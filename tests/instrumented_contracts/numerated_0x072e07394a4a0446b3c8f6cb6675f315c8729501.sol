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
35  */
36 contract ERC20Basic {
37   uint256 public totalSupply;
38   function balanceOf(address who) public constant returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 
42   function allowance(address owner, address spender) public constant returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) onlyOwner public {
80     require(newOwner != address(0));
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev https://github.com/ethereum/EIPs/issues/20
92  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20Basic {
95 
96   using SafeMath for uint256;
97 
98   mapping (address => mapping (address => uint256)) internal allowed;
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public constant returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint256 the amount of tokens to be transferred
132    */
133   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147    *
148    * Beware that changing an allowance with this method brings the risk that someone may use both the old
149    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152    * @param _spender The address which will spend the funds.
153    * @param _value The amount of tokens to be spent.
154    */
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Function to check the amount of tokens that an owner allowed to a spender.
163    * @param _owner address The address which owns the funds.
164    * @param _spender address The address which will spend the funds.
165    * @return A uint256 specifying the amount of tokens still available for the spender.
166    */
167   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
168     return allowed[_owner][_spender];
169   }
170 
171 }
172 
173 /**
174  * @title Burnable Token
175  * @dev Token that can be irreversibly burned (destroyed).
176  */
177 contract BurnableToken is StandardToken {
178 
179     event Burn(address indexed burner, uint256 value);
180 
181     /**
182      * @dev Burns a specific amount of tokens.
183      * @param _value The amount of token to be burned.
184      */
185     function burn(uint256 _value) public {
186         require(_value > 0);
187         require(_value <= balances[msg.sender]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         address burner = msg.sender;
192         balances[burner] = balances[burner].sub(_value);
193         totalSupply = totalSupply.sub(_value);
194         Burn(burner, _value);
195     }
196 }
197 
198 
199 /**
200  * @title Mintable token
201  * @dev Simple ERC20 Token example, with mintable token creation
202  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
203  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
204  */
205 
206 contract MintableToken is BurnableToken, Ownable {
207   event Mint(address indexed to, uint256 amount);
208   event MintFinished();
209 
210   bool public mintingFinished = false;
211 
212 
213   modifier canMint() {
214     require(!mintingFinished);
215     _;
216   }
217 
218   /**
219    * @dev Function to mint tokens
220    * @param _to The address that will receive the minted tokens.
221    * @param _amount The amount of tokens to mint.
222    * @return A boolean that indicates if the operation was successful.
223    */
224   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
225     totalSupply = totalSupply.add(_amount);
226     balances[_to] = balances[_to].add(_amount);
227     Mint(_to, _amount);
228     Transfer(0x0, _to, _amount);
229     return true;
230   }
231 
232   /**
233    * @dev Function to stop minting new tokens.
234    * @return True if the operation was successful.
235    */
236   function finishMinting() onlyOwner public returns (bool) {
237     mintingFinished = true;
238     MintFinished();
239     return true;
240   }
241 }
242 
243 
244 /**
245  * @title Pausable
246  * @dev Base contract which allows children to implement an emergency stop mechanism.
247  */
248 contract Pausable is Ownable {
249   event Pause();
250   event Unpause();
251 
252   bool public paused = false;
253 
254   /**
255    * @dev Modifier to make a function callable only when the contract is not paused.
256    */
257   modifier whenNotPaused() {
258     require(!paused);
259     _;
260   }
261 
262   /**
263    * @dev Modifier to make a function callable only when the contract is paused.
264    */
265   modifier whenPaused() {
266     require(paused);
267     _;
268   }
269 
270   /**
271    * @dev called by the owner to pause, triggers stopped state
272    */
273   function pause() onlyOwner whenNotPaused public {
274     paused = true;
275     Pause();
276   }
277 
278   /**
279    * @dev called by the owner to unpause, returns to normal state
280    */
281   function unpause() onlyOwner whenPaused public {
282     paused = false;
283     Unpause();
284   }
285 
286 }
287 
288 contract PausableToken is StandardToken, Pausable {
289 
290   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
291     return super.transfer(_to, _value);
292   }
293 
294   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
295     return super.transferFrom(_from, _to, _value);
296   }
297 
298   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
299     return super.approve(_spender, _value);
300   }
301 
302 }
303 
304 /*
305  * @title GESToken
306  */
307 contract GESToken is MintableToken, PausableToken {
308   string public constant name = "Galaxy eSolutions";
309   string public constant symbol = "GES";
310   uint8 public constant decimals = 18;
311 }
312 
313 /**
314  * @title Crowdsale
315  * @dev Modified contract for managing a token crowdsale.
316  */
317 
318 contract GESTokenCrowdSale is Ownable {
319   using SafeMath for uint256;
320 
321   /* true for finalised crowdsale */
322   bool public isFinalised;
323 
324   /* The token object */
325   MintableToken public token;
326 
327   /* Start and end timestamps where investments are allowed (both inclusive) */
328   uint256 public mainSaleStartTime;
329   uint256 public mainSaleEndTime;
330 
331   /* Address where funds are transferref after collection */
332   address public wallet;
333 
334   /* Address where company funds will be collected */
335   address public tokenWallet;
336 
337   /* How many token units a buyer gets per ether */
338   uint256 public rate = 10000;
339 
340   /* Amount of raised money in wei */
341   /* PreSale = 793.030144223688 ETH */
342   /* Whitelist = 487.0798419 ETH */ 
343   /* PreSale + Whitelist =  1,280.1099861237 ETH*/
344   uint256 public weiRaised = 1280109986123700000000 ;
345 
346   /* 20,000 - 793.030144223688 - 487.0798419 = 18,719.89  is what will be raised*/
347 
348   /* Minimum amount of Wei allowed per transaction = 0.1 Ethers */
349   uint256 public saleMinimumWei = 100000000000000000; 
350   
351   /* Hard Cap amount of Wei allowed 20,000 ETH */
352   uint256 public hardCap = 20000000000000000000000; 
353   
354   /* Hard Cap amount oftokens to be sold 300000000 */
355   /* Amount raise in preSale removing the extra company 11% as we are allocating here */
356   /* 300000000 - 12235717 - 33000000 - 38358927 = 216405356 */
357   /* Tokens to be sold in the ICO 216405356 */
358   uint256 public tokensToSell = 216405356 * 10 ** 18; 
359 
360   /* Always default to 20 can go upto 50 base don amount being sent */
361    struct AmountBonus {
362     uint256 amount;
363     uint percent;
364   }
365   AmountBonus[] public amountBonuses;
366   /**
367    * event for token purchase logging
368    * event for finalizing the crowdsale
369    */
370   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
371   event FinalisedCrowdsale(uint256 totalSupply);
372 
373   function GESTokenCrowdSale(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, address _wallet, address _tokenWallet) public {
374 
375     /* Can't start main sale in the past */
376     require(_mainSaleStartTime >= now);
377     /* Can't close main sale earlier than start time */
378     require(_mainSaleEndTime >= _mainSaleStartTime);
379 
380     /* Confirming wallet addresses as valid */
381     require(_wallet != 0x0);
382     require(_tokenWallet != 0x0);
383 
384     /* Create GES token */
385     token = createTokenContract();
386     
387     amountBonuses.push(AmountBonus(    50000000000000000000, 20));
388     amountBonuses.push(AmountBonus(   100000000000000000000, 25));
389     amountBonuses.push(AmountBonus(   250000000000000000000, 30));
390     amountBonuses.push(AmountBonus(   500000000000000000000, 35));
391     amountBonuses.push(AmountBonus(  1000000000000000000000, 40));
392     amountBonuses.push(AmountBonus(  2500000000000000000000, 45));
393     amountBonuses.push(AmountBonus(200000000000000000000000, 50));
394 
395 
396     mainSaleStartTime = _mainSaleStartTime;
397     mainSaleEndTime = _mainSaleEndTime;
398 
399     wallet = _wallet ;
400     tokenWallet = _tokenWallet;
401 
402     isFinalised = false;
403 
404     /* Mint tokens for previous backers [Removed the previous 11% the company raised in presale]*/
405     /* 101964.308375680000000000 * 120 = 12235717 -> rounding to highest integer */
406     /* Fixed tokens for the whitelist money raised = 38358927*/
407     /* Fixed tokens for the management and bounty = 33000000 */
408     /* Total to allot: 38358927 + 12235717 + 33000000 = 83594644 */
409     token.mint(tokenWallet, 83594644 * 10 ** 18);
410   }
411 
412   /* Creates the token to be sold */
413   function createTokenContract() internal returns (MintableToken) {
414     return new GESToken();
415   }
416 
417   /* Fallback function can be used to buy tokens */
418   function () public payable {
419     buyTokens(msg.sender);
420   }
421 
422   /* Low level token purchase function */
423   function buyTokens(address beneficiary) public payable {
424     require(!isFinalised);
425     require(beneficiary != 0x0);
426     require(msg.value != 0);
427     require(now >= mainSaleStartTime && now <= mainSaleEndTime);
428     uint256 newRaise = weiRaised.add(msg.value);
429     require(msg.value >= saleMinimumWei && newRaise <= hardCap);
430 
431     /* Add bonus to tokens depends on the value */
432     uint256 bonusedTokens = applyBonus(msg.value);
433     
434     /* Check if we have available tokens to sell */
435     require(bonusedTokens < tokensToSell);
436 
437     /* Update state on the blockchain */
438     weiRaised = newRaise;
439     tokensToSell = tokensToSell.sub(bonusedTokens);
440     token.mint(beneficiary, bonusedTokens);
441     TokenPurchase(msg.sender, beneficiary, msg.value, bonusedTokens);
442   }
443 
444   /* Finish Crowdsale,
445    */
446   function finaliseCrowdsale() external onlyOwner returns (bool) {
447     require(!isFinalised);
448     token.finishMinting();
449     forwardFunds();
450     FinalisedCrowdsale(token.totalSupply());
451     isFinalised = true;
452     return true;
453   }
454 
455   /* Pause the token contract */
456   function pauseToken() external onlyOwner {
457     require(!isFinalised);
458     GESToken(token).pause();
459   }
460 
461   /* Unpause the token contract */
462   function unpauseToken() external onlyOwner {
463     GESToken(token).unpause();
464   }
465 
466   /* Transfer token's contract ownership to a new owner */
467   function transferTokenOwnership(address newOwner) external onlyOwner {
468     GESToken(token).transferOwnership(newOwner);
469   }
470 
471   /* @return true if main sale event has ended */
472   function mainSaleHasEnded() external constant returns (bool) {
473     return now > mainSaleEndTime;
474   }
475 
476   /* Send ether to the fund collection wallet */
477   function forwardFunds() internal {
478     wallet.transfer(this.balance);
479   }
480 
481   /* Set new dates for main-sale (emergency case) */
482   function setMainSaleDates(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime) public onlyOwner returns (bool) {
483     require(!isFinalised);
484     require(_mainSaleStartTime < _mainSaleEndTime);
485     mainSaleStartTime = _mainSaleStartTime;
486     mainSaleEndTime = _mainSaleEndTime;
487     return true;
488   }
489 
490   /* Function to calculate bonus tokens based on the amount sent by the contributor */
491   function applyBonus(uint256 weiAmount) internal constant returns (uint256 bonusedTokens) {
492     /* Bonus tokens to be added */
493     uint256 tokensToAdd = 0;
494 
495     /* Calculting the amont of tokens to be allocated based on rate and the money transferred */
496     uint256 tokens = weiAmount.mul(rate);
497     
498     for(uint8 i = 0; i < amountBonuses.length; i++){
499         if(weiAmount < amountBonuses[i].amount){
500            tokensToAdd = tokens.mul(amountBonuses[i].percent).div(100);
501             return tokens.add(tokensToAdd);
502         }
503     }
504     /* Default callback at 20%, just as a precaution */
505     return tokens.mul(120).div(100);
506   }
507 
508   /*  
509   * Function to extract funds as required before finalizing
510   */
511   function fetchFunds() onlyOwner public {
512     wallet.transfer(this.balance);
513   }
514 
515 }