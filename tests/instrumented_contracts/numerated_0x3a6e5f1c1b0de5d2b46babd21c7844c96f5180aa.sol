1 pragma solidity ^0.4.25;
2 
3 
4 contract SPBevents {
5 
6     // fired whenever theres a withdraw
7     event onWithdraw
8     (
9         uint256 indexed sniperID,
10         address sniperAddress,
11         uint256 ethOut,
12         uint256 timeStamp
13     );
14 
15     // fired whenever an affiliate is paid
16     event onAffiliatePayout
17     (
18         uint256 indexed affiliateID,
19         uint256 indexed roundID,
20         uint256 indexed buyerID,
21         uint256 amount,
22         uint256 timeStamp
23     );
24     
25     // fired whenever a sniper get a random number
26     event onCheckMainpot
27     (
28         uint256 indexed randomNumber,
29         uint256 indexed roundID,
30         address indexed sniperAddress,
31         uint256 timeStamp
32     );
33     
34     // fired whenever a sniper get a random number
35     event onCheckLuckypot
36     (
37         uint256 indexed randomNumber,
38         uint256 indexed roundID,
39         address indexed sniperAddress,
40         uint256 timeStamp
41     );
42     
43     // fired whenever a sniper get a random number
44     event onCheckKingpot
45     (
46         uint256 indexed randomNumber,
47         address indexed sniperAddress,
48         uint256 indexed roundID,
49         uint256 timeStamp
50     );
51     
52     // fired whenever a sniper get a random number hit the exact same numbers that other snipers have
53     event onCheckHitNumber
54     (
55         uint256 indexed randomNumber,
56         uint256 indexed beingHitSniperID,
57         address indexed firedSniperAddress,
58         uint256 roundID,
59         uint256 timeStamp
60     );
61     
62     // fired whenever a sniper send eth
63     event onEndTx
64     (
65         uint256 sniperID,
66         uint256 ethIn,
67         uint256 number,
68         uint256 laffID,
69         uint256 timeStamp
70     );
71     
72     // fired whenever a sniper send eth for ICO
73     event onICOAngel
74     (
75         address indexed whoInvest,
76         uint256 amount,
77         uint256 timeStamp
78     );
79     
80     event onOEZDay
81     (
82         uint256 amount,
83         uint256 timeStamp
84     );
85 }
86 
87 contract modularBillion is SPBevents {}
88 
89 contract SniperBillion is modularBillion {
90     
91     using SafeMath for *;
92     using Array256Lib for uint256[];
93    
94     
95     address constant private comReward_ = 0x8Aa94D530cC572aF0C730147E1ab76875F25f71C;
96     address constant private comMarket_ = 0x6c14CAAc549d7411faE4e201105B4D33afb8a3db;
97     address constant private comICO_ = 0xbAdb636C5C3665a969159a6b993F811D9F263639;
98     address constant private donateAccount_ =  0x1bB064708eBf4763BeB495877E99Dfeb75198942;
99     
100     RubyFundForwarderInterface constant private Ruby_Fund = RubyFundForwarderInterface(0x7D653E0Ecb4DAF3166a49525Df04147a7180B051);
101     SniperBookInterface constant private SniperBook = SniperBookInterface(0xc294FA45F713B09d865A088543765800F47514eD);
102 
103     string constant public name   = "Sniper Billion Official";
104     string constant public symbol = "SPB";
105     
106 
107     uint256 constant private icoEndTime_ = 24 hours;   // ICO timer end at this
108     uint256 constant private maxNumber_  = 100000000; // 100,000,000 - 100 million
109 
110     uint256 public totalSum_;
111     uint256 public rID_;
112     uint256 public icoAmount_;
113     
114     bool private isDrawed_ = false;
115     uint256 lastSID_;
116     
117     uint256[] private globalArr_;
118     uint256[] private icoSidArr_;            
119     uint256[] private luckyPotBingoArr_;
120     uint256[] private airdropPotBingoArr_;
121     
122     //****************
123     // SNIPER DATA 
124     //****************
125     mapping (address => uint256) public sIDxAddr_;          // (addr => sID) returns sniper id by address
126     mapping (bytes32 => uint256) public sIDxName_;          // (name => sID) returns sniper id by name
127     mapping (uint256 => uint256) public sidXnum_;           // (number => sID) returns sniper id by random number;
128 
129     mapping (uint256 => SPBdatasets.Sniper) public spr_;   // (sID => data) sniper data
130     mapping (uint256 => SPBdatasets.Round) public round_;
131     mapping (uint256 => mapping (bytes32 => bool)) public sprNames_; // (sID => name => bool) list of names a sniper owns.
132     
133     
134     constructor()
135         public 
136     {
137         //does nothing
138     }
139 
140     /**
141      * @dev used to make sure no one can interact with contract until it has 
142      * been activated. 
143      */
144     modifier isActivated() {
145         require(activated_ == true, "its not ready yet.  check our discord"); 
146         _;
147     }
148 
149     /**
150      * @dev prevents contracts from interacting with Sniper Billion Game 
151      */
152     modifier isHuman() {
153         require(tx.origin == msg.sender, "sorry humans only");
154         _;
155     }
156 
157     /**
158      * @dev sets boundaries for incoming tx 
159      */
160     modifier isWithinLimits(uint256 _eth) {
161         require(_eth >= 100000000000000000, "pocket lint: not a valid currency");
162         require(_eth <= 100000000000000000000000, "no vitalik, no");
163         _;    
164     }
165     
166     /**
167      * @dev check boundaries for ico time 
168      */
169     modifier isIcoPhase() {
170         require(now < round_[1].icoend, "ico end");
171         _;
172     }
173     
174     /**
175      * @dev after the ICO ends, the game begins
176      */
177     modifier isGameStart() {
178         require(now > round_[rID_].icoend, "start");
179         _;
180     }
181     
182     /**
183      * @dev sets boundaries for ico
184      */
185     modifier isWithinIcoLimits(uint256 _eth) {
186         require(_eth >= 1000000000000000000, "pocket lint: not a valid currency");
187         require(_eth <= 200000000000000000000, "ico up to 200 Ether");
188         _;    
189     }
190     
191     /**
192      * @dev emergency buy uses last stored affiliate ID
193      */
194     function()
195         isActivated()
196         isHuman()
197         isWithinLimits(msg.value)
198         isGameStart()
199         payable
200         external
201     {
202         // determine if sniper is new or not
203         determineSID();
204             
205         // fetch sniper id
206         uint256 _sID = sIDxAddr_[msg.sender];
207         
208         // buy core 
209         buyCore(_sID, spr_[_sID].laff);
210     }
211     
212     function buyXaddr(address _affCode)
213         public
214         isActivated()
215         isHuman()
216         isWithinLimits(msg.value)
217         isGameStart()
218         payable
219     {
220         // determine if sniper is new or not
221         determineSID();
222         
223         // fetch player id
224         uint256 _sID = sIDxAddr_[msg.sender];
225         
226         // manage affiliate residuals
227         uint256 _affID;
228         // if no affiliate code was given or player tried to use their own, lolz
229         if (_affCode == address(0) || _affCode == msg.sender)
230         {
231             // use last stored affiliate code
232             _affID = spr_[_sID].laff;
233         
234         // if affiliate code was given    
235         } else {
236             // get affiliate ID from aff Code 
237             _affID = sIDxAddr_[_affCode];
238             
239             // if affID is not the same as previously stored 
240             if (_affID != spr_[_sID].laff)
241             {
242                 // update last affiliate
243                 spr_[_sID].laff = _affID;
244             }
245         }
246         
247 
248         // if no affiliate code was given or player tried to use their own, lolz
249         if (_affCode == address(0) || _affCode == msg.sender)
250         {
251             // use last stored affiliate code
252             _affID = spr_[_sID].laff;
253         
254         // if affiliate code was given    
255         } else {
256             // get affiliate ID from aff Code 
257             _affID = sIDxAddr_[_affCode];
258             
259             // if affID is not the same as previously stored 
260             if (_affID != spr_[_sID].laff)
261             {
262                 // update last affiliate
263                 spr_[_sID].laff = _affID;
264             }
265         }
266 
267         // buy core 
268         buyCore(_sID, _affID);
269     }
270 
271 
272     function becomeSniperAngel()
273         public
274         isActivated()
275         isHuman()
276         isIcoPhase()
277         isWithinIcoLimits(msg.value)
278         payable
279     {
280         // determine if sniper is new or not
281         determineSID();
282         
283         
284         // fetch sniper id
285         uint256 _sID = sIDxAddr_[msg.sender];
286         
287         spr_[_sID].icoAmt = spr_[_sID].icoAmt.add(msg.value); 
288         
289         icoSidArr_.push(_sID);
290         
291         //ico amount 80% to mainpot
292         round_[1].mpot = round_[1].mpot.add((msg.value / 100).mul(80));
293         
294         //total ICO amount
295         icoAmount_ = icoAmount_.add(msg.value);
296         
297         //ico amount 20% to community.
298         uint256 _icoEth = (msg.value / 100).mul(20);
299         
300         if(_icoEth > 0)
301             comICO_.transfer(_icoEth);
302             
303         emit onICOAngel(msg.sender, msg.value, block.timestamp);
304     }
305     
306 
307     /**
308      * @dev withdraws all of your earnings.
309      * -functionhash- 
310      */
311     function withdraw()
312         public
313         isActivated()
314         isHuman()
315     {
316         // grab time
317         uint256 _now = now;
318         
319         // fetch player ID
320         uint256 _sID = sIDxAddr_[msg.sender];
321         
322 
323         // get their earnings
324        uint256 _eth = withdrawEarnings(_sID);
325         
326         // gib moni
327         if (_eth > 0)
328             spr_[_sID].addr.transfer(_eth);
329         
330         // fire withdraw event
331         emit SPBevents.onWithdraw(_sID, msg.sender, _eth, _now);
332         
333     }
334     
335 
336     function withdrawEarnings(uint256 _sID)
337         private
338         returns(uint256)
339     {
340 
341         // from vaults 
342         uint256 _earnings = (spr_[_sID].win).add(spr_[_sID].gen).add(spr_[_sID].aff).add(spr_[_sID].gems);
343         if (_earnings > 0)
344         {
345             spr_[_sID].win = 0;
346             spr_[_sID].gen = 0;
347             spr_[_sID].aff = 0;
348             spr_[_sID].gems = 0;
349         }
350 
351         return(_earnings);
352     }
353 
354     function generateRandom()
355         private
356         view
357         returns(uint256)
358     {
359         uint256 seed = uint256(keccak256(abi.encodePacked(
360             (block.timestamp).add
361             (block.difficulty).add
362             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
363             (block.gaslimit).add
364             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
365             (block.number)
366         )));
367         seed = seed - ((seed / 100000000) * 100000000) + 1;
368         return seed;
369     }
370 
371     function itemRemove(uint256[] storage self, uint256 index) private {
372         if (index >= self.length) return;
373 
374         for (uint256 i = index; i < self.length - 1; i++){
375             self[i] = self[i+1];
376         }
377         self.length--;
378     }
379 
380     /**
381      * @dev logic runs whenever a buy order is executed.
382      */
383     function buyCore(uint256 _sID, uint256 _affID)
384         private
385     {
386         uint256 _rID = rID_;
387  
388         //If the sniper does not enter the game through the affiliate, then 10% is paid to the team, 
389         //otherwise, paid to the affiliate.
390 
391         if(_affID == 0 && spr_[_sID].laff == 0) {
392             emit onAffiliatePayout(4, _rID, _sID, msg.value, now);
393             core(_rID, _sID, msg.value, 4);
394         }else{
395             emit onAffiliatePayout(_affID, _rID, _sID, msg.value, now);
396             core(_rID, _sID, msg.value, _affID);
397         }
398 
399     }
400 
401 
402     /**
403      * @dev this is the core logic for any buy that happens.
404      */
405     function core(uint256 _rID, uint256 _sID, uint256 _eth, uint256 _affID)
406         private
407     {
408         uint256 _now = block.timestamp;
409 
410         uint256 _value = _eth;
411         uint256 _laffRearwd = _value / 10;
412         
413         //affiliate sniper
414         spr_[_affID].aff = spr_[_affID].aff.add(_laffRearwd);
415         
416         //set sniper last affiliate id;
417         spr_[_sID].laff = _affID;
418         spr_[_sID].lplyt = _now;
419 
420         _value = _value.sub(_laffRearwd);
421 
422         uint256 _rndFireNum = generateRandom();
423         
424         emit onEndTx(_sID, _eth, _rndFireNum, _affID, _now);
425         
426         round_[_rID].ltime = _now;
427 
428         bool _isBingoLp = false;
429         bool _isBingoKp = false;
430 
431         if(globalArr_.length != 0){
432             if(globalArr_.length == 1)
433             {
434                 globalArrEqualOne(_rID, _sID, _value, _rndFireNum);
435             }else{
436                 globalArrNotEqualOne(_rID, _sID, _value, _rndFireNum);
437             }
438         }else{
439 
440             globalArrEqualZero(_rID, _sID, _value, _rndFireNum);
441             
442         }
443         _isBingoLp = calcBingoLuckyPot(_rndFireNum);
444         
445         //bingo luckypot
446         if(_isBingoLp){
447             spr_[_sID].win = spr_[_sID].win.add(round_[_rID].lpot);
448             round_[_rID].lpot = 0;
449             emit onCheckLuckypot(_rndFireNum, _rID, spr_[_sID].addr, block.timestamp);
450         }
451 
452         //bingo kingpot
453         if(_eth >= 500000000000000000){
454             _isBingoKp = calcBingoAirdropPot(_rndFireNum);
455             
456             if(_isBingoKp){
457                 spr_[_sID].win = spr_[_sID].win.add(round_[_rID].apot);
458                 round_[_rID].apot = 0;
459                 emit onCheckKingpot(_rndFireNum, spr_[_sID].addr, _rID, block.timestamp);
460             }
461         }
462         
463         //win mainpot
464         checkWinMainPot(_rID, _sID, _rndFireNum);
465         
466         //surprise mother fuck
467         autoDrawWithOEZDay();
468     }
469     
470     /**
471      * @dev If the game is too crazy, the first draw will not be available for 180 days, 
472      * and the contract will be automatically assigned to ensure the benefit of everyone. 
473      * If the prize is opened once in 180 days, this setting is invalid.
474      */
475     
476     function autoDrawWithOEZDay()
477         private
478     {
479         uint256 _oezDay = round_[rID_].strt + 180 days;
480         if(!isDrawed_ && now > _oezDay){
481             
482             totalSum_ = 0;
483 
484             // If an ICO investor exists
485             // ico         30%
486             // team        30%
487             // all sniper  30%
488             // marketing    5%
489             // donate       5%
490             
491             // If the ICO investor does not exist
492             // team        30%
493             // all sniper  60%
494             // marketing    5%
495             // donate       5%
496             
497             uint256 _cttBalance = round_[rID_].mpot.add(round_[rID_].lpot).add(round_[rID_].apot);
498             
499             
500             uint256 _communityRewards = (_cttBalance / 100).mul(30);
501             
502             if(_communityRewards > 0)
503                 comReward_.transfer(_communityRewards);
504                 
505             uint256 _sniperDividend;
506             
507         
508             if(icoAmount_ > 0){
509                 // sniper dividend 30%
510                 _sniperDividend = (_cttBalance / 100).mul(30);
511                 //ico 30%
512                 uint256 _icoValue = (_cttBalance / 100).mul(30);
513                 distributeICO(_icoValue);
514             }else{
515                 // sniper dividend 60%
516                 _sniperDividend = (_cttBalance / 100).mul(60);
517             }
518             
519             
520             //each piece
521             uint256 _eachPiece = _sniperDividend / lastSID_;
522             
523             for(uint256 i = 1; i < lastSID_; i++)
524             {
525                 spr_[i].win = spr_[i].win.add(_eachPiece);
526             }
527             
528             
529             //marketing 5% & donate 5%
530             uint256 _communityMarket = (_cttBalance / 100).mul(5);
531             if(_communityMarket > 0){
532                 comMarket_.transfer(_communityMarket);
533                 donateAccount_.transfer(_communityMarket);
534             }
535             
536             emit onOEZDay(_cttBalance, now);
537             
538             round_[rID_].mpot = 0;
539             round_[rID_].lpot = 0;
540             round_[rID_].apot = 0;
541             
542             uint256 _icoEndTime = round_[rID_].icoend;
543             
544             rID_++;
545             
546             round_[rID_].strt = now;
547             round_[rID_].icoend = _icoEndTime;
548             
549         }
550     }
551     
552     function globalArrEqualZero(uint256 _rID, uint256 _sID, uint256 _value, uint256 _rndFireNum)
553         private
554     {
555         round_[_rID].mpot = round_[_rID].mpot.add(((_value / 2) / 100).mul(90));
556         round_[_rID].lpot = round_[_rID].lpot.add(((_value / 2) / 100).mul(5));
557         round_[_rID].apot = round_[_rID].apot.add(((_value / 2) / 100).mul(5));
558         
559         sidXnum_[_rndFireNum] = _sID;
560         
561         spr_[_sID].numbers.push(_rndFireNum);
562         spr_[_sID].snums++;
563         spr_[_sID].gen = spr_[_sID].gen.add(_value / 2);
564         globalArr_.push(_rndFireNum);
565         
566         totalSum_ = totalSum_.add(_rndFireNum);
567     }
568 
569     function globalArrNotEqualOne(uint256 _rID, uint256 _sID, uint256 _value, uint256 _rndFireNum)
570         private
571     {
572         uint256 _opID = sidXnum_[globalArr_[0]];
573         bool _found = false;
574         uint256 _index = 0;
575 
576         (_found, _index) = globalArr_.indexOf(_rndFireNum, false);
577         _opID = sidXnum_[_rndFireNum];
578         
579         
580 
581         if(_found){
582 
583             (_found, _index) = spr_[_opID].numbers.indexOf(_rndFireNum, false);
584             
585             itemRemove(spr_[_opID].numbers, _index);
586 
587             spr_[_opID].snums--;
588             
589             sidXnum_[_rndFireNum] = _sID;
590             
591             spr_[_sID].snums++;
592             spr_[_sID].numbers.push(_rndFireNum);
593             
594             spr_[_opID].win = spr_[_opID].win.add(_value);
595             
596             emit onCheckHitNumber(_rndFireNum, _opID, spr_[_sID].addr, _rID, block.timestamp);
597     
598         }else{
599             round_[_rID].mpot = round_[_rID].mpot.add(((_value / 2) / 100).mul(90));
600             round_[_rID].lpot = round_[_rID].lpot.add(((_value / 2) / 100).mul(5));
601             round_[_rID].apot = round_[_rID].apot.add(((_value / 2) / 100).mul(5));
602 
603             globalArr_.push(_rndFireNum);
604             globalArr_.heapSort();
605             (_found, _index) = globalArr_.indexOf(_rndFireNum, true);
606 
607             if(_index == 0){
608                 _opID = sidXnum_[globalArr_[_index + 1]];
609                 
610                 spr_[_opID].win = spr_[_opID].win.add(((_value / 2) / 100).mul(50));
611             
612                 
613                 spr_[_sID].snums++;
614                 spr_[_sID].numbers.push(_rndFireNum);
615                 spr_[_sID].gen = spr_[_sID].gen.add(((_value / 2) / 100).mul(50));
616                 
617                 sidXnum_[_rndFireNum] = _sID;
618                 
619             }else if(_index == globalArr_.length - 1){
620                 _opID = sidXnum_[globalArr_[_index -1]];
621                 
622                 spr_[_opID].win = spr_[_opID].win.add(((_value / 2) / 100).mul(50));
623                 
624                 spr_[_sID].snums++;
625                 spr_[_sID].numbers.push(_rndFireNum);
626                 spr_[_sID].gen = spr_[_sID].gen.add(((_value / 2) / 100).mul(50));
627                 
628                 sidXnum_[_rndFireNum] = _sID;
629                 
630             }else{
631                 uint256 _leftSID = sidXnum_[globalArr_[_index - 1]];
632                 uint256 _rightSID = sidXnum_[globalArr_[_index + 1]];
633                 
634                 spr_[_leftSID].win = spr_[_leftSID].win.add(((_value / 2) / 100).mul(50));
635                 spr_[_rightSID].win = spr_[_rightSID].win.add(((_value / 2) / 100).mul(50));
636                 
637                 spr_[_sID].snums++;
638                 spr_[_sID].numbers.push(_rndFireNum);
639                 
640                 
641                 sidXnum_[_rndFireNum] = _sID;
642             }
643             
644             
645                 
646         }
647         
648         totalSum_ = totalSum_.add(_rndFireNum);
649     }
650 
651     function globalArrEqualOne(uint256 _rID, uint256 _sID, uint256 _value, uint256 _rndFireNum)
652         private
653     {
654         uint256 _opID = sidXnum_[globalArr_[0]];
655         bool _found = false;
656         uint256 _index = 0;
657         if(globalArr_[0] != _rndFireNum)
658         {
659             
660             round_[_rID].mpot = round_[_rID].mpot.add(((_value / 2) / 100).mul(90));
661             round_[_rID].lpot = round_[_rID].lpot.add(((_value / 2) / 100).mul(5));
662             round_[_rID].apot = round_[_rID].apot.add(((_value / 2) / 100).mul(5));
663             
664             sidXnum_[_rndFireNum] = _sID;
665             
666             spr_[_opID].win = spr_[_opID].win.add((_value / 4));
667             
668             spr_[_sID].snums++;
669             spr_[_sID].numbers.push(_rndFireNum);
670             spr_[_sID].gen = spr_[_sID].gen.add((_value / 4));
671     
672             globalArr_.push(_rndFireNum);
673         }else{
674             spr_[_opID].win = spr_[_opID].win.add(_value);
675             
676             (_found, _index) = spr_[_opID].numbers.indexOf(_rndFireNum, false);
677         
678             itemRemove(spr_[_opID].numbers, _index);
679 
680             sidXnum_[_rndFireNum] = _sID;
681             
682             spr_[_opID].snums--;
683 
684             spr_[_sID].snums++;
685             spr_[_sID].numbers.push(_rndFireNum);
686             
687             emit onCheckHitNumber(_rndFireNum, _opID, spr_[_sID].addr, _rID, block.timestamp);
688             
689         }
690         
691         totalSum_ = totalSum_.add(_rndFireNum);
692     }
693     
694     function checkLuckyPot(uint256 _rndFireNum) private returns(uint256){
695         delete luckyPotBingoArr_;
696         uint256 number = _rndFireNum;
697         uint returnNum = number;
698         while (number > 0) {
699             uint256 digit = uint8(number % 10); 
700             number = number / 10;
701  
702             luckyPotBingoArr_.push(digit);
703         }
704 
705         return returnNum;
706     }
707     
708     function checkAirdropPot(uint256 _rndFireNum) private returns(uint256){
709         delete airdropPotBingoArr_;
710         uint256 number = _rndFireNum;
711         uint returnNum = number;
712         while (number > 0) {
713             uint256 digit = uint8(number % 10); 
714             number = number / 10;
715 
716             airdropPotBingoArr_.push(digit);
717         }
718 
719         return returnNum;
720     }
721     
722     function getDigit(uint256 x) private view returns (uint256) {
723         return luckyPotBingoArr_[x];
724     }
725     
726 
727     function calcBingoLuckyPot(uint256 _rndFireNum)
728         private
729         returns(bool)
730     {
731         
732         bool _isBingoLucky = false;
733         checkLuckyPot(_rndFireNum);
734         uint256 _flag;
735 
736         if(luckyPotBingoArr_.length > 1) {
737             for(uint256 i = 0; i < luckyPotBingoArr_.length; i++){
738                 if(luckyPotBingoArr_[0] == getDigit(i)){
739                     _flag++;
740                 }
741             }
742         }
743 
744         if(_flag == luckyPotBingoArr_.length && _flag != 0 && luckyPotBingoArr_.length != 0){
745             _isBingoLucky = true;
746         }
747 
748         return(_isBingoLucky);
749     }
750 
751     function calcBingoAirdropPot(uint256 _rndFireNum) private returns(bool) {
752         bool _isBingoAirdrop = false;
753         checkAirdropPot(_rndFireNum);
754         uint256 _temp;
755         
756         if(airdropPotBingoArr_.length > 1) {
757             
758             airdropPotBingoArr_.heapSort();
759             
760             _temp = airdropPotBingoArr_[0];
761             
762             for(uint256 i = 0; i < airdropPotBingoArr_.length; i++){
763                 if(i == 0 || airdropPotBingoArr_[i] == _temp.add(i)){         
764                     _isBingoAirdrop = true;
765                 }else{
766                     _isBingoAirdrop = false;
767                     break;
768                 }
769                 
770             }
771         }
772 
773         return(_isBingoAirdrop);
774     }
775 
776     function checkWinMainPot(uint256 _rID, uint256 _sID, uint256 _rndFireNum) private {
777         if(totalSum_ == maxNumber_){
778             
779             isDrawed_ = true;
780             
781             totalSum_ = 0;
782 
783             spr_[_sID].snums = 0;
784             delete spr_[_sID].numbers;
785             
786             // winer 48%
787             // next round 20%
788             // ico 20%
789             // marketing 1%
790             // donate 1%
791             // team 10%
792             
793             uint256 _nextMpot;
794             uint256 _nextLpot = round_[_rID].lpot;
795             uint256 _nextApot = round_[_rID].apot;
796             uint256 _icoEndTime = round_[_rID].icoend;
797    
798             //If no one is involved in the ICO, 20% of the ICO will be allocated, 10% of which will be allocated to the community and 10% to the next round.
799             
800             uint256 _communityRewards;
801             
802             if(icoAmount_ > 0){
803                 //next round 20%
804                 _nextMpot = (round_[_rID].mpot / 100).mul(20);
805                 // team 10%
806                 _communityRewards = (round_[_rID].mpot / 100).mul(10);
807             }else{
808                 //next round 30%
809                 _nextMpot = (round_[_rID].mpot / 100).mul(30);
810                 // team 20%
811                 _communityRewards = (round_[_rID].mpot / 100).mul(20);
812             }
813             
814             if(_communityRewards > 0)
815                 comReward_.transfer(_communityRewards);
816             
817             spr_[_sID].win = spr_[_sID].win.add((round_[rID_].mpot / 100).mul(48));
818             
819             //marketing 1% & donate 1%
820             uint256 _communityMarket = (round_[_rID].mpot / 100).mul(1);
821             if(_communityMarket > 0){
822                 comMarket_.transfer(_communityMarket);
823                 donateAccount_.transfer(_communityMarket);
824             }
825             
826             
827             emit onCheckMainpot(_rndFireNum, _rID, spr_[_sID].addr, block.timestamp);
828             
829             //ico 20%
830             if(icoAmount_ > 0){
831                 uint256 _icoValue = (round_[_rID].mpot / 100).mul(20);
832                 distributeICO(_icoValue);
833             }
834             
835             round_[rID_].mpot = 0;
836             round_[rID_].lpot = 0;
837             round_[rID_].apot = 0;
838             
839             rID_++;
840 
841             round_[rID_].strt = now;
842             round_[rID_].mpot = _nextMpot;
843             round_[rID_].lpot = _nextLpot;
844             round_[rID_].apot = _nextApot;
845             round_[rID_].icoend = _icoEndTime;
846             
847         }else{
848 
849             if(totalSum_ > maxNumber_){
850                 uint256 _overNum = totalSum_.sub(maxNumber_);
851                 totalSum_ = maxNumber_.sub(_overNum);
852             }
853             
854         }
855     }
856 
857     function distributeICO(uint256 _icoValue)
858         private
859     {
860         for(uint256 i = 0; i < icoSidArr_.length; i++){
861 
862             uint256 _ps = percent(spr_[icoSidArr_[i]].icoAmt, icoAmount_, 4);
863             uint256 _rs = _ps.mul(_icoValue) / 10000;
864             spr_[icoSidArr_[i]].gems = spr_[icoSidArr_[i]].gems.add(_rs);
865         }
866     }
867     
868     function percent(uint256 numerator, uint256 denominator, uint256 precision) private pure returns(uint256 quotient) {
869 
870          // caution, check safe-to-multiply here
871         uint256 _numerator  = numerator * 10 ** (precision+1);
872         // with rounding of last digit
873         uint256 _quotient =  ((_numerator / denominator) + 5) / 10;
874         return ( _quotient);
875    }
876 
877 
878     /**
879      * @dev gets existing or registers new sID.  use this when a sniper may be new
880      * @return sID 
881      */
882     function determineSID()
883         private
884     {
885         uint256 _sID = sIDxAddr_[msg.sender];
886         // if sniper is new to this version of H1M
887         if (_sID == 0)
888         {
889             // grab their sniper ID, name and last aff ID, from sniper names contract 
890             _sID = SniperBook.getSniperID(msg.sender);
891             lastSID_ = _sID;
892             bytes32 _name = SniperBook.getSniperName(_sID);
893             uint256 _laff = SniperBook.getSniperLAff(_sID);
894             
895             // set up sniper account 
896             sIDxAddr_[msg.sender] = _sID;
897             spr_[_sID].addr = msg.sender;
898             
899             if (_name != "")
900             {
901                 sIDxName_[_name] = _sID;
902                 spr_[_sID].name = _name;
903                 sprNames_[_sID][_name] = true;
904             }
905             
906             if (_laff != 0 && _laff != _sID)
907                 spr_[_sID].laff = _laff;
908             
909         }
910     }
911 
912 
913     /**
914      *  for UI
915      */
916      
917     function getTotalSum()
918         public
919         isHuman()
920         view
921         returns(uint256)
922     {
923         return(totalSum_);
924     }
925     
926     function getCurrentRoundInfo()
927         public
928         isHuman()
929         view
930         returns(uint256, uint256, uint256, uint256, uint256, uint256[] memory)
931     {
932         
933         return(rID_, totalSum_, round_[rID_].lpot, round_[rID_].mpot, round_[rID_].apot, globalArr_);
934     }
935     
936     function getSniperInfo(address _addr)
937         public
938         isHuman()
939         view
940         returns(uint256[] memory, uint256, uint256, uint256, uint256,  uint256)
941     {
942         
943         return(spr_[sIDxAddr_[_addr]].numbers, spr_[sIDxAddr_[_addr]].aff, spr_[sIDxAddr_[_addr]].win, spr_[sIDxAddr_[_addr]].gems, spr_[sIDxAddr_[_addr]].gen, spr_[sIDxAddr_[_addr]].icoAmt);
944     }
945     
946     function getSID(address _addr)
947         public
948         isHuman()
949         view
950         returns(uint256)
951     {
952         
953         return(sIDxAddr_[_addr]);
954     }
955     
956     function getGameTime()
957         public
958         isHuman()
959         view
960         returns(uint256, uint256, bool)
961     {
962         bool _icoOff = false;
963         if(now > round_[1].icoend && activated_){
964             _icoOff = true;
965         }
966         return(round_[1].icoend, icoAmount_, _icoOff);
967     }
968 
969     /** upon contract deploy, it will be deactivated.  this is a one time
970      * use function that will activate the contract.  we do this so devs 
971      * have time to set things up on the web end                            **/
972     bool public activated_ = false;
973     function activate()
974         public
975     {
976         // only luckyteam can activate 
977         require(
978             msg.sender == 0x461f346C3B3D401A5f9Fef44bAB704e96abC926F ||
979             msg.sender == 0x727fE77FFDf8D40F34f641DfB358d9856F9563cA ||
980             msg.sender == 0x3b300189AfA703372022Ca97C64FaA27AdA05238 ||
981             msg.sender == 0x4b95DE2f5E202b59B22a0EcCf6A7C2aa5578Ee4D ||
982 			msg.sender == 0x9f01209Fb1FA757cF6025C2aBf17b847408deDE5,
983             "only luckyteam can activate"
984         );
985         
986         // make sure comReward its been linked.
987         require(address(comReward_) != address(0), "must link to comReward address");
988         
989         // make sure comMarket its been linked.
990         require(address(comMarket_) != address(0), "must link to comMarket address");
991 
992         // make sure comICO its been linked.
993         require(address(comICO_) != address(0), "must link to comICO address");
994         
995         // make sure donateAccount its been linked.
996         require(address(donateAccount_) != address(0), "must link to donateAccount address");
997         
998         // can only be ran once
999         require(activated_ == false, "H1M already activated");
1000         
1001         // activate the contract 
1002         activated_ = true;
1003         
1004         // lets start first round
1005 		rID_ = 1;
1006         round_[1].strt = now;
1007         round_[1].icostrt = now;
1008         round_[1].icoend = now + icoEndTime_;
1009     }
1010     
1011     function receiveSniperInfo(uint256 _sID, address _addr, bytes32 _name, uint256 _laff)
1012         external
1013     {
1014         require (msg.sender == address(SniperBook), "your not playerNames contract... hmmm..");
1015         if (sIDxAddr_[_addr] != _sID)
1016             sIDxAddr_[_addr] = _sID;
1017         if (sIDxName_[_name] != _sID)
1018             sIDxName_[_name] = _sID;
1019         if (spr_[_sID].addr != _addr)
1020             spr_[_sID].addr = _addr;
1021         if (spr_[_sID].name != _name)
1022             spr_[_sID].name = _name;
1023         if (spr_[_sID].laff != _laff)
1024             spr_[_sID].laff = _laff;
1025         if (sprNames_[_sID][_name] == false)
1026             sprNames_[_sID][_name] = true;
1027     }
1028     
1029     /**
1030      * @dev receives entire player name list 
1031      */
1032     function receiveSniperNameList(uint256 _sID, bytes32 _name)
1033         external
1034     {
1035         require (msg.sender == address(SniperBook), "your not playerNames contract... hmmm..");
1036         if(sprNames_[_sID][_name] == false)
1037             sprNames_[_sID][_name] = true;
1038     }   
1039 
1040 }
1041 
1042 library SPBdatasets {
1043     
1044     struct Round {
1045         uint256 strt;    // time round started
1046         uint256 icostrt; // time ico started
1047         uint256 icoend;  // time ico ended;
1048         uint256 ltime;   // last buy time.
1049         uint256 apot;    // airdrop pot;
1050         uint256 lpot;    // lucky pot;
1051         uint256 mpot;    // main pot paid to winner
1052     }
1053     
1054     struct Sniper {
1055         address addr;   // player address
1056         bytes32 name;   // player name
1057         uint256 win;    // winnings vault
1058         uint256 gen;    // general vault
1059         uint256 aff;    // affiliate vault
1060         uint256 lplyt;  // last played time
1061         uint256 laff;   // last affiliate id used
1062         uint256 snums;
1063         uint256 icoAmt; // sniper ico amount
1064         uint256 gems;
1065         uint256[] numbers; //
1066     }
1067 }
1068 
1069 
1070 interface RubyFundForwarderInterface {
1071     function deposit() external payable returns(bool);
1072     function status() external view returns(address, address, bool);
1073     function startMigration(address _newCorpBank) external returns(bool);
1074     function cancelMigration() external returns(bool);
1075     function finishMigration() external returns(bool);
1076     function setup(address _firstCorpBank) external;
1077 }
1078 
1079 interface SniperBookInterface {
1080     function getSniperID(address _addr) external returns (uint256);
1081     function getSniperName(uint256 _sID) external view returns (bytes32);
1082     function getSniperLAff(uint256 _sID) external view returns (uint256);
1083     function getSniperAddr(uint256 _sID) external view returns (address);
1084     function getNameFee() external view returns (uint256);
1085     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
1086     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
1087     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
1088 }
1089 
1090 /**
1091  * @title SafeMath v0.1.9
1092  * @dev Math operations with safety checks that throw on error
1093  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
1094  * - added sqrt
1095  * - added sq
1096  * - added pwr 
1097  * - changed asserts to requires with error log outputs
1098  * - removed div, its useless
1099  */
1100 library SafeMath {
1101     
1102     /**
1103     * @dev Multiplies two numbers, throws on overflow.
1104     */
1105     function mul(uint256 a, uint256 b) 
1106         internal 
1107         pure 
1108         returns (uint256 c) 
1109     {
1110         if (a == 0) {
1111             return 0;
1112         }
1113         c = a * b;
1114         require(c / a == b, "SafeMath mul failed");
1115         return c;
1116     }
1117 
1118     /**
1119     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1120     */
1121     function sub(uint256 a, uint256 b)
1122         internal
1123         pure
1124         returns (uint256) 
1125     {
1126         require(b <= a, "SafeMath sub failed");
1127         return a - b;
1128     }
1129 
1130     /**
1131     * @dev Adds two numbers, throws on overflow.
1132     */
1133     function add(uint256 a, uint256 b)
1134         internal
1135         pure
1136         returns (uint256 c) 
1137     {
1138         c = a + b;
1139         require(c >= a, "SafeMath add failed");
1140         return c;
1141     }
1142     
1143     /**
1144      * @dev gives square root of given x.
1145      */
1146     function sqrt(uint256 x)
1147         internal
1148         pure
1149         returns (uint256 y) 
1150     {
1151         uint256 z = ((add(x,1)) / 2);
1152         y = x;
1153         while (z < y) 
1154         {
1155             y = z;
1156             z = ((add((x / z),z)) / 2);
1157         }
1158     }
1159     
1160     /**
1161      * @dev gives square. multiplies x by x
1162      */
1163     function sq(uint256 x)
1164         internal
1165         pure
1166         returns (uint256)
1167     {
1168         return (mul(x,x));
1169     }
1170     
1171     /**
1172      * @dev x to the power of y 
1173      */
1174     function pwr(uint256 x, uint256 y)
1175         internal 
1176         pure 
1177         returns (uint256)
1178     {
1179         if (x==0)
1180             return (0);
1181         else if (y==0)
1182             return (1);
1183         else 
1184         {
1185             uint256 z = x;
1186             for (uint256 i=1; i < y; i++)
1187                 z = mul(z,x);
1188             return (z);
1189         }
1190     }
1191 }
1192 
1193 library Array256Lib {
1194 
1195   /// @dev Sum vector
1196   /// @param self Storage array containing uint256 type variables
1197   /// @return sum The sum of all elements, does not check for overflow
1198   function sumElements(uint256[] storage self) public view returns(uint256 sum) {
1199     assembly {
1200       mstore(0x60,self_slot)
1201 
1202       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
1203         sum := add(sload(add(sha3(0x60,0x20),i)),sum)
1204       }
1205     }
1206   }
1207 
1208   /// @dev Returns the max value in an array.
1209   /// @param self Storage array containing uint256 type variables
1210   /// @return maxValue The highest value in the array
1211   function getMax(uint256[] storage self) public view returns(uint256 maxValue) {
1212     assembly {
1213       mstore(0x60,self_slot)
1214       maxValue := sload(sha3(0x60,0x20))
1215 
1216       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
1217         switch gt(sload(add(sha3(0x60,0x20),i)), maxValue)
1218         case 1 {
1219           maxValue := sload(add(sha3(0x60,0x20),i))
1220         }
1221       }
1222     }
1223   }
1224 
1225   /// @dev Returns the minimum value in an array.
1226   /// @param self Storage array containing uint256 type variables
1227   /// @return minValue The highest value in the array
1228   function getMin(uint256[] storage self) public view returns(uint256 minValue) {
1229     assembly {
1230       mstore(0x60,self_slot)
1231       minValue := sload(sha3(0x60,0x20))
1232 
1233       for { let i := 0 } lt(i, sload(self_slot)) { i := add(i, 1) } {
1234         switch gt(sload(add(sha3(0x60,0x20),i)), minValue)
1235         case 0 {
1236           minValue := sload(add(sha3(0x60,0x20),i))
1237         }
1238       }
1239     }
1240   }
1241 
1242   /// @dev Finds the index of a given value in an array
1243   /// @param self Storage array containing uint256 type variables
1244   /// @param value The value to search for
1245   /// @param isSorted True if the array is sorted, false otherwise
1246   /// @return found True if the value was found, false otherwise
1247   /// @return index The index of the given value, returns 0 if found is false
1248   function indexOf(uint256[] storage self, uint256 value, bool isSorted)
1249            public
1250            view
1251            returns(bool found, uint256 index) {
1252     assembly{
1253       mstore(0x60,self_slot)
1254       switch isSorted
1255       case 1 {
1256         let high := sub(sload(self_slot),1)
1257         let mid := 0
1258         let low := 0
1259         for { } iszero(gt(low, high)) { } {
1260           mid := div(add(low,high),2)
1261 
1262           switch lt(sload(add(sha3(0x60,0x20),mid)),value)
1263           case 1 {
1264              low := add(mid,1)
1265           }
1266           case 0 {
1267             switch gt(sload(add(sha3(0x60,0x20),mid)),value)
1268             case 1 {
1269               high := sub(mid,1)
1270             }
1271             case 0 {
1272               found := 1
1273               index := mid
1274               low := add(high,1)
1275             }
1276           }
1277         }
1278       }
1279       case 0 {
1280         for { let low := 0 } lt(low, sload(self_slot)) { low := add(low, 1) } {
1281           switch eq(sload(add(sha3(0x60,0x20),low)), value)
1282           case 1 {
1283             found := 1
1284             index := low
1285             low := sload(self_slot)
1286           }
1287         }
1288       }
1289     }
1290   }
1291 
1292   /// @dev Utility function for heapSort
1293   /// @param index The index of child node
1294   /// @return pI The parent node index
1295   function getParentI(uint256 index) private pure returns (uint256 pI) {
1296     uint256 i = index - 1;
1297     pI = i/2;
1298   }
1299 
1300   /// @dev Utility function for heapSort
1301   /// @param index The index of parent node
1302   /// @return lcI The index of left child
1303   function getLeftChildI(uint256 index) private pure returns (uint256 lcI) {
1304     uint256 i = index * 2;
1305     lcI = i + 1;
1306   }
1307 
1308   /// @dev Sorts given array in place
1309   /// @param self Storage array containing uint256 type variables
1310   function heapSort(uint256[] storage self) public {
1311     uint256 end = self.length - 1;
1312     uint256 start = getParentI(end);
1313     uint256 root = start;
1314     uint256 lChild;
1315     uint256 rChild;
1316     uint256 swap;
1317     uint256 temp;
1318     while(start >= 0){
1319       root = start;
1320       lChild = getLeftChildI(start);
1321       while(lChild <= end){
1322         rChild = lChild + 1;
1323         swap = root;
1324         if(self[swap] < self[lChild])
1325           swap = lChild;
1326         if((rChild <= end) && (self[swap]<self[rChild]))
1327           swap = rChild;
1328         if(swap == root)
1329           lChild = end+1;
1330         else {
1331           temp = self[swap];
1332           self[swap] = self[root];
1333           self[root] = temp;
1334           root = swap;
1335           lChild = getLeftChildI(root);
1336         }
1337       }
1338       if(start == 0)
1339         break;
1340       else
1341         start = start - 1;
1342     }
1343     while(end > 0){
1344       temp = self[end];
1345       self[end] = self[0];
1346       self[0] = temp;
1347       end = end - 1;
1348       root = 0;
1349       lChild = getLeftChildI(0);
1350       while(lChild <= end){
1351         rChild = lChild + 1;
1352         swap = root;
1353         if(self[swap] < self[lChild])
1354           swap = lChild;
1355         if((rChild <= end) && (self[swap]<self[rChild]))
1356           swap = rChild;
1357         if(swap == root)
1358           lChild = end + 1;
1359         else {
1360           temp = self[swap];
1361           self[swap] = self[root];
1362           self[root] = temp;
1363           root = swap;
1364           lChild = getLeftChildI(root);
1365         }
1366       }
1367     }
1368   }
1369 
1370   /// @dev Removes duplicates from a given array.
1371   /// @param self Storage array containing uint256 type variables
1372   function uniq(uint256[] storage self) public returns (uint256 length) {
1373     bool contains;
1374     uint256 index;
1375 
1376     for (uint256 i = 0; i < self.length; i++) {
1377       (contains, index) = indexOf(self, self[i], false);
1378 
1379       if (i > index) {
1380         for (uint256 j = i; j < self.length - 1; j++){
1381           self[j] = self[j + 1];
1382         }
1383 
1384         delete self[self.length - 1];
1385         self.length--;
1386         i--;
1387       }
1388     }
1389 
1390     length = self.length;
1391   }
1392 }