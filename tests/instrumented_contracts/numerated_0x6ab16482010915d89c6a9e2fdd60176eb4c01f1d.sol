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
185   // TOBEFIXED: change contract address
186 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x2Ddad27212769D5C87cba9112c6C232628F545bc);
187 //==============================================================================
188 //     _ _  _  |`. _     _ _ |_ | _  _  .
189 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
190 //=================_|===========================================================
191     string constant public name = "FoMo3D Long Gold";
192     string constant public symbol = "F3DLG";
193 	uint256 private rndExtra_ = 0;     // length of the very first ICO , set to 0
194     uint256 private rndGap_ = 0;     // length of ICO phase, set to 0
195     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
196     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
197     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
198 //==============================================================================
199 //     _| _ _|_ _    _ _ _|_    _   .
200 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
201 //=============================|================================================
202 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
203     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
204     uint256 public rID_;    // round id number / total rounds that have happened
205 //****************
206 // PLAYER DATA 
207 //****************
208     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
209     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
210     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
211     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
212     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
213 //****************
214 // ROUND DATA 
215 //****************
216     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
217     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
218 //****************
219 // TEAM FEE DATA 
220 //****************
221     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
222     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
223 //==============================================================================
224 //     _ _  _  __|_ _    __|_ _  _  .
225 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
226 //==============================================================================
227     constructor()
228         public
229     {
230 		// Team allocation structures
231         // 0 = whales
232         // 1 = bears
233         // 2 = sneks
234         // 3 = bulls
235 
236 		// Team allocation percentages
237         // (F3D, P3D) + (Pot , Referrals, Community)
238             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
239         fees_[0] = F3Ddatasets.TeamFee(60,0);   //20% to pot, 20% to aff, 0% to com, 0% to pot swap, 0% to air drop pot
240         fees_[1] = F3Ddatasets.TeamFee(60,0);   //20% to pot, 20% to aff, 0% to com, 0% to pot swap, 0% to air drop pot
241         fees_[2] = F3Ddatasets.TeamFee(60,0);   //20% to pot, 20% to aff, 0% to com, 0% to pot swap, 0% to air drop pot
242         fees_[3] = F3Ddatasets.TeamFee(60,0);   //20% to pot, 20% to aff, 0% to com, 0% to pot swap, 0% to air drop pot
243         
244         // how to split up the final pot based on which team was picked
245         // (F3D, P3D)
246         potSplit_[0] = F3Ddatasets.PotSplit(20,0);  //80% to winner, 0% to next round, 0% to com
247         potSplit_[1] = F3Ddatasets.PotSplit(20,0);  //80% to winner, 0% to next round, 0% to com
248         potSplit_[2] = F3Ddatasets.PotSplit(20,0);  //80% to winner, 0% to next round, 0% to com
249         potSplit_[3] = F3Ddatasets.PotSplit(20,0);  //80% to winner, 0% to next round, 0% to com
250 	}
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
292     function()
293         isActivated()
294         isHuman()
295         isWithinLimits(msg.value)
296         public
297         payable
298     {
299         // set up our tx event data and determine if player is new or not
300         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
301             
302         // fetch player id
303         uint256 _pID = pIDxAddr_[msg.sender];
304         
305         // buy core 
306         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
307     }
308     
309     /**
310      * @dev converts all incoming ethereum to keys.
311      * -functionhash- 0x8f38f309 (using ID for affiliate)
312      * -functionhash- 0x98a0871d (using address for affiliate)
313      * -functionhash- 0xa65b37a1 (using name for affiliate)
314      * @param _affCode the ID/address/name of the player who gets the affiliate fee
315      * @param _team what team is the player playing for?
316      */
317     function buyXid(uint256 _affCode, uint256 _team)
318         isActivated()
319         isHuman()
320         isWithinLimits(msg.value)
321         public
322         payable
323     {
324         // set up our tx event data and determine if player is new or not
325         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
326         
327         // fetch player id
328         uint256 _pID = pIDxAddr_[msg.sender];
329         
330         // manage affiliate residuals
331         // if no affiliate code was given or player tried to use their own, lolz
332         if (_affCode == 0 || _affCode == _pID)
333         {
334             // use last stored affiliate code 
335             _affCode = plyr_[_pID].laff;
336             
337         // if affiliate code was given & its not the same as previously stored 
338         } else if (_affCode != plyr_[_pID].laff) {
339             // update last affiliate 
340             plyr_[_pID].laff = _affCode;
341         }
342         
343         // verify a valid team was selected
344         _team = verifyTeam(_team);
345         
346         // buy core 
347         buyCore(_pID, _affCode, _team, _eventData_);
348     }
349     
350     function buyXaddr(address _affCode, uint256 _team)
351         isActivated()
352         isHuman()
353         isWithinLimits(msg.value)
354         public
355         payable
356     {
357         // set up our tx event data and determine if player is new or not
358         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
359         
360         // fetch player id
361         uint256 _pID = pIDxAddr_[msg.sender];
362         
363         // manage affiliate residuals
364         uint256 _affID;
365         // if no affiliate code was given or player tried to use their own, lolz
366         if (_affCode == address(0) || _affCode == msg.sender)
367         {
368             // use last stored affiliate code
369             _affID = plyr_[_pID].laff;
370         
371         // if affiliate code was given    
372         } else {
373             // get affiliate ID from aff Code 
374             _affID = pIDxAddr_[_affCode];
375             
376             // if affID is not the same as previously stored 
377             if (_affID != plyr_[_pID].laff)
378             {
379                 // update last affiliate
380                 plyr_[_pID].laff = _affID;
381             }
382         }
383         
384         // verify a valid team was selected
385         _team = verifyTeam(_team);
386         
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
399         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
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
449         F3Ddatasets.EventReturns memory _eventData_;
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
481         F3Ddatasets.EventReturns memory _eventData_;
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
521         F3Ddatasets.EventReturns memory _eventData_;
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
579             F3Ddatasets.EventReturns memory _eventData_;
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
590                 // IF anything goes wrong, prevent eth being stuck in the contract
591                 plyr_[_pID].addr.transfer(_eth < address(this).balance ? _eth : address(this).balance);    
592             
593             // build event data
594             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
595             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
596             
597             // fire withdraw and distribute event
598             emit F3Devents.onWithdrawAndDistribute
599             (
600                 msg.sender, 
601                 plyr_[_pID].name, 
602                 _eth, 
603                 _eventData_.compressedData, 
604                 _eventData_.compressedIDs, 
605                 _eventData_.winnerAddr, 
606                 _eventData_.winnerName, 
607                 _eventData_.amountWon, 
608                 _eventData_.newPot, 
609                 _eventData_.P3DAmount, 
610                 _eventData_.genAmount
611             );
612             
613         // in any other situation
614         } else {
615             // get their earnings
616             _eth = withdrawEarnings(_pID);
617             
618             // gib moni
619             if (_eth > 0)
620                 plyr_[_pID].addr.transfer(_eth);
621             
622             // fire withdraw event
623             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
624         }
625     }
626     
627     /**
628      * @dev use these to register names.  they are just wrappers that will send the
629      * registration requests to the PlayerBook contract.  So registering here is the 
630      * same as registering there.  UI will always display the last name you registered.
631      * but you will still own all previously registered names to use as affiliate 
632      * links.
633      * - must pay a registration fee.
634      * - name must be unique
635      * - names will be converted to lowercase
636      * - name cannot start or end with a space 
637      * - cannot have more than 1 space in a row
638      * - cannot be only numbers
639      * - cannot start with 0x 
640      * - name must be at least 1 char
641      * - max length of 32 characters long
642      * - allowed characters: a-z, 0-9, and space
643      * -functionhash- 0x921dec21 (using ID for affiliate)
644      * -functionhash- 0x3ddd4698 (using address for affiliate)
645      * -functionhash- 0x685ffd83 (using name for affiliate)
646      * @param _nameString players desired name
647      * @param _affCode affiliate ID, address, or name of who referred you
648      * @param _all set to true if you want this to push your info to all games 
649      * (this might cost a lot of gas)
650      */
651     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
652         isHuman()
653         public
654         payable
655     {
656         bytes32 _name = _nameString.nameFilter();
657         address _addr = msg.sender;
658         uint256 _paid = msg.value;
659         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
660         
661         uint256 _pID = pIDxAddr_[_addr];
662         
663         // fire event
664         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
665     }
666     
667     function registerNameXaddr(string _nameString, address _affCode, bool _all)
668         isHuman()
669         public
670         payable
671     {
672         bytes32 _name = _nameString.nameFilter();
673         address _addr = msg.sender;
674         uint256 _paid = msg.value;
675         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
676         
677         uint256 _pID = pIDxAddr_[_addr];
678         
679         // fire event
680         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
681     }
682     
683     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
684         isHuman()
685         public
686         payable
687     {
688         bytes32 _name = _nameString.nameFilter();
689         address _addr = msg.sender;
690         uint256 _paid = msg.value;
691         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
692         
693         uint256 _pID = pIDxAddr_[_addr];
694         
695         // fire event
696         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
697     }
698 //==============================================================================
699 //     _  _ _|__|_ _  _ _  .
700 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
701 //=====_|=======================================================================
702     /**
703      * @dev return the price buyer will pay for next 1 individual key.
704      * -functionhash- 0x018a25e8
705      * @return price for next key bought (in wei format)
706      */
707     function getBuyPrice()
708         public 
709         view 
710         returns(uint256)
711     {  
712         // setup local rID
713         uint256 _rID = rID_;
714         
715         // grab time
716         uint256 _now = now;
717         
718         // are we in a round?
719         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
720             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
721         else // rounds over.  need price for new round
722             return ( 75000000000000 ); // init
723     }
724     
725     /**
726      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
727      * provider
728      * -functionhash- 0xc7e284b8
729      * @return time left in seconds
730      */
731     function getTimeLeft()
732         public
733         view
734         returns(uint256)
735     {
736         // setup local rID
737         uint256 _rID = rID_;
738         
739         // grab time
740         uint256 _now = now;
741         
742         if (_now < round_[_rID].end)
743             if (_now > round_[_rID].strt + rndGap_)
744                 return( (round_[_rID].end).sub(_now) );
745             else
746                 return( (round_[_rID].strt + rndGap_).sub(_now) );
747         else
748             return(0);
749     }
750     
751     /**
752      * @dev returns player earnings per vaults 
753      * -functionhash- 0x63066434
754      * @return winnings vault
755      * @return general vault
756      * @return affiliate vault
757      */
758     function getPlayerVaults(uint256 _pID)
759         public
760         view
761         returns(uint256 ,uint256, uint256)
762     {
763         // setup local rID
764         uint256 _rID = rID_;
765         
766         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
767         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
768         {
769             // if player is winner 
770             if (round_[_rID].plyr == _pID)
771             {
772                 return
773                 (
774                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
775                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
776                     plyr_[_pID].aff
777                 );
778             // if player is not the winner
779             } else {
780                 return
781                 (
782                     plyr_[_pID].win,
783                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
784                     plyr_[_pID].aff
785                 );
786             }
787             
788         // if round is still going on, or round has ended and round end has been ran
789         } else {
790             return
791             (
792                 plyr_[_pID].win,
793                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
794                 plyr_[_pID].aff
795             );
796         }
797     }
798     
799     /**
800      * solidity hates stack limits.  this lets us avoid that hate 
801      */
802     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
803         private
804         view
805         returns(uint256)
806     {
807         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
808     }
809     
810     /**
811      * @dev returns all current round info needed for front end
812      * -functionhash- 0x747dff42
813      * @return eth invested during ICO phase
814      * @return round id 
815      * @return total keys for round 
816      * @return time round ends
817      * @return time round started
818      * @return current pot 
819      * @return current team ID & player ID in lead 
820      * @return current player in leads address 
821      * @return current player in leads name
822      * @return whales eth in for round
823      * @return bears eth in for round
824      * @return sneks eth in for round
825      * @return bulls eth in for round
826      * @return airdrop tracker # & airdrop pot
827      */
828     function getCurrentRoundInfo()
829         public
830         view
831         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
832     {
833         // setup local rID
834         uint256 _rID = rID_;
835         
836         return
837         (
838             round_[_rID].ico,               //0
839             _rID,                           //1
840             round_[_rID].keys,              //2
841             round_[_rID].end,               //3
842             round_[_rID].strt,              //4
843             round_[_rID].pot,               //5
844             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
845             plyr_[round_[_rID].plyr].addr,  //7
846             plyr_[round_[_rID].plyr].name,  //8
847             rndTmEth_[_rID][0],             //9
848             rndTmEth_[_rID][1],             //10
849             rndTmEth_[_rID][2],             //11
850             rndTmEth_[_rID][3],             //12
851             airDropTracker_ + (airDropPot_ * 1000)              //13
852         );
853     }
854 
855     /**
856      * @dev returns player info based on address.  if no address is given, it will 
857      * use msg.sender 
858      * -functionhash- 0xee0b5d8b
859      * @param _addr address of the player you want to lookup 
860      * @return player ID 
861      * @return player name
862      * @return keys owned (current round)
863      * @return winnings vault
864      * @return general vault 
865      * @return affiliate vault 
866 	 * @return player round eth
867      */
868     function getPlayerInfoByAddress(address _addr)
869         public 
870         view 
871         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
872     {
873         // setup local rID
874         uint256 _rID = rID_;
875         
876         if (_addr == address(0))
877         {
878             _addr == msg.sender;
879         }
880         uint256 _pID = pIDxAddr_[_addr];
881         
882         return
883         (
884             _pID,                               //0
885             plyr_[_pID].name,                   //1
886             plyrRnds_[_pID][_rID].keys,         //2
887             plyr_[_pID].win,                    //3
888             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
889             plyr_[_pID].aff,                    //5
890             plyrRnds_[_pID][_rID].eth           //6
891         );
892     }
893 
894 //==============================================================================
895 //     _ _  _ _   | _  _ . _  .
896 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
897 //=====================_|=======================================================
898     /**
899      * @dev logic runs whenever a buy order is executed.  determines how to handle 
900      * incoming eth depending on if we are in an active round or not
901      */
902     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
903         private
904     {
905         // setup local rID
906         uint256 _rID = rID_;
907         
908         // grab time
909         uint256 _now = now;
910         
911         // if round is active
912         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
913         {
914             // call core 
915             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
916         
917         // if round is not active     
918         } else {
919             // check to see if end round needs to be ran
920             if (_now > round_[_rID].end && round_[_rID].ended == false) 
921             {
922                 // end the round (distributes pot) & start new round
923 			    round_[_rID].ended = true;
924                 _eventData_ = endRound(_eventData_);
925                 
926                 // build event data
927                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
928                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
929                 
930                 // fire buy and distribute event 
931                 emit F3Devents.onBuyAndDistribute
932                 (
933                     msg.sender, 
934                     plyr_[_pID].name, 
935                     msg.value, 
936                     _eventData_.compressedData, 
937                     _eventData_.compressedIDs, 
938                     _eventData_.winnerAddr, 
939                     _eventData_.winnerName, 
940                     _eventData_.amountWon, 
941                     _eventData_.newPot, 
942                     _eventData_.P3DAmount, 
943                     _eventData_.genAmount
944                 );
945             }
946             
947             // put eth in players vault 
948             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
949         }
950     }
951     
952     /**
953      * @dev logic runs whenever a reload order is executed.  determines how to handle 
954      * incoming eth depending on if we are in an active round or not 
955      */
956     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
957         private
958     {
959         // setup local rID
960         uint256 _rID = rID_;
961         
962         // grab time
963         uint256 _now = now;
964         
965         // if round is active
966         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
967         {
968             // get earnings from all vaults and return unused to gen vault
969             // because we use a custom safemath library.  this will throw if player 
970             // tried to spend more eth than they have.
971             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
972             
973             // call core 
974             core(_rID, _pID, _eth, _affID, _team, _eventData_);
975         
976         // if round is not active and end round needs to be ran   
977         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
978             // end the round (distributes pot) & start new round
979             round_[_rID].ended = true;
980             _eventData_ = endRound(_eventData_);
981                 
982             // build event data
983             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
984             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
985                 
986             // fire buy and distribute event 
987             emit F3Devents.onReLoadAndDistribute
988             (
989                 msg.sender, 
990                 plyr_[_pID].name, 
991                 _eventData_.compressedData, 
992                 _eventData_.compressedIDs, 
993                 _eventData_.winnerAddr, 
994                 _eventData_.winnerName, 
995                 _eventData_.amountWon, 
996                 _eventData_.newPot, 
997                 _eventData_.P3DAmount, 
998                 _eventData_.genAmount
999             );
1000         }
1001     }
1002     
1003     /**
1004      * @dev this is the core logic for any buy/reload that happens while a round 
1005      * is live.
1006      */
1007     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1008         private
1009     {
1010         // if player is new to round
1011         if (plyrRnds_[_pID][_rID].keys == 0)
1012             _eventData_ = managePlayer(_pID, _eventData_);
1013         
1014         // early round eth limiter 
1015         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1016         {
1017             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1018             uint256 _refund = _eth.sub(_availableLimit);
1019             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1020             _eth = _availableLimit;
1021         }
1022         
1023         // if eth left is greater than min eth allowed (sorry no pocket lint)
1024         if (_eth > 1000000000) 
1025         {
1026             // mint the new keys
1027             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1028             
1029             // if they bought at least 1 whole key
1030             if (_keys >= 1000000000000000000)
1031             {
1032             updateTimer(_keys, _rID);
1033 
1034             // set new leaders
1035             if (round_[_rID].plyr != _pID)
1036                 round_[_rID].plyr = _pID;  
1037             if (round_[_rID].team != _team)
1038                 round_[_rID].team = _team; 
1039             
1040             // set the new leader bool to true
1041             _eventData_.compressedData = _eventData_.compressedData + 100;
1042         }
1043             
1044             // store the air drop tracker number (number of buys since last airdrop)
1045             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1046             
1047             // update player 
1048             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1049             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1050             
1051             // update round
1052             round_[_rID].keys = _keys.add(round_[_rID].keys);
1053             round_[_rID].eth = _eth.add(round_[_rID].eth);
1054             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1055     
1056             // distribute eth
1057             _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1058             
1059             // call end tx function to fire end tx event.
1060 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1061         }
1062     }
1063 //==============================================================================
1064 //     _ _ | _   | _ _|_ _  _ _  .
1065 //    (_(_||(_|_||(_| | (_)| _\  .
1066 //==============================================================================
1067     /**
1068      * @dev calculates unmasked earnings (just calculates, does not update mask)
1069      * @return earnings in wei format
1070      */
1071     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1072         private
1073         view
1074         returns(uint256)
1075     {
1076         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1077     }
1078     
1079     /** 
1080      * @dev returns the amount of keys you would get given an amount of eth. 
1081      * -functionhash- 0xce89c80c
1082      * @param _rID round ID you want price for
1083      * @param _eth amount of eth sent in 
1084      * @return keys received 
1085      */
1086     function calcKeysReceived(uint256 _rID, uint256 _eth)
1087         public
1088         view
1089         returns(uint256)
1090     {
1091         // grab time
1092         uint256 _now = now;
1093         
1094         // are we in a round?
1095         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1096             return ( (round_[_rID].eth).keysRec(_eth) );
1097         else // rounds over.  need keys for new round
1098             return ( (_eth).keys() );
1099     }
1100     
1101     /** 
1102      * @dev returns current eth price for X keys.  
1103      * -functionhash- 0xcf808000
1104      * @param _keys number of keys desired (in 18 decimal format)
1105      * @return amount of eth needed to send
1106      */
1107     function iWantXKeys(uint256 _keys)
1108         public
1109         view
1110         returns(uint256)
1111     {
1112         // setup local rID
1113         uint256 _rID = rID_;
1114         
1115         // grab time
1116         uint256 _now = now;
1117         
1118         // are we in a round?
1119         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1120             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1121         else // rounds over.  need price for new round
1122             return ( (_keys).eth() );
1123     }
1124 //==============================================================================
1125 //    _|_ _  _ | _  .
1126 //     | (_)(_)|_\  .
1127 //==============================================================================
1128     /**
1129 	 * @dev receives name/player info from names contract 
1130      */
1131     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1132         external
1133     {
1134         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1135         if (pIDxAddr_[_addr] != _pID)
1136             pIDxAddr_[_addr] = _pID;
1137         if (pIDxName_[_name] != _pID)
1138             pIDxName_[_name] = _pID;
1139         if (plyr_[_pID].addr != _addr)
1140             plyr_[_pID].addr = _addr;
1141         if (plyr_[_pID].name != _name)
1142             plyr_[_pID].name = _name;
1143         if (plyr_[_pID].laff != _laff)
1144             plyr_[_pID].laff = _laff;
1145         if (plyrNames_[_pID][_name] == false)
1146             plyrNames_[_pID][_name] = true;
1147     }
1148     
1149     /**
1150      * @dev receives entire player name list 
1151      */
1152     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1153         external
1154     {
1155         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1156         if(plyrNames_[_pID][_name] == false)
1157             plyrNames_[_pID][_name] = true;
1158     }   
1159         
1160     /**
1161      * @dev gets existing or registers new pID.  use this when a player may be new
1162      * @return pID 
1163      */
1164     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1165         private
1166         returns (F3Ddatasets.EventReturns)
1167     {
1168         uint256 _pID = pIDxAddr_[msg.sender];
1169         // if player is new to this version of fomo3d
1170         if (_pID == 0)
1171         {
1172             // grab their player ID, name and last aff ID, from player names contract 
1173             _pID = PlayerBook.getPlayerID(msg.sender);
1174             bytes32 _name = PlayerBook.getPlayerName(_pID);
1175             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1176             
1177             // set up player account 
1178             pIDxAddr_[msg.sender] = _pID;
1179             plyr_[_pID].addr = msg.sender;
1180             
1181             if (_name != "")
1182             {
1183                 pIDxName_[_name] = _pID;
1184                 plyr_[_pID].name = _name;
1185                 plyrNames_[_pID][_name] = true;
1186             }
1187             
1188             if (_laff != 0 && _laff != _pID)
1189                 plyr_[_pID].laff = _laff;
1190             
1191             // set the new player bool to true
1192             _eventData_.compressedData = _eventData_.compressedData + 1;
1193         } 
1194         return (_eventData_);
1195     }
1196     
1197     /**
1198      * @dev checks to make sure user picked a valid team.  if not sets team 
1199      * to default (sneks)
1200      */
1201     function verifyTeam(uint256 _team)
1202         private
1203         pure
1204         returns (uint256)
1205     {
1206         if (_team < 0 || _team > 3)
1207             return(2);
1208         else
1209             return(_team);
1210     }
1211     
1212     /**
1213      * @dev decides if round end needs to be run & new round started.  and if 
1214      * player unmasked earnings from previously played rounds need to be moved.
1215      */
1216     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1217         private
1218         returns (F3Ddatasets.EventReturns)
1219     {
1220         // if player has played a previous round, move their unmasked earnings
1221         // from that round to gen vault.
1222         if (plyr_[_pID].lrnd != 0)
1223             updateGenVault(_pID, plyr_[_pID].lrnd);
1224             
1225         // update player's last round played
1226         plyr_[_pID].lrnd = rID_;
1227             
1228         // set the joined round bool to true
1229         _eventData_.compressedData = _eventData_.compressedData + 10;
1230         
1231         return(_eventData_);
1232     }
1233     
1234     /**
1235      * @dev ends the round. manages paying out winner/splitting up pot
1236      */
1237     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1238         private
1239         returns (F3Ddatasets.EventReturns)
1240     {
1241         // setup local rID
1242         uint256 _rID = rID_;
1243         
1244         // grab our winning player and team id's
1245         uint256 _winPID = round_[_rID].plyr;
1246         uint256 _winTID = round_[_rID].team;
1247         
1248         // grab our pot amount
1249         uint256 _pot = round_[_rID].pot;
1250         
1251         // calculate our winner share, community rewards, gen share, 
1252         // p3d share, and amount reserved for next pot 
1253         uint256 _win = (_pot.mul(80)) / 100;
1254         uint256 _com = 0;
1255         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1256         uint256 _p3d = 0;
1257         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1258         
1259         // calculate ppt for round mask
1260         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1261         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1262         if (_dust > 0)
1263         {
1264             _gen = _gen.sub(_dust);
1265             _res = _res.add(_dust);
1266         }
1267         
1268         // pay our winner
1269         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1270         
1271         // distribute gen portion to key holders
1272         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1273         
1274         // prepare event data
1275         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1276         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1277         _eventData_.winnerAddr = plyr_[_winPID].addr;
1278         _eventData_.winnerName = plyr_[_winPID].name;
1279         _eventData_.amountWon = _win;
1280         _eventData_.genAmount = _gen;
1281         _eventData_.P3DAmount = _p3d;
1282         _eventData_.newPot = _res;
1283         
1284         // start next round
1285         rID_++;
1286         _rID++;
1287         round_[_rID].strt = now;
1288         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1289         round_[_rID].pot = _res;
1290         
1291         return(_eventData_);
1292     }
1293     
1294     /**
1295      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1296      */
1297     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1298         private 
1299     {
1300         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1301         if (_earnings > 0)
1302         {
1303             // put in gen vault
1304             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1305             // zero out their earnings by updating mask
1306             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1307         }
1308     }
1309     
1310     /**
1311      * @dev updates round timer based on number of whole keys bought.
1312      */
1313     function updateTimer(uint256 _keys, uint256 _rID)
1314         private
1315     {
1316         // grab time
1317         uint256 _now = now;
1318         
1319         // calculate time based on number of keys bought
1320         uint256 _newTime;
1321         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1322             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1323         else
1324             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1325         
1326         // compare to max and set new end time
1327         if (_newTime < (rndMax_).add(_now))
1328             round_[_rID].end = _newTime;
1329         else
1330             round_[_rID].end = rndMax_.add(_now);
1331     }
1332     
1333     /**
1334      * @dev generates a random number between 0-99 and checks to see if thats
1335      * resulted in an airdrop win
1336      * @return do we have a winner?
1337      */
1338     function airdrop()
1339         private 
1340         view 
1341         returns(bool)
1342     {
1343         uint256 seed = uint256(keccak256(abi.encodePacked(
1344             
1345             (block.timestamp).add
1346             (block.difficulty).add
1347             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1348             (block.gaslimit).add
1349             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1350             (block.number)
1351             
1352         )));
1353         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1354             return(true);
1355         else
1356             return(false);
1357     }
1358 
1359     function potSwap()
1360         external
1361         payable
1362     {
1363         // setup local rID
1364         uint256 _rID = rID_ + 1;
1365         
1366         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1367         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1368     }
1369     
1370     /**
1371      * @dev distributes eth based on fees to gen and pot
1372      */
1373     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1374         private
1375         returns(F3Ddatasets.EventReturns)
1376     {
1377         // calculate gen share
1378         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1379         
1380         uint256 _aff = _eth / 5;
1381         
1382         // if the _affID is invalid, the portion goes into the pot
1383         if (_affID != _pID && plyr_[_affID].name != '') {
1384             _eth = _eth.sub(_aff);
1385             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1386             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1387         }
1388         
1389         // calculate pot 
1390         uint256 _pot = _eth.sub(_gen);
1391         
1392         // distribute gen share (thats what updateMasks() does) and adjust
1393         // balances for dust.
1394         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1395         if (_dust > 0)
1396             _gen = _gen.sub(_dust);
1397         
1398         // add eth to pot
1399         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1400         
1401         // set up event data
1402         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1403         _eventData_.potAmount = _pot;
1404 
1405         return(_eventData_);
1406     }
1407 
1408     /**
1409      * @dev updates masks for round and player when keys are bought
1410      * @return dust left over 
1411      */
1412     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1413         private
1414         returns(uint256)
1415     {
1416         /* MASKING NOTES
1417             earnings masks are a tricky thing for people to wrap their minds around.
1418             the basic thing to understand here.  is were going to have a global
1419             tracker based on profit per share for each round, that increases in
1420             relevant proportion to the increase in share supply.
1421             
1422             the player will have an additional mask that basically says "based
1423             on the rounds mask, my shares, and how much i've already withdrawn,
1424             how much is still owed to me?"
1425         */
1426         
1427         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1428         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1429         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1430             
1431         // calculate player earning from their own buy (only based on the keys
1432         // they just bought).  & update player earnings mask
1433         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1434         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1435         
1436         // calculate & return dust
1437         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1438     }
1439     
1440     /**
1441      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1442      * @return earnings in wei format
1443      */
1444     function withdrawEarnings(uint256 _pID)
1445         private
1446         returns(uint256)
1447     {
1448         // update gen vault
1449         updateGenVault(_pID, plyr_[_pID].lrnd);
1450         
1451         // from vaults 
1452         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1453         if (_earnings > 0)
1454         {
1455             plyr_[_pID].win = 0;
1456             plyr_[_pID].gen = 0;
1457             plyr_[_pID].aff = 0;
1458         }
1459 
1460         return(_earnings);
1461     }
1462     
1463     /**
1464      * @dev prepares compression data and fires event for buy or reload tx's
1465      */
1466     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1467         private
1468     {
1469         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1470         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1471         
1472         emit F3Devents.onEndTx
1473         (
1474             _eventData_.compressedData,
1475             _eventData_.compressedIDs,
1476             plyr_[_pID].name,
1477             msg.sender,
1478             _eth,
1479             _keys,
1480             _eventData_.winnerAddr,
1481             _eventData_.winnerName,
1482             _eventData_.amountWon,
1483             _eventData_.newPot,
1484             _eventData_.P3DAmount,
1485             _eventData_.genAmount,
1486             _eventData_.potAmount,
1487             airDropPot_
1488         );
1489     }
1490 //==============================================================================
1491 //    (~ _  _    _._|_    .
1492 //    _)(/_(_|_|| | | \/  .
1493 //====================/=========================================================
1494     /** upon contract deploy, it will be deactivated.  this is a one time
1495      * use function that will activate the contract.  we do this so devs 
1496      * have time to set things up on the web end                            **/
1497     bool public activated_ = true;
1498 }
1499 
1500 //==============================================================================
1501 //   __|_ _    __|_ _  .
1502 //  _\ | | |_|(_ | _\  .
1503 //==============================================================================
1504 library F3Ddatasets {
1505     //compressedData key
1506     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1507         // 0 - new player (bool)
1508         // 1 - joined round (bool)
1509         // 2 - new  leader (bool)
1510         // 3-5 - air drop tracker (uint 0-999)
1511         // 6-16 - round end time
1512         // 17 - winnerTeam
1513         // 18 - 28 timestamp 
1514         // 29 - team
1515         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1516         // 31 - airdrop happened bool
1517         // 32 - airdrop tier 
1518         // 33 - airdrop amount won
1519     //compressedIDs key
1520     // [77-52][51-26][25-0]
1521         // 0-25 - pID 
1522         // 26-51 - winPID
1523         // 52-77 - rID
1524     struct EventReturns {
1525         uint256 compressedData;
1526         uint256 compressedIDs;
1527         address winnerAddr;         // winner address
1528         bytes32 winnerName;         // winner name
1529         uint256 amountWon;          // amount won
1530         uint256 newPot;             // amount in new pot
1531         uint256 P3DAmount;          // amount distributed to p3d
1532         uint256 genAmount;          // amount distributed to gen
1533         uint256 potAmount;          // amount added to pot
1534     }
1535     struct Player {
1536         address addr;   // player address
1537         bytes32 name;   // player name
1538         uint256 win;    // winnings vault
1539         uint256 gen;    // general vault
1540         uint256 aff;    // affiliate vault
1541         uint256 lrnd;   // last round played
1542         uint256 laff;   // last affiliate id used
1543     }
1544     struct PlayerRounds {
1545         uint256 eth;    // eth player has added to round (used for eth limiter)
1546         uint256 keys;   // keys
1547         uint256 mask;   // player mask 
1548         uint256 ico;    // ICO phase investment
1549     }
1550     struct Round {
1551         uint256 plyr;   // pID of player in lead
1552         uint256 team;   // tID of team in lead
1553         uint256 end;    // time ends/ended
1554         bool ended;     // has round end function been ran
1555         uint256 strt;   // time round started
1556         uint256 keys;   // keys
1557         uint256 eth;    // total eth in
1558         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1559         uint256 mask;   // global mask
1560         uint256 ico;    // total eth sent in during ICO phase
1561         uint256 icoGen; // total eth for gen during ICO phase
1562         uint256 icoAvg; // average key price for ICO phase
1563     }
1564     struct TeamFee {
1565         uint256 gen;    // % of buy in thats paid to key holders of current round
1566         uint256 p3d;    // % of buy in thats paid to p3d holders
1567     }
1568     struct PotSplit {
1569         uint256 gen;    // % of pot thats paid to key holders of current round
1570         uint256 p3d;    // % of pot thats paid to p3d holders
1571     }
1572 }
1573 
1574 //==============================================================================
1575 //  |  _      _ _ | _  .
1576 //  |<(/_\/  (_(_||(_  .
1577 //=======/======================================================================
1578 library F3DKeysCalcLong {
1579     using SafeMath for *;
1580     /**
1581      * @dev calculates number of keys received given X eth 
1582      * @param _curEth current amount of eth in contract 
1583      * @param _newEth eth being spent
1584      * @return amount of ticket purchased
1585      */
1586     function keysRec(uint256 _curEth, uint256 _newEth)
1587         internal
1588         pure
1589         returns (uint256)
1590     {
1591         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1592     }
1593     
1594     /**
1595      * @dev calculates amount of eth received if you sold X keys 
1596      * @param _curKeys current amount of keys that exist 
1597      * @param _sellKeys amount of keys you wish to sell
1598      * @return amount of eth received
1599      */
1600     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1601         internal
1602         pure
1603         returns (uint256)
1604     {
1605         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1606     }
1607 
1608     /**
1609      * @dev calculates how many keys would exist with given an amount of eth
1610      * @param _eth eth "in contract"
1611      * @return number of keys that would exist
1612      */
1613     function keys(uint256 _eth) 
1614         internal
1615         pure
1616         returns(uint256)
1617     {
1618         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1619     }
1620     
1621     /**
1622      * @dev calculates how much eth would be in contract given a number of keys
1623      * @param _keys number of keys "in contract" 
1624      * @return eth that would exists
1625      */
1626     function eth(uint256 _keys) 
1627         internal
1628         pure
1629         returns(uint256)  
1630     {
1631         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1632     }
1633 }
1634 
1635 //==============================================================================
1636 //  . _ _|_ _  _ |` _  _ _  _  .
1637 //  || | | (/_| ~|~(_|(_(/__\  .
1638 //==============================================================================
1639 interface PlayerBookInterface {
1640     function getPlayerID(address _addr) external returns (uint256);
1641     function getPlayerName(uint256 _pID) external view returns (bytes32);
1642     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1643     function getPlayerAddr(uint256 _pID) external view returns (address);
1644     function getNameFee() external view returns (uint256);
1645     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1646     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1647     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1648 }
1649 
1650 /**
1651 * @title -Name Filter- v0.1.9
1652 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1653 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1654 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1655 *                                  _____                      _____
1656 *                                 (, /     /)       /) /)    (, /      /)          /)
1657 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1658 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1659 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1660 *                            (__ /          (_/ (, /                                      /)™ 
1661 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1662 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1663 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1664 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1665 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1666 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1667 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1668 *
1669 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1670 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1671 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1672 */
1673 
1674 library NameFilter {
1675     /**
1676      * @dev filters name strings
1677      * -converts uppercase to lower case.  
1678      * -makes sure it does not start/end with a space
1679      * -makes sure it does not contain multiple spaces in a row
1680      * -cannot be only numbers
1681      * -cannot start with 0x 
1682      * -restricts characters to A-Z, a-z, 0-9, and space.
1683      * @return reprocessed string in bytes32 format
1684      */
1685     function nameFilter(string _input)
1686         internal
1687         pure
1688         returns(bytes32)
1689     {
1690         bytes memory _temp = bytes(_input);
1691         uint256 _length = _temp.length;
1692         
1693         //sorry limited to 32 characters
1694         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1695         // make sure it doesnt start with or end with space
1696         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1697         // make sure first two characters are not 0x
1698         if (_temp[0] == 0x30)
1699         {
1700             require(_temp[1] != 0x78, "string cannot start with 0x");
1701             require(_temp[1] != 0x58, "string cannot start with 0X");
1702         }
1703         
1704         // create a bool to track if we have a non number character
1705         bool _hasNonNumber;
1706         
1707         // convert & check
1708         for (uint256 i = 0; i < _length; i++)
1709         {
1710             // if its uppercase A-Z
1711             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1712             {
1713                 // convert to lower case a-z
1714                 _temp[i] = byte(uint(_temp[i]) + 32);
1715                 
1716                 // we have a non number
1717                 if (_hasNonNumber == false)
1718                     _hasNonNumber = true;
1719             } else {
1720                 require
1721                 (
1722                     // require character is a space
1723                     _temp[i] == 0x20 || 
1724                     // OR lowercase a-z
1725                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1726                     // or 0-9
1727                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1728                     "string contains invalid characters"
1729                 );
1730                 // make sure theres not 2x spaces in a row
1731                 if (_temp[i] == 0x20)
1732                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1733                 
1734                 // see if we have a character other than a number
1735                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1736                     _hasNonNumber = true;    
1737             }
1738         }
1739         
1740         require(_hasNonNumber == true, "string cannot be only numbers");
1741         
1742         bytes32 _ret;
1743         assembly {
1744             _ret := mload(add(_temp, 32))
1745         }
1746         return (_ret);
1747     }
1748 }
1749 
1750 /**
1751  * @title SafeMath v0.1.9
1752  * @dev Math operations with safety checks that throw on error
1753  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1754  * - added sqrt
1755  * - added sq
1756  * - added pwr 
1757  * - changed asserts to requires with error log outputs
1758  * - removed div, its useless
1759  */
1760 library SafeMath {
1761     
1762     /**
1763     * @dev Multiplies two numbers, throws on overflow.
1764     */
1765     function mul(uint256 a, uint256 b) 
1766         internal 
1767         pure 
1768         returns (uint256 c) 
1769     {
1770         if (a == 0) {
1771             return 0;
1772         }
1773         c = a * b;
1774         require(c / a == b, "SafeMath mul failed");
1775         return c;
1776     }
1777 
1778     /**
1779     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1780     */
1781     function sub(uint256 a, uint256 b)
1782         internal
1783         pure
1784         returns (uint256) 
1785     {
1786         require(b <= a, "SafeMath sub failed");
1787         return a - b;
1788     }
1789 
1790     /**
1791     * @dev Adds two numbers, throws on overflow.
1792     */
1793     function add(uint256 a, uint256 b)
1794         internal
1795         pure
1796         returns (uint256 c) 
1797     {
1798         c = a + b;
1799         require(c >= a, "SafeMath add failed");
1800         return c;
1801     }
1802     
1803     /**
1804      * @dev gives square root of given x.
1805      */
1806     function sqrt(uint256 x)
1807         internal
1808         pure
1809         returns (uint256 y) 
1810     {
1811         uint256 z = ((add(x,1)) / 2);
1812         y = x;
1813         while (z < y) 
1814         {
1815             y = z;
1816             z = ((add((x / z),z)) / 2);
1817         }
1818     }
1819     
1820     /**
1821      * @dev gives square. multiplies x by x
1822      */
1823     function sq(uint256 x)
1824         internal
1825         pure
1826         returns (uint256)
1827     {
1828         return (mul(x,x));
1829     }
1830     
1831     /**
1832      * @dev x to the power of y 
1833      */
1834     function pwr(uint256 x, uint256 y)
1835         internal 
1836         pure 
1837         returns (uint256)
1838     {
1839         if (x==0)
1840             return (0);
1841         else if (y==0)
1842             return (1);
1843         else 
1844         {
1845             uint256 z = x;
1846             for (uint256 i=1; i < y; i++)
1847                 z = mul(z,x);
1848             return (z);
1849         }
1850     }
1851 }