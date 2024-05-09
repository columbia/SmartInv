1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/SkillChainContributions.sol
94 
95 contract SkillChainContributions is Ownable {
96     using SafeMath for uint256;
97 
98     mapping(address => uint256) public tokenBalances;
99     address[] public addresses;
100 
101     function SkillChainContributions() public {}
102 
103     function addBalance(address _address, uint256 _tokenAmount) onlyOwner public {
104         require(_tokenAmount > 0);
105 
106         if (tokenBalances[_address] == 0) {
107             addresses.push(_address);
108         }
109         tokenBalances[_address] = tokenBalances[_address].add(_tokenAmount);
110     }
111 
112     function getContributorsLength() view public returns (uint) {
113         return addresses.length;
114     }
115 }
116 
117 // File: contracts/ApproveAndCallFallBack.sol
118 
119 contract ApproveAndCallFallBack {
120     function receiveApproval(
121         address from,
122         uint256 tokens,
123         address token,
124         bytes data) public;
125 }
126 
127 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
128 
129 /**
130  * @title ERC20Basic
131  * @dev Simpler version of ERC20 interface
132  * @dev see https://github.com/ethereum/EIPs/issues/179
133  */
134 contract ERC20Basic {
135   function totalSupply() public view returns (uint256);
136   function balanceOf(address who) public view returns (uint256);
137   function transfer(address to, uint256 value) public returns (bool);
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) balances;
151 
152   uint256 totalSupply_;
153 
154   /**
155   * @dev total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[msg.sender]);
169 
170     // SafeMath.sub will throw if there is not enough balance.
171     balances[msg.sender] = balances[msg.sender].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     Transfer(msg.sender, _to, _value);
174     return true;
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of.
180   * @return An uint256 representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) public view returns (uint256 balance) {
183     return balances[_owner];
184   }
185 
186 }
187 
188 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
189 
190 /**
191  * @title Burnable Token
192  * @dev Token that can be irreversibly burned (destroyed).
193  */
194 contract BurnableToken is BasicToken {
195 
196   event Burn(address indexed burner, uint256 value);
197 
198   /**
199    * @dev Burns a specific amount of tokens.
200    * @param _value The amount of token to be burned.
201    */
202   function burn(uint256 _value) public {
203     require(_value <= balances[msg.sender]);
204     // no need to require value <= totalSupply, since that would imply the
205     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
206 
207     address burner = msg.sender;
208     balances[burner] = balances[burner].sub(_value);
209     totalSupply_ = totalSupply_.sub(_value);
210     Burn(burner, _value);
211   }
212 }
213 
214 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
215 
216 /**
217  * @title ERC20 interface
218  * @dev see https://github.com/ethereum/EIPs/issues/20
219  */
220 contract ERC20 is ERC20Basic {
221   function allowance(address owner, address spender) public view returns (uint256);
222   function transferFrom(address from, address to, uint256 value) public returns (bool);
223   function approve(address spender, uint256 value) public returns (bool);
224   event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
228 
229 contract DetailedERC20 is ERC20 {
230   string public name;
231   string public symbol;
232   uint8 public decimals;
233 
234   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
235     name = _name;
236     symbol = _symbol;
237     decimals = _decimals;
238   }
239 }
240 
241 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
242 
243 /**
244  * @title Standard ERC20 token
245  *
246  * @dev Implementation of the basic standard token.
247  * @dev https://github.com/ethereum/EIPs/issues/20
248  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
249  */
250 contract StandardToken is ERC20, BasicToken {
251 
252   mapping (address => mapping (address => uint256)) internal allowed;
253 
254 
255   /**
256    * @dev Transfer tokens from one address to another
257    * @param _from address The address which you want to send tokens from
258    * @param _to address The address which you want to transfer to
259    * @param _value uint256 the amount of tokens to be transferred
260    */
261   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
262     require(_to != address(0));
263     require(_value <= balances[_from]);
264     require(_value <= allowed[_from][msg.sender]);
265 
266     balances[_from] = balances[_from].sub(_value);
267     balances[_to] = balances[_to].add(_value);
268     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269     Transfer(_from, _to, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    *
276    * Beware that changing an allowance with this method brings the risk that someone may use both the old
277    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280    * @param _spender The address which will spend the funds.
281    * @param _value The amount of tokens to be spent.
282    */
283   function approve(address _spender, uint256 _value) public returns (bool) {
284     allowed[msg.sender][_spender] = _value;
285     Approval(msg.sender, _spender, _value);
286     return true;
287   }
288 
289   /**
290    * @dev Function to check the amount of tokens that an owner allowed to a spender.
291    * @param _owner address The address which owns the funds.
292    * @param _spender address The address which will spend the funds.
293    * @return A uint256 specifying the amount of tokens still available for the spender.
294    */
295   function allowance(address _owner, address _spender) public view returns (uint256) {
296     return allowed[_owner][_spender];
297   }
298 
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    *
302    * approve should be called when allowed[_spender] == 0. To increment
303    * allowed value is better to use this function to avoid 2 calls (and wait until
304    * the first transaction is mined)
305    * From MonolithDAO Token.sol
306    * @param _spender The address which will spend the funds.
307    * @param _addedValue The amount of tokens to increase the allowance by.
308    */
309   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
310     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
311     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315   /**
316    * @dev Decrease the amount of tokens that an owner allowed to a spender.
317    *
318    * approve should be called when allowed[_spender] == 0. To decrement
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _subtractedValue The amount of tokens to decrease the allowance by.
324    */
325   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
326     uint oldValue = allowed[msg.sender][_spender];
327     if (_subtractedValue > oldValue) {
328       allowed[msg.sender][_spender] = 0;
329     } else {
330       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
331     }
332     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333     return true;
334   }
335 
336 }
337 
338 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
339 
340 /**
341  * @title Mintable token
342  * @dev Simple ERC20 Token example, with mintable token creation
343  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
344  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
345  */
346 contract MintableToken is StandardToken, Ownable {
347   event Mint(address indexed to, uint256 amount);
348   event MintFinished();
349 
350   bool public mintingFinished = false;
351 
352 
353   modifier canMint() {
354     require(!mintingFinished);
355     _;
356   }
357 
358   /**
359    * @dev Function to mint tokens
360    * @param _to The address that will receive the minted tokens.
361    * @param _amount The amount of tokens to mint.
362    * @return A boolean that indicates if the operation was successful.
363    */
364   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
365     totalSupply_ = totalSupply_.add(_amount);
366     balances[_to] = balances[_to].add(_amount);
367     Mint(_to, _amount);
368     Transfer(address(0), _to, _amount);
369     return true;
370   }
371 
372   /**
373    * @dev Function to stop minting new tokens.
374    * @return True if the operation was successful.
375    */
376   function finishMinting() onlyOwner canMint public returns (bool) {
377     mintingFinished = true;
378     MintFinished();
379     return true;
380   }
381 }
382 
383 // File: contracts/SkillChainToken.sol
384 
385 contract SkillChainToken is DetailedERC20, MintableToken, BurnableToken {
386 
387     modifier canTransfer() {
388         require(mintingFinished);
389         _;
390     }
391 
392     function SkillChainToken() DetailedERC20("Skillchain", "SKI", 18) public {}
393 
394     function transfer(address _to, uint _value) canTransfer public returns (bool) {
395         return super.transfer(_to, _value);
396     }
397 
398     function transferFrom(address _from, address _to, uint _value) canTransfer public returns (bool) {
399         return super.transferFrom(_from, _to, _value);
400     }
401 
402     function approveAndCall(address _spender, uint256 _tokens, bytes _data) public returns (bool success) {
403         approve(_spender, _tokens);
404         ApproveAndCallFallBack(_spender).receiveApproval(
405             msg.sender,
406             _tokens,
407             this,
408             _data
409         );
410         return true;
411     }
412 
413     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
414         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
415     }
416 }
417 
418 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
419 
420 /**
421  * @title Crowdsale
422  * @dev Crowdsale is a base contract for managing a token crowdsale.
423  * Crowdsales have a start and end timestamps, where investors can make
424  * token purchases and the crowdsale will assign them tokens based
425  * on a token per ETH rate. Funds collected are forwarded to a wallet
426  * as they arrive.
427  */
428 contract Crowdsale {
429   using SafeMath for uint256;
430 
431   // The token being sold
432   MintableToken public token;
433 
434   // start and end timestamps where investments are allowed (both inclusive)
435   uint256 public startTime;
436   uint256 public endTime;
437 
438   // address where funds are collected
439   address public wallet;
440 
441   // how many token units a buyer gets per wei
442   uint256 public rate;
443 
444   // amount of raised money in wei
445   uint256 public weiRaised;
446 
447   /**
448    * event for token purchase logging
449    * @param purchaser who paid for the tokens
450    * @param beneficiary who got the tokens
451    * @param value weis paid for purchase
452    * @param amount amount of tokens purchased
453    */
454   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
455 
456 
457   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
458     require(_startTime >= now);
459     require(_endTime >= _startTime);
460     require(_rate > 0);
461     require(_wallet != address(0));
462 
463     token = createTokenContract();
464     startTime = _startTime;
465     endTime = _endTime;
466     rate = _rate;
467     wallet = _wallet;
468   }
469 
470   // fallback function can be used to buy tokens
471   function () external payable {
472     buyTokens(msg.sender);
473   }
474 
475   // low level token purchase function
476   function buyTokens(address beneficiary) public payable {
477     require(beneficiary != address(0));
478     require(validPurchase());
479 
480     uint256 weiAmount = msg.value;
481 
482     // calculate token amount to be created
483     uint256 tokens = getTokenAmount(weiAmount);
484 
485     // update state
486     weiRaised = weiRaised.add(weiAmount);
487 
488     token.mint(beneficiary, tokens);
489     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
490 
491     forwardFunds();
492   }
493 
494   // @return true if crowdsale event has ended
495   function hasEnded() public view returns (bool) {
496     return now > endTime;
497   }
498 
499   // creates the token to be sold.
500   // override this method to have crowdsale of a specific mintable token.
501   function createTokenContract() internal returns (MintableToken) {
502     return new MintableToken();
503   }
504 
505   // Override this method to have a way to add business logic to your crowdsale when buying
506   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
507     return weiAmount.mul(rate);
508   }
509 
510   // send ether to the fund collection wallet
511   // override to create custom fund forwarding mechanisms
512   function forwardFunds() internal {
513     wallet.transfer(msg.value);
514   }
515 
516   // @return true if the transaction can buy tokens
517   function validPurchase() internal view returns (bool) {
518     bool withinPeriod = now >= startTime && now <= endTime;
519     bool nonZeroPurchase = msg.value != 0;
520     return withinPeriod && nonZeroPurchase;
521   }
522 
523 }
524 
525 // File: zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol
526 
527 /**
528  * @title CappedCrowdsale
529  * @dev Extension of Crowdsale with a max amount of funds raised
530  */
531 contract CappedCrowdsale is Crowdsale {
532   using SafeMath for uint256;
533 
534   uint256 public cap;
535 
536   function CappedCrowdsale(uint256 _cap) public {
537     require(_cap > 0);
538     cap = _cap;
539   }
540 
541   // overriding Crowdsale#hasEnded to add cap logic
542   // @return true if crowdsale event has ended
543   function hasEnded() public view returns (bool) {
544     bool capReached = weiRaised >= cap;
545     return capReached || super.hasEnded();
546   }
547 
548   // overriding Crowdsale#validPurchase to add extra cap logic
549   // @return true if investors can buy at the moment
550   function validPurchase() internal view returns (bool) {
551     bool withinCap = weiRaised.add(msg.value) <= cap;
552     return withinCap && super.validPurchase();
553   }
554 
555 }
556 
557 // File: contracts/SkillChainPresale.sol
558 
559 contract SkillChainPresale is CappedCrowdsale, Ownable {
560 
561     SkillChainContributions public contributions;
562 
563     uint256 public minimumContribution = 1 ether;
564 
565     function SkillChainPresale(
566         uint256 _startTime,
567         uint256 _endTime,
568         uint256 _rate,
569         address _wallet,
570         uint256 _cap,
571         address _token,
572         address _contributions
573     )
574     CappedCrowdsale(_cap)
575     Crowdsale(_startTime, _endTime, _rate, _wallet)
576     public
577     {
578         token = SkillChainToken(_token);
579         contributions = SkillChainContributions(_contributions);
580     }
581 
582     // low level token purchase function
583     function buyTokens(address beneficiary) public payable {
584         require(beneficiary != address(0));
585         require(validPurchase());
586 
587         uint256 weiAmount = msg.value;
588 
589         // calculate token amount to be created
590         uint256 tokens = getTokenAmount(weiAmount);
591 
592         // update state
593         weiRaised = weiRaised.add(weiAmount);
594 
595         token.mint(beneficiary, tokens);
596         TokenPurchase(
597             msg.sender,
598             beneficiary,
599             weiAmount,
600             tokens
601         );
602 
603         forwardFunds();
604 
605         // log contribution
606         contributions.addBalance(beneficiary, tokens);
607     }
608 
609     // close presale and transfer token ownership to the presale contract
610     function closeTokenSale(address _icoContract) onlyOwner public {
611         require(hasEnded());
612         require(_icoContract != address(0));
613 
614         token.transferOwnership(_icoContract);
615         contributions.transferOwnership(_icoContract);
616     }
617 
618     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
619         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
620     }
621 
622     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
623     function started() public view returns(bool) {
624         return now >= startTime;
625     }
626 
627     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
628     function ended() public view returns(bool) {
629         return hasEnded();
630     }
631 
632     // returns the total number of the tokens available for the sale, must not change when the ico is started
633     function totalTokens() public view returns(uint) {
634         return rate.mul(cap);
635     }
636 
637     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
638     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
639     function remainingTokens() public view returns(uint) {
640         return rate.mul(cap).sub(rate.mul(weiRaised));
641     }
642 
643     // return the price as number of tokens released for each ether
644     function price() public view returns(uint) {
645         return rate;
646     }
647 
648     /**
649      * @dev Create new instance of token contract
650      */
651     function createTokenContract() internal returns (MintableToken) {
652         return MintableToken(0);
653     }
654 
655     // overriding CappedCrowdsale#validPurchase to add extra cap logic
656     // @return true if investors are sending more than minimum contribution
657     function validPurchase() internal view returns (bool) {
658         bool validContribution = msg.value >= minimumContribution;
659 
660         uint256 remainingBalance = cap.sub(weiRaised);
661         if (remainingBalance <= minimumContribution) {
662             validContribution = true;
663         }
664 
665         return validContribution && super.validPurchase();
666     }
667 }