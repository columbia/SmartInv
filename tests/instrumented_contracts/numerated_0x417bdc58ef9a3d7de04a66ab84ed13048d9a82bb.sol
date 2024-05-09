1 pragma solidity ^0.4.24;
2 /**
3  * AirDrop.me : a... borrowing, of F3D's code which drops 10% of all buy-ins to the Zethr.io bankroll.
4  *
5  * You know the rules.
6  *
7  */
8 
9 // Events 
10 
11 contract F3Devents {
12     // fired whenever a player registers a name
13     event onNewName
14     (
15         uint256 indexed playerID,
16         address indexed playerAddress,
17         bytes32 indexed playerName,
18         bool isNewPlayer,
19         uint256 affiliateID,
20         address affiliateAddress,
21         bytes32 affiliateName,
22         uint256 amountPaid,
23         uint256 timeStamp
24     );
25     
26     // fired at end of buy or reload
27     event onEndTx
28     (
29         uint256 compressedData,     
30         uint256 compressedIDs,      
31         bytes32 playerName,
32         address playerAddress,
33         uint256 ethIn,
34         uint256 keysBought,
35         address winnerAddr,
36         bytes32 winnerName,
37         uint256 amountWon,
38         uint256 newPot,
39         uint256 P3DAmount,
40         uint256 genAmount,
41         uint256 potAmount,
42         uint256 airDropPot
43     );
44     
45 	// fired whenever theres a withdraw
46     event onWithdraw
47     (
48         uint256 indexed playerID,
49         address playerAddress,
50         bytes32 playerName,
51         uint256 ethOut,
52         uint256 timeStamp
53     );
54     
55     // fired whenever a withdraw forces end round to be ran
56     event onWithdrawAndDistribute
57     (
58         address playerAddress,
59         bytes32 playerName,
60         uint256 ethOut,
61         uint256 compressedData,
62         uint256 compressedIDs,
63         address winnerAddr,
64         bytes32 winnerName,
65         uint256 amountWon,
66         uint256 newPot,
67         uint256 P3DAmount,
68         uint256 genAmount
69     );
70     
71     // (fomo3d long only) fired whenever a player tries a buy after round timer 
72     // hit zero, and causes end round to be ran.
73     event onBuyAndDistribute
74     (
75         address playerAddress,
76         bytes32 playerName,
77         uint256 ethIn,
78         uint256 compressedData,
79         uint256 compressedIDs,
80         address winnerAddr,
81         bytes32 winnerName,
82         uint256 amountWon,
83         uint256 newPot,
84         uint256 P3DAmount,
85         uint256 genAmount
86     );
87     
88     // (fomo3d long only) fired whenever a player tries a reload after round timer 
89     // hit zero, and causes end round to be ran.
90     event onReLoadAndDistribute
91     (
92         address playerAddress,
93         bytes32 playerName,
94         uint256 compressedData,
95         uint256 compressedIDs,
96         address winnerAddr,
97         bytes32 winnerName,
98         uint256 amountWon,
99         uint256 newPot,
100         uint256 P3DAmount,
101         uint256 genAmount
102     );
103     
104     // fired whenever an affiliate is paid
105     event onAffiliatePayout
106     (
107         uint256 indexed affiliateID,
108         address affiliateAddress,
109         bytes32 affiliateName,
110         uint256 indexed roundID,
111         uint256 indexed buyerID,
112         uint256 amount,
113         uint256 timeStamp
114     );
115     
116     // received pot swap deposit
117     event onPotSwapDeposit
118     (
119         uint256 roundID,
120         uint256 amountAddedToPot
121     );
122 }
123 
124 
125 // Contract Setup
126 
127 contract modularLong is F3Devents {}
128 
129 contract DiviesCTR {
130     function deposit() public payable;
131 }
132 
133 contract FoMo3Dlong is modularLong {
134     using SafeMath for *;
135     using NameFilter for string;
136     using F3DKeysCalcLong for uint256;
137 	
138 	otherFoMo3D private otherF3D_;
139     DiviesCTR constant private Divies = DiviesCTR(0x95CD217Da207e35E3Ac4cade6e766D5FB6fDAf8d);
140     address constant private FeeAddr = 0xb51d0DF324c513Cf07efD075Cc5bccA1D0F211Ab;
141     //address constant private Jekyll_Island_Inc = Divies;//(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
142 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x77abd49884c36193e7d1fccc6898fcdbd9d23ecc);
143     //F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
144 
145     
146 // Game Settings
147 
148     string constant public name = "Zethr AirdropMe";
149     string constant public symbol = "ZTHA";
150 	uint256 private rndExtra_ = 30;//extSettings.getLongExtra();     // length of the very first ICO 
151     uint256 private rndGap_ = 1 hours; //extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
152     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
153     uint256 constant private rndInc_ = 60 seconds;              // every full key purchased adds this much to the timer
154     uint256 constant private rndMax_ = 8 hours;                // max length a round timer can be
155 
156 // Data Settings
157 
158 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
159     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
160     uint256 public rID_;    // round id number / total rounds that have happened
161     
162 
163 // Player Data
164 
165     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
166     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
167     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
168     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
169     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
170 
171 // Round Data
172 
173     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
174     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
175 
176 // Team Fee Data
177     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
178     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
179 
180 // Constructor
181 
182     constructor()
183         public
184     {
185 		// Team allocation structures
186         // 0 = whales
187         // 1 = bears
188         // 2 = sneks
189         // 3 = bulls
190 
191 		// Team allocation percentages
192         // (F3D, P3D) + (Pot , Referrals, Community)
193             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
194         fees_[0] = F3Ddatasets.TeamFee(56,10);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
195         fees_[1] = F3Ddatasets.TeamFee(56,10);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
196         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
197         fees_[3] = F3Ddatasets.TeamFee(56,10);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
198         
199         // how to split up the final pot based on which team was picked
200         // (F3D, P3D)
201         potSplit_[0] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 25% to next round, 2% to com
202         potSplit_[1] = F3Ddatasets.PotSplit(20,20);   //48% to winner, 25% to next round, 2% to com
203         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
204         potSplit_[3] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
205 	}
206 
207 // Modules
208 
209     /**
210      * @dev used to make sure no one can interact with contract until it has 
211      * been activated. 
212      */
213     modifier isActivated() {
214         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
215         _;
216     }
217     
218     /**
219      * @dev prevents contracts from interacting with fomo3d 
220      */
221     modifier isHuman() {
222         // *breathes in*
223         // HAHAHAHA
224         //address _addr = msg.sender;
225         //uint256 _codeLength;
226         
227         //assembly {_codeLength := extcodesize(_addr)}
228         //require(_codeLength == 0, "sorry humans only");
229         require(msg.sender == tx.origin, "sorry humans only - FOR REAL THIS TIME");
230         _;
231     }
232 
233     /**
234      * @dev sets boundaries for incoming tx 
235      */
236     modifier isWithinLimits(uint256 _eth) {
237         require(_eth >= 1000000000, "pocket lint: not a valid currency");
238         require(_eth <= 100000000000000000000000, "no vitalik, no");
239         _;    
240     }
241     
242 // Public Functions
243 
244     /**
245      * @dev emergency buy uses last stored affiliate ID and team snek
246      */
247     function()
248         isActivated()
249         isHuman()
250         isWithinLimits(msg.value)
251         public
252         payable
253     {
254         // set up our tx event data and determine if player is new or not
255         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
256             
257         // fetch player id
258         uint256 _pID = pIDxAddr_[msg.sender];
259         
260         // buy core 
261         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
262     }
263     
264     /**
265      * @dev converts all incoming ethereum to keys.
266      * -functionhash- 0x8f38f309 (using ID for affiliate)
267      * -functionhash- 0x98a0871d (using address for affiliate)
268      * -functionhash- 0xa65b37a1 (using name for affiliate)
269      * @param _affCode the ID/address/name of the player who gets the affiliate fee
270      * @param _team what team is the player playing for?
271      */
272     function buyXid(uint256 _affCode, uint256 _team)
273         isActivated()
274         isHuman()
275         isWithinLimits(msg.value)
276         public
277         payable
278     {
279         // set up our tx event data and determine if player is new or not
280         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
281         
282         // fetch player id
283         uint256 _pID = pIDxAddr_[msg.sender];
284         
285         // manage affiliate residuals
286         // if no affiliate code was given or player tried to use their own, lolz
287         if (_affCode == 0 || _affCode == _pID)
288         {
289             // use last stored affiliate code 
290             _affCode = plyr_[_pID].laff;
291             
292         // if affiliate code was given & its not the same as previously stored 
293         } else if (_affCode != plyr_[_pID].laff) {
294             // update last affiliate 
295             plyr_[_pID].laff = _affCode;
296         }
297         
298         // verify a valid team was selected
299         _team = verifyTeam(_team);
300         
301         // buy core 
302         buyCore(_pID, _affCode, _team, _eventData_);
303     }
304     
305     function buyXaddr(address _affCode, uint256 _team)
306         isActivated()
307         isHuman()
308         isWithinLimits(msg.value)
309         public
310         payable
311     {
312         // set up our tx event data and determine if player is new or not
313         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
314         
315         // fetch player id
316         uint256 _pID = pIDxAddr_[msg.sender];
317         
318         // manage affiliate residuals
319         uint256 _affID;
320         // if no affiliate code was given or player tried to use their own, lolz
321         if (_affCode == address(0) || _affCode == msg.sender)
322         {
323             // use last stored affiliate code
324             _affID = plyr_[_pID].laff;
325         
326         // if affiliate code was given    
327         } else {
328             // get affiliate ID from aff Code 
329             _affID = pIDxAddr_[_affCode];
330             
331             // if affID is not the same as previously stored 
332             if (_affID != plyr_[_pID].laff)
333             {
334                 // update last affiliate
335                 plyr_[_pID].laff = _affID;
336             }
337         }
338         
339         // verify a valid team was selected
340         _team = verifyTeam(_team);
341         
342         // buy core 
343         buyCore(_pID, _affID, _team, _eventData_);
344     }
345     
346     function buyXname(bytes32 _affCode, uint256 _team)
347         isActivated()
348         isHuman()
349         isWithinLimits(msg.value)
350         public
351         payable
352     {
353         // set up our tx event data and determine if player is new or not
354         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
355         
356         // fetch player id
357         uint256 _pID = pIDxAddr_[msg.sender];
358         
359         // manage affiliate residuals
360         uint256 _affID;
361         // if no affiliate code was given or player tried to use their own, lolz
362         if (_affCode == '' || _affCode == plyr_[_pID].name)
363         {
364             // use last stored affiliate code
365             _affID = plyr_[_pID].laff;
366         
367         // if affiliate code was given
368         } else {
369             // get affiliate ID from aff Code
370             _affID = pIDxName_[_affCode];
371             
372             // if affID is not the same as previously stored
373             if (_affID != plyr_[_pID].laff)
374             {
375                 // update last affiliate
376                 plyr_[_pID].laff = _affID;
377             }
378         }
379         
380         // verify a valid team was selected
381         _team = verifyTeam(_team);
382         
383         // buy core 
384         buyCore(_pID, _affID, _team, _eventData_);
385     }
386     
387     /**
388      * @dev essentially the same as buy, but instead of you sending ether 
389      * from your wallet, it uses your unwithdrawn earnings.
390      * -functionhash- 0x349cdcac (using ID for affiliate)
391      * -functionhash- 0x82bfc739 (using address for affiliate)
392      * -functionhash- 0x079ce327 (using name for affiliate)
393      * @param _affCode the ID/address/name of the player who gets the affiliate fee
394      * @param _team what team is the player playing for?
395      * @param _eth amount of earnings to use (remainder returned to gen vault)
396      */
397     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
398         isActivated()
399         isHuman()
400         isWithinLimits(_eth)
401         public
402     {
403         // set up our tx event data
404         F3Ddatasets.EventReturns memory _eventData_;
405         
406         // fetch player ID
407         uint256 _pID = pIDxAddr_[msg.sender];
408         
409         // manage affiliate residuals
410         // if no affiliate code was given or player tried to use their own, lolz
411         if (_affCode == 0 || _affCode == _pID)
412         {
413             // use last stored affiliate code 
414             _affCode = plyr_[_pID].laff;
415             
416         // if affiliate code was given & its not the same as previously stored 
417         } else if (_affCode != plyr_[_pID].laff) {
418             // update last affiliate 
419             plyr_[_pID].laff = _affCode;
420         }
421 
422         // verify a valid team was selected
423         _team = verifyTeam(_team);
424 
425         // reload core
426         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
427     }
428     
429     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
430         isActivated()
431         isHuman()
432         isWithinLimits(_eth)
433         public
434     {
435         // set up our tx event data
436         F3Ddatasets.EventReturns memory _eventData_;
437         
438         // fetch player ID
439         uint256 _pID = pIDxAddr_[msg.sender];
440         
441         // manage affiliate residuals
442         uint256 _affID;
443         // if no affiliate code was given or player tried to use their own, lolz
444         if (_affCode == address(0) || _affCode == msg.sender)
445         {
446             // use last stored affiliate code
447             _affID = plyr_[_pID].laff;
448         
449         // if affiliate code was given    
450         } else {
451             // get affiliate ID from aff Code 
452             _affID = pIDxAddr_[_affCode];
453             
454             // if affID is not the same as previously stored 
455             if (_affID != plyr_[_pID].laff)
456             {
457                 // update last affiliate
458                 plyr_[_pID].laff = _affID;
459             }
460         }
461         
462         // verify a valid team was selected
463         _team = verifyTeam(_team);
464         
465         // reload core
466         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
467     }
468     
469     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
470         isActivated()
471         isHuman()
472         isWithinLimits(_eth)
473         public
474     {
475         // set up our tx event data
476         F3Ddatasets.EventReturns memory _eventData_;
477         
478         // fetch player ID
479         uint256 _pID = pIDxAddr_[msg.sender];
480         
481         // manage affiliate residuals
482         uint256 _affID;
483         // if no affiliate code was given or player tried to use their own, lolz
484         if (_affCode == '' || _affCode == plyr_[_pID].name)
485         {
486             // use last stored affiliate code
487             _affID = plyr_[_pID].laff;
488         
489         // if affiliate code was given
490         } else {
491             // get affiliate ID from aff Code
492             _affID = pIDxName_[_affCode];
493             
494             // if affID is not the same as previously stored
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501         
502         // verify a valid team was selected
503         _team = verifyTeam(_team);
504         
505         // reload core
506         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
507     }
508 
509     /**
510      * @dev withdraws all of your earnings.
511      * -functionhash- 0x3ccfd60b
512      */
513     function withdraw()
514         isActivated()
515         isHuman()
516         public
517     {
518         // setup local rID 
519         uint256 _rID = rID_;
520         
521         // grab time
522         uint256 _now = now;
523         
524         // fetch player ID
525         uint256 _pID = pIDxAddr_[msg.sender];
526         
527         // setup temp var for player eth
528         uint256 _eth;
529         
530         // check to see if round has ended and no one has run round end yet
531         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
532         {
533             // set up our tx event data
534             F3Ddatasets.EventReturns memory _eventData_;
535             
536             // end the round (distributes pot)
537 			round_[_rID].ended = true;
538             _eventData_ = endRound(_eventData_);
539             
540 			// get their earnings
541             _eth = withdrawEarnings(_pID);
542             
543             // gib moni
544             if (_eth > 0)
545                 plyr_[_pID].addr.transfer(_eth);    
546             
547             // build event data
548             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
549             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
550             
551             // fire withdraw and distribute event
552             emit F3Devents.onWithdrawAndDistribute
553             (
554                 msg.sender, 
555                 plyr_[_pID].name, 
556                 _eth, 
557                 _eventData_.compressedData, 
558                 _eventData_.compressedIDs, 
559                 _eventData_.winnerAddr, 
560                 _eventData_.winnerName, 
561                 _eventData_.amountWon, 
562                 _eventData_.newPot, 
563                 _eventData_.P3DAmount, 
564                 _eventData_.genAmount
565             );
566             
567         // in any other situation
568         } else {
569             // get their earnings
570             _eth = withdrawEarnings(_pID);
571             
572             // gib moni
573             if (_eth > 0)
574                 plyr_[_pID].addr.transfer(_eth);
575             
576             // fire withdraw event
577             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
578         }
579     }
580     
581     /**
582      * @dev use these to register names.  they are just wrappers that will send the
583      * registration requests to the PlayerBook contract.  So registering here is the 
584      * same as registering there.  UI will always display the last name you registered.
585      * but you will still own all previously registered names to use as affiliate 
586      * links.
587      * - must pay a registration fee.
588      * - name must be unique
589      * - names will be converted to lowercase
590      * - name cannot start or end with a space 
591      * - cannot have more than 1 space in a row
592      * - cannot be only numbers
593      * - cannot start with 0x 
594      * - name must be at least 1 char
595      * - max length of 32 characters long
596      * - allowed characters: a-z, 0-9, and space
597      * -functionhash- 0x921dec21 (using ID for affiliate)
598      * -functionhash- 0x3ddd4698 (using address for affiliate)
599      * -functionhash- 0x685ffd83 (using name for affiliate)
600      * @param _nameString players desired name
601      * @param _affCode affiliate ID, address, or name of who referred you
602      * @param _all set to true if you want this to push your info to all games 
603      * (this might cost a lot of gas)
604      */
605     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
614         
615         uint256 _pID = pIDxAddr_[_addr];
616         
617         // fire event
618         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620     
621     function registerNameXaddr(string _nameString, address _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630         
631         uint256 _pID = pIDxAddr_[_addr];
632         
633         // fire event
634         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636     
637     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
638         isHuman()
639         public
640         payable
641     {
642         bytes32 _name = _nameString.nameFilter();
643         address _addr = msg.sender;
644         uint256 _paid = msg.value;
645         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
646         
647         uint256 _pID = pIDxAddr_[_addr];
648         
649         // fire event
650         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
651     }
652 
653 // Getters    
654 
655     /**
656      * @dev return the price buyer will pay for next 1 individual key.
657      * -functionhash- 0x018a25e8
658      * @return price for next key bought (in wei format)
659      */
660     function getBuyPrice()
661         public 
662         view 
663         returns(uint256)
664     {  
665         // setup local rID
666         uint256 _rID = rID_;
667         
668         // grab time
669         uint256 _now = now;
670         
671         // are we in a round?
672         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
673             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
674         else // rounds over.  need price for new round
675             return ( 75000000000000 ); // init
676     }
677     
678     /**
679      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
680      * provider
681      * -functionhash- 0xc7e284b8
682      * @return time left in seconds
683      */
684     function getTimeLeft()
685         public
686         view
687         returns(uint256)
688     {
689         // setup local rID
690         uint256 _rID = rID_;
691         
692         // grab time
693         uint256 _now = now;
694         
695         if (_now < round_[_rID].end)
696             if (_now > round_[_rID].strt + rndGap_)
697                 return( (round_[_rID].end).sub(_now) );
698             else
699                 return( (round_[_rID].strt + rndGap_).sub(_now) );
700         else
701             return(0);
702     }
703     
704     /**
705      * @dev returns player earnings per vaults 
706      * -functionhash- 0x63066434
707      * @return winnings vault
708      * @return general vault
709      * @return affiliate vault
710      */
711     function getPlayerVaults(uint256 _pID)
712         public
713         view
714         returns(uint256 ,uint256, uint256)
715     {
716         // setup local rID
717         uint256 _rID = rID_;
718         
719         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
720         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
721         {
722             // if player is winner 
723             if (round_[_rID].plyr == _pID)
724             {
725                 return
726                 (
727                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
728                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
729                     plyr_[_pID].aff
730                 );
731             // if player is not the winner
732             } else {
733                 return
734                 (
735                     plyr_[_pID].win,
736                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
737                     plyr_[_pID].aff
738                 );
739             }
740             
741         // if round is still going on, or round has ended and round end has been ran
742         } else {
743             return
744             (
745                 plyr_[_pID].win,
746                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
747                 plyr_[_pID].aff
748             );
749         }
750     }
751     
752     /**
753      * solidity hates stack limits.  this lets us avoid that hate 
754      */
755     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
756         private
757         view
758         returns(uint256)
759     {
760         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
761     }
762     
763     /**
764      * @dev returns all current round info needed for front end
765      * -functionhash- 0x747dff42
766      * @return eth invested during ICO phase
767      * @return round id 
768      * @return total keys for round 
769      * @return time round ends
770      * @return time round started
771      * @return current pot 
772      * @return current team ID & player ID in lead 
773      * @return current player in leads address 
774      * @return current player in leads name
775      * @return whales eth in for round
776      * @return bears eth in for round
777      * @return sneks eth in for round
778      * @return bulls eth in for round
779      * @return airdrop tracker # & airdrop pot
780      */
781     function getCurrentRoundInfo()
782         public
783         view
784         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
785     {
786         // setup local rID
787         uint256 _rID = rID_;
788         
789         return
790         (
791             round_[_rID].ico,               //0
792             _rID,                           //1
793             round_[_rID].keys,              //2
794             round_[_rID].end,               //3
795             round_[_rID].strt,              //4
796             round_[_rID].pot,               //5
797             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
798             plyr_[round_[_rID].plyr].addr,  //7
799             plyr_[round_[_rID].plyr].name,  //8
800             rndTmEth_[_rID][0],             //9
801             rndTmEth_[_rID][1],             //10
802             rndTmEth_[_rID][2],             //11
803             rndTmEth_[_rID][3],             //12
804             airDropTracker_ + (airDropPot_ * 1000)              //13
805         );
806     }
807 
808     /**
809      * @dev returns player info based on address.  if no address is given, it will 
810      * use msg.sender 
811      * -functionhash- 0xee0b5d8b
812      * @param _addr address of the player you want to lookup 
813      * @return player ID 
814      * @return player name
815      * @return keys owned (current round)
816      * @return winnings vault
817      * @return general vault 
818      * @return affiliate vault 
819 	 * @return player round eth
820      */
821     function getPlayerInfoByAddress(address _addr)
822         public 
823         view 
824         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
825     {
826         // setup local rID
827         uint256 _rID = rID_;
828         
829         if (_addr == address(0))
830         {
831             _addr == msg.sender;
832         }
833         uint256 _pID = pIDxAddr_[_addr];
834         
835         return
836         (
837             _pID,                               //0
838             plyr_[_pID].name,                   //1
839             plyrRnds_[_pID][_rID].keys,         //2
840             plyr_[_pID].win,                    //3
841             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
842             plyr_[_pID].aff,                    //5
843             plyrRnds_[_pID][_rID].eth           //6
844         );
845     }
846 
847 // Core Logic
848 
849     /**
850      * @dev logic runs whenever a buy order is executed.  determines how to handle 
851      * incoming eth depending on if we are in an active round or not
852      */
853     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
854         private
855     {
856         // setup local rID
857         uint256 _rID = rID_;
858         
859         // grab time
860         uint256 _now = now;
861         
862         // if round is active
863         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
864         {
865             // call core 
866             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
867         
868         // if round is not active     
869         } else {
870             // check to see if end round needs to be ran
871             if (_now > round_[_rID].end && round_[_rID].ended == false) 
872             {
873                 // end the round (distributes pot) & start new round
874 			    round_[_rID].ended = true;
875                 _eventData_ = endRound(_eventData_);
876                 
877                 // build event data
878                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
879                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
880                 
881                 // fire buy and distribute event 
882                 emit F3Devents.onBuyAndDistribute
883                 (
884                     msg.sender, 
885                     plyr_[_pID].name, 
886                     msg.value, 
887                     _eventData_.compressedData, 
888                     _eventData_.compressedIDs, 
889                     _eventData_.winnerAddr, 
890                     _eventData_.winnerName, 
891                     _eventData_.amountWon, 
892                     _eventData_.newPot, 
893                     _eventData_.P3DAmount, 
894                     _eventData_.genAmount
895                 );
896             }
897             
898             // put eth in players vault 
899             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
900         }
901     }
902     
903     /**
904      * @dev logic runs whenever a reload order is executed.  determines how to handle 
905      * incoming eth depending on if we are in an active round or not 
906      */
907     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
908         private
909     {
910         // setup local rID
911         uint256 _rID = rID_;
912         
913         // grab time
914         uint256 _now = now;
915         
916         // if round is active
917         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
918         {
919             // get earnings from all vaults and return unused to gen vault
920             // because we use a custom safemath library.  this will throw if player 
921             // tried to spend more eth than they have.
922             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
923             
924             // call core 
925             core(_rID, _pID, _eth, _affID, _team, _eventData_);
926         
927         // if round is not active and end round needs to be ran   
928         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
929             // end the round (distributes pot) & start new round
930             round_[_rID].ended = true;
931             _eventData_ = endRound(_eventData_);
932                 
933             // build event data
934             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
935             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
936                 
937             // fire buy and distribute event 
938             emit F3Devents.onReLoadAndDistribute
939             (
940                 msg.sender, 
941                 plyr_[_pID].name, 
942                 _eventData_.compressedData, 
943                 _eventData_.compressedIDs, 
944                 _eventData_.winnerAddr, 
945                 _eventData_.winnerName, 
946                 _eventData_.amountWon, 
947                 _eventData_.newPot, 
948                 _eventData_.P3DAmount, 
949                 _eventData_.genAmount
950             );
951         }
952     }
953     
954     /**
955      * @dev this is the core logic for any buy/reload that happens while a round 
956      * is live.
957      */
958     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
959         private
960     {
961         // if player is new to round
962         if (plyrRnds_[_pID][_rID].keys == 0)
963             _eventData_ = managePlayer(_pID, _eventData_);
964         
965         // early round eth limiter 
966         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
967         {
968             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
969             uint256 _refund = _eth.sub(_availableLimit);
970             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
971             _eth = _availableLimit;
972         }
973         
974         // if eth left is greater than min eth allowed (sorry no pocket lint)
975         if (_eth > 1000000000) 
976         {
977             
978             // mint the new keys
979             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
980             
981             // if they bought at least 1 whole key
982             if (_keys >= 1000000000000000000)
983             {
984             updateTimer(_keys, _rID);
985 
986             // set new leaders
987             if (round_[_rID].plyr != _pID)
988                 round_[_rID].plyr = _pID;  
989             if (round_[_rID].team != _team)
990                 round_[_rID].team = _team; 
991             
992             // set the new leader bool to true
993             _eventData_.compressedData = _eventData_.compressedData + 100;
994         }
995             
996             // manage airdrops
997             if (_eth >= 100000000000000000)
998             {
999             airDropTracker_++;
1000             if (airdrop() == true)
1001             {
1002                 // gib muni
1003                 uint256 _prize;
1004                 if (_eth >= 10000000000000000000)
1005                 {
1006                     // calculate prize and give it to winner
1007                     _prize = ((airDropPot_).mul(75)) / 100;
1008                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1009                     
1010                     // adjust airDropPot 
1011                     airDropPot_ = (airDropPot_).sub(_prize);
1012                     
1013                     // let event know a tier 3 prize was won 
1014                     _eventData_.compressedData += 300000000000000000000000000000000;
1015                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1016                     // calculate prize and give it to winner
1017                     _prize = ((airDropPot_).mul(50)) / 100;
1018                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1019                     
1020                     // adjust airDropPot 
1021                     airDropPot_ = (airDropPot_).sub(_prize);
1022                     
1023                     // let event know a tier 2 prize was won 
1024                     _eventData_.compressedData += 200000000000000000000000000000000;
1025                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1026                     // calculate prize and give it to winner
1027                     _prize = ((airDropPot_).mul(25)) / 100;
1028                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1029                     
1030                     // adjust airDropPot 
1031                     airDropPot_ = (airDropPot_).sub(_prize);
1032                     
1033                     // let event know a tier 3 prize was won 
1034                     _eventData_.compressedData += 300000000000000000000000000000000;
1035                 }
1036                 // set airdrop happened bool to true
1037                 _eventData_.compressedData += 10000000000000000000000000000000;
1038                 // let event know how much was won 
1039                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1040                 
1041                 // reset air drop tracker
1042                 airDropTracker_ = 0;
1043             }
1044         }
1045     
1046             // store the air drop tracker number (number of buys since last airdrop)
1047             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1048             
1049             // update player 
1050             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1051             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1052             
1053             // update round
1054             round_[_rID].keys = _keys.add(round_[_rID].keys);
1055             round_[_rID].eth = _eth.add(round_[_rID].eth);
1056             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1057     
1058             // distribute eth
1059             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1060             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1061             
1062             // call end tx function to fire end tx event.
1063 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1064         }
1065     }
1066 
1067 // Calculators
1068     
1069     /**
1070      * @dev calculates unmasked earnings (just calculates, does not update mask)
1071      * @return earnings in wei format
1072      */
1073     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1074         private
1075         view
1076         returns(uint256)
1077     {
1078         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1079     }
1080     
1081     /** 
1082      * @dev returns the amount of keys you would get given an amount of eth. 
1083      * -functionhash- 0xce89c80c
1084      * @param _rID round ID you want price for
1085      * @param _eth amount of eth sent in 
1086      * @return keys received 
1087      */
1088     function calcKeysReceived(uint256 _rID, uint256 _eth)
1089         public
1090         view
1091         returns(uint256)
1092     {
1093         // grab time
1094         uint256 _now = now;
1095         
1096         // are we in a round?
1097         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1098             return ( (round_[_rID].eth).keysRec(_eth) );
1099         else // rounds over.  need keys for new round
1100             return ( (_eth).keys() );
1101     }
1102     
1103     /** 
1104      * @dev returns current eth price for X keys.  
1105      * -functionhash- 0xcf808000
1106      * @param _keys number of keys desired (in 18 decimal format)
1107      * @return amount of eth needed to send
1108      */
1109     function iWantXKeys(uint256 _keys)
1110         public
1111         view
1112         returns(uint256)
1113     {
1114         // setup local rID
1115         uint256 _rID = rID_;
1116         
1117         // grab time
1118         uint256 _now = now;
1119         
1120         // are we in a round?
1121         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1122             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1123         else // rounds over.  need price for new round
1124             return ( (_keys).eth() );
1125     }
1126     
1127 // Tools
1128     
1129     /**
1130 	 * @dev receives name/player info from names contract 
1131      */
1132     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1133         external
1134     {
1135         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1136         if (pIDxAddr_[_addr] != _pID)
1137             pIDxAddr_[_addr] = _pID;
1138         if (pIDxName_[_name] != _pID)
1139             pIDxName_[_name] = _pID;
1140         if (plyr_[_pID].addr != _addr)
1141             plyr_[_pID].addr = _addr;
1142         if (plyr_[_pID].name != _name)
1143             plyr_[_pID].name = _name;
1144         if (plyr_[_pID].laff != _laff)
1145             plyr_[_pID].laff = _laff;
1146         if (plyrNames_[_pID][_name] == false)
1147             plyrNames_[_pID][_name] = true;
1148     }
1149     
1150     /**
1151      * @dev receives entire player name list 
1152      */
1153     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1154         external
1155     {
1156         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1157         if(plyrNames_[_pID][_name] == false)
1158             plyrNames_[_pID][_name] = true;
1159     }   
1160         
1161     /**
1162      * @dev gets existing or registers new pID.  use this when a player may be new
1163      * @return pID 
1164      */
1165     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1166         private
1167         returns (F3Ddatasets.EventReturns)
1168     {
1169         uint256 _pID = pIDxAddr_[msg.sender];
1170         // if player is new to this version of fomo3d
1171         if (_pID == 0)
1172         {
1173             // grab their player ID, name and last aff ID, from player names contract 
1174             _pID = PlayerBook.getPlayerID(msg.sender);
1175             bytes32 _name = PlayerBook.getPlayerName(_pID);
1176             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1177             
1178             // set up player account 
1179             pIDxAddr_[msg.sender] = _pID;
1180             plyr_[_pID].addr = msg.sender;
1181             
1182             if (_name != "")
1183             {
1184                 pIDxName_[_name] = _pID;
1185                 plyr_[_pID].name = _name;
1186                 plyrNames_[_pID][_name] = true;
1187             }
1188             
1189             if (_laff != 0 && _laff != _pID)
1190                 plyr_[_pID].laff = _laff;
1191             
1192             // set the new player bool to true
1193             _eventData_.compressedData = _eventData_.compressedData + 1;
1194         } 
1195         return (_eventData_);
1196     }
1197     
1198     /**
1199      * @dev checks to make sure user picked a valid team.  if not sets team 
1200      * to default (sneks)
1201      */
1202     function verifyTeam(uint256 _team)
1203         private
1204         pure
1205         returns (uint256)
1206     {
1207         if (_team < 0 || _team > 3)
1208             return(2);
1209         else
1210             return(_team);
1211     }
1212     
1213     /**
1214      * @dev decides if round end needs to be run & new round started.  and if 
1215      * player unmasked earnings from previously played rounds need to be moved.
1216      */
1217     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1218         private
1219         returns (F3Ddatasets.EventReturns)
1220     {
1221         // if player has played a previous round, move their unmasked earnings
1222         // from that round to gen vault.
1223         if (plyr_[_pID].lrnd != 0)
1224             updateGenVault(_pID, plyr_[_pID].lrnd);
1225             
1226         // update player's last round played
1227         plyr_[_pID].lrnd = rID_;
1228             
1229         // set the joined round bool to true
1230         _eventData_.compressedData = _eventData_.compressedData + 10;
1231         
1232         return(_eventData_);
1233     }
1234     
1235     /**
1236      * @dev ends the round. manages paying out winner/splitting up pot
1237      */
1238     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1239         private
1240         returns (F3Ddatasets.EventReturns)
1241     {
1242         // setup local rID
1243         uint256 _rID = rID_;
1244         
1245         // grab our winning player and team id's
1246         uint256 _winPID = round_[_rID].plyr;
1247         uint256 _winTID = round_[_rID].team;
1248         
1249         // grab our pot amount
1250         uint256 _pot = round_[_rID].pot;
1251         
1252         // calculate our winner share, community rewards, gen share, 
1253         // p3d share, and amount reserved for next pot 
1254         uint256 _win = (_pot.mul(48)) / 100;
1255         uint256 _com = (_pot / 50);
1256         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1257         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1258         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1259         
1260         // calculate ppt for round mask
1261         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1262         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1263         if (_dust > 0)
1264         {
1265             _gen = _gen.sub(_dust);
1266             _res = _res.add(_dust);
1267         }
1268         
1269         // pay our winner
1270         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1271         
1272         FeeAddr.transfer(_com);
1273         
1274         // distribute gen portion to key holders
1275         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1276         
1277         // send share for p3d to divies
1278         if (_p3d > 0)
1279             Divies.deposit.value(_p3d)();
1280             
1281         // prepare event data
1282         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1283         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1284         _eventData_.winnerAddr = plyr_[_winPID].addr;
1285         _eventData_.winnerName = plyr_[_winPID].name;
1286         _eventData_.amountWon = _win;
1287         _eventData_.genAmount = _gen;
1288         _eventData_.P3DAmount = _p3d;
1289         _eventData_.newPot = _res;
1290         
1291         // start next round
1292         rID_++;
1293         _rID++;
1294         round_[_rID].strt = now;
1295         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1296         round_[_rID].pot = _res;
1297         
1298         return(_eventData_);
1299     }
1300     
1301     /**
1302      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1303      */
1304     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1305         private 
1306     {
1307         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1308         if (_earnings > 0)
1309         {
1310             // put in gen vault
1311             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1312             // zero out their earnings by updating mask
1313             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1314         }
1315     }
1316     
1317     /**
1318      * @dev updates round timer based on number of whole keys bought.
1319      */
1320     function updateTimer(uint256 _keys, uint256 _rID)
1321         private
1322     {
1323         // grab time
1324         uint256 _now = now;
1325         
1326         // calculate time based on number of keys bought
1327         uint256 _newTime;
1328         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1329             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1330         else
1331             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1332         
1333         // compare to max and set new end time
1334         if (_newTime < (rndMax_).add(_now))
1335             round_[_rID].end = _newTime;
1336         else
1337             round_[_rID].end = rndMax_.add(_now);
1338     }
1339     
1340     /**
1341      * @dev generates a random number between 0-99 and checks to see if thats
1342      * resulted in an airdrop win
1343      * @return do we have a winner?
1344      */
1345     function airdrop()
1346         private 
1347         view 
1348         returns(bool)
1349     {
1350         uint256 seed = uint256(keccak256(abi.encodePacked(
1351             
1352             (block.timestamp).add
1353             (block.difficulty).add
1354             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1355             (block.gaslimit).add
1356             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1357             (block.number)
1358             
1359         )));
1360         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1361             return(true);
1362         else
1363             return(false);
1364     }
1365 
1366     /**
1367      * @dev distributes eth based on fees to com, aff, and p3d
1368      */
1369     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1370         private
1371         returns(F3Ddatasets.EventReturns)
1372     {
1373         // pay 2% out to community rewards
1374         uint256 _com = _eth / 50;
1375 
1376         FeeAddr.transfer(_com);
1377 
1378         uint256 _p3d;
1379         //address(Jekyll_Island_Inc).deposit.value(_com)(); // always returns true or reverts;
1380         /*
1381         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1382         {
1383             // This ensures Team Just cannot influence the outcome of FoMo3D with
1384             // bank migrations by breaking outgoing transactions.
1385             // Something we would never do. But that's not the point.
1386             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1387             // highest belief that everything we create should be trustless.
1388             // Team JUST, The name you shouldn't have to trust.
1389             _p3d = _com;
1390             _com = 0;
1391         }*/
1392         
1393         // pay 1% out to FoMo3D short
1394         //uint256 _long = _eth / 100;
1395         //otherF3D_.potSwap.value(_long)();
1396         
1397         // distribute share to affiliate
1398         uint256 _aff = _eth / 10; //
1399         
1400         // decide what to do with affiliate share of fees
1401         // affiliate must not be self, and must have a name registered
1402         if (_affID != _pID && plyr_[_affID].name != '') {
1403             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1404             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1405         } else {
1406             _p3d = _aff;
1407         }
1408         
1409         // pay out p3d
1410         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1411 
1412         if (_p3d > 0)
1413         {
1414             // deposit to divies contract
1415             //Divies.deposit.value(_p3d.add(_com))();
1416             Divies.deposit.value(_p3d)();
1417             
1418             // set up event data
1419             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1420         }
1421         
1422         return(_eventData_);
1423     }
1424     
1425     function potSwap()
1426         external
1427         payable
1428     {
1429         // setup local rID
1430         uint256 _rID = rID_ + 1;
1431         
1432         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1433         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1434     }
1435     
1436     /**
1437      * @dev distributes eth based on fees to gen and pot
1438      */
1439     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1440         private
1441         returns(F3Ddatasets.EventReturns)
1442     {
1443         // calculate gen share
1444         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1445         
1446         // toss 2% into airdrop pot [this 1% comes from removing the f3d potsplit to the short f3d]
1447         uint256 _air = (_eth.mul(2) / 100);
1448         airDropPot_ = airDropPot_.add(_air);
1449         
1450         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1451         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1452         
1453         // calculate pot 
1454         uint256 _pot = _eth.sub(_gen);
1455         
1456         // distribute gen share (thats what updateMasks() does) and adjust
1457         // balances for dust.
1458         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1459         if (_dust > 0)
1460             _gen = _gen.sub(_dust);
1461         
1462         // add eth to pot
1463         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1464         
1465         // set up event data
1466         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1467         _eventData_.potAmount = _pot;
1468         
1469         return(_eventData_);
1470     }
1471 
1472     /**
1473      * @dev updates masks for round and player when keys are bought
1474      * @return dust left over 
1475      */
1476     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1477         private
1478         returns(uint256)
1479     {
1480         /* MASKING NOTES
1481             earnings masks are a tricky thing for people to wrap their minds around.
1482             the basic thing to understand here.  is were going to have a global
1483             tracker based on profit per share for each round, that increases in
1484             relevant proportion to the increase in share supply.
1485             
1486             the player will have an additional mask that basically says "based
1487             on the rounds mask, my shares, and how much i've already withdrawn,
1488             how much is still owed to me?"
1489         */
1490         
1491         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1492         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1493         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1494             
1495         // calculate player earning from their own buy (only based on the keys
1496         // they just bought).  & update player earnings mask
1497         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1498         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1499         
1500         // calculate & return dust
1501         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1502     }
1503     
1504     /**
1505      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1506      * @return earnings in wei format
1507      */
1508     function withdrawEarnings(uint256 _pID)
1509         private
1510         returns(uint256)
1511     {
1512         // update gen vault
1513         updateGenVault(_pID, plyr_[_pID].lrnd);
1514         
1515         // from vaults 
1516         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1517         if (_earnings > 0)
1518         {
1519             plyr_[_pID].win = 0;
1520             plyr_[_pID].gen = 0;
1521             plyr_[_pID].aff = 0;
1522         }
1523 
1524         return(_earnings);
1525     }
1526     
1527     /**
1528      * @dev prepares compression data and fires event for buy or reload tx's
1529      */
1530     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1531         private
1532     {
1533         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1534         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1535         
1536         emit F3Devents.onEndTx
1537         (
1538             _eventData_.compressedData,
1539             _eventData_.compressedIDs,
1540             plyr_[_pID].name,
1541             msg.sender,
1542             _eth,
1543             _keys,
1544             _eventData_.winnerAddr,
1545             _eventData_.winnerName,
1546             _eventData_.amountWon,
1547             _eventData_.newPot,
1548             _eventData_.P3DAmount,
1549             _eventData_.genAmount,
1550             _eventData_.potAmount,
1551             airDropPot_
1552         );
1553     }
1554 
1555 // Security
1556     
1557     /** upon contract deploy, it will be deactivated.  this is a one time
1558      * use function that will activate the contract.  we do this so devs 
1559      * have time to set things up on the web end                            **/
1560     bool public activated_ = false;
1561     function activate()
1562         public
1563     {
1564         // only team just can activate 
1565         require(
1566             msg.sender == 0x11e52c75998fe2E7928B191bfc5B25937Ca16741,
1567             "only team zethr can activate"
1568         );
1569 
1570 		// make sure that its been linked.
1571         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1572         
1573         // can only be ran once
1574         require(activated_ == false, "fomo3d already activated");
1575         
1576         // activate the contract 
1577         activated_ = true;
1578         
1579         // lets start first round
1580 		rID_ = 1;
1581         round_[1].strt = now + rndExtra_ - rndGap_;
1582         round_[1].end = now + rndInit_ + rndExtra_;
1583     }
1584 
1585 }
1586 
1587 // Structs
1588 
1589 library F3Ddatasets {
1590     //compressedData key
1591     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1592         // 0 - new player (bool)
1593         // 1 - joined round (bool)
1594         // 2 - new  leader (bool)
1595         // 3-5 - air drop tracker (uint 0-999)
1596         // 6-16 - round end time
1597         // 17 - winnerTeam
1598         // 18 - 28 timestamp 
1599         // 29 - team
1600         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1601         // 31 - airdrop happened bool
1602         // 32 - airdrop tier 
1603         // 33 - airdrop amount won
1604     //compressedIDs key
1605     // [77-52][51-26][25-0]
1606         // 0-25 - pID 
1607         // 26-51 - winPID
1608         // 52-77 - rID
1609     struct EventReturns {
1610         uint256 compressedData;
1611         uint256 compressedIDs;
1612         address winnerAddr;         // winner address
1613         bytes32 winnerName;         // winner name
1614         uint256 amountWon;          // amount won
1615         uint256 newPot;             // amount in new pot
1616         uint256 P3DAmount;          // amount distributed to p3d
1617         uint256 genAmount;          // amount distributed to gen
1618         uint256 potAmount;          // amount added to pot
1619     }
1620     struct Player {
1621         address addr;   // player address
1622         bytes32 name;   // player name
1623         uint256 win;    // winnings vault
1624         uint256 gen;    // general vault
1625         uint256 aff;    // affiliate vault
1626         uint256 lrnd;   // last round played
1627         uint256 laff;   // last affiliate id used
1628     }
1629     struct PlayerRounds {
1630         uint256 eth;    // eth player has added to round (used for eth limiter)
1631         uint256 keys;   // keys
1632         uint256 mask;   // player mask 
1633         uint256 ico;    // ICO phase investment
1634     }
1635     struct Round {
1636         uint256 plyr;   // pID of player in lead
1637         uint256 team;   // tID of team in lead
1638         uint256 end;    // time ends/ended
1639         bool ended;     // has round end function been ran
1640         uint256 strt;   // time round started
1641         uint256 keys;   // keys
1642         uint256 eth;    // total eth in
1643         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1644         uint256 mask;   // global mask
1645         uint256 ico;    // total eth sent in during ICO phase
1646         uint256 icoGen; // total eth for gen during ICO phase
1647         uint256 icoAvg; // average key price for ICO phase
1648     }
1649     struct TeamFee {
1650         uint256 gen;    // % of buy in thats paid to key holders of current round
1651         uint256 p3d;    // % of buy in thats paid to p3d holders
1652     }
1653     struct PotSplit {
1654         uint256 gen;    // % of pot thats paid to key holders of current round
1655         uint256 p3d;    // % of pot thats paid to p3d holders
1656     }
1657 }
1658 
1659 // Key Calculations
1660 
1661 library F3DKeysCalcLong {
1662     using SafeMath for *;
1663     /**
1664      * @dev calculates number of keys received given X eth 
1665      * @param _curEth current amount of eth in contract 
1666      * @param _newEth eth being spent
1667      * @return amount of ticket purchased
1668      */
1669     function keysRec(uint256 _curEth, uint256 _newEth)
1670         internal
1671         pure
1672         returns (uint256)
1673     {
1674         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1675     }
1676     
1677     /**
1678      * @dev calculates amount of eth received if you sold X keys 
1679      * @param _curKeys current amount of keys that exist 
1680      * @param _sellKeys amount of keys you wish to sell
1681      * @return amount of eth received
1682      */
1683     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1684         internal
1685         pure
1686         returns (uint256)
1687     {
1688         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1689     }
1690 
1691     /**
1692      * @dev calculates how many keys would exist with given an amount of eth
1693      * @param _eth eth "in contract"
1694      * @return number of keys that would exist
1695      */
1696     function keys(uint256 _eth)
1697         internal
1698         pure
1699         returns(uint256)
1700     {
1701         return (((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000)) / 50;
1702     }
1703 
1704     /**
1705      * @dev calculates how much eth would be in contract given a number of keys
1706      * @param _keys number of keys "in contract"
1707      * @return eth that would exists
1708      */
1709     function eth(uint256 _keys)
1710         internal
1711         pure
1712         returns(uint256)
1713     {
1714         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq()) * 50;
1715     }
1716 }
1717 
1718 // Interfaces
1719 
1720 interface otherFoMo3D {
1721     function potSwap() external payable;
1722 }
1723 
1724 interface F3DexternalSettingsInterface {
1725     function getFastGap() external returns(uint256);
1726     function getLongGap() external returns(uint256);
1727     function getFastExtra() external returns(uint256);
1728     function getLongExtra() external returns(uint256);
1729 }
1730 
1731 interface JIincForwarderInterface {
1732     function deposit() external payable;
1733     function status() external view returns(address, address, bool);
1734     function startMigration(address _newCorpBank) external returns(bool);
1735     function cancelMigration() external returns(bool);
1736     function finishMigration() external returns(bool);
1737     function setup(address _firstCorpBank) external;
1738 }
1739 
1740 interface PlayerBookInterface {
1741     function getPlayerID(address _addr) external returns (uint256);
1742     function getPlayerName(uint256 _pID) external view returns (bytes32);
1743     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1744     function getPlayerAddr(uint256 _pID) external view returns (address);
1745     function getNameFee() external view returns (uint256);
1746     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1747     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1748     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1749 }
1750 
1751 library NameFilter {
1752     /**
1753      * @dev filters name strings
1754      * -converts uppercase to lower case.  
1755      * -makes sure it does not start/end with a space
1756      * -makes sure it does not contain multiple spaces in a row
1757      * -cannot be only numbers
1758      * -cannot start with 0x 
1759      * -restricts characters to A-Z, a-z, 0-9, and space.
1760      * @return reprocessed string in bytes32 format
1761      */
1762     function nameFilter(string _input)
1763         internal
1764         pure
1765         returns(bytes32)
1766     {
1767         bytes memory _temp = bytes(_input);
1768         uint256 _length = _temp.length;
1769         
1770         //sorry limited to 32 characters
1771         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1772         // make sure it doesnt start with or end with space
1773         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1774         // make sure first two characters are not 0x
1775         if (_temp[0] == 0x30)
1776         {
1777             require(_temp[1] != 0x78, "string cannot start with 0x");
1778             require(_temp[1] != 0x58, "string cannot start with 0X");
1779         }
1780         
1781         // create a bool to track if we have a non number character
1782         bool _hasNonNumber;
1783         
1784         // convert & check
1785         for (uint256 i = 0; i < _length; i++)
1786         {
1787             // if its uppercase A-Z
1788             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1789             {
1790                 // convert to lower case a-z
1791                 _temp[i] = byte(uint(_temp[i]) + 32);
1792                 
1793                 // we have a non number
1794                 if (_hasNonNumber == false)
1795                     _hasNonNumber = true;
1796             } else {
1797                 require
1798                 (
1799                     // require character is a space
1800                     _temp[i] == 0x20 || 
1801                     // OR lowercase a-z
1802                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1803                     // or 0-9
1804                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1805                     "string contains invalid characters"
1806                 );
1807                 // make sure theres not 2x spaces in a row
1808                 if (_temp[i] == 0x20)
1809                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1810                 
1811                 // see if we have a character other than a number
1812                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1813                     _hasNonNumber = true;    
1814             }
1815         }
1816         
1817         require(_hasNonNumber == true, "string cannot be only numbers");
1818         
1819         bytes32 _ret;
1820         assembly {
1821             _ret := mload(add(_temp, 32))
1822         }
1823         return (_ret);
1824     }
1825 }
1826 
1827 /**
1828  * @title SafeMath v0.1.9
1829  * @dev Math operations with safety checks that throw on error
1830  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1831  * - added sqrt
1832  * - added sq
1833  * - added pwr 
1834  * - changed asserts to requires with error log outputs
1835  * - removed div, its useless
1836  */
1837 library SafeMath {
1838     
1839     /**
1840     * @dev Multiplies two numbers, throws on overflow.
1841     */
1842     function mul(uint256 a, uint256 b) 
1843         internal 
1844         pure 
1845         returns (uint256 c) 
1846     {
1847         if (a == 0) {
1848             return 0;
1849         }
1850         c = a * b;
1851         require(c / a == b, "SafeMath mul failed");
1852         return c;
1853     }
1854 
1855     /**
1856     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1857     */
1858     function sub(uint256 a, uint256 b)
1859         internal
1860         pure
1861         returns (uint256) 
1862     {
1863         require(b <= a, "SafeMath sub failed");
1864         return a - b;
1865     }
1866 
1867     /**
1868     * @dev Adds two numbers, throws on overflow.
1869     */
1870     function add(uint256 a, uint256 b)
1871         internal
1872         pure
1873         returns (uint256 c) 
1874     {
1875         c = a + b;
1876         require(c >= a, "SafeMath add failed");
1877         return c;
1878     }
1879     
1880     /**
1881      * @dev gives square root of given x.
1882      */
1883     function sqrt(uint256 x)
1884         internal
1885         pure
1886         returns (uint256 y) 
1887     {
1888         uint256 z = ((add(x,1)) / 2);
1889         y = x;
1890         while (z < y) 
1891         {
1892             y = z;
1893             z = ((add((x / z),z)) / 2);
1894         }
1895     }
1896     
1897     /**
1898      * @dev gives square. multiplies x by x
1899      */
1900     function sq(uint256 x)
1901         internal
1902         pure
1903         returns (uint256)
1904     {
1905         return (mul(x,x));
1906     }
1907     
1908     /**
1909      * @dev x to the power of y 
1910      */
1911     function pwr(uint256 x, uint256 y)
1912         internal 
1913         pure 
1914         returns (uint256)
1915     {
1916         if (x==0)
1917             return (0);
1918         else if (y==0)
1919             return (1);
1920         else 
1921         {
1922             uint256 z = x;
1923             for (uint256 i=1; i < y; i++)
1924                 z = mul(z,x);
1925             return (z);
1926         }
1927     }
1928 }