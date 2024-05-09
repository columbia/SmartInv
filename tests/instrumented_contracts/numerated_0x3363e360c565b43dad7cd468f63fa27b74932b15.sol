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
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
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
79   function () payable {
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
128   function CappedCrowdsale(uint256 _cap) {
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
160   function Ownable() {
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
230   function SelfPayPreSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
231     CappedCrowdsale(_cap)
232     FinalizableCrowdsale()
233     Crowdsale(_startTime, _endTime, _rate, _wallet) public
234   {
235     // As goal needs to be met for a successful crowdsale the value needs to be less
236     // than or equal than a cap which is limit for accepted funds
237     require(_goal <= _cap);
238   }
239 
240   /**
241    * @dev Calculates the amount of SXP coins the buyer gets
242    * @param weiAmount uint the amount of wei send to the contract
243    * @return uint the amount of tokens the buyer gets
244    */
245   function computeTokenWithBonus(uint256 weiAmount, address beneficiary) internal returns(uint256) {
246     // standard rate: 1 ETH : 300 SXP
247     uint256 tokens_ = weiAmount.mul(rate);
248 
249     // Hardcoded address of the specific gold level beneficiary
250     // mainnet: 0x2157a35ce381175946d564ef64e22735286e61ea
251     // testnet: 0xCB61f584dCCd8762427ef44ee8eB4a24f4bC4a82 (accounts[7])
252     if (beneficiary == address(0xCB61f584dCCd8762427ef44ee8eB4a24f4bC4a82) && weiAmount >= 50 ether && !goldLevelBonusIsUsed) {
253       // Gold level bonus: Exclusive bonus of 100% for one specific investor
254       tokens_ = tokens_.mul(200).div(100);
255       goldLevelBonusIsUsed = true;
256     } else if (weiAmount >= 10 ether && nbBackerWithMoreOrEqualTen < 10) {
257       // Silver level bonus: the first 10 participants that transfer 10 ETH or more will get 75% SXP bonus
258       tokens_ = tokens_.mul(175).div(100);
259       nbBackerWithMoreOrEqualTen++;
260     } else {
261       // Bronze level bonus: +60% bonus for everyone else
262       tokens_ = tokens_.mul(160).div(100);
263     }
264 
265     return tokens_;
266   }
267 
268   // low level token purchase function
269   function buyTokens(address beneficiary) public payable {
270     require(beneficiary != 0x0);
271     require(validPurchase());
272 
273     uint256 weiAmount = msg.value;
274 
275     // Calculate the number of tokens and any bonus tokens
276     uint256 tokens = computeTokenWithBonus(weiAmount, beneficiary);
277 
278     token.mint(beneficiary, tokens);
279     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
280 
281     // update state
282     weiRaised = weiRaised.add(weiAmount);
283     numberOfPurchasers = numberOfPurchasers + 1;
284     sxpNumber = sxpNumber.add(tokens);
285 
286     forwardFunds();
287   }
288 
289   /**
290    * @dev Can be overridden to add finalization logic. The overriding function
291    * should call super.finalization() to ensure the chain of finalization is
292    * executed entirely.
293    */
294   function finalization() internal {
295     token.transferOwnership(owner);
296   }
297 
298 }
299 
300 contract ERC20Basic {
301   uint256 public totalSupply;
302   function balanceOf(address who) public constant returns (uint256);
303   function transfer(address to, uint256 value) public returns (bool);
304   event Transfer(address indexed from, address indexed to, uint256 value);
305 }
306 
307 contract BasicToken is ERC20Basic {
308   using SafeMath for uint256;
309 
310   mapping(address => uint256) balances;
311 
312   /**
313   * @dev transfer token for a specified address
314   * @param _to The address to transfer to.
315   * @param _value The amount to be transferred.
316   */
317   function transfer(address _to, uint256 _value) public returns (bool) {
318     require(_to != address(0));
319 
320     // SafeMath.sub will throw if there is not enough balance.
321     balances[msg.sender] = balances[msg.sender].sub(_value);
322     balances[_to] = balances[_to].add(_value);
323     Transfer(msg.sender, _to, _value);
324     return true;
325   }
326 
327   /**
328   * @dev Gets the balance of the specified address.
329   * @param _owner The address to query the the balance of.
330   * @return An uint256 representing the amount owned by the passed address.
331   */
332   function balanceOf(address _owner) public constant returns (uint256 balance) {
333     return balances[_owner];
334   }
335 
336 }
337 
338 contract ERC20 is ERC20Basic {
339   function allowance(address owner, address spender) public constant returns (uint256);
340   function transferFrom(address from, address to, uint256 value) public returns (bool);
341   function approve(address spender, uint256 value) public returns (bool);
342   event Approval(address indexed owner, address indexed spender, uint256 value);
343 }
344 
345 contract StandardToken is ERC20, BasicToken {
346 
347   mapping (address => mapping (address => uint256)) allowed;
348 
349 
350   /**
351    * @dev Transfer tokens from one address to another
352    * @param _from address The address which you want to send tokens from
353    * @param _to address The address which you want to transfer to
354    * @param _value uint256 the amount of tokens to be transferred
355    */
356   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
357     require(_to != address(0));
358 
359     uint256 _allowance = allowed[_from][msg.sender];
360 
361     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
362     // require (_value <= _allowance);
363 
364     balances[_from] = balances[_from].sub(_value);
365     balances[_to] = balances[_to].add(_value);
366     allowed[_from][msg.sender] = _allowance.sub(_value);
367     Transfer(_from, _to, _value);
368     return true;
369   }
370 
371   /**
372    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
373    *
374    * Beware that changing an allowance with this method brings the risk that someone may use both the old
375    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
376    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
377    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378    * @param _spender The address which will spend the funds.
379    * @param _value The amount of tokens to be spent.
380    */
381   function approve(address _spender, uint256 _value) public returns (bool) {
382     allowed[msg.sender][_spender] = _value;
383     Approval(msg.sender, _spender, _value);
384     return true;
385   }
386 
387   /**
388    * @dev Function to check the amount of tokens that an owner allowed to a spender.
389    * @param _owner address The address which owns the funds.
390    * @param _spender address The address which will spend the funds.
391    * @return A uint256 specifying the amount of tokens still available for the spender.
392    */
393   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
394     return allowed[_owner][_spender];
395   }
396 
397   /**
398    * approve should be called when allowed[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    */
403   function increaseApproval (address _spender, uint _addedValue)
404     returns (bool success) {
405     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
406     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
407     return true;
408   }
409 
410   function decreaseApproval (address _spender, uint _subtractedValue)
411     returns (bool success) {
412     uint oldValue = allowed[msg.sender][_spender];
413     if (_subtractedValue > oldValue) {
414       allowed[msg.sender][_spender] = 0;
415     } else {
416       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
417     }
418     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
419     return true;
420   }
421 
422 }
423 
424 contract BurnableToken is StandardToken {
425 
426     event Burn(address indexed burner, uint256 value);
427 
428     /**
429      * @dev Burns a specific amount of tokens.
430      * @param _value The amount of token to be burned.
431      */
432     function burn(uint256 _value) public {
433         require(_value > 0);
434 
435         address burner = msg.sender;
436         balances[burner] = balances[burner].sub(_value);
437         totalSupply = totalSupply.sub(_value);
438         Burn(burner, _value);
439     }
440 }
441 
442 contract MintableToken is StandardToken, Ownable {
443   event Mint(address indexed to, uint256 amount);
444   event MintFinished();
445 
446   bool public mintingFinished = false;
447 
448 
449   modifier canMint() {
450     require(!mintingFinished);
451     _;
452   }
453 
454   /**
455    * @dev Function to mint tokens
456    * @param _to The address that will receive the minted tokens.
457    * @param _amount The amount of tokens to mint.
458    * @return A boolean that indicates if the operation was successful.
459    */
460   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
461     totalSupply = totalSupply.add(_amount);
462     balances[_to] = balances[_to].add(_amount);
463     Mint(_to, _amount);
464     Transfer(0x0, _to, _amount);
465     return true;
466   }
467 
468   /**
469    * @dev Function to stop minting new tokens.
470    * @return True if the operation was successful.
471    */
472   function finishMinting() onlyOwner public returns (bool) {
473     mintingFinished = true;
474     MintFinished();
475     return true;
476   }
477 }
478 
479 contract SelfPayToken is MintableToken,BurnableToken {
480     string public constant name = "SelfPay Token";
481     string public constant symbol = "SXP";
482     uint256 public decimals = 18;
483     bool public tradingStarted = false;
484 
485     /**
486      * @dev modifier that throws if trading has not started yet
487      */
488     modifier hasStartedTrading() {
489         require(tradingStarted);
490         _;
491     }
492 
493     /**
494      * @dev Allows the owner to enable the trading.
495      */
496     function startTrading() onlyOwner public {
497         tradingStarted = true;
498     }
499 
500     /**
501      * @dev Allows anyone to transfer the SelfPayToken tokens once trading has started
502      * @param _to the recipient address of the tokens.
503      * @param _value number of tokens to be transfered.
504      */
505     function transfer(address _to, uint _value) hasStartedTrading public returns (bool){
506         return super.transfer(_to, _value);
507     }
508 
509     /**
510      * @dev Allows anyone to transfer the SelfPayToken tokens once trading has started
511      * @param _from address The address which you want to send tokens from
512      * @param _to address The address which you want to transfer to
513      * @param _value uint the amout of tokens to be transfered
514      */
515     function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool){
516         return super.transferFrom(_from, _to, _value);
517     }
518 }