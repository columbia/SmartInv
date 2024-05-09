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
41  *   │ ChungkueiBlock, Ambius, Aritz Cracker, Cryptoknight,    │  ║ ├─┤├─┤│││├┴┐└─┐   ║ │ │
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
178 contract modularLong is F3Devents { }
179 
180 contract FoMo3Dlong is modularLong {
181     using SafeMath for *;
182     using NameFilter for string;
183     using F3DKeysCalcLong for uint256;
184 
185     // otherFoMo3D private otherF3D_;
186     address private otherF3D_;
187 
188     // remove the 害虫
189     // DiviesInterface constant private Divies = DiviesInterface(0xe7d5f7a1afbfeb44894c1114fb021cab7e0367fd);
190     // 简化社区分红
191     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x548e2295fc38b69000ff43a730933919b08c2562);
192     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x86767b90BAC12000aAB5Bd2037e32E5775928bbB);
193     // hack 闭源合约
194     // F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x85C2d5079DC6C2856116C41f4EDd2E3EBBb63B5C);
195 //==============================================================================
196 //     _ _  _  |`. _     _ _ |_ | _  _  .
197 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
198 //=================_|===========================================================
199     string constant public name = "imfomo Long Official";
200     string constant public symbol = "imfomo";
201     uint256 private rndExtra_ = 30;     // length of the very first ICO
202     uint256 private rndGap_ = 30;         // length of ICO phase, set to 1 year for EOS.
203     uint256 constant private rndInit_ = 10 minutes;                // round timer starts at this
204     uint256 constant private rndInc_ = 60 seconds;              // every full key purchased adds this much to the timer
205     uint256 constant private rndMax_ = 10 minutes;                // max length a round timer can be
206     address constant private reward = 0x43505CE3219A8C93Cf8d18782094404A4450126b;
207 //==============================================================================
208 //     _| _ _|_ _    _ _ _|_    _   .
209 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
210 //=============================|================================================
211     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
212     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
213     uint256 public rID_;    // round id number / total rounds that have happened
214 //****************
215 // PLAYER DATA 
216 //****************
217     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
218     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
219     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
220     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
221     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
222 //****************
223 // ROUND DATA 
224 //****************
225     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
226     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
227 //****************
228 // TEAM FEE DATA 
229 //****************
230     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
231     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
232 //==============================================================================
233 //     _ _  _  __|_ _    __|_ _  _  .
234 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
235 //==============================================================================
236     constructor()
237         public
238     {
239 		// Team allocation structures
240         // 0 = whales
241         // 1 = bears
242         // 2 = sneks
243         // 3 = bulls
244 
245 		// Team allocation percentages
246         // (F3D, P3D) + (Pot , Referrals, Community)
247             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
248         fees_[0] = F3Ddatasets.TeamFee(31,0);   //50% to pot, 15% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
249         fees_[1] = F3Ddatasets.TeamFee(38,0);   //43% to pot, 15% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
250         fees_[2] = F3Ddatasets.TeamFee(61,0);   //20% to pot, 15% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
251         fees_[3] = F3Ddatasets.TeamFee(46,0);   //35% to pot, 15% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
252         
253         // how to split up the final pot based on which team was picked
254         // (F3D, P3D)
255         potSplit_[0] = F3Ddatasets.PotSplit(15,0);  //58% to winner, 25% to next round, 2% to com
256         potSplit_[1] = F3Ddatasets.PotSplit(15,0);  //58% to winner, 25% to next round, 2% to com
257         potSplit_[2] = F3Ddatasets.PotSplit(30,0);  //58% to winner, 10% to next round, 2% to com
258         potSplit_[3] = F3Ddatasets.PotSplit(30,0);  //58% to winner, 10% to next round, 2% to com
259     }
260 //==============================================================================
261 //     _ _  _  _|. |`. _  _ _  .
262 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
263 //==============================================================================
264     /**
265      * @dev used to make sure no one can interact with contract until it has 
266      * been activated. 
267      */
268     modifier isActivated() {
269         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
270         _;
271     }
272     
273     /**
274      * @dev prevents contracts from interacting with fomo3d 
275      */
276     modifier isHuman() {
277         address _addr = msg.sender;
278         uint256 _codeLength;
279         
280         assembly {_codeLength := extcodesize(_addr)}
281         require(_codeLength == 0, "sorry humans only");
282         _;
283     }
284 
285     /**
286      * @dev sets boundaries for incoming tx 
287      */
288     modifier isWithinLimits(uint256 _eth) {
289         require(_eth >= 1000000000, "pocket lint: not a valid currency");
290         require(_eth <= 100000000000000000000000, "no vitalik, no");
291         _;    
292     }
293     
294 //==============================================================================
295 //     _    |_ |. _   |`    _  __|_. _  _  _  .
296 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
297 //====|=========================================================================
298     /**
299      * @dev emergency buy uses last stored affiliate ID and team snek
300      */
301     function()
302         isActivated()
303         isHuman()
304         isWithinLimits(msg.value)
305         public
306         payable
307     {
308         // set up our tx event data and determine if player is new or not
309         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
310             
311         // fetch player id
312         uint256 _pID = pIDxAddr_[msg.sender];
313         
314         // buy core 
315         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
316     }
317     
318     /**
319      * @dev converts all incoming ethereum to keys.
320      * -functionhash- 0x8f38f309 (using ID for affiliate)
321      * -functionhash- 0x98a0871d (using address for affiliate)
322      * -functionhash- 0xa65b37a1 (using name for affiliate)
323      * @param _affCode the ID/address/name of the player who gets the affiliate fee
324      * @param _team what team is the player playing for?
325      */
326     function buyXid(uint256 _affCode, uint256 _team)
327         isActivated()
328         isHuman()
329         isWithinLimits(msg.value)
330         public
331         payable
332     {
333         // set up our tx event data and determine if player is new or not
334         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
335         
336         // fetch player id
337         uint256 _pID = pIDxAddr_[msg.sender];
338         
339         // manage affiliate residuals
340         // if no affiliate code was given or player tried to use their own, lolz
341         if (_affCode == 0 || _affCode == _pID)
342         {
343             // use last stored affiliate code 
344             _affCode = plyr_[_pID].laff;
345             
346         // if affiliate code was given & its not the same as previously stored 
347         } else if (_affCode != plyr_[_pID].laff) {
348             // update last affiliate 
349             plyr_[_pID].laff = _affCode;
350         }
351         
352         // verify a valid team was selected
353         _team = verifyTeam(_team);
354         
355         // buy core 
356         buyCore(_pID, _affCode, _team, _eventData_);
357     }
358     
359     function buyXaddr(address _affCode, uint256 _team)
360         isActivated()
361         isHuman()
362         isWithinLimits(msg.value)
363         public
364         payable
365     {
366         // set up our tx event data and determine if player is new or not
367         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
368         
369         // fetch player id
370         uint256 _pID = pIDxAddr_[msg.sender];
371         
372         // manage affiliate residuals
373         uint256 _affID;
374         // if no affiliate code was given or player tried to use their own, lolz
375         if (_affCode == address(0) || _affCode == msg.sender)
376         {
377             // use last stored affiliate code
378             _affID = plyr_[_pID].laff;
379         
380         // if affiliate code was given    
381         } else {
382             // get affiliate ID from aff Code 
383             _affID = pIDxAddr_[_affCode];
384             
385             // if affID is not the same as previously stored 
386             if (_affID != plyr_[_pID].laff)
387             {
388                 // update last affiliate
389                 plyr_[_pID].laff = _affID;
390             }
391         }
392         
393         // verify a valid team was selected
394         _team = verifyTeam(_team);
395         
396         // buy core 
397         buyCore(_pID, _affID, _team, _eventData_);
398     }
399     
400     function buyXname(bytes32 _affCode, uint256 _team)
401         isActivated()
402         isHuman()
403         isWithinLimits(msg.value)
404         public
405         payable
406     {
407         // set up our tx event data and determine if player is new or not
408         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
409         
410         // fetch player id
411         uint256 _pID = pIDxAddr_[msg.sender];
412         
413         // manage affiliate residuals
414         uint256 _affID;
415         // if no affiliate code was given or player tried to use their own, lolz
416         if (_affCode == '' || _affCode == plyr_[_pID].name)
417         {
418             // use last stored affiliate code
419             _affID = plyr_[_pID].laff;
420         
421         // if affiliate code was given
422         } else {
423             // get affiliate ID from aff Code
424             _affID = pIDxName_[_affCode];
425             
426             // if affID is not the same as previously stored
427             if (_affID != plyr_[_pID].laff)
428             {
429                 // update last affiliate
430                 plyr_[_pID].laff = _affID;
431             }
432         }
433         
434         // verify a valid team was selected
435         _team = verifyTeam(_team);
436         
437         // buy core 
438         buyCore(_pID, _affID, _team, _eventData_);
439     }
440     
441     /**
442      * @dev essentially the same as buy, but instead of you sending ether 
443      * from your wallet, it uses your unwithdrawn earnings.
444      * -functionhash- 0x349cdcac (using ID for affiliate)
445      * -functionhash- 0x82bfc739 (using address for affiliate)
446      * -functionhash- 0x079ce327 (using name for affiliate)
447      * @param _affCode the ID/address/name of the player who gets the affiliate fee
448      * @param _team what team is the player playing for?
449      * @param _eth amount of earnings to use (remainder returned to gen vault)
450      */
451     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
452         isActivated()
453         isHuman()
454         isWithinLimits(_eth)
455         public
456     {
457         // set up our tx event data
458         F3Ddatasets.EventReturns memory _eventData_;
459         
460         // fetch player ID
461         uint256 _pID = pIDxAddr_[msg.sender];
462         
463         // manage affiliate residuals
464         // if no affiliate code was given or player tried to use their own, lolz
465         if (_affCode == 0 || _affCode == _pID)
466         {
467             // use last stored affiliate code 
468             _affCode = plyr_[_pID].laff;
469             
470         // if affiliate code was given & its not the same as previously stored 
471         } else if (_affCode != plyr_[_pID].laff) {
472             // update last affiliate 
473             plyr_[_pID].laff = _affCode;
474         }
475 
476         // verify a valid team was selected
477         _team = verifyTeam(_team);
478 
479         // reload core
480         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
481     }
482     
483     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
484         isActivated()
485         isHuman()
486         isWithinLimits(_eth)
487         public
488     {
489         // set up our tx event data
490         F3Ddatasets.EventReturns memory _eventData_;
491         
492         // fetch player ID
493         uint256 _pID = pIDxAddr_[msg.sender];
494         
495         // manage affiliate residuals
496         uint256 _affID;
497         // if no affiliate code was given or player tried to use their own, lolz
498         if (_affCode == address(0) || _affCode == msg.sender)
499         {
500             // use last stored affiliate code
501             _affID = plyr_[_pID].laff;
502         
503         // if affiliate code was given    
504         } else {
505             // get affiliate ID from aff Code 
506             _affID = pIDxAddr_[_affCode];
507             
508             // if affID is not the same as previously stored 
509             if (_affID != plyr_[_pID].laff)
510             {
511                 // update last affiliate
512                 plyr_[_pID].laff = _affID;
513             }
514         }
515         
516         // verify a valid team was selected
517         _team = verifyTeam(_team);
518         
519         // reload core
520         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
521     }
522     
523     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
524         isActivated()
525         isHuman()
526         isWithinLimits(_eth)
527         public
528     {
529         // set up our tx event data
530         F3Ddatasets.EventReturns memory _eventData_;
531         
532         // fetch player ID
533         uint256 _pID = pIDxAddr_[msg.sender];
534         
535         // manage affiliate residuals
536         uint256 _affID;
537         // if no affiliate code was given or player tried to use their own, lolz
538         if (_affCode == '' || _affCode == plyr_[_pID].name)
539         {
540             // use last stored affiliate code
541             _affID = plyr_[_pID].laff;
542         
543         // if affiliate code was given
544         } else {
545             // get affiliate ID from aff Code
546             _affID = pIDxName_[_affCode];
547             
548             // if affID is not the same as previously stored
549             if (_affID != plyr_[_pID].laff)
550             {
551                 // update last affiliate
552                 plyr_[_pID].laff = _affID;
553             }
554         }
555         
556         // verify a valid team was selected
557         _team = verifyTeam(_team);
558         
559         // reload core
560         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
561     }
562 
563     /**
564      * @dev withdraws all of your earnings.
565      * -functionhash- 0x3ccfd60b
566      */
567     function withdraw()
568         isActivated()
569         isHuman()
570         public
571     {
572         // setup local rID 
573         uint256 _rID = rID_;
574         
575         // grab time
576         uint256 _now = now;
577         
578         // fetch player ID
579         uint256 _pID = pIDxAddr_[msg.sender];
580         
581         // setup temp var for player eth
582         uint256 _eth;
583         
584         // check to see if round has ended and no one has run round end yet
585         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
586         {
587             // set up our tx event data
588             F3Ddatasets.EventReturns memory _eventData_;
589             
590             // end the round (distributes pot)
591             round_[_rID].ended = true;
592             _eventData_ = endRound(_eventData_);
593             
594 			// get their earnings
595             _eth = withdrawEarnings(_pID);
596             
597             // gib moni
598             if (_eth > 0)
599                 plyr_[_pID].addr.transfer(_eth);    
600             
601             // build event data
602             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
603             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
604             
605             // fire withdraw and distribute event
606             emit F3Devents.onWithdrawAndDistribute
607             (
608                 msg.sender, 
609                 plyr_[_pID].name, 
610                 _eth, 
611                 _eventData_.compressedData, 
612                 _eventData_.compressedIDs, 
613                 _eventData_.winnerAddr, 
614                 _eventData_.winnerName, 
615                 _eventData_.amountWon, 
616                 _eventData_.newPot, 
617                 _eventData_.P3DAmount, 
618                 _eventData_.genAmount
619             );
620             
621         // in any other situation
622         } else {
623             // get their earnings
624             _eth = withdrawEarnings(_pID);
625             
626             // gib moni
627             if (_eth > 0)
628                 plyr_[_pID].addr.transfer(_eth);
629             
630             // fire withdraw event
631             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
632         }
633     }
634     
635     /**
636      * @dev use these to register names.  they are just wrappers that will send the
637      * registration requests to the PlayerBook contract.  So registering here is the 
638      * same as registering there.  UI will always display the last name you registered.
639      * but you will still own all previously registered names to use as affiliate 
640      * links.
641      * - must pay a registration fee.
642      * - name must be unique
643      * - names will be converted to lowercase
644      * - name cannot start or end with a space 
645      * - cannot have more than 1 space in a row
646      * - cannot be only numbers
647      * - cannot start with 0x 
648      * - name must be at least 1 char
649      * - max length of 32 characters long
650      * - allowed characters: a-z, 0-9, and space
651      * -functionhash- 0x921dec21 (using ID for affiliate)
652      * -functionhash- 0x3ddd4698 (using address for affiliate)
653      * -functionhash- 0x685ffd83 (using name for affiliate)
654      * @param _nameString players desired name
655      * @param _affCode affiliate ID, address, or name of who referred you
656      * @param _all set to true if you want this to push your info to all games 
657      * (this might cost a lot of gas)
658      */
659     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
660         isHuman()
661         public
662         payable
663     {
664         bytes32 _name = _nameString.nameFilter();
665         address _addr = msg.sender;
666         uint256 _paid = msg.value;
667         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
668         
669         uint256 _pID = pIDxAddr_[_addr];
670         
671         // fire event
672         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
673     }
674     
675     function registerNameXaddr(string _nameString, address _affCode, bool _all)
676         isHuman()
677         public
678         payable
679     {
680         bytes32 _name = _nameString.nameFilter();
681         address _addr = msg.sender;
682         uint256 _paid = msg.value;
683         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
684         
685         uint256 _pID = pIDxAddr_[_addr];
686         
687         // fire event
688         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
689     }
690     
691     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
692         isHuman()
693         public
694         payable
695     {
696         bytes32 _name = _nameString.nameFilter();
697         address _addr = msg.sender;
698         uint256 _paid = msg.value;
699         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
700         
701         uint256 _pID = pIDxAddr_[_addr];
702         
703         // fire event
704         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
705     }
706 //==============================================================================
707 //     _  _ _|__|_ _  _ _  .
708 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
709 //=====_|=======================================================================
710     /**
711      * @dev return the price buyer will pay for next 1 individual key.
712      * -functionhash- 0x018a25e8
713      * @return price for next key bought (in wei format)
714      */
715     function getBuyPrice()
716         public 
717         view 
718         returns(uint256)
719     {  
720         // setup local rID
721         uint256 _rID = rID_;
722         
723         // grab time
724         uint256 _now = now;
725         
726         // are we in a round?
727         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
728             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
729         else // rounds over.  need price for new round
730             return ( 75000000000000 ); // init
731     }
732     
733     /**
734      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
735      * provider
736      * -functionhash- 0xc7e284b8
737      * @return time left in seconds
738      */
739     function getTimeLeft()
740         public
741         view
742         returns(uint256)
743     {
744         // setup local rID
745         uint256 _rID = rID_;
746         
747         // grab time
748         uint256 _now = now;
749         
750         if (_now < round_[_rID].end)
751             if (_now > round_[_rID].strt + rndGap_)
752                 return( (round_[_rID].end).sub(_now) );
753             else
754                 return( (round_[_rID].strt + rndGap_).sub(_now) );
755         else
756             return(0);
757     }
758     
759     /**
760      * @dev returns player earnings per vaults 
761      * -functionhash- 0x63066434
762      * @return winnings vault
763      * @return general vault
764      * @return affiliate vault
765      */
766     function getPlayerVaults(uint256 _pID)
767         public
768         view
769         returns(uint256 ,uint256, uint256)
770     {
771         // setup local rID
772         uint256 _rID = rID_;
773         
774         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
775         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
776         {
777             // if player is winner 
778             if (round_[_rID].plyr == _pID)
779             {
780                 return
781                 (
782                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(58)) / 100 ),
783                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
784                     plyr_[_pID].aff
785                 );
786             // if player is not the winner
787             } else {
788                 return
789                 (
790                     plyr_[_pID].win,
791                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
792                     plyr_[_pID].aff
793                 );
794             }
795             
796         // if round is still going on, or round has ended and round end has been ran
797         } else {
798             return
799             (
800                 plyr_[_pID].win,
801                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
802                 plyr_[_pID].aff
803             );
804         }
805     }
806     
807     /**
808      * solidity hates stack limits.  this lets us avoid that hate 
809      */
810     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
811         private
812         view
813         returns(uint256)
814     {
815         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
816     }
817     
818     /**
819      * @dev returns all current round info needed for front end
820      * -functionhash- 0x747dff42
821      * @return eth invested during ICO phase
822      * @return round id 
823      * @return total keys for round 
824      * @return time round ends
825      * @return time round started
826      * @return current pot 
827      * @return current team ID & player ID in lead 
828      * @return current player in leads address 
829      * @return current player in leads name
830      * @return whales eth in for round
831      * @return bears eth in for round
832      * @return sneks eth in for round
833      * @return bulls eth in for round
834      * @return airdrop tracker # & airdrop pot
835      */
836     function getCurrentRoundInfo()
837         public
838         view
839         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
840     {
841         // setup local rID
842         uint256 _rID = rID_;
843         
844         return
845         (
846             round_[_rID].ico,               //0
847             _rID,                           //1
848             round_[_rID].keys,              //2
849             round_[_rID].end,               //3
850             round_[_rID].strt,              //4
851             round_[_rID].pot,               //5
852             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
853             plyr_[round_[_rID].plyr].addr,  //7
854             plyr_[round_[_rID].plyr].name,  //8
855             rndTmEth_[_rID][0],             //9
856             rndTmEth_[_rID][1],             //10
857             rndTmEth_[_rID][2],             //11
858             rndTmEth_[_rID][3],             //12
859             airDropTracker_ + (airDropPot_ * 1000)              //13
860         );
861     }
862 
863     /**
864      * @dev returns player info based on address.  if no address is given, it will 
865      * use msg.sender 
866      * -functionhash- 0xee0b5d8b
867      * @param _addr address of the player you want to lookup 
868      * @return player ID 
869      * @return player name
870      * @return keys owned (current round)
871      * @return winnings vault
872      * @return general vault 
873      * @return affiliate vault 
874 	 * @return player round eth
875      */
876     function getPlayerInfoByAddress(address _addr)
877         public 
878         view 
879         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
880     {
881         // setup local rID
882         uint256 _rID = rID_;
883         
884         if (_addr == address(0))
885         {
886             _addr == msg.sender;
887         }
888         uint256 _pID = pIDxAddr_[_addr];
889         
890         return
891         (
892             _pID,                               //0
893             plyr_[_pID].name,                   //1
894             plyrRnds_[_pID][_rID].keys,         //2
895             plyr_[_pID].win,                    //3
896             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
897             plyr_[_pID].aff,                    //5
898             plyrRnds_[_pID][_rID].eth           //6
899         );
900     }
901 
902 //==============================================================================
903 //     _ _  _ _   | _  _ . _  .
904 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
905 //=====================_|=======================================================
906     /**
907      * @dev logic runs whenever a buy order is executed.  determines how to handle 
908      * incoming eth depending on if we are in an active round or not
909      */
910     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
911         private
912     {
913         // setup local rID
914         uint256 _rID = rID_;
915         
916         // grab time
917         uint256 _now = now;
918         
919         // if round is active
920         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
921         {
922             // call core 
923             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
924         
925         // if round is not active     
926         } else {
927             // check to see if end round needs to be ran
928             if (_now > round_[_rID].end && round_[_rID].ended == false) 
929             {
930                 // end the round (distributes pot) & start new round
931 			    round_[_rID].ended = true;
932                 _eventData_ = endRound(_eventData_);
933                 
934                 // build event data
935                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
936                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
937                 
938                 // fire buy and distribute event 
939                 emit F3Devents.onBuyAndDistribute
940                 (
941                     msg.sender, 
942                     plyr_[_pID].name, 
943                     msg.value, 
944                     _eventData_.compressedData, 
945                     _eventData_.compressedIDs, 
946                     _eventData_.winnerAddr, 
947                     _eventData_.winnerName, 
948                     _eventData_.amountWon, 
949                     _eventData_.newPot, 
950                     _eventData_.P3DAmount, 
951                     _eventData_.genAmount
952                 );
953             }
954             
955             // put eth in players vault 
956             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
957         }
958     }
959     
960     /**
961      * @dev logic runs whenever a reload order is executed.  determines how to handle 
962      * incoming eth depending on if we are in an active round or not 
963      */
964     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
965         private
966     {
967         // setup local rID
968         uint256 _rID = rID_;
969         
970         // grab time
971         uint256 _now = now;
972         
973         // if round is active
974         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
975         {
976             // get earnings from all vaults and return unused to gen vault
977             // because we use a custom safemath library.  this will throw if player 
978             // tried to spend more eth than they have.
979             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
980             
981             // call core 
982             core(_rID, _pID, _eth, _affID, _team, _eventData_);
983         
984         // if round is not active and end round needs to be ran   
985         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
986             // end the round (distributes pot) & start new round
987             round_[_rID].ended = true;
988             _eventData_ = endRound(_eventData_);
989                 
990             // build event data
991             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
992             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
993                 
994             // fire buy and distribute event 
995             emit F3Devents.onReLoadAndDistribute
996             (
997                 msg.sender, 
998                 plyr_[_pID].name, 
999                 _eventData_.compressedData, 
1000                 _eventData_.compressedIDs, 
1001                 _eventData_.winnerAddr, 
1002                 _eventData_.winnerName, 
1003                 _eventData_.amountWon, 
1004                 _eventData_.newPot, 
1005                 _eventData_.P3DAmount, 
1006                 _eventData_.genAmount
1007             );
1008         }
1009     }
1010     
1011     /**
1012      * @dev this is the core logic for any buy/reload that happens while a round 
1013      * is live.
1014      */
1015     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1016         private
1017     {
1018         // if player is new to round
1019         if (plyrRnds_[_pID][_rID].keys == 0)
1020             _eventData_ = managePlayer(_pID, _eventData_);
1021         
1022         // early round eth limiter 
1023         // 当一轮刚开始时，合约收到的总ETH数小于100且某用户累计充值超过1ETH的时候，将不再能买到keys，你多余钱会直接计入你的收益
1024         // if (round_[_rID].eth < 1000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1025         // {
1026         //     uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1027         //     uint256 _refund = _eth.sub(_availableLimit);
1028         //     plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1029         //     _eth = _availableLimit;
1030         // }
1031         
1032         // if eth left is greater than min eth allowed (sorry no pocket lint)
1033         if (_eth > 1000000000) 
1034         {
1035             
1036             // mint the new keys
1037             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1038             
1039             // if they bought at least 1 whole key
1040             if (_keys >= 1000000000000000000)
1041             {
1042             updateTimer(_keys, _rID);
1043 
1044             // set new leaders
1045             if (round_[_rID].plyr != _pID)
1046                 round_[_rID].plyr = _pID;  
1047             if (round_[_rID].team != _team)
1048                 round_[_rID].team = _team; 
1049             
1050             // set the new leader bool to true
1051             _eventData_.compressedData = _eventData_.compressedData + 100;
1052         }
1053             
1054             // manage airdrops
1055             if (_eth >= 100000000000000000)
1056             {
1057             airDropTracker_++;
1058             if (airdrop() == true)
1059             {
1060                 // gib muni
1061                 uint256 _prize;
1062                 // >= 10 ether
1063                 if (_eth >= 10000000000000000000)
1064                 {
1065                     // calculate prize and give it to winner
1066                     _prize = ((airDropPot_).mul(75)) / 100;
1067                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1068                     
1069                     // adjust airDropPot 
1070                     airDropPot_ = (airDropPot_).sub(_prize);
1071                     
1072                     // let event know a tier 3 prize was won 
1073                     _eventData_.compressedData += 300000000000000000000000000000000;
1074                 // >= 1 && < 10 ether
1075                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1076                     // calculate prize and give it to winner
1077                     _prize = ((airDropPot_).mul(50)) / 100;
1078                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1079                     
1080                     // adjust airDropPot 
1081                     airDropPot_ = (airDropPot_).sub(_prize);
1082                     
1083                     // let event know a tier 2 prize was won 
1084                     _eventData_.compressedData += 200000000000000000000000000000000;
1085                 // >= 0.1 && <= 1 ether
1086                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1087                     // calculate prize and give it to winner
1088                     _prize = ((airDropPot_).mul(25)) / 100;
1089                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1090                     
1091                     // adjust airDropPot 
1092                     airDropPot_ = (airDropPot_).sub(_prize);
1093                     
1094                     // let event know a tier 3 prize was won 
1095                     _eventData_.compressedData += 300000000000000000000000000000000;
1096                 }
1097                 // set airdrop happened bool to true
1098                 _eventData_.compressedData += 10000000000000000000000000000000;
1099                 // let event know how much was won 
1100                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1101                 
1102                 // reset air drop tracker
1103                 airDropTracker_ = 0;
1104             }
1105         }
1106     
1107             // store the air drop tracker number (number of buys since last airdrop)
1108             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1109             
1110             // update player 
1111             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1112             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1113             
1114             // update round
1115             round_[_rID].keys = _keys.add(round_[_rID].keys);
1116             round_[_rID].eth = _eth.add(round_[_rID].eth);
1117             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1118     
1119             // distribute eth
1120             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1121             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1122             
1123             // call end tx function to fire end tx event.
1124             endTx(_pID, _team, _eth, _keys, _eventData_);
1125         }
1126     }
1127 //==============================================================================
1128 //     _ _ | _   | _ _|_ _  _ _  .
1129 //    (_(_||(_|_||(_| | (_)| _\  .
1130 //==============================================================================
1131     /**
1132      * @dev calculates unmasked earnings (just calculates, does not update mask)
1133      * @return earnings in wei format
1134      */
1135     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1136         private
1137         view
1138         returns(uint256)
1139     {
1140         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1141     }
1142     
1143     /** 
1144      * @dev returns the amount of keys you would get given an amount of eth. 
1145      * -functionhash- 0xce89c80c
1146      * @param _rID round ID you want price for
1147      * @param _eth amount of eth sent in 
1148      * @return keys received 
1149      */
1150     function calcKeysReceived(uint256 _rID, uint256 _eth)
1151         public
1152         view
1153         returns(uint256)
1154     {
1155         // grab time
1156         uint256 _now = now;
1157         
1158         // are we in a round?
1159         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1160             return ( (round_[_rID].eth).keysRec(_eth) );
1161         else // rounds over.  need keys for new round
1162             return ( (_eth).keys() );
1163     }
1164     
1165     /** 
1166      * @dev returns current eth price for X keys.  
1167      * -functionhash- 0xcf808000
1168      * @param _keys number of keys desired (in 18 decimal format)
1169      * @return amount of eth needed to send
1170      */
1171     function iWantXKeys(uint256 _keys)
1172         public
1173         view
1174         returns(uint256)
1175     {
1176         // setup local rID
1177         uint256 _rID = rID_;
1178         
1179         // grab time
1180         uint256 _now = now;
1181         
1182         // are we in a round?
1183         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1184             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1185         else // rounds over.  need price for new round
1186             return ( (_keys).eth() );
1187     }
1188 //==============================================================================
1189 //    _|_ _  _ | _  .
1190 //     | (_)(_)|_\  .
1191 //==============================================================================
1192     /**
1193 	 * @dev receives name/player info from names contract 
1194      */
1195     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1196         external
1197     {
1198         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1199         if (pIDxAddr_[_addr] != _pID)
1200             pIDxAddr_[_addr] = _pID;
1201         if (pIDxName_[_name] != _pID)
1202             pIDxName_[_name] = _pID;
1203         if (plyr_[_pID].addr != _addr)
1204             plyr_[_pID].addr = _addr;
1205         if (plyr_[_pID].name != _name)
1206             plyr_[_pID].name = _name;
1207         if (plyr_[_pID].laff != _laff)
1208             plyr_[_pID].laff = _laff;
1209         if (plyrNames_[_pID][_name] == false)
1210             plyrNames_[_pID][_name] = true;
1211     }
1212     
1213     /**
1214      * @dev receives entire player name list 
1215      */
1216     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1217         external
1218     {
1219         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1220         if(plyrNames_[_pID][_name] == false)
1221             plyrNames_[_pID][_name] = true;
1222     }   
1223         
1224     /**
1225      * @dev gets existing or registers new pID.  use this when a player may be new
1226      * @return pID 
1227      */
1228     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1229         private
1230         returns (F3Ddatasets.EventReturns)
1231     {
1232         uint256 _pID = pIDxAddr_[msg.sender];
1233         // if player is new to this version of fomo3d
1234         if (_pID == 0)
1235         {
1236             // grab their player ID, name and last aff ID, from player names contract 
1237             _pID = PlayerBook.getPlayerID(msg.sender);
1238             bytes32 _name = PlayerBook.getPlayerName(_pID);
1239             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1240 
1241             // set up player account 
1242             pIDxAddr_[msg.sender] = _pID;
1243             plyr_[_pID].addr = msg.sender;
1244             
1245             if (_name != "")
1246             {
1247                 pIDxName_[_name] = _pID;
1248                 plyr_[_pID].name = _name;
1249                 plyrNames_[_pID][_name] = true;
1250             }
1251             
1252             if (_laff != 0 && _laff != _pID)
1253                 plyr_[_pID].laff = _laff;
1254             
1255             // set the new player bool to true
1256             _eventData_.compressedData = _eventData_.compressedData + 1;
1257         } 
1258         return (_eventData_);
1259     }
1260     
1261     /**
1262      * @dev checks to make sure user picked a valid team.  if not sets team 
1263      * to default (sneks)
1264      */
1265     function verifyTeam(uint256 _team)
1266         private
1267         pure
1268         returns (uint256)
1269     {
1270         if (_team < 0 || _team > 3)
1271             return(2);
1272         else
1273             return(_team);
1274     }
1275     
1276     /**
1277      * @dev decides if round end needs to be run & new round started.  and if 
1278      * player unmasked earnings from previously played rounds need to be moved.
1279      */
1280     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1281         private
1282         returns (F3Ddatasets.EventReturns)
1283     {
1284         // if player has played a previous round, move their unmasked earnings
1285         // from that round to gen vault.
1286         if (plyr_[_pID].lrnd != 0)
1287             updateGenVault(_pID, plyr_[_pID].lrnd);
1288             
1289         // update player's last round played
1290         plyr_[_pID].lrnd = rID_;
1291             
1292         // set the joined round bool to true
1293         _eventData_.compressedData = _eventData_.compressedData + 10;
1294         
1295         return(_eventData_);
1296     }
1297     
1298     /**
1299      * @dev ends the round. manages paying out winner/splitting up pot
1300      */
1301     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1302         private
1303         returns (F3Ddatasets.EventReturns)
1304     {
1305         // setup local rID
1306         uint256 _rID = rID_;
1307         
1308         // grab our winning player and team id's
1309         uint256 _winPID = round_[_rID].plyr;
1310         uint256 _winTID = round_[_rID].team;
1311         
1312         // grab our pot amount
1313         uint256 _pot = round_[_rID].pot;
1314         
1315         // calculate our winner share, community rewards, gen share, 
1316         // p3d share, and amount reserved for next pot 
1317         uint256 _win = (_pot.mul(58)) / 100;
1318         uint256 _com = (_pot / 50);
1319         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1320         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1321         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1322         
1323         // calculate ppt for round mask
1324         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1325         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1326         if (_dust > 0)
1327         {
1328             _gen = _gen.sub(_dust);
1329             _res = _res.add(_dust);
1330         }
1331         
1332         // pay our winner
1333         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1334         
1335         // community rewards
1336         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1337         // {
1338         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1339         //     // bank migrations by breaking outgoing transactions.
1340         //     // Something we would never do. But that's not the point.
1341         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1342         //     // highest belief that everything we create should be trustless.
1343         //     // Team JUST, The name you shouldn't have to trust.
1344         //     _p3d = _p3d.add(_com);
1345         //     _com = 0;
1346         // }
1347 
1348         _p3d = _p3d.add(_com);
1349         
1350         // distribute gen portion to key holders
1351         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1352         
1353         // send share for p3d to divies
1354         // Divies.deposit.value(_p3d)();
1355         if (_p3d > 0)
1356             reward.transfer(_p3d);
1357             
1358         // prepare event data
1359         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1360         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1361         _eventData_.winnerAddr = plyr_[_winPID].addr;
1362         _eventData_.winnerName = plyr_[_winPID].name;
1363         _eventData_.amountWon = _win;
1364         _eventData_.genAmount = _gen;
1365         _eventData_.P3DAmount = _p3d;
1366         _eventData_.newPot = _res;
1367         
1368         // start next round
1369         rID_++;
1370         _rID++;
1371         round_[_rID].strt = now;
1372         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1373         round_[_rID].pot = _res;
1374         
1375         return(_eventData_);
1376     }
1377     
1378     /**
1379      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1380      */
1381     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1382         private 
1383     {
1384         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1385         if (_earnings > 0)
1386         {
1387             // put in gen vault
1388             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1389             // zero out their earnings by updating mask
1390             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1391         }
1392     }
1393     
1394     /**
1395      * @dev updates round timer based on number of whole keys bought.
1396      */
1397     function updateTimer(uint256 _keys, uint256 _rID)
1398         private
1399     {
1400         // grab time
1401         uint256 _now = now;
1402         
1403         // calculate time based on number of keys bought
1404         uint256 _newTime;
1405         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1406             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1407         else
1408             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1409         
1410         // compare to max and set new end time
1411         if (_newTime < (rndMax_).add(_now))
1412             round_[_rID].end = _newTime;
1413         else
1414             round_[_rID].end = rndMax_.add(_now);
1415     }
1416     
1417     /**
1418      * @dev generates a random number between 0-99 and checks to see if thats
1419      * resulted in an airdrop win
1420      * @return do we have a winner?
1421      */
1422     function airdrop()
1423         private 
1424         view 
1425         returns(bool)
1426     {
1427         uint256 seed = uint256(keccak256(abi.encodePacked(
1428             
1429             (block.timestamp).add
1430             (block.difficulty).add
1431             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1432             (block.gaslimit).add
1433             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1434             (block.number)
1435             
1436         )));
1437         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1438             return(true);
1439         else
1440             return(false);
1441     }
1442 
1443     /**
1444      * @dev distributes eth based on fees to com, aff, and p3d
1445      */
1446     function distributeExternal(uint256, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1447         private
1448         returns(F3Ddatasets.EventReturns)
1449     {
1450         // pay 2% out to community rewards
1451         uint256 _com = _eth / 50;
1452         uint256 _p3d;
1453         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1454         // {
1455         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1456         //     // bank migrations by breaking outgoing transactions.
1457         //     // Something we would never do. But that's not the point.
1458         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1459         //     // highest belief that everything we create should be trustless.
1460         //     // Team JUST, The name you shouldn't have to trust.
1461         //     _p3d = _com;
1462         //     _com = 0;
1463         // }
1464         _p3d = _p3d.add(_com);
1465 
1466         // pay 1% out to FoMo3D short
1467         uint256 _long = _eth / 100;
1468         otherF3D_.transfer(_long);
1469         
1470         // distribute share to affiliate
1471         uint256 _aff;
1472         uint256 _aff2;
1473 
1474         uint256 _affID2 = plyr_[_affID].laff;
1475 
1476         if (_affID2 != 0 && plyr_[_affID2].name != "") {
1477             _aff = _eth.mul(10) / 100;
1478             _aff2 = _eth.mul(5) / 100;
1479             plyr_[_affID2].aff = _aff2.add(plyr_[_affID2].aff);
1480         } else {
1481             _aff = _eth.mul(15) / 100;
1482         }
1483         
1484         // decide what to do with affiliate share of fees
1485         // affiliate must not be self, and must have a name registered
1486         if (_affID != _pID && plyr_[_affID].name != "") {
1487             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1488             // emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1489         } else {
1490             _p3d = _p3d.add(_aff);
1491         }
1492 
1493         // pay out p3d
1494         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1495         if (_p3d > 0)
1496         {
1497             // deposit to divies contract
1498             // Divies.deposit.value(_p3d)();
1499             reward.transfer(_p3d);
1500             // set up event data
1501             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1502         }
1503         
1504         return(_eventData_);
1505     }
1506     
1507     function potSwap()
1508         external
1509         payable
1510     {
1511         // setup local rID
1512         uint256 _rID = rID_ + 1;
1513         
1514         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1515         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1516     }
1517     
1518     /**
1519      * @dev distributes eth based on fees to gen and pot
1520      */
1521     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1522         private
1523         returns(F3Ddatasets.EventReturns)
1524     {
1525         // calculate gen share
1526         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1527         
1528         // toss 1% into airdrop pot 
1529         uint256 _air = (_eth / 100);
1530         airDropPot_ = airDropPot_.add(_air);
1531         
1532         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1533         _eth = _eth.sub(((_eth.mul(19)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1534         
1535         // calculate pot 
1536         uint256 _pot = _eth.sub(_gen);
1537         
1538         // distribute gen share (thats what updateMasks() does) and adjust
1539         // balances for dust.
1540         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1541         if (_dust > 0)
1542             _gen = _gen.sub(_dust);
1543         
1544         // add eth to pot
1545         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1546         
1547         // set up event data
1548         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1549         _eventData_.potAmount = _pot;
1550         
1551         return(_eventData_);
1552     }
1553 
1554     /**
1555      * @dev updates masks for round and player when keys are bought
1556      * @return dust left over 
1557      */
1558     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1559         private
1560         returns(uint256)
1561     {
1562         /* MASKING NOTES
1563             earnings masks are a tricky thing for people to wrap their minds around.
1564             the basic thing to understand here.  is were going to have a global
1565             tracker based on profit per share for each round, that increases in
1566             relevant proportion to the increase in share supply.
1567             
1568             the player will have an additional mask that basically says "based
1569             on the rounds mask, my shares, and how much i've already withdrawn,
1570             how much is still owed to me?"
1571         */
1572         
1573         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1574         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1575         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1576             
1577         // calculate player earning from their own buy (only based on the keys
1578         // they just bought).  & update player earnings mask
1579         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1580         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1581         
1582         // calculate & return dust
1583         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1584     }
1585     
1586     /**
1587      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1588      * @return earnings in wei format
1589      */
1590     function withdrawEarnings(uint256 _pID)
1591         private
1592         returns(uint256)
1593     {
1594         // update gen vault
1595         updateGenVault(_pID, plyr_[_pID].lrnd);
1596         
1597         // from vaults 
1598         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1599         if (_earnings > 0)
1600         {
1601             plyr_[_pID].win = 0;
1602             plyr_[_pID].gen = 0;
1603             plyr_[_pID].aff = 0;
1604         }
1605 
1606         return(_earnings);
1607     }
1608     
1609     /**
1610      * @dev prepares compression data and fires event for buy or reload tx's
1611      */
1612     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1613         private
1614     {
1615         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1616         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1617         
1618         emit F3Devents.onEndTx
1619         (
1620             _eventData_.compressedData,
1621             _eventData_.compressedIDs,
1622             plyr_[_pID].name,
1623             msg.sender,
1624             _eth,
1625             _keys,
1626             _eventData_.winnerAddr,
1627             _eventData_.winnerName,
1628             _eventData_.amountWon,
1629             _eventData_.newPot,
1630             _eventData_.P3DAmount,
1631             _eventData_.genAmount,
1632             _eventData_.potAmount,
1633             airDropPot_
1634         );
1635     }
1636 //==============================================================================
1637 //    (~ _  _    _._|_    .
1638 //    _)(/_(_|_|| | | \/  .
1639 //====================/=========================================================
1640     /** upon contract deploy, it will be deactivated.  this is a one time
1641      * use function that will activate the contract.  we do this so devs 
1642      * have time to set things up on the web end                            **/
1643     bool public activated_ = false;
1644     function activate()
1645         public
1646     {
1647         // only team just can activate 
1648         require(
1649             msg.sender == 0x5F4c768496eC8714F6EbD017979E194bB7D0A973 ||
1650             msg.sender == 0x5e332cA3C520Eb67531A939B3C2Bd0ab0C704D3A ||
1651             msg.sender == 0xa8E88C7fA55a8709bDf38d810769dC68cBdA3eb0 ||
1652             msg.sender == 0x0DE04B2fe678Df1B469B7440Bc1D1d1B1eE88485 ||
1653             msg.sender == 0xD9A85b1eEe7718221713D5e8131d041DC417E901,
1654             "only team just can activate"
1655         );
1656 
1657 		// make sure that its been linked.
1658         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1659         
1660         // can only be ran once
1661         require(activated_ == false, "fomo3d already activated");
1662         
1663         // activate the contract 
1664         activated_ = true;
1665         
1666         // lets start first round
1667 		rID_ = 1;
1668         round_[1].strt = now + rndExtra_ - rndGap_;
1669         round_[1].end = now + rndInit_ + rndExtra_;
1670     }
1671     function setOtherFomo(address _otherF3D)
1672         public
1673     {
1674         // only team just can activate 
1675         require(
1676             msg.sender == 0x5F4c768496eC8714F6EbD017979E194bB7D0A973 ||
1677             msg.sender == 0x5e332cA3C520Eb67531A939B3C2Bd0ab0C704D3A ||
1678             msg.sender == 0xa8E88C7fA55a8709bDf38d810769dC68cBdA3eb0 ||
1679             msg.sender == 0x0DE04B2fe678Df1B469B7440Bc1D1d1B1eE88485 ||
1680             msg.sender == 0xD9A85b1eEe7718221713D5e8131d041DC417E901,
1681             "only team just can activate"
1682         );
1683 
1684         // make sure that it HASNT yet been linked.
1685         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1686         
1687         // set up other fomo3d (fast or long) for pot swap
1688         // otherF3D_ = otherFoMo3D(_otherF3D);
1689         otherF3D_ = _otherF3D;
1690     }
1691 }
1692 
1693 //==============================================================================
1694 //   __|_ _    __|_ _  .
1695 //  _\ | | |_|(_ | _\  .
1696 //==============================================================================
1697 library F3Ddatasets {
1698     //compressedData key
1699     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1700         // 0 - new player (bool)
1701         // 1 - joined round (bool)
1702         // 2 - new  leader (bool)
1703         // 3-5 - air drop tracker (uint 0-999)
1704         // 6-16 - round end time
1705         // 17 - winnerTeam
1706         // 18 - 28 timestamp 
1707         // 29 - team
1708         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1709         // 31 - airdrop happened bool
1710         // 32 - airdrop tier 
1711         // 33 - airdrop amount won
1712     //compressedIDs key
1713     // [77-52][51-26][25-0]
1714         // 0-25 - pID 
1715         // 26-51 - winPID
1716         // 52-77 - rID
1717     struct EventReturns {
1718         uint256 compressedData;
1719         uint256 compressedIDs;
1720         address winnerAddr;         // winner address
1721         bytes32 winnerName;         // winner name
1722         uint256 amountWon;          // amount won
1723         uint256 newPot;             // amount in new pot
1724         uint256 P3DAmount;          // amount distributed to p3d
1725         uint256 genAmount;          // amount distributed to gen
1726         uint256 potAmount;          // amount added to pot
1727     }
1728     struct Player {
1729         address addr;   // player address
1730         bytes32 name;   // player name
1731         uint256 win;    // winnings vault
1732         uint256 gen;    // general vault
1733         uint256 aff;    // affiliate vault
1734         uint256 lrnd;   // last round played
1735         uint256 laff;   // last affiliate id used
1736     }
1737     struct PlayerRounds {
1738         uint256 eth;    // eth player has added to round (used for eth limiter)
1739         uint256 keys;   // keys
1740         uint256 mask;   // player mask 
1741         uint256 ico;    // ICO phase investment
1742     }
1743     struct Round {
1744         uint256 plyr;   // pID of player in lead
1745         uint256 team;   // tID of team in lead
1746         uint256 end;    // time ends/ended
1747         bool ended;     // has round end function been ran
1748         uint256 strt;   // time round started
1749         uint256 keys;   // keys
1750         uint256 eth;    // total eth in
1751         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1752         uint256 mask;   // global mask
1753         uint256 ico;    // total eth sent in during ICO phase
1754         uint256 icoGen; // total eth for gen during ICO phase
1755         uint256 icoAvg; // average key price for ICO phase
1756     }
1757     struct TeamFee {
1758         uint256 gen;    // % of buy in thats paid to key holders of current round
1759         uint256 p3d;    // % of buy in thats paid to p3d holders
1760     }
1761     struct PotSplit {
1762         uint256 gen;    // % of pot thats paid to key holders of current round
1763         uint256 p3d;    // % of pot thats paid to p3d holders
1764     }
1765 }
1766 
1767 //==============================================================================
1768 //  |  _      _ _ | _  .
1769 //  |<(/_\/  (_(_||(_  .
1770 //=======/======================================================================
1771 library F3DKeysCalcLong {
1772     using SafeMath for *;
1773     /**
1774      * @dev calculates number of keys received given X eth 
1775      * @param _curEth current amount of eth in contract 
1776      * @param _newEth eth being spent
1777      * @return amount of ticket purchased
1778      */
1779     function keysRec(uint256 _curEth, uint256 _newEth)
1780         internal
1781         pure
1782         returns (uint256)
1783     {
1784         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1785     }
1786     
1787     /**
1788      * @dev calculates amount of eth received if you sold X keys 
1789      * @param _curKeys current amount of keys that exist 
1790      * @param _sellKeys amount of keys you wish to sell
1791      * @return amount of eth received
1792      */
1793     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1794         internal
1795         pure
1796         returns (uint256)
1797     {
1798         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1799     }
1800 
1801     /**
1802      * @dev calculates how many keys would exist with given an amount of eth
1803      * @param _eth eth "in contract"
1804      * @return number of keys that would exist
1805      */
1806     function keys(uint256 _eth) 
1807         internal
1808         pure
1809         returns(uint256)
1810     {
1811         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1812     }
1813     
1814     /**
1815      * @dev calculates how much eth would be in contract given a number of keys
1816      * @param _keys number of keys "in contract" 
1817      * @return eth that would exists
1818      */
1819     function eth(uint256 _keys) 
1820         internal
1821         pure
1822         returns(uint256)  
1823     {
1824         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1825     }
1826 }
1827 
1828 //==============================================================================
1829 //  . _ _|_ _  _ |` _  _ _  _  .
1830 //  || | | (/_| ~|~(_|(_(/__\  .
1831 //==============================================================================
1832 interface otherFoMo3D {
1833     function potSwap() external payable;
1834 }
1835 
1836 interface F3DexternalSettingsInterface {
1837     function getFastGap() external returns(uint256);
1838     function getLongGap() external returns(uint256);
1839     function getFastExtra() external returns(uint256);
1840     function getLongExtra() external returns(uint256);
1841 }
1842 
1843 interface DiviesInterface {
1844     function deposit() external payable;
1845 }
1846 
1847 interface JIincForwarderInterface {
1848     function deposit() external payable returns(bool);
1849     function status() external view returns(address, address, bool);
1850     function startMigration(address _newCorpBank) external returns(bool);
1851     function cancelMigration() external returns(bool);
1852     function finishMigration() external returns(bool);
1853     function setup(address _firstCorpBank) external;
1854 }
1855 
1856 interface PlayerBookInterface {
1857     function getPlayerID(address _addr) external returns (uint256);
1858     function getPlayerName(uint256 _pID) external view returns (bytes32);
1859     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1860     function getPlayerAddr(uint256 _pID) external view returns (address);
1861     function getNameFee() external view returns (uint256);
1862     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1863     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1864     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1865 }
1866 
1867 /**
1868 * @title -Name Filter- v0.1.9
1869 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1870 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1871 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1872 *                                  _____                      _____
1873 *                                 (, /     /)       /) /)    (, /      /)          /)
1874 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1875 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1876 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1877 *                            (__ /          (_/ (, /                                      /)™ 
1878 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1879 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1880 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1881 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1882 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1883 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1884 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1885 *
1886 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1887 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1888 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1889 */
1890 
1891 library NameFilter {
1892     /**
1893      * @dev filters name strings
1894      * -converts uppercase to lower case.  
1895      * -makes sure it does not start/end with a space
1896      * -makes sure it does not contain multiple spaces in a row
1897      * -cannot be only numbers
1898      * -cannot start with 0x 
1899      * -restricts characters to A-Z, a-z, 0-9, and space.
1900      * @return reprocessed string in bytes32 format
1901      */
1902     function nameFilter(string _input)
1903         internal
1904         pure
1905         returns(bytes32)
1906     {
1907         bytes memory _temp = bytes(_input);
1908         uint256 _length = _temp.length;
1909         
1910         //sorry limited to 32 characters
1911         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1912         // make sure it doesnt start with or end with space
1913         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1914         // make sure first two characters are not 0x
1915         if (_temp[0] == 0x30)
1916         {
1917             require(_temp[1] != 0x78, "string cannot start with 0x");
1918             require(_temp[1] != 0x58, "string cannot start with 0X");
1919         }
1920         
1921         // create a bool to track if we have a non number character
1922         bool _hasNonNumber;
1923         
1924         // convert & check
1925         for (uint256 i = 0; i < _length; i++)
1926         {
1927             // if its uppercase A-Z
1928             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1929             {
1930                 // convert to lower case a-z
1931                 _temp[i] = byte(uint(_temp[i]) + 32);
1932                 
1933                 // we have a non number
1934                 if (_hasNonNumber == false)
1935                     _hasNonNumber = true;
1936             } else {
1937                 require
1938                 (
1939                     // require character is a space
1940                     _temp[i] == 0x20 || 
1941                     // OR lowercase a-z
1942                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1943                     // or 0-9
1944                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1945                     "string contains invalid characters"
1946                 );
1947                 // make sure theres not 2x spaces in a row
1948                 if (_temp[i] == 0x20)
1949                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1950                 
1951                 // see if we have a character other than a number
1952                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1953                     _hasNonNumber = true;    
1954             }
1955         }
1956         
1957         require(_hasNonNumber == true, "string cannot be only numbers");
1958         
1959         bytes32 _ret;
1960         assembly {
1961             _ret := mload(add(_temp, 32))
1962         }
1963         return (_ret);
1964     }
1965 }
1966 
1967 /**
1968  * @title SafeMath v0.1.9
1969  * @dev Math operations with safety checks that throw on error
1970  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1971  * - added sqrt
1972  * - added sq
1973  * - added pwr 
1974  * - changed asserts to requires with error log outputs
1975  * - removed div, its useless
1976  */
1977 library SafeMath {
1978     
1979     /**
1980     * @dev Multiplies two numbers, throws on overflow.
1981     */
1982     function mul(uint256 a, uint256 b) 
1983         internal 
1984         pure 
1985         returns (uint256 c) 
1986     {
1987         if (a == 0) {
1988             return 0;
1989         }
1990         c = a * b;
1991         require(c / a == b, "SafeMath mul failed");
1992         return c;
1993     }
1994 
1995     /**
1996     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1997     */
1998     function sub(uint256 a, uint256 b)
1999         internal
2000         pure
2001         returns (uint256) 
2002     {
2003         require(b <= a, "SafeMath sub failed");
2004         return a - b;
2005     }
2006 
2007     /**
2008     * @dev Adds two numbers, throws on overflow.
2009     */
2010     function add(uint256 a, uint256 b)
2011         internal
2012         pure
2013         returns (uint256 c) 
2014     {
2015         c = a + b;
2016         require(c >= a, "SafeMath add failed");
2017         return c;
2018     }
2019     
2020     /**
2021      * @dev gives square root of given x.
2022      */
2023     function sqrt(uint256 x)
2024         internal
2025         pure
2026         returns (uint256 y) 
2027     {
2028         uint256 z = ((add(x,1)) / 2);
2029         y = x;
2030         while (z < y) 
2031         {
2032             y = z;
2033             z = ((add((x / z),z)) / 2);
2034         }
2035     }
2036     
2037     /**
2038      * @dev gives square. multiplies x by x
2039      */
2040     function sq(uint256 x)
2041         internal
2042         pure
2043         returns (uint256)
2044     {
2045         return (mul(x,x));
2046     }
2047     
2048     /**
2049      * @dev x to the power of y 
2050      */
2051     function pwr(uint256 x, uint256 y)
2052         internal 
2053         pure 
2054         returns (uint256)
2055     {
2056         if (x==0)
2057             return (0);
2058         else if (y==0)
2059             return (1);
2060         else 
2061         {
2062             uint256 z = x;
2063             for (uint256 i=1; i < y; i++)
2064                 z = mul(z,x);
2065             return (z);
2066         }
2067     }
2068 }