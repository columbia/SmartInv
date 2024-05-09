1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Pausable is Ownable {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    */
79   modifier whenNotPaused() {
80     require(!paused);
81     _;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is paused.
86    */
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   /**
93    * @dev called by the owner to pause, triggers stopped state
94    */
95   function pause() onlyOwner whenNotPaused public {
96     paused = true;
97     Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused public {
104     paused = false;
105     Unpause();
106   }
107 }
108 
109 contract GimmerTokenSale is Pausable {
110     using SafeMath for uint256;
111 
112     /**
113     * @dev Supporter structure, which allows us to track
114     * how much the user has bought so far, and if he's flagged as known
115     */
116     struct Supporter {
117         uint256 weiSpent; // the total amount of Wei this address has sent to this contract
118         bool hasKYC; // if the user has KYC flagged
119     }
120 
121     // Variables
122     mapping(address => Supporter) public supportersMap; // Mapping with all the campaign supporters
123     GimmerToken public token; // ERC20 GMR Token contract address
124     address public fundWallet; // Wallet address to forward all Ether to
125     address public kycManagerWallet; // Wallet address that manages the approval of KYC
126     uint256 public tokensSold; // How many tokens sold have been sold in total
127     uint256 public weiRaised; // Total amount of raised money in Wei
128     uint256 public maxTxGas; // Maximum transaction gas price allowed for fair-chance transactions
129     uint256 public saleWeiLimitWithoutKYC; // The maximum amount of Wei an address can spend here without needing KYC approval during CrowdSale
130     bool public finished; // Flag denoting the owner has invoked finishContract()
131 
132     uint256 public constant ONE_MILLION = 1000000; // One million for token cap calculation reference
133     uint256 public constant PRE_SALE_GMR_TOKEN_CAP = 15 * ONE_MILLION * 1 ether; // Maximum amount that can be sold during the Pre Sale period
134     uint256 public constant GMR_TOKEN_SALE_CAP = 100 * ONE_MILLION * 1 ether; // Maximum amount of tokens that can be sold by this contract
135     uint256 public constant MIN_ETHER = 0.1 ether; // Minimum ETH Contribution allowed during the crowd sale
136 
137     /* Allowed Contribution in Ether */
138     uint256 public constant PRE_SALE_30_ETH = 30 ether; // Minimum 30 Ether to get 25% Bonus Tokens
139     uint256 public constant PRE_SALE_300_ETH = 300 ether; // Minimum 300 Ether to get 30% Bonus Tokens
140     uint256 public constant PRE_SALE_1000_ETH = 1000 ether; // Minimum 3000 Ether to get 40% Bonus Tokens
141 
142     /* Bonus Tokens based on the ETH Contributed in single transaction */
143     uint256 public constant TOKEN_RATE_BASE_RATE = 2500; // Base Price for reference only
144     uint256 public constant TOKEN_RATE_05_PERCENT_BONUS = 2625; // 05% Bonus Tokens During Crowd Sale's Week 4
145     uint256 public constant TOKEN_RATE_10_PERCENT_BONUS = 2750; // 10% Bonus Tokens During Crowd Sale's Week 3
146     uint256 public constant TOKEN_RATE_15_PERCENT_BONUS = 2875; // 15% Bonus Tokens During Crowd Sale'sWeek 2
147     uint256 public constant TOKEN_RATE_20_PERCENT_BONUS = 3000; // 20% Bonus Tokens During Crowd Sale'sWeek 1
148     uint256 public constant TOKEN_RATE_25_PERCENT_BONUS = 3125; // 25% Bonus Tokens, During PreSale when >= 30 ETH & < 300 ETH
149     uint256 public constant TOKEN_RATE_30_PERCENT_BONUS = 3250; // 30% Bonus Tokens, During PreSale when >= 300 ETH & < 3000 ETH
150     uint256 public constant TOKEN_RATE_40_PERCENT_BONUS = 3500; // 40% Bonus Tokens, During PreSale when >= 3000 ETH
151 
152     /* Timestamps where investments are allowed */
153     uint256 public constant PRE_SALE_START_TIME = 1516190400; // PreSale Start Time : UTC: Wednesday, 17 January 2018 12:00:00 
154     uint256 public constant PRE_SALE_END_TIME = 1517400000; // PreSale End Time : UTC: Wednesday, 31 January 2018 12:00:00
155     uint256 public constant START_WEEK_1 = 1517486400; // CrowdSale Start Week-1 : UTC: Thursday, 1 February 2018 12:00:00
156     uint256 public constant START_WEEK_2 = 1518091200; // CrowdSale Start Week-2 : UTC: Thursday, 8 February 2018 12:00:00
157     uint256 public constant START_WEEK_3 = 1518696000; // CrowdSale Start Week-3 : UTC: Thursday, 15 February 2018 12:00:00
158     uint256 public constant START_WEEK_4 = 1519300800; // CrowdSale Start Week-4 : UTC: Thursday, 22 February 2018 12:00:00
159     uint256 public constant SALE_END_TIME = 1519905600; // CrowdSale End Time : UTC: Thursday, 1 March 2018 12:00:00
160 
161     /**
162     * @dev Modifier to only allow KYCManager Wallet
163     * to execute a function
164     */
165     modifier onlyKycManager() {
166         require(msg.sender == kycManagerWallet);
167         _;
168     }
169 
170     /**
171     * Event for token purchase logging
172     * @param purchaser The wallet address that bought the tokens
173     * @param value How many Weis were paid for the purchase
174     * @param amount The amount of tokens purchased
175     */
176     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
177 
178     /**
179      * Event for kyc status change logging
180      * @param user User who has had his KYC status changed
181      * @param isApproved A boolean representing the KYC approval the user has been changed to
182      */
183     event KYC(address indexed user, bool isApproved);
184 
185     /**
186      * Constructor
187      * @param _fundWallet Address to forward all received Ethers to
188      * @param _kycManagerWallet KYC Manager wallet to approve / disapprove user's KYC
189      * @param _saleWeiLimitWithoutKYC Maximum amount of Wei an address can spend in the contract without KYC during the crowdsale
190      * @param _maxTxGas Maximum gas price a transaction can have before being reverted
191      */
192     function GimmerTokenSale(
193         address _fundWallet, 
194         address _kycManagerWallet,
195         uint256 _saleWeiLimitWithoutKYC, 
196         uint256 _maxTxGas
197     )
198     public 
199     {
200         require(_fundWallet != address(0));
201         require(_kycManagerWallet != address(0));
202         require(_saleWeiLimitWithoutKYC > 0);
203         require(_maxTxGas > 0);
204 
205         fundWallet = _fundWallet;
206         kycManagerWallet = _kycManagerWallet;
207         saleWeiLimitWithoutKYC = _saleWeiLimitWithoutKYC;
208         maxTxGas = _maxTxGas;
209 
210         token = new GimmerToken();
211     }
212 
213     /* fallback function can be used to buy tokens */
214     function () public payable {
215         buyTokens();
216     }
217 
218     /* low level token purchase function */
219     function buyTokens() public payable whenNotPaused {
220         // Do not allow if gasprice is bigger than the maximum
221         // This is for fair-chance for all contributors, so no one can
222         // set a too-high transaction price and be able to buy earlier
223         require(tx.gasprice <= maxTxGas);
224         // valid purchase identifies which stage the contract is at (PreState/Token Sale)
225         // making sure were inside the contribution period and the user
226         // is sending enough Wei for the stage's rules
227         require(validPurchase());
228 
229         address sender = msg.sender;
230         uint256 weiAmountSent = msg.value;
231 
232         // calculate token amount to be created
233         uint256 rate = getRate(weiAmountSent);
234         uint256 newTokens = weiAmountSent.mul(rate);
235 
236         // look if we have not yet reached the cap
237         uint256 totalTokensSold = tokensSold.add(newTokens);
238         if (isCrowdSaleRunning()) {
239             require(totalTokensSold <= GMR_TOKEN_SALE_CAP);
240         } else if (isPreSaleRunning()) { 
241             require(totalTokensSold <= PRE_SALE_GMR_TOKEN_CAP);
242         }
243 
244         // update supporter state
245         Supporter storage sup = supportersMap[sender];
246         uint256 totalWei = sup.weiSpent.add(weiAmountSent);
247         sup.weiSpent = totalWei;
248 
249         // update contract state
250         weiRaised = weiRaised.add(weiAmountSent);
251         tokensSold = totalTokensSold;
252 
253         // mint the coins
254         token.mint(sender, newTokens);
255         TokenPurchase(sender, weiAmountSent, newTokens);
256 
257         // forward the funds to the wallet
258         fundWallet.transfer(msg.value);
259     }
260 
261     /**
262     * @dev Ends the operation of the contract
263     */
264     function finishContract() public onlyOwner {
265         // make sure the contribution period has ended
266         require(now > SALE_END_TIME);
267         require(!finished);
268 
269         finished = true;
270 
271         // send the 10% commission to Gimmer's fund wallet
272         uint256 tenPC = tokensSold.div(10);
273         token.mint(fundWallet, tenPC);
274 
275         // finish the minting of the token, so the system allows transfers
276         token.finishMinting();
277 
278         // transfer ownership of the token contract to the fund wallet,
279         // so it isn't locked to be a child of the crowd sale contract
280         token.transferOwnership(fundWallet);
281     }
282 
283     function setSaleWeiLimitWithoutKYC(uint256 _newSaleWeiLimitWithoutKYC) public onlyKycManager {
284         require(_newSaleWeiLimitWithoutKYC > 0);
285         saleWeiLimitWithoutKYC = _newSaleWeiLimitWithoutKYC;
286     }
287 
288     /**
289     * @dev Updates the maximum allowed transaction cost that can be received
290     * on the buyTokens() function.
291     * @param _newMaxTxGas The new maximum transaction cost
292     */
293     function updateMaxTxGas(uint256 _newMaxTxGas) public onlyKycManager {
294         require(_newMaxTxGas > 0);
295         maxTxGas = _newMaxTxGas;
296     }
297 
298     /**
299     * @dev Flag an user as known
300     * @param _user The user to flag as known
301     */
302     function approveUserKYC(address _user) onlyKycManager public {
303         require(_user != address(0));
304 
305         Supporter storage sup = supportersMap[_user];
306         sup.hasKYC = true;
307         KYC(_user, true);
308     }
309 
310     /**
311      * @dev Flag an user as unknown/disapproved
312      * @param _user The user to flag as unknown / suspecious
313      */
314     function disapproveUserKYC(address _user) onlyKycManager public {
315         require(_user != address(0));
316         
317         Supporter storage sup = supportersMap[_user];
318         sup.hasKYC = false;
319         KYC(_user, false);
320     }
321 
322     /**
323     * @dev Changes the KYC manager to a new address
324     * @param _newKYCManagerWallet The new address that will be managing KYC approval
325     */
326     function setKYCManager(address _newKYCManagerWallet) onlyOwner public {
327         require(_newKYCManagerWallet != address(0));
328         kycManagerWallet = _newKYCManagerWallet;
329     }
330     
331     /**
332     * @dev Returns true if any of the token sale stages are currently running
333     * @return A boolean representing the state of this contract
334     */
335     function isTokenSaleRunning() public constant returns (bool) {
336         return (isPreSaleRunning() || isCrowdSaleRunning());
337     }
338 
339     /**
340     * @dev Returns true if the presale sale is currently running
341     * @return A boolean representing the state of the presale
342     */
343     function isPreSaleRunning() public constant returns (bool) {
344         return (now >= PRE_SALE_START_TIME && now < PRE_SALE_END_TIME);
345     }
346 
347     /**
348     * @dev Returns true if the public sale is currently running
349     * @return A boolean representing the state of the crowd sale
350     */
351     function isCrowdSaleRunning() public constant returns (bool) {
352         return (now >= START_WEEK_1 && now <= SALE_END_TIME);
353     }
354 
355     /**
356     * @dev Returns true if the public sale has ended
357     * @return A boolean representing if we are past the contribution date for this contract
358     */
359     function hasEnded() public constant returns (bool) {
360         return now > SALE_END_TIME;
361     }
362 
363     /**
364     * @dev Returns true if the pre sale has ended
365     * @return A boolean representing if we are past the pre sale contribution dates
366     */
367     function hasPreSaleEnded() public constant returns (bool) {
368         return now > PRE_SALE_END_TIME;
369     }
370 
371     /**
372     * @dev Returns if an user has KYC approval or not
373     * @return A boolean representing the user's KYC status
374     */
375     function userHasKYC(address _user) public constant returns (bool) {
376         return supportersMap[_user].hasKYC;
377     }
378 
379     /**
380      * @dev Returns the weiSpent of a user
381      */
382     function userWeiSpent(address _user) public constant returns (uint256) {
383         return supportersMap[_user].weiSpent;
384     }
385 
386     /**
387      * @dev Returns the rate the user will be paying at,
388      * based on the amount of Wei sent to the contract, and the current time
389      * @return An uint256 representing the rate the user will pay for the GMR tokens
390      */
391     function getRate(uint256 _weiAmount) internal constant returns (uint256) {   
392         if (isCrowdSaleRunning()) {
393             if (now >= START_WEEK_4) { return TOKEN_RATE_05_PERCENT_BONUS; }
394             else if (now >= START_WEEK_3) { return TOKEN_RATE_10_PERCENT_BONUS; }
395             else if (now >= START_WEEK_2) { return TOKEN_RATE_15_PERCENT_BONUS; }
396             else if (now >= START_WEEK_1) { return TOKEN_RATE_20_PERCENT_BONUS; }
397         }
398         else if (isPreSaleRunning()) {
399             if (_weiAmount >= PRE_SALE_1000_ETH) { return TOKEN_RATE_40_PERCENT_BONUS; }
400             else if (_weiAmount >= PRE_SALE_300_ETH) { return TOKEN_RATE_30_PERCENT_BONUS; }
401             else if (_weiAmount >= PRE_SALE_30_ETH) { return TOKEN_RATE_25_PERCENT_BONUS; }
402         }
403     }
404 
405     /* @return true if the transaction can buy tokens, otherwise false */
406     function validPurchase() internal constant returns (bool) {
407         bool userHasKyc = userHasKYC(msg.sender);
408 
409         if (isCrowdSaleRunning()) {
410             // crowdsale restrictions (KYC only needed after wei limit, minimum of 0.1 ETH tx)
411             if(!userHasKyc) {
412                 Supporter storage sup = supportersMap[msg.sender];
413                 uint256 ethContribution = sup.weiSpent.add(msg.value);
414                 if (ethContribution > saleWeiLimitWithoutKYC) {
415                     return false;
416                 }
417             }
418             return msg.value >= MIN_ETHER;
419         }
420         else if (isPreSaleRunning()) {
421             // presale restrictions (at least 30 eth, always KYC)
422             return userHasKyc && msg.value >= PRE_SALE_30_ETH;
423         } else {
424             return false;
425         }
426     }
427 }
428 
429 contract ERC20Basic {
430   uint256 public totalSupply;
431   function balanceOf(address who) public view returns (uint256);
432   function transfer(address to, uint256 value) public returns (bool);
433   event Transfer(address indexed from, address indexed to, uint256 value);
434 }
435 
436 contract BasicToken is ERC20Basic {
437   using SafeMath for uint256;
438 
439   mapping(address => uint256) balances;
440 
441   /**
442   * @dev transfer token for a specified address
443   * @param _to The address to transfer to.
444   * @param _value The amount to be transferred.
445   */
446   function transfer(address _to, uint256 _value) public returns (bool) {
447     require(_to != address(0));
448     require(_value <= balances[msg.sender]);
449 
450     // SafeMath.sub will throw if there is not enough balance.
451     balances[msg.sender] = balances[msg.sender].sub(_value);
452     balances[_to] = balances[_to].add(_value);
453     Transfer(msg.sender, _to, _value);
454     return true;
455   }
456 
457   /**
458   * @dev Gets the balance of the specified address.
459   * @param _owner The address to query the the balance of.
460   * @return An uint256 representing the amount owned by the passed address.
461   */
462   function balanceOf(address _owner) public view returns (uint256 balance) {
463     return balances[_owner];
464   }
465 
466 }
467 
468 contract ERC20 is ERC20Basic {
469   function allowance(address owner, address spender) public view returns (uint256);
470   function transferFrom(address from, address to, uint256 value) public returns (bool);
471   function approve(address spender, uint256 value) public returns (bool);
472   event Approval(address indexed owner, address indexed spender, uint256 value);
473 }
474 
475 contract StandardToken is ERC20, BasicToken {
476 
477   mapping (address => mapping (address => uint256)) internal allowed;
478 
479 
480   /**
481    * @dev Transfer tokens from one address to another
482    * @param _from address The address which you want to send tokens from
483    * @param _to address The address which you want to transfer to
484    * @param _value uint256 the amount of tokens to be transferred
485    */
486   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
487     require(_to != address(0));
488     require(_value <= balances[_from]);
489     require(_value <= allowed[_from][msg.sender]);
490 
491     balances[_from] = balances[_from].sub(_value);
492     balances[_to] = balances[_to].add(_value);
493     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
494     Transfer(_from, _to, _value);
495     return true;
496   }
497 
498   /**
499    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
500    *
501    * Beware that changing an allowance with this method brings the risk that someone may use both the old
502    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
503    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
504    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
505    * @param _spender The address which will spend the funds.
506    * @param _value The amount of tokens to be spent.
507    */
508   function approve(address _spender, uint256 _value) public returns (bool) {
509     allowed[msg.sender][_spender] = _value;
510     Approval(msg.sender, _spender, _value);
511     return true;
512   }
513 
514   /**
515    * @dev Function to check the amount of tokens that an owner allowed to a spender.
516    * @param _owner address The address which owns the funds.
517    * @param _spender address The address which will spend the funds.
518    * @return A uint256 specifying the amount of tokens still available for the spender.
519    */
520   function allowance(address _owner, address _spender) public view returns (uint256) {
521     return allowed[_owner][_spender];
522   }
523 
524   /**
525    * @dev Increase the amount of tokens that an owner allowed to a spender.
526    *
527    * approve should be called when allowed[_spender] == 0. To increment
528    * allowed value is better to use this function to avoid 2 calls (and wait until
529    * the first transaction is mined)
530    * From MonolithDAO Token.sol
531    * @param _spender The address which will spend the funds.
532    * @param _addedValue The amount of tokens to increase the allowance by.
533    */
534   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
535     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
536     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
537     return true;
538   }
539 
540   /**
541    * @dev Decrease the amount of tokens that an owner allowed to a spender.
542    *
543    * approve should be called when allowed[_spender] == 0. To decrement
544    * allowed value is better to use this function to avoid 2 calls (and wait until
545    * the first transaction is mined)
546    * From MonolithDAO Token.sol
547    * @param _spender The address which will spend the funds.
548    * @param _subtractedValue The amount of tokens to decrease the allowance by.
549    */
550   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
551     uint oldValue = allowed[msg.sender][_spender];
552     if (_subtractedValue > oldValue) {
553       allowed[msg.sender][_spender] = 0;
554     } else {
555       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
556     }
557     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
558     return true;
559   }
560 
561 }
562 
563 contract MintableToken is StandardToken, Ownable {
564   event Mint(address indexed to, uint256 amount);
565   event MintFinished();
566 
567   bool public mintingFinished = false;
568 
569 
570   modifier canMint() {
571     require(!mintingFinished);
572     _;
573   }
574 
575   /**
576    * @dev Function to mint tokens
577    * @param _to The address that will receive the minted tokens.
578    * @param _amount The amount of tokens to mint.
579    * @return A boolean that indicates if the operation was successful.
580    */
581   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
582     totalSupply = totalSupply.add(_amount);
583     balances[_to] = balances[_to].add(_amount);
584     Mint(_to, _amount);
585     Transfer(address(0), _to, _amount);
586     return true;
587   }
588 
589   /**
590    * @dev Function to stop minting new tokens.
591    * @return True if the operation was successful.
592    */
593   function finishMinting() onlyOwner canMint public returns (bool) {
594     mintingFinished = true;
595     MintFinished();
596     return true;
597   }
598 }
599 
600 contract GimmerToken is MintableToken  {
601     // Constants
602     string public constant name = "GimmerToken";
603     string public constant symbol = "GMR";  
604     uint8 public constant decimals = 18;
605 
606     /**
607     * @dev Modifier to only allow transfers after the minting has been done
608     */
609     modifier onlyWhenTransferEnabled() {
610         require(mintingFinished);
611         _;
612     }
613 
614     modifier validDestination(address _to) {
615         require(_to != address(0x0));
616         require(_to != address(this));
617         _;
618     }
619 
620     function GimmerToken() public {
621     }
622 
623     function transferFrom(address _from, address _to, uint256 _value) public        
624         onlyWhenTransferEnabled
625         validDestination(_to)         
626         returns (bool) {
627         return super.transferFrom(_from, _to, _value);
628     }
629 
630     function approve(address _spender, uint256 _value) public
631         onlyWhenTransferEnabled         
632         returns (bool) {
633         return super.approve(_spender, _value);
634     }
635 
636     function increaseApproval (address _spender, uint _addedValue) public
637         onlyWhenTransferEnabled         
638         returns (bool) {
639         return super.increaseApproval(_spender, _addedValue);
640     }
641 
642     function decreaseApproval (address _spender, uint _subtractedValue) public
643         onlyWhenTransferEnabled         
644         returns (bool) {
645         return super.decreaseApproval(_spender, _subtractedValue);
646     }
647 
648     function transfer(address _to, uint256 _value) public
649         onlyWhenTransferEnabled
650         validDestination(_to)         
651         returns (bool) {
652         return super.transfer(_to, _value);
653     }
654 }