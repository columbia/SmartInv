1 pragma solidity ^0.4.17;
2 
3 // File: contracts\helpers\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16   * @dev The Constructor sets the original owner of the contract to the
17   * sender account.
18   */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24   * @dev Throws if called by any other account other than owner.
25   */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts\helpers\SafeMath.sol
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90 }
91 
92 // File: contracts\token\ERC20Interface.sol
93 
94 contract ERC20Interface {
95 
96   event Transfer(address indexed from, address indexed to, uint256 value);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function allowance(address owner, address spender) public view returns (uint256);
106 
107 }
108 
109 // File: contracts\token\BaseToken.sol
110 
111 contract BaseToken is ERC20Interface {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev Obtain total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135   /**
136   * @dev Transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148 
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     require(_spender != address(0));
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167 
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185 
186     Transfer(_from, _to, _value);
187 
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 // File: contracts\token\MintableToken.sol
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 contract MintableToken is BaseToken, Ownable {
250 
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   /**
262    * @dev Function to mint tokens
263    * @param _to The address that will receive the minted tokens.
264    * @param _amount The amount of tokens to mint.
265    * @return A boolean that indicates if the operation was successful.
266    */
267   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
268     require(_to != address(0));
269 
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     MintFinished();
284     return true;
285   }
286 
287 }
288 
289 // File: contracts\crowdsale\Crowdsale.sol
290 
291 /**
292  * @title Crowdsale
293  * @dev Crowdsale is a base contract for managing a token crowdsale.
294  * Crowdsales have a start and end timestamps, where investors can make
295  * token purchases and the crowdsale will assign them tokens based
296  * on a token per ETH rate. Funds collected are forwarded to a wallet
297  * as they arrive. The contract requires a MintableToken that will be
298  * minted as contributions arrive, note that the crowdsale contract
299  * must be owner of the token in order to be able to mint it.
300  */
301 contract Crowdsale {
302   using SafeMath for uint256;
303 
304   /**
305    * event for token purchase logging
306    * @param purchaser who paid for the tokens
307    * @param beneficiary who got the tokens
308    * @param value weis paid for purchase
309    * @param tokens amount of tokens purchased
310    */
311   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
312 
313   // The token being sold
314   MintableToken public token;
315 
316   // start and end timestamps in UNIX.
317   uint256 public startTime;
318   uint256 public endTime;
319 
320   // how many tokens does a buyer get per wei
321   uint256 public rate;
322 
323   // wallet where funds are forwarded
324   address public wallet;
325 
326   // amount of raised money in wei
327   uint256 public weiRaised;
328   // amount of sold tokens
329   uint256 public tokensSold;
330 
331 
332   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
333     require(_startTime >= now);
334     require(_endTime >= _startTime);
335     require(_rate > 0);
336     require(_wallet != address(0));
337     require(_token != address(0));
338 
339     startTime = _startTime;
340     endTime = _endTime;
341     rate = _rate;
342     wallet = _wallet;
343     token = MintableToken(_token);
344   }
345 
346   // fallback function can be used to buy tokens
347   function () external payable {
348     buyTokens(msg.sender);
349   }
350 
351   // low level token purchase function
352   function buyTokens(address beneficiary) public payable {
353     require(beneficiary != address(0));
354     require(validPurchase());
355 
356     uint256 weiAmount = msg.value;
357 
358     // calculate token amount to be created
359     uint256 tokens = getTokenAmount(weiAmount);
360 
361     // update state
362     weiRaised = weiRaised.add(weiAmount);
363     tokensSold = tokensSold.add(tokens);
364 
365     token.mint(beneficiary, tokens);
366     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
367 
368     forwardFunds();
369   }
370 
371   // @return true if crowdsale event has ended
372   function hasEnded() public view returns (bool) {
373     return now > endTime;
374   }
375 
376   // Override this method to have a way to add business logic to your crowdsale when buying
377   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
378     return weiAmount.mul(rate);
379   }
380 
381   // send ether to the fund collection wallet
382   // override to create custom fund forwarding mechanisms
383   function forwardFunds() internal {
384     wallet.transfer(msg.value);
385   }
386 
387   // @return true if the transaction can buy tokens
388   function validPurchase() internal view returns (bool) {
389     bool withinPeriod = now >= startTime && now <= endTime;
390     bool nonZeroPurchase = msg.value != 0;
391     return withinPeriod && nonZeroPurchase;
392   }
393 
394 }
395 
396 // File: contracts\crowdsale\FinalizableCrowdsale.sol
397 
398 contract FinalizableCrowdsale is Crowdsale, Ownable {
399   using SafeMath for uint256;
400 
401   event Finalized();
402 
403   bool public isFinalized = false;
404 
405   /**
406    * @dev Must be called after crowdsale ends, to do some extra finalization
407    * work. Calls the contract's finalization function.
408    */
409   function finalize() onlyOwner public {
410     require(!isFinalized);
411     require(hasEnded());
412 
413     finalization();
414     Finalized();
415 
416     isFinalized = true;
417   }
418 
419   /**
420    * @dev Can be overridden to add finalization logic. The overriding function
421    * should call super.finalization() to ensure the chain of finalization is
422    * executed entirely.
423    */
424   function finalization() internal {
425   }
426 
427 }
428 
429 // File: contracts\crowdsale\TokenCappedCrowdsale.sol
430 
431 contract TokenCappedCrowdsale is Crowdsale {
432   using SafeMath for uint256;
433 
434   uint256 public tokenCap;
435 
436   function TokenCappedCrowdsale(uint256 _tokenCap) public {
437     require(_tokenCap > 0);
438     tokenCap = _tokenCap;
439   }
440 
441   function isCapReached() public view returns (bool) {
442     return tokensSold >= tokenCap;
443   }
444 
445   function hasEnded() public view returns (bool) {
446     return isCapReached() || super.hasEnded();
447   }
448 
449   // overriding Crowdsale#validPurchase to add extra cap logic
450   // @return true if investors can buy at the moment
451   function validPurchase() internal view returns (bool) {
452     bool withinCap = tokensSold.add(getTokenAmount(msg.value)) <= tokenCap;
453     return withinCap && super.validPurchase();
454   }
455 }
456 
457 // File: contracts\ZitKOINCrowdsale.sol
458 
459 contract ZitKOINCrowdsale is TokenCappedCrowdsale, FinalizableCrowdsale {
460   event RateChanged(uint256 newRate);
461 
462   uint256 private constant E18 = 10**18;
463 
464   // Max tokens sold = 500 million
465   uint256 private TOKEN_SALE_CAP = 500000000 * E18;
466 
467   // 200 million
468   uint256 public constant TEAM_TOKENS = 200000000 * E18;
469   address public constant TEAM_ADDRESS = 0x900f9dF4Dd7A5131adFd7da173E75e328968F5f3;
470 
471   // 170 million
472   uint256 public constant FUTURE_ME_TOKENS = 170000000 * E18;
473   address public constant FUTURE_ME_ADDRESS = 0x900f9dF4Dd7A5131adFd7da173E75e328968F5f3;
474 
475   // 80 million
476   uint256 public constant ADVISORS_TOKENS = 80000000 * E18;
477   address public constant ADVISORS_ADDRESS = 0x900f9dF4Dd7A5131adFd7da173E75e328968F5f3;
478 
479   // 50 million
480   uint256 public constant AIRDROP_TOKENS = 50000000 * E18;
481   address public constant AIRDROP_ADDRESS = 0x900f9dF4Dd7A5131adFd7da173E75e328968F5f3;
482 
483 
484   function ZitKOINCrowdsale(uint256 _startTime,
485                             uint256 _endTime,
486                             uint256 _rate,
487                             address _wallet,
488                             address _token)
489         TokenCappedCrowdsale(TOKEN_SALE_CAP)
490         Crowdsale(_startTime, _endTime, _rate, _wallet, _token) public {
491   }
492 
493   function setCrowdsaleWallet(address _wallet) public onlyOwner {
494     require(_wallet != address(0));
495     wallet = _wallet;
496   }
497 
498   function setRate(uint256 _rate) public onlyOwner  {
499     rate = _rate;
500     RateChanged(_rate);
501   }
502 
503   function finalization() internal {
504     token.mint(TEAM_ADDRESS, TEAM_TOKENS);
505     token.mint(FUTURE_ME_ADDRESS, FUTURE_ME_TOKENS);
506     token.mint(ADVISORS_ADDRESS, ADVISORS_TOKENS);
507     token.mint(AIRDROP_ADDRESS, AIRDROP_TOKENS);
508 
509     // finish minting
510     token.finishMinting();
511     // release ownership back to owner
512     token.transferOwnership(owner);
513     // finalize
514     super.finalization();
515   }
516 
517   // @dev Recover any mistakenly sent ERC20 tokens to the Crowdsale address
518   function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {
519     ERC20Interface(_erc20).transfer(msg.sender, _amount);
520   }
521 
522   function releaseTokenOwnership() public onlyOwner {
523     token.transferOwnership(owner);
524   }
525 }