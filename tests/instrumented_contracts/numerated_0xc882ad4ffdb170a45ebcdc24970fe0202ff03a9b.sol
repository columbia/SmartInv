1 /**
2  *Submitted for verification at Etherscan.io on 2018-07-25
3 */
4 
5 pragma solidity ^0.4.23;
6 
7 // File: contracts/NokuPricingPlan.sol
8 
9 /**
10 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
11 */
12 contract NokuPricingPlan {
13     /**
14     * @dev Pay the fee for the service identified by the specified name.
15     * The fee amount shall already be approved by the client.
16     * @param serviceName The name of the target service.
17     * @param multiplier The multiplier of the base service fee to apply.
18     * @param client The client of the target service.
19     * @return true if fee has been paid.
20     */
21     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
22 
23     /**
24     * @dev Get the usage fee for the service identified by the specified name.
25     * The returned fee amount shall be approved before using #payFee method.
26     * @param serviceName The name of the target service.
27     * @param multiplier The multiplier of the base service fee to apply.
28     * @return The amount to approve before really paying such fee.
29     */
30     function usageFee(bytes32 serviceName, uint256 multiplier) public view returns(uint fee);
31 }
32 
33 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipRenounced(address indexed previousOwner);
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to relinquish control of the contract.
69    */
70   function renounceOwnership() public onlyOwner {
71     emit OwnershipRenounced(owner);
72     owner = address(0);
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param _newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address _newOwner) public onlyOwner {
80     _transferOwnership(_newOwner);
81   }
82 
83   /**
84    * @dev Transfers control of the contract to a newOwner.
85    * @param _newOwner The address to transfer ownership to.
86    */
87   function _transferOwnership(address _newOwner) internal {
88     require(_newOwner != address(0));
89     emit OwnershipTransferred(owner, _newOwner);
90     owner = _newOwner;
91   }
92 }
93 
94 // File: contracts/NokuCustomToken.sol
95 
96 contract NokuCustomToken is Ownable {
97 
98     event LogBurnFinished();
99     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
100 
101     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
102     NokuPricingPlan public pricingPlan;
103 
104     // The entity acting as Custom Token service provider i.e. Noku
105     address public serviceProvider;
106 
107     // Flag indicating if Custom Token burning has been permanently finished or not.
108     bool public burningFinished;
109 
110     /**
111     * @dev Modifier to make a function callable only by service provider i.e. Noku.
112     */
113     modifier onlyServiceProvider() {
114         require(msg.sender == serviceProvider, "caller is not service provider");
115         _;
116     }
117 
118     modifier canBurn() {
119         require(!burningFinished, "burning finished");
120         _;
121     }
122 
123     constructor(address _pricingPlan, address _serviceProvider) internal {
124         require(_pricingPlan != 0, "_pricingPlan is zero");
125         require(_serviceProvider != 0, "_serviceProvider is zero");
126 
127         pricingPlan = NokuPricingPlan(_pricingPlan);
128         serviceProvider = _serviceProvider;
129     }
130 
131     /**
132     * @dev Presence of this function indicates the contract is a Custom Token.
133     */
134     function isCustomToken() public pure returns(bool isCustom) {
135         return true;
136     }
137 
138     /**
139     * @dev Stop burning new tokens.
140     * @return true if the operation was successful.
141     */
142     function finishBurning() public onlyOwner canBurn returns(bool finished) {
143         burningFinished = true;
144 
145         emit LogBurnFinished();
146 
147         return true;
148     }
149 
150     /**
151     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
152     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
153     */
154     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
155         require(_pricingPlan != 0, "_pricingPlan is 0");
156         require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");
157 
158         pricingPlan = NokuPricingPlan(_pricingPlan);
159 
160         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
161     }
162 }
163 
164 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
165 
166 /**
167  * @title Pausable
168  * @dev Base contract which allows children to implement an emergency stop mechanism.
169  */
170 contract Pausable is Ownable {
171   event Pause();
172   event Unpause();
173 
174   bool public paused = false;
175 
176 
177   /**
178    * @dev Modifier to make a function callable only when the contract is not paused.
179    */
180   modifier whenNotPaused() {
181     require(!paused);
182     _;
183   }
184 
185   /**
186    * @dev Modifier to make a function callable only when the contract is paused.
187    */
188   modifier whenPaused() {
189     require(paused);
190     _;
191   }
192 
193   /**
194    * @dev called by the owner to pause, triggers stopped state
195    */
196   function pause() onlyOwner whenNotPaused public {
197     paused = true;
198     emit Pause();
199   }
200 
201   /**
202    * @dev called by the owner to unpause, returns to normal state
203    */
204   function unpause() onlyOwner whenPaused public {
205     paused = false;
206     emit Unpause();
207   }
208 }
209 
210 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217 
218   /**
219   * @dev Multiplies two numbers, throws on overflow.
220   */
221   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
222     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
223     // benefit is lost if 'b' is also tested.
224     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
225     if (a == 0) {
226       return 0;
227     }
228 
229     c = a * b;
230     assert(c / a == b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     // uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241     return a / b;
242   }
243 
244   /**
245   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
256     c = a + b;
257     assert(c >= a);
258     return c;
259   }
260 }
261 
262 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
263 
264 /**
265  * @title ERC20Basic
266  * @dev Simpler version of ERC20 interface
267  * @dev see https://github.com/ethereum/EIPs/issues/179
268  */
269 contract ERC20Basic {
270   function totalSupply() public view returns (uint256);
271   function balanceOf(address who) public view returns (uint256);
272   function transfer(address to, uint256 value) public returns (bool);
273   event Transfer(address indexed from, address indexed to, uint256 value);
274 }
275 
276 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
277 
278 /**
279  * @title ERC20 interface
280  * @dev see https://github.com/ethereum/EIPs/issues/20
281  */
282 contract ERC20 is ERC20Basic {
283   function allowance(address owner, address spender)
284     public view returns (uint256);
285 
286   function transferFrom(address from, address to, uint256 value)
287     public returns (bool);
288 
289   function approve(address spender, uint256 value) public returns (bool);
290   event Approval(
291     address indexed owner,
292     address indexed spender,
293     uint256 value
294   );
295 }
296 
297 // File: contracts/NokuTokenBurner.sol
298 
299 contract BurnableERC20 is ERC20 {
300     function burn(uint256 amount) public returns (bool burned);
301 }
302 
303 /**
304 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
305 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
306 */
307 contract NokuTokenBurner is Pausable {
308     using SafeMath for uint256;
309 
310     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
311     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
312 
313     // The wallet receiving the unburnt tokens.
314     address public wallet;
315 
316     // The percentage of tokens to burn after being received (range [0, 100])
317     uint256 public burningPercentage;
318 
319     // The cumulative amount of burnt tokens.
320     uint256 public burnedTokens;
321 
322     // The cumulative amount of tokens transferred back to the wallet.
323     uint256 public transferredTokens;
324 
325     /**
326     * @dev Create a new NokuTokenBurner with predefined burning fraction.
327     * @param _wallet The wallet receiving the unburnt tokens.
328     */
329     constructor(address _wallet) public {
330         require(_wallet != address(0), "_wallet is zero");
331         
332         wallet = _wallet;
333         burningPercentage = 100;
334 
335         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
336     }
337 
338     /**
339     * @dev Change the percentage of tokens to burn after being received.
340     * @param _burningPercentage The percentage of tokens to be burnt.
341     */
342     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
343         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
344         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
345         
346         burningPercentage = _burningPercentage;
347 
348         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
349     }
350 
351     /**
352     * @dev Called after burnable tokens has been transferred for burning.
353     * @param _token THe extended ERC20 interface supported by the sent tokens.
354     * @param _amount The amount of burnable tokens just arrived ready for burning.
355     */
356     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
357         require(_token != address(0), "_token is zero");
358         require(_amount > 0, "_amount is zero");
359 
360         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
361         if (amountToBurn > 0) {
362             assert(BurnableERC20(_token).burn(amountToBurn));
363             
364             burnedTokens = burnedTokens.add(amountToBurn);
365         }
366 
367         uint256 amountToTransfer = _amount.sub(amountToBurn);
368         if (amountToTransfer > 0) {
369             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
370 
371             transferredTokens = transferredTokens.add(amountToTransfer);
372         }
373     }
374 }
375 
376 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
377 
378 /**
379  * @title Basic token
380  * @dev Basic version of StandardToken, with no allowances.
381  */
382 contract BasicToken is ERC20Basic {
383   using SafeMath for uint256;
384 
385   mapping(address => uint256) balances;
386 
387   uint256 totalSupply_;
388 
389   /**
390   * @dev total number of tokens in existence
391   */
392   function totalSupply() public view returns (uint256) {
393     return totalSupply_;
394   }
395 
396   /**
397   * @dev transfer token for a specified address
398   * @param _to The address to transfer to.
399   * @param _value The amount to be transferred.
400   */
401   function transfer(address _to, uint256 _value) public returns (bool) {
402     require(_to != address(0));
403     require(_value <= balances[msg.sender]);
404 
405     balances[msg.sender] = balances[msg.sender].sub(_value);
406     balances[_to] = balances[_to].add(_value);
407     emit Transfer(msg.sender, _to, _value);
408     return true;
409   }
410 
411   /**
412   * @dev Gets the balance of the specified address.
413   * @param _owner The address to query the the balance of.
414   * @return An uint256 representing the amount owned by the passed address.
415   */
416   function balanceOf(address _owner) public view returns (uint256) {
417     return balances[_owner];
418   }
419 
420 }
421 
422 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
423 
424 /**
425  * @title Burnable Token
426  * @dev Token that can be irreversibly burned (destroyed).
427  */
428 contract BurnableToken is BasicToken {
429 
430   event Burn(address indexed burner, uint256 value);
431 
432   /**
433    * @dev Burns a specific amount of tokens.
434    * @param _value The amount of token to be burned.
435    */
436   function burn(uint256 _value) public {
437     _burn(msg.sender, _value);
438   }
439 
440   function _burn(address _who, uint256 _value) internal {
441     require(_value <= balances[_who]);
442     // no need to require value <= totalSupply, since that would imply the
443     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
444 
445     balances[_who] = balances[_who].sub(_value);
446     totalSupply_ = totalSupply_.sub(_value);
447     emit Burn(_who, _value);
448     emit Transfer(_who, address(0), _value);
449   }
450 }
451 
452 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
453 
454 /**
455  * @title DetailedERC20 token
456  * @dev The decimals are only for visualization purposes.
457  * All the operations are done using the smallest and indivisible token unit,
458  * just as on Ethereum all the operations are done in wei.
459  */
460 contract DetailedERC20 is ERC20 {
461   string public name;
462   string public symbol;
463   uint8 public decimals;
464 
465   constructor(string _name, string _symbol, uint8 _decimals) public {
466     name = _name;
467     symbol = _symbol;
468     decimals = _decimals;
469   }
470 }
471 
472 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
473 
474 /**
475  * @title Standard ERC20 token
476  *
477  * @dev Implementation of the basic standard token.
478  * @dev https://github.com/ethereum/EIPs/issues/20
479  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
480  */
481 contract StandardToken is ERC20, BasicToken {
482 
483   mapping (address => mapping (address => uint256)) internal allowed;
484 
485 
486   /**
487    * @dev Transfer tokens from one address to another
488    * @param _from address The address which you want to send tokens from
489    * @param _to address The address which you want to transfer to
490    * @param _value uint256 the amount of tokens to be transferred
491    */
492   function transferFrom(
493     address _from,
494     address _to,
495     uint256 _value
496   )
497     public
498     returns (bool)
499   {
500     require(_to != address(0));
501     require(_value <= balances[_from]);
502     require(_value <= allowed[_from][msg.sender]);
503 
504     balances[_from] = balances[_from].sub(_value);
505     balances[_to] = balances[_to].add(_value);
506     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
507     emit Transfer(_from, _to, _value);
508     return true;
509   }
510 
511   /**
512    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
513    *
514    * Beware that changing an allowance with this method brings the risk that someone may use both the old
515    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
516    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
517    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
518    * @param _spender The address which will spend the funds.
519    * @param _value The amount of tokens to be spent.
520    */
521   function approve(address _spender, uint256 _value) public returns (bool) {
522     allowed[msg.sender][_spender] = _value;
523     emit Approval(msg.sender, _spender, _value);
524     return true;
525   }
526 
527   /**
528    * @dev Function to check the amount of tokens that an owner allowed to a spender.
529    * @param _owner address The address which owns the funds.
530    * @param _spender address The address which will spend the funds.
531    * @return A uint256 specifying the amount of tokens still available for the spender.
532    */
533   function allowance(
534     address _owner,
535     address _spender
536    )
537     public
538     view
539     returns (uint256)
540   {
541     return allowed[_owner][_spender];
542   }
543 
544   /**
545    * @dev Increase the amount of tokens that an owner allowed to a spender.
546    *
547    * approve should be called when allowed[_spender] == 0. To increment
548    * allowed value is better to use this function to avoid 2 calls (and wait until
549    * the first transaction is mined)
550    * From MonolithDAO Token.sol
551    * @param _spender The address which will spend the funds.
552    * @param _addedValue The amount of tokens to increase the allowance by.
553    */
554   function increaseApproval(
555     address _spender,
556     uint _addedValue
557   )
558     public
559     returns (bool)
560   {
561     allowed[msg.sender][_spender] = (
562       allowed[msg.sender][_spender].add(_addedValue));
563     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
564     return true;
565   }
566 
567   /**
568    * @dev Decrease the amount of tokens that an owner allowed to a spender.
569    *
570    * approve should be called when allowed[_spender] == 0. To decrement
571    * allowed value is better to use this function to avoid 2 calls (and wait until
572    * the first transaction is mined)
573    * From MonolithDAO Token.sol
574    * @param _spender The address which will spend the funds.
575    * @param _subtractedValue The amount of tokens to decrease the allowance by.
576    */
577   function decreaseApproval(
578     address _spender,
579     uint _subtractedValue
580   )
581     public
582     returns (bool)
583   {
584     uint oldValue = allowed[msg.sender][_spender];
585     if (_subtractedValue > oldValue) {
586       allowed[msg.sender][_spender] = 0;
587     } else {
588       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
589     }
590     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
591     return true;
592   }
593 
594 }
595 
596 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
597 
598 /**
599  * @title Mintable token
600  * @dev Simple ERC20 Token example, with mintable token creation
601  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
602  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
603  */
604 contract MintableToken is StandardToken, Ownable {
605   event Mint(address indexed to, uint256 amount);
606   event MintFinished();
607 
608   bool public mintingFinished = false;
609 
610 
611   modifier canMint() {
612     require(!mintingFinished);
613     _;
614   }
615 
616   modifier hasMintPermission() {
617     require(msg.sender == owner);
618     _;
619   }
620 
621   /**
622    * @dev Function to mint tokens
623    * @param _to The address that will receive the minted tokens.
624    * @param _amount The amount of tokens to mint.
625    * @return A boolean that indicates if the operation was successful.
626    */
627   function mint(
628     address _to,
629     uint256 _amount
630   )
631     hasMintPermission
632     canMint
633     public
634     returns (bool)
635   {
636     totalSupply_ = totalSupply_.add(_amount);
637     balances[_to] = balances[_to].add(_amount);
638     emit Mint(_to, _amount);
639     emit Transfer(address(0), _to, _amount);
640     return true;
641   }
642 
643   /**
644    * @dev Function to stop minting new tokens.
645    * @return True if the operation was successful.
646    */
647   function finishMinting() onlyOwner canMint public returns (bool) {
648     mintingFinished = true;
649     emit MintFinished();
650     return true;
651   }
652 }
653 
654 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
655 
656 /**
657  * @title SafeERC20
658  * @dev Wrappers around ERC20 operations that throw on failure.
659  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
660  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
661  */
662 library SafeERC20 {
663   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
664     require(token.transfer(to, value));
665   }
666 
667   function safeTransferFrom(
668     ERC20 token,
669     address from,
670     address to,
671     uint256 value
672   )
673     internal
674   {
675     require(token.transferFrom(from, to, value));
676   }
677 
678   function safeApprove(ERC20 token, address spender, uint256 value) internal {
679     require(token.approve(spender, value));
680   }
681 }
682 
683 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
684 
685 /**
686  * @title TokenTimelock
687  * @dev TokenTimelock is a token holder contract that will allow a
688  * beneficiary to extract the tokens after a given release time
689  */
690 contract TokenTimelock {
691   using SafeERC20 for ERC20Basic;
692 
693   // ERC20 basic token contract being held
694   ERC20Basic public token;
695 
696   // beneficiary of tokens after they are released
697   address public beneficiary;
698 
699   // timestamp when token release is enabled
700   uint256 public releaseTime;
701 
702   constructor(
703     ERC20Basic _token,
704     address _beneficiary,
705     uint256 _releaseTime
706   )
707     public
708   {
709     // solium-disable-next-line security/no-block-members
710     require(_releaseTime > block.timestamp);
711     token = _token;
712     beneficiary = _beneficiary;
713     releaseTime = _releaseTime;
714   }
715 
716   /**
717    * @notice Transfers tokens held by timelock to beneficiary.
718    */
719   function release() public {
720     // solium-disable-next-line security/no-block-members
721     require(block.timestamp >= releaseTime);
722 
723     uint256 amount = token.balanceOf(this);
724     require(amount > 0);
725 
726     token.safeTransfer(beneficiary, amount);
727   }
728 }
729 
730 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
731 
732 /* solium-disable security/no-block-members */
733 
734 pragma solidity ^0.4.23;
735 
736 
737 
738 
739 
740 
741 /**
742  * @title TokenVesting
743  * @dev A token holder contract that can release its token balance gradually like a
744  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
745  * owner.
746  */
747 contract TokenVesting is Ownable {
748   using SafeMath for uint256;
749   using SafeERC20 for ERC20Basic;
750 
751   event Released(uint256 amount);
752   event Revoked();
753 
754   // beneficiary of tokens after they are released
755   address public beneficiary;
756 
757   uint256 public cliff;
758   uint256 public start;
759   uint256 public duration;
760 
761   bool public revocable;
762 
763   mapping (address => uint256) public released;
764   mapping (address => bool) public revoked;
765 
766   /**
767    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
768    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
769    * of the balance will have vested.
770    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
771    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
772    * @param _start the time (as Unix time) at which point vesting starts 
773    * @param _duration duration in seconds of the period in which the tokens will vest
774    * @param _revocable whether the vesting is revocable or not
775    */
776   constructor(
777     address _beneficiary,
778     uint256 _start,
779     uint256 _cliff,
780     uint256 _duration,
781     bool _revocable
782   )
783     public
784   {
785     require(_beneficiary != address(0));
786     require(_cliff <= _duration);
787 
788     beneficiary = _beneficiary;
789     revocable = _revocable;
790     duration = _duration;
791     cliff = _start.add(_cliff);
792     start = _start;
793   }
794 
795   /**
796    * @notice Transfers vested tokens to beneficiary.
797    * @param token ERC20 token which is being vested
798    */
799   function release(ERC20Basic token) public {
800     uint256 unreleased = releasableAmount(token);
801 
802     require(unreleased > 0);
803 
804     released[token] = released[token].add(unreleased);
805 
806     token.safeTransfer(beneficiary, unreleased);
807 
808     emit Released(unreleased);
809   }
810 
811   /**
812    * @notice Allows the owner to revoke the vesting. Tokens already vested
813    * remain in the contract, the rest are returned to the owner.
814    * @param token ERC20 token which is being vested
815    */
816   function revoke(ERC20Basic token) public onlyOwner {
817     require(revocable);
818     require(!revoked[token]);
819 
820     uint256 balance = token.balanceOf(this);
821 
822     uint256 unreleased = releasableAmount(token);
823     uint256 refund = balance.sub(unreleased);
824 
825     revoked[token] = true;
826 
827     token.safeTransfer(owner, refund);
828 
829     emit Revoked();
830   }
831 
832   /**
833    * @dev Calculates the amount that has already vested but hasn't been released yet.
834    * @param token ERC20 token which is being vested
835    */
836   function releasableAmount(ERC20Basic token) public view returns (uint256) {
837     return vestedAmount(token).sub(released[token]);
838   }
839 
840   /**
841    * @dev Calculates the amount that has already vested.
842    * @param token ERC20 token which is being vested
843    */
844   function vestedAmount(ERC20Basic token) public view returns (uint256) {
845     uint256 currentBalance = token.balanceOf(this);
846     uint256 totalBalance = currentBalance.add(released[token]);
847 
848     if (block.timestamp < cliff) {
849       return 0;
850     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
851       return totalBalance;
852     } else {
853       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
854     }
855   }
856 }
857 
858 // File: contracts/NokuCustomERC20.sol
859 
860 /**
861 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
862 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
863 * by minting or burning tokens in order to increase or decrease the token supply.
864 */
865 contract NokuCustomERC20 is NokuCustomToken, DetailedERC20, MintableToken, BurnableToken {
866     using SafeMath for uint256;
867 
868     event LogNokuCustomERC20Created(
869         address indexed caller,
870         string indexed name,
871         string indexed symbol,
872         uint8 decimals,
873         uint256 transferableFromBlock,
874         uint256 lockEndBlock,
875         address pricingPlan,
876         address serviceProvider
877     );
878     event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);
879     event LogInformationChanged(address indexed caller, string name, string symbol);
880     event LogTransferFeePaymentFinished(address indexed caller);
881     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
882 
883     // Flag indicating if minting fees are enabled or disabled
884     bool public mintingFeeEnabled;
885 
886     // Block number from which tokens are initially transferable
887     uint256 public transferableFromBlock;
888 
889     // Block number from which initial lock ends
890     uint256 public lockEndBlock;
891 
892     // The initially locked balances by address
893     mapping (address => uint256) public initiallyLockedBalanceOf;
894 
895     // The fee percentage for Custom Token transfer or zero if transfer is free of charge
896     uint256 public transferFeePercentage;
897 
898     // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 
899     bool public transferFeePaymentFinished;
900 
901     // Address of optional Timelock smart contract, otherwise 0x0
902     TokenTimelock public timelock;
903 
904     // Address of optional Vesting smart contract, otherwise 0x0
905     TokenVesting public vesting;
906 
907     bytes32 public constant BURN_SERVICE_NAME     = "NokuCustomERC20.burn";
908     bytes32 public constant MINT_SERVICE_NAME     = "NokuCustomERC20.mint";
909     bytes32 public constant TIMELOCK_SERVICE_NAME = "NokuCustomERC20.timelock";
910     bytes32 public constant VESTING_SERVICE_NAME  = "NokuCustomERC20.vesting";
911 
912     modifier canTransfer(address _from, uint _value) {
913         require(block.number >= transferableFromBlock, "token not transferable");
914 
915         if (block.number < lockEndBlock) {
916             uint256 locked = lockedBalanceOf(_from);
917             if (locked > 0) {
918                 uint256 newBalance = balanceOf(_from).sub(_value);
919                 require(newBalance >= locked, "_value exceeds locked amount");
920             }
921         }
922         _;
923     }
924 
925     constructor(
926         string _name,
927         string _symbol,
928         uint8 _decimals,
929         uint256 _transferableFromBlock,
930         uint256 _lockEndBlock,
931         address _pricingPlan,
932         address _serviceProvider
933     )
934     NokuCustomToken(_pricingPlan, _serviceProvider)
935     DetailedERC20(_name, _symbol, _decimals) public
936     {
937         require(bytes(_name).length > 0, "_name is empty");
938         require(bytes(_symbol).length > 0, "_symbol is empty");
939         require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");
940 
941         transferableFromBlock = _transferableFromBlock;
942         lockEndBlock = _lockEndBlock;
943         mintingFeeEnabled = true;
944 
945         emit LogNokuCustomERC20Created(
946             msg.sender,
947             _name,
948             _symbol,
949             _decimals,
950             _transferableFromBlock,
951             _lockEndBlock,
952             _pricingPlan,
953             _serviceProvider
954         );
955     }
956 
957     function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {
958         require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");
959 
960         mintingFeeEnabled = _mintingFeeEnabled;
961 
962         emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);
963 
964         return true;
965     }
966 
967     /**
968     * @dev Change the Custom Token detailed information after creation.
969     * @param _name The name to assign to the Custom Token.
970     * @param _symbol The symbol to assign to the Custom Token.
971     */
972     function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {
973         require(bytes(_name).length > 0, "_name is empty");
974         require(bytes(_symbol).length > 0, "_symbol is empty");
975 
976         name = _name;
977         symbol = _symbol;
978 
979         emit LogInformationChanged(msg.sender, _name, _symbol);
980 
981         return true;
982     }
983 
984     /**
985     * @dev Stop trasfer fee payment for tokens.
986     * @return true if the operation was successful.
987     */
988     function finishTransferFeePayment() public onlyOwner returns(bool finished) {
989         require(!transferFeePaymentFinished, "transfer fee finished");
990 
991         transferFeePaymentFinished = true;
992 
993         emit LogTransferFeePaymentFinished(msg.sender);
994 
995         return true;
996     }
997 
998     /**
999     * @dev Change the transfer fee percentage to be paid in Custom tokens.
1000     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
1001     */
1002     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
1003         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");
1004         require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");
1005 
1006         transferFeePercentage = _transferFeePercentage;
1007 
1008         emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
1009     }
1010 
1011     function lockedBalanceOf(address _to) public view returns(uint256 locked) {
1012         uint256 initiallyLocked = initiallyLockedBalanceOf[_to];
1013         if (block.number >= lockEndBlock) return 0;
1014         else if (block.number <= transferableFromBlock) return initiallyLocked;
1015 
1016         uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));
1017         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
1018         return initiallyLocked.sub(released);
1019     }
1020 
1021     /**
1022     * @dev Get the fee to be paid for the transfer of NOKU tokens.
1023     * @param _value The amount of NOKU tokens to be transferred.
1024     */
1025     function transferFee(uint256 _value) public view returns(uint256 usageFee) {
1026         return _value.mul(transferFeePercentage).div(100);
1027     }
1028 
1029     /**
1030     * @dev Check if token transfer is free of any charge or not.
1031     * @return true if transfer is free of any charge.
1032     */
1033     function freeTransfer() public view returns (bool isTransferFree) {
1034         return transferFeePaymentFinished || transferFeePercentage == 0;
1035     }
1036 
1037     /**
1038     * @dev Override #transfer for optionally paying fee to Custom token owner.
1039     */
1040     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {
1041         if (freeTransfer()) {
1042             return super.transfer(_to, _value);
1043         }
1044         else {
1045             uint256 usageFee = transferFee(_value);
1046             uint256 netValue = _value.sub(usageFee);
1047 
1048             bool feeTransferred = super.transfer(owner, usageFee);
1049             bool netValueTransferred = super.transfer(_to, netValue);
1050 
1051             return feeTransferred && netValueTransferred;
1052         }
1053     }
1054 
1055     /**
1056     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
1057     */
1058     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {
1059         if (freeTransfer()) {
1060             return super.transferFrom(_from, _to, _value);
1061         }
1062         else {
1063             uint256 usageFee = transferFee(_value);
1064             uint256 netValue = _value.sub(usageFee);
1065 
1066             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
1067             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
1068 
1069             return feeTransferred && netValueTransferred;
1070         }
1071     }
1072 
1073     /**
1074     * @dev Burn a specific amount of tokens, paying the service fee.
1075     * @param _amount The amount of token to be burned.
1076     */
1077     function burn(uint256 _amount) public canBurn {
1078         require(_amount > 0, "_amount is zero");
1079 
1080         super.burn(_amount);
1081 
1082         require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");
1083     }
1084 
1085     /**
1086     * @dev Mint a specific amount of tokens, paying the service fee.
1087     * @param _to The address that will receive the minted tokens.
1088     * @param _amount The amount of tokens to mint.
1089     * @return A boolean that indicates if the operation was successful.
1090     */
1091     function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1092         require(_to != 0, "_to is zero");
1093         require(_amount > 0, "_amount is zero");
1094 
1095         super.mint(_to, _amount);
1096 
1097         if (mintingFeeEnabled) {
1098             require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");
1099         }
1100 
1101         return true;
1102     }
1103 
1104     /**
1105     * @dev Mint new locked tokens, which will unlock progressively.
1106     * @param _to The address that will receieve the minted locked tokens.
1107     * @param _amount The amount of tokens to mint.
1108     * @return A boolean that indicates if the operation was successful.
1109     */
1110     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1111         initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);
1112 
1113         return mint(_to, _amount);
1114     }
1115 
1116     /**
1117      * @dev Mint the specified amount of timelocked tokens.
1118      * @param _to The address that will receieve the minted locked tokens.
1119      * @param _amount The amount of tokens to mint.
1120      * @param _releaseTime The token release time as timestamp from Unix epoch.
1121      * @return A boolean that indicates if the operation was successful.
1122      */
1123     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint
1124     returns(bool minted)
1125     {
1126         require(timelock == address(0), "TokenTimelock already activated");
1127 
1128         timelock = new TokenTimelock(this, _to, _releaseTime);
1129 
1130         minted = mint(timelock, _amount);
1131 
1132         require(pricingPlan.payFee(TIMELOCK_SERVICE_NAME, _amount, msg.sender), "timelock fee failed");
1133     }
1134 
1135     /**
1136     * @dev Mint the specified amount of vested tokens.
1137     * @param _to The address that will receieve the minted vested tokens.
1138     * @param _amount The amount of tokens to mint.
1139     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
1140     * @param _duration The duration in seconds of the period in which the tokens will vest.
1141     * @return A boolean that indicates if the operation was successful.
1142     */
1143     function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public onlyOwner canMint
1144     returns(bool minted)
1145     {
1146         require(vesting == address(0), "TokenVesting already activated");
1147 
1148         vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
1149 
1150         minted = mint(vesting, _amount);
1151 
1152         require(pricingPlan.payFee(VESTING_SERVICE_NAME, _amount, msg.sender), "vesting fee failed");
1153     }
1154 
1155     /**
1156      * @dev Release vested tokens to the beneficiary. Anyone can release vested tokens.
1157     * @return A boolean that indicates if the operation was successful.
1158      */
1159     function releaseVested() public returns(bool released) {
1160         require(vesting != address(0), "TokenVesting not activated");
1161 
1162         vesting.release(this);
1163 
1164         return true;
1165     }
1166 
1167     /**
1168      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
1169     * @return A boolean that indicates if the operation was successful.
1170      */
1171     function revokeVested() public onlyOwner returns(bool revoked) {
1172         require(vesting != address(0), "TokenVesting not activated");
1173 
1174         vesting.revoke(this);
1175 
1176         return true;
1177     }
1178 }
1179 
1180 // File: openzeppelin-solidity/contracts/AddressUtils.sol
1181 
1182 /**
1183  * Utility library of inline functions on addresses
1184  */
1185 library AddressUtils {
1186 
1187   /**
1188    * Returns whether the target address is a contract
1189    * @dev This function will return false if invoked during the constructor of a contract,
1190    *  as the code is not actually created until after the constructor finishes.
1191    * @param addr address to check
1192    * @return whether the target address is a contract
1193    */
1194   function isContract(address addr) internal view returns (bool) {
1195     uint256 size;
1196     // XXX Currently there is no better way to check if there is a contract in an address
1197     // than to check the size of the code at that address.
1198     // See https://ethereum.stackexchange.com/a/14016/36603
1199     // for more details about how this works.
1200     // TODO Check this again before the Serenity release, because all addresses will be
1201     // contracts then.
1202     // solium-disable-next-line security/no-inline-assembly
1203     assembly { size := extcodesize(addr) }
1204     return size > 0;
1205   }
1206 
1207 }
1208 
1209 // File: contracts/NokuCustomService.sol
1210 
1211 contract NokuCustomService is Pausable {
1212     using AddressUtils for address;
1213 
1214     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
1215 
1216     // The pricing plan determining the fee to be paid in NOKU tokens by customers
1217     NokuPricingPlan public pricingPlan;
1218 
1219     constructor(address _pricingPlan) internal {
1220         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1221 
1222         pricingPlan = NokuPricingPlan(_pricingPlan);
1223     }
1224 
1225     function setPricingPlan(address _pricingPlan) public onlyOwner {
1226         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1227         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
1228         
1229         pricingPlan = NokuPricingPlan(_pricingPlan);
1230 
1231         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
1232     }
1233 }
1234 
1235 // File: contracts/NokuCustomERC20Service.sol
1236 
1237 /**
1238 * @dev The NokuCustomERC2Service contract .
1239 */
1240 contract NokuCustomERC20Service is NokuCustomService {
1241     event LogNokuCustomERC20ServiceCreated(address caller, address indexed pricingPlan);
1242 
1243     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
1244 
1245     uint8 public constant DECIMALS = 18;
1246 
1247     bytes32 public constant CUSTOM_ERC20_CREATE_SERVICE_NAME = "NokuCustomERC20.create";
1248 
1249     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
1250         emit LogNokuCustomERC20ServiceCreated(msg.sender, _pricingPlan);
1251     }
1252 
1253     // TODO: REMOVE
1254     function createCustomToken(string _name, string _symbol, uint8 /*_decimals*/) public returns(NokuCustomERC20 customToken) {
1255         customToken = new NokuCustomERC20(
1256             _name,
1257             _symbol,
1258             DECIMALS,
1259             block.number,
1260             block.number,
1261             pricingPlan,
1262             owner
1263         );
1264 
1265         // Transfer NokuCustomERC20 ownership to the client
1266         customToken.transferOwnership(msg.sender);
1267 
1268         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1269     }
1270 
1271     function createCustomToken(
1272         string _name,
1273         string _symbol,
1274         uint8 /*_decimals*/,
1275         uint256 transferableFromBlock,
1276         uint256 lockEndBlock
1277     )
1278     public returns(NokuCustomERC20 customToken)
1279     {
1280         customToken = new NokuCustomERC20(
1281             _name,
1282             _symbol,
1283             DECIMALS,
1284             transferableFromBlock,
1285             lockEndBlock,
1286             pricingPlan,
1287             owner
1288         );
1289 
1290         // Transfer NokuCustomERC20 ownership to the client
1291         customToken.transferOwnership(msg.sender);
1292 
1293         require(pricingPlan.payFee(CUSTOM_ERC20_CREATE_SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1294     }
1295 }