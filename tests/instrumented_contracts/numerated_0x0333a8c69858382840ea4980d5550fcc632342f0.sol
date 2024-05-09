1 pragma solidity ^0.4.20;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public view returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * @dev https://github.com/ethereum/EIPs/issues/20
172  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 /**
263  * @title Burnable Token
264  * @dev Token that can be irreversibly burned (destroyed).
265  */
266 contract BurnableToken is BasicToken {
267 
268   event Burn(address indexed burner, uint256 value);
269 
270   /**
271    * @dev Burns a specific amount of tokens.
272    * @param _value The amount of token to be burned.
273    */
274   function burn(uint256 _value) public {
275     require(_value <= balances[msg.sender]);
276     // no need to require value <= totalSupply, since that would imply the
277     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
278 
279     address burner = msg.sender;
280     balances[burner] = balances[burner].sub(_value);
281     totalSupply_ = totalSupply_.sub(_value);
282     emit Burn(burner, _value);
283     emit Transfer(burner, address(0), _value);
284   }
285 }
286 
287 
288 /**
289  * @title Mintable token
290  * @dev Simple ERC20 Token example, with mintable token creation
291  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
292  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
293  */
294 contract MintableToken is StandardToken, Ownable, BurnableToken {
295   event Mint(address indexed to, uint256 amount);
296   event MintFinished();
297   string public name = "VinCoin";
298   string public symbol = "VNC";
299   uint public decimals = 18;
300   uint256 public constant INITIAL_SUPPLY = 30000000 * (10 ** 18);
301   
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }	
309 	
310   function MintableToken() public {
311     totalSupply_ = INITIAL_SUPPLY;
312     balances[msg.sender] = INITIAL_SUPPLY;
313     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
314   }	
315 	
316  
317 
318   /**
319    * @dev Function to mint tokens
320    * @param _to The address that will receive the minted tokens.
321    * @param _amount The amount of tokens to mint.
322    * @return A boolean that indicates if the operation was successful.
323    */
324   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
325     totalSupply_ = totalSupply_.add(_amount);
326     balances[_to] = balances[_to].add(_amount);
327     emit Mint(_to, _amount);
328     emit Transfer(address(0), _to, _amount);
329     return true;
330   }
331 
332   /**
333    * @dev Function to stop minting new tokens.
334    * @return True if the operation was successful.
335    */
336   function finishMinting() onlyOwner canMint public returns (bool) {
337     mintingFinished = true;
338     emit MintFinished();
339     return true;
340   }
341 }
342 
343 contract Crowdsale is Ownable {
344 using SafeMath for uint256;
345 
346 // The token being sold
347 MintableToken public token;
348 
349 // start and end timestamps where investments are allowed (both inclusive)
350 uint256 public startTime;
351 uint256 public endTime;
352 
353 // address where funds are collected
354 address public wallet;
355 
356 // amount of raised money in wei
357 uint256 public weiRaised;
358 
359 // amount of tokens that were sold
360 uint256 public tokensSold;
361 
362 // Hard cap in VNC tokens
363 uint256 constant public hardCap = 24000000 * (10**18);
364 
365 /**
366 * event for token purchase logging
367 * @param purchaser who paid for the tokens
368 * @param beneficiary who got the tokens
369 * @param value weis paid for purchase
370 * @param amount amount of tokens purchased
371 */
372 event TokenPurchase(address indexed purchaser, address indexed beneficiary, 
373 uint256 value, uint256 amount);
374 
375 
376 function Crowdsale(uint256 _startTime, uint256 _endTime, address _wallet, MintableToken tokenContract) public {
377 require(_startTime >= now);
378 require(_endTime >= _startTime);
379 require(_wallet != 0x0);
380 
381 startTime = _startTime;
382 endTime = _endTime;
383 wallet = _wallet;
384 token = tokenContract;
385 }
386 
387 function setNewTokenOwner(address newOwner) public onlyOwner {
388     token.transferOwnership(newOwner);
389 }
390 
391 function createTokenOwner() internal returns (MintableToken) {
392     return new MintableToken();
393 }
394 
395 function () external payable {
396     buyTokens(msg.sender);
397   }
398 
399   /**
400      * @dev Internal function that is used to determine the current rate for token / ETH conversion
401      * @return The current token rate
402      */
403     function getRate() internal view returns (uint256) {
404         if(now < (startTime + 5 weeks)) {
405             return 7000;
406         }
407 
408         if(now < (startTime + 9 weeks)) {
409             return 6500;
410         }
411 
412         if(now < (startTime + 13 weeks)) {
413             return 6000;
414         }
415 		
416         if(now < (startTime + 15 weeks)) {
417             return 5500;
418         }
419         return 5000;
420     }
421    
422   // low level token purchase function
423  function buyTokens(address beneficiary) public payable {
424  require(beneficiary != 0x0);
425  require(validPurchase());
426  require(msg.value >= 0.05 ether);
427 
428  uint256 weiAmount = msg.value;
429  uint256 updateWeiRaised = weiRaised.add(weiAmount);
430  uint256 rate = getRate();
431  uint256 tokens = weiAmount.mul(rate);
432  require ( tokens <= token.balanceOf(this));
433 // update state
434 weiRaised = updateWeiRaised;
435 
436 token.transfer(beneficiary, tokens);
437 
438 tokensSold = tokensSold.add(tokens);
439 
440 emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
441 
442 forwardFunds();
443 }
444 
445 // @return true if crowdsale event has ended
446 function hasEnded() public view returns (bool) {
447 return now > endTime || tokensSold >= hardCap;
448 }
449 
450 // Override this method to have a way to add business logic to your crowdsale when buying
451 function tokenResend() public onlyOwner {
452 token.transfer(owner, token.balanceOf(this));
453 }
454 
455 // send ether to the fund collection wallet
456 // override to create custom fund forwarding mechanisms
457 function forwardFunds() internal {
458 wallet.transfer(msg.value);
459 }
460 
461 // @return true if the transaction can buy tokens
462 function validPurchase() internal view returns (bool) {
463 bool withinPeriod = now >= startTime && now <= endTime;
464 bool nonZeroPurchase = msg.value != 0;
465 bool hardCapNotReached = tokensSold < hardCap;
466         return withinPeriod && nonZeroPurchase && hardCapNotReached;
467 }
468 
469 }