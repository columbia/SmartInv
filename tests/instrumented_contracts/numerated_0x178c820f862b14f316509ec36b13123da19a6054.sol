1 
2 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
3 
4 pragma solidity ^0.4.24;
5 
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address _who) public view returns (uint256);
15   function transfer(address _to, uint256 _value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
20 
21 pragma solidity ^0.4.24;
22 
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
34     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
35     // benefit is lost if 'b' is also tested.
36     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37     if (_a == 0) {
38       return 0;
39     }
40 
41     c = _a * _b;
42     assert(c / _a == _b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     // assert(_b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = _a / _b;
52     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
53     return _a / _b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
60     assert(_b <= _a);
61     return _a - _b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
68     c = _a + _b;
69     assert(c >= _a);
70     return c;
71   }
72 }
73 
74 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
75 
76 pragma solidity ^0.4.24;
77 
78 
79 
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) internal balances;
89 
90   uint256 internal totalSupply_;
91 
92   /**
93   * @dev Total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev Transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_value <= balances[msg.sender]);
106     require(_to != address(0));
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
126 
127 pragma solidity ^0.4.24;
128 
129 
130 
131 /**
132  * @title Burnable Token
133  * @dev Token that can be irreversibly burned (destroyed).
134  */
135 contract BurnableToken is BasicToken {
136 
137   event Burn(address indexed burner, uint256 value);
138 
139   /**
140    * @dev Burns a specific amount of tokens.
141    * @param _value The amount of token to be burned.
142    */
143   function burn(uint256 _value) public {
144     _burn(msg.sender, _value);
145   }
146 
147   function _burn(address _who, uint256 _value) internal {
148     require(_value <= balances[_who]);
149     // no need to require value <= totalSupply, since that would imply the
150     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
151 
152     balances[_who] = balances[_who].sub(_value);
153     totalSupply_ = totalSupply_.sub(_value);
154     emit Burn(_who, _value);
155     emit Transfer(_who, address(0), _value);
156   }
157 }
158 
159 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
160 
161 pragma solidity ^0.4.24;
162 
163 
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address _owner, address _spender)
171     public view returns (uint256);
172 
173   function transferFrom(address _from, address _to, uint256 _value)
174     public returns (bool);
175 
176   function approve(address _spender, uint256 _value) public returns (bool);
177   event Approval(
178     address indexed owner,
179     address indexed spender,
180     uint256 value
181   );
182 }
183 
184 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
185 
186 pragma solidity ^0.4.24;
187 
188 
189 
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * https://github.com/ethereum/EIPs/issues/20
196  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(
210     address _from,
211     address _to,
212     uint256 _value
213   )
214     public
215     returns (bool)
216   {
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219     require(_to != address(0));
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     emit Transfer(_from, _to, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(
250     address _owner,
251     address _spender
252    )
253     public
254     view
255     returns (uint256)
256   {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    * approve should be called when allowed[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint256 _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(
292     address _spender,
293     uint256 _subtractedValue
294   )
295     public
296     returns (bool)
297   {
298     uint256 oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue >= oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
311 
312 pragma solidity ^0.4.24;
313 
314 
315 /**
316  * @title Ownable
317  * @dev The Ownable contract has an owner address, and provides basic authorization control
318  * functions, this simplifies the implementation of "user permissions".
319  */
320 contract Ownable {
321   address public owner;
322 
323 
324   event OwnershipRenounced(address indexed previousOwner);
325   event OwnershipTransferred(
326     address indexed previousOwner,
327     address indexed newOwner
328   );
329 
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() public {
336     owner = msg.sender;
337   }
338 
339   /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyOwner() {
343     require(msg.sender == owner);
344     _;
345   }
346 
347   /**
348    * @dev Allows the current owner to relinquish control of the contract.
349    * @notice Renouncing to ownership will leave the contract without an owner.
350    * It will not be possible to call the functions with the `onlyOwner`
351    * modifier anymore.
352    */
353   function renounceOwnership() public onlyOwner {
354     emit OwnershipRenounced(owner);
355     owner = address(0);
356   }
357 
358   /**
359    * @dev Allows the current owner to transfer control of the contract to a newOwner.
360    * @param _newOwner The address to transfer ownership to.
361    */
362   function transferOwnership(address _newOwner) public onlyOwner {
363     _transferOwnership(_newOwner);
364   }
365 
366   /**
367    * @dev Transfers control of the contract to a newOwner.
368    * @param _newOwner The address to transfer ownership to.
369    */
370   function _transferOwnership(address _newOwner) internal {
371     require(_newOwner != address(0));
372     emit OwnershipTransferred(owner, _newOwner);
373     owner = _newOwner;
374   }
375 }
376 
377 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
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
439 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
440 
441 pragma solidity ^0.4.24;
442 
443 
444 
445 /**
446  * @title DetailedERC20 token
447  * @dev The decimals are only for visualization purposes.
448  * All the operations are done using the smallest and indivisible token unit,
449  * just as on Ethereum all the operations are done in wei.
450  */
451 contract DetailedERC20 is ERC20 {
452   string public name;
453   string public symbol;
454   uint8 public decimals;
455 
456   constructor(string _name, string _symbol, uint8 _decimals) public {
457     name = _name;
458     symbol = _symbol;
459     decimals = _decimals;
460   }
461 }
462 
463 // File: openzeppelin-solidity/contracts/AddressUtils.sol
464 
465 pragma solidity ^0.4.24;
466 
467 
468 /**
469  * Utility library of inline functions on addresses
470  */
471 library AddressUtils {
472 
473   /**
474    * Returns whether the target address is a contract
475    * @dev This function will return false if invoked during the constructor of a contract,
476    * as the code is not actually created until after the constructor finishes.
477    * @param _addr address to check
478    * @return whether the target address is a contract
479    */
480   function isContract(address _addr) internal view returns (bool) {
481     uint256 size;
482     // XXX Currently there is no better way to check if there is a contract in an address
483     // than to check the size of the code at that address.
484     // See https://ethereum.stackexchange.com/a/14016/36603
485     // for more details about how this works.
486     // TODO Check this again before the Serenity release, because all addresses will be
487     // contracts then.
488     // solium-disable-next-line security/no-inline-assembly
489     assembly { size := extcodesize(_addr) }
490     return size > 0;
491   }
492 
493 }
494 
495 // File: contracts/interfaces/ERC677.sol
496 
497 pragma solidity 0.4.24;
498 
499 
500 contract ERC677 is ERC20 {
501     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
502 
503     function transferAndCall(address, uint256, bytes) external returns (bool);
504 
505     function increaseAllowance(address spender, uint256 addedValue) public returns (bool);
506     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool);
507 }
508 
509 // File: contracts/interfaces/IBurnableMintableERC677Token.sol
510 
511 pragma solidity 0.4.24;
512 
513 
514 contract IBurnableMintableERC677Token is ERC677 {
515     function mint(address _to, uint256 _amount) public returns (bool);
516     function burn(uint256 _value) public;
517     function claimTokens(address _token, address _to) public;
518 }
519 
520 // File: contracts/upgradeable_contracts/Sacrifice.sol
521 
522 pragma solidity 0.4.24;
523 
524 contract Sacrifice {
525     constructor(address _recipient) public payable {
526         selfdestruct(_recipient);
527     }
528 }
529 
530 // File: contracts/upgradeable_contracts/Claimable.sol
531 
532 pragma solidity 0.4.24;
533 
534 
535 
536 contract Claimable {
537     bytes4 internal constant TRANSFER = 0xa9059cbb; // transfer(address,uint256)
538 
539     modifier validAddress(address _to) {
540         require(_to != address(0));
541         /* solcov ignore next */
542         _;
543     }
544 
545     function claimValues(address _token, address _to) internal {
546         if (_token == address(0)) {
547             claimNativeCoins(_to);
548         } else {
549             claimErc20Tokens(_token, _to);
550         }
551     }
552 
553     function claimNativeCoins(address _to) internal {
554         uint256 value = address(this).balance;
555         if (!_to.send(value)) {
556             (new Sacrifice).value(value)(_to);
557         }
558     }
559 
560     function claimErc20Tokens(address _token, address _to) internal {
561         ERC20Basic token = ERC20Basic(_token);
562         uint256 balance = token.balanceOf(this);
563         safeTransfer(_token, _to, balance);
564     }
565 
566     function safeTransfer(address _token, address _to, uint256 _value) internal {
567         bytes memory returnData;
568         bool returnDataResult;
569         bytes memory callData = abi.encodeWithSelector(TRANSFER, _to, _value);
570         assembly {
571             let result := call(gas, _token, 0x0, add(callData, 0x20), mload(callData), 0, 32)
572             returnData := mload(0)
573             returnDataResult := mload(0)
574 
575             switch result
576                 case 0 {
577                     revert(0, 0)
578                 }
579         }
580 
581         // Return data is optional
582         if (returnData.length > 0) {
583             require(returnDataResult);
584         }
585     }
586 }
587 
588 // File: contracts/ERC677BridgeToken.sol
589 
590 pragma solidity 0.4.24;
591 
592 
593 
594 
595 
596 
597 
598 contract ERC677BridgeToken is IBurnableMintableERC677Token, DetailedERC20, BurnableToken, MintableToken, Claimable {
599     address public bridgeContract;
600 
601     event ContractFallbackCallFailed(address from, address to, uint256 value);
602 
603     constructor(string _name, string _symbol, uint8 _decimals) public DetailedERC20(_name, _symbol, _decimals) {
604         // solhint-disable-previous-line no-empty-blocks
605     }
606 
607     function setBridgeContract(address _bridgeContract) external onlyOwner {
608         require(AddressUtils.isContract(_bridgeContract));
609         bridgeContract = _bridgeContract;
610     }
611 
612     modifier validRecipient(address _recipient) {
613         require(_recipient != address(0) && _recipient != address(this));
614         /* solcov ignore next */
615         _;
616     }
617 
618     function transferAndCall(address _to, uint256 _value, bytes _data) external validRecipient(_to) returns (bool) {
619         require(superTransfer(_to, _value));
620         emit Transfer(msg.sender, _to, _value, _data);
621 
622         if (AddressUtils.isContract(_to)) {
623             require(contractFallback(msg.sender, _to, _value, _data));
624         }
625         return true;
626     }
627 
628     function getTokenInterfacesVersion() external pure returns (uint64 major, uint64 minor, uint64 patch) {
629         return (2, 2, 0);
630     }
631 
632     function superTransfer(address _to, uint256 _value) internal returns (bool) {
633         return super.transfer(_to, _value);
634     }
635 
636     function transfer(address _to, uint256 _value) public returns (bool) {
637         require(superTransfer(_to, _value));
638         callAfterTransfer(msg.sender, _to, _value);
639         return true;
640     }
641 
642     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
643         require(super.transferFrom(_from, _to, _value));
644         callAfterTransfer(_from, _to, _value);
645         return true;
646     }
647 
648     function callAfterTransfer(address _from, address _to, uint256 _value) internal {
649         if (AddressUtils.isContract(_to) && !contractFallback(_from, _to, _value, new bytes(0))) {
650             require(_to != bridgeContract);
651             emit ContractFallbackCallFailed(_from, _to, _value);
652         }
653     }
654 
655     function contractFallback(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
656         return _to.call(abi.encodeWithSignature("onTokenTransfer(address,uint256,bytes)", _from, _value, _data));
657     }
658 
659     function finishMinting() public returns (bool) {
660         revert();
661     }
662 
663     function renounceOwnership() public onlyOwner {
664         revert();
665     }
666 
667     function claimTokens(address _token, address _to) public onlyOwner validAddress(_to) {
668         claimValues(_token, _to);
669     }
670 
671     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
672         return super.increaseApproval(spender, addedValue);
673     }
674 
675     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
676         return super.decreaseApproval(spender, subtractedValue);
677     }
678 }
