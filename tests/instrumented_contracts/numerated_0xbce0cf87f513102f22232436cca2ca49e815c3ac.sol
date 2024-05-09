1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
104 
105 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
106 
107 /**
108  * @dev Contract module which allows children to implement an emergency stop
109  * mechanism that can be triggered by an authorized account.
110  *
111  * This module is used through inheritance. It will make available the
112  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
113  * the functions of your contract. Note that they will not be pausable by
114  * simply including this module, only once the modifiers are put in place.
115  */
116 abstract contract Pausable is Context {
117     /**
118      * @dev Emitted when the pause is triggered by `account`.
119      */
120     event Paused(address account);
121 
122     /**
123      * @dev Emitted when the pause is lifted by `account`.
124      */
125     event Unpaused(address account);
126 
127     bool private _paused;
128 
129     /**
130      * @dev Initializes the contract in unpaused state.
131      */
132     constructor() {
133         _paused = false;
134     }
135 
136     /**
137      * @dev Returns true if the contract is paused, and false otherwise.
138      */
139     function paused() public view virtual returns (bool) {
140         return _paused;
141     }
142 
143     /**
144      * @dev Modifier to make a function callable only when the contract is not paused.
145      *
146      * Requirements:
147      *
148      * - The contract must not be paused.
149      */
150     modifier whenNotPaused() {
151         require(!paused(), "Pausable: paused");
152         _;
153     }
154 
155     /**
156      * @dev Modifier to make a function callable only when the contract is paused.
157      *
158      * Requirements:
159      *
160      * - The contract must be paused.
161      */
162     modifier whenPaused() {
163         require(paused(), "Pausable: not paused");
164         _;
165     }
166 
167     /**
168      * @dev Triggers stopped state.
169      *
170      * Requirements:
171      *
172      * - The contract must not be paused.
173      */
174     function _pause() internal virtual whenNotPaused {
175         _paused = true;
176         emit Paused(_msgSender());
177     }
178 
179     /**
180      * @dev Returns to normal state.
181      *
182      * Requirements:
183      *
184      * - The contract must be paused.
185      */
186     function _unpause() internal virtual whenPaused {
187         _paused = false;
188         emit Unpaused(_msgSender());
189     }
190 }
191 
192 
193 // File @openzeppelin/contracts/utils/math/Math.sol@v4.5.0
194 
195 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
196 
197 /**
198  * @dev Standard math utilities missing in the Solidity language.
199  */
200 library Math {
201     /**
202      * @dev Returns the largest of two numbers.
203      */
204     function max(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a >= b ? a : b;
206     }
207 
208     /**
209      * @dev Returns the smallest of two numbers.
210      */
211     function min(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a < b ? a : b;
213     }
214 
215     /**
216      * @dev Returns the average of two numbers. The result is rounded towards
217      * zero.
218      */
219     function average(uint256 a, uint256 b) internal pure returns (uint256) {
220         // (a + b) / 2 can overflow.
221         return (a & b) + (a ^ b) / 2;
222     }
223 
224     /**
225      * @dev Returns the ceiling of the division of two numbers.
226      *
227      * This differs from standard division with `/` in that it rounds up instead
228      * of rounding down.
229      */
230     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
231         // (a + b - 1) / b can overflow on addition, so we distribute.
232         return a / b + (a % b == 0 ? 0 : 1);
233     }
234 }
235 
236 
237 // File @openzeppelin/contracts/utils/Arrays.sol@v4.5.0
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
240 
241 /**
242  * @dev Collection of functions related to array types.
243  */
244 library Arrays {
245     /**
246      * @dev Searches a sorted `array` and returns the first index that contains
247      * a value greater or equal to `element`. If no such index exists (i.e. all
248      * values in the array are strictly less than `element`), the array length is
249      * returned. Time complexity O(log n).
250      *
251      * `array` is expected to be sorted in ascending order, and to contain no
252      * repeated elements.
253      */
254     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
255         if (array.length == 0) {
256             return 0;
257         }
258 
259         uint256 low = 0;
260         uint256 high = array.length;
261 
262         while (low < high) {
263             uint256 mid = Math.average(low, high);
264 
265             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
266             // because Math.average rounds down (it does integer division with truncation).
267             if (array[mid] > element) {
268                 high = mid;
269             } else {
270                 low = mid + 1;
271             }
272         }
273 
274         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
275         if (low > 0 && array[low - 1] == element) {
276             return low - 1;
277         } else {
278             return low;
279         }
280     }
281 }
282 
283 
284 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
285 
286 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
287 
288 /**
289  * @title Counters
290  * @author Matt Condon (@shrugs)
291  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
292  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
293  *
294  * Include with `using Counters for Counters.Counter;`
295  */
296 library Counters {
297     struct Counter {
298         // This variable should never be directly accessed by users of the library: interactions must be restricted to
299         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
300         // this feature: see https://github.com/ethereum/solidity/issues/4637
301         uint256 _value; // default: 0
302     }
303 
304     function current(Counter storage counter) internal view returns (uint256) {
305         return counter._value;
306     }
307 
308     function increment(Counter storage counter) internal {
309         unchecked {
310             counter._value += 1;
311         }
312     }
313 
314     function decrement(Counter storage counter) internal {
315         uint256 value = counter._value;
316         require(value > 0, "Counter: decrement overflow");
317         unchecked {
318             counter._value = value - 1;
319         }
320     }
321 
322     function reset(Counter storage counter) internal {
323         counter._value = 0;
324     }
325 }
326 
327 
328 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
329 
330 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
331 
332 /**
333  * @dev String operations.
334  */
335 library Strings {
336     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
337 
338     /**
339      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
340      */
341     function toString(uint256 value) internal pure returns (string memory) {
342         // Inspired by OraclizeAPI's implementation - MIT licence
343         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
344 
345         if (value == 0) {
346             return "0";
347         }
348         uint256 temp = value;
349         uint256 digits;
350         while (temp != 0) {
351             digits++;
352             temp /= 10;
353         }
354         bytes memory buffer = new bytes(digits);
355         while (value != 0) {
356             digits -= 1;
357             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
358             value /= 10;
359         }
360         return string(buffer);
361     }
362 
363     /**
364      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
365      */
366     function toHexString(uint256 value) internal pure returns (string memory) {
367         if (value == 0) {
368             return "0x00";
369         }
370         uint256 temp = value;
371         uint256 length = 0;
372         while (temp != 0) {
373             length++;
374             temp >>= 8;
375         }
376         return toHexString(value, length);
377     }
378 
379     /**
380      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
381      */
382     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
383         bytes memory buffer = new bytes(2 * length + 2);
384         buffer[0] = "0";
385         buffer[1] = "x";
386         for (uint256 i = 2 * length + 1; i > 1; --i) {
387             buffer[i] = _HEX_SYMBOLS[value & 0xf];
388             value >>= 4;
389         }
390         require(value == 0, "Strings: hex length insufficient");
391         return string(buffer);
392     }
393 }
394 
395 
396 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
397 
398 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
399 
400 /**
401  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
402  *
403  * These functions can be used to verify that a message was signed by the holder
404  * of the private keys of a given address.
405  */
406 library ECDSA {
407     enum RecoverError {
408         NoError,
409         InvalidSignature,
410         InvalidSignatureLength,
411         InvalidSignatureS,
412         InvalidSignatureV
413     }
414 
415     function _throwError(RecoverError error) private pure {
416         if (error == RecoverError.NoError) {
417             return; // no error: do nothing
418         } else if (error == RecoverError.InvalidSignature) {
419             revert("ECDSA: invalid signature");
420         } else if (error == RecoverError.InvalidSignatureLength) {
421             revert("ECDSA: invalid signature length");
422         } else if (error == RecoverError.InvalidSignatureS) {
423             revert("ECDSA: invalid signature 's' value");
424         } else if (error == RecoverError.InvalidSignatureV) {
425             revert("ECDSA: invalid signature 'v' value");
426         }
427     }
428 
429     /**
430      * @dev Returns the address that signed a hashed message (`hash`) with
431      * `signature` or error string. This address can then be used for verification purposes.
432      *
433      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
434      * this function rejects them by requiring the `s` value to be in the lower
435      * half order, and the `v` value to be either 27 or 28.
436      *
437      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
438      * verification to be secure: it is possible to craft signatures that
439      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
440      * this is by receiving a hash of the original message (which may otherwise
441      * be too long), and then calling {toEthSignedMessageHash} on it.
442      *
443      * Documentation for signature generation:
444      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
445      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
446      *
447      * _Available since v4.3._
448      */
449     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
450         // Check the signature length
451         // - case 65: r,s,v signature (standard)
452         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
453         if (signature.length == 65) {
454             bytes32 r;
455             bytes32 s;
456             uint8 v;
457             // ecrecover takes the signature parameters, and the only way to get them
458             // currently is to use assembly.
459             assembly {
460                 r := mload(add(signature, 0x20))
461                 s := mload(add(signature, 0x40))
462                 v := byte(0, mload(add(signature, 0x60)))
463             }
464             return tryRecover(hash, v, r, s);
465         } else if (signature.length == 64) {
466             bytes32 r;
467             bytes32 vs;
468             // ecrecover takes the signature parameters, and the only way to get them
469             // currently is to use assembly.
470             assembly {
471                 r := mload(add(signature, 0x20))
472                 vs := mload(add(signature, 0x40))
473             }
474             return tryRecover(hash, r, vs);
475         } else {
476             return (address(0), RecoverError.InvalidSignatureLength);
477         }
478     }
479 
480     /**
481      * @dev Returns the address that signed a hashed message (`hash`) with
482      * `signature`. This address can then be used for verification purposes.
483      *
484      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
485      * this function rejects them by requiring the `s` value to be in the lower
486      * half order, and the `v` value to be either 27 or 28.
487      *
488      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
489      * verification to be secure: it is possible to craft signatures that
490      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
491      * this is by receiving a hash of the original message (which may otherwise
492      * be too long), and then calling {toEthSignedMessageHash} on it.
493      */
494     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
495         (address recovered, RecoverError error) = tryRecover(hash, signature);
496         _throwError(error);
497         return recovered;
498     }
499 
500     /**
501      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
502      *
503      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
504      *
505      * _Available since v4.3._
506      */
507     function tryRecover(
508         bytes32 hash,
509         bytes32 r,
510         bytes32 vs
511     ) internal pure returns (address, RecoverError) {
512         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
513         uint8 v = uint8((uint256(vs) >> 255) + 27);
514         return tryRecover(hash, v, r, s);
515     }
516 
517     /**
518      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
519      *
520      * _Available since v4.2._
521      */
522     function recover(
523         bytes32 hash,
524         bytes32 r,
525         bytes32 vs
526     ) internal pure returns (address) {
527         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
528         _throwError(error);
529         return recovered;
530     }
531 
532     /**
533      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
534      * `r` and `s` signature fields separately.
535      *
536      * _Available since v4.3._
537      */
538     function tryRecover(
539         bytes32 hash,
540         uint8 v,
541         bytes32 r,
542         bytes32 s
543     ) internal pure returns (address, RecoverError) {
544         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
545         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
546         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
547         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
548         //
549         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
550         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
551         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
552         // these malleable signatures as well.
553         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
554             return (address(0), RecoverError.InvalidSignatureS);
555         }
556         if (v != 27 && v != 28) {
557             return (address(0), RecoverError.InvalidSignatureV);
558         }
559 
560         // If the signature is valid (and not malleable), return the signer address
561         address signer = ecrecover(hash, v, r, s);
562         if (signer == address(0)) {
563             return (address(0), RecoverError.InvalidSignature);
564         }
565 
566         return (signer, RecoverError.NoError);
567     }
568 
569     /**
570      * @dev Overload of {ECDSA-recover} that receives the `v`,
571      * `r` and `s` signature fields separately.
572      */
573     function recover(
574         bytes32 hash,
575         uint8 v,
576         bytes32 r,
577         bytes32 s
578     ) internal pure returns (address) {
579         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
580         _throwError(error);
581         return recovered;
582     }
583 
584     /**
585      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
586      * produces hash corresponding to the one signed with the
587      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
588      * JSON-RPC method as part of EIP-191.
589      *
590      * See {recover}.
591      */
592     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
593         // 32 is the length in bytes of hash,
594         // enforced by the type signature above
595         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
596     }
597 
598     /**
599      * @dev Returns an Ethereum Signed Message, created from `s`. This
600      * produces hash corresponding to the one signed with the
601      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
602      * JSON-RPC method as part of EIP-191.
603      *
604      * See {recover}.
605      */
606     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
607         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
608     }
609 
610     /**
611      * @dev Returns an Ethereum Signed Typed Data, created from a
612      * `domainSeparator` and a `structHash`. This produces hash corresponding
613      * to the one signed with the
614      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
615      * JSON-RPC method as part of EIP-712.
616      *
617      * See {recover}.
618      */
619     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
620         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
621     }
622 }
623 
624 
625 // File contracts/tokens/ERC20SnapshotSolmate.sol
626 
627 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Snapshot.sol)
628 
629 
630 
631 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
632 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
633 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
634 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
635 abstract contract ERC20 {
636     /*///////////////////////////////////////////////////////////////
637                                   EVENTS
638     //////////////////////////////////////////////////////////////*/
639 
640     event Transfer(address indexed from, address indexed to, uint256 amount);
641 
642     event Approval(
643         address indexed owner,
644         address indexed spender,
645         uint256 amount
646     );
647 
648     /*///////////////////////////////////////////////////////////////
649                              METADATA STORAGE
650     //////////////////////////////////////////////////////////////*/
651 
652     string public name;
653 
654     string public symbol;
655 
656     uint8 public immutable decimals;
657 
658     /*///////////////////////////////////////////////////////////////
659                               ERC20 STORAGE
660     //////////////////////////////////////////////////////////////*/
661 
662     uint256 public totalSupply;
663 
664     mapping(address => uint256) public balanceOf;
665 
666     mapping(address => mapping(address => uint256)) public allowance;
667 
668     /*///////////////////////////////////////////////////////////////
669                              EIP-2612 STORAGE
670     //////////////////////////////////////////////////////////////*/
671 
672     uint256 internal immutable INITIAL_CHAIN_ID;
673 
674     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
675 
676     mapping(address => uint256) public nonces;
677 
678     /*///////////////////////////////////////////////////////////////
679                                CONSTRUCTOR
680     //////////////////////////////////////////////////////////////*/
681 
682     constructor(
683         string memory _name,
684         string memory _symbol,
685         uint8 _decimals
686     ) {
687         name = _name;
688         symbol = _symbol;
689         decimals = _decimals;
690 
691         INITIAL_CHAIN_ID = block.chainid;
692         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
693     }
694 
695     /*///////////////////////////////////////////////////////////////
696                               ERC20 LOGIC
697     //////////////////////////////////////////////////////////////*/
698 
699     function approve(address spender, uint256 amount)
700         public
701         virtual
702         returns (bool)
703     {
704         allowance[msg.sender][spender] = amount;
705 
706         emit Approval(msg.sender, spender, amount);
707 
708         return true;
709     }
710 
711     function _approve(
712         address owner,
713         address spender,
714         uint256 amount
715     ) internal {
716         allowance[owner][spender] = amount;
717 
718         emit Approval(owner, spender, amount);
719     }
720 
721     function transfer(address to, uint256 amount)
722         public
723         virtual
724         returns (bool)
725     {
726         _beforeTokenTransfer(msg.sender, to, amount);
727 
728         balanceOf[msg.sender] -= amount;
729 
730         // Cannot overflow because the sum of all user
731         // balances can't exceed the max uint256 value.
732         unchecked {
733             balanceOf[to] += amount;
734         }
735 
736         emit Transfer(msg.sender, to, amount);
737 
738         return true;
739     }
740 
741     function transferFrom(
742         address from,
743         address to,
744         uint256 amount
745     ) public virtual returns (bool) {
746         _beforeTokenTransfer(from, to, amount);
747 
748         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
749 
750         if (allowed != type(uint256).max)
751             allowance[from][msg.sender] = allowed - amount;
752 
753         balanceOf[from] -= amount;
754 
755         // Cannot overflow because the sum of all user
756         // balances can't exceed the max uint256 value.
757         unchecked {
758             balanceOf[to] += amount;
759         }
760 
761         emit Transfer(from, to, amount);
762 
763         return true;
764     }
765 
766     /*///////////////////////////////////////////////////////////////
767                               EIP-2612 LOGIC
768     //////////////////////////////////////////////////////////////*/
769 
770     function permit(
771         address owner,
772         address spender,
773         uint256 value,
774         uint256 deadline,
775         uint8 v,
776         bytes32 r,
777         bytes32 s
778     ) public virtual {
779         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
780 
781         // Unchecked because the only math done is incrementing
782         // the owner's nonce which cannot realistically overflow.
783         unchecked {
784             address recoveredAddress = ECDSA.recover(
785                 keccak256(
786                     abi.encodePacked(
787                         "\x19\x01",
788                         DOMAIN_SEPARATOR(),
789                         keccak256(
790                             abi.encode(
791                                 keccak256(
792                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
793                                 ),
794                                 owner,
795                                 spender,
796                                 value,
797                                 nonces[owner]++,
798                                 deadline
799                             )
800                         )
801                     )
802                 ),
803                 v,
804                 r,
805                 s
806             );
807 
808             require(
809                 recoveredAddress != address(0) && recoveredAddress == owner,
810                 "INVALID_SIGNER"
811             );
812 
813             allowance[recoveredAddress][spender] = value;
814         }
815 
816         emit Approval(owner, spender, value);
817     }
818 
819     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
820         return
821             block.chainid == INITIAL_CHAIN_ID
822                 ? INITIAL_DOMAIN_SEPARATOR
823                 : computeDomainSeparator();
824     }
825 
826     function computeDomainSeparator() internal view virtual returns (bytes32) {
827         return
828             keccak256(
829                 abi.encode(
830                     keccak256(
831                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
832                     ),
833                     keccak256(bytes(name)),
834                     keccak256("1"),
835                     block.chainid,
836                     address(this)
837                 )
838             );
839     }
840 
841     /*///////////////////////////////////////////////////////////////
842                        INTERNAL MINT/BURN LOGIC
843     //////////////////////////////////////////////////////////////*/
844 
845     function _mint(address to, uint256 amount) internal virtual {
846         _beforeTokenTransfer(address(0), to, amount);
847 
848         totalSupply += amount;
849 
850         // Cannot overflow because the sum of all user
851         // balances can't exceed the max uint256 value.
852         unchecked {
853             balanceOf[to] += amount;
854         }
855 
856         emit Transfer(address(0), to, amount);
857     }
858 
859     function _burn(address from, uint256 amount) internal virtual {
860         _beforeTokenTransfer(from, address(0), amount);
861 
862         balanceOf[from] -= amount;
863 
864         // Cannot underflow because a user's balance
865         // will never be larger than the total supply.
866         unchecked {
867             totalSupply -= amount;
868         }
869 
870         emit Transfer(from, address(0), amount);
871     }
872 
873     /**
874      * @dev Hook that is called before any transfer of tokens. This includes
875      * minting and burning.
876      *
877      * Calling conditions:
878      *
879      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
880      * will be transferred to `to`.
881      * - when `from` is zero, `amount` tokens will be minted for `to`.
882      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
883      * - `from` and `to` are never both zero.
884      *
885      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
886      */
887     function _beforeTokenTransfer(
888         address from,
889         address to,
890         uint256 amount
891     ) internal virtual {}
892 }
893 
894 /**
895  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
896  * total supply at the time are recorded for later access.
897  *
898  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
899  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
900  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
901  * used to create an efficient ERC20 forking mechanism.
902  *
903  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
904  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
905  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
906  * and the account address.
907  *
908  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
909  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
910  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
911  *
912  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
913  * alternative consider {ERC20Votes}.
914  *
915  * ==== Gas Costs
916  *
917  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
918  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
919  * smaller since identical balances in subsequent snapshots are stored as a single entry.
920  *
921  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
922  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
923  * transfers will have normal cost until the next snapshot, and so on.
924  */
925 
926 contract ERC20SnapshotSolmate is ERC20 {
927     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
928     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
929 
930     using Arrays for uint256[];
931     using Counters for Counters.Counter;
932 
933     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
934     // Snapshot struct, but that would impede usage of functions that work on an array.
935     struct Snapshots {
936         uint256[] ids;
937         uint256[] values;
938     }
939 
940     mapping(address => Snapshots) private _accountBalanceSnapshots;
941     Snapshots private _totalSupplySnapshots;
942 
943     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
944     Counters.Counter private _currentSnapshotId;
945 
946     /**
947      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
948      */
949     event Snapshot(uint256 id);
950 
951     constructor(
952         string memory _name,
953         string memory _symbol,
954         uint8 _decimals
955     ) ERC20(_name, _symbol, _decimals) {}
956 
957     /**
958      * @dev Creates a new snapshot and returns its snapshot id.
959      *
960      * Emits a {Snapshot} event that contains the same id.
961      *
962      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
963      * set of accounts, for example using {AccessControl}, or it may be open to the public.
964      *
965      * [WARNING]
966      * ====
967      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
968      * you must consider that it can potentially be used by attackers in two ways.
969      *
970      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
971      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
972      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
973      * section above.
974      *
975      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
976      * ====
977      */
978     function _snapshot() internal virtual returns (uint256) {
979         _currentSnapshotId.increment();
980 
981         uint256 currentId = _getCurrentSnapshotId();
982         emit Snapshot(currentId);
983         return currentId;
984     }
985 
986     /**
987      * @dev Get the current snapshotId
988      */
989     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
990         return _currentSnapshotId.current();
991     }
992 
993     /**
994      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
995      */
996     function balanceOfAt(address account, uint256 snapshotId)
997         public
998         view
999         virtual
1000         returns (uint256)
1001     {
1002         (bool snapshotted, uint256 value) = _valueAt(
1003             snapshotId,
1004             _accountBalanceSnapshots[account]
1005         );
1006 
1007         return snapshotted ? value : balanceOf[account];
1008     }
1009 
1010     /**
1011      * @dev Retrieves the total supply at the time `snapshotId` was created.
1012      */
1013     function totalSupplyAt(uint256 snapshotId)
1014         public
1015         view
1016         virtual
1017         returns (uint256)
1018     {
1019         (bool snapshotted, uint256 value) = _valueAt(
1020             snapshotId,
1021             _totalSupplySnapshots
1022         );
1023 
1024         return snapshotted ? value : totalSupply;
1025     }
1026 
1027     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1028     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1029     function _beforeTokenTransfer(
1030         address from,
1031         address to,
1032         uint256 amount
1033     ) internal virtual override {
1034         super._beforeTokenTransfer(from, to, amount);
1035 
1036         if (from == address(0)) {
1037             // mint
1038             _updateAccountSnapshot(to);
1039             _updateTotalSupplySnapshot();
1040         } else if (to == address(0)) {
1041             // burn
1042             _updateAccountSnapshot(from);
1043             _updateTotalSupplySnapshot();
1044         } else {
1045             // transfer
1046             _updateAccountSnapshot(from);
1047             _updateAccountSnapshot(to);
1048         }
1049     }
1050 
1051     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1052         private
1053         view
1054         returns (bool, uint256)
1055     {
1056         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1057         require(
1058             snapshotId <= _getCurrentSnapshotId(),
1059             "ERC20Snapshot: nonexistent id"
1060         );
1061 
1062         // When a valid snapshot is queried, there are three possibilities:
1063         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1064         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1065         //  to this id is the current one.
1066         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1067         //  requested id, and its value is the one to return.
1068         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1069         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1070         //  larger than the requested one.
1071         //
1072         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1073         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1074         // exactly this.
1075 
1076         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1077 
1078         if (index == snapshots.ids.length) {
1079             return (false, 0);
1080         } else {
1081             return (true, snapshots.values[index]);
1082         }
1083     }
1084 
1085     function _updateAccountSnapshot(address account) private {
1086         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf[account]);
1087     }
1088 
1089     function _updateTotalSupplySnapshot() private {
1090         _updateSnapshot(_totalSupplySnapshots, totalSupply);
1091     }
1092 
1093     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue)
1094         private
1095     {
1096         uint256 currentId = _getCurrentSnapshotId();
1097         if (_lastSnapshotId(snapshots.ids) < currentId) {
1098             snapshots.ids.push(currentId);
1099             snapshots.values.push(currentValue);
1100         }
1101     }
1102 
1103     function _lastSnapshotId(uint256[] storage ids)
1104         private
1105         view
1106         returns (uint256)
1107     {
1108         uint256 idsLen = ids.length;
1109 
1110         if (idsLen == 0) {
1111             return 0;
1112         } else {
1113             return ids[idsLen - 1];
1114         }
1115     }
1116 }
1117 
1118 
1119 // File contracts/PxCvx.sol
1120 // SPDX-License-Identifier: MIT
1121 pragma solidity 0.8.12;
1122 
1123 
1124 
1125 contract PxCvx is ERC20SnapshotSolmate("Pirex CVX", "pxCVX", 18), Ownable {
1126     /**
1127         @notice Epoch details
1128                 Reward/snapshotRewards/futuresRewards indexes are associated with 1 reward
1129         @param  snapshotId               uint256    Snapshot id
1130         @param  rewards                  bytes32[]  Rewards
1131         @param  snapshotRewards          uint256[]  Snapshot reward amounts
1132         @param  futuresRewards           uint256[]  Futures reward amounts
1133         @param  redeemedSnapshotRewards  mapping    Redeemed snapshot rewards
1134      */
1135     struct Epoch {
1136         uint256 snapshotId;
1137         bytes32[] rewards;
1138         uint256[] snapshotRewards;
1139         uint256[] futuresRewards;
1140         mapping(address => uint256) redeemedSnapshotRewards;
1141     }
1142 
1143     // Address of currently assigned operator
1144     address public operator;
1145 
1146     // Epochs mapped to epoch details
1147     mapping(uint256 => Epoch) private epochs;
1148 
1149     event SetOperator(address operator);
1150     event UpdateEpochFuturesRewards(
1151         uint256 indexed epoch,
1152         uint256[] futuresRewards
1153     );
1154 
1155     error NotAuthorized();
1156     error NoOperator();
1157     error Paused();
1158     error ZeroAddress();
1159     error ZeroAmount();
1160     error InvalidEpoch();
1161     error InvalidFuturesRewards();
1162     error MismatchedFuturesRewards();
1163 
1164     modifier onlyOperator() {
1165         if (msg.sender != operator) revert NotAuthorized();
1166         _;
1167     }
1168 
1169     modifier onlyOperatorOrNotPaused() {
1170         address _operator = operator;
1171 
1172         // Ensure an operator is set
1173         if (_operator == address(0)) revert NoOperator();
1174 
1175         // This contract shares the same pause state as the operator
1176         if (msg.sender != _operator && Pausable(_operator).paused())
1177             revert Paused();
1178         _;
1179     }
1180 
1181     /** 
1182         @notice Set a new operator address
1183         @param  _operator  address  New operator address    
1184      */
1185     function setOperator(address _operator) external onlyOwner {
1186         if (_operator == address(0)) revert ZeroAddress();
1187 
1188         emit SetOperator(_operator);
1189 
1190         // If it's the first operator, also set up 1st epoch with snapshot id 1
1191         // and prevent reward claims until subsequent epochs
1192         if (operator == address(0)) {
1193             uint256 currentEpoch = getCurrentEpoch();
1194             epochs[currentEpoch].snapshotId = _snapshot();
1195         }
1196 
1197         operator = _operator;
1198     }
1199 
1200     /** 
1201         @notice Return the current snapshotId
1202         @return uint256  Current snapshot id
1203      */
1204     function getCurrentSnapshotId() external view returns (uint256) {
1205         return _getCurrentSnapshotId();
1206     }
1207 
1208     /**
1209         @notice Get current epoch
1210         @return uint256  Current epoch
1211      */
1212     function getCurrentEpoch() public view returns (uint256) {
1213         return (block.timestamp / 1209600) * 1209600;
1214     }
1215 
1216     /**
1217         @notice Get epoch
1218         @param  epoch            uint256    Epoch
1219         @return snapshotId       uint256    Snapshot id
1220         @return rewards          address[]  Reward tokens
1221         @return snapshotRewards  uint256[]  Snapshot reward amounts
1222         @return futuresRewards   uint256[]  Futures reward amounts
1223      */
1224     function getEpoch(uint256 epoch)
1225         external
1226         view
1227         returns (
1228             uint256 snapshotId,
1229             bytes32[] memory rewards,
1230             uint256[] memory snapshotRewards,
1231             uint256[] memory futuresRewards
1232         )
1233     {
1234         Epoch storage e = epochs[epoch];
1235 
1236         return (e.snapshotId, e.rewards, e.snapshotRewards, e.futuresRewards);
1237     }
1238 
1239     /**
1240         @notice Get redeemed snapshot rewards bitmap
1241         @param  account  address   Account
1242         @param  epoch    uint256   Epoch
1243         @return uint256  Redeemed snapshot bitmap
1244      */
1245     function getEpochRedeemedSnapshotRewards(address account, uint256 epoch)
1246         external
1247         view
1248         returns (uint256)
1249     {
1250         return epochs[epoch].redeemedSnapshotRewards[account];
1251     }
1252 
1253     /**
1254         @notice Add new epoch reward metadata
1255         @param  epoch           uint256  Epoch
1256         @param  token           address  Token address
1257         @param  snapshotReward  uint256  Snapshot reward amount
1258         @param  futuresReward   uint256  Futures reward amount
1259      */
1260     function addEpochRewardMetadata(
1261         uint256 epoch,
1262         bytes32 token,
1263         uint256 snapshotReward,
1264         uint256 futuresReward
1265     ) external onlyOperator {
1266         Epoch storage e = epochs[epoch];
1267 
1268         e.rewards.push(token);
1269         e.snapshotRewards.push(snapshotReward);
1270         e.futuresRewards.push(futuresReward);
1271     }
1272 
1273     /**
1274         @notice Set redeemed snapshot rewards bitmap
1275         @param  account   address  Account
1276         @param  epoch     uint256  Epoch
1277         @param  redeemed  uint256  Redeemed bitmap
1278      */
1279     function setEpochRedeemedSnapshotRewards(
1280         address account,
1281         uint256 epoch,
1282         uint256 redeemed
1283     ) external onlyOperator {
1284         epochs[epoch].redeemedSnapshotRewards[account] = redeemed;
1285     }
1286 
1287     /**
1288         @notice Update epoch futures rewards to reflect amounts remaining after redemptions
1289         @param  epoch           uint256    Epoch
1290         @param  futuresRewards  uint256[]  Futures rewards
1291      */
1292     function updateEpochFuturesRewards(
1293         uint256 epoch,
1294         uint256[] memory futuresRewards
1295     ) external onlyOperator {
1296         if (epoch == 0) revert InvalidEpoch();
1297 
1298         uint256 fLen = epochs[epoch].futuresRewards.length;
1299 
1300         if (fLen == 0) revert InvalidEpoch();
1301         if (futuresRewards.length == 0) revert InvalidFuturesRewards();
1302         if (futuresRewards.length != fLen) revert MismatchedFuturesRewards();
1303 
1304         epochs[epoch].futuresRewards = futuresRewards;
1305 
1306         emit UpdateEpochFuturesRewards(epoch, futuresRewards);
1307     }
1308 
1309     /** 
1310         @notice Mint the specified amount of tokens to the specified account
1311         @param  account  address  Receiver of the tokens
1312         @param  amount   uint256  Amount to be minted
1313      */
1314     function mint(address account, uint256 amount) external onlyOperator {
1315         if (account == address(0)) revert ZeroAddress();
1316         if (amount == 0) revert ZeroAmount();
1317 
1318         _mint(account, amount);
1319     }
1320 
1321     /** 
1322         @notice Burn the specified amount of tokens from the specified account
1323         @param  account  address  Owner of the tokens
1324         @param  amount   uint256  Amount to be burned
1325      */
1326     function burn(address account, uint256 amount) external onlyOperator {
1327         if (account == address(0)) revert ZeroAddress();
1328         if (amount == 0) revert ZeroAmount();
1329 
1330         _burn(account, amount);
1331     }
1332 
1333     /** 
1334         @notice Approve allowances by operator with specified accounts and amount
1335         @param  from    address  Owner of the tokens
1336         @param  to      address  Account to be approved
1337         @param  amount  uint256  Amount to be approved
1338      */
1339     function operatorApprove(
1340         address from,
1341         address to,
1342         uint256 amount
1343     ) external onlyOperator {
1344         if (from == address(0)) revert ZeroAddress();
1345         if (to == address(0)) revert ZeroAddress();
1346         if (amount == 0) revert ZeroAmount();
1347 
1348         _approve(from, to, amount);
1349     }
1350 
1351     /**
1352         @notice Snapshot token balances for the current epoch
1353      */
1354     function takeEpochSnapshot() external onlyOperatorOrNotPaused {
1355         uint256 currentEpoch = getCurrentEpoch();
1356 
1357         // If snapshot has not been set for current epoch, take snapshot
1358         if (epochs[currentEpoch].snapshotId == 0) {
1359             epochs[currentEpoch].snapshotId = _snapshot();
1360         }
1361     }
1362 }