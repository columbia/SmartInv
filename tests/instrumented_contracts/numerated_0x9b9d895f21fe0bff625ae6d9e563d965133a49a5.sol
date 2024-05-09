1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 contract Sales{
48 
49 	enum ICOSaleState{
50 		PrivateSale,
51 	    PreSale,
52 	    PublicSale,
53 	    Success,
54 	    Failed
55 	 }
56 }
57 
58 contract Utils{
59 
60 	//verifies the amount greater than zero
61 
62 	modifier greaterThanZero(uint256 _value){
63 		require(_value>0);
64 		_;
65 	}
66 
67 	///verifies an address
68 
69 	modifier validAddress(address _add){
70 		require(_add!=0x0);
71 		_;
72 	}
73 }
74 
75 
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 contract Token {
86     uint256 public totalSupply;
87     function balanceOf(address _owner) constant returns (uint256 balance);
88     function transfer(address _to, uint256 _value) returns (bool success);
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
90     function approve(address _spender, uint256 _value) returns (bool success);
91     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
92     event Transfer(address indexed _from, address indexed _to, uint256 _value);
93     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 
96 
97 /*  ERC 20 token */
98 contract GACToken is Token,Ownable,Sales {
99     string public constant name = "Gladage Care Token";
100     string public constant symbol = "GAC";
101     uint256 public constant decimals = 18;
102     string public version = "1.0";
103     uint public valueToBeSent = 1;
104 
105     bool public finalizedICO = false;
106 
107     uint256 public ethraised;
108     uint256 public btcraised;
109     uint256 public usdraised;
110 
111     bool public istransferAllowed;
112 
113     uint256 public constant GACFund = 5 * (10**8) * 10**decimals; 
114     uint256 public fundingStartBlock; // crowdsale start unix //now
115     uint256 public fundingEndBlock; // crowdsale end unix //1530403200 //07/01/2018 @ 12:00am (UTC)
116     uint256 public tokenCreationMax= 275 * (10**6) * 10**decimals;//TODO
117     mapping (address => bool) ownership;
118     uint256 public minCapUSD = 2000000;
119     uint256 public maxCapUSD = 20000000;
120 
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     modifier onlyPayloadSize(uint size) {
126         require(msg.data.length >= size + 4);
127         _;
128     }
129 
130     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
131       if(!istransferAllowed) throw;
132       if (balances[msg.sender] >= _value && _value > 0) {
133         balances[msg.sender] -= _value;
134         balances[_to] += _value;
135         Transfer(msg.sender, _to, _value);
136         return true;
137       } else {
138         return false;
139       }
140     }
141 
142     function burnTokens(uint256 _value) public{
143         require(balances[msg.sender]>=_value);
144         balances[msg.sender] = SafeMath.sub(balances[msg.sender],_value);
145         totalSupply =SafeMath.sub(totalSupply,_value);
146     }
147 
148 
149     //this is the default constructor
150     function GACToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){
151         totalSupply = GACFund;
152         fundingStartBlock = _fundingStartBlock;
153         fundingEndBlock = _fundingEndBlock;
154     }
155 
156     ///change the funding end block
157     function changeEndBlock(uint256 _newFundingEndBlock) onlyOwner{
158         fundingEndBlock = _newFundingEndBlock;
159     }
160 
161     ///change the funding start block
162     function changeStartBlock(uint256 _newFundingStartBlock) onlyOwner{
163         fundingStartBlock = _newFundingStartBlock;
164     }
165 
166     ///the Min Cap USD 
167     ///function too chage the miin cap usd
168     function changeMinCapUSD(uint256 _newMinCap) onlyOwner{
169         minCapUSD = _newMinCap;
170     }
171 
172     ///fucntion to change the max cap usd
173     function changeMaxCapUSD(uint256 _newMaxCap) onlyOwner{
174         maxCapUSD = _newMaxCap;
175     }
176 
177 
178     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
179       if(!istransferAllowed) throw;
180       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
181         balances[_to] += _value;
182         balances[_from] -= _value;
183         allowed[_from][msg.sender] -= _value;
184         Transfer(_from, _to, _value);
185         return true;
186       } else {
187         return false;
188       }
189     }
190 
191 
192     function addToBalances(address _person,uint256 value) {
193         if(!ownership[msg.sender]) throw;
194         balances[_person] = SafeMath.add(balances[_person],value);
195         Transfer(address(this), _person, value);
196     }
197 
198     function addToOwnership(address owners) onlyOwner{
199         ownership[owners] = true;
200     }
201 
202     function balanceOf(address _owner) constant returns (uint256 balance) {
203         return balances[_owner];
204     }
205 
206     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
207         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
214       return allowed[_owner][_spender];
215     }
216 
217     function increaseEthRaised(uint256 value){
218         if(!ownership[msg.sender]) throw;
219         ethraised+=value;
220     }
221 
222     function increaseBTCRaised(uint256 value){
223         if(!ownership[msg.sender]) throw;
224         btcraised+=value;
225     }
226 
227     function increaseUSDRaised(uint256 value){
228         if(!ownership[msg.sender]) throw;
229         usdraised+=value;
230     }
231 
232     function finalizeICO(){
233         if(!ownership[msg.sender]) throw;
234         ///replace the below amount of 10000 with the min cap usd value
235         ///havent recieved the valus yet :(
236         if(usdraised<minCapUSD) throw;
237         finalizedICO = true;
238         istransferAllowed = true;
239     }
240 
241     function enableTransfers() public onlyOwner{
242         istransferAllowed = true;
243     }
244 
245     function disableTransfers() public onlyOwner{
246         istransferAllowed = false;
247     }
248 
249     //functiion to force finalize the ICO by the owner no checks called here
250     function finalizeICOOwner() onlyOwner{
251         finalizedICO = true;
252         istransferAllowed = true;
253     }
254 
255     function isValid() returns(bool){
256         if(now>=fundingStartBlock && now<fundingEndBlock ){
257             return true;
258         }else{
259             return false;
260         }
261         if(usdraised>maxCapUSD) throw;
262     }
263 
264     ///do not allow payments on this address
265 
266     function() payable{
267         throw;
268     }
269 }
270 
271 
272 
273 
274 
275 
276 
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   modifier stopInEmergency {
306     if (paused) {
307       throw;
308     }
309     _;
310   }
311 
312   /**
313    * @dev called by the owner to pause, triggers stopped state
314    */
315   function pause() onlyOwner whenNotPaused public {
316     paused = true;
317     Pause();
318   }
319 
320   /**
321    * @dev called by the owner to unpause, returns to normal state
322    */
323   function unpause() onlyOwner whenPaused public {
324     paused = false;
325     Unpause();
326   }
327 }
328 // Bitcoin transaction parsing library
329 
330 // Copyright 2016 rain <https://keybase.io/rain>
331 //
332 // Licensed under the Apache License, Version 2.0 (the "License");
333 // you may not use this file except in compliance with the License.
334 // You may obtain a copy of the License at
335 //
336 //      http://www.apache.org/licenses/LICENSE-2.0
337 //
338 // Unless required by applicable law or agreed to in writing, software
339 // distributed under the License is distributed on an "AS IS" BASIS,
340 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
341 // See the License for the specific language governing permissions and
342 // limitations under the License.
343 
344 // https://en.bitcoin.it/wiki/Protocol_documentation#tx
345 //
346 // Raw Bitcoin transaction structure:
347 //
348 // field     | size | type     | description
349 // version   | 4    | int32    | transaction version number
350 // n_tx_in   | 1-9  | var_int  | number of transaction inputs
351 // tx_in     | 41+  | tx_in[]  | list of transaction inputs
352 // n_tx_out  | 1-9  | var_int  | number of transaction outputs
353 // tx_out    | 9+   | tx_out[] | list of transaction outputs
354 // lock_time | 4    | uint32   | block number / timestamp at which tx locked
355 //
356 // Transaction input (tx_in) structure:
357 //
358 // field      | size | type     | description
359 // previous   | 36   | outpoint | Previous output transaction reference
360 // script_len | 1-9  | var_int  | Length of the signature script
361 // sig_script | ?    | uchar[]  | Script for confirming transaction authorization
362 // sequence   | 4    | uint32   | Sender transaction version
363 //
364 // OutPoint structure:
365 //
366 // field      | size | type     | description
367 // hash       | 32   | char[32] | The hash of the referenced transaction
368 // index      | 4    | uint32   | The index of this output in the referenced transaction
369 //
370 // Transaction output (tx_out) structure:
371 //
372 // field         | size | type     | description
373 // value         | 8    | int64    | Transaction value (Satoshis)
374 // pk_script_len | 1-9  | var_int  | Length of the public key script
375 // pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.
376 //
377 // Variable integers (var_int) can be encoded differently depending
378 // on the represented value, to save space. Variable integers always
379 // precede an array of a variable length data type (e.g. tx_in).
380 //
381 // Variable integer encodings as a function of represented value:
382 //
383 // value           | bytes  | format
384 // <0xFD (253)     | 1      | uint8
385 // <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16
386 // <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32
387 // -               | 9      | 0xFF followed by length as uint64
388 //
389 // Public key scripts `pk_script` are set on the output and can
390 // take a number of forms. The regular transaction script is
391 // called 'pay-to-pubkey-hash' (P2PKH):
392 //
393 // OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
394 //
395 // OP_x are Bitcoin script opcodes. The bytes representation (including
396 // the 0x14 20-byte stack push) is:
397 //
398 // 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC
399 //
400 // The <pubKeyHash> is the ripemd160 hash of the sha256 hash of
401 // the public key, preceded by a network version byte. (21 bytes total)
402 //
403 // Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)
404 //
405 // The Bitcoin address is derived from the pubKeyHash. The binary form is the
406 // pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes
407 // of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)
408 // This is converted to base58 to form the publicly used Bitcoin address.
409 // Mainnet P2PKH transaction scripts are to addresses beginning with '1'.
410 //
411 // P2SH ('pay to script hash') scripts only supply a script hash. The spender
412 // must then provide the script that would allow them to redeem this output.
413 // This allows for arbitrarily complex scripts to be funded using only a
414 // hash of the script, and moves the onus on providing the script from
415 // the spender to the redeemer.
416 //
417 // The P2SH script format is simple:
418 //
419 // OP_HASH160 <scriptHash> OP_EQUAL
420 //
421 // 0xA9 0x14 <scriptHash> 0x87
422 //
423 // The <scriptHash> is the ripemd160 hash of the sha256 hash of the
424 // redeem script. The P2SH address is derived from the scriptHash.
425 // Addresses are the scriptHash with a version prefix of 5, encoded as
426 // Base58check. These addresses begin with a '3'.
427 
428 
429 
430 // parse a raw bitcoin transaction byte array
431 library BTC {
432     // Convert a variable integer into something useful and return it and
433     // the index to after it.
434     function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {
435         // the first byte tells us how big the integer is
436         var ibit = uint8(txBytes[pos]);
437         pos += 1;  // skip ibit
438 
439         if (ibit < 0xfd) {
440             return (ibit, pos);
441         } else if (ibit == 0xfd) {
442             return (getBytesLE(txBytes, pos, 16), pos + 2);
443         } else if (ibit == 0xfe) {
444             return (getBytesLE(txBytes, pos, 32), pos + 4);
445         } else if (ibit == 0xff) {
446             return (getBytesLE(txBytes, pos, 64), pos + 8);
447         }
448     }
449     // convert little endian bytes to uint
450     function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {
451         if (bits == 8) {
452             return uint8(data[pos]);
453         } else if (bits == 16) {
454             return uint16(data[pos])
455                  + uint16(data[pos + 1]) * 2 ** 8;
456         } else if (bits == 32) {
457             return uint32(data[pos])
458                  + uint32(data[pos + 1]) * 2 ** 8
459                  + uint32(data[pos + 2]) * 2 ** 16
460                  + uint32(data[pos + 3]) * 2 ** 24;
461         } else if (bits == 64) {
462             return uint64(data[pos])
463                  + uint64(data[pos + 1]) * 2 ** 8
464                  + uint64(data[pos + 2]) * 2 ** 16
465                  + uint64(data[pos + 3]) * 2 ** 24
466                  + uint64(data[pos + 4]) * 2 ** 32
467                  + uint64(data[pos + 5]) * 2 ** 40
468                  + uint64(data[pos + 6]) * 2 ** 48
469                  + uint64(data[pos + 7]) * 2 ** 56;
470         }
471     }
472     // scan the full transaction bytes and return the first two output
473     // values (in satoshis) and addresses (in binary)
474     function getFirstTwoOutputs(bytes txBytes)
475              returns (uint, bytes20, uint, bytes20)
476     {
477         uint pos;
478         uint[] memory input_script_lens = new uint[](2);
479         uint[] memory output_script_lens = new uint[](2);
480         uint[] memory script_starts = new uint[](2);
481         uint[] memory output_values = new uint[](2);
482         bytes20[] memory output_addresses = new bytes20[](2);
483 
484         pos = 4;  // skip version
485 
486         (input_script_lens, pos) = scanInputs(txBytes, pos, 0);
487 
488         (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);
489 
490         for (uint i = 0; i < 2; i++) {
491             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
492             output_addresses[i] = pkhash;
493         }
494 
495         return (output_values[0], output_addresses[0],
496                 output_values[1], output_addresses[1]);
497     }
498     // Check whether `btcAddress` is in the transaction outputs *and*
499     // whether *at least* `value` has been sent to it.
500         // Check whether `btcAddress` is in the transaction outputs *and*
501     // whether *at least* `value` has been sent to it.
502     function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)
503              returns (bool,uint)
504     {
505         uint pos = 4;  // skip version
506         (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs
507 
508         // scan *all* the outputs and find where they are
509         var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);
510 
511         // look at each output and check whether it at least value to btcAddress
512         for (uint i = 0; i < output_values.length; i++) {
513             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
514             if (pkhash == btcAddress && output_values[i] >= value) {
515                 return (true,output_values[i]);
516             }
517         }
518     }
519     // scan the inputs and find the script lengths.
520     // return an array of script lengths and the end position
521     // of the inputs.
522     // takes a 'stop' argument which sets the maximum number of
523     // outputs to scan through. stop=0 => scan all.
524     function scanInputs(bytes txBytes, uint pos, uint stop)
525              returns (uint[], uint)
526     {
527         uint n_inputs;
528         uint halt;
529         uint script_len;
530 
531         (n_inputs, pos) = parseVarInt(txBytes, pos);
532 
533         if (stop == 0 || stop > n_inputs) {
534             halt = n_inputs;
535         } else {
536             halt = stop;
537         }
538 
539         uint[] memory script_lens = new uint[](halt);
540 
541         for (var i = 0; i < halt; i++) {
542             pos += 36;  // skip outpoint
543             (script_len, pos) = parseVarInt(txBytes, pos);
544             script_lens[i] = script_len;
545             pos += script_len + 4;  // skip sig_script, seq
546         }
547 
548         return (script_lens, pos);
549     }
550     // scan the outputs and find the values and script lengths.
551     // return array of values, array of script lengths and the
552     // end position of the outputs.
553     // takes a 'stop' argument which sets the maximum number of
554     // outputs to scan through. stop=0 => scan all.
555     function scanOutputs(bytes txBytes, uint pos, uint stop)
556              returns (uint[], uint[], uint[], uint)
557     {
558         uint n_outputs;
559         uint halt;
560         uint script_len;
561 
562         (n_outputs, pos) = parseVarInt(txBytes, pos);
563 
564         if (stop == 0 || stop > n_outputs) {
565             halt = n_outputs;
566         } else {
567             halt = stop;
568         }
569 
570         uint[] memory script_starts = new uint[](halt);
571         uint[] memory script_lens = new uint[](halt);
572         uint[] memory output_values = new uint[](halt);
573 
574         for (var i = 0; i < halt; i++) {
575             output_values[i] = getBytesLE(txBytes, pos, 64);
576             pos += 8;
577 
578             (script_len, pos) = parseVarInt(txBytes, pos);
579             script_starts[i] = pos;
580             script_lens[i] = script_len;
581             pos += script_len;
582         }
583 
584         return (output_values, script_starts, script_lens, pos);
585     }
586     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
587     function sliceBytes20(bytes data, uint start) returns (bytes20) {
588         uint160 slice = 0;
589         for (uint160 i = 0; i < 20; i++) {
590             slice += uint160(data[i + start]) << (8 * (19 - i));
591         }
592         return bytes20(slice);
593     }
594     // returns true if the bytes located in txBytes by pos and
595     // script_len represent a P2PKH script
596     function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {
597         return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script
598             && (txBytes[pos] == 0x76)       // OP_DUP
599             && (txBytes[pos + 1] == 0xa9)   // OP_HASH160
600             && (txBytes[pos + 2] == 0x14)   // bytes to push
601             && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY
602             && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG
603     }
604     // returns true if the bytes located in txBytes by pos and
605     // script_len represent a P2SH script
606     function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {
607         return (script_len == 23)           // 20 byte scripthash + 3 bytes of script
608             && (txBytes[pos + 0] == 0xa9)   // OP_HASH160
609             && (txBytes[pos + 1] == 0x14)   // bytes to push
610             && (txBytes[pos + 22] == 0x87); // OP_EQUAL
611     }
612     // Get the pubkeyhash / scripthash from an output script. Assumes
613     // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.
614     // Returns the pubkeyhash/ scripthash, or zero if unknown output.
615     function parseOutputScript(bytes txBytes, uint pos, uint script_len)
616              returns (bytes20)
617     {
618         if (isP2PKH(txBytes, pos, script_len)) {
619             return sliceBytes20(txBytes, pos + 3);
620         } else if (isP2SH(txBytes, pos, script_len)) {
621             return sliceBytes20(txBytes, pos + 2);
622         } else {
623             return;
624         }
625     }
626 }
627 
628 
629 
630 
631 /**
632  * @title SafeMath
633  * @dev Math operations with safety checks that throw on error
634  */
635 library SafeMath {
636   function mul(uint256 a, uint256 b) internal returns (uint256) {
637     if (a == 0) {
638       return 0;
639     }
640     uint256 c = a * b;
641     assert(c / a == b);
642     return c;
643   }
644 
645   function div(uint256 a, uint256 b) internal returns (uint256) {
646     // assert(b > 0); // Solidity automatically throws when dividing by 0
647     uint256 c = a / b;
648     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
649     return c;
650   }
651 
652   function sub(uint256 a, uint256 b) internal returns (uint256) {
653     assert(b <= a);
654     return a - b;
655   }
656 
657   function add(uint256 a, uint256 b) internal returns (uint256) {
658     uint256 c = a + b;
659     assert(c >= a);
660     return c;
661   }
662 }
663 
664 
665 
666 
667 contract PricingStrategy is Ownable{
668     uint public ETHUSD=580;
669     uint public BTCUSD=9000;
670     uint256 public exchangeRate;
671     bool public called;
672     
673     function getLatest(uint btcusd,uint ethusd) onlyOwner{
674         ETHUSD = ethusd;
675         BTCUSD = btcusd;
676     }
677 
678 
679     uint256 public bonuspercentageprivate = 50;
680     uint256 public bonuspercentagepresale = 25;
681     uint256 public bonuspercentagepublic  = 0;
682 
683     function changeprivatebonus(uint256 _value) public onlyOwner{
684         bonuspercentageprivate = _value;
685     }
686 
687     function changepublicbonus(uint256 _value) public onlyOwner{
688         bonuspercentagepresale = _value;
689     }
690 
691     function changepresalebonus(uint256 _value) public onlyOwner{
692         bonuspercentagepublic = _value;
693     }
694 
695     uint256 public mincontribprivatesale = 15000;
696     uint256 public mincontribpresale = 1000;
697     uint256 public mincontribpublicsale = 0;
698 
699     function changeminprivatesale(uint256 _value) public onlyOwner{
700         mincontribprivatesale = _value;
701     }
702 
703     function changeminpresale(uint256 _value) public onlyOwner{
704         mincontribpresale = _value;
705     }
706 
707     function changeminpublicsale(uint256 _value) public onlyOwner{
708         mincontribpublicsale = _value;
709     }
710 
711 
712     ///log the value to get the value in usd
713     event logval(uint256 s);
714 
715     function totalDiscount(Sales.ICOSaleState state,uint256 contribution,string types) returns (uint256,uint256){
716         uint256 valueInUSD;
717         if(keccak256(types)==keccak256("ethereum")){
718             if(ETHUSD==0) throw;
719             valueInUSD = (ETHUSD*contribution)/1000000000000000000;
720             logval(valueInUSD);
721 
722         }else if(keccak256(types)==keccak256("bitcoin")){
723             if(BTCUSD==0) throw;
724             valueInUSD = (BTCUSD*contribution)/100000000;
725             logval(valueInUSD);
726 
727         }
728         if(state==Sales.ICOSaleState.PrivateSale){
729             if(valueInUSD<mincontribprivatesale) throw;
730             return (bonuspercentageprivate,valueInUSD);
731         }else if(state==Sales.ICOSaleState.PreSale){
732             if(valueInUSD<mincontribpresale) throw;
733             return (bonuspercentagepresale,valueInUSD);
734         }else if(state==Sales.ICOSaleState.PublicSale){
735             if(valueInUSD>=mincontribpublicsale) throw;
736             return (bonuspercentagepublic,valueInUSD);
737         }
738         else{
739             return (0,0);
740         }
741     }
742     
743     function() payable{
744         
745     }
746 }
747 
748 
749 ///////https://ethereum.stackexchange.com/questions/11383/oracle-oraclize-it-with-truffle-and-testrpc
750 
751 ////https://ethereum.stackexchange.com/questions/17015/regarding-oraclize-call-in-smart-contract
752 
753 
754 
755 contract NewTokenSale is Ownable,Pausable, Utils,Sales{
756 
757     GACToken token;
758     bool fundssent;
759     uint256 public tokensPerUSD;
760     uint256 public currentSupply = 634585000000000000000000;
761     PricingStrategy pricingstrategy;
762     uint256 public tokenCreationMax = 275 * (10**6) * 10**18;
763 
764     ///the address of owner to recieve the token
765     address public ownerAddr =0xB0583785f27B7f87535B4c574D3B30928aD3A7eb ; //to be filled
766 
767     ///this is the address of the distributong account admin
768     address public distributorAddress = 0x5377209111cBe0cfeeaA54c4C28465cbf81D5601;
769 
770     ////MAX Tokens for private sale
771     uint256 public maxPrivateSale = 150 * (10**6) * (10**18);
772     ///MAX tokens for presale 
773     uint256 public maxPreSale = 100 * (10**6) * (10**18);
774 
775     ///MAX tokens for the public sale
776     uint256 public maxPublicSale = 20* (10**6) * (10**18);
777 
778     ///current sales
779     uint256 public endprivate = 1525219200; // 05/02/2018 @ 12:00am (UTC)
780     uint256 public endpresale = 1527724800;//05/31/2018 @ 12:00am (UTC)
781     // uint256 public endpublicsale;
782     uint256 public currentPrivateSale = 630585000000000000000000;
783     uint256 public currentPreSale = 4000000000000000000000;
784     uint256 public currentPublicSale ; 
785 
786 
787     ///array of addresses for the ethereum relateed back funding  contract
788     uint256  public numberOfBackers;
789 
790     mapping(uint256 => bool) transactionsClaimed;
791     uint256 public valueToBeSent;
792     uint public investorCount;
793 
794     struct balanceStruct{
795         uint256 value;
796         bool tokenstransferred;
797     }
798 
799     mapping(address => balanceStruct) public balances;
800     address[] public balancesArr;
801 
802     ///the event log to log out the address of the multisig wallet
803     event logaddr(address addr);
804 
805     ///the function to get the balance
806     function getBalance(address addr) public view returns(uint256) {
807         return balances[addr].value;
808     }
809 
810     ///the function of adding to balances
811     function addToBalances(address addr, uint256 tokenValue) internal{
812         balances[addr].value = SafeMath.add(balances[addr].value,tokenValue);
813         bool found;
814         for(uint i=0;i<balancesArr.length;i++){
815             if(balancesArr[i]==addr){
816                 found = true;
817             }
818         }
819         if(!found){
820             balancesArr.push(addr);
821         }
822     }
823 
824     ///the function of adding to the balances
825     function alottMainSaleToken(address[] arr) public {
826         require(msg.sender == distributorAddress);
827         for(uint i=0;i<arr.length;i++){
828             if(checkExistsInArray(arr[i])){
829             if(!balances[arr[i]].tokenstransferred){
830                 balances[arr[i]].tokenstransferred = true;
831                 token.addToBalances(arr[i], balances[arr[i]].value);
832             }
833         }
834         }
835     }
836 
837     function checkExistsInArray(address addr) internal returns (bool) {
838         for(uint i=0;i<balancesArr.length;i++){
839             if(balancesArr[i]==addr){
840                 return true;
841             }
842         }
843         return false;
844     }
845 
846     //the constructor function
847    function NewTokenSale(address tokenAddress,address strategy){
848         //require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
849         token = GACToken(tokenAddress);
850         tokensPerUSD = 10 * 10 ** 18;
851         valueToBeSent = token.valueToBeSent();
852         pricingstrategy = PricingStrategy(strategy);
853     }
854 
855     /**
856         Payable function to send the ether funds
857     **/
858     function() external payable stopInEmergency{
859         require(token.isValid());
860         require(msg.value>0);
861         ICOSaleState currentState = getStateFunding();
862         require(currentState!=ICOSaleState.Failed);
863         require(currentState!=ICOSaleState.Success);
864         var (discount,usd) = pricingstrategy.totalDiscount(currentState,msg.value,"ethereum");
865         uint256 tokens = usd*tokensPerUSD;
866         uint256 totalTokens = SafeMath.add(tokens,SafeMath.div(SafeMath.mul(tokens,discount),100));
867         if(currentState==ICOSaleState.PrivateSale){
868             require(SafeMath.add(currentPrivateSale,totalTokens)<=maxPrivateSale);
869             currentPrivateSale = SafeMath.add(currentPrivateSale,totalTokens);
870         }else if(currentState==ICOSaleState.PreSale){
871             require(SafeMath.add(currentPreSale,totalTokens)<=maxPreSale);
872             currentPreSale = SafeMath.add(currentPreSale,totalTokens);
873         }else if(currentState==ICOSaleState.PublicSale){
874             require(SafeMath.add(currentPublicSale,totalTokens)<=maxPublicSale);
875             currentPublicSale = SafeMath.add(currentPublicSale,totalTokens);
876         }
877         currentSupply = SafeMath.add(currentSupply,totalTokens);
878         require(currentSupply<=tokenCreationMax);
879         addToBalances(msg.sender,totalTokens);
880         token.increaseEthRaised(msg.value);
881         token.increaseUSDRaised(usd);
882         numberOfBackers++;
883         if(!ownerAddr.send(this.balance))throw;
884     }
885     
886     //Token distribution for the case of the ICO
887     ///function to run when the transaction has been veified
888     function processTransaction(bytes txn, uint256 txHash,address addr,bytes20 btcaddr)  onlyOwner returns (uint)
889     {   
890         bool  valueSent;
891         require(token.isValid());
892      ICOSaleState currentState = getStateFunding();
893 
894         if(!transactionsClaimed[txHash]){
895             var (a,b) = BTC.checkValueSent(txn,btcaddr,valueToBeSent);
896             if(a){
897                 valueSent = true;
898                 transactionsClaimed[txHash] = true;
899                  ///since we are creating tokens we need to increase the total supply
900                allottTokensBTC(addr,b,currentState);
901                 return 1;
902                }
903         }
904     }
905     
906     ///function to allot tokens to address
907     function allottTokensBTC(address addr,uint256 value,ICOSaleState state) internal{
908         ICOSaleState currentState = getStateFunding();
909         require(currentState!=ICOSaleState.Failed);
910         require(currentState!=ICOSaleState.Success);
911         var (discount,usd) = pricingstrategy.totalDiscount(state,value,"bitcoin");
912         uint256 tokens = usd*tokensPerUSD;
913         uint256 totalTokens = SafeMath.add(tokens,SafeMath.div(SafeMath.mul(tokens,discount),100));
914         if(currentState==ICOSaleState.PrivateSale){
915             require(SafeMath.add(currentPrivateSale,totalTokens)<=maxPrivateSale);
916             currentPrivateSale = SafeMath.add(currentPrivateSale,totalTokens);
917         }else if(currentState==ICOSaleState.PreSale){
918             require(SafeMath.add(currentPreSale,totalTokens)<=maxPreSale);
919             currentPreSale = SafeMath.add(currentPreSale,totalTokens);
920         }else if(currentState==ICOSaleState.PublicSale){
921             require(SafeMath.add(currentPublicSale,totalTokens)<=maxPublicSale);
922             currentPublicSale = SafeMath.add(currentPublicSale,totalTokens);
923         }
924        currentSupply = SafeMath.add(currentSupply,totalTokens);
925        require(currentSupply<=tokenCreationMax);
926        addToBalances(addr,totalTokens);
927        token.increaseBTCRaised(value);
928        token.increaseUSDRaised(usd);
929        numberOfBackers++;
930     }
931 
932 
933     ///function to alott tokens by the owner
934 
935     function alottTokensExchange(address contributor,uint256 value) public onlyOwner{
936         token.addToBalances(contributor,value);
937         currentSupply = SafeMath.add(currentSupply,value);
938     }
939 
940     function finalizeTokenSale() public onlyOwner{
941         ICOSaleState currentState = getStateFunding();
942         if(currentState!=ICOSaleState.Success) throw;
943         token.finalizeICO();
944     }
945 
946     ////kill the contract
947     function killContract() public onlyOwner{
948         selfdestruct(ownerAddr);
949     }
950 
951 
952     ///change the end private sale
953     function changeEndPrivateSale(uint256 _newend) public onlyOwner{
954         endprivate = _newend;
955     }
956 
957     function changeEndPreSale(uint256 _newend) public onlyOwner{
958         endpresale  = _newend;
959     }
960 
961 
962     function changeTokensPerUSD(uint256 _val) public onlyOwner{
963         tokensPerUSD = _val;
964     }
965 
966     function getStateFunding() returns (ICOSaleState){
967        if(now>token.fundingStartBlock() && now<=endprivate) return ICOSaleState.PrivateSale;
968        if(now>endprivate && now<=endpresale) return ICOSaleState.PreSale;
969        if(now>endpresale && now<=token.fundingEndBlock()) return ICOSaleState.PublicSale;
970        if(now>token.fundingEndBlock() && token.usdraised()<token.minCapUSD()) return ICOSaleState.Failed;
971        if(now>token.fundingEndBlock() && token.usdraised()>=token.minCapUSD()) return ICOSaleState.Success;
972     }
973 
974     
975 
976 }