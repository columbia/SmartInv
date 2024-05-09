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
177 
178 contract modularLong is F3Devents {}
179 
180 contract FoMo3Dlong is modularLong {
181     using SafeMath for *;
182     using NameFilter for string;
183     using F3DKeysCalcLong for uint256;
184     
185     otherFoMo3D private otherF3D_;
186     DiviesInterface constant private Divies = DiviesInterface(0xf54643360a7a1a74c107b8847dab1e40d544bf19);
187     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x9524d6bef8fcd03edc10822ba13b9533a0b3fb58);
188     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xe095c3362ecb60663cb6e9fbd20de2988638f34c);
189 
190 //==============================================================================
191 //     _ _  _  |`. _     _ _ |_ | _  _  .
192 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
193 //=================_|===========================================================
194     string constant public name = "FoMo3D Long Official";
195     string constant public symbol = "F3D";
196     uint256 private rndExtra_ = 30 minutes;     // length of the very first ICO
197     uint256 private rndGap_ = 30 minutes;         // length of ICO phase, set to 1 year for EOS.
198     uint256 constant private rndInit_ = 10 minutes;                // round timer starts at this
199     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
200     uint256 constant private rndMax_ = 2 minutes;                // max length a round timer can be
201 //==============================================================================
202 //     _| _ _|_ _    _ _ _|_    _   .
203 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
204 //=============================|================================================
205     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
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
226 //==============================================================================
227 //     _ _  _  __|_ _    __|_ _  _  .
228 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
229 //==============================================================================
230     constructor()
231         public
232     {
233         // Team allocation structures
234         // 0 = whales
235         // 1 = bears
236         // 2 = sneks
237         // 3 = bulls
238 
239         // Team allocation percentages
240         // (F3D, P3D) + (Pot , Referrals, Community)
241             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
242         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
243         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
244         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
245         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
246         
247         // how to split up the final pot based on which team was picked
248         // (F3D, P3D)
249         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
250         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
251         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
252         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
253     }
254 //==============================================================================
255 //     _ _  _  _|. |`. _  _ _  .
256 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
257 //==============================================================================
258     /**
259      * @dev used to make sure no one can interact with contract until it has 
260      * been activated. 
261      */
262     modifier isActivated() {
263         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
264         _;
265     }
266     
267     /**
268      * @dev prevents contracts from interacting with fomo3d 
269      */
270     modifier isHuman() {
271         address _addr = msg.sender;
272         uint256 _codeLength;
273         
274         assembly {_codeLength := extcodesize(_addr)}
275         require(_codeLength == 0, "sorry humans only");
276         _;
277     }
278 
279     /**
280      * @dev sets boundaries for incoming tx 
281      */
282     modifier isWithinLimits(uint256 _eth) {
283         require(_eth >= 1000000000, "pocket lint: not a valid currency");
284         require(_eth <= 100000000000000000000000, "no vitalik, no");
285         _;    
286     }
287     
288 //==============================================================================
289 //     _    |_ |. _   |`    _  __|_. _  _  _  .
290 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
291 //====|=========================================================================
292     /**
293      * @dev emergency buy uses last stored affiliate ID and team snek
294      */
295     function()
296         isActivated()
297         isHuman()
298         isWithinLimits(msg.value)
299         public
300         payable
301     {
302         // set up our tx event data and determine if player is new or not
303         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
304             
305         // fetch player id
306         uint256 _pID = pIDxAddr_[msg.sender];
307         
308         // buy core 
309         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
310     }
311     
312     /**
313      * @dev converts all incoming ethereum to keys.
314      * -functionhash- 0x8f38f309 (using ID for affiliate)
315      * -functionhash- 0x98a0871d (using address for affiliate)
316      * -functionhash- 0xa65b37a1 (using name for affiliate)
317      * @param _affCode the ID/address/name of the player who gets the affiliate fee
318      * @param _team what team is the player playing for?
319      */
320     function buyXid(uint256 _affCode, uint256 _team)
321         isActivated()
322         isHuman()
323         isWithinLimits(msg.value)
324         public
325         payable
326     {
327         // set up our tx event data and determine if player is new or not
328         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
329         
330         // fetch player id
331         uint256 _pID = pIDxAddr_[msg.sender];
332         
333         // manage affiliate residuals
334         // if no affiliate code was given or player tried to use their own, lolz
335         if (_affCode == 0 || _affCode == _pID)
336         {
337             // use last stored affiliate code 
338             _affCode = plyr_[_pID].laff;
339             
340         // if affiliate code was given & its not the same as previously stored 
341         } else if (_affCode != plyr_[_pID].laff) {
342             // update last affiliate 
343             plyr_[_pID].laff = _affCode;
344         }
345         
346         // verify a valid team was selected
347         _team = verifyTeam(_team);
348         
349         // buy core 
350         buyCore(_pID, _affCode, _team, _eventData_);
351     }
352     
353     function buyXaddr(address _affCode, uint256 _team)
354         isActivated()
355         isHuman()
356         isWithinLimits(msg.value)
357         public
358         payable
359     {
360         // set up our tx event data and determine if player is new or not
361         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
362         
363         // fetch player id
364         uint256 _pID = pIDxAddr_[msg.sender];
365         
366         // manage affiliate residuals
367         uint256 _affID;
368         // if no affiliate code was given or player tried to use their own, lolz
369         if (_affCode == address(0) || _affCode == msg.sender)
370         {
371             // use last stored affiliate code
372             _affID = plyr_[_pID].laff;
373         
374         // if affiliate code was given    
375         } else {
376             // get affiliate ID from aff Code 
377             _affID = pIDxAddr_[_affCode];
378             
379             // if affID is not the same as previously stored 
380             if (_affID != plyr_[_pID].laff)
381             {
382                 // update last affiliate
383                 plyr_[_pID].laff = _affID;
384             }
385         }
386         
387         // verify a valid team was selected
388         _team = verifyTeam(_team);
389         
390         // buy core 
391         buyCore(_pID, _affID, _team, _eventData_);
392     }
393     
394     function buyXname(bytes32 _affCode, uint256 _team)
395         isActivated()
396         isHuman()
397         isWithinLimits(msg.value)
398         public
399         payable
400     {
401         // set up our tx event data and determine if player is new or not
402         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
403         
404         // fetch player id
405         uint256 _pID = pIDxAddr_[msg.sender];
406         
407         // manage affiliate residuals
408         uint256 _affID;
409         // if no affiliate code was given or player tried to use their own, lolz
410         if (_affCode == '' || _affCode == plyr_[_pID].name)
411         {
412             // use last stored affiliate code
413             _affID = plyr_[_pID].laff;
414         
415         // if affiliate code was given
416         } else {
417             // get affiliate ID from aff Code
418             _affID = pIDxName_[_affCode];
419             
420             // if affID is not the same as previously stored
421             if (_affID != plyr_[_pID].laff)
422             {
423                 // update last affiliate
424                 plyr_[_pID].laff = _affID;
425             }
426         }
427         
428         // verify a valid team was selected
429         _team = verifyTeam(_team);
430         
431         // buy core 
432         buyCore(_pID, _affID, _team, _eventData_);
433     }
434     
435     /**
436      * @dev essentially the same as buy, but instead of you sending ether 
437      * from your wallet, it uses your unwithdrawn earnings.
438      * -functionhash- 0x349cdcac (using ID for affiliate)
439      * -functionhash- 0x82bfc739 (using address for affiliate)
440      * -functionhash- 0x079ce327 (using name for affiliate)
441      * @param _affCode the ID/address/name of the player who gets the affiliate fee
442      * @param _team what team is the player playing for?
443      * @param _eth amount of earnings to use (remainder returned to gen vault)
444      */
445     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
446         isActivated()
447         isHuman()
448         isWithinLimits(_eth)
449         public
450     {
451         // set up our tx event data
452         F3Ddatasets.EventReturns memory _eventData_;
453         
454         // fetch player ID
455         uint256 _pID = pIDxAddr_[msg.sender];
456         
457         // manage affiliate residuals
458         // if no affiliate code was given or player tried to use their own, lolz
459         if (_affCode == 0 || _affCode == _pID)
460         {
461             // use last stored affiliate code 
462             _affCode = plyr_[_pID].laff;
463             
464         // if affiliate code was given & its not the same as previously stored 
465         } else if (_affCode != plyr_[_pID].laff) {
466             // update last affiliate 
467             plyr_[_pID].laff = _affCode;
468         }
469 
470         // verify a valid team was selected
471         _team = verifyTeam(_team);
472 
473         // reload core
474         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
475     }
476     
477     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
478         isActivated()
479         isHuman()
480         isWithinLimits(_eth)
481         public
482     {
483         // set up our tx event data
484         F3Ddatasets.EventReturns memory _eventData_;
485         
486         // fetch player ID
487         uint256 _pID = pIDxAddr_[msg.sender];
488         
489         // manage affiliate residuals
490         uint256 _affID;
491         // if no affiliate code was given or player tried to use their own, lolz
492         if (_affCode == address(0) || _affCode == msg.sender)
493         {
494             // use last stored affiliate code
495             _affID = plyr_[_pID].laff;
496         
497         // if affiliate code was given    
498         } else {
499             // get affiliate ID from aff Code 
500             _affID = pIDxAddr_[_affCode];
501             
502             // if affID is not the same as previously stored 
503             if (_affID != plyr_[_pID].laff)
504             {
505                 // update last affiliate
506                 plyr_[_pID].laff = _affID;
507             }
508         }
509         
510         // verify a valid team was selected
511         _team = verifyTeam(_team);
512         
513         // reload core
514         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
515     }
516     
517     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
518         isActivated()
519         isHuman()
520         isWithinLimits(_eth)
521         public
522     {
523         // set up our tx event data
524         F3Ddatasets.EventReturns memory _eventData_;
525         
526         // fetch player ID
527         uint256 _pID = pIDxAddr_[msg.sender];
528         
529         // manage affiliate residuals
530         uint256 _affID;
531         // if no affiliate code was given or player tried to use their own, lolz
532         if (_affCode == '' || _affCode == plyr_[_pID].name)
533         {
534             // use last stored affiliate code
535             _affID = plyr_[_pID].laff;
536         
537         // if affiliate code was given
538         } else {
539             // get affiliate ID from aff Code
540             _affID = pIDxName_[_affCode];
541             
542             // if affID is not the same as previously stored
543             if (_affID != plyr_[_pID].laff)
544             {
545                 // update last affiliate
546                 plyr_[_pID].laff = _affID;
547             }
548         }
549         
550         // verify a valid team was selected
551         _team = verifyTeam(_team);
552         
553         // reload core
554         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
555     }
556 
557     /**
558      * @dev withdraws all of your earnings.
559      * -functionhash- 0x3ccfd60b
560      */
561     function withdraw()
562         isActivated()
563         isHuman()
564         public
565     {
566         // setup local rID 
567         uint256 _rID = rID_;
568         
569         // grab time
570         uint256 _now = now;
571         
572         // fetch player ID
573         uint256 _pID = pIDxAddr_[msg.sender];
574         
575         // setup temp var for player eth
576         uint256 _eth;
577         
578         // check to see if round has ended and no one has run round end yet
579         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
580         {
581             // set up our tx event data
582             F3Ddatasets.EventReturns memory _eventData_;
583             
584             // end the round (distributes pot)
585             round_[_rID].ended = true;
586             _eventData_ = endRound(_eventData_);
587             
588             // get their earnings
589             _eth = withdrawEarnings(_pID);
590             
591             // gib moni
592             if (_eth > 0)
593                 plyr_[_pID].addr.transfer(_eth);    
594             
595             // build event data
596             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
597             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
598             
599             // fire withdraw and distribute event
600             emit F3Devents.onWithdrawAndDistribute
601             (
602                 msg.sender, 
603                 plyr_[_pID].name, 
604                 _eth, 
605                 _eventData_.compressedData, 
606                 _eventData_.compressedIDs, 
607                 _eventData_.winnerAddr, 
608                 _eventData_.winnerName, 
609                 _eventData_.amountWon, 
610                 _eventData_.newPot, 
611                 _eventData_.P3DAmount, 
612                 _eventData_.genAmount
613             );
614             
615         // in any other situation
616         } else {
617             // get their earnings
618             _eth = withdrawEarnings(_pID);
619             
620             // gib moni
621             if (_eth > 0)
622                 plyr_[_pID].addr.transfer(_eth);
623             
624             // fire withdraw event
625             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
626         }
627     }
628     
629     /**
630      * @dev use these to register names.  they are just wrappers that will send the
631      * registration requests to the PlayerBook contract.  So registering here is the 
632      * same as registering there.  UI will always display the last name you registered.
633      * but you will still own all previously registered names to use as affiliate 
634      * links.
635      * - must pay a registration fee.
636      * - name must be unique
637      * - names will be converted to lowercase
638      * - name cannot start or end with a space 
639      * - cannot have more than 1 space in a row
640      * - cannot be only numbers
641      * - cannot start with 0x 
642      * - name must be at least 1 char
643      * - max length of 32 characters long
644      * - allowed characters: a-z, 0-9, and space
645      * -functionhash- 0x921dec21 (using ID for affiliate)
646      * -functionhash- 0x3ddd4698 (using address for affiliate)
647      * -functionhash- 0x685ffd83 (using name for affiliate)
648      * @param _nameString players desired name
649      * @param _affCode affiliate ID, address, or name of who referred you
650      * @param _all set to true if you want this to push your info to all games 
651      * (this might cost a lot of gas)
652      */
653     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
654         isHuman()
655         public
656         payable
657     {
658         bytes32 _name = _nameString.nameFilter();
659         address _addr = msg.sender;
660         uint256 _paid = msg.value;
661         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
662         
663         uint256 _pID = pIDxAddr_[_addr];
664         
665         // fire event
666         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
667     }
668     
669     function registerNameXaddr(string _nameString, address _affCode, bool _all)
670         isHuman()
671         public
672         payable
673     {
674         bytes32 _name = _nameString.nameFilter();
675         address _addr = msg.sender;
676         uint256 _paid = msg.value;
677         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
678         
679         uint256 _pID = pIDxAddr_[_addr];
680         
681         // fire event
682         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
683     }
684     
685     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
686         isHuman()
687         public
688         payable
689     {
690         bytes32 _name = _nameString.nameFilter();
691         address _addr = msg.sender;
692         uint256 _paid = msg.value;
693         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
694         
695         uint256 _pID = pIDxAddr_[_addr];
696         
697         // fire event
698         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
699     }
700 //==============================================================================
701 //     _  _ _|__|_ _  _ _  .
702 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
703 //=====_|=======================================================================
704     /**
705      * @dev return the price buyer will pay for next 1 individual key.
706      * -functionhash- 0x018a25e8
707      * @return price for next key bought (in wei format)
708      */
709     function getBuyPrice()
710         public 
711         view 
712         returns(uint256)
713     {  
714         // setup local rID
715         uint256 _rID = rID_;
716         
717         // grab time
718         uint256 _now = now;
719         
720         // are we in a round?
721         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
722             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
723         else // rounds over.  need price for new round
724             return ( 75000000000000 ); // init
725     }
726     
727     /**
728      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
729      * provider
730      * -functionhash- 0xc7e284b8
731      * @return time left in seconds
732      */
733     function getTimeLeft()
734         public
735         view
736         returns(uint256)
737     {
738         // setup local rID
739         uint256 _rID = rID_;
740         
741         // grab time
742         uint256 _now = now;
743         
744         if (_now < round_[_rID].end)
745             if (_now > round_[_rID].strt + rndGap_)
746                 return( (round_[_rID].end).sub(_now) );
747             else
748                 return( (round_[_rID].strt + rndGap_).sub(_now) );
749         else
750             return(0);
751     }
752     
753     /**
754      * @dev returns player earnings per vaults 
755      * -functionhash- 0x63066434
756      * @return winnings vault
757      * @return general vault
758      * @return affiliate vault
759      */
760     function getPlayerVaults(uint256 _pID)
761         public
762         view
763         returns(uint256 ,uint256, uint256)
764     {
765         // setup local rID
766         uint256 _rID = rID_;
767         
768         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
769         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
770         {
771             // if player is winner 
772             if (round_[_rID].plyr == _pID)
773             {
774                 return
775                 (
776                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
777                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
778                     plyr_[_pID].aff
779                 );
780             // if player is not the winner
781             } else {
782                 return
783                 (
784                     plyr_[_pID].win,
785                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
786                     plyr_[_pID].aff
787                 );
788             }
789             
790         // if round is still going on, or round has ended and round end has been ran
791         } else {
792             return
793             (
794                 plyr_[_pID].win,
795                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
796                 plyr_[_pID].aff
797             );
798         }
799     }
800     
801     /**
802      * solidity hates stack limits.  this lets us avoid that hate 
803      */
804     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
805         private
806         view
807         returns(uint256)
808     {
809         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
810     }
811     
812     /**
813      * @dev returns all current round info needed for front end
814      * -functionhash- 0x747dff42
815      * @return eth invested during ICO phase
816      * @return round id 
817      * @return total keys for round 
818      * @return time round ends
819      * @return time round started
820      * @return current pot 
821      * @return current team ID & player ID in lead 
822      * @return current player in leads address 
823      * @return current player in leads name
824      * @return whales eth in for round
825      * @return bears eth in for round
826      * @return sneks eth in for round
827      * @return bulls eth in for round
828      * @return airdrop tracker # & airdrop pot
829      */
830     function getCurrentRoundInfo()
831         public
832         view
833         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
834     {
835         // setup local rID
836         uint256 _rID = rID_;
837         
838         return
839         (
840             round_[_rID].ico,               //0
841             _rID,                           //1
842             round_[_rID].keys,              //2
843             round_[_rID].end,               //3
844             round_[_rID].strt,              //4
845             round_[_rID].pot,               //5
846             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
847             plyr_[round_[_rID].plyr].addr,  //7
848             plyr_[round_[_rID].plyr].name,  //8
849             rndTmEth_[_rID][0],             //9
850             rndTmEth_[_rID][1],             //10
851             rndTmEth_[_rID][2],             //11
852             rndTmEth_[_rID][3],             //12
853             airDropTracker_ + (airDropPot_ * 1000)              //13
854         );
855     }
856 
857     /**
858      * @dev returns player info based on address.  if no address is given, it will 
859      * use msg.sender 
860      * -functionhash- 0xee0b5d8b
861      * @param _addr address of the player you want to lookup 
862      * @return player ID 
863      * @return player name
864      * @return keys owned (current round)
865      * @return winnings vault
866      * @return general vault 
867      * @return affiliate vault 
868      * @return player round eth
869      */
870     function getPlayerInfoByAddress(address _addr)
871         public 
872         view 
873         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
874     {
875         // setup local rID
876         uint256 _rID = rID_;
877         
878         if (_addr == address(0))
879         {
880             _addr == msg.sender;
881         }
882         uint256 _pID = pIDxAddr_[_addr];
883         
884         return
885         (
886             _pID,                               //0
887             plyr_[_pID].name,                   //1
888             plyrRnds_[_pID][_rID].keys,         //2
889             plyr_[_pID].win,                    //3
890             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
891             plyr_[_pID].aff,                    //5
892             plyrRnds_[_pID][_rID].eth           //6
893         );
894     }
895 
896 //==============================================================================
897 //     _ _  _ _   | _  _ . _  .
898 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
899 //=====================_|=======================================================
900     /**
901      * @dev logic runs whenever a buy order is executed.  determines how to handle 
902      * incoming eth depending on if we are in an active round or not
903      */
904     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
905         private
906     {
907         // setup local rID
908         uint256 _rID = rID_;
909         
910         // grab time
911         uint256 _now = now;
912         
913         // if round is active
914         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
915         {
916             // call core 
917             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
918         
919         // if round is not active     
920         } else {
921             // check to see if end round needs to be ran
922             if (_now > round_[_rID].end && round_[_rID].ended == false) 
923             {
924                 // end the round (distributes pot) & start new round
925                 round_[_rID].ended = true;
926                 _eventData_ = endRound(_eventData_);
927                 
928                 // build event data
929                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
930                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
931                 
932                 // fire buy and distribute event 
933                 emit F3Devents.onBuyAndDistribute
934                 (
935                     msg.sender, 
936                     plyr_[_pID].name, 
937                     msg.value, 
938                     _eventData_.compressedData, 
939                     _eventData_.compressedIDs, 
940                     _eventData_.winnerAddr, 
941                     _eventData_.winnerName, 
942                     _eventData_.amountWon, 
943                     _eventData_.newPot, 
944                     _eventData_.P3DAmount, 
945                     _eventData_.genAmount
946                 );
947             }
948             
949             // put eth in players vault 
950             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
951         }
952     }
953     
954     /**
955      * @dev logic runs whenever a reload order is executed.  determines how to handle 
956      * incoming eth depending on if we are in an active round or not 
957      */
958     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
959         private
960     {
961         // setup local rID
962         uint256 _rID = rID_;
963         
964         // grab time
965         uint256 _now = now;
966         
967         // if round is active
968         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
969         {
970             // get earnings from all vaults and return unused to gen vault
971             // because we use a custom safemath library.  this will throw if player 
972             // tried to spend more eth than they have.
973             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
974             
975             // call core 
976             core(_rID, _pID, _eth, _affID, _team, _eventData_);
977         
978         // if round is not active and end round needs to be ran   
979         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
980             // end the round (distributes pot) & start new round
981             round_[_rID].ended = true;
982             _eventData_ = endRound(_eventData_);
983                 
984             // build event data
985             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
986             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
987                 
988             // fire buy and distribute event 
989             emit F3Devents.onReLoadAndDistribute
990             (
991                 msg.sender, 
992                 plyr_[_pID].name, 
993                 _eventData_.compressedData, 
994                 _eventData_.compressedIDs, 
995                 _eventData_.winnerAddr, 
996                 _eventData_.winnerName, 
997                 _eventData_.amountWon, 
998                 _eventData_.newPot, 
999                 _eventData_.P3DAmount, 
1000                 _eventData_.genAmount
1001             );
1002         }
1003     }
1004     
1005     /**
1006      * @dev this is the core logic for any buy/reload that happens while a round 
1007      * is live.
1008      */
1009     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1010         private
1011     {
1012         // if player is new to round
1013         if (plyrRnds_[_pID][_rID].keys == 0)
1014             _eventData_ = managePlayer(_pID, _eventData_);
1015         
1016         // early round eth limiter 
1017         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1018         {
1019             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1020             uint256 _refund = _eth.sub(_availableLimit);
1021             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1022             _eth = _availableLimit;
1023         }
1024         
1025         // if eth left is greater than min eth allowed (sorry no pocket lint)
1026         if (_eth > 1000000000) 
1027         {
1028             
1029             // mint the new keys
1030             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1031             
1032             // if they bought at least 1 whole key
1033             if (_keys >= 1000000000000000000)
1034             {
1035             updateTimer(_keys, _rID);
1036 
1037             // set new leaders
1038             if (round_[_rID].plyr != _pID)
1039                 round_[_rID].plyr = _pID;  
1040             if (round_[_rID].team != _team)
1041                 round_[_rID].team = _team; 
1042             
1043             // set the new leader bool to true
1044             _eventData_.compressedData = _eventData_.compressedData + 100;
1045         }
1046             
1047             // manage airdrops
1048             if (_eth >= 100000000000000000)
1049             {
1050             airDropTracker_++;
1051             if (airdrop() == true)
1052             {
1053                 // gib muni
1054                 uint256 _prize;
1055                 if (_eth >= 10000000000000000000)
1056                 {
1057                     // calculate prize and give it to winner
1058                     _prize = ((airDropPot_).mul(75)) / 100;
1059                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1060                     
1061                     // adjust airDropPot 
1062                     airDropPot_ = (airDropPot_).sub(_prize);
1063                     
1064                     // let event know a tier 3 prize was won 
1065                     _eventData_.compressedData += 300000000000000000000000000000000;
1066                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1067                     // calculate prize and give it to winner
1068                     _prize = ((airDropPot_).mul(50)) / 100;
1069                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1070                     
1071                     // adjust airDropPot 
1072                     airDropPot_ = (airDropPot_).sub(_prize);
1073                     
1074                     // let event know a tier 2 prize was won 
1075                     _eventData_.compressedData += 200000000000000000000000000000000;
1076                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1077                     // calculate prize and give it to winner
1078                     _prize = ((airDropPot_).mul(25)) / 100;
1079                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1080                     
1081                     // adjust airDropPot 
1082                     airDropPot_ = (airDropPot_).sub(_prize);
1083                     
1084                     // let event know a tier 3 prize was won 
1085                     _eventData_.compressedData += 300000000000000000000000000000000;
1086                 }
1087                 // set airdrop happened bool to true
1088                 _eventData_.compressedData += 10000000000000000000000000000000;
1089                 // let event know how much was won 
1090                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1091                 
1092                 // reset air drop tracker
1093                 airDropTracker_ = 0;
1094             }
1095         }
1096     
1097             // store the air drop tracker number (number of buys since last airdrop)
1098             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1099             
1100             // update player 
1101             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1102             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1103             
1104             // update round
1105             round_[_rID].keys = _keys.add(round_[_rID].keys);
1106             round_[_rID].eth = _eth.add(round_[_rID].eth);
1107             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1108     
1109             // distribute eth
1110             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1111             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1112             
1113             // call end tx function to fire end tx event.
1114             endTx(_pID, _team, _eth, _keys, _eventData_);
1115         }
1116     }
1117 //==============================================================================
1118 //     _ _ | _   | _ _|_ _  _ _  .
1119 //    (_(_||(_|_||(_| | (_)| _\  .
1120 //==============================================================================
1121     /**
1122      * @dev calculates unmasked earnings (just calculates, does not update mask)
1123      * @return earnings in wei format
1124      */
1125     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1126         private
1127         view
1128         returns(uint256)
1129     {
1130         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1131     }
1132     
1133     /** 
1134      * @dev returns the amount of keys you would get given an amount of eth. 
1135      * -functionhash- 0xce89c80c
1136      * @param _rID round ID you want price for
1137      * @param _eth amount of eth sent in 
1138      * @return keys received 
1139      */
1140     function calcKeysReceived(uint256 _rID, uint256 _eth)
1141         public
1142         view
1143         returns(uint256)
1144     {
1145         // grab time
1146         uint256 _now = now;
1147         
1148         // are we in a round?
1149         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1150             return ( (round_[_rID].eth).keysRec(_eth) );
1151         else // rounds over.  need keys for new round
1152             return ( (_eth).keys() );
1153     }
1154     
1155     /** 
1156      * @dev returns current eth price for X keys.  
1157      * -functionhash- 0xcf808000
1158      * @param _keys number of keys desired (in 18 decimal format)
1159      * @return amount of eth needed to send
1160      */
1161     function iWantXKeys(uint256 _keys)
1162         public
1163         view
1164         returns(uint256)
1165     {
1166         // setup local rID
1167         uint256 _rID = rID_;
1168         
1169         // grab time
1170         uint256 _now = now;
1171         
1172         // are we in a round?
1173         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1174             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1175         else // rounds over.  need price for new round
1176             return ( (_keys).eth() );
1177     }
1178 //==============================================================================
1179 //    _|_ _  _ | _  .
1180 //     | (_)(_)|_\  .
1181 //==============================================================================
1182     /**
1183      * @dev receives name/player info from names contract 
1184      */
1185     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1186         external
1187     {
1188         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1189         if (pIDxAddr_[_addr] != _pID)
1190             pIDxAddr_[_addr] = _pID;
1191         if (pIDxName_[_name] != _pID)
1192             pIDxName_[_name] = _pID;
1193         if (plyr_[_pID].addr != _addr)
1194             plyr_[_pID].addr = _addr;
1195         if (plyr_[_pID].name != _name)
1196             plyr_[_pID].name = _name;
1197         if (plyr_[_pID].laff != _laff)
1198             plyr_[_pID].laff = _laff;
1199         if (plyrNames_[_pID][_name] == false)
1200             plyrNames_[_pID][_name] = true;
1201     }
1202     
1203     /**
1204      * @dev receives entire player name list 
1205      */
1206     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1207         external
1208     {
1209         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1210         if(plyrNames_[_pID][_name] == false)
1211             plyrNames_[_pID][_name] = true;
1212     }   
1213         
1214     /**
1215      * @dev gets existing or registers new pID.  use this when a player may be new
1216      * @return pID 
1217      */
1218     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1219         private
1220         returns (F3Ddatasets.EventReturns)
1221     {
1222         uint256 _pID = pIDxAddr_[msg.sender];
1223         // if player is new to this version of fomo3d
1224         if (_pID == 0)
1225         {
1226             // grab their player ID, name and last aff ID, from player names contract 
1227             _pID = PlayerBook.getPlayerID(msg.sender);
1228             bytes32 _name = PlayerBook.getPlayerName(_pID);
1229             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1230             
1231             // set up player account 
1232             pIDxAddr_[msg.sender] = _pID;
1233             plyr_[_pID].addr = msg.sender;
1234             
1235             if (_name != "")
1236             {
1237                 pIDxName_[_name] = _pID;
1238                 plyr_[_pID].name = _name;
1239                 plyrNames_[_pID][_name] = true;
1240             }
1241             
1242             if (_laff != 0 && _laff != _pID)
1243                 plyr_[_pID].laff = _laff;
1244             
1245             // set the new player bool to true
1246             _eventData_.compressedData = _eventData_.compressedData + 1;
1247         } 
1248         return (_eventData_);
1249     }
1250     
1251     /**
1252      * @dev checks to make sure user picked a valid team.  if not sets team 
1253      * to default (sneks)
1254      */
1255     function verifyTeam(uint256 _team)
1256         private
1257         pure
1258         returns (uint256)
1259     {
1260         if (_team < 0 || _team > 3)
1261             return(2);
1262         else
1263             return(_team);
1264     }
1265     
1266     /**
1267      * @dev decides if round end needs to be run & new round started.  and if 
1268      * player unmasked earnings from previously played rounds need to be moved.
1269      */
1270     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1271         private
1272         returns (F3Ddatasets.EventReturns)
1273     {
1274         // if player has played a previous round, move their unmasked earnings
1275         // from that round to gen vault.
1276         if (plyr_[_pID].lrnd != 0)
1277             updateGenVault(_pID, plyr_[_pID].lrnd);
1278             
1279         // update player's last round played
1280         plyr_[_pID].lrnd = rID_;
1281             
1282         // set the joined round bool to true
1283         _eventData_.compressedData = _eventData_.compressedData + 10;
1284         
1285         return(_eventData_);
1286     }
1287     
1288     /**
1289      * @dev ends the round. manages paying out winner/splitting up pot
1290      */
1291     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1292         private
1293         returns (F3Ddatasets.EventReturns)
1294     {
1295         // setup local rID
1296         uint256 _rID = rID_;
1297         
1298         // grab our winning player and team id's
1299         uint256 _winPID = round_[_rID].plyr;
1300         uint256 _winTID = round_[_rID].team;
1301         
1302         // grab our pot amount
1303         uint256 _pot = round_[_rID].pot;
1304         
1305         // calculate our winner share, community rewards, gen share, 
1306         // p3d share, and amount reserved for next pot 
1307         uint256 _win = (_pot.mul(48)) / 100;
1308         uint256 _com = (_pot / 50);
1309         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1310         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1311         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1312         
1313         // calculate ppt for round mask
1314         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1315         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1316         if (_dust > 0)
1317         {
1318             _gen = _gen.sub(_dust);
1319             _res = _res.add(_dust);
1320         }
1321         
1322         // pay our winner
1323         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1324         
1325         // community rewards
1326         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1327         {
1328             // This ensures Team Just cannot influence the outcome of FoMo3D with
1329             // bank migrations by breaking outgoing transactions.
1330             // Something we would never do. But that's not the point.
1331             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1332             // highest belief that everything we create should be trustless.
1333             // Team JUST, The name you shouldn't have to trust.
1334             _p3d = _p3d.add(_com);
1335             _com = 0;
1336         }
1337         
1338         // distribute gen portion to key holders
1339         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1340         
1341         // send share for p3d to divies
1342         if (_p3d > 0)
1343             Divies.deposit.value(_p3d)();
1344             
1345         // prepare event data
1346         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1347         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1348         _eventData_.winnerAddr = plyr_[_winPID].addr;
1349         _eventData_.winnerName = plyr_[_winPID].name;
1350         _eventData_.amountWon = _win;
1351         _eventData_.genAmount = _gen;
1352         _eventData_.P3DAmount = _p3d;
1353         _eventData_.newPot = _res;
1354         
1355         // start next round
1356         rID_++;
1357         _rID++;
1358         round_[_rID].strt = now;
1359         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1360         round_[_rID].pot = _res;
1361         
1362         return(_eventData_);
1363     }
1364     
1365     /**
1366      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1367      */
1368     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1369         private 
1370     {
1371         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1372         if (_earnings > 0)
1373         {
1374             // put in gen vault
1375             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1376             // zero out their earnings by updating mask
1377             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1378         }
1379     }
1380     
1381     /**
1382      * @dev updates round timer based on number of whole keys bought.
1383      */
1384     function updateTimer(uint256 _keys, uint256 _rID)
1385         private
1386     {
1387         // grab time
1388         uint256 _now = now;
1389         
1390         // calculate time based on number of keys bought
1391         uint256 _newTime;
1392         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1393             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1394         else
1395             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1396         
1397         // compare to max and set new end time
1398         if (_newTime < (rndMax_).add(_now))
1399             round_[_rID].end = _newTime;
1400         else
1401             round_[_rID].end = rndMax_.add(_now);
1402     }
1403     
1404     /**
1405      * @dev generates a random number between 0-99 and checks to see if thats
1406      * resulted in an airdrop win
1407      * @return do we have a winner?
1408      */
1409     function airdrop()
1410         private 
1411         view 
1412         returns(bool)
1413     {
1414         uint256 seed = uint256(keccak256(abi.encodePacked(
1415             
1416             (block.timestamp).add
1417             (block.difficulty).add
1418             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1419             (block.gaslimit).add
1420             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1421             (block.number)
1422             
1423         )));
1424         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1425             return(true);
1426         else
1427             return(false);
1428     }
1429 
1430     /**
1431      * @dev distributes eth based on fees to com, aff, and p3d
1432      */
1433     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1434         private
1435         returns(F3Ddatasets.EventReturns)
1436     {
1437         // pay 2% out to community rewards
1438         uint256 _com = _eth / 50;
1439         uint256 _p3d;
1440         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1441         {
1442             // This ensures Team Just cannot influence the outcome of FoMo3D with
1443             // bank migrations by breaking outgoing transactions.
1444             // Something we would never do. But that's not the point.
1445             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1446             // highest belief that everything we create should be trustless.
1447             // Team JUST, The name you shouldn't have to trust.
1448             _p3d = _com;
1449             _com = 0;
1450         }
1451         
1452         // pay 1% out to FoMo3D short
1453         uint256 _long = _eth / 100;
1454         otherF3D_.potSwap.value(_long)();
1455         
1456         // distribute share to affiliate
1457         uint256 _aff = _eth / 10;
1458         
1459         // decide what to do with affiliate share of fees
1460         // affiliate must not be self, and must have a name registered
1461         if (_affID != _pID && plyr_[_affID].name != '') {
1462             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1463             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1464         } else {
1465             _p3d = _aff;
1466         }
1467         
1468         // pay out p3d
1469         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1470         if (_p3d > 0)
1471         {
1472             // deposit to divies contract
1473             Divies.deposit.value(_p3d)();
1474             
1475             // set up event data
1476             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1477         }
1478         
1479         return(_eventData_);
1480     }
1481     
1482     function potSwap()
1483         external
1484         payable
1485     {
1486         // setup local rID
1487         uint256 _rID = rID_ + 1;
1488         
1489         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1490         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1491     }
1492     
1493     /**
1494      * @dev distributes eth based on fees to gen and pot
1495      */
1496     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1497         private
1498         returns(F3Ddatasets.EventReturns)
1499     {
1500         // calculate gen share
1501         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1502         
1503         // toss 1% into airdrop pot 
1504         uint256 _air = (_eth / 100);
1505         airDropPot_ = airDropPot_.add(_air);
1506         
1507         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1508         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1509         
1510         // calculate pot 
1511         uint256 _pot = _eth.sub(_gen);
1512         
1513         // distribute gen share (thats what updateMasks() does) and adjust
1514         // balances for dust.
1515         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1516         if (_dust > 0)
1517             _gen = _gen.sub(_dust);
1518         
1519         // add eth to pot
1520         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1521         
1522         // set up event data
1523         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1524         _eventData_.potAmount = _pot;
1525         
1526         return(_eventData_);
1527     }
1528 
1529     /**
1530      * @dev updates masks for round and player when keys are bought
1531      * @return dust left over 
1532      */
1533     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1534         private
1535         returns(uint256)
1536     {
1537         /* MASKING NOTES
1538             earnings masks are a tricky thing for people to wrap their minds around.
1539             the basic thing to understand here.  is were going to have a global
1540             tracker based on profit per share for each round, that increases in
1541             relevant proportion to the increase in share supply.
1542             
1543             the player will have an additional mask that basically says "based
1544             on the rounds mask, my shares, and how much i've already withdrawn,
1545             how much is still owed to me?"
1546         */
1547         
1548         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1549         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1550         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1551             
1552         // calculate player earning from their own buy (only based on the keys
1553         // they just bought).  & update player earnings mask
1554         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1555         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1556         
1557         // calculate & return dust
1558         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1559     }
1560     
1561     /**
1562      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1563      * @return earnings in wei format
1564      */
1565     function withdrawEarnings(uint256 _pID)
1566         private
1567         returns(uint256)
1568     {
1569         // update gen vault
1570         updateGenVault(_pID, plyr_[_pID].lrnd);
1571         
1572         // from vaults 
1573         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1574         if (_earnings > 0)
1575         {
1576             plyr_[_pID].win = 0;
1577             plyr_[_pID].gen = 0;
1578             plyr_[_pID].aff = 0;
1579         }
1580 
1581         return(_earnings);
1582     }
1583     
1584     /**
1585      * @dev prepares compression data and fires event for buy or reload tx's
1586      */
1587     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1588         private
1589     {
1590         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1591         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1592         
1593         emit F3Devents.onEndTx
1594         (
1595             _eventData_.compressedData,
1596             _eventData_.compressedIDs,
1597             plyr_[_pID].name,
1598             msg.sender,
1599             _eth,
1600             _keys,
1601             _eventData_.winnerAddr,
1602             _eventData_.winnerName,
1603             _eventData_.amountWon,
1604             _eventData_.newPot,
1605             _eventData_.P3DAmount,
1606             _eventData_.genAmount,
1607             _eventData_.potAmount,
1608             airDropPot_
1609         );
1610     }
1611 //==============================================================================
1612 //    (~ _  _    _._|_    .
1613 //    _)(/_(_|_|| | | \/  .
1614 //====================/=========================================================
1615     /** upon contract deploy, it will be deactivated.  this is a one time
1616      * use function that will activate the contract.  we do this so devs 
1617      * have time to set things up on the web end                            **/
1618     bool public activated_ = false;
1619     function activate()
1620         public
1621     {
1622         // only team just can activate 
1623         require(
1624             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1625             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1626             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1627             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1628             msg.sender == 0xB1819CFd705255422A32916Db7d08170d474dA15,
1629             "only team just can activate"
1630         );
1631 
1632         // make sure that its been linked.
1633         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1634         
1635         // can only be ran once
1636         require(activated_ == false, "fomo3d already activated");
1637         
1638         // activate the contract 
1639         activated_ = true;
1640         
1641         // lets start first round
1642         rID_ = 1;
1643         round_[1].strt = now + rndExtra_ - rndGap_;
1644         round_[1].end = now + rndInit_ + rndExtra_;
1645     }
1646     function setOtherFomo(address _otherF3D)
1647         public
1648     {
1649         // only team just can activate 
1650         require(
1651             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1652             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1653             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1654             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1655             msg.sender == 0xB1819CFd705255422A32916Db7d08170d474dA15,
1656             "only team just can activate"
1657         );
1658 
1659         // make sure that it HASNT yet been linked.
1660         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1661         
1662         // set up other fomo3d (fast or long) for pot swap
1663         otherF3D_ = otherFoMo3D(_otherF3D);
1664     }
1665 }
1666 
1667 //==============================================================================
1668 //   __|_ _    __|_ _  .
1669 //  _\ | | |_|(_ | _\  .
1670 //==============================================================================
1671 library F3Ddatasets {
1672     //compressedData key
1673     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1674         // 0 - new player (bool)
1675         // 1 - joined round (bool)
1676         // 2 - new  leader (bool)
1677         // 3-5 - air drop tracker (uint 0-999)
1678         // 6-16 - round end time
1679         // 17 - winnerTeam
1680         // 18 - 28 timestamp 
1681         // 29 - team
1682         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1683         // 31 - airdrop happened bool
1684         // 32 - airdrop tier 
1685         // 33 - airdrop amount won
1686     //compressedIDs key
1687     // [77-52][51-26][25-0]
1688         // 0-25 - pID 
1689         // 26-51 - winPID
1690         // 52-77 - rID
1691     struct EventReturns {
1692         uint256 compressedData;
1693         uint256 compressedIDs;
1694         address winnerAddr;         // winner address
1695         bytes32 winnerName;         // winner name
1696         uint256 amountWon;          // amount won
1697         uint256 newPot;             // amount in new pot
1698         uint256 P3DAmount;          // amount distributed to p3d
1699         uint256 genAmount;          // amount distributed to gen
1700         uint256 potAmount;          // amount added to pot
1701     }
1702     struct Player {
1703         address addr;   // player address
1704         bytes32 name;   // player name
1705         uint256 win;    // winnings vault
1706         uint256 gen;    // general vault
1707         uint256 aff;    // affiliate vault
1708         uint256 lrnd;   // last round played
1709         uint256 laff;   // last affiliate id used
1710     }
1711     struct PlayerRounds {
1712         uint256 eth;    // eth player has added to round (used for eth limiter)
1713         uint256 keys;   // keys
1714         uint256 mask;   // player mask 
1715         uint256 ico;    // ICO phase investment
1716     }
1717     struct Round {
1718         uint256 plyr;   // pID of player in lead
1719         uint256 team;   // tID of team in lead
1720         uint256 end;    // time ends/ended
1721         bool ended;     // has round end function been ran
1722         uint256 strt;   // time round started
1723         uint256 keys;   // keys
1724         uint256 eth;    // total eth in
1725         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1726         uint256 mask;   // global mask
1727         uint256 ico;    // total eth sent in during ICO phase
1728         uint256 icoGen; // total eth for gen during ICO phase
1729         uint256 icoAvg; // average key price for ICO phase
1730     }
1731     struct TeamFee {
1732         uint256 gen;    // % of buy in thats paid to key holders of current round
1733         uint256 p3d;    // % of buy in thats paid to p3d holders
1734     }
1735     struct PotSplit {
1736         uint256 gen;    // % of pot thats paid to key holders of current round
1737         uint256 p3d;    // % of pot thats paid to p3d holders
1738     }
1739 }
1740 
1741 //==============================================================================
1742 //  |  _      _ _ | _  .
1743 //  |<(/_\/  (_(_||(_  .
1744 //=======/======================================================================
1745 library F3DKeysCalcLong {
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
1802 //==============================================================================
1803 //  . _ _|_ _  _ |` _  _ _  _  .
1804 //  || | | (/_| ~|~(_|(_(/__\  .
1805 //==============================================================================
1806 interface otherFoMo3D {
1807     function potSwap() external payable;
1808 }
1809 
1810 
1811 interface DiviesInterface {
1812     function deposit() external payable;
1813 }
1814 
1815 interface JIincForwarderInterface {
1816     function deposit() external payable returns(bool);
1817     function status() external view returns(address, address, bool);
1818     function startMigration(address _newCorpBank) external returns(bool);
1819     function cancelMigration() external returns(bool);
1820     function finishMigration() external returns(bool);
1821     function setup(address _firstCorpBank) external;
1822 }
1823 
1824 interface PlayerBookInterface {
1825     function getPlayerID(address _addr) external returns (uint256);
1826     function getPlayerName(uint256 _pID) external view returns (bytes32);
1827     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1828     function getPlayerAddr(uint256 _pID) external view returns (address);
1829     function getNameFee() external view returns (uint256);
1830     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1831     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1832     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1833 }
1834 
1835 /**
1836 * @title -Name Filter- v0.1.9
1837 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1838 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1839 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1840 *                                  _____                      _____
1841 *                                 (, /     /)       /) /)    (, /      /)          /)
1842 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1843 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1844 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1845 *                            (__ /          (_/ (, /                                      /)™ 
1846 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1847 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1848 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1849 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1850 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1851 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1852 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1853 *
1854 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1855 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1856 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1857 */
1858 
1859 library NameFilter {
1860     /**
1861      * @dev filters name strings
1862      * -converts uppercase to lower case.  
1863      * -makes sure it does not start/end with a space
1864      * -makes sure it does not contain multiple spaces in a row
1865      * -cannot be only numbers
1866      * -cannot start with 0x 
1867      * -restricts characters to A-Z, a-z, 0-9, and space.
1868      * @return reprocessed string in bytes32 format
1869      */
1870     function nameFilter(string _input)
1871         internal
1872         pure
1873         returns(bytes32)
1874     {
1875         bytes memory _temp = bytes(_input);
1876         uint256 _length = _temp.length;
1877         
1878         //sorry limited to 32 characters
1879         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1880         // make sure it doesnt start with or end with space
1881         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1882         // make sure first two characters are not 0x
1883         if (_temp[0] == 0x30)
1884         {
1885             require(_temp[1] != 0x78, "string cannot start with 0x");
1886             require(_temp[1] != 0x58, "string cannot start with 0X");
1887         }
1888         
1889         // create a bool to track if we have a non number character
1890         bool _hasNonNumber;
1891         
1892         // convert & check
1893         for (uint256 i = 0; i < _length; i++)
1894         {
1895             // if its uppercase A-Z
1896             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1897             {
1898                 // convert to lower case a-z
1899                 _temp[i] = byte(uint(_temp[i]) + 32);
1900                 
1901                 // we have a non number
1902                 if (_hasNonNumber == false)
1903                     _hasNonNumber = true;
1904             } else {
1905                 require
1906                 (
1907                     // require character is a space
1908                     _temp[i] == 0x20 || 
1909                     // OR lowercase a-z
1910                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1911                     // or 0-9
1912                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1913                     "string contains invalid characters"
1914                 );
1915                 // make sure theres not 2x spaces in a row
1916                 if (_temp[i] == 0x20)
1917                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1918                 
1919                 // see if we have a character other than a number
1920                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1921                     _hasNonNumber = true;    
1922             }
1923         }
1924         
1925         require(_hasNonNumber == true, "string cannot be only numbers");
1926         
1927         bytes32 _ret;
1928         assembly {
1929             _ret := mload(add(_temp, 32))
1930         }
1931         return (_ret);
1932     }
1933 }
1934 
1935 /**
1936  * @title SafeMath v0.1.9
1937  * @dev Math operations with safety checks that throw on error
1938  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1939  * - added sqrt
1940  * - added sq
1941  * - added pwr 
1942  * - changed asserts to requires with error log outputs
1943  * - removed div, its useless
1944  */
1945 library SafeMath {
1946     
1947     /**
1948     * @dev Multiplies two numbers, throws on overflow.
1949     */
1950     function mul(uint256 a, uint256 b) 
1951         internal 
1952         pure 
1953         returns (uint256 c) 
1954     {
1955         if (a == 0) {
1956             return 0;
1957         }
1958         c = a * b;
1959         require(c / a == b, "SafeMath mul failed");
1960         return c;
1961     }
1962 
1963     /**
1964     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1965     */
1966     function sub(uint256 a, uint256 b)
1967         internal
1968         pure
1969         returns (uint256) 
1970     {
1971         require(b <= a, "SafeMath sub failed");
1972         return a - b;
1973     }
1974 
1975     /**
1976     * @dev Adds two numbers, throws on overflow.
1977     */
1978     function add(uint256 a, uint256 b)
1979         internal
1980         pure
1981         returns (uint256 c) 
1982     {
1983         c = a + b;
1984         require(c >= a, "SafeMath add failed");
1985         return c;
1986     }
1987     
1988     /**
1989      * @dev gives square root of given x.
1990      */
1991     function sqrt(uint256 x)
1992         internal
1993         pure
1994         returns (uint256 y) 
1995     {
1996         uint256 z = ((add(x,1)) / 2);
1997         y = x;
1998         while (z < y) 
1999         {
2000             y = z;
2001             z = ((add((x / z),z)) / 2);
2002         }
2003     }
2004     
2005     /**
2006      * @dev gives square. multiplies x by x
2007      */
2008     function sq(uint256 x)
2009         internal
2010         pure
2011         returns (uint256)
2012     {
2013         return (mul(x,x));
2014     }
2015     
2016     /**
2017      * @dev x to the power of y 
2018      */
2019     function pwr(uint256 x, uint256 y)
2020         internal 
2021         pure 
2022         returns (uint256)
2023     {
2024         if (x==0)
2025             return (0);
2026         else if (y==0)
2027             return (1);
2028         else 
2029         {
2030             uint256 z = x;
2031             for (uint256 i=1; i < y; i++)
2032                 z = mul(z,x);
2033             return (z);
2034         }
2035     }
2036 }