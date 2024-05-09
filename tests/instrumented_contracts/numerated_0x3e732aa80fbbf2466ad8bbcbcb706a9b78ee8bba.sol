1 // SPDX-License-Identifier: APGL-3.0-Only AND MIT
2 
3 /**
4 
5 ████████╗██╗   ██╗██████╗ ██████╗ ██╗   ██╗   
6 ╚══██╔══╝██║   ██║██╔══██╗██╔══██╗╚██╗ ██╔╝   
7    ██║   ██║   ██║██████╔╝██████╔╝ ╚████╔╝    
8    ██║   ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝     
9    ██║   ╚██████╔╝██████╔╝██████╔╝   ██║      
10    ╚═╝    ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝      
11                                               
12 ██╗  ██╗███████╗██╗   ██╗██╗███╗   ██╗███████╗
13 ██║ ██╔╝██╔════╝██║   ██║██║████╗  ██║██╔════╝
14 █████╔╝ █████╗  ██║   ██║██║██╔██╗ ██║███████╗
15 ██╔═██╗ ██╔══╝  ╚██╗ ██╔╝██║██║╚██╗██║╚════██║
16 ██║  ██╗███████╗ ╚████╔╝ ██║██║ ╚████║███████║
17 ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝  ╚═══╝╚══════╝
18 
19         A TubbyCats Derivative Project
20           TubbyCats:   @tubbycatsnft
21           TubbyKevins: @tubbykevins
22 
23 ERC721 contract created using Solmate and _batchMint
24  forked from Azuki's ERC721A Contract and optimized
25    to work with Solmate's Contract to create an
26        extremely gas efficient contract.
27 
28 **/
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev String operations.
37  */
38 library Strings {
39     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97 
98 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
104  *
105  * These functions can be used to verify that a message was signed by the holder
106  * of the private keys of a given address.
107  */
108 library ECDSA {
109     enum RecoverError {
110         NoError,
111         InvalidSignature,
112         InvalidSignatureLength,
113         InvalidSignatureS,
114         InvalidSignatureV
115     }
116 
117     function _throwError(RecoverError error) private pure {
118         if (error == RecoverError.NoError) {
119             return; // no error: do nothing
120         } else if (error == RecoverError.InvalidSignature) {
121             revert("ECDSA: invalid signature");
122         } else if (error == RecoverError.InvalidSignatureLength) {
123             revert("ECDSA: invalid signature length");
124         } else if (error == RecoverError.InvalidSignatureS) {
125             revert("ECDSA: invalid signature 's' value");
126         } else if (error == RecoverError.InvalidSignatureV) {
127             revert("ECDSA: invalid signature 'v' value");
128         }
129     }
130 
131     /**
132      * @dev Returns the address that signed a hashed message (`hash`) with
133      * `signature` or error string. This address can then be used for verification purposes.
134      *
135      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
136      * this function rejects them by requiring the `s` value to be in the lower
137      * half order, and the `v` value to be either 27 or 28.
138      *
139      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
140      * verification to be secure: it is possible to craft signatures that
141      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
142      * this is by receiving a hash of the original message (which may otherwise
143      * be too long), and then calling {toEthSignedMessageHash} on it.
144      *
145      * Documentation for signature generation:
146      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
147      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
148      *
149      * _Available since v4.3._
150      */
151     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
152         // Check the signature length
153         // - case 65: r,s,v signature (standard)
154         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
155         if (signature.length == 65) {
156             bytes32 r;
157             bytes32 s;
158             uint8 v;
159             // ecrecover takes the signature parameters, and the only way to get them
160             // currently is to use assembly.
161             assembly {
162                 r := mload(add(signature, 0x20))
163                 s := mload(add(signature, 0x40))
164                 v := byte(0, mload(add(signature, 0x60)))
165             }
166             return tryRecover(hash, v, r, s);
167         } else if (signature.length == 64) {
168             bytes32 r;
169             bytes32 vs;
170             // ecrecover takes the signature parameters, and the only way to get them
171             // currently is to use assembly.
172             assembly {
173                 r := mload(add(signature, 0x20))
174                 vs := mload(add(signature, 0x40))
175             }
176             return tryRecover(hash, r, vs);
177         } else {
178             return (address(0), RecoverError.InvalidSignatureLength);
179         }
180     }
181 
182     /**
183      * @dev Returns the address that signed a hashed message (`hash`) with
184      * `signature`. This address can then be used for verification purposes.
185      *
186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
187      * this function rejects them by requiring the `s` value to be in the lower
188      * half order, and the `v` value to be either 27 or 28.
189      *
190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
191      * verification to be secure: it is possible to craft signatures that
192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
193      * this is by receiving a hash of the original message (which may otherwise
194      * be too long), and then calling {toEthSignedMessageHash} on it.
195      */
196     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
197         (address recovered, RecoverError error) = tryRecover(hash, signature);
198         _throwError(error);
199         return recovered;
200     }
201 
202     /**
203      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
204      *
205      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
206      *
207      * _Available since v4.3._
208      */
209     function tryRecover(
210         bytes32 hash,
211         bytes32 r,
212         bytes32 vs
213     ) internal pure returns (address, RecoverError) {
214         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
215         uint8 v = uint8((uint256(vs) >> 255) + 27);
216         return tryRecover(hash, v, r, s);
217     }
218 
219     /**
220      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
221      *
222      * _Available since v4.2._
223      */
224     function recover(
225         bytes32 hash,
226         bytes32 r,
227         bytes32 vs
228     ) internal pure returns (address) {
229         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
230         _throwError(error);
231         return recovered;
232     }
233 
234     /**
235      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
236      * `r` and `s` signature fields separately.
237      *
238      * _Available since v4.3._
239      */
240     function tryRecover(
241         bytes32 hash,
242         uint8 v,
243         bytes32 r,
244         bytes32 s
245     ) internal pure returns (address, RecoverError) {
246         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
247         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
248         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
249         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
250         //
251         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
252         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
253         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
254         // these malleable signatures as well.
255         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
256             return (address(0), RecoverError.InvalidSignatureS);
257         }
258         if (v != 27 && v != 28) {
259             return (address(0), RecoverError.InvalidSignatureV);
260         }
261 
262         // If the signature is valid (and not malleable), return the signer address
263         address signer = ecrecover(hash, v, r, s);
264         if (signer == address(0)) {
265             return (address(0), RecoverError.InvalidSignature);
266         }
267 
268         return (signer, RecoverError.NoError);
269     }
270 
271     /**
272      * @dev Overload of {ECDSA-recover} that receives the `v`,
273      * `r` and `s` signature fields separately.
274      */
275     function recover(
276         bytes32 hash,
277         uint8 v,
278         bytes32 r,
279         bytes32 s
280     ) internal pure returns (address) {
281         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
282         _throwError(error);
283         return recovered;
284     }
285 
286     /**
287      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
288      * produces hash corresponding to the one signed with the
289      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
290      * JSON-RPC method as part of EIP-191.
291      *
292      * See {recover}.
293      */
294     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
295         // 32 is the length in bytes of hash,
296         // enforced by the type signature above
297         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
298     }
299 
300     /**
301      * @dev Returns an Ethereum Signed Message, created from `s`. This
302      * produces hash corresponding to the one signed with the
303      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
304      * JSON-RPC method as part of EIP-191.
305      *
306      * See {recover}.
307      */
308     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
309         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
310     }
311 
312     /**
313      * @dev Returns an Ethereum Signed Typed Data, created from a
314      * `domainSeparator` and a `structHash`. This produces hash corresponding
315      * to the one signed with the
316      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
317      * JSON-RPC method as part of EIP-712.
318      *
319      * See {recover}.
320      */
321     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
322         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
323     }
324 }
325 
326 pragma solidity >=0.8.0;
327 
328 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
329 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
330 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
331 abstract contract ERC721 {
332     /*///////////////////////////////////////////////////////////////
333                                  EVENTS
334     //////////////////////////////////////////////////////////////*/
335 
336     event Transfer(address indexed from, address indexed to, uint256 indexed id);
337 
338     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
339 
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     error MintZeroAddress();
343     error MintZeroQuantity();
344 
345     /*///////////////////////////////////////////////////////////////
346                           METADATA STORAGE/LOGIC
347     //////////////////////////////////////////////////////////////*/
348 
349     string public name;
350 
351     string public symbol;
352 
353     function tokenURI(uint256 id) public view virtual returns (string memory);
354 
355     /*///////////////////////////////////////////////////////////////
356                             ERC721 STORAGE                        
357     //////////////////////////////////////////////////////////////*/
358 
359     uint256 public totalSupply;
360 
361     mapping(address => uint256) public balanceOf;
362 
363     mapping(uint256 => address) public ownerOf;
364 
365     mapping(uint256 => address) public getApproved;
366 
367     mapping(address => mapping(address => bool)) public isApprovedForAll;
368 
369     /*///////////////////////////////////////////////////////////////
370                               CONSTRUCTOR
371     //////////////////////////////////////////////////////////////*/
372 
373     constructor(string memory _name, string memory _symbol) {
374         name = _name;
375         symbol = _symbol;
376     }
377 
378     /*///////////////////////////////////////////////////////////////
379                               ERC721 LOGIC
380     //////////////////////////////////////////////////////////////*/
381 
382     function approve(address spender, uint256 id) public virtual {
383         address owner = ownerOf[id];
384 
385         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
386 
387         getApproved[id] = spender;
388 
389         emit Approval(owner, spender, id);
390     }
391 
392     function setApprovalForAll(address operator, bool approved) public virtual {
393         isApprovedForAll[msg.sender][operator] = approved;
394 
395         emit ApprovalForAll(msg.sender, operator, approved);
396     }
397 
398     function transferFrom(
399         address from,
400         address to,
401         uint256 id
402     ) public virtual {
403         require(from == ownerOf[id], "WRONG_FROM");
404 
405         require(to != address(0), "INVALID_RECIPIENT");
406 
407         require(
408             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
409             "NOT_AUTHORIZED"
410         );
411 
412         // Underflow of the sender's balance is impossible because we check for
413         // ownership above and the recipient's balance can't realistically overflow.
414         unchecked {
415             balanceOf[from]--;
416 
417             balanceOf[to]++;
418         }
419 
420         ownerOf[id] = to;
421 
422         delete getApproved[id];
423 
424         emit Transfer(from, to, id);
425     }
426 
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 id
431     ) public virtual {
432         transferFrom(from, to, id);
433 
434         require(
435             to.code.length == 0 ||
436                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
437                 ERC721TokenReceiver.onERC721Received.selector,
438             "UNSAFE_RECIPIENT"
439         );
440     }
441 
442     function safeTransferFrom(
443         address from,
444         address to,
445         uint256 id,
446         bytes memory data
447     ) public virtual {
448         transferFrom(from, to, id);
449 
450         require(
451             to.code.length == 0 ||
452                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
453                 ERC721TokenReceiver.onERC721Received.selector,
454             "UNSAFE_RECIPIENT"
455         );
456     }
457 
458     /*///////////////////////////////////////////////////////////////
459                               ERC165 LOGIC
460     //////////////////////////////////////////////////////////////*/
461 
462     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
463         return
464             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
465             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
466             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
467     }
468 
469     /*///////////////////////////////////////////////////////////////
470                        INTERNAL MINT/BURN LOGIC
471     //////////////////////////////////////////////////////////////*/
472 
473     function _batchMint(address to, uint256 quantity) internal virtual {
474         if (to == address(0)) revert MintZeroAddress();
475         if (quantity == 0) revert MintZeroQuantity();
476 
477         unchecked {
478             balanceOf[to] += quantity;
479 
480             uint256 updatedIndex = totalSupply;
481             uint256 end = updatedIndex + quantity;
482 
483             do {
484                 uint256 tokenId = updatedIndex+1;
485                 emit Transfer(address(0), to, tokenId);
486                 ownerOf[tokenId] = to;
487                 updatedIndex++;
488             } while (updatedIndex != end);
489             totalSupply = updatedIndex;
490         }
491     }
492 
493     function _mint(address to, uint256 id) internal virtual {
494         require(to != address(0), "INVALID_RECIPIENT");
495 
496         require(ownerOf[id] == address(0), "ALREADY_MINTED");
497 
498         // Counter overflow is incredibly unrealistic.
499         unchecked {
500             totalSupply++;
501 
502             balanceOf[to]++;
503         }
504 
505         ownerOf[id] = to;
506 
507         emit Transfer(address(0), to, id);
508     }
509 
510     function _burn(uint256 id) internal virtual {
511         address owner = ownerOf[id];
512 
513         require(ownerOf[id] != address(0), "NOT_MINTED");
514 
515         // Ownership check above ensures no underflow.
516         unchecked {
517             totalSupply--;
518 
519             balanceOf[owner]--;
520         }
521 
522         delete ownerOf[id];
523 
524         delete getApproved[id];
525 
526         emit Transfer(owner, address(0), id);
527     }
528 
529     /*///////////////////////////////////////////////////////////////
530                        INTERNAL SAFE MINT LOGIC
531     //////////////////////////////////////////////////////////////*/
532 
533     function _safeMint(address to, uint256 id) internal virtual {
534         _mint(to, id);
535 
536         require(
537             to.code.length == 0 ||
538                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
539                 ERC721TokenReceiver.onERC721Received.selector,
540             "UNSAFE_RECIPIENT"
541         );
542     }
543 
544     function _safeMint(
545         address to,
546         uint256 id,
547         bytes memory data
548     ) internal virtual {
549         _mint(to, id);
550 
551         require(
552             to.code.length == 0 ||
553                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
554                 ERC721TokenReceiver.onERC721Received.selector,
555             "UNSAFE_RECIPIENT"
556         );
557     }
558 }
559 
560 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
561 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
562 interface ERC721TokenReceiver {
563     function onERC721Received(
564         address operator,
565         address from,
566         uint256 id,
567         bytes calldata data
568     ) external returns (bytes4);
569 }
570 
571 pragma solidity ^0.8.4;
572 
573 contract TubbyKevin is ERC721 {
574 
575     using ECDSA for bytes32;
576 
577     enum SaleState {
578         CLOSED,
579         CLAIM,
580         MINT
581     }
582 
583     uint256 public maxSupply = 6666;
584     uint256 public mintPrice = 0.03 ether;
585     uint256 public immutable maxMintable = 10;
586     uint256 public immutable maxTubbyClaim = 4000;
587 
588     SaleState public saleState;
589 
590     string public baseURI;
591 
592     address private dev1;
593     address private dev2;
594     address private mktng;
595     address private signer;
596     
597     mapping(address => uint256) private sharePercs;
598     mapping(address => bool) private didntWorkVote;
599     mapping(uint256 => bool) public claimed;
600 
601     bool public useIpfs = false;
602 
603     modifier onlyShareholder() {
604         require(sharePercs[msg.sender] > 0 || msg.sender == signer,"MUST_BE_SHAREHOLDER");
605         _;
606     }
607 
608     constructor(
609         string memory _baseURI,
610         address _dev1,
611         address _dev2,
612         address _mktng,
613         address _signer
614     ) 
615     ERC721("Tubby Kevins", "TKEV"){
616         baseURI = _baseURI;
617         sharePercs[_dev1] = 20;
618         sharePercs[_dev2] = 20;
619         sharePercs[_mktng] = 60;
620         dev1 = _dev1;
621         dev2 = _dev2;
622         mktng = _mktng;
623         signer = _signer;
624     }
625 
626     function tubbyClaim(
627         uint256[] memory _nftIds,
628         uint256 _nonce,
629         bytes memory _signature
630     ) public {
631         require(saleState == SaleState.CLAIM, "CLAIM_INACTIVE");
632         bytes32 hash = hashTransaction(msg.sender, _nftIds, _nonce);
633         require(matchSignerAdmin(signTransaction(hash), _signature), "SIGNATURE_MISMATCH");
634         require(totalSupply+_nftIds.length <= maxTubbyClaim, "NOT_ENOUGH_LEFT");
635         for (uint i=0;i<_nftIds.length;i++) {
636             require(!claimed[_nftIds[i]], "ALREADY_CLAIMED");
637             claimed[_nftIds[i]] = true;
638         }
639         _batchMint(msg.sender, _nftIds.length);
640     }
641 
642     function adminMint(
643         address[] memory addresses,
644         uint256[] memory amounts
645     ) public onlyShareholder {
646         for (uint i=0;i<addresses.length;i++) {
647             _batchMint(addresses[i], amounts[i]);
648         }
649     }
650 
651     function mint(
652         uint256 _amount
653     ) public payable {
654         require(saleState == SaleState.MINT, "MINT_INACTIVE");
655         require(msg.value == (_amount * mintPrice), "INSUFFICIENT_FUNDS");
656         require(_amount <= maxMintable || _amount + totalSupply <= maxSupply, "REQUESTING_TOO_MANY");
657         if (_amount == 1) {
658             _mint(msg.sender, totalSupply+1);
659         } else {
660             _batchMint(msg.sender, _amount);
661         }
662     }
663 
664     function updateSaleState(
665         SaleState code
666     ) public onlyShareholder {
667         saleState = code;
668     }
669 
670     function didntWorkOut() public onlyShareholder {
671         require(!didntWorkVote[msg.sender], "ALREADY_VOTED");
672         didntWorkVote[msg.sender] = true;
673         if (didntWorkVote[dev1] && didntWorkVote[dev2] && didntWorkVote[mktng]) {
674             sharePercs[dev1] = 33;
675             sharePercs[dev2] = 33;
676             sharePercs[mktng] = 33;
677             saleState = SaleState.CLOSED;
678         }
679     }
680 
681     function updateMintPrice(
682         uint256 _gweiPrice
683     ) public onlyShareholder {
684         mintPrice = _gweiPrice;
685     }
686 
687     function withdraw() public onlyShareholder {
688         require(address(this).balance > (0.1 * 1 ether), "INSUFFICIENT_FUNDS");
689         uint256 dev_amnt = (address(this).balance * 20) / 100;
690         uint256 mktg_amnt = (address(this).balance - (dev_amnt * 2));
691         payable(dev1).transfer(dev_amnt);
692         payable(dev2).transfer(dev_amnt);
693         payable(mktng).transfer(mktg_amnt);
694     }
695 
696     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
697         if (_i == 0) {
698             return "0";
699         }
700         uint j = _i;
701         uint len;
702         while (j != 0) {
703             len++;
704             j /= 10;
705         }
706         bytes memory bstr = new bytes(len);
707         uint k = len;
708         while (_i != 0) {
709             k = k-1;
710             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
711             bytes1 b1 = bytes1(temp);
712             bstr[k] = b1;
713             _i /= 10;
714         }
715         return string(bstr);
716     }
717 
718     function tokenURI(
719         uint256 id
720     ) public view override returns (string memory) {
721         if (!useIpfs) {
722             return string(abi.encodePacked(baseURI, uint2str(id)));
723         } else {
724             return string(abi.encodePacked(baseURI, uint2str(id), ".json"));
725         }
726     }
727 
728     function updateSigner(
729         address _signer
730     ) public onlyShareholder {
731         signer = _signer;
732     }
733 
734     function updateMetadata(
735         string memory _uri,
736         bool _useIpfs
737     ) public onlyShareholder {
738         baseURI = _uri;
739         useIpfs = _useIpfs;
740     }
741 
742     function hashTransaction(address _sender, uint256[] memory _nftIds, uint256 _nonce) public pure returns (bytes32) {
743         bytes32 _hash = keccak256(abi.encodePacked(_sender, _nftIds, _nonce));
744         return _hash;
745     }
746         
747     function signTransaction(bytes32 _hash) public pure returns (bytes32) {
748         return _hash.toEthSignedMessageHash();
749     }
750 
751     function matchSignerAdmin(bytes32 _payload, bytes memory _signature) public view returns (bool) {
752         return signer == _payload.recover(_signature);
753     }
754 }