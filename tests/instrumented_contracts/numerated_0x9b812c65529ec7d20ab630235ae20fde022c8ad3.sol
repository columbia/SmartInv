1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 library SafeMath {
16     function tryAdd(uint256 a, uint256 b)
17         internal
18         pure
19         returns (bool, uint256)
20     {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     function trySub(uint256 a, uint256 b)
29         internal
30         pure
31         returns (bool, uint256)
32     {
33         unchecked {
34             if (b > a) return (false, 0);
35             return (true, a - b);
36         }
37     }
38 
39     function tryMul(uint256 a, uint256 b)
40         internal
41         pure
42         returns (bool, uint256)
43     {
44         unchecked {
45             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46             // benefit is lost if 'b' is also tested.
47             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48             if (a == 0) return (true, 0);
49             uint256 c = a * b;
50             if (c / a != b) return (false, 0);
51             return (true, c);
52         }
53     }
54 
55     function tryDiv(uint256 a, uint256 b)
56         internal
57         pure
58         returns (bool, uint256)
59     {
60         unchecked {
61             if (b == 0) return (false, 0);
62             return (true, a / b);
63         }
64     }
65 
66     function tryMod(uint256 a, uint256 b)
67         internal
68         pure
69         returns (bool, uint256)
70     {
71         unchecked {
72             if (b == 0) return (false, 0);
73             return (true, a % b);
74         }
75     }
76 
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a + b;
79     }
80 
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a - b;
83     }
84 
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a * b;
87     }
88 
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a / b;
91     }
92 
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a % b;
95     }
96 
97     function sub(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         unchecked {
103             require(b <= a, errorMessage);
104             return a - b;
105         }
106     }
107 
108     function div(
109         uint256 a,
110         uint256 b,
111         string memory errorMessage
112     ) internal pure returns (uint256) {
113         unchecked {
114             require(b > 0, errorMessage);
115             return a / b;
116         }
117     }
118 
119     function mod(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         unchecked {
125             require(b > 0, errorMessage);
126             return a % b;
127         }
128     }
129 }
130 
131 interface IERC20 {
132     function totalSupply() external view returns (uint256);
133 
134     function balanceOf(address account) external view returns (uint256);
135 
136     function transfer(address recipient, uint256 amount)
137         external
138         returns (bool);
139 
140     function allowance(address owner, address spender)
141         external
142         view
143         returns (uint256);
144 
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) external returns (bool);
152 
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     event Approval(
156         address indexed owner,
157         address indexed spender,
158         uint256 value
159     );
160 }
161 
162 interface IERC20Metadata is IERC20 {
163     function name() external view returns (string memory);
164 
165     function symbol() external view returns (string memory);
166 
167     function decimals() external view returns (uint8);
168 }
169 
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping(address => uint256) private _balances;
172 
173     mapping(address => mapping(address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     constructor(string memory name_, string memory symbol_) {
181         _name = name_;
182         _symbol = symbol_;
183     }
184 
185     function name() public view virtual override returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public view virtual override returns (uint8) {
194         return 18;
195     }
196 
197     function totalSupply() public view virtual override returns (uint256) {
198         return _totalSupply;
199     }
200 
201     function balanceOf(address account)
202         public
203         view
204         virtual
205         override
206         returns (uint256)
207     {
208         return _balances[account];
209     }
210 
211     function transfer(address recipient, uint256 amount)
212         public
213         virtual
214         override
215         returns (bool)
216     {
217         _transfer(_msgSender(), recipient, amount);
218         return true;
219     }
220 
221     function allowance(address owner, address spender)
222         public
223         view
224         virtual
225         override
226         returns (uint256)
227     {
228         return _allowances[owner][spender];
229     }
230 
231     function approve(address spender, uint256 amount)
232         public
233         virtual
234         override
235         returns (bool)
236     {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(
242         address sender,
243         address recipient,
244         uint256 amount
245     ) public virtual override returns (bool) {
246         _transfer(sender, recipient, amount);
247 
248         uint256 currentAllowance = _allowances[sender][_msgSender()];
249         require(
250             currentAllowance >= amount,
251             "ERC20: transfer amount exceeds allowance"
252         );
253         unchecked {
254             _approve(sender, _msgSender(), currentAllowance - amount);
255         }
256 
257         return true;
258     }
259 
260     function increaseAllowance(address spender, uint256 addedValue)
261         public
262         virtual
263         returns (bool)
264     {
265         _approve(
266             _msgSender(),
267             spender,
268             _allowances[_msgSender()][spender] + addedValue
269         );
270         return true;
271     }
272 
273     function decreaseAllowance(address spender, uint256 subtractedValue)
274         public
275         virtual
276         returns (bool)
277     {
278         uint256 currentAllowance = _allowances[_msgSender()][spender];
279         require(
280             currentAllowance >= subtractedValue,
281             "ERC20: decreased allowance below zero"
282         );
283         unchecked {
284             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
285         }
286 
287         return true;
288     }
289 
290     function _transfer(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) internal virtual {
295         require(sender != address(0), "ERC20: transfer from the zero address");
296         require(recipient != address(0), "ERC20: transfer to the zero address");
297 
298         _beforeTokenTransfer(sender, recipient, amount);
299 
300         uint256 senderBalance = _balances[sender];
301         require(
302             senderBalance >= amount,
303             "ERC20: transfer amount exceeds balance"
304         );
305         unchecked {
306             _balances[sender] = senderBalance - amount;
307         }
308         _balances[recipient] += amount;
309 
310         emit Transfer(sender, recipient, amount);
311 
312         _afterTokenTransfer(sender, recipient, amount);
313     }
314 
315     function _mint(address account, uint256 amount) internal virtual {
316         require(account != address(0), "ERC20: mint to the zero address");
317 
318         _beforeTokenTransfer(address(0), account, amount);
319 
320         _totalSupply += amount;
321         _balances[account] += amount;
322         emit Transfer(address(0), account, amount);
323 
324         _afterTokenTransfer(address(0), account, amount);
325     }
326 
327     function _burn(address account, uint256 amount) internal virtual {
328         require(account != address(0), "ERC20: burn from the zero address");
329 
330         _beforeTokenTransfer(account, address(0), amount);
331 
332         uint256 accountBalance = _balances[account];
333         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
334         unchecked {
335             _balances[account] = accountBalance - amount;
336         }
337         _totalSupply -= amount;
338 
339         emit Transfer(account, address(0), amount);
340 
341         _afterTokenTransfer(account, address(0), amount);
342     }
343 
344     function _approve(
345         address owner,
346         address spender,
347         uint256 amount
348     ) internal virtual {
349         require(owner != address(0), "ERC20: approve from the zero address");
350         require(spender != address(0), "ERC20: approve to the zero address");
351 
352         _allowances[owner][spender] = amount;
353         emit Approval(owner, spender, amount);
354     }
355 
356     function _beforeTokenTransfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal virtual {}
361 
362     function _afterTokenTransfer(
363         address from,
364         address to,
365         uint256 amount
366     ) internal virtual {}
367 }
368 
369 library Strings {
370     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
371 
372     /**
373      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
374      */
375     function toString(uint256 value) internal pure returns (string memory) {
376         // Inspired by OraclizeAPI's implementation - MIT licence
377         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
378 
379         if (value == 0) {
380             return "0";
381         }
382         uint256 temp = value;
383         uint256 digits;
384         while (temp != 0) {
385             digits++;
386             temp /= 10;
387         }
388         bytes memory buffer = new bytes(digits);
389         while (value != 0) {
390             digits -= 1;
391             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
392             value /= 10;
393         }
394         return string(buffer);
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
399      */
400     function toHexString(uint256 value) internal pure returns (string memory) {
401         if (value == 0) {
402             return "0x00";
403         }
404         uint256 temp = value;
405         uint256 length = 0;
406         while (temp != 0) {
407             length++;
408             temp >>= 8;
409         }
410         return toHexString(value, length);
411     }
412 
413     /**
414      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
415      */
416     function toHexString(uint256 value, uint256 length)
417         internal
418         pure
419         returns (string memory)
420     {
421         bytes memory buffer = new bytes(2 * length + 2);
422         buffer[0] = "0";
423         buffer[1] = "x";
424         for (uint256 i = 2 * length + 1; i > 1; --i) {
425             buffer[i] = _HEX_SYMBOLS[value & 0xf];
426             value >>= 4;
427         }
428         require(value == 0, "Strings: hex length insufficient");
429         return string(buffer);
430     }
431 }
432 
433 library ECDSA {
434     enum RecoverError {
435         NoError,
436         InvalidSignature,
437         InvalidSignatureLength,
438         InvalidSignatureS,
439         InvalidSignatureV
440     }
441 
442     function _throwError(RecoverError error) private pure {
443         if (error == RecoverError.NoError) {
444             return; // no error: do nothing
445         } else if (error == RecoverError.InvalidSignature) {
446             revert("ECDSA: invalid signature");
447         } else if (error == RecoverError.InvalidSignatureLength) {
448             revert("ECDSA: invalid signature length");
449         } else if (error == RecoverError.InvalidSignatureS) {
450             revert("ECDSA: invalid signature 's' value");
451         } else if (error == RecoverError.InvalidSignatureV) {
452             revert("ECDSA: invalid signature 'v' value");
453         }
454     }
455 
456     /**
457      * @dev Returns the address that signed a hashed message (`hash`) with
458      * `signature` or error string. This address can then be used for verification purposes.
459      *
460      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
461      * this function rejects them by requiring the `s` value to be in the lower
462      * half order, and the `v` value to be either 27 or 28.
463      *
464      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
465      * verification to be secure: it is possible to craft signatures that
466      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
467      * this is by receiving a hash of the original message (which may otherwise
468      * be too long), and then calling {toEthSignedMessageHash} on it.
469      *
470      * Documentation for signature generation:
471      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
472      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
473      *
474      * _Available since v4.3._
475      */
476     function tryRecover(bytes32 hash, bytes memory signature)
477         internal
478         pure
479         returns (address, RecoverError)
480     {
481         // Check the signature length
482         // - case 65: r,s,v signature (standard)
483         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
484         if (signature.length == 65) {
485             bytes32 r;
486             bytes32 s;
487             uint8 v;
488             // ecrecover takes the signature parameters, and the only way to get them
489             // currently is to use assembly.
490             assembly {
491                 r := mload(add(signature, 0x20))
492                 s := mload(add(signature, 0x40))
493                 v := byte(0, mload(add(signature, 0x60)))
494             }
495             return tryRecover(hash, v, r, s);
496         } else if (signature.length == 64) {
497             bytes32 r;
498             bytes32 vs;
499             // ecrecover takes the signature parameters, and the only way to get them
500             // currently is to use assembly.
501             assembly {
502                 r := mload(add(signature, 0x20))
503                 vs := mload(add(signature, 0x40))
504             }
505             return tryRecover(hash, r, vs);
506         } else {
507             return (address(0), RecoverError.InvalidSignatureLength);
508         }
509     }
510 
511     /**
512      * @dev Returns the address that signed a hashed message (`hash`) with
513      * `signature`. This address can then be used for verification purposes.
514      *
515      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
516      * this function rejects them by requiring the `s` value to be in the lower
517      * half order, and the `v` value to be either 27 or 28.
518      *
519      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
520      * verification to be secure: it is possible to craft signatures that
521      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
522      * this is by receiving a hash of the original message (which may otherwise
523      * be too long), and then calling {toEthSignedMessageHash} on it.
524      */
525     function recover(bytes32 hash, bytes memory signature)
526         internal
527         pure
528         returns (address)
529     {
530         (address recovered, RecoverError error) = tryRecover(hash, signature);
531         _throwError(error);
532         return recovered;
533     }
534 
535     /**
536      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
537      *
538      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
539      *
540      * _Available since v4.3._
541      */
542     function tryRecover(
543         bytes32 hash,
544         bytes32 r,
545         bytes32 vs
546     ) internal pure returns (address, RecoverError) {
547         bytes32 s;
548         uint8 v;
549         assembly {
550             s := and(
551                 vs,
552                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
553             )
554             v := add(shr(255, vs), 27)
555         }
556         return tryRecover(hash, v, r, s);
557     }
558 
559     /**
560      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
561      *
562      * _Available since v4.2._
563      */
564     function recover(
565         bytes32 hash,
566         bytes32 r,
567         bytes32 vs
568     ) internal pure returns (address) {
569         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
570         _throwError(error);
571         return recovered;
572     }
573 
574     /**
575      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
576      * `r` and `s` signature fields separately.
577      *
578      * _Available since v4.3._
579      */
580     function tryRecover(
581         bytes32 hash,
582         uint8 v,
583         bytes32 r,
584         bytes32 s
585     ) internal pure returns (address, RecoverError) {
586         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
587         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
588         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
589         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
590         //
591         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
592         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
593         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
594         // these malleable signatures as well.
595         if (
596             uint256(s) >
597             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
598         ) {
599             return (address(0), RecoverError.InvalidSignatureS);
600         }
601         if (v != 27 && v != 28) {
602             return (address(0), RecoverError.InvalidSignatureV);
603         }
604 
605         // If the signature is valid (and not malleable), return the signer address
606         address signer = ecrecover(hash, v, r, s);
607         if (signer == address(0)) {
608             return (address(0), RecoverError.InvalidSignature);
609         }
610 
611         return (signer, RecoverError.NoError);
612     }
613 
614     /**
615      * @dev Overload of {ECDSA-recover} that receives the `v`,
616      * `r` and `s` signature fields separately.
617      */
618     function recover(
619         bytes32 hash,
620         uint8 v,
621         bytes32 r,
622         bytes32 s
623     ) internal pure returns (address) {
624         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
625         _throwError(error);
626         return recovered;
627     }
628 
629     /**
630      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
631      * produces hash corresponding to the one signed with the
632      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
633      * JSON-RPC method as part of EIP-191.
634      *
635      * See {recover}.
636      */
637     function toEthSignedMessageHash(bytes32 hash)
638         internal
639         pure
640         returns (bytes32)
641     {
642         // 32 is the length in bytes of hash,
643         // enforced by the type signature above
644         return
645             keccak256(
646                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
647             );
648     }
649 
650     /**
651      * @dev Returns an Ethereum Signed Message, created from `s`. This
652      * produces hash corresponding to the one signed with the
653      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
654      * JSON-RPC method as part of EIP-191.
655      *
656      * See {recover}.
657      */
658     function toEthSignedMessageHash(bytes memory s)
659         internal
660         pure
661         returns (bytes32)
662     {
663         return
664             keccak256(
665                 abi.encodePacked(
666                     "\x19Ethereum Signed Message:\n",
667                     Strings.toString(s.length),
668                     s
669                 )
670             );
671     }
672 
673     /**
674      * @dev Returns an Ethereum Signed Typed Data, created from a
675      * `domainSeparator` and a `structHash`. This produces hash corresponding
676      * to the one signed with the
677      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
678      * JSON-RPC method as part of EIP-712.
679      *
680      * See {recover}.
681      */
682     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
683         internal
684         pure
685         returns (bytes32)
686     {
687         return
688             keccak256(
689                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
690             );
691     }
692 }
693 
694 abstract contract EIP712 {
695     /* solhint-disable var-name-mixedcase */
696     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
697     // invalidate the cached domain separator if the chain id changes.
698     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
699     uint256 private immutable _CACHED_CHAIN_ID;
700     address private immutable _CACHED_THIS;
701 
702     bytes32 private immutable _HASHED_NAME;
703     bytes32 private immutable _HASHED_VERSION;
704     bytes32 private immutable _TYPE_HASH;
705 
706     /* solhint-enable var-name-mixedcase */
707 
708     /**
709      * @dev Initializes the domain separator and parameter caches.
710      *
711      * The meaning of `name` and `version` is specified in
712      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
713      *
714      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
715      * - `version`: the current major version of the signing domain.
716      *
717      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
718      * contract upgrade].
719      */
720     constructor(string memory name, string memory version) {
721         bytes32 hashedName = keccak256(bytes(name));
722         bytes32 hashedVersion = keccak256(bytes(version));
723         bytes32 typeHash = keccak256(
724             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
725         );
726         _HASHED_NAME = hashedName;
727         _HASHED_VERSION = hashedVersion;
728         _CACHED_CHAIN_ID = block.chainid;
729         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(
730             typeHash,
731             hashedName,
732             hashedVersion
733         );
734         _CACHED_THIS = address(this);
735         _TYPE_HASH = typeHash;
736     }
737 
738     /**
739      * @dev Returns the domain separator for the current chain.
740      */
741     function _domainSeparatorV4() internal view returns (bytes32) {
742         if (
743             address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID
744         ) {
745             return _CACHED_DOMAIN_SEPARATOR;
746         } else {
747             return
748                 _buildDomainSeparator(
749                     _TYPE_HASH,
750                     _HASHED_NAME,
751                     _HASHED_VERSION
752                 );
753         }
754     }
755 
756     function _buildDomainSeparator(
757         bytes32 typeHash,
758         bytes32 nameHash,
759         bytes32 versionHash
760     ) private view returns (bytes32) {
761         return
762             keccak256(
763                 abi.encode(
764                     typeHash,
765                     nameHash,
766                     versionHash,
767                     block.chainid,
768                     address(this)
769                 )
770             );
771     }
772 
773     /**
774      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
775      * function returns the hash of the fully encoded EIP712 message for this domain.
776      *
777      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
778      *
779      * ```solidity
780      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
781      *     keccak256("Mail(address to,string contents)"),
782      *     mailTo,
783      *     keccak256(bytes(mailContents))
784      * )));
785      * address signer = ECDSA.recover(digest, signature);
786      * ```
787      */
788     function _hashTypedDataV4(bytes32 structHash)
789         internal
790         view
791         virtual
792         returns (bytes32)
793     {
794         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
795     }
796 }
797 
798 contract CybeeDAO is ERC20, EIP712 {
799     mapping(address => uint256) private _nonces;
800 
801     uint256 private constant minimumTimeBetweenMints = 1 days * 365;
802 
803     address public immutable cSigner;
804     address public minter;
805     uint256 public nextMintAfter;
806     uint256 public maxMintCap = 2;
807 
808     bytes32 public constant CLAIM_CALL_HASH_TYPE =
809         keccak256("claim(address receiver,uint256 amount,uint256 nonce)");
810     uint256 public constant MAX_SUPPLY = 10_000_000_000e18;
811 
812     // for DAO
813     uint256 public constant AMOUNT_DAO = (MAX_SUPPLY / 100) * 30;
814     address public constant ADDR_DAO =
815         0x3D3FA7E562A1bA54f2265412AB1817f39b358c2a;
816 
817     // for Cybee team
818     uint256 public constant AMOUNT_TEAM = (MAX_SUPPLY / 100) * 40;
819     address public constant ADDR_TEAM =
820         0x22e132FD5EC37b7827fEc48342b994a33Df6b228;
821 
822     event MinterChanged(address indexed minter, address indexed newMinter);
823     event Claimed(address indexed to, uint256 amount, uint256 nonce);
824     event Minted(address indexed to, uint256 amount);
825 
826     constructor(address _signer)
827         ERC20("CybeeDAO", "CBD")
828         EIP712("CybeeDAO", "1")
829     {
830         _mint(ADDR_DAO, AMOUNT_DAO);
831         _mint(ADDR_TEAM, AMOUNT_TEAM);
832 
833         minter = ADDR_DAO;
834         cSigner = _signer;
835         nextMintAfter = block.timestamp + minimumTimeBetweenMints;
836     }
837 
838     function claim(uint256 amount, bytes memory signature) public {
839         uint256 total = totalSupply() + amount;
840         require(total <= MAX_SUPPLY, "CybeeDAO: Exceed max supply");
841 
842         bytes32 digest = _hashTypedDataV4(
843             keccak256(
844                 abi.encode(
845                     CLAIM_CALL_HASH_TYPE,
846                     msg.sender,
847                     amount,
848                     _nonces[msg.sender]
849                 )
850             )
851         );
852         require(
853             ECDSA.recover(digest, signature) == cSigner,
854             "CybeeDAO: Invalid signature"
855         );
856 
857         uint256 userNonce = _nonces[msg.sender];
858         _nonces[msg.sender] = userNonce + 1;
859 
860         _mint(msg.sender, amount);
861         emit Claimed(msg.sender, amount, userNonce);
862     }
863 
864     function nonce(address user) public view returns (uint256) {
865         return _nonces[user];
866     }
867 
868     function mint(address to, uint256 amount) public {
869         require(msg.sender == minter, "CybeeDAO: Only minter can mint");
870         require(
871             block.timestamp >= nextMintAfter,
872             "CybeeDAO: Minting is not allowed yet"
873         );
874 
875         nextMintAfter = block.timestamp + minimumTimeBetweenMints;
876 
877         uint256 maxMintAmount = (totalSupply() / 100) * maxMintCap;
878         require(amount <= maxMintAmount, "CybeeDAO: Exceed max mint cap");
879 
880         _mint(to, amount);
881         emit Minted(to, amount);
882     }
883 
884     function setMinter(address _minter) public {
885         require(
886             minter == _minter,
887             "CybeeDAO: Only minter can change the minter address"
888         );
889         minter = _minter;
890         emit MinterChanged(minter, _minter);
891     }
892 }