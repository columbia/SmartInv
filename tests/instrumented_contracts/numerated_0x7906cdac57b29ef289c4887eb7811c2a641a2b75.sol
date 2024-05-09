1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * See https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address _who) public view returns (uint256);
61   function transfer(address _to, uint256 _value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address _owner, address _spender)
71     public view returns (uint256);
72 
73   function transferFrom(address _from, address _to, uint256 _value)
74     public returns (bool);
75 
76   function approve(address _spender, uint256 _value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances.
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) internal balances;
92 
93   uint256 internal totalSupply_;
94 
95   /**
96   * @dev Total number of tokens in existence
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalSupply_;
100   }
101 
102   /**
103   * @dev Transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * https://github.com/ethereum/EIPs/issues/20
130  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(
144     address _from,
145     address _to,
146     uint256 _value
147   )
148     public
149     returns (bool)
150   {
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153     require(_to != address(0));
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     emit Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(
184     address _owner,
185     address _spender
186    )
187     public
188     view
189     returns (uint256)
190   {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(
204     address _spender,
205     uint256 _addedValue
206   )
207     public
208     returns (bool)
209   {
210     allowed[msg.sender][_spender] = (
211       allowed[msg.sender][_spender].add(_addedValue));
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(
226     address _spender,
227     uint256 _subtractedValue
228   )
229     public
230     returns (bool)
231   {
232     uint256 oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue >= oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 /**
245  * @title Ownable
246  * @dev The Ownable contract has an owner address, and provides basic authorization control
247  * functions, this simplifies the implementation of "user permissions".
248  */
249 contract Ownable {
250   address public owner;
251 
252 
253   event OwnershipRenounced(address indexed previousOwner);
254   event OwnershipTransferred(
255     address indexed previousOwner,
256     address indexed newOwner
257   );
258 
259 
260   /**
261    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
262    * account.
263    */
264   constructor() public {
265     owner = msg.sender;
266   }
267 
268   /**
269    * @dev Throws if called by any account other than the owner.
270    */
271   modifier onlyOwner() {
272     require(msg.sender == owner);
273     _;
274   }
275 
276   /**
277    * @dev Allows the current owner to relinquish control of the contract.
278    * @notice Renouncing to ownership will leave the contract without an owner.
279    * It will not be possible to call the functions with the `onlyOwner`
280    * modifier anymore.
281    */
282   function renounceOwnership() public onlyOwner {
283     emit OwnershipRenounced(owner);
284     owner = address(0);
285   }
286 
287   /**
288    * @dev Allows the current owner to transfer control of the contract to a newOwner.
289    * @param _newOwner The address to transfer ownership to.
290    */
291   function transferOwnership(address _newOwner) public onlyOwner {
292     _transferOwnership(_newOwner);
293   }
294 
295   /**
296    * @dev Transfers control of the contract to a newOwner.
297    * @param _newOwner The address to transfer ownership to.
298    */
299   function _transferOwnership(address _newOwner) internal {
300     require(_newOwner != address(0));
301     emit OwnershipTransferred(owner, _newOwner);
302     owner = _newOwner;
303   }
304 }
305 
306 /**
307  * @title Pausable
308  * @dev Base contract which allows children to implement an emergency stop mechanism.
309  */
310 contract Pausable is Ownable  {
311   event Pause();
312   event Unpause();
313 
314   bool public paused = false;
315 
316 
317   /**
318    * @dev Modifier to make a function callable only when the contract is not paused.
319    */
320   modifier whenNotPaused() {
321     require(!paused);
322     _;
323   }
324 
325   /**
326    * @dev Modifier to make a function callable only when the contract is paused.
327    */
328   modifier whenPaused() {
329     require(paused);
330     _;
331   }
332 
333   /**
334    * @dev called by the owner to pause, triggers stopped state
335    */
336   function pause() public onlyOwner whenNotPaused {
337     paused = true;
338     emit Pause();
339   }
340 
341   /**
342    * @dev called by the owner to unpause, returns to normal state
343    */
344   function unpause() public onlyOwner whenPaused {
345     paused = false;
346     emit Unpause();
347   }
348 }
349 
350 contract NIX is StandardToken, Pausable {
351 
352     string public name; 
353     string public symbol;
354     uint8 public decimals;
355     //token available for reserved
356     uint256 public TOKEN_RESERVED = 35e5 * 10 **18;
357     uint256 public TOKEN_FOUNDERS_TEAMS = 525e4 * 10 **18;
358     uint256 public TOKEN_ADVISORS = 175e4 * 10 **18;
359     uint256 public TOKEN_MARKETING = 175e3 * 10 **18;
360 
361    constructor () public {
362         name = "Encrypt Index";
363         symbol = "NIX";
364         decimals = 18;
365         totalSupply_ = 35e6 * 10  **  uint256(decimals); //35 millions
366         balances[owner] = totalSupply_;
367    }
368 }
369 
370 contract Sale is NIX{
371 
372     using SafeMath for uint256;
373     // To indicate Sale status; saleStatus=0 => sale not started; saleStatus=1=> sale started; saleStatus=2=> sale finished
374     uint256 public saleStatus; 
375     // To store sale type; saleType=0 => private sale ,saleType=1 => PreSale; saleType=2 => public sale
376     uint256 public saleType; 
377     //price of token in cents
378     uint256 public tokenCostPrivate = 8; //5 cents i.e., .5$
379     //price of token in cents
380     uint256 public tokenCostPre = 9; //5 cents i.e., .5$
381     //price of token in cents
382     uint256 public tokenCostPublic = 10; //5 cents i.e., .5$
383     //1 eth = usd in cents, eg: 1 eth = 107.91$ so, 1 eth = =107,91 cents
384     uint256 public ETH_USD;
385     //min contribution 
386     uint256 public minContribution = 1000000; //10000,00 cents i.e., 10000.00$
387     //coinbase account
388     address public wallet;
389     //soft cap
390     uint256 public softCap = 500000000; //$5 million
391     //hard cap
392     uint256 public hardCap = 1500000000; //$15 million
393     //store total wei raised
394     uint256 public weiRaised;
395     //initially whitelisting is false  
396     bool public whitelistingEnabled = false;
397 
398     //Structure to store token sent and wei received by the buyer of tokens
399     struct Investor {
400         uint256 weiReceived;
401         uint256 tokenSent;
402     }
403 
404     //investors indexed by their ETH address
405     mapping(address => Investor) public investors;
406     //whitelisting address
407     mapping (address => bool) public whitelisted;
408 
409     
410     /*
411     * constructor invoked with wallet and eth_usd parameter
412     */
413     constructor (address _wallet, uint256 _ETH_USD) public{
414       require(_wallet != address(0x0), "wallet address must not be zero");
415       wallet = _wallet;
416       ETH_USD = _ETH_USD;
417     }
418     
419     /*
420     * fallback function to create tokens
421     */
422     function () external payable{
423         createTokens(msg.sender);
424     }
425 
426     /*
427     * function to change wallet
428     */
429     function changeWallet(address _wallet) public onlyOwner{
430       require(_wallet != address(0x0), "wallet address must not be zero");
431       wallet = _wallet;
432     }
433 
434     /*
435     * drain ethers from contract
436     */
437     function drain() external onlyOwner{
438       wallet.transfer(address(this).balance);
439     }
440 
441     /*
442     * function to change whitelisting status
443     */
444     function toggleWhitelist() public onlyOwner{
445         whitelistingEnabled = !whitelistingEnabled;
446     }
447 
448     /*
449     * function to change eth usd rate
450     */
451     function changeETH_USD(uint256 _ETH_USD) public onlyOwner{
452         ETH_USD = _ETH_USD;
453     }
454 
455     /*
456     * function to add user to whitelist
457     */
458     function whitelistAddress(address investor) public onlyOwner{
459         require(!whitelisted[investor], "users is already whitelisted");
460         whitelisted[investor] = true;
461     }
462 
463     /*
464     * To start private sale
465     */
466     function startPrivateSale(uint256 _ETH_USD) public onlyOwner{
467       require (saleStatus == 0);
468       ETH_USD = _ETH_USD;
469       saleStatus = 1;
470     }
471 
472     /*
473     * To start pre sale
474     */
475     function startPreSale(uint256 _ETH_USD) public onlyOwner{
476       require (saleStatus == 1 && saleType == 0);
477       ETH_USD = _ETH_USD;
478       saleType = 1;
479     }
480 
481     /*
482     * To start public sale
483     */
484     function startPublicSale(uint256 _ETH_USD) public onlyOwner{
485       require (saleStatus == 1 && saleType == 1);
486       ETH_USD = _ETH_USD;
487       saleType = 2;
488     }
489 
490     /**
491     * Set new minimum contribution
492     * _minContribution minimum contribution in cents
493     *
494     */
495     function changeMinContribution(uint256 _minContribution) public onlyOwner {
496         require(_minContribution > 0, "min contribution should be greater than 0");
497         minContribution = _minContribution;
498     }
499 
500     /*
501     * To create NIX Token and assign to transaction initiator
502     */
503     function createTokens(address _beneficiary) internal {
504        _preValidatePurchase(_beneficiary, msg.value);
505       //Calculate NIX Token to send
506       uint256 totalNumberOfTokenTransferred = _getTokenAmount(msg.value);
507 
508       //transfer tokens to investor
509       transferTokens(_beneficiary, totalNumberOfTokenTransferred);
510 
511       //initializing structure for the address of the beneficiary
512       Investor storage _investor = investors[_beneficiary];
513       //Update investor's balance
514       _investor.tokenSent = _investor.tokenSent.add(totalNumberOfTokenTransferred);
515       _investor.weiReceived = _investor.weiReceived.add(msg.value);
516       weiRaised = weiRaised.add(msg.value);
517       wallet.transfer(msg.value);
518     }
519     
520     function transferTokens(address toAddr, uint256 value) private{
521         balances[owner] = balances[owner].sub(value);
522         balances[toAddr] = balances[toAddr].add(value);
523         emit Transfer(owner, toAddr, value);
524     }
525 
526     /**
527     * function to create number of tokens to be transferred
528     *
529     */
530 
531     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
532       if(saleType == 0){
533         return (_weiAmount.mul(ETH_USD).mul(100)).div((tokenCostPrivate).mul(80)); // 20% discount
534       }else if(saleType == 1){
535         return (_weiAmount.mul(ETH_USD).mul(100)).div((tokenCostPrivate).mul(90)); // 10% discount
536       }else if (saleType == 2){
537         return (_weiAmount.mul(ETH_USD).mul(100)).div((tokenCostPrivate).mul(95)); //5% discount
538       }
539     }
540 
541     /**
542     * validatess sale requirement before creating tokens
543     *
544     */
545     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) whenNotPaused internal view{
546       require(_beneficiary != address(0), "beneficiary address must not be zero");
547       require(whitelistingEnabled == false || whitelisted[_beneficiary],
548                 "whitelisting should be disabled or users should be whitelisted");
549       //Make sure Sale is running
550       assert(saleStatus == 1);
551       require(_weiAmount >= getMinContributionInWei(), "amount is less than min contribution" );
552     }
553 
554     /**
555     * gives minimum contribution in wei
556     * the min contribution value in wei
557     *
558     */
559     function getMinContributionInWei() public view returns(uint256){
560       return (minContribution.mul(1e18)).div(ETH_USD);
561     }
562 
563     /**
564     * gives usd raised based on wei raised
565     * the usd value in cents
566     *
567     */
568     function usdRaised() public view returns (uint256) {
569       return weiRaised.mul(ETH_USD).div(1e18);
570     }
571 
572     /**
573     * tell soft cap reached or not
574     * bool true=> if reached
575     *
576     */
577     function isSoftCapReached() public view returns (bool) {
578       if(usdRaised() >= softCap){
579         return true;
580       }
581     }
582 
583     /**
584     * tell hard cap reached or not
585     * bool true=> if reached
586     *
587     */
588     function isHardCapReached() public view returns (bool) {
589       if(usdRaised() >= hardCap){
590         return true;
591       }
592     }
593 
594 }