1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev Total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev Transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(
187     address _owner,
188     address _spender
189    )
190     public
191     view
192     returns (uint256)
193   {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint256 _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint256 oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title DetailedERC20 token
249  * @dev The decimals are only for visualization purposes.
250  * All the operations are done using the smallest and indivisible token unit,
251  * just as on Ethereum all the operations are done in wei.
252  */
253 contract DetailedERC20 is ERC20 {
254   string public name;
255   string public symbol;
256   uint8 public decimals;
257 
258   constructor(string _name, string _symbol, uint8 _decimals) public {
259     name = _name;
260     symbol = _symbol;
261     decimals = _decimals;
262   }
263 }
264 
265 /**
266  * @title SplitPayment
267  * @dev Base contract that supports multiple payees claiming funds sent to this contract
268  * according to the proportion they own.
269  */
270 contract SplitPayment {
271   using SafeMath for uint256;
272 
273   uint256 public totalShares = 0;
274   uint256 public totalReleased = 0;
275 
276   mapping(address => uint256) public shares;
277   mapping(address => uint256) public released;
278   address[] public payees;
279 
280   /**
281    * @dev Constructor
282    */
283   constructor(address[] _payees, uint256[] _shares) public payable {
284     require(_payees.length == _shares.length);
285 
286     for (uint256 i = 0; i < _payees.length; i++) {
287       addPayee(_payees[i], _shares[i]);
288     }
289   }
290 
291   /**
292    * @dev payable fallback
293    */
294   function () public payable {}
295 
296   /**
297    * @dev Claim your share of the balance.
298    */
299   function claim() public {
300     address payee = msg.sender;
301 
302     require(shares[payee] > 0);
303 
304     uint256 totalReceived = address(this).balance.add(totalReleased);
305     uint256 payment = totalReceived.mul(
306       shares[payee]).div(
307         totalShares).sub(
308           released[payee]
309     );
310 
311     require(payment != 0);
312     require(address(this).balance >= payment);
313 
314     released[payee] = released[payee].add(payment);
315     totalReleased = totalReleased.add(payment);
316 
317     payee.transfer(payment);
318   }
319 
320   /**
321    * @dev Add a new payee to the contract.
322    * @param _payee The address of the payee to add.
323    * @param _shares The number of shares owned by the payee.
324    */
325   function addPayee(address _payee, uint256 _shares) internal {
326     require(_payee != address(0));
327     require(_shares > 0);
328     require(shares[_payee] == 0);
329 
330     payees.push(_payee);
331     shares[_payee] = _shares;
332     totalShares = totalShares.add(_shares);
333   }
334 }
335 
336 /**
337  * @title Sontaku token contract
338  * @dev ERC20-compatible token which is mintable, capped and timed crowdsalable
339  */
340 
341 contract SontakuToken is StandardToken, DetailedERC20, SplitPayment {
342   using SafeMath for uint256;
343 
344   /**
345    * Event for token purchase logging
346    * @param purchaser who paid for the tokens
347    * @param beneficiary who got the tokens
348    * @param value weis paid for purchase
349    * @param amount amount of tokens purchased
350    */
351   event Purchase(
352     address indexed purchaser,
353     address indexed beneficiary,
354     uint256 value,
355     uint256 amount
356   );
357 
358   string constant TOKEN_NAME = "Sontaku";
359   string constant TOKEN_SYMBOL = "SONTAKU";
360   uint8 constant TOKEN_DECIMALS = 18;
361   uint256 constant EXCHANGE_RATE = 46490;
362   uint256 constant HARD_CAP = 46494649 * (uint256(10)**TOKEN_DECIMALS);
363   uint256 constant MIN_PURCHASE = 4649 * (uint256(10)**(TOKEN_DECIMALS - 2));
364 
365   uint256 public exchangeRate;          // Token units per wei on purchase
366   uint256 public hardCap;               // Maximum mintable tokens
367   uint256 public minPurchase;           // Minimum purchase tokens
368   uint256 public crowdsaleOpeningTime;  // Starting time for crowdsale
369   uint256 public crowdsaleClosingTime;  // Finishing time for crowdsale
370   uint256 public fundRaised;            // Amount of wei raised
371 
372   constructor(
373     address[] _founders,
374     uint256[] _founderShares,
375     uint256 _crowdsaleOpeningTime, 
376     uint256 _crowdsaleClosingTime
377   )
378     DetailedERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS)
379     SplitPayment(_founders, _founderShares)
380     public 
381   {
382     require(_crowdsaleOpeningTime <= _crowdsaleClosingTime);
383 
384     exchangeRate = EXCHANGE_RATE;
385     hardCap = HARD_CAP;
386     minPurchase = MIN_PURCHASE;
387     crowdsaleOpeningTime = _crowdsaleOpeningTime;
388     crowdsaleClosingTime = _crowdsaleClosingTime;
389 
390     for (uint i = 0; i < _founders.length; i++) {
391       _mint(_founders[i], _founderShares[i]);
392     }
393   }
394 
395   // -----------------------------------------
396   // Crowdsale external interface
397   // -----------------------------------------
398 
399   function () public payable {
400     buyTokens(msg.sender);
401   }
402 
403   /**
404    * @param _beneficiary Address performing the token purchase
405    */
406   function buyTokens(address _beneficiary) public payable {
407 
408     uint256 weiAmount = msg.value;
409     uint256 tokenAmount = _getTokenAmount(weiAmount);
410 
411     _validatePurchase(_beneficiary, weiAmount, tokenAmount);
412     _processPurchase(_beneficiary, weiAmount, tokenAmount);
413 
414     emit Purchase(
415       msg.sender,
416       _beneficiary,
417       weiAmount,
418       tokenAmount
419     );
420   }
421 
422   // -----------------------------------------
423   // Internal interface (extensible)
424   // -----------------------------------------
425 
426   /**
427    * @param _beneficiary Address performing the token purchase
428    * @param _weiAmount Value in wei involved in the purchase
429    * @param _tokenAmount Number of tokens to be purchased
430    */
431   function _validatePurchase(
432     address _beneficiary,
433     uint256 _weiAmount,
434     uint256 _tokenAmount
435   )
436     internal view
437   {
438     require(_beneficiary != address(0));
439     require(_weiAmount != 0);
440     require(_tokenAmount >= minPurchase);
441     require(totalSupply_ + _tokenAmount <= hardCap);
442     require(block.timestamp >= crowdsaleOpeningTime);
443     require(block.timestamp <= crowdsaleClosingTime);
444   }
445 
446   /**
447    * @param _beneficiary Address receiving the tokens
448    * @param _weiAmount Value in wei involved in the purchase
449    * @param _tokenAmount Number of tokens to be purchased
450    */
451   function _processPurchase(
452     address _beneficiary,
453     uint256 _weiAmount,
454     uint256 _tokenAmount
455   )
456     internal
457   {
458     _mint(_beneficiary, _tokenAmount);
459     fundRaised = fundRaised.add(_weiAmount);
460   }
461 
462   /**
463    * @param _beneficiary Address receiving the tokens
464    * @param _tokenAmount Number of tokens to be minted
465    */
466   function _mint(
467     address _beneficiary, 
468     uint256 _tokenAmount
469   )
470     internal
471   {
472     totalSupply_ = totalSupply_.add(_tokenAmount);
473     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
474 
475     emit Transfer(address(0), _beneficiary, _tokenAmount);
476   }
477 
478   /**
479    * @param _weiAmount Value in wei to be converted into tokens
480    * @return Number of tokens that can be purchased with the specified _weiAmount
481    */
482   function _getTokenAmount(uint256 _weiAmount)
483     internal view returns (uint256)
484   {
485     return _weiAmount.mul(exchangeRate);
486   }
487 }