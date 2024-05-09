1 pragma solidity 0.5.9;
2 
3 
4 /**
5  * https://rekt.fyi
6  *
7  * Mock the performance of your friend's ETH stack by sending them a REKT token, and add a bounty to it.
8  *
9  * REKT tokens are non-transferrable. Holders can only burn the token and collect the bounty once their
10  * ETH balance is m times higher or their ETH is worth m times more in USD than when they received the
11  * token, where m is a multiplier value set by users.
12  *
13  * copyright 2019 rekt.fyi
14  *
15  * This program is free software: you can redistribute it and/or modify
16  * it under the terms of the GNU General Public License as published by
17  * the Free Software Foundation, either version 3 of the License, or
18  * (at your option) any later version.
19  *
20  * This program is distributed in the hope that it will be useful,
21  * but WITHOUT ANY WARRANTY; without even the implied warranty of
22  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
23  * GNU General Public License for more details.
24  *
25  * You should have received a copy of the GNU General Public License
26  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
27  */
28 
29 
30 /**
31  * Libraries
32  */
33 
34 /// math.sol -- mixin for inline numerical wizardry
35 
36 // This program is free software: you can redistribute it and/or modify
37 // it under the terms of the GNU General Public License as published by
38 // the Free Software Foundation, either version 3 of the License, or
39 // (at your option) any later version.
40 
41 // This program is distributed in the hope that it will be useful,
42 // but WITHOUT ANY WARRANTY; without even the implied warranty of
43 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
44 // GNU General Public License for more details.
45 
46 // You should have received a copy of the GNU General Public License
47 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
48 
49 library DSMath {
50     function add(uint x, uint y) internal pure returns (uint z) {
51         require((z = x + y) >= x);
52     }
53     function sub(uint x, uint y) internal pure returns (uint z) {
54         require((z = x - y) <= x);
55     }
56     function mul(uint x, uint y) internal pure returns (uint z) {
57         require(y == 0 || (z = x * y) / y == x);
58     }
59 
60     function min(uint x, uint y) internal pure returns (uint z) {
61         return x <= y ? x : y;
62     }
63     function max(uint x, uint y) internal pure returns (uint z) {
64         return x >= y ? x : y;
65     }
66     function imin(int x, int y) internal pure returns (int z) {
67         return x <= y ? x : y;
68     }
69     function imax(int x, int y) internal pure returns (int z) {
70         return x >= y ? x : y;
71     }
72 
73     uint constant WAD = 10 ** 18;
74     uint constant RAY = 10 ** 27;
75 
76     function wmul(uint x, uint y) internal pure returns (uint z) {
77         z = add(mul(x, y), WAD / 2) / WAD;
78     }
79     function rmul(uint x, uint y) internal pure returns (uint z) {
80         z = add(mul(x, y), RAY / 2) / RAY;
81     }
82     function wdiv(uint x, uint y) internal pure returns (uint z) {
83         z = add(mul(x, WAD), y / 2) / y;
84     }
85     function rdiv(uint x, uint y) internal pure returns (uint z) {
86         z = add(mul(x, RAY), y / 2) / y;
87     }
88 
89     // This famous algorithm is called "exponentiation by squaring"
90     // and calculates x^n with x as fixed-point and n as regular unsigned.
91     //
92     // It's O(log n), instead of O(n) for naive repeated multiplication.
93     //
94     // These facts are why it works:
95     //
96     //  If n is even, then x^n = (x^2)^(n/2).
97     //  If n is odd,  then x^n = x * x^(n-1),
98     //   and applying the equation for even x gives
99     //    x^n = x * (x^2)^((n-1) / 2).
100     //
101     //  Also, EVM division is flooring and
102     //    floor[(n-1) / 2] = floor[n / 2].
103     //
104     function rpow(uint x, uint n) internal pure returns (uint z) {
105         z = n % 2 != 0 ? x : RAY;
106 
107         for (n /= 2; n != 0; n /= 2) {
108             x = rmul(x, x);
109 
110             if (n % 2 != 0) {
111                 z = rmul(z, x);
112             }
113         }
114     }
115 }
116 
117 /**
118  * External Contracts
119  */
120 
121 contract Medianizer {
122     function peek() public view returns (bytes32, bool) {}
123 }
124 
125 contract Dai {
126      function transferFrom(address src, address dst, uint wad) public returns (bool) {}
127 }
128 
129 
130 /**
131  * Contracts
132  */
133 
134 
135 /**
136  * @title Ownable
137  * @dev The Ownable contract has an owner address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Ownable {
141     address public owner;
142 
143 
144     event OwnershipRenounced(address indexed previousOwner);
145     event OwnershipTransferred(
146         address indexed previousOwner,
147         address indexed newOwner
148     );
149 
150 
151     /**
152     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153     * account.
154     */
155     constructor() public {
156         owner = msg.sender;
157     }
158 
159     /**
160     * @dev Throws if called by any account other than the owner.
161     */
162     modifier onlyOwner() {
163         require(msg.sender == owner);
164         _;
165     }
166 
167     /**
168     * @dev Allows the current owner to relinquish control of the contract.
169     * @notice Renouncing to ownership will leave the contract without an owner.
170     * It will not be possible to call the functions with the `onlyOwner`
171     * modifier anymore.
172     */
173     function renounceOwnership() public onlyOwner {
174         emit OwnershipRenounced(owner);
175         owner = address(0);
176     }
177 
178     /**
179     * @dev Allows the current owner to transfer control of the contract to a newOwner.
180     * @param _newOwner The address to transfer ownership to.
181     */
182     function transferOwnership(address _newOwner) public onlyOwner {
183         _transferOwnership(_newOwner);
184     }
185 
186     /**
187     * @dev Transfers control of the contract to a newOwner.
188     * @param _newOwner The address to transfer ownership to.
189     */
190     function _transferOwnership(address _newOwner) internal {
191         require(_newOwner != address(0));
192         emit OwnershipTransferred(owner, _newOwner);
193         owner = _newOwner;
194     }
195 }
196 
197 
198 /**
199  * @title https://rekt.fyi
200  * @notice Mock the performance of your friend's ETH stack by sending them a REKT token, and add a bounty to it.
201  *
202  * REKT tokens are non-transferrable. Holders can only burn the token and collect the bounty once their
203  * ETH balance is m times higher or their ETH is worth m times more in USD than when they received the
204  * token, where m is a multiplier value set by users.
205  */
206 contract RektFyi is Ownable {
207 
208     using DSMath for uint;
209 
210     /**
211      * Storage
212      */
213 
214     struct Receiver {
215         uint walletBalance;
216         uint bountyETH;
217         uint bountyDAI;
218         uint timestamp;
219         uint etherPrice;
220         address payable sender;
221     }
222 
223     struct Vault {
224         uint fee;
225         uint bountyETH;
226         uint bountySAI; // DAI bounty sent here before the switch to MCD
227         uint bountyDAI; // DAI bounty sent here after the switch to MCD
228     }
229 
230     struct Pot {
231         uint ETH;
232         uint DAI;
233     }
234 
235 
236     mapping(address => Receiver) public receiver;
237     mapping(address => uint) public balance;
238     mapping(address => address[]) private recipients;
239     mapping(address => Pot) public unredeemedBounty;
240     mapping(address => Vault) public vault;
241     Pot public bountyPot = Pot(0,0);
242     uint public feePot = 0;
243 
244     bool public shutdown = false;
245     uint public totalSupply = 0;
246     uint public multiplier = 1300000000000000000; // 1.3x to start
247     uint public bumpBasePrice = 10000000000000000; // 0.01 ETH
248     uint public holdTimeCeiling = 3628800; // 6 weeks in seconds
249 
250     address public medianizerAddress;
251     Medianizer oracle;
252 
253     bool public isMCD = false;
254     uint public MCDswitchTimestamp = 0;
255     address public saiAddress;
256     address public daiAddress;
257 
258     Dai dai;
259     Dai sai;
260 
261 
262     constructor(address _medianizerAddress, address _saiAddress) public {
263         medianizerAddress = _medianizerAddress;
264         oracle = Medianizer(medianizerAddress);
265 
266         saiAddress = _saiAddress;
267         dai = Dai(saiAddress);
268         sai = dai;
269     }
270 
271 
272     /**
273      * Constants
274      */
275 
276     string public constant name = "REKT.fyi";
277     string public constant symbol = "REKT";
278     uint8 public constant decimals = 0;
279 
280     uint public constant WAD = 1000000000000000000;
281     uint public constant PRECISION = 100000000000000; // 4 orders of magnitude / decimal places
282     uint public constant MULTIPLIER_FLOOR = 1000000000000000000; // 1x
283     uint public constant MULTIPLIER_CEILING = 10000000000000000000; // 10x
284     uint public constant BONUS_FLOOR = 1250000000000000000; //1.25x 
285     uint public constant BONUS_CEILING = 1800000000000000000; //1.8x
286     uint public constant BOUNTY_BONUS_MINIMUM = 5000000000000000000; // $5
287     uint public constant HOLD_SCORE_CEILING = 1000000000000000000000000000; // 1 RAY
288     uint public constant BUMP_INCREMENT = 100000000000000000; // 0.1x
289     uint public constant HOLD_TIME_MAX = 23670000; // 9 months is the maximum the owner can set with setHoldTimeCeiling(uint)
290     uint public constant BUMP_PRICE_MAX = 100000000000000000; //0.1 ETH is the maximum the owner can set with setBumpPrice(uint)
291 
292 
293     /**
294      * Events
295      */
296 
297     event LogVaultDeposit(address indexed addr, string indexed potType, uint value);
298     event LogWithdraw(address indexed to, uint eth, uint sai, uint dai);
299     event Transfer(address indexed from, address indexed to, uint tokens);
300     event LogBump(uint indexed from, uint indexed to, uint cost, address indexed by);
301     event LogBurn(
302         address indexed sender,
303         address indexed receiver,
304         uint receivedAt,
305         uint multiplier,
306         uint initialETH,
307         uint etherPrice,
308         uint bountyETH,
309         uint bountyDAI,
310         uint reward
311         );
312     event LogGive(address indexed sender, address indexed receiver);
313 
314 
315     /**
316      * Modifiers
317      */
318 
319     modifier shutdownNotActive() {
320         require(shutdown == false, "shutdown activated");
321         _;
322     }
323 
324 
325     modifier giveRequirementsMet(address _to) {
326         require(address(_to) != address(0), "Invalid address");
327         require(_to != msg.sender, "Cannot give to yourself");
328         require(balanceOf(_to) == 0, "Receiver already has a token");
329         require(_to.balance > 0, "Receiver wallet must not be empty");
330         _;
331     }
332 
333 
334     /**
335      * External functions
336      */
337 
338     /// @notice Give somebody a REKT token, along with an optional bounty in ether.
339     /// @param _to The address to send the REKT token to.
340     function give(address _to) external payable shutdownNotActive giveRequirementsMet(_to) {
341         if (msg.value > 0) {
342             unredeemedBounty[msg.sender].ETH = unredeemedBounty[msg.sender].ETH.add(msg.value);
343             bountyPot.ETH = bountyPot.ETH.add(msg.value);
344         }
345         receiver[_to] = Receiver(_to.balance, msg.value, 0, now, getPrice(), msg.sender);
346         giveCommon(_to);
347     }
348 
349 
350     /// @notice Give somebody a REKT token, along with an option bounty in DAI.
351     /// @param _to The account to send the REKT token to.
352     /// @param _amount The amount of DAI to use as a bounty.
353     function giveWithDAI(address _to, uint _amount) external shutdownNotActive giveRequirementsMet(_to) {
354         if (_amount > 0) {
355             // If the switch has already been included in this block then MCD is active,
356             // but we won't be able to tell later if that's the case so block this tx.
357             // Its ok for the mcd switch to occur later than this function in the same block
358             require(MCDswitchTimestamp != now, "Cannot send DAI during the switching block");
359             require(dai.transferFrom(msg.sender, address(this), _amount), "DAI transfer failed");
360             unredeemedBounty[msg.sender].DAI = unredeemedBounty[msg.sender].DAI.add(_amount);
361             bountyPot.DAI = bountyPot.DAI.add(_amount);
362         }
363         receiver[_to] = Receiver(_to.balance, 0, _amount, now, getPrice(), msg.sender);
364         giveCommon(_to);
365     }
366 
367 
368     /// @notice Bump the multiplier up or down.
369     /// @dev Multiplier has PRECISION precision and is rounded down unless the unrounded
370     /// value hits the MULTIPLIER_CEILING or MULTIPLIER_FLOOR.
371     /// @param _up Boolean representing whether the direction of the bump is up or not.
372     function bump(bool _up) external payable shutdownNotActive {
373         require(msg.value > 0, "Ether required");
374         uint initialMultiplier = multiplier;
375 
376         // amount = (value/price)*bonus*increment
377         uint bumpAmount = msg.value
378             .wdiv(bumpBasePrice)
379             .wmul(getBonusMultiplier(msg.sender))
380             .wmul(BUMP_INCREMENT);
381 
382         if (_up) {
383             if (multiplier.add(bumpAmount) >= MULTIPLIER_CEILING) {
384                 multiplier = MULTIPLIER_CEILING;
385             } else {
386                 multiplier = multiplier.add(roundBumpAmount(bumpAmount));
387             }
388         }
389         else {
390             if (multiplier > bumpAmount) {
391                 if (multiplier.sub(bumpAmount) <= MULTIPLIER_FLOOR) {
392                     multiplier = MULTIPLIER_FLOOR;
393                 } else {
394                     multiplier = multiplier.sub(roundBumpAmount(bumpAmount));
395                 }
396             }
397             else {
398                 multiplier = MULTIPLIER_FLOOR;
399             }
400         }
401 
402         emit LogBump(initialMultiplier, multiplier, msg.value, msg.sender);
403         feePot = feePot.add(msg.value);
404     }
405 
406 
407     /// @notice Burn a REKT token. If applicable, fee reward and bounty are sent to user's pots.
408     /// REKT tokens can only be burned if the receiver has made gains >= the multiplier
409     /// (unless we are in shutdown mode).
410     /// @param _receiver The account that currently holds the REKT token.
411     function burn(address _receiver) external {
412         require(balanceOf(_receiver) == 1, "Nothing to burn");
413         address sender = receiver[_receiver].sender;
414         require(
415             msg.sender == _receiver ||
416             msg.sender == sender ||
417             (_receiver == address(this) && msg.sender == owner),
418             "Must be token sender or receiver, or must be the owner burning REKT sent to the contract"
419             );
420 
421         if (!shutdown) {
422             if (receiver[_receiver].walletBalance.wmul(multiplier) > _receiver.balance) {
423                 uint balanceValueThen = receiver[_receiver].walletBalance.wmul(receiver[_receiver].etherPrice);
424                 uint balanceValueNow = _receiver.balance.wmul(getPrice());
425                 if (balanceValueThen.wmul(multiplier) > balanceValueNow) {
426                     revert("Not enough gains");
427                 }
428             }
429         }
430 
431         balance[_receiver] = 0;
432         totalSupply --;
433         
434         emit Transfer(_receiver, address(0), 1);
435 
436         uint feeReward = distributeBurnRewards(_receiver, sender);
437 
438         emit LogBurn(
439             sender,
440             _receiver,
441             receiver[_receiver].timestamp,
442             multiplier,
443             receiver[_receiver].walletBalance,
444             receiver[_receiver].etherPrice,
445             receiver[_receiver].bountyETH,
446             receiver[_receiver].bountyDAI,
447             feeReward);
448     }
449 
450 
451     /// @notice Withdrawal of fee reward, DAI, SAI & ETH bounties for the user.
452     /// @param _addr The account to receive the funds and whose vault the funds will be taken from.
453     function withdraw(address payable _addr) external {
454         require(_addr != address(this), "This contract cannot withdraw to itself");
455         withdrawCommon(_addr, _addr);
456     }
457 
458 
459     /// @notice Withdraw from the contract's personal vault should anyone send
460     /// REKT to REKT.fyi with a bounty.
461     /// @param _destination The account to receive the funds.
462     function withdrawSelf(address payable _destination) external onlyOwner {
463         withdrawCommon(_destination, address(this));
464     }
465 
466 
467     /// @dev Sets a new Medianizer address in case of MakerDAO upgrades.
468     /// @param _addr The new address.
469     function setNewMedianizer(address _addr) external onlyOwner {
470         require(address(_addr) != address(0), "Invalid address");
471         medianizerAddress = _addr;
472         oracle = Medianizer(medianizerAddress);
473         bytes32 price;
474         bool ok;
475         (price, ok) = oracle.peek();
476         require(ok, "Pricefeed error");
477     }
478 
479 
480     /// @notice Sets a new DAI token address when MakerDAO upgrades to multicollateral DAI.
481     /// @dev DAI will now be deposited into vault[user].bountyDAI for new bounties instead
482     /// of vault[user].bountySAI.
483     /// If setMCD(address) has been included in the block already, then a user will
484     /// not be able to give a SAI/DAI bounty later in this block.
485     /// We can then determine with certainty whether they sent SAI or DAI when the time
486     /// comes to distribute it to a user's vault.
487     /// New DAI token can only be set once;
488     /// further changes will require shutdown and redeployment.
489     /// @param _addr The new address.
490     function setMCD(address _addr) external onlyOwner {
491         require(!isMCD, "MCD has already been set");
492         require(address(_addr) != address(0), "Invalid address");
493         daiAddress = _addr;
494         dai = Dai(daiAddress);
495         isMCD = true;
496         MCDswitchTimestamp = now;
497     }
498 
499 
500     /// @dev Sets a new bump price up to BUMP_PRICE_MAX.
501     /// @param _amount The base price of bumping by BUMP_INCREMENT.
502     function setBumpPrice(uint _amount) external onlyOwner {
503         require(_amount > 0 && _amount <= BUMP_PRICE_MAX, "Price must not be higher than BUMP_PRICE_MAX");
504         bumpBasePrice = _amount;
505     }
506 
507 
508     /// @dev Sets a new hold time ceiling up to HOLD_TIME_MAX.
509     /// @param _seconds The maximum hold time in seconds before the holdscore becomes 1 RAY.
510     function setHoldTimeCeiling(uint _seconds) external onlyOwner {
511         require(_seconds > 0 && _seconds <= HOLD_TIME_MAX, "Hold time must not be higher than HOLD_TIME_MAX");
512         holdTimeCeiling = _seconds;
513     }
514     
515 
516     /// @dev Permanent shutdown of the contract.
517     /// No one can give or bump, everyone can burn and withdraw.
518     function setShutdown() external onlyOwner {
519         shutdown = true;
520     }
521 
522 
523     /**
524      * Public functions
525      */
526 
527     /// @dev The proportion of the value of this bounty in relation to
528     /// the value of all bounties in the system.
529     /// @param _bounty This bounty.
530     /// @return A uint representing the proportion of bounty as a RAY.
531     function calculateBountyProportion(uint _bounty) public view returns (uint) {
532         return _bounty.rdiv(potValue(bountyPot.DAI, bountyPot.ETH));
533     }
534 
535 
536     /// @dev A score <= 1 RAY that corresponds to a duration between 0 and HOLD_SCORE_CEILING.
537     /// @params _receivedAtTime The timestamp of the block where the user received the REKT token.
538     /// @return A uint representing the score as a RAY.
539     function calculateHoldScore(uint _receivedAtTime) public view returns (uint) {
540         if (now == _receivedAtTime)
541         {
542             return 0;
543         }
544         uint timeDiff = now.sub(_receivedAtTime);
545         uint holdScore = timeDiff.rdiv(holdTimeCeiling);
546         if (holdScore > HOLD_SCORE_CEILING) {
547             holdScore = HOLD_SCORE_CEILING;
548         }
549         return holdScore;
550     }
551 
552 
553     /// @notice Returns the REKT balance of the specified address.
554     /// @dev Effectively a bool because the balance can only be 0 or 1.
555     /// @param _owner The address to query the balance of.
556     /// @return A uint representing the amount owned by the passed address.
557     function balanceOf(address _receiver) public view returns (uint) {
558         return balance[_receiver];
559     }
560 
561 
562     /// @notice Returns the total value of _dai and _eth in USD. 1 DAI = $1 is assumed.
563     /// @dev Price of ether taken from MakerDAO's Medianizer via getPrice().
564     /// @param _dai DAI to use in calculation.
565     /// @param _eth Ether to use in calculation.
566     /// @return A uint representing the total value of the inputs.
567     function potValue(uint _dai, uint _eth) public view returns (uint) {
568         return _dai.add(_eth.wmul(getPrice()));
569     }
570 
571 
572     /// @dev Returns the bonus multiplier represented as a WAD.
573     /// @param _sender The address of the sender.
574     /// @return A uint representing the bonus multiplier as a WAD.
575     function getBonusMultiplier(address _sender) public view returns (uint) {
576         uint bounty = potValue(unredeemedBounty[_sender].DAI, unredeemedBounty[_sender].ETH);
577         uint bonus = WAD;
578         if (bounty >= BOUNTY_BONUS_MINIMUM) {
579             bonus = bounty.wdiv(potValue(bountyPot.DAI, bountyPot.ETH)).add(BONUS_FLOOR);
580             if (bonus > BONUS_CEILING) {
581                 bonus = BONUS_CEILING;
582             }
583         }
584         return bonus;
585     }
586 
587 
588     /// @dev Returns the addresses the sender has sent to as an array.
589     /// @param _sender The address of the sender.
590     /// @return An array of recipient addresses.
591     function getRecipients(address _sender) public view returns (address[] memory) {
592         return recipients[_sender];
593     }
594 
595 
596     /// @dev Returns the price of ETH in USD as per the MakerDAO Medianizer interface.
597     /// @return A uint representing the price of ETH in USD as a WAD.
598     function getPrice() public view returns (uint) {
599         bytes32 price;
600         bool ok;
601         (price, ok) = oracle.peek();
602         require(ok, "Pricefeed error");
603         return uint(price);
604     }
605 
606 
607     /**
608      * Private functions
609      */
610 
611     /// @dev Common functionality for give(address) and giveWithDAI(address, uint).
612     /// @param _to The account to send the REKT token to.
613     function giveCommon(address _to) private {
614         balance[_to] = 1;
615         recipients[msg.sender].push(_to);
616         totalSupply ++;
617         emit Transfer(address(0), msg.sender, 1);
618         emit Transfer(msg.sender, _to, 1);
619         emit LogGive(msg.sender, _to);
620     }
621 
622 
623     /// @dev Assigns rewards and bounties to pots within user vaults dependant on holdScore
624     /// and bounty proportion compared to the total bounties within the system.
625     /// @param _receiver The account that received the REKT token.
626     /// @param _sender The account that sent the REKT token.
627     /// @return A uint representing the fee reward.
628     function distributeBurnRewards(address _receiver, address _sender) private returns (uint feeReward) {
629 
630         feeReward = 0;
631 
632         uint bountyETH = receiver[_receiver].bountyETH;
633         uint bountyDAI = receiver[_receiver].bountyDAI;
634         uint bountyTotal = potValue(bountyDAI, bountyETH);
635 
636         if (bountyTotal > 0 ) {
637             uint bountyProportion = calculateBountyProportion(bountyTotal);
638             uint userRewardPot = bountyProportion.rmul(feePot);
639 
640             if (shutdown) {
641                 // in the shutdown state the holdscore isn't used
642                 feeReward = userRewardPot;
643             } else {
644                 uint holdScore = calculateHoldScore(receiver[_receiver].timestamp);
645                 feeReward = userRewardPot.rmul(holdScore);
646             }
647 
648             if (bountyETH > 0) {
649                 // subtract bounty from the senders's bounty total and the bounty pot
650                 unredeemedBounty[_sender].ETH = unredeemedBounty[_sender].ETH.sub(bountyETH);
651                 bountyPot.ETH = bountyPot.ETH.sub(bountyETH);
652 
653                 // add bounty to receivers vault
654                 vault[_receiver].bountyETH = vault[_receiver].bountyETH.add(bountyETH);
655                 emit LogVaultDeposit(_receiver, 'bountyETH', bountyETH);
656 
657             } else if (bountyDAI > 0) {
658                 unredeemedBounty[_sender].DAI = unredeemedBounty[_sender].DAI.sub(bountyDAI);
659                 bountyPot.DAI = bountyPot.DAI.sub(bountyDAI);
660                 if (isMCD && receiver[_receiver].timestamp > MCDswitchTimestamp) {
661                     vault[_receiver].bountyDAI = vault[_receiver].bountyDAI.add(bountyDAI);
662                 } else { // they would have sent SAI
663                     vault[_receiver].bountySAI = vault[_receiver].bountySAI.add(bountyDAI);
664                 }
665                 emit LogVaultDeposit(_receiver, 'bountyDAI', bountyDAI);
666             }
667 
668             if (feeReward > 0) {
669                 feeReward = feeReward / 2;
670 
671                 // subtract and add feeReward for receiver vault
672                 feePot = feePot.sub(feeReward);
673                 vault[_receiver].fee = vault[_receiver].fee.add(feeReward);
674                 emit LogVaultDeposit(_receiver, 'reward', feeReward);
675 
676                 // subtract and add feeReward for sender vault
677                 feePot = feePot.sub(feeReward);
678                 vault[_sender].fee = vault[_sender].fee.add(feeReward);
679                 emit LogVaultDeposit(_sender, 'reward', feeReward);
680             }
681         }
682 
683         return feeReward;
684     }
685 
686 
687     /// @dev Returns a rounded bump amount represented as a WAD.
688     /// @param _amount The amount to be rounded.
689     /// @return A uint representing the amount rounded to PRECISION as a WAD.
690     function roundBumpAmount(uint _amount) private pure returns (uint rounded) {
691         require(_amount >= PRECISION, "bump size too small to round");
692         return (_amount / PRECISION).mul(PRECISION);
693     }
694 
695 
696     /// @dev called by withdraw(address) and withdrawSelf(address) to withdraw
697     /// fee reward, DAI, SAI & ETH bounties.
698     /// Both params will be the same for a normal user withdrawal.
699     /// @param _destination The account to receive the funds.
700     /// @param _vaultOwner The vault that the funds will be taken from.
701     function withdrawCommon(address payable _destination, address _vaultOwner) private {
702         require(address(_destination) != address(0), "Invalid address");
703         uint amountETH = vault[_vaultOwner].fee.add(vault[_vaultOwner].bountyETH);
704         uint amountDAI = vault[_vaultOwner].bountyDAI;
705         uint amountSAI = vault[_vaultOwner].bountySAI;
706         vault[_vaultOwner] = Vault(0,0,0,0);
707         emit LogWithdraw(_destination, amountETH, amountSAI, amountDAI);
708         if (amountDAI > 0) {
709             require(dai.transferFrom(address(this), _destination, amountDAI), "DAI transfer failed");
710         }
711         if (amountSAI > 0) {
712             require(sai.transferFrom(address(this), _destination, amountSAI), "SAI transfer failed");
713         }
714         if (amountETH > 0) {
715             _destination.transfer(amountETH);
716         }
717     }
718 }