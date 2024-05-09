1 pragma solidity ^0.4.24;
2 /**
3  * @title -FoMo-3D v0.7.1
4  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
5  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
6  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
7  *                                  _____                      _____
8  *                                 (, /     /)       /) /)    (, /      /)          /)
9  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
10  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
11  *          ┴ ┴                /   /          .-/ _____   (__ /
12  *                            (__ /          (_/ (, /                                      /)™
13  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
14  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
15  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
16  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/   .--,-``-.
17  *========,---,.======================____==========================/   /     '.=======,---,====*
18  *      ,'  .' |                    ,'  , `.                       / ../        ;    .'  .' `\
19  *    ,---.'   |    ,---.        ,-+-,.' _ |    ,---.              \ ``\  .`-    ' ,---.'     \
20  *    |   |   .'   '   ,'\    ,-+-. ;   , ||   '   ,'\      ,---,.  \___\/   \   : |   |  .`\  |
21  *    :   :  :    /   /   |  ,--.'|'   |  ||  /   /   |   ,'  .' |       \   :   | :   : |  '  |
22  *    :   |  |-, .   ; ,. : |   |  ,', |  |, .   ; ,. : ,---.'   |       /  /   /  |   ' '  ;  :
23  *    |   :  ;/| '   | |: : |   | /  | |--'  '   | |: : |   |  .'        \  \   \  '   | ;  .  |
24  *    |   |   .' '   | .; : |   : |  | ,     '   | .; : :   |.'      ___ /   :   | |   | :  |  '
25  *    '   :  '   |   :    | |   : |  |/      |   :    | `---'       /   /\   /   : '   : | /  ;
26  *    |   |  |    \   \  /  |   | |`-'        \   \  /             / ,,/  ',-    . |   | '` ,/
27  *    |   :  \     `----'   |   ;/             `----'              \ ''\        ;  ;   :  .'
28  *====|   | ,'=============='---'==========(Quick version)===========\   \     .'===|   ,.'======*
29  *    `----'  
30  */
31  
32  
33 contract F3Devents {
34     // fired whenever a player registers a name
35     event onNewName
36     (
37         uint256 indexed playerID,
38         address indexed playerAddress,
39         bytes32 indexed playerName,
40         bool isNewPlayer,
41         uint256 affiliateID,
42         address affiliateAddress,
43         bytes32 affiliateName,
44         uint256 amountPaid,
45         uint256 timeStamp
46     );
47 
48     // fired at end of buy or reload
49     event onEndTx
50     (
51         uint256 compressedData,
52         uint256 compressedIDs,
53         bytes32 playerName,
54         address playerAddress,
55         uint256 ethIn,
56         uint256 keysBought,
57         address winnerAddr,
58         bytes32 winnerName,
59         uint256 amountWon,
60         uint256 newPot,
61         uint256 P3DAmount,
62         uint256 genAmount,
63         uint256 potAmount,
64         uint256 airDropPot
65     );
66 
67 	// fired whenever theres a withdraw
68     event onWithdraw
69     (
70         uint256 indexed playerID,
71         address playerAddress,
72         bytes32 playerName,
73         uint256 ethOut,
74         uint256 timeStamp
75     );
76 
77     // fired whenever a withdraw forces end round to be ran
78     event onWithdrawAndDistribute
79     (
80         address playerAddress,
81         bytes32 playerName,
82         uint256 ethOut,
83         uint256 compressedData,
84         uint256 compressedIDs,
85         address winnerAddr,
86         bytes32 winnerName,
87         uint256 amountWon,
88         uint256 newPot,
89         uint256 P3DAmount,
90         uint256 genAmount
91     );
92 
93     // (fomo3d short only) fired whenever a player tries a buy after round timer
94     // hit zero, and causes end round to be ran.
95     event onBuyAndDistribute
96     (
97         address playerAddress,
98         bytes32 playerName,
99         uint256 ethIn,
100         uint256 compressedData,
101         uint256 compressedIDs,
102         address winnerAddr,
103         bytes32 winnerName,
104         uint256 amountWon,
105         uint256 newPot,
106         uint256 P3DAmount,
107         uint256 genAmount
108     );
109 
110     // (fomo3d short only) fired whenever a player tries a reload after round timer
111     // hit zero, and causes end round to be ran.
112     event onReLoadAndDistribute
113     (
114         address playerAddress,
115         bytes32 playerName,
116         uint256 compressedData,
117         uint256 compressedIDs,
118         address winnerAddr,
119         bytes32 winnerName,
120         uint256 amountWon,
121         uint256 newPot,
122         uint256 P3DAmount,
123         uint256 genAmount
124     );
125 
126     // fired whenever an affiliate is paid
127     event onAffiliatePayout
128     (
129         uint256 indexed affiliateID,
130         address affiliateAddress,
131         bytes32 affiliateName,
132         uint256 indexed roundID,
133         uint256 indexed buyerID,
134         uint256 amount,
135         uint256 timeStamp
136     );
137 
138     // received pot swap deposit
139     event onPotSwapDeposit
140     (
141         uint256 roundID,
142         uint256 amountAddedToPot
143     );
144 }
145 
146 
147 contract modularShort is F3Devents {}
148 
149 contract FoMo3DQuick is modularShort {
150     using SafeMath for *;
151     using NameFilter for string;
152     using F3DKeysCalcShort for uint256;
153 
154     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x9576A5C917CAf5cc79D8124292D35AB131f514EF);
155 
156     address private admin = msg.sender;
157     string constant public name = "FoMo3DQuick";
158     string constant public symbol = "Quick";
159     uint256 private rndExtra_ = 1 minutes;     // length of the very first ICO
160     uint256 private rndGap_ = 1 minutes;         // length of ICO phase, set to 1 year for EOS.
161     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
162     uint256 constant private rndInc_ = 1 minutes;              // every full key purchased adds this much to the timer
163     uint256 constant private rndMax_ = 1 hours;                // max length a round timer can be
164 //==============================================================================
165 //     _| _ _|_ _    _ _ _|_    _   .
166 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
167 //=============================|================================================
168     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
169     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
170     uint256 public rID_;    // round id number / total rounds that have happened
171 //****************
172 // PLAYER DATA
173 //****************
174     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
175     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
176     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
177     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
178     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
179 //****************
180 // ROUND DATA
181 //****************
182     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
183     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
184 //****************
185 // TEAM FEE DATA
186 //****************
187     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
188     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
189 //==============================================================================
190 //     _ _  _  __|_ _    __|_ _  _  .
191 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
192 //==============================================================================
193     constructor()
194         public
195     {
196 		// Team allocation structures
197         // 0 = whales
198         // 1 = bears
199         // 2 = sneks
200         // 3 = bulls
201 
202 		// Team allocation percentages
203         // (F3D, P3D) + (Pot , Referrals, Community)
204             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
205         fees_[0] = F3Ddatasets.TeamFee(60,0);   // NO P3D SHARES, ALL TEAM SETTINGS 'BEARS' DEFAULT
206         fees_[1] = F3Ddatasets.TeamFee(60,0);  
207         fees_[2] = F3Ddatasets.TeamFee(60,0); 
208         fees_[3] = F3Ddatasets.TeamFee(60,0);   
209 
210         // how to split up the final pot based on which team was picked
211         // (F3D, P3D)
212         potSplit_[0] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
213         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
214         potSplit_[2] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
215         potSplit_[3] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
216 	}
217 //==============================================================================
218 //     _ _  _  _|. |`. _  _ _  .
219 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
220 //==============================================================================
221     /**
222      * @dev used to make sure no one can interact with contract until it has
223      * been activated.
224      */
225     modifier isActivated() {
226         require(activated_ == true, "its not ready yet.  check ?eta in discord");
227         _;
228     }
229 
230     /**
231      * @dev prevents contracts from interacting with fomo3d
232      */
233     modifier isHuman() {
234         address _addr = msg.sender;
235         uint256 _codeLength;
236 
237         assembly {_codeLength := extcodesize(_addr)}
238         require(_codeLength == 0, "sorry humans only");
239         _;
240     }
241 
242     /**
243      * @dev sets boundaries for incoming tx
244      */
245     modifier isWithinLimits(uint256 _eth) {
246         require(_eth >= 1000000000, "pocket lint: not a valid currency");
247         require(_eth <= 100000000000000000000000, "no vitalik, no");
248         _;
249     }
250 
251 //==============================================================================
252 //     _    |_ |. _   |`    _  __|_. _  _  _  .
253 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
254 //====|=========================================================================
255     /**
256      * @dev emergency buy uses last stored affiliate ID and team snek
257      */
258     function()
259         isActivated()
260         isHuman()
261         isWithinLimits(msg.value)
262         public
263         payable
264     {
265         // set up our tx event data and determine if player is new or not
266         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
267 
268         // fetch player id
269         uint256 _pID = pIDxAddr_[msg.sender];
270 
271         // buy core
272         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
273     }
274 
275     /**
276      * @dev converts all incoming ethereum to keys.
277      * -functionhash- 0x8f38f309 (using ID for affiliate)
278      * -functionhash- 0x98a0871d (using address for affiliate)
279      * -functionhash- 0xa65b37a1 (using name for affiliate)
280      * @param _affCode the ID/address/name of the player who gets the affiliate fee
281      * @param _team what team is the player playing for?
282      */
283     function buyXid(uint256 _affCode, uint256 _team)
284         isActivated()
285         isHuman()
286         isWithinLimits(msg.value)
287         public
288         payable
289     {
290         // set up our tx event data and determine if player is new or not
291         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
292 
293         // fetch player id
294         uint256 _pID = pIDxAddr_[msg.sender];
295 
296         // manage affiliate residuals
297         // if no affiliate code was given or player tried to use their own, lolz
298         if (_affCode == 0 || _affCode == _pID)
299         {
300             // use last stored affiliate code
301             _affCode = plyr_[_pID].laff;
302 
303         // if affiliate code was given & its not the same as previously stored
304         } else if (_affCode != plyr_[_pID].laff) {
305             // update last affiliate
306             plyr_[_pID].laff = _affCode;
307         }
308 
309         // verify a valid team was selected
310         _team = verifyTeam(_team);
311 
312         // buy core
313         buyCore(_pID, _affCode, _team, _eventData_);
314     }
315 
316     function buyXaddr(address _affCode, uint256 _team)
317         isActivated()
318         isHuman()
319         isWithinLimits(msg.value)
320         public
321         payable
322     {
323         // set up our tx event data and determine if player is new or not
324         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
325 
326         // fetch player id
327         uint256 _pID = pIDxAddr_[msg.sender];
328 
329         // manage affiliate residuals
330         uint256 _affID;
331         // if no affiliate code was given or player tried to use their own, lolz
332         if (_affCode == address(0) || _affCode == msg.sender)
333         {
334             // use last stored affiliate code
335             _affID = plyr_[_pID].laff;
336 
337         // if affiliate code was given
338         } else {
339             // get affiliate ID from aff Code
340             _affID = pIDxAddr_[_affCode];
341 
342             // if affID is not the same as previously stored
343             if (_affID != plyr_[_pID].laff)
344             {
345                 // update last affiliate
346                 plyr_[_pID].laff = _affID;
347             }
348         }
349 
350         // verify a valid team was selected
351         _team = verifyTeam(_team);
352 
353         // buy core
354         buyCore(_pID, _affID, _team, _eventData_);
355     }
356 
357     function buyXname(bytes32 _affCode, uint256 _team)
358         isActivated()
359         isHuman()
360         isWithinLimits(msg.value)
361         public
362         payable
363     {
364         // set up our tx event data and determine if player is new or not
365         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
366 
367         // fetch player id
368         uint256 _pID = pIDxAddr_[msg.sender];
369 
370         // manage affiliate residuals
371         uint256 _affID;
372         // if no affiliate code was given or player tried to use their own, lolz
373         if (_affCode == '' || _affCode == plyr_[_pID].name)
374         {
375             // use last stored affiliate code
376             _affID = plyr_[_pID].laff;
377 
378         // if affiliate code was given
379         } else {
380             // get affiliate ID from aff Code
381             _affID = pIDxName_[_affCode];
382 
383             // if affID is not the same as previously stored
384             if (_affID != plyr_[_pID].laff)
385             {
386                 // update last affiliate
387                 plyr_[_pID].laff = _affID;
388             }
389         }
390 
391         // verify a valid team was selected
392         _team = verifyTeam(_team);
393 
394         // buy core
395         buyCore(_pID, _affID, _team, _eventData_);
396     }
397 
398     /**
399      * @dev essentially the same as buy, but instead of you sending ether
400      * from your wallet, it uses your unwithdrawn earnings.
401      * -functionhash- 0x349cdcac (using ID for affiliate)
402      * -functionhash- 0x82bfc739 (using address for affiliate)
403      * -functionhash- 0x079ce327 (using name for affiliate)
404      * @param _affCode the ID/address/name of the player who gets the affiliate fee
405      * @param _team what team is the player playing for?
406      * @param _eth amount of earnings to use (remainder returned to gen vault)
407      */
408     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
409         isActivated()
410         isHuman()
411         isWithinLimits(_eth)
412         public
413     {
414         // set up our tx event data
415         F3Ddatasets.EventReturns memory _eventData_;
416 
417         // fetch player ID
418         uint256 _pID = pIDxAddr_[msg.sender];
419 
420         // manage affiliate residuals
421         // if no affiliate code was given or player tried to use their own, lolz
422         if (_affCode == 0 || _affCode == _pID)
423         {
424             // use last stored affiliate code
425             _affCode = plyr_[_pID].laff;
426 
427         // if affiliate code was given & its not the same as previously stored
428         } else if (_affCode != plyr_[_pID].laff) {
429             // update last affiliate
430             plyr_[_pID].laff = _affCode;
431         }
432 
433         // verify a valid team was selected
434         _team = verifyTeam(_team);
435 
436         // reload core
437         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
438     }
439 
440     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
441         isActivated()
442         isHuman()
443         isWithinLimits(_eth)
444         public
445     {
446         // set up our tx event data
447         F3Ddatasets.EventReturns memory _eventData_;
448 
449         // fetch player ID
450         uint256 _pID = pIDxAddr_[msg.sender];
451 
452         // manage affiliate residuals
453         uint256 _affID;
454         // if no affiliate code was given or player tried to use their own, lolz
455         if (_affCode == address(0) || _affCode == msg.sender)
456         {
457             // use last stored affiliate code
458             _affID = plyr_[_pID].laff;
459 
460         // if affiliate code was given
461         } else {
462             // get affiliate ID from aff Code
463             _affID = pIDxAddr_[_affCode];
464 
465             // if affID is not the same as previously stored
466             if (_affID != plyr_[_pID].laff)
467             {
468                 // update last affiliate
469                 plyr_[_pID].laff = _affID;
470             }
471         }
472 
473         // verify a valid team was selected
474         _team = verifyTeam(_team);
475 
476         // reload core
477         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
478     }
479 
480     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
481         isActivated()
482         isHuman()
483         isWithinLimits(_eth)
484         public
485     {
486         // set up our tx event data
487         F3Ddatasets.EventReturns memory _eventData_;
488 
489         // fetch player ID
490         uint256 _pID = pIDxAddr_[msg.sender];
491 
492         // manage affiliate residuals
493         uint256 _affID;
494         // if no affiliate code was given or player tried to use their own, lolz
495         if (_affCode == '' || _affCode == plyr_[_pID].name)
496         {
497             // use last stored affiliate code
498             _affID = plyr_[_pID].laff;
499 
500         // if affiliate code was given
501         } else {
502             // get affiliate ID from aff Code
503             _affID = pIDxName_[_affCode];
504 
505             // if affID is not the same as previously stored
506             if (_affID != plyr_[_pID].laff)
507             {
508                 // update last affiliate
509                 plyr_[_pID].laff = _affID;
510             }
511         }
512 
513         // verify a valid team was selected
514         _team = verifyTeam(_team);
515 
516         // reload core
517         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
518     }
519 
520     /**
521      * @dev withdraws all of your earnings.
522      * -functionhash- 0x3ccfd60b
523      */
524     function withdraw()
525         isActivated()
526         isHuman()
527         public
528     {
529         // setup local rID
530         uint256 _rID = rID_;
531 
532         // grab time
533         uint256 _now = now;
534 
535         // fetch player ID
536         uint256 _pID = pIDxAddr_[msg.sender];
537 
538         // setup temp var for player eth
539         uint256 _eth;
540 
541         // check to see if round has ended and no one has run round end yet
542         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
543         {
544             // set up our tx event data
545             F3Ddatasets.EventReturns memory _eventData_;
546 
547             // end the round (distributes pot)
548 			round_[_rID].ended = true;
549             _eventData_ = endRound(_eventData_);
550 
551 			// get their earnings
552             _eth = withdrawEarnings(_pID);
553 
554             // gib moni
555             if (_eth > 0)
556                 plyr_[_pID].addr.transfer(_eth);
557 
558             // build event data
559             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
560             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
561 
562             // fire withdraw and distribute event
563             emit F3Devents.onWithdrawAndDistribute
564             (
565                 msg.sender,
566                 plyr_[_pID].name,
567                 _eth,
568                 _eventData_.compressedData,
569                 _eventData_.compressedIDs,
570                 _eventData_.winnerAddr,
571                 _eventData_.winnerName,
572                 _eventData_.amountWon,
573                 _eventData_.newPot,
574                 _eventData_.P3DAmount,
575                 _eventData_.genAmount
576             );
577 
578         // in any other situation
579         } else {
580             // get their earnings
581             _eth = withdrawEarnings(_pID);
582 
583             // gib moni
584             if (_eth > 0)
585                 plyr_[_pID].addr.transfer(_eth);
586 
587             // fire withdraw event
588             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
589         }
590     }
591 
592     /**
593      * @dev use these to register names.  they are just wrappers that will send the
594      * registration requests to the PlayerBook contract.  So registering here is the
595      * same as registering there.  UI will always display the last name you registered.
596      * but you will still own all previously registered names to use as affiliate
597      * links.
598      * - must pay a registration fee.
599      * - name must be unique
600      * - names will be converted to lowercase
601      * - name cannot start or end with a space
602      * - cannot have more than 1 space in a row
603      * - cannot be only numbers
604      * - cannot start with 0x
605      * - name must be at least 1 char
606      * - max length of 32 characters long
607      * - allowed characters: a-z, 0-9, and space
608      * -functionhash- 0x921dec21 (using ID for affiliate)
609      * -functionhash- 0x3ddd4698 (using address for affiliate)
610      * -functionhash- 0x685ffd83 (using name for affiliate)
611      * @param _nameString players desired name
612      * @param _affCode affiliate ID, address, or name of who referred you
613      * @param _all set to true if you want this to push your info to all games
614      * (this might cost a lot of gas)
615      */
616     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
617         isHuman()
618         public
619         payable
620     {
621         bytes32 _name = _nameString.nameFilter();
622         address _addr = msg.sender;
623         uint256 _paid = msg.value;
624         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
625 
626         uint256 _pID = pIDxAddr_[_addr];
627 
628         // fire event
629         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
630     }
631 
632     function registerNameXaddr(string _nameString, address _affCode, bool _all)
633         isHuman()
634         public
635         payable
636     {
637         bytes32 _name = _nameString.nameFilter();
638         address _addr = msg.sender;
639         uint256 _paid = msg.value;
640         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
641 
642         uint256 _pID = pIDxAddr_[_addr];
643 
644         // fire event
645         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
646     }
647 
648     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
649         isHuman()
650         public
651         payable
652     {
653         bytes32 _name = _nameString.nameFilter();
654         address _addr = msg.sender;
655         uint256 _paid = msg.value;
656         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
657 
658         uint256 _pID = pIDxAddr_[_addr];
659 
660         // fire event
661         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
662     }
663 //==============================================================================
664 //     _  _ _|__|_ _  _ _  .
665 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
666 //=====_|=======================================================================
667     /**
668      * @dev return the price buyer will pay for next 1 individual key.
669      * -functionhash- 0x018a25e8
670      * @return price for next key bought (in wei format)
671      */
672     function getBuyPrice()
673         public
674         view
675         returns(uint256)
676     {
677         // setup local rID
678         uint256 _rID = rID_;
679 
680         // grab time
681         uint256 _now = now;
682 
683         // are we in a round?
684         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
685             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
686         else // rounds over.  need price for new round
687             return ( 75000000000000 ); // init
688     }
689 
690     /**
691      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
692      * provider
693      * -functionhash- 0xc7e284b8
694      * @return time left in seconds
695      */
696     function getTimeLeft()
697         public
698         view
699         returns(uint256)
700     {
701         // setup local rID
702         uint256 _rID = rID_;
703 
704         // grab time
705         uint256 _now = now;
706 
707         if (_now < round_[_rID].end)
708             if (_now > round_[_rID].strt + rndGap_)
709                 return( (round_[_rID].end).sub(_now) );
710             else
711                 return( (round_[_rID].strt + rndGap_).sub(_now) );
712         else
713             return(0);
714     }
715 
716     /**
717      * @dev returns player earnings per vaults
718      * -functionhash- 0x63066434
719      * @return winnings vault
720      * @return general vault
721      * @return affiliate vault
722      */
723     function getPlayerVaults(uint256 _pID)
724         public
725         view
726         returns(uint256 ,uint256, uint256)
727     {
728         // setup local rID
729         uint256 _rID = rID_;
730 
731         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
732         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
733         {
734             // if player is winner
735             if (round_[_rID].plyr == _pID)
736             {
737                 return
738                 (
739                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
740                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
741                     plyr_[_pID].aff
742                 );
743             // if player is not the winner
744             } else {
745                 return
746                 (
747                     plyr_[_pID].win,
748                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
749                     plyr_[_pID].aff
750                 );
751             }
752 
753         // if round is still going on, or round has ended and round end has been ran
754         } else {
755             return
756             (
757                 plyr_[_pID].win,
758                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
759                 plyr_[_pID].aff
760             );
761         }
762     }
763 
764     /**
765      * solidity hates stack limits.  this lets us avoid that hate
766      */
767     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
768         private
769         view
770         returns(uint256)
771     {
772         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
773     }
774 
775     /**
776      * @dev returns all current round info needed for front end
777      * -functionhash- 0x747dff42
778      * @return eth invested during ICO phase
779      * @return round id
780      * @return total keys for round
781      * @return time round ends
782      * @return time round started
783      * @return current pot
784      * @return current team ID & player ID in lead
785      * @return current player in leads address
786      * @return current player in leads name
787      * @return whales eth in for round
788      * @return bears eth in for round
789      * @return sneks eth in for round
790      * @return bulls eth in for round
791      * @return airdrop tracker # & airdrop pot
792      */
793     function getCurrentRoundInfo()
794         public
795         view
796         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
797     {
798         // setup local rID
799         uint256 _rID = rID_;
800 
801         return
802         (
803             round_[_rID].ico,               //0
804             _rID,                           //1
805             round_[_rID].keys,              //2
806             round_[_rID].end,               //3
807             round_[_rID].strt,              //4
808             round_[_rID].pot,               //5
809             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
810             plyr_[round_[_rID].plyr].addr,  //7
811             plyr_[round_[_rID].plyr].name,  //8
812             rndTmEth_[_rID][0],             //9
813             rndTmEth_[_rID][1],             //10
814             rndTmEth_[_rID][2],             //11
815             rndTmEth_[_rID][3],             //12
816             airDropTracker_ + (airDropPot_ * 1000)              //13
817         );
818     }
819 
820     /**
821      * @dev returns player info based on address.  if no address is given, it will
822      * use msg.sender
823      * -functionhash- 0xee0b5d8b
824      * @param _addr address of the player you want to lookup
825      * @return player ID
826      * @return player name
827      * @return keys owned (current round)
828      * @return winnings vault
829      * @return general vault
830      * @return affiliate vault
831 	 * @return player round eth
832      */
833     function getPlayerInfoByAddress(address _addr)
834         public
835         view
836         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
837     {
838         // setup local rID
839         uint256 _rID = rID_;
840 
841         if (_addr == address(0))
842         {
843             _addr == msg.sender;
844         }
845         uint256 _pID = pIDxAddr_[_addr];
846 
847         return
848         (
849             _pID,                               //0
850             plyr_[_pID].name,                   //1
851             plyrRnds_[_pID][_rID].keys,         //2
852             plyr_[_pID].win,                    //3
853             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
854             plyr_[_pID].aff,                    //5
855             plyrRnds_[_pID][_rID].eth           //6
856         );
857     }
858 
859 //==============================================================================
860 //     _ _  _ _   | _  _ . _  .
861 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
862 //=====================_|=======================================================
863     /**
864      * @dev logic runs whenever a buy order is executed.  determines how to handle
865      * incoming eth depending on if we are in an active round or not
866      */
867     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
868         private
869     {
870         // setup local rID
871         uint256 _rID = rID_;
872 
873         // grab time
874         uint256 _now = now;
875 
876         // if round is active
877         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
878         {
879             // call core
880             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
881 
882         // if round is not active
883         } else {
884             // check to see if end round needs to be ran
885             if (_now > round_[_rID].end && round_[_rID].ended == false)
886             {
887                 // end the round (distributes pot) & start new round
888 			    round_[_rID].ended = true;
889                 _eventData_ = endRound(_eventData_);
890 
891                 // build event data
892                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
893                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
894 
895                 // fire buy and distribute event
896                 emit F3Devents.onBuyAndDistribute
897                 (
898                     msg.sender,
899                     plyr_[_pID].name,
900                     msg.value,
901                     _eventData_.compressedData,
902                     _eventData_.compressedIDs,
903                     _eventData_.winnerAddr,
904                     _eventData_.winnerName,
905                     _eventData_.amountWon,
906                     _eventData_.newPot,
907                     _eventData_.P3DAmount,
908                     _eventData_.genAmount
909                 );
910             }
911 
912             // put eth in players vault
913             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
914         }
915     }
916 
917     /**
918      * @dev logic runs whenever a reload order is executed.  determines how to handle
919      * incoming eth depending on if we are in an active round or not
920      */
921     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
922         private
923     {
924         // setup local rID
925         uint256 _rID = rID_;
926 
927         // grab time
928         uint256 _now = now;
929 
930         // if round is active
931         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
932         {
933             // get earnings from all vaults and return unused to gen vault
934             // because we use a custom safemath library.  this will throw if player
935             // tried to spend more eth than they have.
936             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
937 
938             // call core
939             core(_rID, _pID, _eth, _affID, _team, _eventData_);
940 
941         // if round is not active and end round needs to be ran
942         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
943             // end the round (distributes pot) & start new round
944             round_[_rID].ended = true;
945             _eventData_ = endRound(_eventData_);
946 
947             // build event data
948             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
949             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
950 
951             // fire buy and distribute event
952             emit F3Devents.onReLoadAndDistribute
953             (
954                 msg.sender,
955                 plyr_[_pID].name,
956                 _eventData_.compressedData,
957                 _eventData_.compressedIDs,
958                 _eventData_.winnerAddr,
959                 _eventData_.winnerName,
960                 _eventData_.amountWon,
961                 _eventData_.newPot,
962                 _eventData_.P3DAmount,
963                 _eventData_.genAmount
964             );
965         }
966     }
967 
968     /**
969      * @dev this is the core logic for any buy/reload that happens while a round
970      * is live.
971      */
972     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
973         private
974     {
975         // if player is new to round
976         if (plyrRnds_[_pID][_rID].keys == 0)
977             _eventData_ = managePlayer(_pID, _eventData_);
978 
979         // early round eth limiter
980         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
981         {
982             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
983             uint256 _refund = _eth.sub(_availableLimit);
984             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
985             _eth = _availableLimit;
986         }
987 
988         // if eth left is greater than min eth allowed (sorry no pocket lint)
989         if (_eth > 1000000000)
990         {
991 
992             // mint the new keys
993             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
994 
995             // if they bought at least 1 whole key
996             if (_keys >= 1000000000000000000)
997             {
998             updateTimer(_keys, _rID);
999 
1000             // set new leaders
1001             if (round_[_rID].plyr != _pID)
1002                 round_[_rID].plyr = _pID;
1003             if (round_[_rID].team != _team)
1004                 round_[_rID].team = _team;
1005 
1006             // set the new leader bool to true
1007             _eventData_.compressedData = _eventData_.compressedData + 100;
1008         }
1009 
1010             // manage airdrops
1011             if (_eth >= 100000000000000000)
1012             {
1013             airDropTracker_++;
1014             if (airdrop() == true)
1015             {
1016                 // gib muni
1017                 uint256 _prize;
1018                 if (_eth >= 10000000000000000000)
1019                 {
1020                     // calculate prize and give it to winner
1021                     _prize = ((airDropPot_).mul(75)) / 100;
1022                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1023 
1024                     // adjust airDropPot
1025                     airDropPot_ = (airDropPot_).sub(_prize);
1026 
1027                     // let event know a tier 3 prize was won
1028                     _eventData_.compressedData += 300000000000000000000000000000000;
1029                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1030                     // calculate prize and give it to winner
1031                     _prize = ((airDropPot_).mul(50)) / 100;
1032                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1033 
1034                     // adjust airDropPot
1035                     airDropPot_ = (airDropPot_).sub(_prize);
1036 
1037                     // let event know a tier 2 prize was won
1038                     _eventData_.compressedData += 200000000000000000000000000000000;
1039                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1040                     // calculate prize and give it to winner
1041                     _prize = ((airDropPot_).mul(25)) / 100;
1042                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1043 
1044                     // adjust airDropPot
1045                     airDropPot_ = (airDropPot_).sub(_prize);
1046 
1047                     // let event know a tier 3 prize was won
1048                     _eventData_.compressedData += 300000000000000000000000000000000;
1049                 }
1050                 // set airdrop happened bool to true
1051                 _eventData_.compressedData += 10000000000000000000000000000000;
1052                 // let event know how much was won
1053                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1054 
1055                 // reset air drop tracker
1056                 airDropTracker_ = 0;
1057             }
1058         }
1059 
1060             // store the air drop tracker number (number of buys since last airdrop)
1061             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1062 
1063             // update player
1064             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1065             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1066 
1067             // update round
1068             round_[_rID].keys = _keys.add(round_[_rID].keys);
1069             round_[_rID].eth = _eth.add(round_[_rID].eth);
1070             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1071 
1072             // distribute eth
1073             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1074             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1075 
1076             // call end tx function to fire end tx event.
1077 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1078         }
1079     }
1080 //==============================================================================
1081 //     _ _ | _   | _ _|_ _  _ _  .
1082 //    (_(_||(_|_||(_| | (_)| _\  .
1083 //==============================================================================
1084     /**
1085      * @dev calculates unmasked earnings (just calculates, does not update mask)
1086      * @return earnings in wei format
1087      */
1088     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1089         private
1090         view
1091         returns(uint256)
1092     {
1093         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1094     }
1095 
1096     /**
1097      * @dev returns the amount of keys you would get given an amount of eth.
1098      * -functionhash- 0xce89c80c
1099      * @param _rID round ID you want price for
1100      * @param _eth amount of eth sent in
1101      * @return keys received
1102      */
1103     function calcKeysReceived(uint256 _rID, uint256 _eth)
1104         public
1105         view
1106         returns(uint256)
1107     {
1108         // grab time
1109         uint256 _now = now;
1110 
1111         // are we in a round?
1112         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1113             return ( (round_[_rID].eth).keysRec(_eth) );
1114         else // rounds over.  need keys for new round
1115             return ( (_eth).keys() );
1116     }
1117 
1118     /**
1119      * @dev returns current eth price for X keys.
1120      * -functionhash- 0xcf808000
1121      * @param _keys number of keys desired (in 18 decimal format)
1122      * @return amount of eth needed to send
1123      */
1124     function iWantXKeys(uint256 _keys)
1125         public
1126         view
1127         returns(uint256)
1128     {
1129         // setup local rID
1130         uint256 _rID = rID_;
1131 
1132         // grab time
1133         uint256 _now = now;
1134 
1135         // are we in a round?
1136         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1137             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1138         else // rounds over.  need price for new round
1139             return ( (_keys).eth() );
1140     }
1141 //==============================================================================
1142 //    _|_ _  _ | _  .
1143 //     | (_)(_)|_\  .
1144 //==============================================================================
1145     /**
1146 	 * @dev receives name/player info from names contract
1147      */
1148     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1149         external
1150     {
1151         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1152         if (pIDxAddr_[_addr] != _pID)
1153             pIDxAddr_[_addr] = _pID;
1154         if (pIDxName_[_name] != _pID)
1155             pIDxName_[_name] = _pID;
1156         if (plyr_[_pID].addr != _addr)
1157             plyr_[_pID].addr = _addr;
1158         if (plyr_[_pID].name != _name)
1159             plyr_[_pID].name = _name;
1160         if (plyr_[_pID].laff != _laff)
1161             plyr_[_pID].laff = _laff;
1162         if (plyrNames_[_pID][_name] == false)
1163             plyrNames_[_pID][_name] = true;
1164     }
1165 
1166     /**
1167      * @dev receives entire player name list
1168      */
1169     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1170         external
1171     {
1172         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1173         if(plyrNames_[_pID][_name] == false)
1174             plyrNames_[_pID][_name] = true;
1175     }
1176 
1177     /**
1178      * @dev gets existing or registers new pID.  use this when a player may be new
1179      * @return pID
1180      */
1181     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1182         private
1183         returns (F3Ddatasets.EventReturns)
1184     {
1185         uint256 _pID = pIDxAddr_[msg.sender];
1186         // if player is new to this version of fomo3d
1187         if (_pID == 0)
1188         {
1189             // grab their player ID, name and last aff ID, from player names contract
1190             _pID = PlayerBook.getPlayerID(msg.sender);
1191             bytes32 _name = PlayerBook.getPlayerName(_pID);
1192             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1193 
1194             // set up player account
1195             pIDxAddr_[msg.sender] = _pID;
1196             plyr_[_pID].addr = msg.sender;
1197 
1198             if (_name != "")
1199             {
1200                 pIDxName_[_name] = _pID;
1201                 plyr_[_pID].name = _name;
1202                 plyrNames_[_pID][_name] = true;
1203             }
1204 
1205             if (_laff != 0 && _laff != _pID)
1206                 plyr_[_pID].laff = _laff;
1207 
1208             // set the new player bool to true
1209             _eventData_.compressedData = _eventData_.compressedData + 1;
1210         }
1211         return (_eventData_);
1212     }
1213 
1214     /**
1215      * @dev checks to make sure user picked a valid team.  if not sets team
1216      * to default (sneks)
1217      */
1218     function verifyTeam(uint256 _team)
1219         private
1220         pure
1221         returns (uint256)
1222     {
1223         if (_team < 0 || _team > 3)
1224             return(2);
1225         else
1226             return(_team);
1227     }
1228 
1229     /**
1230      * @dev decides if round end needs to be run & new round started.  and if
1231      * player unmasked earnings from previously played rounds need to be moved.
1232      */
1233     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1234         private
1235         returns (F3Ddatasets.EventReturns)
1236     {
1237         // if player has played a previous round, move their unmasked earnings
1238         // from that round to gen vault.
1239         if (plyr_[_pID].lrnd != 0)
1240             updateGenVault(_pID, plyr_[_pID].lrnd);
1241 
1242         // update player's last round played
1243         plyr_[_pID].lrnd = rID_;
1244 
1245         // set the joined round bool to true
1246         _eventData_.compressedData = _eventData_.compressedData + 10;
1247 
1248         return(_eventData_);
1249     }
1250 
1251     /**
1252      * @dev ends the round. manages paying out winner/splitting up pot
1253      */
1254     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1255         private
1256         returns (F3Ddatasets.EventReturns)
1257     {
1258         // setup local rID
1259         uint256 _rID = rID_;
1260 
1261         // grab our winning player and team id's
1262         uint256 _winPID = round_[_rID].plyr;
1263         uint256 _winTID = round_[_rID].team;
1264 
1265         // grab our pot amount
1266         uint256 _pot = round_[_rID].pot;
1267 
1268         // calculate our winner share, community rewards, gen share,
1269         // p3d share, and amount reserved for next pot
1270         uint256 _win = (_pot.mul(48)) / 100;
1271         uint256 _com = (_pot / 50);
1272         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1273         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1274         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1275 
1276         // calculate ppt for round mask
1277         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1278         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1279         if (_dust > 0)
1280         {
1281             _gen = _gen.sub(_dust);
1282             _res = _res.add(_dust);
1283         }
1284 
1285         // pay our winner
1286         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1287 
1288         // community rewards
1289 
1290         admin.transfer(_com);
1291 
1292         admin.transfer(_p3d.sub(_p3d / 2));
1293 
1294         round_[_rID].pot = _pot.add(_p3d / 2);
1295 
1296         // distribute gen portion to key holders
1297         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1298 
1299         // prepare event data
1300         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1301         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1302         _eventData_.winnerAddr = plyr_[_winPID].addr;
1303         _eventData_.winnerName = plyr_[_winPID].name;
1304         _eventData_.amountWon = _win;
1305         _eventData_.genAmount = _gen;
1306         _eventData_.P3DAmount = _p3d;
1307         _eventData_.newPot = _res;
1308 
1309         // start next round
1310         rID_++;
1311         _rID++;
1312         round_[_rID].strt = now;
1313         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1314         round_[_rID].pot = _res;
1315 
1316         return(_eventData_);
1317     }
1318 
1319     /**
1320      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1321      */
1322     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1323         private
1324     {
1325         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1326         if (_earnings > 0)
1327         {
1328             // put in gen vault
1329             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1330             // zero out their earnings by updating mask
1331             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1332         }
1333     }
1334 
1335     /**
1336      * @dev updates round timer based on number of whole keys bought.
1337      */
1338     function updateTimer(uint256 _keys, uint256 _rID)
1339         private
1340     {
1341         // grab time
1342         uint256 _now = now;
1343 
1344         // calculate time based on number of keys bought
1345         uint256 _newTime;
1346         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1347             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1348         else
1349             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1350 
1351         // compare to max and set new end time
1352         if (_newTime < (rndMax_).add(_now))
1353             round_[_rID].end = _newTime;
1354         else
1355             round_[_rID].end = rndMax_.add(_now);
1356     }
1357 
1358     /**
1359      * @dev generates a random number between 0-99 and checks to see if thats
1360      * resulted in an airdrop win
1361      * @return do we have a winner?
1362      */
1363     function airdrop()
1364         private
1365         view
1366         returns(bool)
1367     {
1368         uint256 seed = uint256(keccak256(abi.encodePacked(
1369 
1370             (block.timestamp).add
1371             (block.difficulty).add
1372             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1373             (block.gaslimit).add
1374             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1375             (block.number)
1376 
1377         )));
1378         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1379             return(true);
1380         else
1381             return(false);
1382     }
1383 
1384     /**
1385      * @dev distributes eth based on fees to com, aff, and p3d
1386      */
1387     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1388         private
1389         returns(F3Ddatasets.EventReturns)
1390     {
1391         // pay 3% out to community rewards
1392         uint256 _p1 = _eth / 100;
1393         uint256 _com = _eth / 50;
1394         _com = _com.add(_p1);
1395 
1396         uint256 _p3d;
1397         if (!address(admin).call.value(_com)())
1398         {
1399             // This ensures Team Just cannot influence the outcome of FoMo3D with
1400             // bank migrations by breaking outgoing transactions.
1401             // Something we would never do. But that's not the point.
1402             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1403             // highest belief that everything we create should be trustless.
1404             // Team JUST, The name you shouldn't have to trust.
1405             _p3d = _com;
1406             _com = 0;
1407         }
1408 
1409 
1410         // distribute share to affiliate
1411         uint256 _aff = _eth / 10;
1412 
1413         // decide what to do with affiliate share of fees
1414         // affiliate must not be self, and must have a name registered
1415         if (_affID != _pID && plyr_[_affID].name != '') {
1416             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1417             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1418         } else {
1419             _p3d = _aff;
1420         }
1421 
1422         // pay out p3d
1423         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1424         if (_p3d > 0)
1425         {
1426             // deposit to divies contract
1427             uint256 _potAmount = _p3d / 2;
1428 
1429             admin.transfer(_p3d.sub(_potAmount));
1430 
1431             round_[_rID].pot = round_[_rID].pot.add(_potAmount);
1432 
1433             // set up event data
1434             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1435         }
1436 
1437         return(_eventData_);
1438     }
1439 
1440     function potSwap()
1441         external
1442         payable
1443     {
1444         // setup local rID
1445         uint256 _rID = rID_ + 1;
1446 
1447         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1448         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1449     }
1450 
1451     /**
1452      * @dev distributes eth based on fees to gen and pot
1453      */
1454     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1455         private
1456         returns(F3Ddatasets.EventReturns)
1457     {
1458         // calculate gen share
1459         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1460 
1461         // toss 1% into airdrop pot
1462         uint256 _air = (_eth / 100);
1463         airDropPot_ = airDropPot_.add(_air);
1464 
1465         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1466         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1467 
1468         // calculate pot
1469         uint256 _pot = _eth.sub(_gen);
1470 
1471         // distribute gen share (thats what updateMasks() does) and adjust
1472         // balances for dust.
1473         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1474         if (_dust > 0)
1475             _gen = _gen.sub(_dust);
1476 
1477         // add eth to pot
1478         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1479 
1480         // set up event data
1481         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1482         _eventData_.potAmount = _pot;
1483 
1484         return(_eventData_);
1485     }
1486 
1487     /**
1488      * @dev updates masks for round and player when keys are bought
1489      * @return dust left over
1490      */
1491     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1492         private
1493         returns(uint256)
1494     {
1495         /* MASKING NOTES
1496             earnings masks are a tricky thing for people to wrap their minds around.
1497             the basic thing to understand here.  is were going to have a global
1498             tracker based on profit per share for each round, that increases in
1499             relevant proportion to the increase in share supply.
1500 
1501             the player will have an additional mask that basically says "based
1502             on the rounds mask, my shares, and how much i've already withdrawn,
1503             how much is still owed to me?"
1504         */
1505 
1506         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1507         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1508         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1509 
1510         // calculate player earning from their own buy (only based on the keys
1511         // they just bought).  & update player earnings mask
1512         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1513         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1514 
1515         // calculate & return dust
1516         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1517     }
1518 
1519     /**
1520      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1521      * @return earnings in wei format
1522      */
1523     function withdrawEarnings(uint256 _pID)
1524         private
1525         returns(uint256)
1526     {
1527         // update gen vault
1528         updateGenVault(_pID, plyr_[_pID].lrnd);
1529 
1530         // from vaults
1531         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1532         if (_earnings > 0)
1533         {
1534             plyr_[_pID].win = 0;
1535             plyr_[_pID].gen = 0;
1536             plyr_[_pID].aff = 0;
1537         }
1538 
1539         return(_earnings);
1540     }
1541 
1542     /**
1543      * @dev prepares compression data and fires event for buy or reload tx's
1544      */
1545     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1546         private
1547     {
1548         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1549         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1550 
1551         emit F3Devents.onEndTx
1552         (
1553             _eventData_.compressedData,
1554             _eventData_.compressedIDs,
1555             plyr_[_pID].name,
1556             msg.sender,
1557             _eth,
1558             _keys,
1559             _eventData_.winnerAddr,
1560             _eventData_.winnerName,
1561             _eventData_.amountWon,
1562             _eventData_.newPot,
1563             _eventData_.P3DAmount,
1564             _eventData_.genAmount,
1565             _eventData_.potAmount,
1566             airDropPot_
1567         );
1568     }
1569 //==============================================================================
1570 //    (~ _  _    _._|_    .
1571 //    _)(/_(_|_|| | | \/  .
1572 //====================/=========================================================
1573     /** upon contract deploy, it will be deactivated.  this is a one time
1574      * use function that will activate the contract.  we do this so devs
1575      * have time to set things up on the web end                            **/
1576     bool public activated_ = false;
1577     function activate()
1578         public
1579     {
1580         // only team just can activate
1581         require(msg.sender == admin, "only admin can activate");
1582 
1583 
1584         // can only be ran once
1585         require(activated_ == false, "FOMO Short already activated");
1586 
1587         // activate the contract
1588         activated_ = true;
1589 
1590         // lets start first round
1591         rID_ = 1;
1592             round_[1].strt = now + rndExtra_ - rndGap_;
1593             round_[1].end = now + rndInit_ + rndExtra_;
1594     }
1595 }
1596 
1597 //==============================================================================
1598 //   __|_ _    __|_ _  .
1599 //  _\ | | |_|(_ | _\  .
1600 //==============================================================================
1601 library F3Ddatasets {
1602     //compressedData key
1603     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1604         // 0 - new player (bool)
1605         // 1 - joined round (bool)
1606         // 2 - new  leader (bool)
1607         // 3-5 - air drop tracker (uint 0-999)
1608         // 6-16 - round end time
1609         // 17 - winnerTeam
1610         // 18 - 28 timestamp
1611         // 29 - team
1612         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1613         // 31 - airdrop happened bool
1614         // 32 - airdrop tier
1615         // 33 - airdrop amount won
1616     //compressedIDs key
1617     // [77-52][51-26][25-0]
1618         // 0-25 - pID
1619         // 26-51 - winPID
1620         // 52-77 - rID
1621     struct EventReturns {
1622         uint256 compressedData;
1623         uint256 compressedIDs;
1624         address winnerAddr;         // winner address
1625         bytes32 winnerName;         // winner name
1626         uint256 amountWon;          // amount won
1627         uint256 newPot;             // amount in new pot
1628         uint256 P3DAmount;          // amount distributed to p3d
1629         uint256 genAmount;          // amount distributed to gen
1630         uint256 potAmount;          // amount added to pot
1631     }
1632     struct Player {
1633         address addr;   // player address
1634         bytes32 name;   // player name
1635         uint256 win;    // winnings vault
1636         uint256 gen;    // general vault
1637         uint256 aff;    // affiliate vault
1638         uint256 lrnd;   // last round played
1639         uint256 laff;   // last affiliate id used
1640     }
1641     struct PlayerRounds {
1642         uint256 eth;    // eth player has added to round (used for eth limiter)
1643         uint256 keys;   // keys
1644         uint256 mask;   // player mask
1645         uint256 ico;    // ICO phase investment
1646     }
1647     struct Round {
1648         uint256 plyr;   // pID of player in lead
1649         uint256 team;   // tID of team in lead
1650         uint256 end;    // time ends/ended
1651         bool ended;     // has round end function been ran
1652         uint256 strt;   // time round started
1653         uint256 keys;   // keys
1654         uint256 eth;    // total eth in
1655         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1656         uint256 mask;   // global mask
1657         uint256 ico;    // total eth sent in during ICO phase
1658         uint256 icoGen; // total eth for gen during ICO phase
1659         uint256 icoAvg; // average key price for ICO phase
1660     }
1661     struct TeamFee {
1662         uint256 gen;    // % of buy in thats paid to key holders of current round
1663         uint256 p3d;    // % of buy in thats paid to p3d holders
1664     }
1665     struct PotSplit {
1666         uint256 gen;    // % of pot thats paid to key holders of current round
1667         uint256 p3d;    // % of pot thats paid to p3d holders
1668     }
1669 }
1670 
1671 //==============================================================================
1672 //  |  _      _ _ | _  .
1673 //  |<(/_\/  (_(_||(_  .
1674 //=======/======================================================================
1675 library F3DKeysCalcShort {
1676     using SafeMath for *;
1677     /**
1678      * @dev calculates number of keys received given X eth
1679      * @param _curEth current amount of eth in contract
1680      * @param _newEth eth being spent
1681      * @return amount of ticket purchased
1682      */
1683     function keysRec(uint256 _curEth, uint256 _newEth)
1684         internal
1685         pure
1686         returns (uint256)
1687     {
1688         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1689     }
1690 
1691     /**
1692      * @dev calculates amount of eth received if you sold X keys
1693      * @param _curKeys current amount of keys that exist
1694      * @param _sellKeys amount of keys you wish to sell
1695      * @return amount of eth received
1696      */
1697     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1698         internal
1699         pure
1700         returns (uint256)
1701     {
1702         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1703     }
1704 
1705     /**
1706      * @dev calculates how many keys would exist with given an amount of eth
1707      * @param _eth eth "in contract"
1708      * @return number of keys that would exist
1709      */
1710     function keys(uint256 _eth)
1711         internal
1712         pure
1713         returns(uint256)
1714     {
1715         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1716     }
1717 
1718     /**
1719      * @dev calculates how much eth would be in contract given a number of keys
1720      * @param _keys number of keys "in contract"
1721      * @return eth that would exists
1722      */
1723     function eth(uint256 _keys)
1724         internal
1725         pure
1726         returns(uint256)
1727     {
1728         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1729     }
1730 }
1731 
1732 //==============================================================================
1733 //  . _ _|_ _  _ |` _  _ _  _  .
1734 //  || | | (/_| ~|~(_|(_(/__\  .
1735 //==============================================================================
1736 
1737 interface PlayerBookInterface {
1738     function getPlayerID(address _addr) external returns (uint256);
1739     function getPlayerName(uint256 _pID) external view returns (bytes32);
1740     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1741     function getPlayerAddr(uint256 _pID) external view returns (address);
1742     function getNameFee() external view returns (uint256);
1743     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1744     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1745     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1746 }
1747 
1748 /**
1749 * @title -Name Filter- v0.1.9
1750 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1751 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1752 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1753 *                                  _____                      _____
1754 *                                 (, /     /)       /) /)    (, /      /)          /)
1755 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1756 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1757 *          ┴ ┴                /   /          .-/ _____   (__ /
1758 *                            (__ /          (_/ (, /                                      /)™
1759 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1760 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1761 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1762 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1763 *              _       __    _      ____      ____  _   _    _____  ____  ___
1764 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1765 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1766 *
1767 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1768 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1769 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1770 */
1771 
1772 library NameFilter {
1773     /**
1774      * @dev filters name strings
1775      * -converts uppercase to lower case.
1776      * -makes sure it does not start/end with a space
1777      * -makes sure it does not contain multiple spaces in a row
1778      * -cannot be only numbers
1779      * -cannot start with 0x
1780      * -restricts characters to A-Z, a-z, 0-9, and space.
1781      * @return reprocessed string in bytes32 format
1782      */
1783     function nameFilter(string _input)
1784         internal
1785         pure
1786         returns(bytes32)
1787     {
1788         bytes memory _temp = bytes(_input);
1789         uint256 _length = _temp.length;
1790 
1791         //sorry limited to 32 characters
1792         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1793         // make sure it doesnt start with or end with space
1794         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1795         // make sure first two characters are not 0x
1796         if (_temp[0] == 0x30)
1797         {
1798             require(_temp[1] != 0x78, "string cannot start with 0x");
1799             require(_temp[1] != 0x58, "string cannot start with 0X");
1800         }
1801 
1802         // create a bool to track if we have a non number character
1803         bool _hasNonNumber;
1804 
1805         // convert & check
1806         for (uint256 i = 0; i < _length; i++)
1807         {
1808             // if its uppercase A-Z
1809             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1810             {
1811                 // convert to lower case a-z
1812                 _temp[i] = byte(uint(_temp[i]) + 32);
1813 
1814                 // we have a non number
1815                 if (_hasNonNumber == false)
1816                     _hasNonNumber = true;
1817             } else {
1818                 require
1819                 (
1820                     // require character is a space
1821                     _temp[i] == 0x20 ||
1822                     // OR lowercase a-z
1823                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1824                     // or 0-9
1825                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1826                     "string contains invalid characters"
1827                 );
1828                 // make sure theres not 2x spaces in a row
1829                 if (_temp[i] == 0x20)
1830                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1831 
1832                 // see if we have a character other than a number
1833                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1834                     _hasNonNumber = true;
1835             }
1836         }
1837 
1838         require(_hasNonNumber == true, "string cannot be only numbers");
1839 
1840         bytes32 _ret;
1841         assembly {
1842             _ret := mload(add(_temp, 32))
1843         }
1844         return (_ret);
1845     }
1846 }
1847 
1848 /**
1849  * @title SafeMath v0.1.9
1850  * @dev Math operations with safety checks that throw on error
1851  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1852  * - added sqrt
1853  * - added sq
1854  * - added pwr
1855  * - changed asserts to requires with error log outputs
1856  * - removed div, its useless
1857  */
1858 library SafeMath {
1859 
1860     /**
1861     * @dev Multiplies two numbers, throws on overflow.
1862     */
1863     function mul(uint256 a, uint256 b)
1864         internal
1865         pure
1866         returns (uint256 c)
1867     {
1868         if (a == 0) {
1869             return 0;
1870         }
1871         c = a * b;
1872         require(c / a == b, "SafeMath mul failed");
1873         return c;
1874     }
1875 
1876     /**
1877     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1878     */
1879     function sub(uint256 a, uint256 b)
1880         internal
1881         pure
1882         returns (uint256)
1883     {
1884         require(b <= a, "SafeMath sub failed");
1885         return a - b;
1886     }
1887 
1888     /**
1889     * @dev Adds two numbers, throws on overflow.
1890     */
1891     function add(uint256 a, uint256 b)
1892         internal
1893         pure
1894         returns (uint256 c)
1895     {
1896         c = a + b;
1897         require(c >= a, "SafeMath add failed");
1898         return c;
1899     }
1900 
1901     /**
1902      * @dev gives square root of given x.
1903      */
1904     function sqrt(uint256 x)
1905         internal
1906         pure
1907         returns (uint256 y)
1908     {
1909         uint256 z = ((add(x,1)) / 2);
1910         y = x;
1911         while (z < y)
1912         {
1913             y = z;
1914             z = ((add((x / z),z)) / 2);
1915         }
1916     }
1917 
1918     /**
1919      * @dev gives square. multiplies x by x
1920      */
1921     function sq(uint256 x)
1922         internal
1923         pure
1924         returns (uint256)
1925     {
1926         return (mul(x,x));
1927     }
1928 
1929     /**
1930      * @dev x to the power of y
1931      */
1932     function pwr(uint256 x, uint256 y)
1933         internal
1934         pure
1935         returns (uint256)
1936     {
1937         if (x==0)
1938             return (0);
1939         else if (y==0)
1940             return (1);
1941         else
1942         {
1943             uint256 z = x;
1944             for (uint256 i=1; i < y; i++)
1945                 z = mul(z,x);
1946             return (z);
1947         }
1948     }
1949 }