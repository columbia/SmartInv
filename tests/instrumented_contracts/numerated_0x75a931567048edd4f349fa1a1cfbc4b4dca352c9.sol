1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani
4 
5 
6 
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 
14 
15 
16 The above copyright notice and this permission notice shall be included in
17 all copies or substantial portions of the Software.
18 
19 
20 
21 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
22 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
23 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
24 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
25 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
26 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
27 THE SOFTWARE.
28 */
29 
30 contract OraclizeI {
31     address public cbAddress;
32     function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
33     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
34     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
35     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
36     function getPrice(string _datasource) returns (uint _dsprice);
37     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
38     function useCoupon(string _coupon);
39     function setProofType(byte _proofType);
40     function setCustomGasPrice(uint _gasPrice);
41 }
42 contract OraclizeAddrResolverI {
43     function getAddress() returns (address _addr);
44 }
45 contract usingOraclize {
46     uint constant day = 60*60*24;
47     uint constant week = 60*60*24*7;
48     uint constant month = 60*60*24*30;
49     byte constant proofType_NONE = 0x00;
50     byte constant proofType_TLSNotary = 0x10;
51     byte constant proofStorage_IPFS = 0x01;
52     uint8 constant networkID_auto = 0;
53     uint8 constant networkID_mainnet = 1;
54     uint8 constant networkID_testnet = 2;
55     uint8 constant networkID_morden = 2;
56     uint8 constant networkID_consensys = 161;
57 
58     OraclizeAddrResolverI OAR;
59 
60     OraclizeI oraclize;
61     modifier oraclizeAPI {
62         address oraclizeAddr = OAR.getAddress();
63         if (oraclizeAddr == 0){
64             oraclize_setNetwork(networkID_auto);
65             oraclizeAddr = OAR.getAddress();
66         }
67         oraclize = OraclizeI(oraclizeAddr);
68         _
69     }
70     modifier coupon(string code){
71         oraclize = OraclizeI(OAR.getAddress());
72         oraclize.useCoupon(code);
73         _
74     }
75 
76     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
77         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
78             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
79             return true;
80         }
81         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
82             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
83             return true;
84         }
85         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
86             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
87             return true;
88         }
89         return false;
90     }
91 
92     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
93         uint price = oraclize.getPrice(datasource);
94         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
95         return oraclize.query.value(price)(0, datasource, arg);
96     }
97     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
98         uint price = oraclize.getPrice(datasource);
99         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
100         return oraclize.query.value(price)(timestamp, datasource, arg);
101     }
102     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
103         uint price = oraclize.getPrice(datasource, gaslimit);
104         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
105         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
106     }
107     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource, gaslimit);
109         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
110         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
111     }
112     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
113         uint price = oraclize.getPrice(datasource);
114         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
115         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
116     }
117     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
118         uint price = oraclize.getPrice(datasource);
119         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
120         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
121     }
122     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource, gaslimit);
124         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
125         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
126     }
127     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource, gaslimit);
129         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
130         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
131     }
132     function oraclize_cbAddress() oraclizeAPI internal returns (address){
133         return oraclize.cbAddress();
134     }
135     function oraclize_setProof(byte proofP) oraclizeAPI internal {
136         return oraclize.setProofType(proofP);
137     }
138     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
139         return oraclize.setCustomGasPrice(gasPrice);
140     }
141 
142     function getCodeSize(address _addr) constant internal returns(uint _size) {
143         assembly {
144             _size := extcodesize(_addr)
145         }
146     }
147 
148 
149     function parseAddr(string _a) internal returns (address){
150         bytes memory tmp = bytes(_a);
151         uint160 iaddr = 0;
152         uint160 b1;
153         uint160 b2;
154         for (uint i=2; i<2+2*20; i+=2){
155             iaddr *= 256;
156             b1 = uint160(tmp[i]);
157             b2 = uint160(tmp[i+1]);
158             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
159             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
160             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
161             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
162             iaddr += (b1*16+b2);
163         }
164         return address(iaddr);
165     }
166 
167 
168     function strCompare(string _a, string _b) internal returns (int) {
169         bytes memory a = bytes(_a);
170         bytes memory b = bytes(_b);
171         uint minLength = a.length;
172         if (b.length < minLength) minLength = b.length;
173         for (uint i = 0; i < minLength; i ++)
174             if (a[i] < b[i])
175                 return -1;
176             else if (a[i] > b[i])
177                 return 1;
178         if (a.length < b.length)
179             return -1;
180         else if (a.length > b.length)
181             return 1;
182         else
183             return 0;
184    }
185 
186     function indexOf(string _haystack, string _needle) internal returns (int)
187     {
188         bytes memory h = bytes(_haystack);
189         bytes memory n = bytes(_needle);
190         if(h.length < 1 || n.length < 1 || (n.length > h.length))
191             return -1;
192         else if(h.length > (2**128 -1))
193             return -1;
194         else
195         {
196             uint subindex = 0;
197             for (uint i = 0; i < h.length; i ++)
198             {
199                 if (h[i] == n[0])
200                 {
201                     subindex = 1;
202                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
203                     {
204                         subindex++;
205                     }
206                     if(subindex == n.length)
207                         return int(i);
208                 }
209             }
210             return -1;
211         }
212     }
213 
214     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
215         bytes memory _ba = bytes(_a);
216         bytes memory _bb = bytes(_b);
217         bytes memory _bc = bytes(_c);
218         bytes memory _bd = bytes(_d);
219         bytes memory _be = bytes(_e);
220         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
221         bytes memory babcde = bytes(abcde);
222         uint k = 0;
223         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
224         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
225         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
226         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
227         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
228         return string(babcde);
229     }
230 
231     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
232         return strConcat(_a, _b, _c, _d, "");
233     }
234 
235     function strConcat(string _a, string _b, string _c) internal returns (string) {
236         return strConcat(_a, _b, _c, "", "");
237     }
238 
239     function strConcat(string _a, string _b) internal returns (string) {
240         return strConcat(_a, _b, "", "", "");
241     }
242 
243     // parseInt
244     function parseInt(string _a) internal returns (uint) {
245         return parseInt(_a, 0);
246     }
247 
248     // parseInt(parseFloat*10^_b)
249     function parseInt(string _a, uint _b) internal returns (uint) {
250         bytes memory bresult = bytes(_a);
251         uint mint = 0;
252         bool decimals = false;
253         for (uint i=0; i<bresult.length; i++){
254             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
255                 if (decimals){
256                    if (_b == 0) break;
257                     else _b--;
258                 }
259                 mint *= 10;
260                 mint += uint(bresult[i]) - 48;
261             } else if (bresult[i] == 46) decimals = true;
262         }
263         if (_b > 0) mint *= 10**_b;
264         return mint;
265     }
266 
267 
268 }
269 // </ORACLIZE_API>
270 
271 contract Dice is usingOraclize {
272 
273     uint public pwin = 5000; //probability of winning (10000 = 100%)
274     uint public edge = 200; //edge percentage (10000 = 100%)
275     uint public maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
276     uint public minBet = 1 finney;
277     uint public maxInvestors = 5; //maximum number of investors
278     uint public houseEdge = 50; //edge percentage (10000 = 100%)
279     uint public divestFee = 50; //divest fee percentage (10000 = 100%)
280     uint public emergencyWithdrawalRatio = 90; //ratio percentage (100 = 100%)
281 
282     uint safeGas = 25000;
283     uint constant ORACLIZE_GAS_LIMIT = 125000;
284     uint constant INVALID_BET_MARKER = 99999;
285     uint constant EMERGENCY_TIMEOUT = 7 days;
286 
287     struct Investor {
288         address investorAddress;
289         uint amountInvested;
290         bool votedForEmergencyWithdrawal;
291     }
292 
293     struct Bet {
294         address playerAddress;
295         uint amountBetted;
296         uint numberRolled;
297     }
298 
299     struct WithdrawalProposal {
300         address toAddress;
301         uint atTime;
302     }
303 
304     //Starting at 1
305     mapping(address => uint) public investorIDs;
306     mapping(uint => Investor) public investors;
307     uint public numInvestors = 0;
308 
309     uint public invested = 0;
310 
311     address owner;
312     address houseAddress;
313     bool public isStopped;
314 
315     WithdrawalProposal public proposedWithdrawal;
316 
317     mapping (bytes32 => Bet) bets;
318     bytes32[] betsKeys;
319 
320     uint public amountWagered = 0;
321     uint public investorsProfit = 0;
322     uint public investorsLoses = 0;
323     bool profitDistributed;
324 
325     event BetWon(address playerAddress, uint numberRolled, uint amountWon);
326     event BetLost(address playerAddress, uint numberRolled);
327     event EmergencyWithdrawalProposed();
328     event EmergencyWithdrawalFailed(address withdrawalAddress);
329     event EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
330     event FailedSend(address receiver, uint amount);
331     event ValueIsTooBig();
332 
333     function Dice(uint pwinInitial,
334                   uint edgeInitial,
335                   uint maxWinInitial,
336                   uint minBetInitial,
337                   uint maxInvestorsInitial,
338                   uint houseEdgeInitial,
339                   uint divestFeeInitial,
340                   uint emergencyWithdrawalRatioInitial
341                   ) {
342 
343         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
344 
345         pwin = pwinInitial;
346         edge = edgeInitial;
347         maxWin = maxWinInitial;
348         minBet = minBetInitial;
349         maxInvestors = maxInvestorsInitial;
350         houseEdge = houseEdgeInitial;
351         divestFee = divestFeeInitial;
352         emergencyWithdrawalRatio = emergencyWithdrawalRatioInitial;
353         owner = msg.sender;
354         houseAddress = msg.sender;
355     }
356 
357     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
358 
359     //MODIFIERS
360 
361     modifier onlyIfNotStopped {
362         if (isStopped) throw;
363         _
364     }
365 
366     modifier onlyIfStopped {
367         if (!isStopped) throw;
368         _
369     }
370 
371     modifier onlyInvestors {
372         if (investorIDs[msg.sender] == 0) throw;
373         _
374     }
375 
376     modifier onlyNotInvestors {
377         if (investorIDs[msg.sender] != 0) throw;
378         _
379     }
380 
381     modifier onlyOwner {
382         if (owner != msg.sender) throw;
383         _
384     }
385 
386     modifier onlyOraclize {
387         if (msg.sender != oraclize_cbAddress()) throw;
388         _
389     }
390 
391     modifier onlyMoreThanMinInvestment {
392         if (msg.value <= getMinInvestment()) throw;
393         _
394     }
395 
396     modifier onlyMoreThanZero {
397         if (msg.value == 0) throw;
398         _
399     }
400 
401     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
402         Bet thisBet = bets[myid];
403         if ((((thisBet.amountBetted * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)) {
404              _
405         }
406         else {
407             bets[myid].numberRolled = INVALID_BET_MARKER;
408             safeSend(thisBet.playerAddress, thisBet.amountBetted);
409             return;
410         }
411     }
412 
413     modifier onlyIfValidRoll(bytes32 myid, string result) {
414         Bet thisBet = bets[myid];
415         uint numberRolled = parseInt(result);
416         if ((numberRolled < 1 || numberRolled > 10000) && thisBet.numberRolled == 0) {
417             bets[myid].numberRolled = INVALID_BET_MARKER;
418             safeSend(thisBet.playerAddress, thisBet.amountBetted);
419             return;
420         }
421         _
422     }
423 
424     modifier onlyIfInvestorBalanceIsPositive(address currentInvestor) {
425         if (getBalance(currentInvestor) >= 0) {
426             _
427         }
428     }
429 
430     modifier onlyWinningBets(uint numberRolled) {
431         if (numberRolled - 1 < pwin) {
432             _
433         }
434     }
435 
436     modifier onlyLosingBets(uint numberRolled) {
437         if (numberRolled - 1 >= pwin) {
438             _
439         }
440     }
441 
442     modifier onlyAfterProposed {
443         if (proposedWithdrawal.toAddress == 0) throw;
444         _
445     }
446 
447     modifier rejectValue {
448         if (msg.value != 0) throw;
449         _
450     }
451 
452     modifier onlyIfProfitNotDistributed {
453         if (!profitDistributed) {
454             _
455         }
456     }
457 
458     modifier onlyIfValidGas(uint newGasLimit) {
459         if (newGasLimit < 25000) throw;
460         _
461     }
462 
463     modifier onlyIfNotProcessed(bytes32 myid) {
464         Bet thisBet = bets[myid];
465         if (thisBet.numberRolled > 0) throw;
466         _
467     }
468 
469     modifier onlyIfEmergencyTimeOutHasPassed {
470         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
471         _
472     }
473 
474 
475     //CONSTANT HELPER FUNCTIONS
476 
477     function getBankroll() constant returns(uint) {
478         return invested + investorsProfit - investorsLoses;
479     }
480 
481     function getMinInvestment() constant returns(uint) {
482         if (numInvestors == maxInvestors) {
483             uint investorID = searchSmallestInvestor();
484             return getBalance(investors[investorID].investorAddress);
485         }
486         else {
487             return 0;
488         }
489     }
490 
491     function getStatus() constant returns(uint, uint, uint, uint, uint, uint, uint, uint, uint) {
492 
493         uint bankroll = getBankroll();
494 
495         uint minInvestment = getMinInvestment();
496 
497         return (bankroll, pwin, edge, maxWin, minBet, amountWagered, (investorsProfit - investorsLoses), minInvestment, betsKeys.length);
498     }
499 
500     function getBet(uint id) constant returns(address, uint, uint) {
501         if (id < betsKeys.length) {
502             bytes32 betKey = betsKeys[id];
503             return (bets[betKey].playerAddress, bets[betKey].amountBetted, bets[betKey].numberRolled);
504         }
505     }
506 
507     function numBets() constant returns(uint) {
508         return betsKeys.length;
509     }
510 
511     function getMinBetAmount() constant returns(uint) {
512         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
513         return oraclizeFee + minBet;
514     }
515 
516     function getMaxBetAmount() constant returns(uint) {
517         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
518         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
519         return betValue + oraclizeFee;
520     }
521 
522     function getLosesShare(address currentInvestor) constant returns (uint) {
523         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLoses) / invested;
524     }
525 
526     function getProfitShare(address currentInvestor) constant returns (uint) {
527         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
528     }
529 
530     function getBalance(address currentInvestor) constant returns (uint) {
531         return investors[investorIDs[currentInvestor]].amountInvested + getProfitShare(currentInvestor) - getLosesShare(currentInvestor);
532     }
533 
534     function searchSmallestInvestor() constant returns(uint) {
535         uint investorID = 1;
536         for (uint i = 1; i <= numInvestors; i++) {
537             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
538                 investorID = i;
539             }
540         }
541 
542         return investorID;
543     }
544 
545     // PRIVATE HELPERS FUNCTION
546 
547     function safeSend(address addr, uint value) private {
548         if (this.balance < value) {
549             ValueIsTooBig();
550             return;
551         }
552 
553         if (!(addr.call.gas(safeGas).value(value)())) {
554             FailedSend(addr, value);
555             if (addr != houseAddress) {
556                 //Forward to house address all change
557                 if (!(houseAddress.call.gas(safeGas).value(value)())) FailedSend(houseAddress, value);
558             }
559         }
560     }
561 
562     function addInvestorAtID(uint id) private {
563         investorIDs[msg.sender] = id;
564         investors[id].investorAddress = msg.sender;
565         investors[id].amountInvested = msg.value;
566         invested += msg.value;
567     }
568 
569     function profitDistribution() private onlyIfProfitNotDistributed {
570         uint copyInvested;
571 
572         for (uint i = 1; i <= numInvestors; i++) {
573             address currentInvestor = investors[i].investorAddress;
574             uint profitOfInvestor = getProfitShare(currentInvestor);
575             uint losesOfInvestor = getLosesShare(currentInvestor);
576             investors[i].amountInvested += profitOfInvestor - losesOfInvestor;
577             copyInvested += investors[i].amountInvested;
578         }
579 
580         delete investorsProfit;
581         delete investorsLoses;
582         invested = copyInvested;
583 
584         profitDistributed = true;
585     }
586 
587     // SECTION II: BET & BET PROCESSING
588 
589     function() {
590         bet();
591     }
592 
593     function bet() onlyIfNotStopped onlyMoreThanZero {
594         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
595         uint betValue = msg.value - oraclizeFee;
596         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
597             // encrypted arg: '\n{"jsonrpc":2.0,"method":"generateSignedIntegers","params":{"apiKey":"YOUR_API_KEY","n":1,"min":1,"max":10000},"id":1}'
598             bytes32 myid = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0","BEcosMZz8Ae1B5UK80b8W1Lz0TQJiaaOFzYqDf00FtJ3Nqy6C4JgY4KlavaMh+QDQRHJrBDHBznTT+GClNKbeSAv8THZDdyIR58a4GME53+OI1VNoV0SzpKwdVWkVrQnrHr8VyzMFd8XrqicVlN5fcC+39WqzEKaSguPaWotB5XSfgTaj1t/0b6P+V3ma+AIXVbacP7MOeFq/dA4Y80KhYZalvdnau9KUX4YJX9oAw5fSExp++1MhEzmda0RMpU5MPm2OrbdJOnOVD3C3DYxWFXGZXImYBRCzp8f7Fhc6+U=", ORACLIZE_GAS_LIMIT + safeGas);
599             bets[myid] = Bet(msg.sender, betValue, 0);
600             betsKeys.push(myid);
601         }
602         else {
603             throw;
604         }
605     }
606 
607     function __callback (bytes32 myid, string result, bytes proof)
608         onlyOraclize
609         onlyIfNotProcessed(myid)
610         onlyIfValidRoll(myid, result)
611         onlyIfBetSizeIsStillCorrect(myid)  {
612 
613         Bet thisBet = bets[myid];
614         uint numberRolled = parseInt(result);
615         bets[myid].numberRolled = numberRolled;
616         isWinningBet(thisBet, numberRolled);
617         isLosingBet(thisBet, numberRolled);
618         amountWagered += thisBet.amountBetted;
619         delete profitDistributed;
620     }
621 
622     function isWinningBet(Bet thisBet, uint numberRolled) private onlyWinningBets(numberRolled) {
623         uint winAmount = (thisBet.amountBetted * (10000 - edge)) / pwin;
624         BetWon(thisBet.playerAddress, numberRolled, winAmount);
625         safeSend(thisBet.playerAddress, winAmount);
626         investorsLoses += (winAmount - thisBet.amountBetted);
627     }
628 
629     function isLosingBet(Bet thisBet, uint numberRolled) private onlyLosingBets(numberRolled) {
630         BetLost(thisBet.playerAddress, numberRolled);
631         safeSend(thisBet.playerAddress, 1);
632         investorsProfit += (thisBet.amountBetted - 1)*(10000 - houseEdge)/10000;
633         uint houseProfit = (thisBet.amountBetted - 1)*(houseEdge)/10000;
634         safeSend(houseAddress, houseProfit);
635     }
636 
637     //SECTION III: INVEST & DIVEST
638 
639     function increaseInvestment() onlyIfNotStopped onlyMoreThanZero onlyInvestors  {
640         profitDistribution();
641         investors[investorIDs[msg.sender]].amountInvested += msg.value;
642         invested += msg.value;
643     }
644 
645     function newInvestor()
646         onlyIfNotStopped
647         onlyMoreThanZero
648         onlyNotInvestors
649         onlyMoreThanMinInvestment {
650 
651         profitDistribution();
652 
653         if (numInvestors == maxInvestors) {
654             uint smallestInvestorID = searchSmallestInvestor();
655             divest(investors[smallestInvestorID].investorAddress);
656         }
657 
658         numInvestors++;
659         addInvestorAtID(numInvestors);
660     }
661 
662     function divest() onlyInvestors rejectValue {
663         divest(msg.sender);
664     }
665 
666 
667     function divest(address currentInvestor)
668         private
669         onlyIfInvestorBalanceIsPositive(currentInvestor) {
670 
671         profitDistribution();
672         uint currentID = investorIDs[currentInvestor];
673         uint amountToReturn = getBalance(currentInvestor);
674         invested -= investors[currentID].amountInvested;
675         uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
676         amountToReturn -= divestFeeAmount;
677 
678         delete investors[currentID];
679         delete investorIDs[currentInvestor];
680         //Reorder investors
681 
682         if (currentID != numInvestors) {
683             // Get last investor
684             Investor lastInvestor = investors[numInvestors];
685             //Set last investor ID to investorID of divesting account
686             investorIDs[lastInvestor.investorAddress] = currentID;
687             //Copy investor at the new position in the mapping
688             investors[currentID] = lastInvestor;
689             //Delete old position in the mappping
690             delete investors[numInvestors];
691         }
692 
693         numInvestors--;
694         safeSend(currentInvestor, amountToReturn);
695         safeSend(houseAddress, divestFeeAmount);
696     }
697 
698     function forceDivestOfAllInvestors() onlyOwner rejectValue {
699         uint copyNumInvestors = numInvestors;
700         for (uint i = 1; i <= copyNumInvestors; i++) {
701             divest(investors[1].investorAddress);
702         }
703     }
704 
705     /*
706     The owner can use this function to force the exit of an investor from the
707     contract during an emergency withdrawal in the following situations:
708         - Unresponsive investor
709         - Investor demanding to be paid in other to vote, the facto-blackmailing
710         other investors
711     */
712     function forceDivestOfOneInvestor(address currentInvestor)
713         onlyOwner
714         onlyIfStopped
715         rejectValue {
716 
717         divest(currentInvestor);
718         //Resets emergency withdrawal proposal. Investors must vote again
719         delete proposedWithdrawal;
720     }
721 
722     //SECTION IV: CONTRACT MANAGEMENT
723 
724     function stopContract() onlyOwner rejectValue {
725         isStopped = true;
726     }
727 
728     function resumeContract() onlyOwner rejectValue {
729         isStopped = false;
730     }
731 
732     function changeHouseAddress(address newHouse) onlyOwner rejectValue {
733         houseAddress = newHouse;
734     }
735 
736     function changeOwnerAddress(address newOwner) onlyOwner rejectValue {
737         owner = newOwner;
738     }
739 
740     function changeGasLimitOfSafeSend(uint newGasLimit)
741         onlyOwner
742         onlyIfValidGas(newGasLimit)
743         rejectValue {
744         safeGas = newGasLimit;
745     }
746 
747     //SECTION V: EMERGENCY WITHDRAWAL
748 
749     function voteEmergencyWithdrawal(bool vote)
750         onlyInvestors
751         onlyAfterProposed
752         onlyIfStopped
753         rejectValue {
754         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
755     }
756 
757     function proposeEmergencyWithdrawal(address withdrawalAddress)
758         onlyIfStopped
759         onlyOwner
760         rejectValue {
761 
762         //Resets previous votes
763         for (uint i = 1; i <= numInvestors; i++) {
764             delete investors[i].votedForEmergencyWithdrawal;
765         }
766 
767         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
768         EmergencyWithdrawalProposed();
769     }
770 
771     function executeEmergencyWithdrawal()
772         onlyOwner
773         onlyAfterProposed
774         onlyIfStopped
775         onlyIfEmergencyTimeOutHasPassed
776         rejectValue {
777 
778         uint numOfVotesInFavour;
779         uint amountToWithdrawal = this.balance;
780 
781         for (uint i = 1; i <= numInvestors; i++) {
782             if (investors[i].votedForEmergencyWithdrawal == true) {
783                 numOfVotesInFavour++;
784                 delete investors[i].votedForEmergencyWithdrawal;
785             }
786         }
787 
788         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
789             if (!proposedWithdrawal.toAddress.send(this.balance)) {
790                 EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
791             }
792             else {
793                 EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdrawal);
794             }
795         }
796         else {
797             throw;
798         }
799     }
800 
801 }