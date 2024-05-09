1 pragma solidity ^0.4.24;
2 /**
3  * @title POPO v1.3.1
4  *
5  * This product is protected under license.  Any unauthorized copy, modification, or use without 
6  * express written consent from the creators is prohibited.
7  * 
8  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
9  */
10 // Author: https://playpopo.com
11 // Contact: playpopoteam@gmail.com
12 library PopoDatasets {
13 
14   struct Order {
15     uint256 pID;
16     uint256 createTime;
17     uint256 createDayIndex;
18     uint256 orderValue;
19     uint256 refund;
20     uint256 withdrawn;
21     bool hasWithdrawn;
22   }
23   
24   struct Player {
25     address addr;
26     bytes32 name;
27 
28     bool inviteEnable;
29     uint256 inviterPID;
30     uint256 [] inviteePIDs;
31     uint256 inviteReward1;
32     uint256 inviteReward2;
33     uint256 inviteReward3;
34     uint256 inviteRewardWithdrawn;
35 
36     uint256 [] oIDs;
37     uint256 lastOrderDayIndex;
38     uint256 dayEthIn;
39   }
40 
41 }
42 contract PopoEvents {
43 
44   event onEnableInvite
45   (
46     uint256 pID,
47     address pAddr,
48     bytes32 pName,
49     uint256 timeStamp
50   );
51   
52 
53   event onSetInviter
54   (
55     uint256 pID,
56     address pAddr,
57     uint256 indexed inviterPID,
58     address indexed inviterAddr,
59     bytes32 indexed inviterName,
60     uint256 timeStamp
61   );
62 
63   event onOrder
64   (
65     uint256 indexed pID,
66     address indexed pAddr,
67     uint256 indexed dayIndex,
68     uint256 oID,
69     uint256 value,
70     uint256 timeStamp
71   );
72 
73   event onWithdrawOrderRefund
74   (
75     uint256 indexed pID,
76     address indexed pAddr,
77     uint256 oID,
78     uint256 value,
79     uint256 timeStamp
80   );
81 
82   event onWithdrawOrderRefundToOrder
83   (
84     uint256 indexed pID,
85     address indexed pAddr,
86     uint256 oID,
87     uint256 value,
88     uint256 timeStamp
89   );
90 
91   event onWithdrawInviteReward
92   (
93     uint256 indexed pID,
94     address indexed pAddr,
95     uint256 value,
96     uint256 timeStamp
97   );
98 
99   event onWithdrawInviteRewardToOrder
100   (
101     uint256 indexed pID,
102     address indexed pAddr,
103     uint256 value,
104     uint256 timeStamp
105   );
106     
107 }
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
114     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (a == 0) {
118       return 0;
119     }
120 
121     c = a * b;
122     assert(c / a == b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     // uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return a / b;
134   }
135 
136   /**
137   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
148     c = a + b;
149     assert(c >= a);
150     return c;
151   }
152 }
153 library NameFilter {
154   
155     using SafeMath for *;
156 
157     /**
158      * @dev filters name strings
159      * -converts uppercase to lower case.  
160      * -makes sure it does not start/end with a space
161      * -makes sure it does not contain multiple spaces in a row
162      * -cannot be only numbers
163      * -cannot start with 0x 
164      * -restricts characters to A-Z, a-z, 0-9, and space.
165      * @return reprocessed string in bytes32 format
166      */
167     function nameFilter(string _input)
168         internal
169         pure
170         returns(bytes32)
171     {
172         bytes memory _temp = bytes(_input);
173         uint256 _length = _temp.length;
174         
175         //sorry limited to 32 characters
176         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
177         // make sure it doesnt start with or end with space
178         require(_temp[0] != 0x20 && _temp[_length.sub(1)] != 0x20, "string cannot start or end with space");
179         // make sure first two characters are not 0x
180         if (_temp[0] == 0x30)
181         {
182             require(_temp[1] != 0x78, "string cannot start with 0x");
183             require(_temp[1] != 0x58, "string cannot start with 0X");
184         }
185         
186         // create a bool to track if we have a non number character
187         bool _hasNonNumber;
188         
189         // convert & check
190         for (uint256 i = 0; i < _length; i = i.add(1))
191         {
192             // if its uppercase A-Z
193             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
194             {
195                 // convert to lower case a-z
196                 _temp[i] = byte(uint(_temp[i]) + 32);
197                 
198                 // we have a non number
199                 if (_hasNonNumber == false)
200                     _hasNonNumber = true;
201             } else {
202                 require
203                 (
204                     // require character is a space
205                     _temp[i] == 0x20 || 
206                     // OR lowercase a-z
207                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
208                     // or 0-9
209                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
210                     "string contains invalid characters"
211                 );
212                 // make sure theres not 2x spaces in a row
213                 if (_temp[i] == 0x20)
214                     require(_temp[i.add(1)] != 0x20, "string cannot contain consecutive spaces");
215                 
216                 // see if we have a character other than a number
217                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
218                     _hasNonNumber = true;    
219             }
220         }
221         
222         require(_hasNonNumber == true, "string cannot be only numbers");
223         
224         bytes32 _ret;
225         assembly {
226             _ret := mload(add(_temp, 32))
227         }
228         return (_ret);
229     }
230 }
231 contract SafePopo {
232 
233   using SafeMath for *;
234 
235   bool public activated_;
236   uint256 public activated_time_;
237 
238   modifier isHuman() {
239     address _addr = msg.sender;
240     uint256 _codeLength;
241       
242     assembly {_codeLength := extcodesize(_addr)}
243     require (_codeLength == 0, "sorry humans only");
244     _;
245   }
246 
247   modifier isWithinLimits(uint256 _eth) {
248     require (_eth >= 0.1 ether, "0.1 ether at least");
249     require (_eth <= 10000000 ether, "no, too much ether");
250     _;    
251   }
252 
253   modifier isActivated() {
254     require (activated_ == true, "popo is not activated"); 
255     _;
256   }
257 
258   modifier onlyCEO() {
259     require 
260     (
261       msg.sender == 0x5927774a0438f452747b847E4e9097884DA6afE9 || 
262       msg.sender == 0xA2CDecFe929Eccbd519A6c98b1220b16f5b6B0B5
263     );
264     _;
265   }
266 
267   modifier onlyCommunityLeader() { 
268     require 
269     (
270       msg.sender == 0xede5Adf9F68C02537Cc1737CFF4506BCfFAAB63d || 
271       msg.sender == 0x7400A7B7D67814B0d8B27362CC198F4Ae2840e16
272     );
273     _;
274   }
275 
276   function activate() 
277     onlyCEO()
278     onlyCommunityLeader()
279     public
280   {
281     require (activated_ == false, "popo has been activated already");
282 
283     activated_ = true;
284     activated_time_ = now;
285   }
286   
287 }
288 contract CorePopo is SafePopo, PopoEvents {
289 
290   uint256 public startTime_;
291 
292   uint256 public teamPot_;
293   uint256 public communityPot_;
294   
295   mapping (uint256 => uint256) public day_ethIn;
296   uint256 public ethIn_;
297 
298   uint256 public dayEthInLimit_ = 300 ether;
299   uint256 public playerDayEthInLimit_ = 10 ether;
300 
301   uint256 public pIDIndex_;
302   mapping (uint256 => PopoDatasets.Player) public pID_Player_;
303   mapping (address => uint256) public addr_pID_;
304   mapping (bytes32 => uint256) public name_pID_;
305 
306   mapping (uint256 => uint256) public inviteePID_inviteReward1_;
307 
308   uint256 public oIDIndex_;
309   mapping (uint256 => PopoDatasets.Order) public oID_Order_;
310 
311   uint256 [] public refundOIDs_;
312   uint256 public refundOIDIndex_;
313 
314   function determinePID ()
315     internal
316   {
317     if (addr_pID_[msg.sender] != 0) {
318       return;
319     }
320 
321     pIDIndex_ = pIDIndex_.add(1);
322     
323     pID_Player_[pIDIndex_].addr = msg.sender;
324 
325     addr_pID_[msg.sender] = pIDIndex_;
326   }
327 
328   function getDayIndex (uint256 _time)
329     internal
330     view
331     returns (uint256) 
332   {
333     return _time.sub(activated_time_).div(1 days).add(1);
334   }
335   
336 }
337 contract InvitePopo is CorePopo {
338 
339   using NameFilter for string;
340   
341   function enableInvite (string _nameString, bytes32 _inviterName)
342     isActivated()
343     isHuman()
344     public
345     payable
346   {
347     require (msg.value == 0.01 ether, "enable invite need 0.01 ether");     
348 
349     determinePID();
350     determineInviter(addr_pID_[msg.sender], _inviterName);
351    
352     require (pID_Player_[addr_pID_[msg.sender]].inviteEnable == false, "you can only enable invite once");
353 
354     bytes32 _name = _nameString.nameFilter();
355     require (name_pID_[_name] == 0, "your name is already registered by others");
356     
357     pID_Player_[addr_pID_[msg.sender]].name = _name;
358     pID_Player_[addr_pID_[msg.sender]].inviteEnable = true;
359 
360     name_pID_[_name] = addr_pID_[msg.sender];
361 
362     communityPot_ = communityPot_.add(msg.value);
363 
364     emit PopoEvents.onEnableInvite
365     (
366       addr_pID_[msg.sender],
367       msg.sender,
368       _name,
369       now
370     );
371   }
372 
373   function enableInviteOfSU (string _nameString) 
374     onlyCEO()
375     onlyCommunityLeader()
376     isActivated()
377     isHuman()
378     public
379   {
380     determinePID();
381    
382     require (pID_Player_[addr_pID_[msg.sender]].inviteEnable == false, "you can only enable invite once");
383 
384     bytes32 _name = _nameString.nameFilter();
385     require (name_pID_[_name] == 0, "your name is already registered by others");
386     
387     name_pID_[_name] = addr_pID_[msg.sender];
388 
389     pID_Player_[addr_pID_[msg.sender]].name = _name;
390     pID_Player_[addr_pID_[msg.sender]].inviteEnable = true;
391   }
392 
393   function determineInviter (uint256 _pID, bytes32 _inviterName) 
394     internal
395   {
396     if (pID_Player_[_pID].inviterPID != 0) {
397       return;
398     }
399 
400     uint256 _inviterPID = name_pID_[_inviterName];
401     require (_inviterPID != 0, "your inviter name must be registered");
402     require (pID_Player_[_inviterPID].inviteEnable == true, "your inviter must enable invite");
403     require (_inviterPID != _pID, "you can not invite yourself");
404 
405     pID_Player_[_pID].inviterPID = _inviterPID;
406 
407     emit PopoEvents.onSetInviter
408     (
409       _pID,
410       msg.sender,
411       _inviterPID,
412       pID_Player_[_inviterPID].addr,
413       _inviterName,
414       now
415     );
416   }
417 
418   function distributeInviteReward (uint256 _pID, uint256 _inviteReward1, uint256 _inviteReward2, uint256 _inviteReward3, uint256 _percent) 
419     internal
420     returns (uint256)
421   {
422     uint256 inviterPID = pID_Player_[_pID].inviterPID;
423     if (pID_Player_[inviterPID].inviteEnable) 
424     {
425       pID_Player_[inviterPID].inviteReward1 = pID_Player_[inviterPID].inviteReward1.add(_inviteReward1);
426 
427       if (inviteePID_inviteReward1_[_pID] == 0) {
428         pID_Player_[inviterPID].inviteePIDs.push(_pID);
429       }
430       inviteePID_inviteReward1_[_pID] = inviteePID_inviteReward1_[_pID].add(_inviteReward1);
431 
432       _percent = _percent.sub(5);
433     } 
434     
435     uint256 inviterPID_inviterPID = pID_Player_[inviterPID].inviterPID;
436     if (pID_Player_[inviterPID_inviterPID].inviteEnable) 
437     {
438       pID_Player_[inviterPID_inviterPID].inviteReward2 = pID_Player_[inviterPID_inviterPID].inviteReward2.add(_inviteReward2);
439 
440       _percent = _percent.sub(2);
441     }
442 
443     uint256 inviterPID_inviterPID_inviterPID = pID_Player_[inviterPID_inviterPID].inviterPID;
444     if (pID_Player_[inviterPID_inviterPID_inviterPID].inviteEnable) 
445     {
446       pID_Player_[inviterPID_inviterPID_inviterPID].inviteReward3 = pID_Player_[inviterPID_inviterPID_inviterPID].inviteReward3.add(_inviteReward3);
447 
448       _percent = _percent.sub(1);
449     } 
450 
451     return
452     (
453       _percent
454     );
455   }
456   
457 }
458 contract OrderPopo is InvitePopo {
459 
460   function setDayEthInLimit (uint256 dayEthInLimit) 
461     onlyCEO()
462     onlyCommunityLeader()
463     public
464   {
465     dayEthInLimit_ = dayEthInLimit;
466   }
467 
468   function setPlayerDayEthInLimit (uint256 playerDayEthInLimit) 
469     onlyCEO()
470     onlyCommunityLeader()
471     public
472   {
473     playerDayEthInLimit_ = playerDayEthInLimit;
474   }
475   
476   function order (bytes32 _inviterName)
477     isActivated()
478     isHuman()
479     isWithinLimits(msg.value)
480     public
481     payable
482   {
483     uint256 _now = now;
484     uint256 _nowDayIndex = getDayIndex(_now);
485 
486     require (_nowDayIndex > 2, "only third day can order");
487             
488     determinePID();
489     determineInviter(addr_pID_[msg.sender], _inviterName);
490 
491     orderCore(_now, _nowDayIndex, msg.value);
492   }
493 
494   function orderInternal (uint256 _value, bytes32 _inviterName)
495     internal
496   {
497     uint256 _now = now;
498     uint256 _nowDayIndex = getDayIndex(_now);
499 
500     require (_nowDayIndex > 2, "only third day can order");
501             
502     determinePID();
503     determineInviter(addr_pID_[msg.sender], _inviterName);
504 
505     orderCore(_now, _nowDayIndex, _value);
506   }
507 
508   function orderCore (uint256 _now, uint256 _nowDayIndex, uint256 _value)
509     private
510   {
511     teamPot_ = teamPot_.add(_value.mul(3).div(100));
512     communityPot_ = communityPot_.add(_value.mul(4).div(100));
513 
514     require (day_ethIn[_nowDayIndex] < dayEthInLimit_, "beyond the day eth in limit");
515     day_ethIn[_nowDayIndex] = day_ethIn[_nowDayIndex].add(_value);
516     ethIn_ = ethIn_.add(_value);
517 
518     uint256 _pID = addr_pID_[msg.sender];
519 
520     if (pID_Player_[_pID].lastOrderDayIndex == _nowDayIndex) {
521       require (pID_Player_[_pID].dayEthIn < playerDayEthInLimit_, "beyond the player day eth in limit");
522       pID_Player_[_pID].dayEthIn = pID_Player_[_pID].dayEthIn.add(_value);
523     } else {
524       pID_Player_[_pID].lastOrderDayIndex = _nowDayIndex;
525       pID_Player_[_pID].dayEthIn = _value;
526     }
527 
528     oIDIndex_ = oIDIndex_.add(1);
529     
530     oID_Order_[oIDIndex_].pID = _pID;
531     oID_Order_[oIDIndex_].createTime = _now;
532     oID_Order_[oIDIndex_].createDayIndex = _nowDayIndex;
533     oID_Order_[oIDIndex_].orderValue = _value;
534 
535     pID_Player_[_pID].oIDs.push(oIDIndex_);
536 
537     refundOIDs_.push(oIDIndex_);
538 
539     uint256 _percent = 33;
540     if (pID_Player_[_pID].oIDs.length < 3) {
541       _percent = distributeInviteReward(_pID, _value.mul(5).div(100), _value.mul(2).div(100), _value.mul(1).div(100), _percent);
542       refund(_nowDayIndex, _value.mul(_percent).div(100));
543     } else {
544       refund(_nowDayIndex, _value.mul(_percent).div(100));
545     }
546 
547     emit PopoEvents.onOrder
548     (
549       _pID,
550       msg.sender,
551       _nowDayIndex,
552       oIDIndex_,
553       _value,
554       now
555     );
556   }
557 
558   function refund (uint256 _nowDayIndex, uint256 _pot)
559     private
560   {
561     while
562     (
563       (_pot > 0) &&
564       (refundOIDIndex_ < refundOIDs_.length)
565     )
566     {
567       (_pot, refundOIDIndex_) = doRefund(_nowDayIndex, refundOIDIndex_, _pot);
568     }
569   }
570   
571   function doRefund (uint256 _nowDayIndex, uint256 _refundOIDIndex, uint256 _pot)
572     private
573     returns (uint256, uint256)
574   {
575     uint256 _refundOID = refundOIDs_[_refundOIDIndex];
576 
577     uint _orderState = getOrderStateHelper(_nowDayIndex, _refundOID);
578     if (_orderState != 1) {
579       return
580       (
581         _pot,
582         _refundOIDIndex.add(1)
583       );
584     }
585 
586     uint256 _maxRefund = oID_Order_[_refundOID].orderValue.mul(60).div(100);
587     if (oID_Order_[_refundOID].refund < _maxRefund) {
588       uint256 _needRefund = _maxRefund.sub(oID_Order_[_refundOID].refund);
589 
590       if 
591       (
592         _needRefund > _pot
593       ) 
594       {
595         oID_Order_[_refundOID].refund = oID_Order_[_refundOID].refund.add(_pot);
596 
597         return
598         (
599           0,
600           _refundOIDIndex
601         );
602       } 
603       else
604       {
605         oID_Order_[_refundOID].refund = oID_Order_[_refundOID].refund.add(_needRefund);
606 
607         return
608         (
609           _pot.sub(_needRefund),
610           _refundOIDIndex.add(1)
611         );
612       }
613     }
614     else
615     {
616       return
617       (
618         _pot,
619         _refundOIDIndex.add(1)
620       );
621     }
622   }
623 
624   function getOrderStateHelper (uint256 _nowDayIndex, uint256 _oID)
625     internal
626     view
627     returns (uint)
628   {
629     PopoDatasets.Order memory _order = oID_Order_[_oID];
630     
631     if 
632     (
633       _order.hasWithdrawn
634     ) 
635     {
636       return
637       (
638         3
639       );
640     } 
641     else 
642     {
643       if 
644       (
645         _nowDayIndex < _order.createDayIndex || 
646         _nowDayIndex > _order.createDayIndex.add(5)
647       )
648       {
649         return
650         (
651           2
652         );
653       }
654       else 
655       {
656         return
657         (
658           1
659         );
660       }
661     }
662   }
663   
664 }
665 contract InspectorPopo is OrderPopo {
666 
667   function getAdminDashboard () 
668     onlyCEO()
669     onlyCommunityLeader()
670     public
671     view 
672     returns (uint256, uint256)
673   {
674     return
675     (
676       teamPot_,
677       communityPot_
678     ); 
679   }
680 
681   function getDayEthIn (uint256 _dayIndex) 
682     onlyCEO()
683     onlyCommunityLeader()
684     public
685     view 
686     returns (uint256)
687   {
688     return
689     (
690       day_ethIn[_dayIndex]
691     ); 
692   }
693 
694   function getAddressLost (address _addr) 
695     onlyCEO()
696     onlyCommunityLeader()
697     public
698     view 
699     returns (uint256) 
700   {
701     uint256 _now = now;
702     uint256 _nowDayIndex = getDayIndex(_now);
703 
704     uint256 pID = addr_pID_[_addr];
705     require (pID != 0, "address need to be registered");
706     
707     uint256 _orderValue = 0;
708     uint256 _actualTotalRefund = 0;
709 
710     uint256 [] memory _oIDs = pID_Player_[pID].oIDs;
711     for (uint256 _index = 0; _index < _oIDs.length; _index = _index.add(1)) {
712       PopoDatasets.Order memory _order = oID_Order_[_oIDs[_index]];
713       _orderValue = _orderValue.add(_order.orderValue);
714       _actualTotalRefund = _actualTotalRefund.add(getOrderActualTotalRefundHelper(_nowDayIndex, _oIDs[_index]));
715     }
716 
717     if (_orderValue > _actualTotalRefund) {
718       return 
719       (
720         _orderValue.sub(_actualTotalRefund)
721       );
722     }
723     else
724     {
725       return 
726       (
727         0
728       );
729     }
730   }
731 
732   function getInviteInfo () 
733     public
734     view
735     returns (bool, bytes32, uint256, bytes32, uint256, uint256, uint256, uint256)
736   {
737     uint256 _pID = addr_pID_[msg.sender];
738 
739     return 
740     (
741       pID_Player_[_pID].inviteEnable,
742       pID_Player_[_pID].name,
743       pID_Player_[_pID].inviterPID,
744       pID_Player_[pID_Player_[_pID].inviterPID].name,
745       pID_Player_[_pID].inviteReward1,
746       pID_Player_[_pID].inviteReward2,
747       pID_Player_[_pID].inviteReward3,
748       pID_Player_[_pID].inviteRewardWithdrawn
749     );
750   }
751 
752   function getInviteePIDs () 
753     public
754     view
755     returns (uint256 []) 
756   {
757     uint256 _pID = addr_pID_[msg.sender];
758 
759     return 
760     (
761       pID_Player_[_pID].inviteePIDs
762     );
763   }
764 
765   function getInviteeInfo (uint256 _inviteePID) 
766     public
767     view
768     returns (uint256, bytes32) 
769   {
770 
771     require (pID_Player_[_inviteePID].inviterPID == addr_pID_[msg.sender], "you must have invited this player");
772 
773     return 
774     (
775       inviteePID_inviteReward1_[_inviteePID],
776       pID_Player_[_inviteePID].name
777     );
778   }
779 
780   function getOrderInfo () 
781     public
782     view
783     returns (bool, uint256 []) 
784   {
785     uint256 _now = now;
786     uint256 _nowDayIndex = getDayIndex(_now);
787 
788     uint256 _pID = addr_pID_[msg.sender];
789 
790     bool _isWithinPlayerDayEthInLimits = true;
791     if
792     (
793       (pID_Player_[_pID].lastOrderDayIndex == _nowDayIndex) &&
794       (pID_Player_[_pID].dayEthIn >= playerDayEthInLimit_) 
795     )
796     {
797       _isWithinPlayerDayEthInLimits = false;
798     }
799 
800     return 
801     (
802       _isWithinPlayerDayEthInLimits,
803       pID_Player_[_pID].oIDs
804     );
805   }
806 
807   function getOrder (uint256 _oID) 
808     public
809     view
810     returns (uint256, uint256, uint256, uint, uint256)
811   {
812     uint256 _now = now;
813     uint256 _nowDayIndex = getDayIndex(_now);
814 
815     require (oID_Order_[_oID].pID == addr_pID_[msg.sender], "only owner can get its order");
816 
817     return 
818     (
819       oID_Order_[_oID].createTime,
820       oID_Order_[_oID].createDayIndex,
821       oID_Order_[_oID].orderValue,
822       getOrderStateHelper(_nowDayIndex, _oID),
823       getOrderActualTotalRefundHelper(_nowDayIndex, _oID)
824     );
825   }
826 
827   function getOverall ()
828     public
829     view 
830     returns (uint256, uint256, uint256, uint256, uint256, bool, uint256)
831   {
832     uint256 _now = now;
833     uint256 _nowDayIndex = getDayIndex(_now);
834     uint256 _tommorrow = _nowDayIndex.mul(1 days).add(activated_time_);
835     bool _isWithinDayEthInLimits = day_ethIn[_nowDayIndex] < dayEthInLimit_ ? true : false;
836 
837     return (
838       _now,
839       _nowDayIndex,
840       _tommorrow,
841       ethIn_,
842       dayEthInLimit_,
843       _isWithinDayEthInLimits,
844       playerDayEthInLimit_
845     ); 
846   }
847 
848   function getOrderActualTotalRefundHelper (uint256 _nowDayIndex, uint256 _oID) 
849     internal
850     view 
851     returns (uint256)
852   {
853     if (oID_Order_[_oID].hasWithdrawn) {
854       return
855       (
856         oID_Order_[_oID].withdrawn
857       );
858     }
859 
860     uint256 _actualTotalRefund = oID_Order_[_oID].orderValue.mul(60).div(100);
861     uint256 _dayGap = _nowDayIndex.sub(oID_Order_[_oID].createDayIndex);
862     if (_dayGap > 0) {
863       _dayGap = _dayGap > 5 ? 5 : _dayGap;
864       uint256 _maxRefund = oID_Order_[_oID].orderValue.mul(12).mul(_dayGap).div(100);
865 
866       if (oID_Order_[_oID].refund < _maxRefund)
867       {
868         _actualTotalRefund = _actualTotalRefund.add(oID_Order_[_oID].refund);
869       } 
870       else 
871       {
872         _actualTotalRefund = _actualTotalRefund.add(_maxRefund);
873       }
874     }
875     return
876     (
877       _actualTotalRefund
878     );
879   }
880 
881 }
882 contract WithdrawPopo is InspectorPopo {
883 
884   function withdrawOrderRefund(uint256 _oID)
885     isActivated()
886     isHuman()
887     public
888   {
889     uint256 _now = now;
890     uint256 _nowDayIndex = getDayIndex(_now);
891 
892     PopoDatasets.Order memory _order = oID_Order_[_oID];
893     require (_order.pID == addr_pID_[msg.sender], "only owner can withdraw");
894     require (!_order.hasWithdrawn, "order refund has been withdrawn");
895 
896     uint256 _actualTotalRefund = getOrderActualTotalRefundHelper(_nowDayIndex, _oID);
897     require (_actualTotalRefund > 0, "no order refund need to be withdrawn");
898 
899     msg.sender.transfer(_actualTotalRefund);
900 
901     oID_Order_[_oID].withdrawn = _actualTotalRefund;
902     oID_Order_[_oID].hasWithdrawn = true;
903 
904     uint256 _totalRefund = _order.orderValue.mul(60).div(100);
905     _totalRefund = _totalRefund.add(_order.refund);
906     communityPot_ = communityPot_.add(_totalRefund.sub(_actualTotalRefund));
907 
908     emit PopoEvents.onWithdrawOrderRefund
909     (
910       _order.pID,
911       msg.sender,
912       _oID,
913       _actualTotalRefund,
914       now
915     );
916   }
917 
918   function withdrawOrderRefundToOrder(uint256 _oID)
919     isActivated()
920     isHuman()
921     public
922   {
923     uint256 _now = now;
924     uint256 _nowDayIndex = getDayIndex(_now);
925 
926     PopoDatasets.Order memory _order = oID_Order_[_oID];
927     require (_order.pID == addr_pID_[msg.sender], "only owner can withdraw");
928     require (!_order.hasWithdrawn, "order refund has been withdrawn");
929 
930     uint256 _actualTotalRefund = getOrderActualTotalRefundHelper(_nowDayIndex, _oID);
931     require (_actualTotalRefund > 0, "no order refund need to be withdrawn");
932 
933     orderInternal(_actualTotalRefund, pID_Player_[pID_Player_[_order.pID].inviterPID].name);
934 
935     oID_Order_[_oID].withdrawn = _actualTotalRefund;
936     oID_Order_[_oID].hasWithdrawn = true;
937 
938     uint256 _totalRefund = _order.orderValue.mul(60).div(100);
939     _totalRefund = _totalRefund.add(_order.refund);
940     communityPot_ = communityPot_.add(_totalRefund.sub(_actualTotalRefund));
941 
942     emit PopoEvents.onWithdrawOrderRefundToOrder
943     (
944       _order.pID,
945       msg.sender,
946       _oID,
947       _actualTotalRefund,
948       now
949     );
950   }
951 
952   function withdrawInviteReward ()
953     isActivated()
954     isHuman()
955     public
956   {
957     uint256 _pID = addr_pID_[msg.sender];
958 
959     uint256 _withdrawal = pID_Player_[_pID].inviteReward1
960                             .add(pID_Player_[_pID].inviteReward2)
961                             .add(pID_Player_[_pID].inviteReward3)
962                             .sub(pID_Player_[_pID].inviteRewardWithdrawn);
963     require (_withdrawal > 0, "you have no invite reward to withdraw");
964 
965     msg.sender.transfer(_withdrawal);
966 
967     pID_Player_[_pID].inviteRewardWithdrawn = pID_Player_[_pID].inviteRewardWithdrawn.add(_withdrawal);
968 
969     emit PopoEvents.onWithdrawInviteReward
970     (
971       _pID,
972       msg.sender,
973       _withdrawal,
974       now
975     );
976   }
977 
978   function withdrawInviteRewardToOrder ()
979     isActivated()
980     isHuman()
981     public
982   {
983     uint256 _pID = addr_pID_[msg.sender];
984 
985     uint256 _withdrawal = pID_Player_[_pID].inviteReward1
986                             .add(pID_Player_[_pID].inviteReward2)
987                             .add(pID_Player_[_pID].inviteReward3)
988                             .sub(pID_Player_[_pID].inviteRewardWithdrawn);
989     require (_withdrawal > 0, "you have no invite reward to withdraw");
990 
991     orderInternal(_withdrawal, pID_Player_[pID_Player_[_pID].inviterPID].name);
992 
993     pID_Player_[_pID].inviteRewardWithdrawn = pID_Player_[_pID].inviteRewardWithdrawn.add(_withdrawal);
994 
995     emit PopoEvents.onWithdrawInviteRewardToOrder
996     (
997       _pID,
998       msg.sender,
999       _withdrawal,
1000       now
1001     );
1002   }
1003 
1004   function withdrawTeamPot ()
1005     onlyCEO()
1006     isActivated()
1007     isHuman()
1008     public
1009   {
1010     if (teamPot_ <= 0) {
1011       return;
1012     }
1013 
1014     msg.sender.transfer(teamPot_);
1015     teamPot_ = 0;
1016   }
1017 
1018   function withdrawCommunityPot ()
1019     onlyCommunityLeader()
1020     isActivated()
1021     isHuman()
1022     public
1023   {
1024     if (communityPot_ <= 0) {
1025       return;
1026     }
1027 
1028     msg.sender.transfer(communityPot_);
1029     communityPot_ = 0;
1030   }
1031 
1032 }
1033 contract Popo is WithdrawPopo {
1034   
1035   constructor()
1036     public 
1037   {
1038 
1039   }
1040   
1041 }