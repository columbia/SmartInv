1 
2 // File: contracts/common/Validating.sol
3 
4 pragma solidity 0.5.12;
5 
6 
7 interface Validating {
8   modifier notZero(uint number) { require(number > 0, "invalid 0 value"); _; }
9   modifier notEmpty(string memory text) { require(bytes(text).length > 0, "invalid empty string"); _; }
10   modifier validAddress(address value) { require(value != address(0x0), "invalid address"); _; }
11 }
12 
13 // File: contracts/external/MerkleProof.sol
14 
15 pragma solidity 0.5.12;
16 
17 
18 /// @notice can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/MerkleProof.sol
19 contract MerkleProof {
20 
21   /**
22    * Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof.
23    * Based on https://github.com/ameensol/merkle-tree-solidity/src/MerkleProof.sol
24    */
25   function checkProof(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
26     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
27 
28     bytes memory elements = proof;
29     bytes32 element;
30     bytes32 hash = leaf;
31     for (uint i = 32; i <= proof.length; i += 32) {
32       assembly {
33       // Load the current element of the proofOfInclusion (optimal way to get a bytes32 slice)
34         element := mload(add(elements, i))
35       }
36       hash = keccak256(abi.encodePacked(hash < element ? abi.encodePacked(hash, element) : abi.encodePacked(element, hash)));
37     }
38     return hash == root;
39   }
40 
41   // from StorJ -- https://github.com/nginnever/storj-audit-verifier/contracts/MerkleVerifyv3.sol
42   function checkProofOrdered(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
43     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
44 
45     // use the index to determine the node ordering (index ranges 1 to n)
46     bytes32 element;
47     bytes32 hash = leaf;
48     uint remaining;
49     for (uint j = 32; j <= proof.length; j += 32) {
50       assembly {
51         element := mload(add(proof, j))
52       }
53 
54       // calculate remaining elements in proof
55       remaining = (proof.length - j + 32) / 32;
56 
57       // we don't assume that the tree is padded to a power of 2
58       // if the index is odd then the proof will start with a hash at a higher layer,
59       // so we have to adjust the index to be the index at that layer
60       while (remaining > 0 && index % 2 == 1 && index > 2 ** remaining) {
61         index = uint(index) / 2 + 1;
62       }
63 
64       if (index % 2 == 0) {
65         hash = keccak256(abi.encodePacked(abi.encodePacked(element, hash)));
66         index = index / 2;
67       } else {
68         hash = keccak256(abi.encodePacked(abi.encodePacked(hash, element)));
69         index = uint(index) / 2 + 1;
70       }
71     }
72     return hash == root;
73   }
74 
75   /** Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof */
76   function verifyIncluded(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
77     return checkProof(proof, root, leaf);
78   }
79 
80   /** Verifies the inclusion of a leaf is at a specific place in an ordered Merkle tree using a Merkle proof */
81   function verifyIncludedAtIndex(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
82     return checkProofOrdered(proof, root, leaf, index);
83   }
84 }
85 
86 // File: contracts/external/Token.sol
87 
88 pragma solidity 0.5.12;
89 
90 
91 /*
92  * Abstract contract for the full ERC 20 Token standard
93  * https://github.com/ethereum/EIPs/issues/20
94  */
95 contract Token {
96   /** This is a slight change to the ERC20 base standard.
97   function totalSupply() view returns (uint supply);
98   is replaced map:
99   uint public totalSupply;
100   This automatically creates a getter function for the totalSupply.
101   This is moved to the base contract since public getter functions are not
102   currently recognised as an implementation of the matching abstract
103   function by the compiler.
104   */
105   /// total amount of tokens
106   uint public totalSupply;
107 
108   /// @param _owner The address from which the balance will be retrieved
109   /// @return The balance
110   function balanceOf(address _owner) public view returns (uint balance);
111 
112   /// @notice send `_value` token to `_to` from `msg.sender`
113   /// @param _to The address of the recipient
114   /// @param _value The amount of token to be transferred
115   /// @return Whether the transfer was successful or not
116   function transfer(address _to, uint _value) public returns (bool success);
117 
118   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
119   /// @param _from The address of the sender
120   /// @param _to The address of the recipient
121   /// @param _value The amount of token to be transferred
122   /// @return Whether the transfer was successful or not
123   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
124 
125   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
126   /// @param _spender The address of the account able to transfer the tokens
127   /// @param _value The amount of tokens to be approved for transfer
128   /// @return Whether the approval was successful or not
129   function approve(address _spender, uint _value) public returns (bool success);
130 
131   /// @param _owner The address of the account owning tokens
132   /// @param _spender The address of the account able to transfer the tokens
133   /// @return Amount of remaining tokens allowed to spent
134   function allowance(address _owner, address _spender) public view returns (uint remaining);
135 
136   event Transfer(address indexed _from, address indexed _to, uint _value);
137   event Approval(address indexed _owner, address indexed _spender, uint _value);
138 }
139 
140 // File: contracts/gluon/AppGovernance.sol
141 
142 pragma solidity 0.5.12;
143 
144 
145 interface AppGovernance {
146   function approve(uint32 id) external;
147   function disapprove(uint32 id) external;
148   function activate(uint32 id) external;
149 }
150 
151 // File: contracts/gluon/AppLogic.sol
152 
153 pragma solidity 0.5.12;
154 
155 
156 interface AppLogic {
157   function upgrade() external;
158   function credit(address account, address asset, uint quantity) external;
159   function debit(address account, bytes calldata parameters) external returns (address asset, uint quantity);
160 }
161 
162 // File: contracts/gluon/AppState.sol
163 
164 pragma solidity 0.5.12;
165 
166 
167 contract AppState {
168 
169   enum State { OFF, ON, RETIRED }
170   State public state = State.ON;
171   event Off();
172   event Retired();
173 
174   modifier whenOn() { require(state == State.ON, "must be on"); _; }
175   modifier whenOff() { require(state == State.OFF, "must be off"); _; }
176   modifier whenRetired() { require(state == State.RETIRED, "must be retired"); _; }
177 
178   function retire_() internal whenOn {
179     state = State.RETIRED;
180     emit Retired();
181   }
182 
183   function switchOff_() internal whenOn {
184     state = State.OFF;
185     emit Off();
186   }
187 
188   function isOn() external view returns (bool) { return state == State.ON; }
189 }
190 
191 // File: contracts/gluon/GluonView.sol
192 
193 pragma solidity 0.5.12;
194 
195 
196 interface GluonView {
197   function app(uint32 id) external view returns (address current, address proposal, uint activationBlock);
198   function current(uint32 id) external view returns (address);
199   function history(uint32 id) external view returns (address[] memory);
200   function getBalance(uint32 id, address asset) external view returns (uint);
201   function isAnyLogic(uint32 id, address logic) external view returns (bool);
202   function isAppOwner(uint32 id, address appOwner) external view returns (bool);
203   function proposals(address logic) external view returns (bool);
204   function totalAppsCount() external view returns(uint32);
205 }
206 
207 // File: contracts/gluon/GluonCentric.sol
208 
209 pragma solidity 0.5.12;
210 
211 
212 
213 contract GluonCentric {
214   uint32 internal constant REGISTRY_INDEX = 0;
215   uint32 internal constant STAKE_INDEX = 1;
216 
217   uint32 public id;
218   address public gluon;
219 
220   constructor(uint32 id_, address gluon_) public {
221     id = id_;
222     gluon = gluon_;
223   }
224 
225   modifier onlyCurrentLogic { require(currentLogic() == msg.sender, "invalid sender; must be current logic contract"); _; }
226   modifier onlyGluon { require(gluon == msg.sender, "invalid sender; must be gluon contract"); _; }
227   modifier onlyOwner { require(GluonView(gluon).isAppOwner(id, msg.sender), "invalid sender; must be app owner"); _; }
228 
229   function currentLogic() public view returns (address) { return GluonView(gluon).current(id); }
230 }
231 
232 // File: contracts/apps/registry/RegistryData.sol
233 
234 pragma solidity 0.5.12;
235 
236 
237 
238 contract RegistryData is GluonCentric {
239 
240   mapping(address => address) public accounts;
241 
242   constructor(address gluon) GluonCentric(REGISTRY_INDEX, gluon) public { }
243 
244   function addKey(address apiKey, address account) external onlyCurrentLogic {
245     accounts[apiKey] = account;
246   }
247 
248 }
249 
250 // File: contracts/gluon/Upgrading.sol
251 
252 pragma solidity 0.5.12;
253 
254 
255 
256 
257 contract Upgrading {
258   address public upgradeOperator;
259 
260   modifier onlyOwner { require(false, "modifier onlyOwner must be implemented"); _; }
261   modifier onlyUpgradeOperator { require(upgradeOperator == msg.sender, "invalid sender; must be upgrade operator"); _; }
262   function setUpgradeOperator(address upgradeOperator_) external onlyOwner { upgradeOperator = upgradeOperator_; }
263   function upgrade_(AppGovernance appGovernance, uint32 id) internal {
264     appGovernance.activate(id);
265     delete upgradeOperator;
266   }
267 }
268 
269 // File: contracts/apps/registry/RegistryLogic.sol
270 
271 pragma solidity 0.5.12;
272 
273 
274 
275 
276 
277 
278 
279 
280 
281 contract RegistryLogic is Upgrading, Validating, AppLogic, AppState, GluonCentric {
282 
283   RegistryData public data;
284   OldRegistry public old;
285 
286   event Registered(address apiKey, address indexed account);
287 
288   constructor(address gluon, address old_, address data_) GluonCentric(REGISTRY_INDEX, gluon) public {
289     data = RegistryData(data_);
290     old = OldRegistry(old_);
291   }
292 
293   modifier isAbsent(address apiKey) { require(translate(apiKey) == address (0x0), "api key already in use"); _; }
294 
295   function register(address apiKey) external whenOn validAddress(apiKey) isAbsent(apiKey) {
296     data.addKey(apiKey, msg.sender);
297     emit Registered(apiKey, msg.sender);
298   }
299 
300   function translate(address apiKey) public view returns (address) {
301     address account = data.accounts(apiKey);
302     if (account == address(0x0)) account = old.translate(apiKey);
303     return account;
304   }
305 
306   /**************************************************** AppLogic ****************************************************/
307 
308   function upgrade() external onlyUpgradeOperator {
309     retire_();
310     upgrade_(AppGovernance(gluon), id);
311   }
312 
313   function credit(address, address, uint) external { revert("not supported"); }
314 
315   function debit(address, bytes calldata) external returns (address, uint) { revert("not supported"); }
316 
317   function switchOff() external onlyOwner {
318     uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
319     for (uint32 i = 2; i < totalAppsCount; i++) {
320       AppState appState = AppState(GluonView(gluon).current(i));
321       require(!appState.isOn(), "One of the apps is still ON");
322     }
323     switchOff_();
324   }
325 }
326 
327 
328 contract OldRegistry {
329   function translate(address) public view returns (address);
330 }
331 
332 // File: contracts/common/EvmTypes.sol
333 
334 pragma solidity 0.5.12;
335 
336 
337 contract EvmTypes {
338 
339   uint constant internal ADDRESS = 20;
340   uint constant internal UINT8 = 1;
341   uint constant internal UINT32 = 4;
342   uint constant internal UINT64 = 8;
343   uint constant internal UINT128 = 16;
344   uint constant internal UINT256 = 32;
345   uint constant internal BYTES32 = 32;
346   uint constant internal SIGNATURE_BYTES = 65;
347 
348 }
349 
350 // File: contracts/external/BytesLib.sol
351 
352 /*
353  * @title Solidity Bytes Arrays Utils
354  * @author Gonçalo Sá <goncalo.sa@consensys.net>
355  *
356  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
357  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
358  */
359 
360 pragma solidity 0.5.12;
361 
362 
363 library BytesLib {
364     function concat(
365         bytes memory _preBytes,
366         bytes memory _postBytes
367     )
368         internal
369         pure
370         returns (bytes memory)
371     {
372         bytes memory tempBytes;
373 
374         assembly {
375             // Get a location of some free memory and store it in tempBytes as
376             // Solidity does for memory variables.
377             tempBytes := mload(0x40)
378 
379             // Store the length of the first bytes array at the beginning of
380             // the memory for tempBytes.
381             let length := mload(_preBytes)
382             mstore(tempBytes, length)
383 
384             // Maintain a memory counter for the current write location in the
385             // temp bytes array by adding the 32 bytes for the array length to
386             // the starting location.
387             let mc := add(tempBytes, 0x20)
388             // Stop copying when the memory counter reaches the length of the
389             // first bytes array.
390             let end := add(mc, length)
391 
392             for {
393                 // Initialize a copy counter to the start of the _preBytes data,
394                 // 32 bytes into its memory.
395                 let cc := add(_preBytes, 0x20)
396             } lt(mc, end) {
397                 // Increase both counters by 32 bytes each iteration.
398                 mc := add(mc, 0x20)
399                 cc := add(cc, 0x20)
400             } {
401                 // Write the _preBytes data into the tempBytes memory 32 bytes
402                 // at a time.
403                 mstore(mc, mload(cc))
404             }
405 
406             // Add the length of _postBytes to the current length of tempBytes
407             // and store it as the new length in the first 32 bytes of the
408             // tempBytes memory.
409             length := mload(_postBytes)
410             mstore(tempBytes, add(length, mload(tempBytes)))
411 
412             // Move the memory counter back from a multiple of 0x20 to the
413             // actual end of the _preBytes data.
414             mc := end
415             // Stop copying when the memory counter reaches the new combined
416             // length of the arrays.
417             end := add(mc, length)
418 
419             for {
420                 let cc := add(_postBytes, 0x20)
421             } lt(mc, end) {
422                 mc := add(mc, 0x20)
423                 cc := add(cc, 0x20)
424             } {
425                 mstore(mc, mload(cc))
426             }
427 
428             // Update the free-memory pointer by padding our last write location
429             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
430             // next 32 byte block, then round down to the nearest multiple of
431             // 32. If the sum of the length of the two arrays is zero then add
432             // one before rounding down to leave a blank 32 bytes (the length block with 0).
433             mstore(0x40, and(
434               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
435               not(31) // Round down to the nearest 32 bytes.
436             ))
437         }
438 
439         return tempBytes;
440     }
441 
442     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
443         assembly {
444             // Read the first 32 bytes of _preBytes storage, which is the length
445             // of the array. (We don't need to use the offset into the slot
446             // because arrays use the entire slot.)
447             let fslot := sload(_preBytes_slot)
448             // Arrays of 31 bytes or less have an even value in their slot,
449             // while longer arrays have an odd value. The actual length is
450             // the slot divided by two for odd values, and the lowest order
451             // byte divided by two for even values.
452             // If the slot is even, bitwise and the slot with 255 and divide by
453             // two to get the length. If the slot is odd, bitwise and the slot
454             // with -1 and divide by two.
455             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
456             let mlength := mload(_postBytes)
457             let newlength := add(slength, mlength)
458             // slength can contain both the length and contents of the array
459             // if length < 32 bytes so let's prepare for that
460             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
461             switch add(lt(slength, 32), lt(newlength, 32))
462             case 2 {
463                 // Since the new array still fits in the slot, we just need to
464                 // update the contents of the slot.
465                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
466                 sstore(
467                     _preBytes_slot,
468                     // all the modifications to the slot are inside this
469                     // next block
470                     add(
471                         // we can just add to the slot contents because the
472                         // bytes we want to change are the LSBs
473                         fslot,
474                         add(
475                             mul(
476                                 div(
477                                     // load the bytes from memory
478                                     mload(add(_postBytes, 0x20)),
479                                     // zero all bytes to the right
480                                     exp(0x100, sub(32, mlength))
481                                 ),
482                                 // and now shift left the number of bytes to
483                                 // leave space for the length in the slot
484                                 exp(0x100, sub(32, newlength))
485                             ),
486                             // increase length by the double of the memory
487                             // bytes length
488                             mul(mlength, 2)
489                         )
490                     )
491                 )
492             }
493             case 1 {
494                 // The stored value fits in the slot, but the combined value
495                 // will exceed it.
496                 // get the keccak hash to get the contents of the array
497                 mstore(0x0, _preBytes_slot)
498                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
499 
500                 // save new length
501                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
502 
503                 // The contents of the _postBytes array start 32 bytes into
504                 // the structure. Our first read should obtain the `submod`
505                 // bytes that can fit into the unused space in the last word
506                 // of the stored array. To get this, we read 32 bytes starting
507                 // from `submod`, so the data we read overlaps with the array
508                 // contents by `submod` bytes. Masking the lowest-order
509                 // `submod` bytes allows us to add that value directly to the
510                 // stored value.
511 
512                 let submod := sub(32, slength)
513                 let mc := add(_postBytes, submod)
514                 let end := add(_postBytes, mlength)
515                 let mask := sub(exp(0x100, submod), 1)
516 
517                 sstore(
518                     sc,
519                     add(
520                         and(
521                             fslot,
522                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
523                         ),
524                         and(mload(mc), mask)
525                     )
526                 )
527 
528                 for {
529                     mc := add(mc, 0x20)
530                     sc := add(sc, 1)
531                 } lt(mc, end) {
532                     sc := add(sc, 1)
533                     mc := add(mc, 0x20)
534                 } {
535                     sstore(sc, mload(mc))
536                 }
537 
538                 mask := exp(0x100, sub(mc, end))
539 
540                 sstore(sc, mul(div(mload(mc), mask), mask))
541             }
542             default {
543                 // get the keccak hash to get the contents of the array
544                 mstore(0x0, _preBytes_slot)
545                 // Start copying to the last used word of the stored array.
546                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
547 
548                 // save new length
549                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
550 
551                 // Copy over the first `submod` bytes of the new data as in
552                 // case 1 above.
553                 let slengthmod := mod(slength, 32)
554                 let mlengthmod := mod(mlength, 32)
555                 let submod := sub(32, slengthmod)
556                 let mc := add(_postBytes, submod)
557                 let end := add(_postBytes, mlength)
558                 let mask := sub(exp(0x100, submod), 1)
559 
560                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
561 
562                 for {
563                     sc := add(sc, 1)
564                     mc := add(mc, 0x20)
565                 } lt(mc, end) {
566                     sc := add(sc, 1)
567                     mc := add(mc, 0x20)
568                 } {
569                     sstore(sc, mload(mc))
570                 }
571 
572                 mask := exp(0x100, sub(mc, end))
573 
574                 sstore(sc, mul(div(mload(mc), mask), mask))
575             }
576         }
577     }
578 
579     function slice(
580         bytes memory _bytes,
581         uint _start,
582         uint _length
583     ) internal pure returns (bytes memory)
584     {
585         require(_bytes.length >= (_start + _length));
586 
587         bytes memory tempBytes;
588 
589         assembly {
590             switch iszero(_length)
591             case 0 {
592             // Get a location of some free memory and store it in tempBytes as
593             // Solidity does for memory variables.
594                 tempBytes := mload(0x40)
595 
596             // The first word of the slice result is potentially a partial
597             // word read from the original array. To read it, we calculate
598             // the length of that partial word and start copying that many
599             // bytes into the array. The first word we copy will start with
600             // data we don't care about, but the last `lengthmod` bytes will
601             // land at the beginning of the contents of the new array. When
602             // we're done copying, we overwrite the full first word with
603             // the actual length of the slice.
604                 let lengthmod := and(_length, 31)
605 
606             // The multiplication in the next line is necessary
607             // because when slicing multiples of 32 bytes (lengthmod == 0)
608             // the following copy loop was copying the origin's length
609             // and then ending prematurely not copying everything it should.
610                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
611                 let end := add(mc, _length)
612 
613                 for {
614                 // The multiplication in the next line has the same exact purpose
615                 // as the one above.
616                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
617                 } lt(mc, end) {
618                     mc := add(mc, 0x20)
619                     cc := add(cc, 0x20)
620                 } {
621                     mstore(mc, mload(cc))
622                 }
623 
624                 mstore(tempBytes, _length)
625 
626             // update free-memory pointer
627             // allocating the array padded to 32 bytes like the compiler does now
628                 mstore(0x40, and(add(mc, 31), not(31)))
629             }
630             // if we want a zero-length slice let's just return a zero-length array
631             default {
632                 tempBytes := mload(0x40)
633 
634                 mstore(0x40, add(tempBytes, 0x20))
635             }
636         }
637 
638         return tempBytes;
639     }
640 
641     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
642         require(_bytes.length >= (_start + 20));
643         address tempAddress;
644         assembly {
645             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
646         }
647         return tempAddress;
648     }
649 
650     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
651         require(_bytes.length >= (_start + 1));
652         uint8 tempUint;
653         assembly {
654             tempUint := mload(add(add(_bytes, 0x1), _start))
655         }
656         return tempUint;
657     }
658 
659     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
660         require(_bytes.length >= (_start + 2));
661         uint16 tempUint;
662         assembly {
663             tempUint := mload(add(add(_bytes, 0x2), _start))
664         }
665         return tempUint;
666     }
667 
668     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
669         require(_bytes.length >= (_start + 4));
670         uint32 tempUint;
671         assembly {
672             tempUint := mload(add(add(_bytes, 0x4), _start))
673         }
674         return tempUint;
675     }
676 
677     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
678         require(_bytes.length >= (_start + 8));
679         uint64 tempUint;
680         assembly {
681             tempUint := mload(add(add(_bytes, 0x8), _start))
682         }
683         return tempUint;
684     }
685 
686     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
687         require(_bytes.length >= (_start + 12));
688         uint96 tempUint;
689         assembly {
690             tempUint := mload(add(add(_bytes, 0xc), _start))
691         }
692         return tempUint;
693     }
694 
695     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
696         require(_bytes.length >= (_start + 16));
697         uint128 tempUint;
698         assembly {
699             tempUint := mload(add(add(_bytes, 0x10), _start))
700         }
701         return tempUint;
702     }
703 
704     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
705         require(_bytes.length >= (_start + 32));
706         uint256 tempUint;
707         assembly {
708             tempUint := mload(add(add(_bytes, 0x20), _start))
709         }
710         return tempUint;
711     }
712 
713     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
714         require(_bytes.length >= (_start + 32));
715         bytes32 tempBytes32;
716         assembly {
717             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
718         }
719         return tempBytes32;
720     }
721 
722     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
723         bool success = true;
724 
725         assembly {
726             let length := mload(_preBytes)
727 
728             // if lengths don't match the arrays are not equal
729             switch eq(length, mload(_postBytes))
730             case 1 {
731                 // cb is a circuit breaker in the for loop since there's
732                 //  no said feature for inline assembly loops
733                 // cb = 1 - don't breaker
734                 // cb = 0 - break
735                 let cb := 1
736 
737                 let mc := add(_preBytes, 0x20)
738                 let end := add(mc, length)
739 
740                 for {
741                     let cc := add(_postBytes, 0x20)
742                 // the next line is the loop condition:
743                 // while(uint(mc < end) + cb == 2)
744                 } eq(add(lt(mc, end), cb), 2) {
745                     mc := add(mc, 0x20)
746                     cc := add(cc, 0x20)
747                 } {
748                     // if any of these checks fails then arrays are not equal
749                     if iszero(eq(mload(mc), mload(cc))) {
750                         // unsuccess:
751                         success := 0
752                         cb := 0
753                     }
754                 }
755             }
756             default {
757                 // unsuccess:
758                 success := 0
759             }
760         }
761 
762         return success;
763     }
764 
765     function equalStorage(
766         bytes storage _preBytes,
767         bytes memory _postBytes
768     )
769         internal
770         view
771         returns (bool)
772     {
773         bool success = true;
774 
775         assembly {
776             // we know _preBytes_offset is 0
777             let fslot := sload(_preBytes_slot)
778             // Decode the length of the stored array like in concatStorage().
779             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
780             let mlength := mload(_postBytes)
781 
782             // if lengths don't match the arrays are not equal
783             switch eq(slength, mlength)
784             case 1 {
785                 // slength can contain both the length and contents of the array
786                 // if length < 32 bytes so let's prepare for that
787                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
788                 if iszero(iszero(slength)) {
789                     switch lt(slength, 32)
790                     case 1 {
791                         // blank the last byte which is the length
792                         fslot := mul(div(fslot, 0x100), 0x100)
793 
794                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
795                             // unsuccess:
796                             success := 0
797                         }
798                     }
799                     default {
800                         // cb is a circuit breaker in the for loop since there's
801                         //  no said feature for inline assembly loops
802                         // cb = 1 - don't breaker
803                         // cb = 0 - break
804                         let cb := 1
805 
806                         // get the keccak hash to get the contents of the array
807                         mstore(0x0, _preBytes_slot)
808                         let sc := keccak256(0x0, 0x20)
809 
810                         let mc := add(_postBytes, 0x20)
811                         let end := add(mc, mlength)
812 
813                         // the next line is the loop condition:
814                         // while(uint(mc < end) + cb == 2)
815                         for {} eq(add(lt(mc, end), cb), 2) {
816                             sc := add(sc, 1)
817                             mc := add(mc, 0x20)
818                         } {
819                             if iszero(eq(sload(sc), mload(mc))) {
820                                 // unsuccess:
821                                 success := 0
822                                 cb := 0
823                             }
824                         }
825                     }
826                 }
827             }
828             default {
829                 // unsuccess:
830                 success := 0
831             }
832         }
833 
834         return success;
835     }
836 }
837 
838 // File: contracts/apps/spot/WithDepositCommitmentRecord.sol
839 
840 pragma solidity 0.5.12;
841 
842 
843 
844 
845 contract WithDepositCommitmentRecord is EvmTypes {
846   using BytesLib for bytes;
847 
848   struct DepositCommitmentRecord {
849     uint32 ledgerId;
850     address account;
851     address asset;
852     uint quantity;
853     uint32 nonce;
854     uint32 designatedGblock;
855     bytes32 hash;
856   }
857 
858   uint constant private LEDGER_ID = 0;
859   uint constant private ACCOUNT = LEDGER_ID + UINT32;
860   uint constant private ASSET = ACCOUNT + ADDRESS;
861   uint constant private QUANTITY = ASSET + ADDRESS;
862   uint constant private NONCE = QUANTITY + UINT256;
863   uint constant private DESIGNATED_GBLOCK = NONCE + UINT32;
864 
865   function parseDepositCommitmentRecord(bytes memory parameters) internal pure returns (DepositCommitmentRecord memory result) {
866     result.ledgerId = parameters.toUint32(LEDGER_ID);
867     result.account = parameters.toAddress(ACCOUNT);
868     result.asset = parameters.toAddress(ASSET);
869     result.quantity = parameters.toUint(QUANTITY);
870     result.nonce = parameters.toUint32(NONCE);
871     result.designatedGblock = parameters.toUint32(DESIGNATED_GBLOCK);
872     result.hash = keccak256(encodePackedDeposit(result.ledgerId, result.account, result.asset, result.quantity, result.nonce, result.designatedGblock));
873   }
874 
875   function encodePackedDeposit(uint32 ledgerId, address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) public pure returns(bytes memory) {
876     return abi.encodePacked(ledgerId, account, asset, quantity, nonce, designatedGblock);
877   }
878 }
879 
880 // File: contracts/external/Cryptography.sol
881 
882 pragma solidity 0.5.12;
883 
884 
885 contract Cryptography {
886 
887   /**
888   * @dev Recover signer address from a message by using their signature
889   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
890   * @param signature bytes generated using web3.eth.account.sign().signature
891   *
892   * Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
893   * TODO: Remove this library once solidity supports passing a signature to ecrecover.
894   * See https://github.com/ethereum/solidity/issues/864
895   */
896   function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
897     bytes32 r;
898     bytes32 s;
899     uint8 v;
900     if (signature.length != 65) return (address(0x0));
901     // Check the signature length
902 
903     // Divide the signature into r, s and v variables
904     assembly {
905       r := mload(add(signature, 32))
906       s := mload(add(signature, 64))
907       v := byte(0, mload(add(signature, 96)))
908     }
909 
910     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
911     if (v < 27) v += 27;
912 
913     // If the version is correct return the signer address
914     return (v != 27 && v != 28) ? (address(0)) : ecrecover(hash, v, r, s);
915   }
916 
917 }
918 
919 // File: contracts/apps/spot/WithEntry.sol
920 
921 pragma solidity 0.5.12;
922 
923 
924 
925 
926 
927 contract WithEntry is EvmTypes, Cryptography {
928   using BytesLib for bytes;
929 
930   struct Entry {
931     uint32 ledgerId;
932     address account;
933     address asset;
934     EntryType entryType;
935     uint8 action;
936     uint timestamp;
937     uint quantity;
938     uint balance;
939     uint previous;
940     uint32 gblockNumber;
941     bytes32 hash;
942     bytes32 dataHash;
943     bytes signature;
944     address signer;
945     bytes dataBytes;
946   }
947 
948   uint constant private VERSION = 0;
949   uint constant private LEDGER_ID = VERSION + UINT8;
950   uint constant private ACCOUNT = LEDGER_ID + UINT32;
951   uint constant private ASSET = ACCOUNT + ADDRESS;
952   uint constant private ENTRY_TYPE = ASSET + ADDRESS;
953   uint constant private ACTION = ENTRY_TYPE + UINT8;
954   uint constant private TIMESTAMP = ACTION + UINT8;
955   uint constant private QUANTITY = TIMESTAMP + UINT64;
956   uint constant private BALANCE = QUANTITY + UINT256;
957   uint constant private PREVIOUS = BALANCE + UINT256;
958   uint constant private GBLOCK_NUMBER = PREVIOUS + UINT128;
959   uint constant private DATA_HASH = GBLOCK_NUMBER + UINT32;
960   uint constant private ENTRY_LENGTH = DATA_HASH + BYTES32;
961 
962   enum EntryType { Unknown, Origin, Deposit, Withdrawal, Exited, Trade, Fee }
963 
964   function parseEntry(bytes memory parameters, bytes memory signature) internal pure returns (Entry memory result) {
965     result.ledgerId = parameters.toUint32(LEDGER_ID);
966     result.account = parameters.toAddress(ACCOUNT);
967     result.asset = parameters.toAddress(ASSET);
968     result.entryType = EntryType(parameters.toUint8(ENTRY_TYPE));
969     result.action = parameters.toUint8(ACTION);
970     result.timestamp = parameters.toUint64(TIMESTAMP);
971     result.quantity = parameters.toUint(QUANTITY);
972     result.balance = parameters.toUint(BALANCE);
973     result.previous = parameters.toUint128(PREVIOUS);
974     result.gblockNumber = parameters.toUint32(GBLOCK_NUMBER);
975     result.dataHash = parameters.toBytes32(DATA_HASH);
976     bytes memory entryBytes = parameters;
977     if (parameters.length > ENTRY_LENGTH) {
978       result.dataBytes = parameters.slice(ENTRY_LENGTH, parameters.length - ENTRY_LENGTH);
979       require(result.dataHash == keccak256(result.dataBytes), "data hash mismatch");
980       entryBytes = parameters.slice(0, ENTRY_LENGTH);
981     }
982     result.hash = keccak256(entryBytes);
983     result.signer = recover(result.hash, signature);
984   }
985 
986 }
987 
988 // File: contracts/apps/spot/SpotData.sol
989 
990 pragma solidity 0.5.12;
991 
992 
993 
994 contract SpotData is GluonCentric {
995 
996   struct Gblock {
997     bytes32 withdrawalsRoot;
998     bytes32 depositsRoot;
999     bytes32 balancesRoot;
1000   }
1001 
1002   uint32 public nonce = 0;
1003   uint32 public currentGblockNumber;
1004   uint public submissionBlock = block.number;
1005   mapping(uint32 => Gblock) public gblocksByNumber;
1006   mapping(bytes32 => bool) public deposits;
1007   mapping(bytes32 => bool) public withdrawn;
1008   mapping(bytes32 => uint) public exitClaims; // exit entry hash => confirmationThreshold
1009   mapping(address => mapping(address => bool)) public exited; // account => asset => has exited
1010 
1011   constructor(uint32 id, address gluon) GluonCentric(id, gluon) public { }
1012 
1013   function deposit(bytes32 hash) external onlyCurrentLogic { deposits[hash] = true; }
1014 
1015   function deleteDeposit(bytes32 hash) external onlyCurrentLogic {
1016     require(deposits[hash], "unknown deposit");
1017     delete deposits[hash];
1018   }
1019 
1020   function nextNonce() external onlyCurrentLogic returns (uint32) { return ++nonce; }
1021 
1022   function markExited(address account, address asset) external onlyCurrentLogic { exited[account][asset] = true; }
1023 
1024   function markWithdrawn(bytes32 hash) external onlyCurrentLogic {withdrawn[hash] = true;}
1025 
1026   function hasExited(address account, address asset) external view returns (bool) { return exited[account][asset]; }
1027 
1028   function hasWithdrawn(bytes32 hash) external view returns (bool) { return withdrawn[hash]; }
1029 
1030   function markExitClaim(bytes32 hash, uint confirmationThreshold) external onlyCurrentLogic { exitClaims[hash] = confirmationThreshold; }
1031 
1032   function deleteExitClaim(bytes32 hash) external onlyCurrentLogic { delete exitClaims[hash]; }
1033 
1034   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot, uint submissionInterval) external onlyCurrentLogic {
1035     Gblock memory gblock = Gblock(withdrawalsRoot, depositsRoot, balancesRoot);
1036     gblocksByNumber[gblockNumber] = gblock;
1037     currentGblockNumber = gblockNumber;
1038     submissionBlock = block.number + submissionInterval;
1039   }
1040 
1041   function updateSubmissionBlock(uint submissionBlock_) external onlyCurrentLogic { submissionBlock = submissionBlock_; }
1042 
1043   function depositsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].depositsRoot; }
1044 
1045   function withdrawalsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].withdrawalsRoot; }
1046 
1047   function balancesRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].balancesRoot; }
1048 
1049   function isConfirmedGblock(uint32 gblockNumber) external view returns (bool) { return gblockNumber > 0 && gblockNumber < currentGblockNumber; }
1050 
1051 }
1052 
1053 // File: contracts/apps/spot/SpotLogic.sol
1054 
1055 pragma solidity 0.5.12;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 
1070 contract SpotLogic is Upgrading, Validating, MerkleProof, AppLogic, AppState, GluonCentric, WithDepositCommitmentRecord, WithEntry {
1071 
1072   struct ProofOfInclusionAtIndex {
1073     bytes32 leaf;
1074     uint index;
1075     bytes proof;
1076   }
1077 
1078   struct ProofOfExclusionOfDeposit {
1079     DepositCommitmentRecord excluded;
1080     ProofOfInclusionAtIndex predecessor;
1081     ProofOfInclusionAtIndex successor;
1082   }
1083 
1084   uint8 public constant confirmationDelay = 5;
1085   uint8 public constant visibilityDelay = 3;
1086 
1087   uint private constant ASSISTED_WITHDRAW = 1;
1088   uint private constant RECLAIM_DEPOSIT = 2;
1089   uint private constant CLAIM_EXIT = 3;
1090   uint private constant EXIT = 4;
1091   uint private constant EXIT_ON_HALT = 5;
1092   uint private constant RECLAIM_DEPOSIT_ON_HALT = 6;
1093 
1094   SpotData public data;
1095   address public operator;
1096   uint public submissionInterval;
1097   uint public abandonPoint;
1098   event Deposited(address indexed account, address indexed asset, uint quantity, uint32 nonce, uint32 designatedGblock);
1099   event DepositReclaimed(address indexed account, address indexed asset, uint quantity, uint32 nonce);
1100   event ExitClaimed(bytes32 hash, address indexed account, address indexed asset, uint quantity, uint timestamp, uint confirmationThreshold);
1101   event Exited(address indexed account, address indexed asset, uint quantity);
1102   event Withdrawn(bytes32 hash, address indexed account, address indexed asset, uint quantity);
1103   event Submitted(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot);
1104 
1105   constructor(uint32 id, address gluon, address data_, address operator_, uint submissionInterval_, uint abandonPoint_) GluonCentric(id, gluon) public validAddress(gluon) validAddress(operator_) {
1106     operator = operator_;
1107     submissionInterval = submissionInterval_;
1108     data = SpotData(data_);
1109     abandonPoint = abandonPoint_;
1110   }
1111 
1112   /**************************************************** AppLogic ****************************************************/
1113 
1114   function upgrade() external whenOn onlyUpgradeOperator {
1115     require(canSubmit(), "cannot upgrade yet");
1116     retire_();
1117     upgrade_(AppGovernance(gluon), id);
1118   }
1119 
1120   function credit(address account, address asset, uint quantity) external whenOn onlyGluon {
1121     require(!data.hasExited(account, asset), "previously exited");
1122     uint32 nonce = data.nextNonce();
1123     uint32 designatedGblock = data.currentGblockNumber() + visibilityDelay;
1124     bytes32 hash = keccak256(abi.encodePacked(id, account, asset, quantity, nonce, designatedGblock));
1125     data.deposit(hash);
1126     emit Deposited(account, asset, quantity, nonce, designatedGblock);
1127   }
1128 
1129   function debit(address account, bytes calldata parameters) external onlyGluon returns (address asset, uint quantity) {
1130     uint action = parameters.toUint(0);
1131     if (action == ASSISTED_WITHDRAW) return assistedWithdraw(account, parameters);
1132     else if (action == RECLAIM_DEPOSIT) return reclaimDeposit(account, parameters);
1133     else if (action == CLAIM_EXIT) return claimExit(account, parameters);
1134     else if (action == EXIT) return exit(account, parameters);
1135     else if (action == EXIT_ON_HALT) return exitOnHalt(account, parameters);
1136     else if (action == RECLAIM_DEPOSIT_ON_HALT) return reclaimDepositOnHalt(account, parameters);
1137     else revert("invalid action");
1138   }
1139 
1140   /**************************************************** Depositing ****************************************************/
1141 
1142   function reclaimDeposit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1143     (, bytes memory entry_, bytes32[] memory leaves, uint[] memory indexes, bytes memory predecessor, bytes memory successor) = abi.decode(parameters, (uint, bytes, bytes32[], uint[], bytes, bytes));
1144     ProofOfExclusionOfDeposit memory proof = extractProofOfExclusionOfDeposit(entry_, leaves, indexes, predecessor, successor);
1145     DepositCommitmentRecord memory record = proof.excluded;
1146     require(record.account == account, "claimant must be the original depositor");
1147     require(data.currentGblockNumber() > record.designatedGblock && record.designatedGblock != 0, "designated gblock is unconfirmed or unknown");
1148     require(proveIsExcludedFromDeposits(data.depositsRoot(record.designatedGblock), proof), "failed to proof exclusion of deposit");
1149     return reclaimDeposit_(record);
1150   }
1151 
1152   function proveIsExcludedFromDeposits(bytes32 root, ProofOfExclusionOfDeposit memory proof) private pure returns (bool) {
1153     return proof.successor.index == proof.predecessor.index + 1 && // predecessor & successor must be consecutive
1154       proof.successor.leaf > proof.excluded.hash &&
1155       proof.predecessor.leaf < proof.excluded.hash &&
1156       verifyIncludedAtIndex(proof.predecessor.proof, root, proof.predecessor.leaf, proof.predecessor.index) &&
1157       verifyIncludedAtIndex(proof.successor.proof, root, proof.successor.leaf, proof.successor.index);
1158   }
1159 
1160   function reclaimDepositOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1161     (, bytes memory commitmentRecord) = abi.decode(parameters, (uint, bytes));
1162     DepositCommitmentRecord memory record = parseDepositCommitmentRecord(commitmentRecord);
1163     require(record.ledgerId == id, 'not from current ledger');
1164     require(record.account == account, "claimant must be the original depositor");
1165     require(record.designatedGblock >= data.currentGblockNumber(), "designated gblock is already confirmed; use exitOnHalt instead");
1166     return reclaimDeposit_(record);
1167   }
1168 
1169   function encodedDepositOnHaltParameters(address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) external view returns (bytes memory) {
1170     bytes memory encodedPackedDeposit = encodePackedDeposit(id, account, asset, quantity, nonce, designatedGblock);
1171     return abi.encode(RECLAIM_DEPOSIT_ON_HALT, encodedPackedDeposit);
1172   }
1173 
1174   function reclaimDeposit_(DepositCommitmentRecord memory record) private returns (address asset, uint quantity) {
1175     data.deleteDeposit(record.hash);
1176     emit DepositReclaimed(record.account, record.asset, record.quantity, record.nonce);
1177     return (record.asset, record.quantity);
1178   }
1179 
1180   function extractProofOfExclusionOfDeposit(bytes memory recordParameters, bytes32[] memory leaves, uint[] memory indexes, bytes memory predecessor, bytes memory successor) private view returns (ProofOfExclusionOfDeposit memory result) {
1181     result.excluded = parseDepositCommitmentRecord(recordParameters);
1182     require(result.excluded.ledgerId == id, 'not from current ledger');
1183     result.predecessor = ProofOfInclusionAtIndex(leaves[0], indexes[0], predecessor);
1184     result.successor = ProofOfInclusionAtIndex(leaves[1], indexes[1], successor);
1185   }
1186 
1187   /**************************************************** Withdrawing ***************************************************/
1188 
1189   function assistedWithdraw(address account, bytes memory parameters) private returns (address asset, uint quantity) {
1190     (, bytes memory entryBytes, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1191     Entry memory entry = parseAndValidateEntry(entryBytes, signature, account);
1192     require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
1193     require(proveInConfirmedWithdrawals(proof, entry.gblockNumber, entry.hash), "invalid entry proof");
1194     require(!data.hasWithdrawn(entry.hash), "entry already withdrawn");
1195     data.markWithdrawn(entry.hash);
1196     emit Withdrawn(entry.hash, entry.account, entry.asset, entry.quantity);
1197     return (entry.asset, entry.quantity);
1198   }
1199 
1200   function claimExit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1201     (, bytes memory entry_, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1202     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1203     require(!hasExited(entry.account, entry.asset), "previously exited");
1204     require(proveInConfirmedBalances(proof, entry.hash), "invalid balance proof");
1205     uint confirmationThreshold = data.currentGblockNumber() + confirmationDelay;
1206     data.markExitClaim(entry.hash, confirmationThreshold);
1207     emit ExitClaimed(entry.hash, entry.account, entry.asset, entry.balance, entry.timestamp, confirmationThreshold);
1208     return (entry.asset, 0);
1209   }
1210 
1211   function exit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1212     (, bytes memory entry_, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1213     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1214     require(!hasExited(entry.account, entry.asset), "previously exited");
1215     require(canExit(entry.hash), "no prior claim found to withdraw OR balances are yet to be confirmed");
1216     require(proveInUnconfirmedBalances(proof, entry.hash), "invalid balance proof");
1217     data.deleteExitClaim(entry.hash);
1218     exit_(entry);
1219     return (entry.asset, entry.balance);
1220   }
1221 
1222   function exitOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1223     (, bytes memory entry_, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1224     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1225     require(!hasExited(entry.account, entry.asset), "previously exited");
1226     require(proveInConfirmedBalances(proof, entry.hash), "invalid balance proof");
1227     exit_(entry);
1228     return (entry.asset, entry.balance);
1229   }
1230 
1231   function exit_(Entry memory entry) private {
1232     data.markExited(entry.account, entry.asset);
1233     emit Exited(entry.account, entry.asset, entry.balance);
1234   }
1235 
1236   function hasExited(address account, address asset) public view returns (bool) { return data.hasExited(account, asset); }
1237 
1238   function canExit(bytes32 entryHash) public view returns (bool) {
1239     uint confirmationThreshold = data.exitClaims(entryHash);
1240     return confirmationThreshold != 0 && data.currentGblockNumber() >= confirmationThreshold;
1241   }
1242 
1243   /**************************************************** FraudProof ****************************************************/
1244 
1245   function canSubmit() public view returns (bool) { return block.number > data.submissionBlock(); }
1246 
1247   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot) public whenOn {
1248     require(canSubmit(), "cannot submit yet");
1249     require(msg.sender == operator, "submitter must be the operator");
1250     require(gblockNumber == data.currentGblockNumber() + 1, "gblock must be the next in sequence");
1251     data.submit(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot, submissionInterval);
1252     emit Submitted(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
1253   }
1254 
1255   function proveInConfirmedWithdrawals(bytes memory proof, uint32 gblockNumber, bytes32 entryHash) public view returns (bool) {
1256     return data.isConfirmedGblock(gblockNumber) && verifyIncluded(proof, data.withdrawalsRoot(gblockNumber), entryHash);
1257   }
1258 
1259   function proveInConfirmedBalances(bytes memory proof, bytes32 entryHash) public view returns (bool) {
1260     uint32 gblockNumber = data.currentGblockNumber() - 1;
1261     return verifyIncluded(proof, data.balancesRoot(gblockNumber), entryHash);
1262   }
1263 
1264   function proveInUnconfirmedBalances(bytes memory proof, bytes32 entryHash) public view returns (bool) {
1265     uint32 gblockNumber = data.currentGblockNumber();
1266     return verifyIncluded(proof, data.balancesRoot(gblockNumber), entryHash);
1267   }
1268 
1269   function parseAndValidateEntry(bytes memory entryBytes, bytes memory signature, address account) private view returns (Entry memory entry) {
1270     entry = parseEntry(entryBytes, signature);
1271     require(entry.ledgerId == id, 'entry is not from current ledger');
1272     require(entry.signer == operator, "failed to verify signature");
1273     require(entry.account == account, "entry account mismatch");
1274   }
1275 
1276   /****************************************************** halting ******************************************************/
1277 
1278   function hasBeenAbandoned() public view returns(bool) {
1279     return block.number > data.submissionBlock() + abandonPoint;
1280   }
1281 
1282   function abandon() external {
1283     require(hasBeenAbandoned(), "chain has not yet abandoned");
1284     switchOff_();
1285   }
1286 
1287   function switchOff() external onlyOwner {
1288     switchOff_();
1289   }
1290 }
