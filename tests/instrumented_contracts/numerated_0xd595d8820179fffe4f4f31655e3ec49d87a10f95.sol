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
60 contract F3Devents {
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
88         uint256 P3DAmount,
89         uint256 genAmount,
90         uint256 potAmount,
91         uint256 airDropPot
92     );
93 
94 	// fired whenever theres a withdraw
95     event onWithdraw
96     (
97         uint256 indexed playerID,
98         address playerAddress,
99         bytes32 playerName,
100         uint256 ethOut,
101         uint256 timeStamp
102     );
103 
104     // fired whenever a withdraw forces end round to be ran
105     event onWithdrawAndDistribute
106     (
107         address playerAddress,
108         bytes32 playerName,
109         uint256 ethOut,
110         uint256 compressedData,
111         uint256 compressedIDs,
112         address winnerAddr,
113         bytes32 winnerName,
114         uint256 amountWon,
115         uint256 newPot,
116         uint256 P3DAmount,
117         uint256 genAmount
118     );
119 
120     // (fomo3d long only) fired whenever a player tries a buy after round timer
121     // hit zero, and causes end round to be ran.
122     event onBuyAndDistribute
123     (
124         address playerAddress,
125         bytes32 playerName,
126         uint256 ethIn,
127         uint256 compressedData,
128         uint256 compressedIDs,
129         address winnerAddr,
130         bytes32 winnerName,
131         uint256 amountWon,
132         uint256 newPot,
133         uint256 P3DAmount,
134         uint256 genAmount
135     );
136 
137     // (fomo3d long only) fired whenever a player tries a reload after round timer
138     // hit zero, and causes end round to be ran.
139     event onReLoadAndDistribute
140     (
141         address playerAddress,
142         bytes32 playerName,
143         uint256 compressedData,
144         uint256 compressedIDs,
145         address winnerAddr,
146         bytes32 winnerName,
147         uint256 amountWon,
148         uint256 newPot,
149         uint256 P3DAmount,
150         uint256 genAmount
151     );
152 
153     // fired whenever an affiliate is paid
154     event onAffiliatePayout
155     (
156         uint256 indexed affiliateID,
157         address affiliateAddress,
158         bytes32 affiliateName,
159         uint256 indexed roundID,
160         uint256 indexed buyerID,
161         uint256 amount,
162         uint256 timeStamp
163     );
164 
165     // received pot swap deposit
166     event onPotSwapDeposit
167     (
168         uint256 roundID,
169         uint256 amountAddedToPot
170     );
171 }
172 
173 //==============================================================================
174 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
175 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
176 //====================================|=========================================
177 
178 contract modularLong is F3Devents {}
179 
180 contract FoMo3Dlong is modularLong {
181     using SafeMath for *;
182     using NameFilter for string;
183     using F3DKeysCalcLong for uint256;
184 
185 	// otherFoMo3D private otherF3D_;
186     DiviesInterface constant private Divies = DiviesInterface(0x53EbD27d72a35eC520E9859258FaC7c64dbd0b09);
187     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x57fccA4371243C56266a36936a3689F80b981052);
188     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x973C83919836cca35dd0f4B2a50103e8F4B858Cc);
189     // F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
190 //==============================================================================
191 //     _ _  _  |`. _     _ _ |_ | _  _  .
192 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
193 //=================_|===========================================================
194     string constant public name = "tkey";
195     string constant public symbol = "F3D";
196     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
197     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
198     uint256 constant private rndInit_ = 24 hours;                // round timer starts at this
199     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
200     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
201 //==============================================================================
202 //     _| _ _|_ _    _ _ _|_    _   .
203 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
204 //=============================|================================================
205 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
206     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
207     uint256 public rID_;    // round id number / total rounds that have happened
208 //****************
209 // PLAYER DATA
210 //****************
211     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
212     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
213     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
214     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
215     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
216 //****************
217 // ROUND DATA
218 //****************
219     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
220     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
221 //****************
222 // TEAM FEE DATA
223 //****************
224     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
225     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
226 //****************
227 // REFERRAL FEE DATA
228 //****************
229     uint256 referralTotalProportion = 20;
230     mapping (uint256 => uint256) public referralProportion;         // (referral level => proportion) fee distribution by referral level
231 //==============================================================================
232 //     _ _  _  __|_ _    __|_ _  _  .
233 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
234 //==============================================================================
235     constructor()
236         public
237     {
238 		// Team allocation structures
239         // 0 = whales
240         // 1 = bears
241         // 2 = sneks
242         // 3 = bulls
243 
244 		// Team allocation percentages
245         // (F3D, P3D) + (Pot , Referrals, Community)
246             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
247         fees_[0] = F3Ddatasets.TeamFee(26,0);   //26% to f3d, 50% to pot, 20% to affs, 2% to com, 2% to air drop pot, 0% to p3d
248         fees_[1] = F3Ddatasets.TeamFee(33,0);   //33% to f3d, 43% to pot, 20% to affs, 2% to com, 2% to air drop pot, 0% to p3d
249         fees_[2] = F3Ddatasets.TeamFee(56,0);   //56% to f3d, 20% to pot, 20% to affs, 2% to com, 2% to air drop pot, 0% to p3d
250         fees_[3] = F3Ddatasets.TeamFee(41,0);   //41% to f3d, 35% to pot, 20% to affs, 2% to com, 2% to air drop pot, 0% to p3d
251 
252         // how to distribute the referral fee based on referral level
253         referralProportion[0] = 10;
254         referralProportion[1] = 6;
255         referralProportion[2] = 4;
256 
257         // how to split up the final pot based on which team was picked
258         // (F3D, P3D)
259         potSplit_[0] = F3Ddatasets.PotSplit(30,0);   //30% to f3d, 48% to winner, 20% to next round, 2% to com, 0% to p3d
260         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //25% to f3d, 48% to winner, 25% to next round, 2% to com, 0% to p3d
261         potSplit_[2] = F3Ddatasets.PotSplit(40,0);   //40% to f3d, 48% to winner, 10% to next round, 2% to com, 0% to p3d
262         potSplit_[3] = F3Ddatasets.PotSplit(35,0);   //35% to f3d, 48% to winner, 15% to next round, 2% to com, 0% to p3d
263 	}
264 //==============================================================================
265 //     _ _  _  _|. |`. _  _ _  .
266 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
267 //==============================================================================
268     /**
269      * @dev used to make sure no one can interact with contract until it has
270      * been activated.
271      */
272     modifier isActivated() {
273         require(activated_ == true, "its not ready yet.  check ?eta in discord");
274         _;
275     }
276 
277     /**
278      * @dev prevents contracts from interacting with fomo3d
279      */
280     modifier isHuman() {
281         address _addr = msg.sender;
282         uint256 _codeLength;
283 
284         assembly {_codeLength := extcodesize(_addr)}
285         require(_codeLength == 0, "sorry humans only");
286         _;
287     }
288 
289     /**
290      * @dev sets boundaries for incoming tx
291      */
292     modifier isWithinLimits(uint256 _eth) {
293         require(_eth >= 1000000000, "pocket lint: not a valid currency");
294         require(_eth <= 100000000000000000000000, "no vitalik, no");
295         _;
296     }
297 
298 //==============================================================================
299 //     _    |_ |. _   |`    _  __|_. _  _  _  .
300 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
301 //====|=========================================================================
302     /**
303      * @dev emergency buy uses last stored affiliate ID and team snek
304      */
305     function()
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
318         // buy core
319         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
320     }
321 
322     /**
323      * @dev converts all incoming ethereum to keys.
324      * -functionhash- 0x8f38f309 (using ID for affiliate)
325      * -functionhash- 0x98a0871d (using address for affiliate)
326      * -functionhash- 0xa65b37a1 (using name for affiliate)
327      * @param _affCode the ID/address/name of the player who gets the affiliate fee
328      * @param _team what team is the player playing for?
329      */
330     function buyXid(uint256 _affCode, uint256 _team)
331         isActivated()
332         isHuman()
333         isWithinLimits(msg.value)
334         public
335         payable
336     {
337         // set up our tx event data and determine if player is new or not
338         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
339 
340         // fetch player id
341         uint256 _pID = pIDxAddr_[msg.sender];
342 
343         // manage affiliate residuals
344         // if no affiliate code was given or player tried to use their own, lolz
345         if (_affCode == 0 || _affCode == _pID)
346         {
347             // use last stored affiliate code
348             _affCode = plyr_[_pID].laff;
349 
350         // if affiliate code was given & its not the same as previously stored
351         } else if (_affCode != plyr_[_pID].laff) {
352             // update last affiliate
353             plyr_[_pID].laff = _affCode;
354         }
355 
356         // verify a valid team was selected
357         _team = verifyTeam(_team);
358 
359         // buy core
360         buyCore(_pID, _affCode, _team, _eventData_);
361     }
362 
363     function buyXaddr(address _affCode, uint256 _team)
364         isActivated()
365         isHuman()
366         isWithinLimits(msg.value)
367         public
368         payable
369     {
370         // set up our tx event data and determine if player is new or not
371         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
372 
373         // fetch player id
374         uint256 _pID = pIDxAddr_[msg.sender];
375 
376         // manage affiliate residuals
377         uint256 _affID;
378         // if no affiliate code was given or player tried to use their own, lolz
379         if (_affCode == address(0) || _affCode == msg.sender)
380         {
381             // use last stored affiliate code
382             _affID = plyr_[_pID].laff;
383 
384         // if affiliate code was given
385         } else {
386             // get affiliate ID from aff Code
387             _affID = pIDxAddr_[_affCode];
388 
389             // if affID is not the same as previously stored
390             if (_affID != plyr_[_pID].laff)
391             {
392                 // update last affiliate
393                 plyr_[_pID].laff = _affID;
394             }
395         }
396 
397         // verify a valid team was selected
398         _team = verifyTeam(_team);
399 
400         // buy core
401         buyCore(_pID, _affID, _team, _eventData_);
402     }
403 
404     function buyXname(bytes32 _affCode, uint256 _team)
405         isActivated()
406         isHuman()
407         isWithinLimits(msg.value)
408         public
409         payable
410     {
411         // set up our tx event data and determine if player is new or not
412         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
413 
414         // fetch player id
415         uint256 _pID = pIDxAddr_[msg.sender];
416 
417         // manage affiliate residuals
418         uint256 _affID;
419         // if no affiliate code was given or player tried to use their own, lolz
420         if (_affCode == '' || _affCode == plyr_[_pID].name)
421         {
422             // use last stored affiliate code
423             _affID = plyr_[_pID].laff;
424 
425         // if affiliate code was given
426         } else {
427             // get affiliate ID from aff Code
428             _affID = pIDxName_[_affCode];
429 
430             // if affID is not the same as previously stored
431             if (_affID != plyr_[_pID].laff)
432             {
433                 // update last affiliate
434                 plyr_[_pID].laff = _affID;
435             }
436         }
437 
438         // verify a valid team was selected
439         _team = verifyTeam(_team);
440 
441         // buy core
442         buyCore(_pID, _affID, _team, _eventData_);
443     }
444 
445     /**
446      * @dev essentially the same as buy, but instead of you sending ether
447      * from your wallet, it uses your unwithdrawn earnings.
448      * -functionhash- 0x349cdcac (using ID for affiliate)
449      * -functionhash- 0x82bfc739 (using address for affiliate)
450      * -functionhash- 0x079ce327 (using name for affiliate)
451      * @param _affCode the ID/address/name of the player who gets the affiliate fee
452      * @param _team what team is the player playing for?
453      * @param _eth amount of earnings to use (remainder returned to gen vault)
454      */
455     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
456         isActivated()
457         isHuman()
458         isWithinLimits(_eth)
459         public
460     {
461         // set up our tx event data
462         F3Ddatasets.EventReturns memory _eventData_;
463 
464         // fetch player ID
465         uint256 _pID = pIDxAddr_[msg.sender];
466 
467         // manage affiliate residuals
468         // if no affiliate code was given or player tried to use their own, lolz
469         if (_affCode == 0 || _affCode == _pID)
470         {
471             // use last stored affiliate code
472             _affCode = plyr_[_pID].laff;
473 
474         // if affiliate code was given & its not the same as previously stored
475         } else if (_affCode != plyr_[_pID].laff) {
476             // update last affiliate
477             plyr_[_pID].laff = _affCode;
478         }
479 
480         // verify a valid team was selected
481         _team = verifyTeam(_team);
482 
483         // reload core
484         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
485     }
486 
487     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
488         isActivated()
489         isHuman()
490         isWithinLimits(_eth)
491         public
492     {
493         // set up our tx event data
494         F3Ddatasets.EventReturns memory _eventData_;
495 
496         // fetch player ID
497         uint256 _pID = pIDxAddr_[msg.sender];
498 
499         // manage affiliate residuals
500         uint256 _affID;
501         // if no affiliate code was given or player tried to use their own, lolz
502         if (_affCode == address(0) || _affCode == msg.sender)
503         {
504             // use last stored affiliate code
505             _affID = plyr_[_pID].laff;
506 
507         // if affiliate code was given
508         } else {
509             // get affiliate ID from aff Code
510             _affID = pIDxAddr_[_affCode];
511 
512             // if affID is not the same as previously stored
513             if (_affID != plyr_[_pID].laff)
514             {
515                 // update last affiliate
516                 plyr_[_pID].laff = _affID;
517             }
518         }
519 
520         // verify a valid team was selected
521         _team = verifyTeam(_team);
522 
523         // reload core
524         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
525     }
526 
527     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
528         isActivated()
529         isHuman()
530         isWithinLimits(_eth)
531         public
532     {
533         // set up our tx event data
534         F3Ddatasets.EventReturns memory _eventData_;
535 
536         // fetch player ID
537         uint256 _pID = pIDxAddr_[msg.sender];
538 
539         // manage affiliate residuals
540         uint256 _affID;
541         // if no affiliate code was given or player tried to use their own, lolz
542         if (_affCode == '' || _affCode == plyr_[_pID].name)
543         {
544             // use last stored affiliate code
545             _affID = plyr_[_pID].laff;
546 
547         // if affiliate code was given
548         } else {
549             // get affiliate ID from aff Code
550             _affID = pIDxName_[_affCode];
551 
552             // if affID is not the same as previously stored
553             if (_affID != plyr_[_pID].laff)
554             {
555                 // update last affiliate
556                 plyr_[_pID].laff = _affID;
557             }
558         }
559 
560         // verify a valid team was selected
561         _team = verifyTeam(_team);
562 
563         // reload core
564         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
565     }
566 
567     /**
568      * @dev withdraws all of your earnings.
569      * -functionhash- 0x3ccfd60b
570      */
571     function withdraw()
572         isActivated()
573         isHuman()
574         public
575     {
576         // setup local rID
577         uint256 _rID = rID_;
578 
579         // grab time
580         uint256 _now = now;
581 
582         // fetch player ID
583         uint256 _pID = pIDxAddr_[msg.sender];
584 
585         // setup temp var for player eth
586         uint256 _eth;
587 
588         // check to see if round has ended and no one has run round end yet
589         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
590         {
591             // set up our tx event data
592             F3Ddatasets.EventReturns memory _eventData_;
593 
594             // end the round (distributes pot)
595 			round_[_rID].ended = true;
596             _eventData_ = endRound(_eventData_);
597 
598 			// get their earnings
599             _eth = withdrawEarnings(_pID);
600 
601             // gib moni
602             if (_eth > 0)
603                 plyr_[_pID].addr.transfer(_eth);
604 
605             // build event data
606             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
607             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
608 
609             // fire withdraw and distribute event
610             emit F3Devents.onWithdrawAndDistribute
611             (
612                 msg.sender,
613                 plyr_[_pID].name,
614                 _eth,
615                 _eventData_.compressedData,
616                 _eventData_.compressedIDs,
617                 _eventData_.winnerAddr,
618                 _eventData_.winnerName,
619                 _eventData_.amountWon,
620                 _eventData_.newPot,
621                 _eventData_.P3DAmount,
622                 _eventData_.genAmount
623             );
624 
625         // in any other situation
626         } else {
627             // get their earnings
628             _eth = withdrawEarnings(_pID);
629 
630             // gib moni
631             if (_eth > 0)
632                 plyr_[_pID].addr.transfer(_eth);
633 
634             // fire withdraw event
635             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
636         }
637     }
638 
639     /**
640      * @dev use these to register names.  they are just wrappers that will send the
641      * registration requests to the PlayerBook contract.  So registering here is the
642      * same as registering there.  UI will always display the last name you registered.
643      * but you will still own all previously registered names to use as affiliate
644      * links.
645      * - must pay a registration fee.
646      * - name must be unique
647      * - names will be converted to lowercase
648      * - name cannot start or end with a space
649      * - cannot have more than 1 space in a row
650      * - cannot be only numbers
651      * - cannot start with 0x
652      * - name must be at least 1 char
653      * - max length of 32 characters long
654      * - allowed characters: a-z, 0-9, and space
655      * -functionhash- 0x921dec21 (using ID for affiliate)
656      * -functionhash- 0x3ddd4698 (using address for affiliate)
657      * -functionhash- 0x685ffd83 (using name for affiliate)
658      * @param _nameString players desired name
659      * @param _affCode affiliate ID, address, or name of who referred you
660      * @param _all set to true if you want this to push your info to all games
661      * (this might cost a lot of gas)
662      */
663     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
664         isHuman()
665         public
666         payable
667     {
668         bytes32 _name = _nameString.nameFilter();
669         address _addr = msg.sender;
670         uint256 _paid = msg.value;
671         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
672 
673         uint256 _pID = pIDxAddr_[_addr];
674 
675         // fire event
676         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
677     }
678 
679     function registerNameXaddr(string _nameString, address _affCode, bool _all)
680         isHuman()
681         public
682         payable
683     {
684         bytes32 _name = _nameString.nameFilter();
685         address _addr = msg.sender;
686         uint256 _paid = msg.value;
687         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
688 
689         uint256 _pID = pIDxAddr_[_addr];
690 
691         // fire event
692         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
693     }
694 
695     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
696         isHuman()
697         public
698         payable
699     {
700         bytes32 _name = _nameString.nameFilter();
701         address _addr = msg.sender;
702         uint256 _paid = msg.value;
703         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
704 
705         uint256 _pID = pIDxAddr_[_addr];
706 
707         // fire event
708         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
709     }
710 //==============================================================================
711 //     _  _ _|__|_ _  _ _  .
712 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
713 //=====_|=======================================================================
714     /**
715      * @dev return the price buyer will pay for next 1 individual key.
716      * -functionhash- 0x018a25e8
717      * @return price for next key bought (in wei format)
718      */
719     function getBuyPrice()
720         public
721         view
722         returns(uint256)
723     {
724         // setup local rID
725         uint256 _rID = rID_;
726 
727         // grab time
728         uint256 _now = now;
729 
730         // are we in a round?
731         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
732             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
733         else // rounds over.  need price for new round
734             return ( 75000000000000 ); // init
735     }
736 
737     /**
738      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
739      * provider
740      * -functionhash- 0xc7e284b8
741      * @return time left in seconds
742      */
743     function getTimeLeft()
744         public
745         view
746         returns(uint256)
747     {
748         // setup local rID
749         uint256 _rID = rID_;
750 
751         // grab time
752         uint256 _now = now;
753 
754         if (_now < round_[_rID].end)
755             if (_now > round_[_rID].strt + rndGap_)
756                 return( (round_[_rID].end).sub(_now) );
757             else
758                 return( (round_[_rID].strt + rndGap_).sub(_now) );
759         else
760             return(0);
761     }
762 
763     /**
764      * @dev return if it's in ico phase or not
765      * @return bool
766      */
767     function isInICOPhase()
768         public
769         view
770         returns(bool)
771     {
772         // setup local rID
773         uint256 _rID = rID_;
774 
775         // grab time
776         uint256 _now = now;
777 
778         if (_now < round_[_rID].end)
779             if (_now > round_[_rID].strt + rndGap_)
780                 return(false);
781             else
782                 return(true);
783         else
784             return(false);
785     }
786 
787     /**
788      * @dev returns player earnings per vaults
789      * -functionhash- 0x63066434
790      * @return winnings vault
791      * @return general vault
792      * @return affiliate vault
793      */
794     function getPlayerVaults(uint256 _pID)
795         public
796         view
797         returns(uint256 ,uint256, uint256)
798     {
799         // setup local rID
800         uint256 _rID = rID_;
801 
802         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
803         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
804         {
805             // if player is winner
806             if (round_[_rID].plyr == _pID)
807             {
808                 return
809                 (
810                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
811                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
812                     plyr_[_pID].aff
813                 );
814             // if player is not the winner
815             } else {
816                 return
817                 (
818                     plyr_[_pID].win,
819                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
820                     plyr_[_pID].aff
821                 );
822             }
823 
824         // if round is still going on, or round has ended and round end has been ran
825         } else {
826             return
827             (
828                 plyr_[_pID].win,
829                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
830                 plyr_[_pID].aff
831             );
832         }
833     }
834 
835     /**
836      * solidity hates stack limits.  this lets us avoid that hate
837      */
838     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
839         private
840         view
841         returns(uint256)
842     {
843         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
844     }
845 
846     /**
847      * @dev returns all current round info needed for front end
848      * -functionhash- 0x747dff42
849      * @return eth invested during ICO phase
850      * @return round id
851      * @return total keys for round
852      * @return time round ends
853      * @return time round started
854      * @return current pot
855      * @return current team ID & player ID in lead
856      * @return current player in leads address
857      * @return current player in leads name
858      * @return whales eth in for round
859      * @return bears eth in for round
860      * @return sneks eth in for round
861      * @return bulls eth in for round
862      * @return airdrop tracker # & airdrop pot
863      */
864     function getCurrentRoundInfo()
865         public
866         view
867         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
868     {
869         // setup local rID
870         uint256 _rID = rID_;
871 
872         return
873         (
874             round_[_rID].ico,               //0
875             _rID,                           //1
876             round_[_rID].keys,              //2
877             round_[_rID].end,               //3
878             round_[_rID].strt,              //4
879             round_[_rID].pot,               //5
880             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
881             plyr_[round_[_rID].plyr].addr,  //7
882             plyr_[round_[_rID].plyr].name,  //8
883             rndTmEth_[_rID][0],             //9
884             rndTmEth_[_rID][1],             //10
885             rndTmEth_[_rID][2],             //11
886             rndTmEth_[_rID][3],             //12
887             airDropTracker_ + (airDropPot_ * 1000)              //13
888         );
889     }
890 
891     /**
892      * @dev returns player info based on address.  if no address is given, it will
893      * use msg.sender
894      * -functionhash- 0xee0b5d8b
895      * @param _addr address of the player you want to lookup
896      * @return player ID
897      * @return player name
898      * @return keys owned (current round)
899      * @return winnings vault
900      * @return general vault
901      * @return affiliate vault
902 	 * @return player round eth
903      */
904     function getPlayerInfoByAddress(address _addr)
905         public
906         view
907         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
908     {
909         // setup local rID
910         uint256 _rID = rID_;
911 
912         if (_addr == address(0))
913         {
914             _addr == msg.sender;
915         }
916         uint256 _pID = pIDxAddr_[_addr];
917 
918         return
919         (
920             _pID,                               //0
921             plyr_[_pID].name,                   //1
922             plyrRnds_[_pID][_rID].keys,         //2
923             plyr_[_pID].win,                    //3
924             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
925             plyr_[_pID].aff,                    //5
926             plyrRnds_[_pID][_rID].eth           //6
927         );
928     }
929 
930 //==============================================================================
931 //     _ _  _ _   | _  _ . _  .
932 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
933 //=====================_|=======================================================
934     /**
935      * @dev logic runs whenever a buy order is executed.  determines how to handle
936      * incoming eth depending on if we are in an active round or not
937      */
938     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
939         private
940     {
941         // setup local rID
942         uint256 _rID = rID_;
943 
944         // grab time
945         uint256 _now = now;
946 
947         // if round is active
948         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
949         {
950             // call core
951             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
952 
953         // if round is not active
954         } else {
955             // check to see if end round needs to be ran
956             if (_now > round_[_rID].end && round_[_rID].ended == false)
957             {
958                 // end the round (distributes pot) & start new round
959 			    round_[_rID].ended = true;
960                 _eventData_ = endRound(_eventData_);
961 
962                 // build event data
963                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
964                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
965 
966                 // fire buy and distribute event
967                 emit F3Devents.onBuyAndDistribute
968                 (
969                     msg.sender,
970                     plyr_[_pID].name,
971                     msg.value,
972                     _eventData_.compressedData,
973                     _eventData_.compressedIDs,
974                     _eventData_.winnerAddr,
975                     _eventData_.winnerName,
976                     _eventData_.amountWon,
977                     _eventData_.newPot,
978                     _eventData_.P3DAmount,
979                     _eventData_.genAmount
980                 );
981             }
982 
983             // put eth in players vault
984             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
985         }
986     }
987 
988     /**
989      * @dev logic runs whenever a reload order is executed.  determines how to handle
990      * incoming eth depending on if we are in an active round or not
991      */
992     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
993         private
994     {
995         // setup local rID
996         uint256 _rID = rID_;
997 
998         // grab time
999         uint256 _now = now;
1000 
1001         // if round is active
1002         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1003         {
1004             // get earnings from all vaults and return unused to gen vault
1005             // because we use a custom safemath library.  this will throw if player
1006             // tried to spend more eth than they have.
1007             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1008 
1009             // call core
1010             core(_rID, _pID, _eth, _affID, _team, _eventData_);
1011 
1012         // if round is not active and end round needs to be ran
1013         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
1014             // end the round (distributes pot) & start new round
1015             round_[_rID].ended = true;
1016             _eventData_ = endRound(_eventData_);
1017 
1018             // build event data
1019             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1020             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1021 
1022             // fire buy and distribute event
1023             emit F3Devents.onReLoadAndDistribute
1024             (
1025                 msg.sender,
1026                 plyr_[_pID].name,
1027                 _eventData_.compressedData,
1028                 _eventData_.compressedIDs,
1029                 _eventData_.winnerAddr,
1030                 _eventData_.winnerName,
1031                 _eventData_.amountWon,
1032                 _eventData_.newPot,
1033                 _eventData_.P3DAmount,
1034                 _eventData_.genAmount
1035             );
1036         }
1037     }
1038 
1039     /**
1040      * @dev this is the core logic for any buy/reload that happens while a round
1041      * is live.
1042      */
1043     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1044         private
1045     {
1046         // if player is new to round
1047         if (plyrRnds_[_pID][_rID].keys == 0)
1048             _eventData_ = managePlayer(_pID, _eventData_);
1049 
1050         // early round eth limiter
1051         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1052         {
1053             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1054             uint256 _refund = _eth.sub(_availableLimit);
1055             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1056             _eth = _availableLimit;
1057         }
1058 
1059         // if eth left is greater than min eth allowed (sorry no pocket lint)
1060         if (_eth > 1000000000)
1061         {
1062 
1063             // mint the new keys
1064             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1065 
1066             // if they bought at least 1 whole key
1067             if (_keys >= 1000000000000000000)
1068             {
1069             updateTimer(_keys, _rID);
1070 
1071             // set new leaders
1072             if (round_[_rID].plyr != _pID)
1073                 round_[_rID].plyr = _pID;
1074             if (round_[_rID].team != _team)
1075                 round_[_rID].team = _team;
1076 
1077             // set the new leader bool to true
1078             _eventData_.compressedData = _eventData_.compressedData + 100;
1079         }
1080 
1081             // manage airdrops
1082             if (_eth >= 100000000000000000)
1083             {
1084             airDropTracker_++;
1085             if (airdrop() == true)
1086             {
1087                 // gib muni
1088                 uint256 _prize;
1089                 if (_eth >= 10000000000000000000)
1090                 {
1091                     // calculate prize and give it to winner
1092                     _prize = ((airDropPot_).mul(75)) / 100;
1093                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1094 
1095                     // adjust airDropPot
1096                     airDropPot_ = (airDropPot_).sub(_prize);
1097 
1098                     // let event know a tier 3 prize was won
1099                     _eventData_.compressedData += 300000000000000000000000000000000;
1100                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1101                     // calculate prize and give it to winner
1102                     _prize = ((airDropPot_).mul(50)) / 100;
1103                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1104 
1105                     // adjust airDropPot
1106                     airDropPot_ = (airDropPot_).sub(_prize);
1107 
1108                     // let event know a tier 2 prize was won
1109                     _eventData_.compressedData += 200000000000000000000000000000000;
1110                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1111                     // calculate prize and give it to winner
1112                     _prize = ((airDropPot_).mul(25)) / 100;
1113                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1114 
1115                     // adjust airDropPot
1116                     airDropPot_ = (airDropPot_).sub(_prize);
1117 
1118                     // let event know a tier 3 prize was won
1119                     _eventData_.compressedData += 300000000000000000000000000000000;
1120                 }
1121                 // set airdrop happened bool to true
1122                 _eventData_.compressedData += 10000000000000000000000000000000;
1123                 // let event know how much was won
1124                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1125 
1126                 // reset air drop tracker
1127                 airDropTracker_ = 0;
1128             }
1129         }
1130 
1131             // store the air drop tracker number (number of buys since last airdrop)
1132             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
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
1144             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
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
1212 //==============================================================================
1213 //    _|_ _  _ | _  .
1214 //     | (_)(_)|_\  .
1215 //==============================================================================
1216     /**
1217 	 * @dev receives name/player info from names contract
1218      */
1219     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1220         external
1221     {
1222         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1223         if (pIDxAddr_[_addr] != _pID)
1224             pIDxAddr_[_addr] = _pID;
1225         if (pIDxName_[_name] != _pID)
1226             pIDxName_[_name] = _pID;
1227         if (plyr_[_pID].addr != _addr)
1228             plyr_[_pID].addr = _addr;
1229         if (plyr_[_pID].name != _name)
1230             plyr_[_pID].name = _name;
1231         if (plyr_[_pID].laff != _laff)
1232             plyr_[_pID].laff = _laff;
1233         if (plyrNames_[_pID][_name] == false)
1234             plyrNames_[_pID][_name] = true;
1235     }
1236 
1237     /**
1238      * @dev receives entire player name list
1239      */
1240     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1241         external
1242     {
1243         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1244         if(plyrNames_[_pID][_name] == false)
1245             plyrNames_[_pID][_name] = true;
1246     }
1247 
1248     /**
1249      * @dev gets existing or registers new pID.  use this when a player may be new
1250      * @return pID
1251      */
1252     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1253         private
1254         returns (F3Ddatasets.EventReturns)
1255     {
1256         uint256 _pID = pIDxAddr_[msg.sender];
1257         // if player is new to this version of fomo3d
1258         if (_pID == 0)
1259         {
1260             // grab their player ID, name and last aff ID, from player names contract
1261             _pID = PlayerBook.getPlayerID(msg.sender);
1262             bytes32 _name = PlayerBook.getPlayerName(_pID);
1263             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1264 
1265             // set up player account
1266             pIDxAddr_[msg.sender] = _pID;
1267             plyr_[_pID].addr = msg.sender;
1268 
1269             if (_name != "")
1270             {
1271                 pIDxName_[_name] = _pID;
1272                 plyr_[_pID].name = _name;
1273                 plyrNames_[_pID][_name] = true;
1274             }
1275 
1276             if (_laff != 0 && _laff != _pID)
1277                 plyr_[_pID].laff = _laff;
1278 
1279             // set the new player bool to true
1280             _eventData_.compressedData = _eventData_.compressedData + 1;
1281         }
1282         return (_eventData_);
1283     }
1284 
1285     /**
1286      * @dev checks to make sure user picked a valid team.  if not sets team
1287      * to default (sneks)
1288      */
1289     function verifyTeam(uint256 _team)
1290         private
1291         pure
1292         returns (uint256)
1293     {
1294         if (_team < 0 || _team > 3)
1295             return(2);
1296         else
1297             return(_team);
1298     }
1299 
1300     /**
1301      * @dev decides if round end needs to be run & new round started.  and if
1302      * player unmasked earnings from previously played rounds need to be moved.
1303      */
1304     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1305         private
1306         returns (F3Ddatasets.EventReturns)
1307     {
1308         // if player has played a previous round, move their unmasked earnings
1309         // from that round to gen vault.
1310         if (plyr_[_pID].lrnd != 0)
1311             updateGenVault(_pID, plyr_[_pID].lrnd);
1312 
1313         // update player's last round played
1314         plyr_[_pID].lrnd = rID_;
1315 
1316         // set the joined round bool to true
1317         _eventData_.compressedData = _eventData_.compressedData + 10;
1318 
1319         return(_eventData_);
1320     }
1321 
1322     /**
1323      * @dev ends the round. manages paying out winner/splitting up pot
1324      */
1325     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1326         private
1327         returns (F3Ddatasets.EventReturns)
1328     {
1329         // setup local rID
1330         uint256 _rID = rID_;
1331 
1332         // grab our winning player and team id's
1333         uint256 _winPID = round_[_rID].plyr;
1334         uint256 _winTID = round_[_rID].team;
1335 
1336         // grab our pot amount
1337         uint256 _pot = round_[_rID].pot;
1338 
1339         // calculate our winner share, community rewards, gen share,
1340         // p3d share, and amount reserved for next pot
1341         uint256 _win = (_pot.mul(48)) / 100;
1342         uint256 _com = (_pot / 50);
1343         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1344         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1345         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1346 
1347         // calculate ppt for round mask
1348         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1349         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1350         if (_dust > 0)
1351         {
1352             _gen = _gen.sub(_dust);
1353             _res = _res.add(_dust);
1354         }
1355 
1356         // pay our winner
1357         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1358 
1359         // community rewards
1360         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1361         {
1362             // This ensures Team Just cannot influence the outcome of FoMo3D with
1363             // bank migrations by breaking outgoing transactions.
1364             // Something we would never do. But that's not the point.
1365             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1366             // highest belief that everything we create should be trustless.
1367             // Team JUST, The name you shouldn't have to trust.
1368             _gen = _gen.add(_com);
1369             _com = 0;
1370         }
1371 
1372         // distribute gen portion to key holders
1373         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1374 
1375         // send share for p3d to divies
1376         if (_p3d > 0)
1377             Divies.deposit.value(_p3d)();
1378 
1379         // prepare event data
1380         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1381         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1382         _eventData_.winnerAddr = plyr_[_winPID].addr;
1383         _eventData_.winnerName = plyr_[_winPID].name;
1384         _eventData_.amountWon = _win;
1385         _eventData_.genAmount = _gen;
1386         _eventData_.P3DAmount = _p3d;
1387         _eventData_.newPot = _res;
1388 
1389         // start next round
1390         rID_++;
1391         _rID++;
1392         round_[_rID].strt = now;
1393         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1394         round_[_rID].pot = _res;
1395 
1396         return(_eventData_);
1397     }
1398 
1399     /**
1400      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1401      */
1402     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1403         private
1404     {
1405         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1406         if (_earnings > 0)
1407         {
1408             // put in gen vault
1409             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1410             // zero out their earnings by updating mask
1411             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1412         }
1413     }
1414 
1415     /**
1416      * @dev updates round timer based on number of whole keys bought.
1417      */
1418     function updateTimer(uint256 _keys, uint256 _rID)
1419         private
1420     {
1421         // grab time
1422         uint256 _now = now;
1423 
1424         // calculate time based on number of keys bought
1425         uint256 _newTime;
1426         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1427             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1428         else
1429             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1430 
1431         // compare to max and set new end time
1432         if (_newTime < (rndMax_).add(_now))
1433             round_[_rID].end = _newTime;
1434         else
1435             round_[_rID].end = rndMax_.add(_now);
1436     }
1437 
1438     /**
1439      * @dev generates a random number between 0-99 and checks to see if thats
1440      * resulted in an airdrop win
1441      * @return do we have a winner?
1442      */
1443     function airdrop()
1444         private
1445         view
1446         returns(bool)
1447     {
1448         uint256 seed = uint256(keccak256(abi.encodePacked(
1449 
1450             (block.timestamp).add
1451             (block.difficulty).add
1452             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1453             (block.gaslimit).add
1454             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1455             (block.number)
1456 
1457         )));
1458         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1459             return(true);
1460         else
1461             return(false);
1462     }
1463 
1464     /**
1465      * @dev distributes eth based on fees to com, aff, and p3d
1466      * total: 22% of key price
1467      * distribution:
1468      *      20%: referrals
1469      *       2%: community
1470      *       0%: p3d
1471      *       0%: pot swap
1472      */
1473     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1474         private
1475         returns(F3Ddatasets.EventReturns)
1476     {
1477         // pay 2% out to community rewards
1478         uint256 _com = _eth / 50;
1479         // uint256 _p3d = 0;
1480 
1481         // pay 1% out to FoMo3D short
1482         // uint256 _long = _eth / 100;
1483         // otherF3D_.potSwap.value(_long)();
1484 
1485         /**
1486          * 20% for referral part
1487          * - 10% tier 1 referral
1488          * -  6% tier 2 referral
1489          * -  4% tier 3 referral
1490          * if there's no referral, then it goes to community.
1491          */
1492 
1493         uint256 referralProportionAccumulator = 0;
1494         uint256 i = 0;
1495         uint256 _aff;
1496 
1497         while (_affID != _pID && plyr_[_affID].name != "" && i < 3) {
1498             _aff = _eth.mul(referralProportion[i]) / 100;
1499             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1500             referralProportionAccumulator = referralProportionAccumulator + referralProportion[i];
1501             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1502 
1503             _affID = plyr_[_affID].laff;
1504             i = i + 1;
1505         }
1506 
1507         uint256 undistributedPortion = referralTotalProportion - referralProportionAccumulator;
1508 
1509         _com = _com.add(_eth.mul(undistributedPortion) / 100);
1510 
1511         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1512         {
1513             // This ensures Team Just cannot influence the outcome of FoMo3D with
1514             // bank migrations by breaking outgoing transactions.
1515             // Something we would never do. But that's not the point.
1516             // We spent 2000$ in eth re-deploying just to patch this, we hold the
1517             // highest belief that everything we create should be trustless.
1518             // Team JUST, The name you shouldn't have to trust.
1519             // _p3d = _com;
1520             _com = 0;
1521         }
1522 
1523         // distribute share to affiliate
1524         // uint256 _aff = _eth / 10;
1525 
1526         // decide what to do with affiliate share of fees
1527         // affiliate must not be self, and must have a name registered
1528         // if (_affID != _pID && plyr_[_affID].name != '') {
1529         //     plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1530         //     emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1531         // } else {
1532         //     _p3d = _aff;
1533         // }
1534 
1535         // pay out p3d
1536         // _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1537         // if (_p3d > 0)
1538         // {
1539         //     // deposit to divies contract
1540         //     Divies.deposit.value(_p3d)();
1541 
1542         //     // set up event data
1543         //     _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1544         // }
1545 
1546         return(_eventData_);
1547     }
1548 
1549     function potSwap()
1550         external
1551         payable
1552     {
1553         // setup local rID
1554         uint256 _rID = rID_ + 1;
1555 
1556         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1557         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1558     }
1559 
1560     /**
1561      * @dev distributes eth based on fees to gen and pot
1562      * total: 78% of key price
1563      * distribution:
1564      *      76%: gen and pot
1565      *       2%: ari drop
1566      */
1567     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1568         private
1569         returns(F3Ddatasets.EventReturns)
1570     {
1571         // calculate gen share
1572         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1573 
1574         // toss 2% into airdrop pot
1575         uint256 _air = (_eth / 50);
1576         airDropPot_ = airDropPot_.add(_air);
1577 
1578         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1579         _eth = _eth.sub(((_eth.mul(22)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1580 
1581         // calculate pot
1582         uint256 _pot = _eth.sub(_gen);
1583 
1584         // distribute gen share (thats what updateMasks() does) and adjust
1585         // balances for dust.
1586         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1587         if (_dust > 0)
1588             _gen = _gen.sub(_dust);
1589 
1590         // add eth to pot
1591         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1592 
1593         // set up event data
1594         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1595         _eventData_.potAmount = _pot;
1596 
1597         return(_eventData_);
1598     }
1599 
1600     /**
1601      * @dev updates masks for round and player when keys are bought
1602      * @return dust left over
1603      */
1604     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1605         private
1606         returns(uint256)
1607     {
1608         /* MASKING NOTES
1609             earnings masks are a tricky thing for people to wrap their minds around.
1610             the basic thing to understand here.  is were going to have a global
1611             tracker based on profit per share for each round, that increases in
1612             relevant proportion to the increase in share supply.
1613 
1614             the player will have an additional mask that basically says "based
1615             on the rounds mask, my shares, and how much i've already withdrawn,
1616             how much is still owed to me?"
1617         */
1618 
1619         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1620         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1621         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1622 
1623         // calculate player earning from their own buy (only based on the keys
1624         // they just bought).  & update player earnings mask
1625         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1626         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1627 
1628         // calculate & return dust
1629         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1630     }
1631 
1632     /**
1633      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1634      * @return earnings in wei format
1635      */
1636     function withdrawEarnings(uint256 _pID)
1637         private
1638         returns(uint256)
1639     {
1640         // update gen vault
1641         updateGenVault(_pID, plyr_[_pID].lrnd);
1642 
1643         // from vaults
1644         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1645         if (_earnings > 0)
1646         {
1647             plyr_[_pID].win = 0;
1648             plyr_[_pID].gen = 0;
1649             plyr_[_pID].aff = 0;
1650         }
1651 
1652         return(_earnings);
1653     }
1654 
1655     /**
1656      * @dev prepares compression data and fires event for buy or reload tx's
1657      */
1658     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1659         private
1660     {
1661         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1662         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1663 
1664         emit F3Devents.onEndTx
1665         (
1666             _eventData_.compressedData,
1667             _eventData_.compressedIDs,
1668             plyr_[_pID].name,
1669             msg.sender,
1670             _eth,
1671             _keys,
1672             _eventData_.winnerAddr,
1673             _eventData_.winnerName,
1674             _eventData_.amountWon,
1675             _eventData_.newPot,
1676             _eventData_.P3DAmount,
1677             _eventData_.genAmount,
1678             _eventData_.potAmount,
1679             airDropPot_
1680         );
1681     }
1682 //==============================================================================
1683 //    (~ _  _    _._|_    .
1684 //    _)(/_(_|_|| | | \/  .
1685 //====================/=========================================================
1686     /** upon contract deploy, it will be deactivated.  this is a one time
1687      * use function that will activate the contract.  we do this so devs
1688      * have time to set things up on the web end                            **/
1689     bool public activated_ = false;
1690     function activate()
1691         public
1692     {
1693         // only team LJIT can activate
1694         require(
1695             msg.sender == 0x15fa4E13442BE603E3c7D7b1540b88FDe28ACE04 ||
1696             msg.sender == 0x24e4b7b6BB591490bE9dF37B2f06124606C2487A ||
1697             msg.sender == 0xaC0d35cd3141E93C9320317b328CED3dc076B476,
1698             "only team LJIT can activate"
1699         );
1700 
1701 		// make sure that its been linked.
1702         // require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1703 
1704         // can only be ran once
1705         require(activated_ == false, "fomo3d already activated");
1706 
1707         // activate the contract
1708         activated_ = true;
1709 
1710         // lets start first round
1711 		rID_ = 1;
1712         round_[1].strt = now + rndExtra_ - rndGap_;
1713         round_[1].end = now + rndInit_ + rndExtra_;
1714     }
1715     // function setOtherFomo(address _otherF3D)
1716     //     public
1717     // {
1718     //     // only team just can activate
1719     //     require(
1720     //         msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1721     //         msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1722     //         msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1723     //         msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1724 	// 		msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1725     //         "only team just can activate"
1726     //     );
1727 
1728     //     // make sure that it HASNT yet been linked.
1729     //     require(address(otherF3D_) == address(0), "silly dev, you already did that");
1730 
1731     //     // set up other fomo3d (fast or long) for pot swap
1732     //     otherF3D_ = otherFoMo3D(_otherF3D);
1733     // }
1734 }
1735 
1736 //==============================================================================
1737 //   __|_ _    __|_ _  .
1738 //  _\ | | |_|(_ | _\  .
1739 //==============================================================================
1740 library F3Ddatasets {
1741     //compressedData key
1742     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1743         // 0 - new player (bool)
1744         // 1 - joined round (bool)
1745         // 2 - new  leader (bool)
1746         // 3-5 - air drop tracker (uint 0-999)
1747         // 6-16 - round end time
1748         // 17 - winnerTeam
1749         // 18 - 28 timestamp
1750         // 29 - team
1751         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1752         // 31 - airdrop happened bool
1753         // 32 - airdrop tier
1754         // 33 - airdrop amount won
1755     //compressedIDs key
1756     // [77-52][51-26][25-0]
1757         // 0-25 - pID
1758         // 26-51 - winPID
1759         // 52-77 - rID
1760     struct EventReturns {
1761         uint256 compressedData;
1762         uint256 compressedIDs;
1763         address winnerAddr;         // winner address
1764         bytes32 winnerName;         // winner name
1765         uint256 amountWon;          // amount won
1766         uint256 newPot;             // amount in new pot
1767         uint256 P3DAmount;          // amount distributed to p3d
1768         uint256 genAmount;          // amount distributed to gen
1769         uint256 potAmount;          // amount added to pot
1770     }
1771     struct Player {
1772         address addr;   // player address
1773         bytes32 name;   // player name
1774         uint256 win;    // winnings vault
1775         uint256 gen;    // general vault
1776         uint256 aff;    // affiliate vault
1777         uint256 lrnd;   // last round played
1778         uint256 laff;   // last affiliate id used
1779     }
1780     struct PlayerRounds {
1781         uint256 eth;    // eth player has added to round (used for eth limiter)
1782         uint256 keys;   // keys
1783         uint256 mask;   // player mask
1784         uint256 ico;    // ICO phase investment
1785     }
1786     struct Round {
1787         uint256 plyr;   // pID of player in lead
1788         uint256 team;   // tID of team in lead
1789         uint256 end;    // time ends/ended
1790         bool ended;     // has round end function been ran
1791         uint256 strt;   // time round started
1792         uint256 keys;   // keys
1793         uint256 eth;    // total eth in
1794         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1795         uint256 mask;   // global mask
1796         uint256 ico;    // total eth sent in during ICO phase
1797         uint256 icoGen; // total eth for gen during ICO phase
1798         uint256 icoAvg; // average key price for ICO phase
1799     }
1800     struct TeamFee {
1801         uint256 gen;    // % of buy in thats paid to key holders of current round
1802         uint256 p3d;    // % of buy in thats paid to p3d holders
1803     }
1804     struct PotSplit {
1805         uint256 gen;    // % of pot thats paid to key holders of current round
1806         uint256 p3d;    // % of pot thats paid to p3d holders
1807     }
1808 }
1809 
1810 //==============================================================================
1811 //  |  _      _ _ | _  .
1812 //  |<(/_\/  (_(_||(_  .
1813 //=======/======================================================================
1814 library F3DKeysCalcLong {
1815     using SafeMath for *;
1816     /**
1817      * @dev calculates number of keys received given X eth
1818      * @param _curEth current amount of eth in contract
1819      * @param _newEth eth being spent
1820      * @return amount of ticket purchased
1821      */
1822     function keysRec(uint256 _curEth, uint256 _newEth)
1823         internal
1824         pure
1825         returns (uint256)
1826     {
1827         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1828     }
1829 
1830     /**
1831      * @dev calculates amount of eth received if you sold X keys
1832      * @param _curKeys current amount of keys that exist
1833      * @param _sellKeys amount of keys you wish to sell
1834      * @return amount of eth received
1835      */
1836     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1837         internal
1838         pure
1839         returns (uint256)
1840     {
1841         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1842     }
1843 
1844     /**
1845      * @dev calculates how many keys would exist with given an amount of eth
1846      * @param _eth eth "in contract"
1847      * @return number of keys that would exist
1848      */
1849     function keys(uint256 _eth)
1850         internal
1851         pure
1852         returns(uint256)
1853     {
1854         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1855     }
1856 
1857     /**
1858      * @dev calculates how much eth would be in contract given a number of keys
1859      * @param _keys number of keys "in contract"
1860      * @return eth that would exists
1861      */
1862     function eth(uint256 _keys)
1863         internal
1864         pure
1865         returns(uint256)
1866     {
1867         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1868     }
1869 }
1870 
1871 //==============================================================================
1872 //  . _ _|_ _  _ |` _  _ _  _  .
1873 //  || | | (/_| ~|~(_|(_(/__\  .
1874 //==============================================================================
1875 // interface otherFoMo3D {
1876 //     function potSwap() external payable;
1877 // }
1878 
1879 interface F3DexternalSettingsInterface {
1880     function getFastGap() external returns(uint256);
1881     function getLongGap() external returns(uint256);
1882     function getFastExtra() external returns(uint256);
1883     function getLongExtra() external returns(uint256);
1884 }
1885 
1886 interface DiviesInterface {
1887     function deposit() external payable;
1888 }
1889 
1890 interface JIincForwarderInterface {
1891     function deposit() external payable returns(bool);
1892     function status() external view returns(address, address, bool);
1893     function startMigration(address _newCorpBank) external returns(bool);
1894     function cancelMigration() external returns(bool);
1895     function finishMigration() external returns(bool);
1896     function setup(address _firstCorpBank) external;
1897 }
1898 
1899 interface PlayerBookInterface {
1900     function getPlayerID(address _addr) external returns (uint256);
1901     function getPlayerName(uint256 _pID) external view returns (bytes32);
1902     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1903     function getPlayerAddr(uint256 _pID) external view returns (address);
1904     function getNameFee() external view returns (uint256);
1905     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1906     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1907     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1908 }
1909 
1910 /**
1911 * @title -Name Filter- v0.1.9
1912 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1913 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1914 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1915 *                                  _____                      _____
1916 *                                 (, /     /)       /) /)    (, /      /)          /)
1917 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1918 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1919 *          ┴ ┴                /   /          .-/ _____   (__ /
1920 *                            (__ /          (_/ (, /                                      /)™
1921 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1922 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1923 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1924 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1925 *              _       __    _      ____      ____  _   _    _____  ____  ___
1926 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1927 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1928 *
1929 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1930 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1931 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1932 */
1933 
1934 library NameFilter {
1935     /**
1936      * @dev filters name strings
1937      * -converts uppercase to lower case.
1938      * -makes sure it does not start/end with a space
1939      * -makes sure it does not contain multiple spaces in a row
1940      * -cannot be only numbers
1941      * -cannot start with 0x
1942      * -restricts characters to A-Z, a-z, 0-9, and space.
1943      * @return reprocessed string in bytes32 format
1944      */
1945     function nameFilter(string _input)
1946         internal
1947         pure
1948         returns(bytes32)
1949     {
1950         bytes memory _temp = bytes(_input);
1951         uint256 _length = _temp.length;
1952 
1953         //sorry limited to 32 characters
1954         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1955         // make sure it doesnt start with or end with space
1956         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1957         // make sure first two characters are not 0x
1958         if (_temp[0] == 0x30)
1959         {
1960             require(_temp[1] != 0x78, "string cannot start with 0x");
1961             require(_temp[1] != 0x58, "string cannot start with 0X");
1962         }
1963 
1964         // create a bool to track if we have a non number character
1965         bool _hasNonNumber;
1966 
1967         // convert & check
1968         for (uint256 i = 0; i < _length; i++)
1969         {
1970             // if its uppercase A-Z
1971             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1972             {
1973                 // convert to lower case a-z
1974                 _temp[i] = byte(uint(_temp[i]) + 32);
1975 
1976                 // we have a non number
1977                 if (_hasNonNumber == false)
1978                     _hasNonNumber = true;
1979             } else {
1980                 require
1981                 (
1982                     // require character is a space
1983                     _temp[i] == 0x20 ||
1984                     // OR lowercase a-z
1985                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1986                     // or 0-9
1987                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1988                     "string contains invalid characters"
1989                 );
1990                 // make sure theres not 2x spaces in a row
1991                 if (_temp[i] == 0x20)
1992                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1993 
1994                 // see if we have a character other than a number
1995                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1996                     _hasNonNumber = true;
1997             }
1998         }
1999 
2000         require(_hasNonNumber == true, "string cannot be only numbers");
2001 
2002         bytes32 _ret;
2003         assembly {
2004             _ret := mload(add(_temp, 32))
2005         }
2006         return (_ret);
2007     }
2008 }
2009 
2010 /**
2011  * @title SafeMath v0.1.9
2012  * @dev Math operations with safety checks that throw on error
2013  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2014  * - added sqrt
2015  * - added sq
2016  * - added pwr
2017  * - changed asserts to requires with error log outputs
2018  * - removed div, its useless
2019  */
2020 library SafeMath {
2021 
2022     /**
2023     * @dev Multiplies two numbers, throws on overflow.
2024     */
2025     function mul(uint256 a, uint256 b)
2026         internal
2027         pure
2028         returns (uint256 c)
2029     {
2030         if (a == 0) {
2031             return 0;
2032         }
2033         c = a * b;
2034         require(c / a == b, "SafeMath mul failed");
2035         return c;
2036     }
2037 
2038     /**
2039     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2040     */
2041     function sub(uint256 a, uint256 b)
2042         internal
2043         pure
2044         returns (uint256)
2045     {
2046         require(b <= a, "SafeMath sub failed");
2047         return a - b;
2048     }
2049 
2050     /**
2051     * @dev Adds two numbers, throws on overflow.
2052     */
2053     function add(uint256 a, uint256 b)
2054         internal
2055         pure
2056         returns (uint256 c)
2057     {
2058         c = a + b;
2059         require(c >= a, "SafeMath add failed");
2060         return c;
2061     }
2062 
2063     /**
2064      * @dev gives square root of given x.
2065      */
2066     function sqrt(uint256 x)
2067         internal
2068         pure
2069         returns (uint256 y)
2070     {
2071         uint256 z = ((add(x,1)) / 2);
2072         y = x;
2073         while (z < y)
2074         {
2075             y = z;
2076             z = ((add((x / z),z)) / 2);
2077         }
2078     }
2079 
2080     /**
2081      * @dev gives square. multiplies x by x
2082      */
2083     function sq(uint256 x)
2084         internal
2085         pure
2086         returns (uint256)
2087     {
2088         return (mul(x,x));
2089     }
2090 
2091     /**
2092      * @dev x to the power of y
2093      */
2094     function pwr(uint256 x, uint256 y)
2095         internal
2096         pure
2097         returns (uint256)
2098     {
2099         if (x==0)
2100             return (0);
2101         else if (y==0)
2102             return (1);
2103         else
2104         {
2105             uint256 z = x;
2106             for (uint256 i=1; i < y; i++)
2107                 z = mul(z,x);
2108             return (z);
2109         }
2110     }
2111 }