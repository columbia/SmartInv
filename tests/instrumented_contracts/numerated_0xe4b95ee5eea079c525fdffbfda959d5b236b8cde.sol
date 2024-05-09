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
67 // File: contracts/AbstractDeployer.sol
68 
69 contract AbstractDeployer is Ownable {
70     function title() public view returns(string);
71 
72     function deploy(bytes data)
73         external onlyOwner returns(address result)
74     {
75         // solium-disable-next-line security/no-low-level-calls
76         require(address(this).call(data), "Arbitrary call failed");
77         // solium-disable-next-line security/no-inline-assembly
78         assembly {
79             returndatacopy(0, 0, 32)
80             result := mload(0)
81         }
82     }
83 }
84 
85 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * See https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address _who) public view returns (uint256);
95   function transfer(address _to, uint256 _value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 is ERC20Basic {
106   function allowance(address _owner, address _spender)
107     public view returns (uint256);
108 
109   function transferFrom(address _from, address _to, uint256 _value)
110     public returns (bool);
111 
112   function approve(address _spender, uint256 _value) public returns (bool);
113   event Approval(
114     address indexed owner,
115     address indexed spender,
116     uint256 value
117   );
118 }
119 
120 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
121 
122 /**
123  * @title SafeMath
124  * @dev Math operations with safety checks that throw on error
125  */
126 library SafeMath {
127 
128   /**
129   * @dev Multiplies two numbers, throws on overflow.
130   */
131   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
132     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
133     // benefit is lost if 'b' is also tested.
134     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
135     if (_a == 0) {
136       return 0;
137     }
138 
139     c = _a * _b;
140     assert(c / _a == _b);
141     return c;
142   }
143 
144   /**
145   * @dev Integer division of two numbers, truncating the quotient.
146   */
147   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
148     // assert(_b > 0); // Solidity automatically throws when dividing by 0
149     // uint256 c = _a / _b;
150     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
151     return _a / _b;
152   }
153 
154   /**
155   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
156   */
157   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
158     assert(_b <= _a);
159     return _a - _b;
160   }
161 
162   /**
163   * @dev Adds two numbers, throws on overflow.
164   */
165   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
166     c = _a + _b;
167     assert(c >= _a);
168     return c;
169   }
170 }
171 
172 // File: contracts/ext/CheckedERC20.sol
173 
174 library CheckedERC20 {
175     using SafeMath for uint;
176 
177     function isContract(address addr) internal view returns(bool result) {
178         // solium-disable-next-line security/no-inline-assembly
179         assembly {
180             result := gt(extcodesize(addr), 0)
181         }
182     }
183 
184     function handleReturnBool() internal pure returns(bool result) {
185         // solium-disable-next-line security/no-inline-assembly
186         assembly {
187             switch returndatasize()
188             case 0 { // not a std erc20
189                 result := 1
190             }
191             case 32 { // std erc20
192                 returndatacopy(0, 0, 32)
193                 result := mload(0)
194             }
195             default { // anything else, should revert for safety
196                 revert(0, 0)
197             }
198         }
199     }
200 
201     function handleReturnBytes32() internal pure returns(bytes32 result) {
202         // solium-disable-next-line security/no-inline-assembly
203         assembly {
204             switch eq(returndatasize(), 32) // not a std erc20
205             case 1 {
206                 returndatacopy(0, 0, 32)
207                 result := mload(0)
208             }
209 
210             switch gt(returndatasize(), 32) // std erc20
211             case 1 {
212                 returndatacopy(0, 64, 32)
213                 result := mload(0)
214             }
215 
216             switch lt(returndatasize(), 32) // anything else, should revert for safety
217             case 1 {
218                 revert(0, 0)
219             }
220         }
221     }
222 
223     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
224         require(isContract(token));
225         // solium-disable-next-line security/no-low-level-calls
226         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
227         return handleReturnBool();
228     }
229 
230     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
231         require(isContract(token));
232         // solium-disable-next-line security/no-low-level-calls
233         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
234         return handleReturnBool();
235     }
236 
237     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
238         require(isContract(token));
239         // solium-disable-next-line security/no-low-level-calls
240         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
241         return handleReturnBool();
242     }
243 
244     //
245 
246     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
247         if (value > 0) {
248             uint256 balance = token.balanceOf(this);
249             asmTransfer(token, to, value);
250             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
251         }
252     }
253 
254     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
255         if (value > 0) {
256             uint256 toBalance = token.balanceOf(to);
257             asmTransferFrom(token, from, to, value);
258             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
259         }
260     }
261 
262     //
263 
264     function asmName(address token) internal view returns(bytes32) {
265         require(isContract(token));
266         // solium-disable-next-line security/no-low-level-calls
267         require(token.call(bytes4(keccak256("name()"))));
268         return handleReturnBytes32();
269     }
270 
271     function asmSymbol(address token) internal view returns(bytes32) {
272         require(isContract(token));
273         // solium-disable-next-line security/no-low-level-calls
274         require(token.call(bytes4(keccak256("symbol()"))));
275         return handleReturnBytes32();
276     }
277 }
278 
279 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
280 
281 /**
282  * @title Basic token
283  * @dev Basic version of StandardToken, with no allowances.
284  */
285 contract BasicToken is ERC20Basic {
286   using SafeMath for uint256;
287 
288   mapping(address => uint256) internal balances;
289 
290   uint256 internal totalSupply_;
291 
292   /**
293   * @dev Total number of tokens in existence
294   */
295   function totalSupply() public view returns (uint256) {
296     return totalSupply_;
297   }
298 
299   /**
300   * @dev Transfer token for a specified address
301   * @param _to The address to transfer to.
302   * @param _value The amount to be transferred.
303   */
304   function transfer(address _to, uint256 _value) public returns (bool) {
305     require(_value <= balances[msg.sender]);
306     require(_to != address(0));
307 
308     balances[msg.sender] = balances[msg.sender].sub(_value);
309     balances[_to] = balances[_to].add(_value);
310     emit Transfer(msg.sender, _to, _value);
311     return true;
312   }
313 
314   /**
315   * @dev Gets the balance of the specified address.
316   * @param _owner The address to query the the balance of.
317   * @return An uint256 representing the amount owned by the passed address.
318   */
319   function balanceOf(address _owner) public view returns (uint256) {
320     return balances[_owner];
321   }
322 
323 }
324 
325 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
326 
327 /**
328  * @title Standard ERC20 token
329  *
330  * @dev Implementation of the basic standard token.
331  * https://github.com/ethereum/EIPs/issues/20
332  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
333  */
334 contract StandardToken is ERC20, BasicToken {
335 
336   mapping (address => mapping (address => uint256)) internal allowed;
337 
338 
339   /**
340    * @dev Transfer tokens from one address to another
341    * @param _from address The address which you want to send tokens from
342    * @param _to address The address which you want to transfer to
343    * @param _value uint256 the amount of tokens to be transferred
344    */
345   function transferFrom(
346     address _from,
347     address _to,
348     uint256 _value
349   )
350     public
351     returns (bool)
352   {
353     require(_value <= balances[_from]);
354     require(_value <= allowed[_from][msg.sender]);
355     require(_to != address(0));
356 
357     balances[_from] = balances[_from].sub(_value);
358     balances[_to] = balances[_to].add(_value);
359     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
360     emit Transfer(_from, _to, _value);
361     return true;
362   }
363 
364   /**
365    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370    * @param _spender The address which will spend the funds.
371    * @param _value The amount of tokens to be spent.
372    */
373   function approve(address _spender, uint256 _value) public returns (bool) {
374     allowed[msg.sender][_spender] = _value;
375     emit Approval(msg.sender, _spender, _value);
376     return true;
377   }
378 
379   /**
380    * @dev Function to check the amount of tokens that an owner allowed to a spender.
381    * @param _owner address The address which owns the funds.
382    * @param _spender address The address which will spend the funds.
383    * @return A uint256 specifying the amount of tokens still available for the spender.
384    */
385   function allowance(
386     address _owner,
387     address _spender
388    )
389     public
390     view
391     returns (uint256)
392   {
393     return allowed[_owner][_spender];
394   }
395 
396   /**
397    * @dev Increase the amount of tokens that an owner allowed to a spender.
398    * approve should be called when allowed[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param _spender The address which will spend the funds.
403    * @param _addedValue The amount of tokens to increase the allowance by.
404    */
405   function increaseApproval(
406     address _spender,
407     uint256 _addedValue
408   )
409     public
410     returns (bool)
411   {
412     allowed[msg.sender][_spender] = (
413       allowed[msg.sender][_spender].add(_addedValue));
414     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418   /**
419    * @dev Decrease the amount of tokens that an owner allowed to a spender.
420    * approve should be called when allowed[_spender] == 0. To decrement
421    * allowed value is better to use this function to avoid 2 calls (and wait until
422    * the first transaction is mined)
423    * From MonolithDAO Token.sol
424    * @param _spender The address which will spend the funds.
425    * @param _subtractedValue The amount of tokens to decrease the allowance by.
426    */
427   function decreaseApproval(
428     address _spender,
429     uint256 _subtractedValue
430   )
431     public
432     returns (bool)
433   {
434     uint256 oldValue = allowed[msg.sender][_spender];
435     if (_subtractedValue >= oldValue) {
436       allowed[msg.sender][_spender] = 0;
437     } else {
438       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
439     }
440     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
441     return true;
442   }
443 
444 }
445 
446 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
447 
448 /**
449  * @title DetailedERC20 token
450  * @dev The decimals are only for visualization purposes.
451  * All the operations are done using the smallest and indivisible token unit,
452  * just as on Ethereum all the operations are done in wei.
453  */
454 contract DetailedERC20 is ERC20 {
455   string public name;
456   string public symbol;
457   uint8 public decimals;
458 
459   constructor(string _name, string _symbol, uint8 _decimals) public {
460     name = _name;
461     symbol = _symbol;
462     decimals = _decimals;
463   }
464 }
465 
466 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
467 
468 /**
469  * @title ERC165
470  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
471  */
472 interface ERC165 {
473 
474   /**
475    * @notice Query if a contract implements an interface
476    * @param _interfaceId The interface identifier, as specified in ERC-165
477    * @dev Interface identification is specified in ERC-165. This function
478    * uses less than 30,000 gas.
479    */
480   function supportsInterface(bytes4 _interfaceId)
481     external
482     view
483     returns (bool);
484 }
485 
486 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
487 
488 /**
489  * @title SupportsInterfaceWithLookup
490  * @author Matt Condon (@shrugs)
491  * @dev Implements ERC165 using a lookup table.
492  */
493 contract SupportsInterfaceWithLookup is ERC165 {
494 
495   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
496   /**
497    * 0x01ffc9a7 ===
498    *   bytes4(keccak256('supportsInterface(bytes4)'))
499    */
500 
501   /**
502    * @dev a mapping of interface id to whether or not it's supported
503    */
504   mapping(bytes4 => bool) internal supportedInterfaces;
505 
506   /**
507    * @dev A contract implementing SupportsInterfaceWithLookup
508    * implement ERC165 itself
509    */
510   constructor()
511     public
512   {
513     _registerInterface(InterfaceId_ERC165);
514   }
515 
516   /**
517    * @dev implement supportsInterface(bytes4) using a lookup table
518    */
519   function supportsInterface(bytes4 _interfaceId)
520     external
521     view
522     returns (bool)
523   {
524     return supportedInterfaces[_interfaceId];
525   }
526 
527   /**
528    * @dev private method for registering an interface
529    */
530   function _registerInterface(bytes4 _interfaceId)
531     internal
532   {
533     require(_interfaceId != 0xffffffff);
534     supportedInterfaces[_interfaceId] = true;
535   }
536 }
537 
538 // File: contracts/ext/ERC1003Token.sol
539 
540 contract ERC1003Caller is Ownable {
541     function makeCall(address target, bytes data) external payable onlyOwner returns (bool) {
542         // solium-disable-next-line security/no-call-value
543         return target.call.value(msg.value)(data);
544     }
545 }
546 
547 
548 contract ERC1003Token is ERC20 {
549     ERC1003Caller private _caller = new ERC1003Caller();
550     address[] internal _sendersStack;
551 
552     function caller() public view returns(ERC1003Caller) {
553         return _caller;
554     }
555 
556     function approveAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
557         _sendersStack.push(msg.sender);
558         approve(to, value);
559         require(_caller.makeCall.value(msg.value)(to, data));
560         _sendersStack.length -= 1;
561         return true;
562     }
563 
564     function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
565         transfer(to, value);
566         require(_caller.makeCall.value(msg.value)(to, data));
567         return true;
568     }
569 
570     function transferFrom(address from, address to, uint256 value) public returns (bool) {
571         address spender = (from != address(_caller)) ? from : _sendersStack[_sendersStack.length - 1];
572         return super.transferFrom(spender, to, value);
573     }
574 }
575 
576 // File: contracts/interface/IBasicMultiToken.sol
577 
578 contract IBasicMultiToken is ERC20 {
579     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
580     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
581 
582     function tokensCount() public view returns(uint256);
583     function tokens(uint i) public view returns(ERC20);
584     function bundlingEnabled() public view returns(bool);
585     
586     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
587     function bundle(address _beneficiary, uint256 _amount) public;
588 
589     function unbundle(address _beneficiary, uint256 _value) public;
590     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
591 
592     // Owner methods
593     function disableBundling() public;
594     function enableBundling() public;
595 
596     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
597 	  /**
598 	   * 0xd5c368b6 ===
599 	   *   bytes4(keccak256('tokensCount()')) ^
600 	   *   bytes4(keccak256('tokens(uint256)')) ^
601        *   bytes4(keccak256('bundlingEnabled()')) ^
602        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
603        *   bytes4(keccak256('bundle(address,uint256)')) ^
604        *   bytes4(keccak256('unbundle(address,uint256)')) ^
605        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
606        *   bytes4(keccak256('disableBundling()')) ^
607        *   bytes4(keccak256('enableBundling()'))
608 	   */
609 }
610 
611 // File: contracts/BasicMultiToken.sol
612 
613 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken, SupportsInterfaceWithLookup {
614     using CheckedERC20 for ERC20;
615     using CheckedERC20 for DetailedERC20;
616 
617     ERC20[] private _tokens;
618     uint private _inLendingMode;
619     bool private _bundlingEnabled = true;
620 
621     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
622     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
623     event BundlingStatus(bool enabled);
624 
625     modifier notInLendingMode {
626         require(_inLendingMode == 0, "Operation can't be performed while lending");
627         _;
628     }
629 
630     modifier whenBundlingEnabled {
631         require(_bundlingEnabled, "Bundling is disabled");
632         _;
633     }
634 
635     constructor(ERC20[] tokens, string name, string symbol, uint8 decimals)
636         public DetailedERC20(name, symbol, decimals)
637     {
638         require(decimals > 0, "constructor: _decimals should not be zero");
639         require(bytes(name).length > 0, "constructor: name should not be empty");
640         require(bytes(symbol).length > 0, "constructor: symbol should not be empty");
641         require(tokens.length >= 2, "Contract does not support less than 2 inner tokens");
642 
643         _tokens = tokens;
644 
645         _registerInterface(InterfaceId_IBasicMultiToken);
646     }
647 
648     function tokensCount() public view returns(uint) {
649         return _tokens.length;
650     }
651 
652     function tokens(uint i) public view returns(ERC20) {
653         return _tokens[i];
654     }
655 
656     function inLendingMode() public view returns(uint) {
657         return _inLendingMode;
658     }
659 
660     function bundlingEnabled() public view returns(bool) {
661         return _bundlingEnabled;
662     }
663 
664     function bundleFirstTokens(address beneficiary, uint256 amount, uint256[] tokenAmounts) public whenBundlingEnabled notInLendingMode {
665         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
666         _bundle(beneficiary, amount, tokenAmounts);
667     }
668 
669     function bundle(address beneficiary, uint256 amount) public whenBundlingEnabled notInLendingMode {
670         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
671         uint256[] memory tokenAmounts = new uint256[](_tokens.length);
672         for (uint i = 0; i < _tokens.length; i++) {
673             tokenAmounts[i] = _tokens[i].balanceOf(this).mul(amount).div(totalSupply_);
674         }
675         _bundle(beneficiary, amount, tokenAmounts);
676     }
677 
678     function unbundle(address beneficiary, uint256 value) public notInLendingMode {
679         unbundleSome(beneficiary, value, _tokens);
680     }
681 
682     function unbundleSome(address beneficiary, uint256 value, ERC20[] someTokens) public notInLendingMode {
683         _unbundle(beneficiary, value, someTokens);
684     }
685 
686     // Admin methods
687 
688     function disableBundling() public onlyOwner {
689         require(_bundlingEnabled, "Bundling is already disabled");
690         _bundlingEnabled = false;
691         emit BundlingStatus(false);
692     }
693 
694     function enableBundling() public onlyOwner {
695         require(!_bundlingEnabled, "Bundling is already enabled");
696         _bundlingEnabled = true;
697         emit BundlingStatus(true);
698     }
699 
700     // Internal methods
701 
702     function _bundle(address beneficiary, uint256 amount, uint256[] tokenAmounts) internal {
703         require(amount != 0, "Bundling amount should be non-zero");
704         require(_tokens.length == tokenAmounts.length, "Lenghts of _tokens and tokenAmounts array should be equal");
705 
706         for (uint i = 0; i < _tokens.length; i++) {
707             require(tokenAmounts[i] != 0, "Token amount should be non-zero");
708             _tokens[i].checkedTransferFrom(msg.sender, this, tokenAmounts[i]);
709         }
710 
711         totalSupply_ = totalSupply_.add(amount);
712         balances[beneficiary] = balances[beneficiary].add(amount);
713         emit Bundle(msg.sender, beneficiary, amount);
714         emit Transfer(0, beneficiary, amount);
715     }
716 
717     function _unbundle(address beneficiary, uint256 value, ERC20[] someTokens) internal {
718         require(someTokens.length > 0, "Array of someTokens can't be empty");
719 
720         uint256 totalSupply = totalSupply_;
721         balances[msg.sender] = balances[msg.sender].sub(value);
722         totalSupply_ = totalSupply.sub(value);
723         emit Unbundle(msg.sender, beneficiary, value);
724         emit Transfer(msg.sender, 0, value);
725 
726         for (uint i = 0; i < someTokens.length; i++) {
727             for (uint j = 0; j < i; j++) {
728                 require(someTokens[i] != someTokens[j], "unbundleSome: should not unbundle same token multiple times");
729             }
730             uint256 tokenAmount = someTokens[i].balanceOf(this).mul(value).div(totalSupply);
731             someTokens[i].checkedTransfer(beneficiary, tokenAmount);
732         }
733     }
734 
735     // Instant Loans
736 
737     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
738         uint256 prevBalance = token.balanceOf(this);
739         token.asmTransfer(to, amount);
740         _inLendingMode += 1;
741         require(caller().makeCall.value(msg.value)(target, data), "lend: arbitrary call failed");
742         _inLendingMode -= 1;
743         require(token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
744     }
745 }
746 
747 // File: contracts/FeeBasicMultiToken.sol
748 
749 contract FeeBasicMultiToken is Ownable, BasicMultiToken {
750     using CheckedERC20 for ERC20;
751 
752     uint256 constant public TOTAL_PERCRENTS = 1000000;
753     uint256 internal _lendFee;
754 
755     function lendFee() public view returns(uint256) {
756         return _lendFee;
757     }
758 
759     function setLendFee(uint256 theLendFee) public onlyOwner {
760         require(theLendFee <= 30000, "setLendFee: fee should be not greater than 3%");
761         _lendFee = theLendFee;
762     }
763 
764     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
765         uint256 expectedBalance = token.balanceOf(this).mul(TOTAL_PERCRENTS.add(_lendFee)).div(TOTAL_PERCRENTS);
766         super.lend(to, token, amount, target, data);
767         require(token.balanceOf(this) >= expectedBalance, "lend: tokens must be returned with lend fee");
768     }
769 }
770 
771 // File: contracts/implementation/AstraBasicMultiToken.sol
772 
773 contract AstraBasicMultiToken is FeeBasicMultiToken {
774     constructor(ERC20[] tokens, string name, string symbol, uint8 decimals)
775         public BasicMultiToken(tokens, name, symbol, decimals)
776     {
777     }
778 }
779 
780 // File: contracts/implementation/deployers/AstraBasicMultiTokenDeployer.sol
781 
782 contract AstraBasicMultiTokenDeployer is AbstractDeployer {
783     function title() public view returns(string) {
784         return "AstraBasicMultiTokenDeployer";
785     }
786 
787     function create(ERC20[] tokens, string name, string symbol)
788         external returns(address)
789     {
790         require(msg.sender == address(this), "Should be called only from deployer itself");
791         AstraBasicMultiToken mtkn = new AstraBasicMultiToken(tokens, name, symbol, 18);
792         mtkn.transferOwnership(msg.sender);
793         return mtkn;
794     }
795 }