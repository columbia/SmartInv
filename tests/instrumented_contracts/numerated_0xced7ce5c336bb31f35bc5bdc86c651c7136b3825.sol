1 pragma solidity ^0.4.19;
2 
3 // Interface contract to be implemented by SyscoinToken
4 contract SyscoinTransactionProcessor {
5     function processTransaction(uint txHash, uint value, address destinationAddress, uint32 _assetGUID, address superblockSubmitterAddress) public returns (uint);
6     function burn(uint _value, uint32 _assetGUID, bytes syscoinWitnessProgram) payable public returns (bool success);
7 }
8 
9 // Bitcoin transaction parsing library - modified for SYSCOIN
10 
11 // Copyright 2016 rain <https://keybase.io/rain>
12 //
13 // Licensed under the Apache License, Version 2.0 (the "License");
14 // you may not use this file except in compliance with the License.
15 // You may obtain a copy of the License at
16 //
17 //      http://www.apache.org/licenses/LICENSE-2.0
18 //
19 // Unless required by applicable law or agreed to in writing, software
20 // distributed under the License is distributed on an "AS IS" BASIS,
21 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
22 // See the License for the specific language governing permissions and
23 // limitations under the License.
24 
25 // https://en.bitcoin.it/wiki/Protocol_documentation#tx
26 //
27 // Raw Bitcoin transaction structure:
28 //
29 // field     | size | type     | description
30 // version   | 4    | int32    | transaction version number
31 // n_tx_in   | 1-9  | var_int  | number of transaction inputs
32 // tx_in     | 41+  | tx_in[]  | list of transaction inputs
33 // n_tx_out  | 1-9  | var_int  | number of transaction outputs
34 // tx_out    | 9+   | tx_out[] | list of transaction outputs
35 // lock_time | 4    | uint32   | block number / timestamp at which tx locked
36 //
37 // Transaction input (tx_in) structure:
38 //
39 // field      | size | type     | description
40 // previous   | 36   | outpoint | Previous output transaction reference
41 // script_len | 1-9  | var_int  | Length of the signature script
42 // sig_script | ?    | uchar[]  | Script for confirming transaction authorization
43 // sequence   | 4    | uint32   | Sender transaction version
44 //
45 // OutPoint structure:
46 //
47 // field      | size | type     | description
48 // hash       | 32   | char[32] | The hash of the referenced transaction
49 // index      | 4    | uint32   | The index of this output in the referenced transaction
50 //
51 // Transaction output (tx_out) structure:
52 //
53 // field         | size | type     | description
54 // value         | 8    | int64    | Transaction value (Satoshis)
55 // pk_script_len | 1-9  | var_int  | Length of the public key script
56 // pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.
57 //
58 // Variable integers (var_int) can be encoded differently depending
59 // on the represented value, to save space. Variable integers always
60 // precede an array of a variable length data type (e.g. tx_in).
61 //
62 // Variable integer encodings as a function of represented value:
63 //
64 // value           | bytes  | format
65 // <0xFD (253)     | 1      | uint8
66 // <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16
67 // <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32
68 // -               | 9      | 0xFF followed by length as uint64
69 //
70 // Public key scripts `pk_script` are set on the output and can
71 // take a number of forms. The regular transaction script is
72 // called 'pay-to-pubkey-hash' (P2PKH):
73 //
74 // OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
75 //
76 // OP_x are Bitcoin script opcodes. The bytes representation (including
77 // the 0x14 20-byte stack push) is:
78 //
79 // 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC
80 //
81 // The <pubKeyHash> is the ripemd160 hash of the sha256 hash of
82 // the public key, preceded by a network version byte. (21 bytes total)
83 //
84 // Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)
85 //
86 // The Bitcoin address is derived from the pubKeyHash. The binary form is the
87 // pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes
88 // of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)
89 // This is converted to base58 to form the publicly used Bitcoin address.
90 // Mainnet P2PKH transaction scripts are to addresses beginning with '1'.
91 //
92 // P2SH ('pay to script hash') scripts only supply a script hash. The spender
93 // must then provide the script that would allow them to redeem this output.
94 // This allows for arbitrarily complex scripts to be funded using only a
95 // hash of the script, and moves the onus on providing the script from
96 // the spender to the redeemer.
97 //
98 // The P2SH script format is simple:
99 //
100 // OP_HASH160 <scriptHash> OP_EQUAL
101 //
102 // 0xA9 0x14 <scriptHash> 0x87
103 //
104 // The <scriptHash> is the ripemd160 hash of the sha256 hash of the
105 // redeem script. The P2SH address is derived from the scriptHash.
106 // Addresses are the scriptHash with a version prefix of 5, encoded as
107 // Base58check. These addresses begin with a '3'.
108 
109 
110 
111 // parse a raw Syscoin transaction byte array
112 library SyscoinMessageLibrary {
113 
114     uint constant p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;  // secp256k1
115     uint constant q = (p + 1) / 4;
116 
117     // Error codes
118     uint constant ERR_INVALID_HEADER = 10050;
119     uint constant ERR_COINBASE_INDEX = 10060; // coinbase tx index within Litecoin merkle isn't 0
120     uint constant ERR_NOT_MERGE_MINED = 10070; // trying to check AuxPoW on a block that wasn't merge mined
121     uint constant ERR_FOUND_TWICE = 10080; // 0xfabe6d6d found twice
122     uint constant ERR_NO_MERGE_HEADER = 10090; // 0xfabe6d6d not found
123     uint constant ERR_NOT_IN_FIRST_20 = 10100; // chain Merkle root isn't in the first 20 bytes of coinbase tx
124     uint constant ERR_CHAIN_MERKLE = 10110;
125     uint constant ERR_PARENT_MERKLE = 10120;
126     uint constant ERR_PROOF_OF_WORK = 10130;
127     uint constant ERR_INVALID_HEADER_HASH = 10140;
128     uint constant ERR_PROOF_OF_WORK_AUXPOW = 10150;
129     uint constant ERR_PARSE_TX_OUTPUT_LENGTH = 10160;
130     uint constant ERR_PARSE_TX_SYS = 10170;
131     enum Network { MAINNET, TESTNET, REGTEST }
132     uint32 constant SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN = 0x7407;
133     uint32 constant SYSCOIN_TX_VERSION_BURN = 0x7401;
134     // AuxPoW block fields
135     struct AuxPoW {
136         uint blockHash;
137 
138         uint txHash;
139 
140         uint coinbaseMerkleRoot; // Merkle root of auxiliary block hash tree; stored in coinbase tx field
141         uint[] chainMerkleProof; // proves that a given Syscoin block hash belongs to a tree with the above root
142         uint syscoinHashIndex; // index of Syscoin block hash within block hash tree
143         uint coinbaseMerkleRootCode; // encodes whether or not the root was found properly
144 
145         uint parentMerkleRoot; // Merkle root of transaction tree from parent Litecoin block header
146         uint[] parentMerkleProof; // proves that coinbase tx belongs to a tree with the above root
147         uint coinbaseTxIndex; // index of coinbase tx within Litecoin tx tree
148 
149         uint parentNonce;
150     }
151 
152     // Syscoin block header stored as a struct, mostly for readability purposes.
153     // BlockHeader structs can be obtained by parsing a block header's first 80 bytes
154     // with parseHeaderBytes.
155     struct BlockHeader {
156         uint32 bits;
157         uint blockHash;
158     }
159     // Convert a variable integer into something useful and return it and
160     // the index to after it.
161     function parseVarInt(bytes memory txBytes, uint pos) private pure returns (uint, uint) {
162         // the first byte tells us how big the integer is
163         uint8 ibit = uint8(txBytes[pos]);
164         pos += 1;  // skip ibit
165 
166         if (ibit < 0xfd) {
167             return (ibit, pos);
168         } else if (ibit == 0xfd) {
169             return (getBytesLE(txBytes, pos, 16), pos + 2);
170         } else if (ibit == 0xfe) {
171             return (getBytesLE(txBytes, pos, 32), pos + 4);
172         } else if (ibit == 0xff) {
173             return (getBytesLE(txBytes, pos, 64), pos + 8);
174         }
175     }
176     // convert little endian bytes to uint
177     function getBytesLE(bytes memory data, uint pos, uint bits) internal pure returns (uint) {
178         if (bits == 8) {
179             return uint8(data[pos]);
180         } else if (bits == 16) {
181             return uint16(data[pos])
182                  + uint16(data[pos + 1]) * 2 ** 8;
183         } else if (bits == 32) {
184             return uint32(data[pos])
185                  + uint32(data[pos + 1]) * 2 ** 8
186                  + uint32(data[pos + 2]) * 2 ** 16
187                  + uint32(data[pos + 3]) * 2 ** 24;
188         } else if (bits == 64) {
189             return uint64(data[pos])
190                  + uint64(data[pos + 1]) * 2 ** 8
191                  + uint64(data[pos + 2]) * 2 ** 16
192                  + uint64(data[pos + 3]) * 2 ** 24
193                  + uint64(data[pos + 4]) * 2 ** 32
194                  + uint64(data[pos + 5]) * 2 ** 40
195                  + uint64(data[pos + 6]) * 2 ** 48
196                  + uint64(data[pos + 7]) * 2 ** 56;
197         }
198     }
199     
200 
201     // @dev - Parses a syscoin tx
202     //
203     // @param txBytes - tx byte array
204     // Outputs
205     // @return output_value - amount sent to the lock address in satoshis
206     // @return destinationAddress - ethereum destination address
207 
208 
209     function parseTransaction(bytes memory txBytes) internal pure
210              returns (uint, uint, address, uint32)
211     {
212         
213         uint output_value;
214         uint32 assetGUID;
215         address destinationAddress;
216         uint32 version;
217         uint pos = 0;
218         version = bytesToUint32Flipped(txBytes, pos);
219         if(version != SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN && version != SYSCOIN_TX_VERSION_BURN){
220             return (ERR_PARSE_TX_SYS, output_value, destinationAddress, assetGUID);
221         }
222         pos = skipInputs(txBytes, 4);
223             
224         (output_value, destinationAddress, assetGUID) = scanBurns(txBytes, version, pos);
225         return (0, output_value, destinationAddress, assetGUID);
226     }
227 
228 
229   
230     // skips witnesses and saves first script position/script length to extract pubkey of first witness scriptSig
231     function skipWitnesses(bytes memory txBytes, uint pos, uint n_inputs) private pure
232              returns (uint)
233     {
234         uint n_stack;
235         (n_stack, pos) = parseVarInt(txBytes, pos);
236         
237         uint script_len;
238         for (uint i = 0; i < n_inputs; i++) {
239             for (uint j = 0; j < n_stack; j++) {
240                 (script_len, pos) = parseVarInt(txBytes, pos);
241                 pos += script_len;
242             }
243         }
244 
245         return n_stack;
246     }    
247 
248     function skipInputs(bytes memory txBytes, uint pos) private pure
249              returns (uint)
250     {
251         uint n_inputs;
252         uint script_len;
253         (n_inputs, pos) = parseVarInt(txBytes, pos);
254         // if dummy 0x00 is present this is a witness transaction
255         if(n_inputs == 0x00){
256             (n_inputs, pos) = parseVarInt(txBytes, pos); // flag
257             assert(n_inputs != 0x00);
258             // after dummy/flag the real var int comes for txins
259             (n_inputs, pos) = parseVarInt(txBytes, pos);
260         }
261         require(n_inputs < 100);
262 
263         for (uint i = 0; i < n_inputs; i++) {
264             pos += 36;  // skip outpoint
265             (script_len, pos) = parseVarInt(txBytes, pos);
266             pos += script_len + 4;  // skip sig_script, seq
267         }
268 
269         return pos;
270     }
271              
272     // scan the burn outputs and return the value and script data of first burned output.
273     function scanBurns(bytes memory txBytes, uint32 version, uint pos) private pure
274              returns (uint, address, uint32)
275     {
276         uint script_len;
277         uint output_value;
278         uint32 assetGUID = 0;
279         address destinationAddress;
280         uint n_outputs;
281         (n_outputs, pos) = parseVarInt(txBytes, pos);
282         require(n_outputs < 10);
283         for (uint i = 0; i < n_outputs; i++) {
284             // output
285             if(version == SYSCOIN_TX_VERSION_BURN){
286                 output_value = getBytesLE(txBytes, pos, 64);
287             }
288             pos += 8;
289             // varint
290             (script_len, pos) = parseVarInt(txBytes, pos);
291             if(!isOpReturn(txBytes, pos)){
292                 // output script
293                 pos += script_len;
294                 output_value = 0;
295                 continue;
296             }
297             // skip opreturn marker
298             pos += 1;
299             if(version == SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN){
300                 (output_value, destinationAddress, assetGUID) = scanAssetDetails(txBytes, pos);
301             }
302             else if(version == SYSCOIN_TX_VERSION_BURN){                
303                 destinationAddress = scanSyscoinDetails(txBytes, pos);   
304             }
305             // only one opreturn data allowed per transaction
306             break;
307         }
308 
309         return (output_value, destinationAddress, assetGUID);
310     }
311 
312     function skipOutputs(bytes memory txBytes, uint pos) private pure
313              returns (uint)
314     {
315         uint n_outputs;
316         uint script_len;
317 
318         (n_outputs, pos) = parseVarInt(txBytes, pos);
319 
320         require(n_outputs < 10);
321 
322         for (uint i = 0; i < n_outputs; i++) {
323             pos += 8;
324             (script_len, pos) = parseVarInt(txBytes, pos);
325             pos += script_len;
326         }
327 
328         return pos;
329     }
330     // get final position of inputs, outputs and lock time
331     // this is a helper function to slice a byte array and hash the inputs, outputs and lock time
332     function getSlicePos(bytes memory txBytes, uint pos) private pure
333              returns (uint slicePos)
334     {
335         slicePos = skipInputs(txBytes, pos + 4);
336         slicePos = skipOutputs(txBytes, slicePos);
337         slicePos += 4; // skip lock time
338     }
339     // scan a Merkle branch.
340     // return array of values and the end position of the sibling hashes.
341     // takes a 'stop' argument which sets the maximum number of
342     // siblings to scan through. stop=0 => scan all.
343     function scanMerkleBranch(bytes memory txBytes, uint pos, uint stop) private pure
344              returns (uint[], uint)
345     {
346         uint n_siblings;
347         uint halt;
348 
349         (n_siblings, pos) = parseVarInt(txBytes, pos);
350 
351         if (stop == 0 || stop > n_siblings) {
352             halt = n_siblings;
353         } else {
354             halt = stop;
355         }
356 
357         uint[] memory sibling_values = new uint[](halt);
358 
359         for (uint i = 0; i < halt; i++) {
360             sibling_values[i] = flip32Bytes(sliceBytes32Int(txBytes, pos));
361             pos += 32;
362         }
363 
364         return (sibling_values, pos);
365     }   
366     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
367     function sliceBytes20(bytes memory data, uint start) private pure returns (bytes20) {
368         uint160 slice = 0;
369         // FIXME: With solc v0.4.24 and optimizations enabled
370         // using uint160 for index i will generate an error
371         // "Error: VM Exception while processing transaction: Error: redPow(normalNum)"
372         for (uint i = 0; i < 20; i++) {
373             slice += uint160(data[i + start]) << (8 * (19 - i));
374         }
375         return bytes20(slice);
376     }
377     // Slice 32 contiguous bytes from bytes `data`, starting at `start`
378     function sliceBytes32Int(bytes memory data, uint start) private pure returns (uint slice) {
379         for (uint i = 0; i < 32; i++) {
380             if (i + start < data.length) {
381                 slice += uint(data[i + start]) << (8 * (31 - i));
382             }
383         }
384     }
385 
386     // @dev returns a portion of a given byte array specified by its starting and ending points
387     // Should be private, made internal for testing
388     // Breaks underscore naming convention for parameters because it raises a compiler error
389     // if `offset` is changed to `_offset`.
390     //
391     // @param _rawBytes - array to be sliced
392     // @param offset - first byte of sliced array
393     // @param _endIndex - last byte of sliced array
394     function sliceArray(bytes memory _rawBytes, uint offset, uint _endIndex) internal view returns (bytes) {
395         uint len = _endIndex - offset;
396         bytes memory result = new bytes(len);
397         assembly {
398             // Call precompiled contract to copy data
399             if iszero(staticcall(gas, 0x04, add(add(_rawBytes, 0x20), offset), len, add(result, 0x20), len)) {
400                 revert(0, 0)
401             }
402         }
403         return result;
404     }
405     
406     
407     // Returns true if the tx output is an OP_RETURN output
408     function isOpReturn(bytes memory txBytes, uint pos) private pure
409              returns (bool) {
410         // scriptPub format is
411         // 0x6a OP_RETURN
412         return 
413             txBytes[pos] == byte(0x6a);
414     }
415     // Returns syscoin data parsed from the op_return data output from syscoin burn transaction
416     function scanSyscoinDetails(bytes memory txBytes, uint pos) private pure
417              returns (address) {      
418         uint8 op;
419         (op, pos) = getOpcode(txBytes, pos);
420         // ethereum addresses are 20 bytes (without the 0x)
421         require(op == 0x14);
422         return readEthereumAddress(txBytes, pos);
423     }    
424     // Returns asset data parsed from the op_return data output from syscoin asset burn transaction
425     function scanAssetDetails(bytes memory txBytes, uint pos) private pure
426              returns (uint, address, uint32) {
427                  
428         uint32 assetGUID;
429         address destinationAddress;
430         uint output_value;
431         uint8 op;
432         // vchAsset
433         (op, pos) = getOpcode(txBytes, pos);
434         // guid length should be 4 bytes
435         require(op == 0x04);
436         assetGUID = bytesToUint32(txBytes, pos);
437         pos += op;
438         // amount
439         (op, pos) = getOpcode(txBytes, pos);
440         require(op == 0x08);
441         output_value = bytesToUint64(txBytes, pos);
442         pos += op;
443          // destination address
444         (op, pos) = getOpcode(txBytes, pos);
445         // ethereum contracts are 20 bytes (without the 0x)
446         require(op == 0x14);
447         destinationAddress = readEthereumAddress(txBytes, pos);       
448         return (output_value, destinationAddress, assetGUID);
449     }         
450     // Read the ethereum address embedded in the tx output
451     function readEthereumAddress(bytes memory txBytes, uint pos) private pure
452              returns (address) {
453         uint256 data;
454         assembly {
455             data := mload(add(add(txBytes, 20), pos))
456         }
457         return address(uint160(data));
458     }
459 
460     // Read next opcode from script
461     function getOpcode(bytes memory txBytes, uint pos) private pure
462              returns (uint8, uint)
463     {
464         require(pos < txBytes.length);
465         return (uint8(txBytes[pos]), pos + 1);
466     }
467 
468     // @dev - convert an unsigned integer from little-endian to big-endian representation
469     //
470     // @param _input - little-endian value
471     // @return - input value in big-endian format
472     function flip32Bytes(uint _input) internal pure returns (uint result) {
473         assembly {
474             let pos := mload(0x40)
475             for { let i := 0 } lt(i, 32) { i := add(i, 1) } {
476                 mstore8(add(pos, i), byte(sub(31, i), _input))
477             }
478             result := mload(pos)
479         }
480     }
481     // helpers for flip32Bytes
482     struct UintWrapper {
483         uint value;
484     }
485 
486     function ptr(UintWrapper memory uw) private pure returns (uint addr) {
487         assembly {
488             addr := uw
489         }
490     }
491 
492     function parseAuxPoW(bytes memory rawBytes, uint pos) internal view
493              returns (AuxPoW memory auxpow)
494     {
495         // we need to traverse the bytes with a pointer because some fields are of variable length
496         pos += 80; // skip non-AuxPoW header
497         uint slicePos;
498         (slicePos) = getSlicePos(rawBytes, pos);
499         auxpow.txHash = dblShaFlipMem(rawBytes, pos, slicePos - pos);
500         pos = slicePos;
501         // parent block hash, skip and manually hash below
502         pos += 32;
503         (auxpow.parentMerkleProof, pos) = scanMerkleBranch(rawBytes, pos, 0);
504         auxpow.coinbaseTxIndex = getBytesLE(rawBytes, pos, 32);
505         pos += 4;
506         (auxpow.chainMerkleProof, pos) = scanMerkleBranch(rawBytes, pos, 0);
507         auxpow.syscoinHashIndex = getBytesLE(rawBytes, pos, 32);
508         pos += 4;
509         // calculate block hash instead of reading it above, as some are LE and some are BE, we cannot know endianness and have to calculate from parent block header
510         auxpow.blockHash = dblShaFlipMem(rawBytes, pos, 80);
511         pos += 36; // skip parent version and prev block
512         auxpow.parentMerkleRoot = sliceBytes32Int(rawBytes, pos);
513         pos += 40; // skip root that was just read, parent block timestamp and bits
514         auxpow.parentNonce = getBytesLE(rawBytes, pos, 32);
515         uint coinbaseMerkleRootPosition;
516         (auxpow.coinbaseMerkleRoot, coinbaseMerkleRootPosition, auxpow.coinbaseMerkleRootCode) = findCoinbaseMerkleRoot(rawBytes);
517     }
518 
519     // @dev - looks for {0xfa, 0xbe, 'm', 'm'} byte sequence
520     // returns the following 32 bytes if it appears once and only once,
521     // 0 otherwise
522     // also returns the position where the bytes first appear
523     function findCoinbaseMerkleRoot(bytes memory rawBytes) private pure
524              returns (uint, uint, uint)
525     {
526         uint position;
527         bool found = false;
528 
529         for (uint i = 0; i < rawBytes.length; ++i) {
530             if (rawBytes[i] == 0xfa && rawBytes[i+1] == 0xbe && rawBytes[i+2] == 0x6d && rawBytes[i+3] == 0x6d) {
531                 if (found) { // found twice
532                     return (0, position - 4, ERR_FOUND_TWICE);
533                 } else {
534                     found = true;
535                     position = i + 4;
536                 }
537             }
538         }
539 
540         if (!found) { // no merge mining header
541             return (0, position - 4, ERR_NO_MERGE_HEADER);
542         } else {
543             return (sliceBytes32Int(rawBytes, position), position - 4, 1);
544         }
545     }
546 
547     // @dev - Evaluate the merkle root
548     //
549     // Given an array of hashes it calculates the
550     // root of the merkle tree.
551     //
552     // @return root of merkle tree
553     function makeMerkle(bytes32[] hashes2) external pure returns (bytes32) {
554         bytes32[] memory hashes = hashes2;
555         uint length = hashes.length;
556         if (length == 1) return hashes[0];
557         require(length > 0);
558         uint i;
559         uint j;
560         uint k;
561         k = 0;
562         while (length > 1) {
563             k = 0;
564             for (i = 0; i < length; i += 2) {
565                 j = i+1<length ? i+1 : length-1;
566                 hashes[k] = bytes32(concatHash(uint(hashes[i]), uint(hashes[j])));
567                 k += 1;
568             }
569             length = k;
570         }
571         return hashes[0];
572     }
573 
574     // @dev - For a valid proof, returns the root of the Merkle tree.
575     //
576     // @param _txHash - transaction hash
577     // @param _txIndex - transaction's index within the block it's assumed to be in
578     // @param _siblings - transaction's Merkle siblings
579     // @return - Merkle tree root of the block the transaction belongs to if the proof is valid,
580     // garbage if it's invalid
581     function computeMerkle(uint _txHash, uint _txIndex, uint[] memory _siblings) internal pure returns (uint) {
582         uint resultHash = _txHash;
583         uint i = 0;
584         while (i < _siblings.length) {
585             uint proofHex = _siblings[i];
586 
587             uint sideOfSiblings = _txIndex % 2;  // 0 means _siblings is on the right; 1 means left
588 
589             uint left;
590             uint right;
591             if (sideOfSiblings == 1) {
592                 left = proofHex;
593                 right = resultHash;
594             } else if (sideOfSiblings == 0) {
595                 left = resultHash;
596                 right = proofHex;
597             }
598 
599             resultHash = concatHash(left, right);
600 
601             _txIndex /= 2;
602             i += 1;
603         }
604 
605         return resultHash;
606     }
607 
608     // @dev - calculates the Merkle root of a tree containing Litecoin transactions
609     // in order to prove that `ap`'s coinbase tx is in that Litecoin block.
610     //
611     // @param _ap - AuxPoW information
612     // @return - Merkle root of Litecoin block that the Syscoin block
613     // with this info was mined in if AuxPoW Merkle proof is correct,
614     // garbage otherwise
615     function computeParentMerkle(AuxPoW memory _ap) internal pure returns (uint) {
616         return flip32Bytes(computeMerkle(_ap.txHash,
617                                          _ap.coinbaseTxIndex,
618                                          _ap.parentMerkleProof));
619     }
620 
621     // @dev - calculates the Merkle root of a tree containing auxiliary block hashes
622     // in order to prove that the Syscoin block identified by _blockHash
623     // was merge-mined in a Litecoin block.
624     //
625     // @param _blockHash - SHA-256 hash of a certain Syscoin block
626     // @param _ap - AuxPoW information corresponding to said block
627     // @return - Merkle root of auxiliary chain tree
628     // if AuxPoW Merkle proof is correct, garbage otherwise
629     function computeChainMerkle(uint _blockHash, AuxPoW memory _ap) internal pure returns (uint) {
630         return computeMerkle(_blockHash,
631                              _ap.syscoinHashIndex,
632                              _ap.chainMerkleProof);
633     }
634 
635     // @dev - Helper function for Merkle root calculation.
636     // Given two sibling nodes in a Merkle tree, calculate their parent.
637     // Concatenates hashes `_tx1` and `_tx2`, then hashes the result.
638     //
639     // @param _tx1 - Merkle node (either root or internal node)
640     // @param _tx2 - Merkle node (either root or internal node), has to be `_tx1`'s sibling
641     // @return - `_tx1` and `_tx2`'s parent, i.e. the result of concatenating them,
642     // hashing that twice and flipping the bytes.
643     function concatHash(uint _tx1, uint _tx2) internal pure returns (uint) {
644         return flip32Bytes(uint(sha256(abi.encodePacked(sha256(abi.encodePacked(flip32Bytes(_tx1), flip32Bytes(_tx2)))))));
645     }
646 
647     // @dev - checks if a merge-mined block's Merkle proofs are correct,
648     // i.e. Syscoin block hash is in coinbase Merkle tree
649     // and coinbase transaction is in parent Merkle tree.
650     //
651     // @param _blockHash - SHA-256 hash of the block whose Merkle proofs are being checked
652     // @param _ap - AuxPoW struct corresponding to the block
653     // @return 1 if block was merge-mined and coinbase index, chain Merkle root and Merkle proofs are correct,
654     // respective error code otherwise
655     function checkAuxPoW(uint _blockHash, AuxPoW memory _ap) internal pure returns (uint) {
656         if (_ap.coinbaseTxIndex != 0) {
657             return ERR_COINBASE_INDEX;
658         }
659 
660         if (_ap.coinbaseMerkleRootCode != 1) {
661             return _ap.coinbaseMerkleRootCode;
662         }
663 
664         if (computeChainMerkle(_blockHash, _ap) != _ap.coinbaseMerkleRoot) {
665             return ERR_CHAIN_MERKLE;
666         }
667 
668         if (computeParentMerkle(_ap) != _ap.parentMerkleRoot) {
669             return ERR_PARENT_MERKLE;
670         }
671 
672         return 1;
673     }
674 
675     function sha256mem(bytes memory _rawBytes, uint offset, uint len) internal view returns (bytes32 result) {
676         assembly {
677             // Call sha256 precompiled contract (located in address 0x02) to copy data.
678             // Assign to ptr the next available memory position (stored in memory position 0x40).
679             let ptr := mload(0x40)
680             if iszero(staticcall(gas, 0x02, add(add(_rawBytes, 0x20), offset), len, ptr, 0x20)) {
681                 revert(0, 0)
682             }
683             result := mload(ptr)
684         }
685     }
686 
687     // @dev - Bitcoin-way of hashing
688     // @param _dataBytes - raw data to be hashed
689     // @return - result of applying SHA-256 twice to raw data and then flipping the bytes
690     function dblShaFlip(bytes _dataBytes) internal pure returns (uint) {
691         return flip32Bytes(uint(sha256(abi.encodePacked(sha256(abi.encodePacked(_dataBytes))))));
692     }
693 
694     // @dev - Bitcoin-way of hashing
695     // @param _dataBytes - raw data to be hashed
696     // @return - result of applying SHA-256 twice to raw data and then flipping the bytes
697     function dblShaFlipMem(bytes memory _rawBytes, uint offset, uint len) internal view returns (uint) {
698         return flip32Bytes(uint(sha256(abi.encodePacked(sha256mem(_rawBytes, offset, len)))));
699     }
700 
701     // @dev – Read a bytes32 from an offset in the byte array
702     function readBytes32(bytes memory data, uint offset) internal pure returns (bytes32) {
703         bytes32 result;
704         assembly {
705             result := mload(add(add(data, 0x20), offset))
706         }
707         return result;
708     }
709 
710     // @dev – Read an uint32 from an offset in the byte array
711     function readUint32(bytes memory data, uint offset) internal pure returns (uint32) {
712         uint32 result;
713         assembly {
714             result := mload(add(add(data, 0x20), offset))
715             
716         }
717         return result;
718     }
719 
720     // @dev - Bitcoin-way of computing the target from the 'bits' field of a block header
721     // based on http://www.righto.com/2014/02/bitcoin-mining-hard-way-algorithms.html//ref3
722     //
723     // @param _bits - difficulty in bits format
724     // @return - difficulty in target format
725     function targetFromBits(uint32 _bits) internal pure returns (uint) {
726         uint exp = _bits / 0x1000000;  // 2**24
727         uint mant = _bits & 0xffffff;
728         return mant * 256**(exp - 3);
729     }
730 
731     uint constant SYSCOIN_DIFFICULTY_ONE = 0xFFFFF * 256**(0x1e - 3);
732 
733     // @dev - Calculate syscoin difficulty from target
734     // https://en.bitcoin.it/wiki/Difficulty
735     // Min difficulty for bitcoin is 0x1d00ffff
736     // Min difficulty for syscoin is 0x1e0fffff
737     function targetToDiff(uint target) internal pure returns (uint) {
738         return SYSCOIN_DIFFICULTY_ONE / target;
739     }
740     
741 
742     // 0x00 version
743     // 0x04 prev block hash
744     // 0x24 merkle root
745     // 0x44 timestamp
746     // 0x48 bits
747     // 0x4c nonce
748 
749     // @dev - extract previous block field from a raw Syscoin block header
750     //
751     // @param _blockHeader - Syscoin block header bytes
752     // @param pos - where to start reading hash from
753     // @return - hash of block's parent in big endian format
754     function getHashPrevBlock(bytes memory _blockHeader) internal pure returns (uint) {
755         uint hashPrevBlock;
756         assembly {
757             hashPrevBlock := mload(add(add(_blockHeader, 32), 0x04))
758         }
759         return flip32Bytes(hashPrevBlock);
760     }
761 
762     // @dev - extract Merkle root field from a raw Syscoin block header
763     //
764     // @param _blockHeader - Syscoin block header bytes
765     // @param pos - where to start reading root from
766     // @return - block's Merkle root in big endian format
767     function getHeaderMerkleRoot(bytes memory _blockHeader) public pure returns (uint) {
768         uint merkle;
769         assembly {
770             merkle := mload(add(add(_blockHeader, 32), 0x24))
771         }
772         return flip32Bytes(merkle);
773     }
774 
775     // @dev - extract timestamp field from a raw Syscoin block header
776     //
777     // @param _blockHeader - Syscoin block header bytes
778     // @param pos - where to start reading bits from
779     // @return - block's timestamp in big-endian format
780     function getTimestamp(bytes memory _blockHeader) internal pure returns (uint32 time) {
781         return bytesToUint32Flipped(_blockHeader, 0x44);
782     }
783 
784     // @dev - extract bits field from a raw Syscoin block header
785     //
786     // @param _blockHeader - Syscoin block header bytes
787     // @param pos - where to start reading bits from
788     // @return - block's difficulty in bits format, also big-endian
789     function getBits(bytes memory _blockHeader) internal pure returns (uint32 bits) {
790         return bytesToUint32Flipped(_blockHeader, 0x48);
791     }
792 
793 
794     // @dev - converts raw bytes representation of a Syscoin block header to struct representation
795     //
796     // @param _rawBytes - first 80 bytes of a block header
797     // @return - exact same header information in BlockHeader struct form
798     function parseHeaderBytes(bytes memory _rawBytes, uint pos) internal view returns (BlockHeader bh) {
799         bh.bits = getBits(_rawBytes);
800         bh.blockHash = dblShaFlipMem(_rawBytes, pos, 80);
801     }
802 
803     uint32 constant VERSION_AUXPOW = (1 << 8);
804 
805     // @dev - Converts a bytes of size 4 to uint32,
806     // e.g. for input [0x01, 0x02, 0x03 0x04] returns 0x01020304
807     function bytesToUint32Flipped(bytes memory input, uint pos) internal pure returns (uint32 result) {
808         result = uint32(input[pos]) + uint32(input[pos + 1])*(2**8) + uint32(input[pos + 2])*(2**16) + uint32(input[pos + 3])*(2**24);
809     }
810     function bytesToUint64(bytes memory input, uint pos) internal pure returns (uint64 result) {
811         result = uint64(input[pos+7]) + uint64(input[pos + 6])*(2**8) + uint64(input[pos + 5])*(2**16) + uint64(input[pos + 4])*(2**24) + uint64(input[pos + 3])*(2**32) + uint64(input[pos + 2])*(2**40) + uint64(input[pos + 1])*(2**48) + uint64(input[pos])*(2**56);
812     }
813      function bytesToUint32(bytes memory input, uint pos) internal pure returns (uint32 result) {
814         result = uint32(input[pos+3]) + uint32(input[pos + 2])*(2**8) + uint32(input[pos + 1])*(2**16) + uint32(input[pos])*(2**24);
815     }  
816     // @dev - checks version to determine if a block has merge mining information
817     function isMergeMined(bytes memory _rawBytes, uint pos) internal pure returns (bool) {
818         return bytesToUint32Flipped(_rawBytes, pos) & VERSION_AUXPOW != 0;
819     }
820 
821     // @dev - Verify block header
822     // @param _blockHeaderBytes - array of bytes with the block header
823     // @param _pos - starting position of the block header
824 	// @param _proposedBlockHash - proposed block hash computing from block header bytes
825     // @return - [ErrorCode, IsMergeMined]
826     function verifyBlockHeader(bytes _blockHeaderBytes, uint _pos, uint _proposedBlockHash) external view returns (uint, bool) {
827         BlockHeader memory blockHeader = parseHeaderBytes(_blockHeaderBytes, _pos);
828         uint blockSha256Hash = blockHeader.blockHash;
829 		// must confirm that the header hash passed in and computing hash matches
830 		if(blockSha256Hash != _proposedBlockHash){
831 			return (ERR_INVALID_HEADER_HASH, true);
832 		}
833         uint target = targetFromBits(blockHeader.bits);
834         if (_blockHeaderBytes.length > 80 && isMergeMined(_blockHeaderBytes, 0)) {
835             AuxPoW memory ap = parseAuxPoW(_blockHeaderBytes, _pos);
836             if (ap.blockHash > target) {
837 
838                 return (ERR_PROOF_OF_WORK_AUXPOW, true);
839             }
840             uint auxPoWCode = checkAuxPoW(blockSha256Hash, ap);
841             if (auxPoWCode != 1) {
842                 return (auxPoWCode, true);
843             }
844             return (0, true);
845         } else {
846             if (_proposedBlockHash > target) {
847                 return (ERR_PROOF_OF_WORK, false);
848             }
849             return (0, false);
850         }
851     }
852 
853     // For verifying Syscoin difficulty
854     int64 constant TARGET_TIMESPAN =  int64(21600); 
855     int64 constant TARGET_TIMESPAN_DIV_4 = TARGET_TIMESPAN / int64(4);
856     int64 constant TARGET_TIMESPAN_MUL_4 = TARGET_TIMESPAN * int64(4);
857     int64 constant TARGET_TIMESPAN_ADJUSTMENT =  int64(360);  // 6 hour
858     uint constant INITIAL_CHAIN_WORK =  0x100001; 
859     uint constant POW_LIMIT = 0x00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
860 
861     // @dev - Calculate difficulty from compact representation (bits) found in block
862     function diffFromBits(uint32 bits) external pure returns (uint) {
863         return targetToDiff(targetFromBits(bits))*INITIAL_CHAIN_WORK;
864     }
865     
866     function difficultyAdjustmentInterval() external pure returns (int64) {
867         return TARGET_TIMESPAN_ADJUSTMENT;
868     }
869     // @param _actualTimespan - time elapsed from previous block creation til current block creation;
870     // i.e., how much time it took to mine the current block
871     // @param _bits - previous block header difficulty (in bits)
872     // @return - expected difficulty for the next block
873     function calculateDifficulty(int64 _actualTimespan, uint32 _bits) external pure returns (uint32 result) {
874        int64 actualTimespan = _actualTimespan;
875         // Limit adjustment step
876         if (_actualTimespan < TARGET_TIMESPAN_DIV_4) {
877             actualTimespan = TARGET_TIMESPAN_DIV_4;
878         } else if (_actualTimespan > TARGET_TIMESPAN_MUL_4) {
879             actualTimespan = TARGET_TIMESPAN_MUL_4;
880         }
881 
882         // Retarget
883         uint bnNew = targetFromBits(_bits);
884         bnNew = bnNew * uint(actualTimespan);
885         bnNew = uint(bnNew) / uint(TARGET_TIMESPAN);
886 
887         if (bnNew > POW_LIMIT) {
888             bnNew = POW_LIMIT;
889         }
890 
891         return toCompactBits(bnNew);
892     }
893 
894     // @dev - shift information to the right by a specified number of bits
895     //
896     // @param _val - value to be shifted
897     // @param _shift - number of bits to shift
898     // @return - `_val` shifted `_shift` bits to the right, i.e. divided by 2**`_shift`
899     function shiftRight(uint _val, uint _shift) private pure returns (uint) {
900         return _val / uint(2)**_shift;
901     }
902 
903     // @dev - shift information to the left by a specified number of bits
904     //
905     // @param _val - value to be shifted
906     // @param _shift - number of bits to shift
907     // @return - `_val` shifted `_shift` bits to the left, i.e. multiplied by 2**`_shift`
908     function shiftLeft(uint _val, uint _shift) private pure returns (uint) {
909         return _val * uint(2)**_shift;
910     }
911 
912     // @dev - get the number of bits required to represent a given integer value without losing information
913     //
914     // @param _val - unsigned integer value
915     // @return - given value's bit length
916     function bitLen(uint _val) private pure returns (uint length) {
917         uint int_type = _val;
918         while (int_type > 0) {
919             int_type = shiftRight(int_type, 1);
920             length += 1;
921         }
922     }
923 
924     // @dev - Convert uint256 to compact encoding
925     // based on https://github.com/petertodd/python-bitcoinlib/blob/2a5dda45b557515fb12a0a18e5dd48d2f5cd13c2/bitcoin/core/serialize.py
926     // Analogous to arith_uint256::GetCompact from C++ implementation
927     //
928     // @param _val - difficulty in target format
929     // @return - difficulty in bits format
930     function toCompactBits(uint _val) private pure returns (uint32) {
931         uint nbytes = uint (shiftRight((bitLen(_val) + 7), 3));
932         uint32 compact = 0;
933         if (nbytes <= 3) {
934             compact = uint32 (shiftLeft((_val & 0xFFFFFF), 8 * (3 - nbytes)));
935         } else {
936             compact = uint32 (shiftRight(_val, 8 * (nbytes - 3)));
937             compact = uint32 (compact & 0xFFFFFF);
938         }
939 
940         // If the sign bit (0x00800000) is set, divide the mantissa by 256 and
941         // increase the exponent to get an encoding without it set.
942         if ((compact & 0x00800000) > 0) {
943             compact = uint32(shiftRight(compact, 8));
944             nbytes += 1;
945         }
946 
947         return compact | uint32(shiftLeft(nbytes, 24));
948     }
949 }
950 
951 // @dev - SyscoinSuperblocks error codes
952 contract SyscoinErrorCodes {
953     // Error codes
954     uint constant ERR_SUPERBLOCK_OK = 0;
955     uint constant ERR_SUPERBLOCK_BAD_STATUS = 50020;
956     uint constant ERR_SUPERBLOCK_BAD_SYSCOIN_STATUS = 50025;
957     uint constant ERR_SUPERBLOCK_NO_TIMEOUT = 50030;
958     uint constant ERR_SUPERBLOCK_BAD_TIMESTAMP = 50035;
959     uint constant ERR_SUPERBLOCK_INVALID_MERKLE = 50040;
960     uint constant ERR_SUPERBLOCK_BAD_PARENT = 50050;
961     uint constant ERR_SUPERBLOCK_OWN_CHALLENGE = 50055;
962 
963     uint constant ERR_SUPERBLOCK_MIN_DEPOSIT = 50060;
964 
965     uint constant ERR_SUPERBLOCK_NOT_CLAIMMANAGER = 50070;
966 
967     uint constant ERR_SUPERBLOCK_BAD_CLAIM = 50080;
968     uint constant ERR_SUPERBLOCK_VERIFICATION_PENDING = 50090;
969     uint constant ERR_SUPERBLOCK_CLAIM_DECIDED = 50100;
970     uint constant ERR_SUPERBLOCK_BAD_CHALLENGER = 50110;
971 
972     uint constant ERR_SUPERBLOCK_BAD_ACCUMULATED_WORK = 50120;
973     uint constant ERR_SUPERBLOCK_BAD_BITS = 50130;
974     uint constant ERR_SUPERBLOCK_MISSING_CONFIRMATIONS = 50140;
975     uint constant ERR_SUPERBLOCK_BAD_LASTBLOCK = 50150;
976     uint constant ERR_SUPERBLOCK_BAD_BLOCKHEIGHT = 50160;
977 
978     // error codes for verifyTx
979     uint constant ERR_BAD_FEE = 20010;
980     uint constant ERR_CONFIRMATIONS = 20020;
981     uint constant ERR_CHAIN = 20030;
982     uint constant ERR_SUPERBLOCK = 20040;
983     uint constant ERR_MERKLE_ROOT = 20050;
984     uint constant ERR_TX_64BYTE = 20060;
985     // error codes for relayTx
986     uint constant ERR_RELAY_VERIFY = 30010;
987 
988     // Minimum gas requirements
989     uint constant public minReward = 1000000000000000000;
990     uint constant public superblockCost = 440000;
991     uint constant public challengeCost = 34000;
992     uint constant public minProposalDeposit = challengeCost + minReward;
993     uint constant public minChallengeDeposit = superblockCost + minReward;
994     uint constant public respondMerkleRootHashesCost = 378000; // TODO: measure this with 60 hashes
995     uint constant public respondBlockHeaderCost = 40000;
996     uint constant public verifySuperblockCost = 220000;
997 }
998 
999 // @dev - Manages superblocks
1000 //
1001 // Management of superblocks and status transitions
1002 contract SyscoinSuperblocks is SyscoinErrorCodes {
1003 
1004     // @dev - Superblock status
1005     enum Status { Unitialized, New, InBattle, SemiApproved, Approved, Invalid }
1006 
1007     struct SuperblockInfo {
1008         bytes32 blocksMerkleRoot;
1009         uint accumulatedWork;
1010         uint timestamp;
1011         uint prevTimestamp;
1012         bytes32 lastHash;
1013         bytes32 parentId;
1014         address submitter;
1015         bytes32 ancestors;
1016         uint32 lastBits;
1017         uint32 index;
1018         uint32 height;
1019         uint32 blockHeight;
1020         Status status;
1021     }
1022 
1023     // Mapping superblock id => superblock data
1024     mapping (bytes32 => SuperblockInfo) superblocks;
1025 
1026     // Index to superblock id
1027     mapping (uint32 => bytes32) private indexSuperblock;
1028 
1029     struct ProcessTransactionParams {
1030         uint value;
1031         address destinationAddress;
1032         uint32 assetGUID;
1033         address superblockSubmitterAddress;
1034         SyscoinTransactionProcessor untrustedTargetContract;
1035     }
1036 
1037     mapping (uint => ProcessTransactionParams) private txParams;
1038 
1039     uint32 indexNextSuperblock;
1040 
1041     bytes32 public bestSuperblock;
1042     uint public bestSuperblockAccumulatedWork;
1043 
1044     event NewSuperblock(bytes32 superblockHash, address who);
1045     event ApprovedSuperblock(bytes32 superblockHash, address who);
1046     event ChallengeSuperblock(bytes32 superblockHash, address who);
1047     event SemiApprovedSuperblock(bytes32 superblockHash, address who);
1048     event InvalidSuperblock(bytes32 superblockHash, address who);
1049 
1050     event ErrorSuperblock(bytes32 superblockHash, uint err);
1051 
1052     event VerifyTransaction(bytes32 txHash, uint returnCode);
1053     event RelayTransaction(bytes32 txHash, uint returnCode);
1054 
1055     // SyscoinClaimManager
1056     address public trustedClaimManager;
1057 
1058     modifier onlyClaimManager() {
1059         require(msg.sender == trustedClaimManager);
1060         _;
1061     }
1062 
1063     // @dev – the constructor
1064     constructor() public {}
1065 
1066     // @dev - sets ClaimManager instance associated with managing superblocks.
1067     // Once trustedClaimManager has been set, it cannot be changed.
1068     // @param _claimManager - address of the ClaimManager contract to be associated with
1069     function setClaimManager(address _claimManager) public {
1070         require(address(trustedClaimManager) == 0x0 && _claimManager != 0x0);
1071         trustedClaimManager = _claimManager;
1072     }
1073 
1074     // @dev - Initializes superblocks contract
1075     //
1076     // Initializes the superblock contract. It can only be called once.
1077     //
1078     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1079     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1080     // @param _timestamp Timestamp of the last block in the superblock
1081     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1082     // @param _lastHash Hash of the last block in the superblock
1083     // @param _lastBits Difficulty bits of the last block in the superblock
1084     // @param _parentId Id of the parent superblock
1085     // @param _blockHeight Block height of last block in superblock   
1086     // @return Error code and superblockHash
1087     function initialize(
1088         bytes32 _blocksMerkleRoot,
1089         uint _accumulatedWork,
1090         uint _timestamp,
1091         uint _prevTimestamp,
1092         bytes32 _lastHash,
1093         uint32 _lastBits,
1094         bytes32 _parentId,
1095         uint32 _blockHeight
1096     ) public returns (uint, bytes32) {
1097         require(bestSuperblock == 0);
1098         require(_parentId == 0);
1099 
1100         bytes32 superblockHash = calcSuperblockHash(_blocksMerkleRoot, _accumulatedWork, _timestamp, _prevTimestamp, _lastHash, _lastBits, _parentId, _blockHeight);
1101         SuperblockInfo storage superblock = superblocks[superblockHash];
1102 
1103         require(superblock.status == Status.Unitialized);
1104 
1105         indexSuperblock[indexNextSuperblock] = superblockHash;
1106 
1107         superblock.blocksMerkleRoot = _blocksMerkleRoot;
1108         superblock.accumulatedWork = _accumulatedWork;
1109         superblock.timestamp = _timestamp;
1110         superblock.prevTimestamp = _prevTimestamp;
1111         superblock.lastHash = _lastHash;
1112         superblock.parentId = _parentId;
1113         superblock.submitter = msg.sender;
1114         superblock.index = indexNextSuperblock;
1115         superblock.height = 1;
1116         superblock.lastBits = _lastBits;
1117         superblock.status = Status.Approved;
1118         superblock.ancestors = 0x0;
1119         superblock.blockHeight = _blockHeight;
1120         indexNextSuperblock++;
1121 
1122         emit NewSuperblock(superblockHash, msg.sender);
1123 
1124         bestSuperblock = superblockHash;
1125         bestSuperblockAccumulatedWork = _accumulatedWork;
1126 
1127         emit ApprovedSuperblock(superblockHash, msg.sender);
1128 
1129         return (ERR_SUPERBLOCK_OK, superblockHash);
1130     }
1131 
1132     // @dev - Proposes a new superblock
1133     //
1134     // To be accepted, a new superblock needs to have its parent
1135     // either approved or semi-approved.
1136     //
1137     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1138     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1139     // @param _timestamp Timestamp of the last block in the superblock
1140     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1141     // @param _lastHash Hash of the last block in the superblock
1142     // @param _lastBits Difficulty bits of the last block in the superblock
1143     // @param _parentId Id of the parent superblock
1144     // @param _blockHeight Block height of last block in superblock
1145     // @return Error code and superblockHash
1146     function propose(
1147         bytes32 _blocksMerkleRoot,
1148         uint _accumulatedWork,
1149         uint _timestamp,
1150         uint _prevTimestamp,
1151         bytes32 _lastHash,
1152         uint32 _lastBits,
1153         bytes32 _parentId,
1154         uint32 _blockHeight,
1155         address submitter
1156     ) public returns (uint, bytes32) {
1157         if (msg.sender != trustedClaimManager) {
1158             emit ErrorSuperblock(0, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1159             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1160         }
1161 
1162         SuperblockInfo storage parent = superblocks[_parentId];
1163         if (parent.status != Status.SemiApproved && parent.status != Status.Approved) {
1164             emit ErrorSuperblock(superblockHash, ERR_SUPERBLOCK_BAD_PARENT);
1165             return (ERR_SUPERBLOCK_BAD_PARENT, 0);
1166         }
1167 
1168         bytes32 superblockHash = calcSuperblockHash(_blocksMerkleRoot, _accumulatedWork, _timestamp, _prevTimestamp, _lastHash, _lastBits, _parentId, _blockHeight);
1169         SuperblockInfo storage superblock = superblocks[superblockHash];
1170         if (superblock.status == Status.Unitialized) {
1171             indexSuperblock[indexNextSuperblock] = superblockHash;
1172             superblock.blocksMerkleRoot = _blocksMerkleRoot;
1173             superblock.accumulatedWork = _accumulatedWork;
1174             superblock.timestamp = _timestamp;
1175             superblock.prevTimestamp = _prevTimestamp;
1176             superblock.lastHash = _lastHash;
1177             superblock.parentId = _parentId;
1178             superblock.submitter = submitter;
1179             superblock.index = indexNextSuperblock;
1180             superblock.height = parent.height + 1;
1181             superblock.lastBits = _lastBits;
1182             superblock.status = Status.New;
1183             superblock.blockHeight = _blockHeight;
1184             superblock.ancestors = updateAncestors(parent.ancestors, parent.index, parent.height);
1185             indexNextSuperblock++;
1186             emit NewSuperblock(superblockHash, submitter);
1187         }
1188         
1189 
1190         return (ERR_SUPERBLOCK_OK, superblockHash);
1191     }
1192 
1193     // @dev - Confirm a proposed superblock
1194     //
1195     // An unchallenged superblock can be confirmed after a timeout.
1196     // A challenged superblock is confirmed if it has enough descendants
1197     // in the main chain.
1198     //
1199     // @param _superblockHash Id of the superblock to confirm
1200     // @param _validator Address requesting superblock confirmation
1201     // @return Error code and superblockHash
1202     function confirm(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1203         if (msg.sender != trustedClaimManager) {
1204             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1205             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1206         }
1207         SuperblockInfo storage superblock = superblocks[_superblockHash];
1208         if (superblock.status != Status.New && superblock.status != Status.SemiApproved) {
1209             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1210             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1211         }
1212         SuperblockInfo storage parent = superblocks[superblock.parentId];
1213         if (parent.status != Status.Approved) {
1214             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_PARENT);
1215             return (ERR_SUPERBLOCK_BAD_PARENT, 0);
1216         }
1217         superblock.status = Status.Approved;
1218         if (superblock.accumulatedWork > bestSuperblockAccumulatedWork) {
1219             bestSuperblock = _superblockHash;
1220             bestSuperblockAccumulatedWork = superblock.accumulatedWork;
1221         }
1222         emit ApprovedSuperblock(_superblockHash, _validator);
1223         return (ERR_SUPERBLOCK_OK, _superblockHash);
1224     }
1225 
1226     // @dev - Challenge a proposed superblock
1227     //
1228     // A new superblock can be challenged to start a battle
1229     // to verify the correctness of the data submitted.
1230     //
1231     // @param _superblockHash Id of the superblock to challenge
1232     // @param _challenger Address requesting a challenge
1233     // @return Error code and superblockHash
1234     function challenge(bytes32 _superblockHash, address _challenger) public returns (uint, bytes32) {
1235         if (msg.sender != trustedClaimManager) {
1236             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1237             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1238         }
1239         SuperblockInfo storage superblock = superblocks[_superblockHash];
1240         if (superblock.status != Status.New && superblock.status != Status.InBattle) {
1241             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1242             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1243         }
1244         if(superblock.submitter == _challenger){
1245             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_OWN_CHALLENGE);
1246             return (ERR_SUPERBLOCK_OWN_CHALLENGE, 0);        
1247         }
1248         superblock.status = Status.InBattle;
1249         emit ChallengeSuperblock(_superblockHash, _challenger);
1250         return (ERR_SUPERBLOCK_OK, _superblockHash);
1251     }
1252 
1253     // @dev - Semi-approve a challenged superblock
1254     //
1255     // A challenged superblock can be marked as semi-approved
1256     // if it satisfies all the queries or when all challengers have
1257     // stopped participating.
1258     //
1259     // @param _superblockHash Id of the superblock to semi-approve
1260     // @param _validator Address requesting semi approval
1261     // @return Error code and superblockHash
1262     function semiApprove(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1263         if (msg.sender != trustedClaimManager) {
1264             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1265             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1266         }
1267         SuperblockInfo storage superblock = superblocks[_superblockHash];
1268 
1269         if (superblock.status != Status.InBattle && superblock.status != Status.New) {
1270             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1271             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1272         }
1273         superblock.status = Status.SemiApproved;
1274         emit SemiApprovedSuperblock(_superblockHash, _validator);
1275         return (ERR_SUPERBLOCK_OK, _superblockHash);
1276     }
1277 
1278     // @dev - Invalidates a superblock
1279     //
1280     // A superblock with incorrect data can be invalidated immediately.
1281     // Superblocks that are not in the main chain can be invalidated
1282     // if not enough superblocks follow them, i.e. they don't have
1283     // enough descendants.
1284     //
1285     // @param _superblockHash Id of the superblock to invalidate
1286     // @param _validator Address requesting superblock invalidation
1287     // @return Error code and superblockHash
1288     function invalidate(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1289         if (msg.sender != trustedClaimManager) {
1290             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1291             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1292         }
1293         SuperblockInfo storage superblock = superblocks[_superblockHash];
1294         if (superblock.status != Status.InBattle && superblock.status != Status.SemiApproved) {
1295             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1296             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1297         }
1298         superblock.status = Status.Invalid;
1299         emit InvalidSuperblock(_superblockHash, _validator);
1300         return (ERR_SUPERBLOCK_OK, _superblockHash);
1301     }
1302 
1303     // @dev - relays transaction `_txBytes` to `_untrustedTargetContract`'s processTransaction() method.
1304     // Also logs the value of processTransaction.
1305     // Note: callers cannot be 100% certain when an ERR_RELAY_VERIFY occurs because
1306     // it may also have been returned by processTransaction(). Callers should be
1307     // aware of the contract that they are relaying transactions to and
1308     // understand what that contract's processTransaction method returns.
1309     //
1310     // @param _txBytes - transaction bytes
1311     // @param _txIndex - transaction's index within the block
1312     // @param _txSiblings - transaction's Merkle siblings
1313     // @param _syscoinBlockHeader - block header containing transaction
1314     // @param _syscoinBlockIndex - block's index withing superblock
1315     // @param _syscoinBlockSiblings - block's merkle siblings
1316     // @param _superblockHash - superblock containing block header
1317     // @param _untrustedTargetContract - the contract that is going to process the transaction
1318     function relayTx(
1319         bytes memory _txBytes,
1320         uint _txIndex,
1321         uint[] _txSiblings,
1322         bytes memory _syscoinBlockHeader,
1323         uint _syscoinBlockIndex,
1324         uint[] memory _syscoinBlockSiblings,
1325         bytes32 _superblockHash,
1326         SyscoinTransactionProcessor _untrustedTargetContract
1327     ) public returns (uint) {
1328 
1329         // Check if Syscoin block belongs to given superblock
1330         if (bytes32(SyscoinMessageLibrary.computeMerkle(SyscoinMessageLibrary.dblShaFlip(_syscoinBlockHeader), _syscoinBlockIndex, _syscoinBlockSiblings))
1331             != getSuperblockMerkleRoot(_superblockHash)) {
1332             // Syscoin block is not in superblock
1333             emit RelayTransaction(bytes32(0), ERR_SUPERBLOCK);
1334             return ERR_SUPERBLOCK;
1335         }
1336         uint txHash = verifyTx(_txBytes, _txIndex, _txSiblings, _syscoinBlockHeader, _superblockHash);
1337         if (txHash != 0) {
1338             uint ret = parseTxHelper(_txBytes, txHash, _untrustedTargetContract);
1339             if(ret != 0){
1340                 emit RelayTransaction(bytes32(0), ret);
1341                 return ret;
1342             }
1343             ProcessTransactionParams memory params = txParams[txHash];
1344             params.superblockSubmitterAddress = superblocks[_superblockHash].submitter;
1345             txParams[txHash] = params;
1346             return verifyTxHelper(txHash);
1347         }
1348         emit RelayTransaction(bytes32(0), ERR_RELAY_VERIFY);
1349         return(ERR_RELAY_VERIFY);        
1350     }
1351     function parseTxHelper(bytes memory _txBytes, uint txHash, SyscoinTransactionProcessor _untrustedTargetContract) private returns (uint) {
1352         uint value;
1353         address destinationAddress;
1354         uint32 _assetGUID;
1355         uint ret;
1356         (ret, value, destinationAddress, _assetGUID) = SyscoinMessageLibrary.parseTransaction(_txBytes);
1357         if(ret != 0){
1358             return ret;
1359         }
1360 
1361         ProcessTransactionParams memory params;
1362         params.value = value;
1363         params.destinationAddress = destinationAddress;
1364         params.assetGUID = _assetGUID;
1365         params.untrustedTargetContract = _untrustedTargetContract;
1366         txParams[txHash] = params;        
1367         return 0;
1368     }
1369     function verifyTxHelper(uint txHash) private returns (uint) {
1370         ProcessTransactionParams memory params = txParams[txHash];        
1371         uint returnCode = params.untrustedTargetContract.processTransaction(txHash, params.value, params.destinationAddress, params.assetGUID, params.superblockSubmitterAddress);
1372         emit RelayTransaction(bytes32(txHash), returnCode);
1373         return (returnCode);
1374     }
1375     // @dev - Checks whether the transaction given by `_txBytes` is in the block identified by `_txBlockHeaderBytes`.
1376     // First it guards against a Merkle tree collision attack by raising an error if the transaction is exactly 64 bytes long,
1377     // then it calls helperVerifyHash to do the actual check.
1378     //
1379     // @param _txBytes - transaction bytes
1380     // @param _txIndex - transaction's index within the block
1381     // @param _siblings - transaction's Merkle siblings
1382     // @param _txBlockHeaderBytes - block header containing transaction
1383     // @param _txsuperblockHash - superblock containing block header
1384     // @return - SHA-256 hash of _txBytes if the transaction is in the block, 0 otherwise
1385     // TODO: this can probably be made private
1386     function verifyTx(
1387         bytes memory _txBytes,
1388         uint _txIndex,
1389         uint[] memory _siblings,
1390         bytes memory _txBlockHeaderBytes,
1391         bytes32 _txsuperblockHash
1392     ) public returns (uint) {
1393         uint txHash = SyscoinMessageLibrary.dblShaFlip(_txBytes);
1394 
1395         if (_txBytes.length == 64) {  // todo: is check 32 also needed?
1396             emit VerifyTransaction(bytes32(txHash), ERR_TX_64BYTE);
1397             return 0;
1398         }
1399 
1400         if (helperVerifyHash(txHash, _txIndex, _siblings, _txBlockHeaderBytes, _txsuperblockHash) == 1) {
1401             return txHash;
1402         } else {
1403             // log is done via helperVerifyHash
1404             return 0;
1405         }
1406     }
1407 
1408     // @dev - Checks whether the transaction identified by `_txHash` is in the block identified by `_blockHeaderBytes`
1409     // and whether the block is in the Syscoin main chain. Transaction check is done via Merkle proof.
1410     // Note: no verification is performed to prevent txHash from just being an
1411     // internal hash in the Merkle tree. Thus this helper method should NOT be used
1412     // directly and is intended to be private.
1413     //
1414     // @param _txHash - transaction hash
1415     // @param _txIndex - transaction's index within the block
1416     // @param _siblings - transaction's Merkle siblings
1417     // @param _blockHeaderBytes - block header containing transaction
1418     // @param _txsuperblockHash - superblock containing block header
1419     // @return - 1 if the transaction is in the block and the block is in the main chain,
1420     // 20020 (ERR_CONFIRMATIONS) if the block is not in the main chain,
1421     // 20050 (ERR_MERKLE_ROOT) if the block is in the main chain but the Merkle proof fails.
1422     function helperVerifyHash(
1423         uint256 _txHash,
1424         uint _txIndex,
1425         uint[] memory _siblings,
1426         bytes memory _blockHeaderBytes,
1427         bytes32 _txsuperblockHash
1428     ) private returns (uint) {
1429 
1430         //TODO: Verify superblock is in superblock's main chain
1431         if (!isApproved(_txsuperblockHash) || !inMainChain(_txsuperblockHash)) {
1432             emit VerifyTransaction(bytes32(_txHash), ERR_CHAIN);
1433             return (ERR_CHAIN);
1434         }
1435 
1436         // Verify tx Merkle root
1437         uint merkle = SyscoinMessageLibrary.getHeaderMerkleRoot(_blockHeaderBytes);
1438         if (SyscoinMessageLibrary.computeMerkle(_txHash, _txIndex, _siblings) != merkle) {
1439             emit VerifyTransaction(bytes32(_txHash), ERR_MERKLE_ROOT);
1440             return (ERR_MERKLE_ROOT);
1441         }
1442 
1443         emit VerifyTransaction(bytes32(_txHash), 1);
1444         return (1);
1445     }
1446 
1447     // @dev - Calculate superblock hash from superblock data
1448     //
1449     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1450     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1451     // @param _timestamp Timestamp of the last block in the superblock
1452     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1453     // @param _lastHash Hash of the last block in the superblock
1454     // @param _lastBits Difficulty bits of the last block in the superblock
1455     // @param _parentId Id of the parent superblock
1456     // @param _blockHeight Block height of last block in superblock   
1457     // @return Superblock id
1458     function calcSuperblockHash(
1459         bytes32 _blocksMerkleRoot,
1460         uint _accumulatedWork,
1461         uint _timestamp,
1462         uint _prevTimestamp,
1463         bytes32 _lastHash,
1464         uint32 _lastBits,
1465         bytes32 _parentId,
1466         uint32 _blockHeight
1467     ) public pure returns (bytes32) {
1468         return keccak256(abi.encodePacked(
1469             _blocksMerkleRoot,
1470             _accumulatedWork,
1471             _timestamp,
1472             _prevTimestamp,
1473             _lastHash,
1474             _lastBits,
1475             _parentId,
1476             _blockHeight
1477         ));
1478     }
1479 
1480     // @dev - Returns the confirmed superblock with the most accumulated work
1481     //
1482     // @return Best superblock hash
1483     function getBestSuperblock() public view returns (bytes32) {
1484         return bestSuperblock;
1485     }
1486 
1487     // @dev - Returns the superblock data for the supplied superblock hash
1488     //
1489     // @return {
1490     //   bytes32 _blocksMerkleRoot,
1491     //   uint _accumulatedWork,
1492     //   uint _timestamp,
1493     //   uint _prevTimestamp,
1494     //   bytes32 _lastHash,
1495     //   uint32 _lastBits,
1496     //   bytes32 _parentId,
1497     //   address _submitter,
1498     //   Status _status,
1499     //   uint32 _blockHeight,
1500     // }  Superblock data
1501     function getSuperblock(bytes32 superblockHash) public view returns (
1502         bytes32 _blocksMerkleRoot,
1503         uint _accumulatedWork,
1504         uint _timestamp,
1505         uint _prevTimestamp,
1506         bytes32 _lastHash,
1507         uint32 _lastBits,
1508         bytes32 _parentId,
1509         address _submitter,
1510         Status _status,
1511         uint32 _blockHeight
1512     ) {
1513         SuperblockInfo storage superblock = superblocks[superblockHash];
1514         return (
1515             superblock.blocksMerkleRoot,
1516             superblock.accumulatedWork,
1517             superblock.timestamp,
1518             superblock.prevTimestamp,
1519             superblock.lastHash,
1520             superblock.lastBits,
1521             superblock.parentId,
1522             superblock.submitter,
1523             superblock.status,
1524             superblock.blockHeight
1525         );
1526     }
1527 
1528     // @dev - Returns superblock height
1529     function getSuperblockHeight(bytes32 superblockHash) public view returns (uint32) {
1530         return superblocks[superblockHash].height;
1531     }
1532 
1533     // @dev - Returns superblock internal index
1534     function getSuperblockIndex(bytes32 superblockHash) public view returns (uint32) {
1535         return superblocks[superblockHash].index;
1536     }
1537 
1538     // @dev - Return superblock ancestors' indexes
1539     function getSuperblockAncestors(bytes32 superblockHash) public view returns (bytes32) {
1540         return superblocks[superblockHash].ancestors;
1541     }
1542 
1543     // @dev - Return superblock blocks' Merkle root
1544     function getSuperblockMerkleRoot(bytes32 _superblockHash) public view returns (bytes32) {
1545         return superblocks[_superblockHash].blocksMerkleRoot;
1546     }
1547 
1548     // @dev - Return superblock timestamp
1549     function getSuperblockTimestamp(bytes32 _superblockHash) public view returns (uint) {
1550         return superblocks[_superblockHash].timestamp;
1551     }
1552 
1553     // @dev - Return superblock prevTimestamp
1554     function getSuperblockPrevTimestamp(bytes32 _superblockHash) public view returns (uint) {
1555         return superblocks[_superblockHash].prevTimestamp;
1556     }
1557 
1558     // @dev - Return superblock last block hash
1559     function getSuperblockLastHash(bytes32 _superblockHash) public view returns (bytes32) {
1560         return superblocks[_superblockHash].lastHash;
1561     }
1562 
1563     // @dev - Return superblock parent
1564     function getSuperblockParentId(bytes32 _superblockHash) public view returns (bytes32) {
1565         return superblocks[_superblockHash].parentId;
1566     }
1567 
1568     // @dev - Return superblock accumulated work
1569     function getSuperblockAccumulatedWork(bytes32 _superblockHash) public view returns (uint) {
1570         return superblocks[_superblockHash].accumulatedWork;
1571     }
1572 
1573     // @dev - Return superblock status
1574     function getSuperblockStatus(bytes32 _superblockHash) public view returns (Status) {
1575         return superblocks[_superblockHash].status;
1576     }
1577 
1578     // @dev - Return indexNextSuperblock
1579     function getIndexNextSuperblock() public view returns (uint32) {
1580         return indexNextSuperblock;
1581     }
1582 
1583     // @dev - Calculate Merkle root from Syscoin block hashes
1584     function makeMerkle(bytes32[] hashes) public pure returns (bytes32) {
1585         return SyscoinMessageLibrary.makeMerkle(hashes);
1586     }
1587 
1588     function isApproved(bytes32 _superblockHash) public view returns (bool) {
1589         return (getSuperblockStatus(_superblockHash) == Status.Approved);
1590     }
1591 
1592     function getChainHeight() public view returns (uint) {
1593         return superblocks[bestSuperblock].height;
1594     }
1595 
1596     // @dev - write `_fourBytes` into `_word` starting from `_position`
1597     // This is useful for writing 32bit ints inside one 32 byte word
1598     //
1599     // @param _word - information to be partially overwritten
1600     // @param _position - position to start writing from
1601     // @param _eightBytes - information to be written
1602     function writeUint32(bytes32 _word, uint _position, uint32 _fourBytes) private pure returns (bytes32) {
1603         bytes32 result;
1604         assembly {
1605             let pointer := mload(0x40)
1606             mstore(pointer, _word)
1607             mstore8(add(pointer, _position), byte(28, _fourBytes))
1608             mstore8(add(pointer, add(_position,1)), byte(29, _fourBytes))
1609             mstore8(add(pointer, add(_position,2)), byte(30, _fourBytes))
1610             mstore8(add(pointer, add(_position,3)), byte(31, _fourBytes))
1611             result := mload(pointer)
1612         }
1613         return result;
1614     }
1615 
1616     uint constant ANCESTOR_STEP = 5;
1617     uint constant NUM_ANCESTOR_DEPTHS = 8;
1618 
1619     // @dev - Update ancestor to the new height
1620     function updateAncestors(bytes32 ancestors, uint32 index, uint height) internal pure returns (bytes32) {
1621         uint step = ANCESTOR_STEP;
1622         ancestors = writeUint32(ancestors, 0, index);
1623         uint i = 1;
1624         while (i<NUM_ANCESTOR_DEPTHS && (height % step == 1)) {
1625             ancestors = writeUint32(ancestors, 4*i, index);
1626             step *= ANCESTOR_STEP;
1627             ++i;
1628         }
1629         return ancestors;
1630     }
1631 
1632     // @dev - Returns a list of superblock hashes (9 hashes maximum) that helps an agent find out what
1633     // superblocks are missing.
1634     // The first position contains bestSuperblock, then
1635     // bestSuperblock - 1,
1636     // (bestSuperblock-1) - ((bestSuperblock-1) % 5), then
1637     // (bestSuperblock-1) - ((bestSuperblock-1) % 25), ... until
1638     // (bestSuperblock-1) - ((bestSuperblock-1) % 78125)
1639     //
1640     // @return - list of up to 9 ancestor supeerblock id
1641     function getSuperblockLocator() public view returns (bytes32[9]) {
1642         bytes32[9] memory locator;
1643         locator[0] = bestSuperblock;
1644         bytes32 ancestors = getSuperblockAncestors(bestSuperblock);
1645         uint i = NUM_ANCESTOR_DEPTHS;
1646         while (i > 0) {
1647             locator[i] = indexSuperblock[uint32(ancestors & 0xFFFFFFFF)];
1648             ancestors >>= 32;
1649             --i;
1650         }
1651         return locator;
1652     }
1653 
1654     // @dev - Return ancestor at given index
1655     function getSuperblockAncestor(bytes32 superblockHash, uint index) internal view returns (bytes32) {
1656         bytes32 ancestors = superblocks[superblockHash].ancestors;
1657         uint32 ancestorsIndex =
1658             uint32(ancestors[4*index + 0]) * 0x1000000 +
1659             uint32(ancestors[4*index + 1]) * 0x10000 +
1660             uint32(ancestors[4*index + 2]) * 0x100 +
1661             uint32(ancestors[4*index + 3]) * 0x1;
1662         return indexSuperblock[ancestorsIndex];
1663     }
1664 
1665     // dev - returns depth associated with an ancestor index; applies to any superblock
1666     //
1667     // @param _index - index of ancestor to be looked up; an integer between 0 and 7
1668     // @return - depth corresponding to said index, i.e. 5**index
1669     function getAncDepth(uint _index) private pure returns (uint) {
1670         return ANCESTOR_STEP**(uint(_index));
1671     }
1672 
1673     // @dev - return superblock hash at a given height in superblock main chain
1674     //
1675     // @param _height - superblock height
1676     // @return - hash corresponding to block of height _blockHeight
1677     function getSuperblockAt(uint _height) public view returns (bytes32) {
1678         bytes32 superblockHash = bestSuperblock;
1679         uint index = NUM_ANCESTOR_DEPTHS - 1;
1680 
1681         while (getSuperblockHeight(superblockHash) > _height) {
1682             while (getSuperblockHeight(superblockHash) - _height < getAncDepth(index) && index > 0) {
1683                 index -= 1;
1684             }
1685             superblockHash = getSuperblockAncestor(superblockHash, index);
1686         }
1687 
1688         return superblockHash;
1689     }
1690 
1691     // @dev - Checks if a superblock is in superblock main chain
1692     //
1693     // @param _blockHash - hash of the block being searched for in the main chain
1694     // @return - true if the block identified by _blockHash is in the main chain,
1695     // false otherwise
1696     function inMainChain(bytes32 _superblockHash) internal view returns (bool) {
1697         uint height = getSuperblockHeight(_superblockHash);
1698         if (height == 0) return false;
1699         return (getSuperblockAt(height) == _superblockHash);
1700     }
1701 }