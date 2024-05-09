1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract CappedCrowdsale is Crowdsale {
124   using SafeMath for uint256;
125 
126   uint256 public cap;
127 
128   function CappedCrowdsale(uint256 _cap) {
129     require(_cap > 0);
130     cap = _cap;
131   }
132 
133   // overriding Crowdsale#validPurchase to add extra cap logic
134   // @return true if investors can buy at the moment
135   function validPurchase() internal constant returns (bool) {
136     bool withinCap = weiRaised.add(msg.value) <= cap;
137     return super.validPurchase() && withinCap;
138   }
139 
140   // overriding Crowdsale#hasEnded to add cap logic
141   // @return true if crowdsale event has ended
142   function hasEnded() public constant returns (bool) {
143     bool capReached = weiRaised >= cap;
144     return super.hasEnded() || capReached;
145   }
146 
147 }
148 
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   function Ownable() {
161     owner = msg.sender;
162   }
163 
164 
165   /**
166    * @dev Throws if called by any account other than the owner.
167    */
168   modifier onlyOwner() {
169     require(msg.sender == owner);
170     _;
171   }
172 
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner public {
179     require(newOwner != address(0));
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 
186 contract FinalizableCrowdsale is Crowdsale, Ownable {
187   using SafeMath for uint256;
188 
189   bool public isFinalized = false;
190 
191   event Finalized();
192 
193   /**
194    * @dev Must be called after crowdsale ends, to do some extra finalization
195    * work. Calls the contract's finalization function.
196    */
197   function finalize() onlyOwner public {
198     require(!isFinalized);
199     require(hasEnded());
200 
201     finalization();
202     Finalized();
203 
204     isFinalized = true;
205   }
206 
207   /**
208    * @dev Can be overridden to add finalization logic. The overriding function
209    * should call super.finalization() to ensure the chain of finalization is
210    * executed entirely.
211    */
212   function finalization() internal {
213   }
214 }
215 
216 contract Pausable is Ownable {
217   event Pause();
218   event Unpause();
219 
220   bool public paused = false;
221 
222 
223   /**
224    * @dev Modifier to make a function callable only when the contract is not paused.
225    */
226   modifier whenNotPaused() {
227     require(!paused);
228     _;
229   }
230 
231   /**
232    * @dev Modifier to make a function callable only when the contract is paused.
233    */
234   modifier whenPaused() {
235     require(paused);
236     _;
237   }
238 
239   /**
240    * @dev called by the owner to pause, triggers stopped state
241    */
242   function pause() onlyOwner whenNotPaused public {
243     paused = true;
244     Pause();
245   }
246 
247   /**
248    * @dev called by the owner to unpause, returns to normal state
249    */
250   function unpause() onlyOwner whenPaused public {
251     paused = false;
252     Unpause();
253   }
254 }
255 
256 contract ERC20Basic {
257   uint256 public totalSupply;
258   function balanceOf(address who) public constant returns (uint256);
259   function transfer(address to, uint256 value) public returns (bool);
260   event Transfer(address indexed from, address indexed to, uint256 value);
261 }
262 
263 contract BasicToken is ERC20Basic {
264   using SafeMath for uint256;
265 
266   mapping(address => uint256) balances;
267 
268   /**
269   * @dev transfer token for a specified address
270   * @param _to The address to transfer to.
271   * @param _value The amount to be transferred.
272   */
273   function transfer(address _to, uint256 _value) public returns (bool) {
274     require(_to != address(0));
275 
276     // SafeMath.sub will throw if there is not enough balance.
277     balances[msg.sender] = balances[msg.sender].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     Transfer(msg.sender, _to, _value);
280     return true;
281   }
282 
283   /**
284   * @dev Gets the balance of the specified address.
285   * @param _owner The address to query the the balance of.
286   * @return An uint256 representing the amount owned by the passed address.
287   */
288   function balanceOf(address _owner) public constant returns (uint256 balance) {
289     return balances[_owner];
290   }
291 
292 }
293 
294 contract ERC20 is ERC20Basic {
295   function allowance(address owner, address spender) public constant returns (uint256);
296   function transferFrom(address from, address to, uint256 value) public returns (bool);
297   function approve(address spender, uint256 value) public returns (bool);
298   event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 contract StandardToken is ERC20, BasicToken {
302 
303   mapping (address => mapping (address => uint256)) allowed;
304 
305 
306   /**
307    * @dev Transfer tokens from one address to another
308    * @param _from address The address which you want to send tokens from
309    * @param _to address The address which you want to transfer to
310    * @param _value uint256 the amount of tokens to be transferred
311    */
312   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
313     require(_to != address(0));
314 
315     uint256 _allowance = allowed[_from][msg.sender];
316 
317     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
318     // require (_value <= _allowance);
319 
320     balances[_from] = balances[_from].sub(_value);
321     balances[_to] = balances[_to].add(_value);
322     allowed[_from][msg.sender] = _allowance.sub(_value);
323     Transfer(_from, _to, _value);
324     return true;
325   }
326 
327   /**
328    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
329    *
330    * Beware that changing an allowance with this method brings the risk that someone may use both the old
331    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
332    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
333    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
334    * @param _spender The address which will spend the funds.
335    * @param _value The amount of tokens to be spent.
336    */
337   function approve(address _spender, uint256 _value) public returns (bool) {
338     allowed[msg.sender][_spender] = _value;
339     Approval(msg.sender, _spender, _value);
340     return true;
341   }
342 
343   /**
344    * @dev Function to check the amount of tokens that an owner allowed to a spender.
345    * @param _owner address The address which owns the funds.
346    * @param _spender address The address which will spend the funds.
347    * @return A uint256 specifying the amount of tokens still available for the spender.
348    */
349   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
350     return allowed[_owner][_spender];
351   }
352 
353   /**
354    * approve should be called when allowed[_spender] == 0. To increment
355    * allowed value is better to use this function to avoid 2 calls (and wait until
356    * the first transaction is mined)
357    * From MonolithDAO Token.sol
358    */
359   function increaseApproval (address _spender, uint _addedValue)
360     returns (bool success) {
361     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
362     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
363     return true;
364   }
365 
366   function decreaseApproval (address _spender, uint _subtractedValue)
367     returns (bool success) {
368     uint oldValue = allowed[msg.sender][_spender];
369     if (_subtractedValue > oldValue) {
370       allowed[msg.sender][_spender] = 0;
371     } else {
372       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
373     }
374     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375     return true;
376   }
377 
378 }
379 
380 contract MintableToken is StandardToken, Ownable {
381   event Mint(address indexed to, uint256 amount);
382   event MintFinished();
383 
384   bool public mintingFinished = false;
385 
386 
387   modifier canMint() {
388     require(!mintingFinished);
389     _;
390   }
391 
392   /**
393    * @dev Function to mint tokens
394    * @param _to The address that will receive the minted tokens.
395    * @param _amount The amount of tokens to mint.
396    * @return A boolean that indicates if the operation was successful.
397    */
398   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
399     totalSupply = totalSupply.add(_amount);
400     balances[_to] = balances[_to].add(_amount);
401     Mint(_to, _amount);
402     Transfer(0x0, _to, _amount);
403     return true;
404   }
405 
406   /**
407    * @dev Function to stop minting new tokens.
408    * @return True if the operation was successful.
409    */
410   function finishMinting() onlyOwner public returns (bool) {
411     mintingFinished = true;
412     MintFinished();
413     return true;
414   }
415 }
416 
417 contract QiibeeTokenInterface {
418   function mintVestedTokens(address _to,
419     uint256 _value,
420     uint64 _start,
421     uint64 _cliff,
422     uint64 _vesting,
423     bool _revokable,
424     bool _burnsOnRevoke,
425     address _wallet
426   ) returns (bool);
427   function mint(address _to, uint256 _amount) returns (bool);
428   function transferOwnership(address _wallet);
429   function pause();
430   function unpause();
431   function finishMinting() returns (bool);
432 }
433 
434 contract QiibeePresale is CappedCrowdsale, FinalizableCrowdsale, Pausable {
435 
436     using SafeMath for uint256;
437 
438     struct AccreditedInvestor {
439       uint64 cliff;
440       uint64 vesting;
441       bool revokable;
442       bool burnsOnRevoke;
443       uint256 minInvest; // minimum invest in wei for a given investor
444       uint256 maxCumulativeInvest; // maximum cumulative invest in wei for a given investor
445     }
446 
447     QiibeeTokenInterface public token; // token being sold
448 
449     uint256 public distributionCap; // cap in tokens that can be distributed to the pools
450     uint256 public tokensDistributed; // tokens distributed to pools
451     uint256 public tokensSold; // qbx minted (and sold)
452 
453     uint64 public vestFromTime = 1530316800; // start time for vested tokens (equiv. to 30/06/2018 12:00:00 AM GMT)
454 
455     mapping (address => uint256) public balances; // balance of wei invested per investor
456     mapping (address => AccreditedInvestor) public accredited; // whitelist of investors
457 
458     // spam prevention
459     mapping (address => uint256) public lastCallTime; // last call times by address
460     uint256 public maxGasPrice; // max gas price per transaction
461     uint256 public minBuyingRequestInterval; // min request interval for purchases from a single source (in seconds)
462 
463     bool public isFinalized = false;
464 
465     event NewAccreditedInvestor(address indexed from, address indexed buyer);
466     event TokenDistributed(address indexed beneficiary, uint256 tokens);
467 
468     /*
469      * @dev Constructor.
470      * @param _startTime see `startTimestamp`
471      * @param _endTime see `endTimestamp`
472      * @param _rate see `see rate`
473      * @param _cap see `see cap`
474      * @param _distributionCap see `see distributionCap`
475      * @param _maxGasPrice see `see maxGasPrice`
476      * @param _minBuyingRequestInterval see `see minBuyingRequestInterval`
477      * @param _wallet see `wallet`
478      */
479     function QiibeePresale(
480         uint256 _startTime,
481         uint256 _endTime,
482         address _token,
483         uint256 _rate,
484         uint256 _cap,
485         uint256 _distributionCap,
486         uint256 _maxGasPrice,
487         uint256 _minBuyingRequestInterval,
488         address _wallet
489     )
490       Crowdsale(_startTime, _endTime, _rate, _wallet)
491       CappedCrowdsale(_cap)
492     {
493       require(_distributionCap > 0);
494       require(_maxGasPrice > 0);
495       require(_minBuyingRequestInterval > 0);
496       require(_token != address(0));
497 
498       distributionCap = _distributionCap;
499       maxGasPrice = _maxGasPrice;
500       minBuyingRequestInterval = _minBuyingRequestInterval;
501       token = QiibeeTokenInterface(_token);
502     }
503 
504     /*
505      * @param beneficiary address where tokens are sent to
506      */
507     function buyTokens(address beneficiary) public payable whenNotPaused {
508       require(beneficiary != address(0));
509       require(validPurchase());
510 
511       AccreditedInvestor storage data = accredited[msg.sender];
512 
513       // investor's data
514       uint256 minInvest = data.minInvest;
515       uint256 maxCumulativeInvest = data.maxCumulativeInvest;
516       uint64 from = vestFromTime;
517       uint64 cliff = from + data.cliff;
518       uint64 vesting = cliff + data.vesting;
519       bool revokable = data.revokable;
520       bool burnsOnRevoke = data.burnsOnRevoke;
521 
522       uint256 tokens = msg.value.mul(rate);
523 
524       // check investor's limits
525       uint256 newBalance = balances[msg.sender].add(msg.value);
526       require(newBalance <= maxCumulativeInvest && msg.value >= minInvest);
527 
528       if (data.cliff > 0 && data.vesting > 0) {
529         require(QiibeeTokenInterface(token).mintVestedTokens(beneficiary, tokens, from, cliff, vesting, revokable, burnsOnRevoke, wallet));
530       } else {
531         require(QiibeeTokenInterface(token).mint(beneficiary, tokens));
532       }
533 
534       // update state
535       balances[msg.sender] = newBalance;
536       weiRaised = weiRaised.add(msg.value);
537       tokensSold = tokensSold.add(tokens);
538 
539       TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
540 
541       forwardFunds();
542     }
543 
544     /*
545      * @dev This functions is used to manually distribute tokens. It works after the fundraising, can
546      * only be called by the owner and when the presale is not paused. It has a cap on the amount
547      * of tokens that can be manually distributed.
548      *
549      * @param _beneficiary address where tokens are sent to
550      * @param _tokens amount of tokens (in atto) to distribute
551      * @param _cliff duration in seconds of the cliff in which tokens will begin to vest.
552      * @param _vesting duration in seconds of the vesting in which tokens will vest.
553      */
554     function distributeTokens(address _beneficiary, uint256 _tokens, uint64 _cliff, uint64 _vesting, bool _revokable, bool _burnsOnRevoke) public onlyOwner whenNotPaused {
555       require(_beneficiary != address(0));
556       require(_tokens > 0);
557       require(_vesting >= _cliff);
558       require(!isFinalized);
559       require(hasEnded());
560 
561       // check distribution cap limit
562       uint256 totalDistributed = tokensDistributed.add(_tokens);
563       assert(totalDistributed <= distributionCap);
564 
565       if (_cliff > 0 && _vesting > 0) {
566         uint64 from = vestFromTime;
567         uint64 cliff = from + _cliff;
568         uint64 vesting = cliff + _vesting;
569         assert(QiibeeTokenInterface(token).mintVestedTokens(_beneficiary, _tokens, from, cliff, vesting, _revokable, _burnsOnRevoke, wallet));
570       } else {
571         assert(QiibeeTokenInterface(token).mint(_beneficiary, _tokens));
572       }
573 
574       // update state
575       tokensDistributed = tokensDistributed.add(_tokens);
576 
577       TokenDistributed(_beneficiary, _tokens);
578     }
579 
580     /*
581      * @dev Add an address to the accredited list.
582      */
583     function addAccreditedInvestor(address investor, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke, uint256 minInvest, uint256 maxCumulativeInvest) public onlyOwner {
584         require(investor != address(0));
585         require(vesting >= cliff);
586         require(minInvest > 0);
587         require(maxCumulativeInvest > 0);
588         require(minInvest <= maxCumulativeInvest);
589 
590         accredited[investor] = AccreditedInvestor(cliff, vesting, revokable, burnsOnRevoke, minInvest, maxCumulativeInvest);
591 
592         NewAccreditedInvestor(msg.sender, investor);
593     }
594 
595     /*
596      * @dev checks if an address is accredited
597      * @return true if investor is accredited
598      */
599     function isAccredited(address investor) public constant returns (bool) {
600         AccreditedInvestor storage data = accredited[investor];
601         return data.minInvest > 0;
602     }
603 
604     /*
605      * @dev Remove an address from the accredited list.
606      */
607     function removeAccreditedInvestor(address investor) public onlyOwner {
608         require(investor != address(0));
609         delete accredited[investor];
610     }
611 
612 
613     /*
614      * @return true if investors can buy at the moment
615      */
616     function validPurchase() internal constant returns (bool) {
617       require(isAccredited(msg.sender));
618       bool withinFrequency = now.sub(lastCallTime[msg.sender]) >= minBuyingRequestInterval;
619       bool withinGasPrice = tx.gasprice <= maxGasPrice;
620       return super.validPurchase() && withinFrequency && withinGasPrice;
621     }
622 
623     /*
624      * @dev Must be called after crowdsale ends, to do some extra finalization
625      * work. Calls the contract's finalization function. Only owner can call it.
626      */
627     function finalize() public onlyOwner {
628       require(!isFinalized);
629       require(hasEnded());
630 
631       finalization();
632       Finalized();
633 
634       isFinalized = true;
635 
636       // transfer the ownership of the token to the foundation
637       QiibeeTokenInterface(token).transferOwnership(wallet);
638     }
639 
640     /*
641      * @dev sets the token that the presale will use. Can only be called by the owner and
642      * before the presale starts.
643      */
644     function setToken(address tokenAddress) onlyOwner {
645       require(now < startTime);
646       token = QiibeeTokenInterface(tokenAddress);
647     }
648 
649 }