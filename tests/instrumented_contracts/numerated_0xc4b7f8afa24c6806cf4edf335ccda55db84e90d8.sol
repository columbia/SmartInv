1 pragma solidity ^0.4.24;
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
85  * @title SafeERC20
86  * @dev Wrappers around ERC20 operations that throw on failure.
87  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
88  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
89  */
90 library SafeERC20 {
91   function safeTransfer(
92     ERC20Basic _token,
93     address _to,
94     uint256 _value
95   )
96     internal
97   {
98     require(_token.transfer(_to, _value));
99   }
100 
101   function safeTransferFrom(
102     ERC20 _token,
103     address _from,
104     address _to,
105     uint256 _value
106   )
107     internal
108   {
109     require(_token.transferFrom(_from, _to, _value));
110   }
111 
112   function safeApprove(
113     ERC20 _token,
114     address _spender,
115     uint256 _value
116   )
117     internal
118   {
119     require(_token.approve(_spender, _value));
120   }
121 }
122 
123 /**
124  * @title Crowdsale
125  * @dev Crowdsale is a base contract for managing a token crowdsale,
126  * allowing investors to purchase tokens with ether. This contract implements
127  * such functionality in its most fundamental form and can be extended to provide additional
128  * functionality and/or custom behavior.
129  * The external interface represents the basic interface for purchasing tokens, and conform
130  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
131  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
132  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
133  * behavior.
134  */
135 contract Crowdsale {
136   using SafeMath for uint256;
137   using SafeERC20 for ERC20;
138 
139   // The token being sold
140   ERC20 public token;
141 
142   // Address where funds are collected
143   address public wallet;
144 
145   // How many token units a buyer gets per wei.
146   // The rate is the conversion between wei and the smallest and indivisible token unit.
147   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
148   // 1 wei will give you 1 unit, or 0.001 TOK.
149   uint256 public rate;
150 
151   // Amount of wei raised
152   uint256 public weiRaised;
153 
154   /**
155    * Event for token purchase logging
156    * @param purchaser who paid for the tokens
157    * @param beneficiary who got the tokens
158    * @param value weis paid for purchase
159    * @param amount amount of tokens purchased
160    */
161   event TokenPurchase(
162     address indexed purchaser,
163     address indexed beneficiary,
164     uint256 value,
165     uint256 amount
166   );
167 
168   /**
169    * @param _rate Number of token units a buyer gets per wei
170    * @param _wallet Address where collected funds will be forwarded to
171    * @param _token Address of the token being sold
172    */
173   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
174     require(_rate > 0);
175     require(_wallet != address(0));
176     require(_token != address(0));
177 
178     rate = _rate;
179     wallet = _wallet;
180     token = _token;
181   }
182 
183   // -----------------------------------------
184   // Crowdsale external interface
185   // -----------------------------------------
186 
187   /**
188    * @dev fallback function ***DO NOT OVERRIDE***
189    */
190   function () external payable {
191     buyTokens(msg.sender);
192   }
193 
194   /**
195    * @dev low level token purchase ***DO NOT OVERRIDE***
196    * @param _beneficiary Address performing the token purchase
197    */
198   function buyTokens(address _beneficiary) public payable {
199 
200     uint256 weiAmount = msg.value;
201     _preValidatePurchase(_beneficiary, weiAmount);
202 
203     // calculate token amount to be created
204     uint256 tokens = _getTokenAmount(weiAmount);
205 
206     // update state
207     weiRaised = weiRaised.add(weiAmount);
208 
209     _processPurchase(_beneficiary, tokens);
210     emit TokenPurchase(
211       msg.sender,
212       _beneficiary,
213       weiAmount,
214       tokens
215     );
216 
217     _updatePurchasingState(_beneficiary, weiAmount);
218 
219     _forwardFunds();
220     _postValidatePurchase(_beneficiary, weiAmount);
221   }
222 
223   // -----------------------------------------
224   // Internal interface (extensible)
225   // -----------------------------------------
226 
227   /**
228    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
229    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
230    *   super._preValidatePurchase(_beneficiary, _weiAmount);
231    *   require(weiRaised.add(_weiAmount) <= cap);
232    * @param _beneficiary Address performing the token purchase
233    * @param _weiAmount Value in wei involved in the purchase
234    */
235   function _preValidatePurchase(
236     address _beneficiary,
237     uint256 _weiAmount
238   )
239     internal
240   {
241     require(_beneficiary != address(0));
242     require(_weiAmount != 0);
243   }
244 
245   /**
246    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
247    * @param _beneficiary Address performing the token purchase
248    * @param _weiAmount Value in wei involved in the purchase
249    */
250   function _postValidatePurchase(
251     address _beneficiary,
252     uint256 _weiAmount
253   )
254     internal
255   {
256     // optional override
257   }
258 
259   /**
260    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
261    * @param _beneficiary Address performing the token purchase
262    * @param _tokenAmount Number of tokens to be emitted
263    */
264   function _deliverTokens(
265     address _beneficiary,
266     uint256 _tokenAmount
267   )
268     internal
269   {
270     token.safeTransfer(_beneficiary, _tokenAmount);
271   }
272 
273   /**
274    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
275    * @param _beneficiary Address receiving the tokens
276    * @param _tokenAmount Number of tokens to be purchased
277    */
278   function _processPurchase(
279     address _beneficiary,
280     uint256 _tokenAmount
281   )
282     internal
283   {
284     _deliverTokens(_beneficiary, _tokenAmount);
285   }
286 
287   /**
288    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
289    * @param _beneficiary Address receiving the tokens
290    * @param _weiAmount Value in wei involved in the purchase
291    */
292   function _updatePurchasingState(
293     address _beneficiary,
294     uint256 _weiAmount
295   )
296     internal
297   {
298     // optional override
299   }
300 
301   /**
302    * @dev Override to extend the way in which ether is converted to tokens.
303    * @param _weiAmount Value in wei to be converted into tokens
304    * @return Number of tokens that can be purchased with the specified _weiAmount
305    */
306   function _getTokenAmount(uint256 _weiAmount)
307     internal view returns (uint256)
308   {
309     return _weiAmount.mul(rate);
310   }
311 
312   /**
313    * @dev Determines how ETH is stored/forwarded on purchases.
314    */
315   function _forwardFunds() internal {
316     wallet.transfer(msg.value);
317   }
318 }
319 
320 /**
321  * @title AllowanceCrowdsale
322  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
323  */
324 contract AllowanceCrowdsale is Crowdsale {
325   using SafeMath for uint256;
326   using SafeERC20 for ERC20;
327 
328   address public tokenWallet;
329 
330   /**
331    * @dev Constructor, takes token wallet address.
332    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
333    */
334   constructor(address _tokenWallet) public {
335     require(_tokenWallet != address(0));
336     tokenWallet = _tokenWallet;
337   }
338 
339   /**
340    * @dev Checks the amount of tokens left in the allowance.
341    * @return Amount of tokens left in the allowance
342    */
343   function remainingTokens() public view returns (uint256) {
344     return token.allowance(tokenWallet, this);
345   }
346 
347   /**
348    * @dev Overrides parent behavior by transferring tokens from wallet.
349    * @param _beneficiary Token purchaser
350    * @param _tokenAmount Amount of tokens purchased
351    */
352   function _deliverTokens(
353     address _beneficiary,
354     uint256 _tokenAmount
355   )
356     internal
357   {
358     token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
359   }
360 }
361 
362 /**
363  * @title Ownable
364  * @dev The Ownable contract has an owner address, and provides basic authorization control
365  * functions, this simplifies the implementation of "user permissions".
366  */
367 contract Ownable {
368   address public owner;
369 
370 
371   event OwnershipRenounced(address indexed previousOwner);
372   event OwnershipTransferred(
373     address indexed previousOwner,
374     address indexed newOwner
375   );
376 
377 
378   /**
379    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
380    * account.
381    */
382   constructor() public {
383     owner = msg.sender;
384   }
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Allows the current owner to relinquish control of the contract.
396    * @notice Renouncing to ownership will leave the contract without an owner.
397    * It will not be possible to call the functions with the `onlyOwner`
398    * modifier anymore.
399    */
400   function renounceOwnership() public onlyOwner {
401     emit OwnershipRenounced(owner);
402     owner = address(0);
403   }
404 
405   /**
406    * @dev Allows the current owner to transfer control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function transferOwnership(address _newOwner) public onlyOwner {
410     _transferOwnership(_newOwner);
411   }
412 
413   /**
414    * @dev Transfers control of the contract to a newOwner.
415    * @param _newOwner The address to transfer ownership to.
416    */
417   function _transferOwnership(address _newOwner) internal {
418     require(_newOwner != address(0));
419     emit OwnershipTransferred(owner, _newOwner);
420     owner = _newOwner;
421   }
422 }
423 
424 contract GetExpertCrowdsale is AllowanceCrowdsale, Ownable {
425 
426   constructor(address _tokenWallet, uint256 _rate, address _wallet, ERC20 _token) public
427     AllowanceCrowdsale(_tokenWallet)
428     Crowdsale(_rate, _wallet, _token) {
429 
430   }
431 
432   function setTokenWallet(address _tokenWallet) public onlyOwner returns (bool) {
433     require(_tokenWallet != address(0));
434     tokenWallet = _tokenWallet;
435     return true;
436   }
437 
438   function setEtherWallet(address _wallet) public onlyOwner returns (bool) {
439     require(_wallet != address(0));
440     wallet = _wallet;
441     return true;
442   }
443 
444   function setRate(uint256 _rate) public onlyOwner returns (bool) {
445     require(_rate > 0);
446     rate = _rate;
447     return true;
448   }
449 
450 }