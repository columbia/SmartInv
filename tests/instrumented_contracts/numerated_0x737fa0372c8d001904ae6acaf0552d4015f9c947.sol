1 contract Ownable {
2   address public owner;
3 
4 
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14 
15   /**
16    * @dev Throws if called by any account other than the owner.
17    */
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 
24 }
25 
26 contract Pausable is Ownable {
27   event Pause();
28   event Unpause();
29 
30   bool public paused = false;
31 
32 
33   /**
34    * @dev Modifier to make a function callable only when the contract is not paused.
35    */
36   modifier whenNotPaused() {
37     require(!paused);
38     _;
39   }
40 
41   /**
42    * @dev Modifier to make a function callable only when the contract is paused.
43    */
44   modifier whenPaused() {
45     require(paused);
46     _;
47   }
48 
49   /**
50    * @dev called by the owner to pause, triggers stopped state
51    */
52   function pause() onlyOwner whenNotPaused public {
53     paused = true;
54     emit Pause();
55   }
56 
57   /**
58    * @dev called by the owner to unpause, returns to normal state
59    */
60   function unpause() onlyOwner whenPaused public {
61     paused = false;
62     emit Unpause();
63   }
64 }
65 
66 contract medibitICO is Pausable {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71 mapping (address => mapping (address => uint256)) internal allowed;
72 
73 
74   //Gas/GWei
75   uint constant public minPublicContribAmount = 1 ether;
76   
77 
78   // The token being sold
79   medibitToken public token;
80   uint256 constant public tokenDecimals = 18;
81 
82 
83   // start and end timestamps where investments are allowed (both inclusive)
84   uint256 public startTime; 
85   uint256 public endTime; 
86 
87 
88   // need to be enabled to allow investor to participate in the ico
89   bool public icoEnabled;
90 
91   // address where funds are collected
92   address public walletOne;
93 
94   // amount of raised money in wei
95   uint256 public weiRaised;
96 
97   // totalSupply
98   uint256 public totalSupply = 50000000000 * (10 ** tokenDecimals);
99   uint256 constant public toekensForBTCandBonus = 12500000000 * (10 ** tokenDecimals);
100   uint256 constant public toekensForTeam = 5000000000 * (10 ** tokenDecimals);
101   uint256 constant public toekensForOthers = 22500000000 * (10 ** tokenDecimals);
102 
103 
104   //ICO tokens
105   //Is calcluated as: initialICOCap + preSaleCap
106   uint256 public icoCap;
107   uint256 public icoSoldTokens;
108   bool public icoEnded = false;
109 
110   address constant public walletTwo = 0x938Ee925D9EFf6698472a19EbAc780667999857B;
111   address constant public walletThree = 0x09E72590206d652BD1aCDB3A8e358AeB3f21513A;
112 
113   //Sale rates
114 
115   uint256 constant public STANDARD_RATE = 1500000;
116 
117   event Burn(address indexed from, uint256 value);
118 
119 
120   /**
121    * event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129 
130 
131   function medibitICO(address _walletOne) public {
132     require(_walletOne != address(0));
133     token = createTokenContract();
134     
135     //send all dao tokens to multiwallet
136     uint256 tokensToWallet1 = toekensForBTCandBonus;
137     uint256 tokensToWallet2 = toekensForTeam;
138     uint256 tokensToWallet3 = toekensForOthers;
139     
140     walletOne = _walletOne;
141     
142     token.transfer(walletOne, tokensToWallet1);
143     token.transfer(walletTwo, tokensToWallet2);
144     token.transfer(walletThree, tokensToWallet3);
145   }
146 
147 
148   //
149   // Token related operations
150   //
151 
152   // creates the token to be sold.
153   // override this method to have crowdsale of a specific mintable token.
154   function createTokenContract() internal returns (medibitToken) {
155     return new medibitToken();
156   }
157 
158 
159   // enable token tranferability
160   function enableTokenTransferability() external onlyOwner {
161     require(token != address(0));
162     token.unpause();
163   }
164 
165   // disable token tranferability
166   function disableTokenTransferability() external onlyOwner {
167     require(token != address(0));
168     token.pause();
169   }
170 
171   // transfer token to owner account for burn
172    function transferUnsoldIcoTokens() external onlyOwner {
173     require(token != address(0));
174     uint256 unsoldTokens = icoCap.sub(icoSoldTokens);
175     token.transfer(walletOne, unsoldTokens);
176    }
177 
178   //
179   // ICO related operations
180   //
181 
182   // set multisign wallet
183   function setwalletOne(address _walletOne) external onlyOwner{
184     // need to be set before the ico start
185     require(!icoEnabled || now < startTime);
186     require(_walletOne != address(0));
187     walletOne = _walletOne;
188   }
189 
190 
191   // set contribution dates
192   function setContributionDates(uint64 _startTime, uint64 _endTime) external onlyOwner{
193     require(!icoEnabled);
194     require(_startTime >= now);
195     require(_endTime >= _startTime);
196     startTime = _startTime;
197     endTime = _endTime;
198   }
199 
200 
201   // enable ICO, need to be true to actually start ico
202   // multisign wallet need to be set, because once ico started, invested funds is transfered to this address
203   // once ico is enabled, following parameters can not be changed anymore:
204   // startTime, endTime, soldPreSaleTokens
205   function enableICO() external onlyOwner{
206     icoEnabled = true;
207     icoCap = totalSupply;
208   }
209 
210   // fallback function can be used to buy tokens
211   function () payable whenNotPaused public {
212     buyTokens(msg.sender);
213   }
214 
215   // low level token purchase function
216   function buyTokens(address beneficiary) public payable whenNotPaused {
217     require(beneficiary != address(0));
218     require(validPurchase());
219 
220     uint256 weiAmount = msg.value;
221     uint256 returnWeiAmount;
222 
223     // calculate token amount to be created
224     uint rate = getRate();
225     assert(rate > 0);
226     uint256 tokens = weiAmount.mul(rate);
227 
228     uint256 newIcoSoldTokens = icoSoldTokens.add(tokens);
229 
230     if (newIcoSoldTokens > icoCap) {
231         newIcoSoldTokens = icoCap;
232         tokens = icoCap.sub(icoSoldTokens);
233         uint256 newWeiAmount = tokens.div(rate);
234         returnWeiAmount = weiAmount.sub(newWeiAmount);
235         weiAmount = newWeiAmount;
236     }
237 
238     // update state
239     weiRaised = weiRaised.add(weiAmount);
240 
241     token.transfer(beneficiary, tokens);
242     icoSoldTokens = newIcoSoldTokens;
243     if (returnWeiAmount > 0){
244         msg.sender.transfer(returnWeiAmount);
245     }
246 
247     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
248 
249     forwardFunds();
250   }
251 
252   // send ether to the fund collection wallet
253   // override to create custom fund forwarding mechanisms
254   function forwardFunds() internal {
255     walletOne.transfer(address(this).balance);
256   }
257 
258 
259 
260   // @return true if the transaction can buy tokens
261   function validPurchase() internal constant returns (bool) {
262     bool withinPeriod = now >= startTime && now <= endTime;
263     bool nonMinimumPurchase;
264     bool icoTokensAvailable = icoSoldTokens < icoCap;
265  
266     nonMinimumPurchase = msg.value >= minPublicContribAmount;
267     
268 
269     return !icoEnded && icoEnabled && withinPeriod && nonMinimumPurchase && icoTokensAvailable;
270   }
271 
272 
273 
274   // end ico by owner, not really needed in normal situation
275   function endIco() external onlyOwner {
276     icoEnded = true;
277     // send unsold tokens to multi-sign wallet
278     uint256 unsoldTokens = icoCap.sub(icoSoldTokens);
279     token.transfer(walletOne, unsoldTokens);
280   }
281 
282   // @return true if crowdsale event has ended
283   function hasEnded() public constant returns (bool) {
284     return (icoEnded || icoSoldTokens >= icoCap || now > endTime);
285   }
286 
287 
288   function getRate() public constant returns(uint){
289     require(now >= startTime);
290       return STANDARD_RATE;
291 
292   }
293 
294   // drain all eth for owner in an emergency situation
295   function drain() external onlyOwner {
296     owner.transfer(address(this).balance);
297   }
298 
299 }
300 
301 
302 
303 
304 
305 
306 
307 contract ERC20Basic {
308   uint256 public totalSupply;
309   function balanceOf(address who) public constant returns (uint256);
310   function transfer(address to, uint256 value) public returns (bool);
311   event Transfer(address indexed from, address indexed to, uint256 value);
312 }
313 
314 contract ERC20 is ERC20Basic {
315   function allowance(address owner, address spender)
316     public view returns (uint256);
317 
318   function transferFrom(address from, address to, uint256 value)
319     public returns (bool);
320 
321   function approve(address spender, uint256 value) public returns (bool);
322   event Approval(
323     address indexed owner,
324     address indexed spender,
325     uint256 value
326   );
327 }
328 
329 contract BasicToken is ERC20Basic {
330   using SafeMath for uint256;
331 
332   mapping(address => uint256) balances;
333 
334   /**
335   * @dev transfer token for a specified address
336   * @param _to The address to transfer to.
337   * @param _value The amount to be transferred.
338   */
339   function transfer(address _to, uint256 _value) public returns (bool) {
340     require(_to != address(0));
341     require(_value <= balances[msg.sender]);
342 
343     // SafeMath.sub will throw if there is not enough balance.
344     balances[msg.sender] = balances[msg.sender].sub(_value);
345     balances[_to] = balances[_to].add(_value);
346     emit Transfer(msg.sender, _to, _value);
347     return true;
348   }
349 
350   /**
351   * @dev Gets the balance of the specified address.
352   * @param _owner The address to query the the balance of.
353   * @return An uint256 representing the amount owned by the passed address.
354   */
355   function balanceOf(address _owner) public view returns (uint256 balance) {
356     return balances[_owner];
357   }
358 
359 }
360 
361 
362 library SafeERC20 {
363  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
364     require(token.transfer(to, value));
365   }
366 
367   function safeTransferFrom(
368     ERC20 token,
369     address from,
370     address to,
371     uint256 value
372   )
373     internal
374   {
375     require(token.transferFrom(from, to, value));
376   }
377 
378   function safeApprove(ERC20 token, address spender, uint256 value) internal {
379     require(token.approve(spender, value));
380   }
381 }
382 
383 
384 contract StandardToken is ERC20, BasicToken {
385  mapping (address => mapping (address => uint256)) internal allowed;
386 
387 
388   /**
389    * @dev Transfer tokens from one address to another
390    * @param _from address The address which you want to send tokens from
391    * @param _to address The address which you want to transfer to
392    * @param _value uint256 the amount of tokens to be transferred
393    */
394   function transferFrom(
395     address _from,
396     address _to,
397     uint256 _value
398   )
399     public
400     returns (bool)
401   {
402     require(_to != address(0));
403     require(_value <= balances[_from]);
404     require(_value <= allowed[_from][msg.sender]);
405 
406     balances[_from] = balances[_from].sub(_value);
407     balances[_to] = balances[_to].add(_value);
408     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
409     emit Transfer(_from, _to, _value);
410     return true;
411   }
412 
413   /**
414    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
415    * Beware that changing an allowance with this method brings the risk that someone may use both the old
416    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
417    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
418    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
419    * @param _spender The address which will spend the funds.
420    * @param _value The amount of tokens to be spent.
421    */
422   function approve(address _spender, uint256 _value) public returns (bool) {
423     allowed[msg.sender][_spender] = _value;
424     emit Approval(msg.sender, _spender, _value);
425     return true;
426   }
427 
428   /**
429    * @dev Function to check the amount of tokens that an owner allowed to a spender.
430    * @param _owner address The address which owns the funds.
431    * @param _spender address The address which will spend the funds.
432    * @return A uint256 specifying the amount of tokens still available for the spender.
433    */
434   function allowance(
435     address _owner,
436     address _spender
437    )
438     public
439     view
440     returns (uint256)
441   {
442     return allowed[_owner][_spender];
443   }
444 
445   /**
446    * @dev Increase the amount of tokens that an owner allowed to a spender.
447    * approve should be called when allowed[_spender] == 0. To increment
448    * allowed value is better to use this function to avoid 2 calls (and wait until
449    * the first transaction is mined)
450    * From MonolithDAO Token.sol
451    * @param _spender The address which will spend the funds.
452    * @param _addedValue The amount of tokens to increase the allowance by.
453    */
454   function increaseApproval(
455     address _spender,
456     uint256 _addedValue
457   )
458     public
459     returns (bool)
460   {
461     allowed[msg.sender][_spender] = (
462       allowed[msg.sender][_spender].add(_addedValue));
463     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
464     return true;
465   }
466 
467   /**
468    * @dev Decrease the amount of tokens that an owner allowed to a spender.
469    * approve should be called when allowed[_spender] == 0. To decrement
470    * allowed value is better to use this function to avoid 2 calls (and wait until
471    * the first transaction is mined)
472    * From MonolithDAO Token.sol
473    * @param _spender The address which will spend the funds.
474    * @param _subtractedValue The amount of tokens to decrease the allowance by.
475    */
476   function decreaseApproval(
477     address _spender,
478     uint256 _subtractedValue
479   )
480     public
481     returns (bool)
482   {
483     uint256 oldValue = allowed[msg.sender][_spender];
484     if (_subtractedValue > oldValue) {
485       allowed[msg.sender][_spender] = 0;
486     } else {
487       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
488     }
489     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
490     return true;
491   }
492 
493 }
494 
495 
496 
497 contract PausableToken is StandardToken, Pausable {
498   /**
499    * @dev modifier to allow actions only when the contract is not paused or
500    * the sender is the owner of the contract
501    */
502   modifier whenNotPausedOrOwner() {
503     require(msg.sender == owner || !paused);
504     _;
505   }
506 
507   function transfer(address _to, uint256 _value) public whenNotPausedOrOwner returns (bool) {
508     return super.transfer(_to, _value);
509   }
510 
511   function transferFrom(address _from, address _to, uint256 _value) public whenNotPausedOrOwner returns (bool) {
512     return super.transferFrom(_from, _to, _value);
513   }
514 
515   function approve(address _spender, uint256 _value) public whenNotPausedOrOwner returns (bool) {
516     return super.approve(_spender, _value);
517   }
518 
519   function increaseApproval(address _spender, uint _addedValue) public whenNotPausedOrOwner returns (bool success) {
520     return super.increaseApproval(_spender, _addedValue);
521   }
522 
523   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPausedOrOwner returns (bool success) {
524     return super.decreaseApproval(_spender, _subtractedValue);
525   }
526 
527 }
528 
529 contract medibitToken is PausableToken {
530   string constant public name = "MEDIBIT";
531   string constant public symbol = "MEDIBIT";
532   uint256 constant public decimals = 18;
533   uint256 constant TOKEN_UNIT = 10 ** uint256(decimals);
534   uint256 constant INITIAL_SUPPLY = 50000000000 * TOKEN_UNIT;
535 
536 
537   function medibitToken() public {
538     // Set untransferable by default to the token
539     paused = true;
540     // asign all tokens to the contract creator
541     totalSupply = INITIAL_SUPPLY;
542     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
543     balances[msg.sender] = INITIAL_SUPPLY;
544   }
545 
546 }
547 
548 library SafeMath {
549   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
550     uint256 c = a * b;
551     assert(a == 0 || c / a == b);
552     return c;
553   }
554 
555   function div(uint256 a, uint256 b) internal pure returns (uint256) {
556     // assert(b > 0); // Solidity automatically throws when dividing by 0
557     uint256 c = a / b;
558     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
559     return c;
560   }
561 
562   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
563     assert(b <= a);
564     return a - b;
565   }
566 
567   function add(uint256 a, uint256 b) internal pure returns (uint256) {
568     uint256 c = a + b;
569     assert(c >= a);
570     return c;
571   }
572 }