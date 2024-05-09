1 //  ________                     __        __ 
2 // |        \                   |  \      |  \
3 // | $$$$$$$$________  __    __ | $$   __  \$$
4 // | $$__   |        \|  \  |  \| $$  /  \|  \
5 // | $$  \   \$$$$$$$$| $$  | $$| $$_/  $$| $$
6 // | $$$$$    /    $$ | $$  | $$| $$   $$ | $$
7 // | $$      /  $$$$_ | $$__/ $$| $$$$$$\ | $$
8 // | $$     |  $$    \ \$$    $$| $$  \$$\| $$
9 //  \$$      \$$$$$$$$  \$$$$$$  \$$   \$$ \$$
10 
11 
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
804 // File: Fzuki/ERC721A.sol
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
1133         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1134     }
1135 
1136     function _safeMint(address to, uint256 quantity) internal {
1137         _safeMint(to, quantity, '');
1138     }
1139 
1140     /**
1141      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _safeMint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data
1154     ) internal {
1155         _mint(to, quantity, _data, true);
1156     }
1157 
1158     /**
1159      * @dev Mints `quantity` tokens and transfers them to `to`.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `quantity` must be greater than 0.
1165      *
1166      * Emits a {Transfer} event.
1167      */
1168     function _mint(
1169         address to,
1170         uint256 quantity,
1171         bytes memory _data,
1172         bool safe
1173     ) internal {
1174         uint256 startTokenId = _currentIndex;
1175         if (to == address(0)) revert MintToZeroAddress();
1176         if (quantity == 0) revert MintZeroQuantity();
1177 
1178         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1179 
1180         // Overflows are incredibly unrealistic.
1181         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1182         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1183         unchecked {
1184             _addressData[to].balance += uint64(quantity);
1185             _addressData[to].numberMinted += uint64(quantity);
1186 
1187             _ownerships[startTokenId].addr = to;
1188             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1189 
1190             uint256 updatedIndex = startTokenId;
1191             uint256 end = updatedIndex + quantity;
1192 
1193             if (safe && to.isContract()) {
1194                 do {
1195                     emit Transfer(address(0), to, updatedIndex);
1196                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1197                         revert TransferToNonERC721ReceiverImplementer();
1198                     }
1199                 } while (updatedIndex != end);
1200                 // Reentrancy protection
1201                 if (_currentIndex != startTokenId) revert();
1202             } else {
1203                 do {
1204                     emit Transfer(address(0), to, updatedIndex++);
1205                 } while (updatedIndex != end);
1206             }
1207             _currentIndex = updatedIndex;
1208         }
1209         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1210     }
1211 
1212     /**
1213      * @dev Transfers `tokenId` from `from` to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must be owned by `from`.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _transfer(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) private {
1227         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1228 
1229         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1230 
1231         bool isApprovedOrOwner = (_msgSender() == from ||
1232             isApprovedForAll(from, _msgSender()) ||
1233             getApproved(tokenId) == _msgSender());
1234 
1235         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1236         if (to == address(0)) revert TransferToZeroAddress();
1237 
1238         _beforeTokenTransfers(from, to, tokenId, 1);
1239 
1240         // Clear approvals from the previous owner
1241         _approve(address(0), tokenId, from);
1242 
1243         // Underflow of the sender's balance is impossible because we check for
1244         // ownership above and the recipient's balance can't realistically overflow.
1245         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1246         unchecked {
1247             _addressData[from].balance -= 1;
1248             _addressData[to].balance += 1;
1249 
1250             TokenOwnership storage currSlot = _ownerships[tokenId];
1251             currSlot.addr = to;
1252             currSlot.startTimestamp = uint64(block.timestamp);
1253 
1254             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1255             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1256             uint256 nextTokenId = tokenId + 1;
1257             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1258             if (nextSlot.addr == address(0)) {
1259                 // This will suffice for checking _exists(nextTokenId),
1260                 // as a burned slot cannot contain the zero address.
1261                 if (nextTokenId != _currentIndex) {
1262                     nextSlot.addr = from;
1263                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1264                 }
1265             }
1266         }
1267 
1268         emit Transfer(from, to, tokenId);
1269         _afterTokenTransfers(from, to, tokenId, 1);
1270     }
1271 
1272     /**
1273      * @dev This is equivalent to _burn(tokenId, false)
1274      */
1275     function _burn(uint256 tokenId) internal virtual {
1276         _burn(tokenId, false);
1277     }
1278 
1279     /**
1280      * @dev Destroys `tokenId`.
1281      * The approval is cleared when the token is burned.
1282      *
1283      * Requirements:
1284      *
1285      * - `tokenId` must exist.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1290         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1291 
1292         address from = prevOwnership.addr;
1293 
1294         if (approvalCheck) {
1295             bool isApprovedOrOwner = (_msgSender() == from ||
1296                 isApprovedForAll(from, _msgSender()) ||
1297                 getApproved(tokenId) == _msgSender());
1298 
1299             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1300         }
1301 
1302         _beforeTokenTransfers(from, address(0), tokenId, 1);
1303 
1304         // Clear approvals from the previous owner
1305         _approve(address(0), tokenId, from);
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1310         unchecked {
1311             AddressData storage addressData = _addressData[from];
1312             addressData.balance -= 1;
1313             addressData.numberBurned += 1;
1314 
1315             // Keep track of who burned the token, and the timestamp of burning.
1316             TokenOwnership storage currSlot = _ownerships[tokenId];
1317             currSlot.addr = from;
1318             currSlot.startTimestamp = uint64(block.timestamp);
1319             currSlot.burned = true;
1320 
1321             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1322             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1323             uint256 nextTokenId = tokenId + 1;
1324             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1325             if (nextSlot.addr == address(0)) {
1326                 // This will suffice for checking _exists(nextTokenId),
1327                 // as a burned slot cannot contain the zero address.
1328                 if (nextTokenId != _currentIndex) {
1329                     nextSlot.addr = from;
1330                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1331                 }
1332             }
1333         }
1334 
1335         emit Transfer(from, address(0), tokenId);
1336         _afterTokenTransfers(from, address(0), tokenId, 1);
1337 
1338         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1339         unchecked {
1340             _burnCounter++;
1341         }
1342     }
1343 
1344     /**
1345      * @dev Approve `to` to operate on `tokenId`
1346      *
1347      * Emits a {Approval} event.
1348      */
1349     function _approve(
1350         address to,
1351         uint256 tokenId,
1352         address owner
1353     ) private {
1354         _tokenApprovals[tokenId] = to;
1355         emit Approval(owner, to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1360      *
1361      * @param from address representing the previous owner of the given token ID
1362      * @param to target address that will receive the tokens
1363      * @param tokenId uint256 ID of the token to be transferred
1364      * @param _data bytes optional data to send along with the call
1365      * @return bool whether the call correctly returned the expected magic value
1366      */
1367     function _checkContractOnERC721Received(
1368         address from,
1369         address to,
1370         uint256 tokenId,
1371         bytes memory _data
1372     ) private returns (bool) {
1373         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1374             return retval == IERC721Receiver(to).onERC721Received.selector;
1375         } catch (bytes memory reason) {
1376             if (reason.length == 0) {
1377                 revert TransferToNonERC721ReceiverImplementer();
1378             } else {
1379                 assembly {
1380                     revert(add(32, reason), mload(reason))
1381                 }
1382             }
1383         }
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1388      * And also called before burning one token.
1389      *
1390      * startTokenId - the first token id to be transferred
1391      * quantity - the amount to be transferred
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` will be minted for `to`.
1398      * - When `to` is zero, `tokenId` will be burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _beforeTokenTransfers(
1402         address from,
1403         address to,
1404         uint256 startTokenId,
1405         uint256 quantity
1406     ) internal virtual {}
1407 
1408     /**
1409      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1410      * minting.
1411      * And also called after one token has been burned.
1412      *
1413      * startTokenId - the first token id to be transferred
1414      * quantity - the amount to be transferred
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` has been minted for `to`.
1421      * - When `to` is zero, `tokenId` has been burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _afterTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 
1431     function _setMintCountToZero(
1432         address user
1433     )internal {
1434         _addressData[user].numberMinted=0;
1435     }
1436 
1437     function _minus1MintCount(
1438         address user
1439     )internal {
1440         _addressData[user].numberMinted--;
1441     }
1442 }
1443 // File: Fzuki/Fzuki.sol
1444 
1445 
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 //  ________                     __        __ 
1450 // |        \                   |  \      |  \
1451 // | $$$$$$$$________  __    __ | $$   __  \$$
1452 // | $$__   |        \|  \  |  \| $$  /  \|  \
1453 // | $$  \   \$$$$$$$$| $$  | $$| $$_/  $$| $$
1454 // | $$$$$    /    $$ | $$  | $$| $$   $$ | $$
1455 // | $$      /  $$$$_ | $$__/ $$| $$$$$$\ | $$
1456 // | $$     |  $$    \ \$$    $$| $$  \$$\| $$
1457 //  \$$      \$$$$$$$$  \$$$$$$  \$$   \$$ \$$
1458 
1459 
1460 
1461 
1462 
1463 
1464 
1465 contract Fzuki is Ownable, ERC721A, ReentrancyGuard {
1466   using Strings for uint256;
1467 
1468   bool public revealed = false;
1469   
1470   uint256 public startTimestamp = 1649435400;
1471   uint256 public MAX_SUPPLY   = 10000;
1472   uint256 public PRICE        = 0.016 ether;
1473   uint256 public HOLDERPRICE  = 0.012 ether;
1474   uint256 public MAX_QTY      = 20; // Max mint amount per wallet
1475   uint256 public publicGiveAwayCount = 500;
1476 
1477   string private _tokenURIPrefix="";
1478   string private _unrevealedTokenURIPrefix = "ipfs://QmckfemvDEY3gWVyJbayAJNRpfsV2ofp4J4xUJrvz1ZDCe/";
1479   string private _tokenURISuffix =  ".json";
1480   bytes32 private merkleRoot = 0xfbb8b96d2d97e31ba87ea9f843c49afeac07b82128d400756754a636bc305495;
1481 
1482   constructor(uint256 quantity)
1483     ERC721A("Fzuki", "FZUKI"){
1484       _safeMint(msg.sender,quantity);
1485   }
1486 
1487 //-------------------------------------------------------------------------------------------
1488 //  View Parts
1489 
1490 
1491   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1492     require(_exists(tokenId), "Fzuki: URI query for nonexistent token");
1493 
1494     if(revealed == false) {
1495       return string(abi.encodePacked(_unrevealedTokenURIPrefix, tokenId.toString(), _tokenURISuffix));
1496     }
1497     return string(abi.encodePacked(_tokenURIPrefix, tokenId.toString(), _tokenURISuffix));
1498   }
1499 
1500   function numberMinted(address owner) public view returns (uint256) {
1501     return _numberMinted(owner);
1502   }
1503 
1504 
1505 //-------------------------------------------------------------------------------------------
1506 //  Mint Part
1507 
1508 
1509   function mint( uint256 quantity ) external payable nonReentrant {
1510     require(block.timestamp >= startTimestamp, "Fzuki: You come too early");
1511     require(quantity > 0, "No free giveaway");
1512     require(quantity + numberMinted(msg.sender) <= MAX_QTY, "Fzuki: You can't mint that much");
1513     require (msg.value >= PRICE * quantity, "Fzuki: Ether sent is not correct");
1514 
1515     uint256 actualMintCount = quantity;
1516     require( totalSupply() + quantity <= MAX_SUPPLY, "Fzuki: Mint/order exceeds supply" );
1517 
1518     if(publicGiveAwayCount > 0 && numberMinted(msg.sender) == 0 && totalSupply() + quantity + 1 <= MAX_SUPPLY){
1519        ++actualMintCount;
1520        --publicGiveAwayCount;
1521     }
1522     _safeMint(msg.sender, actualMintCount);
1523 
1524     if(actualMintCount != quantity)
1525       _minus1MintCount(msg.sender);
1526   }
1527 
1528   function holderMint( uint quantity, bytes32[] calldata _holderProof) external payable nonReentrant {
1529     require(block.timestamp >= startTimestamp, "Fzuki: You come too early");
1530     bytes32 addressBytes = keccak256(abi.encodePacked(msg.sender));
1531     require(MerkleProof.verify(_holderProof, merkleRoot ,addressBytes),"Fzuki: You are not Azuki / Something holder");
1532     require(quantity > 0, "Fzuki: No free giveaway");
1533     require(quantity + numberMinted(msg.sender) <= MAX_QTY, "Fzuki: You can't mint that much");
1534     require (msg.value >= HOLDERPRICE * quantity, "Fzuki: Ether sent is not correct");
1535 
1536     uint256 actualMintCount = quantity;
1537     require( totalSupply() + quantity <= MAX_SUPPLY, "Fzuki: Mint/order exceeds supply" );
1538 
1539     if(publicGiveAwayCount > 0 && numberMinted(msg.sender) == 0 && totalSupply() + quantity + 1 <= MAX_SUPPLY){
1540        ++actualMintCount; 
1541        --publicGiveAwayCount;
1542     }
1543     _safeMint(msg.sender, actualMintCount);
1544 
1545     if(actualMintCount != quantity)
1546       _minus1MintCount(msg.sender);
1547   }
1548  
1549 //-------------------------------------------------------------------------------------------
1550 //  OnlyOwner Parts
1551 
1552 
1553   function withdraw() public onlyOwner {
1554     // =============================================================================
1555     uint amount = address(this).balance;
1556     payable(0xE46424211843E7C9086f59b22baaA0A03c0Fe85f).call{value: amount / 100 * 65}("");
1557     payable(0x5AbA94428CAfAb0ca358f51283e19b49CA4AFB83).call{value: amount / 100 * 35}("");
1558     payable(0x02835f937C287d9bCC0E182bfC07497288031EA5).call{value: amount / 100 * 5}("");
1559     // =============================================================================
1560   }//
1561 
1562 
1563   function devMint(uint256[] calldata quantity, address[] calldata recipient) external onlyOwner{
1564     require(quantity.length == recipient.length, "Fzuki: Must provide equal quantities and recipients" );
1565 
1566     uint256 totalQuantity;
1567     uint256 supply = totalSupply();
1568     for(uint256 i; i < quantity.length; ++i){
1569       totalQuantity += quantity[i];
1570     }
1571     require( supply + totalQuantity < MAX_SUPPLY, "Fzuki: Mint/order exceeds supply" );
1572 
1573     for(uint256 i; i < recipient.length; ++i){
1574       _safeMint(recipient[i],quantity[i]);
1575       _setMintCountToZero(recipient[i]);
1576     }
1577   }
1578 
1579 
1580   function flipRevealState() external onlyOwner {
1581       revealed = !revealed;
1582   }
1583 
1584   function setUnrevealedURI(string calldata notRevealUri_) external onlyOwner {
1585     _unrevealedTokenURIPrefix = notRevealUri_;
1586   }
1587 
1588   function setStartTimestamp(uint256 timestamp) external onlyOwner {
1589     startTimestamp = timestamp;
1590   }
1591 
1592   function setBaseURI(string calldata prefix, string calldata suffix) external onlyOwner{
1593     _tokenURIPrefix = prefix;
1594     _tokenURISuffix = suffix;
1595   }
1596 
1597   function setMaxQty(uint256 maxQty) external onlyOwner{
1598     require( MAX_QTY != maxQty, "Fzuki: New value matches old" );
1599     MAX_QTY = maxQty;
1600   }
1601 
1602   function setMaxSupply(uint256 maxSupply) external onlyOwner{
1603     require( maxSupply > totalSupply());
1604     MAX_SUPPLY = maxSupply;
1605   }
1606 
1607   function setPrice(uint256 price) external onlyOwner{
1608     require( PRICE != price, "Fzuki: New value matches old" );
1609     PRICE = price;
1610   }
1611 
1612   function setHolderPrice(uint256 price) external onlyOwner{
1613     require( HOLDERPRICE != price, "Fzuki: New value matches old" );
1614     HOLDERPRICE = price;
1615   }
1616 
1617   function setRoot(bytes32 _root) external onlyOwner{
1618     merkleRoot = _root;
1619   }
1620 }