1 /**
2  * @title POPO v3.0.1
3  * 
4  * This product is protected under license.  Any unauthorized copy, modification, or use without 
5  * express written consent from the creators is prohibited.
6  * 
7  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
8  */
9 // author: https://playpopo.com
10 // contact: playpopoteam@gmail.com
11 pragma solidity ^0.4.24;
12 // produced by the Solididy File Flattener (c) David Appleton 2018
13 // contact : dave@akomba.com
14 // released under Apache 2.0 licence
15 library PopoDatasets {
16 
17   struct Order {
18     uint256 pID;
19     uint256 createTime;
20     uint256 createDayIndex;
21     uint256 orderValue;
22     uint256 refund;
23     uint256 withdrawn;
24     bool hasWithdrawn;
25   }
26   
27   struct Player {
28     address addr;
29     bytes32 name;
30 
31     bool inviteEnable;
32     uint256 inviterPID;
33     uint256 [] inviteePIDs;
34     uint256 inviteReward1;
35     uint256 inviteReward2;
36     uint256 inviteReward3;
37     uint256 inviteRewardWithdrawn;
38 
39     uint256 [] oIDs;
40     uint256 lastOrderDayIndex;
41     uint256 dayEthIn;
42   }
43 
44 }
45 library SafeMath {
46 
47   /**
48   * @dev Multiplies two numbers, throws on overflow.
49   */
50   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52     // benefit is lost if 'b' is also tested.
53     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54     if (a == 0) {
55       return 0;
56     }
57 
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 contract PopoEvents {
91 
92   event onEnableInvite
93   (
94     uint256 pID,
95     address pAddr,
96     bytes32 pName,
97     uint256 timeStamp
98   );
99   
100 
101   event onSetInviter
102   (
103     uint256 pID,
104     address pAddr,
105     uint256 indexed inviterPID,
106     address indexed inviterAddr,
107     bytes32 indexed inviterName,
108     uint256 timeStamp
109   );
110 
111   event onOrder
112   (
113     uint256 indexed pID,
114     address indexed pAddr,
115     uint256 indexed dayIndex,
116     uint256 oID,
117     uint256 value,
118     uint256 timeStamp
119   );
120 
121   event onWithdrawOrderRefund
122   (
123     uint256 indexed pID,
124     address indexed pAddr,
125     uint256 oID,
126     uint256 value,
127     uint256 timeStamp
128   );
129 
130   event onWithdrawOrderRefundToOrder
131   (
132     uint256 indexed pID,
133     address indexed pAddr,
134     uint256 oID,
135     uint256 value,
136     uint256 timeStamp
137   );
138 
139   event onWithdrawInviteReward
140   (
141     uint256 indexed pID,
142     address indexed pAddr,
143     uint256 value,
144     uint256 timeStamp
145   );
146 
147   event onWithdrawInviteRewardToOrder
148   (
149     uint256 indexed pID,
150     address indexed pAddr,
151     uint256 value,
152     uint256 timeStamp
153   );
154     
155 }
156 library NameFilter {
157   
158     using SafeMath for *;
159 
160     /**
161      * @dev filters name strings
162      * -converts uppercase to lower case.  
163      * -makes sure it does not start/end with a space
164      * -makes sure it does not contain multiple spaces in a row
165      * -cannot be only numbers
166      * -cannot start with 0x 
167      * -restricts characters to A-Z, a-z, 0-9, and space.
168      * @return reprocessed string in bytes32 format
169      */
170     function nameFilter(string _input)
171         internal
172         pure
173         returns(bytes32)
174     {
175         bytes memory _temp = bytes(_input);
176         uint256 _length = _temp.length;
177         
178         //sorry limited to 32 characters
179         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
180         // make sure it doesnt start with or end with space
181         require(_temp[0] != 0x20 && _temp[_length.sub(1)] != 0x20, "string cannot start or end with space");
182         // make sure first two characters are not 0x
183         if (_temp[0] == 0x30)
184         {
185             require(_temp[1] != 0x78, "string cannot start with 0x");
186             require(_temp[1] != 0x58, "string cannot start with 0X");
187         }
188         
189         // create a bool to track if we have a non number character
190         bool _hasNonNumber;
191         
192         // convert & check
193         for (uint256 i = 0; i < _length; i = i.add(1))
194         {
195             // if its uppercase A-Z
196             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
197             {
198                 // convert to lower case a-z
199                 _temp[i] = byte(uint(_temp[i]) + 32);
200                 
201                 // we have a non number
202                 if (_hasNonNumber == false)
203                     _hasNonNumber = true;
204             } else {
205                 require
206                 (
207                     // require character is a space
208                     _temp[i] == 0x20 || 
209                     // OR lowercase a-z
210                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
211                     // or 0-9
212                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
213                     "string contains invalid characters"
214                 );
215                 // make sure theres not 2x spaces in a row
216                 if (_temp[i] == 0x20)
217                     require(_temp[i.add(1)] != 0x20, "string cannot contain consecutive spaces");
218                 
219                 // see if we have a character other than a number
220                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
221                     _hasNonNumber = true;    
222             }
223         }
224         
225         require(_hasNonNumber == true, "string cannot be only numbers");
226         
227         bytes32 _ret;
228         assembly {
229             _ret := mload(add(_temp, 32))
230         }
231         return (_ret);
232     }
233 }
234 contract SafePopo {
235 
236   using SafeMath for *;
237 
238   bool public activated_;
239   uint256 public activated_time_;
240 
241   modifier isHuman() {
242     address _addr = msg.sender;
243     uint256 _codeLength;
244       
245     assembly {_codeLength := extcodesize(_addr)}
246     require (_codeLength == 0, "sorry humans only");
247     _;
248   }
249 
250   modifier isWithinLimits(uint256 _eth) {
251     require (_eth >= 0.1 ether, "0.1 ether at least");
252     require (_eth <= 10000000 ether, "no, too much ether");
253     _;    
254   }
255 
256   modifier isActivated() {
257     require (activated_ == true, "popo is not activated"); 
258     _;
259   }
260 
261   modifier onlyCEO() {
262     require 
263     (
264       msg.sender == 0x5927774a0438f452747b847E4e9097884DA6afE9 || 
265       msg.sender == 0xA2CDecFe929Eccbd519A6c98b1220b16f5b6B0B5 ||
266       msg.sender == 0xede5Adf9F68C02537Cc1737CFF4506BCfFAAB63d
267     );
268     _;
269   }
270 
271   modifier onlyCommunityLeader() { 
272     require 
273     (
274       msg.sender == 0x5927774a0438f452747b847E4e9097884DA6afE9 || 
275       msg.sender == 0xA2CDecFe929Eccbd519A6c98b1220b16f5b6B0B5 ||
276       msg.sender == 0xede5Adf9F68C02537Cc1737CFF4506BCfFAAB63d
277     );
278     _;
279   }
280 
281   function activate() 
282     onlyCEO()
283     onlyCommunityLeader()
284     public
285   {
286     require (activated_ == false, "popo has been activated already");
287 
288     activated_ = true;
289     activated_time_ = now;
290   }
291   
292 }
293 contract CorePopo is SafePopo, PopoEvents {
294 
295   uint256 public startTime_;
296 
297   uint256 public teamPot_;
298   uint256 public communityPot_;
299   
300   mapping (uint256 => uint256) public day_ethIn;
301   uint256 public ethIn_;
302 
303   uint256 public dayEthInLimit_ = 300 ether;
304   uint256 public playerDayEthInLimit_ = 10 ether;
305 
306   uint256 public pIDIndex_;
307   mapping (uint256 => PopoDatasets.Player) public pID_Player_;
308   mapping (address => uint256) public addr_pID_;
309   mapping (bytes32 => uint256) public name_pID_;
310 
311   mapping (uint256 => uint256) public inviteePID_inviteReward1_;
312 
313   uint256 public oIDIndex_;
314   mapping (uint256 => PopoDatasets.Order) public oID_Order_;
315 
316   uint256 [] public refundOIDs_;
317   uint256 public refundOIDIndex_;
318 
319   function determinePID ()
320     internal
321   {
322     if (addr_pID_[msg.sender] != 0) {
323       return;
324     }
325 
326     pIDIndex_ = pIDIndex_.add(1);
327     
328     pID_Player_[pIDIndex_].addr = msg.sender;
329 
330     addr_pID_[msg.sender] = pIDIndex_;
331   }
332 
333   function getDayIndex (uint256 _time)
334     internal
335     view
336     returns (uint256) 
337   {
338     return _time.sub(activated_time_).div(1 days).add(1);
339   }
340   
341 }
342 contract InvitePopo is CorePopo {
343 
344   using NameFilter for string;
345   
346   function enableInvite (string _nameString, bytes32 _inviterName)
347     isActivated()
348     isHuman()
349     public
350     payable
351   {
352     require (msg.value == 0.01 ether, "enable invite need 0.01 ether");     
353 
354     determinePID();
355     determineInviter(addr_pID_[msg.sender], _inviterName);
356    
357     require (pID_Player_[addr_pID_[msg.sender]].inviteEnable == false, "you can only enable invite once");
358 
359     bytes32 _name = _nameString.nameFilter();
360     require (name_pID_[_name] == 0, "your name is already registered by others");
361     
362     pID_Player_[addr_pID_[msg.sender]].name = _name;
363     pID_Player_[addr_pID_[msg.sender]].inviteEnable = true;
364 
365     name_pID_[_name] = addr_pID_[msg.sender];
366 
367     communityPot_ = communityPot_.add(msg.value);
368 
369     emit PopoEvents.onEnableInvite
370     (
371       addr_pID_[msg.sender],
372       msg.sender,
373       _name,
374       now
375     );
376   }
377 
378   function enableInviteOfSU (string _nameString) 
379     onlyCEO()
380     onlyCommunityLeader()
381     isActivated()
382     isHuman()
383     public
384   {
385     determinePID();
386    
387     require (pID_Player_[addr_pID_[msg.sender]].inviteEnable == false, "you can only enable invite once");
388 
389     bytes32 _name = _nameString.nameFilter();
390     require (name_pID_[_name] == 0, "your name is already registered by others");
391     
392     name_pID_[_name] = addr_pID_[msg.sender];
393 
394     pID_Player_[addr_pID_[msg.sender]].name = _name;
395     pID_Player_[addr_pID_[msg.sender]].inviteEnable = true;
396   }
397 
398   function determineInviter (uint256 _pID, bytes32 _inviterName) 
399     internal
400   {
401     if (pID_Player_[_pID].inviterPID != 0) {
402       return;
403     }
404 
405     uint256 _inviterPID = name_pID_[_inviterName];
406     require (_inviterPID != 0, "your inviter name must be registered");
407     require (pID_Player_[_inviterPID].inviteEnable == true, "your inviter must enable invite");
408     require (_inviterPID != _pID, "you can not invite yourself");
409 
410     pID_Player_[_pID].inviterPID = _inviterPID;
411 
412     emit PopoEvents.onSetInviter
413     (
414       _pID,
415       msg.sender,
416       _inviterPID,
417       pID_Player_[_inviterPID].addr,
418       _inviterName,
419       now
420     );
421   }
422 
423   function distributeInviteReward (uint256 _pID, uint256 _inviteReward1, uint256 _inviteReward2, uint256 _inviteReward3, uint256 _percent) 
424     internal
425     returns (uint256)
426   {
427     uint256 inviterPID = pID_Player_[_pID].inviterPID;
428     if (pID_Player_[inviterPID].inviteEnable) 
429     {
430       pID_Player_[inviterPID].inviteReward1 = pID_Player_[inviterPID].inviteReward1.add(_inviteReward1);
431 
432       if (inviteePID_inviteReward1_[_pID] == 0) {
433         pID_Player_[inviterPID].inviteePIDs.push(_pID);
434       }
435       inviteePID_inviteReward1_[_pID] = inviteePID_inviteReward1_[_pID].add(_inviteReward1);
436 
437       _percent = _percent.sub(5);
438     } 
439     
440     uint256 inviterPID_inviterPID = pID_Player_[inviterPID].inviterPID;
441     if (pID_Player_[inviterPID_inviterPID].inviteEnable) 
442     {
443       pID_Player_[inviterPID_inviterPID].inviteReward2 = pID_Player_[inviterPID_inviterPID].inviteReward2.add(_inviteReward2);
444 
445       _percent = _percent.sub(2);
446     }
447 
448     uint256 inviterPID_inviterPID_inviterPID = pID_Player_[inviterPID_inviterPID].inviterPID;
449     if (pID_Player_[inviterPID_inviterPID_inviterPID].inviteEnable) 
450     {
451       pID_Player_[inviterPID_inviterPID_inviterPID].inviteReward3 = pID_Player_[inviterPID_inviterPID_inviterPID].inviteReward3.add(_inviteReward3);
452 
453       _percent = _percent.sub(1);
454     } 
455 
456     return
457     (
458       _percent
459     );
460   }
461   
462 }
463 contract OrderPopo is InvitePopo {
464 
465   function setDayEthInLimit (uint256 dayEthInLimit) 
466     onlyCEO()
467     onlyCommunityLeader()
468     public
469   {
470     dayEthInLimit_ = dayEthInLimit;
471   }
472 
473   function setPlayerDayEthInLimit (uint256 playerDayEthInLimit) 
474     onlyCEO()
475     onlyCommunityLeader()
476     public
477   {
478     playerDayEthInLimit_ = playerDayEthInLimit;
479   }
480   
481   function order (bytes32 _inviterName)
482     isActivated()
483     isHuman()
484     isWithinLimits(msg.value)
485     public
486     payable
487   {
488     uint256 _now = now;
489     uint256 _nowDayIndex = getDayIndex(_now);
490 
491     require (_nowDayIndex > 2, "only third day can order");
492             
493     determinePID();
494     determineInviter(addr_pID_[msg.sender], _inviterName);
495 
496     orderCore(_now, _nowDayIndex, msg.value);
497   }
498 
499   function orderInternal (uint256 _value, bytes32 _inviterName)
500     internal
501   {
502     uint256 _now = now;
503     uint256 _nowDayIndex = getDayIndex(_now);
504 
505     require (_nowDayIndex > 2, "only third day can order");
506             
507     determinePID();
508     determineInviter(addr_pID_[msg.sender], _inviterName);
509 
510     orderCore(_now, _nowDayIndex, _value);
511   }
512 
513   function orderCore (uint256 _now, uint256 _nowDayIndex, uint256 _value)
514     private
515   {
516     teamPot_ = teamPot_.add(_value.mul(3).div(100));
517     communityPot_ = communityPot_.add(_value.mul(4).div(100));
518 
519     require (day_ethIn[_nowDayIndex] < dayEthInLimit_, "beyond the day eth in limit");
520     day_ethIn[_nowDayIndex] = day_ethIn[_nowDayIndex].add(_value);
521     ethIn_ = ethIn_.add(_value);
522 
523     uint256 _pID = addr_pID_[msg.sender];
524 
525     if (pID_Player_[_pID].lastOrderDayIndex == _nowDayIndex) {
526       require (pID_Player_[_pID].dayEthIn < playerDayEthInLimit_, "beyond the player day eth in limit");
527       pID_Player_[_pID].dayEthIn = pID_Player_[_pID].dayEthIn.add(_value);
528     } else {
529       pID_Player_[_pID].lastOrderDayIndex = _nowDayIndex;
530       pID_Player_[_pID].dayEthIn = _value;
531     }
532 
533     oIDIndex_ = oIDIndex_.add(1);
534     
535     oID_Order_[oIDIndex_].pID = _pID;
536     oID_Order_[oIDIndex_].createTime = _now;
537     oID_Order_[oIDIndex_].createDayIndex = _nowDayIndex;
538     oID_Order_[oIDIndex_].orderValue = _value;
539 
540     pID_Player_[_pID].oIDs.push(oIDIndex_);
541 
542     refundOIDs_.push(oIDIndex_);
543 
544     uint256 _percent = 33;
545     if (pID_Player_[_pID].oIDs.length < 3) {
546       _percent = distributeInviteReward(_pID, _value.mul(5).div(100), _value.mul(2).div(100), _value.mul(1).div(100), _percent);
547       refund(_nowDayIndex, _value.mul(_percent).div(100));
548     } else {
549       refund(_nowDayIndex, _value.mul(_percent).div(100));
550     }
551 
552     emit PopoEvents.onOrder
553     (
554       _pID,
555       msg.sender,
556       _nowDayIndex,
557       oIDIndex_,
558       _value,
559       now
560     );
561   }
562 
563   function refund (uint256 _nowDayIndex, uint256 _pot)
564     private
565   {
566     while
567     (
568       (_pot > 0) &&
569       (refundOIDIndex_ < refundOIDs_.length)
570     )
571     {
572       (_pot, refundOIDIndex_) = doRefund(_nowDayIndex, refundOIDIndex_, _pot);
573     }
574   }
575   
576   function doRefund (uint256 _nowDayIndex, uint256 _refundOIDIndex, uint256 _pot)
577     private
578     returns (uint256, uint256)
579   {
580     uint256 _refundOID = refundOIDs_[_refundOIDIndex];
581 
582     uint _orderState = getOrderStateHelper(_nowDayIndex, _refundOID);
583     if (_orderState != 1) {
584       return
585       (
586         _pot,
587         _refundOIDIndex.add(1)
588       );
589     }
590 
591     uint256 _maxRefund = oID_Order_[_refundOID].orderValue.mul(60).div(100);
592     if (oID_Order_[_refundOID].refund < _maxRefund) {
593       uint256 _needRefund = _maxRefund.sub(oID_Order_[_refundOID].refund);
594 
595       if 
596       (
597         _needRefund > _pot
598       ) 
599       {
600         oID_Order_[_refundOID].refund = oID_Order_[_refundOID].refund.add(_pot);
601 
602         return
603         (
604           0,
605           _refundOIDIndex
606         );
607       } 
608       else
609       {
610         oID_Order_[_refundOID].refund = oID_Order_[_refundOID].refund.add(_needRefund);
611 
612         return
613         (
614           _pot.sub(_needRefund),
615           _refundOIDIndex.add(1)
616         );
617       }
618     }
619     else
620     {
621       return
622       (
623         _pot,
624         _refundOIDIndex.add(1)
625       );
626     }
627   }
628 
629   function getOrderStateHelper (uint256 _nowDayIndex, uint256 _oID)
630     internal
631     view
632     returns (uint)
633   {
634     PopoDatasets.Order memory _order = oID_Order_[_oID];
635     
636     if 
637     (
638       _order.hasWithdrawn
639     ) 
640     {
641       return
642       (
643         3
644       );
645     } 
646     else 
647     {
648       if 
649       (
650         _nowDayIndex < _order.createDayIndex || 
651         _nowDayIndex > _order.createDayIndex.add(5)
652       )
653       {
654         return
655         (
656           2
657         );
658       }
659       else 
660       {
661         return
662         (
663           1
664         );
665       }
666     }
667   }
668   
669 }
670 contract InspectorPopo is OrderPopo {
671 
672   function getAdminDashboard () 
673     onlyCEO()
674     onlyCommunityLeader()
675     public
676     view 
677     returns (uint256, uint256)
678   {
679     return
680     (
681       teamPot_,
682       communityPot_
683     ); 
684   }
685 
686   function getDayEthIn (uint256 _dayIndex) 
687     onlyCEO()
688     onlyCommunityLeader()
689     public
690     view 
691     returns (uint256)
692   {
693     return
694     (
695       day_ethIn[_dayIndex]
696     ); 
697   }
698 
699   function getAddressLost (address _addr) 
700     onlyCEO()
701     onlyCommunityLeader()
702     public
703     view 
704     returns (uint256) 
705   {
706     uint256 _now = now;
707     uint256 _nowDayIndex = getDayIndex(_now);
708 
709     uint256 pID = addr_pID_[_addr];
710     require (pID != 0, "address need to be registered");
711     
712     uint256 _orderValue = 0;
713     uint256 _actualTotalRefund = 0;
714 
715     uint256 [] memory _oIDs = pID_Player_[pID].oIDs;
716     for (uint256 _index = 0; _index < _oIDs.length; _index = _index.add(1)) {
717       PopoDatasets.Order memory _order = oID_Order_[_oIDs[_index]];
718       _orderValue = _orderValue.add(_order.orderValue);
719       _actualTotalRefund = _actualTotalRefund.add(getOrderActualTotalRefundHelper(_nowDayIndex, _oIDs[_index]));
720     }
721 
722     if (_orderValue > _actualTotalRefund) {
723       return 
724       (
725         _orderValue.sub(_actualTotalRefund)
726       );
727     }
728     else
729     {
730       return 
731       (
732         0
733       );
734     }
735   }
736 
737   function getInviteInfo () 
738     public
739     view
740     returns (bool, bytes32, uint256, bytes32, uint256, uint256, uint256, uint256)
741   {
742     uint256 _pID = addr_pID_[msg.sender];
743 
744     return 
745     (
746       pID_Player_[_pID].inviteEnable,
747       pID_Player_[_pID].name,
748       pID_Player_[_pID].inviterPID,
749       pID_Player_[pID_Player_[_pID].inviterPID].name,
750       pID_Player_[_pID].inviteReward1,
751       pID_Player_[_pID].inviteReward2,
752       pID_Player_[_pID].inviteReward3,
753       pID_Player_[_pID].inviteRewardWithdrawn
754     );
755   }
756 
757   function getInviteePIDs () 
758     public
759     view
760     returns (uint256 []) 
761   {
762     uint256 _pID = addr_pID_[msg.sender];
763 
764     return 
765     (
766       pID_Player_[_pID].inviteePIDs
767     );
768   }
769 
770   function getInviteeInfo (uint256 _inviteePID) 
771     public
772     view
773     returns (uint256, bytes32) 
774   {
775 
776     require (pID_Player_[_inviteePID].inviterPID == addr_pID_[msg.sender], "you must have invited this player");
777 
778     return 
779     (
780       inviteePID_inviteReward1_[_inviteePID],
781       pID_Player_[_inviteePID].name
782     );
783   }
784 
785   function getOrderInfo () 
786     public
787     view
788     returns (bool, uint256 []) 
789   {
790     uint256 _now = now;
791     uint256 _nowDayIndex = getDayIndex(_now);
792 
793     uint256 _pID = addr_pID_[msg.sender];
794 
795     bool _isWithinPlayerDayEthInLimits = true;
796     if
797     (
798       (pID_Player_[_pID].lastOrderDayIndex == _nowDayIndex) &&
799       (pID_Player_[_pID].dayEthIn >= playerDayEthInLimit_) 
800     )
801     {
802       _isWithinPlayerDayEthInLimits = false;
803     }
804 
805     return 
806     (
807       _isWithinPlayerDayEthInLimits,
808       pID_Player_[_pID].oIDs
809     );
810   }
811 
812   function getOrder (uint256 _oID) 
813     public
814     view
815     returns (uint256, uint256, uint256, uint, uint256)
816   {
817     uint256 _now = now;
818     uint256 _nowDayIndex = getDayIndex(_now);
819 
820     require (oID_Order_[_oID].pID == addr_pID_[msg.sender], "only owner can get its order");
821 
822     return 
823     (
824       oID_Order_[_oID].createTime,
825       oID_Order_[_oID].createDayIndex,
826       oID_Order_[_oID].orderValue,
827       getOrderStateHelper(_nowDayIndex, _oID),
828       getOrderActualTotalRefundHelper(_nowDayIndex, _oID)
829     );
830   }
831 
832   function getOverall ()
833     public
834     view 
835     returns (uint256, uint256, uint256, uint256, uint256, bool, uint256)
836   {
837     uint256 _now = now;
838     uint256 _nowDayIndex = getDayIndex(_now);
839     uint256 _tommorrow = _nowDayIndex.mul(1 days).add(activated_time_);
840     bool _isWithinDayEthInLimits = day_ethIn[_nowDayIndex] < dayEthInLimit_ ? true : false;
841 
842     return (
843       _now,
844       _nowDayIndex,
845       _tommorrow,
846       ethIn_,
847       dayEthInLimit_,
848       _isWithinDayEthInLimits,
849       playerDayEthInLimit_
850     ); 
851   }
852 
853   function getOrderActualTotalRefundHelper (uint256 _nowDayIndex, uint256 _oID) 
854     internal
855     view 
856     returns (uint256)
857   {
858     if (oID_Order_[_oID].hasWithdrawn) {
859       return
860       (
861         oID_Order_[_oID].withdrawn
862       );
863     }
864 
865     uint256 _actualTotalRefund = oID_Order_[_oID].orderValue.mul(60).div(100);
866     uint256 _dayGap = _nowDayIndex.sub(oID_Order_[_oID].createDayIndex);
867     if (_dayGap > 0) {
868       _dayGap = _dayGap > 5 ? 5 : _dayGap;
869       uint256 _maxRefund = oID_Order_[_oID].orderValue.mul(12).mul(_dayGap).div(100);
870 
871       if (oID_Order_[_oID].refund < _maxRefund)
872       {
873         _actualTotalRefund = _actualTotalRefund.add(oID_Order_[_oID].refund);
874       } 
875       else 
876       {
877         _actualTotalRefund = _actualTotalRefund.add(_maxRefund);
878       }
879     }
880     return
881     (
882       _actualTotalRefund
883     );
884   }
885 
886 }
887 contract WithdrawPopo is InspectorPopo {
888 
889   function withdrawOrderRefund(uint256 _oID)
890     isActivated()
891     isHuman()
892     public
893   {
894     uint256 _now = now;
895     uint256 _nowDayIndex = getDayIndex(_now);
896 
897     PopoDatasets.Order memory _order = oID_Order_[_oID];
898     require (_order.pID == addr_pID_[msg.sender], "only owner can withdraw");
899     require (!_order.hasWithdrawn, "order refund has been withdrawn");
900 
901     uint256 _actualTotalRefund = getOrderActualTotalRefundHelper(_nowDayIndex, _oID);
902     require (_actualTotalRefund > 0, "no order refund need to be withdrawn");
903 
904     msg.sender.transfer(_actualTotalRefund);
905 
906     oID_Order_[_oID].withdrawn = _actualTotalRefund;
907     oID_Order_[_oID].hasWithdrawn = true;
908 
909     uint256 _totalRefund = _order.orderValue.mul(60).div(100);
910     _totalRefund = _totalRefund.add(_order.refund);
911     communityPot_ = communityPot_.add(_totalRefund.sub(_actualTotalRefund));
912 
913     emit PopoEvents.onWithdrawOrderRefund
914     (
915       _order.pID,
916       msg.sender,
917       _oID,
918       _actualTotalRefund,
919       now
920     );
921   }
922 
923   function withdrawOrderRefundToOrder(uint256 _oID)
924     isActivated()
925     isHuman()
926     public
927   {
928     uint256 _now = now;
929     uint256 _nowDayIndex = getDayIndex(_now);
930 
931     PopoDatasets.Order memory _order = oID_Order_[_oID];
932     require (_order.pID == addr_pID_[msg.sender], "only owner can withdraw");
933     require (!_order.hasWithdrawn, "order refund has been withdrawn");
934 
935     uint256 _actualTotalRefund = getOrderActualTotalRefundHelper(_nowDayIndex, _oID);
936     require (_actualTotalRefund > 0, "no order refund need to be withdrawn");
937 
938     orderInternal(_actualTotalRefund, pID_Player_[pID_Player_[_order.pID].inviterPID].name);
939 
940     oID_Order_[_oID].withdrawn = _actualTotalRefund;
941     oID_Order_[_oID].hasWithdrawn = true;
942 
943     uint256 _totalRefund = _order.orderValue.mul(60).div(100);
944     _totalRefund = _totalRefund.add(_order.refund);
945     communityPot_ = communityPot_.add(_totalRefund.sub(_actualTotalRefund));
946 
947     emit PopoEvents.onWithdrawOrderRefundToOrder
948     (
949       _order.pID,
950       msg.sender,
951       _oID,
952       _actualTotalRefund,
953       now
954     );
955   }
956 
957   function withdrawInviteReward ()
958     isActivated()
959     isHuman()
960     public
961   {
962     uint256 _pID = addr_pID_[msg.sender];
963 
964     uint256 _withdrawal = pID_Player_[_pID].inviteReward1
965                             .add(pID_Player_[_pID].inviteReward2)
966                             .add(pID_Player_[_pID].inviteReward3)
967                             .sub(pID_Player_[_pID].inviteRewardWithdrawn);
968     require (_withdrawal > 0, "you have no invite reward to withdraw");
969 
970     msg.sender.transfer(_withdrawal);
971 
972     pID_Player_[_pID].inviteRewardWithdrawn = pID_Player_[_pID].inviteRewardWithdrawn.add(_withdrawal);
973 
974     emit PopoEvents.onWithdrawInviteReward
975     (
976       _pID,
977       msg.sender,
978       _withdrawal,
979       now
980     );
981   }
982 
983   function withdrawInviteRewardToOrder ()
984     isActivated()
985     isHuman()
986     public
987   {
988     uint256 _pID = addr_pID_[msg.sender];
989 
990     uint256 _withdrawal = pID_Player_[_pID].inviteReward1
991                             .add(pID_Player_[_pID].inviteReward2)
992                             .add(pID_Player_[_pID].inviteReward3)
993                             .sub(pID_Player_[_pID].inviteRewardWithdrawn);
994     require (_withdrawal > 0, "you have no invite reward to withdraw");
995 
996     orderInternal(_withdrawal, pID_Player_[pID_Player_[_pID].inviterPID].name);
997 
998     pID_Player_[_pID].inviteRewardWithdrawn = pID_Player_[_pID].inviteRewardWithdrawn.add(_withdrawal);
999 
1000     emit PopoEvents.onWithdrawInviteRewardToOrder
1001     (
1002       _pID,
1003       msg.sender,
1004       _withdrawal,
1005       now
1006     );
1007   }
1008 
1009   function withdrawTeamPot ()
1010     onlyCEO()
1011     isActivated()
1012     isHuman()
1013     public
1014   {
1015     if (teamPot_ <= 0) {
1016       return;
1017     }
1018 
1019     msg.sender.transfer(teamPot_);
1020     teamPot_ = 0;
1021   }
1022 
1023   function withdrawCommunityPot ()
1024     onlyCommunityLeader()
1025     isActivated()
1026     isHuman()
1027     public
1028   {
1029     if (communityPot_ <= 0) {
1030       return;
1031     }
1032 
1033     msg.sender.transfer(communityPot_);
1034     communityPot_ = 0;
1035   }
1036 
1037 }
1038 contract Popo is WithdrawPopo {
1039   
1040   constructor()
1041     public 
1042   {
1043 
1044   }
1045   
1046 }