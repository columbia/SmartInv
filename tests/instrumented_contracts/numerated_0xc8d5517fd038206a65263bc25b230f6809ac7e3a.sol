1 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
2 // ⣿⣿⣿⣿⣿⣿⣿⠿⢛⣉⠀⠀⣤⣴⣶⡄⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿
3 // ⣿⣿⣿⣿⡿⠋⠠⣾⣿⣿⣶⢶⣿⣿⣿⣷⣄⡀⠀⣀⣿⣷⣤⡈⠻⣿⣿⣿⣿⣿
4 // ⣿⣿⣿⠟⠀⠀⠀⠈⢿⡟⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣦⡈⢿⣿⣿⣿
5 // ⣿⣿⠏⢀⠀⠀⠀⠀⣾⣿⣤⣠⣼⣿⠿⠿⠿⢿⣿⣿⣿⡇⠀⠀⣻⣿⡄⢻⣿⣿
6 // ⣿⡿⠀⣿⣦⣤⣤⣾⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠙⣿⣿⣿⣶⣶⣿⣿⣷⠀⢿⣿
7 // ⣿⡇⢸⠿⢿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡟⠋⠉⠉⠻⣿⡆⢸⣿
8 // ⣿⣧⠀⠀⠀⣿⣿⡿⠋⠉⠛⣿⣧⡀⠀⠀⠀⠀⣠⣿⣿⠀⠀⠀⠀⠀⠋⢀⣾⣿
9 // ⣿⣿⣷⣄⡈⠛⠻⠇⠀⠀⢠⣿⣿⣿⣷⣶⣶⣿⣿⡿⠿⠷⠀⠀⣀⣤⣶⣿⣿⣿
10 // ⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣤⣤⣤⣤⣤⣤⣤⣤⣴⢶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿
11 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
12 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿
13 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿
14 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿
15 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣤⣤⣤⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
16 // shout outs:
17 // to dom, timshel, loot community and goblenz for the inspiration
18 // to msc18, 124, SHZ, og mushroomers and cool guys from thai and nigeria
19 // to mushrooms つ◕_◕つ 🍄
20 // =========================
21 // for the web3 frens with love
22 
23 // SPDX-License-Identifier: MIT
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev String operations.
29  */
30 library Strings {
31     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
32 
33     /**
34      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
35      */
36     function toString(uint256 value) internal pure returns (string memory) {
37         // Inspired by OraclizeAPI's implementation - MIT licence
38         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
39 
40         if (value == 0) {
41             return "0";
42         }
43         uint256 temp = value;
44         uint256 digits;
45         while (temp != 0) {
46             digits++;
47             temp /= 10;
48         }
49         bytes memory buffer = new bytes(digits);
50         while (value != 0) {
51             digits -= 1;
52             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
53             value /= 10;
54         }
55         return string(buffer);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
60      */
61     function toHexString(uint256 value) internal pure returns (string memory) {
62         if (value == 0) {
63             return "0x00";
64         }
65         uint256 temp = value;
66         uint256 length = 0;
67         while (temp != 0) {
68             length++;
69             temp >>= 8;
70         }
71         return toHexString(value, length);
72     }
73 
74     /**
75      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
76      */
77     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
78         bytes memory buffer = new bytes(2 * length + 2);
79         buffer[0] = "0";
80         buffer[1] = "x";
81         for (uint256 i = 2 * length + 1; i > 1; --i) {
82             buffer[i] = _HEX_SYMBOLS[value & 0xf];
83             value >>= 4;
84         }
85         require(value == 0, "Strings: hex length insufficient");
86         return string(buffer);
87     }
88 }
89 // File: ECDSA.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
99  *
100  * These functions can be used to verify that a message was signed by the holder
101  * of the private keys of a given address.
102  */
103 library ECDSA {
104     enum RecoverError {
105         NoError,
106         InvalidSignature,
107         InvalidSignatureLength,
108         InvalidSignatureS,
109         InvalidSignatureV
110     }
111 
112     function _throwError(RecoverError error) private pure {
113         if (error == RecoverError.NoError) {
114             return; // no error: do nothing
115         } else if (error == RecoverError.InvalidSignature) {
116             revert("ECDSA: invalid signature");
117         } else if (error == RecoverError.InvalidSignatureLength) {
118             revert("ECDSA: invalid signature length");
119         } else if (error == RecoverError.InvalidSignatureS) {
120             revert("ECDSA: invalid signature 's' value");
121         } else if (error == RecoverError.InvalidSignatureV) {
122             revert("ECDSA: invalid signature 'v' value");
123         }
124     }
125 
126     /**
127      * @dev Returns the address that signed a hashed message (`hash`) with
128      * `signature` or error string. This address can then be used for verification purposes.
129      *
130      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
131      * this function rejects them by requiring the `s` value to be in the lower
132      * half order, and the `v` value to be either 27 or 28.
133      *
134      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
135      * verification to be secure: it is possible to craft signatures that
136      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
137      * this is by receiving a hash of the original message (which may otherwise
138      * be too long), and then calling {toEthSignedMessageHash} on it.
139      *
140      * Documentation for signature generation:
141      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
142      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
143      *
144      * _Available since v4.3._
145      */
146     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
147         // Check the signature length
148         // - case 65: r,s,v signature (standard)
149         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
150         if (signature.length == 65) {
151             bytes32 r;
152             bytes32 s;
153             uint8 v;
154             // ecrecover takes the signature parameters, and the only way to get them
155             // currently is to use assembly.
156             assembly {
157                 r := mload(add(signature, 0x20))
158                 s := mload(add(signature, 0x40))
159                 v := byte(0, mload(add(signature, 0x60)))
160             }
161             return tryRecover(hash, v, r, s);
162         } else if (signature.length == 64) {
163             bytes32 r;
164             bytes32 vs;
165             // ecrecover takes the signature parameters, and the only way to get them
166             // currently is to use assembly.
167             assembly {
168                 r := mload(add(signature, 0x20))
169                 vs := mload(add(signature, 0x40))
170             }
171             return tryRecover(hash, r, vs);
172         } else {
173             return (address(0), RecoverError.InvalidSignatureLength);
174         }
175     }
176 
177     /**
178      * @dev Returns the address that signed a hashed message (`hash`) with
179      * `signature`. This address can then be used for verification purposes.
180      *
181      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
182      * this function rejects them by requiring the `s` value to be in the lower
183      * half order, and the `v` value to be either 27 or 28.
184      *
185      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
186      * verification to be secure: it is possible to craft signatures that
187      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
188      * this is by receiving a hash of the original message (which may otherwise
189      * be too long), and then calling {toEthSignedMessageHash} on it.
190      */
191     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
192         (address recovered, RecoverError error) = tryRecover(hash, signature);
193         _throwError(error);
194         return recovered;
195     }
196 
197     /**
198      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
199      *
200      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
201      *
202      * _Available since v4.3._
203      */
204     function tryRecover(
205         bytes32 hash,
206         bytes32 r,
207         bytes32 vs
208     ) internal pure returns (address, RecoverError) {
209         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
210         uint8 v = uint8((uint256(vs) >> 255) + 27);
211         return tryRecover(hash, v, r, s);
212     }
213 
214     /**
215      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
216      *
217      * _Available since v4.2._
218      */
219     function recover(
220         bytes32 hash,
221         bytes32 r,
222         bytes32 vs
223     ) internal pure returns (address) {
224         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
225         _throwError(error);
226         return recovered;
227     }
228 
229     /**
230      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
231      * `r` and `s` signature fields separately.
232      *
233      * _Available since v4.3._
234      */
235     function tryRecover(
236         bytes32 hash,
237         uint8 v,
238         bytes32 r,
239         bytes32 s
240     ) internal pure returns (address, RecoverError) {
241         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
242         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
243         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
244         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
245         //
246         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
247         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
248         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
249         // these malleable signatures as well.
250         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
251             return (address(0), RecoverError.InvalidSignatureS);
252         }
253         if (v != 27 && v != 28) {
254             return (address(0), RecoverError.InvalidSignatureV);
255         }
256 
257         // If the signature is valid (and not malleable), return the signer address
258         address signer = ecrecover(hash, v, r, s);
259         if (signer == address(0)) {
260             return (address(0), RecoverError.InvalidSignature);
261         }
262 
263         return (signer, RecoverError.NoError);
264     }
265 
266     /**
267      * @dev Overload of {ECDSA-recover} that receives the `v`,
268      * `r` and `s` signature fields separately.
269      */
270     function recover(
271         bytes32 hash,
272         uint8 v,
273         bytes32 r,
274         bytes32 s
275     ) internal pure returns (address) {
276         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
277         _throwError(error);
278         return recovered;
279     }
280 
281     /**
282      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
283      * produces hash corresponding to the one signed with the
284      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
285      * JSON-RPC method as part of EIP-191.
286      *
287      * See {recover}.
288      */
289     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
290         // 32 is the length in bytes of hash,
291         // enforced by the type signature above
292         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
293     }
294 
295     /**
296      * @dev Returns an Ethereum Signed Message, created from `s`. This
297      * produces hash corresponding to the one signed with the
298      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
299      * JSON-RPC method as part of EIP-191.
300      *
301      * See {recover}.
302      */
303     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
304         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
305     }
306 
307     /**
308      * @dev Returns an Ethereum Signed Typed Data, created from a
309      * `domainSeparator` and a `structHash`. This produces hash corresponding
310      * to the one signed with the
311      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
312      * JSON-RPC method as part of EIP-712.
313      *
314      * See {recover}.
315      */
316     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
317         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
318     }
319 }
320 // File: Context.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Provides information about the current execution context, including the
328  * sender of the transaction and its data. While these are generally available
329  * via msg.sender and msg.data, they should not be accessed in such a direct
330  * manner, since when dealing with meta-transactions the account sending and
331  * paying for execution may not be the actual sender (as far as an application
332  * is concerned).
333  *
334  * This contract is only required for intermediate, library-like contracts.
335  */
336 abstract contract Context {
337     function _msgSender() internal view virtual returns (address) {
338         return msg.sender;
339     }
340 
341     function _msgData() internal view virtual returns (bytes calldata) {
342         return msg.data;
343     }
344 }
345 // File: Ownable.sol
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Contract module which provides a basic access control mechanism, where
354  * there is an account (an owner) that can be granted exclusive access to
355  * specific functions.
356  *
357  * By default, the owner account will be the one that deploys the contract. This
358  * can later be changed with {transferOwnership}.
359  *
360  * This module is used through inheritance. It will make available the modifier
361  * `onlyOwner`, which can be applied to your functions to restrict their use to
362  * the owner.
363  */
364 abstract contract Ownable is Context {
365     address private _owner;
366 
367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369     /**
370      * @dev Initializes the contract setting the deployer as the initial owner.
371      */
372     constructor() {
373         _setOwner(_msgSender());
374     }
375 
376     /**
377      * @dev Returns the address of the current owner.
378      */
379     function owner() public view virtual returns (address) {
380         return _owner;
381     }
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
388         _;
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public virtual onlyOwner {
399         _setOwner(address(0));
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Can only be called by the current owner.
405      */
406     function transferOwnership(address newOwner) public virtual onlyOwner {
407         require(newOwner != address(0), "Ownable: new owner is the zero address");
408         _setOwner(newOwner);
409     }
410 
411     function _setOwner(address newOwner) private {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 // File: Address.sol
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * [IMPORTANT]
431      * ====
432      * It is unsafe to assume that an address for which this function returns
433      * false is an externally-owned account (EOA) and not a contract.
434      *
435      * Among others, `isContract` will return false for the following
436      * types of addresses:
437      *
438      *  - an externally-owned account
439      *  - a contract in construction
440      *  - an address where a contract will be created
441      *  - an address where a contract lived, but was destroyed
442      * ====
443      */
444     function isContract(address account) internal view returns (bool) {
445         // This method relies on extcodesize, which returns 0 for contracts in
446         // construction, since the code is only stored at the end of the
447         // constructor execution.
448 
449         uint256 size;
450         assembly {
451             size := extcodesize(account)
452         }
453         return size > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return _verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return _verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     function _verifyCallResult(
608         bool success,
609         bytes memory returndata,
610         string memory errorMessage
611     ) private pure returns (bytes memory) {
612         if (success) {
613             return returndata;
614         } else {
615             // Look for revert reason and bubble it up if present
616             if (returndata.length > 0) {
617                 // The easiest way to bubble the revert reason is using memory via assembly
618 
619                 assembly {
620                     let returndata_size := mload(returndata)
621                     revert(add(32, returndata), returndata_size)
622                 }
623             } else {
624                 revert(errorMessage);
625             }
626         }
627     }
628 }
629 // File: Payment.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 
638 /**
639  * @title PaymentSplitter
640  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
641  * that the Ether will be split in this way, since it is handled transparently by the contract.
642  *
643  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
644  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
645  * an amount proportional to the percentage of total shares they were assigned.
646  *
647  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
648  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
649  * function.
650  *
651  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
652  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
653  * to run tests before sending real value to this contract.
654  */
655 contract Payment is Context {
656     event PayeeAdded(address account, uint256 shares);
657     event PaymentReleased(address to, uint256 amount);
658     event PaymentReceived(address from, uint256 amount);
659 
660     uint256 private _totalShares;
661     uint256 private _totalReleased;
662 
663     mapping(address => uint256) private _shares;
664     mapping(address => uint256) private _released;
665     address[] private _payees;
666 
667     /**
668      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
669      * the matching position in the `shares` array.
670      *
671      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
672      * duplicates in `payees`.
673      */
674     constructor(address[] memory payees, uint256[] memory shares_) payable {
675         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
676         require(payees.length > 0, "PaymentSplitter: no payees");
677 
678         for (uint256 i = 0; i < payees.length; i++) {
679             _addPayee(payees[i], shares_[i]);
680         }
681     }
682 
683     /**
684      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
685      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
686      * reliability of the events, and not the actual splitting of Ether.
687      *
688      * To learn more about this see the Solidity documentation for
689      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
690      * functions].
691      */
692     receive() external payable virtual {
693         emit PaymentReceived(_msgSender(), msg.value);
694     }
695 
696     /**
697      * @dev Getter for the total shares held by payees.
698      */
699     function totalShares() public view returns (uint256) {
700         return _totalShares;
701     }
702 
703     /**
704      * @dev Getter for the total amount of Ether already released.
705      */
706     function totalReleased() public view returns (uint256) {
707         return _totalReleased;
708     }
709 
710 
711     /**
712      * @dev Getter for the amount of shares held by an account.
713      */
714     function shares(address account) public view returns (uint256) {
715         return _shares[account];
716     }
717 
718     /**
719      * @dev Getter for the amount of Ether already released to a payee.
720      */
721     function released(address account) public view returns (uint256) {
722         return _released[account];
723     }
724 
725 
726     /**
727      * @dev Getter for the address of the payee number `index`.
728      */
729     function payee(uint256 index) public view returns (address) {
730         return _payees[index];
731     }
732 
733     /**
734      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
735      * total shares and their previous withdrawals.
736      */
737     function release(address payable account) public virtual {
738         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
739 
740         uint256 totalReceived = address(this).balance + totalReleased();
741         uint256 payment = _pendingPayment(account, totalReceived, released(account));
742 
743         require(payment != 0, "PaymentSplitter: account is not due payment");
744 
745         _released[account] += payment;
746         _totalReleased += payment;
747 
748         Address.sendValue(account, payment);
749         emit PaymentReleased(account, payment);
750     }
751 
752 
753     /**
754      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
755      * already released amounts.
756      */
757     function _pendingPayment(
758         address account,
759         uint256 totalReceived,
760         uint256 alreadyReleased
761     ) private view returns (uint256) {
762         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
763     }
764 
765     /**
766      * @dev Add a new payee to the contract.
767      * @param account The address of the payee to add.
768      * @param shares_ The number of shares owned by the payee.
769      */
770     function _addPayee(address account, uint256 shares_) private {
771         require(account != address(0), "PaymentSplitter: account is the zero address");
772         require(shares_ > 0, "PaymentSplitter: shares are 0");
773         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
774 
775         _payees.push(account);
776         _shares[account] = shares_;
777         _totalShares = _totalShares + shares_;
778         emit PayeeAdded(account, shares_);
779     }
780 }
781 // File: IERC721Receiver.sol
782 
783 
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @title ERC721 token receiver interface
789  * @dev Interface for any contract that wants to support safeTransfers
790  * from ERC721 asset contracts.
791  */
792 interface IERC721Receiver {
793     /**
794      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
795      * by `operator` from `from`, this function is called.
796      *
797      * It must return its Solidity selector to confirm the token transfer.
798      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
799      *
800      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
801      */
802     function onERC721Received(
803         address operator,
804         address from,
805         uint256 tokenId,
806         bytes calldata data
807     ) external returns (bytes4);
808 }
809 // File: IERC165.sol
810 
811 
812 
813 pragma solidity ^0.8.0;
814 
815 /**
816  * @dev Interface of the ERC165 standard, as defined in the
817  * https://eips.ethereum.org/EIPS/eip-165[EIP].
818  *
819  * Implementers can declare support of contract interfaces, which can then be
820  * queried by others ({ERC165Checker}).
821  *
822  * For an implementation, see {ERC165}.
823  */
824 interface IERC165 {
825     /**
826      * @dev Returns true if this contract implements the interface defined by
827      * `interfaceId`. See the corresponding
828      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
829      * to learn more about how these ids are created.
830      *
831      * This function call must use less than 30 000 gas.
832      */
833     function supportsInterface(bytes4 interfaceId) external view returns (bool);
834 }
835 // File: ERC165.sol
836 
837 
838 
839 pragma solidity ^0.8.0;
840 
841 
842 /**
843  * @dev Implementation of the {IERC165} interface.
844  *
845  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
846  * for the additional interface id that will be supported. For example:
847  *
848  * ```solidity
849  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
850  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
851  * }
852  * ```
853  *
854  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
855  */
856 abstract contract ERC165 is IERC165 {
857     /**
858      * @dev See {IERC165-supportsInterface}.
859      */
860     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
861         return interfaceId == type(IERC165).interfaceId;
862     }
863 }
864 // File: IERC721.sol
865 
866 
867 
868 pragma solidity ^0.8.0;
869 
870 
871 /**
872  * @dev Required interface of an ERC721 compliant contract.
873  */
874 interface IERC721 is IERC165 {
875     /**
876      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
877      */
878     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
879 
880     /**
881      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
882      */
883     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
884 
885     /**
886      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
887      */
888     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
889 
890     /**
891      * @dev Returns the number of tokens in ``owner``'s account.
892      */
893     function balanceOf(address owner) external view returns (uint256 balance);
894 
895     /**
896      * @dev Returns the owner of the `tokenId` token.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      */
902     function ownerOf(uint256 tokenId) external view returns (address owner);
903 
904     /**
905      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
906      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
914      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId
922     ) external;
923 
924     /**
925      * @dev Transfers `tokenId` token from `from` to `to`.
926      *
927      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
935      *
936      * Emits a {Transfer} event.
937      */
938     function transferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) external;
943 
944     /**
945      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
946      * The approval is cleared when the token is transferred.
947      *
948      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
949      *
950      * Requirements:
951      *
952      * - The caller must own the token or be an approved operator.
953      * - `tokenId` must exist.
954      *
955      * Emits an {Approval} event.
956      */
957     function approve(address to, uint256 tokenId) external;
958 
959     /**
960      * @dev Returns the account approved for `tokenId` token.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must exist.
965      */
966     function getApproved(uint256 tokenId) external view returns (address operator);
967 
968     /**
969      * @dev Approve or remove `operator` as an operator for the caller.
970      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
971      *
972      * Requirements:
973      *
974      * - The `operator` cannot be the caller.
975      *
976      * Emits an {ApprovalForAll} event.
977      */
978     function setApprovalForAll(address operator, bool _approved) external;
979 
980     /**
981      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
982      *
983      * See {setApprovalForAll}
984      */
985     function isApprovedForAll(address owner, address operator) external view returns (bool);
986 
987     /**
988      * @dev Safely transfers `tokenId` token from `from` to `to`.
989      *
990      * Requirements:
991      *
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must exist and be owned by `from`.
995      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function safeTransferFrom(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes calldata data
1005     ) external;
1006 }
1007 // File: IERC721Enumerable.sol
1008 
1009 
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1016  * @dev See https://eips.ethereum.org/EIPS/eip-721
1017  */
1018 interface IERC721Enumerable is IERC721 {
1019     /**
1020      * @dev Returns the total amount of tokens stored by the contract.
1021      */
1022     function totalSupply() external view returns (uint256);
1023 
1024     /**
1025      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1026      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1029 
1030     /**
1031      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1032      * Use along with {totalSupply} to enumerate all tokens.
1033      */
1034     function tokenByIndex(uint256 index) external view returns (uint256);
1035 }
1036 // File: IERC721Metadata.sol
1037 
1038 
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 
1043 /**
1044  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1045  * @dev See https://eips.ethereum.org/EIPS/eip-721
1046  */
1047 interface IERC721Metadata is IERC721 {
1048     /**
1049      * @dev Returns the token collection name.
1050      */
1051     function name() external view returns (string memory);
1052 
1053     /**
1054      * @dev Returns the token collection symbol.
1055      */
1056     function symbol() external view returns (string memory);
1057 
1058     /**
1059      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1060      */
1061     function tokenURI(uint256 tokenId) external view returns (string memory);
1062 }
1063 // File: ERC721A.sol
1064 
1065 
1066 pragma solidity ^0.8.0;
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 
1076 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1077     using Address for address;
1078     using Strings for uint256;
1079 
1080     struct TokenOwnership {
1081         address addr;
1082         uint64 startTimestamp;
1083     }
1084 
1085     struct AddressData {
1086         uint128 balance;
1087         uint128 numberMinted;
1088     }
1089 
1090     uint256 internal currentIndex;
1091 
1092     // Token name
1093     string private _name;
1094 
1095     // Token symbol
1096     string private _symbol;
1097 
1098     // Mapping from token ID to ownership details
1099     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1100     mapping(uint256 => TokenOwnership) internal _ownerships;
1101 
1102     // Mapping owner address to address data
1103     mapping(address => AddressData) private _addressData;
1104 
1105     // Mapping from token ID to approved address
1106     mapping(uint256 => address) private _tokenApprovals;
1107 
1108     // Mapping from owner to operator approvals
1109     mapping(address => mapping(address => bool)) private _operatorApprovals;
1110 
1111     constructor(string memory name_, string memory symbol_) {
1112         _name = name_;
1113         _symbol = symbol_;
1114     }
1115 
1116     /**
1117      * @dev See {IERC721Enumerable-totalSupply}.
1118      */
1119     function totalSupply() public view override returns (uint256) {
1120         return currentIndex;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-tokenByIndex}.
1125      */
1126     function tokenByIndex(uint256 index) public view override returns (uint256) {
1127         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1128         return index;
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1133      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1134      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1135      */
1136     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1137         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1138         uint256 numMintedSoFar = totalSupply();
1139         uint256 tokenIdsIdx;
1140         address currOwnershipAddr;
1141 
1142         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1143         unchecked {
1144             for (uint256 i; i < numMintedSoFar; i++) {
1145                 TokenOwnership memory ownership = _ownerships[i];
1146                 if (ownership.addr != address(0)) {
1147                     currOwnershipAddr = ownership.addr;
1148                 }
1149                 if (currOwnershipAddr == owner) {
1150                     if (tokenIdsIdx == index) {
1151                         return i;
1152                     }
1153                     tokenIdsIdx++;
1154                 }
1155             }
1156         }
1157 
1158         revert('ERC721A: unable to get token of owner by index');
1159     }
1160 
1161     /**
1162      * @dev See {IERC165-supportsInterface}.
1163      */
1164     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1165         return
1166             interfaceId == type(IERC721).interfaceId ||
1167             interfaceId == type(IERC721Metadata).interfaceId ||
1168             interfaceId == type(IERC721Enumerable).interfaceId ||
1169             super.supportsInterface(interfaceId);
1170     }
1171 
1172     /**
1173      * @dev See {IERC721-balanceOf}.
1174      */
1175     function balanceOf(address owner) public view override returns (uint256) {
1176         require(owner != address(0), 'ERC721A: balance query for the zero address');
1177         return uint256(_addressData[owner].balance);
1178     }
1179 
1180     function _numberMinted(address owner) internal view returns (uint256) {
1181         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1182         return uint256(_addressData[owner].numberMinted);
1183     }
1184 
1185     /**
1186      * Gas spent here starts off proportional to the maximum mint batch size.
1187      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1188      */
1189     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1190         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1191 
1192         unchecked {
1193             for (uint256 curr = tokenId; curr >= 0; curr--) {
1194                 TokenOwnership memory ownership = _ownerships[curr];
1195                 if (ownership.addr != address(0)) {
1196                     return ownership;
1197                 }
1198             }
1199         }
1200 
1201         revert('ERC721A: unable to determine the owner of token');
1202     }
1203 
1204     /**
1205      * @dev See {IERC721-ownerOf}.
1206      */
1207     function ownerOf(uint256 tokenId) public view override returns (address) {
1208         return ownershipOf(tokenId).addr;
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Metadata-name}.
1213      */
1214     function name() public view virtual override returns (string memory) {
1215         return _name;
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Metadata-symbol}.
1220      */
1221     function symbol() public view virtual override returns (string memory) {
1222         return _symbol;
1223     }
1224 
1225     /**
1226      * @dev See {IERC721Metadata-tokenURI}.
1227      */
1228     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1229         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1230 
1231         string memory baseURI = _baseURI();
1232         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1233     }
1234 
1235     /**
1236      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1237      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1238      * by default, can be overriden in child contracts.
1239      */
1240     function _baseURI() internal view virtual returns (string memory) {
1241         return '';
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-approve}.
1246      */
1247     function approve(address to, uint256 tokenId) public override {
1248         address owner = ERC721A.ownerOf(tokenId);
1249         require(to != owner, 'ERC721A: approval to current owner');
1250 
1251         require(
1252             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1253             'ERC721A: approve caller is not owner nor approved for all'
1254         );
1255 
1256         _approve(to, tokenId, owner);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-getApproved}.
1261      */
1262     function getApproved(uint256 tokenId) public view override returns (address) {
1263         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1264 
1265         return _tokenApprovals[tokenId];
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-setApprovalForAll}.
1270      */
1271     function setApprovalForAll(address operator, bool approved) public override {
1272         require(operator != _msgSender(), 'ERC721A: approve to caller');
1273 
1274         _operatorApprovals[_msgSender()][operator] = approved;
1275         emit ApprovalForAll(_msgSender(), operator, approved);
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-isApprovedForAll}.
1280      */
1281     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1282         return _operatorApprovals[owner][operator];
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-transferFrom}.
1287      */
1288     function transferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) public override {
1293         _transfer(from, to, tokenId);
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-safeTransferFrom}.
1298      */
1299     function safeTransferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId
1303     ) public override {
1304         safeTransferFrom(from, to, tokenId, '');
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-safeTransferFrom}.
1309      */
1310     function safeTransferFrom(
1311         address from,
1312         address to,
1313         uint256 tokenId,
1314         bytes memory _data
1315     ) public override {
1316         _transfer(from, to, tokenId);
1317         require(
1318             _checkOnERC721Received(from, to, tokenId, _data),
1319             'ERC721A: transfer to non ERC721Receiver implementer'
1320         );
1321     }
1322 
1323     /**
1324      * @dev Returns whether `tokenId` exists.
1325      *
1326      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1327      *
1328      * Tokens start existing when they are minted (`_mint`),
1329      */
1330     function _exists(uint256 tokenId) internal view returns (bool) {
1331         return tokenId < currentIndex;
1332     }
1333 
1334     function _safeMint(address to, uint256 quantity) internal {
1335         _safeMint(to, quantity, '');
1336     }
1337 
1338     /**
1339      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1340      *
1341      * Requirements:
1342      *
1343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1344      * - `quantity` must be greater than 0.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function _safeMint(
1349         address to,
1350         uint256 quantity,
1351         bytes memory _data
1352     ) internal {
1353         _mint(to, quantity, _data, true);
1354     }
1355 
1356     /**
1357      * @dev Mints `quantity` tokens and transfers them to `to`.
1358      *
1359      * Requirements:
1360      *
1361      * - `to` cannot be the zero address.
1362      * - `quantity` must be greater than 0.
1363      *
1364      * Emits a {Transfer} event.
1365      */
1366     function _mint(
1367         address to,
1368         uint256 quantity,
1369         bytes memory _data,
1370         bool safe
1371     ) internal {
1372         uint256 startTokenId = currentIndex;
1373         require(to != address(0), 'ERC721A: mint to the zero address');
1374         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1375 
1376         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1377 
1378         // Overflows are incredibly unrealistic.
1379         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1380         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1381         unchecked {
1382             _addressData[to].balance += uint128(quantity);
1383             _addressData[to].numberMinted += uint128(quantity);
1384 
1385             _ownerships[startTokenId].addr = to;
1386             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1387 
1388             uint256 updatedIndex = startTokenId;
1389 
1390             for (uint256 i; i < quantity; i++) {
1391                 emit Transfer(address(0), to, updatedIndex);
1392                 if (safe) {
1393                     require(
1394                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1395                         'ERC721A: transfer to non ERC721Receiver implementer'
1396                     );
1397                 }
1398 
1399                 updatedIndex++;
1400             }
1401 
1402             currentIndex = updatedIndex;
1403         }
1404 
1405         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1406     }
1407 
1408     /**
1409      * @dev Transfers `tokenId` from `from` to `to`.
1410      *
1411      * Requirements:
1412      *
1413      * - `to` cannot be the zero address.
1414      * - `tokenId` token must be owned by `from`.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _transfer(
1419         address from,
1420         address to,
1421         uint256 tokenId
1422     ) private {
1423         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1424 
1425         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1426             getApproved(tokenId) == _msgSender() ||
1427             isApprovedForAll(prevOwnership.addr, _msgSender()));
1428 
1429         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1430 
1431         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1432         require(to != address(0), 'ERC721A: transfer to the zero address');
1433 
1434         _beforeTokenTransfers(from, to, tokenId, 1);
1435 
1436         // Clear approvals from the previous owner
1437         _approve(address(0), tokenId, prevOwnership.addr);
1438 
1439         // Underflow of the sender's balance is impossible because we check for
1440         // ownership above and the recipient's balance can't realistically overflow.
1441         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1442         unchecked {
1443             _addressData[from].balance -= 1;
1444             _addressData[to].balance += 1;
1445 
1446             _ownerships[tokenId].addr = to;
1447             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1448 
1449             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1450             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1451             uint256 nextTokenId = tokenId + 1;
1452             if (_ownerships[nextTokenId].addr == address(0)) {
1453                 if (_exists(nextTokenId)) {
1454                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1455                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1456                 }
1457             }
1458         }
1459 
1460         emit Transfer(from, to, tokenId);
1461         _afterTokenTransfers(from, to, tokenId, 1);
1462     }
1463 
1464     /**
1465      * @dev Approve `to` to operate on `tokenId`
1466      *
1467      * Emits a {Approval} event.
1468      */
1469     function _approve(
1470         address to,
1471         uint256 tokenId,
1472         address owner
1473     ) private {
1474         _tokenApprovals[tokenId] = to;
1475         emit Approval(owner, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1480      * The call is not executed if the target address is not a contract.
1481      *
1482      * @param from address representing the previous owner of the given token ID
1483      * @param to target address that will receive the tokens
1484      * @param tokenId uint256 ID of the token to be transferred
1485      * @param _data bytes optional data to send along with the call
1486      * @return bool whether the call correctly returned the expected magic value
1487      */
1488     function _checkOnERC721Received(
1489         address from,
1490         address to,
1491         uint256 tokenId,
1492         bytes memory _data
1493     ) private returns (bool) {
1494         if (to.isContract()) {
1495             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1496                 return retval == IERC721Receiver(to).onERC721Received.selector;
1497             } catch (bytes memory reason) {
1498                 if (reason.length == 0) {
1499                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1500                 } else {
1501                     assembly {
1502                         revert(add(32, reason), mload(reason))
1503                     }
1504                 }
1505             }
1506         } else {
1507             return true;
1508         }
1509     }
1510 
1511     /**
1512      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1513      *
1514      * startTokenId - the first token id to be transferred
1515      * quantity - the amount to be transferred
1516      *
1517      * Calling conditions:
1518      *
1519      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1520      * transferred to `to`.
1521      * - When `from` is zero, `tokenId` will be minted for `to`.
1522      */
1523     function _beforeTokenTransfers(
1524         address from,
1525         address to,
1526         uint256 startTokenId,
1527         uint256 quantity
1528     ) internal virtual {}
1529 
1530     /**
1531      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1532      * minting.
1533      *
1534      * startTokenId - the first token id to be transferred
1535      * quantity - the amount to be transferred
1536      *
1537      * Calling conditions:
1538      *
1539      * - when `from` and `to` are both non-zero.
1540      * - `from` and `to` are never both zero.
1541      */
1542     function _afterTokenTransfers(
1543         address from,
1544         address to,
1545         uint256 startTokenId,
1546         uint256 quantity
1547     ) internal virtual {}
1548 }
1549 
1550 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1551 
1552 pragma solidity ^0.8.0;
1553 
1554 /**
1555  * @dev Contract module that helps prevent reentrant calls to a function.
1556  *
1557  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1558  * available, which can be applied to functions to make sure there are no nested
1559  * (reentrant) calls to them.
1560  *
1561  * Note that because there is a single `nonReentrant` guard, functions marked as
1562  * `nonReentrant` may not call one another. This can be worked around by making
1563  * those functions `private`, and then adding `external` `nonReentrant` entry
1564  * points to them.
1565  *
1566  * TIP: If you would like to learn more about reentrancy and alternative ways
1567  * to protect against it, check out our blog post
1568  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1569  */
1570 abstract contract ReentrancyGuard {
1571     // Booleans are more expensive than uint256 or any type that takes up a full
1572     // word because each write operation emits an extra SLOAD to first read the
1573     // slot's contents, replace the bits taken up by the boolean, and then write
1574     // back. This is the compiler's defense against contract upgrades and
1575     // pointer aliasing, and it cannot be disabled.
1576 
1577     // The values being non-zero value makes deployment a bit more expensive,
1578     // but in exchange the refund on every call to nonReentrant will be lower in
1579     // amount. Since refunds are capped to a percentage of the total
1580     // transaction's gas, it is best to keep them low in cases like this one, to
1581     // increase the likelihood of the full refund coming into effect.
1582     uint256 private constant _NOT_ENTERED = 1;
1583     uint256 private constant _ENTERED = 2;
1584 
1585     uint256 private _status;
1586 
1587     constructor() {
1588         _status = _NOT_ENTERED;
1589     }
1590 
1591     /**
1592      * @dev Prevents a contract from calling itself, directly or indirectly.
1593      * Calling a `nonReentrant` function from another `nonReentrant`
1594      * function is not supported. It is possible to prevent this from happening
1595      * by making the `nonReentrant` function external, and making it call a
1596      * `private` function that does the actual work.
1597      */
1598     modifier nonReentrant() {
1599         // On the first call to nonReentrant, _notEntered will be true
1600         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1601 
1602         // Any calls to nonReentrant after this point will fail
1603         _status = _ENTERED;
1604 
1605         _;
1606 
1607         // By storing the original value once again, a refund is triggered (see
1608         // https://eips.ethereum.org/EIPS/eip-2200)
1609         _status = _NOT_ENTERED;
1610     }
1611 }
1612 
1613 
1614 
1615 pragma solidity ^0.8.0;
1616 
1617 /**********************************************************\
1618 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
1619 * EIP-5050 Token Interaction Standard: [tbd]
1620 *
1621 * Implementation of an interactive token protocol.
1622 /**********************************************************/
1623 
1624 /// @title ERC-5050 Token Interaction Standard
1625 /// @dev See https://eips.ethereum.org/EIPS/eip-xxx
1626 interface IERC5050Sender {
1627     /// @notice Send an action to the target address
1628     /// @dev The action's `fromContract` is automatically set to `address(this)`,
1629     /// and the `from` parameter is set to `msg.sender`.
1630     /// @param action The action to send
1631     function sendAction(Action memory action) external payable;
1632 
1633     /// @notice Check if an action is valid based on its hash and nonce
1634     /// @dev When an action passes through all three possible contracts
1635     /// (`fromContract`, `to`, and `state`) the `state` contract validates the
1636     /// action with the initating `fromContract` using a nonced action hash.
1637     /// This hash is calculated and saved to storage on the `fromContract` before
1638     /// action handling is initiated. The `state` contract calculates the hash
1639     /// and verifies it and nonce with the `fromContract`.
1640     /// @param _hash The hash to validate
1641     /// @param _nonce The nonce to validate
1642     function isValid(bytes32 _hash, uint256 _nonce) external returns (bool);
1643 
1644     /// @notice Retrieve list of actions that can be sent.
1645     /// @dev Intended for use by off-chain applications to query compatible contracts,
1646     /// and to advertise functionality in human-readable form.
1647     function sendableActions() external view returns (string[] memory);
1648 
1649     /// @notice Change or reaffirm the approved address for an action
1650     /// @dev The zero address indicates there is no approved address.
1651     ///  Throws unless `msg.sender` is the `_account`, or an authorized
1652     ///  operator of the `_account`.
1653     /// @param _account The account of the account-action pair to approve
1654     /// @param _action The action of the account-action pair to approve
1655     /// @param _approved The new approved account-action controller
1656     function approveForAction(
1657         address _account,
1658         bytes4 _action,
1659         address _approved
1660     ) external returns (bool);
1661 
1662     /// @notice Enable or disable approval for a third party ("operator") to conduct
1663     ///  all actions on behalf of `msg.sender`
1664     /// @dev Emits the ApprovalForAll event. The contract MUST allow
1665     ///  an unbounded number of operators per owner.
1666     /// @param _operator Address to add to the set of authorized operators
1667     /// @param _approved True if the operator is approved, false to revoke approval
1668     function setApprovalForAllActions(address _operator, bool _approved)
1669         external;
1670 
1671     /// @notice Get the approved address for an account-action pair
1672     /// @dev Throws if `_tokenId` is not a valid NFT.
1673     /// @param _account The account of the account-action to find the approved address for
1674     /// @param _action The action of the account-action to find the approved address for
1675     /// @return The approved address for this account-action, or the zero address if
1676     ///  there is none
1677     function getApprovedForAction(address _account, bytes4 _action)
1678         external
1679         view
1680         returns (address);
1681 
1682     /// @notice Query if an address is an authorized operator for another address
1683     /// @param _account The address on whose behalf actions are performed
1684     /// @param _operator The address that acts on behalf of the account
1685     /// @return True if `_operator` is an approved operator for `_account`, false otherwise
1686     function isApprovedForAllActions(address _account, address _operator)
1687         external
1688         view
1689         returns (bool);
1690 
1691     /// @dev This emits when an action is sent (`sendAction()`)
1692     event SendAction(
1693         bytes4 indexed name,
1694         address _from,
1695         address indexed _fromContract,
1696         uint256 _tokenId,
1697         address indexed _to,
1698         uint256 _toTokenId,
1699         address _state,
1700         bytes _data
1701     );
1702 
1703     /// @dev This emits when the approved address for an account-action pair
1704     ///  is changed or reaffirmed. The zero address indicates there is no
1705     ///  approved address.
1706     event ApprovalForAction(
1707         address indexed _account,
1708         bytes4 indexed _action,
1709         address indexed _approved
1710     );
1711 
1712     /// @dev This emits when an operator is enabled or disabled for an account.
1713     ///  The operator can conduct all actions on behalf of the account.
1714     event ApprovalForAllActions(
1715         address indexed _account,
1716         address indexed _operator,
1717         bool _approved
1718     );
1719 }
1720 
1721 interface IERC5050Receiver {
1722     /// @notice Handle an action
1723     /// @dev Both the `to` contract and `state` contract are called via
1724     /// `onActionReceived()`.
1725     /// @param action The action to handle
1726     function onActionReceived(Action calldata action, uint256 _nonce)
1727         external
1728         payable;
1729 
1730     /// @notice Retrieve list of actions that can be received.
1731     /// @dev Intended for use by off-chain applications to query compatible contracts,
1732     /// and to advertise functionality in human-readable form.
1733     function receivableActions() external view returns (string[] memory);
1734 
1735     /// @dev This emits when a valid action is received.
1736     event ActionReceived(
1737         bytes4 indexed name,
1738         address _from,
1739         address indexed _fromContract,
1740         uint256 _tokenId,
1741         address indexed _to,
1742         uint256 _toTokenId,
1743         address _state,
1744         bytes _data
1745     );
1746 }
1747 
1748 /// @param _address The address of the interactive object
1749 /// @param tokenId The token that is interacting (optional)
1750 struct Object {
1751     address _address;
1752     uint256 _tokenId;
1753 }
1754 
1755 /// @param selector The bytes4(keccack256()) encoding of the action string
1756 /// @param user The address of the sender
1757 /// @param from The initiating object
1758 /// @param to The receiving object
1759 /// @param state The state contract
1760 /// @param data Additional data with no specified format
1761 struct Action {
1762     bytes4 selector;
1763     address user;
1764     Object from;
1765     Object to;
1766     address state;
1767     bytes data;
1768 }
1769 
1770 // Barely modified version of OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
1771 
1772 pragma solidity ^0.8.0;
1773 
1774 library ActionsSet {
1775     struct Set {
1776         // Storage of action names
1777         string[] _names;
1778         // Storage of action selectors
1779         bytes4[] _selectors;
1780         // Position of the value in the `values` array, plus 1 because index 0
1781         // means a value is not in the set.
1782         mapping(bytes4 => uint256) _indexes;
1783     }
1784 
1785     /**
1786      * @dev Add a value to a set. O(1).
1787      *
1788      * Returns true if the value was added to the set, that is if it was not
1789      * already present.
1790      */
1791     function add(Set storage set, string memory name) internal returns (bool) {
1792         bytes4 selector = bytes4(keccak256(bytes(name)));
1793         if (!contains(set, selector)) {
1794             set._selectors.push(selector);
1795             set._names.push(name);
1796             // The value is stored at length-1, but we add 1 to all indexes
1797             // and use 0 as a sentinel value
1798             set._indexes[selector] = set._selectors.length;
1799             return true;
1800         } else {
1801             return false;
1802         }
1803     }
1804 
1805     /**
1806      * @dev Removes a value from a set. O(1).
1807      *
1808      * Returns true if the value was removed from the set, that is if it was
1809      * present.
1810      */
1811     function remove(Set storage set, bytes4 value) internal returns (bool) {
1812         // We read and store the value's index to prevent multiple reads from the same storage slot
1813         uint256 valueIndex = set._indexes[value];
1814 
1815         if (valueIndex != 0) {
1816             // Equivalent to contains(set, value)
1817             // To delete an element from the _selectors array in O(1), we swap the element to delete with the last one in
1818             // the array, and then remove the last element (sometimes called as 'swap and pop').
1819             // This modifies the order of the array, as noted in {at}.
1820 
1821             uint256 toDeleteIndex = valueIndex - 1;
1822             uint256 lastIndex = set._selectors.length - 1;
1823 
1824             if (lastIndex != toDeleteIndex) {
1825                 bytes4 lastValue = set._selectors[lastIndex];
1826 
1827                 // Move the last value to the index where the value to delete is
1828                 set._selectors[toDeleteIndex] = lastValue;
1829                 // Update the index for the moved value
1830                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1831             }
1832 
1833             // Delete the slot where the moved value was stored
1834             set._selectors.pop();
1835 
1836             // Delete the index for the deleted slot
1837             delete set._indexes[value];
1838 
1839             return true;
1840         } else {
1841             return false;
1842         }
1843     }
1844 
1845     /**
1846      * @dev Returns true if the value is in the set. O(1).
1847      */
1848     function contains(Set storage set, bytes4 value)
1849         internal
1850         view
1851         returns (bool)
1852     {
1853         return set._indexes[value] != 0;
1854     }
1855 
1856     /**
1857      * @dev Returns the number of values on the set. O(1).
1858      */
1859     function length(Set storage set) internal view returns (uint256) {
1860         return set._selectors.length;
1861     }
1862 
1863     /**
1864      * @dev Returns the value stored at position `index` in the set. O(1).
1865      *
1866      * Note that there are no guarantees on the ordering of values inside the
1867      * array, and it may change when more values are added or removed.
1868      *
1869      * Requirements:
1870      *
1871      * - `index` must be strictly less than {length}.
1872      */
1873     function at(Set storage set, uint256 index) internal view returns (bytes4) {
1874         return set._selectors[index];
1875     }
1876 
1877     /**
1878      * @dev Return the entire set of action names
1879      *
1880      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1881      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1882      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1883      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1884      */
1885     function names(Set storage set) internal view returns (string[] memory) {
1886         return set._names;
1887     }
1888     
1889     /**
1890      * @dev Return the entire set of action selectors
1891      *
1892      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1893      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1894      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1895      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1896      */
1897     function selectors(Set storage set) internal view returns (bytes4[] memory) {
1898         return set._selectors;
1899     }
1900     
1901     
1902 }
1903 
1904 pragma solidity ^0.8.0;
1905 
1906 /**********************************************************\
1907 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
1908 * EIP-5050 Token Interaction Standard: [tbd]
1909 *
1910 * Implementation of an interactive token protocol.
1911 /**********************************************************/
1912 
1913 interface IControllable {
1914     event ControllerApproval(
1915         address indexed _controller,
1916         bytes4 indexed _action
1917     );
1918     
1919     event ControllerApprovalForAll(
1920         address indexed _controller,
1921         bool _approved
1922     );
1923     
1924     function approveController(address _controller, bytes4 _action)
1925         external;
1926 
1927     function setControllerApprovalForAll(address _controller, bool _approved)
1928         external;
1929 
1930     function isApprovedController(address _controller, bytes4 _action)
1931         external
1932         view
1933         returns (bool);
1934 }
1935 
1936 
1937 pragma solidity ^0.8.0;
1938 
1939 /**********************************************************\
1940 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
1941 * EIP-5050 Token Interaction Standard: [tbd]
1942 *
1943 * Implementation of an interactive token protocol.
1944 /**********************************************************/
1945 
1946 contract Controllable is IControllable {
1947     mapping(address => mapping(bytes4 => bool)) private _actionControllers;
1948     mapping(address => bool) private _universalControllers;
1949 
1950     function approveController(address _controller, bytes4 _action)
1951         external
1952         virtual
1953     {
1954         _actionControllers[_controller][_action] = true;
1955         emit ControllerApproval(
1956             _controller,
1957             _action
1958         );
1959     }
1960     
1961     function setControllerApprovalForAll(address _controller, bool _approved)
1962         external
1963         virtual
1964     {
1965         _universalControllers[_controller] = _approved;
1966         emit ControllerApprovalForAll(
1967             _controller,
1968             _approved
1969         );
1970     }
1971 
1972     function isApprovedController(address _controller, bytes4 _action)
1973         external
1974         view
1975         returns (bool)
1976     {
1977         return _isApprovedController(_controller, _action);
1978     }
1979 
1980     function _isApprovedController(address _controller, bytes4 _action)
1981         internal
1982         view
1983         returns (bool)
1984     {
1985         if (_universalControllers[_controller]) {
1986             return true;
1987         }
1988         return _actionControllers[_controller][_action];
1989     }
1990 }
1991 
1992 pragma solidity ^0.8.0;
1993 
1994 /**********************************************************\
1995 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
1996 * EIP-5050 Token Interaction Standard: [tbd]
1997 *
1998 * Implementation of an interactive token protocol.
1999 /**********************************************************/
2000 
2001 contract ERC5050Sender is Controllable, IERC5050Sender {
2002     using Address for address;
2003     using ActionsSet for ActionsSet.Set;
2004 
2005     ActionsSet.Set _sendableActions;
2006 
2007     uint256 private _nonce;
2008     bytes32 private _hash;
2009 
2010     mapping(address => mapping(bytes4 => address)) actionApprovals;
2011     mapping(address => mapping(address => bool)) operatorApprovals;
2012 
2013     function sendAction(Action memory action)
2014         external
2015         payable
2016         virtual
2017         override
2018     {
2019         _sendAction(action);
2020     }
2021 
2022     function isValid(bytes32 actionHash, uint256 nonce)
2023         external
2024         view
2025         returns (bool)
2026     {
2027         return actionHash == _hash && nonce == _nonce;
2028     }
2029 
2030     function sendableActions() external view returns (string[] memory) {
2031         return _sendableActions.names();
2032     }
2033 
2034     modifier onlySendableAction(Action memory action) {
2035         if (_isApprovedController(msg.sender, action.selector)) {
2036             return;
2037         }
2038         require(
2039             _sendableActions.contains(action.selector),
2040             "ERC5050: invalid action"
2041         );
2042         require(
2043             _isApprovedOrSelf(action.user, action.selector),
2044             "ERC5050: unapproved sender"
2045         );
2046         _;
2047     }
2048 
2049     function approveForAction(
2050         address _account,
2051         bytes4 _action,
2052         address _approved
2053     ) public virtual override returns (bool) {
2054         require(_approved != _account, "ERC5050: approve to caller");
2055 
2056         require(
2057             msg.sender == _account ||
2058                 isApprovedForAllActions(_account, msg.sender),
2059             "ERC5050: approve caller is not account nor approved for all"
2060         );
2061 
2062         actionApprovals[_account][_action] = _approved;
2063         emit ApprovalForAction(_account, _action, _approved);
2064 
2065         return true;
2066     }
2067 
2068     function setApprovalForAllActions(address _operator, bool _approved)
2069         public
2070         virtual
2071         override
2072     {
2073         require(msg.sender != _operator, "ERC5050: approve to caller");
2074 
2075         operatorApprovals[msg.sender][_operator] = _approved;
2076 
2077         emit ApprovalForAllActions(msg.sender, _operator, _approved);
2078     }
2079 
2080     function getApprovedForAction(address _account, bytes4 _action)
2081         public
2082         view
2083         returns (address)
2084     {
2085         return actionApprovals[_account][_action];
2086     }
2087 
2088     function isApprovedForAllActions(address _account, address _operator)
2089         public
2090         view
2091         returns (bool)
2092     {
2093         return operatorApprovals[_account][_operator];
2094     }
2095 
2096     function _sendAction(Action memory action) internal {
2097         if (!_isApprovedController(msg.sender, action.selector)) {
2098             action.from._address = address(this);
2099             bool toIsContract = action.to._address.isContract();
2100             bool stateIsContract = action.state.isContract();
2101             address next;
2102             if (toIsContract) {
2103                 next = action.to._address;
2104             } else if (stateIsContract) {
2105                 next = action.state;
2106             }
2107             uint256 nonce;
2108             if (toIsContract && stateIsContract) {
2109                 _validate(action);
2110                 nonce = _nonce;
2111             }
2112             if (next.isContract()) {
2113                 try
2114                     IERC5050Receiver(next).onActionReceived{value: msg.value}(
2115                         action,
2116                         nonce
2117                     )
2118                 {} catch Error(string memory err) {
2119                     revert(err);
2120                 } catch (bytes memory returnData) {
2121                     if (returnData.length > 0) {
2122                         revert(string(returnData));
2123                     }
2124                 }
2125             }
2126         }
2127         emit SendAction(
2128             action.selector,
2129             action.user,
2130             action.from._address,
2131             action.from._tokenId,
2132             action.to._address,
2133             action.to._tokenId,
2134             action.state,
2135             action.data
2136         );
2137     }
2138 
2139     function _validate(Action memory action) internal {
2140         ++_nonce;
2141         _hash = bytes32(
2142             keccak256(
2143                 abi.encodePacked(
2144                     action.selector,
2145                     action.user,
2146                     action.from._address,
2147                     action.from._tokenId,
2148                     action.to._address,
2149                     action.to._tokenId,
2150                     action.state,
2151                     action.data,
2152                     _nonce
2153                 )
2154             )
2155         );
2156     }
2157 
2158     function _isApprovedOrSelf(address account, bytes4 action)
2159         internal
2160         view
2161         returns (bool)
2162     {
2163         return (msg.sender == account ||
2164             isApprovedForAllActions(account, msg.sender) ||
2165             getApprovedForAction(account, action) == msg.sender);
2166     }
2167 
2168     function _registerSendable(string memory action) internal {
2169         _sendableActions.add(action);
2170     }
2171 }
2172 
2173 pragma solidity ^0.8.0;
2174 
2175 /**********************************************************\
2176 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
2177 * EIP-5050 Token Interaction Standard: [tbd]
2178 *
2179 * Implementation of an interactive token protocol.
2180 /**********************************************************/
2181 
2182 
2183 contract ERC5050Receiver is Controllable, IERC5050Receiver {
2184     using Address for address;
2185     using ActionsSet for ActionsSet.Set;
2186 
2187     ActionsSet.Set _receivableActions;
2188 
2189     modifier onlyReceivableAction(Action calldata action, uint256 nonce) {
2190         if (_isApprovedController(msg.sender, action.selector)) {
2191             return;
2192         }
2193         require(
2194             action.to._address == address(this),
2195             "ERC5050: invalid receiver"
2196         );
2197         require(
2198             _receivableActions.contains(action.selector),
2199             "ERC5050: invalid action"
2200         );
2201         require(
2202             action.from._address == address(0) ||
2203                 action.from._address == msg.sender,
2204             "ERC5050: invalid sender"
2205         );
2206         require(
2207             (action.from._address != address(0) && action.user == tx.origin) ||
2208                 action.user == msg.sender,
2209             "ERC5050: invalid sender"
2210         );
2211         _;
2212     }
2213 
2214     function receivableActions() external view returns (string[] memory) {
2215         return _receivableActions.names();
2216     }
2217 
2218     function onActionReceived(Action calldata action, uint256 nonce)
2219         external
2220         payable
2221         virtual
2222         override
2223         onlyReceivableAction(action, nonce)
2224     {
2225         _onActionReceived(action, nonce);
2226     }
2227 
2228     function _onActionReceived(Action calldata action, uint256 nonce)
2229         internal
2230         virtual
2231     {
2232         if (!_isApprovedController(msg.sender, action.selector)) {
2233             if (action.state != address(0)) {
2234                 require(action.state.isContract(), "ERC5050: invalid state");
2235                 try
2236                     IERC5050Receiver(action.state).onActionReceived{
2237                         value: msg.value
2238                     }(action, nonce)
2239                 {} catch (bytes memory reason) {
2240                     if (reason.length == 0) {
2241                         revert("ERC5050: call to non ERC5050Receiver");
2242                     } else {
2243                         assembly {
2244                             revert(add(32, reason), mload(reason))
2245                         }
2246                     }
2247                 }
2248             }
2249         }
2250         emit ActionReceived(
2251             action.selector,
2252             action.user,
2253             action.from._address,
2254             action.from._tokenId,
2255             action.to._address,
2256             action.to._tokenId,
2257             action.state,
2258             action.data
2259         );
2260     }
2261 
2262     function _registerReceivable(string memory action) internal {
2263         _receivableActions.add(action);
2264     }
2265 }
2266 
2267 pragma solidity ^0.8.0;
2268 
2269 /**********************************************************\
2270 * Author: alxi <chitch@alxi.nl> (https://twitter.com/0xalxi)
2271 * EIP-5050 Token Interaction Standard: [tbd]
2272 *
2273 * Implementation of an interactive token protocol.
2274 /**********************************************************/
2275 
2276 contract ERC5050 is ERC5050Sender, ERC5050Receiver {
2277     function _registerAction(string memory action) internal {
2278         _registerReceivable(action);
2279         _registerSendable(action);
2280     }
2281 }
2282 
2283 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2284 
2285 pragma solidity ^0.8.0;
2286 
2287 /**
2288  * @dev Interface of the ERC20 standard as defined in the EIP.
2289  */
2290 interface IERC20 {
2291     /**
2292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2293      * another (`to`).
2294      *
2295      * Note that `value` may be zero.
2296      */
2297     event Transfer(address indexed from, address indexed to, uint256 value);
2298 
2299     /**
2300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2301      * a call to {approve}. `value` is the new allowance.
2302      */
2303     event Approval(address indexed owner, address indexed spender, uint256 value);
2304 
2305     /**
2306      * @dev Returns the amount of tokens in existence.
2307      */
2308     function totalSupply() external view returns (uint256);
2309 
2310     /**
2311      * @dev Returns the amount of tokens owned by `account`.
2312      */
2313     function balanceOf(address account) external view returns (uint256);
2314 
2315     /**
2316      * @dev Moves `amount` tokens from the caller's account to `to`.
2317      *
2318      * Returns a boolean value indicating whether the operation succeeded.
2319      *
2320      * Emits a {Transfer} event.
2321      */
2322     function transfer(address to, uint256 amount) external returns (bool);
2323 
2324     /**
2325      * @dev Returns the remaining number of tokens that `spender` will be
2326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2327      * zero by default.
2328      *
2329      * This value changes when {approve} or {transferFrom} are called.
2330      */
2331     function allowance(address owner, address spender) external view returns (uint256);
2332 
2333     /**
2334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2335      *
2336      * Returns a boolean value indicating whether the operation succeeded.
2337      *
2338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2339      * that someone may use both the old and the new allowance by unfortunate
2340      * transaction ordering. One possible solution to mitigate this race
2341      * condition is to first reduce the spender's allowance to 0 and set the
2342      * desired value afterwards:
2343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2344      *
2345      * Emits an {Approval} event.
2346      */
2347     function approve(address spender, uint256 amount) external returns (bool);
2348 
2349     /**
2350      * @dev Moves `amount` tokens from `from` to `to` using the
2351      * allowance mechanism. `amount` is then deducted from the caller's
2352      * allowance.
2353      *
2354      * Returns a boolean value indicating whether the operation succeeded.
2355      *
2356      * Emits a {Transfer} event.
2357      */
2358     function transferFrom(
2359         address from,
2360         address to,
2361         uint256 amount
2362     ) external returns (bool);
2363 }
2364 
2365 pragma solidity ^0.8.2;
2366 
2367 interface IToken {
2368     function balanceOf(address) external view returns (uint256);
2369 }
2370 
2371 
2372 contract terrariumClub is ERC721A, ERC5050, Ownable, ReentrancyGuard {  
2373     using Strings for uint256;
2374     string public _shroomies;
2375     string public _magicShroomies;
2376     string public mycelianTruth = unicode"つ◕_◕つ 🍄";
2377     bool public mushroomization = false;
2378     uint256 public mushrooms = 10000;
2379     uint256 public royalSpores = 10;
2380     uint256 public myceliumMana = 420;
2381     uint256 public grewUpOnTheDead = 0;
2382     uint256 public shroomsMintLimit = 24;
2383     bool public teamMinted = false;
2384     mapping(address => bool) public claimStatuses;
2385     mapping(address => uint256) public mushroomCounter;
2386     mapping(uint256 => bool) public sporeMushrooms;
2387     mapping(uint256 => bool) public magicMushrooms;
2388     mapping(uint256 => uint256) public eatCooldown;
2389     mapping(uint256 => bool) public isRoyal;
2390 
2391     address spells;
2392 
2393     bytes4 public constant CAST_SELECTOR = bytes4(keccak256("cast"));
2394     bytes4 public constant EAT_SHROOM_SELECTOR = bytes4(keccak256("eat_shroom"));
2395 
2396     uint256 constant MUSHROOM_PRICE = 0.0420 ether;
2397     uint256 constant LEET_PRICE = 0.31337 ether;
2398 
2399 
2400     event MushroomEaten(uint shroomId);
2401 
2402 	constructor() ERC721A("terrariumClub", "SHROOM") {
2403         _registerReceivable("cast");
2404         _registerReceivable("eat_shroom");
2405     }
2406 
2407     address constant internal fertile_ground = 0x000000000000000000000000000000000000dEaD;
2408     address constant internal goblintown_address = 0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e;
2409     address constant internal hyperloot_address = 0x0290d49f53A8d186973B82faaFdaFe696B29AcBb;
2410     address constant internal loot_address = 0xFF9C1b15B16263C61d017ee9F65C50e4AE0113D7;
2411     address constant internal genesis_adventurers_address = 0x8dB687aCEb92c66f013e1D614137238Cc698fEdb;
2412     address constant internal cryptoadz_address = 0x1CB1A5e65610AEFF2551A50f76a87a7d3fB649C6;
2413     address constant internal blitnauts_address = 0x448f3219CF2A23b0527A7a0158e7264B87f635Db;
2414     address constant internal chainrunners_address = 0x97597002980134beA46250Aa0510C9B90d87A587;
2415     address constant internal nouns_address = 0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03;
2416     address constant internal wagdie_address = 0x659A4BdaAaCc62d2bd9Cb18225D9C89b5B697A5A;
2417     address constant internal grugs_lair_address = 0xFA9Ed22ca5D329eCaee9347F72E18C1fC291471b;
2418 
2419 
2420     function _baseURI() internal view virtual override returns (string memory) {
2421         return _shroomies;
2422     }
2423 
2424     function _magicURI() internal view virtual returns (string memory) {
2425         return _magicShroomies;
2426     }
2427 
2428 
2429     // for cc0 frens つ◕_◕つ 🍄
2430  	function claimMushroom() external nonReentrant {
2431   	    uint256 shroomId = totalSupply();
2432         require(mushroomization, "Mushroomization isn't started");
2433         require(shroomId < mushrooms, "No spores left...");
2434         require(msg.sender == tx.origin);
2435     	require(!claimStatuses[msg.sender], "Mushroom already claimed");
2436         require(
2437             IToken(goblintown_address).balanceOf(msg.sender) > 0 ||
2438             IToken(hyperloot_address).balanceOf(msg.sender) > 0 ||
2439             IToken(loot_address).balanceOf(msg.sender) > 0 ||
2440             IToken(genesis_adventurers_address).balanceOf(msg.sender) > 0 ||
2441             IToken(cryptoadz_address).balanceOf(msg.sender) > 0 ||
2442             IToken(blitnauts_address).balanceOf(msg.sender) > 0 ||
2443             IToken(chainrunners_address).balanceOf(msg.sender) > 0 ||
2444             IToken(nouns_address).balanceOf(msg.sender) > 0 ||
2445             IToken(wagdie_address).balanceOf(msg.sender) > 0 ||
2446             IToken(grugs_lair_address).balanceOf(msg.sender) > 0,
2447             "u dont l00k l1k3 cc0 / fren =_="
2448         );
2449         _safeMint(msg.sender, 1);
2450         claimStatuses[msg.sender] = true;
2451         sporeMushrooms[shroomId] = true;
2452     }
2453 
2454     // つ◕_◕つ 🍄🙏
2455     function mintMushrooms(uint256 _mushrooms) external payable nonReentrant mintConditions(_mushrooms) {
2456         uint256 mintedMushrooms = mushroomCounter[msg.sender];
2457         require(mintedMushrooms + _mushrooms <= shroomsMintLimit, "User max mint limit");
2458         require(msg.value >= (MUSHROOM_PRICE * _mushrooms), unicode"Wow, pls attach 0.0420 ether per mushroom つ◕_◕つ");
2459         _safeMint(msg.sender, _mushrooms);
2460         mushroomCounter[msg.sender] = (mintedMushrooms + _mushrooms);
2461     }
2462 
2463     // つ◕_◕つ 🍄💀
2464     function rebirthTheDead() external nonReentrant mintConditions(1) {
2465     	require(!claimStatuses[msg.sender], "Mushroom already claimed");
2466         require(
2467             grewUpOnTheDead < IToken(wagdie_address).balanceOf(fertile_ground),
2468             "All the dead already reborn."
2469         );
2470         _safeMint(msg.sender, 1);
2471         grewUpOnTheDead += 1;
2472         claimStatuses[msg.sender] = true;
2473     }
2474 
2475     // つ◕_◕つ 🍄👑
2476     function mintRoyal() external payable nonReentrant {
2477         uint256 shroomId = totalSupply();
2478         require(mushroomization, "Mushroomization isn't started");
2479         require(royalSpores > 0, "No more leet spores...");
2480         require(shroomId < mushrooms, "No spores left...");
2481         require(msg.sender == tx.origin);
2482         require(msg.value >= LEET_PRICE, unicode"Royal Shrooms requiring つ◕_◕つ 0.31337 ether");
2483         _safeMint(msg.sender, 1);
2484         royalSpores -= 1;
2485         isRoyal[shroomId] = true;
2486 
2487     }
2488 
2489     // in case of mushroomed ser want to send a shroom to fren つ◕_◕つ 🍄
2490     function dropSporeToFren(address fren, uint256 shroomId) external nonReentrant mintConditions(1) {
2491         require(msg.sender != fren);
2492         require(ownerOf(shroomId) == msg.sender);
2493         require(sporeMushrooms[shroomId], "no spores in ur shroom");
2494         _safeMint(fren, 1);
2495         sporeMushrooms[shroomId] = false;
2496     }
2497 
2498     // つ◕_◕つ 🔮
2499     function onActionReceived(Action calldata action, uint256 _nonce)
2500         external
2501         payable
2502         override
2503         onlyReceivableAction(action, _nonce)
2504     {
2505         require(action.selector == CAST_SELECTOR || action.selector == EAT_SHROOM_SELECTOR, "Mushrooms: invalid action.selector");
2506         if (action.selector == CAST_SELECTOR){
2507             require(action.from._address == spells, "Mushrooms: invalid action.from");
2508             require(action.user == ownerOf(action.to._tokenId), "Mushrooms: sender not owner of this mushroom");
2509             require(!magicMushrooms[action.to._tokenId], "Only one cast per tokenID");
2510             require(myceliumMana > 0, "No mana left");
2511             magicMushrooms[action.to._tokenId] = true;
2512             myceliumMana -= 1;
2513         }
2514         if (action.selector == EAT_SHROOM_SELECTOR){
2515             require(action.user == ownerOf(action.to._tokenId), "Mushrooms: sender not owner of this mushroom");
2516             require(eatCooldown[action.to._tokenId] - block.number < 5000, "You can eat mushrooms only once per 5000 blocks");
2517             emit MushroomEaten(action.to._tokenId);
2518             eatCooldown[action.to._tokenId] = block.number;
2519         }
2520         _onActionReceived(action, _nonce);
2521     }
2522 
2523     // つ◕_◕つ 💬
2524     function broadcastMycelialMessage (uint256 shroomId, string calldata message) public {
2525         require(msg.sender == ownerOf(shroomId), "Mushrooms: sender not owner");
2526         require(isRoyal[shroomId], "Mushroom isn't royal");
2527         mycelianTruth = message;
2528     }
2529 
2530     // つ◕_◕つ 🍄
2531  	function teamHarvest(uint256 _mushrooms) public onlyOwner {
2532         require(!teamMinted);
2533   	    uint256 totalmushrooms = totalSupply();
2534 	    require(totalmushrooms + _mushrooms <= mushrooms);
2535         _safeMint(msg.sender, _mushrooms);
2536         teamMinted = true;
2537     }
2538 
2539     // つ◕_◕つ 🍄
2540     function startMushroomization(bool _mushroomization) external onlyOwner {
2541         mushroomization = _mushroomization;
2542     }
2543 
2544      // つ◕_◕つ 🍄
2545     function visualize(string memory link) external onlyOwner {
2546         _shroomies = link;
2547     }
2548 
2549     // つ◕_◕つ 🔮
2550     function doSomethingMagic(string memory magicLink) external onlyOwner {
2551         _magicShroomies = magicLink;
2552     }
2553 
2554     // つ◕_◕つ thought to rename but deployed to blockchain how it was in goblintown
2555     function sumthinboutfunds() public payable onlyOwner {
2556 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2557 		require(success);
2558 	}
2559 
2560     function somethingAboutTokens(address token) external onlyOwner {
2561         uint256 balance = IERC20(token).balanceOf(address(this));
2562         IERC20(token).transfer(msg.sender, balance);
2563     }
2564 
2565     function setSpellsAddress(address _spells) external onlyOwner {
2566         spells = _spells;
2567     }
2568 
2569     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
2570         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2571 
2572         string memory baseURI = _baseURI();
2573         string memory magicURI = _magicURI();
2574         if (magicMushrooms[_tokenId] && bytes(magicURI).length != 0) {
2575             return string(abi.encodePacked(magicURI, _tokenId.toString()));
2576         }
2577         else {
2578             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString())) : '';
2579         }
2580     }
2581 
2582     modifier mintConditions(uint256 _mushrooms) {
2583         require(mushroomization, "Mushroomization isn't started");
2584         require(totalSupply() + _mushrooms <= mushrooms, "No spores left...");
2585         require(tx.origin == msg.sender, unicode"ಠ_ಠ");
2586         _;
2587     }
2588 }