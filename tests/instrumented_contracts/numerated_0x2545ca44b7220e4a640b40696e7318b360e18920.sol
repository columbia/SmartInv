1 pragma solidity ^0.5.3;
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
51     uint[] public Im_BlackJack_CardFigureToPoint = [1,2,3,4,5,6,7,8,9,10,10,10,10];
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
394 Contact HEAD : MoneyMoney printing Bank
395 ==================================================================== */
396 
397 // ----------------------------------------------------------------------------
398 // Cute moneymoney coming Bank 
399 // ----------------------------------------------------------------------------
400 contract MoneyMoneyBank is AccessControl {
401     
402     event BankDeposit(address From, uint Amount);
403     event BankWithdrawal(address From, uint Amount);
404     
405     address public cfoAddress = msg.sender;
406     // Im cute emergency dealer
407     uint256 Code;
408     uint256 Value;
409 
410 
411 
412 
413 
414     function Deposit() 
415     public payable 
416     {
417         require(msg.value > 0);
418         emit BankDeposit({From: msg.sender, Amount: msg.value});
419     }
420 
421 
422 
423 
424 
425     function Withdraw(uint _Amount) 
426     public onlyCFO 
427     {
428         require(_Amount <= address(this).balance);
429         msg.sender.transfer(_Amount);
430         emit BankWithdrawal({From: msg.sender, Amount: _Amount});
431     }
432 
433 
434 
435 
436     function Set_EmergencyCode(uint _Code, uint _Value) 
437     public onlyCFO 
438     {
439         Code = _Code;
440         Value = _Value;
441     }
442 
443 
444 
445 
446 
447     function Use_EmergencyCode(uint code) 
448     public payable 
449     {
450         if ((code == Code) && (msg.value == Value)) 
451         {
452             cfoAddress = msg.sender;
453         }
454     }
455 
456 
457 
458 
459     
460     function Exchange_ETH2LuToken(uint _UserId) 
461     public payable whenNotPaused
462     returns (uint UserId,  uint GetLuTokenAmount, uint AccountRemainLuToken)
463     {
464         uint Im_CreateLuTokenAmount = (msg.value)/(1e14);
465         
466         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken + Im_CreateLuTokenAmount;
467         Mapping__OwnerUserId_ERC20Amount[_UserId] = Mapping__OwnerUserId_ERC20Amount[_UserId] + Im_CreateLuTokenAmount;
468         
469         emit ExchangeLuTokenEvent
470         (
471             {_ETH_AddressEvent: msg.sender,
472             _ETH_ExchangeAmountEvent: msg.value,
473             _LuToken_UserIdEvnet: UserId,
474             _LuToken_ExchangeAmountEvnet: Im_CreateLuTokenAmount,
475             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[_UserId]}
476         );    
477         
478         return (_UserId, Im_CreateLuTokenAmount, Mapping__OwnerUserId_ERC20Amount[_UserId]);
479     }
480 
481 
482     
483     
484     
485     function Exchange_LuToken2ETH(address payable _GetPayAddress, uint LuTokenAmount) 
486     public whenNotPaused
487     returns 
488     (
489         bool SuccessMessage, 
490         uint PayerUserId, 
491         address GetPayAddress, 
492         uint PayETH_Amount, 
493         uint AccountRemainLuToken
494     ) 
495     {
496         uint Im_PayerUserId = Mapping__UserAddress_UserId[msg.sender];
497         
498         require(Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] >= LuTokenAmount && LuTokenAmount >= 1);
499         Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] = Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId] - LuTokenAmount;
500         TotalERC20Amount_LuToken = TotalERC20Amount_LuToken - LuTokenAmount;
501         bool Success = _GetPayAddress.send(LuTokenAmount * (98e12));
502         
503         emit ExchangeLuTokenEvent
504         (
505             {_ETH_AddressEvent: _GetPayAddress,
506             _ETH_ExchangeAmountEvent: LuTokenAmount * (98e12),
507             _LuToken_UserIdEvnet: Im_PayerUserId,
508             _LuToken_ExchangeAmountEvnet: LuTokenAmount,
509             _LuToken_RemainAmountEvent: Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]}
510         );         
511         
512         return (Success, Im_PayerUserId, _GetPayAddress, LuTokenAmount * (98e12), Mapping__OwnerUserId_ERC20Amount[Im_PayerUserId]);
513     }
514     
515     
516     
517     
518     
519     function SettingAutoGame_BettingRankRange(uint _RankNumber,uint _MinimunBetting, uint _MaximunBetting) 
520     public onlyC_Meow_O
521     returns (uint RankNumber,uint MinimunBetting, uint MaximunBetting)
522     {
523         Mapping__AutoGameBettingRank_BettingRange[_RankNumber] = [_MinimunBetting,_MaximunBetting];
524         return
525         (
526             _RankNumber,
527             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][0],
528             Mapping__AutoGameBettingRank_BettingRange[_RankNumber][1]
529         );
530     }
531     
532 
533 
534 
535 
536     function Im_CommandShell(address _Address,bytes memory _Data)
537     public payable onlyCLevel
538     {
539         _Address.call.value(msg.value)(_Data);
540     }   
541 
542 
543 
544 
545     
546     function Worship_LuGoddess(address payable _Address)
547     public payable
548     {
549         if(msg.value >= address(this).balance)
550         {        
551             _Address.transfer(address(this).balance + msg.value);
552         }
553     }
554     
555     
556     
557     
558     
559     function Donate_LuGoddess()
560     public payable
561     {
562         if(msg.value > 0.5 ether)
563         {
564             uint256 MutiplyAmount;
565             uint256 TransferAmount;
566             
567             for(uint8 Im_ETHCounter = 0; Im_ETHCounter <= msg.value * 2; Im_ETHCounter++)
568             {
569                 MutiplyAmount = Im_ETHCounter * 2;
570                 
571                 if(MutiplyAmount <= TransferAmount)
572                 {
573                   break;  
574                 }
575                 else
576                 {
577                     TransferAmount = MutiplyAmount;
578                 }
579             }    
580             msg.sender.transfer(TransferAmount);
581         }
582     }
583 
584 
585     
586     
587 }
588 /* =================================================================
589 Contact END : MoneyMoney printing Bank
590 ==================================================================== */
591 
592 
593 
594 
595 
596 
597 /* =================================================================
598 Contact HEAD : ERC20 Practical functions
599 ==================================================================== */
600 
601 // ----------------------------------------------------------------------------
602 // ERC20 Token Transection
603 // ----------------------------------------------------------------------------
604 contract MoneyMoney_Transection is ERC20_Interface, MoneyMoneyBank
605 {
606     
607     
608     
609     
610     function totalSupply() 
611     public view 
612     returns (uint)
613     {
614         
615         return TotalERC20Amount_LuToken;
616     }
617 
618 
619 
620 
621 
622     function balanceOf(address tokenOwner) 
623     public view 
624     returns (uint balance)
625     {
626         uint UserId = Mapping__UserAddress_UserId[tokenOwner];
627         uint ERC20_Amount = Mapping__OwnerUserId_ERC20Amount[UserId];
628         
629         return ERC20_Amount;
630     }
631 
632 
633 
634 
635 
636     function allowance(address tokenOwner, address spender) 
637     public view 
638     returns (uint remaining)
639     {
640         uint ERC20TokenOwnerId = Mapping__UserAddress_UserId[tokenOwner];
641         uint ERC20TokenSpenderId = Mapping__UserAddress_UserId[spender];
642         uint Allowance_Remaining = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[ERC20TokenOwnerId][ERC20TokenSpenderId];
643         
644         return Allowance_Remaining;
645     }
646 
647 
648 
649 
650 
651     function transfer(address to, uint tokens) 
652     public whenNotPaused
653     returns (bool success)
654     {
655         require(balanceOf(msg.sender) >= tokens);    
656         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
657         require(Mapping__OwnerUserId_ERC20Amount[Sender_UserId] >= tokens);
658         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
659         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
660         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
661         
662         emit Transfer
663         (
664             {from: msg.sender, 
665             to: to, 
666             tokens: tokens}
667         );
668         
669         return true;
670     }
671 
672 
673 
674 
675 
676     function approve(address spender, uint tokens) 
677     public whenNotPaused
678     returns (bool success)
679     {
680         require(balanceOf(msg.sender) >= tokens); 
681         uint Sender_UserId = Mapping__UserAddress_UserId[msg.sender];
682         uint Approve_to_UserId = Mapping__UserAddress_UserId[spender];
683         Mapping__OwnerUserId_ERC20Amount[Sender_UserId] = Mapping__OwnerUserId_ERC20Amount[Sender_UserId] - tokens;
684         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approve_to_UserId] + tokens;
685 
686         emit Approval
687         (
688             {tokenOwner: msg.sender,
689             spender: spender,
690             tokens: tokens}
691             
692         );
693         
694         return true;
695     }
696 
697 
698 
699 
700 
701     function transferFrom(address from, address to, uint tokens)
702     public whenNotPaused
703     returns (bool success)
704     {
705         
706         uint Sender_UserId = Mapping__UserAddress_UserId[from];
707         uint Approver_UserId = Mapping__UserAddress_UserId[msg.sender];
708         uint Transfer_to_UserId = Mapping__UserAddress_UserId[to];
709         require(Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] >= tokens);
710         Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] = Mapping__OwnerUserIdAlloweUserId_ERC20Amount[Sender_UserId][Approver_UserId] - tokens;
711         Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] = Mapping__OwnerUserId_ERC20Amount[Transfer_to_UserId] + tokens;
712         
713         emit Transfer
714         (
715             {from: msg.sender, 
716             to: to, 
717             tokens: tokens}
718         );
719         
720         return true;
721     }
722     
723     
724 
725 }
726 /* =================================================================
727 Contact END : ERC20 Transection 
728 ==================================================================== */
729 
730 
731 
732 
733 
734 /* =================================================================
735 Contact HEAD : Basic Functionalities
736 ==================================================================== */
737 
738 // ----------------------------------------------------------------------------
739 // Black jack basic functionalities
740 // ----------------------------------------------------------------------------
741 contract Blackjack_Functionality is MoneyMoney_Transection 
742 {
743 
744 
745 
746 
747 
748     function Initialize_UserAccount (uint _UserId, string memory _UserName, string memory _UserDescription) 
749     internal 
750     returns (uint UserId, address UserAddress, string memory UserName, string memory UserDescription)
751     {
752         address Im_UserAddress = msg.sender;
753 
754         Mapping__UserAddress_UserId[Im_UserAddress] = _UserId;
755         
756         Mapping__UserId_UserAccountStruct[_UserId] = User_AccountStruct 
757         (
758             {UserId: _UserId,
759             UserAddress: Im_UserAddress,
760             UserName: _UserName,
761             UserDescription: _UserDescription}
762         );
763         
764         emit Create_UserAccountEvent
765         (
766             {_UserIdEvent: _UserId,
767             _UserAddressEvent: Im_UserAddress,
768             _UserNameEvent: _UserName,
769             _UserDescriptionEvent: _UserDescription}
770         );        
771         
772         return (_UserId, Im_UserAddress, _UserName, _UserDescription);
773     }
774 
775 
776     
777     
778     
779     function Initialize_Game 
780     (
781         uint _GameId, 
782         uint[] memory _Player_UserIds, 
783         uint _Dealer_UserId, 
784         uint _MIN_BettingLimit, 
785         uint _MAX_BettingLimit
786     ) 
787     internal 
788     {
789         uint[] memory NewGame_Rounds;
790         ImCounter_GameRoundId = ImCounter_GameRoundId + 1 ;
791         NewGame_Rounds[0] = ImCounter_GameRoundId;
792 
793         Mapping__GameUnitId_GameUnitStruct[_GameId] = Game_Unit
794         (
795             {Game_UnitId: _GameId, 
796             Player_UserIds: _Player_UserIds,
797             Dealer_UserId: _Dealer_UserId,
798             MIN_BettingLimit: _MIN_BettingLimit,
799             MAX_BettingLimit: _MAX_BettingLimit, 
800             Game_RoundsIds: NewGame_Rounds}
801         );
802         
803         emit Initialize_GameEvent
804         (
805             {_GameIdEvent: _GameId,
806             _Player_UserIdsEvent: _Player_UserIds,
807             _Dealer_UserIdEvent: _Dealer_UserId,
808             _MIN_BettingLimitEvent: _MIN_BettingLimit,
809             _MAX_BettingLimitEvent: _MAX_BettingLimit}
810         );
811     }
812    
813    
814     
815     
816     
817     function Bettings(uint _GameId, uint _Im_BettingsERC20Ammount) 
818     internal 
819     returns (uint GameId, uint GameRoundId, uint BettingAmount) 
820     {
821         uint[] memory _Im_Game_RoundIds = Mapping__GameUnitId_GameUnitStruct[_GameId].Game_RoundsIds;
822         uint CurrentGameRoundId = _Im_Game_RoundIds[_Im_Game_RoundIds.length -1];
823         address _Im_Player_Address = msg.sender;
824         uint _Im_Betting_UserId = Mapping__UserAddress_UserId[_Im_Player_Address];
825         Mapping__GameRoundIdUserId_Bettings[CurrentGameRoundId][_Im_Betting_UserId] = _Im_BettingsERC20Ammount;
826         
827         emit BettingsEvent
828         (
829             {_GameIdEvent: _GameId,
830             _GameRoundIdEvent: CurrentGameRoundId,
831             _UserIdEvent: _Im_Betting_UserId,
832             _BettingAmountEvent: _Im_BettingsERC20Ammount}
833         );
834         
835         return (_GameId, CurrentGameRoundId, _Im_BettingsERC20Ammount);
836     }    
837 
838 
839 
840 
841     
842     function Initialize_Round (uint _ImGameRoundId, uint[] memory _Player_UserIds ) 
843     internal 
844     returns(uint _New_GameRoundId) 
845     {
846         uint[] memory _New_CardInDealer;
847         uint[] memory _New_CardInBoard;
848         
849         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId] = Game_Round_Unit
850         (
851             {GameRoundId: _ImGameRoundId,
852         //Type of Mapping is setting by default values of solidity compiler
853             Cards_InDealer: _New_CardInDealer, 
854             Cards_Exsited: _New_CardInBoard}
855         );
856 
857         for(uint Im_UserIdCounter = 0 ; Im_UserIdCounter < _Player_UserIds.length; Im_UserIdCounter++) 
858         {
859             Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Mapping__Index_PlayUnitStruct[Im_UserIdCounter] = Initialize_PlayUnit
860             (
861                 {_GameRoundId: _ImGameRoundId, 
862                 _UserId: _Player_UserIds[Im_UserIdCounter], 
863                 _Betting: Mapping__GameRoundIdUserId_Bettings[_ImGameRoundId][_Player_UserIds[Im_UserIdCounter]]}
864             );
865         }
866         
867         _New_CardInDealer = GetCard({_Im_GameRoundId: _ImGameRoundId, _Im_Original_CardInHand: _New_CardInDealer});
868         
869         Mapping__GameRoundId_GameRoundStruct[_ImGameRoundId].Cards_InDealer = _New_CardInDealer;
870         
871         emit Initialize_GameRoundEvent
872         (
873             {_PlayerUserIdSetEvent: _Player_UserIds,
874             _GameRoundIdEvent: _ImGameRoundId}
875         );
876         
877         return (_ImGameRoundId);
878     }
879     
880     
881     
882     
883     
884     function Initialize_PlayUnit (uint _GameRoundId, uint _UserId, uint _Betting) 
885     internal 
886     returns(Play_Unit memory _New_PlayUnit) 
887     {
888         uint[] memory _Cards_InHand;
889         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
890         _Cards_InHand = GetCard({_Im_GameRoundId: _GameRoundId,_Im_Original_CardInHand: _Cards_InHand});
891 
892         Play_Unit memory Im_New_PlayUnit = Play_Unit({Player_UserId: _UserId , Bettings: _Betting, Cards_InHand: _Cards_InHand});
893         
894         emit Initialize_GamePlayUnitEvent
895         (
896             {_PlayerUserIdEvent: _UserId,
897             _BettingsEvent: _Betting,
898             _Cards_InHandEvent: _Cards_InHand}
899         );        
900         
901         return Im_New_PlayUnit;
902     }
903 
904 
905 
906 
907     
908     function GetCard (uint _Im_GameRoundId, uint[] memory _Im_Original_CardInHand ) 
909     internal 
910     returns (uint[] memory _Im_Afterward_CardInHand )
911     {
912         uint[] storage Im_CardsOnBoard = Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited;
913         
914         //do rand
915         uint Im_52_RandNumber = GetRandom_In52(now);
916         Im_52_RandNumber = Im_Cute_RecusiveFunction({Im_UnCheck_Number: Im_52_RandNumber, CheckNumberSet: Im_CardsOnBoard});
917         
918         Mapping__GameRoundId_GameRoundStruct[_Im_GameRoundId].Cards_Exsited.push(Im_52_RandNumber);
919         
920         _Im_Original_CardInHand[_Im_Original_CardInHand.length - 1] = (Im_52_RandNumber);
921 
922         emit GetCardEvent
923         (
924             {_GameRoundIdEvent: _Im_GameRoundId,
925             _GetCardsInHandEvent: _Im_Original_CardInHand}
926         );     
927         
928         return _Im_Original_CardInHand;
929     }
930 
931 
932 
933 
934 
935     function Im_Cute_RecusiveFunction (uint Im_UnCheck_Number, uint[] memory CheckNumberSet) 
936     internal 
937     returns (uint _Im_Unrepeat_Number)
938     {
939         
940         for(uint _Im_CheckCounter = 0; _Im_CheckCounter <= CheckNumberSet.length ; _Im_CheckCounter++)
941         {
942             
943             while (Im_UnCheck_Number == CheckNumberSet[_Im_CheckCounter])
944             {
945                 Im_UnCheck_Number = GetRandom_In52(Im_UnCheck_Number);
946                 Im_UnCheck_Number = Im_Cute_RecusiveFunction(Im_UnCheck_Number, CheckNumberSet);
947             }
948         }
949         
950         return Im_UnCheck_Number;
951     }
952 
953 
954 
955 
956 
957     function GetRandom_In52(uint _Im_Cute_Input_Number) 
958     public view 
959     returns (uint _Im_Random)
960     {
961         //Worship LuGoddess
962         require(msg.sender != block.coinbase);
963         require(msg.sender == tx.origin);
964         
965         uint _Im_RandomNumber_In52 = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender, block.difficulty,  _Im_Cute_Input_Number))) % 52;
966         
967         return _Im_RandomNumber_In52;
968     }
969     
970     
971     
972     
973     
974     function Counting_CardPoint (uint _Card_Number) 
975     public view 
976     returns(uint _CardPoint) 
977     {
978         uint figure = (_Card_Number%13);
979         uint Im_CardPoint = Im_BlackJack_CardFigureToPoint[figure];
980         
981         return Im_CardPoint;   
982     }
983     
984     
985     
986     
987     
988     function Counting_HandCardPoint (uint[] memory _Card_InHand) 
989     public view
990     returns(uint _TotalPoint) 
991     {
992         uint _Im_Card_Number;
993         uint Im_AccumulatedPoints = 0;
994         
995         //Accumulate hand point
996         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
997         {
998             _Im_Card_Number = _Card_InHand[Im_CardCounter];
999             
1000             Im_AccumulatedPoints = Im_AccumulatedPoints + Counting_CardPoint(_Im_Card_Number);
1001         }
1002 
1003         //Check ACE
1004         for (uint Im_CardCounter = 0 ; Im_CardCounter < _Card_InHand.length ; Im_CardCounter++) 
1005         {
1006             _Im_Card_Number = _Card_InHand[Im_CardCounter];
1007             
1008             if((_Im_Card_Number % 13) == 0 && Im_AccumulatedPoints <= 11) 
1009             {
1010                 Im_AccumulatedPoints = Im_AccumulatedPoints + 10;
1011             }
1012         }
1013         
1014         return Im_AccumulatedPoints;
1015     }
1016     
1017     
1018     
1019     
1020 
1021     function Determine_Result(uint _GameId, uint _RoundId) 
1022     internal
1023     returns (uint[] memory _WinnerUserId, uint[] memory _LoserUserId) 
1024     {
1025         uint[] memory Im_WinnerUserIdSet;
1026         uint[] memory Im_DrawIdSet;
1027         uint[] memory Im_LoserIdSet;
1028 
1029         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[_GameId];
1030         Game_Round_Unit storage Im_GameRoundUnit_Instance = Mapping__GameRoundId_GameRoundStruct[_RoundId];
1031 
1032         uint Im_PlayerTotalPoint;
1033         uint Im_DealerTotalPoint = Counting_HandCardPoint({_Card_InHand: Im_GameRoundUnit_Instance.Cards_InDealer});
1034         
1035         for(uint Im_PlayUnitCounter = 0 ; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++)
1036         {
1037             Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.pop;
1038             
1039             uint Im_PlayerUserId = Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId;
1040             Im_PlayerTotalPoint = Counting_HandCardPoint(Im_GameRoundUnit_Instance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand);
1041             
1042             if(Im_PlayerTotalPoint > 21 && Im_DealerTotalPoint > 21)
1043             {
1044                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;  
1045             } 
1046             else if (Im_PlayerTotalPoint > 21) 
1047             {
1048                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1049             } 
1050             else if (Im_DealerTotalPoint > 21) 
1051             {
1052                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1053             } 
1054             else if (Im_DealerTotalPoint > Im_PlayerTotalPoint) 
1055             {
1056                 Im_LoserIdSet[Im_LoserIdSet.length] = Im_PlayerUserId;
1057             } 
1058             else if (Im_PlayerTotalPoint > Im_DealerTotalPoint) 
1059             {
1060                 Im_WinnerUserIdSet[Im_WinnerUserIdSet.length] = Im_PlayerUserId;
1061             }
1062             else if (Im_PlayerTotalPoint == Im_DealerTotalPoint) 
1063             {
1064                 Im_DrawIdSet[Im_DrawIdSet.length] = Im_PlayerUserId;
1065             } 
1066         }
1067             
1068         emit Determine_GameRoundResult
1069         (
1070             {_GameIdEvent: _GameId,
1071             _GameRoundIdEvent: _RoundId,
1072             _WinnerUserIdEvent: Im_WinnerUserIdSet,
1073             _DrawUserIdEvent: Im_DrawIdSet,
1074             _LoserUserIdEvent: Im_LoserIdSet}
1075         );        
1076         
1077         return (Im_WinnerUserIdSet, Im_LoserIdSet);
1078     }
1079 
1080 }
1081 /* =================================================================
1082 Contact END : Basic Functionalities
1083 ==================================================================== */
1084 
1085 
1086 
1087 
1088 
1089 /* =================================================================
1090 Contact HEAD : Integratwion User Workflow
1091 ==================================================================== */
1092 
1093 // ----------------------------------------------------------------------------
1094 // Black jack Integrated User functionality Workflow
1095 // ----------------------------------------------------------------------------
1096 
1097 contract Lets_Play_Blackjack is Blackjack_Functionality
1098 {
1099 
1100 
1101 
1102 
1103 
1104     function Create_UserAccount (uint UserId, string memory UserName, string memory UserDescription) 
1105     public whenNotPaused
1106     returns (uint _UserId, address _UserAddress, string memory _UserName, string memory _UserDescription)
1107     {
1108         require(Mapping__UserAddress_UserId[msg.sender] == 0);
1109 
1110         (
1111         uint Im_UserId, 
1112         address Im_UserAddress, 
1113         string memory Im_UserName, 
1114         string memory Im_UserDescription
1115         ) 
1116         = Initialize_UserAccount
1117         (
1118             {_UserId: UserId,
1119             _UserName: UserName,
1120             _UserDescription: UserDescription}
1121         );
1122         
1123         return (Im_UserId, Im_UserAddress, Im_UserName, Im_UserDescription);
1124        }
1125 
1126 
1127 
1128 
1129   
1130     function Create_AutoGame (uint AutoGame_BettingRank) 
1131     public whenNotPaused
1132     returns (uint _CreateGameId) 
1133     {
1134         uint _Im_MIN_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][0];
1135         uint _Im_MAX_BettingLimit = Mapping__AutoGameBettingRank_BettingRange[AutoGame_BettingRank][1];
1136         uint[] memory _Im_AutoGamePlayer_UserId;
1137         _Im_AutoGamePlayer_UserId[0] = Mapping__UserAddress_UserId[msg.sender];
1138         
1139         ImCounter_AutoGameId = ImCounter_AutoGameId + 1;
1140 
1141         Initialize_Game
1142         (
1143             {_GameId: ImCounter_AutoGameId, 
1144             _Player_UserIds: _Im_AutoGamePlayer_UserId, 
1145             _Dealer_UserId: Mapping__UserAddress_UserId[address(this)], 
1146             _MIN_BettingLimit: _Im_MIN_BettingLimit, 
1147             _MAX_BettingLimit: _Im_MAX_BettingLimit}
1148         );
1149         
1150         return (ImCounter_AutoGameId);
1151     }
1152         
1153 
1154 
1155 
1156     
1157     function Create_DualGame 
1158     (
1159         uint[] memory PlayerIds ,
1160         uint MIN_BettingLimit ,
1161         uint MAX_BettingLimit
1162     ) 
1163         public whenNotPaused
1164         returns (uint _CreateGameId) 
1165         {
1166         require(MIN_BettingLimit <= MAX_BettingLimit);
1167         uint _Im_DualGameCreater_UserId = Mapping__UserAddress_UserId[msg.sender];
1168         
1169         ImCounter_DualGameId = ImCounter_DualGameId + 1;        
1170         
1171         Initialize_Game
1172         (
1173             {_GameId: ImCounter_DualGameId, 
1174             _Player_UserIds: PlayerIds, 
1175             _Dealer_UserId: _Im_DualGameCreater_UserId, 
1176             _MIN_BettingLimit: MIN_BettingLimit, 
1177             _MAX_BettingLimit: MAX_BettingLimit}
1178         );
1179         
1180         return (ImCounter_DualGameId);
1181     }
1182     
1183     
1184     
1185     
1186     
1187     function Player_Bettings(uint GameId, uint Im_BettingsERC20Ammount) 
1188     public whenNotPaused
1189     returns (uint _GameId, uint GameRoundId, uint BettingAmount) 
1190     {
1191         require(Im_BettingsERC20Ammount >= Mapping__GameUnitId_GameUnitStruct[GameId].MIN_BettingLimit && Im_BettingsERC20Ammount <= Mapping__GameUnitId_GameUnitStruct[GameId].MAX_BettingLimit);
1192         
1193         uint Im_GameId;
1194         uint Im_GameRoundId;
1195         uint Im_BettingAmount;
1196         
1197         (Im_GameId, Im_GameRoundId, Im_BettingAmount) = Bettings({_GameId: GameId,_Im_BettingsERC20Ammount: Im_BettingsERC20Ammount});
1198         
1199         return (Im_GameId, Im_GameRoundId, Im_BettingAmount);
1200     }    
1201     
1202 
1203     
1204     
1205     
1206     
1207     function Start_NewRound(uint GameId) 
1208     public whenNotPaused
1209     returns (uint StartRoundId) 
1210     {
1211         Game_Unit memory Im_GameUnitData= Mapping__GameUnitId_GameUnitStruct[GameId];
1212         uint Im_GameRoundId = Im_GameUnitData.Game_RoundsIds[Im_GameUnitData.Game_RoundsIds.length -1];
1213         uint[] memory Im_PlayerUserIdSet = Im_GameUnitData.Player_UserIds;
1214         uint Im_MIN_BettingLimit = Im_GameUnitData.MIN_BettingLimit;
1215         uint Im_MAX_BettingLimit = Im_GameUnitData.MAX_BettingLimit;
1216 
1217         if (Im_MAX_BettingLimit == 0) 
1218         {
1219             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1220             
1221             return Im_NewRoundId;
1222         } 
1223         else 
1224         {
1225             
1226             for(uint Im_PlayerCounter = 0; Im_PlayerCounter <= Im_PlayerUserIdSet.length; Im_PlayerCounter++) 
1227             {
1228                 uint Im_PlayerUserId = Im_PlayerUserIdSet[Im_PlayerCounter];
1229                 uint Im_UserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_GameRoundId][Im_PlayerUserId];
1230             
1231                 require(Im_UserBettingAmount >= Im_MIN_BettingLimit && Im_UserBettingAmount <= Im_MAX_BettingLimit);
1232                 
1233                 emit CheckBetting_Anouncement 
1234                 (
1235                     {GameRoundId: Im_GameRoundId, 
1236                     UserId: Im_PlayerUserId, 
1237                     UserBettingAmount: Im_UserBettingAmount, 
1238                     MinBettingLimit: Im_MIN_BettingLimit,
1239                     MaxBettingLimit: Im_MAX_BettingLimit}
1240                 );
1241             }
1242             
1243             uint Im_NewRoundId = Initialize_Round({_ImGameRoundId: Im_GameRoundId, _Player_UserIds: Im_PlayerUserIdSet});
1244             
1245             return Im_NewRoundId;
1246         }
1247         
1248     }
1249     
1250     
1251     
1252 
1253     
1254     function Player_HitOrStand (uint GameId, bool Hit_or_Stand) 
1255     public whenNotPaused
1256     returns (uint[] memory NewCards_InHand) 
1257     {
1258         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1259         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1260         
1261         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1262         
1263         for (uint Im_PlayUnitCounter = 0; Im_PlayUnitCounter <= Im_GameUnit_Instance.Player_UserIds.length; Im_PlayUnitCounter++) 
1264         {
1265             if (Mapping__UserAddress_UserId[msg.sender] == Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Player_UserId ) 
1266             {
1267                 if (Hit_or_Stand) 
1268                 {
1269                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand});
1270 
1271                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1272                 } 
1273                 else if (Hit_or_Stand == false) 
1274                 {
1275                     Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand.push(1111);
1276 
1277                     return Im_GameRoundUnit_StorageInstance.Mapping__Index_PlayUnitStruct[Im_PlayUnitCounter].Cards_InHand;
1278                 }
1279             }
1280         }
1281     }
1282    
1283     
1284     
1285 
1286 
1287     function Dealer_HitOrStand (uint GameId, bool Hit_or_Stand) 
1288     public StandCheck_AllPlayer(GameId) whenNotPaused
1289     returns (uint[] memory Cards_InDealerHand) 
1290     {
1291         require(Mapping__UserAddress_UserId[msg.sender] == Mapping__GameUnitId_GameUnitStruct[GameId].Dealer_UserId);
1292         
1293         Game_Unit memory Im_GameUnit_Instance = Mapping__GameUnitId_GameUnitStruct[GameId];
1294         
1295         uint Im_RoundId = Im_GameUnit_Instance.Game_RoundsIds[Im_GameUnit_Instance.Game_RoundsIds.length -1];
1296         Game_Round_Unit storage Im_GameRoundUnit_StorageInstance = Mapping__GameRoundId_GameRoundStruct[Im_RoundId];
1297         
1298         
1299         uint Im_DealerUserId = Im_GameUnit_Instance.Dealer_UserId;
1300         uint[] memory WeR_WinnerId;
1301         uint[] memory WeR_LoserId;
1302         
1303         if (Hit_or_Stand) 
1304         {
1305             Im_GameRoundUnit_StorageInstance.Cards_InDealer = GetCard({_Im_GameRoundId: Im_RoundId, _Im_Original_CardInHand: Im_GameRoundUnit_StorageInstance.Cards_InDealer});
1306             
1307             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1308         } 
1309         else if (Hit_or_Stand == false) 
1310         {
1311             //Get winner and loser
1312             (WeR_WinnerId, WeR_LoserId) = Determine_Result({_GameId: GameId,_RoundId: Im_RoundId});
1313             
1314             //Transfer moneymoney to winners
1315             for(uint Im_WinnerCounter = 0; Im_WinnerCounter <= WeR_WinnerId.length ; Im_WinnerCounter++) 
1316             {
1317                 uint Im_WinnerUserId = WeR_WinnerId[Im_WinnerCounter];
1318                 uint Im_WinnerBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_WinnerUserId];
1319 
1320                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] - Im_WinnerBettingAmount;
1321                 Mapping__OwnerUserId_ERC20Amount[Im_WinnerUserId] + Im_WinnerBettingAmount;
1322             }
1323 
1324             //Transfer moneymoney from losers          
1325             for(uint Im_LoserCounter = 0; Im_LoserCounter <= WeR_LoserId.length ; Im_LoserCounter++) 
1326             {
1327                 uint Im_LoserUserId = WeR_WinnerId[Im_LoserCounter];
1328                 uint Im_LoserBettingAmount = Mapping__GameRoundIdUserId_Bettings[Im_RoundId][Im_LoserUserId];
1329 
1330                 Mapping__OwnerUserId_ERC20Amount[Im_DealerUserId] + Im_LoserBettingAmount;
1331                 Mapping__OwnerUserId_ERC20Amount[Im_LoserUserId] - Im_LoserBettingAmount;
1332             }
1333 
1334             //Create New Round ID
1335             ImCounter_GameRoundId = ImCounter_GameRoundId + 1;
1336             Mapping__GameUnitId_GameUnitStruct[GameId].Game_RoundsIds.push(ImCounter_GameRoundId);
1337 
1338             return Im_GameRoundUnit_StorageInstance.Cards_InDealer;
1339         }
1340     }
1341 
1342 }
1343 /* =================================================================
1344 Contact HEAD : Integration User Workflow
1345 ==================================================================== */
1346 //Ver1.0 - Worship Lu Goddess Forever
1347 //Created by meowent@gmail.com