1 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 abstract contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor() {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and making it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Counters.sol
65 
66 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @title Counters
72  * @author Matt Condon (@shrugs)
73  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
74  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
75  *
76  * Include with `using Counters for Counters.Counter;`
77  */
78 library Counters {
79     struct Counter {
80         // This variable should never be directly accessed by users of the library: interactions must be restricted to
81         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
82         // this feature: see https://github.com/ethereum/solidity/issues/4637
83         uint256 _value; // default: 0
84     }
85 
86     function current(Counter storage counter) internal view returns (uint256) {
87         return counter._value;
88     }
89 
90     function increment(Counter storage counter) internal {
91         unchecked {
92             counter._value += 1;
93         }
94     }
95 
96     function decrement(Counter storage counter) internal {
97         uint256 value = counter._value;
98         require(value > 0, "Counter: decrement overflow");
99         unchecked {
100             counter._value = value - 1;
101         }
102     }
103 
104     function reset(Counter storage counter) internal {
105         counter._value = 0;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
110 
111 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev These functions deal with verification of Merkle Trees proofs.
117  *
118  * The proofs can be generated using the JavaScript library
119  * https://github.com/miguelmota/merkletreejs[merkletreejs].
120  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
121  *
122  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
123  */
124 library MerkleProof {
125     /**
126      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
127      * defined by `root`. For this, a `proof` must be provided, containing
128      * sibling hashes on the branch from the leaf to the root of the tree. Each
129      * pair of leaves and each pair of pre-images are assumed to be sorted.
130      */
131     function verify(
132         bytes32[] memory proof,
133         bytes32 root,
134         bytes32 leaf
135     ) internal pure returns (bool) {
136         return processProof(proof, leaf) == root;
137     }
138 
139     /**
140      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
141      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
142      * hash matches the root of the tree. When processing the proof, the pairs
143      * of leafs & pre-images are assumed to be sorted.
144      *
145      * _Available since v4.4._
146      */
147     function processProof(bytes32[] memory proof, bytes32 leaf)
148         internal
149         pure
150         returns (bytes32)
151     {
152         bytes32 computedHash = leaf;
153         for (uint256 i = 0; i < proof.length; i++) {
154             bytes32 proofElement = proof[i];
155             if (computedHash <= proofElement) {
156                 // Hash(current computed hash + current element of the proof)
157                 computedHash = _efficientHash(computedHash, proofElement);
158             } else {
159                 // Hash(current element of the proof + current computed hash)
160                 computedHash = _efficientHash(proofElement, computedHash);
161             }
162         }
163         return computedHash;
164     }
165 
166     function _efficientHash(bytes32 a, bytes32 b)
167         private
168         pure
169         returns (bytes32 value)
170     {
171         assembly {
172             mstore(0x00, a)
173             mstore(0x20, b)
174             value := keccak256(0x00, 0x40)
175         }
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Strings.sol
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev String operations.
187  */
188 library Strings {
189     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
193      */
194     function toString(uint256 value) internal pure returns (string memory) {
195         // Inspired by OraclizeAPI's implementation - MIT licence
196         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
197 
198         if (value == 0) {
199             return "0";
200         }
201         uint256 temp = value;
202         uint256 digits;
203         while (temp != 0) {
204             digits++;
205             temp /= 10;
206         }
207         bytes memory buffer = new bytes(digits);
208         while (value != 0) {
209             digits -= 1;
210             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
211             value /= 10;
212         }
213         return string(buffer);
214     }
215 
216     /**
217      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
218      */
219     function toHexString(uint256 value) internal pure returns (string memory) {
220         if (value == 0) {
221             return "0x00";
222         }
223         uint256 temp = value;
224         uint256 length = 0;
225         while (temp != 0) {
226             length++;
227             temp >>= 8;
228         }
229         return toHexString(value, length);
230     }
231 
232     /**
233      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
234      */
235     function toHexString(uint256 value, uint256 length)
236         internal
237         pure
238         returns (string memory)
239     {
240         bytes memory buffer = new bytes(2 * length + 2);
241         buffer[0] = "0";
242         buffer[1] = "x";
243         for (uint256 i = 2 * length + 1; i > 1; --i) {
244             buffer[i] = _HEX_SYMBOLS[value & 0xf];
245             value >>= 4;
246         }
247         require(value == 0, "Strings: hex length insufficient");
248         return string(buffer);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/Context.sol
253 
254 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Provides information about the current execution context, including the
260  * sender of the transaction and its data. While these are generally available
261  * via msg.sender and msg.data, they should not be accessed in such a direct
262  * manner, since when dealing with meta-transactions the account sending and
263  * paying for execution may not be the actual sender (as far as an application
264  * is concerned).
265  *
266  * This contract is only required for intermediate, library-like contracts.
267  */
268 abstract contract Context {
269     function _msgSender() internal view virtual returns (address) {
270         return msg.sender;
271     }
272 
273     function _msgData() internal view virtual returns (bytes calldata) {
274         return msg.data;
275     }
276 }
277 
278 // File: @openzeppelin/contracts/access/Ownable.sol
279 
280 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Contract module which provides a basic access control mechanism, where
286  * there is an account (an owner) that can be granted exclusive access to
287  * specific functions.
288  *
289  * By default, the owner account will be the one that deploys the contract. This
290  * can later be changed with {transferOwnership}.
291  *
292  * This module is used through inheritance. It will make available the modifier
293  * `onlyOwner`, which can be applied to your functions to restrict their use to
294  * the owner.
295  */
296 abstract contract Ownable is Context {
297     address private _owner;
298 
299     event OwnershipTransferred(
300         address indexed previousOwner,
301         address indexed newOwner
302     );
303 
304     /**
305      * @dev Initializes the contract setting the deployer as the initial owner.
306      */
307     constructor() {
308         _transferOwnership(_msgSender());
309     }
310 
311     /**
312      * @dev Returns the address of the current owner.
313      */
314     function owner() public view virtual returns (address) {
315         return _owner;
316     }
317 
318     /**
319      * @dev Throws if called by any account other than the owner.
320      */
321     modifier onlyOwner() {
322         require(owner() == _msgSender(), "Ownable: caller is not the owner");
323         _;
324     }
325 
326     /**
327      * @dev Leaves the contract without owner. It will not be possible to call
328      * `onlyOwner` functions anymore. Can only be called by the current owner.
329      *
330      * NOTE: Renouncing ownership will leave the contract without an owner,
331      * thereby removing any functionality that is only available to the owner.
332      */
333     function renounceOwnership() public virtual onlyOwner {
334         _transferOwnership(address(0));
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public virtual onlyOwner {
342         require(
343             newOwner != address(0),
344             "Ownable: new owner is the zero address"
345         );
346         _transferOwnership(newOwner);
347     }
348 
349     /**
350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
351      * Internal function without access restriction.
352      */
353     function _transferOwnership(address newOwner) internal virtual {
354         address oldOwner = _owner;
355         _owner = newOwner;
356         emit OwnershipTransferred(oldOwner, newOwner);
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Address.sol
361 
362 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
363 
364 pragma solidity ^0.8.1;
365 
366 /**
367  * @dev Collection of functions related to the address type
368  */
369 library Address {
370     /**
371      * @dev Returns true if `account` is a contract.
372      *
373      * [IMPORTANT]
374      * ====
375      * It is unsafe to assume that an address for which this function returns
376      * false is an externally-owned account (EOA) and not a contract.
377      *
378      * Among others, `isContract` will return false for the following
379      * types of addresses:
380      *
381      *  - an externally-owned account
382      *  - a contract in construction
383      *  - an address where a contract will be created
384      *  - an address where a contract lived, but was destroyed
385      * ====
386      *
387      * [IMPORTANT]
388      * ====
389      * You shouldn't rely on `isContract` to protect against flash loan attacks!
390      *
391      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
392      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
393      * constructor.
394      * ====
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies on extcodesize/address.code.length, which returns 0
398         // for contracts in construction, since the code is only stored at the end
399         // of the constructor execution.
400 
401         return account.code.length > 0;
402     }
403 
404     /**
405      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
406      * `recipient`, forwarding all available gas and reverting on errors.
407      *
408      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
409      * of certain opcodes, possibly making contracts go over the 2300 gas limit
410      * imposed by `transfer`, making them unable to receive funds via
411      * `transfer`. {sendValue} removes this limitation.
412      *
413      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
414      *
415      * IMPORTANT: because control is transferred to `recipient`, care must be
416      * taken to not create reentrancy vulnerabilities. Consider using
417      * {ReentrancyGuard} or the
418      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(
422             address(this).balance >= amount,
423             "Address: insufficient balance"
424         );
425 
426         (bool success, ) = recipient.call{value: amount}("");
427         require(
428             success,
429             "Address: unable to send value, recipient may have reverted"
430         );
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data)
452         internal
453         returns (bytes memory)
454     {
455         return functionCall(target, data, "Address: low-level call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
460      * `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value
487     ) internal returns (bytes memory) {
488         return
489             functionCallWithValue(
490                 target,
491                 data,
492                 value,
493                 "Address: low-level call with value failed"
494             );
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
499      * with `errorMessage` as a fallback revert reason when `target` reverts.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(
510             address(this).balance >= value,
511             "Address: insufficient balance for call"
512         );
513         require(isContract(target), "Address: call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.call{value: value}(
516             data
517         );
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data)
528         internal
529         view
530         returns (bytes memory)
531     {
532         return
533             functionStaticCall(
534                 target,
535                 data,
536                 "Address: low-level static call failed"
537             );
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data)
564         internal
565         returns (bytes memory)
566     {
567         return
568             functionDelegateCall(
569                 target,
570                 data,
571                 "Address: low-level delegate call failed"
572             );
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
622 
623 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @title ERC721 token receiver interface
629  * @dev Interface for any contract that wants to support safeTransfers
630  * from ERC721 asset contracts.
631  */
632 interface IERC721Receiver {
633     /**
634      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
635      * by `operator` from `from`, this function is called.
636      *
637      * It must return its Solidity selector to confirm the token transfer.
638      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
639      *
640      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
641      */
642     function onERC721Received(
643         address operator,
644         address from,
645         uint256 tokenId,
646         bytes calldata data
647     ) external returns (bytes4);
648 }
649 
650 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Interface of the ERC165 standard, as defined in the
658  * https://eips.ethereum.org/EIPS/eip-165[EIP].
659  *
660  * Implementers can declare support of contract interfaces, which can then be
661  * queried by others ({ERC165Checker}).
662  *
663  * For an implementation, see {ERC165}.
664  */
665 interface IERC165 {
666     /**
667      * @dev Returns true if this contract implements the interface defined by
668      * `interfaceId`. See the corresponding
669      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
670      * to learn more about how these ids are created.
671      *
672      * This function call must use less than 30 000 gas.
673      */
674     function supportsInterface(bytes4 interfaceId) external view returns (bool);
675 }
676 
677 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Implementation of the {IERC165} interface.
685  *
686  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
687  * for the additional interface id that will be supported. For example:
688  *
689  * ```solidity
690  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
692  * }
693  * ```
694  *
695  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
696  */
697 abstract contract ERC165 is IERC165 {
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId)
702         public
703         view
704         virtual
705         override
706         returns (bool)
707     {
708         return interfaceId == type(IERC165).interfaceId;
709     }
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
713 
714 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 /**
719  * @dev Required interface of an ERC721 compliant contract.
720  */
721 interface IERC721 is IERC165 {
722     /**
723      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
724      */
725     event Transfer(
726         address indexed from,
727         address indexed to,
728         uint256 indexed tokenId
729     );
730 
731     /**
732      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
733      */
734     event Approval(
735         address indexed owner,
736         address indexed approved,
737         uint256 indexed tokenId
738     );
739 
740     /**
741      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
742      */
743     event ApprovalForAll(
744         address indexed owner,
745         address indexed operator,
746         bool approved
747     );
748 
749     /**
750      * @dev Returns the number of tokens in ``owner``'s account.
751      */
752     function balanceOf(address owner) external view returns (uint256 balance);
753 
754     /**
755      * @dev Returns the owner of the `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function ownerOf(uint256 tokenId) external view returns (address owner);
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
765      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
773      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
774      *
775      * Emits a {Transfer} event.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) external;
782 
783     /**
784      * @dev Transfers `tokenId` token from `from` to `to`.
785      *
786      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must be owned by `from`.
793      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
794      *
795      * Emits a {Transfer} event.
796      */
797     function transferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) external;
802 
803     /**
804      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
805      * The approval is cleared when the token is transferred.
806      *
807      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
808      *
809      * Requirements:
810      *
811      * - The caller must own the token or be an approved operator.
812      * - `tokenId` must exist.
813      *
814      * Emits an {Approval} event.
815      */
816     function approve(address to, uint256 tokenId) external;
817 
818     /**
819      * @dev Returns the account approved for `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function getApproved(uint256 tokenId)
826         external
827         view
828         returns (address operator);
829 
830     /**
831      * @dev Approve or remove `operator` as an operator for the caller.
832      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
833      *
834      * Requirements:
835      *
836      * - The `operator` cannot be the caller.
837      *
838      * Emits an {ApprovalForAll} event.
839      */
840     function setApprovalForAll(address operator, bool _approved) external;
841 
842     /**
843      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
844      *
845      * See {setApprovalForAll}
846      */
847     function isApprovedForAll(address owner, address operator)
848         external
849         view
850         returns (bool);
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`.
854      *
855      * Requirements:
856      *
857      * - `from` cannot be the zero address.
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must exist and be owned by `from`.
860      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
861      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
862      *
863      * Emits a {Transfer} event.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes calldata data
870     ) external;
871 }
872 
873 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
874 
875 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
876 
877 pragma solidity ^0.8.0;
878 
879 /**
880  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
881  * @dev See https://eips.ethereum.org/EIPS/eip-721
882  */
883 interface IERC721Enumerable is IERC721 {
884     /**
885      * @dev Returns the total amount of tokens stored by the contract.
886      */
887     function totalSupply() external view returns (uint256);
888 
889     /**
890      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
891      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
892      */
893     function tokenOfOwnerByIndex(address owner, uint256 index)
894         external
895         view
896         returns (uint256);
897 
898     /**
899      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
900      * Use along with {totalSupply} to enumerate all tokens.
901      */
902     function tokenByIndex(uint256 index) external view returns (uint256);
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
906 
907 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 /**
912  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
913  * @dev See https://eips.ethereum.org/EIPS/eip-721
914  */
915 interface IERC721Metadata is IERC721 {
916     /**
917      * @dev Returns the token collection name.
918      */
919     function name() external view returns (string memory);
920 
921     /**
922      * @dev Returns the token collection symbol.
923      */
924     function symbol() external view returns (string memory);
925 
926     /**
927      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
928      */
929     function tokenURI(uint256 tokenId) external view returns (string memory);
930 }
931 
932 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
933 
934 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
940  * the Metadata extension, but not including the Enumerable extension, which is available separately as
941  * {ERC721Enumerable}.
942  */
943 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
944     using Address for address;
945     using Strings for uint256;
946 
947     // Token name
948     string private _name;
949 
950     // Token symbol
951     string private _symbol;
952 
953     // Mapping from token ID to owner address
954     mapping(uint256 => address) private _owners;
955 
956     // Mapping owner address to token count
957     mapping(address => uint256) private _balances;
958 
959     // Mapping from token ID to approved address
960     mapping(uint256 => address) private _tokenApprovals;
961 
962     // Mapping from owner to operator approvals
963     mapping(address => mapping(address => bool)) private _operatorApprovals;
964 
965     /**
966      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
967      */
968     constructor(string memory name_, string memory symbol_) {
969         _name = name_;
970         _symbol = symbol_;
971     }
972 
973     /**
974      * @dev See {IERC165-supportsInterface}.
975      */
976     function supportsInterface(bytes4 interfaceId)
977         public
978         view
979         virtual
980         override(ERC165, IERC165)
981         returns (bool)
982     {
983         return
984             interfaceId == type(IERC721).interfaceId ||
985             interfaceId == type(IERC721Metadata).interfaceId ||
986             super.supportsInterface(interfaceId);
987     }
988 
989     /**
990      * @dev See {IERC721-balanceOf}.
991      */
992     function balanceOf(address owner)
993         public
994         view
995         virtual
996         override
997         returns (uint256)
998     {
999         require(
1000             owner != address(0),
1001             "ERC721: balance query for the zero address"
1002         );
1003         return _balances[owner];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-ownerOf}.
1008      */
1009     function ownerOf(uint256 tokenId)
1010         public
1011         view
1012         virtual
1013         override
1014         returns (address)
1015     {
1016         address owner = _owners[tokenId];
1017         require(
1018             owner != address(0),
1019             "ERC721: owner query for nonexistent token"
1020         );
1021         return owner;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-name}.
1026      */
1027     function name() public view virtual override returns (string memory) {
1028         return _name;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-symbol}.
1033      */
1034     function symbol() public view virtual override returns (string memory) {
1035         return _symbol;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-tokenURI}.
1040      */
1041     function tokenURI(uint256 tokenId)
1042         public
1043         view
1044         virtual
1045         override
1046         returns (string memory)
1047     {
1048         require(
1049             _exists(tokenId),
1050             "ERC721Metadata: URI query for nonexistent token"
1051         );
1052 
1053         string memory baseURI = _baseURI();
1054         return
1055             bytes(baseURI).length > 0
1056                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1057                 : "";
1058     }
1059 
1060     /**
1061      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063      * by default, can be overriden in child contracts.
1064      */
1065     function _baseURI() internal view virtual returns (string memory) {
1066         return "";
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-approve}.
1071      */
1072     function approve(address to, uint256 tokenId) public virtual override {
1073         address owner = ERC721.ownerOf(tokenId);
1074         require(to != owner, "ERC721: approval to current owner");
1075 
1076         require(
1077             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078             "ERC721: approve caller is not owner nor approved for all"
1079         );
1080 
1081         _approve(to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-getApproved}.
1086      */
1087     function getApproved(uint256 tokenId)
1088         public
1089         view
1090         virtual
1091         override
1092         returns (address)
1093     {
1094         require(
1095             _exists(tokenId),
1096             "ERC721: approved query for nonexistent token"
1097         );
1098 
1099         return _tokenApprovals[tokenId];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-setApprovalForAll}.
1104      */
1105     function setApprovalForAll(address operator, bool approved)
1106         public
1107         virtual
1108         override
1109     {
1110         _setApprovalForAll(_msgSender(), operator, approved);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-isApprovedForAll}.
1115      */
1116     function isApprovedForAll(address owner, address operator)
1117         public
1118         view
1119         virtual
1120         override
1121         returns (bool)
1122     {
1123         return _operatorApprovals[owner][operator];
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-transferFrom}.
1128      */
1129     function transferFrom(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) public virtual override {
1134         //solhint-disable-next-line max-line-length
1135         require(
1136             _isApprovedOrOwner(_msgSender(), tokenId),
1137             "ERC721: transfer caller is not owner nor approved"
1138         );
1139 
1140         _transfer(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) public virtual override {
1151         safeTransferFrom(from, to, tokenId, "");
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-safeTransferFrom}.
1156      */
1157     function safeTransferFrom(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) public virtual override {
1163         require(
1164             _isApprovedOrOwner(_msgSender(), tokenId),
1165             "ERC721: transfer caller is not owner nor approved"
1166         );
1167         _safeTransfer(from, to, tokenId, _data);
1168     }
1169 
1170     /**
1171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1173      *
1174      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1175      *
1176      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1177      * implement alternative mechanisms to perform token transfer, such as signature-based.
1178      *
1179      * Requirements:
1180      *
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      * - `tokenId` token must exist and be owned by `from`.
1184      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _safeTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId,
1192         bytes memory _data
1193     ) internal virtual {
1194         _transfer(from, to, tokenId);
1195         require(
1196             _checkOnERC721Received(from, to, tokenId, _data),
1197             "ERC721: transfer to non ERC721Receiver implementer"
1198         );
1199     }
1200 
1201     /**
1202      * @dev Returns whether `tokenId` exists.
1203      *
1204      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1205      *
1206      * Tokens start existing when they are minted (`_mint`),
1207      * and stop existing when they are burned (`_burn`).
1208      */
1209     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1210         return _owners[tokenId] != address(0);
1211     }
1212 
1213     /**
1214      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1215      *
1216      * Requirements:
1217      *
1218      * - `tokenId` must exist.
1219      */
1220     function _isApprovedOrOwner(address spender, uint256 tokenId)
1221         internal
1222         view
1223         virtual
1224         returns (bool)
1225     {
1226         require(
1227             _exists(tokenId),
1228             "ERC721: operator query for nonexistent token"
1229         );
1230         address owner = ERC721.ownerOf(tokenId);
1231         return (spender == owner ||
1232             getApproved(tokenId) == spender ||
1233             isApprovedForAll(owner, spender));
1234     }
1235 
1236     /**
1237      * @dev Safely mints `tokenId` and transfers it to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must not exist.
1242      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _safeMint(address to, uint256 tokenId) internal virtual {
1247         _safeMint(to, tokenId, "");
1248     }
1249 
1250     /**
1251      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1252      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1253      */
1254     function _safeMint(
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) internal virtual {
1259         _mint(to, tokenId);
1260         require(
1261             _checkOnERC721Received(address(0), to, tokenId, _data),
1262             "ERC721: transfer to non ERC721Receiver implementer"
1263         );
1264     }
1265 
1266     /**
1267      * @dev Mints `tokenId` and transfers it to `to`.
1268      *
1269      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must not exist.
1274      * - `to` cannot be the zero address.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function _mint(address to, uint256 tokenId) internal virtual {
1279         require(to != address(0), "ERC721: mint to the zero address");
1280         require(!_exists(tokenId), "ERC721: token already minted");
1281 
1282         _beforeTokenTransfer(address(0), to, tokenId);
1283 
1284         _balances[to] += 1;
1285         _owners[tokenId] = to;
1286 
1287         emit Transfer(address(0), to, tokenId);
1288 
1289         _afterTokenTransfer(address(0), to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev Destroys `tokenId`.
1294      * The approval is cleared when the token is burned.
1295      *
1296      * Requirements:
1297      *
1298      * - `tokenId` must exist.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         address owner = ERC721.ownerOf(tokenId);
1304 
1305         _beforeTokenTransfer(owner, address(0), tokenId);
1306 
1307         // Clear approvals
1308         _approve(address(0), tokenId);
1309 
1310         _balances[owner] -= 1;
1311         delete _owners[tokenId];
1312 
1313         emit Transfer(owner, address(0), tokenId);
1314 
1315         _afterTokenTransfer(owner, address(0), tokenId);
1316     }
1317 
1318     /**
1319      * @dev Transfers `tokenId` from `from` to `to`.
1320      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1321      *
1322      * Requirements:
1323      *
1324      * - `to` cannot be the zero address.
1325      * - `tokenId` token must be owned by `from`.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _transfer(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) internal virtual {
1334         require(
1335             ERC721.ownerOf(tokenId) == from,
1336             "ERC721: transfer from incorrect owner"
1337         );
1338         require(to != address(0), "ERC721: transfer to the zero address");
1339 
1340         _beforeTokenTransfer(from, to, tokenId);
1341 
1342         // Clear approvals from the previous owner
1343         _approve(address(0), tokenId);
1344 
1345         _balances[from] -= 1;
1346         _balances[to] += 1;
1347         _owners[tokenId] = to;
1348 
1349         emit Transfer(from, to, tokenId);
1350 
1351         _afterTokenTransfer(from, to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev Approve `to` to operate on `tokenId`
1356      *
1357      * Emits a {Approval} event.
1358      */
1359     function _approve(address to, uint256 tokenId) internal virtual {
1360         _tokenApprovals[tokenId] = to;
1361         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev Approve `operator` to operate on all of `owner` tokens
1366      *
1367      * Emits a {ApprovalForAll} event.
1368      */
1369     function _setApprovalForAll(
1370         address owner,
1371         address operator,
1372         bool approved
1373     ) internal virtual {
1374         require(owner != operator, "ERC721: approve to caller");
1375         _operatorApprovals[owner][operator] = approved;
1376         emit ApprovalForAll(owner, operator, approved);
1377     }
1378 
1379     /**
1380      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1381      * The call is not executed if the target address is not a contract.
1382      *
1383      * @param from address representing the previous owner of the given token ID
1384      * @param to target address that will receive the tokens
1385      * @param tokenId uint256 ID of the token to be transferred
1386      * @param _data bytes optional data to send along with the call
1387      * @return bool whether the call correctly returned the expected magic value
1388      */
1389     function _checkOnERC721Received(
1390         address from,
1391         address to,
1392         uint256 tokenId,
1393         bytes memory _data
1394     ) private returns (bool) {
1395         if (to.isContract()) {
1396             try
1397                 IERC721Receiver(to).onERC721Received(
1398                     _msgSender(),
1399                     from,
1400                     tokenId,
1401                     _data
1402                 )
1403             returns (bytes4 retval) {
1404                 return retval == IERC721Receiver.onERC721Received.selector;
1405             } catch (bytes memory reason) {
1406                 if (reason.length == 0) {
1407                     revert(
1408                         "ERC721: transfer to non ERC721Receiver implementer"
1409                     );
1410                 } else {
1411                     assembly {
1412                         revert(add(32, reason), mload(reason))
1413                     }
1414                 }
1415             }
1416         } else {
1417             return true;
1418         }
1419     }
1420 
1421     /**
1422      * @dev Hook that is called before any token transfer. This includes minting
1423      * and burning.
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` will be minted for `to`.
1430      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1431      * - `from` and `to` are never both zero.
1432      *
1433      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1434      */
1435     function _beforeTokenTransfer(
1436         address from,
1437         address to,
1438         uint256 tokenId
1439     ) internal virtual {}
1440 
1441     /**
1442      * @dev Hook that is called after any transfer of tokens. This includes
1443      * minting and burning.
1444      *
1445      * Calling conditions:
1446      *
1447      * - when `from` and `to` are both non-zero.
1448      * - `from` and `to` are never both zero.
1449      *
1450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1451      */
1452     function _afterTokenTransfer(
1453         address from,
1454         address to,
1455         uint256 tokenId
1456     ) internal virtual {}
1457 }
1458 
1459 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1460 
1461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 /**
1466  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1467  * enumerability of all the token ids in the contract as well as all token ids owned by each
1468  * account.
1469  */
1470 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1471     // Mapping from owner to list of owned token IDs
1472     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1473 
1474     // Mapping from token ID to index of the owner tokens list
1475     mapping(uint256 => uint256) private _ownedTokensIndex;
1476 
1477     // Array with all token ids, used for enumeration
1478     uint256[] private _allTokens;
1479 
1480     // Mapping from token id to position in the allTokens array
1481     mapping(uint256 => uint256) private _allTokensIndex;
1482 
1483     /**
1484      * @dev See {IERC165-supportsInterface}.
1485      */
1486     function supportsInterface(bytes4 interfaceId)
1487         public
1488         view
1489         virtual
1490         override(IERC165, ERC721)
1491         returns (bool)
1492     {
1493         return
1494             interfaceId == type(IERC721Enumerable).interfaceId ||
1495             super.supportsInterface(interfaceId);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1500      */
1501     function tokenOfOwnerByIndex(address owner, uint256 index)
1502         public
1503         view
1504         virtual
1505         override
1506         returns (uint256)
1507     {
1508         require(
1509             index < ERC721.balanceOf(owner),
1510             "ERC721Enumerable: owner index out of bounds"
1511         );
1512         return _ownedTokens[owner][index];
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Enumerable-totalSupply}.
1517      */
1518     function totalSupply() public view virtual override returns (uint256) {
1519         return _allTokens.length;
1520     }
1521 
1522     /**
1523      * @dev See {IERC721Enumerable-tokenByIndex}.
1524      */
1525     function tokenByIndex(uint256 index)
1526         public
1527         view
1528         virtual
1529         override
1530         returns (uint256)
1531     {
1532         require(
1533             index < ERC721Enumerable.totalSupply(),
1534             "ERC721Enumerable: global index out of bounds"
1535         );
1536         return _allTokens[index];
1537     }
1538 
1539     /**
1540      * @dev Hook that is called before any token transfer. This includes minting
1541      * and burning.
1542      *
1543      * Calling conditions:
1544      *
1545      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1546      * transferred to `to`.
1547      * - When `from` is zero, `tokenId` will be minted for `to`.
1548      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1549      * - `from` cannot be the zero address.
1550      * - `to` cannot be the zero address.
1551      *
1552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1553      */
1554     function _beforeTokenTransfer(
1555         address from,
1556         address to,
1557         uint256 tokenId
1558     ) internal virtual override {
1559         super._beforeTokenTransfer(from, to, tokenId);
1560 
1561         if (from == address(0)) {
1562             _addTokenToAllTokensEnumeration(tokenId);
1563         } else if (from != to) {
1564             _removeTokenFromOwnerEnumeration(from, tokenId);
1565         }
1566         if (to == address(0)) {
1567             _removeTokenFromAllTokensEnumeration(tokenId);
1568         } else if (to != from) {
1569             _addTokenToOwnerEnumeration(to, tokenId);
1570         }
1571     }
1572 
1573     /**
1574      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1575      * @param to address representing the new owner of the given token ID
1576      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1577      */
1578     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1579         uint256 length = ERC721.balanceOf(to);
1580         _ownedTokens[to][length] = tokenId;
1581         _ownedTokensIndex[tokenId] = length;
1582     }
1583 
1584     /**
1585      * @dev Private function to add a token to this extension's token tracking data structures.
1586      * @param tokenId uint256 ID of the token to be added to the tokens list
1587      */
1588     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1589         _allTokensIndex[tokenId] = _allTokens.length;
1590         _allTokens.push(tokenId);
1591     }
1592 
1593     /**
1594      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1595      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1596      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1597      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1598      * @param from address representing the previous owner of the given token ID
1599      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1600      */
1601     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1602         private
1603     {
1604         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1605         // then delete the last slot (swap and pop).
1606 
1607         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1608         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1609 
1610         // When the token to delete is the last token, the swap operation is unnecessary
1611         if (tokenIndex != lastTokenIndex) {
1612             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1613 
1614             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1615             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1616         }
1617 
1618         // This also deletes the contents at the last position of the array
1619         delete _ownedTokensIndex[tokenId];
1620         delete _ownedTokens[from][lastTokenIndex];
1621     }
1622 
1623     /**
1624      * @dev Private function to remove a token from this extension's token tracking data structures.
1625      * This has O(1) time complexity, but alters the order of the _allTokens array.
1626      * @param tokenId uint256 ID of the token to be removed from the tokens list
1627      */
1628     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1629         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1630         // then delete the last slot (swap and pop).
1631 
1632         uint256 lastTokenIndex = _allTokens.length - 1;
1633         uint256 tokenIndex = _allTokensIndex[tokenId];
1634 
1635         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1636         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1637         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1638         uint256 lastTokenId = _allTokens[lastTokenIndex];
1639 
1640         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1641         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1642 
1643         // This also deletes the contents at the last position of the array
1644         delete _allTokensIndex[tokenId];
1645         _allTokens.pop();
1646     }
1647 }
1648 
1649 //SPDX-License-Identifier: MIT
1650 
1651 pragma solidity ^0.8.0;
1652 
1653 contract Rabbitus is ERC721Enumerable, Ownable, ReentrancyGuard {
1654     using Counters for Counters.Counter;
1655     using Strings for uint256;
1656     using Address for address;
1657 
1658     uint256 public PUBLIC_SUPPLY = 3110;
1659 
1660     uint256 public PRESALE_PRICE = 0.075 ether;
1661     uint256 public PUBLIC_PRICE = 0.09 ether;
1662 
1663     uint256 public PRESALE_MINT_LIMIT = PUBLIC_SUPPLY;
1664     uint256 public PUBLIC_MINT_LIMIT = PUBLIC_SUPPLY;
1665 
1666     bytes32 public m_whitelistRoot;
1667     mapping(address => bool) public m_mapWhitelist;
1668 
1669     uint256 public preSaleActiveDatetime = 1658413800; // (GMT): Thursday, July 21, 2022 2:30:00 PM
1670     uint256 public publicSaleActiveDatetime = 1658586600; // (GMT): Saturday, July 23, 2022 2:30:00 PM
1671 
1672     mapping(address => uint256) public m_mapPresaleMintCount;
1673     mapping(address => uint256) public m_mapPublicMintCount;
1674 
1675     string private _tokenBaseURI = "";
1676 
1677     uint256 internal lastRandom;
1678 
1679     mapping(uint256 => uint256) public indexer;
1680 
1681     constructor() ERC721("OpenSea Shared Storefront", "OPENSTORE") {}
1682 
1683     function setWhiteListRoot(bytes32 root) external onlyOwner {
1684         m_whitelistRoot = root;
1685     }
1686 
1687     function setWhiteList(address[] memory _addressList, bool bEnable) external onlyOwner {
1688         for (uint256 i = 0; i < _addressList.length; i++) {
1689             m_mapWhitelist[_addressList[i]] = bEnable;
1690         }
1691     }
1692 
1693 
1694     function isWhiteListed(bytes32 _leafNode, bytes32[] memory proof) public view returns (bool) {
1695         return MerkleProof.verify(proof, m_whitelistRoot, _leafNode);
1696     }
1697 
1698     function toLeaf(address account, uint256 index, uint256 amount) public pure returns (bytes32) {
1699         return keccak256(abi.encodePacked(index, account, amount));
1700     }
1701 
1702     function setMintPrice(uint256 presaleMintPrice, uint256 publicMintPrice) external onlyOwner {
1703         PRESALE_PRICE = presaleMintPrice;
1704         PUBLIC_PRICE = publicMintPrice;
1705     }
1706 
1707     function setMaxLimit(uint256 publicSupply) external onlyOwner {
1708         PUBLIC_SUPPLY = publicSupply;
1709     }
1710 
1711     function setMintLimit(uint256 presaleMintLimit, uint256 publicMintLimit) external onlyOwner {
1712         PRESALE_MINT_LIMIT = presaleMintLimit;
1713         PUBLIC_MINT_LIMIT = publicMintLimit;
1714     }
1715 
1716     function setBaseURI(string memory baseURI) external onlyOwner {
1717         _tokenBaseURI = baseURI;
1718     }
1719 
1720     function airdrop(address[] memory airdropAddress, uint256 numberOfTokens) external onlyOwner {
1721         require(totalSupply() + airdropAddress.length * numberOfTokens <= PUBLIC_SUPPLY, "Purchase would exceed PUBLIC_SUPPLY");
1722 
1723         for (uint256 k = 0; k < airdropAddress.length; k++) {
1724             _mintRabbitus(airdropAddress[k], numberOfTokens);
1725         }
1726     }
1727 
1728     function setActiveDatetime(uint256 _presaleDatetime, uint256 _publicDatetime) external onlyOwner {
1729         preSaleActiveDatetime = _presaleDatetime;
1730         publicSaleActiveDatetime = _publicDatetime;
1731     }
1732 
1733     function mintPublic(uint256 numberOfTokens) external payable nonReentrant {
1734         require(publicSaleActiveDatetime <= block.timestamp, "sale is not active yet");
1735         require(totalSupply() + numberOfTokens <= PUBLIC_SUPPLY, "Purchase would exceed PUBLIC_SUPPLY");
1736 
1737         require(PUBLIC_PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1738 
1739         m_mapPublicMintCount[msg.sender] = m_mapPublicMintCount[msg.sender] + numberOfTokens;
1740 
1741         require(m_mapPublicMintCount[msg.sender] <= PUBLIC_MINT_LIMIT, "Overflow for PUBLIC_MINT_LIMIT");
1742 
1743         _mintRabbitus(msg.sender, numberOfTokens);
1744     }
1745 
1746     function mintPublicWithCreditCard(address to, uint256 numberOfTokens) external payable nonReentrant {
1747         require(publicSaleActiveDatetime <= block.timestamp, "sale is not active yet");
1748         require(totalSupply() + numberOfTokens <= PUBLIC_SUPPLY, "Purchase would exceed PUBLIC_SUPPLY");
1749 
1750         require(PUBLIC_PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1751 
1752         m_mapPublicMintCount[to] = m_mapPublicMintCount[to] + numberOfTokens;
1753 
1754         require(m_mapPublicMintCount[to] <= PUBLIC_MINT_LIMIT, "Overflow for PUBLIC_MINT_LIMIT");
1755 
1756         _mintRabbitus(to, numberOfTokens);
1757     }
1758 
1759     function mintWhitelist(uint256 numberOfTokens, uint256 index, uint256 amount, bytes32[] calldata proof) external payable nonReentrant {
1760         require(preSaleActiveDatetime <= block.timestamp && publicSaleActiveDatetime >= block.timestamp, " whitelist sale is not active yet");
1761         require(totalSupply() + numberOfTokens <= PUBLIC_SUPPLY, "Purchase would exceed PUBLIC_SUPPLY");
1762         
1763         require(isWhiteListed(toLeaf(msg.sender, index, amount), proof) || m_mapWhitelist[msg.sender], "Invalid proof");
1764 
1765         require(PRESALE_PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
1766 
1767         m_mapPresaleMintCount[msg.sender] = m_mapPresaleMintCount[msg.sender] + numberOfTokens;
1768 
1769         require(m_mapPresaleMintCount[msg.sender] <= PRESALE_MINT_LIMIT, "Overflow for PRESALE_MINT_LIMIT");
1770 
1771         _mintRabbitus(msg.sender, numberOfTokens);
1772     }
1773 
1774     function enoughRandom() internal view returns (uint256 seed) {
1775         seed = uint256(keccak256(abi.encodePacked(block.timestamp + block.difficulty + 
1776                     ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
1777                     block.gaslimit + ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
1778                     block.number)));
1779     }
1780 
1781     function _mintRabbitus(address to, uint256 numberOfMints) internal {
1782         require(msg.sender == tx.origin, "contract not allowed");
1783         lastRandom = enoughRandom();
1784 
1785         uint256 _indexerLength;
1786         unchecked {
1787             _indexerLength = PUBLIC_SUPPLY - totalSupply();
1788         }
1789 
1790         for (uint256 i; i < numberOfMints; ) {
1791             lastRandom >>= i;
1792 
1793             // Find the next available tokenID
1794             //slither-disable-next-line weak-prng
1795             uint256 index = lastRandom % _indexerLength;
1796             uint256 tokenId = indexer[index];
1797 
1798             if (tokenId == 0) {
1799                 tokenId = index;
1800             }
1801 
1802             // Swap the picked tokenId for the last element
1803             unchecked {
1804                 --_indexerLength;
1805             }
1806 
1807             uint256 last = indexer[_indexerLength];
1808             if (last == 0) {
1809                 // this _indexerLength value had not been picked before
1810                 indexer[index] = _indexerLength;
1811             } else {
1812                 // this _indexerLength value had been picked and swapped before
1813                 indexer[index] = last;
1814             }
1815 
1816             // Mint ARN and generate its attributes
1817             _safeMint(to, tokenId + 1);
1818 
1819             unchecked {
1820                 ++i;
1821             }
1822         }
1823     }
1824 
1825     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1826         require(_exists(tokenId), "Token does not exist");
1827         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1828     }
1829 
1830     function withdraw() external onlyOwner nonReentrant {
1831         (bool os, ) = payable(msg.sender).call{
1832             value: address(this).balance
1833         }("");
1834         require(os);
1835     }
1836 }