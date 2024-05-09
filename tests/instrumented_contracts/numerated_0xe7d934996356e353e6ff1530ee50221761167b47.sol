1 pragma solidity ^0.4.24;
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
305 
306 interface PlayerBookInterface {
307     function getPlayerID(address _addr, uint256 _affCode) external returns (uint256);
308     function getPlayerName(uint256 _pID) external view returns (bytes32);
309     function getPlayerLAff(uint256 _pID) external view returns (uint256);
310     function getPlayerAddr(uint256 _pID) external view returns (address);
311     function getPlayerBetID(uint256 _pID, uint256 betIndex) external view returns (uint256);
312     function getPlayerInfo(uint256 _pID) external view returns(uint256,uint256,uint256,uint256,uint256,uint256);
313     function getNameFee() external view returns (uint256);
314     function betXaddr(address _addr, uint256 betAmount, bool isWin, uint256 betID, uint256 winAmount) external;
315     function rewardXID(uint256 _pID, uint256 rewardAmount, uint256 betID, uint256 level) external;
316     function registerNameFromDapp(address _addr, bytes32 _name) external payable returns(bool);
317 }
318 // </ORACLIZE_API>
319 
320 contract Bet100 is usingOraclize {
321 
322     using NameFilter for string;
323 
324     uint constant edge = 100; 
325     uint constant maxWin = 1000; 
326     uint constant maxWinCheck = maxWin * 2;  
327     uint constant minBet = 10 finney;
328     uint constant emergencyWithdrawalRatio = 10; 
329 
330     uint safeGas = 400000;
331     uint constant ORACLIZE_GAS_LIMIT = 175000;
332     uint constant INVALID_BET_MARKER = 99999;
333     uint constant INVALID_BET_MARKER_1 = 99998;
334     uint constant EMERGENCY_TIMEOUT = 30 seconds;
335 
336     string public randomOrgAPIKey = "e1de2fda-77b3-4fa5-bdec-cd09c82bcff7";
337 
338     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x8c7f8865acdf45ce86adac2939a72658d12272e3);
339 
340 
341     struct Bet {
342         address playerAddress;      
343         uint betNumber;             
344         uint amountBet;             
345         uint numberRolled;          
346         uint laff;                  
347         uint betTime;               
348         uint winAmount;             
349         bytes32 myid;                  
350     }
351 
352     struct WithdrawalProposal {
353         address toAddress;
354         uint atTime;
355     }
356 
357     uint public _bankRoll = 0;
358 
359     address public owner;
360     address public houseAddress;
361     bool public isStopped;
362 
363 
364     mapping (bytes32 => Bet) public bets;
365     bytes32[] public betsKeys;
366     uint256 betsCount;
367     mapping(uint => Bet) public betsInfo;
368 
369 
370     uint public investorsProfit = 0;
371 
372     uint public investorsLosses = 0;
373 
374 
375     uint constant dealerMinReward = 100 szabo; 
376     uint constant dealer_level_1_reward = 20; 
377     uint constant dealer_level_2_reward = 10; 
378     uint constant dealer_level_3_reward = 5; 
379     uint public dealer_reward_total = 0; 
380 
381     uint public draw_amount = 0;
382     uint public invest_amount = 0;
383 
384     event LOG_NewBet(address playerAddress, uint amount, bytes32 myid);
385     event LOG_BetWon(address playerAddress, uint numberRolled, uint amountWon, uint betId);
386     event LOG_BetLost(address playerAddress, uint numberRolled, uint betId);
387     event LOG_EmergencyWithdrawalProposed();
388     event LOG_EmergencyWithdrawalFailed(address withdrawalAddress);
389     event LOG_EmergencyWithdrawalSucceeded(address withdrawalAddress, uint amountWithdrawn);
390     event LOG_FailedSend(address receiver, uint amount);
391     event LOG_ZeroSend();
392     event LOG_InvestorEntrance(address investor, uint amount);
393     event LOG_InvestorCapitalUpdate(address investor, int amount);
394     event LOG_InvestorExit(address investor, uint amount);
395     event LOG_ContractStopped();
396     event LOG_ContractResumed();
397     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
398     event LOG_HouseAddressChanged(address oldAddr, address newHouseAddress);
399     event LOG_RandomOrgAPIKeyChanged(string oldKey, string newKey);
400     event LOG_GasLimitChanged(uint oldGasLimit, uint newGasLimit);
401     event LOG_EmergencyAutoStop();
402     event LOG_EmergencyWithdrawalVote(address investor, bool vote);
403     event LOG_ValueIsTooBig();
404     event LOG_SuccessfulSend(address addr, uint amount);
405 
406     constructor() public {
407         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
408         owner = msg.sender;
409         houseAddress = msg.sender;
410         betsCount = 0;
411     }
412 
413     //SECTION I: MODIFIERS AND HELPER FUNCTIONS
414 
415     //MODIFIERS
416 
417     modifier onlyIfNotStopped {
418         require(isStopped == false, "Game is stop!!!");
419         //if (isStopped) throw;
420         _;
421     }
422 
423     modifier onlyIfStopped {
424         require(isStopped == true, "Game is not stop!!!");
425         // if (!isStopped) throw;
426         _;
427     }
428 
429     modifier onlyOwner {
430         require(owner == msg.sender, "Only owner can operator !!!");
431         // if (owner != msg.sender) throw;
432         _;
433     }
434 
435     modifier onlyOraclize {
436         require(msg.sender == oraclize_cbAddress(), "Only Oraclize address can operator !!!");
437         //if (msg.sender != oraclize_cbAddress()) throw;
438         _;
439     }
440 
441     modifier onlyMoreThanZero {
442         require(msg.value != 0, "onlyMoreThanZero !!!");
443         //if (msg.value == 0) throw;
444         _;
445     }
446 
447     modifier onlyIfBetExist(bytes32 myid) {
448         require(bets[myid].playerAddress != address(0x0), "onlyIfBetExist !!!");
449         //if(bets[myid].playerAddress == address(0x0)) throw;
450         _;
451     }
452 
453     modifier onlyIfBetSizeIsStillCorrect(bytes32 myid) {
454         if ((((bets[myid].amountBet * ((10000 - edge) - bets[myid].betNumber)) / bets[myid].betNumber ) <= (maxWinCheck * getBankroll()) / 10000)  && (bets[myid].amountBet >= minBet)) {
455              _;
456         }
457         else {
458             bets[myid].numberRolled = INVALID_BET_MARKER_1;
459             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
460             return;
461         }
462     }
463 
464     modifier onlyIfValidRoll(bytes32 myid, string result) {
465         uint numberRolled = parseInt(result);
466         if ((numberRolled < 1 || numberRolled > 10000) && bets[myid].numberRolled == 0) {
467             bets[myid].numberRolled = INVALID_BET_MARKER;
468             safeSend(bets[myid].playerAddress, bets[myid].amountBet);
469             return;
470         }
471         _;
472     }
473 
474     modifier onlyWinningBets(uint numberRolled, uint betNumber) {
475         if (numberRolled - 1 < betNumber) {
476             _;
477         }
478     }
479 
480     modifier onlyLosingBets(uint numberRolled, uint betNumber) {
481         if (numberRolled - 1 >= betNumber) {
482             _;
483         }
484     }
485 
486     modifier onlyIfValidGas(uint newGasLimit) {
487         require(ORACLIZE_GAS_LIMIT + newGasLimit >= ORACLIZE_GAS_LIMIT, "gas is low");
488         // if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
489         require(newGasLimit >= 25000, "gas is low");
490         // if (newGasLimit < 25000) throw;
491         _;
492     }
493 
494     modifier onlyIfNotProcessed(bytes32 myid) {
495         require(bets[myid].numberRolled <= 0, "onlyIfNotProcessed");
496         // if (bets[myid].numberRolled > 0) throw;
497         _;
498     }
499     //检测下注点数是否合法
500     modifier onlyRollNumberValid(uint rollNumber) {
501         require(rollNumber < 100, "roll number invalid");
502         require(rollNumber > 0, "roll number invalid");
503         _;
504     }
505 
506     //CONSTANT HELPER FUNCTIONS
507 
508     function getBankroll()
509         view
510         public
511         returns(uint) {
512 
513         if (_bankRoll + investorsProfit <= investorsLosses) {
514             return 0;
515         }
516         else {
517             return _bankRoll + investorsProfit - investorsLosses;
518         }
519         //return _bankRoll;
520     }
521 
522     function getStatus()
523         view
524         external
525         returns(uint, uint, uint, uint, uint, uint) {
526 
527         uint bankroll = getBankroll();
528         //uint minInvestment = getMinInvestment();
529         return (bankroll, edge, maxWin, minBet, (investorsProfit - investorsLosses), betsCount);
530     }
531 
532     function getBet(uint id)
533         public
534         view
535         returns(address, uint, uint, uint, uint, uint) {
536 
537         if (id < betsCount) {
538             return (betsInfo[id].playerAddress, betsInfo[id].amountBet, betsInfo[id].betNumber,  betsInfo[id].numberRolled, betsInfo[id].winAmount,  betsInfo[id].betTime);
539         }
540     }
541 
542     function getBetKey(uint id)
543         public
544         view
545         returns(bytes32) {
546 
547         if (id < betsCount) {
548             return (betsInfo[id].myid);
549         }
550     }
551 
552     function numBets()
553         view
554         public
555         returns(uint) {
556 
557         return betsCount;
558     }
559 
560     function getBetReward(uint betNumber, uint betAmount) 
561         view
562         public
563         returns(uint, uint, uint) 
564     {
565         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
566         uint realBet = betAmount;
567         uint winAmount = ((realBet * (10000 - edge)) / (betNumber * 100)) - oraclizeFee ;
568         return (winAmount, realBet, oraclizeFee);
569     }
570 
571     function OraclizeIFee() 
572         view
573         public
574         returns(uint) 
575     {
576         return OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
577     }
578 
579     function getMinBetAmount()
580         view
581         public
582         returns(uint) {
583 
584         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
585         return oraclizeFee + minBet;
586     }
587 
588     function getMaxBetAmount(uint256 withNumber)
589         view
590         public
591         returns(uint) {
592         uint betNumber = withNumber * 100;
593         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
594         uint betValue =  (maxWin * getBankroll()) * betNumber / (10000 * (10000 - edge - betNumber));
595         return betValue + oraclizeFee;
596     }
597 
598 
599     function changeOraclizeProofType(byte _proofType)
600         onlyOwner 
601         public {
602 
603         require(_proofType != 0x00, "_proofType is 0x00");
604         //if (_proofType == 0x00) throw;
605         oraclize_setProof( _proofType |  proofStorage_IPFS );
606     }
607 
608     function changeOraclizeConfig(bytes32 _config)
609         onlyOwner 
610         public {
611 
612         oraclize_setConfig(_config);
613     }
614 
615     // PRIVATE HELPERS FUNCTION
616 
617     function safeSend(address addr, uint value)
618         private {
619 
620         if (value == 0) {
621             emit LOG_ZeroSend();
622             return;
623         }
624 
625         if (this.balance < value) {
626             emit LOG_ValueIsTooBig();
627             return;
628         }
629         //发送资金
630         if (!(addr.call.gas(safeGas).value(value)())) {
631             emit LOG_FailedSend(addr, value);
632             if (addr != houseAddress) {
633                 
634                 if (!(houseAddress.call.gas(safeGas).value(value)())) LOG_FailedSend(houseAddress, value);
635             }
636         }
637 
638         emit LOG_SuccessfulSend(addr,value);
639     }
640 
641     // SECTION II: BET & BET PROCESSING
642 
643     function()
644         payable 
645         public {
646 
647         bet(5, 0);
648     }
649 
650     function bet(uint256 betNumber, uint affCode)
651         payable
652         onlyIfNotStopped 
653         onlyRollNumberValid(betNumber) {
654 
655         uint256 betNumberHigh = betNumber * 100;
656         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
657         require(oraclizeFee < msg.value, "msg.value can not pay for oraclizeFee");
658         //if (oraclizeFee >= msg.value) throw;
659         uint betValue = msg.value;
660 
661         uint pID = PlayerBook.getPlayerID(msg.sender, affCode);
662         if ((((betValue * ((10000 - edge) - betNumberHigh)) / betNumberHigh ) <= (maxWin * getBankroll()) / 10000) && (betValue >= minBet)) {
663 
664             string memory str1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random.data.0', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"params\":{\"apiKey\":\"";
665             string memory str2 = randomOrgAPIKey;
666             string memory str3 = "\",\"n\":1,\"min\":1,\"max\":10000${[identity] \"}\"},\"id\":1${[identity] \"}\"}']";
667             string memory query = strConcat(str1, str2, str3);
668 
669             bytes32 myid =
670                 oraclize_query(
671                     "nested",
672                     query,
673                     ORACLIZE_GAS_LIMIT + safeGas
674                 );
675             uint laff = PlayerBook.getPlayerLAff(pID);
676             bets[myid] = Bet(msg.sender, betNumberHigh, betValue, 0, laff, now, 0, myid);
677             betsKeys.push(myid);
678             emit LOG_NewBet(msg.sender, betValue, myid);
679         }
680         else {
681             revert("out of bank roll");
682         }
683     }
684 
685     function __callback(bytes32 myid, string result, bytes proof)
686         onlyOraclize
687         onlyIfBetExist(myid)
688         onlyIfNotProcessed(myid)
689         onlyIfValidRoll(myid, result)
690         onlyIfBetSizeIsStillCorrect(myid) {
691 
692         uint numberRolled = parseInt(result);
693         bets[myid].numberRolled = numberRolled;
694         isWinningBet(bets[myid], numberRolled, bets[myid].betNumber);
695         isLosingBet(bets[myid], numberRolled, bets[myid].betNumber);
696     }
697 
698     function isWinningBet(Bet thisBet, uint numberRolled, uint betNumber)
699         private
700         onlyWinningBets(numberRolled, betNumber) {
701 
702         uint winAmount = (thisBet.amountBet * (10000 - edge)) / betNumber;
703 
704         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", ORACLIZE_GAS_LIMIT + safeGas);
705         winAmount = winAmount - oraclizeFee;
706 
707         emit LOG_BetWon(thisBet.playerAddress, numberRolled, winAmount, betsCount);
708 
709         safeSend(thisBet.playerAddress, winAmount);
710         
711         //统计
712         thisBet.winAmount = winAmount;
713         betsInfo[betsCount] = thisBet;
714         PlayerBook.betXaddr(thisBet.playerAddress, thisBet.amountBet, true, betsCount, winAmount);
715 
716         //计算返现
717         affReward(thisBet, betsCount);
718 
719         betsCount++;
720         
721         //Check for overflow and underflow
722         if ((investorsLosses + winAmount < investorsLosses) ||
723             (investorsLosses + winAmount < thisBet.amountBet)) {
724                 revert("error");
725             }
726 
727         uint256 rLosses = winAmount - thisBet.amountBet;
728         if(winAmount < thisBet.amountBet)
729             rLosses = 0;
730 
731         investorsLosses += rLosses;
732     }
733 
734     function isLosingBet(Bet thisBet, uint numberRolled, uint betNumber)
735         private
736         onlyLosingBets(numberRolled, betNumber) {
737 
738         emit LOG_BetLost(thisBet.playerAddress, numberRolled, betsCount);
739         safeSend(thisBet.playerAddress, 1);
740 
741 
742         betsInfo[betsCount] = thisBet;
743         PlayerBook.betXaddr(thisBet.playerAddress, thisBet.amountBet, false, betsCount, 0);
744         
745 
746         affReward(thisBet, betsCount);
747 
748         betsCount++;
749 
750         //Check for overflow and underflow
751         if ((investorsProfit + thisBet.amountBet < investorsProfit) ||
752             (investorsProfit + thisBet.amountBet < thisBet.amountBet) ||
753             (thisBet.amountBet == 1)) {
754                 revert("error");
755             }
756         
757         investorsProfit += thisBet.amountBet - 1;
758     }
759 
760     function affReward(Bet thisBet, uint256 betID)
761         private {
762         
763         if(thisBet.laff > 0)
764         {
765             uint laff_1_reward_max = thisBet.amountBet * edge / 10000;
766             uint laff_1_reward = thisBet.amountBet * edge * dealer_level_1_reward / (10000 * 100);
767             if(laff_1_reward >= dealerMinReward && laff_1_reward < laff_1_reward_max)
768             {
769 
770                 address laff_1_address = PlayerBook.getPlayerAddr(thisBet.laff);
771                 dealer_reward_total += laff_1_reward;
772                 safeSend(laff_1_address, laff_1_reward);
773                 PlayerBook.rewardXID(thisBet.laff, laff_1_reward, betID, 1);
774 
775 
776                 uint laff_2_pid = PlayerBook.getPlayerLAff(thisBet.laff);
777                 uint laff_2_reward = thisBet.amountBet * edge * dealer_level_2_reward / (10000 * 100);
778                 if(laff_2_pid>0 && laff_2_reward >= dealerMinReward && laff_2_reward < laff_1_reward_max)
779                 {
780 
781                     address laff_2_address = PlayerBook.getPlayerAddr(laff_2_pid);
782                     dealer_reward_total += laff_2_reward;
783                     safeSend(laff_2_address, laff_2_reward);
784                     PlayerBook.rewardXID(laff_2_pid, laff_2_reward, betID, 2);
785                 }
786                 
787             }
788             
789         }
790     }
791 
792     //SECTION III: INVEST & DIVEST
793 
794     function increaseInvestment()
795         external
796         payable
797         onlyIfNotStopped
798         onlyMoreThanZero
799         onlyOwner  {
800 
801         _bankRoll += msg.value;
802         invest_amount += msg.value;
803     }
804 
805 
806 
807     function divest(uint amount)
808         external
809         onlyOwner {
810 
811         //divest(msg.sender);
812         require(address(this).balance >= amount, "Don't have enough balance");
813         //require(_bankRoll > amount, "Don't have enough _bankRoll");
814 
815         _bankRoll = address(this).balance - amount;
816         draw_amount += amount;
817         safeSend(owner, amount);
818 
819         investorsProfit = 0;
820         investorsLosses = 0;
821         
822     }
823 
824     //SECTION IV: CONTRACT MANAGEMENT
825 
826     function stopContract()
827         external
828         onlyOwner {
829 
830         isStopped = true;
831         emit LOG_ContractStopped();
832     }
833 
834     function resumeContract()
835         external
836         onlyOwner {
837 
838         isStopped = false;
839         emit LOG_ContractResumed();
840     }
841 
842     function changeHouseAddress(address newHouse)
843         external
844         onlyOwner {
845 
846         require(newHouse != address(0x0), "new Houst is 0x0");
847         //if (newHouse == address(0x0)) throw; //changed based on audit feedback
848         houseAddress = newHouse;
849         emit LOG_HouseAddressChanged(houseAddress, newHouse);
850     }
851 
852     function changeOwnerAddress(address newOwner)
853         external
854         onlyOwner {
855 
856         require(newOwner != address(0x0), "new owner is 0x0");
857         // if (newOwner == address(0x0)) throw;
858         owner = newOwner;
859         emit LOG_OwnerAddressChanged(owner, newOwner);
860     }
861 
862     /**
863      * @dev prevents contracts from interacting with fomo3d 
864      */
865     modifier isHuman() {
866         address _addr = msg.sender;
867         uint256 _codeLength;
868         
869         assembly {_codeLength := extcodesize(_addr)}
870         require(_codeLength == 0, "sorry humans only");
871         _;
872     }
873     
874     function regName(string name) 
875         isHuman()
876         public
877         payable
878     {
879         bytes32 _name = name.nameFilter();
880         address _addr = msg.sender;
881         uint256 _paid = msg.value;
882         PlayerBook.registerNameFromDapp.value(_paid)(_addr, _name);
883     }
884 
885     function changeRandomOrgAPIKey(string newKey) 
886         onlyOwner {
887 
888         string oldKey = randomOrgAPIKey;
889         randomOrgAPIKey = newKey;
890         LOG_RandomOrgAPIKeyChanged(oldKey, newKey);
891     }
892 
893     function changeGasLimitOfSafeSend(uint newGasLimit)
894         external
895         onlyOwner
896         onlyIfValidGas(newGasLimit) {
897 
898         safeGas = newGasLimit;
899         emit LOG_GasLimitChanged(safeGas, newGasLimit);
900     }
901 
902     //SECTION V: EMERGENCY WITHDRAWAL
903     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) 
904         external
905     {
906         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
907     }
908 }
909 
910 
911 library NameFilter {
912     /**
913      * @dev filters name strings
914      * -converts uppercase to lower case.  
915      * -makes sure it does not start/end with a space
916      * -makes sure it does not contain multiple spaces in a row
917      * -cannot be only numbers
918      * -cannot start with 0x 
919      * -restricts characters to A-Z, a-z, 0-9, and space.
920      * @return reprocessed string in bytes32 format
921      */
922     function nameFilter(string _input)
923         internal
924         pure
925         returns(bytes32)
926     {
927         bytes memory _temp = bytes(_input);
928         uint256 _length = _temp.length;
929         
930         //sorry limited to 32 characters
931         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
932         // make sure it doesnt start with or end with space
933         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
934         // make sure first two characters are not 0x
935         if (_temp[0] == 0x30)
936         {
937             require(_temp[1] != 0x78, "string cannot start with 0x");
938             require(_temp[1] != 0x58, "string cannot start with 0X");
939         }
940         
941         // create a bool to track if we have a non number character
942         bool _hasNonNumber;
943         
944         // convert & check
945         for (uint256 i = 0; i < _length; i++)
946         {
947             // if its uppercase A-Z
948             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
949             {
950                 // convert to lower case a-z
951                 _temp[i] = byte(uint(_temp[i]) + 32);
952                 
953                 // we have a non number
954                 if (_hasNonNumber == false)
955                     _hasNonNumber = true;
956             } else {
957                 require
958                 (
959                     // require character is a space
960                     _temp[i] == 0x20 || 
961                     // OR lowercase a-z
962                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
963                     // or 0-9
964                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
965                     "string contains invalid characters"
966                 );
967                 // make sure theres not 2x spaces in a row
968                 if (_temp[i] == 0x20)
969                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
970                 
971                 // see if we have a character other than a number
972                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
973                     _hasNonNumber = true;    
974             }
975         }
976         
977         require(_hasNonNumber == true, "string cannot be only numbers");
978         
979         bytes32 _ret;
980         assembly {
981             _ret := mload(add(_temp, 32))
982         }
983         return (_ret);
984     }
985 }