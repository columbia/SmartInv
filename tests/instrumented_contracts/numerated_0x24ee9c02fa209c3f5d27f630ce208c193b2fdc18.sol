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
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63     address public owner;
64 
65 
66     /**
67      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68      * account.
69      */
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83 
84     /**
85      * @dev Allows the current owner to transfer control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function transferOwnership(address newOwner) public onlyOwner {
89         if (newOwner != address(0)) {
90             owner = newOwner;
91         }
92     }
93 }
94 
95 //==============================================================================
96 //     _    _  _ _|_ _  .
97 //    (/_\/(/_| | | _\  .
98 //==============================================================================
99 contract F3Devents {
100     // fired whenever a player registers a name
101     event onNewName
102     (
103         uint256 indexed playerID,
104         address indexed playerAddress,
105         bytes32 indexed playerName,
106         bool isNewPlayer,
107         uint256 affiliateID,
108         address affiliateAddress,
109         bytes32 affiliateName,
110         uint256 amountPaid,
111         uint256 timeStamp
112     );
113 
114     // fired at end of buy or reload
115     event onEndTx
116     (
117         uint256 compressedData,
118         uint256 compressedIDs,
119         bytes32 playerName,
120         address playerAddress,
121         uint256 ethIn,
122         uint256 keysBought,
123         address winnerAddr,
124         bytes32 winnerName,
125         uint256 amountWon,
126         uint256 newPot,
127         uint256 P3DAmount,
128         uint256 genAmount,
129         uint256 potAmount,
130         uint256 airDropPot
131     );
132 
133     // fired whenever theres a withdraw
134     event onWithdraw
135     (
136         uint256 indexed playerID,
137         address playerAddress,
138         bytes32 playerName,
139         uint256 ethOut,
140         uint256 timeStamp
141     );
142 
143     // fired whenever a withdraw forces end round to be ran
144     event onWithdrawAndDistribute
145     (
146         address playerAddress,
147         bytes32 playerName,
148         uint256 ethOut,
149         uint256 compressedData,
150         uint256 compressedIDs,
151         address winnerAddr,
152         bytes32 winnerName,
153         uint256 amountWon,
154         uint256 newPot,
155         uint256 P3DAmount,
156         uint256 genAmount
157     );
158 
159     // (fomo3d long only) fired whenever a player tries a buy after round timer
160     // hit zero, and causes end round to be ran.
161     event onBuyAndDistribute
162     (
163         address playerAddress,
164         bytes32 playerName,
165         uint256 ethIn,
166         uint256 compressedData,
167         uint256 compressedIDs,
168         address winnerAddr,
169         bytes32 winnerName,
170         uint256 amountWon,
171         uint256 newPot,
172         uint256 P3DAmount,
173         uint256 genAmount
174     );
175 
176     // (fomo3d long only) fired whenever a player tries a reload after round timer
177     // hit zero, and causes end round to be ran.
178     event onReLoadAndDistribute
179     (
180         address playerAddress,
181         bytes32 playerName,
182         uint256 compressedData,
183         uint256 compressedIDs,
184         address winnerAddr,
185         bytes32 winnerName,
186         uint256 amountWon,
187         uint256 newPot,
188         uint256 P3DAmount,
189         uint256 genAmount
190     );
191 
192     // fired whenever an affiliate is paid
193     event onAffiliatePayout
194     (
195         uint256 indexed affiliateID,
196         address affiliateAddress,
197         bytes32 affiliateName,
198         uint256 indexed roundID,
199         uint256 indexed buyerID,
200         uint256 amount,
201         uint256 timeStamp
202     );
203 
204     // received pot swap deposit
205     event onPotSwapDeposit
206     (
207         uint256 roundID,
208         uint256 amountAddedToPot
209     );
210 }
211 
212 //==============================================================================
213 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
214 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
215 //====================================|=========================================
216 
217 contract modularLong is F3Devents, Ownable {}
218 
219 contract FoMo3Dlong is modularLong {
220     using SafeMath for *;
221     using NameFilter for string;
222     using F3DKeysCalcLong for uint256;
223 
224     otherFoMo3D private otherF3D_;
225     //P3D分红，暂时不设置，表示无
226     DiviesInterface constant private Divies= DiviesInterface(0x0);
227     //开发者钱包，用于获得一般性收入
228     address constant private myWallet = 0xAD81260195048D1CafDe04856994d60c14E2188d;
229     //开发者的钱包，用于抽取奖金池
230     address constant private myWallet1 = 0xa21fd0B4cabfE359B6F1E7F6b4336022028AB1C4;
231     //    JIincForwarderInterface constant private Jekyll_Island_Inc = JIincForwarderInterface(0xdd4950F977EE28D2C132f1353D1595035Db444EE);
232     //玩家数据
233     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x214e86bc50b2b13cc949e75983c9b728790cf867);
234     //外部设置
235     F3DexternalSettingsInterface constant private extSettings = F3DexternalSettingsInterface(0xf6fcbc80a7fc48dae64156225ee5b191fdad7624);
236     //==============================================================================
237     //     _ _  _  |`. _     _ _ |_ | _  _  .
238     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
239     //=================_|===========================================================
240     string constant public name = "FoMo6D";
241     string constant public symbol = "F6D";
242     uint256 private rndExtra_ = extSettings.getLongExtra();     // length of the very first ICO，相当于是延时多少秒倒计时正式开始
243     uint256 private rndGap_ = extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS. 回合之间的休息时间，投资会进入零钱而不是立刻开始
244     bool private    affNeedName_ = extSettings.getAffNeedName();//是否需要注册名字才能获得推广链接
245     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this, 回合起始倒计时
246     uint256 constant private rndInc_ = 30 seconds;              // every full key purchased adds this much to the timer
247     uint256 constant private rndMax_ = 12 hours;                // max length a round timer can be
248 
249     uint256 constant private keyPriceStart_ = 15000000000000000;//key的起始价, TODO,如果需要改动，两个地方都要改，math那里
250     uint256 constant private keyPriceStep_   = 10000000000000;       //key价格上涨阶梯
251 
252     uint256 private realRndMax_ = rndMax_;               //实际的最大倒计时
253     uint256 constant private keysToReduceMaxTime_ = 10000;//10000个key减少最大倒计时
254     uint256 constant private reduceMaxTimeStep_ = 60 seconds;//一次减少最大倒计时的数量
255     uint256 constant private minMaxTime_ = 2 hours;//最大倒计时的最低限度
256 
257     uint256 constant private comFee_ = 2;                       //dev teams fee %
258     uint256 constant private otherF3DFee_ = 1;                  //to other f3d fee, or give it to com, if has not then to com
259     uint256 constant private affFee_ = 15;                      //aff rewards for invite friends, if has not aff then to com
260     uint256 constant private airdropFee_ = 7;                   //airdrop rewards
261 
262     uint256 constant private feesTotal_ = comFee_ + otherF3DFee_ + affFee_ + airdropFee_;
263 
264     uint256 constant private winnerFee_ = 48;                   //last winner to get
265 
266     uint256 constant private bigAirdrop_ = 12;                    //big airdrop
267     uint256 constant private midAirdrop_ = 8;                    //mid airdrop
268     uint256 constant private smallAirdrop_ = 4;                    //small airdrop
269 
270     uint256 constant private maxEarningRate_ = 600;                //最大获利倍数，百分比
271     uint256 constant private keysLeftRate_ = 100;                  //达到最大获利倍数后，剩余多大比例的keys留下继续分红, 相对于maxEarningRate_的比例
272 
273     //==============================================================================
274     //     _| _ _|_ _    _ _ _|_    _   .
275     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
276     //=============================|================================================
277     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
278     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
279     uint256 public rID_;    // round id number / total rounds that have happened
280     //****************
281     // PLAYER DATA
282     //****************
283     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
284     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
285     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
286     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
287     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
288     mapping (uint256 => uint256) public pIDxCards0_;         //three cards got
289     mapping (uint256 => uint256) public pIDxCards1_;         //three cards got
290     mapping (uint256 => uint256) public pIDxCards2_;         //three cards got
291     //****************
292     // ROUND DATA
293     //****************
294     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
295     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
296     //****************
297     // TEAM FEE DATA
298     //****************
299     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
300     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
301     //==============================================================================
302     //     _ _  _  __|_ _    __|_ _  _  .
303     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
304     //==============================================================================
305     constructor()
306     public
307     {
308         // Team allocation structures
309         // 0 = whales
310         // 1 = bears
311         // 2 = sneks
312         // 3 = bulls
313         // Team allocation percentages
314         // (F3D, P3D) + (Pot , Referrals, Community)
315         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
316         fees_[0] = F3Ddatasets.TeamFee(60,0);   //15% to pot, 15% to aff, 2% to com, 1% to pot swap, 7% to air drop pot
317         fees_[1] = F3Ddatasets.TeamFee(60,0);   //15% to pot, 15% to aff, 2% to com, 1% to pot swap, 7% to air drop pot
318         fees_[2] = F3Ddatasets.TeamFee(60,0);  //15% to pot, 15% to aff, 2% to com, 1% to pot swap, 7% to air drop pot
319         fees_[3] = F3Ddatasets.TeamFee(60,0);   //15% to pot, 15% to aff, 2% to com, 1% to pot swap, 7% to air drop pot
320 
321         // how to split up the final pot based on which team was picked
322         // (F3D, P3D)
323         potSplit_[0] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
324         potSplit_[1] = F3Ddatasets.PotSplit(40,0);   //48% to winner, 10% to next round, 2% to com
325         potSplit_[2] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
326         potSplit_[3] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
327     }
328     //==============================================================================
329     //     _ _  _  _|. |`. _  _ _  .
330     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
331     //==============================================================================
332     /**
333      * @dev used to make sure no one can interact with contract until it has
334      * been activated.
335      */
336     modifier isActivated() {
337         require(activated_ == true, "its not ready yet.  check ?eta in discord");
338         _;
339     }
340 
341     /**
342      * @dev prevents contracts from interacting with fomo3d
343      */
344     modifier isHuman() {
345         address _addr = msg.sender;
346         uint256 _codeLength;
347 
348         assembly {_codeLength := extcodesize(_addr)}
349         require(_codeLength == 0, "sorry humans only");
350         _;
351     }
352 
353     /**
354      * @dev sets boundaries for incoming tx
355      */
356     modifier isWithinLimits(uint256 _eth) {
357         require(_eth >= 1000000000, "pocket lint: not a valid currency");
358         require(_eth <= 100000000000000000000000, "no vitalik, no");
359         _;
360     }
361 
362     //==============================================================================
363     //     _    |_ |. _   |`    _  __|_. _  _  _  .
364     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
365     //====|=========================================================================
366     /**
367      * @dev emergency buy uses last stored affiliate ID and team snek
368      */
369     function()
370     isActivated()
371     isHuman()
372     isWithinLimits(msg.value)
373     public
374     payable
375     {
376         // set up our tx event data and determine if player is new or not
377         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
378 
379         // fetch player id
380         uint256 _pID = pIDxAddr_[msg.sender];
381 
382         // buy core
383         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
384     }
385 
386     /**
387      * @dev converts all incoming ethereum to keys.
388      * -functionhash- 0x8f38f309 (using ID for affiliate)
389      * -functionhash- 0x98a0871d (using address for affiliate)
390      * -functionhash- 0xa65b37a1 (using name for affiliate)
391      * @param _affCode the ID/address/name of the player who gets the affiliate fee
392      * @param _team what team is the player playing for?
393      */
394     function buyXid(uint256 _affCode, uint256 _team)
395     isActivated()
396     isHuman()
397     isWithinLimits(msg.value)
398     public
399     payable
400     {
401         // set up our tx event data and determine if player is new or not
402         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
403 
404         // fetch player id
405         uint256 _pID = pIDxAddr_[msg.sender];
406 
407         // manage affiliate residuals
408         // if no affiliate code was given or player tried to use their own, lolz
409         if (_affCode == 0 || _affCode == _pID)
410         {
411             // use last stored affiliate code
412             _affCode = plyr_[_pID].laff;
413 
414             // if affiliate code was given & its not the same as previously stored
415         } else if (_affCode != plyr_[_pID].laff) {
416             // update last affiliate
417             plyr_[_pID].laff = _affCode;
418         }
419 
420         // verify a valid team was selected
421         _team = verifyTeam(_team);
422 
423         // buy core
424         buyCore(_pID, _affCode, _team, _eventData_);
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
438     isActivated()
439     isHuman()
440     isWithinLimits(_eth)
441     public
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
456             // if affiliate code was given & its not the same as previously stored
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
469     /**
470      * @dev withdraws all of your earnings.
471      * -functionhash- 0x3ccfd60b
472      */
473     function withdraw()
474     isActivated()
475     isHuman()
476     public
477     {
478         // setup local rID
479         uint256 _rID = rID_;
480 
481         // grab time
482         uint256 _now = now;
483 
484         // fetch player ID
485         uint256 _pID = pIDxAddr_[msg.sender];
486 
487         // setup temp var for player eth
488         uint256 _eth;
489 
490         // check to see if round has ended and no one has run round end yet
491         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
492         {
493             // set up our tx event data
494             F3Ddatasets.EventReturns memory _eventData_;
495 
496             // end the round (distributes pot)
497             round_[_rID].ended = true;
498             _eventData_ = endRound(_eventData_);
499 
500             // get their earnings
501             _eth = withdrawEarnings(_pID);
502 
503             // gib moni
504             if (_eth > 0)
505                 plyr_[_pID].addr.transfer(_eth);
506 
507             // build event data
508             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
509             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
510 
511             // fire withdraw and distribute event
512             emit F3Devents.onWithdrawAndDistribute
513             (
514                 msg.sender,
515                 plyr_[_pID].name,
516                 _eth,
517                 _eventData_.compressedData,
518                 _eventData_.compressedIDs,
519                 _eventData_.winnerAddr,
520                 _eventData_.winnerName,
521                 _eventData_.amountWon,
522                 _eventData_.newPot,
523                 _eventData_.P3DAmount,
524                 _eventData_.genAmount
525             );
526 
527             // in any other situation
528         } else {
529             // get their earnings
530             _eth = withdrawEarnings(_pID);
531 
532             // gib moni
533             if (_eth > 0)
534                 plyr_[_pID].addr.transfer(_eth);
535 
536             // fire withdraw event
537             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
538         }
539     }
540 
541     /**
542      * @dev use these to register names.  they are just wrappers that will send the
543      * registration requests to the PlayerBook contract.  So registering here is the
544      * same as registering there.  UI will always display the last name you registered.
545      * but you will still own all previously registered names to use as affiliate
546      * links.
547      * - must pay a registration fee.
548      * - name must be unique
549      * - names will be converted to lowercase
550      * - name cannot start or end with a space
551      * - cannot have more than 1 space in a row
552      * - cannot be only numbers
553      * - cannot start with 0x
554      * - name must be at least 1 char
555      * - max length of 32 characters long
556      * - allowed characters: a-z, 0-9, and space
557      * -functionhash- 0x921dec21 (using ID for affiliate)
558      * -functionhash- 0x3ddd4698 (using address for affiliate)
559      * -functionhash- 0x685ffd83 (using name for affiliate)
560      * @param _nameString players desired name
561      * @param _affCode affiliate ID, address, or name of who referred you
562      * @param _all set to true if you want this to push your info to all games
563      * (this might cost a lot of gas)
564      */
565     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
566     isHuman()
567     public
568     payable
569     {
570         bytes32 _name = _nameString.nameFilter();
571         address _addr = msg.sender;
572         uint256 _paid = msg.value;
573         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
574 
575         uint256 _pID = pIDxAddr_[_addr];
576 
577         // fire event
578         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
579     }
580 
581     /*
582     function registerNameXaddr(string _nameString, address _affCode, bool _all)
583     isHuman()
584     public
585     payable
586     {
587         bytes32 _name = _nameString.nameFilter();
588         address _addr = msg.sender;
589         uint256 _paid = msg.value;
590         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
591 
592         uint256 _pID = pIDxAddr_[_addr];
593 
594         // fire event
595         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
596     }
597 
598     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
599     isHuman()
600     public
601     payable
602     {
603         bytes32 _name = _nameString.nameFilter();
604         address _addr = msg.sender;
605         uint256 _paid = msg.value;
606         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
607 
608         uint256 _pID = pIDxAddr_[_addr];
609 
610         // fire event
611         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
612     }
613     */
614 
615     //==============================================================================
616     //     _  _ _|__|_ _  _ _  .
617     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
618     //=====_|=======================================================================
619     /**
620      * @dev return the price buyer will pay for next 1 individual key.
621      * -functionhash- 0x018a25e8
622      * @return price for next key bought (in wei format)
623      */
624     function getBuyPrice()
625     public
626     view
627     returns(uint256)
628     {
629         // setup local rID
630         uint256 _rID = rID_;
631 
632         // are we in a round?
633         if (isRoundActive())
634             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
635         else // rounds over.  need price for new round
636             return ( keyPriceStart_ ); // init
637     }
638 
639     /**
640         is round in active?
641     */
642     function isRoundActive()
643     public
644     view
645     returns(bool)
646     {
647         // setup local rID
648         uint256 _rID = rID_;
649 
650         // grab time
651         uint256 _now = now;
652 
653         return _now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0));
654     }
655 
656     /**
657       回合结束但是还未触发大奖分配
658     */
659 //    function isRoundEnd()
660 //    public
661 //    view
662 //    returns(bool)
663 //    {
664 //        return now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0;
665 //    }
666 
667     /**
668      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
669      * provider
670      * -functionhash- 0xc7e284b8
671      * @return time left in seconds
672      */
673     function getTimeLeft()
674     public
675     view
676     returns(uint256)
677     {
678         // setup local rID
679         uint256 _rID = rID_;
680 
681         // grab time
682         uint256 _now = now;
683 
684         if (_now < round_[_rID].end)
685             if (_now > round_[_rID].strt + rndGap_)
686                 return( (round_[_rID].end).sub(_now) );
687             else
688                 return( (round_[_rID].strt + rndGap_).sub(_now) );
689         else
690             return(0);
691     }
692 
693     /**
694 //     * @dev returns player earnings per vaults
695 //     * -functionhash- 0x63066434
696 //     * @return winnings vault
697 //     * @return general vault
698 //     * @return affiliate vault
699 //     */
700     function getPlayerVaults(uint256 _pID)
701     public
702     view
703     returns(uint256 ,uint256, uint256, uint256, uint256)
704     {
705         // setup local rID
706         uint256 _rID = rID_;
707 
708         uint256 _ppt = 0;
709         //如果此轮结束但尚未触发分配，则分红得加上大奖池pot中的分红
710         if (now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0) {
711             _ppt = ((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000));
712             _ppt = _ppt / (round_[_rID].keys);
713         }
714 
715         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd, 0, 0, _ppt);
716         uint256 _keysOff = plyrRnds_[_pID][plyr_[_pID].lrnd].keysOff;
717         uint256 _ethOff = plyrRnds_[_pID][plyr_[_pID].lrnd].ethOff;
718 
719         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
720         //倒计时结束后，需要buy或者withdraw才能触发endround过程
721         if (_ppt > 0 && round_[_rID].plyr == _pID)
722         {
723             return
724             (
725             plyr_[_pID].win.add(((round_[_rID].pot).mul(winnerFee_)) / 100),
726             (plyr_[_pID].gen).add(_earnings[0]),
727             plyr_[_pID].aff,
728             _keysOff.add(_earnings[1]),
729             _ethOff.add(_earnings[2])
730             );
731         } else {
732             return
733             (
734             plyr_[_pID].win,
735             (plyr_[_pID].gen).add(_earnings[0]),
736             plyr_[_pID].aff,
737             _keysOff.add(_earnings[1]),
738             _ethOff.add(_earnings[2])
739             );
740         }
741     }
742 
743     /**
744      * solidity hates stack limits.  this lets us avoid that hate
745      */
746 //    function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
747 //    private
748 //    view
749 //    returns(uint256)
750 //    {
751 //        //当前大奖池分红的单key价值
752 //        uint256 _ppt = ((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys);
753 //        return(  ((((round_[_rID].mask).add(_ppt)).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
754 //    }
755 
756     /**
757      * @dev returns all current round info needed for front end
758      * -functionhash- 0x747dff42
759      * @return eth invested during ICO phase
760      * @return round id
761      * @return total keys for round
762      * @return time round ends
763      * @return time round started
764      * @return current pot
765      * @return current team ID & player ID in lead
766      * @return current player in leads address
767      * @return current player in leads name
768      * @return whales eth in for round
769      * @return bears eth in for round
770      * @return sneks eth in for round
771      * @return bulls eth in for round
772      * @return airdrop tracker # & airdrop pot
773      */
774     function getCurrentRoundInfo()
775     public
776     view
777     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
778     {
779         // setup local rID
780         uint256 _rID = rID_;
781 
782         return
783         (
784         round_[_rID].ico,               //0
785         _rID,                           //1
786         round_[_rID].keys,              //2
787         round_[_rID].end,               //3
788         round_[_rID].strt,              //4
789         round_[_rID].pot,               //5
790         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
791         plyr_[round_[_rID].plyr].addr,  //7
792         plyr_[round_[_rID].plyr].name,  //8
793         rndTmEth_[_rID][0],             //9
794         rndTmEth_[_rID][1],             //10
795         rndTmEth_[_rID][2],             //11
796         rndTmEth_[_rID][3],             //12
797         airDropTracker_ + (airDropPot_ * 1000)             //13
798         );
799     }
800 
801     /**
802      * @dev returns player info based on address.  if no address is given, it will
803      * use msg.sender
804      * -functionhash- 0xee0b5d8b
805      * @param _addr address of the player you want to lookup
806      * @return player ID
807      * @return player name
808      * @return keys owned (current round)
809      * @return winnings vault
810      * @return general vault
811      * @return affiliate vault
812 	 * @return player round eth
813      */
814     function getPlayerInfoByAddress(address _addr)
815     public
816     view
817     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
818     {
819         if (_addr == address(0))
820         {
821             _addr == msg.sender;
822         }
823         uint256 _pID = pIDxAddr_[_addr];
824 
825 
826         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd, 0, 0, 0);
827 
828         return
829         (
830         _pID,                               //0
831         plyr_[_pID].name,                   //1
832         plyrRnds_[_pID][rID_].keys,         //2
833         plyr_[_pID].win,                    //3
834         (plyr_[_pID].gen).add(_earnings[0]),//4
835         plyr_[_pID].aff,                    //5
836         plyrRnds_[_pID][rID_].eth,          //6
837         pIDxCards0_[_pID],                  //7
838         pIDxCards1_[_pID],                  //8
839         pIDxCards2_[_pID],                  //9
840         plyr_[_pID].laff                    //10
841         );
842     }
843 
844     //==============================================================================
845     //     _ _  _ _   | _  _ . _  .
846     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
847     //=====================_|=======================================================
848     /**
849      * @dev logic runs whenever a buy order is executed.  determines how to handle
850      * incoming eth depending on if we are in an active round or not
851      */
852     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
853     private
854     {
855         // setup local rID
856         uint256 _rID = rID_;
857 
858         // grab time
859         uint256 _now = now;
860 
861         // if round is active
862         if (isRoundActive())
863         {
864             // call core
865             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
866 
867             // if round is not active
868         } else {
869             // check to see if end round needs to be ran
870             if (_now > round_[_rID].end && round_[_rID].ended == false)
871             {
872                 // end the round (distributes pot) & start new round
873                 round_[_rID].ended = true;
874                 _eventData_ = endRound(_eventData_);
875 
876                 // build event data
877                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
878                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
879 
880                 // fire buy and distribute event
881                 emit F3Devents.onBuyAndDistribute
882                 (
883                     msg.sender,
884                     plyr_[_pID].name,
885                     msg.value,
886                     _eventData_.compressedData,
887                     _eventData_.compressedIDs,
888                     _eventData_.winnerAddr,
889                     _eventData_.winnerName,
890                     _eventData_.amountWon,
891                     _eventData_.newPot,
892                     _eventData_.P3DAmount,
893                     _eventData_.genAmount
894                 );
895             }
896 
897             // put eth in players vault
898             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
899         }
900     }
901 
902     /**
903      * @dev logic runs whenever a reload order is executed.  determines how to handle
904      * incoming eth depending on if we are in an active round or not
905      */
906     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
907     private
908     {
909         // setup local rID
910         uint256 _rID = rID_;
911 
912         // grab time
913         uint256 _now = now;
914 
915         // if round is active
916         if (isRoundActive())
917         {
918             // get earnings from all vaults and return unused to gen vault
919             // because we use a custom safemath library.  this will throw if player
920             // tried to spend more eth than they have.
921             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
922 
923             // call core
924             core(_rID, _pID, _eth, _affID, _team, _eventData_);
925 
926             // if round is not active and end round needs to be ran
927         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
928             // end the round (distributes pot) & start new round
929             round_[_rID].ended = true;
930             _eventData_ = endRound(_eventData_);
931 
932             // build event data
933             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
934             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
935 
936             // fire buy and distribute event
937             emit F3Devents.onReLoadAndDistribute
938             (
939                 msg.sender,
940                 plyr_[_pID].name,
941                 _eventData_.compressedData,
942                 _eventData_.compressedIDs,
943                 _eventData_.winnerAddr,
944                 _eventData_.winnerName,
945                 _eventData_.amountWon,
946                 _eventData_.newPot,
947                 _eventData_.P3DAmount,
948                 _eventData_.genAmount
949             );
950         }
951     }
952 
953     /**
954      * @dev this is the core logic for any buy/reload that happens while a round
955      * is live.
956      */
957     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
958     private
959     {
960         // if player is new to round
961         if (plyrRnds_[_pID][_rID].keys == 0)
962             _eventData_ = managePlayer(_pID, _eventData_);
963 
964         // early round eth limiter
965         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
966         {
967             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
968             uint256 _refund = _eth.sub(_availableLimit);
969             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
970             _eth = _availableLimit;
971         }
972 
973         // if eth left is greater than min eth allowed (sorry no pocket lint)
974         if (_eth > 1000000000)
975         {
976             // mint the new keys
977             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
978 
979             // if they bought at least 1 whole key
980             if (_keys >= 1000000000000000000)
981             {
982                 updateTimer(_keys, _rID);
983 
984                 // set new leaders
985                 if (round_[_rID].plyr != _pID && plyr_[round_[_rID].plyr].addr != owner)
986                     round_[_rID].plyr = _pID;
987                 if (round_[_rID].team != _team)
988                     round_[_rID].team = _team;
989 
990                 // set the new leader bool to true
991                 _eventData_.compressedData = _eventData_.compressedData + 100;
992             }
993 
994             // manage airdrops > 0.1ETH
995             if (_eth >= 100000000000000000)
996             {
997                 // gib muni
998                 uint256 _prize = 0;
999                 //抽牌
1000                 (_refund, _availableLimit) = drawCard(_pID);
1001                 if(pIDxCards0_[_pID] < 2 || pIDxCards2_[_pID] >= 2) {
1002                     pIDxCards0_[_pID] = _refund;
1003                     pIDxCards1_[_pID] = 0;
1004                     pIDxCards2_[_pID] = 0;
1005                 } else if(pIDxCards1_[_pID] >= 2) {
1006                     pIDxCards2_[_pID] = _refund;
1007                 } else if(pIDxCards0_[_pID] >= 2) {
1008                     pIDxCards1_[_pID] = _refund;
1009                 }
1010                 if(_availableLimit > 0) {
1011                     _prize = _eth.mul(_availableLimit);
1012                     //最多抽空奖池
1013                     if(_prize > airDropPot_) _prize = airDropPot_;
1014                 } else {
1015                     airDropTracker_++;
1016                     if (airdrop() == true)
1017                     {
1018                         if (_eth >= 10000000000000000000)
1019                         {
1020                             // calculate prize and give it to winner
1021                             _prize = ((airDropPot_).mul(bigAirdrop_)) / 100;
1022                             // let event know a tier 3 prize was won
1023                             _eventData_.compressedData += 300000000000000000000000000000000;
1024                         } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1025                             // calculate prize and give it to winner
1026                             _prize = ((airDropPot_).mul(midAirdrop_)) / 100;
1027                             // let event know a tier 2 prize was won
1028                             _eventData_.compressedData += 200000000000000000000000000000000;
1029                         } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1030                             // calculate prize and give it to winner
1031                             _prize = ((airDropPot_).mul(smallAirdrop_)) / 100;
1032                             // let event know a tier 3 prize was won
1033                             _eventData_.compressedData += 300000000000000000000000000000000;
1034                         }
1035                         // set airdrop happened bool to true
1036                         _eventData_.compressedData += 10000000000000000000000000000000;
1037                         // let event know how much was won
1038                         _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1039 
1040                         // reset air drop tracker
1041                         airDropTracker_ = 0;
1042                     }
1043                 }
1044 
1045                 if(_prize > 0) {
1046                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1047                     // adjust airDropPot
1048                     airDropPot_ = (airDropPot_).sub(_prize);
1049                 }
1050             }
1051 
1052             // store the air drop tracker number (number of buys since last airdrop)
1053             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1054 
1055             // update player
1056             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1057             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1058 
1059             // update round
1060             round_[_rID].keys = _keys.add(round_[_rID].keys);
1061             round_[_rID].eth = _eth.add(round_[_rID].eth);
1062             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1063 
1064             // distribute eth
1065             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1066             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1067 
1068             // call end tx function to fire end tx event.
1069             endTx(_pID, _team, _eth, _keys, _eventData_);
1070         }
1071     }
1072     //==============================================================================
1073     //     _ _ | _   | _ _|_ _  _ _  .
1074     //    (_(_||(_|_||(_| | (_)| _\  .
1075     //==============================================================================
1076     /**
1077      * @dev calculates unmasked earnings (just calculates, does not update mask)
1078      * @return earnings in wei format
1079      */
1080     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast, uint256 _subKeys, uint256 _subEth, uint256 _ppt)
1081     private
1082     view
1083     returns(uint256[])
1084     {
1085         uint256[] memory result = new uint256[](4);
1086 
1087         //实际可计算分红的keys数量，总数减去出局的keys数量
1088         uint256 _realKeys = ((plyrRnds_[_pID][_rIDlast].keys).sub(plyrRnds_[_pID][_rIDlast].keysOff)).sub(_subKeys);
1089         uint256 _investedEth = ((plyrRnds_[_pID][_rIDlast].eth).sub(plyrRnds_[_pID][_rIDlast].ethOff)).sub(_subEth);
1090 
1091         //玩家拥有的key价值 = 当前keys分红单价 * 实际可分红的keys数量
1092         uint256 _totalEarning = (((round_[_rIDlast].mask.add(_ppt))).mul(_realKeys)) / (1000000000000000000);
1093         _totalEarning = _totalEarning.sub(plyrRnds_[_pID][_rIDlast].mask);
1094 
1095         //是否到最大获利倍数
1096         if(_investedEth > 0 && _totalEarning.mul(100) / _investedEth >= maxEarningRate_) {
1097 
1098             result[0] = (_investedEth.mul(maxEarningRate_) / 100);
1099             result[0] = result[0].mul(100 - keysLeftRate_.mul(100) / maxEarningRate_) / 100;//出局的最大收益（减去复投的keys收益）
1100 
1101             result[1] = _realKeys.mul(100 - keysLeftRate_.mul(100) / maxEarningRate_) / 100;//出局的key数量(去掉留下复投的keys, 简单点，实际情况是留下的keys稍多)
1102 
1103             result[2] = _investedEth.mul(100 - keysLeftRate_.mul(100) / maxEarningRate_) / 100;//出局的eth数量
1104         } else {
1105             result[0] = _totalEarning;
1106             result[1] = 0;
1107             result[2] = 0;
1108         }
1109 
1110         //出局的收益，可以分配到pot中
1111         result[3] = _totalEarning.sub(result[0]);
1112 
1113         return( result );
1114     }
1115 
1116     /**
1117      * @dev returns the amount of keys you would get given an amount of eth.
1118      * -functionhash- 0xce89c80c
1119      * @param _rID round ID you want price for
1120      * @param _eth amount of eth sent in
1121      * @return keys received
1122      */
1123     function calcKeysReceived(uint256 _rID, uint256 _eth)
1124     public
1125     view
1126     returns(uint256)
1127     {
1128         // are we in a round?
1129         if (isRoundActive())
1130             return ( (round_[_rID].eth).keysRec(_eth) );
1131         else // rounds over.  need keys for new round
1132             return ( (_eth).keys() );
1133     }
1134 
1135     /**
1136      * @dev returns current eth price for X keys.
1137      * -functionhash- 0xcf808000
1138      * @param _keys number of keys desired (in 18 decimal format)
1139      * @return amount of eth needed to send
1140      */
1141     function iWantXKeys(uint256 _keys)
1142     public
1143     view
1144     returns(uint256)
1145     {
1146         // setup local rID
1147         uint256 _rID = rID_;
1148 
1149         // are we in a round?
1150         if (isRoundActive())
1151             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1152         else // rounds over.  need price for new round
1153             return ( (_keys).eth() );
1154     }
1155     //==============================================================================
1156     //    _|_ _  _ | _  .
1157     //     | (_)(_)|_\  .
1158     //==============================================================================
1159     /**
1160 	 * @dev receives name/player info from names contract
1161      */
1162     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1163     external
1164     {
1165         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1166         if (pIDxAddr_[_addr] != _pID)
1167             pIDxAddr_[_addr] = _pID;
1168         if (pIDxName_[_name] != _pID)
1169             pIDxName_[_name] = _pID;
1170         if (plyr_[_pID].addr != _addr)
1171             plyr_[_pID].addr = _addr;
1172         if (plyr_[_pID].name != _name)
1173             plyr_[_pID].name = _name;
1174         if (plyr_[_pID].laff != _laff)
1175             plyr_[_pID].laff = _laff;
1176         if (plyrNames_[_pID][_name] == false)
1177             plyrNames_[_pID][_name] = true;
1178     }
1179 
1180     /**
1181      * @dev receives entire player name list
1182      */
1183     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1184     external
1185     {
1186         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1187         if(plyrNames_[_pID][_name] == false)
1188             plyrNames_[_pID][_name] = true;
1189     }
1190 
1191     /**
1192      * @dev gets existing or registers new pID.  use this when a player may be new
1193      * @return pID
1194      */
1195     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1196     private
1197     returns (F3Ddatasets.EventReturns)
1198     {
1199         uint256 _pID = pIDxAddr_[msg.sender];
1200         // if player is new to this version of fomo3d
1201         if (_pID == 0)
1202         {
1203             // grab their player ID, name and last aff ID, from player names contract
1204             _pID = PlayerBook.getPlayerID(msg.sender);
1205             bytes32 _name = PlayerBook.getPlayerName(_pID);
1206             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1207 
1208             // set up player account
1209             pIDxAddr_[msg.sender] = _pID;
1210             plyr_[_pID].addr = msg.sender;
1211 
1212             if (_name != "")
1213             {
1214                 pIDxName_[_name] = _pID;
1215                 plyr_[_pID].name = _name;
1216                 plyrNames_[_pID][_name] = true;
1217             }
1218 
1219             if (_laff != 0 && _laff != _pID)
1220                 plyr_[_pID].laff = _laff;
1221 
1222             // set the new player bool to true
1223             _eventData_.compressedData = _eventData_.compressedData + 1;
1224         }
1225         return (_eventData_);
1226     }
1227 
1228     /**
1229      * @dev checks to make sure user picked a valid team.  if not sets team
1230      * to default (sneks)
1231      */
1232     function verifyTeam(uint256 _team)
1233     private
1234     pure
1235     returns (uint256)
1236     {
1237         if (_team < 0 || _team > 3)
1238             return(2);
1239         else
1240             return(_team);
1241     }
1242 
1243     /**
1244      * @dev decides if round end needs to be run & new round started.  and if
1245      * player unmasked earnings from previously played rounds need to be moved.
1246      */
1247     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1248     private
1249     returns (F3Ddatasets.EventReturns)
1250     {
1251         // if player has played a previous round, move their unmasked earnings
1252         // from that round to gen vault.
1253         if (plyr_[_pID].lrnd != 0)
1254             updateGenVault(_pID, plyr_[_pID].lrnd, 0, 0);
1255 
1256         // update player's last round played
1257         plyr_[_pID].lrnd = rID_;
1258 
1259         // set the joined round bool to true
1260         _eventData_.compressedData = _eventData_.compressedData + 10;
1261 
1262         return(_eventData_);
1263     }
1264 
1265     /**
1266      * @dev ends the round. manages paying out winner/splitting up pot
1267      */
1268     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1269     private
1270     returns (F3Ddatasets.EventReturns)
1271     {
1272         // setup local rID
1273         uint256 _rID = rID_;
1274 
1275         // grab our winning player and team id's
1276         uint256 _winPID = round_[_rID].plyr;
1277         uint256 _winTID = round_[_rID].team;
1278 
1279         // grab our pot amount
1280         uint256 _pot = round_[_rID].pot;
1281 
1282         // calculate our winner share, community rewards, gen share,
1283         // p3d share, and amount reserved for next pot
1284         uint256 _win = (_pot.mul(winnerFee_)) / 100;
1285         uint256 _com = (_pot.mul(comFee_)) / 100;
1286         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1287         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1288         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1289 
1290         // calculate ppt for round mask
1291         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1292         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1293         if (_dust > 0)
1294         {
1295             _gen = _gen.sub(_dust);
1296             _res = _res.add(_dust);
1297         }
1298 
1299         // pay our winner
1300         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1301 
1302         // community rewards
1303         //        if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1304         //        {
1305         //            // This ensures Team Just cannot influence the outcome of FoMo3D with
1306         //            // bank migrations by breaking outgoing transactions.
1307         //            // Something we would never do. But that's not the point.
1308         //            // We spent 2000$ in eth re-deploying just to patch this, we hold the
1309         //            // highest belief that everything we create should be trustless.
1310         //            // Team JUST, The name you shouldn't have to trust.
1311         //            _p3d = _p3d.add(_com);
1312         //            _com = 0;
1313         //        }
1314 
1315         // distribute gen portion to key holders
1316         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1317 
1318         // send share for p3d to divies.sol
1319         if (_p3d > 0) {
1320             if(address(Divies) != address(0)) {
1321                 Divies.deposit.value(_p3d)();
1322             } else {
1323                 _com = _com.add(_p3d);
1324                 _p3d = 0;
1325             }
1326         }
1327 
1328         //to team
1329         myWallet.transfer(_com);
1330 
1331         // prepare event data
1332         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1333         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1334         _eventData_.winnerAddr = plyr_[_winPID].addr;
1335         _eventData_.winnerName = plyr_[_winPID].name;
1336         _eventData_.amountWon = _win;
1337         _eventData_.genAmount = _gen;
1338         _eventData_.P3DAmount = _p3d;
1339         _eventData_.newPot = _res;
1340 
1341         // start next round
1342         rID_++;
1343         _rID++;
1344         round_[_rID].strt = now;
1345         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1346         round_[_rID].pot = _res;
1347 
1348         return(_eventData_);
1349     }
1350 
1351     /**
1352      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1353      */
1354     function updateGenVault(uint256 _pID, uint256 _rIDlast, uint256 _subKeys, uint256 _subEth)
1355     private
1356     {
1357         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, _rIDlast, _subKeys, _subEth, 0);
1358         if (_earnings[0] > 0)
1359         {
1360             // put in gen vault
1361             plyr_[_pID].gen = _earnings[0].add(plyr_[_pID].gen);
1362             // zero out their earnings by updating mask
1363             plyrRnds_[_pID][_rIDlast].mask = _earnings[0].add(plyrRnds_[_pID][_rIDlast].mask);
1364         }
1365         if(_earnings[1] > 0) {
1366             plyrRnds_[_pID][_rIDlast].keysOff = _earnings[1].add(plyrRnds_[_pID][_rIDlast].keysOff);
1367         }
1368         if(_earnings[2] > 0) {
1369             plyrRnds_[_pID][_rIDlast].ethOff = _earnings[2].add(plyrRnds_[_pID][_rIDlast].ethOff);
1370             plyrRnds_[_pID][_rIDlast].mask = _earnings[2].mul(keysLeftRate_) / (maxEarningRate_.sub(keysLeftRate_));
1371         }
1372 
1373         if(_earnings[3] > 0) {
1374             //多余收益进大奖池
1375             round_[rID_].pot = _earnings[3].add(round_[rID_].pot);
1376         }
1377     }
1378 
1379     /**
1380      * @dev updates round timer based on number of whole keys bought.
1381      */
1382     function updateTimer(uint256 _keys, uint256 _rID)
1383     private
1384     {
1385         // grab time
1386         uint256 _now = now;
1387 
1388         //当前总key数，每10000个keys减少倒计时60秒，最低不少于2小时
1389         uint256 _totalKeys = _keys.add(round_[_rID].keys);
1390         uint256 _times10k = _totalKeys / keysToReduceMaxTime_.mul(1000000000000000000);
1391         realRndMax_ = rndMax_.sub(_times10k.mul(reduceMaxTimeStep_));
1392         if(realRndMax_ < minMaxTime_) realRndMax_ = minMaxTime_;
1393 
1394         // calculate time based on number of keys bought
1395         uint256 _newTime;
1396         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1397             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1398         else
1399             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1400 
1401         // compare to max and set new end time
1402         if (_newTime < (realRndMax_).add(_now))
1403             round_[_rID].end = _newTime;
1404         else
1405             round_[_rID].end = realRndMax_.add(_now);
1406     }
1407 
1408     /**
1409      * @dev generates a random number between 0-99 and checks to see if thats
1410      * resulted in an airdrop win
1411      * @return do we have a winner?
1412      */
1413     function airdrop()
1414     private
1415     view
1416     returns(bool)
1417     {
1418         uint256 rnd = randInt(1000);
1419 
1420         return rnd < airDropTracker_;
1421     }
1422 
1423     /**
1424        Draw a card on invest
1425    */
1426     function drawCard(uint256 _pID)
1427     private
1428     view
1429     returns (uint256 _cardNum, uint256 _rewardNum)
1430     {
1431         uint256 _card0 = pIDxCards0_[_pID];
1432         uint256 _card1 = pIDxCards1_[_pID];
1433         uint256 _card2 = pIDxCards2_[_pID];
1434 
1435         uint256 card = 2 + randInt(54);
1436 
1437         uint256 reward = 0;
1438 
1439         //还没有卡牌或者已经3张卡牌，则从头开始
1440         if(_card0 < 2 || _card2 >= 2) {
1441 
1442         } else {
1443             uint256[] memory cardInfo = parseCard(card);
1444             uint256[] memory cardInfo0 = parseCard(_card0);
1445             uint256[] memory cardInfo1 = parseCard(_card1);
1446 
1447             //Kings
1448             if(cardInfo[0] == 4 && (cardInfo0[0] == 4 || cardInfo1[0] == 4)) {
1449                 card = 2 + randInt(52);
1450             //AAA
1451             } else if(cardInfo[1] == 14 && cardInfo0[1] == 14 && cardInfo1[1] == 14){
1452                 card = 2 + randInt(12);
1453             }
1454 
1455             cardInfo = parseCard(card);
1456 
1457             if(_card1 >= 2) {
1458                 //Bomb
1459                 if((cardInfo[1] == cardInfo0[1]) && (cardInfo[1] == cardInfo1[1])) {
1460                     reward = 66;
1461                 } else {
1462                     uint256[] memory numbers = new uint256[](3);
1463                     numbers[0] = cardInfo0[1];
1464                     numbers[1] = cardInfo1[1];
1465                     numbers[2] = cardInfo[1];
1466                     numbers = sortArray(numbers);
1467                     if(numbers[0] == numbers[1] + 1 && numbers[1] == numbers[2] + 1) {
1468                         reward = 6;
1469                     }
1470                 }
1471             } else if(_card0 >= 2) {
1472 
1473             }
1474         }
1475         return (card, reward);
1476     }
1477 
1478     function sortArray(uint256[] arr_)
1479     private
1480     pure
1481     returns (uint256 [] )
1482     {
1483         uint256 l = arr_.length;
1484         uint256[] memory arr = new uint256[] (l);
1485 
1486         for(uint i=0;i<l;i++)
1487         {
1488             arr[i] = arr_[i];
1489         }
1490 
1491         for(i =0;i<l;i++)
1492         {
1493             for(uint j =i+1;j<l;j++)
1494             {
1495                 if(arr[i]<arr[j])
1496                 {
1497                     uint256 temp= arr[j];
1498                     arr[j]=arr[i];
1499                     arr[i] = temp;
1500 
1501                 }
1502 
1503             }
1504         }
1505 
1506         return arr;
1507     }
1508 
1509     function parseCard(uint256 _card)
1510     private
1511     pure
1512     returns(uint256[]) {
1513         uint256[] memory r = new uint256[](2);
1514         if(_card < 2) {
1515             return r;
1516         }
1517         //card from 2 to 55
1518         //2 is card 2... 54小王  55大王
1519         uint256 color = (_card - 2) / 13;
1520         uint256 number = _card - color * 13;
1521         r[0] = color;
1522         r[1] = number;
1523         return r;
1524     }
1525     /**
1526        random int
1527     */
1528     function randInt(uint256 _range)
1529     private
1530     view
1531     returns(uint256)
1532     {
1533         uint256 seed = uint256(keccak256(abi.encodePacked(
1534 
1535                 (block.timestamp).add
1536                 (block.difficulty).add
1537                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1538                 (block.gaslimit).add
1539                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1540                 (block.number)
1541 
1542             )));
1543         return (seed - ((seed / _range) * _range));
1544     }
1545 
1546     /**
1547      * @dev distributes eth based on fees to com, aff, and p3d
1548      */
1549     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1550     private
1551     returns(F3Ddatasets.EventReturns)
1552     {
1553         // pay 2% out to community rewards
1554         uint256 _com = _eth.mul(comFee_) / 100;
1555         uint256 _p3d;
1556         //        if (!address(Jekyll_Island_Inc).call.value(_com)(bytes4(keccak256("deposit()"))))
1557         //        {
1558         //            // This ensures Team Just cannot influence the outcome of FoMo3D with
1559         //            // bank migrations by breaking outgoing transactions.
1560         //            // Something we would never do. But that's not the point.
1561         //            // We spent 2000$ in eth re-deploying just to patch this, we hold the
1562         //            // highest belief that everything we create should be trustless.
1563         //            // Team JUST, The name you shouldn't have to trust.
1564         //            _p3d = _com;
1565         //            _com = 0;
1566         //        }
1567 
1568         // pay 1% out to FoMo3D short or to com
1569         uint256 _long = _eth.mul(otherF3DFee_) / 100;
1570         if(address(otherF3D_) != address(0)) {
1571             otherF3D_.potSwap.value(_long)();
1572         } else {
1573             _com = _com.add(_long);
1574         }
1575 
1576         // distribute share to affiliate
1577         uint256 _aff = _eth.mul(affFee_) / 100;
1578 
1579         // decide what to do with affiliate share of fees
1580         // affiliate must not be self, and must have a name registered
1581         if (_affID != _pID && (!affNeedName_ || plyr_[_affID].name != '')) {
1582             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1583             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1584         } else {
1585             _p3d = _aff;
1586         }
1587 
1588         // pay out p3d
1589         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1590         if (_p3d > 0)
1591         {
1592             if(address(Divies) != address(0)) {
1593                 // deposit to divies.sol contract
1594                 Divies.deposit.value(_p3d)();
1595             } else {
1596                 _com = _com.add(_p3d);
1597                 _p3d = 0;
1598             }
1599             // set up event data
1600             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1601         }
1602 
1603         //to team
1604         myWallet.transfer(_com);
1605 
1606         return(_eventData_);
1607     }
1608 
1609     function potSwap()
1610     external
1611     payable
1612     {
1613         // setup local rID
1614         uint256 _rID = rID_ + 1;
1615 
1616         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1617         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1618     }
1619 
1620     /**
1621      * @dev distributes eth based on fees to gen and pot
1622      */
1623     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1624     private
1625     returns(F3Ddatasets.EventReturns)
1626     {
1627         // calculate gen share
1628         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1629 
1630         // toss 1% into airdrop pot
1631         uint256 _air = (_eth.mul(airdropFee_) / 100);
1632         airDropPot_ = airDropPot_.add(_air);
1633 
1634         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1635         uint256 _pot = _eth.sub(((_eth.mul(feesTotal_)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1636 
1637         // calculate pot
1638         _pot = _pot.sub(_gen);
1639 
1640         // distribute gen share (thats what updateMasks() does) and adjust
1641         // balances for dust.
1642         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys, _eth);
1643         if (_dust > 0)
1644             _gen = _gen.sub(_dust);
1645 
1646         // add eth to pot
1647         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1648 
1649         // set up event data
1650         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1651         _eventData_.potAmount = _pot;
1652 
1653         return(_eventData_);
1654     }
1655     /**
1656      * @dev updates masks for round and player when keys are bought
1657      * @return dust left over
1658      */
1659     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys, uint256 _eth)
1660     private
1661     returns(uint256)
1662     {
1663         uint256 _oldKeyValue = round_[_rID].mask;
1664         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1665         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1666         round_[_rID].mask = _ppt.add(_oldKeyValue);
1667 
1668         //更新收益，计算可能的收益溢出
1669         updateGenVault(_pID, plyr_[_pID].lrnd, _keys, _eth);
1670 
1671         // calculate player earning from their own buy (only based on the keys
1672         // they just bought).  & update player earnings mask
1673 //        uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1674 //        _pearn = ((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn);
1675 //        plyrRnds_[_pID][_rID].mask = (_pearn).add(plyrRnds_[_pID][_rID].mask);
1676 
1677         plyrRnds_[_pID][_rID].mask = (_oldKeyValue.mul(_keys) / (1000000000000000000)).add(plyrRnds_[_pID][_rID].mask);
1678 
1679         // calculate & return dust
1680         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1681     }
1682 
1683     /**
1684      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1685      * @return earnings in wei format
1686      */
1687     function withdrawEarnings(uint256 _pID)
1688     private
1689     returns(uint256)
1690     {
1691         // update gen vault
1692         updateGenVault(_pID, plyr_[_pID].lrnd, 0, 0);
1693 
1694         // from vaults
1695         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1696         if (_earnings > 0)
1697         {
1698             plyr_[_pID].win = 0;
1699             plyr_[_pID].gen = 0;
1700             plyr_[_pID].aff = 0;
1701         }
1702 
1703         return(_earnings);
1704     }
1705 
1706     /**
1707      * @dev prepares compression data and fires event for buy or reload tx's
1708      */
1709     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1710     private
1711     {
1712         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1713         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1714 
1715         emit F3Devents.onEndTx
1716         (
1717             _eventData_.compressedData,
1718             _eventData_.compressedIDs,
1719             plyr_[_pID].name,
1720             msg.sender,
1721             _eth,
1722             _keys,
1723             _eventData_.winnerAddr,
1724             _eventData_.winnerName,
1725             _eventData_.amountWon,
1726             _eventData_.newPot,
1727             _eventData_.P3DAmount,
1728             _eventData_.genAmount,
1729             _eventData_.potAmount,
1730             airDropPot_
1731         );
1732     }
1733     //==============================================================================
1734     //    (~ _  _    _._|_    .
1735     //    _)(/_(_|_|| | | \/  .
1736     //====================/=========================================================
1737     /** upon contract deploy, it will be deactivated.  this is a one time
1738      * use function that will activate the contract.  we do this so devs
1739      * have time to set things up on the web end                            **/
1740     bool public activated_ = false;
1741     function activate()
1742     onlyOwner
1743     public
1744     {
1745         // make sure that its been linked.
1746         //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1747 
1748         // can only be ran once
1749         require(activated_ == false, "fomo3d already activated");
1750 
1751         // activate the contract
1752         activated_ = true;
1753 
1754         // lets start first round
1755         rID_ = 1;
1756         round_[1].strt = now + rndExtra_ - rndGap_;
1757         round_[1].end = now + rndInit_ + rndExtra_;
1758     }
1759     function setOtherFomo(address _otherF3D)
1760     onlyOwner
1761     public
1762     {
1763         // make sure that it HASNT yet been linked.
1764         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1765 
1766         // set up other fomo3d (fast or long) for pot swap
1767         otherF3D_ = otherFoMo3D(_otherF3D);
1768     }
1769 }
1770 
1771 //==============================================================================
1772 //   __|_ _    __|_ _  .
1773 //  _\ | | |_|(_ | _\  .
1774 //==============================================================================
1775 library F3Ddatasets {
1776     //compressedData key
1777     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1778     // 0 - new player (bool)
1779     // 1 - joined round (bool)
1780     // 2 - new  leader (bool)
1781     // 3-5 - air drop tracker (uint 0-999)
1782     // 6-16 - round end time
1783     // 17 - winnerTeam
1784     // 18 - 28 timestamp
1785     // 29 - team
1786     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1787     // 31 - airdrop happened bool
1788     // 32 - airdrop tier
1789     // 33 - airdrop amount won
1790     //compressedIDs key
1791     // [77-52][51-26][25-0]
1792     // 0-25 - pID
1793     // 26-51 - winPID
1794     // 52-77 - rID
1795     struct EventReturns {
1796         uint256 compressedData;
1797         uint256 compressedIDs;
1798         address winnerAddr;         // winner address
1799         bytes32 winnerName;         // winner name
1800         uint256 amountWon;          // amount won
1801         uint256 newPot;             // amount in new pot
1802         uint256 P3DAmount;          // amount distributed to p3d
1803         uint256 genAmount;          // amount distributed to gen
1804         uint256 potAmount;          // amount added to pot
1805     }
1806     struct Player {
1807         address addr;   // player address
1808         bytes32 name;   // player name
1809         uint256 win;    // winnings vault
1810         uint256 gen;    // general vault
1811         uint256 aff;    // affiliate vault
1812         uint256 lrnd;   // last round played
1813         uint256 laff;   // last affiliate id used
1814     }
1815     struct PlayerRounds {
1816         uint256 eth;    // eth player has added to round (used for eth limiter)
1817         uint256 keys;   // keys
1818         uint256 keysOff;// keys kicked off
1819         uint256 ethOff; //  eth kicked off
1820         uint256 mask;   // player mask
1821         uint256 ico;    // ICO phase investment
1822     }
1823     struct Round {
1824         uint256 plyr;   // pID of player in lead
1825         uint256 team;   // tID of team in lead
1826         uint256 end;    // time ends/ended
1827         bool ended;     // has round end function been ran
1828         uint256 strt;   // time round started
1829         uint256 keys;   // keys
1830         uint256 eth;    // total eth in
1831         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1832         uint256 mask;   // global mask
1833         uint256 ico;    // total eth sent in during ICO phase
1834         uint256 icoGen; // total eth for gen during ICO phase
1835         uint256 icoAvg; // average key price for ICO phase
1836     }
1837     struct TeamFee {
1838         uint256 gen;    // % of buy in thats paid to key holders of current round
1839         uint256 p3d;    // % of buy in thats paid to p3d holders
1840     }
1841     struct PotSplit {
1842         uint256 gen;    // % of pot thats paid to key holders of current round
1843         uint256 p3d;    // % of pot thats paid to p3d holders
1844     }
1845 }
1846 
1847 //==============================================================================
1848 //  |  _      _ _ | _  .
1849 //  |<(/_\/  (_(_||(_  .
1850 //=======/======================================================================
1851 library F3DKeysCalcLong {
1852     using SafeMath for *;
1853     uint256 constant private keyPriceStart_ = 15000000000000000;
1854     uint256 constant private keyPriceStep_ = 10000000000000;
1855     /**
1856      * @dev calculates number of keys received given X eth
1857      * @param _curEth current amount of eth in contract
1858      * @param _newEth eth being spent
1859      * @return amount of ticket purchased
1860      */
1861     function keysRec(uint256 _curEth, uint256 _newEth)
1862     internal
1863     pure
1864     returns (uint256)
1865     {
1866         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1867     }
1868 
1869     /**
1870        当前keys数量为_curKeys，购买_sellKeys所需的eth
1871      * @dev calculates amount of eth received if you sold X keys
1872      * @param _curKeys current amount of keys that exist
1873      * @param _sellKeys amount of keys you wish to sell
1874      * @return amount of eth received
1875      */
1876     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1877     internal
1878     pure
1879     returns (uint256)
1880     {
1881         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1882     }
1883 
1884     /**
1885         解二次方程: eth总值 = n * 起始价 +  n*n*递增价/2
1886         _eth对应的key数量 = (开根号(起始价*起始价 + 2*递增价*_eth) - 起始价) / 递增价
1887      * @dev calculates how many keys would exist with given an amount of eth
1888      * @param _eth eth "in contract"
1889      * @return number of keys that would exist
1890      */
1891     function keys(uint256 _eth)
1892     internal
1893     pure
1894     returns(uint256)
1895     {
1896         return ((((keyPriceStart_).sq()).add((keyPriceStep_).mul(2).mul(_eth))).sqrt().sub(keyPriceStart_)).mul(1000000000000000000) / (keyPriceStep_);
1897     }
1898 
1899     /**
1900        _keys数量的key对应的 eth总值 = n * 起始价 +  n*n*递增价/2 + n*递增价/2
1901        按照原版 eth总值 = n * 起始价 +  n*n*递增价/2 少了一部分
1902      * @dev calculates how much eth would be in contract given a number of keys
1903      * @param _keys number of keys "in contract"
1904      * @return eth that would exists
1905      */
1906     function eth(uint256 _keys)
1907     public
1908     pure
1909     returns(uint256)
1910     {
1911         uint256 n = _keys / (1000000000000000000);
1912         //correct
1913         // return n.mul(keyPriceStart_).add((n.sq().mul(keyPriceStep_)) / (2)).add(n.mul(keyPriceStep_) / (2));
1914         //original
1915         return n.mul(keyPriceStart_).add((n.sq().mul(keyPriceStep_)) / (2));
1916     }
1917 }
1918 
1919 //==============================================================================
1920 //  . _ _|_ _  _ |` _  _ _  _  .
1921 //  || | | (/_| ~|~(_|(_(/__\  .
1922 //==============================================================================
1923 interface otherFoMo3D {
1924     function potSwap() external payable;
1925 }
1926 
1927 interface F3DexternalSettingsInterface {
1928     function getFastGap() external returns(uint256);
1929     function getLongGap() external returns(uint256);
1930     function getFastExtra() external returns(uint256);
1931     function getLongExtra() external returns(uint256);
1932     function getAffNeedName() external returns(bool);
1933 }
1934 
1935 interface DiviesInterface {
1936     function deposit() external payable;
1937 }
1938 
1939 interface JIincForwarderInterface {
1940     function deposit() external payable returns(bool);
1941     function status() external view returns(address, address, bool);
1942     function startMigration(address _newCorpBank) external returns(bool);
1943     function cancelMigration() external returns(bool);
1944     function finishMigration() external returns(bool);
1945     function setup(address _firstCorpBank) external;
1946 }
1947 
1948 interface PlayerBookInterface {
1949     function getPlayerID(address _addr) external returns (uint256);
1950     function getPlayerName(uint256 _pID) external view returns (bytes32);
1951     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1952     function getPlayerAddr(uint256 _pID) external view returns (address);
1953     function getNameFee() external view returns (uint256);
1954     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1955     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1956     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1957 }
1958 
1959 /**
1960 * @title -Name Filter- v0.1.9
1961 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
1962 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
1963 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
1964 *                                  _____                      _____
1965 *                                 (, /     /)       /) /)    (, /      /)          /)
1966 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
1967 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
1968 *          ┴ ┴                /   /          .-/ _____   (__ /
1969 *                            (__ /          (_/ (, /                                      /)™
1970 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
1971 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
1972 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
1973 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
1974 *              _       __    _      ____      ____  _   _    _____  ____  ___
1975 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
1976 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
1977 *
1978 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
1979 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
1980 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
1981 */
1982 
1983 library NameFilter {
1984     /**
1985      * @dev filters name strings
1986      * -converts uppercase to lower case.
1987      * -makes sure it does not start/end with a space
1988      * -makes sure it does not contain multiple spaces in a row
1989      * -cannot be only numbers
1990      * -cannot start with 0x
1991      * -restricts characters to A-Z, a-z, 0-9, and space.
1992      * @return reprocessed string in bytes32 format
1993      */
1994     function nameFilter(string _input)
1995     internal
1996     pure
1997     returns(bytes32)
1998     {
1999         bytes memory _temp = bytes(_input);
2000         uint256 _length = _temp.length;
2001 
2002         //sorry limited to 32 characters
2003         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
2004         // make sure it doesnt start with or end with space
2005         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
2006         // make sure first two characters are not 0x
2007         if (_temp[0] == 0x30)
2008         {
2009             require(_temp[1] != 0x78, "string cannot start with 0x");
2010             require(_temp[1] != 0x58, "string cannot start with 0X");
2011         }
2012 
2013         // create a bool to track if we have a non number character
2014         bool _hasNonNumber;
2015 
2016         // convert & check
2017         for (uint256 i = 0; i < _length; i++)
2018         {
2019             // if its uppercase A-Z
2020             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2021             {
2022                 // convert to lower case a-z
2023                 _temp[i] = byte(uint(_temp[i]) + 32);
2024 
2025                 // we have a non number
2026                 if (_hasNonNumber == false)
2027                     _hasNonNumber = true;
2028             } else {
2029                 require
2030                 (
2031                 // require character is a space
2032                     _temp[i] == 0x20 ||
2033                 // OR lowercase a-z
2034                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2035                 // or 0-9
2036                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
2037                     "string contains invalid characters"
2038                 );
2039                 // make sure theres not 2x spaces in a row
2040                 if (_temp[i] == 0x20)
2041                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2042 
2043                 // see if we have a character other than a number
2044                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2045                     _hasNonNumber = true;
2046             }
2047         }
2048 
2049         require(_hasNonNumber == true, "string cannot be only numbers");
2050 
2051         bytes32 _ret;
2052         assembly {
2053             _ret := mload(add(_temp, 32))
2054         }
2055         return (_ret);
2056     }
2057 }
2058 
2059 /**
2060  * @title SafeMath v0.1.9
2061  * @dev Math operations with safety checks that throw on error
2062  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2063  * - added sqrt
2064  * - added sq
2065  * - added pwr
2066  * - changed asserts to requires with error log outputs
2067  * - removed div, its useless
2068  */
2069 library SafeMath {
2070 
2071     /**
2072     * @dev Multiplies two numbers, throws on overflow.
2073     */
2074     function mul(uint256 a, uint256 b)
2075     internal
2076     pure
2077     returns (uint256 c)
2078     {
2079         if (a == 0) {
2080             return 0;
2081         }
2082         c = a * b;
2083         require(c / a == b, "SafeMath mul failed");
2084         return c;
2085     }
2086 
2087     /**
2088     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2089     */
2090     function sub(uint256 a, uint256 b)
2091     internal
2092     pure
2093     returns (uint256)
2094     {
2095         require(b <= a, "SafeMath sub failed");
2096         return a - b;
2097     }
2098 
2099     /**
2100     * @dev Adds two numbers, throws on overflow.
2101     */
2102     function add(uint256 a, uint256 b)
2103     internal
2104     pure
2105     returns (uint256 c)
2106     {
2107         c = a + b;
2108         require(c >= a, "SafeMath add failed");
2109         return c;
2110     }
2111 
2112     /**
2113      * @dev gives square root of given x.
2114      */
2115     function sqrt(uint256 x)
2116     internal
2117     pure
2118     returns (uint256 y)
2119     {
2120         uint256 z = ((add(x,1)) / 2);
2121         y = x;
2122         while (z < y)
2123         {
2124             y = z;
2125             z = ((add((x / z),z)) / 2);
2126         }
2127     }
2128 
2129     /**
2130      * @dev gives square. multiplies x by x
2131      */
2132     function sq(uint256 x)
2133     internal
2134     pure
2135     returns (uint256)
2136     {
2137         return (mul(x,x));
2138     }
2139 
2140     /**
2141      * @dev x to the power of y
2142      */
2143     function pwr(uint256 x, uint256 y)
2144     internal
2145     pure
2146     returns (uint256)
2147     {
2148         if (x==0)
2149             return (0);
2150         else if (y==0)
2151             return (1);
2152         else
2153         {
2154             uint256 z = x;
2155             for (uint256 i=1; i < y; i++)
2156                 z = mul(z,x);
2157             return (z);
2158         }
2159     }
2160 }