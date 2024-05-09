1 pragma solidity ^0.4.19;
2 
3 // File: contracts/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/oraclizeLib.sol
52 
53 // <ORACLIZE_API_LIB>
54 /*
55 Copyright (c) 2015-2016 Oraclize SRL
56 Copyright (c) 2016 Oraclize LTD
57 
58 
59 
60 Permission is hereby granted, free of charge, to any person obtaining a copy
61 of this software and associated documentation files (the "Software"), to deal
62 in the Software without restriction, including without limitation the rights
63 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
64 copies of the Software, and to permit persons to whom the Software is
65 furnished to do so, subject to the following conditions:
66 
67 
68 
69 The above copyright notice and this permission notice shall be included in
70 all copies or substantial portions of the Software.
71 
72 
73 
74 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
75 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
76 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
77 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
78 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
79 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
80 THE SOFTWARE.
81 */
82 
83 pragma solidity ^0.4.0;
84 
85 contract OraclizeI {
86     address public cbAddress;
87     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
88     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
89     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
90     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
91     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
92     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
93     function getPrice(string _datasource) returns (uint _dsprice);
94     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
95     function setProofType(byte _proofType);
96     function setConfig(bytes32 _config);
97     function setCustomGasPrice(uint _gasPrice);
98 }
99 contract OraclizeAddrResolverI {
100     function getAddress() returns (address _addr);
101 }
102 library oraclizeLib {
103     //byte constant internal proofType_NONE = 0x00;
104     function proofType_NONE()
105     constant
106     returns (byte) {
107         return 0x00;
108     }
109     //byte constant internal proofType_TLSNotary = 0x10;
110     function proofType_TLSNotary()
111     constant
112     returns (byte) {
113         return 0x10;
114     }
115     //byte constant internal proofStorage_IPFS = 0x01;
116     function proofStorage_IPFS()
117     constant
118     returns (byte) {
119         return 0x01;
120     }
121 
122     // *******TRUFFLE + BRIDGE*********
123     //OraclizeAddrResolverI constant public OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
124 
125     // *****REALNET DEPLOYMENT******
126     OraclizeAddrResolverI constant public OAR = oraclize_setNetwork(); // constant means dont store and re-eval on each call
127 
128     function getOAR()
129     constant
130     returns (OraclizeAddrResolverI) {
131         return OAR;
132     }
133 
134     OraclizeI constant public oraclize = OraclizeI(OAR.getAddress());
135 
136     function getCON()
137     constant
138     returns (OraclizeI) {
139         return oraclize;
140     }
141 
142     function oraclize_setNetwork()
143     public
144     returns(OraclizeAddrResolverI){
145         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
146             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
147         }
148         if (getCodeSize(0xb9b00A7aE2e1D3557d7Ec7e0633e25739A6B510e)>0) { // ropsten custom ethereum bridge
149             return OraclizeAddrResolverI(0xb9b00A7aE2e1D3557d7Ec7e0633e25739A6B510e);
150         }
151         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
152             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
153         }
154         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
155             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
156         }
157         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
158             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
159         }
160         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
161             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
162         }
163         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
164             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
165         }
166         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
167             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
168         }
169     }
170 
171     function oraclize_getPrice(string datasource)
172     public
173     returns (uint){
174         return oraclize.getPrice(datasource);
175     }
176 
177     function oraclize_getPrice(string datasource, uint gaslimit)
178     public
179     returns (uint){
180         return oraclize.getPrice(datasource, gaslimit);
181     }
182 
183     function oraclize_query(string datasource, string arg)
184     public
185     returns (bytes32 id){
186         return oraclize_query(0, datasource, arg);
187     }
188 
189     function oraclize_query(uint timestamp, string datasource, string arg)
190     public
191     returns (bytes32 id){
192         uint price = oraclize.getPrice(datasource);
193         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
194         return oraclize.query.value(price)(timestamp, datasource, arg);
195     }
196 
197     function oraclize_query(string datasource, string arg, uint gaslimit)
198     public
199     returns (bytes32 id){
200         return oraclize_query(0, datasource, arg, gaslimit);
201     }
202 
203     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit)
204     public
205     returns (bytes32 id){
206         uint price = oraclize.getPrice(datasource, gaslimit);
207         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
208         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
209     }
210 
211     function oraclize_query(string datasource, string arg1, string arg2)
212     public
213     returns (bytes32 id){
214         return oraclize_query(0, datasource, arg1, arg2);
215     }
216 
217     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2)
218     public
219     returns (bytes32 id){
220         uint price = oraclize.getPrice(datasource);
221         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
222         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
223     }
224 
225     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit)
226     public
227     returns (bytes32 id){
228         return oraclize_query(0, datasource, arg1, arg2, gaslimit);
229     }
230 
231     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit)
232     public
233     returns (bytes32 id){
234         uint price = oraclize.getPrice(datasource, gaslimit);
235         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
236         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
237     }
238 
239     function oraclize_query(string datasource, string[] argN)
240     internal
241     returns (bytes32 id){
242         return oraclize_query(0, datasource, argN);
243     }
244 
245     function oraclize_query(uint timestamp, string datasource, string[] argN)
246     internal
247     returns (bytes32 id){
248         uint price = oraclize.getPrice(datasource);
249         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
250         bytes memory args = stra2cbor(argN);
251         return oraclize.queryN.value(price)(timestamp, datasource, args);
252     }
253 
254     function oraclize_query(string datasource, string[] argN, uint gaslimit)
255     internal
256     returns (bytes32 id){
257         return oraclize_query(0, datasource, argN, gaslimit);
258     }
259 
260     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit)
261     internal
262     returns (bytes32 id){
263         uint price = oraclize.getPrice(datasource, gaslimit);
264         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
265         bytes memory args = stra2cbor(argN);
266         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
267     }
268 
269     function oraclize_cbAddress()
270     public
271     constant
272     returns (address){
273         return oraclize.cbAddress();
274     }
275 
276     function oraclize_setProof(byte proofP)
277     public {
278         return oraclize.setProofType(proofP);
279     }
280 
281     function oraclize_setCustomGasPrice(uint gasPrice)
282     public {
283         return oraclize.setCustomGasPrice(gasPrice);
284     }
285 
286     function oraclize_setConfig(bytes32 config)
287     public {
288         return oraclize.setConfig(config);
289     }
290 
291     function getCodeSize(address _addr)
292     public
293     returns(uint _size) {
294         assembly {
295             _size := extcodesize(_addr)
296         }
297     }
298 
299     function parseAddr(string _a)
300     public
301     returns (address){
302         bytes memory tmp = bytes(_a);
303         uint160 iaddr = 0;
304         uint160 b1;
305         uint160 b2;
306         for (uint i=2; i<2+2*20; i+=2){
307             iaddr *= 256;
308             b1 = uint160(tmp[i]);
309             b2 = uint160(tmp[i+1]);
310             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
311             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
312             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
313             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
314             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
315             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
316             iaddr += (b1*16+b2);
317         }
318         return address(iaddr);
319     }
320 
321     function strCompare(string _a, string _b)
322     public
323     returns (int) {
324         bytes memory a = bytes(_a);
325         bytes memory b = bytes(_b);
326         uint minLength = a.length;
327         if (b.length < minLength) minLength = b.length;
328         for (uint i = 0; i < minLength; i ++)
329             if (a[i] < b[i])
330                 return -1;
331             else if (a[i] > b[i])
332                 return 1;
333         if (a.length < b.length)
334             return -1;
335         else if (a.length > b.length)
336             return 1;
337         else
338             return 0;
339     }
340 
341     function indexOf(string _haystack, string _needle)
342     public
343     returns (int) {
344         bytes memory h = bytes(_haystack);
345         bytes memory n = bytes(_needle);
346         if(h.length < 1 || n.length < 1 || (n.length > h.length))
347             return -1;
348         else if(h.length > (2**128 -1))
349             return -1;
350         else
351         {
352             uint subindex = 0;
353             for (uint i = 0; i < h.length; i ++)
354             {
355                 if (h[i] == n[0])
356                 {
357                     subindex = 1;
358                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
359                     {
360                         subindex++;
361                     }
362                     if(subindex == n.length)
363                         return int(i);
364                 }
365             }
366             return -1;
367         }
368     }
369 
370     function strConcat(string _a, string _b, string _c, string _d, string _e)
371     internal
372     returns (string) {
373         bytes memory _ba = bytes(_a);
374         bytes memory _bb = bytes(_b);
375         bytes memory _bc = bytes(_c);
376         bytes memory _bd = bytes(_d);
377         bytes memory _be = bytes(_e);
378         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
379         bytes memory babcde = bytes(abcde);
380         uint k = 0;
381         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
382         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
383         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
384         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
385         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
386         return string(babcde);
387     }
388 
389     function strConcat(string _a, string _b, string _c, string _d)
390     internal
391     returns (string) {
392         return strConcat(_a, _b, _c, _d, "");
393     }
394 
395     function strConcat(string _a, string _b, string _c)
396     internal
397     returns (string) {
398         return strConcat(_a, _b, _c, "", "");
399     }
400 
401     function strConcat(string _a, string _b)
402     internal
403     returns (string) {
404         return strConcat(_a, _b, "", "", "");
405     }
406 
407     // parseInt
408     function parseInt(string _a)
409     public
410     constant
411     returns (uint) {
412         return parseInt(_a, 0);
413     }
414 
415     // parseInt(parseFloat*10^_b)
416     function parseInt(string _a, uint _b)
417     public
418     constant
419     returns (uint) {
420         bytes memory bresult = bytes(_a);
421         uint mint = 0;
422         bool decimals = false;
423         for (uint i=0; i<bresult.length; i++){
424             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
425                 if (decimals){
426                    if (_b == 0) break;
427                     else _b--;
428                 }
429                 mint *= 10;
430                 mint += uint(bresult[i]) - 48;
431             } else if (bresult[i] == 46) decimals = true;
432         }
433         if (_b > 0) mint *= 10**_b;
434         return mint;
435     }
436 
437     function uint2str(uint i)
438     internal
439     returns (string){
440         if (i == 0) return "0";
441         uint j = i;
442         uint len;
443         while (j != 0){
444             len++;
445             j /= 10;
446         }
447         bytes memory bstr = new bytes(len);
448         uint k = len - 1;
449         while (i != 0){
450             bstr[k--] = byte(48 + i % 10);
451             i /= 10;
452         }
453         return string(bstr);
454     }
455 
456     function stra2cbor(string[] arr)
457     internal
458     returns (bytes) {
459         uint arrlen = arr.length;
460 
461         // get correct cbor output length
462         uint outputlen = 0;
463         bytes[] memory elemArray = new bytes[](arrlen);
464         for (uint i = 0; i < arrlen; i++) {
465             elemArray[i] = (bytes(arr[i]));
466             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
467         }
468         uint ctr = 0;
469         uint cborlen = arrlen + 0x80;
470         outputlen += byte(cborlen).length;
471         bytes memory res = new bytes(outputlen);
472 
473         while (byte(cborlen).length > ctr) {
474             res[ctr] = byte(cborlen)[ctr];
475             ctr++;
476         }
477         for (i = 0; i < arrlen; i++) {
478             res[ctr] = 0x5F;
479             ctr++;
480             for (uint x = 0; x < elemArray[i].length; x++) {
481                 // if there's a bug with larger strings, this may be the culprit
482                 if (x % 23 == 0) {
483                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
484                     elemcborlen += 0x40;
485                     uint lctr = ctr;
486                     while (byte(elemcborlen).length > ctr - lctr) {
487                         res[ctr] = byte(elemcborlen)[ctr - lctr];
488                         ctr++;
489                     }
490                 }
491                 res[ctr] = elemArray[i][x];
492                 ctr++;
493             }
494             res[ctr] = 0xFF;
495             ctr++;
496         }
497         return res;
498     }
499 
500     function b2s(bytes _b)
501     internal
502     returns (string) {
503         bytes memory output = new bytes(_b.length * 2);
504         uint len = output.length;
505 
506         assembly {
507             let i := 0
508             let mem := 0
509             loop:
510                 // isolate octet
511                 0x1000000000000000000000000000000000000000000000000000000000000000
512                 exp(0x10, mod(i, 0x40))
513                 // change offset only if needed
514                 jumpi(skip, gt(mod(i, 0x40), 0))
515                 // save offset mem for reuse
516                 mem := mload(add(_b, add(mul(0x20, div(i, 0x40)), 0x20)))
517             skip:
518                 mem
519                 mul
520                 div
521                 dup1
522                 // check if alpha or numerical, jump if numerical
523                 0x0a
524                 swap1
525                 lt
526                 num
527                 jumpi
528                 // offset alpha char correctly
529                 0x0a
530                 swap1
531                 sub
532             alp:
533                 0x61
534                 add
535                 jump(end)
536             num:
537                 0x30
538                 add
539             end:
540                 add(output, add(0x20, i))
541                 mstore8
542                 i := add(i, 1)
543                 jumpi(loop, gt(len, i))
544         }
545 
546         return string(output);
547     }
548 }
549 // </ORACLIZE_API_LIB>
550 
551 // File: contracts/DogRace.sol
552 
553 //contract DogRace is usingOraclize {
554 contract DogRace {
555     using SafeMath for uint256; 
556 
557     string public constant version = "0.0.5";
558 
559     uint public constant min_bet = 0.1 ether;
560     uint public constant max_bet = 1 ether;
561     uint public constant house_fee_pct = 5;
562     uint public constant claim_period = 30 days;
563 
564     address public owner;   // owner address
565 
566     // Currencies: BTC, ETH, LTC, BCH, XRP
567     uint8 constant dogs_count = 5;
568 
569     // Race states and timing
570     struct chronus_struct {
571         bool  betting_open;     // boolean: check if betting is open
572         bool  race_start;       // boolean: check if race has started
573         bool  race_end;         // boolean: check if race has ended
574         bool  race_voided;      // boolean: check if race has been voided
575         uint  starting_time;    // timestamp of when the race starts
576         uint  betting_duration; // duration of betting period
577         uint  race_duration;    // duration of the race
578     }
579     
580     // Single bet information
581     struct bet_info {
582         uint8 dog;       // Dog on which the bet is made
583         uint amount;    // Amount of the bet
584     }
585 
586     // Dog pool information
587     struct pool_info {
588         uint bets_total;       // total bets amount
589         uint pre;              // start price
590         uint post;             // ending price
591         int delta;             // price delta
592         bool post_check;       // differentiating pre and post prices in oraclize callback
593         bool winner;           // has respective dog won the race?
594     }
595 
596     // Bettor information
597     struct bettor_info {
598         uint bets_total;       // total bets amount
599         bool rewarded;         // if reward was paid to the bettor
600         bet_info[] bets;       // array of bets
601     }
602 
603     mapping (bytes32 => uint) oraclize_query_ids;        // mapping oraclize query IDs => dogs
604     mapping (address => bettor_info) bettors;       // mapping bettor address => bettor information
605     
606     pool_info[dogs_count] pools;                    // pools for each currency
607 
608     chronus_struct chronus;                         // states and timing
609 
610     uint public bets_total = 0;                     // total amount of bets
611     uint public reward_total = 0;                   // total amount to be distributed among winners
612     uint public winning_bets_total = 0;             // total amount of bets in winning pool(s)
613     uint prices_remaining = dogs_count;             // variable to check if all prices are received at the end of the race
614     int max_delta = int256((uint256(1) << 255));    // winner dog(s) delta; initialize to minimal int value
615 
616     // tracking events
617     event OraclizeQuery(string description);
618     event PriceTicker(uint dog, uint price);
619     event Bet(address from, uint256 _value, uint dog);
620     event Reward(address to, uint256 _value);
621     event HouseFee(uint256 _value);
622 
623     // constructor
624     function DogRace() public {
625         owner = msg.sender;
626         oraclizeLib.oraclize_setCustomGasPrice(20000000000 wei); // 20GWei
627     }
628 
629     // modifiers for restricting access to methods
630     modifier onlyOwner {
631         require(owner == msg.sender);
632         _;
633     }
634 
635     modifier duringBetting {
636         require(chronus.betting_open);
637         _;
638     }
639     
640     modifier beforeBetting {
641         require(!chronus.betting_open && !chronus.race_start);
642         _;
643     }
644 
645     modifier afterRace {
646         require(chronus.race_end);
647         _;
648     }
649 
650     // ======== Bettor interface ===============================================================================================
651 
652     // place a bet
653     function place_bet(uint8 dog) external duringBetting payable  {
654         require(msg.value >= min_bet && msg.value <= max_bet && dog < dogs_count);
655 
656         bet_info memory current_bet;
657 
658         // Update bettors info
659         current_bet.amount = msg.value;
660         current_bet.dog = dog;
661         bettors[msg.sender].bets.push(current_bet);
662         bettors[msg.sender].bets_total = bettors[msg.sender].bets_total.add(msg.value);
663 
664         // Update pools info
665         pools[dog].bets_total = pools[dog].bets_total.add(msg.value);
666 
667         bets_total = bets_total.add(msg.value);
668 
669         Bet(msg.sender, msg.value, dog);
670     }
671 
672     // fallback method for accepting payments
673     function () private payable {}
674 
675     // method to check the reward amount
676     function check_reward() afterRace external constant returns (uint) {
677         return bettor_reward(msg.sender);
678     }
679 
680     // method to claim the reward
681     function claim_reward() afterRace external {
682         require(!bettors[msg.sender].rewarded);
683         
684         uint reward = bettor_reward(msg.sender);
685         require(reward > 0 && this.balance >= reward);
686         
687         bettors[msg.sender].rewarded = true;
688         msg.sender.transfer(reward);
689 
690         Reward(msg.sender, reward);
691     }
692 
693     // ============================================================================================================================
694 
695     //oraclize callback method
696     function __callback(bytes32 myid, string result) public {
697         require (msg.sender == oraclizeLib.oraclize_cbAddress());
698 
699         chronus.race_start = true;
700         chronus.betting_open = false;
701         uint dog_index = oraclize_query_ids[myid];
702         require(dog_index > 0);                 // Check if the query id is known
703         dog_index--;
704         oraclize_query_ids[myid] = 0;                // Prevent duplicate callbacks
705 
706         if (!pools[dog_index].post_check) {
707             pools[dog_index].pre = oraclizeLib.parseInt(result, 3); // from Oraclize
708             pools[dog_index].post_check = true;        // next check for the coin will be ending price check
709 
710             PriceTicker(dog_index, pools[dog_index].pre);
711         } else {
712             pools[dog_index].post = oraclizeLib.parseInt(result, 3); // from Oraclize
713             // calculating the difference in price with a precision of 5 digits
714             pools[dog_index].delta = int(pools[dog_index].post - pools[dog_index].pre) * 10000 / int(pools[dog_index].pre);
715             if (max_delta < pools[dog_index].delta) {
716                 max_delta = pools[dog_index].delta;
717             }
718             
719             PriceTicker(dog_index, pools[dog_index].post);
720             
721             prices_remaining--;                    // How many end prices are to be received
722             if (prices_remaining == 0) {           // If all end prices have been received, then process rewards
723                 end_race();
724             }
725         }
726     }
727 
728     // calculate bettor's reward
729     function bettor_reward(address candidate) internal afterRace constant returns(uint reward) {
730         bettor_info storage bettor = bettors[candidate];
731 
732         if (chronus.race_voided) {
733             reward = bettor.bets_total;
734         } else {
735             if (reward_total == 0) {
736                 return 0;
737             }
738             uint winning_bets = 0;
739             for (uint i = 0; i < bettor.bets.length; i++) {
740                 if (pools[bettor.bets[i].dog].winner) {
741                     winning_bets = winning_bets.add(bettor.bets[i].amount);
742                 }
743             }
744             reward = reward_total.mul(winning_bets).div(winning_bets_total);
745         }
746     }
747 
748     // ============= DApp interface ==============================================================================================
749 
750     // exposing pool details for DApp
751     function get_pool(uint dog) external constant returns (uint, uint, uint, int, bool, bool) {
752         return (pools[dog].bets_total, pools[dog].pre, pools[dog].post, pools[dog].delta, pools[dog].post_check, pools[dog].winner);
753     }
754 
755     // exposing chronus for DApp
756     function get_chronus() external constant returns (bool, bool, bool, bool, uint, uint, uint) {
757         return (chronus.betting_open, chronus.race_start, chronus.race_end, chronus.race_voided, chronus.starting_time, chronus.betting_duration, chronus.race_duration);
758     }
759 
760     // exposing bettor info for DApp
761     function get_bettor_nfo() external constant returns (uint, uint, bool) {
762         bettor_info info = bettors[msg.sender];
763         return (info.bets_total, info.bets.length, info.rewarded);
764     }
765 
766     // exposing bets info for DApp
767     function get_bet_nfo(uint bet_num) external constant returns (uint, uint) {
768         bettor_info info = bettors[msg.sender];
769         bet_info b_info = info.bets[bet_num];
770         return (b_info.dog, b_info.amount);
771     }
772 
773     // =========== race lifecycle management functions ================================================================================
774 
775     // place the oraclize queries and open betting
776     function setup_race(uint betting_period, uint racing_period) public onlyOwner beforeBetting payable returns(bool) {
777         // We have to send 2 queries for each dog; check if we have enough ether for this
778         require (oraclizeLib.oraclize_getPrice("URL", 500000) * 2 * dogs_count < this.balance);
779 
780         chronus.starting_time = block.timestamp;
781         chronus.betting_open = true;
782         
783         uint delay = betting_period.add(60); //slack time 1 minute
784         chronus.betting_duration = delay;
785 
786         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd", 500000)] = 1;
787         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd", 500000)] = 2;
788         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd", 500000)] = 3;
789         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin-cash/).0.price_usd", 500000)] = 4;
790         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ripple/).0.price_usd", 500000)] = 5;
791 
792         delay = delay.add(racing_period);
793 
794         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd", 500000)] = 1;
795         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd", 500000)] = 2;
796         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd", 500000)] = 3;
797         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin-cash/).0.price_usd", 500000)] = 4;
798         oraclize_query_ids[oraclizeLib.oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ripple/).0.price_usd", 500000)] = 5;
799 
800         OraclizeQuery("Oraclize queries were sent");
801         
802         chronus.race_duration = delay;
803 
804         return true;
805     }
806 
807     // end race and transfer house fee (called internally by callback)
808     function end_race() internal {
809 
810         chronus.race_end = true;
811 
812         // calculate winning pool(s) and their total amount
813         for (uint dog = 0; dog < dogs_count; dog++) {
814             if (pools[dog].delta == max_delta) {
815                 pools[dog].winner = true;
816                 winning_bets_total = winning_bets_total.add(pools[dog].bets_total);
817             }
818         }
819 
820         // calculate house fee and transfer it to contract owner
821         uint house_fee;
822 
823         if (winning_bets_total == 0) {              // No winners => house takes all the money
824             reward_total = 0;
825             house_fee = this.balance;
826         } else {
827             if (winning_bets_total == bets_total) {     // All the bettors are winners => void the race => no house fee; everyone gets their bets back
828                 chronus.race_voided = true;
829                 house_fee = 0;
830             } else {
831                 house_fee = bets_total.mul(house_fee_pct).div(100);         // calculate house fee as % of total bets
832             }
833             reward_total = bets_total.sub(house_fee);                       // subtract house_fee from total reward
834             house_fee = this.balance.sub(reward_total);                    // this.balance will also include remains of kickcstart ether
835         }
836 
837         HouseFee(house_fee);
838         owner.transfer(house_fee);
839     }
840 
841     // in case of any errors in race, enable full refund for the bettors to claim
842     function void_race() external onlyOwner {
843         require(now > chronus.starting_time + chronus.race_duration);
844         require((chronus.betting_open && !chronus.race_start)
845             || (chronus.race_start && !chronus.race_end));
846         chronus.betting_open = false;
847         chronus.race_voided = true;
848         chronus.race_end = true;
849     }
850 
851     // method to retrieve unclaimed winnings after claim period has ended
852     function recover_unclaimed_bets() external onlyOwner {
853         require(now > chronus.starting_time + chronus.race_duration + claim_period);
854         require(chronus.race_end);
855         owner.transfer(this.balance);
856     }
857 
858     // selfdestruct (returns balance to the owner)
859     function kill() external onlyOwner {
860         selfdestruct(msg.sender);
861     }
862 }