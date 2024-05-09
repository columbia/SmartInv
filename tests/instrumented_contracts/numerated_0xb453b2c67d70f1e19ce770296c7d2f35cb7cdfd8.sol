1 pragma solidity ^0.4.23;
2 
3 contract Events {
4     event onActive();
5 
6     event onOuterDividend
7     (
8         uint256 _dividends
9     );
10 
11     event onBuyKey
12     (
13         address _address,
14         uint256 _pID,
15         uint256 _rID,
16         uint256 _eth,
17         uint256 _key,
18         bool _timeExtended
19     );
20 
21     event onReload
22     (
23         address _address,
24         uint256 _pID,
25         uint256 _rID,
26         uint256 _eth,
27         uint256 _dividend,
28         uint256 _luckBonus,
29         uint256 _key,
30         bool _timeExtended
31     );
32 
33     event onWithdraw
34     (
35         address _address,
36         uint256 _pID,
37         uint256 _rID,
38         uint256 _eth,
39         uint256 _dividend,
40         uint256 _luckBonus
41     );
42 
43     event onSell
44     (
45         address _address,
46         uint256 _pID,
47         uint256 _rID,
48         uint256 _key,
49         uint256 _eth
50     );
51 
52     event onWinLuckyPrize
53     (
54         uint256 _rID
55     );
56 }
57 
58 contract PT7D is Events {
59     using SafeMath for *;
60 
61     ReferralInterface private Referralcontract_;
62 //==============================================================================
63 //   config
64 //==============================================================================
65     string public name = "PT7D";
66     string public symbol = "PT";
67     uint256 constant internal magnitude = 1e18;
68 //==============================================================================
69 //   variable config
70 //==============================================================================
71     uint16 public sellFee_ = 1500;
72     uint8 public luckyBonus_ = 5;
73     uint8 public attenuationFee_ = 1;
74     uint8 public luckyEdge_ = 70;
75     uint8 public extensionThreshold_ = 2;
76 
77     uint256 public extensionMin_ = 0.1 ether;
78     uint256 public extensionMax_ = 10 ether;
79     uint256 public rndInit_ = 24 hours;
80     uint256 public rndInc_ = 1 hours;
81 //==============================================================================
82 //   datasets
83 //============================================================================== 
84     uint256 public pID_ = 0;
85     uint256 public rID_ = 0;
86     uint256 public keySupply_ = 0;
87     uint256 public totalInvestment_ = 0;
88     uint256 public pot_ = 0;
89     uint256 internal profitPerShare_ = 0;
90     uint256 public luckyRounds_ = 0;
91 
92     mapping (address => uint256) public pIDxAddr_;
93     mapping (uint256 => Datasets.Player) public plyr_;
94     mapping (uint256 => Datasets.Round) public round_;
95     mapping (uint256 => mapping (uint256 => uint256)) public plyrRnds_;
96     mapping (bytes32 => bool) public administrators;
97 
98     uint256 internal administratorBalance_ = 0;
99 //==============================================================================
100 //   modifier
101 //==============================================================================
102     modifier isActivated() {
103         require(activated_ == true, "its not ready yet."); 
104         _;
105     }
106 
107     modifier onlyAdministrator(){
108         address _customerAddress = msg.sender; 
109         require(administrators[keccak256(_customerAddress)]);
110         _;
111     }
112 //==============================================================================
113 //   public functions
114 //==============================================================================
115     constructor()
116         public
117     {
118         administrators[0x14c319c3c982350b442e4074ec4736b3ac376ebdca548bdda0097040223e7bd6] = true;
119     }
120     
121     function()
122         public
123         payable
124         isActivated()
125     {
126         uint256 _curBalance = totalEthereumBalance();
127         if (_curBalance > 10 ether && _curBalance < 500 ether)
128             require(msg.value >= 10 ether);
129 
130         uint256 _pID = getPlayerID();
131         endRoundAndGetEarnings(_pID);
132 
133         uint256 _amountOfkeys;
134         bool _timeExtended;
135         (_amountOfkeys,_timeExtended) = purchaseKeys(_pID, msg.value);
136         
137         emit onBuyKey(msg.sender, _pID, rID_, msg.value, _amountOfkeys, _timeExtended);
138     }
139     
140     function outerDividend()
141         external
142         payable
143         isActivated()
144     {
145         uint256 _dividends = msg.value;
146         profitPerShare_ = profitPerShare_.add(_dividends.mul(magnitude).div(keySupply_));
147 
148         emit onOuterDividend(_dividends);
149     }
150 
151     function reLoad()
152         public
153         isActivated()
154     {
155         uint256 _pID = getPlayerID();
156         endRoundAndGetEarnings(_pID);
157 
158         uint256 _dividends;
159         uint256 _luckBonus;
160         (_dividends,_luckBonus) = withdrawEarnings(_pID);
161         uint256 _earnings = _dividends.add(_luckBonus);
162 
163         uint256 _curBalance = totalEthereumBalance();
164         if (_curBalance > 10 ether && _curBalance < 500 ether)
165             require(_earnings >= 10 ether);
166 
167         uint256 _amountOfkeys;
168         bool _timeExtended;
169         (_amountOfkeys,_timeExtended) = purchaseKeys(_pID, _earnings);
170 
171         emit onReload(msg.sender, _pID, rID_, _earnings, _dividends, _luckBonus, _amountOfkeys, _timeExtended);
172     }
173 
174     function withdraw()
175         public
176         isActivated()
177     {
178         uint256 _pID = getPlayerID();
179         endRoundAndGetEarnings(_pID);
180 
181         uint256 _dividends;
182         uint256 _luckBonus;
183         (_dividends,_luckBonus) = withdrawEarnings(_pID);
184         uint256 _earnings = _dividends.add(_luckBonus);
185         if (_earnings > 0)
186             plyr_[_pID].addr.transfer(_earnings);
187 
188         emit onWithdraw(msg.sender, _pID, rID_, _earnings, _dividends, _luckBonus);
189     }
190     
191     function sell(uint256 _amountOfkeys)
192         public
193         isActivated()
194     {
195         uint256 _pID = getPlayerID();
196         endRoundAndGetEarnings(_pID);
197 
198         Datasets.Player _plyr = plyr_[_pID];
199         Datasets.Round _round = round_[rID_];
200 
201         require(_amountOfkeys <= _plyr.keys);
202 
203         uint256 _eth = keysToEthereum(_amountOfkeys);
204         uint256 _sellFee = calcSellFee(_pID);
205         uint256 _dividends = _eth.mul(_sellFee).div(10000);
206         uint256 _taxedEthereum = _eth.sub(_dividends);
207         
208         keySupply_ = keySupply_.sub(_amountOfkeys);
209 
210         _plyr.keys = _plyr.keys.sub(_amountOfkeys);
211         _plyr.mask = _plyr.mask - (int256)(_taxedEthereum.add(profitPerShare_.mul(_amountOfkeys).div(magnitude)));
212         
213         if (keySupply_ > 0) {
214             profitPerShare_ = profitPerShare_.add((_dividends.mul(magnitude)).div(keySupply_));
215         }
216         
217         emit onSell(msg.sender, _pID, rID_, _amountOfkeys, _eth);
218     }
219 //==============================================================================
220 //   private functions
221 //==============================================================================
222     function getPlayerID()
223         private
224         returns (uint256)
225     {
226         uint256 _pID = pIDxAddr_[msg.sender];
227         if (_pID == 0)
228         {
229             pID_++;
230             _pID = pID_;
231             pIDxAddr_[msg.sender] = _pID;
232             plyr_[_pID].addr = msg.sender;
233         } 
234         return (_pID);
235     }
236 
237     function getExtensionValue()
238         private
239         view
240         returns (uint256)
241     {
242         Datasets.Round _round = round_[rID_];
243         uint256 _extensionEth = _round.investment.mul(extensionThreshold_).div(1000);
244         _extensionEth = _extensionEth >= extensionMin_ ? _extensionEth : extensionMin_;
245         _extensionEth = _extensionEth >= extensionMax_ ? _extensionEth : extensionMax_;
246         return _extensionEth;
247     }
248 
249     function getReferBonus()
250         private
251         view
252         returns (uint256)
253     {
254         uint256 _investment = round_[rID_].investment;
255         uint256 _referBonus = 10;
256         if (_investment >= 25000 ether && _investment < 50000 ether)
257             _referBonus = 20;
258         else if (_investment >= 50000 ether && _investment < 75000 ether)
259             _referBonus = 30;
260         else if (_investment >= 75000 ether && _investment < 100000 ether)
261             _referBonus = 40;
262         else if (_investment >= 100000 ether)
263             _referBonus = 50;
264         return _referBonus;
265     }
266 
267     function endRoundAndGetEarnings(uint256 _pID)
268         private
269     {
270         Datasets.Round _round = round_[rID_];
271         if (_round.investment > pot_.mul(luckyEdge_).div(100) || now > _round.end)
272             endRound();
273 
274         Datasets.Player _plyr = plyr_[_pID];
275         if (_plyr.lrnd == 0)
276             _plyr.lrnd = rID_;
277         uint256 _lrnd = _plyr.lrnd;
278         if (rID_ > 1 && _lrnd != rID_)
279         {
280             uint256 _plyrRoundKeys = plyrRnds_[_pID][_lrnd];
281             if (_plyrRoundKeys > 0 && round_[_lrnd].ppk > 0)
282                 _plyr.luck = _plyr.luck.add(_plyrRoundKeys.mul(round_[_lrnd].ppk).div(magnitude));
283 
284             _plyr.lrnd = rID_;
285         }
286     }
287 
288     function endRound()
289         private
290     {
291         Datasets.Round _round = round_[rID_];
292 
293         if (_round.keys > 0 && _round.investment <= pot_.mul(luckyEdge_).div(100) && now > _round.end)
294         {
295             uint256 _referBonus = getReferBonus();
296             uint256 _ref = pot_.mul(_referBonus).div(100);
297             uint256 _luck = pot_.sub(_ref);
298             _round.ppk = _luck.mul(magnitude).div(_round.keys);
299             pot_ = 0;
300             luckyRounds_++;
301 
302             Referralcontract_.outerDividend.value(_ref)();
303 
304             emit onWinLuckyPrize(rID_);
305         }
306 
307         rID_++;
308         round_[rID_].strt = now;
309         round_[rID_].end = now.add(rndInit_);
310     }
311 
312     function purchaseKeys(uint256 _pID, uint256 _eth)
313         private
314         returns(uint256,bool)
315     {
316         Datasets.Player _plyr = plyr_[_pID];
317         Datasets.Round _round = round_[rID_];
318 
319         if (_eth > 1000000000)
320         {
321             uint256 _luck = _eth.mul(luckyBonus_).div(100);
322             uint256 _amountOfkeys = ethereumTokeys(_eth.sub(_luck));
323             
324             bool _timeExtended = false;
325             if (_eth >= getExtensionValue())
326             {
327                 _round.end = _round.end.add(rndInc_);
328                 if (_round.end > now.add(rndInit_))
329                     _round.end = now.add(rndInit_);
330                 _timeExtended = true;
331             }
332 
333             uint256 _totalKeys = _plyr.keys.add(_amountOfkeys);
334             if (_plyr.keys == 0)
335                 _plyr.keytime = now;
336             else
337                 _plyr.keytime = now.sub(now.sub(_plyr.keytime).mul(_plyr.keys).div(_totalKeys));
338             _plyr.keys = _totalKeys;
339             _plyr.mask = _plyr.mask + (int256)(profitPerShare_.mul(_amountOfkeys).div(magnitude));
340 
341             _round.keys = _round.keys.add(_amountOfkeys);
342             _round.investment = _round.investment.add(_eth);
343 
344             plyrRnds_[_pID][rID_] = plyrRnds_[_pID][rID_].add(_amountOfkeys);
345 
346             keySupply_ = keySupply_.add(_amountOfkeys);
347             totalInvestment_ = totalInvestment_.add(_eth);
348             pot_ = pot_.add(_luck);
349             
350             return (_amountOfkeys,_timeExtended);
351         }
352         return (0,false);
353     }
354 
355     function withdrawEarnings(uint256 _pID)
356         private
357         returns(uint256,uint256)
358     {
359         uint256 _dividends = getPlayerDividends(_pID);
360         uint256 _luckBonus = getPlayerLuckyBonus(_pID);
361 
362         if (_dividends > 0)
363             plyr_[_pID].mask = (int256)(plyr_[_pID].keys.mul(profitPerShare_).div(magnitude));
364         if (_luckBonus > 0)
365             plyr_[_pID].luck = 0;
366 
367         return (_dividends,_luckBonus);
368     }
369 //==============================================================================
370 //   view only functions
371 //==============================================================================
372     function getReferralContract()
373         public
374         view
375         returns(address)
376     {
377         return address(Referralcontract_);
378     }
379 
380     function getBuyPrice(uint256 _keysToBuy)
381         public 
382         view 
383         returns(uint256)
384     {
385         uint256 _amountOfkeys = ethereumTokeys(1e18);
386         return _keysToBuy.mul(magnitude).div(_amountOfkeys);
387     }
388 
389     function getSellPrice(uint256 _keysToSell)
390         public 
391         view 
392         returns(uint256)
393     {
394         require(_keysToSell <= keySupply_, "exceeded the maximum");
395         uint256 _ethereum = keysToEthereum(_keysToSell);
396         uint256 _dividends = _ethereum.mul(sellFee_).div(10000);
397         uint256 _taxedEthereum = _ethereum.sub(_dividends);
398         return _taxedEthereum;
399     }
400 
401     function totalEthereumBalance()
402         public
403         view
404         returns(uint)
405     {
406         return this.balance;
407     }
408 
409     function calcLuckEdge()
410         public
411         view
412         returns(uint256)
413     {
414         return pot_.mul(luckyEdge_).div(100);
415     }
416 
417     function calcSellFee(uint256 _pID)
418         public
419         view
420         returns(uint256)
421     {
422         uint256 _attenuation = now.sub(plyr_[_pID].keytime).div(86400).mul(attenuationFee_);
423         if (_attenuation > 100)
424             _attenuation = 100;
425         uint256 _sellFee = sellFee_.sub(sellFee_.mul(_attenuation).div(100));
426         return _sellFee;
427     }
428 
429     function getPlayerDividends(uint256 _pID)
430         public
431         view
432         returns(uint256)
433     {
434         Datasets.Player _plyr = plyr_[_pID];
435         return (uint256)((int256)(_plyr.keys.mul(profitPerShare_).div(magnitude)) - _plyr.mask);
436     }
437 
438     function getPlayerLuckyBonus(uint256 _pID)
439         public
440         view
441         returns(uint256)
442     {
443         Datasets.Player _plyr = plyr_[_pID];
444         uint256 _lrnd = _plyr.lrnd;
445         Datasets.Round _round = round_[_lrnd];
446         uint256 _plyrRoundKeys = plyrRnds_[_pID][_lrnd];
447         uint256 _luckBonus = _plyr.luck;
448 
449         if (_lrnd != rID_ && _lrnd > 0 && _plyrRoundKeys > 0 && _round.ppk > 0)
450             _luckBonus = _luckBonus.add(_plyrRoundKeys.mul(_round.ppk).div(magnitude));
451 
452         return _luckBonus;
453     }
454 
455     function calcRoundEarnings(uint256 _pID, uint256 _rID)
456         public
457         view
458         returns (uint256)
459     {
460         return plyrRnds_[_pID][_rID].mul(round_[_rID].ppk).div(magnitude);
461     }
462 
463 //==============================================================================
464 //   key calculate
465 //==============================================================================
466     uint256 constant internal keyPriceInitial_ = 0.0000001 ether;
467     uint256 constant internal keyPriceIncremental_ = 0.00000001 ether;
468 
469     function ethereumTokeys(uint256 _ethereum)
470         internal
471         view
472         returns(uint256)
473     {
474         uint256 _keyPriceInitial = keyPriceInitial_ * 1e18;
475         uint256 _keysReceived = 
476          (
477             (
478                 SafeMath.sub(
479                     (SafeMath.sqrt
480                         (
481                             (_keyPriceInitial**2)
482                             +
483                             (2*(keyPriceIncremental_ * 1e18)*(_ethereum * 1e18))
484                             +
485                             (((keyPriceIncremental_)**2)*(keySupply_**2))
486                             +
487                             (2*(keyPriceIncremental_)*_keyPriceInitial*keySupply_)
488                         )
489                     ), _keyPriceInitial
490                 )
491             )/(keyPriceIncremental_)
492         )-(keySupply_)
493         ;
494   
495         return _keysReceived;
496     }
497     
498     function keysToEthereum(uint256 _keys)
499         internal
500         view
501         returns(uint256)
502     {
503         uint256 keys_ = (_keys + 1e18);
504         uint256 _keySupply = (keySupply_ + 1e18);
505         uint256 _etherReceived =
506         (
507             SafeMath.sub(
508                 (
509                     (
510                         (
511                             keyPriceInitial_ +(keyPriceIncremental_ * (_keySupply/1e18))
512                         )-keyPriceIncremental_
513                     )*(keys_ - 1e18)
514                 ),(keyPriceIncremental_*((keys_**2-keys_)/1e18))/2
515             )
516         /1e18);
517         return _etherReceived;
518     }
519 //==============================================================================
520 //   administrator only functions
521 //============================================================================== 
522     function setAdministrator(bytes32 _identifier, bool _status)
523         public
524         onlyAdministrator()
525     {
526         administrators[_identifier] = _status;
527     }
528     
529     function setReferralContract(address _referral)
530         public
531         onlyAdministrator()
532     {
533         require(address(Referralcontract_) == address(0), "silly dev, you already did that");
534         Referralcontract_ = ReferralInterface(_referral);
535     }
536 
537     bool public activated_ = false;
538     function activate()
539         public
540         onlyAdministrator()
541     {
542         require(address(Referralcontract_) != address(0), "must link to Referral Contract");
543         require(activated_ == false, "already activated");
544         
545         activated_ = true;
546         rID_ = 1;
547         round_[rID_].strt = now;
548         round_[rID_].end = now.add(rndInit_);
549 
550         emit onActive();
551     }
552 
553     function updateConfigs(
554         uint16 _sellFee,uint8 _luckyBonus,uint8 _attenuationFee,uint8 _luckyEdge,uint8 _extensionThreshold,
555         uint256 _extensionMin,uint256 _extensionMax,uint256 _rndInit,uint256 _rndInc)
556         public
557         onlyAdministrator()
558     {
559         require(_sellFee >= 0 && _sellFee <= 10000, "out of range.");
560         require(_luckyBonus >= 0 && _luckyBonus <= 100, "out of range.");
561         require(_attenuationFee >= 0 && _attenuationFee <= 100, "out of range.");
562         require(_luckyEdge >= 0 && _luckyEdge <= 100, "out of range.");
563         require(_extensionThreshold >= 0 && _extensionThreshold <= 1000, "out of range.");
564 
565         sellFee_ = _sellFee == 0 ? sellFee_ : _sellFee;
566         luckyBonus_ = _luckyBonus == 0 ? luckyBonus_ : _luckyBonus;
567         attenuationFee_ = _attenuationFee == 0 ? attenuationFee_ : _attenuationFee;
568         luckyEdge_ = _luckyEdge == 0 ? luckyEdge_ : _luckyEdge;
569         extensionThreshold_ = _extensionThreshold == 0 ? extensionThreshold_ : _extensionThreshold;
570         
571         extensionMin_ = _extensionMin == 0 ? extensionMin_ : _extensionMin;
572         extensionMax_ = _extensionMax == 0 ? extensionMax_ : _extensionMax;
573         rndInit_ = _rndInit == 0 ? rndInit_ : _rndInit;
574         rndInc_ = _rndInc == 0 ? rndInc_ : _rndInc;
575     }
576 
577     function administratorInvest()
578         public
579         payable
580         onlyAdministrator()
581     {
582         administratorBalance_ = administratorBalance_.add(msg.value);
583     }
584 
585     function administratorWithdraw(uint256 _eth)
586         public
587         onlyAdministrator()
588     {
589         require(_eth <= administratorBalance_);
590         administratorBalance_ = administratorBalance_.sub(_eth);
591         msg.sender.transfer(_eth);
592     }
593 }
594 
595 interface ReferralInterface {
596     function outerDividend() external payable;
597 }
598 
599 library Datasets {
600     struct Player {
601         address addr;
602         uint256 keys;
603         int256 mask;
604         uint256 luck;
605         uint256 lrnd;
606         uint256 keytime;
607     }
608 
609     struct Round {
610         uint256 strt;
611         uint256 end;
612         uint256 keys;
613         uint256 ppk;
614         uint256 investment;
615     }
616 }
617 
618 library SafeMath {
619     function mul(uint256 a, uint256 b) 
620         internal 
621         pure 
622         returns (uint256 c) 
623     {
624         if (a == 0) {
625             return 0;
626         }
627         c = a * b;
628         require(c / a == b, "SafeMath mul failed");
629         return c;
630     }
631 
632     function div(uint256 a, uint256 b) 
633         internal 
634         pure 
635         returns (uint256) 
636     {
637         uint256 c = a / b;
638         return c;
639     }
640 
641     function sub(uint256 a, uint256 b)
642         internal
643         pure
644         returns (uint256) 
645     {
646         require(b <= a, "SafeMath sub failed");
647         return a - b;
648     }
649 
650     function add(uint256 a, uint256 b)
651         internal
652         pure
653         returns (uint256 c) 
654     {
655         c = a + b;
656         require(c >= a, "SafeMath add failed");
657         return c;
658     }
659     
660     function sqrt(uint256 x)
661         internal
662         pure
663         returns (uint256 y) 
664     {
665         uint256 z = ((add(x,1)) / 2);
666         y = x;
667         while (z < y) 
668         {
669             y = z;
670             z = ((add((x / z),z)) / 2);
671         }
672     }
673     
674     function sq(uint256 x)
675         internal
676         pure
677         returns (uint256)
678     {
679         return (mul(x,x));
680     }
681     
682     function pwr(uint256 x, uint256 y)
683         internal 
684         pure 
685         returns (uint256)
686     {
687         if (x==0)
688             return (0);
689         else if (y==0)
690             return (1);
691         else 
692         {
693             uint256 z = x;
694             for (uint256 i=1; i < y; i++)
695                 z = mul(z,x);
696             return (z);
697         }
698     }
699 }