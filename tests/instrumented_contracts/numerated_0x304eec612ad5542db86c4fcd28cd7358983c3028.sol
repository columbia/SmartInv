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
180 contract H3FoMo3Dlong is modularLong {
181     using SafeMath for *;
182     using NameFilter for string;
183     using F3DKeysCalcLong for uint256;
184 
185     otherFoMo3D private otherF3D_;
186     DiviesInterface constant private Divies = DiviesInterface(0x88ac6e1f2ffc98fda7ca2a4236178b8be66b79f4);
187     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x6f6a4c6bc3b646be9c33566fe40cdc20c34ee104);
188     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xa988d0b985188818906d206ba0cf98ca0a7433bb);
189     //==============================================================================
190     //     _ _  _  |`. _     _ _ |_ | _  _  .
191     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
192     //=================_|===========================================================
193     string constant public name = "FoMo3D Long Official";
194     string constant public symbol = "F3D";
195     uint256 private rndExtra_ = 15 minutes;     // length of the very first ICO
196     uint256 private rndGap_ = 15 minutes;         // length of ICO phase, set to 1 year for EOS.
197     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
198     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
199     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
200     //==============================================================================
201     //     _| _ _|_ _    _ _ _|_    _   .
202     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
203     //=============================|================================================
204     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
205     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
206     uint256 public rID_;    // round id number / total rounds that have happened
207     //****************
208     // PLAYER DATA
209     //****************
210     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
211     mapping(bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
212     mapping(uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
213     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
214     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
215     //****************
216     // ROUND DATA
217     //****************
218     mapping(uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
219     mapping(uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
220     //****************
221     // TEAM FEE DATA
222     //****************
223     mapping(uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
224     mapping(uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
225 //==============================================================================
226 //     _ _  _  __|_ _    __|_ _  _  .
227 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
228 //==============================================================================
229     constructor() public {
230         // Team allocation structures
231         // 0 = whales
232         // 1 = bears
233         // 2 = sneks
234         // 3 = bulls
235 
236         // Team allocation percentages
237         // (F3D, P3D) + (Pot , Referrals, Community)
238         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
239         fees_[0] = F3Ddatasets.TeamFee(30, 6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
240         fees_[1] = F3Ddatasets.TeamFee(43, 0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
241         fees_[2] = F3Ddatasets.TeamFee(56, 10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
242         fees_[3] = F3Ddatasets.TeamFee(43, 8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
243 
244         // how to split up the final pot based on which team was picked
245         // (F3D, P3D)
246         potSplit_[0] = F3Ddatasets.PotSplit(15, 10);  //48% to winner, 25% to next round, 2% to com
247         potSplit_[1] = F3Ddatasets.PotSplit(25, 0);   //48% to winner, 25% to next round, 2% to com
248         potSplit_[2] = F3Ddatasets.PotSplit(20, 20);  //48% to winner, 10% to next round, 2% to com
249         potSplit_[3] = F3Ddatasets.PotSplit(30, 10);  //48% to winner, 10% to next round, 2% to com
250     }
251 //==============================================================================
252 //     _ _  _  _|. |`. _  _ _  .
253 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
254 //==============================================================================
255     /**
256      * @dev used to make sure no one can interact with contract until it has
257      * been activated.
258      */
259     modifier isActivated() {
260         require(activated_ == true, "its not ready yet.  check ?eta in discord");
261         _;
262     }
263 
264     /**
265      * @dev prevents contracts from interacting with fomo3d
266      */
267     modifier isHuman() {
268         address _addr = msg.sender;
269         uint256 _codeLength;
270 
271         assembly {_codeLength := extcodesize(_addr)}
272         require(_codeLength == 0, "sorry humans only");
273         _;
274     }
275 
276     /**
277      * @dev sets boundaries for incoming tx
278      */
279     modifier isWithinLimits(uint256 _eth) {
280         require(_eth >= 1000000000, "pocket lint: not a valid currency");
281         require(_eth <= 100000000000000000000000, "no vitalik, no");
282         _;
283     }
284 
285 //==============================================================================
286 //     _    |_ |. _   |`    _  __|_. _  _  _  .
287 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
288 //====|=========================================================================
289     /**
290      * @dev emergency buy uses last stored affiliate ID and team snek
291      */
292     function() isActivated() isHuman() isWithinLimits(msg.value) public payable
293     {
294         // set up our tx event data and determine if player is new or not
295         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
296 
297         // fetch player id
298         uint256 _pID = pIDxAddr_[msg.sender];
299 
300         // buy core
301         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
302     }
303 
304     /**
305      * @dev converts all incoming ethereum to keys.
306      * -functionhash- 0x8f38f309 (using ID for affiliate)
307      * -functionhash- 0x98a0871d (using address for affiliate)
308      * -functionhash- 0xa65b37a1 (using name for affiliate)
309      * @param _affCode the ID/address/name of the player who gets the affiliate fee
310      * @param _team what team is the player playing for?
311      */
312     function buyXid(uint256 _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
313         // set up our tx event data and determine if player is new or not
314         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
315 
316         // fetch player id
317         uint256 _pID = pIDxAddr_[msg.sender];
318 
319         // manage affiliate residuals
320         // if no affiliate code was given or player tried to use their own, lolz
321         if (_affCode == 0 || _affCode == _pID) {
322             // use last stored affiliate code
323             _affCode = plyr_[_pID].laff;
324 
325         // if affiliate code was given & its not the same as previously stored
326         } else if (_affCode != plyr_[_pID].laff) {
327             // update last affiliate
328             plyr_[_pID].laff = _affCode;
329         }
330 
331         // verify a valid team was selected
332         _team = verifyTeam(_team);
333 
334         // buy core
335         buyCore(_pID, _affCode, _team, _eventData_);
336     }
337 
338     function buyXaddr(address _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
339         // set up our tx event data and determine if player is new or not
340         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
341 
342         // fetch player id
343         uint256 _pID = pIDxAddr_[msg.sender];
344 
345         // manage affiliate residuals
346         uint256 _affID;
347         // if no affiliate code was given or player tried to use their own, lolz
348         if (_affCode == address(0) || _affCode == msg.sender)
349         {
350             // use last stored affiliate code
351             _affID = plyr_[_pID].laff;
352 
353         // if affiliate code was given
354         } else {
355             // get affiliate ID from aff Code
356             _affID = pIDxAddr_[_affCode];
357 
358             // if affID is not the same as previously stored
359             if (_affID != plyr_[_pID].laff)
360             {
361             // update last affiliate
362             plyr_[_pID].laff = _affID;
363             }
364         }
365 
366         // verify a valid team was selected
367         _team = verifyTeam(_team);
368 
369         // buy core
370         buyCore(_pID, _affID, _team, _eventData_);
371     }
372 
373     function buyXname(bytes32 _affCode, uint256 _team) isActivated() isHuman() isWithinLimits(msg.value) public payable {
374         // set up our tx event data and determine if player is new or not
375         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
376 
377         // fetch player id
378         uint256 _pID = pIDxAddr_[msg.sender];
379 
380         // manage affiliate residuals
381         uint256 _affID;
382         // if no affiliate code was given or player tried to use their own, lolz
383         if (_affCode == '' || _affCode == plyr_[_pID].name)
384         {
385             // use last stored affiliate code
386             _affID = plyr_[_pID].laff;
387 
388         // if affiliate code was given
389         } else {
390             // get affiliate ID from aff Code
391             _affID = pIDxName_[_affCode];
392 
393             // if affID is not the same as previously stored
394             if (_affID != plyr_[_pID].laff)
395             {
396                 // update last affiliate
397                 plyr_[_pID].laff = _affID;
398             }
399         }
400 
401         // verify a valid team was selected
402         _team = verifyTeam(_team);
403 
404         // buy core
405         buyCore(_pID, _affID, _team, _eventData_);
406     }
407 
408     /**
409      * @dev essentially the same as buy, but instead of you sending ether
410      * from your wallet, it uses your unwithdrawn earnings.
411      * -functionhash- 0x349cdcac (using ID for affiliate)
412      * -functionhash- 0x82bfc739 (using address for affiliate)
413      * -functionhash- 0x079ce327 (using name for affiliate)
414      * @param _affCode the ID/address/name of the player who gets the affiliate fee
415      * @param _team what team is the player playing for?
416      * @param _eth amount of earnings to use (remainder returned to gen vault)
417      */
418     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
419     isActivated()
420     isHuman()
421     isWithinLimits(_eth)
422     public {
423         // set up our tx event data
424         F3Ddatasets.EventReturns memory _eventData_;
425 
426         // fetch player ID
427         uint256 _pID = pIDxAddr_[msg.sender];
428 
429         // manage affiliate residuals
430         // if no affiliate code was given or player tried to use their own, lolz
431         if (_affCode == 0 || _affCode == _pID)
432         {
433             // use last stored affiliate code
434             _affCode = plyr_[_pID].laff;
435 
436         // if affiliate code was given & its not the same as previously stored
437         } else if (_affCode != plyr_[_pID].laff) {
438         // update last affiliate
439             plyr_[_pID].laff = _affCode;
440         }
441 
442         // verify a valid team was selected
443         _team = verifyTeam(_team);
444 
445         // reload core
446         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
447     }
448 
449     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) isActivated() isHuman() isWithinLimits(_eth) public {
450         // set up our tx event data
451         F3Ddatasets.EventReturns memory _eventData_;
452 
453         // fetch player ID
454         uint256 _pID = pIDxAddr_[msg.sender];
455 
456         // manage affiliate residuals
457         uint256 _affID;
458         // if no affiliate code was given or player tried to use their own, lolz
459         if (_affCode == address(0) || _affCode == msg.sender)
460         {
461             // use last stored affiliate code
462             _affID = plyr_[_pID].laff;
463 
464         // if affiliate code was given
465         } else {
466             // get affiliate ID from aff Code
467             _affID = pIDxAddr_[_affCode];
468 
469             // if affID is not the same as previously stored
470             if (_affID != plyr_[_pID].laff)
471             {
472             // update last affiliate
473             plyr_[_pID].laff = _affID;
474             }
475         }
476 
477         // verify a valid team was selected
478         _team = verifyTeam(_team);
479 
480         // reload core
481         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
482     }
483 
484     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
485     isActivated()
486     isHuman()
487     isWithinLimits(_eth)
488     public {
489         // set up our tx event data
490         F3Ddatasets.EventReturns memory _eventData_;
491 
492         // fetch player ID
493         uint256 _pID = pIDxAddr_[msg.sender];
494 
495         // manage affiliate residuals
496         uint256 _affID;
497         // if no affiliate code was given or player tried to use their own, lolz
498         if (_affCode == '' || _affCode == plyr_[_pID].name)
499         {
500             // use last stored affiliate code
501             _affID = plyr_[_pID].laff;
502 
503         // if affiliate code was given
504         } else {
505             // get affiliate ID from aff Code
506             _affID = pIDxName_[_affCode];
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
523     /**
524      * @dev withdraws all of your earnings.
525      * -functionhash- 0x3ccfd60b
526      */
527     function withdraw() isActivated() isHuman() public {
528         // setup local rID
529         uint256 _rID = rID_;
530 
531         // grab time
532         uint256 _now = now;
533 
534         // fetch player ID
535         uint256 _pID = pIDxAddr_[msg.sender];
536 
537         // setup temp var for player eth
538         uint256 _eth;
539 
540         // check to see if round has ended and no one has run round end yet
541         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
542         {
543             // set up our tx event data
544             F3Ddatasets.EventReturns memory _eventData_;
545 
546             // end the round (distributes pot)
547             round_[_rID].ended = true;
548             _eventData_ = endRound(_eventData_);
549 
550             // get their earnings
551             _eth = withdrawEarnings(_pID);
552 
553             // gib moni
554             if (_eth > 0)
555             plyr_[_pID].addr.transfer(_eth);
556 
557             // build event data
558             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
559             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
560 
561             // fire withdraw and distribute event
562             emit F3Devents.onWithdrawAndDistribute
563             (
564             msg.sender,
565             plyr_[_pID].name,
566             _eth,
567             _eventData_.compressedData,
568             _eventData_.compressedIDs,
569             _eventData_.winnerAddr,
570             _eventData_.winnerName,
571             _eventData_.amountWon,
572             _eventData_.newPot,
573             _eventData_.P3DAmount,
574             _eventData_.genAmount
575             );
576 
577         // in any other situation
578         } else {
579             // get their earnings
580             _eth = withdrawEarnings(_pID);
581 
582             // gib moni
583             if (_eth > 0)
584             plyr_[_pID].addr.transfer(_eth);
585 
586             // fire withdraw event
587             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
588         }
589     }
590 
591     /**
592      * @dev use these to register names.  they are just wrappers that will send the
593      * registration requests to the PlayerBook contract.  So registering here is the
594      * same as registering there.  UI will always display the last name you registered.
595      * but you will still own all previously registered names to use as affiliate
596      * links.
597      * - must pay a registration fee.
598      * - name must be unique
599      * - names will be converted to lowercase
600      * - name cannot start or end with a space
601      * - cannot have more than 1 space in a row
602      * - cannot be only numbers
603      * - cannot start with 0x
604      * - name must be at least 1 char
605      * - max length of 32 characters long
606      * - allowed characters: a-z, 0-9, and space
607      * -functionhash- 0x921dec21 (using ID for affiliate)
608      * -functionhash- 0x3ddd4698 (using address for affiliate)
609      * -functionhash- 0x685ffd83 (using name for affiliate)
610      * @param _nameString players desired name
611      * @param _affCode affiliate ID, address, or name of who referred you
612      * @param _all set to true if you want this to push your info to all games
613      * (this might cost a lot of gas)
614      */
615     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
616     isHuman()
617     public
618     payable
619     {
620         bytes32 _name = _nameString.nameFilter();
621         address _addr = msg.sender;
622         uint256 _paid = msg.value;
623         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
624 
625         uint256 _pID = pIDxAddr_[_addr];
626 
627         // fire event
628         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
629     }
630 
631     function registerNameXaddr(string _nameString, address _affCode, bool _all)
632     isHuman()
633     public
634     payable
635     {
636         bytes32 _name = _nameString.nameFilter();
637         address _addr = msg.sender;
638         uint256 _paid = msg.value;
639         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
640 
641         uint256 _pID = pIDxAddr_[_addr];
642 
643         // fire event
644         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
645     }
646 
647     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
648     isHuman()
649     public
650     payable
651     {
652         bytes32 _name = _nameString.nameFilter();
653         address _addr = msg.sender;
654         uint256 _paid = msg.value;
655         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
656 
657         uint256 _pID = pIDxAddr_[_addr];
658 
659         // fire event
660         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
661     }
662     //==============================================================================
663     //     _  _ _|__|_ _  _ _  .
664     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
665     //=====_|=======================================================================
666     /**
667      * @dev return the price buyer will pay for next 1 individual key.
668      * -functionhash- 0x018a25e8
669      * @return price for next key bought (in wei format)
670      */
671     function getBuyPrice()
672     public
673     view
674     returns (uint256)
675     {
676         // setup local rID
677         uint256 _rID = rID_;
678 
679         // grab time
680         uint256 _now = now;
681 
682         // are we in a round?
683         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
684         return ((round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000));
685         else // rounds over.  need price for new round
686         return (75000000000000 ); // init
687     }
688 
689     /**
690      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
691      * provider
692      * -functionhash- 0xc7e284b8
693      * @return time left in seconds
694      */
695     function getTimeLeft()
696     public
697     view
698     returns (uint256)
699     {
700         // setup local rID
701         uint256 _rID = rID_;
702 
703         // grab time
704         uint256 _now = now;
705 
706         if (_now < round_[_rID].end)
707         if (_now > round_[_rID].strt + rndGap_)
708         return ((round_[_rID].end).sub(_now));
709         else
710         return ((round_[_rID].strt + rndGap_).sub(_now));
711         else
712         return (0);
713     }
714 
715     /**
716      * @dev returns player earnings per vaults
717      * -functionhash- 0x63066434
718      * @return winnings vault
719      * @return general vault
720      * @return affiliate vault
721      */
722     function getPlayerVaults(uint256 _pID)
723     public
724     view
725     returns (uint256, uint256, uint256)
726     {
727         // setup local rID
728         uint256 _rID = rID_;
729 
730         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
731         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
732         {
733             // if player is winner
734             if (round_[_rID].plyr == _pID)
735             {
736                 return
737                 (
738                 (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100 ),
739                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
740                 plyr_[_pID].aff
741                 );
742             // if player is not the winner
743             } else {
744                 return
745                 (
746                 plyr_[_pID].win,
747                 (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
748                 plyr_[_pID].aff
749                 );
750             }
751 
752         // if round is still going on, or round has ended and round end has been ran
753         } else {
754             return
755             (
756             plyr_[_pID].win,
757             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
758             plyr_[_pID].aff
759             );
760         }
761     }
762 
763     /**
764      * solidity hates stack limits.  this lets us avoid that hate
765      */
766     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
767     private
768     view
769     returns (uint256)
770     {
771         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
772     }
773 
774     /**
775      * @dev returns all current round info needed for front end
776      * -functionhash- 0x747dff42
777      * @return eth invested during ICO phase
778      * @return round id
779      * @return total keys for round
780      * @return time round ends
781      * @return time round started
782      * @return current pot
783      * @return current team ID & player ID in lead
784      * @return current player in leads address
785      * @return current player in leads name
786      * @return whales eth in for round
787      * @return bears eth in for round
788      * @return sneks eth in for round
789      * @return bulls eth in for round
790      * @return airdrop tracker # & airdrop pot
791      */
792     function getCurrentRoundInfo()
793     public
794     view
795     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
796     {
797         // setup local rID
798         uint256 _rID = rID_;
799 
800         return
801         (
802         round_[_rID].ico, //0
803         _rID, //1
804         round_[_rID].keys, //2
805         round_[_rID].end,               //3
806         round_[_rID].strt, //4
807         round_[_rID].pot, //5
808         (round_[_rID].team + (round_[_rID].plyr * 10)), //6
809         plyr_[round_[_rID].plyr].addr, //7
810         plyr_[round_[_rID].plyr].name, //8
811         rndTmEth_[_rID][0], //9
812         rndTmEth_[_rID][1], //10
813         rndTmEth_[_rID][2], //11
814         rndTmEth_[_rID][3],             //12
815         airDropTracker_ + (airDropPot_ * 1000)              //13
816         );
817     }
818 
819     /**
820      * @dev returns player info based on address.  if no address is given, it will
821      * use msg.sender
822      * -functionhash- 0xee0b5d8b
823      * @param _addr address of the player you want to lookup
824      * @return player ID
825      * @return player name
826      * @return keys owned (current round)
827      * @return winnings vault
828      * @return general vault
829      * @return affiliate vault
830      * @return player round eth
831      */
832     function getPlayerInfoByAddress(address _addr)
833     public
834     view
835     returns (uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
836     {
837         // setup local rID
838         uint256 _rID = rID_;
839 
840         if (_addr == address(0))
841         {
842             _addr == msg.sender;
843         }
844         uint256 _pID = pIDxAddr_[_addr];
845 
846         return
847         (
848         _pID, //0
849         plyr_[_pID].name, //1
850         plyrRnds_[_pID][_rID].keys, //2
851         plyr_[_pID].win, //3
852         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
853         plyr_[_pID].aff, //5
854         plyrRnds_[_pID][_rID].eth           //6
855         );
856     }
857 
858     //==============================================================================
859     //     _ _  _ _   | _  _ . _  .
860     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
861     //=====================_|=======================================================
862     /**
863      * @dev logic runs whenever a buy order is executed.  determines how to handle
864      * incoming eth depending on if we are in an active round or not
865      */
866     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
867     private
868     {
869         // setup local rID
870         uint256 _rID = rID_;
871 
872         // grab time
873         uint256 _now = now;
874 
875         // if round is active
876         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
877         {
878             // call core
879             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
880 
881         // if round is not active
882         } else {
883             // check to see if end round needs to be ran
884             if (_now > round_[_rID].end && round_[_rID].ended == false)
885             {
886                 // end the round (distributes pot) & start new round
887                 round_[_rID].ended = true;
888                 _eventData_ = endRound(_eventData_);
889 
890                 // build event data
891                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
892                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
893 
894                 // fire buy and distribute event
895                 emit F3Devents.onBuyAndDistribute
896                 (
897                 msg.sender,
898                 plyr_[_pID].name,
899                 msg.value,
900                 _eventData_.compressedData,
901                 _eventData_.compressedIDs,
902                 _eventData_.winnerAddr,
903                 _eventData_.winnerName,
904                 _eventData_.amountWon,
905                 _eventData_.newPot,
906                 _eventData_.P3DAmount,
907                 _eventData_.genAmount
908                 );
909             }
910 
911             // put eth in players vault
912             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
913         }
914     }
915 
916     /**
917      * @dev logic runs whenever a reload order is executed.  determines how to handle
918      * incoming eth depending on if we are in an active round or not
919      */
920     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
921     private
922     {
923         // setup local rID
924         uint256 _rID = rID_;
925 
926         // grab time
927         uint256 _now = now;
928 
929         // if round is active
930         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
931         {
932             // get earnings from all vaults and return unused to gen vault
933             // because we use a custom safemath library.  this will throw if player
934             // tried to spend more eth than they have.
935             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
936 
937             // call core
938             core(_rID, _pID, _eth, _affID, _team, _eventData_);
939 
940         // if round is not active and end round needs to be ran
941         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
942             // end the round (distributes pot) & start new round
943             round_[_rID].ended = true;
944             _eventData_ = endRound(_eventData_);
945 
946             // build event data
947             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
948             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
949 
950             // fire buy and distribute event
951             emit F3Devents.onReLoadAndDistribute
952             (
953             msg.sender,
954             plyr_[_pID].name,
955             _eventData_.compressedData,
956             _eventData_.compressedIDs,
957             _eventData_.winnerAddr,
958             _eventData_.winnerName,
959             _eventData_.amountWon,
960             _eventData_.newPot,
961             _eventData_.P3DAmount,
962             _eventData_.genAmount
963             );
964         }
965     }
966 
967     /**
968      * @dev this is the core logic for any buy/reload that happens while a round
969      * is live.
970      */
971     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
972     private
973     {
974         // if player is new to round
975         if (plyrRnds_[_pID][_rID].keys == 0)
976         _eventData_ = managePlayer(_pID, _eventData_);
977 
978         // early round eth limiter
979         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
980         {
981             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
982             uint256 _refund = _eth.sub(_availableLimit);
983             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
984             _eth = _availableLimit;
985         }
986 
987         // if eth left is greater than min eth allowed (sorry no pocket lint)
988         if (_eth > 1000000000)
989         {
990 
991             // mint the new keys
992             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
993 
994             // if they bought at least 1 whole key
995             if (_keys >= 1000000000000000000)
996             {
997                 updateTimer(_keys, _rID);
998 
999                 // set new leaders
1000                 if (round_[_rID].plyr != _pID)
1001                 round_[_rID].plyr = _pID;
1002                 if (round_[_rID].team != _team)
1003                 round_[_rID].team = _team;
1004 
1005                 // set the new leader bool to true
1006                 _eventData_.compressedData = _eventData_.compressedData + 100;
1007             }
1008 
1009             // manage airdrops
1010             if (_eth >= 100000000000000000)
1011             {
1012                 airDropTracker_++;
1013                 if (airdrop() == true)
1014                 {
1015                     // gib muni
1016                     uint256 _prize;
1017                     if (_eth >= 10000000000000000000)
1018                     {
1019                         // calculate prize and give it to winner
1020                         _prize = ((airDropPot_).mul(75)) / 100;
1021                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1022 
1023                         // adjust airDropPot
1024                         airDropPot_ = (airDropPot_).sub(_prize);
1025 
1026                         // let event know a tier 3 prize was won
1027                         _eventData_.compressedData += 300000000000000000000000000000000;
1028                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1029                         // calculate prize and give it to winner
1030                         _prize = ((airDropPot_).mul(50)) / 100;
1031                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1032 
1033                         // adjust airDropPot
1034                         airDropPot_ = (airDropPot_).sub(_prize);
1035 
1036                         // let event know a tier 2 prize was won
1037                         _eventData_.compressedData += 200000000000000000000000000000000;
1038                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1039                         // calculate prize and give it to winner
1040                         _prize = ((airDropPot_).mul(25)) / 100;
1041                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1042 
1043                         // adjust airDropPot
1044                         airDropPot_ = (airDropPot_).sub(_prize);
1045 
1046                         // let event know a tier 3 prize was won
1047                         _eventData_.compressedData += 300000000000000000000000000000000;
1048                     }
1049                     // set airdrop happened bool to true
1050                     _eventData_.compressedData += 10000000000000000000000000000000;
1051                     // let event know how much was won
1052                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1053 
1054                     // reset air drop tracker
1055                     airDropTracker_ = 0;
1056                 }
1057             }
1058 
1059             // store the air drop tracker number (number of buys since last airdrop)
1060             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1061 
1062             // update player
1063             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1064             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1065 
1066             // update round
1067             round_[_rID].keys = _keys.add(round_[_rID].keys);
1068             round_[_rID].eth = _eth.add(round_[_rID].eth);
1069             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1070 
1071             // distribute eth
1072             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1073             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1074 
1075             // call end tx function to fire end tx event.
1076             endTx(_pID, _team, _eth, _keys, _eventData_);
1077         }
1078     }
1079     //==============================================================================
1080     //     _ _ | _   | _ _|_ _  _ _  .
1081     //    (_(_||(_|_||(_| | (_)| _\  .
1082     //==============================================================================
1083     /**
1084      * @dev calculates unmasked earnings (just calculates, does not update mask)
1085      * @return earnings in wei format
1086      */
1087     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1088     private
1089     view
1090     returns (uint256)
1091     {
1092         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
1093     }
1094 
1095     /**
1096      * @dev returns the amount of keys you would get given an amount of eth.
1097      * -functionhash- 0xce89c80c
1098      * @param _rID round ID you want price for
1099      * @param _eth amount of eth sent in
1100      * @return keys received
1101      */
1102     function calcKeysReceived(uint256 _rID, uint256 _eth)
1103     public
1104     view
1105     returns (uint256)
1106     {
1107         // grab time
1108         uint256 _now = now;
1109 
1110         // are we in a round?
1111         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1112             return ((round_[_rID].eth).keysRec(_eth));
1113         else // rounds over.  need keys for new round
1114             return ((_eth).keys());
1115     }
1116 
1117     /**
1118      * @dev returns current eth price for X keys.
1119      * -functionhash- 0xcf808000
1120      * @param _keys number of keys desired (in 18 decimal format)
1121      * @return amount of eth needed to send
1122      */
1123     function iWantXKeys(uint256 _keys)
1124     public
1125     view
1126     returns (uint256)
1127     {
1128         // setup local rID
1129         uint256 _rID = rID_;
1130 
1131         // grab time
1132         uint256 _now = now;
1133 
1134         // are we in a round?
1135         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1136         return ((round_[_rID].keys.add(_keys)).ethRec(_keys));
1137         else // rounds over.  need price for new round
1138         return ((_keys).eth());
1139     }
1140     //==============================================================================
1141     //    _|_ _  _ | _  .
1142     //     | (_)(_)|_\  .
1143     //==============================================================================
1144     /**
1145      * @dev receives name/player info from names contract
1146      */
1147     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1148     external
1149     {
1150         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1151         if (pIDxAddr_[_addr] != _pID)
1152         pIDxAddr_[_addr] = _pID;
1153         if (pIDxName_[_name] != _pID)
1154         pIDxName_[_name] = _pID;
1155         if (plyr_[_pID].addr != _addr)
1156         plyr_[_pID].addr = _addr;
1157         if (plyr_[_pID].name != _name)
1158         plyr_[_pID].name = _name;
1159         if (plyr_[_pID].laff != _laff)
1160         plyr_[_pID].laff = _laff;
1161         if (plyrNames_[_pID][_name] == false)
1162         plyrNames_[_pID][_name] = true;
1163     }
1164 
1165     /**
1166      * @dev receives entire player name list
1167      */
1168     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1169     external
1170     {
1171         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1172         if (plyrNames_[_pID][_name] == false)
1173         plyrNames_[_pID][_name] = true;
1174     }
1175 
1176     /**
1177      * @dev gets existing or registers new pID.  use this when a player may be new
1178      * @return pID
1179      */
1180     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1181     private
1182     returns (F3Ddatasets.EventReturns)
1183     {
1184         uint256 _pID = pIDxAddr_[msg.sender];
1185         // if player is new to this version of fomo3d
1186         if (_pID == 0)
1187         {
1188             // grab their player ID, name and last aff ID, from player names contract
1189             _pID = PlayerBook.getPlayerID(msg.sender);
1190             bytes32 _name = PlayerBook.getPlayerName(_pID);
1191             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1192 
1193             // set up player account
1194             pIDxAddr_[msg.sender] = _pID;
1195             plyr_[_pID].addr = msg.sender;
1196 
1197             if (_name != "")
1198             {
1199                 pIDxName_[_name] = _pID;
1200                 plyr_[_pID].name = _name;
1201                 plyrNames_[_pID][_name] = true;
1202             }
1203 
1204             if (_laff != 0 && _laff != _pID)
1205             plyr_[_pID].laff = _laff;
1206 
1207             // set the new player bool to true
1208             _eventData_.compressedData = _eventData_.compressedData + 1;
1209         }
1210         return (_eventData_);
1211     }
1212 
1213     /**
1214      * @dev checks to make sure user picked a valid team.  if not sets team
1215      * to default (sneks)
1216      */
1217     function verifyTeam(uint256 _team)
1218     private
1219     pure
1220     returns (uint256)
1221     {
1222         if (_team < 0 || _team > 3)
1223         return (2);
1224         else
1225         return (_team);
1226     }
1227 
1228     /**
1229      * @dev decides if round end needs to be run & new round started.  and if
1230      * player unmasked earnings from previously played rounds need to be moved.
1231      */
1232     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1233     private
1234     returns (F3Ddatasets.EventReturns)
1235     {
1236         // if player has played a previous round, move their unmasked earnings
1237         // from that round to gen vault.
1238         if (plyr_[_pID].lrnd != 0)
1239         updateGenVault(_pID, plyr_[_pID].lrnd);
1240 
1241         // update player's last round played
1242         plyr_[_pID].lrnd = rID_;
1243 
1244         // set the joined round bool to true
1245         _eventData_.compressedData = _eventData_.compressedData + 10;
1246 
1247         return (_eventData_);
1248     }
1249 
1250     /**
1251      * @dev ends the round. manages paying out winner/splitting up pot
1252      */
1253     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1254     private
1255     returns (F3Ddatasets.EventReturns)
1256     {
1257         // setup local rID
1258         uint256 _rID = rID_;
1259 
1260         // grab our winning player and team id's
1261         uint256 _winPID = round_[_rID].plyr;
1262         uint256 _winTID = round_[_rID].team;
1263 
1264         // grab our pot amount
1265         uint256 _pot = round_[_rID].pot;
1266 
1267         // calculate our winner share, community rewards, gen share,
1268         // p3d share, and amount reserved for next pot
1269         uint256 _win = (_pot.mul(48)) / 100;
1270         uint256 _com = (_pot / 50);
1271         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1272         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1273         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1274 
1275         // calculate ppt for round mask
1276         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1277         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1278         if (_dust > 0)
1279         {
1280             _gen = _gen.sub(_dust);
1281             _res = _res.add(_dust);
1282         }
1283 
1284         // pay our winner
1285         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1286 
1287         // community rewards
1288         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1289         {
1290         // This ensures Team Just cannot influence the outcome of FoMo3D with
1291         // bank migrations by breaking outgoing transactions.
1292         // Something we would never do. But that's not the point.
1293         // We spent 2000$ in eth re-deploying just to patch this, we hold the
1294         // highest belief that everything we create should be trustless.
1295         // Team JUST, The name you shouldn't have to trust.
1296             _p3d = _p3d.add(_com);
1297             _com = 0;
1298         }
1299 
1300         // distribute gen portion to key holders
1301         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1302 
1303         // send share for p3d to divies
1304         if (_p3d > 0)
1305             Divies.deposit.value(_p3d)();
1306 
1307         // prepare event data
1308         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1309         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1310         _eventData_.winnerAddr = plyr_[_winPID].addr;
1311         _eventData_.winnerName = plyr_[_winPID].name;
1312         _eventData_.amountWon = _win;
1313         _eventData_.genAmount = _gen;
1314         _eventData_.P3DAmount = _p3d;
1315         _eventData_.newPot = _res;
1316 
1317         // start next round
1318         rID_++;
1319         _rID++;
1320         round_[_rID].strt = now;
1321         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1322         round_[_rID].pot = _res;
1323 
1324         return (_eventData_);
1325     }
1326 
1327     /**
1328      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1329      */
1330     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1331     private
1332     {
1333         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1334         if (_earnings > 0)
1335         {
1336             // put in gen vault
1337             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1338             // zero out their earnings by updating mask
1339             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1340         }
1341     }
1342 
1343     /**
1344      * @dev updates round timer based on number of whole keys bought.
1345      */
1346     function updateTimer(uint256 _keys, uint256 _rID)
1347     private
1348     {
1349         // grab time
1350         uint256 _now = now;
1351 
1352         // calculate time based on number of keys bought
1353         uint256 _newTime;
1354         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1355         _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1356         else
1357         _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1358 
1359         // compare to max and set new end time
1360         if (_newTime < (rndMax_).add(_now))
1361         round_[_rID].end = _newTime;
1362         else
1363         round_[_rID].end = rndMax_.add(_now);
1364     }
1365 
1366     /**
1367      * @dev generates a random number between 0-99 and checks to see if thats
1368      * resulted in an airdrop win
1369      * @return do we have a winner?
1370      */
1371     function airdrop()
1372     private
1373     view
1374     returns (bool)
1375     {
1376         uint256 seed = uint256(keccak256(abi.encodePacked(
1377 
1378         (block.timestamp).add
1379         (block.difficulty).add
1380         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1381         (block.gaslimit).add
1382         ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1383         (block.number)
1384 
1385         )));
1386         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1387         return (true);
1388         else
1389         return (false);
1390     }
1391 
1392     /**
1393      * @dev distributes eth based on fees to com, aff, and p3d
1394      */
1395     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1396     private
1397     returns (F3Ddatasets.EventReturns)
1398     {
1399         // pay 2% out to community rewards
1400         uint256 _com = _eth / 50;
1401         uint256 _p3d;
1402         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1403         {
1404         // This ensures Team Just cannot influence the outcome of FoMo3D with
1405         // bank migrations by breaking outgoing transactions.
1406         // Something we would never do. But that's not the point.
1407         // We spent 2000$ in eth re-deploying just to patch this, we hold the
1408         // highest belief that everything we create should be trustless.
1409         // Team JUST, The name you shouldn't have to trust.
1410         _p3d = _com;
1411         _com = 0;
1412         }
1413 
1414         // pay 1% out to FoMo3D short
1415         uint256 _long = _eth / 100;
1416         //otherF3D_.potSwap.value(_long)();
1417 
1418         // distribute share to affiliate
1419         uint256 _aff = _eth / 10;
1420 
1421         // decide what to do with affiliate share of fees
1422         // affiliate must not be self, and must have a name registered
1423         if (_affID != _pID && plyr_[_affID].name != '') {
1424         plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1425         emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1426         } else {
1427         _p3d = _aff;
1428         }
1429 
1430         // pay out p3d
1431         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1432         if (_p3d > 0)
1433         {
1434         // deposit to divies contract
1435         Divies.deposit.value(_p3d)();
1436 
1437         // set up event data
1438         _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1439         }
1440 
1441         return (_eventData_);
1442     }
1443 
1444     function potSwap()
1445     external
1446     payable
1447     {
1448         // setup local rID
1449         uint256 _rID = rID_ + 1;
1450 
1451         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1452         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1453     }
1454 
1455     /**
1456      * @dev distributes eth based on fees to gen and pot
1457      */
1458     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1459     private
1460     returns (F3Ddatasets.EventReturns)
1461     {
1462         // calculate gen share
1463         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1464 
1465         // toss 1% into airdrop pot
1466         uint256 _air = (_eth / 100);
1467         airDropPot_ = airDropPot_.add(_air);
1468 
1469         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1470         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1471 
1472         // calculate pot
1473         uint256 _pot = _eth.sub(_gen);
1474 
1475         // distribute gen share (thats what updateMasks() does) and adjust
1476         // balances for dust.
1477         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1478         if (_dust > 0)
1479         _gen = _gen.sub(_dust);
1480 
1481         // add eth to pot
1482         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1483 
1484         // set up event data
1485         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1486         _eventData_.potAmount = _pot;
1487 
1488         return (_eventData_);
1489     }
1490 
1491     /**
1492      * @dev updates masks for round and player when keys are bought
1493      * @return dust left over
1494      */
1495     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1496     private
1497     returns (uint256)
1498     {
1499         /* MASKING NOTES
1500             earnings masks are a tricky thing for people to wrap their minds around.
1501             the basic thing to understand here.  is were going to have a global
1502             tracker based on profit per share for each round, that increases in
1503             relevant proportion to the increase in share supply.
1504 
1505             the player will have an additional mask that basically says "based
1506             on the rounds mask, my shares, and how much i've already withdrawn,
1507             how much is still owed to me?"
1508         */
1509 
1510         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1511         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1512         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1513 
1514         // calculate player earning from their own buy (only based on the keys
1515         // they just bought).  & update player earnings mask
1516         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1517         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1518 
1519         // calculate & return dust
1520         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1521     }
1522 
1523     /**
1524      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1525      * @return earnings in wei format
1526      */
1527     function withdrawEarnings(uint256 _pID)
1528     private
1529     returns (uint256)
1530     {
1531         // update gen vault
1532         updateGenVault(_pID, plyr_[_pID].lrnd);
1533 
1534         // from vaults
1535         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1536         if (_earnings > 0)
1537         {
1538         plyr_[_pID].win = 0;
1539         plyr_[_pID].gen = 0;
1540         plyr_[_pID].aff = 0;
1541         }
1542 
1543         return (_earnings);
1544     }
1545 
1546     /**
1547      * @dev prepares compression data and fires event for buy or reload tx's
1548      */
1549     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1550     private
1551     {
1552         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1553         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1554 
1555         emit F3Devents.onEndTx
1556         (
1557         _eventData_.compressedData,
1558         _eventData_.compressedIDs,
1559         plyr_[_pID].name,
1560         msg.sender,
1561         _eth,
1562         _keys,
1563         _eventData_.winnerAddr,
1564         _eventData_.winnerName,
1565         _eventData_.amountWon,
1566         _eventData_.newPot,
1567         _eventData_.P3DAmount,
1568         _eventData_.genAmount,
1569         _eventData_.potAmount,
1570         airDropPot_
1571         );
1572     }
1573     //==============================================================================
1574     //    (~ _  _    _._|_    .
1575     //    _)(/_(_|_|| | | \/  .
1576     //====================/=========================================================
1577     /** upon contract deploy, it will be deactivated.  this is a one time
1578      * use function that will activate the contract.  we do this so devs
1579      * have time to set things up on the web end                            **/
1580     bool public activated_ = false;
1581     function activate()
1582     public
1583     {
1584         // only team just can activate
1585         require(
1586         msg.sender == 0xC6a376F0037da2D3e9b47e38838d3d4D0da509c1 ||
1587         msg.sender == 0x9796dEbbC98aA7061dbBbA72829F9C094D30A2f5 ||
1588         msg.sender == 0x8Eb9d3aEA9a74F7d8e6206576645E64CE3c92aA9 ||
1589         msg.sender == 0x23f9BbcAd3E34e7887727D61DD61Ac43c17cdCbd ||
1590         msg.sender == 0xA2396623aac1dfcCfCfA0540D796Dd52270F7c7c,
1591         "only team just can activate"
1592         );
1593 
1594         // make sure that its been linked.
1595         //require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1596 
1597         // can only be ran once
1598         require(activated_ == false, "fomo3d already activated");
1599 
1600         // activate the contract
1601         activated_ = true;
1602 
1603         // lets start first round
1604         rID_ = 1;
1605         round_[1].strt = now + rndExtra_ - rndGap_;
1606         round_[1].end = now + rndInit_ + rndExtra_;
1607     }
1608     function setOtherFomo(address _otherF3D)
1609     public
1610     {
1611         // only team just can activate
1612         require(
1613         msg.sender == 0xC6a376F0037da2D3e9b47e38838d3d4D0da509c1 ||
1614         msg.sender == 0x9796dEbbC98aA7061dbBbA72829F9C094D30A2f5 ||
1615         msg.sender == 0x8Eb9d3aEA9a74F7d8e6206576645E64CE3c92aA9 ||
1616         msg.sender == 0x23f9BbcAd3E34e7887727D61DD61Ac43c17cdCbd ||
1617         msg.sender == 0xA2396623aac1dfcCfCfA0540D796Dd52270F7c7c,
1618         "only team just can activate"
1619         );
1620 
1621         // make sure that it HASNT yet been linked.
1622         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1623 
1624         // set up other fomo3d (fast or long) for pot swap
1625         otherF3D_ = otherFoMo3D(_otherF3D);
1626     }
1627 }
1628 
1629 //==============================================================================
1630 //   __|_ _    __|_ _  .
1631 //  _\ | | |_|(_ | _\  .
1632 //==============================================================================
1633 library F3Ddatasets {
1634     //compressedData key
1635     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1636     // 0 - new player (bool)
1637     // 1 - joined round (bool)
1638     // 2 - new  leader (bool)
1639     // 3-5 - air drop tracker (uint 0-999)
1640     // 6-16 - round end time
1641     // 17 - winnerTeam
1642     // 18 - 28 timestamp
1643     // 29 - team
1644     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1645     // 31 - airdrop happened bool
1646     // 32 - airdrop tier
1647     // 33 - airdrop amount won
1648     //compressedIDs key
1649     // [77-52][51-26][25-0]
1650     // 0-25 - pID
1651     // 26-51 - winPID
1652     // 52-77 - rID
1653     struct EventReturns {
1654         uint256 compressedData;
1655         uint256 compressedIDs;
1656         address winnerAddr;         // winner address
1657         bytes32 winnerName;         // winner name
1658         uint256 amountWon;          // amount won
1659         uint256 newPot;             // amount in new pot
1660         uint256 P3DAmount;          // amount distributed to p3d
1661         uint256 genAmount;          // amount distributed to gen
1662         uint256 potAmount;          // amount added to pot
1663     }
1664     struct Player {
1665         address addr;   // player address
1666         bytes32 name;   // player name
1667         uint256 win;    // winnings vault
1668         uint256 gen;    // general vault
1669         uint256 aff;    // affiliate vault
1670         uint256 lrnd;   // last round played
1671         uint256 laff;   // last affiliate id used
1672     }
1673     struct PlayerRounds {
1674         uint256 eth;    // eth player has added to round (used for eth limiter)
1675         uint256 keys;   // keys
1676         uint256 mask;   // player mask
1677         uint256 ico;    // ICO phase investment
1678     }
1679     struct Round {
1680         uint256 plyr;   // pID of player in lead
1681         uint256 team;   // tID of team in lead
1682         uint256 end;    // time ends/ended
1683         bool ended;     // has round end function been ran
1684         uint256 strt;   // time round started
1685         uint256 keys;   // keys
1686         uint256 eth;    // total eth in
1687         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1688         uint256 mask;   // global mask
1689         uint256 ico;    // total eth sent in during ICO phase
1690         uint256 icoGen; // total eth for gen during ICO phase
1691         uint256 icoAvg; // average key price for ICO phase
1692     }
1693     struct TeamFee {
1694         uint256 gen;    // % of buy in thats paid to key holders of current round
1695         uint256 p3d;    // % of buy in thats paid to p3d holders
1696     }
1697     struct PotSplit {
1698         uint256 gen;    // % of pot thats paid to key holders of current round
1699         uint256 p3d;    // % of pot thats paid to p3d holders
1700     }
1701 }
1702 
1703 //==============================================================================
1704 //  |  _      _ _ | _  .
1705 //  |<(/_\/  (_(_||(_  .
1706 //=======/======================================================================
1707 library F3DKeysCalcLong {
1708     using SafeMath for *;
1709     /**
1710      * @dev calculates number of keys received given X eth
1711      * @param _curEth current amount of eth in contract
1712      * @param _newEth eth being spent
1713      * @return amount of ticket purchased
1714      */
1715     function keysRec(uint256 _curEth, uint256 _newEth)
1716     internal
1717     pure
1718     returns (uint256)
1719     {
1720         return (keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1721     }
1722 
1723     /**
1724      * @dev calculates amount of eth received if you sold X keys
1725      * @param _curKeys current amount of keys that exist
1726      * @param _sellKeys amount of keys you wish to sell
1727      * @return amount of eth received
1728      */
1729     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1730     internal
1731     pure
1732     returns (uint256)
1733     {
1734         return ((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1735     }
1736 
1737     /**
1738      * @dev calculates how many keys would exist with given an amount of eth
1739      * @param _eth eth "in contract"
1740      * @return number of keys that would exist
1741      */
1742     function keys(uint256 _eth)
1743     internal
1744     pure
1745     returns (uint256)
1746     {
1747         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1748     }
1749 
1750     /**
1751      * @dev calculates how much eth would be in contract given a number of keys
1752      * @param _keys number of keys "in contract"
1753      * @return eth that would exists
1754      */
1755     function eth(uint256 _keys)
1756     internal
1757     pure
1758     returns (uint256)
1759     {
1760         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1761     }
1762 }
1763 
1764 //==============================================================================
1765 //  . _ _|_ _  _ |` _  _ _  _  .
1766 //  || | | (/_| ~|~(_|(_(/__\  .
1767 //==============================================================================
1768 interface otherFoMo3D {
1769     function potSwap() external payable;
1770 }
1771 
1772 interface F3DexternalSettingsInterface {
1773     function getFastGap() external returns (uint256);
1774     function getLongGap() external returns (uint256);
1775     function getFastExtra() external returns (uint256);
1776     function getLongExtra() external returns (uint256);
1777 }
1778 
1779 interface DiviesInterface {
1780     function deposit() external payable;
1781 }
1782 
1783 interface JIincForwarderInterface {
1784     function deposit() external payable returns (bool);
1785     function status() external view returns (address, address, bool);
1786     function startMigration(address _newCorpBank) external returns (bool);
1787     function cancelMigration() external returns (bool);
1788     function finishMigration() external returns (bool);
1789     function setup(address _firstCorpBank) external;
1790 }
1791 
1792 interface PlayerBookInterface {
1793     function getPlayerID(address _addr) external returns (uint256);
1794     function getPlayerName(uint256 _pID) external view returns (bytes32);
1795     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1796     function getPlayerAddr(uint256 _pID) external view returns (address);
1797     function getNameFee() external view returns (uint256);
1798     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1799     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns (bool, uint256);
1800     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns (bool, uint256);
1801 }
1802 
1803 /**
1804 * @title -Name Filter- v0.1.9
1805 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1806 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1807 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1808 *                                  _____                      _____
1809 *                                 (, /     /)       /) /)    (, /      /)          /)
1810 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1811 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1812 *          ┴ ┴                /   /          .-/ _____   (__ /
1813 *                            (__ /          (_/ (, /                                      /)™
1814 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1815 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1816 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1817 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1818 *              _       __    _      ____      ____  _   _    _____  ____  ___
1819 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1820 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1821 *
1822 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1823 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1824 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1825 */
1826 
1827 library NameFilter {
1828     /**
1829      * @dev filters name strings
1830      * -converts uppercase to lower case.
1831      * -makes sure it does not start/end with a space
1832      * -makes sure it does not contain multiple spaces in a row
1833      * -cannot be only numbers
1834      * -cannot start with 0x
1835      * -restricts characters to A-Z, a-z, 0-9, and space.
1836      * @return reprocessed string in bytes32 format
1837      */
1838     function nameFilter(string _input)
1839     internal
1840     pure
1841     returns (bytes32)
1842     {
1843         bytes memory _temp = bytes(_input);
1844         uint256 _length = _temp.length;
1845 
1846         //sorry limited to 32 characters
1847         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1848         // make sure it doesnt start with or end with space
1849         require(_temp[0] != 0x20 && _temp[_length - 1] != 0x20, "string cannot start or end with space");
1850         // make sure first two characters are not 0x
1851         if (_temp[0] == 0x30)
1852         {
1853             require(_temp[1] != 0x78, "string cannot start with 0x");
1854             require(_temp[1] != 0x58, "string cannot start with 0X");
1855         }
1856 
1857         // create a bool to track if we have a non number character
1858         bool _hasNonNumber;
1859 
1860         // convert & check
1861         for (uint256 i = 0; i < _length; i++)
1862         {
1863             // if its uppercase A-Z
1864             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1865             {
1866                 // convert to lower case a-z
1867                 _temp[i] = byte(uint(_temp[i]) + 32);
1868 
1869                 // we have a non number
1870                 if (_hasNonNumber == false)
1871                 _hasNonNumber = true;
1872             } else {
1873                 require
1874                 (
1875                 // require character is a space
1876                 _temp[i] == 0x20 ||
1877                 // OR lowercase a-z
1878                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1879                 // or 0-9
1880                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
1881                 "string contains invalid characters"
1882                 );
1883                 // make sure theres not 2x spaces in a row
1884                 if (_temp[i] == 0x20)
1885                 require(_temp[i + 1] != 0x20, "string cannot contain consecutive spaces");
1886 
1887                 // see if we have a character other than a number
1888                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1889                 _hasNonNumber = true;
1890             }
1891         }
1892 
1893         require(_hasNonNumber == true, "string cannot be only numbers");
1894 
1895         bytes32 _ret;
1896         assembly {
1897         _ret := mload(add(_temp, 32))
1898         }
1899         return (_ret);
1900     }
1901 }
1902 
1903 /**
1904  * @title SafeMath v0.1.9
1905  * @dev Math operations with safety checks that throw on error
1906  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1907  * - added sqrt
1908  * - added sq
1909  * - added pwr
1910  * - changed asserts to requires with error log outputs
1911  * - removed div, its useless
1912  */
1913 library SafeMath {
1914 
1915     /**
1916     * @dev Multiplies two numbers, throws on overflow.
1917     */
1918     function mul(uint256 a, uint256 b)
1919     internal
1920     pure
1921     returns (uint256 c)
1922     {
1923         if (a == 0) {
1924         return 0;
1925         }
1926         c = a * b;
1927         require(c / a == b, "SafeMath mul failed");
1928         return c;
1929     }
1930 
1931     /**
1932     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1933     */
1934     function sub(uint256 a, uint256 b)
1935     internal
1936     pure
1937     returns (uint256)
1938     {
1939         require(b <= a, "SafeMath sub failed");
1940         return a - b;
1941     }
1942 
1943     /**
1944     * @dev Adds two numbers, throws on overflow.
1945     */
1946     function add(uint256 a, uint256 b)
1947     internal
1948     pure
1949     returns (uint256 c)
1950     {
1951         c = a + b;
1952         require(c >= a, "SafeMath add failed");
1953         return c;
1954     }
1955 
1956     /**
1957      * @dev gives square root of given x.
1958      */
1959     function sqrt(uint256 x)
1960     internal
1961     pure
1962     returns (uint256 y)
1963     {
1964         uint256 z = ((add(x, 1)) / 2);
1965         y = x;
1966         while (z < y)
1967         {
1968             y = z;
1969             z = ((add((x / z), z)) / 2);
1970         }
1971     }
1972 
1973     /**
1974      * @dev gives square. multiplies x by x
1975      */
1976     function sq(uint256 x)
1977     internal
1978     pure
1979     returns (uint256)
1980     {
1981         return (mul(x, x));
1982     }
1983 
1984     /**
1985      * @dev x to the power of y
1986      */
1987     function pwr(uint256 x, uint256 y)
1988     internal
1989     pure
1990     returns (uint256)
1991     {
1992         if (x == 0)
1993             return (0);
1994         else if (y == 0)
1995             return (1);
1996         else
1997         {
1998             uint256 z = x;
1999             for (uint256 i =1; i < y; i++)
2000             z = mul(z, x);
2001             return (z);
2002         }
2003     }
2004 }