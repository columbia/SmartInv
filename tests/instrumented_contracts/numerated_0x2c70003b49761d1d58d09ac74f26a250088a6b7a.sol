1 pragma solidity ^0.4.24;
2 
3 // openzeppelin-solidity: 1.12.0-rc.2
4 
5 /**
6  * @title Roles
7  * @author Francisco Giordano (@frangio)
8  * @dev Library for managing addresses assigned to a Role.
9  * See RBAC.sol for example usage.
10  */
11 library Roles {
12   struct Role {
13     mapping (address => bool) bearer;
14   }
15 
16   /**
17    * @dev give an address access to this role
18    */
19   function add(Role storage _role, address _addr)
20     internal
21   {
22     _role.bearer[_addr] = true;
23   }
24 
25   /**
26    * @dev remove an address' access to this role
27    */
28   function remove(Role storage _role, address _addr)
29     internal
30   {
31     _role.bearer[_addr] = false;
32   }
33 
34   /**
35    * @dev check if an address has this role
36    * // reverts
37    */
38   function check(Role storage _role, address _addr)
39     internal
40     view
41   {
42     require(has(_role, _addr));
43   }
44 
45   /**
46    * @dev check if an address has this role
47    * @return bool
48    */
49   function has(Role storage _role, address _addr)
50     internal
51     view
52     returns (bool)
53   {
54     return _role.bearer[_addr];
55   }
56 }
57 
58 /**
59  * @title RBAC (Role-Based Access Control)
60  * @author Matt Condon (@Shrugs)
61  * @dev Stores and provides setters and getters for roles and addresses.
62  * Supports unlimited numbers of roles and addresses.
63  * See //contracts/mocks/RBACMock.sol for an example of usage.
64  * This RBAC method uses strings to key roles. It may be beneficial
65  * for you to write your own implementation of this interface using Enums or similar.
66  */
67 contract RBAC {
68   using Roles for Roles.Role;
69 
70   mapping (string => Roles.Role) private roles;
71 
72   event RoleAdded(address indexed operator, string role);
73   event RoleRemoved(address indexed operator, string role);
74 
75   /**
76    * @dev reverts if addr does not have role
77    * @param _operator address
78    * @param _role the name of the role
79    * // reverts
80    */
81   function checkRole(address _operator, string _role)
82     public
83     view
84   {
85     roles[_role].check(_operator);
86   }
87 
88   /**
89    * @dev determine if addr has role
90    * @param _operator address
91    * @param _role the name of the role
92    * @return bool
93    */
94   function hasRole(address _operator, string _role)
95     public
96     view
97     returns (bool)
98   {
99     return roles[_role].has(_operator);
100   }
101 
102   /**
103    * @dev add a role to an address
104    * @param _operator address
105    * @param _role the name of the role
106    */
107   function addRole(address _operator, string _role)
108     internal
109   {
110     roles[_role].add(_operator);
111     emit RoleAdded(_operator, _role);
112   }
113 
114   /**
115    * @dev remove a role from an address
116    * @param _operator address
117    * @param _role the name of the role
118    */
119   function removeRole(address _operator, string _role)
120     internal
121   {
122     roles[_role].remove(_operator);
123     emit RoleRemoved(_operator, _role);
124   }
125 
126   /**
127    * @dev modifier to scope access to a single role (uses msg.sender as addr)
128    * @param _role the name of the role
129    * // reverts
130    */
131   modifier onlyRole(string _role)
132   {
133     checkRole(msg.sender, _role);
134     _;
135   }
136 
137   /**
138    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
139    * @param _roles the names of the roles to scope access to
140    * // reverts
141    *
142    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
143    *  see: https://github.com/ethereum/solidity/issues/2467
144    */
145   // modifier onlyRoles(string[] _roles) {
146   //     bool hasAnyRole = false;
147   //     for (uint8 i = 0; i < _roles.length; i++) {
148   //         if (hasRole(msg.sender, _roles[i])) {
149   //             hasAnyRole = true;
150   //             break;
151   //         }
152   //     }
153 
154   //     require(hasAnyRole);
155 
156   //     _;
157   // }
158 }
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166   address public owner;
167 
168 
169   event OwnershipRenounced(address indexed previousOwner);
170   event OwnershipTransferred(
171     address indexed previousOwner,
172     address indexed newOwner
173   );
174 
175 
176   /**
177    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
178    * account.
179    */
180   constructor() public {
181     owner = msg.sender;
182   }
183 
184   /**
185    * @dev Throws if called by any account other than the owner.
186    */
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191 
192   /**
193    * @dev Allows the current owner to relinquish control of the contract.
194    * @notice Renouncing to ownership will leave the contract without an owner.
195    * It will not be possible to call the functions with the `onlyOwner`
196    * modifier anymore.
197    */
198   function renounceOwnership() public onlyOwner {
199     emit OwnershipRenounced(owner);
200     owner = address(0);
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param _newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address _newOwner) public onlyOwner {
208     _transferOwnership(_newOwner);
209   }
210 
211   /**
212    * @dev Transfers control of the contract to a newOwner.
213    * @param _newOwner The address to transfer ownership to.
214    */
215   function _transferOwnership(address _newOwner) internal {
216     require(_newOwner != address(0));
217     emit OwnershipTransferred(owner, _newOwner);
218     owner = _newOwner;
219   }
220 }
221 
222 /**
223  * @title Pausable
224  * @dev Base contract which allows children to implement an emergency stop mechanism.
225  */
226 contract Pausable is Ownable {
227   event Pause();
228   event Unpause();
229 
230   bool public paused = false;
231 
232 
233   /**
234    * @dev Modifier to make a function callable only when the contract is not paused.
235    */
236   modifier whenNotPaused() {
237     require(!paused);
238     _;
239   }
240 
241   /**
242    * @dev Modifier to make a function callable only when the contract is paused.
243    */
244   modifier whenPaused() {
245     require(paused);
246     _;
247   }
248 
249   /**
250    * @dev called by the owner to pause, triggers stopped state
251    */
252   function pause() public onlyOwner whenNotPaused {
253     paused = true;
254     emit Pause();
255   }
256 
257   /**
258    * @dev called by the owner to unpause, returns to normal state
259    */
260   function unpause() public onlyOwner whenPaused {
261     paused = false;
262     emit Unpause();
263   }
264 }
265 
266 /**
267  * @title Whitelist
268  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
269  * This simplifies the implementation of "user permissions".
270  */
271 contract Whitelist is Ownable, RBAC {
272   string public constant ROLE_WHITELISTED = "whitelist";
273 
274   /**
275    * @dev Throws if operator is not whitelisted.
276    * @param _operator address
277    */
278   modifier onlyIfWhitelisted(address _operator) {
279     checkRole(_operator, ROLE_WHITELISTED);
280     _;
281   }
282 
283   /**
284    * @dev add an address to the whitelist
285    * @param _operator address
286    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
287    */
288   function addAddressToWhitelist(address _operator)
289     public
290     onlyOwner
291   {
292     addRole(_operator, ROLE_WHITELISTED);
293   }
294 
295   /**
296    * @dev getter to determine if address is in whitelist
297    */
298   function whitelist(address _operator)
299     public
300     view
301     returns (bool)
302   {
303     return hasRole(_operator, ROLE_WHITELISTED);
304   }
305 
306   /**
307    * @dev add addresses to the whitelist
308    * @param _operators addresses
309    * @return true if at least one address was added to the whitelist,
310    * false if all addresses were already in the whitelist
311    */
312   function addAddressesToWhitelist(address[] _operators)
313     public
314     onlyOwner
315   {
316     for (uint256 i = 0; i < _operators.length; i++) {
317       addAddressToWhitelist(_operators[i]);
318     }
319   }
320 
321   /**
322    * @dev remove an address from the whitelist
323    * @param _operator address
324    * @return true if the address was removed from the whitelist,
325    * false if the address wasn't in the whitelist in the first place
326    */
327   function removeAddressFromWhitelist(address _operator)
328     public
329     onlyOwner
330   {
331     removeRole(_operator, ROLE_WHITELISTED);
332   }
333 
334   /**
335    * @dev remove addresses from the whitelist
336    * @param _operators addresses
337    * @return true if at least one address was removed from the whitelist,
338    * false if all addresses weren't in the whitelist in the first place
339    */
340   function removeAddressesFromWhitelist(address[] _operators)
341     public
342     onlyOwner
343   {
344     for (uint256 i = 0; i < _operators.length; i++) {
345       removeAddressFromWhitelist(_operators[i]);
346     }
347   }
348 
349 }
350 
351 /**
352  * @title ERC20Basic
353  * @dev Simpler version of ERC20 interface
354  * See https://github.com/ethereum/EIPs/issues/179
355  */
356 contract ERC20Basic {
357   function totalSupply() public view returns (uint256);
358   function balanceOf(address _who) public view returns (uint256);
359   function transfer(address _to, uint256 _value) public returns (bool);
360   event Transfer(address indexed from, address indexed to, uint256 value);
361 }
362 
363 /**
364  * @title ERC20 interface
365  * @dev see https://github.com/ethereum/EIPs/issues/20
366  */
367 contract ERC20 is ERC20Basic {
368   function allowance(address _owner, address _spender)
369     public view returns (uint256);
370 
371   function transferFrom(address _from, address _to, uint256 _value)
372     public returns (bool);
373 
374   function approve(address _spender, uint256 _value) public returns (bool);
375   event Approval(
376     address indexed owner,
377     address indexed spender,
378     uint256 value
379   );
380 }
381 
382 /**
383  * @title SafeERC20
384  * @dev Wrappers around ERC20 operations that throw on failure.
385  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389   function safeTransfer(
390     ERC20Basic _token,
391     address _to,
392     uint256 _value
393   )
394     internal
395   {
396     require(_token.transfer(_to, _value));
397   }
398 
399   function safeTransferFrom(
400     ERC20 _token,
401     address _from,
402     address _to,
403     uint256 _value
404   )
405     internal
406   {
407     require(_token.transferFrom(_from, _to, _value));
408   }
409 
410   function safeApprove(
411     ERC20 _token,
412     address _spender,
413     uint256 _value
414   )
415     internal
416   {
417     require(_token.approve(_spender, _value));
418   }
419 }
420 
421 /**
422  * @title SafeMath
423  * @dev Math operations with safety checks that throw on error
424  */
425 library SafeMath {
426 
427   /**
428   * @dev Multiplies two numbers, throws on overflow.
429   */
430   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
431     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
432     // benefit is lost if 'b' is also tested.
433     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
434     if (_a == 0) {
435       return 0;
436     }
437 
438     c = _a * _b;
439     assert(c / _a == _b);
440     return c;
441   }
442 
443   /**
444   * @dev Integer division of two numbers, truncating the quotient.
445   */
446   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
447     // assert(_b > 0); // Solidity automatically throws when dividing by 0
448     // uint256 c = _a / _b;
449     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
450     return _a / _b;
451   }
452 
453   /**
454   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
455   */
456   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
457     assert(_b <= _a);
458     return _a - _b;
459   }
460 
461   /**
462   * @dev Adds two numbers, throws on overflow.
463   */
464   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
465     c = _a + _b;
466     assert(c >= _a);
467     return c;
468   }
469 }
470 
471 /**
472  * @title Basic token
473  * @dev Basic version of StandardToken, with no allowances.
474  */
475 contract BasicToken is ERC20Basic {
476   using SafeMath for uint256;
477 
478   mapping(address => uint256) internal balances;
479 
480   uint256 internal totalSupply_;
481 
482   /**
483   * @dev Total number of tokens in existence
484   */
485   function totalSupply() public view returns (uint256) {
486     return totalSupply_;
487   }
488 
489   /**
490   * @dev Transfer token for a specified address
491   * @param _to The address to transfer to.
492   * @param _value The amount to be transferred.
493   */
494   function transfer(address _to, uint256 _value) public returns (bool) {
495     require(_value <= balances[msg.sender]);
496     require(_to != address(0));
497 
498     balances[msg.sender] = balances[msg.sender].sub(_value);
499     balances[_to] = balances[_to].add(_value);
500     emit Transfer(msg.sender, _to, _value);
501     return true;
502   }
503 
504   /**
505   * @dev Gets the balance of the specified address.
506   * @param _owner The address to query the the balance of.
507   * @return An uint256 representing the amount owned by the passed address.
508   */
509   function balanceOf(address _owner) public view returns (uint256) {
510     return balances[_owner];
511   }
512 
513 }
514 
515 /**
516  * @title Standard ERC20 token
517  *
518  * @dev Implementation of the basic standard token.
519  * https://github.com/ethereum/EIPs/issues/20
520  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
521  */
522 contract StandardToken is ERC20, BasicToken {
523 
524   mapping (address => mapping (address => uint256)) internal allowed;
525 
526 
527   /**
528    * @dev Transfer tokens from one address to another
529    * @param _from address The address which you want to send tokens from
530    * @param _to address The address which you want to transfer to
531    * @param _value uint256 the amount of tokens to be transferred
532    */
533   function transferFrom(
534     address _from,
535     address _to,
536     uint256 _value
537   )
538     public
539     returns (bool)
540   {
541     require(_value <= balances[_from]);
542     require(_value <= allowed[_from][msg.sender]);
543     require(_to != address(0));
544 
545     balances[_from] = balances[_from].sub(_value);
546     balances[_to] = balances[_to].add(_value);
547     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
548     emit Transfer(_from, _to, _value);
549     return true;
550   }
551 
552   /**
553    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
554    * Beware that changing an allowance with this method brings the risk that someone may use both the old
555    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
556    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
557    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
558    * @param _spender The address which will spend the funds.
559    * @param _value The amount of tokens to be spent.
560    */
561   function approve(address _spender, uint256 _value) public returns (bool) {
562     allowed[msg.sender][_spender] = _value;
563     emit Approval(msg.sender, _spender, _value);
564     return true;
565   }
566 
567   /**
568    * @dev Function to check the amount of tokens that an owner allowed to a spender.
569    * @param _owner address The address which owns the funds.
570    * @param _spender address The address which will spend the funds.
571    * @return A uint256 specifying the amount of tokens still available for the spender.
572    */
573   function allowance(
574     address _owner,
575     address _spender
576    )
577     public
578     view
579     returns (uint256)
580   {
581     return allowed[_owner][_spender];
582   }
583 
584   /**
585    * @dev Increase the amount of tokens that an owner allowed to a spender.
586    * approve should be called when allowed[_spender] == 0. To increment
587    * allowed value is better to use this function to avoid 2 calls (and wait until
588    * the first transaction is mined)
589    * From MonolithDAO Token.sol
590    * @param _spender The address which will spend the funds.
591    * @param _addedValue The amount of tokens to increase the allowance by.
592    */
593   function increaseApproval(
594     address _spender,
595     uint256 _addedValue
596   )
597     public
598     returns (bool)
599   {
600     allowed[msg.sender][_spender] = (
601       allowed[msg.sender][_spender].add(_addedValue));
602     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
603     return true;
604   }
605 
606   /**
607    * @dev Decrease the amount of tokens that an owner allowed to a spender.
608    * approve should be called when allowed[_spender] == 0. To decrement
609    * allowed value is better to use this function to avoid 2 calls (and wait until
610    * the first transaction is mined)
611    * From MonolithDAO Token.sol
612    * @param _spender The address which will spend the funds.
613    * @param _subtractedValue The amount of tokens to decrease the allowance by.
614    */
615   function decreaseApproval(
616     address _spender,
617     uint256 _subtractedValue
618   )
619     public
620     returns (bool)
621   {
622     uint256 oldValue = allowed[msg.sender][_spender];
623     if (_subtractedValue >= oldValue) {
624       allowed[msg.sender][_spender] = 0;
625     } else {
626       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
627     }
628     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632 }
633 
634 /**
635  * @title Pausable token
636  * @dev StandardToken modified with pausable transfers.
637  **/
638 contract PausableToken is StandardToken, Pausable {
639 
640   function transfer(
641     address _to,
642     uint256 _value
643   )
644     public
645     whenNotPaused
646     returns (bool)
647   {
648     return super.transfer(_to, _value);
649   }
650 
651   function transferFrom(
652     address _from,
653     address _to,
654     uint256 _value
655   )
656     public
657     whenNotPaused
658     returns (bool)
659   {
660     return super.transferFrom(_from, _to, _value);
661   }
662 
663   function approve(
664     address _spender,
665     uint256 _value
666   )
667     public
668     whenNotPaused
669     returns (bool)
670   {
671     return super.approve(_spender, _value);
672   }
673 
674   function increaseApproval(
675     address _spender,
676     uint _addedValue
677   )
678     public
679     whenNotPaused
680     returns (bool success)
681   {
682     return super.increaseApproval(_spender, _addedValue);
683   }
684 
685   function decreaseApproval(
686     address _spender,
687     uint _subtractedValue
688   )
689     public
690     whenNotPaused
691     returns (bool success)
692   {
693     return super.decreaseApproval(_spender, _subtractedValue);
694   }
695 }
696 
697 /**
698  * @title Burnable Token
699  * @dev Token that can be irreversibly burned (destroyed).
700  */
701 contract BurnableToken is BasicToken {
702 
703   event Burn(address indexed burner, uint256 value);
704 
705   /**
706    * @dev Burns a specific amount of tokens.
707    * @param _value The amount of token to be burned.
708    */
709   function burn(uint256 _value) public {
710     _burn(msg.sender, _value);
711   }
712 
713   function _burn(address _who, uint256 _value) internal {
714     require(_value <= balances[_who]);
715     // no need to require value <= totalSupply, since that would imply the
716     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
717 
718     balances[_who] = balances[_who].sub(_value);
719     totalSupply_ = totalSupply_.sub(_value);
720     emit Burn(_who, _value);
721     emit Transfer(_who, address(0), _value);
722   }
723 }
724 
725 /**
726  * @title Standard Burnable Token
727  * @dev Adds burnFrom method to ERC20 implementations
728  */
729 contract StandardBurnableToken is BurnableToken, StandardToken {
730 
731   /**
732    * @dev Burns a specific amount of tokens from the target address and decrements allowance
733    * @param _from address The address which you want to send tokens from
734    * @param _value uint256 The amount of token to be burned
735    */
736   function burnFrom(address _from, uint256 _value) public {
737     require(_value <= allowed[_from][msg.sender]);
738     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
739     // this function needs to emit an event with the updated approval.
740     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
741     _burn(_from, _value);
742   }
743 }
744 
745 contract KratosToken is StandardBurnableToken, PausableToken {
746 
747     string constant public name = "KRATOS";
748     string constant public symbol = "TOS";
749     uint8 constant public decimals = 18;
750 
751     uint256 public timelockTimestamp = 0;
752     mapping(address => uint256) public timelock;
753 
754     constructor(uint256 _totalSupply) public {
755         // constructor
756         totalSupply_ = _totalSupply;
757         balances[msg.sender] = _totalSupply;
758     }
759 
760     event TimeLocked(address indexed _beneficary, uint256 _timestamp);
761     event TimeUnlocked(address indexed _beneficary);
762 
763     /**
764     * @dev Modifier to make a function callable only when the contract is not timelocked or timelock expired.
765     */
766     modifier whenNotTimelocked(address _beneficary) {
767         require(timelock[_beneficary] <= block.timestamp);
768         _;
769     }
770 
771     /**
772     * @dev Modifier to make a function callable only when the contract is timelocked and not expired.
773     */
774     modifier whenTimelocked(address _beneficary) {
775         require(timelock[_beneficary] > block.timestamp);
776         _;
777     }
778 
779     function enableTimelock(uint256 _timelockTimestamp) onlyOwner public {
780         require(timelockTimestamp == 0 || _timelockTimestamp > block.timestamp);
781         timelockTimestamp = _timelockTimestamp;
782     }
783 
784     function disableTimelock() onlyOwner public {
785         timelockTimestamp = 0;
786     }
787 
788     /**
789     * @dev called by the owner to timelock token belonging to beneficary
790     */
791     function addTimelock(address _beneficary, uint256 _timestamp) public onlyOwner {
792         _addTimelock(_beneficary, _timestamp);
793     }
794 
795     function _addTimelock(address _beneficary, uint256 _timestamp) internal whenNotTimelocked(_beneficary) {
796         require(_timestamp > block.timestamp);
797         timelock[_beneficary] = _timestamp;
798         emit TimeLocked(_beneficary, _timestamp);
799     }
800 
801     /**
802     * @dev called by the owner to timeunlock token belonging to beneficary
803     */
804     function removeTimelock(address _beneficary) onlyOwner whenTimelocked(_beneficary) public {
805         timelock[_beneficary] = 0;
806         emit TimeUnlocked(_beneficary);
807     }
808 
809     function transfer(address _to, uint256 _value) public whenNotTimelocked(msg.sender) returns (bool) {
810         if (timelockTimestamp > block.timestamp)
811             _addTimelock(_to, timelockTimestamp);
812         return super.transfer(_to, _value);
813     }
814 
815     function transferFrom(address _from, address _to, uint256 _value) public whenNotTimelocked(_from) returns (bool) {
816         if (timelockTimestamp > block.timestamp)
817             _addTimelock(_to, timelockTimestamp);
818         return super.transferFrom(_from, _to, _value);
819     }
820 
821     function approve(address _spender, uint256 _value) public whenNotTimelocked(_spender) returns (bool) {
822         return super.approve(_spender, _value);
823     }
824 
825     function increaseApproval(address _spender, uint _addedValue) public whenNotTimelocked(_spender) returns (bool success) {
826         return super.increaseApproval(_spender, _addedValue);
827     }
828 
829     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotTimelocked(_spender) returns (bool success) {
830         return super.decreaseApproval(_spender, _subtractedValue);
831     }
832 }
833 
834 /**
835  * @title Crowdsale
836  * @dev Crowdsale is a base contract for managing a token crowdsale,
837  * allowing investors to purchase tokens with ether. This contract implements
838  * such functionality in its most fundamental form and can be extended to provide additional
839  * functionality and/or custom behavior.
840  * The external interface represents the basic interface for purchasing tokens, and conform
841  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
842  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
843  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
844  * behavior.
845  */
846 contract Crowdsale {
847   using SafeMath for uint256;
848   using SafeERC20 for ERC20;
849 
850   // The token being sold
851   ERC20 public token;
852 
853   // Address where funds are collected
854   address public wallet;
855 
856   // How many token units a buyer gets per wei.
857   // The rate is the conversion between wei and the smallest and indivisible token unit.
858   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
859   // 1 wei will give you 1 unit, or 0.001 TOK.
860   uint256 public rate;
861 
862   // Amount of wei raised
863   uint256 public weiRaised;
864 
865   /**
866    * Event for token purchase logging
867    * @param purchaser who paid for the tokens
868    * @param beneficiary who got the tokens
869    * @param value weis paid for purchase
870    * @param amount amount of tokens purchased
871    */
872   event TokenPurchase(
873     address indexed purchaser,
874     address indexed beneficiary,
875     uint256 value,
876     uint256 amount
877   );
878 
879   /**
880    * @param _rate Number of token units a buyer gets per wei
881    * @param _wallet Address where collected funds will be forwarded to
882    * @param _token Address of the token being sold
883    */
884   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
885     require(_rate > 0);
886     require(_wallet != address(0));
887     require(_token != address(0));
888 
889     rate = _rate;
890     wallet = _wallet;
891     token = _token;
892   }
893 
894   // -----------------------------------------
895   // Crowdsale external interface
896   // -----------------------------------------
897 
898   /**
899    * @dev fallback function ***DO NOT OVERRIDE***
900    */
901   function () external payable {
902     buyTokens(msg.sender);
903   }
904 
905   /**
906    * @dev low level token purchase ***DO NOT OVERRIDE***
907    * @param _beneficiary Address performing the token purchase
908    */
909   function buyTokens(address _beneficiary) public payable {
910 
911     uint256 weiAmount = msg.value;
912     _preValidatePurchase(_beneficiary, weiAmount);
913 
914     // calculate token amount to be created
915     uint256 tokens = _getTokenAmount(weiAmount);
916 
917     // update state
918     weiRaised = weiRaised.add(weiAmount);
919 
920     _processPurchase(_beneficiary, tokens);
921     emit TokenPurchase(
922       msg.sender,
923       _beneficiary,
924       weiAmount,
925       tokens
926     );
927 
928     _updatePurchasingState(_beneficiary, weiAmount);
929 
930     _forwardFunds();
931     _postValidatePurchase(_beneficiary, weiAmount);
932   }
933 
934   // -----------------------------------------
935   // Internal interface (extensible)
936   // -----------------------------------------
937 
938   /**
939    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
940    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
941    *   super._preValidatePurchase(_beneficiary, _weiAmount);
942    *   require(weiRaised.add(_weiAmount) <= cap);
943    * @param _beneficiary Address performing the token purchase
944    * @param _weiAmount Value in wei involved in the purchase
945    */
946   function _preValidatePurchase(
947     address _beneficiary,
948     uint256 _weiAmount
949   )
950     internal
951   {
952     require(_beneficiary != address(0));
953     require(_weiAmount != 0);
954   }
955 
956   /**
957    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
958    * @param _beneficiary Address performing the token purchase
959    * @param _weiAmount Value in wei involved in the purchase
960    */
961   function _postValidatePurchase(
962     address _beneficiary,
963     uint256 _weiAmount
964   )
965     internal
966   {
967     // optional override
968   }
969 
970   /**
971    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
972    * @param _beneficiary Address performing the token purchase
973    * @param _tokenAmount Number of tokens to be emitted
974    */
975   function _deliverTokens(
976     address _beneficiary,
977     uint256 _tokenAmount
978   )
979     internal
980   {
981     token.safeTransfer(_beneficiary, _tokenAmount);
982   }
983 
984   /**
985    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
986    * @param _beneficiary Address receiving the tokens
987    * @param _tokenAmount Number of tokens to be purchased
988    */
989   function _processPurchase(
990     address _beneficiary,
991     uint256 _tokenAmount
992   )
993     internal
994   {
995     _deliverTokens(_beneficiary, _tokenAmount);
996   }
997 
998   /**
999    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1000    * @param _beneficiary Address receiving the tokens
1001    * @param _weiAmount Value in wei involved in the purchase
1002    */
1003   function _updatePurchasingState(
1004     address _beneficiary,
1005     uint256 _weiAmount
1006   )
1007     internal
1008   {
1009     // optional override
1010   }
1011 
1012   /**
1013    * @dev Override to extend the way in which ether is converted to tokens.
1014    * @param _weiAmount Value in wei to be converted into tokens
1015    * @return Number of tokens that can be purchased with the specified _weiAmount
1016    */
1017   function _getTokenAmount(uint256 _weiAmount)
1018     internal view returns (uint256)
1019   {
1020     return _weiAmount.mul(rate);
1021   }
1022 
1023   /**
1024    * @dev Determines how ETH is stored/forwarded on purchases.
1025    */
1026   function _forwardFunds() internal {
1027     wallet.transfer(msg.value);
1028   }
1029 }
1030 
1031 /**
1032  * @title WhitelistedCrowdsale
1033  * @dev Crowdsale in which only whitelisted users can contribute.
1034  */
1035 contract WhitelistedCrowdsale is Whitelist, Crowdsale {
1036   /**
1037    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
1038    * @param _beneficiary Token beneficiary
1039    * @param _weiAmount Amount of wei contributed
1040    */
1041   function _preValidatePurchase(
1042     address _beneficiary,
1043     uint256 _weiAmount
1044   )
1045     internal
1046     onlyIfWhitelisted(_beneficiary)
1047   {
1048     super._preValidatePurchase(_beneficiary, _weiAmount);
1049   }
1050 
1051 }
1052 
1053 /**
1054  * @title CappedCrowdsale
1055  * @dev Crowdsale with a limit for total contributions.
1056  */
1057 contract CappedCrowdsale is Crowdsale {
1058   using SafeMath for uint256;
1059 
1060   uint256 public cap;
1061 
1062   /**
1063    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1064    * @param _cap Max amount of wei to be contributed
1065    */
1066   constructor(uint256 _cap) public {
1067     require(_cap > 0);
1068     cap = _cap;
1069   }
1070 
1071   /**
1072    * @dev Checks whether the cap has been reached.
1073    * @return Whether the cap was reached
1074    */
1075   function capReached() public view returns (bool) {
1076     return weiRaised >= cap;
1077   }
1078 
1079   /**
1080    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1081    * @param _beneficiary Token purchaser
1082    * @param _weiAmount Amount of wei contributed
1083    */
1084   function _preValidatePurchase(
1085     address _beneficiary,
1086     uint256 _weiAmount
1087   )
1088     internal
1089   {
1090     super._preValidatePurchase(_beneficiary, _weiAmount);
1091     require(weiRaised.add(_weiAmount) <= cap);
1092   }
1093 
1094 }
1095 
1096 /**
1097  * @title TimedCrowdsale
1098  * @dev Crowdsale accepting contributions only within a time frame.
1099  */
1100 contract TimedCrowdsale is Crowdsale {
1101   using SafeMath for uint256;
1102 
1103   uint256 public openingTime;
1104   uint256 public closingTime;
1105 
1106   /**
1107    * @dev Reverts if not in crowdsale time range.
1108    */
1109   modifier onlyWhileOpen {
1110     // solium-disable-next-line security/no-block-members
1111     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1112     _;
1113   }
1114 
1115   /**
1116    * @dev Constructor, takes crowdsale opening and closing times.
1117    * @param _openingTime Crowdsale opening time
1118    * @param _closingTime Crowdsale closing time
1119    */
1120   constructor(uint256 _openingTime, uint256 _closingTime) public {
1121     // solium-disable-next-line security/no-block-members
1122     require(_openingTime >= block.timestamp);
1123     require(_closingTime >= _openingTime);
1124 
1125     openingTime = _openingTime;
1126     closingTime = _closingTime;
1127   }
1128 
1129   /**
1130    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1131    * @return Whether crowdsale period has elapsed
1132    */
1133   function hasClosed() public view returns (bool) {
1134     // solium-disable-next-line security/no-block-members
1135     return block.timestamp > closingTime;
1136   }
1137 
1138   /**
1139    * @dev Extend parent behavior requiring to be within contributing period
1140    * @param _beneficiary Token purchaser
1141    * @param _weiAmount Amount of wei contributed
1142    */
1143   function _preValidatePurchase(
1144     address _beneficiary,
1145     uint256 _weiAmount
1146   )
1147     internal
1148     onlyWhileOpen
1149   {
1150     super._preValidatePurchase(_beneficiary, _weiAmount);
1151   }
1152 
1153 }
1154 
1155 /**
1156  * @title PostDeliveryCrowdsale
1157  * @dev Crowdsale that locks tokens from withdrawal until it ends.
1158  */
1159 contract PostDeliveryCrowdsale is TimedCrowdsale {
1160   using SafeMath for uint256;
1161 
1162   mapping(address => uint256) public balances;
1163 
1164   /**
1165    * @dev Withdraw tokens only after crowdsale ends.
1166    */
1167   function withdrawTokens() public {
1168     require(hasClosed());
1169     uint256 amount = balances[msg.sender];
1170     require(amount > 0);
1171     balances[msg.sender] = 0;
1172     _deliverTokens(msg.sender, amount);
1173   }
1174 
1175   /**
1176    * @dev Overrides parent by storing balances instead of issuing tokens right away.
1177    * @param _beneficiary Token purchaser
1178    * @param _tokenAmount Amount of tokens purchased
1179    */
1180   function _processPurchase(
1181     address _beneficiary,
1182     uint256 _tokenAmount
1183   )
1184     internal
1185   {
1186     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
1187   }
1188 
1189 }
1190 
1191 contract KratosPresale is CappedCrowdsale, WhitelistedCrowdsale, PostDeliveryCrowdsale {
1192 
1193     constructor(
1194         uint256 _cap,
1195         uint256 _openingTime,
1196         uint256 _closingTime,
1197         uint256 _rate,
1198         address _wallet,
1199         KratosToken _token
1200     ) public
1201         Crowdsale(_rate, _wallet, _token)
1202         CappedCrowdsale(_cap) // hard cap
1203         TimedCrowdsale(_openingTime, _closingTime) {
1204     }
1205 
1206     function setRate(uint256 _rate) external onlyOwner onlyWhileOpen {
1207         // solium-disable-next-line security/no-block-members
1208         require(_rate > 0);
1209 
1210         rate = _rate;
1211     }
1212 
1213     function setClosingTime(uint256 _closingTime) external onlyOwner {
1214         // solium-disable-next-line security/no-block-members
1215         require(_closingTime >= block.timestamp);
1216         require(_closingTime >= openingTime);
1217 
1218         closingTime = _closingTime;
1219     }
1220 
1221     // allow withdrawal of tokens anytime
1222     function withdrawTokens(address _addr) public onlyOwner {
1223         // require(hasClosed());
1224         uint256 amount = balances[_addr];
1225         require(amount > 0);
1226         balances[_addr] = 0;
1227         _deliverTokens(_addr, amount);
1228     }
1229 }