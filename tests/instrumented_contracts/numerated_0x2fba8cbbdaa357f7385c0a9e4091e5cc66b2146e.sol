1 pragma solidity 0.4.19;
2 
3 // File: contracts/NokuPricingPlan.sol
4 
5 /**
6 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
7 */
8 interface NokuPricingPlan {
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
26     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
27 }
28 
29 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused public {
104     paused = true;
105     Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     Unpause();
114   }
115 }
116 
117 // File: zeppelin-solidity/contracts/math/SafeMath.sol
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, throws on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129     if (a == 0) {
130       return 0;
131     }
132     uint256 c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return c;
145   }
146 
147   /**
148   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public view returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 // File: contracts/NokuTokenBurner.sol
193 
194 contract BurnableERC20 is ERC20 {
195     function burn(uint256 amount) public returns (bool burned);
196 }
197 
198 /**
199 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
200 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
201 */
202 contract NokuTokenBurner is Pausable {
203     using SafeMath for uint256;
204 
205     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
206     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
207 
208     // The wallet receiving the unburnt tokens.
209     address public wallet;
210 
211     // The percentage of tokens to burn after being received (range [0, 100])
212     uint256 public burningPercentage;
213 
214     // The cumulative amount of burnt tokens.
215     uint256 public burnedTokens;
216 
217     // The cumulative amount of tokens transferred back to the wallet.
218     uint256 public transferredTokens;
219 
220     /**
221     * @dev Create a new NokuTokenBurner with predefined burning fraction.
222     * @param _wallet The wallet receiving the unburnt tokens.
223     */
224     function NokuTokenBurner(address _wallet) public {
225         require(_wallet != address(0));
226         
227         wallet = _wallet;
228         burningPercentage = 100;
229 
230         LogNokuTokenBurnerCreated(msg.sender, _wallet);
231     }
232 
233     /**
234     * @dev Change the percentage of tokens to burn after being received.
235     * @param _burningPercentage The percentage of tokens to be burnt.
236     */
237     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
238         require(0 <= _burningPercentage && _burningPercentage <= 100);
239         require(_burningPercentage != burningPercentage);
240         
241         burningPercentage = _burningPercentage;
242 
243         LogBurningPercentageChanged(msg.sender, _burningPercentage);
244     }
245 
246     /**
247     * @dev Called after burnable tokens has been transferred for burning.
248     * @param _token THe extended ERC20 interface supported by the sent tokens.
249     * @param _amount The amount of burnable tokens just arrived ready for burning.
250     */
251     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
252         require(_token != address(0));
253         require(_amount > 0);
254 
255         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
256         if (amountToBurn > 0) {
257             assert(BurnableERC20(_token).burn(amountToBurn));
258             
259             burnedTokens = burnedTokens.add(amountToBurn);
260         }
261 
262         uint256 amountToTransfer = _amount.sub(amountToBurn);
263         if (amountToTransfer > 0) {
264             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
265 
266             transferredTokens = transferredTokens.add(amountToTransfer);
267         }
268     }
269 }
270 
271 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
272 
273 /**
274  * @title Basic token
275  * @dev Basic version of StandardToken, with no allowances.
276  */
277 contract BasicToken is ERC20Basic {
278   using SafeMath for uint256;
279 
280   mapping(address => uint256) balances;
281 
282   uint256 totalSupply_;
283 
284   /**
285   * @dev total number of tokens in existence
286   */
287   function totalSupply() public view returns (uint256) {
288     return totalSupply_;
289   }
290 
291   /**
292   * @dev transfer token for a specified address
293   * @param _to The address to transfer to.
294   * @param _value The amount to be transferred.
295   */
296   function transfer(address _to, uint256 _value) public returns (bool) {
297     require(_to != address(0));
298     require(_value <= balances[msg.sender]);
299 
300     // SafeMath.sub will throw if there is not enough balance.
301     balances[msg.sender] = balances[msg.sender].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     Transfer(msg.sender, _to, _value);
304     return true;
305   }
306 
307   /**
308   * @dev Gets the balance of the specified address.
309   * @param _owner The address to query the the balance of.
310   * @return An uint256 representing the amount owned by the passed address.
311   */
312   function balanceOf(address _owner) public view returns (uint256 balance) {
313     return balances[_owner];
314   }
315 
316 }
317 
318 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
319 
320 /**
321  * @title Burnable Token
322  * @dev Token that can be irreversibly burned (destroyed).
323  */
324 contract BurnableToken is BasicToken {
325 
326   event Burn(address indexed burner, uint256 value);
327 
328   /**
329    * @dev Burns a specific amount of tokens.
330    * @param _value The amount of token to be burned.
331    */
332   function burn(uint256 _value) public {
333     require(_value <= balances[msg.sender]);
334     // no need to require value <= totalSupply, since that would imply the
335     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
336 
337     address burner = msg.sender;
338     balances[burner] = balances[burner].sub(_value);
339     totalSupply_ = totalSupply_.sub(_value);
340     Burn(burner, _value);
341   }
342 }
343 
344 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
345 
346 contract DetailedERC20 is ERC20 {
347   string public name;
348   string public symbol;
349   uint8 public decimals;
350 
351   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
352     name = _name;
353     symbol = _symbol;
354     decimals = _decimals;
355   }
356 }
357 
358 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
359 
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * @dev https://github.com/ethereum/EIPs/issues/20
365  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  */
367 contract StandardToken is ERC20, BasicToken {
368 
369   mapping (address => mapping (address => uint256)) internal allowed;
370 
371 
372   /**
373    * @dev Transfer tokens from one address to another
374    * @param _from address The address which you want to send tokens from
375    * @param _to address The address which you want to transfer to
376    * @param _value uint256 the amount of tokens to be transferred
377    */
378   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
379     require(_to != address(0));
380     require(_value <= balances[_from]);
381     require(_value <= allowed[_from][msg.sender]);
382 
383     balances[_from] = balances[_from].sub(_value);
384     balances[_to] = balances[_to].add(_value);
385     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
386     Transfer(_from, _to, _value);
387     return true;
388   }
389 
390   /**
391    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
392    *
393    * Beware that changing an allowance with this method brings the risk that someone may use both the old
394    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
395    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
396    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397    * @param _spender The address which will spend the funds.
398    * @param _value The amount of tokens to be spent.
399    */
400   function approve(address _spender, uint256 _value) public returns (bool) {
401     allowed[msg.sender][_spender] = _value;
402     Approval(msg.sender, _spender, _value);
403     return true;
404   }
405 
406   /**
407    * @dev Function to check the amount of tokens that an owner allowed to a spender.
408    * @param _owner address The address which owns the funds.
409    * @param _spender address The address which will spend the funds.
410    * @return A uint256 specifying the amount of tokens still available for the spender.
411    */
412   function allowance(address _owner, address _spender) public view returns (uint256) {
413     return allowed[_owner][_spender];
414   }
415 
416   /**
417    * @dev Increase the amount of tokens that an owner allowed to a spender.
418    *
419    * approve should be called when allowed[_spender] == 0. To increment
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _addedValue The amount of tokens to increase the allowance by.
425    */
426   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
427     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
428     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
429     return true;
430   }
431 
432   /**
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434    *
435    * approve should be called when allowed[_spender] == 0. To decrement
436    * allowed value is better to use this function to avoid 2 calls (and wait until
437    * the first transaction is mined)
438    * From MonolithDAO Token.sol
439    * @param _spender The address which will spend the funds.
440    * @param _subtractedValue The amount of tokens to decrease the allowance by.
441    */
442   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
443     uint oldValue = allowed[msg.sender][_spender];
444     if (_subtractedValue > oldValue) {
445       allowed[msg.sender][_spender] = 0;
446     } else {
447       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
448     }
449     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
450     return true;
451   }
452 
453 }
454 
455 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
456 
457 /**
458  * @title Mintable token
459  * @dev Simple ERC20 Token example, with mintable token creation
460  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
461  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
462  */
463 contract MintableToken is StandardToken, Ownable {
464   event Mint(address indexed to, uint256 amount);
465   event MintFinished();
466 
467   bool public mintingFinished = false;
468 
469 
470   modifier canMint() {
471     require(!mintingFinished);
472     _;
473   }
474 
475   /**
476    * @dev Function to mint tokens
477    * @param _to The address that will receive the minted tokens.
478    * @param _amount The amount of tokens to mint.
479    * @return A boolean that indicates if the operation was successful.
480    */
481   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
482     totalSupply_ = totalSupply_.add(_amount);
483     balances[_to] = balances[_to].add(_amount);
484     Mint(_to, _amount);
485     Transfer(address(0), _to, _amount);
486     return true;
487   }
488 
489   /**
490    * @dev Function to stop minting new tokens.
491    * @return True if the operation was successful.
492    */
493   function finishMinting() onlyOwner canMint public returns (bool) {
494     mintingFinished = true;
495     MintFinished();
496     return true;
497   }
498 }
499 
500 // File: contracts/NokuCustomERC20.sol
501 
502 /**
503 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
504 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
505 * by minting or burning tokens in order to increase or decrease the token supply.
506 */
507 contract NokuCustomERC20 is Ownable, DetailedERC20, MintableToken, BurnableToken {
508     using SafeMath for uint256;
509 
510     event LogNokuCustomERC20Created(
511         address indexed caller,
512         string indexed name,
513         string indexed symbol,
514         uint8 decimals,
515         address pricingPlan,
516         address serviceProvider
517     );
518     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
519     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
520 
521     // The entity acting as Custom token service provider i.e. Noku
522     address public serviceProvider;
523 
524     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
525     address public pricingPlan;
526 
527     // The fee percentage for Custom token transfer or zero if transfer is free of charge
528     uint256 public transferFeePercentage;
529 
530     bytes32 public constant CUSTOM_ERC20_BURN_SERVICE_NAME = "NokuCustomERC20.burn";
531     bytes32 public constant CUSTOM_ERC20_MINT_SERVICE_NAME = "NokuCustomERC20.mint";
532 
533     /**
534     * @dev Modifier to make a function callable only by service provider i.e. Noku.
535     */
536     modifier onlyServiceProvider() {
537         require(msg.sender == serviceProvider);
538         _;
539     }
540 
541     function NokuCustomERC20(
542         string _name,
543         string _symbol,
544         uint8 _decimals,
545         address _pricingPlan,
546         address _serviceProvider
547     )
548     DetailedERC20 (_name, _symbol, _decimals) public
549     {
550         require(bytes(_name).length > 0);
551         require(bytes(_symbol).length > 0);
552         require(_pricingPlan != 0);
553         require(_serviceProvider != 0);
554 
555         pricingPlan = _pricingPlan;
556         serviceProvider = _serviceProvider;
557 
558         LogNokuCustomERC20Created(
559             msg.sender,
560             _name,
561             _symbol,
562             _decimals,
563             _pricingPlan,
564             _serviceProvider
565         );
566     }
567 
568     function isCustomToken() public pure returns(bool isCustom) {
569         return true;
570     }
571 
572     /**
573     * @dev Change the transfer fee percentage to be paid in Custom tokens.
574     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
575     */
576     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
577         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100);
578         require(_transferFeePercentage != transferFeePercentage);
579 
580         transferFeePercentage = _transferFeePercentage;
581 
582         LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
583     }
584 
585     /**
586     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
587     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
588     */
589     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
590         require(_pricingPlan != 0);
591         require(_pricingPlan != pricingPlan);
592 
593         pricingPlan = _pricingPlan;
594 
595         LogPricingPlanChanged(msg.sender, _pricingPlan);
596     }
597 
598     /**
599     * @dev Get the fee to be paid for the transfer of NOKU tokens.
600     * @param _value The amount of NOKU tokens to be transferred.
601     */
602     function transferFee(uint256 _value) public view returns (uint256 usageFee) {
603         return _value.mul(transferFeePercentage).div(100);
604     }
605 
606     /**
607     * @dev Override #transfer for optionally paying fee to Custom token owner.
608     */
609     function transfer(address _to, uint256 _value) public returns (bool transferred) {
610         if (transferFeePercentage == 0) {
611             return super.transfer(_to, _value);
612         }
613         else {
614             uint256 usageFee = transferFee(_value);
615             uint256 netValue = _value.sub(usageFee);
616 
617             bool feeTransferred = super.transfer(owner, usageFee);
618             bool netValueTransferred = super.transfer(_to, netValue);
619 
620             return feeTransferred && netValueTransferred;
621         }
622     }
623 
624     /**
625     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
626     */
627     function transferFrom(address _from, address _to, uint256 _value) public returns (bool transferred) {
628         if (transferFeePercentage == 0) {
629             return super.transferFrom(_from, _to, _value);
630         }
631         else {
632             uint256 usageFee = transferFee(_value);
633             uint256 netValue = _value.sub(usageFee);
634 
635             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
636             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
637 
638             return feeTransferred && netValueTransferred;
639         }
640     }
641 
642     /**
643     * @dev Burn a specific amount of tokens, paying the service fee.
644     * @param _amount The amount of token to be burned.
645     */
646     function burn(uint256 _amount) public {
647         require(_amount > 0);
648 
649         super.burn(_amount);
650 
651         require(NokuPricingPlan(pricingPlan).payFee(CUSTOM_ERC20_BURN_SERVICE_NAME, _amount, msg.sender));
652     }
653 
654     /**
655     * @dev Mint a specific amount of tokens, paying the service fee.
656     * @param _to The address that will receive the minted tokens.
657     * @param _amount The amount of tokens to mint.
658     * @return A boolean that indicates if the operation was successful.
659     */
660     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool minted) {
661         require(_to != 0);
662         require(_amount > 0);
663 
664         super.mint(_to, _amount);
665 
666         require(NokuPricingPlan(pricingPlan).payFee(CUSTOM_ERC20_MINT_SERVICE_NAME, _amount, msg.sender));
667 
668         return true;
669     }
670 }