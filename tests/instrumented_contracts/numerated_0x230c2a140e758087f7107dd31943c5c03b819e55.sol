1 pragma solidity 0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 /**
76  * @title PausableOnce
77  * @dev The PausableOnce contract provides an option for the "pauseMaster"
78  * to pause once the transactions for two weeks.
79  *
80  */
81 
82 contract PausableOnce is Ownable {
83 
84     /** Address that can start the pause */
85     address public pauseMaster;
86 
87     uint constant internal PAUSE_DURATION = 14 days;
88     uint64 public pauseEnd = 0;
89 
90     event Paused();
91 
92     /**
93      * @dev Set the pauseMaster (callable by the owner only).
94      * @param _pauseMaster The address of the pauseMaster
95      */
96     function setPauseMaster(address _pauseMaster) onlyOwner external returns (bool success) {
97         require(_pauseMaster != address(0));
98         pauseMaster = _pauseMaster;
99         return true;
100     }
101 
102     /**
103      * @dev Start the pause (by the pauseMaster, ONCE only).
104      */
105     function pause() onlyPauseMaster external returns (bool success) {
106         require(pauseEnd == 0);
107         pauseEnd = uint64(now + PAUSE_DURATION);
108         Paused();
109         return true;
110     }
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is not paused.
114      */
115     modifier whenNotPaused() {
116         require(now > pauseEnd);
117         _;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the pauseMaster.
122      */
123     modifier onlyPauseMaster() {
124         require(msg.sender == pauseMaster);
125         _;
126     }
127 
128 }
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public constant returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   /**
152   * @dev transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158 
159     // SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     Transfer(msg.sender, _to, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Gets the balance of the specified address.
168   * @param _owner The address to query the the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171   function balanceOf(address _owner) public constant returns (uint256 balance) {
172     return balances[_owner];
173   }
174 
175 }
176 
177 /**
178  * @title ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/20
180  */
181 contract ERC20 is ERC20Basic {
182   function allowance(address owner, address spender) public constant returns (uint256);
183   function transferFrom(address from, address to, uint256 value) public returns (bool);
184   function approve(address spender, uint256 value) public returns (bool);
185   event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208 
209     uint256 _allowance = allowed[_from][msg.sender];
210 
211     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
212     // require (_value <= _allowance);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = _allowance.sub(_value);
217     Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
244     return allowed[_owner][_spender];
245   }
246 
247   /**
248    * approve should be called when allowed[_spender] == 0. To increment
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    */
253   function increaseApproval (address _spender, uint _addedValue)
254     returns (bool success) {
255     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   function decreaseApproval (address _spender, uint _subtractedValue)
261     returns (bool success) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 /**
275 * @title Upgrade agent interface
276 */
277 contract InterfaceUpgradeAgent {
278 
279     uint32 public revision;
280     uint256 public originalSupply;
281 
282     /**
283      * @dev Reissue the tokens onto the new contract revision.
284      * @param holder Holder (owner) of the tokens
285      * @param tokenQty How many tokens to be issued
286      */
287     function upgradeFrom(address holder, uint256 tokenQty) public;
288 }
289 
290 /**
291  * @title UpgradableToken
292  * @dev The UpgradableToken contract provides an option of upgrading the tokens to a new revision.
293  * The "upgradeMaster" may propose the upgrade. Token holders can opt-in amount of tokens to upgrade.
294  */
295 
296 contract UpgradableToken is StandardToken, Ownable {
297 
298     using SafeMath for uint256;
299 
300     uint32 public REVISION;
301 
302     /** Address that can set the upgrade agent thus enabling the upgrade. */
303     address public upgradeMaster = address(0);
304 
305     /** Address of the contract that issues the new revision tokens. */
306     address public upgradeAgent = address(0);
307 
308     /** How many tokens are upgraded. */
309     uint256 public totalUpgraded;
310 
311     event Upgrade(address indexed _from, uint256 _value);
312     event UpgradeEnabled(address agent);
313 
314     /**
315      * @dev Set the upgrade master.
316      * parameter _upgradeMaster Upgrade master
317      */
318     function setUpgradeMaster(address _upgradeMaster) onlyOwner external {
319         require(_upgradeMaster != address(0));
320         upgradeMaster = _upgradeMaster;
321     }
322 
323     /**
324      * @dev Set the upgrade agent (once only) thus enabling the upgrade.
325      * @param _upgradeAgent Upgrade agent contract address
326      * @param _revision Unique ID that agent contract must return on ".revision()"
327      */
328     function setUpgradeAgent(address _upgradeAgent, uint32 _revision)
329         onlyUpgradeMaster whenUpgradeDisabled external
330     {
331         require((_upgradeAgent != address(0)) && (_revision != 0));
332 
333         InterfaceUpgradeAgent agent = InterfaceUpgradeAgent(_upgradeAgent);
334 
335         require(agent.revision() == _revision);
336         require(agent.originalSupply() == totalSupply);
337 
338         upgradeAgent = _upgradeAgent;
339         UpgradeEnabled(_upgradeAgent);
340     }
341 
342     /**
343      * @dev Upgrade tokens to the new revision.
344      * @param value How many tokens to be upgraded
345      */
346     function upgrade(uint256 value) whenUpgradeEnabled external {
347         require(value > 0);
348 
349         uint256 balance = balances[msg.sender];
350         require(balance > 0);
351 
352         // Take tokens out from the old contract
353         balances[msg.sender] = balance.sub(value);
354         totalSupply = totalSupply.sub(value);
355         totalUpgraded = totalUpgraded.add(value);
356         // Issue the new revision tokens
357         InterfaceUpgradeAgent agent = InterfaceUpgradeAgent(upgradeAgent);
358         agent.upgradeFrom(msg.sender, value);
359 
360         Upgrade(msg.sender, value);
361     }
362 
363     /**
364     * @dev Modifier to make a function callable only when the upgrade is enabled.
365     */
366     modifier whenUpgradeEnabled() {
367         require(upgradeAgent != address(0));
368         _;
369     }
370 
371     /**
372     * @dev Modifier to make a function callable only when the upgrade is impossible.
373     */
374     modifier whenUpgradeDisabled() {
375         require(upgradeAgent == address(0));
376         _;
377     }
378 
379     /**
380     * @dev Throws if called by any account other than the upgradeMaster.
381     */
382     modifier onlyUpgradeMaster() {
383         require(msg.sender == upgradeMaster);
384         _;
385     }
386 
387 }
388 
389 /**
390  * @title Withdrawable
391  * @dev The Withdrawable contract provides a mechanism of withdrawal(s).
392  * "Withdrawals" are permissions for specified addresses to pull (withdraw) payments from the contract balance.
393  */
394 
395 contract Withdrawable {
396 
397     mapping (address => uint) pendingWithdrawals;
398 
399     /*
400      * @dev Logged upon a granted allowance to the specified drawer on withdrawal.
401      * @param drawer The address of the drawer.
402      * @param weiAmount The value in Wei which may be withdrawn.
403      */
404     event Withdrawal(address indexed drawer, uint256 weiAmount);
405 
406     /*
407      * @dev Logged upon a withdrawn value.
408      * @param drawer The address of the drawer.
409      * @param weiAmount The value in Wei which has been withdrawn.
410      */
411     event Withdrawn(address indexed drawer, uint256 weiAmount);
412 
413     /*
414      * @dev Allow the specified drawer to withdraw the specified value from the contract balance.
415      * @param drawer The address of the drawer.
416      * @param weiAmount The value in Wei allowed to withdraw.
417      * @return success
418      */
419     function setWithdrawal(address drawer, uint256 weiAmount) internal returns (bool success) {
420         if ((drawer != address(0)) && (weiAmount > 0)) {
421             uint256 oldBalance = pendingWithdrawals[drawer];
422             uint256 newBalance = oldBalance + weiAmount;
423             if (newBalance > oldBalance) {
424                 pendingWithdrawals[drawer] = newBalance;
425                 Withdrawal(drawer, weiAmount);
426                 return true;
427             }
428         }
429         return false;
430     }
431 
432     /*
433      * @dev Withdraw the allowed value from the contract balance.
434      * @return success
435      */
436     function withdraw() public returns (bool success) {
437         uint256 weiAmount = pendingWithdrawals[msg.sender];
438         require(weiAmount > 0);
439 
440         pendingWithdrawals[msg.sender] = 0;
441         msg.sender.transfer(weiAmount);
442         Withdrawn(msg.sender, weiAmount);
443         return true;
444     }
445 
446 }
447 
448 /**
449  * @title Cointed Token
450  * @dev Cointed Token (CTD) and Token Sale (ICO).
451  */
452 
453 contract CtdToken is UpgradableToken, PausableOnce, Withdrawable {
454 
455     using SafeMath for uint256;
456 
457     string public constant name = "Cointed Token";
458     string public constant symbol = "CTD";
459     /** Number of "Atom" in 1 CTD (1 CTD = 1x10^decimals Atom) */
460     uint8  public constant decimals = 18;
461 
462     /** Holder of bounty tokens */
463     address public bounty;
464 
465     /** Limit (in Atom) issued, inclusive owner's and bounty shares */
466     uint256 constant internal TOTAL_LIMIT   = 650000000 * (10 ** uint256(decimals));
467     /** Limit (in Atom) for Pre-ICO Phases A, incl. owner's and bounty shares */
468     uint256 constant internal PRE_ICO_LIMIT = 130000000 * (10 ** uint256(decimals));
469 
470     /**
471     * ICO Phases.
472     *
473     * - PreStart: tokens are not yet sold/issued
474     * - PreIcoA:  new tokens sold/issued at the premium price
475     * - PreIcoB:  new tokens sold/issued at the discounted price
476     * - MainIco   new tokens sold/issued at the regular price
477     * - AfterIco: new tokens can not be not be sold/issued any longer
478     */
479     enum Phases {PreStart, PreIcoA, PreIcoB, MainIco, AfterIco}
480 
481     uint64 constant internal PRE_ICO_DURATION = 745 hours;
482     uint64 constant internal ICO_DURATION = 2423 hours + 59 minutes;
483     uint64 constant internal RETURN_WEI_PAUSE = 30 days;
484 
485     // Main ICO rate in CTD(s) per 1 ETH:
486     uint256 constant internal TO_SENDER_RATE   = 1000;
487     uint256 constant internal TO_OWNER_RATE    =  263;
488     uint256 constant internal TO_BOUNTY_RATE   =   52;
489     uint256 constant internal TOTAL_RATE   =   TO_SENDER_RATE + TO_OWNER_RATE + TO_BOUNTY_RATE;
490     // Pre-ICO Phase A rate
491     uint256 constant internal TO_SENDER_RATE_A = 1150;
492     uint256 constant internal TO_OWNER_RATE_A  =  304;
493     uint256 constant internal TO_BOUNTY_RATE_A =   61;
494     uint256 constant internal TOTAL_RATE_A   =   TO_SENDER_RATE_A + TO_OWNER_RATE_A + TO_BOUNTY_RATE_A;
495     // Pre-ICO Phase B rate
496     uint256 constant internal TO_SENDER_RATE_B = 1100;
497     uint256 constant internal TO_OWNER_RATE_B  =  292;
498     uint256 constant internal TO_BOUNTY_RATE_B =   58;
499     uint256 constant internal TOTAL_RATE_B   =   TO_SENDER_RATE_B + TO_OWNER_RATE_B + TO_BOUNTY_RATE_B;
500 
501     // Award in Wei(s) to a successful initiator of a Phase shift
502     uint256 constant internal PRE_OPENING_AWARD = 100 * (10 ** uint256(15));
503     uint256 constant internal ICO_OPENING_AWARD = 200 * (10 ** uint256(15));
504     uint256 constant internal ICO_CLOSING_AWARD = 500 * (10 ** uint256(15));
505 
506     struct Rates {
507         uint256 toSender;
508         uint256 toOwner;
509         uint256 toBounty;
510         uint256 total;
511     }
512 
513     event NewTokens(uint256 amount);
514     event NewFunds(address funder, uint256 value);
515     event NewPhase(Phases phase);
516 
517     // current Phase
518     Phases public phase = Phases.PreStart;
519 
520     // Timestamps limiting duration of Phases, in seconds since Unix epoch.
521     uint64 public preIcoOpeningTime;  // when Pre-ICO Phase A starts
522     uint64 public icoOpeningTime;     // when Main ICO starts (if not sold out before)
523     uint64 public closingTime;        // by when the ICO campaign finishes in any way
524     uint64 public returnAllowedTime;  // when owner may withdraw Eth from contract, if any
525 
526     uint256 public totalProceeds;
527 
528     /*
529      * @dev constructor
530      * @param _preIcoOpeningTime Timestamp when the Pre-ICO (Phase A) shall start.
531      * msg.value MUST be at least the sum of awards.
532      */
533     function CtdToken(uint64 _preIcoOpeningTime) payable {
534         require(_preIcoOpeningTime > now);
535 
536         preIcoOpeningTime = _preIcoOpeningTime;
537         icoOpeningTime = preIcoOpeningTime + PRE_ICO_DURATION;
538         closingTime = icoOpeningTime + ICO_DURATION;
539     }
540 
541     /*
542      * @dev Fallback function delegates the request to create().
543      */
544     function () payable external {
545         create();
546     }
547 
548     /**
549      * @dev Set the address of the holder of bounty tokens.
550      * @param _bounty The address of the bounty token holder.
551      * @return success/failure
552      */
553     function setBounty(address _bounty) onlyOwner external returns (bool success) {
554         require(_bounty != address(0));
555         bounty = _bounty;
556         return true;
557     }
558 
559     /**
560      * @dev Mint tokens and add them to the balance of the message.sender.
561      * Additional tokens are minted and added to the owner and the bounty balances.
562      * @return success/failure
563      */
564     function create() payable whenNotClosed whenNotPaused public returns (bool success) {
565         require(msg.value > 0);
566         require(now >= preIcoOpeningTime);
567 
568         Phases oldPhase = phase;
569         uint256 weiToParticipate = msg.value;
570         uint256 overpaidWei;
571 
572         adjustPhaseBasedOnTime();
573 
574         if (phase != Phases.AfterIco) {
575 
576             Rates memory rates = getRates();
577             uint256 newTokens = weiToParticipate.mul(rates.total);
578             uint256 requestedSupply = totalSupply.add(newTokens);
579 
580             uint256 oversoldTokens = computeOversoldAndAdjustPhase(requestedSupply);
581             overpaidWei = (oversoldTokens > 0) ? oversoldTokens.div(rates.total) : 0;
582 
583             if (overpaidWei > 0) {
584                 weiToParticipate = msg.value.sub(overpaidWei);
585                 newTokens = weiToParticipate.mul(rates.total);
586                 requestedSupply = totalSupply.add(newTokens);
587             }
588 
589             // "emission" of new tokens
590             totalSupply = requestedSupply;
591             balances[msg.sender] = balances[msg.sender].add(weiToParticipate.mul(rates.toSender));
592             balances[owner] = balances[owner].add(weiToParticipate.mul(rates.toOwner));
593             balances[bounty] = balances[bounty].add(weiToParticipate.mul(rates.toBounty));
594 
595             // ETH transfers
596             totalProceeds = totalProceeds.add(weiToParticipate);
597             owner.transfer(weiToParticipate);
598             if (overpaidWei > 0) {
599                 setWithdrawal(msg.sender, overpaidWei);
600             }
601 
602             // Logging
603             NewTokens(newTokens);
604             NewFunds(msg.sender, weiToParticipate);
605 
606         } else {
607             setWithdrawal(msg.sender, msg.value);
608         }
609 
610         if (phase != oldPhase) {
611             logShiftAndBookAward();
612         }
613 
614         return true;
615     }
616 
617     /**
618      * @dev Send the value (ethers) that the contract holds to the owner address.
619      */
620     function returnWei() onlyOwner whenClosed afterWithdrawPause external {
621         owner.transfer(this.balance);
622     }
623 
624     function adjustPhaseBasedOnTime() internal {
625 
626         if (now >= closingTime) {
627             if (phase != Phases.AfterIco) {
628                 phase = Phases.AfterIco;
629             }
630         } else if (now >= icoOpeningTime) {
631             if (phase != Phases.MainIco) {
632                 phase = Phases.MainIco;
633             }
634         } else if (phase == Phases.PreStart) {
635             setDefaultParamsIfNeeded();
636             phase = Phases.PreIcoA;
637         }
638     }
639 
640     function setDefaultParamsIfNeeded() internal {
641         if (bounty == address(0)) {
642             bounty = owner;
643         }
644         if (upgradeMaster == address(0)) {
645             upgradeMaster = owner;
646         }
647         if (pauseMaster == address(0)) {
648             pauseMaster = owner;
649         }
650     }
651 
652     function computeOversoldAndAdjustPhase(uint256 newTotalSupply) internal returns (uint256 oversoldTokens) {
653 
654         if ((phase == Phases.PreIcoA) &&
655             (newTotalSupply >= PRE_ICO_LIMIT)) {
656             phase = Phases.PreIcoB;
657             oversoldTokens = newTotalSupply.sub(PRE_ICO_LIMIT);
658 
659         } else if (newTotalSupply >= TOTAL_LIMIT) {
660             phase = Phases.AfterIco;
661             oversoldTokens = newTotalSupply.sub(TOTAL_LIMIT);
662 
663         } else {
664             oversoldTokens = 0;
665         }
666 
667         return oversoldTokens;
668     }
669 
670     function getRates() internal returns (Rates rates) {
671 
672         if (phase == Phases.PreIcoA) {
673             rates.toSender = TO_SENDER_RATE_A;
674             rates.toOwner = TO_OWNER_RATE_A;
675             rates.toBounty = TO_BOUNTY_RATE_A;
676             rates.total = TOTAL_RATE_A;
677         } else if (phase == Phases.PreIcoB) {
678             rates.toSender = TO_SENDER_RATE_B;
679             rates.toOwner = TO_OWNER_RATE_B;
680             rates.toBounty = TO_BOUNTY_RATE_B;
681             rates.total = TOTAL_RATE_B;
682         } else {
683             rates.toSender = TO_SENDER_RATE;
684             rates.toOwner = TO_OWNER_RATE;
685             rates.toBounty = TO_BOUNTY_RATE;
686             rates.total = TOTAL_RATE;
687         }
688         return rates;
689     }
690 
691     function logShiftAndBookAward() internal {
692         uint256 shiftAward;
693 
694         if ((phase == Phases.PreIcoA) || (phase == Phases.PreIcoB)) {
695             shiftAward = PRE_OPENING_AWARD;
696 
697         } else if (phase == Phases.MainIco) {
698             shiftAward = ICO_OPENING_AWARD;
699 
700         } else {
701             shiftAward = ICO_CLOSING_AWARD;
702             returnAllowedTime = uint64(now + RETURN_WEI_PAUSE);
703         }
704 
705         setWithdrawal(msg.sender, shiftAward);
706         NewPhase(phase);
707     }
708 
709     /**
710      * @dev Transfer tokens to the specified address.
711      * @param _to The address to transfer to.
712      * @param _value The amount of tokens to be transferred.
713      * @return success/failure
714      */
715     function transfer(address _to, uint256 _value)
716         whenNotPaused limitForOwner public returns (bool success)
717     {
718         return super.transfer(_to, _value);
719     }
720 
721     /**
722      * @dev Transfer tokens from one address to another.
723      * @param _from address The address which you want to send tokens from.
724      * @param _to address The address which you want to transfer to.
725      * @param _value the amount of tokens to be transferred.
726      * @return success/failure
727      */
728     function transferFrom(address _from, address _to, uint256 _value)
729         whenNotPaused limitForOwner public returns (bool success)
730     {
731         return super.transferFrom(_from, _to, _value);
732     }
733 
734     /**
735      * @dev Approve the specified address to spend the specified amount of tokens on behalf of the msg.sender.
736      * Use "increaseApproval" or "decreaseApproval" function to change the approval, if needed.
737      * @param _spender The address which will spend the funds.
738      * @param _value The amount of tokens to be spent.
739      * @return success/failure
740      */
741     function approve(address _spender, uint256 _value)
742         whenNotPaused limitForOwner public returns (bool success)
743     {
744         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
745         return super.approve(_spender, _value);
746     }
747 
748     /**
749      * @dev Increase the approval for the passed address to spend tokens on behalf of the msg.sender.
750      * @param _spender The address which will spend the funds.
751      * @param _addedValue The amount of tokens to increase the approval with.
752      * @return success/failure
753      */
754     function increaseApproval(address _spender, uint _addedValue)
755         whenNotPaused limitForOwner public returns (bool success)
756     {
757         return super.increaseApproval(_spender, _addedValue);
758     }
759 
760     /**
761      * @dev Decrease the approval for the passed address to spend tokens on behalf of the msg.sender.
762      * @param _spender The address which will spend the funds.
763      * @param _subtractedValue The amount of tokens to decrease the approval with.
764      * @return success/failure
765      */
766     function decreaseApproval(address _spender, uint _subtractedValue)
767         whenNotPaused limitForOwner public returns (bool success)
768     {
769         return super.decreaseApproval(_spender, _subtractedValue);
770     }
771 
772     /*
773      * @dev Withdraw the allowed value (ethers) from the contract balance.
774      * @return success/failure
775      */
776     function withdraw() whenNotPaused public returns (bool success) {
777         return super.withdraw();
778     }
779 
780     /**
781      * @dev Throws if called when ICO is active.
782      */
783     modifier whenClosed() {
784         require(phase == Phases.AfterIco);
785         _;
786     }
787 
788     /**
789      * @dev Throws if called when ICO is completed.
790      */
791     modifier whenNotClosed() {
792         require(phase != Phases.AfterIco);
793         _;
794     }
795 
796     /**
797      * @dev Throws if called by the owner before ICO is completed.
798      */
799     modifier limitForOwner() {
800         require((msg.sender != owner) || (phase == Phases.AfterIco));
801         _;
802     }
803 
804     /**
805      * @dev Throws if called before returnAllowedTime.
806      */
807     modifier afterWithdrawPause() {
808         require(now > returnAllowedTime);
809         _;
810     }
811 
812 }