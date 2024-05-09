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
50 	    PrivateSale,
51 	    PreSale,
52 	    PreICO,
53 	    PublicICO
54 	}
55 }
56 
57 contract Utils{
58 
59 	//verifies the amount greater than zero
60 
61 	modifier greaterThanZero(uint256 _value){
62 		require(_value>0);
63 		_;
64 	}
65 
66 	///verifies an address
67 
68 	modifier validAddress(address _add){
69 		require(_add!=0x0);
70 		_;
71 	}
72 }
73 
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
84 contract Token {
85     uint256 public totalSupply;
86     function balanceOf(address _owner) constant returns (uint256 balance);
87     function transfer(address _to, uint256 _value) returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
89     function approve(address _spender, uint256 _value) returns (bool success);
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 }
94 
95 
96 /*  ERC 20 token */
97 contract SMTToken is Token,Ownable,Sales {
98     string public constant name = "Sun Money Token";
99     string public constant symbol = "SMT";
100     uint256 public constant decimals = 18;
101     string public version = "1.0";
102 
103     ///The value to be sent to our BTC address
104     uint public valueToBeSent = 1;
105     ///The ethereum address of the person manking the transaction
106     address personMakingTx;
107     //uint private output1,output2,output3,output4;
108     ///to return the address just for the testing purposes
109     address public addr1;
110     ///to return the tx origin just for the testing purposes
111     address public txorigin;
112 
113     //function for testing only btc address
114     bool isTesting;
115     ///testing the name remove while deploying
116     bytes32 testname;
117     address finalOwner;
118     bool public finalizedPublicICO = false;
119     bool public finalizedPreICO = false;
120 
121     uint256 public SMTfundAfterPreICO;
122     uint256 public ethraised;
123     uint256 public btcraised;
124 
125     bool public istransferAllowed;
126 
127     uint256 public constant SMTfund = 10 * (10**6) * 10**decimals; 
128     uint256 public fundingStartBlock; // crowdsale start block
129     uint256 public fundingEndBlock; // crowdsale end block
130     uint256 public  tokensPerEther = 150; //TODO
131     uint256 public  tokensPerBTC = 22*150*(10**10);
132     uint256 public tokenCreationMax= 72* (10**5) * 10**decimals; //TODO
133     mapping (address => bool) ownership;
134 
135 
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) allowed;
138 
139     modifier onlyPayloadSize(uint size) {
140         require(msg.data.length >= size + 4);
141         _;
142     }
143 
144     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
145       if(!istransferAllowed) throw;
146       if (balances[msg.sender] >= _value && _value > 0) {
147         balances[msg.sender] -= _value;
148         balances[_to] += _value;
149         Transfer(msg.sender, _to, _value);
150         return true;
151       } else {
152         return false;
153       }
154     }
155 
156     //this is the default constructor
157     function SMTToken(uint256 _fundingStartBlock, uint256 _fundingEndBlock){
158         totalSupply = SMTfund;
159         fundingStartBlock = _fundingStartBlock;
160         fundingEndBlock = _fundingEndBlock;
161     }
162 
163 
164     ICOSaleState public salestate = ICOSaleState.PrivateSale;
165 
166     ///**To be replaced  the following by the following*///
167     /**
168 
169     **/
170 
171     /***Event to be fired when the state of the sale of the ICO is changes**/
172     event stateChange(ICOSaleState state);
173 
174     /**
175 
176     **/
177     function setState(ICOSaleState state)  returns (bool){
178     if(!ownership[msg.sender]) throw;
179     salestate = state;
180     stateChange(salestate);
181     return true;
182     }
183 
184     /**
185 
186     **/
187     function getState() returns (ICOSaleState) {
188     return salestate;
189 
190     }
191 
192 
193 
194     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool success) {
195         if(!istransferAllowed) throw;
196       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
197         balances[_to] += _value;
198         balances[_from] -= _value;
199         allowed[_from][msg.sender] -= _value;
200         Transfer(_from, _to, _value);
201         return true;
202       } else {
203         return false;
204       }
205     }
206 
207     function addToBalances(address _person,uint256 value) {
208         if(!ownership[msg.sender]) throw;
209         balances[_person] = SafeMath.add(balances[_person],value);
210 
211     }
212 
213     function addToOwnership(address owners) onlyOwner{
214         ownership[owners] = true;
215     }
216 
217     function balanceOf(address _owner) constant returns (uint256 balance) {
218         return balances[_owner];
219     }
220 
221     function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) returns (bool success) {
222         if(!istransferAllowed) throw;
223         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
224         allowed[msg.sender][_spender] = _value;
225         Approval(msg.sender, _spender, _value);
226         return true;
227     }
228 
229     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
230       if(!istransferAllowed) throw;
231       return allowed[_owner][_spender];
232     }
233 
234     function increaseEthRaised(uint256 value){
235         if(!ownership[msg.sender]) throw;
236         ethraised+=value;
237     }
238 
239     function increaseBTCRaised(uint256 value){
240         if(!ownership[msg.sender]) throw;
241         btcraised+=value;
242     }
243 
244 
245 
246 
247     function finalizePreICO(uint256 value) returns(bool){
248         if(!ownership[msg.sender]) throw;
249         finalizedPreICO = true;
250         SMTfundAfterPreICO =value;
251         return true;
252     }
253 
254 
255     function finalizePublicICO() returns(bool) {
256         if(!ownership[msg.sender]) throw;
257         finalizedPublicICO = true;
258         istransferAllowed = true;
259         return true;
260     }
261 
262 
263     function isValid() returns(bool){
264         if(block.number>=fundingStartBlock && block.number<fundingEndBlock ){
265             return true;
266         }else{
267             return false;
268         }
269     }
270 
271     ///do not allow payments on this address
272 
273     function() payable{
274         throw;
275     }
276 }
277 
278 
279 
280 
281 
282 
283 
284 
285 /**
286  * @title Pausable
287  * @dev Base contract which allows children to implement an emergency stop mechanism.
288  */
289 contract Pausable is Ownable {
290   event Pause();
291   event Unpause();
292 
293   bool public paused = false;
294 
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is not paused.
298    */
299   modifier whenNotPaused() {
300     require(!paused);
301     _;
302   }
303 
304   /**
305    * @dev Modifier to make a function callable only when the contract is paused.
306    */
307   modifier whenPaused() {
308     require(paused);
309     _;
310   }
311 
312   modifier stopInEmergency {
313     if (paused) {
314       throw;
315     }
316     _;
317   }
318 
319   /**
320    * @dev called by the owner to pause, triggers stopped state
321    */
322   function pause() onlyOwner whenNotPaused public {
323     paused = true;
324     Pause();
325   }
326 
327   /**
328    * @dev called by the owner to unpause, returns to normal state
329    */
330   function unpause() onlyOwner whenPaused public {
331     paused = false;
332     Unpause();
333   }
334 }
335 // Bitcoin transaction parsing library
336 
337 // Copyright 2016 rain <https://keybase.io/rain>
338 //
339 // Licensed under the Apache License, Version 2.0 (the "License");
340 // you may not use this file except in compliance with the License.
341 // You may obtain a copy of the License at
342 //
343 //      http://www.apache.org/licenses/LICENSE-2.0
344 //
345 // Unless required by applicable law or agreed to in writing, software
346 // distributed under the License is distributed on an "AS IS" BASIS,
347 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
348 // See the License for the specific language governing permissions and
349 // limitations under the License.
350 
351 // https://en.bitcoin.it/wiki/Protocol_documentation#tx
352 //
353 // Raw Bitcoin transaction structure:
354 //
355 // field     | size | type     | description
356 // version   | 4    | int32    | transaction version number
357 // n_tx_in   | 1-9  | var_int  | number of transaction inputs
358 // tx_in     | 41+  | tx_in[]  | list of transaction inputs
359 // n_tx_out  | 1-9  | var_int  | number of transaction outputs
360 // tx_out    | 9+   | tx_out[] | list of transaction outputs
361 // lock_time | 4    | uint32   | block number / timestamp at which tx locked
362 //
363 // Transaction input (tx_in) structure:
364 //
365 // field      | size | type     | description
366 // previous   | 36   | outpoint | Previous output transaction reference
367 // script_len | 1-9  | var_int  | Length of the signature script
368 // sig_script | ?    | uchar[]  | Script for confirming transaction authorization
369 // sequence   | 4    | uint32   | Sender transaction version
370 //
371 // OutPoint structure:
372 //
373 // field      | size | type     | description
374 // hash       | 32   | char[32] | The hash of the referenced transaction
375 // index      | 4    | uint32   | The index of this output in the referenced transaction
376 //
377 // Transaction output (tx_out) structure:
378 //
379 // field         | size | type     | description
380 // value         | 8    | int64    | Transaction value (Satoshis)
381 // pk_script_len | 1-9  | var_int  | Length of the public key script
382 // pk_script     | ?    | uchar[]  | Public key as a Bitcoin script.
383 //
384 // Variable integers (var_int) can be encoded differently depending
385 // on the represented value, to save space. Variable integers always
386 // precede an array of a variable length data type (e.g. tx_in).
387 //
388 // Variable integer encodings as a function of represented value:
389 //
390 // value           | bytes  | format
391 // <0xFD (253)     | 1      | uint8
392 // <=0xFFFF (65535)| 3      | 0xFD followed by length as uint16
393 // <=0xFFFF FFFF   | 5      | 0xFE followed by length as uint32
394 // -               | 9      | 0xFF followed by length as uint64
395 //
396 // Public key scripts `pk_script` are set on the output and can
397 // take a number of forms. The regular transaction script is
398 // called 'pay-to-pubkey-hash' (P2PKH):
399 //
400 // OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
401 //
402 // OP_x are Bitcoin script opcodes. The bytes representation (including
403 // the 0x14 20-byte stack push) is:
404 //
405 // 0x76 0xA9 0x14 <pubKeyHash> 0x88 0xAC
406 //
407 // The <pubKeyHash> is the ripemd160 hash of the sha256 hash of
408 // the public key, preceded by a network version byte. (21 bytes total)
409 //
410 // Network version bytes: 0x00 (mainnet); 0x6f (testnet); 0x34 (namecoin)
411 //
412 // The Bitcoin address is derived from the pubKeyHash. The binary form is the
413 // pubKeyHash, plus a checksum at the end.  The checksum is the first 4 bytes
414 // of the (32 byte) double sha256 of the pubKeyHash. (25 bytes total)
415 // This is converted to base58 to form the publicly used Bitcoin address.
416 // Mainnet P2PKH transaction scripts are to addresses beginning with '1'.
417 //
418 // P2SH ('pay to script hash') scripts only supply a script hash. The spender
419 // must then provide the script that would allow them to redeem this output.
420 // This allows for arbitrarily complex scripts to be funded using only a
421 // hash of the script, and moves the onus on providing the script from
422 // the spender to the redeemer.
423 //
424 // The P2SH script format is simple:
425 //
426 // OP_HASH160 <scriptHash> OP_EQUAL
427 //
428 // 0xA9 0x14 <scriptHash> 0x87
429 //
430 // The <scriptHash> is the ripemd160 hash of the sha256 hash of the
431 // redeem script. The P2SH address is derived from the scriptHash.
432 // Addresses are the scriptHash with a version prefix of 5, encoded as
433 // Base58check. These addresses begin with a '3'.
434 
435 
436 
437 // parse a raw bitcoin transaction byte array
438 library BTC {
439     // Convert a variable integer into something useful and return it and
440     // the index to after it.
441     function parseVarInt(bytes txBytes, uint pos) returns (uint, uint) {
442         // the first byte tells us how big the integer is
443         var ibit = uint8(txBytes[pos]);
444         pos += 1;  // skip ibit
445 
446         if (ibit < 0xfd) {
447             return (ibit, pos);
448         } else if (ibit == 0xfd) {
449             return (getBytesLE(txBytes, pos, 16), pos + 2);
450         } else if (ibit == 0xfe) {
451             return (getBytesLE(txBytes, pos, 32), pos + 4);
452         } else if (ibit == 0xff) {
453             return (getBytesLE(txBytes, pos, 64), pos + 8);
454         }
455     }
456     // convert little endian bytes to uint
457     function getBytesLE(bytes data, uint pos, uint bits) returns (uint) {
458         if (bits == 8) {
459             return uint8(data[pos]);
460         } else if (bits == 16) {
461             return uint16(data[pos])
462                  + uint16(data[pos + 1]) * 2 ** 8;
463         } else if (bits == 32) {
464             return uint32(data[pos])
465                  + uint32(data[pos + 1]) * 2 ** 8
466                  + uint32(data[pos + 2]) * 2 ** 16
467                  + uint32(data[pos + 3]) * 2 ** 24;
468         } else if (bits == 64) {
469             return uint64(data[pos])
470                  + uint64(data[pos + 1]) * 2 ** 8
471                  + uint64(data[pos + 2]) * 2 ** 16
472                  + uint64(data[pos + 3]) * 2 ** 24
473                  + uint64(data[pos + 4]) * 2 ** 32
474                  + uint64(data[pos + 5]) * 2 ** 40
475                  + uint64(data[pos + 6]) * 2 ** 48
476                  + uint64(data[pos + 7]) * 2 ** 56;
477         }
478     }
479     // scan the full transaction bytes and return the first two output
480     // values (in satoshis) and addresses (in binary)
481     function getFirstTwoOutputs(bytes txBytes)
482              returns (uint, bytes20, uint, bytes20)
483     {
484         uint pos;
485         uint[] memory input_script_lens = new uint[](2);
486         uint[] memory output_script_lens = new uint[](2);
487         uint[] memory script_starts = new uint[](2);
488         uint[] memory output_values = new uint[](2);
489         bytes20[] memory output_addresses = new bytes20[](2);
490 
491         pos = 4;  // skip version
492 
493         (input_script_lens, pos) = scanInputs(txBytes, pos, 0);
494 
495         (output_values, script_starts, output_script_lens, pos) = scanOutputs(txBytes, pos, 2);
496 
497         for (uint i = 0; i < 2; i++) {
498             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
499             output_addresses[i] = pkhash;
500         }
501 
502         return (output_values[0], output_addresses[0],
503                 output_values[1], output_addresses[1]);
504     }
505     // Check whether `btcAddress` is in the transaction outputs *and*
506     // whether *at least* `value` has been sent to it.
507         // Check whether `btcAddress` is in the transaction outputs *and*
508     // whether *at least* `value` has been sent to it.
509     function checkValueSent(bytes txBytes, bytes20 btcAddress, uint value)
510              returns (bool,uint)
511     {
512         uint pos = 4;  // skip version
513         (, pos) = scanInputs(txBytes, pos, 0);  // find end of inputs
514 
515         // scan *all* the outputs and find where they are
516         var (output_values, script_starts, output_script_lens,) = scanOutputs(txBytes, pos, 0);
517 
518         // look at each output and check whether it at least value to btcAddress
519         for (uint i = 0; i < output_values.length; i++) {
520             var pkhash = parseOutputScript(txBytes, script_starts[i], output_script_lens[i]);
521             if (pkhash == btcAddress && output_values[i] >= value) {
522                 return (true,output_values[i]);
523             }
524         }
525     }
526     // scan the inputs and find the script lengths.
527     // return an array of script lengths and the end position
528     // of the inputs.
529     // takes a 'stop' argument which sets the maximum number of
530     // outputs to scan through. stop=0 => scan all.
531     function scanInputs(bytes txBytes, uint pos, uint stop)
532              returns (uint[], uint)
533     {
534         uint n_inputs;
535         uint halt;
536         uint script_len;
537 
538         (n_inputs, pos) = parseVarInt(txBytes, pos);
539 
540         if (stop == 0 || stop > n_inputs) {
541             halt = n_inputs;
542         } else {
543             halt = stop;
544         }
545 
546         uint[] memory script_lens = new uint[](halt);
547 
548         for (var i = 0; i < halt; i++) {
549             pos += 36;  // skip outpoint
550             (script_len, pos) = parseVarInt(txBytes, pos);
551             script_lens[i] = script_len;
552             pos += script_len + 4;  // skip sig_script, seq
553         }
554 
555         return (script_lens, pos);
556     }
557     // scan the outputs and find the values and script lengths.
558     // return array of values, array of script lengths and the
559     // end position of the outputs.
560     // takes a 'stop' argument which sets the maximum number of
561     // outputs to scan through. stop=0 => scan all.
562     function scanOutputs(bytes txBytes, uint pos, uint stop)
563              returns (uint[], uint[], uint[], uint)
564     {
565         uint n_outputs;
566         uint halt;
567         uint script_len;
568 
569         (n_outputs, pos) = parseVarInt(txBytes, pos);
570 
571         if (stop == 0 || stop > n_outputs) {
572             halt = n_outputs;
573         } else {
574             halt = stop;
575         }
576 
577         uint[] memory script_starts = new uint[](halt);
578         uint[] memory script_lens = new uint[](halt);
579         uint[] memory output_values = new uint[](halt);
580 
581         for (var i = 0; i < halt; i++) {
582             output_values[i] = getBytesLE(txBytes, pos, 64);
583             pos += 8;
584 
585             (script_len, pos) = parseVarInt(txBytes, pos);
586             script_starts[i] = pos;
587             script_lens[i] = script_len;
588             pos += script_len;
589         }
590 
591         return (output_values, script_starts, script_lens, pos);
592     }
593     // Slice 20 contiguous bytes from bytes `data`, starting at `start`
594     function sliceBytes20(bytes data, uint start) returns (bytes20) {
595         uint160 slice = 0;
596         for (uint160 i = 0; i < 20; i++) {
597             slice += uint160(data[i + start]) << (8 * (19 - i));
598         }
599         return bytes20(slice);
600     }
601     // returns true if the bytes located in txBytes by pos and
602     // script_len represent a P2PKH script
603     function isP2PKH(bytes txBytes, uint pos, uint script_len) returns (bool) {
604         return (script_len == 25)           // 20 byte pubkeyhash + 5 bytes of script
605             && (txBytes[pos] == 0x76)       // OP_DUP
606             && (txBytes[pos + 1] == 0xa9)   // OP_HASH160
607             && (txBytes[pos + 2] == 0x14)   // bytes to push
608             && (txBytes[pos + 23] == 0x88)  // OP_EQUALVERIFY
609             && (txBytes[pos + 24] == 0xac); // OP_CHECKSIG
610     }
611     // returns true if the bytes located in txBytes by pos and
612     // script_len represent a P2SH script
613     function isP2SH(bytes txBytes, uint pos, uint script_len) returns (bool) {
614         return (script_len == 23)           // 20 byte scripthash + 3 bytes of script
615             && (txBytes[pos + 0] == 0xa9)   // OP_HASH160
616             && (txBytes[pos + 1] == 0x14)   // bytes to push
617             && (txBytes[pos + 22] == 0x87); // OP_EQUAL
618     }
619     // Get the pubkeyhash / scripthash from an output script. Assumes
620     // pay-to-pubkey-hash (P2PKH) or pay-to-script-hash (P2SH) outputs.
621     // Returns the pubkeyhash/ scripthash, or zero if unknown output.
622     function parseOutputScript(bytes txBytes, uint pos, uint script_len)
623              returns (bytes20)
624     {
625         if (isP2PKH(txBytes, pos, script_len)) {
626             return sliceBytes20(txBytes, pos + 3);
627         } else if (isP2SH(txBytes, pos, script_len)) {
628             return sliceBytes20(txBytes, pos + 2);
629         } else {
630             return;
631         }
632     }
633 }
634 
635 
636 
637 
638 
639 /**
640  * @title SafeMath
641  * @dev Math operations with safety checks that throw on error
642  */
643 library SafeMath {
644   function mul(uint256 a, uint256 b) internal returns (uint256) {
645     if (a == 0) {
646       return 0;
647     }
648     uint256 c = a * b;
649     assert(c / a == b);
650     return c;
651   }
652 
653   function div(uint256 a, uint256 b) internal returns (uint256) {
654     // assert(b > 0); // Solidity automatically throws when dividing by 0
655     uint256 c = a / b;
656     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
657     return c;
658   }
659 
660   function sub(uint256 a, uint256 b) internal returns (uint256) {
661     assert(b <= a);
662     return a - b;
663   }
664 
665   function add(uint256 a, uint256 b) internal returns (uint256) {
666     uint256 c = a + b;
667     assert(c >= a);
668     return c;
669   }
670 }
671 
672 
673 
674 contract PricingStrategy{
675 
676 	/**
677 	returns the base discount value
678 	@param  currentsupply is a 'current supply' value
679 	@param  contribution  is 'sent by the contributor'
680 	@return   an integer for getting the discount value of the base discounts
681 	**/
682 	function baseDiscounts(uint256 currentsupply,uint256 contribution,string types) returns (uint256){
683 		if(contribution==0) throw;
684 		if(keccak256("ethereum")==keccak256(types)){
685 			if(currentsupply>=0 && currentsupply<= 15*(10**5) * (10**18) && contribution>=1*10**18){
686 			 return 40;
687 			}else if(currentsupply> 15*(10**5) * (10**18) && currentsupply< 30*(10**5) * (10**18) && contribution>=5*10**17){
688 				return 30;
689 			}else{
690 				return 0;
691 			}
692 			}else if(keccak256("bitcoin")==keccak256(types)){
693 				if(currentsupply>=0 && currentsupply<= 15*(10**5) * (10**18) && contribution>=45*10**5){
694 				 return 40;
695 				}else if(currentsupply> 15*(10**5) * (10**18) && currentsupply< 30*(10**5) * (10**18) && contribution>=225*10**4){
696 					return 30;
697 				}else{
698 					return 0;
699 				}
700 			}	
701 	}
702 
703 	/**
704 	
705 	These are the base discounts offered by the sunMOneyToken
706 	These are valid ffor every value sent to the contract
707 	@param   contribution is a 'the value sent in wei by the contributor in ethereum'
708 	@return  the discount
709 	**/
710 	function volumeDiscounts(uint256 contribution,string types) returns (uint256){
711 		///do not allow the zero contrbution 
712 		//its unsigned negative checking not required
713 		if(contribution==0) throw;
714 		if(keccak256("ethereum")==keccak256(types)){
715 			if(contribution>=3*10**18 && contribution<10*10**18){
716 				return 0;
717 			}else if(contribution>=10*10**18 && contribution<20*10**18){
718 				return 5;
719 			}else if(contribution>=20*10**18){
720 				return 10;
721 			}else{
722 				return 0;
723 			}
724 			}else if(keccak256("bitcoin")==keccak256(types)){
725 				if(contribution>=3*45*10**5 && contribution<10*45*10**5){
726 					return 0;
727 				}else if(contribution>=10*45*10**5 && contribution<20*45*10**5){
728 					return 5;
729 				}else if(contribution>=20*45*10**5){
730 					return 10;
731 				}else{
732 					return 0;
733 				}
734 			}
735 
736 	}
737 
738 	/**returns the total discount value**/
739 	/**
740 	@param  currentsupply is a 'current supply'
741 	@param  contribution is a 'sent by the contributor'
742 	@return   an integer for getting the total discounts
743 	**/
744 	function totalDiscount(uint256 currentsupply,uint256 contribution,string types) returns (uint256){
745 		uint256 basediscount = baseDiscounts(currentsupply,contribution,types);
746 		uint256 volumediscount = volumeDiscounts(contribution,types);
747 		uint256 totaldiscount = basediscount+volumediscount;
748 		return totaldiscount;
749 	}
750 }
751 
752 
753 
754 contract PreICO is Ownable,Pausable, Utils,PricingStrategy,Sales{
755 
756 	SMTToken token;
757 	uint256 public tokensPerBTC;
758 	uint public tokensPerEther;
759 	uint256 public initialSupplyPrivateSale;
760 	uint256 public initialSupplyPreSale;
761 	uint256 public SMTfundAfterPreICO;
762 	uint256 public initialSupplyPublicPreICO;
763 	uint256 public currentSupply;
764 	uint256 public fundingStartBlock;
765 	uint256 public fundingEndBlock;
766 	uint256 public SMTfund;
767 	uint256 public tokenCreationMaxPreICO = 15* (10**5) * 10**18;
768 	uint256 public tokenCreationMaxPrivateSale = 15*(10**5) * (10**18);
769 	///tokens for the team
770 	uint256 public team = 1*(10**6)*(10**18);
771 	///tokens for reserve
772 	uint256 public reserve = 1*(10**6)*(10**18);
773 	///tokens for the mentors
774 	uint256 public mentors = 5*(10**5)*10**18;
775 	///tokkens for the bounty
776 	uint256 public bounty = 3*(10**5)*10**18;
777 	///address for the teeam,investores,etc
778 
779 	uint256 totalsend = team+reserve+bounty+mentors;
780 	address public addressPeople = 0xea0f17CA7C3e371af30EFE8CbA0e646374552e8B;
781 
782 	address public ownerAddr = 0x4cA09B312F23b390450D902B21c7869AA64877E3;
783 	///array of addresses for the ethereum relateed back funding  contract
784 	uint256 public numberOfBackers;
785 	///the txorigin is the web3.eth.coinbase account
786 	//record Transactions that have claimed ether to prevent the replay attacks
787 	//to-do
788 	mapping(uint256 => bool) transactionsClaimed;
789 	uint256 public valueToBeSent;
790 
791 	//the constructor function
792    function PreICO(address tokenAddress){
793 		//require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
794 		token = SMTToken(tokenAddress);
795 		tokensPerEther = token.tokensPerEther();
796 		tokensPerBTC = token.tokensPerBTC();
797 		valueToBeSent = token.valueToBeSent();
798 		SMTfund = token.SMTfund();
799 	}
800 	
801 	////function to send initialFUnd
802     function sendFunds() onlyOwner{
803         token.addToBalances(addressPeople,totalsend);
804     }
805 
806 	///a function using safemath to work with
807 	///the new function
808 	function calNewTokens(uint256 contribution,string types) returns (uint256){
809 		uint256 disc = totalDiscount(currentSupply,contribution,types);
810 		uint256 CreatedTokens;
811 		if(keccak256(types)==keccak256("ethereum")) CreatedTokens = SafeMath.mul(contribution,tokensPerEther);
812 		else if(keccak256(types)==keccak256("bitcoin"))  CreatedTokens = SafeMath.mul(contribution,tokensPerBTC);
813 		uint256 tokens = SafeMath.add(CreatedTokens,SafeMath.div(SafeMath.mul(CreatedTokens,disc),100));
814 		return tokens;
815 	}
816 	/**
817 		Payable function to send the ether funds
818 	**/
819 	function() external payable stopInEmergency{
820         if(token.getState()==ICOSaleState.PublicICO) throw;
821         bool isfinalized = token.finalizedPreICO();
822         bool isValid = token.isValid();
823         if(isfinalized) throw;
824         if(!isValid) throw;
825         if (msg.value == 0) throw;
826         uint256 newCreatedTokens;
827         ///since we are creating tokens we need to increase the total supply
828         if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {
829         	if((msg.value) < 1*10**18) throw;
830         	newCreatedTokens =calNewTokens(msg.value,"ethereum");
831         	uint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
832         	if(temp>tokenCreationMaxPrivateSale){
833         		uint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);
834         		initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);
835         		currentSupply = SafeMath.add(currentSupply,consumed);
836         		uint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);
837         		uint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));
838         		switchState();
839         		initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);
840         		currentSupply = SafeMath.add(currentSupply,finalTokens);
841         		if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
842         		numberOfBackers++;
843                token.addToBalances(msg.sender,SafeMath.add(finalTokens,consumed));
844         	 if(!ownerAddr.send(msg.value))throw;
845         	  token.increaseEthRaised(msg.value);
846         	}else{
847     			initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
848     			currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
849     			if(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;
850     			numberOfBackers++;
851                 token.addToBalances(msg.sender,newCreatedTokens);
852             	if(!ownerAddr.send(msg.value))throw;
853             	token.increaseEthRaised(msg.value);
854     		}
855         }
856         else if(token.getState()==ICOSaleState.PreICO){
857         	if(msg.value < 5*10**17) throw;
858         	newCreatedTokens =calNewTokens(msg.value,"ethereum");
859         	initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);
860         	currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
861         	if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
862         	numberOfBackers++;
863              token.addToBalances(msg.sender,newCreatedTokens);
864         	if(!ownerAddr.send(msg.value))throw;
865         	token.increaseEthRaised(msg.value);
866         }
867 
868 	}
869 
870 	///token distribution initial function for the one in the exchanges
871 	///to be done only the owner can run this function
872 	function tokenAssignExchange(address addr,uint256 val,uint256 txnHash) public onlyOwner {
873 	   // if(msg.sender!=owner) throw;
874 	  if (val == 0) throw;
875 	  if(token.getState()==ICOSaleState.PublicICO) throw;
876 	  if(transactionsClaimed[txnHash]) throw;
877 	  bool isfinalized = token.finalizedPreICO();
878 	  if(isfinalized) throw;
879 	  bool isValid = token.isValid();
880 	  if(!isValid) throw;
881 	  uint256 newCreatedTokens;
882         if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {
883         	if(val < 1*10**18) throw;
884         	newCreatedTokens =calNewTokens(val,"ethereum");
885         	uint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
886         	if(temp>tokenCreationMaxPrivateSale){
887         		uint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);
888         		initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);
889         		currentSupply = SafeMath.add(currentSupply,consumed);
890         		uint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);
891         		uint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));
892         		switchState();
893         		initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);
894         		currentSupply = SafeMath.add(currentSupply,finalTokens);
895         		if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
896         		numberOfBackers++;
897                token.addToBalances(addr,SafeMath.add(finalTokens,consumed));
898         	   token.increaseEthRaised(val);
899         	}else{
900     			initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
901     			currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
902     			if(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;
903     			numberOfBackers++;
904                 token.addToBalances(addr,newCreatedTokens);
905             	token.increaseEthRaised(val);
906     		}
907         }
908         else if(token.getState()==ICOSaleState.PreICO){
909         	if(msg.value < 5*10**17) throw;
910         	newCreatedTokens =calNewTokens(val,"ethereum");
911         	initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);
912         	currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
913         	if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
914         	numberOfBackers++;
915              token.addToBalances(addr,newCreatedTokens);
916         	token.increaseEthRaised(val);
917         }
918 	}
919 
920 	//Token distribution for the case of the ICO
921 	///function to run when the transaction has been veified
922 	function processTransaction(bytes txn, uint256 txHash,address addr,bytes20 btcaddr) onlyOwner returns (uint)
923 	{
924 		bool valueSent;
925 		bool isValid = token.isValid();
926 		if(!isValid) throw;
927 		//txorigin = tx.origin;
928 		//	if(token.getState()!=State.Funding) throw;
929 		if(!transactionsClaimed[txHash]){
930 			var (a,b) = BTC.checkValueSent(txn,btcaddr,valueToBeSent);
931 			if(a){
932 				valueSent = true;
933 				transactionsClaimed[txHash] = true;
934 				uint256 newCreatedTokens;
935 				 ///since we are creating tokens we need to increase the total supply
936             if(token.getState()==ICOSaleState.PrivateSale||token.getState()==ICOSaleState.PreSale) {
937         	if(b < 45*10**5) throw;
938         	newCreatedTokens =calNewTokens(b,"bitcoin");
939         	uint256 temp = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
940         	if(temp>tokenCreationMaxPrivateSale){
941         		uint256 consumed = SafeMath.sub(tokenCreationMaxPrivateSale,initialSupplyPrivateSale);
942         		initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,consumed);
943         		currentSupply = SafeMath.add(currentSupply,consumed);
944         		uint256 nonConsumed = SafeMath.sub(newCreatedTokens,consumed);
945         		uint256 finalTokens = SafeMath.sub(nonConsumed,SafeMath.div(nonConsumed,10));
946         		switchState();
947         		initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,finalTokens);
948         		currentSupply = SafeMath.add(currentSupply,finalTokens);
949         		if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
950         		numberOfBackers++;
951                token.addToBalances(addr,SafeMath.add(finalTokens,consumed));
952         	   token.increaseBTCRaised(b);
953         	}else{
954     			initialSupplyPrivateSale = SafeMath.add(initialSupplyPrivateSale,newCreatedTokens);
955     			currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
956     			if(initialSupplyPrivateSale>tokenCreationMaxPrivateSale) throw;
957     			numberOfBackers++;
958                 token.addToBalances(addr,newCreatedTokens);
959             	token.increaseBTCRaised(b);
960     		}
961         }
962         else if(token.getState()==ICOSaleState.PreICO){
963         	if(msg.value < 225*10**4) throw;
964         	newCreatedTokens =calNewTokens(b,"bitcoin");
965         	initialSupplyPublicPreICO = SafeMath.add(initialSupplyPublicPreICO,newCreatedTokens);
966         	currentSupply = SafeMath.add(currentSupply,newCreatedTokens);
967         	if(initialSupplyPublicPreICO>tokenCreationMaxPreICO) throw;
968         	numberOfBackers++;
969              token.addToBalances(addr,newCreatedTokens);
970         	token.increaseBTCRaised(b);
971          }
972 		return 1;
973 			}
974 		}
975 		else{
976 		    throw;
977 		}
978 	}
979 
980 	function finalizePreICO() public onlyOwner{
981 		uint256 val = currentSupply;
982 		token.finalizePreICO(val);
983 	}
984 
985 	function switchState() internal  {
986 		 token.setState(ICOSaleState.PreICO);
987 		
988 	}
989 	
990 
991 	
992 
993 }