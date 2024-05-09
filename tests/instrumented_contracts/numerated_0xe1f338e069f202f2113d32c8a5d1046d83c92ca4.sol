1 pragma solidity ^0.4.24;
2 /**
3 *                                        ,   ,
4 *                                        $,  $,     ,
5 *                                        "ss.$ss. .s'
6 *                                ,     .ss$$$$$$$$$$s,
7 *                                $. s$$$$$$$$$$$$$$`$$Ss
8 *                                "$$$$$$$$$$$$$$$$$$o$$$       ,
9 *                               s$$$$$$$$$$$$$$$$$$$$$$$$s,  ,s
10 *                              s$$$$$$$$$"$$$$$$""""$$$$$$"$$$$$,
11 *                              s$$$$$$$$$$s""$$$$ssssss"$$$$$$$$"
12 *                             s$$$$$$$$$$'         `"""ss"$"$s""
13 *                             s$$$$$$$$$$,              `"""""$  .s$$s
14 *                             s$$$$$$$$$$$$s,...               `s$$'  `
15 *                         `ssss$$$$$$$$$$$$$$$$$$$$####s.     .$$"$.   , s-
16 *                           `""""$$$$$$$$$$$$$$$$$$$$#####$$$$$$"     $.$'
17 * 祝你成功                        "$$$$$$$$$$$$$$$$$$$$$####s""     .$$$|
18 *   福    喜喜                        "$$$$$$$$$$$$$$$$$$$$$$$$##s    .$$" $
19 *                                   $$""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"   `
20 *                                  $$"  "$"$$$$$$$$$$$$$$$$$$$$S""""'
21 *                             ,   ,"     '  $$$$$$$$$$$$$$$$####s
22 *                             $.          .s$$$$$$$$$$$$$$$$$####"
23 *                 ,           "$s.   ..ssS$$$$$$$$$$$$$$$$$$$####"
24 *                 $           .$$$S$$$$$$$$$$$$$$$$$$$$$$$$#####"
25 *                 Ss     ..sS$$$$$$$$$$$$$$$$$$$$$$$$$$$######""
26 *                  "$$sS$$$$$$$$$$$$$$$$$$$$$$$$$$$########"
27 *           ,      s$$$$$$$$$$$$$$$$$$$$$$$$#########""'
28 *           $    s$$$$$$$$$$$$$$$$$$$$$#######""'      s'         ,
29 *           $$..$$$$$$$$$$$$$$$$$$######"'       ....,$$....    ,$
30 *            "$$$$$$$$$$$$$$$######"' ,     .sS$$$$$$$$$$$$$$$$s$$
31 *              $$$$$$$$$$$$#####"     $, .s$$$$$$$$$$$$$$$$$$$$$$$$s.
32 *   )          $$$$$$$$$$$#####'      `$$$$$$$$$###########$$$$$$$$$$$.
33 *  ((          $$$$$$$$$$$#####       $$$$$$$$###"       "####$$$$$$$$$$
34 *  ) \         $$$$$$$$$$$$####.     $$$$$$###"             "###$$$$$$$$$   s'
35 * (   )        $$$$$$$$$$$$$####.   $$$$$###"                ####$$$$$$$$s$$'
36 * )  ( (       $$"$$$$$$$$$$$#####.$$$$$###'                .###$$$$$$$$$$"
37 * (  )  )   _,$"   $$$$$$$$$$$$######.$$##'                .###$$$$$$$$$$
38 * ) (  ( \.         "$$$$$$$$$$$$$#######,,,.          ..####$$$$$$$$$$$"
39 *(   )$ )  )        ,$$$$$$$$$$$$$$$$$$####################$$$$$$$$$$$"
40 *(   ($$  ( \     _sS"  `"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$S$$,
41 * )  )$$$s ) )  .      .   `$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"'  `$$
42 *  (   $$$Ss/  .$,    .$,,s$$$$$$##S$$$$$$$$$$$$$$$$$$$$$$$$S""        '
43 *    \)_$$$$$$$$$$$$$$$$$$$$$$$##"  $$        `$$.        `$$.
44 *        `"S$$$$$$$$$$$$$$$$$#"      $          `$          `$
45 *            `"""""""""""""'         '           '           '
46 */
47 contract F3Devents {
48     // 只要玩家注册了名字就会被解雇
49     event onNewName
50     (
51         uint256 indexed playerID,
52         address indexed playerAddress,
53         bytes32 indexed playerName,
54         bool isNewPlayer,
55         uint256 affiliateID,
56         address affiliateAddress,
57         bytes32 affiliateName,
58         uint256 amountPaid,
59         uint256 timeStamp
60     );
61 
62     // 在购买或重装结束时解雇
63     event onEndTx
64     (
65         uint256 compressedData,
66         uint256 compressedIDs,
67         bytes32 playerName,
68         address playerAddress,
69         uint256 ethIn,
70         uint256 keysBought,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 P3DAmount,
76         uint256 genAmount,
77         uint256 potAmount,
78         uint256 airDropPot
79     );
80 
81     // 只要有人退出就会被解雇
82     event onWithdraw
83     (
84         uint256 indexed playerID,
85         address playerAddress,
86         bytes32 playerName,
87         uint256 ethOut,
88         uint256 timeStamp
89     );
90 
91     // 每当撤军力量结束时，就会被解雇
92     event onWithdrawAndDistribute
93     (
94         address playerAddress,
95         bytes32 playerName,
96         uint256 ethOut,
97         uint256 compressedData,
98         uint256 compressedIDs,
99         address winnerAddr,
100         bytes32 winnerName,
101         uint256 amountWon,
102         uint256 newPot,
103         uint256 P3DAmount,
104         uint256 genAmount
105     );
106 
107     // (fomo3d免费) 每当玩家尝试一轮又一轮的计时器时就会被解雇
108     // 命中零，并导致结束回合
109     event onBuyAndDistribute
110     (
111         address playerAddress,
112         bytes32 playerName,
113         uint256 ethIn,
114         uint256 compressedData,
115         uint256 compressedIDs,
116         address winnerAddr,
117         bytes32 winnerName,
118         uint256 amountWon,
119         uint256 newPot,
120         uint256 P3DAmount,
121         uint256 genAmount
122     );
123 
124     // (fomo3d免费) 每当玩家在圆形时间后尝试重新加载时就会触发
125     // 命中零，并导致结束回合.
126     event onReLoadAndDistribute
127     (
128         address playerAddress,
129         bytes32 playerName,
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
140     // 每当联盟会员付款时就会被解雇
141     event onAffiliatePayout
142     (
143         uint256 indexed affiliateID,
144         address affiliateAddress,
145         bytes32 affiliateName,
146         uint256 indexed roundID,
147         uint256 indexed buyerID,
148         uint256 amount,
149         uint256 timeStamp
150     );
151 
152     // 收到罐子掉期存款
153     event onPotSwapDeposit
154     (
155         uint256 roundID,
156         uint256 amountAddedToPot
157     );
158 }
159 
160 //==============================================================================
161 //   _ _  _ _|_ _ _  __|_   _ _ _|_    _   .
162 //  (_(_)| | | | (_|(_ |   _\(/_ | |_||_)  .
163 //====================================|=========================================
164 
165 contract modularShort is F3Devents {}
166 
167 contract WorldFomo is modularShort {
168     using SafeMath for *;
169     using NameFilter for string;
170     using F3DKeysCalcShort for uint256;
171 
172     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0x6ed17ee485821cd47531f2e4c7b9ef8b48f2bab5);
173 
174 //==============================================================================
175 //     _ _  _  |`. _     _ _ |_ | _  _  .
176 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (游戏设置)
177 //=================_|===========================================================
178     address private admin = msg.sender;
179     string constant public name = "WorldFomo";
180     string constant public symbol = "WF";
181     uint256 private rndExtra_ = 15 seconds;     // 第一个ICO的长度
182     uint256 private rndGap_ = 30 minutes;         // ICO阶段的长度，EOS设定为1年。
183     uint256 constant private rndInit_ = 30 minutes;                // 圆计时器从此开始
184     uint256 constant private rndInc_ = 10 seconds;              // 购买的每一把钥匙都会给计时器增加很多
185     uint256 constant private rndMax_ = 12 hours;                // 圆形计时器的最大长度可以是
186 //==============================================================================
187 //     _| _ _|_ _    _ _ _|_    _   .
188 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (用于存储更改的游戏信息的数据)
189 //=============================|================================================
190     uint256 public airDropPot_;             // 获得空投的人赢得了这个锅的一部分
191     uint256 public airDropTracker_ = 0;     // 每次“合格”tx发生时递增。用于确定获胜的空投
192     uint256 public rID_;    // 已发生的轮次ID /总轮数
193 //****************
194 // 球员数据
195 //****************
196     mapping (address => uint256) public pIDxAddr_;          // （addr => pID）按地址返回玩家ID
197     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID）按名称返回玩家ID
198     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) 球员数据
199     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) 玩家ID和轮次ID的玩家轮数据
200     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool）玩家拥有的名字列表。 （用于这样您可以在您拥有的任何名称中更改您的显示名称）
201 //****************
202 // 圆形数据
203 //****************
204     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) 圆形数据
205     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => 数据）每个团队的eth，by round id和team id
206 //****************
207 // 团队收费数据
208 //****************
209     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) 按团队分配费用
210     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) 锅分裂由团队分配
211 //==============================================================================
212 //     _ _  _  __|_ _    __|_ _  _  .
213 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (合同部署时的初始数据设置)
214 //==============================================================================
215     constructor()
216         public
217     {
218         // 团队分配结构
219         // 0 = europe
220         // 1 = freeforall
221         // 2 = china
222         // 3 = americas
223 
224         // 团队分配百分比
225         // (F3D, P3D) + (Pot , Referrals, Community)
226             // 介绍人 / 社区奖励在数学上被设计为来自获胜者的底池份额.
227         fees_[0] = F3Ddatasets.TeamFee(32,0);   //50% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
228         fees_[1] = F3Ddatasets.TeamFee(45,0);   //37% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
229         fees_[2] = F3Ddatasets.TeamFee(62,0);  //20% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
230         fees_[3] = F3Ddatasets.TeamFee(47,0);   //35% to pot, 15% to aff, 3% to com, 0% to pot swap, 0% to air drop pot
231 
232         // 如何根据选择的球队分割最终的底池
233         // (F3D, P3D)
234         potSplit_[0] = F3Ddatasets.PotSplit(47,0);  //25% to winner, 25% to next round, 3% to com
235         potSplit_[1] = F3Ddatasets.PotSplit(47,0);   //25% to winner, 25% to next round, 3% to com
236         potSplit_[2] = F3Ddatasets.PotSplit(62,0);  //25% to winner, 10% to next round, 3% to com
237         potSplit_[3] = F3Ddatasets.PotSplit(62,0);  //25% to winner, 10% to next round,3% to com
238     }
239 //==============================================================================
240 //     _ _  _  _|. |`. _  _ _  .
241 //    | | |(_)(_||~|~|(/_| _\  .  (这些都是安全检查)
242 //==============================================================================
243     /**
244      * @dev 用于确保在激活之前没有人可以与合同互动.
245      *
246      */
247     modifier isActivated() {
248         require(activated_ == true, "its not ready yet.  check ?eta in discord");
249         _;
250     }
251 
252     /**
253      * @dev 防止合同与fomo3d交互
254      */
255     modifier isHuman() {
256         require(msg.sender == tx.origin, "sorry humans only - FOR REAL THIS TIME");
257         _;
258     }
259 
260     /**
261      * @dev 设置传入tx的边界
262      */
263     modifier isWithinLimits(uint256 _eth) {
264         require(_eth >= 1000000000, "pocket lint: not a valid currency");
265         require(_eth <= 100000000000000000000000, "no vitalik, no");
266         _;
267     }
268 
269 //==============================================================================
270 //     _    |_ |. _   |`    _  __|_. _  _  _  .
271 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (用这些来与合同互动)
272 //====|=========================================================================
273     /**
274      * @dev 紧急购买使用最后存储的会员ID和团队潜行
275      */
276     function()
277         isActivated()
278         isHuman()
279         isWithinLimits(msg.value)
280         public
281         payable
282     {
283         // 设置我们的tx事件数据并确定玩家是否是新手
284         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
285 
286         // 获取玩家ID
287         uint256 _pID = pIDxAddr_[msg.sender];
288 
289         // 买核心
290         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
291     }
292 
293     /**
294      * @dev 将所有传入的以太坊转换为键.
295      * -functionhash- 0x8f38f309 (使用ID作为会员)
296      * -functionhash- 0x98a0871d (使用联盟会员的地址)
297      * -functionhash- 0xa65b37a1 (使用联盟会员的名称)
298      * @param _affCode 获得联盟费用的玩家的ID /地址/名称
299      * @param _team 什么球队是球员?
300      */
301     function buyXid(uint256 _affCode, uint256 _team)
302         isActivated()
303         isHuman()
304         isWithinLimits(msg.value)
305         public
306         payable
307     {
308         // 设置我们的tx事件数据并确定玩家是否是新手
309         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
310 
311         // 获取玩家ID
312         uint256 _pID = pIDxAddr_[msg.sender];
313 
314         // 管理会员残差
315         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
316         if (_affCode == 0 || _affCode == _pID)
317         {
318             // 使用最后存储的联盟代码
319             _affCode = plyr_[_pID].laff;
320 
321         // 如果提供联属代码并且它与先前存储的不同
322         } else if (_affCode != plyr_[_pID].laff) {
323             // 更新最后一个会员
324             plyr_[_pID].laff = _affCode;
325         }
326 
327         // 验证是否选择了有效的团队
328         _team = verifyTeam(_team);
329 
330         // 买核心
331         buyCore(_pID, _affCode, _team, _eventData_);
332     }
333 
334     function buyXaddr(address _affCode, uint256 _team)
335         isActivated()
336         isHuman()
337         isWithinLimits(msg.value)
338         public
339         payable
340     {
341         // 设置我们的tx事件数据并确定玩家是否是新手
342         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
343 
344         // 获取玩家ID
345         uint256 _pID = pIDxAddr_[msg.sender];
346 
347         // 管理会员残差
348         uint256 _affID;
349         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
350         if (_affCode == address(0) || _affCode == msg.sender)
351         {
352             // 使用最后存储的联盟代码
353             _affID = plyr_[_pID].laff;
354 
355         // 如果是联盟代码
356         } else {
357             // 从aff Code获取会员ID
358             _affID = pIDxAddr_[_affCode];
359 
360             // 如果affID与先前存储的不同
361             if (_affID != plyr_[_pID].laff)
362             {
363                 // 更新最后一个会员
364                 plyr_[_pID].laff = _affID;
365             }
366         }
367 
368         // 验证是否选择了有效的团队
369         _team = verifyTeam(_team);
370 
371         // 买核心
372         buyCore(_pID, _affID, _team, _eventData_);
373     }
374 
375     function buyXname(bytes32 _affCode, uint256 _team)
376         isActivated()
377         isHuman()
378         isWithinLimits(msg.value)
379         public
380         payable
381     {
382         // 设置我们的tx事件数据并确定玩家是否是新手
383         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
384 
385         // 获取玩家ID
386         uint256 _pID = pIDxAddr_[msg.sender];
387 
388         // 管理会员残差
389         uint256 _affID;
390         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
391         if (_affCode == '' || _affCode == plyr_[_pID].name)
392         {
393             // 使用最后存储的联盟代码
394             _affID = plyr_[_pID].laff;
395 
396         // 如果是联盟代码
397         } else {
398             // 从aff Code获取会员ID
399             _affID = pIDxName_[_affCode];
400 
401             // 如果affID与先前存储的不同
402             if (_affID != plyr_[_pID].laff)
403             {
404                 // 更新最后一个会员
405                 plyr_[_pID].laff = _affID;
406             }
407         }
408 
409         // 验证是否选择了有效的团队
410         _team = verifyTeam(_team);
411 
412         // 买核心
413         buyCore(_pID, _affID, _team, _eventData_);
414     }
415 
416     /**
417      * @dev 基本上与买相同，但不是你发送以太
418      * 从您的钱包中，它使用您未提取的收入.
419      * -functionhash- 0x349cdcac (使用ID作为会员)
420      * -functionhash- 0x82bfc739 (使用联盟会员的地址)
421      * -functionhash- 0x079ce327 (使用联盟会员的名称)
422      * @param _affCode 获得联盟费用的玩家的ID /地址/名称
423      * @param _team 球员在哪支球队？
424      * @param _eth 使用的收入金额（余额退回基金库）
425      */
426     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
427         isActivated()
428         isHuman()
429         isWithinLimits(_eth)
430         public
431     {
432         // 设置我们的tx事件数据
433         F3Ddatasets.EventReturns memory _eventData_;
434 
435         // 获取玩家ID
436         uint256 _pID = pIDxAddr_[msg.sender];
437 
438         // 管理会员残差
439         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
440         if (_affCode == 0 || _affCode == _pID)
441         {
442             // 使用最后存储的联盟代码
443             _affCode = plyr_[_pID].laff;
444 
445         // 如果提供联属代码并且它与先前存储的不同
446         } else if (_affCode != plyr_[_pID].laff) {
447             // 更新最后一个会员
448             plyr_[_pID].laff = _affCode;
449         }
450 
451         // 验证是否选择了有效的团队
452         _team = verifyTeam(_team);
453 
454         // 重装核心
455         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
456     }
457 
458     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
459         isActivated()
460         isHuman()
461         isWithinLimits(_eth)
462         public
463     {
464         // 设置我们的tx事件数据
465         F3Ddatasets.EventReturns memory _eventData_;
466 
467         // 获取玩家ID
468         uint256 _pID = pIDxAddr_[msg.sender];
469 
470         // 管理会员残差
471         uint256 _affID;
472         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
473         if (_affCode == address(0) || _affCode == msg.sender)
474         {
475             // 使用最后存储的联盟代码
476             _affID = plyr_[_pID].laff;
477 
478         // 如果是联盟代码
479         } else {
480             // 从aff Code获取会员ID
481             _affID = pIDxAddr_[_affCode];
482 
483             // 如果affID与先前存储的不同
484             if (_affID != plyr_[_pID].laff)
485             {
486                 // 更新最后一个会员
487                 plyr_[_pID].laff = _affID;
488             }
489         }
490 
491         // 验证是否选择了有效的团队
492         _team = verifyTeam(_team);
493 
494         // 重装核心
495         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
496     }
497 
498     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
499         isActivated()
500         isHuman()
501         isWithinLimits(_eth)
502         public
503     {
504         // 设置我们的tx事件数据
505         F3Ddatasets.EventReturns memory _eventData_;
506 
507         // 获取玩家ID
508         uint256 _pID = pIDxAddr_[msg.sender];
509 
510         // 管理会员残差
511         uint256 _affID;
512         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
513         if (_affCode == '' || _affCode == plyr_[_pID].name)
514         {
515             // 使用最后存储的联盟代码
516             _affID = plyr_[_pID].laff;
517 
518         // 如果是联盟代码
519         } else {
520             // 从aff Code获取会员ID
521             _affID = pIDxName_[_affCode];
522 
523             // 如果affID与先前存储的不同
524             if (_affID != plyr_[_pID].laff)
525             {
526                 // 更新最后一个会员
527                 plyr_[_pID].laff = _affID;
528             }
529         }
530 
531         // 验证是否选择了有效的团队
532         _team = verifyTeam(_team);
533 
534         // 重装核心
535         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
536     }
537 
538     /**
539      * @dev 撤回所有收入.
540      * -functionhash- 0x3ccfd60b
541      */
542     function withdraw()
543         isActivated()
544         isHuman()
545         public
546     {
547         // 设置本地rID
548         uint256 _rID = rID_;
549 
550         // 抓住时间
551         uint256 _now = now;
552 
553         // 获取玩家ID
554         uint256 _pID = pIDxAddr_[msg.sender];
555 
556         // 为玩家eth设置temp var
557         uint256 _eth;
558 
559         // 检查圆是否已经结束并且还没有人绕圈结束
560         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
561         {
562             // 设置我们的tx事件数据
563             F3Ddatasets.EventReturns memory _eventData_;
564 
565             // 圆形结束（分配锅）
566             round_[_rID].ended = true;
567             _eventData_ = endRound(_eventData_);
568 
569             // 得到他们的收入
570             _eth = withdrawEarnings(_pID);
571 
572             // 给钱
573             if (_eth > 0)
574                 plyr_[_pID].addr.transfer(_eth);
575 
576             // 构建事件数据
577             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
578             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
579 
580             // 火灾撤回和分发事件
581             emit F3Devents.onWithdrawAndDistribute
582             (
583                 msg.sender,
584                 plyr_[_pID].name,
585                 _eth,
586                 _eventData_.compressedData,
587                 _eventData_.compressedIDs,
588                 _eventData_.winnerAddr,
589                 _eventData_.winnerName,
590                 _eventData_.amountWon,
591                 _eventData_.newPot,
592                 _eventData_.P3DAmount,
593                 _eventData_.genAmount
594             );
595 
596         // 在任何其他情况下
597         } else {
598             // 得到他们的收入
599             _eth = withdrawEarnings(_pID);
600 
601             // 给钱
602             if (_eth > 0)
603                 plyr_[_pID].addr.transfer(_eth);
604 
605             // 消防事件
606             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
607         }
608     }
609 
610     /**
611      * @dev 使用这些来注册名称。它们只是将注册请求发送给PlayerBook合同的包装器。所以在这里注册与在那里注册是一样的。
612      * UI将始终显示您注册的姓氏，但您仍将拥有所有以前注册的名称以用作会员链接。
613      * - 必须支付注册费
614      * - 名称必须是唯一的
615      * - 名称将转换为小写
616      * - 名称不能以空格开头或结尾
617      * - 连续不能超过1个空格
618      * - 不能只是数字
619      * - 不能以0x开头
620      * - name必须至少为1个字符
621      * - 最大长度为32个字符
622      * - 允许的字符：a-z，0-9和空格
623      * -functionhash- 0x921dec21 (使用ID作为会员)
624      * -functionhash- 0x3ddd4698 (使用联盟会员的地址)
625      * -functionhash- 0x685ffd83 (使用联盟会员的名称)
626      * @param _nameString 球员想要的名字
627      * @param _affCode 会员ID，地址或推荐您的人的姓名
628      * @param _all 如果您希望将信息推送到所有游戏，则设置为true
629      * (这可能会耗费大量气体)
630      */
631     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
632         isHuman()
633         public
634         payable
635     {
636         bytes32 _name = _nameString.nameFilter();
637         address _addr = msg.sender;
638         uint256 _paid = msg.value;
639         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
640 
641         uint256 _pID = pIDxAddr_[_addr];
642 
643         // 火灾事件
644         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
645     }
646 
647     function registerNameXaddr(string _nameString, address _affCode, bool _all)
648         isHuman()
649         public
650         payable
651     {
652         bytes32 _name = _nameString.nameFilter();
653         address _addr = msg.sender;
654         uint256 _paid = msg.value;
655         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
656 
657         uint256 _pID = pIDxAddr_[_addr];
658 
659         // 火灾事件
660         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
661     }
662 
663     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
664         isHuman()
665         public
666         payable
667     {
668         bytes32 _name = _nameString.nameFilter();
669         address _addr = msg.sender;
670         uint256 _paid = msg.value;
671         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
672 
673         uint256 _pID = pIDxAddr_[_addr];
674 
675         // 火灾事件
676         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
677     }
678 //==============================================================================
679 //     _  _ _|__|_ _  _ _  .
680 //    (_|(/_ |  | (/_| _\  . (用于UI和查看etherscan上的东西)
681 //=====_|=======================================================================
682     /**
683      * @dev 退货价格买家将支付下一个个人钥匙.
684      * -functionhash- 0x018a25e8
685      * @return 购买下一个钥匙的价格（以wei格式）
686      */
687     function getBuyPrice()
688         public
689         view
690         returns(uint256)
691     {
692         // 设置本地rID
693         uint256 _rID = rID_;
694 
695         // 抓住时间
696         uint256 _now = now;
697 
698         // 我们是一个回合?
699         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
700             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
701         else // rounds over.  need price for new round
702             return ( 75000000000000 ); // init
703     }
704 
705     /**
706      * @dev 返回剩余时间。不要垃圾邮件，你可以从你的节点提供商那里得到你自己
707      * -functionhash- 0xc7e284b8
708      * @return 时间在几秒钟内
709      */
710     function getTimeLeft()
711         public
712         view
713         returns(uint256)
714     {
715         // 设置本地rID
716         uint256 _rID = rID_;
717 
718         // 抓住时间
719         uint256 _now = now;
720 
721         if (_now < round_[_rID].end)
722             if (_now > round_[_rID].strt + rndGap_)
723                 return( (round_[_rID].end).sub(_now) );
724             else
725                 return( (round_[_rID].strt + rndGap_).sub(_now) );
726         else
727             return(0);
728     }
729 
730     /**
731      * @dev 每个金库返回玩家收入
732      * -functionhash- 0x63066434
733      * @return 赢得金库
734      * @return 一般金库
735      * @return 会员保险库
736      */
737     function getPlayerVaults(uint256 _pID)
738         public
739         view
740         returns(uint256 ,uint256, uint256)
741     {
742         // 设置本地rID
743         uint256 _rID = rID_;
744 
745         // 如果圆结束了但圆形结束尚未运行（因此合同没有分配奖金）
746         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
747         {
748             // 如果球员是胜利者
749             if (round_[_rID].plyr == _pID)
750             {
751                 return
752                 (
753                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(25)) / 100 ),
754                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
755                     plyr_[_pID].aff
756                 );
757             // 如果玩家不是赢家
758             } else {
759                 return
760                 (
761                     plyr_[_pID].win,
762                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
763                     plyr_[_pID].aff
764                 );
765             }
766 
767         // 如果圆形仍在继续，或圆形已经结束并且圆形结束已经运行
768         } else {
769             return
770             (
771                 plyr_[_pID].win,
772                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
773                 plyr_[_pID].aff
774             );
775         }
776     }
777 
778     /**
779      * 坚固不喜欢堆栈限制。这让我们避免那种仇恨
780      */
781     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
782         private
783         view
784         returns(uint256)
785     {
786         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
787     }
788 
789     /**
790      * @dev 返回前端所需的所有当前轮次信息
791      * -functionhash- 0x747dff42
792      * @return 在ICO阶段投资的eth
793      * @return 圆的身份
794      * @return 圆的总钥匙
795      * @return 时间到了
796      * @return 时间开始了
797      * @return 目前的锅
798      * @return 领先的当前球队ID和球员ID
799      * @return 领先地址的当前玩家
800      * @return 引导名称中的当前玩家
801      * @return 鲸鱼为了圆形
802      * @return b耳朵为圆形
803      * @return 为了回合而进行的
804      * @return 公牛队参加比赛
805      * @return 空投跟踪器＃＆airdrop pot
806      */
807     function getCurrentRoundInfo()
808         public
809         view
810         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
811     {
812         // 设置本地rID
813         uint256 _rID = rID_;
814 
815         return
816         (
817             round_[_rID].ico,               //0
818             _rID,                           //1
819             round_[_rID].keys,              //2
820             round_[_rID].end,               //3
821             round_[_rID].strt,              //4
822             round_[_rID].pot,               //5
823             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
824             plyr_[round_[_rID].plyr].addr,  //7
825             plyr_[round_[_rID].plyr].name,  //8
826             rndTmEth_[_rID][0],             //9
827             rndTmEth_[_rID][1],             //10
828             rndTmEth_[_rID][2],             //11
829             rndTmEth_[_rID][3],             //12
830             airDropTracker_ + (airDropPot_ * 1000)              //13
831         );
832     }
833 
834     /**
835      * @dev 根据地址返回玩家信息。如果没有给出地址，它会
836      * use msg.sender
837      * -functionhash- 0xee0b5d8b
838      * @param _addr 您要查找的播放器的地址
839      * @return 玩家ID
840      * @return 参赛者姓名
841      * @return 密钥拥有（当前轮次）
842      * @return 赢得金库
843      * @return 一般金库
844      * @return 会员保险库
845      * @return 球员圆的eth
846      */
847     function getPlayerInfoByAddress(address _addr)
848         public
849         view
850         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
851     {
852         // 设置本地rID
853         uint256 _rID = rID_;
854 
855         if (_addr == address(0))
856         {
857             _addr == msg.sender;
858         }
859         uint256 _pID = pIDxAddr_[_addr];
860 
861         return
862         (
863             _pID,                               //0
864             plyr_[_pID].name,                   //1
865             plyrRnds_[_pID][_rID].keys,         //2
866             plyr_[_pID].win,                    //3
867             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
868             plyr_[_pID].aff,                    //5
869             plyrRnds_[_pID][_rID].eth           //6
870         );
871     }
872 
873 //==============================================================================
874 //     _ _  _ _   | _  _ . _  .
875 //    (_(_)| (/_  |(_)(_||(_  . (这+工具+计算+模块=我们的软件引擎)
876 //=====================_|=======================================================
877     /**
878      * @dev 每当执行买单时，逻辑就会运行。决定如何处理
879      * 传入的道德取决于我们是否处于活跃轮次
880      */
881     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
882         private
883     {
884         // 设置本地rID
885         uint256 _rID = rID_;
886 
887         // 抓住时间
888         uint256 _now = now;
889 
890         // 如果圆形是活跃的
891 
892         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
893         {
894             // 致电核心
895             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
896 
897         // 如果圆形不活跃
898         } else {
899             // 检查是否需要运行结束轮次
900             if (_now > round_[_rID].end && round_[_rID].ended == false)
901             {
902                 // 结束回合（分配锅）并开始新一轮
903                 round_[_rID].ended = true;
904                 _eventData_ = endRound(_eventData_);
905 
906                 // 构建事件数据
907                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
908                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
909 
910                 // 火买和分发事件
911                 emit F3Devents.onBuyAndDistribute
912                 (
913                     msg.sender,
914                     plyr_[_pID].name,
915                     msg.value,
916                     _eventData_.compressedData,
917                     _eventData_.compressedIDs,
918                     _eventData_.winnerAddr,
919                     _eventData_.winnerName,
920                     _eventData_.amountWon,
921                     _eventData_.newPot,
922                     _eventData_.P3DAmount,
923                     _eventData_.genAmount
924                 );
925             }
926 
927             // 将eth放入球员保险库中
928             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
929         }
930     }
931 
932     /**
933      * @dev 每当执行重新加载订单时，逻辑就会运行。决定如何处理
934      * 传入的道德取决于我们是否处于活跃轮次
935      */
936     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
937         private
938     {
939         // 设置本地rID
940         uint256 _rID = rID_;
941 
942         // 抓住时间
943         uint256 _now = now;
944 
945         // 如果圆形是活跃的
946         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
947         {
948             // 从所有金库中获取收益并将未使用的金额归还给gen保险库
949             // 因为我们使用自定义safemath库。如果玩家，这将抛出
950             // 他们试图花更多的时间。
951             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
952 
953             // 致电核心
954             core(_rID, _pID, _eth, _affID, _team, _eventData_);
955 
956         // 如果round不活动并且需要运行end round
957         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
958             // end the round (distributes pot) & start new round
959             round_[_rID].ended = true;
960             _eventData_ = endRound(_eventData_);
961 
962             // 构建事件数据
963             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
964             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
965 
966             // 火买和分发事件
967             emit F3Devents.onReLoadAndDistribute
968             (
969                 msg.sender,
970                 plyr_[_pID].name,
971                 _eventData_.compressedData,
972                 _eventData_.compressedIDs,
973                 _eventData_.winnerAddr,
974                 _eventData_.winnerName,
975                 _eventData_.amountWon,
976                 _eventData_.newPot,
977                 _eventData_.P3DAmount,
978                 _eventData_.genAmount
979             );
980         }
981     }
982 
983     /**
984      * @dev 这是在回合生效期间发生的任何购买/重新加载的核心逻辑
985      */
986     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
987         private
988     {
989         // 如果玩家是新手
990         if (plyrRnds_[_pID][_rID].keys == 0)
991             _eventData_ = managePlayer(_pID, _eventData_);
992 
993         // 早期的道路限制器
994         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
995         {
996             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
997             uint256 _refund = _eth.sub(_availableLimit);
998             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
999             _eth = _availableLimit;
1000         }
1001 
1002         // 如果留下的eth大于min eth允许（抱歉没有口袋棉绒）
1003         if (_eth > 1000000000)
1004         {
1005 
1006             // 铸造新钥匙
1007             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
1008 
1009             // 如果他们至少买了一把钥匙
1010             if (_keys >= 1000000000000000000)
1011             {
1012             updateTimer(_keys, _rID);
1013 
1014             // 树立新的领导者
1015             if (round_[_rID].plyr != _pID)
1016                 round_[_rID].plyr = _pID;
1017             if (round_[_rID].team != _team)
1018                 round_[_rID].team = _team;
1019 
1020             // 将新的领导者布尔设为真
1021             _eventData_.compressedData = _eventData_.compressedData + 100;
1022         }
1023 
1024 
1025             // 存储空投跟踪器编号（自上次空投以来的购买次数）
1026             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1027 
1028             // 更新播放器
1029             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1030             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1031 
1032             // 更新回合
1033             round_[_rID].keys = _keys.add(round_[_rID].keys);
1034             round_[_rID].eth = _eth.add(round_[_rID].eth);
1035             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1036 
1037             // 分配道德
1038             _eventData_ = distributeExternal(_rID, _eth, _team, _eventData_);
1039             _eventData_ = distributeInternal(_rID, _pID, _eth, _affID, _team, _keys, _eventData_);
1040 
1041             // 调用end tx函数来触发结束tx事件。
1042             endTx(_pID, _team, _eth, _keys, _eventData_);
1043         }
1044     }
1045 //==============================================================================
1046 //     _ _ | _   | _ _|_ _  _ _  .
1047 //    (_(_||(_|_||(_| | (_)| _\  .
1048 //==============================================================================
1049     /**
1050      * @dev 计算未屏蔽的收入（只计算，不更新掩码）k)
1051      * @return earnings in wei format
1052      */
1053     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1054         private
1055         view
1056         returns(uint256)
1057     {
1058         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
1059     }
1060 
1061     /**
1062      * @dev 返回给出一定数量eth的密钥数量.
1063      * -functionhash- 0xce89c80c
1064      * @param _rID round ID you want price for
1065      * @param _eth amount of eth sent in
1066      * @return keys received
1067      */
1068     function calcKeysReceived(uint256 _rID, uint256 _eth)
1069         public
1070         view
1071         returns(uint256)
1072     {
1073         // 抓住时间
1074         uint256 _now = now;
1075 
1076         // 我们是一个回合?
1077         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1078             return ( (round_[_rID].eth).keysRec(_eth) );
1079         else // 转过来。需要新一轮的钥匙
1080             return ( (_eth).keys() );
1081     }
1082 
1083     /**
1084      * @dev 返回X键的当前eth价格。
1085      * -functionhash- 0xcf808000
1086      * @param _keys 所需的键数（18位十进制格式）
1087      * @return 需要发送的eth数量
1088      */
1089     function iWantXKeys(uint256 _keys)
1090         public
1091         view
1092         returns(uint256)
1093     {
1094         // 设置本地rID
1095         uint256 _rID = rID_;
1096 
1097         // 抓住时间
1098         uint256 _now = now;
1099 
1100         // 我们是一个回合?
1101         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1102             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
1103         else // rounds over.  need price for new round
1104             return ( (_keys).eth() );
1105     }
1106 //==============================================================================
1107 //    _|_ _  _ | _  .
1108 //     | (_)(_)|_\  .
1109 //==============================================================================
1110     /**
1111      * @dev 从姓名合同中接收姓名/球员信息
1112      */
1113     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
1114         external
1115     {
1116         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1117         if (pIDxAddr_[_addr] != _pID)
1118             pIDxAddr_[_addr] = _pID;
1119         if (pIDxName_[_name] != _pID)
1120             pIDxName_[_name] = _pID;
1121         if (plyr_[_pID].addr != _addr)
1122             plyr_[_pID].addr = _addr;
1123         if (plyr_[_pID].name != _name)
1124             plyr_[_pID].name = _name;
1125         if (plyr_[_pID].laff != _laff)
1126             plyr_[_pID].laff = _laff;
1127         if (plyrNames_[_pID][_name] == false)
1128             plyrNames_[_pID][_name] = true;
1129     }
1130 
1131     /**
1132      * @dev 接收整个玩家名单
1133      */
1134     function receivePlayerNameList(uint256 _pID, bytes32 _name)
1135         external
1136     {
1137         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
1138         if(plyrNames_[_pID][_name] == false)
1139             plyrNames_[_pID][_name] = true;
1140     }
1141 
1142     /**
1143      * @dev 获得现有或注册新的pID。当玩家可能是新手时使用此功能
1144      * @return pID
1145      */
1146     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
1147         private
1148         returns (F3Ddatasets.EventReturns)
1149     {
1150         uint256 _pID = pIDxAddr_[msg.sender];
1151         // 如果玩家是这个版本的worldfomo的新手
1152         if (_pID == 0)
1153         {
1154             // 从玩家姓名合同中获取他们的玩家ID，姓名和最后一个身份证
1155             _pID = PlayerBook.getPlayerID(msg.sender);
1156             bytes32 _name = PlayerBook.getPlayerName(_pID);
1157             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
1158 
1159             // 设置玩家帐户
1160             pIDxAddr_[msg.sender] = _pID;
1161             plyr_[_pID].addr = msg.sender;
1162 
1163             if (_name != "")
1164             {
1165                 pIDxName_[_name] = _pID;
1166                 plyr_[_pID].name = _name;
1167                 plyrNames_[_pID][_name] = true;
1168             }
1169 
1170             if (_laff != 0 && _laff != _pID)
1171                 plyr_[_pID].laff = _laff;
1172 
1173             // 将新玩家bool设置为true
1174             _eventData_.compressedData = _eventData_.compressedData + 1;
1175         }
1176         return (_eventData_);
1177     }
1178 
1179     /**
1180      * @dev 检查以确保用户选择了一个有效的团队。如果没有设置团队
1181      * 默认（中国）
1182      */
1183     function verifyTeam(uint256 _team)
1184         private
1185         pure
1186         returns (uint256)
1187     {
1188         if (_team < 0 || _team > 3)
1189             return(2);
1190         else
1191             return(_team);
1192     }
1193 
1194     /**
1195      * @dev 决定是否需要运行圆形结束并开始新一轮。而如果
1196      * 需要移动之前玩过的球员未经掩盖的收入
1197      */
1198     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
1199         private
1200         returns (F3Ddatasets.EventReturns)
1201     {
1202         // 如果玩家已经玩过上一轮，则移动他们未经掩盖的收益
1203         // 从那一轮到生成金库。
1204         if (plyr_[_pID].lrnd != 0)
1205             updateGenVault(_pID, plyr_[_pID].lrnd);
1206 
1207         // 更新玩家的最后一轮比赛
1208         plyr_[_pID].lrnd = rID_;
1209 
1210         // 将连接的圆形bool设置为true
1211         _eventData_.compressedData = _eventData_.compressedData + 10;
1212 
1213         return(_eventData_);
1214     }
1215 
1216     /**
1217      * @dev 结束这一轮。管理支付赢家/拆分锅
1218      */
1219     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1220         private
1221         returns (F3Ddatasets.EventReturns)
1222     {
1223         // 设置本地rID
1224         uint256 _rID = rID_;
1225 
1226         // 抓住我们的获胜球员和球队ID
1227         uint256 _winPID = round_[_rID].plyr;
1228         uint256 _winTID = round_[_rID].team;
1229 
1230         // 抓住我们的锅量
1231         uint256 _pot = round_[_rID].pot;
1232 
1233         // 计算我们的赢家份额，社区奖励，发行份额，
1234         // 份额，以及为下一个底池保留的金额
1235         uint256 _win = (_pot.mul(25)) / 100;
1236         uint256 _com = (_pot.mul(3)) / 100;
1237         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1238         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1239         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1240 
1241         // k计算圆形面罩的ppt
1242         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1243         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1244         if (_dust > 0)
1245         {
1246             _gen = _gen.sub(_dust);
1247             _res = _res.add(_dust);
1248         }
1249 
1250         // 支付我们的赢家
1251         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1252 
1253         // 社区奖励
1254 
1255         admin.transfer(_com);
1256 
1257         // 将gen部分分配给密钥持有者
1258         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1259 
1260         // 准备事件数据
1261         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1262         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1263         _eventData_.winnerAddr = plyr_[_winPID].addr;
1264         _eventData_.winnerName = plyr_[_winPID].name;
1265         _eventData_.amountWon = _win;
1266         _eventData_.genAmount = _gen;
1267         _eventData_.P3DAmount = _p3d;
1268         _eventData_.newPot = _res;
1269 
1270         // 下一轮开始
1271         rID_++;
1272         _rID++;
1273         round_[_rID].strt = now;
1274         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1275         round_[_rID].pot = _res;
1276 
1277         return(_eventData_);
1278     }
1279 
1280     /**
1281      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
1282      */
1283     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1284         private
1285     {
1286         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1287         if (_earnings > 0)
1288         {
1289             // 放入gen库
1290             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1291             // 通过更新面具将收入归零
1292             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1293         }
1294     }
1295 
1296     /**
1297      * @dev 根据购买的全部密钥数量更新圆形计时器。
1298      */
1299     function updateTimer(uint256 _keys, uint256 _rID)
1300         private
1301     {
1302         // 抓住时间
1303         uint256 _now = now;
1304 
1305         // 根据购买的钥匙数计算时间
1306         uint256 _newTime;
1307         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1308             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1309         else
1310             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1311 
1312         // 比较max并设置新的结束时间
1313         if (_newTime < (rndMax_).add(_now))
1314             round_[_rID].end = _newTime;
1315         else
1316             round_[_rID].end = rndMax_.add(_now);
1317     }
1318 
1319     /**
1320      * @dev 生成0-99之间的随机数并检查是否存在
1321      * 导致空投获胜
1322      * @return 我们有赢家吗？我们有赢家吗？
1323      */
1324     function airdrop()
1325         private
1326         view
1327         returns(bool)
1328     {
1329         uint256 seed = uint256(keccak256(abi.encodePacked(
1330 
1331             (block.timestamp).add
1332             (block.difficulty).add
1333             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1334             (block.gaslimit).add
1335             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1336             (block.number)
1337 
1338         )));
1339         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1340             return(true);
1341         else
1342             return(false);
1343     }
1344 
1345     /**
1346      * @dev 根据对com，aff和p3d的费用分配eth
1347      */
1348     function distributeExternal(uint256 _rID, uint256 _eth, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1349         private
1350         returns(F3Ddatasets.EventReturns)
1351     {
1352         // 支付3％的社区奖励
1353         uint256 _com = (_eth.mul(3)) / 100;
1354         uint256 _p3d;
1355         if (!address(admin).call.value(_com)())
1356         {
1357             _p3d = _com;
1358             _com = 0;
1359         }
1360 
1361 
1362         // 支付p3d
1363         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1364         if (_p3d > 0)
1365         {
1366             round_[_rID].pot = round_[_rID].pot.add(_p3d);
1367 
1368             // 设置事件数据
1369             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1370         }
1371 
1372         return(_eventData_);
1373     }
1374 
1375     function potSwap()
1376         external
1377         payable
1378     {
1379         // 设置本地rID
1380         uint256 _rID = rID_ + 1;
1381 
1382         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1383         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
1384     }
1385 
1386     /**
1387      * @dev 根据对gen和pot的费用分配eth
1388      */
1389     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1390         private
1391         returns(F3Ddatasets.EventReturns)
1392     {
1393         // 计算gen份额
1394         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1395 
1396         // distribute share to affiliate 15%
1397         uint256 _aff = (_eth.mul(15)) / 100;
1398 
1399         // 更新道德平衡 (eth = eth - (com share + pot swap share + aff share))
1400         _eth = _eth.sub(((_eth.mul(18)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1401 
1402         // 计算锅
1403         uint256 _pot = _eth.sub(_gen);
1404 
1405         // decide what to do with affiliate share of fees
1406         // affiliate must not be self, and must have a name registered
1407         if (_affID != _pID && plyr_[_affID].name != '') {
1408             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1409             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1410         } else {
1411             _gen = _gen.add(_aff);
1412         }
1413 
1414         // 分配gen份额（这就是updateMasks（）所做的）并进行调整
1415         // 灰尘平衡。
1416         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1417         if (_dust > 0)
1418             _gen = _gen.sub(_dust);
1419 
1420         // 添加eth到pot
1421         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1422 
1423         // 设置事件数据
1424         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1425         _eventData_.potAmount = _pot;
1426 
1427         return(_eventData_);
1428     }
1429 
1430     /**
1431      * @dev 购买钥匙时更新圆形和玩家的面具
1432      * @return 灰尘遗留下来
1433      */
1434     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1435         private
1436         returns(uint256)
1437     {
1438         /* 掩盖笔记
1439             收入面具对人们来说是一个棘手的事情。
1440             这里要理解的基本内容。将有一个全球性的
1441             跟踪器基于每轮的每股利润，增加
1442             相关比例增加份额。
1443 
1444             玩家将有一个额外的面具基本上说“基于
1445             在回合面具，我的股票，以及我已经撤回了多少，
1446             还欠我多少钱呢？“
1447         */
1448 
1449         // 基于此购买的每个键和圆形面具的钙利润:(灰尘进入锅）
1450         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1451         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1452 
1453         // 计算玩家从他们自己购买的收入（仅基于钥匙
1454         // 他们刚刚买了）。并更新玩家收入掩
1455         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1456         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1457 
1458         // 计算并返回灰尘
1459         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1460     }
1461 
1462     /**
1463      * @dev 加上未公开的收入和保险金收入，将它们全部设为0
1464      * @return wei格式的收益
1465      */
1466     function withdrawEarnings(uint256 _pID)
1467         private
1468         returns(uint256)
1469     {
1470         // 更新gen保险库
1471         updateGenVault(_pID, plyr_[_pID].lrnd);
1472 
1473         // 来自金库
1474         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1475         if (_earnings > 0)
1476         {
1477             plyr_[_pID].win = 0;
1478             plyr_[_pID].gen = 0;
1479             plyr_[_pID].aff = 0;
1480         }
1481 
1482         return(_earnings);
1483     }
1484 
1485     /**
1486      * @dev 准备压缩数据并触发事件以进行购买或重新加载tx
1487      */
1488     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1489         private
1490     {
1491         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1492         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1493 
1494         emit F3Devents.onEndTx
1495         (
1496             _eventData_.compressedData,
1497             _eventData_.compressedIDs,
1498             plyr_[_pID].name,
1499             msg.sender,
1500             _eth,
1501             _keys,
1502             _eventData_.winnerAddr,
1503             _eventData_.winnerName,
1504             _eventData_.amountWon,
1505             _eventData_.newPot,
1506             _eventData_.P3DAmount,
1507             _eventData_.genAmount,
1508             _eventData_.potAmount,
1509             airDropPot_
1510         );
1511     }
1512 //==============================================================================
1513 //    (~ _  _    _._|_    .
1514 //    _)(/_(_|_|| | | \/  .
1515 //====================/=========================================================
1516     /** 合同部署后，它将被停用。这是一次
1517      * 使用将激活合同的功能。我们这样做是开发者
1518      * 有时间在网络端设置                           **/
1519     bool public activated_ = false;
1520     function activate()
1521         public
1522     {
1523         // 只有团队才能激活
1524         require(msg.sender == admin, "only admin can activate");
1525 
1526 
1527         // 只能跑一次
1528         require(activated_ == false, "FOMO Free already activated");
1529 
1530         // 激活合同
1531         activated_ = true;
1532 
1533         // 让我们开始第一轮
1534         rID_ = 1;
1535             round_[1].strt = now + rndExtra_ - rndGap_;
1536             round_[1].end = now + rndInit_ + rndExtra_;
1537     }
1538 }
1539 
1540 //==============================================================================
1541 //   __|_ _    __|_ _  .
1542 //  _\ | | |_|(_ | _\  .
1543 //==============================================================================
1544 library F3Ddatasets {
1545     //压缩数据密钥
1546     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
1547         // 0 - new player (bool)
1548         // 1 - joined round (bool)
1549         // 2 - new  leader (bool)
1550         // 3-5 - air drop tracker (uint 0-999)
1551         // 6-16 - round end time
1552         // 17 - winnerTeam
1553         // 18 - 28 timestamp
1554         // 29 - team
1555         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
1556         // 31 - airdrop happened bool
1557         // 32 - airdrop tier
1558         // 33 - airdrop amount won
1559     //压缩的ID密钥
1560     // [77-52][51-26][25-0]
1561         // 0-25 - pID
1562         // 26-51 - winPID
1563         // 52-77 - rID
1564     struct EventReturns {
1565         uint256 compressedData;
1566         uint256 compressedIDs;
1567         address winnerAddr;         // 获胜者地址
1568         bytes32 winnerName;         // 获胜者地址
1569         uint256 amountWon;          // 金额赢了
1570         uint256 newPot;             // 在新锅中的数量
1571         uint256 P3DAmount;          // 金额分配给p3d
1572         uint256 genAmount;          // 金额分配给gen
1573         uint256 potAmount;          // 加入锅中的量
1574     }
1575     struct Player {
1576         address addr;   // 球员地址
1577         bytes32 name;   // 参赛者姓名
1578         uint256 win;    // 赢得金库
1579         uint256 gen;    // 一般金库
1580         uint256 aff;    // 会员保险库
1581         uint256 lrnd;   // 上一轮比赛
1582         uint256 laff;   // 使用的最后一个会员ID
1583     }
1584     struct PlayerRounds {
1585         uint256 eth;    // 玩家加入回合（用于eth限制器）
1586         uint256 keys;   // 按键
1587         uint256 mask;   // 运动员面具
1588         uint256 ico;    // ICO阶段投资
1589     }
1590     struct Round {
1591         uint256 plyr;   // 领先的玩家的pID
1592         uint256 team;   // 领导团队的tID
1593         uint256 end;    // 时间结束/结束
1594         bool ended;     // 已经运行了圆端函数
1595         uint256 strt;   // 时间开始了
1596         uint256 keys;   // 按键
1597         uint256 eth;    // 总人口
1598         uint256 pot;    // 罐装（在回合期间）/最终金额支付给获胜者（在回合结束后）
1599         uint256 mask;   // 全球面具
1600         uint256 ico;    // 在ICO阶段发送的总eth
1601         uint256 icoGen; // ICO阶段的gen eth总量
1602         uint256 icoAvg; // ICO阶段的平均关键价格
1603     }
1604     struct TeamFee {
1605         uint256 gen;    // 支付给本轮关键持有人的购买百分比
1606         uint256 p3d;    // 支付给p3d持有人的购买百分比
1607     }
1608     struct PotSplit {
1609         uint256 gen;    // 支付给本轮关键持有人的底池百分比
1610         uint256 p3d;    // 付给p3d持有者的锅的百分比
1611     }
1612 }
1613 
1614 //==============================================================================
1615 //  |  _      _ _ | _  .
1616 //  |<(/_\/  (_(_||(_  .
1617 //=======/======================================================================
1618 library F3DKeysCalcShort {
1619     using SafeMath for *;
1620     /**
1621      * @dev 计算给定X eth时收到的密钥数
1622      * @param _curEth 合同中的当前eth数量
1623      * @param _newEth eth被用掉了
1624      * @return 购买的机票数量
1625      */
1626     function keysRec(uint256 _curEth, uint256 _newEth)
1627         internal
1628         pure
1629         returns (uint256)
1630     {
1631         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1632     }
1633 
1634     /**
1635      * @dev 计算出售X键时收到的eth数量
1636      * @param _curKeys 当前存在的密钥数量
1637      * @param _sellKeys 您希望出售的钥匙数量
1638      * @return 收到的eth数量
1639      */
1640     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1641         internal
1642         pure
1643         returns (uint256)
1644     {
1645         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1646     }
1647 
1648     /**
1649      * @dev 计算给定一定数量的eth会存在多少个密钥
1650      * @param _eth 合同中的道德
1651      * @return 将存在的密钥数
1652      */
1653     function keys(uint256 _eth)
1654         internal
1655         pure
1656         returns(uint256)
1657     {
1658         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1659     }
1660 
1661     /**
1662      * @dev 在给定一些密钥的情况下计算合同中的eth数量
1663      * @param _keys “契约”中的键数
1664      * @return 存在的道德
1665      */
1666     function eth(uint256 _keys)
1667         internal
1668         pure
1669         returns(uint256)
1670     {
1671         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1672     }
1673 }
1674 
1675 //==============================================================================
1676 //  . _ _|_ _  _ |` _  _ _  _  .
1677 //  || | | (/_| ~|~(_|(_(/__\  .
1678 //==============================================================================
1679 
1680 interface PlayerBookInterface {
1681     function getPlayerID(address _addr) external returns (uint256);
1682     function getPlayerName(uint256 _pID) external view returns (bytes32);
1683     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1684     function getPlayerAddr(uint256 _pID) external view returns (address);
1685     function getNameFee() external view returns (uint256);
1686     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1687     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1688     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1689 }
1690 
1691 
1692 library NameFilter {
1693     /**
1694      * @dev 过滤名称字符串
1695      * -将大写转换为小写.
1696      * -确保它不以空格开始/结束
1697      * -确保它不包含连续的多个空格
1698      * -不能只是数字
1699      * -不能以0x开头
1700      * -将字符限制为A-Z，a-z，0-9和空格。
1701      * @return 以字节32格式重新处理的字符串
1702      */
1703     function nameFilter(string _input)
1704         internal
1705         pure
1706         returns(bytes32)
1707     {
1708         bytes memory _temp = bytes(_input);
1709         uint256 _length = _temp.length;
1710 
1711         //对不起限于32个字符
1712         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
1713         // 确保它不以空格开头或以空格结尾
1714         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
1715         // 确保前两个字符不是0x
1716         if (_temp[0] == 0x30)
1717         {
1718             require(_temp[1] != 0x78, "string cannot start with 0x");
1719             require(_temp[1] != 0x58, "string cannot start with 0X");
1720         }
1721 
1722         // 创建一个bool来跟踪我们是否有非数字字符
1723         bool _hasNonNumber;
1724 
1725         // 转换和检查
1726         for (uint256 i = 0; i < _length; i++)
1727         {
1728             // 如果它的大写A-Z
1729             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1730             {
1731                 // 转换为小写a-z
1732                 _temp[i] = byte(uint(_temp[i]) + 32);
1733 
1734                 // 我们有一个非数字
1735                 if (_hasNonNumber == false)
1736                     _hasNonNumber = true;
1737             } else {
1738                 require
1739                 (
1740                     // 要求角色是一个空间
1741                     _temp[i] == 0x20 ||
1742                     // 或小写a-z
1743                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1744                     // 或0-9
1745                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1746                     "string contains invalid characters"
1747                 );
1748                 // 确保连续两行不是空格
1749                 if (_temp[i] == 0x20)
1750                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
1751 
1752                 // 看看我们是否有一个数字以外的字符
1753                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1754                     _hasNonNumber = true;
1755             }
1756         }
1757 
1758         require(_hasNonNumber == true, "string cannot be only numbers");
1759 
1760         bytes32 _ret;
1761         assembly {
1762             _ret := mload(add(_temp, 32))
1763         }
1764         return (_ret);
1765     }
1766 }
1767 
1768 /**
1769  * @title SafeMath v0.1.9
1770  * @dev 带有安全检查的数学运算会引发错误
1771  * - 添加 sqrt
1772  * - 添加 sq
1773  * - 添加 pwr
1774  * - 将断言更改为需要带有错误日志输出
1775  * - 删除div，它没用
1776  */
1777 library SafeMath {
1778 
1779     /**
1780     * @dev 将两个数字相乘，抛出溢出。
1781     */
1782     function mul(uint256 a, uint256 b)
1783         internal
1784         pure
1785         returns (uint256 c)
1786     {
1787         if (a == 0) {
1788             return 0;
1789         }
1790         c = a * b;
1791         require(c / a == b, "SafeMath mul failed");
1792         return c;
1793     }
1794 
1795     /**
1796     * @dev 减去两个数字，在溢出时抛出（即，如果减数大于减数）。
1797     */
1798     function sub(uint256 a, uint256 b)
1799         internal
1800         pure
1801         returns (uint256)
1802     {
1803         require(b <= a, "SafeMath sub failed");
1804         return a - b;
1805     }
1806 
1807     /**
1808     * @dev 添加两个数字，溢出时抛出。
1809     */
1810     function add(uint256 a, uint256 b)
1811         internal
1812         pure
1813         returns (uint256 c)
1814     {
1815         c = a + b;
1816         require(c >= a, "SafeMath add failed");
1817         return c;
1818     }
1819 
1820     /**
1821      * @dev 给出给定x的平方根.
1822      */
1823     function sqrt(uint256 x)
1824         internal
1825         pure
1826         returns (uint256 y)
1827     {
1828         uint256 z = ((add(x,1)) / 2);
1829         y = x;
1830         while (z < y)
1831         {
1832             y = z;
1833             z = ((add((x / z),z)) / 2);
1834         }
1835     }
1836 
1837     /**
1838      * @dev 给广场。将x乘以x
1839      */
1840     function sq(uint256 x)
1841         internal
1842         pure
1843         returns (uint256)
1844     {
1845         return (mul(x,x));
1846     }
1847 
1848     /**
1849      * @dev x到y的力量
1850      */
1851     function pwr(uint256 x, uint256 y)
1852         internal
1853         pure
1854         returns (uint256)
1855     {
1856         if (x==0)
1857             return (0);
1858         else if (y==0)
1859             return (1);
1860         else
1861         {
1862             uint256 z = x;
1863             for (uint256 i=1; i < y; i++)
1864                 z = mul(z,x);
1865             return (z);
1866         }
1867     }
1868 }