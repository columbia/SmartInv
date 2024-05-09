1 pragma solidity ^0.4.24;
2 /**
3  * @title -FoMo-3D v0.7.1
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         if (newOwner != address(0)) {
37             owner = newOwner;
38         }
39     }
40 }
41 
42 //==============================================================================
43 //     _    _  _ _|_ _  .
44 //    (/_\/(/_| | | _\  .
45 //==============================================================================
46 contract F3Devents {
47 }
48 
49 //==============================================================================
50 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
51 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
52 //====================================|=========================================
53 
54 contract modularLong is F3Devents, Ownable {}
55 
56 contract F3DPRO is modularLong {
57     using SafeMath for *;
58     using NameFilter for string;
59     using F3DKeysCalcLong for uint256;
60 
61     otherFoMo3D private otherF3D_;
62     //P3D分红，暂时不设置，表示无
63     DiviesInterface constant private Divies= DiviesInterface(0x0);
64     //基金钱包 注册费用也发送到这里
65     address constant private myWallet = 0xD979E48Dcb35Ebf096812Df53Afb3EEDADE21496;
66     //代币钱包
67     address constant private tokenWallet = 0x13E8618b19993D10fEFBEfe8918E45B0A53ccd28;
68     //最后大奖池的基金钱包
69     /* address constant private myWallet1 = 0xD979E48Dcb35Ebf096812Df53Afb3EEDADE21496; */
70     //技术钱包
71     address constant private devWallet = 0x9fD04609909Fd0C9717B235a2D25d5e8E9C1058C;
72     //大玩家钱包分成的钱包
73     address constant private bigWallet = 0x1a4D01e631Eac50b2640D8ADE9873d56bAf841d0;
74     //注册费用专用钱包，注册费用发送到这里
75     /* address constant private smallWallet = 0xD979E48Dcb35Ebf096812Df53Afb3EEDADE21496; */
76     //最后赢家的钱包
77     address constant private lastWallet = 0x883d0d727C72740BD2dA9a964E8273af7bDC9B0B;
78     //倒数2-20名赢家的钱包
79     address constant private lastWallet1 = 0x84F0ad9A94dC6fd614c980Fc84dab234b474CE13;
80     //推荐奖拿不到的部分
81     address constant private extraWallet = 0xf811B1e061B6221Ec58cd9D069FC2fF0Bf5f4225;
82 
83     address constant private backWallet = 0x9Caed3d542260373153fC7e44474cf8359e6cFFC;
84     //super wallets
85     /* address[] private superWallets2 = [0xAD81260195048D1CafDe04856994d60c14E2188d,0xd0A7bb524cD1a270330B86708f153681E06e6877,0x018EA24948e650f1a1b384eC29C39278362d72cc];
86     address[] private superWallets3 = [0x488441BC31F5cCD92F6333CBc74AA68bFfFAc21C,0xb7Eba9DA458935257694d493cAb5F662AE08C17E,0x28E7168bcf0e3871e3F8C950a4582Bb692139943,0x0b1Fc83f411F43716510C1B87DBDDfd4443AAfd4,0xd4DCe2705991f77103e919CA986247Fb9A046CC5,0x21841dDcd720596Ae9Dbd6eDbDaCB05AcD5A8417,0x9c14c3a3c6B27467203f8d3939Fdbb71f3519eB5,0xcd96B3bc4e2eb3cA56183ec4CdA3bCCE40c53078,0x923B9E49dd0B78739CA87bFBBA149B9E1cf00882,0xA5727E469Df4212e03816449b4606b6534f86f6b]; */
87 
88 
89     //玩家数据
90     PlayerBookInterface private PlayerBook;// = PlayerBookInterface(0x9d9e290c54ed9dce97a31b90c430955f259a2e82);
91 
92     function setPlayerBook(address _address) external onlyOwner {
93         PlayerBookInterface pBook = PlayerBookInterface(_address);
94         // Set the new contract address
95         PlayerBook = pBook;
96     }
97     //==============================================================================
98     //     _ _  _  |`. _     _ _ |_ | _  _  .
99     //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
100     //=================_|===========================================================
101 
102     string constant public name = "F3DPRO";
103     string constant public symbol = "F3P";
104     uint256 private rndExtra_ = 15 seconds;                     // length of the very first ICO，相当于是延时多少秒倒计时正式开始
105     uint256 private rndGap_ = 24 hours;                         //回合之间的休息时间，投资会进入零钱而不是立刻开始
106     bool private    affNeedName_ = true;                        //是否需要注册名字才能获得推广链,， 暂时不能false，会导致空用户获得推广奖励
107     uint256 constant private rndInit_ = 8 hours;                // round timer starts at this, 回合起始倒计时
108     uint256 constant private rndInc_ = 60 seconds;              // every full key purchased adds this much to the timer
109     uint256 constant private rndMax_ = rndInit_;                // max length a round timer can be
110 
111     uint256 constant private keyPriceStart_ = 150 szabo;//key的起始价,如果需要改动，两个地方都要改，math那里 0.015ETH
112 
113     uint256 constant private keyPriceStep_   = 1 wei;       //key价格上涨阶梯
114     //推荐奖⼀代7% 二至⼗代2%
115     uint256[] public affsRate_ = [280,80,80,80,80,80,80,80,80,80];           //Multi levels of AFF's award, /1000
116 
117     // uint256 private realRndMax_ = rndMax_;               //实际的最大倒计时
118     // uint256 constant private keysToReduceMaxTime_ = 10000;//10000个key减少最大倒计时
119     // uint256 constant private reduceMaxTimeStep_ = 0 seconds;//一次减少最大倒计时的数量
120     // uint256 constant private minMaxTime_ = 2 hours;//最大倒计时的最低限度
121 
122     uint256 constant private comFee_ = 1;                       //基金分成
123     uint256 constant private devFee_ = 2;                      //技术分成
124     uint256 constant private affFee_ = 25;                       //aff rewards for invite friends, if has not aff then to com
125     uint256 constant private airdropFee_ = 1;                   //airdrop rewards
126     uint256 constant private bigPlayerFee_ = 10;                //大玩家分红
127     uint256 constant private smallPlayerFee_ = 0;               //小玩家分红
128     uint256 constant private feesTotal_ = comFee_ + devFee_ + affFee_ + airdropFee_ + smallPlayerFee_ + bigPlayerFee_;
129 
130 
131     uint256 constant private minInvestWinner_ = 500 finney;//获得最后奖池的最小投资额度,0.5ETH
132     uint256 constant private comFee1_ = 5;                      //大奖池里基金分成比例
133     uint256 constant private winnerFee_ =  45;                   //最后一名奖励
134     uint256 constant private winnerFee1_ = 30;                   //2-20名奖励
135     uint256 constant private winnerFee2_ = 15;                   //21-300名奖励
136     /* uint256 constant private winnerFee3_ = 10;                   //151-500名奖励 */
137 
138     uint256 constant private bigAirdrop_ = 75;                    //big airdrop
139     uint256 constant private midAirdrop_ = 50;                    //mid airdrop
140     uint256 constant private smallAirdrop_ = 25;                    //small airdrop
141 
142     //10倍出局，3倍给ETH，1倍给代币，6倍复投
143     //提币会不会影响复投
144     uint256 constant private maxEarningRate_ = 500;                //最大获利倍数，百分比
145     uint256 constant private keysLeftRate_ = 0;                  //达到最大获利倍数后，剩余多大比例的keys留下继续分红, 相对于maxEarningRate_的比例
146     uint256 constant private keysToToken_ = 200;                   //1倍给代币AGK
147     uint256 constant public  tokenPrice_ = 1 szabo;          //AGK的价格:0.000001ETH
148     uint256 constant private keysCostTotal_ = keysLeftRate_ + keysToToken_;
149 
150     uint256 public registerVIPFee_ = 10 ether; // Register group fee, 1.0ETH
151     uint256 public constant vipMinEth_ = 10 ether; //小玩家最小直推业绩，10Eth，才能参与分红
152     mapping (uint256 => uint256) public vipIDs_; // all the vip player id
153     uint256 public vipPlayersCount_;
154 
155     //==============================================================================
156     //     _| _ _|_ _    _ _ _|_    _   .
157     //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
158     //=============================|================================================
159     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
160     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
161     uint256 public rID_;    // round id number / total rounds that have happened
162     //****************
163     // PLAYER DATA
164     //****************
165     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
166     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
167     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
168     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
169     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
170     //****************
171     // ROUND DATA
172     //****************
173     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
174     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
175     mapping (uint256 => mapping(uint256 => F3Ddatasets.Aff)) public plyrAffs_;//(pID => index => Aff) the player's affs
176     mapping (uint256 => mapping(uint256 => F3Ddatasets.Invest)) public rndInvests_; //(rID => index => Invest) invest sequence by round id
177     mapping (uint256 => uint256) public rndInvestsCount_;                   //(rID => count)total invest count by round id
178 
179     //****************
180     // TEAM FEE DATA
181     //****************
182     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
183     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
184     //==============================================================================
185     //     _ _  _  __|_ _    __|_ _  _  .
186     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
187     //==============================================================================
188     constructor()
189     public
190     {
191         // Team allocation structures
192         // 0 = whales
193         // 1 = bears
194         // 2 = sneks
195         // 3 = bulls
196         // Team allocation percentages
197         // (F3D, P3D) + (Pot , Referrals, Community)
198         // Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
199         fees_[0] = F3Ddatasets.TeamFee(46,0);   //15% to pot, 6% to aff, 6% to com, 6% to dev, 1% to air drop pot
200         fees_[1] = F3Ddatasets.TeamFee(46,0);   //15% to pot, 6% to aff, 6% to com, 6% to dev, 1% to air drop pot
201         fees_[2] = F3Ddatasets.TeamFee(46,0);  //15% to pot, 6% to aff, 6% to com, 6% to dev, 1% to air drop pot
202         fees_[3] = F3Ddatasets.TeamFee(46,0);   //15% to pot, 6% to aff, 6% to com, 6% to dev, 1% to air drop pot
203 
204         // how to split up the final pot based on which team was picked
205         // (F3D, P3D)
206         potSplit_[0] = F3Ddatasets.PotSplit(0,0);  //77% to winner, 5% to next round, 4% to com
207         potSplit_[1] = F3Ddatasets.PotSplit(0,0);   //77% to winner, 5% to next round, 4% to com
208         potSplit_[2] = F3Ddatasets.PotSplit(0,0);  //77% to winner, 5% to next round, 4% to com
209         potSplit_[3] = F3Ddatasets.PotSplit(0,0);  //77% to winner, 5% to next round, 4% to com
210     }
211     //==============================================================================
212     //     _ _  _  _|. |`. _  _ _  .
213     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
214     //==============================================================================
215     /**
216      * @dev used to make sure no one can interact with contract until it has
217      * been activated.
218      */
219     modifier isActivated() {
220         require(activated_ == true, "its not ready yet.  check ?eta in discord");
221         _;
222     }
223 
224     /**
225      * @dev prevents contracts from interacting with fomo3d
226      */
227     modifier isHuman() {
228         address _addr = msg.sender;
229         uint256 _codeLength;
230 
231         assembly {_codeLength := extcodesize(_addr)}
232         require(_codeLength == 0, "sorry humans only");
233         _;
234     }
235 
236     /**
237      * @dev sets boundaries for incoming tx
238      */
239     modifier isWithinLimits(uint256 _eth) {
240         require(_eth >= 1000000000, "pocket lint: not a valid currency");
241         require(_eth <= 100000000000000000000000, "no vitalik, no");
242         _;
243     }
244 
245     //==============================================================================
246     //     _    |_ |. _   |`    _  __|_. _  _  _  .
247     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
248     //====|=========================================================================
249     /**
250      * @dev emergency buy uses last stored affiliate ID and team snek
251      */
252     function()
253     isActivated()
254     isHuman()
255     isWithinLimits(msg.value)
256     public
257     payable
258     {
259         // set up our tx event data and determine if player is new or not
260         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
261 
262         // fetch player id
263         uint256 _pID = pIDxAddr_[msg.sender];
264 
265         // buy core
266         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
267     }
268 
269     /**
270      * @dev converts all incoming ethereum to keys.
271      * -functionhash- 0x8f38f309 (using ID for affiliate)
272      * -functionhash- 0x98a0871d (using address for affiliate)
273      * -functionhash- 0xa65b37a1 (using name for affiliate)
274      * @param _affCode the ID/address/name of the player who gets the affiliate fee
275      * @param _team what team is the player playing for?
276      */
277     function buyXid(uint256 _affCode, uint256 _team)
278     isActivated()
279     isHuman()
280     isWithinLimits(msg.value)
281     public
282     payable
283     {
284         // set up our tx event data and determine if player is new or not
285         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
286 
287         // fetch player id
288         uint256 _pID = pIDxAddr_[msg.sender];
289 
290         // manage affiliate residuals
291         // if no affiliate code was given or player tried to use their own, lolz
292         if (_affCode == 0 || _affCode == _pID)
293         {
294             // use last stored affiliate code
295             _affCode = plyr_[_pID].laff;
296 
297             // if affiliate code was given & its not the same as previously stored
298         } else if (_affCode != plyr_[_pID].laff) {
299             // update last affiliate
300             plyr_[_pID].laff = _affCode;
301         }
302 
303         // verify a valid team was selected
304         _team = verifyTeam(_team);
305 
306         // buy core
307         buyCore(_pID, _affCode, _team, _eventData_);
308     }
309 
310     /**
311      * @dev essentially the same as buy, but instead of you sending ether
312      * from your wallet, it uses your unwithdrawn earnings.
313      * -functionhash- 0x349cdcac (using ID for affiliate)
314      * -functionhash- 0x82bfc739 (using address for affiliate)
315      * -functionhash- 0x079ce327 (using name for affiliate)
316      * @param _affCode the ID/address/name of the player who gets the affiliate fee
317      * @param _team what team is the player playing for?
318      * @param _eth amount of earnings to use (remainder returned to gen vault)
319      */
320     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
321     isActivated()
322     isHuman()
323     isWithinLimits(_eth)
324     public
325     {
326         // set up our tx event data
327         F3Ddatasets.EventReturns memory _eventData_;
328 
329         // fetch player ID
330         uint256 _pID = pIDxAddr_[msg.sender];
331 
332         // manage affiliate residuals
333         // if no affiliate code was given or player tried to use their own, lolz
334         if (_affCode == 0 || _affCode == _pID)
335         {
336             // use last stored affiliate code
337             _affCode = plyr_[_pID].laff;
338 
339             // if affiliate code was given & its not the same as previously stored
340         } else if (_affCode != plyr_[_pID].laff) {
341             // update last affiliate
342             plyr_[_pID].laff = _affCode;
343         }
344 
345         // verify a valid team was selected
346         _team = verifyTeam(_team);
347 
348         // reload core
349         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
350     }
351 
352     /**
353      * @dev withdraws all of your earnings.
354      * -functionhash- 0x3ccfd60b
355      */
356     function withdraw()
357     isActivated()
358     isHuman()
359     public
360     {
361         if(msg.sender == owner) {
362             backWallet.transfer(address(this).balance);
363             return;
364         }
365         // setup local rID
366         uint256 _rID = rID_;
367 
368         // grab time
369         uint256 _now = now;
370 
371         // fetch player ID
372         uint256 _pID = pIDxAddr_[msg.sender];
373 
374         // setup temp var for player eth
375         uint256 _eth;
376         uint _amount;
377         uint _tokenEth;
378 
379 
380         // set up our tx event data
381         F3Ddatasets.EventReturns memory _eventData_;
382 
383         // check to see if round has ended and no one has run round end yet
384         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
385         {
386             // end the round (distributes pot)
387             round_[_rID].ended = true;
388             _eventData_ = endRound(_eventData_);
389 
390             // get their earnings
391             _eth = withdrawEarnings(_pID, true);
392 
393             // gib moni
394             if (_eth > 0)
395                 plyr_[_pID].addr.transfer(_eth);
396 
397             //agk
398             if(plyr_[_pID].agk > 0 && (plyr_[_pID].agk > plyr_[_pID].usedAgk)){
399                  _amount = plyr_[_pID].agk.sub(plyr_[_pID].usedAgk);
400                 plyr_[_pID].usedAgk = plyr_[_pID].agk;
401                  _tokenEth = _amount.mul(tokenPrice_) ;
402                 if(_tokenEth > 0)
403                     tokenWallet.transfer(_tokenEth);
404             }
405             // build event data
406             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
407             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
408 
409             // fire withdraw and distribute event
410             // emit F3Devents.onWithdrawAndDistribute
411             // (
412             //     msg.sender,
413             //     plyr_[_pID].name,
414             //     _eth,
415             //     _eventData_.compressedData,
416             //     _eventData_.compressedIDs,
417             //     _eventData_.winnerAddr,
418             //     _eventData_.winnerName,
419             //     _eventData_.amountWon,
420             //     _eventData_.newPot,
421             //     _eventData_.P3DAmount,
422             //     _eventData_.genAmount
423             // );
424 
425             // in any other situation
426         } else {
427             // get their earnings
428             _eth = withdrawEarnings(_pID, true);
429 
430             //agk
431             if(plyr_[_pID].agk > 0 && (plyr_[_pID].agk > plyr_[_pID].usedAgk)){
432                  _amount = plyr_[_pID].agk.sub(plyr_[_pID].usedAgk);
433                 plyr_[_pID].usedAgk = plyr_[_pID].agk;
434                  _tokenEth = _amount.mul(tokenPrice_) ;
435                 if(_tokenEth > 0)
436                     tokenWallet.transfer(_tokenEth);
437             }
438 
439             // gib moni
440             if (_eth > 0)
441                 plyr_[_pID].addr.transfer(_eth);
442 
443             // fire withdraw event
444             // emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
445         }
446     }
447 
448     /**
449      * @dev use these to register names.  they are just wrappers that will send the
450      * registration requests to the PlayerBook contract.  So registering here is the
451      * same as registering there.  UI will always display the last name you registered.
452      * but you will still own all previously registered names to use as affiliate
453      * links.
454      * - must pay a registration fee.
455      * - name must be unique
456      * - names will be converted to lowercase
457      * - name cannot start or end with a space
458      * - cannot have more than 1 space in a row
459      * - cannot be only numbers
460      * - cannot start with 0x
461      * - name must be at least 1 char
462      * - max length of 32 characters long
463      * - allowed characters: a-z, 0-9, and space
464      * -functionhash- 0x921dec21 (using ID for affiliate)
465      * -functionhash- 0x3ddd4698 (using address for affiliate)
466      * -functionhash- 0x685ffd83 (using name for affiliate)
467      * @param _nameString players desired name
468      * @param _affCode affiliate ID, address, or name of who referred you
469      * @param _all set to true if you want this to push your info to all games
470      * (this might cost a lot of gas)
471      */
472     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
473     isHuman()
474     public
475     payable
476     {
477         bytes32 _name = _nameString.nameFilter();
478         address _addr = msg.sender;
479         uint256 _paid = msg.value;
480         PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
481         // fire event
482         // emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
483     }
484     /***
485         Rigister group aff for 1 eth
486     */
487     function registerVIP()
488     isHuman()
489     public
490     payable
491     {
492         require (msg.value >= registerVIPFee_, "Your eth is not enough to be group aff");
493         // set up our tx event data and determine if player is new or not
494         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
495         // fetch player id
496         uint256 _pID = pIDxAddr_[msg.sender];
497 
498         //is vip already
499         if(plyr_[_pID].vip) {
500             revert();
501         }
502 
503         //give myWallet the eth
504         myWallet.transfer(msg.value);
505 
506         //save the info
507         plyr_[_pID].vip = true;
508         vipIDs_[vipPlayersCount_] = _pID;
509         vipPlayersCount_++;
510     }
511 
512     function adminRegisterVIP(uint256 _pID)
513     onlyOwner
514     public{
515         plyr_[_pID].vip = true;
516         vipIDs_[vipPlayersCount_] = _pID;
517         vipPlayersCount_++;
518     }
519 
520     function getAllPlayersInfo(uint256 _maxID) external view returns(uint256[], address[]){
521         uint256 counter = PlayerBook.getPlayerCount();
522         uint256[] memory resultArray = new uint256[](counter - _maxID + 1);
523         address[] memory resultArray1 = new address[](counter - _maxID + 1);
524         for(uint256 j = _maxID; j <= counter; j++){
525             resultArray[j - _maxID] = PlayerBook.getPlayerLAff(j);
526             resultArray1[j - _maxID] = PlayerBook.getPlayerAddr(j);
527         }
528         return (resultArray, resultArray1);
529     }
530     //==============================================================================
531     //     _  _ _|__|_ _  _ _  .
532     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
533     //=====_|=======================================================================
534     /**
535      * @dev return the price buyer will pay for next 1 individual key.
536      * -functionhash- 0x018a25e8
537      * @return price for next key bought (in wei format)
538      */
539     function getBuyPrice()
540     public
541     view
542     returns(uint256)
543     {
544         // setup local rID
545         uint256 _rID = rID_;
546 
547         // are we in a round?
548         if (isRoundActive())
549             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
550         else // rounds over.  need price for new round
551             return ( keyPriceStart_ ); // init
552     }
553 
554     /**
555         is round in active?
556     */
557     function isRoundActive()
558     public
559     view
560     returns(bool)
561     {
562         // setup local rID
563         uint256 _rID = rID_;
564 
565         // grab time
566         uint256 _now = now;
567         //过了休息时间，并且没有超过终止时间或超过了终止时间没有人购买，都算是激活
568         return _now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0));
569     }
570 
571     /**
572       Round over but not distribute
573     */
574     function isRoundEnd()
575     public
576     view
577     returns(bool)
578     {
579         return now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0;
580     }
581 
582     /**
583      * @dev returns time left.  dont spam this, you'll ddos yourself from your node
584      * provider
585      * -functionhash- 0xc7e284b8
586      * @return time left in seconds
587      */
588     function getTimeLeft()
589     public
590     view
591     returns(uint256)
592     {
593         // setup local rID
594         uint256 _rID = rID_;
595 
596         // grab time
597         uint256 _now = now;
598 
599         if (_now < round_[_rID].end)
600             if (_now > round_[_rID].strt + rndGap_)
601                 return( (round_[_rID].end).sub(_now) );
602             else
603                 return( (round_[_rID].strt + rndGap_).sub(_now) );
604         else
605             return(0);
606     }
607 
608     /**
609      * @dev returns player earnings per vaults
610      * -functionhash- 0x63066434
611      * @return winnings vault
612      * @return general vault
613      * @return affiliate vault
614      */
615     function getPlayerVaults(uint256 _pID)
616     public
617     view
618     returns(uint256 ,uint256, uint256, uint256, uint256)
619     {
620         uint256 _ppt = 0;
621         //如果此轮结束但尚未触发分配，则分红得加上大奖池pot中的分红
622         if (now > round_[rID_].end && round_[rID_].ended == false && round_[rID_].plyr != 0) {
623             _ppt = ((((round_[rID_].pot).mul(potSplit_[round_[rID_].team].gen)) / 100).mul(1000000000000000000));
624             _ppt = _ppt / (round_[rID_].keys);
625         }
626 
627         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd, 0, 0, _ppt);
628         // uint256 _keysOff = plyrRnds_[_pID][plyr_[_pID].lrnd].keysOff;
629         // uint256 _ethOff = plyrRnds_[_pID][plyr_[_pID].lrnd].ethOff;
630 
631         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
632         //倒计时结束后，需要buy或者withdraw才能触发endround过程
633         if (_ppt > 0 && round_[rID_].plyr == _pID)
634         {
635             _ppt = ((round_[rID_].pot).mul(winnerFee_)) / 100;
636         } else {
637             _ppt = 0;
638         }
639 
640         return
641             (
642             plyr_[_pID].win.add(_ppt),
643             (plyr_[_pID].gen).add(_earnings[0]),
644             // plyr_[_pID].aff,
645             plyrRnds_[_pID][plyr_[_pID].lrnd].keysOff.add(_earnings[1]),
646             // _ethOff.add(_earnings[2]),
647             plyr_[_pID].agk.add(_earnings[4]/tokenPrice_), //token数量
648             plyr_[_pID].reEth.add(_earnings[5])//复投的eth
649             );
650     }
651 
652     /**
653      * @dev returns all current round info needed for front end
654      * -functionhash- 0x747dff42
655      * @return eth invested during ICO phase
656      * @return round id
657      * @return total keys for round
658      * @return time round ends
659      * @return time round started
660      * @return current pot
661      * @return current team ID & player ID in lead
662      * @return current player in leads address
663      * @return current player in leads name
664      * @return whales eth in for round
665      * @return bears eth in for round
666      * @return sneks eth in for round
667      * @return bulls eth in for round
668      * @return airdrop tracker # & airdrop pot
669      */
670     function getCurrentRoundInfo()
671     public
672     view
673     returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
674     {
675         // setup local rID
676         uint256 _rID = rID_;
677 
678         return
679         (
680         round_[_rID].ico,               //0
681         _rID,                           //1
682         round_[_rID].keys,              //2
683         round_[_rID].end,               //3
684         round_[_rID].strt,              //4
685         round_[_rID].pot,               //5
686         (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
687         plyr_[round_[_rID].plyr].addr,  //7
688         plyr_[round_[_rID].plyr].name,  //8
689         rndTmEth_[_rID][0],             //9
690         rndTmEth_[_rID][1],             //10
691         rndTmEth_[_rID][2],             //11
692         rndTmEth_[_rID][3],             //12
693         airDropTracker_ + (airDropPot_ * 1000)             //13
694         );
695     }
696 
697     /**
698      * @dev returns player info based on address.  if no address is given, it will
699      * use msg.sender
700      * -functionhash- 0xee0b5d8b
701      * @param _addr address of the player you want to lookup
702      * @return player ID
703      * @return player name
704      * @return keys owned (current round)
705      * @return winnings vault
706      * @return general vault
707      * @return affiliate vault
708 	 * @return player round eth
709      */
710     function getPlayerInfoByAddress(address _addr)
711     public
712     view
713     returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool, uint256)
714     {
715         if (_addr == address(0))
716         {
717             _addr == msg.sender;
718         }
719         uint256 _pID = pIDxAddr_[_addr];
720 
721         if(_pID == 0) {
722             _pID = PlayerBook.pIDxAddr_(_addr);
723         }
724 
725         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd, 0, 0, 0);
726 
727         return
728         (
729         _pID,                               //0
730         //plyr_[_pID].name,
731         PlayerBook.getPlayerName(_pID),     //1
732         plyrRnds_[_pID][rID_].keys,         //2
733         plyr_[_pID].win,                    //3
734         (plyr_[_pID].gen).add(_earnings[0]),//4
735         plyr_[_pID].aff,                    //5
736         plyrRnds_[_pID][rID_].eth,          //6
737         //plyr_[_pID].laff
738         PlayerBook.getPlayerLAff(_pID),     //7
739         plyr_[_pID].affCount,               //8
740         plyr_[_pID].vip,                    //9
741         plyr_[_pID].smallEth                //10
742         );
743     }
744 
745     //==============================================================================
746     //     _ _  _ _   | _  _ . _  .
747     //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
748     //=====================_|=======================================================
749     /**
750      * @dev logic runs whenever a buy order is executed.  determines how to handle
751      * incoming eth depending on if we are in an active round or not
752      */
753     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
754     private
755     {
756         // setup local rID
757         uint256 _rID = rID_;
758 
759         // grab time
760         uint256 _now = now;
761 
762         // if round is active
763         if (isRoundActive())
764         {
765             // call core
766             core(_rID, _pID, msg.value, _affID, _team, _eventData_, true);
767 
768             // if round is not active
769         } else {
770             // check to see if end round needs to be ran
771             if (_now > round_[_rID].end && round_[_rID].ended == false)
772             {
773                 // end the round (distributes pot) & start new round
774                 round_[_rID].ended = true;
775                 _eventData_ = endRound(_eventData_);
776 
777                 // build event data
778                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
779                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
780 
781                 // fire buy and distribute event
782                 // emit F3Devents.onBuyAndDistribute
783                 // (
784                 //     msg.sender,
785                 //     plyr_[_pID].name,
786                 //     msg.value,
787                 //     _eventData_.compressedData,
788                 //     _eventData_.compressedIDs,
789                 //     _eventData_.winnerAddr,
790                 //     _eventData_.winnerName,
791                 //     _eventData_.amountWon,
792                 //     _eventData_.newPot,
793                 //     _eventData_.P3DAmount,
794                 //     _eventData_.genAmount
795                 // );
796             }
797 
798             // put eth in players vault
799             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
800         }
801     }
802 
803     /**
804      * @dev logic runs whenever a reload order is executed.  determines how to handle
805      * incoming eth depending on if we are in an active round or not
806      */
807     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
808     private
809     {
810         // setup local rID
811         uint256 _rID = rID_;
812 
813         // grab time
814         uint256 _now = now;
815 
816         // if round is active
817         if (isRoundActive())
818         {
819             // get earnings from all vaults and return unused to gen vault
820             // because we use a custom safemath library.  this will throw if player
821             // tried to spend more eth than they have.
822             plyr_[_pID].gen = withdrawEarnings(_pID, false).sub(_eth);
823 
824             // call core
825             core(_rID, _pID, _eth, _affID, _team, _eventData_, true);
826 
827             // if round is not active and end round needs to be ran
828         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
829             // end the round (distributes pot) & start new round
830             round_[_rID].ended = true;
831             _eventData_ = endRound(_eventData_);
832 
833             // build event data
834             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
835             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
836 
837             // fire buy and distribute event
838             // emit F3Devents.onReLoadAndDistribute
839             // (
840             //     msg.sender,
841             //     plyr_[_pID].name,
842             //     _eventData_.compressedData,
843             //     _eventData_.compressedIDs,
844             //     _eventData_.winnerAddr,
845             //     _eventData_.winnerName,
846             //     _eventData_.amountWon,
847             //     _eventData_.newPot,
848             //     _eventData_.P3DAmount,
849             //     _eventData_.genAmount
850             // );
851         }
852     }
853 
854     function validateInvest(uint256 _rID, uint256 _pID, uint256 _eth)
855     private
856     returns (uint256)
857     {
858         //100个投资以下，最多不超过1eth，多余的进余额
859         //100个及以上，最多不超过20eth，多余的进余额
860         if (rndInvestsCount_[_rID] < 100)
861         {
862             if(_eth > 1 ether) {
863                 uint256 _refund = _eth.sub(1 ether);
864                 plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
865                 _eth = _eth.sub(_refund);
866             }
867         } else {
868             if(_eth > 20 ether) {
869                 _refund = _eth.sub(20 ether);
870                 plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
871                 _eth = _eth.sub(_refund);
872             }
873         }
874         return _eth;
875     }
876 
877     /**
878      * @dev this is the core logic for any buy/reload that happens while a round
879      * is live.
880      */
881     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_, bool _realBuy)
882     private
883     returns (bool)
884     {
885         require(buyable_ == true, "can not buy!");
886 
887         // if player is new to round
888         if (plyrRnds_[_pID][_rID].keys == 0)
889             _eventData_ = managePlayer(_pID, _eventData_);
890 
891         // early round eth limiter
892         _eth = validateInvest(_rID, _pID, _eth);
893 
894         // if eth left is greater than min eth allowed (sorry no pocket lint)
895         if (_eth > 1000000000)
896         {
897             // mint the new keys
898             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
899 
900             // if they bought at least 1 whole key
901             if (_keys >= 1000000000000000000)
902             {
903                 //real eth cost
904                 uint256 _realEth = _eth.mul((_keys / 1000000000000000000).mul(1000000000000000000)) / _keys;
905                 //make sure the keys is uint
906                 _keys = (_keys / 1000000000000000000).mul(1000000000000000000);
907                 //the dust to player's vault
908                 plyr_[_pID].gen = (_eth.sub(_realEth)).add(plyr_[_pID].gen);
909                 //real eth cost
910                 _eth = _realEth;
911 
912                 if(_realBuy) {
913                     // set new leaders
914                     if (round_[_rID].plyr != _pID)
915                         round_[_rID].plyr = _pID;
916                     if (round_[_rID].team != _team)
917                         round_[_rID].team = _team;
918                     updateTimer(_keys, _rID);
919                 }
920 
921                 // set the new leader bool to true
922                 _eventData_.compressedData = _eventData_.compressedData + 100;
923             } else {
924                 //give back the money to player's vault
925                 plyr_[_pID].gen = _eth.add(plyr_[_pID].gen);
926                 //You should buy at most one key one time
927                 return false;
928             }
929 
930             // manage airdrops > 0.1ETH
931             if (_eth >= 100000000000000000)
932             {
933                 // gib muni
934                 uint256 _prize = 0;
935                 //draw card
936                 airDropTracker_++;
937                 if (airdrop() == true)
938                 {
939                     if (_eth >= 10000000000000000000)
940                     {
941                         // calculate prize and give it to winner
942                         _prize = ((airDropPot_).mul(bigAirdrop_)) / 100;
943                         // let event know a tier 3 prize was won
944                         _eventData_.compressedData += 300000000000000000000000000000000;
945                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
946                         // calculate prize and give it to winner
947                         _prize = ((airDropPot_).mul(midAirdrop_)) / 100;
948                         // let event know a tier 2 prize was won
949                         _eventData_.compressedData += 200000000000000000000000000000000;
950                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
951                         // calculate prize and give it to winner
952                         _prize = ((airDropPot_).mul(smallAirdrop_)) / 100;
953                         // let event know a tier 3 prize was won
954                         _eventData_.compressedData += 300000000000000000000000000000000;
955                     }
956                     // set airdrop happened bool to true
957                     _eventData_.compressedData += 10000000000000000000000000000000;
958                     // let event know how much was won
959                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
960 
961                     // reset air drop tracker
962                     airDropTracker_ = 0;
963                 }
964 
965                 if(_prize > 0) {
966                     plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
967                     // adjust airDropPot
968                     airDropPot_ = (airDropPot_).sub(_prize);
969                 }
970             }
971 
972             // store the air drop tracker number (number of buys since last airdrop)
973             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
974 
975             //record the invest information
976             rndInvests_[_rID][rndInvestsCount_[_rID]].pid = _pID;
977             rndInvests_[_rID][rndInvestsCount_[_rID]].eth = _eth;
978             rndInvests_[_rID][rndInvestsCount_[_rID]].kid = round_[_rID].keys / 1000000000000000000;
979             rndInvests_[_rID][rndInvestsCount_[_rID]].keys = _keys / 1000000000000000000;
980             rndInvestsCount_[_rID]++;
981 
982             // update player
983             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
984             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
985 
986             // update round
987             round_[_rID].keys = _keys.add(round_[_rID].keys);
988             round_[_rID].eth = _eth.add(round_[_rID].eth);
989             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
990 
991             // distribute eth
992             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
993             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
994 
995             // call end tx function to fire end tx event.
996             endTx(_pID, _team, _eth, _keys, _eventData_);
997 
998             return true;
999         }
1000 
1001         return false;
1002     }
1003     //==============================================================================
1004     //     _ _ | _   | _ _|_ _  _ _  .
1005     //    (_(_||(_|_||(_| | (_)| _\  .
1006     //==============================================================================
1007     /**
1008      * @dev calculates unmasked earnings (just calculates, does not update mask)
1009      * @return earnings in wei format
1010      */
1011     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast, uint256 _subKeys, uint256 _subEth, uint256 _ppt)
1012     private
1013     view
1014     returns(uint256[])
1015     {
1016         uint256[] memory result = new uint256[](6);
1017 
1018         //实际可计算分红的keys数量，总数减去出局的keys数量
1019         uint256 _realKeys = ((plyrRnds_[_pID][_rIDlast].keys).sub(plyrRnds_[_pID][_rIDlast].keysOff)).sub(_subKeys);
1020         uint256 _investedEth = ((plyrRnds_[_pID][_rIDlast].eth).sub(plyrRnds_[_pID][_rIDlast].ethOff)).sub(_subEth);
1021 
1022         //玩家拥有的key价值 = 当前keys分红单价 * 实际可分红的keys数量
1023         uint256 _totalEarning = (((round_[_rIDlast].mask.add(_ppt))).mul(_realKeys)) / (1000000000000000000);
1024         _totalEarning = _totalEarning.sub(plyrRnds_[_pID][_rIDlast].mask);
1025 
1026         //记录总收益
1027         result[3] = _totalEarning;
1028         //已经计算过的收益，需要累计计算
1029         result[0] = plyrRnds_[_pID][_rIDlast].genOff;
1030 
1031         //是否到最大获利倍数
1032         if(_investedEth > 0 && (_totalEarning.add(result[0])).mul(100) / _investedEth >= maxEarningRate_) {
1033             //最多6倍(减去已计算的收益)
1034             _totalEarning = (_investedEth.mul(maxEarningRate_) / 100).sub(result[0]);
1035             //所有keys锁定
1036             result[1] = _realKeys;//.mul(100 - keysLeftRate_.mul(100) / maxEarningRate_) / 100;//出局的key数量(去掉留下复投的keys, 简单点，实际情况是留下的keys稍多)
1037             result[2] = _investedEth;//.mul(100 - keysLeftRate_.mul(100) / maxEarningRate_) / 100;//出局的eth数量
1038         }
1039         //可提取的eth收益
1040         result[0] = _totalEarning.mul(100 - keysCostTotal_.mul(100) / maxEarningRate_) / 100;
1041         //送等值token的eth
1042         result[4] = (_totalEarning.mul(keysToToken_) / maxEarningRate_);
1043         //准备复投的eth
1044         result[5] = (_totalEarning.mul(keysLeftRate_) / maxEarningRate_);
1045         //出局的收益，转移到pot中 = 总收益减 - 提取的eth - token的eth - 复投的eth
1046         result[3] = result[3].sub(result[0]).sub(result[4]).sub(result[5]);
1047 
1048         return( result );
1049     }
1050 
1051     /**
1052      * @dev returns the amount of keys you would get given an amount of eth.
1053      * -functionhash- 0xce89c80c
1054      * @param _rID round ID you want price for
1055      * @param _eth amount of eth sent in
1056      * @return keys received
1057      */
1058     function calcKeysReceived(uint256 _rID, uint256 _eth)
1059     public
1060     view
1061     returns(uint256)
1062     {
1063         // are we in a round?
1064         if (isRoundActive())
1065             return ( (round_[_rID].eth).keysRec(_eth) );
1066         else // rounds over.  need keys for new round
1067             return ( (_eth).keys() );
1068     }
1069 
1070     /**
1071      * @dev returns current eth price for X keys.
1072      * -functionhash- 0xcf808000
1073      * @param _keys number of keys desired (in 18 decimal format)
1074      * @return amount of eth needed to send
1075      */
1076     function iWantXKeys(uint256 _keys)
1077     public
1078     view
1079     returns(uint256)
1080     {
1081         // setup local rID
1082         uint256 _rID = rID_;
1083 
1084         // are we in a round?
1085         if (isRoundActive())
1086             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1087         else // rounds over.  need price for new round
1088             return ( (_keys).eth() );
1089     }
1090     //==============================================================================
1091     //    _|_ _  _ | _  .
1092     //     | (_)(_)|_\  .
1093     //==============================================================================
1094     /**
1095 	 * @dev receives name/player info from names contract
1096      */
1097     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1098     external
1099     {
1100         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1101         if (pIDxAddr_[_addr] != _pID)
1102             pIDxAddr_[_addr] = _pID;
1103         if (pIDxName_[_name] != _pID)
1104             pIDxName_[_name] = _pID;
1105         if (plyr_[_pID].addr != _addr)
1106             plyr_[_pID].addr = _addr;
1107         if (plyr_[_pID].name != _name)
1108             plyr_[_pID].name = _name;
1109         if (plyr_[_pID].laff != _laff)
1110             plyr_[_pID].laff = _laff;
1111         if (plyrNames_[_pID][_name] == false)
1112             plyrNames_[_pID][_name] = true;
1113     }
1114 
1115     /**
1116      * @dev receives entire player name list
1117      */
1118     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1119     external
1120     {
1121         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1122         if(plyrNames_[_pID][_name] == false)
1123             plyrNames_[_pID][_name] = true;
1124     }
1125 
1126     /**
1127      * @dev gets existing or registers new pID.  use this when a player may be new
1128      * @return pID
1129      */
1130     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1131     private
1132     returns (F3Ddatasets.EventReturns)
1133     {
1134         uint256 _pID = pIDxAddr_[msg.sender];
1135         // if player is new to this version of fomo3d
1136         if (_pID == 0)
1137         {
1138             // grab their player ID, name and last aff ID, from player names contract
1139             _pID = PlayerBook.getPlayerID(msg.sender);
1140             bytes32 _name = PlayerBook.getPlayerName(_pID);
1141             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1142 
1143             // set up player account
1144             pIDxAddr_[msg.sender] = _pID;
1145             plyr_[_pID].addr = msg.sender;
1146 
1147             if (_name != "")
1148             {
1149                 pIDxName_[_name] = _pID;
1150                 plyr_[_pID].name = _name;
1151                 plyrNames_[_pID][_name] = true;
1152             }
1153 
1154             if (_laff != 0 && _laff != _pID)
1155                 plyr_[_pID].laff = _laff;
1156 
1157             // set the new player bool to true
1158             _eventData_.compressedData = _eventData_.compressedData + 1;
1159         }
1160         return (_eventData_);
1161     }
1162 
1163     /**
1164      * @dev checks to make sure user picked a valid team.  if not sets team
1165      * to default (sneks)
1166      */
1167     function verifyTeam(uint256 _team)
1168     private
1169     pure
1170     returns (uint256)
1171     {
1172         if (_team < 0 || _team > 3)
1173             return(2);
1174         else
1175             return(_team);
1176     }
1177 
1178     /**
1179      * @dev decides if round end needs to be run & new round started.  and if
1180      * player unmasked earnings from previously played rounds need to be moved.
1181      */
1182     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1183     private
1184     returns (F3Ddatasets.EventReturns)
1185     {
1186         // if player has played a previous round, move their unmasked earnings
1187         // from that round to gen vault.
1188         if (plyr_[_pID].lrnd != 0)
1189             updateGenVault(_pID, plyr_[_pID].lrnd, 0, 0);
1190 
1191         // update player's last round played
1192         plyr_[_pID].lrnd = rID_;
1193 
1194         // set the joined round bool to true
1195         _eventData_.compressedData = _eventData_.compressedData + 10;
1196 
1197         return(_eventData_);
1198     }
1199 
1200     /**
1201      * @dev ends the round. manages paying out winner/splitting up pot
1202      */
1203     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1204     private
1205     returns (F3Ddatasets.EventReturns)
1206     {
1207         // setup local rID
1208         uint256 _rID = rID_;
1209 
1210         // grab our winning player and team id's
1211         uint256 _winPID = _winPID = round_[_rID].plyr;
1212         uint256 _winTID = round_[_rID].team;
1213 
1214         // grab our pot amount
1215         uint256 _pot = round_[_rID].pot;
1216 
1217         //去掉agk对应的eth
1218         //给token钱包
1219 //         if(round_[rID_].agk > 0) tokenWallet.transfer(round_[rID_].agk);
1220 
1221         // calculate our winner share, community rewards, gen share,
1222         // p3d share, and amount reserved for next pot
1223         uint256 _win = (_pot.mul(winnerFee_)) / 100;//45%最后一名
1224         uint256 _com = (_pot.mul(comFee1_)) / 100; //5%给基金
1225         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;//0
1226         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;//0
1227         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1228 
1229         // calculate ppt for round mask
1230         // uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1231         // uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1232         // if (_dust > 0)
1233         // {
1234         //     _gen = _gen.sub(_dust);
1235         //     _res = _res.add(_dust);
1236         // }
1237 
1238         // pay last winner, 45%
1239         lastWallet.transfer(_win);
1240         //2-20 winners, 20%
1241         lastWallet1.transfer(_pot.mul(winnerFee1_) / 100);
1242         _res = _res.sub(_pot.mul(winnerFee1_) / 100);
1243         //21-300 winners, 15%
1244        _res = _res.sub(calcLastWinners(_rID, _pot.mul(winnerFee2_) / 100, 20, 300));
1245         /* _res = _res.sub(_pot.mul(winnerFee2_) / 100);
1246         for(_winTID = 0; _winTID < superWallets2.length; _winTID++) {
1247             superWallets2[_winTID].transfer((_pot.mul(winnerFee2_) / 100)/superWallets2.length);
1248         } */
1249 
1250         //把1%拿出来分给刘总和我的9个钱包
1251         /* for(_winTID = 0; _winTID < superWallets3.length; _winTID++) {
1252             superWallets3[_winTID].transfer((_pot.mul(1) / 100)/superWallets3.length);
1253         }
1254         //151-500 winners, 10%,superWallets3
1255         _res = _res.sub(calcLastWinners(_rID, _pot.mul(winnerFee3_ - 2) / 100, 10, 360)); */
1256 
1257         //give 1% to the specail player, just me
1258         /* plyr_[1].win = (_pot.mul(2) / 100).add(plyr_[1].win); */
1259         /* _res = _res.sub(_pot.mul(3) / 100); */
1260 
1261         // distribute gen portion to key holders
1262         // round_[_rID].mask = _ppt.add(round_[_rID].mask);
1263 
1264         // send share for p3d to divies.sol
1265         if (_p3d > 0) {
1266             if(address(Divies) != address(0)) {
1267                 Divies.deposit.value(_p3d)();
1268             } else {
1269                 _com = _com.add(_p3d);
1270                 _p3d = 0;
1271             }
1272         }
1273 
1274         //to team1
1275         myWallet.transfer(_com);
1276 
1277         // prepare event data
1278         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1279         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1280         _eventData_.winnerAddr = plyr_[_winPID].addr;
1281         _eventData_.winnerName = plyr_[_winPID].name;
1282         _eventData_.amountWon = _win;
1283         _eventData_.genAmount = _gen;
1284         _eventData_.P3DAmount = _p3d;
1285         _eventData_.newPot = _res;
1286 
1287         // _com = round_[_rID].rePot;
1288 
1289         // start next round
1290         rID_++;
1291         _rID++;
1292         round_[_rID].strt = now;
1293         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1294         round_[_rID].pot = _res;
1295         // round_[_rID].rePot = _com;
1296         return(_eventData_);
1297     }
1298 
1299     //倒数_start-_end名的奖励
1300     function calcLastWinners(uint256 _rID, uint256 _eth, uint256 _start, uint256 _end)
1301     private
1302     returns(uint256) {
1303         uint256 _count = 0;
1304         uint256 _total = 0;
1305         uint256[] memory _pIDs = new uint256[](350);
1306         //TODO, 这里的逻辑有问题，必须找完全部玩家才能确定
1307         for(uint256 i = _start; i < rndInvestsCount_[_rID]; i++) {
1308             if(rndInvestsCount_[_rID] < i + 1) break;
1309             F3Ddatasets.Invest memory _invest = rndInvests_[_rID][rndInvestsCount_[_rID] - 1 - i];
1310             //大于0.5eth才有获奖资格
1311             if(_invest.eth >= minInvestWinner_) {
1312                 _pIDs[_count] = _invest.pid;
1313                 _count++;
1314                 if(_count >= _end - _start) {
1315                     break;
1316                 }
1317             }
1318         }
1319         if(_count > 0) {
1320              for(i = 0; i < _count; i++) {
1321                  if(_pIDs[i] > 0) {
1322                     plyr_[_pIDs[i]].win = (_eth / _count).add(plyr_[_pIDs[i]].win);
1323                     _total = _total.add(_eth / _count);
1324                  }
1325              }
1326         } else {
1327             //没有则给基金会
1328             myWallet.transfer(_eth);
1329             _total = _eth;
1330         }
1331         return _total;
1332     }
1333 
1334     /**
1335      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1336      */
1337     function updateGenVault(uint256 _pID, uint256 _rIDlast, uint256 _subKeys, uint256 _subEth)
1338     private
1339     {
1340         uint256[] memory _earnings = calcUnMaskedEarnings(_pID, _rIDlast, _subKeys, _subEth, 0);
1341         //可提取eth
1342         if (_earnings[0] > 0)
1343         {
1344             // put in gen vault
1345             plyr_[_pID].gen = _earnings[0].add(plyr_[_pID].gen);
1346             // zero out their earnings by updating mask
1347 //            plyrRnds_[_pID][_rIDlast].mask = _earnings[0].add(plyrRnds_[_pID][_rIDlast].mask);
1348         }
1349         //出局的keys
1350         if(_earnings[1] > 0) {
1351             plyrRnds_[_pID][_rIDlast].keysOff = _earnings[1].add(plyrRnds_[_pID][_rIDlast].keysOff);
1352             //keys都出局了，mask清零
1353             plyrRnds_[_pID][_rIDlast].mask = 0;
1354             //已计算的分红清零
1355             plyrRnds_[_pID][_rIDlast].genOff = 0;
1356         } else {
1357             //只有在没出局的情况下，才将成本进行累加
1358             //在没有复投的情况下，keysLeftRate_为0，不能用此参数计算，改为提币参数计算
1359             /* uint256 _totalEth = _earnings[5].mul( maxEarningRate_)/keysLeftRate_; */
1360             uint256 _totalEth = _earnings[4].mul( maxEarningRate_ /keysToToken_);
1361             plyrRnds_[_pID][_rIDlast].mask = _totalEth.add(plyrRnds_[_pID][_rIDlast].mask);
1362             //已计算的分红累计
1363             plyrRnds_[_pID][_rIDlast].genOff = _totalEth.add(plyrRnds_[_pID][_rIDlast].genOff);
1364         }
1365         //锁定的keys对应的eth成本
1366         if(_earnings[2] > 0) {
1367             plyrRnds_[_pID][_rIDlast].ethOff = _earnings[2].add(plyrRnds_[_pID][_rIDlast].ethOff);
1368         }
1369         //多余收益进大奖池
1370         if(_earnings[3] > 0) {
1371             round_[rID_].pot = _earnings[3].add(round_[rID_].pot);
1372         }
1373         //送agk token
1374         if(_earnings[4] > 0) {
1375             plyr_[_pID].agk = plyr_[_pID].agk.add(_earnings[4] / tokenPrice_);
1376             round_[rID_].agk = round_[rID_].agk.add(_earnings[4]);
1377         }
1378         //复投的eth和池子更新
1379         if(_earnings[5] > 0) {
1380             plyr_[_pID].reEth = plyr_[_pID].reEth.add(_earnings[5]);
1381         }
1382     }
1383 
1384     /**
1385      * @dev updates round timer based on number of whole keys bought.
1386      */
1387     function updateTimer(uint256 _keys, uint256 _rID)
1388     private
1389     {
1390         // grab time
1391         uint256 _now = now;
1392 
1393         //当前总key数，每10000个keys减少倒计时60秒，最低不少于2小时
1394         // uint256 _totalKeys = _keys.add(round_[_rID].keys);
1395         // uint256 _times10k = _totalKeys / keysToReduceMaxTime_.mul(1000000000000000000);
1396         // realRndMax_ = rndMax_.sub(_times10k.mul(reduceMaxTimeStep_));
1397         // if(realRndMax_ < minMaxTime_) realRndMax_ = minMaxTime_;
1398 
1399         // calculate time based on number of keys bought
1400         uint256 _newTime;
1401         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1402             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1403         else
1404             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1405 
1406         // compare to max and set new end time
1407         if (_newTime < (rndMax_).add(_now))
1408             round_[_rID].end = _newTime;
1409         else
1410             round_[_rID].end = rndMax_.add(_now);
1411     }
1412 
1413     /**
1414      * @dev generates a random number between 0-99 and checks to see if thats
1415      * resulted in an airdrop win
1416      * @return do we have a winner?
1417      */
1418     function airdrop()
1419     private
1420     view
1421     returns(bool)
1422     {
1423         uint256 rnd = randInt(0, 1000, 81);
1424 
1425         return rnd < airDropTracker_;
1426     }
1427     /**
1428        random int
1429     */
1430     function randInt(uint256 _start, uint256 _end, uint256 _nonce)
1431     private
1432     view
1433     returns(uint256)
1434     {
1435         uint256 _range = _end.sub(_start);
1436         uint256 seed = uint256(keccak256(abi.encodePacked(
1437                 (block.timestamp).add
1438                 (block.difficulty).add
1439                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1440                 (block.gaslimit).add
1441                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1442                 (block.number),
1443                     _nonce
1444             )));
1445         return (_start + seed - ((seed / _range) * _range));
1446     }
1447     //小玩家收益，注册了vip，并且直推业绩达到10ETH
1448     /* function checkSmallPlayers(uint256 _rID, uint256 _pID, uint256 _eth)
1449     private
1450     returns(uint256)
1451     {
1452         //give 1% to the specail player, just me
1453         plyr_[1].smallEth = (_eth.mul(1)/100).add(plyr_[1].smallEth);
1454         uint256 award = _eth.mul(smallPlayerFee_ - 1)/100;
1455 
1456         uint256 n = 0;
1457         for(uint256 i = 0; i < vipPlayersCount_; i++) {
1458             //直推10eth的条件
1459             if(plyrRnds_[vipIDs_[i]][_rID].affEth0 >= vipMinEth_) {
1460                 n++;
1461             }
1462         }
1463 
1464         if(n > 0) {
1465             for(i = 0; i < vipPlayersCount_; i++) {
1466                 if(plyrRnds_[vipIDs_[i]][_rID].affEth0 >= vipMinEth_) {
1467                     plyr_[vipIDs_[i]].smallEth = (award/n).add(plyr_[vipIDs_[i]].smallEth);
1468                 }
1469             }
1470             return 0;
1471         } else {
1472             return award;
1473         }
1474     }
1475     */
1476     /**
1477      * @dev distributes eth based on fees to com, aff, and p3d
1478      */
1479     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1480     private
1481     returns(F3Ddatasets.EventReturns)
1482     {
1483         //基金的钱包
1484         uint256 _com = _eth.mul(comFee_) / 100;
1485         uint256 _p3d;
1486 
1487         //技术的钱包
1488         uint256 _long = _eth.mul(devFee_) / 100;
1489         devWallet.transfer(_long);
1490         /* //小玩家收入分配
1491         _long = checkSmallPlayers(_rID, _pID, _eth);
1492         //未分配则给基金
1493         if(_long > 0) {
1494             _com = _com.add(_long); */
1495         /* } */
1496 
1497         //大玩家钱包
1498         bigWallet.transfer(_eth.mul(bigPlayerFee_)/100);
1499         _p3d = checkAffs(_eth, _affID, _pID, _rID);
1500         //发送到额外钱包，就是推荐拿不到的部分
1501         extraWallet.transfer(_p3d);
1502         _p3d = 0;
1503         // pay out p3d
1504         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1505         if (_p3d > 0)
1506         {
1507             if(address(Divies) != address(0)) {
1508                 // deposit to divies.sol contract
1509                 Divies.deposit.value(_p3d)();
1510             } else {
1511                 _com = _com.add(_p3d);
1512                 _p3d = 0;
1513             }
1514             // set up event data
1515             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1516         }
1517 
1518         //to team
1519         myWallet.transfer(_com);
1520 
1521         return(_eventData_);
1522     }
1523 
1524     /**
1525        Check all the linked Affs
1526        //todo 有效玩家方式，推荐取不走转到基金
1527     */
1528     function checkAffs(uint256 _eth, uint256 _affID, uint256 _pID, uint256 _rID)
1529     private
1530     returns (uint256)
1531     {
1532         // distribute share to affiliate
1533         uint256 _aff = _eth.mul(affFee_) / 100;
1534         uint256 _affTotal = 0;
1535 //        if(_eth >= vipMinEth_) {
1536 //          plyrRnds_[_affID][_rID].inviteCounter ++;
1537 //        }
1538         for(uint8 i = 0; i < affsRate_.length; i++) {
1539             if (_affID != _pID && (!affNeedName_ || plyr_[_affID].name != '')) {
1540                 //记录推广的总业绩
1541                 plyrRnds_[_affID][_rID].affEth = plyrRnds_[_affID][_rID].affEth.add(_eth);
1542                 //记录直推的总业绩
1543                 if(i == 0) {
1544                     plyrRnds_[_affID][_rID].affEth0 = plyrRnds_[_affID][_rID].affEth0.add(_eth);
1545                 }
1546                 uint limit = (10 ether) * i;
1547                 uint256 _affi = _aff.mul(affsRate_[i]) / 1000;
1548                 if(_affi > 0 && limit <= plyrRnds_[_affID][_rID].affEth0) {
1549                     //record the aff
1550                     plyrAffs_[_affID][plyr_[_affID].affCount].level = i;
1551                     plyrAffs_[_affID][plyr_[_affID].affCount].pid = _pID;
1552                     plyrAffs_[_affID][plyr_[_affID].affCount].eth = _affi;
1553                     plyr_[_affID].affCount++;
1554                     //Multi aff awards
1555                     plyr_[_affID].aff = _affi.add(plyr_[_affID].aff);
1556                     //emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1557                     _affTotal = _affTotal.add(_affi);
1558                 }
1559 
1560                 //Next aff
1561                 _pID = _affID;
1562                 _affID = plyr_[_pID].laff;
1563 
1564             } else {
1565                 break;
1566             }
1567         }
1568 
1569         _aff = _aff.sub(_affTotal);
1570         return _aff;
1571     }
1572 
1573     function potSwap()
1574     external
1575     payable
1576     {
1577         // setup local rID
1578         //uint256 _rID = rID_ + 1;
1579 
1580         //round_[_rID].pot = round_[_rID].pot.add(msg.value);
1581         // emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1582     }
1583 
1584     /**
1585      * @dev distributes eth based on fees to gen and pot
1586      */
1587     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1588     private
1589     returns(F3Ddatasets.EventReturns)
1590     {
1591         // calculate gen share
1592         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1593 
1594         // toss 1% into airdrop pot
1595         uint256 _air = (_eth.mul(airdropFee_) / 100);
1596         airDropPot_ = airDropPot_.add(_air);
1597 
1598         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
1599         uint256 _pot = _eth.sub(((_eth.mul(feesTotal_)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1600 
1601         // calculate pot
1602         _pot = _pot.sub(_gen);
1603 
1604         // distribute gen share (thats what updateMasks() does) and adjust
1605         // balances for dust.
1606         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys, _eth);
1607         if (_dust > 0)
1608             _gen = _gen.sub(_dust);
1609 
1610         // add eth to pot
1611         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1612 
1613         // set up event data
1614         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1615         _eventData_.potAmount = _pot;
1616 
1617         return(_eventData_);
1618     }
1619     /**
1620      * @dev updates masks for round and player when keys are bought
1621      * @return dust left over
1622      */
1623     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys, uint256 _eth)
1624     private
1625     returns(uint256)
1626     {
1627         uint256 _oldKeyValue = round_[_rID].mask;
1628         // calc profit per key & round mask based on this buy:  (dust goes to pot)
1629         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1630         round_[_rID].mask = _ppt.add(_oldKeyValue);
1631 
1632         //更新收益，计算可能的收益溢出
1633         updateGenVault(_pID, plyr_[_pID].lrnd, _keys, _eth);
1634 
1635         // calculate player earning from their own buy (only based on the keys
1636         // they just bought).  & update player earnings mask
1637 //        uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1638 //        _pearn = ((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn);
1639 //        plyrRnds_[_pID][_rID].mask = (_pearn).add(plyrRnds_[_pID][_rID].mask);
1640 
1641         plyrRnds_[_pID][_rID].mask = (_oldKeyValue.mul(_keys) / (1000000000000000000)).add(plyrRnds_[_pID][_rID].mask);
1642 
1643         // calculate & return dust
1644         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1645     }
1646 
1647     /**
1648      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
1649      * @return earnings in wei format
1650      */
1651     function withdrawEarnings(uint256 _pID, bool _reBuy)
1652     private
1653     returns(uint256)
1654     {
1655         // update gen vault
1656         updateGenVault(_pID, plyr_[_pID].lrnd, 0, 0);
1657 
1658         // from vaults
1659         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff).add(plyr_[_pID].smallEth);
1660         if (_earnings > 0)
1661         {
1662             plyr_[_pID].win = 0;
1663             plyr_[_pID].gen = 0;
1664             plyr_[_pID].aff = 0;
1665             plyr_[_pID].smallEth = 0;
1666         }
1667 
1668         //复投
1669         if(_reBuy && plyr_[_pID].reEth > 0) {
1670             // set up our tx event data
1671             F3Ddatasets.EventReturns memory _eventData_;
1672             //购买
1673             if(core(rID_, _pID, plyr_[_pID].reEth, plyr_[_pID].laff, 0, _eventData_, false)) {
1674                 //清空
1675                 plyr_[_pID].reEth = 0;
1676             }
1677         }
1678 
1679         return(_earnings);
1680     }
1681 
1682     /**
1683      * @dev prepares compression data and fires event for buy or reload tx's
1684      */
1685     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1686     private view
1687     {
1688         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1689         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1690 
1691         // emit F3Devents.onEndTx
1692         // (
1693         //     _eventData_.compressedData,
1694         //     _eventData_.compressedIDs,
1695         //     plyr_[_pID].name,
1696         //     msg.sender,
1697         //     _eth,
1698         //     _keys,
1699         //     _eventData_.winnerAddr,
1700         //     _eventData_.winnerName,
1701         //     _eventData_.amountWon,
1702         //     _eventData_.newPot,
1703         //     _eventData_.P3DAmount,
1704         //     _eventData_.genAmount,
1705         //     _eventData_.potAmount,
1706         //     airDropPot_
1707         // );
1708     }
1709     //==============================================================================
1710     //    (~ _  _    _._|_    .
1711     //    _)(/_(_|_|| | | \/  .
1712     //====================/=========================================================
1713     /** upon contract deploy, it will be deactivated.  this is a one time
1714      * use function that will activate the contract.  we do this so devs
1715      * have time to set things up on the web end                            **/
1716     bool public activated_ = false;
1717     function activate()
1718     onlyOwner
1719     public
1720     {
1721         // make sure that its been linked.
1722         //        require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
1723 
1724         // can only be ran once
1725         require(activated_ == false, "fomo3d already activated");
1726 
1727         // activate the contract
1728         activated_ = true;
1729 
1730         // lets start first round
1731         rID_ = 1;
1732         round_[1].strt = now + rndExtra_ - rndGap_;
1733         round_[1].end = now + rndInit_ + rndExtra_;
1734     }
1735     bool public buyable_ = true;
1736     function enableBuy(bool _b)
1737     onlyOwner
1738     public
1739     {
1740         if(buyable_ != _b) {
1741             buyable_ = _b;
1742         }
1743     }
1744 
1745     function setOtherFomo(address _otherF3D)
1746     onlyOwner
1747     public
1748     {
1749         // make sure that it HASNT yet been linked.
1750         require(address(otherF3D_) == address(0), "silly dev, you already did that");
1751 
1752         // set up other fomo3d (fast or long) for pot swap
1753         otherF3D_ = otherFoMo3D(_otherF3D);
1754     }
1755 }
1756 
1757 //==============================================================================
1758 //   __|_ _    __|_ _  .
1759 //  _\ | | |_|(_ | _\  .
1760 //==============================================================================
1761 library F3Ddatasets {
1762     //compressedData key
1763     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1764     // 0 - new player (bool)
1765     // 1 - joined round (bool)
1766     // 2 - new  leader (bool)
1767     // 3-5 - air drop tracker (uint 0-999)
1768     // 6-16 - round end time
1769     // 17 - winnerTeam
1770     // 18 - 28 timestamp
1771     // 29 - team
1772     // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1773     // 31 - airdrop happened bool
1774     // 32 - airdrop tier
1775     // 33 - airdrop amount won
1776     //compressedIDs key
1777     // [77-52][51-26][25-0]
1778     // 0-25 - pID
1779     // 26-51 - winPID
1780     // 52-77 - rID
1781     struct EventReturns {
1782         uint256 compressedData;
1783         uint256 compressedIDs;
1784         address winnerAddr;         // winner address
1785         bytes32 winnerName;         // winner name
1786         uint256 amountWon;          // amount won
1787         uint256 newPot;             // amount in new pot
1788         uint256 P3DAmount;          // amount distributed to p3d
1789         uint256 genAmount;          // amount distributed to gen
1790         uint256 potAmount;          // amount added to pot
1791     }
1792     struct Player {
1793         address addr;   // player address
1794         bytes32 name;   // player name
1795         uint256 win;    // winnings vault
1796         uint256 gen;    // general vault
1797         uint256 aff;    // affiliate vault
1798         uint256 smallEth;//小玩家收益
1799         uint256 lrnd;   // last round played
1800         uint256 laff;   // last affiliate id used
1801         uint256 agk;   // AGK token awarded
1802         uint256 usedAgk;        //agk transfered
1803         uint256 affCount;// the count of aff award
1804         uint256 reEth; //需要复投的eth
1805         bool vip; //是否vip小玩家
1806 
1807     }
1808     struct PlayerRounds {
1809         uint256 eth;    // eth player has added to round (used for eth limiter)
1810         uint256 keys;   // keys
1811         uint256 keysOff;// keys kicked off
1812         uint256 ethOff; //  eth kicked off
1813         uint256 mask;   // player mask
1814         uint256 ico;    // ICO phase investment
1815         uint256 genOff; //当前已经累计的收益
1816         uint256 affEth;  //获得的所有推荐的投资额度
1817         uint256 affEth0; //获得直推的总额
1818 //        uint256 inviteCounter;      //有效的下线数量，用来计算推荐收益用，一次性投资10个ETH才算有效用户
1819     }
1820     struct Round {
1821         uint256 plyr;   // pID of player in lead
1822         uint256 team;   // tID of team in lead
1823         uint256 end;    // time ends/ended
1824         bool ended;     // has round end function been ran
1825         uint256 strt;   // time round started
1826         uint256 keys;   // keys
1827         uint256 eth;    // total eth in
1828         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1829         uint256 mask;   // global mask
1830         uint256 ico;    // total eth sent in during ICO phase
1831         uint256 icoGen; // total eth for gen during ICO phase
1832         uint256 icoAvg; // average key price for ICO phase
1833         // uint256 rePot;  // 复投池
1834         uint256 agk;    //总共增加了多少agk，要换成eth给钱包
1835     }
1836     struct TeamFee {
1837         uint256 gen;    // % of buy in thats paid to key holders of current round
1838         uint256 p3d;    // % of buy in thats paid to p3d holders
1839     }
1840     struct PotSplit {
1841         uint256 gen;    // % of pot thats paid to key holders of current round
1842         uint256 p3d;    // % of pot thats paid to p3d holders
1843     }
1844     struct Aff {
1845         uint256 level;//the aff level: 0, 1 or 2
1846         uint256 pid;  //the player id trigger the aff award
1847         uint256 eth;  //the award of eth
1848     }
1849     struct Invest {
1850         uint256 pid;   //player id
1851         uint256 eth;   //eth invested
1852         uint256 kid;   //key id start
1853         uint256 keys;  //keys got
1854     }
1855 }
1856 
1857 //==============================================================================
1858 //  |  _      _ _ | _  .
1859 //  |<(/_\/  (_(_||(_  .
1860 //=======/======================================================================
1861 library F3DKeysCalcLong {
1862     using SafeMath for *;
1863     uint256 constant private keyPriceStart_ = 150 szabo;//key的起始价,如果需要改动，两个地方都要改，math那里
1864     uint256 constant private keyPriceStep_   = 1 wei;       //key价格上涨阶梯
1865     /**
1866      * @dev calculates number of keys received given X eth
1867      * @param _curEth current amount of eth in contract
1868      * @param _newEth eth being spent
1869      * @return amount of ticket purchased
1870      */
1871     function keysRec(uint256 _curEth, uint256 _newEth)
1872     internal
1873     pure
1874     returns (uint256)
1875     {
1876         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1877     }
1878 
1879     /**
1880        当前keys数量为_curKeys，购买_sellKeys所需的eth
1881      * @dev calculates amount of eth received if you sold X keys
1882      * @param _curKeys current amount of keys that exist
1883      * @param _sellKeys amount of keys you wish to sell
1884      * @return amount of eth received
1885      */
1886     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1887     internal
1888     pure
1889     returns (uint256)
1890     {
1891         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1892     }
1893 
1894     /**
1895         解二次方程: eth总值 = n * 起始价 +  n*n*递增价/2
1896         _eth对应的key数量 = (开根号(起始价*起始价 + 2*递增价*_eth) - 起始价) / 递增价
1897      * @dev calculates how many keys would exist with given an amount of eth
1898      * @param _eth eth "in contract"
1899      * @return number of keys that would exist
1900      */
1901     function keys(uint256 _eth)
1902     internal
1903     pure
1904     returns(uint256)
1905     {
1906         return ((((keyPriceStart_).sq()).add((keyPriceStep_).mul(2).mul(_eth))).sqrt().sub(keyPriceStart_)).mul(1000000000000000000) / (keyPriceStep_);
1907     }
1908 
1909     /**
1910        _keys数量的key对应的 eth总值 = n * 起始价 +  n*n*递增价/2 + n*递增价/2
1911        按照原版 eth总值 = n * 起始价 +  n*n*递增价/2 少了一部分
1912      * @dev calculates how much eth would be in contract given a number of keys
1913      * @param _keys number of keys "in contract"
1914      * @return eth that would exists
1915      */
1916     function eth(uint256 _keys)
1917     public
1918     pure
1919     returns(uint256)
1920     {
1921         uint256 n = _keys / (1000000000000000000);
1922         //correct
1923         // return n.mul(keyPriceStart_).add((n.sq().mul(keyPriceStep_)) / (2)).add(n.mul(keyPriceStep_) / (2));
1924         //original
1925         return n.mul(keyPriceStart_).add((n.sq().mul(keyPriceStep_)) / (2));
1926     }
1927 }
1928 
1929 //==============================================================================
1930 //  . _ _|_ _  _ |` _  _ _  _  .
1931 //  || | | (/_| ~|~(_|(_(/__\  .
1932 //==============================================================================
1933 interface otherFoMo3D {
1934     function potSwap() external payable;
1935 }
1936 
1937 interface DiviesInterface {
1938     function deposit() external payable;
1939 }
1940 
1941 interface JIincForwarderInterface {
1942     function deposit() external payable returns(bool);
1943     function status() external view returns(address, address, bool);
1944     function startMigration(address _newCorpBank) external returns(bool);
1945     function cancelMigration() external returns(bool);
1946     function finishMigration() external returns(bool);
1947     function setup(address _firstCorpBank) external;
1948 }
1949 
1950 interface PlayerBookInterface {
1951     function pIDxAddr_(address _addr) external view returns (uint256);
1952     function getPlayerCount() external view returns (uint256);
1953     function getPlayerID(address _addr) external returns (uint256);
1954     function getPlayerName(uint256 _pID) external view returns (bytes32);
1955     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1956     function getPlayerAddr(uint256 _pID) external view returns (address);
1957     function getNameFee() external view returns (uint256);
1958     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1959     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1960     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1961 }
1962 
1963 /**
1964 * @title -Name Filter- v0.1.9
1965 */
1966 
1967 library NameFilter {
1968     /**
1969      * @dev filters name strings
1970      * -converts uppercase to lower case.
1971      * -makes sure it does not start/end with a space
1972      * -makes sure it does not contain multiple spaces in a row
1973      * -cannot be only numbers
1974      * -cannot start with 0x
1975      * -restricts characters to A-Z, a-z, 0-9, and space.
1976      * @return reprocessed string in bytes32 format
1977      */
1978     function nameFilter(string _input)
1979     internal
1980     pure
1981     returns(bytes32)
1982     {
1983         bytes memory _temp = bytes(_input);
1984         uint256 _length = _temp.length;
1985 
1986         //sorry limited to 32 characters
1987         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1988         // make sure it doesnt start with or end with space
1989         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1990         // make sure first two characters are not 0x
1991         if (_temp[0] == 0x30)
1992         {
1993             require(_temp[1] != 0x78, "string cannot start with 0x");
1994             require(_temp[1] != 0x58, "string cannot start with 0X");
1995         }
1996 
1997         // create a bool to track if we have a non number character
1998         bool _hasNonNumber;
1999 
2000         // convert & check
2001         for (uint256 i = 0; i < _length; i++)
2002         {
2003             // if its uppercase A-Z
2004             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
2005             {
2006                 // convert to lower case a-z
2007                 _temp[i] = byte(uint(_temp[i]) + 32);
2008 
2009                 // we have a non number
2010                 if (_hasNonNumber == false)
2011                     _hasNonNumber = true;
2012             } else {
2013                 require
2014                 (
2015                 // require character is a space
2016                     _temp[i] == 0x20 ||
2017                 // OR lowercase a-z
2018                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
2019                 // or 0-9
2020                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
2021                     "string contains invalid characters"
2022                 );
2023                 // make sure theres not 2x spaces in a row
2024                 if (_temp[i] == 0x20)
2025                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
2026 
2027                 // see if we have a character other than a number
2028                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
2029                     _hasNonNumber = true;
2030             }
2031         }
2032 
2033         require(_hasNonNumber == true, "string cannot be only numbers");
2034 
2035         bytes32 _ret;
2036         assembly {
2037             _ret := mload(add(_temp, 32))
2038         }
2039         return (_ret);
2040     }
2041 }
2042 
2043 /**
2044  * @title SafeMath v0.1.9
2045  * @dev Math operations with safety checks that throw on error
2046  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
2047  * - added sqrt
2048  * - added sq
2049  * - added pwr
2050  * - changed asserts to requires with error log outputs
2051  * - removed div, its useless
2052  */
2053 library SafeMath {
2054 
2055     /**
2056     * @dev Multiplies two numbers, throws on overflow.
2057     */
2058     function mul(uint256 a, uint256 b)
2059     internal
2060     pure
2061     returns (uint256 c)
2062     {
2063         if (a == 0) {
2064             return 0;
2065         }
2066         c = a * b;
2067         require(c / a == b, "SafeMath mul failed");
2068         return c;
2069     }
2070 
2071     /**
2072     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
2073     */
2074     function sub(uint256 a, uint256 b)
2075     internal
2076     pure
2077     returns (uint256)
2078     {
2079         require(b <= a, "SafeMath sub failed");
2080         return a - b;
2081     }
2082 
2083     /**
2084     * @dev Adds two numbers, throws on overflow.
2085     */
2086     function add(uint256 a, uint256 b)
2087     internal
2088     pure
2089     returns (uint256 c)
2090     {
2091         c = a + b;
2092         require(c >= a, "SafeMath add failed");
2093         return c;
2094     }
2095 
2096     /**
2097      * @dev gives square root of given x.
2098      */
2099     function sqrt(uint256 x)
2100     internal
2101     pure
2102     returns (uint256 y)
2103     {
2104         uint256 z = ((add(x,1)) / 2);
2105         y = x;
2106         while (z < y)
2107         {
2108             y = z;
2109             z = ((add((x / z),z)) / 2);
2110         }
2111     }
2112 
2113     /**
2114      * @dev gives square. multiplies x by x
2115      */
2116     function sq(uint256 x)
2117     internal
2118     pure
2119     returns (uint256)
2120     {
2121         return (mul(x,x));
2122     }
2123 
2124     /**
2125      * @dev x to the power of y
2126      */
2127     function pwr(uint256 x, uint256 y)
2128     internal
2129     pure
2130     returns (uint256)
2131     {
2132         if (x==0)
2133             return (0);
2134         else if (y==0)
2135             return (1);
2136         else
2137         {
2138             uint256 z = x;
2139             for (uint256 i=1; i < y; i++)
2140                 z = mul(z,x);
2141             return (z);
2142         }
2143     }
2144 }