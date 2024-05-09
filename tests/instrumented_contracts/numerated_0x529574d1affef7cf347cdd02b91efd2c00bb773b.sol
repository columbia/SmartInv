1 // SPDX-License-Identifier: MIT
2 
3 ////////////////////////////////////////////////////////////////////////////////////////////////////
4 //////////////////////(///////#@%#&&&&&&&&&&&&&&&//////#@%#&&&&&&#@%#&&&/////(//////////////////////
5 /////////////##%&&%////((#&&&(///(//////////////////(/////////////(///(&#///#@%#(%//////////////////
6 //////////(%(/(((((#@@%%(//(//////////////////////////////(//////////(///(##&//(((%/////////////////
7 //////////(&#(/#@&((/((////////////////////////////////////////////////(////#///#((#////////////////
8 ////////(//@&##//%#//////////(/////////////////////////////(////////////(////(///((/////////////////
9 ////////(%@#@#///(///////////#/////////////////////////////(/////////////(//(//(//((////////////////
10 ///////((%#(/#//(////////////#///////////////////////////////////////////////(//(//(((//////////////
11 ///////(%@%(((/(/////////////#////////////////////////////////////////////(///(//#/(%(//////////////
12 ////////@@#/#(/(/////////////(//////////////////////////////(/(///////////(////(//(/##//////////////
13 ////////%@%((((///////////////(/////////////////////////////(//(///////////////(////(%//////////////
14 ////////#@%#/((///////////////(//////////////////////////////(/(////////////////(///(%#/////////////
15 ////////(@%#/(///////////////////////////////////////////////(///////////////////(///&(/////////////
16 ////////(@&#/#///////////////////////////////////////////////(//(////////////////(///#//////////////
17 ////////(@&(/(///////////////////////////////////////////////(//(//////////(//////(//##/////////////
18 ///////((@&(((//////////////////////////((((/////////////////(/////////////(//////(/(%%/////////////
19 ////////(@&#((////////////////////////(((////((//////////////(///(//////((##/////////%%/////////////
20 ////////(&&#((/////////////////////////#///////(/////////////(///(/////(#(/(%//////((#%/////////////
21 ////////##&#/#//////////////////////////####(//////////////////////////(#(/(#//////((%#/////////////
22 ////////(#&#/(///(//////////////////////////////////////////((((((((((((///////////(/@//////////////
23 ////////(#%(/(///(/////////////////////////(#%&&%%#//#%#/////(#%#/(//(%&%&&&&#(////((%//////////////
24 ////////(&&(//(///////////////////(%%&#(##(/%%%//////%&&%////%@#@%(//(&(%(////#&@@%(&///////////////
25 ////////(&%##(///////////////##%#/#%&@//////@@&%@&&&%%&%%@&&&@&%#%%%#(((#&#(%&&(//#@%///////////////
26 /////////%(%//////////////#&%%(////%@&@@&&&@&@@@&@@@@@&&%&%&@@#########((((((#%@%@#(((//////////////
27 //////////%(//(/////////(&&@@&(///@@@@@@@@@&&&&%@@@&&&&&%%&&&&(((((((((((((###(@///(##//////////////
28 //////////#(////////////%&@&@@@@@@@@@&%(((((///((%@&@@@@&%%%%&@&%#(((((((((((&%@///#(((/////////////
29 /////////(///////////////@&@&&&%(//((////////////////((%#(//////(/#(@%#(((((#@(&///#(/#/////////////
30 /////////(((//////////////@#&@//////////////////////////(##///////(/##&((((((&%@//(#/##(////////////
31 /////////#(////////////////%%#@(/////////////////////////(##/////////(&#(////%(@(//%(%(%////////////
32 /////////%#/////////////////#@@&@#////////////////////////(#%//////////@(////&(&(/((#%#%////////////
33 /////////&#//////////////////#%%(/@(///////////////////////###//////////@(////@@(//(%%%&&///////////
34 ////////(#(///////////////////((&%(@##(/////////////////////%&//////////%#///&(#(//((&#&##//////////
35 ////////%(/////////(////////////#(&&(/#@%///////////////////(%(//////////&///&##(////%@&&%//////////
36 ///////(&(/(//////(%&(////////////#(#%#/%%(/////////////////(%#//////////&//(&&#/////(&@#@(/////////
37 ///////%%(/(/////(#(%//////////////(((#(%&&&&#///////////////##/////////(%/(#/(///////%@&(&/////////
38 ///////%((/(///((%//@%/////////////////#((##//&&(///////////(##/////////(@&&&%//////(/%&(#&(////////
39 //////(%(/////(%@&(((/////////////////(//(##(#&#%&###(////(///(///(((##&((&(%///////(/%@#%(@////////
40 ///////#(///((@@////////////////////////(////%(#(////(&(#&##&&&((&#////#@##/////////(/%&&@@%////////
41 ///////%@%%@%%#////////////////////////////(/////#&&(##&///(///&&%//(&&(/(//////////((%#/((/////////
42 ///////(/((/(//////////////////////////////////////////(%&&&%&%@@&&(////////////////((%///(/////////
43 /////////((((//////////////////////////////////////////////(////////////////////////((#//(//////////
44 /////////(/((/////////////////////////////////////////////////////////////((((//(((//&#/////////////
45 /////////#//(/(///////////////////////////////////////////////(%#((//////////////(/#%(//////////////
46 ///////////(#//((///((/((//////////////////////////////////((#&&%(#//////////////%@%////////////////
47 ///////////#(//#/(/(////((/(////////////////////////(////////%##(#(//////////(%%&%(/////////////////
48 ///////////&#//////////////(#%%((((////((//////////////////////(////////(%#%#&#%//#/////////////////
49 ///////////&#(////////////////////#(#%&%#(////////////////////////(#////#%#(((////%/////////////////
50 ///////////#%///////////////%//////////(#(///(%%#%&%((///(((((##%&&@&#((/(///////(#(////////////////
51 //////////((&////////////((////////////////////(((//////////////////////#%((//////(#////////////////
52 //////////((%(////(//(/#(////////////////////////////////////////////////(@((//////(#@(/////////////
53 ////////////////////////////////////////////////////////////////////////////////////////////////////
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 // File: ECDSA.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 
127 /**
128  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
129  *
130  * These functions can be used to verify that a message was signed by the holder
131  * of the private keys of a given address.
132  */
133 library ECDSA {
134     enum RecoverError {
135         NoError,
136         InvalidSignature,
137         InvalidSignatureLength,
138         InvalidSignatureS,
139         InvalidSignatureV
140     }
141 
142     function _throwError(RecoverError error) private pure {
143         if (error == RecoverError.NoError) {
144             return; // no error: do nothing
145         } else if (error == RecoverError.InvalidSignature) {
146             revert("ECDSA: invalid signature");
147         } else if (error == RecoverError.InvalidSignatureLength) {
148             revert("ECDSA: invalid signature length");
149         } else if (error == RecoverError.InvalidSignatureS) {
150             revert("ECDSA: invalid signature 's' value");
151         } else if (error == RecoverError.InvalidSignatureV) {
152             revert("ECDSA: invalid signature 'v' value");
153         }
154     }
155 
156     /**
157      * @dev Returns the address that signed a hashed message (`hash`) with
158      * `signature` or error string. This address can then be used for verification purposes.
159      *
160      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
161      * this function rejects them by requiring the `s` value to be in the lower
162      * half order, and the `v` value to be either 27 or 28.
163      *
164      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
165      * verification to be secure: it is possible to craft signatures that
166      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
167      * this is by receiving a hash of the original message (which may otherwise
168      * be too long), and then calling {toEthSignedMessageHash} on it.
169      *
170      * Documentation for signature generation:
171      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
172      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
173      *
174      * _Available since v4.3._
175      */
176     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
177         // Check the signature length
178         // - case 65: r,s,v signature (standard)
179         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
180         if (signature.length == 65) {
181             bytes32 r;
182             bytes32 s;
183             uint8 v;
184             // ecrecover takes the signature parameters, and the only way to get them
185             // currently is to use assembly.
186             assembly {
187                 r := mload(add(signature, 0x20))
188                 s := mload(add(signature, 0x40))
189                 v := byte(0, mload(add(signature, 0x60)))
190             }
191             return tryRecover(hash, v, r, s);
192         } else if (signature.length == 64) {
193             bytes32 r;
194             bytes32 vs;
195             // ecrecover takes the signature parameters, and the only way to get them
196             // currently is to use assembly.
197             assembly {
198                 r := mload(add(signature, 0x20))
199                 vs := mload(add(signature, 0x40))
200             }
201             return tryRecover(hash, r, vs);
202         } else {
203             return (address(0), RecoverError.InvalidSignatureLength);
204         }
205     }
206 
207     /**
208      * @dev Returns the address that signed a hashed message (`hash`) with
209      * `signature`. This address can then be used for verification purposes.
210      *
211      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
212      * this function rejects them by requiring the `s` value to be in the lower
213      * half order, and the `v` value to be either 27 or 28.
214      *
215      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
216      * verification to be secure: it is possible to craft signatures that
217      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
218      * this is by receiving a hash of the original message (which may otherwise
219      * be too long), and then calling {toEthSignedMessageHash} on it.
220      */
221     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
222         (address recovered, RecoverError error) = tryRecover(hash, signature);
223         _throwError(error);
224         return recovered;
225     }
226 
227     /**
228      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
229      *
230      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
231      *
232      * _Available since v4.3._
233      */
234     function tryRecover(
235         bytes32 hash,
236         bytes32 r,
237         bytes32 vs
238     ) internal pure returns (address, RecoverError) {
239         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
240         uint8 v = uint8((uint256(vs) >> 255) + 27);
241         return tryRecover(hash, v, r, s);
242     }
243 
244     /**
245      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
246      *
247      * _Available since v4.2._
248      */
249     function recover(
250         bytes32 hash,
251         bytes32 r,
252         bytes32 vs
253     ) internal pure returns (address) {
254         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
255         _throwError(error);
256         return recovered;
257     }
258 
259     /**
260      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
261      * `r` and `s` signature fields separately.
262      *
263      * _Available since v4.3._
264      */
265     function tryRecover(
266         bytes32 hash,
267         uint8 v,
268         bytes32 r,
269         bytes32 s
270     ) internal pure returns (address, RecoverError) {
271         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
272         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
273         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
274         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
275         //
276         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
277         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
278         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
279         // these malleable signatures as well.
280         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
281             return (address(0), RecoverError.InvalidSignatureS);
282         }
283         if (v != 27 && v != 28) {
284             return (address(0), RecoverError.InvalidSignatureV);
285         }
286 
287         // If the signature is valid (and not malleable), return the signer address
288         address signer = ecrecover(hash, v, r, s);
289         if (signer == address(0)) {
290             return (address(0), RecoverError.InvalidSignature);
291         }
292 
293         return (signer, RecoverError.NoError);
294     }
295 
296     /**
297      * @dev Overload of {ECDSA-recover} that receives the `v`,
298      * `r` and `s` signature fields separately.
299      */
300     function recover(
301         bytes32 hash,
302         uint8 v,
303         bytes32 r,
304         bytes32 s
305     ) internal pure returns (address) {
306         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
307         _throwError(error);
308         return recovered;
309     }
310 
311     /**
312      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
313      * produces hash corresponding to the one signed with the
314      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
315      * JSON-RPC method as part of EIP-191.
316      *
317      * See {recover}.
318      */
319     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
320         // 32 is the length in bytes of hash,
321         // enforced by the type signature above
322         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
323     }
324 
325     /**
326      * @dev Returns an Ethereum Signed Message, created from `s`. This
327      * produces hash corresponding to the one signed with the
328      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
329      * JSON-RPC method as part of EIP-191.
330      *
331      * See {recover}.
332      */
333     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
334         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
335     }
336 
337     /**
338      * @dev Returns an Ethereum Signed Typed Data, created from a
339      * `domainSeparator` and a `structHash`. This produces hash corresponding
340      * to the one signed with the
341      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
342      * JSON-RPC method as part of EIP-712.
343      *
344      * See {recover}.
345      */
346     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
347         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
348     }
349 }
350 // File: Context.sol
351 
352 
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
375 // File: Ownable.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 abstract contract Ownable is Context {
395     address private _owner;
396 
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398 
399     /**
400      * @dev Initializes the contract setting the deployer as the initial owner.
401      */
402     constructor() {
403         _setOwner(_msgSender());
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view virtual returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(owner() == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         _setOwner(address(0));
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         _setOwner(newOwner);
439     }
440 
441     function _setOwner(address newOwner) private {
442         address oldOwner = _owner;
443         _owner = newOwner;
444         emit OwnershipTransferred(oldOwner, newOwner);
445     }
446 }
447 // File: Address.sol
448 
449 
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * [IMPORTANT]
461      * ====
462      * It is unsafe to assume that an address for which this function returns
463      * false is an externally-owned account (EOA) and not a contract.
464      *
465      * Among others, `isContract` will return false for the following
466      * types of addresses:
467      *
468      *  - an externally-owned account
469      *  - a contract in construction
470      *  - an address where a contract will be created
471      *  - an address where a contract lived, but was destroyed
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize, which returns 0 for contracts in
476         // construction, since the code is only stored at the end of the
477         // constructor execution.
478 
479         uint256 size;
480         assembly {
481             size := extcodesize(account)
482         }
483         return size > 0;
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
580         return _verifyCallResult(success, returndata, errorMessage);
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
607         return _verifyCallResult(success, returndata, errorMessage);
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
634         return _verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     function _verifyCallResult(
638         bool success,
639         bytes memory returndata,
640         string memory errorMessage
641     ) private pure returns (bytes memory) {
642         if (success) {
643             return returndata;
644         } else {
645             // Look for revert reason and bubble it up if present
646             if (returndata.length > 0) {
647                 // The easiest way to bubble the revert reason is using memory via assembly
648 
649                 assembly {
650                     let returndata_size := mload(returndata)
651                     revert(add(32, returndata), returndata_size)
652                 }
653             } else {
654                 revert(errorMessage);
655             }
656         }
657     }
658 }
659 
660 // File: IERC721Receiver.sol
661 
662 pragma solidity ^0.8.0;
663 
664 /**
665  * @title ERC721 token receiver interface
666  * @dev Interface for any contract that wants to support safeTransfers
667  * from ERC721 asset contracts.
668  */
669 interface IERC721Receiver {
670     /**
671      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
672      * by `operator` from `from`, this function is called.
673      *
674      * It must return its Solidity selector to confirm the token transfer.
675      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
676      *
677      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
678      */
679     function onERC721Received(
680         address operator,
681         address from,
682         uint256 tokenId,
683         bytes calldata data
684     ) external returns (bytes4);
685 }
686 // File: IERC165.sol
687 
688 
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Interface of the ERC165 standard, as defined in the
694  * https://eips.ethereum.org/EIPS/eip-165[EIP].
695  *
696  * Implementers can declare support of contract interfaces, which can then be
697  * queried by others ({ERC165Checker}).
698  *
699  * For an implementation, see {ERC165}.
700  */
701 interface IERC165 {
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30 000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 }
712 // File: ERC165.sol
713 
714 
715 
716 pragma solidity ^0.8.0;
717 
718 
719 /**
720  * @dev Implementation of the {IERC165} interface.
721  *
722  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
723  * for the additional interface id that will be supported. For example:
724  *
725  * ```solidity
726  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
728  * }
729  * ```
730  *
731  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
732  */
733 abstract contract ERC165 is IERC165 {
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
738         return interfaceId == type(IERC165).interfaceId;
739     }
740 }
741 // File: IERC721.sol
742 
743 
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Required interface of an ERC721 compliant contract.
750  */
751 interface IERC721 is IERC165 {
752     /**
753      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
754      */
755     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
759      */
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
764      */
765     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
766 
767     /**
768      * @dev Returns the number of tokens in ``owner``'s account.
769      */
770     function balanceOf(address owner) external view returns (uint256 balance);
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) external view returns (address owner);
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) external view returns (address operator);
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes calldata data
882     ) external;
883 }
884 // File: IERC721Enumerable.sol
885 
886 
887 
888 pragma solidity ^0.8.0;
889 
890 
891 /**
892  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
893  * @dev See https://eips.ethereum.org/EIPS/eip-721
894  */
895 interface IERC721Enumerable is IERC721 {
896     /**
897      * @dev Returns the total amount of tokens stored by the contract.
898      */
899     function totalSupply() external view returns (uint256);
900 
901     /**
902      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
903      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
904      */
905     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
906 
907     /**
908      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
909      * Use along with {totalSupply} to enumerate all tokens.
910      */
911     function tokenByIndex(uint256 index) external view returns (uint256);
912 }
913 // File: IERC721Metadata.sol
914 
915 
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /**
921  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
922  * @dev See https://eips.ethereum.org/EIPS/eip-721
923  */
924 interface IERC721Metadata is IERC721 {
925     /**
926      * @dev Returns the token collection name.
927      */
928     function name() external view returns (string memory);
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() external view returns (string memory);
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) external view returns (string memory);
939 }
940 // File: ERC721A.sol
941 
942 
943 pragma solidity ^0.8.0;
944 
945 
946 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
947     using Address for address;
948     using Strings for uint256;
949 
950     struct TokenOwnership {
951         address addr;
952         uint64 startTimestamp;
953     }
954 
955     struct AddressData {
956         uint128 balance;
957         uint128 numberMinted;
958     }
959 
960     uint256 internal currentIndex;
961 
962     // Token name
963     string private _name;
964 
965     // Token symbol
966     string private _symbol;
967 
968     // Mapping from token ID to ownership details
969     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
970     mapping(uint256 => TokenOwnership) internal _ownerships;
971 
972     // Mapping owner address to address data
973     mapping(address => AddressData) private _addressData;
974 
975     // Mapping from token ID to approved address
976     mapping(uint256 => address) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     constructor(string memory name_, string memory symbol_) {
982         _name = name_;
983         _symbol = symbol_;
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-totalSupply}.
988      */
989     function totalSupply() public view override returns (uint256) {
990         return currentIndex;
991     }
992 
993     /**
994      * @dev See {IERC721Enumerable-tokenByIndex}.
995      */
996     function tokenByIndex(uint256 index) public view override returns (uint256) {
997         require(index < totalSupply(), 'ERC721A: global index out of bounds');
998         return index;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1003      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1004      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1007         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1008         uint256 numMintedSoFar = totalSupply();
1009         uint256 tokenIdsIdx;
1010         address currOwnershipAddr;
1011 
1012         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1013         unchecked {
1014             for (uint256 i; i < numMintedSoFar; i++) {
1015                 TokenOwnership memory ownership = _ownerships[i];
1016                 if (ownership.addr != address(0)) {
1017                     currOwnershipAddr = ownership.addr;
1018                 }
1019                 if (currOwnershipAddr == owner) {
1020                     if (tokenIdsIdx == index) {
1021                         return i;
1022                     }
1023                     tokenIdsIdx++;
1024                 }
1025             }
1026         }
1027 
1028         revert('ERC721A: unable to get token of owner by index');
1029     }
1030 
1031     /**
1032      * @dev See {IERC165-supportsInterface}.
1033      */
1034     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1035         return
1036             interfaceId == type(IERC721).interfaceId ||
1037             interfaceId == type(IERC721Metadata).interfaceId ||
1038             interfaceId == type(IERC721Enumerable).interfaceId ||
1039             super.supportsInterface(interfaceId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-balanceOf}.
1044      */
1045     function balanceOf(address owner) public view override returns (uint256) {
1046         require(owner != address(0), 'ERC721A: balance query for the zero address');
1047         return uint256(_addressData[owner].balance);
1048     }
1049 
1050     function _numberMinted(address owner) internal view returns (uint256) {
1051         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1052         return uint256(_addressData[owner].numberMinted);
1053     }
1054 
1055     /**
1056      * Gas spent here starts off proportional to the maximum mint batch size.
1057      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1058      */
1059     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1060         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1061 
1062         unchecked {
1063             for (uint256 curr = tokenId; curr >= 0; curr--) {
1064                 TokenOwnership memory ownership = _ownerships[curr];
1065                 if (ownership.addr != address(0)) {
1066                     return ownership;
1067                 }
1068             }
1069         }
1070 
1071         revert('ERC721A: unable to determine the owner of token');
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-ownerOf}.
1076      */
1077     function ownerOf(uint256 tokenId) public view override returns (address) {
1078         return ownershipOf(tokenId).addr;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-name}.
1083      */
1084     function name() public view virtual override returns (string memory) {
1085         return _name;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-symbol}.
1090      */
1091     function symbol() public view virtual override returns (string memory) {
1092         return _symbol;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Metadata-tokenURI}.
1097      */
1098     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1099         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1100 
1101         string memory baseURI = _baseURI();
1102         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1103     }
1104 
1105     /**
1106      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1107      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1108      * by default, can be overriden in child contracts.
1109      */
1110     function _baseURI() internal view virtual returns (string memory) {
1111         return '';
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-approve}.
1116      */
1117     function approve(address to, uint256 tokenId) public override {
1118         address owner = ERC721A.ownerOf(tokenId);
1119         require(to != owner, 'ERC721A: approval to current owner');
1120 
1121         require(
1122             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1123             'ERC721A: approve caller is not owner nor approved for all'
1124         );
1125 
1126         _approve(to, tokenId, owner);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721-getApproved}.
1131      */
1132     function getApproved(uint256 tokenId) public view override returns (address) {
1133         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1134 
1135         return _tokenApprovals[tokenId];
1136     }
1137 
1138     /**
1139      * @dev See {IERC721-setApprovalForAll}.
1140      */
1141     function setApprovalForAll(address operator, bool approved) public override {
1142         require(operator != _msgSender(), 'ERC721A: approve to caller');
1143 
1144         _operatorApprovals[_msgSender()][operator] = approved;
1145         emit ApprovalForAll(_msgSender(), operator, approved);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-isApprovedForAll}.
1150      */
1151     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1152         return _operatorApprovals[owner][operator];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-transferFrom}.
1157      */
1158     function transferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId
1162     ) public override {
1163         _transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-safeTransferFrom}.
1168      */
1169     function safeTransferFrom(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) public override {
1174         safeTransferFrom(from, to, tokenId, '');
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-safeTransferFrom}.
1179      */
1180     function safeTransferFrom(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) public override {
1186         _transfer(from, to, tokenId);
1187         require(
1188             _checkOnERC721Received(from, to, tokenId, _data),
1189             'ERC721A: transfer to non ERC721Receiver implementer'
1190         );
1191     }
1192 
1193     /**
1194      * @dev Returns whether `tokenId` exists.
1195      *
1196      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1197      *
1198      * Tokens start existing when they are minted (`_mint`),
1199      */
1200     function _exists(uint256 tokenId) internal view returns (bool) {
1201         return tokenId < currentIndex;
1202     }
1203 
1204     function _safeMint(address to, uint256 quantity) internal {
1205         _safeMint(to, quantity, '');
1206     }
1207 
1208     /**
1209      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1214      * - `quantity` must be greater than 0.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _safeMint(
1219         address to,
1220         uint256 quantity,
1221         bytes memory _data
1222     ) internal {
1223         _mint(to, quantity, _data, true);
1224     }
1225 
1226     /**
1227      * @dev Mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - `to` cannot be the zero address.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _mint(
1237         address to,
1238         uint256 quantity,
1239         bytes memory _data,
1240         bool safe
1241     ) internal {
1242         uint256 startTokenId = currentIndex;
1243         require(to != address(0), 'ERC721A: mint to the zero address');
1244         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1245 
1246         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1247 
1248         // Overflows are incredibly unrealistic.
1249         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1250         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1251         unchecked {
1252             _addressData[to].balance += uint128(quantity);
1253             _addressData[to].numberMinted += uint128(quantity);
1254 
1255             _ownerships[startTokenId].addr = to;
1256             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1257 
1258             uint256 updatedIndex = startTokenId;
1259 
1260             for (uint256 i; i < quantity; i++) {
1261                 emit Transfer(address(0), to, updatedIndex);
1262                 if (safe) {
1263                     require(
1264                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1265                         'ERC721A: transfer to non ERC721Receiver implementer'
1266                     );
1267                 }
1268 
1269                 updatedIndex++;
1270             }
1271 
1272             currentIndex = updatedIndex;
1273         }
1274 
1275         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1276     }
1277 
1278     /**
1279      * @dev Transfers `tokenId` from `from` to `to`.
1280      *
1281      * Requirements:
1282      *
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must be owned by `from`.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function _transfer(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) private {
1293         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1294 
1295         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1296             getApproved(tokenId) == _msgSender() ||
1297             isApprovedForAll(prevOwnership.addr, _msgSender()));
1298 
1299         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1300 
1301         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1302         require(to != address(0), 'ERC721A: transfer to the zero address');
1303 
1304         _beforeTokenTransfers(from, to, tokenId, 1);
1305 
1306         // Clear approvals from the previous owner
1307         _approve(address(0), tokenId, prevOwnership.addr);
1308 
1309         // Underflow of the sender's balance is impossible because we check for
1310         // ownership above and the recipient's balance can't realistically overflow.
1311         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1312         unchecked {
1313             _addressData[from].balance -= 1;
1314             _addressData[to].balance += 1;
1315 
1316             _ownerships[tokenId].addr = to;
1317             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1318 
1319             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1320             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1321             uint256 nextTokenId = tokenId + 1;
1322             if (_ownerships[nextTokenId].addr == address(0)) {
1323                 if (_exists(nextTokenId)) {
1324                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1325                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(from, to, tokenId);
1331         _afterTokenTransfers(from, to, tokenId, 1);
1332     }
1333 
1334     /**
1335      * @dev Approve `to` to operate on `tokenId`
1336      *
1337      * Emits a {Approval} event.
1338      */
1339     function _approve(
1340         address to,
1341         uint256 tokenId,
1342         address owner
1343     ) private {
1344         _tokenApprovals[tokenId] = to;
1345         emit Approval(owner, to, tokenId);
1346     }
1347 
1348     /**
1349      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1350      * The call is not executed if the target address is not a contract.
1351      *
1352      * @param from address representing the previous owner of the given token ID
1353      * @param to target address that will receive the tokens
1354      * @param tokenId uint256 ID of the token to be transferred
1355      * @param _data bytes optional data to send along with the call
1356      * @return bool whether the call correctly returned the expected magic value
1357      */
1358     function _checkOnERC721Received(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) private returns (bool) {
1364         if (to.isContract()) {
1365             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1366                 return retval == IERC721Receiver(to).onERC721Received.selector;
1367             } catch (bytes memory reason) {
1368                 if (reason.length == 0) {
1369                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1370                 } else {
1371                     assembly {
1372                         revert(add(32, reason), mload(reason))
1373                     }
1374                 }
1375             }
1376         } else {
1377             return true;
1378         }
1379     }
1380 
1381     /**
1382      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1383      *
1384      * startTokenId - the first token id to be transferred
1385      * quantity - the amount to be transferred
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      */
1393     function _beforeTokenTransfers(
1394         address from,
1395         address to,
1396         uint256 startTokenId,
1397         uint256 quantity
1398     ) internal virtual {}
1399 
1400     /**
1401      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1402      * minting.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - when `from` and `to` are both non-zero.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _afterTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 }
1419 
1420 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1421 
1422 pragma solidity ^0.8.0;
1423 
1424 /**
1425  * @dev Contract module that helps prevent reentrant calls to a function.
1426  *
1427  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1428  * available, which can be applied to functions to make sure there are no nested
1429  * (reentrant) calls to them.
1430  *
1431  * Note that because there is a single `nonReentrant` guard, functions marked as
1432  * `nonReentrant` may not call one another. This can be worked around by making
1433  * those functions `private`, and then adding `external` `nonReentrant` entry
1434  * points to them.
1435  *
1436  * TIP: If you would like to learn more about reentrancy and alternative ways
1437  * to protect against it, check out our blog post
1438  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1439  */
1440 abstract contract ReentrancyGuard {
1441     // Booleans are more expensive than uint256 or any type that takes up a full
1442     // word because each write operation emits an extra SLOAD to first read the
1443     // slot's contents, replace the bits taken up by the boolean, and then write
1444     // back. This is the compiler's defense against contract upgrades and
1445     // pointer aliasing, and it cannot be disabled.
1446 
1447     // The values being non-zero value makes deployment a bit more expensive,
1448     // but in exchange the refund on every call to nonReentrant will be lower in
1449     // amount. Since refunds are capped to a percentage of the total
1450     // transaction's gas, it is best to keep them low in cases like this one, to
1451     // increase the likelihood of the full refund coming into effect.
1452     uint256 private constant _NOT_ENTERED = 1;
1453     uint256 private constant _ENTERED = 2;
1454 
1455     uint256 private _status;
1456 
1457     constructor() {
1458         _status = _NOT_ENTERED;
1459     }
1460 
1461     /**
1462      * @dev Prevents a contract from calling itself, directly or indirectly.
1463      * Calling a `nonReentrant` function from another `nonReentrant`
1464      * function is not supported. It is possible to prevent this from happening
1465      * by making the `nonReentrant` function external, and making it call a
1466      * `private` function that does the actual work.
1467      */
1468     modifier nonReentrant() {
1469         // On the first call to nonReentrant, _notEntered will be true
1470         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1471 
1472         // Any calls to nonReentrant after this point will fail
1473         _status = _ENTERED;
1474 
1475         _;
1476 
1477         // By storing the original value once again, a refund is triggered (see
1478         // https://eips.ethereum.org/EIPS/eip-2200)
1479         _status = _NOT_ENTERED;
1480     }
1481 }
1482 
1483 pragma solidity ^0.8.2;
1484 
1485 abstract contract DATOLTINGEE {
1486     function ownerOf(uint256 tokenId) public virtual view returns(address);
1487 
1488     function NOMZ(uint256 distinghear) external virtual;
1489 
1490     function oopsy(uint256) public virtual view returns(bool);
1491 
1492     function frizewitdat(uint256) public virtual view returns(uint);
1493 
1494     function SLOPstufs(uint256) public virtual view returns(uint);
1495 
1496     function MEEEEEET(uint256) public virtual view returns(uint);
1497 
1498     function mellteeGUDnesses(uint256) public virtual view returns(uint);
1499 
1500     function stufonnaTOP(uint256) public virtual view returns(uint);
1501 
1502     function grippeebits(uint256) public virtual view returns(uint);
1503 }
1504 
1505 abstract contract DATUDDEROLDTINGEE {
1506     function ownerOf(uint256 tokenId) public virtual view returns(address);
1507 }
1508 
1509 contract grumpls is ERC721A, Ownable, ReentrancyGuard {
1510     using Strings for uint256;
1511     string public ALLDATstuffs;
1512     DATOLTINGEE private datoltingee;
1513     DATUDDEROLDTINGEE private dattudderoldtingee;
1514 
1515     error dattunbesidewaez(uint256 stuffs);
1516     error cantMEKaburgrADOGG(uint256 SIDWAEZ);
1517     error kinchooKOUNT();
1518     error distingOFF();
1519     error yooAINTdabossoHIM();
1520     error needayoosatoppin();
1521     error speshululreddyclaimed();
1522     error goblinNOSTEALIN();
1523 
1524     uint256 private trowDISindaTRAPP = 0;
1525 
1526     bool public izzitON;
1527     bool public izzitINdere;
1528 
1529     address datoltingeeadriss = 0xc5B52253f5225835cc81C52cdb3d6A22bc3B0c93;
1530     address dattudderoldtingeeadriss = 0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e;
1531     address daKing = 0x9478b25707fE50043d34b38F28765616c47f88BD;
1532 
1533     mapping(uint256 => uint) public stakkinUPdaGREEDyintsfrizewitdat;
1534     mapping(uint256 => uint) public stakkinUPdaGREEDyintsSLOPstufs;
1535     mapping(uint256 => uint) public stakkinUPdaGREEDyintsMEEEEEET;
1536     mapping(uint256 => uint) public stakkinUPdaGREEDyintsmellteeGUDnesses;
1537     mapping(uint256 => uint) public stakkinUPdaGREEDyintsstufonnaTOP;
1538     mapping(uint256 => uint) public stakkinUPdaGREEDyintsgrippeebits;
1539 
1540     mapping(uint256 => bool) public oooooshynee;
1541     mapping(uint256 => uint256) public watgotTROWNin;
1542     mapping(uint256 => uint256) public watToppinsgotTROWNin;
1543 
1544     mapping(uint256 => bool) public HOODIDdis;
1545 
1546     constructor() ERC721A("grumpls", "GRUMPL") {
1547         datoltingee = DATOLTINGEE(datoltingeeadriss);
1548         dattudderoldtingee = DATUDDEROLDTINGEE(dattudderoldtingeeadriss);
1549     }
1550 
1551     function _baseURI() internal view virtual override returns(string memory) {
1552         return ALLDATstuffs;
1553     }
1554 
1555     function watzaSPESHUL(uint256[] calldata speshulz) public onlyOwner {
1556         for (uint256 i = 0; i < speshulz.length; i++) {
1557             oooooshynee[speshulz[i]] = true;
1558         }
1559     }
1560 
1561     function ternItINdere(bool dere) public onlyOwner {
1562         izzitINdere = dere;
1563     }
1564 
1565     function ternON(bool itzON) public onlyOwner {
1566         izzitON = itzON;
1567     }
1568 
1569     function itsabrgrr(uint ORDURRnumbr, uint256[] calldata stuffs, uint frize, uint slop, uint meet, uint meltee, uint stuf, uint gripee) external {
1570     
1571         if(msg.sender != daKing){
1572             if (!izzitON) {
1573                 revert distingOFF();
1574             }
1575         }
1576     
1577         uint howMENNYzit = totalSupply();
1578 
1579         if (dattudderoldtingee.ownerOf(ORDURRnumbr) != msg.sender) {
1580             revert yooAINTdabossoHIM();
1581         }
1582 
1583         if (stuffs.length != 1) {
1584             revert kinchooKOUNT();
1585         }
1586   
1587         uint daTingys = frize + slop + meet + meltee + stuf + gripee;
1588 
1589         if (daTingys < 1 || daTingys > 6) {
1590             revert needayoosatoppin();
1591         }
1592 
1593         nomNOMNOMnomnom(stuffs);
1594 
1595         watToppinsgotTROWNin[howMENNYzit] = daTingys;
1596 
1597         if (frize > trowDISindaTRAPP) {
1598             stakkinUPdaGREEDyintsfrizewitdat[howMENNYzit] = datoltingee.frizewitdat(stuffs[0]);
1599         }
1600 
1601         if (slop > trowDISindaTRAPP) {
1602             stakkinUPdaGREEDyintsSLOPstufs[howMENNYzit] = datoltingee.SLOPstufs(stuffs[0]);
1603         }
1604 
1605         if (meet > trowDISindaTRAPP) {
1606             stakkinUPdaGREEDyintsMEEEEEET[howMENNYzit] = datoltingee.MEEEEEET(stuffs[0]);
1607         }
1608 
1609         if (meltee > trowDISindaTRAPP) {
1610             stakkinUPdaGREEDyintsmellteeGUDnesses[howMENNYzit] = datoltingee.mellteeGUDnesses(stuffs[0]);
1611         }
1612 
1613         if (stuf > trowDISindaTRAPP) {
1614             stakkinUPdaGREEDyintsstufonnaTOP[howMENNYzit] = datoltingee.stufonnaTOP(stuffs[0]);
1615         }
1616 
1617         if (gripee > trowDISindaTRAPP) {
1618             stakkinUPdaGREEDyintsgrippeebits[howMENNYzit] = datoltingee.grippeebits(stuffs[0]);
1619         }
1620 
1621         if (!oooooshynee[ORDURRnumbr]) {
1622             watgotTROWNin[howMENNYzit] = 1;
1623         } else {
1624             if (HOODIDdis[ORDURRnumbr]) {
1625                 revert speshululreddyclaimed();
1626             }
1627 
1628             watgotTROWNin[howMENNYzit] = 0;
1629             HOODIDdis[ORDURRnumbr] = true;
1630         }
1631 
1632         _safeMint(msg.sender, 1);
1633     }
1634 
1635     function itsadubble(uint ORDURRnumbr, uint256[] calldata stuffs) external {
1636         if (!izzitON) {
1637             revert distingOFF();
1638         }
1639         require(!oooooshynee[ORDURRnumbr]);
1640         if (dattudderoldtingee.ownerOf(ORDURRnumbr) != msg.sender) {
1641             revert yooAINTdabossoHIM();
1642         }
1643         if (stuffs.length != 2) {
1644             revert kinchooKOUNT();
1645         }
1646         nomNOMNOMnomnom(stuffs);
1647 
1648         uint256 howMENNYzit = totalSupply();
1649         watgotTROWNin[howMENNYzit] = 2;
1650         _safeMint(msg.sender, 1);
1651     }
1652 
1653     function ohfukwatsHAPNIN(uint ORDURRnumbr, uint256[] calldata stuffs) external {
1654         if (!izzitON) {
1655             revert distingOFF();
1656         }
1657         require(!oooooshynee[ORDURRnumbr]);
1658         if (dattudderoldtingee.ownerOf(ORDURRnumbr) != msg.sender) {
1659             revert yooAINTdabossoHIM();
1660         }
1661         require(stuffs.length == 3);
1662         nomNOMNOMnomnom(stuffs);
1663 
1664         uint256 howMENNYzit = totalSupply();
1665         watgotTROWNin[howMENNYzit] = 3;
1666 
1667         _safeMint(msg.sender, 1);
1668     }
1669 
1670     function stikitINSIDWAEZ(uint ORDURRnumbr, uint peepeezNstuff) external {
1671         if (!izzitON) {
1672             revert distingOFF();
1673         }
1674         require(datoltingee.ownerOf(peepeezNstuff) == msg.sender);
1675         if (dattudderoldtingee.ownerOf(ORDURRnumbr) != msg.sender) {
1676             revert yooAINTdabossoHIM();
1677         }
1678         if (!datoltingee.oopsy(peepeezNstuff)) {
1679             revert cantMEKaburgrADOGG(peepeezNstuff);
1680         }
1681 
1682         datoltingee.NOMZ(peepeezNstuff);
1683         uint256 howMENNYzit = totalSupply();
1684 
1685         if (oooooshynee[ORDURRnumbr]) {
1686             if (HOODIDdis[ORDURRnumbr]) {
1687                 revert speshululreddyclaimed();
1688             }
1689             watgotTROWNin[howMENNYzit] = 5;
1690             HOODIDdis[ORDURRnumbr] = true;
1691         } else {
1692             watgotTROWNin[howMENNYzit] = 4;
1693         }
1694 
1695         _safeMint(msg.sender, 1);
1696     }
1697 
1698     function sompinNOOcummin(string memory datPikturethingy) external onlyOwner {
1699         ALLDATstuffs = datPikturethingy;
1700     }
1701 
1702     function tokenURI(uint256 grumpl) public view virtual override returns(string memory) {
1703         require(_exists(grumpl), "ERC721Metadata: URI query for nonexistent token");
1704 
1705         string memory baseURI = _baseURI();
1706         uint256 dagotTROWNin = watgotTROWNin[grumpl];
1707         uint burgrrr = watToppinsgotTROWNin[grumpl];
1708 
1709         if (izzitINdere) {
1710             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, grumpl.toString())) : '';
1711         } else {
1712             if (dagotTROWNin < 2) {
1713                 return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, dagotTROWNin.toString(), "-", burgrrr.toString())) : '';
1714             } else {
1715                 return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, dagotTROWNin.toString())) : '';
1716             }
1717         }
1718     }
1719 
1720     function nomNOMNOMnomnom(uint256[] calldata stuffs) internal {
1721         for (uint8 i = 0; i < stuffs.length; i++) {
1722             if (datoltingee.oopsy(stuffs[i])) {
1723                 revert dattunbesidewaez(stuffs[i]);
1724             } 
1725             if (datoltingee.ownerOf(stuffs[i]) != msg.sender) {
1726                 revert goblinNOSTEALIN();
1727             }
1728             datoltingee.NOMZ(stuffs[i]);
1729         }
1730     }
1731 
1732 }