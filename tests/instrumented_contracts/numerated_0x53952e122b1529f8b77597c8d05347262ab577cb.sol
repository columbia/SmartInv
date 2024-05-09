1 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
2  * SafeMath.sol so as to fix the code base and simplify compilation in Remix etc..
3  * with no external dependencies.
4  */
5  
6  pragma solidity ^0.4.18;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
55  * Ownable.sol so as to fix the code base and simplify compilation in Remix etc..
56  * with no external dependencies. 
57  */
58  
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 }
94 
95 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
96  * MintableToken.sol so as to fix the code base and simplify compilation in Remix etc..
97  * with no external dependencies. 
98  */
99 
100 /****************************************************************************************
101  * @title ERC20Basic
102  * @dev Simpler version of ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/179
104  */
105 contract ERC20Basic {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 /***************************************************************************************
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /***************************************************************************************
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return balances[_owner];
164   }
165 }
166 
167 /***************************************************************************************
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
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 }
259 
260 /***************************************************************************************
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 contract MintableToken is StandardToken, Ownable {
267   event Mint(address indexed to, uint256 amount);
268   event MintFinished();
269 
270   bool public mintingFinished = false;
271 
272   modifier canMint() {
273     require(!mintingFinished);
274     _;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
284     totalSupply_ = totalSupply_.add(_amount);
285     balances[_to] = balances[_to].add(_amount);
286     Mint(_to, _amount);
287     Transfer(address(0), _to, _amount);
288     return true;
289   }
290 
291   /**
292    * @dev Function to stop minting new tokens.
293    * @return True if the operation was successful.
294    */
295   function finishMinting() onlyOwner canMint public returns (bool) {
296     mintingFinished = true;
297     MintFinished();
298     return true;
299   }
300 }
301 
302 contract SovToken is MintableToken {
303   string public name = "Sovereign";
304   string public symbol = "SVT";
305   uint256 public decimals = 18;
306 
307   uint256 private _tradeableDate = now;
308   
309   //please update the following addresses before deployment
310   address private constant CONVERT_ADDRESS = 0x9376B2Ff3E68Be533bAD507D99aaDAe7180A8175; 
311   address private constant POOL = 0xE06be458ad8E80d8b8f198579E0Aa0Ce5f571294;
312   
313   event Burn(address indexed burner, uint256 value);
314 
315   function SovToken(uint256 tradeDate) public
316   {
317     _tradeableDate = tradeDate;
318   }
319 
320   function transfer(address _to, uint256 _value) public returns (bool) 
321   {
322     require(_to != address(0));
323     require(_value <= balances[msg.sender]);
324     
325     // reject transaction if the transfer is before tradeable date and
326     // the transfer is not from or to the pool
327     require(now > _tradeableDate || _to == POOL || msg.sender == POOL);
328     
329     // if the transfer address is the conversion address - burn the tokens
330     if (_to == CONVERT_ADDRESS)
331     {   
332         address burner = msg.sender;
333         balances[burner] = balances[burner].sub(_value);
334         totalSupply_ = totalSupply_.sub(_value);
335         Burn(burner, _value);
336         Transfer(msg.sender, _to, _value);
337         return true;
338     }
339     else
340     {
341         balances[msg.sender] = balances[msg.sender].sub(_value);
342         balances[_to] = balances[_to].add(_value);
343         Transfer(msg.sender, _to, _value);
344         return true;
345     }
346   }
347 }
348 
349 /* This file is a flattened version of OpenZeppelin (https://github.com/OpenZeppelin) 
350  * Crowdsale.sol so as to fix the code base and simplify compilation in Remix etc..
351  * with no external dependencies. 
352  */
353 
354 /**
355  * @title Crowdsale
356  * @dev Crowdsale is a base contract for managing a token crowdsale.
357  * Crowdsales have a start and end timestamps, where investors can make
358  * token purchases and the crowdsale will assign them tokens based
359  * on a token per ETH rate. Funds collected are forwarded to a wallet
360  * as they arrive. The contract requires a MintableToken that will be
361  * minted as contributions arrive, note that the crowdsale contract
362  * must be owner of the token in order to be able to mint it.
363  */
364 contract Crowdsale {
365   using SafeMath for uint256;
366 
367   // The token being sold
368   MintableToken public token;
369 
370   // start and end timestamps where investments are allowed (both inclusive)
371   uint256 public startTime;
372   uint256 public endTime;
373 
374   // address where funds are collected
375   address public wallet;
376 
377   // how many token units a buyer gets per wei
378   uint256 public rate;
379 
380   // amount of raised money in wei
381   uint256 public weiRaised;
382 
383   /**
384    * event for token purchase logging
385    * @param purchaser who paid for the tokens
386    * @param beneficiary who got the tokens
387    * @param value weis paid for purchase
388    * @param amount amount of tokens purchased
389    */
390   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
391 
392 
393   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, MintableToken _token) public {
394     require(_startTime >= now);
395     require(_endTime >= _startTime);
396     require(_rate > 0);
397     require(_wallet != address(0));
398     require(_token != address(0));
399 
400     startTime = _startTime;
401     endTime = _endTime;
402     rate = _rate;
403     wallet = _wallet;
404     token = _token;
405   }
406 
407   // fallback function can be used to buy tokens
408   function () external payable {
409     buyTokens(msg.sender);
410   }
411 
412   // low level token purchase function
413   function buyTokens(address beneficiary) public payable {
414     require(beneficiary != address(0));
415     require(validPurchase());
416 
417     uint256 weiAmount = msg.value;
418 
419     // calculate token amount to be created
420     uint256 tokens = getTokenAmount(weiAmount);
421 
422     // update state
423     weiRaised = weiRaised.add(weiAmount);
424 
425     token.mint(beneficiary, tokens);
426     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
427 
428     forwardFunds();
429   }
430 
431   // @return true if crowdsale event has ended
432   function hasEnded() public view returns (bool) {
433     return now > endTime;
434   }
435 
436   // Override this method to have a way to add business logic to your crowdsale when buying
437   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
438     return weiAmount.mul(rate);
439   }
440 
441   // send ether to the fund collection wallet
442   // override to create custom fund forwarding mechanisms
443   function forwardFunds() internal {
444     wallet.transfer(msg.value);
445   }
446 
447   // @return true if the transaction can buy tokens
448   function validPurchase() internal view returns (bool) {
449     bool withinPeriod = now >= startTime && now <= endTime;
450     bool nonZeroPurchase = msg.value != 0;
451     return withinPeriod && nonZeroPurchase;
452   }
453 }
454 
455 contract SovTokenCrowdsale is Crowdsale {
456   uint private constant TIME_UNIT = 86400;    // in seconds - set at 60 (1 min) for testing and change to 86400 (1 day) for release
457   uint private constant TOTAL_TIME = 91;
458   uint private constant RATE = 1000;
459   uint256 private constant START_TIME = 1519128000;
460   uint256 private constant HARD_CAP = 100000*1000000000000000000;    // in wei - 100K Eth
461   
462   //please update the following addresses before deployment
463   address private constant WALLET = 0x04Fb0BbC4f95F5681138502094f8FD570AA2CB9F;
464   address private constant POOL = 0xE06be458ad8E80d8b8f198579E0Aa0Ce5f571294;
465 
466   function SovTokenCrowdsale() public
467         Crowdsale(START_TIME, START_TIME + (TIME_UNIT * TOTAL_TIME), RATE, WALLET, new SovToken(START_TIME + (TIME_UNIT * TOTAL_TIME)))
468   {    }
469   
470   // low level token purchase function
471   function buyTokens(address beneficiary) public payable 
472   {
473     require(beneficiary != address(0));
474     require(validPurchase());
475     
476     uint256 weiAmount = msg.value;
477 
478     // validate if hardcap reached
479     require(weiRaised.add(weiAmount) < HARD_CAP);
480 
481     // calculate token amount to be created
482     uint256 tokens = getTokenAmount(weiAmount);
483 
484     // update state
485     weiRaised = weiRaised.add(weiAmount);
486 
487     token.mint(beneficiary, tokens);
488     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
489 
490     // for every token given away, half a token is minted to the treasury pool
491     token.mint(POOL, tokens/2);
492 
493     forwardFunds();
494   }
495 
496   // Overriden to calculate bonuses
497   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) 
498   {
499     uint256 tokens =  weiAmount.mul(rate);
500     uint256 bonus = 100;
501 
502     // determine bonus according to pre-sale period age
503     if (now >= endTime)
504       bonus = 0;
505     else if (now <= startTime + (7 * TIME_UNIT))
506       bonus += 75;
507     else if (now <= startTime + (14 * TIME_UNIT))
508       bonus += 65;
509     else if (now <= startTime + (21 * TIME_UNIT))
510       bonus += 55;
511     else if (now <= startTime + (28 * TIME_UNIT))
512       bonus += 45;
513     else if (now <= startTime + (39 * TIME_UNIT))
514       bonus += 35;
515     else if (now <= startTime + (70 * TIME_UNIT))
516       bonus = 0;
517     else if (now <= startTime + (77 * TIME_UNIT))
518       bonus += 10;
519     else if (now <= startTime + (84 * TIME_UNIT))
520       bonus += 5;
521     else
522       bonus = 100;
523 
524     tokens = tokens * bonus / 100;
525 
526     bonus = 100;
527     
528     //determine applicable amount bonus
529     // 1 - 10 ETH 10%, >10 ETH 20%
530     if (weiAmount >= 1000000000000000000 && weiAmount < 10000000000000000000)
531       bonus += 10;
532     else if (weiAmount >= 10000000000000000000)
533       bonus += 20;
534 
535     tokens = tokens * bonus / 100;
536       
537     return tokens;
538   }  
539   
540   
541   // @return true if the transaction can buy tokens
542   function validPurchase() internal view returns (bool) 
543   {
544       bool isPreSale = now >= startTime && now <= startTime + (39 * TIME_UNIT);
545       bool isIco = now > startTime + (70 * TIME_UNIT) && now <= endTime;
546       bool withinPeriod = isPreSale || isIco;
547       bool nonZeroPurchase = msg.value != 0;
548       return withinPeriod && nonZeroPurchase;
549   }
550 }