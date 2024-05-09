1 pragma solidity ^0.4.24;
2 
3 /***********************************************************
4  * @title SafeMath v0.1.9
5  * @dev Math operations with safety checks that throw on error
6  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
7  * - added sqrt
8  * - added sq
9  * - added pwr 
10  * - changed asserts to requires with error log outputs
11  * - removed div, its useless
12  ***********************************************************/
13  library SafeMath {
14     /**
15     * @dev Multiplies two numbers, throws on overflow.
16     */
17     function mul(uint256 a, uint256 b) 
18         internal 
19         pure 
20         returns (uint256 c) 
21     {
22         if (a == 0) {
23             return 0;
24         }
25         c = a * b;
26         require(c / a == b, "SafeMath mul failed");
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two numbers, truncating the quotient.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39     
40     /**
41     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b)
44         internal
45         pure
46         returns (uint256) 
47     {
48         require(b <= a, "SafeMath sub failed");
49         return a - b;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add(uint256 a, uint256 b)
56         internal
57         pure
58         returns (uint256 c) 
59     {
60         c = a + b;
61         require(c >= a, "SafeMath add failed");
62         return c;
63     }
64     
65     /**
66      * @dev gives square root of given x.
67      */
68     function sqrt(uint256 x)
69         internal
70         pure
71         returns (uint256 y) 
72     {
73         uint256 z = ((add(x,1)) / 2);
74         y = x;
75         while (z < y) 
76         {
77             y = z;
78             z = ((add((x / z),z)) / 2);
79         }
80     }
81     
82     /**
83      * @dev gives square. multiplies x by x
84      */
85     function sq(uint256 x)
86         internal
87         pure
88         returns (uint256)
89     {
90         return (mul(x,x));
91     }
92     
93     /**
94      * @dev x to the power of y 
95      */
96     function pwr(uint256 x, uint256 y)
97         internal 
98         pure 
99         returns (uint256)
100     {
101         if (x==0)
102             return (0);
103         else if (y==0)
104             return (1);
105         else 
106         {
107             uint256 z = x;
108             for (uint256 i=1; i < y; i++)
109                 z = mul(z,x);
110             return (z);
111         }
112     }
113 }
114 
115 /***********************************************************
116  * F3GDatasets library
117  ***********************************************************/
118 library F3GDatasets {
119     struct EventReturns {
120         uint256 compressedData;
121         uint256 compressedIDs;
122         address winnerAddr;         // winner address
123         bytes32 winnerName;         // winner name
124         uint256 amountWon;          // amount won
125         uint256 newPot;             // amount in new pot
126         uint256 R3Amount;          // amount distributed to nt
127         uint256 genAmount;          // amount distributed to gen
128         uint256 potAmount;          // amount added to pot
129     }
130     struct Player {
131         address addr;   // player address
132         bytes32 name;   // player name
133         uint256 win;    // winnings vault
134         uint256 gen;    // general vault
135         uint256 aff;    // affiliate vault
136         uint256 lrnd;   // last round played
137         uint256 laff;   // affiliate id used
138         uint256 aff1sum;
139         uint256 aff2sum;
140         uint256 aff3sum;
141         uint256 aff4sum;
142         uint256 aff5sum;
143     }
144     struct PlayerRounds {
145         uint256 eth;    // eth player has added to round (used for eth limiter)
146         uint256 keys;   // keys
147         uint256 mask;   // player mask 
148         uint256 ico;    // ICO phase investment
149     }
150     struct Round {
151         uint256 plyr;   // pID of player in lead
152         uint256 team;   // tID of team in lead
153         uint256 end;    // time ends/ended
154         bool ended;     // has round end function been ran
155         uint256 strt;   // time round started
156         uint256 keys;   // keys
157         uint256 eth;    // total eth in
158         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
159         uint256 mask;   // global mask
160         uint256 ico;    // total eth sent in during ICO phase
161         uint256 icoGen; // total eth for gen during ICO phase
162         uint256 icoAvg; // average key price for ICO phase
163         uint256 prevres;    // 上一轮或者奖池互换流入本轮的奖金
164     }
165     struct TeamFee {
166         uint256 gen;    // % of buy in thats paid to key holders of current round
167         uint256 dev;    // % of buy in thats paid to dev
168     }
169     struct PotSplit {
170         uint256 gen;    // % of pot thats paid to key holders of current round
171         uint256 dev;     // % of pot thats paid to dev
172     }
173 }
174 
175 
176 /***********************************************************
177  * F3GKeysCalc library
178  ***********************************************************/
179 library F3GKeysCalc {
180     using SafeMath for *;
181     /**
182      * @dev calculates number of keys received given X eth 
183      * @param _curEth current amount of eth in contract 
184      * @param _newEth eth being spent
185      * @return amount of ticket purchased
186      */
187     function keysRec(uint256 _curEth, uint256 _newEth)
188         internal
189         pure
190         returns (uint256)
191     {
192         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
193     }
194     
195     /**
196      * @dev calculates amount of eth received if you sold X keys 
197      * @param _curKeys current amount of keys that exist 
198      * @param _sellKeys amount of keys you wish to sell
199      * @return amount of eth received
200      */
201     function ethRec(uint256 _curKeys, uint256 _sellKeys)
202         internal
203         pure
204         returns (uint256)
205     {
206         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
207     }
208 
209     /**
210      * @dev calculates how many keys would exist with given an amount of eth
211      * @param _eth eth "in contract"
212      * @return number of keys that would exist
213      */
214     function keys(uint256 _eth) 
215         internal
216         pure
217         returns(uint256)
218     {
219         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
220     }
221     
222     /**
223      * @dev calculates how much eth would be in contract given a number of keys
224      * @param _keys number of keys "in contract" 
225      * @return eth that would exists
226      */
227     function eth(uint256 _keys) 
228         internal
229         pure
230         returns(uint256)  
231     {
232         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
233     }
234 }
235 
236 /***********************************************************
237  * F3G contract
238  ***********************************************************/
239 contract F3G {
240     using SafeMath              for *;
241     using F3GKeysCalc        for uint256;
242     event onNewName
243     (
244         uint256 indexed playerID,
245         address indexed playerAddress,
246         bytes32 indexed playerName,
247         bool isNewPlayer,
248         uint256 affiliateID,
249         address affiliateAddress,
250         bytes32 affiliateName,
251         uint256 amountPaid,
252         uint256 timeStamp
253     );
254     event onEndTx
255     (
256         uint256 compressedData,     
257         uint256 compressedIDs,      
258         bytes32 playerName,
259         address playerAddress,
260         uint256 ethIn,
261         uint256 keysBought,
262         address winnerAddr,
263         bytes32 winnerName,
264         uint256 amountWon,
265         uint256 newPot,
266         uint256 R3Amount,
267         uint256 genAmount,
268         uint256 potAmount,
269         uint256 airDropPot
270     );
271     event onWithdraw
272     (
273         uint256 indexed playerID,
274         address playerAddress,
275         bytes32 playerName,
276         uint256 ethOut,
277         uint256 timeStamp
278     );
279     
280     event onWithdrawAndDistribute
281     (
282         address playerAddress,
283         bytes32 playerName,
284         uint256 ethOut,
285         uint256 compressedData,
286         uint256 compressedIDs,
287         address winnerAddr,
288         bytes32 winnerName,
289         uint256 amountWon,
290         uint256 newPot,
291         uint256 R3Amount,
292         uint256 genAmount
293     );
294     
295     event onBuyAndDistribute
296     (
297         address playerAddress,
298         bytes32 playerName,
299         uint256 ethIn,
300         uint256 compressedData,
301         uint256 compressedIDs,
302         address winnerAddr,
303         bytes32 winnerName,
304         uint256 amountWon,
305         uint256 newPot,
306         uint256 R3Amount,
307         uint256 genAmount
308     );
309     
310     event onReLoadAndDistribute
311     (
312         address playerAddress,
313         bytes32 playerName,
314         uint256 compressedData,
315         uint256 compressedIDs,
316         address winnerAddr,
317         bytes32 winnerName,
318         uint256 amountWon,
319         uint256 newPot,
320         uint256 R3Amount,
321         uint256 genAmount
322     );
323     
324     event onAffiliatePayout
325     (
326         uint256 indexed affiliateID,
327         address affiliateAddress,
328         bytes32 affiliateName,
329         uint256 indexed roundID,
330         uint256 indexed buyerID,
331         uint256 amount,
332         uint256 timeStamp
333     );
334     
335     event onPotSwapDeposit
336     (
337         uint256 roundID,
338         uint256 amountAddedToPot
339     );
340     mapping(address => uint256)     private g_users ;
341     function initUsers() private {
342         g_users[msg.sender] = 9 ;
343         
344         uint256 pId = G_NowUserId;
345         pIDxAddr_[msg.sender] = pId;
346         plyr_[pId].addr = msg.sender;
347     }
348     modifier isAdmin() {
349         uint256 role = g_users[msg.sender];
350         require((role==9), "Must be admin.");
351         _;
352     }
353     modifier isHuman {
354         address _addr = msg.sender;
355         uint256 _codeLength;
356         assembly {_codeLength := extcodesize(_addr)}
357         require(_codeLength == 0, "Humans only");
358         _;
359     }
360 
361     address public commAddr_ = address(0x9e27E6b1219dDd2419C278C5B3D74169F6900F4d);
362     address public devAddr_ = address(0xe6CE2a354a0BF26B5b383015B7E61701F6adb39C);
363     address public affiAddr_ = address(0x08F521636a2B117B554d04dc9E54fa4061161859);
364 
365     //合作伙伴
366     address public partnerAddr_ = address(0xD4c195777FB7856391390307BAbefA044DaD8DC1);
367 
368     bool public activated_ = false;
369     modifier isActivated() {
370         require(activated_ == true, "its not active yet."); 
371         _;
372     }
373     function activate() isAdmin() public {
374         require(address(commAddr_) != address(0x0), "Must setup commAddr_.");
375         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
376         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
377         require(address(affiAddr_) != address(0x0), "Must setup affiAddr_.");
378         require(activated_ == false, "Only once");
379         activated_ = true ;
380         rID_ = 1;
381         // ----
382         round_[1].strt = now ;                    
383         round_[1].end = round_[1].strt + rndMax_;   
384     }
385     string constant public name   = "Fomo 3G Official";                  // 合约名称
386     string constant public symbol = "F3G";                               // 合约符号
387 
388     uint256 constant private rndInc_    = 1 minutes;                    // 每购买一个key延迟的时间
389     uint256 constant private rndMax_    = 5 hours;                      // 一轮的最长时间
390 
391     modifier isWithinLimits(uint256 _eth) {
392         require(_eth >= 1000000000, "Too little");
393         require(_eth <= 100000000000000000000000, "Too much");
394         _;    
395     }
396 
397     uint256 public G_NowUserId = 1000; //当前用户编号
398     
399     mapping (address => uint256) public pIDxAddr_;  
400     mapping (uint256 => F3GDatasets.Player) public plyr_; 
401     mapping (uint256 => mapping (uint256 => F3GDatasets.PlayerRounds)) public plyrRnds_;
402     uint256 public rID_;                    // 当前游戏轮编号 
403     uint256 public airDropPot_;             // 空投小奖池
404     uint256 public airDropTracker_ = 0;     // 空投小奖池计数
405     mapping (uint256 => F3GDatasets.Round) public round_;
406     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
407     mapping (uint256 => F3GDatasets.TeamFee) public fees_; 
408     mapping (uint256 => F3GDatasets.PotSplit) public potSplit_;
409     
410     constructor() public {
411 
412 		// Team allocation percentages
413         // (F3G, dev) + (Pot , Referrals, Community)
414             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
415         fees_[0] = F3GDatasets.TeamFee(36,3); //40% to pot, 15% to aff, 3% to com, 2% to 合作伙伴, 1% to air drop pot
416         fees_[1] = F3GDatasets.TeamFee(43,3);  //33% to pot, 15% to aff, 3% to com, 2% to 合作伙伴, 1% to air drop pot
417         fees_[2] = F3GDatasets.TeamFee(66,3); //10% to pot, 15% to aff, 3% to com, 2% to  合作伙伴, 1% to air drop pot
418 
419         // how to split up the final pot based on which team was picked
420         // (F3G, dev)
421         potSplit_[0] = F3GDatasets.PotSplit(21,3);  //48% to winner, 25% to next round, 3% to com
422         potSplit_[1] = F3GDatasets.PotSplit(29,3);   //48% to winner, 17% to next round, 3% to com
423         potSplit_[2] = F3GDatasets.PotSplit(36,3);  //48% to winner, 10% to next round, 3% to com
424 
425         initUsers();
426     }
427 
428     function() isActivated() isHuman() isWithinLimits(msg.value) public payable {
429         F3GDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
430         uint256 _pID = pIDxAddr_[msg.sender];
431         uint256 _team = 2;
432         buyCore(_pID, 0, _team, _eventData_);
433     }
434     function buy(uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
435         F3GDatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
436         uint256 _pID = pIDxAddr_[msg.sender];
437 
438         uint256 _affCode = plyr_[_pID].laff;
439         
440         require(_affCode != 0, "must registration before");
441 
442         _team = verifyTeam(_team);
443         buyCore(_pID, _affCode, _team, _eventData_);
444     }
445     
446     function reLoadXid(uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
447         F3GDatasets.EventReturns memory _eventData_;
448         uint256 _pID = pIDxAddr_[msg.sender];
449 
450         uint256 _affCode = plyr_[_pID].laff;
451 
452         require(_affCode != 0, "must registration before");
453 
454         _team = verifyTeam(_team);
455         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
456     }
457 
458     function withdraw() isActivated() isHuman() public {
459         uint256 _rID = rID_;
460         uint256 _now = now;
461         uint256 _pID = pIDxAddr_[msg.sender];
462         uint256 _eth;
463         
464         if (_now > round_[_rID].end && (round_[_rID].ended == false) && round_[_rID].plyr != 0){
465             F3GDatasets.EventReturns memory _eventData_;
466             round_[_rID].ended = true;
467             _eventData_ = endRound(_eventData_);
468             // get their earnings
469             _eth = withdrawEarnings(_pID);
470             if (_eth > 0)
471                 plyr_[_pID].addr.transfer(_eth);
472 
473             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
474             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
475 
476             emit onWithdrawAndDistribute(
477                 msg.sender, 
478                 plyr_[_pID].name, 
479                 _eth, 
480                 _eventData_.compressedData, 
481                 _eventData_.compressedIDs, 
482                 _eventData_.winnerAddr, 
483                 _eventData_.winnerName, 
484                 _eventData_.amountWon, 
485                 _eventData_.newPot, 
486                 _eventData_.R3Amount, 
487                 _eventData_.genAmount
488             );                
489         }else{
490             _eth = withdrawEarnings(_pID);
491             if (_eth > 0)
492                 plyr_[_pID].addr.transfer(_eth);
493             emit onWithdraw(
494                 _pID, 
495                 msg.sender, 
496                 plyr_[_pID].name, 
497                 _eth, 
498                 _now
499             );
500         }
501     }
502 
503     function register(uint256 _affCode) isHuman() public payable{
504         
505         require(msg.value == 0, "registration fee is 0 ether, please set the exact amount");
506         require(_affCode != 0, "error aff code");
507         require(plyr_[_affCode].addr != address(0x0), "error aff code");
508         
509         G_NowUserId = G_NowUserId.add(1);
510         
511         address _addr = msg.sender;
512         
513         pIDxAddr_[_addr] = G_NowUserId;
514 
515         plyr_[G_NowUserId].addr = _addr;
516         plyr_[G_NowUserId].laff = _affCode;
517         
518         uint256 _affID1 = _affCode;
519         uint256 _affID2 = plyr_[_affID1].laff;
520         uint256 _affID3 = plyr_[_affID2].laff;
521         uint256 _affID4 = plyr_[_affID3].laff;
522         uint256 _affID5 = plyr_[_affID4].laff;
523         
524         plyr_[_affID1].aff1sum = plyr_[_affID1].aff1sum.add(1);
525         plyr_[_affID2].aff2sum = plyr_[_affID2].aff2sum.add(1);
526         plyr_[_affID3].aff3sum = plyr_[_affID3].aff3sum.add(1);
527         plyr_[_affID4].aff4sum = plyr_[_affID4].aff4sum.add(1);
528         plyr_[_affID5].aff5sum = plyr_[_affID5].aff5sum.add(1);
529 
530     }
531     
532     function getBuyPrice() public view  returns(uint256) {  
533         uint256 _rID = rID_;
534         uint256 _now = now;
535 
536         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
537             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
538         else // rounds over.  need price for new round
539             return ( 75000000000000 ); // init
540     }
541     function getTimeLeft() public view returns(uint256) {
542         uint256 _rID = rID_;
543         uint256 _now = now ;
544         if(_rID == 1 && _now < round_[_rID].strt ) return (0);
545 
546         if (_now < round_[_rID].end)
547             if (_now > round_[_rID].strt)
548                 return( (round_[_rID].end).sub(_now) );
549             else
550                 return( (round_[_rID].end).sub(_now) );
551         else
552             return(0);
553     }
554 
555     function getPlayerVaults(uint256 _pID) public view returns(uint256 ,uint256, uint256) {
556         uint256 _rID = rID_;
557         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0){
558             // if player is winner 
559             if (round_[_rID].plyr == _pID){
560                 uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
561                 return
562                 (
563                     (plyr_[_pID].win).add( ((_pot).mul(48)) / 100 ),
564                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
565                     plyr_[_pID].aff
566                 );
567             // if player is not the winner
568             } else {
569                 return(
570                     plyr_[_pID].win,
571                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
572                     plyr_[_pID].aff
573                 );
574             }
575             
576         // if round is still going on, or round has ended and round end has been ran
577         } else {
578             return(
579                 plyr_[_pID].win,
580                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
581                 plyr_[_pID].aff
582             );
583         }
584     }
585 
586     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID) private view returns(uint256) {
587         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
588         return(  ((((round_[_rID].mask).add(((((_pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
589     }
590     function getCurrentRoundInfo() public view
591         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256) {
592         uint256 _rID = rID_;       
593         return
594             (
595                 round_[_rID].ico,             
596                 _rID,             
597                 round_[_rID].keys,             
598                 ((_rID == 1) && (now < round_[_rID].strt) ) ? 0 : round_[_rID].end,
599                 ((_rID == 1) && (now < round_[_rID].strt) ) ? 0 : round_[_rID].strt,
600                 round_[_rID].pot,             
601                 (round_[_rID].team + (round_[_rID].plyr * 10)),
602                 plyr_[round_[_rID].plyr].addr,
603                 plyr_[round_[_rID].plyr].name,
604                 rndTmEth_[_rID][0],
605                 rndTmEth_[_rID][1],
606                 rndTmEth_[_rID][2],
607                 rndTmEth_[_rID][3],
608                 airDropTracker_ + (airDropPot_ * 1000)
609             );     
610     }
611     function getPlayerInfoByAddress(address _addr) public  view  returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256){
612         uint256 _rID = rID_;
613         if (_addr == address(0)) {
614             _addr == msg.sender;
615         }
616         uint256 _pID = pIDxAddr_[_addr];
617 
618         return (
619             _pID,
620             plyr_[_pID].name,
621             plyrRnds_[_pID][_rID].keys,
622             plyr_[_pID].win,
623             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
624             plyr_[_pID].aff,
625             plyrRnds_[_pID][_rID].eth
626         );
627     }
628 
629     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3GDatasets.EventReturns memory _eventData_) private {
630         uint256 _rID = rID_;
631         uint256 _now = now;
632         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
633             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
634         }else{
635             if (_now > round_[_rID].end && round_[_rID].ended == false) {
636                 round_[_rID].ended = true;
637                 _eventData_ = endRound(_eventData_);
638 
639                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
640                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
641                 emit onBuyAndDistribute(
642                     msg.sender, 
643                     plyr_[_pID].name, 
644                     msg.value, 
645                     _eventData_.compressedData, 
646                     _eventData_.compressedIDs, 
647                     _eventData_.winnerAddr, 
648                     _eventData_.winnerName, 
649                     _eventData_.amountWon, 
650                     _eventData_.newPot, 
651                     _eventData_.R3Amount, 
652                     _eventData_.genAmount
653                 );
654             }
655             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
656         }
657     }
658 
659     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3GDatasets.EventReturns memory _eventData_) private {
660         uint256 _rID = rID_;
661         uint256 _now = now;
662         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
663             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
664             core(_rID, _pID, _eth, _affID, _team, _eventData_);
665         }else if (_now > round_[_rID].end && round_[_rID].ended == false) {
666             round_[_rID].ended = true;
667             _eventData_ = endRound(_eventData_);
668 
669             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
670             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
671 
672             emit onReLoadAndDistribute(
673                 msg.sender, 
674                 plyr_[_pID].name, 
675                 _eventData_.compressedData, 
676                 _eventData_.compressedIDs, 
677                 _eventData_.winnerAddr, 
678                 _eventData_.winnerName, 
679                 _eventData_.amountWon, 
680                 _eventData_.newPot, 
681                 _eventData_.R3Amount, 
682                 _eventData_.genAmount
683             );
684         }
685     }
686 
687     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3GDatasets.EventReturns memory _eventData_) private{
688         if (plyrRnds_[_pID][_rID].keys == 0)
689             _eventData_ = managePlayer(_pID, _eventData_);
690         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000){
691             uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
692             uint256 _refund = _eth.sub(_availableLimit);
693             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
694             _eth = _availableLimit;
695         }
696         if (_eth > 1000000000) {
697             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
698 
699             if (_keys >= 1000000000000000000){
700                 updateTimer(_keys, _rID);
701                 if (round_[_rID].plyr != _pID)
702                     round_[_rID].plyr = _pID;  
703                 if (round_[_rID].team != _team)
704                     round_[_rID].team = _team; 
705                 _eventData_.compressedData = _eventData_.compressedData + 100;
706             }
707 
708             if (_eth >= 100000000000000000){
709                 // > 0.1 ether, 才有空投
710                 airDropTracker_++;
711                 if (airdrop() == true){
712                     uint256 _prize;
713                     if (_eth >= 10000000000000000000){
714                         // <= 10 ether
715                         _prize = ((airDropPot_).mul(75)) / 100;
716                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
717                         airDropPot_ = (airDropPot_).sub(_prize);
718 
719                         _eventData_.compressedData += 300000000000000000000000000000000;
720                     }else if(_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
721                         // >= 1 ether and < 10 ether
722                         _prize = ((airDropPot_).mul(50)) / 100;
723                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
724 
725                         airDropPot_ = (airDropPot_).sub(_prize);
726 
727                         _eventData_.compressedData += 200000000000000000000000000000000;
728 
729                     }else if(_eth >= 100000000000000000 && _eth < 1000000000000000000){
730                         // >= 0.1 ether and < 1 ether
731                         _prize = ((airDropPot_).mul(25)) / 100;
732                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
733 
734                         airDropPot_ = (airDropPot_).sub(_prize);
735 
736                         _eventData_.compressedData += 300000000000000000000000000000000;
737                     }
738 
739                     _eventData_.compressedData += 10000000000000000000000000000000;
740 
741                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
742 
743                     airDropTracker_ = 0;
744                 }
745             }
746 
747             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
748 
749             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
750             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
751 
752             round_[_rID].keys = _keys.add(round_[_rID].keys);
753             round_[_rID].eth = _eth.add(round_[_rID].eth);
754             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
755 
756             // distribute eth
757             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
758             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
759 
760             endTx(_pID, _team, _eth, _keys, _eventData_);
761         }
762 
763     }
764 
765     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast) private view returns(uint256) {
766         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
767     }
768 
769     function calcKeysReceived(uint256 _rID, uint256 _eth) public view returns(uint256){
770         uint256 _now = now;
771         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
772             return ( (round_[_rID].eth).keysRec(_eth) );
773         else // rounds over.  need keys for new round
774             return ( (_eth).keys() );
775     }
776 
777     function iWantXKeys(uint256 _keys) public view returns(uint256) {
778         uint256 _rID = rID_;
779         uint256 _now = now;
780 
781         if (_now > round_[_rID].strt && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
782             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
783         else // rounds over.  need price for new round
784             return ( (_keys).eth() );
785     }
786 
787     function determinePID(F3GDatasets.EventReturns memory _eventData_) private returns (F3GDatasets.EventReturns) {
788         uint256 _pID = pIDxAddr_[msg.sender];
789 
790         return _eventData_ ;
791     }
792     function verifyTeam(uint256 _team) private pure returns (uint256) {
793         if (_team < 0 || _team > 2) 
794             return(2);
795         else
796             return(_team);
797     }
798 
799     function managePlayer(uint256 _pID, F3GDatasets.EventReturns memory _eventData_) private returns (F3GDatasets.EventReturns) {
800         if (plyr_[_pID].lrnd != 0)
801             updateGenVault(_pID, plyr_[_pID].lrnd);
802         
803         plyr_[_pID].lrnd = rID_;
804 
805         _eventData_.compressedData = _eventData_.compressedData + 10;
806 
807         return _eventData_ ;
808     }
809     function endRound(F3GDatasets.EventReturns memory _eventData_) private returns (F3GDatasets.EventReturns) {
810         uint256 _rID = rID_;
811         uint256 _winPID = round_[_rID].plyr;
812         uint256 _winTID = round_[_rID].team;
813         // grab our pot amount
814         uint256 _pot = round_[_rID].pot.add(round_[_rID].prevres);
815 
816         uint256 _win = (_pot.mul(48)) / 100;
817         uint256 _com = (_pot.mul(3)) / 100;
818         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
819         uint256 _dev = (_pot.mul(potSplit_[_winTID].dev)) / 100;
820         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_dev);
821         // calculate ppt for round mask
822         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
823         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
824         if (_dust > 0){
825             _gen = _gen.sub(_dust);
826             _res = _res.add(_dust);
827         }
828 
829         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
830         if(_com>0) {
831             commAddr_.transfer(_com);
832             _com = 0 ;
833         }
834 
835         if(_dev > 0) {
836             devAddr_.transfer(_dev);
837         }
838 
839         round_[_rID].mask = _ppt.add(round_[_rID].mask);
840 
841         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
842         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
843         _eventData_.winnerAddr = plyr_[_winPID].addr;
844         _eventData_.winnerName = plyr_[_winPID].name;
845         _eventData_.amountWon = _win;
846         _eventData_.genAmount = _gen;
847         _eventData_.R3Amount = 0;
848         _eventData_.newPot = _res;
849         // 下一轮
850         rID_++;
851         _rID++;
852         round_[_rID].strt = now;
853         round_[_rID].end = now.add(rndMax_);
854         round_[_rID].prevres = _res;
855 
856         return(_eventData_);
857     }
858 
859     function updateGenVault(uint256 _pID, uint256 _rIDlast) private {
860         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
861         if (_earnings > 0){
862             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
863 
864             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
865 
866         }
867     }
868 
869     function updateTimer(uint256 _keys, uint256 _rID) private {
870         uint256 _now = now;
871 
872         uint256 _newTime;
873 
874         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
875             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
876         else
877             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
878 
879         if (_newTime < (rndMax_).add(_now))
880             round_[_rID].end = _newTime;
881         else
882             round_[_rID].end = rndMax_.add(_now);
883     }
884 
885     function airdrop() private  view  returns(bool) {
886         uint256 seed = uint256(keccak256(abi.encodePacked(
887             (block.timestamp).add
888             (block.difficulty).add
889             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
890             (block.gaslimit).add
891             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
892             (block.number)
893             
894         )));
895         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
896             return(true);
897         else
898             return(false);
899     }
900     
901     function distributeRef(uint256 _eth, uint256 _affID) private{
902         
903         uint256 _allaff = (_eth.mul(15)).div(100);
904         
905         //五级返佣
906         uint256 _affID1 = _affID;
907         uint256 _affID2 = plyr_[_affID1].laff;
908         uint256 _affID3 = plyr_[_affID2].laff;
909         uint256 _affID4 = plyr_[_affID3].laff;
910         uint256 _affID5 = plyr_[_affID4].laff;
911         uint256 _aff = 0;
912 
913         if (_affID1 != 0) {   
914             _aff = (_eth.mul(5)).div(100);
915             _allaff = _allaff.sub(_aff);
916             plyr_[_affID1].aff = _aff.add(plyr_[_affID1].aff);
917         }
918 
919         if (_affID2 != 0) {   
920             _aff = (_eth.mul(2)).div(100);
921             _allaff = _allaff.sub(_aff);
922             plyr_[_affID2].aff = _aff.add(plyr_[_affID2].aff);
923         }
924 
925         if (_affID3 != 0) {   
926             _aff = (_eth.mul(1)).div(100);
927             _allaff = _allaff.sub(_aff);
928             plyr_[_affID3].aff = _aff.add(plyr_[_affID3].aff);
929         }
930 
931         if (_affID4 != 0) {   
932             _aff = (_eth.mul(2)).div(100);
933             _allaff = _allaff.sub(_aff);
934             plyr_[_affID4].aff = _aff.add(plyr_[_affID4].aff);
935         }
936 
937         if (_affID5 != 0) {   
938             _aff = (_eth.mul(5)).div(100);
939             _allaff = _allaff.sub(_aff);
940             plyr_[_affID5].aff = _aff.add(plyr_[_affID5].aff);
941         }
942         
943         if(_allaff > 0 ){
944             affiAddr_.transfer(_allaff);
945         }          
946     }
947     
948     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3GDatasets.EventReturns memory _eventData_) 
949         private returns(F3GDatasets.EventReturns){
950 
951         uint256 _comm = (_eth.mul(3)).div(100);
952         if (_comm > 0) {
953             commAddr_.transfer(_comm);
954         }
955         
956         distributeRef(_eth, _affID);
957 
958         // partner
959         uint256 _partner = (_eth.mul(2)).div(100);
960         partnerAddr_.transfer(_partner);
961 
962         uint256 _dev = (_eth.mul(fees_[_team].dev)).div(100);
963         if(_dev>0){
964             devAddr_.transfer(_dev);
965         }
966         return (_eventData_) ; 
967 
968     }
969 
970     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3GDatasets.EventReturns memory _eventData_)
971         private returns(F3GDatasets.EventReturns) {
972         // 持有者的份额 
973         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;    
974         // 空投小奖池 1%
975         uint256 _air = (_eth / 100);
976         airDropPot_ = airDropPot_.add(_air);
977         // 21% = aff airpot etc.
978         _eth = _eth.sub(((_eth.mul(21)) / 100).add((_eth.mul(fees_[_team].dev)) / 100));
979         // 奖池
980         uint256 _pot = _eth.sub(_gen);
981 
982         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
983         if (_dust > 0)
984             _gen = _gen.sub(_dust);
985         
986         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
987 
988         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
989         _eventData_.potAmount = _pot;
990 
991         return(_eventData_);
992     }
993     
994     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys) private returns(uint256) {
995         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
996         round_[_rID].mask = _ppt.add(round_[_rID].mask);
997         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
998         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
999         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1000     }
1001     function withdrawEarnings(uint256 _pID) private returns(uint256) {
1002         updateGenVault(_pID, plyr_[_pID].lrnd);
1003         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1004         if (_earnings > 0){
1005             plyr_[_pID].win = 0;
1006             plyr_[_pID].gen = 0;
1007             plyr_[_pID].aff = 0;
1008         }
1009         return(_earnings);
1010     }
1011     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3GDatasets.EventReturns memory _eventData_) private {
1012         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1013         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1014 
1015         emit onEndTx(
1016             _eventData_.compressedData,
1017             _eventData_.compressedIDs,
1018             plyr_[_pID].name,
1019             msg.sender,
1020             _eth,
1021             _keys,
1022             _eventData_.winnerAddr,
1023             _eventData_.winnerName,
1024             _eventData_.amountWon,
1025             _eventData_.newPot,
1026             _eventData_.R3Amount,
1027             _eventData_.genAmount,
1028             _eventData_.potAmount,
1029             airDropPot_
1030         );
1031     }
1032 }