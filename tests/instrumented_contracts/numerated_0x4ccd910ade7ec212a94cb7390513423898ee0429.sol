1 pragma solidity ^0.4.23;
2 
3 // File: contracts/NokuPricingPlan.sol
4 
5 /**
6 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
7 */
8 contract NokuPricingPlan {
9     /**
10     * @dev Pay the fee for the service identified by the specified name.
11     * The fee amount shall already be approved by the client.
12     * @param serviceName The name of the target service.
13     * @param multiplier The multiplier of the base service fee to apply.
14     * @param client The client of the target service.
15     * @return true if fee has been paid.
16     */
17     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
18 
19     /**
20     * @dev Get the usage fee for the service identified by the specified name.
21     * The returned fee amount shall be approved before using #payFee method.
22     * @param serviceName The name of the target service.
23     * @param multiplier The multiplier of the base service fee to apply.
24     * @return The amount to approve before really paying such fee.
25     */
26     function usageFee(bytes32 serviceName, uint256 multiplier) public view returns(uint fee);
27 }
28 
29 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    */
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipRenounced(owner);
68     owner = address(0);
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address _newOwner) public onlyOwner {
76     _transferOwnership(_newOwner);
77   }
78 
79   /**
80    * @dev Transfers control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function _transferOwnership(address _newOwner) internal {
84     require(_newOwner != address(0));
85     emit OwnershipTransferred(owner, _newOwner);
86     owner = _newOwner;
87   }
88 }
89 
90 // File: contracts/NokuCustomToken.sol
91 
92 contract NokuCustomToken is Ownable {
93 
94     event LogBurnFinished();
95     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
96 
97     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
98     NokuPricingPlan public pricingPlan;
99 
100     // The entity acting as Custom Token service provider i.e. Noku
101     address public serviceProvider;
102 
103     // Flag indicating if Custom Token burning has been permanently finished or not.
104     bool public burningFinished;
105 
106     /**
107     * @dev Modifier to make a function callable only by service provider i.e. Noku.
108     */
109     modifier onlyServiceProvider() {
110         require(msg.sender == serviceProvider, "caller is not service provider");
111         _;
112     }
113 
114     modifier canBurn() {
115         require(!burningFinished, "burning finished");
116         _;
117     }
118 
119     constructor(address _pricingPlan, address _serviceProvider) internal {
120         require(_pricingPlan != 0, "_pricingPlan is zero");
121         require(_serviceProvider != 0, "_serviceProvider is zero");
122 
123         pricingPlan = NokuPricingPlan(_pricingPlan);
124         serviceProvider = _serviceProvider;
125     }
126 
127     /**
128     * @dev Presence of this function indicates the contract is a Custom Token.
129     */
130     function isCustomToken() public pure returns(bool isCustom) {
131         return true;
132     }
133 
134     /**
135     * @dev Stop burning new tokens.
136     * @return true if the operation was successful.
137     */
138     function finishBurning() public onlyOwner canBurn returns(bool finished) {
139         burningFinished = true;
140 
141         emit LogBurnFinished();
142 
143         return true;
144     }
145 
146     /**
147     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
148     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
149     */
150     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
151         require(_pricingPlan != 0, "_pricingPlan is 0");
152         require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");
153 
154         pricingPlan = NokuPricingPlan(_pricingPlan);
155 
156         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
157     }
158 }
159 
160 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
161 
162 /**
163  * @title Pausable
164  * @dev Base contract which allows children to implement an emergency stop mechanism.
165  */
166 contract Pausable is Ownable {
167   event Pause();
168   event Unpause();
169 
170   bool public paused = false;
171 
172 
173   /**
174    * @dev Modifier to make a function callable only when the contract is not paused.
175    */
176   modifier whenNotPaused() {
177     require(!paused);
178     _;
179   }
180 
181   /**
182    * @dev Modifier to make a function callable only when the contract is paused.
183    */
184   modifier whenPaused() {
185     require(paused);
186     _;
187   }
188 
189   /**
190    * @dev called by the owner to pause, triggers stopped state
191    */
192   function pause() onlyOwner whenNotPaused public {
193     paused = true;
194     emit Pause();
195   }
196 
197   /**
198    * @dev called by the owner to unpause, returns to normal state
199    */
200   function unpause() onlyOwner whenPaused public {
201     paused = false;
202     emit Unpause();
203   }
204 }
205 
206 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
207 
208 /**
209  * @title SafeMath
210  * @dev Math operations with safety checks that throw on error
211  */
212 library SafeMath {
213 
214   /**
215   * @dev Multiplies two numbers, throws on overflow.
216   */
217   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
218     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
219     // benefit is lost if 'b' is also tested.
220     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
221     if (a == 0) {
222       return 0;
223     }
224 
225     c = a * b;
226     assert(c / a == b);
227     return c;
228   }
229 
230   /**
231   * @dev Integer division of two numbers, truncating the quotient.
232   */
233   function div(uint256 a, uint256 b) internal pure returns (uint256) {
234     // assert(b > 0); // Solidity automatically throws when dividing by 0
235     // uint256 c = a / b;
236     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237     return a / b;
238   }
239 
240   /**
241   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
242   */
243   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
244     assert(b <= a);
245     return a - b;
246   }
247 
248   /**
249   * @dev Adds two numbers, throws on overflow.
250   */
251   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
252     c = a + b;
253     assert(c >= a);
254     return c;
255   }
256 }
257 
258 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
259 
260 /**
261  * @title ERC20Basic
262  * @dev Simpler version of ERC20 interface
263  * @dev see https://github.com/ethereum/EIPs/issues/179
264  */
265 contract ERC20Basic {
266   function totalSupply() public view returns (uint256);
267   function balanceOf(address who) public view returns (uint256);
268   function transfer(address to, uint256 value) public returns (bool);
269   event Transfer(address indexed from, address indexed to, uint256 value);
270 }
271 
272 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
273 
274 /**
275  * @title ERC20 interface
276  * @dev see https://github.com/ethereum/EIPs/issues/20
277  */
278 contract ERC20 is ERC20Basic {
279   function allowance(address owner, address spender)
280     public view returns (uint256);
281 
282   function transferFrom(address from, address to, uint256 value)
283     public returns (bool);
284 
285   function approve(address spender, uint256 value) public returns (bool);
286   event Approval(
287     address indexed owner,
288     address indexed spender,
289     uint256 value
290   );
291 }
292 
293 // File: contracts/NokuTokenBurner.sol
294 
295 contract BurnableERC20 is ERC20 {
296     function burn(uint256 amount) public returns (bool burned);
297 }
298 
299 /**
300 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
301 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
302 */
303 contract NokuTokenBurner is Pausable {
304     using SafeMath for uint256;
305 
306     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
307     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
308 
309     // The wallet receiving the unburnt tokens.
310     address public wallet;
311 
312     // The percentage of tokens to burn after being received (range [0, 100])
313     uint256 public burningPercentage;
314 
315     // The cumulative amount of burnt tokens.
316     uint256 public burnedTokens;
317 
318     // The cumulative amount of tokens transferred back to the wallet.
319     uint256 public transferredTokens;
320 
321     /**
322     * @dev Create a new NokuTokenBurner with predefined burning fraction.
323     * @param _wallet The wallet receiving the unburnt tokens.
324     */
325     constructor(address _wallet) public {
326         require(_wallet != address(0), "_wallet is zero");
327         
328         wallet = _wallet;
329         burningPercentage = 100;
330 
331         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
332     }
333 
334     /**
335     * @dev Change the percentage of tokens to burn after being received.
336     * @param _burningPercentage The percentage of tokens to be burnt.
337     */
338     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
339         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
340         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
341         
342         burningPercentage = _burningPercentage;
343 
344         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
345     }
346 
347     /**
348     * @dev Called after burnable tokens has been transferred for burning.
349     * @param _token THe extended ERC20 interface supported by the sent tokens.
350     * @param _amount The amount of burnable tokens just arrived ready for burning.
351     */
352     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
353         require(_token != address(0), "_token is zero");
354         require(_amount > 0, "_amount is zero");
355 
356         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
357         if (amountToBurn > 0) {
358             assert(BurnableERC20(_token).burn(amountToBurn));
359             
360             burnedTokens = burnedTokens.add(amountToBurn);
361         }
362 
363         uint256 amountToTransfer = _amount.sub(amountToBurn);
364         if (amountToTransfer > 0) {
365             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
366 
367             transferredTokens = transferredTokens.add(amountToTransfer);
368         }
369     }
370 }
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
373 
374 /**
375  * @title Basic token
376  * @dev Basic version of StandardToken, with no allowances.
377  */
378 contract BasicToken is ERC20Basic {
379   using SafeMath for uint256;
380 
381   mapping(address => uint256) balances;
382 
383   uint256 totalSupply_;
384 
385   /**
386   * @dev total number of tokens in existence
387   */
388   function totalSupply() public view returns (uint256) {
389     return totalSupply_;
390   }
391 
392   /**
393   * @dev transfer token for a specified address
394   * @param _to The address to transfer to.
395   * @param _value The amount to be transferred.
396   */
397   function transfer(address _to, uint256 _value) public returns (bool) {
398     require(_to != address(0));
399     require(_value <= balances[msg.sender]);
400 
401     balances[msg.sender] = balances[msg.sender].sub(_value);
402     balances[_to] = balances[_to].add(_value);
403     emit Transfer(msg.sender, _to, _value);
404     return true;
405   }
406 
407   /**
408   * @dev Gets the balance of the specified address.
409   * @param _owner The address to query the the balance of.
410   * @return An uint256 representing the amount owned by the passed address.
411   */
412   function balanceOf(address _owner) public view returns (uint256) {
413     return balances[_owner];
414   }
415 
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
419 
420 /**
421  * @title Burnable Token
422  * @dev Token that can be irreversibly burned (destroyed).
423  */
424 contract BurnableToken is BasicToken {
425 
426   event Burn(address indexed burner, uint256 value);
427 
428   /**
429    * @dev Burns a specific amount of tokens.
430    * @param _value The amount of token to be burned.
431    */
432   function burn(uint256 _value) public {
433     _burn(msg.sender, _value);
434   }
435 
436   function _burn(address _who, uint256 _value) internal {
437     require(_value <= balances[_who]);
438     // no need to require value <= totalSupply, since that would imply the
439     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
440 
441     balances[_who] = balances[_who].sub(_value);
442     totalSupply_ = totalSupply_.sub(_value);
443     emit Burn(_who, _value);
444     emit Transfer(_who, address(0), _value);
445   }
446 }
447 
448 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
449 
450 /**
451  * @title DetailedERC20 token
452  * @dev The decimals are only for visualization purposes.
453  * All the operations are done using the smallest and indivisible token unit,
454  * just as on Ethereum all the operations are done in wei.
455  */
456 contract DetailedERC20 is ERC20 {
457   string public name;
458   string public symbol;
459   uint8 public decimals;
460 
461   constructor(string _name, string _symbol, uint8 _decimals) public {
462     name = _name;
463     symbol = _symbol;
464     decimals = _decimals;
465   }
466 }
467 
468 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
469 
470 /**
471  * @title Standard ERC20 token
472  *
473  * @dev Implementation of the basic standard token.
474  * @dev https://github.com/ethereum/EIPs/issues/20
475  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
476  */
477 contract StandardToken is ERC20, BasicToken {
478 
479   mapping (address => mapping (address => uint256)) internal allowed;
480 
481 
482   /**
483    * @dev Transfer tokens from one address to another
484    * @param _from address The address which you want to send tokens from
485    * @param _to address The address which you want to transfer to
486    * @param _value uint256 the amount of tokens to be transferred
487    */
488   function transferFrom(
489     address _from,
490     address _to,
491     uint256 _value
492   )
493     public
494     returns (bool)
495   {
496     require(_to != address(0));
497     require(_value <= balances[_from]);
498     require(_value <= allowed[_from][msg.sender]);
499 
500     balances[_from] = balances[_from].sub(_value);
501     balances[_to] = balances[_to].add(_value);
502     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
503     emit Transfer(_from, _to, _value);
504     return true;
505   }
506 
507   /**
508    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
509    *
510    * Beware that changing an allowance with this method brings the risk that someone may use both the old
511    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
512    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
513    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
514    * @param _spender The address which will spend the funds.
515    * @param _value The amount of tokens to be spent.
516    */
517   function approve(address _spender, uint256 _value) public returns (bool) {
518     allowed[msg.sender][_spender] = _value;
519     emit Approval(msg.sender, _spender, _value);
520     return true;
521   }
522 
523   /**
524    * @dev Function to check the amount of tokens that an owner allowed to a spender.
525    * @param _owner address The address which owns the funds.
526    * @param _spender address The address which will spend the funds.
527    * @return A uint256 specifying the amount of tokens still available for the spender.
528    */
529   function allowance(
530     address _owner,
531     address _spender
532    )
533     public
534     view
535     returns (uint256)
536   {
537     return allowed[_owner][_spender];
538   }
539 
540   /**
541    * @dev Increase the amount of tokens that an owner allowed to a spender.
542    *
543    * approve should be called when allowed[_spender] == 0. To increment
544    * allowed value is better to use this function to avoid 2 calls (and wait until
545    * the first transaction is mined)
546    * From MonolithDAO Token.sol
547    * @param _spender The address which will spend the funds.
548    * @param _addedValue The amount of tokens to increase the allowance by.
549    */
550   function increaseApproval(
551     address _spender,
552     uint _addedValue
553   )
554     public
555     returns (bool)
556   {
557     allowed[msg.sender][_spender] = (
558       allowed[msg.sender][_spender].add(_addedValue));
559     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
560     return true;
561   }
562 
563   /**
564    * @dev Decrease the amount of tokens that an owner allowed to a spender.
565    *
566    * approve should be called when allowed[_spender] == 0. To decrement
567    * allowed value is better to use this function to avoid 2 calls (and wait until
568    * the first transaction is mined)
569    * From MonolithDAO Token.sol
570    * @param _spender The address which will spend the funds.
571    * @param _subtractedValue The amount of tokens to decrease the allowance by.
572    */
573   function decreaseApproval(
574     address _spender,
575     uint _subtractedValue
576   )
577     public
578     returns (bool)
579   {
580     uint oldValue = allowed[msg.sender][_spender];
581     if (_subtractedValue > oldValue) {
582       allowed[msg.sender][_spender] = 0;
583     } else {
584       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
585     }
586     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
587     return true;
588   }
589 
590 }
591 
592 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
593 
594 /**
595  * @title Mintable token
596  * @dev Simple ERC20 Token example, with mintable token creation
597  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
598  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
599  */
600 contract MintableToken is StandardToken, Ownable {
601   event Mint(address indexed to, uint256 amount);
602   event MintFinished();
603 
604   bool public mintingFinished = false;
605 
606 
607   modifier canMint() {
608     require(!mintingFinished);
609     _;
610   }
611 
612   modifier hasMintPermission() {
613     require(msg.sender == owner);
614     _;
615   }
616 
617   /**
618    * @dev Function to mint tokens
619    * @param _to The address that will receive the minted tokens.
620    * @param _amount The amount of tokens to mint.
621    * @return A boolean that indicates if the operation was successful.
622    */
623   function mint(
624     address _to,
625     uint256 _amount
626   )
627     hasMintPermission
628     canMint
629     public
630     returns (bool)
631   {
632     totalSupply_ = totalSupply_.add(_amount);
633     balances[_to] = balances[_to].add(_amount);
634     emit Mint(_to, _amount);
635     emit Transfer(address(0), _to, _amount);
636     return true;
637   }
638 
639   /**
640    * @dev Function to stop minting new tokens.
641    * @return True if the operation was successful.
642    */
643   function finishMinting() onlyOwner canMint public returns (bool) {
644     mintingFinished = true;
645     emit MintFinished();
646     return true;
647   }
648 }
649 
650 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
651 
652 /**
653  * @title SafeERC20
654  * @dev Wrappers around ERC20 operations that throw on failure.
655  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
656  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
657  */
658 library SafeERC20 {
659   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
660     require(token.transfer(to, value));
661   }
662 
663   function safeTransferFrom(
664     ERC20 token,
665     address from,
666     address to,
667     uint256 value
668   )
669     internal
670   {
671     require(token.transferFrom(from, to, value));
672   }
673 
674   function safeApprove(ERC20 token, address spender, uint256 value) internal {
675     require(token.approve(spender, value));
676   }
677 }
678 
679 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
680 
681 /**
682  * @title TokenTimelock
683  * @dev TokenTimelock is a token holder contract that will allow a
684  * beneficiary to extract the tokens after a given release time
685  */
686 contract TokenTimelock {
687   using SafeERC20 for ERC20Basic;
688 
689   // ERC20 basic token contract being held
690   ERC20Basic public token;
691 
692   // beneficiary of tokens after they are released
693   address public beneficiary;
694 
695   // timestamp when token release is enabled
696   uint256 public releaseTime;
697 
698   constructor(
699     ERC20Basic _token,
700     address _beneficiary,
701     uint256 _releaseTime
702   )
703     public
704   {
705     // solium-disable-next-line security/no-block-members
706     require(_releaseTime > block.timestamp);
707     token = _token;
708     beneficiary = _beneficiary;
709     releaseTime = _releaseTime;
710   }
711 
712   /**
713    * @notice Transfers tokens held by timelock to beneficiary.
714    */
715   function release() public {
716     // solium-disable-next-line security/no-block-members
717     require(block.timestamp >= releaseTime);
718 
719     uint256 amount = token.balanceOf(this);
720     require(amount > 0);
721 
722     token.safeTransfer(beneficiary, amount);
723   }
724 }
725 
726 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
727 
728 /* solium-disable security/no-block-members */
729 
730 pragma solidity ^0.4.23;
731 
732 
733 
734 
735 
736 
737 /**
738  * @title TokenVesting
739  * @dev A token holder contract that can release its token balance gradually like a
740  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
741  * owner.
742  */
743 contract TokenVesting is Ownable {
744   using SafeMath for uint256;
745   using SafeERC20 for ERC20Basic;
746 
747   event Released(uint256 amount);
748   event Revoked();
749 
750   // beneficiary of tokens after they are released
751   address public beneficiary;
752 
753   uint256 public cliff;
754   uint256 public start;
755   uint256 public duration;
756 
757   bool public revocable;
758 
759   mapping (address => uint256) public released;
760   mapping (address => bool) public revoked;
761 
762   /**
763    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
764    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
765    * of the balance will have vested.
766    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
767    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
768    * @param _start the time (as Unix time) at which point vesting starts 
769    * @param _duration duration in seconds of the period in which the tokens will vest
770    * @param _revocable whether the vesting is revocable or not
771    */
772   constructor(
773     address _beneficiary,
774     uint256 _start,
775     uint256 _cliff,
776     uint256 _duration,
777     bool _revocable
778   )
779     public
780   {
781     require(_beneficiary != address(0));
782     require(_cliff <= _duration);
783 
784     beneficiary = _beneficiary;
785     revocable = _revocable;
786     duration = _duration;
787     cliff = _start.add(_cliff);
788     start = _start;
789   }
790 
791   /**
792    * @notice Transfers vested tokens to beneficiary.
793    * @param token ERC20 token which is being vested
794    */
795   function release(ERC20Basic token) public {
796     uint256 unreleased = releasableAmount(token);
797 
798     require(unreleased > 0);
799 
800     released[token] = released[token].add(unreleased);
801 
802     token.safeTransfer(beneficiary, unreleased);
803 
804     emit Released(unreleased);
805   }
806 
807   /**
808    * @notice Allows the owner to revoke the vesting. Tokens already vested
809    * remain in the contract, the rest are returned to the owner.
810    * @param token ERC20 token which is being vested
811    */
812   function revoke(ERC20Basic token) public onlyOwner {
813     require(revocable);
814     require(!revoked[token]);
815 
816     uint256 balance = token.balanceOf(this);
817 
818     uint256 unreleased = releasableAmount(token);
819     uint256 refund = balance.sub(unreleased);
820 
821     revoked[token] = true;
822 
823     token.safeTransfer(owner, refund);
824 
825     emit Revoked();
826   }
827 
828   /**
829    * @dev Calculates the amount that has already vested but hasn't been released yet.
830    * @param token ERC20 token which is being vested
831    */
832   function releasableAmount(ERC20Basic token) public view returns (uint256) {
833     return vestedAmount(token).sub(released[token]);
834   }
835 
836   /**
837    * @dev Calculates the amount that has already vested.
838    * @param token ERC20 token which is being vested
839    */
840   function vestedAmount(ERC20Basic token) public view returns (uint256) {
841     uint256 currentBalance = token.balanceOf(this);
842     uint256 totalBalance = currentBalance.add(released[token]);
843 
844     if (block.timestamp < cliff) {
845       return 0;
846     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
847       return totalBalance;
848     } else {
849       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
850     }
851   }
852 }
853 
854 // File: contracts/NokuCustomERC20.sol
855 
856 /**
857 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
858 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
859 * by minting or burning tokens in order to increase or decrease the token supply.
860 */
861 contract NokuCustomERC20 is NokuCustomToken, DetailedERC20, MintableToken, BurnableToken {
862     using SafeMath for uint256;
863 
864     event LogNokuCustomERC20Created(
865         address indexed caller,
866         string indexed name,
867         string indexed symbol,
868         uint8 decimals,
869         uint256 transferableFromBlock,
870         uint256 lockEndBlock,
871         address pricingPlan,
872         address serviceProvider
873     );
874     event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);
875     event LogInformationChanged(address indexed caller, string name, string symbol);
876     event LogTransferFeePaymentFinished(address indexed caller);
877     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
878 
879     // Flag indicating if minting fees are enabled or disabled
880     bool public mintingFeeEnabled;
881 
882     // Block number from which tokens are initially transferable
883     uint256 public transferableFromBlock;
884 
885     // Block number from which initial lock ends
886     uint256 public lockEndBlock;
887 
888     // The initially locked balances by address
889     mapping (address => uint256) public initiallyLockedBalanceOf;
890 
891     // The fee percentage for Custom Token transfer or zero if transfer is free of charge
892     uint256 public transferFeePercentage;
893 
894     // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 
895     bool public transferFeePaymentFinished;
896 
897     // Address of optional Timelock smart contract, otherwise 0x0
898     TokenTimelock public timelock;
899 
900     // Address of optional Vesting smart contract, otherwise 0x0
901     TokenVesting public vesting;
902 
903     bytes32 public constant BURN_SERVICE_NAME     = "NokuCustomERC20.burn";
904     bytes32 public constant MINT_SERVICE_NAME     = "NokuCustomERC20.mint";
905     bytes32 public constant TIMELOCK_SERVICE_NAME = "NokuCustomERC20.timelock";
906     bytes32 public constant VESTING_SERVICE_NAME  = "NokuCustomERC20.vesting";
907 
908     modifier canTransfer(address _from, uint _value) {
909         require(block.number >= transferableFromBlock, "token not transferable");
910 
911         if (block.number < lockEndBlock) {
912             uint256 locked = lockedBalanceOf(_from);
913             if (locked > 0) {
914                 uint256 newBalance = balanceOf(_from).sub(_value);
915                 require(newBalance >= locked, "_value exceeds locked amount");
916             }
917         }
918         _;
919     }
920 
921     constructor(
922         string _name,
923         string _symbol,
924         uint8 _decimals,
925         uint256 _transferableFromBlock,
926         uint256 _lockEndBlock,
927         address _pricingPlan,
928         address _serviceProvider
929     )
930     NokuCustomToken(_pricingPlan, _serviceProvider)
931     DetailedERC20(_name, _symbol, _decimals) public
932     {
933         require(bytes(_name).length > 0, "_name is empty");
934         require(bytes(_symbol).length > 0, "_symbol is empty");
935         require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");
936 
937         transferableFromBlock = _transferableFromBlock;
938         lockEndBlock = _lockEndBlock;
939         mintingFeeEnabled = true;
940 
941         emit LogNokuCustomERC20Created(
942             msg.sender,
943             _name,
944             _symbol,
945             _decimals,
946             _transferableFromBlock,
947             _lockEndBlock,
948             _pricingPlan,
949             _serviceProvider
950         );
951     }
952 
953     function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {
954         require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");
955 
956         mintingFeeEnabled = _mintingFeeEnabled;
957 
958         emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);
959 
960         return true;
961     }
962 
963     /**
964     * @dev Change the Custom Token detailed information after creation.
965     * @param _name The name to assign to the Custom Token.
966     * @param _symbol The symbol to assign to the Custom Token.
967     */
968     function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {
969         require(bytes(_name).length > 0, "_name is empty");
970         require(bytes(_symbol).length > 0, "_symbol is empty");
971 
972         name = _name;
973         symbol = _symbol;
974 
975         emit LogInformationChanged(msg.sender, _name, _symbol);
976 
977         return true;
978     }
979 
980     /**
981     * @dev Stop trasfer fee payment for tokens.
982     * @return true if the operation was successful.
983     */
984     function finishTransferFeePayment() public onlyOwner returns(bool finished) {
985         require(!transferFeePaymentFinished, "transfer fee finished");
986 
987         transferFeePaymentFinished = true;
988 
989         emit LogTransferFeePaymentFinished(msg.sender);
990 
991         return true;
992     }
993 
994     /**
995     * @dev Change the transfer fee percentage to be paid in Custom tokens.
996     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
997     */
998     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
999         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");
1000         require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");
1001 
1002         transferFeePercentage = _transferFeePercentage;
1003 
1004         emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
1005     }
1006 
1007     function lockedBalanceOf(address _to) public view returns(uint256 locked) {
1008         uint256 initiallyLocked = initiallyLockedBalanceOf[_to];
1009         if (block.number >= lockEndBlock) return 0;
1010         else if (block.number <= transferableFromBlock) return initiallyLocked;
1011 
1012         uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));
1013         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
1014         return initiallyLocked.sub(released);
1015     }
1016 
1017     /**
1018     * @dev Get the fee to be paid for the transfer of NOKU tokens.
1019     * @param _value The amount of NOKU tokens to be transferred.
1020     */
1021     function transferFee(uint256 _value) public view returns(uint256 usageFee) {
1022         return _value.mul(transferFeePercentage).div(100);
1023     }
1024 
1025     /**
1026     * @dev Check if token transfer is free of any charge or not.
1027     * @return true if transfer is free of any charge.
1028     */
1029     function freeTransfer() public view returns (bool isTransferFree) {
1030         return transferFeePaymentFinished || transferFeePercentage == 0;
1031     }
1032 
1033     /**
1034     * @dev Override #transfer for optionally paying fee to Custom token owner.
1035     */
1036     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {
1037         if (freeTransfer()) {
1038             return super.transfer(_to, _value);
1039         }
1040         else {
1041             uint256 usageFee = transferFee(_value);
1042             uint256 netValue = _value.sub(usageFee);
1043 
1044             bool feeTransferred = super.transfer(owner, usageFee);
1045             bool netValueTransferred = super.transfer(_to, netValue);
1046 
1047             return feeTransferred && netValueTransferred;
1048         }
1049     }
1050 
1051     /**
1052     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
1053     */
1054     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {
1055         if (freeTransfer()) {
1056             return super.transferFrom(_from, _to, _value);
1057         }
1058         else {
1059             uint256 usageFee = transferFee(_value);
1060             uint256 netValue = _value.sub(usageFee);
1061 
1062             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
1063             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
1064 
1065             return feeTransferred && netValueTransferred;
1066         }
1067     }
1068 
1069     /**
1070     * @dev Burn a specific amount of tokens, paying the service fee.
1071     * @param _amount The amount of token to be burned.
1072     */
1073     function burn(uint256 _amount) public canBurn {
1074         require(_amount > 0, "_amount is zero");
1075 
1076         super.burn(_amount);
1077 
1078         require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");
1079     }
1080 
1081     /**
1082     * @dev Mint a specific amount of tokens, paying the service fee.
1083     * @param _to The address that will receive the minted tokens.
1084     * @param _amount The amount of tokens to mint.
1085     * @return A boolean that indicates if the operation was successful.
1086     */
1087     function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1088         require(_to != 0, "_to is zero");
1089         require(_amount > 0, "_amount is zero");
1090 
1091         super.mint(_to, _amount);
1092 
1093         if (mintingFeeEnabled) {
1094             require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");
1095         }
1096 
1097         return true;
1098     }
1099 
1100     /**
1101     * @dev Mint new locked tokens, which will unlock progressively.
1102     * @param _to The address that will receieve the minted locked tokens.
1103     * @param _amount The amount of tokens to mint.
1104     * @return A boolean that indicates if the operation was successful.
1105     */
1106     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1107         initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);
1108 
1109         return mint(_to, _amount);
1110     }
1111 
1112     /**
1113      * @dev Mint the specified amount of timelocked tokens.
1114      * @param _to The address that will receieve the minted locked tokens.
1115      * @param _amount The amount of tokens to mint.
1116      * @param _releaseTime The token release time as timestamp from Unix epoch.
1117      * @return A boolean that indicates if the operation was successful.
1118      */
1119     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint
1120     returns(bool minted)
1121     {
1122         require(timelock == address(0), "TokenTimelock already activated");
1123 
1124         timelock = new TokenTimelock(this, _to, _releaseTime);
1125 
1126         minted = mint(timelock, _amount);
1127 
1128         require(pricingPlan.payFee(TIMELOCK_SERVICE_NAME, _amount, msg.sender), "timelock fee failed");
1129     }
1130 
1131     /**
1132     * @dev Mint the specified amount of vested tokens.
1133     * @param _to The address that will receieve the minted vested tokens.
1134     * @param _amount The amount of tokens to mint.
1135     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
1136     * @param _duration The duration in seconds of the period in which the tokens will vest.
1137     * @return A boolean that indicates if the operation was successful.
1138     */
1139     function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public onlyOwner canMint
1140     returns(bool minted)
1141     {
1142         require(vesting == address(0), "TokenVesting already activated");
1143 
1144         vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
1145 
1146         minted = mint(vesting, _amount);
1147 
1148         require(pricingPlan.payFee(VESTING_SERVICE_NAME, _amount, msg.sender), "vesting fee failed");
1149     }
1150 
1151     /**
1152      * @dev Release vested tokens to the beneficiary. Anyone can release vested tokens.
1153     * @return A boolean that indicates if the operation was successful.
1154      */
1155     function releaseVested() public returns(bool released) {
1156         require(vesting != address(0), "TokenVesting not activated");
1157 
1158         vesting.release(this);
1159 
1160         return true;
1161     }
1162 
1163     /**
1164      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
1165     * @return A boolean that indicates if the operation was successful.
1166      */
1167     function revokeVested() public onlyOwner returns(bool revoked) {
1168         require(vesting != address(0), "TokenVesting not activated");
1169 
1170         vesting.revoke(this);
1171 
1172         return true;
1173     }
1174 }
1175 
1176 // File: openzeppelin-solidity/contracts/AddressUtils.sol
1177 
1178 /**
1179  * Utility library of inline functions on addresses
1180  */
1181 library AddressUtils {
1182 
1183   /**
1184    * Returns whether the target address is a contract
1185    * @dev This function will return false if invoked during the constructor of a contract,
1186    *  as the code is not actually created until after the constructor finishes.
1187    * @param addr address to check
1188    * @return whether the target address is a contract
1189    */
1190   function isContract(address addr) internal view returns (bool) {
1191     uint256 size;
1192     // XXX Currently there is no better way to check if there is a contract in an address
1193     // than to check the size of the code at that address.
1194     // See https://ethereum.stackexchange.com/a/14016/36603
1195     // for more details about how this works.
1196     // TODO Check this again before the Serenity release, because all addresses will be
1197     // contracts then.
1198     // solium-disable-next-line security/no-inline-assembly
1199     assembly { size := extcodesize(addr) }
1200     return size > 0;
1201   }
1202 
1203 }
1204 
1205 // File: contracts/NokuCustomService.sol
1206 
1207 contract NokuCustomService is Pausable {
1208     using AddressUtils for address;
1209 
1210     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
1211 
1212     // The pricing plan determining the fee to be paid in NOKU tokens by customers
1213     NokuPricingPlan public pricingPlan;
1214 
1215     constructor(address _pricingPlan) internal {
1216         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1217 
1218         pricingPlan = NokuPricingPlan(_pricingPlan);
1219     }
1220 
1221     function setPricingPlan(address _pricingPlan) public onlyOwner {
1222         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1223         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
1224         
1225         pricingPlan = NokuPricingPlan(_pricingPlan);
1226 
1227         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
1228     }
1229 }
1230 
1231 // File: contracts/NokuCustomERC20Service.sol
1232 
1233 /**
1234 * @dev The NokuCustomERC2Service contract .
1235 */
1236 contract NokuCustomERC20Service is NokuCustomService {
1237     event LogNokuCustomERC20ServiceCreated(address caller, address indexed pricingPlan);
1238 
1239     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
1240 
1241     uint8 public constant DECIMALS = 18;
1242 
1243     bytes32 public constant CUSTOM_ERC20_CREATE_SERVICE_NAME = "NokuCustomERC20.create";
1244 
1245     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
1246         emit LogNokuCustomERC20ServiceCreated(msg.sender, _pricingPlan);
1247     }
1248 
1249     // TODO: REMOVE
1250     function createCustomToken(string _name, string _symbol, uint8 /*_decimals*/) public returns(NokuCustomERC20 customToken) {
1251         customToken = new NokuCustomERC20(
1252             _name,
1253             _symbol,
1254             DECIMALS,
1255             block.number,
1256             block.number,
1257             pricingPlan,
1258             owner
1259         );
1260 
1261         // Transfer NokuCustomERC20 ownership to the client
1262         customToken.transferOwnership(msg.sender);
1263 
1264         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1265     }
1266 
1267     function createCustomToken(
1268         string _name,
1269         string _symbol,
1270         uint8 /*_decimals*/,
1271         uint256 transferableFromBlock,
1272         uint256 lockEndBlock
1273     )
1274     public returns(NokuCustomERC20 customToken)
1275     {
1276         customToken = new NokuCustomERC20(
1277             _name,
1278             _symbol,
1279             DECIMALS,
1280             transferableFromBlock,
1281             lockEndBlock,
1282             pricingPlan,
1283             owner
1284         );
1285 
1286         // Transfer NokuCustomERC20 ownership to the client
1287         customToken.transferOwnership(msg.sender);
1288 
1289         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1290     }
1291 }