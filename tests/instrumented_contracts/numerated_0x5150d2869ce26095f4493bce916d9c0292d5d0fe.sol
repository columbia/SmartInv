1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
68 
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * See https://github.com/ethereum/EIPs/issues/179
73  */
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address _who) public view returns (uint256);
77   function transfer(address _to, uint256 _value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address _owner, address _spender)
89     public view returns (uint256);
90 
91   function transferFrom(address _from, address _to, uint256 _value)
92     public returns (bool);
93 
94   function approve(address _spender, uint256 _value) public returns (bool);
95   event Approval(
96     address indexed owner,
97     address indexed spender,
98     uint256 value
99   );
100 }
101 
102 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109 
110   /**
111   * @dev Multiplies two numbers, throws on overflow.
112   */
113   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
114     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (_a == 0) {
118       return 0;
119     }
120 
121     c = _a * _b;
122     assert(c / _a == _b);
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers, truncating the quotient.
128   */
129   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
130     // assert(_b > 0); // Solidity automatically throws when dividing by 0
131     // uint256 c = _a / _b;
132     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
133     return _a / _b;
134   }
135 
136   /**
137   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
138   */
139   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
140     assert(_b <= _a);
141     return _a - _b;
142   }
143 
144   /**
145   * @dev Adds two numbers, throws on overflow.
146   */
147   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
148     c = _a + _b;
149     assert(c >= _a);
150     return c;
151   }
152 }
153 
154 // File: contracts/ext/CheckedERC20.sol
155 
156 library CheckedERC20 {
157     using SafeMath for uint;
158 
159     function isContract(address addr) internal view returns(bool result) {
160         // solium-disable-next-line security/no-inline-assembly
161         assembly {
162             result := gt(extcodesize(addr), 0)
163         }
164     }
165 
166     function handleReturnBool() internal pure returns(bool result) {
167         // solium-disable-next-line security/no-inline-assembly
168         assembly {
169             switch returndatasize()
170             case 0 { // not a std erc20
171                 result := 1
172             }
173             case 32 { // std erc20
174                 returndatacopy(0, 0, 32)
175                 result := mload(0)
176             }
177             default { // anything else, should revert for safety
178                 revert(0, 0)
179             }
180         }
181     }
182 
183     function handleReturnBytes32() internal pure returns(bytes32 result) {
184         // solium-disable-next-line security/no-inline-assembly
185         assembly {
186             switch eq(returndatasize(), 32) // not a std erc20
187             case 1 {
188                 returndatacopy(0, 0, 32)
189                 result := mload(0)
190             }
191 
192             switch gt(returndatasize(), 32) // std erc20
193             case 1 {
194                 returndatacopy(0, 64, 32)
195                 result := mload(0)
196             }
197 
198             switch lt(returndatasize(), 32) // anything else, should revert for safety
199             case 1 {
200                 revert(0, 0)
201             }
202         }
203     }
204 
205     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
206         require(isContract(token));
207         // solium-disable-next-line security/no-low-level-calls
208         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
209         return handleReturnBool();
210     }
211 
212     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
213         require(isContract(token));
214         // solium-disable-next-line security/no-low-level-calls
215         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
216         return handleReturnBool();
217     }
218 
219     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
220         require(isContract(token));
221         // solium-disable-next-line security/no-low-level-calls
222         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
223         return handleReturnBool();
224     }
225 
226     //
227 
228     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
229         if (value > 0) {
230             uint256 balance = token.balanceOf(this);
231             asmTransfer(token, to, value);
232             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
233         }
234     }
235 
236     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
237         if (value > 0) {
238             uint256 toBalance = token.balanceOf(to);
239             asmTransferFrom(token, from, to, value);
240             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
241         }
242     }
243 
244     //
245 
246     function asmName(address token) internal view returns(bytes32) {
247         require(isContract(token));
248         // solium-disable-next-line security/no-low-level-calls
249         require(token.call(bytes4(keccak256("name()"))));
250         return handleReturnBytes32();
251     }
252 
253     function asmSymbol(address token) internal view returns(bytes32) {
254         require(isContract(token));
255         // solium-disable-next-line security/no-low-level-calls
256         require(token.call(bytes4(keccak256("symbol()"))));
257         return handleReturnBytes32();
258     }
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
262 
263 /**
264  * @title Basic token
265  * @dev Basic version of StandardToken, with no allowances.
266  */
267 contract BasicToken is ERC20Basic {
268   using SafeMath for uint256;
269 
270   mapping(address => uint256) internal balances;
271 
272   uint256 internal totalSupply_;
273 
274   /**
275   * @dev Total number of tokens in existence
276   */
277   function totalSupply() public view returns (uint256) {
278     return totalSupply_;
279   }
280 
281   /**
282   * @dev Transfer token for a specified address
283   * @param _to The address to transfer to.
284   * @param _value The amount to be transferred.
285   */
286   function transfer(address _to, uint256 _value) public returns (bool) {
287     require(_value <= balances[msg.sender]);
288     require(_to != address(0));
289 
290     balances[msg.sender] = balances[msg.sender].sub(_value);
291     balances[_to] = balances[_to].add(_value);
292     emit Transfer(msg.sender, _to, _value);
293     return true;
294   }
295 
296   /**
297   * @dev Gets the balance of the specified address.
298   * @param _owner The address to query the the balance of.
299   * @return An uint256 representing the amount owned by the passed address.
300   */
301   function balanceOf(address _owner) public view returns (uint256) {
302     return balances[_owner];
303   }
304 
305 }
306 
307 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
308 
309 /**
310  * @title Standard ERC20 token
311  *
312  * @dev Implementation of the basic standard token.
313  * https://github.com/ethereum/EIPs/issues/20
314  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
315  */
316 contract StandardToken is ERC20, BasicToken {
317 
318   mapping (address => mapping (address => uint256)) internal allowed;
319 
320 
321   /**
322    * @dev Transfer tokens from one address to another
323    * @param _from address The address which you want to send tokens from
324    * @param _to address The address which you want to transfer to
325    * @param _value uint256 the amount of tokens to be transferred
326    */
327   function transferFrom(
328     address _from,
329     address _to,
330     uint256 _value
331   )
332     public
333     returns (bool)
334   {
335     require(_value <= balances[_from]);
336     require(_value <= allowed[_from][msg.sender]);
337     require(_to != address(0));
338 
339     balances[_from] = balances[_from].sub(_value);
340     balances[_to] = balances[_to].add(_value);
341     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
342     emit Transfer(_from, _to, _value);
343     return true;
344   }
345 
346   /**
347    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
348    * Beware that changing an allowance with this method brings the risk that someone may use both the old
349    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
350    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
351    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
352    * @param _spender The address which will spend the funds.
353    * @param _value The amount of tokens to be spent.
354    */
355   function approve(address _spender, uint256 _value) public returns (bool) {
356     allowed[msg.sender][_spender] = _value;
357     emit Approval(msg.sender, _spender, _value);
358     return true;
359   }
360 
361   /**
362    * @dev Function to check the amount of tokens that an owner allowed to a spender.
363    * @param _owner address The address which owns the funds.
364    * @param _spender address The address which will spend the funds.
365    * @return A uint256 specifying the amount of tokens still available for the spender.
366    */
367   function allowance(
368     address _owner,
369     address _spender
370    )
371     public
372     view
373     returns (uint256)
374   {
375     return allowed[_owner][_spender];
376   }
377 
378   /**
379    * @dev Increase the amount of tokens that an owner allowed to a spender.
380    * approve should be called when allowed[_spender] == 0. To increment
381    * allowed value is better to use this function to avoid 2 calls (and wait until
382    * the first transaction is mined)
383    * From MonolithDAO Token.sol
384    * @param _spender The address which will spend the funds.
385    * @param _addedValue The amount of tokens to increase the allowance by.
386    */
387   function increaseApproval(
388     address _spender,
389     uint256 _addedValue
390   )
391     public
392     returns (bool)
393   {
394     allowed[msg.sender][_spender] = (
395       allowed[msg.sender][_spender].add(_addedValue));
396     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
397     return true;
398   }
399 
400   /**
401    * @dev Decrease the amount of tokens that an owner allowed to a spender.
402    * approve should be called when allowed[_spender] == 0. To decrement
403    * allowed value is better to use this function to avoid 2 calls (and wait until
404    * the first transaction is mined)
405    * From MonolithDAO Token.sol
406    * @param _spender The address which will spend the funds.
407    * @param _subtractedValue The amount of tokens to decrease the allowance by.
408    */
409   function decreaseApproval(
410     address _spender,
411     uint256 _subtractedValue
412   )
413     public
414     returns (bool)
415   {
416     uint256 oldValue = allowed[msg.sender][_spender];
417     if (_subtractedValue >= oldValue) {
418       allowed[msg.sender][_spender] = 0;
419     } else {
420       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
421     }
422     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
423     return true;
424   }
425 
426 }
427 
428 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
429 
430 /**
431  * @title DetailedERC20 token
432  * @dev The decimals are only for visualization purposes.
433  * All the operations are done using the smallest and indivisible token unit,
434  * just as on Ethereum all the operations are done in wei.
435  */
436 contract DetailedERC20 is ERC20 {
437   string public name;
438   string public symbol;
439   uint8 public decimals;
440 
441   constructor(string _name, string _symbol, uint8 _decimals) public {
442     name = _name;
443     symbol = _symbol;
444     decimals = _decimals;
445   }
446 }
447 
448 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
449 
450 /**
451  * @title ERC165
452  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
453  */
454 interface ERC165 {
455 
456   /**
457    * @notice Query if a contract implements an interface
458    * @param _interfaceId The interface identifier, as specified in ERC-165
459    * @dev Interface identification is specified in ERC-165. This function
460    * uses less than 30,000 gas.
461    */
462   function supportsInterface(bytes4 _interfaceId)
463     external
464     view
465     returns (bool);
466 }
467 
468 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
469 
470 /**
471  * @title SupportsInterfaceWithLookup
472  * @author Matt Condon (@shrugs)
473  * @dev Implements ERC165 using a lookup table.
474  */
475 contract SupportsInterfaceWithLookup is ERC165 {
476 
477   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
478   /**
479    * 0x01ffc9a7 ===
480    *   bytes4(keccak256('supportsInterface(bytes4)'))
481    */
482 
483   /**
484    * @dev a mapping of interface id to whether or not it's supported
485    */
486   mapping(bytes4 => bool) internal supportedInterfaces;
487 
488   /**
489    * @dev A contract implementing SupportsInterfaceWithLookup
490    * implement ERC165 itself
491    */
492   constructor()
493     public
494   {
495     _registerInterface(InterfaceId_ERC165);
496   }
497 
498   /**
499    * @dev implement supportsInterface(bytes4) using a lookup table
500    */
501   function supportsInterface(bytes4 _interfaceId)
502     external
503     view
504     returns (bool)
505   {
506     return supportedInterfaces[_interfaceId];
507   }
508 
509   /**
510    * @dev private method for registering an interface
511    */
512   function _registerInterface(bytes4 _interfaceId)
513     internal
514   {
515     require(_interfaceId != 0xffffffff);
516     supportedInterfaces[_interfaceId] = true;
517   }
518 }
519 
520 // File: contracts/ext/ERC1003Token.sol
521 
522 contract ERC1003Caller is Ownable {
523     function makeCall(address target, bytes data) external payable onlyOwner returns (bool) {
524         // solium-disable-next-line security/no-call-value
525         return target.call.value(msg.value)(data);
526     }
527 }
528 
529 
530 contract ERC1003Token is ERC20 {
531     ERC1003Caller private _caller = new ERC1003Caller();
532     address[] internal _sendersStack;
533 
534     function caller() public view returns(ERC1003Caller) {
535         return _caller;
536     }
537 
538     function approveAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
539         _sendersStack.push(msg.sender);
540         approve(to, value);
541         require(_caller.makeCall.value(msg.value)(to, data));
542         _sendersStack.length -= 1;
543         return true;
544     }
545 
546     function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
547         transfer(to, value);
548         require(_caller.makeCall.value(msg.value)(to, data));
549         return true;
550     }
551 
552     function transferFrom(address from, address to, uint256 value) public returns (bool) {
553         address spender = (from != address(_caller)) ? from : _sendersStack[_sendersStack.length - 1];
554         return super.transferFrom(spender, to, value);
555     }
556 }
557 
558 // File: contracts/interface/IBasicMultiToken.sol
559 
560 contract IBasicMultiToken is ERC20 {
561     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
562     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
563 
564     function tokensCount() public view returns(uint256);
565     function tokens(uint i) public view returns(ERC20);
566     function bundlingEnabled() public view returns(bool);
567     
568     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
569     function bundle(address _beneficiary, uint256 _amount) public;
570 
571     function unbundle(address _beneficiary, uint256 _value) public;
572     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
573 
574     // Owner methods
575     function disableBundling() public;
576     function enableBundling() public;
577 
578     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
579 	  /**
580 	   * 0xd5c368b6 ===
581 	   *   bytes4(keccak256('tokensCount()')) ^
582 	   *   bytes4(keccak256('tokens(uint256)')) ^
583        *   bytes4(keccak256('bundlingEnabled()')) ^
584        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
585        *   bytes4(keccak256('bundle(address,uint256)')) ^
586        *   bytes4(keccak256('unbundle(address,uint256)')) ^
587        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
588        *   bytes4(keccak256('disableBundling()')) ^
589        *   bytes4(keccak256('enableBundling()'))
590 	   */
591 }
592 
593 // File: contracts/BasicMultiToken.sol
594 
595 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken, SupportsInterfaceWithLookup {
596     using CheckedERC20 for ERC20;
597     using CheckedERC20 for DetailedERC20;
598 
599     ERC20[] private _tokens;
600     uint private _inLendingMode;
601     bool private _bundlingEnabled = true;
602 
603     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
604     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
605     event BundlingStatus(bool enabled);
606 
607     modifier notInLendingMode {
608         require(_inLendingMode == 0, "Operation can't be performed while lending");
609         _;
610     }
611 
612     modifier whenBundlingEnabled {
613         require(_bundlingEnabled, "Bundling is disabled");
614         _;
615     }
616 
617     constructor()
618         public DetailedERC20("", "", 0)
619     {
620     }
621 
622     function init(ERC20[] tokens, string theName, string theSymbol, uint8 theDecimals) public {
623         require(decimals == 0, "constructor: decimals should be zero");
624         require(theDecimals > 0, "constructor: _decimals should not be zero");
625         require(bytes(theName).length > 0, "constructor: name should not be empty");
626         require(bytes(theSymbol).length > 0, "constructor: symbol should not be empty");
627         require(tokens.length >= 2, "Contract does not support less than 2 inner tokens");
628 
629         name = theName;
630         symbol = theSymbol;
631         decimals = theDecimals;
632         _tokens = tokens;
633 
634         _registerInterface(InterfaceId_IBasicMultiToken);
635     }
636 
637     function tokensCount() public view returns(uint) {
638         return _tokens.length;
639     }
640 
641     function tokens(uint i) public view returns(ERC20) {
642         return _tokens[i];
643     }
644 
645     function inLendingMode() public view returns(uint) {
646         return _inLendingMode;
647     }
648 
649     function bundlingEnabled() public view returns(bool) {
650         return _bundlingEnabled;
651     }
652 
653     function bundleFirstTokens(address beneficiary, uint256 amount, uint256[] tokenAmounts) public whenBundlingEnabled notInLendingMode {
654         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
655         _bundle(beneficiary, amount, tokenAmounts);
656     }
657 
658     function bundle(address beneficiary, uint256 amount) public whenBundlingEnabled notInLendingMode {
659         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
660         uint256[] memory tokenAmounts = new uint256[](_tokens.length);
661         for (uint i = 0; i < _tokens.length; i++) {
662             tokenAmounts[i] = _tokens[i].balanceOf(this).mul(amount).div(totalSupply_);
663         }
664         _bundle(beneficiary, amount, tokenAmounts);
665     }
666 
667     function unbundle(address beneficiary, uint256 value) public notInLendingMode {
668         unbundleSome(beneficiary, value, _tokens);
669     }
670 
671     function unbundleSome(address beneficiary, uint256 value, ERC20[] someTokens) public notInLendingMode {
672         _unbundle(beneficiary, value, someTokens);
673     }
674 
675     // Admin methods
676 
677     function disableBundling() public onlyOwner {
678         require(_bundlingEnabled, "Bundling is already disabled");
679         _bundlingEnabled = false;
680         emit BundlingStatus(false);
681     }
682 
683     function enableBundling() public onlyOwner {
684         require(!_bundlingEnabled, "Bundling is already enabled");
685         _bundlingEnabled = true;
686         emit BundlingStatus(true);
687     }
688 
689     // Internal methods
690 
691     function _bundle(address beneficiary, uint256 amount, uint256[] tokenAmounts) internal {
692         require(amount != 0, "Bundling amount should be non-zero");
693         require(_tokens.length == tokenAmounts.length, "Lenghts of _tokens and tokenAmounts array should be equal");
694 
695         for (uint i = 0; i < _tokens.length; i++) {
696             require(tokenAmounts[i] != 0, "Token amount should be non-zero");
697             _tokens[i].checkedTransferFrom(msg.sender, this, tokenAmounts[i]);
698         }
699 
700         totalSupply_ = totalSupply_.add(amount);
701         balances[beneficiary] = balances[beneficiary].add(amount);
702         emit Bundle(msg.sender, beneficiary, amount);
703         emit Transfer(0, beneficiary, amount);
704     }
705 
706     function _unbundle(address beneficiary, uint256 value, ERC20[] someTokens) internal {
707         require(someTokens.length > 0, "Array of someTokens can't be empty");
708 
709         uint256 totalSupply = totalSupply_;
710         balances[msg.sender] = balances[msg.sender].sub(value);
711         totalSupply_ = totalSupply.sub(value);
712         emit Unbundle(msg.sender, beneficiary, value);
713         emit Transfer(msg.sender, 0, value);
714 
715         for (uint i = 0; i < someTokens.length; i++) {
716             for (uint j = 0; j < i; j++) {
717                 require(someTokens[i] != someTokens[j], "unbundleSome: should not unbundle same token multiple times");
718             }
719             uint256 tokenAmount = someTokens[i].balanceOf(this).mul(value).div(totalSupply);
720             someTokens[i].checkedTransfer(beneficiary, tokenAmount);
721         }
722     }
723 
724     // Instant Loans
725 
726     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
727         uint256 prevBalance = token.balanceOf(this);
728         token.asmTransfer(to, amount);
729         _inLendingMode += 1;
730         require(caller().makeCall.value(msg.value)(target, data), "lend: arbitrary call failed");
731         _inLendingMode -= 1;
732         require(token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
733     }
734 }
735 
736 // File: contracts/FeeBasicMultiToken.sol
737 
738 contract FeeBasicMultiToken is Ownable, BasicMultiToken {
739     using CheckedERC20 for ERC20;
740 
741     uint256 constant public TOTAL_PERCRENTS = 1000000;
742     uint256 internal _lendFee;
743 
744     function lendFee() public view returns(uint256) {
745         return _lendFee;
746     }
747 
748     function setLendFee(uint256 theLendFee) public onlyOwner {
749         require(theLendFee <= 30000, "setLendFee: fee should be not greater than 3%");
750         _lendFee = theLendFee;
751     }
752 
753     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
754         uint256 expectedBalance = token.balanceOf(this).mul(TOTAL_PERCRENTS.add(_lendFee)).div(TOTAL_PERCRENTS);
755         super.lend(to, token, amount, target, data);
756         require(token.balanceOf(this) >= expectedBalance, "lend: tokens must be returned with lend fee");
757     }
758 }
759 
760 // File: contracts/interface/IMultiToken.sol
761 
762 contract IMultiToken is IBasicMultiToken {
763     event Update();
764     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
765 
766     function weights(address _token) public view returns(uint256);
767     function changesEnabled() public view returns(bool);
768     
769     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
770     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
771 
772     // Owner methods
773     function disableChanges() public;
774 
775     bytes4 public constant InterfaceId_IMultiToken = 0x81624e24;
776 	  /**
777 	   * 0x81624e24 ===
778        *   InterfaceId_IBasicMultiToken(0xd5c368b6) ^
779 	   *   bytes4(keccak256('weights(address)')) ^
780        *   bytes4(keccak256('changesEnabled()')) ^
781        *   bytes4(keccak256('getReturn(address,address,uint256)')) ^
782 	   *   bytes4(keccak256('change(address,address,uint256,uint256)')) ^
783        *   bytes4(keccak256('disableChanges()'))
784 	   */
785 }
786 
787 // File: contracts/MultiToken.sol
788 
789 contract MultiToken is IMultiToken, BasicMultiToken {
790     using CheckedERC20 for ERC20;
791 
792     mapping(address => uint256) private _weights;
793     uint256 internal _minimalWeight;
794     bool private _changesEnabled = true;
795 
796     event ChangesDisabled();
797 
798     modifier whenChangesEnabled {
799         require(_changesEnabled, "Operation can't be performed because changes are disabled");
800         _;
801     }
802 
803     function weights(address _token) public view returns(uint256) {
804         return _weights[_token];
805     }
806 
807     function changesEnabled() public view returns(bool) {
808         return _changesEnabled;
809     }
810 
811     function init(ERC20[] tokens, uint256[] tokenWeights, string theName, string theSymbol, uint8 theDecimals) public {
812         super.init(tokens, theName, theSymbol, theDecimals);
813         require(tokenWeights.length == tokens.length, "Lenghts of tokens and tokenWeights array should be equal");
814 
815         uint256 minimalWeight = 0;
816         for (uint i = 0; i < tokens.length; i++) {
817             require(tokenWeights[i] != 0, "The tokenWeights array should not contains zeros");
818             require(_weights[tokens[i]] == 0, "The tokens array have duplicates");
819             _weights[tokens[i]] = tokenWeights[i];
820             if (minimalWeight == 0 || tokenWeights[i] < minimalWeight) {
821                 minimalWeight = tokenWeights[i];
822             }
823         }
824         _minimalWeight = minimalWeight;
825 
826         _registerInterface(InterfaceId_IMultiToken);
827     }
828 
829     function getReturn(address fromToken, address toToken, uint256 amount) public view returns(uint256 returnAmount) {
830         if (_weights[fromToken] > 0 && _weights[toToken] > 0 && fromToken != toToken) {
831             uint256 fromBalance = ERC20(fromToken).balanceOf(this);
832             uint256 toBalance = ERC20(toToken).balanceOf(this);
833             returnAmount = amount.mul(toBalance).mul(_weights[fromToken]).div(
834                 amount.mul(_weights[fromToken]).div(_minimalWeight).add(fromBalance).mul(_weights[toToken])
835             );
836         }
837     }
838 
839     function change(address fromToken, address toToken, uint256 amount, uint256 minReturn) public whenChangesEnabled notInLendingMode returns(uint256 returnAmount) {
840         returnAmount = getReturn(fromToken, toToken, amount);
841         require(returnAmount > 0, "The return amount is zero");
842         require(returnAmount >= minReturn, "The return amount is less than minReturn value");
843 
844         ERC20(fromToken).checkedTransferFrom(msg.sender, this, amount);
845         ERC20(toToken).checkedTransfer(msg.sender, returnAmount);
846 
847         emit Change(fromToken, toToken, msg.sender, amount, returnAmount);
848     }
849 
850     // Admin methods
851 
852     function disableChanges() public onlyOwner {
853         require(_changesEnabled, "Changes are already disabled");
854         _changesEnabled = false;
855         emit ChangesDisabled();
856     }
857 
858     // Internal methods
859 
860     function setWeight(address token, uint256 newWeight) internal {
861         _weights[token] = newWeight;
862     }
863 }
864 
865 // File: contracts/FeeMultiToken.sol
866 
867 contract FeeMultiToken is MultiToken, FeeBasicMultiToken {
868     using CheckedERC20 for ERC20;
869 
870     uint256 internal _changeFee;
871     uint256 internal _referralFee;
872 
873     function changeFee() public view returns(uint256) {
874         return _changeFee;
875     }
876 
877     function referralFee() public view returns(uint256) {
878         return _referralFee;
879     }
880 
881     function setChangeFee(uint256 theChangeFee) public onlyOwner {
882         require(theChangeFee <= 30000, "setChangeFee: fee should be not greater than 3%");
883         _changeFee = theChangeFee;
884     }
885 
886     function setReferralFee(uint256 theReferralFee) public onlyOwner {
887         require(theReferralFee <= 500000, "setReferralFee: fee should be not greater than 50% of changeFee");
888         _referralFee = theReferralFee;
889     }
890 
891     function getReturn(address fromToken, address toToken, uint256 amount) public view returns(uint256 returnAmount) {
892         returnAmount = super.getReturn(fromToken, toToken, amount).mul(TOTAL_PERCRENTS.sub(_changeFee)).div(TOTAL_PERCRENTS);
893     }
894 
895     function change(address fromToken, address toToken, uint256 amount, uint256 minReturn) public returns(uint256 returnAmount) {
896         returnAmount = changeWithRef(fromToken, toToken, amount, minReturn, 0);
897     }
898 
899     function changeWithRef(address fromToken, address toToken, uint256 amount, uint256 minReturn, address ref) public returns(uint256 returnAmount) {
900         returnAmount = super.change(fromToken, toToken, amount, minReturn);
901         uint256 refferalAmount = returnAmount
902             .mul(_changeFee).div(TOTAL_PERCRENTS.sub(_changeFee))
903             .mul(_referralFee).div(TOTAL_PERCRENTS);
904 
905         ERC20(toToken).checkedTransfer(ref, refferalAmount);
906     }
907 }
908 
909 // File: contracts/implementation/AstraMultiToken.sol
910 
911 contract AstraMultiToken is FeeMultiToken {
912     function init(ERC20[] tokens, uint256[] tokenWeights, string theName, string theSymbol, uint8 /*theDecimals*/) public {
913         super.init(tokens, tokenWeights, theName, theSymbol, 18);
914     }
915 }