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
109 contract FoMo3Dlong is modularLong {
110     using SafeMath for *;
111     using NameFilter for string;
112     using F3DKeysCalcLong for uint256;
113     PlayerBookInterface constant private PlayerBook = PlayerBookInterface(0xa6fd21aa986247357f404aa37a7bc90809da1ad8);
114 
115 
116     address public ceo;
117     address public cfo; 
118     string constant public name = "Must Be Hit 4D";
119     string constant public symbol = "MBT4D";
120     uint256 private rndExtra_ = 30 seconds;       
121     uint256 private rndGap_ = 30 seconds;         
122     uint256 constant private rndInit_ = 1 hours;                // 初始时间
123     uint256 constant private rndInc_ = 30 seconds;              // 每一个完整KEY增加
124     uint256 constant private rndMax_ = 12 hours;                // 最多允许增加到
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
174         uint256 _codeLength;
175         
176         assembly {_codeLength := extcodesize(_addr)}
177         require(_codeLength == 0, "Not Human");
178         _;
179     }
180 
181     modifier isWithinLimits(uint256 _eth) {
182         require(_eth >= 1000000000, "Too Less");
183         require(_eth <= 100000000000000000000000, "Too More");
184         _;    
185     }
186     
187     // 使用该玩家最近一次购买数据再次购买
188     function()
189         isActivated()
190         isHuman()
191         isWithinLimits(msg.value)
192         public
193         payable
194     {
195         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
196         uint256 _pID = pIDxAddr_[msg.sender];
197         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
198     }
199 
200     function modCEOAddress(address newCEO) 
201         isHuman() 
202         public
203     {
204         require(address(0) != newCEO, "CEO Can not be 0");
205         require(ceo == msg.sender, "only ceo can modify ceo");
206         ceo = newCEO;
207     }
208 
209     function modCFOAddress(address newCFO) 
210         isHuman() 
211         public
212     {
213         require(address(0) != newCFO, "CFO Can not be 0");
214         require(cfo == msg.sender, "only cfo can modify cfo");
215         cfo = newCFO;
216     }
217     
218     // 通过推荐者ID购买
219     function buyXid(uint256 _affCode, uint256 _team)
220         isActivated()
221         isHuman()
222         isWithinLimits(msg.value)
223         public
224         payable
225     {
226         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
227         uint256 _pID = pIDxAddr_[msg.sender];
228         
229         if (_affCode == 0 || _affCode == _pID)
230         {
231             _affCode = plyr_[_pID].laff;    
232         } 
233         else if (_affCode != plyr_[_pID].laff) 
234         {
235             plyr_[_pID].laff = _affCode;
236         }
237 
238         _team = verifyTeam(_team);
239         buyCore(_pID, _affCode, _team, _eventData_);
240     }
241 
242     // 通过推荐者地址购买
243     function buyXaddr(address _affCode, uint256 _team)
244         isActivated()
245         isHuman()
246         isWithinLimits(msg.value)
247         public
248         payable
249     {
250         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
251 
252         uint256 _pID = pIDxAddr_[msg.sender];
253         uint256 _affID;
254         if (_affCode == address(0) || _affCode == msg.sender)
255         {
256             _affID = plyr_[_pID].laff;
257         } 
258         else 
259         {
260             _affID = pIDxAddr_[_affCode];
261             if (_affID != plyr_[_pID].laff)
262             {
263                 plyr_[_pID].laff = _affID;
264             }
265         }
266         
267         _team = verifyTeam(_team);
268         buyCore(_pID, _affID, _team, _eventData_);
269     }
270     // 通过推荐者名字购买
271     function buyXname(bytes32 _affCode, uint256 _team)
272         isActivated()
273         isHuman()
274         isWithinLimits(msg.value)
275         public
276         payable
277     {
278         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
279         
280         uint256 _pID = pIDxAddr_[msg.sender];
281         uint256 _affID;
282         if (_affCode == '' || _affCode == plyr_[_pID].name)
283         {
284             _affID = plyr_[_pID].laff;
285         } 
286         else 
287         {
288             _affID = pIDxName_[_affCode];
289             if (_affID != plyr_[_pID].laff)
290             {
291                 plyr_[_pID].laff = _affID;
292             }
293         }
294         
295         _team = verifyTeam(_team);
296         buyCore(_pID, _affID, _team, _eventData_);
297     }
298     
299     // 通过小金库和推荐者ID购买
300     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
301         isActivated()
302         isHuman()
303         isWithinLimits(_eth)
304         public
305     {
306         F3Ddatasets.EventReturns memory _eventData_;
307         
308         uint256 _pID = pIDxAddr_[msg.sender];
309         if (_affCode == 0 || _affCode == _pID)
310         {
311             _affCode = plyr_[_pID].laff;
312         } 
313         else if (_affCode != plyr_[_pID].laff) 
314         {
315             plyr_[_pID].laff = _affCode;
316         }
317 
318         _team = verifyTeam(_team);
319         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
320     }
321     
322     // 通过小金库和推荐者地址购买
323     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
324         isActivated()
325         isHuman()
326         isWithinLimits(_eth)
327         public
328     {
329         F3Ddatasets.EventReturns memory _eventData_;
330         
331         uint256 _pID = pIDxAddr_[msg.sender];
332         uint256 _affID;
333         if (_affCode == address(0) || _affCode == msg.sender)
334         {
335             _affID = plyr_[_pID].laff;
336         } 
337         else 
338         {
339             _affID = pIDxAddr_[_affCode];
340             if (_affID != plyr_[_pID].laff)
341             {
342                 plyr_[_pID].laff = _affID;
343             }
344         }
345         _team = verifyTeam(_team);
346         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
347     }
348 
349     // 通过小金库和推荐者名字购买
350     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
351         isActivated()
352         isHuman()
353         isWithinLimits(_eth)
354         public
355     {
356         F3Ddatasets.EventReturns memory _eventData_;
357         
358         uint256 _pID = pIDxAddr_[msg.sender];
359         uint256 _affID;
360         if (_affCode == '' || _affCode == plyr_[_pID].name)
361         {
362             _affID = plyr_[_pID].laff;
363         } 
364         else 
365         {
366             _affID = pIDxName_[_affCode];
367             if (_affID != plyr_[_pID].laff)
368             {
369                 plyr_[_pID].laff = _affID;
370             }
371         }
372         
373         _team = verifyTeam(_team);
374         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
375     }
376 
377     // 提取
378     function withdraw()
379         isActivated()
380         isHuman()
381         public
382     {
383         uint256 _rID = rID_;
384         uint256 _now = now;
385         uint256 _pID = pIDxAddr_[msg.sender];
386         uint256 _eth;
387         
388         // 是否触发结束
389         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
390         {
391             F3Ddatasets.EventReturns memory _eventData_;
392         	round_[_rID].ended = true;
393             _eventData_ = endRound(_eventData_);
394             _eth = withdrawEarnings(_pID);
395             if (_eth > 0)
396                 plyr_[_pID].addr.transfer(_eth);    
397         
398             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
399             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
400         
401             emit F3Devents.onWithdrawAndDistribute
402             (
403                 msg.sender, 
404                 plyr_[_pID].name, 
405                 _eth, 
406                 _eventData_.compressedData, 
407                 _eventData_.compressedIDs, 
408                 _eventData_.winnerAddr, 
409                 _eventData_.winnerName, 
410                 _eventData_.amountWon, 
411                 _eventData_.newPot, 
412                 _eventData_.P3DAmount, 
413                 _eventData_.genAmount
414             );
415         } 
416         else 
417         {
418             _eth = withdrawEarnings(_pID);
419             if (_eth > 0)
420                 plyr_[_pID].addr.transfer(_eth);
421             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
422         }
423     }
424     
425     // 通过推荐者ID注册
426     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
427         isHuman()
428         public
429         payable
430     {
431         bytes32 _name = _nameString.nameFilter();
432         address _addr = msg.sender;
433         uint256 _paid = msg.value;
434         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
435         
436         uint256 _pID = pIDxAddr_[_addr];
437         
438         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
439     }
440     
441     // 通过推荐者地址注册
442     function registerNameXaddr(string _nameString, address _affCode, bool _all)
443         isHuman()
444         public
445         payable
446     {
447         bytes32 _name = _nameString.nameFilter();
448         address _addr = msg.sender;
449         uint256 _paid = msg.value;
450         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
451         
452         uint256 _pID = pIDxAddr_[_addr];
453 
454         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
455     }
456 
457     // 通过推荐者名字注册
458     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
459         isHuman()
460         public
461         payable
462     {
463         bytes32 _name = _nameString.nameFilter();
464         address _addr = msg.sender;
465         uint256 _paid = msg.value;
466         (bool _isNewPlayer, uint256 _affID) = PlayerBook.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
467         
468         uint256 _pID = pIDxAddr_[_addr];
469 
470         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
471     }
472 
473     // 获取单价
474     function getBuyPrice()
475         public 
476         view 
477         returns(uint256)
478     {  
479         
480         uint256 _rID = rID_;
481         uint256 _now = now;
482         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
483             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
484         else 
485             return ( 7500000000000000 );
486     }
487     
488     // 获得剩余时间（秒）
489     function getTimeLeft()
490         public
491         view
492         returns(uint256)
493     {
494         uint256 _rID = rID_;
495         uint256 _now = now;
496         
497         if (_now < round_[_rID].end)
498             if (_now > round_[_rID].strt + rndGap_)
499                 return( (round_[_rID].end).sub(_now) );
500             else
501                 return( (round_[_rID].strt + rndGap_).sub(_now) );
502         else
503             return(0);
504     }
505     
506     // 查看玩家小金库
507     function getPlayerVaults(uint256 _pID)
508         public
509         view
510         returns(uint256 ,uint256, uint256)
511     {
512         
513         uint256 _rID = rID_;
514         
515         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
516         {
517             if (round_[_rID].plyr == _pID)
518             {
519                 return
520                 (
521                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
522                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
523                     plyr_[_pID].aff
524                 );
525             } else {
526                 return
527                 (
528                     plyr_[_pID].win,
529                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
530                     plyr_[_pID].aff
531                 );
532             }
533         } else {
534             return
535             (
536                 plyr_[_pID].win,
537                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
538                 plyr_[_pID].aff
539             );
540         }
541     }
542     
543     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
544         private
545         view
546         returns(uint256)
547     {
548         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
549     }
550     
551     // 获得当前轮信息
552     function getCurrentRoundInfo()
553         public
554         view
555         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
556     {
557         uint256 _rID = rID_;
558         
559         return
560         (
561             round_[_rID].ico,               //0
562             _rID,                           //1
563             round_[_rID].keys,              //2
564             round_[_rID].end,               //3
565             round_[_rID].strt,              //4
566             round_[_rID].pot,               //5
567             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
568             plyr_[round_[_rID].plyr].addr,  //7
569             plyr_[round_[_rID].plyr].name,  //8
570             rndTmEth_[_rID][0],             //9
571             rndTmEth_[_rID][1],             //10
572             rndTmEth_[_rID][2],             //11
573             rndTmEth_[_rID][3],             //12
574             airDropTracker_ + (airDropPot_ * 1000)              //13
575         );
576     }
577 
578     // 获得玩家信息
579     function getPlayerInfoByAddress(address _addr)
580         public 
581         view 
582         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
583     {
584         
585         uint256 _rID = rID_;
586         if (_addr == address(0))
587         {
588             _addr == msg.sender;
589         }
590         uint256 _pID = pIDxAddr_[_addr];
591         
592         return
593         (
594             _pID,                               //0
595             plyr_[_pID].name,                   //1
596             plyrRnds_[_pID][_rID].keys,         //2
597             plyr_[_pID].win,                    //3
598             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
599             plyr_[_pID].aff,                    //5
600             plyrRnds_[_pID][_rID].eth           //6
601         );
602     }
603 
604     // 核心购买逻辑
605     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
606         private
607     {
608         uint256 _rID = rID_;
609         uint256 _now = now;
610         
611         // 未结束
612         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
613         {
614             core(_rID, _pID, msg.value, _affID, _team, _eventData_);    
615         } 
616         else 
617         {
618             // 已结束但未执行
619             if (_now > round_[_rID].end && round_[_rID].ended == false) 
620             {
621                 round_[_rID].ended = true;
622                 _eventData_ = endRound(_eventData_);
623              
624                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
625                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
626                 
627                 emit F3Devents.onBuyAndDistribute
628                 (
629                     msg.sender, 
630                     plyr_[_pID].name, 
631                     msg.value, 
632                     _eventData_.compressedData, 
633                     _eventData_.compressedIDs, 
634                     _eventData_.winnerAddr, 
635                     _eventData_.winnerName, 
636                     _eventData_.amountWon, 
637                     _eventData_.newPot, 
638                     _eventData_.P3DAmount, 
639                     _eventData_.genAmount
640                 );
641             }
642             
643             // 玩家的钱放入小金库
644             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
645         }
646     }
647     
648     // 使用小金库购买核心逻辑
649     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
650         private
651     {
652         
653         uint256 _rID = rID_;
654         uint256 _now = now;
655         
656         // 未结束
657         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
658         {
659             // 取出玩家小金库
660             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
661             core(_rID, _pID, _eth, _affID, _team, _eventData_);
662         } 
663         // 已结束但未执行
664         else if (_now > round_[_rID].end && round_[_rID].ended == false) 
665         {
666             round_[_rID].ended = true;
667             _eventData_ = endRound(_eventData_);
668             
669             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
670             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
671                 
672             emit F3Devents.onReLoadAndDistribute
673             (
674                 msg.sender, 
675                 plyr_[_pID].name, 
676                 _eventData_.compressedData, 
677                 _eventData_.compressedIDs, 
678                 _eventData_.winnerAddr, 
679                 _eventData_.winnerName, 
680                 _eventData_.amountWon, 
681                 _eventData_.newPot, 
682                 _eventData_.P3DAmount, 
683                 _eventData_.genAmount
684             );
685         }
686     }
687     
688     // 真正的购买在这里
689     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
690         private
691     {
692         if (plyrRnds_[_pID][_rID].keys == 0)
693             _eventData_ = managePlayer(_pID, _eventData_);
694         
695         // 前期购买限制
696         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
697         {
698             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
699             uint256 _refund = _eth.sub(_availableLimit);
700             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
701             _eth = _availableLimit;
702         }
703         
704         // 最少数额
705         if (_eth > 1000000000) 
706         {
707             // 购买的KEY数量
708             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
709             // 至少要有一个KEY才可以领头
710             if (_keys >= 1000000000000000000)
711             {
712                 updateTimer(_keys, _rID);
713                 if (round_[_rID].plyr != _pID)
714                     round_[_rID].plyr = _pID;  
715                 if (round_[_rID].team != _team)
716                     round_[_rID].team = _team; 
717                 _eventData_.compressedData = _eventData_.compressedData + 100;
718             }
719             
720             // 判断空投
721             if (_eth >= 100000000000000000)
722             {
723                 airDropTracker_++;
724                 if (airdrop() == true)
725                 {
726                     uint256 _prize;
727                     if (_eth >= 10000000000000000000)
728                     {
729                         _prize = ((airDropPot_).mul(75)) / 100;
730                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
731                         airDropPot_ = (airDropPot_).sub(_prize);
732                         _eventData_.compressedData += 300000000000000000000000000000000;
733                     } 
734                     else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) 
735                     {
736                         _prize = ((airDropPot_).mul(50)) / 100;
737                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
738                         airDropPot_ = (airDropPot_).sub(_prize);
739                         _eventData_.compressedData += 200000000000000000000000000000000;
740                     } 
741                     else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) 
742                     {
743                         _prize = ((airDropPot_).mul(25)) / 100;
744                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
745                         airDropPot_ = (airDropPot_).sub(_prize);
746                         _eventData_.compressedData += 300000000000000000000000000000000;
747                     }
748                     _eventData_.compressedData += 10000000000000000000000000000000;
749                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
750                     airDropTracker_ = 0;
751                 }
752             }
753     
754             
755             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
756             // 更新数据
757             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
758             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
759             round_[_rID].keys = _keys.add(round_[_rID].keys);
760             round_[_rID].eth = _eth.add(round_[_rID].eth);
761             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
762             // 各种分成，内部和外部
763             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
764             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
765             
766             endTx(_pID, _team, _eth, _keys, _eventData_);
767         }
768     }
769 
770     // 计算未统计的分成
771     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
772         private
773         view
774         returns(uint256)
775     {
776         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
777     }
778     
779     // 给定以太的数量，返回KEY的数量
780     function calcKeysReceived(uint256 _rID, uint256 _eth)
781         public
782         view
783         returns(uint256)
784     {
785         uint256 _now = now;
786         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
787             return ( (round_[_rID].eth).keysRec(_eth) );
788         else
789             return ( (_eth).keys() );
790     }
791     
792     // 计算X个KEY需要多少ETH
793     function iWantXKeys(uint256 _keys)
794         public
795         view
796         returns(uint256)
797     {
798         uint256 _rID = rID_;
799         uint256 _now = now;
800         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
801             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
802         else 
803             return ( (_keys).eth() );
804     }
805 
806     /* test use only
807     function setEndAfterSecond(uint256 extraSecond)
808         isActivated()
809         isHuman()
810         public
811     {
812         require((extraSecond > 0 && extraSecond <= 86400), "TIME Out Of Range");
813         require( ceo == msg.sender, "only ceo can setEnd" );
814         round_[rID_].end = now + extraSecond;
815     }
816     */
817     
818     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
819         external
820     {
821         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
822         if (pIDxAddr_[_addr] != _pID)
823             pIDxAddr_[_addr] = _pID;
824         if (pIDxName_[_name] != _pID)
825             pIDxName_[_name] = _pID;
826         if (plyr_[_pID].addr != _addr)
827             plyr_[_pID].addr = _addr;
828         if (plyr_[_pID].name != _name)
829             plyr_[_pID].name = _name;
830         if (plyr_[_pID].laff != _laff)
831             plyr_[_pID].laff = _laff;
832         if (plyrNames_[_pID][_name] == false)
833             plyrNames_[_pID][_name] = true;
834     }
835     
836     function receivePlayerNameList(uint256 _pID, bytes32 _name)
837         external
838     {
839         require (msg.sender == address(PlayerBook), "your not playerNames contract... hmmm..");
840         if(plyrNames_[_pID][_name] == false)
841             plyrNames_[_pID][_name] = true;
842     }   
843         
844     // 获取玩家PID
845     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
846         private
847         returns (F3Ddatasets.EventReturns)
848     {
849         uint256 _pID = pIDxAddr_[msg.sender];
850         if (_pID == 0)
851         {
852             _pID = PlayerBook.getPlayerID(msg.sender);
853             bytes32 _name = PlayerBook.getPlayerName(_pID);
854             uint256 _laff = PlayerBook.getPlayerLAff(_pID);
855             
856             pIDxAddr_[msg.sender] = _pID;
857             plyr_[_pID].addr = msg.sender;
858             
859             if (_name != "")
860             {
861                 pIDxName_[_name] = _pID;
862                 plyr_[_pID].name = _name;
863                 plyrNames_[_pID][_name] = true;
864             }
865             
866             if (_laff != 0 && _laff != _pID)
867                 plyr_[_pID].laff = _laff;
868 
869             _eventData_.compressedData = _eventData_.compressedData + 1;
870         } 
871         return (_eventData_);
872     }
873     
874     function verifyTeam(uint256 _team)
875         private
876         pure
877         returns (uint256)
878     {
879         if (_team < 0 || _team > 3)
880             return(2);
881         else
882             return(_team);
883     }
884     
885     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
886         private
887         returns (F3Ddatasets.EventReturns)
888     {
889         // 玩家以前玩家。更新一下小金库
890         if (plyr_[_pID].lrnd != 0)
891             updateGenVault(_pID, plyr_[_pID].lrnd);
892         
893         plyr_[_pID].lrnd = rID_;
894 
895         _eventData_.compressedData = _eventData_.compressedData + 10;
896         
897         return(_eventData_);
898     }
899     
900     // 结束
901     function endRound(F3Ddatasets.EventReturns memory _eventData_)
902         private
903         returns (F3Ddatasets.EventReturns)
904     {
905         
906         uint256 _rID = rID_;
907         
908         uint256 _winPID = round_[_rID].plyr;
909         uint256 _winTID = round_[_rID].team;
910         
911         uint256 _pot = round_[_rID].pot;
912         
913         uint256 _win = (_pot.mul(55)) / 100;
914         uint256 _com = (_pot / 20);
915         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
916         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
917         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
918         
919         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
920         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
921         if (_dust > 0)
922         {
923             _gen = _gen.sub(_dust);
924             _res = _res.add(_dust);
925         }
926         
927         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
928 
929         _com = _com.add(_p3d);
930         cfo.transfer(_com);
931         
932         round_[_rID].mask = _ppt.add(round_[_rID].mask);
933         
934         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
935         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
936         _eventData_.winnerAddr = plyr_[_winPID].addr;
937         _eventData_.winnerName = plyr_[_winPID].name;
938         _eventData_.amountWon = _win;
939         _eventData_.genAmount = _gen;
940         _eventData_.P3DAmount = _p3d;
941         _eventData_.newPot = _res;
942         
943         rID_++;
944         _rID++;
945         round_[_rID].strt = now;
946         round_[_rID].end = now.add(rndInit_).add(rndGap_);
947         round_[_rID].pot = _res;
948         
949         return(_eventData_);
950     }
951     
952     // 更新玩家未统计的分成
953     function updateGenVault(uint256 _pID, uint256 _rIDlast)
954         private 
955     {
956         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
957         if (_earnings > 0)
958         {
959             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
960             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
961         }
962     }
963     
964     // 更新本轮时间
965     function updateTimer(uint256 _keys, uint256 _rID)
966         private
967     {
968         uint256 _now = now;
969         uint256 _newTime;
970         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
971             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
972         else
973             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
974         
975         if (_newTime < (rndMax_).add(_now))
976             round_[_rID].end = _newTime;
977         else
978             round_[_rID].end = rndMax_.add(_now);
979     }
980     
981     // 空投是否触发判断
982     function airdrop()
983         private 
984         view 
985         returns(bool)
986     {
987         uint256 seed = uint256(keccak256(abi.encodePacked(
988             
989             (block.timestamp).add
990             (block.difficulty).add
991             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
992             (block.gaslimit).add
993             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
994             (block.number)
995             
996         )));
997         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
998             return(true);
999         else
1000             return(false);
1001     }
1002 
1003     
1004     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1005         private
1006         returns(F3Ddatasets.EventReturns)
1007     {
1008         // 5% 开发团队
1009         uint256 _com = _eth / 20;
1010         // 10 推荐人
1011         uint256 _aff = _eth / 10;
1012         // 第一队推荐人分成30%
1013         if (_team == 0 ) {
1014             _aff = _eth.mul(30) / 100;
1015         }
1016         
1017         // MODIFY 如果推荐人不存在 10% -> _com
1018         if (_affID != _pID && plyr_[_affID].name != '') {
1019             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1020             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1021         } else {
1022             _com = _com.add(_aff);
1023         }
1024 
1025         cfo.transfer(_com);
1026         
1027         return(_eventData_);
1028     }
1029 
1030     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1031         private
1032         returns(F3Ddatasets.EventReturns)
1033     {
1034         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1035         
1036         // 5% 到空投
1037         uint256 _air = (_eth / 20);
1038         airDropPot_ = airDropPot_.add(_air);
1039         if (_team == 0){
1040             _eth = _eth.sub(((_eth.mul(40)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1041         }else{
1042             _eth = _eth.sub(((_eth.mul(20)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1043         }
1044         
1045         uint256 _pot = _eth.sub(_gen);
1046         
1047         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1048         if (_dust > 0)
1049             _gen = _gen.sub(_dust);
1050         
1051         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1052         
1053         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1054         _eventData_.potAmount = _pot;
1055         
1056         return(_eventData_);
1057     }
1058 
1059     // 更新玩家已统计的分成
1060     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1061         private
1062         returns(uint256)
1063     {
1064 
1065         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1066         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1067 
1068         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1069         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1070         
1071         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1072     }
1073     
1074 
1075     function withdrawEarnings(uint256 _pID)
1076         private
1077         returns(uint256)
1078     {
1079         updateGenVault(_pID, plyr_[_pID].lrnd);
1080         
1081         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1082         if (_earnings > 0)
1083         {
1084             plyr_[_pID].win = 0;
1085             plyr_[_pID].gen = 0;
1086             plyr_[_pID].aff = 0;
1087         }
1088 
1089         return(_earnings);
1090     }
1091     
1092     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1093         private
1094     {
1095         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1096         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1097         
1098         emit F3Devents.onEndTx
1099         (
1100             _eventData_.compressedData,
1101             _eventData_.compressedIDs,
1102             plyr_[_pID].name,
1103             msg.sender,
1104             _eth,
1105             _keys,
1106             _eventData_.winnerAddr,
1107             _eventData_.winnerName,
1108             _eventData_.amountWon,
1109             _eventData_.newPot,
1110             _eventData_.P3DAmount,
1111             _eventData_.genAmount,
1112             _eventData_.potAmount,
1113             airDropPot_
1114         );
1115     }
1116 
1117     bool public activated_ = false;
1118     function activate()
1119         public
1120     {
1121         require( msg.sender == ceo, "ONLY ceo CAN activate" );
1122         require(activated_ == false, "Already Activated");
1123         
1124         activated_ = true;
1125         
1126         rID_ = 1;
1127         round_[1].strt = now + rndExtra_ - rndGap_;
1128         round_[1].end = now + rndInit_ + rndExtra_;
1129     }
1130 }
1131 
1132 library F3Ddatasets {
1133     struct EventReturns {
1134         uint256 compressedData;
1135         uint256 compressedIDs;
1136         address winnerAddr;         // winner address
1137         bytes32 winnerName;         // winner name
1138         uint256 amountWon;          // amount won
1139         uint256 newPot;             // amount in new pot
1140         uint256 P3DAmount;          // amount distributed to p3d
1141         uint256 genAmount;          // amount distributed to gen
1142         uint256 potAmount;          // amount added to pot
1143     }
1144     struct Player {
1145         address addr;   // player address
1146         bytes32 name;   // player name
1147         uint256 win;    // winnings vault
1148         uint256 gen;    // general vault
1149         uint256 aff;    // affiliate vault
1150         uint256 lrnd;   // last round played
1151         uint256 laff;   // last affiliate id used
1152     }
1153     struct PlayerRounds {
1154         uint256 eth;    // eth player has added to round (used for eth limiter)
1155         uint256 keys;   // keys
1156         uint256 mask;   // player mask 
1157         uint256 ico;    // ICO phase investment
1158     }
1159     struct Round {
1160         uint256 plyr;   // pID of player in lead
1161         uint256 team;   // tID of team in lead
1162         uint256 end;    // time ends/ended
1163         bool ended;     // has round end function been ran
1164         uint256 strt;   // time round started
1165         uint256 keys;   // keys
1166         uint256 eth;    // total eth in
1167         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
1168         uint256 mask;   // global mask
1169         uint256 ico;    // total eth sent in during ICO phase
1170         uint256 icoGen; // total eth for gen during ICO phase
1171         uint256 icoAvg; // average key price for ICO phase
1172     }
1173     struct TeamFee {
1174         uint256 gen;    // % of buy in thats paid to key holders of current round
1175         uint256 p3d;    // % of buy in thats paid to p3d holders
1176     }
1177     struct PotSplit {
1178         uint256 gen;    // % of pot thats paid to key holders of current round
1179         uint256 p3d;    // % of pot thats paid to p3d holders
1180     }
1181 }
1182 
1183 library F3DKeysCalcLong {
1184     using SafeMath for *;
1185     // 根据ETH计算KEY
1186     function keysRec(uint256 _curEth, uint256 _newEth)
1187         internal
1188         pure
1189         returns (uint256)
1190     {
1191         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1192     }
1193     
1194     // 根据KEY算ETH
1195     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1196         internal
1197         pure
1198         returns (uint256)
1199     {
1200         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1201     }
1202 
1203     // 根据ETH算KEY
1204     function keys(uint256 _eth) 
1205         internal
1206         pure
1207         returns(uint256)
1208     {
1209         return ((((((_eth).mul(1000000000000000000)).mul(31250000000000000000000000000)).add(56249882812561035156250000000000000000000000000000000000000000000000)).sqrt()).sub(7499992187500000000000000000000000)) / (15625000000);
1210     }
1211     
1212     // 根据KEY算ETH
1213     function eth(uint256 _keys) 
1214         internal
1215         pure
1216         returns(uint256)  
1217     {
1218         return ((7812500000).mul(_keys.sq()).add((7499992187500000).mul(_keys.mul(1000000000000000000)))) / ((1000000000000000000).sq()) ;
1219     }
1220 }
1221 
1222 interface PlayerBookInterface {
1223     function getPlayerID(address _addr) external returns (uint256);
1224     function getPlayerName(uint256 _pID) external view returns (bytes32);
1225     function getPlayerLAff(uint256 _pID) external view returns (uint256);
1226     function getPlayerAddr(uint256 _pID) external view returns (address);
1227     function getNameFee() external view returns (uint256);
1228     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1229     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1230     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1231 }
1232 
1233 library NameFilter {
1234     function nameFilter(string _input)
1235         internal
1236         pure
1237         returns(bytes32)
1238     {
1239         bytes memory _temp = bytes(_input);
1240         uint256 _length = _temp.length;
1241         
1242         require (_length <= 32 && _length > 0, "Invalid Length");
1243         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "Can NOT start with SPACE");
1244         if (_temp[0] == 0x30)
1245         {
1246             require(_temp[1] != 0x78, "CAN NOT Start With 0x");
1247             require(_temp[1] != 0x58, "CAN NOT Start With 0X");
1248         }
1249         
1250         bool _hasNonNumber;
1251         
1252         for (uint256 i = 0; i < _length; i++)
1253         {
1254             // 大写转小写
1255             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
1256             {
1257                 _temp[i] = byte(uint(_temp[i]) + 32);
1258                 if (_hasNonNumber == false)
1259                     _hasNonNumber = true;
1260             } else {
1261                 require
1262                 (
1263                     _temp[i] == 0x20 || 
1264                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
1265                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
1266                     "Include Illegal Characters!"
1267                 );
1268                 if (_temp[i] == 0x20)
1269                     require( _temp[i+1] != 0x20, 
1270                     "ONLY One Space Allowed");
1271                 
1272                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1273                     _hasNonNumber = true;    
1274             }
1275         }
1276         
1277         require(_hasNonNumber == true, "All Numbers Not Allowed");
1278         
1279         bytes32 _ret;
1280         assembly {
1281             _ret := mload(add(_temp, 32))
1282         }
1283         return (_ret);
1284     }
1285 }
1286 
1287 library SafeMath {
1288     function mul(uint256 a, uint256 b) 
1289         internal 
1290         pure 
1291         returns (uint256 c) 
1292     {
1293         if (a == 0) {
1294             return 0;
1295         }
1296         c = a * b;
1297         require(c / a == b, "Mul Failed");
1298         return c;
1299     }
1300     function sub(uint256 a, uint256 b)
1301         internal
1302         pure
1303         returns (uint256) 
1304     {
1305         require(b <= a, "Sub Failed");
1306         return a - b;
1307     }
1308 
1309     function add(uint256 a, uint256 b)
1310         internal
1311         pure
1312         returns (uint256 c) 
1313     {
1314         c = a + b;
1315         require(c >= a, "Add Failed");
1316         return c;
1317     }
1318     
1319     function sqrt(uint256 x)
1320         internal
1321         pure
1322         returns (uint256 y) 
1323     {
1324         uint256 z = ((add(x,1)) / 2);
1325         y = x;
1326         while (z < y) 
1327         {
1328             y = z;
1329             z = ((add((x / z),z)) / 2);
1330         }
1331     }
1332     function sq(uint256 x)
1333         internal
1334         pure
1335         returns (uint256)
1336     {
1337         return (mul(x,x));
1338     }
1339 }