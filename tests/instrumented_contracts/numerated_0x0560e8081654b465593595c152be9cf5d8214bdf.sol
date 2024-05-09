1 /**
2  
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:::@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@:::::-@@@@@@::::::@@:::::::::::::::::::::::::@::=-:@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@:***+:@@@@@@::**-+@@:*********+:************-=:**-:@@-::::@@@@@@@@@@@@@@@@@@
7 @@@@@:****-:@@@@@::**-*@@:***+++++++:+***********-=-**-=@@-:**-*@@@@@@@@@@@@@@@@@
8 @@@@@:*****::@@@@::**-*@@:**-------:::----**------*:--=*@@-:**-*@@@@@@@@@@@@@@@@@
9 @@@@@:**+**+-@@@@::**-*@@:**-+**********+-**-******@=+*@@@-:**-*@@@@@@@@@@@@@@@@@
10 @@@@@:**--**-:@@@::**-*@@:**-+@@@@@@@@@@-:**-*@@@@@::::@::::**--::@@@:::::@@@@@@@
11 @@@@@:**--***=:@@::**-*@@:**-=::::::@@@@-:**-*@@@@@:-=-*:-==**+=--@:::=+==-::@@@@
12 @@@@@:**--:**+:@@::**-*@@:**-:::::::@@@@-:**-*@@@@@:**-*:-******-=:: ******:-@@@@
13 @@@@@:**--:=**+::::**-*@@:********-:#@@@-:**-*@@@@@:**-*:-=+**+=-=:**+==-=-+*@@@@
14 @@@@@:**--@:+**=:::**-*@@:********-:%@@@-:**-*@@@@@:**-*@**-**-***:**+:--:+*@@@@@
15 @@@@@:**--@::***-::**-*@@:**-:::::::%@@@-:**-*@@@@@:**-*@@-:**-*@@:=**+=::+@@@@@@
16 @@@@@:**--@@:-***::**-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@@--*****+::@@@@@
17 @@@@@:**--@@@:=**=:**-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@@@::==***+::@@@@
18 @@@@@:**--@@@@:******-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@@@::+-:+**-:@@@@
19 @@@@@:**--@@@@:-*****-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@@::::::=**-=@@@@
20 @@@@@:**--@@@@@:=****-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@::-*+--+**-+@@@@
21 @@@@@:**--@@@@@-:=***-*@@:**-+@@@@@@@@@@-:**-*@@@@@:**-*@@-:**-*@::=******=+*@@@@
22 @@@@@::::-@@@@@@@::::-*@@::::+@@@@@@@@@@-::::*@@@@@::::*@@-::::*@@@:--++--+*@@@@@
23 @@@@@::::=@@@@@@@::::-*@@::::+@@@@@@@@@@:::::*@@@@@::::*@@-::::*@@@@+:=++**@@@@@@
24 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 
26 The NFTits Club | Official Contract | Gals Of The Galaxy
27 
28 */
29 
30 // SPDX-License-Identifier: MIT
31 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module that helps prevent reentrant calls to a function.
40  *
41  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
42  * available, which can be applied to functions to make sure there are no nested
43  * (reentrant) calls to them.
44  *
45  * Note that because there is a single `nonReentrant` guard, functions marked as
46  * `nonReentrant` may not call one another. This can be worked around by making
47  * those functions `private`, and then adding `external` `nonReentrant` entry
48  * points to them.
49  *
50  * TIP: If you would like to learn more about reentrancy and alternative ways
51  * to protect against it, check out our blog post
52  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
53  */
54 abstract contract ReentrancyGuard {
55     // Booleans are more expensive than uint256 or any type that takes up a full
56     // word because each write operation emits an extra SLOAD to first read the
57     // slot's contents, replace the bits taken up by the boolean, and then write
58     // back. This is the compiler's defense against contract upgrades and
59     // pointer aliasing, and it cannot be disabled.
60 
61     // The values being non-zero value makes deployment a bit more expensive,
62     // but in exchange the refund on every call to nonReentrant will be lower in
63     // amount. Since refunds are capped to a percentage of the total
64     // transaction's gas, it is best to keep them low in cases like this one, to
65     // increase the likelihood of the full refund coming into effect.
66     uint256 private constant _NOT_ENTERED = 1;
67     uint256 private constant _ENTERED = 2;
68 
69     uint256 private _status;
70 
71     constructor() {
72         _status = _NOT_ENTERED;
73     }
74 
75     /**
76      * @dev Prevents a contract from calling itself, directly or indirectly.
77      * Calling a `nonReentrant` function from another `nonReentrant`
78      * function is not supported. It is possible to prevent this from happening
79      * by making the `nonReentrant` function external, and making it call a
80      * `private` function that does the actual work.
81      */
82     modifier nonReentrant() {
83         // On the first call to nonReentrant, _notEntered will be true
84         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
85 
86         // Any calls to nonReentrant after this point will fail
87         _status = _ENTERED;
88 
89         _;
90 
91         // By storing the original value once again, a refund is triggered (see
92         // https://eips.ethereum.org/EIPS/eip-2200)
93         _status = _NOT_ENTERED;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Strings.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev String operations.
106  */
107 library Strings {
108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
112      */
113     function toString(uint256 value) internal pure returns (string memory) {
114         // Inspired by OraclizeAPI's implementation - MIT licence
115         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
116 
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
137      */
138     function toHexString(uint256 value) internal pure returns (string memory) {
139         if (value == 0) {
140             return "0x00";
141         }
142         uint256 temp = value;
143         uint256 length = 0;
144         while (temp != 0) {
145             length++;
146             temp >>= 8;
147         }
148         return toHexString(value, length);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
153      */
154     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
155         bytes memory buffer = new bytes(2 * length + 2);
156         buffer[0] = "0";
157         buffer[1] = "x";
158         for (uint256 i = 2 * length + 1; i > 1; --i) {
159             buffer[i] = _HEX_SYMBOLS[value & 0xf];
160             value >>= 4;
161         }
162         require(value == 0, "Strings: hex length insufficient");
163         return string(buffer);
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
168 
169 
170 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
177  *
178  * These functions can be used to verify that a message was signed by the holder
179  * of the private keys of a given address.
180  */
181 library ECDSA {
182     enum RecoverError {
183         NoError,
184         InvalidSignature,
185         InvalidSignatureLength,
186         InvalidSignatureS,
187         InvalidSignatureV
188     }
189 
190     function _throwError(RecoverError error) private pure {
191         if (error == RecoverError.NoError) {
192             return; // no error: do nothing
193         } else if (error == RecoverError.InvalidSignature) {
194             revert("ECDSA: invalid signature");
195         } else if (error == RecoverError.InvalidSignatureLength) {
196             revert("ECDSA: invalid signature length");
197         } else if (error == RecoverError.InvalidSignatureS) {
198             revert("ECDSA: invalid signature 's' value");
199         } else if (error == RecoverError.InvalidSignatureV) {
200             revert("ECDSA: invalid signature 'v' value");
201         }
202     }
203 
204     /**
205      * @dev Returns the address that signed a hashed message (`hash`) with
206      * `signature` or error string. This address can then be used for verification purposes.
207      *
208      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
209      * this function rejects them by requiring the `s` value to be in the lower
210      * half order, and the `v` value to be either 27 or 28.
211      *
212      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
213      * verification to be secure: it is possible to craft signatures that
214      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
215      * this is by receiving a hash of the original message (which may otherwise
216      * be too long), and then calling {toEthSignedMessageHash} on it.
217      *
218      * Documentation for signature generation:
219      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
220      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
221      *
222      * _Available since v4.3._
223      */
224     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
225         // Check the signature length
226         // - case 65: r,s,v signature (standard)
227         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
228         if (signature.length == 65) {
229             bytes32 r;
230             bytes32 s;
231             uint8 v;
232             // ecrecover takes the signature parameters, and the only way to get them
233             // currently is to use assembly.
234             assembly {
235                 r := mload(add(signature, 0x20))
236                 s := mload(add(signature, 0x40))
237                 v := byte(0, mload(add(signature, 0x60)))
238             }
239             return tryRecover(hash, v, r, s);
240         } else if (signature.length == 64) {
241             bytes32 r;
242             bytes32 vs;
243             // ecrecover takes the signature parameters, and the only way to get them
244             // currently is to use assembly.
245             assembly {
246                 r := mload(add(signature, 0x20))
247                 vs := mload(add(signature, 0x40))
248             }
249             return tryRecover(hash, r, vs);
250         } else {
251             return (address(0), RecoverError.InvalidSignatureLength);
252         }
253     }
254 
255     /**
256      * @dev Returns the address that signed a hashed message (`hash`) with
257      * `signature`. This address can then be used for verification purposes.
258      *
259      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
260      * this function rejects them by requiring the `s` value to be in the lower
261      * half order, and the `v` value to be either 27 or 28.
262      *
263      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
264      * verification to be secure: it is possible to craft signatures that
265      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
266      * this is by receiving a hash of the original message (which may otherwise
267      * be too long), and then calling {toEthSignedMessageHash} on it.
268      */
269     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
270         (address recovered, RecoverError error) = tryRecover(hash, signature);
271         _throwError(error);
272         return recovered;
273     }
274 
275     /**
276      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
277      *
278      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
279      *
280      * _Available since v4.3._
281      */
282     function tryRecover(
283         bytes32 hash,
284         bytes32 r,
285         bytes32 vs
286     ) internal pure returns (address, RecoverError) {
287         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
288         uint8 v = uint8((uint256(vs) >> 255) + 27);
289         return tryRecover(hash, v, r, s);
290     }
291 
292     /**
293      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
294      *
295      * _Available since v4.2._
296      */
297     function recover(
298         bytes32 hash,
299         bytes32 r,
300         bytes32 vs
301     ) internal pure returns (address) {
302         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
303         _throwError(error);
304         return recovered;
305     }
306 
307     /**
308      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
309      * `r` and `s` signature fields separately.
310      *
311      * _Available since v4.3._
312      */
313     function tryRecover(
314         bytes32 hash,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) internal pure returns (address, RecoverError) {
319         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
320         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
321         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
322         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
323         //
324         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
325         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
326         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
327         // these malleable signatures as well.
328         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
329             return (address(0), RecoverError.InvalidSignatureS);
330         }
331         if (v != 27 && v != 28) {
332             return (address(0), RecoverError.InvalidSignatureV);
333         }
334 
335         // If the signature is valid (and not malleable), return the signer address
336         address signer = ecrecover(hash, v, r, s);
337         if (signer == address(0)) {
338             return (address(0), RecoverError.InvalidSignature);
339         }
340 
341         return (signer, RecoverError.NoError);
342     }
343 
344     /**
345      * @dev Overload of {ECDSA-recover} that receives the `v`,
346      * `r` and `s` signature fields separately.
347      */
348     function recover(
349         bytes32 hash,
350         uint8 v,
351         bytes32 r,
352         bytes32 s
353     ) internal pure returns (address) {
354         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
355         _throwError(error);
356         return recovered;
357     }
358 
359     /**
360      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
361      * produces hash corresponding to the one signed with the
362      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
363      * JSON-RPC method as part of EIP-191.
364      *
365      * See {recover}.
366      */
367     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
368         // 32 is the length in bytes of hash,
369         // enforced by the type signature above
370         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
371     }
372 
373     /**
374      * @dev Returns an Ethereum Signed Message, created from `s`. This
375      * produces hash corresponding to the one signed with the
376      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
377      * JSON-RPC method as part of EIP-191.
378      *
379      * See {recover}.
380      */
381     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
382         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
383     }
384 
385     /**
386      * @dev Returns an Ethereum Signed Typed Data, created from a
387      * `domainSeparator` and a `structHash`. This produces hash corresponding
388      * to the one signed with the
389      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
390      * JSON-RPC method as part of EIP-712.
391      *
392      * See {recover}.
393      */
394     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
395         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
396     }
397 }
398 
399 // File: @openzeppelin/contracts/utils/Context.sol
400 
401 
402 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 /**
407  * @dev Provides information about the current execution context, including the
408  * sender of the transaction and its data. While these are generally available
409  * via msg.sender and msg.data, they should not be accessed in such a direct
410  * manner, since when dealing with meta-transactions the account sending and
411  * paying for execution may not be the actual sender (as far as an application
412  * is concerned).
413  *
414  * This contract is only required for intermediate, library-like contracts.
415  */
416 abstract contract Context {
417     function _msgSender() internal view virtual returns (address) {
418         return msg.sender;
419     }
420 
421     function _msgData() internal view virtual returns (bytes calldata) {
422         return msg.data;
423     }
424 }
425 
426 // File: @openzeppelin/contracts/access/Ownable.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 
434 /**
435  * @dev Contract module which provides a basic access control mechanism, where
436  * there is an account (an owner) that can be granted exclusive access to
437  * specific functions.
438  *
439  * By default, the owner account will be the one that deploys the contract. This
440  * can later be changed with {transferOwnership}.
441  *
442  * This module is used through inheritance. It will make available the modifier
443  * `onlyOwner`, which can be applied to your functions to restrict their use to
444  * the owner.
445  */
446 abstract contract Ownable is Context {
447     address private _owner;
448 
449     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
450 
451     /**
452      * @dev Initializes the contract setting the deployer as the initial owner.
453      */
454     constructor() {
455         _transferOwnership(_msgSender());
456     }
457 
458     /**
459      * @dev Returns the address of the current owner.
460      */
461     function owner() public view virtual returns (address) {
462         return _owner;
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         require(owner() == _msgSender(), "Ownable: caller is not the owner");
470         _;
471     }
472 
473     /**
474      * @dev Leaves the contract without owner. It will not be possible to call
475      * `onlyOwner` functions anymore. Can only be called by the current owner.
476      *
477      * NOTE: Renouncing ownership will leave the contract without an owner,
478      * thereby removing any functionality that is only available to the owner.
479      */
480     function renounceOwnership() public virtual onlyOwner {
481         _transferOwnership(address(0));
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         _transferOwnership(newOwner);
491     }
492 
493     /**
494      * @dev Transfers ownership of the contract to a new account (`newOwner`).
495      * Internal function without access restriction.
496      */
497     function _transferOwnership(address newOwner) internal virtual {
498         address oldOwner = _owner;
499         _owner = newOwner;
500         emit OwnershipTransferred(oldOwner, newOwner);
501     }
502 }
503 
504 // File: @openzeppelin/contracts/utils/Address.sol
505 
506 
507 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
508 
509 pragma solidity ^0.8.1;
510 
511 /**
512  * @dev Collection of functions related to the address type
513  */
514 library Address {
515     /**
516      * @dev Returns true if `account` is a contract.
517      *
518      * [IMPORTANT]
519      * ====
520      * It is unsafe to assume that an address for which this function returns
521      * false is an externally-owned account (EOA) and not a contract.
522      *
523      * Among others, `isContract` will return false for the following
524      * types of addresses:
525      *
526      *  - an externally-owned account
527      *  - a contract in construction
528      *  - an address where a contract will be created
529      *  - an address where a contract lived, but was destroyed
530      * ====
531      *
532      * [IMPORTANT]
533      * ====
534      * You shouldn't rely on `isContract` to protect against flash loan attacks!
535      *
536      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
537      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
538      * constructor.
539      * ====
540      */
541     function isContract(address account) internal view returns (bool) {
542         // This method relies on extcodesize/address.code.length, which returns 0
543         // for contracts in construction, since the code is only stored at the end
544         // of the constructor execution.
545 
546         return account.code.length > 0;
547     }
548 
549     /**
550      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
551      * `recipient`, forwarding all available gas and reverting on errors.
552      *
553      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
554      * of certain opcodes, possibly making contracts go over the 2300 gas limit
555      * imposed by `transfer`, making them unable to receive funds via
556      * `transfer`. {sendValue} removes this limitation.
557      *
558      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
559      *
560      * IMPORTANT: because control is transferred to `recipient`, care must be
561      * taken to not create reentrancy vulnerabilities. Consider using
562      * {ReentrancyGuard} or the
563      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
564      */
565     function sendValue(address payable recipient, uint256 amount) internal {
566         require(address(this).balance >= amount, "Address: insufficient balance");
567 
568         (bool success, ) = recipient.call{value: amount}("");
569         require(success, "Address: unable to send value, recipient may have reverted");
570     }
571 
572     /**
573      * @dev Performs a Solidity function call using a low level `call`. A
574      * plain `call` is an unsafe replacement for a function call: use this
575      * function instead.
576      *
577      * If `target` reverts with a revert reason, it is bubbled up by this
578      * function (like regular Solidity function calls).
579      *
580      * Returns the raw returned data. To convert to the expected return value,
581      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
582      *
583      * Requirements:
584      *
585      * - `target` must be a contract.
586      * - calling `target` with `data` must not revert.
587      *
588      * _Available since v3.1._
589      */
590     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
591         return functionCall(target, data, "Address: low-level call failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
596      * `errorMessage` as a fallback revert reason when `target` reverts.
597      *
598      * _Available since v3.1._
599      */
600     function functionCall(
601         address target,
602         bytes memory data,
603         string memory errorMessage
604     ) internal returns (bytes memory) {
605         return functionCallWithValue(target, data, 0, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but also transferring `value` wei to `target`.
611      *
612      * Requirements:
613      *
614      * - the calling contract must have an ETH balance of at least `value`.
615      * - the called Solidity function must be `payable`.
616      *
617      * _Available since v3.1._
618      */
619     function functionCallWithValue(
620         address target,
621         bytes memory data,
622         uint256 value
623     ) internal returns (bytes memory) {
624         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
629      * with `errorMessage` as a fallback revert reason when `target` reverts.
630      *
631      * _Available since v3.1._
632      */
633     function functionCallWithValue(
634         address target,
635         bytes memory data,
636         uint256 value,
637         string memory errorMessage
638     ) internal returns (bytes memory) {
639         require(address(this).balance >= value, "Address: insufficient balance for call");
640         require(isContract(target), "Address: call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.call{value: value}(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
648      * but performing a static call.
649      *
650      * _Available since v3.3._
651      */
652     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
653         return functionStaticCall(target, data, "Address: low-level static call failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
658      * but performing a static call.
659      *
660      * _Available since v3.3._
661      */
662     function functionStaticCall(
663         address target,
664         bytes memory data,
665         string memory errorMessage
666     ) internal view returns (bytes memory) {
667         require(isContract(target), "Address: static call to non-contract");
668 
669         (bool success, bytes memory returndata) = target.staticcall(data);
670         return verifyCallResult(success, returndata, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but performing a delegate call.
676      *
677      * _Available since v3.4._
678      */
679     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
680         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
685      * but performing a delegate call.
686      *
687      * _Available since v3.4._
688      */
689     function functionDelegateCall(
690         address target,
691         bytes memory data,
692         string memory errorMessage
693     ) internal returns (bytes memory) {
694         require(isContract(target), "Address: delegate call to non-contract");
695 
696         (bool success, bytes memory returndata) = target.delegatecall(data);
697         return verifyCallResult(success, returndata, errorMessage);
698     }
699 
700     /**
701      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
702      * revert reason using the provided one.
703      *
704      * _Available since v4.3._
705      */
706     function verifyCallResult(
707         bool success,
708         bytes memory returndata,
709         string memory errorMessage
710     ) internal pure returns (bytes memory) {
711         if (success) {
712             return returndata;
713         } else {
714             // Look for revert reason and bubble it up if present
715             if (returndata.length > 0) {
716                 // The easiest way to bubble the revert reason is using memory via assembly
717 
718                 assembly {
719                     let returndata_size := mload(returndata)
720                     revert(add(32, returndata), returndata_size)
721                 }
722             } else {
723                 revert(errorMessage);
724             }
725         }
726     }
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 /**
737  * @title ERC721 token receiver interface
738  * @dev Interface for any contract that wants to support safeTransfers
739  * from ERC721 asset contracts.
740  */
741 interface IERC721Receiver {
742     /**
743      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
744      * by `operator` from `from`, this function is called.
745      *
746      * It must return its Solidity selector to confirm the token transfer.
747      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
748      *
749      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
750      */
751     function onERC721Received(
752         address operator,
753         address from,
754         uint256 tokenId,
755         bytes calldata data
756     ) external returns (bytes4);
757 }
758 
759 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Interface of the ERC165 standard, as defined in the
768  * https://eips.ethereum.org/EIPS/eip-165[EIP].
769  *
770  * Implementers can declare support of contract interfaces, which can then be
771  * queried by others ({ERC165Checker}).
772  *
773  * For an implementation, see {ERC165}.
774  */
775 interface IERC165 {
776     /**
777      * @dev Returns true if this contract implements the interface defined by
778      * `interfaceId`. See the corresponding
779      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
780      * to learn more about how these ids are created.
781      *
782      * This function call must use less than 30 000 gas.
783      */
784     function supportsInterface(bytes4 interfaceId) external view returns (bool);
785 }
786 
787 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 
795 /**
796  * @dev Implementation of the {IERC165} interface.
797  *
798  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
799  * for the additional interface id that will be supported. For example:
800  *
801  * ```solidity
802  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
803  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
804  * }
805  * ```
806  *
807  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
808  */
809 abstract contract ERC165 is IERC165 {
810     /**
811      * @dev See {IERC165-supportsInterface}.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
814         return interfaceId == type(IERC165).interfaceId;
815     }
816 }
817 
818 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
819 
820 
821 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 
826 /**
827  * @dev Required interface of an ERC721 compliant contract.
828  */
829 interface IERC721 is IERC165 {
830     /**
831      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
832      */
833     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
834 
835     /**
836      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
837      */
838     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
839 
840     /**
841      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
842      */
843     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
844 
845     /**
846      * @dev Returns the number of tokens in ``owner``'s account.
847      */
848     function balanceOf(address owner) external view returns (uint256 balance);
849 
850     /**
851      * @dev Returns the owner of the `tokenId` token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function ownerOf(uint256 tokenId) external view returns (address owner);
858 
859     /**
860      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
861      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
862      *
863      * Requirements:
864      *
865      * - `from` cannot be the zero address.
866      * - `to` cannot be the zero address.
867      * - `tokenId` token must exist and be owned by `from`.
868      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
870      *
871      * Emits a {Transfer} event.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) external;
878 
879     /**
880      * @dev Transfers `tokenId` token from `from` to `to`.
881      *
882      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must be owned by `from`.
889      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
890      *
891      * Emits a {Transfer} event.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) external;
898 
899     /**
900      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
901      * The approval is cleared when the token is transferred.
902      *
903      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
904      *
905      * Requirements:
906      *
907      * - The caller must own the token or be an approved operator.
908      * - `tokenId` must exist.
909      *
910      * Emits an {Approval} event.
911      */
912     function approve(address to, uint256 tokenId) external;
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) external view returns (address operator);
922 
923     /**
924      * @dev Approve or remove `operator` as an operator for the caller.
925      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
926      *
927      * Requirements:
928      *
929      * - The `operator` cannot be the caller.
930      *
931      * Emits an {ApprovalForAll} event.
932      */
933     function setApprovalForAll(address operator, bool _approved) external;
934 
935     /**
936      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
937      *
938      * See {setApprovalForAll}
939      */
940     function isApprovedForAll(address owner, address operator) external view returns (bool);
941 
942     /**
943      * @dev Safely transfers `tokenId` token from `from` to `to`.
944      *
945      * Requirements:
946      *
947      * - `from` cannot be the zero address.
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must exist and be owned by `from`.
950      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
952      *
953      * Emits a {Transfer} event.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes calldata data
960     ) external;
961 }
962 
963 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
964 
965 
966 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 
971 /**
972  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
973  * @dev See https://eips.ethereum.org/EIPS/eip-721
974  */
975 interface IERC721Enumerable is IERC721 {
976     /**
977      * @dev Returns the total amount of tokens stored by the contract.
978      */
979     function totalSupply() external view returns (uint256);
980 
981     /**
982      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
983      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
984      */
985     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
986 
987     /**
988      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
989      * Use along with {totalSupply} to enumerate all tokens.
990      */
991     function tokenByIndex(uint256 index) external view returns (uint256);
992 }
993 
994 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
995 
996 
997 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1004  * @dev See https://eips.ethereum.org/EIPS/eip-721
1005  */
1006 interface IERC721Metadata is IERC721 {
1007     /**
1008      * @dev Returns the token collection name.
1009      */
1010     function name() external view returns (string memory);
1011 
1012     /**
1013      * @dev Returns the token collection symbol.
1014      */
1015     function symbol() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1019      */
1020     function tokenURI(uint256 tokenId) external view returns (string memory);
1021 }
1022 
1023 // File: contracts/ERC721A.sol
1024 
1025 
1026 // Creator: Chiru Labs
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 
1032 
1033 
1034 
1035 
1036 
1037 
1038 
1039 /**
1040  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1041  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1042  *
1043  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1044  *
1045  * Does not support burning tokens to address(0).
1046  */
1047 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1048     using Address for address;
1049     using Strings for uint256;
1050 
1051     struct TokenOwnership {
1052         address addr;
1053         uint64 startTimestamp;
1054     }
1055 
1056     struct AddressData {
1057         uint128 balance;
1058         uint128 numberMinted;
1059     }
1060 
1061     uint256 private currentIndex = 0;
1062 
1063     uint256 internal immutable maxBatchSize;
1064 
1065     // Token name
1066     string private _name;
1067 
1068     // Token symbol
1069     string private _symbol;
1070 
1071     // Mapping from token ID to ownership details
1072     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1073     mapping(uint256 => TokenOwnership) private _ownerships;
1074 
1075     // Mapping owner address to address data
1076     mapping(address => AddressData) private _addressData;
1077 
1078     // Mapping from token ID to approved address
1079     mapping(uint256 => address) private _tokenApprovals;
1080 
1081     // Mapping from owner to operator approvals
1082     mapping(address => mapping(address => bool)) private _operatorApprovals;
1083 
1084     /**
1085      * @dev
1086      * `maxBatchSize` refers to how much a minter can mint at a time.
1087      */
1088     constructor(
1089         string memory name_,
1090         string memory symbol_,
1091         uint256 maxBatchSize_
1092     ) {
1093         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1094         _name = name_;
1095         _symbol = symbol_;
1096         maxBatchSize = maxBatchSize_;
1097     }
1098 
1099     /**
1100      * @dev See {IERC721Enumerable-totalSupply}.
1101      */
1102     function totalSupply() public view override returns (uint256) {
1103         return currentIndex;
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Enumerable-tokenByIndex}.
1108      */
1109     function tokenByIndex(uint256 index) public view override returns (uint256) {
1110         require(index < totalSupply(), "ERC721A: global index out of bounds");
1111         return index;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1116      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1117      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1120         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1121         uint256 numMintedSoFar = totalSupply();
1122         uint256 tokenIdsIdx = 0;
1123         address currOwnershipAddr = address(0);
1124         for (uint256 i = 0; i < numMintedSoFar; i++) {
1125             TokenOwnership memory ownership = _ownerships[i];
1126             if (ownership.addr != address(0)) {
1127                 currOwnershipAddr = ownership.addr;
1128             }
1129             if (currOwnershipAddr == owner) {
1130                 if (tokenIdsIdx == index) {
1131                     return i;
1132                 }
1133                 tokenIdsIdx++;
1134             }
1135         }
1136         revert("ERC721A: unable to get token of owner by index");
1137     }
1138 
1139     /**
1140      * @dev See {IERC165-supportsInterface}.
1141      */
1142     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1143         return
1144             interfaceId == type(IERC721).interfaceId ||
1145             interfaceId == type(IERC721Metadata).interfaceId ||
1146             interfaceId == type(IERC721Enumerable).interfaceId ||
1147             super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-balanceOf}.
1152      */
1153     function balanceOf(address owner) public view override returns (uint256) {
1154         require(owner != address(0), "ERC721A: balance query for the zero address");
1155         return uint256(_addressData[owner].balance);
1156     }
1157 
1158     function _numberMinted(address owner) internal view returns (uint256) {
1159         require(owner != address(0), "ERC721A: number minted query for the zero address");
1160         return uint256(_addressData[owner].numberMinted);
1161     }
1162 
1163     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1164         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1165 
1166         uint256 lowestTokenToCheck;
1167         if (tokenId >= maxBatchSize) {
1168             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1169         }
1170 
1171         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1172             TokenOwnership memory ownership = _ownerships[curr];
1173             if (ownership.addr != address(0)) {
1174                 return ownership;
1175             }
1176         }
1177 
1178         revert("ERC721A: unable to determine the owner of token");
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-ownerOf}.
1183      */
1184     function ownerOf(uint256 tokenId) public view override returns (address) {
1185         return ownershipOf(tokenId).addr;
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Metadata-name}.
1190      */
1191     function name() public view virtual override returns (string memory) {
1192         return _name;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Metadata-symbol}.
1197      */
1198     function symbol() public view virtual override returns (string memory) {
1199         return _symbol;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Metadata-tokenURI}.
1204      */
1205     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1206         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1207 
1208         string memory baseURI = _baseURI();
1209         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1210     }
1211 
1212     /**
1213      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1214      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1215      * by default, can be overriden in child contracts.
1216      */
1217     function _baseURI() internal view virtual returns (string memory) {
1218         return "";
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-approve}.
1223      */
1224     function approve(address to, uint256 tokenId) public override {
1225         address owner = ERC721A.ownerOf(tokenId);
1226         require(to != owner, "ERC721A: approval to current owner");
1227 
1228         require(
1229             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1230             "ERC721A: approve caller is not owner nor approved for all"
1231         );
1232 
1233         _approve(to, tokenId, owner);
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-getApproved}.
1238      */
1239     function getApproved(uint256 tokenId) public view override returns (address) {
1240         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1241 
1242         return _tokenApprovals[tokenId];
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-setApprovalForAll}.
1247      */
1248     function setApprovalForAll(address operator, bool approved) public override {
1249         require(operator != _msgSender(), "ERC721A: approve to caller");
1250 
1251         _operatorApprovals[_msgSender()][operator] = approved;
1252         emit ApprovalForAll(_msgSender(), operator, approved);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-isApprovedForAll}.
1257      */
1258     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1259         return _operatorApprovals[owner][operator];
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-transferFrom}.
1264      */
1265     function transferFrom(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) public override {
1270         _transfer(from, to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-safeTransferFrom}.
1275      */
1276     function safeTransferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) public override {
1281         safeTransferFrom(from, to, tokenId, "");
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-safeTransferFrom}.
1286      */
1287     function safeTransferFrom(
1288         address from,
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) public override {
1293         _transfer(from, to, tokenId);
1294         require(
1295             _checkOnERC721Received(from, to, tokenId, _data),
1296             "ERC721A: transfer to non ERC721Receiver implementer"
1297         );
1298     }
1299 
1300     /**
1301      * @dev Returns whether `tokenId` exists.
1302      *
1303      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1304      *
1305      * Tokens start existing when they are minted (`_mint`),
1306      */
1307     function _exists(uint256 tokenId) internal view returns (bool) {
1308         return tokenId < currentIndex;
1309     }
1310 
1311     function _safeMint(address to, uint256 quantity) internal {
1312         _safeMint(to, quantity, "");
1313     }
1314 
1315     /**
1316      * @dev Mints `quantity` tokens and transfers them to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `to` cannot be the zero address.
1321      * - `quantity` cannot be larger than the max batch size.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _safeMint(
1326         address to,
1327         uint256 quantity,
1328         bytes memory _data
1329     ) internal {
1330         uint256 startTokenId = currentIndex;
1331         require(to != address(0), "ERC721A: mint to the zero address");
1332         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1333         require(!_exists(startTokenId), "ERC721A: token already minted");
1334         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1335 
1336         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1337 
1338         AddressData memory addressData = _addressData[to];
1339         _addressData[to] = AddressData(
1340             addressData.balance + uint128(quantity),
1341             addressData.numberMinted + uint128(quantity)
1342         );
1343         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1344 
1345         uint256 updatedIndex = startTokenId;
1346 
1347         for (uint256 i = 0; i < quantity; i++) {
1348             emit Transfer(address(0), to, updatedIndex);
1349             require(
1350                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1351                 "ERC721A: transfer to non ERC721Receiver implementer"
1352             );
1353             updatedIndex++;
1354         }
1355 
1356         currentIndex = updatedIndex;
1357         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1358     }
1359 
1360     /**
1361      * @dev Transfers `tokenId` from `from` to `to`.
1362      *
1363      * Requirements:
1364      *
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must be owned by `from`.
1367      *
1368      * Emits a {Transfer} event.
1369      */
1370     function _transfer(
1371         address from,
1372         address to,
1373         uint256 tokenId
1374     ) private {
1375         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1376 
1377         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1378             getApproved(tokenId) == _msgSender() ||
1379             isApprovedForAll(prevOwnership.addr, _msgSender()));
1380 
1381         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1382 
1383         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1384         require(to != address(0), "ERC721A: transfer to the zero address");
1385 
1386         _beforeTokenTransfers(from, to, tokenId, 1);
1387 
1388         // Clear approvals from the previous owner
1389         _approve(address(0), tokenId, prevOwnership.addr);
1390 
1391         _addressData[from].balance -= 1;
1392         _addressData[to].balance += 1;
1393         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1394 
1395         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1396         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1397         uint256 nextTokenId = tokenId + 1;
1398         if (_ownerships[nextTokenId].addr == address(0)) {
1399             if (_exists(nextTokenId)) {
1400                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1401             }
1402         }
1403 
1404         emit Transfer(from, to, tokenId);
1405         _afterTokenTransfers(from, to, tokenId, 1);
1406     }
1407 
1408     /**
1409      * @dev Approve `to` to operate on `tokenId`
1410      *
1411      * Emits a {Approval} event.
1412      */
1413     function _approve(
1414         address to,
1415         uint256 tokenId,
1416         address owner
1417     ) private {
1418         _tokenApprovals[tokenId] = to;
1419         emit Approval(owner, to, tokenId);
1420     }
1421 
1422     uint256 public nextOwnerToExplicitlySet = 0;
1423 
1424     /**
1425      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1426      */
1427     function _setOwnersExplicit(uint256 quantity) internal {
1428         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1429         require(quantity > 0, "quantity must be nonzero");
1430         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1431         if (endIndex > currentIndex - 1) {
1432             endIndex = currentIndex - 1;
1433         }
1434         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1435         require(_exists(endIndex), "not enough minted yet for this cleanup");
1436         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1437             if (_ownerships[i].addr == address(0)) {
1438                 TokenOwnership memory ownership = ownershipOf(i);
1439                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1440             }
1441         }
1442         nextOwnerToExplicitlySet = endIndex + 1;
1443     }
1444 
1445     /**
1446      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1447      * The call is not executed if the target address is not a contract.
1448      *
1449      * @param from address representing the previous owner of the given token ID
1450      * @param to target address that will receive the tokens
1451      * @param tokenId uint256 ID of the token to be transferred
1452      * @param _data bytes optional data to send along with the call
1453      * @return bool whether the call correctly returned the expected magic value
1454      */
1455     function _checkOnERC721Received(
1456         address from,
1457         address to,
1458         uint256 tokenId,
1459         bytes memory _data
1460     ) private returns (bool) {
1461         if (to.isContract()) {
1462             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1463                 return retval == IERC721Receiver(to).onERC721Received.selector;
1464             } catch (bytes memory reason) {
1465                 if (reason.length == 0) {
1466                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1467                 } else {
1468                     assembly {
1469                         revert(add(32, reason), mload(reason))
1470                     }
1471                 }
1472             }
1473         } else {
1474             return true;
1475         }
1476     }
1477 
1478     /**
1479      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1480      *
1481      * startTokenId - the first token id to be transferred
1482      * quantity - the amount to be transferred
1483      *
1484      * Calling conditions:
1485      *
1486      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1487      * transferred to `to`.
1488      * - When `from` is zero, `tokenId` will be minted for `to`.
1489      */
1490     function _beforeTokenTransfers(
1491         address from,
1492         address to,
1493         uint256 startTokenId,
1494         uint256 quantity
1495     ) internal virtual {}
1496 
1497     /**
1498      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1499      * minting.
1500      *
1501      * startTokenId - the first token id to be transferred
1502      * quantity - the amount to be transferred
1503      *
1504      * Calling conditions:
1505      *
1506      * - when `from` and `to` are both non-zero.
1507      * - `from` and `to` are never both zero.
1508      */
1509     function _afterTokenTransfers(
1510         address from,
1511         address to,
1512         uint256 startTokenId,
1513         uint256 quantity
1514     ) internal virtual {}
1515 }
1516 
1517 // File: contracts/con2.sol
1518 
1519 
1520 
1521 pragma solidity ^0.8.4;
1522 
1523 
1524 
1525 
1526 
1527 contract NFTits is ERC721A, Ownable, ReentrancyGuard {
1528     using ECDSA for bytes32;
1529     string baseURI = "ipfs://QmZbvgq4RHxLYTsNDB37s7jp1hNdx6jqxPU3q657H27MAs/"; 
1530     string baseExtension = ".json";
1531     uint256 public salePrice = 0.1 ether;
1532     uint256 public presalePrice = 0.07 ether;
1533     uint256 maxSupply = 7777; 
1534     bool public paused = true;
1535     bool public presalePaused = true;
1536     mapping (address => uint256) public whitelistMintedAmount;
1537     uint256 public presaleMaxMint = 10; 
1538     uint256 public saleMintAmount = 50;
1539     address public signerAddress = 0xBA3Daf4d95A0B5A31eD0278CfeceDCe54EB23C16;
1540     constructor() ERC721A(
1541       "The NFTits Club", 
1542       "TIT",
1543        saleMintAmount){    
1544        }
1545 
1546     function matchAddressSigner(address account, bytes calldata signature) internal view returns (bool){
1547       return ECDSA.recover(keccak256(abi.encodePacked(account)).toEthSignedMessageHash(), signature) == signerAddress;
1548       }
1549 
1550     function presaleMint(uint256 quantity,  bytes calldata signature) external payable nonReentrant{
1551       require(matchAddressSigner(msg.sender, signature), "not on whitelist");
1552       require(whitelistMintedAmount[msg.sender] + quantity <= presaleMaxMint);
1553       require(msg.value >= quantity * presalePrice);
1554       require(!presalePaused);
1555       whitelistMintedAmount[msg.sender] += quantity;
1556       _safeMint(msg.sender, quantity);
1557       } 
1558 
1559     function mint(address _to, uint quantity) external payable {
1560       uint256 supply = totalSupply();
1561       require (quantity <= saleMintAmount);
1562       require(supply + quantity <= maxSupply);      
1563       if (msg.sender != owner()){
1564         require (!paused);
1565         require(msg.value >= quantity * salePrice);
1566       }
1567       _safeMint(_to, quantity);
1568       }
1569  
1570     function _baseURI() internal view override returns (string memory){
1571       return baseURI; 
1572       }
1573 
1574     function changeWhitelistAddress(address _newWhitelistSigner)public onlyOwner{
1575       signerAddress = _newWhitelistSigner;
1576     }
1577  
1578     // only owner 
1579     function togglePaused() public onlyOwner{
1580       paused = !paused;
1581       }
1582     
1583     function togglePresalePaused() public onlyOwner{
1584       presalePaused = !presalePaused;
1585       }
1586 
1587     function setPrice(uint256 _newPrice) public onlyOwner(){
1588       salePrice = _newPrice;
1589     }
1590 
1591     function setPresalePrice(uint256 _newPrice) public onlyOwner(){
1592       presalePrice = _newPrice;
1593     }
1594 
1595     function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner(){
1596       saleMintAmount = _newMaxMintAmount;
1597     }
1598   
1599     function setMaxPresaleMint(uint256 _newMaxMintAmount) public onlyOwner(){
1600       presaleMaxMint = _newMaxMintAmount;
1601     }
1602     
1603     function updateMaxSupply (uint256 _newMax) public onlyOwner(){
1604       maxSupply = _newMax;
1605     }
1606 
1607     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1608       baseURI = _newBaseURI;
1609     }
1610  
1611     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1612       baseExtension = _newBaseExtension;
1613     }
1614 
1615     function withdraw() public payable onlyOwner {
1616       require(payable(msg.sender).send(address(this).balance));
1617       }
1618   }