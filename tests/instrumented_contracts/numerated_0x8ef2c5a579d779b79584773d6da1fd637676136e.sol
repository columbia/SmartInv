1 pragma solidity 0.4.24;
2 
3 /* 
4 *  __      __  ______  ____        _____   ____        ____    ______  __  __
5 * /\ \  __/\ \/\  _  \/\  _`\     /\  __`\/\  _`\     /\  _`\ /\__  _\/\ \/\ \
6 * \ \ \/\ \ \ \ \ \L\ \ \ \L\ \   \ \ \/\ \ \ \L\_\   \ \ \L\_\/_/\ \/\ \ \_\ \
7 *  \ \ \ \ \ \ \ \  __ \ \ ,  /    \ \ \ \ \ \  _\/    \ \  _\L  \ \ \ \ \  _  \
8 *   \ \ \_/ \_\ \ \ \/\ \ \ \\ \    \ \ \_\ \ \ \/      \ \ \L\ \ \ \ \ \ \ \ \ \
9 *    \ `\___x___/\ \_\ \_\ \_\ \_\   \ \_____\ \_\       \ \____/  \ \_\ \ \_\ \_\
10 *     '\/__//__/  \/_/\/_/\/_/\/ /    \/_____/\/_/        \/___/    \/_/  \/_/\/_/
11 * 
12 *             _____  _____   __  __   ____    ____
13 *            /\___ \/\  __`\/\ \/\ \ /\  _`\ /\  _`\
14 *    __      \/__/\ \ \ \/\ \ \ \/'/'\ \ \L\_\ \ \L\ \         __      __      ___ ___      __
15 *  /'__`\       _\ \ \ \ \ \ \ \ , <  \ \  _\L\ \ ,  /       /'_ `\  /'__`\  /' __` __`\  /'__`\
16 * /\ \L\.\_    /\ \_\ \ \ \_\ \ \ \\`\ \ \ \L\ \ \ \\ \     /\ \L\ \/\ \L\.\_/\ \/\ \/\ \/\  __/
17 * \ \__/.\_\   \ \____/\ \_____\ \_\ \_\\ \____/\ \_\ \_\   \ \____ \ \__/.\_\ \_\ \_\ \_\ \____\
18 *  \/__/\/_/    \/___/  \/_____/\/_/\/_/ \/___/  \/_/\/ /    \/___L\ \/__/\/_/\/_/\/_/\/_/\/____/
19 *                                                              /\____/
20 *                                                              \_/__/
21 */
22 
23 contract WarOfEth {
24     using SafeMath for *;
25     using NameFilter for string;
26     using WoeKeysCalc for uint256;
27 
28     //==============
29     // EVENTS
30     //==============
31 
32     // 用户注册新名字事件
33     event onNewName
34     (
35         uint256 indexed playerID,
36         address indexed playerAddress,
37         bytes32 indexed playerName,
38         bool isNewPlayer,
39         uint256 amountPaid,
40         uint256 timeStamp
41     );
42 
43     // 队伍新名字事件
44     event onNewTeamName
45     (
46         uint256 indexed teamID,
47         bytes32 indexed teamName,
48         uint256 indexed playerID,
49         bytes32 playerName,
50         uint256 amountPaid,
51         uint256 timeStamp
52     );
53     
54     // 购买事件
55     event onTx
56     (
57         uint256 indexed playerID,
58         address playerAddress,
59         bytes32 playerName,
60         uint256 teamID,
61         bytes32 teamName,
62         uint256 ethIn,
63         uint256 keysBought
64     );
65 
66     // 支付邀请奖励时触发
67     event onAffPayout
68     (
69         uint256 indexed affID,
70         address affAddress,
71         bytes32 affName,
72         uint256 indexed roundID,
73         uint256 indexed buyerID,
74         uint256 amount,
75         uint256 timeStamp
76     );
77 
78     // 淘汰事件（每回合淘汰一次）
79     event onKill
80     (
81         uint256 deadCount,
82         uint256 liveCount,
83         uint256 deadKeys
84     );
85 
86     // 游戏结束事件
87     event onEndRound
88     (
89         uint256 winnerTID,  // winner
90         bytes32 winnerTName,
91         uint256 playersCount,
92         uint256 eth    // eth in pot
93     );
94 
95     // 提现事件
96     event onWithdraw
97     (
98         uint256 indexed playerID,
99         address playerAddress,
100         bytes32 playerName,
101         uint256 ethOut,
102         uint256 timeStamp
103     );
104 
105     //==============
106     // DATA
107     //==============
108 
109     // 玩家基本信息
110     struct Player {
111         address addr;   // 地址 player address
112         bytes32 name;   
113         uint256 gen;    // 钱包余额：通用
114         uint256 aff;    // 钱包余额：邀请奖励
115         uint256 laff;   // 最近邀请人（玩家ID）
116     }
117     
118     // 玩家在每局比赛中的信息
119     struct PlayerRounds {
120         uint256 eth;    // 本局投入的eth成本
121         mapping (uint256 => uint256) plyrTmKeys;    // teamid => keys
122         bool withdrawn;     // 这轮收益是否已提现
123     }
124 
125     // 队伍信息
126     struct Team {
127         uint256 id;     // team id
128         bytes32 name;    // team name
129         uint256 keys;   // key s in the team
130         uint256 eth;   // eth from the team
131         uint256 price;    // price of the last key (only for view)
132         uint256 playersCount;   // how many team members
133         uint256 leaderID;   // leader pID (leader is always the top 1 player in the team)
134         address leaderAddr;  // leader address
135         bool dead;  // 队伍是否已被淘汰
136     }
137 
138     // 比赛信息
139     struct Round {
140         uint256 start;  // 开始时间
141         uint256 state;  // 局状态。0: 局未激活，1：局准备，2：杀戮，3：结束（结束后瓜分奖池，相当于ended=true）
142         uint256 eth;    // 收到eth总量
143         uint256 pot;    // 奖池
144         uint256 keys;   // 本轮全部keys
145         uint256 team;   // 领先队伍的ID
146         uint256 ethPerKey;  // how many eth per key in Winner Team. 只有在比赛结束后才有值。
147         uint256 lastKillingTime;   // 上一次淘汰触发时间
148         uint256 deadRate;   // 当前淘汰线比率（第一名keys * 淘汰线比率 = 淘汰线）
149         uint256 deadKeys;   // 下一次淘汰线（keys低于淘汰线的队伍将被淘汰）
150         uint256 liveTeams;  // 活着队伍的数量
151         uint256 tID_;    // how many teams in this Round
152     }
153 
154     // Game
155     string constant public name = "War of Eth Official";
156     string constant public symbol = "WOE";
157     address public owner;
158     uint256 public minTms_ = 3;    //开局最少队伍数
159     uint256 public maxTms_ = 16;    //最大队伍数
160     uint256 public roundGap_ = 86400;    // 每两局比赛的间隔（state为0的阶段）：24小时
161     uint256 public killingGap_ = 86400;   // 淘汰间隔（上一次淘汰时间 + 淘汰间隔 = 下一次淘汰时间）：24小时
162     uint256 constant private registrationFee_ = 10 finney;    // 名字注册费
163 
164     // Player
165     uint256 public pID_;    // 玩家总数
166     mapping (address => uint256) public pIDxAddr_;  // (addr => pID) returns player id by address
167     mapping (bytes32 => uint256) public pIDxName_;  // (name => pID) returns player id by name
168     mapping (uint256 => Player) public plyr_;   // (pID => data) player data
169     
170     // Round
171     uint256 public rID_;    // 当前局ID
172     mapping (uint256 => Round) public round_;   // 局ID => 局数据
173 
174     // Player Rounds
175     mapping (uint256 => mapping (uint256 => PlayerRounds)) public plyrRnds_;  // 玩家ID => 局ID => 玩家在这局中的数据
176 
177     // Team
178     mapping (uint256 => mapping (uint256 => Team)) public rndTms_;  // 局ID => 队ID => 队伍在这局中的数
179     mapping (uint256 => mapping (bytes32 => uint256)) public rndTIDxName_;  // (rID => team name => tID) returns team id by name
180 
181     // =============
182     // CONSTRUCTOR
183     // =============
184 
185     constructor() public {
186         owner = msg.sender;
187     }
188 
189     // =============
190     // MODIFIERS
191     // =============
192 
193     // 合约作者才能操作
194     modifier onlyOwner() {
195         require(msg.sender == owner);
196         _;
197     }
198 
199     // 合约是否已激活
200     modifier isActivated() {
201         require(activated_ == true, "its not ready yet."); 
202         _;
203     }
204     
205     // 只接受用户调用，不接受合约调用
206     modifier isHuman() {
207         require(tx.origin == msg.sender, "sorry humans only");
208         _;
209     }
210 
211     // 交易限额
212     modifier isWithinLimits(uint256 _eth) {
213         require(_eth >= 1000000000, "no less than 1 Gwei");
214         require(_eth <= 100000000000000000000000, "no more than 100000 ether");
215         _;
216     }
217 
218     // =====================
219     // PUBLIC INTERACTION
220     // =====================
221 
222     // 直接打到合约中的钱会由这个方法处理【不推荐，请勿使用】
223     // 默认使用上一个邀请人，且资金进入当前领先队伍
224     function()
225         public
226         payable
227         isActivated()
228         isHuman()
229         isWithinLimits(msg.value)
230     {
231         buy(round_[rID_].team, "");
232     }
233 
234     // 购买
235     // 邀请码只能是用户名，不支持用户ID或Address
236     function buy(uint256 _team, bytes32 _affCode)
237         public
238         payable
239         isActivated()
240         isHuman()
241         isWithinLimits(msg.value)
242     {
243         // 确保比赛尚未结束
244         require(round_[rID_].state < 3, "This round has ended.");
245 
246         // 确保比赛已经开始
247         if (round_[rID_].state == 0){
248             require(now >= round_[rID_].start, "This round hasn't started yet.");
249             round_[rID_].state = 1;
250         }
251 
252         // 获取玩家ID
253         // 如果不存在，会创建新玩家档案
254         determinePID(msg.sender);
255         uint256 _pID = pIDxAddr_[msg.sender];
256         uint256 _tID;
257 
258         // 邀请码处理
259         // 只能是用户名，不支持用户ID或Address
260         uint256 _affID;
261         if (_affCode == "" || _affCode == plyr_[_pID].name){
262             // 如果没有邀请码，则使用上一个邀请码
263             _affID = plyr_[_pID].laff;
264         } else {
265             // 如果存在邀请码，则获取对应的玩家ID
266             _affID = pIDxName_[_affCode];
267             
268             // 更新玩家的最近邀请人
269             if (_affID != plyr_[_pID].laff){
270                 plyr_[_pID].laff = _affID;
271             }
272         }
273 
274         // 购买处理
275         if (round_[rID_].state == 1){
276             // Check team id
277             _tID = determinTID(_team, _pID);
278 
279             // Buy
280             buyCore(_pID, _affID, _tID, msg.value);
281 
282             // 满足队伍数条件就进入淘汰阶段（state: 2）
283             if (round_[rID_].tID_ >= minTms_){
284                 // 进入淘汰阶段
285                 round_[rID_].state = 2;
286 
287                 // 初始化设置
288                 startKilling();
289             }
290 
291         } else if (round_[rID_].state == 2){
292             // 是否触发结束
293             if (round_[rID_].liveTeams == 1){
294                 // 结束
295                 endRound();
296                 
297                 // 退还资金到钱包账户
298                 refund(_pID, msg.value);
299 
300                 return;
301             }
302 
303             // Check team id
304             _tID = determinTID(_team, _pID);
305 
306             // Buy
307             buyCore(_pID, _affID, _tID, msg.value);
308 
309             // Kill if needed
310             if (now > round_[rID_].lastKillingTime.add(killingGap_)) {
311                 kill();
312             }
313         }
314     }
315 
316     // 钱包提币
317     function withdraw()
318         public
319         isActivated()
320         isHuman()
321     {
322         // fetch player ID
323         uint256 _pID = pIDxAddr_[msg.sender];
324 
325         // 确保玩家存在
326         require(_pID != 0, "Please join the game first!");
327 
328         // 提现金额
329         uint256 _eth;
330 
331         // 如果存在已经结束的轮次，计算我尚未提现的收益
332         if (rID_ > 1){
333             for (uint256 i = 1; i < rID_; i++) {
334                 // 如果尚未提现，则提出金额
335                 if (plyrRnds_[_pID][i].withdrawn == false){
336                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
337                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
338                     }
339                     plyrRnds_[_pID][i].withdrawn = true;
340                 }
341             }
342         }
343 
344         _eth = _eth.add(plyr_[_pID].gen).add(plyr_[_pID].aff);
345 
346         // 转账
347         if (_eth > 0) {
348             plyr_[_pID].addr.transfer(_eth);
349         }
350 
351         // 清空钱包余额
352         plyr_[_pID].gen = 0;
353         plyr_[_pID].aff = 0;
354 
355         // Event 提现
356         emit onWithdraw(_pID, plyr_[_pID].addr, plyr_[_pID].name, _eth, now);
357     }
358 
359     // 注册玩家名字
360     function registerNameXID(string _nameString)
361         public
362         payable
363         isHuman()
364     {
365         // make sure name fees paid
366         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
367         
368         // filter name + condition checks
369         bytes32 _name = NameFilter.nameFilter(_nameString);
370         
371         // set up address 
372         address _addr = msg.sender;
373         
374         // set up our tx event data and determine if player is new or not
375         // bool _isNewPlayer = determinePID(_addr);
376         bool _isNewPlayer = determinePID(_addr);
377         
378         // fetch player id
379         uint256 _pID = pIDxAddr_[_addr];
380 
381         // 确保这个名字还没有人用
382         require(pIDxName_[_name] == 0, "sorry that names already taken");
383         
384         // add name to player profile, registry, and name book
385         plyr_[_pID].name = _name;
386         pIDxName_[_name] = _pID;
387 
388         // deposit registration fee
389         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
390         
391         // Event
392         emit onNewName(_pID, _addr, _name, _isNewPlayer, msg.value, now);
393     }
394 
395     // 注册队伍名字
396     // 只能由队长设置
397     function setTeamName(uint256 _tID, string _nameString)
398         public
399         payable
400         isHuman()
401     {
402         // 要求team id存在
403         require(_tID <= round_[rID_].tID_ && _tID != 0, "There's no this team.");
404         
405         // fetch player ID
406         uint256 _pID = pIDxAddr_[msg.sender];
407         
408         // 要求必须是队长
409         require(_pID == rndTms_[rID_][_tID].leaderID, "Only team leader can change team name. You can invest more money to be the team leader.");
410         
411         // 需要注册费
412         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
413         
414         // filter name + condition checks
415         bytes32 _name = NameFilter.nameFilter(_nameString);
416 
417         require(rndTIDxName_[rID_][_name] == 0, "sorry that names already taken");
418         
419         // add name to team
420         rndTms_[rID_][_tID].name = _name;
421         rndTIDxName_[rID_][_name] = _tID;
422 
423         // deposit registration fee
424         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
425 
426         // event
427         emit onNewTeamName(_tID, _name, _pID, plyr_[_pID].name, msg.value, now);
428     }
429 
430     // 向游戏钱包存款
431     function deposit()
432         public
433         payable
434         isActivated()
435         isHuman()
436         isWithinLimits(msg.value)
437     {
438         determinePID(msg.sender);
439         uint256 _pID = pIDxAddr_[msg.sender];
440 
441         plyr_[_pID].gen = (msg.value).add(plyr_[_pID].gen);
442     }
443 
444     //==============
445     // GETTERS
446     //==============
447 
448     // 检查名字可注册
449     function checkIfNameValid(string _nameStr)
450         public
451         view
452         returns (bool)
453     {
454         bytes32 _name = _nameStr.nameFilter();
455         if (pIDxName_[_name] == 0)
456             return (true);
457         else 
458             return (false);
459     }
460 
461     // 查询：距离下一次淘汰的时间
462     function getNextKillingAfter()
463         public
464         view
465         returns (uint256)
466     {
467         require(round_[rID_].state == 2, "Not in killing period.");
468 
469         uint256 _tNext = round_[rID_].lastKillingTime.add(killingGap_);
470         uint256 _t = _tNext > now ? _tNext.sub(now) : 0;
471 
472         return _t;
473     }
474 
475     // 查询：单个玩家本轮信息 (前端查询用户钱包也是这个方法)
476     // 返回：玩家ID，地址，名字，gen，aff，本轮投资额，本轮预计收益，未提现收益
477     function getPlayerInfoByAddress(address _addr)
478         public 
479         view 
480         returns(uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
481     {
482         if (_addr == address(0))
483         {
484             _addr == msg.sender;
485         }
486         uint256 _pID = pIDxAddr_[_addr];
487 
488         return (
489             _pID,
490             _addr,
491             plyr_[_pID].name,
492             plyr_[_pID].gen,
493             plyr_[_pID].aff,
494             plyrRnds_[_pID][rID_].eth,
495             getProfit(_pID),
496             getPreviousProfit(_pID)
497         );
498     }
499 
500     // 查询: 玩家在某轮对某队的投资（_roundID = 0 表示当前轮）
501     // 返回 keys
502     function getPlayerRoundTeamBought(uint256 _pID, uint256 _roundID, uint256 _tID)
503         public
504         view
505         returns (uint256)
506     {
507         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
508         return plyrRnds_[_pID][_rID].plyrTmKeys[_tID];
509     }
510 
511     // 查询: 玩家在某轮的全部投资（_roundID = 0 表示当前轮）
512     // 返回 keysList数组 (keysList[i]表示用户在i+1队的份额)
513     function getPlayerRoundBought(uint256 _pID, uint256 _roundID)
514         public
515         view
516         returns (uint256[])
517     {
518         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
519 
520         // 该轮队伍总数
521         uint256 _tCount = round_[_rID].tID_;
522 
523         // 玩家在各队的keys
524         uint256[] memory keysList = new uint256[](_tCount);
525 
526         // 生成数组
527         for (uint i = 0; i < _tCount; i++) {
528             keysList[i] = plyrRnds_[_pID][_rID].plyrTmKeys[i+1];
529         }
530 
531         return keysList;
532     }
533 
534     // 查询：玩家在各轮的成绩（包含本赛季，但是收益为0）
535     // 返回 {ethList, winList}  (ethList[i]表示第i+1个赛季的投资)
536     function getPlayerRounds(uint256 _pID)
537         public
538         view
539         returns (uint256[], uint256[])
540     {
541         uint256[] memory _ethList = new uint256[](rID_);
542         uint256[] memory _winList = new uint256[](rID_);
543         for (uint i=0; i < rID_; i++){
544             _ethList[i] = plyrRnds_[_pID][i+1].eth;
545             _winList[i] = plyrRnds_[_pID][i+1].plyrTmKeys[round_[i+1].team].mul(round_[i+1].ethPerKey) / 1000000000000000000;
546         }
547 
548         return (
549             _ethList,
550             _winList
551         );
552     }
553 
554     // 查询：上一局信息
555     // 返回：局ID，状态，奖池金额，获胜队伍ID，队伍名字，队伍人数，总队伍数
556     // 如果不存在上一局，会返回一堆0
557     function getLastRoundInfo()
558         public
559         view
560         returns (uint256, uint256, uint256, uint256, bytes32, uint256, uint256)
561     {
562         // last round id
563         uint256 _rID = rID_.sub(1);
564 
565         // last winner
566         uint256 _tID = round_[_rID].team;
567 
568         return (
569             _rID,
570             round_[_rID].state,
571             round_[_rID].pot,
572             _tID,
573             rndTms_[_rID][_tID].name,
574             rndTms_[_rID][_tID].playersCount,
575             round_[_rID].tID_
576         );
577     }
578 
579     // 查询：本局比赛信息
580     function getCurrentRoundInfo()
581         public
582         view
583         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
584     {
585         return (
586             rID_,
587             round_[rID_].state,
588             round_[rID_].eth,
589             round_[rID_].pot,
590             round_[rID_].keys,
591             round_[rID_].team,
592             round_[rID_].ethPerKey,
593             round_[rID_].lastKillingTime,
594             killingGap_,
595             round_[rID_].deadRate,
596             round_[rID_].deadKeys,
597             round_[rID_].liveTeams,
598             round_[rID_].tID_,
599             round_[rID_].start
600         );
601     }
602 
603     // 查询：某支队伍信息
604     // 返回：基本信息，队伍成员，及其投资金额
605     function getTeamInfoByID(uint256 _tID) 
606         public
607         view
608         returns (uint256, bytes32, uint256, uint256, uint256, uint256, bool)
609     {
610         require(_tID <= round_[rID_].tID_, "There's no this team.");
611         
612         return (
613             rndTms_[rID_][_tID].id,
614             rndTms_[rID_][_tID].name,
615             rndTms_[rID_][_tID].keys,
616             rndTms_[rID_][_tID].eth,
617             rndTms_[rID_][_tID].price,
618             rndTms_[rID_][_tID].leaderID,
619             rndTms_[rID_][_tID].dead
620         );
621     }
622 
623     // 查询：所有队伍的信息
624     // 返回：id[], name[], keys[], eth[], price[], playersCount[], dead[]
625     function getTeamsInfo()
626         public
627         view
628         returns (uint256[], bytes32[], uint256[], uint256[], uint256[], uint256[], bool[])
629     {
630         uint256 _tID = round_[rID_].tID_;
631 
632         // Lists of Team Info
633         uint256[] memory _idList = new uint256[](_tID);
634         bytes32[] memory _nameList = new bytes32[](_tID);
635         uint256[] memory _keysList = new uint256[](_tID);
636         uint256[] memory _ethList = new uint256[](_tID);
637         uint256[] memory _priceList = new uint256[](_tID);
638         uint256[] memory _membersList = new uint256[](_tID);
639         bool[] memory _deadList = new bool[](_tID);
640 
641         // Data
642         for (uint i = 0; i < _tID; i++) {
643             _idList[i] = rndTms_[rID_][i+1].id;
644             _nameList[i] = rndTms_[rID_][i+1].name;
645             _keysList[i] = rndTms_[rID_][i+1].keys;
646             _ethList[i] = rndTms_[rID_][i+1].eth;
647             _priceList[i] = rndTms_[rID_][i+1].price;
648             _membersList[i] = rndTms_[rID_][i+1].playersCount;
649             _deadList[i] = rndTms_[rID_][i+1].dead;
650         }
651 
652         return (
653             _idList,
654             _nameList,
655             _keysList,
656             _ethList,
657             _priceList,
658             _membersList,
659             _deadList
660         );
661     }
662 
663     // 获取每个队伍中的队长信息
664     // 返回：leaderID[], leaderName[], leaderAddr[]
665     function getTeamLeaders()
666         public
667         view
668         returns (uint256[], uint256[], bytes32[], address[])
669     {
670         uint256 _tID = round_[rID_].tID_;
671 
672         // Teams' leaders info
673         uint256[] memory _idList = new uint256[](_tID);
674         uint256[] memory _leaderIDList = new uint256[](_tID);
675         bytes32[] memory _leaderNameList = new bytes32[](_tID);
676         address[] memory _leaderAddrList = new address[](_tID);
677 
678         // Data
679         for (uint i = 0; i < _tID; i++) {
680             _idList[i] = rndTms_[rID_][i+1].id;
681             _leaderIDList[i] = rndTms_[rID_][i+1].leaderID;
682             _leaderNameList[i] = plyr_[_leaderIDList[i]].name;
683             _leaderAddrList[i] = rndTms_[rID_][i+1].leaderAddr;
684         }
685 
686         return (
687             _idList,
688             _leaderIDList,
689             _leaderNameList,
690             _leaderAddrList
691         );
692     }
693 
694     // 查询：预测本局的收益（假定目前领先的队伍赢）
695     // 返回：eth
696     function getProfit(uint256 _pID)
697         public
698         view
699         returns (uint256)
700     {
701         // 领先队伍ID
702         uint256 _tID = round_[rID_].team;
703 
704         // 如果用户不持有领先队伍股份，则返回0
705         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
706             return 0;
707         }
708 
709         // 我投资获胜的队伍Keys
710         uint256 _keys = plyrRnds_[_pID][rID_].plyrTmKeys[_tID];
711         
712         // 计算每把Key的价值
713         uint256 _ethPerKey = round_[rID_].pot.mul(1000000000000000000) / rndTms_[rID_][_tID].keys;
714         
715         // 我的Keys对应的总价值
716         uint256 _value = _keys.mul(_ethPerKey) / 1000000000000000000;
717 
718         return _value;
719     }
720 
721     // 查询：此前轮尚未提现的收益
722     function getPreviousProfit(uint256 _pID)
723         public
724         view
725         returns (uint256)
726     {
727         uint256 _eth;
728 
729         if (rID_ > 1){
730             // 计算我已结束的每轮中，尚未提现的收益
731             for (uint256 i = 1; i < rID_; i++) {
732                 if (plyrRnds_[_pID][i].withdrawn == false){
733                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
734                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
735                     }
736                 }
737             }
738         } else {
739             // 如果还没有已结束的轮次，则返回0
740             _eth = 0;
741         }
742 
743         // 返回
744         return _eth;
745     }
746 
747     // 下一个完整Key的价格
748     function getNextKeyPrice(uint256 _tID)
749         public 
750         view 
751         returns(uint256)
752     {  
753         require(_tID <= round_[rID_].tID_ && _tID != 0, "No this team.");
754 
755         return ( (rndTms_[rID_][_tID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
756     }
757 
758     // 购买某队X数量Keys，需要多少Eth？
759     function getEthFromKeys(uint256 _tID, uint256 _keys)
760         public
761         view
762         returns(uint256)
763     {
764         if (_tID <= round_[rID_].tID_ && _tID != 0){
765             // 如果_tID存在，则正常计算
766             return ((rndTms_[rID_][_tID].keys.add(_keys)).ethRec(_keys));
767         } else {
768             // 如果_tID不存在，则认为是新队伍
769             return ((uint256(0).add(_keys)).ethRec(_keys));
770         }
771     }
772 
773     // X数量Eth，可以买到某队多少keys？
774     function getKeysFromEth(uint256 _tID, uint256 _eth)
775         public
776         view
777         returns (uint256)
778     {
779         if (_tID <= round_[rID_].tID_ && _tID != 0){
780             // 如果_tID存在，则正常计算
781             return (rndTms_[rID_][_tID].eth).keysRec(_eth);
782         } else {
783             // 如果_tID不存在，则认为是新队伍
784             return (uint256(0).keysRec(_eth));
785         }
786     }
787 
788     // ==========================
789     //   PRIVATE: CORE GAME LOGIC
790     // ==========================
791 
792     // 核心购买方法
793     function buyCore(uint256 _pID, uint256 _affID, uint256 _tID, uint256 _eth)
794         private
795     {
796         uint256 _keys = (rndTms_[rID_][_tID].eth).keysRec(_eth);
797 
798         // 更新Player、Team、Round数据
799         // player
800         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
801             rndTms_[rID_][_tID].playersCount++;
802         }
803         plyrRnds_[_pID][rID_].plyrTmKeys[_tID] = _keys.add(plyrRnds_[_pID][rID_].plyrTmKeys[_tID]);
804         plyrRnds_[_pID][rID_].eth = _eth.add(plyrRnds_[_pID][rID_].eth);
805 
806         // Team
807         rndTms_[rID_][_tID].keys = _keys.add(rndTms_[rID_][_tID].keys);
808         rndTms_[rID_][_tID].eth = _eth.add(rndTms_[rID_][_tID].eth);
809         rndTms_[rID_][_tID].price = _eth.mul(1000000000000000000) / _keys;
810         uint256 _teamLeaderID = rndTms_[rID_][_tID].leaderID;
811         // refresh team leader
812         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] > plyrRnds_[_teamLeaderID][rID_].plyrTmKeys[_tID]){
813             rndTms_[rID_][_tID].leaderID = _pID;
814             rndTms_[rID_][_tID].leaderAddr = msg.sender;
815         }
816 
817         // Round
818         round_[rID_].keys = _keys.add(round_[rID_].keys);
819         round_[rID_].eth = _eth.add(round_[rID_].eth);
820         // refresh round leader
821         if (rndTms_[rID_][_tID].keys > rndTms_[rID_][round_[rID_].team].keys){
822             round_[rID_].team = _tID;
823         }
824 
825         // 资金分配
826         distribute(rID_, _pID, _eth, _affID);
827 
828         // Event
829         emit onTx(_pID, msg.sender, plyr_[_pID].name, _tID, rndTms_[rID_][_tID].name, _eth, _keys);
830     }
831 
832     // 资金分配
833     function distribute(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
834         private
835     {
836         // [1] com - 3%
837         uint256 _com = (_eth.mul(3)) / 100;
838 
839         // pay community reward
840         plyr_[1].gen = _com.add(plyr_[1].gen);
841 
842         // [2] aff - 10%
843         uint256 _aff = _eth / 10;
844 
845         if (_affID != _pID && plyr_[_affID].name != "") {
846             // pay aff
847             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
848             
849             // Event 邀请奖励
850             emit onAffPayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
851         } else {
852             // 如果没有邀请人，则这部分资金并入最终奖池
853             // 它并不会影响玩家买到的Keys数量，只会增加最终奖池的金额
854             _aff = 0;
855         }
856 
857         // [3] pot - 87%
858         uint256 _pot = _eth.sub(_aff).sub(_com);
859 
860         // 更新本局奖池
861         round_[_rID].pot = _pot.add(round_[_rID].pot);
862     }
863 
864     // 结束流程（只能执行一次）
865     function endRound()
866         private
867     {
868         require(round_[rID_].state < 3, "Round only end once.");
869         
870         // 本轮状态更新
871         round_[rID_].state = 3;
872 
873         // 奖池金额
874         uint256 _pot = round_[rID_].pot;
875 
876         // Devide Round Pot
877         // [1] winner 77%
878         uint256 _win = (_pot.mul(77))/100;
879 
880         // [2] com 3%
881         uint256 _com = (_pot.mul(3))/100;
882 
883         // [3] next round 20%
884         uint256 _res = (_pot.sub(_win)).sub(_com);
885 
886         // 获胜队伍
887         uint256 _tID = round_[rID_].team;
888         // 计算ethPerKey (每个完整的key对应多少个wei, A Full Key = 10**18 keys)
889         uint256 _epk = (_win.mul(1000000000000000000)) / (rndTms_[rID_][_tID].keys);
890 
891         // 考虑dust
892         uint256 _dust = _win.sub((_epk.mul(rndTms_[rID_][_tID].keys)) / 1000000000000000000);
893         if (_dust > 0) {
894             _win = _win.sub(_dust);
895             _res = _res.add(_dust);
896         }
897 
898         // pay winner team
899         round_[rID_].ethPerKey = _epk;
900 
901         // pay community reward
902         plyr_[1].gen = _com.add(plyr_[1].gen);
903 
904         // Event
905         emit onEndRound(_tID, rndTms_[rID_][_tID].name, rndTms_[rID_][_tID].playersCount, _pot);
906 
907         // 进入下一局
908         rID_++;
909         round_[rID_].pot = _res;
910         round_[rID_].start = now + roundGap_;
911     }
912     
913     // 退款到钱包账户
914     function refund(uint256 _pID, uint256 _value)
915         private
916     {
917         plyr_[_pID].gen = _value.add(plyr_[_pID].gen);
918     }
919 
920     // 创建队伍
921     // 返回 队伍ID
922     function createTeam(uint256 _pID, uint256 _eth)
923         private
924         returns (uint256)
925     {
926         // 单局队伍总数不能多于maxTms_
927         require(round_[rID_].tID_ < maxTms_, "The number of teams has reached the maximum limit.");
928 
929         // 创建队伍至少需要投资1eth
930         require(_eth >= 1000000000000000000, "You need at least 1 eth to create a team, though creating a new team is free.");
931 
932         // 本局队伍数和存活队伍数增加
933         round_[rID_].tID_++;
934         round_[rID_].liveTeams++;
935         
936         // 新队伍ID
937         uint256 _tID = round_[rID_].tID_;
938         
939         // 新队伍数据
940         rndTms_[rID_][_tID].id = _tID;
941         rndTms_[rID_][_tID].leaderID = _pID;
942         rndTms_[rID_][_tID].leaderAddr = plyr_[_pID].addr;
943         rndTms_[rID_][_tID].dead = false;
944 
945         return _tID;
946     }
947 
948     // 初始化各项杀戮参数
949     function startKilling()
950         private
951     {   
952         // 初始回合的基本参数
953         round_[rID_].lastKillingTime = now;
954         round_[rID_].deadRate = 10;     // 百分比，按照 deadRate / 100 来使用
955         round_[rID_].deadKeys = (rndTms_[rID_][round_[rID_].team].keys.mul(round_[rID_].deadRate)) / 100;
956     }
957 
958     // 杀戮淘汰
959     function kill()
960         private
961     {
962         // 本回合死亡队伍数
963         uint256 _dead = 0;
964 
965         // 少于淘汰线的队伍淘汰
966         for (uint256 i = 1; i <= round_[rID_].tID_; i++) {
967             if (rndTms_[rID_][i].keys < round_[rID_].deadKeys && rndTms_[rID_][i].dead == false){
968                 rndTms_[rID_][i].dead = true;
969                 round_[rID_].liveTeams--;
970                 _dead++;
971             }
972         }
973 
974         round_[rID_].lastKillingTime = now;
975 
976         // 如果只剩一支队伍，则启动结束程序
977         if (round_[rID_].liveTeams == 1 && round_[rID_].state == 2) {
978             endRound();
979             return;
980         }
981 
982         // 更新淘汰比率（如果参数修改了，要注意此处判断条件）
983         if (round_[rID_].deadRate < 90) {
984             round_[rID_].deadRate = round_[rID_].deadRate + 10;
985         }
986 
987         // 更新下一回合淘汰线
988         round_[rID_].deadKeys = ((rndTms_[rID_][round_[rID_].team].keys).mul(round_[rID_].deadRate)) / 100;
989 
990         // event
991         emit onKill(_dead, round_[rID_].liveTeams, round_[rID_].deadKeys);
992     }
993 
994     // 通过地址查询玩家ID，如果没有，就创建新玩家
995     // 返回：是否为新玩家
996     function determinePID(address _addr)
997         private
998         returns (bool)
999     {
1000         if (pIDxAddr_[_addr] == 0)
1001         {
1002             pID_++;
1003             pIDxAddr_[_addr] = pID_;
1004             plyr_[pID_].addr = _addr;
1005             
1006             return (true);  // 新玩家
1007         } else {
1008             return (false);
1009         }
1010     }
1011 
1012     // 队伍编号检查，返回编号（仅在当前局使用）
1013     function determinTID(uint256 _team, uint256 _pID)
1014         private
1015         returns (uint256)
1016     {
1017         // 确保队伍尚未淘汰
1018         require(rndTms_[rID_][_team].dead == false, "You can not buy a dead team!");
1019         
1020         if (_team <= round_[rID_].tID_ && _team > 0) {
1021             // 如果队伍已存在，则直接返回
1022             return _team;
1023         } else {
1024             // 如果队伍不存在，则创建新队伍
1025             return createTeam(_pID, msg.value);
1026         }
1027     }
1028 
1029     //==============
1030     // SECURITY
1031     //============== 
1032 
1033     // 部署完合约第一轮游戏需要我来激活整个游戏
1034     bool public activated_ = false;
1035     function activate()
1036         public
1037         onlyOwner()
1038     {   
1039         // can only be ran once
1040         require(activated_ == false, "it is already activated");
1041         
1042         // activate the contract 
1043         activated_ = true;
1044 
1045         // the first player
1046         plyr_[1].addr = owner;
1047         plyr_[1].name = "joker";
1048         pIDxAddr_[owner] = 1;
1049         pIDxName_["joker"] = 1;
1050         pID_ = 1;
1051         
1052         // 激活第一局.
1053         rID_ = 1;
1054         round_[1].start = now;
1055         round_[1].state = 1;
1056     }
1057 
1058     //============================
1059     // SETTINGS (Only owner)
1060     //============================
1061 
1062     // 设置最小队伍数
1063     function setMinTms(uint256 _tms)
1064         public
1065         onlyOwner()
1066     {
1067         minTms_ = _tms;
1068     }
1069 
1070     // 设置最大队伍数
1071     function setMaxTms(uint256 _tms)
1072         public
1073         onlyOwner()
1074     {
1075         maxTms_ = _tms;
1076     }
1077 
1078     // 设置两个赛季的间隔
1079     function setRoundGap(uint256 _gap)
1080         public
1081         onlyOwner()
1082     {
1083         roundGap_ = _gap;
1084     }
1085 
1086     // 设置两轮淘汰的间隔
1087     function setKillingGap(uint256 _gap)
1088         public
1089         onlyOwner()
1090     {
1091         killingGap_ = _gap;
1092     }
1093 
1094 }   // main contract ends here
1095 
1096 
1097 // Keys价格相关计算
1098 library WoeKeysCalc {
1099     using SafeMath for *;
1100 
1101     // 根据现有ETH，计算新入X个ETH能购买的Keys数量
1102     function keysRec(uint256 _curEth, uint256 _newEth)
1103         internal
1104         pure
1105         returns (uint256)
1106     {
1107         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1108     }
1109     
1110     // 根据当前Keys数量，计算卖出X数量的keys值多少ETH
1111     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1112         internal
1113         pure
1114         returns (uint256)
1115     {
1116         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1117     }
1118 
1119     // 根据池中ETH数量计算对应的Keys数量
1120     function keys(uint256 _eth) 
1121         internal
1122         pure
1123         returns(uint256)
1124     {
1125         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000000);
1126     }
1127     
1128     // 根据Keys数量，计算池中ETH的数量
1129     function eth(uint256 _keys) 
1130         internal
1131         pure
1132         returns(uint256)  
1133     {
1134         return ((78125000000000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000000))) / (2))) / ((1000000000000000000).sq());
1135     }
1136 }
1137 
1138 
1139 library NameFilter {
1140     /**
1141      * @dev filters name strings
1142      * -converts uppercase to lower case.  
1143      * -makes sure it does not start/end with a space
1144      * -makes sure it does not contain multiple spaces in a row
1145      * -cannot be only numbers
1146      * -cannot start with 0x 
1147      * -restricts characters to A-Z, a-z, 0-9, and space.
1148      * @return reprocessed string in bytes32 format
1149      */
1150     function nameFilter(string _input)
1151         internal
1152         pure
1153         returns(bytes32)
1154     {
1155         bytes memory _temp = bytes(_input);
1156         uint256 _length = _temp.length;
1157         
1158         //sorry limited to 32 characters
1159         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1160         // make sure it doesnt start with or end with space
1161         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1162         // make sure first two characters are not 0x
1163         if (_temp[0] == 0x30)
1164         {
1165             require(_temp[1] != 0x78, "string cannot start with 0x");
1166             require(_temp[1] != 0x58, "string cannot start with 0X");
1167         }
1168         
1169         // create a bool to track if we have a non number character
1170         bool _hasNonNumber;
1171         
1172         // convert & check
1173         for (uint256 i = 0; i < _length; i++)
1174         {
1175             // if its uppercase A-Z
1176             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1177             {
1178                 // convert to lower case a-z
1179                 _temp[i] = byte(uint(_temp[i]) + 32);
1180                 
1181                 // we have a non number
1182                 if (_hasNonNumber == false)
1183                     _hasNonNumber = true;
1184             } else {
1185                 require
1186                 (
1187                     // require character is a space
1188                     _temp[i] == 0x20 || 
1189                     // OR lowercase a-z
1190                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1191                     // or 0-9
1192                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1193                     "string contains invalid characters"
1194                 );
1195                 // make sure theres not 2x spaces in a row
1196                 if (_temp[i] == 0x20)
1197                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1198                 
1199                 // see if we have a character other than a number
1200                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1201                     _hasNonNumber = true;    
1202             }
1203         }
1204         
1205         require(_hasNonNumber == true, "string cannot be only numbers");
1206         
1207         bytes32 _ret;
1208         assembly {
1209             _ret := mload(add(_temp, 32))
1210         }
1211         return (_ret);
1212     }
1213 }
1214 
1215 
1216 library SafeMath {
1217     
1218     /**
1219     * @dev Multiplies two numbers, throws on overflow.
1220     */
1221     function mul(uint256 a, uint256 b) 
1222         internal 
1223         pure 
1224         returns (uint256 c) 
1225     {
1226         if (a == 0) {
1227             return 0;
1228         }
1229         c = a * b;
1230         require(c / a == b, "SafeMath mul failed");
1231         return c;
1232     }
1233 
1234     /**
1235     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1236     */
1237     function sub(uint256 a, uint256 b)
1238         internal
1239         pure
1240         returns (uint256) 
1241     {
1242         require(b <= a, "SafeMath sub failed");
1243         return a - b;
1244     }
1245 
1246     /**
1247     * @dev Adds two numbers, throws on overflow.
1248     */
1249     function add(uint256 a, uint256 b)
1250         internal
1251         pure
1252         returns (uint256 c) 
1253     {
1254         c = a + b;
1255         require(c >= a, "SafeMath add failed");
1256         return c;
1257     }
1258     
1259     /**
1260      * @dev gives square root of given x.
1261      */
1262     function sqrt(uint256 x)
1263         internal
1264         pure
1265         returns (uint256 y) 
1266     {
1267         uint256 z = ((add(x,1)) / 2);
1268         y = x;
1269         while (z < y) 
1270         {
1271             y = z;
1272             z = ((add((x / z),z)) / 2);
1273         }
1274     }
1275     
1276     /**
1277      * @dev gives square. multiplies x by x
1278      */
1279     function sq(uint256 x)
1280         internal
1281         pure
1282         returns (uint256)
1283     {
1284         return (mul(x,x));
1285     }
1286     
1287     /**
1288      * @dev x to the power of y 
1289      */
1290     function pwr(uint256 x, uint256 y)
1291         internal 
1292         pure 
1293         returns (uint256)
1294     {
1295         if (x==0)
1296             return (0);
1297         else if (y==0)
1298             return (1);
1299         else 
1300         {
1301             uint256 z = x;
1302             for (uint256 i=1; i < y; i++)
1303                 z = mul(z,x);
1304             return (z);
1305         }
1306     }
1307 }