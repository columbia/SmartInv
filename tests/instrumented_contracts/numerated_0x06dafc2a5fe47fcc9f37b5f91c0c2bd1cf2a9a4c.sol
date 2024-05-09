1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) public constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111 
112     uint256 _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue)
157     returns (bool success) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval (address _spender, uint _subtractedValue)
164     returns (bool success) {
165     uint oldValue = allowed[msg.sender][_spender];
166     if (_subtractedValue > oldValue) {
167       allowed[msg.sender][_spender] = 0;
168     } else {
169       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
170     }
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner public {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(0x0, _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 /**
264  * @title Crowdsale
265  * @dev Crowdsale is a base contract for managing a token crowdsale.
266  * Crowdsales have a start and end timestamps, where investors can make
267  * token purchases and the crowdsale will assign them tokens based
268  * on a token per ETH rate. Funds collected are forwarded to a wallet
269  * as they arrive.
270  */
271 contract Crowdsale {
272   using SafeMath for uint256;
273 
274   // The token being sold
275   MintableToken public token;
276 
277   // start and end timestamps where investments are allowed (both inclusive)
278   uint256 public startTime;
279   uint256 public endTime;
280 
281   // address where funds are collected
282   address public wallet;
283 
284   // how many token units a buyer gets per wei
285   uint256 public rate;
286 
287   // amount of raised money in wei
288   uint256 public weiRaised;
289 
290   /**
291    * event for token purchase logging
292    * @param purchaser who paid for the tokens
293    * @param beneficiary who got the tokens
294    * @param value weis paid for purchase
295    * @param amount amount of tokens purchased
296    */
297   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
298 
299 
300   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
301     require(_startTime >= now);
302     require(_endTime >= _startTime);
303     require(_rate > 0);
304     require(_wallet != 0x0);
305 
306     token = createTokenContract();
307     startTime = _startTime;
308     endTime = _endTime;
309     rate = _rate;
310     wallet = _wallet;
311   }
312 
313   // creates the token to be sold.
314   // override this method to have crowdsale of a specific mintable token.
315   function createTokenContract() internal returns (MintableToken) {
316     return new MintableToken();
317   }
318 
319 
320   // fallback function can be used to buy tokens
321   function () payable {
322     buyTokens(msg.sender);
323   }
324 
325   // low level token purchase function
326   function buyTokens(address beneficiary) public payable {
327     require(beneficiary != 0x0);
328     require(validPurchase());
329 
330     uint256 weiAmount = msg.value;
331 
332     // calculate token amount to be created
333     uint256 tokens = weiAmount.mul(rate);
334 
335     // update state
336     weiRaised = weiRaised.add(weiAmount);
337 
338     token.mint(beneficiary, tokens);
339     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
340 
341     forwardFunds();
342   }
343 
344   // send ether to the fund collection wallet
345   // override to create custom fund forwarding mechanisms
346   function forwardFunds() internal {
347     wallet.transfer(msg.value);
348   }
349 
350   // @return true if the transaction can buy tokens
351   function validPurchase() internal constant returns (bool) {
352     bool withinPeriod = now >= startTime && now <= endTime;
353     bool nonZeroPurchase = msg.value != 0;
354     return withinPeriod && nonZeroPurchase;
355   }
356 
357   // @return true if crowdsale event has ended
358   function hasEnded() public constant returns (bool) {
359     return now > endTime;
360   }
361 
362 
363 }
364 
365 /**
366  * @title FinalizableCrowdsale
367  * @dev Extension of Crowdsale where an owner can do extra work
368  * after finishing.
369  */
370 contract FinalizableCrowdsale is Crowdsale, Ownable {
371   using SafeMath for uint256;
372 
373   bool public isFinalized = false;
374 
375   event Finalized();
376 
377   /**
378    * @dev Must be called after crowdsale ends, to do some extra finalization
379    * work. Calls the contract's finalization function.
380    */
381   function finalize() onlyOwner public {
382     require(!isFinalized);
383     require(hasEnded());
384 
385     finalization();
386     Finalized();
387 
388     isFinalized = true;
389   }
390 
391   /**
392    * @dev Can be overridden to add finalization logic. The overriding function
393    * should call super.finalization() to ensure the chain of finalization is
394    * executed entirely.
395    */
396   function finalization() internal {
397   }
398 }
399 
400 /**
401  * @title FinalizableCrowdsale
402  * @dev Extension of Crowsdale where an owner can do extra work
403  * after finishing. By default, it will end token minting.
404  */
405 contract MyFinalizableCrowdsale is FinalizableCrowdsale {
406   using SafeMath for uint256;
407   // address where funds are collected
408   address public tokenWallet;
409 
410   event FinalTokens(uint256 _generated);
411 
412   function MyFinalizableCrowdsale(address _tokenWallet) {
413     tokenWallet = _tokenWallet;
414   }
415 
416   function generateFinalTokens(uint256 ratio) internal {
417     uint256 finalValue = token.totalSupply();
418     finalValue = finalValue.mul(ratio).div(1000);
419 
420     token.mint(tokenWallet, finalValue);
421     FinalTokens(finalValue);
422   }
423 
424 }
425 
426 /**
427  * @title MultiCappedCrowdsale
428  * @dev Extension of Crowsdale with a soft cap and a hard cap.
429  * after finishing. By default, it will end token minting.
430  */
431 contract MultiCappedCrowdsale is Crowdsale, Ownable {
432   using SafeMath for uint256;
433 
434   uint256 public softCap;
435   uint256 public hardCap = 0;
436   bytes32 public hardCapHash;
437   uint256 public hardCapTime = 0;
438   uint256 public endBuffer;
439   event NotFinalized(bytes32 _a, bytes32 _b);
440 
441   function MultiCappedCrowdsale(uint256 _softCap, bytes32 _hardCapHash, uint256 _endBuffer) {
442     require(_softCap > 0);
443     softCap = _softCap;
444     hardCapHash = _hardCapHash;
445     endBuffer = _endBuffer;
446   }
447 
448   //
449   //  Soft cap logic
450   //
451   
452   // overriding Crowdsale#validPurchase to add extra cap logic
453   // @return true if investors can buy at the moment
454   function validPurchase() internal constant returns (bool) {
455     if (hardCap > 0) {
456       checkHardCap(weiRaised.add(msg.value));
457     }
458     return super.validPurchase();
459   }
460 
461   //
462   //  Hard cap logic
463   //
464 
465   function hashHardCap(uint256 _hardCap, uint256 _key) internal constant returns (bytes32) {
466     return keccak256(_hardCap, _key);
467   }
468 
469   function setHardCap(uint256 _hardCap, uint256 _key) external onlyOwner {
470     require(hardCap==0);
471     if (hardCapHash != hashHardCap(_hardCap, _key)) {
472       NotFinalized(hashHardCap(_hardCap, _key), hardCapHash);
473       return;
474     }
475     hardCap = _hardCap;
476     checkHardCap(weiRaised);
477   }
478 
479 
480 
481   function checkHardCap(uint256 totalRaised) internal {
482     if (hardCapTime == 0 && totalRaised > hardCap) {
483       hardCapTime = block.timestamp;
484       endTime = block.timestamp+endBuffer;
485     }
486   }
487 
488 }
489 
490 /**
491  * @title LimitedTransferToken
492  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
493  * transferability for different events. It is intended to be used as a base class for other token
494  * contracts.
495  * LimitedTransferToken has been designed to allow for different limiting factors,
496  * this can be achieved by recursively calling super.transferableTokens() until the base class is
497  * hit. For example:
498  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
499  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
500  *     }
501  * A working example is VestedToken.sol:
502  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
503  */
504 
505 contract LimitedTransferToken is ERC20 {
506 
507   /**
508    * @dev Checks whether it can transfer or otherwise throws.
509    */
510   modifier canTransfer(address _sender, uint256 _value) {
511    require(_value <= transferableTokens(_sender, uint64(now)));
512    _;
513   }
514 
515   /**
516    * @dev Checks modifier and allows transfer if tokens are not locked.
517    * @param _to The address that will receive the tokens.
518    * @param _value The amount of tokens to be transferred.
519    */
520   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
521     return super.transfer(_to, _value);
522   }
523 
524   /**
525   * @dev Checks modifier and allows transfer if tokens are not locked.
526   * @param _from The address that will send the tokens.
527   * @param _to The address that will receive the tokens.
528   * @param _value The amount of tokens to be transferred.
529   */
530   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
531     return super.transferFrom(_from, _to, _value);
532   }
533 
534   /**
535    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
536    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
537    * specific logic for limiting token transferability for a holder over time.
538    */
539   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
540     return balanceOf(holder);
541   }
542 }
543 
544 /**
545  * @title FypToken
546  */
547 contract FypToken is MintableToken, LimitedTransferToken {
548 
549   string public constant name = "Flyp.me Token";
550   string public constant symbol = "FYP";
551   uint8 public constant decimals = 18;
552   bool public isTransferable = false;
553 
554   function enableTransfers() onlyOwner {
555      isTransferable = true;
556   }
557 
558   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
559     if (!isTransferable) {
560         return 0;
561     }
562     return super.transferableTokens(holder, time);
563   }
564 
565   function finishMinting() onlyOwner public returns (bool) {
566      enableTransfers();
567      return super.finishMinting();
568   }
569 
570 }
571 
572 /**
573  * @title FlypCrowdsale
574  * @dev This is a sale with the following features:
575  *  - erc20 based
576  *  - Soft cap and hidden hard cap
577  *  - When finished distributes percent to specific address based on whether the
578  *    cap was reached.
579  *  - Start and end times for the ico
580  *  - Sends incoming eth to a specific address
581  */
582 contract FlypCrowdsale is MyFinalizableCrowdsale, MultiCappedCrowdsale {
583 
584   // how many token units a buyer gets per wei
585   uint256 public presaleRate;
586   uint256 public postSoftRate;
587   uint256 public postHardRate;
588   uint256 public presaleEndTime;
589 
590   function FlypCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _presaleEndTime, uint256 _rate, uint256 _rateDiff, uint256 _softCap, address _wallet, bytes32 _hardCapHash, address _tokenWallet, uint256 _endBuffer)
591    MultiCappedCrowdsale(_softCap, _hardCapHash, _endBuffer)
592    MyFinalizableCrowdsale(_tokenWallet)
593    Crowdsale(_startTime, _endTime, _rate, _wallet)
594   {
595     presaleRate = _rate+_rateDiff;
596     postSoftRate = _rate-_rateDiff;
597     postHardRate = _rate-(2*_rateDiff);
598     presaleEndTime = _presaleEndTime;
599   }
600 
601   // Allows generating tokens for externally funded participants (other blockchains)
602   function pregenTokens(address beneficiary, uint256 weiAmount, uint256 tokenAmount) external onlyOwner {
603     require(beneficiary != 0x0);
604 
605     // update state
606     weiRaised = weiRaised.add(weiAmount);
607 
608     token.mint(beneficiary, tokenAmount);
609     TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
610   }
611 
612   // Overrides Crowdsale function
613   function buyTokens(address beneficiary) public payable {
614     require(beneficiary != 0x0);
615     require(validPurchase());
616 
617     uint256 weiAmount = msg.value;
618 
619     uint256 currentRate = rate;
620     if (block.timestamp < presaleEndTime) {
621         currentRate = presaleRate;
622     }
623     else if (hardCap > 0 && weiRaised > hardCap) {
624         currentRate = postHardRate;
625     }
626     else if (weiRaised > softCap) {
627         currentRate = postSoftRate;
628     }
629     // calculate token amount to be created
630     uint256 tokens = weiAmount.mul(currentRate);
631 
632     // update state
633     weiRaised = weiRaised.add(weiAmount);
634 
635     token.mint(beneficiary, tokens);
636     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
637 
638     forwardFunds();
639   }
640 
641   // Overrides Crowdsale function
642   function createTokenContract() internal returns (MintableToken) {
643     return new FypToken();
644   }
645 
646   // Overrides FinalizableCrowdsale function
647   function finalization() internal {
648     if (weiRaised < softCap) {
649       generateFinalTokens(1000);
650     } else if (weiRaised < hardCap) {
651       generateFinalTokens(666);
652     } else {
653       generateFinalTokens(428);
654     }
655     token.finishMinting();
656     super.finalization();
657   }
658 
659   // Make sure no eth funds become stuck on contract
660   function withdraw(uint256 weiValue) onlyOwner {
661     wallet.transfer(weiValue);
662   }
663 
664 }