1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title Ownable
5 * @dev The Ownable contract has an owner address, and provides basic authorization control
6 * functions, this simplifies the implementation of "user permissions".
7 */
8 
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipRenounced(address indexed previousOwner);
13     event OwnershipTransferred(
14         address indexed previousOwner,
15         address indexed newOwner
16     );
17 
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to relinquish control of the contract.
37     * @notice Renouncing to ownership will leave the contract without an owner.
38     * It will not be possible to call the functions with the `onlyOwner`
39     * modifier anymore.
40     */
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 
46     /**
47     * @dev Allows the current owner to transfer control of the contract to a newOwner.
48     * @param _newOwner The address to transfer ownership to.
49     */
50     function transferOwnership(address _newOwner) public onlyOwner {
51         _transferOwnership(_newOwner);
52     }
53 
54     /**
55     * @dev Transfers control of the contract to a newOwner.
56     * @param _newOwner The address to transfer ownership to.
57     */
58     function _transferOwnership(address _newOwner) internal {
59         require(_newOwner != address(0));
60         emit OwnershipTransferred(owner, _newOwner);
61         owner = _newOwner;
62     }
63 }
64 
65 
66 /**
67 * @title SafeMath
68 * @dev Math operations with safety checks that throw on error
69 */
70 
71 library SafeMath {
72     /**
73     * @dev Multiplies two numbers, throws on overflow.
74     */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
76         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87 
88     /**
89     * @dev Integer division of two numbers, truncating the quotient.
90     */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // assert(b > 0); // Solidity automatically throws when dividing by 0
93         // uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95         return a / b;
96     }
97 
98     /**
99     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         assert(b <= a);
103         return a - b;
104     }
105 
106     /**
107     * @dev Adds two numbers, throws on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
110         c = a + b;
111         assert(c >= a);
112         return c;
113     }
114 }
115 
116 //==================================================
117 // QIU3D Events
118 //==================================================
119 contract QIU3Devents {
120     //fired whenever buy ticket
121     event onNewTicket(
122         address indexed player,
123         uint256 indexed matchId,
124         uint256 indexed ticketId,
125         uint256 fullMatResOpt,
126         uint256 goalsOpt,
127         uint256 gapGoalsOpt,
128         uint256 bothGoalOpt,
129         uint256 halfAndFullMatResOpt,
130         uint256 ticketValue,     
131         uint256 cost
132     );
133     //fired whenever buy bet
134     event onNewBet(
135         address indexed player,
136         uint256 indexed matchId,
137         uint256 indexed betId,
138         uint256 option,
139         uint256 odds,
140         uint256 cost
141     );
142 
143     //fired at end match
144     event onEndMatch(
145         uint256 indexed matchId,
146         uint256 compressData
147     );
148 
149     //fired at buy ticket with player invite
150     event onInvite(
151         address indexed player,
152         address indexed inviter,
153         uint256 profit
154     );
155 
156     //fired at withdraw
157     event onWithdraw(
158         address indexed player,
159         uint256 withdraw,
160         uint256 withdrawType    //0-withdraw 1-buy ticket 2-buy bet
161     );
162 }
163 
164 //==================================================
165 // QIU3D contract setup
166 //==================================================
167 contract QIU3D is QIU3Devents, Ownable {
168     using SafeMath for *;
169 
170     //match data interface
171     Q3DMatchDataInterface private MatchDataInt_;
172     //foundation address, default is owner
173     address private foundationAddress_;
174 
175     //jackpot and dividend percentage settings
176     uint256 constant private TxTJPPercentage = 63;  //Ticket jackpot percentage in Ticket fund
177     uint256 constant private BxTJPPercentage = 27;  //Bet jackpot percentage in Ticket fund
178     uint256 constant private BxBJPPercentage = 90;  //Bet jackpot percentage in Bet fund
179     uint256 constant private DxTJPPercentage = 10;  //Dividend percentage in Ticket fund
180     uint256 constant private DxBJPPercentage = 10;  //Dividend percentage in Bet fund
181     uint256 constant private TxDJPPercentage = 90;  //Tikcet dividend percentage in all Dividend
182     uint256 constant private FxDJPPercentage = 10;  //Foundation dividend percentage in all Dividend
183 
184     //ticket options default invalid value
185     uint256 constant InvalidFullMatchResult = 0;
186     uint256 constant InvalidTotalGoals = 88;
187     uint256 constant InvalidGapGoals = 88;
188     uint256 constant InvalidBothGoals = 0;
189     uint256 constant InvalidHalfAndFullMatchResult = 0; 
190 
191     //ticket price settings
192     uint256 constant private TicketInitPrice = 100000000000000;     //Ticket initial price when match begin 
193     uint256 constant private TicketIncreasePrice = 100000000000;    //Ticket increase price by each transaction
194     uint256 constant private PriceThreshold = 1000;                 //Speed up price incrase whenever ticket value is a large number
195 
196     //bet settings
197     uint256 constant private OddsCommission = 10;         //Bet Odds commission
198     uint256 constant private OddsOpenPercentage = 30;     //Bet Odds open percentage
199     uint256 constant private OddsMaxDeviation = 5;        //Whenever frontend odds less than actual odds, player should accept the deviation
200 
201     //invite settings
202     uint256 constant private InviteProfitPercentage = 10;  //profit percentage by invite player
203 
204     //Match data
205     uint256 public openMatchId_;                                            //current opening matchId
206     uint256[] public matchIds_;                                             //match Id list
207     mapping(uint256 => QIU3Ddatasets.Match) public matches_;                //(matchId => Match) return match by match ID
208     mapping(uint256 => QIU3Ddatasets.MatchBetOptions) public betOptions_;   //(matchId => MatchBetOptions) return bet options by match ID
209 
210     //Player data
211     mapping(address => QIU3Ddatasets.Player) public players_;       //(address => Player) return player by player address    
212 
213     //ticket option values storage array
214     //|2-0| full match result option array
215     //|12-3| total goals option array
216     //|23-13| gap goals option array
217     //|25-24| both goals option array
218     //|34-26| half and full match result option array
219     mapping(uint256 => uint256[35]) public ticketOptionValues_;    //(matchId => array[35]) return ticket option value by match ID
220 
221     constructor(address _matchDataAddress) public
222     {
223         openMatchId_ = 0; 
224         MatchDataInt_ = Q3DMatchDataInterface(_matchDataAddress);
225         foundationAddress_ = msg.sender;
226     }
227 
228     /**
229      * @dev update foundation address
230      **/
231     function setFoundationAddress(address _foundationAddr) public onlyOwner
232     {
233         foundationAddress_ = _foundationAddr;
234     }
235 
236     //==================================================
237     // Modifier
238     //==================================================
239     modifier isHuman() 
240     {
241         require(msg.sender == tx.origin, "sorry humans only");
242         _;
243     }
244 
245     modifier isWithinLimits(uint256 _eth) 
246     {
247         require(_eth >= 1000000000, "pocket lint: not a valid currency");
248         _;    
249     }
250 
251     /**
252      * @dev whenever player transfer eth to contract, default select match full time result is draw
253      **/
254     function() public isHuman() isWithinLimits(msg.value) payable
255     {
256         buyTicketCore_(
257             openMatchId_, 
258             2, 
259             InvalidTotalGoals, 
260             InvalidGapGoals, 
261             InvalidBothGoals, 
262             InvalidHalfAndFullMatchResult, 
263             msg.value, 
264             address(0));
265     }
266 
267     //==================================================
268     // public functions (interact with contract)
269     //==================================================
270     /**
271      * @dev player buy ticket with match options
272      * @param _matchId the ID of match
273      * @param _fullMatResOpt full time result (1-3), 0 to none
274      * @param _goalsOpt total goals (0-9), other values to none
275      * @param _gapGoalsOpt home team goals minus away team goals mapping value (0-10), mapping value = actual gap goals + 5, other values to none
276      * @param _bothGoalOpt both team goal (1-2)， 0 to none
277      * @param _halfAndFullMatResOpt match half time result and full time result (1-9)， 0 to none
278      * @param _inviteAddr address of invite player
279      */
280     function buyTicket(
281         uint256 _matchId,
282         uint256 _fullMatResOpt,
283         uint256 _goalsOpt,
284         uint256 _gapGoalsOpt,
285         uint256 _bothGoalOpt,
286         uint256 _halfAndFullMatResOpt,
287         address _inviteAddr
288         ) 
289         public
290         isHuman() isWithinLimits(msg.value) payable
291     {
292         buyTicketCore_(
293             _matchId, 
294             _fullMatResOpt, 
295             _goalsOpt, 
296             _gapGoalsOpt, 
297             _bothGoalOpt, 
298             _halfAndFullMatResOpt, 
299             msg.value, 
300             _inviteAddr);
301     }
302 
303      /**
304      * @dev player buy ticket with vault
305      * @param _matchId the ID of match
306      * @param _fullMatResOpt full time result (1-3), 0 to none
307      * @param _goalsOpt total goals (0-9), other values to none
308      * @param _gapGoalsOpt home team goals minus away team goals mapping value (0-10), mapping value = actual gap goals + 5, other values to none
309      * @param _bothGoalOpt both team goal (1-2)， 0 to none
310      * @param _halfAndFullMatResOpt match half time result and full time result (1-9)， 0 to none
311      * @param _vaultEth pay eth value from vault
312      * @param _inviteAddr address of invite player
313      */
314     function buyTicketWithVault(
315         uint256 _matchId,
316         uint256 _fullMatResOpt,
317         uint256 _goalsOpt,
318         uint256 _gapGoalsOpt,
319         uint256 _bothGoalOpt,
320         uint256 _halfAndFullMatResOpt,
321         uint256 _vaultEth,
322         address _inviteAddr
323         )
324         public
325         isHuman() isWithinLimits(_vaultEth)
326     {
327         uint256 withdrawn = 0;
328         uint256 totalProfit = 0; 
329         (totalProfit, withdrawn) = getPlayerVault_();
330         require(totalProfit >= withdrawn.add(_vaultEth), "no balance");
331         QIU3Ddatasets.Player storage _player_ = players_[msg.sender];
332         _player_.withdraw = withdrawn.add(_vaultEth);
333         buyTicketCore_(
334             _matchId, 
335             _fullMatResOpt, 
336             _goalsOpt, 
337             _gapGoalsOpt, 
338             _bothGoalOpt, 
339             _halfAndFullMatResOpt, 
340             _vaultEth, 
341             _inviteAddr);
342         emit onWithdraw(msg.sender, _vaultEth, 1);
343     }
344 
345 
346     /**
347      * @dev player buy bet with bet option for current match
348      * @param _option match full time result, 0 - home win, 1 - draw , 2 - away win
349      * @param _odds odds value player want to buy
350      */
351 
352     function bet(uint256 _option, uint256 _odds) public
353         isHuman() isWithinLimits(msg.value) payable
354     {
355         betCore_(_option, _odds, msg.value);
356     }
357 
358 
359     /**
360      * @dev player buy bet with vault
361      * @param _option match full time result, 0 - home win, 1 - draw , 2 - away win
362      * @param _odds odds value player want to buy
363      * @param _vaultEth pay eth value from vault
364      */
365 
366     function betWithVault(uint256 _option, uint256 _odds, uint256 _vaultEth) public
367         isHuman() isWithinLimits(_vaultEth)
368     {
369         uint256 withdrawn = 0;
370         uint256 totalProfit = 0; 
371         (totalProfit, withdrawn) = getPlayerVault_();
372         require(totalProfit >= withdrawn.add(_vaultEth), "no balance");
373         QIU3Ddatasets.Player storage _player_ = players_[msg.sender];
374         _player_.withdraw = withdrawn.add(_vaultEth);
375         betCore_(_option, _odds, _vaultEth);
376         emit onWithdraw(msg.sender, _vaultEth, 2);
377     }
378 
379     
380     /**
381      * @dev player withdraw profit and dividend, everytime player call withdraw will empty balance
382      */
383     function withdraw() public isHuman()
384     {
385         uint256 withdrawn = 0;
386         uint256 totalProfit = 0; 
387         (totalProfit, withdrawn) = getPlayerVault_();
388         require(totalProfit > withdrawn, "no balance");
389         QIU3Ddatasets.Player storage _player_ = players_[msg.sender];
390         _player_.withdraw = totalProfit;
391         msg.sender.transfer(totalProfit.sub(withdrawn));
392         emit onWithdraw(msg.sender, totalProfit.sub(withdrawn), 0);
393     }
394 
395     //==================================================
396     // view functions (getter in contract)
397     //==================================================
398     /** 
399      * @dev returns game basic information
400      * @return the ID of current match
401      * @return ticket price in real time
402      * @return the timestamp when match end
403      * @return total tickt fund from player buy ticket
404      * @return total bet fund from player buy bet
405      */
406     function getGameInfo() public view returns(uint256, uint256, uint256, uint256, uint256)
407     {
408         QIU3Ddatasets.Match memory _match_ = matches_[openMatchId_];
409         if(openMatchId_ == 0){
410             return (openMatchId_, TicketInitPrice, 0, 0, 0);
411         }else{
412             return (openMatchId_, _match_.currentPrice, _match_.endts, _match_.ticketFund, _match_.betFund);
413         }
414     }
415 
416     /** 
417      * @dev returns player information in QIU3D game
418      * @return last match id which player buy ticket
419      * @return total withdraw amount
420      * @return total invite profit
421      * @return total ticket profit
422      * @return total ticket dividend
423      * @return total bet profit
424      */
425     function getPlayerInGame() public view returns(uint256, uint256, uint256, uint256, uint256, uint256)
426     {
427         QIU3Ddatasets.Player memory _player_ = players_[msg.sender];
428         uint256 totalTicketProfit = 0;
429         uint256 totalTicketDividend = 0;
430         uint256 totalBetProfit = 0;
431         for(uint i = 0 ; i < _player_.matchIds.length; i++){
432             uint256 ticketProfit = 0;
433             uint256 ticketDividend = 0;
434             uint256 betProfit = 0;
435             (ticketProfit, ticketDividend, betProfit) = getPlayerProfitInMatch(_player_.matchIds[i]);
436             totalTicketProfit = totalTicketProfit.add(ticketProfit);
437             totalTicketDividend = totalTicketDividend.add(ticketDividend);
438             totalBetProfit = totalBetProfit.add(betProfit);
439         }
440         return (
441             _player_.lastBuyTicketMatchId,
442             _player_.withdraw,
443             _player_.inviteProfit,
444             totalTicketProfit,
445             totalTicketDividend,
446             totalBetProfit
447         );
448     }
449 
450     /** 
451      * @dev returns player profit in special match
452      * @param matchId ID of match
453      * @return ticket dividend, show before match end.
454      * @return ticket profit, show after match end.
455      * @return bet profit, show after match end.
456      */
457     function getPlayerProfitInMatch(uint256 matchId) public view returns(uint256, uint256, uint256)
458     {
459         uint256 ticketProfit;
460         uint256 ticketDividend;
461         (ticketProfit, ticketDividend) = getTicketProfitAndDividend(matchId, 0);
462         uint256 betProfit = getBetProfit_(matchId);
463         return(ticketProfit, ticketDividend, betProfit);
464     }
465 
466     /** 
467      * @dev returns the current bet information 
468      * @return return if bet opened
469      * @return home win odds
470      * @return draw odds
471      * @return away win odds
472      * @return home team win max sell
473      * @return draw win max sell
474      * @return away team win max sell
475      */
476     function getBet() public view returns(bool, uint256, uint256, uint256, uint256, uint256, uint256)
477     {
478         QIU3Ddatasets.BetReturns memory _betReturn_;
479         _betReturn_ = getBetReturns_(_betReturn_);
480         return(
481             _betReturn_.opened,
482             _betReturn_.homeOdds,
483             _betReturn_.drawOdds,
484             _betReturn_.awayOdds,
485             _betReturn_.homeMaxSell,
486             _betReturn_.drawMaxSell,
487             _betReturn_.awayMaxSell
488         );
489     }
490 
491     /** 
492      * @dev returns player's ticket profit and profit in special match
493      */
494     function getTicketProfitAndDividend(uint256 _matchId, uint256 _ticketId) public view returns(uint256, uint256)
495     {
496         uint256 totalTicketProfit = 0;
497         uint256 totalTicketDividend = 0;
498         uint256 _remainTicketJackpot = 0;
499         QIU3Ddatasets.Match storage _match_ = matches_[_matchId];
500         QIU3Ddatasets.TicketEventIntReturns memory _profitReturns_;
501         if(_match_.ended){
502             uint256 _ticketJackpot = getTicketJackpot_(_matchId, getBetClearedProfit_(_matchId, _match_.compressedData));
503             _profitReturns_ = calculateTicketProfitAssign_(_matchId, _match_.compressedData, _ticketJackpot, _profitReturns_);
504             if(_profitReturns_.count == 0){
505                 _remainTicketJackpot = _ticketJackpot;
506             }
507         }
508         QIU3Ddatasets.MatchPlayer memory _matchPlayer_ = _match_.matchPlayers[msg.sender];
509         for(uint i = 0; i < _matchPlayer_.ticketIds.length; i++){
510             uint256 tId = 0;
511             if(_ticketId != 0){
512                 tId = _ticketId;
513             }else{
514                 tId = _matchPlayer_.ticketIds[i];
515             }
516             totalTicketProfit = totalTicketProfit.add(
517                 calculateTicketProfit_(_matchId, _profitReturns_, _match_.tickets[tId]));
518             totalTicketDividend = totalTicketDividend.add(
519                 calculateTicketDividend_(_matchId, _remainTicketJackpot, _match_.tickets[tId]));
520             if(_ticketId != 0){
521                 //so disgusting code, but gas you know.
522                 break;
523             }
524         }
525         return (totalTicketProfit, totalTicketDividend);
526     }
527 
528     //==================================================
529     // private functions - calculate player ticket and bet profit
530     //==================================================
531     /** 
532      * @dev calculate one ticket profit in special match
533      */
534     function calculateTicketProfit_(
535         uint256 _matchId, 
536         QIU3Ddatasets.TicketEventIntReturns memory _profitReturns_, 
537         QIU3Ddatasets.Ticket memory _ticket_
538         ) private view returns(uint256)
539     {
540         uint256 ticketProfit = 0;
541         QIU3Ddatasets.Match memory _match_ = matches_[_matchId];
542         if(_match_.ended && _profitReturns_.count > 0){
543             QIU3Ddatasets.TicketEventBoolReturns memory _compareReturns_ = compareOptionsResult_(
544                 _ticket_.compressedData, _match_.compressedData, _compareReturns_);
545             uint256 optionTicketValue = _ticket_.ticketValue.div(_ticket_.compressedData.div(10000000));
546             if(_compareReturns_.fullMatch){
547                 ticketProfit = ticketProfit.add((_profitReturns_.fullMatch.mul(optionTicketValue)).div(1000000000000000000));
548             }
549             if(_compareReturns_.totalGoal){
550                 ticketProfit = ticketProfit.add((_profitReturns_.totalGoal.mul(optionTicketValue)).div(1000000000000000000));
551             }
552             if(_compareReturns_.gapGoal){
553                 ticketProfit = ticketProfit.add((_profitReturns_.gapGoal.mul(optionTicketValue)).div(1000000000000000000));
554             }
555             if(_compareReturns_.bothGoal){
556                 ticketProfit = ticketProfit.add((_profitReturns_.bothGoal.mul(optionTicketValue)).div(1000000000000000000));
557             }
558             if(_compareReturns_.halfAndFullMatch){
559                 ticketProfit = ticketProfit.add((_profitReturns_.halfAndFullMatch.mul(optionTicketValue)).div(1000000000000000000));
560             }
561         }
562         return ticketProfit;
563     }
564 
565     /** 
566      * @dev calculate one ticket dividend in special match
567      */
568     function calculateTicketDividend_(
569         uint256 _matchId, 
570         uint256 _remainTicketJackpot, 
571         QIU3Ddatasets.Ticket memory _ticket_
572         ) private view returns(uint256)
573     {
574         uint256 totalDividend = 0;
575         totalDividend = getTicketDividendFromJackpot_(_matchId, _remainTicketJackpot);
576         uint256 totalOptionValues;
577         (totalOptionValues, ) = getTotalOptionValues_(_matchId);
578         uint256 dividendPerTicket = (totalDividend.mul(1000000000000000000)).div(totalOptionValues);
579         uint256 dividend = (_ticket_.ticketValue.mul(dividendPerTicket)).div(1000000000000000000);
580         return dividend;
581     }
582 
583     /** 
584      * @dev calculate ticket profit assign in special match, returns all option profit
585      */
586     function calculateTicketProfitAssign_(
587         uint256 _matchId, 
588         uint256 _compressResult, 
589         uint256 _ticketJackpot, 
590         QIU3Ddatasets.TicketEventIntReturns memory _eventReturns_
591         ) private view returns(QIU3Ddatasets.TicketEventIntReturns)
592     {
593         QIU3Ddatasets.TicketEventIntReturns memory _optionReturns_ = getDecompressedOptions_(_compressResult, _optionReturns_);
594 
595         uint256 fullMatchValue = ticketOptionValues_[_matchId][_optionReturns_.fullMatch.sub(1)];
596         if(fullMatchValue > 0){
597             _eventReturns_.count = _eventReturns_.count.add(1);
598         }
599 
600         uint256 totalGoalValue = 0;
601         if(_optionReturns_.totalGoal != InvalidTotalGoals){
602             totalGoalValue = ticketOptionValues_[_matchId][_optionReturns_.totalGoal.add(3)];
603             if(totalGoalValue > 0){
604                 _eventReturns_.count = _eventReturns_.count.add(1);
605             }
606         }
607 
608         uint256 gapGoalValue = 0;
609         if(_optionReturns_.gapGoal != InvalidGapGoals){
610             gapGoalValue = ticketOptionValues_[_matchId][_optionReturns_.gapGoal.add(13)];
611             if(gapGoalValue > 0){
612                 _eventReturns_.count = _eventReturns_.count.add(1);
613             }
614         }
615         uint256 bothGoalValue = ticketOptionValues_[_matchId][_optionReturns_.bothGoal.add(23)];
616         if(bothGoalValue > 0){
617             _eventReturns_.count = _eventReturns_.count.add(1);
618         }
619         uint256 halfAndFullMatchValue = ticketOptionValues_[_matchId][_optionReturns_.halfAndFullMatch.add(25)];
620         if(halfAndFullMatchValue > 0){
621             _eventReturns_.count = _eventReturns_.count.add(1);
622         }
623         if(_eventReturns_.count != 0){
624             uint256 perJackpot = _ticketJackpot.div(_eventReturns_.count);
625             if(fullMatchValue > 0){
626                 _eventReturns_.fullMatch = perJackpot.mul(1000000000000000000).div(fullMatchValue);
627             }
628             if(totalGoalValue > 0){
629                 _eventReturns_.totalGoal = perJackpot.mul(1000000000000000000).div(totalGoalValue);
630             }
631             if(gapGoalValue > 0){
632                 _eventReturns_.gapGoal = perJackpot.mul(1000000000000000000).div(gapGoalValue);
633             }
634             if(bothGoalValue > 0){
635                 _eventReturns_.bothGoal = perJackpot.mul(1000000000000000000).div(bothGoalValue);
636             }
637             if(halfAndFullMatchValue > 0){
638                 _eventReturns_.halfAndFullMatch = perJackpot.mul(1000000000000000000).div(halfAndFullMatchValue);
639             }
640         }
641         return(_eventReturns_);
642     }
643 
644     /** 
645      * @dev get player bet profit in special match
646      */
647     function getBetProfit_(uint256 _matchId) public view returns(uint256)
648     {
649         uint256 betProfit = 0;
650         QIU3Ddatasets.Match storage _match_ = matches_[_matchId];
651         if(_match_.ended){
652             QIU3Ddatasets.MatchPlayer memory _matchPlayer_ = _match_.matchPlayers[msg.sender];
653             for(uint i = 0; i < _matchPlayer_.betIds.length; i++){
654                 uint256 _betId = _matchPlayer_.betIds[i];
655                 betProfit = betProfit.add(calculateBetProfit_(_match_, _betId));
656             }
657         }
658         return betProfit;
659     }
660 
661 
662     /** 
663      * @dev calculate one bet profit in special match
664      */
665     function calculateBetProfit_(QIU3Ddatasets.Match storage _match_, uint256 betId) private view returns(uint256){
666         QIU3Ddatasets.Bet memory _bet_ = _match_.bets[betId];
667         uint256 option = _match_.compressedData % 10;
668         //odds option is different with match's full match result option, need +1
669         if(option == _bet_.option.add(1)){
670             return (_bet_.odds.mul(_bet_.cost)).div(100);
671         }else{
672             return 0;
673         }
674     }
675 
676     /** 
677     * @dev get bet cleared profit
678     */
679     function getBetClearedProfit_(uint256 _matchId, uint256 _compressedData) private view returns(uint256)
680     {
681         uint256 _totalBetJackpot = getBetJackpot_(_matchId);
682         QIU3Ddatasets.MatchBetOptions memory _betOption_ = betOptions_[_matchId];
683         uint256 matchResult = _compressedData % 10;
684         if(matchResult == 1){
685             return _totalBetJackpot.sub(_betOption_.homeBetReturns);
686         }else if(matchResult == 2){
687             return _totalBetJackpot.sub(_betOption_.drawBetReturns);
688         }else {
689             return _totalBetJackpot.sub(_betOption_.awayBetReturns);
690         }
691     }
692 
693     /** 
694      * @dev get player total profit and withdraw
695      */
696     function getPlayerVault_() private view returns(uint256, uint256){
697         uint256 withdrawn = 0;
698         uint256 inviteProfit = 0;
699         uint256 ticketProfit = 0;
700         uint256 ticketDividend = 0;
701         uint256 betProfit = 0;
702         (,withdrawn, inviteProfit, ticketProfit, ticketDividend, betProfit) = getPlayerInGame();
703         uint256 totalProfit = ((inviteProfit.add(ticketProfit)).add(ticketDividend)).add(betProfit);
704         return (totalProfit, withdrawn);
705     }
706 
707     //==================================================
708     // private functions - buy ticket
709     //==================================================
710     /** 
711     * @dev buy ticket core
712     */
713     function buyTicketCore_(
714         uint256 _matchId,
715         uint256 _fullMatResOpt,
716         uint256 _goalsOpt,
717         uint256 _gapGoalsOpt,
718         uint256 _bothGoalOpt,
719         uint256 _halfAndFullMatResOpt,
720         uint256 _eth,
721         address _inviteAddr
722         ) private
723     {
724         determineMatch_(_matchId);
725         QIU3Ddatasets.Match storage _match_ = matches_[openMatchId_];
726         require(!_match_.ended && _match_.endts > now, "no match open, wait for next match");
727 
728         uint256 _inviteProfit = grantInvitation_(_eth, _inviteAddr);
729 
730         QIU3Ddatasets.Ticket memory _ticket_;
731         //generate new ticket ID
732         uint256 _ticketId = _match_.ticketIds.length.add(1);
733         _ticket_.ticketId = _ticketId;
734         _ticket_.compressedData = getCompressedOptions_(_fullMatResOpt, _goalsOpt, _gapGoalsOpt, _bothGoalOpt, _halfAndFullMatResOpt);
735         _ticket_.playerAddr = msg.sender;
736         _ticket_.cost = _eth;
737         _ticket_.ticketValue = (_eth.mul(1000000000000000000)).div(_match_.currentPrice);
738         
739         _match_.ticketIds.push(_ticketId);
740         _match_.tickets[_ticketId] = _ticket_;
741         _match_.ticketFund = _match_.ticketFund.add(_ticket_.cost.sub(_inviteProfit));
742         _match_.currentPrice = getTicketPrice_(_match_.currentPrice, _ticket_.ticketValue);
743     
744         updatePlayerWithTicket_(_ticket_, _match_);
745         updateMatchTicketOptions_(openMatchId_, _ticket_.compressedData, _ticket_.ticketValue);
746 
747         emit onNewTicket(
748             msg.sender, 
749             openMatchId_, 
750             _ticketId, 
751             _fullMatResOpt,
752             _goalsOpt,
753             _gapGoalsOpt,
754             _bothGoalOpt,
755             _halfAndFullMatResOpt,
756             _ticket_.ticketValue,
757             _eth
758         );
759     }
760 
761     /** 
762     * @dev determine if active new match
763     */
764     function determineMatch_(uint256 _matchId) private
765     {
766         require(_matchId > 0, "invalid match ID");
767         if(_matchId != openMatchId_){
768             if(openMatchId_ == 0){
769                 startNewMatch_(_matchId);
770             }else{
771                 bool ended;
772                 uint256 halfHomeGoals;
773                 uint256 halfAwayGoals;
774                 uint256 homeGoals;
775                 uint256 awayGoals;
776                 (ended, halfHomeGoals, halfAwayGoals, homeGoals, awayGoals) = MatchDataInt_.getMatchStatus(openMatchId_);
777                 require(ended, "waiting match end");
778                 QIU3Ddatasets.Match storage _match_ = matches_[openMatchId_];
779                 if(!_match_.ended){
780                     _match_.ended = true;
781                     _match_.compressedData = getCompressedMatchResult_(halfHomeGoals, halfAwayGoals, homeGoals, awayGoals);
782                     emit onEndMatch(openMatchId_, _match_.compressedData);
783                     uint256 _fundationDividend = getFoundationDividendFromJackpot_(openMatchId_);
784                     foundationAddress_.transfer(_fundationDividend);
785                 }
786                 startNewMatch_(_matchId);
787             }
788         }
789     }
790 
791     /** 
792     * @dev start a new match
793     */
794     function startNewMatch_(uint256 _matchId) private
795     {
796         uint256 _newMatchId;
797         uint256 _kickoffTime;
798         (_newMatchId,_kickoffTime) = MatchDataInt_.getOpenMatchBaseInfo();
799 
800         require(_matchId == _newMatchId, "match ID invalid");
801         require(_newMatchId > openMatchId_, "No more match opening");
802         openMatchId_ = _newMatchId;
803         QIU3Ddatasets.Match memory _match_;
804         _match_.matchId = _newMatchId;
805         _match_.endts = _kickoffTime;
806         _match_.currentPrice = TicketInitPrice;
807         matchIds_.push(_newMatchId);
808         matches_[_newMatchId] = _match_;
809     }
810 
811     /** 
812     * @dev grant invitor profit
813     */
814     function grantInvitation_(uint256 _eth, address _inviteAddr) private returns(uint256)
815     {
816         uint256 _inviteProfit = 0;
817         if(_inviteAddr != address(0) && _inviteAddr != msg.sender && (players_[_inviteAddr].lastBuyTicketMatchId == openMatchId_)){
818             _inviteProfit = (_eth.mul(InviteProfitPercentage)).div(100);
819             players_[_inviteAddr].inviteProfit = players_[_inviteAddr].inviteProfit.add(_inviteProfit);
820             emit onInvite(msg.sender, _inviteAddr, _inviteProfit);
821         }
822         return _inviteProfit;
823     }
824 
825     /**
826     * @dev update player data whenever player buy ticket
827     */
828     function updatePlayerWithTicket_(QIU3Ddatasets.Ticket memory _ticket_, QIU3Ddatasets.Match storage _match_) private
829     {
830         QIU3Ddatasets.Player storage _player_ = players_[_ticket_.playerAddr];
831         _player_.lastBuyTicketMatchId = openMatchId_;
832 
833         QIU3Ddatasets.MatchPlayer storage _matchPlayer_ = _match_.matchPlayers[_ticket_.playerAddr];
834         _matchPlayer_.ticketIds.push(_ticket_.ticketId);
835 
836         bool playerInThisMatch = false;
837         for(uint i = 0 ; i < _player_.matchIds.length; i ++){
838             if(openMatchId_ == _player_.matchIds[i]){
839                 playerInThisMatch = true;
840             }
841         }
842         if(!playerInThisMatch){
843             _player_.matchIds.push(openMatchId_);
844         }
845     }
846 
847     /**
848     * @dev update match data with ticket options, also check if the bet could opened
849     */
850     function updateMatchTicketOptions_(uint256 _matchId, uint256 _compressedData, uint256 _ticketValue) private
851     {
852         QIU3Ddatasets.TicketEventBoolReturns memory _validReturns_ = getValidOptions_(_compressedData, _validReturns_);
853         QIU3Ddatasets.TicketEventIntReturns memory _optionReturns_ = getDecompressedOptions_(_compressedData, _optionReturns_);
854         //option value in ticket = total ticket value / valid options
855         uint256 _optionValue = _ticketValue.div(_validReturns_.count);
856         if(_validReturns_.fullMatch){
857             ticketOptionValues_[_matchId][_optionReturns_.fullMatch.sub(1)] = ticketOptionValues_[_matchId][_optionReturns_.fullMatch.sub(1)].add(_optionValue);
858         }
859         if(_validReturns_.totalGoal){
860             ticketOptionValues_[_matchId][_optionReturns_.totalGoal.add(3)] = ticketOptionValues_[_matchId][_optionReturns_.totalGoal.add(3)].add(_optionValue);
861         }
862         if(_validReturns_.gapGoal){
863             ticketOptionValues_[_matchId][_optionReturns_.gapGoal.add(13)] = ticketOptionValues_[_matchId][_optionReturns_.gapGoal.add(13)].add(_optionValue);
864         }
865         if(_validReturns_.bothGoal){
866             ticketOptionValues_[_matchId][_optionReturns_.bothGoal.add(23)] = ticketOptionValues_[_matchId][_optionReturns_.bothGoal.add(23)].add(_optionValue);
867         }
868         if(_validReturns_.halfAndFullMatch){
869             ticketOptionValues_[_matchId][_optionReturns_.halfAndFullMatch.add(25)] = ticketOptionValues_[_matchId][_optionReturns_.halfAndFullMatch.add(25)].add(_optionValue);
870         }
871 
872         QIU3Ddatasets.MatchBetOptions storage _betOption_ = betOptions_[_matchId];
873 
874         //open gambling conditions
875         if(!_betOption_.betOpened){
876             //condition 1: at least one player selected each full match result option(home/draw/away) 
877             if(ticketOptionValues_[_matchId][0] != 0 && ticketOptionValues_[_matchId][1] != 0 && ticketOptionValues_[_matchId][2] != 0){
878                 uint256 totalOptionValues;
879                 uint256 fullMatchOptionValue;
880                 (totalOptionValues, fullMatchOptionValue) = getTotalOptionValues_(_matchId);
881                 //condition 2: full match result option value / total option value > 30%
882                 if((fullMatchOptionValue.mul(100)).div(totalOptionValues) > OddsOpenPercentage){
883                     _betOption_.betOpened = true;
884                 }
885             }
886         }
887     }
888 
889     /**
890     * @dev get new ticket price
891     */
892     function getTicketPrice_(uint256 _currentPrice, uint256 _ticketValue) internal pure returns(uint256)
893     {
894         uint256 tv = _ticketValue.div(1000000000000000000);
895         if(tv < PriceThreshold){
896             //newPrice = _currentPrice + TicketIncreasePrice
897             return (_currentPrice.add(TicketIncreasePrice));
898         }else{
899             //newPrice = _currentPrice + TicketIncreasePrice * (_ticketValue/PriceThreshold + 1)
900             return (_currentPrice.add(TicketIncreasePrice.mul((tv.div(PriceThreshold)).add(1))));
901         }
902     }  
903 
904 
905     //==================================================
906     // private functions - ticket options operations
907     //==================================================
908     /**
909     * @dev get total ticket value in current match
910     */
911     function getTotalOptionValues_(uint256 _matchId) private view returns (uint256, uint256)
912     {
913         uint256 _totalCount = 0;
914         uint256 _fullMatchResult = 0;
915         for(uint i = 0 ; i < ticketOptionValues_[_matchId].length; i++){
916             if(i <= 2){
917                 _fullMatchResult = _fullMatchResult.add(ticketOptionValues_[_matchId][i]);
918             }
919             _totalCount = _totalCount.add(ticketOptionValues_[_matchId][i]);
920         }
921         return (_totalCount, _fullMatchResult);
922     }
923 
924 
925     /**
926     * @dev compress ticket options value to uint256
927     */
928     function getCompressedOptions_(uint256 _fullResult, uint256 _totalGoals, uint256 _gapGoals, uint256 _bothGoals, uint256 _halfAndFullResult) 
929         private pure returns (uint256)
930     {
931         //Ticket default settings
932         uint256 fullMatResOpt = InvalidFullMatchResult; 
933         uint256 goalsOpt = InvalidTotalGoals; 
934         uint256 gapGoalsOpt = InvalidGapGoals; 
935         uint256 bothGoalOpt = InvalidBothGoals; 
936         uint256 halfAndFullMatResOpt = InvalidHalfAndFullMatchResult; 
937         uint256 vaildOptions = 0;
938 
939         if(_fullResult > 0 && _fullResult <= 3){
940             vaildOptions = vaildOptions.add(1);
941             fullMatResOpt = _fullResult;
942         }
943         if(_totalGoals <= 9){
944             vaildOptions = vaildOptions.add(1);
945             goalsOpt = _totalGoals;
946         }
947         if(_gapGoals <= 10 ){
948             vaildOptions = vaildOptions.add(1);
949             gapGoalsOpt = _gapGoals;
950         }
951         if(_bothGoals == 1 || _bothGoals == 2){
952             vaildOptions = vaildOptions.add(1);
953             bothGoalOpt = _bothGoals;
954         }
955         if(_halfAndFullResult > 0 && _halfAndFullResult <= 9){
956             vaildOptions = vaildOptions.add(1);
957             halfAndFullMatResOpt = _halfAndFullResult;
958         }
959         //if no vaild option be seleced, select full match result is draw by default
960         if(vaildOptions == 0){
961             vaildOptions = 1;
962             fullMatResOpt == 2;
963         }
964         uint256 compressedData = fullMatResOpt;
965         compressedData = compressedData.add(goalsOpt.mul(10));
966         compressedData = compressedData.add(gapGoalsOpt.mul(1000));
967         compressedData = compressedData.add(bothGoalOpt.mul(100000));
968         compressedData = compressedData.add(halfAndFullMatResOpt.mul(1000000));
969         compressedData = compressedData.add(vaildOptions.mul(10000000));
970         return (compressedData);
971     }
972 
973     /**
974     * @dev check ticket option's valid count
975     */
976     function getValidOptions_(uint256 _compressData, QIU3Ddatasets.TicketEventBoolReturns memory _eventReturns_) 
977         private pure returns (QIU3Ddatasets.TicketEventBoolReturns)
978     {
979         _eventReturns_.fullMatch = (_compressData % 10 != InvalidFullMatchResult);
980         _eventReturns_.totalGoal = ((_compressData % 1000)/10 != InvalidTotalGoals);
981         _eventReturns_.gapGoal = ((_compressData % 100000)/1000 != InvalidGapGoals);
982         _eventReturns_.bothGoal = ((_compressData % 1000000)/100000 != InvalidBothGoals);
983         _eventReturns_.halfAndFullMatch = ((_compressData % 10000000)/1000000 != InvalidHalfAndFullMatchResult);
984         _eventReturns_.count = _compressData/10000000;
985         return (_eventReturns_);
986     }
987 
988     //==================================================
989     // private functions - buy bet
990     //==================================================
991     
992     /** 
993     * @dev buy bet core
994     */
995     function betCore_(uint256 _option, uint256 _odds, uint256 _eth) private
996     {
997         require(_option < 3, "invalid bet option");
998         QIU3Ddatasets.Match storage _match_ = matches_[openMatchId_];
999         require(!_match_.ended && _match_.endts > now, "no match open, wait for next match");
1000         QIU3Ddatasets.BetReturns memory _betReturn_;
1001         _betReturn_ = getBetReturns_(_betReturn_);
1002         require(_betReturn_.opened, "bet not open");
1003 
1004         QIU3Ddatasets.Bet memory _bet_;
1005         if(_option == 0){
1006             require(msg.value <= _betReturn_.homeMaxSell, "not enough to sell");
1007             require(_odds <= _betReturn_.homeOdds, "invalid odds");
1008             if(_odds < _betReturn_.homeOdds){
1009                 //when user bet odds less than live bet, only accept the deviation < 3%
1010                 require(((_betReturn_.homeOdds - _odds).mul(100)).div(_betReturn_.homeOdds) <= OddsMaxDeviation, "Odds already changed");
1011             }
1012             _bet_.odds = _betReturn_.homeOdds;
1013         }else if(_option == 1){
1014             require(msg.value <= _betReturn_.drawMaxSell, "not enough to sell");
1015             require(_odds <= _betReturn_.drawOdds, "invalid odds");
1016             if(_odds < _betReturn_.drawOdds){
1017                 //when user bet odds less than live bet, only accept the deviation < 3%
1018                 require(((_betReturn_.drawOdds - _odds).mul(100)).div(_betReturn_.drawOdds) <= OddsMaxDeviation, "Odds already changed");
1019             }
1020             _bet_.odds = _betReturn_.drawOdds;
1021         }else if(_option == 2){
1022             require(msg.value <= _betReturn_.awayMaxSell, "not enough to sell");
1023             require(_odds <= _betReturn_.awayOdds, "invalid odds");
1024             if(_odds < _betReturn_.awayOdds){
1025                 //when user bet odds less than live bet, only accept the deviation < 3%
1026                 require(((_betReturn_.awayOdds - _odds).mul(100)).div(_betReturn_.awayOdds) <= OddsMaxDeviation, "Odds already changed");
1027             }
1028             _bet_.odds = _betReturn_.awayOdds;
1029         }
1030 
1031         //generate new bet ID
1032         uint256 _betId = _match_.betIds.length.add(1);
1033         _bet_.betId = _betId;
1034         _bet_.option = _option;
1035         _bet_.playerAddr = msg.sender;
1036         _bet_.cost = _eth;
1037 
1038         _match_.betFund = _match_.betFund.add(_eth);
1039         _match_.betIds.push(_betId);
1040         _match_.bets[_betId] = _bet_;
1041 
1042         updatePlayerWithBet_(_bet_, _match_);
1043         updateMatchBetOptions_(_bet_);
1044         
1045         emit onNewBet(msg.sender, _match_.matchId, _betId, _option, _bet_.odds, _eth);
1046     }
1047 
1048     /**
1049     * @dev get bet return information
1050     */
1051     function getBetReturns_(QIU3Ddatasets.BetReturns memory _betReturn_) private view returns(QIU3Ddatasets.BetReturns)
1052     {
1053         QIU3Ddatasets.MatchBetOptions memory _betOption_ = betOptions_[openMatchId_];
1054         if(_betOption_.betOpened){
1055             uint256 _totalValue = ticketOptionValues_[openMatchId_][0] + ticketOptionValues_[openMatchId_][1] + ticketOptionValues_[openMatchId_][2];
1056             _betReturn_.homeOdds = calOdds_(_totalValue, ticketOptionValues_[openMatchId_][0]);
1057             _betReturn_.drawOdds = calOdds_(_totalValue, ticketOptionValues_[openMatchId_][1]);
1058             _betReturn_.awayOdds = calOdds_(_totalValue, ticketOptionValues_[openMatchId_][2]);
1059 
1060             uint256 _totalBetJackpot = getBetJackpot_(openMatchId_);
1061             _betReturn_.homeMaxSell = ((_totalBetJackpot.sub(_betOption_.homeBetReturns)).mul(100)).div(_betReturn_.homeOdds);
1062             _betReturn_.drawMaxSell = ((_totalBetJackpot.sub(_betOption_.drawBetReturns)).mul(100)).div(_betReturn_.drawOdds);
1063             _betReturn_.awayMaxSell = ((_totalBetJackpot.sub(_betOption_.awayBetReturns)).mul(100)).div(_betReturn_.awayOdds);
1064             _betReturn_.opened = true;
1065         }
1066         return (_betReturn_);
1067     }
1068     
1069     /**
1070     * @dev update player information with bet 
1071     */
1072     function updatePlayerWithBet_(QIU3Ddatasets.Bet memory _bet_, QIU3Ddatasets.Match storage _match_) private
1073     {
1074         QIU3Ddatasets.MatchPlayer storage _matchPlayer_ = _match_.matchPlayers[_bet_.playerAddr];
1075         _matchPlayer_.betIds.push(_bet_.betId);
1076 
1077         QIU3Ddatasets.Player storage _player_ = players_[_bet_.playerAddr];
1078         bool playerInThisMatch = false;
1079         for(uint i = 0 ; i < _player_.matchIds.length; i ++){
1080             if(openMatchId_ == _player_.matchIds[i]){
1081                 playerInThisMatch = true;
1082             }
1083         }
1084         if(!playerInThisMatch){
1085             _player_.matchIds.push(openMatchId_);
1086         }
1087     }
1088 
1089     /**
1090     * @dev update bet return with bet 
1091     */
1092     function updateMatchBetOptions_(QIU3Ddatasets.Bet memory _bet_) private
1093     {
1094         QIU3Ddatasets.MatchBetOptions storage _betOption_ = betOptions_[openMatchId_];
1095         if(_bet_.option == 0){
1096             _betOption_.homeBetReturns = _betOption_.homeBetReturns.add((_bet_.cost.mul(_bet_.odds)).div(100));
1097         }else if(_bet_.option == 1){
1098             _betOption_.drawBetReturns = _betOption_.drawBetReturns.add((_bet_.cost.mul(_bet_.odds)).div(100));
1099         }else if(_bet_.option == 2){
1100             _betOption_.awayBetReturns = _betOption_.awayBetReturns.add((_bet_.cost.mul(_bet_.odds)).div(100));
1101         }
1102     }
1103 
1104     /**
1105     * @dev calculate bet odds
1106     */
1107     function calOdds_(uint256 _totalValue, uint256 _optionValue) private pure returns(uint256){
1108         uint256 _odds = (_totalValue.mul(100)).div(_optionValue);
1109         uint256 _commission = _odds.div(OddsCommission);
1110         return (_odds - _commission);
1111     }
1112 
1113 
1114     //==================================================
1115     // private functions - jackpot and dividend
1116     //==================================================
1117     /**
1118     * @dev get bet jackpot
1119     */
1120     function getBetJackpot_(uint256 _matchId) private view returns(uint256)
1121     {
1122         QIU3Ddatasets.Match memory _match_ = matches_[_matchId];
1123         uint256 _betJackpot = ((_match_.ticketFund.mul(BxTJPPercentage)).div(100)).add((_match_.betFund.mul(BxBJPPercentage)).div(100));
1124         return (_betJackpot);
1125     }
1126 
1127     /**
1128     * @dev get ticket jackpot
1129     */
1130     function getTicketJackpot_(uint256 _matchId, uint256 _remainBetJackpot) private view returns(uint256)
1131     {
1132         QIU3Ddatasets.Match memory _match_ = matches_[_matchId];
1133         uint256 _ticketJackpot = (_match_.ticketFund.mul(TxTJPPercentage)).div(100);
1134         _ticketJackpot = _ticketJackpot.add(_remainBetJackpot);
1135         return (_ticketJackpot);
1136     }
1137 
1138     /**
1139     * @dev get ticket dividend
1140     */
1141     function getTicketDividendFromJackpot_(uint256 _matchId, uint256 _remainTicketJackpot) private view returns(uint256)
1142     {
1143         QIU3Ddatasets.Match memory _match_ = matches_[_matchId];
1144         uint256 _totalDividend = (_match_.ticketFund.mul(DxTJPPercentage)).div(100);
1145         if(_match_.ended){
1146             _totalDividend = _totalDividend.add((_match_.betFund.mul(DxBJPPercentage)).div(100));
1147             _totalDividend = _totalDividend.add(_remainTicketJackpot);
1148         }
1149         uint256 _ticketDividend = (_totalDividend.mul(TxDJPPercentage)).div(100);
1150         return (_ticketDividend);
1151     }
1152 
1153     /**
1154     * @dev get foundation dividend
1155     */
1156     function getFoundationDividendFromJackpot_(uint256 _matchId) private view returns(uint256)
1157     {
1158         QIU3Ddatasets.Match memory _match_ = matches_[_matchId];
1159         uint256 _totalDividend = ((_match_.ticketFund.mul(DxTJPPercentage)).div(100)).add((_match_.betFund.mul(DxBJPPercentage)).div(100));
1160 
1161         uint256 _betClearedProfit = getBetClearedProfit_(_matchId, _match_.compressedData);
1162         uint256 _ticketJackpot = getTicketJackpot_(_matchId, _betClearedProfit);
1163         QIU3Ddatasets.TicketEventIntReturns memory _profitReturns_ = calculateTicketProfitAssign_(
1164             _matchId, 
1165             _match_.compressedData, 
1166             _ticketJackpot, 
1167             _profitReturns_);
1168         
1169         if(_profitReturns_.count == 0){
1170             _totalDividend = _totalDividend.add(_ticketJackpot);
1171         }
1172 
1173         uint256 _foundationDividend = (_totalDividend.mul(FxDJPPercentage)).div(100);
1174         return (_foundationDividend);
1175     }
1176 
1177     /**
1178     * @dev compare two compressed ticket option and return bool resuts
1179     */
1180     function compareOptionsResult_(uint256 optionData, uint256 resultData, QIU3Ddatasets.TicketEventBoolReturns memory _eventReturns_) 
1181         private pure returns(QIU3Ddatasets.TicketEventBoolReturns)
1182     {
1183         _eventReturns_.fullMatch = (optionData % 10 == resultData % 10);
1184         _eventReturns_.totalGoal = ((optionData % 1000)/10 == (resultData % 1000)/10) && ((resultData % 1000)/10 != InvalidTotalGoals);
1185         _eventReturns_.gapGoal = ((optionData % 100000)/1000 == (resultData % 100000)/1000) && ((resultData % 100000)/1000 != InvalidGapGoals);
1186         _eventReturns_.bothGoal = ((optionData % 1000000)/100000 == (resultData % 1000000)/100000);
1187         _eventReturns_.halfAndFullMatch = ((optionData % 10000000)/1000000 == (resultData % 10000000)/1000000);
1188         return (_eventReturns_);
1189     }
1190 
1191     /**
1192     * @dev convert match score to ticket options value and compress to uint256
1193     */
1194     function getCompressedMatchResult_(uint256 _halfHomeGoals, uint256 _halfAwayGoals, uint256 _homeGoals, uint256 _awayGoals)
1195         private pure returns (uint256)
1196     {
1197         uint256 validCount = 5;
1198         //calculate full time match result
1199         uint256 fullMatchResult;
1200         //calculate gap goal = home goals - away goals
1201         uint256 gapGoal;
1202         if(_homeGoals >= _awayGoals){
1203             gapGoal = (_homeGoals.sub(_awayGoals)).add(5);
1204             if(gapGoal > 10){
1205                 gapGoal = InvalidGapGoals;
1206                 validCount = validCount.sub(1);
1207             }
1208         }else{
1209             gapGoal = _awayGoals.sub(_homeGoals);
1210             if(gapGoal > 5){
1211                 gapGoal = InvalidGapGoals;
1212                 validCount = validCount.sub(1);
1213             }else{
1214                 gapGoal = 5 - gapGoal;
1215             }
1216         }
1217         uint256 halfAndFullResult;
1218         //calculate half and full time match result
1219         if(_homeGoals > _awayGoals){
1220             fullMatchResult = 1;
1221             if(_halfHomeGoals > _halfAwayGoals){
1222                 halfAndFullResult = 1;
1223             }else if(_halfHomeGoals == _halfAwayGoals){
1224                 halfAndFullResult = 2;
1225             }else{
1226                 halfAndFullResult = 3;
1227             }
1228         }else if(_homeGoals == _awayGoals){
1229             fullMatchResult = 2;
1230             if(_halfHomeGoals > _halfAwayGoals){
1231                 halfAndFullResult = 4;
1232             }else if(_halfHomeGoals == _halfAwayGoals){
1233                 halfAndFullResult = 5;
1234             }else{
1235                 halfAndFullResult = 6;
1236             }
1237         }else{
1238             fullMatchResult = 3;
1239             if(_halfHomeGoals > _halfAwayGoals){
1240                 halfAndFullResult = 7;
1241             }else if(_halfHomeGoals == _halfAwayGoals){
1242                 halfAndFullResult = 8;
1243             }else{
1244                 halfAndFullResult = 9;
1245             }
1246         }
1247         //calculate both team goals result
1248         uint256 bothGoalResult = 1;
1249         if(_homeGoals == 0 || _awayGoals == 0){
1250             bothGoalResult = 2;
1251         }
1252         //calculate total goals result
1253         uint256 totalGoalResult = _homeGoals + _awayGoals;
1254         if(totalGoalResult > 9){
1255             totalGoalResult = InvalidTotalGoals;
1256             validCount = validCount.sub(1);
1257         }
1258 
1259         uint256 compressedData = fullMatchResult;
1260         compressedData = compressedData.add(totalGoalResult.mul(10));
1261         compressedData = compressedData.add(gapGoal.mul(1000));
1262         compressedData = compressedData.add(bothGoalResult.mul(100000));
1263         compressedData = compressedData.add(halfAndFullResult.mul(1000000));
1264         compressedData = compressedData.add(validCount.mul(10000000));
1265 
1266         return (compressedData);
1267     }
1268 
1269     /**
1270     * @dev decompress ticket options
1271     */
1272     function getDecompressedOptions_(uint256 _compressData, QIU3Ddatasets.TicketEventIntReturns memory _eventReturns_) 
1273         private pure returns (QIU3Ddatasets.TicketEventIntReturns)
1274     {
1275         _eventReturns_.fullMatch = _compressData % 10;
1276         _eventReturns_.totalGoal = (_compressData % 1000)/10;
1277         _eventReturns_.gapGoal = (_compressData % 100000)/1000;
1278         _eventReturns_.bothGoal = (_compressData % 1000000)/100000;
1279         _eventReturns_.halfAndFullMatch = (_compressData % 10000000)/1000000;
1280         _eventReturns_.count = _compressData/10000000;
1281         return (_eventReturns_);
1282     }
1283 }
1284 
1285 
1286 //==================================================
1287 // Interface
1288 //==================================================
1289 interface Q3DMatchDataInterface {
1290    function getOpenMatchBaseInfo() external view returns(uint256, uint256);
1291    function getMatchStatus(uint256 _matchId) external view returns(bool, uint256, uint256, uint256, uint256);
1292 }
1293 
1294 //==================================================
1295 // Structs - Storage 
1296 //==================================================
1297 
1298 library QIU3Ddatasets{
1299 
1300     struct Match{
1301         bool ended;                     //if match ended
1302         uint256 matchId;                //ID of soccer match      
1303         uint256 endts;                  //match end timestamp
1304         uint256 currentPrice;           //current ticket price
1305         uint256 ticketFund;             //fund of ticket
1306         uint256 betFund;                //fund of bet
1307         uint256 compressedData;         //compressed options for match result
1308         uint256[] ticketIds;            //ticket IDs in this match
1309         uint256[] betIds;               //bet IDs in this match
1310         mapping(uint256 => Ticket) tickets; //(ticketID => Ticket) return card by cardId
1311         mapping(uint256 => Bet) bets;   //(betId => Bet) return bet by betId
1312         mapping(address => MatchPlayer) matchPlayers;   //(address => MatchPlayer) return player in match by address
1313     }
1314 
1315     struct Player{
1316         uint256 lastBuyTicketMatchId;   //save the last match ID when player buy ticket, check the player have right to invit other players
1317         uint256 inviteProfit;   //profit by invite player
1318         uint256 withdraw;       //player total withdraw
1319         uint256[] matchIds;     //IDs of player join matches
1320     }
1321 
1322     struct MatchPlayer{
1323         uint256[] ticketIds; 
1324         uint256[] betIds;
1325     }
1326 
1327     //====== Ticket Options ======
1328     // compressedData Ticet Options
1329     // [7][6][5][4-3][2-1][0]
1330     // [0]: Full time match result option(0 - 9)
1331         // 0 - none
1332         // 1 - home team win 
1333         // 2 - draw
1334         // 3 - away team win 
1335     // [2-1]: Full time total goals option(0 - 9)
1336         // 88 - none
1337     // [4-3]: Home goals minus Away goals option(0 - 99)
1338         // 88 - none
1339     // [5]: Both team goal(0 - 9)
1340         // 0 - none
1341         // 1 - yes
1342         // 2 - no
1343     // [6]: Half and full time match result option(0 - 9)
1344         // 0 - none
1345         // 1 - home/home
1346         // 2 - home/draw
1347         // 3 - home/away
1348         // 4 - draw/home
1349         // 5 - draw/draw
1350         // 6 - draw/away
1351         // 7 - away/home
1352         // 8 - away/draw
1353         // 9 - away/away
1354     // [7]: valid option count(0 - 9)
1355     struct Ticket{
1356         uint256 compressedData;     //compressed ticket options data
1357         uint256 ticketId;       //ID of ticket
1358         address playerAddr;     //address of player
1359         uint256 ticketValue;    //value of ticket
1360         uint256 cost;           //cost of buy ticket
1361     }
1362 
1363     struct Bet{
1364         uint256 betId;          //ID of bet
1365         address playerAddr;     //address of player
1366         uint256 option;           //player selected option (0 - home, 1 - draw , 2- away)
1367         uint256 odds;           //odds when player bet
1368         uint256 cost;           //cost of bet
1369     }
1370 
1371     struct MatchBetOptions{
1372         bool betOpened;
1373         uint256 homeBetReturns;
1374         uint256 drawBetReturns;
1375         uint256 awayBetReturns;
1376     }
1377 
1378     //==================================================
1379     // Structs - Returns value
1380     //==================================================
1381     struct BetReturns{
1382         bool opened;
1383         uint256 homeOdds;
1384         uint256 drawOdds;
1385         uint256 awayOdds;
1386         uint256 homeMaxSell;
1387         uint256 drawMaxSell;
1388         uint256 awayMaxSell; 
1389     }
1390 
1391     struct TicketEventIntReturns{
1392         uint256 fullMatch;
1393         uint256 totalGoal;
1394         uint256 gapGoal;
1395         uint256 bothGoal;
1396         uint256 halfAndFullMatch;
1397         uint256 count;
1398     }
1399 
1400     struct TicketEventBoolReturns{
1401         bool fullMatch;
1402         bool totalGoal;
1403         bool gapGoal;
1404         bool bothGoal;
1405         bool halfAndFullMatch;
1406         uint256 count;
1407     }
1408 }