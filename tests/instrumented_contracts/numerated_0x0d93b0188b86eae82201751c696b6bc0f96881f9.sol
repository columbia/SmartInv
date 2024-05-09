1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4     // 注册
5     event onNewName
6     (
7         uint256 indexed playerID,
8         address indexed playerAddress,
9         bytes32 indexed playerName,
10         bool isNewPlayer,
11         uint256 affiliateID,
12         address affiliateAddress,
13         bytes32 affiliateName,
14         uint256 amountPaid,
15         uint256 timeStamp
16     );
17     
18     // 购买
19     event onEndTx
20     (
21         uint256 compressedData,     
22         uint256 compressedIDs,      
23         bytes32 playerName,
24         address playerAddress,
25         uint256 ethIn,
26         uint256 keysBought,
27         address winnerAddr,
28         bytes32 winnerName,
29         uint256 amountWon,
30         uint256 newPot,
31         uint256 P3DAmount,
32         uint256 genAmount,
33         uint256 potAmount,
34         uint256 airDropPot
35     );
36     
37 	// 提取
38     event onWithdraw
39     (
40         uint256 indexed playerID,
41         address playerAddress,
42         bytes32 playerName,
43         uint256 ethOut,
44         uint256 timeStamp
45     );
46     
47     // 提取触发结束
48     event onWithdrawAndDistribute
49     (
50         address playerAddress,
51         bytes32 playerName,
52         uint256 ethOut,
53         uint256 compressedData,
54         uint256 compressedIDs,
55         address winnerAddr,
56         bytes32 winnerName,
57         uint256 amountWon,
58         uint256 newPot,
59         uint256 P3DAmount,
60         uint256 genAmount
61     );
62     
63     // 购买触发结束.
64     event onBuyAndDistribute
65     (
66         address playerAddress,
67         bytes32 playerName,
68         uint256 ethIn,
69         uint256 compressedData,
70         uint256 compressedIDs,
71         address winnerAddr,
72         bytes32 winnerName,
73         uint256 amountWon,
74         uint256 newPot,
75         uint256 P3DAmount,
76         uint256 genAmount
77     );
78     
79     // 使用金库购买触发结束.
80     event onReLoadAndDistribute
81     (
82         address playerAddress,
83         bytes32 playerName,
84         uint256 compressedData,
85         uint256 compressedIDs,
86         address winnerAddr,
87         bytes32 winnerName,
88         uint256 amountWon,
89         uint256 newPot,
90         uint256 P3DAmount,
91         uint256 genAmount
92     );
93     
94     // 被推荐人付费
95     event onAffiliatePayout
96     (
97         uint256 indexed affiliateID,
98         address affiliateAddress,
99         bytes32 affiliateName,
100         uint256 indexed roundID,
101         uint256 indexed buyerID,
102         uint256 amount,
103         uint256 timeStamp
104     );
105 }
106 
107 contract modularLong is F3Devents {}
108 
109 contract SCardLong is modularLong {
110     using SafeMath for *;
111     using NameFilter for string;
112     using F3DKeysCalcLong for uint256;
113     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xc873e3646534b2253f324ee7f5f7f5b2a857ba9a);
114 
115 
116     address public ceo;
117     address public cfo; 
118     string constant public name = "SCard";
119     string constant public symbol = "SCARD";
120     uint256 private rndExtra_ = 30 seconds;       
121     uint256 private rndGap_ = 30 seconds;         
122     uint256 constant private rndInit_ = 24 hours;                // 初始时间
123     uint256 constant private rndInc_ = 30 seconds;              // 每一个完整KEY增加
124     uint256 constant private rndMax_ = 24 hours;                // 最多允许增加到
125 
126     uint256 public airDropPot_;             // 空投
127     uint256 public airDropTracker_ = 0;     
128     uint256 public rID_;  
129 
130     mapping (address => uint256) public pIDxAddr_;          // 玩家地址 =》 玩家ID
131     mapping (bytes32 => uint256) public pIDxName_;          // 玩家用户名=》 玩家ID
132     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // 玩家ID =》 玩家数据
133     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // 玩家ID =》 第几轮 =》 玩家当轮数据
134     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // 玩家ID =》 玩家用户名 =》 True/False
135 
136     mapping (uint256 => F3Ddatasets.Round) public round_;   // 第几轮 =》 本轮数据
137     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // 第几轮=》TeamID=>该组数据
138 
139     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // TeamID => 购买分发比例配置
140     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // TeamID => 结束分发比例配置
141 
142 
143     constructor()
144         public
145     {
146         ceo = msg.sender;
147         cfo = msg.sender;
148 		//  青龙 奖池 30%, 所有持KEY玩家 -30%, 推荐 - 30%, 开发团队 - 5%, 空投 - 5%
149         fees_[0] = F3Ddatasets.TeamFee(30,0);  
150         //  白虎 奖池 25%, 所有持KEY玩家 -60%, 推荐 - 10%, 开发团队 - 5%, 空投 - 5%
151         fees_[1] = F3Ddatasets.TeamFee(60,0);   
152         //  朱雀 奖池 60%, 所有持KEY玩家 -20%, 推荐 - 10%, 开发团队 - 5%, 空投 - 5%
153         fees_[2] = F3Ddatasets.TeamFee(20,0);   
154         //  玄武 奖池 40%, 所有持KEY玩家 -40%, 推荐 - 10%, 开发团队 - 5%, 空投 - 5%
155         fees_[3] = F3Ddatasets.TeamFee(40,0);   
156         
157         // 青龙 55 - 大赢家 25 -> 所有持KEY玩家 15-> 下一轮 5-> 开发团队
158         potSplit_[0] = F3Ddatasets.PotSplit(25,0); 
159         // 白虎 55 - 大赢家 30 -> 所有持KEY玩家 10-> 下一轮 5-> 开发团队
160         potSplit_[1] = F3Ddatasets.PotSplit(30,0);  
161         // 朱雀 55 - 大赢家 10 -> 所有持KEY玩家 30-> 下一轮 5-> 开发团队
162         potSplit_[2] = F3Ddatasets.PotSplit(10,0);  
163         // 玄武 55 - 大赢家 20 -> 所有持KEY玩家 20-> 下一轮 5-> 开发团队
164         potSplit_[3] = F3Ddatasets.PotSplit(20,0);  
165 	}
166 
167     modifier isActivated() {
168         require(activated_ == true, "Not Active!"); 
169         _;
170     }
171 
172     modifier isHuman() {
173         address _addr = msg.sender;
174         require (_addr == tx.origin);
175         uint256 _codeLength;
176         
177         assembly {_codeLength := extcodesize(_addr)}
178         require(_codeLength == 0, "Not Human");
179         _;
180     }
181 
182     modifier isWithinLimits(uint256 _eth) {
183         require(_eth >= 1000000000, "Too Less");
184         require(_eth <= 100000000000000000000000, "Too More");
185         _;    
186     }
187     
188     // 使用该玩家最近一次购买数据再次购买
189     function()
190         isActivated()
191         isHuman()
192         isWithinLimits(msg.value)
193         public
194         payable
195     {
196         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
197         uint256 _pID = pIDxAddr_[msg.sender];
198         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
199     }
200 
201     function modCEOAddress(address newCEO) 
202         isHuman() 
203         public
204     {
205         require(address(0) != newCEO, "CEO Can not be 0");
206         require(ceo == msg.sender, "only ceo can modify ceo");
207         ceo = newCEO;
208     }
209 
210     function modCFOAddress(address newCFO) 
211         isHuman() 
212         public
213     {
214         require(address(0) != newCFO, "CFO Can not be 0");
215         require(cfo == msg.sender, "only cfo can modify cfo");
216         cfo = newCFO;
217     }
218     
219     // 通过推荐者ID购买
220     function buyXid(uint256 _affCode, uint256 _team)
221         isActivated()
222         isHuman()
223         isWithinLimits(msg.value)
224         public
225         payable
226     {
227         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
228         uint256 _pID = pIDxAddr_[msg.sender];
229         
230         if (_affCode == 0 || _affCode == _pID)
231         {
232             _affCode = plyr_[_pID].laff;    
233         } 
234         else if (_affCode != plyr_[_pID].laff) 
235         {
236             plyr_[_pID].laff = _affCode;
237         }
238 
239         _team = verifyTeam(_team);
240         buyCore(_pID, _affCode, _team, _eventData_);
241     }
242 
243     // 通过推荐者地址购买
244     function buyXaddr(address _affCode, uint256 _team)
245         isActivated()
246         isHuman()
247         isWithinLimits(msg.value)
248         public
249         payable
250     {
251         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
252 
253         uint256 _pID = pIDxAddr_[msg.sender];
254         uint256 _affID;
255         if (_affCode == address(0) || _affCode == msg.sender)
256         {
257             _affID = plyr_[_pID].laff;
258         } 
259         else 
260         {
261             _affID = pIDxAddr_[_affCode];
262             if (_affID != plyr_[_pID].laff)
263             {
264                 plyr_[_pID].laff = _affID;
265             }
266         }
267         
268         _team = verifyTeam(_team);
269         buyCore(_pID, _affID, _team, _eventData_);
270     }
271     // 通过推荐者名字购买
272     function buyXname(bytes32 _affCode, uint256 _team)
273         isActivated()
274         isHuman()
275         isWithinLimits(msg.value)
276         public
277         payable
278     {
279         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
280         
281         uint256 _pID = pIDxAddr_[msg.sender];
282         uint256 _affID;
283         if (_affCode == '' || _affCode == plyr_[_pID].name)
284         {
285             _affID = plyr_[_pID].laff;
286         } 
287         else 
288         {
289             _affID = pIDxName_[_affCode];
290             if (_affID != plyr_[_pID].laff)
291             {
292                 plyr_[_pID].laff = _affID;
293             }
294         }
295         
296         _team = verifyTeam(_team);
297         buyCore(_pID, _affID, _team, _eventData_);
298     }
299     
300     // 通过小金库和推荐者ID购买
301     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
302         isActivated()
303         isHuman()
304         isWithinLimits(_eth)
305         public
306     {
307         F3Ddatasets.EventReturns memory _eventData_;
308         
309         uint256 _pID = pIDxAddr_[msg.sender];
310         if (_affCode == 0 || _affCode == _pID)
311         {
312             _affCode = plyr_[_pID].laff;
313         } 
314         else if (_affCode != plyr_[_pID].laff) 
315         {
316             plyr_[_pID].laff = _affCode;
317         }
318 
319         _team = verifyTeam(_team);
320         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
321     }
322     
323     // 通过小金库和推荐者地址购买
324     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
325         isActivated()
326         isHuman()
327         isWithinLimits(_eth)
328         public
329     {
330         F3Ddatasets.EventReturns memory _eventData_;
331         
332         uint256 _pID = pIDxAddr_[msg.sender];
333         uint256 _affID;
334         if (_affCode == address(0) || _affCode == msg.sender)
335         {
336             _affID = plyr_[_pID].laff;
337         } 
338         else 
339         {
340             _affID = pIDxAddr_[_affCode];
341             if (_affID != plyr_[_pID].laff)
342             {
343                 plyr_[_pID].laff = _affID;
344             }
345         }
346         _team = verifyTeam(_team);
347         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
348     }
349 
350     // 通过小金库和推荐者名字购买
351     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
352         isActivated()
353         isHuman()
354         isWithinLimits(_eth)
355         public
356     {
357         F3Ddatasets.EventReturns memory _eventData_;
358         
359         uint256 _pID = pIDxAddr_[msg.sender];
360         uint256 _affID;
361         if (_affCode == '' || _affCode == plyr_[_pID].name)
362         {
363             _affID = plyr_[_pID].laff;
364         } 
365         else 
366         {
367             _affID = pIDxName_[_affCode];
368             if (_affID != plyr_[_pID].laff)
369             {
370                 plyr_[_pID].laff = _affID;
371             }
372         }
373         
374         _team = verifyTeam(_team);
375         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
376     }
377 
378     // 提取
379     function withdraw()
380         isActivated()
381         isHuman()
382         public
383     {
384         uint256 _rID = rID_;
385         uint256 _now = now;
386         uint256 _pID = pIDxAddr_[msg.sender];
387         uint256 _eth;
388         
389         // 是否触发结束
390         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
391         {
392             F3Ddatasets.EventReturns memory _eventData_;
393         	round_[_rID].ended = true;
394             _eventData_ = endRound(_eventData_);
395             _eth = withdrawEarnings(_pID);
396             if (_eth > 0)
397                 plyr_[_pID].addr.transfer(_eth);    
398         
399             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
400             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
401         
402             emit F3Devents.onWithdrawAndDistribute
403             (
404                 msg.sender, 
405                 plyr_[_pID].name, 
406                 _eth, 
407                 _eventData_.compressedData, 
408                 _eventData_.compressedIDs, 
409                 _eventData_.winnerAddr, 
410                 _eventData_.winnerName, 
411                 _eventData_.amountWon, 
412                 _eventData_.newPot, 
413                 _eventData_.P3DAmount, 
414                 _eventData_.genAmount
415             );
416         } 
417         else 
418         {
419             _eth = withdrawEarnings(_pID);
420             if (_eth > 0)
421                 plyr_[_pID].addr.transfer(_eth);
422             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
423         }
424     }
425     
426     // 通过推荐者ID注册
427     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
428         isHuman()
429         public
430         payable
431     {
432         bytes32 _name = _nameString.nameFilter();
433         address _addr = msg.sender;
434         uint256 _paid = msg.value;
435         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
436         
437         uint256 _pID = pIDxAddr_[_addr];
438         
439         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
440     }
441     
442     // 通过推荐者地址注册
443     function registerNameXaddr(string _nameString, address _affCode, bool _all)
444         isHuman()
445         public
446         payable
447     {
448         bytes32 _name = _nameString.nameFilter();
449         address _addr = msg.sender;
450         uint256 _paid = msg.value;
451         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
452         
453         uint256 _pID = pIDxAddr_[_addr];
454 
455         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
456     }
457 
458     // 通过推荐者名字注册
459     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
460         isHuman()
461         public
462         payable
463     {
464         bytes32 _name = _nameString.nameFilter();
465         address _addr = msg.sender;
466         uint256 _paid = msg.value;
467         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
468         
469         uint256 _pID = pIDxAddr_[_addr];
470 
471         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
472     }
473 
474     // 获取单价
475     function getBuyPrice()
476         public 
477         view 
478         returns(uint256)
479     {  
480         
481         uint256 _rID = rID_;
482         uint256 _now = now;
483         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
484             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
485         else 
486             return ( 7500000000000000 );
487     }
488     
489     // 获得剩余时间（秒）
490     function getTimeLeft()
491         public
492         view
493         returns(uint256)
494     {
495         uint256 _rID = rID_;
496         uint256 _now = now;
497         
498         if (_now < round_[_rID].end)
499             if (_now > round_[_rID].strt + rndGap_)
500                 return( (round_[_rID].end).sub(_now) );
501             else
502                 return( (round_[_rID].strt + rndGap_).sub(_now) );
503         else
504             return(0);
505     }
506     
507     // 查看玩家小金库
508     function getPlayerVaults(uint256 _pID)
509         public
510         view
511         returns(uint256 ,uint256, uint256)
512     {
513         
514         uint256 _rID = rID_;
515         
516         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
517         {
518             if (round_[_rID].plyr == _pID)
519             {
520                 return
521                 (
522                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
523                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
524                     plyr_[_pID].aff
525                 );
526             } else {
527                 return
528                 (
529                     plyr_[_pID].win,
530                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
531                     plyr_[_pID].aff
532                 );
533             }
534         } else {
535             return
536             (
537                 plyr_[_pID].win,
538                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
539                 plyr_[_pID].aff
540             );
541         }
542     }
543     
544     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
545         private
546         view
547         returns(uint256)
548     {
549         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
550     }
551     
552     // 获得当前轮信息
553     function getCurrentRoundInfo()
554         public
555         view
556         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
557     {
558         uint256 _rID = rID_;
559         
560         return
561         (
562             round_[_rID].ico,               //0
563             _rID,                           //1
564             round_[_rID].keys,              //2
565             round_[_rID].end,               //3
566             round_[_rID].strt,              //4
567             round_[_rID].pot,               //5
568             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
569             plyr_[round_[_rID].plyr].addr,  //7
570             plyr_[round_[_rID].plyr].name,  //8
571             rndTmEth_[_rID][0],             //9
572             rndTmEth_[_rID][1],             //10
573             rndTmEth_[_rID][2],             //11
574             rndTmEth_[_rID][3],             //12
575             airDropTracker_ + (airDropPot_ * 1000)              //13
576         );
577     }
578 
579     // 获得玩家信息
580     function getPlayerInfoByAddress(address _addr)
581         public 
582         view 
583         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
584     {
585         
586         uint256 _rID = rID_;
587         if (_addr == address(0))
588         {
589             _addr == msg.sender;
590         }
591         uint256 _pID = pIDxAddr_[_addr];
592         
593         return
594         (
595             _pID,                               //0
596             plyr_[_pID].name,                   //1
597             plyrRnds_[_pID][_rID].keys,         //2
598             plyr_[_pID].win,                    //3
599             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
600             plyr_[_pID].aff,                    //5
601             plyrRnds_[_pID][_rID].eth           //6
602         );
603     }
604 
605     // 核心购买逻辑
606     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
607         private
608     {
609         uint256 _rID = rID_;
610         uint256 _now = now;
611         
612         // 未结束
613         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
614         {
615             core(_rID, _pID, msg.value, _affID, _team, _eventData_);    
616         } 
617         else 
618         {
619             // 已结束但未执行
620             if (_now > round_[_rID].end && round_[_rID].ended == false) 
621             {
622                 round_[_rID].ended = true;
623                 _eventData_ = endRound(_eventData_);
624              
625                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
626                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
627                 
628                 emit F3Devents.onBuyAndDistribute
629                 (
630                     msg.sender, 
631                     plyr_[_pID].name, 
632                     msg.value, 
633                     _eventData_.compressedData, 
634                     _eventData_.compressedIDs, 
635                     _eventData_.winnerAddr, 
636                     _eventData_.winnerName, 
637                     _eventData_.amountWon, 
638                     _eventData_.newPot, 
639                     _eventData_.P3DAmount, 
640                     _eventData_.genAmount
641                 );
642             }
643             
644             // 玩家的钱放入小金库
645             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
646         }
647     }
648     
649     // 使用小金库购买核心逻辑
650     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
651         private
652     {
653         
654         uint256 _rID = rID_;
655         uint256 _now = now;
656         
657         // 未结束
658         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
659         {
660             // 取出玩家小金库
661             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
662             core(_rID, _pID, _eth, _affID, _team, _eventData_);
663         } 
664         // 已结束但未执行
665         else if (_now > round_[_rID].end && round_[_rID].ended == false) 
666         {
667             round_[_rID].ended = true;
668             _eventData_ = endRound(_eventData_);
669             
670             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
671             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
672                 
673             emit F3Devents.onReLoadAndDistribute
674             (
675                 msg.sender, 
676                 plyr_[_pID].name, 
677                 _eventData_.compressedData, 
678                 _eventData_.compressedIDs, 
679                 _eventData_.winnerAddr, 
680                 _eventData_.winnerName, 
681                 _eventData_.amountWon, 
682                 _eventData_.newPot, 
683                 _eventData_.P3DAmount, 
684                 _eventData_.genAmount
685             );
686         }
687     }
688     
689     // 真正的购买在这里
690     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
691         private
692     {
693         if (plyrRnds_[_pID][_rID].keys == 0)
694             _eventData_ = managePlayer(_pID, _eventData_);
695         
696         // 前期购买限制
697         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
698         {
699             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
700             uint256 _refund = _eth.sub(_availableLimit);
701             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
702             _eth = _availableLimit;
703         }
704         
705         // 最少数额
706         if (_eth > 1000000000) 
707         {
708             // 购买的KEY数量
709             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
710             // 至少要有一个KEY才可以领头
711             if (_keys >= 1000000000000000000)
712             {
713                 updateTimer(_keys, _rID);
714                 if (round_[_rID].plyr != _pID)
715                     round_[_rID].plyr = _pID;  
716                 if (round_[_rID].team != _team)
717                     round_[_rID].team = _team; 
718                 _eventData_.compressedData = _eventData_.compressedData + 100;
719             }
720             
721             // 判断空投
722             if (_eth >= 100000000000000000)
723             {
724                 airDropTracker_++;
725                 if (airdrop() == true)
726                 {
727                     uint256 _prize;
728                     if (_eth >= 10000000000000000000)
729                     {
730                         _prize = ((airDropPot_).mul(75)) / 100;
731                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
732                         airDropPot_ = (airDropPot_).sub(_prize);
733                         _eventData_.compressedData += 300000000000000000000000000000000;
734                     } 
735                     else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) 
736                     {
737                         _prize = ((airDropPot_).mul(50)) / 100;
738                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
739                         airDropPot_ = (airDropPot_).sub(_prize);
740                         _eventData_.compressedData += 200000000000000000000000000000000;
741                     } 
742                     else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) 
743                     {
744                         _prize = ((airDropPot_).mul(25)) / 100;
745                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
746                         airDropPot_ = (airDropPot_).sub(_prize);
747                         _eventData_.compressedData += 300000000000000000000000000000000;
748                     }
749                     _eventData_.compressedData += 10000000000000000000000000000000;
750                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
751                     airDropTracker_ = 0;
752                 }
753             }
754     
755             
756             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
757             // 更新数据
758             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
759             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
760             round_[_rID].keys = _keys.add(round_[_rID].keys);
761             round_[_rID].eth = _eth.add(round_[_rID].eth);
762             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
763             // 各种分成，内部和外部
764             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
765             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
766             
767             endTx(_pID, _team, _eth, _keys, _eventData_);
768         }
769     }
770 
771     // 计算未统计的分成
772     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
773         private
774         view
775         returns(uint256)
776     {
777         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
778     }
779     
780     // 给定以太的数量，返回KEY的数量
781     function calcKeysReceived(uint256 _rID, uint256 _eth)
782         public
783         view
784         returns(uint256)
785     {
786         uint256 _now = now;
787         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
788             return ( (round_[_rID].eth).keysRec(_eth) );
789         else
790             return ( (_eth).keys() );
791     }
792     
793     // 计算X个KEY需要多少ETH
794     function iWantXKeys(uint256 _keys)
795         public
796         view
797         returns(uint256)
798     {
799         uint256 _rID = rID_;
800         uint256 _now = now;
801         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
802             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
803         else 
804             return ( (_keys).eth() );
805     }
806 
807     /* test use only
808     function setEndAfterSecond(uint256 extraSecond)
809         isActivated()
810         isHuman()
811         public
812     {
813         require((extraSecond > 0 && extraSecond <= 86400), "TIME Out Of Range");
814         require( ceo == msg.sender, "only ceo can setEnd" );
815         round_[rID_].end = now + extraSecond;
816     }
817     */
818     
819     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
820         external
821     {
822         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
823         if (pIDxAddr_[_addr] != _pID)
824             pIDxAddr_[_addr] = _pID;
825         if (pIDxName_[_name] != _pID)
826             pIDxName_[_name] = _pID;
827         if (plyr_[_pID].addr != _addr)
828             plyr_[_pID].addr = _addr;
829         if (plyr_[_pID].name != _name)
830             plyr_[_pID].name = _name;
831         if (plyr_[_pID].laff != _laff)
832             plyr_[_pID].laff = _laff;
833         if (plyrNames_[_pID][_name] == false)
834             plyrNames_[_pID][_name] = true;
835     }
836     
837     function receivePlayerNameList(uint256 _pID, bytes32 _name)
838         external
839     {
840         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
841         if(plyrNames_[_pID][_name] == false)
842             plyrNames_[_pID][_name] = true;
843     }   
844         
845     // 获取玩家PID
846     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
847         private
848         returns (F3Ddatasets.EventReturns)
849     {
850         uint256 _pID = pIDxAddr_[msg.sender];
851         if (_pID == 0)
852         {
853             _pID = PlayerBook.getPlayerID(msg.sender);
854             bytes32 _name = PlayerBook.getPlayerName(_pID);
855             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
856             
857             pIDxAddr_[msg.sender] = _pID;
858             plyr_[_pID].addr = msg.sender;
859             
860             if (_name != "")
861             {
862                 pIDxName_[_name] = _pID;
863                 plyr_[_pID].name = _name;
864                 plyrNames_[_pID][_name] = true;
865             }
866             
867             if (_laff != 0 && _laff != _pID)
868                 plyr_[_pID].laff = _laff;
869 
870             _eventData_.compressedData = _eventData_.compressedData + 1;
871         } 
872         return (_eventData_);
873     }
874     
875     function verifyTeam(uint256 _team)
876         private
877         pure
878         returns (uint256)
879     {
880         if (_team < 0 || _team > 3)
881             return(2);
882         else
883             return(_team);
884     }
885     
886     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
887         private
888         returns (F3Ddatasets.EventReturns)
889     {
890         // 玩家以前玩家。更新一下小金库
891         if (plyr_[_pID].lrnd != 0)
892             updateGenVault(_pID, plyr_[_pID].lrnd);
893         
894         plyr_[_pID].lrnd = rID_;
895 
896         _eventData_.compressedData = _eventData_.compressedData + 10;
897         
898         return(_eventData_);
899     }
900     
901     // 结束
902     function endRound(F3Ddatasets.EventReturns memory _eventData_)
903         private
904         returns (F3Ddatasets.EventReturns)
905     {
906         
907         uint256 _rID = rID_;
908         
909         uint256 _winPID = round_[_rID].plyr;
910         uint256 _winTID = round_[_rID].team;
911         
912         uint256 _pot = round_[_rID].pot;
913         
914         uint256 _win = (_pot.mul(55)) / 100;
915         uint256 _com = (_pot / 20);
916         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
917         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
918         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
919         
920         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
921         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
922         if (_dust > 0)
923         {
924             _gen = _gen.sub(_dust);
925             _res = _res.add(_dust);
926         }
927         
928         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
929 
930         _com = _com.add(_p3d);
931         cfo.transfer(_com);
932         
933         round_[_rID].mask = _ppt.add(round_[_rID].mask);
934         
935         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
936         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
937         _eventData_.winnerAddr = plyr_[_winPID].addr;
938         _eventData_.winnerName = plyr_[_winPID].name;
939         _eventData_.amountWon = _win;
940         _eventData_.genAmount = _gen;
941         _eventData_.P3DAmount = _p3d;
942         _eventData_.newPot = _res;
943         
944         rID_++;
945         _rID++;
946         round_[_rID].strt = now;
947         round_[_rID].end = now.add(rndInit_).add(rndGap_);
948         round_[_rID].pot = _res;
949         
950         return(_eventData_);
951     }
952     
953     // 更新玩家未统计的分成
954     function updateGenVault(uint256 _pID, uint256 _rIDlast)
955         private 
956     {
957         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
958         if (_earnings > 0)
959         {
960             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
961             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
962         }
963     }
964     
965     // 更新本轮时间
966     function updateTimer(uint256 _keys, uint256 _rID)
967         private
968     {
969         uint256 _now = now;
970         uint256 _newTime;
971         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
972             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
973         else
974             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
975         
976         if (_newTime < (rndMax_).add(_now))
977             round_[_rID].end = _newTime;
978         else
979             round_[_rID].end = rndMax_.add(_now);
980     }
981     
982     // 空投是否触发判断
983     function airdrop()
984         private 
985         view 
986         returns(bool)
987     {
988         uint256 seed = uint256(keccak256(abi.encodePacked(
989             
990             (block.timestamp).add
991             (block.difficulty).add
992             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
993             (block.gaslimit).add
994             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
995             (block.number)
996             
997         )));
998         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
999             return(true);
1000         else
1001             return(false);
1002     }
1003 
1004     
1005     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1006         private
1007         returns(F3Ddatasets.EventReturns)
1008     {
1009         // 5% 开发团队
1010         uint256 _com = _eth / 20;
1011         // 10 推荐人
1012         uint256 _aff = _eth / 10;
1013         // 第一队推荐人分成30%
1014         if (_team == 0 ) {
1015             _aff = _eth.mul(30) / 100;
1016         }
1017         
1018         // MODIFY 如果推荐人不存在 10% -> _com
1019         if (_affID != _pID && plyr_[_affID].name != '') {
1020             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1021             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1022         } else {
1023             _com = _com.add(_aff);
1024         }
1025 
1026         cfo.transfer(_com);
1027         
1028         return(_eventData_);
1029     }
1030 
1031     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1032         private
1033         returns(F3Ddatasets.EventReturns)
1034     {
1035         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1036         
1037         // 5% 到空投
1038         uint256 _air = (_eth / 20);
1039         airDropPot_ = airDropPot_.add(_air);
1040         if (_team == 0){
1041             _eth = _eth.sub(((_eth.mul(40)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1042         }else{
1043             _eth = _eth.sub(((_eth.mul(20)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1044         }
1045         
1046         uint256 _pot = _eth.sub(_gen);
1047         
1048         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1049         if (_dust > 0)
1050             _gen = _gen.sub(_dust);
1051         
1052         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1053         
1054         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1055         _eventData_.potAmount = _pot;
1056         
1057         return(_eventData_);
1058     }
1059 
1060     // 更新玩家已统计的分成
1061     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1062         private
1063         returns(uint256)
1064     {
1065 
1066         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1067         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1068 
1069         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1070         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1071         
1072         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1073     }
1074     
1075 
1076     function withdrawEarnings(uint256 _pID)
1077         private
1078         returns(uint256)
1079     {
1080         updateGenVault(_pID, plyr_[_pID].lrnd);
1081         
1082         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1083         if (_earnings > 0)
1084         {
1085             plyr_[_pID].win = 0;
1086             plyr_[_pID].gen = 0;
1087             plyr_[_pID].aff = 0;
1088         }
1089 
1090         return(_earnings);
1091     }
1092     
1093     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1094         private
1095     {
1096         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1097         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1098         
1099         emit F3Devents.onEndTx
1100         (
1101             _eventData_.compressedData,
1102             _eventData_.compressedIDs,
1103             plyr_[_pID].name,
1104             msg.sender,
1105             _eth,
1106             _keys,
1107             _eventData_.winnerAddr,
1108             _eventData_.winnerName,
1109             _eventData_.amountWon,
1110             _eventData_.newPot,
1111             _eventData_.P3DAmount,
1112             _eventData_.genAmount,
1113             _eventData_.potAmount,
1114             airDropPot_
1115         );
1116     }
1117 
1118     bool public activated_ = false;
1119     function activate()
1120         public
1121     {
1122         require( msg.sender == ceo, "ONLY ceo CAN activate" );
1123         require(activated_ == false, "Already Activated");
1124         
1125         activated_ = true;
1126         
1127         rID_ = 1;
1128         round_[1].strt = now + rndExtra_ - rndGap_;
1129         round_[1].end = now + rndInit_ + rndExtra_;
1130     }
1131     
1132     function disable()
1133         public
1134     {
1135         require( msg.sender == ceo, "ONLY ceo" );
1136         selfdestruct(ceo);
1137     }
1138 }
1139 
1140 library F3Ddatasets {
1141     struct EventReturns {
1142         uint256 compressedData;
1143         uint256 compressedIDs;
1144         address winnerAddr;         // winner address
1145         bytes32 winnerName;         // winner name
1146         uint256 amountWon;          // amount won
1147         uint256 newPot;             // amount in new pot
1148         uint256 P3DAmount;          // amount distributed to p3d
1149         uint256 genAmount;          // amount distributed to gen
1150         uint256 potAmount;          // amount added to pot
1151     }
1152     struct Player {
1153         address addr;   // player address
1154         bytes32 name;   // player name
1155         uint256 win;    // winnings vault
1156         uint256 gen;    // general vault
1157         uint256 aff;    // affiliate vault
1158         uint256 lrnd;   // last round played
1159         uint256 laff;   // last affiliate id used
1160     }
1161     struct PlayerRounds {
1162         uint256 eth;    // eth player has added to round (used for eth limiter)
1163         uint256 keys;   // keys
1164         uint256 mask;   // player mask 
1165         uint256 ico;    // ICO phase investment
1166     }
1167     struct Round {
1168         uint256 plyr;   // pID of player in lead
1169         uint256 team;   // tID of team in lead
1170         uint256 end;    // time ends/ended
1171         bool ended;     // has round end function been ran
1172         uint256 strt;   // time round started
1173         uint256 keys;   // keys
1174         uint256 eth;    // total eth in
1175         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1176         uint256 mask;   // global mask
1177         uint256 ico;    // total eth sent in during ICO phase
1178         uint256 icoGen; // total eth for gen during ICO phase
1179         uint256 icoAvg; // average key price for ICO phase
1180     }
1181     struct TeamFee {
1182         uint256 gen;    // % of buy in thats paid to key holders of current round
1183         uint256 p3d;    // % of buy in thats paid to p3d holders
1184     }
1185     struct PotSplit {
1186         uint256 gen;    // % of pot thats paid to key holders of current round
1187         uint256 p3d;    // % of pot thats paid to p3d holders
1188     }
1189 }
1190 
1191 library F3DKeysCalcLong {
1192     using SafeMath for *;
1193     // 根据ETH计算KEY
1194     function keysRec(uint256 _curEth, uint256 _newEth)
1195         internal
1196         pure
1197         returns (uint256)
1198     {
1199         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1200     }
1201     
1202     // 根据KEY算ETH
1203     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1204         internal
1205         pure
1206         returns (uint256)
1207     {
1208         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1209     }
1210 
1211     // 根据ETH算KEY
1212     function keys(uint256 _eth) 
1213         internal
1214         pure
1215         returns(uint256)
1216     {
1217         return ((((((_eth).mul(1000000000000000000)).mul(31250000000000000000000000000)).add(56249882812561035156250000000000000000000000000000000000000000000000)).sqrt()).sub(7499992187500000000000000000000000)) / (15625000000);
1218     }
1219     
1220     // 根据KEY算ETH
1221     function eth(uint256 _keys) 
1222         internal
1223         pure
1224         returns(uint256)  
1225     {
1226         return ((7812500000).mul(_keys.sq()).add((7499992187500000).mul(_keys.mul(1000000000000000000)))) / ((1000000000000000000).sq()) ;
1227     }
1228 }
1229 
1230 interface PlayerBookInterface {
1231     function getPlayerID(address _addr) external returns (uint256);
1232     function getPlayerName(uint256 _pID) external view returns (bytes32);
1233     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1234     function getPlayerAddr(uint256 _pID) external view returns (address);
1235     function getNameFee() external view returns (uint256);
1236     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1237     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1238     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1239 }
1240 
1241 library NameFilter {
1242     function nameFilter(string _input)
1243         internal
1244         pure
1245         returns(bytes32)
1246     {
1247         bytes memory _temp = bytes(_input);
1248         uint256 _length = _temp.length;
1249         
1250         require (_length <= 32 && _length > 0, "Invalid Length");
1251         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "Can NOT start with SPACE");
1252         if (_temp[0] == 0x30)
1253         {
1254             require(_temp[1] != 0x78, "CAN NOT Start With 0x");
1255             require(_temp[1] != 0x58, "CAN NOT Start With 0X");
1256         }
1257         
1258         bool _hasNonNumber;
1259         
1260         for (uint256 i = 0; i < _length; i++)
1261         {
1262             // 大写转小写
1263             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1264             {
1265                 _temp[i] = byte(uint(_temp[i]) + 32);
1266                 if (_hasNonNumber == false)
1267                     _hasNonNumber = true;
1268             } else {
1269                 require
1270                 (
1271                     _temp[i] == 0x20 || 
1272                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1273                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1274                     "Include Illegal Characters!"
1275                 );
1276                 if (_temp[i] == 0x20)
1277                     require( _temp[i+1] != 0x20, 
1278                     "ONLY One Space Allowed");
1279                 
1280                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1281                     _hasNonNumber = true;    
1282             }
1283         }
1284         
1285         require(_hasNonNumber == true, "All Numbers Not Allowed");
1286         
1287         bytes32 _ret;
1288         assembly {
1289             _ret := mload(add(_temp, 32))
1290         }
1291         return (_ret);
1292     }
1293 }
1294 
1295 library SafeMath {
1296     function mul(uint256 a, uint256 b) 
1297         internal 
1298         pure 
1299         returns (uint256 c) 
1300     {
1301         if (a == 0) {
1302             return 0;
1303         }
1304         c = a * b;
1305         require(c / a == b, "Mul Failed");
1306         return c;
1307     }
1308     function sub(uint256 a, uint256 b)
1309         internal
1310         pure
1311         returns (uint256) 
1312     {
1313         require(b <= a, "Sub Failed");
1314         return a - b;
1315     }
1316 
1317     function add(uint256 a, uint256 b)
1318         internal
1319         pure
1320         returns (uint256 c) 
1321     {
1322         c = a + b;
1323         require(c >= a, "Add Failed");
1324         return c;
1325     }
1326     
1327     function sqrt(uint256 x)
1328         internal
1329         pure
1330         returns (uint256 y) 
1331     {
1332         uint256 z = ((add(x,1)) / 2);
1333         y = x;
1334         while (z < y) 
1335         {
1336             y = z;
1337             z = ((add((x / z),z)) / 2);
1338         }
1339     }
1340     function sq(uint256 x)
1341         internal
1342         pure
1343         returns (uint256)
1344     {
1345         return (mul(x,x));
1346     }
1347 }