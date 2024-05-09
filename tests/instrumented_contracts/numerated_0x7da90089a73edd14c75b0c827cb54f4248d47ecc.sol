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
94     function __callback(bytes32 myid, string result) {
95         __callback(myid, result, new bytes(0));
96     }
97     function __callback(bytes32 myid, string result, bytes proof) {
98     }
99     
100     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
101         return oraclize.getPrice(datasource);
102     }
103     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
104         return oraclize.getPrice(datasource, gaslimit);
105     }
106     
107     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource);
109         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
110         return oraclize.query.value(price)(0, datasource, arg);
111     }
112     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
113         uint price = oraclize.getPrice(datasource);
114         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
115         return oraclize.query.value(price)(timestamp, datasource, arg);
116     }
117     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
118         uint price = oraclize.getPrice(datasource, gaslimit);
119         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
120         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
121     }
122     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource, gaslimit);
124         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
125         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
126     }
127     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource);
134         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
135         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
136     }
137     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
141     }
142     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource, gaslimit);
144         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
145         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
146     }
147     function oraclize_cbAddress() oraclizeAPI internal returns (address){
148         return oraclize.cbAddress();
149     }
150     function oraclize_setProof(byte proofP) oraclizeAPI internal {
151         return oraclize.setProofType(proofP);
152     }
153     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
154         return oraclize.setCustomGasPrice(gasPrice);
155     }    
156     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
157         return oraclize.setConfig(config);
158     }
159 
160     function getCodeSize(address _addr) constant internal returns(uint _size) {
161         assembly {
162             _size := extcodesize(_addr)
163         }
164     }
165 
166 
167     function parseAddr(string _a) internal returns (address){
168         bytes memory tmp = bytes(_a);
169         uint160 iaddr = 0;
170         uint160 b1;
171         uint160 b2;
172         for (uint i=2; i<2+2*20; i+=2){
173             iaddr *= 256;
174             b1 = uint160(tmp[i]);
175             b2 = uint160(tmp[i+1]);
176             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
177             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
178             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
179             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
180             iaddr += (b1*16+b2);
181         }
182         return address(iaddr);
183     }
184 
185 
186     function strCompare(string _a, string _b) internal returns (int) {
187         bytes memory a = bytes(_a);
188         bytes memory b = bytes(_b);
189         uint minLength = a.length;
190         if (b.length < minLength) minLength = b.length;
191         for (uint i = 0; i < minLength; i ++)
192             if (a[i] < b[i])
193                 return -1;
194             else if (a[i] > b[i])
195                 return 1;
196         if (a.length < b.length)
197             return -1;
198         else if (a.length > b.length)
199             return 1;
200         else
201             return 0;
202    } 
203 
204     function indexOf(string _haystack, string _needle) internal returns (int)
205     {
206         bytes memory h = bytes(_haystack);
207         bytes memory n = bytes(_needle);
208         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
209             return -1;
210         else if(h.length > (2**128 -1))
211             return -1;                                  
212         else
213         {
214             uint subindex = 0;
215             for (uint i = 0; i < h.length; i ++)
216             {
217                 if (h[i] == n[0])
218                 {
219                     subindex = 1;
220                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
221                     {
222                         subindex++;
223                     }   
224                     if(subindex == n.length)
225                         return int(i);
226                 }
227             }
228             return -1;
229         }   
230     }
231 
232     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
233         bytes memory _ba = bytes(_a);
234         bytes memory _bb = bytes(_b);
235         bytes memory _bc = bytes(_c);
236         bytes memory _bd = bytes(_d);
237         bytes memory _be = bytes(_e);
238         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
239         bytes memory babcde = bytes(abcde);
240         uint k = 0;
241         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
242         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
243         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
244         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
245         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
246         return string(babcde);
247     }
248     
249     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
250         return strConcat(_a, _b, _c, _d, "");
251     }
252 
253     function strConcat(string _a, string _b, string _c) internal returns (string) {
254         return strConcat(_a, _b, _c, "", "");
255     }
256 
257     function strConcat(string _a, string _b) internal returns (string) {
258         return strConcat(_a, _b, "", "", "");
259     }
260 
261     // parseInt
262     function parseInt(string _a) internal returns (uint) {
263         return parseInt(_a, 0);
264     }
265 
266     // parseInt(parseFloat*10^_b)
267     function parseInt(string _a, uint _b) internal returns (uint) {
268         bytes memory bresult = bytes(_a);
269         uint mint = 0;
270         bool decimals = false;
271         for (uint i=0; i<bresult.length; i++){
272             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
273                 if (decimals){
274                    if (_b == 0) break;
275                     else _b--;
276                 }
277                 mint *= 10;
278                 mint += uint(bresult[i]) - 48;
279             } else if (bresult[i] == 46) decimals = true;
280         }
281         if (_b > 0) mint *= 10**_b;
282         return mint;
283     }
284     
285     function uint2str(uint i) internal returns (string){
286         if (i == 0) return "0";
287         uint j = i;
288         uint len;
289         while (j != 0){
290             len++;
291             j /= 10;
292         }
293         bytes memory bstr = new bytes(len);
294         uint k = len - 1;
295         while (i != 0){
296             bstr[k--] = byte(48 + i % 10);
297             i /= 10;
298         }
299         return string(bstr);
300     }
301     
302     
303 
304 }
305 // </ORACLIZE_API>
306 
307 contract Dice is usingOraclize {
308 
309     uint constant pwin = 9000; //probability of winning (10000 = 100%)
310     uint constant edge = 190; //edge percentage (10000 = 100%)
311     uint constant maxWin = 100; //max win (before edge is taken) as percentage of bankroll (10000 = 100%)
312     uint constant minBet = 200 finney;
313     uint constant maxInvestors = 10; //maximum number of investors
314     uint constant houseEdge = 90; //edge percentage (10000 = 100%)
315     uint constant divestFee = 50; //divest fee percentage (10000 = 100%)
316     uint constant emergencyWithdrawalRatio = 10; //ratio percentage (100 = 100%)
317 
318     uint safeGas = 2300;
319     uint constant ORACLIZE_GAS_LIMIT = 175000;
320     uint constant INVALID_BET_MARKER = 99999;
321     uint constant EMERGENCY_TIMEOUT = 3 days;
322 
323     struct Investor {
324         address investorAddress;
325         uint amountInvested;
326         bool votedForEmergencyWithdrawal;
327     }
328 
329     struct Bet {
330         address playerAddress;
331         uint amountBet;
332         uint numberRolled;
333     }
334 
335     struct WithdrawalProposal {
336         address toAddress;
337         uint atTime;
338     }
339 
340     //Starting at 1
341     mapping(address => uint) public investorIDs;
342     mapping(uint => Investor) public investors;
343     uint public numInvestors = 0;
344 
345     uint public invested = 0;
346 
347     address public owner;
348     address public houseAddress;
349     bool public isStopped;
350 
351     WithdrawalProposal public proposedWithdrawal;
352 
353     mapping (bytes32 => Bet) public bets;
354     bytes32[] public betsKeys;
355 
356     uint public investorsProfit = 0;
357     uint public investorsLosses = 0;
358     bool profitDistributed;
359 
360     event LOG_NewBet(address playerAddress, uint amount);
361     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon);
362     event LOG_BetLost(address playerAddress, uint numberRolled);
363     event LOG_EmergencyWithdrawalProposed();
364     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
365     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
366     event LOG_FailedSend(address receiver, uint amount);
367     event LOG_ZeroSend();
368     event LOG_InvestorEntrance(address investor, uint amount);
369     event LOG_InvestorCapitalUpdate(address investor, int amount);
370     event LOG_InvestorExit(address investor, uint amount);
371     event LOG_ContractStopped();
372     event LOG_ContractResumed();
373     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
374     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
375     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
376     event LOG_EmergencyAutoStop();
377     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
378     event LOG_ValueIsTooBig();
379     event LOG_SuccessfulSend(address addr, uint amount);
380 
381     function Dice() {
382         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
383         owner = msg.sender;
384         houseAddress = msg.sender;
385     }
386 
387     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
388 
389     //MODIFIERS
390 
391     modifier onlyIfNotStopped {
392         if (isStopped) throw;
393         _;
394     }
395 
396     modifier onlyIfStopped {
397         if (!isStopped) throw;
398         _;
399     }
400 
401     modifier onlyInvestors {
402         if (investorIDs[msg.sender] == 0) throw;
403         _;
404     }
405 
406     modifier onlyNotInvestors {
407         if (investorIDs[msg.sender] != 0) throw;
408         _;
409     }
410 
411     modifier onlyOwner {
412         if (owner != msg.sender) throw;
413         _;
414     }
415 
416     modifier onlyOraclize {
417         if (msg.sender != oraclize_cbAddress()) throw;
418         _;
419     }
420 
421     modifier onlyMoreThanMinInvestment {
422         if (msg.value <= getMinInvestment()) throw;
423         _;
424     }
425 
426     modifier onlyMoreThanZero {
427         if (msg.value == 0) throw;
428         _;
429     }
430 
431     modifier onlyIfBetExist(bytes32 myid) {
432         if(bets[myid].playerAddress == address(0x0)) throw;
433         _;
434     }
435 
436     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
437         if ((((bets[myid].amountBet * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet)) {
438              _;
439         }
440         else {
441             bets[myid].numberRolled = INVALID_BET_MARKER;
442             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
443             return;
444         }
445     }
446 
447     modifier onlyIfValidRoll(bytes32 myid, string result) {
448         uint numberRolled = parseInt(result);
449         if ((numberRolled < 1 || numberRolled > 10000) && bets[myid].numberRolled == 0) {
450             bets[myid].numberRolled = INVALID_BET_MARKER;
451             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
452             return;
453         }
454         _;
455     }
456 
457     modifier onlyWinningBets(uint numberRolled) {
458         if (numberRolled - 1 < pwin) {
459             _;
460         }
461     }
462 
463     modifier onlyLosingBets(uint numberRolled) {
464         if (numberRolled - 1 >= pwin) {
465             _;
466         }
467     }
468 
469     modifier onlyAfterProposed {
470         if (proposedWithdrawal.toAddress == 0) throw;
471         _;
472     }
473 
474     modifier onlyIfProfitNotDistributed {
475         if (!profitDistributed) {
476             _;
477         }
478     }
479 
480     modifier onlyIfValidGas(uint newGasLimit) {
481         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
482         if (newGasLimit < 25000) throw;
483         _;
484     }
485 
486     modifier onlyIfNotProcessed(bytes32 myid) {
487         if (bets[myid].numberRolled > 0) throw;
488         _;
489     }
490 
491     modifier onlyIfEmergencyTimeOutHasPassed {
492         if (proposedWithdrawal.atTime + EMERGENCY_TIMEOUT > now) throw;
493         _;
494     }
495 
496     modifier investorsInvariant {
497         _;
498         if (numInvestors > maxInvestors) throw;
499     }
500 
501     //CONSTANT HELPER FUNCTIONS
502 
503     function getBankroll()
504         constant
505         returns(uint) {
506 
507         if ((invested < investorsProfit) ||
508             (invested + investorsProfit < invested) ||
509             (invested + investorsProfit < investorsLosses)) {
510             return 0;
511         }
512         else {
513             return invested + investorsProfit - investorsLosses;
514         }
515     }
516 
517     function getMinInvestment()
518         constant
519         returns(uint) {
520 
521         if (numInvestors == maxInvestors) {
522             uint investorID = searchSmallestInvestor();
523             return getBalance(investors[investorID].investorAddress);
524         }
525         else {
526             return 0;
527         }
528     }
529 
530     function getStatus()
531         constant
532         returns(uint, uint, uint, uint, uint, uint, uint, uint) {
533 
534         uint bankroll = getBankroll();
535         uint minInvestment = getMinInvestment();
536         return (bankroll, pwin, edge, maxWin, minBet, (investorsProfit - investorsLosses), minInvestment, betsKeys.length);
537     }
538 
539     function getBet(uint id)
540         constant
541         returns(address, uint, uint) {
542 
543         if (id < betsKeys.length) {
544             bytes32 betKey = betsKeys[id];
545             return (bets[betKey].playerAddress, bets[betKey].amountBet, bets[betKey].numberRolled);
546         }
547     }
548 
549     function numBets()
550         constant
551         returns(uint) {
552 
553         return betsKeys.length;
554     }
555 
556     function getMinBetAmount()
557         constant
558         returns(uint) {
559 
560         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
561         return oraclizeFee + minBet;
562     }
563 
564     function getMaxBetAmount()
565         constant
566         returns(uint) {
567 
568         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
569         uint betValue =  (maxWin * getBankroll()) * pwin / (10000 * (10000 - edge - pwin));
570         return betValue + oraclizeFee;
571     }
572 
573     function getLossesShare(address currentInvestor)
574         constant
575         returns (uint) {
576 
577         return investors[investorIDs[currentInvestor]].amountInvested * (investorsLosses) / invested;
578     }
579 
580     function getProfitShare(address currentInvestor)
581         constant
582         returns (uint) {
583 
584         return investors[investorIDs[currentInvestor]].amountInvested * (investorsProfit) / invested;
585     }
586 
587     function getBalance(address currentInvestor)
588         constant
589         returns (uint) {
590 
591         uint invested = investors[investorIDs[currentInvestor]].amountInvested;
592         uint profit = getProfitShare(currentInvestor);
593         uint losses = getLossesShare(currentInvestor);
594 
595         if ((invested + profit < profit) ||
596             (invested + profit < invested) ||
597             (invested + profit < losses))
598             return 0;
599         else
600             return invested + profit - losses;
601     }
602 
603     function searchSmallestInvestor()
604         constant
605         returns(uint) {
606 
607         uint investorID = 1;
608         for (uint i = 1; i <= numInvestors; i++) {
609             if (getBalance(investors[i].investorAddress) < getBalance(investors[investorID].investorAddress)) {
610                 investorID = i;
611             }
612         }
613 
614         return investorID;
615     }
616 
617     function changeOraclizeProofType(byte _proofType)
618         onlyOwner {
619 
620         if (_proofType == 0x00) throw;
621         oraclize_setProof( _proofType |  proofStorage_IPFS );
622     }
623 
624     function changeOraclizeConfig(bytes32 _config)
625         onlyOwner {
626 
627         oraclize_setConfig(_config);
628     }
629 
630     // PRIVATE HELPERS FUNCTION
631 
632     function safeSend(address addr, uint value)
633         private {
634 
635         if (value == 0) {
636             LOG_ZeroSend();
637             return;
638         }
639 
640         if (this.balance < value) {
641             LOG_ValueIsTooBig();
642             return;
643         }
644 
645         if (!(addr.call.gas(safeGas).value(value)())) {
646             LOG_FailedSend(addr, value);
647             if (addr != houseAddress) {
648                 //Forward to house address all change
649                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
650             }
651         }
652 
653         LOG_SuccessfulSend(addr,value);
654     }
655 
656     function addInvestorAtID(uint id)
657         private {
658 
659         investorIDs[msg.sender] = id;
660         investors[id].investorAddress = msg.sender;
661         investors[id].amountInvested = msg.value;
662         invested += msg.value;
663 
664         LOG_InvestorEntrance(msg.sender, msg.value);
665     }
666 
667     function profitDistribution()
668         private
669         onlyIfProfitNotDistributed {
670 
671         uint copyInvested;
672 
673         for (uint i = 1; i <= numInvestors; i++) {
674             address currentInvestor = investors[i].investorAddress;
675             uint profitOfInvestor = getProfitShare(currentInvestor);
676             uint lossesOfInvestor = getLossesShare(currentInvestor);
677             //Check for overflow and underflow
678             if ((investors[i].amountInvested + profitOfInvestor >= investors[i].amountInvested) &&
679                 (investors[i].amountInvested + profitOfInvestor >= lossesOfInvestor))  {
680                 investors[i].amountInvested += profitOfInvestor - lossesOfInvestor;
681                 LOG_InvestorCapitalUpdate(currentInvestor, (int) (profitOfInvestor - lossesOfInvestor));
682             }
683             else {
684                 isStopped = true;
685                 LOG_EmergencyAutoStop();
686             }
687 
688             if (copyInvested + investors[i].amountInvested >= copyInvested)
689                 copyInvested += investors[i].amountInvested;
690         }
691 
692         delete investorsProfit;
693         delete investorsLosses;
694         invested = copyInvested;
695 
696         profitDistributed = true;
697     }
698 
699     // SECTION II: BET & BET PROCESSING
700 
701     function()
702         payable {
703 
704         bet();
705     }
706 
707     function bet()
708         payable
709         onlyIfNotStopped {
710 
711         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
712         if (oraclizeFee >= msg.value) throw;
713         uint betValue = msg.value - oraclizeFee;
714         if ((((betValue * ((10000 - edge) - pwin)) / pwin ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
715             LOG_NewBet(msg.sender, betValue);
716             bytes32 myid =
717                 oraclize_query(
718                     "nested",
719                     "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":${[decrypt] BIYkzb1GQzRZFNsTzF7fh+n8VmT8GEyW3mHYlrU8It5O6/bam6/LVVxqkury8YZDJPjm0mWQeqQGebGAVSFrFw16/VHJ65QMFBfIHN2frhav/d10ARqECjoOvse5v4/DIT3LQUHPEx0Z/5UdtqYTQydW/pbC5BM=},\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']",
720                     ORACLIZE_GAS_LIMIT + safeGas
721                 );
722             bets[myid] = Bet(msg.sender, betValue, 0);
723             betsKeys.push(myid);
724         }
725         else {
726             throw;
727         }
728     }
729 
730     function __callback(bytes32 myid, string result, bytes proof)
731         onlyOraclize
732         onlyIfBetExist(myid)
733         onlyIfNotProcessed(myid)
734         onlyIfValidRoll(myid, result)
735         onlyIfBetSizeIsStillCorrect(myid)  {
736 
737         uint numberRolled = parseInt(result);
738         bets[myid].numberRolled = numberRolled;
739         isWinningBet(bets[myid], numberRolled);
740         isLosingBet(bets[myid], numberRolled);
741         delete profitDistributed;
742     }
743 
744     function isWinningBet(Bet thisBet, uint numberRolled)
745         private
746         onlyWinningBets(numberRolled) {
747 
748         uint winAmount = (thisBet.amountBet * (10000 - edge)) / pwin;
749         LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount);
750         safeSend(thisBet.playerAddress, winAmount);
751 
752         //Check for overflow and underflow
753         if ((investorsLosses + winAmount < investorsLosses) ||
754             (investorsLosses + winAmount < thisBet.amountBet)) {
755                 throw;
756             }
757 
758         investorsLosses += winAmount - thisBet.amountBet;
759     }
760 
761     function isLosingBet(Bet thisBet, uint numberRolled)
762         private
763         onlyLosingBets(numberRolled) {
764 
765         LOG_BetLost(thisBet.playerAddress, numberRolled);
766         safeSend(thisBet.playerAddress, 1);
767 
768         //Check for overflow and underflow
769         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
770             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
771             (thisBet.amountBet == 1)) {
772                 throw;
773             }
774 
775         uint totalProfit = investorsProfit + (thisBet.amountBet - 1); //added based on audit feedback
776         investorsProfit += (thisBet.amountBet - 1)*(10000 - houseEdge)/10000;
777         uint houseProfit = totalProfit - investorsProfit; //changed based on audit feedback
778         safeSend(houseAddress, houseProfit);
779     }
780 
781     //SECTION III: INVEST & DIVEST
782 
783     function increaseInvestment()
784         payable
785         onlyIfNotStopped
786         onlyMoreThanZero
787         onlyInvestors  {
788 
789         profitDistribution();
790         investors[investorIDs[msg.sender]].amountInvested += msg.value;
791         invested += msg.value;
792     }
793 
794     function newInvestor()
795         payable
796         onlyIfNotStopped
797         onlyMoreThanZero
798         onlyNotInvestors
799         onlyMoreThanMinInvestment
800         investorsInvariant {
801 
802         profitDistribution();
803 
804         if (numInvestors == maxInvestors) {
805             uint smallestInvestorID = searchSmallestInvestor();
806             divest(investors[smallestInvestorID].investorAddress);
807         }
808 
809         numInvestors++;
810         addInvestorAtID(numInvestors);
811     }
812 
813     function divest()
814         onlyInvestors {
815 
816         divest(msg.sender);
817     }
818 
819 
820     function divest(address currentInvestor)
821         private
822         investorsInvariant {
823 
824         profitDistribution();
825         uint currentID = investorIDs[currentInvestor];
826         uint amountToReturn = getBalance(currentInvestor);
827 
828         if ((invested >= investors[currentID].amountInvested)) {
829             invested -= investors[currentID].amountInvested;
830             uint divestFeeAmount =  (amountToReturn*divestFee)/10000;
831             amountToReturn -= divestFeeAmount;
832 
833             delete investors[currentID];
834             delete investorIDs[currentInvestor];
835 
836             //Reorder investors
837             if (currentID != numInvestors) {
838                 // Get last investor
839                 Investor lastInvestor = investors[numInvestors];
840                 //Set last investor ID to investorID of divesting account
841                 investorIDs[lastInvestor.investorAddress] = currentID;
842                 //Copy investor at the new position in the mapping
843                 investors[currentID] = lastInvestor;
844                 //Delete old position in the mappping
845                 delete investors[numInvestors];
846             }
847 
848             numInvestors--;
849             safeSend(currentInvestor, amountToReturn);
850             safeSend(houseAddress, divestFeeAmount);
851             LOG_InvestorExit(currentInvestor, amountToReturn);
852         } else {
853             isStopped = true;
854             LOG_EmergencyAutoStop();
855         }
856     }
857 
858     function forceDivestOfAllInvestors()
859         onlyOwner {
860 
861         uint copyNumInvestors = numInvestors;
862         for (uint i = 1; i <= copyNumInvestors; i++) {
863             divest(investors[1].investorAddress);
864         }
865     }
866 
867     /*
868     The owner can use this function to force the exit of an investor from the
869     contract during an emergency withdrawal in the following situations:
870         - Unresponsive investor
871         - Investor demanding to be paid in other to vote, the facto-blackmailing
872         other investors
873     */
874     function forceDivestOfOneInvestor(address currentInvestor)
875         onlyOwner
876         onlyIfStopped {
877 
878         divest(currentInvestor);
879         //Resets emergency withdrawal proposal. Investors must vote again
880         delete proposedWithdrawal;
881     }
882 
883     //SECTION IV: CONTRACT MANAGEMENT
884 
885     function stopContract()
886         onlyOwner {
887 
888         isStopped = true;
889         LOG_ContractStopped();
890     }
891 
892     function resumeContract()
893         onlyOwner {
894 
895         isStopped = false;
896         LOG_ContractResumed();
897     }
898 
899     function changeHouseAddress(address newHouse)
900         onlyOwner {
901 
902         if (newHouse == address(0x0)) throw; //changed based on audit feedback
903         houseAddress = newHouse;
904         LOG_HouseAddressChanged(houseAddress, newHouse);
905     }
906 
907     function changeOwnerAddress(address newOwner)
908         onlyOwner {
909 
910         if (newOwner == address(0x0)) throw;
911         owner = newOwner;
912         LOG_OwnerAddressChanged(owner, newOwner);
913     }
914 
915     function changeGasLimitOfSafeSend(uint newGasLimit)
916         onlyOwner
917         onlyIfValidGas(newGasLimit) {
918 
919         safeGas = newGasLimit;
920         LOG_GasLimitChanged(safeGas, newGasLimit);
921     }
922 
923     //SECTION V: EMERGENCY WITHDRAWAL
924 
925     function voteEmergencyWithdrawal(bool vote)
926         onlyInvestors
927         onlyAfterProposed
928         onlyIfStopped {
929 
930         investors[investorIDs[msg.sender]].votedForEmergencyWithdrawal = vote;
931         LOG_EmergencyWithdrawalVote(msg.sender, vote);
932     }
933 
934     function proposeEmergencyWithdrawal(address withdrawalAddress)
935         onlyIfStopped
936         onlyOwner {
937 
938         //Resets previous votes
939         for (uint i = 1; i <= numInvestors; i++) {
940             delete investors[i].votedForEmergencyWithdrawal;
941         }
942 
943         proposedWithdrawal = WithdrawalProposal(withdrawalAddress, now);
944         LOG_EmergencyWithdrawalProposed();
945     }
946 
947     function executeEmergencyWithdrawal()
948         onlyOwner
949         onlyAfterProposed
950         onlyIfStopped
951         onlyIfEmergencyTimeOutHasPassed {
952 
953         uint numOfVotesInFavour;
954         uint amountToWithdraw = this.balance;
955 
956         for (uint i = 1; i <= numInvestors; i++) {
957             if (investors[i].votedForEmergencyWithdrawal == true) {
958                 numOfVotesInFavour++;
959                 delete investors[i].votedForEmergencyWithdrawal;
960             }
961         }
962 
963         if (numOfVotesInFavour >= emergencyWithdrawalRatio * numInvestors / 100) {
964             if (!proposedWithdrawal.toAddress.send(amountToWithdraw)) {
965                 LOG_EmergencyWithdrawalFailed(proposedWithdrawal.toAddress);
966             }
967             else {
968                 LOG_EmergencyWithdrawalSucceeded(proposedWithdrawal.toAddress, amountToWithdraw);
969             }
970         }
971         else {
972             throw;
973         }
974     }
975 
976 }