1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     if (a == 0) {
73       return 0;
74     }
75     uint256 c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return c;
85   }
86 
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   function add(uint256 a, uint256 b) internal pure returns (uint256) {
93     uint256 c = a + b;
94     assert(c >= a);
95     return c;
96   }
97 }
98 
99 
100 
101 
102 
103 
104 /**
105  * @title Crowdsale
106  * @dev Crowdsale is a base contract for managing a token crowdsale.
107  * Crowdsales have a start and end timestamps, where investors can make
108  * token purchases and the crowdsale will assign them tokens based
109  * on a token per ETH rate. Funds collected are forwarded to a wallet
110  * as they arrive.
111  */
112 contract Crowdsale {
113   using SafeMath for uint256;
114 
115   // The token being sold
116   MintableToken public token;
117 
118   // start and end timestamps where investments are allowed (both inclusive)
119   uint256 public startTime;
120   uint256 public endTime;
121 
122   // address where funds are collected
123   address public wallet;
124 
125   // how many token units a buyer gets per wei
126   uint256 public rate;
127 
128   // amount of raised money in wei
129   uint256 public weiRaised;
130 
131   /**
132    * event for token purchase logging
133    * @param purchaser who paid for the tokens
134    * @param beneficiary who got the tokens
135    * @param value weis paid for purchase
136    * @param amount amount of tokens purchased
137    */
138   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
139 
140 
141   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
142     require(_startTime >= now);
143     require(_endTime >= _startTime);
144     require(_rate > 0);
145     require(_wallet != address(0));
146 
147     token = createTokenContract();
148     startTime = _startTime;
149     endTime = _endTime;
150     rate = _rate;
151     wallet = _wallet;
152   }
153 
154   // creates the token to be sold.
155   // override this method to have crowdsale of a specific mintable token.
156   function createTokenContract() internal returns (MintableToken) {
157     return new MintableToken();
158   }
159 
160 
161   // fallback function can be used to buy tokens
162   function () external payable {
163     buyTokens(msg.sender);
164   }
165 
166   // low level token purchase function
167   function buyTokens(address beneficiary) public payable {
168     require(beneficiary != address(0));
169     require(validPurchase());
170 
171     uint256 weiAmount = msg.value;
172 
173     // calculate token amount to be created
174     uint256 tokens = weiAmount.mul(rate);
175 
176     // update state
177     weiRaised = weiRaised.add(weiAmount);
178 
179     token.mint(beneficiary, tokens);
180     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
181 
182     forwardFunds();
183   }
184 
185   // send ether to the fund collection wallet
186   // override to create custom fund forwarding mechanisms
187   function forwardFunds() internal {
188     wallet.transfer(msg.value);
189   }
190 
191   // @return true if the transaction can buy tokens
192   function validPurchase() internal view returns (bool) {
193     bool withinPeriod = now >= startTime && now <= endTime;
194     bool nonZeroPurchase = msg.value != 0;
195     return withinPeriod && nonZeroPurchase;
196   }
197 
198   // @return true if crowdsale event has ended
199   function hasEnded() public view returns (bool) {
200     return now > endTime;
201   }
202 
203 
204 }
205 
206 
207 /**
208  * @title CappedCrowdsale
209  * @dev Extension of Crowdsale with a max amount of funds raised
210  */
211 contract CappedCrowdsale is Crowdsale {
212   using SafeMath for uint256;
213 
214   uint256 public cap;
215 
216   function CappedCrowdsale(uint256 _cap) public {
217     require(_cap > 0);
218     cap = _cap;
219   }
220 
221   // overriding Crowdsale#validPurchase to add extra cap logic
222   // @return true if investors can buy at the moment
223   function validPurchase() internal view returns (bool) {
224     bool withinCap = weiRaised.add(msg.value) <= cap;
225     return super.validPurchase() && withinCap;
226   }
227 
228   // overriding Crowdsale#hasEnded to add cap logic
229   // @return true if crowdsale event has ended
230   function hasEnded() public view returns (bool) {
231     bool capReached = weiRaised >= cap;
232     return super.hasEnded() || capReached;
233   }
234 
235 }
236 
237 
238 
239 
240 
241 
242 
243 
244 
245 
246 
247 
248 
249 
250 /**
251  * @title Basic token
252  * @dev Basic version of StandardToken, with no allowances.
253  */
254 contract BasicToken is ERC20Basic {
255   using SafeMath for uint256;
256 
257   mapping(address => uint256) balances;
258 
259   /**
260   * @dev transfer token for a specified address
261   * @param _to The address to transfer to.
262   * @param _value The amount to be transferred.
263   */
264   function transfer(address _to, uint256 _value) public returns (bool) {
265     require(_to != address(0));
266     require(_value <= balances[msg.sender]);
267 
268     // SafeMath.sub will throw if there is not enough balance.
269     balances[msg.sender] = balances[msg.sender].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     Transfer(msg.sender, _to, _value);
272     return true;
273   }
274 
275   /**
276   * @dev Gets the balance of the specified address.
277   * @param _owner The address to query the the balance of.
278   * @return An uint256 representing the amount owned by the passed address.
279   */
280   function balanceOf(address _owner) public view returns (uint256 balance) {
281     return balances[_owner];
282   }
283 
284 }
285 
286 
287 
288 
289 
290 
291 
292 /**
293  * @title ERC20 interface
294  * @dev see https://github.com/ethereum/EIPs/issues/20
295  */
296 contract ERC20 is ERC20Basic {
297   function allowance(address owner, address spender) public view returns (uint256);
298   function transferFrom(address from, address to, uint256 value) public returns (bool);
299   function approve(address spender, uint256 value) public returns (bool);
300   event Approval(address indexed owner, address indexed spender, uint256 value);
301 }
302 
303 
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * @dev https://github.com/ethereum/EIPs/issues/20
310  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
311  */
312 contract StandardToken is ERC20, BasicToken {
313 
314   mapping (address => mapping (address => uint256)) internal allowed;
315 
316 
317   /**
318    * @dev Transfer tokens from one address to another
319    * @param _from address The address which you want to send tokens from
320    * @param _to address The address which you want to transfer to
321    * @param _value uint256 the amount of tokens to be transferred
322    */
323   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
324     require(_to != address(0));
325     require(_value <= balances[_from]);
326     require(_value <= allowed[_from][msg.sender]);
327 
328     balances[_from] = balances[_from].sub(_value);
329     balances[_to] = balances[_to].add(_value);
330     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
331     Transfer(_from, _to, _value);
332     return true;
333   }
334 
335   /**
336    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
337    *
338    * Beware that changing an allowance with this method brings the risk that someone may use both the old
339    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
340    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
341    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
342    * @param _spender The address which will spend the funds.
343    * @param _value The amount of tokens to be spent.
344    */
345   function approve(address _spender, uint256 _value) public returns (bool) {
346     allowed[msg.sender][_spender] = _value;
347     Approval(msg.sender, _spender, _value);
348     return true;
349   }
350 
351   /**
352    * @dev Function to check the amount of tokens that an owner allowed to a spender.
353    * @param _owner address The address which owns the funds.
354    * @param _spender address The address which will spend the funds.
355    * @return A uint256 specifying the amount of tokens still available for the spender.
356    */
357   function allowance(address _owner, address _spender) public view returns (uint256) {
358     return allowed[_owner][_spender];
359   }
360 
361   /**
362    * approve should be called when allowed[_spender] == 0. To increment
363    * allowed value is better to use this function to avoid 2 calls (and wait until
364    * the first transaction is mined)
365    * From MonolithDAO Token.sol
366    */
367   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
368     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
369     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
370     return true;
371   }
372 
373   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
374     uint oldValue = allowed[msg.sender][_spender];
375     if (_subtractedValue > oldValue) {
376       allowed[msg.sender][_spender] = 0;
377     } else {
378       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
379     }
380     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
381     return true;
382   }
383 
384 }
385 
386 
387 
388 
389 
390 /**
391  * @title Mintable token
392  * @dev Simple ERC20 Token example, with mintable token creation
393  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
394  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
395  */
396 
397 contract MintableToken is StandardToken, Ownable {
398   event Mint(address indexed to, uint256 amount);
399   event MintFinished();
400 
401   bool public mintingFinished = false;
402 
403 
404   modifier canMint() {
405     require(!mintingFinished);
406     _;
407   }
408 
409   /**
410    * @dev Function to mint tokens
411    * @param _to The address that will receive the minted tokens.
412    * @param _amount The amount of tokens to mint.
413    * @return A boolean that indicates if the operation was successful.
414    */
415   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
416     totalSupply = totalSupply.add(_amount);
417     balances[_to] = balances[_to].add(_amount);
418     Mint(_to, _amount);
419     Transfer(address(0), _to, _amount);
420     return true;
421   }
422 
423   /**
424    * @dev Function to stop minting new tokens.
425    * @return True if the operation was successful.
426    */
427   function finishMinting() onlyOwner canMint public returns (bool) {
428     mintingFinished = true;
429     MintFinished();
430     return true;
431   }
432 }
433 
434 
435 
436 
437 
438 
439 
440 contract BlockchainAirToken is MintableToken {
441     string public constant name = "BlockchainAirToken";
442     string public constant symbol = "AIR";
443     uint8 public constant decimals = 18;
444 }
445 
446 
447 contract BlockchainAirCrowdsale is CappedCrowdsale, Ownable {
448     uint256 public reminder;
449 
450     function BlockchainAirCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _reminder, uint256 _cap, address _wallet) public
451         CappedCrowdsale(_cap)
452         Crowdsale(_startTime, _endTime, _rate, _wallet)
453     {
454         reminder = _reminder;
455     }
456 
457     function transferTokens(address _to, uint256 _amount) onlyOwner external {
458         token.mint(_to, _amount);
459     }
460 
461     function setCap(uint256 _cap) onlyOwner external {
462         require(_cap > 0);
463         cap = _cap;
464     }
465 
466     function buyTokens(address beneficiary) public payable {
467         require(beneficiary != address(0));
468         require(validPurchase());
469 
470         uint256 weiAmount = msg.value;
471 
472         uint256 tokens = weiAmount.mul(rate).add(weiAmount.mul(reminder).div(100));
473 
474         weiRaised = weiRaised.add(weiAmount);
475 
476         token.mint(beneficiary, tokens);
477         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
478 
479         forwardFunds();
480     }
481 
482     function createTokenContract() internal returns (MintableToken) {
483         return new BlockchainAirToken();
484     }
485 }