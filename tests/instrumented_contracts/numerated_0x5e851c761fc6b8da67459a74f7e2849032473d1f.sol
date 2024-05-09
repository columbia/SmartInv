1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   uint256 totalSupply_;
72 
73   /**
74   * @dev total number of tokens in existence
75   */
76   function totalSupply() public view returns (uint256) {
77     return totalSupply_;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint256 _value) public returns (bool) {
86     require(_to != address(0));
87     require(_value <= balances[msg.sender]);
88 
89     // SafeMath.sub will throw if there is not enough balance.
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103   }
104 
105 }
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
118 /**
119  * @title Standard ERC20 token
120  *
121  * @dev Implementation of the basic standard token.
122  * @dev https://github.com/ethereum/EIPs/issues/20
123  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is ERC20, BasicToken {
126 
127   mapping (address => mapping (address => uint256)) internal allowed;
128 
129 
130   /**
131    * @dev Transfer tokens from one address to another
132    * @param _from address The address which you want to send tokens from
133    * @param _to address The address which you want to transfer to
134    * @param _value uint256 the amount of tokens to be transferred
135    */
136   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[_from]);
139     require(_value <= allowed[_from][msg.sender]);
140 
141     balances[_from] = balances[_from].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    *
151    * Beware that changing an allowance with this method brings the risk that someone may use both the old
152    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint256 _value) public returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Function to check the amount of tokens that an owner allowed to a spender.
166    * @param _owner address The address which owns the funds.
167    * @param _spender address The address which will spend the funds.
168    * @return A uint256 specifying the amount of tokens still available for the spender.
169    */
170   function allowance(address _owner, address _spender) public view returns (uint256) {
171     return allowed[_owner][_spender];
172   }
173 
174   /**
175    * @dev Increase the amount of tokens that an owner allowed to a spender.
176    *
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    * @param _spender The address which will spend the funds.
182    * @param _addedValue The amount of tokens to increase the allowance by.
183    */
184   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
186     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187     return true;
188   }
189 
190   /**
191    * @dev Decrease the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To decrement
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _subtractedValue The amount of tokens to decrease the allowance by.
199    */
200   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
201     uint oldValue = allowed[msg.sender][_spender];
202     if (_subtractedValue > oldValue) {
203       allowed[msg.sender][_spender] = 0;
204     } else {
205       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206     }
207     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211 }
212 
213 /**
214  * @title Burnable Token
215  * @dev Token that can be irreversibly burned (destroyed).
216  */
217 contract BurnableToken is BasicToken {
218 
219   event Burn(address indexed burner, uint256 value);
220 
221   /**
222    * @dev Burns a specific amount of tokens.
223    * @param _value The amount of token to be burned.
224    */
225   function burn(uint256 _value) public {
226     require(_value <= balances[msg.sender]);
227     // no need to require value <= totalSupply, since that would imply the
228     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
229 
230     address burner = msg.sender;
231     balances[burner] = balances[burner].sub(_value);
232     totalSupply_ = totalSupply_.sub(_value);
233     Burn(burner, _value);
234   }
235 }
236 
237 /**
238  * @title Ownable
239  * @dev The Ownable contract has an owner address, and provides basic authorization control
240  * functions, this simplifies the implementation of "user permissions".
241  */
242 contract Ownable {
243   address public owner;
244 
245 
246   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248 
249   /**
250    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
251    * account.
252    */
253   function Ownable() public {
254     owner = msg.sender;
255   }
256 
257   /**
258    * @dev Throws if called by any account other than the owner.
259    */
260   modifier onlyOwner() {
261     require(msg.sender == owner);
262     _;
263   }
264 
265   /**
266    * @dev Allows the current owner to transfer control of the contract to a newOwner.
267    * @param newOwner The address to transfer ownership to.
268    */
269   function transferOwnership(address newOwner) public onlyOwner {
270     require(newOwner != address(0));
271     OwnershipTransferred(owner, newOwner);
272     owner = newOwner;
273   }
274 
275 }
276 
277 /**
278  * @title Mintable token
279  * @dev Simple ERC20 Token example, with mintable token creation
280  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
281  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
282  */
283 contract MintableToken is StandardToken, Ownable {
284   event Mint(address indexed to, uint256 amount);
285   event MintFinished();
286 
287   bool public mintingFinished = false;
288 
289 
290   modifier canMint() {
291     require(!mintingFinished);
292     _;
293   }
294 
295   /**
296    * @dev Function to mint tokens
297    * @param _to The address that will receive the minted tokens.
298    * @param _amount The amount of tokens to mint.
299    * @return A boolean that indicates if the operation was successful.
300    */
301   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
302     totalSupply_ = totalSupply_.add(_amount);
303     balances[_to] = balances[_to].add(_amount);
304     Mint(_to, _amount);
305     Transfer(address(0), _to, _amount);
306     return true;
307   }
308 
309   /**
310    * @dev Function to stop minting new tokens.
311    * @return True if the operation was successful.
312    */
313   function finishMinting() onlyOwner canMint public returns (bool) {
314     mintingFinished = true;
315     MintFinished();
316     return true;
317   }
318 }
319 
320 /**
321  * @title Capped token
322  * @dev Mintable token with a token cap.
323  */
324 contract CappedToken is MintableToken {
325 
326   uint256 public cap;
327 
328   function CappedToken(uint256 _cap) public {
329     require(_cap > 0);
330     cap = _cap;
331   }
332 
333   /**
334    * @dev Function to mint tokens
335    * @param _to The address that will receive the minted tokens.
336    * @param _amount The amount of tokens to mint.
337    * @return A boolean that indicates if the operation was successful.
338    */
339   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
340     require(totalSupply_.add(_amount) <= cap);
341 
342     return super.mint(_to, _amount);
343   }
344 
345 }
346 
347 contract EMACToken is CappedToken, BurnableToken {
348 
349     string public constant name = "eMarketChain";
350     string public constant symbol = "EMAC";
351     uint8 public constant decimals = 18;
352 
353     function EMACToken(uint256 _cap) CappedToken(_cap) public {
354     }
355     
356     function burn(uint256 _value) public {
357         super.burn(_value);
358     }
359 }
360 
361 
362 /**
363  * @title Crowdsale
364  * @dev Crowdsale is a base contract for managing a token crowdsale.
365  * Crowdsales have a start and end timestamps, where investors can make
366  * token purchases and the crowdsale will assign them tokens based
367  * on a token per ETH rate. Funds collected are forwarded to a wallet
368  * as they arrive. The contract requires a MintableToken that will be
369  * minted as contributions arrive, note that the crowdsale contract
370  * must be owner of the token in order to be able to mint it.
371  */
372 contract EMACCrowdsale is Ownable {
373   using SafeMath for uint256;
374 
375   // The token being sold
376   EMACToken public token;
377 
378   // start and end timestamps where investments are allowed (both inclusive)
379   uint256 public startTime;
380   uint256 public endTime;
381 
382   // address where funds are collected
383   address public wallet;
384   
385   // Team, advisors etc. wallet
386   address public teamWallet;
387 
388   // how many token units a buyer gets per wei
389   uint256 public rate;
390 
391   // amount of raised money in wei
392   uint256 public weiRaised;
393   
394   // 454m
395   uint256 public constant INIT_TOKENS = 454 * (10 ** 6) * (10 ** 18);
396   
397   // 20% of tokens are going for the team, advisors etc.
398   uint256 public TEAM_TOKENS = INIT_TOKENS.mul(20).div(100);
399   
400   // 32000 eth
401   uint256 public constant HARD_CAP = 32000 * (10**18);
402   
403   // 18000 eth
404   uint256 public constant PRE_SALE_CAP = 18000 * (10**18);
405   
406   // set bonuses
407   uint256 public constant PRE_SALE_BONUS_PERCENTAGE = 120;
408   uint256 public constant MAIN_SALE_BONUS_PERCENTAGE_PHASE1 = 115;
409   uint256 public constant MAIN_SALE_BONUS_PERCENTAGE_PHASE2 = 110;
410   uint256 public constant MAIN_SALE_BONUS_PERCENTAGE_PHASE3 = 105;
411   uint256 public constant MAIN_SALE_BONUS_PERCENTAGE_PHASE4 = 100;
412   
413   /**
414    * event for token purchase logging
415    * @param purchaser who paid for the tokens
416    * @param beneficiary who got the tokens
417    * @param value weis paid for purchase
418    * @param amount amount of tokens purchased
419    */
420   event EMACTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
421 
422   function EMACCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _teamWallet) public {
423     require(_startTime >= now);
424     require(_endTime >= _startTime);
425     require(_rate > 0);
426     require(_wallet != address(0));
427     require(_teamWallet != address(0));
428 
429     startTime = _startTime;
430     endTime = _endTime;
431     rate = _rate;
432     wallet = _wallet;
433     token = new EMACToken(INIT_TOKENS);
434     teamWallet = _teamWallet;
435     
436     token.mint(_teamWallet, TEAM_TOKENS);
437     depositTokens();
438   }
439   
440   function depositTokens() public payable {
441     EMACTokenPurchase(msg.sender, teamWallet, msg.value, TEAM_TOKENS);
442   }
443 
444   // fallback function can be used to buy tokens
445   function () external payable {
446     buyTokens(msg.sender);
447   }
448 
449   // token purchase function
450   function buyTokens(address beneficiary) public payable {
451     require(beneficiary != address(0));
452     require(validPurchase());
453 
454     uint256 weiAmount = msg.value;
455 
456     // calculate token amount to be created
457     uint256 tokens = getTokenAmount(weiAmount);
458 
459     // update state
460     weiRaised = weiRaised.add(weiAmount);
461 
462     token.mint(beneficiary, tokens);
463     EMACTokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
464 
465     forwardFunds();
466   }
467   
468   function finalize() onlyOwner public {
469     require(hasEnded());
470 
471     uint256 unsoldTokens = INIT_TOKENS - token.totalSupply();
472 
473     // burn all unsold tokens
474     require(unsoldTokens > 0);
475     token.burn(unsoldTokens);
476   }
477 
478   // @return true if crowdsale event has ended
479   function hasEnded() public view returns (bool) {
480     return now > endTime;
481   }
482 
483   // Add token exchange bonus rate
484   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
485     uint256 tokenExchangeRate = MAIN_SALE_BONUS_PERCENTAGE_PHASE4;
486     uint256 convertToWei = (10**18);
487 
488     if (now <= (startTime + 14 days) && weiRaised <= PRE_SALE_CAP) {
489       tokenExchangeRate = PRE_SALE_BONUS_PERCENTAGE;
490     }
491     else if (now <= endTime && weiRaised <= HARD_CAP) {
492       if (weiRaised < 10000 * convertToWei) {
493         tokenExchangeRate = MAIN_SALE_BONUS_PERCENTAGE_PHASE1;
494       }
495       else if (weiRaised >= 10000 * convertToWei && weiRaised < 20000 * convertToWei) {
496         tokenExchangeRate = MAIN_SALE_BONUS_PERCENTAGE_PHASE2;
497       }
498       else if (weiRaised >= 20000 * convertToWei && weiRaised < 30000 * convertToWei) {
499         tokenExchangeRate = MAIN_SALE_BONUS_PERCENTAGE_PHASE3;
500       }
501     }
502 
503     uint256 bonusRate = rate.mul(tokenExchangeRate);
504     return weiAmount.mul(bonusRate).div(100);
505   }
506 
507   // send ether to the fund collection wallet
508   function forwardFunds() internal {
509     wallet.transfer(msg.value);
510   }
511 
512   // @return true if the transaction can buy tokens
513   function validPurchase() internal view returns (bool) {
514     bool withinPeriod = now >= startTime && now <= endTime;
515     bool nonZeroPurchase = msg.value != 0;
516     bool notReachedHardCap = weiRaised <= HARD_CAP;
517     return withinPeriod && nonZeroPurchase && notReachedHardCap;
518   }
519 }