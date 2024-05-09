1 pragma solidity ^0.4.24;
2 
3 
4 // Events 
5 
6 contract F3Devents {
7     // fired whenever a player registers a name
8     event onNewName
9     (
10         uint256 indexed playerID,
11         address indexed playerAddress,
12         bytes32 indexed playerName,
13         bool isNewPlayer,
14         uint256 affiliateID,
15         address affiliateAddress,
16         bytes32 affiliateName,
17         uint256 amountPaid,
18         uint256 timeStamp
19     );
20     
21     // fired at end of buy or reload
22     event onEndTx
23     (
24         uint256 compressedData,     
25         uint256 compressedIDs,      
26         bytes32 playerName,
27         address playerAddress,
28         uint256 ethIn,
29         uint256 keysBought,
30         address winnerAddr,
31         bytes32 winnerName,
32         uint256 amountWon,
33         uint256 newPot,
34         uint256 P3DAmount,
35         uint256 genAmount,
36         uint256 potAmount,
37         uint256 airDropPot
38     );
39     
40     // fired whenever theres a withdraw
41     event onWithdraw
42     (
43         uint256 indexed playerID,
44         address playerAddress,
45         bytes32 playerName,
46         uint256 ethOut,
47         uint256 timeStamp
48     );
49     
50     // fired whenever a withdraw forces end round to be ran
51     event onWithdrawAndDistribute
52     (
53         address playerAddress,
54         bytes32 playerName,
55         uint256 ethOut,
56         uint256 compressedData,
57         uint256 compressedIDs,
58         address winnerAddr,
59         bytes32 winnerName,
60         uint256 amountWon,
61         uint256 newPot,
62         uint256 P3DAmount,
63         uint256 genAmount
64     );
65     
66     // (fomo3d long only) fired whenever a player tries a buy after round timer 
67     // hit zero, and causes end round to be ran.
68     event onBuyAndDistribute
69     (
70         address playerAddress,
71         bytes32 playerName,
72         uint256 ethIn,
73         uint256 compressedData,
74         uint256 compressedIDs,
75         address winnerAddr,
76         bytes32 winnerName,
77         uint256 amountWon,
78         uint256 newPot,
79         uint256 P3DAmount,
80         uint256 genAmount
81     );
82     
83     // (fomo3d long only) fired whenever a player tries a reload after round timer 
84     // hit zero, and causes end round to be ran.
85     event onReLoadAndDistribute
86     (
87         address playerAddress,
88         bytes32 playerName,
89         uint256 compressedData,
90         uint256 compressedIDs,
91         address winnerAddr,
92         bytes32 winnerName,
93         uint256 amountWon,
94         uint256 newPot,
95         uint256 P3DAmount,
96         uint256 genAmount
97     );
98     
99     // fired whenever an affiliate is paid
100     event onAffiliatePayout
101     (
102         uint256 indexed affiliateID,
103         address affiliateAddress,
104         bytes32 affiliateName,
105         uint256 indexed roundID,
106         uint256 indexed buyerID,
107         uint256 amount,
108         uint256 timeStamp
109     );
110     
111     // received pot swap deposit
112     event onPotSwapDeposit
113     (
114         uint256 roundID,
115         uint256 amountAddedToPot
116     );
117 }
118 
119 
120 // Contract Setup
121 
122 contract modularLong is F3Devents {}
123 
124 contract DiviesCTR {
125     function deposit() public payable;
126 }
127 
128 contract FoMo3Dlong is modularLong {
129     using SafeMath for *;
130     using NameFilter for string;
131     using F3DKeysCalcLong for uint256;
132     
133     otherFoMo3D private otherF3D_;
134     DiviesCTR constant private Divies = DiviesCTR(0x3b4F4505E644ae36FD0d3223Af9b0BAC1C49e656);
135     address constant private FeeAddr = 0x8d35c3edFc1A8f2564fd00561Fb0A8423D5B8b44;
136     //address constant private Jekyll_Island_Inc = Divies;//(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
137     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x76f48aa7411437d3B81bea31525b30E707D60aE9);
138     //F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
139 
140     
141 // Game Settings
142 
143     string constant public name = "HoDL4D";
144     string constant public symbol = "H4D";
145     uint256 private rndExtra_ = 30 seconds;//extSettings.getLongExtra();     // length of the very first ICO 
146     uint256 private rndGap_ = 3 minutes; //extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
147     uint256 constant private rndInit_ = 3 hours;                // round timer starts at this
148     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
149     uint256 constant private rndMax_ = 3 hours;                // max length a round timer can be
150 
151 // Data Settings
152 
153     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
154     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
155     uint256 public rID_;    // round id number / total rounds that have happened
156     
157 
158 // Player Data
159 
160     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
161     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
162     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
163     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
164     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
165 
166 // Round Data
167 
168     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
169     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
170 
171 // Team Fee Data
172     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
173     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
174 
175 // Constructor
176 
177     constructor()
178         public
179     {
180         // Team allocation structures
181         // 0 = whales
182         // 1 = bears
183         // 2 = sneks
184         // 3 = bulls
185 
186         // Team allocation percentages
187         // (F3D, P3D) + (Pot , Referrals, Community)
188             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
189         fees_[0] = F3Ddatasets.TeamFee(56,10);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
190         fees_[1] = F3Ddatasets.TeamFee(56,10);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
191         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
192         fees_[3] = F3Ddatasets.TeamFee(56,10);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
193         
194         // how to split up the final pot based on which team was picked
195         // (F3D, P3D)
196         potSplit_[0] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 25% to next round, 2% to com
197         potSplit_[1] = F3Ddatasets.PotSplit(20,20);   //48% to winner, 25% to next round, 2% to com
198         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
199         potSplit_[3] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
200     }
201 
202 // Modules
203 
204     /**
205      * @dev used to make sure no one can interact with contract until it has 
206      * been activated. 
207      */
208     modifier isActivated() {
209         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
210         _;
211     }
212     
213     /**
214      * @dev prevents contracts from interacting with fomo3d 
215      */
216     modifier isHuman() {
217         // *breathes in*
218         // HAHAHAHA
219         //address _addr = msg.sender;
220         //uint256 _codeLength;
221         
222         //assembly {_codeLength := extcodesize(_addr)}
223         //require(_codeLength == 0, "sorry humans only");
224         require(msg.sender == tx.origin, "sorry humans only - FOR REAL THIS TIME");
225         _;
226     }
227 
228     /**
229      * @dev sets boundaries for incoming tx 
230      */
231     modifier isWithinLimits(uint256 _eth) {
232         require(_eth >= 1000000000, "pocket lint: not a valid currency");
233         require(_eth <= 100000000000000000000000, "no vitalik, no");
234         _;    
235     }
236     
237 // Public Functions
238 
239     /**
240      * @dev emergency buy uses last stored affiliate ID and team snek
241      */
242     function()
243         isActivated()
244         isHuman()
245         isWithinLimits(msg.value)
246         public
247         payable
248     {
249         // set up our tx event data and determine if player is new or not
250         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
251             
252         // fetch player id
253         uint256 _pID = pIDxAddr_[msg.sender];
254         
255         // buy core 
256         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
257     }
258     
259     /**
260      * @dev converts all incoming ethereum to keys.
261      * -functionhash- 0x8f38f309 (using ID for affiliate)
262      * -functionhash- 0x98a0871d (using address for affiliate)
263      * -functionhash- 0xa65b37a1 (using name for affiliate)
264      * @param _affCode the ID/address/name of the player who gets the affiliate fee
265      * @param _team what team is the player playing for?
266      */
267     function buyXid(uint256 _affCode, uint256 _team)
268         isActivated()
269         isHuman()
270         isWithinLimits(msg.value)
271         public
272         payable
273     {
274         // set up our tx event data and determine if player is new or not
275         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
276         
277         // fetch player id
278         uint256 _pID = pIDxAddr_[msg.sender];
279         
280         // manage affiliate residuals
281         // if no affiliate code was given or player tried to use their own, lolz
282         if (_affCode == 0 || _affCode == _pID)
283         {
284             // use last stored affiliate code 
285             _affCode = plyr_[_pID].laff;
286             
287         // if affiliate code was given & its not the same as previously stored 
288         } else if (_affCode != plyr_[_pID].laff) {
289             // update last affiliate 
290             plyr_[_pID].laff = _affCode;
291         }
292         
293         // verify a valid team was selected
294         _team = verifyTeam(_team);
295         
296         // buy core 
297         buyCore(_pID, _affCode, _team, _eventData_);
298     }
299     
300     function buyXaddr(address _affCode, uint256 _team)
301         isActivated()
302         isHuman()
303         isWithinLimits(msg.value)
304         public
305         payable
306     {
307         // set up our tx event data and determine if player is new or not
308         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
309         
310         // fetch player id
311         uint256 _pID = pIDxAddr_[msg.sender];
312         
313         // manage affiliate residuals
314         uint256 _affID;
315         // if no affiliate code was given or player tried to use their own, lolz
316         if (_affCode == address(0) || _affCode == msg.sender)
317         {
318             // use last stored affiliate code
319             _affID = plyr_[_pID].laff;
320         
321         // if affiliate code was given    
322         } else {
323             // get affiliate ID from aff Code 
324             _affID = pIDxAddr_[_affCode];
325             
326             // if affID is not the same as previously stored 
327             if (_affID != plyr_[_pID].laff)
328             {
329                 // update last affiliate
330                 plyr_[_pID].laff = _affID;
331             }
332         }
333         
334         // verify a valid team was selected
335         _team = verifyTeam(_team);
336         
337         // buy core 
338         buyCore(_pID, _affID, _team, _eventData_);
339     }
340     
341     function buyXname(bytes32 _affCode, uint256 _team)
342         isActivated()
343         isHuman()
344         isWithinLimits(msg.value)
345         public
346         payable
347     {
348         // set up our tx event data and determine if player is new or not
349         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
350         
351         // fetch player id
352         uint256 _pID = pIDxAddr_[msg.sender];
353         
354         // manage affiliate residuals
355         uint256 _affID;
356         // if no affiliate code was given or player tried to use their own, lolz
357         if (_affCode == '' || _affCode == plyr_[_pID].name)
358         {
359             // use last stored affiliate code
360             _affID = plyr_[_pID].laff;
361         
362         // if affiliate code was given
363         } else {
364             // get affiliate ID from aff Code
365             _affID = pIDxName_[_affCode];
366             
367             // if affID is not the same as previously stored
368             if (_affID != plyr_[_pID].laff)
369             {
370                 // update last affiliate
371                 plyr_[_pID].laff = _affID;
372             }
373         }
374         
375         // verify a valid team was selected
376         _team = verifyTeam(_team);
377         
378         // buy core 
379         buyCore(_pID, _affID, _team, _eventData_);
380     }
381     
382     /**
383      * @dev essentially the same as buy, but instead of you sending ether 
384      * from your wallet, it uses your unwithdrawn earnings.
385      * -functionhash- 0x349cdcac (using ID for affiliate)
386      * -functionhash- 0x82bfc739 (using address for affiliate)
387      * -functionhash- 0x079ce327 (using name for affiliate)
388      * @param _affCode the ID/address/name of the player who gets the affiliate fee
389      * @param _team what team is the player playing for?
390      * @param _eth amount of earnings to use (remainder returned to gen vault)
391      */
392     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
393         isActivated()
394         isHuman()
395         isWithinLimits(_eth)
396         public
397     {
398         // set up our tx event data
399         F3Ddatasets.EventReturns memory _eventData_;
400         
401         // fetch player ID
402         uint256 _pID = pIDxAddr_[msg.sender];
403         
404         // manage affiliate residuals
405         // if no affiliate code was given or player tried to use their own, lolz
406         if (_affCode == 0 || _affCode == _pID)
407         {
408             // use last stored affiliate code 
409             _affCode = plyr_[_pID].laff;
410             
411         // if affiliate code was given & its not the same as previously stored 
412         } else if (_affCode != plyr_[_pID].laff) {
413             // update last affiliate 
414             plyr_[_pID].laff = _affCode;
415         }
416 
417         // verify a valid team was selected
418         _team = verifyTeam(_team);
419 
420         // reload core
421         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
422     }
423     
424     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
425         isActivated()
426         isHuman()
427         isWithinLimits(_eth)
428         public
429     {
430         // set up our tx event data
431         F3Ddatasets.EventReturns memory _eventData_;
432         
433         // fetch player ID
434         uint256 _pID = pIDxAddr_[msg.sender];
435         
436         // manage affiliate residuals
437         uint256 _affID;
438         // if no affiliate code was given or player tried to use their own, lolz
439         if (_affCode == address(0) || _affCode == msg.sender)
440         {
441             // use last stored affiliate code
442             _affID = plyr_[_pID].laff;
443         
444         // if affiliate code was given    
445         } else {
446             // get affiliate ID from aff Code 
447             _affID = pIDxAddr_[_affCode];
448             
449             // if affID is not the same as previously stored 
450             if (_affID != plyr_[_pID].laff)
451             {
452                 // update last affiliate
453                 plyr_[_pID].laff = _affID;
454             }
455         }
456         
457         // verify a valid team was selected
458         _team = verifyTeam(_team);
459         
460         // reload core
461         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
462     }
463     
464     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
465         isActivated()
466         isHuman()
467         isWithinLimits(_eth)
468         public
469     {
470         // set up our tx event data
471         F3Ddatasets.EventReturns memory _eventData_;
472         
473         // fetch player ID
474         uint256 _pID = pIDxAddr_[msg.sender];
475         
476         // manage affiliate residuals
477         uint256 _affID;
478         // if no affiliate code was given or player tried to use their own, lolz
479         if (_affCode == '' || _affCode == plyr_[_pID].name)
480         {
481             // use last stored affiliate code
482             _affID = plyr_[_pID].laff;
483         
484         // if affiliate code was given
485         } else {
486             // get affiliate ID from aff Code
487             _affID = pIDxName_[_affCode];
488             
489             // if affID is not the same as previously stored
490             if (_affID != plyr_[_pID].laff)
491             {
492                 // update last affiliate
493                 plyr_[_pID].laff = _affID;
494             }
495         }
496         
497         // verify a valid team was selected
498         _team = verifyTeam(_team);
499         
500         // reload core
501         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
502     }
503 
504     /**
505      * @dev withdraws all of your earnings.
506      * -functionhash- 0x3ccfd60b
507      */
508     function withdraw()
509         isActivated()
510         isHuman()
511         public
512     {
513         // setup local rID 
514         uint256 _rID = rID_;
515         
516         // grab time
517         uint256 _now = now;
518         
519         // fetch player ID
520         uint256 _pID = pIDxAddr_[msg.sender];
521         
522         // setup temp var for player eth
523         uint256 _eth;
524         
525         // check to see if round has ended and no one has run round end yet
526         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
527         {
528             // set up our tx event data
529             F3Ddatasets.EventReturns memory _eventData_;
530             
531             // end the round (distributes pot)
532             round_[_rID].ended = true;
533             _eventData_ = endRound(_eventData_);
534             
535             // get their earnings
536             _eth = withdrawEarnings(_pID);
537             
538             // gib moni
539             if (_eth > 0)
540                 plyr_[_pID].addr.transfer(_eth);    
541             
542             // build event data
543             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
544             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
545             
546             // fire withdraw and distribute event
547             emit F3Devents.onWithdrawAndDistribute
548             (
549                 msg.sender, 
550                 plyr_[_pID].name, 
551                 _eth, 
552                 _eventData_.compressedData, 
553                 _eventData_.compressedIDs, 
554                 _eventData_.winnerAddr, 
555                 _eventData_.winnerName, 
556                 _eventData_.amountWon, 
557                 _eventData_.newPot, 
558                 _eventData_.P3DAmount, 
559                 _eventData_.genAmount
560             );
561             
562         // in any other situation
563         } else {
564             // get their earnings
565             _eth = withdrawEarnings(_pID);
566             
567             // gib moni
568             if (_eth > 0)
569                 plyr_[_pID].addr.transfer(_eth);
570             
571             // fire withdraw event
572             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
573         }
574     }
575     
576     /**
577      * @dev use these to register names.  they are just wrappers that will send the
578      * registration requests to the PlayerBook contract.  So registering here is the 
579      * same as registering there.  UI will always display the last name you registered.
580      * but you will still own all previously registered names to use as affiliate 
581      * links.
582      * - must pay a registration fee.
583      * - name must be unique
584      * - names will be converted to lowercase
585      * - name cannot start or end with a space 
586      * - cannot have more than 1 space in a row
587      * - cannot be only numbers
588      * - cannot start with 0x 
589      * - name must be at least 1 char
590      * - max length of 32 characters long
591      * - allowed characters: a-z, 0-9, and space
592      * -functionhash- 0x921dec21 (using ID for affiliate)
593      * -functionhash- 0x3ddd4698 (using address for affiliate)
594      * -functionhash- 0x685ffd83 (using name for affiliate)
595      * @param _nameString players desired name
596      * @param _affCode affiliate ID, address, or name of who referred you
597      * @param _all set to true if you want this to push your info to all games 
598      * (this might cost a lot of gas)
599      */
600     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
601         isHuman()
602         public
603         payable
604     {
605         bytes32 _name = _nameString.nameFilter();
606         address _addr = msg.sender;
607         uint256 _paid = msg.value;
608         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
609         
610         uint256 _pID = pIDxAddr_[_addr];
611         
612         // fire event
613         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
614     }
615     
616     function registerNameXaddr(string _nameString, address _affCode, bool _all)
617         isHuman()
618         public
619         payable
620     {
621         bytes32 _name = _nameString.nameFilter();
622         address _addr = msg.sender;
623         uint256 _paid = msg.value;
624         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
625         
626         uint256 _pID = pIDxAddr_[_addr];
627         
628         // fire event
629         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
630     }
631     
632     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
633         isHuman()
634         public
635         payable
636     {
637         bytes32 _name = _nameString.nameFilter();
638         address _addr = msg.sender;
639         uint256 _paid = msg.value;
640         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
641         
642         uint256 _pID = pIDxAddr_[_addr];
643         
644         // fire event
645         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
646     }
647 
648 // Getters    
649 
650     /**
651      * @dev return the price buyer will pay for next 1 individual key.
652      * -functionhash- 0x018a25e8
653      * @return price for next key bought (in wei format)
654      */
655     function getBuyPrice()
656         public 
657         view 
658         returns(uint256)
659     {  
660         // setup local rID
661         uint256 _rID = rID_;
662         
663         // grab time
664         uint256 _now = now;
665         
666         // are we in a round?
667         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
668             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
669         else // rounds over.  need price for new round
670             return ( 75000000000000 ); // init
671     }
672     
673     /**
674      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
675      * provider
676      * -functionhash- 0xc7e284b8
677      * @return time left in seconds
678      */
679     function getTimeLeft()
680         public
681         view
682         returns(uint256)
683     {
684         // setup local rID
685         uint256 _rID = rID_;
686         
687         // grab time
688         uint256 _now = now;
689         
690         if (_now < round_[_rID].end)
691             if (_now > round_[_rID].strt + rndGap_)
692                 return( (round_[_rID].end).sub(_now) );
693             else
694                 return( (round_[_rID].strt + rndGap_).sub(_now) );
695         else
696             return(0);
697     }
698     
699     /**
700      * @dev returns player earnings per vaults 
701      * -functionhash- 0x63066434
702      * @return winnings vault
703      * @return general vault
704      * @return affiliate vault
705      */
706     function getPlayerVaults(uint256 _pID)
707         public
708         view
709         returns(uint256 ,uint256, uint256)
710     {
711         // setup local rID
712         uint256 _rID = rID_;
713         
714         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
715         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
716         {
717             // if player is winner 
718             if (round_[_rID].plyr == _pID)
719             {
720                 return
721                 (
722                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
723                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
724                     plyr_[_pID].aff
725                 );
726             // if player is not the winner
727             } else {
728                 return
729                 (
730                     plyr_[_pID].win,
731                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
732                     plyr_[_pID].aff
733                 );
734             }
735             
736         // if round is still going on, or round has ended and round end has been ran
737         } else {
738             return
739             (
740                 plyr_[_pID].win,
741                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
742                 plyr_[_pID].aff
743             );
744         }
745     }
746     
747     /**
748      * solidity hates stack limits.  this lets us avoid that hate 
749      */
750     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
751         private
752         view
753         returns(uint256)
754     {
755         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
756     }
757     
758     /**
759      * @dev returns all current round info needed for front end
760      * -functionhash- 0x747dff42
761      * @return eth invested during ICO phase
762      * @return round id 
763      * @return total keys for round 
764      * @return time round ends
765      * @return time round started
766      * @return current pot 
767      * @return current team ID & player ID in lead 
768      * @return current player in leads address 
769      * @return current player in leads name
770      * @return whales eth in for round
771      * @return bears eth in for round
772      * @return sneks eth in for round
773      * @return bulls eth in for round
774      * @return airdrop tracker # & airdrop pot
775      */
776     function getCurrentRoundInfo()
777         public
778         view
779         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
780     {
781         // setup local rID
782         uint256 _rID = rID_;
783         
784         return
785         (
786             round_[_rID].ico,               //0
787             _rID,                           //1
788             round_[_rID].keys,              //2
789             round_[_rID].end,               //3
790             round_[_rID].strt,              //4
791             round_[_rID].pot,               //5
792             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
793             plyr_[round_[_rID].plyr].addr,  //7
794             plyr_[round_[_rID].plyr].name,  //8
795             rndTmEth_[_rID][0],             //9
796             rndTmEth_[_rID][1],             //10
797             rndTmEth_[_rID][2],             //11
798             rndTmEth_[_rID][3],             //12
799             airDropTracker_ + (airDropPot_ * 1000)              //13
800         );
801     }
802 
803     /**
804      * @dev returns player info based on address.  if no address is given, it will 
805      * use msg.sender 
806      * -functionhash- 0xee0b5d8b
807      * @param _addr address of the player you want to lookup 
808      * @return player ID 
809      * @return player name
810      * @return keys owned (current round)
811      * @return winnings vault
812      * @return general vault 
813      * @return affiliate vault 
814      * @return player round eth
815      */
816     function getPlayerInfoByAddress(address _addr)
817         public 
818         view 
819         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
820     {
821         // setup local rID
822         uint256 _rID = rID_;
823         
824         if (_addr == address(0))
825         {
826             _addr == msg.sender;
827         }
828         uint256 _pID = pIDxAddr_[_addr];
829         
830         return
831         (
832             _pID,                               //0
833             plyr_[_pID].name,                   //1
834             plyrRnds_[_pID][_rID].keys,         //2
835             plyr_[_pID].win,                    //3
836             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
837             plyr_[_pID].aff,                    //5
838             plyrRnds_[_pID][_rID].eth           //6
839         );
840     }
841 
842 // Core Logic
843 
844     /**
845      * @dev logic runs whenever a buy order is executed.  determines how to handle 
846      * incoming eth depending on if we are in an active round or not
847      */
848     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
849         private
850     {
851         // setup local rID
852         uint256 _rID = rID_;
853         
854         // grab time
855         uint256 _now = now;
856         
857         // if round is active
858         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
859         {
860             // call core 
861             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
862         
863         // if round is not active     
864         } else {
865             // check to see if end round needs to be ran
866             if (_now > round_[_rID].end && round_[_rID].ended == false) 
867             {
868                 // end the round (distributes pot) & start new round
869                 round_[_rID].ended = true;
870                 _eventData_ = endRound(_eventData_);
871                 
872                 // build event data
873                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
874                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
875                 
876                 // fire buy and distribute event 
877                 emit F3Devents.onBuyAndDistribute
878                 (
879                     msg.sender, 
880                     plyr_[_pID].name, 
881                     msg.value, 
882                     _eventData_.compressedData, 
883                     _eventData_.compressedIDs, 
884                     _eventData_.winnerAddr, 
885                     _eventData_.winnerName, 
886                     _eventData_.amountWon, 
887                     _eventData_.newPot, 
888                     _eventData_.P3DAmount, 
889                     _eventData_.genAmount
890                 );
891             }
892             
893             // put eth in players vault 
894             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
895         }
896     }
897     
898     /**
899      * @dev logic runs whenever a reload order is executed.  determines how to handle 
900      * incoming eth depending on if we are in an active round or not 
901      */
902     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
903         private
904     {
905         // setup local rID
906         uint256 _rID = rID_;
907         
908         // grab time
909         uint256 _now = now;
910         
911         // if round is active
912         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
913         {
914             // get earnings from all vaults and return unused to gen vault
915             // because we use a custom safemath library.  this will throw if player 
916             // tried to spend more eth than they have.
917             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
918             
919             // call core 
920             core(_rID, _pID, _eth, _affID, _team, _eventData_);
921         
922         // if round is not active and end round needs to be ran   
923         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
924             // end the round (distributes pot) & start new round
925             round_[_rID].ended = true;
926             _eventData_ = endRound(_eventData_);
927                 
928             // build event data
929             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
930             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
931                 
932             // fire buy and distribute event 
933             emit F3Devents.onReLoadAndDistribute
934             (
935                 msg.sender, 
936                 plyr_[_pID].name, 
937                 _eventData_.compressedData, 
938                 _eventData_.compressedIDs, 
939                 _eventData_.winnerAddr, 
940                 _eventData_.winnerName, 
941                 _eventData_.amountWon, 
942                 _eventData_.newPot, 
943                 _eventData_.P3DAmount, 
944                 _eventData_.genAmount
945             );
946         }
947     }
948     
949     /**
950      * @dev this is the core logic for any buy/reload that happens while a round 
951      * is live.
952      */
953     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
954         private
955     {
956         // if player is new to round
957         if (plyrRnds_[_pID][_rID].keys == 0)
958             _eventData_ = managePlayer(_pID, _eventData_);
959         
960         // early round eth limiter 
961         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
962         {
963             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
964             uint256 _refund = _eth.sub(_availableLimit);
965             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
966             _eth = _availableLimit;
967         }
968         
969         // if eth left is greater than min eth allowed (sorry no pocket lint)
970         if (_eth > 1000000000) 
971         {
972             
973             // mint the new keys
974             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
975             
976             // if they bought at least 1 whole key
977             if (_keys >= 1000000000000000000)
978             {
979             updateTimer(_keys, _rID);
980 
981             // set new leaders
982             if (round_[_rID].plyr != _pID)
983                 round_[_rID].plyr = _pID;  
984             if (round_[_rID].team != _team)
985                 round_[_rID].team = _team; 
986             
987             // set the new leader bool to true
988             _eventData_.compressedData = _eventData_.compressedData + 100;
989         }
990             
991             // manage airdrops
992             if (_eth >= 100000000000000000)
993             {
994             airDropTracker_++;
995             if (airdrop() == true)
996             {
997                 // gib muni
998                 uint256 _prize;
999                 if (_eth >= 10000000000000000000)
1000                 {
1001                     // calculate prize and give it to winner
1002                     _prize = ((airDropPot_).mul(75)) / 100;
1003                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1004                     
1005                     // adjust airDropPot 
1006                     airDropPot_ = (airDropPot_).sub(_prize);
1007                     
1008                     // let event know a tier 3 prize was won 
1009                     _eventData_.compressedData += 300000000000000000000000000000000;
1010                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1011                     // calculate prize and give it to winner
1012                     _prize = ((airDropPot_).mul(50)) / 100;
1013                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1014                     
1015                     // adjust airDropPot 
1016                     airDropPot_ = (airDropPot_).sub(_prize);
1017                     
1018                     // let event know a tier 2 prize was won 
1019                     _eventData_.compressedData += 200000000000000000000000000000000;
1020                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1021                     // calculate prize and give it to winner
1022                     _prize = ((airDropPot_).mul(25)) / 100;
1023                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1024                     
1025                     // adjust airDropPot 
1026                     airDropPot_ = (airDropPot_).sub(_prize);
1027                     
1028                     // let event know a tier 3 prize was won 
1029                     _eventData_.compressedData += 300000000000000000000000000000000;
1030                 }
1031                 // set airdrop happened bool to true
1032                 _eventData_.compressedData += 10000000000000000000000000000000;
1033                 // let event know how much was won 
1034                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1035                 
1036                 // reset air drop tracker
1037                 airDropTracker_ = 0;
1038             }
1039         }
1040     
1041             // store the air drop tracker number (number of buys since last airdrop)
1042             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1043             
1044             // update player 
1045             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1046             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1047             
1048             // update round
1049             round_[_rID].keys = _keys.add(round_[_rID].keys);
1050             round_[_rID].eth = _eth.add(round_[_rID].eth);
1051             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1052     
1053             // distribute eth
1054             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1055             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1056             
1057             // call end tx function to fire end tx event.
1058             endTx(_pID, _team, _eth, _keys, _eventData_);
1059         }
1060     }
1061 
1062 // Calculators
1063     
1064     /**
1065      * @dev calculates unmasked earnings (just calculates, does not update mask)
1066      * @return earnings in wei format
1067      */
1068     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1069         private
1070         view
1071         returns(uint256)
1072     {
1073         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1074     }
1075     
1076     /** 
1077      * @dev returns the amount of keys you would get given an amount of eth. 
1078      * -functionhash- 0xce89c80c
1079      * @param _rID round ID you want price for
1080      * @param _eth amount of eth sent in 
1081      * @return keys received 
1082      */
1083     function calcKeysReceived(uint256 _rID, uint256 _eth)
1084         public
1085         view
1086         returns(uint256)
1087     {
1088         // grab time
1089         uint256 _now = now;
1090         
1091         // are we in a round?
1092         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1093             return ( (round_[_rID].eth).keysRec(_eth) );
1094         else // rounds over.  need keys for new round
1095             return ( (_eth).keys() );
1096     }
1097     
1098     /** 
1099      * @dev returns current eth price for X keys.  
1100      * -functionhash- 0xcf808000
1101      * @param _keys number of keys desired (in 18 decimal format)
1102      * @return amount of eth needed to send
1103      */
1104     function iWantXKeys(uint256 _keys)
1105         public
1106         view
1107         returns(uint256)
1108     {
1109         // setup local rID
1110         uint256 _rID = rID_;
1111         
1112         // grab time
1113         uint256 _now = now;
1114         
1115         // are we in a round?
1116         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1117             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1118         else // rounds over.  need price for new round
1119             return ( (_keys).eth() );
1120     }
1121     
1122 // Tools
1123     
1124     /**
1125      * @dev receives name/player info from names contract 
1126      */
1127     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1128         external
1129     {
1130         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1131         if (pIDxAddr_[_addr] != _pID)
1132             pIDxAddr_[_addr] = _pID;
1133         if (pIDxName_[_name] != _pID)
1134             pIDxName_[_name] = _pID;
1135         if (plyr_[_pID].addr != _addr)
1136             plyr_[_pID].addr = _addr;
1137         if (plyr_[_pID].name != _name)
1138             plyr_[_pID].name = _name;
1139         if (plyr_[_pID].laff != _laff)
1140             plyr_[_pID].laff = _laff;
1141         if (plyrNames_[_pID][_name] == false)
1142             plyrNames_[_pID][_name] = true;
1143     }
1144     
1145     /**
1146      * @dev receives entire player name list 
1147      */
1148     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1149         external
1150     {
1151         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1152         if(plyrNames_[_pID][_name] == false)
1153             plyrNames_[_pID][_name] = true;
1154     }   
1155         
1156     /**
1157      * @dev gets existing or registers new pID.  use this when a player may be new
1158      * @return pID 
1159      */
1160     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1161         private
1162         returns (F3Ddatasets.EventReturns)
1163     {
1164         uint256 _pID = pIDxAddr_[msg.sender];
1165         // if player is new to this version of fomo3d
1166         if (_pID == 0)
1167         {
1168             // grab their player ID, name and last aff ID, from player names contract 
1169             _pID = PlayerBook.getPlayerID(msg.sender);
1170             bytes32 _name = PlayerBook.getPlayerName(_pID);
1171             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1172             
1173             // set up player account 
1174             pIDxAddr_[msg.sender] = _pID;
1175             plyr_[_pID].addr = msg.sender;
1176             
1177             if (_name != "")
1178             {
1179                 pIDxName_[_name] = _pID;
1180                 plyr_[_pID].name = _name;
1181                 plyrNames_[_pID][_name] = true;
1182             }
1183             
1184             if (_laff != 0 && _laff != _pID)
1185                 plyr_[_pID].laff = _laff;
1186             
1187             // set the new player bool to true
1188             _eventData_.compressedData = _eventData_.compressedData + 1;
1189         } 
1190         return (_eventData_);
1191     }
1192     
1193     /**
1194      * @dev checks to make sure user picked a valid team.  if not sets team 
1195      * to default (sneks)
1196      */
1197     function verifyTeam(uint256 _team)
1198         private
1199         pure
1200         returns (uint256)
1201     {
1202         if (_team < 0 || _team > 3)
1203             return(2);
1204         else
1205             return(_team);
1206     }
1207     
1208     /**
1209      * @dev decides if round end needs to be run & new round started.  and if 
1210      * player unmasked earnings from previously played rounds need to be moved.
1211      */
1212     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1213         private
1214         returns (F3Ddatasets.EventReturns)
1215     {
1216         // if player has played a previous round, move their unmasked earnings
1217         // from that round to gen vault.
1218         if (plyr_[_pID].lrnd != 0)
1219             updateGenVault(_pID, plyr_[_pID].lrnd);
1220             
1221         // update player's last round played
1222         plyr_[_pID].lrnd = rID_;
1223             
1224         // set the joined round bool to true
1225         _eventData_.compressedData = _eventData_.compressedData + 10;
1226         
1227         return(_eventData_);
1228     }
1229     
1230     /**
1231      * @dev ends the round. manages paying out winner/splitting up pot
1232      */
1233     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1234         private
1235         returns (F3Ddatasets.EventReturns)
1236     {
1237         // setup local rID
1238         uint256 _rID = rID_;
1239         
1240         // grab our winning player and team id's
1241         uint256 _winPID = round_[_rID].plyr;
1242         uint256 _winTID = round_[_rID].team;
1243         
1244         // grab our pot amount
1245         uint256 _pot = round_[_rID].pot;
1246         
1247         // calculate our winner share, community rewards, gen share, 
1248         // p3d share, and amount reserved for next pot 
1249         uint256 _win = (_pot.mul(48)) / 100;
1250         uint256 _com = (_pot / 50);
1251         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1252         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1253         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1254         
1255         // calculate ppt for round mask
1256         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1257         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1258         if (_dust > 0)
1259         {
1260             _gen = _gen.sub(_dust);
1261             _res = _res.add(_dust);
1262         }
1263         
1264         // pay our winner
1265         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1266         
1267         FeeAddr.transfer(_com);
1268         
1269         // distribute gen portion to key holders
1270         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1271         
1272         // send share for p3d to divies
1273         if (_p3d > 0)
1274             Divies.deposit.value(_p3d)();
1275             
1276         // prepare event data
1277         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1278         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1279         _eventData_.winnerAddr = plyr_[_winPID].addr;
1280         _eventData_.winnerName = plyr_[_winPID].name;
1281         _eventData_.amountWon = _win;
1282         _eventData_.genAmount = _gen;
1283         _eventData_.P3DAmount = _p3d;
1284         _eventData_.newPot = _res;
1285         
1286         // start next round
1287         rID_++;
1288         _rID++;
1289         round_[_rID].strt = now;
1290         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1291         round_[_rID].pot = _res;
1292         
1293         return(_eventData_);
1294     }
1295     
1296     /**
1297      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1298      */
1299     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1300         private 
1301     {
1302         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1303         if (_earnings > 0)
1304         {
1305             // put in gen vault
1306             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1307             // zero out their earnings by updating mask
1308             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1309         }
1310     }
1311     
1312     /**
1313      * @dev updates round timer based on number of whole keys bought.
1314      */
1315     function updateTimer(uint256 _keys, uint256 _rID)
1316         private
1317     {
1318         // grab time
1319         uint256 _now = now;
1320         
1321         // calculate time based on number of keys bought
1322         uint256 _newTime;
1323         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1324             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1325         else
1326             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1327         
1328         // compare to max and set new end time
1329         if (_newTime < (rndMax_).add(_now))
1330             round_[_rID].end = _newTime;
1331         else
1332             round_[_rID].end = rndMax_.add(_now);
1333     }
1334     
1335     /**
1336      * @dev generates a random number between 0-99 and checks to see if thats
1337      * resulted in an airdrop win
1338      * @return do we have a winner?
1339      */
1340     function airdrop()
1341         private 
1342         view 
1343         returns(bool)
1344     {
1345         uint256 seed = uint256(keccak256(abi.encodePacked(
1346             
1347             (block.timestamp).add
1348             (block.difficulty).add
1349             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1350             (block.gaslimit).add
1351             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1352             (block.number)
1353             
1354         )));
1355         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1356             return(true);
1357         else
1358             return(false);
1359     }
1360 
1361     /**
1362      * @dev distributes eth based on fees to com, aff, and p3d
1363      */
1364     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1365         private
1366         returns(F3Ddatasets.EventReturns)
1367     {
1368         // pay 2% out to community rewards
1369         uint256 _com = _eth / 50;
1370 
1371         FeeAddr.transfer(_com);
1372 
1373         uint256 _p3d;
1374         //address(Jekyll_Island_Inc).deposit.value(_com)(); // always returns true or reverts;
1375         /*
1376         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1377         {
1378             // This ensures Team Just cannot influence the outcome of FoMo3D with
1379             // bank migrations by breaking outgoing transactions.
1380             // Something we would never do. But that's not the point.
1381             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1382             // highest belief that everything we create should be trustless.
1383             // Team JUST, The name you shouldn't have to trust.
1384             _p3d = _com;
1385             _com = 0;
1386         }*/
1387         
1388         // pay 1% out to FoMo3D short
1389         //uint256 _long = _eth / 100;
1390         //otherF3D_.potSwap.value(_long)();
1391         
1392         // distribute share to affiliate
1393         uint256 _aff = _eth / 10; //
1394         
1395         // decide what to do with affiliate share of fees
1396         // affiliate must not be self, and must have a name registered
1397         if (_affID != _pID && plyr_[_affID].name != '') {
1398             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1399             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1400         } else {
1401             _p3d = _aff;
1402         }
1403         
1404         // pay out p3d
1405         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1406 
1407         if (_p3d > 0)
1408         {
1409             // deposit to divies contract
1410             //Divies.deposit.value(_p3d.add(_com))();
1411             Divies.deposit.value(_p3d)();
1412             
1413             // set up event data
1414             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1415         }
1416         
1417         return(_eventData_);
1418     }
1419     
1420     function potSwap()
1421         external
1422         payable
1423     {
1424         // setup local rID
1425         uint256 _rID = rID_ + 1;
1426         
1427         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1428         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1429     }
1430     
1431     /**
1432      * @dev distributes eth based on fees to gen and pot
1433      */
1434     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1435         private
1436         returns(F3Ddatasets.EventReturns)
1437     {
1438         // calculate gen share
1439         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1440         
1441         // toss 2% into airdrop pot [this 1% comes from removing the f3d potsplit to the short f3d]
1442         uint256 _air = (_eth.mul(2) / 100);
1443         airDropPot_ = airDropPot_.add(_air);
1444         
1445         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1446         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1447         
1448         // calculate pot 
1449         uint256 _pot = _eth.sub(_gen);
1450         
1451         // distribute gen share (thats what updateMasks() does) and adjust
1452         // balances for dust.
1453         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1454         if (_dust > 0)
1455             _gen = _gen.sub(_dust);
1456         
1457         // add eth to pot
1458         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1459         
1460         // set up event data
1461         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1462         _eventData_.potAmount = _pot;
1463         
1464         return(_eventData_);
1465     }
1466 
1467     /**
1468      * @dev updates masks for round and player when keys are bought
1469      * @return dust left over 
1470      */
1471     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1472         private
1473         returns(uint256)
1474     {
1475         /* MASKING NOTES
1476             earnings masks are a tricky thing for people to wrap their minds around.
1477             the basic thing to understand here.  is were going to have a global
1478             tracker based on profit per share for each round, that increases in
1479             relevant proportion to the increase in share supply.
1480             
1481             the player will have an additional mask that basically says "based
1482             on the rounds mask, my shares, and how much i've already withdrawn,
1483             how much is still owed to me?"
1484         */
1485         
1486         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1487         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1488         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1489             
1490         // calculate player earning from their own buy (only based on the keys
1491         // they just bought).  & update player earnings mask
1492         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1493         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1494         
1495         // calculate & return dust
1496         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1497     }
1498     
1499     /**
1500      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1501      * @return earnings in wei format
1502      */
1503     function withdrawEarnings(uint256 _pID)
1504         private
1505         returns(uint256)
1506     {
1507         // update gen vault
1508         updateGenVault(_pID, plyr_[_pID].lrnd);
1509         
1510         // from vaults 
1511         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1512         if (_earnings > 0)
1513         {
1514             plyr_[_pID].win = 0;
1515             plyr_[_pID].gen = 0;
1516             plyr_[_pID].aff = 0;
1517         }
1518 
1519         return(_earnings);
1520     }
1521     
1522     /**
1523      * @dev prepares compression data and fires event for buy or reload tx's
1524      */
1525     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1526         private
1527     {
1528         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1529         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1530         
1531         emit F3Devents.onEndTx
1532         (
1533             _eventData_.compressedData,
1534             _eventData_.compressedIDs,
1535             plyr_[_pID].name,
1536             msg.sender,
1537             _eth,
1538             _keys,
1539             _eventData_.winnerAddr,
1540             _eventData_.winnerName,
1541             _eventData_.amountWon,
1542             _eventData_.newPot,
1543             _eventData_.P3DAmount,
1544             _eventData_.genAmount,
1545             _eventData_.potAmount,
1546             airDropPot_
1547         );
1548     }
1549 
1550 // Security
1551     
1552     /** upon contract deploy, it will be deactivated.  this is a one time
1553      * use function that will activate the contract.  we do this so devs 
1554      * have time to set things up on the web end                            **/
1555     bool public activated_ = false;
1556     function activate()
1557         public
1558     {
1559         // only team just can activate 
1560         require(
1561             (msg.sender == 0x8d35c3edFc1A8f2564fd00561Fb0A8423D5B8b44 || msg.sender == 0x8d35c3edFc1A8f2564fd00561Fb0A8423D5B8b44),
1562             "only team HoDL4D can activate"
1563         );
1564 
1565         // make sure that its been linked.
1566         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1567         
1568         // can only be ran once
1569         require(activated_ == false, "fomo3d already activated");
1570         
1571         // activate the contract 
1572         activated_ = true;
1573         
1574         // lets start first round
1575         rID_ = 1;
1576         round_[1].strt = now + rndExtra_ - rndGap_;
1577         round_[1].end = now + rndInit_ + rndExtra_;
1578     }
1579 
1580 }
1581 
1582 // Structs
1583 
1584 library F3Ddatasets {
1585     //compressedData key
1586     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1587         // 0 - new player (bool)
1588         // 1 - joined round (bool)
1589         // 2 - new  leader (bool)
1590         // 3-5 - air drop tracker (uint 0-999)
1591         // 6-16 - round end time
1592         // 17 - winnerTeam
1593         // 18 - 28 timestamp 
1594         // 29 - team
1595         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1596         // 31 - airdrop happened bool
1597         // 32 - airdrop tier 
1598         // 33 - airdrop amount won
1599     //compressedIDs key
1600     // [77-52][51-26][25-0]
1601         // 0-25 - pID 
1602         // 26-51 - winPID
1603         // 52-77 - rID
1604     struct EventReturns {
1605         uint256 compressedData;
1606         uint256 compressedIDs;
1607         address winnerAddr;         // winner address
1608         bytes32 winnerName;         // winner name
1609         uint256 amountWon;          // amount won
1610         uint256 newPot;             // amount in new pot
1611         uint256 P3DAmount;          // amount distributed to p3d
1612         uint256 genAmount;          // amount distributed to gen
1613         uint256 potAmount;          // amount added to pot
1614     }
1615     struct Player {
1616         address addr;   // player address
1617         bytes32 name;   // player name
1618         uint256 win;    // winnings vault
1619         uint256 gen;    // general vault
1620         uint256 aff;    // affiliate vault
1621         uint256 lrnd;   // last round played
1622         uint256 laff;   // last affiliate id used
1623     }
1624     struct PlayerRounds {
1625         uint256 eth;    // eth player has added to round (used for eth limiter)
1626         uint256 keys;   // keys
1627         uint256 mask;   // player mask 
1628         uint256 ico;    // ICO phase investment
1629     }
1630     struct Round {
1631         uint256 plyr;   // pID of player in lead
1632         uint256 team;   // tID of team in lead
1633         uint256 end;    // time ends/ended
1634         bool ended;     // has round end function been ran
1635         uint256 strt;   // time round started
1636         uint256 keys;   // keys
1637         uint256 eth;    // total eth in
1638         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1639         uint256 mask;   // global mask
1640         uint256 ico;    // total eth sent in during ICO phase
1641         uint256 icoGen; // total eth for gen during ICO phase
1642         uint256 icoAvg; // average key price for ICO phase
1643     }
1644     struct TeamFee {
1645         uint256 gen;    // % of buy in thats paid to key holders of current round
1646         uint256 p3d;    // % of buy in thats paid to p3d holders
1647     }
1648     struct PotSplit {
1649         uint256 gen;    // % of pot thats paid to key holders of current round
1650         uint256 p3d;    // % of pot thats paid to p3d holders
1651     }
1652 }
1653 
1654 // Key Calculations
1655 
1656 library F3DKeysCalcLong {
1657     using SafeMath for *;
1658     /**
1659      * @dev calculates number of keys received given X eth 
1660      * @param _curEth current amount of eth in contract 
1661      * @param _newEth eth being spent
1662      * @return amount of ticket purchased
1663      */
1664     function keysRec(uint256 _curEth, uint256 _newEth)
1665         internal
1666         pure
1667         returns (uint256)
1668     {
1669         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1670     }
1671     
1672     /**
1673      * @dev calculates amount of eth received if you sold X keys 
1674      * @param _curKeys current amount of keys that exist 
1675      * @param _sellKeys amount of keys you wish to sell
1676      * @return amount of eth received
1677      */
1678     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1679         internal
1680         pure
1681         returns (uint256)
1682     {
1683         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1684     }
1685 
1686     /**
1687      * @dev calculates how many keys would exist with given an amount of eth
1688      * @param _eth eth "in contract"
1689      * @return number of keys that would exist
1690      */
1691     function keys(uint256 _eth) 
1692         internal
1693         pure
1694         returns(uint256)
1695     {
1696         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1697     }
1698     
1699     /**
1700      * @dev calculates how much eth would be in contract given a number of keys
1701      * @param _keys number of keys "in contract" 
1702      * @return eth that would exists
1703      */
1704     function eth(uint256 _keys) 
1705         internal
1706         pure
1707         returns(uint256)  
1708     {
1709         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1710     }
1711 }
1712 
1713 // Interfaces
1714 
1715 interface otherFoMo3D {
1716     function potSwap() external payable;
1717 }
1718 
1719 interface F3DexternalSettingsInterface {
1720     function getFastGap() external returns(uint256);
1721     function getLongGap() external returns(uint256);
1722     function getFastExtra() external returns(uint256);
1723     function getLongExtra() external returns(uint256);
1724 }
1725 
1726 interface JIincForwarderInterface {
1727     function deposit() external payable;
1728     function status() external view returns(address, address, bool);
1729     function startMigration(address _newCorpBank) external returns(bool);
1730     function cancelMigration() external returns(bool);
1731     function finishMigration() external returns(bool);
1732     function setup(address _firstCorpBank) external;
1733 }
1734 
1735 interface PlayerBookInterface {
1736     function getPlayerID(address _addr) external returns (uint256);
1737     function getPlayerName(uint256 _pID) external view returns (bytes32);
1738     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1739     function getPlayerAddr(uint256 _pID) external view returns (address);
1740     function getNameFee() external view returns (uint256);
1741     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1742     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1743     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1744 }
1745 
1746 library NameFilter {
1747     /**
1748      * @dev filters name strings
1749      * -converts uppercase to lower case.  
1750      * -makes sure it does not start/end with a space
1751      * -makes sure it does not contain multiple spaces in a row
1752      * -cannot be only numbers
1753      * -cannot start with 0x 
1754      * -restricts characters to A-Z, a-z, 0-9, and space.
1755      * @return reprocessed string in bytes32 format
1756      */
1757     function nameFilter(string _input)
1758         internal
1759         pure
1760         returns(bytes32)
1761     {
1762         bytes memory _temp = bytes(_input);
1763         uint256 _length = _temp.length;
1764         
1765         //sorry limited to 32 characters
1766         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1767         // make sure it doesnt start with or end with space
1768         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1769         // make sure first two characters are not 0x
1770         if (_temp[0] == 0x30)
1771         {
1772             require(_temp[1] != 0x78, "string cannot start with 0x");
1773             require(_temp[1] != 0x58, "string cannot start with 0X");
1774         }
1775         
1776         // create a bool to track if we have a non number character
1777         bool _hasNonNumber;
1778         
1779         // convert & check
1780         for (uint256 i = 0; i < _length; i++)
1781         {
1782             // if its uppercase A-Z
1783             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1784             {
1785                 // convert to lower case a-z
1786                 _temp[i] = byte(uint(_temp[i]) + 32);
1787                 
1788                 // we have a non number
1789                 if (_hasNonNumber == false)
1790                     _hasNonNumber = true;
1791             } else {
1792                 require
1793                 (
1794                     // require character is a space
1795                     _temp[i] == 0x20 || 
1796                     // OR lowercase a-z
1797                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1798                     // or 0-9
1799                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1800                     "string contains invalid characters"
1801                 );
1802                 // make sure theres not 2x spaces in a row
1803                 if (_temp[i] == 0x20)
1804                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1805                 
1806                 // see if we have a character other than a number
1807                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1808                     _hasNonNumber = true;    
1809             }
1810         }
1811         
1812         require(_hasNonNumber == true, "string cannot be only numbers");
1813         
1814         bytes32 _ret;
1815         assembly {
1816             _ret := mload(add(_temp, 32))
1817         }
1818         return (_ret);
1819     }
1820 }
1821 
1822 /**
1823  * @title SafeMath v0.1.9
1824  * @dev Math operations with safety checks that throw on error
1825  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1826  * - added sqrt
1827  * - added sq
1828  * - added pwr 
1829  * - changed asserts to requires with error log outputs
1830  * - removed div, its useless
1831  */
1832 library SafeMath {
1833     
1834     /**
1835     * @dev Multiplies two numbers, throws on overflow.
1836     */
1837     function mul(uint256 a, uint256 b) 
1838         internal 
1839         pure 
1840         returns (uint256 c) 
1841     {
1842         if (a == 0) {
1843             return 0;
1844         }
1845         c = a * b;
1846         require(c / a == b, "SafeMath mul failed");
1847         return c;
1848     }
1849 
1850     /**
1851     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1852     */
1853     function sub(uint256 a, uint256 b)
1854         internal
1855         pure
1856         returns (uint256) 
1857     {
1858         require(b <= a, "SafeMath sub failed");
1859         return a - b;
1860     }
1861 
1862     /**
1863     * @dev Adds two numbers, throws on overflow.
1864     */
1865     function add(uint256 a, uint256 b)
1866         internal
1867         pure
1868         returns (uint256 c) 
1869     {
1870         c = a + b;
1871         require(c >= a, "SafeMath add failed");
1872         return c;
1873     }
1874     
1875     /**
1876      * @dev gives square root of given x.
1877      */
1878     function sqrt(uint256 x)
1879         internal
1880         pure
1881         returns (uint256 y) 
1882     {
1883         uint256 z = ((add(x,1)) / 2);
1884         y = x;
1885         while (z < y) 
1886         {
1887             y = z;
1888             z = ((add((x / z),z)) / 2);
1889         }
1890     }
1891     
1892     /**
1893      * @dev gives square. multiplies x by x
1894      */
1895     function sq(uint256 x)
1896         internal
1897         pure
1898         returns (uint256)
1899     {
1900         return (mul(x,x));
1901     }
1902     
1903     /**
1904      * @dev x to the power of y 
1905      */
1906     function pwr(uint256 x, uint256 y)
1907         internal 
1908         pure 
1909         returns (uint256)
1910     {
1911         if (x==0)
1912             return (0);
1913         else if (y==0)
1914             return (1);
1915         else 
1916         {
1917             uint256 z = x;
1918             for (uint256 i=1; i < y; i++)
1919                 z = mul(z,x);
1920             return (z);
1921         }
1922     }
1923 }