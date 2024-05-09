1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address _who) public view returns (uint256);
11   function transfer(address _to, uint256 _value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract Enlist {
16   struct Record {
17     address investor;
18     bytes32 _type;
19   }
20 
21   Record[] records;
22 
23   function setRecord (
24     address _investor,
25     bytes32 _type
26   ) internal {
27     records.push(Record(_investor, _type));
28   }
29 
30   function getRecordCount () constant
31   public
32   returns (uint) {
33     return records.length;
34   }
35 
36   function getRecord (uint index) view
37   public
38   returns (address, bytes32) {
39     return (
40       records[index].investor,
41       records[index]._type
42     );
43   }
44 }
45 
46 
47 /* CONSTANTS:
48  *    20
49  */
50 contract JinVestingRule {
51   struct Rule {
52     bytes32 name;
53     bytes32 cliffStr;
54     uint256 cliff;
55     uint256 baseRatio; /* 第一個月解鎖 */
56     uint256 incrRatio; /* 第二個月開始每月解鎖 */
57   }
58 
59   uint public period;
60   uint public ruleCount;
61   Rule[20+1] public rules;
62   mapping(bytes32 => uint) ruleNumbering;
63 
64   constructor () public {
65     uint j = 0;
66     /* skip index j==0 */
67     rules[++j] = Rule('PRESALE1' , '2018-12-01', 1543622400,  20, 10); /* 私人配售 */
68     rules[++j] = Rule('PRESALE2' , '2019-02-01', 1548979200,  20, 10);
69     rules[++j] = Rule('PRESALE3' , '2019-04-01', 1554076800,  20, 10);
70     rules[++j] = Rule('PRESALE4' , '2019-06-01', 1559347200,  20, 10);
71     rules[++j] = Rule('PRESALE5' , '2019-08-01', 1564617600,  20, 10);
72     rules[++j] = Rule('CROWDSALE', '2019-09-01', 1567296000, 100,  0); /* 公開預售 */
73     rules[++j] = Rule('STARTUP'  , '2020-01-01', 1577836800,  10, 10); /* 創始團隊 */
74     rules[++j] = Rule('TECHTEAM' , '2019-09-01', 1567296000,  10, 10); /* 技術平台 */
75     ruleCount = j;
76     for (uint i = 1; i <= ruleCount; i++) {
77       ruleNumbering[rules[i].name] = i;
78     }
79     period = 30 days;
80 
81 
82 
83 
84   }
85 
86  modifier validateRuleName(bytes32 key) {
87    require(ruleNumbering[key] != 0);
88    _;
89  }
90 
91  modifier validateRuleIndex(uint i) {
92    require(1 <= i && i <= ruleCount);
93    _;
94  }
95 
96   function getRule (bytes32 key)
97   public view
98   validateRuleName(key)
99   returns (
100     string str_name,
101     string str_cliffStr,
102     uint256 cliff,
103     uint256 baseRatio,
104     uint256 incrRatio
105   ) {
106     return (
107       bytes32ToString(rules[ruleNumbering[key]].name),
108       bytes32ToString(rules[ruleNumbering[key]].cliffStr),
109       rules[ruleNumbering[key]].cliff,
110       rules[ruleNumbering[key]].baseRatio,
111       rules[ruleNumbering[key]].incrRatio
112     );
113   }
114 
115   function getRuleIndexByName (bytes32 key)
116   public view
117   validateRuleName(key)
118   returns (uint) {
119     return ruleNumbering[key];
120   }
121 
122   /* ref
123    * https://ethereum.stackexchange.com/questions/29295/how-to-convert-a-bytes-to-string-in-solidity?rq=1
124    */
125   function bytes32ToString(bytes32 x)
126   public pure
127   returns (string) {
128     bytes memory bytesString = new bytes(32);
129     uint charCount = 0;
130     for (uint j = 0; j < 32; j++) {
131       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
132       if (char != 0) {
133         bytesString[charCount] = char;
134         charCount++;
135       }
136     }
137     bytes memory bytesStringTrimmed = new bytes(charCount);
138     for (j = 0; j < charCount; j++) {
139       bytesStringTrimmed[j] = bytesString[j];
140     }
141     return string(bytesStringTrimmed);
142   }
143 
144 }
145 
146 
147 
148 /**
149  * @title Math
150  * @dev Assorted math operations
151  */
152 library Math {
153   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
154     return _a >= _b ? _a : _b;
155   }
156 
157   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
158     return _a < _b ? _a : _b;
159   }
160 
161   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
162     return _a >= _b ? _a : _b;
163   }
164 
165   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
166     return _a < _b ? _a : _b;
167   }
168 }
169 
170 
171 
172 /**
173  * @title Ownable
174  * @dev The Ownable contract has an owner address, and provides basic authorization control
175  * functions, this simplifies the implementation of "user permissions".
176  */
177 contract Ownable {
178   address public owner;
179 
180 
181   event OwnershipRenounced(address indexed previousOwner);
182   event OwnershipTransferred(
183     address indexed previousOwner,
184     address indexed newOwner
185   );
186 
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   constructor() public {
193     owner = msg.sender;
194   }
195 
196   /**
197    * @dev Throws if called by any account other than the owner.
198    */
199   modifier onlyOwner() {
200     require(msg.sender == owner);
201     _;
202   }
203 
204   /**
205    * @dev Allows the current owner to relinquish control of the contract.
206    * @notice Renouncing to ownership will leave the contract without an owner.
207    * It will not be possible to call the functions with the `onlyOwner`
208    * modifier anymore.
209    */
210   function renounceOwnership() public onlyOwner {
211     emit OwnershipRenounced(owner);
212     owner = address(0);
213   }
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param _newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address _newOwner) public onlyOwner {
220     _transferOwnership(_newOwner);
221   }
222 
223   /**
224    * @dev Transfers control of the contract to a newOwner.
225    * @param _newOwner The address to transfer ownership to.
226    */
227   function _transferOwnership(address _newOwner) internal {
228     require(_newOwner != address(0));
229     emit OwnershipTransferred(owner, _newOwner);
230     owner = _newOwner;
231   }
232 }
233 
234 
235 
236 
237 
238 
239 
240 
241 
242 
243 /**
244  * @title Basic token
245  * @dev Basic version of StandardToken, with no allowances.
246  */
247 contract BasicToken is ERC20Basic {
248   using SafeMath for uint256;
249 
250   mapping(address => uint256) internal balances;
251 
252   uint256 internal totalSupply_;
253 
254   /**
255   * @dev Total number of tokens in existence
256   */
257   function totalSupply() public view returns (uint256) {
258     return totalSupply_;
259   }
260 
261   /**
262   * @dev Transfer token for a specified address
263   * @param _to The address to transfer to.
264   * @param _value The amount to be transferred.
265   */
266   function transfer(address _to, uint256 _value) public returns (bool) {
267     require(_value <= balances[msg.sender]);
268     require(_to != address(0));
269 
270     balances[msg.sender] = balances[msg.sender].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     emit Transfer(msg.sender, _to, _value);
273     return true;
274   }
275 
276   /**
277   * @dev Gets the balance of the specified address.
278   * @param _owner The address to query the the balance of.
279   * @return An uint256 representing the amount owned by the passed address.
280   */
281   function balanceOf(address _owner) public view returns (uint256) {
282     return balances[_owner];
283   }
284 
285 }
286 
287 
288 
289 
290 
291 
292 /**
293  * @title ERC20 interface
294  * @dev see https://github.com/ethereum/EIPs/issues/20
295  */
296 contract ERC20 is ERC20Basic {
297   function allowance(address _owner, address _spender)
298     public view returns (uint256);
299 
300   function transferFrom(address _from, address _to, uint256 _value)
301     public returns (bool);
302 
303   function approve(address _spender, uint256 _value) public returns (bool);
304   event Approval(
305     address indexed owner,
306     address indexed spender,
307     uint256 value
308   );
309 }
310 
311 
312 
313 /**
314  * @title Standard ERC20 token
315  *
316  * @dev Implementation of the basic standard token.
317  * https://github.com/ethereum/EIPs/issues/20
318  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
319  */
320 contract StandardToken is ERC20, BasicToken {
321 
322   mapping (address => mapping (address => uint256)) internal allowed;
323 
324 
325   /**
326    * @dev Transfer tokens from one address to another
327    * @param _from address The address which you want to send tokens from
328    * @param _to address The address which you want to transfer to
329    * @param _value uint256 the amount of tokens to be transferred
330    */
331   function transferFrom(
332     address _from,
333     address _to,
334     uint256 _value
335   )
336     public
337     returns (bool)
338   {
339     require(_value <= balances[_from]);
340     require(_value <= allowed[_from][msg.sender]);
341     require(_to != address(0));
342 
343     balances[_from] = balances[_from].sub(_value);
344     balances[_to] = balances[_to].add(_value);
345     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
346     emit Transfer(_from, _to, _value);
347     return true;
348   }
349 
350   /**
351    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
352    * Beware that changing an allowance with this method brings the risk that someone may use both the old
353    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
354    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
355    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356    * @param _spender The address which will spend the funds.
357    * @param _value The amount of tokens to be spent.
358    */
359   function approve(address _spender, uint256 _value) public returns (bool) {
360     allowed[msg.sender][_spender] = _value;
361     emit Approval(msg.sender, _spender, _value);
362     return true;
363   }
364 
365   /**
366    * @dev Function to check the amount of tokens that an owner allowed to a spender.
367    * @param _owner address The address which owns the funds.
368    * @param _spender address The address which will spend the funds.
369    * @return A uint256 specifying the amount of tokens still available for the spender.
370    */
371   function allowance(
372     address _owner,
373     address _spender
374    )
375     public
376     view
377     returns (uint256)
378   {
379     return allowed[_owner][_spender];
380   }
381 
382   /**
383    * @dev Increase the amount of tokens that an owner allowed to a spender.
384    * approve should be called when allowed[_spender] == 0. To increment
385    * allowed value is better to use this function to avoid 2 calls (and wait until
386    * the first transaction is mined)
387    * From MonolithDAO Token.sol
388    * @param _spender The address which will spend the funds.
389    * @param _addedValue The amount of tokens to increase the allowance by.
390    */
391   function increaseApproval(
392     address _spender,
393     uint256 _addedValue
394   )
395     public
396     returns (bool)
397   {
398     allowed[msg.sender][_spender] = (
399       allowed[msg.sender][_spender].add(_addedValue));
400     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404   /**
405    * @dev Decrease the amount of tokens that an owner allowed to a spender.
406    * approve should be called when allowed[_spender] == 0. To decrement
407    * allowed value is better to use this function to avoid 2 calls (and wait until
408    * the first transaction is mined)
409    * From MonolithDAO Token.sol
410    * @param _spender The address which will spend the funds.
411    * @param _subtractedValue The amount of tokens to decrease the allowance by.
412    */
413   function decreaseApproval(
414     address _spender,
415     uint256 _subtractedValue
416   )
417     public
418     returns (bool)
419   {
420     uint256 oldValue = allowed[msg.sender][_spender];
421     if (_subtractedValue >= oldValue) {
422       allowed[msg.sender][_spender] = 0;
423     } else {
424       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
425     }
426     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
427     return true;
428   }
429 
430 }
431 
432 
433 
434 
435 
436 
437 /**
438  * @title DetailedERC20 token
439  * @dev The decimals are only for visualization purposes.
440  * All the operations are done using the smallest and indivisible token unit,
441  * just as on Ethereum all the operations are done in wei.
442  */
443 contract DetailedERC20 is ERC20 {
444   string public name;
445   string public symbol;
446   uint8 public decimals;
447 
448   constructor(string _name, string _symbol, uint8 _decimals) public {
449     name = _name;
450     symbol = _symbol;
451     decimals = _decimals;
452   }
453 }
454 
455 
456 
457 
458 
459 /**
460  * @title SafeMath
461  * @dev Math operations with safety checks that throw on error
462  */
463 library SafeMath {
464 
465   /**
466   * @dev Multiplies two numbers, throws on overflow.
467   */
468   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
469     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
470     // benefit is lost if 'b' is also tested.
471     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
472     if (_a == 0) {
473       return 0;
474     }
475 
476     c = _a * _b;
477     assert(c / _a == _b);
478     return c;
479   }
480 
481   /**
482   * @dev Integer division of two numbers, truncating the quotient.
483   */
484   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
485     // assert(_b > 0); // Solidity automatically throws when dividing by 0
486     // uint256 c = _a / _b;
487     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
488     return _a / _b;
489   }
490 
491   /**
492   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
493   */
494   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
495     assert(_b <= _a);
496     return _a - _b;
497   }
498 
499   /**
500   * @dev Adds two numbers, throws on overflow.
501   */
502   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
503     c = _a + _b;
504     assert(c >= _a);
505     return c;
506   }
507 }
508 
509 
510 
511 
512 
513 contract JinToken is
514   StandardToken,
515   DetailedERC20,
516   Ownable,
517   JinVestingRule,
518   Enlist {
519   using SafeMath for uint;
520   using Math for uint;
521 
522   uint public INITIAL_SUPPLY;
523 
524   mapping (address => mapping (bytes32 => uint)) private lockedAmount;
525   mapping (address => mapping (bytes32 => uint)) private alreadyClaim;
526 
527   // How many token units a buyer gets per microether.
528   // The rate is the conversion between
529   //    microeather and
530   //    the smallest and indivisible token unit.
531   // So, if you are using a rate of 1 with 5 decimals called KIM
532   // 1 microether will give you 1 unit, or 0.00001 KIM.
533   uint public rate;  // Crowdsale
534 
535   constructor (
536     string _name,     // "jinyitong"
537     string _symbol,   // "JIN", "KIN", "BGC"
538     uint8 _decimals,  // 5
539     address _startup,
540     address _angelfund,
541     address _techteam
542   )
543   DetailedERC20(
544     _name,
545     _symbol,
546     _decimals
547   )
548   JinVestingRule()
549   public {
550     rate = 30;
551     INITIAL_SUPPLY = 3.14e8;                 // 三億一千四百萬 (314000000)
552     totalSupply_ = INITIAL_SUPPLY.mul(10 ** uint(decimals)); // BasicToken
553     balances[msg.sender] = totalSupply_;                     // BasicToken
554 
555     /* initial transferToLock */
556     uint jins = 0;
557 
558     jins = totalSupply_.div(100).mul(20);
559     _transferToLock(_startup, jins, 'STARTUP');
560 
561     jins = totalSupply_.div(100).mul(15);
562     transfer(_angelfund, jins); // _transferToLock(_angelfund, jins, 'ANGELFUND');
563 
564     jins = totalSupply_.div(100).mul(5);
565     _transferToLock(_techteam, jins, 'TECHTEAM');
566   }
567 
568   event TransferToLock (
569     address indexed to,
570     uint value,
571     string lockingType,
572     uint totalLocked
573   );
574 
575   event DoubleClaim (
576     address indexed user,
577     bytes32 _type,
578     address sender
579   );
580 
581   modifier onlyOwner() {
582     require(msg.sender == owner); // Ownable
583     _;
584   }
585 
586   /* Crowdsale */
587   function ()
588   external
589   payable {
590 
591     address user = msg.sender;
592     uint jins = _getTokenAmount(msg.value);
593 
594     require(jins >= 0);
595 
596     _transferToLock(user, jins, 'CROWDSALE');
597   }
598 
599   function _getTokenAmount(uint weiAmount) internal view returns (uint) {
600     uint _microAmount = weiAmount.div(10 ** 12);
601     return _microAmount.mul(rate);
602   }
603 
604   function setCrowdsaleRate(uint _rate) public onlyOwner() returns (bool) {
605     rate = _rate;
606     return true;
607   }
608 
609   function transferToLock (
610     address user,
611     uint amount,
612     bytes32 _type
613   ) public
614   onlyOwner()
615   validateRuleName(_type)
616   returns (bool) {
617     _transferToLock(user, amount, _type);
618     return true;
619   }
620 
621   function _transferToLock (
622     address _to,
623     uint _value,
624     bytes32 _type
625   ) internal
626   returns (bool) {
627     address _from = owner;
628 
629     require(_value > 0);
630     require(_value <= balances[_from]);
631     require(_to != address(0));
632 
633     balances[_from] = balances[_from].sub(_value);
634     lockedAmount[_to][_type] = lockedAmount[_to][_type].add(_value);
635 
636     emit TransferToLock(_to, _value, bytes32ToString(_type), lockedAmount[_to][_type]);
637 
638     setRecord(_to, _type);
639 
640     return true;
641   }
642 
643   function claimToken (
644     address user,
645     bytes32 _type
646   ) public
647   validateRuleName(_type)
648   returns (bool) {
649     require(lockedAmount[user][_type] > 0);
650     uint approved = approvedRatio(_type);
651     uint availableToClaim =
652       lockedAmount[user][_type].mul(approved).div(100);
653     uint amountToClaim = availableToClaim.sub(alreadyClaim[user][_type]);
654 
655     if (amountToClaim > 0) {
656       balances[user] = balances[user].add(amountToClaim);
657       alreadyClaim[user][_type] = availableToClaim;
658     } else if (amountToClaim == 0) {
659       emit DoubleClaim(
660         user,
661         _type,
662         msg.sender
663       );
664     } else {
665     }
666 
667     return true;
668   }
669 
670   function approvedRatio (
671     bytes32 _type
672   ) internal view returns (uint) {
673       uint _now = getTime();
674       uint cliff = rules[ruleNumbering[_type]].cliff;
675 
676       require(_now >= cliff);
677 
678       uint baseRatio = rules[ruleNumbering[_type]].baseRatio;
679       uint incrRatio = rules[ruleNumbering[_type]].incrRatio;
680 
681       return Math.min256(
682         100,
683         _now
684         .sub( cliff )
685         .div( period ) // a month
686         .mul( incrRatio )
687         .add( baseRatio )
688       );
689   }
690 
691   function getLockedAvailable (
692     address user,
693     bytes32 _type
694   ) public view
695   validateRuleName(_type)
696   returns (uint) {
697     uint record;
698 
699     record = lockedAmount[user][_type].sub(alreadyClaim[user][_type]);
700 
701     return record;
702   }
703 
704   function getTime () public view returns (uint) {
705     return block.timestamp; // now
706   }
707 }