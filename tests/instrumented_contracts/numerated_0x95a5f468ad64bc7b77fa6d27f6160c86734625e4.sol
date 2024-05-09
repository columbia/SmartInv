1 // produced by the Solididy File Flattener (c) David Appleton 2018
2 // contact : dave@akomba.com
3 // released under Apache 2.0 licence
4 library Roles {
5   struct Role {
6     mapping (address => bool) bearer;
7   }
8 
9   /**
10    * @dev give an address access to this role
11    */
12   function add(Role storage role, address addr)
13     internal
14   {
15     role.bearer[addr] = true;
16   }
17 
18   /**
19    * @dev remove an address' access to this role
20    */
21   function remove(Role storage role, address addr)
22     internal
23   {
24     role.bearer[addr] = false;
25   }
26 
27   /**
28    * @dev check if an address has this role
29    * // reverts
30    */
31   function check(Role storage role, address addr)
32     view
33     internal
34   {
35     require(has(role, addr));
36   }
37 
38   /**
39    * @dev check if an address has this role
40    * @return bool
41    */
42   function has(Role storage role, address addr)
43     view
44     internal
45     returns (bool)
46   {
47     return role.bearer[addr];
48   }
49 }
50 
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
58     // benefit is lost if 'b' is also tested.
59     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60     if (a == 0) {
61       return 0;
62     }
63 
64     c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     // uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return a / b;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    */
127   function renounceOwnership() public onlyOwner {
128     emit OwnershipRenounced(owner);
129     owner = address(0);
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address _newOwner) public onlyOwner {
137     _transferOwnership(_newOwner);
138   }
139 
140   /**
141    * @dev Transfers control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function _transferOwnership(address _newOwner) internal {
145     require(_newOwner != address(0));
146     emit OwnershipTransferred(owner, _newOwner);
147     owner = _newOwner;
148   }
149 }
150 
151 contract RefundVault is Ownable {
152   using SafeMath for uint256;
153 
154   enum State { Active, Refunding, Closed }
155 
156   mapping (address => uint256) public deposited;
157   address public wallet;
158   State public state;
159 
160   event Closed();
161   event RefundsEnabled();
162   event Refunded(address indexed beneficiary, uint256 weiAmount);
163 
164   /**
165    * @param _wallet Vault address
166    */
167   constructor(address _wallet) public {
168     require(_wallet != address(0));
169     wallet = _wallet;
170     state = State.Active;
171   }
172 
173   /**
174    * @param investor Investor address
175    */
176   function deposit(address investor) onlyOwner public payable {
177     require(state == State.Active);
178     deposited[investor] = deposited[investor].add(msg.value);
179   }
180 
181   function close() onlyOwner public {
182     require(state == State.Active);
183     state = State.Closed;
184     emit Closed();
185     wallet.transfer(address(this).balance);
186   }
187 
188   function enableRefunds() onlyOwner public {
189     require(state == State.Active);
190     state = State.Refunding;
191     emit RefundsEnabled();
192   }
193 
194   /**
195    * @param investor Investor address
196    */
197   function refund(address investor) public {
198     require(state == State.Refunding);
199     uint256 depositedValue = deposited[investor];
200     deposited[investor] = 0;
201     investor.transfer(depositedValue);
202     emit Refunded(investor, depositedValue);
203   }
204 }
205 
206 contract Claimable is Ownable {
207   address public pendingOwner;
208 
209   /**
210    * @dev Modifier throws if called by any account other than the pendingOwner.
211    */
212   modifier onlyPendingOwner() {
213     require(msg.sender == pendingOwner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to set the pendingOwner address.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) onlyOwner public {
222     pendingOwner = newOwner;
223   }
224 
225   /**
226    * @dev Allows the pendingOwner address to finalize the transfer.
227    */
228   function claimOwnership() onlyPendingOwner public {
229     emit OwnershipTransferred(owner, pendingOwner);
230     owner = pendingOwner;
231     pendingOwner = address(0);
232   }
233 }
234 
235 contract RBAC {
236   using Roles for Roles.Role;
237 
238   mapping (string => Roles.Role) private roles;
239 
240   event RoleAdded(address addr, string roleName);
241   event RoleRemoved(address addr, string roleName);
242 
243   /**
244    * @dev reverts if addr does not have role
245    * @param addr address
246    * @param roleName the name of the role
247    * // reverts
248    */
249   function checkRole(address addr, string roleName)
250     view
251     public
252   {
253     roles[roleName].check(addr);
254   }
255 
256   /**
257    * @dev determine if addr has role
258    * @param addr address
259    * @param roleName the name of the role
260    * @return bool
261    */
262   function hasRole(address addr, string roleName)
263     view
264     public
265     returns (bool)
266   {
267     return roles[roleName].has(addr);
268   }
269 
270   /**
271    * @dev add a role to an address
272    * @param addr address
273    * @param roleName the name of the role
274    */
275   function addRole(address addr, string roleName)
276     internal
277   {
278     roles[roleName].add(addr);
279     emit RoleAdded(addr, roleName);
280   }
281 
282   /**
283    * @dev remove a role from an address
284    * @param addr address
285    * @param roleName the name of the role
286    */
287   function removeRole(address addr, string roleName)
288     internal
289   {
290     roles[roleName].remove(addr);
291     emit RoleRemoved(addr, roleName);
292   }
293 
294   /**
295    * @dev modifier to scope access to a single role (uses msg.sender as addr)
296    * @param roleName the name of the role
297    * // reverts
298    */
299   modifier onlyRole(string roleName)
300   {
301     checkRole(msg.sender, roleName);
302     _;
303   }
304 
305   /**
306    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
307    * @param roleNames the names of the roles to scope access to
308    * // reverts
309    *
310    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
311    *  see: https://github.com/ethereum/solidity/issues/2467
312    */
313   // modifier onlyRoles(string[] roleNames) {
314   //     bool hasAnyRole = false;
315   //     for (uint8 i = 0; i < roleNames.length; i++) {
316   //         if (hasRole(msg.sender, roleNames[i])) {
317   //             hasAnyRole = true;
318   //             break;
319   //         }
320   //     }
321 
322   //     require(hasAnyRole);
323 
324   //     _;
325   // }
326 }
327 
328 contract RoundVault is RefundVault {
329 
330     uint256 constant DEV_FUND_COMMISSION = 4; //%
331 
332     uint256 public totalRoundPrize;
333     uint256 public finalCumulativeWeight;
334 
335     StartersProxyInterface public startersProxy;
336 
337     event RewardWinner(address player, uint256 weiAmount, uint256 kPercent);
338 
339     constructor(address _devFundWallet, address _proxyAddress) RefundVault(_devFundWallet) public {
340         startersProxy = StartersProxyInterface(_proxyAddress);
341     }
342 
343     /**
344     * @dev Pays actual ETH to the winner
345     */
346     function reward(address _winner, uint256 _personalWeight) onlyOwner public {
347         //millions of % for better precision
348         uint256 _portion = _personalWeight.mul(100000000).div(finalCumulativeWeight);
349 
350         //wei
351         uint256 _prizeWei = totalRoundPrize.mul(_portion).div(100000000);
352 
353         require(address(this).balance > _prizeWei, "Vault run out of funds!");
354 
355         if (isContract(_winner)) {
356             //do noting
357             //bad guy, punish this hacking attempt
358         } else {
359             //check if any debt player has
360             uint256 _personalDept = startersProxy.debt(_winner);
361             if (_personalDept > 0) {
362                 uint256 _toRepay = _personalDept;
363                 if (_prizeWei < _personalDept) {
364                     //don't repay more than won
365                     _toRepay = _prizeWei;
366                 }
367                 startersProxy.payDebt.value(_toRepay)(_winner);
368                 //anything left to reward with?
369                 if (_prizeWei.sub(_toRepay) > 0) {
370                     _winner.transfer(_prizeWei.sub(_toRepay));
371                 }
372             } else {
373                 _winner.transfer(_prizeWei);
374             }
375         }
376 
377         emit RewardWinner(_winner, _prizeWei, _portion);
378     }
379 
380     function isContract(address _address) internal view returns (bool) {
381         uint size;
382         assembly { size := extcodesize(_address) }
383         return size > 0;
384     }
385 
386     function personalPrizeByNow(uint256 _personalWeight, uint256 _roundCumulativeWeigh) onlyOwner public view returns (uint256){
387         if (_roundCumulativeWeigh == 0) {
388             //no wins in this round yet
389             return 0;
390         }
391         //millions of % for better precision
392         uint256 _portion = _personalWeight.mul(100000000).div(_roundCumulativeWeigh);
393         //wei
394         return totalPrizePot().mul(_portion).div(100000000);
395     }
396 
397     function personalPrizeWithBet(uint256 _personalWeight, uint256 _roundCumulativeWeight, uint256 _bet) onlyOwner public view returns (uint256){
398         if (_roundCumulativeWeight == 0) {
399             //no wins in this round yet
400             _roundCumulativeWeight = _personalWeight;
401         } else {
402             //assuming cumulativeWeight
403             _roundCumulativeWeight = _roundCumulativeWeight.add(_personalWeight);
404         }
405         uint256 _portion = _personalWeight.mul(100).div(_roundCumulativeWeight);
406 
407         //wei
408         uint256 _assumingPersonalAdditionToPot = _bet.mul(100 - DEV_FUND_COMMISSION).div(100);
409         uint256 _assumingPrizePot = totalPrizePot().add(_assumingPersonalAdditionToPot);
410 
411         return _assumingPrizePot.mul(_portion).div(100);
412     }
413 
414     function totalPrizePot() internal view returns (uint256) {
415         return address(this).balance.mul(100 - DEV_FUND_COMMISSION).div(100);
416     }
417 
418     function sumUp(uint256 _weight) onlyOwner public {
419         finalCumulativeWeight = _weight;
420         totalRoundPrize = totalPrizePot();
421     }
422 
423     function terminate() onlyOwner public {
424         state = State.Active;
425         super.close();
426     }
427 
428     function getWallet() public view returns (address) {
429         return wallet;
430     }
431 
432     function getDevFundAddress() public view returns (address){
433         return wallet;
434     }
435 }
436 
437 interface StartersProxyInterface {
438 
439     function debt(address signer) external view returns (uint256);
440 
441     function payDebt(address signer) external payable;
442 }
443 
444 contract Whitelist is Ownable, RBAC {
445   event WhitelistedAddressAdded(address addr);
446   event WhitelistedAddressRemoved(address addr);
447 
448   string public constant ROLE_WHITELISTED = "whitelist";
449 
450   /**
451    * @dev Throws if called by any account that's not whitelisted.
452    */
453   modifier onlyWhitelisted() {
454     checkRole(msg.sender, ROLE_WHITELISTED);
455     _;
456   }
457 
458   /**
459    * @dev add an address to the whitelist
460    * @param addr address
461    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
462    */
463   function addAddressToWhitelist(address addr)
464     onlyOwner
465     public
466   {
467     addRole(addr, ROLE_WHITELISTED);
468     emit WhitelistedAddressAdded(addr);
469   }
470 
471   /**
472    * @dev getter to determine if address is in whitelist
473    */
474   function whitelist(address addr)
475     public
476     view
477     returns (bool)
478   {
479     return hasRole(addr, ROLE_WHITELISTED);
480   }
481 
482   /**
483    * @dev add addresses to the whitelist
484    * @param addrs addresses
485    * @return true if at least one address was added to the whitelist,
486    * false if all addresses were already in the whitelist
487    */
488   function addAddressesToWhitelist(address[] addrs)
489     onlyOwner
490     public
491   {
492     for (uint256 i = 0; i < addrs.length; i++) {
493       addAddressToWhitelist(addrs[i]);
494     }
495   }
496 
497   /**
498    * @dev remove an address from the whitelist
499    * @param addr address
500    * @return true if the address was removed from the whitelist,
501    * false if the address wasn't in the whitelist in the first place
502    */
503   function removeAddressFromWhitelist(address addr)
504     onlyOwner
505     public
506   {
507     removeRole(addr, ROLE_WHITELISTED);
508     emit WhitelistedAddressRemoved(addr);
509   }
510 
511   /**
512    * @dev remove addresses from the whitelist
513    * @param addrs addresses
514    * @return true if at least one address was removed from the whitelist,
515    * false if all addresses weren't in the whitelist in the first place
516    */
517   function removeAddressesFromWhitelist(address[] addrs)
518     onlyOwner
519     public
520   {
521     for (uint256 i = 0; i < addrs.length; i++) {
522       removeAddressFromWhitelist(addrs[i]);
523     }
524   }
525 
526 }
527 
528 contract EthBattleRound is Whitelist, Claimable {
529     using SafeMath for uint256;
530 
531     uint256 public constant SMART_ASS_COEFFICIENT = 5; //%
532     uint256 public constant REFERRAL_BONUS = 1; //%
533 
534     // refund vault used to hold funds while round is running.
535     // Can allow claiming of ETH back to participants if something went wrong
536     RoundVault public vault;
537 
538     event Play(address player, uint256 bet, address referral, address round);
539     event Win(address player, address round);
540     event Reward(uint256 counter, address winner);
541     event Finalize(uint256 count);
542     event CoolDown(uint256 winCount);
543 
544     //Active - can play
545     //CoolingDown - can't play but still can win
546     //Rewarding - neither plays nor wins possible, it's in the state of paying rewards
547     //Closed - rewarding is over, fund is empty
548     enum State {Active, CoolingDown, Rewarding, Closed}
549     State private state;
550 
551     uint256 public roundCumulativeWeight;
552     uint256 public winCount;   //facts
553     uint256 public winnerCount; //players
554     uint256 public rewardCount;
555 
556     uint256 public roundSwapLimit = 200; //the default 'win' counter triggering the round swap
557 
558     //backlog of winners counting their wins
559     mapping(address => uint256) public winnersBacklog;
560 
561     //backlog of players and their referrals
562     mapping(address => address) public referralBacklog;
563     //players and their last bets
564     mapping(address => uint256) public lastBetWei;
565     //players and their cumulative wins weight in the round
566     mapping(address => uint256) public playerWinWeight;
567     //rewarded winners
568     mapping(address => bool) public rewardedWinners;
569 
570 
571     /**
572     * @dev Default fallback function, just deposits funds to the pot
573     */
574     function () public payable {
575         vault.getWallet().transfer(msg.value);
576     }
577 
578     /**
579     * @dev Constructor, creates EthBattleRound.
580     * @param _devFundWallet Development funds wallet to store a portion of funds once round is over
581     * @param _battleAddress EthBattle address
582     * @param _rewardingAddrs addresses authorized to pay the rewards
583     */
584     constructor (address _devFundWallet, address _battleAddress, address[] _rewardingAddrs, address _proxyAddress) public {
585         vault = new RoundVault(_devFundWallet, _proxyAddress);
586 
587         addAddressToWhitelist(_battleAddress);
588 
589         addAddressesToWhitelist(_rewardingAddrs);
590 
591         state = State.Active;
592     }
593 
594     function isActive() public view returns (bool){
595         return state == State.Active;
596     }
597 
598     /**
599     * @dev Enable the refunds to players can claim back their bets
600     */
601     function enableRefunds() onlyOwner public {
602         require(isActive() || isCoolingDown(), "Round must be active");
603         vault.enableRefunds();
604     }
605 
606     /**
607     * @dev Last resort, terminate the round from any state
608     */
609     function terminate() external onlyWhitelisted {
610         //from any state
611         vault.terminate();
612         state = State.Closed;
613     }
614 
615     /**
616     * @dev Every player, if enabled, can claim refund
617     */
618     function claimRefund() public {
619         vault.refund(msg.sender);
620     }
621 
622 
623     function coolDown() onlyOwner public {
624         require(isActive() || isCoolingDown(), "Round must be active");
625         state = State.CoolingDown;
626         emit CoolDown(winCount);
627     }
628 
629     function isCoolingDown() public view returns (bool){
630         return state == State.CoolingDown;
631     }
632 
633     function startRewarding() external onlyWhitelisted {
634         require(isCoolingDown(), "Cool it down first");
635         vault.sumUp(roundCumulativeWeight);
636 
637         state = State.Rewarding;
638     }
639 
640     function isRewarding() public view returns (bool){
641         return state == State.Rewarding;
642     }
643 
644     function playRound(address _player, uint256 _bet) onlyOwner public payable {
645         require(isActive(), "Not active anymore");
646 
647         lastBetWei[_player] = _bet;
648 
649         uint256 _thisBet = msg.value;
650         if (referralBacklog[_player] != address(0)) {
651             //this player used a referral link once, split the bet
652             uint256 _referralReward = _thisBet.mul(REFERRAL_BONUS).div(100);
653             if (isContract(referralBacklog[_player])) {
654                 //do noting
655                 //bad guy, punish this hacking attempt
656                 vault.getDevFundAddress().transfer(_referralReward);
657             } else {
658                 referralBacklog[_player].transfer(_referralReward);
659             }
660             _thisBet = _thisBet.sub(_referralReward);
661         }
662 
663         vault.deposit.value(_thisBet)(_player);
664 
665         emit Play(_player, _thisBet, referralBacklog[_player], address(this));
666 
667     }
668 
669     function win(address _player) onlyOwner public {
670         require(isActive() || isCoolingDown(), "Round must be active or cooling down");
671 
672         require(lastBetWei[_player] > 0, "Hmm, did this player call 'play' before?");
673 
674         uint256 _thisWinWeight = applySmartAssCorrection(_player, lastBetWei[_player]);
675 
676         recordWinFact(_player, _thisWinWeight);
677     }
678 
679     /**
680     * @dev Prize right now, if the payment would have happened immediately
681     */
682     function currentPrize(address _player) onlyOwner public view returns (uint256) {
683         //calculate depending on personal weight and the total weight so far
684         return vault.personalPrizeByNow(playerWinWeight[_player], roundCumulativeWeight);
685     }
686 
687     /**
688     * @dev Project the prize if this were the last game and the payment would take place right after this win
689     * NOTE: Doesn't apply the referral's correction
690     */
691     function projectedPrizeForPlayer(address _player, uint256 _bet) onlyOwner public view returns (uint256) {
692         uint256 _projectedPersonalWeight = applySmartAssCorrection(_player, _bet);
693         //calculate depending on personal weight and the total weight so far
694         return vault.personalPrizeWithBet(_projectedPersonalWeight, roundCumulativeWeight, _bet);
695     }
696 
697     function recordWinFact(address _player, uint256 _winWeight) internal {
698         if (playerWinWeight[_player] == 0) {
699             //new winner
700             winnerCount++;
701         }
702         winCount++;
703         playerWinWeight[_player] = playerWinWeight[_player].add(_winWeight);
704         roundCumulativeWeight = roundCumulativeWeight.add(_winWeight);
705 
706         winnersBacklog[_player] = winnersBacklog[_player].add(1);
707         if (winCount == roundSwapLimit) {
708             //this round is over. Cool down.
709             coolDown();
710         }
711         emit Win(_player, address(this));
712     }
713 
714     function applySmartAssCorrection(address _player, uint256 _bet) internal view returns (uint256){
715         if (winnersBacklog[_player] > 0) {
716             //has won before, or he's a referral and got his fee before
717             uint256 _personalWinCount = winnersBacklog[_player];
718             if (_personalWinCount > 10) {
719                 //even if more than 10 wins limit decrease to 10 * SMART_ASS_COEFFICIENT
720                 _personalWinCount = 10;
721             }
722             _bet = _bet.mul(100 - _personalWinCount.mul(SMART_ASS_COEFFICIENT)).div(100);
723         }
724         return _bet;
725     }
726 
727     function rewardWinner(address _winner) external onlyWhitelisted {
728         require(state == State.Rewarding, "Round in not in 'Rewarding' state yet");
729         require(playerWinWeight[_winner] > 0, "This player hasn't actually won anything");
730         require(!rewardedWinners[_winner], "This player has been rewarded already");
731 
732         vault.reward(_winner, playerWinWeight[_winner]);
733 
734         rewardedWinners[_winner] = true;
735         rewardCount++;
736         emit Reward(rewardCount, _winner);
737     }
738 
739     function setReferral(address _player, address _referral) onlyOwner public {
740         if (referralBacklog[_player] == address(0)) {
741             referralBacklog[_player] = _referral;
742         }
743     }
744 
745     function finalizeRound() external onlyWhitelisted {
746         require(state == State.Rewarding, "The round must be in 'Rewarding' state");
747         isAllWinnersRewarded();
748 
749         //vault leftover moves the funds to the dev funds wallet
750         vault.close();
751 
752         state = State.Closed;
753         emit Finalize(rewardCount);
754     }
755 
756     function isContract(address _address) internal view returns (bool) {
757         uint size;
758         assembly { size := extcodesize(_address) }
759         return size > 0;
760     }
761 
762     function isClosed() public view returns (bool){
763         return state == State.Closed;
764     }
765 
766     function isAllWinnersRewarded() public view returns (bool){
767         return winnerCount == rewardCount;
768     }
769 
770     function getVault() public view returns (RoundVault) {
771         return vault;
772     }
773 
774     function getDevWallet() public view returns (address) {
775         return vault.getWallet();
776     }
777 
778     function setRoundSwapLimit(uint256 _newLimit) external onlyWhitelisted {
779         roundSwapLimit = _newLimit;
780     }
781 
782 
783 }