1 pragma solidity 0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract BasicERC20 {
57   uint256 public totalSupply;
58   function balanceOf(address who) public constant returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract ERC20Basic is BasicERC20 {
67   using SafeMath for uint256;
68   mapping(address => uint256) balances; 
69  
70 }
71 
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20 is ERC20Basic {
78   function allowance(address owner, address spender)
79     public view returns (uint256);
80 
81   function transferFrom(address from, address to, uint256 _value)
82     public returns (bool);
83 
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(
86     address indexed owner,
87     address indexed spender,
88     uint256 value
89   );
90 }
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic _token, address _to, uint256 _value) internal {
100     require(_token.transfer(_to, _value));
101   }
102     function safeTransferFrom(
103     ERC20 _token,
104     address _from,
105     address _to,
106     uint256 _value
107   )
108     internal
109   {
110     require(_token.transferFrom(_from, _to, _value));
111   }
112 
113 }
114 
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122   address public owner;
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124   /**
125    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126    * account.
127    */
128  function Ownable() {
129     owner = msg.sender;
130   }
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138   /**
139    * @dev Allows the current owner to transfer control of the contract to a newOwner.
140    * @param newOwner The address to transfer ownership to.
141    */
142   function transferOwnership(address newOwner) onlyOwner public {
143     require(newOwner != address(0));
144     emit OwnershipTransferred(owner, newOwner);
145     owner = newOwner;
146   }
147 }
148 /**
149  * @title Crowdsale
150  * @dev Crowdsale is a base contract for managing a token crowdsale,
151  * allowing investors to purchase tokens with ether. This contract implements
152  * such functionality in its most fundamental form and can be extended to provide additional
153  * functionality and/or custom behavior.
154  * The external interface represents the basic interface for purchasing tokens, and conform
155  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
156  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
157  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
158  * behavior.
159  */
160 contract Crowdsale {
161   using SafeMath for uint256;
162   using SafeERC20 for ERC20;
163 
164   // The token being sold
165   ERC20 public token;
166 
167   // Address where funds are collected
168   address public wallet;
169 
170   // How many token units a buyer gets per wei.
171   // The rate is the conversion between wei and the smallest and indivisible token unit.
172   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
173   // 1 wei will give you 1 unit, or 0.001 TOK.
174   uint256 public rate;
175 
176   // Amount of wei raised
177   uint256 public weiRaised;
178 
179   /**
180    * Event for token purchase logging
181    * @param purchaser who paid for the tokens
182    * @param beneficiary who got the tokens
183    * @param value weis paid for purchase
184    * @param amount amount of tokens purchased
185    */
186   event TokenPurchase(
187     address indexed purchaser,
188     address indexed beneficiary,
189     uint256 value,
190     uint256 amount,
191     uint256 now
192   );
193 
194   /**
195    * @param _rate Number of token units a buyer gets per wei
196    * @param _wallet Address where collected funds will be forwarded to
197    * @param _token Address of the token being sold
198    */
199   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
200     require(_rate > 0);
201     require(_wallet != address(0));
202     require(_token != address(0));
203 
204     rate = _rate;
205     wallet = _wallet;
206     token = _token;
207   }
208 
209   // -----------------------------------------
210   // Crowdsale external interface
211   // -----------------------------------------
212 
213   /**
214    * @dev fallback function ***DO NOT OVERRIDE***
215    */
216   function () external payable {
217     buyTokens(msg.sender);
218   }
219 
220   /**
221    * @dev low level token purchase ***DO NOT OVERRIDE***
222    * @param _beneficiary Address performing the token purchase
223    */
224   function buyTokens(address _beneficiary) public payable {
225 
226     uint256 weiAmount = msg.value;
227     _preValidatePurchase(_beneficiary, weiAmount);
228 
229     // calculate token amount to be created
230     uint256 tokens = _getTokenAmount(weiAmount);
231 
232     // update state
233     weiRaised = weiRaised.add(weiAmount);
234 
235     _processPurchase(_beneficiary, tokens);
236     emit TokenPurchase(
237       msg.sender,
238       _beneficiary,
239       weiAmount,
240       tokens,
241       now
242     );
243 
244     _updatePurchasingState(_beneficiary, weiAmount);
245 
246     _forwardFunds();
247     _postValidatePurchase(_beneficiary, weiAmount);
248   }
249 
250   // -----------------------------------------
251   // Internal interface (extensible)
252   // -----------------------------------------
253 
254   /**
255    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
256    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
257    *   super._preValidatePurchase(_beneficiary, _weiAmount);
258    *   require(weiRaised.add(_weiAmount) <= cap);
259    * @param _beneficiary Address performing the token purchase
260    * @param _weiAmount Value in wei involved in the purchase
261    */
262   function _preValidatePurchase(
263     address _beneficiary,
264     uint256 _weiAmount
265   )
266     internal
267   {
268     require(_beneficiary != address(0));
269     require(_weiAmount != 0);
270   }
271 
272   /**
273    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
274    * @param _beneficiary Address performing the token purchase
275    * @param _weiAmount Value in wei involved in the purchase
276    */
277   function _postValidatePurchase(
278     address _beneficiary,
279     uint256 _weiAmount
280   )
281     internal
282   {
283     // optional override
284   }
285 
286   /**
287    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
288    * @param _beneficiary Address performing the token purchase
289    * @param _tokenAmount Number of tokens to be emitted
290    */
291   function _deliverTokens(
292     address _beneficiary,
293     uint256 _tokenAmount
294   )
295     internal 
296   {
297     token.safeTransfer(_beneficiary, _tokenAmount);
298   }
299 
300   /**
301    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
302    * @param _beneficiary Address receiving the tokens
303    * @param _tokenAmount Number of tokens to be purchased
304    */
305   function _processPurchase(
306     address _beneficiary,
307     uint256 _tokenAmount
308   )
309   
310   {
311     _deliverTokens(_beneficiary, _tokenAmount);
312   }
313 
314   /**
315    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
316    * @param _beneficiary Address receiving the tokens
317    * @param _weiAmount Value in wei involved in the purchase
318    */
319   function _updatePurchasingState(
320     address _beneficiary,
321     uint256 _weiAmount
322   )
323     internal
324   {
325     // optional override
326   }
327 
328   /**
329    * @dev Override to extend the way in which ether is converted to tokens.
330    * @param _weiAmount Value in wei to be converted into tokens
331    * @return Number of tokens that can be purchased with the specified _weiAmount
332    */
333   function _getTokenAmount(uint256 _weiAmount)
334     internal view returns (uint256)
335   {
336     return _weiAmount.mul(rate);
337   }
338 
339   /**
340    * @dev Determines how ETH is stored/forwarded on purchases.
341    */
342   function _forwardFunds() internal {
343     wallet.transfer(msg.value);
344   }
345 }
346 /**
347  * @title CappedCrowdsale
348  * @dev Crowdsale with a limit for total contributions.
349  */
350 contract CappedCrowdsale is Crowdsale {
351   using SafeMath for uint256;
352 
353   uint256 public cap;
354 
355   /**
356    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
357    * @param _cap Max amount of wei to be contributed
358    */
359   constructor(uint256 _cap) public {
360     require(_cap > 0);
361     cap = _cap;
362   }
363 
364   /**
365    * @dev Checks whether the cap has been reached.
366    * @return Whether the cap was reached
367    */
368   function capReached() public view returns (bool) {
369     return weiRaised >= cap;
370   }
371 
372   /**
373    * @dev Extend parent behavior requiring purchase to respect the funding cap.
374    * @param _beneficiary Token purchaser
375    * @param _weiAmount Amount of wei contributed
376    */
377   function _preValidatePurchase(
378     address _beneficiary,
379     uint256 _weiAmount
380   )
381     internal
382   {
383     super._preValidatePurchase(_beneficiary, _weiAmount);
384     require(weiRaised.add(_weiAmount) <= cap);
385   }
386 
387 }
388 /**
389  * @title TimedCrowdsale
390  * @dev Crowdsale accepting contributions only within a time frame.
391  */
392 contract TimedCrowdsale is CappedCrowdsale {
393   using SafeMath for uint256;
394 
395   uint256 public openingTime;
396   uint256 public closingTime;
397 
398   /**
399    * @dev Reverts if not in crowdsale time range.
400    */
401   modifier onlyWhileOpen {
402     // solium-disable-next-line security/no-block-members
403     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
404     _;
405   }
406 
407   /**
408    * @dev Constructor, takes crowdsale opening and closing times.
409    * @param _openingTime Crowdsale opening time
410    * @param _closingTime Crowdsale closing time
411    */
412   constructor(uint256 _openingTime, uint256 _closingTime) public {
413     // solium-disable-next-line security/no-block-members
414     require(_openingTime >= block.timestamp);
415     require(_closingTime >= _openingTime);
416 
417     openingTime = _openingTime;
418     closingTime = _closingTime;
419   }
420 
421   /**
422    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
423    * @return Whether crowdsale period has elapsed
424    */
425   function hasClosed() public view returns (bool) {
426     // solium-disable-next-line security/no-block-members
427     return block.timestamp > closingTime;
428   }
429 
430   /**
431    * @dev Extend parent behavior requiring to be within contributing period
432    * @param _beneficiary Token purchaser
433    * @param _weiAmount Amount of wei contributed
434    */
435   function _preValidatePurchase(
436     address _beneficiary,
437     uint256 _weiAmount
438   )
439     internal
440     onlyWhileOpen
441   {
442     super._preValidatePurchase(_beneficiary, _weiAmount);
443   }
444 
445 }
446 contract RedanCrowdsale is TimedCrowdsale,Ownable {
447   uint256 public constant DECIMALFACTOR = 10**uint256(18);
448   uint256 public availbleToken;
449   uint256 public soldToken;
450     uint256 public cap=2400 ether;// softcap is 2400 ether
451   uint256 public goal=10000 ether;// hardcap is 10000 ether
452 
453 
454    /**
455  	* @dev RedanCrowdsale is a base contract for managing a token crowdsale.
456  	* RedanCrowdsale have a start and end timestamps, where investors can make
457  	* token purchases and the crowdsale will assign them tokens based
458  	* on a token per ETH rate. Funds collected are forwarded to a wallet
459  	* as they arrive.
460  	*/
461  function RedanCrowdsale(uint256 _starttime, uint256 _endTime, uint256 _rate, address _wallet,ERC20 _token)
462   TimedCrowdsale(_starttime,_endTime)Crowdsale(_rate, _wallet,_token)CappedCrowdsale(cap)
463   {
464   }
465     
466   /**
467    * @dev fallback function ***DO NOT OVERRIDE***
468    */
469   function () external payable {
470     buyTokens(msg.sender);
471   }
472   
473   function buyTokens(address _beneficiary) public payable onlyWhileOpen {
474 
475     // calculate token amount to be created
476     uint256 tokens = _getTokenAmount( msg.value);
477    
478     weiRaised = weiRaised.add(msg.value);
479     token.safeTransferFrom(owner,_beneficiary, tokens);
480     emit TokenPurchase(msg.sender,_beneficiary, msg.value, tokens,now);
481     
482     _forwardFunds();
483     soldToken=soldToken.add(tokens);
484     availbleToken=token.allowance(owner,this);
485   }
486   
487  /**
488  * @dev Change crowdsale ClosingTime
489  * @param  _endTime is End time in Seconds
490  */
491   function changeEndtime(uint256 _endTime) public onlyOwner {
492     require(_endTime > 0); 
493     closingTime = _endTime;
494     }
495  /** function transferFrom(address _from, address _to, uint256 _value)
496     public returns (bool);
497  * @dev Change Token rate per ETH
498  * @param  _rate is set the current rate of AND Token
499  */
500   function changeRate(uint256 _rate) public onlyOwner {
501     require(_rate > 0); 
502     rate = _rate;
503     }
504       /**
505    * @dev Checks whether the goal has been reached.
506    * @return Whether the goal was reached
507    */
508   function goalReached() public view returns (bool) {
509     return weiRaised >= goal;
510   }
511   
512 }