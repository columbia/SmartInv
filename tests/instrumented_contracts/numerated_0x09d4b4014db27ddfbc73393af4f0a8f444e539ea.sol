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
40 }
41 contract OraclizeAddrResolverI {
42     function getAddress() returns (address _addr);
43 }
44 contract usingOraclize {
45     uint constant day = 60*60*24;
46     uint constant week = 60*60*24*7;
47     uint constant month = 60*60*24*30;
48     byte constant proofType_NONE = 0x00;
49     byte constant proofType_TLSNotary = 0x10;
50     byte constant proofStorage_IPFS = 0x01;
51     uint8 constant networkID_auto = 0;
52     uint8 constant networkID_mainnet = 1;
53     uint8 constant networkID_testnet = 2;
54     uint8 constant networkID_morden = 2;
55     uint8 constant networkID_consensys = 161;
56 
57     OraclizeAddrResolverI OAR;
58 
59     OraclizeI oraclize;
60     modifier oraclizeAPI {
61         address oraclizeAddr = OAR.getAddress();
62         if (oraclizeAddr == 0){
63             oraclize_setNetwork(networkID_auto);
64             oraclizeAddr = OAR.getAddress();
65         }
66         oraclize = OraclizeI(oraclizeAddr);
67         _
68     }
69     modifier coupon(string code){
70         oraclize = OraclizeI(OAR.getAddress());
71         oraclize.useCoupon(code);
72         _
73     }
74 
75     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
76         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){
77             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
78             return true;
79         }
80         if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)>0){
81             OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
82             return true;
83         }
84         if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)>0){
85             OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
86             return true;
87         }
88         return false;
89     }
90 
91     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
92         uint price = oraclize.getPrice(datasource);
93         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
94         return oraclize.query.value(price)(0, datasource, arg);
95     }
96     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
97         uint price = oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
99         return oraclize.query.value(price)(timestamp, datasource, arg);
100     }
101     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
102         uint price = oraclize.getPrice(datasource, gaslimit);
103         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
104         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
105     }
106     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
107         uint price = oraclize.getPrice(datasource, gaslimit);
108         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
109         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
110     }
111     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
130     }
131     function oraclize_cbAddress() oraclizeAPI internal returns (address){
132         return oraclize.cbAddress();
133     }
134     function oraclize_setProof(byte proofP) oraclizeAPI internal {
135         return oraclize.setProofType(proofP);
136     }
137 
138     function getCodeSize(address _addr) constant internal returns(uint _size) {
139         assembly {
140             _size := extcodesize(_addr)
141         }
142     }
143 
144 
145     function parseAddr(string _a) internal returns (address){
146         bytes memory tmp = bytes(_a);
147         uint160 iaddr = 0;
148         uint160 b1;
149         uint160 b2;
150         for (uint i=2; i<2+2*20; i+=2){
151             iaddr *= 256;
152             b1 = uint160(tmp[i]);
153             b2 = uint160(tmp[i+1]);
154             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
155             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
156             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
157             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
158             iaddr += (b1*16+b2);
159         }
160         return address(iaddr);
161     }
162 
163 
164     function strCompare(string _a, string _b) internal returns (int) {
165         bytes memory a = bytes(_a);
166         bytes memory b = bytes(_b);
167         uint minLength = a.length;
168         if (b.length < minLength) minLength = b.length;
169         for (uint i = 0; i < minLength; i ++)
170             if (a[i] < b[i])
171                 return -1;
172             else if (a[i] > b[i])
173                 return 1;
174         if (a.length < b.length)
175             return -1;
176         else if (a.length > b.length)
177             return 1;
178         else
179             return 0;
180    }
181 
182     function indexOf(string _haystack, string _needle) internal returns (int)
183     {
184         bytes memory h = bytes(_haystack);
185         bytes memory n = bytes(_needle);
186         if(h.length < 1 || n.length < 1 || (n.length > h.length))
187             return -1;
188         else if(h.length > (2**128 -1))
189             return -1;
190         else
191         {
192             uint subindex = 0;
193             for (uint i = 0; i < h.length; i ++)
194             {
195                 if (h[i] == n[0])
196                 {
197                     subindex = 1;
198                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
199                     {
200                         subindex++;
201                     }
202                     if(subindex == n.length)
203                         return int(i);
204                 }
205             }
206             return -1;
207         }
208     }
209 
210     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
211         bytes memory _ba = bytes(_a);
212         bytes memory _bb = bytes(_b);
213         bytes memory _bc = bytes(_c);
214         bytes memory _bd = bytes(_d);
215         bytes memory _be = bytes(_e);
216         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
217         bytes memory babcde = bytes(abcde);
218         uint k = 0;
219         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
220         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
221         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
222         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
223         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
224         return string(babcde);
225     }
226 
227     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
228         return strConcat(_a, _b, _c, _d, "");
229     }
230 
231     function strConcat(string _a, string _b, string _c) internal returns (string) {
232         return strConcat(_a, _b, _c, "", "");
233     }
234 
235     function strConcat(string _a, string _b) internal returns (string) {
236         return strConcat(_a, _b, "", "", "");
237     }
238 
239     // parseInt
240     function parseInt(string _a) internal returns (uint) {
241         return parseInt(_a, 0);
242     }
243 
244     // parseInt(parseFloat*10^_b)
245     function parseInt(string _a, uint _b) internal returns (uint) {
246         bytes memory bresult = bytes(_a);
247         uint mint = 0;
248         bool decimals = false;
249         for (uint i=0; i<bresult.length; i++){
250             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
251                 if (decimals){
252                    if (_b == 0) break;
253                     else _b--;
254                 }
255                 mint *= 10;
256                 mint += uint(bresult[i]) - 48;
257             } else if (bresult[i] == 46) decimals = true;
258         }
259         if (_b > 0) mint *= 10**_b;
260         return mint;
261     }
262 
263 
264 }
265 // </ORACLIZE_API>
266 
267 contract Dice is usingOraclize {
268 
269     uint public pwin = 5000; //probability of winning (10000 = 100%)
270     uint public edge = 200; //edge percentage (10000 = 100%)
271     uint public maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
272     uint public minBet = 1 finney;
273     uint public maxInvestors = 5; //maximum number of investors
274     uint public houseEdge = 50; //edge percentage (10000 = 100%)
275     uint public divestFee = 50; //divest fee percentage (10000 = 100%)
276     uint public emergencyWithdrawalRatio = 90; //ratio percentage (100 = 100%)
277 
278     uint safeGas = 25000;
279     uint constant ORACLIZE_GAS_LIMIT = 125000;
280     uint constant INVALID_BET_MARKER = 99999;
281     uint constant EMERGENCY_TIMEOUT = 7 days;
282 
283     struct Investor {
284         address investorAddress;
285         uint amountInvested;
286         bool votedForEmergencyWithdrawal;
287     }
288 
289     struct Bet {
290         address playerAddress;
291         uint amountBetted;
292         uint numberRolled;
293     }
294 
295     struct WithdrawalProposal {
296         address toAddress;
297         uint atTime;
298     }
299 
300     //Starting at 1
301     mapping(address => uint) investorIDs;
302     mapping(uint => Investor) investors;
303     uint public numInvestors = 0;
304 
305     uint public invested = 0;
306 
307     address owner;
308     address houseAddress;
309     bool public isStopped;
310 
311     WithdrawalProposal proposedWithdrawal;
312 
313     mapping (bytes32 => Bet) bets;
314     bytes32[] betsKeys;
315 
316     uint public amountWagered = 0;
317     uint public investorsProfit = 0;
318     uint public investorsLoses = 0;
319     bool profitDistributed;
320 
321     event BetWon(address playerAddress, uint numberRolled, uint amountWon);
322     event BetLost(address playerAddress, uint numberRolled);
323     event EmergencyWithdrawalProposed();
324     event EmergencyWithdrawalFailed(address withdrawalAddress);
325     event EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
326     event FailedSend(address receiver, uint amount);
327     event ValueIsTooBig();
328 
329     function Dice(uint pwinInitial,
330                   uint edgeInitial,
331                   uint maxWinInitial,
332                   uint minBetInitial,
333                   uint maxInvestorsInitial,
334                   uint houseEdgeInitial,
335                   uint divestFeeInitial,
336                   uint emergencyWithdrawalRatioInitial
337                   ) {
338 
339         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
340 
341         pwin = pwinInitial;
342         edge = edgeInitial;
343         maxWin = maxWinInitial;
344         minBet = minBetInitial;
345         maxInvestors = maxInvestorsInitial;
346         houseEdge = houseEdgeInitial;
347         divestFee = divestFeeInitial;
348         emergencyWithdrawalRatio = emergencyWithdrawalRatioInitial;
349         owner = msg.sender;
350         houseAddress = msg.sender;
351     }
352 
353     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
354 
355     //MODIFIERS
356 
357     modifier onlyIfNotStopped {
358         if (isStopped) throw;
359         _
360     }
361 
362     modifier onlyIfStopped {
363         if (!isStopped) throw;
364         _
365     }
366 
367     modifier onlyInvestors {
368         if (investorIDs[msg.sender] == 0) throw;
369         _
370     }
371 
372     modifier onlyNotInvestors {
373         if (investorIDs[msg.sender] != 0) throw;
374         _
375     }
376 
377     modifier onlyOwner {
378         if (owner != msg.sender) throw;
379         _
380     }
381 
382     modifier onlyOraclize {
383         if (msg.sender != oraclize_cbAddress()) throw;
384         _
385     }
386 
387     modifier onlyMoreThanMinInvestment {
388         if (msg.value <= getMinInvestment()) throw;
389         _
390     }
391 
392     modifier onlyMoreThanZero {
393         if (msg.value == 0) throw;
394         _
395     }
396 
397     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
398         Bet thisBet = bets[myid];
399         if ((((thisBet.amountBetted * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)) {
400              _
401         }
402         else {
403             bets[myid].numberRolled = INVALID_BET_MARKER;
404             safeSend(thisBet.playerAddress, thisBet.amountBetted);
405             return;
406         }
407     }
408 
409     modifier onlyIfValidRoll(bytes32 myid, string result) {
410         Bet thisBet = bets[myid];
411         uint numberRolled = parseInt(result);
412         if ((numberRolled < 1 || numberRolled > 10000) && thisBet.numberRolled == 0) {
413             bets[myid].numberRolled = INVALID_BET_MARKER;
414             safeSend(thisBet.playerAddress, thisBet.amountBetted);
415             return;
416         }
417         _
418     }
419 
420     modifier onlyIfInvestorBalanceIsPositive(address currentInvestor) {
421         if (getBalance(currentInvestor) >= 0) {
422             _
423         }
424     }
425 
426     modifier onlyWinningBets(uint numberRolled) {
427         if (numberRolled - 1 < pwin) {
428             _
429         }
430     }
431 
432     modifier onlyLosingBets(uint numberRolled) {
433         if (numberRolled - 1 >= pwin) {
434             _
435         }
436     }
437 
438     modifier onlyAfterProposed {
439         if (proposedWithdrawal.toAddress == 0) throw;
440         _
441     }
442 
443     modifier rejectValue {
444         if (msg.value != 0) throw;
445         _
446     }
447 
448     modifier onlyIfProfitNotDistributed {
449         if (!profitDistributed) {
450             _
451         }
452     }
453 
454     modifier onlyIfValidGas(uint newGasLimit) {
455         if (newGasLimit < 25000) throw;
456         _
457     }
458 
459     modifier onlyIfNotProcessed(bytes32 myid) {
460         Bet thisBet = bets[myid];
461         if (thisBet.numberRolled > 0) throw;
462         _
463     }
464 
465     modifier onlyIfEmergencyTimeOutHasPassed {
466         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
467         _
468     }
469 
470 
471     //CONSTANT HELPER FUNCTIONS
472 
473     function getBankroll() constant returns(uint) {
474         return invested + investorsProfit - investorsLoses;
475     }
476 
477     function getMinInvestment() constant returns(uint) {
478         if (numInvestors == maxInvestors) {
479             uint investorID = searchSmallestInvestor();
480             return getBalance(investors[investorID].investorAddress);
481         }
482         else {
483             return 0;
484         }
485     }
486 
487     function getStatus() constant returns(uint, uint, uint, uint, uint, uint, uint, uint, uint) {
488 
489         uint bankroll = getBankroll();
490 
491         if (this.balance < bankroll) {
492             bankroll = this.balance;
493         }
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
534     // PRIVATE HELPERS FUNCTION
535 
536     function searchSmallestInvestor() private returns(uint) {
537         uint investorID = 1;
538         for (uint i = 1; i <= numInvestors; i++) {
539             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
540                 investorID = i;
541             }
542         }
543 
544         return investorID;
545     }
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
598             bytes32 myid = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0","BK+rmSbo3sio5tjcOIXtPF0iYT1uQQcQpwf5JF9DKv/MpFNt35msnfl+AhZEHxYlZ0/p6s87HG10jRoS0coGTzMOBtpbB5iYU6i7mD7St0QvcCXkUvS7apB5O4eQFAkWwGTgEz1RJ9tbSkXilpgurZ+B+ig9s4g+kwPdsKuWx3+1KVDgNlK8a8DG7KfnIp1QZlDGfZ6wge39cY3BXkFXeoO3ZvUSbBAtyG8f36wx6rwhogQBeBQF6a9HHHlj9AFMj7D2nbf24aMfLyhWri7LIQitVHRs976j8F3T7RHp0gc=", ORACLIZE_GAS_LIMIT + safeGas);
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
650         profitDistribution();
651 
652         if (numInvestors < maxInvestors) {
653             numInvestors++;
654             addInvestorAtID(numInvestors);
655         }
656         else {
657             uint smallestInvestorID = searchSmallestInvestor();
658             divest(investors[smallestInvestorID].investorAddress);
659             addInvestorAtID(smallestInvestorID);
660             numInvestors++;
661         }
662     }
663 
664     function divest() onlyInvestors rejectValue {
665         divest(msg.sender);
666     }
667 
668     function divest(address currentInvestor)
669         private
670         onlyIfInvestorBalanceIsPositive(currentInvestor) {
671 
672         profitDistribution();
673         uint currentID = investorIDs[currentInvestor];
674         uint amountToReturn = getBalance(currentInvestor);
675         invested -= investors[currentID].amountInvested;
676         uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
677         amountToReturn -= divestFeeAmount;
678         //Clean up
679         numInvestors--;
680         delete investors[currentID];
681         delete investorIDs[currentInvestor];
682         safeSend(currentInvestor, amountToReturn);
683         safeSend(houseAddress, divestFeeAmount);
684     }
685 
686     function forceDivestOfAllInvestors() onlyOwner rejectValue {
687         uint copyNumInvestors = numInvestors;
688         for (uint investorID = 1; investorID <= copyNumInvestors; investorID++) {
689             divest(investors[investorID].investorAddress);
690         }
691     }
692 
693     /*
694     The owner can use this function to force the exit of an investor from the
695     contract during an emergency withdrawal in the following situations:
696         - Unresponsive investor
697         - Investor demanding to be paid in other to vote, the facto-blackmailing
698         other investors
699     */
700     function forceDivestOfOneInvestor(address currentInvestor)
701         onlyOwner
702         onlyIfStopped
703         rejectValue {
704 
705         divest(currentInvestor);
706         //Resets emergency withdrawal proposal. Investors must vote again
707         delete proposedWithdrawal;
708     }
709 
710     //SECTION IV: CONTRACT MANAGEMENT
711 
712     function stopContract() onlyOwner rejectValue {
713         isStopped = true;
714     }
715 
716     function resumeContract() onlyOwner rejectValue {
717         isStopped = false;
718     }
719 
720     function changeHouseAddress(address newHouse) onlyOwner rejectValue {
721         houseAddress = newHouse;
722     }
723 
724     function changeOwnerAddress(address newOwner) onlyOwner rejectValue {
725         owner = newOwner;
726     }
727 
728     function changeGasLimitOfSafeSend(uint newGasLimit)
729         onlyOwner
730         onlyIfValidGas(newGasLimit)
731         rejectValue {
732         safeGas = newGasLimit;
733     }
734 
735     //SECTION V: EMERGENCY WITHDRAWAL
736 
737     function voteEmergencyWithdrawal(bool vote)
738         onlyInvestors
739         onlyAfterProposed
740         onlyIfStopped
741         rejectValue {
742         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
743     }
744 
745     function proposeEmergencyWithdrawal(address withdrawalAddress)
746         onlyIfStopped
747         onlyOwner
748         rejectValue {
749 
750         //Resets previous votes
751         for (uint i = 1; i <= numInvestors; i++) {
752             delete investors[i].votedForEmergencyWithdrawal;
753         }
754 
755         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
756         EmergencyWithdrawalProposed();
757     }
758 
759     function executeEmergencyWithdrawal()
760         onlyOwner
761         onlyAfterProposed
762         onlyIfStopped
763         onlyIfEmergencyTimeOutHasPassed
764         rejectValue {
765 
766         uint numOfVotesInFavour;
767         uint amountToWithdrawal = this.balance;
768 
769         for (uint i = 1; i <= numInvestors; i++) {
770             if (investors[i].votedForEmergencyWithdrawal == true) {
771                 numOfVotesInFavour++;
772                 delete investors[i].votedForEmergencyWithdrawal;
773             }
774         }
775 
776         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
777             if (!proposedWithdrawal.toAddress.send(this.balance)) {
778                 EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
779             }
780             else {
781                 EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdrawal);
782             }
783         }
784         else {
785             throw;
786         }
787     }
788 
789 }