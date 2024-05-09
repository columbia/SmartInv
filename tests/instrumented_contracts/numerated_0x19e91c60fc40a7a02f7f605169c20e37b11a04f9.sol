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
72     function createMultiToken() internal returns(address);
73 
74     function deploy(bytes data)
75         external onlyOwner returns(address result)
76     {
77         address mtkn = createMultiToken();
78         require(mtkn.call(data), 'Bad arbitrary call');
79         Ownable(mtkn).transferOwnership(msg.sender);
80         return mtkn;
81     }
82 }
83 
84 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
85 
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * See https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address _who) public view returns (uint256);
94   function transfer(address _to, uint256 _value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address _owner, address _spender)
106     public view returns (uint256);
107 
108   function transferFrom(address _from, address _to, uint256 _value)
109     public returns (bool);
110 
111   function approve(address _spender, uint256 _value) public returns (bool);
112   event Approval(
113     address indexed owner,
114     address indexed spender,
115     uint256 value
116   );
117 }
118 
119 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
120 
121 /**
122  * @title SafeMath
123  * @dev Math operations with safety checks that throw on error
124  */
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
131     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
132     // benefit is lost if 'b' is also tested.
133     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
134     if (_a == 0) {
135       return 0;
136     }
137 
138     c = _a * _b;
139     assert(c / _a == _b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
147     // assert(_b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = _a / _b;
149     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
150     return _a / _b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
157     assert(_b <= _a);
158     return _a - _b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
165     c = _a + _b;
166     assert(c >= _a);
167     return c;
168   }
169 }
170 
171 // File: contracts/ext/CheckedERC20.sol
172 
173 library CheckedERC20 {
174     using SafeMath for uint;
175 
176     function isContract(address addr) internal view returns(bool result) {
177         // solium-disable-next-line security/no-inline-assembly
178         assembly {
179             result := gt(extcodesize(addr), 0)
180         }
181     }
182 
183     function handleReturnBool() internal pure returns(bool result) {
184         // solium-disable-next-line security/no-inline-assembly
185         assembly {
186             switch returndatasize()
187             case 0 { // not a std erc20
188                 result := 1
189             }
190             case 32 { // std erc20
191                 returndatacopy(0, 0, 32)
192                 result := mload(0)
193             }
194             default { // anything else, should revert for safety
195                 revert(0, 0)
196             }
197         }
198     }
199 
200     function handleReturnBytes32() internal pure returns(bytes32 result) {
201         // solium-disable-next-line security/no-inline-assembly
202         assembly {
203             switch eq(returndatasize(), 32) // not a std erc20
204             case 1 {
205                 returndatacopy(0, 0, 32)
206                 result := mload(0)
207             }
208 
209             switch gt(returndatasize(), 32) // std erc20
210             case 1 {
211                 returndatacopy(0, 64, 32)
212                 result := mload(0)
213             }
214 
215             switch lt(returndatasize(), 32) // anything else, should revert for safety
216             case 1 {
217                 revert(0, 0)
218             }
219         }
220     }
221 
222     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
223         require(isContract(token));
224         // solium-disable-next-line security/no-low-level-calls
225         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
226         return handleReturnBool();
227     }
228 
229     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
230         require(isContract(token));
231         // solium-disable-next-line security/no-low-level-calls
232         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
233         return handleReturnBool();
234     }
235 
236     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
237         require(isContract(token));
238         // solium-disable-next-line security/no-low-level-calls
239         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
240         return handleReturnBool();
241     }
242 
243     //
244 
245     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
246         if (value > 0) {
247             uint256 balance = token.balanceOf(this);
248             asmTransfer(token, to, value);
249             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
250         }
251     }
252 
253     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
254         if (value > 0) {
255             uint256 toBalance = token.balanceOf(to);
256             asmTransferFrom(token, from, to, value);
257             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
258         }
259     }
260 
261     //
262 
263     function asmName(address token) internal view returns(bytes32) {
264         require(isContract(token));
265         // solium-disable-next-line security/no-low-level-calls
266         require(token.call(bytes4(keccak256("name()"))));
267         return handleReturnBytes32();
268     }
269 
270     function asmSymbol(address token) internal view returns(bytes32) {
271         require(isContract(token));
272         // solium-disable-next-line security/no-low-level-calls
273         require(token.call(bytes4(keccak256("symbol()"))));
274         return handleReturnBytes32();
275     }
276 }
277 
278 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
279 
280 /**
281  * @title Basic token
282  * @dev Basic version of StandardToken, with no allowances.
283  */
284 contract BasicToken is ERC20Basic {
285   using SafeMath for uint256;
286 
287   mapping(address => uint256) internal balances;
288 
289   uint256 internal totalSupply_;
290 
291   /**
292   * @dev Total number of tokens in existence
293   */
294   function totalSupply() public view returns (uint256) {
295     return totalSupply_;
296   }
297 
298   /**
299   * @dev Transfer token for a specified address
300   * @param _to The address to transfer to.
301   * @param _value The amount to be transferred.
302   */
303   function transfer(address _to, uint256 _value) public returns (bool) {
304     require(_value <= balances[msg.sender]);
305     require(_to != address(0));
306 
307     balances[msg.sender] = balances[msg.sender].sub(_value);
308     balances[_to] = balances[_to].add(_value);
309     emit Transfer(msg.sender, _to, _value);
310     return true;
311   }
312 
313   /**
314   * @dev Gets the balance of the specified address.
315   * @param _owner The address to query the the balance of.
316   * @return An uint256 representing the amount owned by the passed address.
317   */
318   function balanceOf(address _owner) public view returns (uint256) {
319     return balances[_owner];
320   }
321 
322 }
323 
324 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
325 
326 /**
327  * @title Standard ERC20 token
328  *
329  * @dev Implementation of the basic standard token.
330  * https://github.com/ethereum/EIPs/issues/20
331  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
332  */
333 contract StandardToken is ERC20, BasicToken {
334 
335   mapping (address => mapping (address => uint256)) internal allowed;
336 
337 
338   /**
339    * @dev Transfer tokens from one address to another
340    * @param _from address The address which you want to send tokens from
341    * @param _to address The address which you want to transfer to
342    * @param _value uint256 the amount of tokens to be transferred
343    */
344   function transferFrom(
345     address _from,
346     address _to,
347     uint256 _value
348   )
349     public
350     returns (bool)
351   {
352     require(_value <= balances[_from]);
353     require(_value <= allowed[_from][msg.sender]);
354     require(_to != address(0));
355 
356     balances[_from] = balances[_from].sub(_value);
357     balances[_to] = balances[_to].add(_value);
358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
359     emit Transfer(_from, _to, _value);
360     return true;
361   }
362 
363   /**
364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param _spender The address which will spend the funds.
370    * @param _value The amount of tokens to be spent.
371    */
372   function approve(address _spender, uint256 _value) public returns (bool) {
373     allowed[msg.sender][_spender] = _value;
374     emit Approval(msg.sender, _spender, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Function to check the amount of tokens that an owner allowed to a spender.
380    * @param _owner address The address which owns the funds.
381    * @param _spender address The address which will spend the funds.
382    * @return A uint256 specifying the amount of tokens still available for the spender.
383    */
384   function allowance(
385     address _owner,
386     address _spender
387    )
388     public
389     view
390     returns (uint256)
391   {
392     return allowed[_owner][_spender];
393   }
394 
395   /**
396    * @dev Increase the amount of tokens that an owner allowed to a spender.
397    * approve should be called when allowed[_spender] == 0. To increment
398    * allowed value is better to use this function to avoid 2 calls (and wait until
399    * the first transaction is mined)
400    * From MonolithDAO Token.sol
401    * @param _spender The address which will spend the funds.
402    * @param _addedValue The amount of tokens to increase the allowance by.
403    */
404   function increaseApproval(
405     address _spender,
406     uint256 _addedValue
407   )
408     public
409     returns (bool)
410   {
411     allowed[msg.sender][_spender] = (
412       allowed[msg.sender][_spender].add(_addedValue));
413     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414     return true;
415   }
416 
417   /**
418    * @dev Decrease the amount of tokens that an owner allowed to a spender.
419    * approve should be called when allowed[_spender] == 0. To decrement
420    * allowed value is better to use this function to avoid 2 calls (and wait until
421    * the first transaction is mined)
422    * From MonolithDAO Token.sol
423    * @param _spender The address which will spend the funds.
424    * @param _subtractedValue The amount of tokens to decrease the allowance by.
425    */
426   function decreaseApproval(
427     address _spender,
428     uint256 _subtractedValue
429   )
430     public
431     returns (bool)
432   {
433     uint256 oldValue = allowed[msg.sender][_spender];
434     if (_subtractedValue >= oldValue) {
435       allowed[msg.sender][_spender] = 0;
436     } else {
437       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
438     }
439     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443 }
444 
445 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
446 
447 /**
448  * @title DetailedERC20 token
449  * @dev The decimals are only for visualization purposes.
450  * All the operations are done using the smallest and indivisible token unit,
451  * just as on Ethereum all the operations are done in wei.
452  */
453 contract DetailedERC20 is ERC20 {
454   string public name;
455   string public symbol;
456   uint8 public decimals;
457 
458   constructor(string _name, string _symbol, uint8 _decimals) public {
459     name = _name;
460     symbol = _symbol;
461     decimals = _decimals;
462   }
463 }
464 
465 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
466 
467 /**
468  * @title ERC165
469  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
470  */
471 interface ERC165 {
472 
473   /**
474    * @notice Query if a contract implements an interface
475    * @param _interfaceId The interface identifier, as specified in ERC-165
476    * @dev Interface identification is specified in ERC-165. This function
477    * uses less than 30,000 gas.
478    */
479   function supportsInterface(bytes4 _interfaceId)
480     external
481     view
482     returns (bool);
483 }
484 
485 // File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol
486 
487 /**
488  * @title SupportsInterfaceWithLookup
489  * @author Matt Condon (@shrugs)
490  * @dev Implements ERC165 using a lookup table.
491  */
492 contract SupportsInterfaceWithLookup is ERC165 {
493 
494   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
495   /**
496    * 0x01ffc9a7 ===
497    *   bytes4(keccak256('supportsInterface(bytes4)'))
498    */
499 
500   /**
501    * @dev a mapping of interface id to whether or not it's supported
502    */
503   mapping(bytes4 => bool) internal supportedInterfaces;
504 
505   /**
506    * @dev A contract implementing SupportsInterfaceWithLookup
507    * implement ERC165 itself
508    */
509   constructor()
510     public
511   {
512     _registerInterface(InterfaceId_ERC165);
513   }
514 
515   /**
516    * @dev implement supportsInterface(bytes4) using a lookup table
517    */
518   function supportsInterface(bytes4 _interfaceId)
519     external
520     view
521     returns (bool)
522   {
523     return supportedInterfaces[_interfaceId];
524   }
525 
526   /**
527    * @dev private method for registering an interface
528    */
529   function _registerInterface(bytes4 _interfaceId)
530     internal
531   {
532     require(_interfaceId != 0xffffffff);
533     supportedInterfaces[_interfaceId] = true;
534   }
535 }
536 
537 // File: contracts/ext/ERC1003Token.sol
538 
539 contract ERC1003Caller is Ownable {
540     function makeCall(address target, bytes data) external payable onlyOwner returns (bool) {
541         // solium-disable-next-line security/no-call-value
542         return target.call.value(msg.value)(data);
543     }
544 }
545 
546 
547 contract ERC1003Token is ERC20 {
548     ERC1003Caller private _caller = new ERC1003Caller();
549     address[] internal _sendersStack;
550 
551     function caller() public view returns(ERC1003Caller) {
552         return _caller;
553     }
554 
555     function approveAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
556         _sendersStack.push(msg.sender);
557         approve(to, value);
558         require(_caller.makeCall.value(msg.value)(to, data));
559         _sendersStack.length -= 1;
560         return true;
561     }
562 
563     function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
564         transfer(to, value);
565         require(_caller.makeCall.value(msg.value)(to, data));
566         return true;
567     }
568 
569     function transferFrom(address from, address to, uint256 value) public returns (bool) {
570         address spender = (from != address(_caller)) ? from : _sendersStack[_sendersStack.length - 1];
571         return super.transferFrom(spender, to, value);
572     }
573 }
574 
575 // File: contracts/interface/IBasicMultiToken.sol
576 
577 contract IBasicMultiToken is ERC20 {
578     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
579     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
580 
581     function tokensCount() public view returns(uint256);
582     function tokens(uint i) public view returns(ERC20);
583     function bundlingEnabled() public view returns(bool);
584     
585     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
586     function bundle(address _beneficiary, uint256 _amount) public;
587 
588     function unbundle(address _beneficiary, uint256 _value) public;
589     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
590 
591     // Owner methods
592     function disableBundling() public;
593     function enableBundling() public;
594 
595     bytes4 public constant InterfaceId_IBasicMultiToken = 0xd5c368b6;
596 	  /**
597 	   * 0xd5c368b6 ===
598 	   *   bytes4(keccak256('tokensCount()')) ^
599 	   *   bytes4(keccak256('tokens(uint256)')) ^
600        *   bytes4(keccak256('bundlingEnabled()')) ^
601        *   bytes4(keccak256('bundleFirstTokens(address,uint256,uint256[])')) ^
602        *   bytes4(keccak256('bundle(address,uint256)')) ^
603        *   bytes4(keccak256('unbundle(address,uint256)')) ^
604        *   bytes4(keccak256('unbundleSome(address,uint256,address[])')) ^
605        *   bytes4(keccak256('disableBundling()')) ^
606        *   bytes4(keccak256('enableBundling()'))
607 	   */
608 }
609 
610 // File: contracts/BasicMultiToken.sol
611 
612 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken, SupportsInterfaceWithLookup {
613     using CheckedERC20 for ERC20;
614     using CheckedERC20 for DetailedERC20;
615 
616     ERC20[] private _tokens;
617     uint private _inLendingMode;
618     bool private _bundlingEnabled = true;
619 
620     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
621     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
622     event BundlingStatus(bool enabled);
623 
624     modifier notInLendingMode {
625         require(_inLendingMode == 0, "Operation can't be performed while lending");
626         _;
627     }
628 
629     modifier whenBundlingEnabled {
630         require(_bundlingEnabled, "Bundling is disabled");
631         _;
632     }
633 
634     constructor()
635         public DetailedERC20("", "", 0)
636     {
637     }
638 
639     function init(ERC20[] tokens, string theName, string theSymbol, uint8 theDecimals) public {
640         require(decimals == 0, "constructor: decimals should be zero");
641         require(theDecimals > 0, "constructor: _decimals should not be zero");
642         require(bytes(theName).length > 0, "constructor: name should not be empty");
643         require(bytes(theSymbol).length > 0, "constructor: symbol should not be empty");
644         require(tokens.length >= 2, "Contract does not support less than 2 inner tokens");
645 
646         name = theName;
647         symbol = theSymbol;
648         decimals = theDecimals;
649         _tokens = tokens;
650 
651         _registerInterface(InterfaceId_IBasicMultiToken);
652     }
653 
654     function tokensCount() public view returns(uint) {
655         return _tokens.length;
656     }
657 
658     function tokens(uint i) public view returns(ERC20) {
659         return _tokens[i];
660     }
661 
662     function inLendingMode() public view returns(uint) {
663         return _inLendingMode;
664     }
665 
666     function bundlingEnabled() public view returns(bool) {
667         return _bundlingEnabled;
668     }
669 
670     function bundleFirstTokens(address beneficiary, uint256 amount, uint256[] tokenAmounts) public whenBundlingEnabled notInLendingMode {
671         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
672         _bundle(beneficiary, amount, tokenAmounts);
673     }
674 
675     function bundle(address beneficiary, uint256 amount) public whenBundlingEnabled notInLendingMode {
676         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
677         uint256[] memory tokenAmounts = new uint256[](_tokens.length);
678         for (uint i = 0; i < _tokens.length; i++) {
679             tokenAmounts[i] = _tokens[i].balanceOf(this).mul(amount).div(totalSupply_);
680         }
681         _bundle(beneficiary, amount, tokenAmounts);
682     }
683 
684     function unbundle(address beneficiary, uint256 value) public notInLendingMode {
685         unbundleSome(beneficiary, value, _tokens);
686     }
687 
688     function unbundleSome(address beneficiary, uint256 value, ERC20[] someTokens) public notInLendingMode {
689         _unbundle(beneficiary, value, someTokens);
690     }
691 
692     // Admin methods
693 
694     function disableBundling() public onlyOwner {
695         require(_bundlingEnabled, "Bundling is already disabled");
696         _bundlingEnabled = false;
697         emit BundlingStatus(false);
698     }
699 
700     function enableBundling() public onlyOwner {
701         require(!_bundlingEnabled, "Bundling is already enabled");
702         _bundlingEnabled = true;
703         emit BundlingStatus(true);
704     }
705 
706     // Internal methods
707 
708     function _bundle(address beneficiary, uint256 amount, uint256[] tokenAmounts) internal {
709         require(amount != 0, "Bundling amount should be non-zero");
710         require(_tokens.length == tokenAmounts.length, "Lenghts of _tokens and tokenAmounts array should be equal");
711 
712         for (uint i = 0; i < _tokens.length; i++) {
713             require(tokenAmounts[i] != 0, "Token amount should be non-zero");
714             _tokens[i].checkedTransferFrom(msg.sender, this, tokenAmounts[i]);
715         }
716 
717         totalSupply_ = totalSupply_.add(amount);
718         balances[beneficiary] = balances[beneficiary].add(amount);
719         emit Bundle(msg.sender, beneficiary, amount);
720         emit Transfer(0, beneficiary, amount);
721     }
722 
723     function _unbundle(address beneficiary, uint256 value, ERC20[] someTokens) internal {
724         require(someTokens.length > 0, "Array of someTokens can't be empty");
725 
726         uint256 totalSupply = totalSupply_;
727         balances[msg.sender] = balances[msg.sender].sub(value);
728         totalSupply_ = totalSupply.sub(value);
729         emit Unbundle(msg.sender, beneficiary, value);
730         emit Transfer(msg.sender, 0, value);
731 
732         for (uint i = 0; i < someTokens.length; i++) {
733             for (uint j = 0; j < i; j++) {
734                 require(someTokens[i] != someTokens[j], "unbundleSome: should not unbundle same token multiple times");
735             }
736             uint256 tokenAmount = someTokens[i].balanceOf(this).mul(value).div(totalSupply);
737             someTokens[i].checkedTransfer(beneficiary, tokenAmount);
738         }
739     }
740 
741     // Instant Loans
742 
743     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
744         uint256 prevBalance = token.balanceOf(this);
745         token.asmTransfer(to, amount);
746         _inLendingMode += 1;
747         require(caller().makeCall.value(msg.value)(target, data), "lend: arbitrary call failed");
748         _inLendingMode -= 1;
749         require(token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
750     }
751 }
752 
753 // File: contracts/FeeBasicMultiToken.sol
754 
755 contract FeeBasicMultiToken is Ownable, BasicMultiToken {
756     using CheckedERC20 for ERC20;
757 
758     uint256 constant public TOTAL_PERCRENTS = 1000000;
759     uint256 internal _lendFee;
760 
761     function lendFee() public view returns(uint256) {
762         return _lendFee;
763     }
764 
765     function setLendFee(uint256 theLendFee) public onlyOwner {
766         require(theLendFee <= 30000, "setLendFee: fee should be not greater than 3%");
767         _lendFee = theLendFee;
768     }
769 
770     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
771         uint256 expectedBalance = token.balanceOf(this).mul(TOTAL_PERCRENTS.add(_lendFee)).div(TOTAL_PERCRENTS);
772         super.lend(to, token, amount, target, data);
773         require(token.balanceOf(this) >= expectedBalance, "lend: tokens must be returned with lend fee");
774     }
775 }
776 
777 // File: contracts/implementation/AstraBasicMultiToken.sol
778 
779 contract AstraBasicMultiToken is FeeBasicMultiToken {
780     function init(ERC20[] tokens, string theName, string theSymbol, uint8 /*theDecimals*/) public {
781         super.init(tokens, theName, theSymbol, 18);
782     }
783 }
784 
785 // File: contracts/implementation/deployers/AstraBasicMultiTokenDeployer.sol
786 
787 contract AstraBasicMultiTokenDeployer is AbstractDeployer {
788     function title() public view returns(string) {
789         return "AstraBasicMultiTokenDeployer";
790     }
791 
792     function createMultiToken() internal returns(address) {
793         return new AstraBasicMultiToken();
794     }
795 }