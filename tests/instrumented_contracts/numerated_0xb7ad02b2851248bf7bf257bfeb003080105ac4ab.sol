1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
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
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Contract module that helps prevent reentrant calls to a function.
78  *
79  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
80  * available, which can be applied to functions to make sure there are no nested
81  * (reentrant) calls to them.
82  *
83  * Note that because there is a single `nonReentrant` guard, functions marked as
84  * `nonReentrant` may not call one another. This can be worked around by making
85  * those functions `private`, and then adding `external` `nonReentrant` entry
86  * points to them.
87  *
88  * TIP: If you would like to learn more about reentrancy and alternative ways
89  * to protect against it, check out our blog post
90  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
91  */
92 abstract contract ReentrancyGuard {
93     // Booleans are more expensive than uint256 or any type that takes up a full
94     // word because each write operation emits an extra SLOAD to first read the
95     // slot's contents, replace the bits taken up by the boolean, and then write
96     // back. This is the compiler's defense against contract upgrades and
97     // pointer aliasing, and it cannot be disabled.
98 
99     // The values being non-zero value makes deployment a bit more expensive,
100     // but in exchange the refund on every call to nonReentrant will be lower in
101     // amount. Since refunds are capped to a percentage of the total
102     // transaction's gas, it is best to keep them low in cases like this one, to
103     // increase the likelihood of the full refund coming into effect.
104     uint256 private constant _NOT_ENTERED = 1;
105     uint256 private constant _ENTERED = 2;
106 
107     uint256 private _status;
108 
109     constructor() {
110         _status = _NOT_ENTERED;
111     }
112 
113     /**
114      * @dev Prevents a contract from calling itself, directly or indirectly.
115      * Calling a `nonReentrant` function from another `nonReentrant`
116      * function is not supported. It is possible to prevent this from happening
117      * by making the `nonReentrant` function external, and making it call a
118      * `private` function that does the actual work.
119      */
120     modifier nonReentrant() {
121         // On the first call to nonReentrant, _notEntered will be true
122         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
123 
124         // Any calls to nonReentrant after this point will fail
125         _status = _ENTERED;
126 
127         _;
128 
129         // By storing the original value once again, a refund is triggered (see
130         // https://eips.ethereum.org/EIPS/eip-2200)
131         _status = _NOT_ENTERED;
132     }
133 }
134 
135 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @title Counters
144  * @author Matt Condon (@shrugs)
145  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
146  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
147  *
148  * Include with `using Counters for Counters.Counter;`
149  */
150 library Counters {
151     struct Counter {
152         // This variable should never be directly accessed by users of the library: interactions must be restricted to
153         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
154         // this feature: see https://github.com/ethereum/solidity/issues/4637
155         uint256 _value; // default: 0
156     }
157 
158     function current(Counter storage counter) internal view returns (uint256) {
159         return counter._value;
160     }
161 
162     function increment(Counter storage counter) internal {
163         unchecked {
164             counter._value += 1;
165         }
166     }
167 
168     function decrement(Counter storage counter) internal {
169         uint256 value = counter._value;
170         require(value > 0, "Counter: decrement overflow");
171         unchecked {
172             counter._value = value - 1;
173         }
174     }
175 
176     function reset(Counter storage counter) internal {
177         counter._value = 0;
178     }
179 }
180 
181 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
182 
183 
184 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Interface of the ERC20 standard as defined in the EIP.
190  */
191 interface IERC20 {
192     /**
193      * @dev Emitted when `value` tokens are moved from one account (`from`) to
194      * another (`to`).
195      *
196      * Note that `value` may be zero.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 
200     /**
201      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
202      * a call to {approve}. `value` is the new allowance.
203      */
204     event Approval(address indexed owner, address indexed spender, uint256 value);
205 
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `to`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address to, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Moves `amount` tokens from `from` to `to` using the
252      * allowance mechanism. `amount` is then deducted from the caller's
253      * allowance.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(
260         address from,
261         address to,
262         uint256 amount
263     ) external returns (bool);
264 }
265 
266 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev String operations.
275  */
276 library Strings {
277     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
281      */
282     function toString(uint256 value) internal pure returns (string memory) {
283         // Inspired by OraclizeAPI's implementation - MIT licence
284         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
285 
286         if (value == 0) {
287             return "0";
288         }
289         uint256 temp = value;
290         uint256 digits;
291         while (temp != 0) {
292             digits++;
293             temp /= 10;
294         }
295         bytes memory buffer = new bytes(digits);
296         while (value != 0) {
297             digits -= 1;
298             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
299             value /= 10;
300         }
301         return string(buffer);
302     }
303 
304     /**
305      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
306      */
307     function toHexString(uint256 value) internal pure returns (string memory) {
308         if (value == 0) {
309             return "0x00";
310         }
311         uint256 temp = value;
312         uint256 length = 0;
313         while (temp != 0) {
314             length++;
315             temp >>= 8;
316         }
317         return toHexString(value, length);
318     }
319 
320     /**
321      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
322      */
323     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
324         bytes memory buffer = new bytes(2 * length + 2);
325         buffer[0] = "0";
326         buffer[1] = "x";
327         for (uint256 i = 2 * length + 1; i > 1; --i) {
328             buffer[i] = _HEX_SYMBOLS[value & 0xf];
329             value >>= 4;
330         }
331         require(value == 0, "Strings: hex length insufficient");
332         return string(buffer);
333     }
334 }
335 
336 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Provides information about the current execution context, including the
345  * sender of the transaction and its data. While these are generally available
346  * via msg.sender and msg.data, they should not be accessed in such a direct
347  * manner, since when dealing with meta-transactions the account sending and
348  * paying for execution may not be the actual sender (as far as an application
349  * is concerned).
350  *
351  * This contract is only required for intermediate, library-like contracts.
352  */
353 abstract contract Context {
354     function _msgSender() internal view virtual returns (address) {
355         return msg.sender;
356     }
357 
358     function _msgData() internal view virtual returns (bytes calldata) {
359         return msg.data;
360     }
361 }
362 
363 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
364 
365 
366 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 
371 /**
372  * @dev Contract module which provides a basic access control mechanism, where
373  * there is an account (an owner) that can be granted exclusive access to
374  * specific functions.
375  *
376  * By default, the owner account will be the one that deploys the contract. This
377  * can later be changed with {transferOwnership}.
378  *
379  * This module is used through inheritance. It will make available the modifier
380  * `onlyOwner`, which can be applied to your functions to restrict their use to
381  * the owner.
382  */
383 abstract contract Ownable is Context {
384     address private _owner;
385 
386     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388     /**
389      * @dev Initializes the contract setting the deployer as the initial owner.
390      */
391     constructor() {
392         _transferOwnership(_msgSender());
393     }
394 
395     /**
396      * @dev Returns the address of the current owner.
397      */
398     function owner() public view virtual returns (address) {
399         return _owner;
400     }
401 
402     /**
403      * @dev Throws if called by any account other than the owner.
404      */
405     modifier onlyOwner() {
406         require(owner() == _msgSender(), "Ownable: caller is not the owner");
407         _;
408     }
409 
410     /**
411      * @dev Leaves the contract without owner. It will not be possible to call
412      * `onlyOwner` functions anymore. Can only be called by the current owner.
413      *
414      * NOTE: Renouncing ownership will leave the contract without an owner,
415      * thereby removing any functionality that is only available to the owner.
416      */
417     function renounceOwnership() public virtual onlyOwner {
418         _transferOwnership(address(0));
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      * Can only be called by the current owner.
424      */
425     function transferOwnership(address newOwner) public virtual onlyOwner {
426         require(newOwner != address(0), "Ownable: new owner is the zero address");
427         _transferOwnership(newOwner);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Internal function without access restriction.
433      */
434     function _transferOwnership(address newOwner) internal virtual {
435         address oldOwner = _owner;
436         _owner = newOwner;
437         emit OwnershipTransferred(oldOwner, newOwner);
438     }
439 }
440 
441 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
442 
443 
444 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
445 
446 pragma solidity ^0.8.1;
447 
448 /**
449  * @dev Collection of functions related to the address type
450  */
451 library Address {
452     /**
453      * @dev Returns true if `account` is a contract.
454      *
455      * [IMPORTANT]
456      * ====
457      * It is unsafe to assume that an address for which this function returns
458      * false is an externally-owned account (EOA) and not a contract.
459      *
460      * Among others, `isContract` will return false for the following
461      * types of addresses:
462      *
463      *  - an externally-owned account
464      *  - a contract in construction
465      *  - an address where a contract will be created
466      *  - an address where a contract lived, but was destroyed
467      * ====
468      *
469      * [IMPORTANT]
470      * ====
471      * You shouldn't rely on `isContract` to protect against flash loan attacks!
472      *
473      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
474      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
475      * constructor.
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize/address.code.length, which returns 0
480         // for contracts in construction, since the code is only stored at the end
481         // of the constructor execution.
482 
483         return account.code.length > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(address(this).balance >= amount, "Address: insufficient balance");
504 
505         (bool success, ) = recipient.call{value: amount}("");
506         require(success, "Address: unable to send value, recipient may have reverted");
507     }
508 
509     /**
510      * @dev Performs a Solidity function call using a low level `call`. A
511      * plain `call` is an unsafe replacement for a function call: use this
512      * function instead.
513      *
514      * If `target` reverts with a revert reason, it is bubbled up by this
515      * function (like regular Solidity function calls).
516      *
517      * Returns the raw returned data. To convert to the expected return value,
518      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
519      *
520      * Requirements:
521      *
522      * - `target` must be a contract.
523      * - calling `target` with `data` must not revert.
524      *
525      * _Available since v3.1._
526      */
527     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
528         return functionCall(target, data, "Address: low-level call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
533      * `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, 0, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but also transferring `value` wei to `target`.
548      *
549      * Requirements:
550      *
551      * - the calling contract must have an ETH balance of at least `value`.
552      * - the called Solidity function must be `payable`.
553      *
554      * _Available since v3.1._
555      */
556     function functionCallWithValue(
557         address target,
558         bytes memory data,
559         uint256 value
560     ) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(
571         address target,
572         bytes memory data,
573         uint256 value,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         require(isContract(target), "Address: call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.call{value: value}(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
590         return functionStaticCall(target, data, "Address: low-level static call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(
600         address target,
601         bytes memory data,
602         string memory errorMessage
603     ) internal view returns (bytes memory) {
604         require(isContract(target), "Address: static call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.staticcall(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a delegate call.
613      *
614      * _Available since v3.4._
615      */
616     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
617         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a delegate call.
623      *
624      * _Available since v3.4._
625      */
626     function functionDelegateCall(
627         address target,
628         bytes memory data,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(isContract(target), "Address: delegate call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.delegatecall(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
639      * revert reason using the provided one.
640      *
641      * _Available since v4.3._
642      */
643     function verifyCallResult(
644         bool success,
645         bytes memory returndata,
646         string memory errorMessage
647     ) internal pure returns (bytes memory) {
648         if (success) {
649             return returndata;
650         } else {
651             // Look for revert reason and bubble it up if present
652             if (returndata.length > 0) {
653                 // The easiest way to bubble the revert reason is using memory via assembly
654 
655                 assembly {
656                     let returndata_size := mload(returndata)
657                     revert(add(32, returndata), returndata_size)
658                 }
659             } else {
660                 revert(errorMessage);
661             }
662         }
663     }
664 }
665 
666 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @title ERC721 token receiver interface
675  * @dev Interface for any contract that wants to support safeTransfers
676  * from ERC721 asset contracts.
677  */
678 interface IERC721Receiver {
679     /**
680      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
681      * by `operator` from `from`, this function is called.
682      *
683      * It must return its Solidity selector to confirm the token transfer.
684      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
685      *
686      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
687      */
688     function onERC721Received(
689         address operator,
690         address from,
691         uint256 tokenId,
692         bytes calldata data
693     ) external returns (bytes4);
694 }
695 
696 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Interface of the ERC165 standard, as defined in the
705  * https://eips.ethereum.org/EIPS/eip-165[EIP].
706  *
707  * Implementers can declare support of contract interfaces, which can then be
708  * queried by others ({ERC165Checker}).
709  *
710  * For an implementation, see {ERC165}.
711  */
712 interface IERC165 {
713     /**
714      * @dev Returns true if this contract implements the interface defined by
715      * `interfaceId`. See the corresponding
716      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
717      * to learn more about how these ids are created.
718      *
719      * This function call must use less than 30 000 gas.
720      */
721     function supportsInterface(bytes4 interfaceId) external view returns (bool);
722 }
723 
724 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
725 
726 
727 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev _Available since v3.1._
734  */
735 interface IERC1155Receiver is IERC165 {
736     /**
737      * @dev Handles the receipt of a single ERC1155 token type. This function is
738      * called at the end of a `safeTransferFrom` after the balance has been updated.
739      *
740      * NOTE: To accept the transfer, this must return
741      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
742      * (i.e. 0xf23a6e61, or its own function selector).
743      *
744      * @param operator The address which initiated the transfer (i.e. msg.sender)
745      * @param from The address which previously owned the token
746      * @param id The ID of the token being transferred
747      * @param value The amount of tokens being transferred
748      * @param data Additional data with no specified format
749      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
750      */
751     function onERC1155Received(
752         address operator,
753         address from,
754         uint256 id,
755         uint256 value,
756         bytes calldata data
757     ) external returns (bytes4);
758 
759     /**
760      * @dev Handles the receipt of a multiple ERC1155 token types. This function
761      * is called at the end of a `safeBatchTransferFrom` after the balances have
762      * been updated.
763      *
764      * NOTE: To accept the transfer(s), this must return
765      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
766      * (i.e. 0xbc197c81, or its own function selector).
767      *
768      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
769      * @param from The address which previously owned the token
770      * @param ids An array containing ids of each token being transferred (order and length must match values array)
771      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
772      * @param data Additional data with no specified format
773      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
774      */
775     function onERC1155BatchReceived(
776         address operator,
777         address from,
778         uint256[] calldata ids,
779         uint256[] calldata values,
780         bytes calldata data
781     ) external returns (bytes4);
782 }
783 
784 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
785 
786 
787 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 
792 /**
793  * @dev Required interface of an ERC1155 compliant contract, as defined in the
794  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
795  *
796  * _Available since v3.1._
797  */
798 interface IERC1155 is IERC165 {
799     /**
800      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
801      */
802     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
803 
804     /**
805      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
806      * transfers.
807      */
808     event TransferBatch(
809         address indexed operator,
810         address indexed from,
811         address indexed to,
812         uint256[] ids,
813         uint256[] values
814     );
815 
816     /**
817      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
818      * `approved`.
819      */
820     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
821 
822     /**
823      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
824      *
825      * If an {URI} event was emitted for `id`, the standard
826      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
827      * returned by {IERC1155MetadataURI-uri}.
828      */
829     event URI(string value, uint256 indexed id);
830 
831     /**
832      * @dev Returns the amount of tokens of token type `id` owned by `account`.
833      *
834      * Requirements:
835      *
836      * - `account` cannot be the zero address.
837      */
838     function balanceOf(address account, uint256 id) external view returns (uint256);
839 
840     /**
841      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
842      *
843      * Requirements:
844      *
845      * - `accounts` and `ids` must have the same length.
846      */
847     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
848         external
849         view
850         returns (uint256[] memory);
851 
852     /**
853      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
854      *
855      * Emits an {ApprovalForAll} event.
856      *
857      * Requirements:
858      *
859      * - `operator` cannot be the caller.
860      */
861     function setApprovalForAll(address operator, bool approved) external;
862 
863     /**
864      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
865      *
866      * See {setApprovalForAll}.
867      */
868     function isApprovedForAll(address account, address operator) external view returns (bool);
869 
870     /**
871      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
872      *
873      * Emits a {TransferSingle} event.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
879      * - `from` must have a balance of tokens of type `id` of at least `amount`.
880      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
881      * acceptance magic value.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 id,
887         uint256 amount,
888         bytes calldata data
889     ) external;
890 
891     /**
892      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
893      *
894      * Emits a {TransferBatch} event.
895      *
896      * Requirements:
897      *
898      * - `ids` and `amounts` must have the same length.
899      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
900      * acceptance magic value.
901      */
902     function safeBatchTransferFrom(
903         address from,
904         address to,
905         uint256[] calldata ids,
906         uint256[] calldata amounts,
907         bytes calldata data
908     ) external;
909 }
910 
911 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
921  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
922  *
923  * _Available since v3.1._
924  */
925 interface IERC1155MetadataURI is IERC1155 {
926     /**
927      * @dev Returns the URI for token type `id`.
928      *
929      * If the `\{id\}` substring is present in the URI, it must be replaced by
930      * clients with the actual token type ID.
931      */
932     function uri(uint256 id) external view returns (string memory);
933 }
934 
935 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 /**
944  * @dev Implementation of the {IERC165} interface.
945  *
946  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
947  * for the additional interface id that will be supported. For example:
948  *
949  * ```solidity
950  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
951  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
952  * }
953  * ```
954  *
955  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
956  */
957 abstract contract ERC165 is IERC165 {
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
962         return interfaceId == type(IERC165).interfaceId;
963     }
964 }
965 
966 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
967 
968 
969 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 
974 
975 
976 
977 
978 
979 /**
980  * @dev Implementation of the basic standard multi-token.
981  * See https://eips.ethereum.org/EIPS/eip-1155
982  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
983  *
984  * _Available since v3.1._
985  */
986 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
987     using Address for address;
988 
989     // Mapping from token ID to account balances
990     mapping(uint256 => mapping(address => uint256)) private _balances;
991 
992     // Mapping from account to operator approvals
993     mapping(address => mapping(address => bool)) private _operatorApprovals;
994 
995     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
996     string private _uri;
997 
998     /**
999      * @dev See {_setURI}.
1000      */
1001     constructor(string memory uri_) {
1002         _setURI(uri_);
1003     }
1004 
1005     /**
1006      * @dev See {IERC165-supportsInterface}.
1007      */
1008     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1009         return
1010             interfaceId == type(IERC1155).interfaceId ||
1011             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1012             super.supportsInterface(interfaceId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC1155MetadataURI-uri}.
1017      *
1018      * This implementation returns the same URI for *all* token types. It relies
1019      * on the token type ID substitution mechanism
1020      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1021      *
1022      * Clients calling this function must replace the `\{id\}` substring with the
1023      * actual token type ID.
1024      */
1025     function uri(uint256) public view virtual override returns (string memory) {
1026         return _uri;
1027     }
1028 
1029     /**
1030      * @dev See {IERC1155-balanceOf}.
1031      *
1032      * Requirements:
1033      *
1034      * - `account` cannot be the zero address.
1035      */
1036     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1037         require(account != address(0), "ERC1155: balance query for the zero address");
1038         return _balances[id][account];
1039     }
1040 
1041     /**
1042      * @dev See {IERC1155-balanceOfBatch}.
1043      *
1044      * Requirements:
1045      *
1046      * - `accounts` and `ids` must have the same length.
1047      */
1048     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1049         public
1050         view
1051         virtual
1052         override
1053         returns (uint256[] memory)
1054     {
1055         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1056 
1057         uint256[] memory batchBalances = new uint256[](accounts.length);
1058 
1059         for (uint256 i = 0; i < accounts.length; ++i) {
1060             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1061         }
1062 
1063         return batchBalances;
1064     }
1065 
1066     /**
1067      * @dev See {IERC1155-setApprovalForAll}.
1068      */
1069     function setApprovalForAll(address operator, bool approved) public virtual override {
1070         _setApprovalForAll(_msgSender(), operator, approved);
1071     }
1072 
1073     /**
1074      * @dev See {IERC1155-isApprovedForAll}.
1075      */
1076     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1077         return _operatorApprovals[account][operator];
1078     }
1079 
1080     /**
1081      * @dev See {IERC1155-safeTransferFrom}.
1082      */
1083     function safeTransferFrom(
1084         address from,
1085         address to,
1086         uint256 id,
1087         uint256 amount,
1088         bytes memory data
1089     ) public virtual override {
1090         require(
1091             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1092             "ERC1155: caller is not owner nor approved"
1093         );
1094         _safeTransferFrom(from, to, id, amount, data);
1095     }
1096 
1097     /**
1098      * @dev See {IERC1155-safeBatchTransferFrom}.
1099      */
1100     function safeBatchTransferFrom(
1101         address from,
1102         address to,
1103         uint256[] memory ids,
1104         uint256[] memory amounts,
1105         bytes memory data
1106     ) public virtual override {
1107         require(
1108             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1109             "ERC1155: transfer caller is not owner nor approved"
1110         );
1111         _safeBatchTransferFrom(from, to, ids, amounts, data);
1112     }
1113 
1114     /**
1115      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1116      *
1117      * Emits a {TransferSingle} event.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1123      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1124      * acceptance magic value.
1125      */
1126     function _safeTransferFrom(
1127         address from,
1128         address to,
1129         uint256 id,
1130         uint256 amount,
1131         bytes memory data
1132     ) internal virtual {
1133         require(to != address(0), "ERC1155: transfer to the zero address");
1134 
1135         address operator = _msgSender();
1136         uint256[] memory ids = _asSingletonArray(id);
1137         uint256[] memory amounts = _asSingletonArray(amount);
1138 
1139         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1140 
1141         uint256 fromBalance = _balances[id][from];
1142         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1143         unchecked {
1144             _balances[id][from] = fromBalance - amount;
1145         }
1146         _balances[id][to] += amount;
1147 
1148         emit TransferSingle(operator, from, to, id, amount);
1149 
1150         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1151 
1152         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1153     }
1154 
1155     /**
1156      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1157      *
1158      * Emits a {TransferBatch} event.
1159      *
1160      * Requirements:
1161      *
1162      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1163      * acceptance magic value.
1164      */
1165     function _safeBatchTransferFrom(
1166         address from,
1167         address to,
1168         uint256[] memory ids,
1169         uint256[] memory amounts,
1170         bytes memory data
1171     ) internal virtual {
1172         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1173         require(to != address(0), "ERC1155: transfer to the zero address");
1174 
1175         address operator = _msgSender();
1176 
1177         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1178 
1179         for (uint256 i = 0; i < ids.length; ++i) {
1180             uint256 id = ids[i];
1181             uint256 amount = amounts[i];
1182 
1183             uint256 fromBalance = _balances[id][from];
1184             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1185             unchecked {
1186                 _balances[id][from] = fromBalance - amount;
1187             }
1188             _balances[id][to] += amount;
1189         }
1190 
1191         emit TransferBatch(operator, from, to, ids, amounts);
1192 
1193         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1194 
1195         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1196     }
1197 
1198     /**
1199      * @dev Sets a new URI for all token types, by relying on the token type ID
1200      * substitution mechanism
1201      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1202      *
1203      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1204      * URI or any of the amounts in the JSON file at said URI will be replaced by
1205      * clients with the token type ID.
1206      *
1207      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1208      * interpreted by clients as
1209      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1210      * for token type ID 0x4cce0.
1211      *
1212      * See {uri}.
1213      *
1214      * Because these URIs cannot be meaningfully represented by the {URI} event,
1215      * this function emits no events.
1216      */
1217     function _setURI(string memory newuri) internal virtual {
1218         _uri = newuri;
1219     }
1220 
1221     /**
1222      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1223      *
1224      * Emits a {TransferSingle} event.
1225      *
1226      * Requirements:
1227      *
1228      * - `to` cannot be the zero address.
1229      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1230      * acceptance magic value.
1231      */
1232     function _mint(
1233         address to,
1234         uint256 id,
1235         uint256 amount,
1236         bytes memory data
1237     ) internal virtual {
1238         require(to != address(0), "ERC1155: mint to the zero address");
1239 
1240         address operator = _msgSender();
1241         uint256[] memory ids = _asSingletonArray(id);
1242         uint256[] memory amounts = _asSingletonArray(amount);
1243 
1244         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1245 
1246         _balances[id][to] += amount;
1247         emit TransferSingle(operator, address(0), to, id, amount);
1248 
1249         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1250 
1251         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1252     }
1253 
1254     /**
1255      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1256      *
1257      * Requirements:
1258      *
1259      * - `ids` and `amounts` must have the same length.
1260      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1261      * acceptance magic value.
1262      */
1263     function _mintBatch(
1264         address to,
1265         uint256[] memory ids,
1266         uint256[] memory amounts,
1267         bytes memory data
1268     ) internal virtual {
1269         require(to != address(0), "ERC1155: mint to the zero address");
1270         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1271 
1272         address operator = _msgSender();
1273 
1274         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1275 
1276         for (uint256 i = 0; i < ids.length; i++) {
1277             _balances[ids[i]][to] += amounts[i];
1278         }
1279 
1280         emit TransferBatch(operator, address(0), to, ids, amounts);
1281 
1282         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1283 
1284         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1285     }
1286 
1287     /**
1288      * @dev Destroys `amount` tokens of token type `id` from `from`
1289      *
1290      * Requirements:
1291      *
1292      * - `from` cannot be the zero address.
1293      * - `from` must have at least `amount` tokens of token type `id`.
1294      */
1295     function _burn(
1296         address from,
1297         uint256 id,
1298         uint256 amount
1299     ) internal virtual {
1300         require(from != address(0), "ERC1155: burn from the zero address");
1301 
1302         address operator = _msgSender();
1303         uint256[] memory ids = _asSingletonArray(id);
1304         uint256[] memory amounts = _asSingletonArray(amount);
1305 
1306         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1307 
1308         uint256 fromBalance = _balances[id][from];
1309         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1310         unchecked {
1311             _balances[id][from] = fromBalance - amount;
1312         }
1313 
1314         emit TransferSingle(operator, from, address(0), id, amount);
1315 
1316         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1317     }
1318 
1319     /**
1320      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1321      *
1322      * Requirements:
1323      *
1324      * - `ids` and `amounts` must have the same length.
1325      */
1326     function _burnBatch(
1327         address from,
1328         uint256[] memory ids,
1329         uint256[] memory amounts
1330     ) internal virtual {
1331         require(from != address(0), "ERC1155: burn from the zero address");
1332         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1333 
1334         address operator = _msgSender();
1335 
1336         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1337 
1338         for (uint256 i = 0; i < ids.length; i++) {
1339             uint256 id = ids[i];
1340             uint256 amount = amounts[i];
1341 
1342             uint256 fromBalance = _balances[id][from];
1343             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1344             unchecked {
1345                 _balances[id][from] = fromBalance - amount;
1346             }
1347         }
1348 
1349         emit TransferBatch(operator, from, address(0), ids, amounts);
1350 
1351         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1352     }
1353 
1354     /**
1355      * @dev Approve `operator` to operate on all of `owner` tokens
1356      *
1357      * Emits a {ApprovalForAll} event.
1358      */
1359     function _setApprovalForAll(
1360         address owner,
1361         address operator,
1362         bool approved
1363     ) internal virtual {
1364         require(owner != operator, "ERC1155: setting approval status for self");
1365         _operatorApprovals[owner][operator] = approved;
1366         emit ApprovalForAll(owner, operator, approved);
1367     }
1368 
1369     /**
1370      * @dev Hook that is called before any token transfer. This includes minting
1371      * and burning, as well as batched variants.
1372      *
1373      * The same hook is called on both single and batched variants. For single
1374      * transfers, the length of the `id` and `amount` arrays will be 1.
1375      *
1376      * Calling conditions (for each `id` and `amount` pair):
1377      *
1378      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1379      * of token type `id` will be  transferred to `to`.
1380      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1381      * for `to`.
1382      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1383      * will be burned.
1384      * - `from` and `to` are never both zero.
1385      * - `ids` and `amounts` have the same, non-zero length.
1386      *
1387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1388      */
1389     function _beforeTokenTransfer(
1390         address operator,
1391         address from,
1392         address to,
1393         uint256[] memory ids,
1394         uint256[] memory amounts,
1395         bytes memory data
1396     ) internal virtual {}
1397 
1398     /**
1399      * @dev Hook that is called after any token transfer. This includes minting
1400      * and burning, as well as batched variants.
1401      *
1402      * The same hook is called on both single and batched variants. For single
1403      * transfers, the length of the `id` and `amount` arrays will be 1.
1404      *
1405      * Calling conditions (for each `id` and `amount` pair):
1406      *
1407      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1408      * of token type `id` will be  transferred to `to`.
1409      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1410      * for `to`.
1411      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1412      * will be burned.
1413      * - `from` and `to` are never both zero.
1414      * - `ids` and `amounts` have the same, non-zero length.
1415      *
1416      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1417      */
1418     function _afterTokenTransfer(
1419         address operator,
1420         address from,
1421         address to,
1422         uint256[] memory ids,
1423         uint256[] memory amounts,
1424         bytes memory data
1425     ) internal virtual {}
1426 
1427     function _doSafeTransferAcceptanceCheck(
1428         address operator,
1429         address from,
1430         address to,
1431         uint256 id,
1432         uint256 amount,
1433         bytes memory data
1434     ) private {
1435         if (to.isContract()) {
1436             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1437                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1438                     revert("ERC1155: ERC1155Receiver rejected tokens");
1439                 }
1440             } catch Error(string memory reason) {
1441                 revert(reason);
1442             } catch {
1443                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1444             }
1445         }
1446     }
1447 
1448     function _doSafeBatchTransferAcceptanceCheck(
1449         address operator,
1450         address from,
1451         address to,
1452         uint256[] memory ids,
1453         uint256[] memory amounts,
1454         bytes memory data
1455     ) private {
1456         if (to.isContract()) {
1457             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1458                 bytes4 response
1459             ) {
1460                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1461                     revert("ERC1155: ERC1155Receiver rejected tokens");
1462                 }
1463             } catch Error(string memory reason) {
1464                 revert(reason);
1465             } catch {
1466                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1467             }
1468         }
1469     }
1470 
1471     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1472         uint256[] memory array = new uint256[](1);
1473         array[0] = element;
1474 
1475         return array;
1476     }
1477 }
1478 
1479 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1480 
1481 
1482 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1483 
1484 pragma solidity ^0.8.0;
1485 
1486 
1487 /**
1488  * @dev Required interface of an ERC721 compliant contract.
1489  */
1490 interface IERC721 is IERC165 {
1491     /**
1492      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1493      */
1494     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1495 
1496     /**
1497      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1498      */
1499     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1500 
1501     /**
1502      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1503      */
1504     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1505 
1506     /**
1507      * @dev Returns the number of tokens in ``owner``'s account.
1508      */
1509     function balanceOf(address owner) external view returns (uint256 balance);
1510 
1511     /**
1512      * @dev Returns the owner of the `tokenId` token.
1513      *
1514      * Requirements:
1515      *
1516      * - `tokenId` must exist.
1517      */
1518     function ownerOf(uint256 tokenId) external view returns (address owner);
1519 
1520     /**
1521      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1522      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1523      *
1524      * Requirements:
1525      *
1526      * - `from` cannot be the zero address.
1527      * - `to` cannot be the zero address.
1528      * - `tokenId` token must exist and be owned by `from`.
1529      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1530      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1531      *
1532      * Emits a {Transfer} event.
1533      */
1534     function safeTransferFrom(
1535         address from,
1536         address to,
1537         uint256 tokenId
1538     ) external;
1539 
1540     /**
1541      * @dev Transfers `tokenId` token from `from` to `to`.
1542      *
1543      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1544      *
1545      * Requirements:
1546      *
1547      * - `from` cannot be the zero address.
1548      * - `to` cannot be the zero address.
1549      * - `tokenId` token must be owned by `from`.
1550      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1551      *
1552      * Emits a {Transfer} event.
1553      */
1554     function transferFrom(
1555         address from,
1556         address to,
1557         uint256 tokenId
1558     ) external;
1559 
1560     /**
1561      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1562      * The approval is cleared when the token is transferred.
1563      *
1564      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1565      *
1566      * Requirements:
1567      *
1568      * - The caller must own the token or be an approved operator.
1569      * - `tokenId` must exist.
1570      *
1571      * Emits an {Approval} event.
1572      */
1573     function approve(address to, uint256 tokenId) external;
1574 
1575     /**
1576      * @dev Returns the account approved for `tokenId` token.
1577      *
1578      * Requirements:
1579      *
1580      * - `tokenId` must exist.
1581      */
1582     function getApproved(uint256 tokenId) external view returns (address operator);
1583 
1584     /**
1585      * @dev Approve or remove `operator` as an operator for the caller.
1586      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1587      *
1588      * Requirements:
1589      *
1590      * - The `operator` cannot be the caller.
1591      *
1592      * Emits an {ApprovalForAll} event.
1593      */
1594     function setApprovalForAll(address operator, bool _approved) external;
1595 
1596     /**
1597      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1598      *
1599      * See {setApprovalForAll}
1600      */
1601     function isApprovedForAll(address owner, address operator) external view returns (bool);
1602 
1603     /**
1604      * @dev Safely transfers `tokenId` token from `from` to `to`.
1605      *
1606      * Requirements:
1607      *
1608      * - `from` cannot be the zero address.
1609      * - `to` cannot be the zero address.
1610      * - `tokenId` token must exist and be owned by `from`.
1611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1612      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1613      *
1614      * Emits a {Transfer} event.
1615      */
1616     function safeTransferFrom(
1617         address from,
1618         address to,
1619         uint256 tokenId,
1620         bytes calldata data
1621     ) external;
1622 }
1623 
1624 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1625 
1626 
1627 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1628 
1629 pragma solidity ^0.8.0;
1630 
1631 
1632 /**
1633  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1634  * @dev See https://eips.ethereum.org/EIPS/eip-721
1635  */
1636 interface IERC721Metadata is IERC721 {
1637     /**
1638      * @dev Returns the token collection name.
1639      */
1640     function name() external view returns (string memory);
1641 
1642     /**
1643      * @dev Returns the token collection symbol.
1644      */
1645     function symbol() external view returns (string memory);
1646 
1647     /**
1648      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1649      */
1650     function tokenURI(uint256 tokenId) external view returns (string memory);
1651 }
1652 
1653 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1654 
1655 
1656 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 
1661 
1662 
1663 
1664 
1665 
1666 
1667 /**
1668  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1669  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1670  * {ERC721Enumerable}.
1671  */
1672 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1673     using Address for address;
1674     using Strings for uint256;
1675 
1676     // Token name
1677     string private _name;
1678 
1679     // Token symbol
1680     string private _symbol;
1681 
1682     // Mapping from token ID to owner address
1683     mapping(uint256 => address) private _owners;
1684 
1685     // Mapping owner address to token count
1686     mapping(address => uint256) private _balances;
1687 
1688     // Mapping from token ID to approved address
1689     mapping(uint256 => address) private _tokenApprovals;
1690 
1691     // Mapping from owner to operator approvals
1692     mapping(address => mapping(address => bool)) private _operatorApprovals;
1693 
1694     /**
1695      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1696      */
1697     constructor(string memory name_, string memory symbol_) {
1698         _name = name_;
1699         _symbol = symbol_;
1700     }
1701 
1702     /**
1703      * @dev See {IERC165-supportsInterface}.
1704      */
1705     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1706         return
1707             interfaceId == type(IERC721).interfaceId ||
1708             interfaceId == type(IERC721Metadata).interfaceId ||
1709             super.supportsInterface(interfaceId);
1710     }
1711 
1712     /**
1713      * @dev See {IERC721-balanceOf}.
1714      */
1715     function balanceOf(address owner) public view virtual override returns (uint256) {
1716         require(owner != address(0), "ERC721: balance query for the zero address");
1717         return _balances[owner];
1718     }
1719 
1720     /**
1721      * @dev See {IERC721-ownerOf}.
1722      */
1723     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1724         address owner = _owners[tokenId];
1725         require(owner != address(0), "ERC721: owner query for nonexistent token");
1726         return owner;
1727     }
1728 
1729     /**
1730      * @dev See {IERC721Metadata-name}.
1731      */
1732     function name() public view virtual override returns (string memory) {
1733         return _name;
1734     }
1735 
1736     /**
1737      * @dev See {IERC721Metadata-symbol}.
1738      */
1739     function symbol() public view virtual override returns (string memory) {
1740         return _symbol;
1741     }
1742 
1743     /**
1744      * @dev See {IERC721Metadata-tokenURI}.
1745      */
1746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1747         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1748 
1749         string memory baseURI = _baseURI();
1750         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1751     }
1752 
1753     /**
1754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1756      * by default, can be overridden in child contracts.
1757      */
1758     function _baseURI() internal view virtual returns (string memory) {
1759         return "";
1760     }
1761 
1762     /**
1763      * @dev See {IERC721-approve}.
1764      */
1765     function approve(address to, uint256 tokenId) public virtual override {
1766         address owner = ERC721.ownerOf(tokenId);
1767         require(to != owner, "ERC721: approval to current owner");
1768 
1769         require(
1770             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1771             "ERC721: approve caller is not owner nor approved for all"
1772         );
1773 
1774         _approve(to, tokenId);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-getApproved}.
1779      */
1780     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1781         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1782 
1783         return _tokenApprovals[tokenId];
1784     }
1785 
1786     /**
1787      * @dev See {IERC721-setApprovalForAll}.
1788      */
1789     function setApprovalForAll(address operator, bool approved) public virtual override {
1790         _setApprovalForAll(_msgSender(), operator, approved);
1791     }
1792 
1793     /**
1794      * @dev See {IERC721-isApprovedForAll}.
1795      */
1796     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1797         return _operatorApprovals[owner][operator];
1798     }
1799 
1800     /**
1801      * @dev See {IERC721-transferFrom}.
1802      */
1803     function transferFrom(
1804         address from,
1805         address to,
1806         uint256 tokenId
1807     ) public virtual override {
1808         //solhint-disable-next-line max-line-length
1809         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1810 
1811         _transfer(from, to, tokenId);
1812     }
1813 
1814     /**
1815      * @dev See {IERC721-safeTransferFrom}.
1816      */
1817     function safeTransferFrom(
1818         address from,
1819         address to,
1820         uint256 tokenId
1821     ) public virtual override {
1822         safeTransferFrom(from, to, tokenId, "");
1823     }
1824 
1825     /**
1826      * @dev See {IERC721-safeTransferFrom}.
1827      */
1828     function safeTransferFrom(
1829         address from,
1830         address to,
1831         uint256 tokenId,
1832         bytes memory _data
1833     ) public virtual override {
1834         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1835         _safeTransfer(from, to, tokenId, _data);
1836     }
1837 
1838     /**
1839      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1840      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1841      *
1842      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1843      *
1844      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1845      * implement alternative mechanisms to perform token transfer, such as signature-based.
1846      *
1847      * Requirements:
1848      *
1849      * - `from` cannot be the zero address.
1850      * - `to` cannot be the zero address.
1851      * - `tokenId` token must exist and be owned by `from`.
1852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1853      *
1854      * Emits a {Transfer} event.
1855      */
1856     function _safeTransfer(
1857         address from,
1858         address to,
1859         uint256 tokenId,
1860         bytes memory _data
1861     ) internal virtual {
1862         _transfer(from, to, tokenId);
1863         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1864     }
1865 
1866     /**
1867      * @dev Returns whether `tokenId` exists.
1868      *
1869      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1870      *
1871      * Tokens start existing when they are minted (`_mint`),
1872      * and stop existing when they are burned (`_burn`).
1873      */
1874     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1875         return _owners[tokenId] != address(0);
1876     }
1877 
1878     /**
1879      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1880      *
1881      * Requirements:
1882      *
1883      * - `tokenId` must exist.
1884      */
1885     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1886         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1887         address owner = ERC721.ownerOf(tokenId);
1888         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1889     }
1890 
1891     /**
1892      * @dev Safely mints `tokenId` and transfers it to `to`.
1893      *
1894      * Requirements:
1895      *
1896      * - `tokenId` must not exist.
1897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1898      *
1899      * Emits a {Transfer} event.
1900      */
1901     function _safeMint(address to, uint256 tokenId) internal virtual {
1902         _safeMint(to, tokenId, "");
1903     }
1904 
1905     /**
1906      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1907      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1908      */
1909     function _safeMint(
1910         address to,
1911         uint256 tokenId,
1912         bytes memory _data
1913     ) internal virtual {
1914         _mint(to, tokenId);
1915         require(
1916             _checkOnERC721Received(address(0), to, tokenId, _data),
1917             "ERC721: transfer to non ERC721Receiver implementer"
1918         );
1919     }
1920 
1921     /**
1922      * @dev Mints `tokenId` and transfers it to `to`.
1923      *
1924      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1925      *
1926      * Requirements:
1927      *
1928      * - `tokenId` must not exist.
1929      * - `to` cannot be the zero address.
1930      *
1931      * Emits a {Transfer} event.
1932      */
1933     function _mint(address to, uint256 tokenId) internal virtual {
1934         require(to != address(0), "ERC721: mint to the zero address");
1935         require(!_exists(tokenId), "ERC721: token already minted");
1936 
1937         _beforeTokenTransfer(address(0), to, tokenId);
1938 
1939         _balances[to] += 1;
1940         _owners[tokenId] = to;
1941 
1942         emit Transfer(address(0), to, tokenId);
1943 
1944         _afterTokenTransfer(address(0), to, tokenId);
1945     }
1946 
1947     /**
1948      * @dev Destroys `tokenId`.
1949      * The approval is cleared when the token is burned.
1950      *
1951      * Requirements:
1952      *
1953      * - `tokenId` must exist.
1954      *
1955      * Emits a {Transfer} event.
1956      */
1957     function _burn(uint256 tokenId) internal virtual {
1958         address owner = ERC721.ownerOf(tokenId);
1959 
1960         _beforeTokenTransfer(owner, address(0), tokenId);
1961 
1962         // Clear approvals
1963         _approve(address(0), tokenId);
1964 
1965         _balances[owner] -= 1;
1966         delete _owners[tokenId];
1967 
1968         emit Transfer(owner, address(0), tokenId);
1969 
1970         _afterTokenTransfer(owner, address(0), tokenId);
1971     }
1972 
1973     /**
1974      * @dev Transfers `tokenId` from `from` to `to`.
1975      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1976      *
1977      * Requirements:
1978      *
1979      * - `to` cannot be the zero address.
1980      * - `tokenId` token must be owned by `from`.
1981      *
1982      * Emits a {Transfer} event.
1983      */
1984     function _transfer(
1985         address from,
1986         address to,
1987         uint256 tokenId
1988     ) internal virtual {
1989         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1990         require(to != address(0), "ERC721: transfer to the zero address");
1991 
1992         _beforeTokenTransfer(from, to, tokenId);
1993 
1994         // Clear approvals from the previous owner
1995         _approve(address(0), tokenId);
1996 
1997         _balances[from] -= 1;
1998         _balances[to] += 1;
1999         _owners[tokenId] = to;
2000 
2001         emit Transfer(from, to, tokenId);
2002 
2003         _afterTokenTransfer(from, to, tokenId);
2004     }
2005 
2006     /**
2007      * @dev Approve `to` to operate on `tokenId`
2008      *
2009      * Emits a {Approval} event.
2010      */
2011     function _approve(address to, uint256 tokenId) internal virtual {
2012         _tokenApprovals[tokenId] = to;
2013         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2014     }
2015 
2016     /**
2017      * @dev Approve `operator` to operate on all of `owner` tokens
2018      *
2019      * Emits a {ApprovalForAll} event.
2020      */
2021     function _setApprovalForAll(
2022         address owner,
2023         address operator,
2024         bool approved
2025     ) internal virtual {
2026         require(owner != operator, "ERC721: approve to caller");
2027         _operatorApprovals[owner][operator] = approved;
2028         emit ApprovalForAll(owner, operator, approved);
2029     }
2030 
2031     /**
2032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2033      * The call is not executed if the target address is not a contract.
2034      *
2035      * @param from address representing the previous owner of the given token ID
2036      * @param to target address that will receive the tokens
2037      * @param tokenId uint256 ID of the token to be transferred
2038      * @param _data bytes optional data to send along with the call
2039      * @return bool whether the call correctly returned the expected magic value
2040      */
2041     function _checkOnERC721Received(
2042         address from,
2043         address to,
2044         uint256 tokenId,
2045         bytes memory _data
2046     ) private returns (bool) {
2047         if (to.isContract()) {
2048             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2049                 return retval == IERC721Receiver.onERC721Received.selector;
2050             } catch (bytes memory reason) {
2051                 if (reason.length == 0) {
2052                     revert("ERC721: transfer to non ERC721Receiver implementer");
2053                 } else {
2054                     assembly {
2055                         revert(add(32, reason), mload(reason))
2056                     }
2057                 }
2058             }
2059         } else {
2060             return true;
2061         }
2062     }
2063 
2064     /**
2065      * @dev Hook that is called before any token transfer. This includes minting
2066      * and burning.
2067      *
2068      * Calling conditions:
2069      *
2070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2071      * transferred to `to`.
2072      * - When `from` is zero, `tokenId` will be minted for `to`.
2073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2074      * - `from` and `to` are never both zero.
2075      *
2076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2077      */
2078     function _beforeTokenTransfer(
2079         address from,
2080         address to,
2081         uint256 tokenId
2082     ) internal virtual {}
2083 
2084     /**
2085      * @dev Hook that is called after any transfer of tokens. This includes
2086      * minting and burning.
2087      *
2088      * Calling conditions:
2089      *
2090      * - when `from` and `to` are both non-zero.
2091      * - `from` and `to` are never both zero.
2092      *
2093      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2094      */
2095     function _afterTokenTransfer(
2096         address from,
2097         address to,
2098         uint256 tokenId
2099     ) internal virtual {}
2100 }
2101 
2102 // File: dwcDiamond721.sol
2103 
2104 pragma solidity 0.8.7;
2105 
2106 
2107 
2108 
2109 
2110 
2111 
2112 /// SPDX-License-Identifier: MIT
2113 
2114 contract DWCNFT is ERC721, Ownable, ReentrancyGuard {
2115    
2116     using Strings for uint256;
2117     using Counters for Counters.Counter;
2118 
2119     string public baseURI;
2120     string public baseExtension = ".json";
2121 
2122     ERC1155 dwcOld = ERC1155(0xB6883B3EAd6e34e0FaDA5a4441EeCA6F52ED521a);
2123 
2124     Counters.Counter private _totalTokenCounter;
2125 
2126    
2127     constructor(string memory _initBaseURI) ERC721("DWC GENESIS DIAMOND PASS", "DWCNFT")
2128     {
2129         setBaseURI(_initBaseURI);              
2130     }
2131 
2132     function swapOldForNew() public nonReentrant
2133     {
2134         uint256 oldDiamond = dwcOld.balanceOf(msg.sender, 1);
2135         require(oldDiamond > 0, "You dont have any diamond passes");
2136 
2137         dwcOld.safeTransferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, 1, oldDiamond, '');
2138         for(uint256 i=0; i<oldDiamond;i++)
2139         {
2140             _totalTokenCounter.increment();
2141             _mint(msg.sender, _totalTokenCounter.current());
2142         }
2143         
2144     }
2145 
2146     function setDwcContract(address dwcAddress) public onlyOwner
2147     {
2148         dwcOld = ERC1155(dwcAddress);
2149     }
2150 
2151     function totalSupply() public view returns (uint256) {
2152             return _totalTokenCounter.current();
2153     }
2154 
2155     function withdrawContractEther() external onlyOwner
2156     {
2157 
2158         (bool hs, ) = payable(msg.sender).call{value: address(this).balance}("");
2159         require(hs);
2160  
2161     }
2162    
2163     function _baseURI() internal view virtual override returns (string memory) {
2164         return baseURI;
2165     }
2166    
2167     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2168         baseURI = _newBaseURI;
2169     }
2170    
2171     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2172     {
2173         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2174 
2175         string memory currentBaseURI = _baseURI();
2176         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
2177     }
2178     function getBalance() public view returns(uint)
2179     {
2180         return address(this).balance;
2181     }
2182 
2183     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
2184         uint256 _balance = balanceOf(address_);
2185         uint256[] memory _tokens = new uint256[] (_balance);
2186         uint256 _index;
2187         uint256 _loopThrough = totalSupply();
2188         for (uint256 i = 0; i < _loopThrough; i++) {
2189             bool _exists = _exists(i);
2190             if (_exists) {
2191                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
2192             }
2193             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
2194         }
2195         return _tokens;
2196     }
2197     
2198    
2199 }