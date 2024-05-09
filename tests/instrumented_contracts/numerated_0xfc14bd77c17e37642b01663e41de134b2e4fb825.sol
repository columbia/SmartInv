1 /**
2  * @title -FoMo-3D v0.7.1
3  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
4  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
5  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
6  *                                  _____                      _____
7  *                                 (, /     /)       /) /)    (, /      /)          /)
8  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
9  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
10  *          ┴ ┴                /   /          .-/ _____   (__ /
11  *                            (__ /          (_/ (, /                                      /)™
12  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
13  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
14  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
15  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/   .--,-``-.
16  *========,---,.======================____==========================/   /     '.=======,---,====*
17  *      ,'  .' |                    ,'  , `.                       / ../        ;    .'  .' `\
18  *    ,---.'   |    ,---.        ,-+-,.' _ |    ,---.              \ ``\  .`-    ' ,---.'     \
19  *    |   |   .'   '   ,'\    ,-+-. ;   , ||   '   ,'\      ,---,.  \___\/   \   : |   |  .`\  |
20  *    :   :  :    /   /   |  ,--.'|'   |  ||  /   /   |   ,'  .' |       \   :   | :   : |  '  |
21  *    :   |  |-, .   ; ,. : |   |  ,', |  |, .   ; ,. : ,---.'   |       /  /   /  |   ' '  ;  :
22  *    |   :  ;/| '   | |: : |   | /  | |--'  '   | |: : |   |  .'        \  \   \  '   | ;  .  |
23  *    |   |   .' '   | .; : |   : |  | ,     '   | .; : :   |.'      ___ /   :   | |   | :  |  '
24  *    '   :  '   |   :    | |   : |  |/      |   :    | `---'       /   /\   /   : '   : | /  ;
25  *    |   |  |    \   \  /  |   | |`-'        \   \  /             / ,,/  ',-    . |   | '` ,/
26  *    |   :  \     `----'   |   ;/             `----'              \ ''\        ;  ;   :  .'
27  *====|   | ,'=============='---'==========(long version)===========\   \     .'===|   ,.'======*
28  *    `----'                                                         `--`-,,-'     '---'
29  *             ╔═╗┌─┐┌─┐┬┌─┐┬┌─┐┬   ┌─────────────────────────┐ ╦ ╦┌─┐┌┐ ╔═╗┬┌┬┐┌─┐ 
30  *             ║ ║├┤ ├┤ ││  │├─┤│   │   https://exitscam.me   │ ║║║├┤ ├┴┐╚═╗│ │ ├┤  
31  *             ╚═╝└  └  ┴└─┘┴┴ ┴┴─┘ └─┬─────────────────────┬─┘ ╚╩╝└─┘└─┘╚═╝┴ ┴ └─┘ 
32  *   ┌────────────────────────────────┘                     └──────────────────────────────┐
33  *   │╔═╗┌─┐┬  ┬┌┬┐┬┌┬┐┬ ┬   ╔╦╗┌─┐┌─┐┬┌─┐┌┐┌   ╦┌┐┌┌┬┐┌─┐┬─┐┌─┐┌─┐┌─┐┌─┐   ╔═╗┌┬┐┌─┐┌─┐┬┌─│
34  *   │╚═╗│ ││  │ │││ │ └┬┘ ═  ║║├┤ └─┐││ ┬│││ ═ ║│││ │ ├┤ ├┬┘├┤ ├─┤│  ├┤  ═ ╚═╗ │ ├─┤│  ├┴┐│
35  *   │╚═╝└─┘┴─┘┴─┴┘┴ ┴  ┴    ═╩╝└─┘└─┘┴└─┘┘└┘   ╩┘└┘ ┴ └─┘┴└─└  ┴ ┴└─┘└─┘   ╚═╝ ┴ ┴ ┴└─┘┴ ┴│
36  *   │    ┌──────────┐           ┌───────┐            ┌─────────┐              ┌────────┐  │
37  *   └────┤ Inventor ├───────────┤ Justo ├────────────┤ Sumpunk ├──────────────┤ Mantso ├──┘
38  *        └──────────┘           └───────┘            └─────────┘              └────────┘
39  *   ┌─────────────────────────────────────────────────────────┐ ╔╦╗┬ ┬┌─┐┌┐┌┬┌─┌─┐  ╔╦╗┌─┐
40  *   │ Ambius, Aritz Cracker, Cryptoknight, Crypto McPump,     │  ║ ├─┤├─┤│││├┴┐└─┐   ║ │ │
41  *   │ Capex, JogFera, The Shocker, Daok, Randazzz, PumpRabbi, │  ╩ ┴ ┴┴ ┴┘└┘┴ ┴└─┘   ╩ └─┘
42  *   │ Kadaz, Incognito Jo, Lil Stronghands, Ninja Turtle,     └───────────────────────────┐
43  *   │ Psaints, Satoshi, Vitalik, Nano 2nd, Bogdanoffs         Isaac Newton, Nikola Tesla, │ 
44  *   │ Le Comte De Saint Germain, Albert Einstein, Socrates, & all the volunteer moderator │
45  *   │ & support staff, content, creators, autonomous agents, and indie devs for P3D.      │
46  *   │              Without your help, we wouldn't have the time to code this.             │
47  *   └─────────────────────────────────────────────────────────────────────────────────────┘
48  * 
49  * This product is protected under license.  Any unauthorized copy, modification, or use without 
50  * express written consent from the creators is prohibited.
51  * 
52  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
53  */
54 
55 //==============================================================================
56 /*
57 //     _    _  _ _|_ _  .
58 //    (/_\/(/_| | | _\  .
59 //==============================================================================
60 
61 
62 
63     contract F3Devents {
64     // fired whenever a player registers a name
65     event onNewName
66     (
67         uint256 indexed playerID,
68         address indexed playerAddress,
69         bytes32 indexed playerName,
70         bool isNewPlayer,
71         uint256 affiliateID,
72         address affiliateAddress,
73         bytes32 affiliateName,
74         uint256 amountPaid,
75         uint256 timeStamp
76     );
77     
78     // fired at end of buy or reload
79     event onEndTx
80     (
81         uint256 compressedData,     
82         uint256 compressedIDs,      
83         bytes32 playerName,
84         address playerAddress,
85         uint256 ethIn,
86         uint256 keysBought,
87         address winnerAddr,
88         bytes32 winnerName,
89         uint256 amountWon,
90         uint256 newPot,
91         uint256 P3DAmount,
92         uint256 genAmount,
93         uint256 potAmount,
94         uint256 airDropPot
95     );
96     
97 	// fired whenever theres a withdraw
98     event onWithdraw
99     (
100         uint256 indexed playerID,
101         address playerAddress,
102         bytes32 playerName,
103         uint256 ethOut,
104         uint256 timeStamp
105     );
106     
107     // fired whenever a withdraw forces end round to be ran
108     event onWithdrawAndDistribute
109     (
110         address playerAddress,
111         bytes32 playerName,
112         uint256 ethOut,
113         uint256 compressedData,
114         uint256 compressedIDs,
115         address winnerAddr,
116         bytes32 winnerName,
117         uint256 amountWon,
118         uint256 newPot,
119         uint256 P3DAmount,
120         uint256 genAmount
121     );
122     
123     // (fomo3d long only) fired whenever a player tries a buy after round timer 
124     // hit zero, and causes end round to be ran.
125     event onBuyAndDistribute
126     (
127         address playerAddress,
128         bytes32 playerName,
129         uint256 ethIn,
130         uint256 compressedData,
131         uint256 compressedIDs,
132         address winnerAddr,
133         bytes32 winnerName,
134         uint256 amountWon,
135         uint256 newPot,
136         uint256 P3DAmount,
137         uint256 genAmount
138     );
139     
140     // (fomo3d long only) fired whenever a player tries a reload after round timer 
141     // hit zero, and causes end round to be ran.
142     event onReLoadAndDistribute
143     (
144         address playerAddress,
145         bytes32 playerName,
146         uint256 compressedData,
147         uint256 compressedIDs,
148         address winnerAddr,
149         bytes32 winnerName,
150         uint256 amountWon,
151         uint256 newPot,
152         uint256 P3DAmount,
153         uint256 genAmount
154     );
155     
156     // fired whenever an affiliate is paid
157     event onAffiliatePayout
158     (
159         uint256 indexed affiliateID,
160         address affiliateAddress,
161         bytes32 affiliateName,
162         uint256 indexed roundID,
163         uint256 indexed buyerID,
164         uint256 amount,
165         uint256 timeStamp
166     );
167     
168     // received pot swap deposit
169     event onPotSwapDeposit
170     (
171         uint256 roundID,
172         uint256 amountAddedToPot
173     );
174 }
175 
176 //==============================================================================
177 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
178 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
179 //====================================|=========================================
180 
181 contract modularLong is F3Devents {}
182 
183 contract FoMo3Dlong is modularLong {
184     using SafeMath for *;
185     using NameFilter for string;
186     using F3DKeysCalcLong for uint256;
187 	
188 	otherFoMo3D private otherF3D_;
189     DiviesInterface constant private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
190     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
191 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
192     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
193 //==============================================================================
194 //     _ _  _  |`. _     _ _ |_ | _  _  .
195 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
196 //=================_|===========================================================
197     string constant public name = "FoMo3D Long Official";
198     string constant public symbol = "F3D";
199 	uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO 
200     uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
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
261     
262     modifier isActivated() {
263         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
264         _;
265     }
266     
267     
268     modifier isHuman() {
269         address _addr = msg.sender;
270         uint256 _codeLength;
271         
272         assembly {_codeLength := extcodesize(_addr)}
273         require(_codeLength == 0, "sorry humans only");
274         _;
275     }
276 
277     
278     modifier isWithinLimits(uint256 _eth) {
279         require(_eth >= 1000000000, "pocket lint: not a valid currency");
280         require(_eth <= 100000000000000000000000, "no vitalik, no");
281         _;    
282     }
283     
284 //==============================================================================
285 //     _    |_ |. _   |`    _  __|_. _  _  _  .
286 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
287 //====|=========================================================================
288    
289     function()
290         isActivated()
291         isHuman()
292         isWithinLimits(msg.value)
293         public
294         payable
295     {
296         // set up our tx event data and determine if player is new or not
297         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
298             
299         // fetch player id
300         uint256 _pID = pIDxAddr_[msg.sender];
301         
302         // buy core 
303         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
304     }
305     
306     
307     function buyXid(uint256 _affCode, uint256 _team)
308         isActivated()
309         isHuman()
310         isWithinLimits(msg.value)
311         public
312         payable
313     {
314         // set up our tx event data and determine if player is new or not
315         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
316         
317         // fetch player id
318         uint256 _pID = pIDxAddr_[msg.sender];
319         
320         // manage affiliate residuals
321         // if no affiliate code was given or player tried to use their own, lolz
322         if (_affCode == 0 || _affCode == _pID)
323         {
324             // use last stored affiliate code 
325             _affCode = plyr_[_pID].laff;
326             
327         // if affiliate code was given & its not the same as previously stored 
328         } else if (_affCode != plyr_[_pID].laff) {
329             // update last affiliate 
330             plyr_[_pID].laff = _affCode;
331         }
332         
333         // verify a valid team was selected
334         _team = verifyTeam(_team);
335         
336         // buy core 
337         buyCore(_pID, _affCode, _team, _eventData_);
338     }
339     
340     function buyXaddr(address _affCode, uint256 _team)
341         isActivated()
342         isHuman()
343         isWithinLimits(msg.value)
344         public
345         payable
346     {
347         // set up our tx event data and determine if player is new or not
348         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
349         
350         // fetch player id
351         uint256 _pID = pIDxAddr_[msg.sender];
352         
353         // manage affiliate residuals
354         uint256 _affID;
355         // if no affiliate code was given or player tried to use their own, lolz
356         if (_affCode == address(0) || _affCode == msg.sender)
357         {
358             // use last stored affiliate code
359             _affID = plyr_[_pID].laff;
360         
361         // if affiliate code was given    
362         } else {
363             // get affiliate ID from aff Code 
364             _affID = pIDxAddr_[_affCode];
365             
366             // if affID is not the same as previously stored 
367             if (_affID != plyr_[_pID].laff)
368             {
369                 // update last affiliate
370                 plyr_[_pID].laff = _affID;
371             }
372         }
373         
374         // verify a valid team was selected
375         _team = verifyTeam(_team);
376         
377         // buy core 
378         buyCore(_pID, _affID, _team, _eventData_);
379     }
380     
381     function buyXname(bytes32 _affCode, uint256 _team)
382         isActivated()
383         isHuman()
384         isWithinLimits(msg.value)
385         public
386         payable
387     {
388         // set up our tx event data and determine if player is new or not
389         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
390         
391         // fetch player id
392         uint256 _pID = pIDxAddr_[msg.sender];
393         
394         // manage affiliate residuals
395         uint256 _affID;
396         // if no affiliate code was given or player tried to use their own, lolz
397         if (_affCode == '' || _affCode == plyr_[_pID].name)
398         {
399             // use last stored affiliate code
400             _affID = plyr_[_pID].laff;
401         
402         // if affiliate code was given
403         } else {
404             // get affiliate ID from aff Code
405             _affID = pIDxName_[_affCode];
406             
407             // if affID is not the same as previously stored
408             if (_affID != plyr_[_pID].laff)
409             {
410                 // update last affiliate
411                 plyr_[_pID].laff = _affID;
412             }
413         }
414         
415         // verify a valid team was selected
416         _team = verifyTeam(_team);
417         
418         // buy core 
419         buyCore(_pID, _affID, _team, _eventData_);
420     }
421     
422    
423     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
424         isActivated()
425         isHuman()
426         isWithinLimits(_eth)
427         public
428     {
429         // set up our tx event data
430         F3Ddatasets.EventReturns memory _eventData_;
431         
432         // fetch player ID
433         uint256 _pID = pIDxAddr_[msg.sender];
434         
435         // manage affiliate residuals
436         // if no affiliate code was given or player tried to use their own, lolz
437         if (_affCode == 0 || _affCode == _pID)
438         {
439             // use last stored affiliate code 
440             _affCode = plyr_[_pID].laff;
441             
442         // if affiliate code was given & its not the same as previously stored 
443         } else if (_affCode != plyr_[_pID].laff) {
444             // update last affiliate 
445             plyr_[_pID].laff = _affCode;
446         }
447 
448         // verify a valid team was selected
449         _team = verifyTeam(_team);
450 
451         // reload core
452         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
453     }
454     
455     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
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
468         uint256 _affID;
469         // if no affiliate code was given or player tried to use their own, lolz
470         if (_affCode == address(0) || _affCode == msg.sender)
471         {
472             // use last stored affiliate code
473             _affID = plyr_[_pID].laff;
474         
475         // if affiliate code was given    
476         } else {
477             // get affiliate ID from aff Code 
478             _affID = pIDxAddr_[_affCode];
479             
480             // if affID is not the same as previously stored 
481             if (_affID != plyr_[_pID].laff)
482             {
483                 // update last affiliate
484                 plyr_[_pID].laff = _affID;
485             }
486         }
487         
488         // verify a valid team was selected
489         _team = verifyTeam(_team);
490         
491         // reload core
492         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
493     }
494     
495     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
496         isActivated()
497         isHuman()
498         isWithinLimits(_eth)
499         public
500     {
501         // set up our tx event data
502         F3Ddatasets.EventReturns memory _eventData_;
503         
504         // fetch player ID
505         uint256 _pID = pIDxAddr_[msg.sender];
506         
507         // manage affiliate residuals
508         uint256 _affID;
509         // if no affiliate code was given or player tried to use their own, lolz
510         if (_affCode == '' || _affCode == plyr_[_pID].name)
511         {
512             // use last stored affiliate code
513             _affID = plyr_[_pID].laff;
514         
515         // if affiliate code was given
516         } else {
517             // get affiliate ID from aff Code
518             _affID = pIDxName_[_affCode];
519             
520             // if affID is not the same as previously stored
521             if (_affID != plyr_[_pID].laff)
522             {
523                 // update last affiliate
524                 plyr_[_pID].laff = _affID;
525             }
526         }
527         
528         // verify a valid team was selected
529         _team = verifyTeam(_team);
530         
531         // reload core
532         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
533     }
534 
535     
536     function withdraw()
537         isActivated()
538         isHuman()
539         public
540     {
541         // setup local rID 
542         uint256 _rID = rID_;
543         
544         // grab time
545         uint256 _now = now;
546         
547         // fetch player ID
548         uint256 _pID = pIDxAddr_[msg.sender];
549         
550         // setup temp var for player eth
551         uint256 _eth;
552         
553         // check to see if round has ended and no one has run round end yet
554         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
555         {
556             // set up our tx event data
557             F3Ddatasets.EventReturns memory _eventData_;
558             
559             // end the round (distributes pot)
560 			round_[_rID].ended = true;
561             _eventData_ = endRound(_eventData_);
562             
563 			// get their earnings
564             _eth = withdrawEarnings(_pID);
565             
566             // gib moni
567             if (_eth > 0)
568                 plyr_[_pID].addr.transfer(_eth);    
569             
570             // build event data
571             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
572             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
573             
574             // fire withdraw and distribute event
575             emit F3Devents.onWithdrawAndDistribute
576             (
577                 msg.sender, 
578                 plyr_[_pID].name, 
579                 _eth, 
580                 _eventData_.compressedData, 
581                 _eventData_.compressedIDs, 
582                 _eventData_.winnerAddr, 
583                 _eventData_.winnerName, 
584                 _eventData_.amountWon, 
585                 _eventData_.newPot, 
586                 _eventData_.P3DAmount, 
587                 _eventData_.genAmount
588             );
589             
590         // in any other situation
591         } else {
592             // get their earnings
593             _eth = withdrawEarnings(_pID);
594             
595             // gib moni
596             if (_eth > 0)
597                 plyr_[_pID].addr.transfer(_eth);
598             
599             // fire withdraw event
600             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
601         }
602     }
603     
604    
605     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
606         isHuman()
607         public
608         payable
609     {
610         bytes32 _name = _nameString.nameFilter();
611         address _addr = msg.sender;
612         uint256 _paid = msg.value;
613         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
614         
615         uint256 _pID = pIDxAddr_[_addr];
616         
617         // fire event
618         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
619     }
620     
621     function registerNameXaddr(string _nameString, address _affCode, bool _all)
622         isHuman()
623         public
624         payable
625     {
626         bytes32 _name = _nameString.nameFilter();
627         address _addr = msg.sender;
628         uint256 _paid = msg.value;
629         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
630         
631         uint256 _pID = pIDxAddr_[_addr];
632         
633         // fire event
634         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
635     }
636     
637     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
638         isHuman()
639         public
640         payable
641     {
642         bytes32 _name = _nameString.nameFilter();
643         address _addr = msg.sender;
644         uint256 _paid = msg.value;
645         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
646         
647         uint256 _pID = pIDxAddr_[_addr];
648         
649         // fire event
650         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
651     }
652 //==============================================================================
653 //     _  _ _|__|_ _  _ _  .
654 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
655 //=====_|=======================================================================
656    
657     function getBuyPrice()
658         public 
659         view 
660         returns(uint256)
661     {  
662         // setup local rID
663         uint256 _rID = rID_;
664         
665         // grab time
666         uint256 _now = now;
667         
668         // are we in a round?
669         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
670             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
671         else // rounds over.  need price for new round
672             return ( 75000000000000 ); // init
673     }
674     
675   
676     function getTimeLeft()
677         public
678         view
679         returns(uint256)
680     {
681         // setup local rID
682         uint256 _rID = rID_;
683         
684         // grab time
685         uint256 _now = now;
686         
687         if (_now < round_[_rID].end)
688             if (_now > round_[_rID].strt + rndGap_)
689                 return( (round_[_rID].end).sub(_now) );
690             else
691                 return( (round_[_rID].strt + rndGap_).sub(_now) );
692         else
693             return(0);
694     }
695     
696    
697     function getPlayerVaults(uint256 _pID)
698         public
699         view
700         returns(uint256 ,uint256, uint256)
701     {
702         // setup local rID
703         uint256 _rID = rID_;
704         
705         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
706         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
707         {
708             // if player is winner 
709             if (round_[_rID].plyr == _pID)
710             {
711                 return
712                 (
713                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
714                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
715                     plyr_[_pID].aff
716                 );
717             // if player is not the winner
718             } else {
719                 return
720                 (
721                     plyr_[_pID].win,
722                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
723                     plyr_[_pID].aff
724                 );
725             }
726             
727         // if round is still going on, or round has ended and round end has been ran
728         } else {
729             return
730             (
731                 plyr_[_pID].win,
732                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
733                 plyr_[_pID].aff
734             );
735         }
736     }
737     
738     
739     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
740         private
741         view
742         returns(uint256)
743     {
744         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
745     }
746     
747     
748     function getCurrentRoundInfo()
749         public
750         view
751         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
752     {
753         // setup local rID
754         uint256 _rID = rID_;
755         
756         return
757         (
758             round_[_rID].ico,               //0
759             _rID,                           //1
760             round_[_rID].keys,              //2
761             round_[_rID].end,               //3
762             round_[_rID].strt,              //4
763             round_[_rID].pot,               //5
764             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
765             plyr_[round_[_rID].plyr].addr,  //7
766             plyr_[round_[_rID].plyr].name,  //8
767             rndTmEth_[_rID][0],             //9
768             rndTmEth_[_rID][1],             //10
769             rndTmEth_[_rID][2],             //11
770             rndTmEth_[_rID][3],             //12
771             airDropTracker_ + (airDropPot_ * 1000)              //13
772         );
773     }
774 
775     
776     function getPlayerInfoByAddress(address _addr)
777         public 
778         view 
779         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
780     {
781         // setup local rID
782         uint256 _rID = rID_;
783         
784         if (_addr == address(0))
785         {
786             _addr == msg.sender;
787         }
788         uint256 _pID = pIDxAddr_[_addr];
789         
790         return
791         (
792             _pID,                               //0
793             plyr_[_pID].name,                   //1
794             plyrRnds_[_pID][_rID].keys,         //2
795             plyr_[_pID].win,                    //3
796             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
797             plyr_[_pID].aff,                    //5
798             plyrRnds_[_pID][_rID].eth           //6
799         );
800     }
801 
802 //==============================================================================
803 //     _ _  _ _   | _  _ . _  .
804 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
805 //=====================_|=======================================================
806      *
807      * @dev logic runs whenever a buy order is executed.  determines how to handle 
808      * incoming eth depending on if we are in an active round or not
809      
810     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
811         private
812     {
813         // setup local rID
814         uint256 _rID = rID_;
815         
816         // grab time
817         uint256 _now = now;
818         
819         // if round is active
820         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
821         {
822             // call core 
823             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
824         
825         // if round is not active     
826         } else {
827             // check to see if end round needs to be ran
828             if (_now > round_[_rID].end && round_[_rID].ended == false) 
829             {
830                 // end the round (distributes pot) & start new round
831 			    round_[_rID].ended = true;
832                 _eventData_ = endRound(_eventData_);
833                 
834                 // build event data
835                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
836                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
837                 
838                 // fire buy and distribute event 
839                 emit F3Devents.onBuyAndDistribute
840                 (
841                     msg.sender, 
842                     plyr_[_pID].name, 
843                     msg.value, 
844                     _eventData_.compressedData, 
845                     _eventData_.compressedIDs, 
846                     _eventData_.winnerAddr, 
847                     _eventData_.winnerName, 
848                     _eventData_.amountWon, 
849                     _eventData_.newPot, 
850                     _eventData_.P3DAmount, 
851                     _eventData_.genAmount
852                 );
853             }
854             
855             // put eth in players vault 
856             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
857         }
858     }
859     
860     **
861      * @dev logic runs whenever a reload order is executed.  determines how to handle 
862      * incoming eth depending on if we are in an active round or not 
863      *
864     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
865         private
866     {
867         // setup local rID
868         uint256 _rID = rID_;
869         
870         // grab time
871         uint256 _now = now;
872         
873         // if round is active
874         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
875         {
876             // get earnings from all vaults and return unused to gen vault
877             // because we use a custom safemath library.  this will throw if player 
878             // tried to spend more eth than they have.
879             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
880             
881             // call core 
882             core(_rID, _pID, _eth, _affID, _team, _eventData_);
883         
884         // if round is not active and end round needs to be ran   
885         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
886             // end the round (distributes pot) & start new round
887             round_[_rID].ended = true;
888             _eventData_ = endRound(_eventData_);
889                 
890             // build event data
891             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
892             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
893                 
894             // fire buy and distribute event 
895             emit F3Devents.onReLoadAndDistribute
896             (
897                 msg.sender, 
898                 plyr_[_pID].name, 
899                 _eventData_.compressedData, 
900                 _eventData_.compressedIDs, 
901                 _eventData_.winnerAddr, 
902                 _eventData_.winnerName, 
903                 _eventData_.amountWon, 
904                 _eventData_.newPot, 
905                 _eventData_.P3DAmount, 
906                 _eventData_.genAmount
907             );
908         }
909     }
910     
911     **
912      * @dev this is the core logic for any buy/reload that happens while a round 
913      * is live.
914      *
915     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
916         private
917     {
918         // if player is new to round
919         if (plyrRnds_[_pID][_rID].keys == 0)
920             _eventData_ = managePlayer(_pID, _eventData_);
921         
922         // early round eth limiter 
923         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
924         {
925             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
926             uint256 _refund = _eth.sub(_availableLimit);
927             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
928             _eth = _availableLimit;
929         }
930         
931         // if eth left is greater than min eth allowed (sorry no pocket lint)
932         if (_eth > 1000000000) 
933         {
934             
935             // mint the new keys
936             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
937             
938             // if they bought at least 1 whole key
939             if (_keys >= 1000000000000000000)
940             {
941             updateTimer(_keys, _rID);
942 
943             // set new leaders
944             if (round_[_rID].plyr != _pID)
945                 round_[_rID].plyr = _pID;  
946             if (round_[_rID].team != _team)
947                 round_[_rID].team = _team; 
948             
949             // set the new leader bool to true
950             _eventData_.compressedData = _eventData_.compressedData + 100;
951         }
952             
953             // manage airdrops
954             if (_eth >= 100000000000000000)
955             {
956             airDropTracker_++;
957             if (airdrop() == true)
958             {
959                 // gib muni
960                 uint256 _prize;
961                 if (_eth >= 10000000000000000000)
962                 {
963                     // calculate prize and give it to winner
964                     _prize = ((airDropPot_).mul(75)) / 100;
965                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
966                     
967                     // adjust airDropPot 
968                     airDropPot_ = (airDropPot_).sub(_prize);
969                     
970                     // let event know a tier 3 prize was won 
971                     _eventData_.compressedData += 300000000000000000000000000000000;
972                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
973                     // calculate prize and give it to winner
974                     _prize = ((airDropPot_).mul(50)) / 100;
975                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
976                     
977                     // adjust airDropPot 
978                     airDropPot_ = (airDropPot_).sub(_prize);
979                     
980                     // let event know a tier 2 prize was won 
981                     _eventData_.compressedData += 200000000000000000000000000000000;
982                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
983                     // calculate prize and give it to winner
984                     _prize = ((airDropPot_).mul(25)) / 100;
985                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
986                     
987                     // adjust airDropPot 
988                     airDropPot_ = (airDropPot_).sub(_prize);
989                     
990                     // let event know a tier 3 prize was won 
991                     _eventData_.compressedData += 300000000000000000000000000000000;
992                 }
993                 // set airdrop happened bool to true
994                 _eventData_.compressedData += 10000000000000000000000000000000;
995                 // let event know how much was won 
996                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
997                 
998                 // reset air drop tracker
999                 airDropTracker_ = 0;
1000             }
1001         }
1002     
1003             // store the air drop tracker number (number of buys since last airdrop)
1004             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1005             
1006             // update player 
1007             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1008             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1009             
1010             // update round
1011             round_[_rID].keys = _keys.add(round_[_rID].keys);
1012             round_[_rID].eth = _eth.add(round_[_rID].eth);
1013             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1014     
1015             // distribute eth
1016             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1017             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1018             
1019             // call end tx function to fire end tx event.
1020 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1021         }
1022     }
1023 //==============================================================================
1024 //     _ _ | _   | _ _|_ _  _ _  .
1025 //    (_(_||(_|_||(_| | (_)| _\  .
1026 //==============================================================================
1027     **
1028      * @dev calculates unmasked earnings (just calculates, does not update mask)
1029      * @return earnings in wei format
1030      *
1031     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1032         private
1033         view
1034         returns(uint256)
1035     {
1036         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1037     }
1038     
1039     ** 
1040      * @dev returns the amount of keys you would get given an amount of eth. 
1041      * -functionhash- 0xce89c80c
1042      * @param _rID round ID you want price for
1043      * @param _eth amount of eth sent in 
1044      * @return keys received 
1045      *
1046     function calcKeysReceived(uint256 _rID, uint256 _eth)
1047         public
1048         view
1049         returns(uint256)
1050     {
1051         // grab time
1052         uint256 _now = now;
1053         
1054         // are we in a round?
1055         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1056             return ( (round_[_rID].eth).keysRec(_eth) );
1057         else // rounds over.  need keys for new round
1058             return ( (_eth).keys() );
1059     }
1060     
1061     ** 
1062      * @dev returns current eth price for X keys.  
1063      * -functionhash- 0xcf808000
1064      * @param _keys number of keys desired (in 18 decimal format)
1065      * @return amount of eth needed to send
1066      *
1067     function iWantXKeys(uint256 _keys)
1068         public
1069         view
1070         returns(uint256)
1071     {
1072         // setup local rID
1073         uint256 _rID = rID_;
1074         
1075         // grab time
1076         uint256 _now = now;
1077         
1078         // are we in a round?
1079         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1080             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1081         else // rounds over.  need price for new round
1082             return ( (_keys).eth() );
1083     }
1084 //==============================================================================
1085 //    _|_ _  _ | _  .
1086 //     | (_)(_)|_\  .
1087 //==============================================================================
1088     **
1089 	 * @dev receives name/player info from names contract 
1090      *
1091     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1092         external
1093     {
1094         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1095         if (pIDxAddr_[_addr] != _pID)
1096             pIDxAddr_[_addr] = _pID;
1097         if (pIDxName_[_name] != _pID)
1098             pIDxName_[_name] = _pID;
1099         if (plyr_[_pID].addr != _addr)
1100             plyr_[_pID].addr = _addr;
1101         if (plyr_[_pID].name != _name)
1102             plyr_[_pID].name = _name;
1103         if (plyr_[_pID].laff != _laff)
1104             plyr_[_pID].laff = _laff;
1105         if (plyrNames_[_pID][_name] == false)
1106             plyrNames_[_pID][_name] = true;
1107     }
1108     
1109     **
1110      * @dev receives entire player name list 
1111      *
1112     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1113         external
1114     {
1115         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1116         if(plyrNames_[_pID][_name] == false)
1117             plyrNames_[_pID][_name] = true;
1118     }   
1119         
1120     **
1121      * @dev gets existing or registers new pID.  use this when a player may be new
1122      * @return pID 
1123      *
1124     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1125         private
1126         returns (F3Ddatasets.EventReturns)
1127     {
1128         uint256 _pID = pIDxAddr_[msg.sender];
1129         // if player is new to this version of fomo3d
1130         if (_pID == 0)
1131         {
1132             // grab their player ID, name and last aff ID, from player names contract 
1133             _pID = PlayerBook.getPlayerID(msg.sender);
1134             bytes32 _name = PlayerBook.getPlayerName(_pID);
1135             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1136             
1137             // set up player account 
1138             pIDxAddr_[msg.sender] = _pID;
1139             plyr_[_pID].addr = msg.sender;
1140             
1141             if (_name != "")
1142             {
1143                 pIDxName_[_name] = _pID;
1144                 plyr_[_pID].name = _name;
1145                 plyrNames_[_pID][_name] = true;
1146             }
1147             
1148             if (_laff != 0 && _laff != _pID)
1149                 plyr_[_pID].laff = _laff;
1150             
1151             // set the new player bool to true
1152             _eventData_.compressedData = _eventData_.compressedData + 1;
1153         } 
1154         return (_eventData_);
1155     }
1156     
1157     **
1158      * @dev checks to make sure user picked a valid team.  if not sets team 
1159      * to default (sneks)
1160      *
1161     function verifyTeam(uint256 _team)
1162         private
1163         pure
1164         returns (uint256)
1165     {
1166         if (_team < 0 || _team > 3)
1167             return(2);
1168         else
1169             return(_team);
1170     }
1171     
1172     **
1173      * @dev decides if round end needs to be run & new round started.  and if 
1174      * player unmasked earnings from previously played rounds need to be moved.
1175      *
1176     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1177         private
1178         returns (F3Ddatasets.EventReturns)
1179     {
1180         // if player has played a previous round, move their unmasked earnings
1181         // from that round to gen vault.
1182         if (plyr_[_pID].lrnd != 0)
1183             updateGenVault(_pID, plyr_[_pID].lrnd);
1184             
1185         // update player's last round played
1186         plyr_[_pID].lrnd = rID_;
1187             
1188         // set the joined round bool to true
1189         _eventData_.compressedData = _eventData_.compressedData + 10;
1190         
1191         return(_eventData_);
1192     }
1193     
1194     **
1195      * @dev ends the round. manages paying out winner/splitting up pot
1196      *
1197     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1198         private
1199         returns (F3Ddatasets.EventReturns)
1200     {
1201         // setup local rID
1202         uint256 _rID = rID_;
1203         
1204         // grab our winning player and team id's
1205         uint256 _winPID = round_[_rID].plyr;
1206         uint256 _winTID = round_[_rID].team;
1207         
1208         // grab our pot amount
1209         uint256 _pot = round_[_rID].pot;
1210         
1211         // calculate our winner share, community rewards, gen share, 
1212         // p3d share, and amount reserved for next pot 
1213         uint256 _win = (_pot.mul(48)) / 100;
1214         uint256 _com = (_pot / 50);
1215         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1216         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1217         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1218         
1219         // calculate ppt for round mask
1220         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1221         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1222         if (_dust > 0)
1223         {
1224             _gen = _gen.sub(_dust);
1225             _res = _res.add(_dust);
1226         }
1227         
1228         // pay our winner
1229         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1230         
1231         // community rewards
1232         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1233         {
1234             // This ensures Team Just cannot influence the outcome of FoMo3D with
1235             // bank migrations by breaking outgoing transactions.
1236             // Something we would never do. But that's not the point.
1237             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1238             // highest belief that everything we create should be trustless.
1239             // Team JUST, The name you shouldn't have to trust.
1240             _p3d = _p3d.add(_com);
1241             _com = 0;
1242         }
1243         
1244         // distribute gen portion to key holders
1245         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1246         
1247         // send share for p3d to divies
1248         if (_p3d > 0)
1249             Divies.deposit.value(_p3d)();
1250             
1251         // prepare event data
1252         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1253         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1254         _eventData_.winnerAddr = plyr_[_winPID].addr;
1255         _eventData_.winnerName = plyr_[_winPID].name;
1256         _eventData_.amountWon = _win;
1257         _eventData_.genAmount = _gen;
1258         _eventData_.P3DAmount = _p3d;
1259         _eventData_.newPot = _res;
1260         
1261         // start next round
1262         rID_++;
1263         _rID++;
1264         round_[_rID].strt = now;
1265         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1266         round_[_rID].pot = _res;
1267         
1268         return(_eventData_);
1269     }
1270     
1271     **
1272      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1273      *
1274     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1275         private 
1276     {
1277         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1278         if (_earnings > 0)
1279         {
1280             // put in gen vault
1281             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1282             // zero out their earnings by updating mask
1283             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1284         }
1285     }
1286     
1287     **
1288      * @dev updates round timer based on number of whole keys bought.
1289      *
1290     function updateTimer(uint256 _keys, uint256 _rID)
1291         private
1292     {
1293         // grab time
1294         uint256 _now = now;
1295         
1296         // calculate time based on number of keys bought
1297         uint256 _newTime;
1298         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1299             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1300         else
1301             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1302         
1303         // compare to max and set new end time
1304         if (_newTime < (rndMax_).add(_now))
1305             round_[_rID].end = _newTime;
1306         else
1307             round_[_rID].end = rndMax_.add(_now);
1308     }
1309     
1310     **
1311      * @dev generates a random number between 0-99 and checks to see if thats
1312      * resulted in an airdrop win
1313      * @return do we have a winner?
1314      *
1315     function airdrop()
1316         private 
1317         view 
1318         returns(bool)
1319     {
1320         uint256 seed = uint256(keccak256(abi.encodePacked(
1321             
1322             (block.timestamp).add
1323             (block.difficulty).add
1324             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1325             (block.gaslimit).add
1326             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1327             (block.number)
1328             
1329         )));
1330         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1331             return(true);
1332         else
1333             return(false);
1334     }
1335 
1336     **
1337      * @dev distributes eth based on fees to com, aff, and p3d
1338      *
1339     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1340         private
1341         returns(F3Ddatasets.EventReturns)
1342     {
1343         // pay 2% out to community rewards
1344         uint256 _com = _eth / 50;
1345         uint256 _p3d;
1346         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1347         {
1348             // This ensures Team Just cannot influence the outcome of FoMo3D with
1349             // bank migrations by breaking outgoing transactions.
1350             // Something we would never do. But that's not the point.
1351             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1352             // highest belief that everything we create should be trustless.
1353             // Team JUST, The name you shouldn't have to trust.
1354             _p3d = _com;
1355             _com = 0;
1356         }
1357         
1358         // pay 1% out to FoMo3D short
1359         uint256 _long = _eth / 100;
1360         otherF3D_.potSwap.value(_long)();
1361         
1362         // distribute share to affiliate
1363         uint256 _aff = _eth / 10;
1364         
1365         // decide what to do with affiliate share of fees
1366         // affiliate must not be self, and must have a name registered
1367         if (_affID != _pID && plyr_[_affID].name != '') {
1368             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1369             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1370         } else {
1371             _p3d = _aff;
1372         }
1373         
1374         // pay out p3d
1375         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1376         if (_p3d > 0)
1377         {
1378             // deposit to divies contract
1379             Divies.deposit.value(_p3d)();
1380             
1381             // set up event data
1382             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1383         }
1384         
1385         return(_eventData_);
1386     }
1387     
1388     function potSwap()
1389         external
1390         payable
1391     {
1392         // setup local rID
1393         uint256 _rID = rID_ + 1;
1394         
1395         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1396         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1397     }
1398     
1399     **
1400      * @dev distributes eth based on fees to gen and pot
1401      *
1402     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1403         private
1404         returns(F3Ddatasets.EventReturns)
1405     {
1406         // calculate gen share
1407         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1408         
1409         // toss 1% into airdrop pot 
1410         uint256 _air = (_eth / 100);
1411         airDropPot_ = airDropPot_.add(_air);
1412         
1413         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1414         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1415         
1416         // calculate pot 
1417         uint256 _pot = _eth.sub(_gen);
1418         
1419         // distribute gen share (thats what updateMasks() does) and adjust
1420         // balances for dust.
1421         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1422         if (_dust > 0)
1423             _gen = _gen.sub(_dust);
1424         
1425         // add eth to pot
1426         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1427         
1428         // set up event data
1429         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1430         _eventData_.potAmount = _pot;
1431         
1432         return(_eventData_);
1433     }
1434 
1435     **
1436      * @dev updates masks for round and player when keys are bought
1437      * @return dust left over 
1438      *
1439     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1440         private
1441         returns(uint256)
1442     {
1443         * MASKING NOTES
1444             earnings masks are a tricky thing for people to wrap their minds around.
1445             the basic thing to understand here.  is were going to have a global
1446             tracker based on profit per share for each round, that increases in
1447             relevant proportion to the increase in share supply.
1448             
1449             the player will have an additional mask that basically says "based
1450             on the rounds mask, my shares, and how much i've already withdrawn,
1451             how much is still owed to me?"
1452         *
1453         
1454         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1455         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1456         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1457             
1458         // calculate player earning from their own buy (only based on the keys
1459         // they just bought).  & update player earnings mask
1460         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1461         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1462         
1463         // calculate & return dust
1464         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1465     }
1466     
1467     **
1468      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1469      * @return earnings in wei format
1470      *
1471     function withdrawEarnings(uint256 _pID)
1472         private
1473         returns(uint256)
1474     {
1475         // update gen vault
1476         updateGenVault(_pID, plyr_[_pID].lrnd);
1477         
1478         // from vaults 
1479         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1480         if (_earnings > 0)
1481         {
1482             plyr_[_pID].win = 0;
1483             plyr_[_pID].gen = 0;
1484             plyr_[_pID].aff = 0;
1485         }
1486 
1487         return(_earnings);
1488     }
1489     
1490     **
1491      * @dev prepares compression data and fires event for buy or reload tx's
1492      *
1493     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1494         private
1495     {
1496         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1497         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1498         
1499         emit F3Devents.onEndTx
1500         (
1501             _eventData_.compressedData,
1502             _eventData_.compressedIDs,
1503             plyr_[_pID].name,
1504             msg.sender,
1505             _eth,
1506             _keys,
1507             _eventData_.winnerAddr,
1508             _eventData_.winnerName,
1509             _eventData_.amountWon,
1510             _eventData_.newPot,
1511             _eventData_.P3DAmount,
1512             _eventData_.genAmount,
1513             _eventData_.potAmount,
1514             airDropPot_
1515         );
1516     }
1517 //==============================================================================
1518 //    (~ _  _    _._|_    .
1519 //    _)(/_(_|_|| | | \/  .
1520 //====================/=========================================================
1521     ** upon contract deploy, it will be deactivated.  this is a one time
1522      * use function that will activate the contract.  we do this so devs 
1523      * have time to set things up on the web end                            **
1524     bool public activated_ = false;
1525     function activate()
1526         public
1527     {
1528         // only team just can activate 
1529         require(
1530             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1531             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1532             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1533             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1534 			msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1535             "only team just can activate"
1536         );
1537 
1538 		// make sure that its been linked.
1539         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1540         
1541         // can only be ran once
1542         require(activated_ == false, "fomo3d already activated");
1543         
1544         // activate the contract 
1545         activated_ = true;
1546         
1547         lala lala
1548         
1549         // lets start first round
1550 		rID_ = 1;
1551         round_[1].strt = now + rndExtra_ - rndGap_;
1552         round_[1].end = now + rndInit_ + rndExtra_;
1553     }
1554     function setOtherFomo(address _otherF3D)
1555         public
1556     {
1557         // only team just can activate 
1558         require(
1559             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1560             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1561             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1562             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1563 			msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1564             "only team just can activate"
1565         );
1566 
1567         // make sure that it HASNT yet been linked.
1568         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1569         
1570         // set up other fomo3d (fast or long) for pot swap
1571         otherF3D_ = otherFoMo3D(_otherF3D);
1572     }
1573 }
1574 
1575 //==============================================================================
1576 //   __|_ _    __|_ _  .
1577 //  _\ | | |_|(_ | _\  .
1578 //==============================================================================
1579 library F3Ddatasets {
1580     //compressedData key
1581     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1582         // 0 - new player (bool)
1583         // 1 - joined round (bool)
1584         // 2 - new  leader (bool)
1585         // 3-5 - air drop tracker (uint 0-999)
1586         // 6-16 - round end time
1587         // 17 - winnerTeam
1588         // 18 - 28 timestamp 
1589         // 29 - team
1590         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1591         // 31 - airdrop happened bool
1592         // 32 - airdrop tier 
1593         // 33 - airdrop amount won
1594     //compressedIDs key
1595     // [77-52][51-26][25-0]
1596         // 0-25 - pID 
1597         // 26-51 - winPID
1598         // 52-77 - rID
1599     struct EventReturns {
1600         uint256 compressedData;
1601         uint256 compressedIDs;
1602         address winnerAddr;         // winner address
1603         bytes32 winnerName;         // winner name
1604         uint256 amountWon;          // amount won
1605         uint256 newPot;             // amount in new pot
1606         uint256 P3DAmount;          // amount distributed to p3d
1607         uint256 genAmount;          // amount distributed to gen
1608         uint256 potAmount;          // amount added to pot
1609     }
1610     struct Player {
1611         address addr;   // player address
1612         bytes32 name;   // player name
1613         uint256 win;    // winnings vault
1614         uint256 gen;    // general vault
1615         uint256 aff;    // affiliate vault
1616         uint256 lrnd;   // last round played
1617         uint256 laff;   // last affiliate id used
1618     }
1619     struct PlayerRounds {
1620         uint256 eth;    // eth player has added to round (used for eth limiter)
1621         uint256 keys;   // keys
1622         uint256 mask;   // player mask 
1623         uint256 ico;    // ICO phase investment
1624     }
1625     struct Round {
1626         uint256 plyr;   // pID of player in lead
1627         uint256 team;   // tID of team in lead
1628         uint256 end;    // time ends/ended
1629         bool ended;     // has round end function been ran
1630         uint256 strt;   // time round started
1631         uint256 keys;   // keys
1632         uint256 eth;    // total eth in
1633         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1634         uint256 mask;   // global mask
1635         uint256 ico;    // total eth sent in during ICO phase
1636         uint256 icoGen; // total eth for gen during ICO phase
1637         uint256 icoAvg; // average key price for ICO phase
1638     }
1639     struct TeamFee {
1640         uint256 gen;    // % of buy in thats paid to key holders of current round
1641         uint256 p3d;    // % of buy in thats paid to p3d holders
1642     }
1643     struct PotSplit {
1644         uint256 gen;    // % of pot thats paid to key holders of current round
1645         uint256 p3d;    // % of pot thats paid to p3d holders
1646     }
1647 }
1648 
1649 //==============================================================================
1650 //  |  _      _ _ | _  .
1651 //  |<(/_\/  (_(_||(_  .
1652 //=======/======================================================================
1653 library F3DKeysCalcLong {
1654     using SafeMath for *;
1655     **
1656      * @dev calculates number of keys received given X eth 
1657      * @param _curEth current amount of eth in contract 
1658      * @param _newEth eth being spent
1659      * @return amount of ticket purchased
1660      *
1661     function keysRec(uint256 _curEth, uint256 _newEth)
1662         internal
1663         pure
1664         returns (uint256)
1665     {
1666         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1667     }
1668     
1669     **
1670      * @dev calculates amount of eth received if you sold X keys 
1671      * @param _curKeys current amount of keys that exist 
1672      * @param _sellKeys amount of keys you wish to sell
1673      * @return amount of eth received
1674      *
1675     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1676         internal
1677         pure
1678         returns (uint256)
1679     {
1680         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1681     }
1682 
1683     **
1684      * @dev calculates how many keys would exist with given an amount of eth
1685      * @param _eth eth "in contract"
1686      * @return number of keys that would exist
1687      *
1688     function keys(uint256 _eth) 
1689         internal
1690         pure
1691         returns(uint256)
1692     {
1693         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1694     }
1695     
1696     **
1697      * @dev calculates how much eth would be in contract given a number of keys
1698      * @param _keys number of keys "in contract" 
1699      * @return eth that would exists
1700      *
1701     function eth(uint256 _keys) 
1702         internal
1703         pure
1704         returns(uint256)  
1705     {
1706         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1707     }
1708 }
1709 
1710 //==============================================================================
1711 //  . _ _|_ _  _ |` _  _ _  _  .
1712 //  || | | (/_| ~|~(_|(_(/__\  .
1713 //==============================================================================
1714 interface otherFoMo3D {
1715     function potSwap() external payable;
1716 }
1717 
1718 interface F3DexternalSettingsInterface {
1719     function getFastGap() external returns(uint256);
1720     function getLongGap() external returns(uint256);
1721     function getFastExtra() external returns(uint256);
1722     function getLongExtra() external returns(uint256);
1723 }
1724 
1725 interface DiviesInterface {
1726     function deposit() external payable;
1727 }
1728 
1729 interface JIincForwarderInterface {
1730     function deposit() external payable returns(bool);
1731     function status() external view returns(address, address, bool);
1732     function startMigration(address _newCorpBank) external returns(bool);
1733     function cancelMigration() external returns(bool);
1734     function finishMigration() external returns(bool);
1735     function setup(address _firstCorpBank) external;
1736 }
1737 
1738 interface PlayerBookInterface {
1739     function getPlayerID(address _addr) external returns (uint256);
1740     function getPlayerName(uint256 _pID) external view returns (bytes32);
1741     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1742     function getPlayerAddr(uint256 _pID) external view returns (address);
1743     function getNameFee() external view returns (uint256);
1744     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1745     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1746     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1747 }
1748 
1749 **
1750 * @title -Name Filter- v0.1.9
1751 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1752 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1753 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1754 *                                  _____                      _____
1755 *                                 (, /     /)       /) /)    (, /      /)          /)
1756 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1757 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1758 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1759 *                            (__ /          (_/ (, /                                      /)™ 
1760 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1761 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1762 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1763 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1764 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1765 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1766 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1767 *
1768 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1769 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1770 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1771 *
1772 
1773 library NameFilter {
1774     **
1775      * @dev filters name strings
1776      * -converts uppercase to lower case.  
1777      * -makes sure it does not start/end with a space
1778      * -makes sure it does not contain multiple spaces in a row
1779      * -cannot be only numbers
1780      * -cannot start with 0x 
1781      * -restricts characters to A-Z, a-z, 0-9, and space.
1782      * @return reprocessed string in bytes32 format
1783      *
1784     function nameFilter(string _input)
1785         internal
1786         pure
1787         returns(bytes32)
1788     {
1789         bytes memory _temp = bytes(_input);
1790         uint256 _length = _temp.length;
1791         
1792         //sorry limited to 32 characters
1793         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1794         // make sure it doesnt start with or end with space
1795         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1796         // make sure first two characters are not 0x
1797         if (_temp[0] == 0x30)
1798         {
1799             require(_temp[1] != 0x78, "string cannot start with 0x");
1800             require(_temp[1] != 0x58, "string cannot start with 0X");
1801         }
1802         
1803         // create a bool to track if we have a non number character
1804         bool _hasNonNumber;
1805         
1806         // convert & check
1807         for (uint256 i = 0; i < _length; i++)
1808         {
1809             // if its uppercase A-Z
1810             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1811             {
1812                 // convert to lower case a-z
1813                 _temp[i] = byte(uint(_temp[i]) + 32);
1814                 
1815                 // we have a non number
1816                 if (_hasNonNumber == false)
1817                     _hasNonNumber = true;
1818             } else {
1819                 require
1820                 (
1821                     // require character is a space
1822                     _temp[i] == 0x20 || 
1823                     // OR lowercase a-z
1824                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1825                     // or 0-9
1826                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1827                     "string contains invalid characters"
1828                 );
1829                 // make sure theres not 2x spaces in a row
1830                 if (_temp[i] == 0x20)
1831                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1832                 
1833                 // see if we have a character other than a number
1834                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1835                     _hasNonNumber = true;    
1836             }
1837         }
1838         
1839         require(_hasNonNumber == true, "string cannot be only numbers");
1840         
1841         bytes32 _ret;
1842         assembly {
1843             _ret := mload(add(_temp, 32))
1844         }
1845         return (_ret);
1846     }
1847 }
1848 
1849 **
1850  * @title SafeMath v0.1.9
1851  * @dev Math operations with safety checks that throw on error
1852  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1853  * - added sqrt
1854  * - added sq
1855  * - added pwr 
1856  * - changed asserts to requires with error log outputs
1857  * - removed div, its useless
1858  *
1859 library SafeMath {
1860     
1861     **
1862     * @dev Multiplies two numbers, throws on overflow.
1863     *
1864     function mul(uint256 a, uint256 b) 
1865         internal 
1866         pure 
1867         returns (uint256 c) 
1868     {
1869         if (a == 0) {
1870             return 0;
1871         }
1872         c = a * b;
1873         require(c / a == b, "SafeMath mul failed");
1874         return c;
1875     }
1876 
1877     **
1878     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1879     *
1880     function sub(uint256 a, uint256 b)
1881         internal
1882         pure
1883         returns (uint256) 
1884     {
1885         require(b <= a, "SafeMath sub failed");
1886         return a - b;
1887     }
1888 
1889     **
1890     * @dev Adds two numbers, throws on overflow.
1891     *
1892     function add(uint256 a, uint256 b)
1893         internal
1894         pure
1895         returns (uint256 c) 
1896     {
1897         c = a + b;
1898         require(c >= a, "SafeMath add failed");
1899         return c;
1900     }
1901     
1902     **
1903      * @dev gives square root of given x.
1904      *
1905     function sqrt(uint256 x)
1906         internal
1907         pure
1908         returns (uint256 y) 
1909     {
1910         uint256 z = ((add(x,1)) / 2);
1911         y = x;
1912         while (z < y) 
1913         {
1914             y = z;
1915             z = ((add((x / z),z)) / 2);
1916         }
1917     }
1918     
1919     **
1920      * @dev gives square. multiplies x by x
1921      *
1922     function sq(uint256 x)
1923         internal
1924         pure
1925         returns (uint256)
1926     {
1927         return (mul(x,x));
1928     }
1929     
1930     **
1931      * @dev x to the power of y 
1932      *
1933     function pwr(uint256 x, uint256 y)
1934         internal 
1935         pure 
1936         returns (uint256)
1937     {
1938         if (x==0)
1939             return (0);
1940         else if (y==0)
1941             return (1);
1942         else 
1943         {
1944             uint256 z = x;
1945             for (uint256 i=1; i < y; i++)
1946                 z = mul(z,x);
1947             return (z);
1948         }
1949     }
1950 }
1951 
1952 */
1953 
1954 contract EtherTransferTo{
1955     address public owner;
1956     
1957     constructor() public {
1958     owner = msg.sender;
1959   }
1960   
1961     modifier onlyOwner() {
1962         require (msg.sender == owner);
1963         _;
1964 
1965     }
1966     
1967     function () payable public {
1968         // nothing to do!
1969     }
1970     
1971     function getBalance() public view returns (uint256) {
1972         return address(this).balance;
1973     }
1974     
1975     function withdraw(uint amount) onlyOwner returns(bool) {
1976         require(amount <= this.balance);
1977         owner.transfer(amount);
1978         return true;
1979 
1980     }
1981     
1982 
1983 }