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
158     uint256 constant private roundGap_ = 86400;    // 每两局比赛的间隔（state为0的阶段）：24小时
159     uint256 constant private killingGap_ = 86400;   // 淘汰间隔（上一次淘汰时间 + 淘汰间隔 = 下一次淘汰时间）：24小时
160     uint256 constant private registrationFee_ = 10 finney;    // 名字注册费
161 
162     // Player
163     uint256 public pID_;    // 玩家总数
164     mapping (address => uint256) public pIDxAddr_;  // (addr => pID) returns player id by address
165     mapping (bytes32 => uint256) public pIDxName_;  // (name => pID) returns player id by name
166     mapping (uint256 => Player) public plyr_;   // (pID => data) player data
167     
168     // Round
169     uint256 public rID_;    // 当前局ID
170     mapping (uint256 => Round) public round_;   // 局ID => 局数据
171 
172     // Player Rounds
173     mapping (uint256 => mapping (uint256 => PlayerRounds)) public plyrRnds_;  // 玩家ID => 局ID => 玩家在这局中的数据
174 
175     // Team
176     mapping (uint256 => mapping (uint256 => Team)) public rndTms_;  // 局ID => 队ID => 队伍在这局中的数
177     mapping (uint256 => mapping (bytes32 => uint256)) public rndTIDxName_;  // (rID => team name => tID) returns team id by name
178 
179     // =============
180     // CONSTRUCTOR
181     // =============
182 
183     constructor() public {
184         owner = msg.sender;
185     }
186 
187     // =============
188     // MODIFIERS
189     // =============
190 
191     // 合约作者才能操作
192     modifier onlyOwner() {
193         require(msg.sender == owner);
194         _;
195     }
196 
197     // 合约是否已激活
198     modifier isActivated() {
199         require(activated_ == true, "its not ready yet."); 
200         _;
201     }
202     
203     // 只接受用户调用，不接受合约调用
204     modifier isHuman() {
205         require(tx.origin == msg.sender, "sorry humans only");
206         _;
207     }
208 
209     // 交易限额
210     modifier isWithinLimits(uint256 _eth) {
211         require(_eth >= 1000000000, "no less than 1 Gwei");
212         require(_eth <= 100000000000000000000000, "no more than 100000 ether");
213         _;
214     }
215 
216     // =====================
217     // PUBLIC INTERACTION
218     // =====================
219 
220     // 直接打到合约中的钱会由这个方法处理【不推荐，请勿使用】
221     // 默认使用上一个邀请人，且资金进入当前领先队伍
222     function()
223         public
224         payable
225         isActivated()
226         isHuman()
227         isWithinLimits(msg.value)
228     {
229         buy(round_[rID_].team, "");
230     }
231 
232     // 购买
233     // 邀请码只能是用户名，不支持用户ID或Address
234     function buy(uint256 _team, bytes32 _affCode)
235         public
236         payable
237         isActivated()
238         isHuman()
239         isWithinLimits(msg.value)
240     {
241         // 确保比赛尚未结束
242         require(round_[rID_].state < 3, "This round has ended.");
243 
244         // 确保比赛已经开始
245         if (round_[rID_].state == 0){
246             require(now >= round_[rID_].start, "This round hasn't started yet.");
247             round_[rID_].state = 1;
248         }
249 
250         // 获取玩家ID
251         // 如果不存在，会创建新玩家档案
252         determinePID(msg.sender);
253         uint256 _pID = pIDxAddr_[msg.sender];
254         uint256 _tID;
255 
256         // 邀请码处理
257         // 只能是用户名，不支持用户ID或Address
258         uint256 _affID;
259         if (_affCode == "" || _affCode == plyr_[_pID].name){
260             // 如果没有邀请码，则使用上一个邀请码
261             _affID = plyr_[_pID].laff;
262         } else {
263             // 如果存在邀请码，则获取对应的玩家ID
264             _affID = pIDxName_[_affCode];
265             
266             // 更新玩家的最近邀请人
267             if (_affID != plyr_[_pID].laff){
268                 plyr_[_pID].laff = _affID;
269             }
270         }
271 
272         // 购买处理
273         if (round_[rID_].state == 1){
274             // Check team id
275             _tID = determinTID(_team, _pID);
276 
277             // Buy
278             buyCore(_pID, _affID, _tID, msg.value);
279 
280             // 达到16支队伍就进入淘汰阶段（state: 2）
281             if (round_[rID_].tID_ >= 16){
282                 // 进入淘汰阶段
283                 round_[rID_].state = 2;
284 
285                 // 初始化设置
286                 startKilling();
287             }
288 
289         } else if (round_[rID_].state == 2){
290             // 是否触发结束
291             if (round_[rID_].liveTeams == 1){
292                 // 结束
293                 endRound();
294                 
295                 // 退还资金到钱包账户
296                 refund(_pID, msg.value);
297 
298                 return;
299             }
300 
301             // Check team id
302             _tID = determinTID(_team, _pID);
303 
304             // Buy
305             buyCore(_pID, _affID, _tID, msg.value);
306 
307             // Kill if needed
308             if (now > round_[rID_].lastKillingTime.add(killingGap_)) {
309                 kill();
310             }
311         }
312     }
313 
314     // 钱包提币
315     function withdraw()
316         public
317         isActivated()
318         isHuman()
319     {
320         // fetch player ID
321         uint256 _pID = pIDxAddr_[msg.sender];
322 
323         // 确保玩家存在
324         require(_pID != 0, "Please join the game first!");
325 
326         // 提现金额
327         uint256 _eth;
328 
329         // 如果存在已经结束的轮次，计算我尚未提现的收益
330         if (rID_ > 1){
331             for (uint256 i = 1; i < rID_; i++) {
332                 // 如果尚未提现，则提出金额
333                 if (plyrRnds_[_pID][i].withdrawn == false){
334                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
335                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
336                     }
337                     plyrRnds_[_pID][i].withdrawn = true;
338                 }
339             }
340         }
341 
342         _eth = _eth.add(plyr_[_pID].gen).add(plyr_[_pID].aff);
343 
344         // 转账
345         if (_eth > 0) {
346             plyr_[_pID].addr.transfer(_eth);
347         }
348 
349         // 清空钱包余额
350         plyr_[_pID].gen = 0;
351         plyr_[_pID].aff = 0;
352 
353         // Event 提现
354         emit onWithdraw(_pID, plyr_[_pID].addr, plyr_[_pID].name, _eth, now);
355     }
356 
357     // 注册玩家名字
358     function registerNameXID(string _nameString)
359         public
360         payable
361         isHuman()
362     {
363         // make sure name fees paid
364         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
365         
366         // filter name + condition checks
367         bytes32 _name = NameFilter.nameFilter(_nameString);
368         
369         // set up address 
370         address _addr = msg.sender;
371         
372         // set up our tx event data and determine if player is new or not
373         // bool _isNewPlayer = determinePID(_addr);
374         bool _isNewPlayer = determinePID(_addr);
375         
376         // fetch player id
377         uint256 _pID = pIDxAddr_[_addr];
378 
379         // 确保这个名字还没有人用
380         require(pIDxName_[_name] == 0, "sorry that names already taken");
381         
382         // add name to player profile, registry, and name book
383         plyr_[_pID].name = _name;
384         pIDxName_[_name] = _pID;
385 
386         // deposit registration fee
387         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
388         
389         // Event
390         emit onNewName(_pID, _addr, _name, _isNewPlayer, msg.value, now);
391     }
392 
393     // 注册队伍名字
394     // 只能由队长设置
395     function setTeamName(uint256 _tID, string _nameString)
396         public
397         payable
398         isHuman()
399     {
400         // 要求team id存在
401         require(_tID <= round_[rID_].tID_ && _tID != 0, "There's no this team.");
402         
403         // fetch player ID
404         uint256 _pID = pIDxAddr_[msg.sender];
405         
406         // 要求必须是队长
407         require(_pID == rndTms_[rID_][_tID].leaderID, "Only team leader can change team name. You can invest more money to be the team leader.");
408         
409         // 需要注册费
410         require (msg.value >= registrationFee_, "You have to pay the name fee.(10 finney)");
411         
412         // filter name + condition checks
413         bytes32 _name = NameFilter.nameFilter(_nameString);
414 
415         require(rndTIDxName_[rID_][_name] == 0, "sorry that names already taken");
416         
417         // add name to team
418         rndTms_[rID_][_tID].name = _name;
419         rndTIDxName_[rID_][_name] = _tID;
420 
421         // deposit registration fee
422         plyr_[1].gen = (msg.value).add(plyr_[1].gen);
423 
424         // event
425         emit onNewTeamName(_tID, _name, _pID, plyr_[_pID].name, msg.value, now);
426     }
427 
428     //==============
429     // GETTERS
430     //==============
431 
432     // 检查名字可注册
433     function checkIfNameValid(string _nameStr)
434         public
435         view
436         returns (bool)
437     {
438         bytes32 _name = _nameStr.nameFilter();
439         if (pIDxName_[_name] == 0)
440             return (true);
441         else 
442             return (false);
443     }
444 
445     // 查询：距离下一次淘汰的时间
446     function getNextKillingAfter()
447         public
448         view
449         returns (uint256)
450     {
451         require(round_[rID_].state == 2, "Not in killing period.");
452 
453         uint256 _tNext = round_[rID_].lastKillingTime.add(killingGap_);
454         uint256 _t = _tNext > now ? _tNext.sub(now) : 0;
455 
456         return _t;
457     }
458 
459     // 查询：单个玩家本轮信息 (前端查询用户钱包也是这个方法)
460     // 返回：玩家ID，地址，名字，gen，aff，本轮投资额，本轮预计收益，未提现收益
461     function getPlayerInfoByAddress(address _addr)
462         public 
463         view 
464         returns(uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
465     {
466         if (_addr == address(0))
467         {
468             _addr == msg.sender;
469         }
470         uint256 _pID = pIDxAddr_[_addr];
471 
472         return (
473             _pID,
474             _addr,
475             plyr_[_pID].name,
476             plyr_[_pID].gen,
477             plyr_[_pID].aff,
478             plyrRnds_[_pID][rID_].eth,
479             getProfit(_pID),
480             getPreviousProfit(_pID)
481         );
482     }
483 
484     // 查询: 玩家在某轮对某队的投资（_roundID = 0 表示当前轮）
485     // 返回 keys
486     function getPlayerRoundTeamBought(uint256 _pID, uint256 _roundID, uint256 _tID)
487         public
488         view
489         returns (uint256)
490     {
491         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
492         return plyrRnds_[_pID][_rID].plyrTmKeys[_tID];
493     }
494 
495     // 查询: 玩家在某轮的全部投资（_roundID = 0 表示当前轮）
496     // 返回 keysList数组 (keysList[i]表示用户在i+1队的份额)
497     function getPlayerRoundBought(uint256 _pID, uint256 _roundID)
498         public
499         view
500         returns (uint256[])
501     {
502         uint256 _rID = _roundID == 0 ? rID_ : _roundID;
503 
504         // 该轮队伍总数
505         uint256 _tCount = round_[_rID].tID_;
506 
507         // 玩家在各队的keys
508         uint256[] memory keysList = new uint256[](_tCount);
509 
510         // 生成数组
511         for (uint i = 0; i < _tCount; i++) {
512             keysList[i] = plyrRnds_[_pID][_rID].plyrTmKeys[i+1];
513         }
514 
515         return keysList;
516     }
517 
518     // 查询：玩家在各轮的成绩（包含本赛季，但是收益为0）
519     // 返回 {ethList, winList}  (ethList[i]表示第i+1个赛季的投资)
520     function getPlayerRounds(uint256 _pID)
521         public
522         view
523         returns (uint256[], uint256[])
524     {
525         uint256[] memory _ethList = new uint256[](rID_);
526         uint256[] memory _winList = new uint256[](rID_);
527         for (uint i=0; i < rID_; i++){
528             _ethList[i] = plyrRnds_[_pID][i+1].eth;
529             _winList[i] = plyrRnds_[_pID][i+1].plyrTmKeys[round_[i+1].team].mul(round_[i+1].ethPerKey) / 1000000000000000000;
530         }
531 
532         return (
533             _ethList,
534             _winList
535         );
536     }
537 
538     // 查询：上一局信息
539     // 返回：局ID，状态，奖池金额，获胜队伍ID，队伍名字，队伍人数，总队伍数
540     // 如果不存在上一局，会返回一堆0
541     function getLastRoundInfo()
542         public
543         view
544         returns (uint256, uint256, uint256, uint256, bytes32, uint256, uint256)
545     {
546         // last round id
547         uint256 _rID = rID_.sub(1);
548 
549         // last winner
550         uint256 _tID = round_[_rID].team;
551 
552         return (
553             _rID,
554             round_[_rID].state,
555             round_[_rID].pot,
556             _tID,
557             rndTms_[_rID][_tID].name,
558             rndTms_[_rID][_tID].playersCount,
559             round_[_rID].tID_
560         );
561     }
562 
563     // 查询：本局比赛信息
564     function getCurrentRoundInfo()
565         public
566         view
567         returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
568     {
569         return (
570             rID_,
571             round_[rID_].state,
572             round_[rID_].eth,
573             round_[rID_].pot,
574             round_[rID_].keys,
575             round_[rID_].team,
576             round_[rID_].ethPerKey,
577             round_[rID_].lastKillingTime,
578             killingGap_,
579             round_[rID_].deadRate,
580             round_[rID_].deadKeys,
581             round_[rID_].liveTeams,
582             round_[rID_].tID_,
583             round_[rID_].start
584         );
585     }
586 
587     // 查询：某支队伍信息
588     // 返回：基本信息，队伍成员，及其投资金额
589     function getTeamInfoByID(uint256 _tID) 
590         public
591         view
592         returns (uint256, bytes32, uint256, uint256, uint256, uint256, bool)
593     {
594         require(_tID <= round_[rID_].tID_, "There's no this team.");
595         
596         return (
597             rndTms_[rID_][_tID].id,
598             rndTms_[rID_][_tID].name,
599             rndTms_[rID_][_tID].keys,
600             rndTms_[rID_][_tID].eth,
601             rndTms_[rID_][_tID].price,
602             rndTms_[rID_][_tID].leaderID,
603             rndTms_[rID_][_tID].dead
604         );
605     }
606 
607     // 查询：所有队伍的信息
608     // 返回：id[], name[], keys[], eth[], price[], playersCount[], dead[]
609     function getTeamsInfo()
610         public
611         view
612         returns (uint256[], bytes32[], uint256[], uint256[], uint256[], uint256[], bool[])
613     {
614         uint256 _tID = round_[rID_].tID_;
615 
616         // Lists of Team Info
617         uint256[] memory _idList = new uint256[](_tID);
618         bytes32[] memory _nameList = new bytes32[](_tID);
619         uint256[] memory _keysList = new uint256[](_tID);
620         uint256[] memory _ethList = new uint256[](_tID);
621         uint256[] memory _priceList = new uint256[](_tID);
622         uint256[] memory _membersList = new uint256[](_tID);
623         bool[] memory _deadList = new bool[](_tID);
624 
625         // Data
626         for (uint i = 0; i < _tID; i++) {
627             _idList[i] = rndTms_[rID_][i+1].id;
628             _nameList[i] = rndTms_[rID_][i+1].name;
629             _keysList[i] = rndTms_[rID_][i+1].keys;
630             _ethList[i] = rndTms_[rID_][i+1].eth;
631             _priceList[i] = rndTms_[rID_][i+1].price;
632             _membersList[i] = rndTms_[rID_][i+1].playersCount;
633             _deadList[i] = rndTms_[rID_][i+1].dead;
634         }
635 
636         return (
637             _idList,
638             _nameList,
639             _keysList,
640             _ethList,
641             _priceList,
642             _membersList,
643             _deadList
644         );
645     }
646 
647     // 获取每个队伍中的队长信息
648     // 返回：leaderID[], leaderName[], leaderAddr[]
649     function getTeamLeaders()
650         public
651         view
652         returns (uint256[], uint256[], bytes32[], address[])
653     {
654         uint256 _tID = round_[rID_].tID_;
655 
656         // Teams' leaders info
657         uint256[] memory _idList = new uint256[](_tID);
658         uint256[] memory _leaderIDList = new uint256[](_tID);
659         bytes32[] memory _leaderNameList = new bytes32[](_tID);
660         address[] memory _leaderAddrList = new address[](_tID);
661 
662         // Data
663         for (uint i = 0; i < _tID; i++) {
664             _idList[i] = rndTms_[rID_][i+1].id;
665             _leaderIDList[i] = rndTms_[rID_][i+1].leaderID;
666             _leaderNameList[i] = plyr_[_leaderIDList[i]].name;
667             _leaderAddrList[i] = rndTms_[rID_][i+1].leaderAddr;
668         }
669 
670         return (
671             _idList,
672             _leaderIDList,
673             _leaderNameList,
674             _leaderAddrList
675         );
676     }
677 
678     // 查询：预测本局的收益（假定目前领先的队伍赢）
679     // 返回：eth
680     function getProfit(uint256 _pID)
681         public
682         view
683         returns (uint256)
684     {
685         // 领先队伍ID
686         uint256 _tID = round_[rID_].team;
687 
688         // 如果用户不持有领先队伍股份，则返回0
689         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
690             return 0;
691         }
692 
693         // 我投资获胜的队伍Keys
694         uint256 _keys = plyrRnds_[_pID][rID_].plyrTmKeys[_tID];
695         
696         // 计算每把Key的价值
697         uint256 _ethPerKey = round_[rID_].pot.mul(1000000000000000000) / rndTms_[rID_][_tID].keys;
698         
699         // 我的Keys对应的总价值
700         uint256 _value = _keys.mul(_ethPerKey) / 1000000000000000000;
701 
702         return _value;
703     }
704 
705     // 查询：此前轮尚未提现的收益
706     function getPreviousProfit(uint256 _pID)
707         public
708         view
709         returns (uint256)
710     {
711         uint256 _eth;
712 
713         if (rID_ > 1){
714             // 计算我已结束的每轮中，尚未提现的收益
715             for (uint256 i = 1; i < rID_; i++) {
716                 if (plyrRnds_[_pID][i].withdrawn == false){
717                     if (plyrRnds_[_pID][i].plyrTmKeys[round_[i].team] != 0) {
718                         _eth = _eth.add(round_[i].ethPerKey.mul(plyrRnds_[_pID][i].plyrTmKeys[round_[i].team]) / 1000000000000000000);
719                     }
720                 }
721             }
722         } else {
723             // 如果还没有已结束的轮次，则返回0
724             _eth = 0;
725         }
726 
727         // 返回
728         return _eth;
729     }
730 
731     // 下一个完整Key的价格
732     function getNextKeyPrice(uint256 _tID)
733         public 
734         view 
735         returns(uint256)
736     {  
737         require(_tID <= round_[rID_].tID_ && _tID != 0, "No this team.");
738 
739         return ( (rndTms_[rID_][_tID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
740     }
741 
742     // 购买某队X数量Keys，需要多少Eth？
743     function getEthFromKeys(uint256 _tID, uint256 _keys)
744         public
745         view
746         returns(uint256)
747     {
748         if (_tID <= round_[rID_].tID_ && _tID != 0){
749             // 如果_tID存在，则正常计算
750             return ((rndTms_[rID_][_tID].keys.add(_keys)).ethRec(_keys));
751         } else {
752             // 如果_tID不存在，则认为是新队伍
753             return ((uint256(0).add(_keys)).ethRec(_keys));
754         }
755     }
756 
757     // X数量Eth，可以买到某队多少keys？
758     function getKeysFromEth(uint256 _tID, uint256 _eth)
759         public
760         view
761         returns (uint256)
762     {
763         if (_tID <= round_[rID_].tID_ && _tID != 0){
764             // 如果_tID存在，则正常计算
765             return (rndTms_[rID_][_tID].eth).keysRec(_eth);
766         } else {
767             // 如果_tID不存在，则认为是新队伍
768             return (uint256(0).keysRec(_eth));
769         }
770     }
771 
772     // ==========================
773     //   PRIVATE: CORE GAME LOGIC
774     // ==========================
775 
776     // 核心购买方法
777     function buyCore(uint256 _pID, uint256 _affID, uint256 _tID, uint256 _eth)
778         private
779     {
780         uint256 _keys = (rndTms_[rID_][_tID].eth).keysRec(_eth);
781 
782         // 更新Player、Team、Round数据
783         // player
784         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] == 0){
785             rndTms_[rID_][_tID].playersCount++;
786         }
787         plyrRnds_[_pID][rID_].plyrTmKeys[_tID] = _keys.add(plyrRnds_[_pID][rID_].plyrTmKeys[_tID]);
788         plyrRnds_[_pID][rID_].eth = _eth.add(plyrRnds_[_pID][rID_].eth);
789 
790         // Team
791         rndTms_[rID_][_tID].keys = _keys.add(rndTms_[rID_][_tID].keys);
792         rndTms_[rID_][_tID].eth = _eth.add(rndTms_[rID_][_tID].eth);
793         rndTms_[rID_][_tID].price = _eth.mul(1000000000000000000) / _keys;
794         uint256 _teamLeaderID = rndTms_[rID_][_tID].leaderID;
795         // refresh team leader
796         if (plyrRnds_[_pID][rID_].plyrTmKeys[_tID] > plyrRnds_[_teamLeaderID][rID_].plyrTmKeys[_tID]){
797             rndTms_[rID_][_tID].leaderID = _pID;
798             rndTms_[rID_][_tID].leaderAddr = msg.sender;
799         }
800 
801         // Round
802         round_[rID_].keys = _keys.add(round_[rID_].keys);
803         round_[rID_].eth = _eth.add(round_[rID_].eth);
804         // refresh round leader
805         if (rndTms_[rID_][_tID].keys > rndTms_[rID_][round_[rID_].team].keys){
806             round_[rID_].team = _tID;
807         }
808 
809         // 资金分配
810         distribute(rID_, _pID, _eth, _affID);
811 
812         // Event
813         emit onTx(_pID, msg.sender, plyr_[_pID].name, _tID, rndTms_[rID_][_tID].name, _eth, _keys);
814     }
815 
816     // 资金分配
817     function distribute(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
818         private
819     {
820         // [1] com - 3%
821         uint256 _com = (_eth.mul(3)) / 100;
822 
823         // pay community reward
824         plyr_[1].gen = _com.add(plyr_[1].gen);
825 
826         // [2] aff - 10%
827         uint256 _aff = _eth / 10;
828 
829         if (_affID != _pID && plyr_[_affID].name != "") {
830             // pay aff
831             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
832             
833             // Event 邀请奖励
834             emit onAffPayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
835         } else {
836             // 如果没有邀请人，则这部分资金并入最终奖池
837             // 它并不会影响玩家买到的Keys数量，只会增加最终奖池的金额
838             _aff = 0;
839         }
840 
841         // [3] pot - 87%
842         uint256 _pot = _eth.sub(_aff).sub(_com);
843 
844         // 更新本局奖池
845         round_[_rID].pot = _pot.add(round_[_rID].pot);
846     }
847 
848     // 结束流程（只能执行一次）
849     function endRound()
850         private
851     {
852         require(round_[rID_].state < 3, "Round only end once.");
853         
854         // 本轮状态更新
855         round_[rID_].state = 3;
856 
857         // 奖池金额
858         uint256 _pot = round_[rID_].pot;
859 
860         // Devide Round Pot
861         // [1] winner 77%
862         uint256 _win = (_pot.mul(77))/100;
863 
864         // [2] com 3%
865         uint256 _com = (_pot.mul(3))/100;
866 
867         // [3] next round 20%
868         uint256 _res = (_pot.sub(_win)).sub(_com);
869 
870         // 获胜队伍
871         uint256 _tID = round_[rID_].team;
872         // 计算ethPerKey (每个完整的key对应多少个wei, A Full Key = 10**18 keys)
873         uint256 _epk = (_win.mul(1000000000000000000)) / (rndTms_[rID_][_tID].keys);
874 
875         // 考虑dust
876         uint256 _dust = _win.sub((_epk.mul(rndTms_[rID_][_tID].keys)) / 1000000000000000000);
877         if (_dust > 0) {
878             _win = _win.sub(_dust);
879             _res = _res.add(_dust);
880         }
881 
882         // pay winner team
883         round_[rID_].ethPerKey = _epk;
884 
885         // pay community reward
886         plyr_[1].gen = _com.add(plyr_[1].gen);
887 
888         // Event
889         emit onEndRound(_tID, rndTms_[rID_][_tID].name, rndTms_[rID_][_tID].playersCount, _pot);
890 
891         // 进入下一局
892         rID_++;
893         round_[rID_].pot = _res;
894         round_[rID_].start = now + roundGap_;
895     }
896     
897     // 退款到钱包账户
898     function refund(uint256 _pID, uint256 _value)
899         private
900     {
901         plyr_[_pID].gen = _value.add(plyr_[_pID].gen);
902     }
903 
904     // 创建队伍
905     // 返回 队伍ID
906     function createTeam(uint256 _pID, uint256 _eth)
907         private
908         returns (uint256)
909     {
910         // 队伍总数不能多于99支
911         require(round_[rID_].tID_ < 99, "No more than 99 teams.");
912 
913         // 创建队伍至少需要投资1eth
914         require(_eth >= 1000000000000000000, "You need at least 1 eth to create a team, though creating a new team is free.");
915 
916         // 本局队伍数和存活队伍数增加
917         round_[rID_].tID_++;
918         round_[rID_].liveTeams++;
919         
920         // 新队伍ID
921         uint256 _tID = round_[rID_].tID_;
922         
923         // 新队伍数据
924         rndTms_[rID_][_tID].id = _tID;
925         rndTms_[rID_][_tID].leaderID = _pID;
926         rndTms_[rID_][_tID].leaderAddr = plyr_[_pID].addr;
927         rndTms_[rID_][_tID].dead = false;
928 
929         return _tID;
930     }
931 
932     // 初始化各项杀戮参数
933     function startKilling()
934         private
935     {   
936         // 初始回合的基本参数
937         round_[rID_].lastKillingTime = now;
938         round_[rID_].deadRate = 10;     // 百分比，按照 deadRate / 100 来使用
939         round_[rID_].deadKeys = (rndTms_[rID_][round_[rID_].team].keys.mul(round_[rID_].deadRate)) / 100;
940     }
941 
942     // 杀戮淘汰
943     function kill()
944         private
945     {
946         // 本回合死亡队伍数
947         uint256 _dead = 0;
948 
949         // 少于淘汰线的队伍淘汰
950         for (uint256 i = 1; i <= round_[rID_].tID_; i++) {
951             if (rndTms_[rID_][i].keys < round_[rID_].deadKeys && rndTms_[rID_][i].dead == false){
952                 rndTms_[rID_][i].dead = true;
953                 round_[rID_].liveTeams--;
954                 _dead++;
955             }
956         }
957 
958         round_[rID_].lastKillingTime = now;
959 
960         // 如果只剩一支队伍，则启动结束程序
961         if (round_[rID_].liveTeams == 1 && round_[rID_].state == 2) {
962             endRound();
963             return;
964         }
965 
966         // 更新淘汰比率（如果参数修改了，要注意此处判断条件）
967         if (round_[rID_].deadRate < 90) {
968             round_[rID_].deadRate = round_[rID_].deadRate + 10;
969         }
970 
971         // 更新下一回合淘汰线
972         round_[rID_].deadKeys = ((rndTms_[rID_][round_[rID_].team].keys).mul(round_[rID_].deadRate)) / 100;
973 
974         // event
975         emit onKill(_dead, round_[rID_].liveTeams, round_[rID_].deadKeys);
976     }
977 
978     // 通过地址查询玩家ID，如果没有，就创建新玩家
979     // 返回：是否为新玩家
980     function determinePID(address _addr)
981         private
982         returns (bool)
983     {
984         if (pIDxAddr_[_addr] == 0)
985         {
986             pID_++;
987             pIDxAddr_[_addr] = pID_;
988             plyr_[pID_].addr = _addr;
989             
990             return (true);  // 新玩家
991         } else {
992             return (false);
993         }
994     }
995 
996     // 队伍编号检查，返回编号（仅在当前局使用）
997     function determinTID(uint256 _team, uint256 _pID)
998         private
999         returns (uint256)
1000     {
1001         // 确保队伍尚未淘汰
1002         require(rndTms_[rID_][_team].dead == false, "You can not buy a dead team!");
1003         
1004         if (_team <= round_[rID_].tID_ && _team > 0) {
1005             // 如果队伍已存在，则直接返回
1006             return _team;
1007         } else {
1008             // 如果队伍不存在，则创建新队伍
1009             return createTeam(_pID, msg.value);
1010         }
1011     }
1012 
1013     //==============
1014     // SECURITY
1015     //============== 
1016 
1017     // 部署完合约第一轮游戏需要我来激活整个游戏
1018     bool public activated_ = false;
1019     function activate()
1020         public
1021         onlyOwner()
1022     {   
1023         // can only be ran once
1024         require(activated_ == false, "it is already activated");
1025         
1026         // activate the contract 
1027         activated_ = true;
1028 
1029         // the first player
1030         plyr_[1].addr = owner;
1031         plyr_[1].name = "joker";
1032         pIDxAddr_[owner] = 1;
1033         pIDxName_["joker"] = 1;
1034         pID_ = 1;
1035         
1036         // 激活第一局.
1037         rID_ = 1;
1038         round_[1].start = now;
1039         round_[1].state = 1;
1040     }
1041 
1042 }   // main contract ends here
1043 
1044 
1045 // Keys价格相关计算
1046 // 【新算法】keys价格是原来的1000倍
1047 library WoeKeysCalc {
1048     using SafeMath for *;
1049 
1050     // 根据现有ETH，计算新入X个ETH能购买的Keys数量
1051     function keysRec(uint256 _curEth, uint256 _newEth)
1052         internal
1053         pure
1054         returns (uint256)
1055     {
1056         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1057     }
1058     
1059     // 根据当前Keys数量，计算卖出X数量的keys值多少ETH
1060     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1061         internal
1062         pure
1063         returns (uint256)
1064     {
1065         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1066     }
1067 
1068     // 根据池中ETH数量计算对应的Keys数量
1069     function keys(uint256 _eth) 
1070         internal
1071         pure
1072         returns(uint256)
1073     {
1074         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000000);
1075     }
1076     
1077     // 根据Keys数量，计算池中ETH的数量
1078     function eth(uint256 _keys) 
1079         internal
1080         pure
1081         returns(uint256)  
1082     {
1083         return ((78125000000000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000000))) / (2))) / ((1000000000000000000).sq());
1084     }
1085 }
1086 
1087 
1088 library NameFilter {
1089     /**
1090      * @dev filters name strings
1091      * -converts uppercase to lower case.  
1092      * -makes sure it does not start/end with a space
1093      * -makes sure it does not contain multiple spaces in a row
1094      * -cannot be only numbers
1095      * -cannot start with 0x 
1096      * -restricts characters to A-Z, a-z, 0-9, and space.
1097      * @return reprocessed string in bytes32 format
1098      */
1099     function nameFilter(string _input)
1100         internal
1101         pure
1102         returns(bytes32)
1103     {
1104         bytes memory _temp = bytes(_input);
1105         uint256 _length = _temp.length;
1106         
1107         //sorry limited to 32 characters
1108         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1109         // make sure it doesnt start with or end with space
1110         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1111         // make sure first two characters are not 0x
1112         if (_temp[0] == 0x30)
1113         {
1114             require(_temp[1] != 0x78, "string cannot start with 0x");
1115             require(_temp[1] != 0x58, "string cannot start with 0X");
1116         }
1117         
1118         // create a bool to track if we have a non number character
1119         bool _hasNonNumber;
1120         
1121         // convert & check
1122         for (uint256 i = 0; i < _length; i++)
1123         {
1124             // if its uppercase A-Z
1125             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1126             {
1127                 // convert to lower case a-z
1128                 _temp[i] = byte(uint(_temp[i]) + 32);
1129                 
1130                 // we have a non number
1131                 if (_hasNonNumber == false)
1132                     _hasNonNumber = true;
1133             } else {
1134                 require
1135                 (
1136                     // require character is a space
1137                     _temp[i] == 0x20 || 
1138                     // OR lowercase a-z
1139                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1140                     // or 0-9
1141                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1142                     "string contains invalid characters"
1143                 );
1144                 // make sure theres not 2x spaces in a row
1145                 if (_temp[i] == 0x20)
1146                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1147                 
1148                 // see if we have a character other than a number
1149                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1150                     _hasNonNumber = true;    
1151             }
1152         }
1153         
1154         require(_hasNonNumber == true, "string cannot be only numbers");
1155         
1156         bytes32 _ret;
1157         assembly {
1158             _ret := mload(add(_temp, 32))
1159         }
1160         return (_ret);
1161     }
1162 }
1163 
1164 
1165 library SafeMath {
1166     
1167     /**
1168     * @dev Multiplies two numbers, throws on overflow.
1169     */
1170     function mul(uint256 a, uint256 b) 
1171         internal 
1172         pure 
1173         returns (uint256 c) 
1174     {
1175         if (a == 0) {
1176             return 0;
1177         }
1178         c = a * b;
1179         require(c / a == b, "SafeMath mul failed");
1180         return c;
1181     }
1182 
1183     /**
1184     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1185     */
1186     function sub(uint256 a, uint256 b)
1187         internal
1188         pure
1189         returns (uint256) 
1190     {
1191         require(b <= a, "SafeMath sub failed");
1192         return a - b;
1193     }
1194 
1195     /**
1196     * @dev Adds two numbers, throws on overflow.
1197     */
1198     function add(uint256 a, uint256 b)
1199         internal
1200         pure
1201         returns (uint256 c) 
1202     {
1203         c = a + b;
1204         require(c >= a, "SafeMath add failed");
1205         return c;
1206     }
1207     
1208     /**
1209      * @dev gives square root of given x.
1210      */
1211     function sqrt(uint256 x)
1212         internal
1213         pure
1214         returns (uint256 y) 
1215     {
1216         uint256 z = ((add(x,1)) / 2);
1217         y = x;
1218         while (z < y) 
1219         {
1220             y = z;
1221             z = ((add((x / z),z)) / 2);
1222         }
1223     }
1224     
1225     /**
1226      * @dev gives square. multiplies x by x
1227      */
1228     function sq(uint256 x)
1229         internal
1230         pure
1231         returns (uint256)
1232     {
1233         return (mul(x,x));
1234     }
1235     
1236     /**
1237      * @dev x to the power of y 
1238      */
1239     function pwr(uint256 x, uint256 y)
1240         internal 
1241         pure 
1242         returns (uint256)
1243     {
1244         if (x==0)
1245             return (0);
1246         else if (y==0)
1247             return (1);
1248         else 
1249         {
1250             uint256 z = x;
1251             for (uint256 i=1; i < y; i++)
1252                 z = mul(z,x);
1253             return (z);
1254         }
1255     }
1256 }