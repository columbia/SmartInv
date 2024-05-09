1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract BasicToken {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 
56   /**
57   * @dev total number of tokens in existence
58   */
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 
91 contract ERC20 {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * @dev Increase the amount of tokens that an owner allowed to a spender.
153    *
154    * approve should be called when allowed[_spender] == 0. To increment
155    * allowed value is better to use this function to avoid 2 calls (and wait until
156    * the first transaction is mined)
157    * From MonolithDAO Token.sol
158    * @param _spender The address which will spend the funds.
159    * @param _addedValue The amount of tokens to increase the allowance by.
160    */
161   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   /**
168    * @dev Decrease the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197   address public owner;
198 
199   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   function Ownable() public {
206     owner = msg.sender;
207   }
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to transfer control of the contract to a newOwner.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) public onlyOwner {
222     require(newOwner != address(0));
223     OwnershipTransferred(owner, newOwner);
224     owner = newOwner;
225   }
226 
227 }
228 
229 /**
230  * @title Manageable
231  */
232 contract Manageable is Ownable
233 {
234 	address public manager;
235 	
236 	event ManagerChanged(address indexed _oldManager, address _newManager);
237 	
238 	function Manageable() public
239 	{
240 		manager = msg.sender;
241 	}
242 	
243 	modifier onlyManager()
244 	{
245 		require(msg.sender == manager);
246 		_;
247 	}
248 	
249 	modifier onlyOwnerOrManager() 
250 	{
251 		require(msg.sender == owner || msg.sender == manager);
252 		_;
253 	}
254 	
255 	function changeManager(address _newManager) onlyOwner public 
256 	{
257 		require(_newManager != address(0));
258 		
259 		address oldManager = manager;
260 		if (oldManager != _newManager)
261 		{
262 			manager = _newManager;
263 			
264 			ManagerChanged(oldManager, _newManager);
265 		}
266 	}
267 }
268 
269 /**
270  * @title Pausable
271  * @dev Base contract which allows children to implement an emergency stop mechanism.
272  */
273 contract Pausable is Manageable {
274   event Pause();
275   event Unpause();
276 
277   bool public paused = false;
278 
279 
280   /**
281    * @dev Modifier to make a function callable only when the contract is not paused.
282    */
283   modifier whenNotPaused() {
284     require(!paused);
285     _;
286   }
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is paused.
290    */
291   modifier whenPaused() {
292     require(paused);
293     _;
294   }
295 
296   /**
297    * @dev called by the owner to pause, triggers stopped state
298    */
299   function pause() onlyOwnerOrManager whenNotPaused public {
300     paused = true;
301     Pause();
302   }
303 
304   /**
305    * @dev called by the owner to unpause, returns to normal state
306    */
307   function unpause() onlyOwnerOrManager whenPaused public {
308     paused = false;
309     Unpause();
310   }
311 }
312 
313 /**
314  * @title Mintable token + Pausable token + BurnableToken
315  */
316 contract MintableToken is StandardToken, Manageable, Pausable  {
317   
318   string public name = "Pointium";
319   string public symbol = "PNT";
320   uint256 public decimals = 18;
321   
322   event Mint(address indexed to, uint256 amount);
323   event MintFinished();
324   event Burn(address indexed burner, uint256 value);
325 
326   bool public mintingFinished = false;
327 
328 
329   modifier canMint() {
330     require(!mintingFinished);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(address _to, uint256 _amount) onlyOwnerOrManager canMint public returns (bool) {
341     totalSupply_ = totalSupply_.add(_amount);
342     balances[_to] = balances[_to].add(_amount);
343     Mint(_to, _amount);
344     Transfer(address(0), _to, _amount);
345     return true;
346   }
347 
348   /**
349    * @dev Function to stop minting new tokens.
350    * @return True if the operation was successful.
351    */
352   function finishMinting() onlyOwnerOrManager canMint public returns (bool) {
353     mintingFinished = true;
354     MintFinished();
355     return true;
356   }
357   
358   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
359     return super.transfer(_to, _value);
360   }
361 
362   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
363     return super.transferFrom(_from, _to, _value);
364   }
365 
366   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
367     return super.approve(_spender, _value);
368   }
369 
370   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
371     return super.increaseApproval(_spender, _addedValue);
372   }
373 
374   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
375     return super.decreaseApproval(_spender, _subtractedValue);
376   }
377   
378   /**
379    * @dev Burns a specific amount of tokens.
380    * @param _value The amount of token to be burned.
381    */
382   function burn(uint256 _value) onlyOwnerOrManager public {
383     require(_value <= balances[msg.sender]);
384     // no need to require value <= totalSupply, since that would imply the
385     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
386 
387     address burner = msg.sender;
388     balances[burner] = balances[burner].sub(_value);
389     totalSupply_ = totalSupply_.sub(_value);
390     Burn(burner, _value);
391   }
392     function burn_from(address _address, uint256 _value) onlyOwnerOrManager public {
393     require(_value <= balances[_address]);
394     // no need to require value <= totalSupply, since that would imply the
395     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
396 
397     address burner = _address;
398     balances[burner] = balances[burner].sub(_value);
399     totalSupply_ = totalSupply_.sub(_value);
400     Burn(burner, _value);
401   }
402 }
403 
404 /**
405  * @title Crowdsale
406  */
407 contract Crowdsale is Manageable{
408   using SafeMath for uint256;
409 
410   bool public isFinalized = false;
411 
412   event Finalized();
413 
414   MintableToken public token; // The token being sold
415 
416   uint256 public startTime;
417   uint256 public endTime;
418 
419   address public wallet; // address where funds are collected
420 
421   uint256 public rate; // how many token units a buyer gets per wei
422 
423   uint256 public weiRaised; // amount of raised money in wei
424 
425   uint256 public cap; // a max amount of funds raised
426   
427   uint256 public tokenWeiMax;
428   
429   uint256 public tokenWeiMin;
430   
431   /**
432    * event for token purchase logging
433    * @param purchaser who paid for the tokens
434    * @param beneficiary who got the tokens
435    * @param value weis paid for purchase
436    * @param amount amount of tokens purchased
437    */
438   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
439   
440   function init(uint256 _startTime, uint256 _endTime, uint256 _cap, uint256 _rate, address _wallet, MintableToken _token, uint256 _tokenWeiMax, uint256 _tokenWeiMin) onlyOwner public{
441 
442     
443     require(_endTime >= _startTime);
444     require(_rate > 0);
445     require(_wallet != address(0));
446     require(_token != address(0));
447     require(_cap > 0);
448     require(_tokenWeiMax > 0);
449     require(_tokenWeiMin > 0);
450 
451     cap = _cap;
452     startTime = _startTime;
453     endTime = _endTime;
454     rate = _rate;
455     wallet = _wallet;
456     token = _token;
457     tokenWeiMax = _tokenWeiMax;
458     tokenWeiMin = _tokenWeiMin;
459   }
460 
461   // fallback function can be used to buy tokens
462   function () external payable {
463     buyTokens(msg.sender);
464   }
465 
466   // low level token purchase function
467   function buyTokens(address beneficiary) public payable {
468     require(beneficiary != address(0));
469     require(validPurchase());
470 
471     uint256 weiAmount = msg.value;
472 
473     // calculate token amount to be created
474     uint256 tokens = getTokenAmount(weiAmount);
475 
476     // update state
477     weiRaised = weiRaised.add(weiAmount);
478 
479     token.mint(beneficiary, tokens);
480     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
481 
482     forwardFunds();
483   }
484 
485   // @return true if crowdsale event has ended
486   function hasEnded() public view returns (bool) {
487     bool capReached = weiRaised >= cap;
488     return capReached || now > endTime;
489   }
490 
491   // Override this method to have a way to add business logic to your crowdsale when buying
492   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
493     if(now <= startTime.add(1209600)){
494         return weiAmount.mul(rate);
495     }
496     else{
497         return weiAmount.mul(rate.sub(8500));
498     }
499   }
500 
501   // send ether to the fund collection wallet
502   // override to create custom fund forwarding mechanisms
503   function forwardFunds() internal {
504     wallet.transfer(msg.value);
505   }
506 
507   // @return true if the transaction can buy tokens
508   function validPurchase() internal view returns (bool) {
509     bool withinPeriod = now >= startTime && now <= endTime;
510     bool nonZeroPurchase = msg.value != 0;
511     bool withinCap = weiRaised.add(msg.value) <= cap;
512     bool withinMaxMin = tokenWeiMax >= msg.value && tokenWeiMin <= msg.value;
513     return withinCap && withinPeriod && nonZeroPurchase && withinMaxMin;
514   }
515 }
516 
517 contract CrowdsaleManager is Manageable {
518     using SafeMath for uint256;
519     MintableToken public token;
520     Crowdsale public sale1;
521     Crowdsale public sale2;
522     
523     function CreateToken() onlyOwner public {
524         token = new MintableToken();
525         token.mint(0xB63E25a133635237f970B5B38B858DE8323E82B6,784000000000000000000000000);
526         token.pause();
527     }
528     
529     function createSale1() onlyOwner public
530     {
531         sale1 = new Crowdsale();
532     }
533     
534     function initSale1() onlyOwner public
535     {
536         uint256 startTime = 1522587600;
537         uint256 endTime = 1525006800;
538         uint256 cap = 2260000000000000000000;
539         uint256 rate = 110500; // bounus + normal
540         address wallet = 0x5F94072FA770E688C30F50C21410aA6bd5779d87;
541         uint256 tokenWeiMax = 500000000000000000000;
542         uint256 tokenWeiMin = 200000000000000000;
543         sale1.init(startTime, endTime, cap, rate, wallet, token, tokenWeiMax, tokenWeiMin);
544         token.changeManager(sale1);
545     }
546     
547     function createSale2() onlyOwner public
548     {
549         sale2 = new Crowdsale();
550     }
551     
552     function initSale2() onlyOwner public
553     {
554         uint256 startTime = 1525179600;
555         uint256 endTime = 1527598800;
556         uint256 cap = 6725000000000000000000;
557         uint256 rate = 93500; // bounus + normal
558         address wallet = 0x555b6789f0749fbcfA188f0140c38606B6021A86;
559         uint256 tokenWeiMax = 500000000000000000000;
560         uint256 tokenWeiMin = 200000000000000000;
561         sale2.init(startTime, endTime, cap, rate, wallet, token, tokenWeiMax, tokenWeiMin);
562         token.changeManager(sale2);
563     }
564     
565     function changeTokenManager(address _newManager) onlyOwner public
566     {
567   	    token.changeManager(_newManager);
568     }
569 }