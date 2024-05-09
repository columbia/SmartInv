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
28  *====|   | ,'=============='---'==========(long version)===========\   \     .'===|   ,.'======*
29  *    `----'                                                         `--`-,,-'     '---'
30  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐
31  *             ║ ║├┤ ├┤ ││  │├─┤│   │   https://exitscam.me   │ ║║║├┤ ├┴┐╚═╗│ │ ├┤
32  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘
33  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
34  *   │╔═╗┌─┐┬  ┬┌┬┐┬┌┬┐┬ ┬   ╔╦╗┌─┐┌─┐┬┌─┐┌┐┌   ╦┌┐┌┌┬┐┌─┐┬─┐┌─┐┌─┐┌─┐┌─┐   ╔═╗┌┬┐┌─┐┌─┐┬┌─│
35  *   │╚═╗│ ││  │ │││ │ └┬┘ ═  ║║├┤ └─┐││ ┬│││ ═ ║│││ │ ├┤ ├┬┘├┤ ├─┤│  ├┤  ═ ╚═╗ │ ├─┤│  ├┴┐│
36  *   │╚═╝└─┘┴─┘┴─┴┘┴ ┴  ┴    ═╩╝└─┘└─┘┴└─┘┘└┘   ╩┘└┘ ┴ └─┘┴└─└  ┴ ┴└─┘└─┘   ╚═╝ ┴ ┴ ┴└─┘┴ ┴│
37  *   │    ┌──────────┐           ┌───────┐            ┌─────────┐              ┌────────┐  │
38  *   └────┤ Inventor ├───────────┤ Justo ├────────────┤ Sumpunk ├──────────────┤ Mantso ├──┘
39  *        └──────────┘           └───────┘            └─────────┘              └────────┘
40  *   ┌─────────────────────────────────────────────────────────┐ ╔╦╗┬ ┬┌─┐┌┐┌┬┌─┌─┐  ╔╦╗┌─┐
41  *   │ Ambius, Aritz Cracker, Cryptoknight, Crypto McPump,     │  ║ ├─┤├─┤│││├┴┐└─┐   ║ │ │
42  *   │ Capex, JogFera, The Shocker, Daok, Randazzz, PumpRabbi, │  ╩ ┴ ┴┴ ┴┘└┘┴ ┴└─┘   ╩ └─┘
43  *   │ Kadaz, Incognito Jo, Lil Stronghands, Ninja Turtle,     └───────────────────────────┐
44  *   │ Psaints, Satoshi, Vitalik, Nano 2nd, Bogdanoffs         Isaac Newton, Nikola Tesla, │
45  *   │ Le Comte De Saint Germain, Albert Einstein, Socrates, & all the volunteer moderator │
46  *   │ & support staff, content, creators, autonomous agents, and indie devs for P3D.      │
47  *   │              Without your help, we wouldn't have the time to code this.             │
48  *   └─────────────────────────────────────────────────────────────────────────────────────┘
49  *
50  * This product is protected under license.  Any unauthorized copy, modification, or use without
51  * express written consent from the creators is prohibited.
52  *
53  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
54  */
55 
56 //==============================================================================
57 //     _    _  _ _|_ _  .
58 //    (/_\/(/_| | | _\  .
59 //==============================================================================
60 contract Star3Devents {
61     // fired whenever a player registers a name
62     event onNewName
63     (
64         uint256 indexed playerID,
65         address indexed playerAddress,
66         bytes32 indexed playerName,
67         bool isNewPlayer,
68         uint256 affiliateID,
69         address affiliateAddress,
70         bytes32 affiliateName,
71         uint256 amountPaid,
72         uint256 timeStamp
73     );
74 
75     // fired at end of buy or reload
76     event onEndTx
77     (
78         uint256 compressedData,
79         uint256 compressedIDs,
80         bytes32 playerName,
81         address playerAddress,
82         uint256 ethIn,
83         uint256 keysBought,
84         address winnerAddr,
85         bytes32 winnerName,
86         uint256 amountWon,
87         uint256 newPot,
88         uint256 genAmount,
89         uint256 potAmount
90     );
91 
92 	// fired whenever theres a withdraw
93     event onWithdraw
94     (
95         uint256 indexed playerID,
96         address playerAddress,
97         bytes32 playerName,
98         uint256 ethOut,
99         uint256 timeStamp
100     );
101 
102     // fired whenever a withdraw forces end round to be ran
103     event onWithdrawAndDistribute
104     (
105         address playerAddress,
106         bytes32 playerName,
107         uint256 ethOut,
108         uint256 compressedData,
109         uint256 compressedIDs,
110         address winnerAddr,
111         bytes32 winnerName,
112         uint256 amountWon,
113         uint256 newPot,
114         uint256 genAmount
115     );
116 
117     // (fomo3d long only) fired whenever a player tries a buy after round timer
118     // hit zero, and causes end round to be ran.
119     event onBuyAndDistribute
120     (
121         address playerAddress,
122         bytes32 playerName,
123         uint256 ethIn,
124         uint256 compressedData,
125         uint256 compressedIDs,
126         address winnerAddr,
127         bytes32 winnerName,
128         uint256 amountWon,
129         uint256 newPot,
130         uint256 genAmount
131     );
132 
133     // (fomo3d long only) fired whenever a player tries a reload after round timer
134     // hit zero, and causes end round to be ran.
135     event onReLoadAndDistribute
136     (
137         address playerAddress,
138         bytes32 playerName,
139         uint256 compressedData,
140         uint256 compressedIDs,
141         address winnerAddr,
142         bytes32 winnerName,
143         uint256 amountWon,
144         uint256 newPot,
145         uint256 genAmount
146     );
147 
148     // fired whenever an affiliate is paid
149     event onAffiliatePayout
150     (
151         uint256 indexed affiliateID,
152         address affiliateAddress,
153         bytes32 affiliateName,
154         uint256 indexed roundID,
155         uint256 indexed buyerID,
156         uint256 amount,
157         uint256 timeStamp
158     );
159 
160     // received pot swap deposit
161     event onPotSwapDeposit
162     (
163         uint256 roundID,
164         uint256 amountAddedToPot
165     );
166 }
167 
168 //==============================================================================
169 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
170 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
171 //====================================|=========================================
172 
173 contract modularLong is Star3Devents {}
174 
175 contract Star3Dlong is modularLong {
176     using SafeMath for *;
177     using NameFilter for string;
178     using Star3DKeysCalcLong for uint256;
179 
180 //==============================================================================
181 //     _ _  _  |`. _     _ _ |_ | _  _  .
182 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
183 //=================_|===========================================================
184     string constant public name = "Save the planet";
185     string constant public symbol = "Star";
186     uint256 private pID_ = 0;   // total number of players
187 	uint256 private rndExtra_ = 1 hours;     // length of the very first ICO
188     uint256 private rndGap_ = 1 seconds;         // length of ICO phase, set to 1 year for EOS.
189     uint256 constant private rndInit_ = 10 hours;                // round timer starts at this
190     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
191     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
192     uint256 public registrationFee_ = 10 finney;            // price to register a name
193 
194 //==============================================================================
195 //     _| _ _|_ _    _ _ _|_    _   .
196 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
197 //=============================|================================================
198 //	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
199     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
200     uint256 public rID_;    // round id number / total rounds that have happened
201 //****************
202 // PLAYER DATA
203 //****************
204     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
205     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
206     mapping (uint256 => Star3Ddatasets.Player) public plyr_;   // (pID => data) player data
207     mapping (uint256 => mapping (uint256 => Star3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
208     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
209 //****************
210 // ROUND DATA
211 //****************
212     mapping (uint256 => Star3Ddatasets.Round) public round_;   // (rID => data) round data
213     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
214 //****************
215 // TEAM FEE DATA
216 //****************
217     mapping (uint256 => Star3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
218     mapping (uint256 => Star3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
219 //==============================================================================
220 //     _ _  _  __|_ _    __|_ _  _  .
221 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
222 //==============================================================================
223     constructor()
224         public
225     {
226 		// Team allocation structures
227         // 0 = whales
228         // 1 = bears
229         // 2 = sneks
230         // 3 = bulls
231 
232 		// Team allocation percentages
233         // (Star, None) + (Pot , Referrals, Community)
234             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
235         fees_[0] = Star3Ddatasets.TeamFee(32, 48, 10);   //32% to pot, 56% to gen, 2% to dev, 48% to winner, 10% aff
236         fees_[1] = Star3Ddatasets.TeamFee(45, 35, 10);   //45% to pot, 35% to gen, 2% to dev, 48% to winner, 10% aff
237         fees_[2] = Star3Ddatasets.TeamFee(50, 30, 10);  //50% to pot, 30% to gen, 2% to dev, 48% to winner, 10% aff
238         fees_[3] = Star3Ddatasets.TeamFee(40, 40, 10);   //48% to pot, 40% to gen, 2% to dev, 48% to winner, 10% aff
239 
240 //        // how to split up the final pot based on which team was picked
241 //        // (Star, None)
242         potSplit_[0] = Star3Ddatasets.PotSplit(20, 30);  //48% to winner, 20% to next round, 30% to gen, 2% to com
243         potSplit_[1] = Star3Ddatasets.PotSplit(15, 35);   //48% to winner, 15% to next round, 35% to gen, 2% to com
244         potSplit_[2] = Star3Ddatasets.PotSplit(25, 25);  //48% to winner, 25% to next round, 25% to gen, 2% to com
245         potSplit_[3] = Star3Ddatasets.PotSplit(30, 20);  //48% to winner, 30% to next round, 20% to gen, 2% to com
246 	}
247 //==============================================================================
248 //     _ _  _  _|. |`. _  _ _  .
249 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
250 //==============================================================================
251     /**
252      * @dev used to make sure no one can interact with contract until it has
253      * been activated.
254      */
255     modifier isActivated() {
256         require(activated_ == true, "its not ready yet.  check ?eta in discord");
257         _;
258     }
259 
260     modifier isRegisteredName()
261     {
262         uint256 _pID = pIDxAddr_[msg.sender];
263         require(plyr_[_pID].name == "" || _pID == 0, "already has name");
264         _;
265     }
266     /**
267      * @dev prevents contracts from interacting with fomo3d
268      */
269     modifier isHuman() {
270         address _addr = msg.sender;
271         uint256 _codeLength;
272 
273         assembly {_codeLength := extcodesize(_addr)}
274         require(_codeLength == 0, "sorry humans only");
275         _;
276     }
277 
278     /**
279      * @dev sets boundaries for incoming tx
280      */
281     modifier isWithinLimits(uint256 _eth) {
282         require(_eth >= 1000000000, "pocket lint: not a valid currency");
283         require(_eth <= 100000000000000000000000, "no vitalik, no");
284         _;
285     }
286 
287 //==============================================================================
288 //     _    |_ |. _   |`    _  __|_. _  _  _  .
289 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
290 //====|=========================================================================
291     /**
292      * @dev emergency buy uses last stored affiliate ID and team snek
293      */
294     function()
295         isActivated()
296         isHuman()
297         isWithinLimits(msg.value)
298         public
299         payable
300     {
301         // set up our tx event data and determine if player is new or not
302         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
303 
304         // fetch player id
305         uint256 _pID = pIDxAddr_[msg.sender];
306 
307         // buy core
308         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
309     }
310 
311     /**
312      * @dev converts all incoming ethereum to keys.
313      * -functionhash- 0x8f38f309 (using ID for affiliate)
314      * -functionhash- 0x98a0871d (using address for affiliate)
315      * -functionhash- 0xa65b37a1 (using name for affiliate)
316      * @param _affCode the ID/address/name of the player who gets the affiliate fee
317      * @param _team what team is the player playing for?
318      */
319     function buyXid(uint256 _affCode, uint256 _team)
320         isActivated()
321         isHuman()
322         isWithinLimits(msg.value)
323         public
324         payable
325     {
326         // set up our tx event data and determine if player is new or not
327         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
328 
329         // fetch player id
330         uint256 _pID = pIDxAddr_[msg.sender];
331 
332         // manage affiliate residuals
333         // if no affiliate code was given or player tried to use their own, lolz
334         if (_affCode == 0 || _affCode == _pID)
335         {
336             // use last stored affiliate code
337             _affCode = plyr_[_pID].laff;
338 
339         // if affiliate code was given & its not the same as previously stored
340         } else if (_affCode != plyr_[_pID].laff) {
341             // update last affiliate
342             plyr_[_pID].laff = _affCode;
343         }
344 
345         // verify a valid team was selected
346         _team = verifyTeam(_team);
347 
348         // buy core
349         buyCore(_pID, _affCode, _team, _eventData_);
350     }
351 
352     function buyXaddr(address _affCode, uint256 _team)
353         isActivated()
354         isHuman()
355         isWithinLimits(msg.value)
356         public
357         payable
358     {
359         // set up our tx event data and determine if player is new or not
360         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
361 
362         // fetch player id
363         uint256 _pID = pIDxAddr_[msg.sender];
364 
365         // verify a valid team was selected
366         _team = verifyTeam(_team);
367         // manage affiliate residuals
368         uint256 _affID;
369         // if no affiliate code was given or player tried to use their own, lolz
370         if (_affCode == address(0) || _affCode == msg.sender)
371         {
372             // use last stored affiliate code
373             _affID = plyr_[_pID].laff;
374 
375         // if affiliate code was given
376         } else {
377             // get affiliate ID from aff Code
378             _affID = pIDxAddr_[_affCode];
379 
380             // if affID is not the same as previously stored
381             if (_affID != plyr_[_pID].laff)
382             {
383                 // update last affiliate
384                 plyr_[_pID].laff = _affID;
385             }
386         }
387         // buy core
388         buyCore(_pID, _affID, _team, _eventData_);
389     }
390 
391     function buyXname(bytes32 _affCode, uint256 _team)
392         isActivated()
393         isHuman()
394         isWithinLimits(msg.value)
395         public
396         payable
397     {
398         // set up our tx event data and determine if player is new or not
399         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
400 
401         // fetch player id
402         uint256 _pID = pIDxAddr_[msg.sender];
403 
404         // manage affiliate residuals
405         uint256 _affID;
406         // if no affiliate code was given or player tried to use their own, lolz
407         if (_affCode == '' || _affCode == plyr_[_pID].name)
408         {
409             // use last stored affiliate code
410             _affID = plyr_[_pID].laff;
411 
412         // if affiliate code was given
413         } else {
414             // get affiliate ID from aff Code
415             _affID = pIDxName_[_affCode];
416 
417             // if affID is not the same as previously stored
418             if (_affID != plyr_[_pID].laff)
419             {
420                 // update last affiliate
421                 plyr_[_pID].laff = _affID;
422             }
423         }
424 
425         // verify a valid team was selected
426         _team = verifyTeam(_team);
427 
428         // buy core
429         buyCore(_pID, _affID, _team, _eventData_);
430     }
431 
432     /**
433      * @dev essentially the same as buy, but instead of you sending ether
434      * from your wallet, it uses your unwithdrawn earnings.
435      * -functionhash- 0x349cdcac (using ID for affiliate)
436      * -functionhash- 0x82bfc739 (using address for affiliate)
437      * -functionhash- 0x079ce327 (using name for affiliate)
438      * @param _affCode the ID/address/name of the player who gets the affiliate fee
439      * @param _team what team is the player playing for?
440      * @param _eth amount of earnings to use (remainder returned to gen vault)
441      */
442     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
443         isActivated()
444         isHuman()
445         isWithinLimits(_eth)
446         public
447     {
448         // set up our tx event data
449         Star3Ddatasets.EventReturns memory _eventData_;
450 
451         // fetch player ID
452         uint256 _pID = pIDxAddr_[msg.sender];
453 
454         // manage affiliate residuals
455         // if no affiliate code was given or player tried to use their own, lolz
456         if (_affCode == 0 || _affCode == _pID)
457         {
458             // use last stored affiliate code
459             _affCode = plyr_[_pID].laff;
460 
461         // if affiliate code was given & its not the same as previously stored
462         } else if (_affCode != plyr_[_pID].laff) {
463             // update last affiliate
464             plyr_[_pID].laff = _affCode;
465         }
466 
467         // verify a valid team was selected
468         _team = verifyTeam(_team);
469 
470         // reload core
471         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
472     }
473 
474     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
475         isActivated()
476         isHuman()
477         isWithinLimits(_eth)
478         public
479     {
480         // set up our tx event data
481         Star3Ddatasets.EventReturns memory _eventData_;
482 
483         // fetch player ID
484         uint256 _pID = pIDxAddr_[msg.sender];
485 
486         // manage affiliate residuals
487         uint256 _affID;
488         // if no affiliate code was given or player tried to use their own, lolz
489         if (_affCode == address(0) || _affCode == msg.sender)
490         {
491             // use last stored affiliate code
492             _affID = plyr_[_pID].laff;
493 
494         // if affiliate code was given
495         } else {
496             // get affiliate ID from aff Code
497             _affID = pIDxAddr_[_affCode];
498 
499             // if affID is not the same as previously stored
500             if (_affID != plyr_[_pID].laff)
501             {
502                 // update last affiliate
503                 plyr_[_pID].laff = _affID;
504             }
505         }
506 
507         // verify a valid team was selected
508         _team = verifyTeam(_team);
509 
510         // reload core
511         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
512     }
513 
514     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
515         isActivated()
516         isHuman()
517         isWithinLimits(_eth)
518         public
519     {
520         // set up our tx event data
521         Star3Ddatasets.EventReturns memory _eventData_;
522 
523         // fetch player ID
524         uint256 _pID = pIDxAddr_[msg.sender];
525 
526         // manage affiliate residuals
527         uint256 _affID;
528         // if no affiliate code was given or player tried to use their own, lolz
529         if (_affCode == '' || _affCode == plyr_[_pID].name)
530         {
531             // use last stored affiliate code
532             _affID = plyr_[_pID].laff;
533 
534         // if affiliate code was given
535         } else {
536             // get affiliate ID from aff Code
537             _affID = pIDxName_[_affCode];
538 
539             // if affID is not the same as previously stored
540             if (_affID != plyr_[_pID].laff)
541             {
542                 // update last affiliate
543                 plyr_[_pID].laff = _affID;
544             }
545         }
546 
547         // verify a valid team was selected
548         _team = verifyTeam(_team);
549 
550         // reload core
551         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
552     }
553 
554     /**
555      * @dev withdraws all of your earnings.
556      * -functionhash- 0x3ccfd60b
557      */
558     function withdraw()
559         isActivated()
560         isHuman()
561         public
562     {
563         // setup local rID
564         uint256 _rID = rID_;
565 
566         // grab time
567         uint256 _now = now;
568 
569         // fetch player ID
570         uint256 _pID = pIDxAddr_[msg.sender];
571 
572         // setup temp var for player eth
573         uint256 _eth;
574 
575         // check to see if round has ended and no one has run round end yet
576         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
577         {
578             // set up our tx event data
579             Star3Ddatasets.EventReturns memory _eventData_;
580 
581             // end the round (distributes pot)
582 			round_[_rID].ended = true;
583             _eventData_ = endRound(_eventData_);
584 
585 			// get their earnings
586             _eth = withdrawEarnings(_pID);
587 
588             // gib moni
589             if (_eth > 0)
590                 plyr_[_pID].addr.transfer(_eth);
591 
592             // build event data
593             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
594             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
595 
596             // fire withdraw and distribute event
597             emit Star3Devents.onWithdrawAndDistribute
598             (
599                 msg.sender,
600                 plyr_[_pID].name,
601                 _eth,
602                 _eventData_.compressedData,
603                 _eventData_.compressedIDs,
604                 _eventData_.winnerAddr,
605                 _eventData_.winnerName,
606                 _eventData_.amountWon,
607                 _eventData_.newPot,
608                 _eventData_.genAmount
609             );
610 
611         // in any other situation
612         } else {
613             // get their earnings
614             _eth = withdrawEarnings(_pID);
615 
616             // gib moni
617             if (_eth > 0)
618                 plyr_[_pID].addr.transfer(_eth);
619 
620             // fire withdraw event
621             emit Star3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
622         }
623     }
624 
625 
626     /**
627      * @dev use these to register names.  they are just wrappers that will send the
628      * registration requests to the PlayerBook contract.  So registering here is the
629      * same as registering there.  UI will always display the last name you registered.
630      * but you will still own all previously registered names to use as affiliate
631      * links.
632      * - must pay a registration fee.
633      * - name must be unique
634      * - names will be converted to lowercase
635      * - name cannot start or end with a space
636      * - cannot have more than 1 space in a row
637      * - cannot be only numbers
638      * - cannot start with 0x
639      * - name must be at least 1 char
640      * - max length of 32 characters long
641      * - allowed characters: a-z, 0-9, and space
642      * -functionhash- 0x921dec21 (using ID for affiliate)
643      * -functionhash- 0x3ddd4698 (using address for affiliate)
644      * -functionhash- 0x685ffd83 (using name for affiliate)
645      * @param _nameString players desired name
646      * @param _affCode affiliate ID, address, or name of who referred you
647      * (this might cost a lot of gas)
648      */
649     function registerNameXID(string _nameString, uint256 _affCode)
650         isHuman()
651         isRegisteredName()
652         public
653         payable
654     {
655         bytes32 _name = _nameString.nameFilter();
656         address _addr = msg.sender;
657         uint256 _paid = msg.value;
658 
659         bool _isNewPlayer = isNewPlayer(_addr);
660         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
661 
662         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
663 
664         uint256 _pID = makePlayerID(msg.sender);
665         uint256 _affID = _affCode;
666         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
667         {
668             // update last affiliate
669             plyr_[_pID].laff = _affID;
670         } else if (_affID == _pID) {
671             _affID = 0;
672         }
673         registerNameCore(_pID, _name);
674         // fire event
675         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
676     }
677 
678     function registerNameXaddr(string _nameString, address _affCode)
679         isHuman()
680         isRegisteredName()
681         public
682         payable
683     {
684         bytes32 _name = _nameString.nameFilter();
685         address _addr = msg.sender;
686         uint256 _paid = msg.value;
687 
688         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
689 
690         bool _isNewPlayer = isNewPlayer(_addr);
691 
692         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
693 
694         uint256 _pID = makePlayerID(msg.sender);
695         uint256 _affID;
696         if (_affCode != address(0) && _affCode != _addr)
697         {
698             // get affiliate ID from aff Code
699             _affID = pIDxAddr_[_affCode];
700 
701             // if affID is not the same as previously stored
702             if (_affID != plyr_[_pID].laff)
703             {
704                 // update last affiliate
705                 plyr_[_pID].laff = _affID;
706             }
707         }
708 
709         registerNameCore(_pID, _name);
710         // fire event
711         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
712     }
713 
714     function registerNameXname(string _nameString, bytes32 _affCode)
715         isHuman()
716         isRegisteredName()
717         public
718         payable
719     {
720         bytes32 _name = _nameString.nameFilter();
721         address _addr = msg.sender;
722         uint256 _paid = msg.value;
723 
724         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
725 
726         bool _isNewPlayer = isNewPlayer(_addr);
727 
728         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
729         uint256 _pID = makePlayerID(msg.sender);
730 
731         uint256 _affID;
732         if (_affCode != "" && _affCode != _name)
733         {
734             // get affiliate ID from aff Code
735             _affID = pIDxName_[_affCode];
736 
737             // if affID is not the same as previously stored
738             if (_affID != plyr_[_pID].laff)
739             {
740                 // update last affiliate
741                 plyr_[_pID].laff = _affID;
742             }
743         }
744 
745         registerNameCore(_pID, _name);
746         // fire event
747         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
748     }
749 
750     function registerNameCore(uint256 _pID, bytes32 _name)
751         private
752     {
753 
754         // if names already has been used, require that current msg sender owns the name
755         if (pIDxName_[_name] != 0)
756             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
757 
758         // add name to player profile, registry, and name book
759         plyr_[_pID].name = _name;
760         pIDxName_[_name] = _pID;
761         if (plyrNames_[_pID][_name] == false)
762         {
763             plyrNames_[_pID][_name] = true;
764         }
765         // registration fee goes directly to community rewards
766         address affAddreess = 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
767         affAddreess.transfer(msg.value);
768 
769     }
770 
771     function isNewPlayer(address _addr)
772     public
773     view
774     returns (bool)
775     {
776         if (pIDxAddr_[_addr] == 0)
777         {
778             // set the new player bool to true
779             return (true);
780         } else {
781             return (false);
782         }
783     }
784 //==============================================================================
785 //     _  _ _|__|_ _  _ _  .
786 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
787 //=====_|=======================================================================
788     /**
789      * @dev return the price buyer will pay for next 1 individual key.
790      * -functionhash- 0x018a25e8
791      * @return price for next key bought (in wei format)
792      */
793     function getBuyPrice()
794         public
795         view
796         returns(uint256)
797     {
798         // setup local rID
799         uint256 _rID = rID_;
800 
801         // grab time
802         uint256 _now = now;
803 
804         // are we in a round?
805         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
806             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
807         else // rounds over.  need price for new round
808             return ( 75000000000000 ); // init
809     }
810 
811     /**
812      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
813      * provider
814      * -functionhash- 0xc7e284b8
815      * @return time left in seconds
816      */
817     function getTimeLeft()
818         public
819         view
820         returns(uint256)
821     {
822         // setup local rID
823         uint256 _rID = rID_;
824 
825         // grab time
826         uint256 _now = now;
827 
828         if (_now < round_[_rID].end)
829             if (_now > round_[_rID].strt + rndGap_)
830                 return( (round_[_rID].end).sub(_now) );
831             else
832                 return( (round_[_rID].strt + rndGap_).sub(_now) );
833         else
834             return(0);
835     }
836 
837     /**
838      * @dev returns player earnings per vaults
839      * -functionhash- 0x63066434
840      * @return winnings vault
841      * @return general vault
842      * @return affiliate vault
843      */
844     function getPlayerVaults(uint256 _pID)
845         public
846         view
847         returns(uint256 ,uint256, uint256)
848     {
849         // setup local rID
850         uint256 _rID = rID_;
851 
852         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
853         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
854         {
855             // if player is winner
856             if (round_[_rID].plyr == _pID)
857             {
858                 return
859                 (
860                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
861                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
862                     plyr_[_pID].aff
863                 );
864             // if player is not the winner
865             } else {
866                 return
867                 (
868                     plyr_[_pID].win,
869                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
870                     plyr_[_pID].aff
871                 );
872             }
873 
874         // if round is still going on, or round has ended and round end has been ran
875         } else {
876             return
877             (
878                 plyr_[_pID].win,
879                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
880                 plyr_[_pID].aff
881             );
882         }
883     }
884 
885     /**
886      * solidity hates stack limits.  this lets us avoid that hate
887      */
888     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
889         private
890         view
891         returns(uint256)
892     {
893         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].endGen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
894     }
895 
896     /**
897      * @dev returns all current round info needed for front end
898      * -functionhash- 0x747dff42
899      * @return eth invested during ICO phase
900      * @return round id
901      * @return total keys for round
902      * @return time round ends
903      * @return time round started
904      * @return current pot
905      * @return current team ID & player ID in lead
906      * @return current player in leads address
907      * @return current player in leads name
908      * @return whales eth in for round
909      * @return bears eth in for round
910      * @return sneks eth in for round
911      * @return bulls eth in for round
912      * @return airdrop tracker # & airdrop pot
913      */
914     function getCurrentRoundInfo()
915         public
916         view
917         returns(uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
918     {
919         // setup local rID
920         uint256 _rID = rID_;
921 
922         return
923         (
924             _rID,                           //0
925             round_[_rID].keys,              //1
926             round_[_rID].end,               //2
927             round_[_rID].strt,              //3
928             round_[_rID].pot,               //4
929             (round_[_rID].team + (round_[_rID].plyr * 10)),     //5
930             plyr_[round_[_rID].plyr].addr,  //6
931             plyr_[round_[_rID].plyr].name,  //7
932             rndTmEth_[_rID][0],             //8
933             rndTmEth_[_rID][1],             //9
934             rndTmEth_[_rID][2],             //10
935             rndTmEth_[_rID][3]             //11
936         );
937     }
938 
939     /**
940      * @dev returns player info based on address.  if no address is given, it will
941      * use msg.sender
942      * -functionhash- 0xee0b5d8b
943      * @param _addr address of the player you want to lookup
944      * @return player ID
945      * @return player name
946      * @return keys owned (current round)
947      * @return winnings vault
948      * @return general vault
949      * @return affiliate vault
950 	 * @return player round eth
951      */
952     function getPlayerInfoByAddress(address _addr)
953         public
954         view
955         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
956     {
957         // setup local rID
958         uint256 _rID = rID_;
959 
960         if (_addr == address(0))
961         {
962             _addr == msg.sender;
963         }
964         uint256 _pID = pIDxAddr_[_addr];
965 
966         return
967         (
968             _pID,                               //0
969             plyr_[_pID].name,                   //1
970             plyrRnds_[_pID][_rID].keys,         //2
971             plyr_[_pID].win,                    //3
972             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
973             plyr_[_pID].aff,                    //5
974             plyrRnds_[_pID][_rID].eth           //6
975         );
976     }
977 
978 //==============================================================================
979 //     _ _  _ _   | _  _ . _  .
980 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
981 //=====================_|=======================================================
982     /**
983      * @dev logic runs whenever a buy order is executed.  determines how to handle
984      * incoming eth depending on if we are in an active round or not
985      */
986     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
987         private
988     {
989         // setup local rID
990         uint256 _rID = rID_;
991 
992         // grab time
993         uint256 _now = now;
994 
995         // if round is active
996         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
997         {
998             // call core
999             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1000 
1001         // if round is not active
1002         } else {
1003             // check to see if end round needs to be ran
1004             if (_now > round_[_rID].end && round_[_rID].ended == false)
1005             {
1006                 // end the round (distributes pot) & start new round
1007 			    round_[_rID].ended = true;
1008                 _eventData_ = endRound(_eventData_);
1009 
1010                 // build event data
1011                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1012                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1013 
1014                 // fire buy and distribute event
1015                 emit Star3Devents.onBuyAndDistribute
1016                 (
1017                     msg.sender,
1018                     plyr_[_pID].name,
1019                     msg.value,
1020                     _eventData_.compressedData,
1021                     _eventData_.compressedIDs,
1022                     _eventData_.winnerAddr,
1023                     _eventData_.winnerName,
1024                     _eventData_.amountWon,
1025                     _eventData_.newPot,
1026                     _eventData_.genAmount
1027                 );
1028             }
1029 
1030             // put eth in players vault
1031             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1032         }
1033     }
1034 
1035     /**
1036      * @dev logic runs whenever a reload order is executed.  determines how to handle
1037      * incoming eth depending on if we are in an active round or not
1038      */
1039     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Star3Ddatasets.EventReturns memory _eventData_)
1040         private
1041     {
1042         // setup local rID
1043         uint256 _rID = rID_;
1044 
1045         // grab time
1046         uint256 _now = now;
1047 
1048         // if round is active
1049         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1050         {
1051             // get earnings from all vaults and return unused to gen vault
1052             // because we use a custom safemath library.  this will throw if player
1053             // tried to spend more eth than they have.
1054             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1055 
1056             // call core
1057             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1058 
1059         // if round is not active and end round needs to be ran
1060         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1061             // end the round (distributes pot) & start new round
1062             round_[_rID].ended = true;
1063             _eventData_ = endRound(_eventData_);
1064 
1065             // build event data
1066             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1067             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1068 
1069             // fire buy and distribute event
1070             emit Star3Devents.onReLoadAndDistribute
1071             (
1072                 msg.sender,
1073                 plyr_[_pID].name,
1074                 _eventData_.compressedData,
1075                 _eventData_.compressedIDs,
1076                 _eventData_.winnerAddr,
1077                 _eventData_.winnerName,
1078                 _eventData_.amountWon,
1079                 _eventData_.newPot,
1080                 _eventData_.genAmount
1081             );
1082         }
1083     }
1084 
1085     /**
1086      * @dev this is the core logic for any buy/reload that happens while a round
1087      * is live.
1088      */
1089     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
1090         private
1091     {
1092         // if player is new to round
1093         if (plyrRnds_[_pID][_rID].keys == 0)
1094             _eventData_ = managePlayer(_pID, _eventData_);
1095 
1096         // early round eth limiter
1097         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1098         {
1099             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1100             uint256 _refund = _eth.sub(_availableLimit);
1101             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1102             _eth = _availableLimit;
1103         }
1104 
1105         // if eth left is greater than min eth allowed (sorry no pocket lint)
1106         if (_eth > 1000000000)
1107         {
1108 
1109             // mint the new keys
1110             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1111 
1112             // if they bought at least 1 whole key
1113             if (_keys >= 1000000000000000000)
1114             {
1115             updateTimer(_keys, _rID);
1116 
1117             // set new leaders
1118             if (round_[_rID].plyr != _pID)
1119                 round_[_rID].plyr = _pID;
1120             if (round_[_rID].team != _team)
1121                 round_[_rID].team = _team;
1122 
1123             // set the new leader bool to true
1124             _eventData_.compressedData = _eventData_.compressedData + 100;
1125             }
1126 
1127             // store the air drop tracker number (number of buys since last airdrop)
1128             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1129 
1130             // update player
1131             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1132             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1133 
1134             // update round
1135             round_[_rID].keys = _keys.add(round_[_rID].keys);
1136             round_[_rID].eth = _eth.add(round_[_rID].eth);
1137             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1138 
1139             // distribute eth
1140             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
1141             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1142 
1143             // call end tx function to fire end tx event.
1144 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1145         }
1146     }
1147 //==============================================================================
1148 //     _ _ | _   | _ _|_ _  _ _  .
1149 //    (_(_||(_|_||(_| | (_)| _\  .
1150 //==============================================================================
1151     /**
1152      * @dev calculates unmasked earnings (just calculates, does not update mask)
1153      * @return earnings in wei format
1154      */
1155     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1156         private
1157         view
1158         returns(uint256)
1159     {
1160         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1161     }
1162 
1163     /**
1164      * @dev returns the amount of keys you would get given an amount of eth.
1165      * -functionhash- 0xce89c80c
1166      * @param _rID round ID you want price for
1167      * @param _eth amount of eth sent in
1168      * @return keys received
1169      */
1170     function calcKeysReceived(uint256 _rID, uint256 _eth)
1171         public
1172         view
1173         returns(uint256)
1174     {
1175         // grab time
1176         uint256 _now = now;
1177 
1178         // are we in a round?
1179         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1180             return ( (round_[_rID].eth).keysRec(_eth) );
1181         else // rounds over.  need keys for new round
1182             return ( (_eth).keys() );
1183     }
1184 
1185     /**
1186      * @dev returns current eth price for X keys.
1187      * -functionhash- 0xcf808000
1188      * @param _keys number of keys desired (in 18 decimal format)
1189      * @return amount of eth needed to send
1190      */
1191     function iWantXKeys(uint256 _keys)
1192         public
1193         view
1194         returns(uint256)
1195     {
1196         // setup local rID
1197         uint256 _rID = rID_;
1198 
1199         // grab time
1200         uint256 _now = now;
1201 
1202         // are we in a round?
1203         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1204             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1205         else // rounds over.  need price for new round
1206             return ( (_keys).eth() );
1207     }
1208     function makePlayerID(address _addr)
1209     private
1210     returns (uint256)
1211     {
1212         if (pIDxAddr_[_addr] == 0)
1213         {
1214             pID_++;
1215             pIDxAddr_[_addr] = pID_;
1216             // set the new player bool to true
1217             return (pID_);
1218         } else {
1219             return (pIDxAddr_[_addr]);
1220         }
1221     }
1222 
1223 
1224     function getPlayerName(uint256 _pID)
1225     external
1226     view
1227     returns (bytes32)
1228     {
1229         return (plyr_[_pID].name);
1230     }
1231     function getPlayerLAff(uint256 _pID)
1232         external
1233         view
1234         returns (uint256)
1235     {
1236         return (plyr_[_pID].laff);
1237     }
1238 
1239     /**
1240      * @dev gets existing or registers new pID.  use this when a player may be new
1241      * @return pID
1242      */
1243     function determinePID(Star3Ddatasets.EventReturns memory _eventData_)
1244         private
1245         returns (Star3Ddatasets.EventReturns)
1246     {
1247         uint256 _pID = pIDxAddr_[msg.sender];
1248         // if player is new to this version of fomo3d
1249         if (_pID == 0)
1250         {
1251             // grab their player ID, name and last aff ID, from player names contract
1252             _pID = makePlayerID(msg.sender);
1253 
1254             bytes32 _name = "";
1255             uint256 _laff = 0;
1256             // set up player account
1257             pIDxAddr_[msg.sender] = _pID;
1258             plyr_[_pID].addr = msg.sender;
1259 
1260             if (_name != "")
1261             {
1262                 pIDxName_[_name] = _pID;
1263                 plyr_[_pID].name = _name;
1264                 plyrNames_[_pID][_name] = true;
1265             }
1266 
1267             if (_laff != 0 && _laff != _pID)
1268                 plyr_[_pID].laff = _laff;
1269             // set the new player bool to true
1270             _eventData_.compressedData = _eventData_.compressedData + 1;
1271         }
1272         return (_eventData_);
1273     }
1274 
1275     /**
1276      * @dev checks to make sure user picked a valid team.  if not sets team
1277      * to default (sneks)
1278      */
1279     function verifyTeam(uint256 _team)
1280         private
1281         pure
1282         returns (uint256)
1283     {
1284         if (_team < 0 || _team > 3)
1285             return(2);
1286         else
1287             return(_team);
1288     }
1289 
1290     /**
1291      * @dev decides if round end needs to be run & new round started.  and if
1292      * player unmasked earnings from previously played rounds need to be moved.
1293      */
1294     function managePlayer(uint256 _pID, Star3Ddatasets.EventReturns memory _eventData_)
1295         private
1296         returns (Star3Ddatasets.EventReturns)
1297     {
1298         // if player has played a previous round, move their unmasked earnings
1299         // from that round to gen vault.
1300         if (plyr_[_pID].lrnd != 0)
1301             updateGenVault(_pID, plyr_[_pID].lrnd);
1302 
1303         // update player's last round played
1304         plyr_[_pID].lrnd = rID_;
1305 
1306         // set the joined round bool to true
1307         _eventData_.compressedData = _eventData_.compressedData + 10;
1308 
1309         return(_eventData_);
1310     }
1311 
1312     /**
1313      * @dev ends the round. manages paying out winner/splitting up pot
1314      */
1315     function endRound(Star3Ddatasets.EventReturns memory _eventData_)
1316         private
1317         returns (Star3Ddatasets.EventReturns)
1318     {
1319         // setup local rID
1320         uint256 _rID = rID_;
1321 
1322         // grab our winning player and team id's
1323         uint256 _winPID = round_[_rID].plyr;
1324         uint256 _winTID = round_[_rID].team;
1325 
1326         // grab our pot amount
1327         uint256 _pot = round_[_rID].pot;
1328 
1329         // calculate our winner share, community rewards, gen share,
1330         // p3d share, and amount reserved for next pot
1331         uint256 _win = (_pot.mul(48)) / 100;
1332         uint256 _com = (_pot / 50);
1333         uint256 _gen = (_pot.mul(potSplit_[_winTID].endGen)) / 100;
1334         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1335 
1336         // calculate ppt for round mask
1337         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1338         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1339         if (_dust > 0)
1340         {
1341             _gen = _gen.sub(_dust);
1342             _res = _res.add(_dust);
1343         }
1344 
1345         // pay our winner
1346         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1347 
1348         // dev rewards
1349         address devAddress = 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
1350         devAddress.transfer(_com);
1351         // distribute gen portion to key holders
1352         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1353 
1354         // send share for p3d to divies
1355 //        if (_p3d > 0)
1356 //            Divies.deposit.value(_p3d)();
1357 
1358         // prepare event data
1359         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1360         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1361         _eventData_.winnerAddr = plyr_[_winPID].addr;
1362         _eventData_.winnerName = plyr_[_winPID].name;
1363         _eventData_.amountWon = _win;
1364         _eventData_.genAmount = _gen;
1365         _eventData_.newPot = _res;
1366 
1367         // start next round
1368         rID_++;
1369         _rID++;
1370         round_[_rID].strt = now;
1371         round_[_rID].end = now.add(rndInit_);
1372         round_[_rID].pot = _res;
1373 
1374         return(_eventData_);
1375     }
1376 
1377     /**
1378      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1379      */
1380     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1381         private
1382     {
1383         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1384         if (_earnings > 0)
1385         {
1386             // put in gen vault
1387             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1388             // zero out their earnings by updating mask
1389             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1390         }
1391     }
1392 
1393     /**
1394      * @dev updates round timer based on number of whole keys bought.
1395      */
1396     function updateTimer(uint256 _keys, uint256 _rID)
1397         private
1398     {
1399         // grab time
1400         uint256 _now = now;
1401 
1402         // calculate time based on number of keys bought
1403         uint256 _newTime;
1404         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1405             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1406         else
1407             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1408 
1409         // compare to max and set new end time
1410         if (_newTime < (rndMax_).add(_now))
1411             round_[_rID].end = _newTime;
1412         else
1413             round_[_rID].end = rndMax_.add(_now);
1414     }
1415 
1416 
1417     /**
1418      * @dev distributes eth based on fees to com, aff, and p3d
1419      */
1420     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, Star3Ddatasets.EventReturns memory _eventData_)
1421         private
1422         returns(Star3Ddatasets.EventReturns)
1423     {
1424         // distribute share to affiliate
1425         uint256 _aff = _eth / 10;
1426 
1427         // affiliate must not be self, and must have a name registered
1428         if (_affID != _pID && plyr_[_affID].name != '') {
1429             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1430         } else {
1431             // dev rewards
1432             address affAddreess = 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
1433             affAddreess.transfer(_aff);
1434         }
1435         return(_eventData_);
1436     }
1437 
1438     /**
1439      * @dev distributes eth based on fees to gen and pot
1440      */
1441     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1442         private
1443         returns(Star3Ddatasets.EventReturns)
1444     {
1445         // calculate gen share
1446         uint256 _gen = (_eth.mul(fees_[_team].firstGive)) / 100;
1447         // calculate dev
1448         uint256 _dev = (_eth.mul(fees_[_team].giveDev)) / 100;
1449         //distribute share to affiliate 10%
1450         _eth = _eth.sub(((_eth.mul(10)) / 100)).sub(_dev);
1451         //calc pot
1452         uint256 _pot =_eth.sub(_gen);
1453 
1454         // distribute gen share (thats what updateMasks() does) and adjust
1455         // balances for dust.
1456         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1457         if (_dust > 0)
1458             _gen = _gen.sub(_dust);
1459 
1460         // dev rewards
1461         address devAddress = 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
1462         devAddress.transfer(_dev);
1463 
1464         // add eth to pot
1465         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1466 
1467         // set up event data
1468         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1469         _eventData_.potAmount = _pot;
1470 
1471         return(_eventData_);
1472     }
1473 
1474     /**
1475      * @dev updates masks for round and player when keys are bought
1476      * @return dust left over
1477      */
1478     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1479         private
1480         returns(uint256)
1481     {
1482         /* MASKING NOTES
1483             earnings masks are a tricky thing for people to wrap their minds around.
1484             the basic thing to understand here.  is were going to have a global
1485             tracker based on profit per share for each round, that increases in
1486             relevant proportion to the increase in share supply.
1487 
1488             the player will have an additional mask that basically says "based
1489             on the rounds mask, my shares, and how much i've already withdrawn,
1490             how much is still owed to me?"
1491         */
1492 
1493         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1494         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1495         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1496 
1497         // calculate player earning from their own buy (only based on the keys
1498         // they just bought).  & update player earnings mask
1499         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1500         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1501 
1502         // calculate & return dust
1503         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1504     }
1505 
1506     /**
1507      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1508      * @return earnings in wei format
1509      */
1510     function withdrawEarnings(uint256 _pID)
1511         private
1512         returns(uint256)
1513     {
1514         // update gen vault
1515         updateGenVault(_pID, plyr_[_pID].lrnd);
1516 
1517         // from vaults
1518         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1519         if (_earnings > 0)
1520         {
1521             plyr_[_pID].win = 0;
1522             plyr_[_pID].gen = 0;
1523             plyr_[_pID].aff = 0;
1524         }
1525 
1526         return(_earnings);
1527     }
1528 
1529     /**
1530      * @dev prepares compression data and fires event for buy or reload tx's
1531      */
1532     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1533         private
1534     {
1535         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1536         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1537 
1538         emit Star3Devents.onEndTx
1539         (
1540             _eventData_.compressedData,
1541             _eventData_.compressedIDs,
1542             plyr_[_pID].name,
1543             msg.sender,
1544             _eth,
1545             _keys,
1546             _eventData_.winnerAddr,
1547             _eventData_.winnerName,
1548             _eventData_.amountWon,
1549             _eventData_.newPot,
1550             _eventData_.genAmount,
1551             _eventData_.potAmount
1552         );
1553     }
1554 //==============================================================================
1555 //    (~ _  _    _._|_    .
1556 //    _)(/_(_|_|| | | \/  .
1557 //====================/=========================================================
1558     /** upon contract deploy, it will be deactivated.  this is a one time
1559      * use function that will activate the contract.  we do this so devs
1560      * have time to set things up on the web end                            **/
1561     bool public activated_ = false;
1562     function activate()
1563         public
1564     {
1565         // only team just can activate
1566         require(
1567 			msg.sender == 0x701b5B2F6bc3F74Eb15DaebAcFC65E6eAdFbb0DA,
1568             "only team just can activate"
1569         );
1570 
1571 		// make sure that its been linked.
1572 //        require(address(otherF3D_) != address(0), "must link to other Star3D first");
1573 
1574         // can only be ran once
1575         require(activated_ == false, "Star3d already activated");
1576 
1577         // activate the contract
1578         activated_ = true;
1579 
1580         // lets start first round
1581 		rID_ = 1;
1582         round_[1].strt = now;
1583         round_[1].end = now + rndInit_ + rndExtra_;
1584     }
1585 }
1586 
1587 
1588 library NameFilter {
1589     /**
1590      * @dev filters name strings
1591      * -converts uppercase to lower case.
1592      * -makes sure it does not start/end with a space
1593      * -makes sure it does not contain multiple spaces in a row
1594      * -cannot be only numbers
1595      * -cannot start with 0x
1596      * -restricts characters to A-Z, a-z, 0-9, and space.
1597      * @return reprocessed string in bytes32 format
1598      */
1599     function nameFilter(string _input)
1600         internal
1601         pure
1602         returns(bytes32)
1603     {
1604         bytes memory _temp = bytes(_input);
1605         uint256 _length = _temp.length;
1606 
1607         //sorry limited to 32 characters
1608         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1609         // make sure it doesnt start with or end with space
1610         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1611         // make sure first two characters are not 0x
1612         if (_temp[0] == 0x30)
1613         {
1614             require(_temp[1] != 0x78, "string cannot start with 0x");
1615             require(_temp[1] != 0x58, "string cannot start with 0X");
1616         }
1617 
1618         // create a bool to track if we have a non number character
1619         bool _hasNonNumber;
1620 
1621         // convert & check
1622         for (uint256 i = 0; i < _length; i++)
1623         {
1624             // if its uppercase A-Z
1625             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1626             {
1627                 // convert to lower case a-z
1628                 _temp[i] = byte(uint(_temp[i]) + 32);
1629 
1630                 // we have a non number
1631                 if (_hasNonNumber == false)
1632                     _hasNonNumber = true;
1633             } else {
1634                 require
1635                 (
1636                     // require character is a space
1637                     _temp[i] == 0x20 ||
1638                     // OR lowercase a-z
1639                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1640                     // or 0-9
1641                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1642                     "string contains invalid characters"
1643                 );
1644                 // make sure theres not 2x spaces in a row
1645                 if (_temp[i] == 0x20)
1646                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1647 
1648                 // see if we have a character other than a number
1649                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1650                     _hasNonNumber = true;
1651             }
1652         }
1653 
1654         require(_hasNonNumber == true, "string cannot be only numbers");
1655 
1656         bytes32 _ret;
1657         assembly {
1658             _ret := mload(add(_temp, 32))
1659         }
1660         return (_ret);
1661     }
1662 }
1663 
1664 
1665 //==============================================================================
1666 //   __|_ _    __|_ _  .
1667 //  _\ | | |_|(_ | _\  .
1668 //==============================================================================
1669 library Star3Ddatasets {
1670     //compressedData key
1671     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1672         // 0 - new player (bool)
1673         // 1 - joined round (bool)
1674         // 2 - new  leader (bool)
1675         // 3-5 - air drop tracker (uint 0-999)
1676         // 6-16 - round end time
1677         // 17 - winnerTeam
1678         // 18 - 28 timestamp
1679         // 29 - team
1680         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1681         // 31 - airdrop happened bool
1682         // 32 - airdrop tier
1683         // 33 - airdrop amount won
1684     //compressedIDs key
1685     // [77-52][51-26][25-0]
1686         // 0-25 - pID
1687         // 26-51 - winPID
1688         // 52-77 - rID
1689     struct EventReturns {
1690         uint256 compressedData;
1691         uint256 compressedIDs;
1692         address winnerAddr;         // winner address
1693         bytes32 winnerName;         // winner name
1694         uint256 amountWon;          // amount won
1695         uint256 newPot;             // amount in new pot
1696         uint256 genAmount;          // amount distributed to gen
1697         uint256 potAmount;          // amount added to pot
1698     }
1699     struct Player {
1700         address addr;   // player address
1701         bytes32 name;   // player name
1702         uint256 win;    // winnings vault
1703         uint256 gen;    // general vault
1704         uint256 aff;    // affiliate vault
1705         uint256 lrnd;   // last round played
1706         uint256 laff;   // last affiliate id used
1707     }
1708     struct PlayerRounds {
1709         uint256 eth;    // eth player has added to round (used for eth limiter)
1710         uint256 keys;   // keys
1711         uint256 mask;   // player mask
1712     }
1713     struct Round {
1714         uint256 plyr;   // pID of player in lead
1715         uint256 team;   // tID of team in lead
1716         uint256 end;    // time ends/ended
1717         bool ended;     // has round end function been ran
1718         uint256 strt;   // time round started
1719         uint256 keys;   // keys
1720         uint256 eth;    // total eth in
1721         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1722         uint256 mask;   // global mask
1723         uint256 icoGen; // total eth for gen during ICO phase
1724         uint256 icoAvg; // average key price for ICO phase
1725     }
1726     struct TeamFee {
1727 //        uint256 gen;    // % of buy in thats paid to key holders of current round
1728 //        uint256 p3d;    // % of buy in thats paid to p3d holders
1729         uint256 firstPot;   //% of pot
1730         uint256 firstGive; //% of keys gen
1731         uint256 giveDev;//% of give dev
1732 
1733 
1734     }
1735     struct PotSplit {
1736         uint256 endNext; //% of next
1737         uint256 endGen; //% of keys gen
1738     }
1739 }
1740 
1741 //==============================================================================
1742 //  |  _      _ _ | _  .
1743 //  |<(/_\/  (_(_||(_  .
1744 //=======/======================================================================
1745 library Star3DKeysCalcLong {
1746     using SafeMath for *;
1747     /**
1748      * @dev calculates number of keys received given X eth
1749      * @param _curEth current amount of eth in contract
1750      * @param _newEth eth being spent
1751      * @return amount of ticket purchased
1752      */
1753     function keysRec(uint256 _curEth, uint256 _newEth)
1754         internal
1755         pure
1756         returns (uint256)
1757     {
1758         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1759     }
1760 
1761     /**
1762      * @dev calculates amount of eth received if you sold X keys
1763      * @param _curKeys current amount of keys that exist
1764      * @param _sellKeys amount of keys you wish to sell
1765      * @return amount of eth received
1766      */
1767     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1768         internal
1769         pure
1770         returns (uint256)
1771     {
1772         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1773     }
1774 
1775     /**
1776      * @dev calculates how many keys would exist with given an amount of eth
1777      * @param _eth eth "in contract"
1778      * @return number of keys that would exist
1779      */
1780     function keys(uint256 _eth)
1781         internal
1782         pure
1783         returns(uint256)
1784     {
1785         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1786     }
1787 
1788     /**
1789      * @dev calculates how much eth would be in contract given a number of keys
1790      * @param _keys number of keys "in contract"
1791      * @return eth that would exists
1792      */
1793     function eth(uint256 _keys)
1794         internal
1795         pure
1796         returns(uint256)
1797     {
1798         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1799     }
1800 }
1801 
1802 /**
1803  * @title SafeMath v0.1.9
1804  * @dev Math operations with safety checks that throw on error
1805  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1806  * - added sqrt
1807  * - added sq
1808  * - added pwr
1809  * - changed asserts to requires with error log outputs
1810  * - removed div, its useless
1811  */
1812 library SafeMath {
1813 
1814     /**
1815     * @dev Multiplies two numbers, throws on overflow.
1816     */
1817     function mul(uint256 a, uint256 b)
1818         internal
1819         pure
1820         returns (uint256 c)
1821     {
1822         if (a == 0) {
1823             return 0;
1824         }
1825         c = a * b;
1826         require(c / a == b, "SafeMath mul failed");
1827         return c;
1828     }
1829 
1830     /**
1831     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1832     */
1833     function sub(uint256 a, uint256 b)
1834         internal
1835         pure
1836         returns (uint256)
1837     {
1838         require(b <= a, "SafeMath sub failed");
1839         return a - b;
1840     }
1841 
1842     /**
1843     * @dev Adds two numbers, throws on overflow.
1844     */
1845     function add(uint256 a, uint256 b)
1846         internal
1847         pure
1848         returns (uint256 c)
1849     {
1850         c = a + b;
1851         require(c >= a, "SafeMath add failed");
1852         return c;
1853     }
1854 
1855     /**
1856      * @dev gives square root of given x.
1857      */
1858     function sqrt(uint256 x)
1859         internal
1860         pure
1861         returns (uint256 y)
1862     {
1863         uint256 z = ((add(x,1)) / 2);
1864         y = x;
1865         while (z < y)
1866         {
1867             y = z;
1868             z = ((add((x / z),z)) / 2);
1869         }
1870     }
1871 
1872     /**
1873      * @dev gives square. multiplies x by x
1874      */
1875     function sq(uint256 x)
1876         internal
1877         pure
1878         returns (uint256)
1879     {
1880         return (mul(x,x));
1881     }
1882 
1883     /**
1884      * @dev x to the power of y
1885      */
1886     function pwr(uint256 x, uint256 y)
1887         internal
1888         pure
1889         returns (uint256)
1890     {
1891         if (x==0)
1892             return (0);
1893         else if (y==0)
1894             return (1);
1895         else
1896         {
1897             uint256 z = x;
1898             for (uint256 i=1; i < y; i++)
1899                 z = mul(z,x);
1900             return (z);
1901         }
1902     }
1903 }