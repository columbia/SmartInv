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
186     address private otherF3D_;
187     DiviesInterface constant private Divies = DiviesInterface(0xeff0ebb99f18eb01f5883acad9662705a6d24ba8);
188     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x1193baf34c32b4c3ce799afeca9fd50198b2b9fd);
189     address reward = 0xeff0ebb99f18eb01f5883acad9662705a6d24ba8;
190     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x66a3ab31055fb0c32e8178914e106e0fff5d0460);
191     // F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
192 
193 //==============================================================================
194 //     _ _  _  |`. _     _ _ |_ | _  _  .
195 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
196 //=================_|===========================================================
197     string constant public name = "FoMo3D Long Official";
198     string constant public symbol = "F3D";
199 	uint256 private rndExtra_ = 30;     // length of the very first ICO 
200     uint256 private rndGap_ = 30;         // length of ICO phase, set to 1 year for EOS.
201     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
202     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
203     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
204 //==============================================================================
205 //     _| _ _|_ _    _ _ _|_    _   .
206 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
207 //=============================|================================================
208 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
209     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
210     uint256 public rID_;    // round id number / total rounds that have happened
211 //****************
212 // PLAYER DATA 
213 //****************
214     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
215     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
216     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
217     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
218     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
219 //****************
220 // ROUND DATA 
221 //****************
222     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
223     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
224 //****************
225 // TEAM FEE DATA 
226 //****************
227     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
228     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
229 //==============================================================================
230 //     _ _  _  __|_ _    __|_ _  _  .
231 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
232 //==============================================================================
233     constructor()
234         public
235     {
236 		// Team allocation structures
237         // 0 = whales
238         // 1 = bears
239         // 2 = sneks
240         // 3 = bulls
241 
242 		// Team allocation percentages
243         // (F3D, P3D) + (Pot , Referrals, Community)
244             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
245         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
246         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
247         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
248         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
249         
250         // how to split up the final pot based on which team was picked
251         // (F3D, P3D)
252         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
253         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
254         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
255         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
256 	}
257 //==============================================================================
258 //     _ _  _  _|. |`. _  _ _  .
259 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
260 //==============================================================================
261     /**
262      * @dev used to make sure no one can interact with contract until it has 
263      * been activated. 
264      */
265     modifier isActivated() {
266         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
267         _;
268     }
269     
270     /**
271      * @dev prevents contracts from interacting with fomo3d 
272      */
273     modifier isHuman() {
274         address _addr = msg.sender;
275         uint256 _codeLength;
276         
277         assembly {_codeLength := extcodesize(_addr)}
278         require(_codeLength == 0, "sorry humans only");
279         _;
280     }
281 
282     /**
283      * @dev sets boundaries for incoming tx 
284      */
285     modifier isWithinLimits(uint256 _eth) {
286         require(_eth >= 1000000000, "pocket lint: not a valid currency");
287         require(_eth <= 100000000000000000000000, "no vitalik, no");
288         _;    
289     }
290     
291 //==============================================================================
292 //     _    |_ |. _   |`    _  __|_. _  _  _  .
293 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
294 //====|=========================================================================
295     /**
296      * @dev emergency buy uses last stored affiliate ID and team snek
297      */
298     function()
299         isActivated()
300         isHuman()
301         isWithinLimits(msg.value)
302         public
303         payable
304     {
305         // set up our tx event data and determine if player is new or not
306         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
307             
308         // fetch player id
309         uint256 _pID = pIDxAddr_[msg.sender];
310         
311         // buy core 
312         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
313     }
314     
315     /**
316      * @dev converts all incoming ethereum to keys.
317      * -functionhash- 0x8f38f309 (using ID for affiliate)
318      * -functionhash- 0x98a0871d (using address for affiliate)
319      * -functionhash- 0xa65b37a1 (using name for affiliate)
320      * @param _affCode the ID/address/name of the player who gets the affiliate fee
321      * @param _team what team is the player playing for?
322      */
323     function buyXid(uint256 _affCode, uint256 _team)
324         isActivated()
325         isHuman()
326         isWithinLimits(msg.value)
327         public
328         payable
329     {
330         // set up our tx event data and determine if player is new or not
331         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
332         
333         // fetch player id
334         uint256 _pID = pIDxAddr_[msg.sender];
335         
336         // manage affiliate residuals
337         // if no affiliate code was given or player tried to use their own, lolz
338         if (_affCode == 0 || _affCode == _pID)
339         {
340             // use last stored affiliate code 
341             _affCode = plyr_[_pID].laff;
342             
343         // if affiliate code was given & its not the same as previously stored 
344         } else if (_affCode != plyr_[_pID].laff) {
345             // update last affiliate 
346             plyr_[_pID].laff = _affCode;
347         }
348         
349         // verify a valid team was selected
350         _team = verifyTeam(_team);
351         
352         // buy core 
353         buyCore(_pID, _affCode, _team, _eventData_);
354     }
355     
356     function buyXaddr(address _affCode, uint256 _team)
357         isActivated()
358         isHuman()
359         isWithinLimits(msg.value)
360         public
361         payable
362     {
363         // set up our tx event data and determine if player is new or not
364         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
365         
366         // fetch player id
367         uint256 _pID = pIDxAddr_[msg.sender];
368         
369         // manage affiliate residuals
370         uint256 _affID;
371         // if no affiliate code was given or player tried to use their own, lolz
372         if (_affCode == address(0) || _affCode == msg.sender)
373         {
374             // use last stored affiliate code
375             _affID = plyr_[_pID].laff;
376         
377         // if affiliate code was given    
378         } else {
379             // get affiliate ID from aff Code 
380             _affID = pIDxAddr_[_affCode];
381             
382             // if affID is not the same as previously stored 
383             if (_affID != plyr_[_pID].laff)
384             {
385                 // update last affiliate
386                 plyr_[_pID].laff = _affID;
387             }
388         }
389         
390         // verify a valid team was selected
391         _team = verifyTeam(_team);
392         
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
405         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
455         F3Ddatasets.EventReturns memory _eventData_;
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
487         F3Ddatasets.EventReturns memory _eventData_;
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
527         F3Ddatasets.EventReturns memory _eventData_;
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
585             F3Ddatasets.EventReturns memory _eventData_;
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
603             emit F3Devents.onWithdrawAndDistribute
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
614                 _eventData_.P3DAmount, 
615                 _eventData_.genAmount
616             );
617             
618         // in any other situation
619         } else {
620             // get their earnings
621             _eth = withdrawEarnings(_pID);
622             
623             // gib moni
624             if (_eth > 0)
625                 plyr_[_pID].addr.transfer(_eth);
626             
627             // fire withdraw event
628             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
629         }
630     }
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
653      * @param _all set to true if you want this to push your info to all games 
654      * (this might cost a lot of gas)
655      */
656     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
657         isHuman()
658         public
659         payable
660     {
661         bytes32 _name = _nameString.nameFilter();
662         address _addr = msg.sender;
663         uint256 _paid = msg.value;
664         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
665         
666         uint256 _pID = pIDxAddr_[_addr];
667         
668         // fire event
669         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
670     }
671     
672     function registerNameXaddr(string _nameString, address _affCode, bool _all)
673         isHuman()
674         public
675         payable
676     {
677         bytes32 _name = _nameString.nameFilter();
678         address _addr = msg.sender;
679         uint256 _paid = msg.value;
680         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
681         
682         uint256 _pID = pIDxAddr_[_addr];
683         
684         // fire event
685         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
686     }
687     
688     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
689         isHuman()
690         public
691         payable
692     {
693         bytes32 _name = _nameString.nameFilter();
694         address _addr = msg.sender;
695         uint256 _paid = msg.value;
696         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
697         
698         uint256 _pID = pIDxAddr_[_addr];
699         
700         // fire event
701         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
702     }
703 //==============================================================================
704 //     _  _ _|__|_ _  _ _  .
705 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
706 //=====_|=======================================================================
707     /**
708      * @dev return the price buyer will pay for next 1 individual key.
709      * -functionhash- 0x018a25e8
710      * @return price for next key bought (in wei format)
711      */
712     function getBuyPrice()
713         public 
714         view 
715         returns(uint256)
716     {  
717         // setup local rID
718         uint256 _rID = rID_;
719         
720         // grab time
721         uint256 _now = now;
722         
723         // are we in a round?
724         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
725             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
726         else // rounds over.  need price for new round
727             return ( 75000000000000 ); // init
728     }
729     
730     /**
731      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
732      * provider
733      * -functionhash- 0xc7e284b8
734      * @return time left in seconds
735      */
736     function getTimeLeft()
737         public
738         view
739         returns(uint256)
740     {
741         // setup local rID
742         uint256 _rID = rID_;
743         
744         // grab time
745         uint256 _now = now;
746         
747         if (_now < round_[_rID].end)
748             if (_now > round_[_rID].strt + rndGap_)
749                 return( (round_[_rID].end).sub(_now) );
750             else
751                 return( (round_[_rID].strt + rndGap_).sub(_now) );
752         else
753             return(0);
754     }
755     
756     /**
757      * @dev returns player earnings per vaults 
758      * -functionhash- 0x63066434
759      * @return winnings vault
760      * @return general vault
761      * @return affiliate vault
762      */
763     function getPlayerVaults(uint256 _pID)
764         public
765         view
766         returns(uint256 ,uint256, uint256)
767     {
768         // setup local rID
769         uint256 _rID = rID_;
770         
771         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
772         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
773         {
774             // if player is winner 
775             if (round_[_rID].plyr == _pID)
776             {
777                 return
778                 (
779                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
780                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
781                     plyr_[_pID].aff
782                 );
783             // if player is not the winner
784             } else {
785                 return
786                 (
787                     plyr_[_pID].win,
788                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
789                     plyr_[_pID].aff
790                 );
791             }
792             
793         // if round is still going on, or round has ended and round end has been ran
794         } else {
795             return
796             (
797                 plyr_[_pID].win,
798                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
799                 plyr_[_pID].aff
800             );
801         }
802     }
803     
804     /**
805      * solidity hates stack limits.  this lets us avoid that hate 
806      */
807     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
808         private
809         view
810         returns(uint256)
811     {
812         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
813     }
814     
815     /**
816      * @dev returns all current round info needed for front end
817      * -functionhash- 0x747dff42
818      * @return eth invested during ICO phase
819      * @return round id 
820      * @return total keys for round 
821      * @return time round ends
822      * @return time round started
823      * @return current pot 
824      * @return current team ID & player ID in lead 
825      * @return current player in leads address 
826      * @return current player in leads name
827      * @return whales eth in for round
828      * @return bears eth in for round
829      * @return sneks eth in for round
830      * @return bulls eth in for round
831      * @return airdrop tracker # & airdrop pot
832      */
833     function getCurrentRoundInfo()
834         public
835         view
836         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
837     {
838         // setup local rID
839         uint256 _rID = rID_;
840         
841         return
842         (
843             round_[_rID].ico,               //0
844             _rID,                           //1
845             round_[_rID].keys,              //2
846             round_[_rID].end,               //3
847             round_[_rID].strt,              //4
848             round_[_rID].pot,               //5
849             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
850             plyr_[round_[_rID].plyr].addr,  //7
851             plyr_[round_[_rID].plyr].name,  //8
852             rndTmEth_[_rID][0],             //9
853             rndTmEth_[_rID][1],             //10
854             rndTmEth_[_rID][2],             //11
855             rndTmEth_[_rID][3],             //12
856             airDropTracker_ + (airDropPot_ * 1000)              //13
857         );
858     }
859 
860     /**
861      * @dev returns player info based on address.  if no address is given, it will 
862      * use msg.sender 
863      * -functionhash- 0xee0b5d8b
864      * @param _addr address of the player you want to lookup 
865      * @return player ID 
866      * @return player name
867      * @return keys owned (current round)
868      * @return winnings vault
869      * @return general vault 
870      * @return affiliate vault 
871 	 * @return player round eth
872      */
873     function getPlayerInfoByAddress(address _addr)
874         public 
875         view 
876         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
877     {
878         // setup local rID
879         uint256 _rID = rID_;
880         
881         if (_addr == address(0))
882         {
883             _addr == msg.sender;
884         }
885         uint256 _pID = pIDxAddr_[_addr];
886         
887         return
888         (
889             _pID,                               //0
890             plyr_[_pID].name,                   //1
891             plyrRnds_[_pID][_rID].keys,         //2
892             plyr_[_pID].win,                    //3
893             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
894             plyr_[_pID].aff,                    //5
895             plyrRnds_[_pID][_rID].eth           //6
896         );
897     }
898 
899 //==============================================================================
900 //     _ _  _ _   | _  _ . _  .
901 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
902 //=====================_|=======================================================
903     /**
904      * @dev logic runs whenever a buy order is executed.  determines how to handle 
905      * incoming eth depending on if we are in an active round or not
906      */
907     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
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
919             // call core 
920             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
921         
922         // if round is not active     
923         } else {
924             // check to see if end round needs to be ran
925             if (_now > round_[_rID].end && round_[_rID].ended == false) 
926             {
927                 // end the round (distributes pot) & start new round
928 			    round_[_rID].ended = true;
929                 _eventData_ = endRound(_eventData_);
930                 
931                 // build event data
932                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
933                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
934                 
935                 // fire buy and distribute event 
936                 emit F3Devents.onBuyAndDistribute
937                 (
938                     msg.sender, 
939                     plyr_[_pID].name, 
940                     msg.value, 
941                     _eventData_.compressedData, 
942                     _eventData_.compressedIDs, 
943                     _eventData_.winnerAddr, 
944                     _eventData_.winnerName, 
945                     _eventData_.amountWon, 
946                     _eventData_.newPot, 
947                     _eventData_.P3DAmount, 
948                     _eventData_.genAmount
949                 );
950             }
951             
952             // put eth in players vault 
953             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
954         }
955     }
956     
957     /**
958      * @dev logic runs whenever a reload order is executed.  determines how to handle 
959      * incoming eth depending on if we are in an active round or not 
960      */
961     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
962         private
963     {
964         // setup local rID
965         uint256 _rID = rID_;
966         
967         // grab time
968         uint256 _now = now;
969         
970         // if round is active
971         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
972         {
973             // get earnings from all vaults and return unused to gen vault
974             // because we use a custom safemath library.  this will throw if player 
975             // tried to spend more eth than they have.
976             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
977             
978             // call core 
979             core(_rID, _pID, _eth, _affID, _team, _eventData_);
980         
981         // if round is not active and end round needs to be ran   
982         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
983             // end the round (distributes pot) & start new round
984             round_[_rID].ended = true;
985             _eventData_ = endRound(_eventData_);
986                 
987             // build event data
988             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
989             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
990                 
991             // fire buy and distribute event 
992             emit F3Devents.onReLoadAndDistribute
993             (
994                 msg.sender, 
995                 plyr_[_pID].name, 
996                 _eventData_.compressedData, 
997                 _eventData_.compressedIDs, 
998                 _eventData_.winnerAddr, 
999                 _eventData_.winnerName, 
1000                 _eventData_.amountWon, 
1001                 _eventData_.newPot, 
1002                 _eventData_.P3DAmount, 
1003                 _eventData_.genAmount
1004             );
1005         }
1006     }
1007     
1008     /**
1009      * @dev this is the core logic for any buy/reload that happens while a round 
1010      * is live.
1011      */
1012     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1013         private
1014     {
1015         // if player is new to round
1016         if (plyrRnds_[_pID][_rID].keys == 0)
1017             _eventData_ = managePlayer(_pID, _eventData_);
1018         
1019         // early round eth limiter 
1020         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1021         {
1022             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1023             uint256 _refund = _eth.sub(_availableLimit);
1024             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1025             _eth = _availableLimit;
1026         }
1027         
1028         // if eth left is greater than min eth allowed (sorry no pocket lint)
1029         if (_eth > 1000000000) 
1030         {
1031             
1032             // mint the new keys
1033             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1034             
1035             // if they bought at least 1 whole key
1036             if (_keys >= 1000000000000000000)
1037             {
1038             updateTimer(_keys, _rID);
1039 
1040             // set new leaders
1041             if (round_[_rID].plyr != _pID)
1042                 round_[_rID].plyr = _pID;  
1043             if (round_[_rID].team != _team)
1044                 round_[_rID].team = _team; 
1045             
1046             // set the new leader bool to true
1047             _eventData_.compressedData = _eventData_.compressedData + 100;
1048         }
1049             
1050             // manage airdrops
1051             if (_eth >= 100000000000000000)
1052             {
1053             airDropTracker_++;
1054             if (airdrop() == true)
1055             {
1056                 // gib muni
1057                 uint256 _prize;
1058                 if (_eth >= 10000000000000000000)
1059                 {
1060                     // calculate prize and give it to winner
1061                     _prize = ((airDropPot_).mul(75)) / 100;
1062                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1063                     
1064                     // adjust airDropPot 
1065                     airDropPot_ = (airDropPot_).sub(_prize);
1066                     
1067                     // let event know a tier 3 prize was won 
1068                     _eventData_.compressedData += 300000000000000000000000000000000;
1069                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1070                     // calculate prize and give it to winner
1071                     _prize = ((airDropPot_).mul(50)) / 100;
1072                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1073                     
1074                     // adjust airDropPot 
1075                     airDropPot_ = (airDropPot_).sub(_prize);
1076                     
1077                     // let event know a tier 2 prize was won 
1078                     _eventData_.compressedData += 200000000000000000000000000000000;
1079                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1080                     // calculate prize and give it to winner
1081                     _prize = ((airDropPot_).mul(25)) / 100;
1082                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1083                     
1084                     // adjust airDropPot 
1085                     airDropPot_ = (airDropPot_).sub(_prize);
1086                     
1087                     // let event know a tier 3 prize was won 
1088                     _eventData_.compressedData += 300000000000000000000000000000000;
1089                 }
1090                 // set airdrop happened bool to true
1091                 _eventData_.compressedData += 10000000000000000000000000000000;
1092                 // let event know how much was won 
1093                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1094                 
1095                 // reset air drop tracker
1096                 airDropTracker_ = 0;
1097             }
1098         }
1099     
1100             // store the air drop tracker number (number of buys since last airdrop)
1101             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1102             
1103             // update player 
1104             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1105             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1106             
1107             // update round
1108             round_[_rID].keys = _keys.add(round_[_rID].keys);
1109             round_[_rID].eth = _eth.add(round_[_rID].eth);
1110             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1111     
1112             // distribute eth
1113             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1114             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1115             
1116             // call end tx function to fire end tx event.
1117 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1118         }
1119     }
1120 //==============================================================================
1121 //     _ _ | _   | _ _|_ _  _ _  .
1122 //    (_(_||(_|_||(_| | (_)| _\  .
1123 //==============================================================================
1124     /**
1125      * @dev calculates unmasked earnings (just calculates, does not update mask)
1126      * @return earnings in wei format
1127      */
1128     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1129         private
1130         view
1131         returns(uint256)
1132     {
1133         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1134     }
1135     
1136     /** 
1137      * @dev returns the amount of keys you would get given an amount of eth. 
1138      * -functionhash- 0xce89c80c
1139      * @param _rID round ID you want price for
1140      * @param _eth amount of eth sent in 
1141      * @return keys received 
1142      */
1143     function calcKeysReceived(uint256 _rID, uint256 _eth)
1144         public
1145         view
1146         returns(uint256)
1147     {
1148         // grab time
1149         uint256 _now = now;
1150         
1151         // are we in a round?
1152         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1153             return ( (round_[_rID].eth).keysRec(_eth) );
1154         else // rounds over.  need keys for new round
1155             return ( (_eth).keys() );
1156     }
1157     
1158     /** 
1159      * @dev returns current eth price for X keys.  
1160      * -functionhash- 0xcf808000
1161      * @param _keys number of keys desired (in 18 decimal format)
1162      * @return amount of eth needed to send
1163      */
1164     function iWantXKeys(uint256 _keys)
1165         public
1166         view
1167         returns(uint256)
1168     {
1169         // setup local rID
1170         uint256 _rID = rID_;
1171         
1172         // grab time
1173         uint256 _now = now;
1174         
1175         // are we in a round?
1176         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1177             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1178         else // rounds over.  need price for new round
1179             return ( (_keys).eth() );
1180     }
1181 //==============================================================================
1182 //    _|_ _  _ | _  .
1183 //     | (_)(_)|_\  .
1184 //==============================================================================
1185     /**
1186 	 * @dev receives name/player info from names contract 
1187      */
1188     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1189         external
1190     {
1191         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1192         if (pIDxAddr_[_addr] != _pID)
1193             pIDxAddr_[_addr] = _pID;
1194         if (pIDxName_[_name] != _pID)
1195             pIDxName_[_name] = _pID;
1196         if (plyr_[_pID].addr != _addr)
1197             plyr_[_pID].addr = _addr;
1198         if (plyr_[_pID].name != _name)
1199             plyr_[_pID].name = _name;
1200         if (plyr_[_pID].laff != _laff)
1201             plyr_[_pID].laff = _laff;
1202         if (plyrNames_[_pID][_name] == false)
1203             plyrNames_[_pID][_name] = true;
1204     }
1205     
1206     /**
1207      * @dev receives entire player name list 
1208      */
1209     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1210         external
1211     {
1212         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1213         if(plyrNames_[_pID][_name] == false)
1214             plyrNames_[_pID][_name] = true;
1215     }   
1216         
1217     /**
1218      * @dev gets existing or registers new pID.  use this when a player may be new
1219      * @return pID 
1220      */
1221     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1222         private
1223         returns (F3Ddatasets.EventReturns)
1224     {
1225         uint256 _pID = pIDxAddr_[msg.sender];
1226         // if player is new to this version of fomo3d
1227         if (_pID == 0)
1228         {
1229             // grab their player ID, name and last aff ID, from player names contract 
1230             _pID = PlayerBook.getPlayerID(msg.sender);
1231             bytes32 _name = PlayerBook.getPlayerName(_pID);
1232             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1233             
1234             // set up player account 
1235             pIDxAddr_[msg.sender] = _pID;
1236             plyr_[_pID].addr = msg.sender;
1237             
1238             if (_name != "")
1239             {
1240                 pIDxName_[_name] = _pID;
1241                 plyr_[_pID].name = _name;
1242                 plyrNames_[_pID][_name] = true;
1243             }
1244             
1245             if (_laff != 0 && _laff != _pID)
1246                 plyr_[_pID].laff = _laff;
1247             
1248             // set the new player bool to true
1249             _eventData_.compressedData = _eventData_.compressedData + 1;
1250         } 
1251         return (_eventData_);
1252     }
1253     
1254     /**
1255      * @dev checks to make sure user picked a valid team.  if not sets team 
1256      * to default (sneks)
1257      */
1258     function verifyTeam(uint256 _team)
1259         private
1260         pure
1261         returns (uint256)
1262     {
1263         if (_team < 0 || _team > 3)
1264             return(2);
1265         else
1266             return(_team);
1267     }
1268     
1269     /**
1270      * @dev decides if round end needs to be run & new round started.  and if 
1271      * player unmasked earnings from previously played rounds need to be moved.
1272      */
1273     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1274         private
1275         returns (F3Ddatasets.EventReturns)
1276     {
1277         // if player has played a previous round, move their unmasked earnings
1278         // from that round to gen vault.
1279         if (plyr_[_pID].lrnd != 0)
1280             updateGenVault(_pID, plyr_[_pID].lrnd);
1281             
1282         // update player's last round played
1283         plyr_[_pID].lrnd = rID_;
1284             
1285         // set the joined round bool to true
1286         _eventData_.compressedData = _eventData_.compressedData + 10;
1287         
1288         return(_eventData_);
1289     }
1290     
1291     /**
1292      * @dev ends the round. manages paying out winner/splitting up pot
1293      */
1294     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1295         private
1296         returns (F3Ddatasets.EventReturns)
1297     {
1298         // setup local rID
1299         uint256 _rID = rID_;
1300         
1301         // grab our winning player and team id's
1302         uint256 _winPID = round_[_rID].plyr;
1303         uint256 _winTID = round_[_rID].team;
1304         
1305         // grab our pot amount
1306         uint256 _pot = round_[_rID].pot;
1307         
1308         // calculate our winner share, community rewards, gen share, 
1309         // p3d share, and amount reserved for next pot 
1310         uint256 _win = (_pot.mul(48)) / 100;
1311         uint256 _com = (_pot / 50);
1312         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1313         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1314         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1315         
1316         // calculate ppt for round mask
1317         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1318         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1319         if (_dust > 0)
1320         {
1321             _gen = _gen.sub(_dust);
1322             _res = _res.add(_dust);
1323         }
1324         
1325         // pay our winner
1326         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1327         
1328         // // community rewards
1329         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1330         // {
1331         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1332         //     // bank migrations by breaking outgoing transactions.
1333         //     // Something we would never do. But that's not the point.
1334         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1335         //     // highest belief that everything we create should be trustless.
1336         //     // Team JUST, The name you shouldn't have to trust.
1337         //     _p3d = _p3d.add(_com);
1338         //     _com = 0;
1339         // }
1340 
1341         reward.transfer(_com);
1342         
1343         // distribute gen portion to key holders
1344         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1345         
1346         // send share for p3d to divies
1347         if (_p3d > 0)
1348             Divies.deposit.value(_p3d)();
1349             
1350         // prepare event data
1351         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1352         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1353         _eventData_.winnerAddr = plyr_[_winPID].addr;
1354         _eventData_.winnerName = plyr_[_winPID].name;
1355         _eventData_.amountWon = _win;
1356         _eventData_.genAmount = _gen;
1357         _eventData_.P3DAmount = _p3d;
1358         _eventData_.newPot = _res;
1359         
1360         // start next round
1361         rID_++;
1362         _rID++;
1363         round_[_rID].strt = now;
1364         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1365         round_[_rID].pot = _res;
1366         
1367         return(_eventData_);
1368     }
1369     
1370     /**
1371      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1372      */
1373     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1374         private 
1375     {
1376         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1377         if (_earnings > 0)
1378         {
1379             // put in gen vault
1380             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1381             // zero out their earnings by updating mask
1382             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1383         }
1384     }
1385     
1386     /**
1387      * @dev updates round timer based on number of whole keys bought.
1388      */
1389     function updateTimer(uint256 _keys, uint256 _rID)
1390         private
1391     {
1392         // grab time
1393         uint256 _now = now;
1394         
1395         // calculate time based on number of keys bought
1396         uint256 _newTime;
1397         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1398             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1399         else
1400             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1401         
1402         // compare to max and set new end time
1403         if (_newTime < (rndMax_).add(_now))
1404             round_[_rID].end = _newTime;
1405         else
1406             round_[_rID].end = rndMax_.add(_now);
1407     }
1408     
1409     /**
1410      * @dev generates a random number between 0-99 and checks to see if thats
1411      * resulted in an airdrop win
1412      * @return do we have a winner?
1413      */
1414     function airdrop()
1415         private 
1416         view 
1417         returns(bool)
1418     {
1419         uint256 seed = uint256(keccak256(abi.encodePacked(
1420             
1421             (block.timestamp).add
1422             (block.difficulty).add
1423             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1424             (block.gaslimit).add
1425             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1426             (block.number)
1427             
1428         )));
1429         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1430             return(true);
1431         else
1432             return(false);
1433     }
1434 
1435     /**
1436      * @dev distributes eth based on fees to com, aff, and p3d
1437      */
1438     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1439         private
1440         returns(F3Ddatasets.EventReturns)
1441     {
1442         // pay 2% out to community rewards
1443         uint256 _com = _eth / 50;
1444         uint256 _p3d;
1445         // if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1446         // {
1447         //     // This ensures Team Just cannot influence the outcome of FoMo3D with
1448         //     // bank migrations by breaking outgoing transactions.
1449         //     // Something we would never do. But that's not the point.
1450         //     // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1451         //     // highest belief that everything we create should be trustless.
1452         //     // Team JUST, The name you shouldn't have to trust.
1453         //     _p3d = _com;
1454         //     _com = 0;
1455         // }
1456         reward.transfer(_com);
1457         
1458         // pay 1% out to FoMo3D short
1459         uint256 _long = _eth / 100;
1460         // otherF3D_.potSwap.value(_long)();
1461         otherF3D_.send(_long);
1462         
1463         // distribute share to affiliate
1464         uint256 _aff = _eth / 10;
1465         
1466         // decide what to do with affiliate share of fees
1467         // affiliate must not be self, and must have a name registered
1468         if (_affID != _pID && plyr_[_affID].name != '') {
1469             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1470             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1471         } else {
1472             _p3d = _aff;
1473         }
1474         
1475         // pay out p3d
1476         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1477         if (_p3d > 0)
1478         {
1479             // deposit to divies contract
1480             Divies.deposit.value(_p3d)();
1481             
1482             // set up event data
1483             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1484         }
1485         
1486         return(_eventData_);
1487     }
1488     
1489     function potSwap()
1490         external
1491         payable
1492     {
1493         // setup local rID
1494         uint256 _rID = rID_ + 1;
1495         
1496         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1497         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1498     }
1499     
1500     /**
1501      * @dev distributes eth based on fees to gen and pot
1502      */
1503     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1504         private
1505         returns(F3Ddatasets.EventReturns)
1506     {
1507         // calculate gen share
1508         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1509         
1510         // toss 1% into airdrop pot 
1511         uint256 _air = (_eth / 100);
1512         airDropPot_ = airDropPot_.add(_air);
1513         
1514         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1515         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1516         
1517         // calculate pot 
1518         uint256 _pot = _eth.sub(_gen);
1519         
1520         // distribute gen share (thats what updateMasks() does) and adjust
1521         // balances for dust.
1522         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1523         if (_dust > 0)
1524             _gen = _gen.sub(_dust);
1525         
1526         // add eth to pot
1527         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1528         
1529         // set up event data
1530         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1531         _eventData_.potAmount = _pot;
1532         
1533         return(_eventData_);
1534     }
1535 
1536     /**
1537      * @dev updates masks for round and player when keys are bought
1538      * @return dust left over 
1539      */
1540     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1541         private
1542         returns(uint256)
1543     {
1544         /* MASKING NOTES
1545             earnings masks are a tricky thing for people to wrap their minds around.
1546             the basic thing to understand here.  is were going to have a global
1547             tracker based on profit per share for each round, that increases in
1548             relevant proportion to the increase in share supply.
1549             
1550             the player will have an additional mask that basically says "based
1551             on the rounds mask, my shares, and how much i've already withdrawn,
1552             how much is still owed to me?"
1553         */
1554         
1555         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1556         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1557         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1558             
1559         // calculate player earning from their own buy (only based on the keys
1560         // they just bought).  & update player earnings mask
1561         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1562         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1563         
1564         // calculate & return dust
1565         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1566     }
1567     
1568     /**
1569      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1570      * @return earnings in wei format
1571      */
1572     function withdrawEarnings(uint256 _pID)
1573         private
1574         returns(uint256)
1575     {
1576         // update gen vault
1577         updateGenVault(_pID, plyr_[_pID].lrnd);
1578         
1579         // from vaults 
1580         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1581         if (_earnings > 0)
1582         {
1583             plyr_[_pID].win = 0;
1584             plyr_[_pID].gen = 0;
1585             plyr_[_pID].aff = 0;
1586         }
1587 
1588         return(_earnings);
1589     }
1590     
1591     /**
1592      * @dev prepares compression data and fires event for buy or reload tx's
1593      */
1594     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1595         private
1596     {
1597         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1598         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1599         
1600         emit F3Devents.onEndTx
1601         (
1602             _eventData_.compressedData,
1603             _eventData_.compressedIDs,
1604             plyr_[_pID].name,
1605             msg.sender,
1606             _eth,
1607             _keys,
1608             _eventData_.winnerAddr,
1609             _eventData_.winnerName,
1610             _eventData_.amountWon,
1611             _eventData_.newPot,
1612             _eventData_.P3DAmount,
1613             _eventData_.genAmount,
1614             _eventData_.potAmount,
1615             airDropPot_
1616         );
1617     }
1618 //==============================================================================
1619 //    (~ _  _    _._|_    .
1620 //    _)(/_(_|_|| | | \/  .
1621 //====================/=========================================================
1622     /** upon contract deploy, it will be deactivated.  this is a one time
1623      * use function that will activate the contract.  we do this so devs 
1624      * have time to set things up on the web end                            **/
1625     bool public activated_ = false;
1626     function activate()
1627         public
1628     {
1629         // only team just can activate 
1630         require(
1631             msg.sender == 0x2ec1a6CAa83037cD0eAbceffCA77ede9C1d77512 ||
1632             msg.sender == 0xA9248e8F10A632226DD282Fa7653157CdC3e940E ||
1633             msg.sender == 0x5F9E2a13226B93359E1dc0B0d4cc4257c4fA7610 ||
1634             msg.sender == 0x7218cd0a71ad54d966c3fd008811b67bd1825456 ||
1635 			msg.sender == 0xaaad7eb3132bf7b07316bf5ce26adcbb4ac9d43d,
1636             "only team just can activate"
1637         );
1638 
1639 		// make sure that its been linked.
1640         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1641         
1642         // can only be ran once
1643         require(activated_ == false, "fomo3d already activated");
1644         
1645         // activate the contract 
1646         activated_ = true;
1647         
1648         // lets start first round
1649 		rID_ = 1;
1650         round_[1].strt = now + rndExtra_ - rndGap_;
1651         round_[1].end = now + rndInit_ + rndExtra_;
1652     }
1653     function setOtherFomo(address _otherF3D)
1654         public
1655     {
1656         // only team just can activate 
1657         require(
1658             msg.sender == 0x2ec1a6CAa83037cD0eAbceffCA77ede9C1d77512 ||
1659             msg.sender == 0xA9248e8F10A632226DD282Fa7653157CdC3e940E ||
1660             msg.sender == 0x5F9E2a13226B93359E1dc0B0d4cc4257c4fA7610 ||
1661             msg.sender == 0x7218cd0a71ad54d966c3fd008811b67bd1825456 ||
1662 			msg.sender == 0xaaad7eb3132bf7b07316bf5ce26adcbb4ac9d43d,
1663             "only team just can activate"
1664         );
1665 
1666         // make sure that it HASNT yet been linked.
1667         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1668         
1669         // // set up other fomo3d (fast or long) for pot swap
1670         otherF3D_ = _otherF3D;
1671     }
1672 }
1673 
1674 //==============================================================================
1675 //   __|_ _    __|_ _  .
1676 //  _\ | | |_|(_ | _\  .
1677 //==============================================================================
1678 library F3Ddatasets {
1679     //compressedData key
1680     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1681         // 0 - new player (bool)
1682         // 1 - joined round (bool)
1683         // 2 - new  leader (bool)
1684         // 3-5 - air drop tracker (uint 0-999)
1685         // 6-16 - round end time
1686         // 17 - winnerTeam
1687         // 18 - 28 timestamp 
1688         // 29 - team
1689         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1690         // 31 - airdrop happened bool
1691         // 32 - airdrop tier 
1692         // 33 - airdrop amount won
1693     //compressedIDs key
1694     // [77-52][51-26][25-0]
1695         // 0-25 - pID 
1696         // 26-51 - winPID
1697         // 52-77 - rID
1698     struct EventReturns {
1699         uint256 compressedData;
1700         uint256 compressedIDs;
1701         address winnerAddr;         // winner address
1702         bytes32 winnerName;         // winner name
1703         uint256 amountWon;          // amount won
1704         uint256 newPot;             // amount in new pot
1705         uint256 P3DAmount;          // amount distributed to p3d
1706         uint256 genAmount;          // amount distributed to gen
1707         uint256 potAmount;          // amount added to pot
1708     }
1709     struct Player {
1710         address addr;   // player address
1711         bytes32 name;   // player name
1712         uint256 win;    // winnings vault
1713         uint256 gen;    // general vault
1714         uint256 aff;    // affiliate vault
1715         uint256 lrnd;   // last round played
1716         uint256 laff;   // last affiliate id used
1717     }
1718     struct PlayerRounds {
1719         uint256 eth;    // eth player has added to round (used for eth limiter)
1720         uint256 keys;   // keys
1721         uint256 mask;   // player mask 
1722         uint256 ico;    // ICO phase investment
1723     }
1724     struct Round {
1725         uint256 plyr;   // pID of player in lead
1726         uint256 team;   // tID of team in lead
1727         uint256 end;    // time ends/ended
1728         bool ended;     // has round end function been ran
1729         uint256 strt;   // time round started
1730         uint256 keys;   // keys
1731         uint256 eth;    // total eth in
1732         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1733         uint256 mask;   // global mask
1734         uint256 ico;    // total eth sent in during ICO phase
1735         uint256 icoGen; // total eth for gen during ICO phase
1736         uint256 icoAvg; // average key price for ICO phase
1737     }
1738     struct TeamFee {
1739         uint256 gen;    // % of buy in thats paid to key holders of current round
1740         uint256 p3d;    // % of buy in thats paid to p3d holders
1741     }
1742     struct PotSplit {
1743         uint256 gen;    // % of pot thats paid to key holders of current round
1744         uint256 p3d;    // % of pot thats paid to p3d holders
1745     }
1746 }
1747 
1748 //==============================================================================
1749 //  |  _      _ _ | _  .
1750 //  |<(/_\/  (_(_||(_  .
1751 //=======/======================================================================
1752 library F3DKeysCalcLong {
1753     using SafeMath for *;
1754     /**
1755      * @dev calculates number of keys received given X eth 
1756      * @param _curEth current amount of eth in contract 
1757      * @param _newEth eth being spent
1758      * @return amount of ticket purchased
1759      */
1760     function keysRec(uint256 _curEth, uint256 _newEth)
1761         internal
1762         pure
1763         returns (uint256)
1764     {
1765         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1766     }
1767     
1768     /**
1769      * @dev calculates amount of eth received if you sold X keys 
1770      * @param _curKeys current amount of keys that exist 
1771      * @param _sellKeys amount of keys you wish to sell
1772      * @return amount of eth received
1773      */
1774     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1775         internal
1776         pure
1777         returns (uint256)
1778     {
1779         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1780     }
1781 
1782     /**
1783      * @dev calculates how many keys would exist with given an amount of eth
1784      * @param _eth eth "in contract"
1785      * @return number of keys that would exist
1786      */
1787     function keys(uint256 _eth) 
1788         internal
1789         pure
1790         returns(uint256)
1791     {
1792         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1793     }
1794     
1795     /**
1796      * @dev calculates how much eth would be in contract given a number of keys
1797      * @param _keys number of keys "in contract" 
1798      * @return eth that would exists
1799      */
1800     function eth(uint256 _keys) 
1801         internal
1802         pure
1803         returns(uint256)  
1804     {
1805         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1806     }
1807 }
1808 
1809 //==============================================================================
1810 //  . _ _|_ _  _ |` _  _ _  _  .
1811 //  || | | (/_| ~|~(_|(_(/__\  .
1812 //==============================================================================
1813 interface otherFoMo3D {
1814     function potSwap() external payable;
1815 }
1816 
1817 interface F3DexternalSettingsInterface {
1818     function getFastGap() external returns(uint256);
1819     function getLongGap() external returns(uint256);
1820     function getFastExtra() external returns(uint256);
1821     function getLongExtra() external returns(uint256);
1822 }
1823 
1824 interface DiviesInterface {
1825     function deposit() external payable;
1826 }
1827 
1828 interface JIincForwarderInterface {
1829     function deposit() external payable returns(bool);
1830     function status() external view returns(address, address, bool);
1831     function startMigration(address _newCorpBank) external returns(bool);
1832     function cancelMigration() external returns(bool);
1833     function finishMigration() external returns(bool);
1834     function setup(address _firstCorpBank) external;
1835 }
1836 
1837 interface PlayerBookInterface {
1838     function getPlayerID(address _addr) external returns (uint256);
1839     function getPlayerName(uint256 _pID) external view returns (bytes32);
1840     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1841     function getPlayerAddr(uint256 _pID) external view returns (address);
1842     function getNameFee() external view returns (uint256);
1843     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1844     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1845     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1846 }
1847 
1848 /**
1849 * @title -Name Filter- v0.1.9
1850 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1851 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1852 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1853 *                                  _____                      _____
1854 *                                 (, /     /)       /) /)    (, /      /)          /)
1855 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1856 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1857 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1858 *                            (__ /          (_/ (, /                                      /)™ 
1859 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1860 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1861 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1862 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1863 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1864 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1865 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1866 *
1867 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1868 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1869 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1870 */
1871 
1872 library NameFilter {
1873     /**
1874      * @dev filters name strings
1875      * -converts uppercase to lower case.  
1876      * -makes sure it does not start/end with a space
1877      * -makes sure it does not contain multiple spaces in a row
1878      * -cannot be only numbers
1879      * -cannot start with 0x 
1880      * -restricts characters to A-Z, a-z, 0-9, and space.
1881      * @return reprocessed string in bytes32 format
1882      */
1883     function nameFilter(string _input)
1884         internal
1885         pure
1886         returns(bytes32)
1887     {
1888         bytes memory _temp = bytes(_input);
1889         uint256 _length = _temp.length;
1890         
1891         //sorry limited to 32 characters
1892         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1893         // make sure it doesnt start with or end with space
1894         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1895         // make sure first two characters are not 0x
1896         if (_temp[0] == 0x30)
1897         {
1898             require(_temp[1] != 0x78, "string cannot start with 0x");
1899             require(_temp[1] != 0x58, "string cannot start with 0X");
1900         }
1901         
1902         // create a bool to track if we have a non number character
1903         bool _hasNonNumber;
1904         
1905         // convert & check
1906         for (uint256 i = 0; i < _length; i++)
1907         {
1908             // if its uppercase A-Z
1909             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1910             {
1911                 // convert to lower case a-z
1912                 _temp[i] = byte(uint(_temp[i]) + 32);
1913                 
1914                 // we have a non number
1915                 if (_hasNonNumber == false)
1916                     _hasNonNumber = true;
1917             } else {
1918                 require
1919                 (
1920                     // require character is a space
1921                     _temp[i] == 0x20 || 
1922                     // OR lowercase a-z
1923                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1924                     // or 0-9
1925                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1926                     "string contains invalid characters"
1927                 );
1928                 // make sure theres not 2x spaces in a row
1929                 if (_temp[i] == 0x20)
1930                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1931                 
1932                 // see if we have a character other than a number
1933                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1934                     _hasNonNumber = true;    
1935             }
1936         }
1937         
1938         require(_hasNonNumber == true, "string cannot be only numbers");
1939         
1940         bytes32 _ret;
1941         assembly {
1942             _ret := mload(add(_temp, 32))
1943         }
1944         return (_ret);
1945     }
1946 }
1947 
1948 /**
1949  * @title SafeMath v0.1.9
1950  * @dev Math operations with safety checks that throw on error
1951  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1952  * - added sqrt
1953  * - added sq
1954  * - added pwr 
1955  * - changed asserts to requires with error log outputs
1956  * - removed div, its useless
1957  */
1958 library SafeMath {
1959     
1960     /**
1961     * @dev Multiplies two numbers, throws on overflow.
1962     */
1963     function mul(uint256 a, uint256 b) 
1964         internal 
1965         pure 
1966         returns (uint256 c) 
1967     {
1968         if (a == 0) {
1969             return 0;
1970         }
1971         c = a * b;
1972         require(c / a == b, "SafeMath mul failed");
1973         return c;
1974     }
1975 
1976     /**
1977     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1978     */
1979     function sub(uint256 a, uint256 b)
1980         internal
1981         pure
1982         returns (uint256) 
1983     {
1984         require(b <= a, "SafeMath sub failed");
1985         return a - b;
1986     }
1987 
1988     /**
1989     * @dev Adds two numbers, throws on overflow.
1990     */
1991     function add(uint256 a, uint256 b)
1992         internal
1993         pure
1994         returns (uint256 c) 
1995     {
1996         c = a + b;
1997         require(c >= a, "SafeMath add failed");
1998         return c;
1999     }
2000     
2001     /**
2002      * @dev gives square root of given x.
2003      */
2004     function sqrt(uint256 x)
2005         internal
2006         pure
2007         returns (uint256 y) 
2008     {
2009         uint256 z = ((add(x,1)) / 2);
2010         y = x;
2011         while (z < y) 
2012         {
2013             y = z;
2014             z = ((add((x / z),z)) / 2);
2015         }
2016     }
2017     
2018     /**
2019      * @dev gives square. multiplies x by x
2020      */
2021     function sq(uint256 x)
2022         internal
2023         pure
2024         returns (uint256)
2025     {
2026         return (mul(x,x));
2027     }
2028     
2029     /**
2030      * @dev x to the power of y 
2031      */
2032     function pwr(uint256 x, uint256 y)
2033         internal 
2034         pure 
2035         returns (uint256)
2036     {
2037         if (x==0)
2038             return (0);
2039         else if (y==0)
2040             return (1);
2041         else 
2042         {
2043             uint256 z = x;
2044             for (uint256 i=1; i < y; i++)
2045                 z = mul(z,x);
2046             return (z);
2047         }
2048     }
2049 }