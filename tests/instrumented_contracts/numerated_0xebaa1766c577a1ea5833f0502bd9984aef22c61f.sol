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
217 * @title A DADI Contract
218 */
219 contract DadiSale is Ownable {
220     using SafeMath for uint256;
221 
222     StandardToken public token;                         // The DADI ERC20 token */
223     address[] public saleWallets;
224 
225     struct WhitelistUser {
226       uint256 pledged;
227       uint index;
228     }
229 
230     struct Investor {
231       uint256 tokens;
232       uint256 contribution;
233       bool distributed;
234       uint index;
235     }
236 
237     uint256 public tokenSupply;
238     uint256 public tokensPurchased = 0;
239     uint256 public tokenPrice = 500;                    // USD$0.50
240     uint256 public ethRate = 200;                       // ETH to USD Rate, set by owner: 1 ETH = ethRate USD
241  
242     mapping(address => WhitelistUser) private whitelisted;
243     address[] private whitelistedIndex;
244     mapping(address => Investor) private investors;
245     address[] private investorIndex;
246 
247     /*****
248     * State for Sale Modes
249     *  0 - Preparing:            All contract initialization calls
250     *  1 - Sale:                 Contract is in the Sale Period
251     *  2 - SaleFinalized         Sale period is finalized, no more payments are allowed
252     *  3 - Success:              Sale Successful
253     *  4 - TokenDistribution:    Sale finished, tokens can be distributed
254     *  5 - Closed:               Sale closed, no tokens more can be distributed
255     */
256     enum SaleState { Preparing, Sale, SaleFinalized, Success, TokenDistribution, Closed }
257     SaleState public state = SaleState.Preparing;
258 
259     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
260     event LogTokenDistribution(address recipient, uint256 tokens);
261     event LogRedistributeTokens(address recipient, SaleState _state, uint256 tokens);
262     event LogFundTransfer(address wallet, uint256 value);
263     event LogRefund(address wallet, uint256 value);
264     event LogStateChange(SaleState _state);
265     event LogNewWhitelistUser(address indexed userAddress, uint index, uint256 value);
266 
267     /*****
268     * @dev Modifier to check that amount transferred is not 0
269     */
270     modifier nonZero() {
271         require(msg.value != 0);
272         _;
273     }
274 
275     /*****
276     * @dev The constructor function to initialize the sale
277     * @param _token                         address   the address of the ERC20 token for the sale
278     * @param _tokenSupply                   uint256   the amount of tokens available
279     */
280     function DadiSale (StandardToken _token, uint256 _tokenSupply) public {
281         require(_token != address(0));
282         require(_tokenSupply != 0);
283 
284         token = StandardToken(_token);
285         tokenSupply = _tokenSupply * (uint256(10) ** 18);
286     }
287 
288     /*****
289     * @dev Fallback Function to buy the tokens
290     */
291     function () public nonZero payable {
292         require(state == SaleState.Sale);
293         buyTokens(msg.sender, msg.value);
294     }
295 
296     /*****
297     * @dev Allows the contract owner to add a new Sale wallet, used to hold funds safely
298     * @param _wallet        address     The address of the wallet
299     * @return success       bool        Returns true if executed successfully
300     */
301     function addSaleWallet (address _wallet) public onlyOwner returns (bool) {
302         require(_wallet != address(0));
303         saleWallets.push(_wallet);
304         return true;
305     }
306 
307     /*****
308     * @dev Allows the contract owner to a single whitelist user
309     * @param userAddress     address      The wallet address to whitelist
310     * @param pledged         uint256      The amount pledged by the user
311     */
312     function addWhitelistUser(address userAddress, uint256 pledged) public onlyOwner {
313         if (!isWhitelisted(userAddress)) {
314             whitelisted[userAddress].index = whitelistedIndex.push(userAddress) - 1;
315           
316             LogNewWhitelistUser(userAddress, whitelisted[userAddress].index, pledged);
317         }
318 
319         whitelisted[userAddress].pledged = pledged * 1000;
320     }
321 
322     /*****
323     * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred
324     * @param _amount    uint256     The amount of money invested by the investor
325     * @return tokens    uint256     The number of tokens purchased for the amount invested
326     */
327     function calculateTokens (uint256 _amount) public constant returns (uint256 tokens) {
328         tokens = _amount * ethRate / tokenPrice;
329         return tokens;
330     }
331 
332     /*****
333     * @dev Called by the owner of the contract to modify the sale state
334     */
335     function setState (uint256 _state) public onlyOwner {
336         state = SaleState(uint(_state));
337         LogStateChange(state);
338     }
339 
340     /*****
341     * @dev Called by the owner of the contract to start the Sale
342     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
343     */
344     function startSale (uint256 rate) public onlyOwner {
345         state = SaleState.Sale;
346         updateEthRate(rate);
347         LogStateChange(state);
348     }
349 
350     /*****
351     * @dev Allow updating the ETH USD exchange rate
352     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
353     * @return bool  Return true if the contract is in PartnerSale Period
354     */
355     function updateEthRate (uint256 rate) public onlyOwner returns (bool) {
356         require(rate >= 100000);
357         
358         ethRate = rate;
359         return true;
360     }
361 
362     function updateTokenSupply (uint256 _tokenSupply)  public onlyOwner returns (bool) {
363         require(_tokenSupply != 0);
364         tokenSupply = _tokenSupply * (uint256(10) ** 18);
365         return true;
366     }
367 
368     /*****
369     * @dev Allows transfer of tokens to a recipient who has purchased offline, during the Sale
370     * @param _recipient     address     The address of the recipient of the tokens
371     * @param _tokens        uint256     The number of tokens purchased by the recipient
372     * @return success       bool        Returns true if executed successfully
373     */
374     function offlineTransaction (address _recipient, uint256 _tokens) public onlyOwner returns (bool) {
375         require(_tokens > 0);
376 
377         // Convert to a token with decimals 
378         uint256 tokens = _tokens * (uint256(10) ** uint8(18));
379 
380         // if the number of tokens is greater than available, reject tx
381         if (tokens >= getTokensAvailable()) {
382             revert();
383         }
384 
385         addToInvestor(_recipient, 0, tokens);
386 
387         // Increase the count of tokens purchased in the sale
388         updateSaleParameters(tokens);
389 
390         LogTokenPurchase(msg.sender, _recipient, 0, tokens);
391 
392         return true;
393     }
394 
395     /*****
396     * @dev Called by the owner of the contract to finalize the ICO
397     *      and redistribute funds (if any)
398     */
399     function finalizeSale () public onlyOwner {
400         state = SaleState.Success;
401         LogStateChange(state);
402 
403         // Transfer any ETH to one of the Sale wallets
404         if (this.balance > 0) {
405             forwardFunds(this.balance);
406         }
407     }
408 
409     /*****
410     * @dev Called by the owner of the contract to close the Sale and redistribute any crumbs.
411     * @param recipient     address     The address of the recipient of the tokens
412     */
413     function closeSale (address recipient) public onlyOwner {
414         state = SaleState.Closed;
415         LogStateChange(state);
416 
417         // redistribute unsold tokens to DADI ecosystem
418         uint256 remaining = getTokensAvailable();
419         updateSaleParameters(remaining);
420 
421         if (remaining > 0) {
422             token.transfer(recipient, remaining);
423             LogRedistributeTokens(recipient, state, remaining);
424         }
425     }
426 
427     /*****
428     * @dev Called by the owner of the contract to allow tokens to be distributed
429     */
430     function setTokenDistribution () public onlyOwner {
431         state = SaleState.TokenDistribution;
432         LogStateChange(state);
433     }
434 
435     /*****
436     * @dev Called by the owner of the contract to distribute tokens to investors
437     * @param _address       address     The address of the investor for which to distribute tokens
438     * @return success       bool        Returns true if executed successfully
439     */
440     function distributeTokens (address _address) public onlyOwner returns (bool) {
441         require(state == SaleState.TokenDistribution);
442         
443         // get the tokens available for the investor
444         uint256 tokens = investors[_address].tokens;
445         require(tokens > 0);
446 
447         require(investors[_address].distributed == false);
448 
449         investors[_address].distributed = true;
450 
451         token.transfer(_address, tokens);
452       
453         LogTokenDistribution(_address, tokens);
454         return true;
455     }
456 
457     /*****
458     * @dev Called by the owner of the contract to distribute tokens to investors who used a non-ERC20 wallet address
459     * @param _purchaseAddress        address     The address the investor used to buy tokens
460     * @param _tokenAddress           address     The address to send the tokens to
461     * @return success                bool        Returns true if executed successfully
462     */
463     function distributeToAlternateAddress (address _purchaseAddress, address _tokenAddress) public onlyOwner returns (bool) {
464         require(state == SaleState.TokenDistribution);
465         
466         // get the tokens available for the investor
467         uint256 tokens = investors[_purchaseAddress].tokens;
468         require(tokens > 0);
469 
470         require(investors[_purchaseAddress].distributed == false);
471 
472         investors[_purchaseAddress].distributed = true;
473 
474         token.transfer(_tokenAddress, tokens);
475       
476         LogTokenDistribution(_tokenAddress, tokens);
477         return true;
478     }
479 
480     /*****
481     * @dev Called by the owner of the contract to redistribute tokens if an investor has been refunded offline
482     * @param investorAddress         address     The address the investor used to buy tokens
483     * @param recipient               address     The address to send the tokens to
484     */
485     function redistributeTokens (address investorAddress, address recipient) public onlyOwner {
486         uint256 tokens = investors[investorAddress].tokens;
487         require(tokens > 0);
488         require(investors[investorAddress].distributed == false);
489         
490         // set flag, so they can't be redistributed
491         investors[investorAddress].distributed = true;
492         token.transfer(recipient, tokens);
493 
494         LogRedistributeTokens(recipient, state, tokens);
495     }
496 
497     /*****
498     * @dev Get the amount of Sale tokens left for purchase
499     * @return uint256 the count of tokens available
500     */
501     function getTokensAvailable () public constant returns (uint256) {
502         return tokenSupply - tokensPurchased;
503     }
504 
505     /*****
506     * @dev Get the total count of tokens purchased in all the Sale periods
507     * @return uint256 the count of tokens purchased
508     */
509     function getTokensPurchased () public constant returns (uint256) {
510         return tokensPurchased;
511     }
512 
513     /*****
514     * @dev Get the balance sent to the contract
515     * @return uint256 the amount sent to this contract, in Wei
516     */
517     function getBalance () public constant returns (uint256) {
518         return this.balance;
519     }
520 
521     /*****
522     * @dev Converts an amount sent in Wei to the equivalent in USD
523     * @param _amount      uint256       the amount sent to the contract, in Wei
524     * @return uint256  the amount sent to this contract, in USD
525     */
526     function ethToUsd (uint256 _amount) public constant returns (uint256) {
527         return (_amount * ethRate) / (uint256(10) ** 18);
528     }
529 
530     /*****
531     * @dev Get a whitelisted user
532     * @param userAddress      address       the wallet address of the user
533     * @return uint256  the amount pledged by the user
534     * @return uint     the index of the user
535     */
536     function getWhitelistUser (address userAddress) public constant returns (uint256 pledged, uint index) {
537         require(isWhitelisted(userAddress));
538         return(whitelisted[userAddress].pledged, whitelisted[userAddress].index);
539     }
540 
541     /*****
542     * @dev Get count of contributors
543     * @return uint     the number of unique contributors
544     */
545     function getInvestorCount () public constant returns (uint count) {
546         return investorIndex.length;
547     }
548 
549     /*****
550     * @dev Get an investor
551     * @param _address      address       the wallet address of the investor
552     * @return uint256  the amount contributed by the user
553     * @return uint256  the number of tokens assigned to the user
554     * @return uint     the index of the user
555     */
556     function getInvestor (address _address) public constant returns (uint256 contribution, uint256 tokens, bool distributed, uint index) {
557         require(isInvested(_address));
558         return(investors[_address].contribution, investors[_address].tokens, investors[_address].distributed, investors[_address].index);
559     }
560 
561     /*****
562     * @dev Get a user's whitelisted state
563     * @param userAddress      address       the wallet address of the user
564     * @return bool  true if the user is in the whitelist
565     */
566     function isWhitelisted (address userAddress) internal constant returns (bool isIndeed) {
567         if (whitelistedIndex.length == 0) return false;
568         return (whitelistedIndex[whitelisted[userAddress].index] == userAddress);
569     }
570 
571     /*****
572     * @dev Get a user's invested state
573     * @param _address      address       the wallet address of the user
574     * @return bool  true if the user has already contributed
575     */
576     function isInvested (address _address) internal constant returns (bool isIndeed) {
577         if (investorIndex.length == 0) return false;
578         return (investorIndex[investors[_address].index] == _address);
579     }
580 
581     /*****
582     * @dev Update a user's invested state
583     * @param _address      address       the wallet address of the user
584     * @param _value        uint256       the amount contributed in this transaction
585     * @param _tokens       uint256       the number of tokens assigned in this transaction
586     */
587     function addToInvestor(address _address, uint256 _value, uint256 _tokens) internal {
588         // add the user to the investorIndex if this is their first contribution
589         if (!isInvested(_address)) {
590             investors[_address].index = investorIndex.push(_address) - 1;
591         }
592       
593         investors[_address].tokens = investors[_address].tokens.add(_tokens);
594         investors[_address].contribution = investors[_address].contribution.add(_value);
595         investors[_address].distributed = false;
596     }
597 
598     /*****
599     * @dev Send ether to the Sale collection wallets
600     */
601     function forwardFunds (uint256 _value) internal {
602         uint accountNumber;
603         address account;
604 
605         // move funds to a random SaleWallet
606         if (saleWallets.length > 0) {
607             accountNumber = getRandom(saleWallets.length) - 1;
608             account = saleWallets[accountNumber];
609             account.transfer(_value);
610             LogFundTransfer(account, _value);
611         }
612     }
613 
614     /*****
615     * @dev Internal function to assign tokens to the contributor
616     * @param _address       address     The address of the contributing investor
617     * @param _value         uint256     The amount invested 
618     * @return success       bool        Returns true if executed successfully
619     */
620     function buyTokens (address _address, uint256 _value) internal returns (bool) {
621         require(isWhitelisted(_address));
622 
623         require(isValidContribution(_address, _value));
624 
625         uint256 boughtTokens = calculateTokens(_value);
626         require(boughtTokens != 0);
627 
628         // if the number of tokens calculated for the given value is 
629         // greater than the tokens available, reject the payment
630         if (boughtTokens > getTokensAvailable()) {
631             revert();
632         }
633 
634         // update investor state
635         addToInvestor(_address, _value, boughtTokens);
636 
637         forwardFunds(_value);
638 
639         updateSaleParameters(boughtTokens);
640 
641         LogTokenPurchase(msg.sender, _address, _value, boughtTokens);
642 
643         return true;
644     }
645 
646     /*****
647     * @dev Check that the amount sent in the transaction is below the pledged amount.
648     * Factors in previous transactions by the same user
649     * @param _address         address     The address of the user making the transaction
650     * @param _amount          uint256     The amount sent in the transaction
651     * @return        bool        Returns true if the amount is valid
652     */
653     function isValidContribution (address _address, uint256 _amount) internal constant returns (bool valid) {
654         return ethToUsd(_amount + investors[_address].contribution) <= whitelisted[_address].pledged;
655     }
656 
657     /*****
658     * @dev Generates a random number from 1 to max based on the last block hash
659     * @param max     uint  the maximum value 
660     * @return a random number
661     */
662     function getRandom(uint max) internal constant returns (uint randomNumber) {
663         return (uint(keccak256(block.blockhash(block.number - 1))) % max) + 1;
664     }
665 
666     /*****
667     * @dev Internal function to modify parameters based on tokens bought
668     * @param _tokens        uint256     The number of tokens purchased
669     */
670     function updateSaleParameters (uint256 _tokens) internal {
671         tokensPurchased = tokensPurchased.add(_tokens);
672     }
673 }