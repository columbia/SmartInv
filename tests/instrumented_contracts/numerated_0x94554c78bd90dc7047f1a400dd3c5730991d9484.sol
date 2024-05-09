1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 /**
177  * @title SimpleToken
178  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
179  * Note they can later distribute these tokens as they wish using `transfer` and other
180  * `StandardToken` functions.
181  */
182 contract OpportyToken is StandardToken {
183 
184   string public constant name = "OpportyToken";
185   string public constant symbol = "OPP";
186   uint8 public constant decimals = 18;
187 
188   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
189 
190   /**
191    * @dev Contructor that gives msg.sender all of existing tokens.
192    */
193   function OpportyToken() public {
194     totalSupply = INITIAL_SUPPLY;
195     balances[msg.sender] = INITIAL_SUPPLY;
196   }
197 
198 }
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211 
212   /**
213    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
214    * account.
215    */
216   function Ownable() public {
217     owner = msg.sender;
218   }
219 
220 
221   /**
222    * @dev Throws if called by any account other than the owner.
223    */
224   modifier onlyOwner() {
225     require(msg.sender == owner);
226     _;
227   }
228 
229 
230   /**
231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) public onlyOwner {
235     require(newOwner != address(0));
236     OwnershipTransferred(owner, newOwner);
237     owner = newOwner;
238   }
239 
240 }
241 
242 /**
243  * @title Pausable
244  * @dev Base contract which allows children to implement an emergency stop mechanism.
245  */
246 contract Pausable is Ownable {
247   event Pause();
248   event Unpause();
249 
250   bool public paused = false;
251 
252 
253   /**
254    * @dev Modifier to make a function callable only when the contract is not paused.
255    */
256   modifier whenNotPaused() {
257     require(!paused);
258     _;
259   }
260 
261   /**
262    * @dev Modifier to make a function callable only when the contract is paused.
263    */
264   modifier whenPaused() {
265     require(paused);
266     _;
267   }
268 
269   /**
270    * @dev called by the owner to pause, triggers stopped state
271    */
272   function pause() onlyOwner whenNotPaused public {
273     paused = true;
274     Pause();
275   }
276 
277   /**
278    * @dev called by the owner to unpause, returns to normal state
279    */
280   function unpause() onlyOwner whenPaused public {
281     paused = false;
282     Unpause();
283   }
284 }
285 
286 contract HoldPresaleContract is Ownable {
287   using SafeMath for uint256;
288   // Addresses and contracts
289   OpportyToken public OppToken;
290   address private presaleCont;
291 
292   struct Holder {
293     bool isActive;
294     uint tokens;
295     uint8 holdPeriod;
296     uint holdPeriodTimestamp;
297     bool withdrawed;
298   }
299 
300   mapping(address => Holder) public holderList;
301   mapping(uint => address) private holderIndexes;
302 
303   mapping (uint => address) private assetOwners;
304   mapping (address => uint) private assetOwnersIndex;
305   uint public assetOwnersIndexes;
306 
307   uint private holderIndex;
308 
309   event TokensTransfered(address contributor , uint amount);
310   event Hold(address sender, address contributor, uint amount, uint8 holdPeriod);
311 
312   modifier onlyAssetsOwners() {
313     require(assetOwnersIndex[msg.sender] > 0);
314     _;
315   }
316 
317   /* constructor */
318   function HoldPresaleContract(address _OppToken) public {
319     OppToken = OpportyToken(_OppToken);
320   }
321 
322   function setPresaleCont(address pres)  public onlyOwner
323   {
324     presaleCont = pres;
325   }
326 
327   function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external {
328     if (holderList[holder].isActive == false) {
329       holderList[holder].isActive = true;
330       holderList[holder].tokens = tokens;
331       holderList[holder].holdPeriod = timed;
332       holderList[holder].holdPeriodTimestamp = timest;
333       holderIndexes[holderIndex] = holder;
334       holderIndex++;
335     } else {
336       holderList[holder].tokens += tokens;
337       holderList[holder].holdPeriod = timed;
338       holderList[holder].holdPeriodTimestamp = timest;
339     }
340     Hold(msg.sender, holder, tokens, timed);
341   }
342 
343   function getBalance() public constant returns (uint) {
344     return OppToken.balanceOf(this);
345   }
346 
347   function unlockTokens() external {
348     address contributor = msg.sender;
349 
350     if (holderList[contributor].isActive && !holderList[contributor].withdrawed) {
351       if (now >= holderList[contributor].holdPeriodTimestamp) {
352         if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) {
353           holderList[contributor].withdrawed = true;
354           TokensTransfered(contributor,  holderList[contributor].tokens);
355         }
356       } else {
357         revert();
358       }
359     } else {
360       revert();
361     }
362   }
363 
364   function addAssetsOwner(address _owner) public onlyOwner {
365     assetOwnersIndexes++;
366     assetOwners[assetOwnersIndexes] = _owner;
367     assetOwnersIndex[_owner] = assetOwnersIndexes;
368   }
369   function removeAssetsOwner(address _owner) public onlyOwner {
370     uint index = assetOwnersIndex[_owner];
371     delete assetOwnersIndex[_owner];
372     delete assetOwners[index];
373     assetOwnersIndexes--;
374   }
375   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
376     return assetOwners[_index];
377   }
378 }
379 
380 contract OpportyPresale is Pausable {
381   using SafeMath for uint256;
382 
383   OpportyToken public token;
384 
385   HoldPresaleContract public holdContract;
386 
387   enum SaleState  { NEW, SALE, ENDED }
388   SaleState public state;
389 
390   uint public endDate;
391   uint public endSaleDate;
392 
393   // address where funds are collected
394   address private wallet;
395 
396   // total ETH collected
397   uint public ethRaised;
398 
399   uint private price;
400 
401   uint public tokenRaised;
402   bool public tokensTransferredToHold;
403 
404   /* Events */
405   event SaleStarted(uint blockNumber);
406   event SaleEnded(uint blockNumber);
407   event FundTransfered(address contrib, uint amount);
408   event WithdrawedEthToWallet(uint amount);
409   event ManualChangeEndDate(uint beforeDate, uint afterDate);
410   event TokensTransferedToHold(address hold, uint amount);
411   event AddedToWhiteList(address inv, uint amount, uint8 holdPeriod, uint8 bonus);
412   event AddedToHolder( address sender, uint tokenAmount, uint8 holdPeriod, uint holdTimestamp);
413 
414   struct WhitelistContributor {
415     bool isActive;
416     uint invAmount;
417     uint8 holdPeriod;
418     uint holdTimestamp;
419     uint8 bonus;
420     bool payed;
421   }
422 
423   mapping(address => WhitelistContributor) public whiteList;
424   mapping(uint => address) private whitelistIndexes;
425   uint private whitelistIndex;
426 
427   /* constructor */
428   function OpportyPresale(
429     address tokenAddress,
430     address walletAddress,
431     uint end,
432     uint endSale,
433     address holdCont ) public
434   {
435     token = OpportyToken(tokenAddress);
436     state = SaleState.NEW;
437 
438     endDate     = end;
439     endSaleDate = endSale;
440     price       = 0.0002 * 1 ether;
441     wallet      = walletAddress;
442 
443     holdContract = HoldPresaleContract(holdCont);
444   }
445 
446   function startPresale() public onlyOwner {
447     require(state == SaleState.NEW);
448     state = SaleState.SALE;
449     SaleStarted(block.number);
450   }
451 
452   function endPresale() public onlyOwner {
453     require(state == SaleState.SALE);
454     state = SaleState.ENDED;
455     SaleEnded(block.number);
456   }
457 
458   function addToWhitelist(address inv, uint amount, uint8 holdPeriod, uint8 bonus) public onlyOwner {
459     require(state == SaleState.NEW || state == SaleState.SALE);
460     require(holdPeriod == 1 || holdPeriod == 3 || holdPeriod == 6 || holdPeriod == 12);
461 
462     amount = amount * (10 ** 18);
463 
464     if (whiteList[inv].isActive == false) {
465       whiteList[inv].isActive = true;
466       whiteList[inv].payed    = false;
467       whitelistIndexes[whitelistIndex] = inv;
468       whitelistIndex++;
469     }
470 
471     whiteList[inv].invAmount  = amount;
472     whiteList[inv].holdPeriod = holdPeriod;
473     whiteList[inv].bonus = bonus;
474 
475     if (whiteList[inv].holdPeriod==1)  whiteList[inv].holdTimestamp = endSaleDate.add(30 days); else
476     if (whiteList[inv].holdPeriod==3)  whiteList[inv].holdTimestamp = endSaleDate.add(92 days); else
477     if (whiteList[inv].holdPeriod==6)  whiteList[inv].holdTimestamp = endSaleDate.add(182 days); else
478     if (whiteList[inv].holdPeriod==12) whiteList[inv].holdTimestamp = endSaleDate.add(1 years);
479 
480     AddedToWhiteList(inv, whiteList[inv].invAmount, whiteList[inv].holdPeriod,  whiteList[inv].bonus);
481   }
482 
483   function() whenNotPaused public payable {
484     require(state == SaleState.SALE);
485     require(msg.value >= 0.3 ether);
486     require(whiteList[msg.sender].isActive);
487 
488     if (now > endDate) {
489       state = SaleState.ENDED;
490       msg.sender.transfer(msg.value);
491       return ;
492     }
493 
494     WhitelistContributor memory contrib = whiteList[msg.sender];
495     require(contrib.invAmount <= msg.value || contrib.payed);
496 
497     if(whiteList[msg.sender].payed == false) {
498       whiteList[msg.sender].payed = true;
499     }
500 
501     ethRaised += msg.value;
502 
503     uint tokenAmount  = msg.value.div(price);
504     tokenAmount += tokenAmount.mul(contrib.bonus).div(100);
505     tokenAmount *= 10 ** 18;
506 
507     tokenRaised += tokenAmount;
508 
509     holdContract.addHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
510     AddedToHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
511     FundTransfered(msg.sender, msg.value);
512   }
513 
514   function getBalanceContract() view internal returns (uint) {
515     return token.balanceOf(this);
516   }
517 
518   function sendTokensToHold() public onlyOwner {
519     require(state == SaleState.ENDED);
520 
521     require(getBalanceContract() >= tokenRaised);
522 
523     if (token.transfer(holdContract, tokenRaised )) {
524       tokensTransferredToHold = true;
525       TokensTransferedToHold(holdContract, tokenRaised );
526     }
527   }
528 
529   function getTokensBack() public onlyOwner {
530     require(state == SaleState.ENDED);
531     require(tokensTransferredToHold == true);
532     uint balance;
533     balance = getBalanceContract() ;
534     token.transfer(msg.sender, balance);
535   }
536 
537   function withdrawEth() public {
538     require(this.balance != 0);
539     require(state == SaleState.ENDED);
540     require(msg.sender == wallet);
541     require(tokensTransferredToHold == true);
542     uint bal = this.balance;
543     wallet.transfer(bal);
544     WithdrawedEthToWallet(bal);
545   }
546 
547   function setEndSaleDate(uint date) public onlyOwner {
548     require(state == SaleState.NEW);
549     require(date > now);
550     uint oldEndDate = endSaleDate;
551     endSaleDate = date;
552     ManualChangeEndDate(oldEndDate, date);
553   }
554 
555   function setEndDate(uint date) public onlyOwner {
556     require(state == SaleState.NEW || state == SaleState.SALE);
557     require(date > now);
558     uint oldEndDate = endDate;
559     endDate = date;
560     ManualChangeEndDate(oldEndDate, date);
561   }
562 
563   function getTokenBalance() public constant returns (uint) {
564     return token.balanceOf(this);
565   }
566 
567   function getEthRaised() constant external returns (uint) {
568     return ethRaised;
569   }
570 }
571 
572 contract OpportyPresale2 is Pausable {
573   using SafeMath for uint256;
574 
575   OpportyToken public token;
576 
577   HoldPresaleContract public holdContract;
578   OpportyPresale      public preSaleContract;
579 
580   enum SaleState  { NEW, SALE, ENDED }
581   SaleState public state;
582 
583   uint public endDate;
584   uint public endSaleDate;
585   uint public minimalContribution;
586 
587   // address where funds are collected
588   address private wallet;
589 
590   address private preSaleOld;
591 
592   // total ETH collected
593   uint public ethRaised;
594 
595   uint private price;
596 
597   uint public tokenRaised;
598   bool public tokensTransferredToHold;
599 
600   /* Events */
601   event SaleStarted(uint blockNumber);
602   event SaleEnded(uint blockNumber);
603   event FundTransfered(address contrib, uint amount);
604   event WithdrawedEthToWallet(uint amount);
605   event ManualChangeEndDate(uint beforeDate, uint afterDate);
606   event TokensTransferedToHold(address hold, uint amount);
607   event AddedToWhiteList(address inv, uint amount, uint8 holdPeriod, uint8 bonus);
608   event AddedToHolder(address sender, uint tokenAmount, uint8 holdPeriod, uint holdTimestamp);
609   event ChangeMinAmount(uint oldMinAmount, uint minAmount);
610 
611   struct WhitelistContributor {
612     bool isActive;
613     uint invAmount;
614     uint8 holdPeriod;
615     uint holdTimestamp;
616     uint8 bonus;
617     bool payed;
618   }
619 
620   mapping(address => WhitelistContributor) public whiteList;
621   mapping(uint => address) private whitelistIndexes;
622   uint private whitelistIndex;
623 
624   mapping (uint => address) private assetOwners;
625   mapping (address => uint) private assetOwnersIndex;
626   uint public assetOwnersIndexes;
627 
628   modifier onlyAssetsOwners() {
629     require(assetOwnersIndex[msg.sender] > 0);
630     _;
631   }
632 
633   /* constructor */
634   function OpportyPresale2(
635     address tokenAddress,
636     address walletAddress,
637     uint end,
638     uint endSale,
639     address holdCont,
640     address oldPreSale) public
641   {
642     token = OpportyToken(tokenAddress);
643     state = SaleState.NEW;
644 
645     endDate     = end;
646     endSaleDate = endSale;
647     price       = 0.0002 * 1 ether;
648     wallet      = walletAddress;
649     minimalContribution = 0.3 * 1 ether;
650 
651     preSaleContract = OpportyPresale(oldPreSale);
652     holdContract = HoldPresaleContract(holdCont);
653     addAssetsOwner(msg.sender);
654   }
655 
656   function startPresale() public onlyOwner {
657     require(state == SaleState.NEW);
658     state = SaleState.SALE;
659     SaleStarted(block.number);
660   }
661 
662   function endPresale() public onlyOwner {
663     require(state == SaleState.SALE);
664     state = SaleState.ENDED;
665     SaleEnded(block.number);
666   }
667 
668   function addToWhitelist(address inv, uint amount, uint8 holdPeriod, uint8 bonus) public onlyAssetsOwners {
669     require(state == SaleState.NEW || state == SaleState.SALE);
670     require(holdPeriod == 1 || holdPeriod == 3 || holdPeriod == 6 || holdPeriod == 12);
671     require(amount >= minimalContribution);
672 
673     if (whiteList[inv].isActive == false) {
674       whiteList[inv].isActive = true;
675       whiteList[inv].payed    = false;
676       whitelistIndexes[whitelistIndex] = inv;
677       whitelistIndex++;
678     }
679 
680     whiteList[inv].invAmount  = amount;
681     whiteList[inv].holdPeriod = holdPeriod;
682     whiteList[inv].bonus = bonus;
683 
684     if (whiteList[inv].holdPeriod==1)  whiteList[inv].holdTimestamp = endSaleDate.add(30 days); else
685     if (whiteList[inv].holdPeriod==3)  whiteList[inv].holdTimestamp = endSaleDate.add(92 days); else
686     if (whiteList[inv].holdPeriod==6)  whiteList[inv].holdTimestamp = endSaleDate.add(182 days); else
687     if (whiteList[inv].holdPeriod==12) whiteList[inv].holdTimestamp = endSaleDate.add(1 years);
688 
689     AddedToWhiteList(inv, whiteList[inv].invAmount, whiteList[inv].holdPeriod,  whiteList[inv].bonus);
690   }
691 
692   function() whenNotPaused public payable {
693     require(state == SaleState.SALE);
694     require(msg.value >= minimalContribution);
695     require(whiteList[msg.sender].isActive);
696 
697     if (now > endDate) {
698       state = SaleState.ENDED;
699       msg.sender.transfer(msg.value);
700       return ;
701     }
702 
703     WhitelistContributor memory contrib = whiteList[msg.sender];
704     require(contrib.invAmount <= msg.value || contrib.payed);
705 
706     if(whiteList[msg.sender].payed == false) {
707       whiteList[msg.sender].payed = true;
708     }
709 
710     ethRaised += msg.value;
711 
712     uint tokenAmount  = msg.value.div(price);
713     tokenAmount += tokenAmount.mul(contrib.bonus).div(100);
714     tokenAmount *= 10 ** 18;
715 
716     tokenRaised += tokenAmount;
717 
718     holdContract.addHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
719     AddedToHolder(msg.sender, tokenAmount, contrib.holdPeriod, contrib.holdTimestamp);
720     FundTransfered(msg.sender, msg.value);
721 
722     // forward the funds to the wallet
723     forwardFunds();
724   }
725 
726   /**
727      * send ether to the fund collection wallet
728      * override to create custom fund forwarding mechanisms
729      */
730   function forwardFunds() internal {
731     wallet.transfer(msg.value);
732   }
733 
734 
735   function getBalanceContract() view internal returns (uint) {
736     return token.balanceOf(this);
737   }
738 
739   function sendTokensToHold() public onlyOwner {
740     require(state == SaleState.ENDED);
741 
742     require(getBalanceContract() >= tokenRaised);
743 
744     if (token.transfer(holdContract, tokenRaised )) {
745       tokensTransferredToHold = true;
746       TokensTransferedToHold(holdContract, tokenRaised );
747     }
748   }
749 
750   function getTokensBack() public onlyOwner {
751     require(state == SaleState.ENDED);
752     require(tokensTransferredToHold == true);
753     uint balance;
754     balance = getBalanceContract() ;
755     token.transfer(msg.sender, balance);
756   }
757 
758   function withdrawEth() public {
759     require(this.balance != 0);
760     require(state == SaleState.ENDED);
761     require(msg.sender == wallet);
762     require(tokensTransferredToHold == true);
763     uint bal = this.balance;
764     wallet.transfer(bal);
765     WithdrawedEthToWallet(bal);
766   }
767 
768   function setEndSaleDate(uint date) public onlyOwner {
769     require(state == SaleState.NEW || state == SaleState.SALE);
770     require(date > now);
771     uint oldEndDate = endSaleDate;
772     endSaleDate = date;
773     ManualChangeEndDate(oldEndDate, date);
774   }
775 
776   function setEndDate(uint date) public onlyOwner {
777     require(state == SaleState.NEW || state == SaleState.SALE);
778     require(date > now);
779     uint oldEndDate = endDate;
780     endDate = date;
781     ManualChangeEndDate(oldEndDate, date);
782   }
783 
784   function setMinimalContribution(uint minimumAmount) public onlyOwner {
785     uint oldMinAmount = minimalContribution;
786     minimalContribution = minimumAmount;
787     ChangeMinAmount(oldMinAmount, minimalContribution);
788   }
789 
790   function getTokenBalance() public constant returns (uint) {
791     return token.balanceOf(this);
792   }
793 
794   function getEthRaised() constant external returns (uint) {
795     uint pre = preSaleContract.getEthRaised();
796     return pre + ethRaised;
797   }
798 
799   function addAssetsOwner(address _owner) public onlyOwner {
800     assetOwnersIndexes++;
801     assetOwners[assetOwnersIndexes] = _owner;
802     assetOwnersIndex[_owner] = assetOwnersIndexes;
803   }
804   function removeAssetsOwner(address _owner) public onlyOwner {
805     uint index = assetOwnersIndex[_owner];
806     delete assetOwnersIndex[_owner];
807     delete assetOwners[index];
808     assetOwnersIndexes--;
809   }
810   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
811     return assetOwners[_index];
812   }
813 }