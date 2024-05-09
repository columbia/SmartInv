1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 
164 /**
165  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
166  *
167  * These functions can be used to verify that a message was signed by the holder
168  * of the private keys of a given address.
169  */
170 library ECDSA {
171     enum RecoverError {
172         NoError,
173         InvalidSignature,
174         InvalidSignatureLength,
175         InvalidSignatureS,
176         InvalidSignatureV
177     }
178 
179     function _throwError(RecoverError error) private pure {
180         if (error == RecoverError.NoError) {
181             return; // no error: do nothing
182         } else if (error == RecoverError.InvalidSignature) {
183             revert("ECDSA: invalid signature");
184         } else if (error == RecoverError.InvalidSignatureLength) {
185             revert("ECDSA: invalid signature length");
186         } else if (error == RecoverError.InvalidSignatureS) {
187             revert("ECDSA: invalid signature 's' value");
188         } else if (error == RecoverError.InvalidSignatureV) {
189             revert("ECDSA: invalid signature 'v' value");
190         }
191     }
192 
193     /**
194      * @dev Returns the address that signed a hashed message (`hash`) with
195      * `signature` or error string. This address can then be used for verification purposes.
196      *
197      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
198      * this function rejects them by requiring the `s` value to be in the lower
199      * half order, and the `v` value to be either 27 or 28.
200      *
201      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
202      * verification to be secure: it is possible to craft signatures that
203      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
204      * this is by receiving a hash of the original message (which may otherwise
205      * be too long), and then calling {toEthSignedMessageHash} on it.
206      *
207      * Documentation for signature generation:
208      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
209      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
210      *
211      * _Available since v4.3._
212      */
213     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
214         // Check the signature length
215         // - case 65: r,s,v signature (standard)
216         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
217         if (signature.length == 65) {
218             bytes32 r;
219             bytes32 s;
220             uint8 v;
221             // ecrecover takes the signature parameters, and the only way to get them
222             // currently is to use assembly.
223             assembly {
224                 r := mload(add(signature, 0x20))
225                 s := mload(add(signature, 0x40))
226                 v := byte(0, mload(add(signature, 0x60)))
227             }
228             return tryRecover(hash, v, r, s);
229         } else if (signature.length == 64) {
230             bytes32 r;
231             bytes32 vs;
232             // ecrecover takes the signature parameters, and the only way to get them
233             // currently is to use assembly.
234             assembly {
235                 r := mload(add(signature, 0x20))
236                 vs := mload(add(signature, 0x40))
237             }
238             return tryRecover(hash, r, vs);
239         } else {
240             return (address(0), RecoverError.InvalidSignatureLength);
241         }
242     }
243 
244     /**
245      * @dev Returns the address that signed a hashed message (`hash`) with
246      * `signature`. This address can then be used for verification purposes.
247      *
248      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
249      * this function rejects them by requiring the `s` value to be in the lower
250      * half order, and the `v` value to be either 27 or 28.
251      *
252      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
253      * verification to be secure: it is possible to craft signatures that
254      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
255      * this is by receiving a hash of the original message (which may otherwise
256      * be too long), and then calling {toEthSignedMessageHash} on it.
257      */
258     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
259         (address recovered, RecoverError error) = tryRecover(hash, signature);
260         _throwError(error);
261         return recovered;
262     }
263 
264     /**
265      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
266      *
267      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
268      *
269      * _Available since v4.3._
270      */
271     function tryRecover(
272         bytes32 hash,
273         bytes32 r,
274         bytes32 vs
275     ) internal pure returns (address, RecoverError) {
276         bytes32 s;
277         uint8 v;
278         assembly {
279             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
280             v := add(shr(255, vs), 27)
281         }
282         return tryRecover(hash, v, r, s);
283     }
284 
285     /**
286      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
287      *
288      * _Available since v4.2._
289      */
290     function recover(
291         bytes32 hash,
292         bytes32 r,
293         bytes32 vs
294     ) internal pure returns (address) {
295         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
296         _throwError(error);
297         return recovered;
298     }
299 
300     /**
301      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
302      * `r` and `s` signature fields separately.
303      *
304      * _Available since v4.3._
305      */
306     function tryRecover(
307         bytes32 hash,
308         uint8 v,
309         bytes32 r,
310         bytes32 s
311     ) internal pure returns (address, RecoverError) {
312         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
313         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
314         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
315         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
316         //
317         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
318         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
319         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
320         // these malleable signatures as well.
321         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
322             return (address(0), RecoverError.InvalidSignatureS);
323         }
324         if (v != 27 && v != 28) {
325             return (address(0), RecoverError.InvalidSignatureV);
326         }
327 
328         // If the signature is valid (and not malleable), return the signer address
329         address signer = ecrecover(hash, v, r, s);
330         if (signer == address(0)) {
331             return (address(0), RecoverError.InvalidSignature);
332         }
333 
334         return (signer, RecoverError.NoError);
335     }
336 
337     /**
338      * @dev Overload of {ECDSA-recover} that receives the `v`,
339      * `r` and `s` signature fields separately.
340      */
341     function recover(
342         bytes32 hash,
343         uint8 v,
344         bytes32 r,
345         bytes32 s
346     ) internal pure returns (address) {
347         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
348         _throwError(error);
349         return recovered;
350     }
351 
352     /**
353      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
354      * produces hash corresponding to the one signed with the
355      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
356      * JSON-RPC method as part of EIP-191.
357      *
358      * See {recover}.
359      */
360     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
361         // 32 is the length in bytes of hash,
362         // enforced by the type signature above
363         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
364     }
365 
366     /**
367      * @dev Returns an Ethereum Signed Message, created from `s`. This
368      * produces hash corresponding to the one signed with the
369      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
370      * JSON-RPC method as part of EIP-191.
371      *
372      * See {recover}.
373      */
374     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
375         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
376     }
377 
378     /**
379      * @dev Returns an Ethereum Signed Typed Data, created from a
380      * `domainSeparator` and a `structHash`. This produces hash corresponding
381      * to the one signed with the
382      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
383      * JSON-RPC method as part of EIP-712.
384      *
385      * See {recover}.
386      */
387     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
388         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/draft-EIP712.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
402  *
403  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
404  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
405  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
406  *
407  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
408  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
409  * ({_hashTypedDataV4}).
410  *
411  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
412  * the chain id to protect against replay attacks on an eventual fork of the chain.
413  *
414  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
415  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
416  *
417  * _Available since v3.4._
418  */
419 abstract contract EIP712 {
420     /* solhint-disable var-name-mixedcase */
421     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
422     // invalidate the cached domain separator if the chain id changes.
423     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
424     uint256 private immutable _CACHED_CHAIN_ID;
425     address private immutable _CACHED_THIS;
426 
427     bytes32 private immutable _HASHED_NAME;
428     bytes32 private immutable _HASHED_VERSION;
429     bytes32 private immutable _TYPE_HASH;
430 
431     /* solhint-enable var-name-mixedcase */
432 
433     /**
434      * @dev Initializes the domain separator and parameter caches.
435      *
436      * The meaning of `name` and `version` is specified in
437      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
438      *
439      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
440      * - `version`: the current major version of the signing domain.
441      *
442      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
443      * contract upgrade].
444      */
445     constructor(string memory name, string memory version) {
446         bytes32 hashedName = keccak256(bytes(name));
447         bytes32 hashedVersion = keccak256(bytes(version));
448         bytes32 typeHash = keccak256(
449             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
450         );
451         _HASHED_NAME = hashedName;
452         _HASHED_VERSION = hashedVersion;
453         _CACHED_CHAIN_ID = block.chainid;
454         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
455         _CACHED_THIS = address(this);
456         _TYPE_HASH = typeHash;
457     }
458 
459     /**
460      * @dev Returns the domain separator for the current chain.
461      */
462     function _domainSeparatorV4() internal view returns (bytes32) {
463         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
464             return _CACHED_DOMAIN_SEPARATOR;
465         } else {
466             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
467         }
468     }
469 
470     function _buildDomainSeparator(
471         bytes32 typeHash,
472         bytes32 nameHash,
473         bytes32 versionHash
474     ) private view returns (bytes32) {
475         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
476     }
477 
478     /**
479      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
480      * function returns the hash of the fully encoded EIP712 message for this domain.
481      *
482      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
483      *
484      * ```solidity
485      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
486      *     keccak256("Mail(address to,string contents)"),
487      *     mailTo,
488      *     keccak256(bytes(mailContents))
489      * )));
490      * address signer = ECDSA.recover(digest, signature);
491      * ```
492      */
493     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
494         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
495     }
496 }
497 
498 // File: contracts/ClaimNAO.sol
499 
500 
501 pragma solidity ^0.8.4;
502 
503 
504 
505 
506 contract ClaimNAO is EIP712("Claim NAO", "v1.0.0") {
507     address public immutable signer;
508     address public immutable token;
509 
510     mapping(address => bool) private isClaimedList;
511 
512     bytes32 public constant TICKET_HASH_TYPE =
513         keccak256("Ticket(address recipient,uint256 amount,uint256 nonce,uint256 deadline)");
514 
515     constructor(address _signer, address _token) {
516         signer = _signer;
517         token = _token;
518     }
519 
520     function isClaimed(address account) public view returns (bool) {
521         return isClaimedList[account];
522     }
523 
524     function claim(
525         bytes memory signature,
526         uint256 amount,
527         uint256 nonce,
528         uint256 deadline
529     ) external {
530         bytes32 digest = keccak256(
531             abi.encodePacked(
532                 "\x19Ethereum Signed Message:\n32",
533                 _hashTypedDataV4(keccak256(abi.encode(TICKET_HASH_TYPE, msg.sender, amount, nonce, deadline)))
534             )
535         );
536         address recoverAddress = ECDSA.recover(digest, signature);
537 
538         require(isClaimedList[msg.sender] == false, "ERROR: Already Claimed");
539         require(recoverAddress == signer, "ERROR: Invalid Signature");
540         require(recoverAddress != address(0), "ERROR: Invalid Signature (ECDSA)");
541         require(block.timestamp < deadline, "ERROR: Signed Transaction Expired");
542 
543         isClaimedList[msg.sender] = true;
544         require(IERC20(token).transfer(msg.sender, amount), "ERROR: Transfer Failed.");
545     }
546 }