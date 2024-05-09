1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 /**
146  * @title ERC20 interface
147  * @dev see https://github.com/ethereum/EIPs/issues/20
148  */
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   uint256 totalSupply_;
166 
167   /**
168   * @dev total number of tokens in existence
169   */
170   function totalSupply() public view returns (uint256) {
171     return totalSupply_;
172   }
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
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
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 /**
297  * @title Mintable token
298  * @dev Simple ERC20 Token example, with mintable token creation
299  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
300  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
301  */
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply_ = totalSupply_.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     Mint(_to, _amount);
324     Transfer(address(0), _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner canMint public returns (bool) {
333     mintingFinished = true;
334     MintFinished();
335     return true;
336   }
337 }
338 
339 
340 /**
341  * @title Capped token
342  * @dev Mintable token with a token cap.
343  */
344 contract CappedToken is MintableToken {
345 
346   uint256 public cap;
347 
348   function CappedToken(uint256 _cap) public {
349     require(_cap > 0);
350     cap = _cap;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     require(totalSupply_.add(_amount) <= cap);
361 
362     return super.mint(_to, _amount);
363   }
364 
365 }
366 
367 /**
368  * @title Pausable token
369  * @dev StandardToken modified with pausable transfers.
370  **/
371 contract PausableToken is StandardToken, Pausable {
372 
373   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
374     return super.transfer(_to, _value);
375   }
376 
377   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
378     return super.transferFrom(_from, _to, _value);
379   }
380 
381   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
382     return super.approve(_spender, _value);
383   }
384 
385   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
386     return super.increaseApproval(_spender, _addedValue);
387   }
388 
389   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
390     return super.decreaseApproval(_spender, _subtractedValue);
391   }
392 } 
393 
394 /**
395  * @title Burnable Token
396  * @dev Token that can be irreversibly burned (destroyed).
397  */
398 contract BurnableToken is BasicToken {
399 
400   event Burn(address indexed burner, uint256 value);
401 
402   /**
403    * @dev Burns a specific amount of tokens.
404    * @param _value The amount of token to be burned.
405    */
406   function burn(uint256 _value) public {
407     require(_value <= balances[msg.sender]);
408     // no need to require value <= totalSupply, since that would imply the
409     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
410 
411     address burner = msg.sender;
412     balances[burner] = balances[burner].sub(_value);
413     totalSupply_ = totalSupply_.sub(_value);
414     Burn(burner, _value);
415     Transfer(burner, address(0), _value);
416   }
417 }
418 
419 /*
420   HardcapToken is PausableToken and on the creation it is paused.
421   It is made so because you don't want token to be transferable etc,
422   while your ico is not over.
423 */
424 contract HardcapToken is CappedToken, PausableToken, BurnableToken {
425 
426   uint256 private constant TOKEN_CAP = 100 * 10**24;
427 
428   string public constant name = "Welltrado token";
429   string public constant symbol = "WTL";
430   uint8 public constant decimals = 18;
431 
432   function HardcapToken() public CappedToken(TOKEN_CAP) {
433     paused = true;
434   }
435 }
436 
437 contract HardcapCrowdsale is Ownable {
438   using SafeMath for uint256;
439 
440   struct Phase {
441     uint256 capTo;
442     uint256 rate;
443   }
444 
445   uint256 private constant TEAM_PERCENTAGE = 10;
446   uint256 private constant PLATFORM_PERCENTAGE = 25;
447   uint256 private constant CROWDSALE_PERCENTAGE = 65;
448 
449   uint256 private constant MIN_TOKENS_TO_PURCHASE = 100 * 10**18;
450 
451   uint256 private constant ICO_TOKENS_CAP = 65 * 10**24;
452 
453   uint256 private constant FINAL_CLOSING_TIME = 1529928000;
454 
455   uint256 private constant INITIAL_START_DATE = 1524484800;
456 
457   uint256 public phase = 0;
458 
459   HardcapToken public token;
460 
461   address public wallet;
462   address public platform;
463   address public assigner;
464   address public teamTokenHolder;
465 
466   uint256 public weiRaised;
467 
468   bool public isFinalized = false;
469 
470   uint256 public openingTime = 1524484800;
471   uint256 public closingTime = 1525089600;
472   uint256 public finalizedTime;
473 
474   mapping (uint256 => Phase) private phases;
475 
476   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
477   event TokenAssigned(address indexed purchaser, address indexed beneficiary, uint256 amount);
478 
479 
480   event Finalized();
481 
482   modifier onlyAssginer() {
483     require(msg.sender == assigner);
484     _;
485   }
486 
487   function HardcapCrowdsale(address _wallet, address _platform, address _assigner, HardcapToken _token) public {
488       require(_wallet != address(0));
489       require(_assigner != address(0));
490       require(_platform != address(0));
491       require(_token != address(0));
492 
493       wallet = _wallet;
494       platform = _platform;
495       assigner = _assigner;
496       token = _token;
497 
498       // phases capTo means that totalSupply must reach it to change the phase
499       phases[0] = Phase(15 * 10**23, 1250);
500       phases[1] = Phase(10 * 10**24, 1200);
501       phases[2] = Phase(17 * 10**24, 1150);
502       phases[3] = Phase(24 * 10**24, 1100);
503       phases[4] = Phase(31 * 10**24, 1070);
504       phases[5] = Phase(38 * 10**24, 1050);
505       phases[6] = Phase(47 * 10**24, 1030);
506       phases[7] = Phase(56 * 10**24, 1000);
507       phases[8] = Phase(65 * 10**24, 1000);
508   }
509 
510   function () external payable {
511     buyTokens(msg.sender);
512   }
513 
514   /*
515     contract for teams tokens lockup
516   */
517   function setTeamTokenHolder(address _teamTokenHolder) onlyOwner public {
518     require(_teamTokenHolder != address(0));
519     // should allow set only once
520     require(teamTokenHolder == address(0));
521     teamTokenHolder = _teamTokenHolder;
522   }
523 
524   function buyTokens(address _beneficiary) public payable {
525     _processTokensPurchase(_beneficiary, msg.value);
526   }
527 
528   /*
529     It may be needed to assign tokens in batches if multiple clients invested
530     in any other crypto currency.
531     NOTE: this will fail if there are not enough tokens left for at least one investor.
532         for this to work all investors must get all their tokens.
533   */
534   function assignTokensToMultipleInvestors(address[] _beneficiaries, uint256[] _tokensAmount) onlyAssginer public {
535     require(_beneficiaries.length == _tokensAmount.length);
536     for (uint i = 0; i < _tokensAmount.length; i++) {
537       _processTokensAssgin(_beneficiaries[i], _tokensAmount[i]);
538     }
539   }
540 
541   /*
542     If investmend was made in bitcoins etc. owner can assign apropriate amount of
543     tokens to the investor.
544   */
545   function assignTokens(address _beneficiary, uint256 _tokensAmount) onlyAssginer public {
546     _processTokensAssgin(_beneficiary, _tokensAmount);
547   }
548 
549   function finalize() onlyOwner public {
550     require(teamTokenHolder != address(0));
551     require(!isFinalized);
552     require(_hasClosed());
553     require(finalizedTime == 0);
554 
555     HardcapToken _token = HardcapToken(token);
556 
557     // assign each counterparty their share
558     uint256 _tokenCap = _token.totalSupply().mul(100).div(CROWDSALE_PERCENTAGE);
559     require(_token.mint(teamTokenHolder, _tokenCap.mul(TEAM_PERCENTAGE).div(100)));
560     require(_token.mint(platform, _tokenCap.mul(PLATFORM_PERCENTAGE).div(100)));
561 
562     // mint and burn all leftovers
563     uint256 _tokensToBurn = _token.cap().sub(_token.totalSupply());
564     require(_token.mint(address(this), _tokensToBurn));
565     _token.burn(_tokensToBurn);
566 
567     require(_token.finishMinting());
568     _token.transferOwnership(wallet);
569 
570     Finalized();
571 
572     finalizedTime = _getTime();
573     isFinalized = true;
574   }
575 
576   function _hasClosed() internal view returns (bool) {
577     return _getTime() > FINAL_CLOSING_TIME || token.totalSupply() >= ICO_TOKENS_CAP;
578   }
579 
580   function _processTokensAssgin(address _beneficiary, uint256 _tokenAmount) internal {
581     _preValidateAssign(_beneficiary, _tokenAmount);
582 
583     // calculate token amount to be created
584     uint256 _leftowers = 0;
585     uint256 _tokens = 0;
586     uint256 _currentSupply = token.totalSupply();
587     bool _phaseChanged = false;
588     Phase memory _phase = phases[phase];
589 
590     while (_tokenAmount > 0 && _currentSupply < ICO_TOKENS_CAP) {
591       _leftowers = _phase.capTo.sub(_currentSupply);
592       // check if it is possible to assign more than there is available in this phase
593       if (_leftowers < _tokenAmount) {
594          _tokens = _tokens.add(_leftowers);
595          _tokenAmount = _tokenAmount.sub(_leftowers);
596          phase = phase + 1;
597          _phaseChanged = true;
598       } else {
599          _tokens = _tokens.add(_tokenAmount);
600          _tokenAmount = 0;
601       }
602 
603       _currentSupply = token.totalSupply().add(_tokens);
604       _phase = phases[phase];
605     }
606 
607     require(_tokens >= MIN_TOKENS_TO_PURCHASE || _currentSupply == ICO_TOKENS_CAP);
608 
609     // if phase changes forward the date of the next phase change by 7 days
610     if (_phaseChanged) {
611       _changeClosingTime();
612     }
613 
614     require(HardcapToken(token).mint(_beneficiary, _tokens));
615     TokenAssigned(msg.sender, _beneficiary, _tokens);
616   }
617 
618   function _processTokensPurchase(address _beneficiary, uint256 _weiAmount) internal {
619     _preValidatePurchase(_beneficiary, _weiAmount);
620 
621     // calculate token amount to be created
622     uint256 _leftowers = 0;
623     uint256 _weiReq = 0;
624     uint256 _weiSpent = 0;
625     uint256 _tokens = 0;
626     uint256 _currentSupply = token.totalSupply();
627     bool _phaseChanged = false;
628     Phase memory _phase = phases[phase];
629 
630     while (_weiAmount > 0 && _currentSupply < ICO_TOKENS_CAP) {
631       _leftowers = _phase.capTo.sub(_currentSupply);
632       _weiReq = _leftowers.div(_phase.rate);
633       // check if it is possible to purchase more than there is available in this phase
634       if (_weiReq < _weiAmount) {
635          _tokens = _tokens.add(_leftowers);
636          _weiAmount = _weiAmount.sub(_weiReq);
637          _weiSpent = _weiSpent.add(_weiReq);
638          phase = phase + 1;
639          _phaseChanged = true;
640       } else {
641          _tokens = _tokens.add(_weiAmount.mul(_phase.rate));
642          _weiSpent = _weiSpent.add(_weiAmount);
643          _weiAmount = 0;
644       }
645 
646       _currentSupply = token.totalSupply().add(_tokens);
647       _phase = phases[phase];
648     }
649 
650     require(_tokens >= MIN_TOKENS_TO_PURCHASE || _currentSupply == ICO_TOKENS_CAP);
651 
652     // if phase changes forward the date of the next phase change by 7 days
653     if (_phaseChanged) {
654       _changeClosingTime();
655     }
656 
657     // return leftovers to investor if tokens are over but he sent more ehters.
658     if (msg.value > _weiSpent) {
659       uint256 _overflowAmount = msg.value.sub(_weiSpent);
660       _beneficiary.transfer(_overflowAmount);
661     }
662 
663     weiRaised = weiRaised.add(_weiSpent);
664 
665     require(HardcapToken(token).mint(_beneficiary, _tokens));
666     TokenPurchase(msg.sender, _beneficiary, _weiSpent, _tokens);
667 
668     // You can access this method either buying tokens or assigning tokens to
669     // someone. In the previous case you won't be sending any ehter to contract
670     // so no need to forward any funds to wallet.
671     if (msg.value > 0) {
672       wallet.transfer(_weiSpent);
673     }
674   }
675 
676   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
677     // if the phase time ended calculate next phase end time and set new phase
678     if (closingTime < _getTime() && closingTime < FINAL_CLOSING_TIME && phase < 8) {
679       phase = phase.add(_calcPhasesPassed());
680       _changeClosingTime();
681 
682     }
683     require(_getTime() > INITIAL_START_DATE);
684     require(_getTime() >= openingTime && _getTime() <= closingTime);
685     require(_beneficiary != address(0));
686     require(_weiAmount != 0);
687     require(phase <= 8);
688 
689     require(token.totalSupply() < ICO_TOKENS_CAP);
690     require(!isFinalized);
691   }
692 
693   function _preValidateAssign(address _beneficiary, uint256 _tokenAmount) internal {
694     // if the phase time ended calculate next phase end time and set new phase
695     if (closingTime < _getTime() && closingTime < FINAL_CLOSING_TIME && phase < 8) {
696       phase = phase.add(_calcPhasesPassed());
697       _changeClosingTime();
698 
699     }
700     // should not allow to assign tokens to team members
701     require(_beneficiary != assigner);
702     require(_beneficiary != platform);
703     require(_beneficiary != wallet);
704     require(_beneficiary != teamTokenHolder);
705 
706     require(_getTime() >= openingTime && _getTime() <= closingTime);
707     require(_beneficiary != address(0));
708     require(_tokenAmount > 0);
709     require(phase <= 8);
710 
711     require(token.totalSupply() < ICO_TOKENS_CAP);
712     require(!isFinalized);
713   }
714 
715   function _changeClosingTime() internal {
716     closingTime = _getTime() + 7 days;
717     if (closingTime > FINAL_CLOSING_TIME) {
718       closingTime = FINAL_CLOSING_TIME;
719     }
720   }
721 
722   function _calcPhasesPassed() internal view returns(uint256) {
723     return  _getTime().sub(closingTime).div(7 days).add(1);
724   }
725 
726  function _getTime() internal view returns (uint256) {
727    return now;
728  }
729 
730 }
731 
732 contract TeamTokenHolder is Ownable {
733   using SafeMath for uint256;
734 
735   uint256 private LOCKUP_TIME = 24; // in months
736 
737   HardcapCrowdsale crowdsale;
738   HardcapToken token;
739   uint256 public collectedTokens;
740 
741   function TeamTokenHolder(address _owner, address _crowdsale, address _token) public {
742     owner = _owner;
743     crowdsale = HardcapCrowdsale(_crowdsale);
744     token = HardcapToken(_token);
745   }
746 
747   /*
748     @notice The Dev (Owner) will call this method to extract the tokens
749   */
750   function collectTokens() public onlyOwner {
751     uint256 balance = token.balanceOf(address(this));
752     uint256 total = collectedTokens.add(balance);
753 
754     uint256 finalizedTime = crowdsale.finalizedTime();
755 
756     require(finalizedTime > 0 && getTime() >= finalizedTime.add(months(3)));
757 
758     uint256 canExtract = total.mul(getTime().sub(finalizedTime)).div(months(LOCKUP_TIME));
759 
760     canExtract = canExtract.sub(collectedTokens);
761 
762     if (canExtract > balance) {
763       canExtract = balance;
764     }
765 
766     collectedTokens = collectedTokens.add(canExtract);
767     assert(token.transfer(owner, canExtract));
768 
769     TokensWithdrawn(owner, canExtract);
770   }
771 
772   function months(uint256 m) internal pure returns (uint256) {
773       return m.mul(30 days);
774   }
775 
776   function getTime() internal view returns (uint256) {
777     return now;
778   }
779 
780   /*
781      Safety Methods
782   */
783 
784   /*
785      @notice This method can be used by the controller to extract mistakenly
786      sent tokens to this contract.
787      @param _token The address of the token contract that you want to recover
788      set to 0 in case you want to extract ether.
789   */
790   function claimTokens(address _token) public onlyOwner {
791     require(_token != address(token));
792     if (_token == 0x0) {
793       owner.transfer(this.balance);
794       return;
795     }
796 
797     HardcapToken _hardcapToken = HardcapToken(_token);
798     uint256 balance = _hardcapToken.balanceOf(this);
799     _hardcapToken.transfer(owner, balance);
800     ClaimedTokens(_token, owner, balance);
801   }
802 
803   event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
804   event TokensWithdrawn(address indexed _holder, uint256 _amount);
805 }