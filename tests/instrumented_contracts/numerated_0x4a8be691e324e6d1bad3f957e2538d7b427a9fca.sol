1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     require(newOwner != address(0));      
36     owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal constant returns (uint256) {
53     // assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal constant returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) constant returns (uint256);
79   function transfer(address to, uint256 value) returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) returns (bool);
90   function approve(address spender, uint256 value) returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances. 
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) returns (bool) {
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of. 
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) constant returns (uint256 balance) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
145     var _allowance = allowed[_from][msg.sender];
146 
147     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
148     // require (_value <= _allowance);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = _allowance.sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) returns (bool) {
163 
164     // To change the approve amount you first have to reduce the addresses`
165     //  allowance to zero by calling `approve(_spender, 0)` if it is not
166     //  already 0 to mitigate the race condition described here:
167     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
169 
170     allowed[msg.sender][_spender] = _value;
171     Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182     return allowed[_owner][_spender];
183   }
184   
185     /*
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until 
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    */
191   function increaseApproval (address _spender, uint _addedValue) 
192     returns (bool success) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   function decreaseApproval (address _spender, uint _subtractedValue) 
199     returns (bool success) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Mintable token
214  * @dev Simple ERC20 Token example, with mintable token creation
215  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
216  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
217  */
218 
219 contract MintableToken is StandardToken, Ownable {
220   event Mint(address indexed to, uint256 amount);
221   event MintFinished();
222 
223   bool public mintingFinished = false;
224 
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will receive the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     Mint(_to, _amount);
241     Transfer(0x0, _to, _amount);
242     return true;
243   }
244 
245   /**
246    * @dev Function to stop minting new tokens.
247    * @return True if the operation was successful.
248    */
249   function finishMinting() onlyOwner returns (bool) {
250     mintingFinished = true;
251     MintFinished();
252     return true;
253   }
254 }
255 
256 /**
257  * @title SimpleToken
258  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
259  */
260 contract SimpleToken is MintableToken {
261 
262   string public constant name = "GlobalSimpleToken";
263   string public constant symbol = "GSIM";
264   uint8 public constant decimals = 18;
265 
266   uint256 public constant INITIAL_SUPPLY = 10;
267 
268   /**
269    * @dev Contructor that gives msg.sender all of existing tokens.
270    */
271   function SimpleToken() {
272     totalSupply = INITIAL_SUPPLY;
273     balances[msg.sender] = INITIAL_SUPPLY;
274   }
275 
276 }
277 
278 /**
279  * @title Crowdsale 
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet 
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */ 
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
316     //require(_startTime >= now);
317     require(_endTime >= _startTime);
318     require(_rate > 0);
319     require(_wallet != 0x0);
320 
321     token = createTokenContract();
322     startTime = _startTime;
323     endTime = _endTime;
324     rate = _rate;
325     wallet = _wallet;
326   }
327 
328   // creates the token to be sold. 
329   // override this method to have crowdsale of a specific mintable token.
330   function createTokenContract() internal returns (MintableToken) {
331     return new MintableToken();
332   }
333 
334 
335   // fallback function can be used to buy tokens
336   function () payable {
337     buyTokens(msg.sender);
338   }
339 
340   // low level token purchase function
341   function buyTokens(address beneficiary) payable {
342     require(beneficiary != 0x0);
343     require(validPurchase());
344 
345     uint256 weiAmount = msg.value;
346 
347     // calculate token amount to be created
348     uint256 tokens = weiAmount.mul(rate);
349 
350     // update state
351     weiRaised = weiRaised.add(weiAmount);
352 
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355 
356     forwardFunds();
357   }
358 
359   // send ether to the fund collection wallet
360   // override to create custom fund forwarding mechanisms
361   function forwardFunds() internal {
362     wallet.transfer(msg.value);
363   }
364 
365   // @return true if the transaction can buy tokens
366   function validPurchase() internal constant returns (bool) {
367     bool withinPeriod = now >= startTime && now <= endTime;
368     bool nonZeroPurchase = msg.value != 0;
369     return withinPeriod && nonZeroPurchase;
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public constant returns (bool) {
374     return now > endTime;
375   }
376 
377 
378 }
379 
380 /**
381  * @title CappedCrowdsale
382  * @dev Extension of Crowsdale with a max amount of funds raised
383  */
384 contract CappedCrowdsale is Crowdsale {
385   using SafeMath for uint256;
386 
387   uint256 public cap;
388 
389   function CappedCrowdsale(uint256 _cap) {
390     require(_cap > 0);
391     cap = _cap * 1000000000000000000;
392   }
393 
394   // overriding Crowdsale#validPurchase to add extra cap logic
395   // @return true if investors can buy at the moment
396   function validPurchase() internal constant returns (bool) {
397     bool withinCap = weiRaised.add(msg.value) <= cap;
398     return super.validPurchase() && withinCap;
399   }
400 
401   // overriding Crowdsale#hasEnded to add cap logic
402   // @return true if crowdsale event has ended
403   function hasEnded() public constant returns (bool) {
404     bool capReached = weiRaised >= cap;
405     return super.hasEnded() || capReached;
406   }
407 
408 }
409 
410 /**
411  * @title FinalizableCrowdsale
412  * @dev Extension of Crowsdale where an owner can do extra work
413  * after finishing. 
414  */
415 contract FinalizableCrowdsale is Crowdsale, Ownable {
416   using SafeMath for uint256;
417 
418   bool public isFinalized = false;
419 
420   event Finalized();
421 
422   /**
423    * @dev Must be called after crowdsale ends, to do some extra finalization
424    * work. Calls the contract's finalization function.
425    */
426   function finalize() onlyOwner {
427     require(!isFinalized);
428     require(hasEnded());
429 
430     finalization();
431     Finalized();
432     
433     isFinalized = true;
434   }
435 
436   /**
437    * @dev Can be overriden to add finalization logic. The overriding function
438    * should call super.finalization() to ensure the chain of finalization is
439    * executed entirely.
440    */
441   function finalization() internal {
442   }
443 }
444 
445 
446 /**
447  * @title SampleCrowdsale
448  * @dev This is an example of a fully fledged crowdsale.
449  * The way to add new features to a base crowdsale is by multiple inheritance.
450  * In this example we are providing following extensions:
451  * CappedCrowdsale - sets a max boundary for raised funds
452  *
453  * After adding multiple features it's good practice to run integration tests
454  * to ensure that subcontracts works together as intended.
455  */
456 contract SampleCrowdsale is CappedCrowdsale,FinalizableCrowdsale {
457 
458   function SampleCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
459     CappedCrowdsale(_cap)
460     FinalizableCrowdsale()
461     Crowdsale(_startTime, _endTime, _rate, _wallet)
462   {
463     //As goal needs to be met for a successful crowdsale
464     //the value needs to less or equal than a cap which is limit for accepted funds
465     //require(_goal <= _cap);
466   }
467 
468   function createTokenContract() internal returns (MintableToken) {
469     return new SimpleToken();
470   }
471 
472 }