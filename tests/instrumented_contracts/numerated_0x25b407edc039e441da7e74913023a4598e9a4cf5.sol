1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 
60 library SafeMath {
61     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
62         uint256 c = a * b;
63         assert(a == 0 || c / a == b);
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal constant returns (uint256) {
68         // assert(b > 0); // Solidity automatically throws when dividing by 0
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71         return c;
72     }
73 
74     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
75         assert(b <= a);
76         return a - b;
77     }
78 
79     function add(uint256 a, uint256 b) internal constant returns (uint256) {
80         uint256 c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 }
85 
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender)
95     public view returns (uint256);
96 
97   function transferFrom(address from, address to, uint256 value)
98     public returns (bool);
99 
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 /**
109  * @title SafeERC20
110  * @dev Wrappers around ERC20 operations that throw on failure.
111  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
112  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
113  */
114 library SafeERC20 {
115   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
116     require(token.transfer(to, value));
117   }
118 
119   function safeTransferFrom(
120     ERC20 token,
121     address from,
122     address to,
123     uint256 value
124   )
125     internal
126   {
127     require(token.transferFrom(from, to, value));
128   }
129 
130   function safeApprove(ERC20 token, address spender, uint256 value) internal {
131     require(token.approve(spender, value));
132   }
133 }
134 
135 /**
136  * @title Crowdsale
137  * @dev Crowdsale is a base contract for managing a token crowdsale,
138  * allowing investors to purchase tokens with ether. This contract implements
139  * such functionality in its most fundamental form and can be extended to provide additional
140  * functionality and/or custom behavior.
141  * The external interface represents the basic interface for purchasing tokens, and conform
142  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
143  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
144  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
145  * behavior.
146  */
147 contract Crowdsale {
148   using SafeMath for uint256;
149   using SafeERC20 for ERC20;
150 
151   // The token being sold
152   ERC20 public token;
153 
154   // Address where funds are collected
155   address public wallet;
156 
157   // How many token units a buyer gets per wei.
158   // The rate is the conversion between wei and the smallest and indivisible token unit.
159   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
160   // 1 wei will give you 1 unit, or 0.001 TOK.
161   uint256 public rate;
162   uint256 public divisor;
163 
164   // Amount of wei raised
165   uint256 public weiRaised;
166 
167   /**
168    * Event for token purchase logging
169    * @param purchaser who paid for the tokens
170    * @param beneficiary who got the tokens
171    * @param value weis paid for purchase
172    * @param amount amount of tokens purchased
173    */
174   event TokenPurchase(
175     address indexed purchaser,
176     address indexed beneficiary,
177     uint256 value,
178     uint256 amount
179   );
180 
181   /**
182    * @param _rate Number of token units a buyer gets per wei
183    * @param _wallet Address where collected funds will be forwarded to
184    * @param _token Address of the token being sold
185    */
186   constructor(uint256 _rate, uint256 _divisor, address _wallet, ERC20 _token) public {
187     require(_rate > 0);
188     require(_divisor > 0);
189     require(_wallet != address(0));
190     require(_token != address(0));
191 
192     rate = _rate;
193     divisor = _divisor;
194     wallet = _wallet;
195     token = _token;
196   }
197 
198   // -----------------------------------------
199   // Crowdsale external interface
200   // -----------------------------------------
201 
202   /**
203    * @dev fallback function ***DO NOT OVERRIDE***
204    */
205   function () external payable {
206     buyTokens(msg.sender);
207   }
208 
209   /**
210    * @dev low level token purchase ***DO NOT OVERRIDE***
211    * @param _beneficiary Address performing the token purchase
212    */
213   function buyTokens(address _beneficiary) public payable {
214 
215     uint256 weiAmount = msg.value;
216     _preValidatePurchase(_beneficiary, weiAmount);
217 
218     // calculate token amount to be created
219     uint256 tokens = _getTokenAmount(weiAmount);
220 
221     // update state
222     weiRaised = weiRaised.add(weiAmount);
223 
224     _processPurchase(_beneficiary, tokens);
225     emit TokenPurchase(
226       msg.sender,
227       _beneficiary,
228       weiAmount,
229       tokens
230     );
231 
232     _updatePurchasingState(_beneficiary, weiAmount);
233 
234     _forwardFunds();
235     _postValidatePurchase(_beneficiary, weiAmount);
236   }
237 
238   // -----------------------------------------
239   // Internal interface (extensible)
240   // -----------------------------------------
241 
242   /**
243    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
244    * @param _beneficiary Address performing the token purchase
245    * @param _weiAmount Value in wei involved in the purchase
246    */
247   function _preValidatePurchase(
248     address _beneficiary,
249     uint256 _weiAmount
250   )
251     internal
252   {
253     require(_beneficiary != address(0));
254     require(_weiAmount != 0);
255   }
256 
257   /**
258    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
259    * @param _beneficiary Address performing the token purchase
260    * @param _weiAmount Value in wei involved in the purchase
261    */
262   function _postValidatePurchase(
263     address _beneficiary,
264     uint256 _weiAmount
265   )
266     internal
267   {
268     // optional override
269   }
270 
271   /**
272    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
273    * @param _beneficiary Address performing the token purchase
274    * @param _tokenAmount Number of tokens to be emitted
275    */
276   function _deliverTokens(
277     address _beneficiary,
278     uint256 _tokenAmount
279   )
280     internal
281   {
282     token.safeTransfer(_beneficiary, _tokenAmount);
283   }
284 
285   /**
286    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
287    * @param _beneficiary Address receiving the tokens
288    * @param _tokenAmount Number of tokens to be purchased
289    */
290   function _processPurchase(
291     address _beneficiary,
292     uint256 _tokenAmount
293   )
294     internal
295   {
296     _deliverTokens(_beneficiary, _tokenAmount);
297   }
298 
299   /**
300    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
301    * @param _beneficiary Address receiving the tokens
302    * @param _weiAmount Value in wei involved in the purchase
303    */
304   function _updatePurchasingState(
305     address _beneficiary,
306     uint256 _weiAmount
307   )
308     internal
309   {
310     // optional override
311   }
312 
313   /**
314    * @dev Override to extend the way in which ether is converted to tokens.
315    * @param _weiAmount Value in wei to be converted into tokens
316    * @return Number of tokens that can be purchased with the specified _weiAmount
317    */
318   function _getTokenAmount(uint256 _weiAmount)
319     internal view returns (uint256)
320   {
321     return _weiAmount.mul(rate);
322   }
323 
324   /**
325    * @dev Determines how ETH is stored/forwarded on purchases.
326    */
327   function _forwardFunds() internal {
328     wallet.transfer(msg.value);
329   }
330 }
331 
332 /**
333  * @title TimedCrowdsale
334  * @dev Crowdsale accepting contributions only within a time frame.
335  */
336 contract TimedCrowdsale is Crowdsale {
337   using SafeMath for uint256;
338 
339   uint256 public openingTime;
340   uint256 public closingTime;
341 
342   /**
343    * @dev Reverts if not in crowdsale time range.
344    */
345   modifier onlyWhileOpen {
346     // solium-disable-next-line security/no-block-members
347     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
348     _;
349   }
350 
351   /**
352    * @dev Constructor, takes crowdsale opening and closing times.
353    * @param _openingTime Crowdsale opening time
354    * @param _closingTime Crowdsale closing time
355    */
356   constructor(uint256 _openingTime, uint256 _closingTime) public {
357     // solium-disable-next-line security/no-block-members
358     require(_openingTime >= block.timestamp);
359     require(_closingTime >= _openingTime);
360 
361     openingTime = _openingTime;
362     closingTime = _closingTime;
363   }
364 
365   /**
366    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
367    * @return Whether crowdsale period has elapsed
368    */
369   function hasClosed() public view returns (bool) {
370     // solium-disable-next-line security/no-block-members
371     return block.timestamp > closingTime;
372   }
373 
374   /**
375    * @dev Extend parent behavior requiring to be within contributing period
376    * @param _beneficiary Token purchaser
377    * @param _weiAmount Amount of wei contributed
378    */
379   function _preValidatePurchase(
380     address _beneficiary,
381     uint256 _weiAmount
382   )
383     internal
384     onlyWhileOpen
385   {
386     super._preValidatePurchase(_beneficiary, _weiAmount);
387   }
388 }
389 
390 contract PhasedCrowdsale is TimedCrowdsale {
391   uint256[] public phases;
392   uint256[] public divisors;
393 
394   constructor(uint256[] _phases, uint256[] _divisors) {
395     for(uint i = 0; i < _phases.length; i++) {
396       require(openingTime < _phases[i] && closingTime > _phases[i]);
397     }
398 
399     phases = _phases;
400     divisors = _divisors;
401   }
402   
403   function getCurrentPhaseCloseTime() view returns (int256, int256) {
404     if(now < openingTime) {
405       return (int256(openingTime), -2);
406     }
407 
408     for(uint i = 0; i < phases.length; i++)  {
409       if(now < phases[i])
410         return (int256(phases[i]), int256(i));
411     }
412 
413     if(now < closingTime) {
414       return (int256(closingTime), -1);
415     }
416 
417     return (-1, -3);
418   }
419 
420   function getCurrentPhaseDivisor() view returns (uint256) {
421     var (closingTime, phaseIndex) = getCurrentPhaseCloseTime();
422 
423     for(uint i = 0; i < phases.length; i++)  {
424       if(uint256(closingTime) == phases[i]) {
425         return divisors[i];
426       }
427     }
428   }
429 
430   function _getTokenAmount(uint256 _weiAmount)
431     internal view returns (uint256)
432   {
433     uint256 divisor = getCurrentPhaseDivisor();
434 
435     return _weiAmount.div(divisor).mul(rate);
436   }
437 }
438 
439 contract YOLCrowdsale is Ownable, TimedCrowdsale, PhasedCrowdsale {
440   address public afterCrowdsaleAddress;
441 
442   modifier onlyClosed {
443     // solium-disable-next-line security/no-block-members
444     require(block.timestamp > openingTime && block.timestamp > closingTime);
445     _;
446   }
447 
448   constructor(
449     uint256 _rate, uint _divisor, address _wallet, 
450     ERC20 _token, uint256 _openingTime, uint256 _closingTime, 
451     uint256[] _phases, uint256[] _divisors,
452     address _afterCrowdsaleAddress) 
453     public 
454     Ownable()
455     Crowdsale(_rate, _divisor, _wallet, _token)
456     TimedCrowdsale(_openingTime, _closingTime)
457     PhasedCrowdsale(_phases, _divisors) {
458       afterCrowdsaleAddress = _afterCrowdsaleAddress;
459   }
460 
461   function finalize() onlyOwner onlyClosed {
462     uint256 restTokenBalance = token.balanceOf(this);
463 
464     token.transfer(afterCrowdsaleAddress, restTokenBalance);
465   }
466 }