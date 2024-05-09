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
74 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
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
191         bytes32 s;
192         uint8 v;
193         assembly {
194             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
195             v := add(shr(255, vs), 27)
196         }
197         return tryRecover(hash, v, r, s);
198     }
199 
200     /**
201      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
202      *
203      * _Available since v4.2._
204      */
205     function recover(
206         bytes32 hash,
207         bytes32 r,
208         bytes32 vs
209     ) internal pure returns (address) {
210         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
211         _throwError(error);
212         return recovered;
213     }
214 
215     /**
216      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
217      * `r` and `s` signature fields separately.
218      *
219      * _Available since v4.3._
220      */
221     function tryRecover(
222         bytes32 hash,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) internal pure returns (address, RecoverError) {
227         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
228         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
229         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
230         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
231         //
232         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
233         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
234         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
235         // these malleable signatures as well.
236         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
237             return (address(0), RecoverError.InvalidSignatureS);
238         }
239         if (v != 27 && v != 28) {
240             return (address(0), RecoverError.InvalidSignatureV);
241         }
242 
243         // If the signature is valid (and not malleable), return the signer address
244         address signer = ecrecover(hash, v, r, s);
245         if (signer == address(0)) {
246             return (address(0), RecoverError.InvalidSignature);
247         }
248 
249         return (signer, RecoverError.NoError);
250     }
251 
252     /**
253      * @dev Overload of {ECDSA-recover} that receives the `v`,
254      * `r` and `s` signature fields separately.
255      */
256     function recover(
257         bytes32 hash,
258         uint8 v,
259         bytes32 r,
260         bytes32 s
261     ) internal pure returns (address) {
262         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
263         _throwError(error);
264         return recovered;
265     }
266 
267     /**
268      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
269      * produces hash corresponding to the one signed with the
270      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
271      * JSON-RPC method as part of EIP-191.
272      *
273      * See {recover}.
274      */
275     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
276         // 32 is the length in bytes of hash,
277         // enforced by the type signature above
278         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
279     }
280 
281     /**
282      * @dev Returns an Ethereum Signed Message, created from `s`. This
283      * produces hash corresponding to the one signed with the
284      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
285      * JSON-RPC method as part of EIP-191.
286      *
287      * See {recover}.
288      */
289     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
290         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
291     }
292 
293     /**
294      * @dev Returns an Ethereum Signed Typed Data, created from a
295      * `domainSeparator` and a `structHash`. This produces hash corresponding
296      * to the one signed with the
297      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
298      * JSON-RPC method as part of EIP-712.
299      *
300      * See {recover}.
301      */
302     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/Context.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 abstract contract Context {
325     function _msgSender() internal view virtual returns (address) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes calldata) {
330         return msg.data;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/access/Ownable.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view virtual returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(owner() == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 
412 // File: contracts/Distributor.sol
413 
414 
415 pragma solidity ^0.8.0;
416 
417 
418 
419 interface IDinoEggs {
420   function withdraw(address _address, uint256 _amount) external;
421 }
422 
423 contract Distributor is Ownable {
424   IDinoEggs private dinoEggsContract;
425 
426   address private _verifier = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
427 
428   mapping(address => uint256) public claimedEggs;
429 
430   constructor(address _dinoEggsContract) {
431     dinoEggsContract = IDinoEggs(_dinoEggsContract);
432   }
433 
434   function _recoverWallet(
435     address _wallet,
436     uint256 _amount,
437     bytes memory _signature
438   ) internal pure returns (address) {
439     return
440       ECDSA.recover(
441         ECDSA.toEthSignedMessageHash(
442           keccak256(abi.encodePacked(_wallet, _amount))
443         ),
444         _signature
445       );
446   }
447 
448   function claim(uint256 _amount, bytes calldata _signature) external {
449     require(tx.origin == msg.sender, "Cannot be called from another contract");
450     require(claimedEggs[_msgSender()] < _amount, "Invalid eggs amount");
451 
452     address signer = _recoverWallet(_msgSender(), _amount, _signature);
453 
454     require(signer == _verifier, "Unverified transaction");
455 
456     uint256 claimAmount = _amount - claimedEggs[_msgSender()];
457 
458     claimedEggs[_msgSender()] = _amount;
459     dinoEggsContract.withdraw(_msgSender(), claimAmount);
460   }
461 
462   function setVerifier(address _newVerifier) public onlyOwner {
463     _verifier = _newVerifier;
464   }
465 }