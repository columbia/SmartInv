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
64 // File: contracts/registry/IDeployer.sol
65 
66 contract IDeployer is Ownable {
67     function deploy(bytes data) external returns(address mtkn);
68 }
69 
70 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   function totalSupply() public view returns (uint256);
79   function balanceOf(address who) public view returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender)
92     public view returns (uint256);
93 
94   function transferFrom(address from, address to, uint256 value)
95     public returns (bool);
96 
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(
99     address indexed owner,
100     address indexed spender,
101     uint256 value
102   );
103 }
104 
105 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     // uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return a / b;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 // File: contracts/ext/CheckedERC20.sol
158 
159 library CheckedERC20 {
160     using SafeMath for uint;
161 
162     function checkedTransfer(ERC20 _token, address _to, uint256 _value) internal {
163         if (_value == 0) {
164             return;
165         }
166         uint256 balance = _token.balanceOf(this);
167         _token.transfer(_to, _value);
168         require(_token.balanceOf(this) == balance.sub(_value), "checkedTransfer: Final balance didn't match");
169     }
170 
171     function checkedTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
172         if (_value == 0) {
173             return;
174         }
175         uint256 toBalance = _token.balanceOf(_to);
176         _token.transferFrom(_from, _to, _value);
177         require(_token.balanceOf(_to) == toBalance.add(_value), "checkedTransfer: Final balance didn't match");
178     }
179 }
180 
181 // File: contracts/interface/IBasicMultiToken.sol
182 
183 contract IBasicMultiToken is ERC20 {
184     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
185     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
186 
187     function tokensCount() public view returns(uint256);
188     function tokens(uint256 _index) public view returns(ERC20);
189     function allTokens() public view returns(ERC20[]);
190     function allDecimals() public view returns(uint8[]);
191     function allBalances() public view returns(uint256[]);
192     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
193 
194     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
195     function bundle(address _beneficiary, uint256 _amount) public;
196 
197     function unbundle(address _beneficiary, uint256 _value) public;
198     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
199 }
200 
201 // File: contracts/interface/IMultiToken.sol
202 
203 contract IMultiToken is IBasicMultiToken {
204     event Update();
205     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
206 
207     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
208     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
209 
210     function allWeights() public view returns(uint256[] _weights);
211     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
212 }
213 
214 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
215 
216 /**
217  * @title Pausable
218  * @dev Base contract which allows children to implement an emergency stop mechanism.
219  */
220 contract Pausable is Ownable {
221   event Pause();
222   event Unpause();
223 
224   bool public paused = false;
225 
226 
227   /**
228    * @dev Modifier to make a function callable only when the contract is not paused.
229    */
230   modifier whenNotPaused() {
231     require(!paused);
232     _;
233   }
234 
235   /**
236    * @dev Modifier to make a function callable only when the contract is paused.
237    */
238   modifier whenPaused() {
239     require(paused);
240     _;
241   }
242 
243   /**
244    * @dev called by the owner to pause, triggers stopped state
245    */
246   function pause() onlyOwner whenNotPaused public {
247     paused = true;
248     emit Pause();
249   }
250 
251   /**
252    * @dev called by the owner to unpause, returns to normal state
253    */
254   function unpause() onlyOwner whenPaused public {
255     paused = false;
256     emit Unpause();
257   }
258 }
259 
260 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
261 
262 /**
263  * @title Basic token
264  * @dev Basic version of StandardToken, with no allowances.
265  */
266 contract BasicToken is ERC20Basic {
267   using SafeMath for uint256;
268 
269   mapping(address => uint256) balances;
270 
271   uint256 totalSupply_;
272 
273   /**
274   * @dev total number of tokens in existence
275   */
276   function totalSupply() public view returns (uint256) {
277     return totalSupply_;
278   }
279 
280   /**
281   * @dev transfer token for a specified address
282   * @param _to The address to transfer to.
283   * @param _value The amount to be transferred.
284   */
285   function transfer(address _to, uint256 _value) public returns (bool) {
286     require(_to != address(0));
287     require(_value <= balances[msg.sender]);
288 
289     balances[msg.sender] = balances[msg.sender].sub(_value);
290     balances[_to] = balances[_to].add(_value);
291     emit Transfer(msg.sender, _to, _value);
292     return true;
293   }
294 
295   /**
296   * @dev Gets the balance of the specified address.
297   * @param _owner The address to query the the balance of.
298   * @return An uint256 representing the amount owned by the passed address.
299   */
300   function balanceOf(address _owner) public view returns (uint256) {
301     return balances[_owner];
302   }
303 
304 }
305 
306 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
307 
308 /**
309  * @title Standard ERC20 token
310  *
311  * @dev Implementation of the basic standard token.
312  * @dev https://github.com/ethereum/EIPs/issues/20
313  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
314  */
315 contract StandardToken is ERC20, BasicToken {
316 
317   mapping (address => mapping (address => uint256)) internal allowed;
318 
319 
320   /**
321    * @dev Transfer tokens from one address to another
322    * @param _from address The address which you want to send tokens from
323    * @param _to address The address which you want to transfer to
324    * @param _value uint256 the amount of tokens to be transferred
325    */
326   function transferFrom(
327     address _from,
328     address _to,
329     uint256 _value
330   )
331     public
332     returns (bool)
333   {
334     require(_to != address(0));
335     require(_value <= balances[_from]);
336     require(_value <= allowed[_from][msg.sender]);
337 
338     balances[_from] = balances[_from].sub(_value);
339     balances[_to] = balances[_to].add(_value);
340     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
341     emit Transfer(_from, _to, _value);
342     return true;
343   }
344 
345   /**
346    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
347    *
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
380    *
381    * approve should be called when allowed[_spender] == 0. To increment
382    * allowed value is better to use this function to avoid 2 calls (and wait until
383    * the first transaction is mined)
384    * From MonolithDAO Token.sol
385    * @param _spender The address which will spend the funds.
386    * @param _addedValue The amount of tokens to increase the allowance by.
387    */
388   function increaseApproval(
389     address _spender,
390     uint _addedValue
391   )
392     public
393     returns (bool)
394   {
395     allowed[msg.sender][_spender] = (
396       allowed[msg.sender][_spender].add(_addedValue));
397     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398     return true;
399   }
400 
401   /**
402    * @dev Decrease the amount of tokens that an owner allowed to a spender.
403    *
404    * approve should be called when allowed[_spender] == 0. To decrement
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param _spender The address which will spend the funds.
409    * @param _subtractedValue The amount of tokens to decrease the allowance by.
410    */
411   function decreaseApproval(
412     address _spender,
413     uint _subtractedValue
414   )
415     public
416     returns (bool)
417   {
418     uint oldValue = allowed[msg.sender][_spender];
419     if (_subtractedValue > oldValue) {
420       allowed[msg.sender][_spender] = 0;
421     } else {
422       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
423     }
424     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
425     return true;
426   }
427 
428 }
429 
430 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
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
450 // File: contracts/ext/ERC1003Token.sol
451 
452 contract ERC1003Caller is Ownable {
453     function makeCall(address _target, bytes _data) external payable onlyOwner returns (bool) {
454         // solium-disable-next-line security/no-call-value
455         return _target.call.value(msg.value)(_data);
456     }
457 }
458 
459 contract ERC1003Token is ERC20 {
460     ERC1003Caller public caller_ = new ERC1003Caller();
461     address[] internal sendersStack_;
462 
463     function approveAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
464         sendersStack_.push(msg.sender);
465         approve(_to, _value);
466         require(caller_.makeCall.value(msg.value)(_to, _data));
467         sendersStack_.length -= 1;
468         return true;
469     }
470 
471     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool) {
472         transfer(_to, _value);
473         require(caller_.makeCall.value(msg.value)(_to, _data));
474         return true;
475     }
476 
477     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
478         address from = (_from != address(caller_)) ? _from : sendersStack_[sendersStack_.length - 1];
479         return super.transferFrom(from, _to, _value);
480     }
481 }
482 
483 // File: contracts/BasicMultiToken.sol
484 
485 contract BasicMultiToken is Pausable, StandardToken, DetailedERC20, ERC1003Token, IBasicMultiToken {
486     using CheckedERC20 for ERC20;
487 
488     ERC20[] public tokens;
489 
490     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
491     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
492     
493     constructor() public DetailedERC20("", "", 0) {
494     }
495 
496     function init(ERC20[] _tokens, string _name, string _symbol, uint8 _decimals) public {
497         require(decimals == 0, "init: contract was already initialized");
498         require(_decimals > 0, "init: _decimals should not be zero");
499         require(bytes(_name).length > 0, "init: _name should not be empty");
500         require(bytes(_symbol).length > 0, "init: _symbol should not be empty");
501         require(_tokens.length >= 2, "Contract do not support less than 2 inner tokens");
502 
503         name = _name;
504         symbol = _symbol;
505         decimals = _decimals;
506         tokens = _tokens;
507     }
508 
509     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public {
510         require(totalSupply_ == 0, "This method can be used with zero total supply only");
511         _bundle(_beneficiary, _amount, _tokenAmounts);
512     }
513 
514     function bundle(address _beneficiary, uint256 _amount) public {
515         require(totalSupply_ != 0, "This method can be used with non zero total supply only");
516         uint256[] memory tokenAmounts = new uint256[](tokens.length);
517         for (uint i = 0; i < tokens.length; i++) {
518             tokenAmounts[i] = tokens[i].balanceOf(this).mul(_amount).div(totalSupply_);
519         }
520         _bundle(_beneficiary, _amount, tokenAmounts);
521     }
522 
523     function unbundle(address _beneficiary, uint256 _value) public {
524         unbundleSome(_beneficiary, _value, tokens);
525     }
526 
527     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public {
528         require(_tokens.length > 0, "Array of tokens can't be empty");
529 
530         uint256 totalSupply = totalSupply_;
531         balances[msg.sender] = balances[msg.sender].sub(_value);
532         totalSupply_ = totalSupply.sub(_value);
533         emit Unbundle(msg.sender, _beneficiary, _value);
534         emit Transfer(msg.sender, 0, _value);
535 
536         for (uint i = 0; i < _tokens.length; i++) {
537             for (uint j = 0; j < i; j++) {
538                 require(_tokens[i] != _tokens[j], "unbundleSome: should not unbundle same token multiple times");
539             }
540             uint256 tokenAmount = _tokens[i].balanceOf(this).mul(_value).div(totalSupply);
541             _tokens[i].checkedTransfer(_beneficiary, tokenAmount);
542         }
543     }
544 
545     function _bundle(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) internal whenNotPaused {
546         require(tokens.length == _tokenAmounts.length, "Lenghts of tokens and _tokenAmounts array should be equal");
547 
548         for (uint i = 0; i < tokens.length; i++) {
549             uint256 prevBalance = tokens[i].balanceOf(this);
550             tokens[i].transferFrom(msg.sender, this, _tokenAmounts[i]); // Can't use require because not all ERC20 tokens return bool
551             require(tokens[i].balanceOf(this) == prevBalance.add(_tokenAmounts[i]), "Invalid token behavior");
552         }
553 
554         totalSupply_ = totalSupply_.add(_amount);
555         balances[_beneficiary] = balances[_beneficiary].add(_amount);
556         emit Bundle(msg.sender, _beneficiary, _amount);
557         emit Transfer(0, _beneficiary, _amount);
558     }
559 
560     // Instant Loans
561 
562     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
563         uint256 prevBalance = _token.balanceOf(this);
564         _token.transfer(_to, _amount);
565         require(caller_.makeCall.value(msg.value)(_target, _data), "lend: arbitrary call failed");
566         require(_token.balanceOf(this) >= prevBalance, "lend: lended token must be refilled");
567     }
568 
569     // Public Getters
570 
571     function tokensCount() public view returns(uint) {
572         return tokens.length;
573     }
574 
575     function tokens(uint _index) public view returns(ERC20) {
576         return tokens[_index];
577     }
578 
579     function allTokens() public view returns(ERC20[] _tokens) {
580         _tokens = tokens;
581     }
582 
583     function allBalances() public view returns(uint256[] _balances) {
584         _balances = new uint256[](tokens.length);
585         for (uint i = 0; i < tokens.length; i++) {
586             _balances[i] = tokens[i].balanceOf(this);
587         }
588     }
589 
590     function allDecimals() public view returns(uint8[] _decimals) {
591         _decimals = new uint8[](tokens.length);
592         for (uint i = 0; i < tokens.length; i++) {
593             _decimals[i] = DetailedERC20(tokens[i]).decimals();
594         }
595     }
596 
597     function allTokensDecimalsBalances() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances) {
598         _tokens = allTokens();
599         _decimals = allDecimals();
600         _balances = allBalances();
601     }
602 }
603 
604 // File: contracts/MultiToken.sol
605 
606 contract MultiToken is IMultiToken, BasicMultiToken {
607     using CheckedERC20 for ERC20;
608 
609     uint inLendingMode;
610     uint256 internal minimalWeight;
611     mapping(address => uint256) public weights;
612 
613     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
614         super.init(_tokens, _name, _symbol, _decimals);
615         require(_weights.length == tokens.length, "Lenghts of _tokens and _weights array should be equal");
616         for (uint i = 0; i < tokens.length; i++) {
617             require(_weights[i] != 0, "The _weights array should not contains zeros");
618             require(weights[tokens[i]] == 0, "The _tokens array have duplicates");
619             weights[tokens[i]] = _weights[i];
620             if (minimalWeight == 0 || minimalWeight < _weights[i]) {
621                 minimalWeight = _weights[i];
622             }
623         }
624     }
625 
626     function init2(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 _decimals) public {
627         init(_tokens, _weights, _name, _symbol, _decimals);
628     }
629 
630     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
631         if (weights[_fromToken] > 0 && weights[_toToken] > 0 && _fromToken != _toToken) {
632             uint256 fromBalance = ERC20(_fromToken).balanceOf(this);
633             uint256 toBalance = ERC20(_toToken).balanceOf(this);
634             returnAmount = _amount.mul(toBalance).mul(weights[_fromToken]).div(
635                 _amount.mul(weights[_fromToken]).div(minimalWeight).add(fromBalance)
636             );
637         }
638     }
639 
640     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
641         require(inLendingMode == 0);
642         returnAmount = getReturn(_fromToken, _toToken, _amount);
643         require(returnAmount > 0, "The return amount is zero");
644         require(returnAmount >= _minReturn, "The return amount is less than _minReturn value");
645         
646         ERC20(_fromToken).checkedTransferFrom(msg.sender, this, _amount);
647         ERC20(_toToken).checkedTransfer(msg.sender, returnAmount);
648 
649         emit Change(_fromToken, _toToken, msg.sender, _amount, returnAmount);
650     }
651 
652     // Instant Loans
653 
654     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
655         inLendingMode += 1;
656         super.lend(_to, _token, _amount, _target, _data);
657         inLendingMode -= 1;
658     }
659 
660     // Public Getters
661 
662     function allWeights() public view returns(uint256[] _weights) {
663         _weights = new uint256[](tokens.length);
664         for (uint i = 0; i < tokens.length; i++) {
665             _weights[i] = weights[tokens[i]];
666         }
667     }
668 
669     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights) {
670         (_tokens, _decimals, _balances) = allTokensDecimalsBalances();
671         _weights = allWeights();
672     }
673 
674 }
675 
676 // File: contracts/FeeMultiToken.sol
677 
678 contract FeeMultiToken is Ownable, MultiToken {
679     using CheckedERC20 for ERC20;
680 
681     uint256 public constant ONE_HUNDRED_PERCRENTS = 1000000;
682     uint256 public lendFee;
683     uint256 public changeFee;
684     uint256 public refferalFee;
685 
686     function init(ERC20[] _tokens, uint256[] _weights, string _name, string _symbol, uint8 /*_decimals*/) public {
687         super.init(_tokens, _weights, _name, _symbol, 18);
688     }
689 
690     function setLendFee(uint256 _lendFee) public onlyOwner {
691         require(_lendFee <= 30000, "setLendFee: fee should be not greater than 3%");
692         lendFee = _lendFee;
693     }
694 
695     function setChangeFee(uint256 _changeFee) public onlyOwner {
696         require(_changeFee <= 30000, "setChangeFee: fee should be not greater than 3%");
697         changeFee = _changeFee;
698     }
699 
700     function setRefferalFee(uint256 _refferalFee) public onlyOwner {
701         require(_refferalFee <= 500000, "setChangeFee: fee should be not greater than 50% of changeFee");
702         refferalFee = _refferalFee;
703     }
704 
705     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns(uint256 returnAmount) {
706         returnAmount = super.getReturn(_fromToken, _toToken, _amount).mul(ONE_HUNDRED_PERCRENTS.sub(changeFee)).div(ONE_HUNDRED_PERCRENTS);
707     }
708 
709     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns(uint256 returnAmount) {
710         returnAmount = changeWithRef(_fromToken, _toToken, _amount, _minReturn, 0);
711     }
712 
713     function changeWithRef(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn, address _ref) public returns(uint256 returnAmount) {
714         returnAmount = super.change(_fromToken, _toToken, _amount, _minReturn);
715         uint256 refferalAmount = returnAmount
716             .mul(changeFee).div(ONE_HUNDRED_PERCRENTS.sub(changeFee))
717             .mul(refferalFee).div(ONE_HUNDRED_PERCRENTS);
718 
719         ERC20(_toToken).checkedTransfer(_ref, refferalAmount);
720     }
721 
722     function lend(address _to, ERC20 _token, uint256 _amount, address _target, bytes _data) public payable {
723         uint256 prevBalance = _token.balanceOf(this);
724         super.lend(_to, _token, _amount, _target, _data);
725         require(_token.balanceOf(this) >= prevBalance.mul(ONE_HUNDRED_PERCRENTS.add(lendFee)).div(ONE_HUNDRED_PERCRENTS), "lend: tokens must be returned with lend fee");
726     }
727 }
728 
729 // File: contracts/registry/MultiTokenDeployer.sol
730 
731 contract MultiTokenDeployer is Ownable, IDeployer {
732     function deploy(bytes data) external onlyOwner returns(address) {
733         require(
734             // init(address[],uint256[],string,string,uint8)
735             (data[0] == 0x6f && data[1] == 0x5f && data[2] == 0x53 && data[3] == 0x5d) ||
736             // init2(address[],uint256[],string,string,uint8)
737             (data[0] == 0x18 && data[1] == 0x2a && data[2] == 0x54 && data[3] == 0x15)
738         );
739 
740         FeeMultiToken mtkn = new FeeMultiToken();
741         require(address(mtkn).call(data));
742         mtkn.transferOwnership(msg.sender);
743         return mtkn;
744     }
745 }