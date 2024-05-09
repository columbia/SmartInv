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
67 // File: contracts/network/AbstractDeployer.sol
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
99 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
111     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
112     // benefit is lost if 'b' is also tested.
113     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
114     if (_a == 0) {
115       return 0;
116     }
117 
118     c = _a * _b;
119     assert(c / _a == _b);
120     return c;
121   }
122 
123   /**
124   * @dev Integer division of two numbers, truncating the quotient.
125   */
126   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
127     // assert(_b > 0); // Solidity automatically throws when dividing by 0
128     // uint256 c = _a / _b;
129     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
130     return _a / _b;
131   }
132 
133   /**
134   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
135   */
136   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
137     assert(_b <= _a);
138     return _a - _b;
139   }
140 
141   /**
142   * @dev Adds two numbers, throws on overflow.
143   */
144   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
145     c = _a + _b;
146     assert(c >= _a);
147     return c;
148   }
149 }
150 
151 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158   using SafeMath for uint256;
159 
160   mapping(address => uint256) internal balances;
161 
162   uint256 internal totalSupply_;
163 
164   /**
165   * @dev Total number of tokens in existence
166   */
167   function totalSupply() public view returns (uint256) {
168     return totalSupply_;
169   }
170 
171   /**
172   * @dev Transfer token for a specified address
173   * @param _to The address to transfer to.
174   * @param _value The amount to be transferred.
175   */
176   function transfer(address _to, uint256 _value) public returns (bool) {
177     require(_value <= balances[msg.sender]);
178     require(_to != address(0));
179 
180     balances[msg.sender] = balances[msg.sender].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     emit Transfer(msg.sender, _to, _value);
183     return true;
184   }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public view returns (uint256) {
192     return balances[_owner];
193   }
194 
195 }
196 
197 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address _owner, address _spender)
205     public view returns (uint256);
206 
207   function transferFrom(address _from, address _to, uint256 _value)
208     public returns (bool);
209 
210   function approve(address _spender, uint256 _value) public returns (bool);
211   event Approval(
212     address indexed owner,
213     address indexed spender,
214     uint256 value
215   );
216 }
217 
218 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
219 
220 /**
221  * @title Standard ERC20 token
222  *
223  * @dev Implementation of the basic standard token.
224  * https://github.com/ethereum/EIPs/issues/20
225  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
226  */
227 contract StandardToken is ERC20, BasicToken {
228 
229   mapping (address => mapping (address => uint256)) internal allowed;
230 
231 
232   /**
233    * @dev Transfer tokens from one address to another
234    * @param _from address The address which you want to send tokens from
235    * @param _to address The address which you want to transfer to
236    * @param _value uint256 the amount of tokens to be transferred
237    */
238   function transferFrom(
239     address _from,
240     address _to,
241     uint256 _value
242   )
243     public
244     returns (bool)
245   {
246     require(_value <= balances[_from]);
247     require(_value <= allowed[_from][msg.sender]);
248     require(_to != address(0));
249 
250     balances[_from] = balances[_from].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     emit Transfer(_from, _to, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     emit Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(
279     address _owner,
280     address _spender
281    )
282     public
283     view
284     returns (uint256)
285   {
286     return allowed[_owner][_spender];
287   }
288 
289   /**
290    * @dev Increase the amount of tokens that an owner allowed to a spender.
291    * approve should be called when allowed[_spender] == 0. To increment
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _addedValue The amount of tokens to increase the allowance by.
297    */
298   function increaseApproval(
299     address _spender,
300     uint256 _addedValue
301   )
302     public
303     returns (bool)
304   {
305     allowed[msg.sender][_spender] = (
306       allowed[msg.sender][_spender].add(_addedValue));
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311   /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender.
313    * approve should be called when allowed[_spender] == 0. To decrement
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _subtractedValue The amount of tokens to decrease the allowance by.
319    */
320   function decreaseApproval(
321     address _spender,
322     uint256 _subtractedValue
323   )
324     public
325     returns (bool)
326   {
327     uint256 oldValue = allowed[msg.sender][_spender];
328     if (_subtractedValue >= oldValue) {
329       allowed[msg.sender][_spender] = 0;
330     } else {
331       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332     }
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337 }
338 
339 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
340 
341 /**
342  * @title DetailedERC20 token
343  * @dev The decimals are only for visualization purposes.
344  * All the operations are done using the smallest and indivisible token unit,
345  * just as on Ethereum all the operations are done in wei.
346  */
347 contract DetailedERC20 is ERC20 {
348   string public name;
349   string public symbol;
350   uint8 public decimals;
351 
352   constructor(string _name, string _symbol, uint8 _decimals) public {
353     name = _name;
354     symbol = _symbol;
355     decimals = _decimals;
356   }
357 }
358 
359 // File: contracts/ext/CheckedERC20.sol
360 
361 library CheckedERC20 {
362     using SafeMath for uint;
363 
364     function isContract(address addr) internal view returns(bool result) {
365         // solium-disable-next-line security/no-inline-assembly
366         assembly {
367             result := gt(extcodesize(addr), 0)
368         }
369     }
370 
371     function handleReturnBool() internal pure returns(bool result) {
372         // solium-disable-next-line security/no-inline-assembly
373         assembly {
374             switch returndatasize()
375             case 0 { // not a std erc20
376                 result := 1
377             }
378             case 32 { // std erc20
379                 returndatacopy(0, 0, 32)
380                 result := mload(0)
381             }
382             default { // anything else, should revert for safety
383                 revert(0, 0)
384             }
385         }
386     }
387 
388     function handleReturnBytes32() internal pure returns(bytes32 result) {
389         // solium-disable-next-line security/no-inline-assembly
390         assembly {
391             if eq(returndatasize(), 32) { // not a std erc20
392                 returndatacopy(0, 0, 32)
393                 result := mload(0)
394             }
395             if gt(returndatasize(), 32) { // std erc20
396                 returndatacopy(0, 64, 32)
397                 result := mload(0)
398             }
399             if lt(returndatasize(), 32) { // anything else, should revert for safety
400                 revert(0, 0)
401             }
402         }
403     }
404 
405     function asmTransfer(address token, address to, uint256 value) internal returns(bool) {
406         require(isContract(token));
407         // solium-disable-next-line security/no-low-level-calls
408         require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, value));
409         return handleReturnBool();
410     }
411 
412     function asmTransferFrom(address token, address from, address to, uint256 value) internal returns(bool) {
413         require(isContract(token));
414         // solium-disable-next-line security/no-low-level-calls
415         require(token.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, to, value));
416         return handleReturnBool();
417     }
418 
419     function asmApprove(address token, address spender, uint256 value) internal returns(bool) {
420         require(isContract(token));
421         // solium-disable-next-line security/no-low-level-calls
422         require(token.call(bytes4(keccak256("approve(address,uint256)")), spender, value));
423         return handleReturnBool();
424     }
425 
426     //
427 
428     function checkedTransfer(ERC20 token, address to, uint256 value) internal {
429         if (value > 0) {
430             uint256 balance = token.balanceOf(this);
431             asmTransfer(token, to, value);
432             require(token.balanceOf(this) == balance.sub(value), "checkedTransfer: Final balance didn't match");
433         }
434     }
435 
436     function checkedTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
437         if (value > 0) {
438             uint256 toBalance = token.balanceOf(to);
439             asmTransferFrom(token, from, to, value);
440             require(token.balanceOf(to) == toBalance.add(value), "checkedTransfer: Final balance didn't match");
441         }
442     }
443 
444     //
445 
446     function asmName(address token) internal view returns(bytes32) {
447         require(isContract(token));
448         // solium-disable-next-line security/no-low-level-calls
449         require(token.call(bytes4(keccak256("name()"))));
450         return handleReturnBytes32();
451     }
452 
453     function asmSymbol(address token) internal view returns(bytes32) {
454         require(isContract(token));
455         // solium-disable-next-line security/no-low-level-calls
456         require(token.call(bytes4(keccak256("symbol()"))));
457         return handleReturnBytes32();
458     }
459 }
460 
461 // File: contracts/ext/ERC1003Token.sol
462 
463 contract ERC1003Caller is Ownable {
464     function makeCall(address target, bytes data) external payable onlyOwner returns (bool) {
465         // solium-disable-next-line security/no-call-value
466         return target.call.value(msg.value)(data);
467     }
468 }
469 
470 
471 contract ERC1003Token is ERC20 {
472     ERC1003Caller private _caller = new ERC1003Caller();
473     address[] internal _sendersStack;
474 
475     function caller() public view returns(ERC1003Caller) {
476         return _caller;
477     }
478 
479     function approveAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
480         _sendersStack.push(msg.sender);
481         approve(to, value);
482         require(_caller.makeCall.value(msg.value)(to, data));
483         _sendersStack.length -= 1;
484         return true;
485     }
486 
487     function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool) {
488         transfer(to, value);
489         require(_caller.makeCall.value(msg.value)(to, data));
490         return true;
491     }
492 
493     function transferFrom(address from, address to, uint256 value) public returns (bool) {
494         address spender = (from != address(_caller)) ? from : _sendersStack[_sendersStack.length - 1];
495         return super.transferFrom(spender, to, value);
496     }
497 }
498 
499 // File: contracts/interface/IBasicMultiToken.sol
500 
501 contract IBasicMultiToken is ERC20 {
502     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
503     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
504 
505     function tokensCount() public view returns(uint256);
506     function tokens(uint i) public view returns(ERC20);
507     
508     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
509     function bundle(address _beneficiary, uint256 _amount) public;
510 
511     function unbundle(address _beneficiary, uint256 _value) public;
512     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
513 
514     function disableBundling() public;
515     function enableBundling() public;
516 }
517 
518 // File: contracts/BasicMultiToken.sol
519 
520 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {
521     using CheckedERC20 for ERC20;
522     using CheckedERC20 for DetailedERC20;
523 
524     ERC20[] private _tokens;
525     uint private _inLendingMode;
526     bool private _bundlingEnabled = true;
527 
528     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
529     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
530     event BundlingStatus(bool enabled);
531 
532     modifier notInLendingMode {
533         require(_inLendingMode == 0, "Operation can't be performed while lending");
534         _;
535     }
536 
537     modifier whenBundlingEnabled {
538         require(_bundlingEnabled, "Bundling is disabled");
539         _;
540     }
541 
542     constructor(ERC20[] tokens, string name, string symbol, uint8 decimals)
543         public DetailedERC20(name, symbol, decimals)
544     {
545         require(decimals > 0, "constructor: _decimals should not be zero");
546         require(bytes(name).length > 0, "constructor: name should not be empty");
547         require(bytes(symbol).length > 0, "constructor: symbol should not be empty");
548         require(tokens.length >= 2, "Contract does not support less than 2 inner tokens");
549 
550         _tokens = tokens;
551     }
552 
553     function tokensCount() public view returns(uint) {
554         return _tokens.length;
555     }
556 
557     function tokens(uint i) public view returns(ERC20) {
558         return _tokens[i];
559     }
560 
561     function inLendingMode() public view returns(uint) {
562         return _inLendingMode;
563     }
564 
565     function bundlingEnabled() public view returns(bool) {
566         return _bundlingEnabled;
567     }
568 
569     function bundleFirstTokens(address beneficiary, uint256 amount, uint256[] tokenAmounts) public whenBundlingEnabled notInLendingMode {
570         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
571         _bundle(beneficiary, amount, tokenAmounts);
572     }
573 
574     function bundle(address beneficiary, uint256 amount) public whenBundlingEnabled notInLendingMode {
575         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
576         uint256[] memory tokenAmounts = new uint256[](_tokens.length);
577         for (uint i = 0; i < _tokens.length; i++) {
578             tokenAmounts[i] = _tokens[i].balanceOf(this).mul(amount).div(totalSupply_);
579         }
580         _bundle(beneficiary, amount, tokenAmounts);
581     }
582 
583     function unbundle(address beneficiary, uint256 value) public notInLendingMode {
584         unbundleSome(beneficiary, value, _tokens);
585     }
586 
587     function unbundleSome(address beneficiary, uint256 value, ERC20[] someTokens) public notInLendingMode {
588         _unbundle(beneficiary, value, someTokens);
589     }
590 
591     // Admin methods
592 
593     function disableBundling() public onlyOwner {
594         require(_bundlingEnabled, "Bundling is already disabled");
595         _bundlingEnabled = false;
596         emit BundlingStatus(false);
597     }
598 
599     function enableBundling() public onlyOwner {
600         require(!_bundlingEnabled, "Bundling is already enabled");
601         _bundlingEnabled = true;
602         emit BundlingStatus(true);
603     }
604 
605     // Internal methods
606 
607     function _bundle(address beneficiary, uint256 amount, uint256[] tokenAmounts) internal {
608         require(amount != 0, "Bundling amount should be non-zero");
609         require(_tokens.length == tokenAmounts.length, "Lenghts of _tokens and tokenAmounts array should be equal");
610 
611         for (uint i = 0; i < _tokens.length; i++) {
612             require(tokenAmounts[i] != 0, "Token amount should be non-zero");
613             _tokens[i].checkedTransferFrom(msg.sender, this, tokenAmounts[i]);
614         }
615 
616         totalSupply_ = totalSupply_.add(amount);
617         balances[beneficiary] = balances[beneficiary].add(amount);
618         emit Bundle(msg.sender, beneficiary, amount);
619         emit Transfer(0, beneficiary, amount);
620     }
621 
622     function _unbundle(address beneficiary, uint256 value, ERC20[] someTokens) internal {
623         require(someTokens.length > 0, "Array of someTokens can't be empty");
624 
625         uint256 totalSupply = totalSupply_;
626         balances[msg.sender] = balances[msg.sender].sub(value);
627         totalSupply_ = totalSupply.sub(value);
628         emit Unbundle(msg.sender, beneficiary, value);
629         emit Transfer(msg.sender, 0, value);
630 
631         for (uint i = 0; i < someTokens.length; i++) {
632             for (uint j = 0; j < i; j++) {
633                 require(someTokens[i] != someTokens[j], "unbundleSome: should not unbundle same token multiple times");
634             }
635             uint256 tokenAmount = someTokens[i].balanceOf(this).mul(value).div(totalSupply);
636             someTokens[i].checkedTransfer(beneficiary, tokenAmount);
637         }
638     }
639 
640     // Instant Loans
641 
642     function lend(address to, ERC20 token, uint256 amount, address target, bytes data) public payable {
643         uint256 prevBalance = token.balanceOf(this);
644         token.asmTransfer(to, amount);
645         _inLendingMode += 1;
646         require(caller().makeCall.value(msg.value)(target, data), "lend: arbitrary call failed");
647         _inLendingMode -= 1;
648         require(token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
649     }
650 }
651 
652 // File: contracts/network/BasicMultiTokenDeployer.sol
653 
654 contract BasicMultiTokenDeployer is AbstractDeployer {
655     function title() public view returns(string) {
656         return "BasicMultiTokenDeployer";
657     }
658 
659     function create(ERC20[] tokens, string name, string symbol, uint8 decimals)
660         external returns(address)
661     {
662         require(msg.sender == address(this), "Should be called only from deployer itself");
663         BasicMultiToken mtkn = new BasicMultiToken(tokens, name, symbol, decimals);
664         mtkn.transferOwnership(msg.sender);
665         return mtkn;
666     }
667 }