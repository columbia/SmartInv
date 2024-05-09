1 // Sources flattened with buidler v0.1.5
2 pragma solidity 0.4.24;
3 
4 
5 // File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v1.12.0
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13 
14   function balanceOf(address _who) external view returns (uint256);
15 
16   function allowance(address _owner, address _spender)
17     external view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) external returns (bool);
20 
21   function approve(address _spender, uint256 _value)
22     external returns (bool);
23 
24   function transferFrom(address _from, address _to, uint256 _value)
25     external returns (bool);
26 
27   event Transfer(
28     address indexed from,
29     address indexed to,
30     uint256 value
31   );
32 
33   event Approval(
34     address indexed owner,
35     address indexed spender,
36     uint256 value
37   );
38 }
39 
40 
41 // File openzeppelin-solidity/contracts/math/SafeMath.sol@v1.12.0
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, reverts on overflow.
51   */
52   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54     // benefit is lost if 'b' is also tested.
55     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56     if (_a == 0) {
57       return 0;
58     }
59 
60     uint256 c = _a * _b;
61     require(c / _a == _b);
62 
63     return c;
64   }
65 
66   /**
67   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
68   */
69   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
70     require(_b > 0); // Solidity only automatically asserts when dividing by 0
71     uint256 c = _a / _b;
72     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
73 
74     return c;
75   }
76 
77   /**
78   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79   */
80   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     require(_b <= _a);
82     uint256 c = _a - _b;
83 
84     return c;
85   }
86 
87   /**
88   * @dev Adds two numbers, reverts on overflow.
89   */
90   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     uint256 c = _a + _b;
92     require(c >= _a);
93 
94     return c;
95   }
96 
97   /**
98   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
99   * reverts when dividing by zero.
100   */
101   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102     require(b != 0);
103     return a % b;
104   }
105 }
106 
107 
108 // File openzeppelin-solidity/contracts/token/ERC20/ERC20.sol@v1.12.0
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
115  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract ERC20 is IERC20 {
118   using SafeMath for uint256;
119 
120   mapping (address => uint256) private balances_;
121 
122   mapping (address => mapping (address => uint256)) private allowed_;
123 
124   uint256 private totalSupply_;
125 
126   /**
127   * @dev Total number of tokens in existence
128   */
129   function totalSupply() public view returns (uint256) {
130     return totalSupply_;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public view returns (uint256) {
139     return balances_[_owner];
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(
149     address _owner,
150     address _spender
151    )
152     public
153     view
154     returns (uint256)
155   {
156     return allowed_[_owner][_spender];
157   }
158 
159   /**
160   * @dev Transfer token for a specified address
161   * @param _to The address to transfer to.
162   * @param _value The amount to be transferred.
163   */
164   function transfer(address _to, uint256 _value) public returns (bool) {
165     require(_value <= balances_[msg.sender]);
166     require(_to != address(0));
167 
168     balances_[msg.sender] = balances_[msg.sender].sub(_value);
169     balances_[_to] = balances_[_to].add(_value);
170     emit Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed_[msg.sender][_spender] = _value;
185     emit Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(
196     address _from,
197     address _to,
198     uint256 _value
199   )
200     public
201     returns (bool)
202   {
203     require(_value <= balances_[_from]);
204     require(_value <= allowed_[_from][msg.sender]);
205     require(_to != address(0));
206 
207     balances_[_from] = balances_[_from].sub(_value);
208     balances_[_to] = balances_[_to].add(_value);
209     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
210     emit Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    * approve should be called when allowed_[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(
224     address _spender,
225     uint256 _addedValue
226   )
227     public
228     returns (bool)
229   {
230     allowed_[msg.sender][_spender] = (
231       allowed_[msg.sender][_spender].add(_addedValue));
232     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed_[_spender] == 0. To decrement
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(
246     address _spender,
247     uint256 _subtractedValue
248   )
249     public
250     returns (bool)
251   {
252     uint256 oldValue = allowed_[msg.sender][_spender];
253     if (_subtractedValue >= oldValue) {
254       allowed_[msg.sender][_spender] = 0;
255     } else {
256       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Internal function that mints an amount of the token and assigns it to
264    * an account. This encapsulates the modification of balances such that the
265    * proper events are emitted.
266    * @param _account The account that will receive the created tokens.
267    * @param _amount The amount that will be created.
268    */
269   function _mint(address _account, uint256 _amount) internal {
270     require(_account != 0);
271     totalSupply_ = totalSupply_.add(_amount);
272     balances_[_account] = balances_[_account].add(_amount);
273     emit Transfer(address(0), _account, _amount);
274   }
275 
276   /**
277    * @dev Internal function that burns an amount of the token of a given
278    * account.
279    * @param _account The account whose tokens will be burnt.
280    * @param _amount The amount that will be burnt.
281    */
282   function _burn(address _account, uint256 _amount) internal {
283     require(_account != 0);
284     require(_amount <= balances_[_account]);
285 
286     totalSupply_ = totalSupply_.sub(_amount);
287     balances_[_account] = balances_[_account].sub(_amount);
288     emit Transfer(_account, address(0), _amount);
289   }
290 
291   /**
292    * @dev Internal function that burns an amount of the token of a given
293    * account, deducting from the sender's allowance for said account. Uses the
294    * internal _burn function.
295    * @param _account The account whose tokens will be burnt.
296    * @param _amount The amount that will be burnt.
297    */
298   function _burnFrom(address _account, uint256 _amount) internal {
299     require(_amount <= allowed_[_account][msg.sender]);
300 
301     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
302     // this function needs to emit an event with the updated approval.
303     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
304       _amount);
305     _burn(_account, _amount);
306   }
307 }
308 
309 
310 // File openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol@v1.12.0
311 
312 /**
313  * @title SafeERC20
314  * @dev Wrappers around ERC20 operations that throw on failure.
315  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
316  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
317  */
318 library SafeERC20 {
319   function safeTransfer(
320     IERC20 _token,
321     address _to,
322     uint256 _value
323   )
324     internal
325   {
326     require(_token.transfer(_to, _value));
327   }
328 
329   function safeTransferFrom(
330     IERC20 _token,
331     address _from,
332     address _to,
333     uint256 _value
334   )
335     internal
336   {
337     require(_token.transferFrom(_from, _to, _value));
338   }
339 
340   function safeApprove(
341     IERC20 _token,
342     address _spender,
343     uint256 _value
344   )
345     internal
346   {
347     require(_token.approve(_spender, _value));
348   }
349 }
350 
351 
352 // File openzeppelin-solidity/contracts/ownership/Ownable.sol@v1.12.0
353 
354 /**
355  * @title Ownable
356  * @dev The Ownable contract has an owner address, and provides basic authorization control
357  * functions, this simplifies the implementation of "user permissions".
358  */
359 contract Ownable {
360   address public owner;
361 
362 
363   event OwnershipRenounced(address indexed previousOwner);
364   event OwnershipTransferred(
365     address indexed previousOwner,
366     address indexed newOwner
367   );
368 
369 
370   /**
371    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
372    * account.
373    */
374   constructor() public {
375     owner = msg.sender;
376   }
377 
378   /**
379    * @dev Throws if called by any account other than the owner.
380    */
381   modifier onlyOwner() {
382     require(msg.sender == owner);
383     _;
384   }
385 
386   /**
387    * @dev Allows the current owner to relinquish control of the contract.
388    * @notice Renouncing to ownership will leave the contract without an owner.
389    * It will not be possible to call the functions with the `onlyOwner`
390    * modifier anymore.
391    */
392   function renounceOwnership() public onlyOwner {
393     emit OwnershipRenounced(owner);
394     owner = address(0);
395   }
396 
397   /**
398    * @dev Allows the current owner to transfer control of the contract to a newOwner.
399    * @param _newOwner The address to transfer ownership to.
400    */
401   function transferOwnership(address _newOwner) public onlyOwner {
402     _transferOwnership(_newOwner);
403   }
404 
405   /**
406    * @dev Transfers control of the contract to a newOwner.
407    * @param _newOwner The address to transfer ownership to.
408    */
409   function _transferOwnership(address _newOwner) internal {
410     require(_newOwner != address(0));
411     emit OwnershipTransferred(owner, _newOwner);
412     owner = _newOwner;
413   }
414 }
415 
416 
417 // File openzeppelin-solidity/contracts/access/rbac/Roles.sol@v1.12.0
418 
419 /**
420  * @title Roles
421  * @author Francisco Giordano (@frangio)
422  * @dev Library for managing addresses assigned to a Role.
423  * See RBAC.sol for example usage.
424  */
425 library Roles {
426   struct Role {
427     mapping (address => bool) bearer;
428   }
429 
430   /**
431    * @dev give an account access to this role
432    */
433   function add(Role storage _role, address _account)
434     internal
435   {
436     _role.bearer[_account] = true;
437   }
438 
439   /**
440    * @dev remove an account's access to this role
441    */
442   function remove(Role storage _role, address _account)
443     internal
444   {
445     _role.bearer[_account] = false;
446   }
447 
448   /**
449    * @dev check if an account has this role
450    * // reverts
451    */
452   function check(Role storage _role, address _account)
453     internal
454     view
455   {
456     require(has(_role, _account));
457   }
458 
459   /**
460    * @dev check if an account has this role
461    * @return bool
462    */
463   function has(Role storage _role, address _account)
464     internal
465     view
466     returns (bool)
467   {
468     return _role.bearer[_account];
469   }
470 }
471 
472 
473 // File openzeppelin-solidity/contracts/access/rbac/RBAC.sol@v1.12.0
474 
475 /**
476  * @title RBAC (Role-Based Access Control)
477  * @author Matt Condon (@Shrugs)
478  * @dev Stores and provides setters and getters for roles and addresses.
479  * Supports unlimited numbers of roles and addresses.
480  * See //contracts/mocks/RBACMock.sol for an example of usage.
481  * This RBAC method uses strings to key roles. It may be beneficial
482  * for you to write your own implementation of this interface using Enums or similar.
483  */
484 contract RBAC {
485   using Roles for Roles.Role;
486 
487   mapping (string => Roles.Role) private roles;
488 
489   event RoleAdded(address indexed operator, string role);
490   event RoleRemoved(address indexed operator, string role);
491 
492   /**
493    * @dev reverts if addr does not have role
494    * @param _operator address
495    * @param _role the name of the role
496    * // reverts
497    */
498   function checkRole(address _operator, string _role)
499     public
500     view
501   {
502     roles[_role].check(_operator);
503   }
504 
505   /**
506    * @dev determine if addr has role
507    * @param _operator address
508    * @param _role the name of the role
509    * @return bool
510    */
511   function hasRole(address _operator, string _role)
512     public
513     view
514     returns (bool)
515   {
516     return roles[_role].has(_operator);
517   }
518 
519   /**
520    * @dev add a role to an address
521    * @param _operator address
522    * @param _role the name of the role
523    */
524   function _addRole(address _operator, string _role)
525     internal
526   {
527     roles[_role].add(_operator);
528     emit RoleAdded(_operator, _role);
529   }
530 
531   /**
532    * @dev remove a role from an address
533    * @param _operator address
534    * @param _role the name of the role
535    */
536   function _removeRole(address _operator, string _role)
537     internal
538   {
539     roles[_role].remove(_operator);
540     emit RoleRemoved(_operator, _role);
541   }
542 
543   /**
544    * @dev modifier to scope access to a single role (uses msg.sender as addr)
545    * @param _role the name of the role
546    * // reverts
547    */
548   modifier onlyRole(string _role)
549   {
550     checkRole(msg.sender, _role);
551     _;
552   }
553 
554   /**
555    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
556    * @param _roles the names of the roles to scope access to
557    * // reverts
558    *
559    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
560    *  see: https://github.com/ethereum/solidity/issues/2467
561    */
562   // modifier onlyRoles(string[] _roles) {
563   //     bool hasAnyRole = false;
564   //     for (uint8 i = 0; i < _roles.length; i++) {
565   //         if (hasRole(msg.sender, _roles[i])) {
566   //             hasAnyRole = true;
567   //             break;
568   //         }
569   //     }
570 
571   //     require(hasAnyRole);
572 
573   //     _;
574   // }
575 }
576 
577 
578 // File openzeppelin-solidity/contracts/cryptography/ECDSA.sol@v1.12.0
579 
580 /**
581  * @title Elliptic curve signature operations
582  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
583  * TODO Remove this library once solidity supports passing a signature to ecrecover.
584  * See https://github.com/ethereum/solidity/issues/864
585  */
586 
587 library ECDSA {
588 
589   /**
590    * @dev Recover signer address from a message by using their signature
591    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
592    * @param _signature bytes signature, the signature is generated using web3.eth.sign()
593    */
594   function recover(bytes32 _hash, bytes _signature)
595     internal
596     pure
597     returns (address)
598   {
599     bytes32 r;
600     bytes32 s;
601     uint8 v;
602 
603     // Check the signature length
604     if (_signature.length != 65) {
605       return (address(0));
606     }
607 
608     // Divide the signature in r, s and v variables
609     // ecrecover takes the signature parameters, and the only way to get them
610     // currently is to use assembly.
611     // solium-disable-next-line security/no-inline-assembly
612     assembly {
613       r := mload(add(_signature, 32))
614       s := mload(add(_signature, 64))
615       v := byte(0, mload(add(_signature, 96)))
616     }
617 
618     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
619     if (v < 27) {
620       v += 27;
621     }
622 
623     // If the version is correct return the signer address
624     if (v != 27 && v != 28) {
625       return (address(0));
626     } else {
627       // solium-disable-next-line arg-overflow
628       return ecrecover(_hash, v, r, s);
629     }
630   }
631 
632   /**
633    * toEthSignedMessageHash
634    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
635    * and hash the result
636    */
637   function toEthSignedMessageHash(bytes32 _hash)
638     internal
639     pure
640     returns (bytes32)
641   {
642     // 32 is the length in bytes of hash,
643     // enforced by the type signature above
644     return keccak256(
645       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
646     );
647   }
648 }
649 
650 
651 // File openzeppelin-solidity/contracts/access/SignatureBouncer.sol@v1.12.0
652 
653 /**
654  * @title SignatureBouncer
655  * @author PhABC, Shrugs and aflesher
656  * @dev Bouncer allows users to submit a signature as a permission to do an action.
657  * If the signature is from one of the authorized bouncer addresses, the signature
658  * is valid. The owner of the contract adds/removes bouncers.
659  * Bouncer addresses can be individual servers signing grants or different
660  * users within a decentralized club that have permission to invite other members.
661  * This technique is useful for whitelists and airdrops; instead of putting all
662  * valid addresses on-chain, simply sign a grant of the form
663  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a valid bouncer address.
664  * Then restrict access to your crowdsale/whitelist/airdrop using the
665  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
666  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
667  * `onlyValidSignatureAndData` can be used to restrict access to only a given method
668  * or a given method with given parameters respectively.
669  * See the tests Bouncer.test.js for specific usage examples.
670  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make the _signature
671  * parameter the "last" parameter. You cannot sign a message that has its own
672  * signature in it so the last 128 bytes of msg.data (which represents the
673  * length of the _signature data and the _signaature data itself) is ignored when validating.
674  * Also non fixed sized parameters make constructing the data in the signature
675  * much more complex. See https://ethereum.stackexchange.com/a/50616 for more details.
676  */
677 contract SignatureBouncer is Ownable, RBAC {
678   using ECDSA for bytes32;
679 
680   // Name of the bouncer role.
681   string private constant ROLE_BOUNCER = "bouncer";
682   // Function selectors are 4 bytes long, as documented in
683   // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
684   uint256 private constant METHOD_ID_SIZE = 4;
685   // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
686   uint256 private constant SIGNATURE_SIZE = 96;
687 
688   /**
689    * @dev requires that a valid signature of a bouncer was provided
690    */
691   modifier onlyValidSignature(bytes _signature)
692   {
693     require(_isValidSignature(msg.sender, _signature));
694     _;
695   }
696 
697   /**
698    * @dev requires that a valid signature with a specifed method of a bouncer was provided
699    */
700   modifier onlyValidSignatureAndMethod(bytes _signature)
701   {
702     require(_isValidSignatureAndMethod(msg.sender, _signature));
703     _;
704   }
705 
706   /**
707    * @dev requires that a valid signature with a specifed method and params of a bouncer was provided
708    */
709   modifier onlyValidSignatureAndData(bytes _signature)
710   {
711     require(_isValidSignatureAndData(msg.sender, _signature));
712     _;
713   }
714 
715   /**
716    * @dev Determine if an account has the bouncer role.
717    * @return true if the account is a bouncer, false otherwise.
718    */
719   function isBouncer(address _account) public view returns(bool) {
720     return hasRole(_account, ROLE_BOUNCER);
721   }
722 
723   /**
724    * @dev allows the owner to add additional bouncer addresses
725    */
726   function addBouncer(address _bouncer)
727     public
728     onlyOwner
729   {
730     require(_bouncer != address(0));
731     _addRole(_bouncer, ROLE_BOUNCER);
732   }
733 
734   /**
735    * @dev allows the owner to remove bouncer addresses
736    */
737   function removeBouncer(address _bouncer)
738     public
739     onlyOwner
740   {
741     _removeRole(_bouncer, ROLE_BOUNCER);
742   }
743 
744   /**
745    * @dev is the signature of `this + sender` from a bouncer?
746    * @return bool
747    */
748   function _isValidSignature(address _address, bytes _signature)
749     internal
750     view
751     returns (bool)
752   {
753     return _isValidDataHash(
754       keccak256(abi.encodePacked(address(this), _address)),
755       _signature
756     );
757   }
758 
759   /**
760    * @dev is the signature of `this + sender + methodId` from a bouncer?
761    * @return bool
762    */
763   function _isValidSignatureAndMethod(address _address, bytes _signature)
764     internal
765     view
766     returns (bool)
767   {
768     bytes memory data = new bytes(METHOD_ID_SIZE);
769     for (uint i = 0; i < data.length; i++) {
770       data[i] = msg.data[i];
771     }
772     return _isValidDataHash(
773       keccak256(abi.encodePacked(address(this), _address, data)),
774       _signature
775     );
776   }
777 
778   /**
779     * @dev is the signature of `this + sender + methodId + params(s)` from a bouncer?
780     * @notice the _signature parameter of the method being validated must be the "last" parameter
781     * @return bool
782     */
783   function _isValidSignatureAndData(address _address, bytes _signature)
784     internal
785     view
786     returns (bool)
787   {
788     require(msg.data.length > SIGNATURE_SIZE);
789     bytes memory data = new bytes(msg.data.length - SIGNATURE_SIZE);
790     for (uint i = 0; i < data.length; i++) {
791       data[i] = msg.data[i];
792     }
793     return _isValidDataHash(
794       keccak256(abi.encodePacked(address(this), _address, data)),
795       _signature
796     );
797   }
798 
799   /**
800    * @dev internal function to convert a hash to an eth signed message
801    * and then recover the signature and check it against the bouncer role
802    * @return bool
803    */
804   function _isValidDataHash(bytes32 _hash, bytes _signature)
805     internal
806     view
807     returns (bool)
808   {
809     address signer = _hash
810       .toEthSignedMessageHash()
811       .recover(_signature);
812     return isBouncer(signer);
813   }
814 }
815 
816 
817 // File contracts/bouncers/EscrowedERC20Bouncer.sol
818 
819 contract EscrowedERC20Bouncer is SignatureBouncer {
820   using SafeERC20 for IERC20;
821 
822   uint256 public nonce;
823 
824   modifier onlyBouncer()
825   {
826     require(isBouncer(msg.sender), "DOES_NOT_HAVE_BOUNCER_ROLE");
827     _;
828   }
829 
830   modifier validDataWithoutSender(bytes _signature)
831   {
832     require(_isValidSignatureAndData(address(this), _signature), "INVALID_SIGNATURE");
833     _;
834   }
835 
836   constructor(address _bouncer)
837     public
838   {
839     addBouncer(_bouncer);
840   }
841 
842   /**
843    * allow anyone with a valid bouncer signature for the msg data to send `_amount` of `_token` to `_to`
844    */
845   function withdraw(uint256 _nonce, IERC20 _token, address _to, uint256 _amount, bytes _signature)
846     public
847     validDataWithoutSender(_signature)
848   {
849     require(_nonce > nonce, "NONCE_GT_NONCE_REQUIRED");
850     nonce = _nonce;
851     _token.safeTransfer(_to, _amount);
852   }
853 
854   /**
855    * Allow the bouncer to withdraw all of the ERC20 tokens in the contract
856    */
857   function withdrawAll(IERC20 _token, address _to)
858     public
859     onlyBouncer
860   {
861     _token.safeTransfer(_to, _token.balanceOf(address(this)));
862   }
863 }
864 
865 
866 // File openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol@v1.12.0
867 
868 /**
869  * @title Mintable token
870  * @dev Simple ERC20 Token example, with mintable token creation
871  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
872  */
873 contract ERC20Mintable is ERC20, Ownable {
874   event Mint(address indexed to, uint256 amount);
875   event MintFinished();
876 
877   bool public mintingFinished = false;
878 
879 
880   modifier canMint() {
881     require(!mintingFinished);
882     _;
883   }
884 
885   modifier hasMintPermission() {
886     require(msg.sender == owner);
887     _;
888   }
889 
890   /**
891    * @dev Function to mint tokens
892    * @param _to The address that will receive the minted tokens.
893    * @param _amount The amount of tokens to mint.
894    * @return A boolean that indicates if the operation was successful.
895    */
896   function mint(
897     address _to,
898     uint256 _amount
899   )
900     public
901     hasMintPermission
902     canMint
903     returns (bool)
904   {
905     _mint(_to, _amount);
906     emit Mint(_to, _amount);
907     return true;
908   }
909 
910   /**
911    * @dev Function to stop minting new tokens.
912    * @return True if the operation was successful.
913    */
914   function finishMinting() public onlyOwner canMint returns (bool) {
915     mintingFinished = true;
916     emit MintFinished();
917     return true;
918   }
919 }
920 
921 
922 // File contracts/bouncers/MintableERC20Bouncer.sol
923 
924 contract MintableERC20Bouncer is SignatureBouncer {
925 
926   uint256 public nonce;
927 
928   modifier validDataWithoutSender(bytes _signature)
929   {
930     require(_isValidSignatureAndData(address(this), _signature), "INVALID_SIGNATURE");
931     _;
932   }
933 
934   constructor(address _bouncer)
935     public
936   {
937     addBouncer(_bouncer);
938   }
939 
940   /**
941    * allow anyone with a valid bouncer signature for the msg data to mint `_amount` of `_token` to `_to`
942    */
943   function mint(uint256 _nonce, ERC20Mintable _token, address _to, uint256 _amount, bytes _signature)
944     public
945     validDataWithoutSender(_signature)
946   {
947     require(_nonce > nonce, "NONCE_GT_NONCE_REQUIRED");
948     nonce = _nonce;
949     _token.mint(_to, _amount);
950   }
951 }
952 
953 
954 // File openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol@v1.12.0
955 
956 /**
957  * @title ERC20Detailed token
958  * @dev The decimals are only for visualization purposes.
959  * All the operations are done using the smallest and indivisible token unit,
960  * just as on Ethereum all the operations are done in wei.
961  */
962 contract ERC20Detailed is IERC20 {
963   string public name;
964   string public symbol;
965   uint8 public decimals;
966 
967   constructor(string _name, string _symbol, uint8 _decimals) public {
968     name = _name;
969     symbol = _symbol;
970     decimals = _decimals;
971   }
972 }
973 
974 
975 // File openzeppelin-solidity/contracts/proposals/ERC1046/TokenMetadata.sol@v1.12.0
976 
977 /**
978  * @title ERC-1047 Token Metadata
979  * @dev See https://eips.ethereum.org/EIPS/eip-1046
980  * @dev tokenURI must respond with a URI that implements https://eips.ethereum.org/EIPS/eip-1047
981  * @dev TODO - update https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC721/IERC721.sol#L17 when 1046 is finalized
982  */
983 contract ERC20TokenMetadata is IERC20 {
984   function tokenURI() external view returns (string);
985 }
986 
987 
988 contract ERC20WithMetadata is ERC20TokenMetadata {
989   string private tokenURI_ = "";
990 
991   constructor(string _tokenURI)
992     public
993   {
994     tokenURI_ = _tokenURI;
995   }
996 
997   function tokenURI() external view returns (string) {
998     return tokenURI_;
999   }
1000 }
1001 
1002 
1003 // File contracts/tokens/KataToken.sol
1004 
1005 contract KataToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20WithMetadata {
1006   constructor(
1007     string _name,
1008     string _symbol,
1009     uint8 _decimals,
1010     string _tokenURI
1011   )
1012     ERC20WithMetadata(_tokenURI)
1013     ERC20Detailed(_name, _symbol, _decimals)
1014     public
1015   {}
1016 }
1017 
1018 
1019 // File contracts/deploy/TokenAndBouncerDeployer.sol
1020 
1021 contract TokenAndBouncerDeployer is Ownable {
1022   event Deployed(address indexed token, address indexed bouncer);
1023 
1024   function deploy(
1025     string _name,
1026     string _symbol,
1027     uint8 _decimals,
1028     string _tokenURI,
1029     address _signer
1030   )
1031     public
1032     onlyOwner
1033   {
1034     MintableERC20Bouncer bouncer = new MintableERC20Bouncer(_signer);
1035     KataToken token = new KataToken(_name, _symbol, _decimals, _tokenURI);
1036     token.transferOwnership(address(bouncer));
1037 
1038     emit Deployed(address(token), address(bouncer));
1039 
1040     selfdestruct(msg.sender);
1041   }
1042 }
1043 
1044 
1045 // File contracts/mocks/MockToken.sol
1046 
1047 contract MockToken is ERC20Detailed, ERC20Mintable {
1048   constructor(string _name, string _symbol, uint8 _decimals)
1049     ERC20Detailed(_name, _symbol, _decimals)
1050     ERC20Mintable()
1051     ERC20()
1052     public
1053   {
1054 
1055   }
1056 }
1057 
1058 
1059 // File contracts/old/ClaimableToken.sol
1060 
1061 // import "./MintableERC721Token.sol";
1062 // import "openzeppelin-solidity/contracts/token/ERC721/DefaultTokenURI.sol";
1063 
1064 
1065 // contract ClaimableToken is DefaultTokenURI, MintableERC721Token {
1066 
1067 //   constructor(string _name, string _symbol, string _tokenURI)
1068 //     MintableERC721Token(_name, _symbol)
1069 //     DefaultTokenURI(_tokenURI)
1070 //     public
1071 //   {
1072 
1073 //   }
1074 // }
1075 
1076 
1077 // File contracts/old/ClaimableTokenDeployer.sol
1078 
1079 // import "./ClaimableTokenMinter.sol";
1080 // import "./ClaimableToken.sol";
1081 
1082 
1083 // contract ClaimableTokenDeployer {
1084 //   ClaimableToken public token;
1085 //   ClaimableTokenMinter public minter;
1086 
1087 //   constructor(
1088 //     string _name,
1089 //     string _symbol,
1090 //     string _tokenURI,
1091 //     address _bouncer
1092 //   )
1093 //     public
1094 //   {
1095 //     token = new ClaimableToken(_name, _symbol, _tokenURI);
1096 //     minter = new ClaimableTokenMinter(token);
1097 //     token.addOwner(msg.sender);
1098 //     token.addMinter(address(minter));
1099 //     minter.addOwner(msg.sender);
1100 //     minter.addBouncer(_bouncer);
1101 //   }
1102 // }
1103 
1104 
1105 // File contracts/old/ClaimableTokenMinter.sol
1106 
1107 // import "./ClaimableToken.sol";
1108 // import "openzeppelin-solidity/contracts/access/ERC721Minter.sol";
1109 // import "openzeppelin-solidity/contracts/access/NonceTracker.sol";
1110 
1111 
1112 // contract ClaimableTokenMinter is NonceTracker, ERC721Minter {
1113 
1114 //   constructor(ClaimableToken _token)
1115 //     ERC721Minter(_token)
1116 //     public
1117 //   {
1118 
1119 //   }
1120 
1121 //   function mint(bytes _sig)
1122 //     withAccess(msg.sender, 1)
1123 //     public
1124 //     returns (uint256)
1125 //   {
1126 //     return super.mint(_sig);
1127 //   }
1128 // }