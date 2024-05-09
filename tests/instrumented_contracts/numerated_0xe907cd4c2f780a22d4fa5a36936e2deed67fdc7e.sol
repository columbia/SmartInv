1 pragma solidity ^0.4.15;
2 
3 // File: contracts/BTC.sol
4 
5 // Bitcoin transaction parsing library
6 
7 // Copyright 2016 rain <https://keybase.io/rain>
8 //
9 // Licensed under the Apache License, Version 2.0 (the "License");
10 // you may not use this file except in compliance with the License.
11 // You may obtain a copy of the License at
12 //
13 //      http://www.apache.org/licenses/LICENSE-2.0
14 //
15 // Unless required by applicable law or agreed to in writing, software
16 // distributed under the License is distributed on an "AS IS" BASIS,
17 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18 // See the License for the specific language governing permissions and
19 // limitations under the License.
20 
21 // https://en.bitcoin.it/wiki/Protocol_documentation#tx
22 //
23 // Raw Bitcoin transaction structure:
24 //
25 // field     | size | type     | description
26 // version   | 4    | int32    | transaction version number
27 // n_tx_in   | 1-9  | var_int  | number of transaction inputs
28 // tx_in     | 41+  | tx_in[]  | list of transaction inputs
29 // n_tx_out  | 1-9  | var_int  | number of transaction outputs
30 // tx_out    | 9+   | tx_out[] | list of transaction outputs
31 // lock_time | 4    | uint32   | block number / timestamp at which tx locked
32 //
33 // Transaction input (tx_in) structure:
34 //
35 // field      | size | type     | description
36 // previous   | 36   | outpoint | Previous output transaction reference
37 // script_len | 1-9  | var_int  | Length of the signature script
38 // sig_script | ?    | uchar[]  | Script for confirming transaction authorization
39 // sequence   | 4    | uint32   | Sender transaction version
40 //
41 // OutPoint structure:
42 //
43 // field      | size | type     | description
44 // hash       | 32   | char[32] | The hash of the referenced transaction
45 // index      | 4    | uint32   | The index of this output in the referenced transaction
46 //
47 // Transaction output (tx_out) structure:
48 //
49 // field         | size | type     | description
50 // value         | 8    | int64    | Transaction value (Satoshis)
51 // pk_script_len | 1-9  | var_int  | Length of the public key script
52 // pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.
53 //
54 // Variable integers (var_int) can be encoded differently depending
55 // on the represented value, to save space. Variable integers always
56 // precede an array of a variable length data type (e.g. tx_in).
57 //
58 // Variable integer encodings as a function of represented value:
59 //
60 // value           | bytes  | format
61 // <0xFD (253)     | 1      | uint8
62 // <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16
63 // <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32
64 // -               | 9      | 0xFF followed by length as uint64
65 //
66 // Public key scripts `pk_script` are set on the output and can
67 // take a number of forms. The regular transaction script is
68 // called 'pay-to-pubkey-hash' (P2PKH):
69 //
70 // OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
71 //
72 // OP_x are Bitcoin script opcodes. The bytes representation (including
73 // the 0x14 20-byte stack push) is:
74 //
75 // 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC
76 //
77 // The <pubKeyHash> is the ripemd160 hash of the sha256 hash of
78 // the public key, preceded by a network version byte. (21 bytes total)
79 //
80 // Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)
81 //
82 // The Bitcoin address is derived from the pubKeyHash. The binary form is the
83 // pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes
84 // of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)
85 // This is converted to base58 to form the publicly used Bitcoin address.
86 // Mainnet P2PKH transaction scripts are to addresses beginning with '1'.
87 //
88 // P2SH ('pay to script hash') scripts only supply a script hash. The spender
89 // must then provide the script that would allow them to redeem this output.
90 // This allows for arbitrarily complex scripts to be funded using only a
91 // hash of the script, and moves the onus on providing the script from
92 // the spender to the redeemer.
93 //
94 // The P2SH script format is simple:
95 //
96 // OP_HASH160 <scriptHash> OP_EQUAL
97 //
98 // 0xA9 0x14 <scriptHash> 0x87
99 //
100 // The <scriptHash> is the ripemd160 hash of the sha256 hash of the
101 // redeem script. The P2SH address is derived from the scriptHash.
102 // Addresses are the scriptHash with a version prefix of 5, encoded as
103 // Base58check. These addresses begin with a '3'.
104 
105 pragma solidity ^0.4.11;
106 
107 // parse a raw bitcoin transaction byte array
108 library BTC {
109     // Convert a variable integer into something useful and return it and
110     // the index to after it.
111     function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {
112         // the first byte tells us how big the integer is
113         var ibit = uint8(txBytes[pos]);
114         pos += 1;  // skip ibit
115 
116         if (ibit < 0xfd) {
117             return (ibit, pos);
118         } else if (ibit == 0xfd) {
119             return (getBytesLE(txBytes, pos, 16), pos + 2);
120         } else if (ibit == 0xfe) {
121             return (getBytesLE(txBytes, pos, 32), pos + 4);
122         } else if (ibit == 0xff) {
123             return (getBytesLE(txBytes, pos, 64), pos + 8);
124         }
125     }
126     // convert little endian bytes to uint
127     function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {
128         if (bits == 8) {
129             return uint8(data[pos]);
130         } else if (bits == 16) {
131             return uint16(data[pos])
132                  + uint16(data[pos + 1]) * 2 ** 8;
133         } else if (bits == 32) {
134             return uint32(data[pos])
135                  + uint32(data[pos + 1]) * 2 ** 8
136                  + uint32(data[pos + 2]) * 2 ** 16
137                  + uint32(data[pos + 3]) * 2 ** 24;
138         } else if (bits == 64) {
139             return uint64(data[pos])
140                  + uint64(data[pos + 1]) * 2 ** 8
141                  + uint64(data[pos + 2]) * 2 ** 16
142                  + uint64(data[pos + 3]) * 2 ** 24
143                  + uint64(data[pos + 4]) * 2 ** 32
144                  + uint64(data[pos + 5]) * 2 ** 40
145                  + uint64(data[pos + 6]) * 2 ** 48
146                  + uint64(data[pos + 7]) * 2 ** 56;
147         }
148     }
149     // scan the full transaction bytes and return the first two output
150     // values (in satoshis) and addresses (in binary)
151     function getFirstTwoOutputs(bytes txBytes)
152              returns (uint, bytes20, uint, bytes20)
153     {
154         uint pos;
155         uint[] memory input_script_lens = new uint[](2);
156         uint[] memory output_script_lens = new uint[](2);
157         uint[] memory script_starts = new uint[](2);
158         uint[] memory output_values = new uint[](2);
159         bytes20[] memory output_addresses = new bytes20[](2);
160 
161         pos = 4;  // skip version
162 
163         (input_script_lens, pos) = scanInputs(txBytes, pos, 0);
164 
165         (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);
166 
167         for (uint i = 0; i < 2; i++) {
168             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
169             output_addresses[i] = pkhash;
170         }
171 
172         return (output_values[0], output_addresses[0],
173                 output_values[1], output_addresses[1]);
174     }
175     // Check whether `btcAddress` is in the transaction outputs *and*
176     // whether *at least* `value` has been sent to it.
177         // Check whether `btcAddress` is in the transaction outputs *and*
178     // whether *at least* `value` has been sent to it.
179     function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)
180              returns (bool,uint)
181     {
182         uint pos = 4;  // skip version
183         (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs
184 
185         // scan *all* the outputs and find where they are
186         var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);
187 
188         // look at each output and check whether it at least value to btcAddress
189         for (uint i = 0; i < output_values.length; i++) {
190             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
191             if (pkhash == btcAddress && output_values[i] >= value) {
192                 return (true,output_values[i]);
193             }
194         }
195     }
196     // scan the inputs and find the script lengths.
197     // return an array of script lengths and the end position
198     // of the inputs.
199     // takes a 'stop' argument which sets the maximum number of
200     // outputs to scan through. stop=0 => scan all.
201     function scanInputs(bytes txBytes, uint pos, uint stop)
202              returns (uint[], uint)
203     {
204         uint n_inputs;
205         uint halt;
206         uint script_len;
207 
208         (n_inputs, pos) = parseVarInt(txBytes, pos);
209 
210         if (stop == 0 || stop > n_inputs) {
211             halt = n_inputs;
212         } else {
213             halt = stop;
214         }
215 
216         uint[] memory script_lens = new uint[](halt);
217 
218         for (var i = 0; i < halt; i++) {
219             pos += 36;  // skip outpoint
220             (script_len, pos) = parseVarInt(txBytes, pos);
221             script_lens[i] = script_len;
222             pos += script_len + 4;  // skip sig_script, seq
223         }
224 
225         return (script_lens, pos);
226     }
227     // scan the outputs and find the values and script lengths.
228     // return array of values, array of script lengths and the
229     // end position of the outputs.
230     // takes a 'stop' argument which sets the maximum number of
231     // outputs to scan through. stop=0 => scan all.
232     function scanOutputs(bytes txBytes, uint pos, uint stop)
233              returns (uint[], uint[], uint[], uint)
234     {
235         uint n_outputs;
236         uint halt;
237         uint script_len;
238 
239         (n_outputs, pos) = parseVarInt(txBytes, pos);
240 
241         if (stop == 0 || stop > n_outputs) {
242             halt = n_outputs;
243         } else {
244             halt = stop;
245         }
246 
247         uint[] memory script_starts = new uint[](halt);
248         uint[] memory script_lens = new uint[](halt);
249         uint[] memory output_values = new uint[](halt);
250 
251         for (var i = 0; i < halt; i++) {
252             output_values[i] = getBytesLE(txBytes, pos, 64);
253             pos += 8;
254 
255             (script_len, pos) = parseVarInt(txBytes, pos);
256             script_starts[i] = pos;
257             script_lens[i] = script_len;
258             pos += script_len;
259         }
260 
261         return (output_values, script_starts, script_lens, pos);
262     }
263     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
264     function sliceBytes20(bytes data, uint start) returns (bytes20) {
265         uint160 slice = 0;
266         for (uint160 i = 0; i < 20; i++) {
267             slice += uint160(data[i + start]) << (8 * (19 - i));
268         }
269         return bytes20(slice);
270     }
271     // returns true if the bytes located in txBytes by pos and
272     // script_len represent a P2PKH script
273     function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {
274         return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script
275             && (txBytes[pos] == 0x76)       // OP_DUP
276             && (txBytes[pos + 1] == 0xa9)   // OP_HASH160
277             && (txBytes[pos + 2] == 0x14)   // bytes to push
278             && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY
279             && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG
280     }
281     // returns true if the bytes located in txBytes by pos and
282     // script_len represent a P2SH script
283     function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {
284         return (script_len == 23)           // 20 byte scripthash + 3 bytes of script
285             && (txBytes[pos + 0] == 0xa9)   // OP_HASH160
286             && (txBytes[pos + 1] == 0x14)   // bytes to push
287             && (txBytes[pos + 22] == 0x87); // OP_EQUAL
288     }
289     // Get the pubkeyhash / scripthash from an output script. Assumes
290     // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.
291     // Returns the pubkeyhash/ scripthash, or zero if unknown output.
292     function parseOutputScript(bytes txBytes, uint pos, uint script_len)
293              returns (bytes20)
294     {
295         if (isP2PKH(txBytes, pos, script_len)) {
296             return sliceBytes20(txBytes, pos + 3);
297         } else if (isP2SH(txBytes, pos, script_len)) {
298             return sliceBytes20(txBytes, pos + 2);
299         } else {
300             return;
301         }
302     }
303 }
304 
305 // File: contracts/Ownable.sol
306 
307 contract Ownable {
308   address public owner;
309 
310   function Ownable() {
311     owner = msg.sender;
312   }
313 
314   modifier onlyOwner() {
315     if (msg.sender == owner)
316       _;
317   }
318 
319   function transferOwnership(address newOwner) onlyOwner {
320     if (newOwner != address(0)) owner = newOwner;
321   }
322 
323 }
324 
325 // File: contracts/Pausable.sol
326 
327 /*
328  * Pausable
329  * Abstract contract that allows children to implement an
330  * emergency stop mechanism.
331  */
332 
333 contract Pausable is Ownable {
334   bool public stopped;
335 
336   modifier stopInEmergency {
337     if (stopped) {
338       throw;
339     }
340     _;
341   }
342 
343   modifier onlyInEmergency {
344     if (!stopped) {
345       throw;
346     }
347     _;
348   }
349 
350   // called by the owner on emergency, triggers stopped state
351   function emergencyStop() external onlyOwner {
352     stopped = true;
353   }
354 
355   // called by the owner on end of emergency, returns to normal state
356   function release() external onlyOwner onlyInEmergency {
357     stopped = false;
358   }
359 
360 }
361 
362 // File: contracts/SafeMath.sol
363 
364 /**
365  * Math operations with safety checks
366  */
367 contract SafeMath {
368   function safeMul(uint a, uint b) internal returns (uint) {
369     uint c = a * b;
370     assert(a == 0 || c / a == b);
371     return c;
372   }
373 
374   function safeDiv(uint a, uint b) internal returns (uint) {
375     assert(b > 0);
376     uint c = a / b;
377     assert(a == b * c + a % b);
378     return c;
379   }
380 
381   function safeSub(uint a, uint b) internal returns (uint) {
382     assert(b <= a);
383     return a - b;
384   }
385 
386   function safeAdd(uint a, uint b) internal returns (uint) {
387     uint c = a + b;
388     assert(c>=a && c>=b);
389     return c;
390   }
391 
392   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
393     return a >= b ? a : b;
394   }
395 
396   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
397     return a < b ? a : b;
398   }
399 
400   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
401     return a >= b ? a : b;
402   }
403 
404   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
405     return a < b ? a : b;
406   }
407 
408 }
409 
410 // File: contracts/StandardToken.sol
411 
412 contract Token {
413     uint256 public totalSupply;
414 
415     function balanceOf(address _owner) constant returns (uint256 balance);
416     function transfer(address _to, uint256 _value) returns (bool success);
417     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
418     function approve(address _spender, uint256 _value) returns (bool success);
419     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
420     event Transfer(address indexed _from, address indexed _to, uint256 _value);
421     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
422 }
423 
424 
425 /*  ERC 20 token */
426 contract StandardToken is Token {
427 
428     mapping (address => uint256) balances;
429     mapping (address => mapping (address => uint256)) allowed;
430 
431     function transfer(address _to, uint256 _value) returns (bool success) {
432       if (balances[msg.sender] >= _value && _value > 0) {
433         balances[msg.sender] -= _value;
434         balances[_to] += _value;
435         Transfer(msg.sender, _to, _value);
436         return true;
437         } else {
438             return false;
439         }
440     }
441 
442     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
443       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
444         balances[_to] += _value;
445         balances[_from] -= _value;
446         allowed[_from][msg.sender] -= _value;
447         Transfer(_from, _to, _value);
448         return true;
449         } else {
450             return false;
451         }
452     }
453 
454     function balanceOf(address _owner) constant returns (uint256 balance) {
455         return balances[_owner];
456     }
457 
458     function approve(address _spender, uint256 _value) returns (bool success) {
459         allowed[msg.sender][_spender] = _value;
460         Approval(msg.sender, _spender, _value);
461         return true;
462     }
463 
464     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
465       return allowed[_owner][_spender];
466   }
467 
468 
469 }
470 
471 // File: contracts/Utils.sol
472 
473 contract Utils{
474 
475 	//verifies the amount greater than zero
476 
477 	modifier greaterThanZero(uint256 _value){
478 		require(_value>0);
479 		_;
480 	}
481 
482 	///verifies an address
483 
484 	modifier validAddress(address _add){
485 		require(_add!=0x0);
486 		_;
487 	}
488 }
489 
490 // File: contracts/Crowdsale.sol
491 
492 contract Crowdsale is StandardToken, Pausable, SafeMath, Utils{
493 	string public constant name = "Mudra";
494 	string public constant symbol = "MUDRA";
495 	uint256 public constant decimals = 18;
496 	string public version = "1.0";
497 	bool public tradingStarted = false;
498 
499     /**
500    * @dev modifier that throws if trading has not started yet
501    */
502    modifier hasStartedTrading() {
503    	require(tradingStarted);
504    	_;
505    }
506   /**
507    * @dev Allows the owner to enable the trading. This can not be undone
508    */
509    function startTrading() onlyOwner() {
510    	tradingStarted = true;
511    }
512 
513    function transfer(address _to, uint _value) hasStartedTrading returns (bool success) {super.transfer(_to, _value);}
514 
515    function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool success) {super.transferFrom(_from, _to, _value);}
516 
517    enum State{
518    	Inactive,
519    	Funding,
520    	Success,
521    	Failure
522    }
523 
524    uint256 public investmentETH;
525    uint256 public investmentBTC;
526    mapping(uint256 => bool) transactionsClaimed;
527    uint256 public initialSupply;
528    address wallet;
529    uint256 public constant _totalSupply = 100 * (10**6) * 10 ** decimals; // 100M ~ 10 Crores
530    uint256 public fundingStartBlock; // crowdsale start block
531    uint256 public constant minBtcValue = 10000; // ~ approx 1$
532    uint256 public tokensPerEther = 450; // 1 ETH = 460 tokens
533    uint256 public tokensPerBTC = 140 * 10 ** 10 * 10 ** 2; // 1 btc = 11500 Tokens
534    uint256 public constant tokenCreationMax = 10 * (10**6) * 10 ** decimals; // 10M ~ 1 Crores
535    address[] public investors;
536 
537    //displays number of uniq investors
538    function investorsCount() constant external returns(uint) { return investors.length; }
539 
540    function Crowdsale(uint256 _fundingStartBlock, address _owner, address _wallet){
541       owner = _owner;
542       fundingStartBlock =_fundingStartBlock;
543       totalSupply = _totalSupply;
544       initialSupply = 0;
545       wallet = _wallet;
546 
547       //check configuration if something in setup is looking weird
548       if (
549         tokensPerEther == 0
550         || tokensPerBTC == 0
551         || owner == 0x0
552         || wallet == 0x0
553         || fundingStartBlock == 0
554         || totalSupply == 0
555         || tokenCreationMax == 0
556         || fundingStartBlock <= block.number)
557       throw;
558 
559    }
560 
561    // don't just send ether to the contract expecting to get tokens
562    //function() { throw; }
563    ////@dev This function manages the Crowdsale State machine
564    ///We make it a function and do not assign to a variable//
565    ///so that no chance of stale variable
566    function getState() constant public returns(State){
567    	///once we reach success lock the State
568    	if(block.number<fundingStartBlock) return State.Inactive;
569    	else if(block.number>fundingStartBlock && initialSupply<tokenCreationMax) return State.Funding;
570    	else if (initialSupply >= tokenCreationMax) return State.Success;
571    	else return State.Failure;
572    }
573 
574    ///get total tokens in that address mapping
575    function getTokens(address addr) public returns(uint256){
576    	return balances[addr];
577    }
578 
579    ///get the block number state
580    function getStateFunding() public returns (uint256){
581    	// average 6000 blocks mined in 24 hrs
582    	if(block.number<fundingStartBlock + 180000) return 20; // 1 month 20%
583    	else if(block.number>=fundingStartBlock+ 180001 && block.number<fundingStartBlock + 270000) return 10; // next 15 days
584    	else if(block.number>=fundingStartBlock + 270001 && block.number<fundingStartBlock + 36000) return 5; // next 15 days
585    	else return 0;
586    }
587    ///a function using safemath to work with
588    ///the new function
589    function calNewTokens(uint256 tokens) returns (uint256){
590    	uint256 disc = getStateFunding();
591    	tokens = safeAdd(tokens,safeDiv(safeMul(tokens,disc),100));
592    	return tokens;
593    }
594 
595    function() external payable stopInEmergency{
596    	// Abort if not in Funding Active state.
597    	if(getState() == State.Success) throw;
598    	if (msg.value == 0) throw;
599    	uint256 newCreatedTokens = safeMul(msg.value,tokensPerEther);
600    	newCreatedTokens = calNewTokens(newCreatedTokens);
601    	///since we are creating tokens we need to increase the total supply
602    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
603    	if(initialSupply>tokenCreationMax) throw;
604       if (balances[msg.sender] == 0) investors.push(msg.sender);
605       investmentETH += msg.value;
606       balances[msg.sender] = safeAdd(balances[msg.sender],newCreatedTokens);
607       // Pocket the money
608       if(!wallet.send(msg.value)) throw;
609    }
610 
611 
612    ///token distribution initial function for the one in the exchanges
613    ///to be done only the owner can run this function
614    function tokenAssignExchange(address addr,uint256 val)
615    external
616    stopInEmergency
617    onlyOwner()
618    {
619    	if(getState() == State.Success) throw;
620     if(addr == 0x0) throw;
621    	if (val == 0) throw;
622    	uint256 newCreatedTokens = safeMul(val,tokensPerEther);
623    	newCreatedTokens = calNewTokens(newCreatedTokens);
624    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
625    	if(initialSupply>tokenCreationMax) throw;
626       if (balances[addr] == 0) investors.push(addr);
627       investmentETH += val;
628       balances[addr] = safeAdd(balances[addr],newCreatedTokens);
629    }
630 
631    ///function to run when the transaction has been veified
632    function processTransaction(bytes txn, uint256 txHash,address addr,bytes20 btcaddr)
633    external
634    stopInEmergency
635    onlyOwner()
636    returns (uint)
637    {
638    	if(getState() == State.Success) throw;
639     if(addr == 0x0) throw;
640    	var (output1,output2,output3,output4) = BTC.getFirstTwoOutputs(txn);
641       if(transactionsClaimed[txHash]) throw;
642       var (a,b) = BTC.checkValueSent(txn,btcaddr,minBtcValue);
643       if(a){
644          transactionsClaimed[txHash] = true;
645          uint256 newCreatedTokens = safeMul(b,tokensPerBTC);
646          ///since we are creating tokens we need to increase the total supply
647          newCreatedTokens = calNewTokens(newCreatedTokens);
648          initialSupply = safeAdd(initialSupply,newCreatedTokens);
649          ///remember not to go off the LIMITS!!
650          if(initialSupply>tokenCreationMax) throw;
651          if (balances[addr] == 0) investors.push(addr);
652          investmentBTC += b;
653          balances[addr] = safeAdd(balances[addr],newCreatedTokens);
654          return 1;
655       }
656       else return 0;
657    }
658 
659    ///change exchange rate ~ update price everyday
660    function changeExchangeRate(uint256 eth, uint256 btc)
661    external
662    onlyOwner()
663    {
664      if(eth == 0 || btc == 0) throw;
665      tokensPerEther = eth;
666      tokensPerBTC = btc;
667   }
668 
669   ///blacklist the users which are fraudulent
670   ///from getting any tokens
671   ///to do also refund just in cases
672   function blacklist(address addr)
673   external
674   onlyOwner()
675   {
676      balances[addr] = 0;
677   }
678 
679 }