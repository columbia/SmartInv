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
184     address public admin;
185 //==============================================================================
186 //     _ _  _  |`. _     _ _ |_ | _  _  .
187 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
188 //=================_|===========================================================
189     string constant public name = "Save the planet";
190     string constant public symbol = "Star";
191     CompanyShareInterface constant private CompanyShare = CompanyShareInterface(0xdba6f4fe7e8a358150fc861148c3a19b22242743);
192 
193     uint256 private pID_ = 0;   // total number of players
194 	uint256 private rndExtra_ = 0;     // length of the very first ICO
195     uint256 private rndGap_ = 1 seconds;         // length of ICO phase, set to 1 year for EOS.
196     uint256 constant private rndInit_ = 30 minutes;                // round timer starts at this
197     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
198     uint256 constant private rndMax_ = 30 minutes;                // max length a round timer can be
199     uint256 public registrationFee_ = 10 finney;            // price to register a name
200 
201 //==============================================================================
202 //     _| _ _|_ _    _ _ _|_    _   .
203 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
204 //=============================|================================================
205 //	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
206 //    uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
207     uint256 public rID_;    // round id number / total rounds that have happened
208 //****************
209 // PLAYER DATA 
210 //****************
211     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
212     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
213     mapping (uint256 => Star3Ddatasets.Player) public plyr_;   // (pID => data) player data
214     mapping (uint256 => mapping (uint256 => Star3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
215     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
216 //****************
217 // ROUND DATA
218 //****************
219     mapping (uint256 => Star3Ddatasets.Round) public round_;   // (rID => data) round data
220     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
221 //****************
222 // TEAM FEE DATA
223 //****************
224     mapping (uint256 => Star3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
225     mapping (uint256 => Star3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
226 //==============================================================================
227 //     _ _  _  __|_ _    __|_ _  _  .
228 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
229 //==============================================================================
230     constructor()
231         public
232     {
233         admin = msg.sender;
234 		// Team allocation structures
235         // 0 = whales
236         // 1 = bears
237         // 2 = sneks
238         // 3 = bulls
239 
240 		// Team allocation percentages
241         // (Star, None) + (Pot , Referrals, Community)
242             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
243         fees_[0] = Star3Ddatasets.TeamFee(32, 45, 10, 3);   //32% to pot, 56% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
244         fees_[1] = Star3Ddatasets.TeamFee(45, 32, 10, 3);   //45% to pot, 35% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
245         fees_[2] = Star3Ddatasets.TeamFee(50, 27, 10, 3);  //50% to pot, 30% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
246         fees_[3] = Star3Ddatasets.TeamFee(40, 37, 10, 3);   //48% to pot, 40% to gen, 2% to dev, 48% to winner, 10% aff 3% affLeader
247 
248 //        // how to split up the final pot based on which team was picked
249 //        // (Star, None)
250         potSplit_[0] = Star3Ddatasets.PotSplit(20, 30);  //48% to winner, 20% to next round, 30% to gen, 2% to com
251         potSplit_[1] = Star3Ddatasets.PotSplit(15, 35);   //48% to winner, 15% to next round, 35% to gen, 2% to com
252         potSplit_[2] = Star3Ddatasets.PotSplit(25, 25);  //48% to winner, 25% to next round, 25% to gen, 2% to com
253         potSplit_[3] = Star3Ddatasets.PotSplit(30, 20);  //48% to winner, 30% to next round, 20% to gen, 2% to com
254 	}
255 //==============================================================================
256 //     _ _  _  _|. |`. _  _ _  .
257 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
258 //==============================================================================
259     /**
260      * @dev used to make sure no one can interact with contract until it has
261      * been activated.
262      */
263     modifier isActivated() {
264         require(activated_ == true, "its not ready yet.  check ?eta in discord");
265         _;
266     }
267 
268     modifier isRegisteredName()
269     {
270         uint256 _pID = pIDxAddr_[msg.sender];
271         require(plyr_[_pID].name == "" || _pID == 0, "already has name");
272         _;
273     }
274     /**
275      * @dev prevents contracts from interacting with fomo3d
276      */
277     modifier isHuman() {
278         address _addr = msg.sender;
279         uint256 _codeLength;
280 
281         assembly {_codeLength := extcodesize(_addr)}
282         require(_codeLength == 0, "sorry humans only");
283         _;
284     }
285 
286     /**
287      * @dev sets boundaries for incoming tx
288      */
289     modifier isWithinLimits(uint256 _eth) {
290         require(_eth >= 1000000000, "pocket lint: not a valid currency");
291         require(_eth <= 100000000000000000000000, "no vitalik, no");
292         _;
293     }
294 
295 //==============================================================================
296 //     _    |_ |. _   |`    _  __|_. _  _  _  .
297 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
298 //====|=========================================================================
299     /**
300      * @dev emergency buy uses last stored affiliate ID and team snek
301      */
302     function()
303         isActivated()
304         isHuman()
305         isWithinLimits(msg.value)
306         public
307         payable
308     {
309         // set up our tx event data and determine if player is new or not
310         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
311 
312         // fetch player id
313         uint256 _pID = pIDxAddr_[msg.sender];
314 
315         // buy core
316         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
317     }
318 
319     /**
320      * @dev converts all incoming ethereum to keys.
321      * -functionhash- 0x8f38f309 (using ID for affiliate)
322      * -functionhash- 0x98a0871d (using address for affiliate)
323      * -functionhash- 0xa65b37a1 (using name for affiliate)
324      * @param _affCode the ID/address/name of the player who gets the affiliate fee
325      * @param _team what team is the player playing for?
326      */
327     function buyXid(uint256 _affCode, uint256 _team)
328         isActivated()
329         isHuman()
330         isWithinLimits(msg.value)
331         public
332         payable
333     {
334         // set up our tx event data and determine if player is new or not
335         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
336 
337         // fetch player id
338         uint256 _pID = pIDxAddr_[msg.sender];
339 
340         // manage affiliate residuals
341         // if no affiliate code was given or player tried to use their own, lolz
342         if (_affCode == 0 || _affCode == _pID)
343         {
344             // use last stored affiliate code
345             _affCode = plyr_[_pID].laff;
346 
347         // if affiliate code was given & its not the same as previously stored
348         } else if (_affCode != plyr_[_pID].laff) {
349             // update last affiliate
350             plyr_[_pID].laff = _affCode;
351         }
352 
353         // verify a valid team was selected
354         _team = verifyTeam(_team);
355 
356         // buy core
357         buyCore(_pID, _affCode, _team, _eventData_);
358     }
359 
360     function buyXaddr(address _affCode, uint256 _team)
361         isActivated()
362         isHuman()
363         isWithinLimits(msg.value)
364         public
365         payable
366     {
367         // set up our tx event data and determine if player is new or not
368         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
369 
370         // fetch player id
371         uint256 _pID = pIDxAddr_[msg.sender];
372 
373         // verify a valid team was selected
374         _team = verifyTeam(_team);
375         // manage affiliate residuals
376         uint256 _affID;
377         // if no affiliate code was given or player tried to use their own, lolz
378         if (_affCode == address(0) || _affCode == msg.sender)
379         {
380             // use last stored affiliate code
381             _affID = plyr_[_pID].laff;
382 
383         // if affiliate code was given
384         } else {
385             // get affiliate ID from aff Code
386             _affID = pIDxAddr_[_affCode];
387 
388             // if affID is not the same as previously stored
389             if (_affID != plyr_[_pID].laff)
390             {
391                 // update last affiliate
392                 plyr_[_pID].laff = _affID;
393             }
394         }
395         // buy core
396         buyCore(_pID, _affID, _team, _eventData_);
397     }
398 
399     function buyXname(bytes32 _affCode, uint256 _team)
400         isActivated()
401         isHuman()
402         isWithinLimits(msg.value)
403         public
404         payable
405     {
406         // set up our tx event data and determine if player is new or not
407         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
408 
409         // fetch player id
410         uint256 _pID = pIDxAddr_[msg.sender];
411 
412         // manage affiliate residuals
413         uint256 _affID;
414         // if no affiliate code was given or player tried to use their own, lolz
415         if (_affCode == '' || _affCode == plyr_[_pID].name)
416         {
417             // use last stored affiliate code
418             _affID = plyr_[_pID].laff;
419 
420         // if affiliate code was given
421         } else {
422             // get affiliate ID from aff Code
423             _affID = pIDxName_[_affCode];
424 
425             // if affID is not the same as previously stored
426             if (_affID != plyr_[_pID].laff)
427             {
428                 // update last affiliate
429                 plyr_[_pID].laff = _affID;
430             }
431         }
432 
433         // verify a valid team was selected
434         _team = verifyTeam(_team);
435 
436         // buy core
437         buyCore(_pID, _affID, _team, _eventData_);
438     }
439 
440     /**
441      * @dev essentially the same as buy, but instead of you sending ether
442      * from your wallet, it uses your unwithdrawn earnings.
443      * -functionhash- 0x349cdcac (using ID for affiliate)
444      * -functionhash- 0x82bfc739 (using address for affiliate)
445      * -functionhash- 0x079ce327 (using name for affiliate)
446      * @param _affCode the ID/address/name of the player who gets the affiliate fee
447      * @param _team what team is the player playing for?
448      * @param _eth amount of earnings to use (remainder returned to gen vault)
449      */
450     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
451         isActivated()
452         isHuman()
453         isWithinLimits(_eth)
454         public
455     {
456         // set up our tx event data
457         Star3Ddatasets.EventReturns memory _eventData_;
458 
459         // fetch player ID
460         uint256 _pID = pIDxAddr_[msg.sender];
461 
462         // manage affiliate residuals
463         // if no affiliate code was given or player tried to use their own, lolz
464         if (_affCode == 0 || _affCode == _pID)
465         {
466             // use last stored affiliate code
467             _affCode = plyr_[_pID].laff;
468 
469         // if affiliate code was given & its not the same as previously stored
470         } else if (_affCode != plyr_[_pID].laff) {
471             // update last affiliate
472             plyr_[_pID].laff = _affCode;
473         }
474 
475         // verify a valid team was selected
476         _team = verifyTeam(_team);
477 
478         // reload core
479         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
480     }
481 
482     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
483         isActivated()
484         isHuman()
485         isWithinLimits(_eth)
486         public
487     {
488         // set up our tx event data
489         Star3Ddatasets.EventReturns memory _eventData_;
490 
491         // fetch player ID
492         uint256 _pID = pIDxAddr_[msg.sender];
493 
494         // manage affiliate residuals
495         uint256 _affID;
496         // if no affiliate code was given or player tried to use their own, lolz
497         if (_affCode == address(0) || _affCode == msg.sender)
498         {
499             // use last stored affiliate code
500             _affID = plyr_[_pID].laff;
501 
502         // if affiliate code was given
503         } else {
504             // get affiliate ID from aff Code
505             _affID = pIDxAddr_[_affCode];
506 
507             // if affID is not the same as previously stored
508             if (_affID != plyr_[_pID].laff)
509             {
510                 // update last affiliate
511                 plyr_[_pID].laff = _affID;
512             }
513         }
514 
515         // verify a valid team was selected
516         _team = verifyTeam(_team);
517 
518         // reload core
519         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
520     }
521 
522     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
523         isActivated()
524         isHuman()
525         isWithinLimits(_eth)
526         public
527     {
528         // set up our tx event data
529         Star3Ddatasets.EventReturns memory _eventData_;
530 
531         // fetch player ID
532         uint256 _pID = pIDxAddr_[msg.sender];
533 
534         // manage affiliate residuals
535         uint256 _affID;
536         // if no affiliate code was given or player tried to use their own, lolz
537         if (_affCode == '' || _affCode == plyr_[_pID].name)
538         {
539             // use last stored affiliate code
540             _affID = plyr_[_pID].laff;
541 
542         // if affiliate code was given
543         } else {
544             // get affiliate ID from aff Code
545             _affID = pIDxName_[_affCode];
546 
547             // if affID is not the same as previously stored
548             if (_affID != plyr_[_pID].laff)
549             {
550                 // update last affiliate
551                 plyr_[_pID].laff = _affID;
552             }
553         }
554 
555         // verify a valid team was selected
556         _team = verifyTeam(_team);
557 
558         // reload core
559         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
560     }
561 
562     /**
563      * @dev withdraws all of your earnings.
564      * -functionhash- 0x3ccfd60b
565      */
566     function withdraw()
567         isActivated()
568         isHuman()
569         public
570     {
571         // setup local rID
572         uint256 _rID = rID_;
573 
574         // grab time
575         uint256 _now = now;
576 
577         // fetch player ID
578         uint256 _pID = pIDxAddr_[msg.sender];
579 
580         // setup temp var for player eth
581         uint256 _eth;
582 
583         // check to see if round has ended and no one has run round end yet
584         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
585         {
586             // set up our tx event data
587             Star3Ddatasets.EventReturns memory _eventData_;
588 
589             // end the round (distributes pot)
590 			round_[_rID].ended = true;
591             _eventData_ = endRound(_eventData_);
592 
593 			// get their earnings
594             _eth = withdrawEarnings(_pID);
595 
596             // gib moni
597             if (_eth > 0)
598                 plyr_[_pID].addr.transfer(_eth);
599 
600             // build event data
601             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
602             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
603 
604             // fire withdraw and distribute event
605             emit Star3Devents.onWithdrawAndDistribute
606             (
607                 msg.sender,
608                 plyr_[_pID].name,
609                 _eth,
610                 _eventData_.compressedData,
611                 _eventData_.compressedIDs,
612                 _eventData_.winnerAddr,
613                 _eventData_.winnerName,
614                 _eventData_.amountWon,
615                 _eventData_.newPot,
616                 _eventData_.genAmount
617             );
618 
619         // in any other situation
620         } else {
621             // get their earnings
622             _eth = withdrawEarnings(_pID);
623 
624             // gib moni
625             if (_eth > 0)
626                 plyr_[_pID].addr.transfer(_eth);
627 
628             // fire withdraw event
629             emit Star3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
630         }
631     }
632 
633 
634     /**
635      * @dev use these to register names.  they are just wrappers that will send the
636      * registration requests to the PlayerBook contract.  So registering here is the
637      * same as registering there.  UI will always display the last name you registered.
638      * but you will still own all previously registered names to use as affiliate
639      * links.
640      * - must pay a registration fee.
641      * - name must be unique
642      * - names will be converted to lowercase
643      * - name cannot start or end with a space
644      * - cannot have more than 1 space in a row
645      * - cannot be only numbers
646      * - cannot start with 0x
647      * - name must be at least 1 char
648      * - max length of 32 characters long
649      * - allowed characters: a-z, 0-9, and space
650      * -functionhash- 0x921dec21 (using ID for affiliate)
651      * -functionhash- 0x3ddd4698 (using address for affiliate)
652      * -functionhash- 0x685ffd83 (using name for affiliate)
653      * @param _nameString players desired name
654      * @param _affCode affiliate ID, address, or name of who referred you
655      * (this might cost a lot of gas)
656      */
657     function registerNameXID(string _nameString, uint256 _affCode)
658         isHuman()
659         isRegisteredName()
660         public
661         payable
662     {
663         bytes32 _name = _nameString.nameFilter();
664         address _addr = msg.sender;
665         uint256 _paid = msg.value;
666 
667         bool _isNewPlayer = isNewPlayer(_addr);
668         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
669 
670         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
671 
672         uint256 _pID = makePlayerID(msg.sender);
673         uint256 _affID = _affCode;
674         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
675         {
676             // update last affiliate
677             plyr_[_pID].laff = _affID;
678         } else if (_affID == _pID) {
679             _affID = 0;
680         }
681         registerNameCore(_pID, _name);
682         // fire event
683         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
684     }
685 
686     function registerNameXaddr(string _nameString, address _affCode)
687         isHuman()
688         isRegisteredName()
689         public
690         payable
691     {
692         bytes32 _name = _nameString.nameFilter();
693         address _addr = msg.sender;
694         uint256 _paid = msg.value;
695 
696         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
697 
698         bool _isNewPlayer = isNewPlayer(_addr);
699 
700         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
701 
702         uint256 _pID = makePlayerID(msg.sender);
703         uint256 _affID;
704         if (_affCode != address(0) && _affCode != _addr)
705         {
706             // get affiliate ID from aff Code
707             _affID = pIDxAddr_[_affCode];
708 
709             // if affID is not the same as previously stored
710             if (_affID != plyr_[_pID].laff)
711             {
712                 // update last affiliate
713                 plyr_[_pID].laff = _affID;
714             }
715         }
716 
717         registerNameCore(_pID, _name);
718         // fire event
719         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
720     }
721 
722     function registerNameXname(string _nameString, bytes32 _affCode)
723         isHuman()
724         isRegisteredName()
725         public
726         payable
727     {
728         bytes32 _name = _nameString.nameFilter();
729         address _addr = msg.sender;
730         uint256 _paid = msg.value;
731 
732         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
733 
734         bool _isNewPlayer = isNewPlayer(_addr);
735 
736         Star3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
737         uint256 _pID = makePlayerID(msg.sender);
738 
739         uint256 _affID;
740         if (_affCode != "" && _affCode != _name)
741         {
742             // get affiliate ID from aff Code
743             _affID = pIDxName_[_affCode];
744 
745             // if affID is not the same as previously stored
746             if (_affID != plyr_[_pID].laff)
747             {
748                 // update last affiliate
749                 plyr_[_pID].laff = _affID;
750             }
751         }
752 
753         registerNameCore(_pID, _name);
754         // fire event
755         emit Star3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
756     }
757 
758     function registerNameCore(uint256 _pID, bytes32 _name)
759         private
760     {
761 
762         // if names already has been used, require that current msg sender owns the name
763         if (pIDxName_[_name] != 0)
764             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
765 
766         // add name to player profile, registry, and name book
767         plyr_[_pID].name = _name;
768         pIDxName_[_name] = _pID;
769         if (plyrNames_[_pID][_name] == false)
770         {
771             plyrNames_[_pID][_name] = true;
772         }
773         // registration fee goes directly to community rewards
774         CompanyShare.deposit.value(msg.value)();
775     }
776 
777     function isNewPlayer(address _addr)
778     public
779     view
780     returns (bool)
781     {
782         if (pIDxAddr_[_addr] == 0)
783         {
784             // set the new player bool to true
785             return (true);
786         } else {
787             return (false);
788         }
789     }
790 //==============================================================================
791 //     _  _ _|__|_ _  _ _  .
792 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
793 //=====_|=======================================================================
794     /**
795      * @dev return the price buyer will pay for next 1 individual key.
796      * -functionhash- 0x018a25e8
797      * @return price for next key bought (in wei format)
798      */
799     function getBuyPrice()
800         public
801         view
802         returns(uint256)
803     {
804         // setup local rID
805         uint256 _rID = rID_;
806 
807         // grab time
808         uint256 _now = now;
809 
810         uint256 _timePrice = getBuyPriceTimes();
811         // are we in a round?
812         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
813             return (((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000)).mul(_timePrice));
814         else // rounds over.  need price for new round
815             return ( 750000000000000 ); // init
816     }
817 
818     function getBuyPriceTimes()
819         public
820         view
821         returns(uint256)
822     {
823         uint256 timeLeft = getTimeLeft();
824         if(timeLeft <= 300)
825         {
826             return 10;
827         }else{
828             return 1;
829         }
830     }
831     /**
832      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
833      * provider
834      * -functionhash- 0xc7e284b8
835      * @return time left in seconds
836      */
837     function getTimeLeft()
838         public
839         view
840         returns(uint256)
841     {
842         // setup local rID
843         uint256 _rID = rID_;
844 
845         // grab time
846         uint256 _now = now;
847 
848         if (_now < round_[_rID].end)
849             if (_now > round_[_rID].strt + rndGap_)
850                 return( (round_[_rID].end).sub(_now) );
851             else
852                 return( (round_[_rID].strt + rndGap_).sub(_now) );
853         else
854             return(0);
855     }
856 
857     /**
858      * @dev returns player earnings per vaults
859      * -functionhash- 0x63066434
860      * @return winnings vault
861      * @return general vault
862      * @return affiliate vault
863      */
864     function getPlayerVaults(uint256 _pID)
865         public
866         view
867         returns(uint256 ,uint256, uint256)
868     {
869         // setup local rID
870         uint256 _rID = rID_;
871 
872         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
873         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
874         {
875             // if player is winner
876             if (round_[_rID].plyr == _pID)
877             {
878                 return
879                 (
880                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
881                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
882                     plyr_[_pID].aff
883                 );
884             // if player is not the winner
885             } else {
886                 return
887                 (
888                     plyr_[_pID].win,
889                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
890                     plyr_[_pID].aff
891                 );
892             }
893 
894         // if round is still going on, or round has ended and round end has been ran
895         } else {
896             return
897             (
898                 plyr_[_pID].win,
899                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
900                 plyr_[_pID].aff
901             );
902         }
903     }
904 
905     /**
906      * solidity hates stack limits.  this lets us avoid that hate
907      */
908     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
909         private
910         view
911         returns(uint256)
912     {
913         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].endGen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
914     }
915 
916     /**
917      * @dev returns all current round info needed for front end
918      * -functionhash- 0x747dff42
919      * @return eth invested during ICO phase
920      * @return round id
921      * @return total keys for round
922      * @return time round ends
923      * @return time round started
924      * @return current pot
925      * @return current team ID & player ID in lead
926      * @return current player in leads address
927      * @return current player in leads name
928      * @return whales eth in for round
929      * @return bears eth in for round
930      * @return sneks eth in for round
931      * @return bulls eth in for round
932      * @return airdrop tracker # & airdrop pot
933      */
934     function getCurrentRoundInfo()
935         public
936         view
937         returns(uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256)
938     {
939         // setup local rID
940         uint256 _rID = rID_;
941 
942         return
943         (
944             _rID,                           //0
945             round_[_rID].keys,              //1
946             round_[_rID].end,               //2
947             round_[_rID].strt,              //3
948             round_[_rID].pot,               //4
949             (round_[_rID].team + (round_[_rID].plyr * 10)),     //5
950             plyr_[round_[_rID].plyr].addr,  //6
951             plyr_[round_[_rID].plyr].name,  //7
952             rndTmEth_[_rID][0],             //8
953             rndTmEth_[_rID][1],             //9
954             rndTmEth_[_rID][2],             //10
955             rndTmEth_[_rID][3]             //11
956         );
957     }
958 
959     /**
960      * @dev returns player info based on address.  if no address is given, it will
961      * use msg.sender
962      * -functionhash- 0xee0b5d8b
963      * @param _addr address of the player you want to lookup
964      * @return player ID
965      * @return player name
966      * @return keys owned (current round)
967      * @return winnings vault
968      * @return general vault
969      * @return affiliate vault
970 	 * @return player round eth
971      */
972     function getPlayerInfoByAddress(address _addr)
973         public
974         view
975         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
976     {
977         // setup local rID
978         uint256 _rID = rID_;
979 
980         if (_addr == address(0))
981         {
982             _addr == msg.sender;
983         }
984         uint256 _pID = pIDxAddr_[_addr];
985 
986         return
987         (
988             _pID,                               //0
989             plyr_[_pID].name,                   //1
990             plyrRnds_[_pID][_rID].keys,         //2
991             plyr_[_pID].win,                    //3
992             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
993             plyr_[_pID].aff,                    //5
994             plyrRnds_[_pID][_rID].eth           //6
995         );
996     }
997 
998 //==============================================================================
999 //     _ _  _ _   | _  _ . _  .
1000 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
1001 //=====================_|=======================================================
1002     /**
1003      * @dev logic runs whenever a buy order is executed.  determines how to handle
1004      * incoming eth depending on if we are in an active round or not
1005      */
1006     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
1007         private
1008     {
1009         // setup local rID
1010         uint256 _rID = rID_;
1011 
1012         // grab time
1013         uint256 _now = now;
1014 
1015         // if round is active
1016         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1017         {
1018             // call core
1019             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
1020 
1021         // if round is not active
1022         } else {
1023             // check to see if end round needs to be ran
1024             if (_now > round_[_rID].end && round_[_rID].ended == false)
1025             {
1026                 // end the round (distributes pot) & start new round
1027 			    round_[_rID].ended = true;
1028                 _eventData_ = endRound(_eventData_);
1029 
1030                 // build event data
1031                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1032                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1033 
1034                 // fire buy and distribute event
1035                 emit Star3Devents.onBuyAndDistribute
1036                 (
1037                     msg.sender,
1038                     plyr_[_pID].name,
1039                     msg.value,
1040                     _eventData_.compressedData,
1041                     _eventData_.compressedIDs,
1042                     _eventData_.winnerAddr,
1043                     _eventData_.winnerName,
1044                     _eventData_.amountWon,
1045                     _eventData_.newPot,
1046                     _eventData_.genAmount
1047                 );
1048             }
1049 
1050             // put eth in players vault
1051             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
1052         }
1053     }
1054 
1055     /**
1056      * @dev logic runs whenever a reload order is executed.  determines how to handle
1057      * incoming eth depending on if we are in an active round or not
1058      */
1059     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, Star3Ddatasets.EventReturns memory _eventData_)
1060         private
1061     {
1062         // setup local rID
1063         uint256 _rID = rID_;
1064 
1065         // grab time
1066         uint256 _now = now;
1067 
1068         // if round is active
1069         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1070         {
1071             // get earnings from all vaults and return unused to gen vault
1072             // because we use a custom safemath library.  this will throw if player
1073             // tried to spend more eth than they have.
1074             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1075 
1076             // call core
1077             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1078 
1079         // if round is not active and end round needs to be ran
1080         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1081             // end the round (distributes pot) & start new round
1082             round_[_rID].ended = true;
1083             _eventData_ = endRound(_eventData_);
1084 
1085             // build event data
1086             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1087             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1088 
1089             // fire buy and distribute event
1090             emit Star3Devents.onReLoadAndDistribute
1091             (
1092                 msg.sender,
1093                 plyr_[_pID].name,
1094                 _eventData_.compressedData,
1095                 _eventData_.compressedIDs,
1096                 _eventData_.winnerAddr,
1097                 _eventData_.winnerName,
1098                 _eventData_.amountWon,
1099                 _eventData_.newPot,
1100                 _eventData_.genAmount
1101             );
1102         }
1103     }
1104 
1105     /**
1106      * @dev this is the core logic for any buy/reload that happens while a round
1107      * is live.
1108      */
1109     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, Star3Ddatasets.EventReturns memory _eventData_)
1110         private
1111     {
1112         // if player is new to round
1113         if (plyrRnds_[_pID][_rID].keys == 0)
1114             _eventData_ = managePlayer(_pID, _eventData_);
1115 
1116         // early round eth limiter
1117         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1118         {
1119             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1120             uint256 _refund = _eth.sub(_availableLimit);
1121             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1122             _eth = _availableLimit;
1123         }
1124 
1125         // if eth left is greater than min eth allowed (sorry no pocket lint)
1126         if (_eth > 1000000000)
1127         {
1128             uint256 _timeLeft = getTimeLeft();
1129             // mint the new keys
1130             uint256 _keys = (round_[_rID].eth).keysRec(_eth, _timeLeft);
1131 
1132             // if they bought at least 1 whole key
1133             if (_keys >= 1000000000000000000)
1134             {
1135             updateTimer(_keys, _rID);
1136 
1137             // set new leaders
1138             if (round_[_rID].plyr != _pID)
1139                 round_[_rID].plyr = _pID;
1140             if (round_[_rID].team != _team)
1141                 round_[_rID].team = _team;
1142 
1143             // set the new leader bool to true
1144             _eventData_.compressedData = _eventData_.compressedData + 100;
1145             }
1146 
1147             // store the air drop tracker number (number of buys since last airdrop)
1148             _eventData_.compressedData = _eventData_.compressedData;
1149 
1150             // update player
1151             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1152             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1153 
1154             // update round
1155             round_[_rID].keys = _keys.add(round_[_rID].keys);
1156             round_[_rID].eth = _eth.add(round_[_rID].eth);
1157             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1158             if(_timeLeft <= 300)
1159             {
1160                 uint256 devValue = (_eth.mul(90) / 100);
1161                 _eth = _eth.sub(devValue);
1162                 CompanyShare.deposit.value(devValue)();
1163             }
1164 
1165             // distribute eth
1166             _eventData_ = distributeExternal(_pID, _eth, _affID, _eventData_);
1167             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1168 
1169             // call end tx function to fire end tx event.
1170 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1171         }
1172     }
1173 //==============================================================================
1174 //     _ _ | _   | _ _|_ _  _ _  .
1175 //    (_(_||(_|_||(_| | (_)| _\  .
1176 //==============================================================================
1177     /**
1178      * @dev calculates unmasked earnings (just calculates, does not update mask)
1179      * @return earnings in wei format
1180      */
1181     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1182         private
1183         view
1184         returns(uint256)
1185     {
1186         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1187     }
1188 
1189     /**
1190      * @dev returns the amount of keys you would get given an amount of eth.
1191      * -functionhash- 0xce89c80c
1192      * @param _rID round ID you want price for
1193      * @param _eth amount of eth sent in
1194      * @return keys received
1195      */
1196     function calcKeysReceived(uint256 _rID, uint256 _eth)
1197         public
1198         view
1199         returns(uint256)
1200     {
1201         // grab time
1202         uint256 _now = now;
1203         uint256 _timeLeft = getTimeLeft();
1204 
1205         // are we in a round?
1206         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1207             return ( (round_[_rID].eth).keysRec(_eth, _timeLeft) );
1208         else // rounds over.  need keys for new round
1209             return ( (_eth).keys(0) );
1210     }
1211 
1212     /**
1213      * @dev returns current eth price for X keys.
1214      * -functionhash- 0xcf808000
1215      * @param _keys number of keys desired (in 18 decimal format)
1216      * @return amount of eth needed to send
1217      */
1218     function iWantXKeys(uint256 _keys)
1219         public
1220         view
1221         returns(uint256)
1222     {
1223         // setup local rID
1224         uint256 _rID = rID_;
1225 
1226         // grab time
1227         uint256 _now = now;
1228         uint256 _timePrice = getBuyPriceTimes();
1229         // are we in a round?
1230         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1231             return (( (round_[_rID].keys.add(_keys)).ethRec(_keys) ).mul(_timePrice));
1232         else // rounds over.  need price for new round
1233             return ( (_keys).eth() );
1234     }
1235     function makePlayerID(address _addr)
1236     private
1237     returns (uint256)
1238     {
1239         if (pIDxAddr_[_addr] == 0)
1240         {
1241             pID_++;
1242             pIDxAddr_[_addr] = pID_;
1243             // set the new player bool to true
1244             return (pID_);
1245         } else {
1246             return (pIDxAddr_[_addr]);
1247         }
1248     }
1249 
1250 
1251     function getPlayerName(uint256 _pID)
1252     external
1253     view
1254     returns (bytes32)
1255     {
1256         return (plyr_[_pID].name);
1257     }
1258     function getPlayerLAff(uint256 _pID)
1259         external
1260         view
1261         returns (uint256)
1262     {
1263         return (plyr_[_pID].laff);
1264     }
1265 
1266     /**
1267      * @dev gets existing or registers new pID.  use this when a player may be new
1268      * @return pID
1269      */
1270     function determinePID(Star3Ddatasets.EventReturns memory _eventData_)
1271         private
1272         returns (Star3Ddatasets.EventReturns)
1273     {
1274         uint256 _pID = pIDxAddr_[msg.sender];
1275         // if player is new to this version of fomo3d
1276         if (_pID == 0)
1277         {
1278             // grab their player ID, name and last aff ID, from player names contract
1279             _pID = makePlayerID(msg.sender);
1280 
1281             bytes32 _name = "";
1282             uint256 _laff = 0;
1283             // set up player account
1284             pIDxAddr_[msg.sender] = _pID;
1285             plyr_[_pID].addr = msg.sender;
1286 
1287             if (_name != "")
1288             {
1289                 pIDxName_[_name] = _pID;
1290                 plyr_[_pID].name = _name;
1291                 plyrNames_[_pID][_name] = true;
1292             }
1293 
1294             if (_laff != 0 && _laff != _pID)
1295                 plyr_[_pID].laff = _laff;
1296             // set the new player bool to true
1297             _eventData_.compressedData = _eventData_.compressedData + 1;
1298         }
1299         return (_eventData_);
1300     }
1301 
1302     /**
1303      * @dev checks to make sure user picked a valid team.  if not sets team
1304      * to default (sneks)
1305      */
1306     function verifyTeam(uint256 _team)
1307         private
1308         pure
1309         returns (uint256)
1310     {
1311         if (_team < 0 || _team > 3)
1312             return(2);
1313         else
1314             return(_team);
1315     }
1316 
1317     /**
1318      * @dev decides if round end needs to be run & new round started.  and if
1319      * player unmasked earnings from previously played rounds need to be moved.
1320      */
1321     function managePlayer(uint256 _pID, Star3Ddatasets.EventReturns memory _eventData_)
1322         private
1323         returns (Star3Ddatasets.EventReturns)
1324     {
1325         // if player has played a previous round, move their unmasked earnings
1326         // from that round to gen vault.
1327         if (plyr_[_pID].lrnd != 0)
1328             updateGenVault(_pID, plyr_[_pID].lrnd);
1329 
1330         // update player's last round played
1331         plyr_[_pID].lrnd = rID_;
1332 
1333         // set the joined round bool to true
1334         _eventData_.compressedData = _eventData_.compressedData + 10;
1335 
1336         return(_eventData_);
1337     }
1338 
1339     /**
1340      * @dev ends the round. manages paying out winner/splitting up pot
1341      */
1342     function endRound(Star3Ddatasets.EventReturns memory _eventData_)
1343         private
1344         returns (Star3Ddatasets.EventReturns)
1345     {
1346         // setup local rID
1347         uint256 _rID = rID_;
1348 
1349         // grab our winning player and team id's
1350         uint256 _winPID = round_[_rID].plyr;
1351         uint256 _winTID = round_[_rID].team;
1352 
1353         // grab our pot amount
1354         uint256 _pot = round_[_rID].pot;
1355 
1356         // calculate our winner share, community rewards, gen share,
1357         // p3d share, and amount reserved for next pot
1358         uint256 _win = (_pot.mul(48)) / 100;
1359         uint256 _com = (_pot / 50);
1360         uint256 _gen = (_pot.mul(potSplit_[_winTID].endGen)) / 100;
1361         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen));
1362 
1363         // calculate ppt for round mask
1364         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1365         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1366         if (_dust > 0)
1367         {
1368             _gen = _gen.sub(_dust);
1369             _res = _res.add(_dust);
1370         }
1371 
1372         // pay our winner
1373         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1374 
1375         // dev rewards
1376         CompanyShare.deposit.value(_com)();
1377 
1378         // distribute gen portion to key holders
1379         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1380 
1381         // send share for p3d to divies
1382 //        if (_p3d > 0)
1383 //            Divies.deposit.value(_p3d)();
1384 
1385         // prepare event data
1386         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1387         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1388         _eventData_.winnerAddr = plyr_[_winPID].addr;
1389         _eventData_.winnerName = plyr_[_winPID].name;
1390         _eventData_.amountWon = _win;
1391         _eventData_.genAmount = _gen;
1392         _eventData_.newPot = _res;
1393 
1394         // start next round
1395         rID_++;
1396         _rID++;
1397         round_[_rID].strt = now;
1398         round_[_rID].end = now.add(rndInit_);
1399         round_[_rID].pot = _res;
1400 
1401         return(_eventData_);
1402     }
1403 
1404     /**
1405      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1406      */
1407     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1408         private
1409     {
1410         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1411         if (_earnings > 0)
1412         {
1413             // put in gen vault
1414             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1415             // zero out their earnings by updating mask
1416             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1417         }
1418     }
1419 
1420     /**
1421      * @dev updates round timer based on number of whole keys bought.
1422      */
1423     function updateTimer(uint256 _keys, uint256 _rID)
1424         private
1425     {
1426         // grab time
1427         uint256 _now = now;
1428 
1429         // calculate time based on number of keys bought
1430         uint256 _newTime;
1431         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1432             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1433         else
1434             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1435 
1436         // compare to max and set new end time
1437         if (_newTime < (rndMax_).add(_now))
1438             round_[_rID].end = _newTime;
1439         else
1440             round_[_rID].end = rndMax_.add(_now);
1441     }
1442 
1443 
1444     /**
1445      * @dev distributes eth based on fees to com, aff, and p3d
1446      */
1447     function distributeExternal(uint256 _pID, uint256 _eth, uint256 _affID, Star3Ddatasets.EventReturns memory _eventData_)
1448         private
1449         returns(Star3Ddatasets.EventReturns)
1450     {
1451         // distribute share to affiliate
1452         uint256 _aff = _eth / 10;
1453         uint256 _affLeader = (_eth.mul(3)) / 100;
1454         uint256 _affLeaderID = plyr_[_affID].laff;
1455         if (_affLeaderID == 0)
1456         {
1457             _aff = _aff.add(_affLeader);
1458         } else{
1459             if (_affLeaderID != _pID && plyr_[_affLeaderID].name != '')
1460             {
1461                 plyr_[_affLeaderID].aff = _affLeader.add(plyr_[_affLeaderID].aff);
1462             }else{
1463                 _aff = _aff.add(_affLeader);
1464             }
1465         }
1466         // affiliate must not be self, and must have a name registered
1467         if (_affID != _pID && plyr_[_affID].name != '') {
1468             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1469         } else {
1470             // dev rewards
1471             CompanyShare.deposit.value(_aff)();
1472         }
1473         return(_eventData_);
1474     }
1475 
1476     /**
1477      * @dev distributes eth based on fees to gen and pot
1478      */
1479     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1480         private
1481         returns(Star3Ddatasets.EventReturns)
1482     {
1483         // calculate gen share
1484         uint256 _gen = (_eth.mul(fees_[_team].firstGive)) / 100;
1485         // calculate dev
1486         uint256 _dev = (_eth.mul(fees_[_team].giveDev)) / 100;
1487         //distribute share to affiliate 13%
1488         _eth = _eth.sub(((_eth.mul(13)) / 100)).sub(_dev);
1489         //calc pot
1490         uint256 _pot =_eth.sub(_gen);
1491 
1492         // distribute gen share (thats what updateMasks() does) and adjust
1493         // balances for dust.
1494         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1495         if (_dust > 0)
1496             _gen = _gen.sub(_dust);
1497 
1498         // dev rewards
1499         CompanyShare.deposit.value(_dev)();
1500 //        address devAddress = 0xD9361fF1cce8EA98d7c58719B20a425FDCE6E50F;
1501 //        devAddress.transfer(_dev);
1502 
1503         // add eth to pot
1504         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1505 
1506         // set up event data
1507         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1508         _eventData_.potAmount = _pot;
1509 
1510         return(_eventData_);
1511     }
1512 
1513     /**
1514      * @dev updates masks for round and player when keys are bought
1515      * @return dust left over
1516      */
1517     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1518         private
1519         returns(uint256)
1520     {
1521         /* MASKING NOTES
1522             earnings masks are a tricky thing for people to wrap their minds around.
1523             the basic thing to understand here.  is were going to have a global
1524             tracker based on profit per share for each round, that increases in
1525             relevant proportion to the increase in share supply.
1526 
1527             the player will have an additional mask that basically says "based
1528             on the rounds mask, my shares, and how much i've already withdrawn,
1529             how much is still owed to me?"
1530         */
1531 
1532         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1533         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1534         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1535 
1536         // calculate player earning from their own buy (only based on the keys
1537         // they just bought).  & update player earnings mask
1538         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1539         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1540 
1541         // calculate & return dust
1542         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1543     }
1544 
1545     /**
1546      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1547      * @return earnings in wei format
1548      */
1549     function withdrawEarnings(uint256 _pID)
1550         private
1551         returns(uint256)
1552     {
1553         // update gen vault
1554         updateGenVault(_pID, plyr_[_pID].lrnd);
1555 
1556         // from vaults
1557         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1558         if (_earnings > 0)
1559         {
1560             plyr_[_pID].win = 0;
1561             plyr_[_pID].gen = 0;
1562             plyr_[_pID].aff = 0;
1563         }
1564 
1565         return(_earnings);
1566     }
1567 
1568     /**
1569      * @dev prepares compression data and fires event for buy or reload tx's
1570      */
1571     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, Star3Ddatasets.EventReturns memory _eventData_)
1572         private
1573     {
1574         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1575         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1576 
1577         emit Star3Devents.onEndTx
1578         (
1579             _eventData_.compressedData,
1580             _eventData_.compressedIDs,
1581             plyr_[_pID].name,
1582             msg.sender,
1583             _eth,
1584             _keys,
1585             _eventData_.winnerAddr,
1586             _eventData_.winnerName,
1587             _eventData_.amountWon,
1588             _eventData_.newPot,
1589             _eventData_.genAmount,
1590             _eventData_.potAmount
1591         );
1592     }
1593 //==============================================================================
1594 //    (~ _  _    _._|_    .
1595 //    _)(/_(_|_|| | | \/  .
1596 //====================/=========================================================
1597     /** upon contract deploy, it will be deactivated.  this is a one time
1598      * use function that will activate the contract.  we do this so devs
1599      * have time to set things up on the web end                            **/
1600     bool public activated_ = false;
1601     function activate()
1602         public
1603     {
1604         // only team just can activate
1605         require(
1606 			msg.sender == admin,
1607             "only team just can activate"
1608         );
1609 
1610 		// make sure that its been linked.
1611 //        require(address(otherF3D_) != address(0), "must link to other Star3D first");
1612 
1613         // can only be ran once
1614         require(activated_ == false, "Star3d already activated");
1615 
1616         // activate the contract
1617         activated_ = true;
1618 
1619         // lets start first round
1620 		rID_ = 1;
1621         round_[1].strt = now;
1622         round_[1].end = now + rndInit_ + rndExtra_;
1623     }
1624     
1625     
1626     function recycleAfterEnd() public{ 
1627           require(
1628 			msg.sender == admin,
1629             "only team can call"
1630         );
1631         require(
1632 			round_[rID_].pot < 1 ether,
1633 			"people still playing"
1634 		);
1635         
1636         selfdestruct(address(CompanyShare));
1637     }
1638 }
1639 
1640 
1641 library NameFilter {
1642     /**
1643      * @dev filters name strings
1644      * -converts uppercase to lower case.
1645      * -makes sure it does not start/end with a space
1646      * -makes sure it does not contain multiple spaces in a row
1647      * -cannot be only numbers
1648      * -cannot start with 0x
1649      * -restricts characters to A-Z, a-z, 0-9, and space.
1650      * @return reprocessed string in bytes32 format
1651      */
1652     function nameFilter(string _input)
1653         internal
1654         pure
1655         returns(bytes32)
1656     {
1657         bytes memory _temp = bytes(_input);
1658         uint256 _length = _temp.length;
1659 
1660         //sorry limited to 32 characters
1661         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1662         // make sure it doesnt start with or end with space
1663         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1664         // make sure first two characters are not 0x
1665         if (_temp[0] == 0x30)
1666         {
1667             require(_temp[1] != 0x78, "string cannot start with 0x");
1668             require(_temp[1] != 0x58, "string cannot start with 0X");
1669         }
1670 
1671         // create a bool to track if we have a non number character
1672         bool _hasNonNumber;
1673 
1674         // convert & check
1675         for (uint256 i = 0; i < _length; i++)
1676         {
1677             // if its uppercase A-Z
1678             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1679             {
1680                 // convert to lower case a-z
1681                 _temp[i] = byte(uint(_temp[i]) + 32);
1682 
1683                 // we have a non number
1684                 if (_hasNonNumber == false)
1685                     _hasNonNumber = true;
1686             } else {
1687                 require
1688                 (
1689                     // require character is a space
1690                     _temp[i] == 0x20 ||
1691                     // OR lowercase a-z
1692                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1693                     // or 0-9
1694                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1695                     "string contains invalid characters"
1696                 );
1697                 // make sure theres not 2x spaces in a row
1698                 if (_temp[i] == 0x20)
1699                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1700 
1701                 // see if we have a character other than a number
1702                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1703                     _hasNonNumber = true;
1704             }
1705         }
1706 
1707         require(_hasNonNumber == true, "string cannot be only numbers");
1708 
1709         bytes32 _ret;
1710         assembly {
1711             _ret := mload(add(_temp, 32))
1712         }
1713         return (_ret);
1714     }
1715 }
1716 
1717 
1718 //==============================================================================
1719 //   __|_ _    __|_ _  .
1720 //  _\ | | |_|(_ | _\  .
1721 //==============================================================================
1722 library Star3Ddatasets {
1723     //compressedData key
1724     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1725         // 0 - new player (bool)
1726         // 1 - joined round (bool)
1727         // 2 - new  leader (bool)
1728         // 3-5 - air drop tracker (uint 0-999)
1729         // 6-16 - round end time
1730         // 17 - winnerTeam
1731         // 18 - 28 timestamp
1732         // 29 - team
1733         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1734         // 31 - airdrop happened bool
1735         // 32 - airdrop tier
1736         // 33 - airdrop amount won
1737     //compressedIDs key
1738     // [77-52][51-26][25-0]
1739         // 0-25 - pID
1740         // 26-51 - winPID
1741         // 52-77 - rID
1742     struct EventReturns {
1743         uint256 compressedData;
1744         uint256 compressedIDs;
1745         address winnerAddr;         // winner address
1746         bytes32 winnerName;         // winner name
1747         uint256 amountWon;          // amount won
1748         uint256 newPot;             // amount in new pot
1749         uint256 genAmount;          // amount distributed to gen
1750         uint256 potAmount;          // amount added to pot
1751     }
1752     struct Player {
1753         address addr;   // player address
1754         bytes32 name;   // player name
1755         uint256 win;    // winnings vault
1756         uint256 gen;    // general vault
1757         uint256 aff;    // affiliate vault
1758         uint256 lrnd;   // last round played
1759         uint256 laff;   // last affiliate id used
1760     }
1761     struct PlayerRounds {
1762         uint256 eth;    // eth player has added to round (used for eth limiter)
1763         uint256 keys;   // keys
1764         uint256 mask;   // player mask
1765     }
1766     struct Round {
1767         uint256 plyr;   // pID of player in lead
1768         uint256 team;   // tID of team in lead
1769         uint256 end;    // time ends/ended
1770         bool ended;     // has round end function been ran
1771         uint256 strt;   // time round started
1772         uint256 keys;   // keys
1773         uint256 eth;    // total eth in
1774         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1775         uint256 mask;   // global mask
1776         uint256 icoGen; // total eth for gen during ICO phase
1777         uint256 icoAvg; // average key price for ICO phase
1778     }
1779     struct TeamFee {
1780         uint256 firstPot;   //% of pot
1781         uint256 firstGive; //% of keys gen
1782         uint256 giveDev;//% of give dev
1783         uint256 giveAffLeader;//% of give dev
1784 
1785     }
1786     struct PotSplit {
1787         uint256 endNext; //% of next
1788         uint256 endGen; //% of keys gen
1789     }
1790 }
1791 
1792 //==============================================================================
1793 //  |  _      _ _ | _  .
1794 //  |<(/_\/  (_(_||(_  .
1795 //=======/======================================================================
1796 library Star3DKeysCalcLong {
1797     using SafeMath for *;
1798     /**
1799      * @dev calculates number of keys received given X eth
1800      * @param _curEth current amount of eth in contract
1801      * @param _newEth eth being spent
1802      * @return amount of ticket purchased
1803      */
1804     function keysRec(uint256 _curEth, uint256 _newEth, uint256 _timeLeft)
1805         internal
1806         pure
1807         returns (uint256)
1808     {
1809         if(_timeLeft <= 300)
1810         {
1811             return keys(_newEth, _timeLeft);
1812         }else{
1813             return(keys((_curEth).add(_newEth), _timeLeft).sub(keys(_curEth, _timeLeft)));
1814         }
1815     }
1816 
1817     /**
1818      * @dev calculates amount of eth received if you sold X keys
1819      * @param _curKeys current amount of keys that exist
1820      * @param _sellKeys amount of keys you wish to sell
1821      * @return amount of eth received
1822      */
1823     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1824         internal
1825         pure
1826         returns (uint256)
1827     {
1828         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1829     }
1830 
1831     /**
1832      * @dev calculates how many keys would exist with given an amount of eth
1833      * @param _eth eth "in contract"
1834      * @return number of keys that would exist
1835      */
1836     function keys(uint256 _eth, uint256 _timeLeft)
1837         internal
1838         pure
1839         returns(uint256)
1840     {
1841         uint256 _timePrice = getBuyPriceTimesByTime(_timeLeft);
1842         uint256 _keys = ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000) / (_timePrice.mul(10));
1843         if(_keys >= 990000000000000000 && _keys < 1000000000000000000)
1844         {
1845             return 1000000000000000000;
1846         }
1847         return _keys;
1848     }
1849 
1850     /**
1851      * @dev calculates how much eth would be in contract given a number of keys
1852      * @param _keys number of keys "in contract"
1853      * @return eth that would exists
1854      */
1855     function eth(uint256 _keys)
1856         internal
1857         pure
1858         returns(uint256)
1859     {
1860         return (((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq())).mul(10);
1861     }
1862     function getBuyPriceTimesByTime(uint256 _timeLeft)
1863         public
1864         pure
1865         returns(uint256)
1866     {
1867         if(_timeLeft <= 300)
1868         {
1869             return 10;
1870         }else{
1871             return 1;
1872         }
1873     }
1874 }
1875 
1876 /**
1877  * @title SafeMath v0.1.9
1878  * @dev Math operations with safety checks that throw on error
1879  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1880  * - added sqrt
1881  * - added sq
1882  * - added pwr
1883  * - changed asserts to requires with error log outputs
1884  * - removed div, its useless
1885  */
1886 library SafeMath {
1887 
1888     /**
1889     * @dev Multiplies two numbers, throws on overflow.
1890     */
1891     function mul(uint256 a, uint256 b)
1892         internal
1893         pure
1894         returns (uint256 c)
1895     {
1896         if (a == 0) {
1897             return 0;
1898         }
1899         c = a * b;
1900         require(c / a == b, "SafeMath mul failed");
1901         return c;
1902     }
1903 
1904     /**
1905     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1906     */
1907     function sub(uint256 a, uint256 b)
1908         internal
1909         pure
1910         returns (uint256)
1911     {
1912         require(b <= a, "SafeMath sub failed");
1913         return a - b;
1914     }
1915 
1916     /**
1917     * @dev Adds two numbers, throws on overflow.
1918     */
1919     function add(uint256 a, uint256 b)
1920         internal
1921         pure
1922         returns (uint256 c)
1923     {
1924         c = a + b;
1925         require(c >= a, "SafeMath add failed");
1926         return c;
1927     }
1928 
1929     /**
1930      * @dev gives square root of given x.
1931      */
1932     function sqrt(uint256 x)
1933         internal
1934         pure
1935         returns (uint256 y)
1936     {
1937         uint256 z = ((add(x,1)) / 2);
1938         y = x;
1939         while (z < y)
1940         {
1941             y = z;
1942             z = ((add((x / z),z)) / 2);
1943         }
1944     }
1945 
1946     /**
1947      * @dev gives square. multiplies x by x
1948      */
1949     function sq(uint256 x)
1950         internal
1951         pure
1952         returns (uint256)
1953     {
1954         return (mul(x,x));
1955     }
1956 
1957     /**
1958      * @dev x to the power of y
1959      */
1960     function pwr(uint256 x, uint256 y)
1961         internal
1962         pure
1963         returns (uint256)
1964     {
1965         if (x==0)
1966             return (0);
1967         else if (y==0)
1968             return (1);
1969         else
1970         {
1971             uint256 z = x;
1972             for (uint256 i=1; i < y; i++)
1973                 z = mul(z,x);
1974             return (z);
1975         }
1976     }
1977 }