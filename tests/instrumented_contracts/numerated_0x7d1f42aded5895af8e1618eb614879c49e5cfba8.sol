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
28  *====|   | ,'=============='---'==========(soon edition)===========\   \     .'===|   ,.'======*
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
43  *   │ Kadaz, Incognito Jo, Lil Stronghands, Maojk, Psaints,   └───────────────────────────┐
44  *   │ P3DHeem, 3DCrypto, FaFiam, Crypto Yardi, Ninja Turtle, Psaints, Satoshi, Vitalik,   │ 
45  *   │ Justin Sun, Nano 2nd, Bogdanoffs                        Isaac Newton, Nikola Tesla, │
46  *   │ Le Comte De Saint Germain, Albert Einstein, Socrates, & all the volunteer moderator │
47  *   │ & support staff, content, creators, autonomous agents, and indie devs for P3D.      │
48  *   │              Without your help, we wouldn't have the time to code this.             │
49  *   └─────────────────────────────────────────────────────────────────────────────────────┘
50  * 
51  * This product is protected under license.  Any unauthorized copy, modification, or use without 
52  * express written consent from the creators is prohibited.
53  * 
54  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
55  */
56 
57 //==============================================================================
58 //     _    _  _ _|_ _  .
59 //    (/_\/(/_| | | _\  .
60 //==============================================================================
61 contract F3Devents {
62     // fired whenever a player registers a name
63     event onNewName
64     (
65         uint256 indexed playerID,
66         address indexed playerAddress,
67         bytes32 indexed playerName,
68         bool isNewPlayer,
69         uint256 affiliateID,
70         address affiliateAddress,
71         bytes32 affiliateName,
72         uint256 amountPaid,
73         uint256 timeStamp
74     );
75     
76     // fired at end of buy or reload
77     event onEndTx
78     (
79         uint256 compressedData,     
80         uint256 compressedIDs,      
81         bytes32 playerName,
82         address playerAddress,
83         uint256 ethIn,
84         uint256 keysBought,
85         address winnerAddr,
86         bytes32 winnerName,
87         uint256 amountWon,
88         uint256 newPot,
89         uint256 P3DAmount,
90         uint256 genAmount,
91         uint256 potAmount,
92         uint256 airDropPot
93     );
94     
95 	// fired whenever theres a withdraw
96     event onWithdraw
97     (
98         uint256 indexed playerID,
99         address playerAddress,
100         bytes32 playerName,
101         uint256 ethOut,
102         uint256 timeStamp
103     );
104     
105     // fired whenever a withdraw forces end round to be ran
106     event onWithdrawAndDistribute
107     (
108         address playerAddress,
109         bytes32 playerName,
110         uint256 ethOut,
111         uint256 compressedData,
112         uint256 compressedIDs,
113         address winnerAddr,
114         bytes32 winnerName,
115         uint256 amountWon,
116         uint256 newPot,
117         uint256 P3DAmount,
118         uint256 genAmount
119     );
120     
121     // (fomo3d long only) fired whenever a player tries a buy after round timer 
122     // hit zero, and causes end round to be ran.
123     event onBuyAndDistribute
124     (
125         address playerAddress,
126         bytes32 playerName,
127         uint256 ethIn,
128         uint256 compressedData,
129         uint256 compressedIDs,
130         address winnerAddr,
131         bytes32 winnerName,
132         uint256 amountWon,
133         uint256 newPot,
134         uint256 P3DAmount,
135         uint256 genAmount
136     );
137     
138     // (fomo3d long only) fired whenever a player tries a reload after round timer 
139     // hit zero, and causes end round to be ran.
140     event onReLoadAndDistribute
141     (
142         address playerAddress,
143         bytes32 playerName,
144         uint256 compressedData,
145         uint256 compressedIDs,
146         address winnerAddr,
147         bytes32 winnerName,
148         uint256 amountWon,
149         uint256 newPot,
150         uint256 P3DAmount,
151         uint256 genAmount
152     );
153     
154     // fired whenever an affiliate is paid
155     event onAffiliatePayout
156     (
157         uint256 indexed affiliateID,
158         address affiliateAddress,
159         bytes32 affiliateName,
160         uint256 indexed roundID,
161         uint256 indexed buyerID,
162         uint256 amount,
163         uint256 timeStamp
164     );
165     
166     // received pot swap deposit
167     event onPotSwapDeposit
168     (
169         uint256 roundID,
170         uint256 amountAddedToPot
171     );
172 }
173 
174 contract FoMo3DSoon is F3Devents{
175     using SafeMath for uint256;
176     using NameFilter for string;
177     using F3DKeysCalcFast for uint256;
178     
179 	DiviesInterface constant private Divies = DiviesInterface(0xa5697bc0725c664a89a8178e81fbc187aca33d8b);
180     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x42503c3dcca420adf53dff5bb1fb176b8773aaa0);
181 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x962e2c933fd7bb3FCD9aFf882e1af4414ada6335);
182 //==============================================================================
183 //     _ _  _  |`. _     _ _ |_ | _  _  .
184 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
185 //=================_|===========================================================
186     string constant public name = "FoMo3D Soon(tm) Edition";
187     string constant public symbol = "F3D";
188 	uint256 private rndGap_ = 60 seconds;                       // length of ICO phase, set to 1 year for EOS.
189     uint256 constant private rndInit_ = 5 minutes;              // round timer starts at this
190     uint256 constant private rndInc_ = 5 minutes;               // every full key purchased adds this much to the timer
191     uint256 constant private rndMax_ = 5 minutes;               // max length a round timer can be
192 //==============================================================================
193 //     _| _ _|_ _    _ _ _|_    _   .
194 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
195 //=============================|================================================
196 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
197     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
198     uint256 public rID_;    // round id number / total rounds that have happened
199 //****************
200 // PLAYER DATA 
201 //****************
202     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
203     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
204     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
205     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
206     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
207 //****************
208 // ROUND DATA 
209 //****************
210     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
211     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
212 //****************
213 // TEAM FEE DATA 
214 //****************
215     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
216     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
217 //==============================================================================
218 //     _ _  _  __|_ _    __|_ _  _  .
219 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
220 //==============================================================================
221     constructor()
222         public
223     {
224 		// Team allocation structures
225         // 0 = whales
226         // 1 = bears
227         // 2 = sneks
228         // 3 = bulls
229 
230 		// Team allocation percentages
231         // (F3D, P3D) + (Pot , Referrals, Community)
232             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
233         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
234         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
235         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
236         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
237         
238         // how to split up the final pot based on which team was picked
239         // (F3D, P3D)
240         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
241         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
242         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
243         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
244 	}
245 //==============================================================================
246 //     _ _  _  _|. |`. _  _ _  .
247 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
248 //==============================================================================
249     /**
250      * @dev used to make sure no one can interact with contract until it has 
251      * been activated. 
252      */
253     modifier isActivated() {
254         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
255         _;
256     }
257     
258     /**
259      * @dev prevents contracts from interacting with fomo3d 
260      */
261     modifier isHuman() {
262         address _addr = msg.sender;
263         require (_addr == tx.origin);
264         
265         uint256 _codeLength;
266         
267         assembly {_codeLength := extcodesize(_addr)}
268         require(_codeLength == 0, "sorry humans only");
269         _;
270     }
271 
272     /**
273      * @dev sets boundaries for incoming tx 
274      */
275     modifier isWithinLimits(uint256 _eth) {
276         require(_eth >= 1000000000, "pocket lint: not a valid currency");
277         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** NOTE THIS NEEDS TO BE CHECKED **/
278 		_;    
279 	}
280 //==============================================================================
281 //     _    |_ |. _   |`    _  __|_. _  _  _  .
282 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
283 //====|=========================================================================
284     /**
285      * @dev emergency buy uses last stored affiliate ID and team snek
286      */
287     function()
288         isActivated()
289         isHuman()
290         isWithinLimits(msg.value)
291         public
292         payable
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
312     function buyXid(uint256 _affCode, uint256 _team)
313         isActivated()
314         isHuman()
315         isWithinLimits(msg.value)
316         public
317         payable
318     {
319         // set up our tx event data and determine if player is new or not
320         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
321         
322         // fetch player id
323         uint256 _pID = pIDxAddr_[msg.sender];
324         
325         // manage affiliate residuals
326         // if no affiliate code was given or player tried to use their own, lolz
327         if (_affCode == 0 || _affCode == _pID)
328         {
329             // use last stored affiliate code 
330             _affCode = plyr_[_pID].laff;
331             
332         // if affiliate code was given & its not the same as previously stored 
333         } else if (_affCode != plyr_[_pID].laff) {
334             // update last affiliate 
335             plyr_[_pID].laff = _affCode;
336         }
337         
338         // verify a valid team was selected
339         _team = verifyTeam(_team);
340         
341         // buy core 
342         buyCore(_pID, _affCode, _team, _eventData_);
343     }
344     
345     function buyXaddr(address _affCode, uint256 _team)
346         isActivated()
347         isHuman()
348         isWithinLimits(msg.value)
349         public
350         payable
351     {
352         // set up our tx event data and determine if player is new or not
353         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
354         
355         // fetch player id
356         uint256 _pID = pIDxAddr_[msg.sender];
357         
358         // manage affiliate residuals
359         uint256 _affID;
360         // if no affiliate code was given or player tried to use their own, lolz
361         if (_affCode == address(0) || _affCode == msg.sender)
362         {
363             // use last stored affiliate code
364             _affID = plyr_[_pID].laff;
365         
366         // if affiliate code was given    
367         } else {
368             // get affiliate ID from aff Code 
369             _affID = pIDxAddr_[_affCode];
370             
371             // if affID is not the same as previously stored 
372             if (_affID != plyr_[_pID].laff)
373             {
374                 // update last affiliate
375                 plyr_[_pID].laff = _affID;
376             }
377         }
378         
379         // verify a valid team was selected
380         _team = verifyTeam(_team);
381         
382         // buy core 
383         buyCore(_pID, _affID, _team, _eventData_);
384     }
385     
386     function buyXname(bytes32 _affCode, uint256 _team)
387         isActivated()
388         isHuman()
389         isWithinLimits(msg.value)
390         public
391         payable
392     {
393         // set up our tx event data and determine if player is new or not
394         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
395         
396         // fetch player id
397         uint256 _pID = pIDxAddr_[msg.sender];
398         
399         // manage affiliate residuals
400         uint256 _affID;
401         // if no affiliate code was given or player tried to use their own, lolz
402         if (_affCode == '' || _affCode == plyr_[_pID].name)
403         {
404             // use last stored affiliate code
405             _affID = plyr_[_pID].laff;
406         
407         // if affiliate code was given
408         } else {
409             // get affiliate ID from aff Code
410             _affID = pIDxName_[_affCode];
411             
412             // if affID is not the same as previously stored
413             if (_affID != plyr_[_pID].laff)
414             {
415                 // update last affiliate
416                 plyr_[_pID].laff = _affID;
417             }
418         }
419         
420         // verify a valid team was selected
421         _team = verifyTeam(_team);
422         
423         // buy core 
424         buyCore(_pID, _affID, _team, _eventData_);
425     }
426     
427     /**
428      * @dev essentially the same as buy, but instead of you sending ether 
429      * from your wallet, it uses your unwithdrawn earnings.
430      * -functionhash- 0x349cdcac (using ID for affiliate)
431      * -functionhash- 0x82bfc739 (using address for affiliate)
432      * -functionhash- 0x079ce327 (using name for affiliate)
433      * @param _affCode the ID/address/name of the player who gets the affiliate fee
434      * @param _team what team is the player playing for?
435      * @param _eth amount of earnings to use (remainder returned to gen vault)
436      */
437     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
438         isActivated()
439         isHuman()
440         isWithinLimits(_eth)
441         public
442     {
443         // set up our tx event data
444         F3Ddatasets.EventReturns memory _eventData_;
445         
446         // fetch player ID
447         uint256 _pID = pIDxAddr_[msg.sender];
448         
449         // manage affiliate residuals
450         // if no affiliate code was given or player tried to use their own, lolz
451         if (_affCode == 0 || _affCode == _pID)
452         {
453             // use last stored affiliate code 
454             _affCode = plyr_[_pID].laff;
455             
456         // if affiliate code was given & its not the same as previously stored 
457         } else if (_affCode != plyr_[_pID].laff) {
458             // update last affiliate 
459             plyr_[_pID].laff = _affCode;
460         }
461 
462         // verify a valid team was selected
463         _team = verifyTeam(_team);
464             
465         // reload core
466         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
467     }
468     
469     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
470         isActivated()
471         isHuman()
472         isWithinLimits(_eth)
473         public
474     {
475         // set up our tx event data
476         F3Ddatasets.EventReturns memory _eventData_;
477         
478         // fetch player ID
479         uint256 _pID = pIDxAddr_[msg.sender];
480         
481         // manage affiliate residuals
482         uint256 _affID;
483         // if no affiliate code was given or player tried to use their own, lolz
484         if (_affCode == address(0) || _affCode == msg.sender)
485         {
486             // use last stored affiliate code
487             _affID = plyr_[_pID].laff;
488         
489         // if affiliate code was given    
490         } else {
491             // get affiliate ID from aff Code 
492             _affID = pIDxAddr_[_affCode];
493             
494             // if affID is not the same as previously stored 
495             if (_affID != plyr_[_pID].laff)
496             {
497                 // update last affiliate
498                 plyr_[_pID].laff = _affID;
499             }
500         }
501         
502         // verify a valid team was selected
503         _team = verifyTeam(_team);
504         
505         // reload core
506         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
507     }
508     
509     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
510         isActivated()
511         isHuman()
512         isWithinLimits(_eth)
513         public
514     {
515         // set up our tx event data
516         F3Ddatasets.EventReturns memory _eventData_;
517         
518         // fetch player ID
519         uint256 _pID = pIDxAddr_[msg.sender];
520         
521         // manage affiliate residuals
522         uint256 _affID;
523         // if no affiliate code was given or player tried to use their own, lolz
524         if (_affCode == '' || _affCode == plyr_[_pID].name)
525         {
526             // use last stored affiliate code
527             _affID = plyr_[_pID].laff;
528         
529         // if affiliate code was given
530         } else {
531             // get affiliate ID from aff Code
532             _affID = pIDxName_[_affCode];
533             
534             // if affID is not the same as previously stored
535             if (_affID != plyr_[_pID].laff)
536             {
537                 // update last affiliate
538                 plyr_[_pID].laff = _affID;
539             }
540         }
541         
542         // verify a valid team was selected
543         _team = verifyTeam(_team);
544         
545         // reload core
546         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
547     }
548 
549     /**
550      * @dev withdraws all of your earnings.
551      * -functionhash- 0x3ccfd60b
552      */
553     function withdraw()
554         isActivated()
555         isHuman()
556         public
557     {
558         // setup local rID
559         uint256 _rID = rID_;
560         
561         // grab time
562         uint256 _now = now;
563         
564         // fetch player ID
565         uint256 _pID = pIDxAddr_[msg.sender];
566         
567         // setup temp var for player eth
568         uint256 _eth;
569         
570         // check to see if round has ended and no one has run round end yet
571         if (_now > round_[_rID].end && round_[_rID].ended == false)
572         {
573             // set up our tx event data
574             F3Ddatasets.EventReturns memory _eventData_;
575             
576             // end the round (distributes pot)
577 			round_[_rID].ended = true;
578             _eventData_ = endRound(_eventData_);
579             
580 			// get their earnings
581             _eth = withdrawEarnings(_pID);
582             
583             // gib moni
584             if (_eth > 0)
585                 plyr_[_pID].addr.transfer(_eth);    
586             
587             // build event data
588             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
589             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
590             
591             // fire withdraw and distribute event
592             emit F3Devents.onWithdrawAndDistribute
593             (
594                 msg.sender, 
595                 plyr_[_pID].name, 
596                 _eth, 
597                 _eventData_.compressedData, 
598                 _eventData_.compressedIDs, 
599                 _eventData_.winnerAddr, 
600                 _eventData_.winnerName, 
601                 _eventData_.amountWon, 
602                 _eventData_.newPot, 
603                 _eventData_.P3DAmount, 
604                 _eventData_.genAmount
605             );
606             
607         // in any other situation
608         } else {
609             // get their earnings
610             _eth = withdrawEarnings(_pID);
611             
612             // gib moni
613             if (_eth > 0)
614                 plyr_[_pID].addr.transfer(_eth);
615             
616             // fire withdraw event
617             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
618         }
619     }
620     
621     /**
622      * @dev use these to register names.  they are just wrappers that will send the
623      * registration requests to the PlayerBook contract.  So registering here is the 
624      * same as registering there.  UI will always display the last name you registered.
625      * but you will still own all previously registered names to use as affiliate 
626      * links.
627      * - must pay a registration fee.
628      * - name must be unique
629      * - names will be converted to lowercase
630      * - name cannot start or end with a space 
631      * - cannot have more than 1 space in a row
632      * - cannot be only numbers
633      * - cannot start with 0x 
634      * - name must be at least 1 char
635      * - max length of 32 characters long
636      * - allowed characters: a-z, 0-9, and space
637      * -functionhash- 0x921dec21 (using ID for affiliate)
638      * -functionhash- 0x3ddd4698 (using address for affiliate)
639      * -functionhash- 0x685ffd83 (using name for affiliate)
640      * @param _nameString players desired name
641      * @param _affCode affiliate ID, address, or name of who referred you
642      * @param _all set to true if you want this to push your info to all games 
643      * (this might cost a lot of gas)
644      */
645     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
646         isHuman()
647         public
648         payable
649     {
650         bytes32 _name = _nameString.nameFilter();
651         address _addr = msg.sender;
652         uint256 _paid = msg.value;
653         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
654         
655         uint256 _pID = pIDxAddr_[_addr];
656         
657         // fire event
658         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
659     }
660     
661     function registerNameXaddr(string _nameString, address _affCode, bool _all)
662         isHuman()
663         public
664         payable
665     {
666         bytes32 _name = _nameString.nameFilter();
667         address _addr = msg.sender;
668         uint256 _paid = msg.value;
669         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
670         
671         uint256 _pID = pIDxAddr_[_addr];
672         
673         // fire event
674         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
675     }
676     
677     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
678         isHuman()
679         public
680         payable
681     {
682         bytes32 _name = _nameString.nameFilter();
683         address _addr = msg.sender;
684         uint256 _paid = msg.value;
685         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
686         
687         uint256 _pID = pIDxAddr_[_addr];
688         
689         // fire event
690         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
691     }
692 //==============================================================================
693 //     _  _ _|__|_ _  _ _  .
694 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
695 //=====_|=======================================================================
696     /**
697      * @dev return the price buyer will pay for next 1 individual key.
698      * - during live round.  this is accurate. (well... unless someone buys before 
699      * you do and ups the price!  you better HURRY!)
700      * - during ICO phase.  this is the max you would get based on current eth 
701      * invested during ICO phase.  if others invest after you, you will receive
702      * less.  (so distract them with meme vids till ICO is over)
703      * -functionhash- 0x018a25e8
704      * @return price for next key bought (in wei format)
705      */
706     function getBuyPrice()
707         public 
708         view 
709         returns(uint256)
710     {  
711         // setup local rID
712         uint256 _rID = rID_;
713             
714         // grab time
715         uint256 _now = now;
716         
717         // is ICO phase over??  & theres eth in the round?
718         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
719             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
720         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
721             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
722         else // rounds over.  need price for new round
723             return ( 100000000000000 ); // init
724     }
725     
726     /**
727      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
728      * provider
729      * -functionhash- 0xc7e284b8
730      * @return time left in seconds
731      */
732     function getTimeLeft()
733         public
734         view
735         returns(uint256)
736     {
737         // setup local rID 
738         uint256 _rID = rID_;
739         
740         // grab time
741         uint256 _now = now;
742         
743         // are we in ICO phase?
744         if (_now <= round_[_rID].strt + rndGap_)
745             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
746         else 
747             if (_now < round_[_rID].end)
748                 return( (round_[_rID].end).sub(_now) );
749             else
750                 return(0);
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
769         if (now > round_[_rID].end && round_[_rID].ended == false)
770         {
771             uint256 _roundMask;
772             uint256 _roundEth;
773             uint256 _roundKeys;
774             uint256 _roundPot;
775             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
776             {
777                 // create a temp round eth based on eth sent in during ICO phase
778                 _roundEth = round_[_rID].ico;
779                 
780                 // create a temp round keys based on keys bought during ICO phase
781                 _roundKeys = (round_[_rID].ico).keys();
782                 
783                 // create a temp round mask based on eth and keys from ICO phase
784                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
785                 
786                 // create a temp rount pot based on pot, and dust from mask
787                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
788             } else {
789                 _roundEth = round_[_rID].eth;
790                 _roundKeys = round_[_rID].keys;
791                 _roundMask = round_[_rID].mask;
792                 _roundPot = round_[_rID].pot;
793             }
794             
795             uint256 _playerKeys;
796             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
797                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
798             else
799                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
800             
801             // if player is winner 
802             if (round_[_rID].plyr == _pID)
803             {
804                 return
805                 (
806                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
807                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
808                     plyr_[_pID].aff
809                 );
810             // if player is not the winner
811             } else {
812                 return
813                 (
814                     plyr_[_pID].win,   
815                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
816                     plyr_[_pID].aff
817                 );
818             }
819             
820         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
821         } else {
822             return
823             (
824                 plyr_[_pID].win,
825                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
826                 plyr_[_pID].aff
827             );
828         }
829     }
830     
831     /**
832      * solidity hates stack limits.  this lets us avoid that hate 
833      */
834     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
835         private
836         view
837         returns(uint256)
838     {
839         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
840     }
841     
842     /**
843      * @dev returns all current round info needed for front end
844      * -functionhash- 0x747dff42
845      * @return eth invested during ICO phase
846      * @return round id 
847      * @return total keys for round 
848      * @return time round ends
849      * @return time round started
850      * @return current pot 
851      * @return current team ID & player ID in lead 
852      * @return current player in leads address 
853      * @return current player in leads name
854      * @return whales eth in for round
855      * @return bears eth in for round
856      * @return sneks eth in for round
857      * @return bulls eth in for round
858      * @return airdrop tracker # & airdrop pot
859      */
860     function getCurrentRoundInfo()
861         public
862         view
863         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
864     {
865         // setup local rID
866         uint256 _rID = rID_;
867         
868         if (round_[_rID].eth != 0)
869         {
870             return
871             (
872                 round_[_rID].ico,               //0
873                 _rID,                           //1
874                 round_[_rID].keys,              //2
875                 round_[_rID].end,               //3
876                 round_[_rID].strt,              //4
877                 round_[_rID].pot,               //5
878                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
879                 plyr_[round_[_rID].plyr].addr,  //7
880                 plyr_[round_[_rID].plyr].name,  //8
881                 rndTmEth_[_rID][0],             //9
882                 rndTmEth_[_rID][1],             //10
883                 rndTmEth_[_rID][2],             //11
884                 rndTmEth_[_rID][3],             //12
885                 airDropTracker_ + (airDropPot_ * 1000)              //13
886             );
887         } else {
888             return
889             (
890                 round_[_rID].ico,               //0
891                 _rID,                           //1
892                 (round_[_rID].ico).keys(),      //2
893                 round_[_rID].end,               //3
894                 round_[_rID].strt,              //4
895                 round_[_rID].pot,               //5
896                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
897                 plyr_[round_[_rID].plyr].addr,  //7
898                 plyr_[round_[_rID].plyr].name,  //8
899                 rndTmEth_[_rID][0],             //9
900                 rndTmEth_[_rID][1],             //10
901                 rndTmEth_[_rID][2],             //11
902                 rndTmEth_[_rID][3],             //12
903                 airDropTracker_ + (airDropPot_ * 1000)              //13
904             );
905         }
906     }
907 
908     /**
909      * @dev returns player info based on address.  if no address is given, it will 
910      * use msg.sender 
911      * -functionhash- 0xee0b5d8b
912      * @param _addr address of the player you want to lookup 
913      * @return player ID 
914      * @return player name
915      * @return keys owned (current round)
916      * @return winnings vault
917      * @return general vault 
918      * @return affiliate vault 
919 	 * @return player ico eth
920      */
921     function getPlayerInfoByAddress(address _addr)
922         public 
923         view 
924         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
925     {
926         // setup local rID
927         uint256 _rID = rID_;
928         
929         if (_addr == address(0))
930         {
931             _addr == msg.sender;
932         }
933         uint256 _pID = pIDxAddr_[_addr];
934         
935         if (plyrRnds_[_pID][_rID].ico == 0)
936         {
937             return
938             (
939                 _pID,                               //0
940                 plyr_[_pID].name,                   //1
941                 plyrRnds_[_pID][_rID].keys,         //2
942                 plyr_[_pID].win,                    //3
943                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
944                 plyr_[_pID].aff,                    //5
945 				0						            //6
946             );
947         } else {
948             return
949             (
950                 _pID,                               //0
951                 plyr_[_pID].name,                   //1
952                 calcPlayerICOPhaseKeys(_pID, _rID), //2
953                 plyr_[_pID].win,                    //3
954                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
955                 plyr_[_pID].aff,                    //5
956 				plyrRnds_[_pID][_rID].ico           //6
957             );
958         }
959         
960     }
961 
962 //==============================================================================
963 //     _ _  _ _   | _  _ . _  .
964 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
965 //=====================_|=======================================================
966     /**
967      * @dev logic runs whenever a buy order is executed.  determines how to handle 
968      * incoming eth depending on if we are in ICO phase or not 
969      */
970     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
971         private
972     {
973         // check to see if round has ended.  and if player is new to round
974         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
975         
976         // are we in ICO phase?
977         if (now <= round_[rID_].strt + rndGap_) 
978         {
979             // let event data know this is a ICO phase buy order
980             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
981         
982             // ICO phase core
983             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
984         
985         
986         // round is live
987         } else {
988              // let event data know this is a buy order
989             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
990         
991             // call core
992             core(_pID, msg.value, _affID, _team, _eventData_);
993         }
994     }
995 
996     /**
997      * @dev logic runs whenever a reload order is executed.  determines how to handle 
998      * incoming eth depending on if we are in ICO phase or not 
999      */
1000     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1001         private 
1002     {
1003         // check to see if round has ended.  and if player is new to round
1004         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
1005         
1006         // get earnings from all vaults and return unused to gen vault
1007         // because we use a custom safemath library.  this will throw if player 
1008         // tried to spend more eth than they have.
1009         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1010                 
1011         // are we in ICO phase?
1012         if (now <= round_[rID_].strt + rndGap_) 
1013         {
1014             // let event data know this is an ICO phase reload 
1015             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
1016                 
1017             // ICO phase core
1018             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
1019 
1020 
1021         // round is live
1022         } else {
1023             // call core
1024             core(_pID, _eth, _affID, _team, _eventData_);
1025         }
1026     }    
1027     
1028     /**
1029      * @dev during ICO phase all eth sent in by each player.  will be added to an 
1030      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
1031      * each player receives an amount based on how much they put in, and the 
1032      * the average price attained.
1033      */
1034     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1035         private
1036     {
1037         // setup local rID
1038         uint256 _rID = rID_;
1039         
1040         // if they bought at least 1 whole key (at time of purchase)
1041         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
1042         {
1043             // set new leaders
1044             if (round_[_rID].plyr != _pID)
1045                 round_[_rID].plyr = _pID;  
1046             if (round_[_rID].team != _team)
1047                 round_[_rID].team = _team;
1048             
1049             // set the new leader bool to true
1050             _eventData_.compressedData = _eventData_.compressedData + 100;
1051         }
1052         
1053         // add eth to our players & rounds ICO phase investment. this will be used 
1054         // to determine total keys and each players share 
1055         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
1056         round_[_rID].ico = _eth.add(round_[_rID].ico);
1057         
1058         // add eth in to team eth tracker
1059         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1060         
1061         // send eth share to com, p3d, affiliate, and fomo3d long
1062         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1063         
1064         // calculate gen share 
1065         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1066         
1067         // add gen share to rounds ICO phase gen tracker (will be distributed 
1068         // when round starts)
1069         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
1070         
1071 		// toss 1% into airdrop pot 
1072         uint256 _air = (_eth / 100);
1073         airDropPot_ = airDropPot_.add(_air);
1074         
1075         // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
1076         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);
1077         
1078         // add eth to pot
1079         round_[_rID].pot = _pot.add(round_[_rID].pot);
1080         
1081         // set up event data
1082         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1083         _eventData_.potAmount = _pot;
1084         
1085         // fire event
1086         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
1087     }
1088     
1089     /**
1090      * @dev this is the core logic for any buy/reload that happens while a round 
1091      * is live.
1092      */
1093     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1094         private
1095     {
1096         // setup local rID
1097         uint256 _rID = rID_;
1098         
1099         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1100         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1101             roundClaimICOKeys(_rID);
1102         
1103         // if player is new to round and is owed keys from ICO phase 
1104         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1105         {
1106             // assign player their keys from ICO phase
1107             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1108             // zero out ICO phase investment
1109             plyrRnds_[_pID][_rID].ico = 0;
1110         }
1111             
1112         // mint the new keys
1113         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1114         
1115         // if they bought at least 1 whole key
1116         if (_keys >= 1000000000000000000)
1117         {
1118             updateTimer(_keys, _rID);
1119 
1120             // set new leaders
1121             if (round_[_rID].plyr != _pID)
1122                 round_[_rID].plyr = _pID;  
1123             if (round_[_rID].team != _team)
1124                 round_[_rID].team = _team; 
1125             
1126             // set the new leader bool to true
1127             _eventData_.compressedData = _eventData_.compressedData + 100;
1128         }
1129         
1130         // manage airdrops
1131         if (_eth >= 100000000000000000)
1132         {
1133             airDropTracker_++;
1134             if (airdrop() == true)
1135             {
1136                 // gib muni
1137                 uint256 _prize;
1138                 if (_eth >= 10000000000000000000) 
1139                 {
1140                     // calculate prize and give it to winner
1141                     _prize = ((airDropPot_).mul(75)) / 100;
1142                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1143                     
1144                     // adjust airDropPot 
1145                     airDropPot_ = (airDropPot_).sub(_prize);
1146                     
1147                     // let event know a tier 3 prize was won 
1148                     _eventData_.compressedData += 300000000000000000000000000000000;
1149                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1150                     // calculate prize and give it to winner
1151                     _prize = ((airDropPot_).mul(50)) / 100;
1152                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1153                     
1154                     // adjust airDropPot 
1155                     airDropPot_ = (airDropPot_).sub(_prize);
1156                     
1157                     // let event know a tier 2 prize was won 
1158                     _eventData_.compressedData += 200000000000000000000000000000000;
1159                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1160                     // calculate prize and give it to winner
1161                     _prize = ((airDropPot_).mul(25)) / 100;
1162                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1163                     
1164                     // adjust airDropPot 
1165                     airDropPot_ = (airDropPot_).sub(_prize);
1166                     
1167                     // let event know a tier 1 prize was won 
1168                     _eventData_.compressedData += 100000000000000000000000000000000;
1169                 }
1170                 // set airdrop happened bool to true
1171                 _eventData_.compressedData += 10000000000000000000000000000000;
1172                 // let event know how much was won 
1173                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1174                 
1175                 // reset air drop tracker
1176                 airDropTracker_ = 0;
1177             }
1178         }
1179 
1180         // store the air drop tracker number (number of buys since last airdrop)
1181         _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1182         
1183         // update player 
1184         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1185         
1186         // update round
1187         round_[_rID].keys = _keys.add(round_[_rID].keys);
1188         round_[_rID].eth = _eth.add(round_[_rID].eth);
1189         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1190 
1191         // distribute eth
1192         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1193         _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1194         
1195         // call end tx function to fire end tx event.
1196         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1197     }
1198 //==============================================================================
1199 //     _ _ | _   | _ _|_ _  _ _  .
1200 //    (_(_||(_|_||(_| | (_)| _\  .
1201 //==============================================================================
1202     /**
1203      * @dev calculates unmasked earnings (just calculates, does not update mask)
1204      * @return earnings in wei format
1205      */
1206     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1207         private
1208         view
1209         returns(uint256)
1210     {
1211         // if player does not have unclaimed keys bought in ICO phase
1212         // return their earnings based on keys held only.
1213         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1214             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1215         else
1216             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1217                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1218             else
1219                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1220         // otherwise return earnings based on keys owed from ICO phase
1221         // (this would be a scenario where they only buy during ICO phase, and never 
1222         // buy/reload during round)
1223     }
1224     
1225     /**
1226      * @dev average ico phase key price is total eth put in, during ICO phase, 
1227      * divided by the number of keys that were bought with that eth.
1228      * -functionhash- 0xdcb6af48
1229      * @return average key price 
1230      */
1231     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1232         public 
1233         view 
1234         returns(uint256)
1235     {
1236         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1237     }
1238     
1239     /**
1240      * @dev at end of ICO phase, each player is entitled to X keys based on final 
1241      * average ICO phase key price, and the amount of eth they put in during ICO.
1242      * if a player participates in the round post ICO, these will be "claimed" and 
1243      * added to their rounds total keys.  if not, this will be used to calculate 
1244      * their gen earnings throughout round and on round end.
1245      * -functionhash- 0x75661f4c
1246      * @return players keys bought during ICO phase 
1247      */
1248     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1249         public 
1250         view
1251         returns(uint256)
1252     {
1253         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1254             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1255         else
1256             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1257     }
1258     
1259     /** 
1260      * @dev returns the amount of keys you would get given an amount of eth. 
1261      * - during live round.  this is accurate. (well... unless someone buys before 
1262      * you do and ups the price!  you better HURRY!)
1263      * - during ICO phase.  this is the max you would get based on current eth 
1264      * invested during ICO phase.  if others invest after you, you will receive
1265      * less.  (so distract them with meme vids till ICO is over)
1266      * -functionhash- 0xce89c80c
1267      * @param _rID round ID you want price for
1268      * @param _eth amount of eth sent in 
1269      * @return keys received 
1270      */
1271     function calcKeysReceived(uint256 _rID, uint256 _eth)
1272         public
1273         view
1274         returns(uint256)
1275     {
1276         // grab time
1277         uint256 _now = now;
1278         
1279         // is ICO phase over??  & theres eth in the round?
1280         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1281             return ( (round_[_rID].eth).keysRec(_eth) );
1282         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1283             return ( (round_[_rID].ico).keysRec(_eth) );
1284         else // rounds over.  need keys for new round
1285             return ( (_eth).keys() );
1286     }
1287     
1288     /** 
1289      * @dev returns current eth price for X keys.  
1290      * - during live round.  this is accurate. (well... unless someone buys before 
1291      * you do and ups the price!  you better HURRY!)
1292      * - during ICO phase.  this is the max you would get based on current eth 
1293      * invested during ICO phase.  if others invest after you, you will receive
1294      * less.  (so distract them with meme vids till ICO is over)
1295      * -functionhash- 0xcf808000
1296      * @param _keys number of keys desired (in 18 decimal format)
1297      * @return amount of eth needed to send
1298      */
1299     function iWantXKeys(uint256 _keys)
1300         public
1301         view
1302         returns(uint256)
1303     {
1304         // setup local rID
1305         uint256 _rID = rID_;
1306         
1307         // grab time
1308         uint256 _now = now;
1309         
1310         // is ICO phase over??  & theres eth in the round?
1311         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1312             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1313         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1314             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1315         else // rounds over.  need price for new round
1316             return ( (_keys).eth() );
1317     }
1318 //==============================================================================
1319 //    _|_ _  _ | _  .
1320 //     | (_)(_)|_\  .
1321 //==============================================================================
1322     /**
1323 	 * @dev receives name/player info from names contract 
1324      */
1325     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1326         external
1327     {
1328         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1329         if (pIDxAddr_[_addr] != _pID)
1330             pIDxAddr_[_addr] = _pID;
1331         if (pIDxName_[_name] != _pID)
1332             pIDxName_[_name] = _pID;
1333         if (plyr_[_pID].addr != _addr)
1334             plyr_[_pID].addr = _addr;
1335         if (plyr_[_pID].name != _name)
1336             plyr_[_pID].name = _name;
1337         if (plyr_[_pID].laff != _laff)
1338             plyr_[_pID].laff = _laff;
1339         if (plyrNames_[_pID][_name] == false)
1340             plyrNames_[_pID][_name] = true;
1341     }
1342 
1343     /**
1344      * @dev receives entire player name list 
1345      */
1346     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1347         external
1348     {
1349         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1350         if(plyrNames_[_pID][_name] == false)
1351             plyrNames_[_pID][_name] = true;
1352     }  
1353         
1354     /**
1355      * @dev gets existing or registers new pID.  use this when a player may be new
1356      * @return pID 
1357      */
1358     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1359         private
1360         returns (F3Ddatasets.EventReturns)
1361     {
1362         uint256 _pID = pIDxAddr_[msg.sender];
1363         // if player is new to this version of fomo3d
1364         if (_pID == 0)
1365         {
1366             // grab their player ID, name and last aff ID, from player names contract 
1367             _pID = PlayerBook.getPlayerID(msg.sender);
1368             bytes32 _name = PlayerBook.getPlayerName(_pID);
1369             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1370             
1371             // set up player account 
1372             pIDxAddr_[msg.sender] = _pID;
1373             plyr_[_pID].addr = msg.sender;
1374             
1375             if (_name != "")
1376             {
1377                 pIDxName_[_name] = _pID;
1378                 plyr_[_pID].name = _name;
1379                 plyrNames_[_pID][_name] = true;
1380             }
1381             
1382             if (_laff != 0 && _laff != _pID)
1383                 plyr_[_pID].laff = _laff;
1384             
1385             // set the new player bool to true
1386             _eventData_.compressedData = _eventData_.compressedData + 1;
1387         } 
1388         return (_eventData_);
1389     }
1390     
1391     /**
1392      * @dev checks to make sure user picked a valid team.  if not sets team 
1393      * to default (sneks)
1394      */
1395     function verifyTeam(uint256 _team)
1396         private
1397         pure
1398         returns (uint256)
1399     {
1400         if (_team < 0 || _team > 3)
1401             return(2);
1402         else
1403             return(_team);
1404     }
1405     
1406     /**
1407      * @dev decides if round end needs to be run & new round started.  and if 
1408      * player unmasked earnings from previously played rounds need to be moved.
1409      */
1410     function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1411         private
1412         returns (F3Ddatasets.EventReturns)
1413     {
1414         // setup local rID
1415         uint256 _rID = rID_;
1416         
1417         // grab time
1418         uint256 _now = now;
1419         
1420         // check to see if round has ended.  we use > instead of >= so that LAST
1421         // second snipe tx can extend the round.
1422         if (_now > round_[_rID].end)
1423         {
1424             // check to see if round end has been run yet.  (distributes pot)
1425             if (round_[_rID].ended == false)
1426             {
1427                 _eventData_ = endRound(_eventData_);
1428                 round_[_rID].ended = true;
1429             }
1430             
1431             // start next round in ICO phase
1432             rID_++;
1433             _rID++;
1434             round_[_rID].strt = _now;
1435             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1436         }
1437         
1438         // is player new to round?
1439         if (plyr_[_pID].lrnd != _rID)
1440         {
1441             // if player has played a previous round, move their unmasked earnings
1442             // from that round to gen vault.
1443             if (plyr_[_pID].lrnd != 0)
1444                 updateGenVault(_pID, plyr_[_pID].lrnd);
1445             
1446             // update player's last round played
1447             plyr_[_pID].lrnd = _rID;
1448             
1449             // set the joined round bool to true
1450             _eventData_.compressedData = _eventData_.compressedData + 10;
1451         }
1452         
1453         return(_eventData_);
1454     }
1455     
1456     /**
1457      * @dev ends the round. manages paying out winner/splitting up pot
1458      */
1459     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1460         private
1461         returns (F3Ddatasets.EventReturns)
1462     {
1463         // setup local rID
1464         uint256 _rID = rID_;
1465         
1466         // check to round ended with ONLY ico phase transactions
1467         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1468             roundClaimICOKeys(_rID);
1469         
1470         // grab our winning player and team id's
1471         uint256 _winPID = round_[_rID].plyr;
1472         uint256 _winTID = round_[_rID].team;
1473         
1474         // grab our pot amount
1475         uint256 _pot = round_[_rID].pot;
1476         
1477         // calculate our winner share, community rewards, gen share, 
1478         // p3d share, and amount reserved for next pot 
1479         uint256 _win = (_pot.mul(48)) / 100;
1480         uint256 _com = (_pot / 50);
1481         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1482         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1483         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1484         
1485         // calculate ppt for round mask
1486         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1487         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1488         if (_dust > 0)
1489         {
1490             _gen = _gen.sub(_dust);
1491             _res = _res.add(_dust);
1492         }
1493         
1494         // pay our winner
1495         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1496         
1497         // community rewards
1498         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1499         {
1500             // This ensures Team Just cannot influence the outcome of FoMo3D with
1501             // bank migrations by breaking outgoing transactions.
1502             // Something we would never do. But that's not the point.
1503             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1504             // highest belief that everything we create should be trustless.
1505             // Team JUST, The name you shouldn't have to trust.
1506             _p3d = _p3d.add(_com);
1507             _com = 0;
1508         }
1509             
1510         // distribute gen portion to key holders
1511         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1512         
1513         // send share for p3d to divies
1514         if (_p3d > 0)
1515             Divies.deposit.value(_p3d)();
1516             
1517         // fill next round pot with its share
1518         round_[_rID + 1].pot += _res;
1519         
1520         // prepare event data
1521         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1522         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1523         _eventData_.winnerAddr = plyr_[_winPID].addr;
1524         _eventData_.winnerName = plyr_[_winPID].name;
1525         _eventData_.amountWon = _win;
1526         _eventData_.genAmount = _gen;
1527         _eventData_.P3DAmount = _p3d;
1528         _eventData_.newPot = _res;
1529         
1530         return(_eventData_);
1531     }
1532     
1533     /**
1534      * @dev takes keys bought during ICO phase, and adds them to round.  pays 
1535      * out gen rewards that accumulated during ICO phase 
1536      */
1537     function roundClaimICOKeys(uint256 _rID)
1538         private
1539     {
1540         // update round eth to account for ICO phase eth investment 
1541         round_[_rID].eth = round_[_rID].ico;
1542                 
1543         // add keys to round that were bought during ICO phase
1544         round_[_rID].keys = (round_[_rID].ico).keys();
1545         
1546         // store average ICO key price 
1547         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1548                 
1549         // set round mask from ICO phase
1550         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1551         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1552         if (_dust > 0)
1553             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1554                 
1555         // distribute gen portion to key holders
1556         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1557     }
1558     
1559     /**
1560      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1561      */
1562     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1563         private 
1564     {
1565         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1566         if (_earnings > 0)
1567         {
1568             // put in gen vault
1569             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1570             // zero out their earnings by updating mask
1571             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1572         }
1573     }
1574     
1575     /**
1576      * @dev updates round timer based on number of whole keys bought.
1577      */
1578     function updateTimer(uint256 _keys, uint256 _rID)
1579         private
1580     {
1581         // calculate time based on number of keys bought
1582         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1583         
1584         // grab time
1585         uint256 _now = now;
1586         
1587         // compare to max and set new end time
1588         if (_newTime < (rndMax_).add(_now))
1589             round_[_rID].end = _newTime;
1590         else
1591             round_[_rID].end = rndMax_.add(_now);
1592     }
1593     
1594     /**
1595      * @dev generates a random number between 0-99 and checks to see if thats
1596      * resulted in an airdrop win
1597      * @return do we have a winner?
1598      */
1599     function airdrop()
1600         private 
1601         view 
1602         returns(bool)
1603     {
1604         uint256 seed = uint256(keccak256(abi.encodePacked(
1605             
1606             (block.timestamp).add
1607             (block.difficulty).add
1608             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1609             (block.gaslimit).add
1610             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1611             (block.number)
1612             
1613         )));
1614         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1615             return(true);
1616         else
1617             return(false);
1618     }
1619 
1620     /**
1621      * @dev distributes eth based on fees to com, aff, and p3d
1622      */
1623     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1624         private
1625         returns(F3Ddatasets.EventReturns)
1626     {
1627         // pay 2% out to community rewards
1628         uint256 _com = _eth / 50;
1629         uint256 _p3d;
1630         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1631         {
1632             // This ensures Team Just cannot influence the outcome of FoMo3D with
1633             // bank migrations by breaking outgoing transactions.
1634             // Something we would never do. But that's not the point.
1635             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1636             // highest belief that everything we create should be trustless.
1637             // Team JUST, The name you shouldn't have to trust.
1638             _p3d = _com;
1639             _com = 0;
1640         }
1641         
1642         // pay 1% out to FoMo3D long
1643         uint256 _long = _eth / 100;
1644         round_[_rID + 1].pot += _long;
1645         
1646         // distribute share to affiliate
1647         uint256 _aff = _eth / 10;
1648         
1649         // decide what to do with affiliate share of fees
1650         // affiliate must not be self, and must have a name registered
1651         if (_affID != _pID && plyr_[_affID].name != '') {
1652             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1653             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1654         } else {
1655             _p3d = _aff;
1656         }
1657         
1658         // pay out p3d
1659         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1660         if (_p3d > 0)
1661         {
1662             // deposit to divies contract
1663             Divies.deposit.value(_p3d)();
1664             
1665             // set up event data
1666             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1667         }
1668         
1669         return(_eventData_);
1670     }
1671     
1672     function potSwap()
1673         external
1674         payable
1675     {
1676         // setup local rID
1677         uint256 _rID = rID_ + 1;
1678         
1679         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1680         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1681     }
1682     
1683     /**
1684      * @dev distributes eth based on fees to gen and pot
1685      */
1686     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1687         private
1688         returns(F3Ddatasets.EventReturns)
1689     {
1690         // calculate gen share
1691         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1692         
1693         // toss 1% into airdrop pot 
1694         uint256 _air = (_eth / 100);
1695         airDropPot_ = airDropPot_.add(_air);
1696         
1697         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1698         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1699         
1700         // calculate pot 
1701         uint256 _pot = _eth.sub(_gen);
1702         
1703         // distribute gen share (thats what updateMasks() does) and adjust
1704         // balances for dust.
1705         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1706         if (_dust > 0)
1707             _gen = _gen.sub(_dust);
1708         
1709         // add eth to pot
1710         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1711         
1712         // set up event data
1713         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1714         _eventData_.potAmount = _pot;
1715         
1716         return(_eventData_);
1717     }
1718 
1719     /**
1720      * @dev updates masks for round and player when keys are bought
1721      * @return dust left over 
1722      */
1723     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1724         private
1725         returns(uint256)
1726     {
1727         /* MASKING NOTES
1728             earnings masks are a tricky thing for people to wrap their minds around.
1729             the basic thing to understand here.  is were going to have a global
1730             tracker based on profit per share for each round, that increases in
1731             relevant proportion to the increase in share supply.
1732             
1733             the player will have an additional mask that basically says "based
1734             on the rounds mask, my shares, and how much i've already withdrawn,
1735             how much is still owed to me?"
1736         */
1737         
1738         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1739         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1740         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1741             
1742         // calculate player earning from their own buy (only based on the keys
1743         // they just bought).  & update player earnings mask
1744         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1745         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1746         
1747         // calculate & return dust
1748         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1749     }
1750     
1751     /**
1752      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1753      * @return earnings in wei format
1754      */
1755     function withdrawEarnings(uint256 _pID)
1756         private
1757         returns(uint256)
1758     {
1759         // update gen vault
1760         updateGenVault(_pID, plyr_[_pID].lrnd);
1761         
1762         // from vaults 
1763         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1764         if (_earnings > 0)
1765         {
1766             plyr_[_pID].win = 0;
1767             plyr_[_pID].gen = 0;
1768             plyr_[_pID].aff = 0;
1769         }
1770 
1771         return(_earnings);
1772     }
1773     
1774     /**
1775      * @dev prepares compression data and fires event for buy or reload tx's
1776      */
1777     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1778         private
1779     {
1780         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1781         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1782         
1783         emit F3Devents.onEndTx
1784         (
1785             _eventData_.compressedData,
1786             _eventData_.compressedIDs,
1787             plyr_[_pID].name,
1788             msg.sender,
1789             _eth,
1790             _keys,
1791             _eventData_.winnerAddr,
1792             _eventData_.winnerName,
1793             _eventData_.amountWon,
1794             _eventData_.newPot,
1795             _eventData_.P3DAmount,
1796             _eventData_.genAmount,
1797             _eventData_.potAmount,
1798             airDropPot_
1799         );
1800     }
1801 //==============================================================================
1802 //    (~ _  _    _._|_    .
1803 //    _)(/_(_|_|| | | \/  .
1804 //====================/=========================================================
1805     /** upon contract deploy, it will be deactivated.  this is a one time
1806      * use function that will activate the contract.  we do this so devs 
1807      * have time to set things up on the web end                            **/
1808     bool public activated_ = false;
1809     function activate()
1810         public
1811     {
1812         // only team just can activate 
1813         require(
1814             msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1815             msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1816             msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1817             msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1818 			msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1819             "only team just can activate"
1820         );
1821 
1822         // can only be ran once
1823         require(activated_ == false, "fomo3d already activated");
1824         
1825         // activate the contract 
1826         activated_ = true;
1827         
1828         // lets start first round in ICO phase
1829 		rID_ = 1;
1830         round_[1].strt = now;
1831         round_[1].end = now + rndInit_ + rndGap_;
1832     }
1833 }
1834 
1835 
1836 //==============================================================================
1837 //   __|_ _    __|_ _  .
1838 //  _\ | | |_|(_ | _\  .
1839 //==============================================================================
1840 library F3Ddatasets {
1841     //compressedData key
1842     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1843         // 0 - new player (bool)
1844         // 1 - joined round (bool)
1845         // 2 - new  leader (bool)
1846         // 3-5 - air drop tracker (uint 0-999)
1847         // 6-16 - round end time
1848         // 17 - winnerTeam
1849         // 18 - 28 timestamp 
1850         // 29 - team
1851         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1852         // 31 - airdrop happened bool
1853         // 32 - airdrop tier 
1854         // 33 - airdrop amount won
1855     //compressedIDs key
1856     // [77-52][51-26][25-0]
1857         // 0-25 - pID 
1858         // 26-51 - winPID
1859         // 52-77 - rID
1860     struct EventReturns {
1861         uint256 compressedData;
1862         uint256 compressedIDs;
1863         address winnerAddr;         // winner address
1864         bytes32 winnerName;         // winner name
1865         uint256 amountWon;          // amount won
1866         uint256 newPot;             // amount in new pot
1867         uint256 P3DAmount;          // amount distributed to p3d
1868         uint256 genAmount;          // amount distributed to gen
1869         uint256 potAmount;          // amount added to pot
1870     }
1871     struct Player {
1872         address addr;   // player address
1873         bytes32 name;   // player name
1874         uint256 win;    // winnings vault
1875         uint256 gen;    // general vault
1876         uint256 aff;    // affiliate vault
1877         uint256 lrnd;   // last round played
1878         uint256 laff;   // last affiliate id used
1879     }
1880     struct PlayerRounds {
1881         uint256 eth;    // eth player has added to round (used for eth limiter)
1882         uint256 keys;   // keys
1883         uint256 mask;   // player mask 
1884         uint256 ico;    // ICO phase investment
1885     }
1886     struct Round {
1887         uint256 plyr;   // pID of player in lead
1888         uint256 team;   // tID of team in lead
1889         uint256 end;    // time ends/ended
1890         bool ended;     // has round end function been ran
1891         uint256 strt;   // time round started
1892         uint256 keys;   // keys
1893         uint256 eth;    // total eth in
1894         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1895         uint256 mask;   // global mask
1896         uint256 ico;    // total eth sent in during ICO phase
1897         uint256 icoGen; // total eth for gen during ICO phase
1898         uint256 icoAvg; // average key price for ICO phase
1899     }
1900     struct TeamFee {
1901         uint256 gen;    // % of buy in thats paid to key holders of current round
1902         uint256 p3d;    // % of buy in thats paid to p3d holders
1903     }
1904     struct PotSplit {
1905         uint256 gen;    // % of pot thats paid to key holders of current round
1906         uint256 p3d;    // % of pot thats paid to p3d holders
1907     }
1908 }
1909 
1910 //==============================================================================
1911 //  |  _      _ _ | _  .
1912 //  |<(/_\/  (_(_||(_  .
1913 //=======/======================================================================
1914 library F3DKeysCalcFast {
1915     using SafeMath for *;
1916     
1917     /**
1918      * @dev calculates number of keys received given X eth 
1919      * @param _curEth current amount of eth in contract 
1920      * @param _newEth eth being spent
1921      * @return amount of ticket purchased
1922      */
1923     function keysRec(uint256 _curEth, uint256 _newEth)
1924         internal
1925         pure
1926         returns (uint256)
1927     {
1928         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1929     }
1930     
1931     /**
1932      * @dev calculates amount of eth received if you sold X keys 
1933      * @param _curKeys current amount of keys that exist 
1934      * @param _sellKeys amount of keys you wish to sell
1935      * @return amount of eth received
1936      */
1937     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1938         internal
1939         pure
1940         returns (uint256)
1941     {
1942         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1943     }
1944 
1945     /**
1946      * @dev calculates how many keys would exist with given an amount of eth
1947      * @param _eth eth "in contract"
1948      * @return number of keys that would exist
1949      */
1950     function keys(uint256 _eth) 
1951         internal
1952         pure
1953         returns(uint256)
1954     {
1955         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1956     }
1957     
1958     /**
1959      * @dev calculates how much eth would be in contract given a number of keys
1960      * @param _keys number of keys "in contract" 
1961      * @return eth that would exists
1962      */
1963     function eth(uint256 _keys) 
1964         internal
1965         pure
1966         returns(uint256)  
1967     {
1968         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1969     }
1970 }
1971 
1972 //==============================================================================
1973 //  . _ _|_ _  _ |` _  _ _  _  .
1974 //  || | | (/_| ~|~(_|(_(/__\  .
1975 //==============================================================================
1976 interface DiviesInterface {
1977     function deposit() external payable;
1978 }
1979 
1980 interface JIincForwarderInterface {
1981     function deposit() external payable returns(bool);
1982     function status() external view returns(address, address, bool);
1983     function startMigration(address _newCorpBank) external returns(bool);
1984     function cancelMigration() external returns(bool);
1985     function finishMigration() external returns(bool);
1986     function setup(address _firstCorpBank) external;
1987 }
1988 
1989 interface PlayerBookInterface {
1990     function getPlayerID(address _addr) external returns (uint256);
1991     function getPlayerName(uint256 _pID) external view returns (bytes32);
1992     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1993     function getPlayerAddr(uint256 _pID) external view returns (address);
1994     function getNameFee() external view returns (uint256);
1995     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1996     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1997     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1998 }
1999 
2000 /**
2001 * @title -Name Filter- v0.1.9
2002 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
2003 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
2004 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
2005 *                                  _____                      _____
2006 *                                 (, /     /)       /) /)    (, /      /)          /)
2007 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
2008 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
2009 *          ┴ ┴                /   /          .-/ _____   (__ /                               
2010 *                            (__ /          (_/ (, /                                      /)™ 
2011 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
2012 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
2013 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
2014 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
2015 *              _       __    _      ____      ____  _   _    _____  ____  ___  
2016 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
2017 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
2018 *
2019 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
2020 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
2021 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
2022 */
2023 
2024 library NameFilter {
2025     
2026     /**
2027      * @dev filters name strings
2028      * -converts uppercase to lower case.  
2029      * -makes sure it does not start/end with a space
2030      * -makes sure it does not contain multiple spaces in a row
2031      * -cannot be only numbers
2032      * -cannot start with 0x 
2033      * -restricts characters to A-Z, a-z, 0-9, and space.
2034      * @return reprocessed string in bytes32 format
2035      */
2036     function nameFilter(string _input)
2037         internal
2038         pure
2039         returns(bytes32)
2040     {
2041         bytes memory _temp = bytes(_input);
2042         uint256 _length = _temp.length;
2043         
2044         //sorry limited to 32 characters
2045         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
2046         // make sure it doesnt start with or end with space
2047         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
2048         // make sure first two characters are not 0x
2049         if (_temp[0] == 0x30)
2050         {
2051             require(_temp[1] != 0x78, "string cannot start with 0x");
2052             require(_temp[1] != 0x58, "string cannot start with 0X");
2053         }
2054         
2055         // create a bool to track if we have a non number character
2056         bool _hasNonNumber;
2057         
2058         // convert & check
2059         for (uint256 i = 0; i < _length; i++)
2060         {
2061             // if its uppercase A-Z
2062             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2063             {
2064                 // convert to lower case a-z
2065                 _temp[i] = byte(uint(_temp[i]) + 32);
2066                 
2067                 // we have a non number
2068                 if (_hasNonNumber == false)
2069                     _hasNonNumber = true;
2070             } else {
2071                 require
2072                 (
2073                     // require character is a space
2074                     _temp[i] == 0x20 || 
2075                     // OR lowercase a-z
2076                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2077                     // or 0-9
2078                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2079                     "string contains invalid characters"
2080                 );
2081                 // make sure theres not 2x spaces in a row
2082                 if (_temp[i] == 0x20)
2083                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2084                 
2085                 // see if we have a character other than a number
2086                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2087                     _hasNonNumber = true;    
2088             }
2089         }
2090         
2091         require(_hasNonNumber == true, "string cannot be only numbers");
2092         
2093         bytes32 _ret;
2094         assembly {
2095             _ret := mload(add(_temp, 32))
2096         }
2097         return (_ret);
2098     }
2099 }
2100 
2101 /**
2102  * @title SafeMath v0.1.9
2103  * @dev Math operations with safety checks that throw on error
2104  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2105  * - added sqrt
2106  * - added sq
2107  * - added pwr 
2108  * - changed asserts to requires with error log outputs
2109  * - removed div, its useless
2110  */
2111 library SafeMath {
2112     
2113     /**
2114     * @dev Multiplies two numbers, throws on overflow.
2115     */
2116     function mul(uint256 a, uint256 b) 
2117         internal 
2118         pure 
2119         returns (uint256 c) 
2120     {
2121         if (a == 0) {
2122             return 0;
2123         }
2124         c = a * b;
2125         require(c / a == b, "SafeMath mul failed");
2126         return c;
2127     }
2128 
2129     /**
2130     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2131     */
2132     function sub(uint256 a, uint256 b)
2133         internal
2134         pure
2135         returns (uint256) 
2136     {
2137         require(b <= a, "SafeMath sub failed");
2138         return a - b;
2139     }
2140 
2141     /**
2142     * @dev Adds two numbers, throws on overflow.
2143     */
2144     function add(uint256 a, uint256 b)
2145         internal
2146         pure
2147         returns (uint256 c) 
2148     {
2149         c = a + b;
2150         require(c >= a, "SafeMath add failed");
2151         return c;
2152     }
2153     
2154     /**
2155      * @dev gives square root of given x.
2156      */
2157     function sqrt(uint256 x)
2158         internal
2159         pure
2160         returns (uint256 y) 
2161     {
2162         uint256 z = ((add(x,1)) / 2);
2163         y = x;
2164         while (z < y) 
2165         {
2166             y = z;
2167             z = ((add((x / z),z)) / 2);
2168         }
2169     }
2170     
2171     /**
2172      * @dev gives square. multiplies x by x
2173      */
2174     function sq(uint256 x)
2175         internal
2176         pure
2177         returns (uint256)
2178     {
2179         return (mul(x,x));
2180     }
2181     
2182     /**
2183      * @dev x to the power of y 
2184      */
2185     function pwr(uint256 x, uint256 y)
2186         internal 
2187         pure 
2188         returns (uint256)
2189     {
2190         if (x==0)
2191             return (0);
2192         else if (y==0)
2193             return (1);
2194         else 
2195         {
2196             uint256 z = x;
2197             for (uint256 i=1; i < y; i++)
2198                 z = mul(z,x);
2199             return (z);
2200         }
2201     }
2202 }