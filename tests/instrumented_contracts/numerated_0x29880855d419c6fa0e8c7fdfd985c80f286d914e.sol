1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // require(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // require(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
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
217 * @title The DADI Public sale Contract
218 */
219 contract DadiPublicSale is Ownable {
220     using SafeMath for uint256;
221 
222     StandardToken public token;                         // The DADI ERC20 token */
223 
224     uint256 public tokenSupply;
225     uint256 public tokensPurchased = 0;
226     uint256 public individualCap = 5000 * 1000;         // USD$5,000
227     uint256 public tokenPrice = 500;                    // USD$0.50
228     uint256 public ethRate;                             // ETH to USD Rate, set by owner: 1 ETH = ethRate USD
229     uint256 public maxGasPrice;                         // Max gas price for contributing transactions.
230  
231     address[] public saleWallets;
232     mapping(address => Investor) private investors;
233     address[] private investorIndex;
234 
235     struct Investor {
236       uint256 tokens;
237       uint256 contribution;
238       bool distributed;
239       uint index;
240     }
241 
242     /*****
243     * State for Sale Modes
244     *  0 - Preparing:            All contract initialization calls
245     *  1 - PublicSale:           Contract is in the Sale Period
246     *  2 - PublicSaleFinalized   Sale period is finalized, no more payments are allowed
247     *  3 - Success:              Sale Successful
248     *  4 - TokenDistribution:    Ssale finished, tokens can be distributed
249     *  5 - Closed:               Sale closed, no tokens more can be distributed
250     */
251     enum SaleState { Preparing, PublicSale, PublicSaleFinalized, Success, TokenDistribution, Closed }
252     SaleState public state = SaleState.Preparing;
253 
254     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
255     event LogTokenDistribution(address recipient, uint256 tokens);
256     event LogRedistributeTokens(address recipient, SaleState _state, uint256 tokens);
257     event LogFundTransfer(address wallet, uint256 value);
258     event LogRefund(address wallet, uint256 value);
259     event LogStateChange(SaleState _state);
260 
261     /*****
262     * @dev Modifier to check that amount transferred is not 0
263     */
264     modifier nonZero() {
265         require(msg.value != 0);
266         _;
267     }
268 
269     /*****
270     * @dev The constructor function to initialize the Public sale
271     * @param _token                         address   the address of the ERC20 token for the sale
272     * @param _tokenSupply                   uint256   the amount of tokens available
273     */
274     function DadiPublicSale (StandardToken _token, uint256 _tokenSupply) public {
275         require(_token != address(0));
276         require(_tokenSupply != 0);
277 
278         token = StandardToken(_token);
279         tokenSupply = _tokenSupply * (uint256(10) ** 18);
280         maxGasPrice = 60000000000;       // 60 Gwei
281     }
282 
283     /*****
284     * @dev Fallback Function to buy the tokens
285     */
286     function () public nonZero payable {
287         require(state == SaleState.PublicSale);
288         buyTokens(msg.sender, msg.value);
289     }
290 
291     /*****
292     * @dev Allows the contract owner to add a new distribution wallet, used to hold funds safely
293     * @param _wallet        address     The address of the wallet
294     * @return success       bool        Returns true if executed successfully
295     */
296     function addSaleWallet (address _wallet) public onlyOwner returns (bool) {
297         require(_wallet != address(0));
298 
299         saleWallets.push(_wallet);
300         return true;
301     }
302 
303     /*****
304     * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred
305     * @param _amount    uint256     The amount of money invested by the investor
306     * @return tokens    uint256     The number of tokens purchased for the amount invested
307     */
308     function calculateTokens (uint256 _amount) public constant returns (uint256 tokens) {
309         tokens = _amount * ethRate / tokenPrice;
310         return tokens;
311     }
312 
313     /*****
314     * @dev Called by the owner of the contract to modify the sale state
315     */
316     function setState (uint256 _state) public onlyOwner {
317         state = SaleState(uint(_state));
318         LogStateChange(state);
319     }
320 
321     /*****
322     * @dev Called by the owner of the contract to start the Public sale
323     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
324     */
325     function startPublicSale (uint256 rate) public onlyOwner {
326         state = SaleState.PublicSale;
327         updateEthRate(rate);
328         LogStateChange(state);
329     }
330 
331     /*****
332     * @dev Allow updating the ETH USD exchange rate
333     * @param rate   uint256  the current ETH USD rate, multiplied by 1000
334     * @return bool  Return true if successful
335     */
336     function updateEthRate (uint256 rate) public onlyOwner returns (bool) {
337         require(rate >= 100000);
338         
339         ethRate = rate;
340         return true;
341     }
342 
343     /*****
344     * @dev Allow updating the max gas price
345     * @param _maxGasPrice   uint256  the maximum gas price for a transaction, in Gwei
346     */
347     function updateMaxGasPrice(uint256 _maxGasPrice) public onlyOwner {
348         require(_maxGasPrice > 0);
349 
350         maxGasPrice = _maxGasPrice;
351     }
352 
353     /*****
354     * @dev Allows transfer of tokens to a recipient who has purchased offline, during the PublicSale
355     * @param _recipient     address     The address of the recipient of the tokens
356     * @param _tokens        uint256     The number of tokens purchased by the recipient
357     * @return success       bool        Returns true if executed successfully
358     */
359     function offlineTransaction (address _recipient, uint256 _tokens) public onlyOwner returns (bool) {
360         require(_tokens > 0);
361 
362         // Convert to a token with decimals 
363         uint256 tokens = _tokens * (uint256(10) ** uint8(18));
364 
365         // if the number of tokens is greater than available, reject tx
366         if (tokens >= getTokensAvailable()) {
367             revert();
368         }
369 
370         addToInvestor(_recipient, 0, tokens);
371 
372         // Increase the count of tokens purchased in the sale
373         updateSaleParameters(tokens);
374 
375         LogTokenPurchase(msg.sender, _recipient, 0, tokens);
376 
377         return true;
378     }
379 
380     /*****
381     * @dev Called by the owner of the contract to finalize the ICO
382     *      and redistribute funds (if any)
383     */
384     function finalizeSale () public onlyOwner {
385         state = SaleState.Success;
386         LogStateChange(state);
387 
388         // Transfer any ETH to one of the sale wallets
389         if (this.balance > 0) {
390             forwardFunds(this.balance);
391         }
392     }
393 
394     /*****
395     * @dev Called by the owner of the contract to close the Sale and redistribute any crumbs.
396     * @param recipient     address     The address of the recipient of the tokens
397     */
398     function closeSale (address recipient) public onlyOwner {
399         state = SaleState.Closed;
400         LogStateChange(state);
401 
402         // redistribute unsold tokens to DADI ecosystem
403         uint256 remaining = getTokensAvailable();
404         updateSaleParameters(remaining);
405 
406         if (remaining > 0) {
407             token.transfer(recipient, remaining);
408             LogRedistributeTokens(recipient, state, remaining);
409         }
410     }
411 
412     /*****
413     * @dev Called by the owner of the contract to allow tokens to be distributed
414     */
415     function setTokenDistribution () public onlyOwner {
416         state = SaleState.TokenDistribution;
417         LogStateChange(state);
418     }
419 
420     /*****
421     * @dev Called by the owner of the contract to distribute tokens to investors
422     * @param _address       address     The address of the investor for which to distribute tokens
423     * @return success       bool        Returns true if executed successfully
424     */
425     function distributeTokens (address _address) public onlyOwner returns (bool) {
426         require(state == SaleState.TokenDistribution);
427         
428         // get the tokens available for the investor
429         uint256 tokens = investors[_address].tokens;
430         require(tokens > 0);
431 
432         require(investors[_address].distributed == false);
433 
434         investors[_address].distributed = true;
435         // investors[_address].tokens = 0;
436         // investors[_address].contribution = 0;
437 
438         token.transfer(_address, tokens);
439       
440         LogTokenDistribution(_address, tokens);
441         return true;
442     }
443 
444     /*****
445     * @dev Called by the owner of the contract to distribute tokens to investors who used a non-ERC20 wallet address
446     * @param _purchaseAddress        address     The address the investor used to buy tokens
447     * @param _tokenAddress           address     The address to send the tokens to
448     * @return success                bool        Returns true if executed successfully
449     */
450     function distributeToAlternateAddress (address _purchaseAddress, address _tokenAddress) public onlyOwner returns (bool) {
451         require(state == SaleState.TokenDistribution);
452         
453         // get the tokens available for the investor
454         uint256 tokens = investors[_purchaseAddress].tokens;
455         require(tokens > 0);
456 
457         require(investors[_purchaseAddress].distributed == false);
458 
459         investors[_purchaseAddress].distributed = true;
460 
461         token.transfer(_tokenAddress, tokens);
462       
463         LogTokenDistribution(_tokenAddress, tokens);
464         return true;
465     }
466 
467     /*****
468     * @dev Called by the owner of the contract to redistribute tokens if an investor has been refunded offline
469     * @param investorAddress         address     The address the investor used to buy tokens
470     * @param recipient               address     The address to send the tokens to
471     */
472     function redistributeTokens (address investorAddress, address recipient) public onlyOwner {
473         uint256 tokens = investors[investorAddress].tokens;
474         require(tokens > 0);
475         require(investors[investorAddress].distributed == false);
476         
477         // remove tokens, so they can't be redistributed
478         // investors[investorAddress].tokens = 0;
479         investors[investorAddress].distributed = true;
480         token.transfer(recipient, tokens);
481 
482         LogRedistributeTokens(recipient, state, tokens);
483     }
484 
485     /*****
486     * @dev Get the amount of tokens left for purchase
487     * @return uint256 the count of tokens available
488     */
489     function getTokensAvailable () public constant returns (uint256) {
490         return tokenSupply - tokensPurchased;
491     }
492 
493     /*****
494     * @dev Get the total count of tokens purchased
495     * @return uint256 the count of tokens purchased
496     */
497     function getTokensPurchased () public constant returns (uint256) {
498         return tokensPurchased;
499     }
500 
501     /*****
502     * @dev Converts an amount sent in Wei to the equivalent in USD
503     * @param _amount      uint256       the amount sent to the contract, in Wei
504     * @return uint256  the amount sent to this contract, in USD
505     */
506     function ethToUsd (uint256 _amount) public constant returns (uint256) {
507         return (_amount * ethRate) / (uint256(10) ** 18);
508     }
509 
510     /*****
511     * @dev Get count of contributors
512     * @return uint     the number of unique contributors
513     */
514     function getInvestorCount () public constant returns (uint count) {
515         return investorIndex.length;
516     }
517 
518     /*****
519     * @dev Get an investor
520     * @param _address      address       the wallet address of the investor
521     * @return uint256  the amount contributed by the user
522     * @return uint256  the number of tokens assigned to the user
523     * @return uint     the index of the user
524     */
525     function getInvestor (address _address) public constant returns (uint256 contribution, uint256 tokens, bool distributed, uint index) {
526         require(isInvested(_address));
527         return(investors[_address].contribution, investors[_address].tokens, investors[_address].distributed, investors[_address].index);
528     }
529 
530     /*****
531     * @dev Get a user's invested state
532     * @param _address      address       the wallet address of the user
533     * @return bool  true if the user has already contributed
534     */
535     function isInvested (address _address) internal constant returns (bool isIndeed) {
536         if (investorIndex.length == 0) return false;
537         return (investorIndex[investors[_address].index] == _address);
538     }
539 
540     /*****
541     * @dev Update a user's invested state
542     * @param _address      address       the wallet address of the user
543     * @param _value        uint256       the amount contributed in this transaction
544     * @param _tokens       uint256       the number of tokens assigned in this transaction
545     */
546     function addToInvestor(address _address, uint256 _value, uint256 _tokens) internal {
547         // add the user to the investorIndex if this is their first contribution
548         if (!isInvested(_address)) {
549             investors[_address].index = investorIndex.push(_address) - 1;
550         }
551       
552         investors[_address].tokens = investors[_address].tokens.add(_tokens);
553         investors[_address].contribution = investors[_address].contribution.add(_value);
554         investors[_address].distributed = false;
555     }
556 
557     /*****
558     * @dev Send ether to the sale collection wallets
559     */
560     function forwardFunds (uint256 _value) internal {
561         uint accountNumber;
562         address account;
563 
564         // move funds to a random saleWallet
565         if (saleWallets.length > 0) {
566             accountNumber = getRandom(saleWallets.length) - 1;
567             account = saleWallets[accountNumber];
568             account.transfer(_value);
569             LogFundTransfer(account, _value);
570         }
571     }
572 
573     /*****
574     * @dev Internal function to assign tokens to the contributor
575     * @param _address       address     The address of the contributing investor
576     * @param _value         uint256     The amount invested 
577     * @return success       bool        Returns true if executed successfully
578     */
579     function buyTokens (address _address, uint256 _value) internal returns (bool) {
580         require(tx.gasprice <= maxGasPrice);
581 
582         require(isValidContribution(_address, _value));
583 
584         uint256 boughtTokens = calculateTokens(_value);
585         require(boughtTokens != 0);
586 
587         // if the number of tokens calculated for the given value is 
588         // greater than the tokens available, reject the payment
589         require(boughtTokens <= getTokensAvailable());
590 
591         // update investor state
592         addToInvestor(_address, _value, boughtTokens);
593 
594         forwardFunds(_value);
595 
596         updateSaleParameters(boughtTokens);
597 
598         LogTokenPurchase(msg.sender, _address, _value, boughtTokens);
599 
600         return true;
601     }
602 
603     /*****
604     * @dev Check that the amount sent in the transaction is below the individual cap
605     * Factors in previous transactions by the same investor
606     * @param _address         address     The address of the user making the transaction
607     * @param _amount          uint256     The amount sent in the transaction
608     * @return        bool        Returns true if the amount is valid
609     */
610     function isValidContribution (address _address, uint256 _amount) internal constant returns (bool valid) {
611         return isBelowCap(_amount + investors[_address].contribution); 
612     }
613 
614     /*****
615     * @dev Check that the amount sent in the transaction is below the individual cap
616     * @param _amount         uint256     The amount sent in the transaction
617     * @return        bool        Returns true if the amount is below the individual cap
618     */
619     function isBelowCap (uint256 _amount) internal constant returns (bool) {
620         return ethToUsd(_amount) < individualCap;
621     }
622 
623     /*****
624     * @dev Generates a random number from 1 to max based on the last block hash
625     * @param max     uint  the maximum value 
626     * @return a random number
627     */
628     function getRandom(uint max) internal constant returns (uint randomNumber) {
629         return (uint(keccak256(block.blockhash(block.number - 1))) % max) + 1;
630     }
631 
632     /*****
633     * @dev Internal function to modify parameters based on tokens bought
634     * @param _tokens        uint256     The number of tokens purchased
635     */
636     function updateSaleParameters (uint256 _tokens) internal {
637         tokensPurchased = tokensPurchased.add(_tokens);
638     }
639 }