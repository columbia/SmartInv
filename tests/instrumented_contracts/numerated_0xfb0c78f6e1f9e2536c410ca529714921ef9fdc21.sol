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
94     // fired whenever theres a withdraw
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
177 interface JIincInterfaceForForwarder {
178     function deposit(address _addr) external payable returns (bool);
179 }
180 contract modularLong is F3Devents {}
181 
182 contract FoMo3Dlong is modularLong {
183     using SafeMath for *;
184     using NameFilter for string;
185     using F3DKeysCalcLong for uint256;
186     
187     otherFoMo3D private otherF3D_;
188     DiviesInterface constant private Divies = DiviesInterface(0xb804dc1719852c036724944c7bbf7cb261609f88);
189     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xe5f55d966ef9b4d541b286dd5237209d7de9959f);
190     JIincForwarderInterface constant private otherF3DInc=JIincForwarderInterface(0x489da84a400bb7852de0ed986b733e771aebf648);
191     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x58216fec6402978f53aab6b475fd68fd44cff8c6);
192     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0xdad91de8238386cacc3a797083aa14ffc855d2e5);
193 
194 //==============================================================================
195 //     _ _  _  |`. _     _ _ |_ | _  _  .
196 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
197 //=================_|===========================================================
198     string constant public name = "FoMo3D Long Official";
199     string constant public symbol = "F3D";
200     uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO 
201     uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
202     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
203     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
204     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
205    
206 //==============================================================================
207 //     _| _ _|_ _    _ _ _|_    _   .
208 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
209 //=============================|================================================
210     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
211     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
212     uint256 public rID_;    // round id number / total rounds that have happened
213 //****************
214 // PLAYER DATA 
215 //****************
216     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
217     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
218     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
219     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
220     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
221 //****************
222 // ROUND DATA 
223 //****************
224     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
225     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
226 //****************
227 // TEAM FEE DATA 
228 //****************
229     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
230     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
231    
232 //==============================================================================
233 //     _ _  _  __|_ _    __|_ _  _  .
234 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
235 //==============================================================================
236     constructor()
237         public
238     {
239         // Team allocation structures
240         // 0 = whales
241         // 1 = bears
242         // 2 = sneks
243         // 3 = bulls
244 
245         // Team allocation percentages
246         // (F3D, P3D) + (Pot , Referrals, Community)
247             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
248         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
249         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
250         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
251         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
252         
253         // how to split up the final pot based on which team was picked
254         // (F3D, P3D)
255         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
256         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
257         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
258         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
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
594             // get their earnings
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
782                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
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
874      * @return player round eth
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
931                 round_[_rID].ended = true;
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
1019        
1020         if (plyrRnds_[_pID][_rID].keys == 0)
1021             _eventData_ = managePlayer(_pID, _eventData_);
1022         
1023         // early round eth limiter 
1024         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1025         {
1026             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1027             uint256 _refund = _eth.sub(_availableLimit);
1028             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1029             _eth = _availableLimit;
1030         }
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
1057            
1058             airDropTracker_++;
1059             if (airdrop() == true)
1060             {
1061                 // gib muni
1062                 uint256 _prize;
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
1074                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1075                     // calculate prize and give it to winner
1076                     _prize = ((airDropPot_).mul(50)) / 100;
1077                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1078                     
1079                     // adjust airDropPot 
1080                     airDropPot_ = (airDropPot_).sub(_prize);
1081                     
1082                     // let event know a tier 2 prize was won 
1083                     _eventData_.compressedData += 200000000000000000000000000000000;
1084                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1085                     // calculate prize and give it to winner
1086                     _prize = ((airDropPot_).mul(25)) / 100;
1087                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1088                     
1089                     // adjust airDropPot 
1090                     airDropPot_ = (airDropPot_).sub(_prize);
1091                     
1092                     // let event know a tier 3 prize was won 
1093                     _eventData_.compressedData += 300000000000000000000000000000000;
1094                 }
1095                 // set airdrop happened bool to true
1096                 _eventData_.compressedData += 10000000000000000000000000000000;
1097                 // let event know how much was won 
1098                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1099                 
1100                 // reset air drop tracker
1101                 airDropTracker_ = 0;
1102             }
1103         }
1104     
1105             // store the air drop tracker number (number of buys since last airdrop)
1106             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1107             
1108             // update player 
1109             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1110             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1111           
1112             // update round
1113             round_[_rID].keys = _keys.add(round_[_rID].keys);
1114             round_[_rID].eth = _eth.add(round_[_rID].eth);
1115             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1116             // distribute eth
1117             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1118             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1119    
1120             // call end tx function to fire end tx event.
1121             endTx(_pID, _team, _eth, _keys, _eventData_);
1122         }
1123     }
1124 //==============================================================================
1125 //     _ _ | _   | _ _|_ _  _ _  .
1126 //    (_(_||(_|_||(_| | (_)| _\  .
1127 //==============================================================================
1128     /**
1129      * @dev calculates unmasked earnings (just calculates, does not update mask)
1130      * @return earnings in wei format
1131      */
1132     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1133         private
1134         view
1135         returns(uint256)
1136     {
1137         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1138     }
1139     
1140     /** 
1141      * @dev returns the amount of keys you would get given an amount of eth. 
1142      * -functionhash- 0xce89c80c
1143      * @param _rID round ID you want price for
1144      * @param _eth amount of eth sent in 
1145      * @return keys received 
1146      */
1147     function calcKeysReceived(uint256 _rID, uint256 _eth)
1148         public
1149         view
1150         returns(uint256)
1151     {
1152         // grab time
1153         uint256 _now = now;
1154         
1155         // are we in a round?
1156         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1157             return ( (round_[_rID].eth).keysRec(_eth) );
1158         else // rounds over.  need keys for new round
1159             return ( (_eth).keys() );
1160     }
1161     
1162     /** 
1163      * @dev returns current eth price for X keys.  
1164      * -functionhash- 0xcf808000
1165      * @param _keys number of keys desired (in 18 decimal format)
1166      * @return amount of eth needed to send
1167      */
1168     function iWantXKeys(uint256 _keys)
1169         public
1170         view
1171         returns(uint256)
1172     {
1173         // setup local rID
1174         uint256 _rID = rID_;
1175         
1176         // grab time
1177         uint256 _now = now;
1178         
1179         // are we in a round?
1180         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1181             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1182         else // rounds over.  need price for new round
1183             return ( (_keys).eth() );
1184     }
1185 //==============================================================================
1186 //    _|_ _  _ | _  .
1187 //     | (_)(_)|_\  .
1188 //==============================================================================
1189     /**
1190      * @dev receives name/player info from names contract 
1191      */
1192     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1193         external
1194     {
1195         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1196         if (pIDxAddr_[_addr] != _pID)
1197             pIDxAddr_[_addr] = _pID;
1198         if (pIDxName_[_name] != _pID)
1199             pIDxName_[_name] = _pID;
1200         if (plyr_[_pID].addr != _addr)
1201             plyr_[_pID].addr = _addr;
1202         if (plyr_[_pID].name != _name)
1203             plyr_[_pID].name = _name;
1204         if (plyr_[_pID].laff != _laff)
1205             plyr_[_pID].laff = _laff;
1206         if (plyrNames_[_pID][_name] == false)
1207             plyrNames_[_pID][_name] = true;
1208     }
1209     
1210     /**
1211      * @dev receives entire player name list 
1212      */
1213     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1214         external
1215     {
1216         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1217         if(plyrNames_[_pID][_name] == false)
1218             plyrNames_[_pID][_name] = true;
1219     }   
1220         
1221     /**
1222      * @dev gets existing or registers new pID.  use this when a player may be new
1223      * @return pID 
1224      */
1225     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1226         private
1227         returns (F3Ddatasets.EventReturns)
1228     {
1229         uint256 _pID = pIDxAddr_[msg.sender];
1230         // if player is new to this version of fomo3d
1231         if (_pID == 0)
1232         {
1233             // grab their player ID, name and last aff ID, from player names contract 
1234             _pID = PlayerBook.getPlayerID(msg.sender);
1235             bytes32 _name = PlayerBook.getPlayerName(_pID);
1236             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1237             
1238             // set up player account 
1239             pIDxAddr_[msg.sender] = _pID;
1240             plyr_[_pID].addr = msg.sender;
1241             
1242             if (_name != "")
1243             {
1244                 pIDxName_[_name] = _pID;
1245                 plyr_[_pID].name = _name;
1246                 plyrNames_[_pID][_name] = true;
1247             }
1248             
1249             if (_laff != 0 && _laff != _pID)
1250                 plyr_[_pID].laff = _laff;
1251             
1252             // set the new player bool to true
1253             _eventData_.compressedData = _eventData_.compressedData + 1;
1254         } 
1255         return (_eventData_);
1256     }
1257     
1258     /**
1259      * @dev checks to make sure user picked a valid team.  if not sets team 
1260      * to default (sneks)
1261      */
1262     function verifyTeam(uint256 _team)
1263         private
1264         pure
1265         returns (uint256)
1266     {
1267         if (_team < 0 || _team > 3)
1268             return(2);
1269         else
1270             return(_team);
1271     }
1272     
1273     /**
1274      * @dev decides if round end needs to be run & new round started.  and if 
1275      * player unmasked earnings from previously played rounds need to be moved.
1276      */
1277     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1278         private
1279         returns (F3Ddatasets.EventReturns)
1280     {
1281         // if player has played a previous round, move their unmasked earnings
1282         // from that round to gen vault.
1283         if (plyr_[_pID].lrnd != 0)
1284             updateGenVault(_pID, plyr_[_pID].lrnd);
1285             
1286         // update player's last round played
1287         plyr_[_pID].lrnd = rID_;
1288             
1289         // set the joined round bool to true
1290         _eventData_.compressedData = _eventData_.compressedData + 10;
1291         
1292         return(_eventData_);
1293     }
1294     
1295     /**
1296      * @dev ends the round. manages paying out winner/splitting up pot
1297      */
1298     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1299         private
1300         returns (F3Ddatasets.EventReturns)
1301     {
1302         // setup local rID
1303         uint256 _rID = rID_;
1304         
1305         // grab our winning player and team id's
1306         uint256 _winPID = round_[_rID].plyr;
1307         uint256 _winTID = round_[_rID].team;
1308         
1309         // grab our pot amount
1310         uint256 _pot = round_[_rID].pot;
1311         
1312         // calculate our winner share, community rewards, gen share, 
1313         // p3d share, and amount reserved for next pot 
1314         uint256 _win = (_pot.mul(48)) / 100;
1315         uint256 _com = (_pot / 50);
1316         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1317         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1318         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1319         
1320         // calculate ppt for round mask
1321         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1322         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1323         if (_dust > 0)
1324         {
1325             _gen = _gen.sub(_dust);
1326             _res = _res.add(_dust);
1327         }
1328         
1329         // pay our winner
1330         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1331         
1332         // community rewards
1333         
1334         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1335         {
1336             // This ensures Team Just cannot influence the outcome of FoMo3D with
1337             // bank migrations by breaking outgoing transactions.
1338             // Something we would never do. But that's not the point.
1339             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1340             // highest belief that everything we create should be trustless.
1341             // Team JUST, The name you shouldn't have to trust.
1342             _p3d = _p3d.add(_com);
1343             _com = 0;
1344         }       
1345         
1346         // distribute gen portion to key holders
1347         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1348         
1349         // send share for p3d to divies
1350         if (_p3d > 0)
1351             Divies.deposit.value(_p3d)();
1352             
1353         // prepare event data
1354         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1355         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1356         _eventData_.winnerAddr = plyr_[_winPID].addr;
1357         _eventData_.winnerName = plyr_[_winPID].name;
1358         _eventData_.amountWon = _win;
1359         _eventData_.genAmount = _gen;
1360         _eventData_.P3DAmount = _p3d;
1361         _eventData_.newPot = _res;
1362         
1363         // start next round
1364         rID_++;
1365         _rID++;
1366         round_[_rID].strt = now;
1367         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1368         round_[_rID].pot = _res;
1369         
1370         return(_eventData_);
1371     }
1372     
1373     /**
1374      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1375      */
1376     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1377         private 
1378     {
1379         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1380         if (_earnings > 0)
1381         {
1382             // put in gen vault
1383             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1384             // zero out their earnings by updating mask
1385             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1386         }
1387     }
1388     
1389     /**
1390      * @dev updates round timer based on number of whole keys bought.
1391      */
1392     function updateTimer(uint256 _keys, uint256 _rID)
1393         private
1394     {
1395         // grab time
1396         uint256 _now = now;
1397         
1398         // calculate time based on number of keys bought
1399         uint256 _newTime;
1400         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1401             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1402         else
1403             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1404         
1405         // compare to max and set new end time
1406         if (_newTime < (rndMax_).add(_now))
1407             round_[_rID].end = _newTime;
1408         else
1409             round_[_rID].end = rndMax_.add(_now);
1410     }
1411     
1412     /**
1413      * @dev generates a random number between 0-99 and checks to see if thats
1414      * resulted in an airdrop win
1415      * @return do we have a winner?
1416      */
1417     function airdrop()
1418         private 
1419         view 
1420         returns(bool)
1421     {
1422         uint256 seed = uint256(keccak256(abi.encodePacked(
1423             
1424             (block.timestamp).add
1425             (block.difficulty).add
1426             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1427             (block.gaslimit).add
1428             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1429             (block.number)
1430             
1431         )));
1432         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1433             return(true);
1434         else
1435             return(false);
1436     }
1437 
1438     /**
1439      * @dev distributes eth based on fees to com, aff, and p3d
1440      */
1441     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1442         private
1443         returns(F3Ddatasets.EventReturns)
1444     {
1445         // pay 2% out to community rewards
1446         uint256 _com = _eth / 50;
1447         uint256 _p3d;
1448        
1449         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1450         {
1451             // This ensures Team Just cannot influence the outcome of FoMo3D with
1452             // bank migrations by breaking outgoing transactions.
1453             // Something we would never do. But that's not the point.
1454             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1455             // highest belief that everything we create should be trustless.
1456             // Team JUST, The name you shouldn't have to trust.
1457             _p3d = _com;
1458             _com = 0;
1459         }
1460       
1461         
1462         // pay 1% out to FoMo3D short
1463         uint256 _long = _eth / 100;
1464         //otherF3D_.potSwap.value(_long)();
1465         address(otherF3DInc).call.value(_long)(bytes4(keccak256("deposit()")));
1466 
1467         // distribute share to affiliate
1468         uint256 _aff = _eth / 10;
1469         
1470         // decide what to do with affiliate share of fees
1471         // affiliate must not be self, and must have a name registered
1472         if (_affID != _pID && plyr_[_affID].name != '') {
1473             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1474             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1475         } else {
1476             _p3d = _aff;
1477         }
1478         
1479         // pay out p3d
1480         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1481         if (_p3d > 0)
1482         {
1483             // deposit to divies contract
1484             Divies.deposit.value(_p3d)();
1485             
1486             // set up event data
1487             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1488         }
1489         
1490         return(_eventData_);
1491     }
1492     
1493     function potSwap()
1494         external
1495         payable
1496     {
1497         // setup local rID
1498         uint256 _rID = rID_ + 1;
1499         
1500         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1501         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1502     }
1503     
1504     /**
1505      * @dev distributes eth based on fees to gen and pot
1506      */
1507     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1508         private
1509         returns(F3Ddatasets.EventReturns)
1510     {
1511         // calculate gen share
1512         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1513         
1514         // toss 1% into airdrop pot 
1515         uint256 _air = (_eth / 100);
1516         airDropPot_ = airDropPot_.add(_air);
1517         
1518         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1519         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1520         
1521         // calculate pot 
1522         uint256 _pot = _eth.sub(_gen);
1523         
1524         // distribute gen share (thats what updateMasks() does) and adjust
1525         // balances for dust.
1526         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1527         if (_dust > 0)
1528             _gen = _gen.sub(_dust);
1529         
1530         // add eth to pot
1531         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1532         
1533         // set up event data
1534         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1535         _eventData_.potAmount = _pot;
1536         
1537         return(_eventData_);
1538     }
1539 
1540     /**
1541      * @dev updates masks for round and player when keys are bought
1542      * @return dust left over 
1543      */
1544     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1545         private
1546         returns(uint256)
1547     {
1548         /* MASKING NOTES
1549             earnings masks are a tricky thing for people to wrap their minds around.
1550             the basic thing to understand here.  is were going to have a global
1551             tracker based on profit per share for each round, that increases in
1552             relevant proportion to the increase in share supply.
1553             
1554             the player will have an additional mask that basically says "based
1555             on the rounds mask, my shares, and how much i've already withdrawn,
1556             how much is still owed to me?"
1557         */
1558         
1559         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1560         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1561         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1562             
1563         // calculate player earning from their own buy (only based on the keys
1564         // they just bought).  & update player earnings mask
1565         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1566         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1567         
1568         // calculate & return dust
1569         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1570     }
1571     
1572     /**
1573      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1574      * @return earnings in wei format
1575      */
1576     function withdrawEarnings(uint256 _pID)
1577         private
1578         returns(uint256)
1579     {
1580         // update gen vault
1581         updateGenVault(_pID, plyr_[_pID].lrnd);
1582         
1583         // from vaults 
1584         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1585         if (_earnings > 0)
1586         {
1587             plyr_[_pID].win = 0;
1588             plyr_[_pID].gen = 0;
1589             plyr_[_pID].aff = 0;
1590         }
1591 
1592         return(_earnings);
1593     }
1594     
1595     /**
1596      * @dev prepares compression data and fires event for buy or reload tx's
1597      */
1598     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1599         private
1600     {
1601         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1602         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1603        
1604         emit F3Devents.onEndTx
1605         (
1606             _eventData_.compressedData,
1607             _eventData_.compressedIDs,
1608             plyr_[_pID].name,
1609             msg.sender,
1610             _eth,
1611             _keys,
1612             _eventData_.winnerAddr,
1613             _eventData_.winnerName,
1614             _eventData_.amountWon,
1615             _eventData_.newPot,
1616             _eventData_.P3DAmount,
1617             _eventData_.genAmount,
1618             _eventData_.potAmount,
1619             airDropPot_
1620         );
1621        
1622     }
1623 //==============================================================================
1624 //    (~ _  _    _._|_    .
1625 //    _)(/_(_|_|| | | \/  .
1626 //====================/=========================================================
1627     /** upon contract deploy, it will be deactivated.  this is a one time
1628      * use function that will activate the contract.  we do this so devs 
1629      * have time to set things up on the web end                            **/
1630     bool public activated_ = false;
1631     function activate()
1632         public
1633     {
1634         // only team just can activate 
1635         require(msg.sender == 0x24e0162606d558ac113722adc6597b434089adb7,"only team just can activate");
1636 
1637         // make sure that its been linked.
1638         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1639         
1640         // can only be ran once
1641         require(activated_ == false, "fomo3d already activated");
1642         
1643         // activate the contract 
1644         activated_ = true;
1645         
1646         // lets start first round
1647         rID_ = 1;
1648         round_[1].strt = now + rndExtra_ - rndGap_;
1649         round_[1].end = now + rndInit_ + rndExtra_;
1650     }
1651     /*
1652     function setOtherFomo(address _otherF3D)
1653         public
1654     {
1655         // only team just can activate 
1656         require(           
1657             msg.sender == 0x24e0162606d558ac113722adc6597b434089adb7,
1658             "only team just can activate"
1659         );
1660 
1661         // make sure that it HASNT yet been linked.
1662         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1663         
1664         // set up other fomo3d (fast or long) for pot swap
1665         otherF3D_ = otherFoMo3D(_otherF3D);
1666     }
1667     */
1668 }
1669 
1670 //==============================================================================
1671 //   __|_ _    __|_ _  .
1672 //  _\ | | |_|(_ | _\  .
1673 //==============================================================================
1674 library F3Ddatasets {
1675     //compressedData key
1676     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1677         // 0 - new player (bool)
1678         // 1 - joined round (bool)
1679         // 2 - new  leader (bool)
1680         // 3-5 - air drop tracker (uint 0-999)
1681         // 6-16 - round end time
1682         // 17 - winnerTeam
1683         // 18 - 28 timestamp 
1684         // 29 - team
1685         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1686         // 31 - airdrop happened bool
1687         // 32 - airdrop tier 
1688         // 33 - airdrop amount won
1689     //compressedIDs key
1690     // [77-52][51-26][25-0]
1691         // 0-25 - pID 
1692         // 26-51 - winPID
1693         // 52-77 - rID
1694     struct EventReturns {
1695         uint256 compressedData;
1696         uint256 compressedIDs;
1697         address winnerAddr;         // winner address
1698         bytes32 winnerName;         // winner name
1699         uint256 amountWon;          // amount won
1700         uint256 newPot;             // amount in new pot
1701         uint256 P3DAmount;          // amount distributed to p3d
1702         uint256 genAmount;          // amount distributed to gen
1703         uint256 potAmount;          // amount added to pot
1704     }
1705     struct Player {
1706         address addr;   // player address
1707         bytes32 name;   // player name
1708         uint256 win;    // winnings vault
1709         uint256 gen;    // general vault
1710         uint256 aff;    // affiliate vault
1711         uint256 lrnd;   // last round played
1712         uint256 laff;   // last affiliate id used
1713     }
1714     struct PlayerRounds {
1715         uint256 eth;    // eth player has added to round (used for eth limiter)
1716         uint256 keys;   // keys
1717         uint256 mask;   // player mask 
1718         uint256 ico;    // ICO phase investment
1719     }
1720     struct Round {
1721         uint256 plyr;   // pID of player in lead
1722         uint256 team;   // tID of team in lead
1723         uint256 end;    // time ends/ended
1724         bool ended;     // has round end function been ran
1725         uint256 strt;   // time round started
1726         uint256 keys;   // keys
1727         uint256 eth;    // total eth in
1728         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1729         uint256 mask;   // global mask
1730         uint256 ico;    // total eth sent in during ICO phase
1731         uint256 icoGen; // total eth for gen during ICO phase
1732         uint256 icoAvg; // average key price for ICO phase
1733     }
1734     struct TeamFee {
1735         uint256 gen;    // % of buy in thats paid to key holders of current round
1736         uint256 p3d;    // % of buy in thats paid to p3d holders
1737     }
1738     struct PotSplit {
1739         uint256 gen;    // % of pot thats paid to key holders of current round
1740         uint256 p3d;    // % of pot thats paid to p3d holders
1741     }
1742 }
1743 
1744 //==============================================================================
1745 //  |  _      _ _ | _  .
1746 //  |<(/_\/  (_(_||(_  .
1747 //=======/======================================================================
1748 library F3DKeysCalcLong {
1749     using SafeMath for *;
1750     /**
1751      * @dev calculates number of keys received given X eth 
1752      * @param _curEth current amount of eth in contract 
1753      * @param _newEth eth being spent
1754      * @return amount of ticket purchased
1755      */
1756     function keysRec(uint256 _curEth, uint256 _newEth)
1757         internal
1758         pure
1759         returns (uint256)
1760     {
1761         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1762     }
1763     
1764     /**
1765      * @dev calculates amount of eth received if you sold X keys 
1766      * @param _curKeys current amount of keys that exist 
1767      * @param _sellKeys amount of keys you wish to sell
1768      * @return amount of eth received
1769      */
1770     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1771         internal
1772         pure
1773         returns (uint256)
1774     {
1775         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1776     }
1777 
1778     /**
1779      * @dev calculates how many keys would exist with given an amount of eth
1780      * @param _eth eth "in contract"
1781      * @return number of keys that would exist
1782      */
1783     function keys(uint256 _eth) 
1784         internal
1785         pure
1786         returns(uint256)
1787     {
1788         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1789     }
1790     
1791     /**
1792      * @dev calculates how much eth would be in contract given a number of keys
1793      * @param _keys number of keys "in contract" 
1794      * @return eth that would exists
1795      */
1796     function eth(uint256 _keys) 
1797         internal
1798         pure
1799         returns(uint256)  
1800     {
1801         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1802     }
1803 }
1804 
1805 //==============================================================================
1806 //  . _ _|_ _  _ |` _  _ _  _  .
1807 //  || | | (/_| ~|~(_|(_(/__\  .
1808 //==============================================================================
1809 interface otherFoMo3D {
1810     function potSwap() external payable;
1811 }
1812 
1813 interface F3DexternalSettingsInterface {
1814     function getFastGap() external returns(uint256);
1815     function getLongGap() external returns(uint256);
1816     function getFastExtra() external returns(uint256);
1817     function getLongExtra() external returns(uint256);
1818 }
1819 
1820 interface DiviesInterface {
1821     function deposit() external payable;
1822 }
1823 
1824 interface JIincForwarderInterface {
1825     function deposit() external payable returns(bool);
1826     function status() external view returns(address, address, bool);
1827     function startMigration(address _newCorpBank) external returns(bool);
1828     function cancelMigration() external returns(bool);
1829     function finishMigration() external returns(bool);
1830     function setup(address _firstCorpBank) external;
1831 }
1832 
1833 interface PlayerBookInterface {
1834     function getPlayerID(address _addr) external returns (uint256);
1835     function getPlayerName(uint256 _pID) external view returns (bytes32);
1836     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1837     function getPlayerAddr(uint256 _pID) external view returns (address);
1838     function getNameFee() external view returns (uint256);
1839     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1840     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1841     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1842 }
1843 
1844 /**
1845 * @title -Name Filter- v0.1.9
1846 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1847 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1848 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1849 *                                  _____                      _____
1850 *                                 (, /     /)       /) /)    (, /      /)          /)
1851 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1852 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1853 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1854 *                            (__ /          (_/ (, /                                      /)™ 
1855 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1856 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1857 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1858 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1859 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1860 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1861 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1862 *
1863 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1864 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1865 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1866 */
1867 
1868 library NameFilter {
1869     /**
1870      * @dev filters name strings
1871      * -converts uppercase to lower case.  
1872      * -makes sure it does not start/end with a space
1873      * -makes sure it does not contain multiple spaces in a row
1874      * -cannot be only numbers
1875      * -cannot start with 0x 
1876      * -restricts characters to A-Z, a-z, 0-9, and space.
1877      * @return reprocessed string in bytes32 format
1878      */
1879     function nameFilter(string _input)
1880         internal
1881         pure
1882         returns(bytes32)
1883     {
1884         bytes memory _temp = bytes(_input);
1885         uint256 _length = _temp.length;
1886         
1887         //sorry limited to 32 characters
1888         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1889         // make sure it doesnt start with or end with space
1890         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1891         // make sure first two characters are not 0x
1892         if (_temp[0] == 0x30)
1893         {
1894             require(_temp[1] != 0x78, "string cannot start with 0x");
1895             require(_temp[1] != 0x58, "string cannot start with 0X");
1896         }
1897         
1898         // create a bool to track if we have a non number character
1899         bool _hasNonNumber;
1900         
1901         // convert & check
1902         for (uint256 i = 0; i < _length; i++)
1903         {
1904             // if its uppercase A-Z
1905             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1906             {
1907                 // convert to lower case a-z
1908                 _temp[i] = byte(uint(_temp[i]) + 32);
1909                 
1910                 // we have a non number
1911                 if (_hasNonNumber == false)
1912                     _hasNonNumber = true;
1913             } else {
1914                 require
1915                 (
1916                     // require character is a space
1917                     _temp[i] == 0x20 || 
1918                     // OR lowercase a-z
1919                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1920                     // or 0-9
1921                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1922                     "string contains invalid characters"
1923                 );
1924                 // make sure theres not 2x spaces in a row
1925                 if (_temp[i] == 0x20)
1926                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1927                 
1928                 // see if we have a character other than a number
1929                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1930                     _hasNonNumber = true;    
1931             }
1932         }
1933         
1934         require(_hasNonNumber == true, "string cannot be only numbers");
1935         
1936         bytes32 _ret;
1937         assembly {
1938             _ret := mload(add(_temp, 32))
1939         }
1940         return (_ret);
1941     }
1942 }
1943 
1944 /**
1945  * @title SafeMath v0.1.9
1946  * @dev Math operations with safety checks that throw on error
1947  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1948  * - added sqrt
1949  * - added sq
1950  * - added pwr 
1951  * - changed asserts to requires with error log outputs
1952  * - removed div, its useless
1953  */
1954 library SafeMath {
1955     
1956     /**
1957     * @dev Multiplies two numbers, throws on overflow.
1958     */
1959     function mul(uint256 a, uint256 b) 
1960         internal 
1961         pure 
1962         returns (uint256 c) 
1963     {
1964         if (a == 0) {
1965             return 0;
1966         }
1967         c = a * b;
1968         require(c / a == b, "SafeMath mul failed");
1969         return c;
1970     }
1971 
1972     /**
1973     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1974     */
1975     function sub(uint256 a, uint256 b)
1976         internal
1977         pure
1978         returns (uint256) 
1979     {
1980         require(b <= a, "SafeMath sub failed");
1981         return a - b;
1982     }
1983 
1984     /**
1985     * @dev Adds two numbers, throws on overflow.
1986     */
1987     function add(uint256 a, uint256 b)
1988         internal
1989         pure
1990         returns (uint256 c) 
1991     {
1992         c = a + b;
1993         require(c >= a, "SafeMath add failed");
1994         return c;
1995     }
1996     
1997     /**
1998      * @dev gives square root of given x.
1999      */
2000     function sqrt(uint256 x)
2001         internal
2002         pure
2003         returns (uint256 y) 
2004     {
2005         uint256 z = ((add(x,1)) / 2);
2006         y = x;
2007         while (z < y) 
2008         {
2009             y = z;
2010             z = ((add((x / z),z)) / 2);
2011         }
2012     }
2013     
2014     /**
2015      * @dev gives square. multiplies x by x
2016      */
2017     function sq(uint256 x)
2018         internal
2019         pure
2020         returns (uint256)
2021     {
2022         return (mul(x,x));
2023     }
2024     
2025     /**
2026      * @dev x to the power of y 
2027      */
2028     function pwr(uint256 x, uint256 y)
2029         internal 
2030         pure 
2031         returns (uint256)
2032     {
2033         if (x==0)
2034             return (0);
2035         else if (y==0)
2036             return (1);
2037         else 
2038         {
2039             uint256 z = x;
2040             for (uint256 i=1; i < y; i++)
2041                 z = mul(z,x);
2042             return (z);
2043         }
2044     }
2045 }