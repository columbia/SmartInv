1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 
76 contract CryptoAngelConstants {
77 
78   string constant TOKEN_NAME = "CryptoAngel";
79   string constant TOKEN_SYMBOL = "ANGEL";
80   uint constant TOKEN_DECIMALS = 18;
81   uint8 constant TOKEN_DECIMALS_UINT8 = uint8(TOKEN_DECIMALS);
82   uint constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
83 
84   uint constant TEAM_TOKENS =   18000000 * TOKEN_DECIMAL_MULTIPLIER;
85   uint constant HARD_CAP_TOKENS =   88000000 * TOKEN_DECIMAL_MULTIPLIER;
86   uint constant MINIMAL_PURCHASE = 0.05 ether;
87   uint constant RATE = 1000; // 1ETH = 1000ANGEL
88 
89   address constant TEAM_ADDRESS = 0x6941A0FD30198c70b3872D4d1b808e4bFc5A07E1;
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   uint256 public totalSupply;
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 }
152 
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) internal allowed;
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     require(_value > 0);
195     allowed[msg.sender][_spender] = _value;
196     Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public view returns (uint256) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    */
216   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223     uint oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue > oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 }
233 
234 
235 /**
236  * @title Mintable token
237  * @dev Simple ERC20 Token example, with mintable token creation
238  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
239  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
240  */
241 
242 contract MintableToken is StandardToken, Ownable {
243   event Mint(address indexed to, uint256 amount);
244   event MintFinished();
245 
246   bool public mintingFinished = false;
247 
248   modifier canMint() {
249     require(!mintingFinished);
250     _;
251   }
252 
253   /**
254    * @dev Function to mint tokens
255    * @param _to The address that will receive the minted tokens.
256    * @param _amount The amount of tokens to mint.
257    * @return A boolean that indicates if the operation was successful.
258    */
259   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
260     totalSupply = totalSupply.add(_amount);
261     balances[_to] = balances[_to].add(_amount);
262     Mint(_to, _amount);
263     Transfer(address(0), _to, _amount);
264     return true;
265   }
266 
267   /**
268    * @dev Function to stop minting new tokens.
269    * @return True if the operation was successful.
270    */
271   function finishMinting() onlyOwner canMint public returns (bool) {
272     mintingFinished = true;
273     MintFinished();
274     return true;
275   }
276 }
277 
278 /**
279  * @title Burnable Token
280  * @dev Token that can be irreversibly burned (destroyed).
281  */
282 contract BurnableToken is StandardToken {
283 
284     event Burn(address indexed burner, uint256 value);
285 
286   /**
287    * @dev Burns a specific amount of tokens.
288    * @param _value The amount of token to be burned.
289    */
290   function burn(uint256 _value) public {
291       require(_value > 0);
292       require(_value <= balances[msg.sender]);
293       // no need to require value <= totalSupply, since that would imply the
294       // sender's balance is greater than the totalSupply, which *should* be an assertion failure
295 
296       address burner = msg.sender;
297       balances[burner] = balances[burner].sub(_value);
298       totalSupply = totalSupply.sub(_value);
299       Burn(burner, _value);
300   }
301 
302   /**
303    * @dev Burn tokens from the specified address.
304    * @param _from address The address which you want to burn tokens from.
305    * @param _value uint The amount of tokens to be burned.
306    */
307   function burnFrom(address _from, uint256 _value) public returns (bool) {
308       require(_value > 0);
309       var allowance = allowed[_from][msg.sender];
310       require(allowance >= _value);
311       balances[_from] = balances[_from].sub(_value);
312       totalSupply = totalSupply.sub(_value);
313       allowed[_from][msg.sender] = allowance.sub(_value);
314       Burn(_from, _value);
315       return true;
316   }
317 }
318 
319 
320 contract CryptoAngel is CryptoAngelConstants, MintableToken, BurnableToken {
321 
322   mapping (address => bool) public frozenAccount;
323 
324   event FrozenFunds(address target, bool frozen);
325 
326   /**
327    * @param target Address to be frozen
328    * @param freeze either to freeze it or not
329    */
330   function freezeAccount(address target, bool freeze) public onlyOwner {
331       frozenAccount[target] = freeze;
332       FrozenFunds(target, freeze);
333   }
334     
335   /**
336    * @dev Returns token's name.
337    */
338   function name() pure public returns (string _name) {
339       return TOKEN_NAME;
340   }
341 
342   /**
343    * @dev Returns token's symbol.
344    */
345   function symbol() pure public returns (string _symbol) {
346       return TOKEN_SYMBOL;
347   }
348 
349   /**
350    * @dev Returns number of decimals.
351    */
352   function decimals() pure public returns (uint8 _decimals) {
353       return TOKEN_DECIMALS_UINT8;
354   }
355 
356   /**
357     * @dev Function to mint tokens
358     * @param _to The address that will receive the minted tokens.
359     * @param _amount The amount of tokens to mint.
360     * @return A boolean that indicates if the operation was successful.
361   */
362     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
363         require(!frozenAccount[_to]);
364         super.mint(_to, _amount);
365     }
366 
367     function transfer(address _to, uint256 _value) public returns (bool) {
368         require(!frozenAccount[msg.sender]);
369         return super.transfer(_to, _value);
370     }
371     
372     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
373         require(!frozenAccount[_from]);
374         require(!frozenAccount[_to]);
375         return super.transferFrom(_from, _to, _value);
376     }
377 }
378 
379 /**
380  * @title Crowdsale
381  * @dev Crowdsale is a base contract for managing a token crowdsale.
382  * Crowdsales have a start and end timestamps, where investors can make
383  * token purchases and the crowdsale will assign them tokens based
384  * on a token per ETH rate. Funds collected are forwarded to a wallet
385  * as they arrive.
386  */
387 contract Crowdsale is CryptoAngelConstants{
388   using SafeMath for uint256;
389 
390   // The token being sold
391   CryptoAngel public token;
392 
393   // start and end timestamps where investments are allowed (both inclusive)
394   uint256 public startTime;
395   uint256 public endTime;
396 
397   // address where funds are collected
398   address public wallet;
399 
400   // how many token units a buyer gets per wei
401   uint256 public rate;
402 
403   // amount of raised money in wei
404   uint256 public weiRaised;
405 
406   // maximum amount of tokens to mint.
407   uint public hardCap;
408 
409   /**
410    * event for token purchase logging
411    * @param purchaser who paid for the tokens
412    * @param beneficiary who got the tokens
413    * @param value weis paid for purchase
414    * @param amount amount of tokens purchased
415    */
416   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
417 
418 
419   function Crowdsale(uint256 _startTime, uint256 _endTime, address _wallet) public {
420     require(_startTime >= now);
421     require(_endTime >= _startTime);
422     require(_wallet != address(0));
423 
424     token = createTokenContract();
425     startTime = _startTime;
426     endTime = _endTime;
427     hardCap = HARD_CAP_TOKENS;
428     wallet = _wallet;
429     rate = RATE;
430   }
431 
432   // creates the token to be sold.
433   function createTokenContract() internal returns (CryptoAngel) {
434     return new CryptoAngel();
435   }
436 
437   // fallback function can be used to buy tokens
438   function() public payable {
439     buyTokens(msg.sender, msg.value);
440   }
441 
442   // low level token purchase function
443   function buyTokens(address beneficiary, uint256 weiAmount) internal {
444     require(beneficiary != address(0));
445     require(validPurchase(weiAmount, token.totalSupply()));
446 
447     // calculate token amount to be created
448     uint256 tokens = calculateTokens(token.totalSupply(), weiAmount);
449 
450     // update state
451     weiRaised = weiRaised.add(weiAmount);
452 
453     token.mint(beneficiary, tokens);
454     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
455 
456     forwardFunds(weiAmount);
457   }
458 
459   // @return number of tokens which should be created
460   function calculateTokens(uint256 totalTokens, uint256 weiAmount) internal view returns (uint256) {
461 
462     uint256 numOfTokens = weiAmount.mul(RATE);
463 
464     if (totalTokens <= hardCap.mul(30).div(100)) { // first 30% of available tokens
465         numOfTokens += numOfTokens.mul(30).div(100);
466     }
467     else if (totalTokens <= hardCap.mul(45).div(100)) { // 30-45% of available tokens
468         numOfTokens += numOfTokens.mul(20).div(100);
469     }
470     else if (totalTokens <= hardCap.mul(60).div(100)) { // 45-60% of available tokens
471         numOfTokens += numOfTokens.mul(10).div(100);
472     }  
473    return numOfTokens;
474   }
475 
476   // send ether to the fund collection wallet
477   // override to create custom fund forwarding mechanisms
478   function forwardFunds(uint amountWei) internal {
479     wallet.transfer(amountWei);
480   }
481 
482   // @return true if the transaction can buy tokens
483   function validPurchase(uint _amountWei, uint _totalSupply) internal view returns (bool) {
484     bool withinPeriod = now >= startTime && now <= endTime;
485     bool nonMinimalPurchase = _amountWei >= MINIMAL_PURCHASE;
486     bool hardCapNotReached = _totalSupply <= hardCap;
487     return withinPeriod && nonMinimalPurchase && hardCapNotReached;
488   }
489 
490   // @return true if crowdsale event has ended
491   function hasEnded() internal view returns (bool) {
492     return now > endTime;
493   }
494 }
495 
496 
497 /**
498  * @title FinalizableCrowdsale
499  * @dev Extension of Crowdsale where an owner can do extra work
500  * after finishing.
501  */
502 contract FinalizableCrowdsale is Crowdsale, Ownable {
503   using SafeMath for uint256;
504 
505   bool public isFinalized = false;
506 
507   event Finalized();
508 
509   function FinalizableCrowdsale(uint _startTime, uint _endTime, address _wallet) public
510             Crowdsale(_startTime, _endTime, _wallet) {
511     }
512 
513   /**
514    * @dev Must be called after crowdsale ends, to do some extra finalization
515    * work. Calls the contract's finalization function.
516    */
517   function finalize() onlyOwner public {
518     require(!isFinalized);
519     require(hasEnded());
520     isFinalized = true;
521     token.finishMinting();
522     token.transferOwnership(owner);
523     Finalized();
524   }
525 
526   modifier notFinalized() {
527     require(!isFinalized);
528     _;
529   }
530 }
531 
532 
533 contract CryptoAngelCrowdsale is CryptoAngelConstants, FinalizableCrowdsale {
534 
535     function CryptoAngelCrowdsale(
536             uint _startTime,
537             uint _endTime,
538             address _wallet
539     ) public
540         FinalizableCrowdsale(_startTime, _endTime, _wallet) {
541         token.mint(TEAM_ADDRESS, TEAM_TOKENS);
542     }
543 
544   /**
545    * @dev Allows the current owner to set the new start time if crowdsale is not finalized.
546    * @param _startTime new end time.
547    */
548     function setStartTime(uint256 _startTime) public onlyOwner notFinalized {
549         require(_startTime < endTime);
550         startTime = _startTime;
551     }
552 
553   /**
554    * @dev Allows the current owner to set the new end time if crowdsale is not finalized.
555    * @param _endTime new end time.
556    */
557     function setEndTime(uint256 _endTime) public onlyOwner notFinalized {
558         require(_endTime > startTime);
559         endTime = _endTime;
560     }
561 
562   /**
563    * @dev Allows the current owner to change the hard cap if crowdsale is not finalized.
564    * @param _hardCapTokens new hard cap.
565    */
566     function setHardCap(uint256 _hardCapTokens) public onlyOwner notFinalized {
567         require(_hardCapTokens * TOKEN_DECIMAL_MULTIPLIER > hardCap);
568         hardCap = _hardCapTokens * TOKEN_DECIMAL_MULTIPLIER;
569     }
570 }