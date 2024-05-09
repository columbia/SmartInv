1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     if (_a == 0) {
16       return 0;
17     }
18 
19     uint256 c = _a * _b;
20     require(c / _a == _b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     require(_b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     require(_b <= _a);
41     uint256 c = _a - _b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     uint256 c = _a + _b;
51     require(c >= _a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
66 /**
67  * @title SafeERC20
68  * @dev Wrappers around ERC20 operations that throw on failure.
69  */
70 library SafeERC20 {
71   function safeTransfer(
72     ERC20 _token,
73     address _to,
74     uint256 _value
75   )
76     internal
77   {
78     require(_token.transfer(_to, _value));
79   }
80 
81   function safeTransferFrom(
82     ERC20 _token,
83     address _from,
84     address _to,
85     uint256 _value
86   )
87     internal
88   {
89     require(_token.transferFrom(_from, _to, _value));
90   }
91 
92   function safeApprove(
93     ERC20 _token,
94     address _spender,
95     uint256 _value
96   )
97     internal
98   {
99     require(_token.approve(_spender, _value));
100   }
101 }
102 
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157 }
158 
159 }
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 {
166   function totalSupply() public view returns (uint256);
167 
168   function balanceOf(address _who) public view returns (uint256);
169 
170   function allowance(address _owner, address _spender)
171     public view returns (uint256);
172 
173   function transfer(address _to, uint256 _value) public returns (bool);
174 
175   function approve(address _spender, uint256 _value)
176     public returns (bool);
177 
178   function transferFrom(address _from, address _to, uint256 _value)
179     public returns (bool);
180 
181   event Transfer(
182     address indexed from,
183     address indexed to,
184     uint256 value
185   );
186 
187   event Approval(
188     address indexed owner,
189     address indexed spender,
190     uint256 value
191   );
192 }
193 
194 contract AddressesFilterFeature is Ownable {}
195 contract ERC20Basic {}
196 contract BasicToken is ERC20Basic {}
197 contract StandardToken is ERC20, BasicToken {}
198 contract MintableToken is AddressesFilterFeature, StandardToken {}
199 
200 contract Token is MintableToken {
201       function mint(address, uint256) public returns (bool);
202 }
203 /**
204  * @title CrowdsaleWPTByRounds
205  * @dev This is an example of a fully fledged crowdsale.
206  * The way to add new features to a base crowdsale is by multiple inheritance.
207  * In this example we are providing following extensions:
208  * CappedCrowdsale - sets a max boundary for raised funds
209  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
210  *
211  * After adding multiple features it's good practice to run integration tests
212  * to ensure that subcontracts works together as intended.
213  */
214 // XXX There doesn't seem to be a way to split this line that keeps solium
215 // happy. See:
216 // https://github.com/duaraghav8/Solium/issues/205
217 // --elopio - 2018-05-10
218 // solium-disable-next-line max-len
219 contract CrowdsaleWPTByRounds is Ownable {
220   using SafeMath for uint256;
221   using SafeERC20 for ERC20;
222 
223   // The token being sold
224   ERC20 public token;
225 
226   // Address where funds are collected
227   address public wallet;
228 
229   // Address of tokens minter
230   Token public minterContract;
231 
232   // How many token units a buyer gets per wei.
233   // The rate is the conversion between wei and the smallest and indivisible token unit.
234   uint256 public rate;
235 
236   // Amount of tokens raised
237   uint256 public tokensRaised;
238 
239   // Cap for current round
240   uint256 public cap;
241 
242   // Time ranges for current round
243   uint256 public openingTime;
244   uint256 public closingTime;
245 
246   //Minimal value of investment
247   uint public minInvestmentValue;
248 
249   /**
250    * @dev Allows the owner to set the minter contract.
251    * @param _minterAddr the minter address
252    */
253   function setMinter(address _minterAddr) public onlyOwner {
254     minterContract = Token(_minterAddr);
255   }
256 
257   /**
258    * @dev Reverts if not in crowdsale time range.
259    */
260   modifier onlyWhileOpen {
261     // solium-disable-next-line security/no-block-members
262     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
263     _;
264   }
265 
266   /**
267    * Event for token purchase logging
268    * @param purchaser who paid for the tokens
269    * @param beneficiary who got the tokens
270    * @param value weis paid for purchase
271    * @param amount amount of tokens purchased
272    */
273   event TokenPurchase(
274     address indexed purchaser,
275     address indexed beneficiary,
276     uint256 value,
277     uint256 amount
278     );
279 
280 constructor () public {
281     rate = 400;
282     wallet = 0xeA9cbceD36a092C596e9c18313536D0EEFacff46;
283     cap = 400000000000000000000000;
284     openingTime = 1534558186;
285     closingTime = 1535320800;
286 
287     minInvestmentValue = 0.02 ether;
288   }
289 
290    /**
291    * @dev Checks whether the cap has been reached.
292    * @return Whether the cap was reached
293    */
294   function capReached() public view returns (bool) {
295     return tokensRaised >= cap;
296   }
297 
298    /**
299    * @dev Correction of current rate.
300    */
301   function changeRate(uint256 newRate) public onlyOwner {
302     rate = newRate;
303   }
304 
305    /**
306    * @dev Close current round.
307    */
308   function closeRound() public onlyOwner {
309     closingTime = block.timestamp + 1;
310   }
311 
312    /**
313    * @dev Set token address.
314    */
315   function setToken(ERC20 _token) public onlyOwner {
316     token = _token;
317   }
318 
319    /**
320    * @dev Set address od deposit wallet.
321    */
322   function setWallet(address _wallet) public onlyOwner {
323     wallet = _wallet;
324   }
325 
326    /**
327    * @dev Change minimal amount of investment.
328    */
329   function changeMinInvest(uint256 newMinValue) public onlyOwner {
330     rate = newMinValue;
331   }
332 
333    /**
334    * @dev Set cap for current round.
335    */
336   function setCap(uint256 _newCap) public onlyOwner {
337     cap = _newCap;
338   }
339 
340    /**
341    * @dev Start new crowdsale round if already not started.
342    */
343   function startNewRound(uint256 _rate, address _wallet, ERC20 _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime) payable public onlyOwner {
344     require(!hasOpened());
345     rate = _rate;
346     wallet = _wallet;
347     token = _token;
348     cap = _cap;
349     openingTime = _openingTime;
350     closingTime = _closingTime;
351   }
352 
353   /**
354    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
355    * @return Whether crowdsale period has elapsed
356    */
357   function hasClosed() public view returns (bool) {
358     // solium-disable-next-line security/no-block-members
359     return block.timestamp > closingTime;
360   }
361 
362   /**
363    * @dev Checks whether the period in which the crowdsale is open.
364    * @return Whether crowdsale period has opened
365    */
366   function hasOpened() public view returns (bool) {
367     // solium-disable-next-line security/no-block-members
368     return (openingTime < block.timestamp && block.timestamp < closingTime);
369   }
370 
371   // -----------------------------------------
372   // Crowdsale external interface
373   // -----------------------------------------
374 
375   /**
376    * @dev fallback function ***DO NOT OVERRIDE***
377    */
378   function () payable external {
379     buyTokens(msg.sender);
380   }
381 
382   /**
383    * @dev low level token purchase ***DO NOT OVERRIDE***
384    * @param _beneficiary Address performing the token purchase
385    */
386   function buyTokens(address _beneficiary) payable public{
387 
388     uint256 weiAmount = msg.value;
389     _preValidatePurchase(_beneficiary, weiAmount);
390 
391     // calculate token amount to be created
392     uint256 tokens = _getTokenAmount(weiAmount);
393 
394     // update state
395     tokensRaised = tokensRaised.add(tokens);
396 
397     minterContract.mint(_beneficiary, tokens);
398     
399     emit TokenPurchase(
400       msg.sender,
401       _beneficiary,
402       weiAmount,
403       tokens
404     );
405 
406     _forwardFunds();
407   }
408 
409   /**
410    * @dev Extend parent behavior requiring purchase to respect the funding cap.
411    * @param _beneficiary Token purchaser
412    *  _weiAmount Amount of wei contributed
413    */
414   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
415   internal
416   view
417   onlyWhileOpen
418   {
419     require(_beneficiary != address(0));
420     require(_weiAmount != 0 && _weiAmount > minInvestmentValue);
421     require(tokensRaised.add(_getTokenAmount(_weiAmount)) <= cap);
422   }
423 
424   /**
425    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
426    * @param _beneficiary Address performing the token purchase
427    * @param _tokenAmount Number of tokens to be emitted
428    */
429   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
430     token.safeTransfer(_beneficiary, _tokenAmount);
431   }
432 
433   /**
434    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
435    * @param _beneficiary Address receiving the tokens
436    * @param _tokenAmount Number of tokens to be purchased
437    */
438   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
439     _deliverTokens(_beneficiary, _tokenAmount);
440   }
441 
442   /**
443    * @dev Override to extend the way in which ether is converted to tokens.
444    * @param _weiAmount Value in wei to be converted into tokens
445    * @return Number of tokens that can be purchased with the specified _weiAmount
446    */
447   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
448     return _weiAmount.mul(rate);
449   }
450 
451   /**
452    * @dev Determines how ETH is stored/forwarded on purchases.
453    */
454   function _forwardFunds() internal {
455     wallet.transfer(msg.value);
456   }
457 }