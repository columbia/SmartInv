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
55     uint256 baseRatio; /* First Month release */
56     uint256 incrRatio; /* Second Month release */
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
67     rules[++j] = Rule('PRESALE1' , '2018-12-01', 1543622400,  20, 10); /* Prvaite Salse Peroiod 1 */
68     rules[++j] = Rule('PRESALE2' , '2019-02-01', 1548979200,  20, 10); /* Prvaite Salse Peroiod 2 */
69     rules[++j] = Rule('PRESALE3' , '2019-04-01', 1554076800,  20, 10); /* Prvaite Salse Peroiod 3 */
70     rules[++j] = Rule('PRESALE4' , '2019-06-01', 1559347200,  20, 10); /* Prvaite Salse Peroiod 4 */
71     rules[++j] = Rule('PRESALE5' , '2019-08-01', 1564617600,  20, 10); /* Prvaite Salse Peroiod 5 */
72     rules[++j] = Rule('CROWDSALE', '2019-09-01', 1567296000, 100,  0); /* Public Sale */
73     rules[++j] = Rule('STARTUP'  , '2020-01-01', 1577836800,  10, 10); /* StartUp Team */
74     rules[++j] = Rule('TECHTEAM' , '2019-09-01', 1567296000,  10, 10); /* Technology Team */
75     ruleCount = j;
76     for (uint i = 1; i <= ruleCount; i++) {
77       ruleNumbering[rules[i].name] = i;
78     }
79     period = 30 days;
80   }
81 
82  modifier validateRuleName(bytes32 key) {
83    require(ruleNumbering[key] != 0);
84    _;
85  }
86 
87  modifier validateRuleIndex(uint i) {
88    require(1 <= i && i <= ruleCount);
89    _;
90  }
91 
92   function getRule (bytes32 key)
93   public view
94   validateRuleName(key)
95   returns (
96     string str_name,
97     string str_cliffStr,
98     uint256 cliff,
99     uint256 baseRatio,
100     uint256 incrRatio
101   ) {
102     return (
103       bytes32ToString(rules[ruleNumbering[key]].name),
104       bytes32ToString(rules[ruleNumbering[key]].cliffStr),
105       rules[ruleNumbering[key]].cliff,
106       rules[ruleNumbering[key]].baseRatio,
107       rules[ruleNumbering[key]].incrRatio
108     );
109   }
110 
111   function getRuleIndexByName (bytes32 key)
112   public view
113   validateRuleName(key)
114   returns (uint) {
115     return ruleNumbering[key];
116   }
117 
118   /* ref
119    * https://ethereum.stackexchange.com/questions/29295/how-to-convert-a-bytes-to-string-in-solidity?rq=1
120    */
121   function bytes32ToString(bytes32 x)
122   public pure
123   returns (string) {
124     bytes memory bytesString = new bytes(32);
125     uint charCount = 0;
126     for (uint j = 0; j < 32; j++) {
127       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
128       if (char != 0) {
129         bytesString[charCount] = char;
130         charCount++;
131       }
132     }
133     bytes memory bytesStringTrimmed = new bytes(charCount);
134     for (j = 0; j < charCount; j++) {
135       bytesStringTrimmed[j] = bytesString[j];
136     }
137     return string(bytesStringTrimmed);
138   }
139 
140 }
141 
142 
143 
144 /**
145  * @title Math
146  * @dev Assorted math operations
147  */
148 library Math {
149   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
150     return _a >= _b ? _a : _b;
151   }
152 
153   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
154     return _a < _b ? _a : _b;
155   }
156 
157   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
158     return _a >= _b ? _a : _b;
159   }
160 
161   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
162     return _a < _b ? _a : _b;
163   }
164 }
165 
166 
167 
168 /**
169  * @title Ownable
170  * @dev The Ownable contract has an owner address, and provides basic authorization control
171  * functions, this simplifies the implementation of "user permissions".
172  */
173 contract Ownable {
174   address public owner;
175 
176 
177   event OwnershipRenounced(address indexed previousOwner);
178   event OwnershipTransferred(
179     address indexed previousOwner,
180     address indexed newOwner
181   );
182 
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   constructor() public {
189     owner = msg.sender;
190   }
191 
192   /**
193    * @dev Throws if called by any account other than the owner.
194    */
195   modifier onlyOwner() {
196     require(msg.sender == owner);
197     _;
198   }
199 
200   /**
201    * @dev Allows the current owner to relinquish control of the contract.
202    * @notice Renouncing to ownership will leave the contract without an owner.
203    * It will not be possible to call the functions with the `onlyOwner`
204    * modifier anymore.
205    */
206   function renounceOwnership() public onlyOwner {
207     emit OwnershipRenounced(owner);
208     owner = address(0);
209   }
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param _newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address _newOwner) public onlyOwner {
216     _transferOwnership(_newOwner);
217   }
218 
219   /**
220    * @dev Transfers control of the contract to a newOwner.
221    * @param _newOwner The address to transfer ownership to.
222    */
223   function _transferOwnership(address _newOwner) internal {
224     require(_newOwner != address(0));
225     emit OwnershipTransferred(owner, _newOwner);
226     owner = _newOwner;
227   }
228 }
229 
230 
231 
232 /**
233  * @title Basic token
234  * @dev Basic version of StandardToken, with no allowances.
235  */
236 contract BasicToken is ERC20Basic {
237   using SafeMath for uint256;
238 
239   mapping(address => uint256) internal balances;
240 
241   uint256 internal totalSupply_;
242 
243   /**
244   * @dev Total number of tokens in existence
245   */
246   function totalSupply() public view returns (uint256) {
247     return totalSupply_;
248   }
249 
250   /**
251   * @dev Transfer token for a specified address
252   * @param _to The address to transfer to.
253   * @param _value The amount to be transferred.
254   */
255   function transfer(address _to, uint256 _value) public returns (bool) {
256     require(_value <= balances[msg.sender]);
257     require(_to != address(0));
258 
259     balances[msg.sender] = balances[msg.sender].sub(_value);
260     balances[_to] = balances[_to].add(_value);
261     emit Transfer(msg.sender, _to, _value);
262     return true;
263   }
264 
265   /**
266   * @dev Gets the balance of the specified address.
267   * @param _owner The address to query the the balance of.
268   * @return An uint256 representing the amount owned by the passed address.
269   */
270   function balanceOf(address _owner) public view returns (uint256) {
271     return balances[_owner];
272   }
273 
274 }
275 
276 
277 /**
278  * @title ERC20 interface
279  * @dev see https://github.com/ethereum/EIPs/issues/20
280  */
281 contract ERC20 is ERC20Basic {
282   function allowance(address _owner, address _spender)
283     public view returns (uint256);
284 
285   function transferFrom(address _from, address _to, uint256 _value)
286     public returns (bool);
287 
288   function approve(address _spender, uint256 _value) public returns (bool);
289   event Approval(
290     address indexed owner,
291     address indexed spender,
292     uint256 value
293   );
294 }
295 
296 
297 
298 /**
299  * @title Standard ERC20 token
300  *
301  * @dev Implementation of the basic standard token.
302  * https://github.com/ethereum/EIPs/issues/20
303  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
304  */
305 contract StandardToken is ERC20, BasicToken {
306 
307   mapping (address => mapping (address => uint256)) internal allowed;
308 
309   /**
310    * @dev Transfer tokens from one address to another
311    * @param _from address The address which you want to send tokens from
312    * @param _to address The address which you want to transfer to
313    * @param _value uint256 the amount of tokens to be transferred
314    */
315   function transferFrom(
316     address _from,
317     address _to,
318     uint256 _value
319   )
320     public
321     returns (bool)
322   {
323     require(_value <= balances[_from]);
324     require(_value <= allowed[_from][msg.sender]);
325     require(_to != address(0));
326 
327     balances[_from] = balances[_from].sub(_value);
328     balances[_to] = balances[_to].add(_value);
329     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
330     emit Transfer(_from, _to, _value);
331     return true;
332   }
333 
334   /**
335    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
336    * Beware that changing an allowance with this method brings the risk that someone may use both the old
337    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
338    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
339    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340    * @param _spender The address which will spend the funds.
341    * @param _value The amount of tokens to be spent.
342    */
343   function approve(address _spender, uint256 _value) public returns (bool) {
344     allowed[msg.sender][_spender] = _value;
345     emit Approval(msg.sender, _spender, _value);
346     return true;
347   }
348 
349   /**
350    * @dev Function to check the amount of tokens that an owner allowed to a spender.
351    * @param _owner address The address which owns the funds.
352    * @param _spender address The address which will spend the funds.
353    * @return A uint256 specifying the amount of tokens still available for the spender.
354    */
355   function allowance(
356     address _owner,
357     address _spender
358    )
359     public
360     view
361     returns (uint256)
362   {
363     return allowed[_owner][_spender];
364   }
365 
366   /**
367    * @dev Increase the amount of tokens that an owner allowed to a spender.
368    * approve should be called when allowed[_spender] == 0. To increment
369    * allowed value is better to use this function to avoid 2 calls (and wait until
370    * the first transaction is mined)
371    * From MonolithDAO Token.sol
372    * @param _spender The address which will spend the funds.
373    * @param _addedValue The amount of tokens to increase the allowance by.
374    */
375   function increaseApproval(
376     address _spender,
377     uint256 _addedValue
378   )
379     public
380     returns (bool)
381   {
382     allowed[msg.sender][_spender] = (
383       allowed[msg.sender][_spender].add(_addedValue));
384     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385     return true;
386   }
387 
388   /**
389    * @dev Decrease the amount of tokens that an owner allowed to a spender.
390    * approve should be called when allowed[_spender] == 0. To decrement
391    * allowed value is better to use this function to avoid 2 calls (and wait until
392    * the first transaction is mined)
393    * From MonolithDAO Token.sol
394    * @param _spender The address which will spend the funds.
395    * @param _subtractedValue The amount of tokens to decrease the allowance by.
396    */
397   function decreaseApproval(
398     address _spender,
399     uint256 _subtractedValue
400   )
401     public
402     returns (bool)
403   {
404     uint256 oldValue = allowed[msg.sender][_spender];
405     if (_subtractedValue >= oldValue) {
406       allowed[msg.sender][_spender] = 0;
407     } else {
408       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
409     }
410     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
411     return true;
412   }
413 
414 }
415 
416 
417 
418 
419 /**
420  * @title DetailedERC20 token
421  * @dev The decimals are only for visualization purposes.
422  * All the operations are done using the smallest and indivisible token unit,
423  * just as on Ethereum all the operations are done in wei.
424  */
425 contract DetailedERC20 is ERC20 {
426   string public name;
427   string public symbol;
428   uint8 public decimals;
429 
430   constructor(string _name, string _symbol, uint8 _decimals) public {
431     name = _name;
432     symbol = _symbol;
433     decimals = _decimals;
434   }
435 }
436 
437 
438 
439 
440 
441 /**
442  * @title SafeMath
443  * @dev Math operations with safety checks that throw on error
444  */
445 library SafeMath {
446 
447   /**
448   * @dev Multiplies two numbers, throws on overflow.
449   */
450   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
451     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
452     // benefit is lost if 'b' is also tested.
453     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
454     if (_a == 0) {
455       return 0;
456     }
457 
458     c = _a * _b;
459     assert(c / _a == _b);
460     return c;
461   }
462 
463   /**
464   * @dev Integer division of two numbers, truncating the quotient.
465   */
466   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
467     // assert(_b > 0); // Solidity automatically throws when dividing by 0
468     // uint256 c = _a / _b;
469     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
470     return _a / _b;
471   }
472 
473   /**
474   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
475   */
476   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
477     assert(_b <= _a);
478     return _a - _b;
479   }
480 
481   /**
482   * @dev Adds two numbers, throws on overflow.
483   */
484   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
485     c = _a + _b;
486     assert(c >= _a);
487     return c;
488   }
489 }
490 
491 
492 
493 
494 
495 contract JinToken is
496   StandardToken,
497   DetailedERC20,
498   Ownable,
499   JinVestingRule,
500   Enlist {
501   using SafeMath for uint;
502   using Math for uint;
503 
504   uint public INITIAL_SUPPLY;
505 
506   mapping (address => mapping (bytes32 => uint)) private lockedAmount;
507   mapping (address => mapping (bytes32 => uint)) private alreadyClaim;
508 
509   // How many token units a buyer gets per microether.
510   // The rate is the conversion between
511   //    microeather and
512   //    the smallest and indivisible token unit.
513   // So, if you are using a rate of 1 with 5 decimals called KIM
514   // 1 microether will give you 1 unit, or 0.00001 KIM.
515   uint public rate;  // Crowdsale
516 
517   constructor (
518     string _name,     // "jinyitong"
519     string _symbol,   // "JIN", "KIN", "BGC"
520     uint8 _decimals,  // 5
521     address _startup,
522     address _angelfund,
523     address _techteam
524   )
525   DetailedERC20(
526     _name,
527     _symbol,
528     _decimals
529   )
530   JinVestingRule()
531   public {
532     rate = 30;
533     INITIAL_SUPPLY = 3.14e8;                 // initital supply 314,000,000 BGC
534     totalSupply_ = INITIAL_SUPPLY.mul(10 ** uint(decimals)); // BasicToken
535     balances[msg.sender] = totalSupply_;                     // BasicToken
536 
537     /* initial transferToLock */
538     uint jins = 0;
539 
540     jins = totalSupply_.div(100).mul(20);
541     _transferToLock(_startup, jins, 'STARTUP');
542 
543     jins = totalSupply_.div(100).mul(15);
544     transfer(_angelfund, jins); // _transferToLock(_angelfund, jins, 'ANGELFUND');
545 
546     jins = totalSupply_.div(100).mul(5);
547     _transferToLock(_techteam, jins, 'TECHTEAM');
548   }
549 
550   event TransferToLock (
551     address indexed to,
552     uint value,
553     string lockingType,
554     uint totalLocked
555   );
556 
557   event DoubleClaim (
558     address indexed user,
559     bytes32 _type,
560     address sender
561   );
562 
563   modifier onlyOwner() {
564     require(msg.sender == owner); // Ownable
565     _;
566   }
567 
568   /* Crowdsale */
569   function ()
570   external
571   payable {
572 
573     address user = msg.sender;
574     uint jins = _getTokenAmount(msg.value);
575 
576     require(jins >= 0);
577 
578     _transferToLock(user, jins, 'CROWDSALE');
579   }
580 
581   function _getTokenAmount(uint weiAmount) internal view returns (uint) {
582     uint _microAmount = weiAmount.div(10 ** 12);
583     return _microAmount.mul(rate);
584   }
585 
586   function setCrowdsaleRate(uint _rate) public onlyOwner() returns (bool) {
587     rate = _rate;
588     return true;
589   }
590 
591   function transferToLock (
592     address user,
593     uint amount,
594     bytes32 _type
595   ) public
596   onlyOwner()
597   validateRuleName(_type)
598   returns (bool) {
599     _transferToLock(user, amount, _type);
600     return true;
601   }
602 
603   function _transferToLock (
604     address _to,
605     uint _value,
606     bytes32 _type
607   ) internal
608   returns (bool) {
609     address _from = owner;
610 
611     require(_value > 0);
612     require(_value <= balances[_from]);
613     require(_to != address(0));
614 
615     balances[_from] = balances[_from].sub(_value);
616     lockedAmount[_to][_type] = lockedAmount[_to][_type].add(_value);
617 
618     emit TransferToLock(_to, _value, bytes32ToString(_type), lockedAmount[_to][_type]);
619 
620     setRecord(_to, _type);
621 
622     return true;
623   }
624 
625   function claimToken (
626     address user,
627     bytes32 _type
628   ) public
629   validateRuleName(_type)
630   returns (bool) {
631     require(lockedAmount[user][_type] > 0);
632     uint approved = approvedRatio(_type);
633     uint availableToClaim =
634       lockedAmount[user][_type].mul(approved).div(100);
635     uint amountToClaim = availableToClaim.sub(alreadyClaim[user][_type]);
636 
637     if (amountToClaim > 0) {
638       balances[user] = balances[user].add(amountToClaim);
639       alreadyClaim[user][_type] = availableToClaim;
640     } else if (amountToClaim == 0) {
641       emit DoubleClaim(
642         user,
643         _type,
644         msg.sender
645       );
646     } else {
647     }
648 
649     return true;
650   }
651 
652   function approvedRatio (
653     bytes32 _type
654   ) internal view returns (uint) {
655       uint _now = getTime();
656       uint cliff = rules[ruleNumbering[_type]].cliff;
657 
658       require(_now >= cliff);
659 
660       uint baseRatio = rules[ruleNumbering[_type]].baseRatio;
661       uint incrRatio = rules[ruleNumbering[_type]].incrRatio;
662 
663       return Math.min256(
664         100,
665         _now
666         .sub( cliff )
667         .div( period ) // a month
668         .mul( incrRatio )
669         .add( baseRatio )
670       );
671   }
672 
673   function getLockedAvailable (
674     address user,
675     bytes32 _type
676   ) public view
677   validateRuleName(_type)
678   returns (uint) {
679     uint record;
680 
681     record = lockedAmount[user][_type].sub(alreadyClaim[user][_type]);
682 
683     return record;
684   }
685 
686   function getTime () public view returns (uint) {
687     return block.timestamp; // now
688   }
689 }