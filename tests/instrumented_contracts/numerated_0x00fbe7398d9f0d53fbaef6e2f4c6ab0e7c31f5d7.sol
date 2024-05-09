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
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   function Ownable() {
110     owner = msg.sender;
111   }
112 
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) onlyOwner public {
128     require(newOwner != address(0));
129     OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144   mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147   /**
148    * @dev Transfer tokens from one address to another
149    * @param _from address The address which you want to send tokens from
150    * @param _to address The address which you want to transfer to
151    * @param _value uint256 the amount of tokens to be transferred
152    */
153   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
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
213 
214 }
215 
216 
217 /**
218  * @title Mintable token
219  * @dev Simple ERC20 Token example, with mintable token creation
220  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
221  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
222  */
223 
224 contract MintableToken is StandardToken, Ownable {
225   event Mint(address indexed to, uint256 amount);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229 
230 
231   modifier canMint() {
232     require(!mintingFinished);
233     _;
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     Mint(_to, _amount);
246     Transfer(0x0, _to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner public returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is not paused.
275    */
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   /**
282    * @dev Modifier to make a function callable only when the contract is paused.
283    */
284   modifier whenPaused() {
285     require(paused);
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused public {
293     paused = true;
294     Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     Unpause();
303   }
304 }
305 
306 contract PausableToken is StandardToken, Pausable {
307 
308   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
313     return super.transferFrom(_from, _to, _value);
314   }
315 
316   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
317     return super.approve(_spender, _value);
318   }
319 
320   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
321     return super.increaseApproval(_spender, _addedValue);
322   }
323 
324   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
325     return super.decreaseApproval(_spender, _subtractedValue);
326   }
327 }
328 
329 
330 contract UAPToken is MintableToken, PausableToken {
331   string public constant name = "Auction Universal Program";
332   string public constant symbol = "UAP";
333   uint8 public constant decimals = 18;
334   
335   uint256 public initialSuppy = 8680500000 * 10 ** uint256(18);
336   
337   function UAPToken(address _tokenWallet)  public {
338     totalSupply = initialSuppy;
339     balances[_tokenWallet] = initialSuppy ;
340   }
341 }
342 
343 /**
344  * @title UAPCrowdsale
345  * @dev Modified contract for managing a token crowdsale.
346  * UAPCrowdsale have main sale periods, where investors can make
347  * token purchases and the crowdsale will assign them tokens based
348  * on a token per ETH rate.
349  * Funds collected are forwarded to a wallet by function call or finalization.
350  * main sale period has cap defined in tokens.
351  */
352 
353 contract UAPCrowdsale is Ownable {
354   using SafeMath for uint256;
355 
356   // true for finalised crowdsale
357   bool public isFinalised;
358 
359   // The token being sold
360   MintableToken public token;
361 
362   // start and end timestamps where main-investments are allowed (both inclusive)
363   uint256 public mainSaleStartTime;
364   uint256 public mainSaleEndTime;
365 
366   // address where funds are collected
367   address public wallet;
368 
369   // address where rest of the tokens will be collected
370   address public tokenWallet;
371 
372   // how many token units a buyer gets per wei
373   uint256 public rate;
374 
375   // amount of raised money in wei
376   uint256 public weiRaised;
377   
378   // total tokens to be sold
379   uint256 public tokensToSell= 319500000 * 10 ** uint256(18);
380 
381   /**
382    * event for token purchase logging
383    * @param purchaser who paid for the tokens
384    * @param beneficiary who got the tokens
385    * @param value weis paid for purchase
386    * @param amount amount of tokens purchased
387    */
388   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
389   event FinalisedCrowdsale();
390 
391   function UAPCrowdsale(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime, uint256 _rate, address _wallet, address _tokenWallet) public {
392 
393     // can't start main sale in the past
394     require(_mainSaleStartTime >= now);
395 
396     // the end of main sale can't happen before it's start
397     require(_mainSaleStartTime < _mainSaleEndTime);
398 
399     require(_rate > 0);
400     require(_wallet != 0x0);
401     require(_tokenWallet != 0x0);
402 
403     token = createTokenContract(_tokenWallet);
404 
405     mainSaleStartTime = _mainSaleStartTime;
406     mainSaleEndTime = _mainSaleEndTime;
407     
408     rate = _rate;
409     wallet = _wallet;
410     tokenWallet = _tokenWallet;
411     
412     isFinalised = false;
413   }
414 
415   // creates the token to be sold.
416   // override this method to have crowdsale of a specific mintable token.
417   function createTokenContract(address _tokenWallet) internal returns (MintableToken) {
418     return new UAPToken(_tokenWallet);
419   }
420 
421   // Fallback function can be used to buy tokens
422   function () public payable {
423     buyTokens(msg.sender);
424   }
425 
426   // low level token purchase function
427   function buyTokens(address beneficiary) public payable {
428     require(!isFinalised);
429     require(beneficiary != 0x0);
430     require(msg.value != 0);
431 
432     require(now >= mainSaleStartTime && now <= mainSaleEndTime);
433 
434     uint256 weiAmount = msg.value;
435 
436     // calculate token amount to be created
437     uint256 tokens = weiAmount.mul(rate);
438     
439     require(tokens <= tokensToSell);
440 
441     // update state
442     weiRaised = weiRaised.add(weiAmount);
443     tokensToSell = tokensToSell.sub(tokens);
444     token.mint(beneficiary, tokens);
445     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
446 
447   }
448 
449   // Finish crowdsale,
450   // stop minting forever
451 
452   function finaliseCrowdsale() external onlyOwner returns (bool) {
453     require(!isFinalised);
454     //Mint all remaining tokens to the token wallet.
455     token.mint(tokenWallet, tokensToSell);
456     token.finishMinting();
457     forwardFunds();
458     FinalisedCrowdsale();
459     isFinalised = true;
460     return true;
461   }
462 
463   // set new dates for main-sale (emergency case)
464   function setMainSaleDates(uint256 _mainSaleStartTime, uint256 _mainSaleEndTime) public onlyOwner returns (bool) {
465     require(!isFinalised);
466     require(_mainSaleStartTime < _mainSaleEndTime);
467     mainSaleStartTime = _mainSaleStartTime;
468     mainSaleEndTime = _mainSaleEndTime;
469     return true;
470   }
471   
472   // set new Rate  
473   function setRate(uint256 _rate) public onlyOwner returns(bool){
474       require(_rate > 0);
475       rate = _rate;
476       return true;
477   }
478 
479   function pauseToken() external onlyOwner {
480     require(!isFinalised);
481     UAPToken(token).pause();
482   }
483 
484   function unpauseToken() external onlyOwner {
485     UAPToken(token).unpause();
486   }
487   
488   // Transfer token ownership after token sale is completed.
489   function transferTokenOwnership(address newOwner) external onlyOwner {
490     require(newOwner != 0x0);
491     UAPToken(token).transferOwnership(newOwner);
492   }
493 
494   // @return true if main sale event has ended
495   function mainSaleHasEnded() external constant returns (bool) {
496     return now > mainSaleEndTime;
497   }
498 
499   // Send ether to the fund collection wallet
500   function forwardFunds() internal {
501     wallet.transfer(msg.value);
502   }
503   
504   // Function to extract funds as required before finalizing
505   function fetchFunds() onlyOwner public {
506     wallet.transfer(this.balance);
507   }
508 
509 }