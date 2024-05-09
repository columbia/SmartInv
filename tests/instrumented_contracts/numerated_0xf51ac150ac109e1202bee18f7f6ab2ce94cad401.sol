1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address _who) public view returns (uint256);
13   function transfer(address _to, uint256 _value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (_a == 0) {
33       return 0;
34     }
35 
36     c = _a * _b;
37     assert(c / _a == _b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     // assert(_b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = _a / _b;
47     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
48     return _a / _b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     assert(_b <= _a);
56     return _a - _b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
63     c = _a + _b;
64     assert(c >= _a);
65     return c;
66   }
67 }
68 
69 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: contracts/mocks/BasicTokenMock.sol
116 
117 /// @title Mock token contract using Open Zepplein's BasicToken
118 /// @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/mocks/BasicTokenMock.sol
119 contract BasicTokenMock is BasicToken {
120     constructor (address initialAccount, uint256 initialBalance) public {
121         balances[initialAccount] = initialBalance;
122         totalSupply_ = initialBalance;
123     }
124 }
125 
126 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address _owner, address _spender)
134     public view returns (uint256);
135 
136   function transferFrom(address _from, address _to, uint256 _value)
137     public returns (bool);
138 
139   function approve(address _spender, uint256 _value) public returns (bool);
140   event Approval(
141     address indexed owner,
142     address indexed spender,
143     uint256 value
144   );
145 }
146 
147 // File: contracts/token/ERC1404/ERC1404.sol
148 
149 contract ERC1404 is ERC20 {
150     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
151     /// @param from Sending address
152     /// @param to Receiving address
153     /// @param value Amount of tokens being transferred
154     /// @return Code by which to reference message for rejection reasoning
155     /// @dev Overwrite with your custom transfer restriction logic
156     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
157 
158     /// @notice Returns a human-readable message for a given restriction code
159     /// @param restrictionCode Identifier for looking up a message
160     /// @return Text showing the restriction's reasoning
161     /// @dev Overwrite with your custom message and restrictionCode handling
162     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
163 }
164 
165 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
166 
167 /**
168  * @title DetailedERC20 token
169  * @dev The decimals are only for visualization purposes.
170  * All the operations are done using the smallest and indivisible token unit,
171  * just as on Ethereum all the operations are done in wei.
172  */
173 contract DetailedERC20 is ERC20 {
174   string public name;
175   string public symbol;
176   uint8 public decimals;
177 
178   constructor(string _name, string _symbol, uint8 _decimals) public {
179     name = _name;
180     symbol = _symbol;
181     decimals = _decimals;
182   }
183 }
184 
185 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * https://github.com/ethereum/EIPs/issues/20
192  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(
206     address _from,
207     address _to,
208     uint256 _value
209   )
210     public
211     returns (bool)
212   {
213     require(_value <= balances[_from]);
214     require(_value <= allowed[_from][msg.sender]);
215     require(_to != address(0));
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
220     emit Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param _spender The address which will spend the funds.
231    * @param _value The amount of tokens to be spent.
232    */
233   function approve(address _spender, uint256 _value) public returns (bool) {
234     allowed[msg.sender][_spender] = _value;
235     emit Approval(msg.sender, _spender, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Function to check the amount of tokens that an owner allowed to a spender.
241    * @param _owner address The address which owns the funds.
242    * @param _spender address The address which will spend the funds.
243    * @return A uint256 specifying the amount of tokens still available for the spender.
244    */
245   function allowance(
246     address _owner,
247     address _spender
248    )
249     public
250     view
251     returns (uint256)
252   {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(
266     address _spender,
267     uint256 _addedValue
268   )
269     public
270     returns (bool)
271   {
272     allowed[msg.sender][_spender] = (
273       allowed[msg.sender][_spender].add(_addedValue));
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(
288     address _spender,
289     uint256 _subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     uint256 oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue >= oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 
306 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
307 
308 /**
309  * @title Ownable
310  * @dev The Ownable contract has an owner address, and provides basic authorization control
311  * functions, this simplifies the implementation of "user permissions".
312  */
313 contract Ownable {
314   address public owner;
315 
316 
317   event OwnershipRenounced(address indexed previousOwner);
318   event OwnershipTransferred(
319     address indexed previousOwner,
320     address indexed newOwner
321   );
322 
323 
324   /**
325    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
326    * account.
327    */
328   constructor() public {
329     owner = msg.sender;
330   }
331 
332   /**
333    * @dev Throws if called by any account other than the owner.
334    */
335   modifier onlyOwner() {
336     require(msg.sender == owner);
337     _;
338   }
339 
340   /**
341    * @dev Allows the current owner to relinquish control of the contract.
342    * @notice Renouncing to ownership will leave the contract without an owner.
343    * It will not be possible to call the functions with the `onlyOwner`
344    * modifier anymore.
345    */
346   function renounceOwnership() public onlyOwner {
347     emit OwnershipRenounced(owner);
348     owner = address(0);
349   }
350 
351   /**
352    * @dev Allows the current owner to transfer control of the contract to a newOwner.
353    * @param _newOwner The address to transfer ownership to.
354    */
355   function transferOwnership(address _newOwner) public onlyOwner {
356     _transferOwnership(_newOwner);
357   }
358 
359   /**
360    * @dev Transfers control of the contract to a newOwner.
361    * @param _newOwner The address to transfer ownership to.
362    */
363   function _transferOwnership(address _newOwner) internal {
364     require(_newOwner != address(0));
365     emit OwnershipTransferred(owner, _newOwner);
366     owner = _newOwner;
367   }
368 }
369 
370 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
371 
372 /**
373  * @title Mintable token
374  * @dev Simple ERC20 Token example, with mintable token creation
375  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
376  */
377 contract MintableToken is StandardToken, Ownable {
378   event Mint(address indexed to, uint256 amount);
379   event MintFinished();
380 
381   bool public mintingFinished = false;
382 
383 
384   modifier canMint() {
385     require(!mintingFinished);
386     _;
387   }
388 
389   modifier hasMintPermission() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394   /**
395    * @dev Function to mint tokens
396    * @param _to The address that will receive the minted tokens.
397    * @param _amount The amount of tokens to mint.
398    * @return A boolean that indicates if the operation was successful.
399    */
400   function mint(
401     address _to,
402     uint256 _amount
403   )
404     public
405     hasMintPermission
406     canMint
407     returns (bool)
408   {
409     totalSupply_ = totalSupply_.add(_amount);
410     balances[_to] = balances[_to].add(_amount);
411     emit Mint(_to, _amount);
412     emit Transfer(address(0), _to, _amount);
413     return true;
414   }
415 
416   /**
417    * @dev Function to stop minting new tokens.
418    * @return True if the operation was successful.
419    */
420   function finishMinting() public onlyOwner canMint returns (bool) {
421     mintingFinished = true;
422     emit MintFinished();
423     return true;
424   }
425 }
426 
427 // File: contracts/token/R-Token/RegulatorService.sol
428 
429 /// @notice Standard interface for `RegulatorService`s extended for ERC-1404 compatability
430 contract RegulatorService {
431 
432   /*
433    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
434    *         The implementation *SHOULD* check whether or not a transfer can be approved.
435    *
436    * @dev    This method *MAY* call back to the token contract specified by `_token` for
437    *         more information needed to enforce trade approval.
438    *
439    * @param  _token The address of the token to be transfered
440    * @param  _spender The address of the spender of the token
441    * @param  _from The address of the sender account
442    * @param  _to The address of the receiver account
443    * @param  _amount The quantity of the token to trade
444    *
445    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
446    *               to assign meaning.
447    */
448   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
449 
450   /*
451    * @notice Returns the error message for a passed failed check reason.
452    *
453    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
454    *                 to assign meaning.
455    *
456    * @return The human-readable mesage string.
457    */
458   function messageForReason(uint8 _reason) public view returns (string);
459 }
460 
461 // File: contracts/token/R-Token/ServiceRegistry.sol
462 
463 /// @notice A service that points to a `RegulatorService`
464 contract ServiceRegistry is Ownable {
465   address public service;
466 
467   /**
468    * @notice Triggered when service address is replaced
469    */
470   event ReplaceService(address oldService, address newService);
471 
472   /**
473    * @dev Validate contract address
474    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
475    *
476    * @param _addr The address of a smart contract
477    */
478   modifier withContract(address _addr) {
479     uint length;
480     assembly { length := extcodesize(_addr) }
481     require(length > 0);
482     _;
483   }
484 
485   /**
486    * @notice Constructor
487    *
488    * @param _service The address of the `RegulatorService`
489    *
490    */
491   function ServiceRegistry(address _service) public {
492     service = _service;
493   }
494 
495   /**
496    * @notice Replaces the address pointer to the `RegulatorService`
497    *
498    * @dev This method is only callable by the contract's owner
499    *
500    * @param _service The address of the new `RegulatorService`
501    */
502   function replaceService(address _service) onlyOwner withContract(_service) public {
503     address oldService = service;
504     service = _service;
505     ReplaceService(oldService, service);
506   }
507 }
508 
509 // File: contracts/token/R-Token/RegulatedToken.sol
510 
511 /// @notice An ERC-20 token that has the ability to check for trade validity
512 contract RegulatedToken is DetailedERC20, MintableToken {
513 
514   /**
515    * @notice R-Token decimals setting (used when constructing DetailedERC20)
516    */
517   uint8 constant public RTOKEN_DECIMALS = 18;
518 
519   /**
520    * @notice Triggered when regulator checks pass or fail
521    */
522   event CheckStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);
523 
524   /**
525    * @notice Address of the `ServiceRegistry` that has the location of the
526    *         `RegulatorService` contract responsible for checking trade
527    *         permissions.
528    */
529   ServiceRegistry public registry;
530 
531   /**
532    * @notice Constructor
533    *
534    * @param _registry Address of `ServiceRegistry` contract
535    * @param _name Name of the token: See DetailedERC20
536    * @param _symbol Symbol of the token: See DetailedERC20
537    */
538   function RegulatedToken(ServiceRegistry _registry, string _name, string _symbol) public
539     DetailedERC20(_name, _symbol, RTOKEN_DECIMALS)
540   {
541     require(_registry != address(0));
542 
543     registry = _registry;
544   }
545 
546   /**
547    * @notice ERC-20 overridden function that include logic to check for trade validity.
548    *
549    * @param _to The address of the receiver
550    * @param _value The number of tokens to transfer
551    *
552    * @return `true` if successful and `false` if unsuccessful
553    */
554   function transfer(address _to, uint256 _value) public returns (bool) {
555     if (_check(msg.sender, _to, _value)) {
556       return super.transfer(_to, _value);
557     } else {
558       return false;
559     }
560   }
561 
562   /**
563    * @notice ERC-20 overridden function that include logic to check for trade validity.
564    *
565    * @param _from The address of the sender
566    * @param _to The address of the receiver
567    * @param _value The number of tokens to transfer
568    *
569    * @return `true` if successful and `false` if unsuccessful
570    */
571   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
572     if (_check(_from, _to, _value)) {
573       return super.transferFrom(_from, _to, _value);
574     } else {
575       return false;
576     }
577   }
578 
579   /**
580    * @notice Performs the regulator check
581    *
582    * @dev This method raises a CheckStatus event indicating success or failure of the check
583    *
584    * @param _from The address of the sender
585    * @param _to The address of the receiver
586    * @param _value The number of tokens to transfer
587    *
588    * @return `true` if the check was successful and `false` if unsuccessful
589    */
590   function _check(address _from, address _to, uint256 _value) private returns (bool) {
591     var reason = _service().check(this, msg.sender, _from, _to, _value);
592 
593     CheckStatus(reason, msg.sender, _from, _to, _value);
594 
595     return reason == 0;
596   }
597 
598   /**
599    * @notice Retreives the address of the `RegulatorService` that manages this token.
600    *
601    * @dev This function *MUST NOT* memoize the `RegulatorService` address.  This would
602    *      break the ability to upgrade the `RegulatorService`.
603    *
604    * @return The `RegulatorService` that manages this token.
605    */
606   function _service() constant public returns (RegulatorService) {
607     return RegulatorService(registry.service());
608   }
609 }
610 
611 // File: contracts/examples/other-standards/R-Token/RegulatedTokenExample.sol
612 
613 contract RegulatedTokenExample is ERC1404, RegulatedToken {
614     function RegulatedTokenExample(ServiceRegistry _registry, string _name, string _symbol) public
615         RegulatedToken(_registry, _name, _symbol)
616     {
617 
618     }
619 
620    /**
621     * @notice Implementing detectTransferRestriction makes this token ERC-1404 compatible
622     * 
623     * @dev Notice in the call to _service.check(), the 2nd argument is address 0.
624     *      This "spender" parameter is unused in Harbor's own R-Token implementation
625     *      and will have to be remain unused for the purposes of our example.
626     *
627     * @param from The address of the sender
628     * @param to The address of the receiver
629     * @param value The number of tokens to transfer
630     *
631     * @return A code that is associated with the reason for a failed check
632     */
633     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
634         return _service().check(this, address(0), from, to, value);
635     }
636 
637    /**
638     * @notice Implementing messageForTransferRestriction makes this token ERC-1404 compatible
639     *
640     * @dev The RegulatorService contract must implement the function messageforReason in this implementation
641     * 
642     * @param reason The restrictionCode returned from the service check
643     *
644     * @return The human-readable mesage string
645     */
646     function messageForTransferRestriction (uint8 reason) public view returns (string) {
647         return _service().messageForReason(reason);
648     }
649 }
650 
651 // File: contracts/mocks/LeviasToken.sol
652 
653 contract LeviasSecurityToken is BasicTokenMock, RegulatedTokenExample {
654     RegulatorService public service;
655 
656     constructor (
657         address initialAccount,
658         uint256 initialBalance,
659         ServiceRegistry registry,
660         string name,
661         string symbol
662     )
663         BasicTokenMock(initialAccount, initialBalance)
664         RegulatedTokenExample(registry, name, symbol)
665         public
666     {
667 
668     }
669 }