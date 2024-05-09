1 pragma solidity ^0.4.15;
2 /* Inlined from ./contracts/TestToken.sol */
3 
4 
5 /* Inlined from node_modules/zeppelin-solidity/contracts/token/StandardToken.sol */
6 
7 
8 
9 /* Inlined from node_modules/zeppelin-solidity/contracts/token/BasicToken.sol */
10 
11 
12 
13 /* Inlined from node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol */
14 
15 
16 
17 /**
18  * @title ERC20Basic
19  * @dev Simpler version of ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/179
21  */
22 contract ERC20Basic {
23   uint256 public totalSupply;
24   function balanceOf(address who) constant returns (uint256);
25   function transfer(address to, uint256 value) returns (bool);
26   event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 
29 
30 
31 /**
32  * @title Basic token
33  * @dev Basic version of StandardToken, with no allowances. 
34  */
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * @dev transfer token for a specified address
42   * @param _to The address to transfer to.
43   * @param _value The amount to be transferred.
44   */
45   function transfer(address _to, uint256 _value) returns (bool) {
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of. 
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 
64 
65 /*
66  * Ownable
67  *
68  * Base contract with an owner.
69  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
70  */
71 contract Ownable {
72   address public owner;
73 
74   function Ownable() {
75     owner = msg.sender;
76   }
77 
78   modifier onlyOwner() {
79     if (msg.sender != owner) {
80       throw;
81     }
82     _;
83   }
84 
85   function transferOwnership(address newOwner) onlyOwner {
86     if (newOwner != address(0)) {
87       owner = newOwner;
88     }
89   }
90 
91 }
92 
93 
94 
95 /*
96  * ERC20 interface
97  * see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 {
100   uint public totalSupply;
101   function balanceOf(address who) constant returns (uint);
102   function allowance(address owner, address spender) constant returns (uint);
103 
104   function transfer(address to, uint value) returns (bool ok);
105   function transferFrom(address from, address to, uint value) returns (bool ok);
106   function approve(address spender, uint value) returns (bool ok);
107   event Transfer(address indexed from, address indexed to, uint value);
108   event Approval(address indexed owner, address indexed spender, uint value);
109 }
110 
111 
112 
113 /**
114  * @title SafeMath
115  * @dev Math operations with safety checks that throw on error
116  */
117 library SafeMath {
118   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
119     uint256 c = a * b;
120     assert(a == 0 || c / a == b);
121     return c;
122   }
123 
124   function div(uint256 a, uint256 b) internal constant returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   function add(uint256 a, uint256 b) internal constant returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * @dev https://github.com/ethereum/EIPs/issues/20
150  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amout of tokens to be transfered
162    */
163   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
164     var _allowance = allowed[_from][msg.sender];
165 
166     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
167     // require (_value <= _allowance);
168 
169     balances[_to] = balances[_to].add(_value);
170     balances[_from] = balances[_from].sub(_value);
171     allowed[_from][msg.sender] = _allowance.sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) returns (bool) {
182 
183     // To change the approve amount you first have to reduce the addresses`
184     //  allowance to zero by calling `approve(_spender, 0)` if it is not
185     //  already 0 to mitigate the race condition described here:
186     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
188 
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifing the amount of tokens still avaible for the spender.
199    */
200   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204 }
205 
206 
207 
208 
209 /**
210  * @title Mintable token
211  * @dev Simple ERC20 Token example, with mintable token creation
212  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
213  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
214  */
215 
216 contract MintableToken is StandardToken, Ownable {
217   event Mint(address indexed to, uint256 amount);
218   event MintFinished();
219 
220   bool public mintingFinished = false;
221 
222 
223   modifier canMint() {
224     require(!mintingFinished);
225     _;
226   }
227 
228   /**
229    * @dev Function to mint tokens
230    * @param _to The address that will recieve the minted tokens.
231    * @param _amount The amount of tokens to mint.
232    * @return A boolean that indicates if the operation was successful.
233    */
234   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
235     totalSupply = totalSupply.add(_amount);
236     balances[_to] = balances[_to].add(_amount);
237     Mint(_to, _amount);
238     return true;
239   }
240 
241   /**
242    * @dev Function to stop minting new tokens.
243    * @return True if the operation was successful.
244    */
245   function finishMinting() onlyOwner returns (bool) {
246     mintingFinished = true;
247     MintFinished();
248     return true;
249   }
250 }
251 
252 
253 
254 /**
255  * @title LimitedTransferToken
256  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
257  * transferability for different events. It is intended to be used as a base class for other token
258  * contracts.
259  * LimitedTransferToken has been designed to allow for different limiting factors,
260  * this can be achieved by recursively calling super.transferableTokens() until the base class is
261  * hit. For example:
262  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
263  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
264  *     }
265  * A working example is VestedToken.sol:
266  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
267  */
268 
269 contract LimitedTransferToken is ERC20 {
270 
271   /**
272    * @dev Checks whether it can transfer or otherwise throws.
273    */
274   modifier canTransfer(address _sender, uint256 _value) {
275    require(_value <= transferableTokens(_sender, uint64(now)));
276    _;
277   }
278 
279   /**
280    * @dev Checks modifier and allows transfer if tokens are not locked.
281    * @param _to The address that will recieve the tokens.
282    * @param _value The amount of tokens to be transferred.
283    */
284   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
285     return super.transfer(_to, _value);
286   }
287 
288   /**
289   * @dev Checks modifier and allows transfer if tokens are not locked.
290   * @param _from The address that will send the tokens.
291   * @param _to The address that will recieve the tokens.
292   * @param _value The amount of tokens to be transferred.
293   */
294   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
295     return super.transferFrom(_from, _to, _value);
296   }
297 
298   /**
299    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
300    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
301    * specific logic for limiting token transferability for a holder over time.
302    */
303   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
304     return balanceOf(holder);
305   }
306 }
307 
308 
309 
310 contract RakugoToken is MintableToken, LimitedTransferToken {
311 
312     event Burn(address indexed burner, uint indexed value);
313 
314     string public constant symbol = "RKT";
315     string public constant name = "Rakugo Seed Token";
316     uint8 public constant decimals = 18;
317 
318     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {//transfers still happening soon
319         require(mintingFinished);
320         return balanceOf(holder);
321     }
322 
323     function burn(uint _value) canTransfer(msg.sender, _value) public {//todo canTransfer(msg.sender, _value), remove public?
324         require(_value > 0);
325         require(_value >= balanceOf(burner));
326 
327         address burner = msg.sender;
328         balances[burner] = balances[burner].sub(_value);
329         totalSupply = totalSupply.sub(_value);
330         Burn(burner, _value);
331     }
332 }
333 
334 
335 
336 /**
337  * @title Crowdsale 
338  * @dev Crowdsale is a base contract for managing a token crowdsale.
339  * Crowdsales have a start and end block, where investors can make
340  * token purchases and the crowdsale will assign them tokens based
341  * on a token per ETH rate. Funds collected are forwarded to a wallet 
342  * as they arrive.
343  */
344 contract Crowdsale {
345   using SafeMath for uint256;
346 
347   // The token being sold
348   MintableToken public token;
349 
350   // start and end block where investments are allowed (both inclusive)
351   uint256 public startBlock;
352   uint256 public endBlock;
353 
354   // address where funds are collected
355   address public wallet;
356 
357   // how many token units a buyer gets per wei
358   uint256 public rate;
359 
360   // amount of raised money in wei
361   uint256 public weiRaised;
362 
363   /**
364    * event for token purchase logging
365    * @param purchaser who paid for the tokens
366    * @param beneficiary who got the tokens
367    * @param value weis paid for purchase
368    * @param amount amount of tokens purchased
369    */ 
370   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
371 
372 
373   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
374     require(_startBlock >= block.number);
375     require(_endBlock >= _startBlock);
376     require(_rate > 0);
377     require(_wallet != 0x0);
378 
379     token = createTokenContract();
380     startBlock = _startBlock;
381     endBlock = _endBlock;
382     rate = _rate;
383     wallet = _wallet;
384   }
385 
386   // creates the token to be sold. 
387   // override this method to have crowdsale of a specific mintable token.
388   function createTokenContract() internal returns (MintableToken) {
389     return new MintableToken();
390   }
391 
392 
393   // fallback function can be used to buy tokens
394   function () payable {
395     buyTokens(msg.sender);
396   }
397 
398   // low level token purchase function
399   function buyTokens(address beneficiary) payable {
400     require(beneficiary != 0x0);
401     require(validPurchase());
402 
403     uint256 weiAmount = msg.value;
404 
405     // calculate token amount to be created
406     uint256 tokens = weiAmount.mul(rate);
407 
408     // update state
409     weiRaised = weiRaised.add(weiAmount);
410 
411     token.mint(beneficiary, tokens);
412     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
413 
414     forwardFunds();
415   }
416 
417   // send ether to the fund collection wallet
418   // override to create custom fund forwarding mechanisms
419   function forwardFunds() internal {
420     wallet.transfer(msg.value);
421   }
422 
423   // @return true if the transaction can buy tokens
424   function validPurchase() internal constant returns (bool) {
425     uint256 current = block.number;
426     bool withinPeriod = current >= startBlock && current <= endBlock;
427     bool nonZeroPurchase = msg.value != 0;
428     return withinPeriod && nonZeroPurchase;
429   }
430 
431   // @return true if crowdsale event has ended
432   function hasEnded() public constant returns (bool) {
433     return block.number > endBlock;
434   }
435 
436 
437 }
438 
439 
440 
441 contract FinalizableCrowdsale is Crowdsale, Ownable {
442   using SafeMath for uint256;
443 
444   bool public isFinalized = false;
445 
446   event Finalized();
447 
448   /**
449    * @dev Must be called after crowdsale ends, to do some extra finalization
450    * work. Calls the contract's finalization function.
451    */
452   function finalize() onlyOwner {
453     require(!isFinalized);
454     require(hasEnded());
455 
456     finalization();
457     Finalized();
458     
459     isFinalized = true;
460   }
461 
462   /**
463    * @dev Can be overriden to add finalization logic. The overriding function
464    * should call super.finalization() to ensure the chain of finalization is
465    * executed entirely.
466    */
467   function finalization() internal {
468   }
469 }
470 /**
471  * @title CappedCrowdsale
472  * @dev Extension of Crowsdale with a max amount of funds raised
473  */
474 contract CappedCrowdsale is Crowdsale {
475   using SafeMath for uint256;
476 
477   uint256 public cap;
478 
479   function CappedCrowdsale(uint256 _cap) {
480     require(_cap > 0);
481     cap = _cap;
482   }
483 
484   // overriding Crowdsale#validPurchase to add extra cap logic
485   // @return true if investors can buy at the moment
486   function validPurchase() internal constant returns (bool) {
487     bool withinCap = weiRaised.add(msg.value) <= cap;
488     return super.validPurchase() && withinCap;
489   }
490 
491   // overriding Crowdsale#hasEnded to add cap logic
492   // @return true if crowdsale event has ended
493   function hasEnded() public constant returns (bool) {
494     bool capReached = weiRaised >= cap;
495     return super.hasEnded() || capReached;
496   }
497 
498 }
499 
500 
501 
502 contract RakugoPresale is CappedCrowdsale {
503 
504   mapping(address => uint) private balances;
505 
506   function RakugoPresale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet)
507   CappedCrowdsale(5000 ether)
508   Crowdsale(_startBlock, _endBlock, _rate, _wallet){
509   }
510 
511   function buyTokens(address beneficiary) payable {
512     require(beneficiary != 0x0);
513     require(validPurchase());
514 
515     uint256 weiAmount = msg.value;
516 
517     // calculate token amount to be created
518     uint256 tokens = weiAmount.mul(rate);
519 
520     // update state
521     weiRaised = weiRaised.add(weiAmount);
522 
523     // add balance
524     balances[msg.sender] = balances[msg.sender].add(tokens);
525 
526     // notarize tx
527     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
528 
529     forwardFunds();
530   }
531 
532   function balanceOf(address _owner) constant returns (uint256 balance) {
533     return balances[_owner];
534   }
535 }
536 
537 
538 
539 contract RakugoCrowdsale is Crowdsale, CappedCrowdsale, FinalizableCrowdsale {
540 
541   address public rakugoPresaleAddress;
542   uint256 public rate = 1200;
543   uint256 public companyTokens = 16000000 ether;
544 
545   function RakugoCrowdsale(
546   uint256 _startBlock,
547   uint256 _endBlock,
548   address _wallet,
549   address _presaleAddress,
550   address[] _presales
551   )
552   CappedCrowdsale(19951 ether)//TODO passing in _saleCap braking?
553   FinalizableCrowdsale()
554   Crowdsale(_startBlock, _endBlock, rate, _wallet) {
555     rakugoPresaleAddress = _presaleAddress;
556     initializeCompanyTokens(companyTokens);
557     presalePurchase(_presales, _presaleAddress);
558   }
559 
560   function createTokenContract() internal returns (MintableToken) {
561     return new RakugoToken();
562   }
563 
564   function initializeCompanyTokens(uint256 _companyTokens) internal {
565     contribute(wallet, wallet, 0, _companyTokens);//no paid eth for company liquidity
566   }
567 
568   function presalePurchase(address[] presales, address _presaleAddress) internal {
569     RakugoPresale rakugoPresale = RakugoPresale(_presaleAddress);
570     for (uint i = 0; i < presales.length; i++) {
571         address presalePurchaseAddress = presales[i];
572         uint256 contributionAmmount = 0;//presale contributions tracked differently than main sale
573         uint256 presalePurchaseTokens = rakugoPresale.balanceOf(presalePurchaseAddress);
574         contribute(presalePurchaseAddress, presalePurchaseAddress, contributionAmmount, presalePurchaseTokens);
575     }
576   }
577 
578   function contribute(address purchaser, address beneficiary, uint256 weiAmount, uint256 tokens){
579     token.mint(beneficiary, tokens);
580     TokenPurchase(purchaser, beneficiary, weiAmount, tokens);
581   }
582 
583  function finalize() onlyOwner {
584     require(!isFinalized);
585     require(hasEnded());
586 
587     finalization();
588     Finalized();
589 
590     isFinalized = true;
591   }
592 
593   function finalization() internal {
594     token.finishMinting();
595   }
596 }