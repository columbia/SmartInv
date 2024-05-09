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
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address _owner, address _spender)
23     public view returns (uint256);
24 
25   function transferFrom(address _from, address _to, uint256 _value)
26     public returns (bool);
27 
28   function approve(address _spender, uint256 _value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 
37 contract ERC1404 is ERC20 {
38     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
39     /// @param from Sending address
40     /// @param to Receiving address
41     /// @param value Amount of tokens being transferred
42     /// @return Code by which to reference message for rejection reasoning
43     /// @dev Overwrite with your custom transfer restriction logic
44     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8);
45 
46     /// @notice Returns a human-readable message for a given restriction code
47     /// @param restrictionCode Identifier for looking up a message
48     /// @return Text showing the restriction's reasoning
49     /// @dev Overwrite with your custom message and restrictionCode handling
50     function messageForTransferRestriction (uint8 restrictionCode) public view returns (string);
51 }
52 
53 
54 /**
55    Copyright (c) 2017 Harbor Platform, Inc.
56 
57    Licensed under the Apache License, Version 2.0 (the “License”);
58    you may not use this file except in compliance with the License.
59    You may obtain a copy of the License at
60 
61    http://www.apache.org/licenses/LICENSE-2.0
62 
63    Unless required by applicable law or agreed to in writing, software
64    distributed under the License is distributed on an “AS IS” BASIS,
65    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
66    See the License for the specific language governing permissions and
67    limitations under the License.
68 */
69 
70 pragma solidity ^0.4.24;
71 
72 /// @notice Standard interface for `RegulatorService`s
73 contract RegulatorServiceI {
74 
75   /*
76    * @notice This method *MUST* be called by `RegulatedToken`s during `transfer()` and `transferFrom()`.
77    *         The implementation *SHOULD* check whether or not a transfer can be approved.
78    *
79    * @dev    This method *MAY* call back to the token contract specified by `_token` for
80    *         more information needed to enforce trade approval.
81    *
82    * @param  _token The address of the token to be transfered
83    * @param  _spender The address of the spender of the token
84    * @param  _from The address of the sender account
85    * @param  _to The address of the receiver account
86    * @param  _amount The quantity of the token to trade
87    *
88    * @return uint8 The reason code: 0 means success.  Non-zero values are left to the implementation
89    *               to assign meaning.
90    */
91   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8);
92 }
93 
94 
95 /**
96  * @title Ownable
97  * @dev The Ownable contract has an owner address, and provides basic authorization control
98  * functions, this simplifies the implementation of "user permissions".
99  */
100 contract Ownable {
101   address public owner;
102 
103 
104   event OwnershipRenounced(address indexed previousOwner);
105   event OwnershipTransferred(
106     address indexed previousOwner,
107     address indexed newOwner
108   );
109 
110 
111   /**
112    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
113    * account.
114    */
115   constructor() public {
116     owner = msg.sender;
117   }
118 
119   /**
120    * @dev Throws if called by any account other than the owner.
121    */
122   modifier onlyOwner() {
123     require(msg.sender == owner);
124     _;
125   }
126 
127   /**
128    * @dev Allows the current owner to relinquish control of the contract.
129    * @notice Renouncing to ownership will leave the contract without an owner.
130    * It will not be possible to call the functions with the `onlyOwner`
131    * modifier anymore.
132    */
133   function renounceOwnership() public onlyOwner {
134     emit OwnershipRenounced(owner);
135     owner = address(0);
136   }
137 
138   /**
139    * @dev Allows the current owner to transfer control of the contract to a newOwner.
140    * @param _newOwner The address to transfer ownership to.
141    */
142   function transferOwnership(address _newOwner) public onlyOwner {
143     _transferOwnership(_newOwner);
144   }
145 
146   /**
147    * @dev Transfers control of the contract to a newOwner.
148    * @param _newOwner The address to transfer ownership to.
149    */
150   function _transferOwnership(address _newOwner) internal {
151     require(_newOwner != address(0));
152     emit OwnershipTransferred(owner, _newOwner);
153     owner = _newOwner;
154   }
155 }
156 
157 
158 /**
159  * @title DetailedERC20 token
160  * @dev The decimals are only for visualization purposes.
161  * All the operations are done using the smallest and indivisible token unit,
162  * just as on Ethereum all the operations are done in wei.
163  */
164 contract DetailedERC20 is ERC20 {
165   string public name;
166   string public symbol;
167   uint8 public decimals;
168 
169   constructor(string _name, string _symbol, uint8 _decimals) public {
170     name = _name;
171     symbol = _symbol;
172     decimals = _decimals;
173   }
174 }
175 
176 
177 /**
178  * @title  On-chain RegulatorService implementation for approving trades
179  * @author Originally Bob Remeika, modified by TokenSoft Inc
180  * @dev Orignal source: https://github.com/harborhq/r-token/blob/master/contracts/TokenRegulatorService.sol
181  */
182 contract RegulatorService is RegulatorServiceI, Ownable {
183   /**
184    * @dev Throws if called by any account other than the admin
185    */
186   modifier onlyAdmins() {
187     require(msg.sender == admin || msg.sender == owner);
188     _;
189   }
190 
191   /// @dev Settings that affect token trading at a global level
192   struct Settings {
193 
194     /**
195      * @dev Toggle for locking/unlocking trades at a token level.
196      *      The default behavior of the zero memory state for locking will be unlocked.
197      */
198     bool locked;
199 
200     /**
201      * @dev Toggle for allowing/disallowing fractional token trades at a token level.
202      *      The default state when this contract is created `false` (or no partial
203      *      transfers allowed).
204      */
205     bool partialTransfers;
206   }
207 
208   // @dev Check success code & message
209   uint8 constant private CHECK_SUCCESS = 0;
210   string constant private SUCCESS_MESSAGE = 'Success';
211 
212   // @dev Check error reason: Token is locked
213   uint8 constant private CHECK_ELOCKED = 1;
214   string constant private ELOCKED_MESSAGE = 'Token is locked';
215 
216   // @dev Check error reason: Token can not trade partial amounts
217   uint8 constant private CHECK_EDIVIS = 2;
218   string constant private EDIVIS_MESSAGE = 'Token can not trade partial amounts';
219 
220   // @dev Check error reason: Sender is not allowed to send the token
221   uint8 constant private CHECK_ESEND = 3;
222   string constant private ESEND_MESSAGE = 'Sender is not allowed to send the token';
223 
224   // @dev Check error reason: Receiver is not allowed to receive the token
225   uint8 constant private CHECK_ERECV = 4;
226   string constant private ERECV_MESSAGE = 'Receiver is not allowed to receive the token';
227 
228   /// @dev Permission bits for allowing a participant to send tokens
229   uint8 constant private PERM_SEND = 0x1;
230 
231   /// @dev Permission bits for allowing a participant to receive tokens
232   uint8 constant private PERM_RECEIVE = 0x2;
233 
234   // @dev Address of the administrator
235   address public admin;
236 
237   /// @notice Permissions that allow/disallow token trades on a per token level
238   mapping(address => Settings) private settings;
239 
240   /// @dev Permissions that allow/disallow token trades on a per participant basis.
241   ///      The format for key based access is `participants[tokenAddress][participantAddress]`
242   ///      which returns the permission bits of a participant for a particular token.
243   mapping(address => mapping(address => uint8)) private participants;
244 
245   /// @dev Event raised when a token's locked setting is set
246   event LogLockSet(address indexed token, bool locked);
247 
248   /// @dev Event raised when a token's partial transfer setting is set
249   event LogPartialTransferSet(address indexed token, bool enabled);
250 
251   /// @dev Event raised when a participant permissions are set for a token
252   event LogPermissionSet(address indexed token, address indexed participant, uint8 permission);
253 
254   /// @dev Event raised when the admin address changes
255   event LogTransferAdmin(address indexed oldAdmin, address indexed newAdmin);
256 
257   constructor() public {
258     admin = msg.sender;
259   }
260 
261   /**
262    * @notice Locks the ability to trade a token
263    *
264    * @dev    This method can only be called by this contract's owner
265    *
266    * @param  _token The address of the token to lock
267    */
268   function setLocked(address _token, bool _locked) onlyOwner public {
269     settings[_token].locked = _locked;
270 
271     emit LogLockSet(_token, _locked);
272   }
273 
274   /**
275    * @notice Allows the ability to trade a fraction of a token
276    *
277    * @dev    This method can only be called by this contract's owner
278    *
279    * @param  _token The address of the token to allow partial transfers
280    */
281   function setPartialTransfers(address _token, bool _enabled) onlyOwner public {
282    settings[_token].partialTransfers = _enabled;
283 
284    emit LogPartialTransferSet(_token, _enabled);
285   }
286 
287   /**
288    * @notice Sets the trade permissions for a participant on a token
289    *
290    * @dev    The `_permission` bits overwrite the previous trade permissions and can
291    *         only be called by the contract's owner.  `_permissions` can be bitwise
292    *         `|`'d together to allow for more than one permission bit to be set.
293    *
294    * @param  _token The address of the token
295    * @param  _participant The address of the trade participant
296    * @param  _permission Permission bits to be set
297    */
298   function setPermission(address _token, address _participant, uint8 _permission) onlyAdmins public {
299     participants[_token][_participant] = _permission;
300 
301     emit LogPermissionSet(_token, _participant, _permission);
302   }
303 
304   /**
305    * @dev Allows the owner to transfer admin controls to newAdmin.
306    *
307    * @param newAdmin The address to transfer admin rights to.
308    */
309   function transferAdmin(address newAdmin) onlyOwner public {
310     require(newAdmin != address(0));
311 
312     address oldAdmin = admin;
313     admin = newAdmin;
314 
315     emit LogTransferAdmin(oldAdmin, newAdmin);
316   }
317 
318   /**
319    * @notice Checks whether or not a trade should be approved
320    *
321    * @dev    This method calls back to the token contract specified by `_token` for
322    *         information needed to enforce trade approval if needed
323    *
324    * @param  _token The address of the token to be transfered
325    * @param  _spender The address of the spender of the token (unused in this implementation)
326    * @param  _from The address of the sender account
327    * @param  _to The address of the receiver account
328    * @param  _amount The quantity of the token to trade
329    *
330    * @return `true` if the trade should be approved and `false` if the trade should not be approved
331    */
332   function check(address _token, address _spender, address _from, address _to, uint256 _amount) public returns (uint8) {
333     if (settings[_token].locked) {
334       return CHECK_ELOCKED;
335     }
336 
337     if (participants[_token][_from] & PERM_SEND == 0) {
338       return CHECK_ESEND;
339     }
340 
341     if (participants[_token][_to] & PERM_RECEIVE == 0) {
342       return CHECK_ERECV;
343     }
344 
345     if (!settings[_token].partialTransfers && _amount % _wholeToken(_token) != 0) {
346       return CHECK_EDIVIS;
347     }
348 
349     return CHECK_SUCCESS;
350   }
351 
352   /**
353    * @notice Returns the error message for a passed failed check reason
354    *
355    * @param  _reason The reason code: 0 means success.  Non-zero values are left to the implementation
356    *                 to assign meaning.
357    *
358    * @return The human-readable mesage string
359    */
360   function messageForReason (uint8 _reason) public pure returns (string) {
361     if (_reason == CHECK_ELOCKED) {
362       return ELOCKED_MESSAGE;
363     }
364     
365     if (_reason == CHECK_ESEND) {
366       return ESEND_MESSAGE;
367     }
368 
369     if (_reason == CHECK_ERECV) {
370       return ERECV_MESSAGE;
371     }
372 
373     if (_reason == CHECK_EDIVIS) {
374       return EDIVIS_MESSAGE;
375     }
376 
377     return SUCCESS_MESSAGE;
378   }
379 
380   /**
381    * @notice Retrieves the whole token value from a token that this `RegulatorService` manages
382    *
383    * @param  _token The token address of the managed token
384    *
385    * @return The uint256 value that represents a single whole token
386    */
387   function _wholeToken(address _token) view private returns (uint256) {
388     return uint256(10)**DetailedERC20(_token).decimals();
389   }
390 }
391 
392 
393 /**
394    Copyright (c) 2017 Harbor Platform, Inc.
395 
396    Licensed under the Apache License, Version 2.0 (the “License”);
397    you may not use this file except in compliance with the License.
398    You may obtain a copy of the License at
399 
400    http://www.apache.org/licenses/LICENSE-2.0
401 
402    Unless required by applicable law or agreed to in writing, software
403    distributed under the License is distributed on an “AS IS” BASIS,
404    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
405    See the License for the specific language governing permissions and
406    limitations under the License.
407 */
408 
409 pragma solidity ^0.4.24;
410 
411 
412 
413 /// @notice A service that points to a `RegulatorService`
414 contract ServiceRegistry is Ownable {
415   address public service;
416 
417   /**
418    * @notice Triggered when service address is replaced
419    */
420   event ReplaceService(address oldService, address newService);
421 
422   /**
423    * @dev Validate contract address
424    * Credit: https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol#L107-L114
425    *
426    * @param _addr The address of a smart contract
427    */
428   modifier withContract(address _addr) {
429     uint length;
430     assembly { length := extcodesize(_addr) }
431     require(length > 0);
432     _;
433   }
434 
435   /**
436    * @notice Constructor
437    *
438    * @param _service The address of the `RegulatorService`
439    *
440    */
441   constructor(address _service) public {
442     service = _service;
443   }
444 
445   /**
446    * @notice Replaces the address pointer to the `RegulatorService`
447    *
448    * @dev This method is only callable by the contract's owner
449    *
450    * @param _service The address of the new `RegulatorService`
451    */
452   function replaceService(address _service) onlyOwner withContract(_service) public {
453     address oldService = service;
454     service = _service;
455     emit ReplaceService(oldService, service);
456   }
457 }
458 
459 
460 /**
461  * @title SafeMath
462  * @dev Math operations with safety checks that throw on error
463  */
464 library SafeMath {
465 
466   /**
467   * @dev Multiplies two numbers, throws on overflow.
468   */
469   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
470     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
471     // benefit is lost if 'b' is also tested.
472     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
473     if (_a == 0) {
474       return 0;
475     }
476 
477     c = _a * _b;
478     assert(c / _a == _b);
479     return c;
480   }
481 
482   /**
483   * @dev Integer division of two numbers, truncating the quotient.
484   */
485   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
486     // assert(_b > 0); // Solidity automatically throws when dividing by 0
487     // uint256 c = _a / _b;
488     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
489     return _a / _b;
490   }
491 
492   /**
493   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
494   */
495   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
496     assert(_b <= _a);
497     return _a - _b;
498   }
499 
500   /**
501   * @dev Adds two numbers, throws on overflow.
502   */
503   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
504     c = _a + _b;
505     assert(c >= _a);
506     return c;
507   }
508 }
509 
510 
511 /**
512  * @title Basic token
513  * @dev Basic version of StandardToken, with no allowances.
514  */
515 contract BasicToken is ERC20Basic {
516   using SafeMath for uint256;
517 
518   mapping(address => uint256) internal balances;
519 
520   uint256 internal totalSupply_;
521 
522   /**
523   * @dev Total number of tokens in existence
524   */
525   function totalSupply() public view returns (uint256) {
526     return totalSupply_;
527   }
528 
529   /**
530   * @dev Transfer token for a specified address
531   * @param _to The address to transfer to.
532   * @param _value The amount to be transferred.
533   */
534   function transfer(address _to, uint256 _value) public returns (bool) {
535     require(_value <= balances[msg.sender]);
536     require(_to != address(0));
537 
538     balances[msg.sender] = balances[msg.sender].sub(_value);
539     balances[_to] = balances[_to].add(_value);
540     emit Transfer(msg.sender, _to, _value);
541     return true;
542   }
543 
544   /**
545   * @dev Gets the balance of the specified address.
546   * @param _owner The address to query the the balance of.
547   * @return An uint256 representing the amount owned by the passed address.
548   */
549   function balanceOf(address _owner) public view returns (uint256) {
550     return balances[_owner];
551   }
552 
553 }
554 
555 
556 /**
557  * @title Burnable Token
558  * @dev Token that can be irreversibly burned (destroyed).
559  */
560 contract BurnableToken is BasicToken {
561 
562   event Burn(address indexed burner, uint256 value);
563 
564   /**
565    * @dev Burns a specific amount of tokens.
566    * @param _value The amount of token to be burned.
567    */
568   function burn(uint256 _value) public {
569     _burn(msg.sender, _value);
570   }
571 
572   function _burn(address _who, uint256 _value) internal {
573     require(_value <= balances[_who]);
574     // no need to require value <= totalSupply, since that would imply the
575     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
576 
577     balances[_who] = balances[_who].sub(_value);
578     totalSupply_ = totalSupply_.sub(_value);
579     emit Burn(_who, _value);
580     emit Transfer(_who, address(0), _value);
581   }
582 }
583 
584 
585 /**
586  * @title Standard ERC20 token
587  *
588  * @dev Implementation of the basic standard token.
589  * https://github.com/ethereum/EIPs/issues/20
590  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
591  */
592 contract StandardToken is ERC20, BasicToken {
593 
594   mapping (address => mapping (address => uint256)) internal allowed;
595 
596 
597   /**
598    * @dev Transfer tokens from one address to another
599    * @param _from address The address which you want to send tokens from
600    * @param _to address The address which you want to transfer to
601    * @param _value uint256 the amount of tokens to be transferred
602    */
603   function transferFrom(
604     address _from,
605     address _to,
606     uint256 _value
607   )
608     public
609     returns (bool)
610   {
611     require(_value <= balances[_from]);
612     require(_value <= allowed[_from][msg.sender]);
613     require(_to != address(0));
614 
615     balances[_from] = balances[_from].sub(_value);
616     balances[_to] = balances[_to].add(_value);
617     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
618     emit Transfer(_from, _to, _value);
619     return true;
620   }
621 
622   /**
623    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
624    * Beware that changing an allowance with this method brings the risk that someone may use both the old
625    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
626    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
627    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
628    * @param _spender The address which will spend the funds.
629    * @param _value The amount of tokens to be spent.
630    */
631   function approve(address _spender, uint256 _value) public returns (bool) {
632     allowed[msg.sender][_spender] = _value;
633     emit Approval(msg.sender, _spender, _value);
634     return true;
635   }
636 
637   /**
638    * @dev Function to check the amount of tokens that an owner allowed to a spender.
639    * @param _owner address The address which owns the funds.
640    * @param _spender address The address which will spend the funds.
641    * @return A uint256 specifying the amount of tokens still available for the spender.
642    */
643   function allowance(
644     address _owner,
645     address _spender
646    )
647     public
648     view
649     returns (uint256)
650   {
651     return allowed[_owner][_spender];
652   }
653 
654   /**
655    * @dev Increase the amount of tokens that an owner allowed to a spender.
656    * approve should be called when allowed[_spender] == 0. To increment
657    * allowed value is better to use this function to avoid 2 calls (and wait until
658    * the first transaction is mined)
659    * From MonolithDAO Token.sol
660    * @param _spender The address which will spend the funds.
661    * @param _addedValue The amount of tokens to increase the allowance by.
662    */
663   function increaseApproval(
664     address _spender,
665     uint256 _addedValue
666   )
667     public
668     returns (bool)
669   {
670     allowed[msg.sender][_spender] = (
671       allowed[msg.sender][_spender].add(_addedValue));
672     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
673     return true;
674   }
675 
676   /**
677    * @dev Decrease the amount of tokens that an owner allowed to a spender.
678    * approve should be called when allowed[_spender] == 0. To decrement
679    * allowed value is better to use this function to avoid 2 calls (and wait until
680    * the first transaction is mined)
681    * From MonolithDAO Token.sol
682    * @param _spender The address which will spend the funds.
683    * @param _subtractedValue The amount of tokens to decrease the allowance by.
684    */
685   function decreaseApproval(
686     address _spender,
687     uint256 _subtractedValue
688   )
689     public
690     returns (bool)
691   {
692     uint256 oldValue = allowed[msg.sender][_spender];
693     if (_subtractedValue >= oldValue) {
694       allowed[msg.sender][_spender] = 0;
695     } else {
696       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
697     }
698     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
699     return true;
700   }
701 
702 }
703 
704 
705 /**
706  * @title Mintable token
707  * @dev Simple ERC20 Token example, with mintable token creation
708  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
709  */
710 contract MintableToken is StandardToken, Ownable {
711   event Mint(address indexed to, uint256 amount);
712   event MintFinished();
713 
714   bool public mintingFinished = false;
715 
716 
717   modifier canMint() {
718     require(!mintingFinished);
719     _;
720   }
721 
722   modifier hasMintPermission() {
723     require(msg.sender == owner);
724     _;
725   }
726 
727   /**
728    * @dev Function to mint tokens
729    * @param _to The address that will receive the minted tokens.
730    * @param _amount The amount of tokens to mint.
731    * @return A boolean that indicates if the operation was successful.
732    */
733   function mint(
734     address _to,
735     uint256 _amount
736   )
737     public
738     hasMintPermission
739     canMint
740     returns (bool)
741   {
742     totalSupply_ = totalSupply_.add(_amount);
743     balances[_to] = balances[_to].add(_amount);
744     emit Mint(_to, _amount);
745     emit Transfer(address(0), _to, _amount);
746     return true;
747   }
748 
749   /**
750    * @dev Function to stop minting new tokens.
751    * @return True if the operation was successful.
752    */
753   function finishMinting() public onlyOwner canMint returns (bool) {
754     mintingFinished = true;
755     emit MintFinished();
756     return true;
757   }
758 }
759 
760 
761 /**
762    Copyright (c) 2017 Harbor Platform, Inc.
763 
764    Licensed under the Apache License, Version 2.0 (the “License”);
765    you may not use this file except in compliance with the License.
766    You may obtain a copy of the License at
767 
768    http://www.apache.org/licenses/LICENSE-2.0
769 
770    Unless required by applicable law or agreed to in writing, software
771    distributed under the License is distributed on an “AS IS” BASIS,
772    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
773    See the License for the specific language governing permissions and
774    limitations under the License.
775 */
776 
777 pragma solidity ^0.4.24;
778 
779 
780 
781 
782 
783 
784 
785 /// @notice An ERC-20 token that has the ability to check for trade validity
786 contract RegulatedToken is DetailedERC20, MintableToken, BurnableToken {
787 
788   /**
789    * @notice R-Token decimals setting (used when constructing DetailedERC20)
790    */
791   uint8 constant public RTOKEN_DECIMALS = 18;
792 
793   /**
794    * @notice Triggered when regulator checks pass or fail
795    */
796   event CheckStatus(uint8 reason, address indexed spender, address indexed from, address indexed to, uint256 value);
797 
798   /**
799    * @notice Address of the `ServiceRegistry` that has the location of the
800    *         `RegulatorService` contract responsible for checking trade
801    *         permissions.
802    */
803   ServiceRegistry public registry;
804 
805   /**
806    * @notice Constructor
807    *
808    * @param _registry Address of `ServiceRegistry` contract
809    * @param _name Name of the token: See DetailedERC20
810    * @param _symbol Symbol of the token: See DetailedERC20
811    */
812   constructor(ServiceRegistry _registry, string _name, string _symbol) public
813     DetailedERC20(_name, _symbol, RTOKEN_DECIMALS)
814   {
815     require(_registry != address(0));
816 
817     registry = _registry;
818   }
819 
820   /**
821    * @notice ERC-20 overridden function that include logic to check for trade validity.
822    *
823    * @param _to The address of the receiver
824    * @param _value The number of tokens to transfer
825    *
826    * @return `true` if successful and `false` if unsuccessful
827    */
828   function transfer(address _to, uint256 _value) public returns (bool) {
829     if (_check(msg.sender, _to, _value)) {
830       return super.transfer(_to, _value);
831     } else {
832       return false;
833     }
834   }
835 
836   /**
837    * @notice ERC-20 overridden function that include logic to check for trade validity.
838    *
839    * @param _from The address of the sender
840    * @param _to The address of the receiver
841    * @param _value The number of tokens to transfer
842    *
843    * @return `true` if successful and `false` if unsuccessful
844    */
845   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
846     if (_check(_from, _to, _value)) {
847       return super.transferFrom(_from, _to, _value);
848     } else {
849       return false;
850     }
851   }
852 
853   /**
854    * @notice Performs the regulator check
855    *
856    * @dev This method raises a CheckStatus event indicating success or failure of the check
857    *
858    * @param _from The address of the sender
859    * @param _to The address of the receiver
860    * @param _value The number of tokens to transfer
861    *
862    * @return `true` if the check was successful and `false` if unsuccessful
863    */
864   function _check(address _from, address _to, uint256 _value) private returns (bool) {
865     require(_from != address(0) && _to != address(0));
866     uint8 reason = _service().check(this, msg.sender, _from, _to, _value);
867 
868     emit CheckStatus(reason, msg.sender, _from, _to, _value);
869 
870     return reason == 0;
871   }
872 
873   /**
874    * @notice Retreives the address of the `RegulatorService` that manages this token.
875    *
876    * @dev This function *MUST NOT* memoize the `RegulatorService` address.  This would
877    *      break the ability to upgrade the `RegulatorService`.
878    *
879    * @return The `RegulatorService` that manages this token.
880    */
881   function _service() view public returns (RegulatorService) {
882     return RegulatorService(registry.service());
883   }
884 }
885 
886 
887 contract RegulatedTokenERC1404 is ERC1404, RegulatedToken {
888     constructor(ServiceRegistry _registry, string _name, string _symbol) public
889         RegulatedToken(_registry, _name, _symbol)
890     {
891 
892     }
893 
894    /**
895     * @notice Implementing detectTransferRestriction makes this token ERC-1404 compatible
896     * 
897     * @dev Notice in the call to _service.check(), the 2nd argument is address 0.
898     *      This "spender" parameter is unused in Harbor's own R-Token implementation
899     *      and will have to be remain unused for the purposes of our example.
900     *
901     * @param from The address of the sender
902     * @param to The address of the receiver
903     * @param value The number of tokens to transfer
904     *
905     * @return A code that is associated with the reason for a failed check
906     */
907     function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
908         return _service().check(this, address(0), from, to, value);
909     }
910 
911    /**
912     * @notice Implementing messageForTransferRestriction makes this token ERC-1404 compatible
913     *
914     * @dev The RegulatorService contract must implement the function messageforReason in this implementation
915     * 
916     * @param reason The restrictionCode returned from the service check
917     *
918     * @return The human-readable mesage string
919     */
920     function messageForTransferRestriction (uint8 reason) public view returns (string) {
921         return _service().messageForReason(reason);
922     }
923 }