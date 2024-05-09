1 pragma solidity ^0.4.24;
2 
3 /*
4 *　　　　　　　　　　　　　　　　　　　　 　 　 ＿＿＿
5 *　　　　　　　　　　　　　　　　　　　　　　　|三三三i
6 *　　　　　　　　　　　　　　　　　　　　　　　|三三三|  
7 *　　神さま　かなえて　happy-end　　　　　　ノ三三三.廴        
8 *　　　　　　　　　　　　　　　　　　　　　　从ﾉ_八ﾑ_}ﾉ
9 *　　　＿＿}ヽ__　　　　　　　　　　 　 　 　 ヽ‐个‐ｱ.     © Team EC Present. 
10 *　　 　｀ﾋｙ　　ﾉ三ﾆ==ｪ- ＿＿＿ ｨｪ=ｧ='ﾌ)ヽ-''Lヽ         
11 *　　　　 ｀‐⌒L三ﾆ=ﾆ三三三三三三三〈oi 人 ）o〉三ﾆ、　　　 
12 *　　　　　　　　　　 　 ｀￣￣￣￣｀弌三三}. !　ｒ三三三iｊ　　　　　　
13 *　　　　　　　　　　 　 　 　 　 　 　,': ::三三|. ! ,'三三三刈、
14 *　　　　　　　　　 　 　 　 　 　 　 ,': : :::｀i三|人|三三ﾊ三j: ;　　　　　
15 *　                  　　　　　　 ,': : : : : 比|　 |三三i |三|: ',
16 *　　　　　　　　　　　　　　　　　,': : : : : : :Vi|　 |三三i |三|: : ',
17 *　　　　　　　　　　　　　　　　, ': : : : : : : ﾉ }乂{三三| |三|: : :;
18 *    BigOne Game v1.0　　  ,': : : : : : : : ::ｊ三三三三|: |三i: : ::,
19 *　　　　　　　　　　　 　 　 ,': : : : : : : : :/三三三三〈: :!三!: : ::;
20 *　　　　　　　　　 　 　 　 ,': : : : : : : : /三三三三三!, |三!: : : ,
21 *　　　　　　　 　 　 　 　 ,': : : : : : : : ::ｊ三三八三三Y {⌒i: : : :,
22 *　　　　　　　　 　 　 　 ,': : : : : : : : : /三//: }三三ｊ: : ー': : : : ,
23 *　　　　　　 　 　 　 　 ,': : : : : : : : :.//三/: : |三三|: : : : : : : : :;
24 *　　　　 　 　 　 　 　 ,': : : : : : : : ://三/: : : |三三|: : : : : : : : ;
25 *　　 　 　 　 　 　 　 ,': : : : : : : : :/三ii/ : : : :|三三|: : : : : : : : :;
26 *　　　 　 　 　 　 　 ,': : : : : : : : /三//: : : : ::!三三!: : : : : : : : ;
27 *　　　　 　 　 　 　 ,': : : : : : : : :ｊ三// : : : : ::|三三!: : : : : : : : :;
28 *　　 　 　 　 　 　 ,': : : : : : : : : |三ij: : : : : : ::ｌ三ﾆ:ｊ: : : : : : : : : ;
29 *　　　 　 　 　 　 ,': : : : : : : : ::::|三ij: : : : : : : !三刈: : : : : : : : : ;
30 *　 　 　 　 　 　 ,': : : : : : : : : : :|三ij: : : : : : ::ｊ三iiﾃ: : : : : : : : : :;
31 *　　 　 　 　 　 ,': : : : : : : : : : : |三ij: : : : : : ::|三iiﾘ: : : : : : : : : : ;
32 *　　　 　 　 　 ,':: : : : : : : : : : : :|三ij::: : :: :: :::|三リ: : : : : : : : : : :;
33 *　　　　　　　 ,': : : : : : : : : : : : :|三ij : : : : : ::ｌ三iﾘ: : : : : : : : : : : ',
34 *           　　　　　　　　　　　　　　   ｒ'三三jiY, : : : : : ::|三ij : : : : : : : : : : : ',
35 *　 　 　 　 　 　      　　                |三 j´　　　　　　　　｀',    signature:
36 *　　　　　　　　　　　　 　 　 　 　 　 　 　  |三三k、
37 *                            　　　　　　　　｀ー≠='.  93511761c3aa73c0a197c55537328f7f797c4429 
38 */
39 
40 
41 contract BigOneEvents {
42     event onNewPlayer
43     (
44         uint256 indexed playerID,
45         address indexed playerAddress,
46         bytes32 indexed playerName,
47         bool isNewPlayer,
48         uint256 affiliateID,
49         address affiliateAddress,
50         bytes32 affiliateName,
51         uint256 amountPaid,
52         uint256 timeStamp
53     );
54 
55     event onEndTx
56     (
57         uint256 indexed playerID,
58         address indexed playerAddress,
59         uint256 roundID,
60         uint256 ethIn,
61         uint256 pot
62     );
63 
64     event onWithdraw
65     (
66         uint256 indexed playerID,
67         address playerAddress,
68         bytes32 playerName,
69         uint256 ethOut,
70         uint256 timeStamp
71     );
72 
73     event onAffiliatePayout
74     (
75         uint256 indexed affiliateID,
76         address affiliateAddress,
77         // bytes32 affiliateName,
78         uint256 indexed roundID,
79         uint256 indexed buyerID,
80         uint256 amount,
81         uint256 timeStamp
82     );
83 
84     event onEndRound
85     (
86         uint256 roundID,
87         uint256 roundTypeID,
88         address winnerAddr,
89         uint256 winnerNum,
90         uint256 amountWon
91     );
92 }
93 
94 contract BigOne is BigOneEvents {
95     using SafeMath for *;
96     using NameFilter for string;
97 
98     UserDataManagerInterface constant private UserDataManager = UserDataManagerInterface(0x5576250692275701eFdE5EEb51596e2D9460790b);
99 
100     //****************
101     // constant
102     //****************
103     address private admin = msg.sender;
104     address private shareCom1 = 0xdcd90eA01E441654C9e8e8fcfBF407781d196287;
105     address private shareCom2 = 0xaF63842fb4A9B3769E0e1b7DAb9C5068dB78d3d3;
106 
107     string constant public name = "bigOne";
108     string constant public symbol = "bigOne";   
109 
110     //****************
111     // var
112     //****************
113     uint256 public rID_;    
114     uint256 public rTypeID_;
115 
116     //****************
117     // PLAYER DATA
118     //****************
119     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
120     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
121     mapping (uint256 => BigOneData.Player) public plyr_;   // (pID => data) player data
122     mapping (uint256 => mapping (uint256 => BigOneData.PlayerRoundData)) public plyrRnds_;   // (pID => rID => data) 
123     mapping (uint256 => uint256) private playerSecret_;
124 
125     //****************
126     // ROUND DATA
127     //****************
128     mapping (uint256 => BigOneData.RoundSetting) public rSettingXTypeID_;   //(rType => setting)
129     mapping (uint256 => BigOneData.Round) public round_;   // (rID => data) round data
130     mapping (uint256 => uint256) public currentRoundxType_;
131     mapping (uint256 => uint256) private roundCommonSecret_;
132 
133     //==============================================================================
134     // init
135     //==============================================================================
136     constructor() public {
137         rID_ = 0;
138         rTypeID_ = 0;
139     }
140 
141     //==============================================================================
142     // checks
143     //==============================================================================
144     modifier isActivated() {
145         require(activated_ == true, "its not ready yet.  check ?eta in discord");
146         _;
147     }
148 
149     modifier isHuman() {
150         address _addr = msg.sender;
151         uint256 _codeLength;
152 
153         assembly {_codeLength := extcodesize(_addr)}
154         require(_codeLength == 0, "sorry humans only");
155         _;
156     }
157 
158     modifier onlyDevs() {
159         require(admin == msg.sender, "msg sender is not a dev");
160         _;
161     }
162 
163     modifier isWithinLimits(uint256 _eth,uint256 _typeID) {
164         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
165         require(_eth >= rSettingXTypeID_[_typeID].perShare, "less than min allow");
166         require(_eth <= rSettingXTypeID_[_typeID].limit, "more than max allow");
167         _;
168     }
169 
170     modifier modeCheck(uint256 _typeID) {
171         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
172         _;
173     }
174 
175     //==============================================================================
176     // admin
177     //==============================================================================
178     bool public activated_ = false;
179     function activate(uint256 _initSecret)
180         onlyDevs()
181         public
182     {
183         require(activated_ == false, "BigOne already activated");
184         require(rTypeID_ > 0, "No round mode setup");
185         activated_ = true;
186 
187         for(uint256 i = 0; i < rTypeID_; i++) {
188             rID_++;
189             round_[rID_].start = now;
190             round_[rID_].typeID = i + 1;
191             round_[rID_].count = 1;
192             round_[rID_].pot = 0;
193             generateRndSecret(rID_,_initSecret);
194             currentRoundxType_[i + 1] = rID_;
195         }
196     }
197 
198     function addRoundMode(uint256 _limit, uint256 _perShare, uint256 _shareMax)
199         onlyDevs()
200         public
201     {
202         require(activated_ == false, "BigOne already started");
203 
204         rTypeID_++;
205         rSettingXTypeID_[rTypeID_].id = rTypeID_;
206         rSettingXTypeID_[rTypeID_].limit = _limit;
207         rSettingXTypeID_[rTypeID_].perShare = _perShare;
208         rSettingXTypeID_[rTypeID_].shareMax = _shareMax;
209         rSettingXTypeID_[rTypeID_].isValue = true;
210     }
211 
212     //==============================================================================
213     // public
214     //==============================================================================
215 
216     function()
217         isActivated()
218         isHuman()
219         isWithinLimits(msg.value,1)
220         public
221         payable
222     {
223         determinePID();
224 
225         uint256 _pID = pIDxAddr_[msg.sender];
226 
227         buyCore(_pID, plyr_[_pID].laff,1);
228     }
229 
230     function buyXid(uint256 _affCode, uint256 _mode)
231         isActivated()
232         isHuman()
233         isWithinLimits(msg.value,_mode)
234         public
235         payable
236     {
237         determinePID();
238 
239         uint256 _pID = pIDxAddr_[msg.sender];
240 
241         if (_affCode == 0 || _affCode == _pID)
242         {
243             _affCode = plyr_[_pID].laff;
244 
245         } else if (_affCode != plyr_[_pID].laff) {
246             plyr_[_pID].laff = _affCode;
247         }
248 
249         buyCore(_pID, _affCode, _mode);
250     }
251 
252     function buyXaddr(address _affCode, uint256 _mode)
253         isActivated()
254         isHuman()
255         isWithinLimits(msg.value,_mode)
256         public
257         payable
258     {
259         determinePID();
260 
261         uint256 _pID = pIDxAddr_[msg.sender];
262 
263         uint256 _affID;
264         if (_affCode == address(0) || _affCode == msg.sender)
265         {
266             _affID = plyr_[_pID].laff;
267 
268         } else {
269             _affID = pIDxAddr_[_affCode];
270 
271             if (_affID != plyr_[_pID].laff)
272             {
273                 plyr_[_pID].laff = _affID;
274             }
275         }
276 
277         buyCore(_pID, _affID, _mode);
278     }
279 
280     function buyXname(bytes32 _affCode, uint256 _mode)
281         isActivated()
282         isHuman()
283         isWithinLimits(msg.value,_mode)
284         public
285         payable
286     {
287         determinePID();
288 
289         uint256 _pID = pIDxAddr_[msg.sender];
290 
291         uint256 _affID;
292         if (_affCode == '' || _affCode == plyr_[_pID].name)
293         {
294             _affID = plyr_[_pID].laff;
295 
296         } else {
297             _affID = pIDxName_[_affCode];
298 
299             if (_affID != plyr_[_pID].laff)
300             {
301                 plyr_[_pID].laff = _affID;
302             }
303         }
304 
305         buyCore(_pID, _affID, _mode);
306     }
307 
308     function reLoadXid(uint256 _affCode, uint256 _eth, uint256 _mode)
309         isActivated()
310         isHuman()
311         isWithinLimits(_eth,_mode)
312         public
313     {
314         uint256 _pID = pIDxAddr_[msg.sender];
315 
316         if (_affCode == 0 || _affCode == _pID)
317         {
318             _affCode = plyr_[_pID].laff;
319 
320         } else if (_affCode != plyr_[_pID].laff) {
321             plyr_[_pID].laff = _affCode;
322         }
323 
324         reLoadCore(_pID, _affCode, _eth, _mode);
325     }
326 
327     function reLoadXaddr(address _affCode, uint256 _eth, uint256 _mode)
328         isActivated()
329         isHuman()
330         isWithinLimits(_eth,_mode)
331         public
332     {
333         uint256 _pID = pIDxAddr_[msg.sender];
334 
335         uint256 _affID;
336         if (_affCode == address(0) || _affCode == msg.sender)
337         {
338             _affID = plyr_[_pID].laff;
339         } else {
340             _affID = pIDxAddr_[_affCode];
341 
342             if (_affID != plyr_[_pID].laff)
343             {
344                 plyr_[_pID].laff = _affID;
345             }
346         }
347 
348         reLoadCore(_pID, _affID, _eth, _mode);
349     }
350 
351     function reLoadXname(bytes32 _affCode, uint256 _eth, uint256 _mode)
352         isActivated()
353         isHuman()
354         isWithinLimits(_eth,_mode)
355         public
356     {
357         uint256 _pID = pIDxAddr_[msg.sender];
358 
359         uint256 _affID;
360         if (_affCode == '' || _affCode == plyr_[_pID].name)
361         {
362             _affID = plyr_[_pID].laff;
363         } else {
364             _affID = pIDxName_[_affCode];
365 
366             if (_affID != plyr_[_pID].laff)
367             {
368                 plyr_[_pID].laff = _affID;
369             }
370         }
371         reLoadCore(_pID, _affID, _eth,_mode);
372     }
373 
374     function withdraw()
375         isActivated()
376         isHuman()
377         public
378     {
379         // grab time
380         uint256 _now = now;
381 
382         // fetch player ID
383         uint256 _pID = pIDxAddr_[msg.sender];
384 
385         // setup temp var for player eth
386         uint256 _eth;
387         uint256 _withdrawFee;
388     
389         // get their earnings
390         _eth = withdrawEarnings(_pID);
391 
392         // gib moni
393         if (_eth > 0)
394         {
395             //10% trade tax
396             _withdrawFee = _eth.div(10);
397 
398             shareCom1.transfer((_withdrawFee.div(2)));
399             shareCom2.transfer((_withdrawFee.div(10)));
400             admin.transfer((_withdrawFee.div(10).mul(4)));
401 
402             plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
403         }
404 
405         // fire withdraw event
406         emit BigOneEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
407     }
408 
409     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
410         isHuman()
411         public
412         payable
413     {
414         bytes32 _name = _nameString.nameFilter();
415         address _addr = msg.sender;
416         uint256 _paid = msg.value;
417         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXIDFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
418 
419         uint256 _pID = pIDxAddr_[_addr];
420         if(_isNewPlayer) generatePlayerSecret(_pID);
421         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
422     }
423 
424     function registerNameXaddr(string _nameString, address _affCode, bool _all)
425         isHuman()
426         public
427         payable
428     {
429         bytes32 _name = _nameString.nameFilter();
430         address _addr = msg.sender;
431         uint256 _paid = msg.value;
432         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
433 
434         uint256 _pID = pIDxAddr_[_addr];
435         if(_isNewPlayer) generatePlayerSecret(_pID);
436         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
437     }
438 
439     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
440         isHuman()
441         public
442         payable
443     {
444         bytes32 _name = _nameString.nameFilter();
445         address _addr = msg.sender;
446         uint256 _paid = msg.value;
447         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
448 
449         uint256 _pID = pIDxAddr_[_addr];
450         if(_isNewPlayer) generatePlayerSecret(_pID);
451         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
452     }
453 
454 //==============================================================================
455 // query
456 //==============================================================================
457 
458     function iWantXKeys(uint256 _keys,uint256 _mode)
459         modeCheck(_mode)
460         public
461         view
462         returns(uint256)
463     {
464         return _keys.mul(rSettingXTypeID_[_mode].perShare);
465     }
466 
467     function getPlayerVaults(uint256 _pID)
468         public
469         view
470         //win,gen,aff
471         returns(uint256[])
472     {
473         uint256[] memory _vaults = new uint256[](3);
474         _vaults[0] = plyr_[_pID].win;
475         _vaults[1] = plyr_[_pID].gen;
476         _vaults[2] = plyr_[_pID].aff;
477 
478         return _vaults;
479     }
480 
481     function getCurrentRoundInfo(uint256 _mode)
482         modeCheck(_mode)
483         public
484         view
485         returns(uint256[])
486     {
487         uint256 _rID = currentRoundxType_[_mode];
488 
489         uint256[] memory _roundInfos = new uint256[](6);
490         _roundInfos[0] = _mode;
491         _roundInfos[1] = _rID;
492         _roundInfos[2] = round_[_rID].count;
493         _roundInfos[3] = round_[_rID].keyCount;
494         _roundInfos[4] = round_[_rID].eth;
495         _roundInfos[5] = round_[_rID].pot;
496 
497         return _roundInfos;
498     }
499 
500     function getPlayerInfoByAddress(address _addr,uint256 _mode)
501         modeCheck(_mode)
502         public
503         view
504         returns(uint256, uint256, bytes32)
505     {
506         uint256 _rID = currentRoundxType_[_mode];
507 
508         if (_addr == address(0))
509         {
510             _addr == msg.sender;
511         }
512         uint256 _pID = pIDxAddr_[_addr];
513 
514         return
515         (
516             _pID,                               //0
517             plyrRnds_[_pID][_rID].eth,          //1
518             plyr_[_pID].name                   //2
519         );
520     }
521 
522     function getPlayerKeys(address _addr,uint256 _mode)
523         public
524         view
525         returns(uint256[]) 
526     {
527         uint256 _rID = currentRoundxType_[_mode];
528 
529         if (_addr == address(0))
530         {
531             _addr == msg.sender;
532         }
533         uint256 _pID = pIDxAddr_[_addr];
534 
535         uint256[] memory _keys = new uint256[](plyrRnds_[_pID][_rID].keyCount);
536         uint256 _keyIndex = 0;
537         for(uint256 i = 0;i < plyrRnds_[_pID][_rID].purchaseIDs.length;i++) {
538             uint256 _pIndex = plyrRnds_[_pID][_rID].purchaseIDs[i];
539             BigOneData.PurchaseRecord memory _pr = round_[_rID].purchases[_pIndex];
540             if(_pr.plyr == _pID) {
541                 for(uint256 j = _pr.start; j <= _pr.end; j++) {
542                     _keys[_keyIndex] = j;
543                     _keyIndex++;
544                 }
545             }
546         }
547         return _keys;
548     }
549 
550     function getPlayerAff(uint256 _pID)
551         public
552         view
553         returns (uint256[])
554     {
555         uint256[] memory _affs = new uint256[](3);
556 
557         _affs[0] = plyr_[_pID].laffID;
558         if (_affs[0] != 0)
559         {
560             //second level aff
561             _affs[1] = plyr_[_affs[0]].laffID;
562 
563             if(_affs[1] != 0)
564             {
565                 //third level aff
566                 _affs[2] = plyr_[_affs[1]].laffID;
567             }
568         }
569         return _affs;
570     }
571 
572 //==============================================================================
573 // private
574 //==============================================================================
575 
576     function buyCore(uint256 _pID, uint256 _affID, uint256 _mode)
577         private
578     {
579         uint256 _rID = currentRoundxType_[_mode];
580 
581         if (round_[_rID].keyCount < rSettingXTypeID_[_mode].shareMax && round_[_rID].plyr == 0)
582         {
583             core(_rID, _pID, msg.value, _affID,_mode);
584         } else {
585             if (round_[_rID].keyCount >= rSettingXTypeID_[_mode].shareMax && round_[_rID].plyr == 0 && round_[_rID].ended == false)
586             {
587                 round_[_rID].ended = true;
588                 endRound(_mode); 
589             }
590             //directly refund player
591             plyr_[_pID].addr.transfer(msg.value);
592         }
593     }
594 
595     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, uint _mode)
596         private
597     {
598         uint256 _rID = currentRoundxType_[_mode];
599 
600         if (round_[_rID].keyCount < rSettingXTypeID_[_mode].shareMax && round_[_rID].plyr == 0)
601         {
602             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
603             core(_rID, _pID, _eth, _affID,_mode);
604         } else {
605             if (round_[_rID].keyCount >= rSettingXTypeID_[_mode].shareMax && round_[_rID].plyr == 0 && round_[_rID].ended == false) 
606             {
607                 round_[_rID].ended = true;
608                 endRound(_mode);      
609             }
610         }
611     }
612 
613     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _mode)
614         private
615     {
616         if (plyrRnds_[_pID][_rID].keyCount == 0) 
617         {
618             managePlayer(_pID,_rID);
619         }
620 
621         if (round_[_rID].keyCount < rSettingXTypeID_[_mode].shareMax)
622         {
623             uint256 _ethAdd = ((rSettingXTypeID_[_mode].shareMax).sub(round_[_rID].keyCount)).mul(rSettingXTypeID_[_mode].perShare);
624             if(_eth > _ethAdd) {
625                 plyr_[_pID].gen = plyr_[_pID].gen.add(_eth.sub(_ethAdd)); 
626             } else {
627                 _ethAdd = _eth;
628             }
629 
630             uint256 _keyAdd = _ethAdd.div(rSettingXTypeID_[_mode].perShare);
631             uint256 _keyEnd = (round_[_rID].keyCount).add(_keyAdd);
632             
633             BigOneData.PurchaseRecord memory _pr;
634             _pr.plyr = _pID;
635             _pr.start = round_[_rID].keyCount;
636             _pr.end = _keyEnd - 1;
637             round_[_rID].purchases.push(_pr);
638             plyrRnds_[_pID][_rID].purchaseIDs.push(round_[_rID].purchases.length - 1);
639             plyrRnds_[_pID][_rID].keyCount += _keyAdd;
640 
641             plyrRnds_[_pID][_rID].eth = _ethAdd.add(plyrRnds_[_pID][_rID].eth);
642             round_[_rID].keyCount = _keyEnd;
643             round_[_rID].eth = _ethAdd.add(round_[_rID].eth);
644             round_[_rID].pot = (round_[_rID].pot).add(_ethAdd.mul(95).div(100));
645 
646             distributeExternal(_rID, _pID, _ethAdd, _affID);
647 
648             if (round_[_rID].keyCount >= rSettingXTypeID_[_mode].shareMax && round_[_rID].plyr == 0 && round_[_rID].ended == false) 
649             {
650                 round_[_rID].ended = true;
651                 endRound(_mode); 
652             }
653 
654             emit BigOneEvents.onEndTx
655             (
656                _pID,
657                 msg.sender,
658                 _rID,
659                 _ethAdd,
660                 round_[_rID].pot
661             );
662 
663         } else {
664             // put back eth in players vault
665             plyr_[_pID].gen = plyr_[_pID].gen.add(_eth);    
666         }
667 
668     }
669 
670 
671 //==============================================================================
672 // util
673 //==============================================================================
674 
675     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
676         external
677     {
678         require (msg.sender == address(UserDataManager), "your not userManager contract");
679         if (pIDxAddr_[_addr] != _pID)
680             pIDxAddr_[_addr] = _pID;
681         if (pIDxName_[_name] != _pID)
682             pIDxName_[_name] = _pID;
683         if (plyr_[_pID].addr != _addr)
684             plyr_[_pID].addr = _addr;
685         if (plyr_[_pID].name != _name)
686             plyr_[_pID].name = _name;
687         if (plyr_[_pID].laff != _laff)
688             plyr_[_pID].laff = _laff;
689     }
690 
691     function determinePID()
692         private
693     {
694         uint256 _pID = pIDxAddr_[msg.sender];
695         if (_pID == 0)
696         {
697             _pID = UserDataManager.getPlayerID(msg.sender);
698             bytes32 _name = UserDataManager.getPlayerName(_pID);
699             uint256 _laff = UserDataManager.getPlayerLaff(_pID);
700 
701             pIDxAddr_[msg.sender] = _pID;
702             plyr_[_pID].addr = msg.sender;
703 
704             if (_name != "")
705             {
706                 pIDxName_[_name] = _pID;
707                 plyr_[_pID].name = _name;
708             }
709 
710             if (_laff != 0 && _laff != _pID) 
711             {
712                 plyr_[_pID].laff = _laff;
713             }
714             generatePlayerSecret(_pID);
715         }
716     }
717 
718     function withdrawEarnings(uint256 _pID)
719         private
720         returns(uint256)
721     {
722         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
723         if (_earnings > 0)
724         {
725             plyr_[_pID].win = 0;
726             plyr_[_pID].gen = 0;
727             plyr_[_pID].aff = 0;
728         }
729 
730         return(_earnings);
731     }
732 
733     function managePlayer(uint256 _pID,uint256 _rID)
734         private
735     {
736         plyr_[_pID].lrnd = _rID;
737     }
738 
739     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
740         private
741     {
742          // pay community rewards
743         // uint256 _com = _eth / 50;
744         
745 
746         // if (address(admin).call.value((_com / 2))() == false)
747         // {
748         //     _p3d = _com / 2;
749         //     _com = _com / 2;
750         // }
751 
752         // if (address(shareCom).call.value((_com / 2))() == false)
753         // {
754         //     _p3d = _p3d.add(_com / 2);
755         //     _com = _com.sub(_com / 2);
756         // }
757 
758         uint256 _p3d = distributeAff(_rID,_pID,_eth,_affID);
759 
760         if (_p3d > 0)
761         {
762             shareCom1.transfer((_p3d.div(2)));
763             shareCom2.transfer((_p3d.div(10)));
764             admin.transfer((_p3d.div(10).mul(4)));
765         }
766     }
767 
768     function distributeAff(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
769         private
770         returns(uint256)
771     {
772         uint256 _addP3d = 0;
773 
774         // distribute share to affiliate
775         uint256 _aff1 = _eth.div(20);
776         // uint256 _aff2 = _eth.div(20);
777         // uint256 _aff3 = _eth.div(100).mul(3);
778 
779 
780         // decide what to do with affiliate share of fees
781         // affiliate must not be self
782         if ((_affID != 0) && (_affID != _pID) && (plyr_[_affID].addr != address(0)))
783         {
784             plyr_[_pID].laffID = _affID;
785             plyr_[_affID].aff = _aff1.add(plyr_[_affID].aff);
786 
787             emit BigOneEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, _rID, _pID, _aff1, now);
788 
789             //second level aff
790             // uint256 _secLaff = plyr_[_affID].laffID;
791             // if((_secLaff != 0) && (_secLaff != _pID))
792             // {
793             //     plyr_[_secLaff].aff = _aff3.add(plyr_[_secLaff].aff);
794             //     emit BigOneEvents.onAffiliatePayout(_secLaff, plyr_[_secLaff].addr, _rID, _pID, _aff3, now);
795             // } else {
796             //     _addP3d = _addP3d.add(_aff3);
797             // }
798         } else {
799             _addP3d = _addP3d.add(_aff1);
800         }
801         return(_addP3d);
802     }
803 
804     function distributeWinning(uint256 _mode, uint256 _amount, uint256 _affID)
805         private
806     {
807         uint256 _affReward = (rSettingXTypeID_[_mode].limit).div(20);
808         if(_affReward > _amount)
809         {
810             _affReward = _amount;
811         } else {
812             uint256 _rest = _amount.sub(_affReward);
813             if(_rest > 0)
814             {
815                 shareCom1.transfer((_rest.div(2)));
816                 shareCom2.transfer((_rest.div(10)));
817                 admin.transfer((_rest.div(10).mul(4)));
818             }
819         }
820         plyr_[_affID].aff = _affReward.add(plyr_[_affID].aff);
821     }
822 
823     function generateRndSecret(uint256 _rID, uint256 _lastSecret)
824         private
825     {
826         roundCommonSecret_[_rID] = uint256(keccak256(abi.encodePacked(_lastSecret, _rID, block.difficulty, now)));
827     }
828 
829     function generatePlayerSecret(uint256 _pID)
830         private
831     {
832         playerSecret_[_pID] = uint256(keccak256(abi.encodePacked(block.blockhash(block.number-1), msg.sender, block.difficulty, now)));
833     }
834 
835     function endRound(uint256 _mode)
836         private
837     {
838         uint256 _rID = currentRoundxType_[_mode];
839 
840         uint256 _winKey = uint256(keccak256(abi.encodePacked(roundCommonSecret_[_rID], playerSecret_[pIDxAddr_[msg.sender]-1], block.difficulty, now))).mod(round_[_rID].keyCount);
841         uint256 _winPID;
842         for(uint256 i = 0;i < round_[_rID].purchases.length; i++) {
843             if(round_[_rID].purchases[i].start <= _winKey && round_[_rID].purchases[i].end >= _winKey) {
844                 _winPID = round_[_rID].purchases[i].plyr;
845                 break;
846             }
847         }
848 
849         if(_winPID != 0) {
850             uint256 _winAmount = (rSettingXTypeID_[_mode].limit).mul(90).div(100);
851 
852             // pay our winner
853             plyr_[_winPID].win = (_winAmount).add(plyr_[_winPID].win);
854 
855             distributeWinning(_mode, (round_[_rID].pot).sub(_winAmount), plyr_[_winPID].laffID);
856         }
857 
858         round_[_rID].plyr = _winPID;
859         round_[_rID].end = now;
860 
861         emit BigOneEvents.onEndRound
862         (
863             _rID,
864             _mode,
865             plyr_[_winPID].addr,
866             _winKey,
867             _winAmount
868         );
869 
870         // start next round
871         rID_++;
872         round_[rID_].start = now;
873         round_[rID_].typeID = _mode;
874         round_[rID_].count = round_[_rID].count + 1;
875         round_[rID_].pot = 0;
876         generateRndSecret(rID_,roundCommonSecret_[_rID]);
877         currentRoundxType_[_mode] = rID_;
878     }
879 }
880 
881 //==============================================================================
882 // interface
883 //==============================================================================
884 
885 interface UserDataManagerInterface {
886     function getPlayerID(address _addr) external returns (uint256);
887     function getPlayerName(uint256 _pID) external view returns (bytes32);
888     function getPlayerLaff(uint256 _pID) external view returns (uint256);
889     function getPlayerAddr(uint256 _pID) external view returns (address);
890     function getNameFee() external view returns (uint256);
891     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
892     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
893     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
894 }
895 
896 //==============================================================================
897 // struct
898 //==============================================================================
899 library BigOneData {
900 
901     struct Player {
902         address addr;   // player address
903         bytes32 name;   // player name
904         uint256 win;    // winnings vault
905         uint256 gen;    // general vault
906         uint256 aff;    // affiliate vault
907         uint256 lrnd;   // last round played
908         uint256 laff;   // last affiliate id used
909         uint256 laffID;   // last affiliate id unaffected
910     }
911     struct PlayerRoundData {
912         uint256 eth;    // eth player has added to round 
913         uint256[] purchaseIDs;   // keys
914         uint256 keyCount;
915     }
916     struct RoundSetting {
917         uint256 id;
918         uint256 limit;   
919         uint256 perShare; 
920         uint256 shareMax;   
921         bool isValue;
922     }
923     struct Round {
924         uint256 plyr;   // pID of player in win
925         uint256 end;    // time ends/ended
926         bool ended;     // has round end function been ran
927         uint256 start;   // time round started
928 
929         uint256 keyCount;   // keys
930         BigOneData.PurchaseRecord[] purchases;  
931         uint256 eth;    // total eth in
932         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
933 
934         uint256 typeID;
935         uint256 count;
936     }
937     struct PurchaseRecord {
938         uint256 plyr;   
939         uint256 start;
940         uint256 end;
941     }
942 
943 }
944 
945 
946 library NameFilter {
947 
948     function nameFilter(string _input)
949         internal
950         pure
951         returns(bytes32)
952     {
953         bytes memory _temp = bytes(_input);
954         uint256 _length = _temp.length;
955 
956         //sorry limited to 32 characters
957         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
958         // make sure it doesnt start with or end with space
959         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
960         // make sure first two characters are not 0x
961         if (_temp[0] == 0x30)
962         {
963             require(_temp[1] != 0x78, "string cannot start with 0x");
964             require(_temp[1] != 0x58, "string cannot start with 0X");
965         }
966 
967         // create a bool to track if we have a non number character
968         bool _hasNonNumber;
969 
970         // convert & check
971         for (uint256 i = 0; i < _length; i++)
972         {
973             // if its uppercase A-Z
974             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
975             {
976                 // convert to lower case a-z
977                 _temp[i] = byte(uint(_temp[i]) + 32);
978 
979                 // we have a non number
980                 if (_hasNonNumber == false)
981                     _hasNonNumber = true;
982             } else {
983                 require
984                 (
985                     // require character is a space
986                     _temp[i] == 0x20 ||
987                     // OR lowercase a-z
988                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
989                     // or 0-9
990                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
991                     "string contains invalid characters"
992                 );
993                 // make sure theres not 2x spaces in a row
994                 if (_temp[i] == 0x20)
995                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
996 
997                 // see if we have a character other than a number
998                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
999                     _hasNonNumber = true;
1000             }
1001         }
1002 
1003         require(_hasNonNumber == true, "string cannot be only numbers");
1004 
1005         bytes32 _ret;
1006         assembly {
1007             _ret := mload(add(_temp, 32))
1008         }
1009         return (_ret);
1010     }
1011 }
1012 
1013 
1014 library SafeMath 
1015 {
1016     /**
1017     * @dev Multiplies two numbers, reverts on overflow.
1018     */
1019     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1020         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1021         // benefit is lost if 'b' is also tested.
1022         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1023         if (_a == 0) {
1024             return 0;
1025         }
1026 
1027         uint256 c = _a * _b;
1028         require(c / _a == _b);
1029 
1030         return c;
1031     }
1032 
1033     /**
1034     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1035     */
1036     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1037         require(_b > 0); // Solidity only automatically asserts when dividing by 0
1038         uint256 c = _a / _b;
1039         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1040 
1041         return c;
1042     }
1043 
1044     /**
1045     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1046     */
1047     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1048         require(_b <= _a);
1049         uint256 c = _a - _b;
1050 
1051         return c;
1052     }
1053 
1054     /**
1055     * @dev Adds two numbers, reverts on overflow.
1056     */
1057     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1058         uint256 c = _a + _b;
1059         require(c >= _a);
1060 
1061         return c;
1062     }
1063 
1064     /**
1065     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1066     * reverts when dividing by zero.
1067     */
1068     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1069         require(b != 0);
1070         return a % b;
1071     }
1072 }