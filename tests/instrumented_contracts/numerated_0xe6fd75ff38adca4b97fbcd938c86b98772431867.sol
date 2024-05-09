1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
18 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     assert(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     assert(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     assert(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) internal balances;
88 
89   uint256 internal totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_value <= balances[msg.sender]);
105     require(_to != address(0));
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
125 
126 pragma solidity ^0.4.24;
127 
128 
129 
130 /**
131  * @title Burnable Token
132  * @dev Token that can be irreversibly burned (destroyed).
133  */
134 contract BurnableToken is BasicToken {
135 
136   event Burn(address indexed burner, uint256 value);
137 
138   /**
139    * @dev Burns a specific amount of tokens.
140    * @param _value The amount of token to be burned.
141    */
142   function burn(uint256 _value) public {
143     _burn(msg.sender, _value);
144   }
145 
146   function _burn(address _who, uint256 _value) internal {
147     require(_value <= balances[_who]);
148     // no need to require value <= totalSupply, since that would imply the
149     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
150 
151     balances[_who] = balances[_who].sub(_value);
152     totalSupply_ = totalSupply_.sub(_value);
153     emit Burn(_who, _value);
154     emit Transfer(_who, address(0), _value);
155   }
156 }
157 
158 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
159 
160 pragma solidity ^0.4.24;
161 
162 
163 
164 /**
165  * @title ERC20 interface
166  * @dev see https://github.com/ethereum/EIPs/issues/20
167  */
168 contract ERC20 is ERC20Basic {
169   function allowance(address _owner, address _spender)
170     public view returns (uint256);
171 
172   function transferFrom(address _from, address _to, uint256 _value)
173     public returns (bool);
174 
175   function approve(address _spender, uint256 _value) public returns (bool);
176   event Approval(
177     address indexed owner,
178     address indexed spender,
179     uint256 value
180   );
181 }
182 
183 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
184 
185 pragma solidity ^0.4.24;
186 
187 
188 
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * https://github.com/ethereum/EIPs/issues/20
195  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218     require(_to != address(0));
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     emit Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(
249     address _owner,
250     address _spender
251    )
252     public
253     view
254     returns (uint256)
255   {
256     return allowed[_owner][_spender];
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(
269     address _spender,
270     uint256 _addedValue
271   )
272     public
273     returns (bool)
274   {
275     allowed[msg.sender][_spender] = (
276       allowed[msg.sender][_spender].add(_addedValue));
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(
291     address _spender,
292     uint256 _subtractedValue
293   )
294     public
295     returns (bool)
296   {
297     uint256 oldValue = allowed[msg.sender][_spender];
298     if (_subtractedValue >= oldValue) {
299       allowed[msg.sender][_spender] = 0;
300     } else {
301       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302     }
303     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304     return true;
305   }
306 
307 }
308 
309 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
310 
311 pragma solidity ^0.4.24;
312 
313 
314 /**
315  * @title Ownable
316  * @dev The Ownable contract has an owner address, and provides basic authorization control
317  * functions, this simplifies the implementation of "user permissions".
318  */
319 contract Ownable {
320   address public owner;
321 
322 
323   event OwnershipRenounced(address indexed previousOwner);
324   event OwnershipTransferred(
325     address indexed previousOwner,
326     address indexed newOwner
327   );
328 
329 
330   /**
331    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
332    * account.
333    */
334   constructor() public {
335     owner = msg.sender;
336   }
337 
338   /**
339    * @dev Throws if called by any account other than the owner.
340    */
341   modifier onlyOwner() {
342     require(msg.sender == owner);
343     _;
344   }
345 
346   /**
347    * @dev Allows the current owner to relinquish control of the contract.
348    * @notice Renouncing to ownership will leave the contract without an owner.
349    * It will not be possible to call the functions with the `onlyOwner`
350    * modifier anymore.
351    */
352   function renounceOwnership() public onlyOwner {
353     emit OwnershipRenounced(owner);
354     owner = address(0);
355   }
356 
357   /**
358    * @dev Allows the current owner to transfer control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function transferOwnership(address _newOwner) public onlyOwner {
362     _transferOwnership(_newOwner);
363   }
364 
365   /**
366    * @dev Transfers control of the contract to a newOwner.
367    * @param _newOwner The address to transfer ownership to.
368    */
369   function _transferOwnership(address _newOwner) internal {
370     require(_newOwner != address(0));
371     emit OwnershipTransferred(owner, _newOwner);
372     owner = _newOwner;
373   }
374 }
375 
376 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
377 
378 pragma solidity ^0.4.24;
379 
380 
381 
382 
383 /**
384  * @title Mintable token
385  * @dev Simple ERC20 Token example, with mintable token creation
386  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
387  */
388 contract MintableToken is StandardToken, Ownable {
389   event Mint(address indexed to, uint256 amount);
390   event MintFinished();
391 
392   bool public mintingFinished = false;
393 
394 
395   modifier canMint() {
396     require(!mintingFinished);
397     _;
398   }
399 
400   modifier hasMintPermission() {
401     require(msg.sender == owner);
402     _;
403   }
404 
405   /**
406    * @dev Function to mint tokens
407    * @param _to The address that will receive the minted tokens.
408    * @param _amount The amount of tokens to mint.
409    * @return A boolean that indicates if the operation was successful.
410    */
411   function mint(
412     address _to,
413     uint256 _amount
414   )
415     public
416     hasMintPermission
417     canMint
418     returns (bool)
419   {
420     totalSupply_ = totalSupply_.add(_amount);
421     balances[_to] = balances[_to].add(_amount);
422     emit Mint(_to, _amount);
423     emit Transfer(address(0), _to, _amount);
424     return true;
425   }
426 
427   /**
428    * @dev Function to stop minting new tokens.
429    * @return True if the operation was successful.
430    */
431   function finishMinting() public onlyOwner canMint returns (bool) {
432     mintingFinished = true;
433     emit MintFinished();
434     return true;
435   }
436 }
437 
438 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
439 
440 pragma solidity ^0.4.24;
441 
442 
443 
444 /**
445  * @title DetailedERC20 token
446  * @dev The decimals are only for visualization purposes.
447  * All the operations are done using the smallest and indivisible token unit,
448  * just as on Ethereum all the operations are done in wei.
449  */
450 contract DetailedERC20 is ERC20 {
451   string public name;
452   string public symbol;
453   uint8 public decimals;
454 
455   constructor(string _name, string _symbol, uint8 _decimals) public {
456     name = _name;
457     symbol = _symbol;
458     decimals = _decimals;
459   }
460 }
461 
462 // File: openzeppelin-solidity/contracts/AddressUtils.sol
463 
464 pragma solidity ^0.4.24;
465 
466 
467 /**
468  * Utility library of inline functions on addresses
469  */
470 library AddressUtils {
471 
472   /**
473    * Returns whether the target address is a contract
474    * @dev This function will return false if invoked during the constructor of a contract,
475    * as the code is not actually created until after the constructor finishes.
476    * @param _addr address to check
477    * @return whether the target address is a contract
478    */
479   function isContract(address _addr) internal view returns (bool) {
480     uint256 size;
481     // XXX Currently there is no better way to check if there is a contract in an address
482     // than to check the size of the code at that address.
483     // See https://ethereum.stackexchange.com/a/14016/36603
484     // for more details about how this works.
485     // TODO Check this again before the Serenity release, because all addresses will be
486     // contracts then.
487     // solium-disable-next-line security/no-inline-assembly
488     assembly { size := extcodesize(_addr) }
489     return size > 0;
490   }
491 
492 }
493 
494 // File: contracts/interfaces/ERC677.sol
495 
496 pragma solidity 0.4.24;
497 
498 
499 contract ERC677 is ERC20 {
500     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
501 
502     function transferAndCall(address, uint256, bytes) external returns (bool);
503 
504     function increaseAllowance(address spender, uint256 addedValue) public returns (bool);
505     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool);
506 }
507 
508 contract LegacyERC20 {
509     function transfer(address _spender, uint256 _value) public; // returns (bool);
510     function transferFrom(address _owner, address _spender, uint256 _value) public; // returns (bool);
511 }
512 
513 // File: contracts/interfaces/IBurnableMintableERC677Token.sol
514 
515 pragma solidity 0.4.24;
516 
517 
518 contract IBurnableMintableERC677Token is ERC677 {
519     function mint(address _to, uint256 _amount) public returns (bool);
520     function burn(uint256 _value) public;
521     function claimTokens(address _token, address _to) public;
522 }
523 
524 // File: contracts/upgradeable_contracts/Sacrifice.sol
525 
526 pragma solidity 0.4.24;
527 
528 contract Sacrifice {
529     constructor(address _recipient) public payable {
530         selfdestruct(_recipient);
531     }
532 }
533 
534 // File: contracts/libraries/Address.sol
535 
536 pragma solidity 0.4.24;
537 
538 
539 /**
540  * @title Address
541  * @dev Helper methods for Address type.
542  */
543 library Address {
544     /**
545     * @dev Try to send native tokens to the address. If it fails, it will force the transfer by creating a selfdestruct contract
546     * @param _receiver address that will receive the native tokens
547     * @param _value the amount of native tokens to send
548     */
549     function safeSendValue(address _receiver, uint256 _value) internal {
550         if (!_receiver.send(_value)) {
551             (new Sacrifice).value(_value)(_receiver);
552         }
553     }
554 }
555 
556 // File: contracts/upgradeable_contracts/Claimable.sol
557 
558 pragma solidity 0.4.24;
559 
560 
561 
562 contract Claimable {
563     bytes4 internal constant TRANSFER = 0xa9059cbb; // transfer(address,uint256)
564 
565     modifier validAddress(address _to) {
566         require(_to != address(0));
567         /* solcov ignore next */
568         _;
569     }
570 
571     function claimValues(address _token, address _to) internal {
572         if (_token == address(0)) {
573             claimNativeCoins(_to);
574         } else {
575             claimErc20Tokens(_token, _to);
576         }
577     }
578 
579     function claimNativeCoins(address _to) internal {
580         uint256 value = address(this).balance;
581         Address.safeSendValue(_to, value);
582     }
583 
584     function claimErc20Tokens(address _token, address _to) internal {
585         ERC20Basic token = ERC20Basic(_token);
586         uint256 balance = token.balanceOf(this);
587         safeTransfer(_token, _to, balance);
588     }
589 
590     function safeTransfer(address _token, address _to, uint256 _value) internal {
591         bytes memory returnData;
592         bool returnDataResult;
593         bytes memory callData = abi.encodeWithSelector(TRANSFER, _to, _value);
594         assembly {
595             let result := call(gas, _token, 0x0, add(callData, 0x20), mload(callData), 0, 32)
596             returnData := mload(0)
597             returnDataResult := mload(0)
598 
599             switch result
600                 case 0 {
601                     revert(0, 0)
602                 }
603         }
604 
605         // Return data is optional
606         if (returnData.length > 0) {
607             require(returnDataResult);
608         }
609     }
610 }
611 
612 // File: contracts/ERC677BridgeToken.sol
613 
614 pragma solidity 0.4.24;
615 
616 
617 
618 
619 
620 
621 
622 /**
623 * @title ERC677BridgeToken
624 * @dev The basic implementation of a bridgeable ERC677-compatible token
625 */
626 contract ERC677BridgeToken is IBurnableMintableERC677Token, DetailedERC20, BurnableToken, MintableToken, Claimable {
627     bytes4 internal constant ON_TOKEN_TRANSFER = 0xa4c0ed36; // onTokenTransfer(address,uint256,bytes)
628 
629     address internal bridgeContractAddr;
630 
631     event ContractFallbackCallFailed(address from, address to, uint256 value);
632 
633     constructor(string _name, string _symbol, uint8 _decimals) public DetailedERC20(_name, _symbol, _decimals) {
634         // solhint-disable-previous-line no-empty-blocks
635     }
636 
637     function bridgeContract() external view returns (address) {
638         return bridgeContractAddr;
639     }
640 
641     function setBridgeContract(address _bridgeContract) external onlyOwner {
642         require(AddressUtils.isContract(_bridgeContract));
643         bridgeContractAddr = _bridgeContract;
644     }
645 
646     modifier validRecipient(address _recipient) {
647         require(_recipient != address(0) && _recipient != address(this));
648         /* solcov ignore next */
649         _;
650     }
651 
652     function transferAndCall(address _to, uint256 _value, bytes _data) external validRecipient(_to) returns (bool) {
653         require(superTransfer(_to, _value));
654         emit Transfer(msg.sender, _to, _value, _data);
655 
656         if (AddressUtils.isContract(_to)) {
657             require(contractFallback(msg.sender, _to, _value, _data));
658         }
659         return true;
660     }
661 
662     function getTokenInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {
663         return (2, 2, 0);
664     }
665 
666     function superTransfer(address _to, uint256 _value) internal returns (bool) {
667         return super.transfer(_to, _value);
668     }
669 
670     function transfer(address _to, uint256 _value) public returns (bool) {
671         require(superTransfer(_to, _value));
672         callAfterTransfer(msg.sender, _to, _value);
673         return true;
674     }
675 
676     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
677         require(super.transferFrom(_from, _to, _value));
678         callAfterTransfer(_from, _to, _value);
679         return true;
680     }
681 
682     function callAfterTransfer(address _from, address _to, uint256 _value) internal {
683         if (AddressUtils.isContract(_to) && !contractFallback(_from, _to, _value, new bytes(0))) {
684             require(!isBridge(_to));
685             emit ContractFallbackCallFailed(_from, _to, _value);
686         }
687     }
688 
689     function isBridge(address _address) public view returns (bool) {
690         return _address == bridgeContractAddr;
691     }
692 
693     /**
694      * @dev call onTokenTransfer fallback on the token recipient contract
695      * @param _from tokens sender
696      * @param _to tokens recipient
697      * @param _value amount of tokens that was sent
698      * @param _data set of extra bytes that can be passed to the recipient
699      */
700     function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
701         return _to.call(abi.encodeWithSelector(ON_TOKEN_TRANSFER, _from, _value, _data));
702     }
703 
704     function finishMinting() public returns (bool) {
705         revert();
706     }
707 
708     function renounceOwnership() public onlyOwner {
709         revert();
710     }
711 
712     function claimTokens(address _token, address _to) public onlyOwner validAddress(_to) {
713         claimValues(_token, _to);
714     }
715 
716     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
717         return super.increaseApproval(spender, addedValue);
718     }
719 
720     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
721         return super.decreaseApproval(spender, subtractedValue);
722     }
723 }
724 
725 // File: contracts/PermittableToken.sol
726 
727 pragma solidity 0.4.24;
728 
729 
730 contract PermittableToken is ERC677BridgeToken {
731     string public constant version = "1";
732 
733     // EIP712 niceties
734     bytes32 public DOMAIN_SEPARATOR;
735     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
736     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
737 
738     mapping(address => uint256) public nonces;
739     mapping(address => mapping(address => uint256)) public expirations;
740 
741     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _chainId)
742         public
743         ERC677BridgeToken(_name, _symbol, _decimals)
744     {
745         require(_chainId != 0);
746         DOMAIN_SEPARATOR = keccak256(
747             abi.encode(
748                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
749                 keccak256(bytes(_name)),
750                 keccak256(bytes(version)),
751                 _chainId,
752                 address(this)
753             )
754         );
755     }
756 
757     /// @dev transferFrom in this contract works in a slightly different form than the generic
758     /// transferFrom function. This contract allows for "unlimited approval".
759     /// Should the user approve an address for the maximum uint256 value,
760     /// then that address will have unlimited approval until told otherwise.
761     /// @param _sender The address of the sender.
762     /// @param _recipient The address of the recipient.
763     /// @param _amount The value to transfer.
764     /// @return Success status.
765     function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {
766         require(_sender != address(0));
767         require(_recipient != address(0));
768 
769         balances[_sender] = balances[_sender].sub(_amount);
770         balances[_recipient] = balances[_recipient].add(_amount);
771         emit Transfer(_sender, _recipient, _amount);
772 
773         if (_sender != msg.sender) {
774             uint256 allowedAmount = allowance(_sender, msg.sender);
775 
776             if (allowedAmount != uint256(-1)) {
777                 // If allowance is limited, adjust it.
778                 // In this case `transferFrom` works like the generic
779                 allowed[_sender][msg.sender] = allowedAmount.sub(_amount);
780                 emit Approval(_sender, msg.sender, allowed[_sender][msg.sender]);
781             } else {
782                 // If allowance is unlimited by `permit`, `approve`, or `increaseAllowance`
783                 // function, don't adjust it. But the expiration date must be empty or in the future
784                 require(expirations[_sender][msg.sender] == 0 || expirations[_sender][msg.sender] >= _now());
785             }
786         } else {
787             // If `_sender` is `msg.sender`,
788             // the function works just like `transfer()`
789         }
790 
791         callAfterTransfer(_sender, _recipient, _amount);
792         return true;
793     }
794 
795     /// @dev An alias for `transfer` function.
796     /// @param _to The address of the recipient.
797     /// @param _amount The value to transfer.
798     function push(address _to, uint256 _amount) public {
799         transferFrom(msg.sender, _to, _amount);
800     }
801 
802     /// @dev Makes a request to transfer the specified amount
803     /// from the specified address to the caller's address.
804     /// @param _from The address of the holder.
805     /// @param _amount The value to transfer.
806     function pull(address _from, uint256 _amount) public {
807         transferFrom(_from, msg.sender, _amount);
808     }
809 
810     /// @dev An alias for `transferFrom` function.
811     /// @param _from The address of the sender.
812     /// @param _to The address of the recipient.
813     /// @param _amount The value to transfer.
814     function move(address _from, address _to, uint256 _amount) public {
815         transferFrom(_from, _to, _amount);
816     }
817 
818     /// @dev Allows to spend holder's unlimited amount by the specified spender.
819     /// The function can be called by anyone, but requires having allowance parameters
820     /// signed by the holder according to EIP712.
821     /// @param _holder The holder's address.
822     /// @param _spender The spender's address.
823     /// @param _nonce The nonce taken from `nonces(_holder)` public getter.
824     /// @param _expiry The allowance expiration date (unix timestamp in UTC).
825     /// Can be zero for no expiration. Forced to zero if `_allowed` is `false`.
826     /// @param _allowed True to enable unlimited allowance for the spender by the holder. False to disable.
827     /// @param _v A final byte of signature (ECDSA component).
828     /// @param _r The first 32 bytes of signature (ECDSA component).
829     /// @param _s The second 32 bytes of signature (ECDSA component).
830     function permit(
831         address _holder,
832         address _spender,
833         uint256 _nonce,
834         uint256 _expiry,
835         bool _allowed,
836         uint8 _v,
837         bytes32 _r,
838         bytes32 _s
839     ) external {
840         require(_holder != address(0));
841         require(_spender != address(0));
842         require(_expiry == 0 || _now() <= _expiry);
843 
844         bytes32 digest = keccak256(
845             abi.encodePacked(
846                 "\x19\x01",
847                 DOMAIN_SEPARATOR,
848                 keccak256(abi.encode(PERMIT_TYPEHASH, _holder, _spender, _nonce, _expiry, _allowed))
849             )
850         );
851 
852         require(_holder == ecrecover(digest, _v, _r, _s));
853         require(_nonce == nonces[_holder]++);
854 
855         uint256 amount = _allowed ? uint256(-1) : 0;
856 
857         allowed[_holder][_spender] = amount;
858         expirations[_holder][_spender] = _allowed ? _expiry : 0;
859 
860         emit Approval(_holder, _spender, amount);
861     }
862 
863     function _now() internal view returns (uint256) {
864         return now;
865     }
866 
867     /// @dev Version of the token contract.
868     function getTokenInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {
869         return (2, 3, 0);
870     }
871 }