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
217 * @title The DADI MaxCap Contract
218 */
219 contract DadiMaxCapSale is Ownable {
220     using SafeMath for uint256;
221 
222     StandardToken public token;                         // The DADI ERC20 token */
223     address[] public saleWallets;
224 
225     struct WhitelistUser {
226       uint index;
227     }
228 
229     struct Investor {
230       uint256 tokens;
231       uint256 contribution;
232       bool distributed;
233       uint index;
234     }
235 
236     uint256 public tokenSupply;
237     uint256 public tokensPurchased = 0;
238     uint256 public individualCap = 5000 * 1000;         // USD$5,000
239     uint256 public saleTokenPrice = 500;                // USD$0.50
240     uint256 public ethRate = 1172560;                   // Original ETH rate. 1 ETH = 1172.56 USD
241  
242     mapping(address => WhitelistUser) private whitelisted;
243     address[] private whitelistedIndex;
244     mapping(address => Investor) private investors;
245     address[] private investorIndex;
246 
247     /*****
248     * State for Sale Modes
249     *  0 - Preparing:            All contract initialization calls
250     *  1 - Sale:                 Contract is in the sale period
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
265     event LogNewWhitelistUser(address indexed userAddress, uint index);
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
276     * @dev The constructor function to initialize the Presale
277     * @param _token                         address   the address of the ERC20 token for the sale
278     * @param _tokenSupply                   uint256   the amount of tokens available
279     */
280     function DadiMaxCapSale (StandardToken _token,uint256 _tokenSupply) public {
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
308     * @dev Allows the contract owner to add multiple whitelist users, each with a wallet address
309     * @param userAddresses   address[]     The array of whitelist wallet addresses
310     */
311     function addWhitelistUsers(address[] userAddresses) public onlyOwner {
312         for (uint i = 0; i < userAddresses.length; i++) {
313             addWhitelistUser(userAddresses[i]);
314         }
315     }
316 
317     /*****
318     * @dev Allows the contract owner to a single whitelist user
319     * @param userAddress     address      The wallet address to whitelist
320     */
321     function addWhitelistUser(address userAddress) public onlyOwner {
322         if (!isWhitelisted(userAddress)) {
323             whitelisted[userAddress].index = whitelistedIndex.push(userAddress) - 1;
324           
325             LogNewWhitelistUser(userAddress, whitelisted[userAddress].index);
326         }
327     }
328 
329     /*****
330     * @dev Calculates the number of tokens that can be bought for the amount of Wei transferred
331     * @param _amount    uint256     The amount of money invested by the investor
332     * @return tokens    uint256     The number of tokens purchased for the amount invested
333     */
334     function calculateTokens (uint256 _amount) public constant returns (uint256 tokens) {
335         tokens = _amount * ethRate / saleTokenPrice;
336         return tokens;
337     }
338 
339     /*****
340     * @dev Called by the owner of the contract to modify the sale state
341     */
342     function setState (uint256 _state) public onlyOwner {
343         state = SaleState(uint(_state));
344         LogStateChange(state);
345     }
346 
347     /*****
348     * @dev Called by the owner of the contract to start the sale
349     */
350     function startSale () public onlyOwner {
351         state = SaleState.Sale;
352         LogStateChange(state);
353     }
354 
355     /*****
356     * @dev Called by the owner of the contract to finalize the ICO
357     *      and redistribute funds (if any)
358     */
359     function finalizeSale () public onlyOwner {
360         state = SaleState.Success;
361         LogStateChange(state);
362 
363         // Transfer any ETH to one of the Presale wallets
364         if (this.balance > 0) {
365             forwardFunds(this.balance);
366         }
367     }
368 
369     /*****
370     * @dev Called by the owner of the contract to close the Sale and redistribute any crumbs.
371     * @param recipient     address     The address of the recipient of the tokens
372     */
373     function closeSale (address recipient) public onlyOwner {
374         state = SaleState.Closed;
375         LogStateChange(state);
376 
377         // redistribute unsold tokens to DADI ecosystem
378         uint256 remaining = getTokensAvailable();
379         updateSaleParameters(remaining);
380 
381         if (remaining > 0) {
382             token.transfer(recipient, remaining);
383             LogRedistributeTokens(recipient, state, remaining);
384         }
385     }
386 
387     /*****
388     * @dev Called by the owner of the contract to allow tokens to be distributed
389     */
390     function setTokenDistribution () public onlyOwner {
391         state = SaleState.TokenDistribution;
392         LogStateChange(state);
393     }
394 
395     /*****
396     * @dev Called by the owner of the contract to distribute tokens to investors
397     * @param _address       address     The address of the investor for which to distribute tokens
398     * @return success       bool        Returns true if executed successfully
399     */
400     function distributeTokens (address _address) public onlyOwner returns (bool) {
401         require(state == SaleState.TokenDistribution);
402         
403         // get the tokens available for the investor
404         uint256 tokens = investors[_address].tokens;
405         require(tokens > 0);
406 
407         require(investors[_address].distributed == false);
408 
409         investors[_address].distributed = true;
410 
411         token.transfer(_address, tokens);
412       
413         LogTokenDistribution(_address, tokens);
414         return true;
415     }
416 
417     /*****
418     * @dev Called by the owner of the contract to distribute tokens to investors who used a non-ERC20 wallet address
419     * @param _purchaseAddress        address     The address the investor used to buy tokens
420     * @param _tokenAddress           address     The address to send the tokens to
421     * @return success                bool        Returns true if executed successfully
422     */
423     function distributeToAlternateAddress (address _purchaseAddress, address _tokenAddress) public onlyOwner returns (bool) {
424         require(state == SaleState.TokenDistribution);
425         
426         // get the tokens available for the investor
427         uint256 tokens = investors[_purchaseAddress].tokens;
428         require(tokens > 0);
429 
430         require(investors[_purchaseAddress].distributed == false);
431         investors[_purchaseAddress].distributed = true;
432 
433         token.transfer(_tokenAddress, tokens);
434       
435         LogTokenDistribution(_tokenAddress, tokens);
436         return true;
437     }
438 
439     /*****
440     * @dev Called by the owner of the contract to redistribute tokens if an investor has been refunded offline
441     * @param investorAddress         address     The address the investor used to buy tokens
442     * @param recipient               address     The address to send the tokens to
443     */
444     function redistributeTokens (address investorAddress, address recipient) public onlyOwner {
445         uint256 tokens = investors[investorAddress].tokens;
446         require(tokens > 0);
447         
448         // remove tokens, so they can't be redistributed
449         require(investors[investorAddress].distributed == false);
450 
451         investors[investorAddress].distributed = true;
452 
453         token.transfer(recipient, tokens);
454 
455         LogRedistributeTokens(recipient, state, tokens);
456     }
457 
458     /*****
459     * @dev Get the amount of PreSale tokens left for purchase
460     * @return uint256 the count of tokens available
461     */
462     function getTokensAvailable () public constant returns (uint256) {
463         return tokenSupply - tokensPurchased;
464     }
465 
466     /*****
467     * @dev Get the total count of tokens purchased in all the Sale periods
468     * @return uint256 the count of tokens purchased
469     */
470     function getTokensPurchased () public constant returns (uint256) {
471         return tokensPurchased;
472     }
473 
474     /*****
475     * @dev Converts an amount sent in Wei to the equivalent in USD
476     * @param _amount      uint256       the amount sent to the contract, in Wei
477     * @return uint256  the amount sent to this contract, in USD
478     */
479     function ethToUsd (uint256 _amount) public constant returns (uint256) {
480         return (_amount * ethRate) / (uint256(10) ** 18);
481     }
482 
483     /*****
484     * @dev Get the overall success state of the ICO
485     * @return bool whether the state is successful, or not
486     */
487     function isSuccessful () public constant returns (bool) {
488         return state == SaleState.Success;
489     }
490 
491     /*****
492     * @dev Get a whitelisted user
493     * @param userAddress      address       the wallet address of the user
494     * @return uint     the index of the user
495     */
496     function getWhitelistUser (address userAddress) public constant returns (uint index) {
497         require(isWhitelisted(userAddress));
498         return whitelisted[userAddress].index;
499     }
500 
501     /*****
502     * @dev Get count of contributors
503     * @return uint     the number of unique contributors
504     */
505     function getInvestorCount () public constant returns (uint count) {
506         return investorIndex.length;
507     }
508 
509 
510     /*****
511     * @dev Get an investor
512     * @param _address      address       the wallet address of the investor
513     * @return uint256  the amount contributed by the user
514     * @return uint256  the number of tokens assigned to the user
515     * @return bool     whether the tokens have already been distributed
516     * @return uint     the index of the user
517     */
518     function getInvestor (address _address) public constant returns (uint256 contribution, uint256 tokens, bool distributed, uint index) {
519         require(isInvested(_address));
520         return(investors[_address].contribution, investors[_address].tokens, investors[_address].distributed, investors[_address].index);
521     }
522 
523     /*****
524     * @dev Get a user's whitelisted state
525     * @param userAddress      address       the wallet address of the user
526     * @return bool  true if the user is in the whitelist
527     */
528     function isWhitelisted (address userAddress) internal constant returns (bool isIndeed) {
529         if (whitelistedIndex.length == 0) return false;
530         return (whitelistedIndex[whitelisted[userAddress].index] == userAddress);
531     }
532 
533     /*****
534     * @dev Get a user's invested state
535     * @param _address      address       the wallet address of the user
536     * @return bool  true if the user has already contributed
537     */
538     function isInvested (address _address) internal constant returns (bool isIndeed) {
539         if (investorIndex.length == 0) return false;
540         return (investorIndex[investors[_address].index] == _address);
541     }
542 
543     /*****
544     * @dev Update a user's invested state
545     * @param _address      address       the wallet address of the user
546     * @param _value        uint256       the amount contributed in this transaction
547     * @param _tokens       uint256       the number of tokens assigned in this transaction
548     */
549     function addToInvestor(address _address, uint256 _value, uint256 _tokens) internal {
550         // add the user to the investorIndex if this is their first contribution
551         if (!isInvested(_address)) {
552             investors[_address].index = investorIndex.push(_address) - 1;
553         }
554       
555         investors[_address].tokens = investors[_address].tokens.add(_tokens);
556         investors[_address].contribution = investors[_address].contribution.add(_value);
557     }
558 
559     /*****
560     * @dev Send ether to the presale collection wallets
561     */
562     function forwardFunds (uint256 _value) internal {
563         uint accountNumber;
564         address account;
565 
566         // move funds to a random preSaleWallet
567         if (saleWallets.length > 0) {
568             accountNumber = getRandom(saleWallets.length) - 1;
569             account = saleWallets[accountNumber];
570             account.transfer(_value);
571             LogFundTransfer(account, _value);
572         }
573     }
574 
575     /*****
576     * @dev Internal function to assign tokens to the contributor
577     * @param _address       address     The address of the contributing investor
578     * @param _value         uint256     The amount invested 
579     * @return success       bool        Returns true if executed successfully
580     */
581     function buyTokens (address _address, uint256 _value) internal returns (bool) {
582         require(isValidContribution(_address, _value));
583 
584         uint256 boughtTokens = calculateTokens(_value);
585         require(boughtTokens != 0);
586 
587         // if the number of tokens calculated for the given value is 
588         // greater than the tokens available, reject the payment
589         if (boughtTokens >= getTokensAvailable()) {
590             revert();
591         }
592 
593         // update investor state
594         addToInvestor(_address, _value, boughtTokens);
595 
596         LogTokenPurchase(msg.sender, _address, _value, boughtTokens);
597 
598         forwardFunds(_value);
599 
600         updateSaleParameters(boughtTokens);
601 
602         return true;
603     }
604 
605     /*****
606     * @dev Check that the user is whitelisted and the amount sent in the transaction is below or equal to the individual cap.
607     * Factors in previous transaction by the same user
608     * @param _address         address     The address of the user making the transaction
609     * @param _amount          uint256     The amount sent in the transaction
610     * @return        bool        Returns true if the amount is valid
611     */
612     function isValidContribution (address _address, uint256 _amount) internal constant returns (bool valid) {
613         require(isWhitelisted(_address));
614 
615         return isEqualOrBelowCap(_amount + investors[_address].contribution); 
616     }
617 
618     /*****
619     * @dev Check that the amount sent in the transaction is equal to or below the individual cap
620     * @param _amount         uint256     The amount sent in the transaction
621     * @return        bool        Returns true if the amount is equal to or below the individual cap
622     */
623     function isEqualOrBelowCap (uint256 _amount) internal constant returns (bool) {
624         return ethToUsd(_amount) <= individualCap;
625     }
626 
627     /*****
628     * @dev Generates a random number from 1 to max based on the last block hash
629     * @param max     uint  the maximum value 
630     * @return a random number
631     */
632     function getRandom(uint max) internal constant returns (uint randomNumber) {
633         return (uint(keccak256(block.blockhash(block.number - 1))) % max) + 1;
634     }
635 
636     /*****
637     * @dev Internal function to modify parameters based on tokens bought
638     * @param _tokens        uint256     The number of tokens purchased
639     */
640     function updateSaleParameters (uint256 _tokens) internal {
641         tokensPurchased = tokensPurchased.add(_tokens);
642     }
643 }