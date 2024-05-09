1 pragma solidity ^0.4.24;
2 /*
3 *　　　　　　　　　　　　　　　　　　　　 　 　 ＿＿＿
4 *　　　　　　　　　　　　　　　　　　　　　　　|三三三i
5 *　　　　　　　　　　　　　　　　　　　　　　　|三三三|  
6 *　　神さま　かなえて　happy-end　　　　　　ノ三三三.廴        
7 *　　　　　　　　　　　　　　　　　　　　　　从ﾉ_八ﾑ_}ﾉ
8 *　　　＿＿}ヽ__　　　　　　　　　　 　 　 　 ヽ‐个‐ｱ.     © Team EC Present. 
9 *　　 　｀ﾋｙ　　ﾉ三ﾆ==ｪ- ＿＿＿ ｨｪ=ｧ='ﾌ)ヽ-''Lヽ         
10 *　　　　 ｀‐⌒L三ﾆ=ﾆ三三三三三三三〈oi 人 ）o〉三ﾆ、　　　 
11 *　　　　　　　　　　 　 ｀￣￣￣￣｀弌三三}. !　ｒ三三三iｊ　　　　　　
12 *　　　　　　　　　　 　 　 　 　 　 　,': ::三三|. ! ,'三三三刈、
13 *　　　　　　　　　 　 　 　 　 　 　 ,': : :::｀i三|人|三三ﾊ三j: ;　　　　　
14 *　                  　　　　　　 ,': : : : : 比|　 |三三i |三|: ',
15 *　　　　　　　　　　　　　　　　　,': : : : : : :Vi|　 |三三i |三|: : ',
16 *　　　　　　　　　　　　　　　　, ': : : : : : : ﾉ }乂{三三| |三|: : :;
17 *    BigOne Game v0.1　　  ,': : : : : : : : ::ｊ三三三三|: |三i: : ::,
18 *　　　　　　　　　　　 　 　 ,': : : : : : : : :/三三三三〈: :!三!: : ::;
19 *　　　　　　　　　 　 　 　 ,': : : : : : : : /三三三三三!, |三!: : : ,
20 *　　　　　　　 　 　 　 　 ,': : : : : : : : ::ｊ三三八三三Y {⌒i: : : :,
21 *　　　　　　　　 　 　 　 ,': : : : : : : : : /三//: }三三ｊ: : ー': : : : ,
22 *　　　　　　 　 　 　 　 ,': : : : : : : : :.//三/: : |三三|: : : : : : : : :;
23 *　　　　 　 　 　 　 　 ,': : : : : : : : ://三/: : : |三三|: : : : : : : : ;
24 *　　 　 　 　 　 　 　 ,': : : : : : : : :/三ii/ : : : :|三三|: : : : : : : : :;
25 *　　　 　 　 　 　 　 ,': : : : : : : : /三//: : : : ::!三三!: : : : : : : : ;
26 *　　　　 　 　 　 　 ,': : : : : : : : :ｊ三// : : : : ::|三三!: : : : : : : : :;
27 *　　 　 　 　 　 　 ,': : : : : : : : : |三ij: : : : : : ::ｌ三ﾆ:ｊ: : : : : : : : : ;
28 *　　　 　 　 　 　 ,': : : : : : : : ::::|三ij: : : : : : : !三刈: : : : : : : : : ;
29 *　 　 　 　 　 　 ,': : : : : : : : : : :|三ij: : : : : : ::ｊ三iiﾃ: : : : : : : : : :;
30 *　　 　 　 　 　 ,': : : : : : : : : : : |三ij: : : : : : ::|三iiﾘ: : : : : : : : : : ;
31 *　　　 　 　 　 ,':: : : : : : : : : : : :|三ij::: : :: :: :::|三リ: : : : : : : : : : :;
32 *　　　　　　　 ,': : : : : : : : : : : : :|三ij : : : : : ::ｌ三iﾘ: : : : : : : : : : : ',
33 *           　　　　　　　　　　　　　　   ｒ'三三jiY, : : : : : ::|三ij : : : : : : : : : : : ',
34 *　 　 　 　 　 　      　　                |三 j´　　　　　　　　｀',    signature:
35 *　　　　　　　　　　　　 　 　 　 　 　 　 　  |三三k、
36 *                            　　　　　　　　｀ー≠='.  93511761c3aa73c0a197c55537328f7f797c4429 
37 */
38 contract BigOneEvents {
39     event onNewPlayer
40     (
41         uint256 indexed playerID,
42         address indexed playerAddress,
43         bytes32 indexed playerName,
44         bool isNewPlayer,
45         uint256 affiliateID,
46         address affiliateAddress,
47         bytes32 affiliateName,
48         uint256 amountPaid,
49         uint256 timeStamp
50     );
51 
52     event onEndTx
53     (
54         bytes32 playerName,
55         address playerAddress,
56         uint256 ethIn,
57         uint256 keyCount,
58         uint256 newPot
59     );
60 
61     event onWithdraw
62     (
63         uint256 indexed playerID,
64         address playerAddress,
65         bytes32 playerName,
66         uint256 ethOut,
67         uint256 timeStamp
68     );
69 
70     event onAffiliatePayout
71     (
72         uint256 indexed affiliateID,
73         address affiliateAddress,
74         bytes32 affiliateName,
75         uint256 indexed roundID,
76         uint256 indexed buyerID,
77         uint256 amount,
78         uint256 timeStamp
79     );
80 
81     event onEndRound
82     (
83         uint256 roundID,
84         uint256 roundTypeID,
85         address winnerAddr,
86         bytes32 winnerName,
87         uint256 amountWon
88     );
89 }
90 
91 contract BigOne is BigOneEvents {
92     using SafeMath for *;
93     using NameFilter for string;
94 
95     UserDataManagerInterface constant private UserDataManager = UserDataManagerInterface(0x2E1c02A6Bc5fC77bfc740A505000846545193Beb);
96 
97     //****************
98     // constant
99     //****************
100     address private admin = msg.sender;
101     address private shareCom = 0x2F0839f736197117796967452310F025a330DA45;
102     address private groupCut = 0x9ebfB7a9105124204E4E18BE73B2B1979aDbc713;
103 
104     string constant public name = "bigOne";
105     string constant public symbol = "bigOne";   
106 
107     //****************
108     // var
109     //****************
110     uint256 public rID_;    
111     uint256 public rTypeID_;   
112     //****************
113     // PLAYER DATA
114     //****************
115     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
116     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
117     mapping (uint256 => BigOneData.Player) public plyr_;   // (pID => data) player data
118     mapping (uint256 => mapping (uint256 => BigOneData.PlayerRoundData)) public plyrRnds_;   // (pID => rID => data) 
119 
120     //****************
121     // ROUND DATA
122     //****************
123     mapping (uint256 => BigOneData.RoundSetting) public rSettingXTypeID_;   //(rType => setting)
124     mapping (uint256 => BigOneData.Round) public round_;   // (rID => data) round data
125     mapping (uint256 => uint256) public currentRoundxType_;
126 
127     mapping (uint256 => address[]) private winners_; //(rType => winners_)
128     mapping (uint256 => uint256[]) private winNumbers_; //(rType => winNumbers_)
129 
130     //==============================================================================
131     // init
132     //==============================================================================
133     constructor() public {
134         rID_ = 0;
135         rTypeID_ = 0;
136     }
137 
138     //==============================================================================
139     // checks
140     //==============================================================================
141     modifier isActivated() {
142         require(activated_ == true, "its not ready yet.  check ?eta in discord");
143         _;
144     }
145 
146     modifier isHuman() {
147         address _addr = msg.sender;
148         uint256 _codeLength;
149 
150         assembly {_codeLength := extcodesize(_addr)}
151         require(_codeLength == 0, "sorry humans only");
152         _;
153     }
154 
155     modifier onlyDevs() {
156         require(admin == msg.sender, "msg sender is not a dev");
157         _;
158     }
159 
160     modifier isWithinLimits(uint256 _eth,uint256 _typeID) {
161         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
162         require(_eth >= rSettingXTypeID_[_typeID].perShare, "less than min allow");
163         require(_eth <= rSettingXTypeID_[_typeID].limit, "more than max allow");
164         _;
165     }
166 
167     modifier modeCheck(uint256 _typeID) {
168         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
169         _;
170     }
171 
172     //==============================================================================
173     // admin
174     //==============================================================================
175     bool public activated_ = false;
176     function activate()
177         onlyDevs()
178         public
179     {
180         require(activated_ == false, "BigOne already activated");
181         require(rTypeID_ > 0, "No round mode setup");
182         activated_ = true;
183 
184         for(uint256 i = 0; i < rTypeID_; i++) {
185             rID_++;
186             round_[rID_].start = now;
187             round_[rID_].typeID = i + 1;
188             round_[rID_].count = 1;
189             round_[rID_].pot = 0;
190 
191             currentRoundxType_[i + 1] = rID_;
192         }
193     }
194 
195     function addRoundMode(uint256 _limit, uint256 _perShare, uint256 _shareMax)
196         onlyDevs()
197         public
198     {
199         require(activated_ == false, "BigOne already started");
200 
201         rTypeID_++;
202         rSettingXTypeID_[rTypeID_].limit = _limit;
203         rSettingXTypeID_[rTypeID_].perShare = _perShare;
204         rSettingXTypeID_[rTypeID_].shareMax = _shareMax;
205         rSettingXTypeID_[rTypeID_].isValue = true;
206     }
207 
208     //==============================================================================
209     // public
210     //==============================================================================
211 
212     function()
213         isActivated()
214         isHuman()
215         isWithinLimits(msg.value,1)
216         public
217         payable
218     {
219         determinePID();
220 
221         uint256 _pID = pIDxAddr_[msg.sender];
222 
223         buyCore(_pID, plyr_[_pID].laff,1);
224     }
225 
226     function buyXid(uint256 _affCode, uint256 _mode)
227         isActivated()
228         isHuman()
229         isWithinLimits(msg.value,_mode)
230         public
231         payable
232     {
233         determinePID();
234 
235         uint256 _pID = pIDxAddr_[msg.sender];
236 
237         if (_affCode == 0 || _affCode == _pID)
238         {
239             _affCode = plyr_[_pID].laff;
240 
241         } else if (_affCode != plyr_[_pID].laff) {
242             plyr_[_pID].laff = _affCode;
243         }
244 
245         buyCore(_pID, _affCode, _mode);
246     }
247 
248     function buyXaddr(address _affCode, uint256 _mode)
249         isActivated()
250         isHuman()
251         isWithinLimits(msg.value,_mode)
252         public
253         payable
254     {
255         determinePID();
256 
257         uint256 _pID = pIDxAddr_[msg.sender];
258 
259         uint256 _affID;
260         if (_affCode == address(0) || _affCode == msg.sender)
261         {
262             _affID = plyr_[_pID].laff;
263 
264         } else {
265             _affID = pIDxAddr_[_affCode];
266 
267             if (_affID != plyr_[_pID].laff)
268             {
269                 plyr_[_pID].laff = _affID;
270             }
271         }
272 
273         buyCore(_pID, _affID, _mode);
274     }
275 
276     function buyXname(bytes32 _affCode, uint256 _mode)
277         isActivated()
278         isHuman()
279         isWithinLimits(msg.value,_mode)
280         public
281         payable
282     {
283         determinePID();
284 
285         uint256 _pID = pIDxAddr_[msg.sender];
286 
287         uint256 _affID;
288         if (_affCode == '' || _affCode == plyr_[_pID].name)
289         {
290             _affID = plyr_[_pID].laff;
291 
292         } else {
293             _affID = pIDxName_[_affCode];
294 
295             if (_affID != plyr_[_pID].laff)
296             {
297                 plyr_[_pID].laff = _affID;
298             }
299         }
300 
301         buyCore(_pID, _affID, _mode);
302     }
303 
304     function reLoadXid(uint256 _affCode, uint256 _eth, uint256 _mode)
305         isActivated()
306         isHuman()
307         isWithinLimits(_eth,_mode)
308         public
309     {
310         uint256 _pID = pIDxAddr_[msg.sender];
311 
312         if (_affCode == 0 || _affCode == _pID)
313         {
314             _affCode = plyr_[_pID].laff;
315 
316         } else if (_affCode != plyr_[_pID].laff) {
317             plyr_[_pID].laff = _affCode;
318         }
319 
320         reLoadCore(_pID, _affCode, _eth, _mode);
321     }
322 
323     function reLoadXaddr(address _affCode, uint256 _eth, uint256 _mode)
324         isActivated()
325         isHuman()
326         isWithinLimits(_eth,_mode)
327         public
328     {
329         uint256 _pID = pIDxAddr_[msg.sender];
330 
331         uint256 _affID;
332         if (_affCode == address(0) || _affCode == msg.sender)
333         {
334             _affID = plyr_[_pID].laff;
335         } else {
336             _affID = pIDxAddr_[_affCode];
337 
338             if (_affID != plyr_[_pID].laff)
339             {
340                 plyr_[_pID].laff = _affID;
341             }
342         }
343 
344         reLoadCore(_pID, _affID, _eth, _mode);
345     }
346 
347     function reLoadXname(bytes32 _affCode, uint256 _eth, uint256 _mode)
348         isActivated()
349         isHuman()
350         isWithinLimits(_eth,_mode)
351         public
352     {
353         uint256 _pID = pIDxAddr_[msg.sender];
354 
355         uint256 _affID;
356         if (_affCode == '' || _affCode == plyr_[_pID].name)
357         {
358             _affID = plyr_[_pID].laff;
359         } else {
360             _affID = pIDxName_[_affCode];
361 
362             if (_affID != plyr_[_pID].laff)
363             {
364                 plyr_[_pID].laff = _affID;
365             }
366         }
367         reLoadCore(_pID, _affID, _eth,_mode);
368     }
369 
370     function withdraw()
371         isActivated()
372         isHuman()
373         public
374     {
375         // grab time
376         uint256 _now = now;
377 
378         // fetch player ID
379         uint256 _pID = pIDxAddr_[msg.sender];
380 
381         // setup temp var for player eth
382         uint256 _eth;
383         uint256 _withdrawFee;
384     
385         // get their earnings
386         _eth = withdrawEarnings(_pID);
387 
388         // gib moni
389         if (_eth > 0)
390         {
391             //10% trade tax
392             _withdrawFee = _eth / 10;
393             uint256 _p1 = _withdrawFee / 2;
394             uint256 _p2 = _withdrawFee / 2;
395             shareCom.transfer(_p1);
396             admin.transfer(_p2);
397 
398             plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
399         }
400 
401         // fire withdraw event
402         emit BigOneEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
403     }
404 
405     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
406         isHuman()
407         public
408         payable
409     {
410         bytes32 _name = _nameString.nameFilter();
411         address _addr = msg.sender;
412         uint256 _paid = msg.value;
413         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
414 
415         uint256 _pID = pIDxAddr_[_addr];
416 
417         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
418     }
419 
420     function registerNameXaddr(string _nameString, address _affCode, bool _all)
421         isHuman()
422         public
423         payable
424     {
425         bytes32 _name = _nameString.nameFilter();
426         address _addr = msg.sender;
427         uint256 _paid = msg.value;
428         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
429 
430         uint256 _pID = pIDxAddr_[_addr];
431 
432         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
433     }
434 
435     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
436         isHuman()
437         public
438         payable
439     {
440         bytes32 _name = _nameString.nameFilter();
441         address _addr = msg.sender;
442         uint256 _paid = msg.value;
443         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
444 
445         uint256 _pID = pIDxAddr_[_addr];
446 
447         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
448     }
449 
450 //==============================================================================
451 // query
452 //==============================================================================
453 
454     function iWantXKeys(uint256 _keys,uint256 _mode)
455         modeCheck(_mode)
456         public
457         view
458         returns(uint256)
459     {
460         return _keys.mul(rSettingXTypeID_[_mode].perShare);
461     }
462 
463     function getWinners(uint256 _mode)
464         modeCheck(_mode)
465         public
466         view
467         returns(address[])
468     {
469         return winners_[_mode];
470     }
471 
472     function getWinNumbers(uint256 _mode)
473         modeCheck(_mode)
474         public
475         view
476         returns(uint256[])
477     {
478         return winNumbers_[_mode];
479     }
480 
481     function getPlayerVaults(uint256 _pID)
482         public
483         view
484         //win,gen,aff
485         returns(uint256,uint256,uint256)
486     {
487         return (plyr_[_pID].win,plyr_[_pID].gen,plyr_[_pID].aff);
488     }
489 
490     function getCurrentRoundInfo(uint256 _mode)
491         modeCheck(_mode)
492         public
493         view
494         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32)
495     {
496         uint256 _rID = currentRoundxType_[_mode];
497 
498         return 
499         (
500             _rID,                           //0
501             round_[_rID].count,             //1            
502             round_[_rID].keyCount,          //2
503 
504             round_[_rID].start,              //3
505             round_[_rID].end,               //4
506 
507             round_[_rID].eth,               //5    
508             round_[_rID].pot,               //6
509 
510             plyr_[round_[_rID].plyr].addr,  //7
511             plyr_[round_[_rID].plyr].name   //8
512         );
513     }
514 
515     function getPlayerInfoByAddress(address _addr,uint256 _mode)
516         modeCheck(_mode)
517         public
518         view
519         returns(uint256, bytes32, uint256[], uint256, uint256, uint256, uint256)
520     {
521         uint256 _rID = currentRoundxType_[_mode];
522 
523         if (_addr == address(0))
524         {
525             _addr == msg.sender;
526         }
527         uint256 _pID = pIDxAddr_[_addr];
528 
529         return
530         (
531             _pID,                               //0
532             plyr_[_pID].name,                   //1
533             getPlayerKeys(_pID,_rID),           //2
534             plyr_[_pID].win,                    //3
535             plyr_[_pID].gen,  
536             plyr_[_pID].aff,                    //5
537             plyrRnds_[_pID][_rID].eth           //6
538         );
539     }
540 
541     function getPlayerKeys(uint256 _pID, uint256 _rID)
542         private
543         view
544         returns(uint256[]) 
545     {
546         uint256[] memory _keys = new uint256[](plyrRnds_[_pID][_rID].keyCount);
547         uint256 _keyIndex = 0;
548         for(uint256 i = 0;i < plyrRnds_[_pID][_rID].purchaseIDs.length;i++) {
549             uint256 _pIndex = plyrRnds_[_pID][_rID].purchaseIDs[i];
550             BigOneData.PurchaseRecord memory _pr = round_[_rID].purchases[_pIndex];
551             if(_pr.plyr == _pID) {
552                 for(uint256 j = _pr.start; j <= _pr.end; j++) {
553                     _keys[_keyIndex] = j;
554                     _keyIndex++;
555                 }
556             }
557         }
558         return _keys;
559     }
560 
561     function getPlayerAff(uint256 _pID)
562         public
563         view
564         returns (uint256,uint256,uint256)
565     {
566         uint256 _affID = plyr_[_pID].laffID;
567         if (_affID != 0)
568         {
569             //second level aff
570             uint256 _secondLaff = plyr_[_affID].laffID;
571 
572             if(_secondLaff != 0)
573             {
574                 //third level aff
575                 uint256 _thirdAff = plyr_[_secondLaff].laffID;
576             }
577         }
578         return (_affID,_secondLaff,_thirdAff);
579     }
580 
581 //==============================================================================
582 // private
583 //==============================================================================
584 
585     function buyCore(uint256 _pID, uint256 _affID, uint256 _mode)
586         private
587     {
588         uint256 _rID = currentRoundxType_[_mode];
589 
590         if (round_[_rID].pot < rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0)
591         {
592             core(_rID, _pID, msg.value, _affID,_mode);
593         } else {
594             if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false)
595             {
596                 round_[_rID].ended = true;
597                 endRound(_mode);
598             }
599 
600             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
601         }
602     }
603 
604     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, uint _mode)
605         private
606     {
607         uint256 _rID = currentRoundxType_[_mode];
608 
609         if (round_[_rID].pot < rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0)
610         {
611             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
612 
613             core(_rID, _pID, _eth, _affID,_mode);
614         } else if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false) {
615             round_[_rID].ended = true;
616             endRound(_mode);
617         }
618     }
619 
620     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _mode)
621         private
622     {
623         if (plyrRnds_[_pID][_rID].keyCount == 0) 
624         {
625             managePlayer(_pID,_rID);
626         }
627 
628         if (round_[_rID].keyCount < rSettingXTypeID_[_mode].shareMax)
629         {
630             uint256 _ethAdd = ((rSettingXTypeID_[_mode].shareMax).sub(round_[_rID].keyCount)).mul(rSettingXTypeID_[_mode].perShare);
631             if(_eth > _ethAdd) {
632                 plyr_[_pID].gen = plyr_[_pID].gen.add(_eth.sub(_ethAdd)); 
633             } else {
634                 _ethAdd = _eth;
635             }
636 
637             uint256 _keyAdd = _ethAdd.div(rSettingXTypeID_[_mode].perShare);
638             uint256 _ketEnd = (round_[_rID].keyCount).add(_keyAdd);
639             
640             BigOneData.PurchaseRecord memory _pr;
641             _pr.plyr = _pID;
642             _pr.start = round_[_rID].keyCount;
643             _pr.end = _ketEnd - 1;
644             round_[_rID].purchases.push(_pr);
645             plyrRnds_[_pID][_rID].purchaseIDs.push(round_[_rID].purchases.length - 1);
646             plyrRnds_[_pID][_rID].keyCount += _keyAdd;
647 
648             plyrRnds_[_pID][_rID].eth = _ethAdd.add(plyrRnds_[_pID][_rID].eth);
649             round_[_rID].keyCount = _ketEnd;
650             round_[_rID].eth = _ethAdd.add(round_[_rID].eth);
651             round_[_rID].pot = (round_[_rID].pot).add((_ethAdd.mul(80)).div(100));
652 
653             distributeExternal(_rID, _pID, _ethAdd, _affID);
654 
655             if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false) 
656             {
657                 round_[_rID].ended = true;
658                 endRound(_mode);
659             }
660 
661             emit BigOneEvents.onEndTx
662             (
663                 plyr_[_pID].name,
664                 msg.sender,
665                 _eth,
666                 round_[_rID].keyCount,
667                 round_[_rID].pot
668             );
669 
670         } else {
671             // put back eth in players vault
672             plyr_[_pID].gen = plyr_[_pID].gen.add(_eth);    
673         }
674 
675     }
676 
677 
678 //==============================================================================
679 // util
680 //==============================================================================
681 
682     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
683         external
684     {
685         require (msg.sender == address(UserDataManager), "your not userManager contract");
686         if (pIDxAddr_[_addr] != _pID)
687             pIDxAddr_[_addr] = _pID;
688         if (pIDxName_[_name] != _pID)
689             pIDxName_[_name] = _pID;
690         if (plyr_[_pID].addr != _addr)
691             plyr_[_pID].addr = _addr;
692         if (plyr_[_pID].name != _name)
693             plyr_[_pID].name = _name;
694         if (plyr_[_pID].laff != _laff)
695             plyr_[_pID].laff = _laff;
696     }
697 
698     function determinePID()
699         private
700     {
701         uint256 _pID = pIDxAddr_[msg.sender];
702         if (_pID == 0)
703         {
704             _pID = UserDataManager.getPlayerID(msg.sender);
705             bytes32 _name = UserDataManager.getPlayerName(_pID);
706             uint256 _laff = UserDataManager.getPlayerLaff(_pID);
707 
708             pIDxAddr_[msg.sender] = _pID;
709             plyr_[_pID].addr = msg.sender;
710 
711             if (_name != "")
712             {
713                 pIDxName_[_name] = _pID;
714                 plyr_[_pID].name = _name;
715             }
716 
717             if (_laff != 0 && _laff != _pID) 
718             {
719                 plyr_[_pID].laff = _laff;
720             }
721         }
722     }
723 
724     function withdrawEarnings(uint256 _pID)
725         private
726         returns(uint256)
727     {
728         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
729         if (_earnings > 0)
730         {
731             plyr_[_pID].win = 0;
732             plyr_[_pID].gen = 0;
733             plyr_[_pID].aff = 0;
734         }
735 
736         return(_earnings);
737     }
738 
739     function managePlayer(uint256 _pID,uint256 _rID)
740         private
741     {
742         plyr_[_pID].lrnd = _rID;
743     }
744 
745     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
746         private
747     {
748          // pay community rewards
749         uint256 _com = _eth / 50;
750         uint256 _p3d;
751 
752         if (address(admin).call.value((_com / 2))() == false)
753         {
754             _p3d = _com / 2;
755             _com = _com / 2;
756         }
757 
758         if (address(shareCom).call.value((_com / 2))() == false)
759         {
760             _p3d = _p3d.add(_com / 2);
761             _com = _com.sub(_com / 2);
762         }
763 
764         _p3d = _p3d.add(distributeAff(_rID,_pID,_eth,_affID));
765 
766         if (_p3d > 0)
767         {
768             shareCom.transfer((_p3d / 2));
769             admin.transfer((_p3d / 2));
770         }
771     }
772 
773     function distributeAff(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
774         private
775         returns(uint256)
776     {
777         uint256 _addP3d = 0;
778 
779         // distribute share to affiliate
780         uint256 _aff1 = _eth.div(10);
781         uint256 _aff2 = _eth.div(20);
782         uint256 _aff3 = _eth.div(100).mul(3);
783 
784         groupCut.transfer(_aff1);
785 
786         // decide what to do with affiliate share of fees
787         // affiliate must not be self, and must have a name registered
788         if ((_affID != 0) && (_affID != _pID) && (plyr_[_affID].name != ''))
789         {
790             plyr_[_pID].laffID = _affID;
791             plyr_[_affID].aff = _aff2.add(plyr_[_affID].aff);
792 
793             emit BigOneEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff2, now);
794 
795             //second level aff
796             uint256 _secLaff = plyr_[_affID].laffID;
797             if((_secLaff != 0) && (_secLaff != _pID))
798             {
799                 plyr_[_secLaff].aff = _aff3.add(plyr_[_secLaff].aff);
800                 emit BigOneEvents.onAffiliatePayout(_secLaff, plyr_[_secLaff].addr, plyr_[_secLaff].name, _rID, _pID, _aff3, now);
801             } else {
802                 _addP3d = _addP3d.add(_aff3);
803             }
804         } else {
805             _addP3d = _addP3d.add(_aff2);
806         }
807         return(_addP3d);
808     }
809 
810     function endRound(uint256 _mode)
811         private
812     {
813         uint256 _rID = currentRoundxType_[_mode];
814 
815         // grab our winning player and team id's
816         uint256 _winKey = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))).mod(round_[_rID].keyCount);
817         uint256 _winPID;
818         for(uint256 i = 0;i < round_[_rID].purchases.length; i++) {
819             if(round_[_rID].purchases[i].start <= _winKey && round_[_rID].purchases[i].end >= _winKey) {
820                 _winPID = round_[_rID].purchases[i].plyr;
821                 break;
822             }
823         }
824 
825         if(_winPID != 0) {
826             // pay our winner
827             plyr_[_winPID].win = (round_[_rID].pot).add(plyr_[_winPID].win);
828 
829             winners_[_mode].push(plyr_[_winPID].addr);
830             winNumbers_[_mode].push(_winKey);
831         }
832 
833         round_[_rID].plyr = _winPID;
834         round_[_rID].end = now;
835 
836         emit BigOneEvents.onEndRound
837         (
838             _rID,
839             _mode,
840             plyr_[_winPID].addr,
841             plyr_[_winPID].name,
842             round_[_rID].pot
843         );
844 
845         // start next round
846         rID_++;
847         round_[rID_].start = now;
848         round_[rID_].typeID = _mode;
849         round_[rID_].count = round_[_rID].count + 1;
850         round_[rID_].pot = 0;
851 
852         currentRoundxType_[_mode] = rID_;
853     }
854 
855 }
856 
857 //==============================================================================
858 // interface
859 //==============================================================================
860 
861 interface UserDataManagerInterface {
862     function getPlayerID(address _addr) external returns (uint256);
863     function getPlayerName(uint256 _pID) external view returns (bytes32);
864     function getPlayerLaff(uint256 _pID) external view returns (uint256);
865     function getPlayerAddr(uint256 _pID) external view returns (address);
866     function getNameFee() external view returns (uint256);
867     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
868     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
869     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
870 }
871 
872 //==============================================================================
873 // struct
874 //==============================================================================
875 library BigOneData {
876 
877     struct Player {
878         address addr;   // player address
879         bytes32 name;   // player name
880         uint256 win;    // winnings vault
881         uint256 gen;    // general vault
882         uint256 aff;    // affiliate vault
883         uint256 lrnd;   // last round played
884         uint256 laff;   // last affiliate id used
885         uint256 laffID;   // last affiliate id unaffected
886     }
887     struct PlayerRoundData {
888         uint256 eth;    // eth player has added to round 
889         uint256[] purchaseIDs;   // keys
890         uint256 keyCount;
891     }
892     struct RoundSetting {
893         uint256 limit;   
894         uint256 perShare; 
895         uint256 shareMax;   
896         bool isValue;
897     }
898     struct Round {
899         uint256 plyr;   // pID of player in win
900         uint256 end;    // time ends/ended
901         bool ended;     // has round end function been ran
902         uint256 start;   // time round started
903 
904         uint256 keyCount;   // keys
905         BigOneData.PurchaseRecord[] purchases;  
906         uint256 eth;    // total eth in
907         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
908 
909         uint256 typeID;
910         uint256 count;
911     }
912     struct PurchaseRecord {
913         uint256 plyr;   
914         uint256 start;
915         uint256 end;
916     }
917 
918 }
919 
920 
921 library NameFilter {
922 
923     function nameFilter(string _input)
924         internal
925         pure
926         returns(bytes32)
927     {
928         bytes memory _temp = bytes(_input);
929         uint256 _length = _temp.length;
930 
931         //sorry limited to 32 characters
932         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
933         // make sure it doesnt start with or end with space
934         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
935         // make sure first two characters are not 0x
936         if (_temp[0] == 0x30)
937         {
938             require(_temp[1] != 0x78, "string cannot start with 0x");
939             require(_temp[1] != 0x58, "string cannot start with 0X");
940         }
941 
942         // create a bool to track if we have a non number character
943         bool _hasNonNumber;
944 
945         // convert & check
946         for (uint256 i = 0; i < _length; i++)
947         {
948             // if its uppercase A-Z
949             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
950             {
951                 // convert to lower case a-z
952                 _temp[i] = byte(uint(_temp[i]) + 32);
953 
954                 // we have a non number
955                 if (_hasNonNumber == false)
956                     _hasNonNumber = true;
957             } else {
958                 require
959                 (
960                     // require character is a space
961                     _temp[i] == 0x20 ||
962                     // OR lowercase a-z
963                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
964                     // or 0-9
965                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
966                     "string contains invalid characters"
967                 );
968                 // make sure theres not 2x spaces in a row
969                 if (_temp[i] == 0x20)
970                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
971 
972                 // see if we have a character other than a number
973                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
974                     _hasNonNumber = true;
975             }
976         }
977 
978         require(_hasNonNumber == true, "string cannot be only numbers");
979 
980         bytes32 _ret;
981         assembly {
982             _ret := mload(add(_temp, 32))
983         }
984         return (_ret);
985     }
986 }
987 
988 
989 library SafeMath 
990 {
991     /**
992     * @dev Multiplies two numbers, reverts on overflow.
993     */
994     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
995         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
996         // benefit is lost if 'b' is also tested.
997         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
998         if (_a == 0) {
999             return 0;
1000         }
1001 
1002         uint256 c = _a * _b;
1003         require(c / _a == _b);
1004 
1005         return c;
1006     }
1007 
1008     /**
1009     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1010     */
1011     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1012         require(_b > 0); // Solidity only automatically asserts when dividing by 0
1013         uint256 c = _a / _b;
1014         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1015 
1016         return c;
1017     }
1018 
1019     /**
1020     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1021     */
1022     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1023         require(_b <= _a);
1024         uint256 c = _a - _b;
1025 
1026         return c;
1027     }
1028 
1029     /**
1030     * @dev Adds two numbers, reverts on overflow.
1031     */
1032     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1033         uint256 c = _a + _b;
1034         require(c >= _a);
1035 
1036         return c;
1037     }
1038 
1039     /**
1040     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1041     * reverts when dividing by zero.
1042     */
1043     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1044         require(b != 0);
1045         return a % b;
1046     }
1047 }