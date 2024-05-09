1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     if (_a == 0) {
16       return 0;
17     }
18 
19     uint256 c = _a * _b;
20     require(c / _a == _b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     require(_b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     require(_b <= _a);
41     uint256 c = _a - _b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     uint256 c = _a + _b;
51     require(c >= _a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 
66 /**
67  * @title SafeERC20
68  * @dev Wrappers around ERC20 operations that throw on failure.
69  */
70 library SafeERC20 {
71   function safeTransfer(
72     ERC20 _token,
73     address _to,
74     uint256 _value
75   )
76     internal
77   {
78     require(_token.transfer(_to, _value));
79   }
80 
81   function safeTransferFrom(
82     ERC20 _token,
83     address _from,
84     address _to,
85     uint256 _value
86   )
87     internal
88   {
89     require(_token.transferFrom(_from, _to, _value));
90   }
91 
92   function safeApprove(
93     ERC20 _token,
94     address _spender,
95     uint256 _value
96   )
97     internal
98   {
99     require(_token.approve(_spender, _value));
100   }
101 }
102 
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipRenounced(address indexed previousOwner);
108   event OwnershipTransferred(
109     address indexed previousOwner,
110     address indexed newOwner
111   );
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   constructor() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to relinquish control of the contract.
132    * @notice Renouncing to ownership will leave the contract without an owner.
133    * It will not be possible to call the functions with the `onlyOwner`
134    * modifier anymore.
135    */
136   function renounceOwnership() public onlyOwner {
137     emit OwnershipRenounced(owner);
138     owner = address(0);
139   }
140 
141   /**
142    * @dev Allows the current owner to transfer control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145   function transferOwnership(address _newOwner) public onlyOwner {
146     _transferOwnership(_newOwner);
147   }
148 
149   /**
150    * @dev Transfers control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function _transferOwnership(address _newOwner) internal {
154     require(_newOwner != address(0));
155     emit OwnershipTransferred(owner, _newOwner);
156     owner = _newOwner;
157 }
158 
159 }
160 
161 /**
162  * @title ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/20
164  */
165 contract ERC20 {
166   function totalSupply() public view returns (uint256);
167 
168   function balanceOf(address _who) public view returns (uint256);
169 
170   function allowance(address _owner, address _spender)
171     public view returns (uint256);
172 
173   function transfer(address _to, uint256 _value) public returns (bool);
174 
175   function approve(address _spender, uint256 _value)
176     public returns (bool);
177 
178   function transferFrom(address _from, address _to, uint256 _value)
179     public returns (bool);
180 
181   event Transfer(
182     address indexed from,
183     address indexed to,
184     uint256 value
185   );
186 
187   event Approval(
188     address indexed owner,
189     address indexed spender,
190     uint256 value
191   );
192 }
193 
194 contract AddressesFilterFeature is Ownable {}
195 contract ERC20Basic {}
196 contract BasicToken is ERC20Basic {}
197 contract StandardToken is ERC20, BasicToken {}
198 contract MintableToken is AddressesFilterFeature, StandardToken {}
199 
200 contract Token is MintableToken {
201       function mint(address, uint256) public returns (bool);
202 }
203 
204 
205 /**
206  * @title CrowdsaleWPTByAuction
207  * @dev This is a fully fledged crowdsale.
208 */
209 
210 contract CrowdsaleWPTByAuction is Ownable {
211   using SafeMath for uint256;
212   using SafeERC20 for ERC20;
213 
214   // The token being sold
215   ERC20 public token;
216 
217   // Address where funds are collected
218   address public wallet;
219 
220   // Address of tokens minter
221   Token public minterContract;
222 
223   // Amount of invested ETH
224   uint256 public ethRaised;
225 
226   // Array of investors and the amount of their investments
227   mapping (address => uint256) private _balances;
228 
229   // Array of investors
230   address[] public beneficiaryAddresses;
231 
232   // Cap for current round
233   uint256 public cap;
234 
235   // BonusCap for current round
236   uint256 public bonusCap;
237 
238   // Time ranges for current round
239   uint256 public openingTime;
240   uint256 public closingTime;
241 
242   //Minimal value of investment
243   uint public minInvestmentValue;
244 
245   //Flags to on/off checks for buy Token
246   bool public checksOn;
247 
248   //Amount of gas for internal transactions
249   uint256 public gasAmount;
250 
251   /**
252    * @dev Allows the owner to set the minter contract.
253    * @param _minterAddr the minter address
254    */
255   function setMinter(address _minterAddr) public onlyOwner {
256     minterContract = Token(_minterAddr);
257   }
258 
259   /**
260    * @dev Reverts if not in crowdsale time range.
261    */
262   modifier onlyWhileOpen {
263     // solium-disable-next-line security/no-block-members
264     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
265     _;
266   }
267 
268   /**
269   * @dev Gets the balance of the specified address.
270   * @param owner The address to query the balance of.
271   * @return An uint256 representing the amount owned by the passed address.
272   */
273   function balanceOf(address owner) public view returns (uint256) {
274     return _balances[owner];
275   }
276 
277   /**
278    * Event for token purchase logging
279    * @param purchaser who paid for the tokens
280    * @param beneficiary who got the tokens
281    * @param value weis paid for purchase
282    * @param amount amount of tokens purchased
283    */
284   event TokenPurchase(
285     address indexed purchaser,
286     address indexed beneficiary,
287     uint256 value,
288     uint256 amount
289     );
290 
291   /**
292    * Event for token transfer
293    * @param _from who paid for the tokens
294    * @param _to who got the tokens
295    * @param amount amount of tokens purchased
296    * @param isDone flag of success of transfer
297    */
298   event TokensTransfer(
299     address indexed _from,
300     address indexed _to,
301     uint256 amount,
302     bool isDone
303     );
304 
305 constructor () public {
306     wallet = 0xeA9cbceD36a092C596e9c18313536D0EEFacff46;
307     openingTime = 1537135200;
308     closingTime = 1538344800;
309     cap = 0;
310     bonusCap = 1000000000000000000000000; //1M WPT 
311     minInvestmentValue = 0.02 ether;
312     ethRaised = 0;
313         
314     checksOn = true;
315     gasAmount = 25000;
316   }
317 
318    /**
319    * @dev Close current round.
320    */
321   function closeRound() public onlyOwner {
322     closingTime = block.timestamp + 1;
323   }
324 
325    /**
326    * @dev Set token address.
327    */
328   function setToken(ERC20 _token) public onlyOwner {
329     token = _token;
330   }
331 
332    /**
333    * @dev Set address od deposit wallet.
334    */
335   function setWallet(address _wallet) public onlyOwner {
336     wallet = _wallet;
337   }
338 
339    /**
340    * @dev Change minimal amount of investment.
341    */
342   function changeMinInvest(uint256 newMinValue) public onlyOwner {
343     minInvestmentValue = newMinValue;
344   }
345 
346   /**
347    * @dev Flag to sell WPT without checks.
348    */
349   function setChecksOn(bool _checksOn) public onlyOwner {
350     checksOn = _checksOn;
351   }
352 
353    /**
354    * @dev Set amount of gas for internal transactions.
355    */
356   function setGasAmount(uint256 _gasAmount) public onlyOwner {
357     gasAmount = _gasAmount;
358   }
359   
360    /**
361    * @dev Set cap for current round.
362    */
363   function setCap(uint256 _newCap) public onlyOwner {
364     cap = _newCap;
365   }
366 
367    /**
368    * @dev Set bonusCap for current round.
369    */
370   function setBonusCap(uint256 _newBonusCap) public onlyOwner {
371     bonusCap = _newBonusCap;
372   }
373 
374    /**
375    * @dev Add new investor.
376    */
377   function addInvestor(address _beneficiary, uint8 amountOfinvestedEth) public onlyOwner {
378       _balances[_beneficiary] = amountOfinvestedEth;
379       beneficiaryAddresses.push(_beneficiary);
380   }
381 
382   /**
383    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
384    * @return Whether crowdsale period has elapsed
385    */
386   function hasClosed() public view returns (bool) {
387     // solium-disable-next-line security/no-block-members
388     return block.timestamp > closingTime;
389   }
390 
391   /**
392    * @dev Checks whether the period in which the crowdsale is open.
393    * @return Whether crowdsale period has opened
394    */
395   function hasOpened() public view returns (bool) {
396     // solium-disable-next-line security/no-block-members
397     return (openingTime < block.timestamp && block.timestamp < closingTime);
398   }
399 
400    /**
401    * @dev Start new crowdsale round with auction if already not started.
402    */
403   function startNewRound(address _wallet, ERC20 _token, uint256 _cap, uint256 _bonusCap, uint256 _openingTime, uint256 _closingTime) payable public onlyOwner {
404     require(!hasOpened());
405     wallet = _wallet;
406     token = _token;
407     cap = _cap;
408     bonusCap = _bonusCap;
409     openingTime = _openingTime;
410     closingTime = _closingTime;
411     ethRaised = 0;
412   }
413 
414    /**
415    * @dev Pay all bonuses to all investors from last round
416    */
417   function payAllBonuses() payable public onlyOwner {
418     require(hasClosed());
419 
420     uint256 allFunds = cap.add(bonusCap);
421     uint256 priceWPTperETH = allFunds.div(ethRaised);
422 
423     uint beneficiaryCount = beneficiaryAddresses.length;
424     for (uint i = 0; i < beneficiaryCount; i++) {
425       minterContract.mint(beneficiaryAddresses[i], _balances[beneficiaryAddresses[i]].mul(priceWPTperETH));
426       delete _balances[beneficiaryAddresses[i]];
427     }
428 
429     delete beneficiaryAddresses;
430     cap = 0;
431     bonusCap = 0;
432 
433   }
434 
435   // -----------------------------------------
436   // Crowdsale external interface
437   // -----------------------------------------
438 
439   /**
440    * @dev fallback function ***DO NOT OVERRIDE***
441    */
442   function () payable external {
443     buyTokens(msg.sender);
444   }
445 
446   /**
447    * @dev low level token purchase ***DO NOT OVERRIDE***
448    * @param _beneficiary Address performing the token purchase
449    */
450   function buyTokens(address _beneficiary) payable public{
451 
452     uint256 weiAmount = msg.value;
453     if (checksOn) {
454         _preValidatePurchase(_beneficiary, weiAmount);
455     }
456 
457     _balances[_beneficiary] = _balances[_beneficiary].add(weiAmount);
458     beneficiaryAddresses.push(_beneficiary);
459 
460     // update state
461     ethRaised = ethRaised.add(weiAmount);
462 
463     _forwardFunds();
464   }
465 
466   /**
467    * @dev Extend parent behavior requiring purchase to respect the funding cap.
468    * @param _beneficiary Token purchaser
469    * @param _weiAmount Amount of wei contributed
470    */
471   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
472   internal
473   view
474   onlyWhileOpen
475   {
476     require(_beneficiary != address(0));
477     require(_weiAmount != 0 && _weiAmount > minInvestmentValue);
478   }
479 
480   /**
481    * @dev Determines how ETH is stored/forwarded on purchases.
482    */
483   function _forwardFunds() internal {
484     bool isTransferDone = wallet.call.value(msg.value).gas(gasAmount)();
485     emit TokensTransfer (
486         msg.sender,
487         wallet,
488         msg.value,
489         isTransferDone
490         );
491   }
492 }
493 
494 //========================================================================
495 
496 contract CrowdsaleWPTByRounds is Ownable {
497   using SafeMath for uint256;
498   using SafeERC20 for ERC20;
499 
500   // The token being sold
501   ERC20 public token;
502 
503   // Address where funds are collected
504   address public wallet;
505 
506   // Address of tokens minter
507   Token public minterContract;
508 
509   // How many token units a buyer gets per wei.
510   // The rate is the conversion between wei and the smallest and indivisible token unit.
511   uint256 public rate;
512 
513   // Amount of tokens raised
514   uint256 public tokensRaised;
515 
516   // Cap for current round
517   uint256 public cap;
518 
519   // Time ranges for current round
520   uint256 public openingTime;
521   uint256 public closingTime;
522 
523   //Minimal value of investment
524   uint public minInvestmentValue;
525 
526   //Flags to on/off checks for buy Token
527   bool public checksOn;
528 
529   //Amount of gas for internal transactions
530   uint256 public gasAmount;
531 
532   /**
533    * @dev Allows the owner to set the minter contract.
534    * @param _minterAddr the minter address
535    */
536   function setMinter(address _minterAddr) public onlyOwner {
537     minterContract = Token(_minterAddr);
538   }
539 
540   /**
541    * @dev Reverts if not in crowdsale time range.
542    */
543   modifier onlyWhileOpen {
544     // solium-disable-next-line security/no-block-members
545     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
546     _;
547   }
548 
549   /**
550    * Event for token purchase logging
551    * @param purchaser who paid for the tokens
552    * @param beneficiary who got the tokens
553    * @param value weis paid for purchase
554    * @param amount amount of tokens purchased
555    */
556   event TokenPurchase(
557     address indexed purchaser,
558     address indexed beneficiary,
559     uint256 value,
560     uint256 amount
561     );
562 
563   /**
564    * Event for token transfer
565    * @param _from who paid for the tokens
566    * @param _to who got the tokens
567    * @param amount amount of tokens purchased
568    * @param isDone flag of success of transfer
569    */
570   event TokensTransfer(
571     address indexed _from,
572     address indexed _to,
573     uint256 amount,
574     bool isDone
575     );
576 
577 constructor () public {
578     rate = 400;
579     wallet = 0xeA9cbceD36a092C596e9c18313536D0EEFacff46;
580     cap = 400000000000000000000000;
581     openingTime = 1534558186;
582     closingTime = 1535320800;
583 
584     minInvestmentValue = 0.02 ether;
585         
586     checksOn = true;
587     gasAmount = 25000;
588   }
589 
590    /**
591    * @dev Checks whether the cap has been reached.
592    * @return Whether the cap was reached
593    */
594   function capReached() public view returns (bool) {
595     return tokensRaised >= cap;
596   }
597 
598    /**
599    * @dev Correction of current rate.
600    */
601   function changeRate(uint256 newRate) public onlyOwner {
602     rate = newRate;
603   }
604 
605    /**
606    * @dev Close current round.
607    */
608   function closeRound() public onlyOwner {
609     closingTime = block.timestamp + 1;
610   }
611 
612    /**
613    * @dev Set token address.
614    */
615   function setToken(ERC20 _token) public onlyOwner {
616     token = _token;
617   }
618 
619    /**
620    * @dev Set address od deposit wallet.
621    */
622   function setWallet(address _wallet) public onlyOwner {
623     wallet = _wallet;
624   }
625 
626    /**
627    * @dev Change minimal amount of investment.
628    */
629   function changeMinInvest(uint256 newMinValue) public onlyOwner {
630     minInvestmentValue = newMinValue;
631   }
632 
633   /**
634    * @dev Flag to sell WPT without checks.
635    */
636   function setChecksOn(bool _checksOn) public onlyOwner {
637     checksOn = _checksOn;
638   }
639 
640    /**
641    * @dev Set amount of gas for internal transactions.
642    */
643   function setGasAmount(uint256 _gasAmount) public onlyOwner {
644     gasAmount = _gasAmount;
645   }
646 
647    /**
648    * @dev Set cap for current round.
649    */
650   function setCap(uint256 _newCap) public onlyOwner {
651     cap = _newCap;
652   }
653 
654    /**
655    * @dev Start new crowdsale round if already not started.
656    */
657   function startNewRound(uint256 _rate, address _wallet, ERC20 _token, uint256 _cap, uint256 _openingTime, uint256 _closingTime) payable public onlyOwner {
658     require(!hasOpened());
659     rate = _rate;
660     wallet = _wallet;
661     token = _token;
662     cap = _cap;
663     openingTime = _openingTime;
664     closingTime = _closingTime;
665     tokensRaised = 0;
666   }
667 
668   /**
669    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
670    * @return Whether crowdsale period has elapsed
671    */
672   function hasClosed() public view returns (bool) {
673     // solium-disable-next-line security/no-block-members
674     return block.timestamp > closingTime;
675   }
676 
677   /**
678    * @dev Checks whether the period in which the crowdsale is open.
679    * @return Whether crowdsale period has opened
680    */
681   function hasOpened() public view returns (bool) {
682     // solium-disable-next-line security/no-block-members
683     return (openingTime < block.timestamp && block.timestamp < closingTime);
684   }
685 
686   // -----------------------------------------
687   // Crowdsale external interface
688   // -----------------------------------------
689 
690   /**
691    * @dev fallback function ***DO NOT OVERRIDE***
692    */
693   function () payable external {
694     buyTokens(msg.sender);
695   }
696 
697   /**
698    * @dev low level token purchase ***DO NOT OVERRIDE***
699    * @param _beneficiary Address performing the token purchase
700    */
701   function buyTokens(address _beneficiary) payable public{
702 
703     uint256 weiAmount = msg.value;
704     if (checksOn) {
705         _preValidatePurchase(_beneficiary, weiAmount);
706     }
707 
708     // calculate token amount to be created
709     uint256 tokens = _getTokenAmount(weiAmount);
710 
711     // update state
712     tokensRaised = tokensRaised.add(tokens);
713 
714     minterContract.mint(_beneficiary, tokens);
715     
716     emit TokenPurchase(
717       msg.sender,
718       _beneficiary,
719       weiAmount,
720       tokens
721     );
722 
723     _forwardFunds();
724   }
725 
726   /**
727    * @dev Extend parent behavior requiring purchase to respect the funding cap.
728    * @param _beneficiary Token purchaser
729    * @param _weiAmount Amount of wei contributed
730    */
731   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
732   internal
733   view
734   onlyWhileOpen
735   {
736     require(_beneficiary != address(0));
737     require(_weiAmount != 0 && _weiAmount > minInvestmentValue);
738     require(tokensRaised.add(_getTokenAmount(_weiAmount)) <= cap);
739   }
740 
741   /**
742    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
743    * @param _beneficiary Address performing the token purchase
744    * @param _tokenAmount Number of tokens to be emitted
745    */
746   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
747     token.safeTransfer(_beneficiary, _tokenAmount);
748   }
749 
750   /**
751    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
752    * @param _beneficiary Address receiving the tokens
753    * @param _tokenAmount Number of tokens to be purchased
754    */
755   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
756     _deliverTokens(_beneficiary, _tokenAmount);
757   }
758 
759   /**
760    * @dev Override to extend the way in which ether is converted to tokens.
761    * @param _weiAmount Value in wei to be converted into tokens
762    * @return Number of tokens that can be purchased with the specified _weiAmount
763    */
764   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
765     return _weiAmount.mul(rate);
766   }
767 
768   /**
769    * @dev Determines how ETH is stored/forwarded on purchases.
770    */
771   function _forwardFunds() internal {
772     bool isTransferDone = wallet.call.value(msg.value).gas(gasAmount)();
773     emit TokensTransfer (
774         msg.sender,
775         wallet,
776         msg.value,
777         isTransferDone
778         );
779   }
780 }