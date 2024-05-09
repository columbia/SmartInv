1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 library SafeMath {
75 
76   /**
77   * @dev Multiplies two numbers, throws on overflow.
78   */
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     if (a == 0) {
81       return 0;
82     }
83     uint256 c = a * b;
84     assert(c / a == b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   /**
99   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102     assert(b <= a);
103     return a - b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 a, uint256 b) internal pure returns (uint256) {
110     uint256 c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 }
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120 
121   using SafeMath for uint256;
122 
123  
124 
125   mapping(address => uint256) balances;
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 }
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
236     uint oldValue = allowed[msg.sender][_spender];
237     if (_subtractedValue > oldValue) {
238       allowed[msg.sender][_spender] = 0;
239     } else {
240       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
241     }
242     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246 }
247 
248 
249 contract MintBurnableToken is StandardToken, Ownable {
250   event Mint(address indexed to, uint256 amount);
251   event MintFinished();
252 
253   bool public mintingFinished = false;
254 
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
262     totalSupply = totalSupply.add(_amount);
263     balances[_to] = balances[_to].add(_amount);
264     Mint(_to, _amount);
265     Transfer(address(0), _to, _amount);
266     return true;
267   }
268 
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 
275   event Burn(address indexed burner, uint256 value);
276 
277   /**
278    * @dev Burns a specific amount of tokens.
279    * @param _value The amount of token to be burned.
280    */
281   function burn(uint256 _value) public {
282     require(_value <= balances[msg.sender]);
283     // no need to require value <= totalSupply, since that would imply the
284     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
285 
286     address burner = msg.sender;
287     balances[burner] = balances[burner].sub(_value);
288     totalSupply = totalSupply.sub(_value);
289     Burn(burner, _value);
290     Transfer(burner, address(0), _value);
291   }
292 
293 }
294 
295 contract DLH is MintBurnableToken {
296 
297   string public constant name = "Depositor-investor L&H";
298 
299   string public constant symbol = "DLH";
300 
301   uint8 public constant decimals = 18;
302 
303 }
304 
305 contract ReentrancyGuard {
306 
307   /**
308    * @dev We use a single lock for the whole contract.
309    */
310   bool private rentrancy_lock = false;
311 
312   /**
313    * @dev Prevents a contract from calling itself, directly or indirectly.
314    * @notice If you mark a function `nonReentrant`, you should also
315    * mark it `external`. Calling one nonReentrant function from
316    * another is not supported. Instead, you can implement a
317    * `private` function doing the actual work, and a `external`
318    * wrapper marked as `nonReentrant`.
319    */
320   modifier nonReentrant() {
321     require(!rentrancy_lock);
322     rentrancy_lock = true;
323     _;
324     rentrancy_lock = false;
325   }
326 }
327 
328 contract Stateful {
329   enum State {
330   Private,
331   PreSale,
332   sellIsOver
333   }
334   State public state = State.Private;
335 
336   event StateChanged(State oldState, State newState);
337 
338   function setState(State newState) internal {
339     State oldState = state;
340     state = newState;
341     StateChanged(oldState, newState);
342   }
343 }
344 
345 contract PreICO is ReentrancyGuard, Ownable, Stateful {
346   using SafeMath for uint256;
347 
348   DLH public token;
349 
350   address public wallet;
351 
352 
353   uint256 public startPreICOTime;
354   uint256 public endPreICOTime;
355 
356   // how many token units a buyer gets per cent
357   uint256 public rate; //
358 
359   uint256 public priceUSD; // wei in one USD
360 
361   // amount of raised money in wei
362   uint256 public centRaised;
363 
364   uint256 public minimumInvest;
365 
366   uint256 public softCapPreSale; // IN USD CENT
367   uint256 public hardCapPreSale; // IN USD CENT
368   uint256 public hardCapPrivate; // IN USD CENT
369 
370   address public oracle;
371   address public manager;
372 
373   // investors => amount of money
374   mapping(address => uint) public balances;
375   mapping(address => uint) public balancesInCent;
376 
377   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
378 
379 
380   function PreICO(
381   address _wallet,
382   address _token,
383   uint256 _priceUSD,
384   uint256 _minimumInvest) public
385   {
386     require(_priceUSD != 0);
387     require(_wallet != address(0));
388     require(_token != address(0));
389     priceUSD = _priceUSD;
390     rate = 250000000000000000; // 0.25 * 1 ether per one cent
391     wallet = _wallet;
392     token = DLH(_token);
393     hardCapPrivate = 40000000;
394     minimumInvest = _minimumInvest; // in cents
395   }
396 
397   modifier saleIsOn() {
398     bool withinPeriod = now >= startPreICOTime && now <= endPreICOTime;
399     require(withinPeriod && state == State.PreSale || state == State.Private);
400     _;
401   }
402 
403   modifier isUnderHardCap() {
404     bool underHardCap;
405     if (state == State.Private){
406       underHardCap = centRaised < hardCapPrivate;
407     }
408     else {
409       underHardCap = centRaised < hardCapPreSale;
410     }
411     require(underHardCap);
412     _;
413   }
414 
415   modifier onlyOracle(){
416     require(msg.sender == oracle);
417     _;
418   }
419 
420   modifier onlyOwnerOrManager(){
421     require(msg.sender == manager || msg.sender == owner);
422     _;
423   }
424 
425   function hasEnded() public view returns (bool) {
426     return now > endPreICOTime;
427   }
428 
429   // Override this method to have a way to add business logic to your crowdsale when buying
430   function getTokenAmount(uint256 centValue) internal view returns(uint256) {
431     return centValue.mul(rate);
432   }
433 
434   // send ether to the fund collection wallet
435   // override to create custom fund forwarding mechanisms
436   function forwardFunds(uint256 value) internal {
437     wallet.transfer(value);
438   }
439 
440   function startPreSale(uint256 _softCapPreSale,
441   uint256 _hardCapPreSale,
442   uint256 period,
443   uint256 _start) public onlyOwner
444   {
445     startPreICOTime = _start;
446     endPreICOTime = startPreICOTime.add(period * 1 days);
447     softCapPreSale = _softCapPreSale;
448     hardCapPreSale = _hardCapPreSale;
449     setState(State.PreSale);
450   }
451 
452   function finishPreSale() public onlyOwner {
453     require(centRaised > softCapPreSale);
454     setState(State.sellIsOver);
455     token.transferOwnership(owner);
456     forwardFunds(this.balance);
457   }
458 
459   function setOracle(address _oracle) public  onlyOwner {
460     require(_oracle != address(0));
461     oracle = _oracle;
462   }
463 
464   // set manager's address
465   function setManager(address _manager) public  onlyOwner {
466     require(_manager != address(0));
467     manager = _manager;
468   }
469 
470   //set new rate
471   function changePriceUSD(uint256 _priceUSD) public  onlyOracle {
472     require(_priceUSD != 0);
473     priceUSD = _priceUSD;
474   }
475 
476   modifier refundAllowed()  {
477     require(state != State.Private && centRaised < softCapPreSale && now > endPreICOTime);
478     _;
479   }
480 
481   function refund() public refundAllowed nonReentrant {
482     uint valueToReturn = balances[msg.sender];
483     balances[msg.sender] = 0;
484     msg.sender.transfer(valueToReturn);
485   }
486 
487   function manualTransfer(address _to, uint _valueUSD) public saleIsOn isUnderHardCap onlyOwnerOrManager {
488     uint256 centValue = _valueUSD.mul(100);
489     uint256 tokensAmount = getTokenAmount(centValue);
490     centRaised = centRaised.add(centValue);
491     token.mint(_to, tokensAmount);
492     balancesInCent[_to] = balancesInCent[_to].add(centValue);
493   }
494 
495   function buyTokens(address beneficiary) saleIsOn isUnderHardCap nonReentrant public payable {
496     require(beneficiary != address(0) && msg.value.div(priceUSD) >= minimumInvest);
497     uint256 weiAmount = msg.value;
498     uint256 centValue = weiAmount.div(priceUSD);
499     uint256 tokens = getTokenAmount(centValue);
500     centRaised = centRaised.add(centValue);
501     token.mint(beneficiary, tokens);
502     balances[msg.sender] = balances[msg.sender].add(weiAmount);
503     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
504     if (centRaised > softCapPreSale || state == State.Private) {
505       forwardFunds(weiAmount);
506     }
507   }
508 
509   function () external payable {
510     buyTokens(msg.sender);
511   }
512 }