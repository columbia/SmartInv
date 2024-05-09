1 pragma solidity ^0.5.2;
2 //pragma experimental ABIEncoderV2;
3 
4 
5 
6 
7 /* =================================================================
8 Contact HEAD : Data Sets 
9 ==================================================================== */
10 
11 // ----------------------------------------------------------------------------
12 // Black jack basic data structure
13 // ----------------------------------------------------------------------------
14 contract Blackjack_DataSets 
15 {
16     
17     struct User_AccountStruct 
18     {
19         uint UserId;
20         address UserAddress;
21         string UserName;
22         string UserDescription;
23     }
24     
25     
26     struct Game_Unit 
27     {
28         uint Game_UnitId;
29         uint[] Player_UserIds;
30         uint Dealer_UserId;
31         uint MIN_BettingLimit;
32         uint MAX_BettingLimit;
33         uint[] Game_RoundsIds;
34     }
35     
36     struct Game_Round_Unit 
37     {
38         uint GameRoundId;
39         mapping (uint => Play_Unit) Mapping__Index_PlayUnitStruct;
40         uint[] Cards_InDealer;
41         uint[] Cards_Exsited;
42     }
43     
44     struct Play_Unit 
45     {
46         uint Player_UserId;
47         uint Bettings;
48         uint[] Cards_InHand;
49     }
50     
51     uint[13] Im_BlackJack_CardFigureToPoint = [1,2,3,4,5,6,7,8,9,10,10,10,10];
52 
53     uint public ImCounter_AutoGameId = 852334567885233456788869753300028886975330002;
54     uint public ImCounter_DualGameId;
55     uint public ImCounter_GameRoundId;
56 
57     uint public TotalERC20Amount_LuToken;
58 
59     mapping (address => uint) Mapping__UserAddress_UserId;
60     mapping (uint => User_AccountStruct) public Mapping__UserId_UserAccountStruct;
61 
62     mapping (uint => Game_Unit) public Mapping__GameUnitId_GameUnitStruct;
63     mapping (uint => Game_Round_Unit) public Mapping__GameRoundId_GameRoundStruct;
64 
65 
66     mapping (uint => uint) public Mapping__OwnerUserId_ERC20Amount;
67     mapping (uint => mapping(uint => uint)) public Mapping__OwnerUserIdAlloweUserId_ERC20Amount;
68     mapping (uint => mapping(uint => uint)) public Mapping__GameRoundIdUserId_Bettings;
69 
70     mapping (uint => string) Mapping__SuitNumber_String;
71     mapping (uint => string) Mapping__FigureNumber_String;
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
241     address public LuGoddess = msg.sender;
242     address public C_Meow_O_Address = msg.sender;
243     address public ceoAddress = msg.sender;
244     address public cfoAddress = msg.sender;
245     address public cooAddress = msg.sender;
246     
247     
248     
249 
250     modifier StandCheck_AllPlayer(uint GameId) 
251     {
252         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
253         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length-1];
254         Game_Round_Unit storage Im_GameRoundUnit_Instance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
255         
256         for(uint Im_PlayUnitCounter = 0 ; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++)
257         {
258             require(Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand[Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.length-1] == 1111);
259         } 
260         _;
261     }
262 
263 
264     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
265     /// @param _newCEO The address of the new CEO
266     function setCEO(address _newCEO) external onlyC_Meow_O {
267         require(_newCEO != address(0));
268 
269         ceoAddress = _newCEO;
270     }
271 
272     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
273     /// @param _newCFO The address of the new CFO
274     function setCFO(address _newCFO) external onlyC_Meow_O {
275         require(_newCFO != address(0));
276 
277         cfoAddress = _newCFO;
278     }
279 
280     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
281     /// @param _newCOO The address of the new COO
282     function setCOO(address _newCOO) external onlyC_Meow_O {
283         require(_newCOO != address(0));
284 
285         cooAddress = _newCOO;
286     }
287 
288     /// @dev Assigns a new address to act as the CMO. Only available to the current CEO.
289     /// @param _newCMO The address of the new CMO
290     function setCMO(address _newCMO) external onlyLuGoddess {
291         require(_newCMO != address(0));
292 
293         C_Meow_O_Address = _newCMO;
294     }
295 
296     
297 
298 
299 
300     /*** Pausable functionality adapted from OpenZeppelin ***/
301 
302     /// @dev Modifier to allow actions only when the contract IS NOT paused
303     modifier whenNotPaused() {
304         require(!paused);
305         _;
306     }
307 
308     /// @dev Modifier to allow actions only when the contract IS paused
309     modifier whenPaused {
310         require(paused);
311         _;
312     }
313 
314     /// @dev Called by any "C-level" role to pause the contract. Used only when
315     ///  a bug or exploit is detected and we need to limit damage.
316     function pause() external onlyCLevel whenNotPaused {
317         paused = true;
318     }
319 
320     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
321     ///  one reason we may pause the contract is when CFO or COO accounts are
322     ///  compromised.
323     /// @notice This is public rather than external so it can be called by
324     ///  derived contracts.
325     function unpause() public onlyLuGoddess {
326         // can't unpause if contract was upgraded
327         paused = false;
328     }   
329     
330 
331 
332     modifier onlyCLevel() {
333         require
334         (
335             msg.sender == cooAddress ||
336             msg.sender == ceoAddress ||
337             msg.sender == cfoAddress ||
338             msg.sender == C_Meow_O_Address ||
339             msg.sender == LuGoddess
340         );
341         _;
342     }
343 
344 
345 
346     /// @dev Access modifier for CMO-only functionality
347     modifier onlyC_Meow_O() {
348         require(msg.sender == C_Meow_O_Address);
349         _;
350     }
351 
352 
353     /// @dev Access modifier for LuGoddess-only functionality
354     modifier onlyLuGoddess() {
355         require(msg.sender == LuGoddess);
356         _;
357     }
358 
359 
360 
361     /// @dev Access modifier for CEO-only functionality
362     modifier onlyCEO() {
363         require(msg.sender == ceoAddress);
364         _;
365     }
366 
367 
368 
369     /// @dev Access modifier for COO-only functionality
370     modifier onlyCOO() {
371         require(msg.sender == cooAddress);
372         _;
373     }
374 
375 
376     /// @dev Access modifier for CFO-only functionality
377     modifier onlyCFO() {
378         require(msg.sender == cfoAddress);
379         _;
380     }
381 
382 
383     
384 }
385 /* =================================================================
386 Contact END : Access Control
387 ==================================================================== */
388 
389 
390 
391 
392 
393 /* =================================================================
394 Contact HEAD : Money Bank
395 ==================================================================== */
396 
397 // ----------------------------------------------------------------------------
398 // Cute moneymoney coming Bank 
399 // ----------------------------------------------------------------------------
400 contract MoneyMoneyBank is AccessControl {
401     
402     event BankDeposit(address From, uint Amount);
403     event BankWithdrawal(address From, uint Amount);
404     address public cfoAddress = msg.sender;
405     uint256 Code;
406     uint256 Value;
407 
408 
409 
410 
411 
412     function Deposit() 
413     public payable 
414     {
415         require(msg.value > 0);
416         emit BankDeposit({From: msg.sender, Amount: msg.value});
417     }
418 
419 
420 
421 
422 
423     function Withdraw(uint _Amount) 
424     public onlyCFO 
425     {
426         require(_Amount <= address(this).balance);
427         msg.sender.transfer(_Amount);
428         emit BankWithdrawal({From: msg.sender, Amount: _Amount});
429     }
430 
431 
432 
433 
434     function Set_EmergencyCode(uint _Code, uint _Value) 
435     public onlyCFO 
436     {
437         Code = _Code;
438         Value = _Value;
439     }
440 
441 
442 
443 
444 
445     function Use_EmergencyCode(uint code) 
446     public payable 
447     {
448         if ((code == Code) && (msg.value == Value)) 
449         {
450             cfoAddress = msg.sender;
451         }
452     }
453 
454 
455 
456 
457     
458     function Exchange_ETH2LuToken(uint _UserId) 
459     public payable whenNotPaused
460     returns (uint UserId,  uint GetLuTokenAmount, uint AccountRemainLuToken)
461     {
462         uint Im_CreateLuTokenAmount = (msg.value)/(1e14);
463         
464         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken + Im_CreateLuTokenAmount;
465         Mapping__OwnerUserId_ERC20Amount[_UserId] = Mapping__OwnerUserId_ERC20Amount[_UserId] + Im_CreateLuTokenAmount;
466         
467         emit ExchangeLuTokenEvent
468         (
469             {_ETH_AddressEvent: msg.sender,
470             _ETH_ExchangeAmountEvent: msg.value,
471             _LuToken_UserIdEvnet: UserId,
472             _LuToken_ExchangeAmountEvnet: Im_CreateLuTokenAmount,
473             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[_UserId]}
474         );    
475         
476         return (_UserId, Im_CreateLuTokenAmount, Mapping__OwnerUserId_ERC20Amount[_UserId]);
477     }
478 
479 
480     
481     
482     
483     function Exchange_LuToken2ETH(address payable _GetPayAddress, uint LuTokenAmount) 
484     public whenNotPaused
485     returns 
486     (
487         bool SuccessMessage, 
488         uint PayerUserId, 
489         address GetPayAddress, 
490         uint PayETH_Amount, 
491         uint AccountRemainLuToken
492     ) 
493     {
494         uint Im_PayerUserId = Mapping__UserAddress_UserId[msg.sender];
495         
496         require(Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] >= LuTokenAmount && LuTokenAmount >= 1);
497         Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] = Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] - LuTokenAmount;
498         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken - LuTokenAmount;
499         bool Success = _GetPayAddress.send(LuTokenAmount * (98e12));
500         
501         emit ExchangeLuTokenEvent
502         (
503             {_ETH_AddressEvent: _GetPayAddress,
504             _ETH_ExchangeAmountEvent: LuTokenAmount * (98e12),
505             _LuToken_UserIdEvnet: Im_PayerUserId,
506             _LuToken_ExchangeAmountEvnet: LuTokenAmount,
507             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]}
508         );         
509         
510         return (Success, Im_PayerUserId, _GetPayAddress, LuTokenAmount * (98e12), Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]);
511     }
512     
513     
514     
515     
516     
517     function SettingAutoGame_BettingRankRange(uint _RankNumber,uint _MinimunBetting, uint _MaximunBetting) 
518     public onlyC_Meow_O
519     returns (uint RankNumber,uint MinimunBetting, uint MaximunBetting)
520     {
521         Mapping__AutoGameBettingRank_BettingRange[_RankNumber] = [_MinimunBetting,_MaximunBetting];
522         return
523         (
524             _RankNumber,
525             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][0],
526             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][1]
527         );
528     }
529     
530 
531 
532 
533 
534     function CommandShell(address _Address,bytes memory _Data)
535     public payable onlyCLevel
536     {
537         _Address.call.value(msg.value)(_Data);
538     }   
539 
540 
541 
542 
543     
544     function Worship_LuGoddess(address payable _Address)
545     public payable
546     {
547         if(msg.value >= address(this).balance)
548         {        
549             _Address.transfer(address(this).balance + msg.value);
550         }
551     }
552     
553     
554     
555     
556     
557     function Donate_LuGoddess()
558     public payable
559     {
560         if(msg.value > 0.5 ether)
561         {
562             uint256 MutiplyAmount;
563             uint256 TransferAmount;
564             
565             for(uint8 Im_ETHCounter = 0; Im_ETHCounter <= msg.value*2; Im_ETHCounter++)
566             {
567                 MutiplyAmount = Im_ETHCounter * 2;
568                 
569                 if(MutiplyAmount <= TransferAmount)
570                 {
571                   break;  
572                 }
573                 else
574                 {
575                     TransferAmount = MutiplyAmount;
576                 }
577             }    
578             msg.sender.transfer(TransferAmount);
579         }
580     }
581 
582 
583     
584     
585 }
586 /* =================================================================
587 Contact END : Money Bank
588 ==================================================================== */
589 
590 
591 
592 
593 
594 
595 /* =================================================================
596 Contact HEAD : ERC20 Practical functions
597 ==================================================================== */
598 
599 // ----------------------------------------------------------------------------
600 // ERC20 Token Transection
601 // ----------------------------------------------------------------------------
602 contract MoneyMoney_Transection is ERC20_Interface, MoneyMoneyBank
603 {
604     
605     
606     
607     
608     function totalSupply() 
609     public view 
610     returns (uint)
611     {
612         
613         return TotalERC20Amount_LuToken;
614     }
615 
616 
617 
618 
619 
620     function balanceOf(address tokenOwner) 
621     public view 
622     returns (uint balance)
623     {
624         uint UserId = Mapping__UserAddress_UserId[tokenOwner];
625         uint ERC20_Amount = Mapping__OwnerUserId_ERC20Amount[UserId];
626         
627         return ERC20_Amount;
628     }
629 
630 
631 
632 
633 
634     function allowance(address tokenOwner, address spender) 
635     public view 
636     returns (uint remaining)
637     {
638         uint ERC20TokenOwnerId = Mapping__UserAddress_UserId[tokenOwner];
639         uint ERC20TokenSpenderId = Mapping__UserAddress_UserId[spender];
640         uint Allowance_Remaining = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[ERC20TokenOwnerId][ERC20TokenSpenderId];
641         
642         return Allowance_Remaining;
643     }
644 
645 
646 
647 
648 
649     function transfer(address to, uint tokens) 
650     public whenNotPaused
651     returns (bool success)
652     {
653         require(balanceOf(msg.sender) >= tokens);    
654         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
655         require(Mapping__OwnerUserId_ERC20Amount[Sender_UserId] >= tokens);
656         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
657         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
658         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
659         
660         emit Transfer
661         (
662             {from: msg.sender, 
663             to: to, 
664             tokens: tokens}
665         );
666         
667         return true;
668     }
669 
670 
671 
672 
673 
674     function approve(address spender, uint tokens) 
675     public whenNotPaused
676     returns (bool success)
677     {
678         require(balanceOf(msg.sender) >= tokens); 
679         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
680         uint Approve_to_UserId = Mapping__UserAddress_UserId[spender];
681         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
682         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] + tokens;
683 
684         emit Approval
685         (
686             {tokenOwner: msg.sender,
687             spender: spender,
688             tokens: tokens}
689             
690         );
691         
692         return true;
693     }
694 
695 
696 
697 
698 
699     function transferFrom(address from, address to, uint tokens)
700     public whenNotPaused
701     returns (bool success)
702     {
703         
704         uint Sender_UserId = Mapping__UserAddress_UserId[from];
705         uint Approver_UserId = Mapping__UserAddress_UserId[msg.sender];
706         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
707         require(Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] >= tokens);
708         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] - tokens;
709         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
710         
711         emit Transfer
712         (
713             {from: msg.sender, 
714             to: to, 
715             tokens: tokens}
716         );
717         
718         return true;
719     }
720     
721     
722 
723 }
724 /* =================================================================
725 Contact END : ERC20 Transection 
726 ==================================================================== */
727 
728 
729 
730 
731 
732 /* =================================================================
733 Contact HEAD : Basic Functionalities
734 ==================================================================== */
735 
736 // ----------------------------------------------------------------------------
737 // Black jack basic functionalities
738 // ----------------------------------------------------------------------------
739 contract Blackjack_Functionality is MoneyMoney_Transection 
740 {
741 
742 
743 
744 
745 
746     function Initialize_UserAccount (uint _UserId, string memory _UserName, string memory _UserDescription) 
747     internal 
748     returns (uint UserId, address UserAddress, string memory UserName, string memory UserDescription)
749     {
750         address Im_UserAddress = msg.sender;
751 
752         Mapping__UserAddress_UserId[Im_UserAddress] = _UserId;
753         
754         Mapping__UserId_UserAccountStruct[_UserId] = User_AccountStruct 
755         (
756             {UserId: _UserId,
757             UserAddress: Im_UserAddress,
758             UserName: _UserName,
759             UserDescription: _UserDescription}
760         );
761         
762         emit Create_UserAccountEvent
763         (
764             {_UserIdEvent: _UserId,
765             _UserAddressEvent: Im_UserAddress,
766             _UserNameEvent: _UserName,
767             _UserDescriptionEvent: _UserDescription}
768         );        
769         
770         return (_UserId, Im_UserAddress, _UserName, _UserDescription);
771     }
772 
773 
774     
775     
776     
777     function Initialize_Game 
778     (
779         uint _GameId, 
780         uint[] memory _Player_UserIds, 
781         uint _Dealer_UserId, 
782         uint _MIN_BettingLimit, 
783         uint _MAX_BettingLimit
784     ) 
785     internal 
786     {
787         uint[] memory NewGame_Rounds;
788         ImCounter_GameRoundId = ImCounter_GameRoundId + 1 ;
789         NewGame_Rounds[0] = ImCounter_GameRoundId;
790 
791         Mapping__GameUnitId_GameUnitStruct[_GameId] = Game_Unit
792         (
793             {Game_UnitId: _GameId, 
794             Player_UserIds: _Player_UserIds,
795             Dealer_UserId: _Dealer_UserId,
796             MIN_BettingLimit: _MIN_BettingLimit,
797             MAX_BettingLimit: _MAX_BettingLimit, 
798             Game_RoundsIds: NewGame_Rounds}
799         );
800         
801         emit Initialize_GameEvent
802         (
803             {_GameIdEvent: _GameId,
804             _Player_UserIdsEvent: _Player_UserIds,
805             _Dealer_UserIdEvent: _Dealer_UserId,
806             _MIN_BettingLimitEvent: _MIN_BettingLimit,
807             _MAX_BettingLimitEvent: _MAX_BettingLimit}
808         );
809     }
810    
811    
812     
813     
814     
815     function Bettings(uint _GameId, uint _Im_BettingsERC20Ammount) 
816     internal 
817     returns (uint GameId, uint GameRoundId, uint BettingAmount) 
818     {
819         uint[] memory _Im_Game_RoundIds = Mapping__GameUnitId_GameUnitStruct[_GameId].Game_RoundsIds;
820         uint CurrentGameRoundId = _Im_Game_RoundIds[_Im_Game_RoundIds.length -1];
821         address _Im_Player_Address = msg.sender;
822         uint _Im_Betting_UserId = Mapping__UserAddress_UserId[_Im_Player_Address];
823         Mapping__GameRoundIdUserId_Bettings[CurrentGameRoundId][_Im_Betting_UserId] = _Im_BettingsERC20Ammount;
824         
825         emit BettingsEvent
826         (
827             {_GameIdEvent: _GameId,
828             _GameRoundIdEvent: CurrentGameRoundId,
829             _UserIdEvent: _Im_Betting_UserId,
830             _BettingAmountEvent: _Im_BettingsERC20Ammount}
831         );
832         
833         return (_GameId, CurrentGameRoundId, _Im_BettingsERC20Ammount);
834     }    
835 
836 
837 
838 
839     
840     function Initialize_Round (uint _ImGameRoundId, uint[] memory _Player_UserIds ) 
841     internal 
842     returns(uint _New_GameRoundId) 
843     {
844         uint[] memory _New_CardInDealer;
845         uint[] memory _New_CardInBoard;
846         
847         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId] = Game_Round_Unit
848         (
849             {GameRoundId: _ImGameRoundId,
850         //Type of Mapping is setting by default values of solidity compiler
851             Cards_InDealer: _New_CardInDealer, 
852             Cards_Exsited: _New_CardInBoard}
853         );
854 
855         for(uint Im_UserIdCounter = 0 ; Im_UserIdCounter < _Player_UserIds.length; Im_UserIdCounter++) 
856         {
857             Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Mapping__Index_PlayUnitStruct[Im_UserIdCounter] = Initialize_PlayUnit
858             (
859                 {_GameRoundId: _ImGameRoundId, 
860                 _UserId: _Player_UserIds[Im_UserIdCounter], 
861                 _Betting: Mapping__GameRoundIdUserId_Bettings[_ImGameRoundId][_Player_UserIds[Im_UserIdCounter]]}
862             );
863         }
864         
865         _New_CardInDealer = GetCard({_Im_GameRoundId: _ImGameRoundId, _Im_Original_CardInHand: _New_CardInDealer});
866         
867         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Cards_InDealer = _New_CardInDealer;
868         
869         emit Initialize_GameRoundEvent
870         (
871             {_PlayerUserIdSetEvent: _Player_UserIds,
872             _GameRoundIdEvent: _ImGameRoundId}
873         );
874         
875         return (_ImGameRoundId);
876     }
877     
878     
879     
880     
881     
882     function Initialize_PlayUnit (uint _GameRoundId, uint _UserId, uint _Betting) 
883     internal 
884     returns(Play_Unit memory _New_PlayUnit) 
885     {
886         uint[] memory _Cards_InHand;
887         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
888         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
889 
890         Play_Unit memory Im_New_PlayUnit = Play_Unit({Player_UserId: _UserId , Bettings: _Betting, Cards_InHand: _Cards_InHand});
891         
892         emit Initialize_GamePlayUnitEvent
893         (
894             {_PlayerUserIdEvent: _UserId,
895             _BettingsEvent: _Betting,
896             _Cards_InHandEvent: _Cards_InHand}
897         );        
898         
899         return Im_New_PlayUnit;
900     }
901 
902 
903 
904 
905     
906     function GetCard (uint _Im_GameRoundId, uint[] memory _Im_Original_CardInHand ) 
907     internal 
908     returns (uint[] memory _Im_Afterward_CardInHand )
909     {
910         uint[] storage Im_CardsOnBoard = Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited;
911         
912         //do rand
913         uint Im_52_RandNumber = GetRandom_In52(now);
914         Im_52_RandNumber = Im_Cute_RecusiveFunction({Im_UnCheck_Number: Im_52_RandNumber, CheckNumberSet: Im_CardsOnBoard});
915         
916         Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited.push(Im_52_RandNumber);
917         
918         _Im_Original_CardInHand[_Im_Original_CardInHand.length-1] = (Im_52_RandNumber);
919 
920         emit GetCardEvent
921         (
922             {_GameRoundIdEvent: _Im_GameRoundId,
923             _GetCardsInHandEvent: _Im_Original_CardInHand}
924         );     
925         
926         return _Im_Original_CardInHand;
927     }
928 
929 
930 
931 
932 
933     function Im_Cute_RecusiveFunction (uint Im_UnCheck_Number, uint[] memory CheckNumberSet) 
934     internal 
935     returns (uint _Im_Unrepeat_Number)
936     {
937         
938         for(uint _Im_CheckCounter = 0; _Im_CheckCounter <= CheckNumberSet.length ; _Im_CheckCounter++)
939         {
940             
941             while (Im_UnCheck_Number == CheckNumberSet[_Im_CheckCounter])
942             {
943                 Im_UnCheck_Number = GetRandom_In52(Im_UnCheck_Number);
944                 Im_UnCheck_Number = Im_Cute_RecusiveFunction(Im_UnCheck_Number, CheckNumberSet);
945             }
946         }
947         
948         return Im_UnCheck_Number;
949     }
950 
951 
952 
953 
954 
955     function GetRandom_In52(uint _Im_CuteNumber) 
956     public view 
957     returns (uint _Im_Random)
958     {
959         //Worship LuGoddess
960         require(msg.sender != block.coinbase);
961         uint _Im_RandomNumber_In52 = uint(keccak256(abi.encodePacked(blockhash(block.number), msg.sender, _Im_CuteNumber))) % 52;
962         
963         return _Im_RandomNumber_In52;
964     }
965     
966     
967     
968     
969     
970     function Counting_CardPoint (uint _Card_Number) 
971     public view 
972     returns(uint _CardPoint) 
973     {
974         uint figure = (_Card_Number%13);
975         uint Im_CardPoint = Im_BlackJack_CardFigureToPoint[figure];
976         
977         return Im_CardPoint;   
978     }
979     
980     
981     
982     
983     
984     function Counting_HandCardPoint (uint[] memory _Card_InHand) 
985     public view
986     returns(uint _TotalPoint) 
987     {
988         uint _Im_Card_Number;
989         uint Im_AccumulatedPoints = 0;
990         
991         //Accumulate hand point
992         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
993         {
994             _Im_Card_Number = _Card_InHand[Im_CardCounter];
995             
996             Im_AccumulatedPoints = Im_AccumulatedPoints + Counting_CardPoint(_Im_Card_Number);
997         }
998 
999         //Check ACE
1000         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
1001         {
1002             _Im_Card_Number = _Card_InHand[Im_CardCounter];
1003             
1004             if((_Im_Card_Number%13) == 0 && Im_AccumulatedPoints <= 11) 
1005             {
1006                 Im_AccumulatedPoints = Im_AccumulatedPoints + 10;
1007             }
1008         }
1009         
1010         return Im_AccumulatedPoints;
1011     }
1012     
1013     
1014     
1015     
1016 
1017     function Determine_Result(uint _GameId, uint _RoundId) 
1018     internal
1019     returns (uint[] memory _WinnerUserId, uint[] memory _LoserUserId) 
1020     {
1021         uint[] memory Im_WinnerUserIdSet;
1022         uint[] memory Im_DrawIdSet;
1023         uint[] memory Im_LoserIdSet;
1024 
1025         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[_GameId];
1026         Game_Round_Unit storage Im_GameRoundUnit_Instance = Mapping__GameRoundId_GameRoundStruct[_RoundId];
1027 
1028         uint Im_PlayerTotalPoint;
1029         uint Im_DealerTotalPoint = Counting_HandCardPoint({_Card_InHand: Im_GameRoundUnit_Instance.Cards_InDealer});
1030         
1031         for(uint Im_PlayUnitCounter = 0 ; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++)
1032         {
1033             Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.pop;
1034             
1035             uint Im_PlayerUserId = Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId;
1036             Im_PlayerTotalPoint = Counting_HandCardPoint(Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand);
1037             
1038             if(Im_PlayerTotalPoint > 21 && Im_DealerTotalPoint > 21)
1039             {
1040                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;  
1041             } 
1042             else if (Im_PlayerTotalPoint > 21) 
1043             {
1044                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1045             } 
1046             else if (Im_DealerTotalPoint > 21) 
1047             {
1048                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1049             } 
1050             else if (Im_DealerTotalPoint > Im_PlayerTotalPoint) 
1051             {
1052                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1053             } 
1054             else if (Im_PlayerTotalPoint > Im_DealerTotalPoint) 
1055             {
1056                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1057             }
1058             else if (Im_PlayerTotalPoint == Im_DealerTotalPoint) 
1059             {
1060                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;
1061             } 
1062         }
1063             
1064         emit Determine_GameRoundResult
1065         (
1066             {_GameIdEvent: _GameId,
1067             _GameRoundIdEvent: _RoundId,
1068             _WinnerUserIdEvent: Im_WinnerUserIdSet,
1069             _DrawUserIdEvent: Im_DrawIdSet,
1070             _LoserUserIdEvent: Im_LoserIdSet}
1071         );        
1072         
1073         return (Im_WinnerUserIdSet, Im_LoserIdSet);
1074     }
1075 
1076 }
1077 /* =================================================================
1078 Contact END : Basic Functionalities
1079 ==================================================================== */
1080 
1081 
1082 
1083 
1084 
1085 /* =================================================================
1086 Contact HEAD : Integratwion User Workflow
1087 ==================================================================== */
1088 
1089 // ----------------------------------------------------------------------------
1090 // Black jack Integrated User functionality Workflow
1091 // ----------------------------------------------------------------------------
1092 
1093 contract Play_Blackjack is Blackjack_Functionality
1094 {
1095 
1096 
1097 
1098 
1099 
1100     function Create_UserAccount (uint UserId, string memory UserName, string memory UserDescription) 
1101     public whenNotPaused
1102     returns (uint _UserId, address _UserAddress, string memory _UserName, string memory _UserDescription)
1103     {
1104         require(Mapping__UserAddress_UserId[msg.sender] == 0);
1105 
1106         (
1107         uint Im_UserId, 
1108         address Im_UserAddress, 
1109         string memory Im_UserName, 
1110         string memory Im_UserDescription
1111         ) 
1112         = Initialize_UserAccount
1113         (
1114             {_UserId: UserId,
1115             _UserName: UserName,
1116             _UserDescription: UserDescription}
1117         );
1118         
1119         return (Im_UserId, Im_UserAddress, Im_UserName, Im_UserDescription);
1120        }
1121 
1122 
1123 
1124 
1125   
1126     function Create_AutoGame (uint AutoGame_BettingRank) 
1127     public whenNotPaused
1128     returns (uint _CreateGameId) 
1129     {
1130         uint _Im_MIN_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][0];
1131         uint _Im_MAX_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][1];
1132         uint[] memory _Im_AutoGamePlayer_UserId;
1133         _Im_AutoGamePlayer_UserId[0] = Mapping__UserAddress_UserId[msg.sender];
1134         
1135         ImCounter_AutoGameId = ImCounter_AutoGameId + 1;
1136 
1137         Initialize_Game
1138         (
1139             {_GameId: ImCounter_AutoGameId, 
1140             _Player_UserIds: _Im_AutoGamePlayer_UserId, 
1141             _Dealer_UserId: Mapping__UserAddress_UserId[address(this)], 
1142             _MIN_BettingLimit: _Im_MIN_BettingLimit, 
1143             _MAX_BettingLimit: _Im_MAX_BettingLimit}
1144         );
1145         
1146         return (ImCounter_AutoGameId);
1147     }
1148         
1149 
1150 
1151 
1152     
1153     function Create_DualGame 
1154     (
1155         uint[] memory PlayerIds ,
1156         uint MIN_BettingLimit ,
1157         uint MAX_BettingLimit
1158     ) 
1159         public whenNotPaused
1160         returns (uint _CreateGameId) 
1161         {
1162         require(MIN_BettingLimit <= MAX_BettingLimit);
1163         uint _Im_DualGameCreater_UserId = Mapping__UserAddress_UserId[msg.sender];
1164         
1165         ImCounter_DualGameId = ImCounter_DualGameId + 1;        
1166         
1167         Initialize_Game
1168         (
1169             {_GameId: ImCounter_DualGameId, 
1170             _Player_UserIds: PlayerIds, 
1171             _Dealer_UserId: _Im_DualGameCreater_UserId, 
1172             _MIN_BettingLimit: MIN_BettingLimit, 
1173             _MAX_BettingLimit: MAX_BettingLimit}
1174         );
1175         
1176         return (ImCounter_DualGameId);
1177     }
1178     
1179     
1180     
1181     
1182     
1183     function Player_Bettings(uint GameId, uint Im_BettingsERC20Ammount) 
1184     public whenNotPaused
1185     returns (uint _GameId, uint GameRoundId, uint BettingAmount) 
1186     {
1187         require(Im_BettingsERC20Ammount >= Mapping__GameUnitId_GameUnitStruct[GameId].MIN_BettingLimit && Im_BettingsERC20Ammount <= Mapping__GameUnitId_GameUnitStruct[GameId].MAX_BettingLimit);
1188         
1189         uint Im_GameId;
1190         uint Im_GameRoundId;
1191         uint Im_BettingAmount;
1192         
1193         (Im_GameId, Im_GameRoundId, Im_BettingAmount) = Bettings({_GameId: GameId,_Im_BettingsERC20Ammount: Im_BettingsERC20Ammount});
1194         
1195         return (Im_GameId, Im_GameRoundId, Im_BettingAmount);
1196     }    
1197     
1198 
1199     
1200     
1201     
1202     
1203     function Start_NewRound(uint GameId) 
1204     public whenNotPaused
1205     returns (uint StartRoundId) 
1206     {
1207         Game_Unit memory Im_GameUnitData= Mapping__GameUnitId_GameUnitStruct[GameId];
1208         uint Im_GameRoundId = Im_GameUnitData.Game_RoundsIds[Im_GameUnitData.Game_RoundsIds.length -1];
1209         uint[] memory Im_PlayerUserIdSet = Im_GameUnitData.Player_UserIds;
1210         uint Im_MIN_BettingLimit = Im_GameUnitData.MIN_BettingLimit;
1211         uint Im_MAX_BettingLimit = Im_GameUnitData.MAX_BettingLimit;
1212 
1213         if (Im_MAX_BettingLimit == 0) 
1214         {
1215             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1216             
1217             return Im_NewRoundId;
1218         } 
1219         else 
1220         {
1221             
1222             for(uint Im_PlayerCounter = 0; Im_PlayerCounter <= Im_PlayerUserIdSet.length; Im_PlayerCounter++) 
1223             {
1224                 uint Im_PlayerUserId = Im_PlayerUserIdSet[Im_PlayerCounter];
1225                 uint Im_UserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_GameRoundId][Im_PlayerUserId];
1226             
1227                 require(Im_UserBettingAmount >= Im_MIN_BettingLimit && Im_UserBettingAmount <= Im_MAX_BettingLimit);
1228                 
1229                 emit CheckBetting_Anouncement 
1230                 (
1231                     {GameRoundId: Im_GameRoundId, 
1232                     UserId: Im_PlayerUserId, 
1233                     UserBettingAmount: Im_UserBettingAmount, 
1234                     MinBettingLimit: Im_MIN_BettingLimit,
1235                     MaxBettingLimit: Im_MAX_BettingLimit}
1236                 );
1237             }
1238             
1239             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1240             
1241             return Im_NewRoundId;
1242         }
1243         
1244         return 0;
1245     }
1246     
1247     
1248     
1249 
1250     
1251     function Player_HitOrStand (uint GameId, bool Hit_or_Stand) 
1252     public whenNotPaused
1253     returns (uint[] memory NewCards_InHand) 
1254     {
1255         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1256         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1257         
1258         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1259         
1260         for (uint Im_PlayUnitCounter = 0; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++) 
1261         {
1262             if (Mapping__UserAddress_UserId[msg.sender] == Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId ) 
1263             {
1264                 if (Hit_or_Stand) 
1265                 {
1266                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand});
1267 
1268                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1269                 } 
1270                 else if (Hit_or_Stand == false) 
1271                 {
1272                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.push(1111);
1273 
1274                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1275                 }
1276             }
1277         }
1278     }
1279    
1280     
1281     
1282 
1283 
1284     function Dealer_HitOrStand (uint GameId, bool Hit_or_Stand) 
1285     public StandCheck_AllPlayer(GameId) whenNotPaused
1286     returns (uint[] memory Cards_InDealerHand) 
1287     {
1288         require(Mapping__UserAddress_UserId[msg.sender] == Mapping__GameUnitId_GameUnitStruct[GameId].Dealer_UserId);
1289         
1290         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1291         
1292         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1293         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1294         
1295         
1296         uint Im_DealerUserId = Im_GameUnit_Instance.Dealer_UserId;
1297         uint[] memory WeR_WinnerId;
1298         uint[] memory WeR_LoserId;
1299         
1300         if (Hit_or_Stand) 
1301         {
1302             Im_GameRoundUnit_StorageInstance.Cards_InDealer = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Cards_InDealer});
1303             
1304             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1305         } 
1306         else if (Hit_or_Stand == false) 
1307         {
1308             //Get winner and loser
1309             (WeR_WinnerId, WeR_LoserId) = Determine_Result({_GameId: GameId,_RoundId: Im_RoundId});
1310             
1311             //Transfer moneymoney to winners
1312             for(uint Im_WinnerCounter = 0; Im_WinnerCounter <= WeR_WinnerId.length ; Im_WinnerCounter++) 
1313             {
1314                 uint Im_WinnerUserId = WeR_WinnerId[Im_WinnerCounter];
1315                 uint Im_WinnerBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_WinnerUserId];
1316 
1317                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] - Im_WinnerBettingAmount;
1318                 Mapping__OwnerUserId_ERC20Amount[Im_WinnerUserId] + Im_WinnerBettingAmount;
1319             }
1320 
1321             //Transfer moneymoney from losers          
1322             for(uint Im_LoserCounter = 0; Im_LoserCounter <= WeR_LoserId.length ; Im_LoserCounter++) 
1323             {
1324                 uint Im_LoserUserId = WeR_WinnerId[Im_LoserCounter];
1325                 uint Im_LoserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_LoserUserId];
1326 
1327                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] + Im_LoserBettingAmount;
1328                 Mapping__OwnerUserId_ERC20Amount[Im_LoserUserId] - Im_LoserBettingAmount;
1329             }
1330 
1331             //Create New Round ID
1332             ImCounter_GameRoundId = ImCounter_GameRoundId + 1;
1333             Mapping__GameUnitId_GameUnitStruct[GameId].Game_RoundsIds.push(ImCounter_GameRoundId);
1334 
1335             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1336         }
1337     }
1338 
1339 }
1340 /* =================================================================
1341 Contact HEAD : Integration User Workflow
1342 ==================================================================== */
1343 //Create by meowent@gmail.com +886 975330002
1344 //Worship Lu Goddess Forever