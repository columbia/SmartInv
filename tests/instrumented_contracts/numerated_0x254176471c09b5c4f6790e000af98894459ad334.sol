1 pragma solidity ^0.4.24;
2 
3 
4 // 
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
58 // 
59 library F3Ddatasets {
60     struct EventReturns {
61         uint256 compressedData;
62         uint256 compressedIDs;
63         address winnerAddr;         // 
64         bytes32 winnerName;         // 
65         uint256 amountWon;          // 
66         uint256 newPot;             // 
67         uint256 P3DAmount;          // 
68         uint256 genAmount;          // 
69         uint256 potAmount;          // 
70     }
71     struct Player {
72         address addr;               // 
73         bytes32 name;               // 
74         uint256 names;              // 
75         uint256 win;                // 
76         uint256 gen;                // 
77         uint256 aff;                // 
78         uint256 lrnd;               // 
79         uint256 laff;               // 
80     }
81     struct PlayerRounds {
82         uint256 eth;                // 
83         uint256 keys;               // 
84         uint256 mask;               // 
85         uint256 ico;                // 
86     }
87     struct Round {
88         uint256 plyr;               // 
89         uint256 team;               // 
90         uint256 end;                // 
91         bool ended;                 // 
92         uint256 strt;               // 
93         uint256 keys;               // 
94         uint256 eth;                //  
95         uint256 pot;                // 
96         uint256 mask;               // 
97         uint256 ico;                // 
98         uint256 icoGen;             // 
99         uint256 icoAvg;             // 
100     }
101     struct TeamFee {
102         uint256 gen;                //  
103         uint256 p3d;                //  
104     }
105     struct PotSplit {
106         uint256 gen;                //  
107         uint256 p3d;                //  
108     }
109 }
110 
111 //  
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
198 //  
199 contract OCF3D {
200 
201     using SafeMath for *;
202     using NameFilter for string;
203 
204     string constant public name = "Official Fomo3D long";           //  
205     string constant public symbol = "OF3D";                      // 
206 
207     // 
208     address public owner;                                       // 
209     address public devs;                                        // 
210     address public otherF3D_;                                   // 
211     address  public Divies;                                     // 
212     address public Jekyll_Island_Inc;                           // 
213 
214     bool public activated_ = false;                             // 
215 
216     uint256 private rndExtra_ = 10 minutes;                              // 
217     uint256 private rndGap_ = 2 minutes;                        // 
218     uint256 constant private rndInit_ = 1 hours;                // 
219     uint256 constant private rndInc_ = 30 seconds;              // 
220     uint256 constant private rndMax_ = 24 hours;                // 
221 
222     uint256 public airDropPot_;                                 // 
223     uint256 public airDropTracker_ = 0;                         // 
224     uint256 public rID_;                                        // 
225 
226     uint256 public registrationFee_ = 10 finney;                // 
227 
228     // 
229     uint256 public pID_;                                        // 
230     mapping(address => uint256) public pIDxAddr_;               //（addr => pID）
231     mapping(bytes32 => uint256) public pIDxName_;               //（name => pID）
232     mapping(uint256 => F3Ddatasets.Player) public plyr_;        //（pID => data）
233     mapping(uint256 => mapping(uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    //（pID => rID => data）
234     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_;       //（pID => name => bool）。
235                                                                           //（）
236     mapping(uint256 => mapping(uint256 => bytes32)) public plyrNameList_; //（pID => nameNum => name）
237 
238     // 
239     mapping(uint256 => F3Ddatasets.Round) public round_;        //（rID => data）
240     mapping(uint256 => mapping(uint256 => uint256)) public rndTmEth_;    //（rID => tID => data）
241 
242     // 
243     mapping(uint256 => F3Ddatasets.TeamFee) public fees_;       //
244     mapping(uint256 => F3Ddatasets.PotSplit) public potSplit_;  //
245 
246     //  
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
260     //  
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
276     //  
277     event onPotSwapDeposit
278     (
279         uint256 roundID,
280         uint256 amountAddedToPot
281     );
282 
283     //  
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
302     // 
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
314     //  
315     event onWithdraw
316     (
317         uint256 indexed playerID,
318         address playerAddress,
319         bytes32 playerName,
320         uint256 ethOut,
321         uint256 timeStamp
322     );
323 
324     //  
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
340     //  
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
355     //  
356     modifier isActivated() {
357         require(activated_ == true, "its not ready yet.  check ?eta in discord");
358         _;
359     }
360 
361     //  
362     modifier isHuman() {
363         address _addr = msg.sender;
364         uint256 _codeLength;
365 
366         assembly {_codeLength := extcodesize(_addr)}
367         require(_codeLength == 0, "sorry humans only");
368         _;
369     }
370 
371     //  
372     modifier onlyDevs()
373     {
374         require(msg.sender == devs, "msg sender is not a dev");
375         _;
376     }
377 
378     // 
379     modifier isWithinLimits(uint256 _eth) {
380         require(_eth >= 1200000000, "pocket lint: not a valid currency");
381         require(_eth <= 100000000000000000000000, "no vitalik, no");
382         _;
383     }
384 
385     //  
386     function activate()
387     public
388     onlyDevs
389     {
390         // 
391         require(activated_ == false, "TinyF3d already activated");
392 
393         // 
394         activated_ = true;
395 
396         // 
397         rID_ = 1;
398         round_[1].strt = now + rndExtra_ - rndGap_;
399         round_[1].end = now + rndInit_ + rndExtra_;
400     }
401 
402     //  
403     constructor()
404     public
405     {
406         owner = msg.sender;
407         devs = msg.sender;
408         otherF3D_ = msg.sender;
409         Divies = msg.sender;
410         Jekyll_Island_Inc = msg.sender;
411 
412          
413         fees_[0] = F3Ddatasets.TeamFee(30, 6);          //  
414         fees_[1] = F3Ddatasets.TeamFee(43, 0);          //  
415         fees_[2] = F3Ddatasets.TeamFee(56, 10);         //  
416         fees_[3] = F3Ddatasets.TeamFee(43, 8);          //  
417 
418         //  
419         //
420         potSplit_[0] = F3Ddatasets.PotSplit(15, 10);    //  
421         potSplit_[1] = F3Ddatasets.PotSplit(25, 0);     //  
422         potSplit_[2] = F3Ddatasets.PotSplit(20, 20);    //  
423         potSplit_[3] = F3Ddatasets.PotSplit(30, 10);    //  
424     }
425 
426     //  
427     function()
428     isActivated()
429     isHuman()
430     isWithinLimits(msg.value)
431     public
432     payable
433     {
434         //  
435         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
436 
437         //  
438         uint256 _pID = pIDxAddr_[msg.sender];
439 
440         //  
441         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
442     }
443 
444     //  
445     function determinePlayer(F3Ddatasets.EventReturns memory _eventData_)
446     private
447     returns (F3Ddatasets.EventReturns)
448     {
449         uint256 _pID = pIDxAddr_[msg.sender];
450 
451         //  
452         if (_pID == 0)
453         {
454             //  
455             determinePID(msg.sender);
456             _pID = pIDxAddr_[msg.sender];
457             bytes32 _name = plyr_[_pID].name;
458             uint256 _laff = plyr_[_pID].laff;
459 
460             //  
461             pIDxAddr_[msg.sender] = _pID;
462             plyr_[_pID].addr = msg.sender;
463 
464             if (_name != "")
465             {
466                 pIDxName_[_name] = _pID;
467                 plyr_[_pID].name = _name;
468                 plyrNames_[_pID][_name] = true;
469             }
470 
471             if (_laff != 0 && _laff != _pID)
472                 plyr_[_pID].laff = _laff;
473 
474             //  
475             _eventData_.compressedData = _eventData_.compressedData + 1;
476         }
477         return (_eventData_);
478     }
479 
480     //  
481     function determinePID(address _addr)
482     private
483     returns (bool)
484     {
485         if (pIDxAddr_[_addr] == 0)
486         {
487             pID_++;
488             pIDxAddr_[_addr] = pID_;
489             plyr_[pID_].addr = _addr;
490 
491             //  
492             return (true);
493         } else {
494             return (false);
495         }
496     }
497 
498     //  
499     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
500     isHuman()
501     public
502     payable
503     {
504         //  
505         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
506 
507         //  
508         bytes32 _name = NameFilter.nameFilter(_nameString);
509 
510         //  
511         address _addr = msg.sender;
512 
513         //  
514         bool _isNewPlayer = determinePID(_addr);
515 
516         //  
517         uint256 _pID = pIDxAddr_[_addr];
518 
519         //  
520         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
521         {
522             //  
523             plyr_[_pID].laff = _affCode;
524         } else if (_affCode == _pID) {
525             _affCode = 0;
526         }
527 
528         //  
529         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
530     }
531 
532     //  
533     function registerNameXaddr(address _addr, string _nameString, address _affCode, bool _all)
534     external
535     payable
536     {
537         //  
538         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
539 
540         //  
541         bytes32 _name = NameFilter.nameFilter(_nameString);
542 
543         //  
544         bool _isNewPlayer = determinePID(_addr);
545 
546         //  
547         uint256 _pID = pIDxAddr_[_addr];
548 
549         //  
550         uint256 _affID;
551         if (_affCode != address(0) && _affCode != _addr)
552         {
553             //  
554             _affID = pIDxAddr_[_affCode];
555 
556             // 
557             if (_affID != plyr_[_pID].laff)
558             {
559                 //  
560                 plyr_[_pID].laff = _affID;
561             }
562         }
563 
564         //  
565         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
566     }
567 
568     //  
569     function registerNameXname(address _addr, string _nameString, bytes32 _affCode, bool _all)
570     external
571     payable
572     {
573         //  
574         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
575 
576         //  
577         bytes32 _name = NameFilter.nameFilter(_nameString);
578 
579         //  
580         bool _isNewPlayer = determinePID(_addr);
581 
582         //  
583         uint256 _pID = pIDxAddr_[_addr];
584 
585         //  
586         uint256 _affID;
587         if (_affCode != "" && _affCode != _name)
588         {
589             //  
590             _affID = pIDxName_[_affCode];
591 
592             //  
593             if (_affID != plyr_[_pID].laff)
594             {
595                 //  
596                 plyr_[_pID].laff = _affID;
597             }
598         }
599 
600         //  
601         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
602     }
603 
604     //  
605     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
606     private
607     {
608         //  
609         if (pIDxName_[_name] != 0)
610             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
611 
612         //  
613         plyr_[_pID].name = _name;
614         pIDxName_[_name] = _pID;
615         if (plyrNames_[_pID][_name] == false)
616         {
617             plyrNames_[_pID][_name] = true;
618             plyr_[_pID].names++;
619             plyrNameList_[_pID][plyr_[_pID].names] = _name;
620         }
621 
622         //  
623         Jekyll_Island_Inc.transfer(address(this).balance);
624 
625         //  
626         //  
627         _all;
628         //if (_all == true)
629         //    for (uint256 i = 1; i <= gID_; i++)
630         //        games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
631 
632 
633         //  
634         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
635     }
636 
637     //  
638     function buyXid(uint256 _affCode, uint256 _team)
639     isActivated()
640     isHuman()
641     isWithinLimits(msg.value)
642     public
643     payable
644     {
645         //  
646         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
647 
648         // 
649         uint256 _pID = pIDxAddr_[msg.sender];
650 
651         //  
652         if (_affCode == 0 || _affCode == _pID)
653         {
654             //  
655             _affCode = plyr_[_pID].laff;
656         } else if (_affCode != plyr_[_pID].laff) {
657             //  
658             plyr_[_pID].laff = _affCode;
659         }
660 
661         //  
662         _team = verifyTeam(_team);
663 
664         //  
665         buyCore(_pID, _affCode, _team, _eventData_);
666     }
667 
668     //  
669     function buyXaddr(address _affCode, uint256 _team)
670     isActivated()
671     isHuman()
672     isWithinLimits(msg.value)
673     public
674     payable
675     {
676         //  
677         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
678 
679         //  
680         uint256 _pID = pIDxAddr_[msg.sender];
681 
682         //  
683         uint256 _affID;
684         if (_affCode == address(0) || _affCode == msg.sender)
685         {
686             //  
687             _affID = plyr_[_pID].laff;
688         } else {
689             //  
690             _affID = pIDxAddr_[_affCode];
691 
692             // 
693             if (_affID != plyr_[_pID].laff)
694             {
695                 //  
696                 plyr_[_pID].laff = _affID;
697             }
698         }
699 
700         //  
701         _team = verifyTeam(_team);
702 
703         //  
704         buyCore(_pID, _affID, _team, _eventData_);
705     }
706 
707     //  
708     function buyXname(bytes32 _affCode, uint256 _team)
709     isActivated()
710     isHuman()
711     isWithinLimits(msg.value)
712     public
713     payable
714     {
715         //  
716         F3Ddatasets.EventReturns memory _eventData_ = determinePlayer(_eventData_);
717 
718         //  
719         uint256 _pID = pIDxAddr_[msg.sender];
720 
721         //  
722         uint256 _affID;
723         if (_affCode == '' || _affCode == plyr_[_pID].name)
724         {
725             //  
726             _affID = plyr_[_pID].laff;
727         } else {
728             //  
729             _affID = pIDxName_[_affCode];
730 
731             //  
732             if (_affID != plyr_[_pID].laff)
733             {
734                 //  
735                 plyr_[_pID].laff = _affID;
736             }
737         }
738 
739         //  
740         _team = verifyTeam(_team);
741 
742         //  
743         buyCore(_pID, _affID, _team, _eventData_);
744     }
745 
746     //  
747     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
748     isActivated()
749     isHuman()
750     isWithinLimits(_eth)
751     public
752     {
753         //  
754         F3Ddatasets.EventReturns memory _eventData_;
755 
756         //  
757         uint256 _pID = pIDxAddr_[msg.sender];
758 
759         //  
760         if (_affCode == 0 || _affCode == _pID)
761         {
762             //  
763             _affCode = plyr_[_pID].laff;
764 
765         } else if (_affCode != plyr_[_pID].laff) {
766             //  
767             plyr_[_pID].laff = _affCode;
768         }
769 
770         //  
771         _team = verifyTeam(_team);
772 
773         //  
774         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
775     }
776 
777     //  
778     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
779     isActivated()
780     isHuman()
781     isWithinLimits(_eth)
782     public
783     {
784         //  
785         F3Ddatasets.EventReturns memory _eventData_;
786 
787         //  
788         uint256 _pID = pIDxAddr_[msg.sender];
789 
790         //  
791         uint256 _affID;
792         if (_affCode == address(0) || _affCode == msg.sender)
793         {
794             //  
795             _affID = plyr_[_pID].laff;
796         } else {
797             //  
798             _affID = pIDxAddr_[_affCode];
799 
800             //  
801             if (_affID != plyr_[_pID].laff)
802             {
803                 //  
804                 plyr_[_pID].laff = _affID;
805             }
806         }
807 
808         //  
809         _team = verifyTeam(_team);
810 
811         //  
812         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
813     }
814 
815     //  
816     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
817     isActivated()
818     isHuman()
819     isWithinLimits(_eth)
820     public
821     {
822         //  
823         F3Ddatasets.EventReturns memory _eventData_;
824 
825         //  
826         uint256 _pID = pIDxAddr_[msg.sender];
827 
828         //  
829         uint256 _affID;
830         if (_affCode == '' || _affCode == plyr_[_pID].name)
831         {
832             //  
833             _affID = plyr_[_pID].laff;
834         } else {
835             //  
836             _affID = pIDxName_[_affCode];
837 
838             //  
839             if (_affID != plyr_[_pID].laff)
840             {
841                 //  
842                 plyr_[_pID].laff = _affID;
843             }
844         }
845 
846         //  
847         _team = verifyTeam(_team);
848 
849         //  
850         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
851     }
852 
853     //  
854     function verifyTeam(uint256 _team)
855     private
856     pure
857     returns (uint256)
858     {
859         if (_team < 0 || _team > 3)
860             return (2);
861         else
862             return (_team);
863     }
864 
865     //  
866     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
867     private
868     {
869         //  
870         uint256 _rID = rID_;
871 
872         //  
873         uint256 _now = now;
874 
875         //  
876         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
877         {
878             //  
879             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
880         } else {
881             //  
882 
883             //  
884             if (_now > round_[_rID].end && round_[_rID].ended == false)
885             {
886                 //  
887                 round_[_rID].ended = true;
888                 _eventData_ = endRound(_eventData_);
889 
890                 //  
891                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
892                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
893 
894                 //  
895                 emit onBuyAndDistribute
896                 (
897                     msg.sender,
898                     plyr_[_pID].name,
899                     msg.value,
900                     _eventData_.compressedData,
901                     _eventData_.compressedIDs,
902                     _eventData_.winnerAddr,
903                     _eventData_.winnerName,
904                     _eventData_.amountWon,
905                     _eventData_.newPot,
906                     _eventData_.P3DAmount,
907                     _eventData_.genAmount
908                 );
909             }
910 
911             // 
912             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
913         }
914     }
915 
916     //  
917     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
918     private
919     {
920         //  
921         uint256 _rID = rID_;
922 
923         //  
924         uint256 _now = now;
925 
926         //  
927         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
928         {
929             //  
930             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
931 
932             //  
933             core(_rID, _pID, _eth, _affID, _team, _eventData_);
934         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
935             //  
936             round_[_rID].ended = true;
937             _eventData_ = endRound(_eventData_);
938 
939             //  
940             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
941             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
942 
943             //  
944             emit onReLoadAndDistribute
945             (
946                 msg.sender,
947                 plyr_[_pID].name,
948                 _eventData_.compressedData,
949                 _eventData_.compressedIDs,
950                 _eventData_.winnerAddr,
951                 _eventData_.winnerName,
952                 _eventData_.amountWon,
953                 _eventData_.newPot,
954                 _eventData_.P3DAmount,
955                 _eventData_.genAmount
956             );
957         }
958     }
959 
960     //  
961     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
962     private
963     returns (F3Ddatasets.EventReturns)
964     {
965         //  
966         if (plyr_[_pID].lrnd != 0)
967             updateGenVault(_pID, plyr_[_pID].lrnd);
968 
969         //  
970         plyr_[_pID].lrnd = rID_;
971 
972         //  
973         _eventData_.compressedData = _eventData_.compressedData + 10;
974 
975         return (_eventData_);
976     }
977 
978  //  
979     function updateTimer(uint256 _keys, uint256 _rID)
980     private
981     {
982         //  
983         uint256 _now = now;
984 
985         //  
986         uint256 _newTime;
987         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
988             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
989         else
990             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
991 
992         //  
993         if (_newTime < (rndMax_).add(_now))
994             round_[_rID].end = _newTime;
995         else
996             round_[_rID].end = rndMax_.add(_now);
997     }
998     //  
999     //  
1000     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
1001     private
1002     view
1003     returns (uint256)
1004     {
1005         return ((((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask));
1006     }
1007 
1008     //  
1009     function updateGenVault(uint256 _pID, uint256 _rIDlast)
1010     private
1011     {
1012         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
1013         if (_earnings > 0)
1014         {
1015             //  
1016             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
1017             //  
1018             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
1019         }
1020     }
1021 
1022    
1023 
1024     //  
1025     function airdrop()
1026     private
1027     view
1028     returns (bool)
1029     {
1030         uint256 seed = uint256(keccak256(abi.encodePacked(
1031 
1032                 (block.timestamp).add
1033                 (block.difficulty).add
1034                 ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
1035                 (block.gaslimit).add
1036                 ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
1037                 (block.number)
1038 
1039             )));
1040         if ((seed - ((seed / 1000) * 1000)) < airDropTracker_)
1041             return (true);
1042         else
1043             return (false);
1044     }
1045 
1046  //  
1047     function getPlayerVaults(uint256 _pID)
1048     public
1049     view
1050     returns (uint256, uint256, uint256)
1051     {
1052         //  
1053         uint256 _rID = rID_;
1054 
1055         //  
1056         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1057         {
1058             //  
1059             if (round_[_rID].plyr == _pID)
1060             {
1061                 return
1062                 (
1063                 (plyr_[_pID].win).add(((round_[_rID].pot).mul(48)) / 100),
1064                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1065                 plyr_[_pID].aff
1066                 );
1067             } else {
1068                 //  
1069                 return
1070                 (
1071                 plyr_[_pID].win,
1072                 (plyr_[_pID].gen).add(getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)),
1073                 plyr_[_pID].aff
1074                 );
1075             }
1076         } else {
1077             //  
1078             return
1079             (
1080             plyr_[_pID].win,
1081             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
1082             plyr_[_pID].aff
1083             );
1084         }
1085     }
1086 
1087     //  
1088     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1089     private
1090     {
1091         //  
1092         if (plyrRnds_[_pID][_rID].keys == 0)
1093             _eventData_ = managePlayer(_pID, _eventData_);
1094 
1095         //  
1096         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
1097         {
1098             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth); // 1eth
1099             uint256 _refund = _eth.sub(_availableLimit);
1100             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
1101             _eth = _availableLimit;
1102         }
1103 
1104         //  
1105         if (_eth > 1000000000) //0.0000001eth
1106         {
1107 
1108             //  
1109             uint256 _keys = keysRec(round_[_rID].eth,_eth);
1110 
1111             //  
1112             if (_keys >= 1000000000000000000)
1113             {
1114                 updateTimer(_keys, _rID);
1115 
1116                 //  
1117                 if (round_[_rID].plyr != _pID)
1118                     round_[_rID].plyr = _pID;
1119                 if (round_[_rID].team != _team)
1120                     round_[_rID].team = _team;
1121 
1122                 //  
1123                 _eventData_.compressedData = _eventData_.compressedData + 100;
1124             }
1125 
1126             //  
1127             if (_eth >= 100000000000000000)
1128             {
1129                 airDropTracker_++;
1130                 if (airdrop() == true)
1131                 {
1132                     uint256 _prize;
1133                     if (_eth >= 10000000000000000000) // 10eth
1134                     {
1135                         //  
1136                         _prize = ((airDropPot_).mul(75)) / 100;
1137                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1138 
1139                         //  
1140                         airDropPot_ = (airDropPot_).sub(_prize);
1141 
1142                         //  
1143                         _eventData_.compressedData += 300000000000000000000000000000000;
1144                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
1145                         //   1eth ~ 10eth
1146                         _prize = ((airDropPot_).mul(50)) / 100;
1147                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1148 
1149                         //  
1150                         airDropPot_ = (airDropPot_).sub(_prize);
1151 
1152                         //    
1153                         _eventData_.compressedData += 200000000000000000000000000000000;
1154                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
1155                         //  
1156                         _prize = ((airDropPot_).mul(25)) / 100;
1157                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
1158 
1159                         //  
1160                         airDropPot_ = (airDropPot_).sub(_prize);
1161 
1162                         //  
1163                         _eventData_.compressedData += 300000000000000000000000000000000;
1164                     }
1165                     //  
1166                     _eventData_.compressedData += 10000000000000000000000000000000;
1167                     //  
1168                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
1169 
1170                     //  
1171                     airDropTracker_ = 0;
1172                 }
1173             }
1174 
1175             //  
1176             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
1177 
1178             //  
1179             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
1180             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
1181 
1182             //  
1183             round_[_rID].keys = _keys.add(round_[_rID].keys);
1184             round_[_rID].eth = _eth.add(round_[_rID].eth);
1185             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
1186 
1187             //  
1188             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
1189             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
1190 
1191             //  
1192             endTx(_pID, _team, _eth, _keys, _eventData_);
1193         }
1194     }
1195 
1196    
1197 
1198     /**
1199      * @dev  
1200      * provider
1201      * -functionhash- 0xc7e284b8
1202      * @return time left in seconds
1203      */
1204     function getTimeLeft()
1205         public
1206         view
1207         returns(uint256)
1208     {
1209         // setup local rID
1210         uint256 _rID = rID_;
1211 
1212         // grab time
1213         uint256 _now = now;
1214 
1215         if (_now < round_[_rID].end)
1216             if (_now > round_[_rID].strt + rndGap_)
1217                 return( (round_[_rID].end).sub(_now) );
1218             else
1219                 return( (round_[_rID].strt + rndGap_).sub(_now) );
1220         else
1221             return(0);
1222     }
1223 
1224 
1225    
1226 
1227     //  
1228     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
1229     private
1230     view
1231     returns (uint256)
1232     {
1233         return (((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000));
1234     }
1235 
1236     //  
1237     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1238     private
1239     {
1240         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
1241         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
1242 
1243         emit onEndTx
1244         (
1245             _eventData_.compressedData,
1246             _eventData_.compressedIDs,
1247             plyr_[_pID].name,
1248             msg.sender,
1249             _eth,
1250             _keys,
1251             _eventData_.winnerAddr,
1252             _eventData_.winnerName,
1253             _eventData_.amountWon,
1254             _eventData_.newPot,
1255             _eventData_.P3DAmount,
1256             _eventData_.genAmount,
1257             _eventData_.potAmount,
1258             airDropPot_
1259         );
1260     }
1261 
1262     //  
1263     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
1264     private
1265     returns (F3Ddatasets.EventReturns)
1266     {
1267         //  
1268         uint256 _com = _eth / 50;
1269         uint256 _p3d;
1270         if (!address(Jekyll_Island_Inc).send(_com))
1271         {
1272             _p3d = _com;
1273             _com = 0;
1274         }
1275 
1276         //  
1277         uint256 _long = _eth / 100;
1278         otherF3D_.transfer(_long);
1279 
1280         //  
1281         uint256 _aff = _eth / 10;
1282 
1283         //  
1284         //  
1285         //  
1286         if (_affID != _pID && plyr_[_affID].name != '') {
1287             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
1288             emit onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
1289         } else {
1290             _p3d = _aff;
1291         }
1292 
1293         //  
1294         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
1295         if (_p3d > 0)
1296         {
1297             //  
1298             Divies.transfer(_p3d);
1299 
1300             //  
1301             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
1302         }
1303 
1304         return (_eventData_);
1305     }
1306 
1307     //  
1308     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
1309     private
1310     returns (F3Ddatasets.EventReturns)
1311     {
1312         //  
1313         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
1314 
1315         //  
1316         uint256 _air = (_eth / 100);
1317         airDropPot_ = airDropPot_.add(_air);
1318 
1319         //   balance（eth = eth  - （com share + pot swap share + aff share + p3d share + airdrop pot share））
1320         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
1321 
1322         //  
1323         uint256 _pot = _eth.sub(_gen);
1324 
1325         //  
1326         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
1327         if (_dust > 0)
1328             _gen = _gen.sub(_dust);
1329 
1330         //  
1331         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
1332 
1333         //  
1334         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
1335         _eventData_.potAmount = _pot;
1336 
1337         return (_eventData_);
1338     }
1339 
1340     //  
1341     function potSwap()
1342     external
1343     payable
1344     {
1345         //  
1346         uint256 _rID = rID_ + 1;
1347 
1348         round_[_rID].pot = round_[_rID].pot.add(msg.value);
1349         emit onPotSwapDeposit(_rID, msg.value);
1350     }
1351 
1352     //  
1353     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
1354     private
1355     returns (uint256)
1356     {
1357 
1358         //   
1359         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1360         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1361 
1362         //  
1363         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
1364         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
1365 
1366         // 
1367         return (_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
1368     }
1369 
1370     //  
1371     function endRound(F3Ddatasets.EventReturns memory _eventData_)
1372     private
1373     returns (F3Ddatasets.EventReturns)
1374     {
1375         //  
1376         uint256 _rID = rID_;
1377 
1378         //  
1379         uint256 _winPID = round_[_rID].plyr;
1380         uint256 _winTID = round_[_rID].team;
1381 
1382         //  
1383         uint256 _pot = round_[_rID].pot;
1384 
1385         //  
1386         //  
1387         uint256 _win = (_pot.mul(48)) / 100;
1388         uint256 _com = (_pot / 50);
1389         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
1390         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
1391         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
1392 
1393         //  
1394         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
1395         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
1396         if (_dust > 0)
1397         {
1398             _gen = _gen.sub(_dust);
1399             _res = _res.add(_dust);
1400         }
1401 
1402         //  
1403         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
1404 
1405         //  
1406         if (!address(Jekyll_Island_Inc).send(_com))
1407         {
1408             _p3d = _p3d.add(_com);
1409             _com = 0;
1410         }
1411 
1412         //  
1413         round_[_rID].mask = _ppt.add(round_[_rID].mask);
1414 
1415         //  
1416         if (_p3d > 0)
1417             Divies.transfer(_p3d);
1418 
1419         // 
1420         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
1421         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
1422         _eventData_.winnerAddr = plyr_[_winPID].addr;
1423         _eventData_.winnerName = plyr_[_winPID].name;
1424         _eventData_.amountWon = _win;
1425         _eventData_.genAmount = _gen;
1426         _eventData_.P3DAmount = _p3d;
1427         _eventData_.newPot = _res;
1428 
1429         //  
1430         rID_++;
1431         _rID++;
1432         round_[_rID].strt = now;
1433         round_[_rID].end = now.add(rndInit_).add(rndGap_);
1434         round_[_rID].pot = _res;
1435 
1436         return (_eventData_);
1437     }
1438 
1439     //  
1440     function getPlayerInfoByAddress(address _addr)
1441     public
1442     view
1443     returns (uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
1444     {
1445         //  
1446         uint256 _rID = rID_;
1447 
1448         if (_addr == address(0))
1449         {
1450             _addr == msg.sender;
1451         }
1452         uint256 _pID = pIDxAddr_[_addr];
1453 
1454         return
1455         (
1456         _pID, //0
1457         plyr_[_pID].name, //1
1458         plyrRnds_[_pID][_rID].keys, //2
1459         plyr_[_pID].win, //3
1460         (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)), //4
1461         plyr_[_pID].aff, //5
1462         plyrRnds_[_pID][_rID].eth           //6
1463         );
1464     }
1465 
1466     //  
1467     function getCurrentRoundInfo()
1468     public
1469     view
1470     returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
1471     {
1472         //  
1473         uint256 _rID = rID_;
1474 
1475         return
1476         (
1477         round_[_rID].ico, //0
1478         _rID, //1
1479         round_[_rID].keys, //2
1480         round_[_rID].end, //3
1481         round_[_rID].strt, //4
1482         round_[_rID].pot, //5
1483         (round_[_rID].team + (round_[_rID].plyr * 10)), //6
1484         plyr_[round_[_rID].plyr].addr, //7
1485         plyr_[round_[_rID].plyr].name, //8
1486         rndTmEth_[_rID][0], //9
1487         rndTmEth_[_rID][1], //10
1488         rndTmEth_[_rID][2], //11
1489         rndTmEth_[_rID][3], //12
1490         airDropTracker_ + (airDropPot_ * 1000)              //13
1491         );
1492     }
1493 
1494     //  
1495     function withdraw()
1496     isActivated()
1497     isHuman()
1498     public
1499     {
1500         //  
1501         uint256 _rID = rID_;
1502 
1503         //  
1504         uint256 _now = now;
1505 
1506         // 
1507         uint256 _pID = pIDxAddr_[msg.sender];
1508 
1509         //  
1510         uint256 _eth;
1511 
1512         //  
1513         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
1514         {
1515             //  
1516             F3Ddatasets.EventReturns memory _eventData_;
1517 
1518             //  
1519             round_[_rID].ended = true;
1520             _eventData_ = endRound(_eventData_);
1521 
1522             //  
1523             _eth = withdrawEarnings(_pID);
1524 
1525             //  
1526             if (_eth > 0)
1527                 plyr_[_pID].addr.transfer(_eth);
1528 
1529             //  
1530             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
1531             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
1532 
1533             //  
1534             emit onWithdrawAndDistribute
1535             (
1536                 msg.sender,
1537                 plyr_[_pID].name,
1538                 _eth,
1539                 _eventData_.compressedData,
1540                 _eventData_.compressedIDs,
1541                 _eventData_.winnerAddr,
1542                 _eventData_.winnerName,
1543                 _eventData_.amountWon,
1544                 _eventData_.newPot,
1545                 _eventData_.P3DAmount,
1546                 _eventData_.genAmount
1547             );
1548         } else {
1549             //  
1550             //  
1551             _eth = withdrawEarnings(_pID);
1552 
1553             //  
1554             if (_eth > 0)
1555                 plyr_[_pID].addr.transfer(_eth);
1556 
1557             //  
1558             emit onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
1559         }
1560     }
1561 
1562     //  
1563     function withdrawEarnings(uint256 _pID)
1564     private
1565     returns (uint256)
1566     {
1567         //  
1568         updateGenVault(_pID, plyr_[_pID].lrnd);
1569 
1570         //  
1571         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
1572         if (_earnings > 0)
1573         {
1574             plyr_[_pID].win = 0;
1575             plyr_[_pID].gen = 0;
1576             plyr_[_pID].aff = 0;
1577         }
1578 
1579         return (_earnings);
1580     }
1581 
1582     //  
1583     function calcKeysReceived(uint256 _rID, uint256 _eth)
1584     public
1585     view
1586     returns (uint256)
1587     {
1588         //  
1589         uint256 _now = now;
1590 
1591         //  
1592         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) {
1593             return keysRec(round_[_rID].eth + _eth,_eth);
1594         } else {
1595             //  
1596             return keys(_eth);
1597         }
1598     }
1599 
1600     //  
1601     function iWantXKeys(uint256 _keys)
1602     public
1603     view
1604     returns (uint256)
1605     {
1606         //  
1607         uint256 _rID = rID_;
1608 
1609         //  
1610         uint256 _now = now;
1611 
1612         //  
1613         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1614             return ethRec(round_[_rID].keys + _keys,_keys);
1615         else //  
1616             return eth(_keys);
1617     }
1618 
1619 
1620     function getBuyPrice()
1621         public 
1622         view 
1623         returns(uint256)
1624     {  
1625         // setup local rID
1626         uint256 _rID = rID_;
1627         
1628         // grab time
1629         uint256 _now = now;
1630         
1631         // are we in a round?
1632         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
1633            return ethRec((round_[_rID].keys+1000000000000000000),1000000000000000000);
1634         else // rounds over.  need price for new round
1635             return ( 75000000000000 ); // init
1636     }
1637     
1638     //  
1639     function keysRec(uint256 _curEth, uint256 _newEth)
1640     internal
1641     pure
1642     returns (uint256)
1643     {
1644         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
1645     }
1646 
1647     function keys(uint256 _eth)
1648     internal
1649     pure
1650     returns(uint256)
1651     {
1652         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
1653     }
1654 
1655     function ethRec(uint256 _curKeys, uint256 _sellKeys)
1656     internal
1657     pure
1658     returns (uint256)
1659     {
1660         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
1661     }
1662 
1663     function eth(uint256 _keys)
1664     internal
1665     pure
1666     returns(uint256)
1667     {
1668         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
1669     }
1670     
1671 }