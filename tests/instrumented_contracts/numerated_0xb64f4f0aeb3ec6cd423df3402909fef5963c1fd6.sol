1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 contract SyscoinDepositsManager {
54 
55     using SafeMath for uint;
56 
57     mapping(address => uint) public deposits;
58 
59     event DepositMade(address who, uint amount);
60     event DepositWithdrawn(address who, uint amount);
61 
62     // @dev – fallback to calling makeDeposit when ether is sent directly to contract.
63     function() public payable {
64         makeDeposit();
65     }
66 
67     // @dev – returns an account's deposit
68     // @param who – the account's address.
69     // @return – the account's deposit.
70     function getDeposit(address who) constant public returns (uint) {
71         return deposits[who];
72     }
73 
74     // @dev – allows a user to deposit eth.
75     // @return – sender's updated deposit amount.
76     function makeDeposit() public payable returns (uint) {
77         increaseDeposit(msg.sender, msg.value);
78         return deposits[msg.sender];
79     }
80 
81     // @dev – increases an account's deposit.
82     // @return – the given user's updated deposit amount.
83     function increaseDeposit(address who, uint amount) internal {
84         deposits[who] = deposits[who].add(amount);
85         require(deposits[who] <= address(this).balance);
86 
87         emit DepositMade(who, amount);
88     }
89 
90     // @dev – allows a user to withdraw eth from their deposit.
91     // @param amount – how much eth to withdraw
92     // @return – sender's updated deposit amount.
93     function withdrawDeposit(uint amount) public returns (uint) {
94         require(deposits[msg.sender] >= amount);
95 
96         deposits[msg.sender] = deposits[msg.sender].sub(amount);
97         msg.sender.transfer(amount);
98 
99         emit DepositWithdrawn(msg.sender, amount);
100         return deposits[msg.sender];
101     }
102 }
103 
104 // Interface contract to be implemented by SyscoinToken
105 contract SyscoinTransactionProcessor {
106     function processTransaction(uint txHash, uint value, address destinationAddress, uint32 _assetGUID, address superblockSubmitterAddress) public returns (uint);
107     function burn(uint _value, uint32 _assetGUID, bytes syscoinWitnessProgram) payable public returns (bool success);
108 }
109 
110 // Bitcoin transaction parsing library - modified for SYSCOIN
111 
112 // Copyright 2016 rain <https://keybase.io/rain>
113 //
114 // Licensed under the Apache License, Version 2.0 (the "License");
115 // you may not use this file except in compliance with the License.
116 // You may obtain a copy of the License at
117 //
118 //      http://www.apache.org/licenses/LICENSE-2.0
119 //
120 // Unless required by applicable law or agreed to in writing, software
121 // distributed under the License is distributed on an "AS IS" BASIS,
122 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
123 // See the License for the specific language governing permissions and
124 // limitations under the License.
125 
126 // https://en.bitcoin.it/wiki/Protocol_documentation#tx
127 //
128 // Raw Bitcoin transaction structure:
129 //
130 // field     | size | type     | description
131 // version   | 4    | int32    | transaction version number
132 // n_tx_in   | 1-9  | var_int  | number of transaction inputs
133 // tx_in     | 41+  | tx_in[]  | list of transaction inputs
134 // n_tx_out  | 1-9  | var_int  | number of transaction outputs
135 // tx_out    | 9+   | tx_out[] | list of transaction outputs
136 // lock_time | 4    | uint32   | block number / timestamp at which tx locked
137 //
138 // Transaction input (tx_in) structure:
139 //
140 // field      | size | type     | description
141 // previous   | 36   | outpoint | Previous output transaction reference
142 // script_len | 1-9  | var_int  | Length of the signature script
143 // sig_script | ?    | uchar[]  | Script for confirming transaction authorization
144 // sequence   | 4    | uint32   | Sender transaction version
145 //
146 // OutPoint structure:
147 //
148 // field      | size | type     | description
149 // hash       | 32   | char[32] | The hash of the referenced transaction
150 // index      | 4    | uint32   | The index of this output in the referenced transaction
151 //
152 // Transaction output (tx_out) structure:
153 //
154 // field         | size | type     | description
155 // value         | 8    | int64    | Transaction value (Satoshis)
156 // pk_script_len | 1-9  | var_int  | Length of the public key script
157 // pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.
158 //
159 // Variable integers (var_int) can be encoded differently depending
160 // on the represented value, to save space. Variable integers always
161 // precede an array of a variable length data type (e.g. tx_in).
162 //
163 // Variable integer encodings as a function of represented value:
164 //
165 // value           | bytes  | format
166 // <0xFD (253)     | 1      | uint8
167 // <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16
168 // <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32
169 // -               | 9      | 0xFF followed by length as uint64
170 //
171 // Public key scripts `pk_script` are set on the output and can
172 // take a number of forms. The regular transaction script is
173 // called 'pay-to-pubkey-hash' (P2PKH):
174 //
175 // OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
176 //
177 // OP_x are Bitcoin script opcodes. The bytes representation (including
178 // the 0x14 20-byte stack push) is:
179 //
180 // 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC
181 //
182 // The <pubKeyHash> is the ripemd160 hash of the sha256 hash of
183 // the public key, preceded by a network version byte. (21 bytes total)
184 //
185 // Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)
186 //
187 // The Bitcoin address is derived from the pubKeyHash. The binary form is the
188 // pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes
189 // of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)
190 // This is converted to base58 to form the publicly used Bitcoin address.
191 // Mainnet P2PKH transaction scripts are to addresses beginning with '1'.
192 //
193 // P2SH ('pay to script hash') scripts only supply a script hash. The spender
194 // must then provide the script that would allow them to redeem this output.
195 // This allows for arbitrarily complex scripts to be funded using only a
196 // hash of the script, and moves the onus on providing the script from
197 // the spender to the redeemer.
198 //
199 // The P2SH script format is simple:
200 //
201 // OP_HASH160 <scriptHash> OP_EQUAL
202 //
203 // 0xA9 0x14 <scriptHash> 0x87
204 //
205 // The <scriptHash> is the ripemd160 hash of the sha256 hash of the
206 // redeem script. The P2SH address is derived from the scriptHash.
207 // Addresses are the scriptHash with a version prefix of 5, encoded as
208 // Base58check. These addresses begin with a '3'.
209 
210 
211 
212 // parse a raw Syscoin transaction byte array
213 library SyscoinMessageLibrary {
214 
215     uint constant p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f;  // secp256k1
216     uint constant q = (p + 1) / 4;
217 
218     // Error codes
219     uint constant ERR_INVALID_HEADER = 10050;
220     uint constant ERR_COINBASE_INDEX = 10060; // coinbase tx index within Litecoin merkle isn't 0
221     uint constant ERR_NOT_MERGE_MINED = 10070; // trying to check AuxPoW on a block that wasn't merge mined
222     uint constant ERR_FOUND_TWICE = 10080; // 0xfabe6d6d found twice
223     uint constant ERR_NO_MERGE_HEADER = 10090; // 0xfabe6d6d not found
224     uint constant ERR_NOT_IN_FIRST_20 = 10100; // chain Merkle root isn't in the first 20 bytes of coinbase tx
225     uint constant ERR_CHAIN_MERKLE = 10110;
226     uint constant ERR_PARENT_MERKLE = 10120;
227     uint constant ERR_PROOF_OF_WORK = 10130;
228     uint constant ERR_INVALID_HEADER_HASH = 10140;
229     uint constant ERR_PROOF_OF_WORK_AUXPOW = 10150;
230     uint constant ERR_PARSE_TX_OUTPUT_LENGTH = 10160;
231     uint constant ERR_PARSE_TX_SYS = 10170;
232     enum Network { MAINNET, TESTNET, REGTEST }
233     uint32 constant SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN = 0x7407;
234     uint32 constant SYSCOIN_TX_VERSION_BURN = 0x7401;
235     // AuxPoW block fields
236     struct AuxPoW {
237         uint blockHash;
238 
239         uint txHash;
240 
241         uint coinbaseMerkleRoot; // Merkle root of auxiliary block hash tree; stored in coinbase tx field
242         uint[] chainMerkleProof; // proves that a given Syscoin block hash belongs to a tree with the above root
243         uint syscoinHashIndex; // index of Syscoin block hash within block hash tree
244         uint coinbaseMerkleRootCode; // encodes whether or not the root was found properly
245 
246         uint parentMerkleRoot; // Merkle root of transaction tree from parent Litecoin block header
247         uint[] parentMerkleProof; // proves that coinbase tx belongs to a tree with the above root
248         uint coinbaseTxIndex; // index of coinbase tx within Litecoin tx tree
249 
250         uint parentNonce;
251     }
252 
253     // Syscoin block header stored as a struct, mostly for readability purposes.
254     // BlockHeader structs can be obtained by parsing a block header's first 80 bytes
255     // with parseHeaderBytes.
256     struct BlockHeader {
257         uint32 bits;
258         uint blockHash;
259     }
260     // Convert a variable integer into something useful and return it and
261     // the index to after it.
262     function parseVarInt(bytes memory txBytes, uint pos) private pure returns (uint, uint) {
263         // the first byte tells us how big the integer is
264         uint8 ibit = uint8(txBytes[pos]);
265         pos += 1;  // skip ibit
266 
267         if (ibit < 0xfd) {
268             return (ibit, pos);
269         } else if (ibit == 0xfd) {
270             return (getBytesLE(txBytes, pos, 16), pos + 2);
271         } else if (ibit == 0xfe) {
272             return (getBytesLE(txBytes, pos, 32), pos + 4);
273         } else if (ibit == 0xff) {
274             return (getBytesLE(txBytes, pos, 64), pos + 8);
275         }
276     }
277     // convert little endian bytes to uint
278     function getBytesLE(bytes memory data, uint pos, uint bits) internal pure returns (uint) {
279         if (bits == 8) {
280             return uint8(data[pos]);
281         } else if (bits == 16) {
282             return uint16(data[pos])
283                  + uint16(data[pos + 1]) * 2 ** 8;
284         } else if (bits == 32) {
285             return uint32(data[pos])
286                  + uint32(data[pos + 1]) * 2 ** 8
287                  + uint32(data[pos + 2]) * 2 ** 16
288                  + uint32(data[pos + 3]) * 2 ** 24;
289         } else if (bits == 64) {
290             return uint64(data[pos])
291                  + uint64(data[pos + 1]) * 2 ** 8
292                  + uint64(data[pos + 2]) * 2 ** 16
293                  + uint64(data[pos + 3]) * 2 ** 24
294                  + uint64(data[pos + 4]) * 2 ** 32
295                  + uint64(data[pos + 5]) * 2 ** 40
296                  + uint64(data[pos + 6]) * 2 ** 48
297                  + uint64(data[pos + 7]) * 2 ** 56;
298         }
299     }
300     
301 
302     // @dev - Parses a syscoin tx
303     //
304     // @param txBytes - tx byte array
305     // Outputs
306     // @return output_value - amount sent to the lock address in satoshis
307     // @return destinationAddress - ethereum destination address
308 
309 
310     function parseTransaction(bytes memory txBytes) internal pure
311              returns (uint, uint, address, uint32)
312     {
313         
314         uint output_value;
315         uint32 assetGUID;
316         address destinationAddress;
317         uint32 version;
318         uint pos = 0;
319         version = bytesToUint32Flipped(txBytes, pos);
320         if(version != SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN && version != SYSCOIN_TX_VERSION_BURN){
321             return (ERR_PARSE_TX_SYS, output_value, destinationAddress, assetGUID);
322         }
323         pos = skipInputs(txBytes, 4);
324             
325         (output_value, destinationAddress, assetGUID) = scanBurns(txBytes, version, pos);
326         return (0, output_value, destinationAddress, assetGUID);
327     }
328 
329 
330   
331     // skips witnesses and saves first script position/script length to extract pubkey of first witness scriptSig
332     function skipWitnesses(bytes memory txBytes, uint pos, uint n_inputs) private pure
333              returns (uint)
334     {
335         uint n_stack;
336         (n_stack, pos) = parseVarInt(txBytes, pos);
337         
338         uint script_len;
339         for (uint i = 0; i < n_inputs; i++) {
340             for (uint j = 0; j < n_stack; j++) {
341                 (script_len, pos) = parseVarInt(txBytes, pos);
342                 pos += script_len;
343             }
344         }
345 
346         return n_stack;
347     }    
348 
349     function skipInputs(bytes memory txBytes, uint pos) private pure
350              returns (uint)
351     {
352         uint n_inputs;
353         uint script_len;
354         (n_inputs, pos) = parseVarInt(txBytes, pos);
355         // if dummy 0x00 is present this is a witness transaction
356         if(n_inputs == 0x00){
357             (n_inputs, pos) = parseVarInt(txBytes, pos); // flag
358             assert(n_inputs != 0x00);
359             // after dummy/flag the real var int comes for txins
360             (n_inputs, pos) = parseVarInt(txBytes, pos);
361         }
362         require(n_inputs < 100);
363 
364         for (uint i = 0; i < n_inputs; i++) {
365             pos += 36;  // skip outpoint
366             (script_len, pos) = parseVarInt(txBytes, pos);
367             pos += script_len + 4;  // skip sig_script, seq
368         }
369 
370         return pos;
371     }
372              
373     // scan the burn outputs and return the value and script data of first burned output.
374     function scanBurns(bytes memory txBytes, uint32 version, uint pos) private pure
375              returns (uint, address, uint32)
376     {
377         uint script_len;
378         uint output_value;
379         uint32 assetGUID = 0;
380         address destinationAddress;
381         uint n_outputs;
382         (n_outputs, pos) = parseVarInt(txBytes, pos);
383         require(n_outputs < 10);
384         for (uint i = 0; i < n_outputs; i++) {
385             // output
386             if(version == SYSCOIN_TX_VERSION_BURN){
387                 output_value = getBytesLE(txBytes, pos, 64);
388             }
389             pos += 8;
390             // varint
391             (script_len, pos) = parseVarInt(txBytes, pos);
392             if(!isOpReturn(txBytes, pos)){
393                 // output script
394                 pos += script_len;
395                 output_value = 0;
396                 continue;
397             }
398             // skip opreturn marker
399             pos += 1;
400             if(version == SYSCOIN_TX_VERSION_ASSET_ALLOCATION_BURN){
401                 (output_value, destinationAddress, assetGUID) = scanAssetDetails(txBytes, pos);
402             }
403             else if(version == SYSCOIN_TX_VERSION_BURN){                
404                 destinationAddress = scanSyscoinDetails(txBytes, pos);   
405             }
406             // only one opreturn data allowed per transaction
407             break;
408         }
409 
410         return (output_value, destinationAddress, assetGUID);
411     }
412 
413     function skipOutputs(bytes memory txBytes, uint pos) private pure
414              returns (uint)
415     {
416         uint n_outputs;
417         uint script_len;
418 
419         (n_outputs, pos) = parseVarInt(txBytes, pos);
420 
421         require(n_outputs < 10);
422 
423         for (uint i = 0; i < n_outputs; i++) {
424             pos += 8;
425             (script_len, pos) = parseVarInt(txBytes, pos);
426             pos += script_len;
427         }
428 
429         return pos;
430     }
431     // get final position of inputs, outputs and lock time
432     // this is a helper function to slice a byte array and hash the inputs, outputs and lock time
433     function getSlicePos(bytes memory txBytes, uint pos) private pure
434              returns (uint slicePos)
435     {
436         slicePos = skipInputs(txBytes, pos + 4);
437         slicePos = skipOutputs(txBytes, slicePos);
438         slicePos += 4; // skip lock time
439     }
440     // scan a Merkle branch.
441     // return array of values and the end position of the sibling hashes.
442     // takes a 'stop' argument which sets the maximum number of
443     // siblings to scan through. stop=0 => scan all.
444     function scanMerkleBranch(bytes memory txBytes, uint pos, uint stop) private pure
445              returns (uint[], uint)
446     {
447         uint n_siblings;
448         uint halt;
449 
450         (n_siblings, pos) = parseVarInt(txBytes, pos);
451 
452         if (stop == 0 || stop > n_siblings) {
453             halt = n_siblings;
454         } else {
455             halt = stop;
456         }
457 
458         uint[] memory sibling_values = new uint[](halt);
459 
460         for (uint i = 0; i < halt; i++) {
461             sibling_values[i] = flip32Bytes(sliceBytes32Int(txBytes, pos));
462             pos += 32;
463         }
464 
465         return (sibling_values, pos);
466     }   
467     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
468     function sliceBytes20(bytes memory data, uint start) private pure returns (bytes20) {
469         uint160 slice = 0;
470         // FIXME: With solc v0.4.24 and optimizations enabled
471         // using uint160 for index i will generate an error
472         // "Error: VM Exception while processing transaction: Error: redPow(normalNum)"
473         for (uint i = 0; i < 20; i++) {
474             slice += uint160(data[i + start]) << (8 * (19 - i));
475         }
476         return bytes20(slice);
477     }
478     // Slice 32 contiguous bytes from bytes `data`, starting at `start`
479     function sliceBytes32Int(bytes memory data, uint start) private pure returns (uint slice) {
480         for (uint i = 0; i < 32; i++) {
481             if (i + start < data.length) {
482                 slice += uint(data[i + start]) << (8 * (31 - i));
483             }
484         }
485     }
486 
487     // @dev returns a portion of a given byte array specified by its starting and ending points
488     // Should be private, made internal for testing
489     // Breaks underscore naming convention for parameters because it raises a compiler error
490     // if `offset` is changed to `_offset`.
491     //
492     // @param _rawBytes - array to be sliced
493     // @param offset - first byte of sliced array
494     // @param _endIndex - last byte of sliced array
495     function sliceArray(bytes memory _rawBytes, uint offset, uint _endIndex) internal view returns (bytes) {
496         uint len = _endIndex - offset;
497         bytes memory result = new bytes(len);
498         assembly {
499             // Call precompiled contract to copy data
500             if iszero(staticcall(gas, 0x04, add(add(_rawBytes, 0x20), offset), len, add(result, 0x20), len)) {
501                 revert(0, 0)
502             }
503         }
504         return result;
505     }
506     
507     
508     // Returns true if the tx output is an OP_RETURN output
509     function isOpReturn(bytes memory txBytes, uint pos) private pure
510              returns (bool) {
511         // scriptPub format is
512         // 0x6a OP_RETURN
513         return 
514             txBytes[pos] == byte(0x6a);
515     }
516     // Returns syscoin data parsed from the op_return data output from syscoin burn transaction
517     function scanSyscoinDetails(bytes memory txBytes, uint pos) private pure
518              returns (address) {      
519         uint8 op;
520         (op, pos) = getOpcode(txBytes, pos);
521         // ethereum addresses are 20 bytes (without the 0x)
522         require(op == 0x14);
523         return readEthereumAddress(txBytes, pos);
524     }    
525     // Returns asset data parsed from the op_return data output from syscoin asset burn transaction
526     function scanAssetDetails(bytes memory txBytes, uint pos) private pure
527              returns (uint, address, uint32) {
528                  
529         uint32 assetGUID;
530         address destinationAddress;
531         uint output_value;
532         uint8 op;
533         // vchAsset
534         (op, pos) = getOpcode(txBytes, pos);
535         // guid length should be 4 bytes
536         require(op == 0x04);
537         assetGUID = bytesToUint32(txBytes, pos);
538         pos += op;
539         // amount
540         (op, pos) = getOpcode(txBytes, pos);
541         require(op == 0x08);
542         output_value = bytesToUint64(txBytes, pos);
543         pos += op;
544          // destination address
545         (op, pos) = getOpcode(txBytes, pos);
546         // ethereum contracts are 20 bytes (without the 0x)
547         require(op == 0x14);
548         destinationAddress = readEthereumAddress(txBytes, pos);       
549         return (output_value, destinationAddress, assetGUID);
550     }         
551     // Read the ethereum address embedded in the tx output
552     function readEthereumAddress(bytes memory txBytes, uint pos) private pure
553              returns (address) {
554         uint256 data;
555         assembly {
556             data := mload(add(add(txBytes, 20), pos))
557         }
558         return address(uint160(data));
559     }
560 
561     // Read next opcode from script
562     function getOpcode(bytes memory txBytes, uint pos) private pure
563              returns (uint8, uint)
564     {
565         require(pos < txBytes.length);
566         return (uint8(txBytes[pos]), pos + 1);
567     }
568 
569     // @dev - convert an unsigned integer from little-endian to big-endian representation
570     //
571     // @param _input - little-endian value
572     // @return - input value in big-endian format
573     function flip32Bytes(uint _input) internal pure returns (uint result) {
574         assembly {
575             let pos := mload(0x40)
576             for { let i := 0 } lt(i, 32) { i := add(i, 1) } {
577                 mstore8(add(pos, i), byte(sub(31, i), _input))
578             }
579             result := mload(pos)
580         }
581     }
582     // helpers for flip32Bytes
583     struct UintWrapper {
584         uint value;
585     }
586 
587     function ptr(UintWrapper memory uw) private pure returns (uint addr) {
588         assembly {
589             addr := uw
590         }
591     }
592 
593     function parseAuxPoW(bytes memory rawBytes, uint pos) internal view
594              returns (AuxPoW memory auxpow)
595     {
596         // we need to traverse the bytes with a pointer because some fields are of variable length
597         pos += 80; // skip non-AuxPoW header
598         uint slicePos;
599         (slicePos) = getSlicePos(rawBytes, pos);
600         auxpow.txHash = dblShaFlipMem(rawBytes, pos, slicePos - pos);
601         pos = slicePos;
602         // parent block hash, skip and manually hash below
603         pos += 32;
604         (auxpow.parentMerkleProof, pos) = scanMerkleBranch(rawBytes, pos, 0);
605         auxpow.coinbaseTxIndex = getBytesLE(rawBytes, pos, 32);
606         pos += 4;
607         (auxpow.chainMerkleProof, pos) = scanMerkleBranch(rawBytes, pos, 0);
608         auxpow.syscoinHashIndex = getBytesLE(rawBytes, pos, 32);
609         pos += 4;
610         // calculate block hash instead of reading it above, as some are LE and some are BE, we cannot know endianness and have to calculate from parent block header
611         auxpow.blockHash = dblShaFlipMem(rawBytes, pos, 80);
612         pos += 36; // skip parent version and prev block
613         auxpow.parentMerkleRoot = sliceBytes32Int(rawBytes, pos);
614         pos += 40; // skip root that was just read, parent block timestamp and bits
615         auxpow.parentNonce = getBytesLE(rawBytes, pos, 32);
616         uint coinbaseMerkleRootPosition;
617         (auxpow.coinbaseMerkleRoot, coinbaseMerkleRootPosition, auxpow.coinbaseMerkleRootCode) = findCoinbaseMerkleRoot(rawBytes);
618     }
619 
620     // @dev - looks for {0xfa, 0xbe, 'm', 'm'} byte sequence
621     // returns the following 32 bytes if it appears once and only once,
622     // 0 otherwise
623     // also returns the position where the bytes first appear
624     function findCoinbaseMerkleRoot(bytes memory rawBytes) private pure
625              returns (uint, uint, uint)
626     {
627         uint position;
628         bool found = false;
629 
630         for (uint i = 0; i < rawBytes.length; ++i) {
631             if (rawBytes[i] == 0xfa && rawBytes[i+1] == 0xbe && rawBytes[i+2] == 0x6d && rawBytes[i+3] == 0x6d) {
632                 if (found) { // found twice
633                     return (0, position - 4, ERR_FOUND_TWICE);
634                 } else {
635                     found = true;
636                     position = i + 4;
637                 }
638             }
639         }
640 
641         if (!found) { // no merge mining header
642             return (0, position - 4, ERR_NO_MERGE_HEADER);
643         } else {
644             return (sliceBytes32Int(rawBytes, position), position - 4, 1);
645         }
646     }
647 
648     // @dev - Evaluate the merkle root
649     //
650     // Given an array of hashes it calculates the
651     // root of the merkle tree.
652     //
653     // @return root of merkle tree
654     function makeMerkle(bytes32[] hashes2) external pure returns (bytes32) {
655         bytes32[] memory hashes = hashes2;
656         uint length = hashes.length;
657         if (length == 1) return hashes[0];
658         require(length > 0);
659         uint i;
660         uint j;
661         uint k;
662         k = 0;
663         while (length > 1) {
664             k = 0;
665             for (i = 0; i < length; i += 2) {
666                 j = i+1<length ? i+1 : length-1;
667                 hashes[k] = bytes32(concatHash(uint(hashes[i]), uint(hashes[j])));
668                 k += 1;
669             }
670             length = k;
671         }
672         return hashes[0];
673     }
674 
675     // @dev - For a valid proof, returns the root of the Merkle tree.
676     //
677     // @param _txHash - transaction hash
678     // @param _txIndex - transaction's index within the block it's assumed to be in
679     // @param _siblings - transaction's Merkle siblings
680     // @return - Merkle tree root of the block the transaction belongs to if the proof is valid,
681     // garbage if it's invalid
682     function computeMerkle(uint _txHash, uint _txIndex, uint[] memory _siblings) internal pure returns (uint) {
683         uint resultHash = _txHash;
684         uint i = 0;
685         while (i < _siblings.length) {
686             uint proofHex = _siblings[i];
687 
688             uint sideOfSiblings = _txIndex % 2;  // 0 means _siblings is on the right; 1 means left
689 
690             uint left;
691             uint right;
692             if (sideOfSiblings == 1) {
693                 left = proofHex;
694                 right = resultHash;
695             } else if (sideOfSiblings == 0) {
696                 left = resultHash;
697                 right = proofHex;
698             }
699 
700             resultHash = concatHash(left, right);
701 
702             _txIndex /= 2;
703             i += 1;
704         }
705 
706         return resultHash;
707     }
708 
709     // @dev - calculates the Merkle root of a tree containing Litecoin transactions
710     // in order to prove that `ap`'s coinbase tx is in that Litecoin block.
711     //
712     // @param _ap - AuxPoW information
713     // @return - Merkle root of Litecoin block that the Syscoin block
714     // with this info was mined in if AuxPoW Merkle proof is correct,
715     // garbage otherwise
716     function computeParentMerkle(AuxPoW memory _ap) internal pure returns (uint) {
717         return flip32Bytes(computeMerkle(_ap.txHash,
718                                          _ap.coinbaseTxIndex,
719                                          _ap.parentMerkleProof));
720     }
721 
722     // @dev - calculates the Merkle root of a tree containing auxiliary block hashes
723     // in order to prove that the Syscoin block identified by _blockHash
724     // was merge-mined in a Litecoin block.
725     //
726     // @param _blockHash - SHA-256 hash of a certain Syscoin block
727     // @param _ap - AuxPoW information corresponding to said block
728     // @return - Merkle root of auxiliary chain tree
729     // if AuxPoW Merkle proof is correct, garbage otherwise
730     function computeChainMerkle(uint _blockHash, AuxPoW memory _ap) internal pure returns (uint) {
731         return computeMerkle(_blockHash,
732                              _ap.syscoinHashIndex,
733                              _ap.chainMerkleProof);
734     }
735 
736     // @dev - Helper function for Merkle root calculation.
737     // Given two sibling nodes in a Merkle tree, calculate their parent.
738     // Concatenates hashes `_tx1` and `_tx2`, then hashes the result.
739     //
740     // @param _tx1 - Merkle node (either root or internal node)
741     // @param _tx2 - Merkle node (either root or internal node), has to be `_tx1`'s sibling
742     // @return - `_tx1` and `_tx2`'s parent, i.e. the result of concatenating them,
743     // hashing that twice and flipping the bytes.
744     function concatHash(uint _tx1, uint _tx2) internal pure returns (uint) {
745         return flip32Bytes(uint(sha256(abi.encodePacked(sha256(abi.encodePacked(flip32Bytes(_tx1), flip32Bytes(_tx2)))))));
746     }
747 
748     // @dev - checks if a merge-mined block's Merkle proofs are correct,
749     // i.e. Syscoin block hash is in coinbase Merkle tree
750     // and coinbase transaction is in parent Merkle tree.
751     //
752     // @param _blockHash - SHA-256 hash of the block whose Merkle proofs are being checked
753     // @param _ap - AuxPoW struct corresponding to the block
754     // @return 1 if block was merge-mined and coinbase index, chain Merkle root and Merkle proofs are correct,
755     // respective error code otherwise
756     function checkAuxPoW(uint _blockHash, AuxPoW memory _ap) internal pure returns (uint) {
757         if (_ap.coinbaseTxIndex != 0) {
758             return ERR_COINBASE_INDEX;
759         }
760 
761         if (_ap.coinbaseMerkleRootCode != 1) {
762             return _ap.coinbaseMerkleRootCode;
763         }
764 
765         if (computeChainMerkle(_blockHash, _ap) != _ap.coinbaseMerkleRoot) {
766             return ERR_CHAIN_MERKLE;
767         }
768 
769         if (computeParentMerkle(_ap) != _ap.parentMerkleRoot) {
770             return ERR_PARENT_MERKLE;
771         }
772 
773         return 1;
774     }
775 
776     function sha256mem(bytes memory _rawBytes, uint offset, uint len) internal view returns (bytes32 result) {
777         assembly {
778             // Call sha256 precompiled contract (located in address 0x02) to copy data.
779             // Assign to ptr the next available memory position (stored in memory position 0x40).
780             let ptr := mload(0x40)
781             if iszero(staticcall(gas, 0x02, add(add(_rawBytes, 0x20), offset), len, ptr, 0x20)) {
782                 revert(0, 0)
783             }
784             result := mload(ptr)
785         }
786     }
787 
788     // @dev - Bitcoin-way of hashing
789     // @param _dataBytes - raw data to be hashed
790     // @return - result of applying SHA-256 twice to raw data and then flipping the bytes
791     function dblShaFlip(bytes _dataBytes) internal pure returns (uint) {
792         return flip32Bytes(uint(sha256(abi.encodePacked(sha256(abi.encodePacked(_dataBytes))))));
793     }
794 
795     // @dev - Bitcoin-way of hashing
796     // @param _dataBytes - raw data to be hashed
797     // @return - result of applying SHA-256 twice to raw data and then flipping the bytes
798     function dblShaFlipMem(bytes memory _rawBytes, uint offset, uint len) internal view returns (uint) {
799         return flip32Bytes(uint(sha256(abi.encodePacked(sha256mem(_rawBytes, offset, len)))));
800     }
801 
802     // @dev – Read a bytes32 from an offset in the byte array
803     function readBytes32(bytes memory data, uint offset) internal pure returns (bytes32) {
804         bytes32 result;
805         assembly {
806             result := mload(add(add(data, 0x20), offset))
807         }
808         return result;
809     }
810 
811     // @dev – Read an uint32 from an offset in the byte array
812     function readUint32(bytes memory data, uint offset) internal pure returns (uint32) {
813         uint32 result;
814         assembly {
815             result := mload(add(add(data, 0x20), offset))
816             
817         }
818         return result;
819     }
820 
821     // @dev - Bitcoin-way of computing the target from the 'bits' field of a block header
822     // based on http://www.righto.com/2014/02/bitcoin-mining-hard-way-algorithms.html//ref3
823     //
824     // @param _bits - difficulty in bits format
825     // @return - difficulty in target format
826     function targetFromBits(uint32 _bits) internal pure returns (uint) {
827         uint exp = _bits / 0x1000000;  // 2**24
828         uint mant = _bits & 0xffffff;
829         return mant * 256**(exp - 3);
830     }
831 
832     uint constant SYSCOIN_DIFFICULTY_ONE = 0xFFFFF * 256**(0x1e - 3);
833 
834     // @dev - Calculate syscoin difficulty from target
835     // https://en.bitcoin.it/wiki/Difficulty
836     // Min difficulty for bitcoin is 0x1d00ffff
837     // Min difficulty for syscoin is 0x1e0fffff
838     function targetToDiff(uint target) internal pure returns (uint) {
839         return SYSCOIN_DIFFICULTY_ONE / target;
840     }
841     
842 
843     // 0x00 version
844     // 0x04 prev block hash
845     // 0x24 merkle root
846     // 0x44 timestamp
847     // 0x48 bits
848     // 0x4c nonce
849 
850     // @dev - extract previous block field from a raw Syscoin block header
851     //
852     // @param _blockHeader - Syscoin block header bytes
853     // @param pos - where to start reading hash from
854     // @return - hash of block's parent in big endian format
855     function getHashPrevBlock(bytes memory _blockHeader) internal pure returns (uint) {
856         uint hashPrevBlock;
857         assembly {
858             hashPrevBlock := mload(add(add(_blockHeader, 32), 0x04))
859         }
860         return flip32Bytes(hashPrevBlock);
861     }
862 
863     // @dev - extract Merkle root field from a raw Syscoin block header
864     //
865     // @param _blockHeader - Syscoin block header bytes
866     // @param pos - where to start reading root from
867     // @return - block's Merkle root in big endian format
868     function getHeaderMerkleRoot(bytes memory _blockHeader) public pure returns (uint) {
869         uint merkle;
870         assembly {
871             merkle := mload(add(add(_blockHeader, 32), 0x24))
872         }
873         return flip32Bytes(merkle);
874     }
875 
876     // @dev - extract timestamp field from a raw Syscoin block header
877     //
878     // @param _blockHeader - Syscoin block header bytes
879     // @param pos - where to start reading bits from
880     // @return - block's timestamp in big-endian format
881     function getTimestamp(bytes memory _blockHeader) internal pure returns (uint32 time) {
882         return bytesToUint32Flipped(_blockHeader, 0x44);
883     }
884 
885     // @dev - extract bits field from a raw Syscoin block header
886     //
887     // @param _blockHeader - Syscoin block header bytes
888     // @param pos - where to start reading bits from
889     // @return - block's difficulty in bits format, also big-endian
890     function getBits(bytes memory _blockHeader) internal pure returns (uint32 bits) {
891         return bytesToUint32Flipped(_blockHeader, 0x48);
892     }
893 
894 
895     // @dev - converts raw bytes representation of a Syscoin block header to struct representation
896     //
897     // @param _rawBytes - first 80 bytes of a block header
898     // @return - exact same header information in BlockHeader struct form
899     function parseHeaderBytes(bytes memory _rawBytes, uint pos) internal view returns (BlockHeader bh) {
900         bh.bits = getBits(_rawBytes);
901         bh.blockHash = dblShaFlipMem(_rawBytes, pos, 80);
902     }
903 
904     uint32 constant VERSION_AUXPOW = (1 << 8);
905 
906     // @dev - Converts a bytes of size 4 to uint32,
907     // e.g. for input [0x01, 0x02, 0x03 0x04] returns 0x01020304
908     function bytesToUint32Flipped(bytes memory input, uint pos) internal pure returns (uint32 result) {
909         result = uint32(input[pos]) + uint32(input[pos + 1])*(2**8) + uint32(input[pos + 2])*(2**16) + uint32(input[pos + 3])*(2**24);
910     }
911     function bytesToUint64(bytes memory input, uint pos) internal pure returns (uint64 result) {
912         result = uint64(input[pos+7]) + uint64(input[pos + 6])*(2**8) + uint64(input[pos + 5])*(2**16) + uint64(input[pos + 4])*(2**24) + uint64(input[pos + 3])*(2**32) + uint64(input[pos + 2])*(2**40) + uint64(input[pos + 1])*(2**48) + uint64(input[pos])*(2**56);
913     }
914      function bytesToUint32(bytes memory input, uint pos) internal pure returns (uint32 result) {
915         result = uint32(input[pos+3]) + uint32(input[pos + 2])*(2**8) + uint32(input[pos + 1])*(2**16) + uint32(input[pos])*(2**24);
916     }  
917     // @dev - checks version to determine if a block has merge mining information
918     function isMergeMined(bytes memory _rawBytes, uint pos) internal pure returns (bool) {
919         return bytesToUint32Flipped(_rawBytes, pos) & VERSION_AUXPOW != 0;
920     }
921 
922     // @dev - Verify block header
923     // @param _blockHeaderBytes - array of bytes with the block header
924     // @param _pos - starting position of the block header
925 	// @param _proposedBlockHash - proposed block hash computing from block header bytes
926     // @return - [ErrorCode, IsMergeMined]
927     function verifyBlockHeader(bytes _blockHeaderBytes, uint _pos, uint _proposedBlockHash) external view returns (uint, bool) {
928         BlockHeader memory blockHeader = parseHeaderBytes(_blockHeaderBytes, _pos);
929         uint blockSha256Hash = blockHeader.blockHash;
930 		// must confirm that the header hash passed in and computing hash matches
931 		if(blockSha256Hash != _proposedBlockHash){
932 			return (ERR_INVALID_HEADER_HASH, true);
933 		}
934         uint target = targetFromBits(blockHeader.bits);
935         if (_blockHeaderBytes.length > 80 && isMergeMined(_blockHeaderBytes, 0)) {
936             AuxPoW memory ap = parseAuxPoW(_blockHeaderBytes, _pos);
937             if (ap.blockHash > target) {
938 
939                 return (ERR_PROOF_OF_WORK_AUXPOW, true);
940             }
941             uint auxPoWCode = checkAuxPoW(blockSha256Hash, ap);
942             if (auxPoWCode != 1) {
943                 return (auxPoWCode, true);
944             }
945             return (0, true);
946         } else {
947             if (_proposedBlockHash > target) {
948                 return (ERR_PROOF_OF_WORK, false);
949             }
950             return (0, false);
951         }
952     }
953 
954     // For verifying Syscoin difficulty
955     int64 constant TARGET_TIMESPAN =  int64(21600); 
956     int64 constant TARGET_TIMESPAN_DIV_4 = TARGET_TIMESPAN / int64(4);
957     int64 constant TARGET_TIMESPAN_MUL_4 = TARGET_TIMESPAN * int64(4);
958     int64 constant TARGET_TIMESPAN_ADJUSTMENT =  int64(360);  // 6 hour
959     uint constant INITIAL_CHAIN_WORK =  0x100001; 
960     uint constant POW_LIMIT = 0x00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
961 
962     // @dev - Calculate difficulty from compact representation (bits) found in block
963     function diffFromBits(uint32 bits) external pure returns (uint) {
964         return targetToDiff(targetFromBits(bits))*INITIAL_CHAIN_WORK;
965     }
966     
967     function difficultyAdjustmentInterval() external pure returns (int64) {
968         return TARGET_TIMESPAN_ADJUSTMENT;
969     }
970     // @param _actualTimespan - time elapsed from previous block creation til current block creation;
971     // i.e., how much time it took to mine the current block
972     // @param _bits - previous block header difficulty (in bits)
973     // @return - expected difficulty for the next block
974     function calculateDifficulty(int64 _actualTimespan, uint32 _bits) external pure returns (uint32 result) {
975        int64 actualTimespan = _actualTimespan;
976         // Limit adjustment step
977         if (_actualTimespan < TARGET_TIMESPAN_DIV_4) {
978             actualTimespan = TARGET_TIMESPAN_DIV_4;
979         } else if (_actualTimespan > TARGET_TIMESPAN_MUL_4) {
980             actualTimespan = TARGET_TIMESPAN_MUL_4;
981         }
982 
983         // Retarget
984         uint bnNew = targetFromBits(_bits);
985         bnNew = bnNew * uint(actualTimespan);
986         bnNew = uint(bnNew) / uint(TARGET_TIMESPAN);
987 
988         if (bnNew > POW_LIMIT) {
989             bnNew = POW_LIMIT;
990         }
991 
992         return toCompactBits(bnNew);
993     }
994 
995     // @dev - shift information to the right by a specified number of bits
996     //
997     // @param _val - value to be shifted
998     // @param _shift - number of bits to shift
999     // @return - `_val` shifted `_shift` bits to the right, i.e. divided by 2**`_shift`
1000     function shiftRight(uint _val, uint _shift) private pure returns (uint) {
1001         return _val / uint(2)**_shift;
1002     }
1003 
1004     // @dev - shift information to the left by a specified number of bits
1005     //
1006     // @param _val - value to be shifted
1007     // @param _shift - number of bits to shift
1008     // @return - `_val` shifted `_shift` bits to the left, i.e. multiplied by 2**`_shift`
1009     function shiftLeft(uint _val, uint _shift) private pure returns (uint) {
1010         return _val * uint(2)**_shift;
1011     }
1012 
1013     // @dev - get the number of bits required to represent a given integer value without losing information
1014     //
1015     // @param _val - unsigned integer value
1016     // @return - given value's bit length
1017     function bitLen(uint _val) private pure returns (uint length) {
1018         uint int_type = _val;
1019         while (int_type > 0) {
1020             int_type = shiftRight(int_type, 1);
1021             length += 1;
1022         }
1023     }
1024 
1025     // @dev - Convert uint256 to compact encoding
1026     // based on https://github.com/petertodd/python-bitcoinlib/blob/2a5dda45b557515fb12a0a18e5dd48d2f5cd13c2/bitcoin/core/serialize.py
1027     // Analogous to arith_uint256::GetCompact from C++ implementation
1028     //
1029     // @param _val - difficulty in target format
1030     // @return - difficulty in bits format
1031     function toCompactBits(uint _val) private pure returns (uint32) {
1032         uint nbytes = uint (shiftRight((bitLen(_val) + 7), 3));
1033         uint32 compact = 0;
1034         if (nbytes <= 3) {
1035             compact = uint32 (shiftLeft((_val & 0xFFFFFF), 8 * (3 - nbytes)));
1036         } else {
1037             compact = uint32 (shiftRight(_val, 8 * (nbytes - 3)));
1038             compact = uint32 (compact & 0xFFFFFF);
1039         }
1040 
1041         // If the sign bit (0x00800000) is set, divide the mantissa by 256 and
1042         // increase the exponent to get an encoding without it set.
1043         if ((compact & 0x00800000) > 0) {
1044             compact = uint32(shiftRight(compact, 8));
1045             nbytes += 1;
1046         }
1047 
1048         return compact | uint32(shiftLeft(nbytes, 24));
1049     }
1050 }
1051 
1052 // @dev - SyscoinSuperblocks error codes
1053 contract SyscoinErrorCodes {
1054     // Error codes
1055     uint constant ERR_SUPERBLOCK_OK = 0;
1056     uint constant ERR_SUPERBLOCK_BAD_STATUS = 50020;
1057     uint constant ERR_SUPERBLOCK_BAD_SYSCOIN_STATUS = 50025;
1058     uint constant ERR_SUPERBLOCK_NO_TIMEOUT = 50030;
1059     uint constant ERR_SUPERBLOCK_BAD_TIMESTAMP = 50035;
1060     uint constant ERR_SUPERBLOCK_INVALID_MERKLE = 50040;
1061     uint constant ERR_SUPERBLOCK_BAD_PARENT = 50050;
1062     uint constant ERR_SUPERBLOCK_OWN_CHALLENGE = 50055;
1063 
1064     uint constant ERR_SUPERBLOCK_MIN_DEPOSIT = 50060;
1065 
1066     uint constant ERR_SUPERBLOCK_NOT_CLAIMMANAGER = 50070;
1067 
1068     uint constant ERR_SUPERBLOCK_BAD_CLAIM = 50080;
1069     uint constant ERR_SUPERBLOCK_VERIFICATION_PENDING = 50090;
1070     uint constant ERR_SUPERBLOCK_CLAIM_DECIDED = 50100;
1071     uint constant ERR_SUPERBLOCK_BAD_CHALLENGER = 50110;
1072 
1073     uint constant ERR_SUPERBLOCK_BAD_ACCUMULATED_WORK = 50120;
1074     uint constant ERR_SUPERBLOCK_BAD_BITS = 50130;
1075     uint constant ERR_SUPERBLOCK_MISSING_CONFIRMATIONS = 50140;
1076     uint constant ERR_SUPERBLOCK_BAD_LASTBLOCK = 50150;
1077     uint constant ERR_SUPERBLOCK_BAD_BLOCKHEIGHT = 50160;
1078 
1079     // error codes for verifyTx
1080     uint constant ERR_BAD_FEE = 20010;
1081     uint constant ERR_CONFIRMATIONS = 20020;
1082     uint constant ERR_CHAIN = 20030;
1083     uint constant ERR_SUPERBLOCK = 20040;
1084     uint constant ERR_MERKLE_ROOT = 20050;
1085     uint constant ERR_TX_64BYTE = 20060;
1086     // error codes for relayTx
1087     uint constant ERR_RELAY_VERIFY = 30010;
1088 
1089     // Minimum gas requirements
1090     uint constant public minReward = 1000000000000000000;
1091     uint constant public superblockCost = 440000;
1092     uint constant public challengeCost = 34000;
1093     uint constant public minProposalDeposit = challengeCost + minReward;
1094     uint constant public minChallengeDeposit = superblockCost + minReward;
1095     uint constant public respondMerkleRootHashesCost = 378000; // TODO: measure this with 60 hashes
1096     uint constant public respondBlockHeaderCost = 40000;
1097     uint constant public verifySuperblockCost = 220000;
1098 }
1099 
1100 // @dev - Manages superblocks
1101 //
1102 // Management of superblocks and status transitions
1103 contract SyscoinSuperblocks is SyscoinErrorCodes {
1104 
1105     // @dev - Superblock status
1106     enum Status { Unitialized, New, InBattle, SemiApproved, Approved, Invalid }
1107 
1108     struct SuperblockInfo {
1109         bytes32 blocksMerkleRoot;
1110         uint accumulatedWork;
1111         uint timestamp;
1112         uint prevTimestamp;
1113         bytes32 lastHash;
1114         bytes32 parentId;
1115         address submitter;
1116         bytes32 ancestors;
1117         uint32 lastBits;
1118         uint32 index;
1119         uint32 height;
1120         uint32 blockHeight;
1121         Status status;
1122     }
1123 
1124     // Mapping superblock id => superblock data
1125     mapping (bytes32 => SuperblockInfo) superblocks;
1126 
1127     // Index to superblock id
1128     mapping (uint32 => bytes32) private indexSuperblock;
1129 
1130     struct ProcessTransactionParams {
1131         uint value;
1132         address destinationAddress;
1133         uint32 assetGUID;
1134         address superblockSubmitterAddress;
1135         SyscoinTransactionProcessor untrustedTargetContract;
1136     }
1137 
1138     mapping (uint => ProcessTransactionParams) private txParams;
1139 
1140     uint32 indexNextSuperblock;
1141 
1142     bytes32 public bestSuperblock;
1143     uint public bestSuperblockAccumulatedWork;
1144 
1145     event NewSuperblock(bytes32 superblockHash, address who);
1146     event ApprovedSuperblock(bytes32 superblockHash, address who);
1147     event ChallengeSuperblock(bytes32 superblockHash, address who);
1148     event SemiApprovedSuperblock(bytes32 superblockHash, address who);
1149     event InvalidSuperblock(bytes32 superblockHash, address who);
1150 
1151     event ErrorSuperblock(bytes32 superblockHash, uint err);
1152 
1153     event VerifyTransaction(bytes32 txHash, uint returnCode);
1154     event RelayTransaction(bytes32 txHash, uint returnCode);
1155 
1156     // SyscoinClaimManager
1157     address public trustedClaimManager;
1158 
1159     modifier onlyClaimManager() {
1160         require(msg.sender == trustedClaimManager);
1161         _;
1162     }
1163 
1164     // @dev – the constructor
1165     constructor() public {}
1166 
1167     // @dev - sets ClaimManager instance associated with managing superblocks.
1168     // Once trustedClaimManager has been set, it cannot be changed.
1169     // @param _claimManager - address of the ClaimManager contract to be associated with
1170     function setClaimManager(address _claimManager) public {
1171         require(address(trustedClaimManager) == 0x0 && _claimManager != 0x0);
1172         trustedClaimManager = _claimManager;
1173     }
1174 
1175     // @dev - Initializes superblocks contract
1176     //
1177     // Initializes the superblock contract. It can only be called once.
1178     //
1179     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1180     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1181     // @param _timestamp Timestamp of the last block in the superblock
1182     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1183     // @param _lastHash Hash of the last block in the superblock
1184     // @param _lastBits Difficulty bits of the last block in the superblock
1185     // @param _parentId Id of the parent superblock
1186     // @param _blockHeight Block height of last block in superblock   
1187     // @return Error code and superblockHash
1188     function initialize(
1189         bytes32 _blocksMerkleRoot,
1190         uint _accumulatedWork,
1191         uint _timestamp,
1192         uint _prevTimestamp,
1193         bytes32 _lastHash,
1194         uint32 _lastBits,
1195         bytes32 _parentId,
1196         uint32 _blockHeight
1197     ) public returns (uint, bytes32) {
1198         require(bestSuperblock == 0);
1199         require(_parentId == 0);
1200 
1201         bytes32 superblockHash = calcSuperblockHash(_blocksMerkleRoot, _accumulatedWork, _timestamp, _prevTimestamp, _lastHash, _lastBits, _parentId, _blockHeight);
1202         SuperblockInfo storage superblock = superblocks[superblockHash];
1203 
1204         require(superblock.status == Status.Unitialized);
1205 
1206         indexSuperblock[indexNextSuperblock] = superblockHash;
1207 
1208         superblock.blocksMerkleRoot = _blocksMerkleRoot;
1209         superblock.accumulatedWork = _accumulatedWork;
1210         superblock.timestamp = _timestamp;
1211         superblock.prevTimestamp = _prevTimestamp;
1212         superblock.lastHash = _lastHash;
1213         superblock.parentId = _parentId;
1214         superblock.submitter = msg.sender;
1215         superblock.index = indexNextSuperblock;
1216         superblock.height = 1;
1217         superblock.lastBits = _lastBits;
1218         superblock.status = Status.Approved;
1219         superblock.ancestors = 0x0;
1220         superblock.blockHeight = _blockHeight;
1221         indexNextSuperblock++;
1222 
1223         emit NewSuperblock(superblockHash, msg.sender);
1224 
1225         bestSuperblock = superblockHash;
1226         bestSuperblockAccumulatedWork = _accumulatedWork;
1227 
1228         emit ApprovedSuperblock(superblockHash, msg.sender);
1229 
1230         return (ERR_SUPERBLOCK_OK, superblockHash);
1231     }
1232 
1233     // @dev - Proposes a new superblock
1234     //
1235     // To be accepted, a new superblock needs to have its parent
1236     // either approved or semi-approved.
1237     //
1238     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1239     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1240     // @param _timestamp Timestamp of the last block in the superblock
1241     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1242     // @param _lastHash Hash of the last block in the superblock
1243     // @param _lastBits Difficulty bits of the last block in the superblock
1244     // @param _parentId Id of the parent superblock
1245     // @param _blockHeight Block height of last block in superblock
1246     // @return Error code and superblockHash
1247     function propose(
1248         bytes32 _blocksMerkleRoot,
1249         uint _accumulatedWork,
1250         uint _timestamp,
1251         uint _prevTimestamp,
1252         bytes32 _lastHash,
1253         uint32 _lastBits,
1254         bytes32 _parentId,
1255         uint32 _blockHeight,
1256         address submitter
1257     ) public returns (uint, bytes32) {
1258         if (msg.sender != trustedClaimManager) {
1259             emit ErrorSuperblock(0, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1260             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1261         }
1262 
1263         SuperblockInfo storage parent = superblocks[_parentId];
1264         if (parent.status != Status.SemiApproved && parent.status != Status.Approved) {
1265             emit ErrorSuperblock(superblockHash, ERR_SUPERBLOCK_BAD_PARENT);
1266             return (ERR_SUPERBLOCK_BAD_PARENT, 0);
1267         }
1268 
1269         bytes32 superblockHash = calcSuperblockHash(_blocksMerkleRoot, _accumulatedWork, _timestamp, _prevTimestamp, _lastHash, _lastBits, _parentId, _blockHeight);
1270         SuperblockInfo storage superblock = superblocks[superblockHash];
1271         if (superblock.status == Status.Unitialized) {
1272             indexSuperblock[indexNextSuperblock] = superblockHash;
1273             superblock.blocksMerkleRoot = _blocksMerkleRoot;
1274             superblock.accumulatedWork = _accumulatedWork;
1275             superblock.timestamp = _timestamp;
1276             superblock.prevTimestamp = _prevTimestamp;
1277             superblock.lastHash = _lastHash;
1278             superblock.parentId = _parentId;
1279             superblock.submitter = submitter;
1280             superblock.index = indexNextSuperblock;
1281             superblock.height = parent.height + 1;
1282             superblock.lastBits = _lastBits;
1283             superblock.status = Status.New;
1284             superblock.blockHeight = _blockHeight;
1285             superblock.ancestors = updateAncestors(parent.ancestors, parent.index, parent.height);
1286             indexNextSuperblock++;
1287             emit NewSuperblock(superblockHash, submitter);
1288         }
1289         
1290 
1291         return (ERR_SUPERBLOCK_OK, superblockHash);
1292     }
1293 
1294     // @dev - Confirm a proposed superblock
1295     //
1296     // An unchallenged superblock can be confirmed after a timeout.
1297     // A challenged superblock is confirmed if it has enough descendants
1298     // in the main chain.
1299     //
1300     // @param _superblockHash Id of the superblock to confirm
1301     // @param _validator Address requesting superblock confirmation
1302     // @return Error code and superblockHash
1303     function confirm(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1304         if (msg.sender != trustedClaimManager) {
1305             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1306             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1307         }
1308         SuperblockInfo storage superblock = superblocks[_superblockHash];
1309         if (superblock.status != Status.New && superblock.status != Status.SemiApproved) {
1310             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1311             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1312         }
1313         SuperblockInfo storage parent = superblocks[superblock.parentId];
1314         if (parent.status != Status.Approved) {
1315             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_PARENT);
1316             return (ERR_SUPERBLOCK_BAD_PARENT, 0);
1317         }
1318         superblock.status = Status.Approved;
1319         if (superblock.accumulatedWork > bestSuperblockAccumulatedWork) {
1320             bestSuperblock = _superblockHash;
1321             bestSuperblockAccumulatedWork = superblock.accumulatedWork;
1322         }
1323         emit ApprovedSuperblock(_superblockHash, _validator);
1324         return (ERR_SUPERBLOCK_OK, _superblockHash);
1325     }
1326 
1327     // @dev - Challenge a proposed superblock
1328     //
1329     // A new superblock can be challenged to start a battle
1330     // to verify the correctness of the data submitted.
1331     //
1332     // @param _superblockHash Id of the superblock to challenge
1333     // @param _challenger Address requesting a challenge
1334     // @return Error code and superblockHash
1335     function challenge(bytes32 _superblockHash, address _challenger) public returns (uint, bytes32) {
1336         if (msg.sender != trustedClaimManager) {
1337             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1338             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1339         }
1340         SuperblockInfo storage superblock = superblocks[_superblockHash];
1341         if (superblock.status != Status.New && superblock.status != Status.InBattle) {
1342             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1343             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1344         }
1345         if(superblock.submitter == _challenger){
1346             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_OWN_CHALLENGE);
1347             return (ERR_SUPERBLOCK_OWN_CHALLENGE, 0);        
1348         }
1349         superblock.status = Status.InBattle;
1350         emit ChallengeSuperblock(_superblockHash, _challenger);
1351         return (ERR_SUPERBLOCK_OK, _superblockHash);
1352     }
1353 
1354     // @dev - Semi-approve a challenged superblock
1355     //
1356     // A challenged superblock can be marked as semi-approved
1357     // if it satisfies all the queries or when all challengers have
1358     // stopped participating.
1359     //
1360     // @param _superblockHash Id of the superblock to semi-approve
1361     // @param _validator Address requesting semi approval
1362     // @return Error code and superblockHash
1363     function semiApprove(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1364         if (msg.sender != trustedClaimManager) {
1365             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1366             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1367         }
1368         SuperblockInfo storage superblock = superblocks[_superblockHash];
1369 
1370         if (superblock.status != Status.InBattle && superblock.status != Status.New) {
1371             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1372             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1373         }
1374         superblock.status = Status.SemiApproved;
1375         emit SemiApprovedSuperblock(_superblockHash, _validator);
1376         return (ERR_SUPERBLOCK_OK, _superblockHash);
1377     }
1378 
1379     // @dev - Invalidates a superblock
1380     //
1381     // A superblock with incorrect data can be invalidated immediately.
1382     // Superblocks that are not in the main chain can be invalidated
1383     // if not enough superblocks follow them, i.e. they don't have
1384     // enough descendants.
1385     //
1386     // @param _superblockHash Id of the superblock to invalidate
1387     // @param _validator Address requesting superblock invalidation
1388     // @return Error code and superblockHash
1389     function invalidate(bytes32 _superblockHash, address _validator) public returns (uint, bytes32) {
1390         if (msg.sender != trustedClaimManager) {
1391             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_NOT_CLAIMMANAGER);
1392             return (ERR_SUPERBLOCK_NOT_CLAIMMANAGER, 0);
1393         }
1394         SuperblockInfo storage superblock = superblocks[_superblockHash];
1395         if (superblock.status != Status.InBattle && superblock.status != Status.SemiApproved) {
1396             emit ErrorSuperblock(_superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
1397             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
1398         }
1399         superblock.status = Status.Invalid;
1400         emit InvalidSuperblock(_superblockHash, _validator);
1401         return (ERR_SUPERBLOCK_OK, _superblockHash);
1402     }
1403 
1404     // @dev - relays transaction `_txBytes` to `_untrustedTargetContract`'s processTransaction() method.
1405     // Also logs the value of processTransaction.
1406     // Note: callers cannot be 100% certain when an ERR_RELAY_VERIFY occurs because
1407     // it may also have been returned by processTransaction(). Callers should be
1408     // aware of the contract that they are relaying transactions to and
1409     // understand what that contract's processTransaction method returns.
1410     //
1411     // @param _txBytes - transaction bytes
1412     // @param _txIndex - transaction's index within the block
1413     // @param _txSiblings - transaction's Merkle siblings
1414     // @param _syscoinBlockHeader - block header containing transaction
1415     // @param _syscoinBlockIndex - block's index withing superblock
1416     // @param _syscoinBlockSiblings - block's merkle siblings
1417     // @param _superblockHash - superblock containing block header
1418     // @param _untrustedTargetContract - the contract that is going to process the transaction
1419     function relayTx(
1420         bytes memory _txBytes,
1421         uint _txIndex,
1422         uint[] _txSiblings,
1423         bytes memory _syscoinBlockHeader,
1424         uint _syscoinBlockIndex,
1425         uint[] memory _syscoinBlockSiblings,
1426         bytes32 _superblockHash,
1427         SyscoinTransactionProcessor _untrustedTargetContract
1428     ) public returns (uint) {
1429 
1430         // Check if Syscoin block belongs to given superblock
1431         if (bytes32(SyscoinMessageLibrary.computeMerkle(SyscoinMessageLibrary.dblShaFlip(_syscoinBlockHeader), _syscoinBlockIndex, _syscoinBlockSiblings))
1432             != getSuperblockMerkleRoot(_superblockHash)) {
1433             // Syscoin block is not in superblock
1434             emit RelayTransaction(bytes32(0), ERR_SUPERBLOCK);
1435             return ERR_SUPERBLOCK;
1436         }
1437         uint txHash = verifyTx(_txBytes, _txIndex, _txSiblings, _syscoinBlockHeader, _superblockHash);
1438         if (txHash != 0) {
1439             uint ret = parseTxHelper(_txBytes, txHash, _untrustedTargetContract);
1440             if(ret != 0){
1441                 emit RelayTransaction(bytes32(0), ret);
1442                 return ret;
1443             }
1444             ProcessTransactionParams memory params = txParams[txHash];
1445             params.superblockSubmitterAddress = superblocks[_superblockHash].submitter;
1446             txParams[txHash] = params;
1447             return verifyTxHelper(txHash);
1448         }
1449         emit RelayTransaction(bytes32(0), ERR_RELAY_VERIFY);
1450         return(ERR_RELAY_VERIFY);        
1451     }
1452     function parseTxHelper(bytes memory _txBytes, uint txHash, SyscoinTransactionProcessor _untrustedTargetContract) private returns (uint) {
1453         uint value;
1454         address destinationAddress;
1455         uint32 _assetGUID;
1456         uint ret;
1457         (ret, value, destinationAddress, _assetGUID) = SyscoinMessageLibrary.parseTransaction(_txBytes);
1458         if(ret != 0){
1459             return ret;
1460         }
1461 
1462         ProcessTransactionParams memory params;
1463         params.value = value;
1464         params.destinationAddress = destinationAddress;
1465         params.assetGUID = _assetGUID;
1466         params.untrustedTargetContract = _untrustedTargetContract;
1467         txParams[txHash] = params;        
1468         return 0;
1469     }
1470     function verifyTxHelper(uint txHash) private returns (uint) {
1471         ProcessTransactionParams memory params = txParams[txHash];        
1472         uint returnCode = params.untrustedTargetContract.processTransaction(txHash, params.value, params.destinationAddress, params.assetGUID, params.superblockSubmitterAddress);
1473         emit RelayTransaction(bytes32(txHash), returnCode);
1474         return (returnCode);
1475     }
1476     // @dev - Checks whether the transaction given by `_txBytes` is in the block identified by `_txBlockHeaderBytes`.
1477     // First it guards against a Merkle tree collision attack by raising an error if the transaction is exactly 64 bytes long,
1478     // then it calls helperVerifyHash to do the actual check.
1479     //
1480     // @param _txBytes - transaction bytes
1481     // @param _txIndex - transaction's index within the block
1482     // @param _siblings - transaction's Merkle siblings
1483     // @param _txBlockHeaderBytes - block header containing transaction
1484     // @param _txsuperblockHash - superblock containing block header
1485     // @return - SHA-256 hash of _txBytes if the transaction is in the block, 0 otherwise
1486     // TODO: this can probably be made private
1487     function verifyTx(
1488         bytes memory _txBytes,
1489         uint _txIndex,
1490         uint[] memory _siblings,
1491         bytes memory _txBlockHeaderBytes,
1492         bytes32 _txsuperblockHash
1493     ) public returns (uint) {
1494         uint txHash = SyscoinMessageLibrary.dblShaFlip(_txBytes);
1495 
1496         if (_txBytes.length == 64) {  // todo: is check 32 also needed?
1497             emit VerifyTransaction(bytes32(txHash), ERR_TX_64BYTE);
1498             return 0;
1499         }
1500 
1501         if (helperVerifyHash(txHash, _txIndex, _siblings, _txBlockHeaderBytes, _txsuperblockHash) == 1) {
1502             return txHash;
1503         } else {
1504             // log is done via helperVerifyHash
1505             return 0;
1506         }
1507     }
1508 
1509     // @dev - Checks whether the transaction identified by `_txHash` is in the block identified by `_blockHeaderBytes`
1510     // and whether the block is in the Syscoin main chain. Transaction check is done via Merkle proof.
1511     // Note: no verification is performed to prevent txHash from just being an
1512     // internal hash in the Merkle tree. Thus this helper method should NOT be used
1513     // directly and is intended to be private.
1514     //
1515     // @param _txHash - transaction hash
1516     // @param _txIndex - transaction's index within the block
1517     // @param _siblings - transaction's Merkle siblings
1518     // @param _blockHeaderBytes - block header containing transaction
1519     // @param _txsuperblockHash - superblock containing block header
1520     // @return - 1 if the transaction is in the block and the block is in the main chain,
1521     // 20020 (ERR_CONFIRMATIONS) if the block is not in the main chain,
1522     // 20050 (ERR_MERKLE_ROOT) if the block is in the main chain but the Merkle proof fails.
1523     function helperVerifyHash(
1524         uint256 _txHash,
1525         uint _txIndex,
1526         uint[] memory _siblings,
1527         bytes memory _blockHeaderBytes,
1528         bytes32 _txsuperblockHash
1529     ) private returns (uint) {
1530 
1531         //TODO: Verify superblock is in superblock's main chain
1532         if (!isApproved(_txsuperblockHash) || !inMainChain(_txsuperblockHash)) {
1533             emit VerifyTransaction(bytes32(_txHash), ERR_CHAIN);
1534             return (ERR_CHAIN);
1535         }
1536 
1537         // Verify tx Merkle root
1538         uint merkle = SyscoinMessageLibrary.getHeaderMerkleRoot(_blockHeaderBytes);
1539         if (SyscoinMessageLibrary.computeMerkle(_txHash, _txIndex, _siblings) != merkle) {
1540             emit VerifyTransaction(bytes32(_txHash), ERR_MERKLE_ROOT);
1541             return (ERR_MERKLE_ROOT);
1542         }
1543 
1544         emit VerifyTransaction(bytes32(_txHash), 1);
1545         return (1);
1546     }
1547 
1548     // @dev - Calculate superblock hash from superblock data
1549     //
1550     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
1551     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
1552     // @param _timestamp Timestamp of the last block in the superblock
1553     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened (every 360 blocks)
1554     // @param _lastHash Hash of the last block in the superblock
1555     // @param _lastBits Difficulty bits of the last block in the superblock
1556     // @param _parentId Id of the parent superblock
1557     // @param _blockHeight Block height of last block in superblock   
1558     // @return Superblock id
1559     function calcSuperblockHash(
1560         bytes32 _blocksMerkleRoot,
1561         uint _accumulatedWork,
1562         uint _timestamp,
1563         uint _prevTimestamp,
1564         bytes32 _lastHash,
1565         uint32 _lastBits,
1566         bytes32 _parentId,
1567         uint32 _blockHeight
1568     ) public pure returns (bytes32) {
1569         return keccak256(abi.encodePacked(
1570             _blocksMerkleRoot,
1571             _accumulatedWork,
1572             _timestamp,
1573             _prevTimestamp,
1574             _lastHash,
1575             _lastBits,
1576             _parentId,
1577             _blockHeight
1578         ));
1579     }
1580 
1581     // @dev - Returns the confirmed superblock with the most accumulated work
1582     //
1583     // @return Best superblock hash
1584     function getBestSuperblock() public view returns (bytes32) {
1585         return bestSuperblock;
1586     }
1587 
1588     // @dev - Returns the superblock data for the supplied superblock hash
1589     //
1590     // @return {
1591     //   bytes32 _blocksMerkleRoot,
1592     //   uint _accumulatedWork,
1593     //   uint _timestamp,
1594     //   uint _prevTimestamp,
1595     //   bytes32 _lastHash,
1596     //   uint32 _lastBits,
1597     //   bytes32 _parentId,
1598     //   address _submitter,
1599     //   Status _status,
1600     //   uint32 _blockHeight,
1601     // }  Superblock data
1602     function getSuperblock(bytes32 superblockHash) public view returns (
1603         bytes32 _blocksMerkleRoot,
1604         uint _accumulatedWork,
1605         uint _timestamp,
1606         uint _prevTimestamp,
1607         bytes32 _lastHash,
1608         uint32 _lastBits,
1609         bytes32 _parentId,
1610         address _submitter,
1611         Status _status,
1612         uint32 _blockHeight
1613     ) {
1614         SuperblockInfo storage superblock = superblocks[superblockHash];
1615         return (
1616             superblock.blocksMerkleRoot,
1617             superblock.accumulatedWork,
1618             superblock.timestamp,
1619             superblock.prevTimestamp,
1620             superblock.lastHash,
1621             superblock.lastBits,
1622             superblock.parentId,
1623             superblock.submitter,
1624             superblock.status,
1625             superblock.blockHeight
1626         );
1627     }
1628 
1629     // @dev - Returns superblock height
1630     function getSuperblockHeight(bytes32 superblockHash) public view returns (uint32) {
1631         return superblocks[superblockHash].height;
1632     }
1633 
1634     // @dev - Returns superblock internal index
1635     function getSuperblockIndex(bytes32 superblockHash) public view returns (uint32) {
1636         return superblocks[superblockHash].index;
1637     }
1638 
1639     // @dev - Return superblock ancestors' indexes
1640     function getSuperblockAncestors(bytes32 superblockHash) public view returns (bytes32) {
1641         return superblocks[superblockHash].ancestors;
1642     }
1643 
1644     // @dev - Return superblock blocks' Merkle root
1645     function getSuperblockMerkleRoot(bytes32 _superblockHash) public view returns (bytes32) {
1646         return superblocks[_superblockHash].blocksMerkleRoot;
1647     }
1648 
1649     // @dev - Return superblock timestamp
1650     function getSuperblockTimestamp(bytes32 _superblockHash) public view returns (uint) {
1651         return superblocks[_superblockHash].timestamp;
1652     }
1653 
1654     // @dev - Return superblock prevTimestamp
1655     function getSuperblockPrevTimestamp(bytes32 _superblockHash) public view returns (uint) {
1656         return superblocks[_superblockHash].prevTimestamp;
1657     }
1658 
1659     // @dev - Return superblock last block hash
1660     function getSuperblockLastHash(bytes32 _superblockHash) public view returns (bytes32) {
1661         return superblocks[_superblockHash].lastHash;
1662     }
1663 
1664     // @dev - Return superblock parent
1665     function getSuperblockParentId(bytes32 _superblockHash) public view returns (bytes32) {
1666         return superblocks[_superblockHash].parentId;
1667     }
1668 
1669     // @dev - Return superblock accumulated work
1670     function getSuperblockAccumulatedWork(bytes32 _superblockHash) public view returns (uint) {
1671         return superblocks[_superblockHash].accumulatedWork;
1672     }
1673 
1674     // @dev - Return superblock status
1675     function getSuperblockStatus(bytes32 _superblockHash) public view returns (Status) {
1676         return superblocks[_superblockHash].status;
1677     }
1678 
1679     // @dev - Return indexNextSuperblock
1680     function getIndexNextSuperblock() public view returns (uint32) {
1681         return indexNextSuperblock;
1682     }
1683 
1684     // @dev - Calculate Merkle root from Syscoin block hashes
1685     function makeMerkle(bytes32[] hashes) public pure returns (bytes32) {
1686         return SyscoinMessageLibrary.makeMerkle(hashes);
1687     }
1688 
1689     function isApproved(bytes32 _superblockHash) public view returns (bool) {
1690         return (getSuperblockStatus(_superblockHash) == Status.Approved);
1691     }
1692 
1693     function getChainHeight() public view returns (uint) {
1694         return superblocks[bestSuperblock].height;
1695     }
1696 
1697     // @dev - write `_fourBytes` into `_word` starting from `_position`
1698     // This is useful for writing 32bit ints inside one 32 byte word
1699     //
1700     // @param _word - information to be partially overwritten
1701     // @param _position - position to start writing from
1702     // @param _eightBytes - information to be written
1703     function writeUint32(bytes32 _word, uint _position, uint32 _fourBytes) private pure returns (bytes32) {
1704         bytes32 result;
1705         assembly {
1706             let pointer := mload(0x40)
1707             mstore(pointer, _word)
1708             mstore8(add(pointer, _position), byte(28, _fourBytes))
1709             mstore8(add(pointer, add(_position,1)), byte(29, _fourBytes))
1710             mstore8(add(pointer, add(_position,2)), byte(30, _fourBytes))
1711             mstore8(add(pointer, add(_position,3)), byte(31, _fourBytes))
1712             result := mload(pointer)
1713         }
1714         return result;
1715     }
1716 
1717     uint constant ANCESTOR_STEP = 5;
1718     uint constant NUM_ANCESTOR_DEPTHS = 8;
1719 
1720     // @dev - Update ancestor to the new height
1721     function updateAncestors(bytes32 ancestors, uint32 index, uint height) internal pure returns (bytes32) {
1722         uint step = ANCESTOR_STEP;
1723         ancestors = writeUint32(ancestors, 0, index);
1724         uint i = 1;
1725         while (i<NUM_ANCESTOR_DEPTHS && (height % step == 1)) {
1726             ancestors = writeUint32(ancestors, 4*i, index);
1727             step *= ANCESTOR_STEP;
1728             ++i;
1729         }
1730         return ancestors;
1731     }
1732 
1733     // @dev - Returns a list of superblock hashes (9 hashes maximum) that helps an agent find out what
1734     // superblocks are missing.
1735     // The first position contains bestSuperblock, then
1736     // bestSuperblock - 1,
1737     // (bestSuperblock-1) - ((bestSuperblock-1) % 5), then
1738     // (bestSuperblock-1) - ((bestSuperblock-1) % 25), ... until
1739     // (bestSuperblock-1) - ((bestSuperblock-1) % 78125)
1740     //
1741     // @return - list of up to 9 ancestor supeerblock id
1742     function getSuperblockLocator() public view returns (bytes32[9]) {
1743         bytes32[9] memory locator;
1744         locator[0] = bestSuperblock;
1745         bytes32 ancestors = getSuperblockAncestors(bestSuperblock);
1746         uint i = NUM_ANCESTOR_DEPTHS;
1747         while (i > 0) {
1748             locator[i] = indexSuperblock[uint32(ancestors & 0xFFFFFFFF)];
1749             ancestors >>= 32;
1750             --i;
1751         }
1752         return locator;
1753     }
1754 
1755     // @dev - Return ancestor at given index
1756     function getSuperblockAncestor(bytes32 superblockHash, uint index) internal view returns (bytes32) {
1757         bytes32 ancestors = superblocks[superblockHash].ancestors;
1758         uint32 ancestorsIndex =
1759             uint32(ancestors[4*index + 0]) * 0x1000000 +
1760             uint32(ancestors[4*index + 1]) * 0x10000 +
1761             uint32(ancestors[4*index + 2]) * 0x100 +
1762             uint32(ancestors[4*index + 3]) * 0x1;
1763         return indexSuperblock[ancestorsIndex];
1764     }
1765 
1766     // dev - returns depth associated with an ancestor index; applies to any superblock
1767     //
1768     // @param _index - index of ancestor to be looked up; an integer between 0 and 7
1769     // @return - depth corresponding to said index, i.e. 5**index
1770     function getAncDepth(uint _index) private pure returns (uint) {
1771         return ANCESTOR_STEP**(uint(_index));
1772     }
1773 
1774     // @dev - return superblock hash at a given height in superblock main chain
1775     //
1776     // @param _height - superblock height
1777     // @return - hash corresponding to block of height _blockHeight
1778     function getSuperblockAt(uint _height) public view returns (bytes32) {
1779         bytes32 superblockHash = bestSuperblock;
1780         uint index = NUM_ANCESTOR_DEPTHS - 1;
1781 
1782         while (getSuperblockHeight(superblockHash) > _height) {
1783             while (getSuperblockHeight(superblockHash) - _height < getAncDepth(index) && index > 0) {
1784                 index -= 1;
1785             }
1786             superblockHash = getSuperblockAncestor(superblockHash, index);
1787         }
1788 
1789         return superblockHash;
1790     }
1791 
1792     // @dev - Checks if a superblock is in superblock main chain
1793     //
1794     // @param _blockHash - hash of the block being searched for in the main chain
1795     // @return - true if the block identified by _blockHash is in the main chain,
1796     // false otherwise
1797     function inMainChain(bytes32 _superblockHash) internal view returns (bool) {
1798         uint height = getSuperblockHeight(_superblockHash);
1799         if (height == 0) return false;
1800         return (getSuperblockAt(height) == _superblockHash);
1801     }
1802 }
1803 
1804 // @dev - Manages a battle session between superblock submitter and challenger
1805 contract SyscoinBattleManager is SyscoinErrorCodes {
1806 
1807     enum ChallengeState {
1808         Unchallenged,             // Unchallenged submission
1809         Challenged,               // Claims was challenged
1810         QueryMerkleRootHashes,    // Challenger expecting block hashes
1811         RespondMerkleRootHashes,  // Blcok hashes were received and verified
1812         QueryBlockHeader,         // Challenger is requesting block headers
1813         RespondBlockHeader,       // All block headers were received
1814         PendingVerification,      // Pending superblock verification
1815         SuperblockVerified,       // Superblock verified
1816         SuperblockFailed          // Superblock not valid
1817     }
1818 
1819     enum BlockInfoStatus {
1820         Uninitialized,
1821         Requested,
1822 		Verified
1823     }
1824 
1825     struct BlockInfo {
1826         bytes32 prevBlock;
1827         uint64 timestamp;
1828         uint32 bits;
1829         BlockInfoStatus status;
1830         bytes powBlockHeader;
1831         bytes32 blockHash;
1832     }
1833 
1834     struct BattleSession {
1835         bytes32 id;
1836         bytes32 superblockHash;
1837         address submitter;
1838         address challenger;
1839         uint lastActionTimestamp;         // Last action timestamp
1840         uint lastActionClaimant;          // Number last action submitter
1841         uint lastActionChallenger;        // Number last action challenger
1842         uint actionsCounter;              // Counter session actions
1843 
1844         bytes32[] blockHashes;            // Block hashes
1845         uint countBlockHeaderQueries;     // Number of block header queries
1846         uint countBlockHeaderResponses;   // Number of block header responses
1847 
1848         mapping (bytes32 => BlockInfo) blocksInfo;
1849 
1850         ChallengeState challengeState;    // Claim state
1851     }
1852 
1853 
1854     mapping (bytes32 => BattleSession) public sessions;
1855 
1856     uint public sessionsCount = 0;
1857 
1858     uint public superblockDuration;         // Superblock duration (in seconds)
1859     uint public superblockTimeout;          // Timeout action (in seconds)
1860 
1861 
1862     // network that the stored blocks belong to
1863     SyscoinMessageLibrary.Network private net;
1864 
1865 
1866     // Syscoin claim manager
1867     SyscoinClaimManager trustedSyscoinClaimManager;
1868 
1869     // Superblocks contract
1870     SyscoinSuperblocks trustedSuperblocks;
1871 
1872     event NewBattle(bytes32 superblockHash, bytes32 sessionId, address submitter, address challenger);
1873     event ChallengerConvicted(bytes32 superblockHash, bytes32 sessionId, address challenger);
1874     event SubmitterConvicted(bytes32 superblockHash, bytes32 sessionId, address submitter);
1875 
1876     event QueryMerkleRootHashes(bytes32 superblockHash, bytes32 sessionId, address submitter);
1877     event RespondMerkleRootHashes(bytes32 superblockHash, bytes32 sessionId, address challenger, bytes32[] blockHashes);
1878     event QueryBlockHeader(bytes32 superblockHash, bytes32 sessionId, address submitter, bytes32 blockSha256Hash);
1879     event RespondBlockHeader(bytes32 superblockHash, bytes32 sessionId, address challenger, bytes blockHeader, bytes powBlockHeader);
1880 
1881     event ErrorBattle(bytes32 sessionId, uint err);
1882     modifier onlyFrom(address sender) {
1883         require(msg.sender == sender);
1884         _;
1885     }
1886 
1887     modifier onlyClaimant(bytes32 sessionId) {
1888         require(msg.sender == sessions[sessionId].submitter);
1889         _;
1890     }
1891 
1892     modifier onlyChallenger(bytes32 sessionId) {
1893         require(msg.sender == sessions[sessionId].challenger);
1894         _;
1895     }
1896 
1897     // @dev – Configures the contract managing superblocks battles
1898     // @param _network Network type to use for block difficulty validation
1899     // @param _superblocks Contract that manages superblocks
1900     // @param _superblockDuration Superblock duration (in seconds)
1901     // @param _superblockTimeout Time to wait for challenges (in seconds)
1902     constructor(
1903         SyscoinMessageLibrary.Network _network,
1904         SyscoinSuperblocks _superblocks,
1905         uint _superblockDuration,
1906         uint _superblockTimeout
1907     ) public {
1908         net = _network;
1909         trustedSuperblocks = _superblocks;
1910         superblockDuration = _superblockDuration;
1911         superblockTimeout = _superblockTimeout;
1912     }
1913 
1914     function setSyscoinClaimManager(SyscoinClaimManager _syscoinClaimManager) public {
1915         require(address(trustedSyscoinClaimManager) == 0x0 && address(_syscoinClaimManager) != 0x0);
1916         trustedSyscoinClaimManager = _syscoinClaimManager;
1917     }
1918 
1919     // @dev - Start a battle session
1920     function beginBattleSession(bytes32 superblockHash, address submitter, address challenger)
1921         onlyFrom(trustedSyscoinClaimManager) public returns (bytes32) {
1922         bytes32 sessionId = keccak256(abi.encode(superblockHash, msg.sender, sessionsCount));
1923         BattleSession storage session = sessions[sessionId];
1924         session.id = sessionId;
1925         session.superblockHash = superblockHash;
1926         session.submitter = submitter;
1927         session.challenger = challenger;
1928         session.lastActionTimestamp = block.timestamp;
1929         session.lastActionChallenger = 0;
1930         session.lastActionClaimant = 1;     // Force challenger to start
1931         session.actionsCounter = 1;
1932         session.challengeState = ChallengeState.Challenged;
1933 
1934         sessionsCount += 1;
1935 
1936         emit NewBattle(superblockHash, sessionId, submitter, challenger);
1937         return sessionId;
1938     }
1939 
1940     // @dev - Challenger makes a query for superblock hashes
1941     function doQueryMerkleRootHashes(BattleSession storage session) internal returns (uint) {
1942         if (!hasDeposit(msg.sender, respondMerkleRootHashesCost)) {
1943             return ERR_SUPERBLOCK_MIN_DEPOSIT;
1944         }
1945         if (session.challengeState == ChallengeState.Challenged) {
1946             session.challengeState = ChallengeState.QueryMerkleRootHashes;
1947             assert(msg.sender == session.challenger);
1948             (uint err, ) = bondDeposit(session.superblockHash, msg.sender, respondMerkleRootHashesCost);
1949             if (err != ERR_SUPERBLOCK_OK) {
1950                 return err;
1951             }
1952             return ERR_SUPERBLOCK_OK;
1953         }
1954         return ERR_SUPERBLOCK_BAD_STATUS;
1955     }
1956 
1957     // @dev - Challenger makes a query for superblock hashes
1958     function queryMerkleRootHashes(bytes32 superblockHash, bytes32 sessionId) onlyChallenger(sessionId) public {
1959         BattleSession storage session = sessions[sessionId];
1960         uint err = doQueryMerkleRootHashes(session);
1961         if (err != ERR_SUPERBLOCK_OK) {
1962             emit ErrorBattle(sessionId, err);
1963         } else {
1964             session.actionsCounter += 1;
1965             session.lastActionTimestamp = block.timestamp;
1966             session.lastActionChallenger = session.actionsCounter;
1967             emit QueryMerkleRootHashes(superblockHash, sessionId, session.submitter);
1968         }
1969     }
1970 
1971     // @dev - Submitter sends hashes to verify superblock merkle root
1972     function doVerifyMerkleRootHashes(BattleSession storage session, bytes32[] blockHashes) internal returns (uint) {
1973         if (!hasDeposit(msg.sender, verifySuperblockCost)) {
1974             return ERR_SUPERBLOCK_MIN_DEPOSIT;
1975         }
1976         require(session.blockHashes.length == 0);
1977         if (session.challengeState == ChallengeState.QueryMerkleRootHashes) {
1978             (bytes32 merkleRoot, , , , bytes32 lastHash, , , ,,) = getSuperblockInfo(session.superblockHash);
1979             if (lastHash != blockHashes[blockHashes.length - 1]){
1980                 return ERR_SUPERBLOCK_BAD_LASTBLOCK;
1981             }
1982             if (merkleRoot != SyscoinMessageLibrary.makeMerkle(blockHashes)) {
1983                 return ERR_SUPERBLOCK_INVALID_MERKLE;
1984             }
1985             (uint err, ) = bondDeposit(session.superblockHash, msg.sender, verifySuperblockCost);
1986             if (err != ERR_SUPERBLOCK_OK) {
1987                 return err;
1988             }
1989             session.blockHashes = blockHashes;
1990             session.challengeState = ChallengeState.RespondMerkleRootHashes;
1991             return ERR_SUPERBLOCK_OK;
1992         }
1993         return ERR_SUPERBLOCK_BAD_STATUS;
1994     }
1995 
1996     // @dev - For the submitter to respond to challenger queries
1997     function respondMerkleRootHashes(bytes32 superblockHash, bytes32 sessionId, bytes32[] blockHashes) onlyClaimant(sessionId) public {
1998         BattleSession storage session = sessions[sessionId];
1999         uint err = doVerifyMerkleRootHashes(session, blockHashes);
2000         if (err != 0) {
2001             emit ErrorBattle(sessionId, err);
2002         } else {
2003             session.actionsCounter += 1;
2004             session.lastActionTimestamp = block.timestamp;
2005             session.lastActionClaimant = session.actionsCounter;
2006             emit RespondMerkleRootHashes(superblockHash, sessionId, session.challenger, blockHashes);
2007         }
2008     }
2009 
2010     // @dev - Challenger makes a query for block header data for a hash
2011     function doQueryBlockHeader(BattleSession storage session, bytes32 blockHash) internal returns (uint) {
2012         if (!hasDeposit(msg.sender, respondBlockHeaderCost)) {
2013             return ERR_SUPERBLOCK_MIN_DEPOSIT;
2014         }
2015         if ((session.countBlockHeaderQueries == 0 && session.challengeState == ChallengeState.RespondMerkleRootHashes) ||
2016             (session.countBlockHeaderQueries > 0 && session.challengeState == ChallengeState.RespondBlockHeader)) {
2017             require(session.countBlockHeaderQueries < session.blockHashes.length);
2018             require(session.blocksInfo[blockHash].status == BlockInfoStatus.Uninitialized);
2019             (uint err, ) = bondDeposit(session.superblockHash, msg.sender, respondBlockHeaderCost);
2020             if (err != ERR_SUPERBLOCK_OK) {
2021                 return err;
2022             }
2023             session.countBlockHeaderQueries += 1;
2024             session.blocksInfo[blockHash].status = BlockInfoStatus.Requested;
2025             session.challengeState = ChallengeState.QueryBlockHeader;
2026             return ERR_SUPERBLOCK_OK;
2027         }
2028         return ERR_SUPERBLOCK_BAD_STATUS;
2029     }
2030 
2031     // @dev - For the challenger to start a query
2032     function queryBlockHeader(bytes32 superblockHash, bytes32 sessionId, bytes32 blockHash) onlyChallenger(sessionId) public {
2033         BattleSession storage session = sessions[sessionId];
2034         uint err = doQueryBlockHeader(session, blockHash);
2035         if (err != ERR_SUPERBLOCK_OK) {
2036             emit ErrorBattle(sessionId, err);
2037         } else {
2038             session.actionsCounter += 1;
2039             session.lastActionTimestamp = block.timestamp;
2040             session.lastActionChallenger = session.actionsCounter;
2041             emit QueryBlockHeader(superblockHash, sessionId, session.submitter, blockHash);
2042         }
2043     }
2044 
2045     // @dev - Verify that block timestamp is in the superblock timestamp interval
2046     function verifyTimestamp(bytes32 superblockHash, bytes blockHeader) internal view returns (bool) {
2047         uint blockTimestamp = SyscoinMessageLibrary.getTimestamp(blockHeader);
2048         uint superblockTimestamp;
2049 
2050         (, , superblockTimestamp, , , , , ,,) = getSuperblockInfo(superblockHash);
2051 
2052         // Block timestamp to be within the expected timestamp of the superblock
2053         return (blockTimestamp <= superblockTimestamp)
2054             && (blockTimestamp / superblockDuration >= superblockTimestamp / superblockDuration - 1);
2055     }
2056 
2057     // @dev - Verify Syscoin block AuxPoW
2058     function verifyBlockAuxPoW(
2059         BlockInfo storage blockInfo,
2060         bytes32 blockHash,
2061         bytes blockHeader
2062     ) internal returns (uint, bytes) {
2063         (uint err, bool isMergeMined) =
2064             SyscoinMessageLibrary.verifyBlockHeader(blockHeader, 0, uint(blockHash));
2065         if (err != 0) {
2066             return (err, new bytes(0));
2067         }
2068         bytes memory powBlockHeader = (isMergeMined) ?
2069             SyscoinMessageLibrary.sliceArray(blockHeader, blockHeader.length - 80, blockHeader.length) :
2070             SyscoinMessageLibrary.sliceArray(blockHeader, 0, 80);
2071 
2072         blockInfo.timestamp = SyscoinMessageLibrary.getTimestamp(blockHeader);
2073         blockInfo.bits = SyscoinMessageLibrary.getBits(blockHeader);
2074         blockInfo.prevBlock = bytes32(SyscoinMessageLibrary.getHashPrevBlock(blockHeader));
2075         blockInfo.blockHash = blockHash;
2076         blockInfo.powBlockHeader = powBlockHeader;
2077         return (ERR_SUPERBLOCK_OK, powBlockHeader);
2078     }
2079 
2080     // @dev - Verify block header sent by challenger
2081     function doVerifyBlockHeader(
2082         BattleSession storage session,
2083         bytes memory blockHeader
2084     ) internal returns (uint, bytes) {
2085         if (!hasDeposit(msg.sender, respondBlockHeaderCost)) {
2086             return (ERR_SUPERBLOCK_MIN_DEPOSIT, new bytes(0));
2087         }
2088         if (session.challengeState == ChallengeState.QueryBlockHeader) {
2089             bytes32 blockSha256Hash = bytes32(SyscoinMessageLibrary.dblShaFlipMem(blockHeader, 0, 80));
2090             BlockInfo storage blockInfo = session.blocksInfo[blockSha256Hash];
2091             if (blockInfo.status != BlockInfoStatus.Requested) {
2092                 return (ERR_SUPERBLOCK_BAD_SYSCOIN_STATUS, new bytes(0));
2093             }
2094 
2095             if (!verifyTimestamp(session.superblockHash, blockHeader)) {
2096                 return (ERR_SUPERBLOCK_BAD_TIMESTAMP, new bytes(0));
2097             }
2098 			// pass in blockSha256Hash here instead of proposedScryptHash because we
2099             // don't need a proposed hash (we already calculated it here, syscoin uses 
2100             // sha256 just like bitcoin)
2101             (uint err, bytes memory powBlockHeader) =
2102                 verifyBlockAuxPoW(blockInfo, blockSha256Hash, blockHeader);
2103             if (err != ERR_SUPERBLOCK_OK) {
2104                 return (err, new bytes(0));
2105             }
2106 			// set to verify block header status
2107             blockInfo.status = BlockInfoStatus.Verified;
2108 
2109             (err, ) = bondDeposit(session.superblockHash, msg.sender, respondBlockHeaderCost);
2110             if (err != ERR_SUPERBLOCK_OK) {
2111                 return (err, new bytes(0));
2112             }
2113 
2114             session.countBlockHeaderResponses += 1;
2115 			// if header responses matches num block hashes we skip to respond block header instead of pending verification
2116             if (session.countBlockHeaderResponses == session.blockHashes.length) {
2117                 session.challengeState = ChallengeState.PendingVerification;
2118             } else {
2119                 session.challengeState = ChallengeState.RespondBlockHeader;
2120             }
2121 
2122             return (ERR_SUPERBLOCK_OK, powBlockHeader);
2123         }
2124         return (ERR_SUPERBLOCK_BAD_STATUS, new bytes(0));
2125     }
2126 
2127     // @dev - For the submitter to respond to challenger queries
2128     function respondBlockHeader(
2129         bytes32 superblockHash,
2130         bytes32 sessionId,
2131         bytes memory blockHeader
2132     ) onlyClaimant(sessionId) public {
2133         BattleSession storage session = sessions[sessionId];
2134         (uint err, bytes memory powBlockHeader) = doVerifyBlockHeader(session, blockHeader);
2135         if (err != 0) {
2136             emit ErrorBattle(sessionId, err);
2137         } else {
2138             session.actionsCounter += 1;
2139             session.lastActionTimestamp = block.timestamp;
2140             session.lastActionClaimant = session.actionsCounter;
2141             emit RespondBlockHeader(superblockHash, sessionId, session.challenger, blockHeader, powBlockHeader);
2142         }
2143     }
2144 
2145     // @dev - Validate superblock information from last blocks
2146     function validateLastBlocks(BattleSession storage session) internal view returns (uint) {
2147         if (session.blockHashes.length <= 0) {
2148             return ERR_SUPERBLOCK_BAD_LASTBLOCK;
2149         }
2150         uint lastTimestamp;
2151         uint prevTimestamp;
2152         uint32 lastBits;
2153         bytes32 parentId;
2154         (, , lastTimestamp, prevTimestamp, , lastBits, parentId,,,) = getSuperblockInfo(session.superblockHash);
2155         bytes32 blockSha256Hash = session.blockHashes[session.blockHashes.length - 1];
2156         if (session.blocksInfo[blockSha256Hash].timestamp != lastTimestamp) {
2157             return ERR_SUPERBLOCK_BAD_TIMESTAMP;
2158         }
2159         if (session.blocksInfo[blockSha256Hash].bits != lastBits) {
2160             return ERR_SUPERBLOCK_BAD_BITS;
2161         }
2162         if (prevTimestamp > lastTimestamp) {
2163             return ERR_SUPERBLOCK_BAD_TIMESTAMP;
2164         }
2165         
2166         return ERR_SUPERBLOCK_OK;
2167     }
2168 
2169     // @dev - Validate superblock accumulated work
2170     function validateProofOfWork(BattleSession storage session) internal view returns (uint) {
2171         uint accWork;
2172         bytes32 prevBlock;
2173         uint32 prevHeight;  
2174         uint32 proposedHeight;  
2175         uint prevTimestamp;
2176         (, accWork, , prevTimestamp, , , prevBlock, ,,proposedHeight) = getSuperblockInfo(session.superblockHash);
2177         uint parentTimestamp;
2178         
2179         uint32 prevBits;
2180        
2181         uint work;    
2182         (, work, parentTimestamp, , prevBlock, prevBits, , , ,prevHeight) = getSuperblockInfo(prevBlock);
2183         
2184         if (proposedHeight != (prevHeight+uint32(session.blockHashes.length))) {
2185             return ERR_SUPERBLOCK_BAD_BLOCKHEIGHT;
2186         }      
2187         uint ret = validateSuperblockProofOfWork(session, parentTimestamp, prevHeight, work, accWork, prevTimestamp, prevBits, prevBlock);
2188         if(ret != 0){
2189             return ret;
2190         }
2191         return ERR_SUPERBLOCK_OK;
2192     }
2193     function validateSuperblockProofOfWork(BattleSession storage session, uint parentTimestamp, uint32 prevHeight, uint work, uint accWork, uint prevTimestamp, uint32 prevBits, bytes32 prevBlock) internal view returns (uint){
2194          uint32 idx = 0;
2195          while (idx < session.blockHashes.length) {
2196             bytes32 blockSha256Hash = session.blockHashes[idx];
2197             uint32 bits = session.blocksInfo[blockSha256Hash].bits;
2198             if (session.blocksInfo[blockSha256Hash].prevBlock != prevBlock) {
2199                 return ERR_SUPERBLOCK_BAD_PARENT;
2200             }
2201             if (net != SyscoinMessageLibrary.Network.REGTEST) {
2202                 uint32 newBits;
2203                 if (net == SyscoinMessageLibrary.Network.TESTNET && session.blocksInfo[blockSha256Hash].timestamp - parentTimestamp > 120) {
2204                     newBits = 0x1e0fffff;
2205                 }
2206                 else if((prevHeight+idx+1) % SyscoinMessageLibrary.difficultyAdjustmentInterval() != 0){
2207                     newBits = prevBits;
2208                 }
2209                 else{
2210                     newBits = SyscoinMessageLibrary.calculateDifficulty(int64(parentTimestamp) - int64(prevTimestamp), prevBits);
2211                     prevTimestamp = parentTimestamp;
2212                     prevBits = bits;
2213                 }
2214                 if (bits != newBits) {
2215                    return ERR_SUPERBLOCK_BAD_BITS;
2216                 }
2217             }
2218             work += SyscoinMessageLibrary.diffFromBits(bits);
2219             prevBlock = blockSha256Hash;
2220             parentTimestamp = session.blocksInfo[blockSha256Hash].timestamp;
2221             idx += 1;
2222         }
2223         if (net != SyscoinMessageLibrary.Network.REGTEST &&  work != accWork) {
2224             return ERR_SUPERBLOCK_BAD_ACCUMULATED_WORK;
2225         }       
2226         return 0;
2227     }
2228     // @dev - Verify whether a superblock's data is consistent
2229     // Only should be called when all blocks header were submitted
2230     function doVerifySuperblock(BattleSession storage session, bytes32 sessionId) internal returns (uint) {
2231         if (session.challengeState == ChallengeState.PendingVerification) {
2232             uint err;
2233             err = validateLastBlocks(session);
2234             if (err != 0) {
2235                 emit ErrorBattle(sessionId, err);
2236                 return 2;
2237             }
2238             err = validateProofOfWork(session);
2239             if (err != 0) {
2240                 emit ErrorBattle(sessionId, err);
2241                 return 2;
2242             }
2243             return 1;
2244         } else if (session.challengeState == ChallengeState.SuperblockFailed) {
2245             return 2;
2246         }
2247         return 0;
2248     }
2249 
2250     // @dev - Perform final verification once all blocks were submitted
2251     function verifySuperblock(bytes32 sessionId) public {
2252         BattleSession storage session = sessions[sessionId];
2253         uint status = doVerifySuperblock(session, sessionId);
2254         if (status == 1) {
2255             convictChallenger(sessionId, session.challenger, session.superblockHash);
2256         } else if (status == 2) {
2257             convictSubmitter(sessionId, session.submitter, session.superblockHash);
2258         }
2259     }
2260 
2261     // @dev - Trigger conviction if response is not received in time
2262     function timeout(bytes32 sessionId) public returns (uint) {
2263         BattleSession storage session = sessions[sessionId];
2264         if (session.challengeState == ChallengeState.SuperblockFailed ||
2265             (session.lastActionChallenger > session.lastActionClaimant &&
2266             block.timestamp > session.lastActionTimestamp + superblockTimeout)) {
2267             convictSubmitter(sessionId, session.submitter, session.superblockHash);
2268             return ERR_SUPERBLOCK_OK;
2269         } else if (session.lastActionClaimant > session.lastActionChallenger &&
2270             block.timestamp > session.lastActionTimestamp + superblockTimeout) {
2271             convictChallenger(sessionId, session.challenger, session.superblockHash);
2272             return ERR_SUPERBLOCK_OK;
2273         }
2274         emit ErrorBattle(sessionId, ERR_SUPERBLOCK_NO_TIMEOUT);
2275         return ERR_SUPERBLOCK_NO_TIMEOUT;
2276     }
2277 
2278     // @dev - To be called when a challenger is convicted
2279     function convictChallenger(bytes32 sessionId, address challenger, bytes32 superblockHash) internal {
2280         BattleSession storage session = sessions[sessionId];
2281         sessionDecided(sessionId, superblockHash, session.submitter, session.challenger);
2282         disable(sessionId);
2283         emit ChallengerConvicted(superblockHash, sessionId, challenger);
2284     }
2285 
2286     // @dev - To be called when a submitter is convicted
2287     function convictSubmitter(bytes32 sessionId, address submitter, bytes32 superblockHash) internal {
2288         BattleSession storage session = sessions[sessionId];
2289         sessionDecided(sessionId, superblockHash, session.challenger, session.submitter);
2290         disable(sessionId);
2291         emit SubmitterConvicted(superblockHash, sessionId, submitter);
2292     }
2293 
2294     // @dev - Disable session
2295     // It should be called only when either the submitter or the challenger were convicted.
2296     function disable(bytes32 sessionId) internal {
2297         delete sessions[sessionId];
2298     }
2299 
2300     // @dev - Check if a session's challenger did not respond before timeout
2301     function getChallengerHitTimeout(bytes32 sessionId) public view returns (bool) {
2302         BattleSession storage session = sessions[sessionId];
2303         return (session.lastActionClaimant > session.lastActionChallenger &&
2304             block.timestamp > session.lastActionTimestamp + superblockTimeout);
2305     }
2306 
2307     // @dev - Check if a session's submitter did not respond before timeout
2308     function getSubmitterHitTimeout(bytes32 sessionId) public view returns (bool) {
2309         BattleSession storage session = sessions[sessionId];
2310         return (session.lastActionChallenger > session.lastActionClaimant &&
2311             block.timestamp > session.lastActionTimestamp + superblockTimeout);
2312     }
2313 
2314     // @dev - Return Syscoin block hashes associated with a certain battle session
2315     function getSyscoinBlockHashes(bytes32 sessionId) public view returns (bytes32[]) {
2316         return sessions[sessionId].blockHashes;
2317     }
2318 
2319     // @dev - To be called when a battle sessions  was decided
2320     function sessionDecided(bytes32 sessionId, bytes32 superblockHash, address winner, address loser) internal {
2321         trustedSyscoinClaimManager.sessionDecided(sessionId, superblockHash, winner, loser);
2322     }
2323 
2324     // @dev - Retrieve superblock information
2325     function getSuperblockInfo(bytes32 superblockHash) internal view returns (
2326         bytes32 _blocksMerkleRoot,
2327         uint _accumulatedWork,
2328         uint _timestamp,
2329         uint _prevTimestamp,
2330         bytes32 _lastHash,
2331         uint32 _lastBits,
2332         bytes32 _parentId,
2333         address _submitter,
2334         SyscoinSuperblocks.Status _status,
2335         uint32 _height
2336     ) {
2337         return trustedSuperblocks.getSuperblock(superblockHash);
2338     }
2339 
2340     // @dev - Verify whether a user has a certain amount of deposits or more
2341     function hasDeposit(address who, uint amount) internal view returns (bool) {
2342         return trustedSyscoinClaimManager.getDeposit(who) >= amount;
2343     }
2344 
2345     // @dev – locks up part of a user's deposit into a claim.
2346     function bondDeposit(bytes32 superblockHash, address account, uint amount) internal returns (uint, uint) {
2347         return trustedSyscoinClaimManager.bondDeposit(superblockHash, account, amount);
2348     }
2349 }
2350 
2351 // @dev - Manager of superblock claims
2352 //
2353 // Manages superblocks proposal and challenges
2354 contract SyscoinClaimManager is SyscoinDepositsManager, SyscoinErrorCodes {
2355 
2356     using SafeMath for uint;
2357 
2358     struct SuperblockClaim {
2359         bytes32 superblockHash;                       // Superblock Id
2360         address submitter;                           // Superblock submitter
2361         uint createdAt;                             // Superblock creation time
2362 
2363         address[] challengers;                      // List of challengers
2364         mapping (address => uint) bondedDeposits;   // Deposit associated to challengers
2365 
2366         uint currentChallenger;                     // Index of challenger in current session
2367         mapping (address => bytes32) sessions;      // Challenge sessions
2368 
2369         uint challengeTimeout;                      // Claim timeout
2370 
2371         bool verificationOngoing;                   // Challenge session has started
2372 
2373         bool decided;                               // If the claim was decided
2374         bool invalid;                               // If superblock is invalid
2375     }
2376 
2377     // Active superblock claims
2378     mapping (bytes32 => SuperblockClaim) public claims;
2379 
2380     // Superblocks contract
2381     SyscoinSuperblocks public trustedSuperblocks;
2382 
2383     // Battle manager contract
2384     SyscoinBattleManager public trustedSyscoinBattleManager;
2385 
2386     // Confirmations required to confirm semi approved superblocks
2387     uint public superblockConfirmations;
2388 
2389     // Monetary reward for opponent in case battle is lost
2390     uint public battleReward;
2391 
2392     uint public superblockDelay;    // Delay required to submit superblocks (in seconds)
2393     uint public superblockTimeout;  // Timeout for action (in seconds)
2394 
2395     event DepositBonded(bytes32 superblockHash, address account, uint amount);
2396     event DepositUnbonded(bytes32 superblockHash, address account, uint amount);
2397     event SuperblockClaimCreated(bytes32 superblockHash, address submitter);
2398     event SuperblockClaimChallenged(bytes32 superblockHash, address challenger);
2399     event SuperblockBattleDecided(bytes32 sessionId, address winner, address loser);
2400     event SuperblockClaimSuccessful(bytes32 superblockHash, address submitter);
2401     event SuperblockClaimPending(bytes32 superblockHash, address submitter);
2402     event SuperblockClaimFailed(bytes32 superblockHash, address submitter);
2403     event VerificationGameStarted(bytes32 superblockHash, address submitter, address challenger, bytes32 sessionId);
2404 
2405     event ErrorClaim(bytes32 superblockHash, uint err);
2406 
2407     modifier onlyBattleManager() {
2408         require(msg.sender == address(trustedSyscoinBattleManager));
2409         _;
2410     }
2411 
2412     modifier onlyMeOrBattleManager() {
2413         require(msg.sender == address(trustedSyscoinBattleManager) || msg.sender == address(this));
2414         _;
2415     }
2416 
2417     // @dev – Sets up the contract managing superblock challenges
2418     // @param _superblocks Contract that manages superblocks
2419     // @param _battleManager Contract that manages battles
2420     // @param _superblockDelay Delay to accept a superblock submission (in seconds)
2421     // @param _superblockTimeout Time to wait for challenges (in seconds)
2422     // @param _superblockConfirmations Confirmations required to confirm semi approved superblocks
2423     constructor(
2424         SyscoinSuperblocks _superblocks,
2425         SyscoinBattleManager _syscoinBattleManager,
2426         uint _superblockDelay,
2427         uint _superblockTimeout,
2428         uint _superblockConfirmations,
2429         uint _battleReward
2430     ) public {
2431         trustedSuperblocks = _superblocks;
2432         trustedSyscoinBattleManager = _syscoinBattleManager;
2433         superblockDelay = _superblockDelay;
2434         superblockTimeout = _superblockTimeout;
2435         superblockConfirmations = _superblockConfirmations;
2436         battleReward = _battleReward;
2437     }
2438 
2439     // @dev – locks up part of a user's deposit into a claim.
2440     // @param superblockHash – claim id.
2441     // @param account – user's address.
2442     // @param amount – amount of deposit to lock up.
2443     // @return – user's deposit bonded for the claim.
2444     function bondDeposit(bytes32 superblockHash, address account, uint amount) onlyMeOrBattleManager external returns (uint, uint) {
2445         SuperblockClaim storage claim = claims[superblockHash];
2446 
2447         if (!claimExists(claim)) {
2448             return (ERR_SUPERBLOCK_BAD_CLAIM, 0);
2449         }
2450 
2451         if (deposits[account] < amount) {
2452             return (ERR_SUPERBLOCK_MIN_DEPOSIT, deposits[account]);
2453         }
2454 
2455         deposits[account] = deposits[account].sub(amount);
2456         claim.bondedDeposits[account] = claim.bondedDeposits[account].add(amount);
2457         emit DepositBonded(superblockHash, account, amount);
2458 
2459         return (ERR_SUPERBLOCK_OK, claim.bondedDeposits[account]);
2460     }
2461 
2462     // @dev – accessor for a claim's bonded deposits.
2463     // @param superblockHash – claim id.
2464     // @param account – user's address.
2465     // @return – user's deposit bonded for the claim.
2466     function getBondedDeposit(bytes32 superblockHash, address account) public view returns (uint) {
2467         SuperblockClaim storage claim = claims[superblockHash];
2468         require(claimExists(claim));
2469         return claim.bondedDeposits[account];
2470     }
2471 
2472     function getDeposit(address account) public view returns (uint) {
2473         return deposits[account];
2474     }
2475 
2476     // @dev – unlocks a user's bonded deposits from a claim.
2477     // @param superblockHash – claim id.
2478     // @param account – user's address.
2479     // @return – user's deposit which was unbonded from the claim.
2480     function unbondDeposit(bytes32 superblockHash, address account) internal returns (uint, uint) {
2481         SuperblockClaim storage claim = claims[superblockHash];
2482         if (!claimExists(claim)) {
2483             return (ERR_SUPERBLOCK_BAD_CLAIM, 0);
2484         }
2485         if (!claim.decided) {
2486             return (ERR_SUPERBLOCK_BAD_STATUS, 0);
2487         }
2488 
2489         uint bondedDeposit = claim.bondedDeposits[account];
2490 
2491         delete claim.bondedDeposits[account];
2492         deposits[account] = deposits[account].add(bondedDeposit);
2493 
2494         emit DepositUnbonded(superblockHash, account, bondedDeposit);
2495 
2496         return (ERR_SUPERBLOCK_OK, bondedDeposit);
2497     }
2498 
2499     // @dev – Propose a new superblock.
2500     //
2501     // @param _blocksMerkleRoot Root of the merkle tree of blocks contained in a superblock
2502     // @param _accumulatedWork Accumulated proof of work of the last block in the superblock
2503     // @param _timestamp Timestamp of the last block in the superblock
2504     // @param _prevTimestamp Timestamp of the block when the last difficulty adjustment happened
2505     // @param _lastHash Hash of the last block in the superblock
2506     // @param _lastBits Difficulty bits of the last block in the superblock
2507     // @param _parentHash Id of the parent superblock
2508     // @return Error code and superblockHash
2509     function proposeSuperblock(
2510         bytes32 _blocksMerkleRoot,
2511         uint _accumulatedWork,
2512         uint _timestamp,
2513         uint _prevTimestamp,
2514         bytes32 _lastHash,
2515         uint32 _lastBits,
2516         bytes32 _parentHash,
2517         uint32 _blockHeight
2518     ) public returns (uint, bytes32) {
2519         require(address(trustedSuperblocks) != 0);
2520 
2521         if (deposits[msg.sender] < minProposalDeposit) {
2522             emit ErrorClaim(0, ERR_SUPERBLOCK_MIN_DEPOSIT);
2523             return (ERR_SUPERBLOCK_MIN_DEPOSIT, 0);
2524         }
2525 
2526         if (_timestamp + superblockDelay > block.timestamp) {
2527             emit ErrorClaim(0, ERR_SUPERBLOCK_BAD_TIMESTAMP);
2528             return (ERR_SUPERBLOCK_BAD_TIMESTAMP, 0);
2529         }
2530 
2531         uint err;
2532         bytes32 superblockHash;
2533         (err, superblockHash) = trustedSuperblocks.propose(_blocksMerkleRoot, _accumulatedWork,
2534             _timestamp, _prevTimestamp, _lastHash, _lastBits, _parentHash, _blockHeight,msg.sender);
2535         if (err != 0) {
2536             emit ErrorClaim(superblockHash, err);
2537             return (err, superblockHash);
2538         }
2539 
2540 
2541         SuperblockClaim storage claim = claims[superblockHash];
2542         // allow to propose an existing claim only if its invalid and decided and its a different submitter or not on the tip
2543         // those are the ones that may actually be stuck and need to be proposed again, 
2544         // but we want to ensure its not the same submitter submitting the same thing
2545         if (claimExists(claim)) {
2546             bool allowed = claim.invalid == true && claim.decided == true && claim.submitter != msg.sender;
2547             if(allowed){
2548                 // we also want to ensure that if parent is approved we are building on the tip and not anywhere else
2549                 if(trustedSuperblocks.getSuperblockStatus(_parentHash) == SyscoinSuperblocks.Status.Approved){
2550                     allowed = trustedSuperblocks.getBestSuperblock() == _parentHash;
2551                 }
2552                 // or if its semi approved allow to build on top as well
2553                 else if(trustedSuperblocks.getSuperblockStatus(_parentHash) == SyscoinSuperblocks.Status.SemiApproved){
2554                     allowed = true;
2555                 }
2556                 else{
2557                     allowed = false;
2558                 }
2559             }
2560             if(!allowed){
2561                 emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2562                 return (ERR_SUPERBLOCK_BAD_CLAIM, superblockHash);  
2563             }
2564         }
2565 
2566 
2567         claim.superblockHash = superblockHash;
2568         claim.submitter = msg.sender;
2569         claim.currentChallenger = 0;
2570         claim.decided = false;
2571         claim.invalid = false;
2572         claim.verificationOngoing = false;
2573         claim.createdAt = block.timestamp;
2574         claim.challengeTimeout = block.timestamp + superblockTimeout;
2575         claim.challengers.length = 0;
2576 
2577         (err, ) = this.bondDeposit(superblockHash, msg.sender, battleReward);
2578         assert(err == ERR_SUPERBLOCK_OK);
2579 
2580         emit SuperblockClaimCreated(superblockHash, msg.sender);
2581 
2582         return (ERR_SUPERBLOCK_OK, superblockHash);
2583     }
2584 
2585     // @dev – challenge a superblock claim.
2586     // @param superblockHash – Id of the superblock to challenge.
2587     // @return - Error code and claim Id
2588     function challengeSuperblock(bytes32 superblockHash) public returns (uint, bytes32) {
2589         require(address(trustedSuperblocks) != 0);
2590 
2591         SuperblockClaim storage claim = claims[superblockHash];
2592 
2593         if (!claimExists(claim)) {
2594             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2595             return (ERR_SUPERBLOCK_BAD_CLAIM, superblockHash);
2596         }
2597         if (claim.decided) {
2598             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_CLAIM_DECIDED);
2599             return (ERR_SUPERBLOCK_CLAIM_DECIDED, superblockHash);
2600         }
2601         if (deposits[msg.sender] < minChallengeDeposit) {
2602             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_MIN_DEPOSIT);
2603             return (ERR_SUPERBLOCK_MIN_DEPOSIT, superblockHash);
2604         }
2605 
2606         uint err;
2607         (err, ) = trustedSuperblocks.challenge(superblockHash, msg.sender);
2608         if (err != 0) {
2609             emit ErrorClaim(superblockHash, err);
2610             return (err, 0);
2611         }
2612 
2613         (err, ) = this.bondDeposit(superblockHash, msg.sender, battleReward);
2614         assert(err == ERR_SUPERBLOCK_OK);
2615 
2616         claim.challengeTimeout = block.timestamp + superblockTimeout;
2617         claim.challengers.push(msg.sender);
2618         emit SuperblockClaimChallenged(superblockHash, msg.sender);
2619 
2620         if (!claim.verificationOngoing) {
2621             runNextBattleSession(superblockHash);
2622         }
2623 
2624         return (ERR_SUPERBLOCK_OK, superblockHash);
2625     }
2626 
2627     // @dev – runs a battle session to verify a superblock for the next challenger
2628     // @param superblockHash – claim id.
2629     function runNextBattleSession(bytes32 superblockHash) internal returns (bool) {
2630         SuperblockClaim storage claim = claims[superblockHash];
2631 
2632         if (!claimExists(claim)) {
2633             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2634             return false;
2635         }
2636 
2637         // superblocks marked as invalid do not have to run remaining challengers
2638         if (claim.decided || claim.invalid) {
2639             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_CLAIM_DECIDED);
2640             return false;
2641         }
2642 
2643         if (claim.verificationOngoing) {
2644             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_VERIFICATION_PENDING);
2645             return false;
2646         }
2647 
2648         if (claim.currentChallenger < claim.challengers.length) {
2649 
2650             bytes32 sessionId = trustedSyscoinBattleManager.beginBattleSession(superblockHash, claim.submitter,
2651                 claim.challengers[claim.currentChallenger]);
2652 
2653             claim.sessions[claim.challengers[claim.currentChallenger]] = sessionId;
2654             emit VerificationGameStarted(superblockHash, claim.submitter,
2655                 claim.challengers[claim.currentChallenger], sessionId);
2656 
2657             claim.verificationOngoing = true;
2658             claim.currentChallenger += 1;
2659         }
2660 
2661         return true;
2662     }
2663 
2664     // @dev – check whether a claim has successfully withstood all challenges.
2665     // If successful without challenges, it will mark the superblock as confirmed.
2666     // If successful with at least one challenge, it will mark the superblock as semi-approved.
2667     // If verification failed, it will mark the superblock as invalid.
2668     //
2669     // @param superblockHash – claim ID.
2670     function checkClaimFinished(bytes32 superblockHash) public returns (bool) {
2671         SuperblockClaim storage claim = claims[superblockHash];
2672 
2673         if (!claimExists(claim)) {
2674             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2675             return false;
2676         }
2677 
2678         // check that there is no ongoing verification game.
2679         if (claim.verificationOngoing) {
2680             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_VERIFICATION_PENDING);
2681             return false;
2682         }
2683 
2684         // an invalid superblock can be rejected immediately
2685         if (claim.invalid) {
2686             // The superblock is invalid, submitter abandoned
2687             // or superblock data is inconsistent
2688             claim.decided = true;
2689             trustedSuperblocks.invalidate(claim.superblockHash, msg.sender);
2690             emit SuperblockClaimFailed(superblockHash, claim.submitter);
2691             doPayChallengers(superblockHash, claim);
2692             return false;
2693         }
2694 
2695         // check that the claim has exceeded the claim's specific challenge timeout.
2696         if (block.timestamp <= claim.challengeTimeout) {
2697             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_NO_TIMEOUT);
2698             return false;
2699         }
2700 
2701         // check that all verification games have been played.
2702         if (claim.currentChallenger < claim.challengers.length) {
2703             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_VERIFICATION_PENDING);
2704             return false;
2705         }
2706 
2707         claim.decided = true;
2708 
2709         bool confirmImmediately = false;
2710         // No challengers and parent approved; confirm immediately
2711         if (claim.challengers.length == 0) {
2712             bytes32 parentId = trustedSuperblocks.getSuperblockParentId(claim.superblockHash);
2713             SyscoinSuperblocks.Status status = trustedSuperblocks.getSuperblockStatus(parentId);
2714             if (status == SyscoinSuperblocks.Status.Approved) {
2715                 confirmImmediately = true;
2716             }
2717         }
2718 
2719         if (confirmImmediately) {
2720             trustedSuperblocks.confirm(claim.superblockHash, msg.sender);
2721             unbondDeposit(superblockHash, claim.submitter);
2722             emit SuperblockClaimSuccessful(superblockHash, claim.submitter);
2723         } else {
2724             trustedSuperblocks.semiApprove(claim.superblockHash, msg.sender);
2725             emit SuperblockClaimPending(superblockHash, claim.submitter);
2726         }
2727         return true;
2728     }
2729 
2730     // @dev – confirm semi approved superblock.
2731     //
2732     // A semi approved superblock can be confirmed if it has several descendant
2733     // superblocks that are also semi-approved.
2734     // If none of the descendants were challenged they will also be confirmed.
2735     //
2736     // @param superblockHash – the claim ID.
2737     // @param descendantId - claim ID descendants
2738     function confirmClaim(bytes32 superblockHash, bytes32 descendantId) public returns (bool) {
2739         uint numSuperblocks = 0;
2740         bool confirmDescendants = true;
2741         bytes32 id = descendantId;
2742         SuperblockClaim storage claim = claims[id];
2743         while (id != superblockHash) {
2744             if (!claimExists(claim)) {
2745                 emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2746                 return false;
2747             }
2748             if (trustedSuperblocks.getSuperblockStatus(id) != SyscoinSuperblocks.Status.SemiApproved) {
2749                 emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
2750                 return false;
2751             }
2752             if (confirmDescendants && claim.challengers.length > 0) {
2753                 confirmDescendants = false;
2754             }
2755             id = trustedSuperblocks.getSuperblockParentId(id);
2756             claim = claims[id];
2757             numSuperblocks += 1;
2758         }
2759 
2760         if (numSuperblocks < superblockConfirmations) {
2761             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_MISSING_CONFIRMATIONS);
2762             return false;
2763         }
2764         if (trustedSuperblocks.getSuperblockStatus(id) != SyscoinSuperblocks.Status.SemiApproved) {
2765             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
2766             return false;
2767         }
2768 
2769         bytes32 parentId = trustedSuperblocks.getSuperblockParentId(superblockHash);
2770         if (trustedSuperblocks.getSuperblockStatus(parentId) != SyscoinSuperblocks.Status.Approved) {
2771             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
2772             return false;
2773         }
2774 
2775         (uint err, ) = trustedSuperblocks.confirm(superblockHash, msg.sender);
2776         if (err != ERR_SUPERBLOCK_OK) {
2777             emit ErrorClaim(superblockHash, err);
2778             return false;
2779         }
2780         emit SuperblockClaimSuccessful(superblockHash, claim.submitter);
2781         doPaySubmitter(superblockHash, claim);
2782         unbondDeposit(superblockHash, claim.submitter);
2783 
2784         if (confirmDescendants) {
2785             bytes32[] memory descendants = new bytes32[](numSuperblocks);
2786             id = descendantId;
2787             uint idx = 0;
2788             while (id != superblockHash) {
2789                 descendants[idx] = id;
2790                 id = trustedSuperblocks.getSuperblockParentId(id);
2791                 idx += 1;
2792             }
2793             while (idx > 0) {
2794                 idx -= 1;
2795                 id = descendants[idx];
2796                 claim = claims[id];
2797                 (err, ) = trustedSuperblocks.confirm(id, msg.sender);
2798                 require(err == ERR_SUPERBLOCK_OK);
2799                 emit SuperblockClaimSuccessful(id, claim.submitter);
2800                 doPaySubmitter(id, claim);
2801                 unbondDeposit(id, claim.submitter);
2802             }
2803         }
2804 
2805         return true;
2806     }
2807 
2808     // @dev – Reject a semi approved superblock.
2809     //
2810     // Superblocks that are not in the main chain can be marked as
2811     // invalid.
2812     //
2813     // @param superblockHash – the claim ID.
2814     function rejectClaim(bytes32 superblockHash) public returns (bool) {
2815         SuperblockClaim storage claim = claims[superblockHash];
2816         if (!claimExists(claim)) {
2817             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_CLAIM);
2818             return false;
2819         }
2820 
2821         uint height = trustedSuperblocks.getSuperblockHeight(superblockHash);
2822         bytes32 id = trustedSuperblocks.getBestSuperblock();
2823         if (trustedSuperblocks.getSuperblockHeight(id) < height + superblockConfirmations) {
2824             emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_MISSING_CONFIRMATIONS);
2825             return false;
2826         }
2827 
2828         id = trustedSuperblocks.getSuperblockAt(height);
2829 
2830         if (id != superblockHash) {
2831             SyscoinSuperblocks.Status status = trustedSuperblocks.getSuperblockStatus(superblockHash);
2832 
2833             if (status != SyscoinSuperblocks.Status.SemiApproved) {
2834                 emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_BAD_STATUS);
2835                 return false;
2836             }
2837 
2838             if (!claim.decided) {
2839                 emit ErrorClaim(superblockHash, ERR_SUPERBLOCK_CLAIM_DECIDED);
2840                 return false;
2841             }
2842 
2843             trustedSuperblocks.invalidate(superblockHash, msg.sender);
2844             emit SuperblockClaimFailed(superblockHash, claim.submitter);
2845             doPayChallengers(superblockHash, claim);
2846             return true;
2847         }
2848 
2849         return false;
2850     }
2851 
2852     // @dev – called when a battle session has ended.
2853     //
2854     // @param sessionId – session Id.
2855     // @param superblockHash - claim Id
2856     // @param winner – winner of verification game.
2857     // @param loser – loser of verification game.
2858     function sessionDecided(bytes32 sessionId, bytes32 superblockHash, address winner, address loser) public onlyBattleManager {
2859         SuperblockClaim storage claim = claims[superblockHash];
2860 
2861         require(claimExists(claim));
2862 
2863         claim.verificationOngoing = false;
2864 
2865         if (claim.submitter == loser) {
2866             // the claim is over.
2867             // Trigger end of verification game
2868             claim.invalid = true;
2869         } else if (claim.submitter == winner) {
2870             // the claim continues.
2871             // It should not fail when called from sessionDecided
2872             runNextBattleSession(superblockHash);
2873         } else {
2874             revert();
2875         }
2876 
2877         emit SuperblockBattleDecided(sessionId, winner, loser);
2878     }
2879 
2880     // @dev - Pay challengers than ran their battles with submitter deposits
2881     // Challengers that did not run will be returned their deposits
2882     function doPayChallengers(bytes32 superblockHash, SuperblockClaim storage claim) internal {
2883         uint rewards = claim.bondedDeposits[claim.submitter];
2884         claim.bondedDeposits[claim.submitter] = 0;
2885         uint totalDeposits = 0;
2886         uint idx = 0;
2887         for (idx = 0; idx < claim.currentChallenger; ++idx) {
2888             totalDeposits = totalDeposits.add(claim.bondedDeposits[claim.challengers[idx]]);
2889         }
2890         
2891         address challenger;
2892         uint reward = 0;
2893         if(totalDeposits == 0 && claim.currentChallenger > 0){
2894             reward = rewards.div(claim.currentChallenger);
2895         }
2896         for (idx = 0; idx < claim.currentChallenger; ++idx) {
2897             reward = 0;
2898             challenger = claim.challengers[idx];
2899             if(totalDeposits > 0){
2900                 reward = rewards.mul(claim.bondedDeposits[challenger]).div(totalDeposits);
2901             }
2902             claim.bondedDeposits[challenger] = claim.bondedDeposits[challenger].add(reward);
2903         }
2904         uint bondedDeposit;
2905         for (idx = 0; idx < claim.challengers.length; ++idx) {
2906             challenger = claim.challengers[idx];
2907             bondedDeposit = claim.bondedDeposits[challenger];
2908             deposits[challenger] = deposits[challenger].add(bondedDeposit);
2909             claim.bondedDeposits[challenger] = 0;
2910             emit DepositUnbonded(superblockHash, challenger, bondedDeposit);
2911         }
2912     }
2913 
2914     // @dev - Pay submitter with challenger deposits
2915     function doPaySubmitter(bytes32 superblockHash, SuperblockClaim storage claim) internal {
2916         address challenger;
2917         uint bondedDeposit;
2918         for (uint idx=0; idx < claim.challengers.length; ++idx) {
2919             challenger = claim.challengers[idx];
2920             bondedDeposit = claim.bondedDeposits[challenger];
2921             claim.bondedDeposits[challenger] = 0;
2922             claim.bondedDeposits[claim.submitter] = claim.bondedDeposits[claim.submitter].add(bondedDeposit);
2923         }
2924         unbondDeposit(superblockHash, claim.submitter);
2925     }
2926 
2927     // @dev - Check if a superblock can be semi approved by calling checkClaimFinished
2928     function getInBattleAndSemiApprovable(bytes32 superblockHash) public view returns (bool) {
2929         SuperblockClaim storage claim = claims[superblockHash];
2930         return (trustedSuperblocks.getSuperblockStatus(superblockHash) == SyscoinSuperblocks.Status.InBattle &&
2931             !claim.invalid && !claim.verificationOngoing && block.timestamp > claim.challengeTimeout
2932             && claim.currentChallenger >= claim.challengers.length);
2933     }
2934 
2935     // @dev – Check if a claim exists
2936     function claimExists(SuperblockClaim claim) private pure returns (bool) {
2937         return (claim.submitter != 0x0);
2938     }
2939 
2940     // @dev - Return a given superblock's submitter
2941     function getClaimSubmitter(bytes32 superblockHash) public view returns (address) {
2942         return claims[superblockHash].submitter;
2943     }
2944 
2945     // @dev - Return superblock submission timestamp
2946     function getNewSuperblockEventTimestamp(bytes32 superblockHash) public view returns (uint) {
2947         return claims[superblockHash].createdAt;
2948     }
2949 
2950     // @dev - Return whether or not a claim has already been made
2951     function getClaimExists(bytes32 superblockHash) public view returns (bool) {
2952         return claimExists(claims[superblockHash]);
2953     }
2954 
2955     // @dev - Return claim status
2956     function getClaimDecided(bytes32 superblockHash) public view returns (bool) {
2957         return claims[superblockHash].decided;
2958     }
2959 
2960     // @dev - Check if a claim is invalid
2961     function getClaimInvalid(bytes32 superblockHash) public view returns (bool) {
2962         // TODO: see if this is redundant with superblock status
2963         return claims[superblockHash].invalid;
2964     }
2965 
2966     // @dev - Check if a claim has a verification game in progress
2967     function getClaimVerificationOngoing(bytes32 superblockHash) public view returns (bool) {
2968         return claims[superblockHash].verificationOngoing;
2969     }
2970 
2971     // @dev - Returns timestamp of challenge timeout
2972     function getClaimChallengeTimeout(bytes32 superblockHash) public view returns (uint) {
2973         return claims[superblockHash].challengeTimeout;
2974     }
2975 
2976     // @dev - Return the number of challengers whose battles haven't been decided yet
2977     function getClaimRemainingChallengers(bytes32 superblockHash) public view returns (uint) {
2978         SuperblockClaim storage claim = claims[superblockHash];
2979         return claim.challengers.length - (claim.currentChallenger);
2980     }
2981 
2982     // @dev – Return session by challenger
2983     function getSession(bytes32 superblockHash, address challenger) public view returns(bytes32) {
2984         return claims[superblockHash].sessions[challenger];
2985     }
2986 
2987     function getClaimChallengers(bytes32 superblockHash) public view returns (address[]) {
2988         SuperblockClaim storage claim = claims[superblockHash];
2989         return claim.challengers;
2990     }
2991 
2992     function getSuperblockInfo(bytes32 superblockHash) internal view returns (
2993         bytes32 _blocksMerkleRoot,
2994         uint _accumulatedWork,
2995         uint _timestamp,
2996         uint _prevTimestamp,
2997         bytes32 _lastHash,
2998         uint32 _lastBits,
2999         bytes32 _parentId,
3000         address _submitter,
3001         SyscoinSuperblocks.Status _status,
3002         uint32 _height
3003     ) {
3004         return trustedSuperblocks.getSuperblock(superblockHash);
3005     }
3006 }