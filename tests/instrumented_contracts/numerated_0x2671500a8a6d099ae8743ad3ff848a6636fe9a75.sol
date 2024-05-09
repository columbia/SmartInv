1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35 
36   modifier onlyOwner() {
37     require(isOwner());
38     _;
39   }
40 
41   /**
42    * @return true if `msg.sender` is the owner of the contract.
43    */
44   function isOwner() public view returns(bool) {
45     return msg.sender == _owner;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    * @notice Renouncing to ownership will leave the contract without an owner.
51    * It will not be possible to call the functions with the `onlyOwner`
52    * modifier anymore.
53    */
54 
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64 
65   function transferOwnership(address newOwner) public onlyOwner {
66     _transferOwnership(newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73 
74   function _transferOwnership(address newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 /*
82  * Haltable
83  *
84  * Abstract contract that allows children to implement an
85  * emergency stop mechanism. Differs from Pausable by requiring a state.
86  *
87  * Originally envisioned in FirstBlood ICO contract.
88  */
89 
90 contract Haltable is Ownable {
91   bool public halted = false;
92 
93   modifier inNormalState {
94     require(!halted);
95     _;
96   }
97 
98   modifier inEmergencyState {
99     require(halted);
100     _;
101   }
102 
103   // called by the owner on emergency, triggers stopped state
104   function halt() external onlyOwner inNormalState {
105     halted = true;
106   }
107 
108   // called by the owner on end of emergency, returns to normal state
109   function unhalt() external onlyOwner inEmergencyState {
110     halted = false;
111   }
112 }
113 
114 /**
115  * @title SafeMath
116  * @dev Math operations with safety checks that revert on error
117  */
118 library SafeMath {
119 
120   /**
121   * @dev Multiplies two numbers, reverts on overflow.
122   */
123   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125     // benefit is lost if 'b' is also tested.
126     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127     if (a == 0) {
128       return 0;
129     }
130 
131     uint256 c = a * b;
132     require(c / a == b);
133 
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     require(b > 0); // Solidity only automatically asserts when dividing by 0
142     uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145     return c;
146   }
147 
148   /**
149   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     require(b <= a);
153     uint256 c = a - b;
154 
155     return c;
156   }
157 
158   /**
159   * @dev Adds two numbers, reverts on overflow.
160   */
161   function add(uint256 a, uint256 b) internal pure returns (uint256) {
162     uint256 c = a + b;
163     require(c >= a);
164 
165     return c;
166   }
167 
168   /**
169   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
170   * reverts when dividing by zero.
171   */
172   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173     require(b != 0);
174     return a % b;
175   }
176 }
177 
178 /**
179  * @title SafeMath
180  * @dev Math operations with safety checks that revert on error
181  */
182 
183 /**
184  * @title ERC20Basic
185  * @dev Simpler version of ERC20 interface
186  * See https://github.com/ethereum/EIPs/issues/179
187  */
188 contract ERC20Basic {
189   function totalSupply() public view returns (uint256);
190   function balanceOf(address who) public view returns (uint256);
191   function transfer(address to, uint256 value) public returns (bool);
192   event Transfer(address indexed from, address indexed to, uint256 value);
193 }
194 
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 contract ERC20 is ERC20Basic {
200   function allowance(address owner, address spender)
201     public view returns (uint256);
202 
203   function transferFrom(address from, address to, uint256 value)
204     public returns (bool);
205 
206   function approve(address spender, uint256 value) public returns (bool);
207   event Approval(
208     address indexed owner,
209     address indexed spender,
210     uint256 value
211   );
212 }
213 
214 /**
215  * @title DetailedERC20 token
216  * @dev The decimals are only for visualization purposes.
217  * All the operations are done using the smallest and indivisible token unit,
218  * just as on Ethereum all the operations are done in wei.
219  */
220 contract DetailedERC20 is ERC20 {
221   string public name;
222   string public symbol;
223   uint8 public decimals;
224 
225   constructor(string _name, string _symbol, uint8 _decimals) public {
226     name = _name;
227     symbol = _symbol;
228     decimals = _decimals;
229   }
230 }
231 
232 /**
233  * @title Basic token
234  * @dev Basic version of StandardToken, with no allowances.
235  */
236 contract BasicToken is ERC20Basic {
237   using SafeMath for uint256;
238 
239   mapping(address => uint256) balances;
240 
241   uint256 totalSupply_;
242 
243   /**
244   * @dev Total number of tokens in existence
245   */
246   function totalSupply() public view returns (uint256) {
247     return totalSupply_;
248   }
249 
250   /**
251   * @dev Transfer token for a specified address
252   * @param _to The address to transfer to.
253   * @param _value The amount to be transferred.
254   */
255   function transfer(address _to, uint256 _value) public returns (bool) {
256     require(_to != address(0));
257     require(_value <= balances[msg.sender]);
258 
259     balances[msg.sender] = balances[msg.sender].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     emit Transfer(msg.sender, _to, _value);
262     return true;
263   }
264 
265   /**
266   * @dev Gets the balance of the specified address.
267   * @param _owner The address to query the the balance of.
268   * @return An uint256 representing the amount owned by the passed address.
269   */
270   function balanceOf(address _owner) public view returns (uint256) {
271     return balances[_owner];
272   }
273 
274 }
275 
276 /**
277  * @title Standard ERC20 token
278  *
279  * @dev Implementation of the basic standard token.
280  * https://github.com/ethereum/EIPs/issues/20
281  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
282  */
283 
284 contract StandardToken is DetailedERC20, BasicToken {
285 
286   mapping (address => mapping (address => uint256)) internal allowed;
287 
288 
289   /**
290    * @dev Transfer tokens from one address to another
291    * @param _from address The address which you want to send tokens from
292    * @param _to address The address which you want to transfer to
293    * @param _value uint256 the amount of tokens to be transferred
294    */
295   function transferFrom(
296     address _from,
297     address _to,
298     uint256 _value
299   )
300     public
301     returns (bool)
302   {
303     require(_to != address(0));
304     require(_value <= balances[_from]);
305     require(_value <= allowed[_from][msg.sender]);
306 
307     balances[_from] = balances[_from].sub(_value);
308     balances[_to] = balances[_to].add(_value);
309     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
310     emit Transfer(_from, _to, _value);
311     return true;
312   }
313 
314   /**
315    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
316    * Beware that changing an allowance with this method brings the risk that someone may use both the old
317    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
318    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
319    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320    * @param _spender The address which will spend the funds.
321    * @param _value The amount of tokens to be spent.
322    */
323   function approve(address _spender, uint256 _value) public returns (bool) {
324     allowed[msg.sender][_spender] = _value;
325     emit Approval(msg.sender, _spender, _value);
326     return true;
327   }
328 
329   /**
330    * @dev Function to check the amount of tokens that an owner allowed to a spender.
331    * @param _owner address The address which owns the funds.
332    * @param _spender address The address which will spend the funds.
333    * @return A uint256 specifying the amount of tokens still available for the spender.
334    */
335   function allowance(
336     address _owner,
337     address _spender
338    )
339     public
340     view
341     returns (uint256)
342   {
343     return allowed[_owner][_spender];
344   }
345 
346   /**
347    * @dev Increase the amount of tokens that an owner allowed to a spender.
348    * approve should be called when allowed[_spender] == 0. To increment
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _addedValue The amount of tokens to increase the allowance by.
354    */
355   function increaseApproval(
356     address _spender,
357     uint256 _addedValue
358   )
359     public
360     returns (bool)
361   {
362     allowed[msg.sender][_spender] = (
363       allowed[msg.sender][_spender].add(_addedValue));
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    * approve should be called when allowed[_spender] == 0. To decrement
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _subtractedValue The amount of tokens to decrease the allowance by.
376    */
377   function decreaseApproval(
378     address _spender,
379     uint256 _subtractedValue
380   )
381     public
382     returns (bool)
383   {
384     uint256 oldValue = allowed[msg.sender][_spender];
385     if (_subtractedValue > oldValue) {
386       allowed[msg.sender][_spender] = 0;
387     } else {
388       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
389     }
390     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391     return true;
392   }
393 
394 }
395 
396 contract ZEON is StandardToken { //!
397 
398   constructor() public DetailedERC20("ZEON", "ZEON", 18) { //!
399     totalSupply_ = 50000000000000000000000000000;
400     balances[msg.sender] = totalSupply_;
401     emit Transfer(address(0), msg.sender, totalSupply_);
402   }
403 }
404 
405 contract InvestorWhiteList is Ownable {
406   mapping (address => bool) public investorWhiteList;
407 
408   mapping (address => address) public referralList;
409 
410   function InvestorWhiteList() {
411 
412   }
413 
414   function addInvestorToWhiteList(address investor) external onlyOwner {
415     require(investor != 0x0 && !investorWhiteList[investor]);
416     investorWhiteList[investor] = true;
417   }
418 
419   function removeInvestorFromWhiteList(address investor) external onlyOwner {
420     require(investor != 0x0 && investorWhiteList[investor]);
421     investorWhiteList[investor] = false;
422   }
423 
424   //when new user will contribute ICO contract will automatically send bonus to referral
425   function addReferralOf(address investor, address referral) external onlyOwner {
426     require(investor != 0x0 && referral != 0x0 && referralList[investor] == 0x0 && investor != referral);
427     referralList[investor] = referral;
428   }
429 
430   function isAllowed(address investor) constant external returns (bool result) {
431     return investorWhiteList[investor];
432   }
433 
434   function getReferralOf(address investor) constant external returns (address result) {
435     return referralList[investor];
436   }
437 }
438 
439 contract PriceReceiver {
440   address public ethPriceProvider;
441 
442   modifier onlyEthPriceProvider() {
443     require(msg.sender == ethPriceProvider);
444     _;
445   }
446 
447   function receiveEthPrice(uint ethUsdPrice) external;
448 
449   function setEthPriceProvider(address provider) external;
450 
451 }
452 
453 // Sale of unsold tokens [smart-contract]
454 
455 contract ZEONPrivateSale is Haltable, PriceReceiver {
456 
457   using SafeMath for uint;
458 
459   string public constant name = "ZEONPrivateSale";
460 
461   ZEON public token;
462 
463   address public beneficiary;
464 
465   InvestorWhiteList public investorWhiteList;
466 
467   uint public constant TokenUsdRate = 50; //0.5 cents for one token
468   uint public constant MonthsInSeconds = 2629746;
469 
470   uint public ethUsdRate;
471 
472   uint public collected = 0;
473 
474   uint public tokensSold = 0;
475 
476   uint public startTime; 
477 
478   uint public endTime;
479 
480   bool public crowdsaleFinished = false;
481 
482   mapping (address => uint) public deposited;
483 
484   event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
485 
486   event NewReferralTransfer(address indexed investor, address indexed referral, uint tokenAmount);
487 
488   modifier icoActive() {
489     require(now >= startTime && now < endTime);
490     _;
491   }
492 
493   modifier icoEnded() {
494     require(now >= endTime);
495     _;
496   }
497 
498   function ZEONPrivateSale(
499     address _token,
500     address _beneficiary,
501     address _investorWhiteList,
502     uint _baseEthUsdPrice,
503 
504     uint _startTime
505   ) {
506     token = ZEON (_token); //token's smart name
507     beneficiary = _beneficiary;
508     investorWhiteList = InvestorWhiteList(_investorWhiteList);
509 
510     startTime = _startTime;
511     endTime = startTime.add(MonthsInSeconds.mul(12));
512 
513     ethUsdRate = _baseEthUsdPrice;
514   }
515 
516   function() payable {
517     doPurchase();
518   }
519 
520   function withdraw() external onlyOwner {
521     token.transfer(beneficiary, token.balanceOf(this));
522   }
523 
524   function calculateTokens(uint ethReceived) internal view returns (uint) {
525     uint actualTokenUsdRate = TokenUsdRate.add(TokenUsdRate.mul((now - startTime).mul(1000).div(MonthsInSeconds).div(100).mul(10)).div(1000));
526     
527     return ethReceived.mul(ethUsdRate.mul(100)).div(actualTokenUsdRate);
528   }
529 
530   function calculateReferralBonus(uint amountTokens) internal view returns (uint) {
531     return amountTokens.mul(8).div(100);
532   }
533 
534   function receiveEthPrice(uint ethUsdPrice) external onlyEthPriceProvider {
535     require(ethUsdPrice > 0);
536     ethUsdRate = ethUsdPrice;
537   }
538 
539   function setEthPriceProvider(address provider) external onlyOwner {
540     require(provider != 0x0);
541     ethPriceProvider = provider;
542   }
543 
544   function setNewWhiteList(address newWhiteList) external onlyOwner {
545     require(newWhiteList != 0x0);
546     investorWhiteList = InvestorWhiteList(newWhiteList);
547   }
548 
549   function doPurchase() private icoActive inNormalState {
550     require(!crowdsaleFinished);
551 
552     uint tokens = calculateTokens(msg.value); 
553 
554     uint newTokensSold = tokensSold.add(tokens);
555 
556     uint referralBonus = 0;
557     referralBonus = calculateReferralBonus(tokens);
558 
559     address referral = investorWhiteList.getReferralOf(msg.sender);
560 
561     if (referralBonus > 0 && referral != 0x0) {
562       newTokensSold = newTokensSold.add(referralBonus);
563     }
564 
565     collected = collected.add(msg.value);
566 
567     tokensSold = newTokensSold;
568 
569     deposited[msg.sender] = deposited[msg.sender].add(msg.value);
570 
571     token.transfer(msg.sender, tokens);
572     NewContribution(msg.sender, tokens, msg.value);
573 
574     if (referralBonus > 0 && referral != 0x0) {
575       token.transfer(referral, referralBonus);
576       NewReferralTransfer(msg.sender, referral, referralBonus);
577     }
578     
579     beneficiary.transfer(msg.value);
580   }
581 
582 
583   function transferOwnership(address newOwner) onlyOwner icoEnded {
584     super.transferOwnership(newOwner);
585   }
586 }