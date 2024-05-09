1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: @openzeppelin/contracts/utils/Strings.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev String operations.
96  */
97 library Strings {
98     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
102      */
103     function toString(uint256 value) internal pure returns (string memory) {
104         // Inspired by OraclizeAPI's implementation - MIT licence
105         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
106 
107         if (value == 0) {
108             return "0";
109         }
110         uint256 temp = value;
111         uint256 digits;
112         while (temp != 0) {
113             digits++;
114             temp /= 10;
115         }
116         bytes memory buffer = new bytes(digits);
117         while (value != 0) {
118             digits -= 1;
119             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
120             value /= 10;
121         }
122         return string(buffer);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
127      */
128     function toHexString(uint256 value) internal pure returns (string memory) {
129         if (value == 0) {
130             return "0x00";
131         }
132         uint256 temp = value;
133         uint256 length = 0;
134         while (temp != 0) {
135             length++;
136             temp >>= 8;
137         }
138         return toHexString(value, length);
139     }
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
143      */
144     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
145         bytes memory buffer = new bytes(2 * length + 2);
146         buffer[0] = "0";
147         buffer[1] = "x";
148         for (uint256 i = 2 * length + 1; i > 1; --i) {
149             buffer[i] = _HEX_SYMBOLS[value & 0xf];
150             value >>= 4;
151         }
152         require(value == 0, "Strings: hex length insufficient");
153         return string(buffer);
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
158 
159 
160 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 /**
166  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
167  *
168  * These functions can be used to verify that a message was signed by the holder
169  * of the private keys of a given address.
170  */
171 library ECDSA {
172     enum RecoverError {
173         NoError,
174         InvalidSignature,
175         InvalidSignatureLength,
176         InvalidSignatureS,
177         InvalidSignatureV
178     }
179 
180     function _throwError(RecoverError error) private pure {
181         if (error == RecoverError.NoError) {
182             return; // no error: do nothing
183         } else if (error == RecoverError.InvalidSignature) {
184             revert("ECDSA: invalid signature");
185         } else if (error == RecoverError.InvalidSignatureLength) {
186             revert("ECDSA: invalid signature length");
187         } else if (error == RecoverError.InvalidSignatureS) {
188             revert("ECDSA: invalid signature 's' value");
189         } else if (error == RecoverError.InvalidSignatureV) {
190             revert("ECDSA: invalid signature 'v' value");
191         }
192     }
193 
194     /**
195      * @dev Returns the address that signed a hashed message (`hash`) with
196      * `signature` or error string. This address can then be used for verification purposes.
197      *
198      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
199      * this function rejects them by requiring the `s` value to be in the lower
200      * half order, and the `v` value to be either 27 or 28.
201      *
202      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
203      * verification to be secure: it is possible to craft signatures that
204      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
205      * this is by receiving a hash of the original message (which may otherwise
206      * be too long), and then calling {toEthSignedMessageHash} on it.
207      *
208      * Documentation for signature generation:
209      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
210      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
211      *
212      * _Available since v4.3._
213      */
214     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
215         // Check the signature length
216         // - case 65: r,s,v signature (standard)
217         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
218         if (signature.length == 65) {
219             bytes32 r;
220             bytes32 s;
221             uint8 v;
222             // ecrecover takes the signature parameters, and the only way to get them
223             // currently is to use assembly.
224             assembly {
225                 r := mload(add(signature, 0x20))
226                 s := mload(add(signature, 0x40))
227                 v := byte(0, mload(add(signature, 0x60)))
228             }
229             return tryRecover(hash, v, r, s);
230         } else if (signature.length == 64) {
231             bytes32 r;
232             bytes32 vs;
233             // ecrecover takes the signature parameters, and the only way to get them
234             // currently is to use assembly.
235             assembly {
236                 r := mload(add(signature, 0x20))
237                 vs := mload(add(signature, 0x40))
238             }
239             return tryRecover(hash, r, vs);
240         } else {
241             return (address(0), RecoverError.InvalidSignatureLength);
242         }
243     }
244 
245     /**
246      * @dev Returns the address that signed a hashed message (`hash`) with
247      * `signature`. This address can then be used for verification purposes.
248      *
249      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
250      * this function rejects them by requiring the `s` value to be in the lower
251      * half order, and the `v` value to be either 27 or 28.
252      *
253      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
254      * verification to be secure: it is possible to craft signatures that
255      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
256      * this is by receiving a hash of the original message (which may otherwise
257      * be too long), and then calling {toEthSignedMessageHash} on it.
258      */
259     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
260         (address recovered, RecoverError error) = tryRecover(hash, signature);
261         _throwError(error);
262         return recovered;
263     }
264 
265     /**
266      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
267      *
268      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
269      *
270      * _Available since v4.3._
271      */
272     function tryRecover(
273         bytes32 hash,
274         bytes32 r,
275         bytes32 vs
276     ) internal pure returns (address, RecoverError) {
277         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
278         uint8 v = uint8((uint256(vs) >> 255) + 27);
279         return tryRecover(hash, v, r, s);
280     }
281 
282     /**
283      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
284      *
285      * _Available since v4.2._
286      */
287     function recover(
288         bytes32 hash,
289         bytes32 r,
290         bytes32 vs
291     ) internal pure returns (address) {
292         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
293         _throwError(error);
294         return recovered;
295     }
296 
297     /**
298      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
299      * `r` and `s` signature fields separately.
300      *
301      * _Available since v4.3._
302      */
303     function tryRecover(
304         bytes32 hash,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) internal pure returns (address, RecoverError) {
309         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
310         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
311         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
312         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
313         //
314         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
315         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
316         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
317         // these malleable signatures as well.
318         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
319             return (address(0), RecoverError.InvalidSignatureS);
320         }
321         if (v != 27 && v != 28) {
322             return (address(0), RecoverError.InvalidSignatureV);
323         }
324 
325         // If the signature is valid (and not malleable), return the signer address
326         address signer = ecrecover(hash, v, r, s);
327         if (signer == address(0)) {
328             return (address(0), RecoverError.InvalidSignature);
329         }
330 
331         return (signer, RecoverError.NoError);
332     }
333 
334     /**
335      * @dev Overload of {ECDSA-recover} that receives the `v`,
336      * `r` and `s` signature fields separately.
337      */
338     function recover(
339         bytes32 hash,
340         uint8 v,
341         bytes32 r,
342         bytes32 s
343     ) internal pure returns (address) {
344         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
345         _throwError(error);
346         return recovered;
347     }
348 
349     /**
350      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
351      * produces hash corresponding to the one signed with the
352      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
353      * JSON-RPC method as part of EIP-191.
354      *
355      * See {recover}.
356      */
357     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
358         // 32 is the length in bytes of hash,
359         // enforced by the type signature above
360         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
361     }
362 
363     /**
364      * @dev Returns an Ethereum Signed Message, created from `s`. This
365      * produces hash corresponding to the one signed with the
366      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
367      * JSON-RPC method as part of EIP-191.
368      *
369      * See {recover}.
370      */
371     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
372         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
373     }
374 
375     /**
376      * @dev Returns an Ethereum Signed Typed Data, created from a
377      * `domainSeparator` and a `structHash`. This produces hash corresponding
378      * to the one signed with the
379      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
380      * JSON-RPC method as part of EIP-712.
381      *
382      * See {recover}.
383      */
384     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
385         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Context.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Provides information about the current execution context, including the
398  * sender of the transaction and its data. While these are generally available
399  * via msg.sender and msg.data, they should not be accessed in such a direct
400  * manner, since when dealing with meta-transactions the account sending and
401  * paying for execution may not be the actual sender (as far as an application
402  * is concerned).
403  *
404  * This contract is only required for intermediate, library-like contracts.
405  */
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/access/Ownable.sol
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 abstract contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor() {
445         _transferOwnership(_msgSender());
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view virtual returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(owner() == _msgSender(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464      * @dev Leaves the contract without owner. It will not be possible to call
465      * `onlyOwner` functions anymore. Can only be called by the current owner.
466      *
467      * NOTE: Renouncing ownership will leave the contract without an owner,
468      * thereby removing any functionality that is only available to the owner.
469      */
470     function renounceOwnership() public virtual onlyOwner {
471         _transferOwnership(address(0));
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Can only be called by the current owner.
477      */
478     function transferOwnership(address newOwner) public virtual onlyOwner {
479         require(newOwner != address(0), "Ownable: new owner is the zero address");
480         _transferOwnership(newOwner);
481     }
482 
483     /**
484      * @dev Transfers ownership of the contract to a new account (`newOwner`).
485      * Internal function without access restriction.
486      */
487     function _transferOwnership(address newOwner) internal virtual {
488         address oldOwner = _owner;
489         _owner = newOwner;
490         emit OwnershipTransferred(oldOwner, newOwner);
491     }
492 }
493 
494 // File: @openzeppelin/contracts/utils/Address.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
498 
499 pragma solidity ^0.8.1;
500 
501 /**
502  * @dev Collection of functions related to the address type
503  */
504 library Address {
505     /**
506      * @dev Returns true if `account` is a contract.
507      *
508      * [IMPORTANT]
509      * ====
510      * It is unsafe to assume that an address for which this function returns
511      * false is an externally-owned account (EOA) and not a contract.
512      *
513      * Among others, `isContract` will return false for the following
514      * types of addresses:
515      *
516      *  - an externally-owned account
517      *  - a contract in construction
518      *  - an address where a contract will be created
519      *  - an address where a contract lived, but was destroyed
520      * ====
521      *
522      * [IMPORTANT]
523      * ====
524      * You shouldn't rely on `isContract` to protect against flash loan attacks!
525      *
526      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
527      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
528      * constructor.
529      * ====
530      */
531     function isContract(address account) internal view returns (bool) {
532         // This method relies on extcodesize/address.code.length, which returns 0
533         // for contracts in construction, since the code is only stored at the end
534         // of the constructor execution.
535 
536         return account.code.length > 0;
537     }
538 
539     /**
540      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
541      * `recipient`, forwarding all available gas and reverting on errors.
542      *
543      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
544      * of certain opcodes, possibly making contracts go over the 2300 gas limit
545      * imposed by `transfer`, making them unable to receive funds via
546      * `transfer`. {sendValue} removes this limitation.
547      *
548      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
549      *
550      * IMPORTANT: because control is transferred to `recipient`, care must be
551      * taken to not create reentrancy vulnerabilities. Consider using
552      * {ReentrancyGuard} or the
553      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
554      */
555     function sendValue(address payable recipient, uint256 amount) internal {
556         require(address(this).balance >= amount, "Address: insufficient balance");
557 
558         (bool success, ) = recipient.call{value: amount}("");
559         require(success, "Address: unable to send value, recipient may have reverted");
560     }
561 
562     /**
563      * @dev Performs a Solidity function call using a low level `call`. A
564      * plain `call` is an unsafe replacement for a function call: use this
565      * function instead.
566      *
567      * If `target` reverts with a revert reason, it is bubbled up by this
568      * function (like regular Solidity function calls).
569      *
570      * Returns the raw returned data. To convert to the expected return value,
571      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
572      *
573      * Requirements:
574      *
575      * - `target` must be a contract.
576      * - calling `target` with `data` must not revert.
577      *
578      * _Available since v3.1._
579      */
580     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionCall(target, data, "Address: low-level call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
586      * `errorMessage` as a fallback revert reason when `target` reverts.
587      *
588      * _Available since v3.1._
589      */
590     function functionCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         return functionCallWithValue(target, data, 0, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but also transferring `value` wei to `target`.
601      *
602      * Requirements:
603      *
604      * - the calling contract must have an ETH balance of at least `value`.
605      * - the called Solidity function must be `payable`.
606      *
607      * _Available since v3.1._
608      */
609     function functionCallWithValue(
610         address target,
611         bytes memory data,
612         uint256 value
613     ) internal returns (bytes memory) {
614         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
619      * with `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCallWithValue(
624         address target,
625         bytes memory data,
626         uint256 value,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(address(this).balance >= value, "Address: insufficient balance for call");
630         require(isContract(target), "Address: call to non-contract");
631 
632         (bool success, bytes memory returndata) = target.call{value: value}(data);
633         return verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a static call.
639      *
640      * _Available since v3.3._
641      */
642     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
643         return functionStaticCall(target, data, "Address: low-level static call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
648      * but performing a static call.
649      *
650      * _Available since v3.3._
651      */
652     function functionStaticCall(
653         address target,
654         bytes memory data,
655         string memory errorMessage
656     ) internal view returns (bytes memory) {
657         require(isContract(target), "Address: static call to non-contract");
658 
659         (bool success, bytes memory returndata) = target.staticcall(data);
660         return verifyCallResult(success, returndata, errorMessage);
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
665      * but performing a delegate call.
666      *
667      * _Available since v3.4._
668      */
669     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
670         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(
680         address target,
681         bytes memory data,
682         string memory errorMessage
683     ) internal returns (bytes memory) {
684         require(isContract(target), "Address: delegate call to non-contract");
685 
686         (bool success, bytes memory returndata) = target.delegatecall(data);
687         return verifyCallResult(success, returndata, errorMessage);
688     }
689 
690     /**
691      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
692      * revert reason using the provided one.
693      *
694      * _Available since v4.3._
695      */
696     function verifyCallResult(
697         bool success,
698         bytes memory returndata,
699         string memory errorMessage
700     ) internal pure returns (bytes memory) {
701         if (success) {
702             return returndata;
703         } else {
704             // Look for revert reason and bubble it up if present
705             if (returndata.length > 0) {
706                 // The easiest way to bubble the revert reason is using memory via assembly
707 
708                 assembly {
709                     let returndata_size := mload(returndata)
710                     revert(add(32, returndata), returndata_size)
711                 }
712             } else {
713                 revert(errorMessage);
714             }
715         }
716     }
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 
727 
728 /**
729  * @title SafeERC20
730  * @dev Wrappers around ERC20 operations that throw on failure (when the token
731  * contract returns false). Tokens that return no value (and instead revert or
732  * throw on failure) are also supported, non-reverting calls are assumed to be
733  * successful.
734  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
735  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
736  */
737 library SafeERC20 {
738     using Address for address;
739 
740     function safeTransfer(
741         IERC20 token,
742         address to,
743         uint256 value
744     ) internal {
745         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
746     }
747 
748     function safeTransferFrom(
749         IERC20 token,
750         address from,
751         address to,
752         uint256 value
753     ) internal {
754         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
755     }
756 
757     /**
758      * @dev Deprecated. This function has issues similar to the ones found in
759      * {IERC20-approve}, and its usage is discouraged.
760      *
761      * Whenever possible, use {safeIncreaseAllowance} and
762      * {safeDecreaseAllowance} instead.
763      */
764     function safeApprove(
765         IERC20 token,
766         address spender,
767         uint256 value
768     ) internal {
769         // safeApprove should only be called when setting an initial allowance,
770         // or when resetting it to zero. To increase and decrease it, use
771         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
772         require(
773             (value == 0) || (token.allowance(address(this), spender) == 0),
774             "SafeERC20: approve from non-zero to non-zero allowance"
775         );
776         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
777     }
778 
779     function safeIncreaseAllowance(
780         IERC20 token,
781         address spender,
782         uint256 value
783     ) internal {
784         uint256 newAllowance = token.allowance(address(this), spender) + value;
785         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
786     }
787 
788     function safeDecreaseAllowance(
789         IERC20 token,
790         address spender,
791         uint256 value
792     ) internal {
793         unchecked {
794             uint256 oldAllowance = token.allowance(address(this), spender);
795             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
796             uint256 newAllowance = oldAllowance - value;
797             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
798         }
799     }
800 
801     /**
802      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
803      * on the return value: the return value is optional (but if data is returned, it must not be false).
804      * @param token The token targeted by the call.
805      * @param data The call data (encoded using abi.encode or one of its variants).
806      */
807     function _callOptionalReturn(IERC20 token, bytes memory data) private {
808         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
809         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
810         // the target address contains contract code and also asserts for success in the low-level call.
811 
812         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
813         if (returndata.length > 0) {
814             // Return data is optional
815             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
816         }
817     }
818 }
819 
820 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev Interface of the ERC165 standard, as defined in the
829  * https://eips.ethereum.org/EIPS/eip-165[EIP].
830  *
831  * Implementers can declare support of contract interfaces, which can then be
832  * queried by others ({ERC165Checker}).
833  *
834  * For an implementation, see {ERC165}.
835  */
836 interface IERC165 {
837     /**
838      * @dev Returns true if this contract implements the interface defined by
839      * `interfaceId`. See the corresponding
840      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
841      * to learn more about how these ids are created.
842      *
843      * This function call must use less than 30 000 gas.
844      */
845     function supportsInterface(bytes4 interfaceId) external view returns (bool);
846 }
847 
848 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
849 
850 
851 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @dev Implementation of the {IERC165} interface.
858  *
859  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
860  * for the additional interface id that will be supported. For example:
861  *
862  * ```solidity
863  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
864  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
865  * }
866  * ```
867  *
868  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
869  */
870 abstract contract ERC165 is IERC165 {
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
875         return interfaceId == type(IERC165).interfaceId;
876     }
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 /**
888  * @dev _Available since v3.1._
889  */
890 interface IERC1155Receiver is IERC165 {
891     /**
892      * @dev Handles the receipt of a single ERC1155 token type. This function is
893      * called at the end of a `safeTransferFrom` after the balance has been updated.
894      *
895      * NOTE: To accept the transfer, this must return
896      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
897      * (i.e. 0xf23a6e61, or its own function selector).
898      *
899      * @param operator The address which initiated the transfer (i.e. msg.sender)
900      * @param from The address which previously owned the token
901      * @param id The ID of the token being transferred
902      * @param value The amount of tokens being transferred
903      * @param data Additional data with no specified format
904      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
905      */
906     function onERC1155Received(
907         address operator,
908         address from,
909         uint256 id,
910         uint256 value,
911         bytes calldata data
912     ) external returns (bytes4);
913 
914     /**
915      * @dev Handles the receipt of a multiple ERC1155 token types. This function
916      * is called at the end of a `safeBatchTransferFrom` after the balances have
917      * been updated.
918      *
919      * NOTE: To accept the transfer(s), this must return
920      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
921      * (i.e. 0xbc197c81, or its own function selector).
922      *
923      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
924      * @param from The address which previously owned the token
925      * @param ids An array containing ids of each token being transferred (order and length must match values array)
926      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
927      * @param data Additional data with no specified format
928      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
929      */
930     function onERC1155BatchReceived(
931         address operator,
932         address from,
933         uint256[] calldata ids,
934         uint256[] calldata values,
935         bytes calldata data
936     ) external returns (bytes4);
937 }
938 
939 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
940 
941 
942 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
943 
944 pragma solidity ^0.8.0;
945 
946 
947 /**
948  * @dev Required interface of an ERC1155 compliant contract, as defined in the
949  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
950  *
951  * _Available since v3.1._
952  */
953 interface IERC1155 is IERC165 {
954     /**
955      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
956      */
957     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
958 
959     /**
960      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
961      * transfers.
962      */
963     event TransferBatch(
964         address indexed operator,
965         address indexed from,
966         address indexed to,
967         uint256[] ids,
968         uint256[] values
969     );
970 
971     /**
972      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
973      * `approved`.
974      */
975     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
976 
977     /**
978      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
979      *
980      * If an {URI} event was emitted for `id`, the standard
981      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
982      * returned by {IERC1155MetadataURI-uri}.
983      */
984     event URI(string value, uint256 indexed id);
985 
986     /**
987      * @dev Returns the amount of tokens of token type `id` owned by `account`.
988      *
989      * Requirements:
990      *
991      * - `account` cannot be the zero address.
992      */
993     function balanceOf(address account, uint256 id) external view returns (uint256);
994 
995     /**
996      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
997      *
998      * Requirements:
999      *
1000      * - `accounts` and `ids` must have the same length.
1001      */
1002     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1003         external
1004         view
1005         returns (uint256[] memory);
1006 
1007     /**
1008      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1009      *
1010      * Emits an {ApprovalForAll} event.
1011      *
1012      * Requirements:
1013      *
1014      * - `operator` cannot be the caller.
1015      */
1016     function setApprovalForAll(address operator, bool approved) external;
1017 
1018     /**
1019      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1020      *
1021      * See {setApprovalForAll}.
1022      */
1023     function isApprovedForAll(address account, address operator) external view returns (bool);
1024 
1025     /**
1026      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1027      *
1028      * Emits a {TransferSingle} event.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1034      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1035      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1036      * acceptance magic value.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 id,
1042         uint256 amount,
1043         bytes calldata data
1044     ) external;
1045 
1046     /**
1047      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1048      *
1049      * Emits a {TransferBatch} event.
1050      *
1051      * Requirements:
1052      *
1053      * - `ids` and `amounts` must have the same length.
1054      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1055      * acceptance magic value.
1056      */
1057     function safeBatchTransferFrom(
1058         address from,
1059         address to,
1060         uint256[] calldata ids,
1061         uint256[] calldata amounts,
1062         bytes calldata data
1063     ) external;
1064 }
1065 
1066 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1067 
1068 
1069 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 /**
1075  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1076  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1077  *
1078  * _Available since v3.1._
1079  */
1080 interface IERC1155MetadataURI is IERC1155 {
1081     /**
1082      * @dev Returns the URI for token type `id`.
1083      *
1084      * If the `\{id\}` substring is present in the URI, it must be replaced by
1085      * clients with the actual token type ID.
1086      */
1087     function uri(uint256 id) external view returns (string memory);
1088 }
1089 
1090 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1091 
1092 
1093 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 /**
1104  * @dev Implementation of the basic standard multi-token.
1105  * See https://eips.ethereum.org/EIPS/eip-1155
1106  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1107  *
1108  * _Available since v3.1._
1109  */
1110 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1111     using Address for address;
1112 
1113     // Mapping from token ID to account balances
1114     mapping(uint256 => mapping(address => uint256)) private _balances;
1115 
1116     // Mapping from account to operator approvals
1117     mapping(address => mapping(address => bool)) private _operatorApprovals;
1118 
1119     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1120     string private _uri;
1121 
1122     /**
1123      * @dev See {_setURI}.
1124      */
1125     constructor(string memory uri_) {
1126         _setURI(uri_);
1127     }
1128 
1129     /**
1130      * @dev See {IERC165-supportsInterface}.
1131      */
1132     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1133         return
1134             interfaceId == type(IERC1155).interfaceId ||
1135             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1136             super.supportsInterface(interfaceId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC1155MetadataURI-uri}.
1141      *
1142      * This implementation returns the same URI for *all* token types. It relies
1143      * on the token type ID substitution mechanism
1144      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1145      *
1146      * Clients calling this function must replace the `\{id\}` substring with the
1147      * actual token type ID.
1148      */
1149     function uri(uint256) public view virtual override returns (string memory) {
1150         return _uri;
1151     }
1152 
1153     /**
1154      * @dev See {IERC1155-balanceOf}.
1155      *
1156      * Requirements:
1157      *
1158      * - `account` cannot be the zero address.
1159      */
1160     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1161         require(account != address(0), "ERC1155: balance query for the zero address");
1162         return _balances[id][account];
1163     }
1164 
1165     /**
1166      * @dev See {IERC1155-balanceOfBatch}.
1167      *
1168      * Requirements:
1169      *
1170      * - `accounts` and `ids` must have the same length.
1171      */
1172     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1173         public
1174         view
1175         virtual
1176         override
1177         returns (uint256[] memory)
1178     {
1179         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1180 
1181         uint256[] memory batchBalances = new uint256[](accounts.length);
1182 
1183         for (uint256 i = 0; i < accounts.length; ++i) {
1184             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1185         }
1186 
1187         return batchBalances;
1188     }
1189 
1190     /**
1191      * @dev See {IERC1155-setApprovalForAll}.
1192      */
1193     function setApprovalForAll(address operator, bool approved) public virtual override {
1194         _setApprovalForAll(_msgSender(), operator, approved);
1195     }
1196 
1197     /**
1198      * @dev See {IERC1155-isApprovedForAll}.
1199      */
1200     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1201         return _operatorApprovals[account][operator];
1202     }
1203 
1204     /**
1205      * @dev See {IERC1155-safeTransferFrom}.
1206      */
1207     function safeTransferFrom(
1208         address from,
1209         address to,
1210         uint256 id,
1211         uint256 amount,
1212         bytes memory data
1213     ) public virtual override {
1214         require(
1215             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1216             "ERC1155: caller is not owner nor approved"
1217         );
1218         _safeTransferFrom(from, to, id, amount, data);
1219     }
1220 
1221     /**
1222      * @dev See {IERC1155-safeBatchTransferFrom}.
1223      */
1224     function safeBatchTransferFrom(
1225         address from,
1226         address to,
1227         uint256[] memory ids,
1228         uint256[] memory amounts,
1229         bytes memory data
1230     ) public virtual override {
1231         require(
1232             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1233             "ERC1155: transfer caller is not owner nor approved"
1234         );
1235         _safeBatchTransferFrom(from, to, ids, amounts, data);
1236     }
1237 
1238     /**
1239      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1240      *
1241      * Emits a {TransferSingle} event.
1242      *
1243      * Requirements:
1244      *
1245      * - `to` cannot be the zero address.
1246      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1247      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1248      * acceptance magic value.
1249      */
1250     function _safeTransferFrom(
1251         address from,
1252         address to,
1253         uint256 id,
1254         uint256 amount,
1255         bytes memory data
1256     ) internal virtual {
1257         require(to != address(0), "ERC1155: transfer to the zero address");
1258 
1259         address operator = _msgSender();
1260         uint256[] memory ids = _asSingletonArray(id);
1261         uint256[] memory amounts = _asSingletonArray(amount);
1262 
1263         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1264 
1265         uint256 fromBalance = _balances[id][from];
1266         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1267         unchecked {
1268             _balances[id][from] = fromBalance - amount;
1269         }
1270         _balances[id][to] += amount;
1271 
1272         emit TransferSingle(operator, from, to, id, amount);
1273 
1274         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1275 
1276         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1277     }
1278 
1279     /**
1280      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1281      *
1282      * Emits a {TransferBatch} event.
1283      *
1284      * Requirements:
1285      *
1286      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1287      * acceptance magic value.
1288      */
1289     function _safeBatchTransferFrom(
1290         address from,
1291         address to,
1292         uint256[] memory ids,
1293         uint256[] memory amounts,
1294         bytes memory data
1295     ) internal virtual {
1296         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1297         require(to != address(0), "ERC1155: transfer to the zero address");
1298 
1299         address operator = _msgSender();
1300 
1301         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1302 
1303         for (uint256 i = 0; i < ids.length; ++i) {
1304             uint256 id = ids[i];
1305             uint256 amount = amounts[i];
1306 
1307             uint256 fromBalance = _balances[id][from];
1308             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1309             unchecked {
1310                 _balances[id][from] = fromBalance - amount;
1311             }
1312             _balances[id][to] += amount;
1313         }
1314 
1315         emit TransferBatch(operator, from, to, ids, amounts);
1316 
1317         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1318 
1319         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1320     }
1321 
1322     /**
1323      * @dev Sets a new URI for all token types, by relying on the token type ID
1324      * substitution mechanism
1325      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1326      *
1327      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1328      * URI or any of the amounts in the JSON file at said URI will be replaced by
1329      * clients with the token type ID.
1330      *
1331      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1332      * interpreted by clients as
1333      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1334      * for token type ID 0x4cce0.
1335      *
1336      * See {uri}.
1337      *
1338      * Because these URIs cannot be meaningfully represented by the {URI} event,
1339      * this function emits no events.
1340      */
1341     function _setURI(string memory newuri) internal virtual {
1342         _uri = newuri;
1343     }
1344 
1345     /**
1346      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1347      *
1348      * Emits a {TransferSingle} event.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1354      * acceptance magic value.
1355      */
1356     function _mint(
1357         address to,
1358         uint256 id,
1359         uint256 amount,
1360         bytes memory data
1361     ) internal virtual {
1362         require(to != address(0), "ERC1155: mint to the zero address");
1363 
1364         address operator = _msgSender();
1365         uint256[] memory ids = _asSingletonArray(id);
1366         uint256[] memory amounts = _asSingletonArray(amount);
1367 
1368         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1369 
1370         _balances[id][to] += amount;
1371         emit TransferSingle(operator, address(0), to, id, amount);
1372 
1373         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1374 
1375         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1376     }
1377 
1378     /**
1379      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1380      *
1381      * Requirements:
1382      *
1383      * - `ids` and `amounts` must have the same length.
1384      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1385      * acceptance magic value.
1386      */
1387     function _mintBatch(
1388         address to,
1389         uint256[] memory ids,
1390         uint256[] memory amounts,
1391         bytes memory data
1392     ) internal virtual {
1393         require(to != address(0), "ERC1155: mint to the zero address");
1394         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1395 
1396         address operator = _msgSender();
1397 
1398         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1399 
1400         for (uint256 i = 0; i < ids.length; i++) {
1401             _balances[ids[i]][to] += amounts[i];
1402         }
1403 
1404         emit TransferBatch(operator, address(0), to, ids, amounts);
1405 
1406         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1407 
1408         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1409     }
1410 
1411     /**
1412      * @dev Destroys `amount` tokens of token type `id` from `from`
1413      *
1414      * Requirements:
1415      *
1416      * - `from` cannot be the zero address.
1417      * - `from` must have at least `amount` tokens of token type `id`.
1418      */
1419     function _burn(
1420         address from,
1421         uint256 id,
1422         uint256 amount
1423     ) internal virtual {
1424         require(from != address(0), "ERC1155: burn from the zero address");
1425 
1426         address operator = _msgSender();
1427         uint256[] memory ids = _asSingletonArray(id);
1428         uint256[] memory amounts = _asSingletonArray(amount);
1429 
1430         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1431 
1432         uint256 fromBalance = _balances[id][from];
1433         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1434         unchecked {
1435             _balances[id][from] = fromBalance - amount;
1436         }
1437 
1438         emit TransferSingle(operator, from, address(0), id, amount);
1439 
1440         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1441     }
1442 
1443     /**
1444      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1445      *
1446      * Requirements:
1447      *
1448      * - `ids` and `amounts` must have the same length.
1449      */
1450     function _burnBatch(
1451         address from,
1452         uint256[] memory ids,
1453         uint256[] memory amounts
1454     ) internal virtual {
1455         require(from != address(0), "ERC1155: burn from the zero address");
1456         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1457 
1458         address operator = _msgSender();
1459 
1460         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1461 
1462         for (uint256 i = 0; i < ids.length; i++) {
1463             uint256 id = ids[i];
1464             uint256 amount = amounts[i];
1465 
1466             uint256 fromBalance = _balances[id][from];
1467             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1468             unchecked {
1469                 _balances[id][from] = fromBalance - amount;
1470             }
1471         }
1472 
1473         emit TransferBatch(operator, from, address(0), ids, amounts);
1474 
1475         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1476     }
1477 
1478     /**
1479      * @dev Approve `operator` to operate on all of `owner` tokens
1480      *
1481      * Emits a {ApprovalForAll} event.
1482      */
1483     function _setApprovalForAll(
1484         address owner,
1485         address operator,
1486         bool approved
1487     ) internal virtual {
1488         require(owner != operator, "ERC1155: setting approval status for self");
1489         _operatorApprovals[owner][operator] = approved;
1490         emit ApprovalForAll(owner, operator, approved);
1491     }
1492 
1493     /**
1494      * @dev Hook that is called before any token transfer. This includes minting
1495      * and burning, as well as batched variants.
1496      *
1497      * The same hook is called on both single and batched variants. For single
1498      * transfers, the length of the `id` and `amount` arrays will be 1.
1499      *
1500      * Calling conditions (for each `id` and `amount` pair):
1501      *
1502      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1503      * of token type `id` will be  transferred to `to`.
1504      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1505      * for `to`.
1506      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1507      * will be burned.
1508      * - `from` and `to` are never both zero.
1509      * - `ids` and `amounts` have the same, non-zero length.
1510      *
1511      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1512      */
1513     function _beforeTokenTransfer(
1514         address operator,
1515         address from,
1516         address to,
1517         uint256[] memory ids,
1518         uint256[] memory amounts,
1519         bytes memory data
1520     ) internal virtual {}
1521 
1522     /**
1523      * @dev Hook that is called after any token transfer. This includes minting
1524      * and burning, as well as batched variants.
1525      *
1526      * The same hook is called on both single and batched variants. For single
1527      * transfers, the length of the `id` and `amount` arrays will be 1.
1528      *
1529      * Calling conditions (for each `id` and `amount` pair):
1530      *
1531      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1532      * of token type `id` will be  transferred to `to`.
1533      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1534      * for `to`.
1535      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1536      * will be burned.
1537      * - `from` and `to` are never both zero.
1538      * - `ids` and `amounts` have the same, non-zero length.
1539      *
1540      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1541      */
1542     function _afterTokenTransfer(
1543         address operator,
1544         address from,
1545         address to,
1546         uint256[] memory ids,
1547         uint256[] memory amounts,
1548         bytes memory data
1549     ) internal virtual {}
1550 
1551     function _doSafeTransferAcceptanceCheck(
1552         address operator,
1553         address from,
1554         address to,
1555         uint256 id,
1556         uint256 amount,
1557         bytes memory data
1558     ) private {
1559         if (to.isContract()) {
1560             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1561                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1562                     revert("ERC1155: ERC1155Receiver rejected tokens");
1563                 }
1564             } catch Error(string memory reason) {
1565                 revert(reason);
1566             } catch {
1567                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1568             }
1569         }
1570     }
1571 
1572     function _doSafeBatchTransferAcceptanceCheck(
1573         address operator,
1574         address from,
1575         address to,
1576         uint256[] memory ids,
1577         uint256[] memory amounts,
1578         bytes memory data
1579     ) private {
1580         if (to.isContract()) {
1581             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1582                 bytes4 response
1583             ) {
1584                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1585                     revert("ERC1155: ERC1155Receiver rejected tokens");
1586                 }
1587             } catch Error(string memory reason) {
1588                 revert(reason);
1589             } catch {
1590                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1591             }
1592         }
1593     }
1594 
1595     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1596         uint256[] memory array = new uint256[](1);
1597         array[0] = element;
1598 
1599         return array;
1600     }
1601 }
1602 
1603 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1604 
1605 
1606 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1607 
1608 pragma solidity ^0.8.0;
1609 
1610 
1611 /**
1612  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1613  *
1614  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1615  * clearly identified. Note: While a totalSupply of 1 might mean the
1616  * corresponding is an NFT, there is no guarantees that no other token with the
1617  * same id are not going to be minted.
1618  */
1619 abstract contract ERC1155Supply is ERC1155 {
1620     mapping(uint256 => uint256) private _totalSupply;
1621 
1622     /**
1623      * @dev Total amount of tokens in with a given id.
1624      */
1625     function totalSupply(uint256 id) public view virtual returns (uint256) {
1626         return _totalSupply[id];
1627     }
1628 
1629     /**
1630      * @dev Indicates whether any token exist with a given id, or not.
1631      */
1632     function exists(uint256 id) public view virtual returns (bool) {
1633         return ERC1155Supply.totalSupply(id) > 0;
1634     }
1635 
1636     /**
1637      * @dev See {ERC1155-_beforeTokenTransfer}.
1638      */
1639     function _beforeTokenTransfer(
1640         address operator,
1641         address from,
1642         address to,
1643         uint256[] memory ids,
1644         uint256[] memory amounts,
1645         bytes memory data
1646     ) internal virtual override {
1647         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1648 
1649         if (from == address(0)) {
1650             for (uint256 i = 0; i < ids.length; ++i) {
1651                 _totalSupply[ids[i]] += amounts[i];
1652             }
1653         }
1654 
1655         if (to == address(0)) {
1656             for (uint256 i = 0; i < ids.length; ++i) {
1657                 uint256 id = ids[i];
1658                 uint256 amount = amounts[i];
1659                 uint256 supply = _totalSupply[id];
1660                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1661                 unchecked {
1662                     _totalSupply[id] = supply - amount;
1663                 }
1664             }
1665         }
1666     }
1667 }
1668 
1669 // File: Bit.sol
1670 
1671 
1672 pragma solidity ^0.8.4;
1673 
1674 
1675 
1676 
1677 
1678 
1679 
1680 
1681 library StringLibrary {
1682 
1683     function castString(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
1684         bytes memory _ba = bytes(_a);
1685         bytes memory _bb = bytes(_b);
1686         bytes memory _bc = bytes(_c);
1687         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
1688         uint k = 0;
1689         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
1690         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
1691         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
1692         return string(bbb);
1693     }
1694     
1695 }
1696 
1697 contract BitStake is ERC1155, Ownable, ERC1155Supply {
1698 
1699     using SafeERC20 for IERC20;
1700     using StringLibrary for string;
1701     using Strings for uint256;
1702 
1703     mapping(uint256 => string) private _tokenURIs;
1704 
1705     IERC20 public usdt;
1706     IERC20 public feeToken;
1707 
1708     address public usdtContract;
1709     address public feeTokenContract;
1710 
1711     address public collectNFT;
1712     address public collectUSDT;
1713     address public collectFeeToken;
1714 
1715     /**
1716      * @param _usdt USDT地址
1717      * @param _feeToken 手续费Token地址
1718      */
1719     constructor(
1720         address _usdt,
1721         address _feeToken,
1722         address _collectNFT,
1723         address _collectUSDT,
1724         address _collectFeeToken
1725     ) ERC1155("http://nft.ahjsc.top/") {
1726         require(
1727             _usdt != address(0) && _feeToken != address(0),
1728             "address is zero"
1729         );
1730 
1731         usdt = IERC20(_usdt);
1732         feeToken = IERC20(_feeToken);
1733         usdtContract=_usdt;
1734         feeTokenContract=_feeToken;
1735         collectNFT = _collectNFT;
1736         collectUSDT = _collectUSDT;
1737         collectFeeToken = _collectFeeToken;
1738 
1739     }
1740 
1741     string private _name = "BitStake";
1742     string private _symbol = "BitStake";
1743 
1744     function name() public view virtual returns (string memory) {
1745         return _name;
1746     }
1747 
1748     function symbol() public view virtual returns (string memory) {
1749         return _symbol;
1750     }
1751 
1752 
1753     function setFor(uint256 startId,uint256 endId,address _myAddress) public onlyOwner{
1754 
1755         string memory  startString ="http://nft.ahjsc.top/bitstake/json/";
1756         string memory  endString =".json";
1757 
1758         for(uint i=startId;i< endId;i++){
1759 
1760             setURI(i,startString.castString(i.toString(),endString));
1761             mint(_myAddress,i,1,"0x00");
1762             
1763         }
1764 
1765     }
1766 
1767     function uri(uint256 tokenId)
1768         public
1769         view
1770         virtual
1771         override
1772         returns (string memory)
1773     {
1774         return _tokenURIs[tokenId];
1775     }
1776 
1777     function setURI(uint256 tokenId, string memory newuri) public onlyOwner {
1778         _tokenURIs[tokenId] = newuri;
1779     }
1780 
1781     /**
1782      * @dev 设置收集Token的钱包地址
1783      * @param collectAddress 收集各个Token的钱包地址，0-收集NFT的地址，1-收集USDT的地址，2-收集手续费的地址
1784      */
1785     function setCollectAddress(address[] memory collectAddress)
1786         external
1787         onlyOwner
1788     {
1789         require(collectAddress.length == 3, "address length error");
1790         collectNFT = collectAddress[0];
1791         collectUSDT = collectAddress[1];
1792         collectFeeToken = collectAddress[2];
1793     }
1794 
1795     function lookCollectAddress() public view virtual returns (address _nftAddress,address _usdtAddress,address _feeAddress) {
1796         return (collectNFT,collectUSDT,collectFeeToken);
1797     }
1798 
1799     /**
1800      * @dev 设置USDT和FeeToken地址
1801      * @param _usdt USDT地址
1802      * @param _feeToken X币地址
1803      */
1804     function setUAndFeeToken(address _usdt, address _feeToken)
1805         external
1806         onlyOwner
1807     {
1808         require(
1809             _usdt != address(0) && _feeToken != address(0),
1810             "address is zero"
1811         );
1812         usdtContract = _usdt;
1813         feeTokenContract = _feeToken;
1814         usdt = IERC20(_usdt);
1815         feeToken = IERC20(_feeToken);
1816     }
1817 
1818     function lookUAndFeeToken() public view virtual returns (address _usdtContract,address _feeTokenContract) {
1819         return (usdtContract,feeTokenContract);
1820     }
1821 
1822     function mint(
1823         address account,
1824         uint256 id,
1825         uint256 amount,
1826         bytes memory data
1827     ) public onlyOwner {
1828         _mint(account, id, amount, data);
1829     }
1830 
1831     function mintBatch(
1832         address to,
1833         uint256[] memory ids,
1834         uint256[] memory amounts,
1835         bytes memory data
1836     ) public onlyOwner {
1837         _mintBatch(to, ids, amounts, data);
1838     }
1839 
1840     function bulkMint(
1841         address[] memory to,
1842         uint256 id,
1843         bytes memory data
1844     ) public onlyOwner {
1845         uint256 n = to.length;
1846 
1847         for (uint256 i = 0; i < n; ) {
1848             _mint(to[i], id, 1, data);
1849 
1850             unchecked {
1851                 ++i;
1852             }
1853         }
1854     }
1855 
1856     // The following functions are overrides required by Solidity.
1857 
1858     function _beforeTokenTransfer(
1859         address operator,
1860         address from,
1861         address to,
1862         uint256[] memory ids,
1863         uint256[] memory amounts,
1864         bytes memory data
1865     ) internal override(ERC1155, ERC1155Supply) {
1866         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1867     }
1868 
1869     function burn(
1870         address account,
1871         uint256 id,
1872         uint256 value
1873     ) public virtual {
1874         require(
1875             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1876             "ERC1155: caller is not owner nor approved"
1877         );
1878 
1879         _burn(account, id, value);
1880     }
1881 
1882     function burnBatch(
1883         address account,
1884         uint256[] memory ids,
1885         uint256[] memory values
1886     ) public virtual {
1887         require(
1888             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1889             "ERC1155: caller is not owner nor approved"
1890         );
1891 
1892         _burnBatch(account, ids, values);
1893     }
1894 
1895     using ECDSA for bytes32;
1896     string signCotent = "HelloWorld";
1897 
1898     function setSigner(string memory _signCotent) public {
1899         signCotent = _signCotent;
1900     }
1901 
1902     function getSigner() public view returns (string memory) {
1903         return signCotent;
1904     }
1905 
1906     function isMessageValid(bytes memory _signature, address _myAddress)
1907         public
1908         view
1909         returns (address, bool)
1910     {
1911         // 1. 对签名信息进行 abi 编码
1912         bytes memory abiEncode = abi.encodePacked(signCotent);
1913 
1914         // 2. 再进行 keccak256 Hash运算
1915         bytes32 messagehash = keccak256(abiEncode);
1916 
1917         // 3. 添加前缀，可以将计算出的以太坊特定的签名。这可以防止恶意 DApp 可以签署任意数据（例如交易）并使用签名来冒充受害者的滥用行为。
1918         bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(
1919             messagehash
1920         );
1921 
1922         // 4. 从签名恢复地址
1923         address signer = ECDSA.recover(ethSignedMessageHash, _signature);
1924 
1925         if (_myAddress == signer) {
1926             return (signer, true);
1927         } else {
1928             return (signer, false);
1929         }
1930     }
1931 
1932     /**
1933      * @dev 抵押NFT（卖NFT）
1934      * @param from NFT所在地址
1935      * @param id tokenId
1936      * @param amount 数量
1937      * @param amountF 手续费Token收取数量(X币数量)
1938      */
1939     function depositNFT(
1940         address from,
1941         uint256 id,
1942         uint256 amount,
1943         uint256 amountF
1944     ) public {
1945         // require(
1946         //     feeToken.balanceOf(from) >= amountF,
1947         //     "Insufficient FeeToken Quantity"
1948         // );
1949         // require(
1950         //     feeToken.allowance(from, address(this)) >= amountF,
1951         //     "transfer amount exceeds allowance"
1952         // );
1953         safeTransferFrom(from, collectNFT, id, amount, "");
1954         feeToken.safeTransferFrom(from, collectFeeToken, amountF);
1955     }
1956 
1957     /**
1958      * @dev 购买NFT
1959 	 * @param amountU 需要支付USDT数量
1960 	 * @param amountF 需要支付X币数量
1961      */
1962     function buyNFT(
1963         uint256 amountU,
1964         uint256 amountF
1965     ) public  {
1966 
1967         address owner = _msgSender();
1968         
1969         //     require(
1970         //         usdt.balanceOf(owner) >= amountU,
1971         //         "Insufficient USDT Quantity"
1972         //     );
1973         //    require(
1974         //         feeToken.balanceOf(owner) >= amountF,
1975         //         "Insufficient FeeToken Quantity"
1976         //     );
1977         //     require(
1978         //         usdt.allowance(owner, address(this)) >= amountU,
1979         //         "usdt transfer amount exceeds allowance"
1980         //     );
1981         //     require(
1982         //         feeToken.allowance(owner, address(this)) >= amountF,
1983         //         "feeToken transfer amount exceeds allowance"
1984         //     );
1985 
1986         usdt.safeTransferFrom(owner, collectUSDT, amountU);
1987         feeToken.safeTransferFrom(owner, collectFeeToken, amountF);
1988 
1989     }
1990 
1991 }