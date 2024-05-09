1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     enum RecoverError {
87         NoError,
88         InvalidSignature,
89         InvalidSignatureLength,
90         InvalidSignatureS,
91         InvalidSignatureV
92     }
93 
94     function _throwError(RecoverError error) private pure {
95         if (error == RecoverError.NoError) {
96             return; // no error: do nothing
97         } else if (error == RecoverError.InvalidSignature) {
98             revert("ECDSA: invalid signature");
99         } else if (error == RecoverError.InvalidSignatureLength) {
100             revert("ECDSA: invalid signature length");
101         } else if (error == RecoverError.InvalidSignatureS) {
102             revert("ECDSA: invalid signature 's' value");
103         } else if (error == RecoverError.InvalidSignatureV) {
104             revert("ECDSA: invalid signature 'v' value");
105         }
106     }
107 
108     /**
109      * @dev Returns the address that signed a hashed message (`hash`) with
110      * `signature` or error string. This address can then be used for verification purposes.
111      *
112      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
113      * this function rejects them by requiring the `s` value to be in the lower
114      * half order, and the `v` value to be either 27 or 28.
115      *
116      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
117      * verification to be secure: it is possible to craft signatures that
118      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
119      * this is by receiving a hash of the original message (which may otherwise
120      * be too long), and then calling {toEthSignedMessageHash} on it.
121      *
122      * Documentation for signature generation:
123      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
124      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
125      *
126      * _Available since v4.3._
127      */
128     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
129         // Check the signature length
130         // - case 65: r,s,v signature (standard)
131         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
132         if (signature.length == 65) {
133             bytes32 r;
134             bytes32 s;
135             uint8 v;
136             // ecrecover takes the signature parameters, and the only way to get them
137             // currently is to use assembly.
138             assembly {
139                 r := mload(add(signature, 0x20))
140                 s := mload(add(signature, 0x40))
141                 v := byte(0, mload(add(signature, 0x60)))
142             }
143             return tryRecover(hash, v, r, s);
144         } else if (signature.length == 64) {
145             bytes32 r;
146             bytes32 vs;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 vs := mload(add(signature, 0x40))
152             }
153             return tryRecover(hash, r, vs);
154         } else {
155             return (address(0), RecoverError.InvalidSignatureLength);
156         }
157     }
158 
159     /**
160      * @dev Returns the address that signed a hashed message (`hash`) with
161      * `signature`. This address can then be used for verification purposes.
162      *
163      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
164      * this function rejects them by requiring the `s` value to be in the lower
165      * half order, and the `v` value to be either 27 or 28.
166      *
167      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
168      * verification to be secure: it is possible to craft signatures that
169      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
170      * this is by receiving a hash of the original message (which may otherwise
171      * be too long), and then calling {toEthSignedMessageHash} on it.
172      */
173     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
174         (address recovered, RecoverError error) = tryRecover(hash, signature);
175         _throwError(error);
176         return recovered;
177     }
178 
179     /**
180      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
181      *
182      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
183      *
184      * _Available since v4.3._
185      */
186     function tryRecover(
187         bytes32 hash,
188         bytes32 r,
189         bytes32 vs
190     ) internal pure returns (address, RecoverError) {
191         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
192         uint8 v = uint8((uint256(vs) >> 255) + 27);
193         return tryRecover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
198      *
199      * _Available since v4.2._
200      */
201     function recover(
202         bytes32 hash,
203         bytes32 r,
204         bytes32 vs
205     ) internal pure returns (address) {
206         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
207         _throwError(error);
208         return recovered;
209     }
210 
211     /**
212      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
213      * `r` and `s` signature fields separately.
214      *
215      * _Available since v4.3._
216      */
217     function tryRecover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address, RecoverError) {
223         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
224         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
225         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
226         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
227         //
228         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
229         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
230         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
231         // these malleable signatures as well.
232         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
233             return (address(0), RecoverError.InvalidSignatureS);
234         }
235         if (v != 27 && v != 28) {
236             return (address(0), RecoverError.InvalidSignatureV);
237         }
238 
239         // If the signature is valid (and not malleable), return the signer address
240         address signer = ecrecover(hash, v, r, s);
241         if (signer == address(0)) {
242             return (address(0), RecoverError.InvalidSignature);
243         }
244 
245         return (signer, RecoverError.NoError);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `v`,
250      * `r` and `s` signature fields separately.
251      */
252     function recover(
253         bytes32 hash,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
265      * produces hash corresponding to the one signed with the
266      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
267      * JSON-RPC method as part of EIP-191.
268      *
269      * See {recover}.
270      */
271     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
272         // 32 is the length in bytes of hash,
273         // enforced by the type signature above
274         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from `s`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Typed Data, created from a
291      * `domainSeparator` and a `structHash`. This produces hash corresponding
292      * to the one signed with the
293      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
294      * JSON-RPC method as part of EIP-712.
295      *
296      * See {recover}.
297      */
298     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
300     }
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
304 
305 
306 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `to`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address to, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `from` to `to` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 amount
371     ) external returns (bool);
372 
373     /**
374      * @dev Emitted when `value` tokens are moved from one account (`from`) to
375      * another (`to`).
376      *
377      * Note that `value` may be zero.
378      */
379     event Transfer(address indexed from, address indexed to, uint256 value);
380 
381     /**
382      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
383      * a call to {approve}. `value` is the new allowance.
384      */
385     event Approval(address indexed owner, address indexed spender, uint256 value);
386 }
387 
388 // File: contracts/SN/MerkleProof.sol
389 
390 
391 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev These functions deal with verification of Merkle Trees proofs.
397  *
398  * The proofs can be generated using the JavaScript library
399  * https://github.com/miguelmota/merkletreejs[merkletreejs].
400  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
401  *
402  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
403  *
404  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
405  * hashing, or use a hash function other than keccak256 for hashing leaves.
406  * This is because the concatenation of a sorted pair of internal nodes in
407  * the merkle tree could be reinterpreted as a leaf value.
408  */
409 library MerkleProof {
410     /**
411      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
412      * defined by `root`. For this, a `proof` must be provided, containing
413      * sibling hashes on the branch from the leaf to the root of the tree. Each
414      * pair of leaves and each pair of pre-images are assumed to be sorted.
415      */
416     function verify(
417         bytes32[] memory proof,
418         bytes32 root,
419         bytes32 leaf
420     ) internal pure returns (bool) {
421         return processProof(proof, leaf) == root;
422     }
423 
424     /**
425      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
426      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
427      * hash matches the root of the tree. When processing the proof, the pairs
428      * of leafs & pre-images are assumed to be sorted.
429      *
430      * _Available since v4.4._
431      */
432     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
433         bytes32 computedHash = leaf;
434         for (uint256 i = 0; i < proof.length; i++) {
435             bytes32 proofElement = proof[i];
436             if (computedHash <= proofElement) {
437                 // Hash(current computed hash + current element of the proof)
438                 computedHash = _efficientHash(computedHash, proofElement);
439             } else {
440                 // Hash(current element of the proof + current computed hash)
441                 computedHash = _efficientHash(proofElement, computedHash);
442             }
443         }
444         return computedHash;
445     }
446 
447     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
448         assembly {
449             mstore(0x00, a)
450             mstore(0x20, b)
451             value := keccak256(0x00, 0x40)
452         }
453     }
454 }
455 // File: contracts/SN/IBatch.sol
456 
457 
458 
459 pragma solidity ^0.8.0;
460 
461 interface IBatch {
462   function isOwnerOf( address account, uint[] calldata tokenIds ) external view returns( bool );
463   function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external;
464   function walletOfOwner( address account ) external view returns( uint[] memory );
465 }
466 // File: @openzeppelin/contracts/utils/Context.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev Provides information about the current execution context, including the
475  * sender of the transaction and its data. While these are generally available
476  * via msg.sender and msg.data, they should not be accessed in such a direct
477  * manner, since when dealing with meta-transactions the account sending and
478  * paying for execution may not be the actual sender (as far as an application
479  * is concerned).
480  *
481  * This contract is only required for intermediate, library-like contracts.
482  */
483 abstract contract Context {
484     function _msgSender() internal view virtual returns (address) {
485         return msg.sender;
486     }
487 
488     function _msgData() internal view virtual returns (bytes calldata) {
489         return msg.data;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/access/Ownable.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Contract module which provides a basic access control mechanism, where
503  * there is an account (an owner) that can be granted exclusive access to
504  * specific functions.
505  *
506  * By default, the owner account will be the one that deploys the contract. This
507  * can later be changed with {transferOwnership}.
508  *
509  * This module is used through inheritance. It will make available the modifier
510  * `onlyOwner`, which can be applied to your functions to restrict their use to
511  * the owner.
512  */
513 abstract contract Ownable is Context {
514     address private _owner;
515 
516     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
517 
518     /**
519      * @dev Initializes the contract setting the deployer as the initial owner.
520      */
521     constructor() {
522         _transferOwnership(_msgSender());
523     }
524 
525     /**
526      * @dev Returns the address of the current owner.
527      */
528     function owner() public view virtual returns (address) {
529         return _owner;
530     }
531 
532     /**
533      * @dev Throws if called by any account other than the owner.
534      */
535     modifier onlyOwner() {
536         require(owner() == _msgSender(), "Ownable: caller is not the owner");
537         _;
538     }
539 
540     /**
541      * @dev Leaves the contract without owner. It will not be possible to call
542      * `onlyOwner` functions anymore. Can only be called by the current owner.
543      *
544      * NOTE: Renouncing ownership will leave the contract without an owner,
545      * thereby removing any functionality that is only available to the owner.
546      */
547     function renounceOwnership() public virtual onlyOwner {
548         _transferOwnership(address(0));
549     }
550 
551     /**
552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
553      * Can only be called by the current owner.
554      */
555     function transferOwnership(address newOwner) public virtual onlyOwner {
556         require(newOwner != address(0), "Ownable: new owner is the zero address");
557         _transferOwnership(newOwner);
558     }
559 
560     /**
561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
562      * Internal function without access restriction.
563      */
564     function _transferOwnership(address newOwner) internal virtual {
565         address oldOwner = _owner;
566         _owner = newOwner;
567         emit OwnershipTransferred(oldOwner, newOwner);
568     }
569 }
570 
571 // File: contracts/SN/Delegated.sol
572 
573 
574 
575 pragma solidity ^0.8.0;
576 
577 
578 contract Delegated is Ownable {
579   mapping(address => bool) internal _delegates;
580 
581   constructor(){
582     _delegates[owner()] = true;
583   }
584 
585   modifier onlyDelegates {
586     require(_delegates[msg.sender], "Invalid delegate" );
587     _;
588   }
589 
590   //onlyOwner
591   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
592     return _delegates[addr];
593   }
594 
595   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
596     _delegates[addr] = isDelegate_;
597   }
598 
599   function transferOwnership(address newOwner) public virtual override onlyOwner {
600     _delegates[newOwner] = true;
601     super.transferOwnership( newOwner );
602   }
603 }
604 // File: @openzeppelin/contracts/utils/Address.sol
605 
606 
607 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
608 
609 pragma solidity ^0.8.1;
610 
611 /**
612  * @dev Collection of functions related to the address type
613  */
614 library Address {
615     /**
616      * @dev Returns true if `account` is a contract.
617      *
618      * [IMPORTANT]
619      * ====
620      * It is unsafe to assume that an address for which this function returns
621      * false is an externally-owned account (EOA) and not a contract.
622      *
623      * Among others, `isContract` will return false for the following
624      * types of addresses:
625      *
626      *  - an externally-owned account
627      *  - a contract in construction
628      *  - an address where a contract will be created
629      *  - an address where a contract lived, but was destroyed
630      * ====
631      *
632      * [IMPORTANT]
633      * ====
634      * You shouldn't rely on `isContract` to protect against flash loan attacks!
635      *
636      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
637      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
638      * constructor.
639      * ====
640      */
641     function isContract(address account) internal view returns (bool) {
642         // This method relies on extcodesize/address.code.length, which returns 0
643         // for contracts in construction, since the code is only stored at the end
644         // of the constructor execution.
645 
646         return account.code.length > 0;
647     }
648 
649     /**
650      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
651      * `recipient`, forwarding all available gas and reverting on errors.
652      *
653      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
654      * of certain opcodes, possibly making contracts go over the 2300 gas limit
655      * imposed by `transfer`, making them unable to receive funds via
656      * `transfer`. {sendValue} removes this limitation.
657      *
658      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
659      *
660      * IMPORTANT: because control is transferred to `recipient`, care must be
661      * taken to not create reentrancy vulnerabilities. Consider using
662      * {ReentrancyGuard} or the
663      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
664      */
665     function sendValue(address payable recipient, uint256 amount) internal {
666         require(address(this).balance >= amount, "Address: insufficient balance");
667 
668         (bool success, ) = recipient.call{value: amount}("");
669         require(success, "Address: unable to send value, recipient may have reverted");
670     }
671 
672     /**
673      * @dev Performs a Solidity function call using a low level `call`. A
674      * plain `call` is an unsafe replacement for a function call: use this
675      * function instead.
676      *
677      * If `target` reverts with a revert reason, it is bubbled up by this
678      * function (like regular Solidity function calls).
679      *
680      * Returns the raw returned data. To convert to the expected return value,
681      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
682      *
683      * Requirements:
684      *
685      * - `target` must be a contract.
686      * - calling `target` with `data` must not revert.
687      *
688      * _Available since v3.1._
689      */
690     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
691         return functionCall(target, data, "Address: low-level call failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
696      * `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCall(
701         address target,
702         bytes memory data,
703         string memory errorMessage
704     ) internal returns (bytes memory) {
705         return functionCallWithValue(target, data, 0, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but also transferring `value` wei to `target`.
711      *
712      * Requirements:
713      *
714      * - the calling contract must have an ETH balance of at least `value`.
715      * - the called Solidity function must be `payable`.
716      *
717      * _Available since v3.1._
718      */
719     function functionCallWithValue(
720         address target,
721         bytes memory data,
722         uint256 value
723     ) internal returns (bytes memory) {
724         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
729      * with `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCallWithValue(
734         address target,
735         bytes memory data,
736         uint256 value,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         require(address(this).balance >= value, "Address: insufficient balance for call");
740         require(isContract(target), "Address: call to non-contract");
741 
742         (bool success, bytes memory returndata) = target.call{value: value}(data);
743         return verifyCallResult(success, returndata, errorMessage);
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
748      * but performing a static call.
749      *
750      * _Available since v3.3._
751      */
752     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
753         return functionStaticCall(target, data, "Address: low-level static call failed");
754     }
755 
756     /**
757      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
758      * but performing a static call.
759      *
760      * _Available since v3.3._
761      */
762     function functionStaticCall(
763         address target,
764         bytes memory data,
765         string memory errorMessage
766     ) internal view returns (bytes memory) {
767         require(isContract(target), "Address: static call to non-contract");
768 
769         (bool success, bytes memory returndata) = target.staticcall(data);
770         return verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a delegate call.
776      *
777      * _Available since v3.4._
778      */
779     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
780         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a delegate call.
786      *
787      * _Available since v3.4._
788      */
789     function functionDelegateCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal returns (bytes memory) {
794         require(isContract(target), "Address: delegate call to non-contract");
795 
796         (bool success, bytes memory returndata) = target.delegatecall(data);
797         return verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
802      * revert reason using the provided one.
803      *
804      * _Available since v4.3._
805      */
806     function verifyCallResult(
807         bool success,
808         bytes memory returndata,
809         string memory errorMessage
810     ) internal pure returns (bytes memory) {
811         if (success) {
812             return returndata;
813         } else {
814             // Look for revert reason and bubble it up if present
815             if (returndata.length > 0) {
816                 // The easiest way to bubble the revert reason is using memory via assembly
817 
818                 assembly {
819                     let returndata_size := mload(returndata)
820                     revert(add(32, returndata), returndata_size)
821                 }
822             } else {
823                 revert(errorMessage);
824             }
825         }
826     }
827 }
828 
829 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
830 
831 
832 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
833 
834 pragma solidity ^0.8.0;
835 
836 
837 
838 /**
839  * @title SafeERC20
840  * @dev Wrappers around ERC20 operations that throw on failure (when the token
841  * contract returns false). Tokens that return no value (and instead revert or
842  * throw on failure) are also supported, non-reverting calls are assumed to be
843  * successful.
844  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
845  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
846  */
847 library SafeERC20 {
848     using Address for address;
849 
850     function safeTransfer(
851         IERC20 token,
852         address to,
853         uint256 value
854     ) internal {
855         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
856     }
857 
858     function safeTransferFrom(
859         IERC20 token,
860         address from,
861         address to,
862         uint256 value
863     ) internal {
864         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
865     }
866 
867     /**
868      * @dev Deprecated. This function has issues similar to the ones found in
869      * {IERC20-approve}, and its usage is discouraged.
870      *
871      * Whenever possible, use {safeIncreaseAllowance} and
872      * {safeDecreaseAllowance} instead.
873      */
874     function safeApprove(
875         IERC20 token,
876         address spender,
877         uint256 value
878     ) internal {
879         // safeApprove should only be called when setting an initial allowance,
880         // or when resetting it to zero. To increase and decrease it, use
881         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
882         require(
883             (value == 0) || (token.allowance(address(this), spender) == 0),
884             "SafeERC20: approve from non-zero to non-zero allowance"
885         );
886         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
887     }
888 
889     function safeIncreaseAllowance(
890         IERC20 token,
891         address spender,
892         uint256 value
893     ) internal {
894         uint256 newAllowance = token.allowance(address(this), spender) + value;
895         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
896     }
897 
898     function safeDecreaseAllowance(
899         IERC20 token,
900         address spender,
901         uint256 value
902     ) internal {
903         unchecked {
904             uint256 oldAllowance = token.allowance(address(this), spender);
905             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
906             uint256 newAllowance = oldAllowance - value;
907             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
908         }
909     }
910 
911     /**
912      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
913      * on the return value: the return value is optional (but if data is returned, it must not be false).
914      * @param token The token targeted by the call.
915      * @param data The call data (encoded using abi.encode or one of its variants).
916      */
917     function _callOptionalReturn(IERC20 token, bytes memory data) private {
918         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
919         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
920         // the target address contains contract code and also asserts for success in the low-level call.
921 
922         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
923         if (returndata.length > 0) {
924             // Return data is optional
925             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
926         }
927     }
928 }
929 
930 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
931 
932 
933 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
934 
935 pragma solidity ^0.8.0;
936 
937 
938 
939 
940 /**
941  * @title PaymentSplitter
942  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
943  * that the Ether will be split in this way, since it is handled transparently by the contract.
944  *
945  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
946  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
947  * an amount proportional to the percentage of total shares they were assigned.
948  *
949  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
950  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
951  * function.
952  *
953  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
954  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
955  * to run tests before sending real value to this contract.
956  */
957 contract PaymentSplitter is Context {
958     event PayeeAdded(address account, uint256 shares);
959     event PaymentReleased(address to, uint256 amount);
960     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
961     event PaymentReceived(address from, uint256 amount);
962 
963     uint256 private _totalShares;
964     uint256 private _totalReleased;
965 
966     mapping(address => uint256) private _shares;
967     mapping(address => uint256) private _released;
968     address[] private _payees;
969 
970     mapping(IERC20 => uint256) private _erc20TotalReleased;
971     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
972 
973     /**
974      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
975      * the matching position in the `shares` array.
976      *
977      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
978      * duplicates in `payees`.
979      */
980     constructor(address[] memory payees, uint256[] memory shares_) payable {
981         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
982         require(payees.length > 0, "PaymentSplitter: no payees");
983 
984         for (uint256 i = 0; i < payees.length; i++) {
985             _addPayee(payees[i], shares_[i]);
986         }
987     }
988 
989     /**
990      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
991      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
992      * reliability of the events, and not the actual splitting of Ether.
993      *
994      * To learn more about this see the Solidity documentation for
995      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
996      * functions].
997      */
998     receive() external payable virtual {
999         emit PaymentReceived(_msgSender(), msg.value);
1000     }
1001 
1002     /**
1003      * @dev Getter for the total shares held by payees.
1004      */
1005     function totalShares() public view returns (uint256) {
1006         return _totalShares;
1007     }
1008 
1009     /**
1010      * @dev Getter for the total amount of Ether already released.
1011      */
1012     function totalReleased() public view returns (uint256) {
1013         return _totalReleased;
1014     }
1015 
1016     /**
1017      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1018      * contract.
1019      */
1020     function totalReleased(IERC20 token) public view returns (uint256) {
1021         return _erc20TotalReleased[token];
1022     }
1023 
1024     /**
1025      * @dev Getter for the amount of shares held by an account.
1026      */
1027     function shares(address account) public view returns (uint256) {
1028         return _shares[account];
1029     }
1030 
1031     /**
1032      * @dev Getter for the amount of Ether already released to a payee.
1033      */
1034     function released(address account) public view returns (uint256) {
1035         return _released[account];
1036     }
1037 
1038     /**
1039      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1040      * IERC20 contract.
1041      */
1042     function released(IERC20 token, address account) public view returns (uint256) {
1043         return _erc20Released[token][account];
1044     }
1045 
1046     /**
1047      * @dev Getter for the address of the payee number `index`.
1048      */
1049     function payee(uint256 index) public view returns (address) {
1050         return _payees[index];
1051     }
1052 
1053     /**
1054      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1055      * total shares and their previous withdrawals.
1056      */
1057     function release(address payable account) public virtual {
1058         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1059 
1060         uint256 totalReceived = address(this).balance + totalReleased();
1061         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1062 
1063         require(payment != 0, "PaymentSplitter: account is not due payment");
1064 
1065         _released[account] += payment;
1066         _totalReleased += payment;
1067 
1068         Address.sendValue(account, payment);
1069         emit PaymentReleased(account, payment);
1070     }
1071 
1072     /**
1073      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1074      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1075      * contract.
1076      */
1077     function release(IERC20 token, address account) public virtual {
1078         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1079 
1080         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1081         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1082 
1083         require(payment != 0, "PaymentSplitter: account is not due payment");
1084 
1085         _erc20Released[token][account] += payment;
1086         _erc20TotalReleased[token] += payment;
1087 
1088         SafeERC20.safeTransfer(token, account, payment);
1089         emit ERC20PaymentReleased(token, account, payment);
1090     }
1091 
1092     /**
1093      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1094      * already released amounts.
1095      */
1096     function _pendingPayment(
1097         address account,
1098         uint256 totalReceived,
1099         uint256 alreadyReleased
1100     ) private view returns (uint256) {
1101         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1102     }
1103 
1104     /**
1105      * @dev Add a new payee to the contract.
1106      * @param account The address of the payee to add.
1107      * @param shares_ The number of shares owned by the payee.
1108      */
1109     function _addPayee(address account, uint256 shares_) private {
1110         require(account != address(0), "PaymentSplitter: account is the zero address");
1111         require(shares_ > 0, "PaymentSplitter: shares are 0");
1112         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1113 
1114         _payees.push(account);
1115         _shares[account] = shares_;
1116         _totalShares = _totalShares + shares_;
1117         emit PayeeAdded(account, shares_);
1118     }
1119 }
1120 
1121 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1122 
1123 
1124 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 /**
1129  * @title ERC721 token receiver interface
1130  * @dev Interface for any contract that wants to support safeTransfers
1131  * from ERC721 asset contracts.
1132  */
1133 interface IERC721Receiver {
1134     /**
1135      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1136      * by `operator` from `from`, this function is called.
1137      *
1138      * It must return its Solidity selector to confirm the token transfer.
1139      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1140      *
1141      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1142      */
1143     function onERC721Received(
1144         address operator,
1145         address from,
1146         uint256 tokenId,
1147         bytes calldata data
1148     ) external returns (bytes4);
1149 }
1150 
1151 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1152 
1153 
1154 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 /**
1159  * @dev Interface of the ERC165 standard, as defined in the
1160  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1161  *
1162  * Implementers can declare support of contract interfaces, which can then be
1163  * queried by others ({ERC165Checker}).
1164  *
1165  * For an implementation, see {ERC165}.
1166  */
1167 interface IERC165 {
1168     /**
1169      * @dev Returns true if this contract implements the interface defined by
1170      * `interfaceId`. See the corresponding
1171      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1172      * to learn more about how these ids are created.
1173      *
1174      * This function call must use less than 30 000 gas.
1175      */
1176     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1177 }
1178 
1179 // File: @openzeppelin/contracts/interfaces/IERC165.sol
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1188 
1189 
1190 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @dev Interface for the NFT Royalty Standard.
1197  *
1198  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1199  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1200  *
1201  * _Available since v4.5._
1202  */
1203 interface IERC2981 is IERC165 {
1204     /**
1205      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1206      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1207      */
1208     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1209         external
1210         view
1211         returns (address receiver, uint256 royaltyAmount);
1212 }
1213 
1214 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1215 
1216 
1217 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 
1222 /**
1223  * @dev Implementation of the {IERC165} interface.
1224  *
1225  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1226  * for the additional interface id that will be supported. For example:
1227  *
1228  * ```solidity
1229  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1230  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1231  * }
1232  * ```
1233  *
1234  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1235  */
1236 abstract contract ERC165 is IERC165 {
1237     /**
1238      * @dev See {IERC165-supportsInterface}.
1239      */
1240     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1241         return interfaceId == type(IERC165).interfaceId;
1242     }
1243 }
1244 
1245 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1246 
1247 
1248 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 
1254 /**
1255  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1256  *
1257  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1258  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1259  *
1260  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1261  * fee is specified in basis points by default.
1262  *
1263  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1264  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1265  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1266  *
1267  * _Available since v4.5._
1268  */
1269 abstract contract ERC2981 is IERC2981, ERC165 {
1270     struct RoyaltyInfo {
1271         address receiver;
1272         uint96 royaltyFraction;
1273     }
1274 
1275     RoyaltyInfo private _defaultRoyaltyInfo;
1276     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1277 
1278     /**
1279      * @dev See {IERC165-supportsInterface}.
1280      */
1281     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1282         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1283     }
1284 
1285     /**
1286      * @inheritdoc IERC2981
1287      */
1288     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1289         external
1290         view
1291         virtual
1292         override
1293         returns (address, uint256)
1294     {
1295         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1296 
1297         if (royalty.receiver == address(0)) {
1298             royalty = _defaultRoyaltyInfo;
1299         }
1300 
1301         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1302 
1303         return (royalty.receiver, royaltyAmount);
1304     }
1305 
1306     /**
1307      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1308      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1309      * override.
1310      */
1311     function _feeDenominator() internal pure virtual returns (uint96) {
1312         return 10000;
1313     }
1314 
1315     /**
1316      * @dev Sets the royalty information that all ids in this contract will default to.
1317      *
1318      * Requirements:
1319      *
1320      * - `receiver` cannot be the zero address.
1321      * - `feeNumerator` cannot be greater than the fee denominator.
1322      */
1323     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1324         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1325         require(receiver != address(0), "ERC2981: invalid receiver");
1326 
1327         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1328     }
1329 
1330     /**
1331      * @dev Removes default royalty information.
1332      */
1333     function _deleteDefaultRoyalty() internal virtual {
1334         delete _defaultRoyaltyInfo;
1335     }
1336 
1337     /**
1338      * @dev Sets the royalty information for a specific token id, overriding the global default.
1339      *
1340      * Requirements:
1341      *
1342      * - `tokenId` must be already minted.
1343      * - `receiver` cannot be the zero address.
1344      * - `feeNumerator` cannot be greater than the fee denominator.
1345      */
1346     function _setTokenRoyalty(
1347         uint256 tokenId,
1348         address receiver,
1349         uint96 feeNumerator
1350     ) internal virtual {
1351         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1352         require(receiver != address(0), "ERC2981: Invalid parameters");
1353 
1354         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1355     }
1356 
1357     /**
1358      * @dev Resets royalty information for the token id back to the global default.
1359      */
1360     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1361         delete _tokenRoyaltyInfo[tokenId];
1362     }
1363 }
1364 
1365 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1366 
1367 
1368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 
1373 /**
1374  * @dev Required interface of an ERC721 compliant contract.
1375  */
1376 interface IERC721 is IERC165 {
1377     /**
1378      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1379      */
1380     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1381 
1382     /**
1383      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1384      */
1385     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1386 
1387     /**
1388      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1389      */
1390     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1391 
1392     /**
1393      * @dev Returns the number of tokens in ``owner``'s account.
1394      */
1395     function balanceOf(address owner) external view returns (uint256 balance);
1396 
1397     /**
1398      * @dev Returns the owner of the `tokenId` token.
1399      *
1400      * Requirements:
1401      *
1402      * - `tokenId` must exist.
1403      */
1404     function ownerOf(uint256 tokenId) external view returns (address owner);
1405 
1406     /**
1407      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1408      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1409      *
1410      * Requirements:
1411      *
1412      * - `from` cannot be the zero address.
1413      * - `to` cannot be the zero address.
1414      * - `tokenId` token must exist and be owned by `from`.
1415      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function safeTransferFrom(
1421         address from,
1422         address to,
1423         uint256 tokenId
1424     ) external;
1425 
1426     /**
1427      * @dev Transfers `tokenId` token from `from` to `to`.
1428      *
1429      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1430      *
1431      * Requirements:
1432      *
1433      * - `from` cannot be the zero address.
1434      * - `to` cannot be the zero address.
1435      * - `tokenId` token must be owned by `from`.
1436      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1437      *
1438      * Emits a {Transfer} event.
1439      */
1440     function transferFrom(
1441         address from,
1442         address to,
1443         uint256 tokenId
1444     ) external;
1445 
1446     /**
1447      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1448      * The approval is cleared when the token is transferred.
1449      *
1450      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1451      *
1452      * Requirements:
1453      *
1454      * - The caller must own the token or be an approved operator.
1455      * - `tokenId` must exist.
1456      *
1457      * Emits an {Approval} event.
1458      */
1459     function approve(address to, uint256 tokenId) external;
1460 
1461     /**
1462      * @dev Returns the account approved for `tokenId` token.
1463      *
1464      * Requirements:
1465      *
1466      * - `tokenId` must exist.
1467      */
1468     function getApproved(uint256 tokenId) external view returns (address operator);
1469 
1470     /**
1471      * @dev Approve or remove `operator` as an operator for the caller.
1472      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1473      *
1474      * Requirements:
1475      *
1476      * - The `operator` cannot be the caller.
1477      *
1478      * Emits an {ApprovalForAll} event.
1479      */
1480     function setApprovalForAll(address operator, bool _approved) external;
1481 
1482     /**
1483      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1484      *
1485      * See {setApprovalForAll}
1486      */
1487     function isApprovedForAll(address owner, address operator) external view returns (bool);
1488 
1489     /**
1490      * @dev Safely transfers `tokenId` token from `from` to `to`.
1491      *
1492      * Requirements:
1493      *
1494      * - `from` cannot be the zero address.
1495      * - `to` cannot be the zero address.
1496      * - `tokenId` token must exist and be owned by `from`.
1497      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1498      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1499      *
1500      * Emits a {Transfer} event.
1501      */
1502     function safeTransferFrom(
1503         address from,
1504         address to,
1505         uint256 tokenId,
1506         bytes calldata data
1507     ) external;
1508 }
1509 
1510 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1511 
1512 
1513 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 
1518 /**
1519  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1520  * @dev See https://eips.ethereum.org/EIPS/eip-721
1521  */
1522 interface IERC721Enumerable is IERC721 {
1523     /**
1524      * @dev Returns the total amount of tokens stored by the contract.
1525      */
1526     function totalSupply() external view returns (uint256);
1527 
1528     /**
1529      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1530      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1531      */
1532     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1533 
1534     /**
1535      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1536      * Use along with {totalSupply} to enumerate all tokens.
1537      */
1538     function tokenByIndex(uint256 index) external view returns (uint256);
1539 }
1540 
1541 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1542 
1543 
1544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 
1549 /**
1550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1551  * @dev See https://eips.ethereum.org/EIPS/eip-721
1552  */
1553 interface IERC721Metadata is IERC721 {
1554     /**
1555      * @dev Returns the token collection name.
1556      */
1557     function name() external view returns (string memory);
1558 
1559     /**
1560      * @dev Returns the token collection symbol.
1561      */
1562     function symbol() external view returns (string memory);
1563 
1564     /**
1565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1566      */
1567     function tokenURI(uint256 tokenId) external view returns (string memory);
1568 }
1569 
1570 // File: contracts/SN/ERC721B.sol
1571 
1572 
1573 
1574 pragma solidity ^0.8.0;
1575 
1576 
1577 
1578 
1579 
1580 
1581 
1582 
1583 
1584 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata, ERC2981 {
1585     using Address for address;
1586 
1587     string private _name;
1588     string private _symbol;
1589 
1590     // Mapping from token ID to owner address
1591     address[] internal _owners;
1592 
1593     // Mapping from token ID to approved address
1594     mapping(uint256 => address) private _tokenApprovals;
1595 
1596     // Mapping from owner to operator approvals
1597     mapping(address => mapping(address => bool)) private _operatorApprovals;
1598 
1599     /**
1600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1601      */
1602     constructor(string memory name_, string memory symbol_) {
1603         _name = name_;
1604         _symbol = symbol_;
1605     }
1606 
1607     //public
1608     function balanceOf(address owner) public view virtual override returns (uint256) {
1609         require(owner != address(0), "ERC721: balance query for the zero address");
1610 
1611         uint count = 0;
1612         uint length = _owners.length;
1613         for( uint i = 0; i < length; ++i ){
1614           if( owner == _owners[i] )
1615             ++count;
1616         }
1617         return count;
1618     }
1619 
1620     function name() public view virtual override returns (string memory) {
1621         return _name;
1622     }
1623 
1624     function next() public view returns( uint ){
1625         return _owners.length;
1626     }
1627 
1628     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1629         address owner = _owners[tokenId];
1630         require(owner != address(0), "ERC721: owner query for nonexistent token");
1631         return owner;
1632     }
1633 
1634     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165, ERC2981) returns (bool) {
1635         return
1636             interfaceId == type(IERC721).interfaceId ||
1637             interfaceId == type(IERC721Metadata).interfaceId ||
1638             interfaceId == type(ERC2981).interfaceId ||
1639             super.supportsInterface(interfaceId);
1640     }
1641 
1642     function symbol() public view virtual override returns (string memory) {
1643         return _symbol;
1644     }
1645 
1646     function approve(address to, uint256 tokenId) public virtual override {
1647         address owner = ERC721B.ownerOf(tokenId);
1648         require(to != owner, "ERC721: approval to current owner");
1649 
1650         require(
1651             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1652             "ERC721: approve caller is not owner nor approved for all"
1653         );
1654 
1655         _approve(to, tokenId);
1656     }
1657 
1658     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1659         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1660         return _tokenApprovals[tokenId];
1661     }
1662 
1663     function setApprovalForAll(address operator, bool approved) public virtual override {
1664         require(operator != _msgSender(), "ERC721: approve to caller");
1665         _operatorApprovals[_msgSender()][operator] = approved;
1666         emit ApprovalForAll(_msgSender(), operator, approved);
1667     }
1668 
1669     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1670         return _operatorApprovals[owner][operator];
1671     }
1672 
1673     function transferFrom(
1674         address from,
1675         address to,
1676         uint256 tokenId
1677     ) public virtual override {
1678         //solhint-disable-next-line max-line-length
1679         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1680         _transfer(from, to, tokenId);
1681     }
1682 
1683     /**
1684      * @dev See {IERC721-safeTransferFrom}.
1685      */
1686     function safeTransferFrom(
1687         address from,
1688         address to,
1689         uint256 tokenId
1690     ) public virtual override {
1691         safeTransferFrom(from, to, tokenId, "");
1692     }
1693 
1694     /**
1695      * @dev See {IERC721-safeTransferFrom}.
1696      */
1697     function safeTransferFrom(
1698         address from,
1699         address to,
1700         uint256 tokenId,
1701         bytes memory _data
1702     ) public virtual override {
1703         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1704         _safeTransfer(from, to, tokenId, _data);
1705     }
1706 
1707     //internal
1708     function _safeTransfer(
1709         address from,
1710         address to,
1711         uint256 tokenId,
1712         bytes memory _data
1713     ) internal virtual {
1714         _transfer(from, to, tokenId);
1715         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1716     }
1717 
1718     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1719         return tokenId < _owners.length && _owners[tokenId] != address(0);
1720     }
1721 
1722     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1723         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1724         address owner = ERC721B.ownerOf(tokenId);
1725         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1726     }
1727 
1728     function _safeMint(address to, uint256 tokenId) internal virtual {
1729         _safeMint(to, tokenId, "");
1730     }
1731 
1732     function _safeMint(
1733         address to,
1734         uint256 tokenId,
1735         bytes memory _data
1736     ) internal virtual {
1737         _mint(to, tokenId);
1738         require(
1739             _checkOnERC721Received(address(0), to, tokenId, _data),
1740             "ERC721: transfer to non ERC721Receiver implementer"
1741         );
1742     }
1743 
1744     function _mint(address to, uint256 tokenId) internal virtual {
1745         require(to != address(0), "ERC721: mint to the zero address");
1746         require(!_exists(tokenId), "ERC721: token already minted");
1747 
1748         _beforeTokenTransfer(address(0), to, tokenId);
1749         _owners.push(to);
1750 
1751         emit Transfer(address(0), to, tokenId);
1752     }
1753 
1754     function _burn(uint256 tokenId) internal virtual {
1755         address owner = ERC721B.ownerOf(tokenId);
1756 
1757         _beforeTokenTransfer(owner, address(0), tokenId);
1758 
1759         // Clear approvals
1760         _approve(address(0), tokenId);
1761         _owners[tokenId] = address(0);
1762         _resetTokenRoyalty(tokenId);
1763 
1764         emit Transfer(owner, address(0), tokenId);
1765     }
1766 
1767     function _transfer(
1768         address from,
1769         address to,
1770         uint256 tokenId
1771     ) internal virtual {
1772         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1773         require(to != address(0), "ERC721: transfer to the zero address");
1774 
1775         _beforeTokenTransfer(from, to, tokenId);
1776 
1777         // Clear approvals from the previous owner
1778         _approve(address(0), tokenId);
1779         _owners[tokenId] = to;
1780 
1781         emit Transfer(from, to, tokenId);
1782     }
1783 
1784     function _approve(address to, uint256 tokenId) internal virtual {
1785         _tokenApprovals[tokenId] = to;
1786         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1787     }
1788 
1789     function _checkOnERC721Received(
1790         address from,
1791         address to,
1792         uint256 tokenId,
1793         bytes memory _data
1794     ) private returns (bool) {
1795         if (to.isContract()) {
1796             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1797                 return retval == IERC721Receiver.onERC721Received.selector;
1798             } catch (bytes memory reason) {
1799                 if (reason.length == 0) {
1800                     revert("ERC721: transfer to non ERC721Receiver implementer");
1801                 } else {
1802                     assembly {
1803                         revert(add(32, reason), mload(reason))
1804                     }
1805                 }
1806             }
1807         } else {
1808             return true;
1809         }
1810     }
1811 
1812     function _beforeTokenTransfer(
1813         address from,
1814         address to,
1815         uint256 tokenId
1816     ) internal virtual {}
1817 }
1818 // File: contracts/SN/ERC721EnumerableLite.sol
1819 
1820 
1821 
1822 pragma solidity ^0.8.0;
1823 
1824 
1825 
1826 
1827 abstract contract ERC721EnumerableLite is ERC721B, IBatch, IERC721Enumerable {
1828     function isOwnerOf( address account, uint[] calldata tokenIds ) external view override returns( bool ){
1829         for(uint i; i < tokenIds.length; ++i ){
1830             if( _owners[ tokenIds[i] ] != account )
1831                 return false;
1832         }
1833 
1834         return true;
1835     }
1836 
1837     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1838         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1839     }
1840 
1841     function tokenOfOwnerByIndex(address owner, uint index) public view override returns (uint tokenId) {
1842         uint count;
1843         for( uint i; i < _owners.length; ++i ){
1844             if( owner == _owners[i] ){
1845                 if( count == index )
1846                     return i;
1847                 else
1848                     ++count;
1849             }
1850         }
1851 
1852         require(false, "ERC721Enumerable: owner index out of bounds");
1853     }
1854 
1855     function tokenByIndex(uint index) external view virtual override returns (uint) {
1856         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1857         return index;
1858     }
1859 
1860     function totalSupply() public view virtual override returns (uint) {
1861         return _owners.length;
1862     }
1863 
1864     function transferBatch( address from, address to, uint[] calldata tokenIds, bytes calldata data ) external override{
1865         for(uint i; i < tokenIds.length; ++i ){
1866             safeTransferFrom( from, to, tokenIds[i], data );
1867         }
1868     }
1869 
1870     function walletOfOwner( address account ) external view override returns( uint[] memory ){
1871         uint quantity = balanceOf( account );
1872         uint[] memory wallet = new uint[]( quantity );
1873         for( uint i; i < quantity; ++i ){
1874             wallet[i] = tokenOfOwnerByIndex( account, i );
1875         }
1876         return wallet;
1877     }
1878 }
1879 // File: contracts/LeisureProject.sol
1880 
1881 
1882 
1883 pragma solidity ^0.8.0;
1884 
1885 
1886 
1887 
1888 
1889 
1890 
1891 contract LeisureProject is ERC721EnumerableLite, Delegated, PaymentSplitter {
1892     using Strings for uint;
1893     using ECDSA for bytes32;
1894 
1895     uint public PRICE = 0.08 ether;
1896     uint public MAX_TOKENS_PER_TRANSACTION = 4;
1897     uint public WL_MAX_TOKENS_PER_ADDRESS = 4;
1898     uint public MAX_SUPPLY = 4567;
1899 
1900     string public _baseTokenURI = 'https://gateway.pinata.cloud/ipfs/QmbKHFiYX3fdzQk8ZMKRiyuawXHFbevR8CaEGmx7mw1rEx/'; // Test ipfs
1901     string public _baseTokenSuffix = '.json';
1902 
1903     bool public _paused = true;
1904     bool public _isPresale = true;
1905 
1906     bytes32 public _presaleRoot = 0x2c3e731df3270d48c2150d646491ca63dab631047f0acc00ce2918e551ac0559;    // Merkle root
1907 
1908     address _crossmintAddress = 0xdAb1a1854214684acE522439684a145E62505233;
1909     address _royaltyAddress = 0xdCE0C51dA30Ac60Ceea41Bab798Cd032d33eFa48; // Leisure Secondary
1910 
1911     // Mapping owner address to wl mint count 
1912     mapping(address => uint) private _presaleMintCount;
1913 
1914     // Withdrawal addresses
1915     address dev = 0x05d3a5E0F1F622a15D5c333EEa9034F61890A87D;
1916     address project = 0x909738543e48E665551D46d62C79bc42F827d46a; // leisureproject.eth
1917     address community = 0xdbcb1BC2491B40Aebe468d3942841645ECb0bB6c; // leisurecreatures.eth
1918     address art1 = 0xd39b57DfDE1EfDEaF86Fd6b207352Ad36488dB92;
1919     address art2 = 0xF12C75DFB47B44471eDe4Df21C8eb20B26D37108;
1920     address art3 = 0x3ad257DD5E4D9B9773502C0f08Cb1029264D903A;
1921     address will = 0x7fa1359BA6837D903f895B48A9cc19Ff383DC3f0;
1922 
1923     address[] addressList = [dev, project, community, art1, art2, art3, will];
1924     uint[] primaryShares = [49, 800, 100, 30, 10, 1, 10];
1925 
1926     constructor()
1927     ERC721B("Leisure Creatures", "LEISURE")
1928     PaymentSplitter(addressList, primaryShares)  {
1929         _setDefaultRoyalty(_royaltyAddress, 1000);
1930     }
1931 
1932     function presaleMint(uint _count, bytes32[] calldata _proof) external payable {
1933         require( _count <= MAX_TOKENS_PER_TRANSACTION, "Count exceeded max tokens per transaction." );
1934         require( !_paused, "Sale is currently paused." );
1935         require( _isPresale, "Pre sale already ended.");
1936 
1937         uint supply = totalSupply();
1938         require( supply + _count <= MAX_SUPPLY, "Exceeds max supply." );
1939         require( msg.value >= PRICE * _count, "Ether sent is not correct." );
1940 
1941         require(_presaleMintCount[msg.sender] + _count <= WL_MAX_TOKENS_PER_ADDRESS, "Mint count exceeds the allowed presale count");
1942 
1943         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1944         require(MerkleProof.verify(_proof,_presaleRoot,leaf), "Invalid Proof/Root/Leaf");
1945 
1946         for(uint i = 0; i < _count; ++i) {
1947             _safeMint( msg.sender, supply + i, "" );
1948         }
1949 
1950         _presaleMintCount[msg.sender] += _count;
1951     }
1952 
1953     function mint(uint _count) external payable {
1954         require( _count <= MAX_TOKENS_PER_TRANSACTION, "Count exceeded max tokens per transaction." );
1955         require( !_paused, "Sale is currently paused." );
1956         require( !_isPresale, "Public sale has not started." );
1957 
1958         uint supply = totalSupply();
1959         require( supply + _count <= MAX_SUPPLY, "Exceeds max supply." );
1960         require( msg.value >= PRICE * _count, "Ether sent is not correct." );
1961 
1962         for(uint i = 0; i < _count; ++i){
1963             _safeMint( msg.sender, supply + i, "" );
1964         }
1965     }
1966 
1967     function crossmint(address to, uint _count) external payable {
1968         require(msg.sender == _crossmintAddress, "This function is for Crossmint only.");
1969         require(to != address(0x0), "Destination address should be valid");
1970         require( _count <= MAX_TOKENS_PER_TRANSACTION, "Count exceeded max tokens per transaction." );
1971         require( !_paused, "Sale is currently paused." );
1972         require( !_isPresale, "Public sale has not started." );
1973         
1974         uint supply = totalSupply();
1975         require( supply + _count <= MAX_SUPPLY, "Exceeds max supply.");
1976         require( msg.value >= PRICE * _count, "Ether sent is not correct.");
1977 
1978         for(uint i = 0; i < _count; ++i){
1979             _safeMint( to, supply + i, "" );
1980         }
1981     } 
1982 
1983     function mintTo(uint[] calldata quantity, address[] calldata recipient) external payable onlyDelegates {
1984         require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1985 
1986         uint totalQuantity;
1987         uint supply = totalSupply();
1988         for(uint i; i < quantity.length; ++i){
1989             totalQuantity += quantity[i];
1990         }
1991         require( supply + totalQuantity < MAX_SUPPLY, "Mint/order exceeds supply" );
1992 
1993         for(uint i; i < recipient.length; ++i){
1994             for(uint j; j < quantity[i]; ++j){
1995                 _safeMint( recipient[i], supply++, "" );
1996             }
1997         }
1998     }
1999 
2000     function setPrice(uint _newPrice) external onlyDelegates {
2001         PRICE = _newPrice;
2002     }
2003 
2004     function setMaxSupply (uint _newMaxSupply) external onlyDelegates { 
2005         require( _newMaxSupply >= totalSupply(), "Specified supply is lower than current balance" );
2006         MAX_SUPPLY = _newMaxSupply;
2007     }
2008 
2009     function setMaxMintAmount(uint _newMaxTokensPerTransaction) public onlyDelegates {
2010         MAX_TOKENS_PER_TRANSACTION = _newMaxTokensPerTransaction;
2011     }
2012 
2013     function updatePause(bool _updatePaused) public onlyDelegates {
2014         require( _paused != _updatePaused, "New value matches old" );
2015         _paused = _updatePaused;
2016     }
2017 
2018     function updatePresale(bool _updatePresale) public onlyDelegates {
2019         require( _isPresale != _updatePresale, "New value matches old" );
2020         _isPresale = _updatePresale;
2021     }
2022 
2023     function updateRoot(bytes32 _root) external onlyDelegates {
2024         require(!_paused, "Minting should be paused");
2025         _presaleRoot = _root;
2026     }
2027 
2028     function updateRoyaltyAddress(address royaltyAddress) external onlyDelegates {
2029         require(!_paused, "Minting should be paused");
2030         _royaltyAddress = royaltyAddress;
2031     }
2032 
2033     function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates {
2034         _baseTokenURI = _newBaseURI;
2035         _baseTokenSuffix = _newSuffix;
2036     }
2037 
2038     function tokenURI(uint tokenId) external override view returns (string memory) {
2039         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2040 
2041         string memory baseURI = _baseTokenURI;
2042         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), _baseTokenSuffix)) : "";
2043     }
2044 
2045     /*
2046         Rescue any ERC-20 tokens (doesnt include ETH) that are sent to this contract mistakenly
2047     */
2048     function withdrawToken(IERC20 _token, uint256 _amount) public onlyDelegates {
2049         _token.transferFrom(address(this), owner(), _amount);
2050     }
2051 }