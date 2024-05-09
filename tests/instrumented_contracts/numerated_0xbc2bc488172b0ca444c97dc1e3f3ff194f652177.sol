1 pragma solidity ^0.4.24;
2 
3 
4 // 名称检验
5 library NameFilter {
6 
7 function nameFilter(string _input)
8     internal
9     pure
10     returns(bytes32)
11     {
12         bytes memory _temp = bytes(_input);
13         uint256 _length = _temp.length;
14 
15         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
16         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
17         if (_temp[0] == 0x30)
18         {
19             require(_temp[1] != 0x78, "string cannot start with 0x");
20             require(_temp[1] != 0x58, "string cannot start with 0X");
21         }
22 
23         bool _hasNonNumber;
24         for (uint256 i = 0; i < _length; i++)
25         {
26             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
27             {
28                 _temp[i] = byte(uint(_temp[i]) + 32);
29 
30                 if (_hasNonNumber == false)
31                     _hasNonNumber = true;
32             } else {
33                 require
34                 (
35                     _temp[i] == 0x20 ||
36                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
37                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
38                     "string contains invalid characters"
39                 );
40                 if (_temp[i] == 0x20)
41                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
42 
43                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
44                     _hasNonNumber = true;
45             }
46         }
47 
48         require(_hasNonNumber == true, "string cannot be only numbers");
49 
50         bytes32 _ret;
51         assembly {
52             _ret := mload(add(_temp, 32))
53         }
54         return (_ret);
55     }
56 }
57 
58 // 队伍数据库
59 library F3Ddatasets {
60     struct EventReturns {
61         uint256 compressedData;
62         uint256 compressedIDs;
63         address winnerAddr;         // 胜利者地址
64         bytes32 winnerName;         // 赢家姓名
65         uint256 amountWon;          // 金额赢了
66         uint256 newPot;             // 数量在新池里
67         uint256 P3DAmount;          // 数量分配给p3d
68         uint256 genAmount;          // 数量分配给gen
69         uint256 potAmount;          // 添加到池中的数量
70     }
71     struct Player {
72         address addr;               // 玩家地址
73         bytes32 name;               // 名称
74         uint256 names;              // 名称列表
75         uint256 win;                // 赢得金库
76         uint256 gen;                // 分红保险库
77         uint256 aff;                // 推广保险库
78         uint256 lrnd;               // 上一轮比赛
79         uint256 laff;               // 使用的最后一个会员ID
80     }
81     struct PlayerRounds {
82         uint256 eth;                // 玩家本回合增加的eth
83         uint256 keys;               // 钥匙数
84         uint256 mask;               // 玩家钱包
85         uint256 ico;                // ICO阶段投资
86     }
87     struct Round {
88         uint256 plyr;               // 领导者的pID
89         uint256 team;               // 团队领导的tID
90         uint256 end;                // 时间结束/结束
91         bool ended;                 // 已经运行了回合函数
92         uint256 strt;               // 时间开始了
93         uint256 keys;               // 钥匙数量
94         uint256 eth;                // 总的eth in
95         uint256 pot;                // 奖池（在回合期间）/最终金额支付给获胜者（在回合结束后）
96         uint256 mask;               // 全局钱包
97         uint256 ico;                // 在ICO阶段发送的总eth
98         uint256 icoGen;             // ICO期间gen的总eth
99         uint256 icoAvg;             // ICO阶段的平均关键价格
100     }
101     struct TeamFee {
102         uint256 gen;                // 支付给本轮钥匙持有者的分红百分比
103         uint256 p3d;                // 支付给p3d持有者的分红百分比
104     }
105     struct PotSplit {
106         uint256 gen;                // 支付给本轮钥匙持有者的底池百分比
107         uint256 p3d;                // 支付给p3d持有者的底池百分比
108     }
109 }
110 
111 // 安全数学库
112 library SafeMath {
113 
114     function mul(uint256 a, uint256 b)
115     internal
116     pure
117     returns (uint256 c)
118     {
119         if (a == 0) {
120             return 0;
121         }
122         c = a * b;
123         require(c / a == b, "SafeMath mul failed");
124         return c;
125     }
126 
127     function div(uint256 a, uint256 b)
128     internal
129     pure
130     returns (uint256) {
131         // assert(b > 0); // Solidity automatically throws when dividing by 0
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134         return c;
135     }
136 
137     function sub(uint256 a, uint256 b)
138     internal
139     pure
140     returns (uint256)
141     {
142         require(b <= a, "SafeMath sub failed");
143         return a - b;
144     }
145 
146     function add(uint256 a, uint256 b)
147     internal
148     pure
149     returns (uint256 c)
150     {
151         c = a + b;
152         require(c >= a, "SafeMath add failed");
153         return c;
154     }
155 
156     function sqrt(uint256 x)
157     internal
158     pure
159     returns (uint256 y)
160     {
161         uint256 z = ((add(x,1)) / 2);
162         y = x;
163         while (z < y)
164         {
165             y = z;
166             z = ((add((x / z),z)) / 2);
167         }
168     }
169 
170     function sq(uint256 x)
171     internal
172     pure
173     returns (uint256)
174     {
175         return (mul(x,x));
176     }
177 
178     function pwr(uint256 x, uint256 y)
179     internal
180     pure
181     returns (uint256)
182     {
183         if (x==0)
184             return (0);
185         else if (y==0)
186             return (1);
187         else
188         {
189             uint256 z = x;
190             for (uint256 i=1; i < y; i++)
191                 z = mul(z,x);
192             return (z);
193         }
194     }
195 }
196 
197 
198 // TinyF3D游戏
199 contract TinyF3D {
200 
201     using SafeMath for *;
202     using NameFilter for string;
203 
204     string constant public name = "Fomo3D CHINA";           // 游戏名称
205     string constant public symbol = "GBL";                      // 游戏符号
206 
207     // 游戏数据
208     address public owner;                                       // 合约管理者
209     address public devs;                                        // 开发团队
210     address public otherF3D_;                                   // 副奖池
211     address  public Divies;                                     // 股东
212     address public Jekyll_Island_Inc;                           // 公司账户
213 
214     bool public activated_ = false;                             // 合同部署标志
215 
216     uint256 private rndExtra_ = 0;                              // 第一个ICO的时间
217     uint256 private rndGap_ = 0;                                // ICO阶段的时间,现为马上结束
218     uint256 constant private rndInit_ = 1 hours;                // 回合倒计时开始
219     uint256 constant private rndInc_ = 30 seconds;              // 每一把钥匙增加时间
220     uint256 constant private rndMax_ = 12 hours;                // 最大倒计时时间
221 
222     uint256 public airDropPot_;                                 // 空头罐
223     uint256 public airDropTracker_ = 0;                         // 空投计数
224     uint256 public rID_;                                        // 回合轮数
225 
226     uint256 public registrationFee_ = 10 finney;                // 注册价格
227 
228     // 玩家数据
229     uint256 public pID_;                                        // 玩家总数
230     mapping(address => uint256) public pIDxAddr_;               //（addr => pID）按地址返回玩家ID
231     mapping(bytes32 => uint256) public pIDxName_;               //（name => pID）按名称返回玩家ID
232     mapping(uint256 => F3Ddatasets.Player) public plyr_;        //（pID => data）玩家数据
233     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    //（pID => rID => data）玩家ID和轮次ID的玩家轮数据
234     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_;       //（pID => name => bool）玩家拥有的名字列表。
235                                                                           //（用于这样您可以在您拥有的任何名称中更改您的显示名称）
236     mapping(uint256 => mapping(uint256 => bytes32)) public plyrNameList_; //（pID => nameNum => name）玩家拥有的名称列表
237 
238     // 回合数据
239     mapping(uint256 => F3Ddatasets.Round) public round_;        //（rID => data）回合数据
240     mapping(uint256 => mapping(uint256 => uint256)) public rndTmEth_;    //（rID => tID => data）每个团队中的eth，按轮次ID和团队ID
241 
242     // 团队数据
243     mapping(uint256 => F3Ddatasets.TeamFee) public fees_;       //（团队=>费用）按团队分配费用
244     mapping(uint256 => F3Ddatasets.PotSplit) public potSplit_;  //（团队=>费用）按团队分配分配
245 
246     // 每当玩家注册一个名字时就会被触发
247     event onNewName
248     (
249         uint256 indexed playerID,
250         address indexed playerAddress,
251         bytes32 indexed playerName,
252         bool isNewPlayer,
253         uint256 affiliateID,
254         address affiliateAddress,
255         bytes32 affiliateName,
256         uint256 amountPaid,
257         uint256 timeStamp
258     );
259 
260     // 购买并分红
261     event onBuyAndDistribute
262     (
263         address playerAddress,
264         bytes32 playerName,
265         uint256 ethIn,
266         uint256 compressedData,
267         uint256 compressedIDs,
268         address winnerAddr,
269         bytes32 winnerName,
270         uint256 amountWon,
271         uint256 newPot,
272         uint256 P3DAmount,
273         uint256 genAmount
274     );
275 
276     // 收到副奖池存款
277     event onPotSwapDeposit
278     (
279         uint256 roundID,
280         uint256 amountAddedToPot
281     );
282 
283     // 购买结束事件
284     event onEndTx
285     (
286         uint256 compressedData,
287         uint256 compressedIDs,
288         bytes32 playerName,
289         address playerAddress,
290         uint256 ethIn,
291         uint256 keysBought,
292         address winnerAddr,
293         bytes32 winnerName,
294         uint256 amountWon,
295         uint256 newPot,
296         uint256 P3DAmount,
297         uint256 genAmount,
298         uint256 potAmount,
299         uint256 airDropPot
300     );
301 
302     //每当联盟会员付款时都会被解雇
303     event onAffiliatePayout
304     (
305         uint256 indexed affiliateID,
306         address affiliateAddress,
307         bytes32 affiliateName,
308         uint256 indexed roundID,
309         uint256 indexed buyerID,
310         uint256 amount,
311         uint256 timeStamp
312     );
313 
314     // 撤回收入事件
315     event onWithdraw
316     (
317         uint256 indexed playerID,
318         address playerAddress,
319         bytes32 playerName,
320         uint256 ethOut,
321         uint256 timeStamp
322     );
323 
324     // 撤回收入分发事件
325     event onWithdrawAndDistribute
326     (
327         address playerAddress,
328         bytes32 playerName,
329         uint256 ethOut,
330         uint256 compressedData,
331         uint256 compressedIDs,
332         address winnerAddr,
333         bytes32 winnerName,
334         uint256 amountWon,
335         uint256 newPot,
336         uint256 P3DAmount,
337         uint256 genAmount
338     );
339 
340     // 只有当玩家在回合结束后尝试重新加载时才会触发
341     event onReLoadAndDistribute
342     (
343         address playerAddress,
344         bytes32 playerName,
345         uint256 compressedData,
346         uint256 compressedIDs,
347         address winnerAddr,
348         bytes32 winnerName,
349         uint256 amountWon,
350         uint256 newPot,
351         uint256 P3DAmount,
352         uint256 genAmount
353     );
354 
355     // 确保在合约激活前不能使用
356     modifier isActivated() {
357         require(activated_ == true, "its not ready yet.  check ?eta in discord");
358         _;
359     }
360 
361     // 禁止其他合约调用
362     modifier isHuman() {
363         address _addr = msg.sender;
364         uint256 _codeLength;
365 
366         assembly {_codeLength := extcodesize(_addr)}
367         require(_codeLength == 0, "sorry humans only");
368         _;
369     }
370 
371     // 保证调用者是开发者
372     modifier onlyDevs()
373     {
374         require(msg.sender == devs, "msg sender is not a dev");
375         _;
376     }
377 
378     // dev设置传入交易金额的边界
379     modifier isWithinLimits(uint256 _eth) {
380         require(_eth >= 1000000000, "pocket lint: not a valid currency");
381         require(_eth <= 100000000000000000000000, "no vitalik, no");
382         _;
383     }
384 
385     // 合同部署后激活一次
386     function activate()
387     public
388     onlyDevs
389     {
390         //只能运行一次
391         require(activated_ == false, "TinyF3d already activated");
392 
393         //激活合同
394         activated_ = true;
395 
396         //让我们开始第一轮
397         rID_ = 1;
398         round_[1].strt = now + rndExtra_ - rndGap_;
399         round_[1].end = now + rndInit_ + rndExtra_;
400     }
401 
402     // 合约部署初始数据设置
403     constructor()
404     public
405     {
406         owner = msg.sender;
407         devs = msg.sender;
408         otherF3D_ = msg.sender;
409         Divies = msg.sender;
410         Jekyll_Island_Inc = msg.sender;
411 
412         // 团队分配结构
413         // 0 =鲸鱼
414         // 1 =熊
415         // 2 = 蛇
416         // 3 =公牛
417 
418         // 团队分红
419         //（F3D，P3D）+（奖池，推荐，社区）
420         fees_[0] = F3Ddatasets.TeamFee(30, 6);          // 50％为奖池，10％推广，2％为公司，1％为副奖池，1％为空投罐
421         fees_[1] = F3Ddatasets.TeamFee(43, 0);          // 43％为奖池，10％推广，2％为公司，1％为副奖池，1％为空投罐
422         fees_[2] = F3Ddatasets.TeamFee(56, 10);         // 20％为奖池，10％推广，2％为公司，1％为副奖池，1％为空投罐
423         fees_[3] = F3Ddatasets.TeamFee(43, 8);          // 35％为奖池，10％推广，2％为公司，1％为副奖池，1％为空投罐
424 
425         // 结束奖池分配
426         //（F3D, P3D）+（获胜者，下一轮，公司）
427         potSplit_[0] = F3Ddatasets.PotSplit(15, 10);    // 获胜者48％，下一轮25％，com 2％
428         potSplit_[1] = F3Ddatasets.PotSplit(25, 0);     // 获胜者48％，下一轮25％，com 2％
429         potSplit_[2] = F3Ddatasets.PotSplit(20, 20);    // 获胜者48％，下一轮10％，com 2％
430         potSplit_[3] = F3Ddatasets.PotSplit(30, 10);    // 获胜者48％，下一轮10％，com 2％
431     }
432 
433     // 匿名函数,用来紧急购买
434     function()
435     isActivated()
436     isHuman()
437     isWithinLimits(msg.value)
438     public
439     payable
440     {
441         // 设置交易事件数据并确定玩家是否是新玩家
442         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
443 
444         // 获取玩家ID
445         uint256 _pID = pIDxAddr_[msg.sender];
446 
447         // 买核心
448         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
449     }
450 
451     // 存在或注册新的pID。当玩家可能是新手时使用此功能
452     function determinePlayer(F3Ddatasets.EventReturns memory _eventData_)
453     private
454     returns (F3Ddatasets.EventReturns)
455     {
456         uint256 _pID = pIDxAddr_[msg.sender];
457 
458         // 如果玩家是新手
459         if (_pID == 0)
460         {
461             // 从玩家姓名合同中获取他们的玩家ID，姓名和最后一个身份证
462             determinePID(msg.sender);
463             _pID = pIDxAddr_[msg.sender];
464             bytes32 _name = plyr_[_pID].name;
465             uint256 _laff = plyr_[_pID].laff;
466 
467             // 设置玩家账号
468             pIDxAddr_[msg.sender] = _pID;
469             plyr_[_pID].addr = msg.sender;
470 
471             if (_name != "")
472             {
473                 pIDxName_[_name] = _pID;
474                 plyr_[_pID].name = _name;
475                 plyrNames_[_pID][_name] = true;
476             }
477 
478             if (_laff != 0 && _laff != _pID)
479                 plyr_[_pID].laff = _laff;
480 
481             // 将新玩家设置为true
482             _eventData_.compressedData = _eventData_.compressedData + 1;
483         }
484         return (_eventData_);
485     }
486 
487     // 确定玩家ID
488     function determinePID(address _addr)
489     private
490     returns (bool)
491     {
492         if (pIDxAddr_[_addr] == 0)
493         {
494             pID_++;
495             pIDxAddr_[_addr] = pID_;
496             plyr_[pID_].addr = _addr;
497 
498             // 将新玩家bool设置为true
499             return (true);
500         } else {
501             return (false);
502         }
503     }
504 
505     // 注册名称
506     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
507     isHuman()
508     public
509     payable
510     {
511         // 确保支付名称费用
512         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
513 
514         // 过滤名称
515         bytes32 _name = NameFilter.nameFilter(_nameString);
516 
517         // 获取地址
518         address _addr = msg.sender;
519 
520         // 是否是新玩家
521         bool _isNewPlayer = determinePID(_addr);
522 
523         // 获取玩家ID
524         uint256 _pID = pIDxAddr_[_addr];
525 
526         // 如果没有推广人ID或者推广人是自己
527         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
528         {
529             // 更新推广人
530             plyr_[_pID].laff = _affCode;
531         } else if (_affCode == _pID) {
532             _affCode = 0;
533         }
534 
535         // 注册名称
536         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
537     }
538 
539     // 通过地址注册名称
540     function registerNameXaddr(address _addr, string _nameString, address _affCode, bool _all)
541     external
542     payable
543     {
544         // 确保支付名称费用
545         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
546 
547         // 过滤名称
548         bytes32 _name = NameFilter.nameFilter(_nameString);
549 
550         // 是否是新玩家
551         bool _isNewPlayer = determinePID(_addr);
552 
553         // 获取玩家ID
554         uint256 _pID = pIDxAddr_[_addr];
555 
556         // 如果没有推广人ID或者推广人是自己
557         uint256 _affID;
558         if (_affCode != address(0) && _affCode != _addr)
559         {
560             // 获取推广人ID
561             _affID = pIDxAddr_[_affCode];
562 
563             // 如果推广人ID与先前不同
564             if (_affID != plyr_[_pID].laff)
565             {
566                 // 更新推广人
567                 plyr_[_pID].laff = _affID;
568             }
569         }
570 
571         // 注册名称
572         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
573     }
574 
575     // 通过已有名称注册新名称
576     function registerNameXname(address _addr, string _nameString, bytes32 _affCode, bool _all)
577     external
578     payable
579     {
580         // 确保支付名称费用
581         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
582 
583         // 过滤名称
584         bytes32 _name = NameFilter.nameFilter(_nameString);
585 
586         // 是否是新玩家
587         bool _isNewPlayer = determinePID(_addr);
588 
589         // 获取玩家ID
590         uint256 _pID = pIDxAddr_[_addr];
591 
592         // 如果没有推广人ID或者推广人是自己
593         uint256 _affID;
594         if (_affCode != "" && _affCode != _name)
595         {
596             // 获取推广人ID
597             _affID = pIDxName_[_affCode];
598 
599             // 如果推广人ID与先前存储的不同
600             if (_affID != plyr_[_pID].laff)
601             {
602                 // 更新推广人
603                 plyr_[_pID].laff = _affID;
604             }
605         }
606 
607         // 注册名称
608         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
609     }
610 
611     // 正式注册
612     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
613     private
614     {
615         // 如果已使用名称，则要求当前的msg发件人拥有该名称
616         if (pIDxName_[_name] != 0)
617             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
618 
619         // 为玩家配置文件，注册表和名称簿添加名称
620         plyr_[_pID].name = _name;
621         pIDxName_[_name] = _pID;
622         if (plyrNames_[_pID][_name] == false)
623         {
624             plyrNames_[_pID][_name] = true;
625             plyr_[_pID].names++;
626             plyrNameList_[_pID][plyr_[_pID].names] = _name;
627         }
628 
629         // 注册费直接归于社区奖励
630         Jekyll_Island_Inc.transfer(address(this).balance);
631 
632         // 将玩家信息推送到游戏
633         // 暂时注释 bluehook
634         _all;
635         //if (_all == true)
636         //    for (uint256 i = 1; i <= gID_; i++)
637         //        games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
638 
639 
640         // 发送事件
641         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
642     }
643 
644     // 通过ID购买钥匙
645     function buyXid(uint256 _affCode, uint256 _team)
646     isActivated()
647     isHuman()
648     isWithinLimits(msg.value)
649     public
650     payable
651     {
652         // 设置交易事件数据,确定玩家是否是新玩家
653         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
654 
655         //获取玩家ID
656         uint256 _pID = pIDxAddr_[msg.sender];
657 
658         // 如果没有推广人并且推广人不是自己
659         if (_affCode == 0 || _affCode == _pID)
660         {
661             // 使用最后存储的推广人代码
662             _affCode = plyr_[_pID].laff;
663         } else if (_affCode != plyr_[_pID].laff) {
664             // 更新最后一个推广人代码
665             plyr_[_pID].laff = _affCode;
666         }
667 
668         // 确认选择了有效的团队
669         _team = verifyTeam(_team);
670 
671         // 买核心
672         buyCore(_pID, _affCode, _team, _eventData_);
673     }
674 
675     // 通过地址购买
676     function buyXaddr(address _affCode, uint256 _team)
677     isActivated()
678     isHuman()
679     isWithinLimits(msg.value)
680     public
681     payable
682     {
683         // 设置交易事件数据,确定玩家是否是新玩家
684         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
685 
686         // 获取玩家ID
687         uint256 _pID = pIDxAddr_[msg.sender];
688 
689         // 如果没有推广人并且推广人不是自己
690         uint256 _affID;
691         if (_affCode == address(0) || _affCode == msg.sender)
692         {
693             // 使用最后存储的推广人代码
694             _affID = plyr_[_pID].laff;
695         } else {
696             // 获取推广ID
697             _affID = pIDxAddr_[_affCode];
698 
699             // 如果推广ID与先前存储的不同
700             if (_affID != plyr_[_pID].laff)
701             {
702                 // 更新最后一个推广人代码
703                 plyr_[_pID].laff = _affID;
704             }
705         }
706 
707         // 确认选择了有效的团队
708         _team = verifyTeam(_team);
709 
710         // 买核心
711         buyCore(_pID, _affID, _team, _eventData_);
712     }
713 
714     // 通过玩家名购买
715     function buyXname(bytes32 _affCode, uint256 _team)
716     isActivated()
717     isHuman()
718     isWithinLimits(msg.value)
719     public
720     payable
721     {
722         // 设置交易事件数据,确定玩家是否是新玩家
723         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
724 
725         // 获取玩家ID
726         uint256 _pID = pIDxAddr_[msg.sender];
727 
728         // 如果没有推广人并且推广人不是自己
729         uint256 _affID;
730         if (_affCode == '' || _affCode == plyr_[_pID].name)
731         {
732             // 使用最后存储的推广人代码
733             _affID = plyr_[_pID].laff;
734         } else {
735             // 获取推广人ID
736             _affID = pIDxName_[_affCode];
737 
738             // 如果推广人ID与先前存储的不同
739             if (_affID != plyr_[_pID].laff)
740             {
741                 // 更新最后一个推广人代码
742                 plyr_[_pID].laff = _affID;
743             }
744         }
745 
746         // 确认选择了有效的团队
747         _team = verifyTeam(_team);
748 
749         // 买核心
750         buyCore(_pID, _affID, _team, _eventData_);
751     }
752 
753     // 使用未提取的收入购买
754     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
755     isActivated()
756     isHuman()
757     isWithinLimits(_eth)
758     public
759     {
760         // 设置交易事件
761         F3Ddatasets.EventReturns memory _eventData_;
762 
763         // 获取玩家ID
764         uint256 _pID = pIDxAddr_[msg.sender];
765 
766         // 如果没有推广人并且推广人不是自己
767         if (_affCode == 0 || _affCode == _pID)
768         {
769             // 使用最后存储的推广人代码
770             _affCode = plyr_[_pID].laff;
771 
772         } else if (_affCode != plyr_[_pID].laff) {
773             // 更新最后一个推广人代码
774             plyr_[_pID].laff = _affCode;
775         }
776 
777         // 确认选择了有效的团队
778         _team = verifyTeam(_team);
779 
780         // 重买核心
781         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
782     }
783 
784     // 使用为提取的收入购买通过地址
785     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
786     isActivated()
787     isHuman()
788     isWithinLimits(_eth)
789     public
790     {
791         // 设置交易事件
792         F3Ddatasets.EventReturns memory _eventData_;
793 
794         // 获取玩家ID
795         uint256 _pID = pIDxAddr_[msg.sender];
796 
797         // 如果没有推广人并且推广人不是自己
798         uint256 _affID;
799         if (_affCode == address(0) || _affCode == msg.sender)
800         {
801             // 获取最后的推广人ID
802             _affID = plyr_[_pID].laff;
803         } else {
804             // 获取最后的推广人ID
805             _affID = pIDxAddr_[_affCode];
806 
807             // 如果推广人ID与先前存储的不同
808             if (_affID != plyr_[_pID].laff)
809             {
810                 // 更新最后一个推广人
811                 plyr_[_pID].laff = _affID;
812             }
813         }
814 
815         // 确认选择了有效的团队
816         _team = verifyTeam(_team);
817 
818         // 重买核心
819         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
820     }
821 
822     // 使用未提取的收入购买通过名称
823     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
824     isActivated()
825     isHuman()
826     isWithinLimits(_eth)
827     public
828     {
829         // 设置交易事件
830         F3Ddatasets.EventReturns memory _eventData_;
831 
832         // 获取玩家ID
833         uint256 _pID = pIDxAddr_[msg.sender];
834 
835         // 如果没有推广人并且推广人不是自己
836         uint256 _affID;
837         if (_affCode == '' || _affCode == plyr_[_pID].name)
838         {
839             // 获取推广人ID
840             _affID = plyr_[_pID].laff;
841         } else {
842             // 获取推广人ID
843             _affID = pIDxName_[_affCode];
844 
845             // 如果推广人ID与先前的不同
846             if (_affID != plyr_[_pID].laff)
847             {
848                 // 更新最后一个推广人
849                 plyr_[_pID].laff = _affID;
850             }
851         }
852 
853         // 确认选择了有效的团队
854         _team = verifyTeam(_team);
855 
856         // 重买核心
857         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
858     }
859 
860     // 检查用户是否选择了队伍,如果没有默认蛇队
861     function verifyTeam(uint256 _team)
862     private
863     pure
864     returns (uint256)
865     {
866         if (_team < 0 || _team > 3)
867             return (2);
868         else
869             return (_team);
870     }
871 
872     // 购买
873     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
874     private
875     {
876         // 设置本地rID
877         uint256 _rID = rID_;
878 
879         // 当前时间
880         uint256 _now = now;
881 
882         // 如果回合进行中
883         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
884         {
885             // 尝试购买
886             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
887         } else {
888             // 如果round不活跃
889 
890             // 检查是否回合已经结束
891             if (_now > round_[_rID].end && round_[_rID].ended == false)
892             {
893                 // 结束回合（奖池分红）并开始新回合
894                 round_[_rID].ended = true;
895                 _eventData_ = endRound(_eventData_);
896 
897                 // 构建事件数据
898                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
899                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
900 
901                 // 发起购买事件
902                 emit onBuyAndDistribute
903                 (
904                     msg.sender,
905                     plyr_[_pID].name,
906                     msg.value,
907                     _eventData_.compressedData,
908                     _eventData_.compressedIDs,
909                     _eventData_.winnerAddr,
910                     _eventData_.winnerName,
911                     _eventData_.amountWon,
912                     _eventData_.newPot,
913                     _eventData_.P3DAmount,
914                     _eventData_.genAmount
915                 );
916             }
917 
918             //把eth放在球员保险库里
919             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
920         }
921     }
922 
923     // 重新购买
924     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
925     private
926     {
927         // 设置本地rID
928         uint256 _rID = rID_;
929 
930         // 获取时间
931         uint256 _now = now;
932 
933         // 回合进行中
934         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
935         {
936             // 从所有保险库中获取收益并将未使用的保险库返还给gen保险库
937             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
938 
939             // 购买
940             core(_rID, _pID, _eth, _affID, _team, _eventData_);
941         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
942             // 回合结束,奖池分红,并开始新回合
943             round_[_rID].ended = true;
944             _eventData_ = endRound(_eventData_);
945 
946             // 构建事件数据
947             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
948             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
949 
950             // 发送购买和分发事件
951             emit onReLoadAndDistribute
952             (
953                 msg.sender,
954                 plyr_[_pID].name,
955                 _eventData_.compressedData,
956                 _eventData_.compressedIDs,
957                 _eventData_.winnerAddr,
958                 _eventData_.winnerName,
959                 _eventData_.amountWon,
960                 _eventData_.newPot,
961                 _eventData_.P3DAmount,
962                 _eventData_.genAmount
963             );
964         }
965     }
966 
967     // 如果管理员开始新一轮,移动玩家没有保存的钱包收入到保险箱
968     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
969     private
970     returns (F3Ddatasets.EventReturns)
971     {
972         // 如果玩家玩过上一轮，则移动他们的收入到保险箱。
973         if (plyr_[_pID].lrnd != 0)
974             updateGenVault(_pID, plyr_[_pID].lrnd);
975 
976         // 更新玩家的最后一轮比赛
977         plyr_[_pID].lrnd = rID_;
978 
979         // 将参与的回合bool设置为true
980         _eventData_.compressedData = _eventData_.compressedData + 10;
981 
982         return (_eventData_);
983     }
984 
985     // 计算没有归入钱包的收入（只计算，不更新钱包）
986     // 返回wei格式的收入
987     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
988     private
989     view
990     returns (uint256)
991     {
992         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
993     }
994 
995     // 将收入移至收入保险箱
996     function updateGenVault(uint256 _pID, uint256 _rIDlast)
997     private
998     {
999         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1000         if (_earnings > 0)
1001         {
1002             // 放入分红库
1003             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1004             // 更新钱包并将收入归0
1005             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1006         }
1007     }
1008 
1009     // 根据购买的全部钥匙数量更新回合计时器
1010     function updateTimer(uint256 _keys, uint256 _rID)
1011     private
1012     {
1013         // 当前时间
1014         uint256 _now = now;
1015 
1016         // 根据购买的钥匙数计算时间
1017         uint256 _newTime;
1018         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
1019             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
1020         else
1021             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
1022 
1023         // 与最长限制比较并设置新的结束时间
1024         if (_newTime < (rndMax_).add(_now))
1025             round_[_rID].end = _newTime;
1026         else
1027             round_[_rID].end = rndMax_.add(_now);
1028     }
1029 
1030     // 检查空投
1031     function airdrop()
1032     private
1033     view
1034     returns (bool)
1035     {
1036         uint256 seed = uint256(keccak256(abi.encodePacked(
1037 
1038                 (block.timestamp).add
1039                 (block.difficulty).add
1040                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1041                 (block.gaslimit).add
1042                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1043                 (block.number)
1044 
1045             )));
1046         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1047             return (true);
1048         else
1049             return (false);
1050     }
1051 
1052     // 购买核心
1053     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1054     private
1055     {
1056         // 如果玩家是新手
1057         if (plyrRnds_[_pID][_rID].keys == 0)
1058             _eventData_ = managePlayer(_pID, _eventData_);
1059 
1060         // 早期的道德限制器 <100eth ... >=1eth 早期奖池小于100eth，一个玩家一局限制购买最多1eth
1061         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1062         {
1063             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth); // 1eth
1064             uint256 _refund = _eth.sub(_availableLimit);
1065             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1066             _eth = _availableLimit;
1067         }
1068 
1069         // 如果eth大于最小购买eth数量
1070         if (_eth > 1000000000) //0.0000001eth
1071         {
1072 
1073             // 计算可购买钥匙数量
1074             uint256 _keys = keysRec(round_[_rID].eth,_eth);
1075 
1076             // 如果至少买一把钥匙19位
1077             if (_keys >= 1000000000000000000)
1078             {
1079                 updateTimer(_keys, _rID);
1080 
1081                 // 设置新的领先者
1082                 if (round_[_rID].plyr != _pID)
1083                     round_[_rID].plyr = _pID;
1084                 if (round_[_rID].team != _team)
1085                     round_[_rID].team = _team;
1086 
1087                 // 将新的领先者布尔设置为true
1088                 _eventData_.compressedData = _eventData_.compressedData + 100;
1089             }
1090 
1091             // 管理空投,如果购买金额至少0.1eth
1092             if (_eth >= 100000000000000000)
1093             {
1094                 airDropTracker_++;
1095                 if (airdrop() == true)
1096                 {
1097                     uint256 _prize;
1098                     if (_eth >= 10000000000000000000) // 10eth
1099                     {
1100                         // 计算奖金并将其交给获胜者
1101                         _prize = ((airDropPot_).mul(75)) / 100;
1102                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1103 
1104                         // 调整空投罐
1105                         airDropPot_ = (airDropPot_).sub(_prize);
1106 
1107                         // 让活动知道赢得了一级奖
1108                         _eventData_.compressedData += 300000000000000000000000000000000;
1109                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1110                         // 计算奖金并将其交给获胜者 1eth ~ 10eth
1111                         _prize = ((airDropPot_).mul(50)) / 100;
1112                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1113 
1114                         // 调整空头罐
1115                         airDropPot_ = (airDropPot_).sub(_prize);
1116 
1117                         // 让活动知道获得二等奖
1118                         _eventData_.compressedData += 200000000000000000000000000000000;
1119                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1120                         // 计算奖金并将其交给获胜者 0.11eth ~ 1eth
1121                         _prize = ((airDropPot_).mul(25)) / 100;
1122                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1123 
1124                         // 调整空头罐
1125                         airDropPot_ = (airDropPot_).sub(_prize);
1126 
1127                         // 让活动知道赢得了三级奖
1128                         _eventData_.compressedData += 300000000000000000000000000000000;
1129                     }
1130                     // 设置空投罐触发bool为true
1131                     _eventData_.compressedData += 10000000000000000000000000000000;
1132                     // 让玩家知道赢了多少
1133                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1134 
1135                     // 重置空投罐计数
1136                     airDropTracker_ = 0;
1137                 }
1138             }
1139 
1140             // 存储空投罐计数
1141             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1142 
1143             // 更新玩家数据
1144             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1145             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1146 
1147             // 更新回合数据
1148             round_[_rID].keys = _keys.add(round_[_rID].keys);
1149             round_[_rID].eth = _eth.add(round_[_rID].eth);
1150             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1151 
1152             // eth分红
1153             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1154             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1155 
1156             // 调用结束交易函数来触发结束交易事件。
1157             endTx(_pID, _team, _eth, _keys, _eventData_);
1158         }
1159     }
1160 
1161     // 返回玩家金库
1162     function getPlayerVaults(uint256 _pID)
1163     public
1164     view
1165     returns (uint256, uint256, uint256)
1166     {
1167         // 设置本地rID
1168         uint256 _rID = rID_;
1169 
1170         // 如果回合结束尚未开始（因此合同没有分配奖金）
1171         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1172         {
1173             // 如果玩家是赢家
1174             if (round_[_rID].plyr == _pID)
1175             {
1176                 return
1177                 (
1178                 (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
1179                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1180                 plyr_[_pID].aff
1181                 );
1182             } else {
1183                 // 如果玩家不是赢家
1184                 return
1185                 (
1186                 plyr_[_pID].win,
1187                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1188                 plyr_[_pID].aff
1189                 );
1190             }
1191         } else {
1192             // 如果回合仍然在进行或者回合结束又已经运行
1193             return
1194             (
1195             plyr_[_pID].win,
1196             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1197             plyr_[_pID].aff
1198             );
1199         }
1200     }
1201 
1202     // 计算金库金额帮助函数
1203     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1204     private
1205     view
1206     returns (uint256)
1207     {
1208         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
1209     }
1210 
1211     // 压缩数据并触发购买更新交易事件
1212     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1213     private
1214     {
1215         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1216         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1217 
1218         emit onEndTx
1219         (
1220             _eventData_.compressedData,
1221             _eventData_.compressedIDs,
1222             plyr_[_pID].name,
1223             msg.sender,
1224             _eth,
1225             _keys,
1226             _eventData_.winnerAddr,
1227             _eventData_.winnerName,
1228             _eventData_.amountWon,
1229             _eventData_.newPot,
1230             _eventData_.P3DAmount,
1231             _eventData_.genAmount,
1232             _eventData_.potAmount,
1233             airDropPot_
1234         );
1235     }
1236 
1237     // 外部分红
1238     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1239     private
1240     returns (F3Ddatasets.EventReturns)
1241     {
1242         // 支付2％的社区奖励
1243         uint256 _com = _eth / 50;
1244         uint256 _p3d;
1245         if (!address(Jekyll_Island_Inc).send(_com))
1246         {
1247             _p3d = _com;
1248             _com = 0;
1249         }
1250 
1251         // 向FoMo3D支付1％的费用
1252         uint256 _long = _eth / 100;
1253         otherF3D_.transfer(_long);
1254 
1255         // 将推广费用分配给会员
1256         uint256 _aff = _eth / 10;
1257 
1258         // 决定如何处理推广费用
1259         // 不能是自己，并且必须注册名称
1260         // 如果没有就归P3D
1261         if (_affID != _pID && plyr_[_affID].name != '') {
1262             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1263             emit onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1264         } else {
1265             _p3d = _aff;
1266         }
1267 
1268         // 支付P3D
1269         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1270         if (_p3d > 0)
1271         {
1272             // 然后存入DVS合约
1273             Divies.transfer(_p3d);
1274 
1275             // 设置事件数据
1276             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1277         }
1278 
1279         return (_eventData_);
1280     }
1281 
1282     // 内部分红
1283     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1284     private
1285     returns (F3Ddatasets.EventReturns)
1286     {
1287         // 计算分红份额
1288         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1289 
1290         // 将1％投入空投罐
1291         uint256 _air = (_eth / 100);
1292         airDropPot_ = airDropPot_.add(_air);
1293 
1294         // 更新eth balance（eth = eth  - （com share + pot swap share + aff share + p3d share + airdrop pot share））
1295         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1296 
1297         // 计算的奖池
1298         uint256 _pot = _eth.sub(_gen);
1299 
1300         // 分发分红
1301         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1302         if (_dust > 0)
1303             _gen = _gen.sub(_dust);
1304 
1305         // 添加eth到奖池
1306         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1307 
1308         // 设置事件数据
1309         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1310         _eventData_.potAmount = _pot;
1311 
1312         return (_eventData_);
1313     }
1314 
1315     // 副奖池
1316     function potSwap()
1317     external
1318     payable
1319     {
1320         // 获取一个rID
1321         uint256 _rID = rID_ + 1;
1322 
1323         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1324         emit onPotSwapDeposit(_rID, msg.value);
1325     }
1326 
1327     // 购买钥匙时更新回合和玩家钱包
1328     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1329     private
1330     returns (uint256)
1331     {
1332 
1333         // 基于此次购买的每个钥匙和回合分红利润:(剩余进入奖池）
1334         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1335         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1336 
1337         // 计算自己的收入（基于刚刚买的钥匙数量）并更新玩家钱包
1338         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1339         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1340 
1341         //计算并返回灰尘
1342         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1343     }
1344 
1345     // 结束了本回合,支付赢家和平分奖池
1346     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1347     private
1348     returns (F3Ddatasets.EventReturns)
1349     {
1350         // 获取一个rID
1351         uint256 _rID = rID_;
1352 
1353         // 获取获胜玩家和队伍
1354         uint256 _winPID = round_[_rID].plyr;
1355         uint256 _winTID = round_[_rID].team;
1356 
1357         // 获取奖池
1358         uint256 _pot = round_[_rID].pot;
1359 
1360         // 计算获胜玩家份额，社区奖励，公司份额，
1361         // P3D分享，以及为下一个底池保留的金额
1362         uint256 _win = (_pot.mul(48)) / 100;
1363         uint256 _com = (_pot / 50);
1364         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1365         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1366         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1367 
1368         // 计算回合钱包的ppt
1369         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1370         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1371         if (_dust > 0)
1372         {
1373             _gen = _gen.sub(_dust);
1374             _res = _res.add(_dust);
1375         }
1376 
1377         // 支付我们的赢家
1378         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1379 
1380         // P3D奖励
1381         if (!address(Jekyll_Island_Inc).send(_com))
1382         {
1383             _p3d = _p3d.add(_com);
1384             _com = 0;
1385         }
1386 
1387         // 将gen部分分发给密钥持有者
1388         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1389 
1390         // 将P3D的份额发送给divies
1391         if (_p3d > 0)
1392             Divies.transfer(_p3d);
1393 
1394         // 准备事件
1395         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1396         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1397         _eventData_.winnerAddr = plyr_[_winPID].addr;
1398         _eventData_.winnerName = plyr_[_winPID].name;
1399         _eventData_.amountWon = _win;
1400         _eventData_.genAmount = _gen;
1401         _eventData_.P3DAmount = _p3d;
1402         _eventData_.newPot = _res;
1403 
1404         // 新一轮开始
1405         rID_++;
1406         _rID++;
1407         round_[_rID].strt = now;
1408         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1409         round_[_rID].pot = _res;
1410 
1411         return (_eventData_);
1412     }
1413 
1414     // 通过地址获取玩家信息
1415     function getPlayerInfoByAddress(address _addr)
1416     public
1417     view
1418     returns (uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1419     {
1420         // 设置本地rID
1421         uint256 _rID = rID_;
1422 
1423         if (_addr == address(0))
1424         {
1425             _addr == msg.sender;
1426         }
1427         uint256 _pID = pIDxAddr_[_addr];
1428 
1429         return
1430         (
1431         _pID, //0
1432         plyr_[_pID].name, //1
1433         plyrRnds_[_pID][_rID].keys, //2
1434         plyr_[_pID].win, //3
1435         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), //4
1436         plyr_[_pID].aff, //5
1437         plyrRnds_[_pID][_rID].eth           //6
1438         );
1439     }
1440 
1441     // 回合数据
1442     function getCurrentRoundInfo()
1443     public
1444     view
1445     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1446     {
1447         // 设置本地rID
1448         uint256 _rID = rID_;
1449 
1450         return
1451         (
1452         round_[_rID].ico, //0
1453         _rID, //1
1454         round_[_rID].keys, //2
1455         round_[_rID].end, //3
1456         round_[_rID].strt, //4
1457         round_[_rID].pot, //5
1458         (round_[_rID].team + (round_[_rID].plyr * 10)), //6
1459         plyr_[round_[_rID].plyr].addr, //7
1460         plyr_[round_[_rID].plyr].name, //8
1461         rndTmEth_[_rID][0], //9
1462         rndTmEth_[_rID][1], //10
1463         rndTmEth_[_rID][2], //11
1464         rndTmEth_[_rID][3], //12
1465         airDropTracker_ + (airDropPot_ * 1000)              //13
1466         );
1467     }
1468 
1469     // 撤回所有收入
1470     function withdraw()
1471     isActivated()
1472     isHuman()
1473     public
1474     {
1475         // 设置本地rID
1476         uint256 _rID = rID_;
1477 
1478         // 获取时间
1479         uint256 _now = now;
1480 
1481         // 获取玩家ID
1482         uint256 _pID = pIDxAddr_[msg.sender];
1483 
1484         // 临时变量
1485         uint256 _eth;
1486 
1487         // 检查回合是否已经结束，还没有人绕过回合结束
1488         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1489         {
1490             // 设置交易事件
1491             F3Ddatasets.EventReturns memory _eventData_;
1492 
1493             // 结束回合（奖池分红）
1494             round_[_rID].ended = true;
1495             _eventData_ = endRound(_eventData_);
1496 
1497             // 得到他的收入
1498             _eth = withdrawEarnings(_pID);
1499 
1500             // 支付玩家
1501             if (_eth > 0)
1502                 plyr_[_pID].addr.transfer(_eth);
1503 
1504             // 构建事件数据
1505             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1506             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1507 
1508             // 撤回分发事件
1509             emit onWithdrawAndDistribute
1510             (
1511                 msg.sender,
1512                 plyr_[_pID].name,
1513                 _eth,
1514                 _eventData_.compressedData,
1515                 _eventData_.compressedIDs,
1516                 _eventData_.winnerAddr,
1517                 _eventData_.winnerName,
1518                 _eventData_.amountWon,
1519                 _eventData_.newPot,
1520                 _eventData_.P3DAmount,
1521                 _eventData_.genAmount
1522             );
1523         } else {
1524             // 在任何其他情况下
1525             // 得到他的收入
1526             _eth = withdrawEarnings(_pID);
1527 
1528             // 支付玩家
1529             if (_eth > 0)
1530                 plyr_[_pID].addr.transfer(_eth);
1531 
1532             // 撤回事件
1533             emit onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
1534         }
1535     }
1536 
1537     // 将未显示的收入和保险库收入加起来返回,并将它们置为0
1538     function withdrawEarnings(uint256 _pID)
1539     private
1540     returns (uint256)
1541     {
1542         // 更新gen保险库
1543         updateGenVault(_pID, plyr_[_pID].lrnd);
1544 
1545         // 来自金库
1546         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1547         if (_earnings > 0)
1548         {
1549             plyr_[_pID].win = 0;
1550             plyr_[_pID].gen = 0;
1551             plyr_[_pID].aff = 0;
1552         }
1553 
1554         return (_earnings);
1555     }
1556 
1557     // 计算给定eth可购买的钥匙数量
1558     function calcKeysReceived(uint256 _rID, uint256 _eth)
1559     public
1560     view
1561     returns (uint256)
1562     {
1563         // 获取时间
1564         uint256 _now = now;
1565 
1566         // 回合进行中
1567         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
1568             return keysRec(round_[_rID].eth + _eth,_eth);
1569         } else {
1570             // 如果结束,返回新一轮的数量
1571             return keys(_eth);
1572         }
1573     }
1574 
1575     // 返回购买指定数量钥匙需要的eth
1576     function iWantXKeys(uint256 _keys)
1577     public
1578     view
1579     returns (uint256)
1580     {
1581         // 设置本地rID
1582         uint256 _rID = rID_;
1583 
1584         // 获取时间
1585         uint256 _now = now;
1586 
1587         // 在回合进行中
1588         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1589             return ethRec(round_[_rID].keys + _keys,_keys);
1590         else // 如果结束,返回新一轮的价格
1591             return eth(_keys);
1592     }
1593 
1594     // 计算以太币能够购买的钥匙数量
1595     function keysRec(uint256 _curEth, uint256 _newEth)
1596     internal
1597     pure
1598     returns (uint256)
1599     {
1600         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1601     }
1602 
1603     function keys(uint256 _eth)
1604     internal
1605     pure
1606     returns(uint256)
1607     {
1608         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1609     }
1610 
1611     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1612     internal
1613     pure
1614     returns (uint256)
1615     {
1616         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1617     }
1618 
1619     function eth(uint256 _keys)
1620     internal
1621     pure
1622     returns(uint256)
1623     {
1624         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1625     }
1626 }