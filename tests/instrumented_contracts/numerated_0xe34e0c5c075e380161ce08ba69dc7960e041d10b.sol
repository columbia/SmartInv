1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(
144     address _from,
145     address _to,
146     uint256 _value
147   )
148     public
149     returns (bool)
150   {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to transfer control of the contract to a newOwner.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     require(newOwner != address(0));
285     emit OwnershipTransferred(owner, newOwner);
286     owner = newOwner;
287   }
288 
289   /**
290    * @dev Allows the current owner to relinquish control of the contract.
291    */
292   function renounceOwnership() public onlyOwner {
293     emit OwnershipRenounced(owner);
294     owner = address(0);
295   }
296 }
297 
298 contract VestingToken is StandardToken {
299   using SafeMath for uint256;
300   mapping(address => uint256) public vested;
301   mapping(address => uint256) public released;
302   uint256 public totalVested;
303   uint256 public vestingStartTime;
304   uint256 public vestingStageTime = 2592000; // 30 days
305 
306   function vestedTo (address _address) public view returns (uint256) {
307     return vested[_address];
308   }
309 
310   function releasedTo (address _address) public view returns (uint256) {
311     return released[_address];
312   }
313 
314   function getShare () internal view returns (uint8) {
315     uint256 elapsedTime = now.sub(vestingStartTime);
316     if (elapsedTime > vestingStageTime.mul(3)) return uint8(100);
317     if (elapsedTime > vestingStageTime.mul(2)) return uint8(75);
318     if (elapsedTime > vestingStageTime) return uint8(50);   
319     return uint8(25);
320   }
321 
322   function release () public returns (bool) {
323     uint8 shareForRelease = getShare(); // in percent
324     uint256 tokensForRelease = vested[msg.sender].mul(shareForRelease).div(100);
325     tokensForRelease = tokensForRelease.sub(released[msg.sender]);
326     require(tokensForRelease > 0);
327     released[msg.sender] = released[msg.sender].add(tokensForRelease);
328     balances[msg.sender] = balances[msg.sender].add(tokensForRelease);
329     totalSupply_ = totalSupply_.add(tokensForRelease);
330     emit Release(msg.sender, tokensForRelease);
331     return true;
332   }
333   event Vest(address indexed to, uint256 value);
334   event Release(address indexed to, uint256 value);
335 }
336 
337 contract CrowdsaleToken is VestingToken, Ownable {
338   using SafeMath for uint64;
339   uint64 public cap = 3170000000;
340   uint64 public saleCap = 1866912500;
341   uint64 public team = 634000000;
342   uint64 public advisors = 317000000;
343   uint64 public mlDevelopers = 79250000;
344   uint64 public marketing = 87175000;
345   uint64 public reserved = 185662500;
346   uint64 public basePrice = 18750;
347   uint64 public icoPeriodTime = 604800;
348   uint256 public sold = 0;
349   uint256 public currentIcoPeriodStartDate;
350   uint256 public icoEndDate;
351   bool public preSaleComplete = false;
352 
353   enum Stages {Pause, PreSale, Ico1, Ico2, Ico3, Ico4, IcoEnd}
354   Stages currentStage;
355 
356   mapping(uint8 => uint64) public stageCap;
357 
358   mapping(uint8 => uint256) public stageSupply;
359 
360   constructor() public {
361     currentStage = Stages.Pause;
362     stageCap[uint8(Stages.PreSale)] = 218750000;
363     stageCap[uint8(Stages.Ico1)] = 115200000;
364     stageCap[uint8(Stages.Ico2)] = 165312500;
365     stageCap[uint8(Stages.Ico3)] = 169400000;
366     stageCap[uint8(Stages.Ico4)] = 1198250000;
367   }
368 
369   function startPreSale () public onlyOwner returns (bool) {
370     require(currentStage == Stages.Pause);
371     require(!preSaleComplete);
372     currentStage = Stages.PreSale;
373     return true;
374   }
375 
376   function endPreSale () public onlyOwner returns (bool) {
377     require(currentStage == Stages.PreSale);
378     currentStage = Stages.Pause;
379     preSaleComplete = true;
380     return true;
381   }
382 
383   function startIco () public onlyOwner returns (bool) {
384     require(currentStage == Stages.Pause);
385     require(preSaleComplete);
386     currentStage = Stages.Ico1;
387     currentIcoPeriodStartDate = now;
388     return true;
389   }
390 
391   function endIco () public onlyOwner returns (bool) {
392     if (currentStage != Stages.Ico1 && currentStage != Stages.Ico2 && currentStage != Stages.Ico3 && currentStage != Stages.Ico4) revert();
393     currentStage = Stages.IcoEnd;
394     icoEndDate = now;
395     vestingStartTime = now;
396     uint256 unsoldTokens = saleCap.sub(sold);
397     balances[address(this)] = unsoldTokens;
398     totalSupply_ = totalSupply_.add(unsoldTokens);
399     return true;
400   }
401 
402   function sendUnsold (address _to, uint256 _value) public onlyOwner {
403     require(_value <= balances[address(this)]);
404     balances[address(this)] = balances[address(this)].sub(_value);
405     balances[_to] = balances[_to].add(_value);
406     emit Transfer(address(this), _to, _value);
407   }
408 
409   function getReserve () public onlyOwner returns (bool) {
410     require(reserved > 0);
411     balances[owner] = balances[owner].add(reserved);
412     totalSupply_ = totalSupply_.add(reserved);
413     emit Transfer(address(this), owner, reserved);
414     reserved = 0;
415     return true;   
416   }
417 
418   function vest2team (address _address) public onlyOwner returns (bool) {
419     require(team > 0);
420     vested[_address] = vested[_address].add(team);
421     totalVested = totalVested.add(team);
422     team = 0;
423     emit Vest(_address, team);
424     return true;   
425   }
426 
427   function vest2advisors (address _address) public onlyOwner returns (bool) {
428     require(advisors > 0);
429     vested[_address] = vested[_address].add(advisors);
430     totalVested = totalVested.add(advisors);
431     advisors = 0;
432     emit Vest(_address, advisors);
433     return true;       
434   }
435 
436   function send2marketing (address _address) public onlyOwner returns (bool) {
437     require(marketing > 0);
438     balances[_address] = balances[_address].add(marketing);
439     totalSupply_ = totalSupply_.add(marketing);
440     emit Transfer(address(this), _address, marketing);
441     marketing = 0;
442     return true;           
443   }
444 
445   function vest2mlDevelopers (address _address) public onlyOwner returns (bool) {
446     require(mlDevelopers > 0);
447     vested[_address] = vested[_address].add(mlDevelopers);
448     totalVested = totalVested.add(mlDevelopers);
449     mlDevelopers = 0;
450     emit Vest(_address, mlDevelopers);
451     return true;           
452   }
453 
454   function vest2all (address _address) public onlyOwner returns (bool) {
455     if (team > 0) {
456       vested[_address] = vested[_address].add(team);
457       totalVested = totalVested.add(team);
458       team = 0;
459       emit Vest(_address, team);      
460     }
461     if (advisors > 0) {
462       vested[_address] = vested[_address].add(advisors);
463       totalVested = totalVested.add(advisors);
464       advisors = 0;
465       emit Vest(_address, advisors);      
466     }
467     if (mlDevelopers > 0) {
468       vested[_address] = vested[_address].add(mlDevelopers);
469       totalVested = totalVested.add(mlDevelopers);
470       mlDevelopers = 0;
471       emit Vest(_address, mlDevelopers);      
472     }
473     return true;          
474   }
475 
476   function getBonuses () internal view returns (uint8) {
477     if (currentStage == Stages.PreSale) {
478       return 25;
479     }
480     if (currentStage == Stages.Ico1) {
481       return 20;
482     }
483     if (currentStage == Stages.Ico2) {
484       return 15;
485     }
486     if (currentStage == Stages.Ico3) {
487       return 10;
488     }
489     return 0;
490   }
491 
492   function vestTo (address _to, uint256 _value) public onlyOwner returns (bool) {
493     require(currentStage != Stages.Pause);
494     require(currentStage != Stages.IcoEnd);
495     require(_to != address(0));
496     stageSupply[uint8(currentStage)] = stageSupply[uint8(currentStage)].add(_value);
497     require(stageSupply[uint8(currentStage)] <= stageCap[uint8(currentStage)]);
498     vested[_to] = vested[_to].add(_value);
499     sold = sold.add(_value);
500     totalVested = totalVested.add(_value);
501     emit Vest(_to, _value);
502     return true;
503   }
504 
505   function getTokensAmount (uint256 _wei, address _sender) internal returns (uint256) {
506     require(currentStage != Stages.IcoEnd);
507     require(currentStage != Stages.Pause);
508     uint256 tokens = _wei.mul(basePrice).div(1 ether);
509     uint256 extraTokens = 0;
510     uint256 stageRemains = 0;
511     uint256 stagePrice = 0;
512     uint256 stageBonuses = 0;
513     uint256 spentWei = 0;
514     uint256 change = 0;
515     uint8 bonuses = 0;
516     if (currentStage == Stages.PreSale) {
517       require(_wei >= 100 finney);
518       bonuses = getBonuses();
519       extraTokens = tokens.mul(bonuses).div(100);
520       tokens = tokens.add(extraTokens);
521       stageSupply[uint8(currentStage)] = stageSupply[uint8(currentStage)].add(tokens);
522       require(stageSupply[uint8(currentStage)] <= stageCap[uint8(currentStage)]);
523       return tokens;
524     }
525     require(_wei >= 1 ether);
526     if (currentStage == Stages.Ico4) {
527       stageSupply[uint8(currentStage)] = stageSupply[uint8(currentStage)].add(tokens);
528       require(stageSupply[uint8(currentStage)] <= stageCap[uint8(currentStage)]);
529       return tokens;
530     } else {
531       if (currentIcoPeriodStartDate.add(icoPeriodTime) < now) nextStage(true);
532       bonuses = getBonuses();
533       stageRemains = stageCap[uint8(currentStage)].sub(stageSupply[uint8(currentStage)]);
534       extraTokens = tokens.mul(bonuses).div(100);
535       tokens = tokens.add(extraTokens);
536       if (stageRemains > tokens) {
537         stageSupply[uint8(currentStage)] = stageSupply[uint8(currentStage)].add(tokens);
538         return tokens;
539       } else {
540         stageBonuses = basePrice.mul(bonuses).div(100);
541         stagePrice = basePrice.add(stageBonuses);
542         tokens = stageRemains;
543         stageSupply[uint8(currentStage)] = stageCap[uint8(currentStage)];
544         spentWei = tokens.mul(1 ether).div(stagePrice);
545         change = _wei.sub(spentWei);
546         nextStage(false);
547         _sender.transfer(change);
548         return tokens;
549       }
550     }
551   }
552 
553   function nextStage (bool _time) internal returns (bool) {
554     if (_time) {
555       if (currentStage == Stages.Ico1) {
556         if (currentIcoPeriodStartDate.add(icoPeriodTime).mul(3) < now) {
557           currentStage = Stages.Ico4;
558           currentIcoPeriodStartDate = now;
559           return true;
560         }
561         if (currentIcoPeriodStartDate.add(icoPeriodTime).mul(2) < now) {
562           currentStage = Stages.Ico3;
563           currentIcoPeriodStartDate = now;
564           return true;
565         }
566         currentStage = Stages.Ico2;
567         currentIcoPeriodStartDate = now;
568         return true;
569       }
570       if (currentStage == Stages.Ico2) {
571         if (currentIcoPeriodStartDate.add(icoPeriodTime).mul(2) < now) {
572           currentStage = Stages.Ico4;
573           currentIcoPeriodStartDate = now;
574           return true;
575         }
576         currentStage = Stages.Ico3;
577         currentIcoPeriodStartDate = now;
578         return true;
579       }
580       if (currentStage == Stages.Ico3) {
581         currentStage = Stages.Ico4;
582         currentIcoPeriodStartDate = now;
583         return true;
584       }
585     } else {
586       if (currentStage == Stages.Ico1) {
587         currentStage = Stages.Ico2;
588         currentIcoPeriodStartDate = now;
589         return true;      
590       }
591       if (currentStage == Stages.Ico2) {
592         currentStage = Stages.Ico3;
593         currentIcoPeriodStartDate = now;
594         return true;      
595       }
596       if (currentStage == Stages.Ico3) {
597         currentStage = Stages.Ico4;
598         currentIcoPeriodStartDate = now;
599         return true;      
600       }
601     }
602   }
603 
604   function () public payable {
605     uint256 tokens = getTokensAmount(msg.value, msg.sender);
606     vested[msg.sender] = vested[msg.sender].add(tokens);
607     sold = sold.add(tokens);
608     totalVested = totalVested.add(tokens);
609     emit Vest(msg.sender, tokens);
610   }
611 }
612 
613 contract Multisign is Ownable {
614   address public address1 = address(0);
615   address public address2 = address(0);
616   address public address3 = address(0);
617   mapping(address => address) public withdrawAddress;
618 
619   function setAddresses (address _address1, address _address2, address _address3) public onlyOwner returns (bool) {
620     require(address1 == address(0) && address2 == address(0) && address3 == address(0));
621     require(_address1 != address(0) && _address2 != address(0) && _address3 != address(0));
622     address1 = _address1;
623     address2 = _address2;
624     address3 = _address3;
625     return true;
626   }
627 
628   function signWithdraw (address _address) public returns (bool) {
629     assert(msg.sender != address(0));
630     require (msg.sender == address1 || msg.sender == address2 || msg.sender == address3);
631     require (_address != address(0));
632     withdrawAddress[msg.sender] = _address;
633     if (withdrawAddress[address1] == withdrawAddress[address2] && withdrawAddress[address1] != address(0)) {
634       withdraw(withdrawAddress[address1]);
635       return true;
636     }
637     if (withdrawAddress[address1] == withdrawAddress[address3] && withdrawAddress[address1] != address(0)) {
638       withdraw(withdrawAddress[address1]);
639       return true;
640     }
641     if (withdrawAddress[address2] == withdrawAddress[address3] && withdrawAddress[address2] != address(0)) {
642       withdraw(withdrawAddress[address2]);
643       return true;
644     }
645     return false;
646   }
647 
648   function withdraw (address _address) internal returns (bool) {
649     require(address(this).balance > 0);
650     withdrawAddress[address1] = address(0);
651     withdrawAddress[address2] = address(0);
652     withdrawAddress[address3] = address(0);
653     _address.transfer(address(this).balance);
654     return true;
655   }
656 }
657 
658 contract NSD is CrowdsaleToken, Multisign {
659   string public constant name = "NeuroSeed";
660   string public constant symbol = "NSD";
661   uint32 public constant decimals = 0;
662 }