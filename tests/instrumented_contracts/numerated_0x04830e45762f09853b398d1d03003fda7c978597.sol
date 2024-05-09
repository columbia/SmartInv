1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) returns (bool);
13   function approve(address spender, uint256 value) returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
26     owner = msg.sender;
27   }
28 
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38 
39   /**
40    * @dev Allows the current owner to transfer control of the contract to a newOwner.
41    * @param newOwner The address to transfer ownership to.
42    */
43   function transferOwnership(address newOwner) onlyOwner {
44     if (newOwner != address(0)) {
45       owner = newOwner;
46     }
47   }
48 
49 }
50 
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal constant returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return c;
63   }
64 
65   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   function add(uint256 a, uint256 b) internal constant returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 
77 contract Crowdsale {
78   using SafeMath for uint256;
79 
80   // The token being sold
81   MintableToken public token;
82 
83   // start and end block where investments are allowed (both inclusive)
84   uint256 public startBlock;
85   uint256 public endBlock;
86 
87   // address where funds are collected
88   address public wallet;
89 
90   // how many token units a buyer gets per wei
91   uint256 public rate;
92 
93   // amount of raised money in wei
94   uint256 public weiRaised;
95 
96   /**
97    * event for token purchase logging
98    * @param purchaser who paid for the tokens
99    * @param beneficiary who got the tokens
100    * @param value weis paid for purchase
101    * @param amount amount of tokens purchased
102    */ 
103   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
104 
105 
106   function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet) {
107     require(_startBlock >= block.number);
108     require(_endBlock >= _startBlock);
109     require(_rate > 0);
110     require(_wallet != 0x0);
111 
112     token = createTokenContract();
113     startBlock = _startBlock;
114     endBlock = _endBlock;
115     rate = _rate;
116     wallet = _wallet;
117   }
118 
119   // creates the token to be sold. 
120   // override this method to have crowdsale of a specific mintable token.
121   function createTokenContract() internal returns (MintableToken) {
122     return new MintableToken();
123   }
124 
125 
126   // fallback function can be used to buy tokens
127   function () payable {
128     buyTokens(msg.sender);
129   }
130 
131   // low level token purchase function
132   function buyTokens(address beneficiary) payable {
133     require(beneficiary != 0x0);
134     require(validPurchase());
135 
136     uint256 weiAmount = msg.value;
137 
138     // calculate token amount to be created
139     uint256 tokens = weiAmount.mul(rate);
140 
141     // update state
142     weiRaised = weiRaised.add(weiAmount);
143 
144     token.mint(beneficiary, tokens);
145     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
146 
147     forwardFunds();
148   }
149 
150   // send ether to the fund collection wallet
151   // override to create custom fund forwarding mechanisms
152   function forwardFunds() internal {
153     wallet.transfer(msg.value);
154   }
155 
156   // @return true if the transaction can buy tokens
157   function validPurchase() internal constant returns (bool) {
158     uint256 current = block.number;
159     bool withinPeriod = current >= startBlock && current <= endBlock;
160     bool nonZeroPurchase = msg.value != 0;
161     return withinPeriod && nonZeroPurchase;
162   }
163 
164   // @return true if crowdsale event has ended
165   function hasEnded() public constant returns (bool) {
166     return block.number > endBlock;
167   }
168 
169 
170 }
171 
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) returns (bool) {
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of. 
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) constant returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 contract WhitelistedCrowdsale is Crowdsale, Ownable {
201     using SafeMath for uint256;
202 
203     // list of addresses that can purchase before crowdsale opens
204     mapping (address => bool) public whitelist;
205 
206     function addToWhitelist(address buyer) public onlyOwner {
207         require(buyer != 0x0);
208         whitelist[buyer] = true; 
209     }
210 
211     // @return true if buyer is whitelisted
212     function isWhitelisted(address buyer) public constant returns (bool) {
213         return whitelist[buyer];
214     }
215 
216     // overriding Crowdsale#validPurchase to add whitelist logic
217     // @return true if buyers can buy at the moment
218     function validPurchase() internal constant returns (bool) {
219         // [TODO] issue with overriding and associativity of logical operators
220         return super.validPurchase() || (!hasEnded() && isWhitelisted(msg.sender)); 
221     }
222 
223 }
224 
225 contract ContinuousSale {
226     using SafeMath for uint256;
227 
228     // time bucket size
229     uint256 public constant BUCKET_SIZE = 12 hours;
230 
231     // the token being sold
232     MintableToken public token;
233 
234     // address where funds are collected
235     address public wallet;
236 
237     // amount of tokens emitted per wei
238     uint256 public rate;
239 
240     // amount of raised money in wei
241     uint256 public weiRaised;
242 
243     // max amount of tokens to mint per time bucket
244     uint256 public issuance;
245 
246     // last time bucket from which tokens have been purchased
247     uint256 public lastBucket = 0;
248 
249     // amount issued in the last bucket
250     uint256 public bucketAmount = 0;
251 
252     event TokenPurchase(address indexed investor, address indexed beneficiary, uint256 weiAmount, uint256 tokens);
253 
254     function ContinuousSale(
255         uint256 _rate,
256         address _wallet,
257         MintableToken _token
258     ) {
259         require(_rate != 0);
260         require(_wallet != 0);
261         // require(address(token) != 0x0);
262 
263         rate = _rate;
264         wallet = _wallet;
265         token = _token;
266     }
267 
268     function() payable {
269         buyTokens(msg.sender);
270     }
271 
272     function buyTokens(address beneficiary) public payable {
273         require(beneficiary != 0x0);
274         require(msg.value != 0);
275 
276         prepareContinuousPurchase();
277         uint256 tokens = processPurchase(beneficiary);
278         checkContinuousPurchase(tokens);
279     }
280 
281     function prepareContinuousPurchase() internal {
282         uint256 timestamp = block.timestamp;
283         uint256 bucket = timestamp - (timestamp % BUCKET_SIZE);
284 
285         if (bucket > lastBucket) {
286             lastBucket = bucket;
287             bucketAmount = 0;
288         }
289     }
290 
291     function checkContinuousPurchase(uint256 tokens) internal {
292         uint256 updatedBucketAmount = bucketAmount.add(tokens);
293         require(updatedBucketAmount <= issuance);
294 
295         bucketAmount = updatedBucketAmount;
296     }
297 
298     function processPurchase(address beneficiary) internal returns(uint256) {
299         uint256 weiAmount = msg.value;
300 
301         // calculate token amount to be created
302         uint256 tokens = weiAmount.mul(rate);
303 
304         // update state
305         weiRaised = weiRaised.add(weiAmount);
306 
307         token.mint(beneficiary, tokens);
308         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
309 
310         forwardFunds();
311 
312         return tokens;
313     }
314 
315     function forwardFunds() internal {
316         wallet.transfer(msg.value);
317     }
318 }
319 
320 contract CappedCrowdsale is Crowdsale {
321   using SafeMath for uint256;
322 
323   uint256 public cap;
324 
325   function CappedCrowdsale(uint256 _cap) {
326     require(_cap > 0);
327     cap = _cap;
328   }
329 
330   // overriding Crowdsale#validPurchase to add extra cap logic
331   // @return true if investors can buy at the moment
332   function validPurchase() internal constant returns (bool) {
333     bool withinCap = weiRaised.add(msg.value) <= cap;
334     return super.validPurchase() && withinCap;
335   }
336 
337   // overriding Crowdsale#hasEnded to add cap logic
338   // @return true if crowdsale event has ended
339   function hasEnded() public constant returns (bool) {
340     bool capReached = weiRaised >= cap;
341     return super.hasEnded() || capReached;
342   }
343 
344 }
345 
346 contract MANAContinuousSale is ContinuousSale, Ownable {
347 
348     uint256 public constant INFLATION = 8;
349 
350     bool public started = false;
351 
352     event RateChange(uint256 amount);
353 
354     event WalletChange(address wallet);
355 
356     function MANAContinuousSale(
357         uint256 _rate,
358         address _wallet,
359         MintableToken _token
360     ) ContinuousSale(_rate, _wallet, _token) {
361     }
362 
363     modifier whenStarted() {
364         require(started);
365         _;
366     }
367 
368     function start() onlyOwner {
369         require(!started);
370 
371         // initialize issuance
372         uint256 finalSupply = token.totalSupply();
373         uint256 annualIssuance = finalSupply.mul(INFLATION).div(100);
374         issuance = annualIssuance.mul(BUCKET_SIZE).div(1 years);
375 
376         started = true;
377     }
378 
379     function buyTokens(address beneficiary) whenStarted public payable {
380         super.buyTokens(beneficiary);
381     }
382 
383     function setWallet(address _wallet) onlyOwner {
384         require(_wallet != 0x0);
385         wallet = _wallet;
386         WalletChange(_wallet);
387     }
388 
389     function setRate(uint256 _rate) onlyOwner {
390         rate = _rate;
391         RateChange(_rate);
392     }
393 
394     function unpauseToken() onlyOwner {
395         MANAToken(token).unpause();
396     }
397 
398     function pauseToken() onlyOwner {
399         MANAToken(token).pause();
400     }
401 }
402 
403 contract FinalizableCrowdsale is Crowdsale, Ownable {
404   using SafeMath for uint256;
405 
406   bool public isFinalized = false;
407 
408   event Finalized();
409 
410   // should be called after crowdsale ends, to do
411   // some extra finalization work
412   function finalize() onlyOwner {
413     require(!isFinalized);
414     require(hasEnded());
415 
416     finalization();
417     Finalized();
418     
419     isFinalized = true;
420   }
421 
422   // end token minting on finalization
423   // override this with custom logic if needed
424   function finalization() internal {
425     token.finishMinting();
426   }
427 
428 
429 
430 }
431 
432 contract StandardToken is ERC20, BasicToken {
433 
434   mapping (address => mapping (address => uint256)) allowed;
435 
436 
437   /**
438    * @dev Transfer tokens from one address to another
439    * @param _from address The address which you want to send tokens from
440    * @param _to address The address which you want to transfer to
441    * @param _value uint256 the amout of tokens to be transfered
442    */
443   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
444     var _allowance = allowed[_from][msg.sender];
445 
446     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
447     // require (_value <= _allowance);
448 
449     balances[_to] = balances[_to].add(_value);
450     balances[_from] = balances[_from].sub(_value);
451     allowed[_from][msg.sender] = _allowance.sub(_value);
452     Transfer(_from, _to, _value);
453     return true;
454   }
455 
456   /**
457    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
458    * @param _spender The address which will spend the funds.
459    * @param _value The amount of tokens to be spent.
460    */
461   function approve(address _spender, uint256 _value) returns (bool) {
462 
463     // To change the approve amount you first have to reduce the addresses`
464     //  allowance to zero by calling `approve(_spender, 0)` if it is not
465     //  already 0 to mitigate the race condition described here:
466     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
467     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
468 
469     allowed[msg.sender][_spender] = _value;
470     Approval(msg.sender, _spender, _value);
471     return true;
472   }
473 
474   /**
475    * @dev Function to check the amount of tokens that an owner allowed to a spender.
476    * @param _owner address The address which owns the funds.
477    * @param _spender address The address which will spend the funds.
478    * @return A uint256 specifing the amount of tokens still avaible for the spender.
479    */
480   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
481     return allowed[_owner][_spender];
482   }
483 
484 }
485 
486 contract BurnableToken is StandardToken {
487 
488     event Burn(address indexed burner, uint256 value);
489 
490     /**
491      * @dev Burns a specified amount of tokens.
492      * @param _value The amount of tokens to burn. 
493      */
494     function burn(uint256 _value) public {
495         require(_value > 0);
496 
497         address burner = msg.sender;
498         balances[burner] = balances[burner].sub(_value);
499         totalSupply = totalSupply.sub(_value);
500         Burn(msg.sender, _value);
501     }
502 
503 }
504 
505 contract Pausable is Ownable {
506   event Pause();
507   event Unpause();
508 
509   bool public paused = false;
510 
511 
512   /**
513    * @dev modifier to allow actions only when the contract IS paused
514    */
515   modifier whenNotPaused() {
516     require(!paused);
517     _;
518   }
519 
520   /**
521    * @dev modifier to allow actions only when the contract IS NOT paused
522    */
523   modifier whenPaused {
524     require(paused);
525     _;
526   }
527 
528   /**
529    * @dev called by the owner to pause, triggers stopped state
530    */
531   function pause() onlyOwner whenNotPaused returns (bool) {
532     paused = true;
533     Pause();
534     return true;
535   }
536 
537   /**
538    * @dev called by the owner to unpause, returns to normal state
539    */
540   function unpause() onlyOwner whenPaused returns (bool) {
541     paused = false;
542     Unpause();
543     return true;
544   }
545 }
546 
547 contract PausableToken is StandardToken, Pausable {
548 
549   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
550     return super.transfer(_to, _value);
551   }
552 
553   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
554     return super.transferFrom(_from, _to, _value);
555   }
556 }
557 
558 contract MintableToken is StandardToken, Ownable {
559   event Mint(address indexed to, uint256 amount);
560   event MintFinished();
561 
562   bool public mintingFinished = false;
563 
564 
565   modifier canMint() {
566     require(!mintingFinished);
567     _;
568   }
569 
570   /**
571    * @dev Function to mint tokens
572    * @param _to The address that will recieve the minted tokens.
573    * @param _amount The amount of tokens to mint.
574    * @return A boolean that indicates if the operation was successful.
575    */
576   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
577     totalSupply = totalSupply.add(_amount);
578     balances[_to] = balances[_to].add(_amount);
579     Mint(_to, _amount);
580     return true;
581   }
582 
583   /**
584    * @dev Function to stop minting new tokens.
585    * @return True if the operation was successful.
586    */
587   function finishMinting() onlyOwner returns (bool) {
588     mintingFinished = true;
589     MintFinished();
590     return true;
591   }
592 }
593 
594 contract MANAToken is BurnableToken, PausableToken, MintableToken {
595 
596     string public constant symbol = "MANA";
597 
598     string public constant name = "Decentraland MANA";
599 
600     uint8 public constant decimals = 18;
601 
602     function burn(uint256 _value) whenNotPaused public {
603         super.burn(_value);
604     }
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
636     function MANACrowdsale(
637         uint256 _startBlock,
638         uint256 _endBlock,
639         uint256 _initialRate,
640         uint256 _endRate,
641         uint256 _preferentialRate,
642         address _wallet
643     )
644         CappedCrowdsale(82888 ether)
645         WhitelistedCrowdsale()
646         FinalizableCrowdsale()
647         Crowdsale(_startBlock, _endBlock, _initialRate, _wallet)
648     {
649         require(_initialRate > 0);
650         require(_endRate > 0);
651         require(_preferentialRate > 0);
652 
653         initialRate = _initialRate;
654         endRate = _endRate;
655         preferentialRate = _preferentialRate;
656 
657         continuousSale = createContinuousSaleContract();
658 
659         MANAToken(token).pause();
660     }
661 
662     function createTokenContract() internal returns(MintableToken) {
663         return new MANAToken();
664     }
665 
666     function createContinuousSaleContract() internal returns(MANAContinuousSale) {
667         return new MANAContinuousSale(rate, wallet, token);
668     }
669 
670     function setBuyerRate(address buyer, uint256 rate) onlyOwner public {
671         require(rate != 0);
672         require(isWhitelisted(buyer));
673         require(block.number < startBlock);
674 
675         buyerRate[buyer] = rate;
676 
677         PreferentialRateChange(buyer, rate);
678     }
679 
680     function setInitialRate(uint256 rate) onlyOwner public {
681         require(rate != 0);
682         require(block.number < startBlock);
683 
684         initialRate = rate;
685 
686         InitialRateChange(rate);
687     }
688 
689     function setEndRate(uint256 rate) onlyOwner public {
690         require(rate != 0);
691         require(block.number < startBlock);
692 
693         endRate = rate;
694 
695         EndRateChange(rate);
696     }
697 
698     function getRate() internal returns(uint256) {
699         // some early buyers are offered a discount on the crowdsale price
700         if (buyerRate[msg.sender] != 0) {
701             return buyerRate[msg.sender];
702         }
703 
704         // whitelisted buyers can purchase at preferential price before crowdsale ends
705         if (isWhitelisted(msg.sender)) {
706             return preferentialRate;
707         }
708 
709         // otherwise compute the price for the auction
710         uint256 elapsed = block.number - startBlock;
711         uint256 rateRange = initialRate - endRate;
712         uint256 blockRange = endBlock - startBlock;
713 
714         return initialRate.sub(rateRange.mul(elapsed).div(blockRange));
715     }
716 
717     // low level token purchase function
718     function buyTokens(address beneficiary) payable {
719         require(beneficiary != 0x0);
720         require(validPurchase());
721 
722         uint256 weiAmount = msg.value;
723         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
724 
725         uint256 rate = getRate();
726         // calculate token amount to be created
727         uint256 tokens = weiAmount.mul(rate);
728 
729         // update state
730         weiRaised = updatedWeiRaised;
731 
732         token.mint(beneficiary, tokens);
733         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
734 
735         forwardFunds();
736     }
737 
738     function setWallet(address _wallet) onlyOwner public {
739         require(_wallet != 0x0);
740         wallet = _wallet;
741         continuousSale.setWallet(_wallet);
742         WalletChange(_wallet);
743     }
744 
745     function unpauseToken() onlyOwner {
746         require(isFinalized);
747         MANAToken(token).unpause();
748     }
749 
750     function pauseToken() onlyOwner {
751         require(isFinalized);
752         MANAToken(token).pause();
753     }
754 
755 
756     function beginContinuousSale() onlyOwner public {
757         require(isFinalized);
758 
759         token.transferOwnership(continuousSale);
760 
761         continuousSale.start();
762         continuousSale.transferOwnership(owner);
763     }
764 
765     function finalization() internal {
766         uint256 totalSupply = token.totalSupply();
767         uint256 finalSupply = TOTAL_SHARE.mul(totalSupply).div(CROWDSALE_SHARE);
768 
769         // emit tokens for the foundation
770         token.mint(wallet, FOUNDATION_SHARE.mul(finalSupply).div(TOTAL_SHARE));
771 
772         // NOTE: cannot call super here because it would finish minting and
773         // the continuous sale would not be able to proceed
774     }
775 
776 }