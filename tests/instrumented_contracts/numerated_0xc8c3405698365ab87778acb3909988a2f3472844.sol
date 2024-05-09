1 // File: contracts/WRLD_TOKEN.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 interface IWRLD_TOKEN {
7     function balanceOf(address owner) external view returns(uint256);
8     function transferFrom(address, address, uint256) external;
9     function allowance(address owner, address spender) external view returns(uint256);
10     function approve(address spender, uint256 amount) external returns(bool);
11 }
12 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev These functions deal with verification of Merkle Trees proofs.
21  *
22  * The proofs can be generated using the JavaScript library
23  * https://github.com/miguelmota/merkletreejs[merkletreejs].
24  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
25  *
26  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
27  */
28 library MerkleProof {
29     /**
30      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
31      * defined by `root`. For this, a `proof` must be provided, containing
32      * sibling hashes on the branch from the leaf to the root of the tree. Each
33      * pair of leaves and each pair of pre-images are assumed to be sorted.
34      */
35     function verify(
36         bytes32[] memory proof,
37         bytes32 root,
38         bytes32 leaf
39     ) internal pure returns (bool) {
40         return processProof(proof, leaf) == root;
41     }
42 
43     /**
44      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
45      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
46      * hash matches the root of the tree. When processing the proof, the pairs
47      * of leafs & pre-images are assumed to be sorted.
48      *
49      * _Available since v4.4._
50      */
51     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
52         bytes32 computedHash = leaf;
53         for (uint256 i = 0; i < proof.length; i++) {
54             bytes32 proofElement = proof[i];
55             if (computedHash <= proofElement) {
56                 // Hash(current computed hash + current element of the proof)
57                 computedHash = _efficientHash(computedHash, proofElement);
58             } else {
59                 // Hash(current element of the proof + current computed hash)
60                 computedHash = _efficientHash(proofElement, computedHash);
61             }
62         }
63         return computedHash;
64     }
65 
66     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
67         assembly {
68             mstore(0x00, a)
69             mstore(0x20, b)
70             value := keccak256(0x00, 0x40)
71         }
72     }
73 }
74 
75 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Contract module that helps prevent reentrant calls to a function.
84  *
85  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
86  * available, which can be applied to functions to make sure there are no nested
87  * (reentrant) calls to them.
88  *
89  * Note that because there is a single `nonReentrant` guard, functions marked as
90  * `nonReentrant` may not call one another. This can be worked around by making
91  * those functions `private`, and then adding `external` `nonReentrant` entry
92  * points to them.
93  *
94  * TIP: If you would like to learn more about reentrancy and alternative ways
95  * to protect against it, check out our blog post
96  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
97  */
98 abstract contract ReentrancyGuard {
99     // Booleans are more expensive than uint256 or any type that takes up a full
100     // word because each write operation emits an extra SLOAD to first read the
101     // slot's contents, replace the bits taken up by the boolean, and then write
102     // back. This is the compiler's defense against contract upgrades and
103     // pointer aliasing, and it cannot be disabled.
104 
105     // The values being non-zero value makes deployment a bit more expensive,
106     // but in exchange the refund on every call to nonReentrant will be lower in
107     // amount. Since refunds are capped to a percentage of the total
108     // transaction's gas, it is best to keep them low in cases like this one, to
109     // increase the likelihood of the full refund coming into effect.
110     uint256 private constant _NOT_ENTERED = 1;
111     uint256 private constant _ENTERED = 2;
112 
113     uint256 private _status;
114 
115     constructor() {
116         _status = _NOT_ENTERED;
117     }
118 
119     /**
120      * @dev Prevents a contract from calling itself, directly or indirectly.
121      * Calling a `nonReentrant` function from another `nonReentrant`
122      * function is not supported. It is possible to prevent this from happening
123      * by making the `nonReentrant` function external, and making it call a
124      * `private` function that does the actual work.
125      */
126     modifier nonReentrant() {
127         // On the first call to nonReentrant, _notEntered will be true
128         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
129 
130         // Any calls to nonReentrant after this point will fail
131         _status = _ENTERED;
132 
133         _;
134 
135         // By storing the original value once again, a refund is triggered (see
136         // https://eips.ethereum.org/EIPS/eip-2200)
137         _status = _NOT_ENTERED;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Strings.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 /**
149  * @dev String operations.
150  */
151 library Strings {
152     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
153 
154     /**
155      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
156      */
157     function toString(uint256 value) internal pure returns (string memory) {
158         // Inspired by OraclizeAPI's implementation - MIT licence
159         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
160 
161         if (value == 0) {
162             return "0";
163         }
164         uint256 temp = value;
165         uint256 digits;
166         while (temp != 0) {
167             digits++;
168             temp /= 10;
169         }
170         bytes memory buffer = new bytes(digits);
171         while (value != 0) {
172             digits -= 1;
173             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
174             value /= 10;
175         }
176         return string(buffer);
177     }
178 
179     /**
180      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
181      */
182     function toHexString(uint256 value) internal pure returns (string memory) {
183         if (value == 0) {
184             return "0x00";
185         }
186         uint256 temp = value;
187         uint256 length = 0;
188         while (temp != 0) {
189             length++;
190             temp >>= 8;
191         }
192         return toHexString(value, length);
193     }
194 
195     /**
196      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
197      */
198     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
199         bytes memory buffer = new bytes(2 * length + 2);
200         buffer[0] = "0";
201         buffer[1] = "x";
202         for (uint256 i = 2 * length + 1; i > 1; --i) {
203             buffer[i] = _HEX_SYMBOLS[value & 0xf];
204             value >>= 4;
205         }
206         require(value == 0, "Strings: hex length insufficient");
207         return string(buffer);
208     }
209 }
210 
211 // File: @openzeppelin/contracts/utils/Context.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes calldata) {
234         return msg.data;
235     }
236 }
237 
238 // File: @openzeppelin/contracts/access/Ownable.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 
246 /**
247  * @dev Contract module which provides a basic access control mechanism, where
248  * there is an account (an owner) that can be granted exclusive access to
249  * specific functions.
250  *
251  * By default, the owner account will be the one that deploys the contract. This
252  * can later be changed with {transferOwnership}.
253  *
254  * This module is used through inheritance. It will make available the modifier
255  * `onlyOwner`, which can be applied to your functions to restrict their use to
256  * the owner.
257  */
258 abstract contract Ownable is Context {
259     address private _owner;
260 
261     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
262 
263     /**
264      * @dev Initializes the contract setting the deployer as the initial owner.
265      */
266     constructor() {
267         _transferOwnership(_msgSender());
268     }
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view virtual returns (address) {
274         return _owner;
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         require(owner() == _msgSender(), "Ownable: caller is not the owner");
282         _;
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions anymore. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public virtual onlyOwner {
293         _transferOwnership(address(0));
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Can only be called by the current owner.
299      */
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(newOwner != address(0), "Ownable: new owner is the zero address");
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Internal function without access restriction.
308      */
309     function _transferOwnership(address newOwner) internal virtual {
310         address oldOwner = _owner;
311         _owner = newOwner;
312         emit OwnershipTransferred(oldOwner, newOwner);
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/Address.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
320 
321 pragma solidity ^0.8.1;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      *
344      * [IMPORTANT]
345      * ====
346      * You shouldn't rely on `isContract` to protect against flash loan attacks!
347      *
348      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
349      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
350      * constructor.
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // This method relies on extcodesize/address.code.length, which returns 0
355         // for contracts in construction, since the code is only stored at the end
356         // of the constructor execution.
357 
358         return account.code.length > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         (bool success, ) = recipient.call{value: amount}("");
381         require(success, "Address: unable to send value, recipient may have reverted");
382     }
383 
384     /**
385      * @dev Performs a Solidity function call using a low level `call`. A
386      * plain `call` is an unsafe replacement for a function call: use this
387      * function instead.
388      *
389      * If `target` reverts with a revert reason, it is bubbled up by this
390      * function (like regular Solidity function calls).
391      *
392      * Returns the raw returned data. To convert to the expected return value,
393      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
394      *
395      * Requirements:
396      *
397      * - `target` must be a contract.
398      * - calling `target` with `data` must not revert.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionCall(target, data, "Address: low-level call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
408      * `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, 0, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but also transferring `value` wei to `target`.
423      *
424      * Requirements:
425      *
426      * - the calling contract must have an ETH balance of at least `value`.
427      * - the called Solidity function must be `payable`.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
441      * with `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         require(isContract(target), "Address: call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.call{value: value}(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
465         return functionStaticCall(target, data, "Address: low-level static call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal view returns (bytes memory) {
479         require(isContract(target), "Address: static call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(isContract(target), "Address: delegate call to non-contract");
507 
508         (bool success, bytes memory returndata) = target.delegatecall(data);
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
514      * revert reason using the provided one.
515      *
516      * _Available since v4.3._
517      */
518     function verifyCallResult(
519         bool success,
520         bytes memory returndata,
521         string memory errorMessage
522     ) internal pure returns (bytes memory) {
523         if (success) {
524             return returndata;
525         } else {
526             // Look for revert reason and bubble it up if present
527             if (returndata.length > 0) {
528                 // The easiest way to bubble the revert reason is using memory via assembly
529 
530                 assembly {
531                     let returndata_size := mload(returndata)
532                     revert(add(32, returndata), returndata_size)
533                 }
534             } else {
535                 revert(errorMessage);
536             }
537         }
538     }
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 /**
549  * @title ERC721 token receiver interface
550  * @dev Interface for any contract that wants to support safeTransfers
551  * from ERC721 asset contracts.
552  */
553 interface IERC721Receiver {
554     /**
555      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
556      * by `operator` from `from`, this function is called.
557      *
558      * It must return its Solidity selector to confirm the token transfer.
559      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
560      *
561      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
562      */
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 tokenId,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 /**
579  * @dev Interface of the ERC165 standard, as defined in the
580  * https://eips.ethereum.org/EIPS/eip-165[EIP].
581  *
582  * Implementers can declare support of contract interfaces, which can then be
583  * queried by others ({ERC165Checker}).
584  *
585  * For an implementation, see {ERC165}.
586  */
587 interface IERC165 {
588     /**
589      * @dev Returns true if this contract implements the interface defined by
590      * `interfaceId`. See the corresponding
591      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
592      * to learn more about how these ids are created.
593      *
594      * This function call must use less than 30 000 gas.
595      */
596     function supportsInterface(bytes4 interfaceId) external view returns (bool);
597 }
598 
599 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
611  * for the additional interface id that will be supported. For example:
612  *
613  * ```solidity
614  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
616  * }
617  * ```
618  *
619  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
620  */
621 abstract contract ERC165 is IERC165 {
622     /**
623      * @dev See {IERC165-supportsInterface}.
624      */
625     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
626         return interfaceId == type(IERC165).interfaceId;
627     }
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @dev Required interface of an ERC721 compliant contract.
640  */
641 interface IERC721 is IERC165 {
642     /**
643      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
644      */
645     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
646 
647     /**
648      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
649      */
650     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
651 
652     /**
653      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
654      */
655     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
656 
657     /**
658      * @dev Returns the number of tokens in ``owner``'s account.
659      */
660     function balanceOf(address owner) external view returns (uint256 balance);
661 
662     /**
663      * @dev Returns the owner of the `tokenId` token.
664      *
665      * Requirements:
666      *
667      * - `tokenId` must exist.
668      */
669     function ownerOf(uint256 tokenId) external view returns (address owner);
670 
671     /**
672      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
673      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) external;
690 
691     /**
692      * @dev Transfers `tokenId` token from `from` to `to`.
693      *
694      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
695      *
696      * Requirements:
697      *
698      * - `from` cannot be the zero address.
699      * - `to` cannot be the zero address.
700      * - `tokenId` token must be owned by `from`.
701      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
702      *
703      * Emits a {Transfer} event.
704      */
705     function transferFrom(
706         address from,
707         address to,
708         uint256 tokenId
709     ) external;
710 
711     /**
712      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
713      * The approval is cleared when the token is transferred.
714      *
715      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
716      *
717      * Requirements:
718      *
719      * - The caller must own the token or be an approved operator.
720      * - `tokenId` must exist.
721      *
722      * Emits an {Approval} event.
723      */
724     function approve(address to, uint256 tokenId) external;
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) external view returns (address operator);
734 
735     /**
736      * @dev Approve or remove `operator` as an operator for the caller.
737      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
738      *
739      * Requirements:
740      *
741      * - The `operator` cannot be the caller.
742      *
743      * Emits an {ApprovalForAll} event.
744      */
745     function setApprovalForAll(address operator, bool _approved) external;
746 
747     /**
748      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
749      *
750      * See {setApprovalForAll}
751      */
752     function isApprovedForAll(address owner, address operator) external view returns (bool);
753 
754     /**
755      * @dev Safely transfers `tokenId` token from `from` to `to`.
756      *
757      * Requirements:
758      *
759      * - `from` cannot be the zero address.
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must exist and be owned by `from`.
762      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
763      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
764      *
765      * Emits a {Transfer} event.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes calldata data
772     ) external;
773 }
774 
775 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
776 
777 
778 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 
783 /**
784  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
785  * @dev See https://eips.ethereum.org/EIPS/eip-721
786  */
787 interface IERC721Metadata is IERC721 {
788     /**
789      * @dev Returns the token collection name.
790      */
791     function name() external view returns (string memory);
792 
793     /**
794      * @dev Returns the token collection symbol.
795      */
796     function symbol() external view returns (string memory);
797 
798     /**
799      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
800      */
801     function tokenURI(uint256 tokenId) external view returns (string memory);
802 }
803 
804 // File: erc721a/contracts/ERC721A.sol
805 
806 
807 // Creator: Chiru Labs
808 
809 pragma solidity ^0.8.4;
810 
811 
812 
813 
814 
815 
816 
817 
818 error ApprovalCallerNotOwnerNorApproved();
819 error ApprovalQueryForNonexistentToken();
820 error ApproveToCaller();
821 error ApprovalToCurrentOwner();
822 error BalanceQueryForZeroAddress();
823 error MintToZeroAddress();
824 error MintZeroQuantity();
825 error OwnerQueryForNonexistentToken();
826 error TransferCallerNotOwnerNorApproved();
827 error TransferFromIncorrectOwner();
828 error TransferToNonERC721ReceiverImplementer();
829 error TransferToZeroAddress();
830 error URIQueryForNonexistentToken();
831 
832 /**
833  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
834  * the Metadata extension. Built to optimize for lower gas during batch mints.
835  *
836  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
837  *
838  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
839  *
840  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
841  */
842 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
843     using Address for address;
844     using Strings for uint256;
845 
846     // Compiler will pack this into a single 256bit word.
847     struct TokenOwnership {
848         // The address of the owner.
849         address addr;
850         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
851         uint64 startTimestamp;
852         // Whether the token has been burned.
853         bool burned;
854     }
855 
856     // Compiler will pack this into a single 256bit word.
857     struct AddressData {
858         // Realistically, 2**64-1 is more than enough.
859         uint64 balance;
860         // Keeps track of mint count with minimal overhead for tokenomics.
861         uint64 numberMinted;
862         // Keeps track of burn count with minimal overhead for tokenomics.
863         uint64 numberBurned;
864         // For miscellaneous variable(s) pertaining to the address
865         // (e.g. number of whitelist mint slots used).
866         // If there are multiple variables, please pack them into a uint64.
867         uint64 aux;
868     }
869 
870     // The tokenId of the next token to be minted.
871     uint256 internal _currentIndex;
872 
873     // The number of tokens burned.
874     uint256 internal _burnCounter;
875 
876     // Token name
877     string private _name;
878 
879     // Token symbol
880     string private _symbol;
881 
882     // Mapping from token ID to ownership details
883     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
884     mapping(uint256 => TokenOwnership) internal _ownerships;
885 
886     // Mapping owner address to address data
887     mapping(address => AddressData) private _addressData;
888 
889     // Mapping from token ID to approved address
890     mapping(uint256 => address) private _tokenApprovals;
891 
892     // Mapping from owner to operator approvals
893     mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895     constructor(string memory name_, string memory symbol_) {
896         _name = name_;
897         _symbol = symbol_;
898         _currentIndex = _startTokenId();
899     }
900 
901     /**
902      * To change the starting tokenId, please override this function.
903      */
904     function _startTokenId() internal view virtual returns (uint256) {
905         return 0;
906     }
907 
908     /**
909      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
910      */
911     function totalSupply() public view returns (uint256) {
912         // Counter underflow is impossible as _burnCounter cannot be incremented
913         // more than _currentIndex - _startTokenId() times
914         unchecked {
915             return _currentIndex - _burnCounter - _startTokenId();
916         }
917     }
918 
919     /**
920      * Returns the total amount of tokens minted in the contract.
921      */
922     function _totalMinted() internal view returns (uint256) {
923         // Counter underflow is impossible as _currentIndex does not decrement,
924         // and it is initialized to _startTokenId()
925         unchecked {
926             return _currentIndex - _startTokenId();
927         }
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
934         return
935             interfaceId == type(IERC721).interfaceId ||
936             interfaceId == type(IERC721Metadata).interfaceId ||
937             super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view override returns (uint256) {
944         if (owner == address(0)) revert BalanceQueryForZeroAddress();
945         return uint256(_addressData[owner].balance);
946     }
947 
948     /**
949      * Returns the number of tokens minted by `owner`.
950      */
951     function _numberMinted(address owner) internal view returns (uint256) {
952         return uint256(_addressData[owner].numberMinted);
953     }
954 
955     /**
956      * Returns the number of tokens burned by or on behalf of `owner`.
957      */
958     function _numberBurned(address owner) internal view returns (uint256) {
959         return uint256(_addressData[owner].numberBurned);
960     }
961 
962     /**
963      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
964      */
965     function _getAux(address owner) internal view returns (uint64) {
966         return _addressData[owner].aux;
967     }
968 
969     /**
970      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
971      * If there are multiple variables, please pack them into a uint64.
972      */
973     function _setAux(address owner, uint64 aux) internal {
974         _addressData[owner].aux = aux;
975     }
976 
977     /**
978      * Gas spent here starts off proportional to the maximum mint batch size.
979      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
980      */
981     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
982         uint256 curr = tokenId;
983 
984         unchecked {
985             if (_startTokenId() <= curr && curr < _currentIndex) {
986                 TokenOwnership memory ownership = _ownerships[curr];
987                 if (!ownership.burned) {
988                     if (ownership.addr != address(0)) {
989                         return ownership;
990                     }
991                     // Invariant:
992                     // There will always be an ownership that has an address and is not burned
993                     // before an ownership that does not have an address and is not burned.
994                     // Hence, curr will not underflow.
995                     while (true) {
996                         curr--;
997                         ownership = _ownerships[curr];
998                         if (ownership.addr != address(0)) {
999                             return ownership;
1000                         }
1001                     }
1002                 }
1003             }
1004         }
1005         revert OwnerQueryForNonexistentToken();
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-ownerOf}.
1010      */
1011     function ownerOf(uint256 tokenId) public view override returns (address) {
1012         return _ownershipOf(tokenId).addr;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-name}.
1017      */
1018     function name() public view virtual override returns (string memory) {
1019         return _name;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-symbol}.
1024      */
1025     function symbol() public view virtual override returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-tokenURI}.
1031      */
1032     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1033         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1034 
1035         string memory baseURI = _baseURI();
1036         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1037     }
1038 
1039     /**
1040      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1041      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1042      * by default, can be overriden in child contracts.
1043      */
1044     function _baseURI() internal view virtual returns (string memory) {
1045         return '';
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-approve}.
1050      */
1051     function approve(address to, uint256 tokenId) public override {
1052         address owner = ERC721A.ownerOf(tokenId);
1053         if (to == owner) revert ApprovalToCurrentOwner();
1054 
1055         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1056             revert ApprovalCallerNotOwnerNorApproved();
1057         }
1058 
1059         _approve(to, tokenId, owner);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-getApproved}.
1064      */
1065     function getApproved(uint256 tokenId) public view override returns (address) {
1066         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1067 
1068         return _tokenApprovals[tokenId];
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-setApprovalForAll}.
1073      */
1074     function setApprovalForAll(address operator, bool approved) public virtual override {
1075         if (operator == _msgSender()) revert ApproveToCaller();
1076 
1077         _operatorApprovals[_msgSender()][operator] = approved;
1078         emit ApprovalForAll(_msgSender(), operator, approved);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-isApprovedForAll}.
1083      */
1084     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1085         return _operatorApprovals[owner][operator];
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-transferFrom}.
1090      */
1091     function transferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         _transfer(from, to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public virtual override {
1107         safeTransferFrom(from, to, tokenId, '');
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId,
1117         bytes memory _data
1118     ) public virtual override {
1119         _transfer(from, to, tokenId);
1120         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1121             revert TransferToNonERC721ReceiverImplementer();
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns whether `tokenId` exists.
1127      *
1128      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1129      *
1130      * Tokens start existing when they are minted (`_mint`),
1131      */
1132     function _exists(uint256 tokenId) internal view returns (bool) {
1133         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1134             !_ownerships[tokenId].burned;
1135     }
1136 
1137     function _safeMint(address to, uint256 quantity) internal {
1138         _safeMint(to, quantity, '');
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _safeMint(
1152         address to,
1153         uint256 quantity,
1154         bytes memory _data
1155     ) internal {
1156         _mint(to, quantity, _data, true);
1157     }
1158 
1159     /**
1160      * @dev Mints `quantity` tokens and transfers them to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `quantity` must be greater than 0.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _mint(
1170         address to,
1171         uint256 quantity,
1172         bytes memory _data,
1173         bool safe
1174     ) internal {
1175         uint256 startTokenId = _currentIndex;
1176         if (to == address(0)) revert MintToZeroAddress();
1177         if (quantity == 0) revert MintZeroQuantity();
1178 
1179         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1180 
1181         // Overflows are incredibly unrealistic.
1182         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1183         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1184         unchecked {
1185             _addressData[to].balance += uint64(quantity);
1186             _addressData[to].numberMinted += uint64(quantity);
1187 
1188             _ownerships[startTokenId].addr = to;
1189             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1190 
1191             uint256 updatedIndex = startTokenId;
1192             uint256 end = updatedIndex + quantity;
1193 
1194             if (safe && to.isContract()) {
1195                 do {
1196                     emit Transfer(address(0), to, updatedIndex);
1197                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1198                         revert TransferToNonERC721ReceiverImplementer();
1199                     }
1200                 } while (updatedIndex != end);
1201                 // Reentrancy protection
1202                 if (_currentIndex != startTokenId) revert();
1203             } else {
1204                 do {
1205                     emit Transfer(address(0), to, updatedIndex++);
1206                 } while (updatedIndex != end);
1207             }
1208             _currentIndex = updatedIndex;
1209         }
1210         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1211     }
1212 
1213     /**
1214      * @dev Transfers `tokenId` from `from` to `to`.
1215      *
1216      * Requirements:
1217      *
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must be owned by `from`.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _transfer(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) private {
1228         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1229 
1230         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1231 
1232         bool isApprovedOrOwner = (_msgSender() == from ||
1233             isApprovedForAll(from, _msgSender()) ||
1234             getApproved(tokenId) == _msgSender());
1235 
1236         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1237         if (to == address(0)) revert TransferToZeroAddress();
1238 
1239         _beforeTokenTransfers(from, to, tokenId, 1);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId, from);
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             _addressData[from].balance -= 1;
1249             _addressData[to].balance += 1;
1250 
1251             TokenOwnership storage currSlot = _ownerships[tokenId];
1252             currSlot.addr = to;
1253             currSlot.startTimestamp = uint64(block.timestamp);
1254 
1255             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1256             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1257             uint256 nextTokenId = tokenId + 1;
1258             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1259             if (nextSlot.addr == address(0)) {
1260                 // This will suffice for checking _exists(nextTokenId),
1261                 // as a burned slot cannot contain the zero address.
1262                 if (nextTokenId != _currentIndex) {
1263                     nextSlot.addr = from;
1264                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1265                 }
1266             }
1267         }
1268 
1269         emit Transfer(from, to, tokenId);
1270         _afterTokenTransfers(from, to, tokenId, 1);
1271     }
1272 
1273     /**
1274      * @dev This is equivalent to _burn(tokenId, false)
1275      */
1276     function _burn(uint256 tokenId) internal virtual {
1277         _burn(tokenId, false);
1278     }
1279 
1280     /**
1281      * @dev Destroys `tokenId`.
1282      * The approval is cleared when the token is burned.
1283      *
1284      * Requirements:
1285      *
1286      * - `tokenId` must exist.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1291         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1292 
1293         address from = prevOwnership.addr;
1294 
1295         if (approvalCheck) {
1296             bool isApprovedOrOwner = (_msgSender() == from ||
1297                 isApprovedForAll(from, _msgSender()) ||
1298                 getApproved(tokenId) == _msgSender());
1299 
1300             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1301         }
1302 
1303         _beforeTokenTransfers(from, address(0), tokenId, 1);
1304 
1305         // Clear approvals from the previous owner
1306         _approve(address(0), tokenId, from);
1307 
1308         // Underflow of the sender's balance is impossible because we check for
1309         // ownership above and the recipient's balance can't realistically overflow.
1310         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1311         unchecked {
1312             AddressData storage addressData = _addressData[from];
1313             addressData.balance -= 1;
1314             addressData.numberBurned += 1;
1315 
1316             // Keep track of who burned the token, and the timestamp of burning.
1317             TokenOwnership storage currSlot = _ownerships[tokenId];
1318             currSlot.addr = from;
1319             currSlot.startTimestamp = uint64(block.timestamp);
1320             currSlot.burned = true;
1321 
1322             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1323             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1324             uint256 nextTokenId = tokenId + 1;
1325             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1326             if (nextSlot.addr == address(0)) {
1327                 // This will suffice for checking _exists(nextTokenId),
1328                 // as a burned slot cannot contain the zero address.
1329                 if (nextTokenId != _currentIndex) {
1330                     nextSlot.addr = from;
1331                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1332                 }
1333             }
1334         }
1335 
1336         emit Transfer(from, address(0), tokenId);
1337         _afterTokenTransfers(from, address(0), tokenId, 1);
1338 
1339         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1340         unchecked {
1341             _burnCounter++;
1342         }
1343     }
1344 
1345     /**
1346      * @dev Approve `to` to operate on `tokenId`
1347      *
1348      * Emits a {Approval} event.
1349      */
1350     function _approve(
1351         address to,
1352         uint256 tokenId,
1353         address owner
1354     ) private {
1355         _tokenApprovals[tokenId] = to;
1356         emit Approval(owner, to, tokenId);
1357     }
1358 
1359     /**
1360      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkContractOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1375             return retval == IERC721Receiver(to).onERC721Received.selector;
1376         } catch (bytes memory reason) {
1377             if (reason.length == 0) {
1378                 revert TransferToNonERC721ReceiverImplementer();
1379             } else {
1380                 assembly {
1381                     revert(add(32, reason), mload(reason))
1382                 }
1383             }
1384         }
1385     }
1386 
1387     /**
1388      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1389      * And also called before burning one token.
1390      *
1391      * startTokenId - the first token id to be transferred
1392      * quantity - the amount to be transferred
1393      *
1394      * Calling conditions:
1395      *
1396      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1397      * transferred to `to`.
1398      * - When `from` is zero, `tokenId` will be minted for `to`.
1399      * - When `to` is zero, `tokenId` will be burned by `from`.
1400      * - `from` and `to` are never both zero.
1401      */
1402     function _beforeTokenTransfers(
1403         address from,
1404         address to,
1405         uint256 startTokenId,
1406         uint256 quantity
1407     ) internal virtual {}
1408 
1409     /**
1410      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1411      * minting.
1412      * And also called after one token has been burned.
1413      *
1414      * startTokenId - the first token id to be transferred
1415      * quantity - the amount to be transferred
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` has been minted for `to`.
1422      * - When `to` is zero, `tokenId` has been burned by `from`.
1423      * - `from` and `to` are never both zero.
1424      */
1425     function _afterTokenTransfers(
1426         address from,
1427         address to,
1428         uint256 startTokenId,
1429         uint256 quantity
1430     ) internal virtual {}
1431 }
1432 
1433 // File: contracts/CryptidClan.sol
1434 
1435 
1436 
1437 //Developer : FazelPejmanfar
1438 
1439 
1440 
1441 pragma solidity >=0.7.0 <0.9.0;
1442 
1443 
1444 
1445 
1446 
1447 
1448 
1449 contract CryptidClan is ERC721A, Ownable, ReentrancyGuard {
1450   using Strings for uint256;
1451 
1452   string public baseURI;
1453   string public baseExtension = ".json";
1454   string public notRevealedUri;
1455   uint256 public cost = 0.13 ether;
1456   uint256 public wlcost = 0.11 ether;
1457   uint256 public WRLD_PRICE = 1100 ether;
1458   uint256 public WRLD_PRICE_WL = 999 ether;
1459   uint256 public maxSupply = 3933;
1460   uint256 public WlSupply = 3933;
1461   uint256 public MaxperWallet = 10;
1462   uint256 public MaxperWalletWl = 3;
1463   uint256 public MaxperTxWl = 3;
1464   uint256 public maxpertx = 10; // max mint per tx
1465   bool public paused = false;
1466   bool public revealed = false;
1467   bool public preSale = true;
1468   bool public publicSale = false;
1469   bytes32 public merkleRoot = 0x4ca6910f7cb1d9a99d8e5f7a2034efa6bed27cb52fd2eaa24e2c45993bf7bb30;
1470   IWRLD_TOKEN private WTOKEN;
1471 
1472   constructor(
1473     string memory _initBaseURI,
1474     string memory _initNotRevealedUri
1475   ) ERC721A("Cryptid Clan", "CC") {
1476     setBaseURI(_initBaseURI);
1477     setNotRevealedURI(_initNotRevealedUri);
1478     WTOKEN = IWRLD_TOKEN(0xD5d86FC8d5C0Ea1aC1Ac5Dfab6E529c9967a45E9);
1479   }
1480 
1481   // internal
1482   function _baseURI() internal view virtual override returns (string memory) {
1483     return baseURI;
1484   }
1485       function _startTokenId() internal view virtual override returns (uint256) {
1486         return 1;
1487     }
1488 
1489         function initialize() public onlyOwner {
1490         WTOKEN.approve(address(this), 4326300000000000000000000);
1491     }
1492 
1493   // public
1494     function mint(uint256 tokens) public payable nonReentrant {
1495     require(msg.sender == tx.origin);
1496     require(!paused, "CC: oops contract is paused");
1497     require(publicSale, "CC: Sale Hasn't started yet");
1498     uint256 supply = totalSupply();
1499     require(tokens > 0, "CC: need to mint at least 1 NFT");
1500     require(tokens <= maxpertx, "CC: max mint amount per tx exceeded");
1501     require(supply + tokens <= maxSupply, "CC: We Soldout");
1502     require(_numberMinted(_msgSender()) + tokens <= MaxperWallet, "CC: Max NFT Per Wallet exceeded");
1503     require(msg.value >= cost * tokens, "CC: insufficient funds");
1504 
1505       _safeMint(_msgSender(), tokens);
1506     
1507   }
1508 /// @dev presale mint for whitelisted
1509     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
1510     require(msg.sender == tx.origin);
1511     require(!paused, "CC: oops contract is paused");
1512     require(preSale, "CC: Presale Hasn't started yet");
1513     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "CC: You are not Whitelisted");
1514     uint256 supply = totalSupply();
1515     require(_numberMinted(_msgSender()) + tokens <= MaxperWalletWl, "CC: Max NFT Per Wallet exceeded");
1516     require(tokens > 0, "CC: need to mint at least 1 NFT");
1517     require(tokens <= MaxperTxWl, "CC: max mint per Tx exceeded");
1518     require(supply + tokens <= WlSupply, "CC: Whitelist MaxSupply exceeded");
1519     require(msg.value >= wlcost * tokens, "CC: insufficient funds");
1520 
1521       _safeMint(_msgSender(), tokens);
1522     
1523   }
1524 
1525       function mintwrld(uint256 tokens) external nonReentrant {
1526        require(msg.sender == tx.origin);
1527        require(!paused, "CC: oops contract is paused");
1528        require(publicSale, "CC: Sale Hasn't started yet");
1529        uint256 supply = totalSupply();
1530        require(tokens > 0, "CC: need to mint at least 1 NFT");
1531        require(tokens <= maxpertx, "CC: max mint amount per tx exceeded");
1532        require(supply + tokens <= maxSupply, "CC: We Soldout");
1533        require(_numberMinted(_msgSender()) + tokens <= MaxperWallet, "CC: Max NFT Per Wallet exceeded");
1534        require(WRLD_PRICE * tokens <= WTOKEN.balanceOf(msg.sender), "Low WRLD");
1535        require(WRLD_PRICE * tokens <= WTOKEN.allowance(msg.sender, address(this)), "Low WRLD");
1536 
1537         WTOKEN.transferFrom(msg.sender, address(this), WRLD_PRICE * tokens);
1538 
1539         _safeMint(msg.sender, tokens);
1540     }
1541 
1542         function presalemintwrld(uint256 tokens, bytes32[] calldata merkleProof) external nonReentrant {
1543         require(msg.sender == tx.origin);
1544         require(!paused, "CC: oops contract is paused");
1545         require(preSale, "CC: Presale Hasn't started yet");
1546         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "CC: You are not Whitelisted");
1547         uint256 supply = totalSupply();
1548         require(_numberMinted(_msgSender()) + tokens <= MaxperWalletWl, "CC: Max NFT Per Wallet exceeded");
1549         require(tokens > 0, "CC: need to mint at least 1 NFT");
1550         require(tokens <= MaxperTxWl, "CC: max mint per Tx exceeded");
1551         require(supply + tokens <= WlSupply, "CC: Whitelist MaxSupply exceeded");
1552         require(WRLD_PRICE_WL * tokens <= WTOKEN.balanceOf(msg.sender), "Low WRLD");
1553         require(WRLD_PRICE_WL * tokens <= WTOKEN.allowance(msg.sender, address(this)), "Low WRLD");
1554 
1555         WTOKEN.transferFrom(msg.sender, address(this), WRLD_PRICE_WL * tokens);
1556 
1557       _safeMint(_msgSender(), tokens);
1558     
1559   }
1560 
1561 
1562 
1563 
1564   /// @dev use giveaway or vualt
1565      function gift(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1566     require(_mintAmount > 0, "need to mint at least 1 NFT");
1567     uint256 supply = totalSupply();
1568     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1569 
1570       _safeMint(destination, _mintAmount);
1571     
1572   }
1573 
1574   
1575 
1576 
1577   function tokenURI(uint256 tokenId)
1578     public
1579     view
1580     virtual
1581     override
1582     returns (string memory)
1583   {
1584     require(
1585       _exists(tokenId),
1586       "ERC721AMetadata: URI query for nonexistent token"
1587     );
1588     
1589     if(revealed == false) {
1590         return notRevealedUri;
1591     }
1592 
1593     string memory currentBaseURI = _baseURI();
1594     return bytes(currentBaseURI).length > 0
1595         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1596         : "";
1597   }
1598 
1599     function numberMinted(address owner) public view returns (uint256) {
1600     return _numberMinted(owner);
1601   }
1602 
1603   //only owner
1604   function reveal(bool _state) public onlyOwner {
1605       revealed = _state;
1606   }
1607 
1608   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1609         merkleRoot = _merkleRoot;
1610     }
1611   
1612   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1613     MaxperWallet = _limit;
1614   }
1615 
1616     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1617     MaxperWalletWl = _limit;
1618   }
1619 
1620   function setmaxpertx(uint256 _maxpertx) public onlyOwner {
1621     maxpertx = _maxpertx;
1622   }
1623 
1624     function setWLMaxpertx(uint256 _wlmaxpertx) public onlyOwner {
1625     MaxperTxWl = _wlmaxpertx;
1626   }
1627   
1628   function setCost(uint256 _newCost) public onlyOwner {
1629     cost = _newCost;
1630   }
1631 
1632     function setWlCost(uint256 _newWlCost) public onlyOwner {
1633     wlcost = _newWlCost;
1634   }
1635 
1636     function setWRLDcost(uint256 _newCost) public onlyOwner {
1637     WRLD_PRICE = _newCost;
1638   }
1639 
1640       function setWRLDWLcost(uint256 _newCost) public onlyOwner {
1641     WRLD_PRICE_WL = _newCost;
1642   }
1643 
1644     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1645     maxSupply = _newsupply;
1646   }
1647 
1648     function setwlsupply(uint256 _newsupply) public onlyOwner {
1649     WlSupply = _newsupply;
1650   }
1651 
1652   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1653     baseURI = _newBaseURI;
1654   }
1655 
1656   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1657     baseExtension = _newBaseExtension;
1658   }
1659   
1660   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1661     notRevealedUri = _notRevealedURI;
1662   }
1663 
1664   function pause(bool _state) public onlyOwner {
1665     paused = _state;
1666   }
1667 
1668     function togglepreSale(bool _state) external onlyOwner {
1669         preSale = _state;
1670     }
1671 
1672     function togglepublicSale(bool _state) external onlyOwner {
1673         publicSale = _state;
1674     }
1675   
1676  
1677   function withdraw() public payable onlyOwner nonReentrant {
1678     (bool success, ) = payable(0x7eC6D99967FD5dE3ad28507b6B52C0A6527c6cB3).call{value: address(this).balance}("");
1679     require(success);
1680     WTOKEN.transferFrom(address(this), (0x7eC6D99967FD5dE3ad28507b6B52C0A6527c6cB3), WTOKEN.balanceOf(address(this)));
1681   }
1682 }