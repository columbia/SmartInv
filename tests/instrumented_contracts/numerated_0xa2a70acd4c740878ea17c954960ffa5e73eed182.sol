1 pragma solidity ^0.4.24;
2 
3 /*
4 *                                Stargate V1.0
5 *
6 * 
7  _______ _________ _______  _______  _______  _______ _________ _______ 
8 (  ____ \\__   __/(  ___  )(  ____ )(  ____ \(  ___  )\__   __/(  ____ \
9 | (    \/   ) (   | (   ) || (    )|| (    \/| (   ) |   ) (   | (    \/
10 | (_____    | |   | (___) || (____)|| |      | (___) |   | |   | (__    
11 (_____  )   | |   |  ___  ||     __)| | ____ |  ___  |   | |   |  __)   
12       ) |   | |   | (   ) || (\ (   | | \_  )| (   ) |   | |   | (      
13 /\____) |   | |   | )   ( || ) \ \__| (___) || )   ( |   | |   | (____/\
14 \_______)   )_(   |/     \||/   \__/(_______)|/     \|   )_(   (_______/
15                                                                       
16 *
17 *
18 *                       Website:  https://playstargate.com
19 *
20 *                       Discord:  https://discord.gg/PnbFSa2
21 *
22 *                       Support:  ethergamedev@gmail.com
23 *
24 *
25 *
26 *   Stargate is a unique game of chance where you can win 10X or more of you
27 *   original wager.  Stargate features a progressive jackpot which grows with each bet.
28 *
29 *
30 *
31 *
32 *
33 */
34 
35 
36 // <ORACLIZE_API>
37 /*
38 Copyright (c) 2015-2016 Oraclize SRL
39 Copyright (c) 2016 Oraclize LTD
40 
41 
42 
43 Permission is hereby granted, free of charge, to any person obtaining a copy
44 of this software and associated documentation files (the "Software"), to deal
45 in the Software without restriction, including without limitation the rights
46 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
47 copies of the Software, and to permit persons to whom the Software is
48 furnished to do so, subject to the following conditions:
49 
50 
51 
52 The above copyright notice and this permission notice shall be included in
53 all copies or substantial portions of the Software.
54 
55 
56 
57 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
58 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
59 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
60 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
61 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
62 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
63 THE SOFTWARE.
64 */
65 
66 pragma solidity ^0.4.0; //please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
67 
68 contract OraclizeI {
69     address public cbAddress;
70     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
71     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
72     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
73     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
74     function getPrice(string _datasource) returns (uint _dsprice);
75     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
76     function useCoupon(string _coupon);
77     function setProofType(byte _proofType);
78     function setConfig(bytes32 _config);
79     function setCustomGasPrice(uint _gasPrice);
80 }
81 contract OraclizeAddrResolverI {
82     function getAddress() returns (address _addr);
83 }
84 contract usingOraclize {
85     uint constant day = 60*60*24;
86     uint constant week = 60*60*24*7;
87     uint constant month = 60*60*24*30;
88     byte constant proofType_NONE = 0x00;
89     byte constant proofType_TLSNotary = 0x10;
90     byte constant proofStorage_IPFS = 0x01;
91     uint8 constant networkID_auto = 0;
92     uint8 constant networkID_mainnet = 1;
93     uint8 constant networkID_testnet = 2;
94     uint8 constant networkID_morden = 2;
95     uint8 constant networkID_consensys = 161;
96 
97     OraclizeAddrResolverI OAR;
98     
99     OraclizeI oraclize;
100     modifier oraclizeAPI {
101         if(address(OAR)==0) oraclize_setNetwork(networkID_auto);
102         oraclize = OraclizeI(OAR.getAddress());
103         _;
104     }
105     modifier coupon(string code){
106         oraclize = OraclizeI(OAR.getAddress());
107         oraclize.useCoupon(code);
108         _;
109     }
110 
111     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
112         if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)>0){ //mainnet
113             OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
114             return true;
115         }
116         if (getCodeSize(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1)>0){ //ropsten testnet
117             OAR = OraclizeAddrResolverI(0xc03a2615d5efaf5f49f60b7bb6583eaec212fdf1);
118             return true;
119         }
120         if (getCodeSize(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa)>0){ //browser-solidity
121             OAR = OraclizeAddrResolverI(0x51efaf4c8b3c9afbd5ab9f4bbc82784ab6ef8faa);
122             return true;
123         }
124         return false;
125     }
126     
127     function __callback(bytes32 myid, string result) {
128         __callback(myid, result, new bytes(0));
129     }
130     function __callback(bytes32 myid, string result, bytes proof) {
131     }
132     
133     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
134         return oraclize.getPrice(datasource);
135     }
136     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
137         return oraclize.getPrice(datasource, gaslimit);
138     }
139     
140     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
141         uint price = oraclize.getPrice(datasource);
142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
143         return oraclize.query.value(price)(0, datasource, arg);
144     }
145     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
146         uint price = oraclize.getPrice(datasource);
147         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
148         return oraclize.query.value(price)(timestamp, datasource, arg);
149     }
150     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
151         uint price = oraclize.getPrice(datasource, gaslimit);
152         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
153         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
154     }
155     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
156         uint price = oraclize.getPrice(datasource, gaslimit);
157         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
158         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
159     }
160     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource);
162         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
163         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
164     }
165     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource);
167         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
168         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
169     }
170     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
171         uint price = oraclize.getPrice(datasource, gaslimit);
172         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
173         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
174     }
175     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource, gaslimit);
177         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
178         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
179     }
180     function oraclize_cbAddress() oraclizeAPI internal returns (address){
181         return oraclize.cbAddress();
182     }
183     function oraclize_setProof(byte proofP) oraclizeAPI internal {
184         return oraclize.setProofType(proofP);
185     }
186     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
187         return oraclize.setCustomGasPrice(gasPrice);
188     }    
189     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
190         return oraclize.setConfig(config);
191     }
192 
193     function getCodeSize(address _addr) constant internal returns(uint _size) {
194         assembly {
195             _size := extcodesize(_addr)
196         }
197     }
198 
199 
200     function parseAddr(string _a) internal returns (address){
201         bytes memory tmp = bytes(_a);
202         uint160 iaddr = 0;
203         uint160 b1;
204         uint160 b2;
205         for (uint i=2; i<2+2*20; i+=2){
206             iaddr *= 256;
207             b1 = uint160(tmp[i]);
208             b2 = uint160(tmp[i+1]);
209             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
210             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
211             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
212             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
213             iaddr += (b1*16+b2);
214         }
215         return address(iaddr);
216     }
217 
218 
219     function strCompare(string _a, string _b) internal returns (int) {
220         bytes memory a = bytes(_a);
221         bytes memory b = bytes(_b);
222         uint minLength = a.length;
223         if (b.length < minLength) minLength = b.length;
224         for (uint i = 0; i < minLength; i ++)
225             if (a[i] < b[i])
226                 return -1;
227             else if (a[i] > b[i])
228                 return 1;
229         if (a.length < b.length)
230             return -1;
231         else if (a.length > b.length)
232             return 1;
233         else
234             return 0;
235    } 
236 
237     function indexOf(string _haystack, string _needle) internal returns (int)
238     {
239         bytes memory h = bytes(_haystack);
240         bytes memory n = bytes(_needle);
241         if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
242             return -1;
243         else if(h.length > (2**128 -1))
244             return -1;                                  
245         else
246         {
247             uint subindex = 0;
248             for (uint i = 0; i < h.length; i ++)
249             {
250                 if (h[i] == n[0])
251                 {
252                     subindex = 1;
253                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
254                     {
255                         subindex++;
256                     }   
257                     if(subindex == n.length)
258                         return int(i);
259                 }
260             }
261             return -1;
262         }   
263     }
264 
265     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
266         bytes memory _ba = bytes(_a);
267         bytes memory _bb = bytes(_b);
268         bytes memory _bc = bytes(_c);
269         bytes memory _bd = bytes(_d);
270         bytes memory _be = bytes(_e);
271         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
272         bytes memory babcde = bytes(abcde);
273         uint k = 0;
274         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
275         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
276         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
277         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
278         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
279         return string(babcde);
280     }
281     
282     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
283         return strConcat(_a, _b, _c, _d, "");
284     }
285 
286     function strConcat(string _a, string _b, string _c) internal returns (string) {
287         return strConcat(_a, _b, _c, "", "");
288     }
289 
290     function strConcat(string _a, string _b) internal returns (string) {
291         return strConcat(_a, _b, "", "", "");
292     }
293 
294     // parseInt
295     function parseInt(string _a) internal returns (uint) {
296         return parseInt(_a, 0);
297     }
298 
299     // parseInt(parseFloat*10^_b)
300     function parseInt(string _a, uint _b) internal returns (uint) {
301         bytes memory bresult = bytes(_a);
302         uint mint = 0;
303         bool decimals = false;
304         for (uint i=0; i<bresult.length; i++){
305             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
306                 if (decimals){
307                    if (_b == 0) break;
308                     else _b--;
309                 }
310                 mint *= 10;
311                 mint += uint(bresult[i]) - 48;
312             } else if (bresult[i] == 46) decimals = true;
313         }
314         if (_b > 0) mint *= 10**_b;
315         return mint;
316     }
317     
318     function uint2str(uint i) internal returns (string){
319         if (i == 0) return "0";
320         uint j = i;
321         uint len;
322         while (j != 0){
323             len++;
324             j /= 10;
325         }
326         bytes memory bstr = new bytes(len);
327         uint k = len - 1;
328         while (i != 0){
329             bstr[k--] = byte(48 + i % 10);
330             i /= 10;
331         }
332         return string(bstr);
333     }
334     
335     
336 
337 }
338 // </ORACLIZE_API>
339 
340 
341 
342 // Stargate game data setup
343 contract Stargate is usingOraclize {
344     using SafeMath for uint;
345 
346     // ---------------------- Events
347 
348     event LogResult(
349         address _wagerer,
350         uint _result,
351         uint _profit,
352         uint _wagered,
353         uint _category,
354         bool _win,
355         uint _originalBet
356     );
357 
358     event onWithdraw(
359         address customerAddress,
360         uint256 ethereumWithdrawn
361     );
362 
363     event betError(
364         address indexed _wagerer,
365         uint _result
366     );
367 
368     event modError(
369         address indexed _wagerer,
370         uint _result
371     );
372 
373      // Result announcement events
374     event LOG_NewBet(address _wagerer, uint amount);
375     event Deposit(address indexed sender, uint value);
376     event Loss(address _wagerer, uint _block);                  // Category 0
377     event Cat1(address _wagerer, uint _block);                  // Category 1
378     event Cat2(address _wagerer, uint _block);                  // Category 2
379     event Cat3(address _wagerer, uint _block);                  // Category 3
380     event Cat4(address _wagerer, uint _block);                  // Category 4
381     event Cat5(address _wagerer, uint _block);                  // Category 5
382     event Cat6(address _wagerer, uint _block);                  // Category 6
383     event Cat7(address _wagerer, uint _block);                  // Category 7
384     event Cat8(address _wagerer, uint _block);                  // Category 8
385     event Cat9(address _wagerer, uint _block);                  // Category 9
386     event Cat10(address _wagerer, uint _block);                 // Category 10
387     event Cat11(address _wagerer, uint _block);                 // Category 11
388     event Cat12(address _wagerer, uint _block);                 // Category 12
389     event Cat13(address _wagerer, uint _block);                 // Category 13
390     event Cat14(address _wagerer, uint _block);                 // Category 14
391     event Cat15(address _wagerer, uint _block);                 // Category 15
392     event Cat16(address _wagerer, uint _block);                 // Category 16
393     event Cat17(address _wagerer, uint _block);                 // Category 17
394     event Cat18(address _wagerer, uint _block);                 // Category 18
395     event Cat19(address _wagerer, uint _block);                 // Category 19    
396     event BetConcluded(address _wagerer, uint _block);          // Debug event
397 
398     event LogConstructorInitiated(string nextStep);
399     event LogPriceUpdated(string price);
400     event LogNewOraclizeQuery(string description);
401 
402    
403     // ---------------------- Modifiers
404 
405     // Makes sure bet is within Min and Max Range
406     modifier betIsValid(uint _betSize) {
407         require(_betSize <= maxBet);
408         require(_betSize >= minBet);
409       _;
410     }
411 
412       // only people with winnings
413     modifier onlyPlayers(address _player) {
414         require(playerAccount[_player] > 0);
415         _;
416     }
417 
418     // Requires the game to be currently active
419     modifier gameIsActive {
420       require(gamePaused == false);
421       _;
422     }
423 
424     // Require msg.sender to be owner
425     modifier onlyOwner {
426       require(msg.sender == owner); 
427       _;
428     }
429 
430     modifier onlyOraclize {
431         if (msg.sender != oraclize_cbAddress()) throw; 
432         _;
433     }
434 
435     modifier onlyIfBetExist(bytes32 myid) {
436         if(bets[myid].playerAddress == address(0x0)) throw;
437         _;
438     }
439 
440     modifier onlyIfValidGas(uint newGasLimit) {
441         if (ORACLIZE_GAS_LIMIT + newGasLimit < ORACLIZE_GAS_LIMIT) throw;
442         if (newGasLimit < 25000) throw;
443         _;
444     }
445 
446     modifier onlyIfNotProcessed(bytes32 myid) {
447         if (bets[myid].numberRolled > 0) throw;
448         _;
449     }
450 
451     struct Bet {
452         address playerAddress;
453         uint amountBet;
454         uint numberRolled;
455         uint originalBet;
456         bool instaPay;
457     }
458 
459     // ---------------------- Variables
460 
461     // Configurables
462     uint maxProfit;
463 
464     mapping (address => uint256) public playerAccount;
465     uint public maxProfitAsPercentOfHouse;
466     uint public minBet = 5e16;  //0.05ETH
467     uint public maxBet = 2e17;  //0.20ETH  This will increase with contract value
468 
469     mapping (address => uint256) public playerETHWagered;
470     mapping (address => uint256) public playerETHWon;
471  
472     address private owner;
473     address private bankroll;
474     bool gamePaused;
475     bool boolJackpotFee;
476     uint jackpotDivisor;
477 
478     //Random Number Functions
479     uint public randN = 3;          //numberof random bytes to be returned
480     uint public randDelay = 0;      //number of seconds to delay result
481     uint public maxRange = 1000000; //Max Random Number
482 
483     // Trackers
484     //uint  public totalSpins;
485     uint  public totalBets;
486      uint  public totalCalls;
487     uint  public totalETHWagered;
488     //mapping (uint => uint) public contractBalance;
489     
490     // Is betting allowed? (Administrative function, in the event of unforeseen bugs)
491     bool public gameActive;
492 
493 
494     uint256 public jackpot;
495     uint256 private houseAccount;
496     uint256 public bankAccount;
497     uint256 public contractBalance;
498     uint private maxPayoutMultiple;
499     uint256 public totalPlayerBalance;
500     uint public lastResult;
501     uint256 private lastBlock;
502     uint48 private lastSpinBlock; 
503     uint lastCategory;
504     uint public lastProfit;
505     uint public numBets;
506 
507     mapping(uint => uint256) winThreshold;
508     mapping(uint => uint) winPercentage;
509 
510     
511 
512     mapping (bytes32 => Bet) public bets;
513     bytes32[] public betsKeys;
514 
515     uint[] public arrResult;
516 
517     uint ORACLIZE_GAS_LIMIT = 400000;   //250000;
518     uint safeGas = 2300;
519     uint public customGasPrice = 7000000000;  //7GWEI
520 
521     uint public oracleFee = 0;
522 
523     
524 
525     
526     uint256 public lastOraclePrice;
527     //uint256 public contractBalance;
528     uint public lastOracleFee;
529 
530     bool public allowReferrals;
531     uint public referralPercent;
532     uint public minReferAmount = 100000000000000000;    //0.1 ETH min wagered to qualify for a masternode
533 
534     // ---------------------- Functions 
535 
536     constructor() public  {
537 
538         owner = msg.sender;
539 
540         //oraclize_setProof(proofType_Ledger);
541 
542         // Set starting variables
543         gameActive  = true;
544 
545         allowReferrals = false;
546         referralPercent = 1;
547 
548         jackpot = 0;
549         totalPlayerBalance = 0;
550         houseAccount = 0;
551         bankAccount = 0;
552         maxPayoutMultiple = 15;
553 
554         boolJackpotFee = false;
555         jackpotDivisor = 100;
556 
557         winThreshold[0] = 900000;
558         winThreshold[1] = 2;
559         winThreshold[2] = 299;
560         winThreshold[3] = 3128;
561         winThreshold[4] = 16961;
562         winThreshold[5] = 30794;
563         winThreshold[6] = 44627;
564         winThreshold[7] = 46627;
565         winThreshold[8] = 49627;
566         winThreshold[9] = 51627;
567         winThreshold[10] = 53127;
568         winThreshold[11] = 82530;
569         winThreshold[12] = 150423;
570         winThreshold[13] = 203888;
571         winThreshold[14] = 257353;
572         winThreshold[15] = 310818;
573         winThreshold[16] = 364283;
574         winThreshold[17] = 417748;
575         winThreshold[18] = 471213;
576 
577         winPercentage[2] = 1000;        
578         winPercentage[3] = 500;        
579         winPercentage[4] = 200;         
580         winPercentage[5] = 200;         
581         winPercentage[6] = 200;         
582         winPercentage[7] = 500;        
583         winPercentage[8] = 750;         
584         winPercentage[9] = 400;         
585         winPercentage[10] = 400;       
586         winPercentage[11] = 250;        
587         winPercentage[12] = 150;        
588         winPercentage[13] = 75;         
589         winPercentage[14] = 75;         
590         winPercentage[15] = 75;         
591         winPercentage[16] = 100;        
592         winPercentage[17] = 75;        
593         winPercentage[18] = 75;        
594         winPercentage[19] = 33;        
595 
596     }
597 
598      function deposit()
599         public
600         payable
601     {
602         addContractBalance(msg.value);
603         bankAccount = SafeMath.add(bankAccount, msg.value);
604     }
605 
606 
607     function withdrawWinnings()
608         onlyPlayers(msg.sender)
609         public
610     {
611         // setup data
612         uint256 _winnings = playerAccount[msg.sender]; 
613         require( _winnings < address(this).balance - jackpot);
614         playerAccount[msg.sender] = 0;
615         totalPlayerBalance = SafeMath.sub(totalPlayerBalance, _winnings);
616         msg.sender.transfer(_winnings);
617         subContractBalance(_winnings);
618             
619         // fire event
620         emit onWithdraw(msg.sender, _winnings);
621 
622     }
623 
624      function()
625         payable {
626 
627         bet(true, 0x0000000000000000000000000000000000000000);
628     }
629 
630   // Execute bet.
631     function bet(bool _instaPay, address _referrer) 
632       public
633       payable
634       betIsValid(msg.value)   
635     {
636         require(msg.value > 0);
637         require(gameActive);
638 
639 
640         totalETHWagered += msg.value;
641         playerETHWagered[msg.sender] = SafeMath.add(playerETHWagered[msg.sender], msg.value);
642 
643         addContractBalance(msg.value);
644 
645         uint betValue = msg.value - oracleFee;
646 
647         if (allowReferrals && _referrer != 0x0000000000000000000000000000000000000000 && (_referrer != msg.sender) && (playerETHWagered[_referrer] >= minReferAmount)){
648             
649             uint refererAmount = SafeMath.div(SafeMath.mul(betValue,referralPercent),100);
650             betValue = SafeMath.sub(betValue,refererAmount);
651             playerAccount[_referrer] = SafeMath.add(playerAccount[_referrer], refererAmount);
652             totalPlayerBalance = SafeMath.add(totalPlayerBalance, refererAmount);
653         }
654 
655         
656        
657         LOG_NewBet(msg.sender, msg.value);
658 
659         // Increment total number of bets
660         totalBets += 1;
661 
662         oraclize_setCustomGasPrice(customGasPrice);
663 
664         //bytes32 myid = oraclize_newRandomDSQuery(randDelay, randN, ORACLIZE_GAS_LIMIT + safeGas);
665 
666         bytes32 myid = oraclize_query("WolframAlpha", "random number between 1 and 1000000", ORACLIZE_GAS_LIMIT + safeGas);
667 
668         bets[myid] = Bet(msg.sender, betValue, 0, msg.value, _instaPay);
669         betsKeys.push(myid);
670 
671   
672     }
673 
674      function __callback(bytes32 myid, string strResult)
675         onlyOraclize 
676         onlyIfBetExist(myid)
677         onlyIfNotProcessed(myid)
678       {
679          
680         totalCalls = totalCalls + 1;
681         uint result = parseInt(strResult);
682         bets[myid].numberRolled = result;
683         arrResult.push(result);
684 
685         //uint result = parseInt(strResult);
686 
687         bets[myid].numberRolled = result;
688         arrResult.push(result);
689 
690 
691         uint256 betAmount = bets[myid].amountBet;
692        
693         jackpot = SafeMath.add(jackpot,SafeMath.div(betAmount,jackpotDivisor));
694         
695         if (boolJackpotFee){
696             betAmount = SafeMath.sub(betAmount,SafeMath.div(betAmount,jackpotDivisor));
697         }
698 
699         uint profit = 0;
700         uint category = 0;
701 
702         lastResult = result;
703 
704         checkResult(bets[myid].playerAddress, betAmount, category, result, myid);
705        
706         emit BetConcluded(bets[myid].playerAddress, result);
707     
708         }
709     
710 
711 
712 function checkResult(address target, uint256 betAmount, uint category, uint _result, bytes32 myid) internal {
713   
714   uint _originalBet = bets[myid].amountBet;
715   bool _instaPay = bets[myid].instaPay;
716 
717   uint profit = 0; 
718 
719    if (_result > winThreshold[0]) {   
720             // Player has lost. 
721 
722             category = 0;
723             emit Loss(target, _result);
724            
725         
726         } else if (_result < winThreshold[1]) {  //2
727             // Player has won the jackpot!
728       
729             // Get profit amount via jackpot
730             profit = jackpot;    
731             category = 1;
732             jackpot = 0;
733             // Emit events
734             emit Cat1(target, _result);
735           
736 
737            if (_instaPay){
738                 if(profit > 0){
739                     if (profit <= (address(this).balance - jackpot - totalPlayerBalance)){
740                         target.transfer(profit);
741                         subContractBalance(profit);
742                         playerETHWon[target] = SafeMath.add(playerETHWon[target], profit);
743                     }else
744                         {
745                         playerAccount[target] = SafeMath.add(playerAccount[target],profit);
746                         totalPlayerBalance = SafeMath.add(totalPlayerBalance, profit);
747                         playerETHWon[target] = SafeMath.add(playerETHWon[target], profit);
748                         }
749 
750                     }
751                 }else{
752                     playerAccount[target] = SafeMath.add(playerAccount[target], profit);
753                     totalPlayerBalance = SafeMath.add(totalPlayerBalance, profit);
754                     playerETHWon[target] = SafeMath.add(playerETHWon[target], profit);
755                 }
756 
757 
758             } else {
759                 if (_result < winThreshold[2]) {  //299
760                     category = 2;
761                     emit Cat2(target, _result);
762                 } else if (_result < winThreshold[3]) {  //3128
763                     category = 3;
764                     emit Cat3(target, _result);
765                 } else if (_result < winThreshold[4]) {  //16961
766                     category = 4;
767                     emit Cat4(target, _result);
768                 } else if (_result < winThreshold[5]) {  //30794
769                     category = 5;
770                     emit Cat5(target, _result);
771                 } else if (_result < winThreshold[6]) {  //44627
772                     category = 6;
773                     emit Cat6(target, _result);
774                 } else if (_result < winThreshold[7]) {  //46627
775                     category = 7;
776                     emit Cat7(target, _result);
777                 } else if (_result < winThreshold[8]) {  //49127
778                     category = 8;
779                     emit Cat8(target, _result);
780                 } else if (_result < winThreshold[9]) {  //51627
781                     category = 9;
782                     emit Cat9(target, _result);
783                 } else if (_result < winThreshold[10]) {  //53127
784                     category = 10;
785                     emit Cat10(target, _result);
786                 } else if (_result < winThreshold[11]) {  //82530
787                     category = 11;
788                     emit Cat11(target, _result);
789                 } else if (_result < winThreshold[12]) {  //150423
790                     category = 12;
791                     emit Cat12(target, _result);
792                 } else if (_result < winThreshold[13]) {  //203888
793                     category = 13;
794                     emit Cat13(target, _result);
795                 } else if (_result < winThreshold[14]) {  //257353
796                     category = 14;
797                     emit Cat14(target, _result);
798                 } else if (_result < winThreshold[15]) {  //310818
799                     category = 15;
800                     emit Cat15(target, _result);
801                 } else if (_result < winThreshold[16]) {  //364283
802                     category = 16;
803                     emit Cat16(target, _result);
804                 } else if (_result < winThreshold[17]) {  //417748
805                     category = 17;
806                     emit Cat17(target, _result);
807                 } else if (_result < winThreshold[18]) {  //471213
808                     category = 18;
809                     emit Cat18(target, _result);
810                 } else {
811                     category = 19;
812                     emit Cat19(target, _result);
813                 }
814                 lastCategory = category;
815             }
816 
817             distributePrize(target, betAmount, category, _result, _originalBet, _instaPay);
818 
819         }
820 
821     
822 
823     //Distribute Prize
824     function distributePrize(address target, uint256 betAmount, uint category, uint _result, uint _originalBet, bool _instaPay) internal {
825         
826         uint256 profit = 0;
827      
828         if (category >= 2 && category <= 19){
829             profit = SafeMath.div(SafeMath.mul(betAmount,winPercentage[category]),100);
830         }
831 
832         if (_instaPay){
833             if(profit>0){
834 
835                 uint256 _maxWithdraw = address(this).balance;
836                 if (profit <= _maxWithdraw){
837                     target.transfer(profit);
838                     subContractBalance(profit);
839                 } else {
840                     playerAccount[target] = SafeMath.add(playerAccount[target],profit);
841                     totalPlayerBalance = SafeMath.add(totalPlayerBalance, profit);
842                     playerETHWon[target] = SafeMath.add(playerETHWon[target], profit);
843                 }
844 
845 
846             }
847         }else{
848             playerAccount[target] = SafeMath.add(playerAccount[target], profit);
849             totalPlayerBalance = SafeMath.add(totalPlayerBalance, profit);
850         }
851 
852         lastProfit = profit;
853         playerETHWon[target] = SafeMath.add(playerETHWon[target], profit);
854 
855 
856         emit LogResult(target, _result, profit, betAmount, category, true, _originalBet);
857    
858         
859     }
860 
861 
862      function setWinPercentage(uint _category, uint _percentage) public onlyOwner {
863         winPercentage[_category] = _percentage;
864     }
865 
866      function setWinThreshold(uint _category, uint _threshold) public onlyOwner {
867         winThreshold[_category] = _threshold;
868     }
869 
870      function getWinPercentage(uint _category) public view returns(uint){
871         return(winPercentage[_category]);
872     }
873 
874     function getWinThreshold(uint _category) public view returns(uint){
875         return(winThreshold[_category]);
876     }
877 
878     // Subtracts from the contract balance tracking var
879     function subContractBalance(uint256 sub) internal {
880       contractBalance = contractBalance.sub(sub);
881 
882     }
883 
884     // Adds to the contract balance tracking var
885     function addContractBalance(uint add) internal {
886       contractBalance = contractBalance.add(add);
887     }
888 
889     // Only owner can set minBet   
890     function ownerSetMinBet(uint newMinimumBet) public
891     onlyOwner
892     {
893       minBet = newMinimumBet;
894     }
895 
896     // Only owner can set maxBet   
897     function ownerSetMaxBet(uint newMaximumBet) public
898     onlyOwner
899     {
900       maxBet = newMaximumBet;
901     }
902 
903     function setGasLimit(uint _gas) public onlyOwner   {
904         ORACLIZE_GAS_LIMIT = _gas;
905     }
906 
907     function getGasLimit() public view returns(uint){
908         return(ORACLIZE_GAS_LIMIT);
909     }
910 
911 
912     // If, for any reason, betting needs to be paused (very unlikely), this will freeze all bets.
913     function pauseGame() public onlyOwner {
914         gameActive = false;
915     }
916 
917     // The converse of the above, resuming betting if a freeze had been put in place.
918     function resumeGame() public onlyOwner {
919         gameActive = true;
920     }
921 
922     // Administrative function to change the owner of the contract.
923     function changeOwner(address _newOwner) public onlyOwner {
924         owner = _newOwner;
925     }
926 
927     function setOracleFee(uint256 _newFee) public onlyOwner {
928         oracleFee = _newFee;
929     }
930 
931     function setAllowReferral(bool _allow) public onlyOwner {
932         allowReferrals = _allow;
933     }
934 
935     function setReferralPercent(uint _percent) public onlyOwner {
936         referralPercent = _percent;
937     }
938 
939     function setMaxRange(uint _newRange) public onlyOwner {
940         maxRange = _newRange;
941     }
942 
943     function setRandN(uint _newN) public onlyOwner {
944         randN = _newN;
945     }
946 
947     function setRandDelay(uint _newDelay) public onlyOwner {
948         randDelay = _newDelay;
949     }
950 
951     function setMinReferer(uint _newAmount) public onlyOwner {
952         minReferAmount = _newAmount;
953     }
954 
955     function setStargateCustomGasPrice(uint _newPrice) public onlyOwner {
956         customGasPrice = _newPrice;
957     }
958     
959     function getContractBalance() public view returns(uint256) {
960         return(address(this).balance);
961     }
962 
963     function getMyBalance() public view returns(uint256) {
964         return(playerAccount[msg.sender]);
965     }
966 
967     function getJackpot() public view returns(uint256){
968         return(jackpot);
969     }
970 
971     function getBankAccount() public view returns(uint256){
972         return(bankAccount);
973     }
974 
975     function getLastBlock() public view returns(uint256){
976         return(lastBlock);
977     }
978 
979     function getLastResult() public view returns(uint){
980         return(lastResult);
981     }
982 
983     function getLastCategory() public view returns(uint){
984         return(lastCategory);
985     }
986     function getLastProfit() public view returns(uint){
987         return(lastProfit);
988     }
989 
990     function refund(address _to, uint256 _Amount) public onlyOwner 
991     
992     {
993         uint256 _maxRefund = address(this).balance - jackpot - totalPlayerBalance;
994 
995        require(_Amount <= _maxRefund);
996         _to.transfer(_Amount);
997         subContractBalance(_Amount);
998 
999         
1000     }
1001 
1002 }
1003 
1004 
1005 /**
1006  * @title SafeMath
1007  * @dev Math operations with safety checks that throw on error
1008  */
1009 library SafeMath {
1010 
1011     /**
1012     * @dev Multiplies two numbers, throws on overflow.
1013     */
1014     function mul(uint a, uint b) internal pure returns (uint) {
1015         if (a == 0) {
1016             return 0;
1017         }
1018         uint c = a * b;
1019         assert(c / a == b);
1020         return c;
1021     }
1022 
1023     /**
1024     * @dev Integer division of two numbers, truncating the quotient.
1025     */
1026     function div(uint a, uint b) internal pure returns (uint) {
1027         // assert(b > 0); // Solidity automatically throws when dividing by 0
1028         uint c = a / b;
1029         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1030         return c;
1031     }
1032 
1033     /**
1034     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1035     */
1036     function sub(uint a, uint b) internal pure returns (uint) {
1037         assert(b <= a);
1038         return a - b;
1039     }
1040 
1041     /**
1042     * @dev Adds two numbers, throws on overflow.
1043     */
1044     function add(uint a, uint b) internal pure returns (uint) {
1045         uint c = a + b;
1046         assert(c >= a);
1047         return c;
1048     }
1049 }