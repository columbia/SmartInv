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
449  * @title Savior Token
450  * @dev Savior Token (SAVI) and Token Sale (ICO).
451  */
452 
453 contract SaviorToken is UpgradableToken, PausableOnce, Withdrawable {
454 
455     using SafeMath for uint256;
456 
457     string public constant name = "Savior Token";
458     string public constant symbol = "SAVI";
459     /** Number of "Atom" in 1 SAVI (1 SAVI = 1x18^decimals Atom) */
460     uint8  public constant decimals = 18;
461 
462     /** Holder of bounty tokens */
463     address public bounty;
464 
465     /** Limit (in Atom) issued, inclusive owner's and bounty shares */
466     uint256 constant internal TOTAL_LIMIT   = 100000000 * (10 ** uint256(decimals));
467     /** Limit (in Atom) for Pre-ICO Phase A, B and C, incl. owner's and bounty shares */
468     uint256 constant internal PRE_ICO_LIMIT = 10000000 * (10 ** uint256(decimals));
469 
470     /**
471     * ICO Phases.
472     *
473     * - PreStart: tokens are not yet sold/issued
474     * - PreIcoA:  new tokens sold/issued with a bonus rate of 40%
475     * - PreIcoB:  new tokens sold/issued with a bonus rate of 30%
476     * - PreIcoC:  new tokens sold/issued with a bonus rate of 20%
477     * - MainIcoA   new tokens sold/issued with a bonus rate of 10%
478     * - MainIcoB   new tokens sold/issued with a bonus rate of 5%
479     * - MainIcoC   new tokens sold/issued with a bonus rate of 0%
480     * - AfterIco: new tokens can not be not be sold/issued any longer
481     */
482     
483     enum Phases {PreStart, PreIcoA, PreIcoB, PreIcoC, MainIcoA, MainIcoB, MainIcoC, AfterIco}
484 
485     uint64 constant internal PRE_ICO_DURATION_A = 72 hours;
486     uint64 constant internal PRE_ICO_DURATION_B = 240 hours;
487     uint64 constant internal PRE_ICO_DURATION_C = 408 hours;
488     uint64 constant internal ICO_DURATION_A = 168 hours;
489     uint64 constant internal ICO_DURATION_B = 168 hours;
490     uint64 constant internal ICO_DURATION_C = 1104 hours;
491 
492     uint64 constant internal PRE_ICO_DURATION = 720 hours;
493     uint64 constant internal ICO_DURATION = 1440 hours;
494     uint64 constant internal RETURN_WEI_PAUSE = 30 days;
495 
496     // Pre-ICO Phase A rate
497     uint256 constant internal PreICO_SENDER_RATE_A = 140;
498     uint256 constant internal PreICO_OWNER_RATE_A  =  10;
499     uint256 constant internal PreICO_BOUNTY_RATE_A =  10;
500     uint256 constant internal PreICO_TOTAL_RATE_A  =   PreICO_SENDER_RATE_A + PreICO_OWNER_RATE_A + PreICO_BOUNTY_RATE_A;
501     // Pre-ICO Phase B rate
502     uint256 constant internal PreICO_SENDER_RATE_B = 130;
503     uint256 constant internal PreICO_OWNER_RATE_B  =  10;
504     uint256 constant internal PreICO_BOUNTY_RATE_B =  10;
505     uint256 constant internal PreICO_TOTAL_RATE_B  =   PreICO_SENDER_RATE_B + PreICO_OWNER_RATE_B + PreICO_BOUNTY_RATE_B;
506     // Pre-ICO Phase C rate
507     uint256 constant internal PreICO_SENDER_RATE_C = 120;
508     uint256 constant internal PreICO_OWNER_RATE_C  =  10;
509     uint256 constant internal PreICO_BOUNTY_RATE_C =  10;
510     uint256 constant internal PreICO_TOTAL_RATE_C  =   PreICO_SENDER_RATE_C + PreICO_OWNER_RATE_C + PreICO_BOUNTY_RATE_C;
511 
512     // Pre-ICO Phase A rate
513     uint256 constant internal ICO_SENDER_RATE_A = 110;
514     uint256 constant internal ICO_OWNER_RATE_A  =  10;
515     uint256 constant internal ICO_BOUNTY_RATE_A =  10;
516     uint256 constant internal ICO_TOTAL_RATE_A  =   ICO_SENDER_RATE_A + ICO_OWNER_RATE_A + ICO_BOUNTY_RATE_A;
517     // Pre-ICO Phase B rate
518     uint256 constant internal ICO_SENDER_RATE_B = 105;
519     uint256 constant internal ICO_OWNER_RATE_B  =  10;
520     uint256 constant internal ICO_BOUNTY_RATE_B =  10;
521     uint256 constant internal ICO_TOTAL_RATE_B  =   ICO_SENDER_RATE_B + ICO_OWNER_RATE_B + ICO_BOUNTY_RATE_B;
522     // Pre-ICO Phase C rate
523     uint256 constant internal ICO_SENDER_RATE_C = 100;
524     uint256 constant internal ICO_OWNER_RATE_C  =  10;
525     uint256 constant internal ICO_BOUNTY_RATE_C =  10;
526     uint256 constant internal ICO_TOTAL_RATE_C  =   ICO_SENDER_RATE_C + ICO_OWNER_RATE_C + ICO_BOUNTY_RATE_C;
527 
528 	
529     struct Rates {
530         uint256 toSender;
531         uint256 toOwner;
532         uint256 toBounty;
533         uint256 total;
534     }
535 
536     event NewTokens(uint256 amount);
537     event NewFunds(address funder, uint256 value);
538     event NewPhase(Phases phase);
539 
540     // current Phase
541     Phases public phase = Phases.PreStart;
542 
543     // Timestamps limiting duration of Phases, in seconds since Unix epoch.
544     uint64 public preIcoOpeningTime;  // when Pre-ICO Phase A starts
545     uint64 public icoOpeningTime;     // when Main ICO Phase A starts (if not sold out before)
546     uint64 public closingTime;        // by when the ICO campaign finishes in any way
547     uint64 public returnAllowedTime;  // when owner may withdraw Eth from contract, if any
548 
549     uint256 public totalProceeds;
550 
551     /*
552      * @dev constructor
553      * @param _preIcoOpeningTime Timestamp when the Pre-ICO (Phase A) shall start.
554      * msg.value MUST be at least the sum of awards.
555      */
556     function SaviorToken(uint64 _preIcoOpeningTime) payable {
557         require(_preIcoOpeningTime > now);
558 
559         preIcoOpeningTime = _preIcoOpeningTime;
560         icoOpeningTime = preIcoOpeningTime + PRE_ICO_DURATION;
561         closingTime = icoOpeningTime + ICO_DURATION;
562     }
563 
564     /*
565      * @dev Fallback function delegates the request to create().
566      */
567     function () payable external {
568         create();
569     }
570 
571     /**
572      * @dev Set the address of the holder of bounty tokens.
573      * @param _bounty The address of the bounty token holder.
574      * @return success/failure
575      */
576     function setBounty(address _bounty, uint256 bountyTokens) onlyOwner external returns (bool success) {
577         require(_bounty != address(0));
578         bounty = _bounty;
579         
580         uint256 bounties = bountyTokens * 10**18;
581         
582         balances[bounty] = balances[bounty].add(bounties);
583         totalSupply = totalSupply.add(bounties);
584         
585         NewTokens(bounties);
586         return true;
587     }
588 
589     /**
590      * @dev Mint tokens and add them to the balance of the message.sender.
591      * Additional tokens are minted and added to the owner and the bounty balances.
592      * @return success/failure
593      */
594     function create() payable whenNotClosed whenNotPaused public returns (bool success) {
595         require(msg.value > 0);
596         require(now >= preIcoOpeningTime);
597 
598         uint256 weiToParticipate = msg.value;
599 
600         adjustPhaseBasedOnTime();
601 
602         if (phase != Phases.AfterIco || weiToParticipate < (0.01 * 10**18)) {
603 
604             Rates memory rates = getRates();
605             uint256 newTokens = weiToParticipate.mul(rates.total);
606             uint256 requestedSupply = totalSupply.add(newTokens);
607 
608             // "emission" of new tokens
609             totalSupply = requestedSupply;
610             balances[msg.sender] 	= balances[msg.sender].add(weiToParticipate.mul(rates.toSender));
611             balances[owner] 		= balances[owner].add(weiToParticipate.mul(rates.toOwner));
612             balances[bounty] 		= balances[bounty].add(weiToParticipate.mul(rates.toBounty));
613 
614             // ETH transfers
615             totalProceeds = totalProceeds.add(weiToParticipate);
616             
617             // Logging
618             NewTokens(newTokens);
619             NewFunds(msg.sender, weiToParticipate);
620 
621         } else {
622             setWithdrawal(owner, weiToParticipate);
623         }
624         return true;
625     }
626 
627     /**
628      * @dev Send the value (ethers) that the contract holds to the owner address.
629      */
630     function returnWei() onlyOwner external {
631         owner.transfer(this.balance);
632     }
633 
634     function adjustPhaseBasedOnTime() internal {
635 
636         if (now >= closingTime) {
637             if (phase != Phases.AfterIco) {
638                 phase = Phases.AfterIco;
639             }
640         } else if (now >= icoOpeningTime + ICO_DURATION_A + ICO_DURATION_B) {
641             if (phase != Phases.MainIcoC) {
642                 phase = Phases.MainIcoC;
643             }
644 		} else if (now >= icoOpeningTime + ICO_DURATION_A ) {
645             if (phase != Phases.MainIcoB) {
646                 phase = Phases.MainIcoB;
647             }
648         } else if (now >= icoOpeningTime ) {
649             if (phase != Phases.MainIcoA) {
650                 phase = Phases.MainIcoA;
651             }
652 		} else if (now >= preIcoOpeningTime + PRE_ICO_DURATION_A + PRE_ICO_DURATION_B) {
653             if (phase != Phases.PreIcoC) {
654                 phase = Phases.PreIcoC;
655             }
656 		} else if (now >= preIcoOpeningTime + PRE_ICO_DURATION_A ) {
657             if (phase != Phases.PreIcoB) {
658                 phase = Phases.PreIcoB;
659             }
660 		} else if (now >= preIcoOpeningTime ) {
661             if (phase != Phases.PreIcoA) {
662                 phase = Phases.PreIcoA;
663             }
664         } else if (phase == Phases.PreStart) {
665             setDefaultParamsIfNeeded();
666             phase = Phases.PreIcoA;
667         }
668     }
669 
670     function setDefaultParamsIfNeeded() internal {
671         if (bounty == address(0)) {
672             bounty = owner;
673         }
674         if (upgradeMaster == address(0)) {
675             upgradeMaster = owner;
676         }
677         if (pauseMaster == address(0)) {
678             pauseMaster = owner;
679         }
680     }
681 
682     function getRates() internal returns (Rates rates) {
683 		if (phase == Phases.PreIcoA) {
684             rates.toSender 	= PreICO_SENDER_RATE_A;
685             rates.toOwner 	= PreICO_OWNER_RATE_A;
686             rates.toBounty 	= PreICO_BOUNTY_RATE_A;
687             rates.total 	= PreICO_TOTAL_RATE_A;
688         } else if (phase == Phases.PreIcoB) {
689             rates.toSender 	= PreICO_SENDER_RATE_B;
690             rates.toOwner 	= PreICO_OWNER_RATE_B;
691             rates.toBounty 	= PreICO_BOUNTY_RATE_B;
692             rates.total 	= PreICO_TOTAL_RATE_B;
693         } else if (phase == Phases.PreIcoC) {
694             rates.toSender 	= PreICO_SENDER_RATE_C;
695             rates.toOwner 	= PreICO_OWNER_RATE_C;
696             rates.toBounty 	= PreICO_BOUNTY_RATE_C;
697             rates.total 	= PreICO_TOTAL_RATE_C;
698         } else if (phase == Phases.MainIcoA) {
699             rates.toSender 	= ICO_SENDER_RATE_A;
700             rates.toOwner 	= ICO_OWNER_RATE_A;
701             rates.toBounty 	= ICO_BOUNTY_RATE_A;
702             rates.total 	= ICO_TOTAL_RATE_A;
703         } else if (phase == Phases.MainIcoB) {
704             rates.toSender 	= ICO_SENDER_RATE_B;
705             rates.toOwner 	= ICO_OWNER_RATE_B;
706             rates.toBounty 	= ICO_BOUNTY_RATE_B;
707             rates.total 	= ICO_TOTAL_RATE_B;
708         } else {
709             rates.toSender 	= ICO_SENDER_RATE_C;
710             rates.toOwner 	= ICO_OWNER_RATE_C;
711             rates.toBounty 	= ICO_BOUNTY_RATE_C;
712             rates.total 	= ICO_TOTAL_RATE_C;
713         }
714         return rates;
715     }
716 
717     /**
718      * @dev Transfer tokens to the specified address.
719      * @param _to The address to transfer to.
720      * @param _value The amount of tokens to be transferred.
721      * @return success/failure
722      */
723     function transfer(address _to, uint256 _value)
724         whenNotPaused limitForOwner public returns (bool success)
725     {
726         return super.transfer(_to, _value);
727     }
728 
729     /**
730      * @dev Transfer tokens from one address to another.
731      * @param _from address The address which you want to send tokens from.
732      * @param _to address The address which you want to transfer to.
733      * @param _value the amount of tokens to be transferred.
734      * @return success/failure
735      */
736     function transferFrom(address _from, address _to, uint256 _value)
737         whenNotPaused limitForOwner public returns (bool success)
738     {
739         return super.transferFrom(_from, _to, _value);
740     }
741 
742     /**
743      * @dev Approve the specified address to spend the specified amount of tokens on behalf of the msg.sender.
744      * Use "increaseApproval" or "decreaseApproval" function to change the approval, if needed.
745      * @param _spender The address which will spend the funds.
746      * @param _value The amount of tokens to be spent.
747      * @return success/failure
748      */
749     function approve(address _spender, uint256 _value)
750         whenNotPaused limitForOwner public returns (bool success)
751     {
752         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
753         return super.approve(_spender, _value);
754     }
755 
756     /**
757      * @dev Increase the approval for the passed address to spend tokens on behalf of the msg.sender.
758      * @param _spender The address which will spend the funds.
759      * @param _addedValue The amount of tokens to increase the approval with.
760      * @return success/failure
761      */
762     function increaseApproval(address _spender, uint _addedValue)
763         whenNotPaused limitForOwner public returns (bool success)
764     {
765         return super.increaseApproval(_spender, _addedValue);
766     }
767 
768     /**
769      * @dev Decrease the approval for the passed address to spend tokens on behalf of the msg.sender.
770      * @param _spender The address which will spend the funds.
771      * @param _subtractedValue The amount of tokens to decrease the approval with.
772      * @return success/failure
773      */
774     function decreaseApproval(address _spender, uint _subtractedValue)
775         whenNotPaused limitForOwner public returns (bool success)
776     {
777         return super.decreaseApproval(_spender, _subtractedValue);
778     }
779 
780     /*
781      * @dev Withdraw the allowed value (ethers) from the contract balance.
782      * @return success/failure
783      */
784     function withdraw() whenNotPaused public returns (bool success) {
785         return super.withdraw();
786     }
787 
788     /**
789      * @dev Throws if called when ICO is active.
790      */
791     modifier whenClosed() {
792         require(phase == Phases.AfterIco);
793         _;
794     }
795 
796     /**
797      * @dev Throws if called when ICO is completed.
798      */
799     modifier whenNotClosed() {
800         require(phase != Phases.AfterIco);
801         _;
802     }
803 
804     /**
805      * @dev Throws if called by the owner before ICO is completed.
806      */
807     modifier limitForOwner() {
808         require((msg.sender != owner) || (phase == Phases.AfterIco));
809         _;
810     }
811 
812     /**
813      * @dev Throws if called before returnAllowedTime.
814      */
815     modifier afterWithdrawPause() {
816         require(now > returnAllowedTime);
817         _;
818     }
819 
820 }