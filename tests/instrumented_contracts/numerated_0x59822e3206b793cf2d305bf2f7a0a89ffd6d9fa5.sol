1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Strings.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 /**
185  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
186  *
187  * These functions can be used to verify that a message was signed by the holder
188  * of the private keys of a given address.
189  */
190 library ECDSA {
191     enum RecoverError {
192         NoError,
193         InvalidSignature,
194         InvalidSignatureLength,
195         InvalidSignatureS,
196         InvalidSignatureV
197     }
198 
199     function _throwError(RecoverError error) private pure {
200         if (error == RecoverError.NoError) {
201             return; // no error: do nothing
202         } else if (error == RecoverError.InvalidSignature) {
203             revert("ECDSA: invalid signature");
204         } else if (error == RecoverError.InvalidSignatureLength) {
205             revert("ECDSA: invalid signature length");
206         } else if (error == RecoverError.InvalidSignatureS) {
207             revert("ECDSA: invalid signature 's' value");
208         } else if (error == RecoverError.InvalidSignatureV) {
209             revert("ECDSA: invalid signature 'v' value");
210         }
211     }
212 
213     /**
214      * @dev Returns the address that signed a hashed message (`hash`) with
215      * `signature` or error string. This address can then be used for verification purposes.
216      *
217      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
218      * this function rejects them by requiring the `s` value to be in the lower
219      * half order, and the `v` value to be either 27 or 28.
220      *
221      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
222      * verification to be secure: it is possible to craft signatures that
223      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
224      * this is by receiving a hash of the original message (which may otherwise
225      * be too long), and then calling {toEthSignedMessageHash} on it.
226      *
227      * Documentation for signature generation:
228      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
229      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
230      *
231      * _Available since v4.3._
232      */
233     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
234         // Check the signature length
235         // - case 65: r,s,v signature (standard)
236         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
237         if (signature.length == 65) {
238             bytes32 r;
239             bytes32 s;
240             uint8 v;
241             // ecrecover takes the signature parameters, and the only way to get them
242             // currently is to use assembly.
243             assembly {
244                 r := mload(add(signature, 0x20))
245                 s := mload(add(signature, 0x40))
246                 v := byte(0, mload(add(signature, 0x60)))
247             }
248             return tryRecover(hash, v, r, s);
249         } else if (signature.length == 64) {
250             bytes32 r;
251             bytes32 vs;
252             // ecrecover takes the signature parameters, and the only way to get them
253             // currently is to use assembly.
254             assembly {
255                 r := mload(add(signature, 0x20))
256                 vs := mload(add(signature, 0x40))
257             }
258             return tryRecover(hash, r, vs);
259         } else {
260             return (address(0), RecoverError.InvalidSignatureLength);
261         }
262     }
263 
264     /**
265      * @dev Returns the address that signed a hashed message (`hash`) with
266      * `signature`. This address can then be used for verification purposes.
267      *
268      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
269      * this function rejects them by requiring the `s` value to be in the lower
270      * half order, and the `v` value to be either 27 or 28.
271      *
272      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
273      * verification to be secure: it is possible to craft signatures that
274      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
275      * this is by receiving a hash of the original message (which may otherwise
276      * be too long), and then calling {toEthSignedMessageHash} on it.
277      */
278     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
279         (address recovered, RecoverError error) = tryRecover(hash, signature);
280         _throwError(error);
281         return recovered;
282     }
283 
284     /**
285      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
286      *
287      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
288      *
289      * _Available since v4.3._
290      */
291     function tryRecover(
292         bytes32 hash,
293         bytes32 r,
294         bytes32 vs
295     ) internal pure returns (address, RecoverError) {
296         bytes32 s;
297         uint8 v;
298         assembly {
299             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
300             v := add(shr(255, vs), 27)
301         }
302         return tryRecover(hash, v, r, s);
303     }
304 
305     /**
306      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
307      *
308      * _Available since v4.2._
309      */
310     function recover(
311         bytes32 hash,
312         bytes32 r,
313         bytes32 vs
314     ) internal pure returns (address) {
315         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
316         _throwError(error);
317         return recovered;
318     }
319 
320     /**
321      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
322      * `r` and `s` signature fields separately.
323      *
324      * _Available since v4.3._
325      */
326     function tryRecover(
327         bytes32 hash,
328         uint8 v,
329         bytes32 r,
330         bytes32 s
331     ) internal pure returns (address, RecoverError) {
332         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
333         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
334         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
335         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
336         //
337         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
338         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
339         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
340         // these malleable signatures as well.
341         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
342             return (address(0), RecoverError.InvalidSignatureS);
343         }
344         if (v != 27 && v != 28) {
345             return (address(0), RecoverError.InvalidSignatureV);
346         }
347 
348         // If the signature is valid (and not malleable), return the signer address
349         address signer = ecrecover(hash, v, r, s);
350         if (signer == address(0)) {
351             return (address(0), RecoverError.InvalidSignature);
352         }
353 
354         return (signer, RecoverError.NoError);
355     }
356 
357     /**
358      * @dev Overload of {ECDSA-recover} that receives the `v`,
359      * `r` and `s` signature fields separately.
360      */
361     function recover(
362         bytes32 hash,
363         uint8 v,
364         bytes32 r,
365         bytes32 s
366     ) internal pure returns (address) {
367         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
368         _throwError(error);
369         return recovered;
370     }
371 
372     /**
373      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
374      * produces hash corresponding to the one signed with the
375      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
376      * JSON-RPC method as part of EIP-191.
377      *
378      * See {recover}.
379      */
380     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
381         // 32 is the length in bytes of hash,
382         // enforced by the type signature above
383         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
384     }
385 
386     /**
387      * @dev Returns an Ethereum Signed Message, created from `s`. This
388      * produces hash corresponding to the one signed with the
389      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
390      * JSON-RPC method as part of EIP-191.
391      *
392      * See {recover}.
393      */
394     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
395         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
396     }
397 
398     /**
399      * @dev Returns an Ethereum Signed Typed Data, created from a
400      * `domainSeparator` and a `structHash`. This produces hash corresponding
401      * to the one signed with the
402      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
403      * JSON-RPC method as part of EIP-712.
404      *
405      * See {recover}.
406      */
407     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
408         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
409     }
410 }
411 
412 // File: In Progress/Gambling Apes Claiming.sol
413 
414 
415 pragma solidity ^0.8.7;
416 
417 
418 
419 
420 interface GAInterface {
421     function balanceOf(address) external view returns(uint);
422 }
423 
424 contract GapesClaiming is Ownable {
425     using ECDSA for bytes32;
426 
427     string constant ERROR_INVALID_DATA = "Invalid data provided";
428     string constant ERROR_INVALID_DATA_LENGTH = "Invalid data length";
429     string constant ERROR_INVALID_SIGNATURE = "Invalid signature provided";
430     string constant ERROR_NOT_HOLDER = "You must own atleast one Gambling Ape to claim!";
431 
432     modifier directOnly {
433         require(msg.sender == tx.origin, "Only direct transactions are allowed");
434         _;
435     }
436 
437     modifier notLocked {
438         require(!_locked, "You may not claim right now!");
439         _;
440     }
441 
442     constructor(address signer_, GAInterface GA_) {
443         _signer = signer_; // 0x288367E1E520A02e5E5d70906a7b0c6f5fD9EF90
444         _GA = GA_;         // 0x90cA8a3eb2574F937F514749ce619fDCCa187d45
445         _b1 = 0x0408CFcde646bbADa944BF4312e6a2EF61ce8e7b;
446         _b2 = 0xA61932ae8589664E9aaB312886775a617775E940;
447     }
448 
449     GAInterface immutable _GA;
450     address immutable _b1;
451     address immutable _b2;
452 
453     bool _locked;
454     address _signer;
455     mapping(address => uint) public addressToLastMonthClaimed;
456 
457     modifier verifyInputData(address to, uint[] calldata months, uint amount, bytes calldata signature) {
458         require(months.length > 0, ERROR_INVALID_DATA_LENGTH);
459         for(uint i = 1; i < months.length; i++)
460             require(months[i - 1] < months[i], ERROR_INVALID_DATA); /* Verify order smallest > largest **no duplicates**, gaps allowed eg:[1,2,4,7,9] */
461         
462         require(months[0] > addressToLastMonthClaimed[to], ERROR_INVALID_DATA); /* Smallest value will be first, must be larger than the previously saved largest value */
463         addressToLastMonthClaimed[to] = months[months.length - 1]; /* Largest value will be last, save it to be used in the above check in the future */
464 
465         require(keccak256(abi.encode(to, months, amount)).toEthSignedMessageHash().recover(signature) == _signer, ERROR_INVALID_SIGNATURE); /* Verify the backend signature */
466 
467         require(_GA.balanceOf(to) > 0, ERROR_NOT_HOLDER); /* Users must own at least 1 Gambling Ape to be able to claim */
468         _;
469     }
470 
471     // External/Public
472 
473     function claim(uint[] calldata months, uint amount, bytes calldata signature) external directOnly notLocked verifyInputData(msg.sender, months, amount, signature) {
474         payable(msg.sender).transfer(amount);
475     }
476 
477     // Owner Only
478 
479     function flipLock() external {
480         require(msg.sender == owner() || msg.sender == _b1 || msg.sender == _b2);
481         _locked = !_locked;
482     }
483 
484     function changeSigner(address signer_) external onlyOwner {
485         _signer = signer_;
486     }
487 
488     function withdraw(uint amount) external onlyOwner {
489         payable(msg.sender).transfer(amount);
490     }
491 
492     receive() payable external {}
493 }