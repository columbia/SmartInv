1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256)  {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73   function max(uint256 a, uint256 b) internal pure returns (uint256) {
74     return a > b ? a : b;
75   }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public constant returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public constant returns (uint256 balance) {
142     return balances[_owner];
143   }
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval (address _spender, uint _addedValue)
209     public
210     returns (bool success) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   function decreaseApproval (address _spender, uint _subtractedValue)
217   public
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 }
229 
230 /**
231  * @title The OrigamiToken contract
232  * @dev The OrigamiToken Token contract
233  * @dev inherite from StandardToken and Ownable by Zeppelin
234  * @author ori.network
235  */
236 contract OrigamiToken is StandardToken, Ownable {
237     string  public  constant name = "Origami Network";
238     string  public  constant symbol = "ORI";
239     uint8    public  constant decimals = 18;
240 
241     uint    public  transferableStartTime;
242 
243     address public  tokenSaleContract;
244     address public  bountyWallet;
245 
246 
247     modifier onlyWhenTransferEnabled() 
248     {
249         if ( now <= transferableStartTime ) {
250             require(msg.sender == tokenSaleContract || msg.sender == bountyWallet || msg.sender == owner);
251         }
252         _;
253     }
254 
255     modifier validDestination(address to) 
256     {
257         require(to != address(this));
258         _;
259     }
260 
261     function OrigamiToken(
262         uint tokenTotalAmount, 
263         uint _transferableStartTime, 
264         address _admin, 
265         address _bountyWallet) public
266     {
267         // Mint all tokens. Then disable minting forever.
268         totalSupply_ = tokenTotalAmount * (10 ** uint256(decimals));
269 
270         // Send token to the contract
271         balances[msg.sender] = totalSupply_;
272         Transfer(address(0x0), msg.sender, totalSupply_);
273 
274         // Transferable start time will be set x days after sale end
275         transferableStartTime = _transferableStartTime;
276         // Keep the sale contrat to allow transfer from contract during the sale
277         tokenSaleContract = msg.sender;
278         //  Keep bounty wallet to distribute bounties before transfer is allowed
279         bountyWallet = _bountyWallet;
280 
281         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
282     }
283 
284     /**
285      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
286      * @param _to The address to transfer to.
287      * @param _value The amount to be transferred.
288      */
289     function transfer(address _to, uint _value)
290         public
291         validDestination(_to)
292         onlyWhenTransferEnabled
293         returns (bool) 
294     {
295         return super.transfer(_to, _value);
296     }
297 
298     /**
299      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
300      * @param _from The address to transfer from.
301      * @param _to The address to transfer to.
302      * @param _value The amount to be transferred.
303      */
304     function transferFrom(address _from, address _to, uint _value)
305         public
306         validDestination(_to)
307         onlyWhenTransferEnabled
308         returns (bool) 
309     {
310         return super.transferFrom(_from, _to, _value);
311     }
312 
313     event Burn(address indexed _burner, uint _value);
314 
315     /**
316      * @dev burn tokens
317      * @param _value The amount to be burned.
318      * @return always true (necessary in case of override)
319      */
320     function burn(uint _value) 
321         public
322         onlyWhenTransferEnabled
323         returns (bool)
324     {
325         balances[msg.sender] = balances[msg.sender].sub(_value);
326         totalSupply_ = totalSupply_.sub(_value);
327         Burn(msg.sender, _value);
328         Transfer(msg.sender, address(0x0), _value);
329         return true;
330     }
331 
332     /**
333      * @dev burn tokens in the behalf of someone
334      * @param _from The address of the owner of the token.
335      * @param _value The amount to be burned.
336      * @return always true (necessary in case of override)
337      */
338     function burnFrom(address _from, uint256 _value) 
339         public
340         onlyWhenTransferEnabled
341         returns(bool) 
342     {
343         assert(transferFrom(_from, msg.sender, _value));
344         return burn(_value);
345     }
346 
347     /**
348      * @dev transfer to owner any tokens send by mistake on this contracts
349      * @param token The address of the token to transfer.
350      * @param amount The amount to be transfered.
351      */
352     function emergencyERC20Drain(ERC20 token, uint amount )
353         public
354         onlyOwner 
355     {
356         token.transfer(owner, amount);
357     }
358 }
359 
360 /**
361  * @title StandardCrowdsale 
362  * @dev StandardCrowdsale is a base contract for managing a token crowdsale.
363  * Crowdsales have a start and end timestamps, where investors can make
364  * token purchases and the crowdsale will assign them tokens based
365  * on a token per ETH rate. Funds collected are forwarded to a wallet
366  * as they arrive.
367  * @dev from Crowdsale by Zepellin.
368  */
369 contract StandardCrowdsale {
370   using SafeMath for uint256;
371 
372   // The token being sold
373   StandardToken public token;
374 
375   // start and end timestamps where investments are allowed (both inclusive)
376   uint256 public startTime;
377   uint256 public endTime;
378 
379   // address where funds are collected
380   address public wallet;
381 
382   // how many token units a buyer gets per wei
383   uint256 public rate;
384 
385   // amount of raised money in wei
386   uint256 public weiRaised;
387 
388   /**
389    * event for token purchase logging
390    * @param purchaser who paid for the tokens
391    * @param beneficiary who got the tokens
392    * @param value weis paid for purchase
393    * @param amount amount of tokens purchased
394    */
395   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
396 
397   /**
398    * ORI modification : token is created by contract
399    */
400   function StandardCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
401     require(_startTime >= now);
402     require(_endTime >= _startTime);
403     require(_rate > 0);
404     require(_wallet != address(0));
405 
406     startTime = _startTime;
407     endTime = _endTime;
408     rate = _rate;
409     wallet = _wallet;
410   }
411 
412   //fallback function can be used to buy tokens
413   function () external payable {
414     buyTokens(msg.sender);
415   }
416 
417   //low level token purchase function
418   function buyTokens(address beneficiary) public payable {
419     require(beneficiary != address(0));
420     require(validPurchase());
421 
422     uint256 weiAmount = msg.value;
423 
424     // calculate token amount to be created
425     uint256 tokens = getTokenAmount(weiAmount);
426 
427     // update state
428     weiRaised = weiRaised.add(weiAmount);
429 
430     // Override ORI : not mintable
431     //token.mint(beneficiary, tokens);
432     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
433 
434     forwardFunds();
435   }
436 
437   // @return true if crowdsale event has ended
438   function hasEnded() public view returns (bool) {
439     return now > endTime;
440   }
441 
442   // Override this method to have a way to add business logic to your crowdsale when buying
443   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
444     return weiAmount.mul(rate);
445   }
446 
447   // send ether to the fund collection wallet
448   // override to create custom fund forwarding mechanisms
449   function forwardFunds() internal {
450     wallet.transfer(msg.value);
451   }
452 
453 
454   // @return true if the transaction can buy tokens
455   function validPurchase() internal view returns (bool) {
456     // Test is already done by origami token sale
457     return true;
458   }
459 
460 }
461 
462 /**
463  * @title CappedCrowdsale
464  * @dev Extension of Crowdsale with a max amount of funds raised
465  */
466 contract CappedCrowdsale is StandardCrowdsale {
467   using SafeMath for uint256;
468 
469   uint256 public cap;
470   
471 
472   function CappedCrowdsale(uint256 _cap) public {
473     require(_cap > 0);
474     cap = _cap;
475   }
476 
477   // overriding Crowdsale#hasEnded to add cap logic
478   // @return true if crowdsale event has ended
479   function hasEnded() public view returns (bool) {
480     bool capReached = weiRaised >= cap;
481     return capReached || super.hasEnded();
482   }
483 
484   // overriding Crowdsale#validPurchase to add extra cap logic
485   // @return true if investors can buy at the moment
486   function validPurchase() internal view returns (bool) {
487     bool withinCap = weiRaised < cap;
488     return withinCap && super.validPurchase();
489   }
490 
491 }
492 
493 
494 
495 /**
496  * @title WhitelistedCrowdsale
497  * @dev This is an extension to add whitelist to a crowdsale
498  * @author ori.network
499  *
500  */
501 contract WhitelistedCrowdsale is StandardCrowdsale, Ownable {
502     
503     mapping(address=>bool) public registered;
504 
505     event RegistrationStatusChanged(address target, bool isRegistered);
506 
507     /**
508      * @dev Changes registration status of an address for participation.
509      * @param target Address that will be registered/deregistered.
510      * @param isRegistered New registration status of address.
511      */
512     function changeRegistrationStatus(address target, bool isRegistered)
513         public
514         onlyOwner
515     {
516         registered[target] = isRegistered;
517         RegistrationStatusChanged(target, isRegistered);
518     }
519 
520     /**
521      * @dev Changes registration statuses of addresses for participation.
522      * @param targets Addresses that will be registered/deregistered.
523      * @param isRegistered New registration status of addresses.
524      */
525     function changeRegistrationStatuses(address[] targets, bool isRegistered)
526         public
527         onlyOwner
528     {
529         for (uint i = 0; i < targets.length; i++) {
530             changeRegistrationStatus(targets[i], isRegistered);
531         }
532     }
533 
534     /**
535      * @dev overriding Crowdsale#validPurchase to add whilelist
536      * @return true if investors can buy at the moment, false otherwise
537      */
538     function validPurchase() internal view  returns (bool) {
539         return super.validPurchase() && registered[msg.sender];
540     }
541 }
542 
543 /**
544  * @title OrigamiTokenSale
545  * @dev 
546  * We add new features to a base crowdsale using multiple inheritance.
547  * We are using the following extensions:
548  * CappedCrowdsale - sets a max boundary for raised funds
549  * WhitelistedCrowdsale - add a whitelist
550  *
551  * The code is based on the contracts of Open Zeppelin and we add our contracts : OrigamiTokenSale, WhiteListedCrowdsale, CappedCrowdsale and the Origami Token
552  *
553  * @author ori.network
554  */
555 contract OrigamiTokenSale is Ownable, CappedCrowdsale, WhitelistedCrowdsale {
556     // hard cap of the token sale in ether
557     uint private constant HARD_CAP_IN_WEI = 5000 ether;
558     uint private constant HARD_CAP_IN_WEI_PRESALE = 1000 ether;
559 
560     // Bonus
561     uint private constant BONUS_TWENTY_AMOUNT = 200 ether;
562     uint private constant BONUS_TEN_AMOUNT = 100 ether;
563     uint private constant BONUS_FIVE_AMOUNT = 50 ether;   
564     
565     // Maximum / Minimum contribution
566     uint private constant MINIMUM_INVEST_IN_WEI_PRESALE = 0.5 ether;
567     uint private constant CONTRIBUTOR_MAX_PRESALE_CONTRIBUTION = 50 ether;
568     uint private constant MINIMUM_INVEST_IN_WEI_SALE = 0.1 ether;
569     uint private constant CONTRIBUTOR_MAX_SALE_CONTRIBUTION = 500 ether;
570 
571     // TEAM WALLET
572     address private constant ORIGAMI_WALLET = 0xf498ED871995C178a5815dd6D80AE60e1c5Ca2F4;
573     
574     // Token initialy distributed for the bounty
575     address private constant BOUNTY_WALLET = 0xDBA7a16383658AeDf0A28Eabf2032479F128f26D;
576     uint private constant BOUNTY_AMOUNT = 3000000e18;
577 
578     // PERIOD WHEN TOKEN IS NOT TRANSFERABLE AFTER THE SALE
579     uint private constant PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC = 7 days;    
580 
581     // Total of ORI supply
582     uint private constant TOTAL_ORI_TOKEN_SUPPLY = 50000000;
583 
584     // Token sale rate from ETH to ORI
585     uint private constant RATE_ETH_ORI = 6000;
586     
587 
588     // start and end timestamp PRESALE
589     uint256 public presaleStartTime;
590     uint256 public presaleEndTime;
591     uint256 private presaleEndedAt;
592     uint256 public preSaleWeiRaised;
593     
594     // Bonus Times
595     uint public firstWeekEndTime;
596     uint public secondWeekEndTime;  
597     
598     
599     // Check wei invested by contributor on presale
600     mapping(address => uint256) wei_invested_by_contributor_in_presale;
601     mapping(address => uint256) wei_invested_by_contributor_in_sale;
602 
603     event OrigamiTokenPurchase(address indexed beneficiary, uint256 value, uint256 final_tokens, uint256 initial_tokens, uint256 bonus);
604 
605     function OrigamiTokenSale(uint256 _presaleStartTime, uint256 _presaleEndTime, uint256 _startTime, uint256 _endTime, uint256 _firstWeekEndTime, uint256 _secondWeekEndTime) public
606       WhitelistedCrowdsale()
607       CappedCrowdsale(HARD_CAP_IN_WEI)
608       StandardCrowdsale(_startTime, _endTime, RATE_ETH_ORI, ORIGAMI_WALLET)
609     {
610         // create the token
611         token = createTokenContract();
612         // Get presale start / end time
613         presaleStartTime = _presaleStartTime;
614         presaleEndTime = _presaleEndTime;
615         firstWeekEndTime = _firstWeekEndTime;
616         secondWeekEndTime = _secondWeekEndTime;
617 
618         // transfer token to bountry wallet
619         token.transfer(BOUNTY_WALLET, BOUNTY_AMOUNT);
620     }
621     
622     /**
623      * @dev return if the presale is open
624      */
625     function preSaleOpen() 
626         public
627         view 
628         returns(bool)
629     {
630         return (now >= presaleStartTime && now <= presaleEndTime && preSaleWeiRaised < HARD_CAP_IN_WEI_PRESALE);
631     }
632     
633     /**
634      * @dev return the sale ended at time
635      */
636     function preSaleEndedAt() 
637         public
638         view 
639         returns(uint256)
640     {
641         return presaleEndedAt;
642     }
643     
644     /**
645      * @dev return if the sale is open
646      */
647     function saleOpen() 
648         public
649         view 
650         returns(bool)
651     {
652         return (now >= startTime && now <= endTime);
653     }
654     
655     /**
656      * @dev get invested amount for an address
657      * @param _address address of the wallet
658      */
659     function getInvestedAmount(address _address)
660     public
661     view
662     returns (uint256)
663     {
664         uint256 investedAmount = wei_invested_by_contributor_in_presale[_address];
665         investedAmount = investedAmount.add(wei_invested_by_contributor_in_sale[_address]);
666         return investedAmount;
667     }
668 
669     /**
670      * @dev Get bonus from an invested amount
671      * @param _weiAmount weiAmount that will be invested
672      */
673     function getBonusFactor(uint256 _weiAmount)
674         private view returns(uint256)
675     {
676         // declaration bonuses
677         uint256 bonus = 0;
678 
679         // If presale : bonus 15% otheriwse bonus on volume
680         if(now >= presaleStartTime && now <= presaleEndTime) {
681             bonus = 15;
682         //si week 1 : 10%
683         } else {        
684           // Bonus 20 % if ETH >= 200
685           if(_weiAmount >= BONUS_TWENTY_AMOUNT) {
686               bonus = 20;
687           }
688           //  Bonus 10 % if ETH >= 100 or first week
689           else if(_weiAmount >= BONUS_TEN_AMOUNT || now <= firstWeekEndTime) {
690               bonus = 10;
691           }
692           // Bonus 10 % if ETH >= 20 or second week
693           else if(_weiAmount >= BONUS_FIVE_AMOUNT || now <= secondWeekEndTime) {
694               bonus = 5;
695           }
696         }
697         
698         return bonus;
699     }
700     
701     // ORI : token are not mintable, transfer to wallet instead
702     function buyTokens() 
703        public 
704        payable 
705     {
706         require(validPurchase());
707         uint256 weiAmount = msg.value;
708 
709         // calculate token amount to be created
710         uint256 tokens = weiAmount.mul(rate);
711 
712         //get bonus
713         uint256 bonus = getBonusFactor(weiAmount);
714         
715         // Calculate final bonus amount
716         uint256 final_bonus_amount = (tokens * bonus) / 100;
717         
718          // Transfer bonus tokens to buyer and tokens
719         uint256 final_tokens = tokens.add(final_bonus_amount);
720         // Transfer token with bonus to buyer
721         require(token.transfer(msg.sender, final_tokens)); 
722 
723          // Trigger event
724         OrigamiTokenPurchase(msg.sender, weiAmount, final_tokens, tokens, final_bonus_amount);
725 
726         // Forward funds to team wallet
727         forwardFunds();
728 
729         // update state
730         weiRaised = weiRaised.add(weiAmount);
731 
732         // If cap reached, set end time to be able to transfer after x days
733         if (preSaleOpen()) {
734             wei_invested_by_contributor_in_presale[msg.sender] =  wei_invested_by_contributor_in_presale[msg.sender].add(weiAmount);
735             preSaleWeiRaised = preSaleWeiRaised.add(weiAmount);
736             if(weiRaised >= HARD_CAP_IN_WEI_PRESALE){
737                 presaleEndedAt = now;
738             }
739         }else{
740             wei_invested_by_contributor_in_sale[msg.sender] =  wei_invested_by_contributor_in_sale[msg.sender].add(weiAmount);  
741             if(weiRaised >= HARD_CAP_IN_WEI){
742               endTime = now;
743             }
744         }
745     }
746 
747 
748     /**
749      * 
750      * @return the StandardToken created
751      */
752     function createTokenContract () 
753       internal 
754       returns(StandardToken) 
755     {
756         return new OrigamiToken(TOTAL_ORI_TOKEN_SUPPLY, endTime.add(PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC), ORIGAMI_WALLET, BOUNTY_WALLET);
757     }
758 
759     // fallback function can be used to buy tokens
760     function () external
761        payable 
762     {
763         buyTokens();
764     }
765     
766     /**
767      * @dev Returns the remaining possibled presale amount for a given wallet
768      * @return amount remaining
769      */
770     function getContributorRemainingPresaleAmount(address wallet) public view returns(uint256) {
771         uint256 invested_amount =  wei_invested_by_contributor_in_presale[wallet];
772         return CONTRIBUTOR_MAX_PRESALE_CONTRIBUTION - invested_amount;
773     }
774     
775         /**
776      * @dev Returns the remaining possibled sale amount for a given wallet
777      * @return amount remaining
778      */
779     function getContributorRemainingSaleAmount(address wallet) public view returns(uint256) {
780         uint256 invested_amount =  wei_invested_by_contributor_in_sale[wallet];
781         return CONTRIBUTOR_MAX_SALE_CONTRIBUTION - invested_amount;
782     }
783 
784     /**
785      * @dev Transfer the unsold tokens to the origami team
786      * @dev Only for owner
787      * @return the StandardToken created
788      */
789     function drainRemainingToken () 
790       public
791       onlyOwner
792     {
793         require(hasEnded());
794         token.transfer(ORIGAMI_WALLET, token.balanceOf(this));
795     }
796     
797     /**
798      * @dev test if the purchase can be operated
799      */
800     function validPurchase () internal view returns(bool) 
801     {
802         // if presale, add to wei raise by contributor
803         if (preSaleOpen()) {
804             // Test presale Cap
805             if(preSaleWeiRaised > HARD_CAP_IN_WEI_PRESALE){
806                 return false;
807             }
808             // Test minimum investing for contributor in presale
809             if(msg.value < MINIMUM_INVEST_IN_WEI_PRESALE){
810                  return false;
811             }
812             // Test global invested amount for presale per contributor
813             uint256 maxInvestAmount = getContributorRemainingPresaleAmount(msg.sender);
814             if(msg.value > maxInvestAmount){
815               return false;
816             }
817         }else if(saleOpen()){
818             // Test minimum investing for contributor in presale
819             if(msg.value < MINIMUM_INVEST_IN_WEI_SALE){
820                  return false;
821             }
822             
823              //Test global invested amount for sale per contributor
824              uint256 maxInvestAmountSale = getContributorRemainingSaleAmount(msg.sender);
825              if(msg.value > maxInvestAmountSale){
826                return false;
827             }
828         }else{
829             return false;
830         }
831 
832         //Check if we are in Presale and Presale hard cap not reached yet
833         bool nonZeroPurchase = msg.value != 0;
834         return super.validPurchase() && nonZeroPurchase;
835     }
836 
837 }