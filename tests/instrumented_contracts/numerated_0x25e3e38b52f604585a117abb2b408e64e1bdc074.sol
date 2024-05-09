1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () public payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract CappedCrowdsale is Crowdsale {
124   using SafeMath for uint256;
125 
126   uint256 public cap;
127 
128   function CappedCrowdsale(uint256 _cap) public {
129     require(_cap > 0);
130     cap = _cap;
131   }
132 
133   // overriding Crowdsale#validPurchase to add extra cap logic
134   // @return true if investors can buy at the moment
135   function validPurchase() internal constant returns (bool) {
136     bool withinCap = weiRaised.add(msg.value) <= cap;
137     return super.validPurchase() && withinCap;
138   }
139 
140   // overriding Crowdsale#hasEnded to add cap logic
141   // @return true if crowdsale event has ended
142   function hasEnded() public constant returns (bool) {
143     bool capReached = weiRaised >= cap;
144     return super.hasEnded() || capReached;
145   }
146 
147 }
148 
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() public {
161     owner = msg.sender;
162   }
163 
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner public {
179     require(newOwner != address(0));
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 
186 contract FinalizableCrowdsale is Crowdsale, Ownable {
187   using SafeMath for uint256;
188 
189   bool public isFinalized = false;
190 
191   event Finalized();
192 
193   /**
194    * @dev Must be called after crowdsale ends, to do some extra finalization
195    * work. Calls the contract's finalization function.
196    */
197   function finalize() onlyOwner public {
198     require(!isFinalized);
199     require(hasEnded());
200 
201     finalization();
202     Finalized();
203 
204     isFinalized = true;
205   }
206 
207   /**
208    * @dev Can be overridden to add finalization logic. The overriding function
209    * should call super.finalization() to ensure the chain of finalization is
210    * executed entirely.
211    */
212   function finalization() internal {
213   }
214 }
215 
216 contract SelfPayPreSale is CappedCrowdsale, FinalizableCrowdsale {
217 
218   // number of participants in the SelfPay Pre-Sale
219   uint256 public numberOfPurchasers = 0;
220 
221   // Number of backers that have sent 10 or more ETH
222   uint256 public nbBackerWithMoreOrEqualTen = 0;
223 
224   // Total SXP
225   uint256 public sxpNumber = 0;
226 
227   // Ensure the gold level bonus can only be used once
228   bool public goldLevelBonusIsUsed = false;
229 
230   //
231   address private goldLevelBonusAddress=0x0;
232 
233   function SelfPayPreSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet, address _goldLevelBonusAddress)
234     CappedCrowdsale(_cap)
235     FinalizableCrowdsale()
236     Crowdsale(_startTime, _endTime, _rate, _wallet) public
237   {
238     goldLevelBonusAddress = _goldLevelBonusAddress;
239     // As goal needs to be met for a successful crowdsale the value needs to be less
240     // than or equal than a cap which is limit for accepted funds
241     require(_goal <= _cap);
242   }
243 
244   function createTokenContract() internal returns (MintableToken) {
245    return new SelfPayToken();
246   }
247 
248   /**
249    * @dev Calculates the amount of SXP coins the buyer gets
250    * @param weiAmount uint the amount of wei send to the contract
251    * @return uint the amount of tokens the buyer gets
252    */
253   function computeTokenWithBonus(uint256 weiAmount, address beneficiary) internal returns(uint256) {
254     // standard rate: 1 ETH : 300 SXP
255     uint256 tokens_ = weiAmount.mul(rate);
256 
257     // Specific gold level investor
258     if (beneficiary == goldLevelBonusAddress && weiAmount >= 50 ether && weiAmount <= 100 ether && !goldLevelBonusIsUsed) {
259 
260       // Gold level bonus: Exclusive bonus of 100% for one specific investor
261       tokens_ = tokens_.mul(200).div(100);
262       goldLevelBonusIsUsed = true;
263 
264     } else if (weiAmount >= 10 ether && nbBackerWithMoreOrEqualTen < 10) {
265 
266       // Silver level bonus: the first 10 participants that transfer 10 ETH or more will get 75% SXP bonus
267       tokens_ = tokens_.mul(175).div(100);
268       nbBackerWithMoreOrEqualTen++;
269 
270     } else {
271 
272       // Bronze level bonus: +60% bonus for everyone else during PRE SALE
273       tokens_ = tokens_.mul(160).div(100);
274 
275     }
276 
277     return tokens_;
278   }
279 
280   // low level token purchase function
281   function buyTokens(address beneficiary) public payable {
282     require(beneficiary != 0x0);
283     require(validPurchase());
284 
285     uint256 weiAmount = msg.value;
286 
287     // Calculate the number of tokens and any bonus tokens
288     uint256 tokens = computeTokenWithBonus(weiAmount, beneficiary);
289 
290     token.mint(beneficiary, tokens);
291     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
292 
293     // update state
294     weiRaised = weiRaised.add(weiAmount);
295     numberOfPurchasers = numberOfPurchasers + 1;
296     sxpNumber = sxpNumber.add(tokens);
297 
298     forwardFunds();
299   }
300 
301   function finalization() internal {
302     token.transferOwnership(owner);
303   }
304 
305 }
306 
307 contract ERC20Basic {
308   uint256 public totalSupply;
309   function balanceOf(address who) public constant returns (uint256);
310   function transfer(address to, uint256 value) public returns (bool);
311   event Transfer(address indexed from, address indexed to, uint256 value);
312 }
313 
314 contract BasicToken is ERC20Basic {
315   using SafeMath for uint256;
316 
317   mapping(address => uint256) balances;
318 
319   /**
320   * @dev transfer token for a specified address
321   * @param _to The address to transfer to.
322   * @param _value The amount to be transferred.
323   */
324   function transfer(address _to, uint256 _value) public returns (bool) {
325     require(_to != address(0));
326 
327     // SafeMath.sub will throw if there is not enough balance.
328     balances[msg.sender] = balances[msg.sender].sub(_value);
329     balances[_to] = balances[_to].add(_value);
330     Transfer(msg.sender, _to, _value);
331     return true;
332   }
333 
334   /**
335   * @dev Gets the balance of the specified address.
336   * @param _owner The address to query the the balance of.
337   * @return An uint256 representing the amount owned by the passed address.
338   */
339   function balanceOf(address _owner) public constant returns (uint256 balance) {
340     return balances[_owner];
341   }
342 
343 }
344 
345 contract ERC20 is ERC20Basic {
346   function allowance(address owner, address spender) public constant returns (uint256);
347   function transferFrom(address from, address to, uint256 value) public returns (bool);
348   function approve(address spender, uint256 value) public returns (bool);
349   event Approval(address indexed owner, address indexed spender, uint256 value);
350 }
351 
352 contract StandardToken is ERC20, BasicToken {
353 
354   mapping (address => mapping (address => uint256)) allowed;
355 
356 
357   /**
358    * @dev Transfer tokens from one address to another
359    * @param _from address The address which you want to send tokens from
360    * @param _to address The address which you want to transfer to
361    * @param _value uint256 the amount of tokens to be transferred
362    */
363   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
364     require(_to != address(0));
365 
366     uint256 _allowance = allowed[_from][msg.sender];
367 
368     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
369     // require (_value <= _allowance);
370 
371     balances[_from] = balances[_from].sub(_value);
372     balances[_to] = balances[_to].add(_value);
373     allowed[_from][msg.sender] = _allowance.sub(_value);
374     Transfer(_from, _to, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
380    *
381    * Beware that changing an allowance with this method brings the risk that someone may use both the old
382    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
383    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
384    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
385    * @param _spender The address which will spend the funds.
386    * @param _value The amount of tokens to be spent.
387    */
388   function approve(address _spender, uint256 _value) public returns (bool) {
389     allowed[msg.sender][_spender] = _value;
390     Approval(msg.sender, _spender, _value);
391     return true;
392   }
393 
394   /**
395    * @dev Function to check the amount of tokens that an owner allowed to a spender.
396    * @param _owner address The address which owns the funds.
397    * @param _spender address The address which will spend the funds.
398    * @return A uint256 specifying the amount of tokens still available for the spender.
399    */
400   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
401     return allowed[_owner][_spender];
402   }
403 
404   /**
405    * approve should be called when allowed[_spender] == 0. To increment
406    * allowed value is better to use this function to avoid 2 calls (and wait until
407    * the first transaction is mined)
408    * From MonolithDAO Token.sol
409    */
410   function increaseApproval (address _spender, uint _addedValue) public
411     returns (bool success) {
412     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
413     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414     return true;
415   }
416 
417   function decreaseApproval (address _spender, uint _subtractedValue) public
418     returns (bool success) {
419     uint oldValue = allowed[msg.sender][_spender];
420     if (_subtractedValue > oldValue) {
421       allowed[msg.sender][_spender] = 0;
422     } else {
423       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
424     }
425     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429 }
430 
431 contract BurnableToken is StandardToken {
432 
433     event Burn(address indexed burner, uint256 value);
434 
435     /**
436      * @dev Burns a specific amount of tokens.
437      * @param _value The amount of token to be burned.
438      */
439     function burn(uint256 _value) public {
440         require(_value > 0);
441 
442         address burner = msg.sender;
443         balances[burner] = balances[burner].sub(_value);
444         totalSupply = totalSupply.sub(_value);
445         Burn(burner, _value);
446     }
447 }
448 
449 contract MintableToken is StandardToken, Ownable {
450   event Mint(address indexed to, uint256 amount);
451   event MintFinished();
452 
453   bool public mintingFinished = false;
454 
455 
456   modifier canMint() {
457     require(!mintingFinished);
458     _;
459   }
460 
461   /**
462    * @dev Function to mint tokens
463    * @param _to The address that will receive the minted tokens.
464    * @param _amount The amount of tokens to mint.
465    * @return A boolean that indicates if the operation was successful.
466    */
467   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
468     totalSupply = totalSupply.add(_amount);
469     balances[_to] = balances[_to].add(_amount);
470     Mint(_to, _amount);
471     Transfer(0x0, _to, _amount);
472     return true;
473   }
474 
475   /**
476    * @dev Function to stop minting new tokens.
477    * @return True if the operation was successful.
478    */
479   function finishMinting() onlyOwner public returns (bool) {
480     mintingFinished = true;
481     MintFinished();
482     return true;
483   }
484 }
485 
486 contract SelfPayToken is MintableToken,BurnableToken {
487     string public constant name = "SelfPay.asia Token";
488     string public constant symbol = "SXP";
489     uint256 public decimals = 18;
490     bool public tradingStarted = false;
491 
492     /**
493      * @dev modifier that throws if trading has not started yet
494      */
495     modifier hasStartedTrading() {
496         require(tradingStarted);
497         _;
498     }
499 
500     /**
501      * @dev Allows the owner to enable the trading.
502      */
503     function startTrading() onlyOwner public {
504         tradingStarted = true;
505     }
506 
507     /**
508      * @dev Allows anyone to transfer the SelfPayToken tokens once trading has started
509      * @param _to the recipient address of the tokens.
510      * @param _value number of tokens to be transfered.
511      */
512     function transfer(address _to, uint _value) hasStartedTrading public returns (bool){
513         return super.transfer(_to, _value);
514     }
515 
516     /**
517      * @dev Allows anyone to transfer the SelfPayToken tokens once trading has started
518      * @param _from address The address which you want to send tokens from
519      * @param _to address The address which you want to transfer to
520      * @param _value uint the amout of tokens to be transfered
521      */
522     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool){
523         return super.transferFrom(_from, _to, _value);
524     }
525 }