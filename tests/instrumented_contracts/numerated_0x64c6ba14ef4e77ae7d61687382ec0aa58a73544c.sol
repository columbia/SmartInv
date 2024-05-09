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
168 interface CompanyShareInterface {
169     function deposit() external payable;
170 }
171 
172 //==============================================================================
173 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
174 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
175 //====================================|=========================================
176 
177 contract modularLong is Star3Devents {}
178 
179 contract Star3Dlong is modularLong {
180     using SafeMath for *;
181     using NameFilter for string;
182     using Star3DKeysCalcLong for uint256;
183 
184 //==============================================================================
185 //     _ _  _  |`. _     _ _ |_ | _  _  .
186 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
187 //=================_|===========================================================
188     string constant public name = "Save the planet";
189     string constant public symbol = "Star";
190     CompanyShareInterface constant private CompanyShare = CompanyShareInterface(0x03347ABb58cc3071FDBBa7F7bD7cca03C8E04229);
191 
192     uint256 private pID_ = 0;   // total number of players
193 	uint256 private rndExtra_ = 0 hours;     // length of the very first ICO
194     uint256 private rndGap_ = 10 seconds;         // length of ICO phase, set to 1 year for EOS.
195     uint256 constant private rndInit_ = 10 hours;                     // round timer starts at this
196     uint256 constant private rndInc_ = 30 seconds;               // every full key purchased adds this much to the timer
197     uint256 constant private rndMax_ = 24 hours;                     // max length a round timer can be
198     uint256 public registrationFee_ = 10 finney;               // price to register a name
199 
200 //==============================================================================
201 //     _| _ _|_ _    _ _ _|_    _   .
202 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
203 //=============================|================================================
204 //	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
205 //    uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
206     uint256 public rID_;    // round id number / total rounds that have happened
207 //****************
208 // PLAYER DATA 
209 //****************
210     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
211     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
212     mapping (uint256 => Star3Ddatasets.Player) public plyr_;   // (pID => data) player data
213     mapping (uint256 => mapping (uint256 => Star3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
214     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
215 //****************
216 // ROUND DATA
217 //****************
218     mapping (uint256 => Star3Ddatasets.Round) public round_;   // (rID => data) round data
219     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
220 //****************
221 // TEAM FEE DATA
222 //****************
223     mapping (uint256 => Star3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
224     mapping (uint256 => Star3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
225 //==============================================================================
226 //     _ _  _  __|_ _    __|_ _  _  .
227 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
228 //==============================================================================
229     constructor()
230         public
231     {
232 		// Team allocation structures
233         // 0 = whales
234         // 1 = bears
235         // 2 = sneks
236         // 3 = bulls
237 
238 		// Team allocation percentages
239         // (Star, None) + (Pot , Referrals, Community)
240             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
241         fees_[0] = Star3Ddatasets.TeamFee(32, 45, 10, 3);	//32%pot 45%gen 10%dev 3%aff 10%dev
242         fees_[1] = Star3Ddatasets.TeamFee(45, 32, 10, 3);	//45%pot 32%gen 10%dev 3%aff 10%dev
243         fees_[2] = Star3Ddatasets.TeamFee(50, 27, 10, 3);	//50%pot 27%gen 10%dev 3%aff 10%dev
244         fees_[3] = Star3Ddatasets.TeamFee(40, 37, 10, 3);	//40%pot 37%gen 10%dev 3%aff 10%dev
245 
246 //        // how to split up the final pot based on which team was picked
247 //        // (Star, None)
248         potSplit_[0] = Star3Ddatasets.PotSplit(20, 30);  //newPot20%  gen30%  dev2% winer48%
249         potSplit_[1] = Star3Ddatasets.PotSplit(15, 35);  
250         potSplit_[2] = Star3Ddatasets.PotSplit(25, 25);  
251         potSplit_[3] = Star3Ddatasets.PotSplit(30, 20);  
252 	}
253 //==============================================================================
254 //     _ _  _  _|. |`. _  _ _  .
255 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
256 //==============================================================================
257     /**
258      * @dev used to make sure no one can interact with contract until it has
259      * been activated.
260      */
261     modifier isActivated() {
262         require(activated_ == true, "its not ready yet.  check ?eta in discord");
263         _;
264     }
265 
266     modifier isRegisteredName()
267     {
268         uint256 _pID = pIDxAddr_[msg.sender];
269         require(plyr_[_pID].name == "" || _pID == 0, "already has name");
270         _;
271     }
272     /**
273      * @dev prevents contracts from interacting with fomo3d
274      */
275     modifier isHuman() {
276         address _addr = msg.sender;
277         uint256 _codeLength;
278 
279         assembly {_codeLength := extcodesize(_addr)}
280         require(_codeLength == 0, "sorry humans only");
281         _;
282     }
283 
284     /**
285      * @dev sets boundaries for incoming tx
286      */
287     modifier isWithinLimits(uint256 _eth) {
288         require(_eth >= 1000000000, "pocket lint: not a valid currency");
289         require(_eth <= 100000000000000000000000, "no vitalik, no");
290         _;
291     }
292 
293 //==============================================================================
294 //     _    |_ |. _   |`    _  __|_. _  _  _  .
295 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
296 //====|=========================================================================
297     /**
298      * @dev emergency buy uses last stored affiliate ID and team snek
299      */
300     function()
301         isActivated()
302         isHuman()
303         isWithinLimits(msg.value)
304         public
305         payable
306     {
307         // set up our tx event data and determine if player is new or not
308         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
309 
310         // fetch player id
311         uint256 _pID = pIDxAddr_[msg.sender];
312 
313         // buy core
314         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
315     }
316 
317     /**
318      * @dev converts all incoming ethereum to keys.
319      * -functionhash- 0x8f38f309 (using ID for affiliate)
320      * -functionhash- 0x98a0871d (using address for affiliate)
321      * -functionhash- 0xa65b37a1 (using name for affiliate)
322      * @param _affCode the ID/address/name of the player who gets the affiliate fee
323      * @param _team what team is the player playing for?
324      */
325     function buyXid(uint256 _affCode, uint256 _team)
326         isActivated()
327         isHuman()
328         isWithinLimits(msg.value)
329         public
330         payable
331     {
332         // set up our tx event data and determine if player is new or not
333         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
334 
335         // fetch player id
336         uint256 _pID = pIDxAddr_[msg.sender];
337 
338         // manage affiliate residuals
339         // if no affiliate code was given or player tried to use their own, lolz
340         if (_affCode == 0 || _affCode == _pID)
341         {
342             // use last stored affiliate code
343             _affCode = plyr_[_pID].laff;
344 
345         // if affiliate code was given & its not the same as previously stored
346         } else if (_affCode != plyr_[_pID].laff) {
347             // update last affiliate
348             plyr_[_pID].laff = _affCode;
349         }
350 
351         // verify a valid team was selected
352         _team = verifyTeam(_team);
353 
354         // buy core
355         buyCore(_pID, _affCode, _team, _eventData_);
356     }
357 
358     function buyXaddr(address _affCode, uint256 _team)
359         isActivated()
360         isHuman()
361         isWithinLimits(msg.value)
362         public
363         payable
364     {
365         // set up our tx event data and determine if player is new or not
366         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
367 
368         // fetch player id
369         uint256 _pID = pIDxAddr_[msg.sender];
370 
371         // verify a valid team was selected
372         _team = verifyTeam(_team);
373         // manage affiliate residuals
374         uint256 _affID;
375         // if no affiliate code was given or player tried to use their own, lolz
376         if (_affCode == address(0) || _affCode == msg.sender)
377         {
378             // use last stored affiliate code
379             _affID = plyr_[_pID].laff;
380 
381         // if affiliate code was given
382         } else {
383             // get affiliate ID from aff Code
384             _affID = pIDxAddr_[_affCode];
385 
386             // if affID is not the same as previously stored
387             if (_affID != plyr_[_pID].laff)
388             {
389                 // update last affiliate
390                 plyr_[_pID].laff = _affID;
391             }
392         }
393         // buy core
394         buyCore(_pID, _affID, _team, _eventData_);
395     }
396 
397     function buyXname(bytes32 _affCode, uint256 _team)
398         isActivated()
399         isHuman()
400         isWithinLimits(msg.value)
401         public
402         payable
403     {
404         // set up our tx event data and determine if player is new or not
405         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
406 
407         // fetch player id
408         uint256 _pID = pIDxAddr_[msg.sender];
409 
410         // manage affiliate residuals
411         uint256 _affID;
412         // if no affiliate code was given or player tried to use their own, lolz
413         if (_affCode == '' || _affCode == plyr_[_pID].name)
414         {
415             // use last stored affiliate code
416             _affID = plyr_[_pID].laff;
417 
418         // if affiliate code was given
419         } else {
420             // get affiliate ID from aff Code
421             _affID = pIDxName_[_affCode];
422 
423             // if affID is not the same as previously stored
424             if (_affID != plyr_[_pID].laff)
425             {
426                 // update last affiliate
427                 plyr_[_pID].laff = _affID;
428             }
429         }
430 
431         // verify a valid team was selected
432         _team = verifyTeam(_team);
433 
434         // buy core
435         buyCore(_pID, _affID, _team, _eventData_);
436     }
437 
438     /**
439      * @dev essentially the same as buy, but instead of you sending ether
440      * from your wallet, it uses your unwithdrawn earnings.
441      * -functionhash- 0x349cdcac (using ID for affiliate)
442      * -functionhash- 0x82bfc739 (using address for affiliate)
443      * -functionhash- 0x079ce327 (using name for affiliate)
444      * @param _affCode the ID/address/name of the player who gets the affiliate fee
445      * @param _team what team is the player playing for?
446      * @param _eth amount of earnings to use (remainder returned to gen vault)
447      */
448     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
449         isActivated()
450         isHuman()
451         isWithinLimits(_eth)
452         public
453     {
454         // set up our tx event data
455         Star3Ddatasets.EventReturns memory _eventData_;
456 
457         // fetch player ID
458         uint256 _pID = pIDxAddr_[msg.sender];
459 
460         // manage affiliate residuals
461         // if no affiliate code was given or player tried to use their own, lolz
462         if (_affCode == 0 || _affCode == _pID)
463         {
464             // use last stored affiliate code
465             _affCode = plyr_[_pID].laff;
466 
467         // if affiliate code was given & its not the same as previously stored
468         } else if (_affCode != plyr_[_pID].laff) {
469             // update last affiliate
470             plyr_[_pID].laff = _affCode;
471         }
472 
473         // verify a valid team was selected
474         _team = verifyTeam(_team);
475 
476         // reload core
477         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
478     }
479 
480     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
481         isActivated()
482         isHuman()
483         isWithinLimits(_eth)
484         public
485     {
486         // set up our tx event data
487         Star3Ddatasets.EventReturns memory _eventData_;
488 
489         // fetch player ID
490         uint256 _pID = pIDxAddr_[msg.sender];
491 
492         // manage affiliate residuals
493         uint256 _affID;
494         // if no affiliate code was given or player tried to use their own, lolz
495         if (_affCode == address(0) || _affCode == msg.sender)
496         {
497             // use last stored affiliate code
498             _affID = plyr_[_pID].laff;
499 
500         // if affiliate code was given
501         } else {
502             // get affiliate ID from aff Code
503             _affID = pIDxAddr_[_affCode];
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
520     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
521         isActivated()
522         isHuman()
523         isWithinLimits(_eth)
524         public
525     {
526         // set up our tx event data
527         Star3Ddatasets.EventReturns memory _eventData_;
528 
529         // fetch player ID
530         uint256 _pID = pIDxAddr_[msg.sender];
531 
532         // manage affiliate residuals
533         uint256 _affID;
534         // if no affiliate code was given or player tried to use their own, lolz
535         if (_affCode == '' || _affCode == plyr_[_pID].name)
536         {
537             // use last stored affiliate code
538             _affID = plyr_[_pID].laff;
539 
540         // if affiliate code was given
541         } else {
542             // get affiliate ID from aff Code
543             _affID = pIDxName_[_affCode];
544 
545             // if affID is not the same as previously stored
546             if (_affID != plyr_[_pID].laff)
547             {
548                 // update last affiliate
549                 plyr_[_pID].laff = _affID;
550             }
551         }
552 
553         // verify a valid team was selected
554         _team = verifyTeam(_team);
555 
556         // reload core
557         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
558     }
559 
560     /**
561      * @dev withdraws all of your earnings.
562      * -functionhash- 0x3ccfd60b
563      */
564     function withdraw()
565         isActivated()
566         isHuman()
567         public
568     {
569         // setup local rID
570         uint256 _rID = rID_;
571 
572         // grab time
573         uint256 _now = now;
574 
575         // fetch player ID
576         uint256 _pID = pIDxAddr_[msg.sender];
577 
578         // setup temp var for player eth
579         uint256 _eth;
580 
581         // check to see if round has ended and no one has run round end yet
582         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
583         {
584             // set up our tx event data
585             Star3Ddatasets.EventReturns memory _eventData_;
586 
587             // end the round (distributes pot)
588 			round_[_rID].ended = true;
589             _eventData_ = endRound(_eventData_);
590 
591 			// get their earnings
592             _eth = withdrawEarnings(_pID);
593 
594             // gib moni
595             if (_eth > 0)
596                 plyr_[_pID].addr.transfer(_eth);
597 
598             // build event data
599             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
600             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
601 
602             // fire withdraw and distribute event
603             emit Star3Devents.onWithdrawAndDistribute
604             (
605                 msg.sender,
606                 plyr_[_pID].name,
607                 _eth,
608                 _eventData_.compressedData,
609                 _eventData_.compressedIDs,
610                 _eventData_.winnerAddr,
611                 _eventData_.winnerName,
612                 _eventData_.amountWon,
613                 _eventData_.newPot,
614                 _eventData_.genAmount
615             );
616 
617         // in any other situation
618         } else {
619             // get their earnings
620             _eth = withdrawEarnings(_pID);
621 
622             // gib moni
623             if (_eth > 0)
624                 plyr_[_pID].addr.transfer(_eth);
625 
626             // fire withdraw event
627             emit Star3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
628         }
629     }
630 
631 
632     /**
633      * @dev use these to register names.  they are just wrappers that will send the
634      * registration requests to the PlayerBook contract.  So registering here is the
635      * same as registering there.  UI will always display the last name you registered.
636      * but you will still own all previously registered names to use as affiliate
637      * links.
638      * - must pay a registration fee.
639      * - name must be unique
640      * - names will be converted to lowercase
641      * - name cannot start or end with a space
642      * - cannot have more than 1 space in a row
643      * - cannot be only numbers
644      * - cannot start with 0x
645      * - name must be at least 1 char
646      * - max length of 32 characters long
647      * - allowed characters: a-z, 0-9, and space
648      * -functionhash- 0x921dec21 (using ID for affiliate)
649      * -functionhash- 0x3ddd4698 (using address for affiliate)
650      * -functionhash- 0x685ffd83 (using name for affiliate)
651      * @param _nameString players desired name
652      * @param _affCode affiliate ID, address, or name of who referred you
653      * (this might cost a lot of gas)
654      */
655     function registerNameXID(string _nameString, uint256 _affCode)
656         isHuman()
657         isRegisteredName()
658         public
659         payable
660     {
661         bytes32 _name = _nameString.nameFilter();
662         address _addr = msg.sender;
663         uint256 _paid = msg.value;
664 
665         bool _isNewPlayer = isNewPlayer(_addr);
666         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
667 
668         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
669 
670         uint256 _pID = makePlayerID(msg.sender);
671         uint256 _affID = _affCode;
672         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
673         {
674             // update last affiliate
675             plyr_[_pID].laff = _affID;
676         } else if (_affID == _pID) {
677             _affID = 0;
678         }
679         registerNameCore(_pID, _name);
680         // fire event
681         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
682     }
683 
684     function registerNameXaddr(string _nameString, address _affCode)
685         isHuman()
686         isRegisteredName()
687         public
688         payable
689     {
690         bytes32 _name = _nameString.nameFilter();
691         address _addr = msg.sender;
692         uint256 _paid = msg.value;
693 
694         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
695 
696         bool _isNewPlayer = isNewPlayer(_addr);
697 
698         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
699 
700         uint256 _pID = makePlayerID(msg.sender);
701         uint256 _affID;
702         if (_affCode != address(0) && _affCode != _addr)
703         {
704             // get affiliate ID from aff Code
705             _affID = pIDxAddr_[_affCode];
706 
707             // if affID is not the same as previously stored
708             if (_affID != plyr_[_pID].laff)
709             {
710                 // update last affiliate
711                 plyr_[_pID].laff = _affID;
712             }
713         }
714 
715         registerNameCore(_pID, _name);
716         // fire event
717         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
718     }
719 
720     function registerNameXname(string _nameString, bytes32 _affCode)
721         isHuman()
722         isRegisteredName()
723         public
724         payable
725     {
726         bytes32 _name = _nameString.nameFilter();
727         address _addr = msg.sender;
728         uint256 _paid = msg.value;
729 
730         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
731 
732         bool _isNewPlayer = isNewPlayer(_addr);
733 
734         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
735         uint256 _pID = makePlayerID(msg.sender);
736 
737         uint256 _affID;
738         if (_affCode != "" && _affCode != _name)
739         {
740             // get affiliate ID from aff Code
741             _affID = pIDxName_[_affCode];
742 
743             // if affID is not the same as previously stored
744             if (_affID != plyr_[_pID].laff)
745             {
746                 // update last affiliate
747                 plyr_[_pID].laff = _affID;
748             }
749         }
750 
751         registerNameCore(_pID, _name);
752         // fire event
753         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
754     }
755 
756     function registerNameCore(uint256 _pID, bytes32 _name)
757         private
758     {
759 
760         // if names already has been used, require that current msg sender owns the name
761         if (pIDxName_[_name] != 0)
762             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
763 
764         // add name to player profile, registry, and name book
765         plyr_[_pID].name = _name;
766         pIDxName_[_name] = _pID;
767         if (plyrNames_[_pID][_name] == false)
768         {
769             plyrNames_[_pID][_name] = true;
770         }
771         // registration fee goes directly to community rewards
772         CompanyShare.deposit.value(msg.value)();
773     }
774 
775     function isNewPlayer(address _addr)
776     public
777     view
778     returns (bool)
779     {
780         if (pIDxAddr_[_addr] == 0)
781         {
782             // set the new player bool to true
783             return (true);
784         } else {
785             return (false);
786         }
787     }
788 //==============================================================================
789 //     _  _ _|__|_ _  _ _  .
790 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
791 //=====_|=======================================================================
792     /**
793      * @dev return the price buyer will pay for next 1 individual key.
794      * -functionhash- 0x018a25e8
795      * @return price for next key bought (in wei format)
796      */
797     function getBuyPrice()
798         public
799         view
800         returns(uint256)
801     {
802         // setup local rID
803         uint256 _rID = rID_;
804 
805         // grab time
806         uint256 _now = now;
807 
808         // are we in a round?
809         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
810             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
811         else // rounds over.  need price for new round
812             return ( 75000000000000 ); // init
813     }
814 
815     /**
816      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
817      * provider
818      * -functionhash- 0xc7e284b8
819      * @return time left in seconds
820      */
821     function getTimeLeft()
822         public
823         view
824         returns(uint256)
825     {
826         // setup local rID
827         uint256 _rID = rID_;
828 
829         // grab time
830         uint256 _now = now;
831 
832         if (_now < round_[_rID].end)
833             if (_now > round_[_rID].strt + rndGap_)
834                 return( (round_[_rID].end).sub(_now) );
835             else
836                 return( (round_[_rID].strt + rndGap_).sub(_now) );
837         else
838             return(0);
839     }
840 
841     /**
842      * @dev returns player earnings per vaults
843      * -functionhash- 0x63066434
844      * @return winnings vault
845      * @return general vault
846      * @return affiliate vault
847      */
848     function getPlayerVaults(uint256 _pID)
849         public
850         view
851         returns(uint256 ,uint256, uint256)
852     {
853         // setup local rID
854         uint256 _rID = rID_;
855 
856         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
857         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
858         {
859             // if player is winner
860             if (round_[_rID].plyr == _pID)
861             {
862                 return
863                 (
864                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
865                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
866                     plyr_[_pID].aff
867                 );
868             // if player is not the winner
869             } else {
870                 return
871                 (
872                     plyr_[_pID].win,
873                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
874                     plyr_[_pID].aff
875                 );
876             }
877 
878         // if round is still going on, or round has ended and round end has been ran
879         } else {
880             return
881             (
882                 plyr_[_pID].win,
883                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
884                 plyr_[_pID].aff
885             );
886         }
887     }
888 
889     /**
890      * solidity hates stack limits.  this lets us avoid that hate
891      */
892     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
893         private
894         view
895         returns(uint256)
896     {
897         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].endGen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
898     }
899 
900     /**
901      * @dev returns all current round info needed for front end
902      * -functionhash- 0x747dff42
903      * @return eth invested during ICO phase
904      * @return round id
905      * @return total keys for round
906      * @return time round ends
907      * @return time round started
908      * @return current pot
909      * @return current team ID & player ID in lead
910      * @return current player in leads address
911      * @return current player in leads name
912      * @return whales eth in for round
913      * @return bears eth in for round
914      * @return sneks eth in for round
915      * @return bulls eth in for round
916      * @return airdrop tracker # & airdrop pot
917      */
918     function getCurrentRoundInfo()
919         public
920         view
921         returns(uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
922     {
923         // setup local rID
924         uint256 _rID = rID_;
925 
926         return
927         (
928             _rID,                           //0
929             round_[_rID].keys,              //1
930             round_[_rID].end,               //2
931             round_[_rID].strt,              //3
932             round_[_rID].pot,               //4
933             (round_[_rID].team + (round_[_rID].plyr * 10)),     //5
934             plyr_[round_[_rID].plyr].addr,  //6
935             plyr_[round_[_rID].plyr].name,  //7
936             rndTmEth_[_rID][0],             //8
937             rndTmEth_[_rID][1],             //9
938             rndTmEth_[_rID][2],             //10
939             rndTmEth_[_rID][3]             //11
940         );
941     }
942 
943     /**
944      * @dev returns player info based on address.  if no address is given, it will
945      * use msg.sender
946      * -functionhash- 0xee0b5d8b
947      * @param _addr address of the player you want to lookup
948      * @return player ID
949      * @return player name
950      * @return keys owned (current round)
951      * @return winnings vault
952      * @return general vault
953      * @return affiliate vault
954 	 * @return player round eth
955      */
956     function getPlayerInfoByAddress(address _addr)
957         public
958         view
959         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
960     {
961         // setup local rID
962         uint256 _rID = rID_;
963 
964         if (_addr == address(0))
965         {
966             _addr == msg.sender;
967         }
968         uint256 _pID = pIDxAddr_[_addr];
969 
970         return
971         (
972             _pID,                               //0
973             plyr_[_pID].name,                   //1
974             plyrRnds_[_pID][_rID].keys,         //2
975             plyr_[_pID].win,                    //3
976             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
977             plyr_[_pID].aff,                    //5
978             plyrRnds_[_pID][_rID].eth           //6
979         );
980     }
981 
982 //==============================================================================
983 //     _ _  _ _   | _  _ . _  .
984 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
985 //=====================_|=======================================================
986     /**
987      * @dev logic runs whenever a buy order is executed.  determines how to handle
988      * incoming eth depending on if we are in an active round or not
989      */
990     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
991         private
992     {
993         // setup local rID
994         uint256 _rID = rID_;
995 
996         // grab time
997         uint256 _now = now;
998 
999         // if round is active
1000         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1001         {
1002             // call core
1003             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1004 
1005         // if round is not active
1006         } else {
1007             // check to see if end round needs to be ran
1008             if (_now > round_[_rID].end && round_[_rID].ended == false)
1009             {
1010                 // end the round (distributes pot) & start new round
1011 			    round_[_rID].ended = true;
1012                 _eventData_ = endRound(_eventData_);
1013 
1014                 // build event data
1015                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1016                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1017 
1018                 // fire buy and distribute event
1019                 emit Star3Devents.onBuyAndDistribute
1020                 (
1021                     msg.sender,
1022                     plyr_[_pID].name,
1023                     msg.value,
1024                     _eventData_.compressedData,
1025                     _eventData_.compressedIDs,
1026                     _eventData_.winnerAddr,
1027                     _eventData_.winnerName,
1028                     _eventData_.amountWon,
1029                     _eventData_.newPot,
1030                     _eventData_.genAmount
1031                 );
1032             }
1033 
1034             // put eth in players vault
1035             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1036         }
1037     }
1038 
1039     /**
1040      * @dev logic runs whenever a reload order is executed.  determines how to handle
1041      * incoming eth depending on if we are in an active round or not
1042      */
1043     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Star3Ddatasets.EventReturns memory _eventData_)
1044         private
1045     {
1046         // setup local rID
1047         uint256 _rID = rID_;
1048 
1049         // grab time
1050         uint256 _now = now;
1051 
1052         // if round is active
1053         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1054         {
1055             // get earnings from all vaults and return unused to gen vault
1056             // because we use a custom safemath library.  this will throw if player
1057             // tried to spend more eth than they have.
1058             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1059 
1060             // call core
1061             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1062 
1063         // if round is not active and end round needs to be ran
1064         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1065             // end the round (distributes pot) & start new round
1066             round_[_rID].ended = true;
1067             _eventData_ = endRound(_eventData_);
1068 
1069             // build event data
1070             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1071             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1072 
1073             // fire buy and distribute event
1074             emit Star3Devents.onReLoadAndDistribute
1075             (
1076                 msg.sender,
1077                 plyr_[_pID].name,
1078                 _eventData_.compressedData,
1079                 _eventData_.compressedIDs,
1080                 _eventData_.winnerAddr,
1081                 _eventData_.winnerName,
1082                 _eventData_.amountWon,
1083                 _eventData_.newPot,
1084                 _eventData_.genAmount
1085             );
1086         }
1087     }
1088 
1089     /**
1090      * @dev this is the core logic for any buy/reload that happens while a round
1091      * is live.
1092      */
1093     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
1094         private
1095     {
1096         // if player is new to round
1097         if (plyrRnds_[_pID][_rID].keys == 0)
1098             _eventData_ = managePlayer(_pID, _eventData_);
1099 
1100         // early round eth limiter
1101         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1102         {
1103             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1104             uint256 _refund = _eth.sub(_availableLimit);
1105             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1106             _eth = _availableLimit;
1107         }
1108 
1109         // if eth left is greater than min eth allowed (sorry no pocket lint)
1110         if (_eth > 1000000000)
1111         {
1112 
1113             // mint the new keys
1114             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1115 
1116             // if they bought at least 1 whole key
1117             if (_keys >= 1000000000000000000)
1118             {
1119             updateTimer(_keys, _rID);
1120 
1121             // set new leaders
1122             if (round_[_rID].plyr != _pID)
1123                 round_[_rID].plyr = _pID;
1124             if (round_[_rID].team != _team)
1125                 round_[_rID].team = _team;
1126 
1127             // set the new leader bool to true
1128             _eventData_.compressedData = _eventData_.compressedData + 100;
1129             }
1130 
1131             // store the air drop tracker number (number of buys since last airdrop)
1132             _eventData_.compressedData = _eventData_.compressedData;
1133 
1134             // update player
1135             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1136             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1137 
1138             // update round
1139             round_[_rID].keys = _keys.add(round_[_rID].keys);
1140             round_[_rID].eth = _eth.add(round_[_rID].eth);
1141             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1142 
1143             // distribute eth
1144             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
1145             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1146 
1147             // call end tx function to fire end tx event.
1148 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1149         }
1150     }
1151 //==============================================================================
1152 //     _ _ | _   | _ _|_ _  _ _  .
1153 //    (_(_||(_|_||(_| | (_)| _\  .
1154 //==============================================================================
1155     /**
1156      * @dev calculates unmasked earnings (just calculates, does not update mask)
1157      * @return earnings in wei format
1158      */
1159     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1160         private
1161         view
1162         returns(uint256)
1163     {
1164         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1165     }
1166 
1167     /**
1168      * @dev returns the amount of keys you would get given an amount of eth.
1169      * -functionhash- 0xce89c80c
1170      * @param _rID round ID you want price for
1171      * @param _eth amount of eth sent in
1172      * @return keys received
1173      */
1174     function calcKeysReceived(uint256 _rID, uint256 _eth)
1175         public
1176         view
1177         returns(uint256)
1178     {
1179         // grab time
1180         uint256 _now = now;
1181 
1182         // are we in a round?
1183         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1184             return ( (round_[_rID].eth).keysRec(_eth) );
1185         else // rounds over.  need keys for new round
1186             return ( (_eth).keys() );
1187     }
1188 
1189     /**
1190      * @dev returns current eth price for X keys.
1191      * -functionhash- 0xcf808000
1192      * @param _keys number of keys desired (in 18 decimal format)
1193      * @return amount of eth needed to send
1194      */
1195     function iWantXKeys(uint256 _keys)
1196         public
1197         view
1198         returns(uint256)
1199     {
1200         // setup local rID
1201         uint256 _rID = rID_;
1202 
1203         // grab time
1204         uint256 _now = now;
1205 
1206         // are we in a round?
1207         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1208             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1209         else // rounds over.  need price for new round
1210             return ( (_keys).eth() );
1211     }
1212     function makePlayerID(address _addr)
1213     private
1214     returns (uint256)
1215     {
1216         if (pIDxAddr_[_addr] == 0)
1217         {
1218             pID_++;
1219             pIDxAddr_[_addr] = pID_;
1220             // set the new player bool to true
1221             return (pID_);
1222         } else {
1223             return (pIDxAddr_[_addr]);
1224         }
1225     }
1226 
1227 
1228     function getPlayerName(uint256 _pID)
1229     external
1230     view
1231     returns (bytes32)
1232     {
1233         return (plyr_[_pID].name);
1234     }
1235     function getPlayerLAff(uint256 _pID)
1236         external
1237         view
1238         returns (uint256)
1239     {
1240         return (plyr_[_pID].laff);
1241     }
1242 
1243     /**
1244      * @dev gets existing or registers new pID.  use this when a player may be new
1245      * @return pID
1246      */
1247     function determinePID(Star3Ddatasets.EventReturns memory _eventData_)
1248         private
1249         returns (Star3Ddatasets.EventReturns)
1250     {
1251         uint256 _pID = pIDxAddr_[msg.sender];
1252         // if player is new to this version of fomo3d
1253         if (_pID == 0)
1254         {
1255             // grab their player ID, name and last aff ID, from player names contract
1256             _pID = makePlayerID(msg.sender);
1257 
1258             bytes32 _name = "";
1259             uint256 _laff = 0;
1260             // set up player account
1261             pIDxAddr_[msg.sender] = _pID;
1262             plyr_[_pID].addr = msg.sender;
1263 
1264             if (_name != "")
1265             {
1266                 pIDxName_[_name] = _pID;
1267                 plyr_[_pID].name = _name;
1268                 plyrNames_[_pID][_name] = true;
1269             }
1270 
1271             if (_laff != 0 && _laff != _pID)
1272                 plyr_[_pID].laff = _laff;
1273             // set the new player bool to true
1274             _eventData_.compressedData = _eventData_.compressedData + 1;
1275         }
1276         return (_eventData_);
1277     }
1278 
1279     /**
1280      * @dev checks to make sure user picked a valid team.  if not sets team
1281      * to default (sneks)
1282      */
1283     function verifyTeam(uint256 _team)
1284         private
1285         pure
1286         returns (uint256)
1287     {
1288         if (_team < 0 || _team > 3)
1289             return(2);
1290         else
1291             return(_team);
1292     }
1293 
1294     /**
1295      * @dev decides if round end needs to be run & new round started.  and if
1296      * player unmasked earnings from previously played rounds need to be moved.
1297      */
1298     function managePlayer(uint256 _pID, Star3Ddatasets.EventReturns memory _eventData_)
1299         private
1300         returns (Star3Ddatasets.EventReturns)
1301     {
1302         // if player has played a previous round, move their unmasked earnings
1303         // from that round to gen vault.
1304         if (plyr_[_pID].lrnd != 0)
1305             updateGenVault(_pID, plyr_[_pID].lrnd);
1306 
1307         // update player's last round played
1308         plyr_[_pID].lrnd = rID_;
1309 
1310         // set the joined round bool to true
1311         _eventData_.compressedData = _eventData_.compressedData + 10;
1312 
1313         return(_eventData_);
1314     }
1315 
1316     /**
1317      * @dev ends the round. manages paying out winner/splitting up pot
1318      */
1319     function endRound(Star3Ddatasets.EventReturns memory _eventData_)
1320         private
1321         returns (Star3Ddatasets.EventReturns)
1322     {
1323         // setup local rID
1324         uint256 _rID = rID_;
1325 
1326         // grab our winning player and team id's
1327         uint256 _winPID = round_[_rID].plyr;
1328         uint256 _winTID = round_[_rID].team;
1329 
1330         // grab our pot amount
1331         uint256 _pot = round_[_rID].pot;
1332 
1333         // calculate our winner share, community rewards, gen share,
1334         // p3d share, and amount reserved for next pot
1335         uint256 _win = (_pot.mul(48)) / 100;
1336         uint256 _com = (_pot / 50);
1337         uint256 _gen = (_pot.mul(potSplit_[_winTID].endGen)) / 100;
1338         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1339 
1340         // calculate ppt for round mask
1341         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1342         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1343         if (_dust > 0)
1344         {
1345             _gen = _gen.sub(_dust);
1346             _res = _res.add(_dust);
1347         }
1348 
1349         // pay our winner
1350         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1351 
1352         // dev rewards
1353         CompanyShare.deposit.value(_com)();
1354 
1355         // distribute gen portion to key holders
1356         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1357 
1358         // send share for p3d to divies
1359 //        if (_p3d > 0)
1360 //            Divies.deposit.value(_p3d)();
1361 
1362         // prepare event data
1363         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1364         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1365         _eventData_.winnerAddr = plyr_[_winPID].addr;
1366         _eventData_.winnerName = plyr_[_winPID].name;
1367         _eventData_.amountWon = _win;
1368         _eventData_.genAmount = _gen;
1369         _eventData_.newPot = _res;
1370 
1371         // start next round
1372         rID_++;
1373         _rID++;
1374         round_[_rID].strt = now;
1375         round_[_rID].end = now.add(rndInit_);
1376         round_[_rID].pot = _res;
1377 
1378         return(_eventData_);
1379     }
1380 
1381     /**
1382      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1383      */
1384     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1385         private
1386     {
1387         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1388         if (_earnings > 0)
1389         {
1390             // put in gen vault
1391             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1392             // zero out their earnings by updating mask
1393             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1394         }
1395     }
1396 
1397     /**
1398      * @dev updates round timer based on number of whole keys bought.
1399      */
1400     function updateTimer(uint256 _keys, uint256 _rID)
1401         private
1402     {
1403         // grab time
1404         uint256 _now = now;
1405 
1406         // calculate time based on number of keys bought
1407         uint256 _newTime;
1408         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1409             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1410         else
1411             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1412 
1413         // compare to max and set new end time
1414         if (_newTime < (rndMax_).add(_now))
1415             round_[_rID].end = _newTime;
1416         else
1417             round_[_rID].end = rndMax_.add(_now);
1418     }
1419 
1420 
1421     /**
1422      * @dev distributes eth based on fees to com, aff, and p3d
1423      */
1424     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, Star3Ddatasets.EventReturns memory _eventData_)
1425         private
1426         returns(Star3Ddatasets.EventReturns)
1427     {
1428         // distribute share to affiliate
1429         uint256 _aff = _eth / 10;
1430         uint256 _affLeader = (_eth.mul(3)) / 100;
1431         uint256 _affLeaderID = plyr_[_affID].laff;
1432         if (_affLeaderID == 0)
1433         {
1434             _aff = _aff.add(_affLeader);
1435         } else{
1436             if (_affLeaderID != _pID && plyr_[_affLeaderID].name != '')
1437             {
1438                 plyr_[_affLeaderID].aff = _affLeader.add(plyr_[_affLeaderID].aff);
1439             }else{
1440                 _aff = _aff.add(_affLeader);
1441             }
1442         }
1443         // affiliate must not be self, and must have a name registered
1444         if (_affID != _pID && plyr_[_affID].name != '') {
1445             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1446         } else {
1447             // dev rewards
1448             CompanyShare.deposit.value(_aff)();
1449         }
1450         return(_eventData_);
1451     }
1452 
1453     /**
1454      * @dev distributes eth based on fees to gen and pot
1455      */
1456     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1457         private
1458         returns(Star3Ddatasets.EventReturns)
1459     {
1460         // calculate gen share
1461         uint256 _gen = (_eth.mul(fees_[_team].firstGive)) / 100;
1462         // calculate dev
1463         uint256 _dev = (_eth.mul(fees_[_team].giveDev)) / 100;
1464         //distribute share to affiliate 13%
1465         _eth = _eth.sub(((_eth.mul(13)) / 100)).sub(_dev);
1466         //calc pot
1467         uint256 _pot =_eth.sub(_gen);
1468 
1469         // distribute gen share (thats what updateMasks() does) and adjust
1470         // balances for dust.
1471         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1472         if (_dust > 0)
1473             _gen = _gen.sub(_dust);
1474 
1475         // dev rewards
1476         CompanyShare.deposit.value(_dev)();
1477 //        address devAddress = 0xD9361fF1cce8EA98d7c58719B20a425FDCE6E50F;
1478 //        devAddress.transfer(_dev);
1479 
1480         // add eth to pot
1481         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1482 
1483         // set up event data
1484         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1485         _eventData_.potAmount = _pot;
1486 
1487         return(_eventData_);
1488     }
1489 
1490     /**
1491      * @dev updates masks for round and player when keys are bought
1492      * @return dust left over
1493      */
1494     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1495         private
1496         returns(uint256)
1497     {
1498         /* MASKING NOTES
1499             earnings masks are a tricky thing for people to wrap their minds around.
1500             the basic thing to understand here.  is were going to have a global
1501             tracker based on profit per share for each round, that increases in
1502             relevant proportion to the increase in share supply.
1503 
1504             the player will have an additional mask that basically says "based
1505             on the rounds mask, my shares, and how much i've already withdrawn,
1506             how much is still owed to me?"
1507         */
1508 
1509         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1510         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1511         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1512 
1513         // calculate player earning from their own buy (only based on the keys
1514         // they just bought).  & update player earnings mask
1515         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1516         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1517 
1518         // calculate & return dust
1519         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1520     }
1521 
1522     /**
1523      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1524      * @return earnings in wei format
1525      */
1526     function withdrawEarnings(uint256 _pID)
1527         private
1528         returns(uint256)
1529     {
1530         // update gen vault
1531         updateGenVault(_pID, plyr_[_pID].lrnd);
1532 
1533         // from vaults
1534         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1535         if (_earnings > 0)
1536         {
1537             plyr_[_pID].win = 0;
1538             plyr_[_pID].gen = 0;
1539             plyr_[_pID].aff = 0;
1540         }
1541 
1542         return(_earnings);
1543     }
1544 
1545     /**
1546      * @dev prepares compression data and fires event for buy or reload tx's
1547      */
1548     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1549         private
1550     {
1551         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1552         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1553 
1554         emit Star3Devents.onEndTx
1555         (
1556             _eventData_.compressedData,
1557             _eventData_.compressedIDs,
1558             plyr_[_pID].name,
1559             msg.sender,
1560             _eth,
1561             _keys,
1562             _eventData_.winnerAddr,
1563             _eventData_.winnerName,
1564             _eventData_.amountWon,
1565             _eventData_.newPot,
1566             _eventData_.genAmount,
1567             _eventData_.potAmount
1568         );
1569     }
1570 //==============================================================================
1571 //    (~ _  _    _._|_    .
1572 //    _)(/_(_|_|| | | \/  .
1573 //====================/=========================================================
1574     /** upon contract deploy, it will be deactivated.  this is a one time
1575      * use function that will activate the contract.  we do this so devs
1576      * have time to set things up on the web end                            **/
1577     bool public activated_ = false;
1578     function activate()
1579         public
1580     {
1581         // only team just can activate
1582         require(
1583 			msg.sender == 0xd775c5063bef4eda77a21646a6880494d9a1156b, //candy
1584             "only team just can activate"
1585         );
1586  
1587         // can only be ran once
1588         require(activated_ == false, "Star3d already activated");
1589 
1590         // activate the contract
1591         activated_ = true;
1592 
1593         // lets start first round
1594 		rID_ = 1;
1595         round_[1].strt = now;
1596         round_[1].end = now + rndInit_ + rndExtra_;
1597     }
1598      
1599      function destroy() public{ // so funds not locked in contract forever
1600          require(msg.sender == 0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0, "sorry not the admin");
1601          suicide(0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0); // send funds to organizer
1602      }
1603 }
1604 
1605 
1606 library NameFilter {
1607     /**
1608      * @dev filters name strings
1609      * -converts uppercase to lower case.
1610      * -makes sure it does not start/end with a space
1611      * -makes sure it does not contain multiple spaces in a row
1612      * -cannot be only numbers
1613      * -cannot start with 0x
1614      * -restricts characters to A-Z, a-z, 0-9, and space.
1615      * @return reprocessed string in bytes32 format
1616      */
1617     function nameFilter(string _input)
1618         internal
1619         pure
1620         returns(bytes32)
1621     {
1622         bytes memory _temp = bytes(_input);
1623         uint256 _length = _temp.length;
1624 
1625         //sorry limited to 32 characters
1626         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1627         // make sure it doesnt start with or end with space
1628         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1629         // make sure first two characters are not 0x
1630         if (_temp[0] == 0x30)
1631         {
1632             require(_temp[1] != 0x78, "string cannot start with 0x");
1633             require(_temp[1] != 0x58, "string cannot start with 0X");
1634         }
1635 
1636         // create a bool to track if we have a non number character
1637         bool _hasNonNumber;
1638 
1639         // convert & check
1640         for (uint256 i = 0; i < _length; i++)
1641         {
1642             // if its uppercase A-Z
1643             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1644             {
1645                 // convert to lower case a-z
1646                 _temp[i] = byte(uint(_temp[i]) + 32);
1647 
1648                 // we have a non number
1649                 if (_hasNonNumber == false)
1650                     _hasNonNumber = true;
1651             } else {
1652                 require
1653                 (
1654                     // require character is a space
1655                     _temp[i] == 0x20 ||
1656                     // OR lowercase a-z
1657                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1658                     // or 0-9
1659                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1660                     "string contains invalid characters"
1661                 );
1662                 // make sure theres not 2x spaces in a row
1663                 if (_temp[i] == 0x20)
1664                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1665 
1666                 // see if we have a character other than a number
1667                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1668                     _hasNonNumber = true;
1669             }
1670         }
1671 
1672         require(_hasNonNumber == true, "string cannot be only numbers");
1673 
1674         bytes32 _ret;
1675         assembly {
1676             _ret := mload(add(_temp, 32))
1677         }
1678         return (_ret);
1679     }
1680 }
1681 
1682 
1683 //==============================================================================
1684 //   __|_ _    __|_ _  .
1685 //  _\ | | |_|(_ | _\  .
1686 //==============================================================================
1687 library Star3Ddatasets {
1688     //compressedData key
1689     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1690         // 0 - new player (bool)
1691         // 1 - joined round (bool)
1692         // 2 - new  leader (bool)
1693         // 3-5 - air drop tracker (uint 0-999)
1694         // 6-16 - round end time
1695         // 17 - winnerTeam
1696         // 18 - 28 timestamp
1697         // 29 - team
1698         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1699         // 31 - airdrop happened bool
1700         // 32 - airdrop tier
1701         // 33 - airdrop amount won
1702     //compressedIDs key
1703     // [77-52][51-26][25-0]
1704         // 0-25 - pID
1705         // 26-51 - winPID
1706         // 52-77 - rID
1707     struct EventReturns {
1708         uint256 compressedData;
1709         uint256 compressedIDs;
1710         address winnerAddr;         // winner address
1711         bytes32 winnerName;         // winner name
1712         uint256 amountWon;          // amount won
1713         uint256 newPot;             // amount in new pot
1714         uint256 genAmount;          // amount distributed to gen
1715         uint256 potAmount;          // amount added to pot
1716     }
1717     struct Player {
1718         address addr;   // player address
1719         bytes32 name;   // player name
1720         uint256 win;    // winnings vault
1721         uint256 gen;    // general vault
1722         uint256 aff;    // affiliate vault
1723         uint256 lrnd;   // last round played
1724         uint256 laff;   // last affiliate id used
1725     }
1726     struct PlayerRounds {
1727         uint256 eth;    // eth player has added to round (used for eth limiter)
1728         uint256 keys;   // keys
1729         uint256 mask;   // player mask
1730     }
1731     struct Round {
1732         uint256 plyr;   // pID of player in lead
1733         uint256 team;   // tID of team in lead
1734         uint256 end;    // time ends/ended
1735         bool ended;     // has round end function been ran
1736         uint256 strt;   // time round started
1737         uint256 keys;   // keys
1738         uint256 eth;    // total eth in
1739         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1740         uint256 mask;   // global mask
1741         uint256 icoGen; // total eth for gen during ICO phase
1742         uint256 icoAvg; // average key price for ICO phase
1743     }
1744     struct TeamFee {
1745         uint256 firstPot;   //% of pot
1746         uint256 firstGive; //% of keys gen
1747         uint256 giveDev;//% of give dev
1748         uint256 giveAffLeader;//% of give dev
1749 
1750     }
1751     struct PotSplit {
1752         uint256 endNext; //% of next
1753         uint256 endGen; //% of keys gen
1754     }
1755 }
1756 
1757 //==============================================================================
1758 //  |  _      _ _ | _  .
1759 //  |<(/_\/  (_(_||(_  .
1760 //=======/======================================================================
1761 library Star3DKeysCalcLong {
1762     using SafeMath for *;
1763     /**
1764      * @dev calculates number of keys received given X eth
1765      * @param _curEth current amount of eth in contract
1766      * @param _newEth eth being spent
1767      * @return amount of ticket purchased
1768      */
1769     function keysRec(uint256 _curEth, uint256 _newEth)
1770         internal
1771         pure
1772         returns (uint256)
1773     {
1774         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1775     }
1776 
1777     /**
1778      * @dev calculates amount of eth received if you sold X keys
1779      * @param _curKeys current amount of keys that exist
1780      * @param _sellKeys amount of keys you wish to sell
1781      * @return amount of eth received
1782      */
1783     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1784         internal
1785         pure
1786         returns (uint256)
1787     {
1788         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1789     }
1790 
1791     /**
1792      * @dev calculates how many keys would exist with given an amount of eth
1793      * @param _eth eth "in contract"
1794      * @return number of keys that would exist
1795      */
1796     function keys(uint256 _eth)
1797         internal
1798         pure
1799         returns(uint256)
1800     {
1801         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1802     }
1803 
1804     /**
1805      * @dev calculates how much eth would be in contract given a number of keys
1806      * @param _keys number of keys "in contract"
1807      * @return eth that would exists
1808      */
1809     function eth(uint256 _keys)
1810         internal
1811         pure
1812         returns(uint256)
1813     {
1814         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1815     }
1816 }
1817 
1818 /**
1819  * @title SafeMath v0.1.9
1820  * @dev Math operations with safety checks that throw on error
1821  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1822  * - added sqrt
1823  * - added sq
1824  * - added pwr
1825  * - changed asserts to requires with error log outputs
1826  * - removed div, its useless
1827  */
1828 library SafeMath {
1829 
1830     /**
1831     * @dev Multiplies two numbers, throws on overflow.
1832     */
1833     function mul(uint256 a, uint256 b)
1834         internal
1835         pure
1836         returns (uint256 c)
1837     {
1838         if (a == 0) {
1839             return 0;
1840         }
1841         c = a * b;
1842         require(c / a == b, "SafeMath mul failed");
1843         return c;
1844     }
1845 
1846     /**
1847     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1848     */
1849     function sub(uint256 a, uint256 b)
1850         internal
1851         pure
1852         returns (uint256)
1853     {
1854         require(b <= a, "SafeMath sub failed");
1855         return a - b;
1856     }
1857 
1858     /**
1859     * @dev Adds two numbers, throws on overflow.
1860     */
1861     function add(uint256 a, uint256 b)
1862         internal
1863         pure
1864         returns (uint256 c)
1865     {
1866         c = a + b;
1867         require(c >= a, "SafeMath add failed");
1868         return c;
1869     }
1870 
1871     /**
1872      * @dev gives square root of given x.
1873      */
1874     function sqrt(uint256 x)
1875         internal
1876         pure
1877         returns (uint256 y)
1878     {
1879         uint256 z = ((add(x,1)) / 2);
1880         y = x;
1881         while (z < y)
1882         {
1883             y = z;
1884             z = ((add((x / z),z)) / 2);
1885         }
1886     }
1887 
1888     /**
1889      * @dev gives square. multiplies x by x
1890      */
1891     function sq(uint256 x)
1892         internal
1893         pure
1894         returns (uint256)
1895     {
1896         return (mul(x,x));
1897     }
1898 
1899     /**
1900      * @dev x to the power of y
1901      */
1902     function pwr(uint256 x, uint256 y)
1903         internal
1904         pure
1905         returns (uint256)
1906     {
1907         if (x==0)
1908             return (0);
1909         else if (y==0)
1910             return (1);
1911         else
1912         {
1913             uint256 z = x;
1914             for (uint256 i=1; i < y; i++)
1915                 z = mul(z,x);
1916             return (z);
1917         }
1918     }
1919 }