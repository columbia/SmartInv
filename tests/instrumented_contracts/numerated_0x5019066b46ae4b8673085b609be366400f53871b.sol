1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     if (newOwner != address(0)) {
31       owner = newOwner;
32     }
33   }
34 
35 }
36 
37 contract Pausable is Ownable {
38   event Pause();
39   event Unpause();
40 
41   bool public paused = false;
42 
43 
44   /**
45    * @dev modifier to allow actions only when the contract IS paused
46    */
47   modifier whenNotPaused() {
48     require(!paused);
49     _;
50   }
51 
52   /**
53    * @dev modifier to allow actions only when the contract IS NOT paused
54    */
55   modifier whenPaused {
56     require(paused);
57     _;
58   }
59 
60   /**
61    * @dev called by the owner to pause, triggers stopped state
62    */
63   function pause() onlyOwner whenNotPaused returns (bool) {
64     paused = true;
65     Pause();
66     return true;
67   }
68 
69   /**
70    * @dev called by the owner to unpause, returns to normal state
71    */
72   function unpause() onlyOwner whenPaused returns (bool) {
73     paused = false;
74     Unpause();
75     return true;
76   }
77 }
78 
79 contract ERC20Basic {
80   uint256 public totalSupply;
81   function balanceOf(address who) constant returns (uint256);
82   function transfer(address to, uint256 value) returns (bool);
83   event Transfer(address indexed from, address indexed to, uint256 value);
84 }
85 
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) returns (bool);
89   function approve(address spender, uint256 value) returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 contract Crowdsale {
120   using SafeMath for uint256;
121 
122   // The token being sold
123   MintableToken public token;
124 
125   // start and end block where investments are allowed (both inclusive)
126   uint256 public startBlock;
127   uint256 public endBlock;
128 
129   // address where funds are collected
130   address public wallet;
131 
132   // how many token units a buyer gets per wei
133   uint256 public rate;
134 
135   // amount of raised money in wei
136   uint256 public weiRaised;
137 
138   /**
139    * event for token purchase logging
140    * @param purchaser who paid for the tokens
141    * @param beneficiary who got the tokens
142    * @param value weis paid for purchase
143    * @param amount amount of tokens purchased
144    */
145   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
146 
147 
148   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
149     require(_startBlock >= block.number);
150     require(_endBlock >= _startBlock);
151     require(_rate > 0);
152     require(_wallet != 0x0);
153 
154     token = createTokenContract();
155     startBlock = _startBlock;
156     endBlock = _endBlock;
157     rate = _rate;
158     wallet = _wallet;
159   }
160 
161   // creates the token to be sold.
162   // override this method to have crowdsale of a specific mintable token.
163   function createTokenContract() internal returns (MintableToken) {
164     return new MintableToken();
165   }
166 
167 
168   // fallback function can be used to buy tokens
169   function () payable {
170     buyTokens(msg.sender);
171   }
172 
173   // low level token purchase function
174   function buyTokens(address beneficiary) payable {
175     require(beneficiary != 0x0);
176     require(validPurchase());
177 
178     uint256 weiAmount = msg.value;
179 
180     // calculate token amount to be created
181     uint256 tokens = weiAmount.mul(rate);
182 
183     // update state
184     weiRaised = weiRaised.add(weiAmount);
185 
186     token.mint(beneficiary, tokens);
187     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
188 
189     forwardFunds();
190   }
191 
192   // send ether to the fund collection wallet
193   // override to create custom fund forwarding mechanisms
194   function forwardFunds() internal {
195     wallet.transfer(msg.value);
196   }
197 
198   // @return true if the transaction can buy tokens
199   function validPurchase() internal constant returns (bool) {
200     uint256 current = block.number;
201     bool withinPeriod = current >= startBlock && current <= endBlock;
202     bool nonZeroPurchase = msg.value != 0;
203     return withinPeriod && nonZeroPurchase;
204   }
205 
206   // @return true if crowdsale event has ended
207   function hasEnded() public constant returns (bool) {
208     return block.number > endBlock;
209   }
210 
211 
212 }
213 
214 contract WhitelistedCrowdsale is Crowdsale, Ownable {
215     using SafeMath for uint256;
216 
217     // list of addresses that can purchase before crowdsale opens
218     mapping (address => bool) public whitelist;
219 
220     function addToWhitelist(address buyer) public onlyOwner {
221         require(buyer != 0x0);
222         whitelist[buyer] = true;
223     }
224 
225     // @return true if buyer is whitelisted
226     function isWhitelisted(address buyer) public constant returns (bool) {
227         return whitelist[buyer];
228     }
229 
230     // overriding Crowdsale#validPurchase to add whitelist logic
231     // @return true if buyers can buy at the moment
232     function validPurchase() internal constant returns (bool) {
233         // [TODO] issue with overriding and associativity of logical operators
234         return super.validPurchase() || (!hasEnded() && isWhitelisted(msg.sender));
235     }
236 
237 }
238 
239 contract BasicToken is ERC20Basic {
240   using SafeMath for uint256;
241 
242   mapping(address => uint256) balances;
243 
244   /**
245   * @dev transfer token for a specified address
246   * @param _to The address to transfer to.
247   * @param _value The amount to be transferred.
248   */
249   function transfer(address _to, uint256 _value) returns (bool) {
250     balances[msg.sender] = balances[msg.sender].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     Transfer(msg.sender, _to, _value);
253     return true;
254   }
255 
256   /**
257   * @dev Gets the balance of the specified address.
258   * @param _owner The address to query the the balance of.
259   * @return An uint256 representing the amount owned by the passed address.
260   */
261   function balanceOf(address _owner) constant returns (uint256 balance) {
262     return balances[_owner];
263   }
264 
265 }
266 
267 contract ContinuousSale {
268     using SafeMath for uint256;
269 
270     // time bucket size
271     uint256 public constant BUCKET_SIZE = 12 hours;
272 
273     // the token being sold
274     MintableToken public token;
275 
276     // address where funds are collected
277     address public wallet;
278 
279     // amount of tokens emitted per wei
280     uint256 public rate;
281 
282     // amount of raised money in wei
283     uint256 public weiRaised;
284 
285     // max amount of tokens to mint per time bucket
286     uint256 public issuance;
287 
288     // last time bucket from which tokens have been purchased
289     uint256 public lastBucket = 0;
290 
291     // amount issued in the last bucket
292     uint256 public bucketAmount = 0;
293 
294     event TokenPurchase(address indexed investor, address indexed beneficiary, uint256 weiAmount, uint256 tokens);
295 
296     function ContinuousSale(
297         uint256 _rate,
298         address _wallet,
299         MintableToken _token
300     ) {
301         require(_rate != 0);
302         require(_wallet != 0);
303         // require(address(token) != 0x0);
304 
305         rate = _rate;
306         wallet = _wallet;
307         token = _token;
308     }
309 
310     function() payable {
311         buyTokens(msg.sender);
312     }
313 
314     function buyTokens(address beneficiary) public payable {
315         require(beneficiary != 0x0);
316         require(msg.value != 0);
317 
318         prepareContinuousPurchase();
319         uint256 tokens = processPurchase(beneficiary);
320         checkContinuousPurchase(tokens);
321     }
322 
323     function prepareContinuousPurchase() internal {
324         uint256 timestamp = block.timestamp;
325         uint256 bucket = timestamp - (timestamp % BUCKET_SIZE);
326 
327         if (bucket > lastBucket) {
328             lastBucket = bucket;
329             bucketAmount = 0;
330         }
331     }
332 
333     function checkContinuousPurchase(uint256 tokens) internal {
334         uint256 updatedBucketAmount = bucketAmount.add(tokens);
335         require(updatedBucketAmount <= issuance);
336 
337         bucketAmount = updatedBucketAmount;
338     }
339 
340     function processPurchase(address beneficiary) internal returns(uint256) {
341         uint256 weiAmount = msg.value;
342 
343         // calculate token amount to be created
344         uint256 tokens = weiAmount.mul(rate);
345 
346         // update state
347         weiRaised = weiRaised.add(weiAmount);
348 
349         token.mint(beneficiary, tokens);
350         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
351 
352         forwardFunds();
353 
354         return tokens;
355     }
356 
357     function forwardFunds() internal {
358         wallet.transfer(msg.value);
359     }
360 }
361 
362 contract StandardToken is ERC20, BasicToken {
363 
364   mapping (address => mapping (address => uint256)) allowed;
365 
366 
367   /**
368    * @dev Transfer tokens from one address to another
369    * @param _from address The address which you want to send tokens from
370    * @param _to address The address which you want to transfer to
371    * @param _value uint256 the amout of tokens to be transfered
372    */
373   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
374     var _allowance = allowed[_from][msg.sender];
375 
376     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
377     // require (_value <= _allowance);
378 
379     balances[_to] = balances[_to].add(_value);
380     balances[_from] = balances[_from].sub(_value);
381     allowed[_from][msg.sender] = _allowance.sub(_value);
382     Transfer(_from, _to, _value);
383     return true;
384   }
385 
386   /**
387    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
388    * @param _spender The address which will spend the funds.
389    * @param _value The amount of tokens to be spent.
390    */
391   function approve(address _spender, uint256 _value) returns (bool) {
392 
393     // To change the approve amount you first have to reduce the addresses`
394     //  allowance to zero by calling `approve(_spender, 0)` if it is not
395     //  already 0 to mitigate the race condition described here:
396     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
398 
399     allowed[msg.sender][_spender] = _value;
400     Approval(msg.sender, _spender, _value);
401     return true;
402   }
403 
404   /**
405    * @dev Function to check the amount of tokens that an owner allowed to a spender.
406    * @param _owner address The address which owns the funds.
407    * @param _spender address The address which will spend the funds.
408    * @return A uint256 specifing the amount of tokens still avaible for the spender.
409    */
410   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
411     return allowed[_owner][_spender];
412   }
413 
414 }
415 
416 contract BurnableToken is StandardToken {
417 
418     event Burn(address indexed burner, uint256 value);
419 
420     /**
421      * @dev Burns a specified amount of tokens.
422      * @param _value The amount of tokens to burn.
423      */
424     function burn(uint256 _value) public {
425         require(_value > 0);
426 
427         address burner = msg.sender;
428         balances[burner] = balances[burner].sub(_value);
429         totalSupply = totalSupply.sub(_value);
430         Burn(msg.sender, _value);
431     }
432 
433 }
434 
435 contract PausableToken is StandardToken, Pausable {
436 
437   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
438     return super.transfer(_to, _value);
439   }
440 
441   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
442     return super.transferFrom(_from, _to, _value);
443   }
444 }
445 
446 contract MANAContinuousSale is ContinuousSale, Ownable {
447 
448     uint256 public constant INFLATION = 8;
449 
450     bool public started = false;
451 
452     event RateChange(uint256 amount);
453 
454     event WalletChange(address wallet);
455 
456     function MANAContinuousSale(
457         uint256 _rate,
458         address _wallet,
459         MintableToken _token
460     ) ContinuousSale(_rate, _wallet, _token) {
461     }
462 
463     modifier whenStarted() {
464         require(started);
465         _;
466     }
467 
468     function start() onlyOwner {
469         require(!started);
470 
471         // initialize issuance
472         uint256 finalSupply = token.totalSupply();
473         uint256 annualIssuance = finalSupply.mul(INFLATION).div(100);
474         issuance = annualIssuance.mul(BUCKET_SIZE).div(1 years);
475 
476         started = true;
477     }
478 
479     function buyTokens(address beneficiary) whenStarted public payable {
480         super.buyTokens(beneficiary);
481     }
482 
483     function setWallet(address _wallet) onlyOwner {
484         require(_wallet != 0x0);
485         wallet = _wallet;
486         WalletChange(_wallet);
487     }
488 
489     function setRate(uint256 _rate) onlyOwner {
490         rate = _rate;
491         RateChange(_rate);
492     }
493 
494     function unpauseToken() onlyOwner {
495         MANAToken(token).unpause();
496     }
497 
498     function pauseToken() onlyOwner {
499         MANAToken(token).pause();
500     }
501 }
502 
503 contract FinalizableCrowdsale is Crowdsale, Ownable {
504   using SafeMath for uint256;
505 
506   bool public isFinalized = false;
507 
508   event Finalized();
509 
510   // should be called after crowdsale ends, to do
511   // some extra finalization work
512   function finalize() onlyOwner {
513     require(!isFinalized);
514     require(hasEnded());
515 
516     finalization();
517     Finalized();
518 
519     isFinalized = true;
520   }
521 
522   // end token minting on finalization
523   // override this with custom logic if needed
524   function finalization() internal {
525     token.finishMinting();
526   }
527 
528 
529 
530 }
531 
532 contract MintableToken is StandardToken, Ownable {
533   event Mint(address indexed to, uint256 amount);
534   event MintFinished();
535 
536   bool public mintingFinished = false;
537 
538 
539   modifier canMint() {
540     require(!mintingFinished);
541     _;
542   }
543 
544   /**
545    * @dev Function to mint tokens
546    * @param _to The address that will recieve the minted tokens.
547    * @param _amount The amount of tokens to mint.
548    * @return A boolean that indicates if the operation was successful.
549    */
550   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
551     totalSupply = totalSupply.add(_amount);
552     balances[_to] = balances[_to].add(_amount);
553     Mint(_to, _amount);
554     return true;
555   }
556 
557   /**
558    * @dev Function to stop minting new tokens.
559    * @return True if the operation was successful.
560    */
561   function finishMinting() onlyOwner returns (bool) {
562     mintingFinished = true;
563     MintFinished();
564     return true;
565   }
566 }
567 
568 contract MANAToken is BurnableToken, PausableToken, MintableToken {
569 
570     string public constant symbol = "MANA";
571 
572     string public constant name = "Decentraland MANA";
573 
574     uint8 public constant decimals = 18;
575 
576     function burn(uint256 _value) whenNotPaused public {
577         super.burn(_value);
578     }
579 }
580 
581 contract CappedCrowdsale is Crowdsale {
582   using SafeMath for uint256;
583 
584   uint256 public cap;
585 
586   function CappedCrowdsale(uint256 _cap) {
587     require(_cap > 0);
588     cap = _cap;
589   }
590 
591   // overriding Crowdsale#validPurchase to add extra cap logic
592   // @return true if investors can buy at the moment
593   function validPurchase() internal constant returns (bool) {
594     bool withinCap = weiRaised.add(msg.value) <= cap;
595     return super.validPurchase() && withinCap;
596   }
597 
598   // overriding Crowdsale#hasEnded to add cap logic
599   // @return true if crowdsale event has ended
600   function hasEnded() public constant returns (bool) {
601     bool capReached = weiRaised >= cap;
602     return super.hasEnded() || capReached;
603   }
604 
605 }
606 
607 contract MANACrowdsale is WhitelistedCrowdsale, CappedCrowdsale, FinalizableCrowdsale {
608 
609     uint256 public constant TOTAL_SHARE = 100;
610     uint256 public constant CROWDSALE_SHARE = 40;
611     uint256 public constant FOUNDATION_SHARE = 60;
612 
613     // price at which whitelisted buyers will be able to buy tokens
614     uint256 public preferentialRate;
615 
616     // customize the rate for each whitelisted buyer
617     mapping (address => uint256) public buyerRate;
618 
619     // initial rate at which tokens are offered
620     uint256 public initialRate;
621 
622     // end rate at which tokens are offered
623     uint256 public endRate;
624 
625     // continuous crowdsale contract
626     MANAContinuousSale public continuousSale;
627 
628     event WalletChange(address wallet);
629 
630     event PreferentialRateChange(address indexed buyer, uint256 rate);
631 
632     event InitialRateChange(uint256 rate);
633 
634     event EndRateChange(uint256 rate);
635 
636     function MANACrowdsale()
637         CappedCrowdsale(86206 ether)
638         WhitelistedCrowdsale()
639         FinalizableCrowdsale()
640         Crowdsale(4170650, 4170680, 12083, 0x000fb8369677b3065de5821a86bc9551d5e5eab9)
641     {
642         initialRate = 12083;
643         endRate = 7250;
644         preferentialRate = 12083;
645 
646         continuousSale = createContinuousSaleContract();
647 
648         MANAToken(token).pause();
649     }
650 
651     function createTokenContract() internal returns(MintableToken) {
652         return new MANAToken();
653     }
654 
655     function createContinuousSaleContract() internal returns(MANAContinuousSale) {
656         return new MANAContinuousSale(rate, wallet, token);
657     }
658 
659     function setBuyerRate(address buyer, uint256 rate) onlyOwner public {
660         require(rate != 0);
661         require(isWhitelisted(buyer));
662         require(block.number < startBlock);
663 
664         buyerRate[buyer] = rate;
665 
666         PreferentialRateChange(buyer, rate);
667     }
668 
669     function setInitialRate(uint256 rate) onlyOwner public {
670         require(rate != 0);
671         require(block.number < startBlock);
672 
673         initialRate = rate;
674 
675         InitialRateChange(rate);
676     }
677 
678     function setEndRate(uint256 rate) onlyOwner public {
679         require(rate != 0);
680         require(block.number < startBlock);
681 
682         endRate = rate;
683 
684         EndRateChange(rate);
685     }
686 
687     function getRate() internal returns(uint256) {
688         // some early buyers are offered a discount on the crowdsale price
689         if (buyerRate[msg.sender] != 0) {
690             return buyerRate[msg.sender];
691         }
692 
693         // whitelisted buyers can purchase at preferential price before crowdsale ends
694         if (isWhitelisted(msg.sender)) {
695             return preferentialRate;
696         }
697 
698         // otherwise compute the price for the auction
699         uint256 elapsed = block.number - startBlock;
700         uint256 rateRange = initialRate - endRate;
701         uint256 blockRange = endBlock - startBlock;
702 
703         return initialRate.sub(rateRange.mul(elapsed).div(blockRange));
704     }
705 
706     // low level token purchase function
707     function buyTokens(address beneficiary) payable {
708         require(beneficiary != 0x0);
709         require(validPurchase());
710 
711         uint256 weiAmount = msg.value;
712         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
713 
714         uint256 rate = getRate();
715         // calculate token amount to be created
716         uint256 tokens = weiAmount.mul(rate);
717 
718         // update state
719         weiRaised = updatedWeiRaised;
720 
721         token.mint(beneficiary, tokens);
722         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
723 
724         forwardFunds();
725     }
726 
727     function setWallet(address _wallet) onlyOwner public {
728         require(_wallet != 0x0);
729         wallet = _wallet;
730         continuousSale.setWallet(_wallet);
731         WalletChange(_wallet);
732     }
733 
734     function unpauseToken() onlyOwner {
735         require(isFinalized);
736         MANAToken(token).unpause();
737     }
738 
739     function pauseToken() onlyOwner {
740         require(isFinalized);
741         MANAToken(token).pause();
742     }
743 
744 
745     function beginContinuousSale() onlyOwner public {
746         require(isFinalized);
747 
748         token.transferOwnership(continuousSale);
749 
750         continuousSale.start();
751         continuousSale.transferOwnership(owner);
752     }
753 
754     function finalization() internal {
755         uint256 totalSupply = token.totalSupply();
756         uint256 finalSupply = TOTAL_SHARE.mul(totalSupply).div(CROWDSALE_SHARE);
757 
758         // emit tokens for the foundation
759         token.mint(wallet, FOUNDATION_SHARE.mul(finalSupply).div(TOTAL_SHARE));
760 
761         // NOTE: cannot call super here because it would finish minting and
762         // the continuous sale would not be able to proceed
763     }
764 
765 }