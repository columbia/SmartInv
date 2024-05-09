1 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
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
504 // File: whitesandsPresaleMinter.sol
505 
506 
507 pragma solidity ^0.8.7;
508 
509 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
510 
511 
512 
513 
514 
515 
516 interface IWhiteSandsNFT {
517     function mintPresale(uint16 count,uint256 nonce,bytes calldata signature) external payable;
518     function totalSupply() external view returns (uint256);
519     function safeTransferFrom(address,address,uint256) external;
520 }
521 
522 contract WhiteSandsParcelPassPresaleMinter is Ownable, IERC721Receiver, ReentrancyGuard {
523     using ECDSA for bytes32;
524     using Strings for uint256;
525     bool public mintActive = false;
526 
527     mapping (address => uint) private presale; 
528     address private signer;
529     IWhiteSandsNFT public whiteSandsParcelPass;
530     uint constant cost = 0.5 ether;
531 
532     constructor(IWhiteSandsNFT _whiteSandsParcelPass) {
533         whiteSandsParcelPass = _whiteSandsParcelPass;
534     }
535 
536     // ======== Admin functions ========
537 
538     function setmintActive(bool _active) external onlyOwner {
539         mintActive = _active;
540     }
541 
542 
543     function setSigner(address _signer) external onlyOwner {
544         signer = _signer;
545     }
546 
547     function withdraw() external onlyOwner {
548         uint balance = address(this).balance;
549         payable(msg.sender).transfer(balance);
550     }
551 
552 
553     // ======== Public functions ========
554     // Allows 1 mint per wallet only
555     function mintPresale(uint16 count, uint256 maxTimestamp, bytes calldata _signature) external payable nonReentrant {
556         count;
557         require(msg.sender == tx.origin, "Only EOA");
558         require(mintActive, "Mint is not active");
559         require(block.timestamp <= maxTimestamp, "Signature expired");
560         require(presale[msg.sender] == 0, "Already participated in the pre-sale");
561         require(msg.value >= cost, "Insufficient funds");
562         require(_verifySignerSignature(keccak256(abi.encode(address(this), msg.sender, maxTimestamp)), _signature), "Invalid signature");
563         presale[msg.sender] = 1;
564         whiteSandsParcelPass.mintPresale{value: cost}(1, 1, _signature);
565         uint currTokenId = whiteSandsParcelPass.totalSupply();
566         whiteSandsParcelPass.safeTransferFrom(address(this), msg.sender, currTokenId);
567         if (msg.value > cost) {
568             uint256 refund = msg.value - cost;
569             // payable(msg.sender).transfer(refund);
570             (bool status,) = payable(msg.sender).call{value : refund}("");
571             require(status, "Failed to refund additional value");
572         }
573 
574     }
575 
576     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external override returns (bytes4) {
577         operator;from;tokenId;data;
578         return this.onERC721Received.selector;
579     }
580 
581     // ======== Internal functions ========
582 
583     function _verifySignerSignature(bytes32 hash, bytes calldata signature) internal view returns(bool) {
584         return hash.toEthSignedMessageHash().recover(signature) == signer;
585     }
586 }