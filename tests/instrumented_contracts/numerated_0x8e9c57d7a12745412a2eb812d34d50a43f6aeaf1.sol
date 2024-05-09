1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 /**
22  * @title SafeERC20
23  * @dev Wrappers around ERC20 operations that throw on failure.
24  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
25  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
26  */
27 library SafeERC20 {
28   function safeTransfer(
29     ERC20Basic _token,
30     address _to,
31     uint256 _value
32   )
33     internal
34   {
35     require(_token.transfer(_to, _value));
36   }
37 
38   function safeTransferFrom(
39     ERC20 _token,
40     address _from,
41     address _to,
42     uint256 _value
43   )
44     internal
45   {
46     require(_token.transferFrom(_from, _to, _value));
47   }
48 
49   function safeApprove(
50     ERC20 _token,
51     address _spender,
52     uint256 _value
53   )
54     internal
55   {
56     require(_token.approve(_spender, _value));
57   }
58 }
59 
60 
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    * @notice Renouncing to ownership will leave the contract without an owner.
97    * It will not be possible to call the functions with the `onlyOwner`
98    * modifier anymore.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112 
113   /**
114    * @dev Transfers control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function _transferOwnership(address _newOwner) internal {
118     require(_newOwner != address(0));
119     emit OwnershipTransferred(owner, _newOwner);
120     owner = _newOwner;
121   }
122 }
123 
124 
125 
126 
127 
128 
129 
130 
131 /**
132  * @title Pausable
133  * @dev Base contract which allows children to implement an emergency stop mechanism.
134  */
135 contract Pausable is Ownable {
136   event Pause();
137   event Unpause();
138 
139   bool public paused = false;
140 
141 
142   /**
143    * @dev Modifier to make a function callable only when the contract is not paused.
144    */
145   modifier whenNotPaused() {
146     require(!paused);
147     _;
148   }
149 
150   /**
151    * @dev Modifier to make a function callable only when the contract is paused.
152    */
153   modifier whenPaused() {
154     require(paused);
155     _;
156   }
157 
158   /**
159    * @dev called by the owner to pause, triggers stopped state
160    */
161   function pause() public onlyOwner whenNotPaused {
162     paused = true;
163     emit Pause();
164   }
165 
166   /**
167    * @dev called by the owner to unpause, returns to normal state
168    */
169   function unpause() public onlyOwner whenPaused {
170     paused = false;
171     emit Unpause();
172   }
173 }
174 
175 
176 
177 
178 
179 
180 
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address _owner, address _spender)
188     public view returns (uint256);
189 
190   function transferFrom(address _from, address _to, uint256 _value)
191     public returns (bool);
192 
193   function approve(address _spender, uint256 _value) public returns (bool);
194   event Approval(
195     address indexed owner,
196     address indexed spender,
197     uint256 value
198   );
199 }
200 
201 
202 
203 
204 /**
205  * @title SafeMath
206  * @dev Math operations with safety checks that throw on error
207  */
208 library SafeMath {
209 
210   /**
211   * @dev Multiplies two numbers, throws on overflow.
212   */
213   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
214     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
215     // benefit is lost if 'b' is also tested.
216     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
217     if (_a == 0) {
218       return 0;
219     }
220 
221     c = _a * _b;
222     assert(c / _a == _b);
223     return c;
224   }
225 
226   /**
227   * @dev Integer division of two numbers, truncating the quotient.
228   */
229   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
230     // assert(_b > 0); // Solidity automatically throws when dividing by 0
231     // uint256 c = _a / _b;
232     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
233     return _a / _b;
234   }
235 
236   /**
237   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
238   */
239   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
240     assert(_b <= _a);
241     return _a - _b;
242   }
243 
244   /**
245   * @dev Adds two numbers, throws on overflow.
246   */
247   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
248     c = _a + _b;
249     assert(c >= _a);
250     return c;
251   }
252 }
253 
254 
255 
256 
257 /**
258  * @title Crowdsale
259  * @dev Crowdsale is a base contract for managing a token crowdsale,
260  * allowing investors to purchase tokens with ether. This contract implements
261  * such functionality in its most fundamental form and can be extended to provide additional
262  * functionality and/or custom behavior.
263  * The external interface represents the basic interface for purchasing tokens, and conform
264  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
265  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
266  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
267  * behavior.
268  */
269 contract Crowdsale {
270   using SafeMath for uint256;
271   using SafeERC20 for ERC20;
272 
273   // The token being sold
274   ERC20 public token;
275 
276   // Address where funds are collected
277   address public wallet;
278 
279   // How many token units a buyer gets per wei.
280   // The rate is the conversion between wei and the smallest and indivisible token unit.
281   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
282   // 1 wei will give you 1 unit, or 0.001 TOK.
283   uint256 public rate;
284 
285   // Amount of wei raised
286   uint256 public weiRaised;
287 
288   /**
289    * Event for token purchase logging
290    * @param purchaser who paid for the tokens
291    * @param beneficiary who got the tokens
292    * @param value weis paid for purchase
293    * @param amount amount of tokens purchased
294    */
295   event TokenPurchase(
296     address indexed purchaser,
297     address indexed beneficiary,
298     uint256 value,
299     uint256 amount
300   );
301 
302   /**
303    * @param _rate Number of token units a buyer gets per wei
304    * @param _wallet Address where collected funds will be forwarded to
305    * @param _token Address of the token being sold
306    */
307   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
308     require(_rate > 0);
309     require(_wallet != address(0));
310     require(_token != address(0));
311 
312     rate = _rate;
313     wallet = _wallet;
314     token = _token;
315   }
316 
317   // -----------------------------------------
318   // Crowdsale external interface
319   // -----------------------------------------
320 
321   /**
322    * @dev fallback function ***DO NOT OVERRIDE***
323    */
324   function () external payable {
325     buyTokens(msg.sender);
326   }
327 
328   /**
329    * @dev low level token purchase ***DO NOT OVERRIDE***
330    * @param _beneficiary Address performing the token purchase
331    */
332   function buyTokens(address _beneficiary) public payable {
333 
334     uint256 weiAmount = msg.value;
335     _preValidatePurchase(_beneficiary, weiAmount);
336 
337     // calculate token amount to be created
338     uint256 tokens = _getTokenAmount(weiAmount);
339 
340     // update state
341     weiRaised = weiRaised.add(weiAmount);
342 
343     _processPurchase(_beneficiary, tokens);
344     emit TokenPurchase(
345       msg.sender,
346       _beneficiary,
347       weiAmount,
348       tokens
349     );
350 
351     _updatePurchasingState(_beneficiary, weiAmount);
352 
353     _forwardFunds();
354     _postValidatePurchase(_beneficiary, weiAmount);
355   }
356 
357   // -----------------------------------------
358   // Internal interface (extensible)
359   // -----------------------------------------
360 
361   /**
362    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
363    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
364    *   super._preValidatePurchase(_beneficiary, _weiAmount);
365    *   require(weiRaised.add(_weiAmount) <= cap);
366    * @param _beneficiary Address performing the token purchase
367    * @param _weiAmount Value in wei involved in the purchase
368    */
369   function _preValidatePurchase(
370     address _beneficiary,
371     uint256 _weiAmount
372   )
373     internal
374   {
375     require(_beneficiary != address(0));
376     require(_weiAmount != 0);
377   }
378 
379   /**
380    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
381    * @param _beneficiary Address performing the token purchase
382    * @param _weiAmount Value in wei involved in the purchase
383    */
384   function _postValidatePurchase(
385     address _beneficiary,
386     uint256 _weiAmount
387   )
388     internal
389   {
390     // optional override
391   }
392 
393   /**
394    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
395    * @param _beneficiary Address performing the token purchase
396    * @param _tokenAmount Number of tokens to be emitted
397    */
398   function _deliverTokens(
399     address _beneficiary,
400     uint256 _tokenAmount
401   )
402     internal
403   {
404     token.safeTransfer(_beneficiary, _tokenAmount);
405   }
406 
407   /**
408    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
409    * @param _beneficiary Address receiving the tokens
410    * @param _tokenAmount Number of tokens to be purchased
411    */
412   function _processPurchase(
413     address _beneficiary,
414     uint256 _tokenAmount
415   )
416     internal
417   {
418     _deliverTokens(_beneficiary, _tokenAmount);
419   }
420 
421   /**
422    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
423    * @param _beneficiary Address receiving the tokens
424    * @param _weiAmount Value in wei involved in the purchase
425    */
426   function _updatePurchasingState(
427     address _beneficiary,
428     uint256 _weiAmount
429   )
430     internal
431   {
432     // optional override
433   }
434 
435   /**
436    * @dev Override to extend the way in which ether is converted to tokens.
437    * @param _weiAmount Value in wei to be converted into tokens
438    * @return Number of tokens that can be purchased with the specified _weiAmount
439    */
440   function _getTokenAmount(uint256 _weiAmount)
441     internal view returns (uint256)
442   {
443     return _weiAmount.mul(rate);
444   }
445 
446   /**
447    * @dev Determines how ETH is stored/forwarded on purchases.
448    */
449   function _forwardFunds() internal {
450     wallet.transfer(msg.value);
451   }
452 }
453 
454 
455 contract TSCCoinSeller is Crowdsale, Pausable {
456     uint256 internal initialRate = 10000;
457     constructor(ERC20 _token) Crowdsale(initialRate, msg.sender, _token) public {}
458 
459     function buyTokens(address _beneficiary) public payable whenNotPaused {
460         super.buyTokens(_beneficiary);
461     }
462 
463     function changeRate(uint256 _newRate) public onlyOwner {
464         require(_newRate > 0);
465         rate = _newRate;
466     }
467 
468     function changeWallet(address _newWallet) public onlyOwner {
469         require(_newWallet != address(0));
470         wallet = _newWallet;
471     }
472 
473     function returnCoins(uint256 _value) public onlyOwner {
474         token.transfer(msg.sender, _value);
475     }
476 
477     function destroy() public onlyOwner {
478         returnCoins(token.balanceOf(this));
479         selfdestruct(owner);
480     }
481 }