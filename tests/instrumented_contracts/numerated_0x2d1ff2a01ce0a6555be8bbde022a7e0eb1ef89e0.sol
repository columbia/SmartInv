1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin\math\SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin\token\ERC20\ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin\token\ERC20\BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin\token\ERC20\ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin\token\ERC20\StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: zeppelin\token\ERC20\MintableToken.sol
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 contract MintableToken is StandardToken, Ownable {
273   event Mint(address indexed to, uint256 amount);
274   event MintFinished();
275 
276   bool public mintingFinished = false;
277 
278 
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     totalSupply_ = totalSupply_.add(_amount);
292     balances[_to] = balances[_to].add(_amount);
293     Mint(_to, _amount);
294     Transfer(address(0), _to, _amount);
295     return true;
296   }
297 
298   /**
299    * @dev Function to stop minting new tokens.
300    * @return True if the operation was successful.
301    */
302   function finishMinting() onlyOwner canMint public returns (bool) {
303     mintingFinished = true;
304     MintFinished();
305     return true;
306   }
307 }
308 
309 // File: contracts\GMRToken.sol
310 
311 /**
312 * @title Gimmer Token Smart Contract
313 * @author lucas@gimmer.net, jitendra@chittoda.com
314 */
315 contract GMRToken is MintableToken {
316     // Constants
317     string public constant name = "GimmerToken";
318     string public constant symbol = "GMR";
319     uint8 public constant decimals = 18;
320 
321     /**
322     * @dev Modifier to only allow transfers after the token sale has finished
323     */
324     modifier onlyWhenTransferEnabled() {
325         require(mintingFinished);
326         _;
327     }
328 
329     /**
330     * @dev Modifier to not allow transfers
331     * to 0x0 and to this contract
332     */
333     modifier validDestination(address _to) {
334         require(_to != address(0x0));
335         require(_to != address(this));
336         _;
337     }
338 
339     function GMRToken() public {
340     }
341 
342     function transferFrom(address _from, address _to, uint256 _value) public
343         onlyWhenTransferEnabled
344         validDestination(_to)
345         returns (bool) {
346         return super.transferFrom(_from, _to, _value);
347     }
348 
349     function approve(address _spender, uint256 _value) public
350         onlyWhenTransferEnabled
351         returns (bool) {
352         return super.approve(_spender, _value);
353     }
354 
355     function increaseApproval (address _spender, uint _addedValue) public
356         onlyWhenTransferEnabled
357         returns (bool) {
358         return super.increaseApproval(_spender, _addedValue);
359     }
360 
361     function decreaseApproval (address _spender, uint _subtractedValue) public
362         onlyWhenTransferEnabled
363         returns (bool) {
364         return super.decreaseApproval(_spender, _subtractedValue);
365     }
366 
367     function transfer(address _to, uint256 _value) public
368         onlyWhenTransferEnabled
369         validDestination(_to)
370         returns (bool) {
371         return super.transfer(_to, _value);
372     }
373 }
374 
375 // File: zeppelin\lifecycle\Pausable.sol
376 
377 /**
378  * @title Pausable
379  * @dev Base contract which allows children to implement an emergency stop mechanism.
380  */
381 contract Pausable is Ownable {
382   event Pause();
383   event Unpause();
384 
385   bool public paused = false;
386 
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is not paused.
390    */
391   modifier whenNotPaused() {
392     require(!paused);
393     _;
394   }
395 
396   /**
397    * @dev Modifier to make a function callable only when the contract is paused.
398    */
399   modifier whenPaused() {
400     require(paused);
401     _;
402   }
403 
404   /**
405    * @dev called by the owner to pause, triggers stopped state
406    */
407   function pause() onlyOwner whenNotPaused public {
408     paused = true;
409     Pause();
410   }
411 
412   /**
413    * @dev called by the owner to unpause, returns to normal state
414    */
415   function unpause() onlyOwner whenPaused public {
416     paused = false;
417     Unpause();
418   }
419 }
420 
421 // File: contracts\GimmerToken.sol
422 
423 /**
424 * @title Gimmer Token Smart Contract
425 * @author lucas@gimmer.net, jitendra@chittoda.com
426 */
427 contract GimmerToken is MintableToken {
428     // Constants
429     string public constant name = "GimmerToken";
430     string public constant symbol = "GMR";
431     uint8 public constant decimals = 18;
432 
433     /**
434     * @dev Modifier to only allow transfers after the minting has been done
435     */
436     modifier onlyWhenTransferEnabled() {
437         require(mintingFinished);
438         _;
439     }
440 
441     modifier validDestination(address _to) {
442         require(_to != address(0x0));
443         require(_to != address(this));
444         _;
445     }
446 
447     function GimmerToken() public {
448     }
449 
450     function transferFrom(address _from, address _to, uint256 _value) public
451         onlyWhenTransferEnabled
452         validDestination(_to)
453         returns (bool) {
454         return super.transferFrom(_from, _to, _value);
455     }
456 
457     function approve(address _spender, uint256 _value) public
458         onlyWhenTransferEnabled
459         returns (bool) {
460         return super.approve(_spender, _value);
461     }
462 
463     function increaseApproval (address _spender, uint _addedValue) public
464         onlyWhenTransferEnabled
465         returns (bool) {
466         return super.increaseApproval(_spender, _addedValue);
467     }
468 
469     function decreaseApproval (address _spender, uint _subtractedValue) public
470         onlyWhenTransferEnabled
471         returns (bool) {
472         return super.decreaseApproval(_spender, _subtractedValue);
473     }
474 
475     function transfer(address _to, uint256 _value) public
476         onlyWhenTransferEnabled
477         validDestination(_to)
478         returns (bool) {
479         return super.transfer(_to, _value);
480     }
481 }
482 
483 // File: contracts\GimmerTokenSale.sol
484 
485 /**
486 * @title Gimmer Token Sale Smart Contract
487 * @author lucas@gimmer.net, jitendra@chittoda.com
488 */
489 contract GimmerTokenSale is Pausable {
490     using SafeMath for uint256;
491 
492     /**
493     * @dev Supporter structure, which allows us to track
494     * how much the user has bought so far, and if he's flagged as known
495     */
496     struct Supporter {
497         uint256 weiSpent; // the total amount of Wei this address has sent to this contract
498         bool hasKYC; // if the user has KYC flagged
499     }
500 
501     // Variables
502     mapping(address => Supporter) public supportersMap; // Mapping with all the campaign supporters
503     GimmerToken public token; // ERC20 GMR Token contract address
504     address public fundWallet; // Wallet address to forward all Ether to
505     address public kycManagerWallet; // Wallet address that manages the approval of KYC
506     address public currentAddress; // Wallet address that manages the approval of KYC
507     uint256 public tokensSold; // How many tokens sold have been sold in total
508     uint256 public weiRaised; // Total amount of raised money in Wei
509     uint256 public maxTxGas; // Maximum transaction gas price allowed for fair-chance transactions
510     uint256 public saleWeiLimitWithoutKYC; // The maximum amount of Wei an address can spend here without needing KYC approval during CrowdSale
511     bool public finished; // Flag denoting the owner has invoked finishContract()
512 
513     uint256 public constant ONE_MILLION = 1000000; // One million for token cap calculation reference
514     uint256 public constant PRE_SALE_GMR_TOKEN_CAP = 15 * ONE_MILLION * 1 ether; // Maximum amount that can be sold during the Pre Sale period
515     uint256 public constant GMR_TOKEN_SALE_CAP = 100 * ONE_MILLION * 1 ether; // Maximum amount of tokens that can be sold by this contract
516     uint256 public constant MIN_ETHER = 0.1 ether; // Minimum ETH Contribution allowed during the crowd sale
517 
518     /* Allowed Contribution in Ether */
519     uint256 public constant PRE_SALE_30_ETH = 30 ether; // Minimum 30 Ether to get 25% Bonus Tokens
520     uint256 public constant PRE_SALE_300_ETH = 300 ether; // Minimum 300 Ether to get 30% Bonus Tokens
521     uint256 public constant PRE_SALE_1000_ETH = 1000 ether; // Minimum 3000 Ether to get 40% Bonus Tokens
522 
523     /* Bonus Tokens based on the ETH Contributed in single transaction */
524     uint256 public constant TOKEN_RATE_BASE_RATE = 2500; // Base Price for reference only
525     uint256 public constant TOKEN_RATE_05_PERCENT_BONUS = 2625; // 05% Bonus Tokens During Crowd Sale's Week 4
526     uint256 public constant TOKEN_RATE_10_PERCENT_BONUS = 2750; // 10% Bonus Tokens During Crowd Sale's Week 3
527     uint256 public constant TOKEN_RATE_15_PERCENT_BONUS = 2875; // 15% Bonus Tokens During Crowd Sale'sWeek 2
528     uint256 public constant TOKEN_RATE_20_PERCENT_BONUS = 3000; // 20% Bonus Tokens During Crowd Sale'sWeek 1
529     uint256 public constant TOKEN_RATE_25_PERCENT_BONUS = 3125; // 25% Bonus Tokens, During PreSale when >= 30 ETH & < 300 ETH
530     uint256 public constant TOKEN_RATE_30_PERCENT_BONUS = 3250; // 30% Bonus Tokens, During PreSale when >= 300 ETH & < 3000 ETH
531     uint256 public constant TOKEN_RATE_40_PERCENT_BONUS = 3500; // 40% Bonus Tokens, During PreSale when >= 3000 ETH
532 
533     /* Timestamps where investments are allowed */
534     uint256 public constant PRE_SALE_START_TIME = 1525176000; // PreSale Start Time : UTC: Wednesday, 17 January 2018 12:00:00
535     uint256 public constant PRE_SALE_END_TIME = 1525521600; // PreSale End Time : UTC: Wednesday, 31 January 2018 12:00:00
536     uint256 public constant START_WEEK_1 = 1525608000; // CrowdSale Start Week-1 : UTC: Thursday, 1 February 2018 12:00:00
537     uint256 public constant START_WEEK_2 = 1526040000; // CrowdSale Start Week-2 : UTC: Thursday, 8 February 2018 12:00:00
538     uint256 public constant START_WEEK_3 = 1526472000; // CrowdSale Start Week-3 : UTC: Thursday, 15 February 2018 12:00:00
539     uint256 public constant START_WEEK_4 = 1526904000; // CrowdSale Start Week-4 : UTC: Thursday, 22 February 2018 12:00:00
540     uint256 public constant SALE_END_TIME = 1527336000; // CrowdSale End Time : UTC: Thursday, 1 March 2018 12:00:00
541 
542     /**
543     * @dev Modifier to only allow KYCManager Wallet
544     * to execute a function
545     */
546     modifier onlyKycManager() {
547         require(msg.sender == kycManagerWallet);
548         _;
549     }
550 
551     /**
552     * Event for token purchase logging
553     * @param purchaser The wallet address that bought the tokens
554     * @param value How many Weis were paid for the purchase
555     * @param amount The amount of tokens purchased
556     */
557     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
558 
559     /**
560      * Event for kyc status change logging
561      * @param user User who has had his KYC status changed
562      * @param isApproved A boolean representing the KYC approval the user has been changed to
563      */
564     event KYC(address indexed user, bool isApproved);
565 
566     /**
567      * Constructor
568      * @param _fundWallet Address to forward all received Ethers to
569      * @param _kycManagerWallet KYC Manager wallet to approve / disapprove user's KYC
570      * @param _saleWeiLimitWithoutKYC Maximum amount of Wei an address can spend in the contract without KYC during the crowdsale
571      * @param _maxTxGas Maximum gas price a transaction can have before being reverted
572      */
573     function GimmerTokenSale(
574         address _fundWallet,
575         address _kycManagerWallet,
576         uint256 _saleWeiLimitWithoutKYC,
577         uint256 _maxTxGas
578     )
579     public
580     {
581         require(_fundWallet != address(0));
582         require(_kycManagerWallet != address(0));
583         require(_saleWeiLimitWithoutKYC > 0);
584         require(_maxTxGas > 0);
585 
586         currentAddress = this;
587 
588         fundWallet = _fundWallet;
589         kycManagerWallet = _kycManagerWallet;
590         saleWeiLimitWithoutKYC = _saleWeiLimitWithoutKYC;
591         maxTxGas = _maxTxGas;
592 
593         token = new GimmerToken();
594     }
595 
596     /* fallback function can be used to buy tokens */
597     function () public payable {
598         buyTokens();
599     }
600 
601     /* low level token purchase function */
602     function buyTokens() public payable whenNotPaused {
603         // Do not allow if gasprice is bigger than the maximum
604         // This is for fair-chance for all contributors, so no one can
605         // set a too-high transaction price and be able to buy earlier
606         require(tx.gasprice <= maxTxGas);
607         // valid purchase identifies which stage the contract is at (PreState/Token Sale)
608         // making sure were inside the contribution period and the user
609         // is sending enough Wei for the stage's rules
610         require(validPurchase());
611 
612         address sender = msg.sender;
613         uint256 weiAmountSent = msg.value;
614 
615         // calculate token amount to be created
616         uint256 rate = getRate(weiAmountSent);
617         uint256 newTokens = weiAmountSent.mul(rate);
618 
619         // look if we have not yet reached the cap
620         uint256 totalTokensSold = tokensSold.add(newTokens);
621         if (isCrowdSaleRunning()) {
622             require(totalTokensSold <= GMR_TOKEN_SALE_CAP);
623         } else if (isPreSaleRunning()) {
624             require(totalTokensSold <= PRE_SALE_GMR_TOKEN_CAP);
625         }
626 
627         // update supporter state
628         Supporter storage sup = supportersMap[sender];
629         uint256 totalWei = sup.weiSpent.add(weiAmountSent);
630         sup.weiSpent = totalWei;
631 
632         // update contract state
633         weiRaised = weiRaised.add(weiAmountSent);
634         tokensSold = totalTokensSold;
635 
636         // mint the coins
637         token.mint(sender, newTokens);
638         TokenPurchase(sender, weiAmountSent, newTokens);
639 
640         // forward the funds to the wallet
641         fundWallet.transfer(msg.value);
642     }
643 
644     /**
645     * @dev Ends the operation of the contract
646     */
647     function finishContract() public onlyOwner {
648         // make sure the contribution period has ended
649         require(now > SALE_END_TIME);
650         require(!finished);
651 
652         finished = true;
653 
654         // send the 10% commission to Gimmer's fund wallet
655         uint256 tenPC = tokensSold.div(10);
656         token.mint(fundWallet, tenPC);
657 
658         // finish the minting of the token, so the system allows transfers
659         token.finishMinting();
660 
661         // transfer ownership of the token contract to the fund wallet,
662         // so it isn't locked to be a child of the crowd sale contract
663         token.transferOwnership(fundWallet);
664     }
665 
666     function setSaleWeiLimitWithoutKYC(uint256 _newSaleWeiLimitWithoutKYC) public onlyKycManager {
667         require(_newSaleWeiLimitWithoutKYC > 0);
668         saleWeiLimitWithoutKYC = _newSaleWeiLimitWithoutKYC;
669     }
670 
671     /**
672     * @dev Updates the maximum allowed transaction cost that can be received
673     * on the buyTokens() function.
674     * @param _newMaxTxGas The new maximum transaction cost
675     */
676     function updateMaxTxGas(uint256 _newMaxTxGas) public onlyKycManager {
677         require(_newMaxTxGas > 0);
678         maxTxGas = _newMaxTxGas;
679     }
680 
681     /**
682     * @dev Flag an user as known
683     * @param _user The user to flag as known
684     */
685     function approveUserKYC(address _user) onlyKycManager public {
686         require(_user != address(0));
687 
688         Supporter storage sup = supportersMap[_user];
689         sup.hasKYC = true;
690         KYC(_user, true);
691     }
692 
693     /**
694      * @dev Flag an user as unknown/disapproved
695      * @param _user The user to flag as unknown / suspecious
696      */
697     function disapproveUserKYC(address _user) onlyKycManager public {
698         require(_user != address(0));
699 
700         Supporter storage sup = supportersMap[_user];
701         sup.hasKYC = false;
702         KYC(_user, false);
703     }
704 
705     /**
706     * @dev Changes the KYC manager to a new address
707     * @param _newKYCManagerWallet The new address that will be managing KYC approval
708     */
709     function setKYCManager(address _newKYCManagerWallet) onlyOwner public {
710         require(_newKYCManagerWallet != address(0));
711         kycManagerWallet = _newKYCManagerWallet;
712     }
713 
714     /**
715     * @dev Returns true if any of the token sale stages are currently running
716     * @return A boolean representing the state of this contract
717     */
718     function isTokenSaleRunning() public constant returns (bool) {
719         return (isPreSaleRunning() || isCrowdSaleRunning());
720     }
721 
722     /**
723     * @dev Returns true if the presale sale is currently running
724     * @return A boolean representing the state of the presale
725     */
726     function isPreSaleRunning() public constant returns (bool) {
727         return (now >= PRE_SALE_START_TIME && now < PRE_SALE_END_TIME);
728     }
729 
730     /**
731     * @dev Returns true if the public sale is currently running
732     * @return A boolean representing the state of the crowd sale
733     */
734     function isCrowdSaleRunning() public constant returns (bool) {
735         return (now >= START_WEEK_1 && now <= SALE_END_TIME);
736     }
737 
738     /**
739     * @dev Returns true if the public sale has ended
740     * @return A boolean representing if we are past the contribution date for this contract
741     */
742     function hasEnded() public constant returns (bool) {
743         return now > SALE_END_TIME;
744     }
745 
746     /**
747     * @dev Returns true if the pre sale has ended
748     * @return A boolean representing if we are past the pre sale contribution dates
749     */
750     function hasPreSaleEnded() public constant returns (bool) {
751         return now > PRE_SALE_END_TIME;
752     }
753 
754     /**
755     * @dev Returns if an user has KYC approval or not
756     * @return A boolean representing the user's KYC status
757     */
758     function userHasKYC(address _user) public constant returns (bool) {
759         return supportersMap[_user].hasKYC;
760     }
761 
762     /**
763      * @dev Returns the weiSpent of a user
764      */
765     function userWeiSpent(address _user) public constant returns (uint256) {
766         return supportersMap[_user].weiSpent;
767     }
768 
769     /**
770      * @dev Returns the rate the user will be paying at,
771      * based on the amount of Wei sent to the contract, and the current time
772      * @return An uint256 representing the rate the user will pay for the GMR tokens
773      */
774     function getRate(uint256 _weiAmount) internal constant returns (uint256) {
775         if (isCrowdSaleRunning()) {
776             if (now >= START_WEEK_4) { return TOKEN_RATE_05_PERCENT_BONUS; }
777             else if (now >= START_WEEK_3) { return TOKEN_RATE_10_PERCENT_BONUS; }
778             else if (now >= START_WEEK_2) { return TOKEN_RATE_15_PERCENT_BONUS; }
779             else if (now >= START_WEEK_1) { return TOKEN_RATE_20_PERCENT_BONUS; }
780         }
781         else if (isPreSaleRunning()) {
782             if (_weiAmount >= PRE_SALE_1000_ETH) { return TOKEN_RATE_40_PERCENT_BONUS; }
783             else if (_weiAmount >= PRE_SALE_300_ETH) { return TOKEN_RATE_30_PERCENT_BONUS; }
784             else if (_weiAmount >= PRE_SALE_30_ETH) { return TOKEN_RATE_25_PERCENT_BONUS; }
785         }
786     }
787 
788     /* @return true if the transaction can buy tokens, otherwise false */
789     function validPurchase() internal constant returns (bool) {
790         bool userHasKyc = userHasKYC(msg.sender);
791 
792         if (isCrowdSaleRunning()) {
793             // crowdsale restrictions (KYC only needed after wei limit, minimum of 0.1 ETH tx)
794             if(!userHasKyc) {
795                 Supporter storage sup = supportersMap[msg.sender];
796                 uint256 ethContribution = sup.weiSpent.add(msg.value);
797                 if (ethContribution > saleWeiLimitWithoutKYC) {
798                     return false;
799                 }
800             }
801             return msg.value >= MIN_ETHER;
802         }
803         else if (isPreSaleRunning()) {
804             // presale restrictions (at least 30 eth, always KYC)
805             return userHasKyc && msg.value >= PRE_SALE_30_ETH;
806         } else {
807             return false;
808         }
809     }
810 }
811 
812 // File: contracts\GMRTokenManager.sol
813 
814 /**
815 * @title Gimmer Token Sale Manager Smart Contract
816 * @author lucas@gimmer.net, jitendra@chittoda.com
817 */
818 contract GMRTokenManager is Ownable {
819     using SafeMath for uint256;
820 
821     /* Contracts */
822     GMRToken public token;
823     GimmerTokenSale public oldTokenSale;
824 
825     /* Flags for tracking contract usage */
826     bool public finishedMigration;
827 
828     /* Constants */
829     uint256 public constant TOKEN_BONUS_RATE = 8785; // The rate for the bonus given to precontract contributors
830 
831     /**
832      * Constructor
833      * @param _oldTokenSaleAddress Old Token Sale contract address
834      */
835     function GMRTokenManager(address _oldTokenSaleAddress) public {
836         // access the old token sale
837         oldTokenSale = GimmerTokenSale(_oldTokenSaleAddress);
838 
839         // deploy the token contract
840         token = new GMRToken();
841     }
842 
843     /**
844      * Prepopulates the specified wallet
845      * @param _wallet Wallet to mint the reserve tokens to
846      */
847     function prepopulate(address _wallet) public onlyOwner {
848         require(!finishedMigration);
849         require(_wallet != address(0));
850 
851         // get the balance the user spent in the last sale
852         uint256 spent = oldTokenSale.userWeiSpent(_wallet);
853         require(spent != 0);
854 
855         // make sure we have not prepopulated already
856         uint256 balance = token.balanceOf(_wallet);
857         require(balance == 0);
858 
859         // calculate the new balance with bonus
860         uint256 tokens = spent.mul(TOKEN_BONUS_RATE);
861 
862         // mint the coins
863         token.mint(_wallet, tokens);
864     }
865 
866     /**
867      * Ends the migration process by giving the token
868      * contract back to the owner
869      */
870     function endMigration() public onlyOwner {
871         require(!finishedMigration);
872         finishedMigration = true;
873 
874         token.transferOwnership(owner);
875     }
876 }