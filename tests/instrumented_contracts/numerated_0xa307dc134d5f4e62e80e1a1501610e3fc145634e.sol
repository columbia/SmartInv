1 pragma solidity ^0.4.24;
2 contract CAE4Devents {
3     // fired whenever a player registers a name
4     event onNewName
5     (
6         uint256 indexed playerID,
7         address indexed playerAddress,
8         bytes32 indexed playerName,
9         bool isNewPlayer,
10         uint256 affiliateID,
11         address affiliateAddress,
12         bytes32 affiliateName,
13         uint256 amountPaid,
14         uint256 timeStamp
15     );
16     
17     // fired at end of buy or reload
18     event onEndTx
19     (
20         uint256 compressedData,     
21         uint256 compressedIDs,      
22         bytes32 playerName,
23         address playerAddress,
24         uint256 ethIn,
25         uint256 keysBought,
26         address winnerAddr,
27         bytes32 winnerName,
28         uint256 amountWon,
29         uint256 newPot,
30         uint256 P3DAmount,
31         uint256 genAmount,
32         uint256 potAmount,
33         uint256 airDropPot
34     );
35     
36 	// fired whenever theres a withdraw
37     event onWithdraw
38     (
39         uint256 indexed playerID,
40         address playerAddress,
41         bytes32 playerName,
42         uint256 ethOut,
43         uint256 timeStamp
44     );
45     
46     // fired whenever a withdraw forces end round to be ran
47     event onWithdrawAndDistribute
48     (
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 compressedData,
53         uint256 compressedIDs,
54         address winnerAddr,
55         bytes32 winnerName,
56         uint256 amountWon,
57         uint256 newPot,
58         uint256 P3DAmount,
59         uint256 genAmount
60     );
61     
62     // (fomo3d long only) fired whenever a player tries a buy after round timer 
63     // hit zero, and causes end round to be ran.
64     event onBuyAndDistribute
65     (
66         address playerAddress,
67         bytes32 playerName,
68         uint256 ethIn,
69         uint256 compressedData,
70         uint256 compressedIDs,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 P3DAmount,
76         uint256 genAmount
77     );
78     
79     // (fomo3d long only) fired whenever a player tries a reload after round timer 
80     // hit zero, and causes end round to be ran.
81     event onReLoadAndDistribute
82     (
83         address playerAddress,
84         bytes32 playerName,
85         uint256 compressedData,
86         uint256 compressedIDs,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 P3DAmount,
92         uint256 genAmount
93     );
94     
95     // fired whenever an affiliate is paid
96     event onAffiliatePayout
97     (
98         uint256 indexed affiliateID,
99         address affiliateAddress,
100         bytes32 affiliateName,
101         uint256 indexed roundID,
102         uint256 indexed buyerID,
103         uint256 amount,
104         uint256 timeStamp
105     );
106     
107     // received pot swap deposit
108     event onPotSwapDeposit
109     (
110         uint256 roundID,
111         uint256 amountAddedToPot
112     );
113     
114     // fired whenever an janwin is paid
115     event onNewJanWin
116     (
117         uint256 indexed roundID,
118         uint256 indexed buyerID,
119         uint256 amount,
120         uint256 timeStamp
121     );
122 }
123 
124 contract modularLong is CAE4Devents {}
125 
126 library CAE4Ddatasets {
127     //compressedData key
128     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
129         // 0 - new player (bool)
130         // 1 - joined round (bool)
131         // 2 - new  leader (bool)
132         // 3-5 - air drop tracker (uint 0-999)
133         // 6-16 - round end time
134         // 17 - winnerTeam
135         // 18 - 28 timestamp 
136         // 29 - team
137         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
138         // 31 - airdrop happened bool
139         // 32 - airdrop tier 
140         // 33 - airdrop amount won
141     //compressedIDs key
142     // [77-52][51-26][25-0]
143         // 0-25 - pID 
144         // 26-51 - winPID
145         // 52-77 - rID
146     struct EventReturns {
147         uint256 compressedData;
148         uint256 compressedIDs;
149         address winnerAddr;         // winner address
150         bytes32 winnerName;         // winner name
151         uint256 amountWon;          // amount won
152         uint256 newPot;             // amount in new pot
153         uint256 P3DAmount;          // amount distributed to p3d
154         uint256 genAmount;          // amount distributed to gen
155         uint256 potAmount;          // amount added to pot
156     }
157     struct Player {
158         address addr;   // player address
159         bytes32 name;   // player name
160         uint256 win;    // winnings vault
161         uint256 gen;    // general vault
162         uint256 aff;    // affiliate vault
163         uint256 lrnd;   // last round played
164         uint256 laff;   // last affiliate id used
165     }
166     struct PlayerRounds {
167         uint256 eth;    // eth player has added to round (used for eth limiter)
168         uint256 keys;   // keys
169         uint256 mask;   // player mask 
170         uint256 ico;    // ICO phase investment
171     }
172     struct Round {
173         uint256 plyr;   // pID of player in lead
174         uint256 team;   // tID of team in lead
175         uint256 end;    // time ends/ended
176         bool ended;     // has round end function been ran
177         uint256 strt;   // time round started
178         uint256 keys;   // keys
179         uint256 eth;    // total eth in
180         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
181         uint256 mask;   // global mask
182         uint256 ico;    // total eth sent in during ICO phase
183         uint256 icoGen; // total eth for gen during ICO phase
184         uint256 icoAvg; // average key price for ICO phase
185         uint256 initPot; // the init pot from last round
186     }
187     
188     struct TeamFee {
189         uint256 gen;    // % of buy in thats paid to key holders of current round
190         uint256 pot;    // % of buy in thats paid to p3d holders
191         uint256 aff;
192         uint256 com;
193     }
194     
195 
196     struct PotSplit {
197         uint256 gen;    // % of pot thats paid to key holders of current round
198         uint256 win;    // % of pot thats paid to p3d holders
199         uint256 next;
200         uint256 com;
201     }
202     
203 }
204 
205 
206 
207 interface JIincForwarderInterface {
208     function deposit() external payable returns(bool);
209     function status() external view returns(address, address, bool);
210     function startMigration(address _newCorpBank) external returns(bool);
211     function cancelMigration() external returns(bool);
212     function finishMigration() external returns(bool);
213     function setup(address _firstCorpBank) external;
214 }
215 
216 interface PlayerBookInterface {
217     function getPlayerID(address _addr) external returns (uint256);
218     function getPlayerName(uint256 _pID) external view returns (bytes32);
219     function getPlayerLAff(uint256 _pID) external view returns (uint256);
220     function getPlayerAddr(uint256 _pID) external view returns (address);
221     function getNameFee() external view returns (uint256);
222     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
223     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
224     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
225 }
226 
227 contract CAE4Dlong is modularLong {
228     using SafeMath for *;
229     using NameFilter for string;
230     using CAE4DKeysCalcLong for uint256;
231 	
232     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xBE207a22b2dcabB7AAd232d8F631cBEda56E379d);
233     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xBCE0e39E0b9CbD62fde3B490523231eA2827Df1d);
234     
235     
236     //JIincForwarderInterface private Jekyll_Island_Inc ;
237     //PlayerBookInterface private PlayerBook ;
238     //address public playerbookaddr ;
239     //address public jekylladdr ;
240     
241 //==============================================================================
242 //     _ _  _  |`. _     _ _ |_ | _  _  .
243 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
244 //=================_|===========================================================
245     string constant public name = "CAE4D";
246     string constant public symbol = "CAE4D";
247     uint256 private rndExtra_ = 30;//extSettings.getLongExtra();     // length of the very first ICO 
248     uint256 private rndGap_ = 30;//extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
249     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
250     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
251     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
252 //==============================================================================
253 //     _| _ _|_ _    _ _ _|_    _   .
254 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
255 //=============================|================================================
256 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
257     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
258     uint256 public rID_;    // round id number / total rounds that have happened
259 //****************
260 // PLAYER DATA 
261 //****************
262     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
263     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
264     mapping (uint256 => CAE4Ddatasets.Player) public plyr_;   // (pID => data) player data
265     mapping (uint256 => mapping (uint256 => CAE4Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
266     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
267 //****************
268 // ROUND DATA 
269 //****************
270     mapping (uint256 => CAE4Ddatasets.Round) public round_;   // (rID => data) round data
271     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
272 //****************
273 // TEAM FEE DATA 
274 //****************
275     mapping (uint256 => CAE4Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
276     mapping (uint256 => CAE4Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
277 //==============================================================================
278 //     _ _  _  __|_ _    __|_ _  _  .
279 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
280 //==============================================================================
281     //constructor(address addr1,address addr2)
282     constructor()
283         public
284     {
285     
286         //playerbookaddr = addr2;
287     	//jekylladdr = addr1;
288     
289     	//DiviesInterface constant private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
290     	//Jekyll_Island_Inc = JIincForwarderInterface(jekylladdr);
291     	//PlayerBook = PlayerBookInterface(playerbookaddr);
292     	
293 		// Team allocation structures
294         // 0 = elephants
295         // 1 = nuts
296         // 2 = rock
297         // 3 = rivulets
298 
299 		// Team allocation percentages
300         // (Gen,Pot,Referrals,Community)
301         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
302         fees_[0] = CAE4Ddatasets.TeamFee(20,60,15,5);   //60% to pot, 15% to aff, 5% to com
303         fees_[1] = CAE4Ddatasets.TeamFee(41,24,30,5);   //24% to pot, 30% to aff, 5% to com
304         fees_[2] = CAE4Ddatasets.TeamFee(55,30,10,5);   //30% to pot, 10% to aff, 5% to com
305         fees_[3] = CAE4Ddatasets.TeamFee(50,20,25,5);   //20% to pot, 25% to aff, 5% to com
306         
307         // how to split up the final pot based on which team was picked
308         // (gen,win,next,com)
309         potSplit_[0] = CAE4Ddatasets.PotSplit(10,75,13,2);  //75% to winner, 13% to next round, 2% to com
310         potSplit_[1] = CAE4Ddatasets.PotSplit(20,65,13,2);   //65% to winner, 13% to next round, 2% to com
311         potSplit_[2] = CAE4Ddatasets.PotSplit(25,65,8,2);  //65% to winner, 8% to next round, 2% to com
312         potSplit_[3] = CAE4Ddatasets.PotSplit(40,45,13,2);  //45% to winner, 13% to next round, 2% to com
313     }
314 //==============================================================================
315 //     _ _  _  _|. |`. _  _ _  .
316 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
317 //==============================================================================
318     /**
319      * @dev used to make sure no one can interact with contract until it has 
320      * been activated. 
321      */
322     modifier isActivated() {
323         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
324         _;
325     }
326     
327     /**
328      * @dev prevents contracts from interacting with fomo3d 
329      */
330     modifier isHuman() {
331         address _addr = msg.sender;
332         uint256 _codeLength;
333         
334         assembly {_codeLength := extcodesize(_addr)}
335         require(_codeLength == 0, "sorry humans only");
336         _;
337     }
338 
339     /**
340      * @dev sets boundaries for incoming tx 
341      */
342     modifier isWithinLimits(uint256 _eth) {
343         require(_eth >= 1000000000, "pocket lint: not a valid currency");
344         require(_eth <= 100000000000000000000000, "no vitalik, no");
345         _;    
346     }
347     
348 //==============================================================================
349 //     _    |_ |. _   |`    _  __|_. _  _  _  .
350 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
351 //====|=========================================================================
352     /**
353      * @dev emergency buy uses last stored affiliate ID and team snek
354      */
355     function()
356         isActivated()
357         isHuman()
358         isWithinLimits(msg.value)
359         public
360         payable
361     {
362         // set up our tx event data and determine if player is new or not
363         CAE4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
364             
365         // fetch player id
366         uint256 _pID = pIDxAddr_[msg.sender];
367         
368         // buy core 
369         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
370     }
371     
372     /**
373      * @dev converts all incoming ethereum to keys.
374      * @param _affCode the ID/address/name of the player who gets the affiliate fee
375      * @param _team what team is the player playing for?
376      */
377     function buyXid(uint256 _affCode, uint256 _team)
378         isActivated()
379         isHuman()
380         isWithinLimits(msg.value)
381         public
382         payable
383     {
384         // set up our tx event data and determine if player is new or not
385         CAE4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
386         
387         // fetch player id
388         uint256 _pID = pIDxAddr_[msg.sender];
389         
390         // manage affiliate residuals
391         // if no affiliate code was given or player tried to use their own, lolz
392         if (_affCode == 0 || _affCode == _pID)
393         {
394             // use last stored affiliate code 
395             _affCode = plyr_[_pID].laff;
396             
397         // if affiliate code was given & its not the same as previously stored 
398         } else if (_affCode != plyr_[_pID].laff) {
399             // update last affiliate 
400             plyr_[_pID].laff = _affCode;
401         }
402         
403         // verify a valid team was selected
404         _team = verifyTeam(_team);
405         
406         // buy core 
407         buyCore(_pID, _affCode, _team, _eventData_);
408     }
409     
410     function buyXaddr(address _affCode, uint256 _team)
411         isActivated()
412         isHuman()
413         isWithinLimits(msg.value)
414         public
415         payable
416     {
417         // set up our tx event data and determine if player is new or not
418         CAE4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
419         
420         // fetch player id
421         uint256 _pID = pIDxAddr_[msg.sender];
422         
423         // manage affiliate residuals
424         uint256 _affID;
425         // if no affiliate code was given or player tried to use their own, lolz
426         if (_affCode == address(0) || _affCode == msg.sender)
427         {
428             // use last stored affiliate code
429             _affID = plyr_[_pID].laff;
430         
431         // if affiliate code was given    
432         } else {
433             // get affiliate ID from aff Code 
434             _affID = pIDxAddr_[_affCode];
435             
436             // if affID is not the same as previously stored 
437             if (_affID != plyr_[_pID].laff)
438             {
439                 // update last affiliate
440                 plyr_[_pID].laff = _affID;
441             }
442         }
443         
444         // verify a valid team was selected
445         _team = verifyTeam(_team);
446         
447         // buy core 
448         buyCore(_pID, _affID, _team, _eventData_);
449     }
450     
451     function buyXname(bytes32 _affCode, uint256 _team)
452         isActivated()
453         isHuman()
454         isWithinLimits(msg.value)
455         public
456         payable
457     {
458         // set up our tx event data and determine if player is new or not
459         CAE4Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
460         
461         // fetch player id
462         uint256 _pID = pIDxAddr_[msg.sender];
463         
464         // manage affiliate residuals
465         uint256 _affID;
466         // if no affiliate code was given or player tried to use their own, lolz
467         if (_affCode == '' || _affCode == plyr_[_pID].name)
468         {
469             // use last stored affiliate code
470             _affID = plyr_[_pID].laff;
471         
472         // if affiliate code was given
473         } else {
474             // get affiliate ID from aff Code
475             _affID = pIDxName_[_affCode];
476             
477             // if affID is not the same as previously stored
478             if (_affID != plyr_[_pID].laff)
479             {
480                 // update last affiliate
481                 plyr_[_pID].laff = _affID;
482             }
483         }
484         
485         // verify a valid team was selected
486         _team = verifyTeam(_team);
487         
488         // buy core 
489         buyCore(_pID, _affID, _team, _eventData_);
490     }
491     
492     /**
493      * @dev essentially the same as buy, but instead of you sending ether 
494      * from your wallet, it uses your unwithdrawn earnings.
495      * @param _affCode the ID/address/name of the player who gets the affiliate fee
496      * @param _team what team is the player playing for?
497      * @param _eth amount of earnings to use (remainder returned to gen vault)
498      */
499     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
500         isActivated()
501         isHuman()
502         isWithinLimits(_eth)
503         public
504     {
505         // set up our tx event data
506         CAE4Ddatasets.EventReturns memory _eventData_;
507         
508         // fetch player ID
509         uint256 _pID = pIDxAddr_[msg.sender];
510         
511         // manage affiliate residuals
512         // if no affiliate code was given or player tried to use their own, lolz
513         if (_affCode == 0 || _affCode == _pID)
514         {
515             // use last stored affiliate code 
516             _affCode = plyr_[_pID].laff;
517             
518         // if affiliate code was given & its not the same as previously stored 
519         } else if (_affCode != plyr_[_pID].laff) {
520             // update last affiliate 
521             plyr_[_pID].laff = _affCode;
522         }
523 
524         // verify a valid team was selected
525         _team = verifyTeam(_team);
526 
527         // reload core
528         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
529     }
530     
531     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
532         isActivated()
533         isHuman()
534         isWithinLimits(_eth)
535         public
536     {
537         // set up our tx event data
538         CAE4Ddatasets.EventReturns memory _eventData_;
539         
540         // fetch player ID
541         uint256 _pID = pIDxAddr_[msg.sender];
542         
543         // manage affiliate residuals
544         uint256 _affID;
545         // if no affiliate code was given or player tried to use their own, lolz
546         if (_affCode == address(0) || _affCode == msg.sender)
547         {
548             // use last stored affiliate code
549             _affID = plyr_[_pID].laff;
550         
551         // if affiliate code was given    
552         } else {
553             // get affiliate ID from aff Code 
554             _affID = pIDxAddr_[_affCode];
555             
556             // if affID is not the same as previously stored 
557             if (_affID != plyr_[_pID].laff)
558             {
559                 // update last affiliate
560                 plyr_[_pID].laff = _affID;
561             }
562         }
563         
564         // verify a valid team was selected
565         _team = verifyTeam(_team);
566         
567         // reload core
568         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
569     }
570     
571     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
572         isActivated()
573         isHuman()
574         isWithinLimits(_eth)
575         public
576     {
577         // set up our tx event data
578         CAE4Ddatasets.EventReturns memory _eventData_;
579         
580         // fetch player ID
581         uint256 _pID = pIDxAddr_[msg.sender];
582         
583         // manage affiliate residuals
584         uint256 _affID;
585         // if no affiliate code was given or player tried to use their own, lolz
586         if (_affCode == '' || _affCode == plyr_[_pID].name)
587         {
588             // use last stored affiliate code
589             _affID = plyr_[_pID].laff;
590         
591         // if affiliate code was given
592         } else {
593             // get affiliate ID from aff Code
594             _affID = pIDxName_[_affCode];
595             
596             // if affID is not the same as previously stored
597             if (_affID != plyr_[_pID].laff)
598             {
599                 // update last affiliate
600                 plyr_[_pID].laff = _affID;
601             }
602         }
603         
604         // verify a valid team was selected
605         _team = verifyTeam(_team);
606         
607         // reload core
608         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
609     }
610 
611     /**
612      * @dev withdraws all of your earnings.
613      * -functionhash- 0x3ccfd60b
614      */
615     function withdraw()
616         isActivated()
617         isHuman()
618         public
619     {
620         // setup local rID 
621         uint256 _rID = rID_;
622         
623         // grab time
624         uint256 _now = now;
625         
626         // fetch player ID
627         uint256 _pID = pIDxAddr_[msg.sender];
628         
629         // setup temp var for player eth
630         uint256 _eth;
631         
632         // check to see if round has ended and no one has run round end yet
633         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
634         {
635             // set up our tx event data
636             CAE4Ddatasets.EventReturns memory _eventData_;
637             
638             // end the round (distributes pot)
639 			round_[_rID].ended = true;
640             _eventData_ = endRound(_eventData_);
641             
642 			// get their earnings
643             _eth = withdrawEarnings(_pID);
644             
645             // gib moni
646             if (_eth > 0)
647                 plyr_[_pID].addr.transfer(_eth);    
648             
649             // build event data
650             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
651             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
652             
653             // fire withdraw and distribute event
654             emit CAE4Devents.onWithdrawAndDistribute
655             (
656                 msg.sender, 
657                 plyr_[_pID].name, 
658                 _eth, 
659                 _eventData_.compressedData, 
660                 _eventData_.compressedIDs, 
661                 _eventData_.winnerAddr, 
662                 _eventData_.winnerName, 
663                 _eventData_.amountWon, 
664                 _eventData_.newPot, 
665                 _eventData_.P3DAmount, 
666                 _eventData_.genAmount
667             );
668             
669         // in any other situation
670         } else {
671             // get their earnings
672             _eth = withdrawEarnings(_pID);
673             
674             // gib moni
675             if (_eth > 0)
676                 plyr_[_pID].addr.transfer(_eth);
677             
678             // fire withdraw event
679             emit CAE4Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
680         }
681     }
682     
683     /**
684      * @dev use these to register names.  they are just wrappers that will send the
685      * registration requests to the PlayerBook contract.  So registering here is the 
686      * same as registering there.  UI will always display the last name you registered.
687      * but you will still own all previously registered names to use as affiliate 
688      * links.
689      * - must pay a registration fee.
690      * - name must be unique
691      * - names will be converted to lowercase
692      * - name cannot start or end with a space 
693      * - cannot have more than 1 space in a row
694      * - cannot be only numbers
695      * - cannot start with 0x 
696      * - name must be at least 1 char
697      * - max length of 32 characters long
698      * - allowed characters: a-z, 0-9, and space
699      * @param _nameString players desired name
700      * @param _affCode affiliate ID, address, or name of who referred you
701      * @param _all set to true if you want this to push your info to all games 
702      * (this might cost a lot of gas)
703      */
704     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
705         isHuman()
706         public
707         payable
708     {
709         bytes32 _name = _nameString.nameFilter();
710         address _addr = msg.sender;
711         uint256 _paid = msg.value;
712         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
713         
714         uint256 _pID = pIDxAddr_[_addr];
715         
716         // fire event
717         emit CAE4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
718     }
719     
720     function registerNameXaddr(string _nameString, address _affCode, bool _all)
721         isHuman()
722         public
723         payable
724     {
725         bytes32 _name = _nameString.nameFilter();
726         address _addr = msg.sender;
727         uint256 _paid = msg.value;
728         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
729         
730         uint256 _pID = pIDxAddr_[_addr];
731         
732         // fire event
733         emit CAE4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
734     }
735     
736     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
737         isHuman()
738         public
739         payable
740     {
741         bytes32 _name = _nameString.nameFilter();
742         address _addr = msg.sender;
743         uint256 _paid = msg.value;
744         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
745         
746         uint256 _pID = pIDxAddr_[_addr];
747         
748         // fire event
749         emit CAE4Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
750     }
751 //==============================================================================
752 //     _  _ _|__|_ _  _ _  .
753 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
754 //=====_|=======================================================================
755     /**
756      * @dev return the price buyer will pay for next 1 individual key.
757      * -functionhash- 0x018a25e8
758      * @return price for next key bought (in wei format)
759      */
760     function getBuyPrice()
761         public 
762         view 
763         returns(uint256)
764     {  
765         // setup local rID
766         uint256 _rID = rID_;
767         
768         // grab time
769         uint256 _now = now;
770         
771         // are we in a round?
772         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
773             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
774         else // rounds over.  need price for new round
775             return ( 75000000000000 ); // init
776     }
777     
778     /**
779      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
780      * provider
781      * -functionhash- 0xc7e284b8
782      * @return time left in seconds
783      */
784     function getTimeLeft()
785         public
786         view
787         returns(uint256)
788     {
789         // setup local rID
790         uint256 _rID = rID_;
791         
792         // grab time
793         uint256 _now = now;
794         
795         if (_now < round_[_rID].end)
796             if (_now > round_[_rID].strt + rndGap_)
797                 return( (round_[_rID].end).sub(_now) );
798             else
799                 return( (round_[_rID].strt + rndGap_).sub(_now) );
800         else
801             return(0);
802     }
803     
804     /**
805      * @dev returns player earnings per vaults 
806      * -functionhash- 0x63066434
807      * @return winnings vault
808      * @return general vault
809      * @return affiliate vault
810      */
811     function getPlayerVaults(uint256 _pID)
812         public
813         view
814         returns(uint256 ,uint256, uint256)
815     {
816         // setup local rID
817         uint256 _rID = rID_;
818         
819         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
820         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
821         {
822             // if player is winner 
823             if (round_[_rID].plyr == _pID)
824             {
825                 return
826                 (
827                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
828                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
829                     plyr_[_pID].aff
830                 );
831             // if player is not the winner
832             } else {
833                 return
834                 (
835                     plyr_[_pID].win,
836                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
837                     plyr_[_pID].aff
838                 );
839             }
840             
841         // if round is still going on, or round has ended and round end has been ran
842         } else {
843             return
844             (
845                 plyr_[_pID].win,
846                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
847                 plyr_[_pID].aff
848             );
849         }
850     }
851     
852     /**
853      * solidity hates stack limits.  this lets us avoid that hate 
854      */
855     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
856         private
857         view
858         returns(uint256)
859     {
860         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
861     }
862     
863     /**
864      * @dev returns all current round info needed for front end
865      * -functionhash- 0x747dff42
866      * @return eth invested during ICO phase
867      * @return round id 
868      * @return total keys for round 
869      * @return time round ends
870      * @return time round started
871      * @return current pot 
872      * @return current team ID & player ID in lead 
873      * @return current player in leads address 
874      * @return current player in leads name
875      * @return elephants eth in for round
876      * @return nuts eth in for round
877      * @return rock eth in for round
878      * @return rivulets eth in for round
879      * @return airdrop tracker # & airdrop pot
880      */
881     function getCurrentRoundInfo()
882         public
883         view
884         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
885     {
886         // setup local rID
887         uint256 _rID = rID_;
888         
889         return
890         (
891             round_[_rID].eth,               //0
892             _rID,                           //1
893             round_[_rID].keys,              //2
894             round_[_rID].end,               //3
895             round_[_rID].strt,              //4
896             round_[_rID].pot,               //5
897             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
898             plyr_[round_[_rID].plyr].addr,  //7
899             plyr_[round_[_rID].plyr].name,  //8
900             rndTmEth_[_rID][0],             //9
901             rndTmEth_[_rID][1],             //10
902             rndTmEth_[_rID][2],             //11
903             rndTmEth_[_rID][3],             //12
904             airDropTracker_ + (airDropPot_ * 1000)              //13
905         );
906     }
907     
908     function getCurrentRoundRewards()
909     public
910     view
911     returns(uint256){
912     	uint256 _rID = rID_;
913     	return (round_[_rID].eth.add(round_[_rID].initPot).sub(round_[_rID].pot));
914     }
915 
916     /**
917      * @dev returns player info based on address.  if no address is given, it will 
918      * use msg.sender 
919      * -functionhash- 0xee0b5d8b
920      * @param _addr address of the player you want to lookup 
921      * @return player ID 
922      * @return player name
923      * @return keys owned (current round)
924      * @return winnings vault
925      * @return general vault 
926      * @return affiliate vault 
927 	 * @return player round eth
928      */
929     function getPlayerInfoByAddress(address _addr)
930         public 
931         view 
932         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
933     {
934         // setup local rID
935         uint256 _rID = rID_;
936         
937         if (_addr == address(0))
938         {
939             _addr == msg.sender;
940         }
941         uint256 _pID = pIDxAddr_[_addr];
942         
943         return
944         (
945             _pID,                               //0
946             plyr_[_pID].name,                   //1
947             plyrRnds_[_pID][_rID].keys,         //2
948             plyr_[_pID].win,                    //3
949             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
950             plyr_[_pID].aff,                    //5
951             plyrRnds_[_pID][_rID].eth           //6
952         );
953     }
954 
955 //==============================================================================
956 //     _ _  _ _   | _  _ . _  .
957 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
958 //=====================_|=======================================================
959     /**
960      * @dev logic runs whenever a buy order is executed.  determines how to handle 
961      * incoming eth depending on if we are in an active round or not
962      */
963     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, CAE4Ddatasets.EventReturns memory _eventData_)
964         private
965     {
966         // setup local rID
967         uint256 _rID = rID_;
968         
969         // grab time
970         uint256 _now = now;
971         
972         // if round is active
973         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
974         {
975             // call core 
976             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
977         
978         // if round is not active     
979         } else {
980             // check to see if end round needs to be ran
981             if (_now > round_[_rID].end && round_[_rID].ended == false) 
982             {
983                 // end the round (distributes pot) & start new round
984 			    round_[_rID].ended = true;
985                 _eventData_ = endRound(_eventData_);
986                 
987                 // build event data
988                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
989                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
990                 
991                 // fire buy and distribute event 
992                 emit CAE4Devents.onBuyAndDistribute
993                 (
994                     msg.sender, 
995                     plyr_[_pID].name, 
996                     msg.value, 
997                     _eventData_.compressedData, 
998                     _eventData_.compressedIDs, 
999                     _eventData_.winnerAddr, 
1000                     _eventData_.winnerName, 
1001                     _eventData_.amountWon, 
1002                     _eventData_.newPot, 
1003                     _eventData_.P3DAmount, 
1004                     _eventData_.genAmount
1005                 );
1006             }
1007             
1008             // put eth in players vault 
1009             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1010         }
1011     }
1012     
1013     /**
1014      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1015      * incoming eth depending on if we are in an active round or not 
1016      */
1017     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, CAE4Ddatasets.EventReturns memory _eventData_)
1018         private
1019     {
1020         // setup local rID
1021         uint256 _rID = rID_;
1022         
1023         // grab time
1024         uint256 _now = now;
1025         
1026         // if round is active
1027         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
1028         {
1029             // get earnings from all vaults and return unused to gen vault
1030             // because we use a custom safemath library.  this will throw if player 
1031             // tried to spend more eth than they have.
1032             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1033             
1034             // call core 
1035             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1036         
1037         // if round is not active and end round needs to be ran   
1038         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1039             // end the round (distributes pot) & start new round
1040             round_[_rID].ended = true;
1041             _eventData_ = endRound(_eventData_);
1042                 
1043             // build event data
1044             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1045             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1046                 
1047             // fire buy and distribute event 
1048             emit CAE4Devents.onReLoadAndDistribute
1049             (
1050                 msg.sender, 
1051                 plyr_[_pID].name, 
1052                 _eventData_.compressedData, 
1053                 _eventData_.compressedIDs, 
1054                 _eventData_.winnerAddr, 
1055                 _eventData_.winnerName, 
1056                 _eventData_.amountWon, 
1057                 _eventData_.newPot, 
1058                 _eventData_.P3DAmount, 
1059                 _eventData_.genAmount
1060             );
1061         }
1062     }
1063     
1064     /**
1065      * @dev this is the core logic for any buy/reload that happens while a round 
1066      * is live.
1067      */
1068     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, CAE4Ddatasets.EventReturns memory _eventData_)
1069         private
1070     {
1071         // if player is new to round
1072         if (plyrRnds_[_pID][_rID].keys == 0)
1073             _eventData_ = managePlayer(_pID, _eventData_);
1074         
1075         // early round eth limiter 
1076         //if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 5000000000000000000)
1077         //{
1078         //    uint256 _availableLimit = (5000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1079         //    uint256 _refund = _eth.sub(_availableLimit);
1080         //   plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1081         //   _eth = _availableLimit;
1082         //}
1083         
1084         // if eth left is greater than min eth allowed (sorry no pocket lint)
1085         if (_eth > 1000000000) 
1086         {
1087             
1088             // mint the new keys
1089             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1090             
1091             // if they bought at least 1 whole key
1092             if (_keys >= 1000000000000000000)
1093             {
1094             updateTimer(_keys, _rID);
1095 
1096             // set new leaders
1097             if (round_[_rID].plyr != _pID)
1098                 round_[_rID].plyr = _pID;  
1099             if (round_[_rID].team != _team)
1100                 round_[_rID].team = _team; 
1101             
1102             // set the new leader bool to true
1103             _eventData_.compressedData = _eventData_.compressedData + 100;
1104         }
1105             
1106             // manage airdrops
1107             if (_eth >= 100000000000000000)
1108             {
1109             airDropTracker_++;
1110             if (airdrop() == true)
1111             {
1112                 // gib muni
1113                 uint256 _prize;
1114                 if (_eth >= 10000000000000000000)
1115                 {
1116                     // calculate prize and give it to winner
1117                     _prize = ((airDropPot_).mul(75)) / 100;
1118                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1119                     
1120                     // adjust airDropPot 
1121                     airDropPot_ = (airDropPot_).sub(_prize);
1122                     
1123                     // let event know a tier 3 prize was won 
1124                     _eventData_.compressedData += 300000000000000000000000000000000;
1125                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1126                     // calculate prize and give it to winner
1127                     _prize = ((airDropPot_).mul(50)) / 100;
1128                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1129                     
1130                     // adjust airDropPot 
1131                     airDropPot_ = (airDropPot_).sub(_prize);
1132                     
1133                     // let event know a tier 2 prize was won 
1134                     _eventData_.compressedData += 200000000000000000000000000000000;
1135                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1136                     // calculate prize and give it to winner
1137                     _prize = ((airDropPot_).mul(25)) / 100;
1138                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1139                     
1140                     // adjust airDropPot 
1141                     airDropPot_ = (airDropPot_).sub(_prize);
1142                     
1143                     // let event know a tier 3 prize was won 
1144                     _eventData_.compressedData += 300000000000000000000000000000000;
1145                 }
1146                 // set airdrop happened bool to true
1147                 _eventData_.compressedData += 10000000000000000000000000000000;
1148                 // let event know how much was won 
1149                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1150                 
1151                 // reset air drop tracker
1152                 airDropTracker_ = 0;
1153             }
1154         }
1155     
1156             // store the air drop tracker number (number of buys since last airdrop)
1157             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1158             
1159             // update player 
1160             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1161             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1162             
1163             // update round
1164             round_[_rID].keys = _keys.add(round_[_rID].keys);
1165             round_[_rID].eth = _eth.add(round_[_rID].eth);
1166             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1167     
1168             // distribute eth
1169             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1170             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1171             
1172             // call end tx function to fire end tx event.
1173 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1174         }
1175     }
1176 //==============================================================================
1177 //     _ _ | _   | _ _|_ _  _ _  .
1178 //    (_(_||(_|_||(_| | (_)| _\  .
1179 //==============================================================================
1180     /**
1181      * @dev calculates unmasked earnings (just calculates, does not update mask)
1182      * @return earnings in wei format
1183      */
1184     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1185         private
1186         view
1187         returns(uint256)
1188     {
1189         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1190     }
1191     
1192     /** 
1193      * @dev returns the amount of keys you would get given an amount of eth. 
1194      * -functionhash- 0xce89c80c
1195      * @param _rID round ID you want price for
1196      * @param _eth amount of eth sent in 
1197      * @return keys received 
1198      */
1199     function calcKeysReceived(uint256 _rID, uint256 _eth)
1200         public
1201         view
1202         returns(uint256)
1203     {
1204         // grab time
1205         uint256 _now = now;
1206         
1207         // are we in a round?
1208         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1209             return ( (round_[_rID].eth).keysRec(_eth) );
1210         else // rounds over.  need keys for new round
1211             return ( (_eth).keys() );
1212     }
1213     
1214     /** 
1215      * @dev returns current eth price for X keys.  
1216      * -functionhash- 0xcf808000
1217      * @param _keys number of keys desired (in 18 decimal format)
1218      * @return amount of eth needed to send
1219      */
1220     function iWantXKeys(uint256 _keys)
1221         public
1222         view
1223         returns(uint256)
1224     {
1225         // setup local rID
1226         uint256 _rID = rID_;
1227         
1228         // grab time
1229         uint256 _now = now;
1230         
1231         // are we in a round?
1232         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1233             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1234         else // rounds over.  need price for new round
1235             return ( (_keys).eth() );
1236     }
1237 //==============================================================================
1238 //    _|_ _  _ | _  .
1239 //     | (_)(_)|_\  .
1240 //==============================================================================
1241     /**
1242 	 * @dev receives name/player info from names contract 
1243      */
1244     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1245         external
1246     {
1247         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1248         if (pIDxAddr_[_addr] != _pID)
1249             pIDxAddr_[_addr] = _pID;
1250         if (pIDxName_[_name] != _pID)
1251             pIDxName_[_name] = _pID;
1252         if (plyr_[_pID].addr != _addr)
1253             plyr_[_pID].addr = _addr;
1254         if (plyr_[_pID].name != _name)
1255             plyr_[_pID].name = _name;
1256         if (plyr_[_pID].laff != _laff)
1257             plyr_[_pID].laff = _laff;
1258         if (plyrNames_[_pID][_name] == false)
1259             plyrNames_[_pID][_name] = true;
1260     }
1261     
1262     /**
1263      * @dev receives entire player name list 
1264      */
1265     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1266         external
1267     {
1268         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1269         if(plyrNames_[_pID][_name] == false)
1270             plyrNames_[_pID][_name] = true;
1271     }   
1272         
1273     /**
1274      * @dev gets existing or registers new pID.  use this when a player may be new
1275      * @return pID 
1276      */
1277     function determinePID(CAE4Ddatasets.EventReturns memory _eventData_)
1278         private
1279         returns (CAE4Ddatasets.EventReturns)
1280     {
1281         uint256 _pID = pIDxAddr_[msg.sender];
1282         // if player is new to this version of fomo3d
1283         if (_pID == 0)
1284         {
1285             // grab their player ID, name and last aff ID, from player names contract 
1286             _pID = PlayerBook.getPlayerID(msg.sender);
1287             bytes32 _name = PlayerBook.getPlayerName(_pID);
1288             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1289             
1290             // set up player account 
1291             pIDxAddr_[msg.sender] = _pID;
1292             plyr_[_pID].addr = msg.sender;
1293             
1294             if (_name != "")
1295             {
1296                 pIDxName_[_name] = _pID;
1297                 plyr_[_pID].name = _name;
1298                 plyrNames_[_pID][_name] = true;
1299             }
1300             
1301             if (_laff != 0 && _laff != _pID)
1302                 plyr_[_pID].laff = _laff;
1303             
1304             // set the new player bool to true
1305             _eventData_.compressedData = _eventData_.compressedData + 1;
1306         } 
1307         return (_eventData_);
1308     }
1309     
1310     /**
1311      * @dev checks to make sure user picked a valid team.  if not sets team 
1312      * to default (rock)
1313      */
1314     function verifyTeam(uint256 _team)
1315         private
1316         pure
1317         returns (uint256)
1318     {
1319         if (_team < 0 || _team > 3)
1320             return(2);
1321         else
1322             return(_team);
1323     }
1324     
1325     /**
1326      * @dev decides if round end needs to be run & new round started.  and if 
1327      * player unmasked earnings from previously played rounds need to be moved.
1328      */
1329     function managePlayer(uint256 _pID, CAE4Ddatasets.EventReturns memory _eventData_)
1330         private
1331         returns (CAE4Ddatasets.EventReturns)
1332     {
1333         // if player has played a previous round, move their unmasked earnings
1334         // from that round to gen vault.
1335         if (plyr_[_pID].lrnd != 0)
1336             updateGenVault(_pID, plyr_[_pID].lrnd);
1337             
1338         // update player's last round played
1339         plyr_[_pID].lrnd = rID_;
1340             
1341         // set the joined round bool to true
1342         _eventData_.compressedData = _eventData_.compressedData + 10;
1343         
1344         return(_eventData_);
1345     }
1346     
1347     /**
1348      * @dev ends the round. manages paying out winner/splitting up pot
1349      */
1350     function endRound(CAE4Ddatasets.EventReturns memory _eventData_)
1351         private
1352         returns (CAE4Ddatasets.EventReturns)
1353     {
1354         // setup local rID
1355         uint256 _rID = rID_;
1356         
1357         // grab our winning player and team id's
1358         uint256 _winPID = round_[_rID].plyr;
1359         uint256 _winTID = round_[_rID].team;
1360         
1361         // grab our pot amount
1362         uint256 _pot = round_[_rID].pot;
1363         
1364         // calculate our winner share, community rewards, gen share, 
1365         // p3d share, and amount reserved for next pot 
1366         uint256 _win = (_pot.mul(potSplit_[_winTID].win)) / 100;
1367         uint256 _com = (_pot.mul(potSplit_[_winTID].com)) / 100;
1368         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1369         uint256 _res = ((_pot.sub(_win)).sub(_com)).sub(_gen);
1370         
1371         // calculate ppt for round mask
1372         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1373         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1374         if (_dust > 0)
1375         {
1376             _gen = _gen.sub(_dust);
1377             _res = _res.add(_dust);
1378         }
1379         
1380         // pay our winner
1381         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1382         
1383         // community rewards
1384         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1385         {
1386             // This ensures Team Just cannot influence the outcome of FoMo3D with
1387             // bank migrations by breaking outgoing transactions.
1388             // Something we would never do. But that's not the point.
1389             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1390             // highest belief that everything we create should be trustless.
1391             // Team JUST, The name you shouldn't have to trust.
1392             //_p3d = _p3d.add(_com);
1393             _res = _res.add(_com);
1394             _com = 0;
1395         }
1396         
1397         // distribute gen portion to key holders
1398         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1399         
1400         // send share for p3d to divies
1401         //if (_p3d > 0)
1402             //Divies.deposit.value(_p3d)();
1403             
1404         // prepare event data
1405         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1406         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1407         _eventData_.winnerAddr = plyr_[_winPID].addr;
1408         _eventData_.winnerName = plyr_[_winPID].name;
1409         _eventData_.amountWon = _win;
1410         _eventData_.genAmount = _gen;
1411         //_eventData_.P3DAmount = _p3d;
1412         _eventData_.newPot = _res;
1413         
1414         // start next round
1415         rID_++;
1416         _rID++;
1417         round_[_rID].strt = now;
1418         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1419         round_[_rID].pot = _res;
1420         round_[_rID].initPot = round_[_rID].pot;
1421         return(_eventData_);
1422     }
1423     
1424     /**
1425      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1426      */
1427     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1428         private 
1429     {
1430         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1431         if (_earnings > 0)
1432         {
1433             // put in gen vault
1434             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1435             // zero out their earnings by updating mask
1436             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1437         }
1438     }
1439     
1440     /**
1441      * @dev updates round timer based on number of whole keys bought.
1442      */
1443     function updateTimer(uint256 _keys, uint256 _rID)
1444         private
1445     {
1446         // grab time
1447         uint256 _now = now;
1448         
1449         // calculate time based on number of keys bought
1450         uint256 _newTime;
1451         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1452             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1453         else
1454             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1455         
1456         // compare to max and set new end time
1457         if (_newTime < (rndMax_).add(_now))
1458             round_[_rID].end = _newTime;
1459         else
1460             round_[_rID].end = rndMax_.add(_now);
1461     }
1462     
1463     /**
1464      * @dev generates a random number between 0-99 and checks to see if thats
1465      * resulted in an airdrop win
1466      * @return do we have a winner?
1467      */
1468     function airdrop()
1469         private 
1470         view 
1471         returns(bool)
1472     {
1473         uint256 seed = uint256(keccak256(abi.encodePacked(
1474             
1475             (block.timestamp).add
1476             (block.difficulty).add
1477             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1478             (block.gaslimit).add
1479             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1480             (block.number)
1481             
1482         )));
1483         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1484             return(true);
1485         else
1486             return(false);
1487     }
1488 
1489     /**
1490      * @dev distributes eth based on fees to com, aff, and p3d
1491      * CAE4Ddatasets.TeamFee(20,0);   //60% to pot, 15% to aff, 5% to com
1492      */
1493     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, CAE4Ddatasets.EventReturns memory _eventData_)
1494         private
1495         returns(CAE4Ddatasets.EventReturns)
1496     {
1497         // pay x% out to community rewards
1498         uint256 _com = _eth.mul(fees_[_team].com) / 100;
1499         
1500         // distribute share to affiliate
1501         uint256 _aff = _eth.mul(fees_[_team].aff) / 100;
1502         
1503         // decide what to do with affiliate share of fees
1504         // affiliate must not be self, and must have a name registered
1505         if (_affID != _pID && plyr_[_affID].name != '') {
1506             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1507             emit CAE4Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1508         } else {
1509         	_com = _com.add(_aff);
1510             //_p3d = _aff;
1511         }
1512         
1513         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1514         {
1515             // This ensures Team Just cannot influence the outcome of FoMo3D with
1516             // bank migrations by breaking outgoing transactions.
1517             // Something we would never do. But that's not the point.
1518             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1519             // highest belief that everything we create should be trustless.
1520             // Team JUST, The name you shouldn't have to trust.
1521             //_p3d = _com;
1522             round_[rID_].pot = round_[rID_].pot.add(_com);
1523             _com = 0;
1524         }
1525         
1526         // pay out p3d
1527         //_p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1528         //if (_p3d > 0)
1529         //{
1530             // deposit to divies contract
1531             //Divies.deposit.value(_p3d)();
1532             
1533             // set up event data
1534          //   _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1535         //}
1536         
1537         return(_eventData_);
1538     }
1539     
1540     function potSwap()
1541         external
1542         payable
1543     {
1544         // setup local rID
1545         uint256 _rID = rID_ + 1;
1546         
1547         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1548         emit CAE4Devents.onPotSwapDeposit(_rID, msg.value);
1549     }
1550     
1551     /**
1552      * @dev distributes eth based on fees to gen and pot
1553      */
1554     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, CAE4Ddatasets.EventReturns memory _eventData_)
1555         private
1556         returns(CAE4Ddatasets.EventReturns)
1557     {
1558         // calculate gen share
1559         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1560         
1561         // toss 1% into airdrop pot 
1562         //uint256 _air = (_eth / 100);
1563         //airDropPot_ = airDropPot_.add(_air);
1564         
1565         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1566         //_eth = _eth.sub(((14) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1567         _eth = _eth.sub((_eth.mul(fees_[_team].com + fees_[_team].aff)) / 100);
1568         // calculate pot 
1569         uint256 _pot = _eth.sub(_gen);
1570         
1571         // distribute gen share (thats what updateMasks() does) and adjust
1572         // balances for dust.
1573         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1574         if (_dust > 0)
1575             _gen = _gen.sub(_dust);
1576         
1577         // add eth to pot
1578         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1579         
1580         // set up event data
1581         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1582         _eventData_.potAmount = _pot;
1583         
1584         return(_eventData_);
1585     }
1586 
1587     /**
1588      * @dev updates masks for round and player when keys are bought
1589      * @return dust left over 
1590      */
1591     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1592         private
1593         returns(uint256)
1594     {
1595         /* MASKING NOTES
1596             earnings masks are a tricky thing for people to wrap their minds around.
1597             the basic thing to understand here.  is were going to have a global
1598             tracker based on profit per share for each round, that increases in
1599             relevant proportion to the increase in share supply.
1600             
1601             the player will have an additional mask that basically says "based
1602             on the rounds mask, my shares, and how much i've already withdrawn,
1603             how much is still owed to me?"
1604         */
1605         
1606         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1607         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1608         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1609             
1610         // calculate player earning from their own buy (only based on the keys
1611         // they just bought).  & update player earnings mask
1612         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1613         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1614         
1615         // calculate & return dust
1616         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1617     }
1618     
1619     /**
1620      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1621      * @return earnings in wei format
1622      */
1623     function withdrawEarnings(uint256 _pID)
1624         private
1625         returns(uint256)
1626     {
1627         // update gen vault
1628         updateGenVault(_pID, plyr_[_pID].lrnd);
1629         
1630         // from vaults 
1631         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1632         if (_earnings > 0)
1633         {
1634             plyr_[_pID].win = 0;
1635             plyr_[_pID].gen = 0;
1636             plyr_[_pID].aff = 0;
1637         }
1638 
1639         return(_earnings);
1640     }
1641     
1642     /**
1643      * @dev prepares compression data and fires event for buy or reload tx's
1644      */
1645     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, CAE4Ddatasets.EventReturns memory _eventData_)
1646         private
1647     {
1648         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1649         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1650         
1651         emit CAE4Devents.onEndTx
1652         (
1653             _eventData_.compressedData,
1654             _eventData_.compressedIDs,
1655             plyr_[_pID].name,
1656             msg.sender,
1657             _eth,
1658             _keys,
1659             _eventData_.winnerAddr,
1660             _eventData_.winnerName,
1661             _eventData_.amountWon,
1662             _eventData_.newPot,
1663             _eventData_.P3DAmount,
1664             _eventData_.genAmount,
1665             _eventData_.potAmount,
1666             airDropPot_
1667         );
1668     }
1669 //==============================================================================
1670 //    (~ _  _    _._|_    .
1671 //    _)(/_(_|_|| | | \/  .
1672 //====================/=========================================================
1673     /** upon contract deploy, it will be deactivated.  this is a one time
1674      * use function that will activate the contract.  we do this so devs 
1675      * have time to set things up on the web end                            **/
1676     bool public activated_ = false;
1677     function activate()
1678         public
1679     {
1680         // only team just can activate 
1681         require(
1682         	msg.sender == 0xe1A375cd31baF61D2fDAbd93F85c22A49a3795aF ||
1683         	msg.sender == 0xbD63f951D2FbbA361b2B48F65fce7E227EFD0CAC ,
1684             "only team just can activate"
1685         );
1686         
1687         // can only be ran once
1688         require(activated_ == false, "fomo3d already activated");
1689         
1690         // activate the contract 
1691         activated_ = true;
1692         
1693         // lets start first round
1694 		rID_ = 1;
1695         round_[1].strt = now + rndExtra_ - rndGap_;
1696         round_[1].end = now + rndInit_ + rndExtra_;
1697     }
1698     
1699 }
1700 
1701 library NameFilter {
1702     /**
1703      * @dev filters name strings
1704      * -converts uppercase to lower case.  
1705      * -makes sure it does not start/end with a space
1706      * -makes sure it does not contain multiple spaces in a row
1707      * -cannot be only numbers
1708      * -cannot start with 0x 
1709      * -restricts characters to A-Z, a-z, 0-9, and space.
1710      * @return reprocessed string in bytes32 format
1711      */
1712     function nameFilter(string _input)
1713         internal
1714         pure
1715         returns(bytes32)
1716     {
1717         bytes memory _temp = bytes(_input);
1718         uint256 _length = _temp.length;
1719         
1720         //sorry limited to 32 characters
1721         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1722         // make sure it doesnt start with or end with space
1723         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1724         // make sure first two characters are not 0x
1725         if (_temp[0] == 0x30)
1726         {
1727             require(_temp[1] != 0x78, "string cannot start with 0x");
1728             require(_temp[1] != 0x58, "string cannot start with 0X");
1729         }
1730         
1731         // create a bool to track if we have a non number character
1732         bool _hasNonNumber;
1733         
1734         // convert & check
1735         for (uint256 i = 0; i < _length; i++)
1736         {
1737             // if its uppercase A-Z
1738             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1739             {
1740                 // convert to lower case a-z
1741                 _temp[i] = byte(uint(_temp[i]) + 32);
1742                 
1743                 // we have a non number
1744                 if (_hasNonNumber == false)
1745                     _hasNonNumber = true;
1746             } else {
1747                 require
1748                 (
1749                     // require character is a space
1750                     _temp[i] == 0x20 || 
1751                     // OR lowercase a-z
1752                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1753                     // or 0-9
1754                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1755                     "string contains invalid characters"
1756                 );
1757                 // make sure theres not 2x spaces in a row
1758                 if (_temp[i] == 0x20)
1759                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1760                 
1761                 // see if we have a character other than a number
1762                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1763                     _hasNonNumber = true;    
1764             }
1765         }
1766         
1767         require(_hasNonNumber == true, "string cannot be only numbers");
1768         
1769         bytes32 _ret;
1770         assembly {
1771             _ret := mload(add(_temp, 32))
1772         }
1773         return (_ret);
1774     }
1775 }
1776 
1777 library SafeMath {
1778     
1779     /**
1780     * @dev Multiplies two numbers, throws on overflow.
1781     */
1782     function mul(uint256 a, uint256 b) 
1783         internal 
1784         pure 
1785         returns (uint256 c) 
1786     {
1787         if (a == 0) {
1788             return 0;
1789         }
1790         c = a * b;
1791         require(c / a == b, "SafeMath mul failed");
1792         return c;
1793     }
1794 
1795     /**
1796     * @dev Integer division of two numbers, truncating the quotient.
1797     */
1798     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1799         // assert(b > 0); // Solidity automatically throws when dividing by 0
1800         uint256 c = a / b;
1801         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1802         return c;
1803     }
1804     
1805     /**
1806     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1807     */
1808     function sub(uint256 a, uint256 b)
1809         internal
1810         pure
1811         returns (uint256) 
1812     {
1813         require(b <= a, "SafeMath sub failed");
1814         return a - b;
1815     }
1816 
1817     /**
1818     * @dev Adds two numbers, throws on overflow.
1819     */
1820     function add(uint256 a, uint256 b)
1821         internal
1822         pure
1823         returns (uint256 c) 
1824     {
1825         c = a + b;
1826         require(c >= a, "SafeMath add failed");
1827         return c;
1828     }
1829     
1830     /**
1831      * @dev gives square root of given x.
1832      */
1833     function sqrt(uint256 x)
1834         internal
1835         pure
1836         returns (uint256 y) 
1837     {
1838         uint256 z = ((add(x,1)) / 2);
1839         y = x;
1840         while (z < y) 
1841         {
1842             y = z;
1843             z = ((add((x / z),z)) / 2);
1844         }
1845     }
1846     
1847     /**
1848      * @dev gives square. multiplies x by x
1849      */
1850     function sq(uint256 x)
1851         internal
1852         pure
1853         returns (uint256)
1854     {
1855         return (mul(x,x));
1856     }
1857     
1858     /**
1859      * @dev x to the power of y 
1860      */
1861     function pwr(uint256 x, uint256 y)
1862         internal 
1863         pure 
1864         returns (uint256)
1865     {
1866         if (x==0)
1867             return (0);
1868         else if (y==0)
1869             return (1);
1870         else 
1871         {
1872             uint256 z = x;
1873             for (uint256 i=1; i < y; i++)
1874                 z = mul(z,x);
1875             return (z);
1876         }
1877     }
1878 }
1879 
1880 
1881 library UintCompressor {
1882     using SafeMath for *;
1883     
1884     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
1885         internal
1886         pure
1887         returns(uint256)
1888     {
1889         // check conditions 
1890         require(_end < 77 && _start < 77, "start/end must be less than 77");
1891         require(_end >= _start, "end must be >= start");
1892         
1893         // format our start/end points
1894         _end = exponent(_end).mul(10);
1895         _start = exponent(_start);
1896         
1897         // check that the include data fits into its segment 
1898         require(_include < (_end / _start));
1899         
1900         // build middle
1901         if (_include > 0)
1902             _include = _include.mul(_start);
1903         
1904         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
1905     }
1906     
1907     function extract(uint256 _input, uint256 _start, uint256 _end)
1908 	    internal
1909 	    pure
1910 	    returns(uint256)
1911     {
1912         // check conditions
1913         require(_end < 77 && _start < 77, "start/end must be less than 77");
1914         require(_end >= _start, "end must be >= start");
1915         
1916         // format our start/end points
1917         _end = exponent(_end).mul(10);
1918         _start = exponent(_start);
1919         
1920         // return requested section
1921         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
1922     }
1923     
1924     function exponent(uint256 _position)
1925         private
1926         pure
1927         returns(uint256)
1928     {
1929         return((10).pwr(_position));
1930     }
1931 }
1932 
1933 library CAE4DKeysCalcLong {
1934     using SafeMath for *;
1935     /**
1936      * @dev calculates number of keys received given X eth 
1937      * @param _curEth current amount of eth in contract 
1938      * @param _newEth eth being spent
1939      * @return amount of ticket purchased
1940      */
1941     function keysRec(uint256 _curEth, uint256 _newEth)
1942         internal
1943         pure
1944         returns (uint256)
1945     {
1946         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1947     }
1948     
1949     /**
1950      * @dev calculates amount of eth received if you sold X keys 
1951      * @param _curKeys current amount of keys that exist 
1952      * @param _sellKeys amount of keys you wish to sell
1953      * @return amount of eth received
1954      */
1955     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1956         internal
1957         pure
1958         returns (uint256)
1959     {
1960         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1961     }
1962 
1963     /**
1964      * @dev calculates how many keys would exist with given an amount of eth
1965      * @param _eth eth "in contract"
1966      * @return number of keys that would exist
1967      */
1968     function keys(uint256 _eth) 
1969         internal
1970         pure
1971         returns(uint256)
1972     {
1973         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1974     }
1975     
1976     /**
1977      * @dev calculates how much eth would be in contract given a number of keys
1978      * @param _keys number of keys "in contract" 
1979      * @return eth that would exists
1980      */
1981     function eth(uint256 _keys) 
1982         internal
1983         pure
1984         returns(uint256)  
1985     {
1986         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1987     }
1988 }