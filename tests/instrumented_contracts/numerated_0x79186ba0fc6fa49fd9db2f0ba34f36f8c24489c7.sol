1 pragma solidity ^0.4.18;
2 
3 /**
4  * Libraries
5  */
6 
7 
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
51  * Helper contracts
52  */
53 
54 
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Pausable is Ownable {
91   event Pause();
92   event Unpause();
93 
94   bool public paused = false;
95 
96 
97   /**
98    * @dev Modifier to make a function callable only when the contract is not paused.
99    */
100   modifier whenNotPaused() {
101     require(!paused);
102     _;
103   }
104 
105   /**
106    * @dev Modifier to make a function callable only when the contract is paused.
107    */
108   modifier whenPaused() {
109     require(paused);
110     _;
111   }
112 
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() onlyOwner whenNotPaused public {
117     paused = true;
118     Pause();
119   }
120 
121   /**
122    * @dev called by the owner to unpause, returns to normal state
123    */
124   function unpause() onlyOwner whenPaused public {
125     paused = false;
126     Unpause();
127   }
128 }
129 
130 contract Destructible is Ownable {
131 
132   function Destructible() public payable { }
133 
134   /**
135    * @dev Transfers the current balance to the owner and terminates the contract.
136    */
137   function destroy() onlyOwner public {
138     selfdestruct(owner);
139   }
140 
141   function destroyAndSend(address _recipient) onlyOwner public {
142     selfdestruct(_recipient);
143   }
144 }
145 
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) public view returns (uint256);
155   function transferFrom(address from, address to, uint256 value) public returns (bool);
156   function approve(address spender, uint256 value) public returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 contract DetailedERC20 is ERC20 {
161   string public name;
162   string public symbol;
163   uint8 public decimals;
164 
165   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
166     name = _name;
167     symbol = _symbol;
168     decimals = _decimals;
169   }
170 }
171 
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191   function transfer(address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[msg.sender]);
194 
195     // SafeMath.sub will throw if there is not enough balance.
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203   * @dev Gets the balance of the specified address.
204   * @param _owner The address to query the the balance of.
205   * @return An uint256 representing the amount owned by the passed address.
206   */
207   function balanceOf(address _owner) public view returns (uint256 balance) {
208     return balances[_owner];
209   }
210 
211 }
212 
213 contract BurnableToken is BasicToken {
214 
215   event Burn(address indexed burner, uint256 value);
216 
217   /**
218    * @dev Burns a specific amount of tokens.
219    * @param _value The amount of token to be burned.
220    */
221   function burn(uint256 _value) public {
222     require(_value <= balances[msg.sender]);
223     // no need to require value <= totalSupply, since that would imply the
224     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
225 
226     address burner = msg.sender;
227     balances[burner] = balances[burner].sub(_value);
228     totalSupply_ = totalSupply_.sub(_value);
229     Burn(burner, _value);
230   }
231 }
232 
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
245     require(_to != address(0));
246     require(_value <= balances[_from]);
247     require(_value <= allowed[_from][msg.sender]);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public view returns (uint256) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * @dev Increase the amount of tokens that an owner allowed to a spender.
284    *
285    * approve should be called when allowed[_spender] == 0. To increment
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _addedValue The amount of tokens to increase the allowance by.
291    */
292   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
293     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298   /**
299    * @dev Decrease the amount of tokens that an owner allowed to a spender.
300    *
301    * approve should be called when allowed[_spender] == 0. To decrement
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param _spender The address which will spend the funds.
306    * @param _subtractedValue The amount of tokens to decrease the allowance by.
307    */
308   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
309     uint oldValue = allowed[msg.sender][_spender];
310     if (_subtractedValue > oldValue) {
311       allowed[msg.sender][_spender] = 0;
312     } else {
313       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
314     }
315     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 }
320 
321 /**
322  * Proxy
323  */
324 
325 contract Proxy is Ownable, Destructible, Pausable {
326     // crowdsale contract
327     Crowdsale public crowdsale;
328 
329     function Proxy(Crowdsale _crowdsale) public {
330         setCrowdsale(_crowdsale);
331     }
332 
333     function setCrowdsale(address _crowdsale) onlyOwner public {
334         require(_crowdsale != address(0));
335         crowdsale = Crowdsale(_crowdsale);
336     }
337 
338     function () external whenNotPaused payable {
339         // buy tokens from crowdsale
340         crowdsale.buyTokens.value(msg.value)(msg.sender);
341     }
342 }
343 
344 /**
345  * Proxy
346  */
347 
348 contract Referral is Ownable, Destructible, Pausable {
349     using SafeMath for uint256;
350 
351     Crowdsale public crowdsale;
352     Token public token;
353 
354     address public beneficiary;
355 
356     function Referral(address _crowdsale, address _token, address _beneficiary) public {
357         setCrowdsale(_crowdsale);
358         setToken(_token);
359         setBeneficiary(_beneficiary);
360     }
361 
362     function setCrowdsale(address _crowdsale) onlyOwner public {
363         require(_crowdsale != address(0));
364         crowdsale = Crowdsale(_crowdsale);
365     }
366 
367     function setToken(address _token) onlyOwner public {
368         require(_token != address(0));
369         token = Token(_token);
370     }
371 
372     function setBeneficiary(address _beneficiary) onlyOwner public {
373         require(_beneficiary != address(0));
374         beneficiary = _beneficiary;
375     }
376 
377     function () external whenNotPaused payable {
378         uint256 tokens = crowdsale.buyTokens.value(msg.value)(this);
379 
380         uint256 baseAmount = crowdsale.getBaseAmount(msg.value);
381         uint256 refTokens = baseAmount.div(10);
382 
383         // send 10% to referral
384         token.transfer(beneficiary, refTokens);
385 
386         // remove 10%
387         tokens = tokens.sub(refTokens);
388 
389         // send eth to buyer
390         token.transfer(msg.sender, tokens);
391     }
392 }
393 
394 /**
395  * CCOS Token
396  */
397 
398 contract Token is StandardToken, BurnableToken, DetailedERC20, Destructible {
399     function Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply)
400         DetailedERC20(_name, _symbol, _decimals) public
401         {
402 
403         // covert to ether
404         _totalSupply = _totalSupply;
405 
406         totalSupply_ = _totalSupply;
407 
408         // give moneyz to us
409         balances[msg.sender] = totalSupply_;
410 
411         // first event
412         Transfer(0x0, msg.sender, totalSupply_);
413     }
414 }
415 
416 /**
417  * CCOS Crowdsale
418  */
419 
420 contract Crowdsale is Ownable, Pausable, Destructible {
421     using SafeMath for uint256;
422 
423     struct Vault {
424         uint256 tokenAmount;
425         uint256 weiValue;
426         address referralBeneficiary;
427     }
428 
429     struct CustomContract {
430         bool isReferral;
431         bool isSpecial;
432         address referralAddress;
433     }
434 
435     // Manual kill switch
436     bool crowdsaleConcluded = false;
437 
438     // The token being sold
439     Token public token;
440 
441     // start and end timestamps where investments are allowed (both inclusive)
442     uint256 public startTime;
443     uint256 public endTime;
444 
445     // minimum investment
446     uint256 minimum_invest = 100000000000000;
447 
448     // regular bonus amounts
449     uint256 week_1 = 20;
450     uint256 week_2 = 15;
451     uint256 week_3 = 10;
452     uint256 week_4 = 0;
453 
454     // custom bonus amounts
455     uint256 week_special_1 = 40;
456     uint256 week_special_2 = 15;
457     uint256 week_special_3 = 10;
458     uint256 week_special_4 = 0;
459 
460     uint256 week_referral_1 = 25;
461     uint256 week_referral_2 = 20;
462     uint256 week_referral_3 = 15;
463     uint256 week_referral_4 = 5;
464 
465     // bonus ducks
466     mapping (address => CustomContract) public customBonuses;
467 
468     // address where funds are collected
469     address public wallet;
470 
471     // how many token units a buyer gets per wei
472     uint256 public rate;
473 
474     // amount of raised in wei
475     uint256 public weiRaised;
476     uint256 public tokensSold;
477 
478     // amount on hold for KYC
479     uint256 public tokensOnHold;
480 
481     // high-ballers
482     mapping(address => Vault) ballers;
483 
484     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
485 
486     function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
487         require(_endTime >= _startTime);
488         require(_rate > 0);
489         require(_wallet != address(0));
490         require(_token != address(0));
491 
492         startTime = _startTime;
493         endTime = _endTime;
494         rate = _rate;
495         wallet = _wallet;
496         token = Token(_token);
497     }
498 
499     // fallback function can be used to buy tokens
500     function () external whenNotPaused payable {
501         buyTokens(msg.sender);
502     }
503 
504     // low level token purchase function
505     function buyTokens(address _beneficiary) public whenNotPaused payable returns (uint256) {
506         require(!hasEnded());
507 
508         // minimum investment
509         require(minimum_invest <= msg.value);
510 
511         address beneficiary = _beneficiary;
512 
513         require(beneficiary != address(0));
514         require(validPurchase());
515 
516         uint256 weiAmount = msg.value;
517 
518         // calculate token amount to be sent
519         var tokens = getTokenAmount(weiAmount);
520 
521         // if we run out of tokens
522         bool isLess = false;
523         if (!hasEnoughTokensLeft(weiAmount)) {
524             isLess = true;
525 
526             uint256 percentOfValue = tokensLeft().mul(100).div(tokens);
527             require(percentOfValue <= 100);
528 
529             tokens = tokens.mul(percentOfValue).div(100);
530             weiAmount = weiAmount.mul(percentOfValue).div(100);
531 
532             // send back unused ethers
533             beneficiary.transfer(msg.value.sub(weiAmount));
534         }
535 
536         // update raised ETH amount
537         weiRaised = weiRaised.add(weiAmount);
538         tokensSold = tokensSold.add(tokens);
539 
540         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
541 
542         // Require a KYC, but tokens on hold
543         if ((11 ether) <= weiAmount) {
544             // we have a KYC requirement
545             // add tokens to his/her vault to release/refund manually afterawards
546 
547             tokensOnHold = tokensOnHold.add(tokens);
548 
549             ballers[beneficiary].tokenAmount += tokens;
550             ballers[beneficiary].weiValue += weiAmount;
551             ballers[beneficiary].referralBeneficiary = address(0);
552 
553             // set referral address if referral contract
554             if (customBonuses[msg.sender].isReferral == true) {
555               ballers[beneficiary].referralBeneficiary = customBonuses[msg.sender].referralAddress;
556             }
557 
558             return (0);
559         }
560 
561         token.transfer(beneficiary, tokens);
562 
563         forwardFunds(weiAmount);
564 
565         if (isLess == true) {
566           return (tokens);
567         }
568         return (tokens);
569     }
570 
571     /**
572      * Release / Refund logics
573      */
574 
575     function viewFunds(address _wallet) public view returns (uint256) {
576         return ballers[_wallet].tokenAmount;
577     }
578 
579     function releaseFunds(address _wallet) onlyOwner public {
580         require(ballers[_wallet].tokenAmount > 0);
581         require(ballers[_wallet].weiValue <= this.balance);
582 
583         // held tokens count for this buyer
584         uint256 tokens = ballers[_wallet].tokenAmount;
585 
586         // remove from tokens on hold
587         tokensOnHold = tokensOnHold.sub(tokens);
588 
589         // transfer ether to our wallet
590         forwardFunds(ballers[_wallet].weiValue);
591 
592         // if it's a referral release give bonus tokens to referral
593         if (ballers[_wallet].referralBeneficiary != address(0)) {
594           uint256 refTokens = tokens.mul(10).div(100);
595           token.transfer(ballers[_wallet].referralBeneficiary, refTokens);
596 
597           // subtract referral tokens from total
598           tokens = tokens.sub(refTokens);
599         }
600 
601         // send tokens to buyer
602         token.transfer(_wallet, tokens);
603 
604 
605         // reset vault
606         ballers[_wallet].tokenAmount = 0;
607         ballers[_wallet].weiValue = 0;
608     }
609 
610     function refundFunds(address _wallet) onlyOwner public {
611         require(ballers[_wallet].tokenAmount > 0);
612         require(ballers[_wallet].weiValue <= this.balance);
613 
614         // remove from tokens on hold
615         tokensOnHold = tokensOnHold.sub(ballers[_wallet].tokenAmount);
616 
617         _wallet.transfer(ballers[_wallet].weiValue);
618 
619         weiRaised = weiRaised.sub(ballers[_wallet].weiValue);
620         tokensSold = tokensSold.sub(ballers[_wallet].tokenAmount);
621 
622         ballers[_wallet].tokenAmount = 0;
623         ballers[_wallet].weiValue = 0;
624     }
625 
626     /**
627      * Editors
628      */
629 
630     function addOldInvestment(address _beneficiary, uint256 _weiAmount, uint256 _tokensWithDecimals) onlyOwner public {
631       require(_beneficiary != address(0));
632 
633       // update sold tokens amount
634       weiRaised = weiRaised.add(_weiAmount);
635       tokensSold = tokensSold.add(_tokensWithDecimals);
636 
637       token.transfer(_beneficiary, _tokensWithDecimals);
638 
639       TokenPurchase(msg.sender, _beneficiary, _weiAmount, _tokensWithDecimals);
640     }
641 
642     function setCustomBonus(address _contract, bool _isReferral, bool _isSpecial, address _referralAddress) onlyOwner public {
643       require(_contract != address(0));
644 
645       customBonuses[_contract] = CustomContract({
646           isReferral: _isReferral,
647           isSpecial: _isSpecial,
648           referralAddress: _referralAddress
649       });
650     }
651 
652     function addOnHold(uint256 _amount) onlyOwner public {
653       tokensOnHold = tokensOnHold.add(_amount);
654     }
655 
656     function subOnHold(uint256 _amount) onlyOwner public {
657       tokensOnHold = tokensOnHold.sub(_amount);
658     }
659 
660     function setMinInvestment(uint256 _investment) onlyOwner public {
661       require(_investment > 0);
662       minimum_invest = _investment;
663     }
664 
665     function changeEndTime(uint256 _endTime) onlyOwner public {
666         require(_endTime > startTime);
667         endTime = _endTime;
668     }
669 
670     function changeStartTime(uint256 _startTime) onlyOwner public {
671         require(endTime > _startTime);
672         startTime = _startTime;
673     }
674 
675     function setWallet(address _wallet) onlyOwner public {
676         require(_wallet != address(0));
677         wallet = _wallet;
678     }
679 
680     function setToken(address _token) onlyOwner public {
681         require(_token != address(0));
682         token = Token(_token);
683     }
684 
685     /**
686      * End crowdsale manually
687      */
688 
689     function endSale() onlyOwner public {
690       // close crowdsale
691       crowdsaleConcluded = true;
692 
693       // burn all tokens left
694       token.burn(token.balanceOf(this));
695     }
696 
697     /**
698      * When at risk, evacuate tokens
699      */
700 
701     function evacuateTokens(address _wallet) onlyOwner public {
702       require(_wallet != address(0));
703       token.transfer(_wallet, token.balanceOf(this));
704     }
705 
706     /**
707      * Calculations
708      */
709 
710     // @return true if crowdsale event has ended
711     function hasEnded() public view returns (bool) {
712         return now > endTime || token.balanceOf(this) == 0 || crowdsaleConcluded;
713     }
714 
715     function getBaseAmount(uint256 _weiAmount) public view returns (uint256) {
716         return _weiAmount.mul(rate);
717     }
718 
719     // Override this method to have a way to add business logic to your crowdsale when buying
720     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
721         uint256 tokens = getBaseAmount(_weiAmount);
722         uint256 percentage = 0;
723 
724          // Special bonuses
725         if (customBonuses[msg.sender].isSpecial == true) {
726 
727           if ( startTime <= now && now < startTime + 7 days ) {
728             percentage = week_special_1;
729           } else if ( startTime + 7 days <= now && now < startTime + 14 days ) {
730             percentage = week_special_2;
731           } else if ( startTime + 14 days <= now && now < startTime + 21 days ) {
732             percentage = week_special_3;
733           } else if ( startTime + 21 days <= now && now <= endTime ) {
734             percentage = week_special_4;
735           }
736 
737         // Regular bonuses
738         } else {
739 
740           if ( startTime <= now && now < startTime + 7 days ) {
741             percentage = week_1;
742           } else if ( startTime + 7 days <= now && now < startTime + 14 days ) {
743             percentage = week_2;
744           } else if ( startTime + 14 days <= now && now < startTime + 21 days ) {
745             percentage = week_3;
746           } else if ( startTime + 21 days <= now && now <= endTime ) {
747             percentage = week_4;
748           }
749 
750           // Referral bonuses
751           if (customBonuses[msg.sender].isReferral == true) {
752             percentage += 15; // 5 for buyer, 10 for referrer
753           }
754 
755         }
756 
757         // Large contributors
758         if (msg.value >= 50 ether) {
759           percentage += 80;
760         } else if (msg.value >= 30 ether) {
761           percentage += 70;
762         } else if (msg.value >= 10 ether) {
763           percentage += 50;
764         } else if (msg.value >= 5 ether) {
765           percentage += 30;
766         } else if (msg.value >= 3 ether) {
767           percentage += 10;
768         }
769 
770         tokens += tokens.mul(percentage).div(100);
771 
772         assert(tokens > 0);
773 
774         return (tokens);
775     }
776 
777     // send ether to the fund collection wallet
778     function forwardFunds(uint256 _amount) internal {
779         wallet.transfer(_amount);
780     }
781 
782     // @return true if the transaction can buy tokens
783     function validPurchase() internal view returns (bool) {
784         bool withinPeriod = now >= startTime && now <= endTime;
785         bool nonZeroPurchase = msg.value != 0;
786         return withinPeriod && nonZeroPurchase;
787     }
788 
789     function tokensLeft() public view returns (uint256) {
790         return token.balanceOf(this).sub(tokensOnHold);
791     }
792 
793     function hasEnoughTokensLeft(uint256 _weiAmount) public payable returns (bool) {
794         return tokensLeft().sub(_weiAmount) >= getBaseAmount(_weiAmount);
795     }
796 }