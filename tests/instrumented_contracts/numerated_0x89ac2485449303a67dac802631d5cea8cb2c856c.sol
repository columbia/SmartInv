1 pragma solidity ^0.4.15;
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
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) returns (bool) {
60     require(_to != address(0));
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) returns (bool);
87   function approve(address spender, uint256 value) returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     require(_to != address(0));
111 
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue)
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue)
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title SimpleToken
181  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
182  * Note they can later distribute these tokens as they wish using `transfer` and other
183  * `StandardToken` functions.
184  */
185 contract OpportyToken is StandardToken {
186 
187   string public constant name = "OpportyToken";
188   string public constant symbol = "OPP";
189   uint8 public constant decimals = 18;
190 
191   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
192 
193   /**
194    * @dev Contructor that gives msg.sender all of existing tokens.
195    */
196   function OpportyToken() {
197     totalSupply = INITIAL_SUPPLY;
198     balances[msg.sender] = INITIAL_SUPPLY;
199   }
200 
201 }
202 
203 
204 /**
205  * @title Ownable
206  * @dev The Ownable contract has an owner address, and provides basic authorization control
207  * functions, this simplifies the implementation of "user permissions".
208  */
209 contract Ownable {
210   address public owner;
211 
212 
213   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   function Ownable() {
221     owner = msg.sender;
222   }
223 
224 
225   /**
226    * @dev Throws if called by any account other than the owner.
227    */
228   modifier onlyOwner() {
229     require(msg.sender == owner);
230     _;
231   }
232 
233 
234   /**
235    * @dev Allows the current owner to transfer control of the contract to a newOwner.
236    * @param newOwner The address to transfer ownership to.
237    */
238   function transferOwnership(address newOwner) onlyOwner public {
239     require(newOwner != address(0));
240     OwnershipTransferred(owner, newOwner);
241     owner = newOwner;
242   }
243 
244 }
245 
246 /**
247  * @title Pausable
248  * @dev Base contract which allows children to implement an emergency stop mechanism.
249  */
250 contract Pausable is Ownable {
251   event Pause();
252   event Unpause();
253 
254   bool public paused = false;
255 
256 
257   /**
258    * @dev Modifier to make a function callable only when the contract is not paused.
259    */
260   modifier whenNotPaused() {
261     require(!paused);
262     _;
263   }
264 
265   /**
266    * @dev Modifier to make a function callable only when the contract is paused.
267    */
268   modifier whenPaused() {
269     require(paused);
270     _;
271   }
272 
273   /**
274    * @dev called by the owner to pause, triggers stopped state
275    */
276   function pause() onlyOwner whenNotPaused public {
277     paused = true;
278     Pause();
279   }
280 
281   /**
282    * @dev called by the owner to unpause, returns to normal state
283    */
284   function unpause() onlyOwner whenPaused public {
285     paused = false;
286     Unpause();
287   }
288 }
289 
290 contract HoldPresaleContract is Ownable {
291   using SafeMath for uint256;
292   // Addresses and contracts
293   OpportyToken public OppToken;
294   address private presaleCont;
295 
296   struct Holder {
297     bool isActive;
298     uint tokens;
299     uint8 holdPeriod;
300     uint holdPeriodTimestamp;
301     bool withdrawed;
302   }
303 
304   mapping(address => Holder) public holderList;
305   mapping(uint => address) private holderIndexes;
306 
307   mapping (uint => address) private assetOwners;
308   mapping (address => uint) private assetOwnersIndex;
309   uint public assetOwnersIndexes;
310 
311   uint private holderIndex;
312 
313   event TokensTransfered(address contributor , uint amount);
314   event Hold(address sender, address contributor, uint amount, uint8 holdPeriod);
315 
316   modifier onlyAssetsOwners() {
317     require(assetOwnersIndex[msg.sender] > 0);
318     _;
319   }
320 
321   /* constructor */
322   function HoldPresaleContract(address _OppToken) {
323     OppToken = OpportyToken(_OppToken);
324   }
325 
326   function setPresaleCont(address pres)  public onlyOwner
327   {
328     presaleCont = pres;
329   }
330 
331   function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external {
332     if (holderList[holder].isActive == false) {
333       holderList[holder].isActive = true;
334       holderList[holder].tokens = tokens;
335       holderList[holder].holdPeriod = timed;
336       holderList[holder].holdPeriodTimestamp = timest;
337       holderIndexes[holderIndex] = holder;
338       holderIndex++;
339     } else {
340       holderList[holder].tokens += tokens;
341       holderList[holder].holdPeriod = timed;
342       holderList[holder].holdPeriodTimestamp = timest;
343     }
344     Hold(msg.sender, holder, tokens, timed);
345   }
346 
347   function getBalance() constant returns (uint) {
348     return OppToken.balanceOf(this);
349   }
350 
351   function unlockTokens() external {
352     address contributor = msg.sender;
353 
354     if (holderList[contributor].isActive && !holderList[contributor].withdrawed) {
355       if (now >= holderList[contributor].holdPeriodTimestamp) {
356         if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) {
357           holderList[contributor].withdrawed = true;
358           TokensTransfered(contributor,  holderList[contributor].tokens);
359         }
360       } else {
361         revert();
362       }
363     } else {
364       revert();
365     }
366   }
367 
368   function addAssetsOwner(address _owner) public onlyOwner {
369     assetOwnersIndexes++;
370     assetOwners[assetOwnersIndexes] = _owner;
371     assetOwnersIndex[_owner] = assetOwnersIndexes;
372   }
373   function removeAssetsOwner(address _owner) public onlyOwner {
374     uint index = assetOwnersIndex[_owner];
375     delete assetOwnersIndex[_owner];
376     delete assetOwners[index];
377     assetOwnersIndexes--;
378   }
379   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
380     return assetOwners[_index];
381   }
382 }
383 
384 contract OpportyPresale is Pausable {
385   using SafeMath for uint256;
386 
387   OpportyToken public token;
388 
389   HoldPresaleContract public holdContract;
390 
391   enum SaleState  { NEW, SALE, ENDED }
392   SaleState public state;
393 
394   uint public endDate;
395   uint public endSaleDate;
396 
397   // address where funds are collected
398   address private wallet;
399 
400   // total ETH collected
401   uint public ethRaised;
402 
403   uint private price;
404 
405   uint public tokenRaised;
406   bool public tokensTransferredToHold;
407 
408   /* Events */
409   event SaleStarted(uint blockNumber);
410   event SaleEnded(uint blockNumber);
411   event FundTransfered(address contrib, uint amount);
412   event WithdrawedEthToWallet(uint amount);
413   event ManualChangeEndDate(uint beforeDate, uint afterDate);
414   event TokensTransferedToHold(address hold, uint amount);
415   event AddedToWhiteList(address inv, uint amount, uint8 holdPeriod, uint8 bonus);
416   event AddedToHolder( address sender, uint tokenAmount, uint8 holdPeriod, uint holdTimestamp);
417 
418   struct WhitelistContributor {
419     bool isActive;
420     uint invAmount;
421     uint8 holdPeriod;
422     uint holdTimestamp;
423     uint8 bonus;
424     bool payed;
425   }
426 
427   mapping(address => WhitelistContributor) public whiteList;
428   mapping(uint => address) private whitelistIndexes;
429   uint private whitelistIndex;
430 
431   /* constructor */
432   function OpportyPresale(
433     address tokenAddress,
434     address walletAddress,
435     uint end,
436     uint endSale,
437     address holdCont )
438   {
439     token = OpportyToken(tokenAddress);
440     state = SaleState.NEW;
441 
442     endDate     = end;
443     endSaleDate = endSale;
444     price       = 0.0002 * 1 ether;
445     wallet      = walletAddress;
446 
447     holdContract = HoldPresaleContract(holdCont);
448   }
449 
450   function startPresale() public onlyOwner {
451     require(state == SaleState.NEW);
452     state = SaleState.SALE;
453     SaleStarted(block.number);
454   }
455 
456   function endPresale() public onlyOwner {
457     require(state == SaleState.SALE);
458     state = SaleState.ENDED;
459     SaleEnded(block.number);
460   }
461 
462   function addToWhitelist(address inv, uint amount, uint8 holdPeriod, uint8 bonus) public onlyOwner {
463     require(state == SaleState.NEW || state == SaleState.SALE);
464     require(holdPeriod == 1 || holdPeriod == 3 || holdPeriod == 6 || holdPeriod == 12);
465 
466     amount = amount * (10 ** 18);
467 
468     if (whiteList[inv].isActive == false) {
469       whiteList[inv].isActive = true;
470       whiteList[inv].payed    = false;
471       whitelistIndexes[whitelistIndex] = inv;
472       whitelistIndex++;
473     }
474 
475     whiteList[inv].invAmount  = amount;
476     whiteList[inv].holdPeriod = holdPeriod;
477     whiteList[inv].bonus = bonus;
478 
479     if (whiteList[inv].holdPeriod==1)  whiteList[inv].holdTimestamp = endSaleDate.add(30 days); else
480     if (whiteList[inv].holdPeriod==3)  whiteList[inv].holdTimestamp = endSaleDate.add(92 days); else
481     if (whiteList[inv].holdPeriod==6)  whiteList[inv].holdTimestamp = endSaleDate.add(182 days); else
482     if (whiteList[inv].holdPeriod==12) whiteList[inv].holdTimestamp = endSaleDate.add(1 years);
483 
484     AddedToWhiteList(inv, whiteList[inv].invAmount, whiteList[inv].holdPeriod,  whiteList[inv].bonus);
485   }
486 
487   function() whenNotPaused public payable {
488     require(state == SaleState.SALE);
489     require(msg.value >= 0.3 ether);
490     require(whiteList[msg.sender].isActive);
491 
492     if (now > endDate) {
493       state = SaleState.ENDED;
494       msg.sender.transfer(msg.value);
495       return ;
496     }
497 
498     WhitelistContributor memory contrib = whiteList[msg.sender];
499     require(contrib.invAmount <= msg.value || contrib.payed);
500 
501     if(whiteList[msg.sender].payed == false) {
502       whiteList[msg.sender].payed = true;
503     }
504 
505     ethRaised += msg.value;
506 
507     uint tokenAmount  = msg.value.div(price);
508     tokenAmount += tokenAmount.mul(contrib.bonus).div(100);
509     tokenAmount *= 10 ** 18;
510 
511     tokenRaised += tokenAmount;
512 
513     holdContract.addHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
514     AddedToHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
515     FundTransfered(msg.sender, msg.value);
516   }
517 
518   function getBalanceContract() internal returns (uint) {
519     return token.balanceOf(this);
520   }
521 
522   function sendTokensToHold() public onlyOwner {
523     require(state == SaleState.ENDED);
524 
525     require(getBalanceContract() >= tokenRaised);
526 
527     if (token.transfer(holdContract, tokenRaised )) {
528       tokensTransferredToHold = true;
529       TokensTransferedToHold(holdContract, tokenRaised );
530     }
531   }
532 
533   function getTokensBack() public onlyOwner {
534     require(state == SaleState.ENDED);
535     require(tokensTransferredToHold == true);
536     uint balance;
537     balance = getBalanceContract() ;
538     token.transfer(msg.sender, balance);
539   }
540 
541   function withdrawEth() {
542     require(this.balance != 0);
543     require(state == SaleState.ENDED);
544     require(msg.sender == wallet);
545     require(tokensTransferredToHold == true);
546     uint bal = this.balance;
547     wallet.transfer(bal);
548     WithdrawedEthToWallet(bal);
549   }
550 
551   function setEndSaleDate(uint date) public onlyOwner {
552     require(state == SaleState.NEW);
553     require(date > now);
554     uint oldEndDate = endSaleDate;
555     endSaleDate = date;
556     ManualChangeEndDate(oldEndDate, date);
557   }
558 
559   function setEndDate(uint date) public onlyOwner {
560     require(state == SaleState.NEW || state == SaleState.SALE);
561     require(date > now);
562     uint oldEndDate = endDate;
563     endDate = date;
564     ManualChangeEndDate(oldEndDate, date);
565   }
566 
567   function getTokenBalance() constant returns (uint) {
568     return token.balanceOf(this);
569   }
570 
571   function getEthRaised() constant external returns (uint) {
572     return ethRaised;
573   }
574 }
575 
576 
577 
578 contract OpportySaleBonus is Ownable {
579   using SafeMath for uint256;
580 
581   uint private startDate;
582 
583   /* bonus from time */
584   uint private firstBonusPhase;
585   uint private firstExtraBonus;
586   uint private secondBonusPhase;
587   uint private secondExtraBonus;
588   uint private thirdBonusPhase;
589   uint private thirdExtraBonus;
590   uint private fourBonusPhase;
591   uint private fourExtraBonus;
592   uint private fifthBonusPhase;
593   uint private fifthExtraBonus;
594   uint private sixthBonusPhase;
595   uint private sixthExtraBonus;
596 
597   /**
598   * @dev constructor
599   * 20% '1st 24 hours'
600   * 15% '2-4 days'
601   * 12% '5-9 days'
602   * 10% '10-14 days'
603   * 8%  '15-19 days'
604   * 5%  '20-24 days'
605   * 0%  '25-28 days'
606   */
607   function OpportySaleBonus(uint _startDate) {
608     startDate = _startDate;
609 
610     firstBonusPhase   = startDate.add(1 days);
611     firstExtraBonus   = 20;
612     secondBonusPhase  = startDate.add(4 days);
613     secondExtraBonus  = 15;
614     thirdBonusPhase   = startDate.add(9 days);
615     thirdExtraBonus   = 12;
616     fourBonusPhase    = startDate.add(14 days);
617     fourExtraBonus    = 10;
618     fifthBonusPhase   = startDate.add(19 days);
619     fifthExtraBonus   = 8;
620     sixthBonusPhase   = startDate.add(24 days);
621     sixthExtraBonus   = 5;
622   }
623 
624   /**
625  * @dev Calculate bonus for hours
626  * @return token bonus
627  */
628   function calculateBonusForHours(uint256 _tokens) returns(uint256) {
629     if (now >= startDate && now <= firstBonusPhase ) {
630       return _tokens.mul(firstExtraBonus).div(100);
631     } else
632     if (now <= secondBonusPhase ) {
633       return _tokens.mul(secondExtraBonus).div(100);
634     } else
635     if (now <= thirdBonusPhase ) {
636       return _tokens.mul(thirdExtraBonus).div(100);
637     } else
638     if (now <= fourBonusPhase ) {
639       return _tokens.mul(fourExtraBonus).div(100);
640     } else
641     if (now <= fifthBonusPhase ) {
642       return _tokens.mul(fifthExtraBonus).div(100);
643     } else
644     if (now <= sixthBonusPhase ) {
645       return _tokens.mul(sixthExtraBonus).div(100);
646     } else
647     return 0;
648   }
649 
650   function changeStartDate(uint _date) onlyOwner {
651     startDate = _date;
652     firstBonusPhase   = startDate.add(1 days);
653     secondBonusPhase  = startDate.add(4 days);
654     thirdBonusPhase   = startDate.add(9 days);
655     fourBonusPhase    = startDate.add(14 days);
656     fifthBonusPhase   = startDate.add(19 days);
657     sixthBonusPhase   = startDate.add(24 days);
658   }
659 
660   /**
661  * @dev return current bonus percent
662  */
663   function getBonus() public constant returns (uint) {
664     if (now >= startDate && now <= firstBonusPhase ) {
665       return firstExtraBonus;
666     } else
667     if ( now <= secondBonusPhase ) {
668       return secondExtraBonus;
669     } else
670     if ( now <= thirdBonusPhase ) {
671       return thirdExtraBonus;
672     } else
673     if ( now <= fourBonusPhase ) {
674       return fourExtraBonus;
675     } else
676     if ( now <= fifthBonusPhase ) {
677       return fifthExtraBonus;
678     } else
679     if ( now <= sixthBonusPhase ) {
680       return sixthExtraBonus;
681     } else
682     return 0;
683   }
684 
685 }
686 
687 contract OpportySale is Pausable {
688 
689   using SafeMath for uint256;
690 
691   OpportyToken public token;
692 
693   // minimum goal ETH
694   uint private SOFTCAP;
695   // maximum goal ETH
696   uint private HARDCAP;
697 
698   // start and end timestamps where investments are allowed
699   uint private startDate;
700   uint private endDate;
701 
702   uint private price;
703 
704   // total ETH collected
705   uint private ethRaised;
706   // total token sales
707   uint private totalTokens;
708   // how many tokens sent to investors
709   uint private withdrawedTokens;
710   // minimum ETH investment amount
711   uint private minimalContribution;
712 
713   bool releasedTokens;
714 
715   // address where funds are collected
716   address public wallet;
717   // address where funds will be frozen
718   HoldPresaleContract public holdContract;
719   OpportyPresale private presale;
720   OpportySaleBonus private bonus;
721 
722   //minimum of tokens that must be on the contract for the start
723   uint private minimumTokensToStart = 150000000 * (10 ** 18);
724 
725   struct ContributorData {
726     bool isActive;
727     uint contributionAmount;// total ETH
728     uint tokensIssued;// total token
729     uint bonusAmount;// total bonus token
730   }
731 
732   enum SaleState  { NEW, SALE, ENDED }
733   SaleState private state;
734 
735   mapping(address => ContributorData) public contributorList;
736   uint private nextContributorIndex;
737   uint private nextContributorToClaim;
738   uint private nextContributorToTransferTokens;
739 
740   mapping(uint => address) private contributorIndexes;
741   mapping(address => bool) private hasClaimedEthWhenFail; //address who got a refund
742   mapping(address => bool) private hasWithdrawedTokens; //address who got a tokens
743 
744   /* Events */
745   event CrowdsaleStarted(uint blockNumber);
746   event CrowdsaleEnded(uint blockNumber);
747   event SoftCapReached(uint blockNumber);
748   event HardCapReached(uint blockNumber);
749   event FundTransfered(address contrib, uint amount);
750   event TokensTransfered(address contributor , uint amount);
751   event Refunded(address ref, uint amount);
752   event ErrorSendingETH(address to, uint amount);
753   event WithdrawedEthToWallet(uint amount);
754   event ManualChangeStartDate(uint beforeDate, uint afterDate);
755   event ManualChangeEndDate(uint beforeDate, uint afterDate);
756   event TokensTransferedToHold(address hold, uint amount);
757   event TokensTransferedToOwner(address hold, uint amount);
758 
759   function OpportySale(
760     address tokenAddress,
761     address walletAddress,
762     uint start,
763     uint end,
764     address holdCont,
765     address presaleCont )
766   {
767     token = OpportyToken(tokenAddress);
768     state = SaleState.NEW;
769     SOFTCAP   = 1000 * 1 ether;
770     HARDCAP   = 50000 * 1 ether;
771     price     = 0.0002 * 1 ether;
772     startDate = start;
773     endDate   = end;
774     minimalContribution = 0.3 * 1 ether;
775     releasedTokens = false;
776 
777     wallet = walletAddress;
778     holdContract = HoldPresaleContract(holdCont);
779     presale = OpportyPresale(presaleCont);
780     bonus   = new OpportySaleBonus(start);
781   }
782 
783   /* Setters */
784 
785   function setStartDate(uint date) onlyOwner {
786     require(state == SaleState.NEW);
787     require(date < endDate);
788     uint oldStartDate = startDate;
789     startDate = date;
790     bonus.changeStartDate(date);
791     ManualChangeStartDate(oldStartDate, date);
792   }
793   function setEndDate(uint date) onlyOwner {
794     require(state == SaleState.NEW || state == SaleState.SALE);
795     require(date > now && date > startDate);
796     uint oldEndDate = endDate;
797     endDate = date;
798     ManualChangeEndDate(oldEndDate, date);
799   }
800   function setSoftCap(uint softCap) onlyOwner {
801     require(state == SaleState.NEW);
802     SOFTCAP = softCap;
803   }
804   function setHardCap(uint hardCap) onlyOwner {
805     require(state == SaleState.NEW);
806     HARDCAP = hardCap;
807   }
808 
809   /* The function without name is the default function that is called whenever anyone sends funds to a contract */
810   function() whenNotPaused public payable {
811     require(msg.value != 0);
812 
813     if (state == SaleState.ENDED) {
814       revert();
815     }
816 
817     bool chstate = checkCrowdsaleState();
818 
819     if (state == SaleState.SALE) {
820       processTransaction(msg.sender, msg.value);
821     }
822     else {
823       refundTransaction(chstate);
824     }
825   }
826 
827   /**
828    * @dev Checks if the goal or time limit has been reached and ends the campaign
829    * @return false when contract does not accept tokens
830    */
831   function checkCrowdsaleState() internal returns (bool){
832     if (getEthRaised() >= HARDCAP && state != SaleState.ENDED) {
833       state = SaleState.ENDED;
834       HardCapReached(block.number); // Close the crowdsale
835       CrowdsaleEnded(block.number);
836       return true;
837     }
838 
839     if(now > startDate && now <= endDate) {
840       if (state == SaleState.SALE && checkBalanceContract() >= minimumTokensToStart ) {
841         return true;
842       }
843     } else {
844       if (state != SaleState.ENDED && now > endDate) {
845         state = SaleState.ENDED;
846         CrowdsaleEnded(block.number);
847         return true;
848       }
849     }
850     return false;
851   }
852 
853   /**
854    * @dev Token purchase
855    */
856   function processTransaction(address _contributor, uint _amount) internal {
857 
858     require(msg.value >= minimalContribution);
859 
860     uint maxContribution = calculateMaxContribution();
861     uint contributionAmount = _amount;
862     uint returnAmount = 0;
863 
864     if (maxContribution < _amount) {
865       contributionAmount = maxContribution;
866       returnAmount = _amount - maxContribution;
867     }
868     uint ethrai = getEthRaised() ;
869     if (ethrai + contributionAmount >= SOFTCAP && SOFTCAP > ethrai) {
870       SoftCapReached(block.number);
871     }
872 
873     if (contributorList[_contributor].isActive == false) {
874       contributorList[_contributor].isActive = true;
875       contributorList[_contributor].contributionAmount = contributionAmount;
876       contributorIndexes[nextContributorIndex] = _contributor;
877       nextContributorIndex++;
878     } else {
879       contributorList[_contributor].contributionAmount += contributionAmount;
880     }
881 
882     ethRaised += contributionAmount;
883 
884     FundTransfered(_contributor, contributionAmount);
885 
886     uint tokenAmount  = contributionAmount.div(price);
887     uint timeBonus    = bonus.calculateBonusForHours(tokenAmount);
888 
889     if (tokenAmount > 0) {
890       contributorList[_contributor].tokensIssued += tokenAmount.add(timeBonus);
891       contributorList[_contributor].bonusAmount += timeBonus;
892       totalTokens += tokenAmount.add(timeBonus);
893     }
894 
895     if (returnAmount != 0) {
896       _contributor.transfer(returnAmount);
897     }
898   }
899 
900   /**
901    * @dev It is necessary for a correct change of status in the event of completion of the campaign.
902    * @param _stateChanged if true transfer ETH back
903    */
904   function refundTransaction(bool _stateChanged) internal {
905     if (_stateChanged) {
906       msg.sender.transfer(msg.value);
907     } else{
908       revert();
909     }
910   }
911 
912   /**
913    * @dev transfer remains tokens after the completion of crowdsale
914    */
915   function releaseTokens() onlyOwner {
916     require (state == SaleState.ENDED);
917 
918     uint cbalance = checkBalanceContract();
919 
920     require (cbalance != 0);
921     require (withdrawedTokens >= totalTokens || getEthRaised() < SOFTCAP);
922 
923     if (getEthRaised() >= SOFTCAP) {
924       if (releasedTokens == true) {
925         if (token.transfer(msg.sender, cbalance ) ) {
926           TokensTransferedToOwner(msg.sender , cbalance );
927         }
928       } else {
929         if (token.transfer(holdContract, cbalance ) ) {
930           holdContract.addHolder(msg.sender, cbalance, 1, endDate.add(182 days) );
931           releasedTokens = true;
932           TokensTransferedToHold(holdContract , cbalance );
933         }
934       }
935     } else {
936       if (token.transfer(msg.sender, cbalance) ) {
937         TokensTransferedToOwner(msg.sender , cbalance );
938       }
939     }
940   }
941 
942   function checkBalanceContract() internal returns (uint) {
943     return token.balanceOf(this);
944   }
945 
946   /**
947    * @dev if crowdsale is successful, investors can claim token here
948    */
949   function getTokens() whenNotPaused {
950     uint er =  getEthRaised();
951     require((now > endDate && er >= SOFTCAP )  || ( er >= HARDCAP)  );
952     require(state == SaleState.ENDED);
953     require(contributorList[msg.sender].tokensIssued > 0);
954     require(!hasWithdrawedTokens[msg.sender]);
955 
956     uint tokenCount = contributorList[msg.sender].tokensIssued;
957 
958     if (token.transfer(msg.sender, tokenCount * (10 ** 18) )) {
959       TokensTransfered(msg.sender , tokenCount * (10 ** 18) );
960       withdrawedTokens += tokenCount;
961       hasWithdrawedTokens[msg.sender] = true;
962     }
963 
964   }
965   function batchReturnTokens(uint _numberOfReturns) onlyOwner whenNotPaused {
966     uint er = getEthRaised();
967     require((now > endDate && er >= SOFTCAP )  || (er >= HARDCAP)  );
968     require(state == SaleState.ENDED);
969 
970     address currentParticipantAddress;
971     uint tokensCount;
972 
973     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
974       currentParticipantAddress = contributorIndexes[nextContributorToTransferTokens];
975       if (currentParticipantAddress == 0x0) return;
976       if (!hasWithdrawedTokens[currentParticipantAddress]) {
977         tokensCount = contributorList[currentParticipantAddress].tokensIssued;
978         hasWithdrawedTokens[currentParticipantAddress] = true;
979         if (token.transfer(currentParticipantAddress, tokensCount * (10 ** 18))) {
980           TokensTransfered(currentParticipantAddress, tokensCount * (10 ** 18));
981           withdrawedTokens += tokensCount;
982           hasWithdrawedTokens[msg.sender] = true;
983         }
984       }
985       nextContributorToTransferTokens += 1;
986     }
987 
988   }
989 
990   /**
991    * @dev if crowdsale is unsuccessful, investors can claim refunds here
992    */
993   function refund() whenNotPaused {
994     require(now > endDate && getEthRaised() < SOFTCAP);
995     require(contributorList[msg.sender].contributionAmount > 0);
996     require(!hasClaimedEthWhenFail[msg.sender]);
997 
998     uint ethContributed = contributorList[msg.sender].contributionAmount;
999     hasClaimedEthWhenFail[msg.sender] = true;
1000     if (!msg.sender.send(ethContributed)) {
1001       ErrorSendingETH(msg.sender, ethContributed);
1002     } else {
1003       Refunded(msg.sender, ethContributed);
1004     }
1005   }
1006   function batchReturnEthIfFailed(uint _numberOfReturns) onlyOwner whenNotPaused {
1007     require(now > endDate && getEthRaised() < SOFTCAP);
1008     address currentParticipantAddress;
1009     uint contribution;
1010     for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {
1011       currentParticipantAddress = contributorIndexes[nextContributorToClaim];
1012       if (currentParticipantAddress == 0x0) return;
1013       if (!hasClaimedEthWhenFail[currentParticipantAddress]) {
1014         contribution = contributorList[currentParticipantAddress].contributionAmount;
1015         hasClaimedEthWhenFail[currentParticipantAddress] = true;
1016 
1017         if (!currentParticipantAddress.send(contribution)){
1018           ErrorSendingETH(currentParticipantAddress, contribution);
1019         } else {
1020           Refunded(currentParticipantAddress, contribution);
1021         }
1022       }
1023       nextContributorToClaim += 1;
1024     }
1025   }
1026 
1027   /**
1028    * @dev transfer funds ETH to multisig wallet if reached minimum goal
1029    */
1030   function withdrawEth() {
1031     require(this.balance != 0);
1032     require(getEthRaised() >= SOFTCAP);
1033     require(msg.sender == wallet);
1034     uint bal = this.balance;
1035     wallet.transfer(bal);
1036     WithdrawedEthToWallet(bal);
1037   }
1038 
1039   function withdrawRemainingBalanceForManualRecovery() onlyOwner {
1040     require(this.balance != 0);
1041     require(now > endDate);
1042     require(contributorIndexes[nextContributorToClaim] == 0x0);
1043     msg.sender.transfer(this.balance);
1044   }
1045 
1046   /**
1047    * @dev Manual start crowdsale.
1048    */
1049   function startCrowdsale() onlyOwner  {
1050     require(now > startDate && now <= endDate);
1051     require(state == SaleState.NEW);
1052     require(checkBalanceContract() >= minimumTokensToStart);
1053 
1054     state = SaleState.SALE;
1055     CrowdsaleStarted(block.number);
1056   }
1057 
1058   /* Getters */
1059 
1060   function getAccountsNumber() constant returns (uint) {
1061     return nextContributorIndex;
1062   }
1063 
1064   function getEthRaised() constant returns (uint) {
1065     uint pre = presale.getEthRaised();
1066     return pre + ethRaised;
1067   }
1068 
1069   function getTokensTotal() constant returns (uint) {
1070     return totalTokens;
1071   }
1072 
1073   function getWithdrawedToken() constant returns (uint) {
1074     return withdrawedTokens;
1075   }
1076 
1077   function calculateMaxContribution() constant returns (uint) {
1078     return HARDCAP - getEthRaised();
1079   }
1080 
1081   function getSoftCap() constant returns(uint) {
1082     return SOFTCAP;
1083   }
1084 
1085   function getHardCap() constant returns(uint) {
1086     return HARDCAP;
1087   }
1088 
1089   function getSaleStatus() constant returns (uint) {
1090     return uint(state);
1091   }
1092 
1093   function getStartDate() constant returns (uint) {
1094     return startDate;
1095   }
1096 
1097   function getEndDate() constant returns (uint) {
1098     return endDate;
1099   }
1100 
1101   // @return true if crowdsale event has ended
1102   function hasEnded() public constant returns (bool) {
1103     return now > endDate || state == SaleState.ENDED;
1104   }
1105 
1106   function getTokenBalance() constant returns (uint) {
1107     return token.balanceOf(this);
1108   }
1109 
1110   /**
1111    * @dev return current bonus percent
1112    */
1113   function getCurrentBonus() public constant returns (uint) {
1114     if(now > endDate || state == SaleState.ENDED) {
1115       return 0;
1116     }
1117     return bonus.getBonus();
1118   }
1119 }