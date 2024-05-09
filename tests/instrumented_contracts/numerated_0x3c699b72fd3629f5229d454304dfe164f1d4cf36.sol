1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     c = a * b;
23     assert(c / a == b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return a / b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
49     c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 // File: contracts/ext/CheckedERC20.sol
91 
92 library CheckedERC20 {
93     using SafeMath for uint;
94 
95     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
96         if (_value == 0) {
97             return;
98         }
99         uint256 balance = _token.balanceOf(this);
100         _token.transfer(_to, _value);
101         require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
102     }
103 
104     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
105         if (_value == 0) {
106             return;
107         }
108         uint256 toBalance = _token.balanceOf(_to);
109         _token.transferFrom(_from, _to, _value);
110         require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
111     }
112 }
113 
114 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
115 
116 /**
117  * @title Ownable
118  * @dev The Ownable contract has an owner address, and provides basic authorization control
119  * functions, this simplifies the implementation of "user permissions".
120  */
121 contract Ownable {
122   address public owner;
123 
124 
125   event OwnershipRenounced(address indexed previousOwner);
126   event OwnershipTransferred(
127     address indexed previousOwner,
128     address indexed newOwner
129   );
130 
131 
132   /**
133    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
134    * account.
135    */
136   constructor() public {
137     owner = msg.sender;
138   }
139 
140   /**
141    * @dev Throws if called by any account other than the owner.
142    */
143   modifier onlyOwner() {
144     require(msg.sender == owner);
145     _;
146   }
147 
148   /**
149    * @dev Allows the current owner to relinquish control of the contract.
150    */
151   function renounceOwnership() public onlyOwner {
152     emit OwnershipRenounced(owner);
153     owner = address(0);
154   }
155 
156   /**
157    * @dev Allows the current owner to transfer control of the contract to a newOwner.
158    * @param _newOwner The address to transfer ownership to.
159    */
160   function transferOwnership(address _newOwner) public onlyOwner {
161     _transferOwnership(_newOwner);
162   }
163 
164   /**
165    * @dev Transfers control of the contract to a newOwner.
166    * @param _newOwner The address to transfer ownership to.
167    */
168   function _transferOwnership(address _newOwner) internal {
169     require(_newOwner != address(0));
170     emit OwnershipTransferred(owner, _newOwner);
171     owner = _newOwner;
172   }
173 }
174 
175 // File: contracts/ext/ERC1003Token.sol
176 
177 contract ERC1003Caller is Ownable {
178     function makeCall(address _target, bytes _data) external payable onlyOwner returns (bool) {
179         // solium-disable-next-line security/no-call-value
180         return _target.call.value(msg.value)(_data);
181     }
182 }
183 
184 contract ERC1003Token is ERC20 {
185     ERC1003Caller public caller_ = new ERC1003Caller();
186     address[] internal sendersStack_;
187 
188     function approveAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
189         sendersStack_.push(msg.sender);
190         approve(_to, _value);
191         require(caller_.makeCall.value(msg.value)(_to, _data));
192         sendersStack_.length -= 1;
193         return true;
194     }
195 
196     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
197         transfer(_to, _value);
198         require(caller_.makeCall.value(msg.value)(_to, _data));
199         return true;
200     }
201 
202     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203         address from = (_from != address(caller_)) ? _from : sendersStack_[sendersStack_.length - 1];
204         return super.transferFrom(from, _to, _value);
205     }
206 }
207 
208 // File: contracts/interface/IBasicMultiToken.sol
209 
210 contract IBasicMultiToken is ERC20 {
211     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
212     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
213 
214     function tokensCount() public view returns(uint256);
215     function tokens(uint256 _index) public view returns(ERC20);
216     function allTokens() public view returns(ERC20[]);
217     function allDecimals() public view returns(uint8[]);
218     function allBalances() public view returns(uint256[]);
219     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
220 
221     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
222     function bundle(address _beneficiary, uint256 _amount) public;
223 
224     function unbundle(address _beneficiary, uint256 _value) public;
225     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
226 
227     function denyBundling() public;
228     function allowBundling() public;
229 }
230 
231 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
232 
233 /**
234  * @title DetailedERC20 token
235  * @dev The decimals are only for visualization purposes.
236  * All the operations are done using the smallest and indivisible token unit,
237  * just as on Ethereum all the operations are done in wei.
238  */
239 contract DetailedERC20 is ERC20 {
240   string public name;
241   string public symbol;
242   uint8 public decimals;
243 
244   constructor(string _name, string _symbol, uint8 _decimals) public {
245     name = _name;
246     symbol = _symbol;
247     decimals = _decimals;
248   }
249 }
250 
251 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
252 
253 /**
254  * @title Basic token
255  * @dev Basic version of StandardToken, with no allowances.
256  */
257 contract BasicToken is ERC20Basic {
258   using SafeMath for uint256;
259 
260   mapping(address => uint256) balances;
261 
262   uint256 totalSupply_;
263 
264   /**
265   * @dev total number of tokens in existence
266   */
267   function totalSupply() public view returns (uint256) {
268     return totalSupply_;
269   }
270 
271   /**
272   * @dev transfer token for a specified address
273   * @param _to The address to transfer to.
274   * @param _value The amount to be transferred.
275   */
276   function transfer(address _to, uint256 _value) public returns (bool) {
277     require(_to != address(0));
278     require(_value <= balances[msg.sender]);
279 
280     balances[msg.sender] = balances[msg.sender].sub(_value);
281     balances[_to] = balances[_to].add(_value);
282     emit Transfer(msg.sender, _to, _value);
283     return true;
284   }
285 
286   /**
287   * @dev Gets the balance of the specified address.
288   * @param _owner The address to query the the balance of.
289   * @return An uint256 representing the amount owned by the passed address.
290   */
291   function balanceOf(address _owner) public view returns (uint256) {
292     return balances[_owner];
293   }
294 
295 }
296 
297 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
298 
299 /**
300  * @title Standard ERC20 token
301  *
302  * @dev Implementation of the basic standard token.
303  * @dev https://github.com/ethereum/EIPs/issues/20
304  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
305  */
306 contract StandardToken is ERC20, BasicToken {
307 
308   mapping (address => mapping (address => uint256)) internal allowed;
309 
310 
311   /**
312    * @dev Transfer tokens from one address to another
313    * @param _from address The address which you want to send tokens from
314    * @param _to address The address which you want to transfer to
315    * @param _value uint256 the amount of tokens to be transferred
316    */
317   function transferFrom(
318     address _from,
319     address _to,
320     uint256 _value
321   )
322     public
323     returns (bool)
324   {
325     require(_to != address(0));
326     require(_value <= balances[_from]);
327     require(_value <= allowed[_from][msg.sender]);
328 
329     balances[_from] = balances[_from].sub(_value);
330     balances[_to] = balances[_to].add(_value);
331     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
332     emit Transfer(_from, _to, _value);
333     return true;
334   }
335 
336   /**
337    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338    *
339    * Beware that changing an allowance with this method brings the risk that someone may use both the old
340    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
341    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
342    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
343    * @param _spender The address which will spend the funds.
344    * @param _value The amount of tokens to be spent.
345    */
346   function approve(address _spender, uint256 _value) public returns (bool) {
347     allowed[msg.sender][_spender] = _value;
348     emit Approval(msg.sender, _spender, _value);
349     return true;
350   }
351 
352   /**
353    * @dev Function to check the amount of tokens that an owner allowed to a spender.
354    * @param _owner address The address which owns the funds.
355    * @param _spender address The address which will spend the funds.
356    * @return A uint256 specifying the amount of tokens still available for the spender.
357    */
358   function allowance(
359     address _owner,
360     address _spender
361    )
362     public
363     view
364     returns (uint256)
365   {
366     return allowed[_owner][_spender];
367   }
368 
369   /**
370    * @dev Increase the amount of tokens that an owner allowed to a spender.
371    *
372    * approve should be called when allowed[_spender] == 0. To increment
373    * allowed value is better to use this function to avoid 2 calls (and wait until
374    * the first transaction is mined)
375    * From MonolithDAO Token.sol
376    * @param _spender The address which will spend the funds.
377    * @param _addedValue The amount of tokens to increase the allowance by.
378    */
379   function increaseApproval(
380     address _spender,
381     uint _addedValue
382   )
383     public
384     returns (bool)
385   {
386     allowed[msg.sender][_spender] = (
387       allowed[msg.sender][_spender].add(_addedValue));
388     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
389     return true;
390   }
391 
392   /**
393    * @dev Decrease the amount of tokens that an owner allowed to a spender.
394    *
395    * approve should be called when allowed[_spender] == 0. To decrement
396    * allowed value is better to use this function to avoid 2 calls (and wait until
397    * the first transaction is mined)
398    * From MonolithDAO Token.sol
399    * @param _spender The address which will spend the funds.
400    * @param _subtractedValue The amount of tokens to decrease the allowance by.
401    */
402   function decreaseApproval(
403     address _spender,
404     uint _subtractedValue
405   )
406     public
407     returns (bool)
408   {
409     uint oldValue = allowed[msg.sender][_spender];
410     if (_subtractedValue > oldValue) {
411       allowed[msg.sender][_spender] = 0;
412     } else {
413       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
414     }
415     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
416     return true;
417   }
418 
419 }
420 
421 // File: contracts/BasicMultiToken.sol
422 
423 contract BasicMultiToken is Ownable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {
424     using CheckedERC20 for ERC20;
425 
426     ERC20[] public tokens;
427     uint internal inLendingMode;
428     bool public bundlingDenied;
429 
430     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
431     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
432     event BundlingDenied(bool denied);
433 
434     modifier notInLendingMode {
435         require(inLendingMode == 0, "Operation can't be performed while lending");
436         _;
437     }
438 
439     modifier bundlingEnabled {
440         require(!bundlingDenied, "Operation can't be performed because bundling is denied");
441         _;
442     }
443 
444     constructor() public DetailedERC20("", "", 0) {
445     }
446 
447     function init(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public {
448         require(decimals == 0, "init: contract was already initialized");
449         require(_decimals > 0, "init: _decimals should not be zero");
450         require(bytes(_name).length > 0, "init: _name should not be empty");
451         require(bytes(_symbol).length > 0, "init: _symbol should not be empty");
452         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
453 
454         name = _name;
455         symbol = _symbol;
456         decimals = _decimals;
457         tokens = _tokens;
458     }
459 
460     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public bundlingEnabled notInLendingMode {
461         require(totalSupply_ == 0, "bundleFirstTokens: This method can be used with zero total supply only");
462         _bundle(_beneficiary, _amount, _tokenAmounts);
463     }
464 
465     function bundle(address _beneficiary, uint256 _amount) public bundlingEnabled notInLendingMode {
466         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
467         uint256[] memory tokenAmounts = new uint256[](tokens.length);
468         for (uint i = 0; i < tokens.length; i++) {
469             tokenAmounts[i] = tokens[i].balanceOf(this).mul(_amount).div(totalSupply_);
470         }
471         _bundle(_beneficiary, _amount, tokenAmounts);
472     }
473 
474     function unbundle(address _beneficiary, uint256 _value) public notInLendingMode {
475         unbundleSome(_beneficiary, _value, tokens);
476     }
477 
478     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public notInLendingMode {
479         require(_tokens.length > 0, "Array of tokens can't be empty");
480 
481         uint256 totalSupply = totalSupply_;
482         balances[msg.sender] = balances[msg.sender].sub(_value);
483         totalSupply_ = totalSupply.sub(_value);
484         emit Unbundle(msg.sender, _beneficiary, _value);
485         emit Transfer(msg.sender, 0, _value);
486 
487         for (uint i = 0; i < _tokens.length; i++) {
488             for (uint j = 0; j < i; j++) {
489                 require(_tokens[i] != _tokens[j], "unbundleSome: should not unbundle same token multiple times");
490             }
491             uint256 tokenAmount = _tokens[i].balanceOf(this).mul(_value).div(totalSupply);
492             _tokens[i].checkedTransfer(_beneficiary, tokenAmount);
493         }
494     }
495 
496     // Admin methods
497 
498     function denyBundling() public onlyOwner {
499         require(!bundlingDenied);
500         bundlingDenied = true;
501         emit BundlingDenied(true);
502     }
503 
504     function allowBundling() public onlyOwner {
505         require(bundlingDenied);
506         bundlingDenied = false;
507         emit BundlingDenied(false);
508     }
509 
510     // Internal methods
511 
512     function _bundle(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) internal {
513         require(_amount != 0, "Bundling amount should be non-zero");
514         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
515 
516         for (uint i = 0; i < tokens.length; i++) {
517             require(_tokenAmounts[i] != 0, "Token amount should be non-zero");
518             tokens[i].checkedTransferFrom(msg.sender, this, _tokenAmounts[i]); // Can't use require because not all ERC20 tokens return bool
519         }
520 
521         totalSupply_ = totalSupply_.add(_amount);
522         balances[_beneficiary] = balances[_beneficiary].add(_amount);
523         emit Bundle(msg.sender, _beneficiary, _amount);
524         emit Transfer(0, _beneficiary, _amount);
525     }
526 
527     // Instant Loans
528 
529     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
530         uint256 prevBalance = _token.balanceOf(this);
531         _token.transfer(_to, _amount);
532         inLendingMode += 1;
533         require(caller_.makeCall.value(msg.value)(_target, _data), "lend: arbitrary call failed");
534         inLendingMode -= 1;
535         require(_token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
536     }
537 
538     // Public Getters
539 
540     function tokensCount() public view returns(uint) {
541         return tokens.length;
542     }
543 
544     function tokens(uint _index) public view returns(ERC20) {
545         return tokens[_index];
546     }
547 
548     function allTokens() public view returns(ERC20[] _tokens) {
549         _tokens = tokens;
550     }
551 
552     function allBalances() public view returns(uint256[] _balances) {
553         _balances = new uint256[](tokens.length);
554         for (uint i = 0; i < tokens.length; i++) {
555             _balances[i] = tokens[i].balanceOf(this);
556         }
557     }
558 
559     function allDecimals() public view returns(uint8[] _decimals) {
560         _decimals = new uint8[](tokens.length);
561         for (uint i = 0; i < tokens.length; i++) {
562             _decimals[i] = DetailedERC20(tokens[i]).decimals();
563         }
564     }
565 
566     function allTokensDecimalsBalances() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances) {
567         _tokens = allTokens();
568         _decimals = allDecimals();
569         _balances = allBalances();
570     }
571 }
572 
573 // File: contracts/interface/IMultiToken.sol
574 
575 contract IMultiToken is IBasicMultiToken {
576     event Update();
577     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
578 
579     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
580     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
581 
582     function allWeights() public view returns(uint256[] _weights);
583     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
584 
585     function denyChanges() public;
586 }
587 
588 // File: contracts/MultiToken.sol
589 
590 contract MultiToken is IMultiToken, BasicMultiToken {
591     using CheckedERC20 for ERC20;
592 
593     uint256 internal minimalWeight;
594     mapping(address => uint256) public weights;
595     bool public changesDenied;
596 
597     event ChangesDenied();
598 
599     modifier changesEnabled {
600         require(!changesDenied, "Operation can't be performed because changes are denied");
601         _;
602     }
603 
604     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
605         super.init(_tokens, _name, _symbol, _decimals);
606         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
607         for (uint i = 0; i < tokens.length; i++) {
608             require(_weights[i] != 0, "The _weights array should not contains zeros");
609             require(weights[tokens[i]] == 0, "The _tokens array have duplicates");
610             weights[tokens[i]] = _weights[i];
611             if (minimalWeight == 0 || minimalWeight < _weights[i]) {
612                 minimalWeight = _weights[i];
613             }
614         }
615     }
616 
617     function init2(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
618         init(_tokens, _weights, _name, _symbol, _decimals);
619     }
620 
621     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
622         if (weights[_fromToken] > 0 && weights[_toToken] > 0 && _fromToken != _toToken) {
623             uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
624             uint256 toBalance = ERC20(_toToken).balanceOf(this);
625             returnAmount = _amount.mul(toBalance).mul(weights[_fromToken]).div(
626                 _amount.mul(weights[_fromToken]).div(minimalWeight).add(fromBalance)
627             );
628         }
629     }
630 
631     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public changesEnabled notInLendingMode returns(uint256 returnAmount) {
632         returnAmount = getReturn(_fromToken, _toToken, _amount);
633         require(returnAmount > 0, "The return amount is zero");
634         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
635 
636         ERC20(_fromToken).checkedTransferFrom(msg.sender, this, _amount);
637         ERC20(_toToken).checkedTransfer(msg.sender, returnAmount);
638 
639         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
640     }
641 
642     // Admin methods
643 
644     function denyChanges() public onlyOwner {
645         require(!changesDenied);
646         changesDenied = true;
647         emit ChangesDenied();
648     }
649 
650     // Public Getters
651 
652     function allWeights() public view returns(uint256[] _weights) {
653         _weights = new uint256[](tokens.length);
654         for (uint i = 0; i < tokens.length; i++) {
655             _weights[i] = weights[tokens[i]];
656         }
657     }
658 
659     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights) {
660         (_tokens, _decimals, _balances) = allTokensDecimalsBalances();
661         _weights = allWeights();
662     }
663 
664 }
665 
666 // File: contracts/FeeMultiToken.sol
667 
668 contract FeeMultiToken is Ownable, MultiToken {
669     using CheckedERC20 for ERC20;
670 
671     uint256 public constant TOTAL_PERCRENTS = 1000000;
672     uint256 public lendFee;
673     uint256 public changeFee;
674     uint256 public refferalFee;
675 
676     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 /*_decimals*/) public {
677         super.init(_tokens, _weights, _name, _symbol, 18);
678     }
679 
680     function setLendFee(uint256 _lendFee) public onlyOwner {
681         require(_lendFee <= 30000, "setLendFee: fee should be not greater than 3%");
682         lendFee = _lendFee;
683     }
684 
685     function setChangeFee(uint256 _changeFee) public onlyOwner {
686         require(_changeFee <= 30000, "setChangeFee: fee should be not greater than 3%");
687         changeFee = _changeFee;
688     }
689 
690     function setRefferalFee(uint256 _refferalFee) public onlyOwner {
691         require(_refferalFee <= 500000, "setChangeFee: fee should be not greater than 50% of changeFee");
692         refferalFee = _refferalFee;
693     }
694 
695     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
696         returnAmount = super.getReturn(_fromToken, _toToken, _amount).mul(TOTAL_PERCRENTS.sub(changeFee)).div(TOTAL_PERCRENTS);
697     }
698 
699     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
700         returnAmount = changeWithRef(_fromToken, _toToken, _amount, _minReturn, 0);
701     }
702 
703     function changeWithRef(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn, address _ref) public returns(uint256 returnAmount) {
704         returnAmount = super.change(_fromToken, _toToken, _amount, _minReturn);
705         uint256 refferalAmount = returnAmount
706             .mul(changeFee).div(TOTAL_PERCRENTS.sub(changeFee))
707             .mul(refferalFee).div(TOTAL_PERCRENTS);
708 
709         ERC20(_toToken).checkedTransfer(_ref, refferalAmount);
710     }
711 
712     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
713         uint256 prevBalance = _token.balanceOf(this);
714         super.lend(_to, _token, _amount, _target, _data);
715         require(_token.balanceOf(this) >= prevBalance.mul(TOTAL_PERCRENTS.add(lendFee)).div(TOTAL_PERCRENTS), "lend: tokens must be returned with lend fee");
716     }
717 }