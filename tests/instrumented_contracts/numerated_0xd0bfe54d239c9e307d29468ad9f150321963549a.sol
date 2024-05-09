1 pragma solidity ^0.4.11;
2 
3 pragma solidity ^0.4.11;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     require(newOwner != address(0));      
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal constant returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/20
88  */
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) constant returns (uint256);
91   function transferFrom(address from, address to, uint256 value) returns (bool);
92   function approve(address spender, uint256 value) returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances. 
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) returns (bool) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of. 
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) constant returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
147     var _allowance = allowed[_from][msg.sender];
148 
149     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150     // require (_value <= _allowance);
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = _allowance.sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) returns (bool) {
165 
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171 
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
184     return allowed[_owner][_spender];
185   }
186   
187     /*
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until 
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    */
193   function increaseApproval (address _spender, uint _addedValue) 
194     returns (bool success) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   function decreaseApproval (address _spender, uint _subtractedValue) 
201     returns (bool success) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222   event Mint(address indexed to, uint256 amount);
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227 
228   modifier canMint() {
229     require(!mintingFinished);
230     _;
231   }
232 
233   /**
234    * @dev Function to mint tokens
235    * @param _to The address that will receive the minted tokens.
236    * @param _amount The amount of tokens to mint.
237    * @return A boolean that indicates if the operation was successful.
238    */
239   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
240     totalSupply = totalSupply.add(_amount);
241     balances[_to] = balances[_to].add(_amount);
242     Mint(_to, _amount);
243     Transfer(0x0, _to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() onlyOwner returns (bool) {
252     mintingFinished = true;
253     MintFinished();
254     return true;
255   }
256 }
257 
258 /**
259  * @title SimpleToken
260  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
261  */
262 contract SimpleToken is MintableToken {
263 
264   string public constant name = "GlobalSimpleToken";
265   string public constant symbol = "GSIM";
266   uint8 public constant decimals = 18;
267 
268   uint256 public constant INITIAL_SUPPLY = 10;
269 
270   /**
271    * @dev Contructor that gives msg.sender all of existing tokens.
272    */
273   function SimpleToken() {
274     totalSupply = INITIAL_SUPPLY;
275     balances[msg.sender] = INITIAL_SUPPLY;
276   }
277 
278 }
279 
280 /**
281  * @title Crowdsale 
282  * @dev Crowdsale is a base contract for managing a token crowdsale.
283  * Crowdsales have a start and end timestamps, where investors can make
284  * token purchases and the crowdsale will assign them tokens based
285  * on a token per ETH rate. Funds collected are forwarded to a wallet 
286  * as they arrive.
287  */
288 contract Crowdsale {
289   using SafeMath for uint256;
290 
291   // The token being sold
292   MintableToken public token;
293 
294   // start and end timestamps where investments are allowed (both inclusive)
295   uint256 public startTime;
296   uint256 public endTime;
297 
298   // address where funds are collected
299   address public wallet;
300 
301   // how many token units a buyer gets per wei
302   uint256 public rate;
303 
304   // amount of raised money in wei
305   uint256 public weiRaised;
306 
307   /**
308    * event for token purchase logging
309    * @param purchaser who paid for the tokens
310    * @param beneficiary who got the tokens
311    * @param value weis paid for purchase
312    * @param amount amount of tokens purchased
313    */ 
314   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
315 
316 
317   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
318     //require(_startTime >= now);
319     require(_endTime >= _startTime);
320     require(_rate > 0);
321     require(_wallet != 0x0);
322 
323     token = createTokenContract();
324     startTime = _startTime;
325     endTime = _endTime;
326     rate = _rate;
327     wallet = _wallet;
328   }
329 
330   // creates the token to be sold. 
331   // override this method to have crowdsale of a specific mintable token.
332   function createTokenContract() internal returns (MintableToken) {
333     return new MintableToken();
334   }
335 
336 
337   // fallback function can be used to buy tokens
338   function () payable {
339     buyTokens(msg.sender);
340   }
341 
342   // low level token purchase function
343   function buyTokens(address beneficiary) payable {
344     require(beneficiary != 0x0);
345     require(validPurchase());
346 
347     uint256 weiAmount = msg.value;
348 
349     // calculate token amount to be created
350     uint256 tokens = weiAmount.mul(rate);
351 
352     // update state
353     weiRaised = weiRaised.add(weiAmount);
354 
355     token.mint(beneficiary, tokens);
356     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
357 
358     forwardFunds();
359   }
360 
361   // send ether to the fund collection wallet
362   // override to create custom fund forwarding mechanisms
363   function forwardFunds() internal {
364     wallet.transfer(msg.value);
365   }
366 
367   // @return true if the transaction can buy tokens
368   function validPurchase() internal constant returns (bool) {
369     bool withinPeriod = now >= startTime && now <= endTime;
370     bool nonZeroPurchase = msg.value != 0;
371     return withinPeriod && nonZeroPurchase;
372   }
373 
374   // @return true if crowdsale event has ended
375   function hasEnded() public constant returns (bool) {
376     return now > endTime;
377   }
378 
379 
380 }
381 
382 /**
383  * @title CappedCrowdsale
384  * @dev Extension of Crowsdale with a max amount of funds raised
385  */
386 contract CappedCrowdsale is Crowdsale {
387   using SafeMath for uint256;
388 
389   uint256 public cap;
390 
391   function CappedCrowdsale(uint256 _cap) {
392     require(_cap > 0);
393     cap = _cap;
394   }
395 
396   // overriding Crowdsale#validPurchase to add extra cap logic
397   // @return true if investors can buy at the moment
398   function validPurchase() internal constant returns (bool) {
399     bool withinCap = weiRaised.add(msg.value) <= cap;
400     return super.validPurchase() && withinCap;
401   }
402 
403   // overriding Crowdsale#hasEnded to add cap logic
404   // @return true if crowdsale event has ended
405   function hasEnded() public constant returns (bool) {
406     bool capReached = weiRaised >= cap;
407     return super.hasEnded() || capReached;
408   }
409 
410 }
411 
412 /**
413  * @title FinalizableCrowdsale
414  * @dev Extension of Crowsdale where an owner can do extra work
415  * after finishing. 
416  */
417 contract FinalizableCrowdsale is Crowdsale, Ownable {
418   using SafeMath for uint256;
419 
420   bool public isFinalized = false;
421 
422   event Finalized();
423 
424   /**
425    * @dev Must be called after crowdsale ends, to do some extra finalization
426    * work. Calls the contract's finalization function.
427    */
428   function finalize() onlyOwner {
429     require(!isFinalized);
430     require(hasEnded());
431 
432     finalization();
433     Finalized();
434     
435     isFinalized = true;
436   }
437 
438   /**
439    * @dev Can be overriden to add finalization logic. The overriding function
440    * should call super.finalization() to ensure the chain of finalization is
441    * executed entirely.
442    */
443   function finalization() internal {
444   }
445 }
446 
447 
448 /**
449  * @title SampleCrowdsale
450  * @dev This is an example of a fully fledged crowdsale.
451  * The way to add new features to a base crowdsale is by multiple inheritance.
452  * In this example we are providing following extensions:
453  * CappedCrowdsale - sets a max boundary for raised funds
454  *
455  * After adding multiple features it's good practice to run integration tests
456  * to ensure that subcontracts works together as intended.
457  */
458 contract SampleCrowdsale is CappedCrowdsale,FinalizableCrowdsale {
459 
460   function SampleCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
461     CappedCrowdsale(_cap)
462     FinalizableCrowdsale()
463     Crowdsale(_startTime, _endTime, _rate, _wallet)
464   {
465     //As goal needs to be met for a successful crowdsale
466     //the value needs to less or equal than a cap which is limit for accepted funds
467     //require(_goal <= _cap);
468   }
469 
470   function createTokenContract() internal returns (MintableToken) {
471     return new SimpleToken();
472   }
473 
474 }