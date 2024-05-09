1 // SPDX-License-Identifier: MIT
2 /*
3  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄ 
4 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌
5 ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌
6 ▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌       ▐░▌▐░▌▐░▌    ▐░▌
7 ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▐░▌   ▐░▌
8  ▐░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌
9 ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░▌   ▐░▌ ▐░▌
10 ▐░▌       ▐░▌          ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌    ▐░▌▐░▌
11 ▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌▐░▌     ▐░▐░▌
12 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌      ▐░░▌
13  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀        ▀▀ 
14                                                                                          
15                       By Devko.dev#7286                              
16  */
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @title Counters
21  * @author Matt Condon (@shrugs)
22  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
23  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
24  *
25  * Include with `using Counters for Counters.Counter;`
26  */
27 library Counters {
28     struct Counter {
29         // This variable should never be directly accessed by users of the library: interactions must be restricted to
30         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
31         // this feature: see https://github.com/ethereum/solidity/issues/4637
32         uint256 _value; // default: 0
33     }
34 
35     function current(Counter storage counter) internal view returns (uint256) {
36         return counter._value;
37     }
38 
39     function increment(Counter storage counter) internal {
40         unchecked {
41             counter._value += 1;
42         }
43     }
44 
45     function decrement(Counter storage counter) internal {
46         uint256 value = counter._value;
47         require(value > 0, "Counter: decrement overflow");
48         unchecked {
49             counter._value = value - 1;
50         }
51     }
52 
53     function reset(Counter storage counter) internal {
54         counter._value = 0;
55     }
56 }
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 pragma solidity ^0.8.0;
124 
125 
126 /**
127  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
128  *
129  * These functions can be used to verify that a message was signed by the holder
130  * of the private keys of a given address.
131  */
132 library ECDSA {
133     enum RecoverError {
134         NoError,
135         InvalidSignature,
136         InvalidSignatureLength,
137         InvalidSignatureS,
138         InvalidSignatureV
139     }
140 
141     function _throwError(RecoverError error) private pure {
142         if (error == RecoverError.NoError) {
143             return; // no error: do nothing
144         } else if (error == RecoverError.InvalidSignature) {
145             revert("ECDSA: invalid signature");
146         } else if (error == RecoverError.InvalidSignatureLength) {
147             revert("ECDSA: invalid signature length");
148         } else if (error == RecoverError.InvalidSignatureS) {
149             revert("ECDSA: invalid signature 's' value");
150         } else if (error == RecoverError.InvalidSignatureV) {
151             revert("ECDSA: invalid signature 'v' value");
152         }
153     }
154 
155     /**
156      * @dev Returns the address that signed a hashed message (`hash`) with
157      * `signature` or error string. This address can then be used for verification purposes.
158      *
159      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
160      * this function rejects them by requiring the `s` value to be in the lower
161      * half order, and the `v` value to be either 27 or 28.
162      *
163      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
164      * verification to be secure: it is possible to craft signatures that
165      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
166      * this is by receiving a hash of the original message (which may otherwise
167      * be too long), and then calling {toEthSignedMessageHash} on it.
168      *
169      * Documentation for signature generation:
170      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
171      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
172      *
173      * _Available since v4.3._
174      */
175     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
176         // Check the signature length
177         // - case 65: r,s,v signature (standard)
178         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
179         if (signature.length == 65) {
180             bytes32 r;
181             bytes32 s;
182             uint8 v;
183             // ecrecover takes the signature parameters, and the only way to get them
184             // currently is to use assembly.
185             assembly {
186                 r := mload(add(signature, 0x20))
187                 s := mload(add(signature, 0x40))
188                 v := byte(0, mload(add(signature, 0x60)))
189             }
190             return tryRecover(hash, v, r, s);
191         } else if (signature.length == 64) {
192             bytes32 r;
193             bytes32 vs;
194             // ecrecover takes the signature parameters, and the only way to get them
195             // currently is to use assembly.
196             assembly {
197                 r := mload(add(signature, 0x20))
198                 vs := mload(add(signature, 0x40))
199             }
200             return tryRecover(hash, r, vs);
201         } else {
202             return (address(0), RecoverError.InvalidSignatureLength);
203         }
204     }
205 
206     /**
207      * @dev Returns the address that signed a hashed message (`hash`) with
208      * `signature`. This address can then be used for verification purposes.
209      *
210      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
211      * this function rejects them by requiring the `s` value to be in the lower
212      * half order, and the `v` value to be either 27 or 28.
213      *
214      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
215      * verification to be secure: it is possible to craft signatures that
216      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
217      * this is by receiving a hash of the original message (which may otherwise
218      * be too long), and then calling {toEthSignedMessageHash} on it.
219      */
220     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
221         (address recovered, RecoverError error) = tryRecover(hash, signature);
222         _throwError(error);
223         return recovered;
224     }
225 
226     /**
227      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
228      *
229      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
230      *
231      * _Available since v4.3._
232      */
233     function tryRecover(
234         bytes32 hash,
235         bytes32 r,
236         bytes32 vs
237     ) internal pure returns (address, RecoverError) {
238         bytes32 s;
239         uint8 v;
240         assembly {
241             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
242             v := add(shr(255, vs), 27)
243         }
244         return tryRecover(hash, v, r, s);
245     }
246 
247     /**
248      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
249      *
250      * _Available since v4.2._
251      */
252     function recover(
253         bytes32 hash,
254         bytes32 r,
255         bytes32 vs
256     ) internal pure returns (address) {
257         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
258         _throwError(error);
259         return recovered;
260     }
261 
262     /**
263      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
264      * `r` and `s` signature fields separately.
265      *
266      * _Available since v4.3._
267      */
268     function tryRecover(
269         bytes32 hash,
270         uint8 v,
271         bytes32 r,
272         bytes32 s
273     ) internal pure returns (address, RecoverError) {
274         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
275         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
276         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
277         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
278         //
279         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
280         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
281         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
282         // these malleable signatures as well.
283         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
284             return (address(0), RecoverError.InvalidSignatureS);
285         }
286         if (v != 27 && v != 28) {
287             return (address(0), RecoverError.InvalidSignatureV);
288         }
289 
290         // If the signature is valid (and not malleable), return the signer address
291         address signer = ecrecover(hash, v, r, s);
292         if (signer == address(0)) {
293             return (address(0), RecoverError.InvalidSignature);
294         }
295 
296         return (signer, RecoverError.NoError);
297     }
298 
299     /**
300      * @dev Overload of {ECDSA-recover} that receives the `v`,
301      * `r` and `s` signature fields separately.
302      */
303     function recover(
304         bytes32 hash,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) internal pure returns (address) {
309         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
310         _throwError(error);
311         return recovered;
312     }
313 
314     /**
315      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
316      * produces hash corresponding to the one signed with the
317      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
318      * JSON-RPC method as part of EIP-191.
319      *
320      * See {recover}.
321      */
322     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
323         // 32 is the length in bytes of hash,
324         // enforced by the type signature above
325         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
326     }
327 
328     /**
329      * @dev Returns an Ethereum Signed Message, created from `s`. This
330      * produces hash corresponding to the one signed with the
331      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
332      * JSON-RPC method as part of EIP-191.
333      *
334      * See {recover}.
335      */
336     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
337         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
338     }
339 
340     /**
341      * @dev Returns an Ethereum Signed Typed Data, created from a
342      * `domainSeparator` and a `structHash`. This produces hash corresponding
343      * to the one signed with the
344      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
345      * JSON-RPC method as part of EIP-712.
346      *
347      * See {recover}.
348      */
349     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
350         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
351     }
352 }
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Provides information about the current execution context, including the
358  * sender of the transaction and its data. While these are generally available
359  * via msg.sender and msg.data, they should not be accessed in such a direct
360  * manner, since when dealing with meta-transactions the account sending and
361  * paying for execution may not be the actual sender (as far as an application
362  * is concerned).
363  *
364  * This contract is only required for intermediate, library-like contracts.
365  */
366 abstract contract Context {
367     function _msgSender() internal view virtual returns (address) {
368         return msg.sender;
369     }
370 
371     function _msgData() internal view virtual returns (bytes calldata) {
372         return msg.data;
373     }
374 }
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Contract module which provides a basic access control mechanism, where
380  * there is an account (an owner) that can be granted exclusive access to
381  * specific functions.
382  *
383  * By default, the owner account will be the one that deploys the contract. This
384  * can later be changed with {transferOwnership}.
385  *
386  * This module is used through inheritance. It will make available the modifier
387  * `onlyOwner`, which can be applied to your functions to restrict their use to
388  * the owner.
389  */
390 abstract contract Ownable is Context {
391     address private _owner;
392 
393     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
394 
395     /**
396      * @dev Initializes the contract setting the deployer as the initial owner.
397      */
398     constructor() {
399         _transferOwnership(_msgSender());
400     }
401 
402     /**
403      * @dev Returns the address of the current owner.
404      */
405     function owner() public view virtual returns (address) {
406         return _owner;
407     }
408 
409     /**
410      * @dev Throws if called by any account other than the owner.
411      */
412     modifier onlyOwner() {
413         require(owner() == _msgSender(), "Ownable: caller is not the owner");
414         _;
415     }
416 
417     /**
418      * @dev Leaves the contract without owner. It will not be possible to call
419      * `onlyOwner` functions anymore. Can only be called by the current owner.
420      *
421      * NOTE: Renouncing ownership will leave the contract without an owner,
422      * thereby removing any functionality that is only available to the owner.
423      */
424     function renounceOwnership() public virtual onlyOwner {
425         _transferOwnership(address(0));
426     }
427 
428     /**
429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
430      * Can only be called by the current owner.
431      */
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(newOwner != address(0), "Ownable: new owner is the zero address");
434         _transferOwnership(newOwner);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Internal function without access restriction.
440      */
441     function _transferOwnership(address newOwner) internal virtual {
442         address oldOwner = _owner;
443         _owner = newOwner;
444         emit OwnershipTransferred(oldOwner, newOwner);
445     }
446 }
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Collection of functions related to the address type
452  */
453 library Address {
454     /**
455      * @dev Returns true if `account` is a contract.
456      *
457      * [IMPORTANT]
458      * ====
459      * It is unsafe to assume that an address for which this function returns
460      * false is an externally-owned account (EOA) and not a contract.
461      *
462      * Among others, `isContract` will return false for the following
463      * types of addresses:
464      *
465      *  - an externally-owned account
466      *  - a contract in construction
467      *  - an address where a contract will be created
468      *  - an address where a contract lived, but was destroyed
469      * ====
470      */
471     function isContract(address account) internal view returns (bool) {
472         // This method relies on extcodesize, which returns 0 for contracts in
473         // construction, since the code is only stored at the end of the
474         // constructor execution.
475 
476         uint256 size;
477         assembly {
478             size := extcodesize(account)
479         }
480         return size > 0;
481     }
482 
483     /**
484      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
485      * `recipient`, forwarding all available gas and reverting on errors.
486      *
487      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
488      * of certain opcodes, possibly making contracts go over the 2300 gas limit
489      * imposed by `transfer`, making them unable to receive funds via
490      * `transfer`. {sendValue} removes this limitation.
491      *
492      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
493      *
494      * IMPORTANT: because control is transferred to `recipient`, care must be
495      * taken to not create reentrancy vulnerabilities. Consider using
496      * {ReentrancyGuard} or the
497      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
498      */
499     function sendValue(address payable recipient, uint256 amount) internal {
500         require(address(this).balance >= amount, "Address: insufficient balance");
501 
502         (bool success, ) = recipient.call{value: amount}("");
503         require(success, "Address: unable to send value, recipient may have reverted");
504     }
505 
506     /**
507      * @dev Performs a Solidity function call using a low level `call`. A
508      * plain `call` is an unsafe replacement for a function call: use this
509      * function instead.
510      *
511      * If `target` reverts with a revert reason, it is bubbled up by this
512      * function (like regular Solidity function calls).
513      *
514      * Returns the raw returned data. To convert to the expected return value,
515      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
516      *
517      * Requirements:
518      *
519      * - `target` must be a contract.
520      * - calling `target` with `data` must not revert.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
525         return functionCall(target, data, "Address: low-level call failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
530      * `errorMessage` as a fallback revert reason when `target` reverts.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(
535         address target,
536         bytes memory data,
537         string memory errorMessage
538     ) internal returns (bytes memory) {
539         return functionCallWithValue(target, data, 0, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but also transferring `value` wei to `target`.
545      *
546      * Requirements:
547      *
548      * - the calling contract must have an ETH balance of at least `value`.
549      * - the called Solidity function must be `payable`.
550      *
551      * _Available since v3.1._
552      */
553     function functionCallWithValue(
554         address target,
555         bytes memory data,
556         uint256 value
557     ) internal returns (bytes memory) {
558         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
563      * with `errorMessage` as a fallback revert reason when `target` reverts.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.call{value: value}(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal view returns (bytes memory) {
601         require(isContract(target), "Address: static call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.staticcall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a delegate call.
610      *
611      * _Available since v3.4._
612      */
613     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
614         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(
624         address target,
625         bytes memory data,
626         string memory errorMessage
627     ) internal returns (bytes memory) {
628         require(isContract(target), "Address: delegate call to non-contract");
629 
630         (bool success, bytes memory returndata) = target.delegatecall(data);
631         return verifyCallResult(success, returndata, errorMessage);
632     }
633 
634     /**
635      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
636      * revert reason using the provided one.
637      *
638      * _Available since v4.3._
639      */
640     function verifyCallResult(
641         bool success,
642         bytes memory returndata,
643         string memory errorMessage
644     ) internal pure returns (bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @title ERC721 token receiver interface
667  * @dev Interface for any contract that wants to support safeTransfers
668  * from ERC721 asset contracts.
669  */
670 interface IERC721Receiver {
671     /**
672      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
673      * by `operator` from `from`, this function is called.
674      *
675      * It must return its Solidity selector to confirm the token transfer.
676      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
677      *
678      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
679      */
680     function onERC721Received(
681         address operator,
682         address from,
683         uint256 tokenId,
684         bytes calldata data
685     ) external returns (bytes4);
686 }
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Interface of the ERC165 standard, as defined in the
692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
693  *
694  * Implementers can declare support of contract interfaces, which can then be
695  * queried by others ({ERC165Checker}).
696  *
697  * For an implementation, see {ERC165}.
698  */
699 interface IERC165 {
700     /**
701      * @dev Returns true if this contract implements the interface defined by
702      * `interfaceId`. See the corresponding
703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
704      * to learn more about how these ids are created.
705      *
706      * This function call must use less than 30 000 gas.
707      */
708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
709 }
710 
711 pragma solidity ^0.8.0;
712 
713 /**
714  * @dev Implementation of the {IERC165} interface.
715  *
716  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
717  * for the additional interface id that will be supported. For example:
718  *
719  * ```solidity
720  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
721  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
722  * }
723  * ```
724  *
725  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
726  */
727 abstract contract ERC165 is IERC165 {
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
732         return interfaceId == type(IERC165).interfaceId;
733     }
734 }
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Required interface of an ERC721 compliant contract.
740  */
741 interface IERC721 is IERC165 {
742     /**
743      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
744      */
745     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
749      */
750     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
751 
752     /**
753      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
754      */
755     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
756 
757     /**
758      * @dev Returns the number of tokens in ``owner``'s account.
759      */
760     function balanceOf(address owner) external view returns (uint256 balance);
761 
762     /**
763      * @dev Returns the owner of the `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function ownerOf(uint256 tokenId) external view returns (address owner);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) external;
790 
791     /**
792      * @dev Transfers `tokenId` token from `from` to `to`.
793      *
794      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
795      *
796      * Requirements:
797      *
798      * - `from` cannot be the zero address.
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must be owned by `from`.
801      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
802      *
803      * Emits a {Transfer} event.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) external;
810 
811     /**
812      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
813      * The approval is cleared when the token is transferred.
814      *
815      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      * - `tokenId` must exist.
821      *
822      * Emits an {Approval} event.
823      */
824     function approve(address to, uint256 tokenId) external;
825 
826     /**
827      * @dev Returns the account approved for `tokenId` token.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function getApproved(uint256 tokenId) external view returns (address operator);
834 
835     /**
836      * @dev Approve or remove `operator` as an operator for the caller.
837      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
838      *
839      * Requirements:
840      *
841      * - The `operator` cannot be the caller.
842      *
843      * Emits an {ApprovalForAll} event.
844      */
845     function setApprovalForAll(address operator, bool _approved) external;
846 
847     /**
848      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
849      *
850      * See {setApprovalForAll}
851      */
852     function isApprovedForAll(address owner, address operator) external view returns (bool);
853 
854     /**
855      * @dev Safely transfers `tokenId` token from `from` to `to`.
856      *
857      * Requirements:
858      *
859      * - `from` cannot be the zero address.
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must exist and be owned by `from`.
862      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes calldata data
872     ) external;
873 }
874 
875 pragma solidity ^0.8.0;
876 
877 /**
878  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
879  * @dev See https://eips.ethereum.org/EIPS/eip-721
880  */
881 interface IERC721Metadata is IERC721 {
882     /**
883      * @dev Returns the token collection name.
884      */
885     function name() external view returns (string memory);
886 
887     /**
888      * @dev Returns the token collection symbol.
889      */
890     function symbol() external view returns (string memory);
891 
892     /**
893      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
894      */
895     function tokenURI(uint256 tokenId) external view returns (string memory);
896 }
897 
898 pragma solidity ^0.8.0;
899 
900 /**
901  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
902  * the Metadata extension, but not including the Enumerable extension, which is available separately as
903  * {ERC721Enumerable}.
904  */
905 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
906     using Address for address;
907     using Strings for uint256;
908 
909     // Token name
910     string private _name;
911 
912     // Token symbol
913     string private _symbol;
914 
915     // Mapping from token ID to owner address
916     mapping(uint256 => address) private _owners;
917 
918     // Mapping owner address to token count
919     mapping(address => uint256) private _balances;
920 
921     // Mapping from token ID to approved address
922     mapping(uint256 => address) private _tokenApprovals;
923 
924     // Mapping from owner to operator approvals
925     mapping(address => mapping(address => bool)) private _operatorApprovals;
926 
927     /**
928      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
929      */
930     constructor(string memory name_, string memory symbol_) {
931         _name = name_;
932         _symbol = symbol_;
933     }
934 
935     /**
936      * @dev See {IERC165-supportsInterface}.
937      */
938     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
939         return
940             interfaceId == type(IERC721).interfaceId ||
941             interfaceId == type(IERC721Metadata).interfaceId ||
942             super.supportsInterface(interfaceId);
943     }
944 
945     /**
946      * @dev See {IERC721-balanceOf}.
947      */
948     function balanceOf(address owner) public view virtual override returns (uint256) {
949         require(owner != address(0), "ERC721: balance query for the zero address");
950         return _balances[owner];
951     }
952 
953     /**
954      * @dev See {IERC721-ownerOf}.
955      */
956     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
957         address owner = _owners[tokenId];
958         require(owner != address(0), "ERC721: owner query for nonexistent token");
959         return owner;
960     }
961 
962     /**
963      * @dev See {IERC721Metadata-name}.
964      */
965     function name() public view virtual override returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev See {IERC721Metadata-symbol}.
971      */
972     function symbol() public view virtual override returns (string memory) {
973         return _symbol;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-tokenURI}.
978      */
979     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
980         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
981 
982         string memory baseURI = _baseURI();
983         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
984     }
985 
986     /**
987      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
988      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
989      * by default, can be overriden in child contracts.
990      */
991     function _baseURI() internal view virtual returns (string memory) {
992         return "";
993     }
994 
995     /**
996      * @dev See {IERC721-approve}.
997      */
998     function approve(address to, uint256 tokenId) public virtual override {
999         address owner = ERC721.ownerOf(tokenId);
1000         require(to != owner, "ERC721: approval to current owner");
1001 
1002         require(
1003             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1004             "ERC721: approve caller is not owner nor approved for all"
1005         );
1006 
1007         _approve(to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-getApproved}.
1012      */
1013     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1014         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1015 
1016         return _tokenApprovals[tokenId];
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-setApprovalForAll}.
1021      */
1022     function setApprovalForAll(address operator, bool approved) public virtual override {
1023         _setApprovalForAll(_msgSender(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1030         return _operatorApprovals[owner][operator];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-transferFrom}.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public virtual override {
1041         //solhint-disable-next-line max-line-length
1042         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1043 
1044         _transfer(from, to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         safeTransferFrom(from, to, tokenId, "");
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-safeTransferFrom}.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) public virtual override {
1067         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1068         _safeTransfer(from, to, tokenId, _data);
1069     }
1070 
1071     /**
1072      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1073      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1074      *
1075      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1076      *
1077      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1078      * implement alternative mechanisms to perform token transfer, such as signature-based.
1079      *
1080      * Requirements:
1081      *
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      * - `tokenId` token must exist and be owned by `from`.
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _safeTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId,
1093         bytes memory _data
1094     ) internal virtual {
1095         _transfer(from, to, tokenId);
1096         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1097     }
1098 
1099     /**
1100      * @dev Returns whether `tokenId` exists.
1101      *
1102      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1103      *
1104      * Tokens start existing when they are minted (`_mint`),
1105      * and stop existing when they are burned (`_burn`).
1106      */
1107     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1108         return _owners[tokenId] != address(0);
1109     }
1110 
1111     /**
1112      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must exist.
1117      */
1118     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1119         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1120         address owner = ERC721.ownerOf(tokenId);
1121         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1122     }
1123 
1124     /**
1125      * @dev Safely mints `tokenId` and transfers it to `to`.
1126      *
1127      * Requirements:
1128      *
1129      * - `tokenId` must not exist.
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _safeMint(address to, uint256 tokenId) internal virtual {
1135         _safeMint(to, tokenId, "");
1136     }
1137 
1138     /**
1139      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1140      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1141      */
1142     function _safeMint(
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) internal virtual {
1147         _mint(to, tokenId);
1148         require(
1149             _checkOnERC721Received(address(0), to, tokenId, _data),
1150             "ERC721: transfer to non ERC721Receiver implementer"
1151         );
1152     }
1153 
1154     /**
1155      * @dev Mints `tokenId` and transfers it to `to`.
1156      *
1157      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must not exist.
1162      * - `to` cannot be the zero address.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _mint(address to, uint256 tokenId) internal virtual {
1167         require(to != address(0), "ERC721: mint to the zero address");
1168         require(!_exists(tokenId), "ERC721: token already minted");
1169 
1170         _beforeTokenTransfer(address(0), to, tokenId);
1171 
1172         _balances[to] += 1;
1173         _owners[tokenId] = to;
1174 
1175         emit Transfer(address(0), to, tokenId);
1176     }
1177 
1178     /**
1179      * @dev Destroys `tokenId`.
1180      * The approval is cleared when the token is burned.
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must exist.
1185      *
1186      * Emits a {Transfer} event.
1187      */
1188     function _burn(uint256 tokenId) internal virtual {
1189         address owner = ERC721.ownerOf(tokenId);
1190 
1191         _beforeTokenTransfer(owner, address(0), tokenId);
1192 
1193         // Clear approvals
1194         _approve(address(0), tokenId);
1195 
1196         _balances[owner] -= 1;
1197         delete _owners[tokenId];
1198 
1199         emit Transfer(owner, address(0), tokenId);
1200     }
1201 
1202     /**
1203      * @dev Transfers `tokenId` from `from` to `to`.
1204      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `tokenId` token must be owned by `from`.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _transfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) internal virtual {
1218         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1219         require(to != address(0), "ERC721: transfer to the zero address");
1220 
1221         _beforeTokenTransfer(from, to, tokenId);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId);
1225 
1226         _balances[from] -= 1;
1227         _balances[to] += 1;
1228         _owners[tokenId] = to;
1229 
1230         emit Transfer(from, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev Approve `to` to operate on `tokenId`
1235      *
1236      * Emits a {Approval} event.
1237      */
1238     function _approve(address to, uint256 tokenId) internal virtual {
1239         _tokenApprovals[tokenId] = to;
1240         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1241     }
1242 
1243     /**
1244      * @dev Approve `operator` to operate on all of `owner` tokens
1245      *
1246      * Emits a {ApprovalForAll} event.
1247      */
1248     function _setApprovalForAll(
1249         address owner,
1250         address operator,
1251         bool approved
1252     ) internal virtual {
1253         require(owner != operator, "ERC721: approve to caller");
1254         _operatorApprovals[owner][operator] = approved;
1255         emit ApprovalForAll(owner, operator, approved);
1256     }
1257 
1258     /**
1259      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1260      * The call is not executed if the target address is not a contract.
1261      *
1262      * @param from address representing the previous owner of the given token ID
1263      * @param to target address that will receive the tokens
1264      * @param tokenId uint256 ID of the token to be transferred
1265      * @param _data bytes optional data to send along with the call
1266      * @return bool whether the call correctly returned the expected magic value
1267      */
1268     function _checkOnERC721Received(
1269         address from,
1270         address to,
1271         uint256 tokenId,
1272         bytes memory _data
1273     ) private returns (bool) {
1274         if (to.isContract()) {
1275             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1276                 return retval == IERC721Receiver.onERC721Received.selector;
1277             } catch (bytes memory reason) {
1278                 if (reason.length == 0) {
1279                     revert("ERC721: transfer to non ERC721Receiver implementer");
1280                 } else {
1281                     assembly {
1282                         revert(add(32, reason), mload(reason))
1283                     }
1284                 }
1285             }
1286         } else {
1287             return true;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Hook that is called before any token transfer. This includes minting
1293      * and burning.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1301      * - `from` and `to` are never both zero.
1302      *
1303      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1304      */
1305     function _beforeTokenTransfer(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) internal virtual {}
1310 }
1311 
1312 pragma solidity ^0.8.7;
1313 
1314 contract _8SIAN_ is ERC721, Ownable {
1315 
1316     using Strings for uint256;
1317     using Counters for Counters.Counter;
1318     using ECDSA for bytes32;
1319 
1320     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmZhoKWASbhqCyCLHQfTs6bhe3uRhZWKPLwvgNUmowJ2NP/";
1321     uint256 public M_8SIAN_TEAM_RESERVE = 888;
1322     uint256 public M_8SIAN_FREE_CLAIM_RESERVE = 888;
1323     uint256 public M_8SIAN_PUBLIC = 7112;
1324     uint256 public M_8SIAN_MAX = M_8SIAN_FREE_CLAIM_RESERVE + M_8SIAN_TEAM_RESERVE + M_8SIAN_PUBLIC;
1325     uint256 public M_8SIAN_PRICE = 0.088 ether;
1326     uint256 public M_8SIAN_PER_MINT = 5;
1327     mapping(address => uint256) public CLAIMERS_LIST;
1328     mapping(address => uint256) public PRIVATE_MINT_LIST;
1329 
1330     address private PRIVATE_SIGNER = 0xB1b9B90F65Cde3cA10bf469D16A7BC5Ef4Ccd48e;
1331     string private constant PRESALE_SIG_WORD = "8SIAN_M_PRESALE";
1332 
1333     uint256 public claimTokensMinted;
1334     uint256 public publicTokensMinted;
1335     uint256 public teamTokensMinted;
1336 
1337     bool public privateLive;
1338     bool public claimFreeLive;
1339     bool public publicLive;
1340 
1341     Counters.Counter private _tokensMinted;
1342 
1343     constructor() ERC721("8SIAN", "8SIAN") {}
1344     
1345     function matchAddresSigner(bytes memory signature, string memory extraWord, uint256 allowedQuantity) private view returns(bool) {
1346          bytes32 hash = keccak256(abi.encodePacked(
1347             "\x19Ethereum Signed Message:\n32",
1348             keccak256(abi.encodePacked(msg.sender, PRESALE_SIG_WORD, extraWord, allowedQuantity)))
1349           );
1350         return PRIVATE_SIGNER == hash.recover(signature);
1351     }   
1352 
1353     function gift(address[] calldata receivers) external onlyOwner {
1354         require(teamTokensMinted + receivers.length <= M_8SIAN_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1355         require(_tokensMinted.current() + receivers.length <= M_8SIAN_MAX, "EXCEED_MAX");
1356         for (uint256 i = 0; i < receivers.length; i++) {
1357             teamTokensMinted++;
1358             _tokensMinted.increment();
1359             _safeMint(receivers[i], _tokensMinted.current());
1360         }
1361     }
1362 
1363     function founderMint(uint256 tokenQuantity) external onlyOwner {
1364         require(teamTokensMinted + tokenQuantity <= M_8SIAN_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1365         require(_tokensMinted.current() + tokenQuantity <= M_8SIAN_MAX, "EXCEED_MAX");
1366         for(uint256 i = 0; i < tokenQuantity; i++) {
1367             teamTokensMinted++;
1368             _tokensMinted.increment();
1369             _safeMint(msg.sender, _tokensMinted.current());
1370         }
1371     }
1372 
1373     function privateMint(bytes memory signature, uint256 tokenQuantity, uint256 allowedQuantity) external payable {
1374         require(privateLive, "MINT_CLOSED");
1375         require(matchAddresSigner(signature, "TYPE-PRIVATE", allowedQuantity), "DIRECT_MINT_DISALLOWED");
1376         require(publicTokensMinted + tokenQuantity <= M_8SIAN_PUBLIC, "EXCEED_PUBLIC");
1377         require(_tokensMinted.current() + tokenQuantity <= M_8SIAN_MAX, "EXCEED_MAX");
1378         require(PRIVATE_MINT_LIST[msg.sender] + tokenQuantity <= allowedQuantity, "EXCEED_PER_WALLET");
1379         require(M_8SIAN_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1380 
1381         for (uint256 i = 0; i < tokenQuantity; i++) {
1382             publicTokensMinted++;
1383             PRIVATE_MINT_LIST[msg.sender]++;
1384             _tokensMinted.increment();
1385             _safeMint(msg.sender, _tokensMinted.current());
1386         }
1387     }
1388 
1389     function claim(bytes memory signature, uint256 tokenQuantity, uint256 allowedQuantity) external {
1390         require(claimFreeLive, "MINT_CLOSED");
1391         require(matchAddresSigner(signature, "TYPE-FREE", allowedQuantity), "DIRECT_MINT_DISALLOWED");
1392         require(claimTokensMinted + tokenQuantity <= M_8SIAN_FREE_CLAIM_RESERVE, "EXCEED_FREE_CLAIM_RESERVE");
1393         require(_tokensMinted.current() + tokenQuantity <= M_8SIAN_MAX, "EXCEED_MAX");
1394         require(CLAIMERS_LIST[msg.sender] + tokenQuantity <= allowedQuantity, "EXCEED_PER_WALLET");
1395 
1396         for (uint256 i = 0; i < tokenQuantity; i++) {
1397             claimTokensMinted++;
1398             CLAIMERS_LIST[msg.sender]++;
1399             _tokensMinted.increment();
1400             _safeMint(msg.sender, _tokensMinted.current());
1401         }
1402     }
1403 
1404     function mint(uint256 tokenQuantity) external payable {
1405         require(publicLive, "MINT_CLOSED");
1406         require(publicTokensMinted + tokenQuantity <= M_8SIAN_PUBLIC, "EXCEED_PUBLIC");
1407         require(_tokensMinted.current() + tokenQuantity <= M_8SIAN_MAX, "EXCEED_MAX");
1408         require(tokenQuantity <= M_8SIAN_PER_MINT, "EXCEED_PER_MINT");
1409         require(M_8SIAN_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1410 
1411         for (uint256 i = 0; i < tokenQuantity; i++) {
1412             publicTokensMinted++;
1413             _tokensMinted.increment();
1414             _safeMint(msg.sender, _tokensMinted.current());
1415         }
1416     }
1417  
1418     function withdraw() external onlyOwner {
1419         uint256 currentBalance = address(this).balance;
1420         Address.sendValue(payable(0xc640E8B617F71E32f4c664Ea30921dAbF7870144), currentBalance * 220/ 1000);
1421         Address.sendValue(payable(0xe72441A43Ed985a9E3D43c11a7FcE93Dd282FF03), currentBalance * 170/ 1000);
1422         Address.sendValue(payable(0x683E1164Cf26875710737c77fBbE9AF8abCcd0AD), currentBalance * 165/ 1000);
1423         Address.sendValue(payable(0xb53b491e917Eefe9c4d713870B9a08D630670245), currentBalance * 150/ 1000);           
1424         Address.sendValue(payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834), currentBalance * 80 / 1000);
1425         Address.sendValue(payable(0xE9D0BD5520af8c9ad20e12801315117dE9958149), currentBalance * 50 / 1000);
1426         Address.sendValue(payable(0x9178bCf3A4C25B9A321EDFE7360fA587f7bD10fd), currentBalance * 50 / 1000);
1427         Address.sendValue(payable(0x15A294789F34F91b03ec8a005fd27b13005f302e), currentBalance * 50 / 1000);
1428         Address.sendValue(payable(0xeD9C842645D9a2Bb66d4EAC77857768071384447), currentBalance * 25 / 1000);
1429         Address.sendValue(payable(0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c), currentBalance * 10 / 1000);
1430         Address.sendValue(payable(0x3329904219aF8Da1B86576C64b68eBe59D28c037), currentBalance * 10 / 1000);
1431         Address.sendValue(payable(0x506046F99A9932540fa5938fa4aE3a6Ff20E1f65), currentBalance * 10 / 1000);
1432         Address.sendValue(payable(0xf0d78074a1ED1c4CAEce0cECfE81DC9010A77FB9), address(this).balance);
1433     }
1434 
1435     function withdrawB() external onlyOwner {
1436         uint256 currentBalance = address(this).balance;
1437         payable(0xc640E8B617F71E32f4c664Ea30921dAbF7870144).transfer(currentBalance * 220/ 1000);
1438         payable(0xe72441A43Ed985a9E3D43c11a7FcE93Dd282FF03).transfer(currentBalance * 170/ 1000);
1439         payable(0x683E1164Cf26875710737c77fBbE9AF8abCcd0AD).transfer(currentBalance * 165/ 1000);
1440         payable(0xb53b491e917Eefe9c4d713870B9a08D630670245).transfer(currentBalance * 150/ 1000);           
1441         payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer(currentBalance * 80 / 1000);
1442         payable(0xE9D0BD5520af8c9ad20e12801315117dE9958149).transfer(currentBalance * 50 / 1000);
1443         payable(0x9178bCf3A4C25B9A321EDFE7360fA587f7bD10fd).transfer(currentBalance * 50 / 1000);
1444         payable(0x15A294789F34F91b03ec8a005fd27b13005f302e).transfer(currentBalance * 50 / 1000);
1445         payable(0xeD9C842645D9a2Bb66d4EAC77857768071384447).transfer(currentBalance * 25 / 1000);
1446         payable(0xc0F030eac8b588817f8dA16b9a2CDCcc6451B25c).transfer(currentBalance * 10 / 1000);
1447         payable(0x3329904219aF8Da1B86576C64b68eBe59D28c037).transfer(currentBalance * 10 / 1000);
1448         payable(0x506046F99A9932540fa5938fa4aE3a6Ff20E1f65).transfer(currentBalance * 10 / 1000);
1449         payable(0xf0d78074a1ED1c4CAEce0cECfE81DC9010A77FB9).transfer(address(this).balance);
1450     }
1451     
1452     function togglePrivateMintStatus() external onlyOwner {
1453         privateLive = !privateLive;
1454     }
1455 
1456     function togglePublicMintStatus() external onlyOwner {
1457         publicLive = !publicLive;
1458     }
1459 
1460     function toggleClaimFreeMintStatus() external onlyOwner {
1461         claimFreeLive = !claimFreeLive;
1462     }
1463 
1464     function setPrice(uint256 newPrice) external onlyOwner {
1465         M_8SIAN_PRICE = newPrice;
1466     }
1467 
1468     function setTeamReserve(uint256 newCount) external onlyOwner {
1469         M_8SIAN_TEAM_RESERVE = newCount;
1470     }
1471 
1472     function setFreeClaimReserve(uint256 newCount) external onlyOwner {
1473         M_8SIAN_FREE_CLAIM_RESERVE = newCount;
1474     }
1475 
1476     function setPublic(uint256 newCount) external onlyOwner {
1477         M_8SIAN_PUBLIC = newCount;
1478     }
1479     
1480     function setMax(uint256 newCount) external onlyOwner {
1481         M_8SIAN_MAX = newCount;
1482     }
1483     
1484     function setBaseURI(string calldata URI) external onlyOwner {
1485         _tokenBaseURI = URI;
1486     }
1487     
1488     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1489         require(_exists(tokenId), "Cannot query non-existent token");
1490         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1491     }
1492 
1493     function totalSupply() public view returns (uint256) {
1494         return _tokensMinted.current();
1495     }
1496 
1497     receive() external payable {}
1498 }