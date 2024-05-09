1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
39 
40 /**
41  * @title ERC20Detailed token
42  * @dev The decimals are only for visualization purposes.
43  * All the operations are done using the smallest and indivisible token unit,
44  * just as on Ethereum all the operations are done in wei.
45  */
46 contract ERC20Detailed is IERC20 {
47   string private _name;
48   string private _symbol;
49   uint8 private _decimals;
50 
51   constructor(string name, string symbol, uint8 decimals) public {
52     _name = name;
53     _symbol = symbol;
54     _decimals = decimals;
55   }
56 
57   /**
58    * @return the name of the token.
59    */
60   function name() public view returns(string) {
61     return _name;
62   }
63 
64   /**
65    * @return the symbol of the token.
66    */
67   function symbol() public view returns(string) {
68     return _symbol;
69   }
70 
71   /**
72    * @return the number of decimals of the token.
73    */
74   function decimals() public view returns(uint8) {
75     return _decimals;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
152  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract ERC20 is IERC20 {
155   using SafeMath for uint256;
156 
157   mapping (address => uint256) private _balances;
158 
159   mapping (address => mapping (address => uint256)) private _allowed;
160 
161   uint256 private _totalSupply;
162 
163   /**
164   * @dev Total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return _totalSupply;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param owner The address to query the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address owner) public view returns (uint256) {
176     return _balances[owner];
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param owner address The address which owns the funds.
182    * @param spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address owner,
187     address spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return _allowed[owner][spender];
194   }
195 
196   /**
197   * @dev Transfer token for a specified address
198   * @param to The address to transfer to.
199   * @param value The amount to be transferred.
200   */
201   function transfer(address to, uint256 value) public returns (bool) {
202     _transfer(msg.sender, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param spender The address which will spend the funds.
213    * @param value The amount of tokens to be spent.
214    */
215   function approve(address spender, uint256 value) public returns (bool) {
216     require(spender != address(0));
217 
218     _allowed[msg.sender][spender] = value;
219     emit Approval(msg.sender, spender, value);
220     return true;
221   }
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param from address The address which you want to send tokens from
226    * @param to address The address which you want to transfer to
227    * @param value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(
230     address from,
231     address to,
232     uint256 value
233   )
234     public
235     returns (bool)
236   {
237     require(value <= _allowed[from][msg.sender]);
238 
239     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
240     _transfer(from, to, value);
241     return true;
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed_[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param spender The address which will spend the funds.
251    * @param addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseAllowance(
254     address spender,
255     uint256 addedValue
256   )
257     public
258     returns (bool)
259   {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = (
263       _allowed[msg.sender][spender].add(addedValue));
264     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseAllowance(
278     address spender,
279     uint256 subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].sub(subtractedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293   * @dev Transfer token for a specified addresses
294   * @param from The address to transfer from.
295   * @param to The address to transfer to.
296   * @param value The amount to be transferred.
297   */
298   function _transfer(address from, address to, uint256 value) internal {
299     require(value <= _balances[from]);
300     require(to != address(0));
301 
302     _balances[from] = _balances[from].sub(value);
303     _balances[to] = _balances[to].add(value);
304     emit Transfer(from, to, value);
305   }
306 
307   /**
308    * @dev Internal function that mints an amount of the token and assigns it to
309    * an account. This encapsulates the modification of balances such that the
310    * proper events are emitted.
311    * @param account The account that will receive the created tokens.
312    * @param value The amount that will be created.
313    */
314   function _mint(address account, uint256 value) internal {
315     require(account != 0);
316     _totalSupply = _totalSupply.add(value);
317     _balances[account] = _balances[account].add(value);
318     emit Transfer(address(0), account, value);
319   }
320 
321   /**
322    * @dev Internal function that burns an amount of the token of a given
323    * account.
324    * @param account The account whose tokens will be burnt.
325    * @param value The amount that will be burnt.
326    */
327   function _burn(address account, uint256 value) internal {
328     require(account != 0);
329     require(value <= _balances[account]);
330 
331     _totalSupply = _totalSupply.sub(value);
332     _balances[account] = _balances[account].sub(value);
333     emit Transfer(account, address(0), value);
334   }
335 
336   /**
337    * @dev Internal function that burns an amount of the token of a given
338    * account, deducting from the sender's allowance for said account. Uses the
339    * internal burn function.
340    * @param account The account whose tokens will be burnt.
341    * @param value The amount that will be burnt.
342    */
343   function _burnFrom(address account, uint256 value) internal {
344     require(value <= _allowed[account][msg.sender]);
345 
346     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
347     // this function needs to emit an event with the updated approval.
348     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
349       value);
350     _burn(account, value);
351   }
352 }
353 
354 // File: openzeppelin-solidity/contracts/access/Roles.sol
355 
356 /**
357  * @title Roles
358  * @dev Library for managing addresses assigned to a Role.
359  */
360 library Roles {
361   struct Role {
362     mapping (address => bool) bearer;
363   }
364 
365   /**
366    * @dev give an account access to this role
367    */
368   function add(Role storage role, address account) internal {
369     require(account != address(0));
370     require(!has(role, account));
371 
372     role.bearer[account] = true;
373   }
374 
375   /**
376    * @dev remove an account's access to this role
377    */
378   function remove(Role storage role, address account) internal {
379     require(account != address(0));
380     require(has(role, account));
381 
382     role.bearer[account] = false;
383   }
384 
385   /**
386    * @dev check if an account has this role
387    * @return bool
388    */
389   function has(Role storage role, address account)
390     internal
391     view
392     returns (bool)
393   {
394     require(account != address(0));
395     return role.bearer[account];
396   }
397 }
398 
399 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
400 
401 contract MinterRole {
402   using Roles for Roles.Role;
403 
404   event MinterAdded(address indexed account);
405   event MinterRemoved(address indexed account);
406 
407   Roles.Role private minters;
408 
409   constructor() internal {
410     _addMinter(msg.sender);
411   }
412 
413   modifier onlyMinter() {
414     require(isMinter(msg.sender));
415     _;
416   }
417 
418   function isMinter(address account) public view returns (bool) {
419     return minters.has(account);
420   }
421 
422   function addMinter(address account) public onlyMinter {
423     _addMinter(account);
424   }
425 
426   function renounceMinter() public {
427     _removeMinter(msg.sender);
428   }
429 
430   function _addMinter(address account) internal {
431     minters.add(account);
432     emit MinterAdded(account);
433   }
434 
435   function _removeMinter(address account) internal {
436     minters.remove(account);
437     emit MinterRemoved(account);
438   }
439 }
440 
441 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
442 
443 /**
444  * @title ERC20Mintable
445  * @dev ERC20 minting logic
446  */
447 contract ERC20Mintable is ERC20, MinterRole {
448   /**
449    * @dev Function to mint tokens
450    * @param to The address that will receive the minted tokens.
451    * @param value The amount of tokens to mint.
452    * @return A boolean that indicates if the operation was successful.
453    */
454   function mint(
455     address to,
456     uint256 value
457   )
458     public
459     onlyMinter
460     returns (bool)
461   {
462     _mint(to, value);
463     return true;
464   }
465 }
466 
467 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
468 
469 /**
470  * @title Capped token
471  * @dev Mintable token with a token cap.
472  */
473 contract ERC20Capped is ERC20Mintable {
474 
475   uint256 private _cap;
476 
477   constructor(uint256 cap)
478     public
479   {
480     require(cap > 0);
481     _cap = cap;
482   }
483 
484   /**
485    * @return the cap for the token minting.
486    */
487   function cap() public view returns(uint256) {
488     return _cap;
489   }
490 
491   function _mint(address account, uint256 value) internal {
492     require(totalSupply().add(value) <= _cap);
493     super._mint(account, value);
494   }
495 }
496 
497 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
498 
499 /**
500  * @title Burnable Token
501  * @dev Token that can be irreversibly burned (destroyed).
502  */
503 contract ERC20Burnable is ERC20 {
504 
505   /**
506    * @dev Burns a specific amount of tokens.
507    * @param value The amount of token to be burned.
508    */
509   function burn(uint256 value) public {
510     _burn(msg.sender, value);
511   }
512 
513   /**
514    * @dev Burns a specific amount of tokens from the target address and decrements allowance
515    * @param from address The address which you want to send tokens from
516    * @param value uint256 The amount of token to be burned
517    */
518   function burnFrom(address from, uint256 value) public {
519     _burnFrom(from, value);
520   }
521 }
522 
523 // File: openzeppelin-solidity/contracts/utils/Address.sol
524 
525 /**
526  * Utility library of inline functions on addresses
527  */
528 library Address {
529 
530   /**
531    * Returns whether the target address is a contract
532    * @dev This function will return false if invoked during the constructor of a contract,
533    * as the code is not actually created until after the constructor finishes.
534    * @param account address of the account to check
535    * @return whether the target address is a contract
536    */
537   function isContract(address account) internal view returns (bool) {
538     uint256 size;
539     // XXX Currently there is no better way to check if there is a contract in an address
540     // than to check the size of the code at that address.
541     // See https://ethereum.stackexchange.com/a/14016/36603
542     // for more details about how this works.
543     // TODO Check this again before the Serenity release, because all addresses will be
544     // contracts then.
545     // solium-disable-next-line security/no-inline-assembly
546     assembly { size := extcodesize(account) }
547     return size > 0;
548   }
549 
550 }
551 
552 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
553 
554 /**
555  * @title ERC165Checker
556  * @dev Use `using ERC165Checker for address`; to include this library
557  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
558  */
559 library ERC165Checker {
560   // As per the EIP-165 spec, no interface should ever match 0xffffffff
561   bytes4 private constant _InterfaceId_Invalid = 0xffffffff;
562 
563   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
564   /**
565    * 0x01ffc9a7 ===
566    *   bytes4(keccak256('supportsInterface(bytes4)'))
567    */
568 
569   /**
570    * @notice Query if a contract supports ERC165
571    * @param account The address of the contract to query for support of ERC165
572    * @return true if the contract at account implements ERC165
573    */
574   function _supportsERC165(address account)
575     internal
576     view
577     returns (bool)
578   {
579     // Any contract that implements ERC165 must explicitly indicate support of
580     // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
581     return _supportsERC165Interface(account, _InterfaceId_ERC165) &&
582       !_supportsERC165Interface(account, _InterfaceId_Invalid);
583   }
584 
585   /**
586    * @notice Query if a contract implements an interface, also checks support of ERC165
587    * @param account The address of the contract to query for support of an interface
588    * @param interfaceId The interface identifier, as specified in ERC-165
589    * @return true if the contract at account indicates support of the interface with
590    * identifier interfaceId, false otherwise
591    * @dev Interface identification is specified in ERC-165.
592    */
593   function _supportsInterface(address account, bytes4 interfaceId)
594     internal
595     view
596     returns (bool)
597   {
598     // query support of both ERC165 as per the spec and support of _interfaceId
599     return _supportsERC165(account) &&
600       _supportsERC165Interface(account, interfaceId);
601   }
602 
603   /**
604    * @notice Query if a contract implements interfaces, also checks support of ERC165
605    * @param account The address of the contract to query for support of an interface
606    * @param interfaceIds A list of interface identifiers, as specified in ERC-165
607    * @return true if the contract at account indicates support all interfaces in the
608    * interfaceIds list, false otherwise
609    * @dev Interface identification is specified in ERC-165.
610    */
611   function _supportsAllInterfaces(address account, bytes4[] interfaceIds)
612     internal
613     view
614     returns (bool)
615   {
616     // query support of ERC165 itself
617     if (!_supportsERC165(account)) {
618       return false;
619     }
620 
621     // query support of each interface in _interfaceIds
622     for (uint256 i = 0; i < interfaceIds.length; i++) {
623       if (!_supportsERC165Interface(account, interfaceIds[i])) {
624         return false;
625       }
626     }
627 
628     // all interfaces supported
629     return true;
630   }
631 
632   /**
633    * @notice Query if a contract implements an interface, does not check ERC165 support
634    * @param account The address of the contract to query for support of an interface
635    * @param interfaceId The interface identifier, as specified in ERC-165
636    * @return true if the contract at account indicates support of the interface with
637    * identifier interfaceId, false otherwise
638    * @dev Assumes that account contains a contract that supports ERC165, otherwise
639    * the behavior of this method is undefined. This precondition can be checked
640    * with the `supportsERC165` method in this library.
641    * Interface identification is specified in ERC-165.
642    */
643   function _supportsERC165Interface(address account, bytes4 interfaceId)
644     private
645     view
646     returns (bool)
647   {
648     // success determines whether the staticcall succeeded and result determines
649     // whether the contract at account indicates support of _interfaceId
650     (bool success, bool result) = _callERC165SupportsInterface(
651       account, interfaceId);
652 
653     return (success && result);
654   }
655 
656   /**
657    * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
658    * @param account The address of the contract to query for support of an interface
659    * @param interfaceId The interface identifier, as specified in ERC-165
660    * @return success true if the STATICCALL succeeded, false otherwise
661    * @return result true if the STATICCALL succeeded and the contract at account
662    * indicates support of the interface with identifier interfaceId, false otherwise
663    */
664   function _callERC165SupportsInterface(
665     address account,
666     bytes4 interfaceId
667   )
668     private
669     view
670     returns (bool success, bool result)
671   {
672     bytes memory encodedParams = abi.encodeWithSelector(
673       _InterfaceId_ERC165,
674       interfaceId
675     );
676 
677     // solium-disable-next-line security/no-inline-assembly
678     assembly {
679       let encodedParams_data := add(0x20, encodedParams)
680       let encodedParams_size := mload(encodedParams)
681 
682       let output := mload(0x40)  // Find empty storage location using "free memory pointer"
683       mstore(output, 0x0)
684 
685       success := staticcall(
686         30000,                 // 30k gas
687         account,              // To addr
688         encodedParams_data,
689         encodedParams_size,
690         output,
691         0x20                   // Outputs are 32 bytes long
692       )
693 
694       result := mload(output)  // Load the result
695     }
696   }
697 }
698 
699 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
700 
701 /**
702  * @title IERC165
703  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
704  */
705 interface IERC165 {
706 
707   /**
708    * @notice Query if a contract implements an interface
709    * @param interfaceId The interface identifier, as specified in ERC-165
710    * @dev Interface identification is specified in ERC-165. This function
711    * uses less than 30,000 gas.
712    */
713   function supportsInterface(bytes4 interfaceId)
714     external
715     view
716     returns (bool);
717 }
718 
719 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
720 
721 /**
722  * @title ERC165
723  * @author Matt Condon (@shrugs)
724  * @dev Implements ERC165 using a lookup table.
725  */
726 contract ERC165 is IERC165 {
727 
728   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
729   /**
730    * 0x01ffc9a7 ===
731    *   bytes4(keccak256('supportsInterface(bytes4)'))
732    */
733 
734   /**
735    * @dev a mapping of interface id to whether or not it's supported
736    */
737   mapping(bytes4 => bool) private _supportedInterfaces;
738 
739   /**
740    * @dev A contract implementing SupportsInterfaceWithLookup
741    * implement ERC165 itself
742    */
743   constructor()
744     internal
745   {
746     _registerInterface(_InterfaceId_ERC165);
747   }
748 
749   /**
750    * @dev implement supportsInterface(bytes4) using a lookup table
751    */
752   function supportsInterface(bytes4 interfaceId)
753     external
754     view
755     returns (bool)
756   {
757     return _supportedInterfaces[interfaceId];
758   }
759 
760   /**
761    * @dev internal method for registering an interface
762    */
763   function _registerInterface(bytes4 interfaceId)
764     internal
765   {
766     require(interfaceId != 0xffffffff);
767     _supportedInterfaces[interfaceId] = true;
768   }
769 }
770 
771 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
772 
773 /**
774  * @title IERC1363 Interface
775  * @author Vittorio Minacori (https://github.com/vittominacori)
776  * @dev Interface for a Payable Token contract as defined in
777  *  https://github.com/ethereum/EIPs/issues/1363
778  */
779 contract IERC1363 is IERC20, ERC165 {
780   /*
781    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
782    * 0x4bbee2df ===
783    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
784    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
785    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
786    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
787    */
788 
789   /*
790    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
791    * 0xfb9ec8ce ===
792    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
793    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
794    */
795 
796   /**
797    * @notice Transfer tokens from `msg.sender` to another address
798    *  and then call `onTransferReceived` on receiver
799    * @param to address The address which you want to transfer to
800    * @param value uint256 The amount of tokens to be transferred
801    * @return true unless throwing
802    */
803   function transferAndCall(address to, uint256 value) public returns (bool);
804 
805   /**
806    * @notice Transfer tokens from `msg.sender` to another address
807    *  and then call `onTransferReceived` on receiver
808    * @param to address The address which you want to transfer to
809    * @param value uint256 The amount of tokens to be transferred
810    * @param data bytes Additional data with no specified format, sent in call to `to`
811    * @return true unless throwing
812    */
813   function transferAndCall(address to, uint256 value, bytes data) public returns (bool); // solium-disable-line max-len
814 
815   /**
816    * @notice Transfer tokens from one address to another
817    *  and then call `onTransferReceived` on receiver
818    * @param from address The address which you want to send tokens from
819    * @param to address The address which you want to transfer to
820    * @param value uint256 The amount of tokens to be transferred
821    * @return true unless throwing
822    */
823   function transferFromAndCall(address from, address to, uint256 value) public returns (bool); // solium-disable-line max-len
824 
825 
826   /**
827    * @notice Transfer tokens from one address to another
828    *  and then call `onTransferReceived` on receiver
829    * @param from address The address which you want to send tokens from
830    * @param to address The address which you want to transfer to
831    * @param value uint256 The amount of tokens to be transferred
832    * @param data bytes Additional data with no specified format, sent in call to `to`
833    * @return true unless throwing
834    */
835   function transferFromAndCall(address from, address to, uint256 value, bytes data) public returns (bool); // solium-disable-line max-len, arg-overflow
836 
837   /**
838    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
839    *  and then call `onApprovalReceived` on spender
840    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
841    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
842    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
843    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
844    * @param spender address The address which will spend the funds
845    * @param value uint256 The amount of tokens to be spent
846    */
847   function approveAndCall(address spender, uint256 value) public returns (bool); // solium-disable-line max-len
848 
849   /**
850    * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
851    *  and then call `onApprovalReceived` on spender
852    *  Beware that changing an allowance with this method brings the risk that someone may use both the old
853    *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
854    *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
855    *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
856    * @param spender address The address which will spend the funds
857    * @param value uint256 The amount of tokens to be spent
858    * @param data bytes Additional data with no specified format, sent in call to `spender`
859    */
860   function approveAndCall(address spender, uint256 value, bytes data) public returns (bool); // solium-disable-line max-len
861 }
862 
863 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
864 
865 /**
866  * @title IERC1363Receiver Interface
867  * @author Vittorio Minacori (https://github.com/vittominacori)
868  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
869  *  from ERC1363 token contracts as defined in
870  *  https://github.com/ethereum/EIPs/issues/1363
871  */
872 contract IERC1363Receiver {
873   /*
874    * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
875    * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
876    */
877 
878   /**
879    * @notice Handle the receipt of ERC1363 tokens
880    * @dev Any ERC1363 smart contract calls this function on the recipient
881    *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
882    *  transfer. Return of other than the magic value MUST result in the
883    *  transaction being reverted.
884    *  Note: the token contract address is always the message sender.
885    * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
886    * @param from address The address which are token transferred from
887    * @param value uint256 The amount of tokens transferred
888    * @param data bytes Additional data with no specified format
889    * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
890    *  unless throwing
891    */
892   function onTransferReceived(address operator, address from, uint256 value, bytes data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
893 }
894 
895 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
896 
897 /**
898  * @title IERC1363Spender Interface
899  * @author Vittorio Minacori (https://github.com/vittominacori)
900  * @dev Interface for any contract that wants to support approveAndCall
901  *  from ERC1363 token contracts as defined in
902  *  https://github.com/ethereum/EIPs/issues/1363
903  */
904 contract IERC1363Spender {
905   /*
906    * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
907    * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
908    */
909 
910   /**
911    * @notice Handle the approval of ERC1363 tokens
912    * @dev Any ERC1363 smart contract calls this function on the recipient
913    *  after an `approve`. This function MAY throw to revert and reject the
914    *  approval. Return of other than the magic value MUST result in the
915    *  transaction being reverted.
916    *  Note: the token contract address is always the message sender.
917    * @param owner address The address which called `approveAndCall` function
918    * @param value uint256 The amount of tokens to be spent
919    * @param data bytes Additional data with no specified format
920    * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
921    *  unless throwing
922    */
923   function onApprovalReceived(address owner, uint256 value, bytes data) external returns (bytes4); // solium-disable-line max-len
924 }
925 
926 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
927 
928 /**
929  * @title ERC1363
930  * @author Vittorio Minacori (https://github.com/vittominacori)
931  * @dev Implementation of an ERC1363 interface
932  */
933 contract ERC1363 is ERC20, IERC1363 { // solium-disable-line max-len
934   using Address for address;
935 
936   /*
937    * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
938    * 0x4bbee2df ===
939    *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
940    *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
941    *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
942    *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
943    */
944   bytes4 internal constant _InterfaceId_ERC1363Transfer = 0x4bbee2df;
945 
946   /*
947    * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
948    * 0xfb9ec8ce ===
949    *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
950    *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
951    */
952   bytes4 internal constant _InterfaceId_ERC1363Approve = 0xfb9ec8ce;
953 
954   // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
955   // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
956   bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
957 
958   // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
959   // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
960   bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
961 
962   constructor() public {
963     // register the supported interfaces to conform to ERC1363 via ERC165
964     _registerInterface(_InterfaceId_ERC1363Transfer);
965     _registerInterface(_InterfaceId_ERC1363Approve);
966   }
967 
968   function transferAndCall(
969     address to,
970     uint256 value
971   )
972     public
973     returns (bool)
974   {
975     return transferAndCall(to, value, "");
976   }
977 
978   function transferAndCall(
979     address to,
980     uint256 value,
981     bytes data
982   )
983     public
984     returns (bool)
985   {
986     require(transfer(to, value));
987     require(
988       _checkAndCallTransfer(
989         msg.sender,
990         to,
991         value,
992         data
993       )
994     );
995     return true;
996   }
997 
998   function transferFromAndCall(
999     address from,
1000     address to,
1001     uint256 value
1002   )
1003     public
1004     returns (bool)
1005   {
1006     // solium-disable-next-line arg-overflow
1007     return transferFromAndCall(from, to, value, "");
1008   }
1009 
1010   function transferFromAndCall(
1011     address from,
1012     address to,
1013     uint256 value,
1014     bytes data
1015   )
1016     public
1017     returns (bool)
1018   {
1019     require(transferFrom(from, to, value));
1020     require(
1021       _checkAndCallTransfer(
1022         from,
1023         to,
1024         value,
1025         data
1026       )
1027     );
1028     return true;
1029   }
1030 
1031   function approveAndCall(
1032     address spender,
1033     uint256 value
1034   )
1035     public
1036     returns (bool)
1037   {
1038     return approveAndCall(spender, value, "");
1039   }
1040 
1041   function approveAndCall(
1042     address spender,
1043     uint256 value,
1044     bytes data
1045   )
1046     public
1047     returns (bool)
1048   {
1049     approve(spender, value);
1050     require(
1051       _checkAndCallApprove(
1052         spender,
1053         value,
1054         data
1055       )
1056     );
1057     return true;
1058   }
1059 
1060   /**
1061    * @dev Internal function to invoke `onTransferReceived` on a target address
1062    *  The call is not executed if the target address is not a contract
1063    * @param from address Representing the previous owner of the given token value
1064    * @param to address Target address that will receive the tokens
1065    * @param value uint256 The amount mount of tokens to be transferred
1066    * @param data bytes Optional data to send along with the call
1067    * @return whether the call correctly returned the expected magic value
1068    */
1069   function _checkAndCallTransfer(
1070     address from,
1071     address to,
1072     uint256 value,
1073     bytes data
1074   )
1075     internal
1076     returns (bool)
1077   {
1078     if (!to.isContract()) {
1079       return false;
1080     }
1081     bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1082       msg.sender, from, value, data
1083     );
1084     return (retval == _ERC1363_RECEIVED);
1085   }
1086 
1087   /**
1088    * @dev Internal function to invoke `onApprovalReceived` on a target address
1089    *  The call is not executed if the target address is not a contract
1090    * @param spender address The address which will spend the funds
1091    * @param value uint256 The amount of tokens to be spent
1092    * @param data bytes Optional data to send along with the call
1093    * @return whether the call correctly returned the expected magic value
1094    */
1095   function _checkAndCallApprove(
1096     address spender,
1097     uint256 value,
1098     bytes data
1099   )
1100     internal
1101     returns (bool)
1102   {
1103     if (!spender.isContract()) {
1104       return false;
1105     }
1106     bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1107       msg.sender, value, data
1108     );
1109     return (retval == _ERC1363_APPROVED);
1110   }
1111 }
1112 
1113 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
1114 
1115 /**
1116  * @title Ownable
1117  * @dev The Ownable contract has an owner address, and provides basic authorization control
1118  * functions, this simplifies the implementation of "user permissions".
1119  */
1120 contract Ownable {
1121   address private _owner;
1122 
1123   event OwnershipTransferred(
1124     address indexed previousOwner,
1125     address indexed newOwner
1126   );
1127 
1128   /**
1129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1130    * account.
1131    */
1132   constructor() internal {
1133     _owner = msg.sender;
1134     emit OwnershipTransferred(address(0), _owner);
1135   }
1136 
1137   /**
1138    * @return the address of the owner.
1139    */
1140   function owner() public view returns(address) {
1141     return _owner;
1142   }
1143 
1144   /**
1145    * @dev Throws if called by any account other than the owner.
1146    */
1147   modifier onlyOwner() {
1148     require(isOwner());
1149     _;
1150   }
1151 
1152   /**
1153    * @return true if `msg.sender` is the owner of the contract.
1154    */
1155   function isOwner() public view returns(bool) {
1156     return msg.sender == _owner;
1157   }
1158 
1159   /**
1160    * @dev Allows the current owner to relinquish control of the contract.
1161    * @notice Renouncing to ownership will leave the contract without an owner.
1162    * It will not be possible to call the functions with the `onlyOwner`
1163    * modifier anymore.
1164    */
1165   function renounceOwnership() public onlyOwner {
1166     emit OwnershipTransferred(_owner, address(0));
1167     _owner = address(0);
1168   }
1169 
1170   /**
1171    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1172    * @param newOwner The address to transfer ownership to.
1173    */
1174   function transferOwnership(address newOwner) public onlyOwner {
1175     _transferOwnership(newOwner);
1176   }
1177 
1178   /**
1179    * @dev Transfers control of the contract to a newOwner.
1180    * @param newOwner The address to transfer ownership to.
1181    */
1182   function _transferOwnership(address newOwner) internal {
1183     require(newOwner != address(0));
1184     emit OwnershipTransferred(_owner, newOwner);
1185     _owner = newOwner;
1186   }
1187 }
1188 
1189 // File: eth-token-recover/contracts/TokenRecover.sol
1190 
1191 /**
1192  * @title TokenRecover
1193  * @author Vittorio Minacori (https://github.com/vittominacori)
1194  * @dev Allow to recover any ERC20 sent into the contract for error
1195  */
1196 contract TokenRecover is Ownable {
1197 
1198   /**
1199    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1200    * @param tokenAddress The token contract address
1201    * @param tokenAmount Number of tokens to be sent
1202    */
1203   function recoverERC20(
1204     address tokenAddress,
1205     uint256 tokenAmount
1206   )
1207     public
1208     onlyOwner
1209   {
1210     IERC20(tokenAddress).transfer(owner(), tokenAmount);
1211   }
1212 }
1213 
1214 // File: contracts/access/roles/OperatorRole.sol
1215 
1216 contract OperatorRole {
1217   using Roles for Roles.Role;
1218 
1219   event OperatorAdded(address indexed account);
1220   event OperatorRemoved(address indexed account);
1221 
1222   Roles.Role private _operators;
1223 
1224   constructor() internal {
1225     _addOperator(msg.sender);
1226   }
1227 
1228   modifier onlyOperator() {
1229     require(isOperator(msg.sender));
1230     _;
1231   }
1232 
1233   function isOperator(address account) public view returns (bool) {
1234     return _operators.has(account);
1235   }
1236 
1237   function addOperator(address account) public onlyOperator {
1238     _addOperator(account);
1239   }
1240 
1241   function renounceOperator() public {
1242     _removeOperator(msg.sender);
1243   }
1244 
1245   function _addOperator(address account) internal {
1246     _operators.add(account);
1247     emit OperatorAdded(account);
1248   }
1249 
1250   function _removeOperator(address account) internal {
1251     _operators.remove(account);
1252     emit OperatorRemoved(account);
1253   }
1254 }
1255 
1256 // File: contracts/token/BaseToken.sol
1257 
1258 /**
1259  * @title BaseToken
1260  * @author Vittorio Minacori (https://github.com/vittominacori)
1261  * @dev Implementation of the BaseToken
1262  */
1263 contract BaseToken is ERC20Detailed, ERC20Capped, ERC20Burnable, ERC1363, OperatorRole, TokenRecover {
1264 
1265   event MintFinished();
1266   event TransferEnabled();
1267 
1268   // indicates if minting is finished
1269   bool private _mintingFinished = false;
1270 
1271   // indicates if transfer is enabled
1272   bool private _transferEnabled = false;
1273 
1274   /**
1275    * @dev Tokens can be minted only before minting finished
1276    */
1277   modifier canMint() {
1278     require(!_mintingFinished);
1279     _;
1280   }
1281 
1282   /**
1283    * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator
1284    */
1285   modifier canTransfer(address from) {
1286     require(_transferEnabled || isOperator(from));
1287     _;
1288   }
1289 
1290   /**
1291    * @param name Name of the token
1292    * @param symbol A symbol to be used as ticker
1293    * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1294    * @param cap Maximum number of tokens mintable
1295    * @param initialSupply Initial token supply
1296    */
1297   constructor(
1298     string name,
1299     string symbol,
1300     uint8 decimals,
1301     uint256 cap,
1302     uint256 initialSupply
1303   )
1304     ERC20Detailed(name, symbol, decimals)
1305     ERC20Capped(cap)
1306     public
1307   {
1308     if (initialSupply > 0) {
1309       _mint(owner(), initialSupply);
1310     }
1311   }
1312 
1313   /**
1314    * @return if minting is finished or not
1315    */
1316   function mintingFinished() public view returns (bool) {
1317     return _mintingFinished;
1318   }
1319 
1320   /**
1321    * @return if transfer is enabled or not
1322    */
1323   function transferEnabled() public view returns (bool) {
1324     return _transferEnabled;
1325   }
1326 
1327   function mint(address to, uint256 value) public canMint returns (bool) {
1328     return super.mint(to, value);
1329   }
1330 
1331   function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
1332     return super.transfer(to, value);
1333   }
1334 
1335   function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
1336     return super.transferFrom(from, to, value);
1337   }
1338 
1339   /**
1340    * @dev Function to stop minting new tokens
1341    */
1342   function finishMinting() public onlyOwner canMint {
1343     _mintingFinished = true;
1344     _transferEnabled = true;
1345 
1346     emit MintFinished();
1347     emit TransferEnabled();
1348   }
1349 
1350   /**
1351  * @dev Function to enable transfers.
1352  */
1353   function enableTransfer() public onlyOwner {
1354     _transferEnabled = true;
1355 
1356     emit TransferEnabled();
1357   }
1358 
1359   /**
1360    * @dev remove the `operator` role from address
1361    * @param account Address you want to remove role
1362    */
1363   function removeOperator(address account) public onlyOwner {
1364     _removeOperator(account);
1365   }
1366 
1367   /**
1368    * @dev remove the `minter` role from address
1369    * @param account Address you want to remove role
1370    */
1371   function removeMinter(address account) public onlyOwner {
1372     _removeMinter(account);
1373   }
1374 }
1375 
1376 // File: contracts/token/ShakaToken.sol
1377 
1378 /**
1379  * @title ShakaToken
1380  * @author Vittorio Minacori (https://github.com/vittominacori)
1381  * @dev Implementation of the Shaka Token
1382  */
1383 contract ShakaToken is BaseToken {
1384 
1385   /**
1386    * @param name Name of the token
1387    * @param symbol A symbol to be used as ticker
1388    * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1389    * @param cap Maximum number of tokens mintable
1390    * @param initialSupply Initial token supply
1391    */
1392   constructor(
1393     string name,
1394     string symbol,
1395     uint8 decimals,
1396     uint256 cap,
1397     uint256 initialSupply
1398   )
1399     BaseToken(
1400       name,
1401       symbol,
1402       decimals,
1403       cap,
1404       initialSupply
1405     )
1406     public
1407   {}
1408 }