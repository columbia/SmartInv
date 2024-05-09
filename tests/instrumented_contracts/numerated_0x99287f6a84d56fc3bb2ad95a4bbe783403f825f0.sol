1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
49   function Ownable() public {
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
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title Basic token
89  * @dev Basic version of StandardToken, with no allowances.
90  */
91 contract BasicToken is ERC20Basic {
92   using SafeMath for uint256;
93 
94   mapping(address => uint256) balances;
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103 
104     // SafeMath.sub will throw if there is not enough balance.
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public constant returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public constant returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142   mapping (address => mapping (address => uint256)) allowed;
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152 
153     uint256 _allowance = allowed[_from][msg.sender];
154 
155     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156     // require (_value <= _allowance);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = _allowance.sub(_value);
161     Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191   /**
192    * approve should be called when allowed[_spender] == 0. To increment
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    */
197   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 }
214 
215 
216 /*****
217 * @title The DADI Presale Contract
218 */
219 contract DadiPreSale is Ownable {
220     using SafeMath for uint256;
221 
222     StandardToken public token;                         // The DADI ERC20 token */
223     address public owner;
224     address[] public preSaleWallets;
225 
226     struct WhitelistUser {
227       uint256 pledged;
228       uint index;
229     }
230 
231     struct Investor {
232       uint256 tokens;
233       uint256 contribution;
234       uint index;
235     }
236 
237     uint256 public tokenSupply;
238     uint256 public tokensPurchased = 0;
239     uint256 public individualCap = 10000 * 1000;        // USD$10,000
240     uint256 public preSaleTokenPrice = 400;             // USD$0.40
241     uint256 public ethRate;                             // ETH to USD Rate, set by owner: 1 ETH = ethRate USD
242  
243     mapping(address => WhitelistUser) private whitelisted;
244     address[] private whitelistedIndex;
245     mapping(address => Investor) private investors;
246     address[] private investorIndex;
247 
248     /*****
249     * State for Sale Modes
250     *  0 - Preparing:            All contract initialization calls
251     *  1 - PreSale:              Contract is in the Presale Period
252     *  2 - PreSaleFinalized      Presale period is finalized, no more payments are allowed
253     *  3 - Success:              Presale Successful
254     *  4 - TokenDistribution:    Presale finished, tokens can be distributed
255     *  5 - Closed:               Presale closed, no tokens more can be distributed
256     */
257     enum SaleState { Preparing, PreSale, PreSaleFinalized, Success, TokenDistribution, Closed }
258     SaleState public state = SaleState.Preparing;
259 
260     /*****
261     * State for Purchase Periods
262     *  0 - Preparing:            All contract initialization calls
263     *  1 - Whitelist:            Only whitelisted users can make payments
264     *  2 - WhitelistApplicant:   Only whitelisted users and whitelist applicants can make payments
265     *  3 - Public:               Sale open to all
266     */
267     enum PurchasePeriod { Preparing, Whitelist, WhitelistApplicant, Public }
268     PurchasePeriod public purchasePeriod = PurchasePeriod.Preparing;
269 
270     /**
271     * event for token purchase logging
272     * @param purchaser who paid for the tokens
273     * @param beneficiary who got the tokens
274     * @param value weis paid for purchase
275     * @param tokens amount of tokens purchased
276     */
277     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
278     event LogTokenDistribution(address recipient, uint256 tokens);
279     event LogRedistributeTokens(address recipient, SaleState _state, uint256 tokens);
280     event LogFundTransfer(address wallet, uint256 value);
281     event LogRefund(address wallet, uint256 value);
282     event LogStateChange(SaleState _state);
283     event LogNewWhitelistUser(address indexed userAddress, uint index, uint256 value);
284 
285     /*****
286     * @dev Modifier to check that amount transferred is not 0
287     */
288     modifier nonZero() {
289         require(msg.value != 0);
290         _;
291     }
292 
293     /*****
294     * @dev The constructor function to initialize the Presale
295     * @param _token                         address   the address of the ERC20 token for the sale
296     * @param _tokenSupply                   uint256   the amount of tokens available
297     */
298     function DadiPreSale (StandardToken _token,uint256 _tokenSupply) public {
299         require(_token != address(0));
300         require(_tokenSupply != 0);
301 
302         owner = msg.sender;
303 
304         token = StandardToken(_token);
305         tokenSupply = _tokenSupply * (uint256(10) ** 18);
306     }
307 
308     /*****
309     * @dev Fallback Function to buy the tokens
310     */
311     function () public nonZero payable {
312         require(state == SaleState.PreSale);
313         buyTokens(msg.sender, msg.value);
314     }
315 
316     /*****
317     * @dev Allows the contract owner to add a new PreSale wallet, used to hold funds safely
318     * @param _wallet        address     The address of the wallet
319     * @return success       bool        Returns true if executed successfully
320     */
321     function addPreSaleWallet (address _wallet) public onlyOwner returns (bool) {
322         require(_wallet != address(0));
323         preSaleWallets.push(_wallet);
324         return true;
325     }
326 
327     /*****
328     * @dev Allows the contract owner to add multiple whitelist users, each with a wallet address and a pledged contribution
329     * @param userAddresses   address[]     The array of whitelist wallet addresses
330     * @param pledges         uint256[]     The array of whitelist pledges
331     */
332     function addWhitelistUsers(address[] userAddresses, uint256[] pledges) public onlyOwner {
333         for (uint i = 0; i < userAddresses.length; i++) {
334             addWhitelistUser(userAddresses[i], pledges[i]);
335         }
336     }
337 
338     /*****
339     * @dev Allows the contract owner to a single whitelist user
340     * @param userAddress     address      The wallet address to whitelist
341     * @param pledged         uint256      The amount pledged by the user
342     */
343     function addWhitelistUser(address userAddress, uint256 pledged) public onlyOwner {
344         if (!isWhitelisted(userAddress)) {
345             whitelisted[userAddress].pledged = pledged * 1000;
346             whitelisted[userAddress].index = whitelistedIndex.push(userAddress) - 1;
347           
348             LogNewWhitelistUser(userAddress, whitelisted[userAddress].index, pledged);
349         }
350     }
351 
352     /*****
353     * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred
354     * @param _amount    uint256     The amount of money invested by the investor
355     * @return tokens    uint256     The number of tokens purchased for the amount invested
356     */
357     function calculateTokens (uint256 _amount) public constant returns (uint256 tokens) {
358         tokens = _amount * ethRate / preSaleTokenPrice;
359         return tokens;
360     }
361 
362     /*****
363     * @dev Called by the owner of the contract to modify the sale state
364     */
365     function setState (uint256 _state) public onlyOwner {
366         state = SaleState(uint(_state));
367         LogStateChange(state);
368     }
369 
370     /*****
371     * @dev Called by the owner of the contract to open the WhitelistApplicant/Public periods
372     */
373     function setPurchasePeriod (uint256 phase) public onlyOwner {
374         purchasePeriod = PurchasePeriod(uint(phase));
375     }
376 
377     /*****
378     * @dev Called by the owner of the contract to start the Presale
379     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
380     */
381     function startPreSale (uint256 rate) public onlyOwner {
382         state = SaleState.PreSale;
383         purchasePeriod = PurchasePeriod.Whitelist;
384         updateEthRate(rate);
385         LogStateChange(state);
386     }
387 
388     /*****
389     * @dev Allow updating the ETH USD exchange rate
390     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
391     * @return bool  Return true if the contract is in PartnerSale Period
392     */
393     function updateEthRate (uint256 rate) public onlyOwner returns (bool) {
394         require(rate >= 100000);
395         
396         ethRate = rate;
397         return true;
398     }
399 
400     /*****
401     * @dev Allows transfer of tokens to a recipient who has purchased offline, during the PreSale
402     * @param _recipient     address     The address of the recipient of the tokens
403     * @param _tokens        uint256     The number of tokens purchased by the recipient
404     * @return success       bool        Returns true if executed successfully
405     */
406     function offlineTransaction (address _recipient, uint256 _tokens) public onlyOwner returns (bool) {
407         require(_tokens > 0);
408 
409         // Convert to a token with decimals 
410         uint256 tokens = _tokens * (uint256(10) ** uint8(18));
411 
412         // if the number of tokens is greater than available, reject tx
413         if (tokens >= getTokensAvailable()) {
414             revert();
415         }
416 
417         addToInvestor(_recipient, 0, tokens);
418 
419         // Increase the count of tokens purchased in the sale
420         updateSaleParameters(tokens);
421 
422         LogTokenPurchase(msg.sender, _recipient, 0, tokens);
423 
424         return true;
425     }
426 
427     /*****
428     * @dev Called by the owner of the contract to finalize the ICO
429     *      and redistribute funds (if any)
430     */
431     function finalizeSale () public onlyOwner {
432         state = SaleState.Success;
433         LogStateChange(state);
434 
435         // Transfer any ETH to one of the Presale wallets
436         if (this.balance > 0) {
437             forwardFunds(this.balance);
438         }
439     }
440 
441     /*****
442     * @dev Called by the owner of the contract to close the Sale and redistribute any crumbs.
443     * @param recipient     address     The address of the recipient of the tokens
444     */
445     function closeSale (address recipient) public onlyOwner {
446         state = SaleState.Closed;
447         LogStateChange(state);
448 
449         // redistribute unsold tokens to DADI ecosystem
450         uint256 remaining = getTokensAvailable();
451         updateSaleParameters(remaining);
452 
453         if (remaining > 0) {
454             token.transfer(recipient, remaining);
455             LogRedistributeTokens(recipient, state, remaining);
456         }
457     }
458 
459     /*****
460     * @dev Called by the owner of the contract to allow tokens to be distributed
461     */
462     function setTokenDistribution () public onlyOwner {
463         state = SaleState.TokenDistribution;
464         LogStateChange(state);
465     }
466 
467     /*****
468     * @dev Called by the owner of the contract to distribute tokens to investors
469     * @param _address       address     The address of the investor for which to distribute tokens
470     * @return success       bool        Returns true if executed successfully
471     */
472     function distributeTokens (address _address) public onlyOwner returns (bool) {
473         require(state == SaleState.TokenDistribution);
474         
475         // get the tokens available for the investor
476         uint256 tokens = investors[_address].tokens;
477         require(tokens > 0);
478 
479         investors[_address].tokens = 0;
480         investors[_address].contribution = 0;
481 
482         token.transfer(_address, tokens);
483       
484         LogTokenDistribution(_address, tokens);
485         return true;
486     }
487 
488     /*****
489     * @dev Called by the owner of the contract to distribute tokens to investors who used a non-ERC20 wallet address
490     * @param _purchaseAddress        address     The address the investor used to buy tokens
491     * @param _tokenAddress           address     The address to send the tokens to
492     * @return success                bool        Returns true if executed successfully
493     */
494     function distributeToAlternateAddress (address _purchaseAddress, address _tokenAddress) public onlyOwner returns (bool) {
495         require(state == SaleState.TokenDistribution);
496         
497         // get the tokens available for the investor
498         uint256 tokens = investors[_purchaseAddress].tokens;
499         require(tokens > 0);
500 
501         investors[_purchaseAddress].tokens = 0;
502 
503         token.transfer(_tokenAddress, tokens);
504       
505         LogTokenDistribution(_tokenAddress, tokens);
506         return true;
507     }
508 
509     /*****
510     * @dev Called by the owner of the contract to redistribute tokens if an investor has been refunded offline
511     * @param investorAddress         address     The address the investor used to buy tokens
512     * @param recipient               address     The address to send the tokens to
513     */
514     function redistributeTokens (address investorAddress, address recipient) public onlyOwner {
515         uint256 tokens = investors[investorAddress].tokens;
516         require(tokens > 0);
517         
518         // remove tokens, so they can't be redistributed
519         investors[investorAddress].tokens = 0;
520         token.transfer(recipient, tokens);
521 
522         LogRedistributeTokens(recipient, state, tokens);
523     }
524 
525     /*****
526     * @dev Get the amount of PreSale tokens left for purchase
527     * @return uint256 the count of tokens available
528     */
529     function getTokensAvailable () public constant returns (uint256) {
530         return tokenSupply - tokensPurchased;
531     }
532 
533     /*****
534     * @dev Get the total count of tokens purchased in all the Sale periods
535     * @return uint256 the count of tokens purchased
536     */
537     function getTokensPurchased () public constant returns (uint256) {
538         return tokensPurchased;
539     }
540 
541     /*****
542     * @dev Get the balance sent to the contract
543     * @return uint256 the amount sent to this contract, in Wei
544     */
545     function getBalance () public constant returns (uint256) {
546         return this.balance;
547     }
548 
549     /*****
550     * @dev Converts an amount sent in Wei to the equivalent in USD
551     * @param _amount      uint256       the amount sent to the contract, in Wei
552     * @return uint256  the amount sent to this contract, in USD
553     */
554     function ethToUsd (uint256 _amount) public constant returns (uint256) {
555         return (_amount * ethRate) / (uint256(10) ** 18);
556     }
557 
558     /*****
559     * @dev Get the overall success state of the ICO
560     * @return bool whether the state is successful, or not
561     */
562     function isSuccessful () public constant returns (bool) {
563         return state == SaleState.Success;
564     }
565 
566     /*****
567     * @dev Get a whitelisted user
568     * @param userAddress      address       the wallet address of the user
569     * @return uint256  the amount pledged by the user
570     * @return uint     the index of the user
571     */
572     function getWhitelistUser (address userAddress) public constant returns (uint256 pledged, uint index) {
573         require(isWhitelisted(userAddress));
574         return(whitelisted[userAddress].pledged, whitelisted[userAddress].index);
575     }
576 
577     /*****
578     * @dev Get count of contributors
579     * @return uint     the number of unique contributors
580     */
581     function getInvestorCount () public constant returns (uint count) {
582         return investorIndex.length;
583     }
584 
585 
586     /*****
587     * @dev Get an investor
588     * @param _address      address       the wallet address of the investor
589     * @return uint256  the amount contributed by the user
590     * @return uint256  the number of tokens assigned to the user
591     * @return uint     the index of the user
592     */
593     function getInvestor (address _address) public constant returns (uint256 contribution, uint256 tokens, uint index) {
594         require(isInvested(_address));
595         return(investors[_address].contribution, investors[_address].tokens, investors[_address].index);
596     }
597 
598     /*****
599     * @dev Get a user's whitelisted state
600     * @param userAddress      address       the wallet address of the user
601     * @return bool  true if the user is in the whitelist
602     */
603     function isWhitelisted (address userAddress) internal constant returns (bool isIndeed) {
604         if (whitelistedIndex.length == 0) return false;
605         return (whitelistedIndex[whitelisted[userAddress].index] == userAddress);
606     }
607 
608     /*****
609     * @dev Get a user's invested state
610     * @param _address      address       the wallet address of the user
611     * @return bool  true if the user has already contributed
612     */
613     function isInvested (address _address) internal constant returns (bool isIndeed) {
614         if (investorIndex.length == 0) return false;
615         return (investorIndex[investors[_address].index] == _address);
616     }
617 
618     /*****
619     * @dev Update a user's invested state
620     * @param _address      address       the wallet address of the user
621     * @param _value        uint256       the amount contributed in this transaction
622     * @param _tokens       uint256       the number of tokens assigned in this transaction
623     */
624     function addToInvestor(address _address, uint256 _value, uint256 _tokens) internal {
625         // add the user to the investorIndex if this is their first contribution
626         if (!isInvested(_address)) {
627             investors[_address].index = investorIndex.push(_address) - 1;
628         }
629       
630         investors[_address].tokens = investors[_address].tokens.add(_tokens);
631         investors[_address].contribution = investors[_address].contribution.add(_value);
632     }
633 
634     /*****
635     * @dev Send ether to the presale collection wallets
636     */
637     function forwardFunds (uint256 _value) internal {
638         uint accountNumber;
639         address account;
640 
641         // move funds to a random preSaleWallet
642         if (preSaleWallets.length > 0) {
643             accountNumber = getRandom(preSaleWallets.length) - 1;
644             account = preSaleWallets[accountNumber];
645             account.transfer(_value);
646             LogFundTransfer(account, _value);
647         }
648     }
649 
650     /*****
651     * @dev Internal function to assign tokens to the contributor
652     * @param _address       address     The address of the contributing investor
653     * @param _value         uint256     The amount invested 
654     * @return success       bool        Returns true if executed successfully
655     */
656     function buyTokens (address _address, uint256 _value) internal returns (bool) {
657         require(isBelowCap(_value));
658 
659         if (isWhitelistPeriod()) {
660             require(isWhitelisted(_address));
661         }
662 
663         require(isValidContribution(_address, _value));
664 
665         uint256 boughtTokens = calculateTokens(_value);
666         require(boughtTokens != 0);
667 
668         // if the number of tokens calculated for the given value is 
669         // greater than the tokens available, reject the payment
670         if (boughtTokens >= getTokensAvailable()) {
671             revert();
672         }
673 
674         // update investor state
675         addToInvestor(_address, _value, boughtTokens);
676 
677         LogTokenPurchase(msg.sender, _address, _value, boughtTokens);
678 
679         forwardFunds(_value);
680 
681         updateSaleParameters(boughtTokens);
682 
683         return true;
684     }
685 
686     /*****
687     * @dev Check that the amount sent in the transaction is below the individual cap, or below the pledged
688     * amount if the user is whitelisted and the sale is in the whitelist period. Factors in previous
689     * transaction by the same user
690     * @param _address         address     The address of the user making the transaction
691     * @param _amount          uint256     The amount sent in the transaction
692     * @return        bool        Returns true if the amount is valid
693     */
694     function isValidContribution (address _address, uint256 _amount) internal constant returns (bool valid) {
695         if (isWhitelistPeriod() && isWhitelisted(_address)) {
696             return ethToUsd(_amount + investors[_address].contribution) <= whitelisted[_address].pledged;
697         }
698 
699         return isBelowCap(_amount + investors[_address].contribution); 
700     }
701 
702     /*****
703     * @dev Check that the amount sent in the transaction is below the individual cap
704     * @param _amount         uint256     The amount sent in the transaction
705     * @return        bool        Returns true if the amount is below the individual cap
706     */
707     function isBelowCap (uint256 _amount) internal constant returns (bool) {
708         return ethToUsd(_amount) < individualCap;
709     }
710 
711     /*****
712     * @dev Generates a random number from 1 to max based on the last block hash
713     * @param max     uint  the maximum value 
714     * @return a random number
715     */
716     function getRandom(uint max) internal constant returns (uint randomNumber) {
717         return (uint(keccak256(block.blockhash(block.number - 1))) % max) + 1;
718     }
719 
720     /*****
721     * @dev Internal function to modify parameters based on tokens bought
722     * @param _tokens        uint256     The number of tokens purchased
723     */
724     function updateSaleParameters (uint256 _tokens) internal {
725         tokensPurchased = tokensPurchased.add(_tokens);
726     }
727 
728     /*****
729     * @dev Check the state of the contract
730     * @return bool  Return true if the contract is in the Whitelist period
731     */
732     function isWhitelistPeriod () private constant returns (bool) {
733         return purchasePeriod == PurchasePeriod.Whitelist;
734     }
735 
736     /*****
737     * @dev Check the state of the contract
738     * @return bool  Return true if the contract is in the WhitelistApplicant period
739     */
740     function isWhitelistApplicantPeriod () private constant returns (bool) {
741         return purchasePeriod == PurchasePeriod.WhitelistApplicant;
742     }
743 
744     /*****
745     * @dev Check the state of the contract
746     * @return bool  Return true if the contract is in the Public period
747     */
748     function isPublicPeriod () private constant returns (bool) {
749         return purchasePeriod == PurchasePeriod.Public;
750     }
751 }