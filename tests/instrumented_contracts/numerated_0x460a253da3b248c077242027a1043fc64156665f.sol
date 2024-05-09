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
67 // File: contracts/registry/IDeployer.sol
68 
69 contract IDeployer is Ownable {
70     function deploy(bytes data) external returns(address mtkn);
71 }
72 
73 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * See https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address _who) public view returns (uint256);
83   function transfer(address _to, uint256 _value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address _owner, address _spender)
95     public view returns (uint256);
96 
97   function transferFrom(address _from, address _to, uint256 _value)
98     public returns (bool);
99 
100   function approve(address _spender, uint256 _value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
109 
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115 
116   /**
117   * @dev Multiplies two numbers, throws on overflow.
118   */
119   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
120     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
121     // benefit is lost if 'b' is also tested.
122     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
123     if (_a == 0) {
124       return 0;
125     }
126 
127     c = _a * _b;
128     assert(c / _a == _b);
129     return c;
130   }
131 
132   /**
133   * @dev Integer division of two numbers, truncating the quotient.
134   */
135   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
136     // assert(_b > 0); // Solidity automatically throws when dividing by 0
137     // uint256 c = _a / _b;
138     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
139     return _a / _b;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
146     assert(_b <= _a);
147     return _a - _b;
148   }
149 
150   /**
151   * @dev Adds two numbers, throws on overflow.
152   */
153   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
154     c = _a + _b;
155     assert(c >= _a);
156     return c;
157   }
158 }
159 
160 // File: contracts/ext/CheckedERC20.sol
161 
162 library CheckedERC20 {
163     using SafeMath for uint;
164 
165     function isContract(address addr) internal view returns(bool result) {
166         // solium-disable-next-line security/no-inline-assembly
167         assembly {
168             result := gt(extcodesize(addr), 0)
169         }
170     }
171 
172     function handleReturnBool() internal pure returns(bool result) {
173         // solium-disable-next-line security/no-inline-assembly
174         assembly {
175             switch returndatasize()
176             case 0 { // not a std erc20
177                 result := 1
178             }
179             case 32 { // std erc20
180                 returndatacopy(0, 0, 32)
181                 result := mload(0)
182             }
183             default { // anything else, should revert for safety
184                 revert(0, 0)
185             }
186         }
187     }
188 
189     function handleReturnBytes32() internal pure returns(bytes32 result) {
190         // solium-disable-next-line security/no-inline-assembly
191         assembly {
192             if eq(returndatasize(), 32) { // not a std erc20
193                 returndatacopy(0, 0, 32)
194                 result := mload(0)
195             }
196             if gt(returndatasize(), 32) { // std erc20
197                 returndatacopy(0, 64, 32)
198                 result := mload(0)
199             }
200             if lt(returndatasize(), 32) { // anything else, should revert for safety
201                 revert(0, 0)
202             }
203         }
204     }
205 
206     function asmTransfer(address _token, address _to, uint256 _value) internal returns(bool) {
207         require(isContract(_token));
208         // solium-disable-next-line security/no-low-level-calls
209         require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
210         return handleReturnBool();
211     }
212 
213     function asmTransferFrom(address _token, address _from, address _to, uint256 _value) internal returns(bool) {
214         require(isContract(_token));
215         // solium-disable-next-line security/no-low-level-calls
216         require(_token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
217         return handleReturnBool();
218     }
219 
220     function asmApprove(address _token, address _spender, uint256 _value) internal returns(bool) {
221         require(isContract(_token));
222         // solium-disable-next-line security/no-low-level-calls
223         require(_token.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
224         return handleReturnBool();
225     }
226 
227     //
228 
229     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
230         if (_value > 0) {
231             uint256 balance = _token.balanceOf(this);
232             asmTransfer(_token, _to, _value);
233             require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
234         }
235     }
236 
237     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
238         if (_value > 0) {
239             uint256 toBalance = _token.balanceOf(_to);
240             asmTransferFrom(_token, _from, _to, _value);
241             require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
242         }
243     }
244 
245     //
246 
247     function asmName(address _token) internal view returns(bytes32) {
248         require(isContract(_token));
249         // solium-disable-next-line security/no-low-level-calls
250         require(_token.call(bytes4(keccak256("name()"))));
251         return handleReturnBytes32();
252     }
253 
254     function asmSymbol(address _token) internal view returns(bytes32) {
255         require(isContract(_token));
256         // solium-disable-next-line security/no-low-level-calls
257         require(_token.call(bytes4(keccak256("symbol()"))));
258         return handleReturnBytes32();
259     }
260 }
261 
262 // File: contracts/interface/IBasicMultiToken.sol
263 
264 contract IBasicMultiToken is ERC20 {
265     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
266     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
267 
268     ERC20[] public tokens;
269 
270     function tokensCount() public view returns(uint256);
271 
272     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
273     function bundle(address _beneficiary, uint256 _amount) public;
274 
275     function unbundle(address _beneficiary, uint256 _value) public;
276     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
277 
278     function disableBundling() public;
279     function enableBundling() public;
280 }
281 
282 // File: contracts/interface/IMultiToken.sol
283 
284 contract IMultiToken is IBasicMultiToken {
285     event Update();
286     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
287 
288     mapping(address => uint256) public weights;
289 
290     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
291     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
292 
293     function disableChanges() public;
294 }
295 
296 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
297 
298 /**
299  * @title Basic token
300  * @dev Basic version of StandardToken, with no allowances.
301  */
302 contract BasicToken is ERC20Basic {
303   using SafeMath for uint256;
304 
305   mapping(address => uint256) internal balances;
306 
307   uint256 internal totalSupply_;
308 
309   /**
310   * @dev Total number of tokens in existence
311   */
312   function totalSupply() public view returns (uint256) {
313     return totalSupply_;
314   }
315 
316   /**
317   * @dev Transfer token for a specified address
318   * @param _to The address to transfer to.
319   * @param _value The amount to be transferred.
320   */
321   function transfer(address _to, uint256 _value) public returns (bool) {
322     require(_value <= balances[msg.sender]);
323     require(_to != address(0));
324 
325     balances[msg.sender] = balances[msg.sender].sub(_value);
326     balances[_to] = balances[_to].add(_value);
327     emit Transfer(msg.sender, _to, _value);
328     return true;
329   }
330 
331   /**
332   * @dev Gets the balance of the specified address.
333   * @param _owner The address to query the the balance of.
334   * @return An uint256 representing the amount owned by the passed address.
335   */
336   function balanceOf(address _owner) public view returns (uint256) {
337     return balances[_owner];
338   }
339 
340 }
341 
342 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
343 
344 /**
345  * @title Standard ERC20 token
346  *
347  * @dev Implementation of the basic standard token.
348  * https://github.com/ethereum/EIPs/issues/20
349  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
350  */
351 contract StandardToken is ERC20, BasicToken {
352 
353   mapping (address => mapping (address => uint256)) internal allowed;
354 
355 
356   /**
357    * @dev Transfer tokens from one address to another
358    * @param _from address The address which you want to send tokens from
359    * @param _to address The address which you want to transfer to
360    * @param _value uint256 the amount of tokens to be transferred
361    */
362   function transferFrom(
363     address _from,
364     address _to,
365     uint256 _value
366   )
367     public
368     returns (bool)
369   {
370     require(_value <= balances[_from]);
371     require(_value <= allowed[_from][msg.sender]);
372     require(_to != address(0));
373 
374     balances[_from] = balances[_from].sub(_value);
375     balances[_to] = balances[_to].add(_value);
376     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
377     emit Transfer(_from, _to, _value);
378     return true;
379   }
380 
381   /**
382    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
383    * Beware that changing an allowance with this method brings the risk that someone may use both the old
384    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
385    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
386    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387    * @param _spender The address which will spend the funds.
388    * @param _value The amount of tokens to be spent.
389    */
390   function approve(address _spender, uint256 _value) public returns (bool) {
391     allowed[msg.sender][_spender] = _value;
392     emit Approval(msg.sender, _spender, _value);
393     return true;
394   }
395 
396   /**
397    * @dev Function to check the amount of tokens that an owner allowed to a spender.
398    * @param _owner address The address which owns the funds.
399    * @param _spender address The address which will spend the funds.
400    * @return A uint256 specifying the amount of tokens still available for the spender.
401    */
402   function allowance(
403     address _owner,
404     address _spender
405    )
406     public
407     view
408     returns (uint256)
409   {
410     return allowed[_owner][_spender];
411   }
412 
413   /**
414    * @dev Increase the amount of tokens that an owner allowed to a spender.
415    * approve should be called when allowed[_spender] == 0. To increment
416    * allowed value is better to use this function to avoid 2 calls (and wait until
417    * the first transaction is mined)
418    * From MonolithDAO Token.sol
419    * @param _spender The address which will spend the funds.
420    * @param _addedValue The amount of tokens to increase the allowance by.
421    */
422   function increaseApproval(
423     address _spender,
424     uint256 _addedValue
425   )
426     public
427     returns (bool)
428   {
429     allowed[msg.sender][_spender] = (
430       allowed[msg.sender][_spender].add(_addedValue));
431     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
432     return true;
433   }
434 
435   /**
436    * @dev Decrease the amount of tokens that an owner allowed to a spender.
437    * approve should be called when allowed[_spender] == 0. To decrement
438    * allowed value is better to use this function to avoid 2 calls (and wait until
439    * the first transaction is mined)
440    * From MonolithDAO Token.sol
441    * @param _spender The address which will spend the funds.
442    * @param _subtractedValue The amount of tokens to decrease the allowance by.
443    */
444   function decreaseApproval(
445     address _spender,
446     uint256 _subtractedValue
447   )
448     public
449     returns (bool)
450   {
451     uint256 oldValue = allowed[msg.sender][_spender];
452     if (_subtractedValue >= oldValue) {
453       allowed[msg.sender][_spender] = 0;
454     } else {
455       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
456     }
457     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
458     return true;
459   }
460 
461 }
462 
463 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
464 
465 /**
466  * @title DetailedERC20 token
467  * @dev The decimals are only for visualization purposes.
468  * All the operations are done using the smallest and indivisible token unit,
469  * just as on Ethereum all the operations are done in wei.
470  */
471 contract DetailedERC20 is ERC20 {
472   string public name;
473   string public symbol;
474   uint8 public decimals;
475 
476   constructor(string _name, string _symbol, uint8 _decimals) public {
477     name = _name;
478     symbol = _symbol;
479     decimals = _decimals;
480   }
481 }
482 
483 // File: contracts/ext/ERC1003Token.sol
484 
485 contract ERC1003Caller is Ownable {
486     function makeCall(address _target, bytes _data) external payable onlyOwner returns (bool) {
487         // solium-disable-next-line security/no-call-value
488         return _target.call.value(msg.value)(_data);
489     }
490 }
491 
492 
493 contract ERC1003Token is ERC20 {
494     ERC1003Caller public caller_ = new ERC1003Caller();
495     address[] internal sendersStack_;
496 
497     function approveAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
498         sendersStack_.push(msg.sender);
499         approve(_to, _value);
500         require(caller_.makeCall.value(msg.value)(_to, _data));
501         sendersStack_.length -= 1;
502         return true;
503     }
504 
505     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
506         transfer(_to, _value);
507         require(caller_.makeCall.value(msg.value)(_to, _data));
508         return true;
509     }
510 
511     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
512         address from = (_from != address(caller_)) ? _from : sendersStack_[sendersStack_.length - 1];
513         return super.transferFrom(from, _to, _value);
514     }
515 }
516 
517 // File: contracts/BasicMultiToken.sol
518 
519 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {
520     using CheckedERC20 for ERC20;
521     using CheckedERC20 for DetailedERC20;
522 
523     uint internal inLendingMode;
524     bool public bundlingEnabled = true;
525 
526     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
527     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
528     event BundlingStatus(bool enabled);
529 
530     modifier notInLendingMode {
531         require(inLendingMode == 0, "Operation can't be performed while lending");
532         _;
533     }
534 
535     modifier whenBundlingEnabled {
536         require(bundlingEnabled, "Bundling is disabled");
537         _;
538     }
539 
540     constructor() public DetailedERC20("", "", 0) {
541     }
542 
543     function init(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public {
544         require(decimals == 0, "init: contract was already initialized");
545         require(_decimals > 0, "init: _decimals should not be zero");
546         require(bytes(_name).length > 0, "init: _name should not be empty");
547         require(bytes(_symbol).length > 0, "init: _symbol should not be empty");
548         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
549 
550         name = _name;
551         symbol = _symbol;
552         decimals = _decimals;
553         tokens = _tokens;
554     }
555 
556     function tokensCount() public view returns(uint) {
557         return tokens.length;
558     }
559 
560     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public whenBundlingEnabled notInLendingMode {
561         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
562         _bundle(_beneficiary, _amount, _tokenAmounts);
563     }
564 
565     function bundle(address _beneficiary, uint256 _amount) public whenBundlingEnabled notInLendingMode {
566         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
567         uint256[] memory tokenAmounts = new uint256[](tokens.length);
568         for (uint i = 0; i < tokens.length; i++) {
569             tokenAmounts[i] = tokens[i].balanceOf(this).mul(_amount).div(totalSupply_);
570         }
571         _bundle(_beneficiary, _amount, tokenAmounts);
572     }
573 
574     function unbundle(address _beneficiary, uint256 _value) public notInLendingMode {
575         unbundleSome(_beneficiary, _value, tokens);
576     }
577 
578     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public notInLendingMode {
579         require(_tokens.length > 0, "Array of tokens can't be empty");
580 
581         uint256 totalSupply = totalSupply_;
582         balances[msg.sender] = balances[msg.sender].sub(_value);
583         totalSupply_ = totalSupply.sub(_value);
584         emit Unbundle(msg.sender, _beneficiary, _value);
585         emit Transfer(msg.sender, 0, _value);
586 
587         for (uint i = 0; i < _tokens.length; i++) {
588             for (uint j = 0; j < i; j++) {
589                 require(_tokens[i] != _tokens[j], "unbundleSome: should not unbundle same token multiple times");
590             }
591             uint256 tokenAmount = _tokens[i].balanceOf(this).mul(_value).div(totalSupply);
592             _tokens[i].checkedTransfer(_beneficiary, tokenAmount);
593         }
594     }
595 
596     // Admin methods
597 
598     function disableBundling() public onlyOwner {
599         require(bundlingEnabled, "Bundling is already disabled");
600         bundlingEnabled = false;
601         emit BundlingStatus(false);
602     }
603 
604     function enableBundling() public onlyOwner {
605         require(!bundlingEnabled, "Bundling is already enabled");
606         bundlingEnabled = true;
607         emit BundlingStatus(true);
608     }
609 
610     // Internal methods
611 
612     function _bundle(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) internal {
613         require(_amount != 0, "Bundling amount should be non-zero");
614         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
615 
616         for (uint i = 0; i < tokens.length; i++) {
617             require(_tokenAmounts[i] != 0, "Token amount should be non-zero");
618             tokens[i].checkedTransferFrom(msg.sender, this, _tokenAmounts[i]);
619         }
620 
621         totalSupply_ = totalSupply_.add(_amount);
622         balances[_beneficiary] = balances[_beneficiary].add(_amount);
623         emit Bundle(msg.sender, _beneficiary, _amount);
624         emit Transfer(0, _beneficiary, _amount);
625     }
626 
627     // Instant Loans
628 
629     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
630         uint256 prevBalance = _token.balanceOf(this);
631         _token.asmTransfer(_to, _amount);
632         inLendingMode += 1;
633         require(caller_.makeCall.value(msg.value)(_target, _data), "lend: arbitrary call failed");
634         inLendingMode -= 1;
635         require(_token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
636     }
637 }
638 
639 // File: contracts/MultiToken.sol
640 
641 contract MultiToken is IMultiToken, BasicMultiToken {
642     using CheckedERC20 for ERC20;
643 
644     uint256 internal minimalWeight;
645     bool public changesEnabled = true;
646 
647     event ChangesDisabled();
648 
649     modifier whenChangesEnabled {
650         require(changesEnabled, "Operation can't be performed because changes are disabled");
651         _;
652     }
653 
654     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
655         super.init(_tokens, _name, _symbol, _decimals);
656         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
657         for (uint i = 0; i < tokens.length; i++) {
658             require(_weights[i] != 0, "The _weights array should not contains zeros");
659             require(weights[tokens[i]] == 0, "The _tokens array have duplicates");
660             weights[tokens[i]] = _weights[i];
661             if (minimalWeight == 0 || _weights[i] < minimalWeight) {
662                 minimalWeight = _weights[i];
663             }
664         }
665     }
666 
667     function init2(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
668         init(_tokens, _weights, _name, _symbol, _decimals);
669     }
670 
671     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
672         if (weights[_fromToken] > 0 && weights[_toToken] > 0 && _fromToken != _toToken) {
673             uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
674             uint256 toBalance = ERC20(_toToken).balanceOf(this);
675             returnAmount = _amount.mul(toBalance).mul(weights[_fromToken]).div(
676                 _amount.mul(weights[_fromToken]).div(minimalWeight).add(fromBalance).mul(weights[_toToken])
677             );
678         }
679     }
680 
681     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public whenChangesEnabled notInLendingMode returns(uint256 returnAmount) {
682         returnAmount = getReturn(_fromToken, _toToken, _amount);
683         require(returnAmount > 0, "The return amount is zero");
684         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
685 
686         ERC20(_fromToken).checkedTransferFrom(msg.sender, this, _amount);
687         ERC20(_toToken).checkedTransfer(msg.sender, returnAmount);
688 
689         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
690     }
691 
692     // Admin methods
693 
694     function disableChanges() public onlyOwner {
695         require(changesEnabled, "Changes are already disabled");
696         changesEnabled = false;
697         emit ChangesDisabled();
698     }
699 }
700 
701 // File: contracts/FeeMultiToken.sol
702 
703 contract FeeMultiToken is Ownable, MultiToken {
704     using CheckedERC20 for ERC20;
705 
706     uint256 public constant TOTAL_PERCRENTS = 1000000;
707     uint256 public lendFee;
708     uint256 public changeFee;
709     uint256 public refferalFee;
710 
711     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 /*_decimals*/) public {
712         super.init(_tokens, _weights, _name, _symbol, 18);
713     }
714 
715     function setLendFee(uint256 _lendFee) public onlyOwner {
716         require(_lendFee <= 30000, "setLendFee: fee should be not greater than 3%");
717         lendFee = _lendFee;
718     }
719 
720     function setChangeFee(uint256 _changeFee) public onlyOwner {
721         require(_changeFee <= 30000, "setChangeFee: fee should be not greater than 3%");
722         changeFee = _changeFee;
723     }
724 
725     function setRefferalFee(uint256 _refferalFee) public onlyOwner {
726         require(_refferalFee <= 500000, "setChangeFee: fee should be not greater than 50% of changeFee");
727         refferalFee = _refferalFee;
728     }
729 
730     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
731         returnAmount = super.getReturn(_fromToken, _toToken, _amount).mul(TOTAL_PERCRENTS.sub(changeFee)).div(TOTAL_PERCRENTS);
732     }
733 
734     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
735         returnAmount = changeWithRef(_fromToken, _toToken, _amount, _minReturn, 0);
736     }
737 
738     function changeWithRef(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn, address _ref) public returns(uint256 returnAmount) {
739         returnAmount = super.change(_fromToken, _toToken, _amount, _minReturn);
740         uint256 refferalAmount = returnAmount
741             .mul(changeFee).div(TOTAL_PERCRENTS.sub(changeFee))
742             .mul(refferalFee).div(TOTAL_PERCRENTS);
743 
744         ERC20(_toToken).checkedTransfer(_ref, refferalAmount);
745     }
746 
747     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
748         uint256 prevBalance = _token.balanceOf(this);
749         super.lend(_to, _token, _amount, _target, _data);
750         require(_token.balanceOf(this) >= prevBalance.mul(TOTAL_PERCRENTS.add(lendFee)).div(TOTAL_PERCRENTS), "lend: tokens must be returned with lend fee");
751     }
752 }