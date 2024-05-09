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
321   struct TimeBonus {
322     uint256 bonusPeriodEndTime;
323     uint percent;
324     uint256 weiCap;
325   }
326 
327   /* true for finalised crowdsale */
328   bool public isFinalised;
329 
330   /* The token object */
331   MintableToken public token;
332 
333   /* Start and end timestamps where investments are allowed (both inclusive) */
334   uint256 public mainSaleStartTime;
335   uint256 public mainSaleEndTime;
336 
337   /* Address where funds are transferref after collection */
338   address public wallet;
339 
340   /* Address where final 10% of funds will be collected */
341   address public tokenWallet;
342 
343   /* How many token units a buyer gets per ether */
344   uint256 public rate = 100;
345 
346   /* Amount of raised money in wei */
347   uint256 public weiRaised;
348 
349   /* Minimum amount of Wei allowed per transaction = 0.1 Ethers */
350   uint256 public saleMinimumWei = 100000000000000000; 
351 
352   TimeBonus[] public timeBonuses;
353 
354   /**
355    * event for token purchase logging
356    * event for finalizing the crowdsale
357    */
358   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
359   event FinalisedCrowdsale(uint256 totalSupply, uint256 minterBenefit);
360 
361   function GESTokenCrowdSale(uint256 _mainSaleStartTime, address _wallet, address _tokenWallet) public {
362 
363     /* Can't start main sale in the past */
364     require(_mainSaleStartTime >= now);
365 
366     /* Confirming wallet addresses as valid */
367     require(_wallet != 0x0);
368     require(_tokenWallet != 0x0);
369 
370     /* The Crowdsale bonus pattern
371      * 1 day = 86400 = 60 * 60 * 24 (Seconds * Minutes * Hours)
372      * 1 day * Number of days to close at, Bonus Percentage, Max Wei for which bonus is given  
373      */
374     timeBonuses.push(TimeBonus(86400 *  7,  30,    2000000000000000000000)); // 0 - 7 Days, 30 %, 2000 ETH
375     timeBonuses.push(TimeBonus(86400 *  14, 20,    5000000000000000000000)); // 8 -14 Days, 20 %, 2000ETH + 3000 ETH = 5000 ETH
376     timeBonuses.push(TimeBonus(86400 *  21, 10,   10000000000000000000000)); // 15-21 Days, 10 %, 5000 ETH + 5000 ETH = 10000 ETH
377     timeBonuses.push(TimeBonus(86400 *  60,  0,   25000000000000000000000)); // 22-60 Days, 0  %, 10000 ETH + 15000 ETH = 25000 ETH
378 
379     token = createTokenContract();
380     mainSaleStartTime = _mainSaleStartTime;
381     mainSaleEndTime = mainSaleStartTime + 60 days;
382     wallet = _wallet;
383     tokenWallet = _tokenWallet;
384     isFinalised = false;
385   }
386 
387   /* Creates the token to be sold */
388   function createTokenContract() internal returns (MintableToken) {
389     return new GESToken();
390   }
391 
392   /* Fallback function can be used to buy tokens */
393   function () payable {
394     buyTokens(msg.sender);
395   }
396 
397   /* Low level token purchase function */
398   function buyTokens(address beneficiary) public payable {
399     require(!isFinalised);
400     require(beneficiary != 0x0);
401     require(msg.value != 0);
402     require(now <= mainSaleEndTime && now >= mainSaleStartTime);
403     require(msg.value >= saleMinimumWei);
404 
405     /* Add bonus to tokens depends on the period */
406     uint256 bonusedTokens = applyBonus(msg.value);
407 
408     /* Update state on the blockchain */
409     weiRaised = weiRaised.add(msg.value);
410     token.mint(beneficiary, bonusedTokens);
411     TokenPurchase(msg.sender, beneficiary, msg.value, bonusedTokens);
412 
413   }
414 
415   /* Finish Crowdsale,
416    * Take totalSupply as 89% and mint 11% more to specified owner's wallet
417    * then stop minting forever.
418    */
419 
420   function finaliseCrowdsale() external onlyOwner returns (bool) {
421     require(!isFinalised);
422     uint256 totalSupply = token.totalSupply();
423     uint256 minterBenefit = totalSupply.mul(10).div(89);
424     token.mint(tokenWallet, minterBenefit);
425     token.finishMinting();
426     forwardFunds();
427     FinalisedCrowdsale(totalSupply, minterBenefit);
428     isFinalised = true;
429     return true;
430   }
431 
432   /* Set new dates for main-sale (emergency case) */
433   function setMainSaleDates(uint256 _mainSaleStartTime) public onlyOwner returns (bool) {
434     require(!isFinalised);
435     mainSaleStartTime = _mainSaleStartTime;
436     mainSaleEndTime = mainSaleStartTime + 60 days;
437     return true;
438   }
439 
440   /* Pause the token contract */
441   function pauseToken() external onlyOwner {
442     require(!isFinalised);
443     GESToken(token).pause();
444   }
445 
446   /* Unpause the token contract */
447   function unpauseToken() external onlyOwner {
448     GESToken(token).unpause();
449   }
450 
451   /* Transfer token's contract ownership to a new owner */
452   function transferTokenOwnership(address newOwner) external onlyOwner {
453     GESToken(token).transferOwnership(newOwner);
454   }
455 
456   /* @return true if main sale event has ended */
457   function mainSaleHasEnded() external constant returns (bool) {
458     return now > mainSaleEndTime;
459   }
460 
461   /* Send ether to the fund collection wallet */
462   function forwardFunds() internal {
463     wallet.transfer(this.balance);
464   }
465 
466   /* Function to calculate bonus tokens based on current time(now) and maximum cap per tier */
467   function applyBonus(uint256 weiAmount) internal constant returns (uint256 bonusedTokens) {
468     /* Bonus tokens to be added */
469     uint256 tokensToAdd = 0;
470 
471     /* Calculting the amont of tokens to be allocated based on rate and the money transferred*/
472     uint256 tokens = weiAmount.mul(rate);
473     uint256 diffInSeconds = now.sub(mainSaleStartTime);
474 
475     for (uint i = 0; i < timeBonuses.length; i++) {
476       /* If cap[i] is reached then skip */
477       if(weiRaised.add(weiAmount) <= timeBonuses[i].weiCap){
478         for(uint j = i; j < timeBonuses.length; j++){
479           /* Check which week period time it lies and use that percent */
480           if (diffInSeconds <= timeBonuses[j].bonusPeriodEndTime) {
481             tokensToAdd = tokens.mul(timeBonuses[j].percent).div(100);
482             return tokens.add(tokensToAdd);
483           }
484         }
485       }
486     }
487     
488   }
489 
490   /*  
491   * Function to extract funds as required before finalizing
492   */
493   function fetchFunds() onlyOwner public {
494     wallet.transfer(this.balance);
495   }
496 
497 }