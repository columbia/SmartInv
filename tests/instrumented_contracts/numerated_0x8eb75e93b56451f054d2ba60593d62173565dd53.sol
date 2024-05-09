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
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender)
86     public view returns (uint256);
87 
88   function transferFrom(address from, address to, uint256 value)
89     public returns (bool);
90 
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(
93     address indexed owner,
94     address indexed spender,
95     uint256 value
96   );
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
110   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
112     // benefit is lost if 'b' is also tested.
113     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
114     if (a == 0) {
115       return 0;
116     }
117 
118     c = a * b;
119     assert(c / a == b);
120     return c;
121   }
122 
123   /**
124   * @dev Integer division of two numbers, truncating the quotient.
125   */
126   function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     // uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130     return a / b;
131   }
132 
133   /**
134   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
135   */
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     assert(b <= a);
138     return a - b;
139   }
140 
141   /**
142   * @dev Adds two numbers, throws on overflow.
143   */
144   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
145     c = a + b;
146     assert(c >= a);
147     return c;
148   }
149 }
150 
151 // File: contracts/ext/CheckedERC20.sol
152 
153 library CheckedERC20 {
154     using SafeMath for uint;
155 
156     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
157         if (_value == 0) {
158             return;
159         }
160         uint256 balance = _token.balanceOf(this);
161         _token.transfer(_to, _value);
162         require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
163     }
164 
165     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
166         if (_value == 0) {
167             return;
168         }
169         uint256 toBalance = _token.balanceOf(_to);
170         _token.transferFrom(_from, _to, _value);
171         require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
172     }
173 }
174 
175 // File: contracts/interface/IBasicMultiToken.sol
176 
177 contract IBasicMultiToken is ERC20 {
178     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
179     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
180 
181     function tokensCount() public view returns(uint256);
182     function tokens(uint256 _index) public view returns(ERC20);
183     function allTokens() public view returns(ERC20[]);
184     function allDecimals() public view returns(uint8[]);
185     function allBalances() public view returns(uint256[]);
186     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
187 
188     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
189     function bundle(address _beneficiary, uint256 _amount) public;
190 
191     function unbundle(address _beneficiary, uint256 _value) public;
192     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
193 }
194 
195 // File: contracts/interface/IMultiToken.sol
196 
197 contract IMultiToken is IBasicMultiToken {
198     event Update();
199     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
200 
201     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
202     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
203 
204     function allWeights() public view returns(uint256[] _weights);
205     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
206 }
207 
208 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
209 
210 /**
211  * @title Pausable
212  * @dev Base contract which allows children to implement an emergency stop mechanism.
213  */
214 contract Pausable is Ownable {
215   event Pause();
216   event Unpause();
217 
218   bool public paused = false;
219 
220 
221   /**
222    * @dev Modifier to make a function callable only when the contract is not paused.
223    */
224   modifier whenNotPaused() {
225     require(!paused);
226     _;
227   }
228 
229   /**
230    * @dev Modifier to make a function callable only when the contract is paused.
231    */
232   modifier whenPaused() {
233     require(paused);
234     _;
235   }
236 
237   /**
238    * @dev called by the owner to pause, triggers stopped state
239    */
240   function pause() onlyOwner whenNotPaused public {
241     paused = true;
242     emit Pause();
243   }
244 
245   /**
246    * @dev called by the owner to unpause, returns to normal state
247    */
248   function unpause() onlyOwner whenPaused public {
249     paused = false;
250     emit Unpause();
251   }
252 }
253 
254 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
255 
256 /**
257  * @title Basic token
258  * @dev Basic version of StandardToken, with no allowances.
259  */
260 contract BasicToken is ERC20Basic {
261   using SafeMath for uint256;
262 
263   mapping(address => uint256) balances;
264 
265   uint256 totalSupply_;
266 
267   /**
268   * @dev total number of tokens in existence
269   */
270   function totalSupply() public view returns (uint256) {
271     return totalSupply_;
272   }
273 
274   /**
275   * @dev transfer token for a specified address
276   * @param _to The address to transfer to.
277   * @param _value The amount to be transferred.
278   */
279   function transfer(address _to, uint256 _value) public returns (bool) {
280     require(_to != address(0));
281     require(_value <= balances[msg.sender]);
282 
283     balances[msg.sender] = balances[msg.sender].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     emit Transfer(msg.sender, _to, _value);
286     return true;
287   }
288 
289   /**
290   * @dev Gets the balance of the specified address.
291   * @param _owner The address to query the the balance of.
292   * @return An uint256 representing the amount owned by the passed address.
293   */
294   function balanceOf(address _owner) public view returns (uint256) {
295     return balances[_owner];
296   }
297 
298 }
299 
300 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
301 
302 /**
303  * @title Standard ERC20 token
304  *
305  * @dev Implementation of the basic standard token.
306  * @dev https://github.com/ethereum/EIPs/issues/20
307  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
308  */
309 contract StandardToken is ERC20, BasicToken {
310 
311   mapping (address => mapping (address => uint256)) internal allowed;
312 
313 
314   /**
315    * @dev Transfer tokens from one address to another
316    * @param _from address The address which you want to send tokens from
317    * @param _to address The address which you want to transfer to
318    * @param _value uint256 the amount of tokens to be transferred
319    */
320   function transferFrom(
321     address _from,
322     address _to,
323     uint256 _value
324   )
325     public
326     returns (bool)
327   {
328     require(_to != address(0));
329     require(_value <= balances[_from]);
330     require(_value <= allowed[_from][msg.sender]);
331 
332     balances[_from] = balances[_from].sub(_value);
333     balances[_to] = balances[_to].add(_value);
334     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
335     emit Transfer(_from, _to, _value);
336     return true;
337   }
338 
339   /**
340    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
341    *
342    * Beware that changing an allowance with this method brings the risk that someone may use both the old
343    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
344    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
345    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
346    * @param _spender The address which will spend the funds.
347    * @param _value The amount of tokens to be spent.
348    */
349   function approve(address _spender, uint256 _value) public returns (bool) {
350     allowed[msg.sender][_spender] = _value;
351     emit Approval(msg.sender, _spender, _value);
352     return true;
353   }
354 
355   /**
356    * @dev Function to check the amount of tokens that an owner allowed to a spender.
357    * @param _owner address The address which owns the funds.
358    * @param _spender address The address which will spend the funds.
359    * @return A uint256 specifying the amount of tokens still available for the spender.
360    */
361   function allowance(
362     address _owner,
363     address _spender
364    )
365     public
366     view
367     returns (uint256)
368   {
369     return allowed[_owner][_spender];
370   }
371 
372   /**
373    * @dev Increase the amount of tokens that an owner allowed to a spender.
374    *
375    * approve should be called when allowed[_spender] == 0. To increment
376    * allowed value is better to use this function to avoid 2 calls (and wait until
377    * the first transaction is mined)
378    * From MonolithDAO Token.sol
379    * @param _spender The address which will spend the funds.
380    * @param _addedValue The amount of tokens to increase the allowance by.
381    */
382   function increaseApproval(
383     address _spender,
384     uint _addedValue
385   )
386     public
387     returns (bool)
388   {
389     allowed[msg.sender][_spender] = (
390       allowed[msg.sender][_spender].add(_addedValue));
391     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394 
395   /**
396    * @dev Decrease the amount of tokens that an owner allowed to a spender.
397    *
398    * approve should be called when allowed[_spender] == 0. To decrement
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param _spender The address which will spend the funds.
403    * @param _subtractedValue The amount of tokens to decrease the allowance by.
404    */
405   function decreaseApproval(
406     address _spender,
407     uint _subtractedValue
408   )
409     public
410     returns (bool)
411   {
412     uint oldValue = allowed[msg.sender][_spender];
413     if (_subtractedValue > oldValue) {
414       allowed[msg.sender][_spender] = 0;
415     } else {
416       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
417     }
418     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
419     return true;
420   }
421 
422 }
423 
424 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
425 
426 /**
427  * @title DetailedERC20 token
428  * @dev The decimals are only for visualization purposes.
429  * All the operations are done using the smallest and indivisible token unit,
430  * just as on Ethereum all the operations are done in wei.
431  */
432 contract DetailedERC20 is ERC20 {
433   string public name;
434   string public symbol;
435   uint8 public decimals;
436 
437   constructor(string _name, string _symbol, uint8 _decimals) public {
438     name = _name;
439     symbol = _symbol;
440     decimals = _decimals;
441   }
442 }
443 
444 // File: contracts/ext/ERC1003Token.sol
445 
446 contract ERC1003Caller is Ownable {
447     function makeCall(address _target, bytes _data) external payable onlyOwner returns (bool) {
448         // solium-disable-next-line security/no-call-value
449         return _target.call.value(msg.value)(_data);
450     }
451 }
452 
453 contract ERC1003Token is ERC20 {
454     ERC1003Caller public caller_ = new ERC1003Caller();
455     address[] internal sendersStack_;
456 
457     function approveAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
458         sendersStack_.push(msg.sender);
459         approve(_to, _value);
460         require(caller_.makeCall.value(msg.value)(_to, _data));
461         sendersStack_.length -= 1;
462         return true;
463     }
464 
465     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
466         transfer(_to, _value);
467         require(caller_.makeCall.value(msg.value)(_to, _data));
468         return true;
469     }
470 
471     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
472         address from = (_from != address(caller_)) ? _from : sendersStack_[sendersStack_.length - 1];
473         return super.transferFrom(from, _to, _value);
474     }
475 }
476 
477 // File: contracts/BasicMultiToken.sol
478 
479 contract BasicMultiToken is Pausable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {
480     using CheckedERC20 for ERC20;
481 
482     ERC20[] public tokens;
483 
484     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
485     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
486     
487     constructor() public DetailedERC20("", "", 0) {
488     }
489 
490     function init(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public {
491         require(decimals == 0, "init: contract was already initialized");
492         require(_decimals > 0, "init: _decimals should not be zero");
493         require(bytes(_name).length > 0, "init: _name should not be empty");
494         require(bytes(_symbol).length > 0, "init: _symbol should not be empty");
495         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
496 
497         name = _name;
498         symbol = _symbol;
499         decimals = _decimals;
500         tokens = _tokens;
501     }
502 
503     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public {
504         require(totalSupply_ == 0, "This method can be used with zero total supply only");
505         _bundle(_beneficiary, _amount, _tokenAmounts);
506     }
507 
508     function bundle(address _beneficiary, uint256 _amount) public {
509         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
510         uint256[] memory tokenAmounts = new uint256[](tokens.length);
511         for (uint i = 0; i < tokens.length; i++) {
512             tokenAmounts[i] = tokens[i].balanceOf(this).mul(_amount).div(totalSupply_);
513         }
514         _bundle(_beneficiary, _amount, tokenAmounts);
515     }
516 
517     function unbundle(address _beneficiary, uint256 _value) public {
518         unbundleSome(_beneficiary, _value, tokens);
519     }
520 
521     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public {
522         require(_tokens.length > 0, "Array of tokens can't be empty");
523 
524         uint256 totalSupply = totalSupply_;
525         balances[msg.sender] = balances[msg.sender].sub(_value);
526         totalSupply_ = totalSupply.sub(_value);
527         emit Unbundle(msg.sender, _beneficiary, _value);
528         emit Transfer(msg.sender, 0, _value);
529 
530         for (uint i = 0; i < _tokens.length; i++) {
531             for (uint j = 0; j < i; j++) {
532                 require(_tokens[i] != _tokens[j], "unbundleSome: should not unbundle same token multiple times");
533             }
534             uint256 tokenAmount = _tokens[i].balanceOf(this).mul(_value).div(totalSupply);
535             _tokens[i].checkedTransfer(_beneficiary, tokenAmount);
536         }
537     }
538 
539     function _bundle(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) internal whenNotPaused {
540         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
541 
542         for (uint i = 0; i < tokens.length; i++) {
543             uint256 prevBalance = tokens[i].balanceOf(this);
544             tokens[i].transferFrom(msg.sender, this, _tokenAmounts[i]); // Can't use require because not all ERC20 tokens return bool
545             require(tokens[i].balanceOf(this) == prevBalance.add(_tokenAmounts[i]), "Invalid token behavior");
546         }
547 
548         totalSupply_ = totalSupply_.add(_amount);
549         balances[_beneficiary] = balances[_beneficiary].add(_amount);
550         emit Bundle(msg.sender, _beneficiary, _amount);
551         emit Transfer(0, _beneficiary, _amount);
552     }
553 
554     // Instant Loans
555 
556     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
557         uint256 prevBalance = _token.balanceOf(this);
558         _token.transfer(_to, _amount);
559         require(caller_.makeCall.value(msg.value)(_target, _data), "lend: arbitrary call failed");
560         require(_token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
561     }
562 
563     // Public Getters
564 
565     function tokensCount() public view returns(uint) {
566         return tokens.length;
567     }
568 
569     function tokens(uint _index) public view returns(ERC20) {
570         return tokens[_index];
571     }
572 
573     function allTokens() public view returns(ERC20[] _tokens) {
574         _tokens = tokens;
575     }
576 
577     function allBalances() public view returns(uint256[] _balances) {
578         _balances = new uint256[](tokens.length);
579         for (uint i = 0; i < tokens.length; i++) {
580             _balances[i] = tokens[i].balanceOf(this);
581         }
582     }
583 
584     function allDecimals() public view returns(uint8[] _decimals) {
585         _decimals = new uint8[](tokens.length);
586         for (uint i = 0; i < tokens.length; i++) {
587             _decimals[i] = DetailedERC20(tokens[i]).decimals();
588         }
589     }
590 
591     function allTokensDecimalsBalances() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances) {
592         _tokens = allTokens();
593         _decimals = allDecimals();
594         _balances = allBalances();
595     }
596 }
597 
598 // File: contracts/MultiToken.sol
599 
600 contract MultiToken is IMultiToken, BasicMultiToken {
601     using CheckedERC20 for ERC20;
602 
603     uint inLendingMode;
604     uint256 internal minimalWeight;
605     mapping(address => uint256) public weights;
606 
607     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
608         super.init(_tokens, _name, _symbol, _decimals);
609         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
610         for (uint i = 0; i < tokens.length; i++) {
611             require(_weights[i] != 0, "The _weights array should not contains zeros");
612             require(weights[tokens[i]] == 0, "The _tokens array have duplicates");
613             weights[tokens[i]] = _weights[i];
614             if (minimalWeight == 0 || minimalWeight < _weights[i]) {
615                 minimalWeight = _weights[i];
616             }
617         }
618     }
619 
620     function init2(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
621         init(_tokens, _weights, _name, _symbol, _decimals);
622     }
623 
624     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
625         if (weights[_fromToken] > 0 && weights[_toToken] > 0 && _fromToken != _toToken) {
626             uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
627             uint256 toBalance = ERC20(_toToken).balanceOf(this);
628             returnAmount = _amount.mul(toBalance).mul(weights[_fromToken]).div(
629                 _amount.mul(weights[_fromToken]).div(minimalWeight).add(fromBalance)
630             );
631         }
632     }
633 
634     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
635         require(inLendingMode == 0);
636         returnAmount = getReturn(_fromToken, _toToken, _amount);
637         require(returnAmount > 0, "The return amount is zero");
638         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
639         
640         ERC20(_fromToken).checkedTransferFrom(msg.sender, this, _amount);
641         ERC20(_toToken).checkedTransfer(msg.sender, returnAmount);
642 
643         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
644     }
645 
646     // Instant Loans
647 
648     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
649         inLendingMode += 1;
650         super.lend(_to, _token, _amount, _target, _data);
651         inLendingMode -= 1;
652     }
653 
654     // Public Getters
655 
656     function allWeights() public view returns(uint256[] _weights) {
657         _weights = new uint256[](tokens.length);
658         for (uint i = 0; i < tokens.length; i++) {
659             _weights[i] = weights[tokens[i]];
660         }
661     }
662 
663     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights) {
664         (_tokens, _decimals, _balances) = allTokensDecimalsBalances();
665         _weights = allWeights();
666     }
667 
668 }
669 
670 // File: contracts/FeeMultiToken.sol
671 
672 contract FeeMultiToken is Ownable, MultiToken {
673     using CheckedERC20 for ERC20;
674 
675     uint256 public constant ONE_HUNDRED_PERCRENTS = 1000000;
676     uint256 public lendFee;
677     uint256 public changeFee;
678     uint256 public refferalFee;
679 
680     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 /*_decimals*/) public {
681         super.init(_tokens, _weights, _name, _symbol, 18);
682     }
683 
684     function setLendFee(uint256 _lendFee) public onlyOwner {
685         require(_lendFee <= 30000, "setLendFee: fee should be not greater than 3%");
686         lendFee = _lendFee;
687     }
688 
689     function setChangeFee(uint256 _changeFee) public onlyOwner {
690         require(_changeFee <= 30000, "setChangeFee: fee should be not greater than 3%");
691         changeFee = _changeFee;
692     }
693 
694     function setRefferalFee(uint256 _refferalFee) public onlyOwner {
695         require(_refferalFee <= 500000, "setChangeFee: fee should be not greater than 50% of changeFee");
696         refferalFee = _refferalFee;
697     }
698 
699     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
700         returnAmount = super.getReturn(_fromToken, _toToken, _amount).mul(ONE_HUNDRED_PERCRENTS.sub(changeFee)).div(ONE_HUNDRED_PERCRENTS);
701     }
702 
703     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
704         returnAmount = changeWithRef(_fromToken, _toToken, _amount, _minReturn, 0);
705     }
706 
707     function changeWithRef(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn, address _ref) public returns(uint256 returnAmount) {
708         returnAmount = super.change(_fromToken, _toToken, _amount, _minReturn);
709         uint256 refferalAmount = returnAmount
710             .mul(changeFee).div(ONE_HUNDRED_PERCRENTS.sub(changeFee))
711             .mul(refferalFee).div(ONE_HUNDRED_PERCRENTS);
712 
713         ERC20(_toToken).checkedTransfer(_ref, refferalAmount);
714     }
715 
716     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
717         uint256 prevBalance = _token.balanceOf(this);
718         super.lend(_to, _token, _amount, _target, _data);
719         require(_token.balanceOf(this) >= prevBalance.mul(ONE_HUNDRED_PERCRENTS.add(lendFee)).div(ONE_HUNDRED_PERCRENTS), "lend: tokens must be returned with lend fee");
720     }
721 }