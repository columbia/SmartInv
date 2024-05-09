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
243 /**
244  * @title FinalizableCrowdsale
245  * @dev Extension of Crowdsale where an owner can do extra work
246  * after finishing.
247  */
248 contract FinalizableCrowdsale is Crowdsale, Ownable {
249   using SafeMath for uint256;
250 
251   bool public isFinalized = false;
252 
253   event Finalized();
254 
255   /**
256    * @dev Must be called after crowdsale ends, to do some extra finalization
257    * work. Calls the contract's finalization function.
258    */
259   function finalize() onlyOwner public {
260     require(!isFinalized);
261     require(hasEnded());
262 
263     finalization();
264     Finalized();
265 
266     isFinalized = true;
267   }
268 
269   /**
270    * @dev Can be overridden to add finalization logic. The overriding function
271    * should call super.finalization() to ensure the chain of finalization is
272    * executed entirely.
273    */
274   function finalization() internal {
275   }
276 }
277 
278 
279 
280 
281 
282 
283 
284 
285 
286 
287 
288 
289 
290 
291 /**
292  * @title Basic token
293  * @dev Basic version of StandardToken, with no allowances.
294  */
295 contract BasicToken is ERC20Basic {
296   using SafeMath for uint256;
297 
298   mapping(address => uint256) balances;
299 
300   /**
301   * @dev transfer token for a specified address
302   * @param _to The address to transfer to.
303   * @param _value The amount to be transferred.
304   */
305   function transfer(address _to, uint256 _value) public returns (bool) {
306     require(_to != address(0));
307     require(_value <= balances[msg.sender]);
308 
309     // SafeMath.sub will throw if there is not enough balance.
310     balances[msg.sender] = balances[msg.sender].sub(_value);
311     balances[_to] = balances[_to].add(_value);
312     Transfer(msg.sender, _to, _value);
313     return true;
314   }
315 
316   /**
317   * @dev Gets the balance of the specified address.
318   * @param _owner The address to query the the balance of.
319   * @return An uint256 representing the amount owned by the passed address.
320   */
321   function balanceOf(address _owner) public view returns (uint256 balance) {
322     return balances[_owner];
323   }
324 
325 }
326 
327 
328 
329 
330 
331 
332 
333 /**
334  * @title ERC20 interface
335  * @dev see https://github.com/ethereum/EIPs/issues/20
336  */
337 contract ERC20 is ERC20Basic {
338   function allowance(address owner, address spender) public view returns (uint256);
339   function transferFrom(address from, address to, uint256 value) public returns (bool);
340   function approve(address spender, uint256 value) public returns (bool);
341   event Approval(address indexed owner, address indexed spender, uint256 value);
342 }
343 
344 
345 
346 /**
347  * @title Standard ERC20 token
348  *
349  * @dev Implementation of the basic standard token.
350  * @dev https://github.com/ethereum/EIPs/issues/20
351  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
352  */
353 contract StandardToken is ERC20, BasicToken {
354 
355   mapping (address => mapping (address => uint256)) internal allowed;
356 
357 
358   /**
359    * @dev Transfer tokens from one address to another
360    * @param _from address The address which you want to send tokens from
361    * @param _to address The address which you want to transfer to
362    * @param _value uint256 the amount of tokens to be transferred
363    */
364   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
365     require(_to != address(0));
366     require(_value <= balances[_from]);
367     require(_value <= allowed[_from][msg.sender]);
368 
369     balances[_from] = balances[_from].sub(_value);
370     balances[_to] = balances[_to].add(_value);
371     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
372     Transfer(_from, _to, _value);
373     return true;
374   }
375 
376   /**
377    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
378    *
379    * Beware that changing an allowance with this method brings the risk that someone may use both the old
380    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
381    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
382    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
383    * @param _spender The address which will spend the funds.
384    * @param _value The amount of tokens to be spent.
385    */
386   function approve(address _spender, uint256 _value) public returns (bool) {
387     allowed[msg.sender][_spender] = _value;
388     Approval(msg.sender, _spender, _value);
389     return true;
390   }
391 
392   /**
393    * @dev Function to check the amount of tokens that an owner allowed to a spender.
394    * @param _owner address The address which owns the funds.
395    * @param _spender address The address which will spend the funds.
396    * @return A uint256 specifying the amount of tokens still available for the spender.
397    */
398   function allowance(address _owner, address _spender) public view returns (uint256) {
399     return allowed[_owner][_spender];
400   }
401 
402   /**
403    * @dev Increase the amount of tokens that an owner allowed to a spender.
404    *
405    * approve should be called when allowed[_spender] == 0. To increment
406    * allowed value is better to use this function to avoid 2 calls (and wait until
407    * the first transaction is mined)
408    * From MonolithDAO Token.sol
409    * @param _spender The address which will spend the funds.
410    * @param _addedValue The amount of tokens to increase the allowance by.
411    */
412   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
413     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
414     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418   /**
419    * @dev Decrease the amount of tokens that an owner allowed to a spender.
420    *
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    */
428   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
429     uint oldValue = allowed[msg.sender][_spender];
430     if (_subtractedValue > oldValue) {
431       allowed[msg.sender][_spender] = 0;
432     } else {
433       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
434     }
435     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
436     return true;
437   }
438 
439 }
440 
441 
442 
443 
444 
445 
446 
447 
448 /**
449  * @title Pausable
450  * @dev Base contract which allows children to implement an emergency stop mechanism.
451  */
452 contract Pausable is Ownable {
453   event Pause();
454   event Unpause();
455 
456   bool public paused = false;
457 
458 
459   /**
460    * @dev Modifier to make a function callable only when the contract is not paused.
461    */
462   modifier whenNotPaused() {
463     require(!paused);
464     _;
465   }
466 
467   /**
468    * @dev Modifier to make a function callable only when the contract is paused.
469    */
470   modifier whenPaused() {
471     require(paused);
472     _;
473   }
474 
475   /**
476    * @dev called by the owner to pause, triggers stopped state
477    */
478   function pause() onlyOwner whenNotPaused public {
479     paused = true;
480     Pause();
481   }
482 
483   /**
484    * @dev called by the owner to unpause, returns to normal state
485    */
486   function unpause() onlyOwner whenPaused public {
487     paused = false;
488     Unpause();
489   }
490 }
491 
492 
493 
494 
495 
496 
497 
498 
499 
500 /**
501  * @title Mintable token
502  * @dev Simple ERC20 Token example, with mintable token creation
503  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
504  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
505  */
506 
507 contract MintableToken is StandardToken, Ownable {
508   event Mint(address indexed to, uint256 amount);
509   event MintFinished();
510 
511   bool public mintingFinished = false;
512 
513 
514   modifier canMint() {
515     require(!mintingFinished);
516     _;
517   }
518 
519   /**
520    * @dev Function to mint tokens
521    * @param _to The address that will receive the minted tokens.
522    * @param _amount The amount of tokens to mint.
523    * @return A boolean that indicates if the operation was successful.
524    */
525   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
526     totalSupply = totalSupply.add(_amount);
527     balances[_to] = balances[_to].add(_amount);
528     Mint(_to, _amount);
529     Transfer(address(0), _to, _amount);
530     return true;
531   }
532 
533   /**
534    * @dev Function to stop minting new tokens.
535    * @return True if the operation was successful.
536    */
537   function finishMinting() onlyOwner canMint public returns (bool) {
538     mintingFinished = true;
539     MintFinished();
540     return true;
541   }
542 }
543 
544 
545 
546 /// @title LIX - Crowdfunding code for the Xpress Project
547 /// @author Medwhat
548 contract LIXToken is MintableToken {
549     using SafeMath for uint;
550     string public constant name = "LIX Token";
551     string public constant symbol = "LIX";
552     uint public constant decimals = 18;
553 }
554 
555 /// @title LIXPrivatePresale Implementation for LIX project - SolidChain.org
556 contract LIXPrivatePresale is CappedCrowdsale, FinalizableCrowdsale {
557 
558     uint256 public maximumTokenSupply;
559     address public tokenOwner;
560     address public wallet;
561 
562     struct Investor {
563         bool isWhitelisted;
564         uint contribution;
565         string name;
566         string email;
567     }
568     
569     mapping (address => Investor) investors;
570     address[] public investorAccounts;
571 
572     function LIXPrivatePresale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _tokenOwner, address _wallet, address _tokenAddress)
573     CappedCrowdsale(_cap)
574     FinalizableCrowdsale()
575     Crowdsale(_startTime, _endTime, _rate, _wallet)
576     {
577         //As goal needs to be met for a successful crowdsale
578         //the value needs to less or equal than a cap which is limit for accepted funds
579         require(_goal <= _cap);
580         require(_tokenOwner != 0x0);
581         maximumTokenSupply = _cap.mul(_rate);
582         tokenOwner = _tokenOwner;
583         wallet = _wallet;
584         token = createTokenContract(_tokenAddress);
585     }
586 
587     function createTokenContract(address tokenAddress) internal returns (MintableToken) {
588         return LIXToken(tokenAddress);
589     }
590 
591     function buyTokens(address beneficiary) payable {
592         require(beneficiary != 0x0);
593         require(validPurchase());
594         require(isWhitelistedInvestor(beneficiary));
595         uint256 weiAmount = msg.value;
596         // set investor
597         var investor = investors[beneficiary];
598         // calculate token amount to be created
599         // if investor contribution is greater than 20eth sendout more tokens
600         uint256 tokens;
601         if(weiAmount>=20000000000000000000)
602             tokens = weiAmount.mul(20);
603         else
604             tokens = weiAmount.mul(rate);
605         // update state
606         weiRaised = weiRaised.add(weiAmount);
607         // get investor contribution, if any and add to current contribution
608         investor.contribution = investor.contribution.add(weiAmount);
609         // mint the token
610         token.mint(beneficiary, tokens);
611         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
612         forwardFunds();
613     }
614 
615     function whitelistInvestor(address _address, string name, string email) onlyOwner public{
616         var investor = investors[_address];
617         investor.isWhitelisted = true;
618         investor.name = name;
619         investor.email = email; 
620         investorAccounts.push(_address) -1;
621     }
622 
623     function blacklistInvestor(address _address) onlyOwner public{
624         var investor = investors[_address];
625         investor.isWhitelisted = false;
626     }
627 
628     function getInvestors() view public returns(address[]){
629         return investorAccounts;
630     }
631 
632     function getInvestorInfo(address _address) view public returns(bool, uint, string, string){
633         var investor = investors[_address];
634         return (investor.isWhitelisted, investor.contribution, investor.name, investor.email);
635     }
636 
637     function getInvestorContribution(address _address) view public returns(uint){
638         return investors[_address].contribution;
639     }
640 
641     function isWhitelistedInvestor(address _address) public constant returns(bool result){
642         return investors[_address].isWhitelisted;
643     }
644 
645     function totalInvestors() view public returns (uint) {
646         return investorAccounts.length;
647     }
648 
649     function finalization() internal {
650         token.transferOwnership(tokenOwner);
651     }
652 
653     // @return true if crowdsale event has started
654     function hasStarted() public constant returns (bool) {
655         return now > startTime;
656     }
657 }