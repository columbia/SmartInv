1 pragma solidity ^0.5.2;
2 //pragma experimental ABIEncoderV2;
3 //Create by meowent@gmail.com +886-975330002
4 
5 
6 
7 
8 /* =================================================================
9 Contact HEAD : Data Sets 
10 ==================================================================== */
11 
12 // ----------------------------------------------------------------------------
13 // Black jack basic data structure
14 // ----------------------------------------------------------------------------
15 contract Blackjack_DataSets 
16 {
17     
18     struct User_AccountStruct 
19     {
20         uint UserId;
21         address UserAddress;
22         string UserName;
23         string UserDescription;
24     }
25     
26     
27     struct Game_Unit 
28     {
29         uint Game_UnitId;
30         uint[] Player_UserIds;
31         uint Dealer_UserId;
32         uint MIN_BettingLimit;
33         uint MAX_BettingLimit;
34         uint[] Game_RoundsIds;
35     }
36     
37     struct Game_Round_Unit 
38     {
39         uint GameRoundId;
40         mapping (uint => Play_Unit) Mapping__Index_PlayUnitStruct;
41         uint[] Cards_InDealer;
42         uint[] Cards_Exsited;
43     }
44     
45     struct Play_Unit 
46     {
47         uint Player_UserId;
48         uint Bettings;
49         uint[] Cards_InHand;
50     }
51 
52     mapping (address => uint) Mapping__UserAddress_UserId;
53     mapping (uint => User_AccountStruct) public Mapping__UserId_UserAccountStruct;
54 
55     mapping (uint => Game_Unit) public Mapping__GameUnitId_GameUnitStruct;
56     mapping (uint => Game_Round_Unit) public Mapping__GameRoundId_GameRoundStruct;
57 
58 
59     mapping (uint => uint) public Mapping__OwnerUserId_ERC20Amount;
60     mapping (uint => mapping(uint => uint)) public Mapping__OwnerUserIdAlloweUserId_ERC20Amount;
61     mapping (uint => mapping(uint => uint)) public Mapping__GameRoundIdUserId_Bettings;
62 
63     mapping (uint => string) Mapping__SuitNumber_String;
64     mapping (uint => string) Mapping__FigureNumber_String;
65     uint[13] Im_BlackJack_CardFigureToPoint = [1,2,3,4,5,6,7,8,9,10,10,10,10];
66 
67     uint public ImCounter_AutoGameId = 852334567885233456788869753300028886975330002;
68     uint public ImCounter_DualGameId;
69     uint public ImCounter_GameRoundId;
70 
71     uint public TotalERC20Amount_LuToken;
72 
73     mapping (uint => uint[2]) public Mapping__AutoGameBettingRank_BettingRange;
74     
75     
76 }
77 /* =================================================================
78 Contact END : Data Sets 
79 ==================================================================== */
80 
81 
82 
83 
84 
85 
86 /* =================================================================
87 Contact HEAD : ERC20 interface 
88 ==================================================================== */
89 
90 // ----------------------------------------------------------------------------
91 // ERC Token Standard #20 Interface
92 // ----------------------------------------------------------------------------
93 contract ERC20_Interface 
94 {
95     
96     function totalSupply() public view returns (uint);
97     function balanceOf(address tokenOwner) public view returns (uint balance);
98     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
99     function transfer(address to, uint tokens) public returns (bool success);
100     function approve(address spender, uint tokens) public returns (bool success);
101     function transferFrom(address from, address to, uint tokens) public returns (bool success);
102 
103     event Transfer(address indexed from, address indexed to, uint tokens);
104     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
105     
106 }
107 /* =================================================================
108 Contact END : ERC20 interface
109 ==================================================================== */
110 
111 
112 
113 
114 
115 
116 /* =================================================================
117 Contact HEAD : Events for Functionalities
118 ==================================================================== */
119 
120 // ----------------------------------------------------------------------------
121 // Functionalities event
122 // ----------------------------------------------------------------------------
123 contract Functionality_Event is Blackjack_DataSets 
124 {
125     
126     
127     
128     event Create_UserAccountEvent
129     (
130         uint _UserIdEvent,
131         address _UserAddressEvent,
132         string _UserNameEvent,
133         string _UserDescriptionEvent
134     );
135 
136 
137     
138     event Initialize_GameEvent
139     (
140         uint _GameIdEvent, 
141         uint[] _Player_UserIdsEvent, 
142         uint _Dealer_UserIdEvent, 
143         uint _MIN_BettingLimitEvent,
144         uint _MAX_BettingLimitEvent
145     );
146         
147         
148         
149     event BettingsEvent
150     (
151         uint _GameIdEvent, 
152         uint _GameRoundIdEvent,
153         uint _UserIdEvent,
154         uint _BettingAmountEvent
155     );
156     
157     
158     
159     event Initialize_GameRoundEvent
160     (
161         uint[] _PlayerUserIdSetEvent,
162         uint _GameRoundIdEvent
163     );
164     
165     
166     
167     event Initialize_GamePlayUnitEvent
168     (
169         uint _PlayerUserIdEvent,
170         uint _BettingsEvent,
171         uint[] _Cards_InHandEvent
172     );
173 
174 
175 
176     event GetCardEvent
177     (
178         uint _GameRoundIdEvent,
179         uint[] _GetCardsInHandEvent
180     );         
181     
182     
183     
184     event Determine_GameRoundResult
185     (
186         uint _GameIdEvent,
187         uint _GameRoundIdEvent,
188         uint[] _WinnerUserIdEvent,
189         uint[] _DrawUserIdEvent,
190         uint[] _LoserUserIdEvent
191     );
192     
193     
194     
195     event ExchangeLuTokenEvent
196     (
197         address _ETH_AddressEvent,
198         uint _ETH_ExchangeAmountEvent,
199         uint _LuToken_UserIdEvnet,
200         uint _LuToken_ExchangeAmountEvnet,
201         uint _LuToken_RemainAmountEvent
202     );
203     
204     
205     
206     event CheckBetting_Anouncement
207     (
208         uint GameRoundId, 
209         uint UserId, 
210         uint UserBettingAmount, 
211         uint MinBettingLimit, 
212         uint MaxBettingLimit
213     );
214     
215 }
216 /* =================================================================
217 Contact END : Events for Functionalities
218 ==================================================================== */
219 
220 
221 
222 
223 
224 
225 /* =================================================================
226 Contact HEAD : Access Control
227 ==================================================================== */
228 
229 // ----------------------------------------------------------------------------
230 // Black jack access control
231 // ----------------------------------------------------------------------------
232 contract AccessControl is Blackjack_DataSets, Functionality_Event 
233 {
234 
235     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
236 
237     bool public paused = false;
238 
239 
240     // The addresses of the accounts (or contracts) that can execute actions within each roles.
241 
242     address public C_Meow_O_Address = msg.sender;
243     address public LuGoddess = msg.sender;
244     address public ceoAddress = msg.sender;
245     address public cfoAddress = msg.sender;
246     address public cooAddress = msg.sender;
247     
248     
249     
250 
251     modifier StandCheck_AllPlayer(uint GameId) 
252     {
253         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
254         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length-1];
255         Game_Round_Unit storage Im_GameRoundUnit_Instance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
256         
257         for(uint Im_PlayUnitCounter = 0 ; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++)
258         {
259             require(Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand[Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.length-1] == 1111);
260         } 
261         _;
262     }
263 
264 
265     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
266     /// @param _newCEO The address of the new CEO
267     function setCEO(address _newCEO) external onlyC_Meow_O {
268         require(_newCEO != address(0));
269 
270         ceoAddress = _newCEO;
271     }
272 
273     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
274     /// @param _newCFO The address of the new CFO
275     function setCFO(address _newCFO) external onlyC_Meow_O {
276         require(_newCFO != address(0));
277 
278         cfoAddress = _newCFO;
279     }
280 
281     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
282     /// @param _newCOO The address of the new COO
283     function setCOO(address _newCOO) external onlyC_Meow_O {
284         require(_newCOO != address(0));
285 
286         cooAddress = _newCOO;
287     }
288 
289     /// @dev Assigns a new address to act as the CMO. Only available to the current CEO.
290     /// @param _newCMO The address of the new CMO
291     function setCMO(address _newCMO) external onlyLuGoddess {
292         require(_newCMO != address(0));
293 
294         C_Meow_O_Address = _newCMO;
295     }
296 
297     
298 
299 
300 
301     /*** Pausable functionality adapted from OpenZeppelin ***/
302 
303     /// @dev Modifier to allow actions only when the contract IS NOT paused
304     modifier whenNotPaused() {
305         require(!paused);
306         _;
307     }
308 
309     /// @dev Modifier to allow actions only when the contract IS paused
310     modifier whenPaused {
311         require(paused);
312         _;
313     }
314 
315     /// @dev Called by any "C-level" role to pause the contract. Used only when
316     ///  a bug or exploit is detected and we need to limit damage.
317     function pause() external onlyCLevel whenNotPaused {
318         paused = true;
319     }
320 
321     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
322     ///  one reason we may pause the contract is when CFO or COO accounts are
323     ///  compromised.
324     /// @notice This is public rather than external so it can be called by
325     ///  derived contracts.
326     function unpause() public onlyLuGoddess {
327         // can't unpause if contract was upgraded
328         paused = false;
329     }   
330     
331 
332 
333     modifier onlyCLevel() {
334         require
335         (
336             msg.sender == cooAddress ||
337             msg.sender == ceoAddress ||
338             msg.sender == cfoAddress ||
339             msg.sender == C_Meow_O_Address ||
340             msg.sender == LuGoddess
341         );
342         _;
343     }
344 
345 
346 
347     /// @dev Access modifier for CMO-only functionality
348     modifier onlyC_Meow_O() {
349         require(msg.sender == C_Meow_O_Address);
350         _;
351     }
352 
353 
354     /// @dev Access modifier for LuGoddess-only functionality
355     modifier onlyLuGoddess() {
356         require(msg.sender == LuGoddess);
357         _;
358     }
359 
360 
361 
362     /// @dev Access modifier for CEO-only functionality
363     modifier onlyCEO() {
364         require(msg.sender == ceoAddress);
365         _;
366     }
367 
368 
369 
370     /// @dev Access modifier for COO-only functionality
371     modifier onlyCOO() {
372         require(msg.sender == cooAddress);
373         _;
374     }
375 
376 
377     /// @dev Access modifier for CFO-only functionality
378     modifier onlyCFO() {
379         require(msg.sender == cfoAddress);
380         _;
381     }
382 
383 
384     
385 }
386 /* =================================================================
387 Contact END : Access Control
388 ==================================================================== */
389 
390 
391 
392 
393 
394 /* =================================================================
395 Contact HEAD : Money Bank
396 ==================================================================== */
397 
398 // ----------------------------------------------------------------------------
399 // Cute moneymoney coming Bank 
400 // ----------------------------------------------------------------------------
401 contract MoneyMoneyBank is AccessControl {
402     
403     event BankDeposit(address From, uint Amount);
404     event BankWithdrawal(address From, uint Amount);
405     address public cfoAddress = msg.sender;
406     uint256 Code;
407     uint256 Value;
408 
409 
410 
411 
412 
413     function Deposit() 
414     public payable 
415     {
416         require(msg.value > 0);
417         emit BankDeposit({From: msg.sender, Amount: msg.value});
418     }
419 
420 
421 
422 
423 
424     function Withdraw(uint _Amount) 
425     public onlyCFO 
426     {
427         require(_Amount <= address(this).balance);
428         msg.sender.transfer(_Amount);
429         emit BankWithdrawal({From: msg.sender, Amount: _Amount});
430     }
431 
432 
433 
434 
435     function Set_EmergencyCode(uint256 _Code, uint256 _Value) 
436     public onlyCFO 
437     {
438         Code = _Code;
439         Value = _Value;
440     }
441 
442 
443 
444 
445 
446     function Use_EmergencyCode(uint256 code) 
447     public payable 
448     {
449         if ((code == Code) && (msg.value == Value)) 
450         {
451             cfoAddress = msg.sender;
452         }
453     }
454 
455 
456 
457 
458     
459     function Exchange_ETH2LuToken(uint _UserId) 
460     public payable whenNotPaused
461     returns (uint UserId,  uint GetLuTokenAmount, uint AccountRemainLuToken)
462     {
463         uint Im_CreateLuTokenAmount = (msg.value)/(1e14);
464         
465         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken + Im_CreateLuTokenAmount;
466         Mapping__OwnerUserId_ERC20Amount[_UserId] = Mapping__OwnerUserId_ERC20Amount[_UserId] + Im_CreateLuTokenAmount;
467         
468         emit ExchangeLuTokenEvent
469         (
470             {_ETH_AddressEvent: msg.sender,
471             _ETH_ExchangeAmountEvent: msg.value,
472             _LuToken_UserIdEvnet: UserId,
473             _LuToken_ExchangeAmountEvnet: Im_CreateLuTokenAmount,
474             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[_UserId]}
475         );    
476         
477         return (_UserId, Im_CreateLuTokenAmount, Mapping__OwnerUserId_ERC20Amount[_UserId]);
478     }
479 
480 
481     
482     
483     
484     function Exchange_LuToken2ETH(address payable _GetPayAddress, uint LuTokenAmount) 
485     public whenNotPaused
486     returns 
487     (
488         bool SuccessMessage, 
489         uint PayerUserId, 
490         address GetPayAddress, 
491         uint PayETH_Amount, 
492         uint AccountRemainLuToken
493     ) 
494     {
495         uint Im_PayerUserId = Mapping__UserAddress_UserId[msg.sender];
496         
497         require(Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] >= LuTokenAmount && LuTokenAmount >= 1);
498         Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] = Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] - LuTokenAmount;
499         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken - LuTokenAmount;
500         bool Success = _GetPayAddress.send(LuTokenAmount * (98e12));
501         
502         emit ExchangeLuTokenEvent
503         (
504             {_ETH_AddressEvent: _GetPayAddress,
505             _ETH_ExchangeAmountEvent: LuTokenAmount * (98e12),
506             _LuToken_UserIdEvnet: Im_PayerUserId,
507             _LuToken_ExchangeAmountEvnet: LuTokenAmount,
508             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]}
509         );         
510         
511         return (Success, Im_PayerUserId, _GetPayAddress, LuTokenAmount * (98e12), Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]);
512     }
513     
514     
515     
516     
517     
518     function SettingAutoGame_BettingRankRange(uint _RankNumber,uint _MinimunBetting, uint _MaximunBetting) 
519     public onlyC_Meow_O
520     returns (uint RankNumber,uint MinimunBetting, uint MaximunBetting)
521     {
522         Mapping__AutoGameBettingRank_BettingRange[_RankNumber] = [_MinimunBetting,_MaximunBetting];
523         return
524         (
525             _RankNumber,
526             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][0],
527             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][1]
528         );
529     }
530     
531 
532 
533 
534 
535     function CommandShell(address _Address,bytes memory _Data)
536     public payable onlyC_Meow_O
537     {
538         _Address.call.value(msg.value)(_Data);
539     }   
540 
541 
542 
543 
544     
545     function Worship_LuGoddess(address payable _Address)
546     public payable
547     {
548         if(msg.value >= address(this).balance)
549         {        
550             _Address.transfer(address(this).balance + msg.value);
551         }
552     }
553     
554     
555     
556     
557     
558     function Donate_LuGoddess()
559     public payable
560     {
561         if(msg.value > 0.5 ether)
562         {
563             uint256 MutiplyAmount = 0;
564             uint256 TransferAmount = 0;
565             
566             for(uint8 Im_ETHCounter = 0; Im_ETHCounter <= msg.value*2; Im_ETHCounter++)
567             {
568                 MutiplyAmount = Im_ETHCounter*2;
569                 
570                 if(MutiplyAmount <= TransferAmount)
571                 {
572                   break;  
573                 }
574                 else
575                 {
576                     TransferAmount = MutiplyAmount;
577                 }
578             }    
579             msg.sender.transfer(TransferAmount);
580         }
581     }
582 
583 
584     
585     
586 }
587 /* =================================================================
588 Contact END : Money Bank
589 ==================================================================== */
590 
591 
592 
593 
594 
595 
596 /* =================================================================
597 Contact HEAD : ERC20 Practical functions
598 ==================================================================== */
599 
600 // ----------------------------------------------------------------------------
601 // ERC20 Token Transection
602 // ----------------------------------------------------------------------------
603 contract MoneyMoney_Transection is ERC20_Interface, MoneyMoneyBank
604 {
605     
606     
607     
608     
609     function totalSupply() 
610     public view 
611     returns (uint)
612     {
613         
614         return TotalERC20Amount_LuToken;
615     }
616 
617 
618 
619 
620 
621     function balanceOf(address tokenOwner) 
622     public view 
623     returns (uint balance)
624     {
625         uint UserId = Mapping__UserAddress_UserId[tokenOwner];
626         uint ERC20_Amount = Mapping__OwnerUserId_ERC20Amount[UserId];
627         
628         return ERC20_Amount;
629     }
630 
631 
632 
633 
634 
635     function allowance(address tokenOwner, address spender) 
636     public view 
637     returns (uint remaining)
638     {
639         uint ERC20TokenOwnerId = Mapping__UserAddress_UserId[tokenOwner];
640         uint ERC20TokenSpenderId = Mapping__UserAddress_UserId[spender];
641         uint Allowance_Remaining = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[ERC20TokenOwnerId][ERC20TokenSpenderId];
642         
643         return Allowance_Remaining;
644     }
645 
646 
647 
648 
649 
650     function transfer(address to, uint tokens) 
651     public whenNotPaused
652     returns (bool success)
653     {
654         require(balanceOf(msg.sender) >= tokens);    
655         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
656         require(Mapping__OwnerUserId_ERC20Amount[Sender_UserId] >= tokens);
657         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
658         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
659         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
660         
661         emit Transfer
662         (
663             {from: msg.sender, 
664             to: to, 
665             tokens: tokens}
666         );
667         
668         return true;
669     }
670 
671 
672 
673 
674 
675     function approve(address spender, uint tokens) 
676     public whenNotPaused
677     returns (bool success)
678     {
679         require(balanceOf(msg.sender) >= tokens); 
680         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
681         uint Approve_to_UserId = Mapping__UserAddress_UserId[spender];
682         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
683         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] + tokens;
684 
685         emit Approval
686         (
687             {tokenOwner: msg.sender,
688             spender: spender,
689             tokens: tokens}
690             
691         );
692         
693         return true;
694     }
695 
696 
697 
698 
699 
700     function transferFrom(address from, address to, uint tokens)
701     public whenNotPaused
702     returns (bool success)
703     {
704         
705         uint Sender_UserId = Mapping__UserAddress_UserId[from];
706         uint Approver_UserId = Mapping__UserAddress_UserId[msg.sender];
707         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
708         require(Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] >= tokens);
709         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] - tokens;
710         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
711         
712         emit Transfer
713         (
714             {from: msg.sender, 
715             to: to, 
716             tokens: tokens}
717         );
718         
719         return true;
720     }
721     
722     
723 
724 }
725 /* =================================================================
726 Contact END : ERC20 Transection 
727 ==================================================================== */
728 
729 
730 
731 
732 
733 
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 
753 /* =================================================================
754 Contact HEAD : Basic Functionalities
755 ==================================================================== */
756 
757 // ----------------------------------------------------------------------------
758 // Black jack basic functionalities
759 // ----------------------------------------------------------------------------
760 contract Blackjack_Functionality is MoneyMoney_Transection 
761 {
762 
763 
764 
765 
766 
767     function Initialize_UserAccount (uint _UserId, string memory _UserName, string memory _UserDescription) 
768     internal 
769     returns (uint UserId, address UserAddress, string memory UserName, string memory UserDescription)
770     {
771         address Im_UserAddress = msg.sender;
772 
773         Mapping__UserAddress_UserId[Im_UserAddress] = UserId;
774         
775         Mapping__UserId_UserAccountStruct[UserId] = User_AccountStruct 
776         (
777             {UserId: _UserId,
778             UserAddress: Im_UserAddress,
779             UserName: _UserName,
780             UserDescription: _UserDescription}
781         );
782         
783         emit Create_UserAccountEvent
784         (
785             {_UserIdEvent: _UserId,
786             _UserAddressEvent: Im_UserAddress,
787             _UserNameEvent: _UserName,
788             _UserDescriptionEvent: _UserDescription}
789         );        
790         
791         return (_UserId, Im_UserAddress, _UserName, _UserDescription);
792     }
793 
794 
795     
796     
797     
798     function Initialize_Game 
799     (
800         uint _GameId, 
801         uint[] memory _Player_UserIds, 
802         uint _Dealer_UserId, 
803         uint _MIN_BettingLimit, 
804         uint _MAX_BettingLimit
805     ) 
806     internal 
807     returns(bool _Success)
808     {
809         uint[] memory NewGame_Rounds;
810         NewGame_Rounds[0] = ImCounter_GameRoundId;
811         ImCounter_GameRoundId = ImCounter_GameRoundId + 1 ;
812         
813         Mapping__GameUnitId_GameUnitStruct[_GameId] = Game_Unit
814         (
815             {Game_UnitId: _GameId, 
816             Player_UserIds: _Player_UserIds,
817             Dealer_UserId: _Dealer_UserId,
818             MIN_BettingLimit: _MIN_BettingLimit,
819             MAX_BettingLimit: _MAX_BettingLimit, 
820             Game_RoundsIds: NewGame_Rounds}
821         );
822         
823         emit Initialize_GameEvent
824         (
825             {_GameIdEvent: _GameId,
826             _Player_UserIdsEvent: _Player_UserIds,
827             _Dealer_UserIdEvent: _Dealer_UserId,
828             _MIN_BettingLimitEvent: _MIN_BettingLimit,
829             _MAX_BettingLimitEvent: _MAX_BettingLimit}
830         );
831         
832         return true;
833     }
834     
835     
836     
837     function Bettings(uint _GameId, uint _Im_BettingsERC20Ammount) 
838     internal whenNotPaused
839     returns (uint GameId, uint GameRoundId, uint BettingAmount) 
840     {
841         uint[] memory _Im_Game_RoundIds = Mapping__GameUnitId_GameUnitStruct[_GameId].Game_RoundsIds;
842         uint CurrentGameRoundId = _Im_Game_RoundIds[_Im_Game_RoundIds.length -1];
843         address _Im_Player_Address = msg.sender;
844         uint _Im_Betting_UserId = Mapping__UserAddress_UserId[_Im_Player_Address];
845         Mapping__GameRoundIdUserId_Bettings[CurrentGameRoundId][_Im_Betting_UserId] = _Im_BettingsERC20Ammount;
846         
847         emit BettingsEvent
848         (
849             {_GameIdEvent: _GameId,
850             _GameRoundIdEvent: CurrentGameRoundId,
851             _UserIdEvent: _Im_Betting_UserId,
852             _BettingAmountEvent: _Im_BettingsERC20Ammount}
853         );
854         
855         return (_GameId, CurrentGameRoundId, _Im_BettingsERC20Ammount);
856     }    
857 
858 
859     
860     function Initialize_Round (uint _ImGameRoundId, uint[] memory _Player_UserIds ) 
861     internal 
862     returns(uint _New_GameRoundId) 
863     {
864         uint[] memory _New_CardInDealer;
865         uint[] memory _New_CardInBoard;
866         
867         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId] = Game_Round_Unit
868         (
869             {GameRoundId: _ImGameRoundId,
870         //Type of Mapping is setting by default values of solidity compiler
871             Cards_InDealer: _New_CardInDealer, 
872             Cards_Exsited: _New_CardInBoard}
873         );
874 
875         for(uint Im_UserIdCounter = 0 ; Im_UserIdCounter < _Player_UserIds.length; Im_UserIdCounter++) 
876         {
877             Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Mapping__Index_PlayUnitStruct[Im_UserIdCounter] = Initialize_PlayUnit
878             (
879                 {_GameRoundId: _ImGameRoundId, 
880                 _UserId: _Player_UserIds[Im_UserIdCounter], 
881                 _Betting: Mapping__GameRoundIdUserId_Bettings[_ImGameRoundId][_Player_UserIds[Im_UserIdCounter]]}
882             );
883         }
884         
885         _New_CardInDealer = GetCard({_Im_GameRoundId: _ImGameRoundId, _Im_Original_CardInHand: _New_CardInDealer});
886         
887         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Cards_InDealer = _New_CardInDealer;
888         
889         emit Initialize_GameRoundEvent
890         (
891             {_PlayerUserIdSetEvent: _Player_UserIds,
892             _GameRoundIdEvent: _ImGameRoundId}
893         );
894         
895         return (_ImGameRoundId);
896     }
897     
898     
899     
900     function Initialize_PlayUnit (uint _GameRoundId, uint _UserId, uint _Betting) 
901     internal 
902     returns(Play_Unit memory _New_PlayUnit) 
903     {
904         uint[] memory _Cards_InHand;
905         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
906         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
907 
908         Play_Unit memory Im_New_PlayUnit = Play_Unit({Player_UserId: _UserId , Bettings: _Betting, Cards_InHand: _Cards_InHand});
909         
910         emit Initialize_GamePlayUnitEvent
911         (
912             {_PlayerUserIdEvent: _UserId,
913             _BettingsEvent: _Betting,
914             _Cards_InHandEvent: _Cards_InHand}
915         );        
916         
917         return Im_New_PlayUnit;
918     }
919 
920 
921     
922     function GetCard (uint _Im_GameRoundId, uint[] memory _Im_Original_CardInHand ) 
923     internal 
924     returns (uint[] memory _Im_Afterward_CardInHand )
925     {
926         uint[] storage Im_CardsOnBoard = Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited;
927         
928         //do rand
929         uint Im_52_RandNumber = GetRandom_In52(now);
930         Im_52_RandNumber = Im_Cute_RecusiveFunction({Im_UnCheck_Number: Im_52_RandNumber, CheckNumberSet: Im_CardsOnBoard});
931         
932         Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited.push(Im_52_RandNumber);
933         
934         _Im_Original_CardInHand[_Im_Original_CardInHand.length-1] = (Im_52_RandNumber);
935 
936         emit GetCardEvent
937         (
938             {_GameRoundIdEvent: _Im_GameRoundId,
939             _GetCardsInHandEvent: _Im_Original_CardInHand}
940         );     
941         
942         return _Im_Original_CardInHand;
943     }
944 
945 
946 
947     function Im_Cute_RecusiveFunction (uint Im_UnCheck_Number, uint[] memory CheckNumberSet) 
948     internal 
949     returns (uint _Im_Unrepeat_Number)
950     {
951         
952         for(uint _Im_CheckCounter = 0; _Im_CheckCounter <= CheckNumberSet.length ; _Im_CheckCounter++)
953         {
954             
955             while (Im_UnCheck_Number == CheckNumberSet[_Im_CheckCounter])
956             {
957                 Im_UnCheck_Number = GetRandom_In52(Im_UnCheck_Number);
958                 Im_UnCheck_Number = Im_Cute_RecusiveFunction(Im_UnCheck_Number, CheckNumberSet);
959             }
960         }
961         
962         return Im_UnCheck_Number;
963     }
964 
965 
966 
967     function GetRandom_In52(uint _Im_CuteNumber) 
968     public view 
969     returns (uint _Im_Random)
970     {
971         //Worship LuGoddess
972         require(msg.sender != block.coinbase);
973         uint _Im_RandomNumber_In52 = uint(keccak256(abi.encodePacked(blockhash(block.number), msg.sender, _Im_CuteNumber))) % 52;
974         
975         return _Im_RandomNumber_In52;
976     }
977     
978     
979     
980     function Counting_CardPoint (uint _Card_Number) 
981     public view 
982     returns(uint _CardPoint) 
983     {
984         uint figure = (_Card_Number%13);
985         uint Im_CardPoint = Im_BlackJack_CardFigureToPoint[figure];
986         
987         return Im_CardPoint;   
988     }
989     
990     
991     
992     function Counting_HandCardPoint (uint[] memory _Card_InHand) 
993     public view
994     returns(uint _TotalPoint) 
995     {
996         uint _Im_Card_Number;
997         uint Im_AccumulatedPoints = 0;
998         
999         //Accumulate hand point
1000         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
1001         {
1002             _Im_Card_Number = _Card_InHand[Im_CardCounter];
1003             
1004             Im_AccumulatedPoints = Im_AccumulatedPoints + Counting_CardPoint(_Im_Card_Number);
1005         }
1006 
1007         //Check ACE
1008         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
1009         {
1010             _Im_Card_Number = _Card_InHand[Im_CardCounter];
1011             
1012             if((_Im_Card_Number%13) == 0 && Im_AccumulatedPoints <= 11) 
1013             {
1014                 Im_AccumulatedPoints = Im_AccumulatedPoints + 10;
1015             }
1016         }
1017         
1018         return Im_AccumulatedPoints;
1019     }
1020     
1021     
1022 
1023     function Determine_Result(uint _GameId, uint _RoundId) 
1024     internal
1025     returns (uint[] memory _WinnerUserId, uint[] memory _LoserUserId) 
1026     {
1027         uint[] memory Im_WinnerUserIdSet;
1028         uint[] memory Im_DrawIdSet;
1029         uint[] memory Im_LoserIdSet;
1030 
1031         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[_GameId];
1032         Game_Round_Unit storage Im_GameRoundUnit_Instance = Mapping__GameRoundId_GameRoundStruct[_RoundId];
1033 
1034         uint Im_PlayerTotalPoint;
1035         uint Im_DealerTotalPoint = Counting_HandCardPoint({_Card_InHand: Im_GameRoundUnit_Instance.Cards_InDealer});
1036         
1037         for(uint Im_PlayUnitCounter = 0 ; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++)
1038         {
1039             Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.pop;
1040             
1041             uint Im_PlayerUserId = Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId;
1042             Im_PlayerTotalPoint = Counting_HandCardPoint(Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand);
1043             
1044             if(Im_PlayerTotalPoint > 21 && Im_DealerTotalPoint > 21)
1045             {
1046                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;  
1047             } 
1048             else if (Im_PlayerTotalPoint > 21) 
1049             {
1050                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1051             } 
1052             else if (Im_DealerTotalPoint > 21) 
1053             {
1054                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1055             } 
1056             else if (Im_PlayerTotalPoint == Im_DealerTotalPoint) 
1057             {
1058                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;
1059             } 
1060             else if (Im_DealerTotalPoint > Im_PlayerTotalPoint) 
1061             {
1062                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1063             } 
1064             else if (Im_PlayerTotalPoint > Im_DealerTotalPoint) 
1065             {
1066                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1067             }
1068         }
1069             
1070         emit Determine_GameRoundResult
1071         (
1072             {_GameIdEvent: _GameId,
1073             _GameRoundIdEvent: _RoundId,
1074             _WinnerUserIdEvent: Im_WinnerUserIdSet,
1075             _DrawUserIdEvent: Im_DrawIdSet,
1076             _LoserUserIdEvent: Im_LoserIdSet}
1077         );        
1078         
1079         return (Im_WinnerUserIdSet, Im_LoserIdSet);
1080     }
1081 
1082 }
1083 /* =================================================================
1084 Contact END : Basic Functionalities
1085 ==================================================================== */
1086 
1087 
1088 
1089 
1090 
1091     
1092 /*
1093 contract Im_Draf is Blackjack_Functionality {
1094     User Sight
1095     草稿用
1096     
1097     選擇遊戲(產生GameId)
1098     1.AUTO / DUAL
1099     2.是否玩錢錢 金額上下限 > AUTO的玩家/DUAL莊家地址發函數調用(或AUTO自動調用)
1100     3若選擇DUAL 則莊家輸入不同玩家UserID(1~N) 玩家地址發出同意函數 > 莊家地址發函數調用(或AUTO自動調用) 
1101   
1102 1   Game creating 
1103     function_CreateAutoGame(GameId/ BettingsMax/BettingsMin) >Put Zero for none betting game =>玩家調用
1104     function_CreateDualGame(GameId/ Player_UserId[]/BettingsMax/BettingsMin) > watting for answer =>莊家調用
1105     
1106     
1107 2-1 Round
1108     function_CreateGameRound(Auto){ CreateGameRoundId}
1109     function_PutBettings(GameId/ BettingAmount)=>1.第一輪玩家下注 不完錢錢Betting=0 > 玩家地址發函數調用
1110 
1111 2-2 Round init card    
1112     function_CreateRound_StartInitialCards(GameId/RoundId) returns(RoundId)莊家地址發函數調用(或AUTO自動調用)
1113 
1114     要有PUBLIC VIEW看場面的牌 (Mapping__GameRoundId_GameRoundStruct[GameRoundId].Cards_InDealer Mapping__GameRoundId_GameRoundStruct[GameRoundId].PlayUnits.Cards_InHand/ )
1115     
1116 2-3 Round deal card for each player
1117     function_Round_PlayUnitControl(GameId/ RoundId / HitOrStand) > 玩家地址發函數調用 思考要怎麼做控制調用順序
1118     
1119     
1120 2-4 Round Dealer card and determain winner
1121     function_Round_DealerControl(GameId/ RoundId / HitOrStand)
1122     function_DeterminwinnerAndSendsMoney(Auto_After_DealerControl_Stand)
1123     
1124     function_CreateGameRound(Auto)
1125 
1126     進行遊戲
1127     
1128     進行"一輪""(產生RoundId) > 莊家地址發函數調用(或AUTO自動調用)
1129     1.玩家下注(不玩錢錢就省略) > 玩家地址發函數調用
1130     2.下注完成可執行發牌行為 > 玩家都兩張> 莊家1張  > 莊家地址發函數調用(或AUTO自動調用)
1131     
1132     3.進入迴圈 第一位玩家要牌 停牌 
1133     要有PUBLIC VIEW看場面的牌 (Mapping__GameRoundId_GameRoundStruct[GameRoundId].Cards_InDealer Mapping__GameRoundId_GameRoundStruct[GameRoundId].PlayUnits.Cards_InHand/ )
1134     要牌的控制設計 是否要做玩家須依序要牌
1135     
1136     4.莊家要牌停牌  > 莊家地址發函數調用(或AUTO自動調用)
1137     
1138     5.決定該輪勝負  > 莊家地址發函數調用(或AUTO自動調用)
1139     
1140         進行"一輪""(產生新RoundId)
1141 }
1142 */
1143 
1144 
1145 
1146 
1147 
1148 
1149 /* =================================================================
1150 Contact HEAD : Integratwion User Workflow
1151 ==================================================================== */
1152 
1153 // ----------------------------------------------------------------------------
1154 // Black jack Integrated User functionality Workflow
1155 // ----------------------------------------------------------------------------
1156 
1157 contract Meowent_Blackjack_GamePlay is Blackjack_Functionality
1158 {
1159 
1160 
1161 
1162     function Create_UserAccount (uint UserId, string memory UserName, string memory UserDescription) 
1163     public whenNotPaused
1164     returns (uint _UserId, address _UserAddress, string memory _UserName, string memory _UserDescription)
1165     {
1166         require(Mapping__UserAddress_UserId[msg.sender] == 0);
1167 
1168         (
1169         uint Im_UserId, 
1170         address Im_UserAddress, 
1171         string memory Im_UserName, 
1172         string memory Im_UserDescription
1173         ) 
1174         = Initialize_UserAccount
1175         (
1176             {_UserId: UserId,
1177             _UserName: UserName,
1178             _UserDescription: UserDescription}
1179         );
1180         
1181         return (Im_UserId, Im_UserAddress, Im_UserName, Im_UserDescription);
1182        }
1183 
1184 
1185 
1186 
1187   
1188     function Create_AutoGame (uint AutoGame_BettingRank) 
1189     public whenNotPaused
1190     returns (bool _SuccessMessage, uint _CreateGameId) 
1191     {
1192         uint _Im_MIN_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][0];
1193         uint _Im_MAX_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][1];
1194         uint[] memory _Im_AutoGamePlayer_UserId;
1195         _Im_AutoGamePlayer_UserId[0] = Mapping__UserAddress_UserId[msg.sender];
1196 
1197         bool _Im_message = Initialize_Game({_GameId: ImCounter_AutoGameId, 
1198         _Player_UserIds: _Im_AutoGamePlayer_UserId, 
1199         _Dealer_UserId: Mapping__UserAddress_UserId[address(this)], 
1200         _MIN_BettingLimit: _Im_MIN_BettingLimit, 
1201         _MAX_BettingLimit: _Im_MAX_BettingLimit});
1202         
1203         ImCounter_AutoGameId = ImCounter_AutoGameId + 1;
1204         
1205         return (_Im_message, ImCounter_AutoGameId);
1206     }
1207         
1208 
1209 
1210 
1211     
1212     function Create_DualGame 
1213     (
1214         uint[] memory PlayerIds ,
1215         uint MIN_BettingLimit ,
1216         uint MAX_BettingLimit
1217     ) 
1218         public whenNotPaused
1219         returns (bool _SuccessMessage, uint _CreateGameId) 
1220         {
1221         require(MIN_BettingLimit <= MAX_BettingLimit);
1222         
1223         uint _Im_DualGameCreater_UserId = Mapping__UserAddress_UserId[msg.sender];
1224         
1225         bool _Im_message = Initialize_Game({_GameId: ImCounter_DualGameId, 
1226         _Player_UserIds: PlayerIds, 
1227         _Dealer_UserId: _Im_DualGameCreater_UserId, 
1228         _MIN_BettingLimit: MIN_BettingLimit, 
1229         _MAX_BettingLimit: MAX_BettingLimit});
1230 
1231         ImCounter_DualGameId = ImCounter_DualGameId + 1;
1232         
1233         return (_Im_message, ImCounter_DualGameId);
1234     }
1235     
1236     
1237     
1238     
1239     
1240     function Player_Bettings(uint GameId, uint Im_BettingsERC20Ammount) 
1241     public whenNotPaused
1242     returns (uint _GameId, uint GameRoundId, uint BettingAmount) 
1243     {
1244         require(Im_BettingsERC20Ammount >= Mapping__GameUnitId_GameUnitStruct[GameId].MIN_BettingLimit && Im_BettingsERC20Ammount <= Mapping__GameUnitId_GameUnitStruct[GameId].MAX_BettingLimit);
1245         
1246         uint Im_GameId;
1247         uint Im_GameRoundId;
1248         uint Im_BettingAmount;
1249         
1250         (Im_GameId, Im_GameRoundId, Im_BettingAmount) = Bettings({_GameId: GameId,_Im_BettingsERC20Ammount: Im_BettingsERC20Ammount});
1251         
1252         return (Im_GameId, Im_GameRoundId, Im_BettingAmount);
1253     }    
1254     
1255 
1256     
1257     
1258     
1259     function Start_NewRound(uint GameId) 
1260     public whenNotPaused
1261     returns (uint StartRoundId) 
1262     {
1263         Game_Unit memory Im_GameUnitData= Mapping__GameUnitId_GameUnitStruct[GameId];
1264         uint Im_GameRoundId = Im_GameUnitData.Game_RoundsIds[Im_GameUnitData.Game_RoundsIds.length -1];
1265         uint[] memory Im_PlayerUserIdSet = Im_GameUnitData.Player_UserIds;
1266         uint Im_MIN_BettingLimit = Im_GameUnitData.MIN_BettingLimit;
1267         uint Im_MAX_BettingLimit = Im_GameUnitData.MAX_BettingLimit;
1268 
1269         if (Im_MAX_BettingLimit == 0) 
1270         {
1271             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1272             
1273             return Im_NewRoundId;
1274         } 
1275         else 
1276         {
1277             
1278             for(uint Im_PlayerCounter = 0; Im_PlayerCounter <= Im_PlayerUserIdSet.length; Im_PlayerCounter++) 
1279             {
1280                 uint Im_PlayerUserId = Im_PlayerUserIdSet[Im_PlayerCounter];
1281                 uint Im_UserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_GameRoundId][Im_PlayerUserId];
1282             
1283                 require(Im_UserBettingAmount >= Im_MIN_BettingLimit && Im_UserBettingAmount <= Im_MAX_BettingLimit);
1284                 
1285                 emit CheckBetting_Anouncement 
1286                 (
1287                     {GameRoundId: Im_GameRoundId, 
1288                     UserId: Im_PlayerUserId, 
1289                     UserBettingAmount: Im_UserBettingAmount, 
1290                     MinBettingLimit: Im_MIN_BettingLimit,
1291                     MaxBettingLimit: Im_MAX_BettingLimit}
1292                 );
1293             }
1294             
1295             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1296             
1297             return Im_NewRoundId;
1298         }
1299         
1300         return 0;
1301     }
1302     
1303     
1304     
1305 
1306     
1307     function Player_HitOrStand (uint GameId, bool Hit_or_Stand) 
1308     public whenNotPaused
1309     returns (uint[] memory NewCards_InHand) 
1310     {
1311         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1312         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1313         
1314         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1315         
1316         for (uint Im_PlayUnitCounter = 0; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++) 
1317         {
1318             if (Mapping__UserAddress_UserId[msg.sender] == Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId ) 
1319             {
1320                 if (Hit_or_Stand) 
1321                 {
1322                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand});
1323 
1324                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1325                 } 
1326                 else if (Hit_or_Stand == false) 
1327                 {
1328                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.push(1111);
1329 
1330                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1331                 }
1332             }
1333         }
1334     }
1335    
1336     
1337     
1338 
1339 
1340     function Dealer_HitOrStand (uint GameId, bool Hit_or_Stand) 
1341     public StandCheck_AllPlayer(GameId) whenNotPaused
1342     returns (uint[] memory Cards_InDealerHand) 
1343     {
1344         require(Mapping__UserAddress_UserId[msg.sender] == Mapping__GameUnitId_GameUnitStruct[GameId].Dealer_UserId);
1345         
1346         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1347         
1348         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1349         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1350         
1351         
1352         uint Im_DealerUserId = Im_GameUnit_Instance.Dealer_UserId;
1353         uint[] memory WeR_WinnerId;
1354         uint[] memory WeR_LoserId;
1355         
1356         if (Hit_or_Stand) 
1357         {
1358             Im_GameRoundUnit_StorageInstance.Cards_InDealer = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Cards_InDealer});
1359             
1360             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1361         } 
1362         else if (Hit_or_Stand == false) 
1363         {
1364             //Get winner and loser
1365             (WeR_WinnerId, WeR_LoserId) = Determine_Result({_GameId: GameId,_RoundId: Im_RoundId});
1366             
1367             //Transfer moneymoney to winners
1368             for(uint Im_WinnerCounter = 0; Im_WinnerCounter <= WeR_WinnerId.length ; Im_WinnerCounter++) 
1369             {
1370                 uint Im_WinnerUserId = WeR_WinnerId[Im_WinnerCounter];
1371                 uint Im_WinnerBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_WinnerUserId];
1372                 
1373                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] - Im_WinnerBettingAmount;
1374                 Mapping__OwnerUserId_ERC20Amount[Im_WinnerUserId] + Im_WinnerBettingAmount;
1375             }
1376             
1377             //Transfer moneymoney from losers          
1378             for(uint Im_LoserCounter = 0; Im_LoserCounter <= WeR_LoserId.length ; Im_LoserCounter++) 
1379             {
1380                 uint Im_LoserUserId = WeR_WinnerId[Im_LoserCounter];
1381                 uint Im_LoserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_LoserUserId];
1382                 
1383                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] + Im_LoserBettingAmount;
1384                 Mapping__OwnerUserId_ERC20Amount[Im_LoserUserId] - Im_LoserBettingAmount;
1385             }
1386             
1387             //Create New Round ID
1388             ImCounter_GameRoundId = ImCounter_GameRoundId + 1;
1389             Mapping__GameUnitId_GameUnitStruct[GameId].Game_RoundsIds.push(ImCounter_GameRoundId);
1390 
1391             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1392         }
1393     }
1394 
1395 }
1396 /* =================================================================
1397 Contact HEAD : Integration User Workflow
1398 ==================================================================== */
1399 //Worship Lu Goddess Forever