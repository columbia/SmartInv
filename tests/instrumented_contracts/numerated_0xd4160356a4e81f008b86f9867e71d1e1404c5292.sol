1 pragma solidity ^0.4.0;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47 }
48 contract OraclizeAddrResolverI {
49     function getAddress() returns (address _addr);
50 }
51 contract usingOraclize {
52     uint constant day = 60*60*24;
53     uint constant week = 60*60*24*7;
54     uint constant month = 60*60*24*30;
55     byte constant proofType_NONE = 0x00;
56     byte constant proofType_TLSNotary = 0x10;
57     byte constant proofStorage_IPFS = 0x01;
58     uint8 constant networkID_auto = 0;
59     uint8 constant networkID_mainnet = 1;
60     uint8 constant networkID_testnet = 2;
61     uint8 constant networkID_morden = 2;
62     uint8 constant networkID_consensys = 161;
63 
64     OraclizeAddrResolverI OAR;
65     
66     OraclizeI oraclize;
67     modifier oraclizeAPI {
68         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
69         oraclize = OraclizeI(OAR.getAddress());
70         _;
71     }
72     modifier coupon(string code){
73         oraclize = OraclizeI(OAR.getAddress());
74         oraclize.useCoupon(code);
75         _;
76     }
77 
78     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
79         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
80             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
81             return true;
82         }
83         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
84             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
85             return true;
86         }
87         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
88             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
89             return true;
90         }
91         return false;
92     }
93     
94     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
95         uint price = oraclize.getPrice(datasource);
96         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
97         return oraclize.query.value(price)(0, datasource, arg);
98     }
99     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
100         uint price = oraclize.getPrice(datasource);
101         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
102         return oraclize.query.value(price)(timestamp, datasource, arg);
103     }
104     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
105         uint price = oraclize.getPrice(datasource, gaslimit);
106         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
107         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
108     }
109     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
110         uint price = oraclize.getPrice(datasource, gaslimit);
111         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
112         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
113     }
114     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
115         uint price = oraclize.getPrice(datasource);
116         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
117         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
118     }
119     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
120         uint price = oraclize.getPrice(datasource);
121         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
122         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
123     }
124     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
125         uint price = oraclize.getPrice(datasource, gaslimit);
126         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
127         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
128     }
129     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource, gaslimit);
131         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
132         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
133     }
134     function oraclize_cbAddress() oraclizeAPI internal returns (address){
135         return oraclize.cbAddress();
136     }
137     function oraclize_setProof(byte proofP) oraclizeAPI internal {
138         return oraclize.setProofType(proofP);
139     }
140     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
141         return oraclize.setCustomGasPrice(gasPrice);
142     }    
143     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
144         return oraclize.setConfig(config);
145     }
146 
147     function getCodeSize(address _addr) constant internal returns(uint _size) {
148         assembly {
149             _size := extcodesize(_addr)
150         }
151     }
152 
153 
154     function parseAddr(string _a) internal returns (address){
155         bytes memory tmp = bytes(_a);
156         uint160 iaddr = 0;
157         uint160 b1;
158         uint160 b2;
159         for (uint i=2; i<2+2*20; i+=2){
160             iaddr *= 256;
161             b1 = uint160(tmp[i]);
162             b2 = uint160(tmp[i+1]);
163             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
164             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
165             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
166             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
167             iaddr += (b1*16+b2);
168         }
169         return address(iaddr);
170     }
171 
172 
173     function strCompare(string _a, string _b) internal returns (int) {
174         bytes memory a = bytes(_a);
175         bytes memory b = bytes(_b);
176         uint minLength = a.length;
177         if (b.length < minLength) minLength = b.length;
178         for (uint i = 0; i < minLength; i ++)
179             if (a[i] < b[i])
180                 return -1;
181             else if (a[i] > b[i])
182                 return 1;
183         if (a.length < b.length)
184             return -1;
185         else if (a.length > b.length)
186             return 1;
187         else
188             return 0;
189    } 
190 
191     function indexOf(string _haystack, string _needle) internal returns (int)
192     {
193         bytes memory h = bytes(_haystack);
194         bytes memory n = bytes(_needle);
195         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
196             return -1;
197         else if(h.length > (2**128 -1))
198             return -1;                                  
199         else
200         {
201             uint subindex = 0;
202             for (uint i = 0; i < h.length; i ++)
203             {
204                 if (h[i] == n[0])
205                 {
206                     subindex = 1;
207                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
208                     {
209                         subindex++;
210                     }   
211                     if(subindex == n.length)
212                         return int(i);
213                 }
214             }
215             return -1;
216         }   
217     }
218 
219     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
220         bytes memory _ba = bytes(_a);
221         bytes memory _bb = bytes(_b);
222         bytes memory _bc = bytes(_c);
223         bytes memory _bd = bytes(_d);
224         bytes memory _be = bytes(_e);
225         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
226         bytes memory babcde = bytes(abcde);
227         uint k = 0;
228         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
229         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
230         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
231         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
232         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
233         return string(babcde);
234     }
235     
236     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
237         return strConcat(_a, _b, _c, _d, "");
238     }
239 
240     function strConcat(string _a, string _b, string _c) internal returns (string) {
241         return strConcat(_a, _b, _c, "", "");
242     }
243 
244     function strConcat(string _a, string _b) internal returns (string) {
245         return strConcat(_a, _b, "", "", "");
246     }
247 
248     // parseInt
249     function parseInt(string _a) internal returns (uint) {
250         return parseInt(_a, 0);
251     }
252 
253     // parseInt(parseFloat*10^_b)
254     function parseInt(string _a, uint _b) internal returns (uint) {
255         bytes memory bresult = bytes(_a);
256         uint mint = 0;
257         bool decimals = false;
258         for (uint i=0; i<bresult.length; i++){
259             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
260                 if (decimals){
261                    if (_b == 0) break;
262                     else _b--;
263                 }
264                 mint *= 10;
265                 mint += uint(bresult[i]) - 48;
266             } else if (bresult[i] == 46) decimals = true;
267         }
268         if (_b > 0) mint *= 10**_b;
269         return mint;
270     }
271     
272     function uint2str(uint i) internal returns (string){
273         if (i == 0) return "0";
274         uint j = i;
275         uint len;
276         while (j != 0){
277             len++;
278             j /= 10;
279         }
280         bytes memory bstr = new bytes(len);
281         uint k = len - 1;
282         while (i != 0){
283             bstr[k--] = byte(48 + i % 10);
284             i /= 10;
285         }
286         return string(bstr);
287     }
288     
289     
290 
291 }
292 // </ORACLIZE_API>
293 
294 contract Dice is usingOraclize {
295 
296     uint constant pwin = 7500; //probability of winning (10000 = 100%)
297     uint constant edge = 190; //edge percentage (10000 = 100%)
298     uint constant maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
299     uint constant minBet = 200 finney;
300     uint constant maxInvestors = 10; //maximum number of investors
301     uint constant houseEdge = 25; //edge percentage (10000 = 100%)
302     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
303     uint constant emergencyWithdrawalRatio = 10; //ratio percentage (100 = 100%)
304 
305     uint safeGas = 2300;
306     uint constant ORACLIZE_GAS_LIMIT = 175000;
307     uint constant INVALID_BET_MARKER = 99999;
308     uint constant EMERGENCY_TIMEOUT = 3 days;
309 
310     struct Investor {
311         address investorAddress;
312         uint amountInvested;
313         bool votedForEmergencyWithdrawal;
314     }
315 
316     struct Bet {
317         address playerAddress;
318         uint amountBet;
319         uint numberRolled;
320     }
321 
322     struct WithdrawalProposal {
323         address toAddress;
324         uint atTime;
325     }
326 
327     //Starting at 1
328     mapping(address => uint) public investorIDs;
329     mapping(uint => Investor) public investors;
330     uint public numInvestors = 0;
331 
332     uint public invested = 0;
333 
334     address public owner;
335     address public houseAddress;
336     bool public isStopped;
337 
338     WithdrawalProposal public proposedWithdrawal;
339 
340     mapping (bytes32 => Bet) public bets;
341     bytes32[] public betsKeys;
342 
343     uint public investorsProfit = 0;
344     uint public investorsLosses = 0;
345     bool profitDistributed;
346 
347     event LOG_NewBet(address playerAddress, uint amount);
348     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
349     event LOG_BetLost(address playerAddress, uint numberRolled);
350     event LOG_EmergencyWithdrawalProposed();
351     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
352     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
353     event LOG_FailedSend(address receiver, uint amount);
354     event LOG_ZeroSend();
355     event LOG_InvestorEntrance(address investor, uint amount);
356     event LOG_InvestorCapitalUpdate(address investor, int amount);
357     event LOG_InvestorExit(address investor, uint amount);
358     event LOG_ContractStopped();
359     event LOG_ContractResumed();
360     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
361     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
362     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
363     event LOG_EmergencyAutoStop();
364     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
365     event LOG_ValueIsTooBig();
366     event LOG_SuccessfulSend(address addr, uint amount);
367 
368     function Dice() {
369         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
370         owner = msg.sender;
371         houseAddress = msg.sender;
372     }
373 
374     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
375 
376     //MODIFIERS
377 
378     modifier onlyIfNotStopped {
379         if (isStopped) throw;
380         _;
381     }
382 
383     modifier onlyIfStopped {
384         if (!isStopped) throw;
385         _;
386     }
387 
388     modifier onlyInvestors {
389         if (investorIDs[msg.sender] == 0) throw;
390         _;
391     }
392 
393     modifier onlyNotInvestors {
394         if (investorIDs[msg.sender] != 0) throw;
395         _;
396     }
397 
398     modifier onlyOwner {
399         if (owner != msg.sender) throw;
400         _;
401     }
402 
403     modifier onlyOraclize {
404         if (msg.sender != oraclize_cbAddress()) throw;
405         _;
406     }
407 
408     modifier onlyMoreThanMinInvestment {
409         if (msg.value <= getMinInvestment()) throw;
410         _;
411     }
412 
413     modifier onlyMoreThanZero {
414         if (msg.value == 0) throw;
415         _;
416     }
417 
418     modifier onlyIfBetExist(bytes32 myid) {
419         if(bets[myid].playerAddress == address(0x0)) throw;
420         _;
421     }
422 
423     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
424         if ((((bets[myid].amountBet * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet)) {
425              _;
426         }
427         else {
428             bets[myid].numberRolled = INVALID_BET_MARKER;
429             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
430             return;
431         }
432     }
433 
434     modifier onlyIfValidRoll(bytes32 myid, string result) {
435         uint numberRolled = parseInt(result);
436         if ((numberRolled < 1 || numberRolled > 10000) && bets[myid].numberRolled == 0) {
437             bets[myid].numberRolled = INVALID_BET_MARKER;
438             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
439             return;
440         }
441         _;
442     }
443 
444     modifier onlyWinningBets(uint numberRolled) {
445         if (numberRolled - 1 < pwin) {
446             _;
447         }
448     }
449 
450     modifier onlyLosingBets(uint numberRolled) {
451         if (numberRolled - 1 >= pwin) {
452             _;
453         }
454     }
455 
456     modifier onlyAfterProposed {
457         if (proposedWithdrawal.toAddress == 0) throw;
458         _;
459     }
460 
461     modifier onlyIfProfitNotDistributed {
462         if (!profitDistributed) {
463             _;
464         }
465     }
466 
467     modifier onlyIfValidGas(uint newGasLimit) {
468         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
469         if (newGasLimit < 25000) throw;
470         _;
471     }
472 
473     modifier onlyIfNotProcessed(bytes32 myid) {
474         if (bets[myid].numberRolled > 0) throw;
475         _;
476     }
477 
478     modifier onlyIfEmergencyTimeOutHasPassed {
479         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
480         _;
481     }
482 
483     modifier investorsInvariant {
484         _;
485         if (numInvestors > maxInvestors) throw;
486     }
487 
488     //CONSTANT HELPER FUNCTIONS
489 
490     function getBankroll()
491         constant
492         returns(uint) {
493 
494         if ((invested < investorsProfit) ||
495             (invested + investorsProfit < invested) ||
496             (invested + investorsProfit < investorsLosses)) {
497             return 0;
498         }
499         else {
500             return invested + investorsProfit - investorsLosses;
501         }
502     }
503 
504     function getMinInvestment()
505         constant
506         returns(uint) {
507 
508         if (numInvestors == maxInvestors) {
509             uint investorID = searchSmallestInvestor();
510             return getBalance(investors[investorID].investorAddress);
511         }
512         else {
513             return 0;
514         }
515     }
516 
517     function getStatus()
518         constant
519         returns(uint, uint, uint, uint, uint, uint, uint, uint) {
520 
521         uint bankroll = getBankroll();
522         uint minInvestment = getMinInvestment();
523         return (bankroll, pwin, edge, maxWin, minBet, (investorsProfit - investorsLosses), minInvestment, betsKeys.length);
524     }
525 
526     function getBet(uint id)
527         constant
528         returns(address, uint, uint) {
529 
530         if (id < betsKeys.length) {
531             bytes32 betKey = betsKeys[id];
532             return (bets[betKey].playerAddress, bets[betKey].amountBet, bets[betKey].numberRolled);
533         }
534     }
535 
536     function numBets()
537         constant
538         returns(uint) {
539 
540         return betsKeys.length;
541     }
542 
543     function getMinBetAmount()
544         constant
545         returns(uint) {
546 
547         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
548         return oraclizeFee + minBet;
549     }
550 
551     function getMaxBetAmount()
552         constant
553         returns(uint) {
554 
555         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
556         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
557         return betValue + oraclizeFee;
558     }
559 
560     function getLossesShare(address currentInvestor)
561         constant
562         returns (uint) {
563 
564         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
565     }
566 
567     function getProfitShare(address currentInvestor)
568         constant
569         returns (uint) {
570 
571         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
572     }
573 
574     function getBalance(address currentInvestor)
575         constant
576         returns (uint) {
577 
578         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
579         uint profit = getProfitShare(currentInvestor);
580         uint losses = getLossesShare(currentInvestor);
581 
582         if ((invested + profit < profit) ||
583             (invested + profit < invested) ||
584             (invested + profit < losses))
585             return 0;
586         else
587             return invested + profit - losses;
588     }
589 
590     function searchSmallestInvestor()
591         constant
592         returns(uint) {
593 
594         uint investorID = 1;
595         for (uint i = 1; i <= numInvestors; i++) {
596             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
597                 investorID = i;
598             }
599         }
600 
601         return investorID;
602     }
603 
604     function changeOraclizeProofType(byte _proofType)
605         onlyOwner {
606 
607         if (_proofType == 0x00) throw;
608         oraclize_setProof( _proofType |  proofStorage_IPFS );
609     }
610 
611     function changeOraclizeConfig(bytes32 _config)
612         onlyOwner {
613 
614         oraclize_setConfig(_config);
615     }
616 
617     // PRIVATE HELPERS FUNCTION
618 
619     function safeSend(address addr, uint value)
620         private {
621 
622         if (value == 0) {
623             LOG_ZeroSend();
624             return;
625         }
626 
627         if (this.balance < value) {
628             LOG_ValueIsTooBig();
629             return;
630         }
631 
632         if (!(addr.call.gas(safeGas).value(value)())) {
633             LOG_FailedSend(addr, value);
634             if (addr != houseAddress) {
635                 //Forward to house address all change
636                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
637             }
638         }
639 
640         LOG_SuccessfulSend(addr,value);
641     }
642 
643     function addInvestorAtID(uint id)
644         private {
645 
646         investorIDs[msg.sender] = id;
647         investors[id].investorAddress = msg.sender;
648         investors[id].amountInvested = msg.value;
649         invested += msg.value;
650 
651         LOG_InvestorEntrance(msg.sender, msg.value);
652     }
653 
654     function profitDistribution()
655         private
656         onlyIfProfitNotDistributed {
657 
658         uint copyInvested;
659 
660         for (uint i = 1; i <= numInvestors; i++) {
661             address currentInvestor = investors[i].investorAddress;
662             uint profitOfInvestor = getProfitShare(currentInvestor);
663             uint lossesOfInvestor = getLossesShare(currentInvestor);
664             //Check for overflow and underflow
665             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
666                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
667                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
668                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
669             }
670             else {
671                 isStopped = true;
672                 LOG_EmergencyAutoStop();
673             }
674 
675             if (copyInvested + investors[i].amountInvested >= copyInvested)
676                 copyInvested += investors[i].amountInvested;
677         }
678 
679         delete investorsProfit;
680         delete investorsLosses;
681         invested = copyInvested;
682 
683         profitDistributed = true;
684     }
685 
686     // SECTION II: BET & BET PROCESSING
687 
688     function()
689         payable {
690 
691         bet();
692     }
693 
694     function bet()
695         payable
696         onlyIfNotStopped {
697 
698         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
699         if (oraclizeFee >= msg.value) throw;
700         uint betValue = msg.value - oraclizeFee;
701         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
702             LOG_NewBet(msg.sender, betValue);
703             bytes32 myid =
704                 oraclize_query(
705                     "nested",
706                     "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BLeDHjdcYMnndkLq59sF0YDm7mMsjcXEfM5flEd/5CjV7qWB+JiHS8oOHv4YZrx0snsbqpAVM70MMo8iE21drLvJ7WaBZIL3gOBqPEPGHuSfbiT5Zwk0Pl4WNKdiLwe4RkB9Vk4/RTvzmRxwc1HMp+fZTDS/03k=},\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
707                     ORACLIZE_GAS_LIMIT + safeGas
708                 );
709             bets[myid] = Bet(msg.sender, betValue, 0);
710             betsKeys.push(myid);
711         }
712         else {
713             throw;
714         }
715     }
716 
717     function __callback(bytes32 myid, string result, bytes proof)
718         onlyOraclize
719         onlyIfBetExist(myid)
720         onlyIfNotProcessed(myid)
721         onlyIfValidRoll(myid, result)
722         onlyIfBetSizeIsStillCorrect(myid)  {
723 
724         uint numberRolled = parseInt(result);
725         bets[myid].numberRolled = numberRolled;
726         isWinningBet(bets[myid], numberRolled);
727         isLosingBet(bets[myid], numberRolled);
728         delete profitDistributed;
729     }
730 
731     function isWinningBet(Bet thisBet, uint numberRolled)
732         private
733         onlyWinningBets(numberRolled) {
734 
735         uint winAmount = (thisBet.amountBet * (10000 - edge)) / pwin;
736         LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount);
737         safeSend(thisBet.playerAddress, winAmount);
738 
739         //Check for overflow and underflow
740         if ((investorsLosses + winAmount < investorsLosses) ||
741             (investorsLosses + winAmount < thisBet.amountBet)) {
742                 throw;
743             }
744 
745         investorsLosses += winAmount - thisBet.amountBet;
746     }
747 
748     function isLosingBet(Bet thisBet, uint numberRolled)
749         private
750         onlyLosingBets(numberRolled) {
751 
752         LOG_BetLost(thisBet.playerAddress, numberRolled);
753         safeSend(thisBet.playerAddress, 1);
754 
755         //Check for overflow and underflow
756         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
757             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
758             (thisBet.amountBet == 1)) {
759                 throw;
760             }
761 
762         uint totalProfit = investorsProfit + (thisBet.amountBet - 1); //added based on audit feedback
763         investorsProfit += (thisBet.amountBet - 1)*(10000 - houseEdge)/10000;
764         uint houseProfit = totalProfit - investorsProfit; //changed based on audit feedback
765         safeSend(houseAddress, houseProfit);
766     }
767 
768     //SECTION III: INVEST & DIVEST
769 
770     function increaseInvestment()
771         payable
772         onlyIfNotStopped
773         onlyMoreThanZero
774         onlyInvestors  {
775 
776         profitDistribution();
777         investors[investorIDs[msg.sender]].amountInvested += msg.value;
778         invested += msg.value;
779     }
780 
781     function newInvestor()
782         payable
783         onlyIfNotStopped
784         onlyMoreThanZero
785         onlyNotInvestors
786         onlyMoreThanMinInvestment
787         investorsInvariant {
788 
789         profitDistribution();
790 
791         if (numInvestors == maxInvestors) {
792             uint smallestInvestorID = searchSmallestInvestor();
793             divest(investors[smallestInvestorID].investorAddress);
794         }
795 
796         numInvestors++;
797         addInvestorAtID(numInvestors);
798     }
799 
800     function divest()
801         onlyInvestors {
802 
803         divest(msg.sender);
804     }
805 
806 
807     function divest(address currentInvestor)
808         private
809         investorsInvariant {
810 
811         profitDistribution();
812         uint currentID = investorIDs[currentInvestor];
813         uint amountToReturn = getBalance(currentInvestor);
814 
815         if ((invested >= investors[currentID].amountInvested)) {
816             invested -= investors[currentID].amountInvested;
817             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
818             amountToReturn -= divestFeeAmount;
819 
820             delete investors[currentID];
821             delete investorIDs[currentInvestor];
822 
823             //Reorder investors
824             if (currentID != numInvestors) {
825                 // Get last investor
826                 Investor lastInvestor = investors[numInvestors];
827                 //Set last investor ID to investorID of divesting account
828                 investorIDs[lastInvestor.investorAddress] = currentID;
829                 //Copy investor at the new position in the mapping
830                 investors[currentID] = lastInvestor;
831                 //Delete old position in the mappping
832                 delete investors[numInvestors];
833             }
834 
835             numInvestors--;
836             safeSend(currentInvestor, amountToReturn);
837             safeSend(houseAddress, divestFeeAmount);
838             LOG_InvestorExit(currentInvestor, amountToReturn);
839         } else {
840             isStopped = true;
841             LOG_EmergencyAutoStop();
842         }
843     }
844 
845     function forceDivestOfAllInvestors()
846         onlyOwner {
847 
848         uint copyNumInvestors = numInvestors;
849         for (uint i = 1; i <= copyNumInvestors; i++) {
850             divest(investors[1].investorAddress);
851         }
852     }
853 
854     /*
855     The owner can use this function to force the exit of an investor from the
856     contract during an emergency withdrawal in the following situations:
857         - Unresponsive investor
858         - Investor demanding to be paid in other to vote, the facto-blackmailing
859         other investors
860     */
861     function forceDivestOfOneInvestor(address currentInvestor)
862         onlyOwner
863         onlyIfStopped {
864 
865         divest(currentInvestor);
866         //Resets emergency withdrawal proposal. Investors must vote again
867         delete proposedWithdrawal;
868     }
869 
870     //SECTION IV: CONTRACT MANAGEMENT
871 
872     function stopContract()
873         onlyOwner {
874 
875         isStopped = true;
876         LOG_ContractStopped();
877     }
878 
879     function resumeContract()
880         onlyOwner {
881 
882         isStopped = false;
883         LOG_ContractResumed();
884     }
885 
886     function changeHouseAddress(address newHouse)
887         onlyOwner {
888 
889         if (newHouse == address(0x0)) throw; //changed based on audit feedback
890         houseAddress = newHouse;
891         LOG_HouseAddressChanged(houseAddress, newHouse);
892     }
893 
894     function changeOwnerAddress(address newOwner)
895         onlyOwner {
896 
897         if (newOwner == address(0x0)) throw;
898         owner = newOwner;
899         LOG_OwnerAddressChanged(owner, newOwner);
900     }
901 
902     function changeGasLimitOfSafeSend(uint newGasLimit)
903         onlyOwner
904         onlyIfValidGas(newGasLimit) {
905 
906         safeGas = newGasLimit;
907         LOG_GasLimitChanged(safeGas, newGasLimit);
908     }
909 
910     //SECTION V: EMERGENCY WITHDRAWAL
911 
912     function voteEmergencyWithdrawal(bool vote)
913         onlyInvestors
914         onlyAfterProposed
915         onlyIfStopped {
916 
917         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
918         LOG_EmergencyWithdrawalVote(msg.sender, vote);
919     }
920 
921     function proposeEmergencyWithdrawal(address withdrawalAddress)
922         onlyIfStopped
923         onlyOwner {
924 
925         //Resets previous votes
926         for (uint i = 1; i <= numInvestors; i++) {
927             delete investors[i].votedForEmergencyWithdrawal;
928         }
929 
930         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
931         LOG_EmergencyWithdrawalProposed();
932     }
933 
934     function executeEmergencyWithdrawal()
935         onlyOwner
936         onlyAfterProposed
937         onlyIfStopped
938         onlyIfEmergencyTimeOutHasPassed {
939 
940         uint numOfVotesInFavour;
941         uint amountToWithdraw = this.balance;
942 
943         for (uint i = 1; i <= numInvestors; i++) {
944             if (investors[i].votedForEmergencyWithdrawal == true) {
945                 numOfVotesInFavour++;
946                 delete investors[i].votedForEmergencyWithdrawal;
947             }
948         }
949 
950         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
951             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
952                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
953             }
954             else {
955                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
956             }
957         }
958         else {
959             throw;
960         }
961     }
962 
963 }