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
185 	otherFoMo3D private otherF3D_;
186     // DiviesInterface constant private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
187     DiviesInterface constant private Divies = DiviesInterface(0x10Adfd14161c880923acA3E94043E74b4665DfE5);
188     // JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
189     JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0x1f5654082761182b50460c0E8945324aC7c62D1d);
190 	// PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xD60d353610D9a5Ca478769D371b53CEfAA7B6E4c);
191 	PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xc4AD45a8808d577D8B08Ca5E4dD6939964EB645f);
192     // F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x32967D6c142c2F38AB39235994e2DDF11c37d590);
193     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0x2faF57f01aA779251e56859E0B0ACd4CccAA4871);
194 //==============================================================================
195 //     _ _  _  |`. _     _ _ |_ | _  _  .
196 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
197 //=================_|===========================================================
198     string constant public name = "FoMo3D Long Official";
199     string constant public symbol = "F3D";
200 	uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO 
201     uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
202     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
203     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
204     uint256 constant private rndMax_ = 24 hours;                // max length a round timer can be
205 //==============================================================================
206 //     _| _ _|_ _    _ _ _|_    _   .
207 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
208 //=============================|================================================
209 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
210     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
211     uint256 public rID_;    // round id number / total rounds that have happened
212 //****************
213 // PLAYER DATA 
214 //****************
215     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
216     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
217     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
218     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
219     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
220 //****************
221 // ROUND DATA 
222 //****************
223     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
224     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
225 //****************
226 // TEAM FEE DATA 
227 //****************
228     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
229     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
230 //==============================================================================
231 //     _ _  _  __|_ _    __|_ _  _  .
232 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
233 //==============================================================================
234     constructor()
235         public
236     {
237 		// Team allocation structures
238         // 0 = whales
239         // 1 = bears
240         // 2 = sneks
241         // 3 = bulls
242 
243 		// Team allocation percentages
244         // (F3D, P3D) + (Pot , Referrals, Community)
245             // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
246         fees_[0] = F3Ddatasets.TeamFee(30,6);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
247         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
248         fees_[2] = F3Ddatasets.TeamFee(56,10);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
249         fees_[3] = F3Ddatasets.TeamFee(43,8);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
250         
251         // how to split up the final pot based on which team was picked
252         // (F3D, P3D)
253         potSplit_[0] = F3Ddatasets.PotSplit(15,10);  //48% to winner, 25% to next round, 2% to com
254         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
255         potSplit_[2] = F3Ddatasets.PotSplit(20,20);  //48% to winner, 10% to next round, 2% to com
256         potSplit_[3] = F3Ddatasets.PotSplit(30,10);  //48% to winner, 10% to next round, 2% to com
257 	}
258 //==============================================================================
259 //     _ _  _  _|. |`. _  _ _  .
260 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
261 //==============================================================================
262     /**
263      * @dev used to make sure no one can interact with contract until it has 
264      * been activated. 
265      */
266     modifier isActivated() {
267         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
268         _;
269     }
270     
271     /**
272      * @dev prevents contracts from interacting with fomo3d 
273      */
274     modifier isHuman() {
275         address _addr = msg.sender;
276         uint256 _codeLength;
277         
278         assembly {_codeLength := extcodesize(_addr)}
279         require(_codeLength == 0, "sorry humans only");
280         _;
281     }
282 
283     /**
284      * @dev sets boundaries for incoming tx 
285      */
286     modifier isWithinLimits(uint256 _eth) {
287         require(_eth >= 1000000000, "pocket lint: not a valid currency");
288         require(_eth <= 100000000000000000000000, "no vitalik, no");
289         _;    
290     }
291     
292 //==============================================================================
293 //     _    |_ |. _   |`    _  __|_. _  _  _  .
294 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
295 //====|=========================================================================
296     /**
297      * @dev emergency buy uses last stored affiliate ID and team snek
298      */
299     function()
300         isActivated()
301         isHuman()
302         isWithinLimits(msg.value)
303         public
304         payable
305     {
306         // set up our tx event data and determine if player is new or not
307         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
308             
309         // fetch player id
310         uint256 _pID = pIDxAddr_[msg.sender];
311         
312         // buy core 
313         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
314     }
315     
316     /**
317      * @dev converts all incoming ethereum to keys.
318      * -functionhash- 0x8f38f309 (using ID for affiliate)
319      * -functionhash- 0x98a0871d (using address for affiliate)
320      * -functionhash- 0xa65b37a1 (using name for affiliate)
321      * @param _affCode the ID/address/name of the player who gets the affiliate fee
322      * @param _team what team is the player playing for?
323      */
324     function buyXid(uint256 _affCode, uint256 _team)
325         isActivated()
326         isHuman()
327         isWithinLimits(msg.value)
328         public
329         payable
330     {
331         // set up our tx event data and determine if player is new or not
332         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
333         
334         // fetch player id
335         uint256 _pID = pIDxAddr_[msg.sender];
336         
337         // manage affiliate residuals
338         // if no affiliate code was given or player tried to use their own, lolz
339         if (_affCode == 0 || _affCode == _pID)
340         {
341             // use last stored affiliate code 
342             _affCode = plyr_[_pID].laff;
343             
344         // if affiliate code was given & its not the same as previously stored 
345         } else if (_affCode != plyr_[_pID].laff) {
346             // update last affiliate 
347             plyr_[_pID].laff = _affCode;
348         }
349         
350         // verify a valid team was selected
351         _team = verifyTeam(_team);
352         
353         // buy core 
354         buyCore(_pID, _affCode, _team, _eventData_);
355     }
356     
357     function buyXaddr(address _affCode, uint256 _team)
358         isActivated()
359         isHuman()
360         isWithinLimits(msg.value)
361         public
362         payable
363     {
364         // set up our tx event data and determine if player is new or not
365         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
366         
367         // fetch player id
368         uint256 _pID = pIDxAddr_[msg.sender];
369         
370         // manage affiliate residuals
371         uint256 _affID;
372         // if no affiliate code was given or player tried to use their own, lolz
373         if (_affCode == address(0) || _affCode == msg.sender)
374         {
375             // use last stored affiliate code
376             _affID = plyr_[_pID].laff;
377         
378         // if affiliate code was given    
379         } else {
380             // get affiliate ID from aff Code 
381             _affID = pIDxAddr_[_affCode];
382             
383             // if affID is not the same as previously stored 
384             if (_affID != plyr_[_pID].laff)
385             {
386                 // update last affiliate
387                 plyr_[_pID].laff = _affID;
388             }
389         }
390         
391         // verify a valid team was selected
392         _team = verifyTeam(_team);
393         
394         // buy core 
395         buyCore(_pID, _affID, _team, _eventData_);
396     }
397     
398     function buyXname(bytes32 _affCode, uint256 _team)
399         isActivated()
400         isHuman()
401         isWithinLimits(msg.value)
402         public
403         payable
404     {
405         // set up our tx event data and determine if player is new or not
406         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
407         
408         // fetch player id
409         uint256 _pID = pIDxAddr_[msg.sender];
410         
411         // manage affiliate residuals
412         uint256 _affID;
413         // if no affiliate code was given or player tried to use their own, lolz
414         if (_affCode == '' || _affCode == plyr_[_pID].name)
415         {
416             // use last stored affiliate code
417             _affID = plyr_[_pID].laff;
418         
419         // if affiliate code was given
420         } else {
421             // get affiliate ID from aff Code
422             _affID = pIDxName_[_affCode];
423             
424             // if affID is not the same as previously stored
425             if (_affID != plyr_[_pID].laff)
426             {
427                 // update last affiliate
428                 plyr_[_pID].laff = _affID;
429             }
430         }
431         
432         // verify a valid team was selected
433         _team = verifyTeam(_team);
434         
435         // buy core 
436         buyCore(_pID, _affID, _team, _eventData_);
437     }
438     
439     /**
440      * @dev essentially the same as buy, but instead of you sending ether 
441      * from your wallet, it uses your unwithdrawn earnings.
442      * -functionhash- 0x349cdcac (using ID for affiliate)
443      * -functionhash- 0x82bfc739 (using address for affiliate)
444      * -functionhash- 0x079ce327 (using name for affiliate)
445      * @param _affCode the ID/address/name of the player who gets the affiliate fee
446      * @param _team what team is the player playing for?
447      * @param _eth amount of earnings to use (remainder returned to gen vault)
448      */
449     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
450         isActivated()
451         isHuman()
452         isWithinLimits(_eth)
453         public
454     {
455         // set up our tx event data
456         F3Ddatasets.EventReturns memory _eventData_;
457         
458         // fetch player ID
459         uint256 _pID = pIDxAddr_[msg.sender];
460         
461         // manage affiliate residuals
462         // if no affiliate code was given or player tried to use their own, lolz
463         if (_affCode == 0 || _affCode == _pID)
464         {
465             // use last stored affiliate code 
466             _affCode = plyr_[_pID].laff;
467             
468         // if affiliate code was given & its not the same as previously stored 
469         } else if (_affCode != plyr_[_pID].laff) {
470             // update last affiliate 
471             plyr_[_pID].laff = _affCode;
472         }
473 
474         // verify a valid team was selected
475         _team = verifyTeam(_team);
476 
477         // reload core
478         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
479     }
480     
481     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
482         isActivated()
483         isHuman()
484         isWithinLimits(_eth)
485         public
486     {
487         // set up our tx event data
488         F3Ddatasets.EventReturns memory _eventData_;
489         
490         // fetch player ID
491         uint256 _pID = pIDxAddr_[msg.sender];
492         
493         // manage affiliate residuals
494         uint256 _affID;
495         // if no affiliate code was given or player tried to use their own, lolz
496         if (_affCode == address(0) || _affCode == msg.sender)
497         {
498             // use last stored affiliate code
499             _affID = plyr_[_pID].laff;
500         
501         // if affiliate code was given    
502         } else {
503             // get affiliate ID from aff Code 
504             _affID = pIDxAddr_[_affCode];
505             
506             // if affID is not the same as previously stored 
507             if (_affID != plyr_[_pID].laff)
508             {
509                 // update last affiliate
510                 plyr_[_pID].laff = _affID;
511             }
512         }
513         
514         // verify a valid team was selected
515         _team = verifyTeam(_team);
516         
517         // reload core
518         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
519     }
520     
521     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
522         isActivated()
523         isHuman()
524         isWithinLimits(_eth)
525         public
526     {
527         // set up our tx event data
528         F3Ddatasets.EventReturns memory _eventData_;
529         
530         // fetch player ID
531         uint256 _pID = pIDxAddr_[msg.sender];
532         
533         // manage affiliate residuals
534         uint256 _affID;
535         // if no affiliate code was given or player tried to use their own, lolz
536         if (_affCode == '' || _affCode == plyr_[_pID].name)
537         {
538             // use last stored affiliate code
539             _affID = plyr_[_pID].laff;
540         
541         // if affiliate code was given
542         } else {
543             // get affiliate ID from aff Code
544             _affID = pIDxName_[_affCode];
545             
546             // if affID is not the same as previously stored
547             if (_affID != plyr_[_pID].laff)
548             {
549                 // update last affiliate
550                 plyr_[_pID].laff = _affID;
551             }
552         }
553         
554         // verify a valid team was selected
555         _team = verifyTeam(_team);
556         
557         // reload core
558         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
559     }
560 
561     /**
562      * @dev withdraws all of your earnings.
563      * -functionhash- 0x3ccfd60b
564      */
565     function withdraw()
566         isActivated()
567         isHuman()
568         public
569     {
570         // setup local rID 
571         uint256 _rID = rID_;
572         
573         // grab time
574         uint256 _now = now;
575         
576         // fetch player ID
577         uint256 _pID = pIDxAddr_[msg.sender];
578         
579         // setup temp var for player eth
580         uint256 _eth;
581         
582         // check to see if round has ended and no one has run round end yet
583         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
584         {
585             // set up our tx event data
586             F3Ddatasets.EventReturns memory _eventData_;
587             
588             // end the round (distributes pot)
589 			round_[_rID].ended = true;
590             _eventData_ = endRound(_eventData_);
591             
592 			// get their earnings
593             _eth = withdrawEarnings(_pID);
594             
595             // gib moni
596             if (_eth > 0)
597                 plyr_[_pID].addr.transfer(_eth);    
598             
599             // build event data
600             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
601             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
602             
603             // fire withdraw and distribute event
604             emit F3Devents.onWithdrawAndDistribute
605             (
606                 msg.sender, 
607                 plyr_[_pID].name, 
608                 _eth, 
609                 _eventData_.compressedData, 
610                 _eventData_.compressedIDs, 
611                 _eventData_.winnerAddr, 
612                 _eventData_.winnerName, 
613                 _eventData_.amountWon, 
614                 _eventData_.newPot, 
615                 _eventData_.P3DAmount, 
616                 _eventData_.genAmount
617             );
618             
619         // in any other situation
620         } else {
621             // get their earnings
622             _eth = withdrawEarnings(_pID);
623             
624             // gib moni
625             if (_eth > 0)
626                 plyr_[_pID].addr.transfer(_eth);
627             
628             // fire withdraw event
629             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
630         }
631     }
632     
633     /**
634      * @dev use these to register names.  they are just wrappers that will send the
635      * registration requests to the PlayerBook contract.  So registering here is the 
636      * same as registering there.  UI will always display the last name you registered.
637      * but you will still own all previously registered names to use as affiliate 
638      * links.
639      * - must pay a registration fee.
640      * - name must be unique
641      * - names will be converted to lowercase
642      * - name cannot start or end with a space 
643      * - cannot have more than 1 space in a row
644      * - cannot be only numbers
645      * - cannot start with 0x 
646      * - name must be at least 1 char
647      * - max length of 32 characters long
648      * - allowed characters: a-z, 0-9, and space
649      * -functionhash- 0x921dec21 (using ID for affiliate)
650      * -functionhash- 0x3ddd4698 (using address for affiliate)
651      * -functionhash- 0x685ffd83 (using name for affiliate)
652      * @param _nameString players desired name
653      * @param _affCode affiliate ID, address, or name of who referred you
654      * @param _all set to true if you want this to push your info to all games 
655      * (this might cost a lot of gas)
656      */
657     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
658         isHuman()
659         public
660         payable
661     {
662         bytes32 _name = _nameString.nameFilter();
663         address _addr = msg.sender;
664         uint256 _paid = msg.value;
665         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
666         
667         uint256 _pID = pIDxAddr_[_addr];
668         
669         // fire event
670         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
671     }
672     
673     function registerNameXaddr(string _nameString, address _affCode, bool _all)
674         isHuman()
675         public
676         payable
677     {
678         bytes32 _name = _nameString.nameFilter();
679         address _addr = msg.sender;
680         uint256 _paid = msg.value;
681         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
682         
683         uint256 _pID = pIDxAddr_[_addr];
684         
685         // fire event
686         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
687     }
688     
689     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
690         isHuman()
691         public
692         payable
693     {
694         bytes32 _name = _nameString.nameFilter();
695         address _addr = msg.sender;
696         uint256 _paid = msg.value;
697         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
698         
699         uint256 _pID = pIDxAddr_[_addr];
700         
701         // fire event
702         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
703     }
704 //==============================================================================
705 //     _  _ _|__|_ _  _ _  .
706 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
707 //=====_|=======================================================================
708     /**
709      * @dev return the price buyer will pay for next 1 individual key.
710      * -functionhash- 0x018a25e8
711      * @return price for next key bought (in wei format)
712      */
713     function getBuyPrice()
714         public 
715         view 
716         returns(uint256)
717     {  
718         // setup local rID
719         uint256 _rID = rID_;
720         
721         // grab time
722         uint256 _now = now;
723         
724         // are we in a round?
725         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
726             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
727         else // rounds over.  need price for new round
728             return ( 75000000000000 ); // init
729     }
730     
731     /**
732      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
733      * provider
734      * -functionhash- 0xc7e284b8
735      * @return time left in seconds
736      */
737     function getTimeLeft()
738         public
739         view
740         returns(uint256)
741     {
742         // setup local rID
743         uint256 _rID = rID_;
744         
745         // grab time
746         uint256 _now = now;
747         
748         if (_now < round_[_rID].end)
749             if (_now > round_[_rID].strt + rndGap_)
750                 return( (round_[_rID].end).sub(_now) );
751             else
752                 return( (round_[_rID].strt + rndGap_).sub(_now) );
753         else
754             return(0);
755     }
756     
757     /**
758      * @dev returns player earnings per vaults 
759      * -functionhash- 0x63066434
760      * @return winnings vault
761      * @return general vault
762      * @return affiliate vault
763      */
764     function getPlayerVaults(uint256 _pID)
765         public
766         view
767         returns(uint256 ,uint256, uint256)
768     {
769         // setup local rID
770         uint256 _rID = rID_;
771         
772         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
773         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
774         {
775             // if player is winner 
776             if (round_[_rID].plyr == _pID)
777             {
778                 return
779                 (
780                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
781                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
782                     plyr_[_pID].aff
783                 );
784             // if player is not the winner
785             } else {
786                 return
787                 (
788                     plyr_[_pID].win,
789                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
790                     plyr_[_pID].aff
791                 );
792             }
793             
794         // if round is still going on, or round has ended and round end has been ran
795         } else {
796             return
797             (
798                 plyr_[_pID].win,
799                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
800                 plyr_[_pID].aff
801             );
802         }
803     }
804     
805     /**
806      * solidity hates stack limits.  this lets us avoid that hate 
807      */
808     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
809         private
810         view
811         returns(uint256)
812     {
813         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
814     }
815     
816     /**
817      * @dev returns all current round info needed for front end
818      * -functionhash- 0x747dff42
819      * @return eth invested during ICO phase
820      * @return round id 
821      * @return total keys for round 
822      * @return time round ends
823      * @return time round started
824      * @return current pot 
825      * @return current team ID & player ID in lead 
826      * @return current player in leads address 
827      * @return current player in leads name
828      * @return whales eth in for round
829      * @return bears eth in for round
830      * @return sneks eth in for round
831      * @return bulls eth in for round
832      * @return airdrop tracker # & airdrop pot
833      */
834     function getCurrentRoundInfo()
835         public
836         view
837         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
838     {
839         // setup local rID
840         uint256 _rID = rID_;
841         
842         return
843         (
844             round_[_rID].ico,               //0
845             _rID,                           //1
846             round_[_rID].keys,              //2
847             round_[_rID].end,               //3
848             round_[_rID].strt,              //4
849             round_[_rID].pot,               //5
850             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
851             plyr_[round_[_rID].plyr].addr,  //7
852             plyr_[round_[_rID].plyr].name,  //8
853             rndTmEth_[_rID][0],             //9
854             rndTmEth_[_rID][1],             //10
855             rndTmEth_[_rID][2],             //11
856             rndTmEth_[_rID][3],             //12
857             airDropTracker_ + (airDropPot_ * 1000)              //13
858         );
859     }
860 
861     /**
862      * @dev returns player info based on address.  if no address is given, it will 
863      * use msg.sender 
864      * -functionhash- 0xee0b5d8b
865      * @param _addr address of the player you want to lookup 
866      * @return player ID 
867      * @return player name
868      * @return keys owned (current round)
869      * @return winnings vault
870      * @return general vault 
871      * @return affiliate vault 
872 	 * @return player round eth
873      */
874     function getPlayerInfoByAddress(address _addr)
875         public 
876         view 
877         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
878     {
879         // setup local rID
880         uint256 _rID = rID_;
881         
882         if (_addr == address(0))
883         {
884             _addr == msg.sender;
885         }
886         uint256 _pID = pIDxAddr_[_addr];
887         
888         return
889         (
890             _pID,                               //0
891             plyr_[_pID].name,                   //1
892             plyrRnds_[_pID][_rID].keys,         //2
893             plyr_[_pID].win,                    //3
894             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
895             plyr_[_pID].aff,                    //5
896             plyrRnds_[_pID][_rID].eth           //6
897         );
898     }
899 
900 //==============================================================================
901 //     _ _  _ _   | _  _ . _  .
902 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
903 //=====================_|=======================================================
904     /**
905      * @dev logic runs whenever a buy order is executed.  determines how to handle 
906      * incoming eth depending on if we are in an active round or not
907      */
908     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
909         private
910     {
911         // setup local rID
912         uint256 _rID = rID_;
913         
914         // grab time
915         uint256 _now = now;
916         
917         // if round is active
918         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
919         {
920             // call core 
921             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
922         
923         // if round is not active     
924         } else {
925             // check to see if end round needs to be ran
926             if (_now > round_[_rID].end && round_[_rID].ended == false) 
927             {
928                 // end the round (distributes pot) & start new round
929 			    round_[_rID].ended = true;
930                 _eventData_ = endRound(_eventData_);
931                 
932                 // build event data
933                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
934                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
935                 
936                 // fire buy and distribute event 
937                 emit F3Devents.onBuyAndDistribute
938                 (
939                     msg.sender, 
940                     plyr_[_pID].name, 
941                     msg.value, 
942                     _eventData_.compressedData, 
943                     _eventData_.compressedIDs, 
944                     _eventData_.winnerAddr, 
945                     _eventData_.winnerName, 
946                     _eventData_.amountWon, 
947                     _eventData_.newPot, 
948                     _eventData_.P3DAmount, 
949                     _eventData_.genAmount
950                 );
951             }
952             
953             // put eth in players vault 
954             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
955         }
956     }
957     
958     /**
959      * @dev logic runs whenever a reload order is executed.  determines how to handle 
960      * incoming eth depending on if we are in an active round or not 
961      */
962     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
963         private
964     {
965         // setup local rID
966         uint256 _rID = rID_;
967         
968         // grab time
969         uint256 _now = now;
970         
971         // if round is active
972         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
973         {
974             // get earnings from all vaults and return unused to gen vault
975             // because we use a custom safemath library.  this will throw if player 
976             // tried to spend more eth than they have.
977             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
978             
979             // call core 
980             core(_rID, _pID, _eth, _affID, _team, _eventData_);
981         
982         // if round is not active and end round needs to be ran   
983         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
984             // end the round (distributes pot) & start new round
985             round_[_rID].ended = true;
986             _eventData_ = endRound(_eventData_);
987                 
988             // build event data
989             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
990             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
991                 
992             // fire buy and distribute event 
993             emit F3Devents.onReLoadAndDistribute
994             (
995                 msg.sender, 
996                 plyr_[_pID].name, 
997                 _eventData_.compressedData, 
998                 _eventData_.compressedIDs, 
999                 _eventData_.winnerAddr, 
1000                 _eventData_.winnerName, 
1001                 _eventData_.amountWon, 
1002                 _eventData_.newPot, 
1003                 _eventData_.P3DAmount, 
1004                 _eventData_.genAmount
1005             );
1006         }
1007     }
1008     
1009     /**
1010      * @dev this is the core logic for any buy/reload that happens while a round 
1011      * is live.
1012      */
1013     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1014         private
1015     {
1016         // if player is new to round
1017         if (plyrRnds_[_pID][_rID].keys == 0)
1018             _eventData_ = managePlayer(_pID, _eventData_);
1019         
1020         // early round eth limiter 
1021         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1022         {
1023             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
1024             uint256 _refund = _eth.sub(_availableLimit);
1025             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1026             _eth = _availableLimit;
1027         }
1028         
1029         // if eth left is greater than min eth allowed (sorry no pocket lint)
1030         if (_eth > 1000000000) 
1031         {
1032             
1033             // mint the new keys
1034             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1035             
1036             // if they bought at least 1 whole key
1037             if (_keys >= 1000000000000000000)
1038             {
1039             updateTimer(_keys, _rID);
1040 
1041             // set new leaders
1042             if (round_[_rID].plyr != _pID)
1043                 round_[_rID].plyr = _pID;  
1044             if (round_[_rID].team != _team)
1045                 round_[_rID].team = _team; 
1046             
1047             // set the new leader bool to true
1048             _eventData_.compressedData = _eventData_.compressedData + 100;
1049         }
1050             
1051             // manage airdrops
1052             if (_eth >= 100000000000000000)
1053             {
1054             airDropTracker_++;
1055             if (airdrop() == true)
1056             {
1057                 // gib muni
1058                 uint256 _prize;
1059                 if (_eth >= 10000000000000000000)
1060                 {
1061                     // calculate prize and give it to winner
1062                     _prize = ((airDropPot_).mul(75)) / 100;
1063                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1064                     
1065                     // adjust airDropPot 
1066                     airDropPot_ = (airDropPot_).sub(_prize);
1067                     
1068                     // let event know a tier 3 prize was won 
1069                     _eventData_.compressedData += 300000000000000000000000000000000;
1070                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1071                     // calculate prize and give it to winner
1072                     _prize = ((airDropPot_).mul(50)) / 100;
1073                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1074                     
1075                     // adjust airDropPot 
1076                     airDropPot_ = (airDropPot_).sub(_prize);
1077                     
1078                     // let event know a tier 2 prize was won 
1079                     _eventData_.compressedData += 200000000000000000000000000000000;
1080                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1081                     // calculate prize and give it to winner
1082                     _prize = ((airDropPot_).mul(25)) / 100;
1083                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1084                     
1085                     // adjust airDropPot 
1086                     airDropPot_ = (airDropPot_).sub(_prize);
1087                     
1088                     // let event know a tier 3 prize was won 
1089                     _eventData_.compressedData += 300000000000000000000000000000000;
1090                 }
1091                 // set airdrop happened bool to true
1092                 _eventData_.compressedData += 10000000000000000000000000000000;
1093                 // let event know how much was won 
1094                 _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1095                 
1096                 // reset air drop tracker
1097                 airDropTracker_ = 0;
1098             }
1099         }
1100     
1101             // store the air drop tracker number (number of buys since last airdrop)
1102             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1103             
1104             // update player 
1105             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1106             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1107             
1108             // update round
1109             round_[_rID].keys = _keys.add(round_[_rID].keys);
1110             round_[_rID].eth = _eth.add(round_[_rID].eth);
1111             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1112     
1113             // distribute eth
1114             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1115             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1116             
1117             // call end tx function to fire end tx event.
1118 		    endTx(_pID, _team, _eth, _keys, _eventData_);
1119         }
1120     }
1121 //==============================================================================
1122 //     _ _ | _   | _ _|_ _  _ _  .
1123 //    (_(_||(_|_||(_| | (_)| _\  .
1124 //==============================================================================
1125     /**
1126      * @dev calculates unmasked earnings (just calculates, does not update mask)
1127      * @return earnings in wei format
1128      */
1129     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1130         private
1131         view
1132         returns(uint256)
1133     {
1134         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1135     }
1136     
1137     /** 
1138      * @dev returns the amount of keys you would get given an amount of eth. 
1139      * -functionhash- 0xce89c80c
1140      * @param _rID round ID you want price for
1141      * @param _eth amount of eth sent in 
1142      * @return keys received 
1143      */
1144     function calcKeysReceived(uint256 _rID, uint256 _eth)
1145         public
1146         view
1147         returns(uint256)
1148     {
1149         // grab time
1150         uint256 _now = now;
1151         
1152         // are we in a round?
1153         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1154             return ( (round_[_rID].eth).keysRec(_eth) );
1155         else // rounds over.  need keys for new round
1156             return ( (_eth).keys() );
1157     }
1158     
1159     /** 
1160      * @dev returns current eth price for X keys.  
1161      * -functionhash- 0xcf808000
1162      * @param _keys number of keys desired (in 18 decimal format)
1163      * @return amount of eth needed to send
1164      */
1165     function iWantXKeys(uint256 _keys)
1166         public
1167         view
1168         returns(uint256)
1169     {
1170         // setup local rID
1171         uint256 _rID = rID_;
1172         
1173         // grab time
1174         uint256 _now = now;
1175         
1176         // are we in a round?
1177         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1178             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1179         else // rounds over.  need price for new round
1180             return ( (_keys).eth() );
1181     }
1182 //==============================================================================
1183 //    _|_ _  _ | _  .
1184 //     | (_)(_)|_\  .
1185 //==============================================================================
1186     /**
1187 	 * @dev receives name/player info from names contract 
1188      */
1189     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1190         external
1191     {
1192         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1193         if (pIDxAddr_[_addr] != _pID)
1194             pIDxAddr_[_addr] = _pID;
1195         if (pIDxName_[_name] != _pID)
1196             pIDxName_[_name] = _pID;
1197         if (plyr_[_pID].addr != _addr)
1198             plyr_[_pID].addr = _addr;
1199         if (plyr_[_pID].name != _name)
1200             plyr_[_pID].name = _name;
1201         if (plyr_[_pID].laff != _laff)
1202             plyr_[_pID].laff = _laff;
1203         if (plyrNames_[_pID][_name] == false)
1204             plyrNames_[_pID][_name] = true;
1205     }
1206     
1207     /**
1208      * @dev receives entire player name list 
1209      */
1210     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1211         external
1212     {
1213         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1214         if(plyrNames_[_pID][_name] == false)
1215             plyrNames_[_pID][_name] = true;
1216     }   
1217         
1218     /**
1219      * @dev gets existing or registers new pID.  use this when a player may be new
1220      * @return pID 
1221      */
1222     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1223         private
1224         returns (F3Ddatasets.EventReturns)
1225     {
1226         uint256 _pID = pIDxAddr_[msg.sender];
1227         // if player is new to this version of fomo3d
1228         if (_pID == 0)
1229         {
1230             // grab their player ID, name and last aff ID, from player names contract 
1231             _pID = PlayerBook.getPlayerID(msg.sender);
1232             bytes32 _name = PlayerBook.getPlayerName(_pID);
1233             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1234             
1235             // set up player account 
1236             pIDxAddr_[msg.sender] = _pID;
1237             plyr_[_pID].addr = msg.sender;
1238             
1239             if (_name != "")
1240             {
1241                 pIDxName_[_name] = _pID;
1242                 plyr_[_pID].name = _name;
1243                 plyrNames_[_pID][_name] = true;
1244             }
1245             
1246             if (_laff != 0 && _laff != _pID)
1247                 plyr_[_pID].laff = _laff;
1248             
1249             // set the new player bool to true
1250             _eventData_.compressedData = _eventData_.compressedData + 1;
1251         } 
1252         return (_eventData_);
1253     }
1254     
1255     /**
1256      * @dev checks to make sure user picked a valid team.  if not sets team 
1257      * to default (sneks)
1258      */
1259     function verifyTeam(uint256 _team)
1260         private
1261         pure
1262         returns (uint256)
1263     {
1264         if (_team < 0 || _team > 3)
1265             return(2);
1266         else
1267             return(_team);
1268     }
1269     
1270     /**
1271      * @dev decides if round end needs to be run & new round started.  and if 
1272      * player unmasked earnings from previously played rounds need to be moved.
1273      */
1274     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1275         private
1276         returns (F3Ddatasets.EventReturns)
1277     {
1278         // if player has played a previous round, move their unmasked earnings
1279         // from that round to gen vault.
1280         if (plyr_[_pID].lrnd != 0)
1281             updateGenVault(_pID, plyr_[_pID].lrnd);
1282             
1283         // update player's last round played
1284         plyr_[_pID].lrnd = rID_;
1285             
1286         // set the joined round bool to true
1287         _eventData_.compressedData = _eventData_.compressedData + 10;
1288         
1289         return(_eventData_);
1290     }
1291     
1292     /**
1293      * @dev ends the round. manages paying out winner/splitting up pot
1294      */
1295     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1296         private
1297         returns (F3Ddatasets.EventReturns)
1298     {
1299         // setup local rID
1300         uint256 _rID = rID_;
1301         
1302         // grab our winning player and team id's
1303         uint256 _winPID = round_[_rID].plyr;
1304         uint256 _winTID = round_[_rID].team;
1305         
1306         // grab our pot amount
1307         uint256 _pot = round_[_rID].pot;
1308         
1309         // calculate our winner share, community rewards, gen share, 
1310         // p3d share, and amount reserved for next pot 
1311         uint256 _win = (_pot.mul(48)) / 100;
1312         uint256 _com = (_pot / 50);
1313         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1314         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1315         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1316         
1317         // calculate ppt for round mask
1318         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1319         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1320         if (_dust > 0)
1321         {
1322             _gen = _gen.sub(_dust);
1323             _res = _res.add(_dust);
1324         }
1325         
1326         // pay our winner
1327         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1328         
1329         // community rewards
1330         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1331         {
1332             // This ensures Team Just cannot influence the outcome of FoMo3D with
1333             // bank migrations by breaking outgoing transactions.
1334             // Something we would never do. But that's not the point.
1335             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1336             // highest belief that everything we create should be trustless.
1337             // Team JUST, The name you shouldn't have to trust.
1338             _p3d = _p3d.add(_com);
1339             _com = 0;
1340         }
1341         
1342         // distribute gen portion to key holders
1343         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1344         
1345         // send share for p3d to divies
1346         if (_p3d > 0)
1347             Divies.deposit.value(_p3d)();
1348             
1349         // prepare event data
1350         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1351         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1352         _eventData_.winnerAddr = plyr_[_winPID].addr;
1353         _eventData_.winnerName = plyr_[_winPID].name;
1354         _eventData_.amountWon = _win;
1355         _eventData_.genAmount = _gen;
1356         _eventData_.P3DAmount = _p3d;
1357         _eventData_.newPot = _res;
1358         
1359         // start next round
1360         rID_++;
1361         _rID++;
1362         round_[_rID].strt = now;
1363         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1364         round_[_rID].pot = _res;
1365         
1366         return(_eventData_);
1367     }
1368     
1369     /**
1370      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1371      */
1372     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1373         private 
1374     {
1375         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1376         if (_earnings > 0)
1377         {
1378             // put in gen vault
1379             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1380             // zero out their earnings by updating mask
1381             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1382         }
1383     }
1384     
1385     /**
1386      * @dev updates round timer based on number of whole keys bought.
1387      */
1388     function updateTimer(uint256 _keys, uint256 _rID)
1389         private
1390     {
1391         // grab time
1392         uint256 _now = now;
1393         
1394         // calculate time based on number of keys bought
1395         uint256 _newTime;
1396         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1397             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1398         else
1399             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1400         
1401         // compare to max and set new end time
1402         if (_newTime < (rndMax_).add(_now))
1403             round_[_rID].end = _newTime;
1404         else
1405             round_[_rID].end = rndMax_.add(_now);
1406     }
1407     
1408     /**
1409      * @dev generates a random number between 0-99 and checks to see if thats
1410      * resulted in an airdrop win
1411      * @return do we have a winner?
1412      */
1413     function airdrop()
1414         private 
1415         view 
1416         returns(bool)
1417     {
1418         uint256 seed = uint256(keccak256(abi.encodePacked(
1419             
1420             (block.timestamp).add
1421             (block.difficulty).add
1422             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1423             (block.gaslimit).add
1424             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1425             (block.number)
1426             
1427         )));
1428         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1429             return(true);
1430         else
1431             return(false);
1432     }
1433 
1434     /**
1435      * @dev distributes eth based on fees to com, aff, and p3d
1436      */
1437     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1438         private
1439         returns(F3Ddatasets.EventReturns)
1440     {
1441         // pay 2% out to community rewards
1442         uint256 _com = _eth / 50;
1443         uint256 _p3d;
1444         if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1445         {
1446             // This ensures Team Just cannot influence the outcome of FoMo3D with
1447             // bank migrations by breaking outgoing transactions.
1448             // Something we would never do. But that's not the point.
1449             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
1450             // highest belief that everything we create should be trustless.
1451             // Team JUST, The name you shouldn't have to trust.
1452             _p3d = _com;
1453             _com = 0;
1454         }
1455         
1456         // pay 1% out to FoMo3D short
1457         uint256 _long = _eth / 100;
1458         otherF3D_.potSwap.value(_long)();
1459         
1460         // distribute share to affiliate
1461         uint256 _aff = _eth / 10;
1462         
1463         // decide what to do with affiliate share of fees
1464         // affiliate must not be self, and must have a name registered
1465         if (_affID != _pID && plyr_[_affID].name != '') {
1466             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1467             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1468         } else {
1469             _p3d = _aff;
1470         }
1471         
1472         // pay out p3d
1473         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1474         if (_p3d > 0)
1475         {
1476             // deposit to divies contract
1477             Divies.deposit.value(_p3d)();
1478             
1479             // set up event data
1480             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1481         }
1482         
1483         return(_eventData_);
1484     }
1485     
1486     function potSwap()
1487         external
1488         payable
1489     {
1490         // setup local rID
1491         uint256 _rID = rID_ + 1;
1492         
1493         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1494         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1495     }
1496     
1497     /**
1498      * @dev distributes eth based on fees to gen and pot
1499      */
1500     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1501         private
1502         returns(F3Ddatasets.EventReturns)
1503     {
1504         // calculate gen share
1505         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1506         
1507         // toss 1% into airdrop pot 
1508         uint256 _air = (_eth / 100);
1509         airDropPot_ = airDropPot_.add(_air);
1510         
1511         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1512         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1513         
1514         // calculate pot 
1515         uint256 _pot = _eth.sub(_gen);
1516         
1517         // distribute gen share (thats what updateMasks() does) and adjust
1518         // balances for dust.
1519         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1520         if (_dust > 0)
1521             _gen = _gen.sub(_dust);
1522         
1523         // add eth to pot
1524         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1525         
1526         // set up event data
1527         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1528         _eventData_.potAmount = _pot;
1529         
1530         return(_eventData_);
1531     }
1532 
1533     /**
1534      * @dev updates masks for round and player when keys are bought
1535      * @return dust left over 
1536      */
1537     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1538         private
1539         returns(uint256)
1540     {
1541         /* MASKING NOTES
1542             earnings masks are a tricky thing for people to wrap their minds around.
1543             the basic thing to understand here.  is were going to have a global
1544             tracker based on profit per share for each round, that increases in
1545             relevant proportion to the increase in share supply.
1546             
1547             the player will have an additional mask that basically says "based
1548             on the rounds mask, my shares, and how much i've already withdrawn,
1549             how much is still owed to me?"
1550         */
1551         
1552         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1553         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1554         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1555             
1556         // calculate player earning from their own buy (only based on the keys
1557         // they just bought).  & update player earnings mask
1558         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1559         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1560         
1561         // calculate & return dust
1562         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1563     }
1564     
1565     /**
1566      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1567      * @return earnings in wei format
1568      */
1569     function withdrawEarnings(uint256 _pID)
1570         private
1571         returns(uint256)
1572     {
1573         // update gen vault
1574         updateGenVault(_pID, plyr_[_pID].lrnd);
1575         
1576         // from vaults 
1577         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1578         if (_earnings > 0)
1579         {
1580             plyr_[_pID].win = 0;
1581             plyr_[_pID].gen = 0;
1582             plyr_[_pID].aff = 0;
1583         }
1584 
1585         return(_earnings);
1586     }
1587     
1588     /**
1589      * @dev prepares compression data and fires event for buy or reload tx's
1590      */
1591     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1592         private
1593     {
1594         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1595         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1596         
1597         emit F3Devents.onEndTx
1598         (
1599             _eventData_.compressedData,
1600             _eventData_.compressedIDs,
1601             plyr_[_pID].name,
1602             msg.sender,
1603             _eth,
1604             _keys,
1605             _eventData_.winnerAddr,
1606             _eventData_.winnerName,
1607             _eventData_.amountWon,
1608             _eventData_.newPot,
1609             _eventData_.P3DAmount,
1610             _eventData_.genAmount,
1611             _eventData_.potAmount,
1612             airDropPot_
1613         );
1614     }
1615 //==============================================================================
1616 //    (~ _  _    _._|_    .
1617 //    _)(/_(_|_|| | | \/  .
1618 //====================/=========================================================
1619     /** upon contract deploy, it will be deactivated.  this is a one time
1620      * use function that will activate the contract.  we do this so devs 
1621      * have time to set things up on the web end                            **/
1622     bool public activated_ = false;
1623     function activate()
1624         public
1625     {
1626         // only team just can activate 
1627         require(
1628             // msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1629             // msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1630             // msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1631             // msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1632 			// msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1633             msg.sender == 0xD9A85b1eEe7718221713D5e8131d041DC417E901,
1634             "only team just can activate"
1635         );
1636 
1637 		// make sure that its been linked.
1638         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1639         
1640         // can only be ran once
1641         require(activated_ == false, "fomo3d already activated");
1642         
1643         // activate the contract 
1644         activated_ = true;
1645         
1646         // lets start first round
1647 		rID_ = 1;
1648         round_[1].strt = now + rndExtra_ - rndGap_;
1649         round_[1].end = now + rndInit_ + rndExtra_;
1650     }
1651     function setOtherFomo(address _otherF3D)
1652         public
1653     {
1654         // only team just can activate 
1655         require(
1656             // msg.sender == 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C ||
1657             // msg.sender == 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D ||
1658             // msg.sender == 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53 ||
1659             // msg.sender == 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C ||
1660 			// msg.sender == 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3,
1661 			msg.sender == 0xD9A85b1eEe7718221713D5e8131d041DC417E901,
1662             "only team just can activate"
1663         );
1664 
1665         // make sure that it HASNT yet been linked.
1666         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1667         
1668         // set up other fomo3d (fast or long) for pot swap
1669         otherF3D_ = otherFoMo3D(_otherF3D);
1670     }
1671 }
1672 
1673 //==============================================================================
1674 //   __|_ _    __|_ _  .
1675 //  _\ | | |_|(_ | _\  .
1676 //==============================================================================
1677 library F3Ddatasets {
1678     //compressedData key
1679     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1680         // 0 - new player (bool)
1681         // 1 - joined round (bool)
1682         // 2 - new  leader (bool)
1683         // 3-5 - air drop tracker (uint 0-999)
1684         // 6-16 - round end time
1685         // 17 - winnerTeam
1686         // 18 - 28 timestamp 
1687         // 29 - team
1688         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1689         // 31 - airdrop happened bool
1690         // 32 - airdrop tier 
1691         // 33 - airdrop amount won
1692     //compressedIDs key
1693     // [77-52][51-26][25-0]
1694         // 0-25 - pID 
1695         // 26-51 - winPID
1696         // 52-77 - rID
1697     struct EventReturns {
1698         uint256 compressedData;
1699         uint256 compressedIDs;
1700         address winnerAddr;         // winner address
1701         bytes32 winnerName;         // winner name
1702         uint256 amountWon;          // amount won
1703         uint256 newPot;             // amount in new pot
1704         uint256 P3DAmount;          // amount distributed to p3d
1705         uint256 genAmount;          // amount distributed to gen
1706         uint256 potAmount;          // amount added to pot
1707     }
1708     struct Player {
1709         address addr;   // player address
1710         bytes32 name;   // player name
1711         uint256 win;    // winnings vault
1712         uint256 gen;    // general vault
1713         uint256 aff;    // affiliate vault
1714         uint256 lrnd;   // last round played
1715         uint256 laff;   // last affiliate id used
1716     }
1717     struct PlayerRounds {
1718         uint256 eth;    // eth player has added to round (used for eth limiter)
1719         uint256 keys;   // keys
1720         uint256 mask;   // player mask 
1721         uint256 ico;    // ICO phase investment
1722     }
1723     struct Round {
1724         uint256 plyr;   // pID of player in lead
1725         uint256 team;   // tID of team in lead
1726         uint256 end;    // time ends/ended
1727         bool ended;     // has round end function been ran
1728         uint256 strt;   // time round started
1729         uint256 keys;   // keys
1730         uint256 eth;    // total eth in
1731         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1732         uint256 mask;   // global mask
1733         uint256 ico;    // total eth sent in during ICO phase
1734         uint256 icoGen; // total eth for gen during ICO phase
1735         uint256 icoAvg; // average key price for ICO phase
1736     }
1737     struct TeamFee {
1738         uint256 gen;    // % of buy in thats paid to key holders of current round
1739         uint256 p3d;    // % of buy in thats paid to p3d holders
1740     }
1741     struct PotSplit {
1742         uint256 gen;    // % of pot thats paid to key holders of current round
1743         uint256 p3d;    // % of pot thats paid to p3d holders
1744     }
1745 }
1746 
1747 //==============================================================================
1748 //  |  _      _ _ | _  .
1749 //  |<(/_\/  (_(_||(_  .
1750 //=======/======================================================================
1751 library F3DKeysCalcLong {
1752     using SafeMath for *;
1753     /**
1754      * @dev calculates number of keys received given X eth 
1755      * @param _curEth current amount of eth in contract 
1756      * @param _newEth eth being spent
1757      * @return amount of ticket purchased
1758      */
1759     function keysRec(uint256 _curEth, uint256 _newEth)
1760         internal
1761         pure
1762         returns (uint256)
1763     {
1764         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1765     }
1766     
1767     /**
1768      * @dev calculates amount of eth received if you sold X keys 
1769      * @param _curKeys current amount of keys that exist 
1770      * @param _sellKeys amount of keys you wish to sell
1771      * @return amount of eth received
1772      */
1773     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1774         internal
1775         pure
1776         returns (uint256)
1777     {
1778         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1779     }
1780 
1781     /**
1782      * @dev calculates how many keys would exist with given an amount of eth
1783      * @param _eth eth "in contract"
1784      * @return number of keys that would exist
1785      */
1786     function keys(uint256 _eth) 
1787         internal
1788         pure
1789         returns(uint256)
1790     {
1791         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1792     }
1793     
1794     /**
1795      * @dev calculates how much eth would be in contract given a number of keys
1796      * @param _keys number of keys "in contract" 
1797      * @return eth that would exists
1798      */
1799     function eth(uint256 _keys) 
1800         internal
1801         pure
1802         returns(uint256)  
1803     {
1804         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1805     }
1806 }
1807 
1808 //==============================================================================
1809 //  . _ _|_ _  _ |` _  _ _  _  .
1810 //  || | | (/_| ~|~(_|(_(/__\  .
1811 //==============================================================================
1812 interface otherFoMo3D {
1813     function potSwap() external payable;
1814 }
1815 
1816 interface F3DexternalSettingsInterface {
1817     function getFastGap() external returns(uint256);
1818     function getLongGap() external returns(uint256);
1819     function getFastExtra() external returns(uint256);
1820     function getLongExtra() external returns(uint256);
1821 }
1822 
1823 interface DiviesInterface {
1824     function deposit() external payable;
1825 }
1826 
1827 interface JIincForwarderInterface {
1828     function deposit() external payable returns(bool);
1829     function status() external view returns(address, address, bool);
1830     function startMigration(address _newCorpBank) external returns(bool);
1831     function cancelMigration() external returns(bool);
1832     function finishMigration() external returns(bool);
1833     function setup(address _firstCorpBank) external;
1834 }
1835 
1836 interface PlayerBookInterface {
1837     function getPlayerID(address _addr) external returns (uint256);
1838     function getPlayerName(uint256 _pID) external view returns (bytes32);
1839     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1840     function getPlayerAddr(uint256 _pID) external view returns (address);
1841     function getNameFee() external view returns (uint256);
1842     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1843     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1844     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1845 }
1846 
1847 /**
1848 * @title -Name Filter- v0.1.9
1849 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1850 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1851 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1852 *                                  _____                      _____
1853 *                                 (, /     /)       /) /)    (, /      /)          /)
1854 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1855 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1856 *          ┴ ┴                /   /          .-/ _____   (__ /                               
1857 *                            (__ /          (_/ (, /                                      /)™ 
1858 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1859 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1860 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1861 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1862 *              _       __    _      ____      ____  _   _    _____  ____  ___  
1863 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1864 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1865 *
1866 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1867 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1868 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1869 */
1870 
1871 library NameFilter {
1872     /**
1873      * @dev filters name strings
1874      * -converts uppercase to lower case.  
1875      * -makes sure it does not start/end with a space
1876      * -makes sure it does not contain multiple spaces in a row
1877      * -cannot be only numbers
1878      * -cannot start with 0x 
1879      * -restricts characters to A-Z, a-z, 0-9, and space.
1880      * @return reprocessed string in bytes32 format
1881      */
1882     function nameFilter(string _input)
1883         internal
1884         pure
1885         returns(bytes32)
1886     {
1887         bytes memory _temp = bytes(_input);
1888         uint256 _length = _temp.length;
1889         
1890         //sorry limited to 32 characters
1891         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1892         // make sure it doesnt start with or end with space
1893         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1894         // make sure first two characters are not 0x
1895         if (_temp[0] == 0x30)
1896         {
1897             require(_temp[1] != 0x78, "string cannot start with 0x");
1898             require(_temp[1] != 0x58, "string cannot start with 0X");
1899         }
1900         
1901         // create a bool to track if we have a non number character
1902         bool _hasNonNumber;
1903         
1904         // convert & check
1905         for (uint256 i = 0; i < _length; i++)
1906         {
1907             // if its uppercase A-Z
1908             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1909             {
1910                 // convert to lower case a-z
1911                 _temp[i] = byte(uint(_temp[i]) + 32);
1912                 
1913                 // we have a non number
1914                 if (_hasNonNumber == false)
1915                     _hasNonNumber = true;
1916             } else {
1917                 require
1918                 (
1919                     // require character is a space
1920                     _temp[i] == 0x20 || 
1921                     // OR lowercase a-z
1922                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1923                     // or 0-9
1924                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1925                     "string contains invalid characters"
1926                 );
1927                 // make sure theres not 2x spaces in a row
1928                 if (_temp[i] == 0x20)
1929                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1930                 
1931                 // see if we have a character other than a number
1932                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1933                     _hasNonNumber = true;    
1934             }
1935         }
1936         
1937         require(_hasNonNumber == true, "string cannot be only numbers");
1938         
1939         bytes32 _ret;
1940         assembly {
1941             _ret := mload(add(_temp, 32))
1942         }
1943         return (_ret);
1944     }
1945 }
1946 
1947 /**
1948  * @title SafeMath v0.1.9
1949  * @dev Math operations with safety checks that throw on error
1950  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1951  * - added sqrt
1952  * - added sq
1953  * - added pwr 
1954  * - changed asserts to requires with error log outputs
1955  * - removed div, its useless
1956  */
1957 library SafeMath {
1958     
1959     /**
1960     * @dev Multiplies two numbers, throws on overflow.
1961     */
1962     function mul(uint256 a, uint256 b) 
1963         internal 
1964         pure 
1965         returns (uint256 c) 
1966     {
1967         if (a == 0) {
1968             return 0;
1969         }
1970         c = a * b;
1971         require(c / a == b, "SafeMath mul failed");
1972         return c;
1973     }
1974 
1975     /**
1976     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1977     */
1978     function sub(uint256 a, uint256 b)
1979         internal
1980         pure
1981         returns (uint256) 
1982     {
1983         require(b <= a, "SafeMath sub failed");
1984         return a - b;
1985     }
1986 
1987     /**
1988     * @dev Adds two numbers, throws on overflow.
1989     */
1990     function add(uint256 a, uint256 b)
1991         internal
1992         pure
1993         returns (uint256 c) 
1994     {
1995         c = a + b;
1996         require(c >= a, "SafeMath add failed");
1997         return c;
1998     }
1999     
2000     /**
2001      * @dev gives square root of given x.
2002      */
2003     function sqrt(uint256 x)
2004         internal
2005         pure
2006         returns (uint256 y) 
2007     {
2008         uint256 z = ((add(x,1)) / 2);
2009         y = x;
2010         while (z < y) 
2011         {
2012             y = z;
2013             z = ((add((x / z),z)) / 2);
2014         }
2015     }
2016     
2017     /**
2018      * @dev gives square. multiplies x by x
2019      */
2020     function sq(uint256 x)
2021         internal
2022         pure
2023         returns (uint256)
2024     {
2025         return (mul(x,x));
2026     }
2027     
2028     /**
2029      * @dev x to the power of y 
2030      */
2031     function pwr(uint256 x, uint256 y)
2032         internal 
2033         pure 
2034         returns (uint256)
2035     {
2036         if (x==0)
2037             return (0);
2038         else if (y==0)
2039             return (1);
2040         else 
2041         {
2042             uint256 z = x;
2043             for (uint256 i=1; i < y; i++)
2044                 z = mul(z,x);
2045             return (z);
2046         }
2047     }
2048 }