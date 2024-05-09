1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.4.24;
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
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 pragma solidity ^0.4.24;
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that revert on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, reverts on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     uint256 c = a * b;
60     require(c / a == b);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b > 0); // Solidity only automatically asserts when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72 
73     return c;
74   }
75 
76   /**
77   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80     require(b <= a);
81     uint256 c = a - b;
82 
83     return c;
84   }
85 
86   /**
87   * @dev Adds two numbers, reverts on overflow.
88   */
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     require(c >= a);
92 
93     return c;
94   }
95 
96   /**
97   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
98   * reverts when dividing by zero.
99   */
100   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
101     require(b != 0);
102     return a % b;
103   }
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
107 
108 pragma solidity ^0.4.24;
109 
110 
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
117  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract ERC20 is IERC20 {
120   using SafeMath for uint256;
121 
122   mapping (address => uint256) private _balances;
123 
124   mapping (address => mapping (address => uint256)) private _allowed;
125 
126   uint256 private _totalSupply;
127 
128   /**
129   * @dev Total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return _totalSupply;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param owner The address to query the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address owner) public view returns (uint256) {
141     return _balances[owner];
142   }
143 
144   /**
145    * @dev Function to check the amount of tokens that an owner allowed to a spender.
146    * @param owner address The address which owns the funds.
147    * @param spender address The address which will spend the funds.
148    * @return A uint256 specifying the amount of tokens still available for the spender.
149    */
150   function allowance(
151     address owner,
152     address spender
153    )
154     public
155     view
156     returns (uint256)
157   {
158     return _allowed[owner][spender];
159   }
160 
161   /**
162   * @dev Transfer token for a specified address
163   * @param to The address to transfer to.
164   * @param value The amount to be transferred.
165   */
166   function transfer(address to, uint256 value) public returns (bool) {
167     _transfer(msg.sender, to, value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param spender The address which will spend the funds.
178    * @param value The amount of tokens to be spent.
179    */
180   function approve(address spender, uint256 value) public returns (bool) {
181     require(spender != address(0));
182 
183     _allowed[msg.sender][spender] = value;
184     emit Approval(msg.sender, spender, value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param from address The address which you want to send tokens from
191    * @param to address The address which you want to transfer to
192    * @param value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address from,
196     address to,
197     uint256 value
198   )
199     public
200     returns (bool)
201   {
202     require(value <= _allowed[from][msg.sender]);
203 
204     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
205     _transfer(from, to, value);
206     return true;
207   }
208 
209   /**
210    * @dev Increase the amount of tokens that an owner allowed to a spender.
211    * approve should be called when allowed_[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param spender The address which will spend the funds.
216    * @param addedValue The amount of tokens to increase the allowance by.
217    */
218   function increaseAllowance(
219     address spender,
220     uint256 addedValue
221   )
222     public
223     returns (bool)
224   {
225     require(spender != address(0));
226 
227     _allowed[msg.sender][spender] = (
228       _allowed[msg.sender][spender].add(addedValue));
229     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    * approve should be called when allowed_[_spender] == 0. To decrement
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param spender The address which will spend the funds.
240    * @param subtractedValue The amount of tokens to decrease the allowance by.
241    */
242   function decreaseAllowance(
243     address spender,
244     uint256 subtractedValue
245   )
246     public
247     returns (bool)
248   {
249     require(spender != address(0));
250 
251     _allowed[msg.sender][spender] = (
252       _allowed[msg.sender][spender].sub(subtractedValue));
253     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
254     return true;
255   }
256 
257   /**
258   * @dev Transfer token for a specified addresses
259   * @param from The address to transfer from.
260   * @param to The address to transfer to.
261   * @param value The amount to be transferred.
262   */
263   function _transfer(address from, address to, uint256 value) internal {
264     require(value <= _balances[from]);
265     require(to != address(0));
266 
267     _balances[from] = _balances[from].sub(value);
268     _balances[to] = _balances[to].add(value);
269     emit Transfer(from, to, value);
270   }
271 
272   /**
273    * @dev Internal function that mints an amount of the token and assigns it to
274    * an account. This encapsulates the modification of balances such that the
275    * proper events are emitted.
276    * @param account The account that will receive the created tokens.
277    * @param value The amount that will be created.
278    */
279   function _mint(address account, uint256 value) internal {
280     require(account != 0);
281     _totalSupply = _totalSupply.add(value);
282     _balances[account] = _balances[account].add(value);
283     emit Transfer(address(0), account, value);
284   }
285 
286   /**
287    * @dev Internal function that burns an amount of the token of a given
288    * account.
289    * @param account The account whose tokens will be burnt.
290    * @param value The amount that will be burnt.
291    */
292   function _burn(address account, uint256 value) internal {
293     require(account != 0);
294     require(value <= _balances[account]);
295 
296     _totalSupply = _totalSupply.sub(value);
297     _balances[account] = _balances[account].sub(value);
298     emit Transfer(account, address(0), value);
299   }
300 
301   /**
302    * @dev Internal function that burns an amount of the token of a given
303    * account, deducting from the sender's allowance for said account. Uses the
304    * internal burn function.
305    * @param account The account whose tokens will be burnt.
306    * @param value The amount that will be burnt.
307    */
308   function _burnFrom(address account, uint256 value) internal {
309     require(value <= _allowed[account][msg.sender]);
310 
311     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
312     // this function needs to emit an event with the updated approval.
313     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
314       value);
315     _burn(account, value);
316   }
317 }
318 
319 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
320 
321 pragma solidity ^0.4.24;
322 
323 
324 /**
325  * @title Burnable Token
326  * @dev Token that can be irreversibly burned (destroyed).
327  */
328 contract ERC20Burnable is ERC20 {
329 
330   /**
331    * @dev Burns a specific amount of tokens.
332    * @param value The amount of token to be burned.
333    */
334   function burn(uint256 value) public {
335     _burn(msg.sender, value);
336   }
337 
338   /**
339    * @dev Burns a specific amount of tokens from the target address and decrements allowance
340    * @param from address The address which you want to send tokens from
341    * @param value uint256 The amount of token to be burned
342    */
343   function burnFrom(address from, uint256 value) public {
344     _burnFrom(from, value);
345   }
346 }
347 
348 // File: openzeppelin-solidity/contracts/access/Roles.sol
349 
350 pragma solidity ^0.4.24;
351 
352 /**
353  * @title Roles
354  * @dev Library for managing addresses assigned to a Role.
355  */
356 library Roles {
357   struct Role {
358     mapping (address => bool) bearer;
359   }
360 
361   /**
362    * @dev give an account access to this role
363    */
364   function add(Role storage role, address account) internal {
365     require(account != address(0));
366     require(!has(role, account));
367 
368     role.bearer[account] = true;
369   }
370 
371   /**
372    * @dev remove an account's access to this role
373    */
374   function remove(Role storage role, address account) internal {
375     require(account != address(0));
376     require(has(role, account));
377 
378     role.bearer[account] = false;
379   }
380 
381   /**
382    * @dev check if an account has this role
383    * @return bool
384    */
385   function has(Role storage role, address account)
386     internal
387     view
388     returns (bool)
389   {
390     require(account != address(0));
391     return role.bearer[account];
392   }
393 }
394 
395 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
396 
397 pragma solidity ^0.4.24;
398 
399 
400 contract MinterRole {
401   using Roles for Roles.Role;
402 
403   event MinterAdded(address indexed account);
404   event MinterRemoved(address indexed account);
405 
406   Roles.Role private minters;
407 
408   constructor() internal {
409     _addMinter(msg.sender);
410   }
411 
412   modifier onlyMinter() {
413     require(isMinter(msg.sender));
414     _;
415   }
416 
417   function isMinter(address account) public view returns (bool) {
418     return minters.has(account);
419   }
420 
421   function addMinter(address account) public onlyMinter {
422     _addMinter(account);
423   }
424 
425   function renounceMinter() public {
426     _removeMinter(msg.sender);
427   }
428 
429   function _addMinter(address account) internal {
430     minters.add(account);
431     emit MinterAdded(account);
432   }
433 
434   function _removeMinter(address account) internal {
435     minters.remove(account);
436     emit MinterRemoved(account);
437   }
438 }
439 
440 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
441 
442 pragma solidity ^0.4.24;
443 
444 
445 
446 /**
447  * @title ERC20Mintable
448  * @dev ERC20 minting logic
449  */
450 contract ERC20Mintable is ERC20, MinterRole {
451   /**
452    * @dev Function to mint tokens
453    * @param to The address that will receive the minted tokens.
454    * @param value The amount of tokens to mint.
455    * @return A boolean that indicates if the operation was successful.
456    */
457   function mint(
458     address to,
459     uint256 value
460   )
461     public
462     onlyMinter
463     returns (bool)
464   {
465     _mint(to, value);
466     return true;
467   }
468 }
469 
470 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
471 
472 pragma solidity ^0.4.24;
473 
474 
475 /**
476  * @title ERC20Detailed token
477  * @dev The decimals are only for visualization purposes.
478  * All the operations are done using the smallest and indivisible token unit,
479  * just as on Ethereum all the operations are done in wei.
480  */
481 contract ERC20Detailed is IERC20 {
482   string private _name;
483   string private _symbol;
484   uint8 private _decimals;
485 
486   constructor(string name, string symbol, uint8 decimals) public {
487     _name = name;
488     _symbol = symbol;
489     _decimals = decimals;
490   }
491 
492   /**
493    * @return the name of the token.
494    */
495   function name() public view returns(string) {
496     return _name;
497   }
498 
499   /**
500    * @return the symbol of the token.
501    */
502   function symbol() public view returns(string) {
503     return _symbol;
504   }
505 
506   /**
507    * @return the number of decimals of the token.
508    */
509   function decimals() public view returns(uint8) {
510     return _decimals;
511   }
512 }
513 
514 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
515 
516 pragma solidity ^0.4.24;
517 
518 /**
519  * @title Ownable
520  * @dev The Ownable contract has an owner address, and provides basic authorization control
521  * functions, this simplifies the implementation of "user permissions".
522  */
523 contract Ownable {
524   address private _owner;
525 
526   event OwnershipTransferred(
527     address indexed previousOwner,
528     address indexed newOwner
529   );
530 
531   /**
532    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
533    * account.
534    */
535   constructor() internal {
536     _owner = msg.sender;
537     emit OwnershipTransferred(address(0), _owner);
538   }
539 
540   /**
541    * @return the address of the owner.
542    */
543   function owner() public view returns(address) {
544     return _owner;
545   }
546 
547   /**
548    * @dev Throws if called by any account other than the owner.
549    */
550   modifier onlyOwner() {
551     require(isOwner());
552     _;
553   }
554 
555   /**
556    * @return true if `msg.sender` is the owner of the contract.
557    */
558   function isOwner() public view returns(bool) {
559     return msg.sender == _owner;
560   }
561 
562   /**
563    * @dev Allows the current owner to relinquish control of the contract.
564    * @notice Renouncing to ownership will leave the contract without an owner.
565    * It will not be possible to call the functions with the `onlyOwner`
566    * modifier anymore.
567    */
568   function renounceOwnership() public onlyOwner {
569     emit OwnershipTransferred(_owner, address(0));
570     _owner = address(0);
571   }
572 
573   /**
574    * @dev Allows the current owner to transfer control of the contract to a newOwner.
575    * @param newOwner The address to transfer ownership to.
576    */
577   function transferOwnership(address newOwner) public onlyOwner {
578     _transferOwnership(newOwner);
579   }
580 
581   /**
582    * @dev Transfers control of the contract to a newOwner.
583    * @param newOwner The address to transfer ownership to.
584    */
585   function _transferOwnership(address newOwner) internal {
586     require(newOwner != address(0));
587     emit OwnershipTransferred(_owner, newOwner);
588     _owner = newOwner;
589   }
590 }
591 
592 // File: contracts/ERC677.sol
593 
594 pragma solidity 0.4.24;
595 
596 
597 
598 contract ERC677 is ERC20 {
599     event Transfer(address indexed from, address indexed to, uint value, bytes data);
600 
601     function transferAndCall(address, uint, bytes) external returns (bool);
602 
603 }
604 
605 // File: contracts/IBurnableMintableERC677Token.sol
606 
607 pragma solidity 0.4.24;
608 
609 
610 
611 contract IBurnableMintableERC677Token is ERC677 {
612     function mint(address, uint256) public returns (bool);
613     function burn(uint256 _value) public;
614     function claimTokens(address _token, address _to) public;
615 }
616 
617 // File: contracts/ERC865.sol
618 
619 pragma solidity 0.4.24;
620 
621 
622 contract ERC865 is ERC20 {
623     mapping(bytes32 => bool) hashedTxs;
624 
625     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
626     event TransferAndCallPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, bytes data, uint256 fee);
627 
628     /**
629      * @param _signature bytes The signature, issued by the owner.
630      * @param _to address The address which you want to transfer to.
631      * @param _value uint256 The amount of tokens to be transferred.
632      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
633      * @param _timestamp uint256 Timestamp of transaction, for uniqueness.
634      */
635     function transferPreSigned(bytes _signature, address _to, uint256 _value, uint256 _fee, uint256 _timestamp) public returns (bool);
636 
637     /**
638      * @param _signature bytes The signature, issued by the owner.
639      * @param _to address The address which you want to transfer to.
640      * @param _value uint256 The amount of tokens to be transferred.
641      * @param _data bytes The data which enables the pass additional params.
642      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
643      * @param _timestamp uint256 Timestamp of transaction, for uniqueness.
644      */
645     function transferAndCallPreSigned(bytes _signature, address _to, uint256 _value, bytes _data, uint256 _fee, uint256 _timestamp) public returns (bool);
646 
647     /**
648      * @param _token address The address of the token.
649      * @param _to address The address which you want to transfer to.
650      * @param _value uint256 The amount of tokens to be transferred.
651      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
652      * @param _timestamp uint256 Timestamp of transaction, for uniqueness.
653      */
654     function getTransferPreSignedHash(address _token, address _to, uint256 _value, uint256 _fee, uint256 _timestamp) public pure returns (bytes32);
655 
656     /**
657      * @param _token address The address of the token.
658      * @param _to address The address which you want to transfer to.
659      * @param _value uint256 The amount of tokens to be transferred.
660      * @param _data bytes The data which enables the pass additional params
661      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
662      * @param _timestamp uint256 Timestamp of transaction, for uniqueness.
663      */
664     function getTransferAndCallPreSignedHash(address _token, address _to, uint256 _value, bytes _data, uint256 _fee, uint256 _timestamp) public pure returns (bytes32);
665 }
666 
667 // File: contracts/ERC677Receiver.sol
668 
669 pragma solidity 0.4.24;
670 
671 
672 contract ERC677Receiver {
673   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
674 }
675 
676 // File: contracts/IBridgeValidators.sol
677 
678 pragma solidity 0.4.24;
679 
680 interface IBridgeValidators {
681     function initialize(uint256 _requiredSignatures, address[] _initialValidators, address _owner) public returns(bool);
682     function isValidator(address _validator) public view returns(bool);
683     function requiredSignatures() public view returns(uint256);
684     function owner() public view returns(address);
685 }
686 
687 // File: contracts/IForeignBridgeValidators.sol
688 
689 pragma solidity 0.4.24;
690 
691 interface IForeignBridgeValidators {
692     function isValidator(address _validator) public view returns(bool);
693     function requiredSignatures() public view returns(uint256);
694     function setValidators(address[] _validators) public returns(bool);
695 }
696 
697 // File: contracts/libraries/Message.sol
698 
699 pragma solidity 0.4.24;
700 
701 
702 
703 
704 library Message {
705     function addressArrayContains(address[] array, address value) internal pure returns (bool) {
706         for (uint256 i = 0; i < array.length; i++) {
707             if (array[i] == value) {
708                 return true;
709             }
710         }
711         return false;
712     }
713     // layout of message :: bytes:
714     // offset  0: 32 bytes :: uint256 - message length
715     // offset 32: 20 bytes :: address - recipient address
716     // offset 52: 32 bytes :: uint256 - value
717     // offset 84: 32 bytes :: bytes32 - transaction hash
718     // offset 104: 20 bytes :: address - contract address to prevent double spending
719 
720     // bytes 1 to 32 are 0 because message length is stored as little endian.
721     // mload always reads 32 bytes.
722     // so we can and have to start reading recipient at offset 20 instead of 32.
723     // if we were to read at 32 the address would contain part of value and be corrupted.
724     // when reading from offset 20 mload will read 12 zero bytes followed
725     // by the 20 recipient address bytes and correctly convert it into an address.
726     // this saves some storage/gas over the alternative solution
727     // which is padding address to 32 bytes and reading recipient at offset 32.
728     // for more details see discussion in:
729     // https://github.com/paritytech/parity-bridge/issues/61
730     function parseMessage(bytes message)
731         internal
732         pure
733         returns(address recipient, uint256 amount, bytes32 txHash, address contractAddress)
734     {
735         require(isMessageValid(message));
736         assembly {
737             recipient := and(mload(add(message, 20)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
738             amount := mload(add(message, 52))
739             txHash := mload(add(message, 84))
740             contractAddress := mload(add(message, 104))
741         }
742     }
743 
744     function parseNewSetMessage(bytes message)
745         internal
746         returns(address[] memory newSet, bytes32 txHash, address contractAddress)
747     {
748         uint256 msgLength;
749         uint256 position;
750         address newSetMember;
751         assembly {
752             msgLength := mload(message)
753             txHash := mload(add(message, 32))
754             contractAddress := mload(add(message, 52))
755             position := 72
756         }
757         uint256 newSetLength = (msgLength - position) / 20 + 1;
758         newSet = new address[](newSetLength);
759         uint256 i = 0;
760         while (position <= msgLength) {
761             assembly {
762                 newSetMember := mload(add(message, position))
763             }
764             newSet[i] = newSetMember;
765             position += 20;
766             i++;
767         }
768         return (newSet, txHash, contractAddress);
769     }
770 
771     function isMessageValid(bytes _msg) internal pure returns(bool) {
772         return _msg.length == requiredMessageLength();
773     }
774 
775     function requiredMessageLength() internal pure returns(uint256) {
776         return 104;
777     }
778 
779     function recoverAddressFromSignedMessage(bytes signature, bytes message, bool knownLength) internal pure returns (address) {
780         require(signature.length == 65);
781         bytes32 r;
782         bytes32 s;
783         bytes1 v;
784         // solium-disable-next-line security/no-inline-assembly
785         assembly {
786             r := mload(add(signature, 0x20))
787             s := mload(add(signature, 0x40))
788             v := mload(add(signature, 0x60))
789         }
790         if (knownLength) {
791             return ecrecover(hashMessage(message), uint8(v), r, s);
792         } else {
793             return ecrecover(hashMessageOfUnknownLength(message), uint8(v), r, s);
794         }
795     }
796 
797     function hashMessage(bytes message) internal pure returns (bytes32) {
798         bytes memory prefix = "\x19Ethereum Signed Message:\n";
799         // message is always 84 length
800         string memory msgLength = "104";
801         return keccak256(abi.encodePacked(prefix, msgLength, message));
802     }
803 
804     function hashMessageOfUnknownLength(bytes message) internal pure returns (bytes32) {
805         bytes memory prefix = "\x19Ethereum Signed Message:\n";
806         uint256 lengthOffset;
807         uint256 length;
808         assembly {
809           // The first word of a string is its length
810           length := mload(message)
811           // The beginning of the base-10 message length in the prefix
812           lengthOffset := add(prefix, 57)
813         }
814         uint256 lengthLength = 0;
815         // The divisor to get the next left-most message length digit
816         uint256 divisor = 100000;
817         // Move one digit of the message length to the right at a time
818         while (divisor != 0) {
819           // The place value at the divisor
820           uint256 digit = length / divisor;
821           if (digit == 0) {
822             // Skip leading zeros
823             if (lengthLength == 0) {
824               divisor /= 10;
825               continue;
826             }
827           }
828           // Found a non-zero digit or non-leading zero digit
829           lengthLength++;
830           // Remove this digit from the message length's current value
831           length -= digit * divisor;
832           // Shift our base-10 divisor over
833           divisor /= 10;
834           // Convert the digit to its ASCII representation (man ascii)
835           digit += 0x30;
836           // Move to the next character and write the digit
837           lengthOffset++;
838           assembly {
839             mstore8(lengthOffset, digit)
840           }
841         }
842         // The null string requires exactly 1 zero (unskip 1 leading 0)
843         if (lengthLength == 0) {
844           lengthLength = 1 + 0x19 + 1;
845         } else {
846           lengthLength += 1 + 0x19;
847         }
848         // Truncate the tailing zeros from the prefix
849         assembly {
850           mstore(prefix, lengthLength)
851         }
852         return keccak256(prefix, message);
853     }
854 
855     function hasEnoughValidSignatures(
856         bytes _message,
857         uint8[] _vs,
858         bytes32[] _rs,
859         bytes32[] _ss,
860         IBridgeValidators _validatorContract) internal view
861     {
862         uint256 requiredSignatures = _validatorContract.requiredSignatures();
863         require(_vs.length >= requiredSignatures);
864         bytes32 hash = hashMessage(_message);
865         address[] memory encounteredAddresses = new address[](requiredSignatures);
866 
867         for (uint256 i = 0; i < requiredSignatures; i++) {
868             address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
869             require(_validatorContract.isValidator(recoveredAddress));
870             if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
871                 revert();
872             }
873             encounteredAddresses[i] = recoveredAddress;
874         }
875     }
876 
877     function hasEnoughValidSignaturesForeignBridgeValidator(
878         bytes _message,
879         uint8[] _vs,
880         bytes32[] _rs,
881         bytes32[] _ss,
882         IForeignBridgeValidators _validatorContract) internal view
883     {
884         uint256 requiredSignatures = _validatorContract.requiredSignatures();
885         require(_vs.length >= requiredSignatures);
886         bytes32 hash = hashMessage(_message);
887         address[] memory encounteredAddresses = new address[](requiredSignatures);
888 
889         for (uint256 i = 0; i < requiredSignatures; i++) {
890             address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
891             require(_validatorContract.isValidator(recoveredAddress));
892             if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
893                 revert();
894             }
895             encounteredAddresses[i] = recoveredAddress;
896         }
897     }
898 
899     function hasEnoughValidNewSetSignaturesForeignBridgeValidator(
900         bytes _message,
901         uint8[] _vs,
902         bytes32[] _rs,
903         bytes32[] _ss,
904         IForeignBridgeValidators _validatorContract) internal view
905     {
906         uint256 requiredSignatures = _validatorContract.requiredSignatures();
907         require(_vs.length >= requiredSignatures);
908         bytes32 hash = hashMessageOfUnknownLength(_message);
909         address[] memory encounteredAddresses = new address[](requiredSignatures);
910 
911         for (uint256 i = 0; i < requiredSignatures; i++) {
912             address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
913             require(_validatorContract.isValidator(recoveredAddress));
914             if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
915                 revert();
916             }
917             encounteredAddresses[i] = recoveredAddress;
918         }
919     }
920 
921     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
922         bytes32 r;
923         bytes32 s;
924         uint8 v;
925 
926         // Check the signature length
927         if (sig.length != 65) {
928           return (address(0));
929         }
930 
931         // Divide the signature in r, s and v variables
932         assembly {
933           r := mload(add(sig, 32))
934           s := mload(add(sig, 64))
935           v := byte(0, mload(add(sig, 96)))
936         }
937 
938         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
939         if (v < 27) {
940           v += 27;
941         }
942 
943         // If the version is correct return the signer address
944         if (v != 27 && v != 28) {
945           return (address(0));
946         } else {
947           return ecrecover(hash, v, r, s);
948         }
949     }
950 }
951 
952 // File: contracts/ITransferManager.sol
953 
954 pragma solidity ^0.4.24;
955 
956 /**
957  * @title Interface to be implemented by all Transfer Manager modules
958  * @dev abstract contract
959  */
960 contract ITransferManager {
961     function verifyTransfer(address _from, address _to, uint256 _amount) public view returns(bool);
962 }
963 
964 // File: contracts/IRestrictedToken.sol
965 
966 pragma solidity 0.4.24;
967 
968 interface IRestrictedToken {
969     event TransferManagerSet(address transferManager);
970     
971     function setTransferManager(address _transferManager) external;
972     function verifyTransfer(address _from, address _to, uint256 _value) external view;
973 }
974 
975 // File: contracts/ERC677BridgeToken.sol
976 
977 pragma solidity 0.4.24;
978 
979 
980 
981 
982 
983 
984 
985 
986 
987 
988 
989 contract ERC677BridgeToken is
990     IBurnableMintableERC677Token,
991     IRestrictedToken,
992     ERC20Detailed,
993     ERC20Burnable,
994     ERC20Mintable,
995     Ownable,
996     ERC865 {
997 
998     address public bridgeContract;
999     ITransferManager public transferManager;
1000 
1001     event ContractFallbackCallFailed(address from, address to, uint value);
1002 
1003     constructor(
1004         string _name,
1005         string _symbol,
1006         uint8 _decimals)
1007     public ERC20Detailed(_name, _symbol, _decimals) {}
1008 
1009     function setBridgeContract(address _bridgeContract) onlyMinter public {
1010         require(_bridgeContract != address(0) && isContract(_bridgeContract));
1011         bridgeContract = _bridgeContract;
1012     }
1013 
1014     function setTransferManager(address _transferManager) onlyOwner public {
1015         require(_transferManager != address(0) && isContract(_transferManager));
1016         transferManager = ITransferManager(_transferManager);
1017 
1018         emit TransferManagerSet(_transferManager);
1019     }
1020 
1021     modifier validRecipient(address _recipient) {
1022         require(_recipient != address(0) && _recipient != address(this));
1023         _;
1024     }
1025 
1026     function verifyTransfer(address _from, address _to, uint256 _value) public view returns (bool) {
1027       if (transferManager != address(0)) {
1028         return transferManager.verifyTransfer(_from, _to, _value);
1029       } else {
1030         return true;
1031       }
1032     }
1033 
1034     function transferAndCall(address _to, uint _value, bytes _data)
1035         external validRecipient(_to) returns (bool)
1036     {
1037         require(superTransfer(_to, _value));
1038         emit Transfer(msg.sender, _to, _value, _data);
1039 
1040         if (isContract(_to)) {
1041             require(contractFallback(_to, _value, _data));
1042         }
1043         return true;
1044     }
1045 
1046     function getTokenInterfacesVersion() public pure returns(uint64 major, uint64 minor, uint64 patch) {
1047         return (3, 0, 0);
1048     }
1049 
1050     function superTransfer(address _to, uint256 _value) internal returns(bool)
1051     {
1052         require(verifyTransfer(msg.sender, _to, _value));
1053         return super.transfer(_to, _value);
1054     }
1055 
1056     /**
1057    * @dev ERC20 transfer with a contract fallback.
1058    * Contract fallback to bridge is a special, That's the transfer to other network
1059    * @param _to The address to transfer to.
1060    * @param _value The amount to be transferred.
1061    */
1062     function transfer(address _to, uint256 _value) public returns (bool)
1063     {
1064         require(superTransfer(_to, _value));
1065         if (isContract(_to) && !contractFallback(_to, _value, new bytes(0))) {
1066             if (_to == bridgeContract) {
1067                 revert();
1068             } else {
1069                 emit ContractFallbackCallFailed(msg.sender, _to, _value);
1070             }
1071         }
1072         return true;
1073     }
1074 
1075     function contractFallback(address _to, uint _value, bytes _data)
1076         private
1077         returns(bool)
1078     {
1079         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  msg.sender, _value, _data));
1080     }
1081 
1082     function isContract(address _addr)
1083         internal
1084         view
1085         returns (bool)
1086     {
1087         uint length;
1088         assembly { length := extcodesize(_addr) }
1089         return length > 0;
1090     }
1091 
1092     function renounceOwnership() public onlyOwner {
1093         revert();
1094     }
1095 
1096     /**
1097    * @dev Claims token or ether sent by mistake to the token contract
1098    * @param _token The address to the token sent a null for ether.
1099    * @param _to The address to to sent the tokens.
1100    */
1101     function claimTokens(address _token, address _to) public onlyOwner {
1102         require(_to != address(0));
1103         if (_token == address(0)) {
1104             _to.transfer(address(this).balance);
1105             return;
1106         }
1107 
1108         ERC20Detailed token = ERC20Detailed(_token);
1109         uint256 balance = token.balanceOf(address(this));
1110         require(token.transfer(_to, balance));
1111     }
1112 
1113     function transferWithFee(address _sender, address _from, address _to, uint256 _value, uint256 _fee) internal returns(bool)
1114     {
1115         require(verifyTransfer(_from, _to, _value));
1116         require(verifyTransfer(_from, _sender, _fee));
1117         _transfer(_from, _to, _value);
1118         _transfer(_from, _sender, _fee);
1119         return true;
1120     }
1121 
1122     function contractFallbackFrom(address _from, address _to, uint _value, bytes _data) private returns(bool)
1123     {
1124         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)",  _from, _value, _data));
1125     }
1126 
1127     function transferPreSigned(bytes _signature, address _to, uint256 _value, uint256 _fee, uint256 _timestamp) validRecipient(_to) public returns (bool) {
1128         bytes32 hashedParams = getTransferPreSignedHash(address(this), _to, _value, _fee, _timestamp);
1129         address from = Message.recover(hashedParams, _signature);
1130         require(from != address(0), "Invalid from address recovered");
1131         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
1132         require(hashedTxs[hashedTx] == false, "Transaction hash was already used");
1133 
1134         require(transferWithFee(msg.sender, from, _to, _value, _fee));
1135         hashedTxs[hashedTx] = true;
1136         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
1137 
1138         if (isContract(_to) && !contractFallbackFrom(from, _to, _value, new bytes(0))) {
1139             if (_to == bridgeContract) {
1140                 revert();
1141             } else {
1142                 emit ContractFallbackCallFailed(from, _to, _value);
1143             }
1144         }
1145 
1146         return true;
1147     }
1148 
1149     function getTransferPreSignedHash(address _token, address _to, uint256 _value, uint256 _fee, uint256 _timestamp) public pure returns (bytes32) {
1150         /* "0d98dcb1": getTransferPreSignedHash(address,address,uint256,uint256,uint256) */
1151         return keccak256(abi.encodePacked(bytes4(0x0d98dcb1), _token, _to, _value, _fee, _timestamp));
1152     }
1153 
1154     function transferAndCallPreSigned(bytes _signature, address _to, uint256 _value, bytes _data, uint256 _fee, uint256 _timestamp) validRecipient(_to) public returns (bool) {
1155         bytes32 hashedParams = getTransferAndCallPreSignedHash(address(this), _to, _value, _data, _fee, _timestamp);
1156         address from = Message.recover(hashedParams, _signature);
1157         require(from != address(0), "Invalid from address recovered");
1158         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
1159         require(hashedTxs[hashedTx] == false, "Transaction hash was already used");
1160 
1161         require(transferWithFee(msg.sender, from, _to, _value, _fee));
1162         hashedTxs[hashedTx] = true;
1163         emit TransferAndCallPreSigned(from, _to, msg.sender, _value, _data, _fee);
1164 
1165         if (isContract(_to)) {
1166             require(contractFallbackFrom(from, _to, _value, _data));
1167         }
1168         return true;
1169     }
1170 
1171     function getTransferAndCallPreSignedHash(address _token, address _to, uint256 _value, bytes _data, uint256 _fee, uint256 _timestamp) public pure returns (bytes32) {
1172         /* "cabc0a10": getTransferPreSignedHash(address,address,uint256,uint256,uint256) */
1173         return keccak256(abi.encodePacked(bytes4(0xcabc0a10), _token, _to, _value, _data, _fee, _timestamp));
1174     }
1175 }