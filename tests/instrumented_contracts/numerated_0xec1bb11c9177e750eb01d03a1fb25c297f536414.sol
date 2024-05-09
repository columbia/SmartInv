1 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address _owner, address _spender)
30     public view returns (uint256);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: contracts/ERC1404.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 contract ERC1404 is ERC20 {
49     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
50     /// @param from Sending address
51     /// @param to Receiving address
52     /// @param value Amount of tokens being transferred
53     /// @return Code by which to reference message for rejection reasoning
54     /// @dev Overwrite with your custom transfer restriction logic
55     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
56 
57     /// @notice Returns a human-readable message for a given restriction code
58     /// @param restrictionCode Identifier for looking up a message
59     /// @return Text showing the restriction's reasoning
60     /// @dev Overwrite with your custom message and restrictionCode handling
61     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
62 }
63 
64 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
65 
66 pragma solidity ^0.4.24;
67 
68 
69 
70 /**
71  * @title DetailedERC20 token
72  * @dev The decimals are only for visualization purposes.
73  * All the operations are done using the smallest and indivisible token unit,
74  * just as on Ethereum all the operations are done in wei.
75  */
76 contract DetailedERC20 is ERC20 {
77   string public name;
78   string public symbol;
79   uint8 public decimals;
80 
81   constructor(string _name, string _symbol, uint8 _decimals) public {
82     name = _name;
83     symbol = _symbol;
84     decimals = _decimals;
85   }
86 }
87 
88 // File: zeppelin-solidity/contracts/math/SafeMath.sol
89 
90 pragma solidity ^0.4.24;
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (_a == 0) {
107       return 0;
108     }
109 
110     c = _a * _b;
111     assert(c / _a == _b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
119     // assert(_b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = _a / _b;
121     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
122     return _a / _b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     assert(_b <= _a);
130     return _a - _b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
137     c = _a + _b;
138     assert(c >= _a);
139     return c;
140   }
141 }
142 
143 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
144 
145 pragma solidity ^0.4.24;
146 
147 
148 
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) internal balances;
158 
159   uint256 internal totalSupply_;
160 
161   /**
162   * @dev Total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev Transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_value <= balances[msg.sender]);
175     require(_to != address(0));
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
195 
196 pragma solidity ^0.4.24;
197 
198 
199 
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * https://github.com/ethereum/EIPs/issues/20
206  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
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
219   function transferFrom(
220     address _from,
221     address _to,
222     uint256 _value
223   )
224     public
225     returns (bool)
226   {
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229     require(_to != address(0));
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     emit Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     emit Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(
260     address _owner,
261     address _spender
262    )
263     public
264     view
265     returns (uint256)
266   {
267     return allowed[_owner][_spender];
268   }
269 
270   /**
271    * @dev Increase the amount of tokens that an owner allowed to a spender.
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(
280     address _spender,
281     uint256 _addedValue
282   )
283     public
284     returns (bool)
285   {
286     allowed[msg.sender][_spender] = (
287       allowed[msg.sender][_spender].add(_addedValue));
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(
302     address _spender,
303     uint256 _subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     uint256 oldValue = allowed[msg.sender][_spender];
309     if (_subtractedValue >= oldValue) {
310       allowed[msg.sender][_spender] = 0;
311     } else {
312       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
313     }
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318 }
319 
320 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
321 
322 pragma solidity ^0.4.24;
323 
324 
325 /**
326  * @title Ownable
327  * @dev The Ownable contract has an owner address, and provides basic authorization control
328  * functions, this simplifies the implementation of "user permissions".
329  */
330 contract Ownable {
331   address public owner;
332 
333 
334   event OwnershipRenounced(address indexed previousOwner);
335   event OwnershipTransferred(
336     address indexed previousOwner,
337     address indexed newOwner
338   );
339 
340 
341   /**
342    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
343    * account.
344    */
345   constructor() public {
346     owner = msg.sender;
347   }
348 
349   /**
350    * @dev Throws if called by any account other than the owner.
351    */
352   modifier onlyOwner() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Allows the current owner to relinquish control of the contract.
359    * @notice Renouncing to ownership will leave the contract without an owner.
360    * It will not be possible to call the functions with the `onlyOwner`
361    * modifier anymore.
362    */
363   function renounceOwnership() public onlyOwner {
364     emit OwnershipRenounced(owner);
365     owner = address(0);
366   }
367 
368   /**
369    * @dev Allows the current owner to transfer control of the contract to a newOwner.
370    * @param _newOwner The address to transfer ownership to.
371    */
372   function transferOwnership(address _newOwner) public onlyOwner {
373     _transferOwnership(_newOwner);
374   }
375 
376   /**
377    * @dev Transfers control of the contract to a newOwner.
378    * @param _newOwner The address to transfer ownership to.
379    */
380   function _transferOwnership(address _newOwner) internal {
381     require(_newOwner != address(0));
382     emit OwnershipTransferred(owner, _newOwner);
383     owner = _newOwner;
384   }
385 }
386 
387 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
388 
389 pragma solidity ^0.4.24;
390 
391 
392 
393 
394 /**
395  * @title Mintable token
396  * @dev Simple ERC20 Token example, with mintable token creation
397  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
398  */
399 contract MintableToken is StandardToken, Ownable {
400   event Mint(address indexed to, uint256 amount);
401   event MintFinished();
402 
403   bool public mintingFinished = false;
404 
405 
406   modifier canMint() {
407     require(!mintingFinished);
408     _;
409   }
410 
411   modifier hasMintPermission() {
412     require(msg.sender == owner);
413     _;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param _to The address that will receive the minted tokens.
419    * @param _amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(
423     address _to,
424     uint256 _amount
425   )
426     public
427     hasMintPermission
428     canMint
429     returns (bool)
430   {
431     totalSupply_ = totalSupply_.add(_amount);
432     balances[_to] = balances[_to].add(_amount);
433     emit Mint(_to, _amount);
434     emit Transfer(address(0), _to, _amount);
435     return true;
436   }
437 
438   /**
439    * @dev Function to stop minting new tokens.
440    * @return True if the operation was successful.
441    */
442   function finishMinting() public onlyOwner canMint returns (bool) {
443     mintingFinished = true;
444     emit MintFinished();
445     return true;
446   }
447 }
448 
449 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
450 
451 pragma solidity ^0.4.24;
452 
453 
454 
455 /**
456  * @title Burnable Token
457  * @dev Token that can be irreversibly burned (destroyed).
458  */
459 contract BurnableToken is BasicToken {
460 
461   event Burn(address indexed burner, uint256 value);
462 
463   /**
464    * @dev Burns a specific amount of tokens.
465    * @param _value The amount of token to be burned.
466    */
467   function burn(uint256 _value) public {
468     _burn(msg.sender, _value);
469   }
470 
471   function _burn(address _who, uint256 _value) internal {
472     require(_value <= balances[_who]);
473     // no need to require value <= totalSupply, since that would imply the
474     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
475 
476     balances[_who] = balances[_who].sub(_value);
477     totalSupply_ = totalSupply_.sub(_value);
478     emit Burn(_who, _value);
479     emit Transfer(_who, address(0), _value);
480   }
481 }
482 
483 // File: contracts/ServiceRegistry.sol
484 
485 /**
486    Copyright (c) 2017 Harbor Platform, Inc.
487 
488    Licensed under the Apache License, Version 2.0 (the “License”);
489    you may not use this file except in compliance with the License.
490    You may obtain a copy of the License at
491 
492    http://www.apache.org/licenses/LICENSE-2.0
493 
494    Unless required by applicable law or agreed to in writing, software
495    distributed under the License is distributed on an “AS IS” BASIS,
496    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
497    See the License for the specific language governing permissions and
498    limitations under the License.
499 */
500 
501 pragma solidity ^0.4.24;
502 
503 
504 /// @notice A service that points to a `RegulatorService`
505 contract ServiceRegistry is Ownable {
506   address public service;
507 
508   /**
509    * @notice Triggered when service address is replaced
510    */
511   event ReplaceService(address oldService, address newService);
512 
513   /**
514    * @dev Validate contract address
515    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
516    *
517    * @param _addr The address of a smart contract
518    */
519   modifier withContract(address _addr) {
520     uint length;
521     assembly { length := extcodesize(_addr) }
522     require(length > 0);
523     _;
524   }
525 
526   /**
527    * @notice Constructor
528    *
529    * @param _service The address of the `RegulatorService`
530    *
531    */
532   constructor(address _service) public {
533     service = _service;
534   }
535 
536   /**
537    * @notice Replaces the address pointer to the `RegulatorService`
538    *
539    * @dev This method is only callable by the contract's owner
540    *
541    * @param _service The address of the new `RegulatorService`
542    */
543   function replaceService(address _service) onlyOwner withContract(_service) public {
544     address oldService = service;
545     service = _service;
546     emit ReplaceService(oldService, service);
547   }
548 }
549 
550 // File: contracts/RegulatorServiceI.sol
551 
552 /**
553    Copyright (c) 2017 Harbor Platform, Inc.
554 
555    Licensed under the Apache License, Version 2.0 (the “License”);
556    you may not use this file except in compliance with the License.
557    You may obtain a copy of the License at
558 
559    http://www.apache.org/licenses/LICENSE-2.0
560 
561    Unless required by applicable law or agreed to in writing, software
562    distributed under the License is distributed on an “AS IS” BASIS,
563    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
564    See the License for the specific language governing permissions and
565    limitations under the License.
566 */
567 
568 pragma solidity ^0.4.24;
569 
570 /// @notice Standard interface for `RegulatorService`s
571 contract RegulatorServiceI {
572 
573   /*
574    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
575    *         The implementation *SHOULD* check whether or not a transfer can be approved.
576    *
577    * @dev    This method *MAY* call back to the token contract specified by `_token` for
578    *         more information needed to enforce trade approval.
579    *
580    * @param  _token The address of the token to be transfered
581    * @param  _spender The address of the spender of the token
582    * @param  _from The address of the sender account
583    * @param  _to The address of the receiver account
584    * @param  _amount The quantity of the token to trade
585    *
586    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
587    *               to assign meaning.
588    */
589   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
590 }
591 
592 // File: contracts/RegulatorService.sol
593 
594 pragma solidity ^0.4.18;
595 
596 
597 
598 
599 /**
600  * @title  On-chain RegulatorService implementation for approving trades
601  * @author Originally Bob Remeika, modified by TokenSoft Inc
602  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
603  */
604 contract RegulatorService is RegulatorServiceI, Ownable {
605   /**
606    * @dev Throws if called by any account other than the admin
607    */
608   modifier onlyAdmins() {
609     require(msg.sender == admin || msg.sender == owner);
610     _;
611   }
612 
613   /// @dev Settings that affect token trading at a global level
614   struct Settings {
615 
616     /**
617      * @dev Toggle for locking/unlocking trades at a token level.
618      *      The default behavior of the zero memory state for locking will be unlocked.
619      */
620     bool locked;
621 
622     /**
623      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
624      *      The default state when this contract is created `false` (or no partial
625      *      transfers allowed).
626      */
627     bool partialTransfers;
628 
629     /**
630      * @dev Mappning for 12 months hold up period for investors.
631      * @param  address investors wallet
632      * @param  uint256 holdingPeriod start date in unix
633      */
634     mapping(address => uint256) holdingPeriod;
635   }
636 
637   // @dev number of seconds in a year = 365 * 24 * 60 * 60
638   uint256 constant private YEAR = 1 years;
639 
640   // @dev Check success code & message
641   uint8 constant private CHECK_SUCCESS = 0;
642   string constant private SUCCESS_MESSAGE = 'Success';
643 
644   // @dev Check error reason: Token is locked
645   uint8 constant private CHECK_ELOCKED = 1;
646   string constant private ELOCKED_MESSAGE = 'Token is locked';
647 
648   // @dev Check error reason: Token can not trade partial amounts
649   uint8 constant private CHECK_EDIVIS = 2;
650   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
651 
652   // @dev Check error reason: Sender is not allowed to send the token
653   uint8 constant private CHECK_ESEND = 3;
654   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
655 
656   // @dev Check error reason: Receiver is not allowed to receive the token
657   uint8 constant private CHECK_ERECV = 4;
658   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
659 
660   uint8 constant private CHECK_EHOLDING_PERIOD = 5;
661   string constant private EHOLDING_PERIOD_MESSAGE = 'Sender is still in 12 months holding period';
662 
663   uint8 constant private CHECK_EDECIMALS = 6;
664   string constant private EDECIMALS_MESSAGE = 'Transfer value must be bigger than MINIMAL_TRANSFER';
665 
666   uint256 constant public MINIMAL_TRANSFER = 1 wei;
667 
668   /// @dev Permission bits for allowing a participant to send tokens
669   uint8 constant private PERM_SEND = 0x1;
670 
671   /// @dev Permission bits for allowing a participant to receive tokens
672   uint8 constant private PERM_RECEIVE = 0x2;
673 
674   // @dev Address of the administrator
675   address public admin;
676 
677   /// @notice Permissions that allow/disallow token trades on a per token level
678   mapping(address => Settings) private settings;
679 
680   /// @dev Permissions that allow/disallow token trades on a per participant basis.
681   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
682   ///      which returns the permission bits of a participant for a particular token.
683   mapping(address => mapping(address => uint8)) private participants;
684 
685   /// @dev Event raised when a token's locked setting is set
686   event LogLockSet(address indexed token, bool locked);
687 
688   /// @dev Event raised when a token's partial transfer setting is set
689   event LogPartialTransferSet(address indexed token, bool enabled);
690 
691   /// @dev Event raised when a participant permissions are set for a token
692   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
693 
694   /// @dev Event raised when the admin address changes
695   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
696 
697   /// @dev Event raised when holding period start date is set for participant
698   event LogHoldingPeriod(
699     address indexed _token, address indexed _participant, uint256 _startDate);
700 
701   constructor() public {
702     admin = msg.sender;
703   }
704 
705   /**
706    * @notice Locks the ability to trade a token
707    *
708    * @dev    This method can only be called by this contract's owner
709    *
710    * @param  _token The address of the token to lock
711    */
712   function setLocked(address _token, bool _locked) onlyOwner public {
713     settings[_token].locked = _locked;
714 
715     emit LogLockSet(_token, _locked);
716   }
717 
718   /**
719    * @notice Allows the ability to trade a fraction of a token
720    *
721    * @dev    This method can only be called by this contract's owner
722    *
723    * @param  _token The address of the token to allow partial transfers
724    */
725   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
726    settings[_token].partialTransfers = _enabled;
727 
728    emit LogPartialTransferSet(_token, _enabled);
729   }
730 
731   /**
732    * @notice Sets the trade permissions for a participant on a token
733    *
734    * @dev    The `_permission` bits overwrite the previous trade permissions and can
735    *         only be called by the contract's owner.  `_permissions` can be bitwise
736    *         `|`'d together to allow for more than one permission bit to be set.
737    *
738    * @param  _token The address of the token
739    * @param  _participant The address of the trade participant
740    * @param  _permission Permission bits to be set
741    */
742   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
743     participants[_token][_participant] = _permission;
744 
745     emit LogPermissionSet(_token, _participant, _permission);
746   }
747 
748   /**
749    * @notice Set initial holding period for investor
750    * @param _token       token address
751    * @param _participant participant address
752    * @param _startDate   start date of holding period in UNIX format
753    */
754   function setHoldingPeriod(address _token, address _participant, uint256 _startDate) onlyAdmins public {
755     settings[_token].holdingPeriod[_participant] = _startDate;
756 
757     emit LogHoldingPeriod(_token, _participant, _startDate);
758   }
759 
760   /**
761    * @dev Allows the owner to transfer admin controls to newAdmin.
762    *
763    * @param newAdmin The address to transfer admin rights to.
764    */
765   function transferAdmin(address newAdmin) onlyOwner public {
766     require(newAdmin != address(0));
767 
768     address oldAdmin = admin;
769     admin = newAdmin;
770 
771     emit LogTransferAdmin(oldAdmin, newAdmin);
772   }
773 
774   /**
775    * @notice Checks whether or not a trade should be approved
776    *
777    * @dev    This method calls back to the token contract specified by `_token` for
778    *         information needed to enforce trade approval if needed
779    *
780    * @param  _token The address of the token to be transfered
781    * @param  _spender The address of the spender of the token (unused in this implementation)
782    * @param  _from The address of the sender account
783    * @param  _to The address of the receiver account
784    * @param  _amount The quantity of the token to trade
785    *
786    * @return `true` if the trade should be approved and `false` if the trade should not be approved
787    */
788   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
789     if (settings[_token].locked) {
790       return CHECK_ELOCKED;
791     }
792 
793     if (participants[_token][_from] & PERM_SEND == 0) {
794       return CHECK_ESEND;
795     }
796 
797     if (participants[_token][_to] & PERM_RECEIVE == 0) {
798       return CHECK_ERECV;
799     }
800 
801     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
802       return CHECK_EDIVIS;
803     }
804 
805     if (settings[_token].holdingPeriod[_from] + YEAR >= now) {
806       return CHECK_EHOLDING_PERIOD;
807     }
808 
809     if (_amount < MINIMAL_TRANSFER) {
810       return CHECK_EDECIMALS;
811     }
812 
813     return CHECK_SUCCESS;
814   }
815 
816   /**
817    * @notice Returns the error message for a passed failed check reason
818    *
819    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
820    *                 to assign meaning.
821    *
822    * @return The human-readable mesage string
823    */
824   function messageForReason (uint8 _reason) public pure returns (string) {
825     if (_reason == CHECK_ELOCKED) {
826       return ELOCKED_MESSAGE;
827     }
828     
829     if (_reason == CHECK_ESEND) {
830       return ESEND_MESSAGE;
831     }
832 
833     if (_reason == CHECK_ERECV) {
834       return ERECV_MESSAGE;
835     }
836 
837     if (_reason == CHECK_EDIVIS) {
838       return EDIVIS_MESSAGE;
839     }
840 
841     if (_reason == CHECK_EHOLDING_PERIOD) {
842       return EHOLDING_PERIOD_MESSAGE;
843     }
844 
845     if (_reason == CHECK_EDECIMALS) {
846       return EDECIMALS_MESSAGE;
847     }
848 
849     return SUCCESS_MESSAGE;
850   }
851 
852   /**
853    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
854    *
855    * @param  _token The token address of the managed token
856    *
857    * @return The uint256 value that represents a single whole token
858    */
859   function _wholeToken(address _token) view private returns (uint256) {
860     return uint256(10)**DetailedERC20(_token).decimals();
861   }
862 }
863 
864 // File: contracts/RegulatedToken.sol
865 
866 /**
867    Copyright (c) 2017 Harbor Platform, Inc.
868 
869    Licensed under the Apache License, Version 2.0 (the “License”);
870    you may not use this file except in compliance with the License.
871    You may obtain a copy of the License at
872 
873    http://www.apache.org/licenses/LICENSE-2.0
874 
875    Unless required by applicable law or agreed to in writing, software
876    distributed under the License is distributed on an “AS IS” BASIS,
877    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
878    See the License for the specific language governing permissions and
879    limitations under the License.
880 */
881 
882 pragma solidity ^0.4.24;
883 
884 
885 
886 
887 
888 
889 /// @notice An ERC-20 token that has the ability to check for trade validity
890 contract RegulatedToken is DetailedERC20, MintableToken, BurnableToken {
891 
892   /**
893    * @notice R-Token decimals setting (used when constructing DetailedERC20)
894    */
895   uint8 constant public RTOKEN_DECIMALS = 18;
896 
897   /**
898    * @notice Triggered when regulator checks pass or fail
899    */
900   event CheckStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);
901 
902   /**
903    * @notice Address of the `ServiceRegistry` that has the location of the
904    *         `RegulatorService` contract responsible for checking trade
905    *         permissions.
906    */
907   ServiceRegistry public registry;
908 
909   /**
910    * @notice Constructor
911    *
912    * @param _registry Address of `ServiceRegistry` contract
913    * @param _name Name of the token: See DetailedERC20
914    * @param _symbol Symbol of the token: See DetailedERC20
915    */
916   constructor(ServiceRegistry _registry, string _name, string _symbol) public
917     DetailedERC20(_name, _symbol, RTOKEN_DECIMALS)
918   {
919     require(_registry != address(0));
920 
921     registry = _registry;
922   }
923 
924   /**
925    * @notice ERC-20 overridden function that include logic to check for trade validity.
926    *
927    * @param _to The address of the receiver
928    * @param _value The number of tokens to transfer
929    *
930    * @return `true` if successful and `false` if unsuccessful
931    */
932   function transfer(address _to, uint256 _value) public returns (bool) {
933     if (_check(msg.sender, _to, _value)) {
934       return super.transfer(_to, _value);
935     } else {
936       return false;
937     }
938   }
939 
940   /**
941    * @notice ERC-20 overridden function that include logic to check for trade validity.
942    *
943    * @param _from The address of the sender
944    * @param _to The address of the receiver
945    * @param _value The number of tokens to transfer
946    *
947    * @return `true` if successful and `false` if unsuccessful
948    */
949   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
950     if (_check(_from, _to, _value)) {
951       return super.transferFrom(_from, _to, _value);
952     } else {
953       return false;
954     }
955   }
956 
957   /**
958    * @notice Performs the regulator check
959    *
960    * @dev This method raises a CheckStatus event indicating success or failure of the check
961    *
962    * @param _from The address of the sender
963    * @param _to The address of the receiver
964    * @param _value The number of tokens to transfer
965    *
966    * @return `true` if the check was successful and `false` if unsuccessful
967    */
968   function _check(address _from, address _to, uint256 _value) private returns (bool) {
969     require(_from != address(0) && _to != address(0));
970     uint8 reason = _service().check(this, msg.sender, _from, _to, _value);
971 
972     emit CheckStatus(reason, msg.sender, _from, _to, _value);
973 
974     return reason == 0;
975   }
976 
977   /**
978    * @notice Retreives the address of the `RegulatorService` that manages this token.
979    *
980    * @dev This function *MUST NOT* memoize the `RegulatorService` address.  This would
981    *      break the ability to upgrade the `RegulatorService`.
982    *
983    * @return The `RegulatorService` that manages this token.
984    */
985   function _service() view public returns (RegulatorService) {
986     return RegulatorService(registry.service());
987   }
988 }
989 
990 // File: contracts/RegulatedTokenERC1404.sol
991 
992 pragma solidity ^0.4.24;
993 
994 
995 
996 
997 contract RegulatedTokenERC1404 is ERC1404, RegulatedToken {
998     constructor(ServiceRegistry _registry, string _name, string _symbol) public
999         RegulatedToken(_registry, _name, _symbol)
1000     {
1001 
1002     }
1003 
1004    /**
1005     * @notice Implementing detectTransferRestriction makes this token ERC-1404 compatible
1006     * 
1007     * @dev Notice in the call to _service.check(), the 2nd argument is address 0.
1008     *      This "spender" parameter is unused in Harbor's own R-Token implementation
1009     *      and will have to be remain unused for the purposes of our example.
1010     *
1011     * @param from The address of the sender
1012     * @param to The address of the receiver
1013     * @param value The number of tokens to transfer
1014     *
1015     * @return A code that is associated with the reason for a failed check
1016     */
1017     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
1018         return _service().check(this, address(0), from, to, value);
1019     }
1020 
1021    /**
1022     * @notice Implementing messageForTransferRestriction makes this token ERC-1404 compatible
1023     *
1024     * @dev The RegulatorService contract must implement the function messageforReason in this implementation
1025     * 
1026     * @param reason The restrictionCode returned from the service check
1027     *
1028     * @return The human-readable mesage string
1029     */
1030     function messageForTransferRestriction (uint8 reason) public view returns (string) {
1031         return _service().messageForReason(reason);
1032     }
1033 }