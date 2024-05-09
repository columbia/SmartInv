1 pragma solidity 0.4.15;
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
19   function Ownable() {
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
49   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20Basic {
80   uint256 public totalSupply;
81   function balanceOf(address who) public constant returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public constant returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151 
152     uint256 _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // require (_value <= _allowance);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval (address _spender, uint _addedValue)
197     returns (bool success) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval (address _spender, uint _subtractedValue)
204     returns (bool success) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 }
215 
216 /**
217  * @title StandardCrowdsale 
218  * @dev StandardCrowdsale is a base contract for managing a token crowdsale.
219  * Crowdsales have a start and end timestamps, where investors can make
220  * token purchases and the crowdsale will assign them tokens based
221  * on a token per ETH rate. Funds collected are forwarded to a wallet
222  * as they arrive.
223  * @dev from Crowdsale by Zepellin with small changes. Changes are commented with "Request Modification"
224  */
225 contract StandardCrowdsale {
226     using SafeMath for uint256;
227 
228     // The token being sold
229     StandardToken public token; // Request Modification : change to not mintable
230 
231     // start and end timestamps where investments are allowed (both inclusive)
232     uint256 public startTime;
233     uint256 public endTime;
234 
235     // address where funds are collected
236     address public wallet;
237 
238     // how many token units a buyer gets per wei
239     uint256 public rate;
240 
241     // amount of raised money in wei
242     uint256 public weiRaised;
243 
244     /**
245      * event for token purchase logging
246      * @param purchaser who paid for the tokens
247      * @param value weis paid for purchase
248      * @param amount amount of tokens purchased
249      */
250     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
251 
252     function StandardCrowdsale(
253         uint256 _startTime, 
254         uint256 _endTime, 
255         uint256 _rate, 
256         address _wallet) 
257     {
258         require(_startTime >= now);
259         require(_endTime >= _startTime);
260         require(_rate > 0);
261         require(_wallet != 0x0);
262 
263         startTime = _startTime;
264         endTime = _endTime;
265         rate = _rate;
266         wallet = _wallet;
267 
268         token = createTokenContract(); // Request Modification : change to StandardToken + position
269     }
270 
271     // creates the token to be sold.
272     // Request Modification : change to StandardToken
273     // override this method to have crowdsale of a specific mintable token.
274     function createTokenContract() 
275         internal 
276         returns(StandardToken) 
277     {
278         return new StandardToken();
279     }
280 
281     // fallback function can be used to buy tokens
282     function () 
283        payable 
284     {
285         buyTokens();
286     }
287 
288     // low level token purchase function
289     // Request Modification : change to not mint but transfer from this contract
290     function buyTokens() 
291        public 
292        payable 
293     {
294         require(validPurchase());
295 
296         uint256 weiAmount = msg.value;
297 
298         // calculate token amount to be created
299         uint256 tokens = weiAmount.mul(rate);
300 
301         // update state
302         weiRaised = weiRaised.add(weiAmount);
303 
304         require(token.transfer(msg.sender, tokens)); // Request Modification : changed here - tranfer instead of mintable
305         TokenPurchase(msg.sender, weiAmount, tokens);
306 
307         forwardFunds();
308     }
309 
310     // send ether to the fund collection wallet
311     // override to create custom fund forwarding mechanisms
312     function forwardFunds() 
313        internal 
314     {
315         wallet.transfer(msg.value);
316     }
317 
318     // @return true if the transaction can buy tokens
319     function validPurchase() 
320         internal 
321         returns(bool) 
322     {
323         bool withinPeriod = now >= startTime && now <= endTime;
324         bool nonZeroPurchase = msg.value != 0;
325         return withinPeriod && nonZeroPurchase;
326     }
327 
328     // @return true if crowdsale event has ended
329     function hasEnded() 
330         public 
331         constant 
332         returns(bool) 
333     {
334         return now > endTime;
335     }
336 
337     modifier onlyBeforeSale() {
338         require(now < startTime);
339         _;
340     }
341 
342     // Request Modification : Add check 24hours before token sale
343     modifier only24HBeforeSale() {
344         require(now < startTime.sub(1 days));
345         _;
346     }
347 }
348 
349 /**
350  * @title CappedCrowdsale
351  * @dev Extension of Crowdsale with a max amount of funds raised
352  */
353 contract CappedCrowdsale is StandardCrowdsale {
354   using SafeMath for uint256;
355 
356   uint256 public cap;
357 
358   function CappedCrowdsale(uint256 _cap) {
359     require(_cap > 0);
360     cap = _cap;
361   }
362 
363   // overriding Crowdsale#validPurchase to add extra cap logic
364   // @return true if investors can buy at the moment
365   // Request Modification : delete constant because needed in son contract
366   function validPurchase() internal returns (bool) {
367     bool withinCap = weiRaised.add(msg.value) <= cap;
368     return super.validPurchase() && withinCap;
369   }
370 
371   // overriding Crowdsale#hasEnded to add cap logic
372   // @return true if crowdsale event has ended
373   function hasEnded() public constant returns (bool) {
374     bool capReached = weiRaised >= cap;
375     return super.hasEnded() || capReached;
376   }
377 }
378 
379 /**
380  * @title ProgressiveIndividualCappedCrowdsale
381  * @dev Extension of Crowdsale with a progressive individual cap
382  * @dev This contract is not made for crowdsale superior to 256 * TIME_PERIOD_IN_SEC
383  * @author Request.network
384  */
385 contract ProgressiveIndividualCappedCrowdsale is StandardCrowdsale, Ownable {
386 
387     uint public constant TIME_PERIOD_IN_SEC = 1 days;
388     uint public constant GAS_LIMIT_IN_WEI = 50000000000 wei; // limit gas price -50 Gwei wales stopper
389     uint256 public baseEthCapPerAddress = 0 ether;
390 
391     mapping(address=>uint) public participated;
392 
393     /**
394      * @dev overriding CappedCrowdsale#validPurchase to add an individual cap
395      * @return true if investors can buy at the moment
396      */
397     function validPurchase() 
398         internal 
399         returns(bool)
400     {
401         require(tx.gasprice <= GAS_LIMIT_IN_WEI);
402         uint ethCapPerAddress = getCurrentEthCapPerAddress();
403         participated[msg.sender] = participated[msg.sender].add(msg.value);
404         return super.validPurchase() && participated[msg.sender] <= ethCapPerAddress;
405     }
406 
407     /**
408      * @dev Set the individual cap for the first day. This function can not be called withing the 24h before the sale for security reasons
409      * @param _baseEthCapPerAddress base cap in wei
410      */
411     function setBaseEthCapPerAddress(uint256 _baseEthCapPerAddress) 
412         public
413         onlyOwner 
414         only24HBeforeSale
415     {
416         baseEthCapPerAddress = _baseEthCapPerAddress;
417     }
418 
419     /**
420      * @dev Get the current individual cap. 
421      * @dev This amount increase everyday in an exponential way. Day 1: base cap, Day 2: 2 * base cap, Day 3: 4 * base cap ...
422      * @return individual cap in wei
423      */
424     function getCurrentEthCapPerAddress() 
425         public
426         constant
427         returns(uint)
428     {
429         if (block.timestamp < startTime) return 0;
430         uint timeSinceStartInSec = block.timestamp.sub(startTime);
431         uint currentPeriod = timeSinceStartInSec.div(TIME_PERIOD_IN_SEC).add(1);
432 
433         // for currentPeriod > 256 will always return baseEthCapPerAddress
434         return (2 ** currentPeriod.sub(1)).mul(baseEthCapPerAddress);
435     }
436 }
437 
438 /**
439  * @title WhitelistedCrowdsale
440  * @dev This is an extension to add whitelist to a crowdsale
441  * @author Request.network
442  *
443  */
444 contract WhitelistedCrowdsale is StandardCrowdsale, Ownable {
445     
446     mapping(address=>bool) public registered;
447 
448     event RegistrationStatusChanged(address target, bool isRegistered);
449 
450     /**
451      * @dev Changes registration status of an address for participation.
452      * @param target Address that will be registered/deregistered.
453      * @param isRegistered New registration status of address.
454      */
455     function changeRegistrationStatus(address target, bool isRegistered)
456         public
457         onlyOwner
458         only24HBeforeSale
459     {
460         registered[target] = isRegistered;
461         RegistrationStatusChanged(target, isRegistered);
462     }
463 
464     /**
465      * @dev Changes registration statuses of addresses for participation.
466      * @param targets Addresses that will be registered/deregistered.
467      * @param isRegistered New registration status of addresses.
468      */
469     function changeRegistrationStatuses(address[] targets, bool isRegistered)
470         public
471         onlyOwner
472         only24HBeforeSale
473     {
474         for (uint i = 0; i < targets.length; i++) {
475             changeRegistrationStatus(targets[i], isRegistered);
476         }
477     }
478 
479     /**
480      * @dev overriding Crowdsale#validPurchase to add whilelist
481      * @return true if investors can buy at the moment, false otherwise
482      */
483     function validPurchase() internal returns (bool) {
484         return super.validPurchase() && registered[msg.sender];
485     }
486 }
487 
488 /**
489  * @title The RequestToken contract
490  * @dev The Request Token contract
491  * @dev inherite from StandardToken and Ownable by Zeppelin
492  * @author Request.network
493  */
494 contract RequestToken is StandardToken, Ownable {
495     string  public  constant name = "Request Token";
496     string  public  constant symbol = "REQ";
497     uint8    public  constant decimals = 18;
498 
499     uint    public  transferableStartTime;
500 
501     address public  tokenSaleContract;
502     address public  earlyInvestorWallet;
503 
504 
505     modifier onlyWhenTransferEnabled() 
506     {
507         if ( now <= transferableStartTime ) {
508             require(msg.sender == tokenSaleContract || msg.sender == earlyInvestorWallet || msg.sender == owner);
509         }
510         _;
511     }
512 
513     modifier validDestination(address to) 
514     {
515         require(to != address(this));
516         _;
517     }
518 
519     function RequestToken(
520         uint tokenTotalAmount, 
521         uint _transferableStartTime, 
522         address _admin, 
523         address _earlyInvestorWallet) 
524     {
525         // Mint all tokens. Then disable minting forever.
526         totalSupply = tokenTotalAmount * (10 ** uint256(decimals));
527 
528         balances[msg.sender] = totalSupply;
529         Transfer(address(0x0), msg.sender, totalSupply);
530 
531         transferableStartTime = _transferableStartTime;
532         tokenSaleContract = msg.sender;
533         earlyInvestorWallet = _earlyInvestorWallet;
534 
535         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
536     }
537 
538     /**
539      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
540      * @param _to The address to transfer to.
541      * @param _value The amount to be transferred.
542      */
543     function transfer(address _to, uint _value)
544         public
545         validDestination(_to)
546         onlyWhenTransferEnabled
547         returns (bool) 
548     {
549         return super.transfer(_to, _value);
550     }
551 
552     /**
553      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
554      * @param _from The address to transfer from.
555      * @param _to The address to transfer to.
556      * @param _value The amount to be transferred.
557      */
558     function transferFrom(address _from, address _to, uint _value)
559         public
560         validDestination(_to)
561         onlyWhenTransferEnabled
562         returns (bool) 
563     {
564         return super.transferFrom(_from, _to, _value);
565     }
566 
567     event Burn(address indexed _burner, uint _value);
568 
569     /**
570      * @dev burn tokens
571      * @param _value The amount to be burned.
572      * @return always true (necessary in case of override)
573      */
574     function burn(uint _value) 
575         public
576         onlyWhenTransferEnabled
577         returns (bool)
578     {
579         balances[msg.sender] = balances[msg.sender].sub(_value);
580         totalSupply = totalSupply.sub(_value);
581         Burn(msg.sender, _value);
582         Transfer(msg.sender, address(0x0), _value);
583         return true;
584     }
585 
586     /**
587      * @dev burn tokens in the behalf of someone
588      * @param _from The address of the owner of the token.
589      * @param _value The amount to be burned.
590      * @return always true (necessary in case of override)
591      */
592     function burnFrom(address _from, uint256 _value) 
593         public
594         onlyWhenTransferEnabled
595         returns(bool) 
596     {
597         assert(transferFrom(_from, msg.sender, _value));
598         return burn(_value);
599     }
600 
601     /**
602      * @dev transfer to owner any tokens send by mistake on this contracts
603      * @param token The address of the token to transfer.
604      * @param amount The amount to be transfered.
605      */
606     function emergencyERC20Drain(ERC20 token, uint amount )
607         public
608         onlyOwner 
609     {
610         token.transfer(owner, amount);
611     }
612 }
613 
614 /**
615  * @title RequestTokenSale
616  * @dev 
617  * We add new features to a base crowdsale using multiple inheritance.
618  * We are using the following extensions:
619  * CappedCrowdsale - sets a max boundary for raised funds
620  * WhitelistedCrowdsale - add a whitelist
621  * ProgressiveIndividualCappedCrowdsale - add a Progressive individual cap
622  *
623  * The code is based on the contracts of Open Zeppelin and we add our contracts : RequestTokenSale, WhiteListedCrowdsale, ProgressiveIndividualCappedCrowdsale and the Request Token
624  *
625  * @author Request.network
626  */
627 contract RequestTokenSale is Ownable, CappedCrowdsale, WhitelistedCrowdsale, ProgressiveIndividualCappedCrowdsale {
628     // hard cap of the token sale in ether
629     uint private constant HARD_CAP_IN_WEI = 100000 ether;
630 
631     // Total of Request Token supply
632     uint public constant TOTAL_REQUEST_TOKEN_SUPPLY = 1000000000;
633 
634     // Token sale rate from ETH to REQ
635     uint private constant RATE_ETH_REQ = 5000;
636 
637     // Token initialy distributed for the team (15%)
638     address public constant TEAM_VESTING_WALLET = 0xA76bC39aE4B88ef203C6Afe3fD219549d86D12f2;
639     uint public constant TEAM_VESTING_AMOUNT = 150000000e18;
640 
641     // Token initialy distributed for the early investor (20%)
642     address public constant EARLY_INVESTOR_WALLET = 0xa579E31b930796e3Df50A56829cF82Db98b6F4B3;
643     uint public constant EARLY_INVESTOR_AMOUNT = 200000000e18;
644 
645     // Token initialy distributed for the early foundation (15%)
646     // wallet use also to gather the ether of the token sale
647     address private constant REQUEST_FOUNDATION_WALLET = 0xdD76B55ee6dAfe0c7c978bff69206d476a5b9Ce7;
648     uint public constant REQUEST_FOUNDATION_AMOUNT = 150000000e18;
649 
650     // PERIOD WHEN TOKEN IS NOT TRANSFERABLE AFTER THE SALE
651     uint public constant PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC = 3 days;
652 
653     function RequestTokenSale(uint256 _startTime, uint256 _endTime)
654       ProgressiveIndividualCappedCrowdsale()
655       WhitelistedCrowdsale()
656       CappedCrowdsale(HARD_CAP_IN_WEI)
657       StandardCrowdsale(_startTime, _endTime, RATE_ETH_REQ, REQUEST_FOUNDATION_WALLET)
658     {
659         token.transfer(TEAM_VESTING_WALLET, TEAM_VESTING_AMOUNT);
660 
661         token.transfer(EARLY_INVESTOR_WALLET, EARLY_INVESTOR_AMOUNT);
662 
663         token.transfer(REQUEST_FOUNDATION_WALLET, REQUEST_FOUNDATION_AMOUNT);
664     }
665 
666     /**
667      * @dev Create the Request token (override createTokenContract of StandardCrowdsale)
668      * @return the StandardToken created
669      */
670     function createTokenContract () 
671       internal 
672       returns(StandardToken) 
673     {
674         return new RequestToken(TOTAL_REQUEST_TOKEN_SUPPLY, endTime.add(PERIOD_AFTERSALE_NOT_TRANSFERABLE_IN_SEC), REQUEST_FOUNDATION_WALLET, EARLY_INVESTOR_WALLET);
675     }
676 
677     /**
678      * @dev Transfer the unsold tokens to the request Foundation multisign wallet 
679      * @dev Only for owner
680      * @return the StandardToken created
681      */
682     function drainRemainingToken () 
683       public
684       onlyOwner
685     {
686         require(hasEnded());
687         token.transfer(REQUEST_FOUNDATION_WALLET, token.balanceOf(this));
688     }
689   
690 }