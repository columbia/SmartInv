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
18 *    BigOne Game v0.5　　  ,': : : : : : : : ::ｊ三三三三|: |三i: : ::,
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
57         bytes32 playerName,
58         address playerAddress,
59         uint256 ethIn,
60         uint256 keyCount,
61         uint256 newPot
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
77         bytes32 affiliateName,
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
89         bytes32 winnerName,
90         uint256 amountWon
91     );
92 }
93 
94 contract BigOne is BigOneEvents {
95     using SafeMath for *;
96     using NameFilter for string;
97 
98     UserDataManagerInterface constant private UserDataManager = UserDataManagerInterface(0xD7c181F8de81f90020D5c7c3Dcb4DEED86ed8450);
99 
100     //****************
101     // constant
102     //****************
103     address private admin = msg.sender;
104     address private shareCom = 0xdc02C8B983c52292672b95b057b7F004244e333A;
105     address private groupCut = 0xC153a27a8e460A46fA28F796D5221Dc28828c5A4;
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
133     mapping (uint256 => address[]) private winners_; //(rType => winners_)
134     mapping (uint256 => uint256[]) private winNumbers_; //(rType => winNumbers_)
135 
136     //==============================================================================
137     // init
138     //==============================================================================
139     constructor() public {
140         rID_ = 0;
141         rTypeID_ = 0;
142     }
143 
144     //==============================================================================
145     // checks
146     //==============================================================================
147     modifier isActivated() {
148         require(activated_ == true, "its not ready yet.  check ?eta in discord");
149         _;
150     }
151 
152     modifier isHuman() {
153         address _addr = msg.sender;
154         uint256 _codeLength;
155 
156         assembly {_codeLength := extcodesize(_addr)}
157         require(_codeLength == 0, "sorry humans only");
158         _;
159     }
160 
161     modifier onlyDevs() {
162         require(admin == msg.sender, "msg sender is not a dev");
163         _;
164     }
165 
166     modifier isWithinLimits(uint256 _eth,uint256 _typeID) {
167         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
168         require(_eth >= rSettingXTypeID_[_typeID].perShare, "less than min allow");
169         require(_eth <= rSettingXTypeID_[_typeID].limit, "more than max allow");
170         _;
171     }
172 
173     modifier modeCheck(uint256 _typeID) {
174         require(rSettingXTypeID_[_typeID].isValue, "invaild mode id");
175         _;
176     }
177 
178     //==============================================================================
179     // admin
180     //==============================================================================
181     bool public activated_ = false;
182     function activate(uint256 _initSecret)
183         onlyDevs()
184         public
185     {
186         require(activated_ == false, "BigOne already activated");
187         require(rTypeID_ > 0, "No round mode setup");
188         activated_ = true;
189 
190         for(uint256 i = 0; i < rTypeID_; i++) {
191             rID_++;
192             round_[rID_].start = now;
193             round_[rID_].typeID = i + 1;
194             round_[rID_].count = 1;
195             round_[rID_].pot = 0;
196             generateRndSecret(rID_,_initSecret);
197             currentRoundxType_[i + 1] = rID_;
198         }
199     }
200 
201     function addRoundMode(uint256 _limit, uint256 _perShare, uint256 _shareMax)
202         onlyDevs()
203         public
204     {
205         require(activated_ == false, "BigOne already started");
206 
207         rTypeID_++;
208         rSettingXTypeID_[rTypeID_].id = rTypeID_;
209         rSettingXTypeID_[rTypeID_].limit = _limit;
210         rSettingXTypeID_[rTypeID_].perShare = _perShare;
211         rSettingXTypeID_[rTypeID_].shareMax = _shareMax;
212         rSettingXTypeID_[rTypeID_].isValue = true;
213     }
214 
215     //==============================================================================
216     // public
217     //==============================================================================
218 
219     function()
220         isActivated()
221         isHuman()
222         isWithinLimits(msg.value,1)
223         public
224         payable
225     {
226         determinePID();
227 
228         uint256 _pID = pIDxAddr_[msg.sender];
229 
230         buyCore(_pID, plyr_[_pID].laff,1);
231     }
232 
233     function buyXid(uint256 _affCode, uint256 _mode)
234         isActivated()
235         isHuman()
236         isWithinLimits(msg.value,_mode)
237         public
238         payable
239     {
240         determinePID();
241 
242         uint256 _pID = pIDxAddr_[msg.sender];
243 
244         if (_affCode == 0 || _affCode == _pID)
245         {
246             _affCode = plyr_[_pID].laff;
247 
248         } else if (_affCode != plyr_[_pID].laff) {
249             plyr_[_pID].laff = _affCode;
250         }
251 
252         buyCore(_pID, _affCode, _mode);
253     }
254 
255     function buyXaddr(address _affCode, uint256 _mode)
256         isActivated()
257         isHuman()
258         isWithinLimits(msg.value,_mode)
259         public
260         payable
261     {
262         determinePID();
263 
264         uint256 _pID = pIDxAddr_[msg.sender];
265 
266         uint256 _affID;
267         if (_affCode == address(0) || _affCode == msg.sender)
268         {
269             _affID = plyr_[_pID].laff;
270 
271         } else {
272             _affID = pIDxAddr_[_affCode];
273 
274             if (_affID != plyr_[_pID].laff)
275             {
276                 plyr_[_pID].laff = _affID;
277             }
278         }
279 
280         buyCore(_pID, _affID, _mode);
281     }
282 
283     function buyXname(bytes32 _affCode, uint256 _mode)
284         isActivated()
285         isHuman()
286         isWithinLimits(msg.value,_mode)
287         public
288         payable
289     {
290         determinePID();
291 
292         uint256 _pID = pIDxAddr_[msg.sender];
293 
294         uint256 _affID;
295         if (_affCode == '' || _affCode == plyr_[_pID].name)
296         {
297             _affID = plyr_[_pID].laff;
298 
299         } else {
300             _affID = pIDxName_[_affCode];
301 
302             if (_affID != plyr_[_pID].laff)
303             {
304                 plyr_[_pID].laff = _affID;
305             }
306         }
307 
308         buyCore(_pID, _affID, _mode);
309     }
310 
311     function reLoadXid(uint256 _affCode, uint256 _eth, uint256 _mode)
312         isActivated()
313         isHuman()
314         isWithinLimits(_eth,_mode)
315         public
316     {
317         uint256 _pID = pIDxAddr_[msg.sender];
318 
319         if (_affCode == 0 || _affCode == _pID)
320         {
321             _affCode = plyr_[_pID].laff;
322 
323         } else if (_affCode != plyr_[_pID].laff) {
324             plyr_[_pID].laff = _affCode;
325         }
326 
327         reLoadCore(_pID, _affCode, _eth, _mode);
328     }
329 
330     function reLoadXaddr(address _affCode, uint256 _eth, uint256 _mode)
331         isActivated()
332         isHuman()
333         isWithinLimits(_eth,_mode)
334         public
335     {
336         uint256 _pID = pIDxAddr_[msg.sender];
337 
338         uint256 _affID;
339         if (_affCode == address(0) || _affCode == msg.sender)
340         {
341             _affID = plyr_[_pID].laff;
342         } else {
343             _affID = pIDxAddr_[_affCode];
344 
345             if (_affID != plyr_[_pID].laff)
346             {
347                 plyr_[_pID].laff = _affID;
348             }
349         }
350 
351         reLoadCore(_pID, _affID, _eth, _mode);
352     }
353 
354     function reLoadXname(bytes32 _affCode, uint256 _eth, uint256 _mode)
355         isActivated()
356         isHuman()
357         isWithinLimits(_eth,_mode)
358         public
359     {
360         uint256 _pID = pIDxAddr_[msg.sender];
361 
362         uint256 _affID;
363         if (_affCode == '' || _affCode == plyr_[_pID].name)
364         {
365             _affID = plyr_[_pID].laff;
366         } else {
367             _affID = pIDxName_[_affCode];
368 
369             if (_affID != plyr_[_pID].laff)
370             {
371                 plyr_[_pID].laff = _affID;
372             }
373         }
374         reLoadCore(_pID, _affID, _eth,_mode);
375     }
376 
377     function withdraw()
378         isActivated()
379         isHuman()
380         public
381     {
382         // grab time
383         uint256 _now = now;
384 
385         // fetch player ID
386         uint256 _pID = pIDxAddr_[msg.sender];
387 
388         // setup temp var for player eth
389         uint256 _eth;
390         uint256 _withdrawFee;
391     
392         // get their earnings
393         _eth = withdrawEarnings(_pID);
394 
395         // gib moni
396         if (_eth > 0)
397         {
398             //10% trade tax
399             _withdrawFee = _eth / 10;
400             uint256 _p1 = _withdrawFee / 2;
401             uint256 _p2 = _withdrawFee / 2;
402             shareCom.transfer(_p1);
403             admin.transfer(_p2);
404 
405             plyr_[_pID].addr.transfer(_eth.sub(_withdrawFee));
406         }
407 
408         // fire withdraw event
409         emit BigOneEvents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
410     }
411 
412     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
413         isHuman()
414         public
415         payable
416     {
417         bytes32 _name = _nameString.nameFilter();
418         address _addr = msg.sender;
419         uint256 _paid = msg.value;
420         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXIDFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
421 
422         uint256 _pID = pIDxAddr_[_addr];
423         if(_isNewPlayer) generatePlayerSecret(_pID);
424         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
425     }
426 
427     function registerNameXaddr(string _nameString, address _affCode, bool _all)
428         isHuman()
429         public
430         payable
431     {
432         bytes32 _name = _nameString.nameFilter();
433         address _addr = msg.sender;
434         uint256 _paid = msg.value;
435         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
436 
437         uint256 _pID = pIDxAddr_[_addr];
438         if(_isNewPlayer) generatePlayerSecret(_pID);
439         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
440     }
441 
442     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
443         isHuman()
444         public
445         payable
446     {
447         bytes32 _name = _nameString.nameFilter();
448         address _addr = msg.sender;
449         uint256 _paid = msg.value;
450         (bool _isNewPlayer, uint256 _affID) = UserDataManager.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
451 
452         uint256 _pID = pIDxAddr_[_addr];
453         if(_isNewPlayer) generatePlayerSecret(_pID);
454         emit BigOneEvents.onNewPlayer(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
455     }
456 
457 //==============================================================================
458 // query
459 //==============================================================================
460 
461     function iWantXKeys(uint256 _keys,uint256 _mode)
462         modeCheck(_mode)
463         public
464         view
465         returns(uint256)
466     {
467         return _keys.mul(rSettingXTypeID_[_mode].perShare);
468     }
469 
470     function getWinners(uint256 _mode)
471         modeCheck(_mode)
472         public
473         view
474         returns(address[])
475     {
476         return winners_[_mode];
477     }
478 
479     function getWinNumbers(uint256 _mode)
480         modeCheck(_mode)
481         public
482         view
483         returns(uint256[])
484     {
485         return winNumbers_[_mode];
486     }
487 
488     function getPlayerVaults(uint256 _pID)
489         public
490         view
491         //win,gen,aff
492         returns(uint256[])
493     {
494         uint256[] memory _vaults = new uint256[](3);
495         _vaults[0] = plyr_[_pID].win;
496         _vaults[1] = plyr_[_pID].gen;
497         _vaults[2] = plyr_[_pID].aff;
498 
499         return _vaults;
500     }
501 
502     function getCurrentRoundInfo(uint256 _mode)
503         modeCheck(_mode)
504         public
505         view
506         returns(uint256[])
507     {
508         uint256 _rID = currentRoundxType_[_mode];
509 
510         uint256[] memory _roundInfos = new uint256[](6);
511         _roundInfos[0] = _mode;
512         _roundInfos[1] = _rID;
513         _roundInfos[2] = round_[_rID].count;
514         _roundInfos[3] = round_[_rID].keyCount;
515         _roundInfos[4] = round_[_rID].eth;
516         _roundInfos[5] = round_[_rID].pot;
517 
518         return _roundInfos;
519     }
520 
521     function getPlayerInfoByAddress(address _addr,uint256 _mode)
522         modeCheck(_mode)
523         public
524         view
525         returns(uint256, uint256, bytes32)
526     {
527         uint256 _rID = currentRoundxType_[_mode];
528 
529         if (_addr == address(0))
530         {
531             _addr == msg.sender;
532         }
533         uint256 _pID = pIDxAddr_[_addr];
534 
535         return
536         (
537             _pID,                               //0
538             plyrRnds_[_pID][_rID].eth,          //1
539             plyr_[_pID].name                   //2
540         );
541     }
542 
543     function getPlayerKeys(address _addr,uint256 _mode)
544         public
545         view
546         returns(uint256[]) 
547     {
548         uint256 _rID = currentRoundxType_[_mode];
549 
550         if (_addr == address(0))
551         {
552             _addr == msg.sender;
553         }
554         uint256 _pID = pIDxAddr_[_addr];
555 
556         uint256[] memory _keys = new uint256[](plyrRnds_[_pID][_rID].keyCount);
557         uint256 _keyIndex = 0;
558         for(uint256 i = 0;i < plyrRnds_[_pID][_rID].purchaseIDs.length;i++) {
559             uint256 _pIndex = plyrRnds_[_pID][_rID].purchaseIDs[i];
560             BigOneData.PurchaseRecord memory _pr = round_[_rID].purchases[_pIndex];
561             if(_pr.plyr == _pID) {
562                 for(uint256 j = _pr.start; j <= _pr.end; j++) {
563                     _keys[_keyIndex] = j;
564                     _keyIndex++;
565                 }
566             }
567         }
568         return _keys;
569     }
570 
571     function getPlayerAff(uint256 _pID)
572         public
573         view
574         returns (uint256[])
575     {
576         uint256[] memory _affs = new uint256[](3);
577 
578         _affs[0] = plyr_[_pID].laffID;
579         if (_affs[0] != 0)
580         {
581             //second level aff
582             _affs[1] = plyr_[_affs[0]].laffID;
583 
584             if(_affs[1] != 0)
585             {
586                 //third level aff
587                 _affs[2] = plyr_[_affs[1]].laffID;
588             }
589         }
590         return _affs;
591     }
592 
593 //==============================================================================
594 // private
595 //==============================================================================
596 
597     function buyCore(uint256 _pID, uint256 _affID, uint256 _mode)
598         private
599     {
600         uint256 _rID = currentRoundxType_[_mode];
601 
602         if (round_[_rID].pot < rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0)
603         {
604             core(_rID, _pID, msg.value, _affID,_mode);
605         } else {
606             if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false)
607             {
608                 round_[_rID].ended = true;
609                 endRound(_mode); 
610             }
611             //directly refund player
612             plyr_[_pID].addr.transfer(msg.value);
613         }
614     }
615 
616     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _eth, uint _mode)
617         private
618     {
619         uint256 _rID = currentRoundxType_[_mode];
620 
621         if (round_[_rID].pot < rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0)
622         {
623             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
624             core(_rID, _pID, _eth, _affID,_mode);
625         } else {
626             if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false) 
627             {
628                 round_[_rID].ended = true;
629                 endRound(_mode);      
630             }
631         }
632     }
633 
634     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _mode)
635         private
636     {
637         if (plyrRnds_[_pID][_rID].keyCount == 0) 
638         {
639             managePlayer(_pID,_rID);
640         }
641 
642         if (round_[_rID].keyCount < rSettingXTypeID_[_mode].shareMax)
643         {
644             uint256 _ethAdd = ((rSettingXTypeID_[_mode].shareMax).sub(round_[_rID].keyCount)).mul(rSettingXTypeID_[_mode].perShare);
645             if(_eth > _ethAdd) {
646                 plyr_[_pID].gen = plyr_[_pID].gen.add(_eth.sub(_ethAdd)); 
647             } else {
648                 _ethAdd = _eth;
649             }
650 
651             uint256 _keyAdd = _ethAdd.div(rSettingXTypeID_[_mode].perShare);
652             uint256 _keyEnd = (round_[_rID].keyCount).add(_keyAdd);
653             
654             BigOneData.PurchaseRecord memory _pr;
655             _pr.plyr = _pID;
656             _pr.start = round_[_rID].keyCount;
657             _pr.end = _keyEnd - 1;
658             round_[_rID].purchases.push(_pr);
659             plyrRnds_[_pID][_rID].purchaseIDs.push(round_[_rID].purchases.length - 1);
660             plyrRnds_[_pID][_rID].keyCount += _keyAdd;
661 
662             plyrRnds_[_pID][_rID].eth = _ethAdd.add(plyrRnds_[_pID][_rID].eth);
663             round_[_rID].keyCount = _keyEnd;
664             round_[_rID].eth = _ethAdd.add(round_[_rID].eth);
665             round_[_rID].pot = (round_[_rID].pot).add((_ethAdd.mul(80)).div(100));
666 
667             distributeExternal(_rID, _pID, _ethAdd, _affID);
668 
669             if (round_[_rID].pot >= rSettingXTypeID_[_mode].limit && round_[_rID].plyr == 0 && round_[_rID].ended == false) 
670             {
671                 round_[_rID].ended = true;
672                 endRound(_mode); 
673             }
674 
675             emit BigOneEvents.onEndTx
676             (
677                 plyr_[_pID].name,
678                 msg.sender,
679                 _eth,
680                 round_[_rID].keyCount,
681                 round_[_rID].pot
682             );
683 
684         } else {
685             // put back eth in players vault
686             plyr_[_pID].gen = plyr_[_pID].gen.add(_eth);    
687         }
688 
689     }
690 
691 
692 //==============================================================================
693 // util
694 //==============================================================================
695 
696     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
697         external
698     {
699         require (msg.sender == address(UserDataManager), "your not userManager contract");
700         if (pIDxAddr_[_addr] != _pID)
701             pIDxAddr_[_addr] = _pID;
702         if (pIDxName_[_name] != _pID)
703             pIDxName_[_name] = _pID;
704         if (plyr_[_pID].addr != _addr)
705             plyr_[_pID].addr = _addr;
706         if (plyr_[_pID].name != _name)
707             plyr_[_pID].name = _name;
708         if (plyr_[_pID].laff != _laff)
709             plyr_[_pID].laff = _laff;
710     }
711 
712     function determinePID()
713         private
714     {
715         uint256 _pID = pIDxAddr_[msg.sender];
716         if (_pID == 0)
717         {
718             _pID = UserDataManager.getPlayerID(msg.sender);
719             bytes32 _name = UserDataManager.getPlayerName(_pID);
720             uint256 _laff = UserDataManager.getPlayerLaff(_pID);
721 
722             pIDxAddr_[msg.sender] = _pID;
723             plyr_[_pID].addr = msg.sender;
724 
725             if (_name != "")
726             {
727                 pIDxName_[_name] = _pID;
728                 plyr_[_pID].name = _name;
729             }
730 
731             if (_laff != 0 && _laff != _pID) 
732             {
733                 plyr_[_pID].laff = _laff;
734             }
735             generatePlayerSecret(_pID);
736         }
737     }
738 
739     function withdrawEarnings(uint256 _pID)
740         private
741         returns(uint256)
742     {
743         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
744         if (_earnings > 0)
745         {
746             plyr_[_pID].win = 0;
747             plyr_[_pID].gen = 0;
748             plyr_[_pID].aff = 0;
749         }
750 
751         return(_earnings);
752     }
753 
754     function managePlayer(uint256 _pID,uint256 _rID)
755         private
756     {
757         plyr_[_pID].lrnd = _rID;
758     }
759 
760     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
761         private
762     {
763          // pay community rewards
764         uint256 _com = _eth / 50;
765         uint256 _p3d;
766 
767         if (address(admin).call.value((_com / 2))() == false)
768         {
769             _p3d = _com / 2;
770             _com = _com / 2;
771         }
772 
773         if (address(shareCom).call.value((_com / 2))() == false)
774         {
775             _p3d = _p3d.add(_com / 2);
776             _com = _com.sub(_com / 2);
777         }
778 
779         _p3d = _p3d.add(distributeAff(_rID,_pID,_eth,_affID));
780 
781         if (_p3d > 0)
782         {
783             shareCom.transfer((_p3d / 2));
784             admin.transfer((_p3d / 2));
785         }
786     }
787 
788     function distributeAff(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID)
789         private
790         returns(uint256)
791     {
792         uint256 _addP3d = 0;
793 
794         // distribute share to affiliate
795         uint256 _aff1 = _eth.div(10);
796         uint256 _aff2 = _eth.div(20);
797         uint256 _aff3 = _eth.div(100).mul(3);
798 
799         groupCut.transfer(_aff1);
800 
801         // decide what to do with affiliate share of fees
802         // affiliate must not be self, and must have a name registered
803         if ((_affID != 0) && (_affID != _pID) && (plyr_[_affID].name != ''))
804         {
805             plyr_[_pID].laffID = _affID;
806             plyr_[_affID].aff = _aff2.add(plyr_[_affID].aff);
807 
808             emit BigOneEvents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff2, now);
809 
810             //second level aff
811             uint256 _secLaff = plyr_[_affID].laffID;
812             if((_secLaff != 0) && (_secLaff != _pID))
813             {
814                 plyr_[_secLaff].aff = _aff3.add(plyr_[_secLaff].aff);
815                 emit BigOneEvents.onAffiliatePayout(_secLaff, plyr_[_secLaff].addr, plyr_[_secLaff].name, _rID, _pID, _aff3, now);
816             } else {
817                 _addP3d = _addP3d.add(_aff3);
818             }
819         } else {
820             _addP3d = _addP3d.add(_aff2);
821         }
822         return(_addP3d);
823     }
824 
825     function generateRndSecret(uint256 _rID, uint256 _lastSecret)
826         private
827     {
828         roundCommonSecret_[_rID] = uint256(keccak256(abi.encodePacked(_lastSecret, _rID, block.difficulty, now)));
829     }
830 
831     function generatePlayerSecret(uint256 _pID)
832         private
833     {
834         playerSecret_[_pID] = uint256(keccak256(abi.encodePacked(block.blockhash(block.number), msg.sender, block.difficulty, now)));
835     }
836 
837     function endRound(uint256 _mode)
838         private
839     {
840         uint256 _rID = currentRoundxType_[_mode];
841 
842         uint256 _winKey = uint256(keccak256(abi.encodePacked(roundCommonSecret_[_rID], playerSecret_[pIDxAddr_[msg.sender]], block.difficulty, now))).mod(round_[_rID].keyCount);
843         uint256 _winPID;
844         for(uint256 i = 0;i < round_[_rID].purchases.length; i++) {
845             if(round_[_rID].purchases[i].start <= _winKey && round_[_rID].purchases[i].end >= _winKey) {
846                 _winPID = round_[_rID].purchases[i].plyr;
847                 break;
848             }
849         }
850 
851         if(_winPID != 0) {
852             // pay our winner
853             plyr_[_winPID].win = (round_[_rID].pot).add(plyr_[_winPID].win);
854 
855             winners_[_mode].push(plyr_[_winPID].addr);
856             winNumbers_[_mode].push(_winKey);
857         }
858 
859         round_[_rID].plyr = _winPID;
860         round_[_rID].end = now;
861 
862         emit BigOneEvents.onEndRound
863         (
864             _rID,
865             _mode,
866             plyr_[_winPID].addr,
867             plyr_[_winPID].name,
868             round_[_rID].pot
869         );
870 
871         // start next round
872         rID_++;
873         round_[rID_].start = now;
874         round_[rID_].typeID = _mode;
875         round_[rID_].count = round_[_rID].count + 1;
876         round_[rID_].pot = 0;
877         generateRndSecret(rID_,roundCommonSecret_[_rID]);
878         currentRoundxType_[_mode] = rID_;
879     }
880 }
881 
882 //==============================================================================
883 // interface
884 //==============================================================================
885 
886 interface UserDataManagerInterface {
887     function getPlayerID(address _addr) external returns (uint256);
888     function getPlayerName(uint256 _pID) external view returns (bytes32);
889     function getPlayerLaff(uint256 _pID) external view returns (uint256);
890     function getPlayerAddr(uint256 _pID) external view returns (address);
891     function getNameFee() external view returns (uint256);
892     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
893     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
894     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
895 }
896 
897 //==============================================================================
898 // struct
899 //==============================================================================
900 library BigOneData {
901 
902     struct Player {
903         address addr;   // player address
904         bytes32 name;   // player name
905         uint256 win;    // winnings vault
906         uint256 gen;    // general vault
907         uint256 aff;    // affiliate vault
908         uint256 lrnd;   // last round played
909         uint256 laff;   // last affiliate id used
910         uint256 laffID;   // last affiliate id unaffected
911     }
912     struct PlayerRoundData {
913         uint256 eth;    // eth player has added to round 
914         uint256[] purchaseIDs;   // keys
915         uint256 keyCount;
916     }
917     struct RoundSetting {
918         uint256 id;
919         uint256 limit;   
920         uint256 perShare; 
921         uint256 shareMax;   
922         bool isValue;
923     }
924     struct Round {
925         uint256 plyr;   // pID of player in win
926         uint256 end;    // time ends/ended
927         bool ended;     // has round end function been ran
928         uint256 start;   // time round started
929 
930         uint256 keyCount;   // keys
931         BigOneData.PurchaseRecord[] purchases;  
932         uint256 eth;    // total eth in
933         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
934 
935         uint256 typeID;
936         uint256 count;
937     }
938     struct PurchaseRecord {
939         uint256 plyr;   
940         uint256 start;
941         uint256 end;
942     }
943 
944 }
945 
946 
947 library NameFilter {
948 
949     function nameFilter(string _input)
950         internal
951         pure
952         returns(bytes32)
953     {
954         bytes memory _temp = bytes(_input);
955         uint256 _length = _temp.length;
956 
957         //sorry limited to 32 characters
958         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
959         // make sure it doesnt start with or end with space
960         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
961         // make sure first two characters are not 0x
962         if (_temp[0] == 0x30)
963         {
964             require(_temp[1] != 0x78, "string cannot start with 0x");
965             require(_temp[1] != 0x58, "string cannot start with 0X");
966         }
967 
968         // create a bool to track if we have a non number character
969         bool _hasNonNumber;
970 
971         // convert & check
972         for (uint256 i = 0; i < _length; i++)
973         {
974             // if its uppercase A-Z
975             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
976             {
977                 // convert to lower case a-z
978                 _temp[i] = byte(uint(_temp[i]) + 32);
979 
980                 // we have a non number
981                 if (_hasNonNumber == false)
982                     _hasNonNumber = true;
983             } else {
984                 require
985                 (
986                     // require character is a space
987                     _temp[i] == 0x20 ||
988                     // OR lowercase a-z
989                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
990                     // or 0-9
991                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
992                     "string contains invalid characters"
993                 );
994                 // make sure theres not 2x spaces in a row
995                 if (_temp[i] == 0x20)
996                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
997 
998                 // see if we have a character other than a number
999                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
1000                     _hasNonNumber = true;
1001             }
1002         }
1003 
1004         require(_hasNonNumber == true, "string cannot be only numbers");
1005 
1006         bytes32 _ret;
1007         assembly {
1008             _ret := mload(add(_temp, 32))
1009         }
1010         return (_ret);
1011     }
1012 }
1013 
1014 
1015 library SafeMath 
1016 {
1017     /**
1018     * @dev Multiplies two numbers, reverts on overflow.
1019     */
1020     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
1021         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1022         // benefit is lost if 'b' is also tested.
1023         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1024         if (_a == 0) {
1025             return 0;
1026         }
1027 
1028         uint256 c = _a * _b;
1029         require(c / _a == _b);
1030 
1031         return c;
1032     }
1033 
1034     /**
1035     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1036     */
1037     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1038         require(_b > 0); // Solidity only automatically asserts when dividing by 0
1039         uint256 c = _a / _b;
1040         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1041 
1042         return c;
1043     }
1044 
1045     /**
1046     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1047     */
1048     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1049         require(_b <= _a);
1050         uint256 c = _a - _b;
1051 
1052         return c;
1053     }
1054 
1055     /**
1056     * @dev Adds two numbers, reverts on overflow.
1057     */
1058     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
1059         uint256 c = _a + _b;
1060         require(c >= _a);
1061 
1062         return c;
1063     }
1064 
1065     /**
1066     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1067     * reverts when dividing by zero.
1068     */
1069     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1070         require(b != 0);
1071         return a % b;
1072     }
1073 }