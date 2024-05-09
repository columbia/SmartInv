1 pragma solidity ^0.4.24;
2 /**
3  * @title -FoMo-3D v0.7.0
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
44  *   │ Psaints, Satoshi, Vitalik, Nano 2nd, Bogdanoffs         Isacc Newton, Nikola Tesla, │ 
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
173 contract modularLong is F3Devents {}
174 
175 contract FoMo3Dlong is modularLong {
176     using SafeMath for *;
177     using NameFilter for string;
178     using F3DKeysCalcLong for uint256;
179 	
180 	otherFoMo3D private otherF3D_;
181     DiviesInterface constant private Divies = DiviesInterface(0x1a294b212BB37f790AeF81b91321A1111A177f45);
182     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
183 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
184     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x27AFcbe78bA41543c8e6eDe1ec0560cD128ADCCb);
185 //==============================================================================
186 //     _ _  _  |`. _     _ _ |_ | _  _  .
187 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
188 //=================_|===========================================================
189     string constant public name = "FoMo3D Long Official";
190     string constant public symbol = "F3D";
191 	uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO 
192     uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
193     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
194     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
195     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
196 //==============================================================================
197 //     _| _ _|_ _    _ _ _|_    _   .
198 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
199 //=============================|================================================
200 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
201     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
202     uint256 public rID_;    // round id number / total rounds that have happened
203 //****************
204 // PLAYER DATA 
205 //****************
206     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
207     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
208     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
209     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
210     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
211 //****************
212 // ROUND DATA 
213 //****************
214     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
215     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
216 //****************
217 // TEAM FEE DATA 
218 //****************
219     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
220     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
221 //==============================================================================
222 //     _ _  _  __|_ _    __|_ _  _  .
223 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
224 //==============================================================================
225     constructor()
226         public
227     {
228 		// Team allocation structures
229         // 0 = whales
230         // 1 = bears
231         // 2 = sneks
232         // 3 = bulls
233 
234 		// Team allocation percentages
235         // (F3D, P3D) + (Pot , Referrals, Community)
236             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
237         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
238         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
239         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
240         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
241         
242         // how to split up the final pot based on which team was picked
243         // (F3D, P3D)
244         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
245         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
246         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
247         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
248 	}
249 //==============================================================================
250 //     _ _  _  _|. |`. _  _ _  .
251 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
252 //==============================================================================
253     /**
254      * @dev used to make sure no one can interact with contract until it has 
255      * been activated. 
256      */
257     modifier isActivated() {
258         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
259         _;
260     }
261     
262     /**
263      * @dev prevents contracts from interacting with fomo3d 
264      */
265     modifier isHuman() {
266         address _addr = msg.sender;
267         uint256 _codeLength;
268         
269         assembly {_codeLength := extcodesize(_addr)}
270         require(_codeLength == 0, "sorry humans only");
271         _;
272     }
273 
274     /**
275      * @dev sets boundaries for incoming tx 
276      */
277     modifier isWithinLimits(uint256 _eth) {
278         require(_eth >= 1000000000, "pocket lint: not a valid currency");
279         require(_eth <= 100000000000000000000000, "no vitalik, no");
280         _;    
281     }
282     
283 //==============================================================================
284 //     _    |_ |. _   |`    _  __|_. _  _  _  .
285 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
286 //====|=========================================================================
287     /**
288      * @dev emergency buy uses last stored affiliate ID and team snek
289      */
290     function()
291         isActivated()
292         isHuman()
293         isWithinLimits(msg.value)
294         public
295         payable
296     {
297         // set up our tx event data and determine if player is new or not
298         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
299             
300         // fetch player id
301         uint256 _pID = pIDxAddr_[msg.sender];
302         
303         // buy core 
304         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
305     }
306     
307     /**
308      * @dev converts all incoming ethereum to keys.
309      * -functionhash- 0x8f38f309 (using ID for affiliate)
310      * -functionhash- 0x98a0871d (using address for affiliate)
311      * -functionhash- 0xa65b37a1 (using name for affiliate)
312      * @param _affCode the ID/address/name of the player who gets the affiliate fee
313      * @param _team what team is the player playing for?
314      */
315     function buyXid(uint256 _affCode, uint256 _team)
316         isActivated()
317         isHuman()
318         isWithinLimits(msg.value)
319         public
320         payable
321     {
322         // set up our tx event data and determine if player is new or not
323         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
324         
325         // fetch player id
326         uint256 _pID = pIDxAddr_[msg.sender];
327         
328         // manage affiliate residuals
329         // if no affiliate code was given or player tried to use their own, lolz
330         if (_affCode == 0 || _affCode == _pID)
331         {
332             // use last stored affiliate code 
333             _affCode = plyr_[_pID].laff;
334             
335         // if affiliate code was given & its not the same as previously stored 
336         } else if (_affCode != plyr_[_pID].laff) {
337             // update last affiliate 
338             plyr_[_pID].laff = _affCode;
339         }
340         
341         // verify a valid team was selected
342         _team = verifyTeam(_team);
343         
344         // buy core 
345         buyCore(_pID, _affCode, _team, _eventData_);
346     }
347     
348     function buyXaddr(address _affCode, uint256 _team)
349         isActivated()
350         isHuman()
351         isWithinLimits(msg.value)
352         public
353         payable
354     {
355         // set up our tx event data and determine if player is new or not
356         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
357         
358         // fetch player id
359         uint256 _pID = pIDxAddr_[msg.sender];
360         
361         // manage affiliate residuals
362         uint256 _affID;
363         // if no affiliate code was given or player tried to use their own, lolz
364         if (_affCode == address(0) || _affCode == msg.sender)
365         {
366             // use last stored affiliate code
367             _affID = plyr_[_pID].laff;
368         
369         // if affiliate code was given    
370         } else {
371             // get affiliate ID from aff Code 
372             _affID = pIDxAddr_[_affCode];
373             
374             // if affID is not the same as previously stored 
375             if (_affID != plyr_[_pID].laff)
376             {
377                 // update last affiliate
378                 plyr_[_pID].laff = _affID;
379             }
380         }
381         
382         // verify a valid team was selected
383         _team = verifyTeam(_team);
384         
385         // buy core 
386         buyCore(_pID, _affID, _team, _eventData_);
387     }
388     
389     function buyXname(bytes32 _affCode, uint256 _team)
390         isActivated()
391         isHuman()
392         isWithinLimits(msg.value)
393         public
394         payable
395     {
396         // set up our tx event data and determine if player is new or not
397         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
398         
399         // fetch player id
400         uint256 _pID = pIDxAddr_[msg.sender];
401         
402         // manage affiliate residuals
403         uint256 _affID;
404         // if no affiliate code was given or player tried to use their own, lolz
405         if (_affCode == '' || _affCode == plyr_[_pID].name)
406         {
407             // use last stored affiliate code
408             _affID = plyr_[_pID].laff;
409         
410         // if affiliate code was given
411         } else {
412             // get affiliate ID from aff Code
413             _affID = pIDxName_[_affCode];
414             
415             // if affID is not the same as previously stored
416             if (_affID != plyr_[_pID].laff)
417             {
418                 // update last affiliate
419                 plyr_[_pID].laff = _affID;
420             }
421         }
422         
423         // verify a valid team was selected
424         _team = verifyTeam(_team);
425         
426         // buy core 
427         buyCore(_pID, _affID, _team, _eventData_);
428     }
429     
430     /**
431      * @dev essentially the same as buy, but instead of you sending ether 
432      * from your wallet, it uses your unwithdrawn earnings.
433      * -functionhash- 0x349cdcac (using ID for affiliate)
434      * -functionhash- 0x82bfc739 (using address for affiliate)
435      * -functionhash- 0x079ce327 (using name for affiliate)
436      * @param _affCode the ID/address/name of the player who gets the affiliate fee
437      * @param _team what team is the player playing for?
438      * @param _eth amount of earnings to use (remainder returned to gen vault)
439      */
440     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
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
453         // if no affiliate code was given or player tried to use their own, lolz
454         if (_affCode == 0 || _affCode == _pID)
455         {
456             // use last stored affiliate code 
457             _affCode = plyr_[_pID].laff;
458             
459         // if affiliate code was given & its not the same as previously stored 
460         } else if (_affCode != plyr_[_pID].laff) {
461             // update last affiliate 
462             plyr_[_pID].laff = _affCode;
463         }
464 
465         // verify a valid team was selected
466         _team = verifyTeam(_team);
467 
468         // reload core
469         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
470     }
471     
472     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
473         isActivated()
474         isHuman()
475         isWithinLimits(_eth)
476         public
477     {
478         // set up our tx event data
479         F3Ddatasets.EventReturns memory _eventData_;
480         
481         // fetch player ID
482         uint256 _pID = pIDxAddr_[msg.sender];
483         
484         // manage affiliate residuals
485         uint256 _affID;
486         // if no affiliate code was given or player tried to use their own, lolz
487         if (_affCode == address(0) || _affCode == msg.sender)
488         {
489             // use last stored affiliate code
490             _affID = plyr_[_pID].laff;
491         
492         // if affiliate code was given    
493         } else {
494             // get affiliate ID from aff Code 
495             _affID = pIDxAddr_[_affCode];
496             
497             // if affID is not the same as previously stored 
498             if (_affID != plyr_[_pID].laff)
499             {
500                 // update last affiliate
501                 plyr_[_pID].laff = _affID;
502             }
503         }
504         
505         // verify a valid team was selected
506         _team = verifyTeam(_team);
507         
508         // reload core
509         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
510     }
511     
512     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
513         isActivated()
514         isHuman()
515         isWithinLimits(_eth)
516         public
517     {
518         // set up our tx event data
519         F3Ddatasets.EventReturns memory _eventData_;
520         
521         // fetch player ID
522         uint256 _pID = pIDxAddr_[msg.sender];
523         
524         // manage affiliate residuals
525         uint256 _affID;
526         // if no affiliate code was given or player tried to use their own, lolz
527         if (_affCode == '' || _affCode == plyr_[_pID].name)
528         {
529             // use last stored affiliate code
530             _affID = plyr_[_pID].laff;
531         
532         // if affiliate code was given
533         } else {
534             // get affiliate ID from aff Code
535             _affID = pIDxName_[_affCode];
536             
537             // if affID is not the same as previously stored
538             if (_affID != plyr_[_pID].laff)
539             {
540                 // update last affiliate
541                 plyr_[_pID].laff = _affID;
542             }
543         }
544         
545         // verify a valid team was selected
546         _team = verifyTeam(_team);
547         
548         // reload core
549         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
550     }
551 
552     /**
553      * @dev withdraws all of your earnings.
554      * -functionhash- 0x3ccfd60b
555      */
556     function withdraw()
557         isActivated()
558         isHuman()
559         public
560     {
561         // setup local rID 
562         uint256 _rID = rID_;
563         
564         // grab time
565         uint256 _now = now;
566         
567         // fetch player ID
568         uint256 _pID = pIDxAddr_[msg.sender];
569         
570         // setup temp var for player eth
571         uint256 _eth;
572         
573         // check to see if round has ended and no one has run round end yet
574         if (_now > round_[_rID].end && round_[_rID].ended == false)
575         {
576             // set up our tx event data
577             F3Ddatasets.EventReturns memory _eventData_;
578             
579             // end the round (distributes pot)
580 			round_[_rID].ended = true;
581             _eventData_ = endRound(_eventData_);
582             
583 			// get their earnings
584             _eth = withdrawEarnings(_pID);
585             
586             // gib moni
587             if (_eth > 0)
588                 plyr_[_pID].addr.transfer(_eth);    
589             
590             // build event data
591             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
592             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
593             
594             // fire withdraw and distribute event
595             emit F3Devents.onWithdrawAndDistribute
596             (
597                 msg.sender, 
598                 plyr_[_pID].name, 
599                 _eth, 
600                 _eventData_.compressedData, 
601                 _eventData_.compressedIDs, 
602                 _eventData_.winnerAddr, 
603                 _eventData_.winnerName, 
604                 _eventData_.amountWon, 
605                 _eventData_.newPot, 
606                 _eventData_.P3DAmount, 
607                 _eventData_.genAmount
608             );
609             
610         // in any other situation
611         } else {
612             // get their earnings
613             _eth = withdrawEarnings(_pID);
614             
615             // gib moni
616             if (_eth > 0)
617                 plyr_[_pID].addr.transfer(_eth);
618             
619             // fire withdraw event
620             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
621         }
622     }
623     
624     /**
625      * @dev use these to register names.  they are just wrappers that will send the
626      * registration requests to the PlayerBook contract.  So registering here is the 
627      * same as registering there.  UI will always display the last name you registered.
628      * but you will still own all previously registered names to use as affiliate 
629      * links.
630      * - must pay a registration fee.
631      * - name must be unique
632      * - names will be converted to lowercase
633      * - name cannot start or end with a space 
634      * - cannot have more than 1 space in a row
635      * - cannot be only numbers
636      * - cannot start with 0x 
637      * - name must be at least 1 char
638      * - max length of 32 characters long
639      * - allowed characters: a-z, 0-9, and space
640      * -functionhash- 0x921dec21 (using ID for affiliate)
641      * -functionhash- 0x3ddd4698 (using address for affiliate)
642      * -functionhash- 0x685ffd83 (using name for affiliate)
643      * @param _nameString players desired name
644      * @param _affCode affiliate ID, address, or name of who refered you
645      * @param _all set to true if you want this to push your info to all games 
646      * (this might cost a lot of gas)
647      */
648     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
649         isHuman()
650         public
651         payable
652     {
653         bytes32 _name = _nameString.nameFilter();
654         address _addr = msg.sender;
655         uint256 _paid = msg.value;
656         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
657         
658         uint256 _pID = pIDxAddr_[_addr];
659         
660         // fire event
661         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
662     }
663     
664     function registerNameXaddr(string _nameString, address _affCode, bool _all)
665         isHuman()
666         public
667         payable
668     {
669         bytes32 _name = _nameString.nameFilter();
670         address _addr = msg.sender;
671         uint256 _paid = msg.value;
672         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
673         
674         uint256 _pID = pIDxAddr_[_addr];
675         
676         // fire event
677         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
678     }
679     
680     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
681         isHuman()
682         public
683         payable
684     {
685         bytes32 _name = _nameString.nameFilter();
686         address _addr = msg.sender;
687         uint256 _paid = msg.value;
688         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
689         
690         uint256 _pID = pIDxAddr_[_addr];
691         
692         // fire event
693         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
694     }
695 //==============================================================================
696 //     _  _ _|__|_ _  _ _  .
697 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
698 //=====_|=======================================================================
699     /**
700      * @dev return the price buyer will pay for next 1 individual key.
701      * -functionhash- 0x018a25e8
702      * @return price for next key bought (in wei format)
703      */
704     function getBuyPrice()
705         public 
706         view 
707         returns(uint256)
708     {  
709         // setup local rID
710         uint256 _rID = rID_;
711         
712         // grab time
713         uint256 _now = now;
714         
715         // are we in a round?
716         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
717             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
718         else // rounds over.  need price for new round
719             return ( 75000000000000 ); // init
720     }
721     
722     /**
723      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
724      * provider
725      * -functionhash- 0xc7e284b8
726      * @return time left in seconds
727      */
728     function getTimeLeft()
729         public
730         view
731         returns(uint256)
732     {
733         // setup local rID
734         uint256 _rID = rID_;
735         
736         // grab time
737         uint256 _now = now;
738         
739         if (_now < round_[_rID].end)
740             if (_now < round_[_rID].strt + rndGap_)
741                 return( (round_[_rID].strt + rndGap_).sub(_now));
742             else 
743                 return( (round_[_rID].end).sub(_now) );
744         else
745             return(0);
746     }
747     
748     /**
749      * @dev returns player earnings per vaults 
750      * -functionhash- 0x63066434
751      * @return winnings vault
752      * @return general vault
753      * @return affiliate vault
754      */
755     function getPlayerVaults(uint256 _pID)
756         public
757         view
758         returns(uint256 ,uint256, uint256)
759     {
760         // setup local rID
761         uint256 _rID = rID_;
762         
763         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
764         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
765         {
766             // if player is winner 
767             if (round_[_rID].plyr == _pID)
768             {
769                 return
770                 (
771                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
772                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
773                     plyr_[_pID].aff
774                 );
775             // if player is not the winner
776             } else {
777                 return
778                 (
779                     plyr_[_pID].win,
780                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
781                     plyr_[_pID].aff
782                 );
783             }
784             
785         // if round is still going on, or round has ended and round end has been ran
786         } else {
787             return
788             (
789                 plyr_[_pID].win,
790                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
791                 plyr_[_pID].aff
792             );
793         }
794     }
795     
796     /**
797      * solidity hates stack limits.  this lets us avoid that hate 
798      */
799     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
800         private
801         view
802         returns(uint256)
803     {
804         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
805     }
806     
807     /**
808      * @dev returns all current round info needed for front end
809      * -functionhash- 0x747dff42
810      * @return eth invested during ICO phase
811      * @return round id 
812      * @return total keys for round 
813      * @return time round ends
814      * @return time round started
815      * @return current pot 
816      * @return current team ID & player ID in lead 
817      * @return current player in leads address 
818      * @return current player in leads name
819      * @return whales eth in for round
820      * @return bears eth in for round
821      * @return sneks eth in for round
822      * @return bulls eth in for round
823      * @return airdrop tracker # & airdrop pot
824      */
825     function getCurrentRoundInfo()
826         public
827         view
828         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
829     {
830         // setup local rID
831         uint256 _rID = rID_;
832         
833         return
834         (
835             round_[_rID].ico,               //0
836             _rID,                           //1
837             round_[_rID].keys,              //2
838             round_[_rID].end,               //3
839             round_[_rID].strt,              //4
840             round_[_rID].pot,               //5
841             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
842             plyr_[round_[_rID].plyr].addr,  //7
843             plyr_[round_[_rID].plyr].name,  //8
844             rndTmEth_[_rID][0],             //9
845             rndTmEth_[_rID][1],             //10
846             rndTmEth_[_rID][2],             //11
847             rndTmEth_[_rID][3],             //12
848             airDropTracker_ + (airDropPot_ * 1000)              //13
849         );
850     }
851 
852     /**
853      * @dev returns player info based on address.  if no address is given, it will 
854      * use msg.sender 
855      * -functionhash- 0xee0b5d8b
856      * @param _addr address of the player you want to lookup 
857      * @return player ID 
858      * @return player name
859      * @return keys owned (current round)
860      * @return winnings vault
861      * @return general vault 
862      * @return affiliate vault 
863 	 * @return player round eth
864      */
865     function getPlayerInfoByAddress(address _addr)
866         public 
867         view 
868         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
869     {
870         // setup local rID
871         uint256 _rID = rID_;
872         
873         if (_addr == address(0))
874         {
875             _addr == msg.sender;
876         }
877         uint256 _pID = pIDxAddr_[_addr];
878         
879         return
880         (
881             _pID,                               //0
882             plyr_[_pID].name,                   //1
883             plyrRnds_[_pID][_rID].keys,         //2
884             plyr_[_pID].win,                    //3
885             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
886             plyr_[_pID].aff,                    //5
887             plyrRnds_[_pID][_rID].eth           //6
888         );
889     }
890 
891 //==============================================================================
892 //     _ _  _ _   | _  _ . _  .
893 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
894 //=====================_|=======================================================
895     /**
896      * @dev logic runs whenever a buy order is executed.  determines how to handle 
897      * incoming eth depending on if we are in an active round or not
898      */
899     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
900         private
901     {
902         // setup local rID
903         uint256 _rID = rID_;
904         
905         // grab time
906         uint256 _now = now;
907         
908         // if round is active
909         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
910         {
911             // call core 
912             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
913         
914         // if round is not active     
915         } else {
916             // check to see if end round needs to be ran
917             if (_now > round_[_rID].end && round_[_rID].ended == false) 
918             {
919                 // end the round (distributes pot) & start new round
920 			    round_[_rID].ended = true;
921                 _eventData_ = endRound(_eventData_);
922                 
923                 // build event data
924                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
925                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
926                 
927                 // fire buy and distribute event 
928                 emit F3Devents.onBuyAndDistribute
929                 (
930                     msg.sender, 
931                     plyr_[_pID].name, 
932                     msg.value, 
933                     _eventData_.compressedData, 
934                     _eventData_.compressedIDs, 
935                     _eventData_.winnerAddr, 
936                     _eventData_.winnerName, 
937                     _eventData_.amountWon, 
938                     _eventData_.newPot, 
939                     _eventData_.P3DAmount, 
940                     _eventData_.genAmount
941                 );
942             }
943             
944             // put eth in players vault 
945             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
946         }
947     }
948     
949     /**
950      * @dev logic runs whenever a reload order is executed.  determines how to handle 
951      * incoming eth depending on if we are in an active round or not 
952      */
953     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
954         private
955     {
956         // setup local rID
957         uint256 _rID = rID_;
958         
959         // grab time
960         uint256 _now = now;
961         
962         // if round is active
963         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
964         {
965             // get earnings from all vaults and return unused to gen vault
966             // because we use a custom safemath library.  this will throw if player 
967             // tried to spend more eth than they have.
968             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
969             
970             // call core 
971             core(_rID, _pID, _eth, _affID, _team, _eventData_);
972         
973         // if round is not active and end round needs to be ran   
974         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
975             // end the round (distributes pot) & start new round
976             round_[_rID].ended = true;
977             _eventData_ = endRound(_eventData_);
978                 
979             // build event data
980             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
981             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
982                 
983             // fire buy and distribute event 
984             emit F3Devents.onReLoadAndDistribute
985             (
986                 msg.sender, 
987                 plyr_[_pID].name, 
988                 _eventData_.compressedData, 
989                 _eventData_.compressedIDs, 
990                 _eventData_.winnerAddr, 
991                 _eventData_.winnerName, 
992                 _eventData_.amountWon, 
993                 _eventData_.newPot, 
994                 _eventData_.P3DAmount, 
995                 _eventData_.genAmount
996             );
997         }
998     }
999     
1000     /**
1001      * @dev this is the core logic for any buy/reload that happens while a round 
1002      * is live.
1003      */
1004     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1005         private
1006     {
1007         // if player is new to round
1008         if (plyrRnds_[_pID][_rID].keys == 0)
1009             _eventData_ = managePlayer(_pID, _eventData_);
1010         
1011         // early round eth limiter 
1012         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1013         {
1014             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1015             uint256 _refund = _eth.sub(_availableLimit);
1016             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1017             _eth = _availableLimit;
1018         }
1019         
1020         // if eth left is greater than min eth allowed (sorry no pocket lint)
1021         if (_eth > 1000000000) 
1022         {
1023             
1024             // mint the new keys
1025             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1026             
1027             // if they bought at least 1 whole key
1028             if (_keys >= 1000000000000000000)
1029             {
1030             updateTimer(_keys, _rID);
1031 
1032             // set new leaders
1033             if (round_[_rID].plyr != _pID)
1034                 round_[_rID].plyr = _pID;  
1035             if (round_[_rID].team != _team)
1036                 round_[_rID].team = _team; 
1037             
1038             // set the new leader bool to true
1039             _eventData_.compressedData = _eventData_.compressedData + 100;
1040         }
1041             
1042             // manage airdrops
1043             if (_eth >= 100000000000000000)
1044             {
1045             airDropTracker_++;
1046             if (airdrop() == true)
1047             {
1048                 // gib muni
1049                 uint256 _prize;
1050                 if (_eth >= 10000000000000000000)
1051                 {
1052                     // calculate prize and give it to winner
1053                     _prize = ((airDropPot_).mul(75)) / 100;
1054                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1055                     
1056                     // adjust airDropPot 
1057                     airDropPot_ = (airDropPot_).sub(_prize);
1058                     
1059                     // let event know a tier 3 prize was won 
1060                     _eventData_.compressedData += 300000000000000000000000000000000;
1061                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1062                     // calculate prize and give it to winner
1063                     _prize = ((airDropPot_).mul(50)) / 100;
1064                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1065                     
1066                     // adjust airDropPot 
1067                     airDropPot_ = (airDropPot_).sub(_prize);
1068                     
1069                     // let event know a tier 2 prize was won 
1070                     _eventData_.compressedData += 200000000000000000000000000000000;
1071                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1072                     // calculate prize and give it to winner
1073                     _prize = ((airDropPot_).mul(25)) / 100;
1074                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1075                     
1076                     // adjust airDropPot 
1077                     airDropPot_ = (airDropPot_).sub(_prize);
1078                     
1079                     // let event know a tier 3 prize was won 
1080                     _eventData_.compressedData += 300000000000000000000000000000000;
1081                 }
1082                 // set airdrop happened bool to true
1083                 _eventData_.compressedData += 10000000000000000000000000000000;
1084                 // let event know how much was won 
1085                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1086                 
1087                 // reset air drop tracker
1088                 airDropTracker_ = 0;
1089             }
1090         }
1091     
1092             // store the air drop tracker number (number of buys since last airdrop)
1093             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1094             
1095             // update player 
1096             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1097             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1098             
1099             // update round
1100             round_[_rID].keys = _keys.add(round_[_rID].keys);
1101             round_[_rID].eth = _eth.add(round_[_rID].eth);
1102             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1103     
1104             // distribute eth
1105             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1106             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1107             
1108             // call end tx function to fire end tx event.
1109 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1110         }
1111     }
1112 //==============================================================================
1113 //     _ _ | _   | _ _|_ _  _ _  .
1114 //    (_(_||(_|_||(_| | (_)| _\  .
1115 //==============================================================================
1116     /**
1117      * @dev calculates unmasked earnings (just calculates, does not update mask)
1118      * @return earnings in wei format
1119      */
1120     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1121         private
1122         view
1123         returns(uint256)
1124     {
1125         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1126     }
1127     
1128     /** 
1129      * @dev returns the amount of keys you would get given an amount of eth. 
1130      * -functionhash- 0xce89c80c
1131      * @param _rID round ID you want price for
1132      * @param _eth amount of eth sent in 
1133      * @return keys received 
1134      */
1135     function calcKeysReceived(uint256 _rID, uint256 _eth)
1136         public
1137         view
1138         returns(uint256)
1139     {
1140         // grab time
1141         uint256 _now = now;
1142         
1143         // are we in a round?
1144         if (_now > round_[_rID].strt + rndGap_ && _now <= round_[_rID].end)
1145             return ( (round_[_rID].eth).keysRec(_eth) );
1146         else // rounds over.  need keys for new round
1147             return ( (_eth).keys() );
1148     }
1149     
1150     /** 
1151      * @dev returns current eth price for X keys.  
1152      * -functionhash- 0xcf808000
1153      * @param _keys number of keys desired (in 18 decimal format)
1154      * @return amount of eth needed to send
1155      */
1156     function iWantXKeys(uint256 _keys)
1157         public
1158         view
1159         returns(uint256)
1160     {
1161         // setup local rID
1162         uint256 _rID = rID_;
1163         
1164         // grab time
1165         uint256 _now = now;
1166         
1167         // are we in a round?
1168         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1169             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1170         else // rounds over.  need price for new round
1171             return ( (_keys).eth() );
1172     }
1173 //==============================================================================
1174 //    _|_ _  _ | _  .
1175 //     | (_)(_)|_\  .
1176 //==============================================================================
1177     /**
1178 	 * @dev receives name/player info from names contract 
1179      */
1180     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1181         external
1182     {
1183         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1184         if (pIDxAddr_[_addr] != _pID)
1185             pIDxAddr_[_addr] = _pID;
1186         if (pIDxName_[_name] != _pID)
1187             pIDxName_[_name] = _pID;
1188         if (plyr_[_pID].addr != _addr)
1189             plyr_[_pID].addr = _addr;
1190         if (plyr_[_pID].name != _name)
1191             plyr_[_pID].name = _name;
1192         if (plyr_[_pID].laff != _laff)
1193             plyr_[_pID].laff = _laff;
1194         if (plyrNames_[_pID][_name] == false)
1195             plyrNames_[_pID][_name] = true;
1196     }
1197     
1198     /**
1199      * @dev receives entire player name list 
1200      */
1201     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1202         external
1203     {
1204         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1205         if(plyrNames_[_pID][_name] == false)
1206             plyrNames_[_pID][_name] = true;
1207     }   
1208         
1209     /**
1210      * @dev gets existing or registers new pID.  use this when a player may be new
1211      * @return pID 
1212      */
1213     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1214         private
1215         returns (F3Ddatasets.EventReturns)
1216     {
1217         uint256 _pID = pIDxAddr_[msg.sender];
1218         // if player is new to this version of fomo3d
1219         if (_pID == 0)
1220         {
1221             // grab their player ID, name and last aff ID, from player names contract 
1222             _pID = PlayerBook.getPlayerID(msg.sender);
1223             bytes32 _name = PlayerBook.getPlayerName(_pID);
1224             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1225             
1226             // set up player account 
1227             pIDxAddr_[msg.sender] = _pID;
1228             plyr_[_pID].addr = msg.sender;
1229             
1230             if (_name != "")
1231             {
1232                 pIDxName_[_name] = _pID;
1233                 plyr_[_pID].name = _name;
1234                 plyrNames_[_pID][_name] = true;
1235             }
1236             
1237             if (_laff != 0 && _laff != _pID)
1238                 plyr_[_pID].laff = _laff;
1239             
1240             // set the new player bool to true
1241             _eventData_.compressedData = _eventData_.compressedData + 1;
1242         } 
1243         return (_eventData_);
1244     }
1245     
1246     /**
1247      * @dev checks to make sure user picked a valid team.  if not sets team 
1248      * to default (sneks)
1249      */
1250     function verifyTeam(uint256 _team)
1251         private
1252         pure
1253         returns (uint256)
1254     {
1255         if (_team < 0 || _team > 3)
1256             return(2);
1257         else
1258             return(_team);
1259     }
1260     
1261     /**
1262      * @dev decides if round end needs to be run & new round started.  and if 
1263      * player unmasked earnings from previously played rounds need to be moved.
1264      */
1265     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1266         private
1267         returns (F3Ddatasets.EventReturns)
1268     {
1269         // if player has played a previous round, move their unmasked earnings
1270         // from that round to gen vault.
1271         if (plyr_[_pID].lrnd != 0)
1272             updateGenVault(_pID, plyr_[_pID].lrnd);
1273             
1274         // update player's last round played
1275         plyr_[_pID].lrnd = rID_;
1276             
1277         // set the joined round bool to true
1278         _eventData_.compressedData = _eventData_.compressedData + 10;
1279         
1280         return(_eventData_);
1281     }
1282     
1283     /**
1284      * @dev ends the round. manages paying out winner/splitting up pot
1285      */
1286     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1287         private
1288         returns (F3Ddatasets.EventReturns)
1289     {
1290         // setup local rID
1291         uint256 _rID = rID_;
1292         
1293         // grab our winning player and team id's
1294         uint256 _winPID = round_[_rID].plyr;
1295         uint256 _winTID = round_[_rID].team;
1296         
1297         // grab our pot amount
1298         uint256 _pot = round_[_rID].pot;
1299         
1300         // calculate our winner share, community rewards, gen share, 
1301         // p3d share, and amount reserved for next pot 
1302         uint256 _win = (_pot.mul(48)) / 100;
1303         uint256 _com = (_pot / 50);
1304         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1305         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1306         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1307         
1308         // calculate ppt for round mask
1309         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1310         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1311         if (_dust > 0)
1312         {
1313             _gen = _gen.sub(_dust);
1314             _res = _res.add(_dust);
1315         }
1316         
1317         // pay our winner
1318         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1319         
1320         // community rewards
1321         Jekyll_Island_Inc.deposit.value(_com)();
1322         
1323         // distribute gen portion to key holders
1324         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1325         
1326         // send share for p3d to divies
1327         if (_p3d > 0)
1328             Divies.deposit.value(_p3d)();
1329             
1330         // prepare event data
1331         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1332         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1333         _eventData_.winnerAddr = plyr_[_winPID].addr;
1334         _eventData_.winnerName = plyr_[_winPID].name;
1335         _eventData_.amountWon = _win;
1336         _eventData_.genAmount = _gen;
1337         _eventData_.P3DAmount = _p3d;
1338         _eventData_.newPot = _res;
1339         
1340         // start next round
1341         rID_++;
1342         _rID++;
1343         round_[_rID].strt = now;
1344         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1345         round_[_rID].pot = _res;
1346         
1347         return(_eventData_);
1348     }
1349     
1350     /**
1351      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1352      */
1353     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1354         private 
1355     {
1356         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1357         if (_earnings > 0)
1358         {
1359             // put in gen vault
1360             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1361             // zero out their earnings by updating mask
1362             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1363         }
1364     }
1365     
1366     /**
1367      * @dev updates round timer based on number of whole keys bought.
1368      */
1369     function updateTimer(uint256 _keys, uint256 _rID)
1370         private
1371     {
1372         // grab time
1373         uint256 _now = now;
1374         
1375         // calculate time based on number of keys bought
1376         uint256 _newTime;
1377         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1378             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1379         else
1380             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1381         
1382         // compare to max and set new end time
1383         if (_newTime < (rndMax_).add(_now))
1384             round_[_rID].end = _newTime;
1385         else
1386             round_[_rID].end = rndMax_.add(_now);
1387     }
1388     
1389     /**
1390      * @dev generates a random number between 0-99 and checks to see if thats
1391      * resulted in an airdrop win
1392      * @return do we have a winner?
1393      */
1394     function airdrop()
1395         private 
1396         view 
1397         returns(bool)
1398     {
1399         uint256 seed = uint256(keccak256(abi.encodePacked(
1400             
1401             (block.timestamp).add
1402             (block.difficulty).add
1403             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1404             (block.gaslimit).add
1405             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1406             (block.number)
1407             
1408         )));
1409         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1410             return(true);
1411         else
1412             return(false);
1413     }
1414 
1415     /**
1416      * @dev distributes eth based on fees to com, aff, and p3d
1417      */
1418     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1419         private
1420         returns(F3Ddatasets.EventReturns)
1421     {
1422         // pay 2% out to community rewards
1423         uint256 _com = _eth / 50;
1424         Jekyll_Island_Inc.deposit.value(_com)();
1425         
1426         // pay 1% out to FoMo3D short
1427         uint256 _long = _eth / 100;
1428         otherF3D_.potSwap.value(_long)();
1429         
1430         // distribute share to affiliate
1431         uint256 _aff = _eth / 10;
1432         uint256 _p3d;
1433         
1434         // decide what to do with affiliate share of fees
1435         // affiliate must not be self, and must have a name registered
1436         if (_affID != _pID && plyr_[_affID].name != '') {
1437             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1438             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1439         } else {
1440             _p3d = _aff;
1441         }
1442         
1443         // pay out p3d
1444         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1445         if (_p3d > 0)
1446         {
1447             // deposit to divies contract
1448             Divies.deposit.value(_p3d)();
1449             
1450             // set up event data
1451             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1452         }
1453         
1454         return(_eventData_);
1455     }
1456     
1457     function potSwap()
1458         isActivated()
1459         external
1460         payable
1461     {
1462         // setup local rID
1463         uint256 _rID = rID_;
1464         
1465         if (now > round_[_rID].end && round_[_rID].ended == true)
1466         {
1467             round_[_rID + 1].pot = round_[_rID + 1].pot.add(msg.value);
1468             emit F3Devents.onPotSwapDeposit(_rID + 1, msg.value);
1469         } else {
1470             round_[_rID].pot = round_[_rID].pot.add(msg.value);
1471             emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1472         }
1473     }
1474     
1475     /**
1476      * @dev distributes eth based on fees to gen and pot
1477      */
1478     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1479         private
1480         returns(F3Ddatasets.EventReturns)
1481     {
1482         // calculate gen share
1483         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1484         
1485         // toss 1% into airdrop pot 
1486         uint256 _air = (_eth / 100);
1487         airDropPot_ = airDropPot_.add(_air);
1488         
1489         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1490         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1491         
1492         // calculate pot 
1493         uint256 _pot = _eth.sub(_gen);
1494         
1495         // distribute gen share (thats what updateMasks() does) and adjust
1496         // balances for dust.
1497         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1498         if (_dust > 0)
1499             _gen = _gen.sub(_dust);
1500         
1501         // add eth to pot
1502         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1503         
1504         // set up event data
1505         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1506         _eventData_.potAmount = _pot;
1507         
1508         return(_eventData_);
1509     }
1510 
1511     /**
1512      * @dev updates masks for round and player when keys are bought
1513      * @return dust left over 
1514      */
1515     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1516         private
1517         returns(uint256)
1518     {
1519         /* MASKING NOTES
1520             earnings masks are a tricky thing for people to wrap their minds around.
1521             the basic thing to understand here.  is were going to have a global
1522             tracker based on profit per share for each round, that increases in
1523             relevant proportion to the increase in share supply.
1524             
1525             the player will have an additional mask that basically says "based
1526             on the rounds mask, my shares, and how much i've already withdrawn,
1527             how much is still owed to me?"
1528         */
1529         
1530         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1531         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1532         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1533             
1534         // calculate player earning from their own buy (only based on the keys
1535         // they just bought).  & update player earnings mask
1536         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1537         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1538         
1539         // calculate & return dust
1540         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1541     }
1542     
1543     /**
1544      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1545      * @return earnings in wei format
1546      */
1547     function withdrawEarnings(uint256 _pID)
1548         private
1549         returns(uint256)
1550     {
1551         // update gen vault
1552         updateGenVault(_pID, plyr_[_pID].lrnd);
1553         
1554         // from vaults 
1555         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1556         if (_earnings > 0)
1557         {
1558             plyr_[_pID].win = 0;
1559             plyr_[_pID].gen = 0;
1560             plyr_[_pID].aff = 0;
1561         }
1562 
1563         return(_earnings);
1564     }
1565     
1566     /**
1567      * @dev prepares compression data and fires event for buy or reload tx's
1568      */
1569     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1570         private
1571     {
1572         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1573         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1574         
1575         emit F3Devents.onEndTx
1576         (
1577             _eventData_.compressedData,
1578             _eventData_.compressedIDs,
1579             plyr_[_pID].name,
1580             msg.sender,
1581             _eth,
1582             _keys,
1583             _eventData_.winnerAddr,
1584             _eventData_.winnerName,
1585             _eventData_.amountWon,
1586             _eventData_.newPot,
1587             _eventData_.P3DAmount,
1588             _eventData_.genAmount,
1589             _eventData_.potAmount,
1590             airDropPot_
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
1606             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1607             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1608             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1609             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1610 			msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1611             "only team just can activate"
1612         );
1613 
1614 		// make sure that its been linked.
1615         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1616         
1617         // can only be ran once
1618         require(activated_ == false, "fomo3d already activated");
1619         
1620         // activate the contract 
1621         activated_ = true;
1622         
1623         // lets start first round
1624 		rID_ = 1;
1625         round_[1].strt = now + rndExtra_ - rndGap_;
1626         round_[1].end = now + rndInit_ + rndExtra_;
1627     }
1628     function setOtherFomo(address _otherF3D)
1629         public
1630     {
1631         // only team just can activate 
1632         require(
1633             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1634             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1635             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1636             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1637 			msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1638             "only team just can activate"
1639         );
1640 
1641         // make sure that it HASNT yet been linked.
1642         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1643         
1644         // set up other fomo3d (fast or long) for pot swap
1645         otherF3D_ = otherFoMo3D(_otherF3D);
1646     }
1647 }
1648 
1649 //==============================================================================
1650 //   __|_ _    __|_ _  .
1651 //  _\ | | |_|(_ | _\  .
1652 //==============================================================================
1653 library F3Ddatasets {
1654     //compressedData key
1655     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1656         // 0 - new player (bool)
1657         // 1 - joined round (bool)
1658         // 2 - new  leader (bool)
1659         // 3-5 - air drop tracker (uint 0-999)
1660         // 6-16 - round end time
1661         // 17 - winnerTeam
1662         // 18 - 28 timestamp 
1663         // 29 - team
1664         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1665         // 31 - airdrop happened bool
1666         // 32 - airdrop tier 
1667         // 33 - airdrop amount won
1668     //compressedIDs key
1669     // [77-52][51-26][25-0]
1670         // 0-25 - pID 
1671         // 26-51 - winPID
1672         // 52-77 - rID
1673     struct EventReturns {
1674         uint256 compressedData;
1675         uint256 compressedIDs;
1676         address winnerAddr;         // winner address
1677         bytes32 winnerName;         // winner name
1678         uint256 amountWon;          // amount won
1679         uint256 newPot;             // amount in new pot
1680         uint256 P3DAmount;          // amount distributed to p3d
1681         uint256 genAmount;          // amount distributed to gen
1682         uint256 potAmount;          // amount added to pot
1683     }
1684     struct Player {
1685         address addr;   // player address
1686         bytes32 name;   // player name
1687         uint256 win;    // winnings vault
1688         uint256 gen;    // general vault
1689         uint256 aff;    // affiliate vault
1690         uint256 lrnd;   // last round played
1691         uint256 laff;   // last affiliate id used
1692     }
1693     struct PlayerRounds {
1694         uint256 eth;    // eth player has added to round (used for eth limiter)
1695         uint256 keys;   // keys
1696         uint256 mask;   // player mask 
1697         uint256 ico;    // ICO phase investment
1698     }
1699     struct Round {
1700         uint256 plyr;   // pID of player in lead
1701         uint256 team;   // tID of team in lead
1702         uint256 end;    // time ends/ended
1703         bool ended;     // has round end function been ran
1704         uint256 strt;   // time round started
1705         uint256 keys;   // keys
1706         uint256 eth;    // total eth in
1707         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1708         uint256 mask;   // global mask
1709         uint256 ico;    // total eth sent in during ICO phase
1710         uint256 icoGen; // total eth for gen during ICO phase
1711         uint256 icoAvg; // average key price for ICO phase
1712     }
1713     struct TeamFee {
1714         uint256 gen;    // % of buy in thats paid to key holders of current round
1715         uint256 p3d;    // % of buy in thats paid to p3d holders
1716     }
1717     struct PotSplit {
1718         uint256 gen;    // % of pot thats paid to key holders of current round
1719         uint256 p3d;    // % of pot thats paid to p3d holders
1720     }
1721 }
1722 
1723 //==============================================================================
1724 //  |  _      _ _ | _  .
1725 //  |<(/_\/  (_(_||(_  .
1726 //=======/======================================================================
1727 library F3DKeysCalcLong {
1728     using SafeMath for *;
1729     
1730     /**
1731      * @dev calculates number of keys received given X eth 
1732      * @param _curEth current amount of eth in contract 
1733      * @param _newEth eth being spent
1734      * @return amount of ticket purchased
1735      */
1736     function keysRec(uint256 _curEth, uint256 _newEth)
1737         internal
1738         pure
1739         returns (uint256)
1740     {
1741         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1742     }
1743     
1744     /**
1745      * @dev calculates amount of eth received if you sold X keys 
1746      * @param _curKeys current amount of keys that exist 
1747      * @param _sellKeys amount of keys you wish to sell
1748      * @return amount of eth received
1749      */
1750     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1751         internal
1752         pure
1753         returns (uint256)
1754     {
1755         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1756     }
1757 
1758     /**
1759      * @dev calculates how many keys would exist with given an amount of eth
1760      * @param _eth eth "in contract"
1761      * @return number of keys that would exist
1762      */
1763     function keys(uint256 _eth) 
1764         internal
1765         pure
1766         returns(uint256)
1767     {
1768         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1769     }
1770     
1771     /**
1772      * @dev calculates how much eth would be in contract given a number of keys
1773      * @param _keys number of keys "in contract" 
1774      * @return eth that would exists
1775      */
1776     function eth(uint256 _keys) 
1777         internal
1778         pure
1779         returns(uint256)  
1780     {
1781         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1782     }
1783 }
1784 
1785 //==============================================================================
1786 //  . _ _|_ _  _ |` _  _ _  _  .
1787 //  || | | (/_| ~|~(_|(_(/__\  .
1788 //==============================================================================
1789 interface otherFoMo3D {
1790     function potSwap() external payable;
1791 }
1792 
1793 interface F3DexternalSettingsInterface {
1794     function getFastGap() external returns(uint256);
1795     function getLongGap() external returns(uint256);
1796     function getFastExtra() external returns(uint256);
1797     function getLongExtra() external returns(uint256);
1798 }
1799 
1800 interface DiviesInterface {
1801     function deposit() external payable;
1802 }
1803 
1804 interface JIincForwarderInterface {
1805     function deposit() external payable returns(bool);
1806     function status() external view returns(address, address, bool);
1807     function startMigration(address _newCorpBank) external returns(bool);
1808     function cancelMigration() external returns(bool);
1809     function finishMigration() external returns(bool);
1810     function setup(address _firstCorpBank) external;
1811 }
1812 
1813 interface PlayerBookInterface {
1814     function getPlayerID(address _addr) external returns (uint256);
1815     function getPlayerName(uint256 _pID) external view returns (bytes32);
1816     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1817     function getPlayerAddr(uint256 _pID) external view returns (address);
1818     function getNameFee() external view returns (uint256);
1819     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1820     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1821     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1822 }
1823 
1824 /**
1825 * @title -Name Filter- v0.1.9
1826 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1827 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1828 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1829 *                                  _____                      _____
1830 *                                 (, /     /)       /) /)    (, /      /)          /)
1831 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1832 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1833 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1834 *                            (__ /          (_/ (, /                                      /)™ 
1835 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1836 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1837 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1838 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1839 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1840 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1841 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1842 *
1843 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1844 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1845 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1846 */
1847 
1848 library NameFilter {
1849     
1850     /**
1851      * @dev filters name strings
1852      * -converts uppercase to lower case.  
1853      * -makes sure it does not start/end with a space
1854      * -makes sure it does not contain multiple spaces in a row
1855      * -cannot be only numbers
1856      * -cannot start with 0x 
1857      * -restricts characters to A-Z, a-z, 0-9, and space.
1858      * @return reprocessed string in bytes32 format
1859      */
1860     function nameFilter(string _input)
1861         internal
1862         pure
1863         returns(bytes32)
1864     {
1865         bytes memory _temp = bytes(_input);
1866         uint256 _length = _temp.length;
1867         
1868         //sorry limited to 32 characters
1869         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1870         // make sure it doesnt start with or end with space
1871         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1872         // make sure first two characters are not 0x
1873         if (_temp[0] == 0x30)
1874         {
1875             require(_temp[1] != 0x78, "string cannot start with 0x");
1876             require(_temp[1] != 0x58, "string cannot start with 0X");
1877         }
1878         
1879         // create a bool to track if we have a non number character
1880         bool _hasNonNumber;
1881         
1882         // convert & check
1883         for (uint256 i = 0; i < _length; i++)
1884         {
1885             // if its uppercase A-Z
1886             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1887             {
1888                 // convert to lower case a-z
1889                 _temp[i] = byte(uint(_temp[i]) + 32);
1890                 
1891                 // we have a non number
1892                 if (_hasNonNumber == false)
1893                     _hasNonNumber = true;
1894             } else {
1895                 require
1896                 (
1897                     // require character is a space
1898                     _temp[i] == 0x20 || 
1899                     // OR lowercase a-z
1900                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1901                     // or 0-9
1902                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1903                     "string contains invalid characters"
1904                 );
1905                 // make sure theres not 2x spaces in a row
1906                 if (_temp[i] == 0x20)
1907                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1908                 
1909                 // see if we have a character other than a number
1910                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1911                     _hasNonNumber = true;    
1912             }
1913         }
1914         
1915         require(_hasNonNumber == true, "string cannot be only numbers");
1916         
1917         bytes32 _ret;
1918         assembly {
1919             _ret := mload(add(_temp, 32))
1920         }
1921         return (_ret);
1922     }
1923 }
1924 
1925 /**
1926  * @title SafeMath v0.1.9
1927  * @dev Math operations with safety checks that throw on error
1928  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1929  * - added sqrt
1930  * - added sq
1931  * - added pwr 
1932  * - changed asserts to requires with error log outputs
1933  * - removed div, its useless
1934  */
1935 library SafeMath {
1936     
1937     /**
1938     * @dev Multiplies two numbers, throws on overflow.
1939     */
1940     function mul(uint256 a, uint256 b) 
1941         internal 
1942         pure 
1943         returns (uint256 c) 
1944     {
1945         if (a == 0) {
1946             return 0;
1947         }
1948         c = a * b;
1949         require(c / a == b, "SafeMath mul failed");
1950         return c;
1951     }
1952 
1953     /**
1954     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1955     */
1956     function sub(uint256 a, uint256 b)
1957         internal
1958         pure
1959         returns (uint256) 
1960     {
1961         require(b <= a, "SafeMath sub failed");
1962         return a - b;
1963     }
1964 
1965     /**
1966     * @dev Adds two numbers, throws on overflow.
1967     */
1968     function add(uint256 a, uint256 b)
1969         internal
1970         pure
1971         returns (uint256 c) 
1972     {
1973         c = a + b;
1974         require(c >= a, "SafeMath add failed");
1975         return c;
1976     }
1977     
1978     /**
1979      * @dev gives square root of given x.
1980      */
1981     function sqrt(uint256 x)
1982         internal
1983         pure
1984         returns (uint256 y) 
1985     {
1986         uint256 z = ((add(x,1)) / 2);
1987         y = x;
1988         while (z < y) 
1989         {
1990             y = z;
1991             z = ((add((x / z),z)) / 2);
1992         }
1993     }
1994     
1995     /**
1996      * @dev gives square. multiplies x by x
1997      */
1998     function sq(uint256 x)
1999         internal
2000         pure
2001         returns (uint256)
2002     {
2003         return (mul(x,x));
2004     }
2005     
2006     /**
2007      * @dev x to the power of y 
2008      */
2009     function pwr(uint256 x, uint256 y)
2010         internal 
2011         pure 
2012         returns (uint256)
2013     {
2014         if (x==0)
2015             return (0);
2016         else if (y==0)
2017             return (1);
2018         else 
2019         {
2020             uint256 z = x;
2021             for (uint256 i=1; i < y; i++)
2022                 z = mul(z,x);
2023             return (z);
2024         }
2025     }
2026 }