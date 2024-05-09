1 pragma solidity ^0.4.24;
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
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
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
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * See https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address _who) public view returns (uint256);
123   function transfer(address _to, uint256 _value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) internal balances;
135 
136   uint256 internal totalSupply_;
137 
138   /**
139   * @dev Total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_value <= balances[msg.sender]);
152     require(_to != address(0));
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address _owner, address _spender)
177     public view returns (uint256);
178 
179   function transferFrom(address _from, address _to, uint256 _value)
180     public returns (bool);
181 
182   function approve(address _spender, uint256 _value) public returns (bool);
183   event Approval(
184     address indexed owner,
185     address indexed spender,
186     uint256 value
187   );
188 }
189 
190 /**
191  * @title SafeERC20
192  * @dev Wrappers around ERC20 operations that throw on failure.
193  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
194  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
195  */
196 library SafeERC20 {
197   function safeTransfer(
198     ERC20Basic _token,
199     address _to,
200     uint256 _value
201   )
202     internal
203   {
204     require(_token.transfer(_to, _value));
205   }
206 
207   function safeTransferFrom(
208     ERC20 _token,
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     internal
214   {
215     require(_token.transferFrom(_from, _to, _value));
216   }
217 
218   function safeApprove(
219     ERC20 _token,
220     address _spender,
221     uint256 _value
222   )
223     internal
224   {
225     require(_token.approve(_spender, _value));
226   }
227 }
228 
229 
230 /**
231  * @title Standard ERC20 token
232  *
233  * @dev Implementation of the basic standard token.
234  * https://github.com/ethereum/EIPs/issues/20
235  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
236  */
237 contract StandardToken is ERC20, BasicToken {
238 
239   mapping (address => mapping (address => uint256)) internal allowed;
240 
241 
242   /**
243    * @dev Transfer tokens from one address to another
244    * @param _from address The address which you want to send tokens from
245    * @param _to address The address which you want to transfer to
246    * @param _value uint256 the amount of tokens to be transferred
247    */
248   function transferFrom(
249     address _from,
250     address _to,
251     uint256 _value
252   )
253     public
254     returns (bool)
255   {
256     require(_value <= balances[_from]);
257     require(_value <= allowed[_from][msg.sender]);
258     require(_to != address(0));
259 
260     balances[_from] = balances[_from].sub(_value);
261     balances[_to] = balances[_to].add(_value);
262     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263     emit Transfer(_from, _to, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
269    * Beware that changing an allowance with this method brings the risk that someone may use both the old
270    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
271    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
272    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
273    * @param _spender The address which will spend the funds.
274    * @param _value The amount of tokens to be spent.
275    */
276   function approve(address _spender, uint256 _value) public returns (bool) {
277     allowed[msg.sender][_spender] = _value;
278     emit Approval(msg.sender, _spender, _value);
279     return true;
280   }
281 
282   /**
283    * @dev Function to check the amount of tokens that an owner allowed to a spender.
284    * @param _owner address The address which owns the funds.
285    * @param _spender address The address which will spend the funds.
286    * @return A uint256 specifying the amount of tokens still available for the spender.
287    */
288   function allowance(
289     address _owner,
290     address _spender
291    )
292     public
293     view
294     returns (uint256)
295   {
296     return allowed[_owner][_spender];
297   }
298 
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    * approve should be called when allowed[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param _spender The address which will spend the funds.
306    * @param _addedValue The amount of tokens to increase the allowance by.
307    */
308   function increaseApproval(
309     address _spender,
310     uint256 _addedValue
311   )
312     public
313     returns (bool)
314   {
315     allowed[msg.sender][_spender] = (
316       allowed[msg.sender][_spender].add(_addedValue));
317     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318     return true;
319   }
320 
321   /**
322    * @dev Decrease the amount of tokens that an owner allowed to a spender.
323    * approve should be called when allowed[_spender] == 0. To decrement
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param _spender The address which will spend the funds.
328    * @param _subtractedValue The amount of tokens to decrease the allowance by.
329    */
330   function decreaseApproval(
331     address _spender,
332     uint256 _subtractedValue
333   )
334     public
335     returns (bool)
336   {
337     uint256 oldValue = allowed[msg.sender][_spender];
338     if (_subtractedValue >= oldValue) {
339       allowed[msg.sender][_spender] = 0;
340     } else {
341       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
342     }
343     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
344     return true;
345   }
346 
347 }
348 
349 /**
350  * @title Mintable token
351  * @dev Simple ERC20 Token example, with mintable token creation
352  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
353  */
354 contract MintableToken is StandardToken, Ownable {
355   event Mint(address indexed to, uint256 amount);
356   event MintFinished();
357 
358   bool public mintingFinished = false;
359 
360 
361   modifier canMint() {
362     require(!mintingFinished);
363     _;
364   }
365 
366   modifier hasMintPermission() {
367     require(msg.sender == owner);
368     _;
369   }
370 
371   /**
372    * @dev Function to mint tokens
373    * @param _to The address that will receive the minted tokens.
374    * @param _amount The amount of tokens to mint.
375    * @return A boolean that indicates if the operation was successful.
376    */
377   function mint(
378     address _to,
379     uint256 _amount
380   )
381     public
382     hasMintPermission
383     canMint
384     returns (bool)
385   {
386     totalSupply_ = totalSupply_.add(_amount);
387     balances[_to] = balances[_to].add(_amount);
388     emit Mint(_to, _amount);
389     emit Transfer(address(0), _to, _amount);
390     return true;
391   }
392 
393   /**
394    * @dev Function to stop minting new tokens.
395    * @return True if the operation was successful.
396    */
397   function finishMinting() public onlyOwner canMint returns (bool) {
398     mintingFinished = true;
399     emit MintFinished();
400     return true;
401   }
402 }
403 
404 
405 /**
406  * @title MintAndBurnToken
407  *
408  * @dev StandardToken that is mintable and burnable
409  */
410 contract MintAndBurnToken is MintableToken {
411 
412   // -----------------------------------
413   // BURN FUNCTIONS
414   // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
415   // -----------------------------------
416 
417   event Burn(address indexed burner, uint256 value);
418 
419   /**
420    * @dev Burns a specific amount of tokens.
421    * @param _value The amount of token to be burned.
422    */
423   function burn(uint256 _value) public {
424     _burn(msg.sender, _value);
425   }
426 
427   function _burn(address _who, uint256 _value) internal {
428     require(_value <= balances[_who], "must have balance greater than burn value");
429     // no need to require value <= totalSupply, since that would imply the
430     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
431 
432     balances[_who] = balances[_who].sub(_value);
433     totalSupply_ = totalSupply_.sub(_value);
434     emit Burn(_who, _value);
435     emit Transfer(_who, address(0), _value);
436   }
437 }
438 
439 
440 /**
441  * @title BabyloniaToken
442  */
443 contract BabyloniaToken is MintAndBurnToken {
444 
445   // DetailedERC20 variables
446   string public name = "Babylonia Token";
447   string public symbol = "BBY";
448   uint8 public decimals = 18;
449 }
450 
451 /**
452  * @title EthPriceOracleI
453  * @dev Interface for interacting with MakerDAO's on-chain price oracle
454  */
455 contract EthPriceOracleI {
456     function compute() public view returns (bytes32, bool);
457 }
458 
459 /**
460  * @title Pausable
461  * @dev Base contract which allows children to implement an emergency stop mechanism.
462  */
463 contract Pausable is Ownable {
464   event Pause();
465   event Unpause();
466 
467   bool public paused = false;
468 
469 
470   /**
471    * @dev Modifier to make a function callable only when the contract is not paused.
472    */
473   modifier whenNotPaused() {
474     require(!paused);
475     _;
476   }
477 
478   /**
479    * @dev Modifier to make a function callable only when the contract is paused.
480    */
481   modifier whenPaused() {
482     require(paused);
483     _;
484   }
485 
486   /**
487    * @dev called by the owner to pause, triggers stopped state
488    */
489   function pause() public onlyOwner whenNotPaused {
490     paused = true;
491     emit Pause();
492   }
493 
494   /**
495    * @dev called by the owner to unpause, returns to normal state
496    */
497   function unpause() public onlyOwner whenPaused {
498     paused = false;
499     emit Unpause();
500   }
501 }
502 
503 /**
504  * @title Babylon
505  *
506  * @dev This contract manages the exchange of Helbiz tokens for Babylonia tokens, with a locking period
507  * in place before tokens can be claimed
508  */
509 contract Babylon is Pausable {
510   using SafeMath for uint256;
511   using SafeERC20 for BabyloniaToken;
512 
513   event TokenExchangeCreated(address indexed recipient, uint amount, uint releasedAt);
514   event TokenExchangeReleased(address indexed recipient);
515 
516   BabyloniaToken private babyloniaToken;
517   StandardToken private helbizToken;
518   EthPriceOracleI private ethPriceOracle;
519 
520   uint public INITIAL_CIRCULATION_BBY = 80000000; // the amount of BBY tokens available for the token swap
521   uint public MIN_EXCHANGE_BBY = SafeMath.mul(1000, 10**18); // minimum amount of BBY tokens for an exchange
522 
523   uint public exchangeRate;          // HBZ tokens we receive per BBY
524   uint8 public usdCentsExchangeRate; // USD cents we receive per BBY
525   uint32 public exchangeLockTime;    // time (seconds) after an exchange before the sender can claim their BBY tokens
526   uint public babyloniaTokensLocked; // the amount of BBY tokens locked for exchange
527   bool public ethExchangeEnabled;    // whether we are accepting ETH for BBY
528 
529   struct TokenExchange {
530     address recipient; // the address to receive BBY in exchange for HBZ
531     uint amountHBZ;    // amount in HBZ
532     uint amountBBY;    // amount in BBY
533     uint amountWei;    // amount in Wei
534     uint createdAt;    // datetime created
535     uint releasedAt;   // datetime when BBY can be redeemed
536   }
537 
538   mapping(address => uint) private activeTokenExchanges;
539   TokenExchange[] private tokenExchanges;
540 
541   modifier activeTokenExchange() {
542     require(activeTokenExchanges[msg.sender] != 0, "must be an active token exchange");
543     _;
544   }
545 
546   modifier noActiveTokenExchange() {
547     require(activeTokenExchanges[msg.sender] == 0, "must not have an active token exchange");
548     _;
549   }
550 
551   modifier whenEthEnabled() {
552     require(ethExchangeEnabled);
553     _;
554   }
555 
556   /**
557    * Contract constructor
558    * Instantiates instance of HelbizCoin (HBZ) and BabyloniaToken (BBY) contracts
559    * Sets the cap for the total circulation
560    * Mints 50% of the cap for this contract
561    * @param _helbizCoinAddress Address of deployed HelbizCoin contract
562    * @param _babyloniaTokenAddress Address of deployed BabyloniaToken contract
563    * @param _ethPriceOracleAddress Address of deployed EthPriceOracle contract
564    * @param _exchangeRate x HBZ => 1 BBY rate
565    * @param _exchangeLockTime Number of seconds the exchanged BBY tokens are locked up for
566    */
567   constructor(
568     address _helbizCoinAddress,
569     address _babyloniaTokenAddress,
570     address _ethPriceOracleAddress,
571     uint8 _exchangeRate,
572     uint8 _usdCentsExchangeRate,
573     uint32 _exchangeLockTime
574   ) public {
575     helbizToken = StandardToken(_helbizCoinAddress);
576     babyloniaToken = BabyloniaToken(_babyloniaTokenAddress);
577     ethPriceOracle = EthPriceOracleI(_ethPriceOracleAddress);
578     exchangeRate = _exchangeRate;
579     usdCentsExchangeRate = _usdCentsExchangeRate;
580     exchangeLockTime = _exchangeLockTime;
581     paused = true;
582 
583     // take care of zero-index for storage array
584     tokenExchanges.push(TokenExchange({
585       recipient: address(0),
586       amountHBZ: 0,
587       amountBBY: 0,
588       amountWei: 0,
589       createdAt: 0,
590       releasedAt: 0
591     }));
592   }
593 
594   /**
595    * Do not accept ETH
596    */
597   function() public payable {
598     require(msg.value == 0, "not accepting ETH");
599   }
600 
601   /**
602    * Transfers all of this contract's owned HBZ to the given address
603    * @param _to The address to transfer this contract's HBZ to
604    */
605   function withdrawHBZ(address _to) external onlyOwner {
606     require(_to != address(0), "invalid _to address");
607     require(helbizToken.transfer(_to, helbizToken.balanceOf(address(this))));
608   }
609 
610   /**
611    * Transfers all of this contract's ETH to the given address
612    * @param _to The address to transfer all this contract's ETH to
613    */
614   function withdrawETH(address _to) external onlyOwner {
615     require(_to != address(0), "invalid _to address");
616     _to.transfer(address(this).balance);
617   }
618 
619   /**
620    * Transfers all of this contract's BBY MINUS locked tokens to the given address
621    * @param _to The address to transfer BBY to
622    * @param _amountBBY The amount of BBY to transfer
623    */
624   function withdrawBBY(address _to, uint _amountBBY) external onlyOwner {
625     require(_to != address(0), "invalid _to address");
626     require(_amountBBY > 0, "_amountBBY must be greater than 0");
627     require(babyloniaToken.transfer(_to, _amountBBY));
628   }
629 
630   /**
631    * Burns the remainder of BBY owned by this contract MINUS locked tokens
632    */
633   function burnRemainderBBY() public onlyOwner {
634     uint amountBBY = SafeMath.sub(babyloniaToken.balanceOf(address(this)), babyloniaTokensLocked);
635     babyloniaToken.burn(amountBBY);
636   }
637 
638   /**
639    * Sets a new exchange rate
640    * @param _newRate 1 BBY => _newRate
641    */
642   function setExchangeRate(uint8 _newRate) external onlyOwner {
643     require(_newRate > 0, "new rate must not be 0");
644     exchangeRate = _newRate;
645   }
646 
647   /**
648    * Sets the exchange rate in USD cents (for ETH payments)
649    * @param _newRate 1 BBY => _newRate
650    */
651   function setUSDCentsExchangeRate(uint8 _newRate) external onlyOwner {
652     require(_newRate > 0, "new rate must not be 0");
653     usdCentsExchangeRate = _newRate;
654   }
655 
656   /**
657    * Sets a new exchange lock time
658    * @param _newLockTime Number of seconds the exchanged BBY tokens are locked up for
659    */
660   function setExchangeLockTime(uint32 _newLockTime) external onlyOwner {
661     require(_newLockTime > 0, "new lock time must not be 0");
662     exchangeLockTime = _newLockTime;
663   }
664 
665   /**
666    * Sets whether we are accepting ETH for the exchange
667    * @param _enabled Is ETH enabled
668    */
669   function setEthExchangeEnabled(bool _enabled) external onlyOwner {
670     ethExchangeEnabled = _enabled;
671   }
672 
673   /**
674    * Return the address of the BabyloniaToken contract
675    */
676   function getTokenAddress() public view returns(address) {
677     return address(babyloniaToken);
678   }
679 
680   /**
681    * Transfers HBZ from the sender equal to _amountHBZ to this contract and creates a record for TokenExchange
682    * NOTE: the address must have already approved the transfer with hbzToken.approve()
683    * @param _amountHBZ Amount of HBZ tokens
684    */
685   function exchangeTokens(uint _amountHBZ) public whenNotPaused noActiveTokenExchange {
686     // sanity check
687     require(_amountHBZ >= MIN_EXCHANGE_BBY, "_amountHBZ must be greater than or equal to MIN_EXCHANGE_BBY");
688 
689     // the contract must have enough tokens - considering the locked ones
690     uint amountBBY = SafeMath.div(_amountHBZ, exchangeRate);
691     uint contractBalanceBBY = babyloniaToken.balanceOf(address(this));
692     require(SafeMath.sub(contractBalanceBBY, babyloniaTokensLocked) >= amountBBY, "contract has insufficient BBY");
693 
694     // transfer the HBZ tokens to this contract
695     require(helbizToken.transferFrom(msg.sender, address(this), _amountHBZ));
696 
697     _createExchangeRecord(_amountHBZ, amountBBY, 0);
698   }
699 
700   /**
701    * Accepts ETH in exchange for BBY tokens and creates a record for TokenExchange
702    * NOTE: this function can only be called when the contract is paused, preventing sales in ETH during the token swap
703    * @param _amountBBY Amount of BBY tokens
704    */
705   function exchangeEth(uint _amountBBY) public whenNotPaused whenEthEnabled noActiveTokenExchange payable {
706     // sanity check
707     require(_amountBBY > 0, "_amountBBY must be greater than 0");
708 
709     bytes32 val;
710     (val,) = ethPriceOracle.compute();
711     // divide to get the number of cents in 1 ETH
712     uint256 usdCentsPerETH = SafeMath.div(uint256(val), 10**16);
713 
714     // calculate the price of BBY in Wei
715     uint256 priceInWeiPerBBY = SafeMath.div(10**18, SafeMath.div(usdCentsPerETH, usdCentsExchangeRate));
716 
717     // total cost in Wei for _amountBBY
718     uint256 totalPriceInWei = SafeMath.mul(priceInWeiPerBBY, _amountBBY);
719 
720     // ensure the user sent enough funds and that we have enough BBY
721     require(msg.value >= totalPriceInWei, "Insufficient ETH value");
722     require(SafeMath.sub(babyloniaToken.balanceOf(address(this)), babyloniaTokensLocked) >= _amountBBY, "contract has insufficient BBY");
723 
724     // refund any overpayment
725     if (msg.value > totalPriceInWei) msg.sender.transfer(msg.value - totalPriceInWei);
726 
727     _createExchangeRecord(0, _amountBBY, totalPriceInWei);
728   }
729 
730   /**
731    * Transfers BBY tokens to the sender
732    */
733   function claimTokens() public whenNotPaused activeTokenExchange {
734     TokenExchange storage tokenExchange = tokenExchanges[activeTokenExchanges[msg.sender]];
735     uint amountBBY = tokenExchange.amountBBY;
736 
737     // assert that we're past the lock period
738     /* solium-disable-next-line security/no-block-members */
739     require(block.timestamp >= tokenExchange.releasedAt, "not past locking period");
740 
741     // decrease the counter
742     babyloniaTokensLocked = SafeMath.sub(babyloniaTokensLocked, tokenExchange.amountBBY);
743 
744     // delete from storage and lookup
745     delete tokenExchanges[activeTokenExchanges[msg.sender]];
746     delete activeTokenExchanges[msg.sender];
747 
748     // transfer BBY tokens to the sender
749     babyloniaToken.safeTransfer(msg.sender, amountBBY);
750 
751     emit TokenExchangeReleased(msg.sender);
752   }
753 
754   /**
755    * Return the id of the owned active token exchange
756    */
757   function getActiveTokenExchangeId() public view activeTokenExchange returns(uint) {
758     return activeTokenExchanges[msg.sender];
759   }
760 
761   /**
762    * Returns a token exchange with the given id
763    * @param _id the id of the record to retrieve (optional)
764    */
765   function getActiveTokenExchangeById(uint _id)
766     public
767     view
768     returns(
769       address recipient,
770       uint amountHBZ,
771       uint amountBBY,
772       uint amountWei,
773       uint createdAt,
774       uint releasedAt
775     )
776   {
777     // sanity check
778     require(tokenExchanges[_id].recipient != address(0));
779 
780     TokenExchange storage tokenExchange = tokenExchanges[_id];
781 
782     recipient = tokenExchange.recipient;
783     amountHBZ = tokenExchange.amountHBZ;
784     amountBBY = tokenExchange.amountBBY;
785     amountWei = tokenExchange.amountWei;
786     createdAt = tokenExchange.createdAt;
787     releasedAt = tokenExchange.releasedAt;
788   }
789 
790   /**
791    * Returns the number of token exchanges in the storage array
792    * NOTE: the length will be inaccurate as we are deleting array elements, leaving gaps
793    */
794   function getTokenExchangesCount() public view onlyOwner returns(uint) {
795     return tokenExchanges.length;
796   }
797 
798   /**
799    * Creates a record for the token exchange
800    * @param _amountHBZ The amount of HBZ tokens
801    * @param _amountBBY The amount of BBY tokens
802    * @param _amountWei The amount of Wei (optional - in place of _amountHBZ)
803    */
804   function _createExchangeRecord(uint _amountHBZ, uint _amountBBY, uint _amountWei) internal {
805     /* solium-disable-next-line security/no-block-members */
806     uint releasedAt = SafeMath.add(block.timestamp, exchangeLockTime);
807     TokenExchange memory tokenExchange = TokenExchange({
808       recipient: msg.sender,
809       amountHBZ: _amountHBZ,
810       amountBBY: _amountBBY,
811       amountWei: _amountWei,
812       createdAt: block.timestamp, // solium-disable-line security/no-block-members, whitespace
813       releasedAt: releasedAt
814     });
815     // add to storage and lookup
816     activeTokenExchanges[msg.sender] = tokenExchanges.push(tokenExchange) - 1;
817 
818     // increase the counter
819     babyloniaTokensLocked = SafeMath.add(babyloniaTokensLocked, _amountBBY);
820 
821     emit TokenExchangeCreated(msg.sender, _amountHBZ, releasedAt);
822   }
823 }