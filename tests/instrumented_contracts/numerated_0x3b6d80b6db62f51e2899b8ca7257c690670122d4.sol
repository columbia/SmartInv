1 pragma solidity ^0.4.18;
2 
3 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: node_modules\zeppelin-solidity\contracts\crowdsale\Crowdsale.sol
121 
122 /**
123  * @title Crowdsale
124  * @dev Crowdsale is a base contract for managing a token crowdsale,
125  * allowing investors to purchase tokens with ether. This contract implements
126  * such functionality in its most fundamental form and can be extended to provide additional
127  * functionality and/or custom behavior.
128  * The external interface represents the basic interface for purchasing tokens, and conform
129  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
130  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
131  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
132  * behavior.
133  */
134 
135 contract Crowdsale {
136   using SafeMath for uint256;
137 
138   // The token being sold
139   ERC20 public token;
140 
141   // Address where funds are collected
142   address public wallet;
143 
144   // How many token units a buyer gets per wei
145   uint256 public rate;
146 
147   // Amount of wei raised
148   uint256 public weiRaised;
149 
150   /**
151    * Event for token purchase logging
152    * @param purchaser who paid for the tokens
153    * @param beneficiary who got the tokens
154    * @param value weis paid for purchase
155    * @param amount amount of tokens purchased
156    */
157   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
158 
159   /**
160    * @param _rate Number of token units a buyer gets per wei
161    * @param _wallet Address where collected funds will be forwarded to
162    * @param _token Address of the token being sold
163    */
164   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
165     require(_rate > 0);
166     require(_wallet != address(0));
167     require(_token != address(0));
168 
169     rate = _rate;
170     wallet = _wallet;
171     token = _token;
172   }
173 
174   // -----------------------------------------
175   // Crowdsale external interface
176   // -----------------------------------------
177 
178   /**
179    * @dev fallback function ***DO NOT OVERRIDE***
180    */
181   function () external payable {
182     buyTokens(msg.sender);
183   }
184 
185   /**
186    * @dev low level token purchase ***DO NOT OVERRIDE***
187    * @param _beneficiary Address performing the token purchase
188    */
189   function buyTokens(address _beneficiary) public payable {
190 
191     uint256 weiAmount = msg.value;
192     _preValidatePurchase(_beneficiary, weiAmount);
193 
194     // calculate token amount to be created
195     uint256 tokens = _getTokenAmount(weiAmount);
196 
197     // update state
198     weiRaised = weiRaised.add(weiAmount);
199 
200     _processPurchase(_beneficiary, tokens);
201     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
202 
203     _updatePurchasingState(_beneficiary, weiAmount);
204 
205     _forwardFunds();
206     _postValidatePurchase(_beneficiary, weiAmount);
207   }
208 
209   // -----------------------------------------
210   // Internal interface (extensible)
211   // -----------------------------------------
212 
213   /**
214    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
215    * @param _beneficiary Address performing the token purchase
216    * @param _weiAmount Value in wei involved in the purchase
217    */
218   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
219     require(_beneficiary != address(0));
220     require(_weiAmount != 0);
221   }
222 
223   /**
224    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
225    * @param _beneficiary Address performing the token purchase
226    * @param _weiAmount Value in wei involved in the purchase
227    */
228   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
229     // optional override
230   }
231 
232   /**
233    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
234    * @param _beneficiary Address performing the token purchase
235    * @param _tokenAmount Number of tokens to be emitted
236    */
237   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
238     token.transfer(_beneficiary, _tokenAmount);
239   }
240 
241   /**
242    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
243    * @param _beneficiary Address receiving the tokens
244    * @param _tokenAmount Number of tokens to be purchased
245    */
246   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
247     _deliverTokens(_beneficiary, _tokenAmount);
248   }
249 
250   /**
251    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
252    * @param _beneficiary Address receiving the tokens
253    * @param _weiAmount Value in wei involved in the purchase
254    */
255   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
256     // optional override
257   }
258 
259   /**
260    * @dev Override to extend the way in which ether is converted to tokens.
261    * @param _weiAmount Value in wei to be converted into tokens
262    * @return Number of tokens that can be purchased with the specified _weiAmount
263    */
264   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
265     return _weiAmount.mul(rate);
266   }
267 
268   /**
269    * @dev Determines how ETH is stored/forwarded on purchases.
270    */
271   function _forwardFunds() internal {
272     wallet.transfer(msg.value);
273   }
274 }
275 
276 // File: node_modules\zeppelin-solidity\contracts\crowdsale\validation\TimedCrowdsale.sol
277 
278 /**
279  * @title TimedCrowdsale
280  * @dev Crowdsale accepting contributions only within a time frame.
281  */
282 contract TimedCrowdsale is Crowdsale {
283   using SafeMath for uint256;
284 
285   uint256 public openingTime;
286   uint256 public closingTime;
287 
288   /**
289    * @dev Reverts if not in crowdsale time range. 
290    */
291   modifier onlyWhileOpen {
292     require(now >= openingTime && now <= closingTime);
293     _;
294   }
295 
296   /**
297    * @dev Constructor, takes crowdsale opening and closing times.
298    * @param _openingTime Crowdsale opening time
299    * @param _closingTime Crowdsale closing time
300    */
301   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
302     require(_openingTime >= now);
303     require(_closingTime >= _openingTime);
304 
305     openingTime = _openingTime;
306     closingTime = _closingTime;
307   }
308 
309   /**
310    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
311    * @return Whether crowdsale period has elapsed
312    */
313   function hasClosed() public view returns (bool) {
314     return now > closingTime;
315   }
316   
317   /**
318    * @dev Extend parent behavior requiring to be within contributing period
319    * @param _beneficiary Token purchaser
320    * @param _weiAmount Amount of wei contributed
321    */
322   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
323     super._preValidatePurchase(_beneficiary, _weiAmount);
324   }
325 
326 }
327 
328 // File: node_modules\zeppelin-solidity\contracts\crowdsale\distribution\FinalizableCrowdsale.sol
329 
330 /**
331  * @title FinalizableCrowdsale
332  * @dev Extension of Crowdsale where an owner can do extra work
333  * after finishing.
334  */
335 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
336   using SafeMath for uint256;
337 
338   bool public isFinalized = false;
339 
340   event Finalized();
341 
342   /**
343    * @dev Must be called after crowdsale ends, to do some extra finalization
344    * work. Calls the contract's finalization function.
345    */
346   function finalize() onlyOwner public {
347     require(!isFinalized);
348     require(hasClosed());
349 
350     finalization();
351     Finalized();
352 
353     isFinalized = true;
354   }
355 
356   /**
357    * @dev Can be overridden to add finalization logic. The overriding function
358    * should call super.finalization() to ensure the chain of finalization is
359    * executed entirely.
360    */
361   function finalization() internal {
362   }
363 }
364 
365 // File: contracts\FloraFicTokenCrowdsale.sol
366 
367 contract FloraFicTokenCrowdsale is FinalizableCrowdsale {
368 
369   uint256 public initialRate;
370 
371   function FloraFicTokenCrowdsale(
372     uint256 _openingTime,
373     uint256 _closingTime,
374     uint256 _rate,
375     uint256 _initialRate,
376     address _wallet,
377     ERC20 _token
378   )
379     public
380     Crowdsale(_rate, _wallet, _token)
381     TimedCrowdsale(_openingTime, _closingTime)
382   {
383     initialRate = _initialRate;
384   }
385 
386   function setClosingTime(uint256 _closingTime) onlyOwner public {
387     require(_closingTime >= block.timestamp);
388     require(_closingTime >= openingTime);
389 
390     closingTime = _closingTime;
391   }
392 
393   function getCurrentRate() public view returns (uint256) {
394     // solium-disable-next-line security/no-block-members
395     uint256 elapsedTime = block.timestamp.sub(openingTime);
396     uint num_day = uint(elapsedTime) / 86400;
397     rate = initialRate.sub(num_day.mul(initialRate).div(100));
398     return rate;
399   }
400 
401   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
402     uint256 sendWeiAmount = _weiAmount;
403     uint256 bonus = 0;
404     uint256 currentRate = getCurrentRate();
405     uint256 currentWeiAmount = currentRate.mul(_weiAmount);
406     if( sendWeiAmount < 0.5 ether){
407         bonus = currentWeiAmount.mul(5).div(100);
408     } else if (sendWeiAmount >= 0.5 ether && sendWeiAmount < 1 ether){
409         bonus = currentWeiAmount.mul(7).div(100);
410     } else if (sendWeiAmount >= 1 ether && sendWeiAmount < 5 ether){
411         bonus = currentWeiAmount.mul(10).div(100);
412     } else if (sendWeiAmount >= 5 ether && sendWeiAmount < 10 ether){
413         bonus = currentWeiAmount.mul(15).div(100);
414     } else if (sendWeiAmount >= 10 ether && sendWeiAmount < 20 ether){
415         bonus = currentWeiAmount.mul(20).div(100);
416     } else if (sendWeiAmount >= 20 ether && sendWeiAmount < 50 ether){
417         bonus = currentWeiAmount.mul(25).div(100);
418     } else if (sendWeiAmount >= 50 ether){
419         bonus = currentWeiAmount.mul(30).div(100);
420     }
421     return currentWeiAmount.add(bonus);
422   }
423 
424   function finalization() internal {
425     uint256 amount = token.balanceOf(this);
426     require(amount > 0);
427 
428     token.transfer(wallet, amount);
429   }
430 
431 }