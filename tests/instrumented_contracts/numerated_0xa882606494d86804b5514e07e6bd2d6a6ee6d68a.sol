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
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances.
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) internal balances;
86 
87   uint256 internal totalSupply_;
88 
89   /**
90   * @dev Total number of tokens in existence
91   */
92   function totalSupply() public view returns (uint256) {
93     return totalSupply_;
94   }
95 
96   /**
97   * @dev Transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint256 _value) public returns (bool) {
102     require(_value <= balances[msg.sender]);
103     require(_to != address(0));
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
123 
124 pragma solidity ^0.4.24;
125 
126 /**
127  * @title Burnable Token
128  * @dev Token that can be irreversibly burned (destroyed).
129  */
130 contract BurnableToken is BasicToken {
131 
132   event Burn(address indexed burner, uint256 value);
133 
134   /**
135    * @dev Burns a specific amount of tokens.
136    * @param _value The amount of token to be burned.
137    */
138   function burn(uint256 _value) public {
139     _burn(msg.sender, _value);
140   }
141 
142   function _burn(address _who, uint256 _value) internal {
143     require(_value <= balances[_who]);
144     // no need to require value <= totalSupply, since that would imply the
145     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
146 
147     balances[_who] = balances[_who].sub(_value);
148     totalSupply_ = totalSupply_.sub(_value);
149     emit Burn(_who, _value);
150     emit Transfer(_who, address(0), _value);
151   }
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 pragma solidity ^0.4.24;
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://github.com/ethereum/EIPs/issues/20
161  */
162 contract ERC20 is ERC20Basic {
163   function allowance(address _owner, address _spender)
164     public view returns (uint256);
165 
166   function transferFrom(address _from, address _to, uint256 _value)
167     public returns (bool);
168 
169   function approve(address _spender, uint256 _value) public returns (bool);
170   event Approval(
171     address indexed owner,
172     address indexed spender,
173     uint256 value
174   );
175 }
176 
177 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
178 
179 pragma solidity ^0.4.24;
180 
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * https://github.com/ethereum/EIPs/issues/20
187  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(
201     address _from,
202     address _to,
203     uint256 _value
204   )
205     public
206     returns (bool)
207   {
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210     require(_to != address(0));
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(
241     address _owner,
242     address _spender
243    )
244     public
245     view
246     returns (uint256)
247   {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    * approve should be called when allowed[_spender] == 0. To increment
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _addedValue The amount of tokens to increase the allowance by.
259    */
260   function increaseApproval(
261     address _spender,
262     uint256 _addedValue
263   )
264     public
265     returns (bool)
266   {
267     allowed[msg.sender][_spender] = (
268       allowed[msg.sender][_spender].add(_addedValue));
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(
283     address _spender,
284     uint256 _subtractedValue
285   )
286     public
287     returns (bool)
288   {
289     uint256 oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue >= oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
302 
303 pragma solidity ^0.4.24;
304 
305 
306 /**
307  * @title Ownable
308  * @dev The Ownable contract has an owner address, and provides basic authorization control
309  * functions, this simplifies the implementation of "user permissions".
310  */
311 contract Ownable {
312   address public owner;
313 
314 
315   event OwnershipRenounced(address indexed previousOwner);
316   event OwnershipTransferred(
317     address indexed previousOwner,
318     address indexed newOwner
319   );
320 
321 
322   /**
323    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
324    * account.
325    */
326   constructor() public {
327     owner = msg.sender;
328   }
329 
330   /**
331    * @dev Throws if called by any account other than the owner.
332    */
333   modifier onlyOwner() {
334     require(msg.sender == owner);
335     _;
336   }
337 
338   /**
339    * @dev Allows the current owner to relinquish control of the contract.
340    * @notice Renouncing to ownership will leave the contract without an owner.
341    * It will not be possible to call the functions with the `onlyOwner`
342    * modifier anymore.
343    */
344   function renounceOwnership() public onlyOwner {
345     emit OwnershipRenounced(owner);
346     owner = address(0);
347   }
348 
349   /**
350    * @dev Allows the current owner to transfer control of the contract to a newOwner.
351    * @param _newOwner The address to transfer ownership to.
352    */
353   function transferOwnership(address _newOwner) public onlyOwner {
354     _transferOwnership(_newOwner);
355   }
356 
357   /**
358    * @dev Transfers control of the contract to a newOwner.
359    * @param _newOwner The address to transfer ownership to.
360    */
361   function _transferOwnership(address _newOwner) internal {
362     require(_newOwner != address(0));
363     emit OwnershipTransferred(owner, _newOwner);
364     owner = _newOwner;
365   }
366 }
367 
368 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
369 
370 pragma solidity ^0.4.24;
371 
372 
373 /**
374  * @title Mintable token
375  * @dev Simple ERC20 Token example, with mintable token creation
376  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
377  */
378 contract MintableToken is StandardToken, Ownable {
379   event Mint(address indexed to, uint256 amount);
380   event MintFinished();
381 
382   bool public mintingFinished = false;
383 
384 
385   modifier canMint() {
386     require(!mintingFinished);
387     _;
388   }
389 
390   modifier hasMintPermission() {
391     require(msg.sender == owner);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will receive the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(
402     address _to,
403     uint256 _amount
404   )
405     public
406     hasMintPermission
407     canMint
408     returns (bool)
409   {
410     totalSupply_ = totalSupply_.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     emit Mint(_to, _amount);
413     emit Transfer(address(0), _to, _amount);
414     return true;
415   }
416 
417   /**
418    * @dev Function to stop minting new tokens.
419    * @return True if the operation was successful.
420    */
421   function finishMinting() public onlyOwner canMint returns (bool) {
422     mintingFinished = true;
423     emit MintFinished();
424     return true;
425   }
426 }
427 
428 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
429 
430 pragma solidity ^0.4.24;
431 
432 /**
433  * @title DetailedERC20 token
434  * @dev The decimals are only for visualization purposes.
435  * All the operations are done using the smallest and indivisible token unit,
436  * just as on Ethereum all the operations are done in wei.
437  */
438 contract DetailedERC20 is ERC20 {
439   string public name;
440   string public symbol;
441   uint8 public decimals;
442 
443   constructor(string _name, string _symbol, uint8 _decimals) public {
444     name = _name;
445     symbol = _symbol;
446     decimals = _decimals;
447   }
448 }
449 
450 // File: openzeppelin-solidity/contracts/AddressUtils.sol
451 
452 pragma solidity ^0.4.24;
453 
454 
455 /**
456  * Utility library of inline functions on addresses
457  */
458 library AddressUtils {
459 
460   /**
461    * Returns whether the target address is a contract
462    * @dev This function will return false if invoked during the constructor of a contract,
463    * as the code is not actually created until after the constructor finishes.
464    * @param _addr address to check
465    * @return whether the target address is a contract
466    */
467   function isContract(address _addr) internal view returns (bool) {
468     uint256 size;
469     // XXX Currently there is no better way to check if there is a contract in an address
470     // than to check the size of the code at that address.
471     // See https://ethereum.stackexchange.com/a/14016/36603
472     // for more details about how this works.
473     // TODO Check this again before the Serenity release, because all addresses will be
474     // contracts then.
475     // solium-disable-next-line security/no-inline-assembly
476     assembly { size := extcodesize(_addr) }
477     return size > 0;
478   }
479 
480 }
481 
482 // File: contracts/interfaces/ERC677.sol
483 
484 pragma solidity 0.4.24;
485 
486 contract ERC677 is ERC20 {
487     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
488 
489     function transferAndCall(address, uint256, bytes) external returns (bool);
490 
491     function increaseAllowance(address spender, uint256 addedValue) public returns (bool);
492     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool);
493 }
494 
495 contract LegacyERC20 {
496     function transfer(address _spender, uint256 _value) public; // returns (bool);
497     function transferFrom(address _owner, address _spender, uint256 _value) public; // returns (bool);
498 }
499 
500 // File: contracts/interfaces/IBurnableMintableERC677Token.sol
501 
502 pragma solidity 0.4.24;
503 
504 contract IBurnableMintableERC677Token is ERC677 {
505     function mint(address _to, uint256 _amount) public returns (bool);
506     function burn(uint256 _value) public;
507     function claimTokens(address _token, address _to) external;
508 }
509 
510 // File: contracts/upgradeable_contracts/Sacrifice.sol
511 
512 pragma solidity 0.4.24;
513 
514 contract Sacrifice {
515     constructor(address _recipient) public payable {
516         selfdestruct(_recipient);
517     }
518 }
519 
520 // File: contracts/libraries/Address.sol
521 
522 pragma solidity 0.4.24;
523 
524 /**
525  * @title Address
526  * @dev Helper methods for Address type.
527  */
528 library Address {
529     /**
530     * @dev Try to send native tokens to the address. If it fails, it will force the transfer by creating a selfdestruct contract
531     * @param _receiver address that will receive the native tokens
532     * @param _value the amount of native tokens to send
533     */
534     function safeSendValue(address _receiver, uint256 _value) internal {
535         if (!_receiver.send(_value)) {
536             (new Sacrifice).value(_value)(_receiver);
537         }
538     }
539 }
540 
541 // File: contracts/libraries/SafeERC20.sol
542 
543 pragma solidity 0.4.24;
544 
545 
546 /**
547  * @title SafeERC20
548  * @dev Helper methods for safe token transfers.
549  * Functions perform additional checks to be sure that token transfer really happened.
550  */
551 library SafeERC20 {
552     using SafeMath for uint256;
553 
554     /**
555     * @dev Same as ERC20.transfer(address,uint256) but with extra consistency checks.
556     * @param _token address of the token contract
557     * @param _to address of the receiver
558     * @param _value amount of tokens to send
559     */
560     function safeTransfer(address _token, address _to, uint256 _value) internal {
561         LegacyERC20(_token).transfer(_to, _value);
562         assembly {
563             if returndatasize {
564                 returndatacopy(0, 0, 32)
565                 if iszero(mload(0)) {
566                     revert(0, 0)
567                 }
568             }
569         }
570     }
571 
572     /**
573     * @dev Same as ERC20.transferFrom(address,address,uint256) but with extra consistency checks.
574     * @param _token address of the token contract
575     * @param _from address of the sender
576     * @param _value amount of tokens to send
577     */
578     function safeTransferFrom(address _token, address _from, uint256 _value) internal {
579         LegacyERC20(_token).transferFrom(_from, address(this), _value);
580         assembly {
581             if returndatasize {
582                 returndatacopy(0, 0, 32)
583                 if iszero(mload(0)) {
584                     revert(0, 0)
585                 }
586             }
587         }
588     }
589 }
590 
591 // File: contracts/upgradeable_contracts/Claimable.sol
592 
593 pragma solidity 0.4.24;
594 
595 
596 /**
597  * @title Claimable
598  * @dev Implementation of the claiming utils that can be useful for withdrawing accidentally sent tokens that are not used in bridge operations.
599  */
600 contract Claimable {
601     using SafeERC20 for address;
602 
603     /**
604      * Throws if a given address is equal to address(0)
605      */
606     modifier validAddress(address _to) {
607         require(_to != address(0));
608         /* solcov ignore next */
609         _;
610     }
611 
612     /**
613      * @dev Withdraws the erc20 tokens or native coins from this contract.
614      * Caller should additionally check that the claimed token is not a part of bridge operations (i.e. that token != erc20token()).
615      * @param _token address of the claimed token or address(0) for native coins.
616      * @param _to address of the tokens/coins receiver.
617      */
618     function claimValues(address _token, address _to) internal validAddress(_to) {
619         if (_token == address(0)) {
620             claimNativeCoins(_to);
621         } else {
622             claimErc20Tokens(_token, _to);
623         }
624     }
625 
626     /**
627      * @dev Internal function for withdrawing all native coins from the contract.
628      * @param _to address of the coins receiver.
629      */
630     function claimNativeCoins(address _to) internal {
631         uint256 value = address(this).balance;
632         Address.safeSendValue(_to, value);
633     }
634 
635     /**
636      * @dev Internal function for withdrawing all tokens of ssome particular ERC20 contract from this contract.
637      * @param _token address of the claimed ERC20 token.
638      * @param _to address of the tokens receiver.
639      */
640     function claimErc20Tokens(address _token, address _to) internal {
641         ERC20Basic token = ERC20Basic(_token);
642         uint256 balance = token.balanceOf(this);
643         _token.safeTransfer(_to, balance);
644     }
645 }
646 
647 // File: contracts/ERC677BridgeToken.sol
648 
649 pragma solidity 0.4.24;
650 
651 
652 
653 
654 
655 
656 /**
657 * @title ERC677BridgeToken
658 * @dev The basic implementation of a bridgeable ERC677-compatible token
659 */
660 contract ERC677BridgeToken is IBurnableMintableERC677Token, DetailedERC20, BurnableToken, MintableToken, Claimable {
661     bytes4 internal constant ON_TOKEN_TRANSFER = 0xa4c0ed36; // onTokenTransfer(address,uint256,bytes)
662 
663     address internal bridgeContractAddr;
664 
665     constructor(string _name, string _symbol, uint8 _decimals) public DetailedERC20(_name, _symbol, _decimals) {
666         // solhint-disable-previous-line no-empty-blocks
667     }
668 
669     function bridgeContract() external view returns (address) {
670         return bridgeContractAddr;
671     }
672 
673     function setBridgeContract(address _bridgeContract) external onlyOwner {
674         require(AddressUtils.isContract(_bridgeContract));
675         bridgeContractAddr = _bridgeContract;
676     }
677 
678     modifier validRecipient(address _recipient) {
679         require(_recipient != address(0) && _recipient != address(this));
680         /* solcov ignore next */
681         _;
682     }
683 
684     function transferAndCall(address _to, uint256 _value, bytes _data) external validRecipient(_to) returns (bool) {
685         require(superTransfer(_to, _value));
686         emit Transfer(msg.sender, _to, _value, _data);
687 
688         if (AddressUtils.isContract(_to)) {
689             require(contractFallback(msg.sender, _to, _value, _data));
690         }
691         return true;
692     }
693 
694     function getTokenInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {
695         return (2, 5, 0);
696     }
697 
698     function superTransfer(address _to, uint256 _value) internal returns (bool) {
699         return super.transfer(_to, _value);
700     }
701 
702     function transfer(address _to, uint256 _value) public returns (bool) {
703         require(superTransfer(_to, _value));
704         callAfterTransfer(msg.sender, _to, _value);
705         return true;
706     }
707 
708     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
709         require(super.transferFrom(_from, _to, _value));
710         callAfterTransfer(_from, _to, _value);
711         return true;
712     }
713 
714     /**
715      * @dev Internal function that calls onTokenTransfer callback on the receiver after the successful transfer.
716      * Since it is not present in the original ERC677 standard, the callback is only called on the bridge contract,
717      * in order to simplify UX. In other cases, this token complies with the ERC677/ERC20 standard.
718      * @param _from tokens sender address.
719      * @param _to tokens receiver address.
720      * @param _value amount of sent tokens.
721      */
722     function callAfterTransfer(address _from, address _to, uint256 _value) internal {
723         if (isBridge(_to)) {
724             require(contractFallback(_from, _to, _value, new bytes(0)));
725         }
726     }
727 
728     function isBridge(address _address) public view returns (bool) {
729         return _address == bridgeContractAddr;
730     }
731 
732     /**
733      * @dev call onTokenTransfer fallback on the token recipient contract
734      * @param _from tokens sender
735      * @param _to tokens recipient
736      * @param _value amount of tokens that was sent
737      * @param _data set of extra bytes that can be passed to the recipient
738      */
739     function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
740         return _to.call(abi.encodeWithSelector(ON_TOKEN_TRANSFER, _from, _value, _data));
741     }
742 
743     function finishMinting() public returns (bool) {
744         revert();
745     }
746 
747     function renounceOwnership() public onlyOwner {
748         revert();
749     }
750 
751     /**
752      * @dev Withdraws the erc20 tokens or native coins from this contract.
753      * @param _token address of the claimed token or address(0) for native coins.
754      * @param _to address of the tokens/coins receiver.
755      */
756     function claimTokens(address _token, address _to) external onlyOwner {
757         claimValues(_token, _to);
758     }
759 
760     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
761         return super.increaseApproval(spender, addedValue);
762     }
763 
764     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
765         return super.decreaseApproval(spender, subtractedValue);
766     }
767 }
768 
769 // File: contracts/PermittableToken.sol
770 
771 pragma solidity 0.4.24;
772 
773 contract PermittableToken is ERC677BridgeToken {
774     string public constant version = "1";
775 
776     // EIP712 niceties
777     bytes32 public DOMAIN_SEPARATOR;
778     // bytes32 public constant PERMIT_TYPEHASH_LEGACY = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
779     bytes32 public constant PERMIT_TYPEHASH_LEGACY = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
780     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
781     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
782 
783     mapping(address => uint256) public nonces;
784     mapping(address => mapping(address => uint256)) public expirations;
785 
786     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _chainId)
787         public
788         ERC677BridgeToken(_name, _symbol, _decimals)
789     {
790         require(_chainId != 0);
791         DOMAIN_SEPARATOR = keccak256(
792             abi.encode(
793                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
794                 keccak256(bytes(_name)),
795                 keccak256(bytes(version)),
796                 _chainId,
797                 address(this)
798             )
799         );
800     }
801 
802     /// @dev transferFrom in this contract works in a slightly different form than the generic
803     /// transferFrom function. This contract allows for "unlimited approval".
804     /// Should the user approve an address for the maximum uint256 value,
805     /// then that address will have unlimited approval until told otherwise.
806     /// @param _sender The address of the sender.
807     /// @param _recipient The address of the recipient.
808     /// @param _amount The value to transfer.
809     /// @return Success status.
810     function transferFrom(address _sender, address _recipient, uint256 _amount) public returns (bool) {
811         require(_sender != address(0));
812         require(_recipient != address(0));
813 
814         balances[_sender] = balances[_sender].sub(_amount);
815         balances[_recipient] = balances[_recipient].add(_amount);
816         emit Transfer(_sender, _recipient, _amount);
817 
818         if (_sender != msg.sender) {
819             uint256 allowedAmount = allowance(_sender, msg.sender);
820 
821             if (allowedAmount != uint256(-1)) {
822                 // If allowance is limited, adjust it.
823                 // In this case `transferFrom` works like the generic
824                 allowed[_sender][msg.sender] = allowedAmount.sub(_amount);
825                 emit Approval(_sender, msg.sender, allowed[_sender][msg.sender]);
826             } else {
827                 // If allowance is unlimited by `permit`, `approve`, or `increaseAllowance`
828                 // function, don't adjust it. But the expiration date must be empty or in the future
829                 require(expirations[_sender][msg.sender] == 0 || expirations[_sender][msg.sender] >= now);
830             }
831         } else {
832             // If `_sender` is `msg.sender`,
833             // the function works just like `transfer()`
834         }
835 
836         callAfterTransfer(_sender, _recipient, _amount);
837         return true;
838     }
839 
840     /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
841     /// @param _to The address which will spend the funds.
842     /// @param _value The amount of tokens to be spent.
843     function approve(address _to, uint256 _value) public returns (bool result) {
844         _approveAndResetExpirations(msg.sender, _to, _value);
845         return true;
846     }
847 
848     /// @dev Atomically increases the allowance granted to spender by the caller.
849     /// @param _to The address which will spend the funds.
850     /// @param _addedValue The amount of tokens to increase the allowance by.
851     function increaseAllowance(address _to, uint256 _addedValue) public returns (bool result) {
852         _approveAndResetExpirations(msg.sender, _to, allowed[msg.sender][_to].add(_addedValue));
853         return true;
854     }
855 
856     /// @dev An alias for `transfer` function.
857     /// @param _to The address of the recipient.
858     /// @param _amount The value to transfer.
859     function push(address _to, uint256 _amount) public {
860         transferFrom(msg.sender, _to, _amount);
861     }
862 
863     /// @dev Makes a request to transfer the specified amount
864     /// from the specified address to the caller's address.
865     /// @param _from The address of the holder.
866     /// @param _amount The value to transfer.
867     function pull(address _from, uint256 _amount) public {
868         transferFrom(_from, msg.sender, _amount);
869     }
870 
871     /// @dev An alias for `transferFrom` function.
872     /// @param _from The address of the sender.
873     /// @param _to The address of the recipient.
874     /// @param _amount The value to transfer.
875     function move(address _from, address _to, uint256 _amount) public {
876         transferFrom(_from, _to, _amount);
877     }
878 
879     /// @dev Allows to spend holder's unlimited amount by the specified spender.
880     /// The function can be called by anyone, but requires having allowance parameters
881     /// signed by the holder according to EIP712.
882     /// @param _holder The holder's address.
883     /// @param _spender The spender's address.
884     /// @param _nonce The nonce taken from `nonces(_holder)` public getter.
885     /// @param _expiry The allowance expiration date (unix timestamp in UTC).
886     /// Can be zero for no expiration. Forced to zero if `_allowed` is `false`.
887     /// Note that timestamps are not precise, malicious miner/validator can manipulate them to some extend.
888     /// Assume that there can be a 900 seconds time delta between the desired timestamp and the actual expiration.
889     /// @param _allowed True to enable unlimited allowance for the spender by the holder. False to disable.
890     /// @param _v A final byte of signature (ECDSA component).
891     /// @param _r The first 32 bytes of signature (ECDSA component).
892     /// @param _s The second 32 bytes of signature (ECDSA component).
893     function permit(
894         address _holder,
895         address _spender,
896         uint256 _nonce,
897         uint256 _expiry,
898         bool _allowed,
899         uint8 _v,
900         bytes32 _r,
901         bytes32 _s
902     ) external {
903         require(_expiry == 0 || now <= _expiry);
904 
905         bytes32 digest = _digest(abi.encode(PERMIT_TYPEHASH_LEGACY, _holder, _spender, _nonce, _expiry, _allowed));
906 
907         require(_holder == _recover(digest, _v, _r, _s));
908         require(_nonce == nonces[_holder]++);
909 
910         uint256 amount = _allowed ? uint256(-1) : 0;
911 
912         expirations[_holder][_spender] = _allowed ? _expiry : 0;
913 
914         _approve(_holder, _spender, amount);
915     }
916 
917     /** @dev Allows to spend holder's unlimited amount by the specified spender according to EIP2612.
918      * The function can be called by anyone, but requires having allowance parameters
919      * signed by the holder according to EIP712.
920      * @param _holder The holder's address.
921      * @param _spender The spender's address.
922      * @param _value Allowance value to set as a result of the call.
923      * @param _deadline The deadline timestamp to call the permit function. Must be a timestamp in the future.
924      * Note that timestamps are not precise, malicious miner/validator can manipulate them to some extend.
925      * Assume that there can be a 900 seconds time delta between the desired timestamp and the actual expiration.
926      * @param _v A final byte of signature (ECDSA component).
927      * @param _r The first 32 bytes of signature (ECDSA component).
928      * @param _s The second 32 bytes of signature (ECDSA component).
929      */
930     function permit(
931         address _holder,
932         address _spender,
933         uint256 _value,
934         uint256 _deadline,
935         uint8 _v,
936         bytes32 _r,
937         bytes32 _s
938     ) external {
939         require(now <= _deadline);
940 
941         uint256 nonce = nonces[_holder]++;
942         bytes32 digest = _digest(abi.encode(PERMIT_TYPEHASH, _holder, _spender, _value, nonce, _deadline));
943 
944         require(_holder == _recover(digest, _v, _r, _s));
945 
946         _approveAndResetExpirations(_holder, _spender, _value);
947     }
948 
949     /**
950      * @dev Sets a new allowance value for the given owner and spender addresses.
951      * Resets expiration timestamp in case of unlimited approval.
952      * @param _owner address tokens holder.
953      * @param _spender address of tokens spender.
954      * @param _amount amount of approved tokens.
955      */
956     function _approveAndResetExpirations(address _owner, address _spender, uint256 _amount) internal {
957         _approve(_owner, _spender, _amount);
958 
959         // it is not necessary to reset _expirations in other cases, since it is only used together with infinite allowance
960         if (_amount == uint256(-1)) {
961             delete expirations[_owner][_spender];
962         }
963     }
964 
965     /**
966      * @dev Internal function for issuing an allowance.
967      * @param _owner address of the tokens owner.
968      * @param _spender address of the approved tokens spender.
969      * @param _amount amount of the approved tokens.
970      */
971     function _approve(address _owner, address _spender, uint256 _amount) internal {
972         require(_owner != address(0), "ERC20: approve from the zero address");
973         require(_spender != address(0), "ERC20: approve to the zero address");
974 
975         allowed[_owner][_spender] = _amount;
976         emit Approval(_owner, _spender, _amount);
977     }
978 
979     /**
980      * @dev Calculates the message digest for encoded EIP712 typed struct.
981      * @param _typedStruct encoded payload.
982      */
983     function _digest(bytes memory _typedStruct) internal view returns (bytes32) {
984         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, keccak256(_typedStruct)));
985     }
986 
987     /**
988      * @dev Derives the signer address for the given message digest and ECDSA signature params.
989      * @param _digest signed message digest.
990      * @param _v a final byte of signature (ECDSA component).
991      * @param _r the first 32 bytes of the signature (ECDSA component).
992      * @param _s the second 32 bytes of the signature (ECDSA component).
993      */
994     function _recover(bytes32 _digest, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
995         require(_v == 27 || _v == 28, "ECDSA: invalid signature 'v' value");
996         require(
997             uint256(_s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
998             "ECDSA: invalid signature 's' value"
999         );
1000 
1001         address signer = ecrecover(_digest, _v, _r, _s);
1002         require(signer != address(0), "ECDSA: invalid signature");
1003 
1004         return signer;
1005     }
1006 }
