1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address _who) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 pragma solidity ^0.4.24;
18 
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address _owner, address _spender)
27     public view returns (uint256);
28 
29   function transferFrom(address _from, address _to, uint256 _value)
30     public returns (bool);
31 
32   function approve(address _spender, uint256 _value) public returns (bool);
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 pragma solidity ^0.4.24;
42 
43 
44 contract ERC1404 is ERC20 {
45     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
46     /// @param from Sending address
47     /// @param to Receiving address
48     /// @param value Amount of tokens being transferred
49     /// @return Code by which to reference message for rejection reasoning
50     /// @dev Overwrite with your custom transfer restriction logic
51     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
52 
53     /// @notice Returns a human-readable message for a given restriction code
54     /// @param restrictionCode Identifier for looking up a message
55     /// @return Text showing the restriction's reasoning
56     /// @dev Overwrite with your custom message and restrictionCode handling
57     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
58 }
59 
60 
61 pragma solidity ^0.4.24;
62 
63 
64 
65 /**
66  * @title DetailedERC20 token
67  * @dev The decimals are only for visualization purposes.
68  * All the operations are done using the smallest and indivisible token unit,
69  * just as on Ethereum all the operations are done in wei.
70  */
71 contract DetailedERC20 is ERC20 {
72   string public name;
73   string public symbol;
74   uint8 public decimals;
75 
76   constructor(string _name, string _symbol, uint8 _decimals) public {
77     name = _name;
78     symbol = _symbol;
79     decimals = _decimals;
80   }
81 }
82 
83 
84 pragma solidity ^0.4.24;
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (_a == 0) {
101       return 0;
102     }
103 
104     c = _a * _b;
105     assert(c / _a == _b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     // assert(_b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116     return _a / _b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
123     assert(_b <= _a);
124     return _a - _b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     c = _a + _b;
132     assert(c >= _a);
133     return c;
134   }
135 }
136 
137 
138 pragma solidity ^0.4.24;
139 
140 
141 
142 
143 /**
144  * @title Basic token
145  * @dev Basic version of StandardToken, with no allowances.
146  */
147 contract BasicToken is ERC20Basic {
148   using SafeMath for uint256;
149 
150   mapping(address => uint256) internal balances;
151 
152   uint256 internal totalSupply_;
153 
154   /**
155   * @dev Total number of tokens in existence
156   */
157   function totalSupply() public view returns (uint256) {
158     return totalSupply_;
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint256 _value) public returns (bool) {
167     require(_value <= balances[msg.sender]);
168     require(_to != address(0));
169 
170     balances[msg.sender] = balances[msg.sender].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     emit Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   /**
177   * @dev Gets the balance of the specified address.
178   * @param _owner The address to query the the balance of.
179   * @return An uint256 representing the amount owned by the passed address.
180   */
181   function balanceOf(address _owner) public view returns (uint256) {
182     return balances[_owner];
183   }
184 
185 }
186 
187 
188 pragma solidity ^0.4.24;
189 
190 
191 
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/issues/20
198  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
199  */
200 contract StandardToken is ERC20, BasicToken {
201 
202   mapping (address => mapping (address => uint256)) internal allowed;
203 
204 
205   /**
206    * @dev Transfer tokens from one address to another
207    * @param _from address The address which you want to send tokens from
208    * @param _to address The address which you want to transfer to
209    * @param _value uint256 the amount of tokens to be transferred
210    */
211   function transferFrom(
212     address _from,
213     address _to,
214     uint256 _value
215   )
216     public
217     returns (bool)
218   {
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221     require(_to != address(0));
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     emit Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(
252     address _owner,
253     address _spender
254    )
255     public
256     view
257     returns (uint256)
258   {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseApproval(
272     address _spender,
273     uint256 _addedValue
274   )
275     public
276     returns (bool)
277   {
278     allowed[msg.sender][_spender] = (
279       allowed[msg.sender][_spender].add(_addedValue));
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint256 _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint256 oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue >= oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 
313 pragma solidity ^0.4.24;
314 
315 
316 /**
317  * @title Ownable
318  * @dev The Ownable contract has an owner address, and provides basic authorization control
319  * functions, this simplifies the implementation of "user permissions".
320  */
321 contract Ownable {
322   address public owner;
323 
324 
325   event OwnershipRenounced(address indexed previousOwner);
326   event OwnershipTransferred(
327     address indexed previousOwner,
328     address indexed newOwner
329   );
330 
331 
332   /**
333    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
334    * account.
335    */
336   constructor() public {
337     owner = msg.sender;
338   }
339 
340   /**
341    * @dev Throws if called by any account other than the owner.
342    */
343   modifier onlyOwner() {
344     require(msg.sender == owner);
345     _;
346   }
347 
348   /**
349    * @dev Allows the current owner to relinquish control of the contract.
350    * @notice Renouncing to ownership will leave the contract without an owner.
351    * It will not be possible to call the functions with the `onlyOwner`
352    * modifier anymore.
353    */
354   function renounceOwnership() public onlyOwner {
355     emit OwnershipRenounced(owner);
356     owner = address(0);
357   }
358 
359   /**
360    * @dev Allows the current owner to transfer control of the contract to a newOwner.
361    * @param _newOwner The address to transfer ownership to.
362    */
363   function transferOwnership(address _newOwner) public onlyOwner {
364     _transferOwnership(_newOwner);
365   }
366 
367   /**
368    * @dev Transfers control of the contract to a newOwner.
369    * @param _newOwner The address to transfer ownership to.
370    */
371   function _transferOwnership(address _newOwner) internal {
372     require(_newOwner != address(0));
373     emit OwnershipTransferred(owner, _newOwner);
374     owner = _newOwner;
375   }
376 }
377 
378 
379 pragma solidity ^0.4.24;
380 
381 
382 
383 
384 /**
385  * @title Mintable token
386  * @dev Simple ERC20 Token example, with mintable token creation
387  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
388  */
389 contract MintableToken is StandardToken, Ownable {
390   event Mint(address indexed to, uint256 amount);
391   event MintFinished();
392 
393   bool public mintingFinished = false;
394 
395 
396   modifier canMint() {
397     require(!mintingFinished);
398     _;
399   }
400 
401   modifier hasMintPermission() {
402     require(msg.sender == owner);
403     _;
404   }
405 
406   /**
407    * @dev Function to mint tokens
408    * @param _to The address that will receive the minted tokens.
409    * @param _amount The amount of tokens to mint.
410    * @return A boolean that indicates if the operation was successful.
411    */
412   function mint(
413     address _to,
414     uint256 _amount
415   )
416     public
417     hasMintPermission
418     canMint
419     returns (bool)
420   {
421     totalSupply_ = totalSupply_.add(_amount);
422     balances[_to] = balances[_to].add(_amount);
423     emit Mint(_to, _amount);
424     emit Transfer(address(0), _to, _amount);
425     return true;
426   }
427 
428   /**
429    * @dev Function to stop minting new tokens.
430    * @return True if the operation was successful.
431    */
432   function finishMinting() public onlyOwner canMint returns (bool) {
433     mintingFinished = true;
434     emit MintFinished();
435     return true;
436   }
437 }
438 
439 
440 pragma solidity ^0.4.24;
441 
442 
443 
444 /**
445  * @title Burnable Token
446  * @dev Token that can be irreversibly burned (destroyed).
447  */
448 contract BurnableToken is BasicToken {
449 
450   event Burn(address indexed burner, uint256 value);
451 
452   /**
453    * @dev Burns a specific amount of tokens.
454    * @param _value The amount of token to be burned.
455    */
456   function burn(uint256 _value) public {
457     _burn(msg.sender, _value);
458   }
459 
460   function _burn(address _who, uint256 _value) internal {
461     require(_value <= balances[_who]);
462     // no need to require value <= totalSupply, since that would imply the
463     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
464 
465     balances[_who] = balances[_who].sub(_value);
466     totalSupply_ = totalSupply_.sub(_value);
467     emit Burn(_who, _value);
468     emit Transfer(_who, address(0), _value);
469   }
470 }
471 
472 
473 /**
474    Copyright (c) 2017 Harbor Platform, Inc.
475 
476    Licensed under the Apache License, Version 2.0 (the “License”);
477    you may not use this file except in compliance with the License.
478    You may obtain a copy of the License at
479 
480    http://www.apache.org/licenses/LICENSE-2.0
481 
482    Unless required by applicable law or agreed to in writing, software
483    distributed under the License is distributed on an “AS IS” BASIS,
484    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
485    See the License for the specific language governing permissions and
486    limitations under the License.
487 */
488 
489 pragma solidity ^0.4.24;
490 
491 
492 /// @notice A service that points to a `RegulatorService`
493 contract ServiceRegistry is Ownable {
494   address public service;
495 
496   /**
497    * @notice Triggered when service address is replaced
498    */
499   event ReplaceService(address oldService, address newService);
500 
501   /**
502    * @dev Validate contract address
503    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
504    *
505    * @param _addr The address of a smart contract
506    */
507   modifier withContract(address _addr) {
508     uint length;
509     assembly { length := extcodesize(_addr) }
510     require(length > 0);
511     _;
512   }
513 
514   /**
515    * @notice Constructor
516    *
517    * @param _service The address of the `RegulatorService`
518    *
519    */
520   constructor(address _service) public {
521     service = _service;
522   }
523 
524   /**
525    * @notice Replaces the address pointer to the `RegulatorService`
526    *
527    * @dev This method is only callable by the contract's owner
528    *
529    * @param _service The address of the new `RegulatorService`
530    */
531   function replaceService(address _service) onlyOwner withContract(_service) public {
532     address oldService = service;
533     service = _service;
534     emit ReplaceService(oldService, service);
535   }
536 }
537 
538 
539 /**
540    Copyright (c) 2017 Harbor Platform, Inc.
541 
542    Licensed under the Apache License, Version 2.0 (the “License”);
543    you may not use this file except in compliance with the License.
544    You may obtain a copy of the License at
545 
546    http://www.apache.org/licenses/LICENSE-2.0
547 
548    Unless required by applicable law or agreed to in writing, software
549    distributed under the License is distributed on an “AS IS” BASIS,
550    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
551    See the License for the specific language governing permissions and
552    limitations under the License.
553 */
554 
555 pragma solidity ^0.4.24;
556 
557 /// @notice Standard interface for `RegulatorService`s
558 contract RegulatorServiceI {
559 
560   /*
561    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
562    *         The implementation *SHOULD* check whether or not a transfer can be approved.
563    *
564    * @dev    This method *MAY* call back to the token contract specified by `_token` for
565    *         more information needed to enforce trade approval.
566    *
567    * @param  _token The address of the token to be transfered
568    * @param  _spender The address of the spender of the token
569    * @param  _from The address of the sender account
570    * @param  _to The address of the receiver account
571    * @param  _amount The quantity of the token to trade
572    *
573    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
574    *               to assign meaning.
575    */
576   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
577 }
578 
579 
580 pragma solidity ^0.4.18;
581 
582 
583 
584 
585 /**
586  * @title  On-chain RegulatorService implementation for approving trades
587  * @author Originally Bob Remeika, modified by TokenSoft Inc
588  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
589  */
590 contract RegulatorService is RegulatorServiceI, Ownable {
591   /**
592    * @dev Throws if called by any account other than the admin
593    */
594   modifier onlyAdmins() {
595     require(msg.sender == admin || msg.sender == owner);
596     _;
597   }
598 
599   /// @dev Settings that affect token trading at a global level
600   struct Settings {
601 
602     /**
603      * @dev Toggle for locking/unlocking trades at a token level.
604      *      The default behavior of the zero memory state for locking will be unlocked.
605      */
606     bool locked;
607 
608     /**
609      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
610      *      The default state when this contract is created `false` (or no partial
611      *      transfers allowed).
612      */
613     bool partialTransfers;
614 
615     /**
616      * @dev Mappning for 12 months hold up period for investors.
617      * @param  address investors wallet
618      * @param  uint256 holdingPeriod start date in unix
619      */
620     mapping(address => uint256) holdingPeriod;
621   }
622 
623   // @dev number of seconds in a year = 365 * 24 * 60 * 60
624   uint256 constant private YEAR = 1 years;
625 
626   // @dev Check success code & message
627   uint8 constant private CHECK_SUCCESS = 0;
628   string constant private SUCCESS_MESSAGE = 'Success';
629 
630   // @dev Check error reason: Token is locked
631   uint8 constant private CHECK_ELOCKED = 1;
632   string constant private ELOCKED_MESSAGE = 'Token is locked';
633 
634   // @dev Check error reason: Token can not trade partial amounts
635   uint8 constant private CHECK_EDIVIS = 2;
636   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
637 
638   // @dev Check error reason: Sender is not allowed to send the token
639   uint8 constant private CHECK_ESEND = 3;
640   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
641 
642   // @dev Check error reason: Receiver is not allowed to receive the token
643   uint8 constant private CHECK_ERECV = 4;
644   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
645 
646   uint8 constant private CHECK_EHOLDING_PERIOD = 5;
647   string constant private EHOLDING_PERIOD_MESSAGE = 'Sender is still in 12 months holding period';
648 
649   uint8 constant private CHECK_EDECIMALS = 6;
650   string constant private EDECIMALS_MESSAGE = 'Transfer value must be bigger than 0.000001 or 1 szabo';
651 
652   uint256 constant public MINIMAL_TRANSFER = 1 szabo;
653 
654   /// @dev Permission bits for allowing a participant to send tokens
655   uint8 constant private PERM_SEND = 0x1;
656 
657   /// @dev Permission bits for allowing a participant to receive tokens
658   uint8 constant private PERM_RECEIVE = 0x2;
659 
660   // @dev Address of the administrator
661   address public admin;
662 
663   /// @notice Permissions that allow/disallow token trades on a per token level
664   mapping(address => Settings) private settings;
665 
666   /// @dev Permissions that allow/disallow token trades on a per participant basis.
667   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
668   ///      which returns the permission bits of a participant for a particular token.
669   mapping(address => mapping(address => uint8)) private participants;
670 
671   /// @dev Event raised when a token's locked setting is set
672   event LogLockSet(address indexed token, bool locked);
673 
674   /// @dev Event raised when a token's partial transfer setting is set
675   event LogPartialTransferSet(address indexed token, bool enabled);
676 
677   /// @dev Event raised when a participant permissions are set for a token
678   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
679 
680   /// @dev Event raised when the admin address changes
681   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
682 
683   /// @dev Event raised when holding period start date is set for participant
684   event LogHoldingPeriod(
685     address indexed _token, address indexed _participant, uint256 _startDate);
686 
687   constructor() public {
688     admin = msg.sender;
689   }
690 
691   /**
692    * @notice Locks the ability to trade a token
693    *
694    * @dev    This method can only be called by this contract's owner
695    *
696    * @param  _token The address of the token to lock
697    */
698   function setLocked(address _token, bool _locked) onlyOwner public {
699     settings[_token].locked = _locked;
700 
701     emit LogLockSet(_token, _locked);
702   }
703 
704   /**
705    * @notice Allows the ability to trade a fraction of a token
706    *
707    * @dev    This method can only be called by this contract's owner
708    *
709    * @param  _token The address of the token to allow partial transfers
710    */
711   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
712    settings[_token].partialTransfers = _enabled;
713 
714    emit LogPartialTransferSet(_token, _enabled);
715   }
716 
717   /**
718    * @notice Sets the trade permissions for a participant on a token
719    *
720    * @dev    The `_permission` bits overwrite the previous trade permissions and can
721    *         only be called by the contract's owner.  `_permissions` can be bitwise
722    *         `|`'d together to allow for more than one permission bit to be set.
723    *
724    * @param  _token The address of the token
725    * @param  _participant The address of the trade participant
726    * @param  _permission Permission bits to be set
727    */
728   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
729     participants[_token][_participant] = _permission;
730 
731     emit LogPermissionSet(_token, _participant, _permission);
732   }
733 
734   /**
735    * @notice Set initial holding period for investor
736    * @param _token       token address
737    * @param _participant participant address
738    * @param _startDate   start date of holding period in UNIX format
739    */
740   function setHoldingPeriod(address _token, address _participant, uint256 _startDate) onlyAdmins public {
741     settings[_token].holdingPeriod[_participant] = _startDate;
742 
743     emit LogHoldingPeriod(_token, _participant, _startDate);
744   }
745 
746   /**
747    * @dev Allows the owner to transfer admin controls to newAdmin.
748    *
749    * @param newAdmin The address to transfer admin rights to.
750    */
751   function transferAdmin(address newAdmin) onlyOwner public {
752     require(newAdmin != address(0));
753 
754     address oldAdmin = admin;
755     admin = newAdmin;
756 
757     emit LogTransferAdmin(oldAdmin, newAdmin);
758   }
759 
760   /**
761    * @notice Checks whether or not a trade should be approved
762    *
763    * @dev    This method calls back to the token contract specified by `_token` for
764    *         information needed to enforce trade approval if needed
765    *
766    * @param  _token The address of the token to be transfered
767    * @param  _spender The address of the spender of the token (unused in this implementation)
768    * @param  _from The address of the sender account
769    * @param  _to The address of the receiver account
770    * @param  _amount The quantity of the token to trade
771    *
772    * @return `true` if the trade should be approved and `false` if the trade should not be approved
773    */
774   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
775     if (settings[_token].locked) {
776       return CHECK_ELOCKED;
777     }
778 
779     if (participants[_token][_from] & PERM_SEND == 0) {
780       return CHECK_ESEND;
781     }
782 
783     if (participants[_token][_to] & PERM_RECEIVE == 0) {
784       return CHECK_ERECV;
785     }
786 
787     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
788       return CHECK_EDIVIS;
789     }
790 
791     if (settings[_token].holdingPeriod[_from] + YEAR >= now) {
792       return CHECK_EHOLDING_PERIOD;
793     }
794 
795     if (_amount < MINIMAL_TRANSFER) {
796       return CHECK_EDECIMALS;
797     }
798 
799     return CHECK_SUCCESS;
800   }
801 
802   /**
803    * @notice Returns the error message for a passed failed check reason
804    *
805    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
806    *                 to assign meaning.
807    *
808    * @return The human-readable mesage string
809    */
810   function messageForReason (uint8 _reason) public pure returns (string) {
811     if (_reason == CHECK_ELOCKED) {
812       return ELOCKED_MESSAGE;
813     }
814     
815     if (_reason == CHECK_ESEND) {
816       return ESEND_MESSAGE;
817     }
818 
819     if (_reason == CHECK_ERECV) {
820       return ERECV_MESSAGE;
821     }
822 
823     if (_reason == CHECK_EDIVIS) {
824       return EDIVIS_MESSAGE;
825     }
826 
827     if (_reason == CHECK_EHOLDING_PERIOD) {
828       return EHOLDING_PERIOD_MESSAGE;
829     }
830 
831     if (_reason == CHECK_EDECIMALS) {
832       return EDECIMALS_MESSAGE;
833     }
834 
835     return SUCCESS_MESSAGE;
836   }
837 
838   /**
839    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
840    *
841    * @param  _token The token address of the managed token
842    *
843    * @return The uint256 value that represents a single whole token
844    */
845   function _wholeToken(address _token) view private returns (uint256) {
846     return uint256(10)**DetailedERC20(_token).decimals();
847   }
848 }
849 
850 
851 /**
852    Copyright (c) 2017 Harbor Platform, Inc.
853 
854    Licensed under the Apache License, Version 2.0 (the “License”);
855    you may not use this file except in compliance with the License.
856    You may obtain a copy of the License at
857 
858    http://www.apache.org/licenses/LICENSE-2.0
859 
860    Unless required by applicable law or agreed to in writing, software
861    distributed under the License is distributed on an “AS IS” BASIS,
862    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
863    See the License for the specific language governing permissions and
864    limitations under the License.
865 */
866 
867 pragma solidity ^0.4.24;
868 
869 
870 
871 
872 
873 
874 /// @notice An ERC-20 token that has the ability to check for trade validity
875 contract RegulatedToken is DetailedERC20, MintableToken, BurnableToken {
876 
877   /**
878    * @notice R-Token decimals setting (used when constructing DetailedERC20)
879    */
880   uint8 constant public RTOKEN_DECIMALS = 18;
881 
882   /**
883    * @notice Triggered when regulator checks pass or fail
884    */
885   event CheckStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);
886 
887   /**
888    * @notice Address of the `ServiceRegistry` that has the location of the
889    *         `RegulatorService` contract responsible for checking trade
890    *         permissions.
891    */
892   ServiceRegistry public registry;
893 
894   /**
895    * @notice Constructor
896    *
897    * @param _registry Address of `ServiceRegistry` contract
898    * @param _name Name of the token: See DetailedERC20
899    * @param _symbol Symbol of the token: See DetailedERC20
900    */
901   constructor(ServiceRegistry _registry, string _name, string _symbol) public
902     DetailedERC20(_name, _symbol, RTOKEN_DECIMALS)
903   {
904     require(_registry != address(0));
905 
906     registry = _registry;
907   }
908 
909   /**
910    * @notice ERC-20 overridden function that include logic to check for trade validity.
911    *
912    * @param _to The address of the receiver
913    * @param _value The number of tokens to transfer
914    *
915    * @return `true` if successful and `false` if unsuccessful
916    */
917   function transfer(address _to, uint256 _value) public returns (bool) {
918     if (_check(msg.sender, _to, _value)) {
919       return super.transfer(_to, _value);
920     } else {
921       return false;
922     }
923   }
924 
925   /**
926    * @notice ERC-20 overridden function that include logic to check for trade validity.
927    *
928    * @param _from The address of the sender
929    * @param _to The address of the receiver
930    * @param _value The number of tokens to transfer
931    *
932    * @return `true` if successful and `false` if unsuccessful
933    */
934   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
935     if (_check(_from, _to, _value)) {
936       return super.transferFrom(_from, _to, _value);
937     } else {
938       return false;
939     }
940   }
941 
942   /**
943    * @notice Performs the regulator check
944    *
945    * @dev This method raises a CheckStatus event indicating success or failure of the check
946    *
947    * @param _from The address of the sender
948    * @param _to The address of the receiver
949    * @param _value The number of tokens to transfer
950    *
951    * @return `true` if the check was successful and `false` if unsuccessful
952    */
953   function _check(address _from, address _to, uint256 _value) private returns (bool) {
954     require(_from != address(0) && _to != address(0));
955     uint8 reason = _service().check(this, msg.sender, _from, _to, _value);
956 
957     emit CheckStatus(reason, msg.sender, _from, _to, _value);
958 
959     return reason == 0;
960   }
961 
962   /**
963    * @notice Retreives the address of the `RegulatorService` that manages this token.
964    *
965    * @dev This function *MUST NOT* memoize the `RegulatorService` address.  This would
966    *      break the ability to upgrade the `RegulatorService`.
967    *
968    * @return The `RegulatorService` that manages this token.
969    */
970   function _service() view public returns (RegulatorService) {
971     return RegulatorService(registry.service());
972   }
973 }
974 
975 
976 pragma solidity ^0.4.24;
977 
978 
979 
980 
981 contract RegulatedTokenERC1404 is ERC1404, RegulatedToken {
982     constructor(ServiceRegistry _registry, string _name, string _symbol) public
983         RegulatedToken(_registry, _name, _symbol)
984     {
985 
986     }
987 
988    /**
989     * @notice Implementing detectTransferRestriction makes this token ERC-1404 compatible
990     * 
991     * @dev Notice in the call to _service.check(), the 2nd argument is address 0.
992     *      This "spender" parameter is unused in Harbor's own R-Token implementation
993     *      and will have to be remain unused for the purposes of our example.
994     *
995     * @param from The address of the sender
996     * @param to The address of the receiver
997     * @param value The number of tokens to transfer
998     *
999     * @return A code that is associated with the reason for a failed check
1000     */
1001     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
1002         return _service().check(this, address(0), from, to, value);
1003     }
1004 
1005    /**
1006     * @notice Implementing messageForTransferRestriction makes this token ERC-1404 compatible
1007     *
1008     * @dev The RegulatorService contract must implement the function messageforReason in this implementation
1009     * 
1010     * @param reason The restrictionCode returned from the service check
1011     *
1012     * @return The human-readable mesage string
1013     */
1014     function messageForTransferRestriction (uint8 reason) public view returns (string) {
1015         return _service().messageForReason(reason);
1016     }
1017 }