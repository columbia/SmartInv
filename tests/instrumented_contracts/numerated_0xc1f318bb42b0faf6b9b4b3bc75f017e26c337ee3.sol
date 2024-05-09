1 pragma solidity ^ 0.4.19;
2 
3 contract Ownable {
4 
5  
6 
7     address public owner;
8 
9  
10 
11     function Ownable() public {
12 
13  
14 
15         owner = msg.sender;
16 
17  
18 
19     }
20 
21  
22 
23     function _msgSender() internal view returns (address)
24 
25  
26 
27     {
28 
29  
30 
31         return msg.sender;
32 
33  
34 
35     }
36 
37  
38 
39     modifier onlyOwner {
40 
41  
42 
43         require(msg.sender == owner);
44 
45  
46 
47         _;
48 
49  
50 
51     }
52 
53  
54 
55 }
56 
57  
58 
59  
60 
61  
62 
63 contract SafeMath {
64 
65  
66 
67   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
68 
69  
70 
71     uint256 c = a * b;
72 
73  
74 
75     assert(a == 0 || c / a == b);
76 
77  
78 
79     return c;
80 
81  
82 
83   }
84 
85  
86 
87  
88 
89  
90 
91   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
92 
93  
94 
95     assert(b > 0);
96 
97  
98 
99     uint256 c = a / b;
100 
101  
102 
103     assert(a == b * c + a % b);
104 
105  
106 
107     return c;
108 
109  
110 
111   }
112 
113  
114 
115  
116 
117  
118 
119   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
120 
121  
122 
123     assert(b <= a);
124 
125  
126 
127     return a - b;
128 
129  
130 
131   }
132 
133  
134 
135  
136 
137  
138 
139   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
140 
141  
142 
143     uint256 c = a + b;
144 
145  
146 
147     assert(c>=a && c>=b);
148 
149  
150 
151     return c;
152 
153  
154 
155   }
156 
157  
158 
159  
160 
161  
162 
163   function assert(bool assertion) internal {
164 
165  
166 
167     if (!assertion) {
168 
169       throw;
170 
171     }
172   }
173 }
174 
175 
176 contract Tomato is Ownable, SafeMath {
177 
178  
179     /* Public variables of the token */
180 
181  
182 
183     string public name = 'Test Tomato Stable Coin Cash';
184 
185  
186 
187     string public symbol = 'TTSCH';
188 
189  
190 
191     uint8 public decimals = 8;
192 
193  
194 
195     uint256 public totalSupply =(2999999999  * (10 ** uint256(decimals)));
196 
197  
198 
199     uint public TotalHoldersAmount;
200 
201  
202 
203     
204 
205  
206 
207     /*Lock transfer from all accounts */
208 
209  
210 
211     bool private Lock = false;
212 
213  
214 
215     bool public CanChange = true;
216 
217  
218 
219     
220 
221  
222 
223     address public admin;
224 
225  
226 
227     address public AddressForReturn;
228 
229  
230 
231     
232 
233  
234 
235     address[] Accounts;
236 
237  
238 
239     /* This creates an array with all balances */
240 
241  
242 
243     mapping(address => uint256) public balanceOf;
244 
245  
246 
247     mapping(address => mapping(address => uint256)) public allowance;
248 
249  
250 
251    /*Individual Lock*/
252 
253  
254 
255     mapping(address => bool) public AccountIsLock;
256 
257  
258 
259     /*Allow transfer for ICO, Admin accounts if IsLock==true*/
260 
261  
262 
263     mapping(address => bool) public AccountIsNotLock;
264 
265  
266 
267     
268 
269  
270 
271    /*Allow transfer tokens only to ReturnWallet*/
272 
273  
274 
275     mapping(address => bool) public AccountIsNotLockForReturn;
276 
277  
278 
279     mapping(address => uint) public AccountIsLockByDate;
280 
281  
282 
283     
284 
285  
286 
287     mapping (address => bool) public isHolder;
288 
289  
290 
291     mapping (address => bool) public isArrAccountIsLock;
292 
293  
294 
295     mapping (address => bool) public isArrAccountIsNotLock;
296 
297  
298 
299     mapping (address => bool) public isArrAccountIsNotLockForReturn;
300 
301  
302 
303     mapping (address => bool) public isArrAccountIsLockByDate;
304 
305     
306 
307  
308 
309     address [] public Arrholders;
310 
311  
312 
313     address [] public ArrAccountIsLock;
314 
315  
316 
317     address [] public ArrAccountIsNotLock;
318 
319  
320 
321     address [] public ArrAccountIsNotLockForReturn;
322 
323  
324 
325     address [] public ArrAccountIsLockByDate;
326 
327  
328 
329    
330 
331  
332 
333     /* This generates a public event on the blockchain that will notify clients */
334 
335  
336 
337     event Transfer(address indexed from, address indexed to, uint256 value);
338 
339  
340 
341     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
342 
343  
344 
345     event StartBurn(address indexed from, uint256 value);
346 
347  
348 
349     event StartAllLock(address indexed account);
350 
351  
352 
353     event StartAllUnLock(address indexed account);
354 
355  
356 
357     event StartUseLock(address indexed account,bool re);
358 
359  
360 
361     event StartUseUnLock(address indexed account,bool re);
362 
363  
364 
365     event StartAdmin(address indexed account);
366 
367     event ReturnAdmin(address indexed account);
368     
369     event PauseAdmin(address indexed account);
370  
371 
372  
373 
374  
375 
376  
377 
378     modifier IsNotLock{
379 
380  
381 
382       require(((!Lock&&AccountIsLock[msg.sender]!=true)||((Lock)&&AccountIsNotLock[msg.sender]==true))&&now>AccountIsLockByDate[msg.sender]);
383 
384  
385 
386       _;
387 
388  
389 
390      }
391 
392  
393 
394      
395 
396  
397 
398      modifier isCanChange{
399 
400          
401 
402          if(CanChange == true)
403 
404          {
405 
406              require((msg.sender==owner||msg.sender==admin));
407 
408          }
409 
410          else if(CanChange == false)
411 
412          {
413 
414              require(msg.sender==owner);
415 
416          }
417       _;
418 
419  
420 
421      }
422 
423  
424 
425      modifier whenNotPaused(){
426 
427  
428 
429          require(!Lock);
430 
431  
432 
433          _;
434 
435  
436 
437      }
438 
439  
440 
441      
442 
443  
444 
445     /* Initializes contract with initial supply tokens to the creator of the contract */
446 
447  
448 
449    
450 
451  
452 
453   function Tomato() public {
454 
455  
456 
457         balanceOf[msg.sender] = totalSupply;
458 
459  
460 
461         Arrholders[Arrholders.length++]=msg.sender;
462 
463  
464 
465         admin=msg.sender;
466 
467  
468 
469     }
470 
471  
472 
473     
474 
475  
476 
477      function AddAdmin(address _address) public onlyOwner{
478 
479         
480 
481         require(CanChange);
482 
483  
484 
485         admin=_address;
486 
487  
488 
489         StartAdmin(admin);
490 
491     }
492 
493     
494 
495  
496 
497     modifier whenNotLock(){
498 
499  
500 
501         require(!Lock);
502 
503  
504 
505         _;
506 
507  
508 
509     }
510 
511  
512 
513     modifier whenLock() {
514 
515  
516 
517         require(Lock);
518 
519  
520 
521         _;
522 
523  
524 
525     }
526 
527  
528 
529     
530 
531  
532 
533     function AllLock()public isCanChange whenNotLock{
534 
535  
536 
537         Lock = true;
538 
539  
540 
541         StartAllLock(_msgSender()); 
542 
543  
544 
545     }
546 
547  
548 
549     function AllUnLock()public isCanChange whenLock{
550 
551  
552 
553         Lock = false;
554 
555  
556 
557         StartAllUnLock(_msgSender()); 
558 
559  
560 
561     }
562 
563     
564 
565     function UnStopAdmin()public onlyOwner{
566 
567         CanChange = true;
568         
569         ReturnAdmin(_msgSender());
570     }
571 
572     
573 
574     function StopAdmin() public onlyOwner{
575 
576         CanChange = false;
577 
578         PauseAdmin(_msgSender());
579     }
580 
581  
582 
583     
584 
585  
586 
587     // function setCanChange(bool _canChange)public onlyOwner{
588 
589     //   //  require(CanChange);
590 
591     //  CanChange=_canChange;
592 
593     // }
594 
595  
596 
597  
598 
599  
600 
601     function UseLock(address _address)public onlyOwner{
602 
603  
604 
605     bool _IsLock = true;
606 
607  
608 
609      AccountIsLock[_address]=_IsLock;
610 
611  
612 
613      if (isArrAccountIsLock[_address] != true) {
614 
615  
616 
617         ArrAccountIsLock[ArrAccountIsLock.length++] = _address;
618 
619  
620 
621         isArrAccountIsLock[_address] = true;
622 
623  
624 
625     }if(_IsLock == true){
626 
627  
628 
629     StartUseLock(_address,_IsLock);
630 
631  
632 
633         }
634 
635  
636 
637     }
638 
639 
640     function UseUnLock(address _address)public onlyOwner{
641 
642  
643 
644         bool _IsLock = false;
645 
646  
647 
648      AccountIsLock[_address]=_IsLock;
649 
650  
651 
652      if (isArrAccountIsLock[_address] != true) {
653 
654  
655 
656         ArrAccountIsLock[ArrAccountIsLock.length++] = _address;
657 
658  
659 
660         isArrAccountIsLock[_address] = true;
661 
662  
663 
664     }
665 
666  
667 
668     if(_IsLock == false){
669 
670  
671 
672     StartUseUnLock(_address,_IsLock);
673 
674  
675 
676         }
677 
678  
679 
680     }
681 
682  
683 
684     
685 
686  
687 
688     function setAccountIsNotLock(address _address, bool _IsLock)public onlyOwner{
689 
690  
691 
692      AccountIsNotLock[_address]=_IsLock;
693 
694  
695 
696      if (isArrAccountIsNotLock[_address] != true) {
697 
698  
699 
700         ArrAccountIsNotLock[ArrAccountIsNotLock.length++] = _address;
701 
702  
703 
704         isArrAccountIsNotLock[_address] = true;
705 
706  
707 
708      }
709 
710     }
711 
712  
713 
714     function setAccountIsNotLockForReturn(address _address, bool _IsLock)public onlyOwner{
715 
716  
717 
718      AccountIsNotLockForReturn[_address]=_IsLock;
719 
720  
721 
722       if (isArrAccountIsNotLockForReturn[_address] != true) {
723 
724  
725 
726         ArrAccountIsNotLockForReturn[ArrAccountIsNotLockForReturn.length++] = _address;
727 
728  
729 
730         isArrAccountIsNotLockForReturn[_address] = true;
731 
732  
733 
734     }
735 
736  
737 
738     }
739 
740 
741     /* Send coins */
742 
743  
744 
745     function transfer(address _to, uint256 _value) public  {
746 
747  
748 
749         require(((!Lock&&AccountIsLock[msg.sender]!=true)||((Lock)&&AccountIsNotLock[msg.sender]==true)||(AccountIsNotLockForReturn[msg.sender]==true&&_to==AddressForReturn))&&now>AccountIsLockByDate[msg.sender]);
750 
751  
752 
753         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
754 
755  
756 
757         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
758 
759  
760 
761         balanceOf[msg.sender] -= _value; // Subtract from the sender
762 
763  
764 
765         balanceOf[_to] += _value; // Add the same to the recipient
766 
767  
768 
769         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
770 
771  
772 
773         if (isHolder[_to] != true) {
774 
775  
776 
777         Arrholders[Arrholders.length++] = _to;
778 
779  
780 
781         isHolder[_to] = true;
782 
783  
784 
785     }}
786 
787 
788 
789     /* Allow another contract to spend some tokens in your behalf */
790 
791  
792 
793     function approve(address _spender, uint256 _value)public
794 
795  
796 
797     returns(bool success) {
798 
799  
800 
801         allowance[msg.sender][_spender] = _value;
802 
803  
804 
805         Approval(msg.sender, _spender, _value);
806 
807  
808 
809         return true;
810 
811  
812 
813     }
814 
815 
816 
817     /* A contract attempts to get the coins */
818 
819  
820 
821     function transferFrom(address _from, address _to, uint256 _value)public IsNotLock returns(bool success)  {
822 
823  
824 
825         require(((!Lock&&AccountIsLock[_from]!=true)||((Lock)&&AccountIsNotLock[_from]==true))&&now>AccountIsLockByDate[_from]);
826 
827  
828 
829         require (balanceOf[_from] >= _value) ; // Check if the sender has enough
830 
831  
832 
833         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
834 
835  
836 
837         require (_value <= allowance[_from][msg.sender]) ; // Check allowance
838 
839  
840 
841         balanceOf[_from] -= _value; // Subtract from the sender
842 
843  
844 
845         balanceOf[_to] += _value; // Add the same to the recipient
846 
847  
848 
849         allowance[_from][msg.sender] -= _value;
850 
851  
852 
853         Transfer(_from, _to, _value);
854 
855  
856 
857         if (isHolder[_to] != true) {
858 
859  
860 
861         Arrholders[Arrholders.length++] = _to;
862 
863  
864 
865         isHolder[_to] = true;
866 
867  
868 
869         }
870 
871  
872 
873         return true;
874 
875  
876 
877     }
878 
879  
880 
881  
882 
883  
884 
885  /* @param _value the amount of money to burn*/
886 
887  
888 
889     function Burn(uint256 _value)public onlyOwner returns (bool success) {
890 
891  
892 
893         require(msg.sender != address(0));
894 
895  
896 
897         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
898 
899  
900 
901 		if (_value <= 0) throw; 
902 
903  
904 
905         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
906 
907  
908 
909         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
910 
911  
912 
913         Transfer(msg.sender,address(0),_value);
914 
915  
916 
917         StartBurn(msg.sender, _value);
918 
919  
920 
921         return true;
922 
923  
924 
925     }
926 
927  
928 
929     
930 
931  
932 
933     function GetHoldersCount () public view returns (uint _HoldersCount){
934 
935  
936 
937   
938 
939  
940 
941          return (Arrholders.length-1);
942 
943  
944 
945     }
946 
947  
948 
949     
950 
951  
952 
953     function GetAccountIsLockCount () public view returns (uint _Count){
954 
955  
956 
957   
958 
959  
960 
961          return (ArrAccountIsLock.length);
962 
963  
964 
965     }
966 
967  
968 
969     
970 
971  
972 
973     function GetAccountIsNotLockForReturnCount () public view returns (uint _Count){
974 
975  
976 
977   
978 
979  
980 
981          return (ArrAccountIsNotLockForReturn.length);
982 
983  
984 
985     }
986 
987  
988 
989     
990 
991  
992 
993     function GetAccountIsNotLockCount () public view returns (uint _Count){
994 
995  
996 
997   
998 
999  
1000 
1001          return (ArrAccountIsNotLock.length);
1002 
1003  
1004 
1005     }
1006 
1007  
1008 
1009     
1010 
1011  
1012 
1013      function GetAccountIsLockByDateCount () public view returns (uint _Count){
1014 
1015  
1016 
1017   
1018 
1019  
1020 
1021          return (ArrAccountIsLockByDate.length);
1022 
1023  
1024 
1025     }
1026 
1027  
1028 
1029      
1030 
1031  
1032 
1033      function SetAddressForReturn (address _address) public onlyOwner  returns (bool success ){
1034 
1035  
1036 
1037          AddressForReturn=_address;
1038 
1039  
1040 
1041          return true;
1042 
1043  
1044 
1045     }
1046 
1047 
1048     /* This unnamed function is called whenever someone tries to send ether to it */
1049 
1050  
1051 
1052    function () public payable {
1053 
1054  
1055 
1056          revert();
1057 
1058  
1059 
1060     }
1061 
1062  
1063 
1064 }