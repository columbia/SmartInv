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
105 // parse a raw bitcoin transaction byte array
106 library BTC {
107     // Convert a variable integer into something useful and return it and
108     // the index to after it.
109     function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {
110         // the first byte tells us how big the integer is
111         var ibit = uint8(txBytes[pos]);
112         pos += 1;  // skip ibit
113 
114         if (ibit < 0xfd) {
115             return (ibit, pos);
116         } else if (ibit == 0xfd) {
117             return (getBytesLE(txBytes, pos, 16), pos + 2);
118         } else if (ibit == 0xfe) {
119             return (getBytesLE(txBytes, pos, 32), pos + 4);
120         } else if (ibit == 0xff) {
121             return (getBytesLE(txBytes, pos, 64), pos + 8);
122         }
123     }
124     // convert little endian bytes to uint
125     function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {
126         if (bits == 8) {
127             return uint8(data[pos]);
128         } else if (bits == 16) {
129             return uint16(data[pos])
130                  + uint16(data[pos + 1]) * 2 ** 8;
131         } else if (bits == 32) {
132             return uint32(data[pos])
133                  + uint32(data[pos + 1]) * 2 ** 8
134                  + uint32(data[pos + 2]) * 2 ** 16
135                  + uint32(data[pos + 3]) * 2 ** 24;
136         } else if (bits == 64) {
137             return uint64(data[pos])
138                  + uint64(data[pos + 1]) * 2 ** 8
139                  + uint64(data[pos + 2]) * 2 ** 16
140                  + uint64(data[pos + 3]) * 2 ** 24
141                  + uint64(data[pos + 4]) * 2 ** 32
142                  + uint64(data[pos + 5]) * 2 ** 40
143                  + uint64(data[pos + 6]) * 2 ** 48
144                  + uint64(data[pos + 7]) * 2 ** 56;
145         }
146     }
147     // scan the full transaction bytes and return the first two output
148     // values (in satoshis) and addresses (in binary)
149     function getFirstTwoOutputs(bytes txBytes)
150              returns (uint, bytes20, uint, bytes20)
151     {
152         uint pos;
153         uint[] memory input_script_lens = new uint[](2);
154         uint[] memory output_script_lens = new uint[](2);
155         uint[] memory script_starts = new uint[](2);
156         uint[] memory output_values = new uint[](2);
157         bytes20[] memory output_addresses = new bytes20[](2);
158 
159         pos = 4;  // skip version
160 
161         (input_script_lens, pos) = scanInputs(txBytes, pos, 0);
162 
163         (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);
164 
165         for (uint i = 0; i < 2; i++) {
166             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
167             output_addresses[i] = pkhash;
168         }
169 
170         return (output_values[0], output_addresses[0],
171                 output_values[1], output_addresses[1]);
172     }
173     // Check whether `btcAddress` is in the transaction outputs *and*
174     // whether *at least* `value` has been sent to it.
175         // Check whether `btcAddress` is in the transaction outputs *and*
176     // whether *at least* `value` has been sent to it.
177     function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)
178              returns (bool,uint)
179     {
180         uint pos = 4;  // skip version
181         (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs
182 
183         // scan *all* the outputs and find where they are
184         var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);
185 
186         // look at each output and check whether it at least value to btcAddress
187         for (uint i = 0; i < output_values.length; i++) {
188             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
189             if (pkhash == btcAddress && output_values[i] >= value) {
190                 return (true,output_values[i]);
191             }
192         }
193     }
194     // scan the inputs and find the script lengths.
195     // return an array of script lengths and the end position
196     // of the inputs.
197     // takes a 'stop' argument which sets the maximum number of
198     // outputs to scan through. stop=0 => scan all.
199     function scanInputs(bytes txBytes, uint pos, uint stop)
200              returns (uint[], uint)
201     {
202         uint n_inputs;
203         uint halt;
204         uint script_len;
205 
206         (n_inputs, pos) = parseVarInt(txBytes, pos);
207 
208         if (stop == 0 || stop > n_inputs) {
209             halt = n_inputs;
210         } else {
211             halt = stop;
212         }
213 
214         uint[] memory script_lens = new uint[](halt);
215 
216         for (var i = 0; i < halt; i++) {
217             pos += 36;  // skip outpoint
218             (script_len, pos) = parseVarInt(txBytes, pos);
219             script_lens[i] = script_len;
220             pos += script_len + 4;  // skip sig_script, seq
221         }
222 
223         return (script_lens, pos);
224     }
225     // scan the outputs and find the values and script lengths.
226     // return array of values, array of script lengths and the
227     // end position of the outputs.
228     // takes a 'stop' argument which sets the maximum number of
229     // outputs to scan through. stop=0 => scan all.
230     function scanOutputs(bytes txBytes, uint pos, uint stop)
231              returns (uint[], uint[], uint[], uint)
232     {
233         uint n_outputs;
234         uint halt;
235         uint script_len;
236 
237         (n_outputs, pos) = parseVarInt(txBytes, pos);
238 
239         if (stop == 0 || stop > n_outputs) {
240             halt = n_outputs;
241         } else {
242             halt = stop;
243         }
244 
245         uint[] memory script_starts = new uint[](halt);
246         uint[] memory script_lens = new uint[](halt);
247         uint[] memory output_values = new uint[](halt);
248 
249         for (var i = 0; i < halt; i++) {
250             output_values[i] = getBytesLE(txBytes, pos, 64);
251             pos += 8;
252 
253             (script_len, pos) = parseVarInt(txBytes, pos);
254             script_starts[i] = pos;
255             script_lens[i] = script_len;
256             pos += script_len;
257         }
258 
259         return (output_values, script_starts, script_lens, pos);
260     }
261     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
262     function sliceBytes20(bytes data, uint start) returns (bytes20) {
263         uint160 slice = 0;
264         for (uint160 i = 0; i < 20; i++) {
265             slice += uint160(data[i + start]) << (8 * (19 - i));
266         }
267         return bytes20(slice);
268     }
269     // returns true if the bytes located in txBytes by pos and
270     // script_len represent a P2PKH script
271     function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {
272         return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script
273             && (txBytes[pos] == 0x76)       // OP_DUP
274             && (txBytes[pos + 1] == 0xa9)   // OP_HASH160
275             && (txBytes[pos + 2] == 0x14)   // bytes to push
276             && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY
277             && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG
278     }
279     // returns true if the bytes located in txBytes by pos and
280     // script_len represent a P2SH script
281     function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {
282         return (script_len == 23)           // 20 byte scripthash + 3 bytes of script
283             && (txBytes[pos + 0] == 0xa9)   // OP_HASH160
284             && (txBytes[pos + 1] == 0x14)   // bytes to push
285             && (txBytes[pos + 22] == 0x87); // OP_EQUAL
286     }
287     // Get the pubkeyhash / scripthash from an output script. Assumes
288     // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.
289     // Returns the pubkeyhash/ scripthash, or zero if unknown output.
290     function parseOutputScript(bytes txBytes, uint pos, uint script_len)
291              returns (bytes20)
292     {
293         if (isP2PKH(txBytes, pos, script_len)) {
294             return sliceBytes20(txBytes, pos + 3);
295         } else if (isP2SH(txBytes, pos, script_len)) {
296             return sliceBytes20(txBytes, pos + 2);
297         } else {
298             return;
299         }
300     }
301 }
302 
303 // File: contracts/Ownable.sol
304 
305 contract Ownable {
306   address public owner;
307   address public owner1;
308   address public owner2;
309   address public owner3;
310 
311   function Ownable() {
312     owner = msg.sender;
313   }
314 
315     function Ownable1() {
316     owner1 = msg.sender;
317   }
318 
319     function Ownable2() {
320     owner2 = msg.sender;
321   }
322 
323     function Ownable3() {
324     owner3 = msg.sender;
325   }
326 
327   modifier onlyOwner() {
328     if (msg.sender == owner)
329       _;
330   }
331 
332   modifier onlyOwner1() {
333     if (msg.sender == owner1)
334       _;
335   }
336 
337   modifier onlyOwner2() {
338     if (msg.sender == owner2)
339       _;
340   }
341 
342   modifier onlyOwner3() {
343     if (msg.sender == owner3)
344       _;
345   }
346 
347   function transferOwnership(address newOwner) onlyOwner {
348     if (newOwner != address(0)) owner = newOwner;
349   }
350 
351 }
352 
353 // File: contracts/Pausable.sol
354 
355 /*
356  * Pausable
357  * Abstract contract that allows children to implement an
358  * emergency stop mechanism.
359  */
360 
361 contract Pausable is Ownable {
362   bool public stopped;
363 
364   modifier stopInEmergency {
365     if (stopped) {
366       throw;
367     }
368     _;
369   }
370   
371   modifier onlyInEmergency {
372     if (!stopped) {
373       throw;
374     }
375     _;
376   }
377 
378   // called by the owner on emergency, triggers stopped state
379   function emergencyStop() external onlyOwner {
380     stopped = true;
381   }
382 
383   // called by the owner on end of emergency, returns to normal state
384   function release() external onlyOwner onlyInEmergency {
385     stopped = false;
386   }
387 
388 }
389 
390 // File: contracts/SafeMath.sol
391 
392 /**
393  * Math operations with safety checks
394  */
395 contract SafeMath {
396   function safeMul(uint a, uint b) internal returns (uint) {
397     uint c = a * b;
398     assert(a == 0 || c / a == b);
399     return c;
400   }
401 
402   function safeDiv(uint a, uint b) internal returns (uint) {
403     assert(b > 0);
404     uint c = a / b;
405     assert(a == b * c + a % b);
406     return c;
407   }
408 
409   function safeSub(uint a, uint b) internal returns (uint) {
410     assert(b <= a);
411     return a - b;
412   }
413 
414   function safeAdd(uint a, uint b) internal returns (uint) {
415     uint c = a + b;
416     assert(c>=a && c>=b);
417     return c;
418   }
419 
420   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
421     return a >= b ? a : b;
422   }
423 
424   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
425     return a < b ? a : b;
426   }
427 
428   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
429     return a >= b ? a : b;
430   }
431 
432   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
433     return a < b ? a : b;
434   }
435 
436 }
437 
438 // File: contracts/StandardToken.sol
439 
440 contract Token {
441     uint256 public totalSupply;
442 
443     function balanceOf(address _owner) constant returns (uint256 balance);
444     function transfer(address _to, uint256 _value) returns (bool success);
445     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
446     function approve(address _spender, uint256 _value) returns (bool success);
447     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
448     event Transfer(address indexed _from, address indexed _to, uint256 _value);
449     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
450 }
451 
452 
453 /*  ERC 20 token */
454 contract StandardToken is Token {
455 
456     mapping (address => uint256) balances;
457     mapping (address => mapping (address => uint256)) allowed;
458 
459     function transfer(address _to, uint256 _value) returns (bool success) {
460       if (balances[msg.sender] >= _value && _value > 0) {
461         balances[msg.sender] -= _value;
462         balances[_to] += _value;
463         Transfer(msg.sender, _to, _value);
464         return true;
465         } else {
466             return false;
467         }
468     }
469 
470     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
471       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
472         balances[_to] += _value;
473         balances[_from] -= _value;
474         allowed[_from][msg.sender] -= _value;
475         Transfer(_from, _to, _value);
476         return true;
477         } else {
478             return false;
479         }
480     }
481 
482     function balanceOf(address _owner) constant returns (uint256 balance) {
483         return balances[_owner];
484     }
485 
486     function approve(address _spender, uint256 _value) returns (bool success) {
487         allowed[msg.sender][_spender] = _value;
488         Approval(msg.sender, _spender, _value);
489         return true;
490     }
491 
492     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
493       return allowed[_owner][_spender];
494   }
495 
496 
497 }
498 
499 // File: contracts/Utils.sol
500 
501 contract Utils{
502 
503 	//verifies the amount greater than zero
504 
505 	modifier greaterThanZero(uint256 _value){
506 		require(_value>0);
507 		_;
508 	}
509 
510 	///verifies an address
511 
512 	modifier validAddress(address _add){
513 		require(_add!=0x0);
514 		_;
515 	}
516 }
517 
518 // File: contracts/Crowdsale.sol
519 
520 contract Crowdsale is StandardToken, Pausable, SafeMath, Utils{
521 	string public constant name = "Mudra";
522 	string public constant symbol = "MDR";
523 	uint256 public constant decimals = 18;
524 	string public version = "1.0";
525 	bool public tradingStarted = false;
526 
527     /**
528    * @dev modifier that throws if trading has not started yet
529    */
530    modifier hasStartedTrading() {
531    	require(tradingStarted);
532    	_;
533    }
534   /**
535    * @dev Allows the owner to enable the trading. This can not be undone
536    */
537    function startTrading() only(finalOwner) {
538    	tradingStarted = true;
539    }
540 
541    function transfer(address _to, uint _value) hasStartedTrading returns (bool success) {super.transfer(_to, _value);}
542 
543    function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns (bool success) {super.transferFrom(_from, _to, _value);}
544 
545    enum State{
546    	Inactive,
547    	Funding,
548    	Success,
549    	Failure
550    }
551 
552    modifier only(address allowed) {
553    	if (msg.sender != allowed) throw;
554    	_;
555    }
556 
557    uint256 public investmentETH;
558    uint256 public investmentBTC;
559    mapping(uint256 => bool) transactionsClaimed;
560    uint256 public initialSupply;
561    address finalOwner;
562    address wallet;
563    uint256 public constant _totalSupply = 100 * (10**6) * 10 ** decimals; // 100M ~ 10 Crores
564    uint256 public fundingStartBlock; // crowdsale start block
565    uint256 public constant minBtcValue = 10000; // ~ approx 1$
566    uint256 public tokensPerEther = 460; // 1 ETH = 460 tokens
567    uint256 public tokensPerBTC = 115 * 10 ** 10 * 10 ** 2; // 1 btc = 11500 Tokens
568    uint256 public constant tokenCreationMax = 10 * (10**6) * 10 ** decimals; // 10M ~ 1 Crores
569    address[] public investors;
570 
571    //displays number of uniq investors
572    function investorsCount() constant external returns(uint) { return investors.length; }
573 
574    function Crowdsale(uint256 _fundingStartBlock,address owner,address _wallet){
575    	owner = msg.sender;
576    	fundingStartBlock =_fundingStartBlock;
577    	totalSupply = _totalSupply;
578    	initialSupply = 0;
579    	finalOwner = owner;
580       wallet = _wallet;
581 
582       //check configuration if something in setup is looking weird
583       if (
584        tokensPerEther == 0
585        || tokensPerBTC == 0
586        || finalOwner == 0x0
587        || wallet == 0x0
588        || fundingStartBlock == 0
589        || totalSupply == 0
590        || tokenCreationMax == 0
591        || fundingStartBlock <= block.number)
592       throw;
593 
594    }
595 
596    // don't just send ether to the contract expecting to get tokens
597    //function() { throw; }
598    ////@dev This function manages the Crowdsale State machine
599    ///We make it a function and do not assign to a variable//
600    ///so that no chance of stale variable
601    function getState() constant public returns(State){
602    	///once we reach success lock the State
603    	if(block.number<fundingStartBlock) return State.Inactive;
604    	else if(block.number>fundingStartBlock && initialSupply<tokenCreationMax) return State.Funding;
605    	else if (initialSupply >= tokenCreationMax) return State.Success;
606    	else return State.Failure;
607    }
608 
609    ///get total tokens in that address mapping
610    function getTokens(address addr) public returns(uint256){
611    	return balances[addr];
612    }
613 
614    ///get the block number state
615    function getStateFunding() public returns (uint256){
616    	// average 6000 blocks mined in 24 hrs
617    	if(block.number<fundingStartBlock + 180000) return 20; // 1 month 20%
618    	else if(block.number>=fundingStartBlock+ 180001 && block.number<fundingStartBlock + 270000) return 10; // next 15 days
619    	else if(block.number>=fundingStartBlock + 270001 && block.number<fundingStartBlock + 36000) return 5; // next 15 days
620    	else return 0;
621    }
622    ///a function using safemath to work with
623    ///the new function
624    function calNewTokens(uint256 tokens) returns (uint256){
625    	uint256 disc = getStateFunding();
626    	tokens = safeAdd(tokens,safeDiv(safeMul(tokens,disc),100));
627    	return tokens;
628    }
629 
630    function() external payable stopInEmergency{
631    	// Abort if not in Funding Active state.
632    	if(getState() == State.Success) throw;
633    	if (msg.value == 0) throw;
634    	uint256 newCreatedTokens = safeMul(msg.value,tokensPerEther);
635    	newCreatedTokens = calNewTokens(newCreatedTokens);
636    	///since we are creating tokens we need to increase the total supply
637    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
638    	if(initialSupply>tokenCreationMax) throw;
639       if (balances[msg.sender] == 0) investors.push(msg.sender);
640       investmentETH += msg.value;
641       balances[msg.sender] = safeAdd(balances[msg.sender],newCreatedTokens);
642       // Pocket the money
643       if(!wallet.send(msg.value)) throw;
644    }
645 
646 
647    ///token distribution initial function for the one in the exchanges
648    ///to be done only the owner can run this function
649    function tokenAssignExchange(address addr,uint256 val)
650    external
651    only(finalOwner)
652    {
653    	if(getState() == State.Success) throw;
654    	if (val == 0) throw;
655    	uint256 newCreatedTokens = safeMul(val,tokensPerEther);
656    	newCreatedTokens = calNewTokens(newCreatedTokens);
657    	initialSupply = safeAdd(initialSupply,newCreatedTokens);
658    	if(initialSupply>tokenCreationMax) throw;
659       if (balances[addr] == 0) investors.push(addr);
660       investmentETH += val;
661       balances[addr] = safeAdd(balances[addr],newCreatedTokens);
662    }
663 
664    ///function to run when the transaction has been veified
665    function processTransaction(bytes txn, uint256 txHash,address addr,bytes20 btcaddr)
666    external
667    only(finalOwner)
668    returns (uint)
669    {
670    	if(getState() == State.Success) throw;
671    	var (output1,output2,output3,output4) = BTC.getFirstTwoOutputs(txn);
672       if(transactionsClaimed[txHash]) throw;
673       var (a,b) = BTC.checkValueSent(txn,btcaddr,minBtcValue);
674       if(a){
675          transactionsClaimed[txHash] = true;
676          uint256 newCreatedTokens = safeMul(b,tokensPerBTC);
677          ///since we are creating tokens we need to increase the total supply
678          newCreatedTokens = calNewTokens(newCreatedTokens);
679          initialSupply = safeAdd(initialSupply,newCreatedTokens);
680          ///remember not to go off the LIMITS!!
681          if(initialSupply>tokenCreationMax) throw;
682          if (balances[addr] == 0) investors.push(addr);
683          investmentBTC += b;
684          balances[addr] = safeAdd(balances[addr],newCreatedTokens);
685          return 1;
686       }
687       else return 0;
688    }
689 
690    ///change exchange rate
691    function changeExchangeRate(uint256 eth, uint256 btc)
692    external
693    only(finalOwner)
694    {
695     if(eth == 0 || btc == 0) throw;
696     tokensPerEther = eth;
697     tokensPerBTC = btc;
698  }
699 
700  ///blacklist the users which are fraudulent
701  ///from getting any tokens
702  ///to do also refund just in cases
703  function blacklist(address addr)
704  external
705  only(finalOwner)
706  {
707     balances[addr] = 0;
708  }
709 
710 }