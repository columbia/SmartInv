1 // SPDX-License-Identifier: Unlicense
2 pragma solidity >=0.8.12;
3 
4 /// @notice Gas optimized reentrancy protection for smart contracts.
5 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/ReentrancyGuard.sol)
6 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
7 abstract contract ReentrancyGuard {
8     uint256 private locked = 1;
9 
10     modifier nonReentrant() {
11         require(locked == 1, "REENTRANCY");
12 
13         locked = 2;
14 
15         _;
16 
17         locked = 1;
18     }
19 } /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
20 
21 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
22 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
23 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
24 abstract contract ERC20 {
25     /*///////////////////////////////////////////////////////////////
26                                   EVENTS
27     //////////////////////////////////////////////////////////////*/
28 
29     event Transfer(address indexed from, address indexed to, uint256 amount);
30 
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 amount
35     );
36 
37     /*///////////////////////////////////////////////////////////////
38                              METADATA STORAGE
39     //////////////////////////////////////////////////////////////*/
40 
41     string public name;
42 
43     string public symbol;
44 
45     uint8 public immutable decimals;
46 
47     /*///////////////////////////////////////////////////////////////
48                               ERC20 STORAGE
49     //////////////////////////////////////////////////////////////*/
50 
51     uint256 public totalSupply;
52 
53     mapping(address => uint256) public balanceOf;
54 
55     mapping(address => mapping(address => uint256)) public allowance;
56 
57     /*///////////////////////////////////////////////////////////////
58                              EIP-2612 STORAGE
59     //////////////////////////////////////////////////////////////*/
60 
61     bytes32 public constant PERMIT_TYPEHASH =
62         keccak256(
63             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
64         );
65 
66     uint256 internal immutable INITIAL_CHAIN_ID;
67 
68     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
69 
70     mapping(address => uint256) public nonces;
71 
72     /*///////////////////////////////////////////////////////////////
73                                CONSTRUCTOR
74     //////////////////////////////////////////////////////////////*/
75 
76     constructor(
77         string memory _name,
78         string memory _symbol,
79         uint8 _decimals
80     ) {
81         name = _name;
82         symbol = _symbol;
83         decimals = _decimals;
84 
85         INITIAL_CHAIN_ID = block.chainid;
86         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
87     }
88 
89     /*///////////////////////////////////////////////////////////////
90                               ERC20 LOGIC
91     //////////////////////////////////////////////////////////////*/
92 
93     function approve(address spender, uint256 amount)
94         public
95         virtual
96         returns (bool)
97     {
98         allowance[msg.sender][spender] = amount;
99 
100         emit Approval(msg.sender, spender, amount);
101 
102         return true;
103     }
104 
105     function transfer(address to, uint256 amount)
106         public
107         virtual
108         returns (bool)
109     {
110         balanceOf[msg.sender] -= amount;
111 
112         // Cannot overflow because the sum of all user
113         // balances can't exceed the max uint256 value.
114         unchecked {
115             balanceOf[to] += amount;
116         }
117 
118         emit Transfer(msg.sender, to, amount);
119 
120         return true;
121     }
122 
123     function transferFrom(
124         address from,
125         address to,
126         uint256 amount
127     ) public virtual returns (bool) {
128         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
129 
130         if (allowed != type(uint256).max)
131             allowance[from][msg.sender] = allowed - amount;
132 
133         balanceOf[from] -= amount;
134 
135         // Cannot overflow because the sum of all user
136         // balances can't exceed the max uint256 value.
137         unchecked {
138             balanceOf[to] += amount;
139         }
140 
141         emit Transfer(from, to, amount);
142 
143         return true;
144     }
145 
146     /*///////////////////////////////////////////////////////////////
147                               EIP-2612 LOGIC
148     //////////////////////////////////////////////////////////////*/
149 
150     function permit(
151         address owner,
152         address spender,
153         uint256 value,
154         uint256 deadline,
155         uint8 v,
156         bytes32 r,
157         bytes32 s
158     ) public virtual {
159         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
160 
161         // Unchecked because the only math done is incrementing
162         // the owner's nonce which cannot realistically overflow.
163         unchecked {
164             bytes32 digest = keccak256(
165                 abi.encodePacked(
166                     "\x19\x01",
167                     DOMAIN_SEPARATOR(),
168                     keccak256(
169                         abi.encode(
170                             PERMIT_TYPEHASH,
171                             owner,
172                             spender,
173                             value,
174                             nonces[owner]++,
175                             deadline
176                         )
177                     )
178                 )
179             );
180 
181             address recoveredAddress = ecrecover(digest, v, r, s);
182 
183             require(
184                 recoveredAddress != address(0) && recoveredAddress == owner,
185                 "INVALID_SIGNER"
186             );
187 
188             allowance[recoveredAddress][spender] = value;
189         }
190 
191         emit Approval(owner, spender, value);
192     }
193 
194     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
195         return
196             block.chainid == INITIAL_CHAIN_ID
197                 ? INITIAL_DOMAIN_SEPARATOR
198                 : computeDomainSeparator();
199     }
200 
201     function computeDomainSeparator() internal view virtual returns (bytes32) {
202         return
203             keccak256(
204                 abi.encode(
205                     keccak256(
206                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
207                     ),
208                     keccak256(bytes(name)),
209                     keccak256("1"),
210                     block.chainid,
211                     address(this)
212                 )
213             );
214     }
215 
216     /*///////////////////////////////////////////////////////////////
217                        INTERNAL MINT/BURN LOGIC
218     //////////////////////////////////////////////////////////////*/
219 
220     function _mint(address to, uint256 amount) internal virtual {
221         totalSupply += amount;
222 
223         // Cannot overflow because the sum of all user
224         // balances can't exceed the max uint256 value.
225         unchecked {
226             balanceOf[to] += amount;
227         }
228 
229         emit Transfer(address(0), to, amount);
230     }
231 
232     function _burn(address from, uint256 amount) internal virtual {
233         balanceOf[from] -= amount;
234 
235         // Cannot underflow because a user's balance
236         // will never be larger than the total supply.
237         unchecked {
238             totalSupply -= amount;
239         }
240 
241         emit Transfer(from, address(0), amount);
242     }
243 } // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
244 
245 /**
246  * @dev String operations.
247  */
248 library Strings {
249     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
253      */
254     function toString(uint256 value) internal pure returns (string memory) {
255         // Inspired by OraclizeAPI's implementation - MIT licence
256         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
257 
258         if (value == 0) {
259             return "0";
260         }
261         uint256 temp = value;
262         uint256 digits;
263         while (temp != 0) {
264             digits++;
265             temp /= 10;
266         }
267         bytes memory buffer = new bytes(digits);
268         while (value != 0) {
269             digits -= 1;
270             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
271             value /= 10;
272         }
273         return string(buffer);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
278      */
279     function toHexString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0x00";
282         }
283         uint256 temp = value;
284         uint256 length = 0;
285         while (temp != 0) {
286             length++;
287             temp >>= 8;
288         }
289         return toHexString(value, length);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
294      */
295     function toHexString(uint256 value, uint256 length)
296         internal
297         pure
298         returns (string memory)
299     {
300         bytes memory buffer = new bytes(2 * length + 2);
301         buffer[0] = "0";
302         buffer[1] = "x";
303         for (uint256 i = 2 * length + 1; i > 1; --i) {
304             buffer[i] = _HEX_SYMBOLS[value & 0xf];
305             value >>= 4;
306         }
307         require(value == 0, "Strings: hex length insufficient");
308         return string(buffer);
309     }
310 } /// @title Interface for verifying contract-based account signatures
311 
312 /// @notice Interface that verifies provided signature for the data
313 /// @dev Interface defined by EIP-1271
314 interface IERC1271 {
315     /// @notice Returns whether the provided signature is valid for the provided data
316     /// @dev MUST return the bytes4 magic value 0x1626ba7e when function passes.
317     /// MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5).
318     /// MUST allow external calls.
319     /// @param hash Hash of the data to be signed
320     /// @param signature Signature byte array associated with _data
321     /// @return magicValue The bytes4 magic value 0x1626ba7e
322     function isValidSignature(bytes32 hash, bytes memory signature)
323         external
324         view
325         returns (bytes4 magicValue);
326 }
327 
328 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      *
351      * [IMPORTANT]
352      * ====
353      * You shouldn't rely on `isContract` to protect against flash loan attacks!
354      *
355      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
356      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
357      * constructor.
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize/address.code.length, which returns 0
362         // for contracts in construction, since the code is only stored at the end
363         // of the constructor execution.
364 
365         return account.code.length > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(
386             address(this).balance >= amount,
387             "Address: insufficient balance"
388         );
389 
390         (bool success, ) = recipient.call{value: amount}("");
391         require(
392             success,
393             "Address: unable to send value, recipient may have reverted"
394         );
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain `call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data)
416         internal
417         returns (bytes memory)
418     {
419         return functionCall(target, data, "Address: low-level call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424      * `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, 0, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but also transferring `value` wei to `target`.
439      *
440      * Requirements:
441      *
442      * - the calling contract must have an ETH balance of at least `value`.
443      * - the called Solidity function must be `payable`.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 value
451     ) internal returns (bytes memory) {
452         return
453             functionCallWithValue(
454                 target,
455                 data,
456                 value,
457                 "Address: low-level call with value failed"
458             );
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(
474             address(this).balance >= value,
475             "Address: insufficient balance for call"
476         );
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(
480             data
481         );
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(address target, bytes memory data)
492         internal
493         view
494         returns (bytes memory)
495     {
496         return
497             functionStaticCall(
498                 target,
499                 data,
500                 "Address: low-level static call failed"
501             );
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
506      * but performing a static call.
507      *
508      * _Available since v3.3._
509      */
510     function functionStaticCall(
511         address target,
512         bytes memory data,
513         string memory errorMessage
514     ) internal view returns (bytes memory) {
515         require(isContract(target), "Address: static call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.staticcall(data);
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(address target, bytes memory data)
528         internal
529         returns (bytes memory)
530     {
531         return
532             functionDelegateCall(
533                 target,
534                 data,
535                 "Address: low-level delegate call failed"
536             );
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
541      * but performing a delegate call.
542      *
543      * _Available since v3.4._
544      */
545     function functionDelegateCall(
546         address target,
547         bytes memory data,
548         string memory errorMessage
549     ) internal returns (bytes memory) {
550         require(isContract(target), "Address: delegate call to non-contract");
551 
552         (bool success, bytes memory returndata) = target.delegatecall(data);
553         return verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     /**
557      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
558      * revert reason using the provided one.
559      *
560      * _Available since v4.3._
561      */
562     function verifyCallResult(
563         bool success,
564         bytes memory returndata,
565         string memory errorMessage
566     ) internal pure returns (bytes memory) {
567         if (success) {
568             return returndata;
569         } else {
570             // Look for revert reason and bubble it up if present
571             if (returndata.length > 0) {
572                 // The easiest way to bubble the revert reason is using memory via assembly
573 
574                 assembly {
575                     let returndata_size := mload(returndata)
576                     revert(add(32, returndata), returndata_size)
577                 }
578             } else {
579                 revert(errorMessage);
580             }
581         }
582     }
583 }
584 
585 library Signature {
586     function recover(
587         bytes32 hash,
588         uint8 v,
589         bytes32 r,
590         bytes32 s
591     ) internal pure returns (address) {
592         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
593         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
594         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
595         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
596         //
597         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
598         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
599         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
600         // these malleable signatures as well.
601         require(
602             uint256(s) <=
603                 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
604             "ODYSSEY: INVALID_SIGNATURE_S_VALUE"
605         );
606         require(v == 27 || v == 28, "ODYSSEY: INVALID_SIGNATURE_V_VALUE");
607 
608         // If the signature is valid (and not malleable), return the signer address
609         address signer = ecrecover(hash, v, r, s);
610         require(signer != address(0), "ODYSSEY: INVALID_SIGNATURE");
611 
612         return signer;
613     }
614 
615     function verify(
616         bytes32 hash,
617         address signer,
618         uint8 v,
619         bytes32 r,
620         bytes32 s,
621         bytes32 domainSeparator
622     ) internal view {
623         bytes32 digest = keccak256(
624             abi.encodePacked("\x19\x01", domainSeparator, hash)
625         );
626         if (Address.isContract(signer)) {
627             require(
628                 IERC1271(signer).isValidSignature(
629                     digest,
630                     abi.encodePacked(r, s, v)
631                 ) == 0x1626ba7e,
632                 "ODYSSEY: UNAUTHORIZED"
633             );
634         } else {
635             require(
636                 recover(digest, v, r, s) == signer,
637                 "ODYSSEY: UNAUTHORIZED"
638             );
639         }
640     }
641 } // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
642 
643 /**
644  * @dev These functions deal with verification of Merkle Trees proofs.
645  *
646  * The proofs can be generated using the JavaScript library
647  * https://github.com/miguelmota/merkletreejs[merkletreejs].
648  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
649  *
650  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
651  *
652  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
653  * hashing, or use a hash function other than keccak256 for hashing leaves.
654  * This is because the concatenation of a sorted pair of internal nodes in
655  * the merkle tree could be reinterpreted as a leaf value.
656  */
657 library MerkleProof {
658     /**
659      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
660      * defined by `root`. For this, a `proof` must be provided, containing
661      * sibling hashes on the branch from the leaf to the root of the tree. Each
662      * pair of leaves and each pair of pre-images are assumed to be sorted.
663      */
664     function verify(
665         bytes32[] memory proof,
666         bytes32 root,
667         bytes32 leaf
668     ) internal pure returns (bool) {
669         return processProof(proof, leaf) == root;
670     }
671 
672     /**
673      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
674      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
675      * hash matches the root of the tree. When processing the proof, the pairs
676      * of leafs & pre-images are assumed to be sorted.
677      *
678      * _Available since v4.4._
679      */
680     function processProof(bytes32[] memory proof, bytes32 leaf)
681         internal
682         pure
683         returns (bytes32)
684     {
685         bytes32 computedHash = leaf;
686         for (uint256 i = 0; i < proof.length; i++) {
687             bytes32 proofElement = proof[i];
688             if (computedHash <= proofElement) {
689                 // Hash(current computed hash + current element of the proof)
690                 computedHash = _efficientHash(computedHash, proofElement);
691             } else {
692                 // Hash(current element of the proof + current computed hash)
693                 computedHash = _efficientHash(proofElement, computedHash);
694             }
695         }
696         return computedHash;
697     }
698 
699     function _efficientHash(bytes32 a, bytes32 b)
700         private
701         pure
702         returns (bytes32 value)
703     {
704         assembly {
705             mstore(0x00, a)
706             mstore(0x20, b)
707             value := keccak256(0x00, 0x40)
708         }
709     }
710 }
711 
712 library MerkleWhiteList {
713     function verify(
714         address sender,
715         bytes32[] calldata merkleProof,
716         bytes32 merkleRoot
717     ) internal pure {
718         // Verify whitelist
719         require(address(0) != sender);
720         bytes32 leaf = keccak256(abi.encodePacked(sender));
721         require(
722             MerkleProof.verify(merkleProof, merkleRoot, leaf),
723             "Not whitelisted"
724         );
725     }
726 } /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
727 
728 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
729 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
730 abstract contract ERC721 {
731     /*///////////////////////////////////////////////////////////////
732                                  EVENTS
733     //////////////////////////////////////////////////////////////*/
734 
735     event Transfer(
736         address indexed from,
737         address indexed to,
738         uint256 indexed id
739     );
740 
741     event Approval(
742         address indexed owner,
743         address indexed spender,
744         uint256 indexed id
745     );
746 
747     event ApprovalForAll(
748         address indexed owner,
749         address indexed operator,
750         bool approved
751     );
752 
753     /*///////////////////////////////////////////////////////////////
754                           METADATA STORAGE/LOGIC
755     //////////////////////////////////////////////////////////////*/
756 
757     string public name;
758 
759     string public symbol;
760 
761     function tokenURI(uint256 id) public view virtual returns (string memory);
762 
763     /*///////////////////////////////////////////////////////////////
764                             ERC721 STORAGE                        
765     //////////////////////////////////////////////////////////////*/
766 
767     mapping(address => uint256) public balanceOf;
768 
769     mapping(uint256 => address) public ownerOf;
770 
771     mapping(uint256 => address) public getApproved;
772 
773     mapping(address => mapping(address => bool)) public isApprovedForAll;
774 
775     /*///////////////////////////////////////////////////////////////
776                               CONSTRUCTOR
777     //////////////////////////////////////////////////////////////*/
778 
779     constructor(string memory _name, string memory _symbol) {
780         name = _name;
781         symbol = _symbol;
782     }
783 
784     /*///////////////////////////////////////////////////////////////
785                               ERC721 LOGIC
786     //////////////////////////////////////////////////////////////*/
787 
788     function approve(address spender, uint256 id) public virtual {
789         address owner = ownerOf[id];
790 
791         require(
792             msg.sender == owner || isApprovedForAll[owner][msg.sender],
793             "NOT_AUTHORIZED"
794         );
795 
796         getApproved[id] = spender;
797 
798         emit Approval(owner, spender, id);
799     }
800 
801     function setApprovalForAll(address operator, bool approved) public virtual {
802         isApprovedForAll[msg.sender][operator] = approved;
803 
804         emit ApprovalForAll(msg.sender, operator, approved);
805     }
806 
807     function transferFrom(
808         address from,
809         address to,
810         uint256 id
811     ) public virtual {
812         require(from == ownerOf[id], "WRONG_FROM");
813 
814         require(to != address(0), "INVALID_RECIPIENT");
815 
816         require(
817             msg.sender == from ||
818                 msg.sender == getApproved[id] ||
819                 isApprovedForAll[from][msg.sender],
820             "NOT_AUTHORIZED"
821         );
822 
823         // Underflow of the sender's balance is impossible because we check for
824         // ownership above and the recipient's balance can't realistically overflow.
825         unchecked {
826             balanceOf[from]--;
827 
828             balanceOf[to]++;
829         }
830 
831         ownerOf[id] = to;
832 
833         delete getApproved[id];
834 
835         emit Transfer(from, to, id);
836     }
837 
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 id
842     ) public virtual {
843         transferFrom(from, to, id);
844 
845         require(
846             to.code.length == 0 ||
847                 ERC721TokenReceiver(to).onERC721Received(
848                     msg.sender,
849                     from,
850                     id,
851                     ""
852                 ) ==
853                 ERC721TokenReceiver.onERC721Received.selector,
854             "UNSAFE_RECIPIENT"
855         );
856     }
857 
858     function safeTransferFrom(
859         address from,
860         address to,
861         uint256 id,
862         bytes memory data
863     ) public virtual {
864         transferFrom(from, to, id);
865 
866         require(
867             to.code.length == 0 ||
868                 ERC721TokenReceiver(to).onERC721Received(
869                     msg.sender,
870                     from,
871                     id,
872                     data
873                 ) ==
874                 ERC721TokenReceiver.onERC721Received.selector,
875             "UNSAFE_RECIPIENT"
876         );
877     }
878 
879     /*///////////////////////////////////////////////////////////////
880                               ERC165 LOGIC
881     //////////////////////////////////////////////////////////////*/
882 
883     function supportsInterface(bytes4 interfaceId)
884         public
885         pure
886         virtual
887         returns (bool)
888     {
889         return
890             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
891             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
892             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
893     }
894 
895     /*///////////////////////////////////////////////////////////////
896                        INTERNAL MINT/BURN LOGIC
897     //////////////////////////////////////////////////////////////*/
898 
899     function _mint(address to, uint256 id) internal virtual {
900         require(to != address(0), "INVALID_RECIPIENT");
901 
902         require(ownerOf[id] == address(0), "ALREADY_MINTED");
903 
904         // Counter overflow is incredibly unrealistic.
905         unchecked {
906             balanceOf[to]++;
907         }
908 
909         ownerOf[id] = to;
910 
911         emit Transfer(address(0), to, id);
912     }
913 
914     function _burn(uint256 id) internal virtual {
915         address owner = ownerOf[id];
916 
917         require(ownerOf[id] != address(0), "NOT_MINTED");
918 
919         // Ownership check above ensures no underflow.
920         unchecked {
921             balanceOf[owner]--;
922         }
923 
924         delete ownerOf[id];
925 
926         delete getApproved[id];
927 
928         emit Transfer(owner, address(0), id);
929     }
930 
931     /*///////////////////////////////////////////////////////////////
932                        INTERNAL SAFE MINT LOGIC
933     //////////////////////////////////////////////////////////////*/
934 
935     function _safeMint(address to, uint256 id) internal virtual {
936         _mint(to, id);
937 
938         require(
939             to.code.length == 0 ||
940                 ERC721TokenReceiver(to).onERC721Received(
941                     msg.sender,
942                     address(0),
943                     id,
944                     ""
945                 ) ==
946                 ERC721TokenReceiver.onERC721Received.selector,
947             "UNSAFE_RECIPIENT"
948         );
949     }
950 
951     function _safeMint(
952         address to,
953         uint256 id,
954         bytes memory data
955     ) internal virtual {
956         _mint(to, id);
957 
958         require(
959             to.code.length == 0 ||
960                 ERC721TokenReceiver(to).onERC721Received(
961                     msg.sender,
962                     address(0),
963                     id,
964                     data
965                 ) ==
966                 ERC721TokenReceiver.onERC721Received.selector,
967             "UNSAFE_RECIPIENT"
968         );
969     }
970 }
971 
972 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
973 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
974 interface ERC721TokenReceiver {
975     function onERC721Received(
976         address operator,
977         address from,
978         uint256 id,
979         bytes calldata data
980     ) external returns (bytes4);
981 }
982 
983 library UInt2Str {
984     function uint2str(uint256 _i)
985         internal
986         pure
987         returns (string memory _uintAsString)
988     {
989         if (_i == 0) {
990             return "0";
991         }
992         uint256 j = _i;
993         uint256 len;
994         while (j != 0) {
995             len++;
996             j /= 10;
997         }
998         bytes memory bstr = new bytes(len);
999         uint256 k = len;
1000         while (_i != 0) {
1001             k = k - 1;
1002             uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
1003             bytes1 b1 = bytes1(temp);
1004             bstr[k] = b1;
1005             _i /= 10;
1006         }
1007         return string(bstr);
1008     }
1009 }
1010 
1011 contract OdysseyERC721 is ERC721("", "") {
1012     using UInt2Str for uint256;
1013 
1014     /*///////////////////////////////////////////////////////////////
1015                             CUSTOM ERRORS
1016     //////////////////////////////////////////////////////////////*/
1017     error OdysseyERC721_AlreadyInit();
1018     error OdysseyERC721_Unauthorized();
1019     error OdysseyERC721_BadAddress();
1020 
1021     /*///////////////////////////////////////////////////////////////
1022                             METADATA STORAGE
1023     //////////////////////////////////////////////////////////////*/
1024     address launcher;
1025     address public owner;
1026     bool initialized;
1027     string public baseURI;
1028     uint256 public royaltyFeeInBips; // 1% = 100
1029     address public royaltyReceiver;
1030     string public contractURI;
1031 
1032     /*///////////////////////////////////////////////////////////////
1033                               METADATA LOGIC
1034     //////////////////////////////////////////////////////////////*/
1035 
1036     function tokenURI(uint256 id)
1037         public
1038         view
1039         virtual
1040         override
1041         returns (string memory)
1042     {
1043         return string(abi.encodePacked(baseURI, id.uint2str()));
1044     }
1045 
1046     /*///////////////////////////////////////////////////////////////
1047                               FACTORY LOGIC
1048     //////////////////////////////////////////////////////////////*/
1049 
1050     function initialize(
1051         address _launcher,
1052         address _owner,
1053         string calldata _name,
1054         string calldata _symbol,
1055         string calldata _baseURI
1056     ) external {
1057         if (initialized) {
1058             revert OdysseyERC721_AlreadyInit();
1059         }
1060         initialized = true;
1061         launcher = _launcher;
1062         owner = _owner;
1063         name = _name;
1064         symbol = _symbol;
1065         baseURI = _baseURI;
1066     }
1067 
1068     /*///////////////////////////////////////////////////////////////
1069                               ERC721 LOGIC
1070     //////////////////////////////////////////////////////////////*/
1071 
1072     function transferOwnership(address newOwner) public virtual {
1073         if (newOwner == address(0)) {
1074             revert OdysseyERC721_BadAddress();
1075         }
1076         if (msg.sender != owner) {
1077             revert OdysseyERC721_Unauthorized();
1078         }
1079         owner = newOwner;
1080     }
1081 
1082     function mint(address user, uint256 id) external {
1083         if (msg.sender != launcher) {
1084             revert OdysseyERC721_Unauthorized();
1085         }
1086         _mint(user, id);
1087     }
1088 
1089     /*///////////////////////////////////////////////////////////////
1090                               EIP2981 LOGIC
1091     //////////////////////////////////////////////////////////////*/
1092 
1093     function royaltyInfo(uint256, uint256 _salePrice)
1094         external
1095         view
1096         returns (address receiver, uint256 royaltyAmount)
1097     {
1098         return (royaltyReceiver, (_salePrice / 10000) * royaltyFeeInBips);
1099     }
1100 
1101     function setRoyaltyInfo(address _royaltyReceiver, uint256 _royaltyFeeInBips)
1102         external
1103     {
1104         if (_royaltyReceiver == address(0)) {
1105             revert OdysseyERC721_BadAddress();
1106         }
1107         if (msg.sender != owner) {
1108             revert OdysseyERC721_Unauthorized();
1109         }
1110         royaltyReceiver = _royaltyReceiver;
1111         royaltyFeeInBips = _royaltyFeeInBips;
1112     }
1113 
1114     function setContractURI(string memory _uri) public {
1115         if (msg.sender != owner) {
1116             revert OdysseyERC721_Unauthorized();
1117         }
1118         contractURI = _uri;
1119     }
1120 
1121     /*///////////////////////////////////////////////////////////////
1122                               ERC165 LOGIC
1123     //////////////////////////////////////////////////////////////*/
1124 
1125     function supportsInterface(bytes4 interfaceID)
1126         public
1127         pure
1128         override(ERC721)
1129         returns (bool)
1130     {
1131         return
1132             bytes4(keccak256("royaltyInfo(uint256,uint256)")) == interfaceID ||
1133             super.supportsInterface(interfaceID);
1134     }
1135 } /// @notice Minimalist and gas efficient standard ERC1155 implementation.
1136 
1137 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
1138 abstract contract ERC1155 {
1139     /*///////////////////////////////////////////////////////////////
1140                                 EVENTS
1141     //////////////////////////////////////////////////////////////*/
1142 
1143     event TransferSingle(
1144         address indexed operator,
1145         address indexed from,
1146         address indexed to,
1147         uint256 id,
1148         uint256 amount
1149     );
1150 
1151     event TransferBatch(
1152         address indexed operator,
1153         address indexed from,
1154         address indexed to,
1155         uint256[] ids,
1156         uint256[] amounts
1157     );
1158 
1159     event ApprovalForAll(
1160         address indexed owner,
1161         address indexed operator,
1162         bool approved
1163     );
1164 
1165     event URI(string value, uint256 indexed id);
1166 
1167     /*///////////////////////////////////////////////////////////////
1168                             ERC1155 STORAGE
1169     //////////////////////////////////////////////////////////////*/
1170 
1171     mapping(address => mapping(uint256 => uint256)) public balanceOf;
1172 
1173     mapping(address => mapping(address => bool)) public isApprovedForAll;
1174 
1175     /*///////////////////////////////////////////////////////////////
1176                              METADATA LOGIC
1177     //////////////////////////////////////////////////////////////*/
1178 
1179     function uri(uint256 id) public view virtual returns (string memory);
1180 
1181     /*///////////////////////////////////////////////////////////////
1182                              ERC1155 LOGIC
1183     //////////////////////////////////////////////////////////////*/
1184 
1185     function setApprovalForAll(address operator, bool approved) public virtual {
1186         isApprovedForAll[msg.sender][operator] = approved;
1187 
1188         emit ApprovalForAll(msg.sender, operator, approved);
1189     }
1190 
1191     function safeTransferFrom(
1192         address from,
1193         address to,
1194         uint256 id,
1195         uint256 amount,
1196         bytes memory data
1197     ) public virtual {
1198         require(
1199             msg.sender == from || isApprovedForAll[from][msg.sender],
1200             "NOT_AUTHORIZED"
1201         );
1202 
1203         balanceOf[from][id] -= amount;
1204         balanceOf[to][id] += amount;
1205 
1206         emit TransferSingle(msg.sender, from, to, id, amount);
1207 
1208         require(
1209             to.code.length == 0
1210                 ? to != address(0)
1211                 : ERC1155TokenReceiver(to).onERC1155Received(
1212                     msg.sender,
1213                     from,
1214                     id,
1215                     amount,
1216                     data
1217                 ) == ERC1155TokenReceiver.onERC1155Received.selector,
1218             "UNSAFE_RECIPIENT"
1219         );
1220     }
1221 
1222     function safeBatchTransferFrom(
1223         address from,
1224         address to,
1225         uint256[] memory ids,
1226         uint256[] memory amounts,
1227         bytes memory data
1228     ) public virtual {
1229         uint256 idsLength = ids.length; // Saves MLOADs.
1230 
1231         require(idsLength == amounts.length, "LENGTH_MISMATCH");
1232 
1233         require(
1234             msg.sender == from || isApprovedForAll[from][msg.sender],
1235             "NOT_AUTHORIZED"
1236         );
1237 
1238         for (uint256 i = 0; i < idsLength; ) {
1239             uint256 id = ids[i];
1240             uint256 amount = amounts[i];
1241 
1242             balanceOf[from][id] -= amount;
1243             balanceOf[to][id] += amount;
1244 
1245             // An array can't have a total length
1246             // larger than the max uint256 value.
1247             unchecked {
1248                 i++;
1249             }
1250         }
1251 
1252         emit TransferBatch(msg.sender, from, to, ids, amounts);
1253 
1254         require(
1255             to.code.length == 0
1256                 ? to != address(0)
1257                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(
1258                     msg.sender,
1259                     from,
1260                     ids,
1261                     amounts,
1262                     data
1263                 ) == ERC1155TokenReceiver.onERC1155BatchReceived.selector,
1264             "UNSAFE_RECIPIENT"
1265         );
1266     }
1267 
1268     function balanceOfBatch(address[] memory owners, uint256[] memory ids)
1269         public
1270         view
1271         virtual
1272         returns (uint256[] memory balances)
1273     {
1274         uint256 ownersLength = owners.length; // Saves MLOADs.
1275 
1276         require(ownersLength == ids.length, "LENGTH_MISMATCH");
1277 
1278         balances = new uint256[](owners.length);
1279 
1280         // Unchecked because the only math done is incrementing
1281         // the array index counter which cannot possibly overflow.
1282         unchecked {
1283             for (uint256 i = 0; i < ownersLength; i++) {
1284                 balances[i] = balanceOf[owners[i]][ids[i]];
1285             }
1286         }
1287     }
1288 
1289     /*///////////////////////////////////////////////////////////////
1290                               ERC165 LOGIC
1291     //////////////////////////////////////////////////////////////*/
1292 
1293     function supportsInterface(bytes4 interfaceId)
1294         public
1295         pure
1296         virtual
1297         returns (bool)
1298     {
1299         return
1300             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1301             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
1302             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
1303     }
1304 
1305     /*///////////////////////////////////////////////////////////////
1306                         INTERNAL MINT/BURN LOGIC
1307     //////////////////////////////////////////////////////////////*/
1308 
1309     function _mint(
1310         address to,
1311         uint256 id,
1312         uint256 amount,
1313         bytes memory data
1314     ) internal {
1315         balanceOf[to][id] += amount;
1316 
1317         emit TransferSingle(msg.sender, address(0), to, id, amount);
1318 
1319         require(
1320             to.code.length == 0
1321                 ? to != address(0)
1322                 : ERC1155TokenReceiver(to).onERC1155Received(
1323                     msg.sender,
1324                     address(0),
1325                     id,
1326                     amount,
1327                     data
1328                 ) == ERC1155TokenReceiver.onERC1155Received.selector,
1329             "UNSAFE_RECIPIENT"
1330         );
1331     }
1332 
1333     function _batchMint(
1334         address to,
1335         uint256[] memory ids,
1336         uint256[] memory amounts,
1337         bytes memory data
1338     ) internal {
1339         uint256 idsLength = ids.length; // Saves MLOADs.
1340 
1341         require(idsLength == amounts.length, "LENGTH_MISMATCH");
1342 
1343         for (uint256 i = 0; i < idsLength; ) {
1344             balanceOf[to][ids[i]] += amounts[i];
1345 
1346             // An array can't have a total length
1347             // larger than the max uint256 value.
1348             unchecked {
1349                 i++;
1350             }
1351         }
1352 
1353         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
1354 
1355         require(
1356             to.code.length == 0
1357                 ? to != address(0)
1358                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(
1359                     msg.sender,
1360                     address(0),
1361                     ids,
1362                     amounts,
1363                     data
1364                 ) == ERC1155TokenReceiver.onERC1155BatchReceived.selector,
1365             "UNSAFE_RECIPIENT"
1366         );
1367     }
1368 
1369     function _batchBurn(
1370         address from,
1371         uint256[] memory ids,
1372         uint256[] memory amounts
1373     ) internal {
1374         uint256 idsLength = ids.length; // Saves MLOADs.
1375 
1376         require(idsLength == amounts.length, "LENGTH_MISMATCH");
1377 
1378         for (uint256 i = 0; i < idsLength; ) {
1379             balanceOf[from][ids[i]] -= amounts[i];
1380 
1381             // An array can't have a total length
1382             // larger than the max uint256 value.
1383             unchecked {
1384                 i++;
1385             }
1386         }
1387 
1388         emit TransferBatch(msg.sender, from, address(0), ids, amounts);
1389     }
1390 
1391     function _burn(
1392         address from,
1393         uint256 id,
1394         uint256 amount
1395     ) internal {
1396         balanceOf[from][id] -= amount;
1397 
1398         emit TransferSingle(msg.sender, from, address(0), id, amount);
1399     }
1400 }
1401 
1402 /// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
1403 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC1155.sol)
1404 interface ERC1155TokenReceiver {
1405     function onERC1155Received(
1406         address operator,
1407         address from,
1408         uint256 id,
1409         uint256 amount,
1410         bytes calldata data
1411     ) external returns (bytes4);
1412 
1413     function onERC1155BatchReceived(
1414         address operator,
1415         address from,
1416         uint256[] calldata ids,
1417         uint256[] calldata amounts,
1418         bytes calldata data
1419     ) external returns (bytes4);
1420 }
1421 
1422 contract OdysseyERC1155 is ERC1155 {
1423     using UInt2Str for uint256;
1424 
1425     /*///////////////////////////////////////////////////////////////
1426                             CUSTOM ERRORS
1427     //////////////////////////////////////////////////////////////*/
1428     error OdysseyERC1155_AlreadyInit();
1429     error OdysseyERC1155_Unauthorized();
1430     error OdysseyERC1155_BadAddress();
1431 
1432     /*///////////////////////////////////////////////////////////////
1433                             METADATA STORAGE
1434     //////////////////////////////////////////////////////////////*/
1435     address launcher;
1436     address public owner;
1437     string public name;
1438     string public symbol;
1439     string public baseURI;
1440     bool initialized;
1441     uint256 public royaltyFeeInBips; // 1% = 100
1442     address public royaltyReceiver;
1443     string public contractURI;
1444 
1445     /*///////////////////////////////////////////////////////////////
1446                              METADATA LOGIC
1447     //////////////////////////////////////////////////////////////*/
1448 
1449     function uri(uint256 id)
1450         public
1451         view
1452         virtual
1453         override
1454         returns (string memory)
1455     {
1456         return string(abi.encodePacked(baseURI, id.uint2str()));
1457     }
1458 
1459     /*///////////////////////////////////////////////////////////////
1460                               FACTORY LOGIC
1461     //////////////////////////////////////////////////////////////*/
1462 
1463     function initialize(
1464         address _launcher,
1465         address _owner,
1466         string calldata _name,
1467         string calldata _symbol,
1468         string calldata _baseURI
1469     ) external {
1470         if (isInit()) {
1471             revert OdysseyERC1155_AlreadyInit();
1472         }
1473         initialized = true;
1474         launcher = _launcher;
1475         owner = _owner;
1476         name = _name;
1477         symbol = _symbol;
1478         baseURI = _baseURI;
1479     }
1480 
1481     function isInit() internal view returns (bool) {
1482         return initialized;
1483     }
1484 
1485     /*///////////////////////////////////////////////////////////////
1486                               ERC1155 LOGIC
1487     //////////////////////////////////////////////////////////////*/
1488 
1489     function transferOwnership(address newOwner) public virtual {
1490         if (newOwner == address(0)) {
1491             revert OdysseyERC1155_BadAddress();
1492         }
1493         if (msg.sender != owner) {
1494             revert OdysseyERC1155_Unauthorized();
1495         }
1496         owner = newOwner;
1497     }
1498 
1499     function mint(address user, uint256 id) external {
1500         if (msg.sender != launcher) {
1501             revert OdysseyERC1155_Unauthorized();
1502         }
1503         _mint(user, id, 1, "");
1504     }
1505 
1506     function mintBatch(
1507         address user,
1508         uint256 id,
1509         uint256 amount
1510     ) external {
1511         if (msg.sender != launcher) {
1512             revert OdysseyERC1155_Unauthorized();
1513         }
1514         _mint(user, id, amount, "");
1515     }
1516 
1517     /*///////////////////////////////////////////////////////////////
1518                               EIP2981 LOGIC
1519     //////////////////////////////////////////////////////////////*/
1520 
1521     function royaltyInfo(uint256, uint256 _salePrice)
1522         external
1523         view
1524         returns (address receiver, uint256 royaltyAmount)
1525     {
1526         return (royaltyReceiver, (_salePrice / 10000) * royaltyFeeInBips);
1527     }
1528 
1529     function setRoyaltyInfo(address _royaltyReceiver, uint256 _royaltyFeeInBips)
1530         external
1531     {
1532         if (_royaltyReceiver == address(0)) {
1533             revert OdysseyERC1155_BadAddress();
1534         }
1535         if (msg.sender != owner) {
1536             revert OdysseyERC1155_Unauthorized();
1537         }
1538         royaltyReceiver = _royaltyReceiver;
1539         royaltyFeeInBips = _royaltyFeeInBips;
1540     }
1541 
1542     function setContractURI(string memory _uri) public {
1543         if (msg.sender != owner) {
1544             revert OdysseyERC1155_Unauthorized();
1545         }
1546         contractURI = _uri;
1547     }
1548 
1549     /*///////////////////////////////////////////////////////////////
1550                               ERC165 LOGIC
1551     //////////////////////////////////////////////////////////////*/
1552 
1553     function supportsInterface(bytes4 interfaceID)
1554         public
1555         pure
1556         override(ERC1155)
1557         returns (bool)
1558     {
1559         return
1560             bytes4(keccak256("royaltyInfo(uint256,uint256)")) == interfaceID ||
1561             super.supportsInterface(interfaceID);
1562     }
1563 }
1564 
1565 contract OdysseyTokenFactory {
1566     /*///////////////////////////////////////////////////////////////
1567                             CUSTOM ERRORS
1568     //////////////////////////////////////////////////////////////*/
1569     error OdysseyTokenFactory_TokenAlreadyExists();
1570     /*///////////////////////////////////////////////////////////////
1571                                 EVENTS
1572     //////////////////////////////////////////////////////////////*/
1573 
1574     event TokenCreated(
1575         string indexed name,
1576         string indexed symbol,
1577         address addr,
1578         bool isERC721,
1579         uint256 length
1580     );
1581 
1582     /*///////////////////////////////////////////////////////////////
1583                             FACTORY STORAGE
1584     //////////////////////////////////////////////////////////////*/
1585 
1586     mapping(string => mapping(string => address)) public getToken;
1587     mapping(address => uint256) public tokenExists;
1588     address[] public allTokens;
1589 
1590     /*///////////////////////////////////////////////////////////////
1591                             FACTORY LOGIC
1592     //////////////////////////////////////////////////////////////*/
1593 
1594     function allTokensLength() external view returns (uint256) {
1595         return allTokens.length;
1596     }
1597 
1598     function create1155(
1599         address owner,
1600         string calldata name,
1601         string calldata symbol,
1602         string calldata baseURI
1603     ) external returns (address token) {
1604         if (getToken[name][symbol] != address(0)) {
1605             revert OdysseyTokenFactory_TokenAlreadyExists();
1606         }
1607         bytes memory bytecode = type(OdysseyERC1155).creationCode;
1608         bytes32 salt = keccak256(abi.encodePacked(name, symbol));
1609         assembly {
1610             token := create2(0, add(bytecode, 32), mload(bytecode), salt)
1611         }
1612         getToken[name][symbol] = token;
1613         tokenExists[token] = 1;
1614         // Run the proper initialize function
1615         OdysseyERC1155(token).initialize(
1616             msg.sender,
1617             owner,
1618             name,
1619             symbol,
1620             string(
1621                 abi.encodePacked(
1622                     baseURI,
1623                     Strings.toString(block.chainid),
1624                     "/",
1625                     Strings.toHexString(uint160(token)),
1626                     "/"
1627                 )
1628             )
1629         );
1630         emit TokenCreated(name, symbol, token, false, allTokens.length);
1631         return token;
1632     }
1633 
1634     function create721(
1635         address owner,
1636         string calldata name,
1637         string calldata symbol,
1638         string calldata baseURI
1639     ) external returns (address token) {
1640         if (getToken[name][symbol] != address(0)) {
1641             revert OdysseyTokenFactory_TokenAlreadyExists();
1642         }
1643         bytes memory bytecode = type(OdysseyERC721).creationCode;
1644         bytes32 salt = keccak256(abi.encodePacked(name, symbol));
1645         assembly {
1646             token := create2(0, add(bytecode, 32), mload(bytecode), salt)
1647         }
1648         getToken[name][symbol] = token;
1649         tokenExists[token] = 1;
1650         // Run the proper initialize function
1651         OdysseyERC721(token).initialize(
1652             msg.sender,
1653             owner,
1654             name,
1655             symbol,
1656             string(
1657                 abi.encodePacked(
1658                     baseURI,
1659                     Strings.toString(block.chainid),
1660                     "/",
1661                     Strings.toHexString(uint160(token)),
1662                     "/"
1663                 )
1664             )
1665         );
1666         emit TokenCreated(name, symbol, token, true, allTokens.length);
1667     }
1668 }
1669 
1670 library OdysseyLib {
1671     struct Odyssey1155Info {
1672         uint256[] maxSupply;
1673         uint256[] tokenIds;
1674         uint256[] reserveAmounts;
1675     }
1676 
1677     struct BatchMint {
1678         bytes32[][] merkleProof;
1679         bytes32[] merkleRoot;
1680         uint256[] minPrice;
1681         uint256[] mintsPerUser;
1682         uint256[] tokenId;
1683         address[] tokenAddress;
1684         address[] currency;
1685         uint8[] v;
1686         bytes32[] r;
1687         bytes32[] s;
1688     }
1689 
1690     struct Percentage {
1691         uint256 numerator;
1692         uint256 denominator;
1693     }
1694 
1695     function compareDefaultPercentage(OdysseyLib.Percentage calldata percent)
1696         internal
1697         pure
1698         returns (bool result)
1699     {
1700         if (percent.numerator > percent.denominator) {
1701             // Can't have a percent greater than 100
1702             return false;
1703         }
1704 
1705         if (percent.numerator == 0 || percent.denominator == 0) {
1706             // Can't use 0 in percentage
1707             return false;
1708         }
1709 
1710         //Check cross multiplication of 3/100
1711         uint256 crossMultiple1 = percent.numerator * 100;
1712         uint256 crossMultiple2 = percent.denominator * 3;
1713         if (crossMultiple1 < crossMultiple2) {
1714             return false;
1715         }
1716         return true;
1717     }
1718 }
1719 
1720 abstract contract OdysseyDatabase {
1721     // Custom Errors
1722     error OdysseyLaunchPlatform_TokenDoesNotExist();
1723     error OdysseyLaunchPlatform_AlreadyClaimed();
1724     error OdysseyLaunchPlatform_MaxSupplyCap();
1725     error OdysseyLaunchPlatform_InsufficientFunds();
1726     error OdysseyLaunchPlatform_TreasuryPayFailure();
1727     error OdysseyLaunchPlatform_FailedToPayEther();
1728     error OdysseyLaunchPlatform_FailedToPayERC20();
1729     error OdysseyLaunchPlatform_ReservedOrClaimedMax();
1730 
1731     // Constants
1732     // keccak256("whitelistMint721(bytes32 merkleRoot,uint256 minPrice,uint256 mintsPerUser,address tokenAddress,address currency)").toString('hex')
1733     bytes32 public constant MERKLE_TREE_ROOT_ERC721_TYPEHASH =
1734         0xf0f6f256599682b9387f45fc268ed696625f835d98d64b8967134239e103fc6c;
1735     // keccak256("whitelistMint1155(bytes32 merkleRoot,uint256 minPrice,uint256 mintsPerUser,uint256 tokenId,address tokenAddress,address currency)").toString('hex')
1736     bytes32 public constant MERKLE_TREE_ROOT_ERC1155_TYPEHASH =
1737         0x0a52f6e0133eadd055cc5703844e676242c3b461d85fb7ce7f74becd7e40edd1;
1738 
1739     // Def understand this before writing code:
1740     // https://docs.soliditylang.org/en/v0.8.12/internals/layout_in_storage.html
1741     //--------------------------------------------------------------------------------//
1742     // Slot       |  Type                  | Description                              //
1743     //--------------------------------------------------------------------------------//
1744     // 0x00       |  address               | OdysseyLaunchPlatform.sol                //
1745     // 0x01       |  address               | OdysseyFactory.sol                       //
1746     // 0x02       |  address               | Treasury Multisig                        //
1747     // 0x03       |  address               | Admin Address                            //
1748     // 0x04       |  address               | OdysseyXp.sol                            //
1749     //--------------------------------------------------------------------------------//
1750     // Slot storage
1751     address launchPlatform; // slot 0
1752     address factory; // slot 1
1753     address treasury; // slot 2
1754     address admin; //slot 3
1755     address xp; //slot 4
1756 
1757     // Common Storage
1758     mapping(address => bytes32) public domainSeparator;
1759     mapping(address => uint256) public whitelistActive;
1760     mapping(address => address) public ownerOf;
1761     mapping(address => address) public royaltyRecipient;
1762     mapping(address => OdysseyLib.Percentage) public treasuryCommission;
1763     mapping(address => uint256) public ohmFamilyCurrencies;
1764     // ERC721 Storage
1765     mapping(address => mapping(address => uint256)) public whitelistClaimed721;
1766     mapping(address => mapping(address => uint256)) public isReserved721;
1767     mapping(address => uint256) public cumulativeSupply721;
1768     mapping(address => uint256) public mintedSupply721;
1769     mapping(address => uint256) public maxSupply721;
1770     // ERC1155 Storage
1771     mapping(address => mapping(address => mapping(uint256 => uint256)))
1772         public whitelistClaimed1155;
1773     mapping(address => mapping(address => mapping(uint256 => uint256)))
1774         public isReserved1155;
1775     mapping(address => mapping(uint256 => uint256)) public cumulativeSupply1155;
1776     mapping(address => mapping(uint256 => uint256)) public maxSupply1155;
1777 
1778     function readSlotAsAddress(uint256 slot)
1779         public
1780         view
1781         returns (address data)
1782     {
1783         assembly {
1784             data := sload(slot)
1785         }
1786     }
1787 } /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
1788 
1789 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol)
1790 /// @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
1791 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
1792 library SafeTransferLib {
1793     /*///////////////////////////////////////////////////////////////
1794                             ETH OPERATIONS
1795     //////////////////////////////////////////////////////////////*/
1796 
1797     function safeTransferETH(address to, uint256 amount) internal {
1798         bool callStatus;
1799 
1800         assembly {
1801             // Transfer the ETH and store if it succeeded or not.
1802             callStatus := call(gas(), to, amount, 0, 0, 0, 0)
1803         }
1804 
1805         require(callStatus, "ETH_TRANSFER_FAILED");
1806     }
1807 
1808     /*///////////////////////////////////////////////////////////////
1809                            ERC20 OPERATIONS
1810     //////////////////////////////////////////////////////////////*/
1811 
1812     function safeTransferFrom(
1813         ERC20 token,
1814         address from,
1815         address to,
1816         uint256 amount
1817     ) internal {
1818         bool callStatus;
1819 
1820         assembly {
1821             // Get a pointer to some free memory.
1822             let freeMemoryPointer := mload(0x40)
1823 
1824             // Write the abi-encoded calldata to memory piece by piece:
1825             mstore(
1826                 freeMemoryPointer,
1827                 0x23b872dd00000000000000000000000000000000000000000000000000000000
1828             ) // Begin with the function selector.
1829             mstore(
1830                 add(freeMemoryPointer, 4),
1831                 and(from, 0xffffffffffffffffffffffffffffffffffffffff)
1832             ) // Mask and append the "from" argument.
1833             mstore(
1834                 add(freeMemoryPointer, 36),
1835                 and(to, 0xffffffffffffffffffffffffffffffffffffffff)
1836             ) // Mask and append the "to" argument.
1837             mstore(add(freeMemoryPointer, 68), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
1838 
1839             // Call the token and store if it succeeded or not.
1840             // We use 100 because the calldata length is 4 + 32 * 3.
1841             callStatus := call(gas(), token, 0, freeMemoryPointer, 100, 0, 0)
1842         }
1843 
1844         require(
1845             didLastOptionalReturnCallSucceed(callStatus),
1846             "TRANSFER_FROM_FAILED"
1847         );
1848     }
1849 
1850     function safeTransfer(
1851         ERC20 token,
1852         address to,
1853         uint256 amount
1854     ) internal {
1855         bool callStatus;
1856 
1857         assembly {
1858             // Get a pointer to some free memory.
1859             let freeMemoryPointer := mload(0x40)
1860 
1861             // Write the abi-encoded calldata to memory piece by piece:
1862             mstore(
1863                 freeMemoryPointer,
1864                 0xa9059cbb00000000000000000000000000000000000000000000000000000000
1865             ) // Begin with the function selector.
1866             mstore(
1867                 add(freeMemoryPointer, 4),
1868                 and(to, 0xffffffffffffffffffffffffffffffffffffffff)
1869             ) // Mask and append the "to" argument.
1870             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
1871 
1872             // Call the token and store if it succeeded or not.
1873             // We use 68 because the calldata length is 4 + 32 * 2.
1874             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
1875         }
1876 
1877         require(
1878             didLastOptionalReturnCallSucceed(callStatus),
1879             "TRANSFER_FAILED"
1880         );
1881     }
1882 
1883     function safeApprove(
1884         ERC20 token,
1885         address to,
1886         uint256 amount
1887     ) internal {
1888         bool callStatus;
1889 
1890         assembly {
1891             // Get a pointer to some free memory.
1892             let freeMemoryPointer := mload(0x40)
1893 
1894             // Write the abi-encoded calldata to memory piece by piece:
1895             mstore(
1896                 freeMemoryPointer,
1897                 0x095ea7b300000000000000000000000000000000000000000000000000000000
1898             ) // Begin with the function selector.
1899             mstore(
1900                 add(freeMemoryPointer, 4),
1901                 and(to, 0xffffffffffffffffffffffffffffffffffffffff)
1902             ) // Mask and append the "to" argument.
1903             mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.
1904 
1905             // Call the token and store if it succeeded or not.
1906             // We use 68 because the calldata length is 4 + 32 * 2.
1907             callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
1908         }
1909 
1910         require(didLastOptionalReturnCallSucceed(callStatus), "APPROVE_FAILED");
1911     }
1912 
1913     /*///////////////////////////////////////////////////////////////
1914                          INTERNAL HELPER LOGIC
1915     //////////////////////////////////////////////////////////////*/
1916 
1917     function didLastOptionalReturnCallSucceed(bool callStatus)
1918         private
1919         pure
1920         returns (bool success)
1921     {
1922         assembly {
1923             // Get how many bytes the call returned.
1924             let returnDataSize := returndatasize()
1925 
1926             // If the call reverted:
1927             if iszero(callStatus) {
1928                 // Copy the revert message into memory.
1929                 returndatacopy(0, 0, returnDataSize)
1930 
1931                 // Revert with the same message.
1932                 revert(0, returnDataSize)
1933             }
1934 
1935             switch returnDataSize
1936             case 32 {
1937                 // Copy the return data into memory.
1938                 returndatacopy(0, 0, returnDataSize)
1939 
1940                 // Set success to whether it returned true.
1941                 success := iszero(iszero(mload(0)))
1942             }
1943             case 0 {
1944                 // There was no return data.
1945                 success := 1
1946             }
1947             default {
1948                 // It returned some malformed input.
1949                 success := 0
1950             }
1951         }
1952     }
1953 } /// @notice Arithmetic library with operations for fixed-point numbers.
1954 
1955 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/FixedPointMathLib.sol)
1956 /// @author Inspired by USM (https://github.com/usmfum/USM/blob/master/contracts/WadMath.sol)
1957 library FixedPointMathLib {
1958     /*//////////////////////////////////////////////////////////////
1959                     SIMPLIFIED FIXED POINT OPERATIONS
1960     //////////////////////////////////////////////////////////////*/
1961 
1962     uint256 internal constant WAD = 1e18; // The scalar of ETH and most ERC20s.
1963 
1964     function mulWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
1965         return mulDivDown(x, y, WAD); // Equivalent to (x * y) / WAD rounded down.
1966     }
1967 
1968     function mulWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
1969         return mulDivUp(x, y, WAD); // Equivalent to (x * y) / WAD rounded up.
1970     }
1971 
1972     function divWadDown(uint256 x, uint256 y) internal pure returns (uint256) {
1973         return mulDivDown(x, WAD, y); // Equivalent to (x * WAD) / y rounded down.
1974     }
1975 
1976     function divWadUp(uint256 x, uint256 y) internal pure returns (uint256) {
1977         return mulDivUp(x, WAD, y); // Equivalent to (x * WAD) / y rounded up.
1978     }
1979 
1980     /*//////////////////////////////////////////////////////////////
1981                     LOW LEVEL FIXED POINT OPERATIONS
1982     //////////////////////////////////////////////////////////////*/
1983 
1984     function mulDivDown(
1985         uint256 x,
1986         uint256 y,
1987         uint256 denominator
1988     ) internal pure returns (uint256 z) {
1989         assembly {
1990             // Store x * y in z for now.
1991             z := mul(x, y)
1992 
1993             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
1994             if iszero(
1995                 and(
1996                     iszero(iszero(denominator)),
1997                     or(iszero(x), eq(div(z, x), y))
1998                 )
1999             ) {
2000                 revert(0, 0)
2001             }
2002 
2003             // Divide z by the denominator.
2004             z := div(z, denominator)
2005         }
2006     }
2007 
2008     function mulDivUp(
2009         uint256 x,
2010         uint256 y,
2011         uint256 denominator
2012     ) internal pure returns (uint256 z) {
2013         assembly {
2014             // Store x * y in z for now.
2015             z := mul(x, y)
2016 
2017             // Equivalent to require(denominator != 0 && (x == 0 || (x * y) / x == y))
2018             if iszero(
2019                 and(
2020                     iszero(iszero(denominator)),
2021                     or(iszero(x), eq(div(z, x), y))
2022                 )
2023             ) {
2024                 revert(0, 0)
2025             }
2026 
2027             // First, divide z - 1 by the denominator and add 1.
2028             // We allow z - 1 to underflow if z is 0, because we multiply the
2029             // end result by 0 if z is zero, ensuring we return 0 if z is zero.
2030             z := mul(iszero(iszero(z)), add(div(sub(z, 1), denominator), 1))
2031         }
2032     }
2033 
2034     function rpow(
2035         uint256 x,
2036         uint256 n,
2037         uint256 scalar
2038     ) internal pure returns (uint256 z) {
2039         assembly {
2040             switch x
2041             case 0 {
2042                 switch n
2043                 case 0 {
2044                     // 0 ** 0 = 1
2045                     z := scalar
2046                 }
2047                 default {
2048                     // 0 ** n = 0
2049                     z := 0
2050                 }
2051             }
2052             default {
2053                 switch mod(n, 2)
2054                 case 0 {
2055                     // If n is even, store scalar in z for now.
2056                     z := scalar
2057                 }
2058                 default {
2059                     // If n is odd, store x in z for now.
2060                     z := x
2061                 }
2062 
2063                 // Shifting right by 1 is like dividing by 2.
2064                 let half := shr(1, scalar)
2065 
2066                 for {
2067                     // Shift n right by 1 before looping to halve it.
2068                     n := shr(1, n)
2069                 } n {
2070                     // Shift n right by 1 each iteration to halve it.
2071                     n := shr(1, n)
2072                 } {
2073                     // Revert immediately if x ** 2 would overflow.
2074                     // Equivalent to iszero(eq(div(xx, x), x)) here.
2075                     if shr(128, x) {
2076                         revert(0, 0)
2077                     }
2078 
2079                     // Store x squared.
2080                     let xx := mul(x, x)
2081 
2082                     // Round to the nearest number.
2083                     let xxRound := add(xx, half)
2084 
2085                     // Revert if xx + half overflowed.
2086                     if lt(xxRound, xx) {
2087                         revert(0, 0)
2088                     }
2089 
2090                     // Set x to scaled xxRound.
2091                     x := div(xxRound, scalar)
2092 
2093                     // If n is even:
2094                     if mod(n, 2) {
2095                         // Compute z * x.
2096                         let zx := mul(z, x)
2097 
2098                         // If z * x overflowed:
2099                         if iszero(eq(div(zx, x), z)) {
2100                             // Revert if x is non-zero.
2101                             if iszero(iszero(x)) {
2102                                 revert(0, 0)
2103                             }
2104                         }
2105 
2106                         // Round to the nearest number.
2107                         let zxRound := add(zx, half)
2108 
2109                         // Revert if zx + half overflowed.
2110                         if lt(zxRound, zx) {
2111                             revert(0, 0)
2112                         }
2113 
2114                         // Return properly scaled zxRound.
2115                         z := div(zxRound, scalar)
2116                     }
2117                 }
2118             }
2119         }
2120     }
2121 
2122     /*//////////////////////////////////////////////////////////////
2123                         GENERAL NUMBER UTILITIES
2124     //////////////////////////////////////////////////////////////*/
2125 
2126     function sqrt(uint256 x) internal pure returns (uint256 z) {
2127         assembly {
2128             // Start off with z at 1.
2129             z := 1
2130 
2131             // Used below to help find a nearby power of 2.
2132             let y := x
2133 
2134             // Find the lowest power of 2 that is at least sqrt(x).
2135             if iszero(lt(y, 0x100000000000000000000000000000000)) {
2136                 y := shr(128, y) // Like dividing by 2 ** 128.
2137                 z := shl(64, z) // Like multiplying by 2 ** 64.
2138             }
2139             if iszero(lt(y, 0x10000000000000000)) {
2140                 y := shr(64, y) // Like dividing by 2 ** 64.
2141                 z := shl(32, z) // Like multiplying by 2 ** 32.
2142             }
2143             if iszero(lt(y, 0x100000000)) {
2144                 y := shr(32, y) // Like dividing by 2 ** 32.
2145                 z := shl(16, z) // Like multiplying by 2 ** 16.
2146             }
2147             if iszero(lt(y, 0x10000)) {
2148                 y := shr(16, y) // Like dividing by 2 ** 16.
2149                 z := shl(8, z) // Like multiplying by 2 ** 8.
2150             }
2151             if iszero(lt(y, 0x100)) {
2152                 y := shr(8, y) // Like dividing by 2 ** 8.
2153                 z := shl(4, z) // Like multiplying by 2 ** 4.
2154             }
2155             if iszero(lt(y, 0x10)) {
2156                 y := shr(4, y) // Like dividing by 2 ** 4.
2157                 z := shl(2, z) // Like multiplying by 2 ** 2.
2158             }
2159             if iszero(lt(y, 0x8)) {
2160                 // Equivalent to 2 ** z.
2161                 z := shl(1, z)
2162             }
2163 
2164             // Shifting right by 1 is like dividing by 2.
2165             z := shr(1, add(z, div(x, z)))
2166             z := shr(1, add(z, div(x, z)))
2167             z := shr(1, add(z, div(x, z)))
2168             z := shr(1, add(z, div(x, z)))
2169             z := shr(1, add(z, div(x, z)))
2170             z := shr(1, add(z, div(x, z)))
2171             z := shr(1, add(z, div(x, z)))
2172 
2173             // Compute a rounded down version of z.
2174             let zRoundDown := div(x, z)
2175 
2176             // If zRoundDown is smaller, use it.
2177             if lt(zRoundDown, z) {
2178                 z := zRoundDown
2179             }
2180         }
2181     }
2182 } // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165Checker.sol)
2183 
2184 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2185 
2186 /**
2187  * @dev Interface of the ERC165 standard, as defined in the
2188  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2189  *
2190  * Implementers can declare support of contract interfaces, which can then be
2191  * queried by others ({ERC165Checker}).
2192  *
2193  * For an implementation, see {ERC165}.
2194  */
2195 interface IERC165 {
2196     /**
2197      * @dev Returns true if this contract implements the interface defined by
2198      * `interfaceId`. See the corresponding
2199      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2200      * to learn more about how these ids are created.
2201      *
2202      * This function call must use less than 30 000 gas.
2203      */
2204     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2205 }
2206 
2207 /**
2208  * @dev Library used to query support of an interface declared via {IERC165}.
2209  *
2210  * Note that these functions return the actual result of the query: they do not
2211  * `revert` if an interface is not supported. It is up to the caller to decide
2212  * what to do in these cases.
2213  */
2214 library ERC165Checker {
2215     // As per the EIP-165 spec, no interface should ever match 0xffffffff
2216     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
2217 
2218     /**
2219      * @dev Returns true if `account` supports the {IERC165} interface,
2220      */
2221     function supportsERC165(address account) internal view returns (bool) {
2222         // Any contract that implements ERC165 must explicitly indicate support of
2223         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
2224         return
2225             _supportsERC165Interface(account, type(IERC165).interfaceId) &&
2226             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
2227     }
2228 
2229     /**
2230      * @dev Returns true if `account` supports the interface defined by
2231      * `interfaceId`. Support for {IERC165} itself is queried automatically.
2232      *
2233      * See {IERC165-supportsInterface}.
2234      */
2235     function supportsInterface(address account, bytes4 interfaceId)
2236         internal
2237         view
2238         returns (bool)
2239     {
2240         // query support of both ERC165 as per the spec and support of _interfaceId
2241         return
2242             supportsERC165(account) &&
2243             _supportsERC165Interface(account, interfaceId);
2244     }
2245 
2246     /**
2247      * @dev Returns a boolean array where each value corresponds to the
2248      * interfaces passed in and whether they're supported or not. This allows
2249      * you to batch check interfaces for a contract where your expectation
2250      * is that some interfaces may not be supported.
2251      *
2252      * See {IERC165-supportsInterface}.
2253      *
2254      * _Available since v3.4._
2255      */
2256     function getSupportedInterfaces(
2257         address account,
2258         bytes4[] memory interfaceIds
2259     ) internal view returns (bool[] memory) {
2260         // an array of booleans corresponding to interfaceIds and whether they're supported or not
2261         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
2262 
2263         // query support of ERC165 itself
2264         if (supportsERC165(account)) {
2265             // query support of each interface in interfaceIds
2266             for (uint256 i = 0; i < interfaceIds.length; i++) {
2267                 interfaceIdsSupported[i] = _supportsERC165Interface(
2268                     account,
2269                     interfaceIds[i]
2270                 );
2271             }
2272         }
2273 
2274         return interfaceIdsSupported;
2275     }
2276 
2277     /**
2278      * @dev Returns true if `account` supports all the interfaces defined in
2279      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
2280      *
2281      * Batch-querying can lead to gas savings by skipping repeated checks for
2282      * {IERC165} support.
2283      *
2284      * See {IERC165-supportsInterface}.
2285      */
2286     function supportsAllInterfaces(
2287         address account,
2288         bytes4[] memory interfaceIds
2289     ) internal view returns (bool) {
2290         // query support of ERC165 itself
2291         if (!supportsERC165(account)) {
2292             return false;
2293         }
2294 
2295         // query support of each interface in _interfaceIds
2296         for (uint256 i = 0; i < interfaceIds.length; i++) {
2297             if (!_supportsERC165Interface(account, interfaceIds[i])) {
2298                 return false;
2299             }
2300         }
2301 
2302         // all interfaces supported
2303         return true;
2304     }
2305 
2306     /**
2307      * @notice Query if a contract implements an interface, does not check ERC165 support
2308      * @param account The address of the contract to query for support of an interface
2309      * @param interfaceId The interface identifier, as specified in ERC-165
2310      * @return true if the contract at account indicates support of the interface with
2311      * identifier interfaceId, false otherwise
2312      * @dev Assumes that account contains a contract that supports ERC165, otherwise
2313      * the behavior of this method is undefined. This precondition can be checked
2314      * with {supportsERC165}.
2315      * Interface identification is specified in ERC-165.
2316      */
2317     function _supportsERC165Interface(address account, bytes4 interfaceId)
2318         private
2319         view
2320         returns (bool)
2321     {
2322         bytes memory encodedParams = abi.encodeWithSelector(
2323             IERC165.supportsInterface.selector,
2324             interfaceId
2325         );
2326         (bool success, bytes memory result) = account.staticcall{gas: 30000}(
2327             encodedParams
2328         );
2329         if (result.length < 32) return false;
2330         return success && abi.decode(result, (bool));
2331     }
2332 }
2333 struct Rewards {
2334     uint256 sale;
2335     uint256 purchase;
2336     uint256 mint;
2337     uint256 ohmPurchase;
2338     uint256 ohmMint;
2339     uint256 multiplier;
2340 }
2341 
2342 struct NFT {
2343     address contractAddress;
2344     uint256 id;
2345 }
2346 
2347 enum NftType {
2348     ERC721,
2349     ERC1155
2350 }
2351 
2352 error OdysseyXpDirectory_Unauthorized();
2353 
2354 contract OdysseyXpDirectory {
2355     using ERC165Checker for address;
2356 
2357     Rewards public defaultRewards;
2358     mapping(address => Rewards) public erc721rewards;
2359     mapping(address => mapping(uint256 => Rewards)) public erc1155rewards;
2360     NFT[] public customRewardTokens;
2361     address public owner;
2362 
2363     constructor() {
2364         owner = msg.sender;
2365     }
2366 
2367     // modifier substitute
2368     function notOwner() internal view returns (bool) {
2369         return msg.sender != owner;
2370     }
2371 
2372     function transferOwnership(address newOwner) external {
2373         if (notOwner()) revert OdysseyXpDirectory_Unauthorized();
2374         owner = newOwner;
2375     }
2376 
2377     /*///////////////////////////////////////////////////////////////
2378                             Reward Setters
2379     //////////////////////////////////////////////////////////////*/
2380 
2381     /// @notice Set default rewards for contracts without a custom reward set
2382     /// @param sale XP reward for selling an NFT
2383     /// @param purchase XP reward for purchasing an NFT
2384     /// @param mint XP reward for minting an NFT
2385     /// @param ohmPurchase XP reward for purchasing an NFT with OHM
2386     /// @param ohmMint XP reward for minting an NFT with OHM
2387     /// @param multiplier XP reward multiplier for wallets holding an NFT
2388     function setDefaultRewards(
2389         uint256 sale,
2390         uint256 purchase,
2391         uint256 mint,
2392         uint256 ohmPurchase,
2393         uint256 ohmMint,
2394         uint256 multiplier
2395     ) public {
2396         if (notOwner()) revert OdysseyXpDirectory_Unauthorized();
2397         defaultRewards = Rewards(
2398             sale,
2399             purchase,
2400             mint,
2401             ohmPurchase,
2402             ohmMint,
2403             multiplier
2404         );
2405     }
2406 
2407     /// @notice Set custom rewards for an ERC721 contract
2408     /// @param sale XP reward for selling this NFT
2409     /// @param purchase XP reward for purchasing this NFT
2410     /// @param mint XP reward for minting this NFT
2411     /// @param ohmPurchase XP reward for purchasing this NFT with OHM
2412     /// @param ohmMint XP reward for minting this NFT with OHM
2413     /// @param multiplier XP reward multiplier for wallets holding this NFT
2414     function setErc721CustomRewards(
2415         address tokenAddress,
2416         uint256 sale,
2417         uint256 purchase,
2418         uint256 mint,
2419         uint256 ohmPurchase,
2420         uint256 ohmMint,
2421         uint256 multiplier
2422     ) public {
2423         if (notOwner()) revert OdysseyXpDirectory_Unauthorized();
2424         customRewardTokens.push(NFT(tokenAddress, 0));
2425         erc721rewards[tokenAddress] = Rewards(
2426             sale,
2427             purchase,
2428             mint,
2429             ohmPurchase,
2430             ohmMint,
2431             multiplier
2432         );
2433     }
2434 
2435     /// @notice Set custom rewards for an ERC1155 contract and token ID
2436     /// @param sale XP reward for selling this NFT
2437     /// @param purchase XP reward for purchasing this NFT
2438     /// @param mint XP reward for minting this NFT
2439     /// @param ohmPurchase XP reward for purchasing this NFT with OHM
2440     /// @param ohmMint XP reward for minting this NFT with OHM
2441     /// @param multiplier XP reward multiplier for wallets holding this NFT
2442     function setErc1155CustomRewards(
2443         address tokenAddress,
2444         uint256 tokenId,
2445         uint256 sale,
2446         uint256 purchase,
2447         uint256 mint,
2448         uint256 ohmPurchase,
2449         uint256 ohmMint,
2450         uint256 multiplier
2451     ) public {
2452         if (notOwner()) revert OdysseyXpDirectory_Unauthorized();
2453         customRewardTokens.push(NFT(tokenAddress, tokenId));
2454         erc1155rewards[tokenAddress][tokenId] = Rewards(
2455             sale,
2456             purchase,
2457             mint,
2458             ohmPurchase,
2459             ohmMint,
2460             multiplier
2461         );
2462     }
2463 
2464     /*///////////////////////////////////////////////////////////////
2465                             Reward Getters
2466     //////////////////////////////////////////////////////////////*/
2467 
2468     /// @notice Get the XP reward for selling an NFT
2469     /// @param seller Seller of the NFT
2470     /// @param contractAddress Address of the NFT being sold
2471     /// @param tokenId ID of the NFT being sold
2472     function getSaleReward(
2473         address seller,
2474         address contractAddress,
2475         uint256 tokenId
2476     ) public view returns (uint256) {
2477         (
2478             bool isCustomErc721,
2479             bool isCustomErc1155,
2480             uint256 multiplier
2481         ) = _getRewardDetails(seller, contractAddress, tokenId);
2482         if (isCustomErc721) {
2483             return erc721rewards[contractAddress].sale * multiplier;
2484         } else if (isCustomErc1155) {
2485             return erc1155rewards[contractAddress][tokenId].sale * multiplier;
2486         } else {
2487             return defaultRewards.sale * multiplier;
2488         }
2489     }
2490 
2491     /// @notice Get the XP reward for buying an NFT
2492     /// @param buyer Buyer of the NFT
2493     /// @param contractAddress Address of the NFT being sold
2494     /// @param tokenId ID of the NFT being sold
2495     function getPurchaseReward(
2496         address buyer,
2497         address contractAddress,
2498         uint256 tokenId
2499     ) public view returns (uint256) {
2500         (
2501             bool isCustomErc721,
2502             bool isCustomErc1155,
2503             uint256 multiplier
2504         ) = _getRewardDetails(buyer, contractAddress, tokenId);
2505         if (isCustomErc721) {
2506             return erc721rewards[contractAddress].purchase * multiplier;
2507         } else if (isCustomErc1155) {
2508             return
2509                 erc1155rewards[contractAddress][tokenId].purchase * multiplier;
2510         } else {
2511             return defaultRewards.purchase * multiplier;
2512         }
2513     }
2514 
2515     /// @notice Get the XP reward for minting an NFT
2516     /// @param buyer Buyer of the NFT
2517     /// @param contractAddress Address of the NFT being sold
2518     /// @param tokenId ID of the NFT being sold
2519     function getMintReward(
2520         address buyer,
2521         address contractAddress,
2522         uint256 tokenId
2523     ) public view returns (uint256) {
2524         (
2525             bool isCustomErc721,
2526             bool isCustomErc1155,
2527             uint256 multiplier
2528         ) = _getRewardDetails(buyer, contractAddress, tokenId);
2529         if (isCustomErc721) {
2530             return erc721rewards[contractAddress].mint * multiplier;
2531         } else if (isCustomErc1155) {
2532             return erc1155rewards[contractAddress][tokenId].mint * multiplier;
2533         } else {
2534             return defaultRewards.mint * multiplier;
2535         }
2536     }
2537 
2538     /// @notice Get the XP reward for buying an NFT with OHM
2539     /// @param buyer Buyer of the NFT
2540     /// @param contractAddress Address of the NFT being sold
2541     /// @param tokenId ID of the NFT being sold
2542     function getOhmPurchaseReward(
2543         address buyer,
2544         address contractAddress,
2545         uint256 tokenId
2546     ) public view returns (uint256) {
2547         (
2548             bool isCustomErc721,
2549             bool isCustomErc1155,
2550             uint256 multiplier
2551         ) = _getRewardDetails(buyer, contractAddress, tokenId);
2552         if (isCustomErc721) {
2553             return erc721rewards[contractAddress].ohmPurchase * multiplier;
2554         } else if (isCustomErc1155) {
2555             return
2556                 erc1155rewards[contractAddress][tokenId].ohmPurchase *
2557                 multiplier;
2558         } else {
2559             return defaultRewards.ohmPurchase * multiplier;
2560         }
2561     }
2562 
2563     /// @notice Get the XP reward for minting an NFT with OHM
2564     /// @param buyer Buyer of the NFT
2565     /// @param contractAddress Address of the NFT being sold
2566     /// @param tokenId ID of the NFT being sold
2567     function getOhmMintReward(
2568         address buyer,
2569         address contractAddress,
2570         uint256 tokenId
2571     ) public view returns (uint256) {
2572         (
2573             bool isCustomErc721,
2574             bool isCustomErc1155,
2575             uint256 multiplier
2576         ) = _getRewardDetails(buyer, contractAddress, tokenId);
2577         if (isCustomErc721) {
2578             return erc721rewards[contractAddress].ohmMint * multiplier;
2579         } else if (isCustomErc1155) {
2580             return
2581                 erc1155rewards[contractAddress][tokenId].ohmMint * multiplier;
2582         } else {
2583             return defaultRewards.ohmMint * multiplier;
2584         }
2585     }
2586 
2587     /// @notice Determine if an NFT has custom rewards and any multiplier based on the user's held NFTs
2588     /// @dev The multiplier and custom rewards are determined simultaneously to save on gas costs of iteration
2589     /// @param user Wallet address with potential multiplier NFTs
2590     /// @param contractAddress Address of the NFT being sold
2591     /// @param tokenId ID of the NFT being sold
2592     function _getRewardDetails(
2593         address user,
2594         address contractAddress,
2595         uint256 tokenId
2596     )
2597         internal
2598         view
2599         returns (
2600             bool isCustomErc721,
2601             bool isCustomErc1155,
2602             uint256 multiplier
2603         )
2604     {
2605         NFT[] memory _customRewardTokens = customRewardTokens; // save an SLOAD from length reading
2606         for (uint256 i = 0; i < _customRewardTokens.length; i++) {
2607             NFT memory token = _customRewardTokens[i];
2608             if (token.contractAddress.supportsInterface(0x80ac58cd)) {
2609                 // is ERC721
2610                 if (OdysseyERC721(token.contractAddress).balanceOf(user) > 0) {
2611                     uint256 reward = erc721rewards[token.contractAddress]
2612                         .multiplier;
2613                     multiplier = reward > 1 ? multiplier + reward : multiplier; // only increment if multiplier is non-one
2614                 }
2615                 if (contractAddress == token.contractAddress) {
2616                     isCustomErc721 = true;
2617                 }
2618             } else if (token.contractAddress.supportsInterface(0xd9b67a26)) {
2619                 // is isERC1155
2620                 if (
2621                     OdysseyERC1155(token.contractAddress).balanceOf(
2622                         user,
2623                         token.id
2624                     ) > 0
2625                 ) {
2626                     uint256 reward = erc1155rewards[token.contractAddress][
2627                         token.id
2628                     ].multiplier;
2629                     multiplier = reward > 1 ? multiplier + reward : multiplier; // only increment if multiplier is non-one
2630                     if (
2631                         contractAddress == token.contractAddress &&
2632                         tokenId == token.id
2633                     ) {
2634                         isCustomErc1155 = true;
2635                     }
2636                 }
2637             }
2638         }
2639         multiplier = multiplier == 0 ? defaultRewards.multiplier : multiplier; // if no custom multiplier, use default
2640         multiplier = multiplier > 4 ? 4 : multiplier; // multiplier caps at 4
2641     }
2642 }
2643 error OdysseyXp_Unauthorized();
2644 error OdysseyXp_NonTransferable();
2645 error OdysseyXp_ZeroAssets();
2646 
2647 contract OdysseyXp is ERC20 {
2648     using SafeTransferLib for ERC20;
2649     using FixedPointMathLib for uint256;
2650 
2651     struct UserHistory {
2652         uint256 balanceAtLastRedeem;
2653         uint256 globallyWithdrawnAtLastRedeem;
2654     }
2655 
2656     /*///////////////////////////////////////////////////////////////
2657                                  EVENTS
2658     //////////////////////////////////////////////////////////////*/
2659 
2660     event Mint(address indexed owner, uint256 assets, uint256 xp);
2661 
2662     event Redeem(address indexed owner, uint256 assets, uint256 xp);
2663 
2664     /*///////////////////////////////////////////////////////////////
2665                             STATE VARIABLES
2666     //////////////////////////////////////////////////////////////*/
2667 
2668     address public router;
2669     address public exchange;
2670     address public owner;
2671     uint256 public globallyWithdrawn;
2672     ERC20 public immutable asset;
2673     OdysseyXpDirectory public directory;
2674     mapping(address => UserHistory) public userHistories;
2675 
2676     constructor(
2677         ERC20 _asset,
2678         OdysseyXpDirectory _directory,
2679         address _router,
2680         address _exchange,
2681         address _owner
2682     ) ERC20("Odyssey XP", "XP", 0) {
2683         asset = _asset;
2684         directory = _directory;
2685         router = _router;
2686         exchange = _exchange;
2687         owner = _owner;
2688     }
2689 
2690     /*///////////////////////////////////////////////////////////////
2691                             MODIFIERS
2692     //////////////////////////////////////////////////////////////*/
2693 
2694     function notOwner() internal view returns (bool) {
2695         return msg.sender != owner;
2696     }
2697 
2698     function notRouter() internal view returns (bool) {
2699         return msg.sender != router;
2700     }
2701 
2702     function notExchange() internal view returns (bool) {
2703         return msg.sender != exchange;
2704     }
2705 
2706     /*///////////////////////////////////////////////////////////////
2707                         RESTRICTED SETTERS
2708     //////////////////////////////////////////////////////////////*/
2709 
2710     function setExchange(address _exchange) external {
2711         if (notOwner()) revert OdysseyXp_Unauthorized();
2712         exchange = _exchange;
2713     }
2714 
2715     function setRouter(address _router) external {
2716         if (notOwner()) revert OdysseyXp_Unauthorized();
2717         router = _router;
2718     }
2719 
2720     function setDirectory(address _directory) external {
2721         if (notOwner()) revert OdysseyXp_Unauthorized();
2722         directory = OdysseyXpDirectory(_directory);
2723     }
2724 
2725     function transferOwnership(address _newOwner) external {
2726         if (notOwner()) revert OdysseyXp_Unauthorized();
2727         owner = _newOwner;
2728     }
2729 
2730     /*///////////////////////////////////////////////////////////////
2731                         XP Granting Methods
2732     //////////////////////////////////////////////////////////////*/
2733 
2734     function saleReward(
2735         address seller,
2736         address contractAddress,
2737         uint256 tokenId
2738     ) external {
2739         if (notExchange()) revert OdysseyXp_Unauthorized();
2740         _grantXP(
2741             seller,
2742             directory.getSaleReward(seller, contractAddress, tokenId)
2743         );
2744     }
2745 
2746     function purchaseReward(
2747         address buyer,
2748         address contractAddress,
2749         uint256 tokenId
2750     ) external {
2751         if (notExchange()) revert OdysseyXp_Unauthorized();
2752         _grantXP(
2753             buyer,
2754             directory.getPurchaseReward(buyer, contractAddress, tokenId)
2755         );
2756     }
2757 
2758     function mintReward(
2759         address buyer,
2760         address contractAddress,
2761         uint256 tokenId
2762     ) external {
2763         if (notRouter()) revert OdysseyXp_Unauthorized();
2764         _grantXP(
2765             buyer,
2766             directory.getMintReward(buyer, contractAddress, tokenId)
2767         );
2768     }
2769 
2770     function ohmPurchaseReward(
2771         address buyer,
2772         address contractAddress,
2773         uint256 tokenId
2774     ) external {
2775         if (notExchange()) revert OdysseyXp_Unauthorized();
2776         _grantXP(
2777             buyer,
2778             directory.getOhmPurchaseReward(buyer, contractAddress, tokenId)
2779         );
2780     }
2781 
2782     function ohmMintReward(
2783         address buyer,
2784         address contractAddress,
2785         uint256 tokenId
2786     ) external {
2787         if (notRouter()) revert OdysseyXp_Unauthorized();
2788         _grantXP(
2789             buyer,
2790             directory.getOhmMintReward(buyer, contractAddress, tokenId)
2791         );
2792     }
2793 
2794     /*///////////////////////////////////////////////////////////////
2795                             MINT LOGIC
2796     //////////////////////////////////////////////////////////////*/
2797 
2798     /// @notice Grants the receiver the given amount of XP
2799     /// @dev Forces the receiver to redeem if they have rewards available
2800     /// @param receiver The address to grant XP to
2801     /// @param xp The amount of XP to grant
2802     function _grantXP(address receiver, uint256 xp)
2803         internal
2804         returns (uint256 assets)
2805     {
2806         uint256 currentXp = balanceOf[receiver];
2807         if ((assets = previewRedeem(receiver, currentXp)) > 0)
2808             _redeem(receiver, assets, currentXp); // force redeeming to keep portions in line
2809         else if (currentXp == 0)
2810             userHistories[receiver]
2811                 .globallyWithdrawnAtLastRedeem = globallyWithdrawn; // if a new user, adjust their history to calculate withdrawn at their first redeem
2812         _mint(receiver, xp);
2813 
2814         emit Mint(msg.sender, assets, xp);
2815 
2816         afterMint(assets, xp);
2817     }
2818 
2819     /*///////////////////////////////////////////////////////////////
2820                         REDEEM LOGIC
2821     //////////////////////////////////////////////////////////////*/
2822 
2823     /// @notice external redeem method
2824     /// @dev will revert if there is nothing to redeem
2825     function redeem() public returns (uint256 assets) {
2826         uint256 xp = balanceOf[msg.sender];
2827         if ((assets = previewRedeem(msg.sender, xp)) == 0)
2828             revert OdysseyXp_ZeroAssets();
2829         _redeem(msg.sender, assets, xp);
2830     }
2831 
2832     /// @notice Internal logic for redeeming rewards
2833     /// @param receiver The receiver of rewards
2834     /// @param assets The amount of assets to grant
2835     /// @param xp The amount of XP the user is redeeming with
2836     function _redeem(
2837         address receiver,
2838         uint256 assets,
2839         uint256 xp
2840     ) internal virtual {
2841         beforeRedeem(assets, xp);
2842 
2843         userHistories[receiver].balanceAtLastRedeem =
2844             asset.balanceOf(address(this)) -
2845             assets;
2846         userHistories[receiver].globallyWithdrawnAtLastRedeem =
2847             globallyWithdrawn +
2848             assets;
2849         globallyWithdrawn += assets;
2850 
2851         asset.safeTransfer(receiver, assets);
2852 
2853         emit Redeem(receiver, assets, xp);
2854     }
2855 
2856     /*///////////////////////////////////////////////////////////////
2857                            ACCOUNTING LOGIC
2858     //////////////////////////////////////////////////////////////*/
2859 
2860     /// @notice Preview the result of a redeem for the given user with the given XP amount
2861     /// @param recipient The user to check potential rewards for
2862     /// @param xp The amount of XP the user is previewing a redeem for
2863     function previewRedeem(address recipient, uint256 xp)
2864         public
2865         view
2866         virtual
2867         returns (uint256)
2868     {
2869         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
2870 
2871         return
2872             supply == 0 || xp == 0
2873                 ? 0
2874                 : xp.mulDivDown(totalAssets(recipient), supply);
2875     }
2876 
2877     /// @notice The total amount of available assets for the user, adjusted based on their history
2878     /// @param user The user to check assets for
2879     function totalAssets(address user) internal view returns (uint256) {
2880         uint256 balance = asset.balanceOf(address(this)); // Saves an extra SLOAD if balance is non-zero.
2881         return
2882             balance +
2883             (globallyWithdrawn -
2884                 userHistories[user].globallyWithdrawnAtLastRedeem) -
2885             userHistories[user].balanceAtLastRedeem;
2886     }
2887 
2888     /*///////////////////////////////////////////////////////////////
2889                        OVERRIDE TRANSFERABILITY
2890     //////////////////////////////////////////////////////////////*/
2891 
2892     function transfer(address to, uint256 amount)
2893         public
2894         override
2895         returns (bool)
2896     {
2897         revert OdysseyXp_NonTransferable();
2898     }
2899 
2900     function transferFrom(
2901         address from,
2902         address to,
2903         uint256 amount
2904     ) public override returns (bool) {
2905         revert OdysseyXp_NonTransferable();
2906     }
2907 
2908     /*///////////////////////////////////////////////////////////////
2909                          INTERNAL HOOKS LOGIC
2910     //////////////////////////////////////////////////////////////*/
2911 
2912     function beforeRedeem(uint256 assets, uint256 xp) internal virtual {}
2913 
2914     function afterMint(uint256 assets, uint256 xp) internal virtual {}
2915 }
2916 
2917 contract OdysseyLaunchPlatform is OdysseyDatabase, ReentrancyGuard {
2918     /*///////////////////////////////////////////////////////////////
2919                                 ACTIONS
2920     //////////////////////////////////////////////////////////////*/
2921     function mintERC721(
2922         bytes32[] calldata merkleProof,
2923         bytes32 merkleRoot,
2924         uint256 minPrice,
2925         uint256 mintsPerUser,
2926         address tokenAddress,
2927         address currency,
2928         uint8 v,
2929         bytes32 r,
2930         bytes32 s
2931     ) external payable nonReentrant {
2932         if (OdysseyTokenFactory(factory).tokenExists(tokenAddress) == 0) {
2933             revert OdysseyLaunchPlatform_TokenDoesNotExist();
2934         }
2935         if (whitelistClaimed721[tokenAddress][msg.sender] >= mintsPerUser) {
2936             revert OdysseyLaunchPlatform_AlreadyClaimed();
2937         }
2938         // Check if user is already reserved + paid
2939         if (isReserved721[tokenAddress][msg.sender] == 0) {
2940             if (
2941                 cumulativeSupply721[tokenAddress] >= maxSupply721[tokenAddress]
2942             ) {
2943                 revert OdysseyLaunchPlatform_MaxSupplyCap();
2944             }
2945             {
2946                 // Verify merkle root and minPrice signed by owner (all id's have same min price)
2947                 bytes32 hash = keccak256(
2948                     abi.encode(
2949                         MERKLE_TREE_ROOT_ERC721_TYPEHASH,
2950                         merkleRoot,
2951                         minPrice,
2952                         mintsPerUser,
2953                         tokenAddress,
2954                         currency
2955                     )
2956                 );
2957                 Signature.verify(
2958                     hash,
2959                     ownerOf[tokenAddress],
2960                     v,
2961                     r,
2962                     s,
2963                     domainSeparator[tokenAddress]
2964                 );
2965             }
2966             if (whitelistActive[tokenAddress] == 1) {
2967                 // Verify user whitelisted
2968                 MerkleWhiteList.verify(msg.sender, merkleProof, merkleRoot);
2969             }
2970             cumulativeSupply721[tokenAddress]++;
2971 
2972             OdysseyLib.Percentage storage percent = treasuryCommission[
2973                 tokenAddress
2974             ];
2975             uint256 commission = (minPrice * percent.numerator) /
2976                 percent.denominator;
2977 
2978             if (currency == address(0)) {
2979                 if (msg.value < minPrice) {
2980                     revert OdysseyLaunchPlatform_InsufficientFunds();
2981                 }
2982                 (bool treasurySuccess, ) = treasury.call{value: commission}("");
2983                 if (!treasurySuccess) {
2984                     revert OdysseyLaunchPlatform_TreasuryPayFailure();
2985                 }
2986                 (bool success, ) = royaltyRecipient[tokenAddress].call{
2987                     value: minPrice - commission
2988                 }("");
2989                 if (!success) {
2990                     revert OdysseyLaunchPlatform_FailedToPayEther();
2991                 }
2992             } else {
2993                 if (
2994                     ERC20(currency).allowance(msg.sender, address(this)) <
2995                     minPrice
2996                 ) {
2997                     revert OdysseyLaunchPlatform_InsufficientFunds();
2998                 }
2999                 bool result = ERC20(currency).transferFrom(
3000                     msg.sender,
3001                     treasury,
3002                     commission
3003                 );
3004                 if (!result) {
3005                     revert OdysseyLaunchPlatform_TreasuryPayFailure();
3006                 }
3007                 result = ERC20(currency).transferFrom(
3008                     msg.sender,
3009                     royaltyRecipient[tokenAddress],
3010                     minPrice - commission
3011                 );
3012                 if (!result) {
3013                     revert OdysseyLaunchPlatform_FailedToPayERC20();
3014                 }
3015                 if (ohmFamilyCurrencies[currency] == 1) {
3016                     OdysseyXp(xp).ohmMintReward(msg.sender, tokenAddress, 0);
3017                 }
3018             }
3019         } else {
3020             isReserved721[tokenAddress][msg.sender]--;
3021         }
3022         // Update State
3023         whitelistClaimed721[tokenAddress][msg.sender]++;
3024         OdysseyERC721(tokenAddress).mint(
3025             msg.sender,
3026             mintedSupply721[tokenAddress]++
3027         );
3028     }
3029 
3030     function reserveERC721(
3031         bytes32[] calldata merkleProof,
3032         bytes32 merkleRoot,
3033         uint256 minPrice,
3034         uint256 mintsPerUser,
3035         address tokenAddress,
3036         address currency,
3037         uint8 v,
3038         bytes32 r,
3039         bytes32 s
3040     ) external payable nonReentrant {
3041         if (OdysseyTokenFactory(factory).tokenExists(tokenAddress) == 0) {
3042             revert OdysseyLaunchPlatform_TokenDoesNotExist();
3043         }
3044         if (cumulativeSupply721[tokenAddress] >= maxSupply721[tokenAddress]) {
3045             revert OdysseyLaunchPlatform_MaxSupplyCap();
3046         }
3047         if (
3048             isReserved721[tokenAddress][msg.sender] +
3049                 whitelistClaimed721[tokenAddress][msg.sender] >=
3050             mintsPerUser
3051         ) {
3052             revert OdysseyLaunchPlatform_ReservedOrClaimedMax();
3053         }
3054         {
3055             // Verify merkle root and minPrice signed by owner (all id's have same min price)
3056             bytes32 hash = keccak256(
3057                 abi.encode(
3058                     MERKLE_TREE_ROOT_ERC721_TYPEHASH,
3059                     merkleRoot,
3060                     minPrice,
3061                     mintsPerUser,
3062                     tokenAddress,
3063                     currency
3064                 )
3065             );
3066             Signature.verify(
3067                 hash,
3068                 ownerOf[tokenAddress],
3069                 v,
3070                 r,
3071                 s,
3072                 domainSeparator[tokenAddress]
3073             );
3074         }
3075         if (whitelistActive[tokenAddress] == 1) {
3076             // Verify user whitelisted
3077             MerkleWhiteList.verify(msg.sender, merkleProof, merkleRoot);
3078         }
3079 
3080         // Set user is reserved
3081         isReserved721[tokenAddress][msg.sender]++;
3082         // Increate Reserved + minted supply
3083         cumulativeSupply721[tokenAddress]++;
3084 
3085         OdysseyLib.Percentage storage percent = treasuryCommission[
3086             tokenAddress
3087         ];
3088         uint256 commission = (minPrice * percent.numerator) /
3089             percent.denominator;
3090 
3091         if (currency == address(0)) {
3092             if (msg.value < minPrice) {
3093                 revert OdysseyLaunchPlatform_InsufficientFunds();
3094             }
3095             (bool treasurySuccess, ) = treasury.call{value: commission}("");
3096             if (!treasurySuccess) {
3097                 revert OdysseyLaunchPlatform_TreasuryPayFailure();
3098             }
3099             (bool success, ) = royaltyRecipient[tokenAddress].call{
3100                 value: minPrice - commission
3101             }("");
3102             if (!success) {
3103                 revert OdysseyLaunchPlatform_FailedToPayEther();
3104             }
3105         } else {
3106             if (
3107                 ERC20(currency).allowance(msg.sender, address(this)) < minPrice
3108             ) {
3109                 revert OdysseyLaunchPlatform_InsufficientFunds();
3110             }
3111             bool result = ERC20(currency).transferFrom(
3112                 msg.sender,
3113                 treasury,
3114                 commission
3115             );
3116             if (!result) {
3117                 revert OdysseyLaunchPlatform_TreasuryPayFailure();
3118             }
3119             result = ERC20(currency).transferFrom(
3120                 msg.sender,
3121                 royaltyRecipient[tokenAddress],
3122                 minPrice - commission
3123             );
3124             if (!result) {
3125                 revert OdysseyLaunchPlatform_FailedToPayERC20();
3126             }
3127             if (ohmFamilyCurrencies[currency] == 1) {
3128                 OdysseyXp(xp).ohmMintReward(msg.sender, tokenAddress, 0);
3129             }
3130         }
3131     }
3132 
3133     function mintERC1155(
3134         bytes32[] calldata merkleProof,
3135         bytes32 merkleRoot,
3136         uint256 minPrice,
3137         uint256 mintsPerUser,
3138         uint256 tokenId,
3139         address tokenAddress,
3140         address currency,
3141         uint8 v,
3142         bytes32 r,
3143         bytes32 s
3144     ) external payable nonReentrant {
3145         if (OdysseyTokenFactory(factory).tokenExists(tokenAddress) == 0) {
3146             revert OdysseyLaunchPlatform_TokenDoesNotExist();
3147         }
3148         if (
3149             whitelistClaimed1155[tokenAddress][msg.sender][tokenId] >=
3150             mintsPerUser
3151         ) {
3152             revert OdysseyLaunchPlatform_AlreadyClaimed();
3153         }
3154         // Check if user is already reserved + paid
3155         if (isReserved1155[tokenAddress][msg.sender][tokenId] == 0) {
3156             if (
3157                 cumulativeSupply1155[tokenAddress][tokenId] >=
3158                 maxSupply1155[tokenAddress][tokenId]
3159             ) {
3160                 revert OdysseyLaunchPlatform_MaxSupplyCap();
3161             }
3162             {
3163                 // Verify merkle root and minPrice signed by owner (all id's have same min price)
3164                 bytes32 hash = keccak256(
3165                     abi.encode(
3166                         MERKLE_TREE_ROOT_ERC1155_TYPEHASH,
3167                         merkleRoot,
3168                         minPrice,
3169                         mintsPerUser,
3170                         tokenId,
3171                         tokenAddress,
3172                         currency
3173                     )
3174                 );
3175                 Signature.verify(
3176                     hash,
3177                     ownerOf[tokenAddress],
3178                     v,
3179                     r,
3180                     s,
3181                     domainSeparator[tokenAddress]
3182                 );
3183             }
3184 
3185             if (whitelistActive[tokenAddress] == 1) {
3186                 // Verify user whitelisted
3187                 MerkleWhiteList.verify(msg.sender, merkleProof, merkleRoot);
3188             }
3189             cumulativeSupply1155[tokenAddress][tokenId]++;
3190 
3191             OdysseyLib.Percentage storage percent = treasuryCommission[
3192                 tokenAddress
3193             ];
3194             uint256 commission = (minPrice * percent.numerator) /
3195                 percent.denominator;
3196 
3197             if (currency == address(0)) {
3198                 if (msg.value < minPrice) {
3199                     revert OdysseyLaunchPlatform_InsufficientFunds();
3200                 }
3201                 (bool treasurySuccess, ) = treasury.call{value: commission}("");
3202                 if (!treasurySuccess) {
3203                     revert OdysseyLaunchPlatform_TreasuryPayFailure();
3204                 }
3205                 (bool success, ) = royaltyRecipient[tokenAddress].call{
3206                     value: minPrice - commission
3207                 }("");
3208                 if (!success) {
3209                     revert OdysseyLaunchPlatform_FailedToPayEther();
3210                 }
3211             } else {
3212                 if (
3213                     ERC20(currency).allowance(msg.sender, address(this)) <
3214                     minPrice
3215                 ) {
3216                     revert OdysseyLaunchPlatform_InsufficientFunds();
3217                 }
3218                 bool result = ERC20(currency).transferFrom(
3219                     msg.sender,
3220                     treasury,
3221                     commission
3222                 );
3223                 if (!result) {
3224                     revert OdysseyLaunchPlatform_TreasuryPayFailure();
3225                 }
3226                 result = ERC20(currency).transferFrom(
3227                     msg.sender,
3228                     royaltyRecipient[tokenAddress],
3229                     minPrice - commission
3230                 );
3231                 if (!result) {
3232                     revert OdysseyLaunchPlatform_FailedToPayERC20();
3233                 }
3234                 if (ohmFamilyCurrencies[currency] == 1) {
3235                     OdysseyXp(xp).ohmMintReward(
3236                         msg.sender,
3237                         tokenAddress,
3238                         tokenId
3239                     );
3240                 }
3241             }
3242         } else {
3243             isReserved1155[tokenAddress][msg.sender][tokenId]--;
3244         }
3245         // Update State
3246         whitelistClaimed1155[tokenAddress][msg.sender][tokenId]++;
3247 
3248         OdysseyERC1155(tokenAddress).mint(msg.sender, tokenId);
3249     }
3250 
3251     function reserveERC1155(
3252         bytes32[] calldata merkleProof,
3253         bytes32 merkleRoot,
3254         uint256 minPrice,
3255         uint256 mintsPerUser,
3256         uint256 tokenId,
3257         address tokenAddress,
3258         address currency,
3259         uint8 v,
3260         bytes32 r,
3261         bytes32 s
3262     ) external payable nonReentrant {
3263         if (OdysseyTokenFactory(factory).tokenExists(tokenAddress) == 0) {
3264             revert OdysseyLaunchPlatform_TokenDoesNotExist();
3265         }
3266         if (
3267             cumulativeSupply1155[tokenAddress][tokenId] >=
3268             maxSupply1155[tokenAddress][tokenId]
3269         ) {
3270             revert OdysseyLaunchPlatform_MaxSupplyCap();
3271         }
3272         if (
3273             isReserved1155[tokenAddress][msg.sender][tokenId] +
3274                 whitelistClaimed1155[tokenAddress][msg.sender][tokenId] >=
3275             mintsPerUser
3276         ) {
3277             revert OdysseyLaunchPlatform_ReservedOrClaimedMax();
3278         }
3279         {
3280             // Verify merkle root and minPrice signed by owner (all id's have same min price)
3281             bytes32 hash = keccak256(
3282                 abi.encode(
3283                     MERKLE_TREE_ROOT_ERC1155_TYPEHASH,
3284                     merkleRoot,
3285                     minPrice,
3286                     mintsPerUser,
3287                     tokenId,
3288                     tokenAddress,
3289                     currency
3290                 )
3291             );
3292             Signature.verify(
3293                 hash,
3294                 ownerOf[tokenAddress],
3295                 v,
3296                 r,
3297                 s,
3298                 domainSeparator[tokenAddress]
3299             );
3300         }
3301 
3302         if (whitelistActive[tokenAddress] == 1) {
3303             // Verify user whitelisted
3304             MerkleWhiteList.verify(msg.sender, merkleProof, merkleRoot);
3305         }
3306 
3307         // Set user is reserved
3308         isReserved1155[tokenAddress][msg.sender][tokenId]++;
3309         // Increase Reserved + minted supply
3310         cumulativeSupply1155[tokenAddress][tokenId]++;
3311 
3312         OdysseyLib.Percentage storage percent = treasuryCommission[
3313             tokenAddress
3314         ];
3315         uint256 commission = (minPrice * percent.numerator) /
3316             percent.denominator;
3317 
3318         if (currency == address(0)) {
3319             if (msg.value < minPrice) {
3320                 revert OdysseyLaunchPlatform_InsufficientFunds();
3321             }
3322             (bool treasurySuccess, ) = treasury.call{value: commission}("");
3323             if (!treasurySuccess) {
3324                 revert OdysseyLaunchPlatform_TreasuryPayFailure();
3325             }
3326             (bool success, ) = royaltyRecipient[tokenAddress].call{
3327                 value: minPrice - commission
3328             }("");
3329             if (!success) {
3330                 revert OdysseyLaunchPlatform_FailedToPayEther();
3331             }
3332         } else {
3333             if (
3334                 ERC20(currency).allowance(msg.sender, address(this)) < minPrice
3335             ) {
3336                 revert OdysseyLaunchPlatform_InsufficientFunds();
3337             }
3338             bool result = ERC20(currency).transferFrom(
3339                 msg.sender,
3340                 treasury,
3341                 commission
3342             );
3343             if (!result) {
3344                 revert OdysseyLaunchPlatform_TreasuryPayFailure();
3345             }
3346             result = ERC20(currency).transferFrom(
3347                 msg.sender,
3348                 royaltyRecipient[tokenAddress],
3349                 minPrice - commission
3350             );
3351             if (!result) {
3352                 revert OdysseyLaunchPlatform_FailedToPayERC20();
3353             }
3354             if (ohmFamilyCurrencies[currency] == 1) {
3355                 OdysseyXp(xp).ohmMintReward(msg.sender, tokenAddress, tokenId);
3356             }
3357         }
3358     }
3359 
3360     function setWhitelistStatus(address addr, bool active)
3361         external
3362         nonReentrant
3363     {
3364         if (OdysseyTokenFactory(factory).tokenExists(addr) == 0) {
3365             revert OdysseyLaunchPlatform_TokenDoesNotExist();
3366         }
3367         whitelistActive[addr] = active ? 1 : 0;
3368     }
3369 
3370     function mint721OnCreate(uint256 amount, address token)
3371         external
3372         nonReentrant
3373     {
3374         cumulativeSupply721[token] = amount;
3375         mintedSupply721[token] = amount;
3376         uint256 i;
3377         for (; i < amount; ++i) {
3378             OdysseyERC721(token).mint(msg.sender, i);
3379         }
3380     }
3381 
3382     function mint1155OnCreate(
3383         uint256[] calldata tokenIds,
3384         uint256[] calldata amounts,
3385         address token
3386     ) external nonReentrant {
3387         uint256 i;
3388         for (; i < tokenIds.length; ++i) {
3389             cumulativeSupply1155[token][tokenIds[i]] = amounts[i];
3390             OdysseyERC1155(token).mintBatch(
3391                 msg.sender,
3392                 tokenIds[i],
3393                 amounts[i]
3394             );
3395         }
3396     }
3397 
3398     function ownerMint721(address token, address to) external nonReentrant {
3399         if (cumulativeSupply721[token] >= maxSupply721[token]) {
3400             revert OdysseyLaunchPlatform_MaxSupplyCap();
3401         }
3402         cumulativeSupply721[token]++;
3403         OdysseyERC721(token).mint(to, mintedSupply721[token]++);
3404     }
3405 
3406     function ownerMint1155(
3407         uint256 id,
3408         uint256 amount,
3409         address token,
3410         address to
3411     ) external nonReentrant {
3412         if (
3413             cumulativeSupply1155[token][id] + amount > maxSupply1155[token][id]
3414         ) {
3415             revert OdysseyLaunchPlatform_MaxSupplyCap();
3416         }
3417         cumulativeSupply1155[token][id] += amount;
3418         OdysseyERC1155(token).mintBatch(to, id, amount);
3419     }
3420 }
3421 
3422 contract OdysseyRouter is OdysseyDatabase, ReentrancyGuard {
3423     error OdysseyRouter_TokenIDSupplyMismatch();
3424     error OdysseyRouter_WhitelistUpdateFail();
3425     error OdysseyRouter_Unauthorized();
3426     error OdysseyRouter_OwnerMintFailure();
3427     error OdysseyRouter_BadTokenAddress();
3428     error OdysseyRouter_BadOwnerAddress();
3429     error OdysseyRouter_BadSenderAddress();
3430     error OdysseyRouter_BadRecipientAddress();
3431     error OdysseyRouter_BadTreasuryAddress();
3432     error OdysseyRouter_BadAdminAddress();
3433 
3434     constructor(
3435         address treasury_,
3436         address xpDirectory_,
3437         address xp_,
3438         address[] memory ohmCurrencies_
3439     ) {
3440         launchPlatform = address(new OdysseyLaunchPlatform());
3441         factory = address(new OdysseyTokenFactory());
3442         treasury = treasury_;
3443         admin = msg.sender;
3444         uint256 i;
3445         for (; i < ohmCurrencies_.length; i++) {
3446             ohmFamilyCurrencies[ohmCurrencies_[i]] = 1;
3447         }
3448         if (xp_ == address(0)) {
3449             if (xpDirectory_ == address(0)) {
3450                 xpDirectory_ = address(new OdysseyXpDirectory());
3451                 OdysseyXpDirectory(xpDirectory_).setDefaultRewards(
3452                     1,
3453                     1,
3454                     1,
3455                     3,
3456                     3,
3457                     1
3458                 );
3459                 OdysseyXpDirectory(xpDirectory_).transferOwnership(admin);
3460             }
3461             xp_ = address(
3462                 new OdysseyXp(
3463                     ERC20(ohmCurrencies_[0]),
3464                     OdysseyXpDirectory(xpDirectory_),
3465                     address(this),
3466                     address(this),
3467                     admin
3468                 )
3469             );
3470         }
3471         xp = xp_;
3472     }
3473 
3474     function Factory() public view returns (OdysseyTokenFactory) {
3475         return OdysseyTokenFactory(readSlotAsAddress(1));
3476     }
3477 
3478     function create1155(
3479         string calldata name,
3480         string calldata symbol,
3481         string calldata baseURI,
3482         OdysseyLib.Odyssey1155Info calldata info,
3483         OdysseyLib.Percentage calldata treasuryPercentage,
3484         address royaltyReceiver,
3485         bool whitelist
3486     ) external returns (address token) {
3487         if (info.maxSupply.length != info.tokenIds.length) {
3488             revert OdysseyRouter_TokenIDSupplyMismatch();
3489         }
3490         token = Factory().create1155(msg.sender, name, symbol, baseURI);
3491         ownerOf[token] = msg.sender;
3492         whitelistActive[token] = whitelist ? 1 : 0;
3493         royaltyRecipient[token] = royaltyReceiver;
3494         uint256 i;
3495         for (; i < info.tokenIds.length; ++i) {
3496             maxSupply1155[token][info.tokenIds[i]] = (info.maxSupply[i] == 0)
3497                 ? type(uint256).max
3498                 : info.maxSupply[i];
3499         }
3500 
3501         domainSeparator[token] = keccak256(
3502             abi.encode(
3503                 // keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
3504                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
3505                 keccak256(bytes(Strings.toHexString(uint160(token)))),
3506                 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1"))
3507                 block.chainid,
3508                 token
3509             )
3510         );
3511 
3512         if (OdysseyLib.compareDefaultPercentage(treasuryPercentage)) {
3513             // Treasury % was greater than 3/100
3514             treasuryCommission[token] = treasuryPercentage;
3515         } else {
3516             // Treasury % was less than 3/100, using 3/100 as default
3517             treasuryCommission[token] = OdysseyLib.Percentage(3, 100);
3518         }
3519 
3520         if (info.reserveAmounts.length > 0) {
3521             (bool success, bytes memory data) = launchPlatform.delegatecall(
3522                 abi.encodeWithSignature(
3523                     "mint1155OnCreate(uint256[],uint256[],address)",
3524                     info.tokenIds,
3525                     info.reserveAmounts,
3526                     token
3527                 )
3528             );
3529             if (!success) {
3530                 if (data.length == 0) revert();
3531                 assembly {
3532                     revert(add(32, data), mload(data))
3533                 }
3534             }
3535         }
3536         return token;
3537     }
3538 
3539     function create721(
3540         string calldata name,
3541         string calldata symbol,
3542         string calldata baseURI,
3543         uint256 maxSupply,
3544         uint256 reserveAmount,
3545         OdysseyLib.Percentage calldata treasuryPercentage,
3546         address royaltyReceiver,
3547         bool whitelist
3548     ) external returns (address token) {
3549         token = Factory().create721(msg.sender, name, symbol, baseURI);
3550         ownerOf[token] = msg.sender;
3551         maxSupply721[token] = (maxSupply == 0) ? type(uint256).max : maxSupply;
3552         whitelistActive[token] = whitelist ? 1 : 0;
3553         royaltyRecipient[token] = royaltyReceiver;
3554         domainSeparator[token] = keccak256(
3555             abi.encode(
3556                 // keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
3557                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
3558                 keccak256(bytes(Strings.toHexString(uint160(token)))),
3559                 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6, // keccak256(bytes("1"))
3560                 block.chainid,
3561                 token
3562             )
3563         );
3564 
3565         if (OdysseyLib.compareDefaultPercentage(treasuryPercentage)) {
3566             // Treasury % was greater than 3/100
3567             treasuryCommission[token] = treasuryPercentage;
3568         } else {
3569             // Treasury % was less than 3/100, using 3/100 as default
3570             treasuryCommission[token] = OdysseyLib.Percentage(3, 100);
3571         }
3572 
3573         if (reserveAmount > 0) {
3574             (bool success, bytes memory data) = launchPlatform.delegatecall(
3575                 abi.encodeWithSignature(
3576                     "mint721OnCreate(uint256,address)",
3577                     reserveAmount,
3578                     token
3579                 )
3580             );
3581             if (!success) {
3582                 if (data.length == 0) revert();
3583                 assembly {
3584                     revert(add(32, data), mload(data))
3585                 }
3586             }
3587         }
3588 
3589         return token;
3590     }
3591 
3592     function mintERC721(
3593         bytes32[] calldata merkleProof,
3594         bytes32 merkleRoot,
3595         uint256 minPrice,
3596         uint256 mintsPerUser,
3597         address tokenAddress,
3598         address currency,
3599         uint8 v,
3600         bytes32 r,
3601         bytes32 s
3602     ) public payable {
3603         (bool success, bytes memory data) = launchPlatform.delegatecall(
3604             abi.encodeWithSignature(
3605                 "mintERC721(bytes32[],bytes32,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3606                 merkleProof,
3607                 merkleRoot,
3608                 minPrice,
3609                 mintsPerUser,
3610                 tokenAddress,
3611                 currency,
3612                 v,
3613                 r,
3614                 s
3615             )
3616         );
3617         if (!success) {
3618             if (data.length == 0) revert();
3619             assembly {
3620                 revert(add(32, data), mload(data))
3621             }
3622         }
3623     }
3624 
3625     function batchMintERC721(OdysseyLib.BatchMint calldata batch)
3626         public
3627         payable
3628     {
3629         for (uint256 i = 0; i < batch.tokenAddress.length; i++) {
3630             (bool success, bytes memory data) = launchPlatform.delegatecall(
3631                 abi.encodeWithSignature(
3632                     "mintERC721(bytes32[],bytes32,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3633                     batch.merkleProof[i],
3634                     batch.merkleRoot[i],
3635                     batch.minPrice[i],
3636                     batch.mintsPerUser[i],
3637                     batch.tokenAddress[i],
3638                     batch.currency[i],
3639                     batch.v[i],
3640                     batch.r[i],
3641                     batch.s[i]
3642                 )
3643             );
3644             if (!success) {
3645                 if (data.length == 0) revert();
3646                 assembly {
3647                     revert(add(32, data), mload(data))
3648                 }
3649             }
3650         }
3651     }
3652 
3653     function reserveERC721(
3654         bytes32[] calldata merkleProof,
3655         bytes32 merkleRoot,
3656         uint256 minPrice,
3657         uint256 mintsPerUser,
3658         address tokenAddress,
3659         address currency,
3660         uint8 v,
3661         bytes32 r,
3662         bytes32 s
3663     ) public payable {
3664         (bool success, bytes memory data) = launchPlatform.delegatecall(
3665             abi.encodeWithSignature(
3666                 "reserveERC721(bytes32[],bytes32,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3667                 merkleProof,
3668                 merkleRoot,
3669                 minPrice,
3670                 mintsPerUser,
3671                 tokenAddress,
3672                 currency,
3673                 v,
3674                 r,
3675                 s
3676             )
3677         );
3678         if (!success) {
3679             if (data.length == 0) revert();
3680             assembly {
3681                 revert(add(32, data), mload(data))
3682             }
3683         }
3684     }
3685 
3686     function batchReserveERC721(OdysseyLib.BatchMint calldata batch)
3687         public
3688         payable
3689     {
3690         for (uint256 i = 0; i < batch.tokenAddress.length; i++) {
3691             (bool success, bytes memory data) = launchPlatform.delegatecall(
3692                 abi.encodeWithSignature(
3693                     "reserveERC721(bytes32[],bytes32,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3694                     batch.merkleProof[i],
3695                     batch.merkleRoot[i],
3696                     batch.minPrice[i],
3697                     batch.mintsPerUser[i],
3698                     batch.tokenAddress[i],
3699                     batch.currency[i],
3700                     batch.v[i],
3701                     batch.r[i],
3702                     batch.s[i]
3703                 )
3704             );
3705             if (!success) {
3706                 if (data.length == 0) revert();
3707                 assembly {
3708                     revert(add(32, data), mload(data))
3709                 }
3710             }
3711         }
3712     }
3713 
3714     function mintERC1155(
3715         bytes32[] calldata merkleProof,
3716         bytes32 merkleRoot,
3717         uint256 minPrice,
3718         uint256 mintsPerUser,
3719         uint256 tokenId,
3720         address tokenAddress,
3721         address currency,
3722         uint8 v,
3723         bytes32 r,
3724         bytes32 s
3725     ) public payable {
3726         (bool success, bytes memory data) = launchPlatform.delegatecall(
3727             abi.encodeWithSignature(
3728                 "mintERC1155(bytes32[],bytes32,uint256,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3729                 merkleProof,
3730                 merkleRoot,
3731                 minPrice,
3732                 mintsPerUser,
3733                 tokenId,
3734                 tokenAddress,
3735                 currency,
3736                 v,
3737                 r,
3738                 s
3739             )
3740         );
3741         if (!success) {
3742             if (data.length == 0) revert();
3743             assembly {
3744                 revert(add(32, data), mload(data))
3745             }
3746         }
3747     }
3748 
3749     function batchMintERC1155(OdysseyLib.BatchMint calldata batch)
3750         public
3751         payable
3752     {
3753         for (uint256 i = 0; i < batch.tokenAddress.length; i++) {
3754             (bool success, bytes memory data) = launchPlatform.delegatecall(
3755                 abi.encodeWithSignature(
3756                     "mintERC1155(bytes32[],bytes32,uint256,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3757                     batch.merkleProof[i],
3758                     batch.merkleRoot[i],
3759                     batch.minPrice[i],
3760                     batch.mintsPerUser[i],
3761                     batch.tokenId[i],
3762                     batch.tokenAddress[i],
3763                     batch.currency[i],
3764                     batch.v[i],
3765                     batch.r[i],
3766                     batch.s[i]
3767                 )
3768             );
3769             if (!success) {
3770                 if (data.length == 0) revert();
3771                 assembly {
3772                     revert(add(32, data), mload(data))
3773                 }
3774             }
3775         }
3776     }
3777 
3778     function reserveERC1155(
3779         bytes32[] calldata merkleProof,
3780         bytes32 merkleRoot,
3781         uint256 minPrice,
3782         uint256 mintsPerUser,
3783         uint256 tokenId,
3784         address tokenAddress,
3785         address currency,
3786         uint8 v,
3787         bytes32 r,
3788         bytes32 s
3789     ) public payable {
3790         (bool success, bytes memory data) = launchPlatform.delegatecall(
3791             abi.encodeWithSignature(
3792                 "reserveERC1155(bytes32[],bytes32,uint256,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3793                 merkleProof,
3794                 merkleRoot,
3795                 minPrice,
3796                 mintsPerUser,
3797                 tokenId,
3798                 tokenAddress,
3799                 currency,
3800                 v,
3801                 r,
3802                 s
3803             )
3804         );
3805         if (!success) {
3806             if (data.length == 0) revert();
3807             assembly {
3808                 revert(add(32, data), mload(data))
3809             }
3810         }
3811     }
3812 
3813     function batchReserveERC1155(OdysseyLib.BatchMint calldata batch)
3814         public
3815         payable
3816     {
3817         for (uint256 i = 0; i < batch.tokenAddress.length; i++) {
3818             (bool success, bytes memory data) = launchPlatform.delegatecall(
3819                 abi.encodeWithSignature(
3820                     "reserveERC1155(bytes32[],bytes32,uint256,uint256,uint256,address,address,uint8,bytes32,bytes32)",
3821                     batch.merkleProof[i],
3822                     batch.merkleRoot[i],
3823                     batch.minPrice[i],
3824                     batch.mintsPerUser[i],
3825                     batch.tokenId[i],
3826                     batch.tokenAddress[i],
3827                     batch.currency[i],
3828                     batch.v[i],
3829                     batch.r[i],
3830                     batch.s[i]
3831                 )
3832             );
3833             if (!success) {
3834                 if (data.length == 0) revert();
3835                 assembly {
3836                     revert(add(32, data), mload(data))
3837                 }
3838             }
3839         }
3840     }
3841 
3842     function setWhitelistStatus(address addr, bool active) public {
3843         if (msg.sender != ownerOf[addr]) {
3844             revert OdysseyRouter_Unauthorized();
3845         }
3846         (bool success, ) = launchPlatform.delegatecall(
3847             abi.encodeWithSignature(
3848                 "setWhitelistStatus(address,bool)",
3849                 addr,
3850                 active
3851             )
3852         );
3853         if (!success) {
3854             revert OdysseyRouter_WhitelistUpdateFail();
3855         }
3856     }
3857 
3858     function ownerMint721(address token, address to) public {
3859         if (ownerOf[token] != msg.sender) {
3860             revert OdysseyRouter_Unauthorized();
3861         }
3862         (bool success, ) = launchPlatform.delegatecall(
3863             abi.encodeWithSignature("ownerMint721(address,address)", token, to)
3864         );
3865         if (!success) {
3866             revert OdysseyRouter_OwnerMintFailure();
3867         }
3868     }
3869 
3870     function ownerMint1155(
3871         uint256 id,
3872         uint256 amount,
3873         address token,
3874         address to
3875     ) public {
3876         if (ownerOf[token] != msg.sender) {
3877             revert OdysseyRouter_Unauthorized();
3878         }
3879         (bool success, ) = launchPlatform.delegatecall(
3880             abi.encodeWithSignature(
3881                 "ownerMint1155(uint256,uint256,address,address)",
3882                 id,
3883                 amount,
3884                 token,
3885                 to
3886             )
3887         );
3888         if (!success) {
3889             revert OdysseyRouter_OwnerMintFailure();
3890         }
3891     }
3892 
3893     function setOwnerShip(address token, address newOwner) public {
3894         if (token == address(0)) {
3895             revert OdysseyRouter_BadTokenAddress();
3896         }
3897         if (newOwner == address(0)) {
3898             revert OdysseyRouter_BadOwnerAddress();
3899         }
3900         if (msg.sender == address(0)) {
3901             revert OdysseyRouter_BadSenderAddress();
3902         }
3903         if (ownerOf[token] != msg.sender) {
3904             revert OdysseyRouter_Unauthorized();
3905         }
3906         ownerOf[token] = newOwner;
3907     }
3908 
3909     function setRoyaltyRecipient(address token, address recipient) public {
3910         if (token == address(0)) {
3911             revert OdysseyRouter_BadTokenAddress();
3912         }
3913         if (recipient == address(0)) {
3914             revert OdysseyRouter_BadRecipientAddress();
3915         }
3916         if (msg.sender == address(0)) {
3917             revert OdysseyRouter_BadSenderAddress();
3918         }
3919         if (ownerOf[token] != msg.sender) {
3920             revert OdysseyRouter_Unauthorized();
3921         }
3922         royaltyRecipient[token] = recipient;
3923     }
3924 
3925     function setTreasury(address newTreasury) public {
3926         if (msg.sender != admin) {
3927             revert OdysseyRouter_Unauthorized();
3928         }
3929         if (msg.sender == address(0)) {
3930             revert OdysseyRouter_BadSenderAddress();
3931         }
3932         if (newTreasury == address(0)) {
3933             revert OdysseyRouter_BadTreasuryAddress();
3934         }
3935         treasury = newTreasury;
3936     }
3937 
3938     function setXP(address newXp) public {
3939         if (msg.sender != admin) {
3940             revert OdysseyRouter_Unauthorized();
3941         }
3942         if (msg.sender == address(0)) {
3943             revert OdysseyRouter_BadSenderAddress();
3944         }
3945         if (newXp == address(0)) {
3946             revert OdysseyRouter_BadTokenAddress();
3947         }
3948         xp = newXp;
3949     }
3950 
3951     function setAdmin(address newAdmin) public {
3952         if (msg.sender != admin) {
3953             revert OdysseyRouter_Unauthorized();
3954         }
3955         if (msg.sender == address(0)) {
3956             revert OdysseyRouter_BadSenderAddress();
3957         }
3958         if (newAdmin == address(0)) {
3959             revert OdysseyRouter_BadAdminAddress();
3960         }
3961         admin = newAdmin;
3962     }
3963 
3964     function setMaxSupply721(address token, uint256 amount) public {
3965         if (ownerOf[token] != msg.sender) {
3966             revert OdysseyRouter_Unauthorized();
3967         }
3968         maxSupply721[token] = amount;
3969     }
3970 
3971     function setMaxSupply1155(
3972         address token,
3973         uint256[] calldata tokenIds,
3974         uint256[] calldata amounts
3975     ) public {
3976         if (ownerOf[token] != msg.sender) {
3977             revert OdysseyRouter_Unauthorized();
3978         }
3979         uint256 i;
3980         for (; i < tokenIds.length; ++i) {
3981             maxSupply1155[token][tokenIds[i]] = amounts[i];
3982         }
3983     }
3984 }
