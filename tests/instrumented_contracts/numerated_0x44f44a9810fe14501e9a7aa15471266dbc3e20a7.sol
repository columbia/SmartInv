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
179 	// DiviesInterface constant private Divies = DiviesInterface(0xC0c001140319C5f114F8467295b1F22F86929Ad0);
180 	DiviesInterface constant private Divies = DiviesInterface(0x10Adfd14161c880923acA3E94043E74b4665DfE5);
181     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
182     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x1f5654082761182b50460c0E8945324aC7c62D1d);
183 	// PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
184 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xc4AD45a8808d577D8B08Ca5E4dD6939964EB645f);
185 //==============================================================================
186 //     _ _  _  |`. _     _ _ |_ | _  _  .
187 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
188 //=================_|===========================================================
189     string constant public name = "FoMo3D Soon(tm) Edition";
190     string constant public symbol = "F3D";
191 	uint256 private rndGap_ = 60 seconds;                       // length of ICO phase, set to 1 year for EOS.
192     uint256 constant private rndInit_ = 5 minutes;              // round timer starts at this
193     uint256 constant private rndInc_ = 5 minutes;               // every full key purchased adds this much to the timer
194     uint256 constant private rndMax_ = 5 minutes;               // max length a round timer can be
195 //==============================================================================
196 //     _| _ _|_ _    _ _ _|_    _   .
197 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
198 //=============================|================================================
199 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
200     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
201     uint256 public rID_;    // round id number / total rounds that have happened
202 //****************
203 // PLAYER DATA 
204 //****************
205     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
206     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
207     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
208     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
209     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
210 //****************
211 // ROUND DATA 
212 //****************
213     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
214     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
215 //****************
216 // TEAM FEE DATA 
217 //****************
218     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
219     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
220 //==============================================================================
221 //     _ _  _  __|_ _    __|_ _  _  .
222 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
223 //==============================================================================
224     constructor()
225         public
226     {
227 		// Team allocation structures
228         // 0 = whales
229         // 1 = bears
230         // 2 = sneks
231         // 3 = bulls
232 
233 		// Team allocation percentages
234         // (F3D, P3D) + (Pot , Referrals, Community)
235             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
236         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
237         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
238         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
239         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
240         
241         // how to split up the final pot based on which team was picked
242         // (F3D, P3D)
243         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
244         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
245         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
246         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
247 	}
248 //==============================================================================
249 //     _ _  _  _|. |`. _  _ _  .
250 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
251 //==============================================================================
252     /**
253      * @dev used to make sure no one can interact with contract until it has 
254      * been activated. 
255      */
256     modifier isActivated() {
257         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
258         _;
259     }
260     
261     /**
262      * @dev prevents contracts from interacting with fomo3d 
263      */
264     modifier isHuman() {
265         address _addr = msg.sender;
266         require (_addr == tx.origin);
267         
268         uint256 _codeLength;
269         
270         assembly {_codeLength := extcodesize(_addr)}
271         require(_codeLength == 0, "sorry humans only");
272         _;
273     }
274 
275     /**
276      * @dev sets boundaries for incoming tx 
277      */
278     modifier isWithinLimits(uint256 _eth) {
279         require(_eth >= 1000000000, "pocket lint: not a valid currency");
280         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** NOTE THIS NEEDS TO BE CHECKED **/
281 		_;    
282 	}
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
644      * @param _affCode affiliate ID, address, or name of who referred you
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
701      * - during live round.  this is accurate. (well... unless someone buys before 
702      * you do and ups the price!  you better HURRY!)
703      * - during ICO phase.  this is the max you would get based on current eth 
704      * invested during ICO phase.  if others invest after you, you will receive
705      * less.  (so distract them with meme vids till ICO is over)
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
720         // is ICO phase over??  & theres eth in the round?
721         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
722             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
723         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
724             return ( ((round_[_rID].ico.keys()).add(1000000000000000000)).ethRec(1000000000000000000) );
725         else // rounds over.  need price for new round
726             return ( 100000000000000 ); // init
727     }
728     
729     /**
730      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
731      * provider
732      * -functionhash- 0xc7e284b8
733      * @return time left in seconds
734      */
735     function getTimeLeft()
736         public
737         view
738         returns(uint256)
739     {
740         // setup local rID 
741         uint256 _rID = rID_;
742         
743         // grab time
744         uint256 _now = now;
745         
746         // are we in ICO phase?
747         if (_now <= round_[_rID].strt + rndGap_)
748             return( ((round_[_rID].end).sub(rndInit_)).sub(_now) );
749         else 
750             if (_now < round_[_rID].end)
751                 return( (round_[_rID].end).sub(_now) );
752             else
753                 return(0);
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
772         if (now > round_[_rID].end && round_[_rID].ended == false)
773         {
774             uint256 _roundMask;
775             uint256 _roundEth;
776             uint256 _roundKeys;
777             uint256 _roundPot;
778             if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
779             {
780                 // create a temp round eth based on eth sent in during ICO phase
781                 _roundEth = round_[_rID].ico;
782                 
783                 // create a temp round keys based on keys bought during ICO phase
784                 _roundKeys = (round_[_rID].ico).keys();
785                 
786                 // create a temp round mask based on eth and keys from ICO phase
787                 _roundMask = ((round_[_rID].icoGen).mul(1000000000000000000)) / _roundKeys;
788                 
789                 // create a temp rount pot based on pot, and dust from mask
790                 _roundPot = (round_[_rID].pot).add((round_[_rID].icoGen).sub((_roundMask.mul(_roundKeys)) / (1000000000000000000)));
791             } else {
792                 _roundEth = round_[_rID].eth;
793                 _roundKeys = round_[_rID].keys;
794                 _roundMask = round_[_rID].mask;
795                 _roundPot = round_[_rID].pot;
796             }
797             
798             uint256 _playerKeys;
799             if (plyrRnds_[_pID][plyr_[_pID].lrnd].ico == 0)
800                 _playerKeys = plyrRnds_[_pID][plyr_[_pID].lrnd].keys;
801             else
802                 _playerKeys = calcPlayerICOPhaseKeys(_pID, _rID);
803             
804             // if player is winner 
805             if (round_[_rID].plyr == _pID)
806             {
807                 return
808                 (
809                     (plyr_[_pID].win).add( (_roundPot.mul(48)) / 100 ),
810                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
811                     plyr_[_pID].aff
812                 );
813             // if player is not the winner
814             } else {
815                 return
816                 (
817                     plyr_[_pID].win,   
818                     (plyr_[_pID].gen).add( getPlayerVaultsHelper(_pID, _roundMask, _roundPot, _roundKeys, _playerKeys) ),
819                     plyr_[_pID].aff
820                 );
821             }
822             
823         // if round is still going on, we are in ico phase, or round has ended and round end has been ran
824         } else {
825             return
826             (
827                 plyr_[_pID].win,
828                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
829                 plyr_[_pID].aff
830             );
831         }
832     }
833     
834     /**
835      * solidity hates stack limits.  this lets us avoid that hate 
836      */
837     function getPlayerVaultsHelper(uint256 _pID, uint256 _roundMask, uint256 _roundPot, uint256 _roundKeys, uint256 _playerKeys)
838         private
839         view
840         returns(uint256)
841     {
842         return(  (((_roundMask.add((((_roundPot.mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000)) / _roundKeys)).mul(_playerKeys)) / 1000000000000000000).sub(plyrRnds_[_pID][rID_].mask)  );
843     }
844     
845     /**
846      * @dev returns all current round info needed for front end
847      * -functionhash- 0x747dff42
848      * @return eth invested during ICO phase
849      * @return round id 
850      * @return total keys for round 
851      * @return time round ends
852      * @return time round started
853      * @return current pot 
854      * @return current team ID & player ID in lead 
855      * @return current player in leads address 
856      * @return current player in leads name
857      * @return whales eth in for round
858      * @return bears eth in for round
859      * @return sneks eth in for round
860      * @return bulls eth in for round
861      * @return airdrop tracker # & airdrop pot
862      */
863     function getCurrentRoundInfo()
864         public
865         view
866         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
867     {
868         // setup local rID
869         uint256 _rID = rID_;
870         
871         if (round_[_rID].eth != 0)
872         {
873             return
874             (
875                 round_[_rID].ico,               //0
876                 _rID,                           //1
877                 round_[_rID].keys,              //2
878                 round_[_rID].end,               //3
879                 round_[_rID].strt,              //4
880                 round_[_rID].pot,               //5
881                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
882                 plyr_[round_[_rID].plyr].addr,  //7
883                 plyr_[round_[_rID].plyr].name,  //8
884                 rndTmEth_[_rID][0],             //9
885                 rndTmEth_[_rID][1],             //10
886                 rndTmEth_[_rID][2],             //11
887                 rndTmEth_[_rID][3],             //12
888                 airDropTracker_ + (airDropPot_ * 1000)              //13
889             );
890         } else {
891             return
892             (
893                 round_[_rID].ico,               //0
894                 _rID,                           //1
895                 (round_[_rID].ico).keys(),      //2
896                 round_[_rID].end,               //3
897                 round_[_rID].strt,              //4
898                 round_[_rID].pot,               //5
899                 (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
900                 plyr_[round_[_rID].plyr].addr,  //7
901                 plyr_[round_[_rID].plyr].name,  //8
902                 rndTmEth_[_rID][0],             //9
903                 rndTmEth_[_rID][1],             //10
904                 rndTmEth_[_rID][2],             //11
905                 rndTmEth_[_rID][3],             //12
906                 airDropTracker_ + (airDropPot_ * 1000)              //13
907             );
908         }
909     }
910 
911     /**
912      * @dev returns player info based on address.  if no address is given, it will 
913      * use msg.sender 
914      * -functionhash- 0xee0b5d8b
915      * @param _addr address of the player you want to lookup 
916      * @return player ID 
917      * @return player name
918      * @return keys owned (current round)
919      * @return winnings vault
920      * @return general vault 
921      * @return affiliate vault 
922 	 * @return player ico eth
923      */
924     function getPlayerInfoByAddress(address _addr)
925         public 
926         view 
927         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
928     {
929         // setup local rID
930         uint256 _rID = rID_;
931         
932         if (_addr == address(0))
933         {
934             _addr == msg.sender;
935         }
936         uint256 _pID = pIDxAddr_[_addr];
937         
938         if (plyrRnds_[_pID][_rID].ico == 0)
939         {
940             return
941             (
942                 _pID,                               //0
943                 plyr_[_pID].name,                   //1
944                 plyrRnds_[_pID][_rID].keys,         //2
945                 plyr_[_pID].win,                    //3
946                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
947                 plyr_[_pID].aff,                    //5
948 				0						            //6
949             );
950         } else {
951             return
952             (
953                 _pID,                               //0
954                 plyr_[_pID].name,                   //1
955                 calcPlayerICOPhaseKeys(_pID, _rID), //2
956                 plyr_[_pID].win,                    //3
957                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
958                 plyr_[_pID].aff,                    //5
959 				plyrRnds_[_pID][_rID].ico           //6
960             );
961         }
962         
963     }
964 
965 //==============================================================================
966 //     _ _  _ _   | _  _ . _  .
967 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
968 //=====================_|=======================================================
969     /**
970      * @dev logic runs whenever a buy order is executed.  determines how to handle 
971      * incoming eth depending on if we are in ICO phase or not 
972      */
973     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
974         private
975     {
976         // check to see if round has ended.  and if player is new to round
977         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
978         
979         // are we in ICO phase?
980         if (now <= round_[rID_].strt + rndGap_) 
981         {
982             // let event data know this is a ICO phase buy order
983             _eventData_.compressedData = _eventData_.compressedData + 2000000000000000000000000000000;
984         
985             // ICO phase core
986             icoPhaseCore(_pID, msg.value, _team, _affID, _eventData_);
987         
988         
989         // round is live
990         } else {
991              // let event data know this is a buy order
992             _eventData_.compressedData = _eventData_.compressedData + 1000000000000000000000000000000;
993         
994             // call core
995             core(_pID, msg.value, _affID, _team, _eventData_);
996         }
997     }
998 
999     /**
1000      * @dev logic runs whenever a reload order is executed.  determines how to handle 
1001      * incoming eth depending on if we are in ICO phase or not 
1002      */
1003     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
1004         private 
1005     {
1006         // check to see if round has ended.  and if player is new to round
1007         _eventData_ = manageRoundAndPlayer(_pID, _eventData_);
1008         
1009         // get earnings from all vaults and return unused to gen vault
1010         // because we use a custom safemath library.  this will throw if player 
1011         // tried to spend more eth than they have.
1012         plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
1013                 
1014         // are we in ICO phase?
1015         if (now <= round_[rID_].strt + rndGap_) 
1016         {
1017             // let event data know this is an ICO phase reload 
1018             _eventData_.compressedData = _eventData_.compressedData + 3000000000000000000000000000000;
1019                 
1020             // ICO phase core
1021             icoPhaseCore(_pID, _eth, _team, _affID, _eventData_);
1022 
1023 
1024         // round is live
1025         } else {
1026             // call core
1027             core(_pID, _eth, _affID, _team, _eventData_);
1028         }
1029     }    
1030     
1031     /**
1032      * @dev during ICO phase all eth sent in by each player.  will be added to an 
1033      * "investment pool".  upon end of ICO phase, all eth will be used to buy keys.
1034      * each player receives an amount based on how much they put in, and the 
1035      * the average price attained.
1036      */
1037     function icoPhaseCore(uint256 _pID, uint256 _eth, uint256 _team, uint256 _affID, F3Ddatasets.EventReturns memory _eventData_)
1038         private
1039     {
1040         // setup local rID
1041         uint256 _rID = rID_;
1042         
1043         // if they bought at least 1 whole key (at time of purchase)
1044         if ((round_[_rID].ico).keysRec(_eth) >= 1000000000000000000 || round_[_rID].plyr == 0)
1045         {
1046             // set new leaders
1047             if (round_[_rID].plyr != _pID)
1048                 round_[_rID].plyr = _pID;  
1049             if (round_[_rID].team != _team)
1050                 round_[_rID].team = _team;
1051             
1052             // set the new leader bool to true
1053             _eventData_.compressedData = _eventData_.compressedData + 100;
1054         }
1055         
1056         // add eth to our players & rounds ICO phase investment. this will be used 
1057         // to determine total keys and each players share 
1058         plyrRnds_[_pID][_rID].ico = _eth.add(plyrRnds_[_pID][_rID].ico);
1059         round_[_rID].ico = _eth.add(round_[_rID].ico);
1060         
1061         // add eth in to team eth tracker
1062         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1063         
1064         // send eth share to com, p3d, affiliate, and fomo3d long
1065         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1066         
1067         // calculate gen share 
1068         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1069         
1070         // add gen share to rounds ICO phase gen tracker (will be distributed 
1071         // when round starts)
1072         round_[_rID].icoGen = _gen.add(round_[_rID].icoGen);
1073         
1074 		// toss 1% into airdrop pot 
1075         uint256 _air = (_eth / 100);
1076         airDropPot_ = airDropPot_.add(_air);
1077         
1078         // calculate pot share pot (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share)) - gen
1079         uint256 _pot = (_eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100))).sub(_gen);
1080         
1081         // add eth to pot
1082         round_[_rID].pot = _pot.add(round_[_rID].pot);
1083         
1084         // set up event data
1085         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1086         _eventData_.potAmount = _pot;
1087         
1088         // fire event
1089         endTx(_rID, _pID, _team, _eth, 0, _eventData_);
1090     }
1091     
1092     /**
1093      * @dev this is the core logic for any buy/reload that happens while a round 
1094      * is live.
1095      */
1096     function core(uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1097         private
1098     {
1099         // setup local rID
1100         uint256 _rID = rID_;
1101         
1102         // check to see if its a new round (past ICO phase) && keys were bought in ICO phase
1103         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1104             roundClaimICOKeys(_rID);
1105         
1106         // if player is new to round and is owed keys from ICO phase 
1107         if (plyrRnds_[_pID][_rID].keys == 0 && plyrRnds_[_pID][_rID].ico > 0)
1108         {
1109             // assign player their keys from ICO phase
1110             plyrRnds_[_pID][_rID].keys = calcPlayerICOPhaseKeys(_pID, _rID);
1111             // zero out ICO phase investment
1112             plyrRnds_[_pID][_rID].ico = 0;
1113         }
1114             
1115         // mint the new keys
1116         uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1117         
1118         // if they bought at least 1 whole key
1119         if (_keys >= 1000000000000000000)
1120         {
1121             updateTimer(_keys, _rID);
1122 
1123             // set new leaders
1124             if (round_[_rID].plyr != _pID)
1125                 round_[_rID].plyr = _pID;  
1126             if (round_[_rID].team != _team)
1127                 round_[_rID].team = _team; 
1128             
1129             // set the new leader bool to true
1130             _eventData_.compressedData = _eventData_.compressedData + 100;
1131         }
1132         
1133         // manage airdrops
1134         if (_eth >= 100000000000000000)
1135         {
1136             airDropTracker_++;
1137             if (airdrop() == true)
1138             {
1139                 // gib muni
1140                 uint256 _prize;
1141                 if (_eth >= 10000000000000000000) 
1142                 {
1143                     // calculate prize and give it to winner
1144                     _prize = ((airDropPot_).mul(75)) / 100;
1145                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1146                     
1147                     // adjust airDropPot 
1148                     airDropPot_ = (airDropPot_).sub(_prize);
1149                     
1150                     // let event know a tier 3 prize was won 
1151                     _eventData_.compressedData += 300000000000000000000000000000000;
1152                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1153                     // calculate prize and give it to winner
1154                     _prize = ((airDropPot_).mul(50)) / 100;
1155                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1156                     
1157                     // adjust airDropPot 
1158                     airDropPot_ = (airDropPot_).sub(_prize);
1159                     
1160                     // let event know a tier 2 prize was won 
1161                     _eventData_.compressedData += 200000000000000000000000000000000;
1162                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1163                     // calculate prize and give it to winner
1164                     _prize = ((airDropPot_).mul(25)) / 100;
1165                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1166                     
1167                     // adjust airDropPot 
1168                     airDropPot_ = (airDropPot_).sub(_prize);
1169                     
1170                     // let event know a tier 1 prize was won 
1171                     _eventData_.compressedData += 100000000000000000000000000000000;
1172                 }
1173                 // set airdrop happened bool to true
1174                 _eventData_.compressedData += 10000000000000000000000000000000;
1175                 // let event know how much was won 
1176                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1177                 
1178                 // reset air drop tracker
1179                 airDropTracker_ = 0;
1180             }
1181         }
1182 
1183         // store the air drop tracker number (number of buys since last airdrop)
1184         _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1185         
1186         // update player 
1187         plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1188         
1189         // update round
1190         round_[_rID].keys = _keys.add(round_[_rID].keys);
1191         round_[_rID].eth = _eth.add(round_[_rID].eth);
1192         rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1193 
1194         // distribute eth
1195         _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1196         _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1197         
1198         // call end tx function to fire end tx event.
1199         endTx(_rID, _pID, _team, _eth, _keys, _eventData_);
1200     }
1201 //==============================================================================
1202 //     _ _ | _   | _ _|_ _  _ _  .
1203 //    (_(_||(_|_||(_| | (_)| _\  .
1204 //==============================================================================
1205     /**
1206      * @dev calculates unmasked earnings (just calculates, does not update mask)
1207      * @return earnings in wei format
1208      */
1209     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1210         private
1211         view
1212         returns(uint256)
1213     {
1214         // if player does not have unclaimed keys bought in ICO phase
1215         // return their earnings based on keys held only.
1216         if (plyrRnds_[_pID][_rIDlast].ico == 0)
1217             return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1218         else
1219             if (now > round_[_rIDlast].strt + rndGap_ && round_[_rIDlast].eth == 0)
1220                 return(  (((((round_[_rIDlast].icoGen).mul(1000000000000000000)) / (round_[_rIDlast].ico).keys()).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1221             else
1222                 return(  (((round_[_rIDlast].mask).mul(calcPlayerICOPhaseKeys(_pID, _rIDlast))) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1223         // otherwise return earnings based on keys owed from ICO phase
1224         // (this would be a scenario where they only buy during ICO phase, and never 
1225         // buy/reload during round)
1226     }
1227     
1228     /**
1229      * @dev average ico phase key price is total eth put in, during ICO phase, 
1230      * divided by the number of keys that were bought with that eth.
1231      * -functionhash- 0xdcb6af48
1232      * @return average key price 
1233      */
1234     function calcAverageICOPhaseKeyPrice(uint256 _rID)
1235         public 
1236         view 
1237         returns(uint256)
1238     {
1239         return(  (round_[_rID].ico).mul(1000000000000000000) / (round_[_rID].ico).keys()  );
1240     }
1241     
1242     /**
1243      * @dev at end of ICO phase, each player is entitled to X keys based on final 
1244      * average ICO phase key price, and the amount of eth they put in during ICO.
1245      * if a player participates in the round post ICO, these will be "claimed" and 
1246      * added to their rounds total keys.  if not, this will be used to calculate 
1247      * their gen earnings throughout round and on round end.
1248      * -functionhash- 0x75661f4c
1249      * @return players keys bought during ICO phase 
1250      */
1251     function calcPlayerICOPhaseKeys(uint256 _pID, uint256 _rID)
1252         public 
1253         view
1254         returns(uint256)
1255     {
1256         if (round_[_rID].icoAvg != 0 || round_[_rID].ico == 0 )
1257             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / round_[_rID].icoAvg  );
1258         else
1259             return(  ((plyrRnds_[_pID][_rID].ico).mul(1000000000000000000)) / calcAverageICOPhaseKeyPrice(_rID)  );
1260     }
1261     
1262     /** 
1263      * @dev returns the amount of keys you would get given an amount of eth. 
1264      * - during live round.  this is accurate. (well... unless someone buys before 
1265      * you do and ups the price!  you better HURRY!)
1266      * - during ICO phase.  this is the max you would get based on current eth 
1267      * invested during ICO phase.  if others invest after you, you will receive
1268      * less.  (so distract them with meme vids till ICO is over)
1269      * -functionhash- 0xce89c80c
1270      * @param _rID round ID you want price for
1271      * @param _eth amount of eth sent in 
1272      * @return keys received 
1273      */
1274     function calcKeysReceived(uint256 _rID, uint256 _eth)
1275         public
1276         view
1277         returns(uint256)
1278     {
1279         // grab time
1280         uint256 _now = now;
1281         
1282         // is ICO phase over??  & theres eth in the round?
1283         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1284             return ( (round_[_rID].eth).keysRec(_eth) );
1285         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1286             return ( (round_[_rID].ico).keysRec(_eth) );
1287         else // rounds over.  need keys for new round
1288             return ( (_eth).keys() );
1289     }
1290     
1291     /** 
1292      * @dev returns current eth price for X keys.  
1293      * - during live round.  this is accurate. (well... unless someone buys before 
1294      * you do and ups the price!  you better HURRY!)
1295      * - during ICO phase.  this is the max you would get based on current eth 
1296      * invested during ICO phase.  if others invest after you, you will receive
1297      * less.  (so distract them with meme vids till ICO is over)
1298      * -functionhash- 0xcf808000
1299      * @param _keys number of keys desired (in 18 decimal format)
1300      * @return amount of eth needed to send
1301      */
1302     function iWantXKeys(uint256 _keys)
1303         public
1304         view
1305         returns(uint256)
1306     {
1307         // setup local rID
1308         uint256 _rID = rID_;
1309         
1310         // grab time
1311         uint256 _now = now;
1312         
1313         // is ICO phase over??  & theres eth in the round?
1314         if (_now > round_[_rID].strt + rndGap_ && round_[_rID].eth != 0 && _now <= round_[_rID].end)
1315             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1316         else if (_now <= round_[_rID].end) // round hasn't ended (in ICO phase, or ICO phase is over, but round eth is 0)
1317             return ( (((round_[_rID].ico).keys()).add(_keys)).ethRec(_keys) );
1318         else // rounds over.  need price for new round
1319             return ( (_keys).eth() );
1320     }
1321 //==============================================================================
1322 //    _|_ _  _ | _  .
1323 //     | (_)(_)|_\  .
1324 //==============================================================================
1325     /**
1326 	 * @dev receives name/player info from names contract 
1327      */
1328     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1329         external
1330     {
1331         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1332         if (pIDxAddr_[_addr] != _pID)
1333             pIDxAddr_[_addr] = _pID;
1334         if (pIDxName_[_name] != _pID)
1335             pIDxName_[_name] = _pID;
1336         if (plyr_[_pID].addr != _addr)
1337             plyr_[_pID].addr = _addr;
1338         if (plyr_[_pID].name != _name)
1339             plyr_[_pID].name = _name;
1340         if (plyr_[_pID].laff != _laff)
1341             plyr_[_pID].laff = _laff;
1342         if (plyrNames_[_pID][_name] == false)
1343             plyrNames_[_pID][_name] = true;
1344     }
1345 
1346     /**
1347      * @dev receives entire player name list 
1348      */
1349     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1350         external
1351     {
1352         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1353         if(plyrNames_[_pID][_name] == false)
1354             plyrNames_[_pID][_name] = true;
1355     }  
1356         
1357     /**
1358      * @dev gets existing or registers new pID.  use this when a player may be new
1359      * @return pID 
1360      */
1361     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1362         private
1363         returns (F3Ddatasets.EventReturns)
1364     {
1365         uint256 _pID = pIDxAddr_[msg.sender];
1366         // if player is new to this version of fomo3d
1367         if (_pID == 0)
1368         {
1369             // grab their player ID, name and last aff ID, from player names contract 
1370             _pID = PlayerBook.getPlayerID(msg.sender);
1371             bytes32 _name = PlayerBook.getPlayerName(_pID);
1372             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1373             
1374             // set up player account 
1375             pIDxAddr_[msg.sender] = _pID;
1376             plyr_[_pID].addr = msg.sender;
1377             
1378             if (_name != "")
1379             {
1380                 pIDxName_[_name] = _pID;
1381                 plyr_[_pID].name = _name;
1382                 plyrNames_[_pID][_name] = true;
1383             }
1384             
1385             if (_laff != 0 && _laff != _pID)
1386                 plyr_[_pID].laff = _laff;
1387             
1388             // set the new player bool to true
1389             _eventData_.compressedData = _eventData_.compressedData + 1;
1390         } 
1391         return (_eventData_);
1392     }
1393     
1394     /**
1395      * @dev checks to make sure user picked a valid team.  if not sets team 
1396      * to default (sneks)
1397      */
1398     function verifyTeam(uint256 _team)
1399         private
1400         pure
1401         returns (uint256)
1402     {
1403         if (_team < 0 || _team > 3)
1404             return(2);
1405         else
1406             return(_team);
1407     }
1408     
1409     /**
1410      * @dev decides if round end needs to be run & new round started.  and if 
1411      * player unmasked earnings from previously played rounds need to be moved.
1412      */
1413     function manageRoundAndPlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1414         private
1415         returns (F3Ddatasets.EventReturns)
1416     {
1417         // setup local rID
1418         uint256 _rID = rID_;
1419         
1420         // grab time
1421         uint256 _now = now;
1422         
1423         // check to see if round has ended.  we use > instead of >= so that LAST
1424         // second snipe tx can extend the round.
1425         if (_now > round_[_rID].end)
1426         {
1427             // check to see if round end has been run yet.  (distributes pot)
1428             if (round_[_rID].ended == false)
1429             {
1430                 _eventData_ = endRound(_eventData_);
1431                 round_[_rID].ended = true;
1432             }
1433             
1434             // start next round in ICO phase
1435             rID_++;
1436             _rID++;
1437             round_[_rID].strt = _now;
1438             round_[_rID].end = _now.add(rndInit_).add(rndGap_);
1439         }
1440         
1441         // is player new to round?
1442         if (plyr_[_pID].lrnd != _rID)
1443         {
1444             // if player has played a previous round, move their unmasked earnings
1445             // from that round to gen vault.
1446             if (plyr_[_pID].lrnd != 0)
1447                 updateGenVault(_pID, plyr_[_pID].lrnd);
1448             
1449             // update player's last round played
1450             plyr_[_pID].lrnd = _rID;
1451             
1452             // set the joined round bool to true
1453             _eventData_.compressedData = _eventData_.compressedData + 10;
1454         }
1455         
1456         return(_eventData_);
1457     }
1458     
1459     /**
1460      * @dev ends the round. manages paying out winner/splitting up pot
1461      */
1462     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1463         private
1464         returns (F3Ddatasets.EventReturns)
1465     {
1466         // setup local rID
1467         uint256 _rID = rID_;
1468         
1469         // check to round ended with ONLY ico phase transactions
1470         if (round_[_rID].eth == 0 && round_[_rID].ico > 0)
1471             roundClaimICOKeys(_rID);
1472         
1473         // grab our winning player and team id's
1474         uint256 _winPID = round_[_rID].plyr;
1475         uint256 _winTID = round_[_rID].team;
1476         
1477         // grab our pot amount
1478         uint256 _pot = round_[_rID].pot;
1479         
1480         // calculate our winner share, community rewards, gen share, 
1481         // p3d share, and amount reserved for next pot 
1482         uint256 _win = (_pot.mul(48)) / 100;
1483         uint256 _com = (_pot / 50);
1484         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1485         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1486         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1487         
1488         // calculate ppt for round mask
1489         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1490         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1491         if (_dust > 0)
1492         {
1493             _gen = _gen.sub(_dust);
1494             _res = _res.add(_dust);
1495         }
1496         
1497         // pay our winner
1498         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1499         
1500         // community rewards
1501         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1502         {
1503             // This ensures Team Just cannot influence the outcome of FoMo3D with
1504             // bank migrations by breaking outgoing transactions.
1505             // Something we would never do. But that's not the point.
1506             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1507             // highest belief that everything we create should be trustless.
1508             // Team JUST, The name you shouldn't have to trust.
1509             _p3d = _p3d.add(_com);
1510             _com = 0;
1511         }
1512             
1513         // distribute gen portion to key holders
1514         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1515         
1516         // send share for p3d to divies
1517         if (_p3d > 0)
1518             Divies.deposit.value(_p3d)();
1519             
1520         // fill next round pot with its share
1521         round_[_rID + 1].pot += _res;
1522         
1523         // prepare event data
1524         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1525         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1526         _eventData_.winnerAddr = plyr_[_winPID].addr;
1527         _eventData_.winnerName = plyr_[_winPID].name;
1528         _eventData_.amountWon = _win;
1529         _eventData_.genAmount = _gen;
1530         _eventData_.P3DAmount = _p3d;
1531         _eventData_.newPot = _res;
1532         
1533         return(_eventData_);
1534     }
1535     
1536     /**
1537      * @dev takes keys bought during ICO phase, and adds them to round.  pays 
1538      * out gen rewards that accumulated during ICO phase 
1539      */
1540     function roundClaimICOKeys(uint256 _rID)
1541         private
1542     {
1543         // update round eth to account for ICO phase eth investment 
1544         round_[_rID].eth = round_[_rID].ico;
1545                 
1546         // add keys to round that were bought during ICO phase
1547         round_[_rID].keys = (round_[_rID].ico).keys();
1548         
1549         // store average ICO key price 
1550         round_[_rID].icoAvg = calcAverageICOPhaseKeyPrice(_rID);
1551                 
1552         // set round mask from ICO phase
1553         uint256 _ppt = ((round_[_rID].icoGen).mul(1000000000000000000)) / (round_[_rID].keys);
1554         uint256 _dust = (round_[_rID].icoGen).sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000));
1555         if (_dust > 0)
1556             round_[_rID].pot = (_dust).add(round_[_rID].pot);   // <<< your adding to pot and havent updated event data
1557                 
1558         // distribute gen portion to key holders
1559         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1560     }
1561     
1562     /**
1563      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1564      */
1565     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1566         private 
1567     {
1568         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1569         if (_earnings > 0)
1570         {
1571             // put in gen vault
1572             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1573             // zero out their earnings by updating mask
1574             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1575         }
1576     }
1577     
1578     /**
1579      * @dev updates round timer based on number of whole keys bought.
1580      */
1581     function updateTimer(uint256 _keys, uint256 _rID)
1582         private
1583     {
1584         // calculate time based on number of keys bought
1585         uint256 _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1586         
1587         // grab time
1588         uint256 _now = now;
1589         
1590         // compare to max and set new end time
1591         if (_newTime < (rndMax_).add(_now))
1592             round_[_rID].end = _newTime;
1593         else
1594             round_[_rID].end = rndMax_.add(_now);
1595     }
1596     
1597     /**
1598      * @dev generates a random number between 0-99 and checks to see if thats
1599      * resulted in an airdrop win
1600      * @return do we have a winner?
1601      */
1602     function airdrop()
1603         private 
1604         view 
1605         returns(bool)
1606     {
1607         uint256 seed = uint256(keccak256(abi.encodePacked(
1608             
1609             (block.timestamp).add
1610             (block.difficulty).add
1611             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1612             (block.gaslimit).add
1613             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1614             (block.number)
1615             
1616         )));
1617         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1618             return(true);
1619         else
1620             return(false);
1621     }
1622 
1623     /**
1624      * @dev distributes eth based on fees to com, aff, and p3d
1625      */
1626     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1627         private
1628         returns(F3Ddatasets.EventReturns)
1629     {
1630         // pay 2% out to community rewards
1631         uint256 _com = _eth / 50;
1632         uint256 _p3d;
1633         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1634         {
1635             // This ensures Team Just cannot influence the outcome of FoMo3D with
1636             // bank migrations by breaking outgoing transactions.
1637             // Something we would never do. But that's not the point.
1638             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1639             // highest belief that everything we create should be trustless.
1640             // Team JUST, The name you shouldn't have to trust.
1641             _p3d = _com;
1642             _com = 0;
1643         }
1644         
1645         // pay 1% out to FoMo3D long
1646         uint256 _long = _eth / 100;
1647         round_[_rID + 1].pot += _long;
1648         
1649         // distribute share to affiliate
1650         uint256 _aff = _eth / 10;
1651         
1652         // decide what to do with affiliate share of fees
1653         // affiliate must not be self, and must have a name registered
1654         if (_affID != _pID && plyr_[_affID].name != '') {
1655             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1656             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1657         } else {
1658             _p3d = _aff;
1659         }
1660         
1661         // pay out p3d
1662         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1663         if (_p3d > 0)
1664         {
1665             // deposit to divies contract
1666             Divies.deposit.value(_p3d)();
1667             
1668             // set up event data
1669             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1670         }
1671         
1672         return(_eventData_);
1673     }
1674     
1675     function potSwap()
1676         external
1677         payable
1678     {
1679         // setup local rID
1680         uint256 _rID = rID_ + 1;
1681         
1682         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1683         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1684     }
1685     
1686     /**
1687      * @dev distributes eth based on fees to gen and pot
1688      */
1689     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1690         private
1691         returns(F3Ddatasets.EventReturns)
1692     {
1693         // calculate gen share
1694         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1695         
1696         // toss 1% into airdrop pot 
1697         uint256 _air = (_eth / 100);
1698         airDropPot_ = airDropPot_.add(_air);
1699         
1700         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1701         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1702         
1703         // calculate pot 
1704         uint256 _pot = _eth.sub(_gen);
1705         
1706         // distribute gen share (thats what updateMasks() does) and adjust
1707         // balances for dust.
1708         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1709         if (_dust > 0)
1710             _gen = _gen.sub(_dust);
1711         
1712         // add eth to pot
1713         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1714         
1715         // set up event data
1716         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1717         _eventData_.potAmount = _pot;
1718         
1719         return(_eventData_);
1720     }
1721 
1722     /**
1723      * @dev updates masks for round and player when keys are bought
1724      * @return dust left over 
1725      */
1726     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1727         private
1728         returns(uint256)
1729     {
1730         /* MASKING NOTES
1731             earnings masks are a tricky thing for people to wrap their minds around.
1732             the basic thing to understand here.  is were going to have a global
1733             tracker based on profit per share for each round, that increases in
1734             relevant proportion to the increase in share supply.
1735             
1736             the player will have an additional mask that basically says "based
1737             on the rounds mask, my shares, and how much i've already withdrawn,
1738             how much is still owed to me?"
1739         */
1740         
1741         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1742         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1743         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1744             
1745         // calculate player earning from their own buy (only based on the keys
1746         // they just bought).  & update player earnings mask
1747         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1748         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1749         
1750         // calculate & return dust
1751         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1752     }
1753     
1754     /**
1755      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1756      * @return earnings in wei format
1757      */
1758     function withdrawEarnings(uint256 _pID)
1759         private
1760         returns(uint256)
1761     {
1762         // update gen vault
1763         updateGenVault(_pID, plyr_[_pID].lrnd);
1764         
1765         // from vaults 
1766         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1767         if (_earnings > 0)
1768         {
1769             plyr_[_pID].win = 0;
1770             plyr_[_pID].gen = 0;
1771             plyr_[_pID].aff = 0;
1772         }
1773 
1774         return(_earnings);
1775     }
1776     
1777     /**
1778      * @dev prepares compression data and fires event for buy or reload tx's
1779      */
1780     function endTx(uint256 _rID, uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1781         private
1782     {
1783         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1784         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (_rID * 10000000000000000000000000000000000000000000000000000);
1785         
1786         emit F3Devents.onEndTx
1787         (
1788             _eventData_.compressedData,
1789             _eventData_.compressedIDs,
1790             plyr_[_pID].name,
1791             msg.sender,
1792             _eth,
1793             _keys,
1794             _eventData_.winnerAddr,
1795             _eventData_.winnerName,
1796             _eventData_.amountWon,
1797             _eventData_.newPot,
1798             _eventData_.P3DAmount,
1799             _eventData_.genAmount,
1800             _eventData_.potAmount,
1801             airDropPot_
1802         );
1803     }
1804 //==============================================================================
1805 //    (~ _  _    _._|_    .
1806 //    _)(/_(_|_|| | | \/  .
1807 //====================/=========================================================
1808     /** upon contract deploy, it will be deactivated.  this is a one time
1809      * use function that will activate the contract.  we do this so devs 
1810      * have time to set things up on the web end                            **/
1811     bool public activated_ = false;
1812     function activate()
1813         public
1814     {
1815         // only team just can activate 
1816         require(
1817             // msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1818             // msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1819             // msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1820             // msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1821 			// msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1822 			msg.sender == 0xD9A85b1eEe7718221713D5e8131d041DC417E901,
1823             "only team just can activate"
1824         );
1825 
1826         // can only be ran once
1827         require(activated_ == false, "fomo3d already activated");
1828         
1829         // activate the contract 
1830         activated_ = true;
1831         
1832         // lets start first round in ICO phase
1833 		rID_ = 1;
1834         round_[1].strt = now;
1835         round_[1].end = now + rndInit_ + rndGap_;
1836     }
1837 }
1838 
1839 
1840 //==============================================================================
1841 //   __|_ _    __|_ _  .
1842 //  _\ | | |_|(_ | _\  .
1843 //==============================================================================
1844 library F3Ddatasets {
1845     //compressedData key
1846     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1847         // 0 - new player (bool)
1848         // 1 - joined round (bool)
1849         // 2 - new  leader (bool)
1850         // 3-5 - air drop tracker (uint 0-999)
1851         // 6-16 - round end time
1852         // 17 - winnerTeam
1853         // 18 - 28 timestamp 
1854         // 29 - team
1855         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1856         // 31 - airdrop happened bool
1857         // 32 - airdrop tier 
1858         // 33 - airdrop amount won
1859     //compressedIDs key
1860     // [77-52][51-26][25-0]
1861         // 0-25 - pID 
1862         // 26-51 - winPID
1863         // 52-77 - rID
1864     struct EventReturns {
1865         uint256 compressedData;
1866         uint256 compressedIDs;
1867         address winnerAddr;         // winner address
1868         bytes32 winnerName;         // winner name
1869         uint256 amountWon;          // amount won
1870         uint256 newPot;             // amount in new pot
1871         uint256 P3DAmount;          // amount distributed to p3d
1872         uint256 genAmount;          // amount distributed to gen
1873         uint256 potAmount;          // amount added to pot
1874     }
1875     struct Player {
1876         address addr;   // player address
1877         bytes32 name;   // player name
1878         uint256 win;    // winnings vault
1879         uint256 gen;    // general vault
1880         uint256 aff;    // affiliate vault
1881         uint256 lrnd;   // last round played
1882         uint256 laff;   // last affiliate id used
1883     }
1884     struct PlayerRounds {
1885         uint256 eth;    // eth player has added to round (used for eth limiter)
1886         uint256 keys;   // keys
1887         uint256 mask;   // player mask 
1888         uint256 ico;    // ICO phase investment
1889     }
1890     struct Round {
1891         uint256 plyr;   // pID of player in lead
1892         uint256 team;   // tID of team in lead
1893         uint256 end;    // time ends/ended
1894         bool ended;     // has round end function been ran
1895         uint256 strt;   // time round started
1896         uint256 keys;   // keys
1897         uint256 eth;    // total eth in
1898         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1899         uint256 mask;   // global mask
1900         uint256 ico;    // total eth sent in during ICO phase
1901         uint256 icoGen; // total eth for gen during ICO phase
1902         uint256 icoAvg; // average key price for ICO phase
1903     }
1904     struct TeamFee {
1905         uint256 gen;    // % of buy in thats paid to key holders of current round
1906         uint256 p3d;    // % of buy in thats paid to p3d holders
1907     }
1908     struct PotSplit {
1909         uint256 gen;    // % of pot thats paid to key holders of current round
1910         uint256 p3d;    // % of pot thats paid to p3d holders
1911     }
1912 }
1913 
1914 //==============================================================================
1915 //  |  _      _ _ | _  .
1916 //  |<(/_\/  (_(_||(_  .
1917 //=======/======================================================================
1918 library F3DKeysCalcFast {
1919     using SafeMath for *;
1920     
1921     /**
1922      * @dev calculates number of keys received given X eth 
1923      * @param _curEth current amount of eth in contract 
1924      * @param _newEth eth being spent
1925      * @return amount of ticket purchased
1926      */
1927     function keysRec(uint256 _curEth, uint256 _newEth)
1928         internal
1929         pure
1930         returns (uint256)
1931     {
1932         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1933     }
1934     
1935     /**
1936      * @dev calculates amount of eth received if you sold X keys 
1937      * @param _curKeys current amount of keys that exist 
1938      * @param _sellKeys amount of keys you wish to sell
1939      * @return amount of eth received
1940      */
1941     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1942         internal
1943         pure
1944         returns (uint256)
1945     {
1946         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1947     }
1948 
1949     /**
1950      * @dev calculates how many keys would exist with given an amount of eth
1951      * @param _eth eth "in contract"
1952      * @return number of keys that would exist
1953      */
1954     function keys(uint256 _eth) 
1955         internal
1956         pure
1957         returns(uint256)
1958     {
1959         return ((((((_eth).mul(1000000000000000000)).mul(200000000000000000000000000000000)).add(2500000000000000000000000000000000000000000000000000000000000000)).sqrt()).sub(50000000000000000000000000000000)) / (100000000000000);
1960     }
1961     
1962     /**
1963      * @dev calculates how much eth would be in contract given a number of keys
1964      * @param _keys number of keys "in contract" 
1965      * @return eth that would exists
1966      */
1967     function eth(uint256 _keys) 
1968         internal
1969         pure
1970         returns(uint256)  
1971     {
1972         return ((50000000000000).mul(_keys.sq()).add(((100000000000000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1973     }
1974 }
1975 
1976 //==============================================================================
1977 //  . _ _|_ _  _ |` _  _ _  _  .
1978 //  || | | (/_| ~|~(_|(_(/__\  .
1979 //==============================================================================
1980 interface DiviesInterface {
1981     function deposit() external payable;
1982 }
1983 
1984 interface JIincForwarderInterface {
1985     function deposit() external payable returns(bool);
1986     function status() external view returns(address, address, bool);
1987     function startMigration(address _newCorpBank) external returns(bool);
1988     function cancelMigration() external returns(bool);
1989     function finishMigration() external returns(bool);
1990     function setup(address _firstCorpBank) external;
1991 }
1992 
1993 interface PlayerBookInterface {
1994     function getPlayerID(address _addr) external returns (uint256);
1995     function getPlayerName(uint256 _pID) external view returns (bytes32);
1996     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1997     function getPlayerAddr(uint256 _pID) external view returns (address);
1998     function getNameFee() external view returns (uint256);
1999     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
2000     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
2001     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
2002 }
2003 
2004 /**
2005 * @title -Name Filter- v0.1.9
2006 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
2007 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
2008 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
2009 *                                  _____                      _____
2010 *                                 (, /     /)       /) /)    (, /      /)          /)
2011 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
2012 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
2013 *          ┴ ┴                /   /          .-/ _____   (__ /                               
2014 *                            (__ /          (_/ (, /                                      /)™ 
2015 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
2016 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
2017 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
2018 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
2019 *              _       __    _      ____      ____  _   _    _____  ____  ___  
2020 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
2021 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
2022 *
2023 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
2024 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
2025 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
2026 */
2027 
2028 library NameFilter {
2029     
2030     /**
2031      * @dev filters name strings
2032      * -converts uppercase to lower case.  
2033      * -makes sure it does not start/end with a space
2034      * -makes sure it does not contain multiple spaces in a row
2035      * -cannot be only numbers
2036      * -cannot start with 0x 
2037      * -restricts characters to A-Z, a-z, 0-9, and space.
2038      * @return reprocessed string in bytes32 format
2039      */
2040     function nameFilter(string _input)
2041         internal
2042         pure
2043         returns(bytes32)
2044     {
2045         bytes memory _temp = bytes(_input);
2046         uint256 _length = _temp.length;
2047         
2048         //sorry limited to 32 characters
2049         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
2050         // make sure it doesnt start with or end with space
2051         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
2052         // make sure first two characters are not 0x
2053         if (_temp[0] == 0x30)
2054         {
2055             require(_temp[1] != 0x78, "string cannot start with 0x");
2056             require(_temp[1] != 0x58, "string cannot start with 0X");
2057         }
2058         
2059         // create a bool to track if we have a non number character
2060         bool _hasNonNumber;
2061         
2062         // convert & check
2063         for (uint256 i = 0; i < _length; i++)
2064         {
2065             // if its uppercase A-Z
2066             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2067             {
2068                 // convert to lower case a-z
2069                 _temp[i] = byte(uint(_temp[i]) + 32);
2070                 
2071                 // we have a non number
2072                 if (_hasNonNumber == false)
2073                     _hasNonNumber = true;
2074             } else {
2075                 require
2076                 (
2077                     // require character is a space
2078                     _temp[i] == 0x20 || 
2079                     // OR lowercase a-z
2080                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2081                     // or 0-9
2082                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
2083                     "string contains invalid characters"
2084                 );
2085                 // make sure theres not 2x spaces in a row
2086                 if (_temp[i] == 0x20)
2087                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2088                 
2089                 // see if we have a character other than a number
2090                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2091                     _hasNonNumber = true;    
2092             }
2093         }
2094         
2095         require(_hasNonNumber == true, "string cannot be only numbers");
2096         
2097         bytes32 _ret;
2098         assembly {
2099             _ret := mload(add(_temp, 32))
2100         }
2101         return (_ret);
2102     }
2103 }
2104 
2105 /**
2106  * @title SafeMath v0.1.9
2107  * @dev Math operations with safety checks that throw on error
2108  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2109  * - added sqrt
2110  * - added sq
2111  * - added pwr 
2112  * - changed asserts to requires with error log outputs
2113  * - removed div, its useless
2114  */
2115 library SafeMath {
2116     
2117     /**
2118     * @dev Multiplies two numbers, throws on overflow.
2119     */
2120     function mul(uint256 a, uint256 b) 
2121         internal 
2122         pure 
2123         returns (uint256 c) 
2124     {
2125         if (a == 0) {
2126             return 0;
2127         }
2128         c = a * b;
2129         require(c / a == b, "SafeMath mul failed");
2130         return c;
2131     }
2132 
2133     /**
2134     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2135     */
2136     function sub(uint256 a, uint256 b)
2137         internal
2138         pure
2139         returns (uint256) 
2140     {
2141         require(b <= a, "SafeMath sub failed");
2142         return a - b;
2143     }
2144 
2145     /**
2146     * @dev Adds two numbers, throws on overflow.
2147     */
2148     function add(uint256 a, uint256 b)
2149         internal
2150         pure
2151         returns (uint256 c) 
2152     {
2153         c = a + b;
2154         require(c >= a, "SafeMath add failed");
2155         return c;
2156     }
2157     
2158     /**
2159      * @dev gives square root of given x.
2160      */
2161     function sqrt(uint256 x)
2162         internal
2163         pure
2164         returns (uint256 y) 
2165     {
2166         uint256 z = ((add(x,1)) / 2);
2167         y = x;
2168         while (z < y) 
2169         {
2170             y = z;
2171             z = ((add((x / z),z)) / 2);
2172         }
2173     }
2174     
2175     /**
2176      * @dev gives square. multiplies x by x
2177      */
2178     function sq(uint256 x)
2179         internal
2180         pure
2181         returns (uint256)
2182     {
2183         return (mul(x,x));
2184     }
2185     
2186     /**
2187      * @dev x to the power of y 
2188      */
2189     function pwr(uint256 x, uint256 y)
2190         internal 
2191         pure 
2192         returns (uint256)
2193     {
2194         if (x==0)
2195             return (0);
2196         else if (y==0)
2197             return (1);
2198         else 
2199         {
2200             uint256 z = x;
2201             for (uint256 i=1; i < y; i++)
2202                 z = mul(z,x);
2203             return (z);
2204         }
2205     }
2206 }