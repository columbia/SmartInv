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
47 
48 interface PlayerBookReceiverInterface {
49     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
50     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
51 }
52 
53 
54 contract PlayerBook {
55     using NameFilter for string;
56     using SafeMath for uint256;
57 
58     address private admin = msg.sender;
59 //==============================================================================
60 //     _| _ _|_ _    _ _ _|_    _   .
61 //    (_|(_| | (_|  _\(/_ | |_||_)  .
62 //=============================|================================================
63     uint256 public registrationFee_ = 10 finney;            // 注册名称的价格
64     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // 映射我们的游戏界面，将您的帐户信息发送到游戏
65     mapping(address => bytes32) public gameNames_;          // 查找游戏名称
66     mapping(address => uint256) public gameIDs_;            // 查找游戏ID
67     uint256 public gID_;        // 游戏总数
68     uint256 public pID_;        // 球员总数
69     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) 按地址返回玩家ID
70     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) 按名称返回玩家ID
71     mapping (uint256 => Player) public plyr_;               // (pID => data) 球员数据
72     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) 玩家拥有的名字列表。 （用于这样你就可以改变你的显示名称，而不管你拥有的任何名字）
73     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) 玩家拥有的名字列表
74     struct Player {
75         address addr;
76         bytes32 name;
77         uint256 laff;
78         uint256 names;
79     }
80 //==============================================================================
81 //     _ _  _  __|_ _    __|_ _  _  .
82 //    (_(_)| |_\ | | |_|(_ | (_)|   .  （合同部署时的初始数据设置）
83 //==============================================================================
84     constructor()
85         public
86     {
87         // premine the dev names (sorry not sorry)
88             // No keys are purchased with this method, it's simply locking our addresses,
89             // PID's and names for referral codes.
90         plyr_[1].addr = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
91         plyr_[1].name = "justo";
92         plyr_[1].names = 1;
93         pIDxAddr_[0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53] = 1;
94         pIDxName_["justo"] = 1;
95         plyrNames_[1]["justo"] = true;
96         plyrNameList_[1][1] = "justo";
97 
98         plyr_[2].addr = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
99         plyr_[2].name = "mantso";
100         plyr_[2].names = 1;
101         pIDxAddr_[0x8b4DA1827932D71759687f925D17F81Fc94e3A9D] = 2;
102         pIDxName_["mantso"] = 2;
103         plyrNames_[2]["mantso"] = true;
104         plyrNameList_[2][1] = "mantso";
105 
106         plyr_[3].addr = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
107         plyr_[3].name = "sumpunk";
108         plyr_[3].names = 1;
109         pIDxAddr_[0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C] = 3;
110         pIDxName_["sumpunk"] = 3;
111         plyrNames_[3]["sumpunk"] = true;
112         plyrNameList_[3][1] = "sumpunk";
113 
114         plyr_[4].addr = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
115         plyr_[4].name = "inventor";
116         plyr_[4].names = 1;
117         pIDxAddr_[0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C] = 4;
118         pIDxName_["inventor"] = 4;
119         plyrNames_[4]["inventor"] = true;
120         plyrNameList_[4][1] = "inventor";
121 
122         pID_ = 4;
123     }
124 //==============================================================================
125 //     _ _  _  _|. |`. _  _ _  .
126 //    | | |(_)(_||~|~|(/_| _\  .  （这些是安全检查）
127 //==============================================================================
128     /**
129      * @dev 防止合同与worldfomo交互
130      */
131     modifier isHuman() {
132         address _addr = msg.sender;
133         uint256 _codeLength;
134 
135         assembly {_codeLength := extcodesize(_addr)}
136         require(_codeLength == 0, "sorry humans only");
137         _;
138     }
139 
140 
141     modifier isRegisteredGame()
142     {
143         require(gameIDs_[msg.sender] != 0);
144         _;
145     }
146 //==============================================================================
147 //     _    _  _ _|_ _  .
148 //    (/_\/(/_| | | _\  .
149 //==============================================================================
150     // 只要玩家注册了名字就会被解雇
151     event onNewName
152     (
153         uint256 indexed playerID,
154         address indexed playerAddress,
155         bytes32 indexed playerName,
156         bool isNewPlayer,
157         uint256 affiliateID,
158         address affiliateAddress,
159         bytes32 affiliateName,
160         uint256 amountPaid,
161         uint256 timeStamp
162     );
163 //==============================================================================
164 //     _  _ _|__|_ _  _ _  .
165 //    (_|(/_ |  | (/_| _\  . （用于UI和查看etherscan上的内容）
166 //=====_|=======================================================================
167     function checkIfNameValid(string _nameStr)
168         public
169         view
170         returns(bool)
171     {
172         bytes32 _name = _nameStr.nameFilter();
173         if (pIDxName_[_name] == 0)
174             return (true);
175         else
176             return (false);
177     }
178 //==============================================================================
179 //     _    |_ |. _   |`    _  __|_. _  _  _  .
180 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  （使用这些与合同互动）
181 //====|=========================================================================
182     /**
183      * @dev 注册一个名字。 UI将始终显示您注册的姓氏。
184      * 但您仍将拥有所有以前注册的名称以用作联属会员
185      * - 必须支付注册费。
186      * - 名称必须是唯一的
187      * - 名称将转换为小写
188      * - 名称不能以空格开头或结尾
189      * - 连续不能超过1个空格
190      * - 不能只是数字
191      * - 不能以0x开头
192      * - name必须至少为1个字符
193      * - 最大长度为32个字符
194      * - 允许的字符：a-z，0-9和空格
195      * -functionhash- 0x921dec21 (使用ID作为会员)
196      * -functionhash- 0x3ddd4698 (使用联盟会员的地址)
197      * -functionhash- 0x685ffd83 (使用联盟会员的名称)
198      * @param _nameString 球员想要的名字
199      * @param _affCode 会员ID，地址或谁提到你的名字
200      * @param _all 如果您希望将信息推送到所有游戏，则设置为true
201      * (这可能会耗费大量气体)
202      */
203     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
204         isHuman()
205         public
206         payable
207     {
208         // 确保支付名称费用
209         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
210 
211         // 过滤器名称+条件检查
212         bytes32 _name = NameFilter.nameFilter(_nameString);
213 
214         // 设置地址
215         address _addr = msg.sender;
216 
217         // 设置我们的tx事件数据并确定玩家是否是新手
218         bool _isNewPlayer = determinePID(_addr);
219 
220         // 获取玩家ID
221         uint256 _pID = pIDxAddr_[_addr];
222 
223         // 管理会员残差
224         // 如果没有给出联盟代码，则没有给出新的联盟代码，或者
225         // 玩家试图使用自己的pID作为联盟代码
226         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
227         {
228             // 更新最后一个会员
229             plyr_[_pID].laff = _affCode;
230         } else if (_affCode == _pID) {
231             _affCode = 0;
232         }
233 
234         // 注册名称
235         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
236     }
237 
238     function registerNameXaddr(string _nameString, address _affCode, bool _all)
239         isHuman()
240         public
241         payable
242     {
243         // 确保支付名称费用
244         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
245 
246         // 过滤器名称+条件检查
247         bytes32 _name = NameFilter.nameFilter(_nameString);
248 
249         // 设置地址
250         address _addr = msg.sender;
251 
252         // 设置我们的tx事件数据并确定玩家是否是新手
253         bool _isNewPlayer = determinePID(_addr);
254 
255         // 获取玩家ID
256         uint256 _pID = pIDxAddr_[_addr];
257 
258         // 管理会员残差
259         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
260         uint256 _affID;
261         if (_affCode != address(0) && _affCode != _addr)
262         {
263             // 从aff Code获取会员ID
264             _affID = pIDxAddr_[_affCode];
265 
266             // 如果affID与先前存储的不同
267             if (_affID != plyr_[_pID].laff)
268             {
269                 // 更新最后一个会员
270                 plyr_[_pID].laff = _affID;
271             }
272         }
273 
274         // 注册名称
275         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
276     }
277 
278     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
279         isHuman()
280         public
281         payable
282     {
283         // 确保支付名称费用
284         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
285 
286         // 过滤器名称+条件检查
287         bytes32 _name = NameFilter.nameFilter(_nameString);
288 
289         // 设置地址
290         address _addr = msg.sender;
291 
292         // 设置我们的tx事件数据并确定玩家是否是新手
293         bool _isNewPlayer = determinePID(_addr);
294 
295         // 获取玩家ID
296         uint256 _pID = pIDxAddr_[_addr];
297 
298         // 管理会员残差
299         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
300         uint256 _affID;
301         if (_affCode != "" && _affCode != _name)
302         {
303             // 从aff Code获取会员ID
304             _affID = pIDxName_[_affCode];
305 
306             // 如果affID与先前存储的不同
307             if (_affID != plyr_[_pID].laff)
308             {
309                 // 更新最后一个会员
310                 plyr_[_pID].laff = _affID;
311             }
312         }
313 
314         // 注册名称
315         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
316     }
317 
318     /**
319      * @dev 玩家，如果您在游戏发布之前注册了个人资料，或者
320      * 注册时将all bool设置为false，使用此功能进行推送
321      * 你对一场比赛的个人资料。另外，如果你更新了你的名字，那么你
322      * 可以使用此功能将您的名字推送到您选择的游戏中。
323      * -functionhash- 0x81c5b206
324      * @param _gameID 游戏ID
325      */
326     function addMeToGame(uint256 _gameID)
327         isHuman()
328         public
329     {
330         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
331         address _addr = msg.sender;
332         uint256 _pID = pIDxAddr_[_addr];
333         require(_pID != 0, "hey there buddy, you dont even have an account");
334         uint256 _totalNames = plyr_[_pID].names;
335 
336         // 添加玩家个人资料和最新名称
337         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
338 
339         // 添加所有名称的列表
340         if (_totalNames > 1)
341             for (uint256 ii = 1; ii <= _totalNames; ii++)
342                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
343     }
344 
345     /**
346      * @dev 玩家，使用此功能将您的玩家资料推送到所有已注册的游戏。
347      * -functionhash- 0x0c6940ea
348      */
349     function addMeToAllGames()
350         isHuman()
351         public
352     {
353         address _addr = msg.sender;
354         uint256 _pID = pIDxAddr_[_addr];
355         require(_pID != 0, "hey there buddy, you dont even have an account");
356         uint256 _laff = plyr_[_pID].laff;
357         uint256 _totalNames = plyr_[_pID].names;
358         bytes32 _name = plyr_[_pID].name;
359 
360         for (uint256 i = 1; i <= gID_; i++)
361         {
362             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
363             if (_totalNames > 1)
364                 for (uint256 ii = 1; ii <= _totalNames; ii++)
365                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
366         }
367 
368     }
369 
370     /**
371      * @dev 玩家使用它来改回你的一个旧名字。小费，你会的
372      * 仍然需要将该信息推送到现有游戏。
373      * -functionhash- 0xb9291296
374      * @param _nameString 您要使用的名称
375      */
376     function useMyOldName(string _nameString)
377         isHuman()
378         public
379     {
380         // 过滤器名称，并获取pID
381         bytes32 _name = _nameString.nameFilter();
382         uint256 _pID = pIDxAddr_[msg.sender];
383 
384         // 确保他们拥有这个名字
385         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
386 
387         // 更新他们当前的名字
388         plyr_[_pID].name = _name;
389     }
390 
391 //==============================================================================
392 //     _ _  _ _   | _  _ . _  .
393 //    (_(_)| (/_  |(_)(_||(_  .
394 //=====================_|=======================================================
395     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
396         private
397     {
398         // 如果已使用名称，则要求当前的msg发件人拥有该名称
399         if (pIDxName_[_name] != 0)
400             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
401 
402         // 为播放器配置文件，注册表和名称簿添加名称
403         plyr_[_pID].name = _name;
404         pIDxName_[_name] = _pID;
405         if (plyrNames_[_pID][_name] == false)
406         {
407             plyrNames_[_pID][_name] = true;
408             plyr_[_pID].names++;
409             plyrNameList_[_pID][plyr_[_pID].names] = _name;
410         }
411 
412         // 注册费直接归于社区奖励
413         admin.transfer(address(this).balance);
414 
415         // 将玩家信息推送到游戏
416         if (_all == true)
417             for (uint256 i = 1; i <= gID_; i++)
418                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
419 
420         // 火灾事件
421         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
422     }
423 //==============================================================================
424 //    _|_ _  _ | _  .
425 //     | (_)(_)|_\  .
426 //==============================================================================
427     function determinePID(address _addr)
428         private
429         returns (bool)
430     {
431         if (pIDxAddr_[_addr] == 0)
432         {
433             pID_++;
434             pIDxAddr_[_addr] = pID_;
435             plyr_[pID_].addr = _addr;
436 
437             // 将新玩家bool设置为true
438             return (true);
439         } else {
440             return (false);
441         }
442     }
443 //==============================================================================
444 //   _   _|_ _  _ _  _ |   _ _ || _  .
445 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
446 //==============================================================================
447     function getPlayerID(address _addr)
448         isRegisteredGame()
449         external
450         returns (uint256)
451     {
452         determinePID(_addr);
453         return (pIDxAddr_[_addr]);
454     }
455     function getPlayerName(uint256 _pID)
456         external
457         view
458         returns (bytes32)
459     {
460         return (plyr_[_pID].name);
461     }
462     function getPlayerLAff(uint256 _pID)
463         external
464         view
465         returns (uint256)
466     {
467         return (plyr_[_pID].laff);
468     }
469     function getPlayerAddr(uint256 _pID)
470         external
471         view
472         returns (address)
473     {
474         return (plyr_[_pID].addr);
475     }
476     function getNameFee()
477         external
478         view
479         returns (uint256)
480     {
481         return(registrationFee_);
482     }
483     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
484         isRegisteredGame()
485         external
486         payable
487         returns(bool, uint256)
488     {
489         // 确保支付名称费用
490         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
491 
492         // 设置我们的tx事件数据并确定玩家是否是新手
493         bool _isNewPlayer = determinePID(_addr);
494 
495         // 获取玩家ID
496         uint256 _pID = pIDxAddr_[_addr];
497 
498         // 管理会员残差
499         // 如果没有给出联盟代码，则没有给出新的联盟代码，或者
500         // 玩家试图使用自己的pID作为联盟代码
501         uint256 _affID = _affCode;
502         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
503         {
504             // 更新最后一个会员
505             plyr_[_pID].laff = _affID;
506         } else if (_affID == _pID) {
507             _affID = 0;
508         }
509 
510         // 注册名称
511         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
512 
513         return(_isNewPlayer, _affID);
514     }
515     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
516         isRegisteredGame()
517         external
518         payable
519         returns(bool, uint256)
520     {
521         // 确保支付名称费用
522         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
523 
524         // 设置我们的tx事件数据并确定玩家是否是新手
525         bool _isNewPlayer = determinePID(_addr);
526 
527         // 获取玩家ID
528         uint256 _pID = pIDxAddr_[_addr];
529 
530         // 管理会员残差
531         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
532         uint256 _affID;
533         if (_affCode != address(0) && _affCode != _addr)
534         {
535             // 从aff Code获取会员ID
536             _affID = pIDxAddr_[_affCode];
537 
538             // 如果affID与先前存储的不同
539             if (_affID != plyr_[_pID].laff)
540             {
541                 // 更新最后一个会员
542                 plyr_[_pID].laff = _affID;
543             }
544         }
545 
546         // 注册名称
547         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
548 
549         return(_isNewPlayer, _affID);
550     }
551     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
552         isRegisteredGame()
553         external
554         payable
555         returns(bool, uint256)
556     {
557         // 确保支付名称费用
558         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
559 
560         // 设置我们的tx事件数据并确定玩家是否是新手
561         bool _isNewPlayer = determinePID(_addr);
562 
563         // 获取玩家ID
564         uint256 _pID = pIDxAddr_[_addr];
565 
566         // 管理会员残差
567         // 如果没有给出联盟代码或者玩家试图使用他们自己的代码
568         uint256 _affID;
569         if (_affCode != "" && _affCode != _name)
570         {
571             // 从aff Code获取会员ID
572             _affID = pIDxName_[_affCode];
573 
574             // 如果affID与先前存储的不同
575             if (_affID != plyr_[_pID].laff)
576             {
577                 // 更新最后一个会员
578                 plyr_[_pID].laff = _affID;
579             }
580         }
581 
582         // 注册名称
583         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
584 
585         return(_isNewPlayer, _affID);
586     }
587 
588 //==============================================================================
589 //   _ _ _|_    _   .
590 //  _\(/_ | |_||_)  .
591 //=============|================================================================
592     function addGame(address _gameAddress, string _gameNameStr)
593         public
594     {
595         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
596             gID_++;
597             bytes32 _name = _gameNameStr.nameFilter();
598             gameIDs_[_gameAddress] = gID_;
599             gameNames_[_gameAddress] = _name;
600             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
601 
602             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
603             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
604             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
605             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
606     }
607 
608     function setRegistrationFee(uint256 _fee)
609         public
610     {
611       registrationFee_ = _fee;
612     }
613 
614 }
615 
616 
617 library NameFilter {
618 
619     /**
620      * @dev 过滤名称字符串
621      * -将大写转换为小写。
622      * -确保它不以空格开始/结束
623      * -确保它不包含连续的多个空格
624      * -不能只是数字
625      * -不能以0x开头
626      * -将字符限制为A-Z，a-z，0-9和空格。
627      * @return 以字节32格式重新处理的字符串
628      */
629     function nameFilter(string _input)
630         internal
631         pure
632         returns(bytes32)
633     {
634         bytes memory _temp = bytes(_input);
635         uint256 _length = _temp.length;
636 
637         //对不起限于32个字符
638         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
639         //确保它不以空格开头或以空格结尾
640         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
641         // 确保前两个字符不是0x
642         if (_temp[0] == 0x30)
643         {
644             require(_temp[1] != 0x78, "string cannot start with 0x");
645             require(_temp[1] != 0x58, "string cannot start with 0X");
646         }
647 
648         // 创建一个bool来跟踪我们是否有非数字字符
649         bool _hasNonNumber;
650 
651         // 转换和检查
652         for (uint256 i = 0; i < _length; i++)
653         {
654             // 如果它的大写A-Z
655             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
656             {
657                 // 转换为小写a-z
658                 _temp[i] = byte(uint(_temp[i]) + 32);
659 
660                 // 我们有一个非数字
661                 if (_hasNonNumber == false)
662                     _hasNonNumber = true;
663             } else {
664                 require
665                 (
666                     // 要求角色是一个空间
667                     _temp[i] == 0x20 ||
668                     // 或小写a-z
669                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
670                     // 或0-9
671                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
672                     "string contains invalid characters"
673                 );
674                 // 确保连续两行不是空格
675                 if (_temp[i] == 0x20)
676                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
677 
678                 // 看看我们是否有一个数字以外的字符
679                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
680                     _hasNonNumber = true;
681             }
682         }
683 
684         require(_hasNonNumber == true, "string cannot be only numbers");
685 
686         bytes32 _ret;
687         assembly {
688             _ret := mload(add(_temp, 32))
689         }
690         return (_ret);
691     }
692 }
693 
694 /**
695  * @title SafeMath v0.1.9
696  * @dev 带有安全检查的数学运算会引发错误
697  * - 添加 sqrt
698  * - 添加 sq
699  * - 添加 pwr
700  * - 将断言更改为需要带有错误日志输出
701  * - 删除div，它没用
702  */
703 library SafeMath {
704 
705     /**
706     * @dev 将两个数字相乘，抛出溢出。
707     */
708     function mul(uint256 a, uint256 b)
709         internal
710         pure
711         returns (uint256 c)
712     {
713         if (a == 0) {
714             return 0;
715         }
716         c = a * b;
717         require(c / a == b, "SafeMath mul failed");
718         return c;
719     }
720 
721     /**
722     * @dev 减去两个数字，在溢出时抛出（即，如果减数大于减数）。
723     */
724     function sub(uint256 a, uint256 b)
725         internal
726         pure
727         returns (uint256)
728     {
729         require(b <= a, "SafeMath sub failed");
730         return a - b;
731     }
732 
733     /**
734     * @dev 添加两个数字，溢出时抛出。
735     */
736     function add(uint256 a, uint256 b)
737         internal
738         pure
739         returns (uint256 c)
740     {
741         c = a + b;
742         require(c >= a, "SafeMath add failed");
743         return c;
744     }
745 
746     /**
747      * @dev 给出给定x的平方根。
748      */
749     function sqrt(uint256 x)
750         internal
751         pure
752         returns (uint256 y)
753     {
754         uint256 z = ((add(x,1)) / 2);
755         y = x;
756         while (z < y)
757         {
758             y = z;
759             z = ((add((x / z),z)) / 2);
760         }
761     }
762 
763     /**
764      * @dev 给广场。将x乘以x
765      */
766     function sq(uint256 x)
767         internal
768         pure
769         returns (uint256)
770     {
771         return (mul(x,x));
772     }
773 
774     /**
775      * @dev x到y的力量
776      */
777     function pwr(uint256 x, uint256 y)
778         internal
779         pure
780         returns (uint256)
781     {
782         if (x==0)
783             return (0);
784         else if (y==0)
785             return (1);
786         else
787         {
788             uint256 z = x;
789             for (uint256 i=1; i < y; i++)
790                 z = mul(z,x);
791             return (z);
792         }
793     }
794 }