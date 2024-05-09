1 pragma solidity ^0.4.18;
2 
3 contract DateTime {
4         /*
5          *  Date and Time utilities for ethereum contracts
6          *
7          */
8         struct _DateTime {
9                 uint16 year;
10                 uint8 month;
11                 uint8 day;
12                 uint8 hour;
13                 uint8 minute;
14                 uint8 second;
15                 uint8 weekday;
16         }
17 
18         uint constant DAY_IN_SECONDS = 86400;
19         uint constant YEAR_IN_SECONDS = 31536000;
20         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
21 
22         uint constant HOUR_IN_SECONDS = 3600;
23         uint constant MINUTE_IN_SECONDS = 60;
24 
25         uint16 constant ORIGIN_YEAR = 1970;
26 
27         function isLeapYear(uint16 year) public pure returns (bool) {
28                 if (year % 4 != 0) {
29                         return false;
30                 }
31                 if (year % 100 != 0) {
32                         return true;
33                 }
34                 if (year % 400 != 0) {
35                         return false;
36                 }
37                 return true;
38         }
39 
40         function leapYearsBefore(uint year) public pure returns (uint) {
41                 year -= 1;
42                 return year / 4 - year / 100 + year / 400;
43         }
44 
45         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
46                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
47                         return 31;
48                 }
49                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
50                         return 30;
51                 }
52                 else if (isLeapYear(year)) {
53                         return 29;
54                 }
55                 else {
56                         return 28;
57                 }
58         }
59 
60         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
61                 uint secondsAccountedFor = 0;
62                 uint buf;
63                 uint8 i;
64 
65                 // Year
66                 dt.year = getYear(timestamp);
67                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
68 
69                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
70                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
71 
72                 // Month
73                 uint secondsInMonth;
74                 for (i = 1; i <= 12; i++) {
75                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
76                         if (secondsInMonth + secondsAccountedFor > timestamp) {
77                                 dt.month = i;
78                                 break;
79                         }
80                         secondsAccountedFor += secondsInMonth;
81                 }
82 
83                 // Day
84                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
85                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
86                                 dt.day = i;
87                                 break;
88                         }
89                         secondsAccountedFor += DAY_IN_SECONDS;
90                 }
91 
92                 // Hour
93                 dt.hour = getHour(timestamp);
94 
95                 // Minute
96                 dt.minute = getMinute(timestamp);
97 
98                 // Second
99                 dt.second = getSecond(timestamp);
100 
101                 // Day of week.
102                 dt.weekday = getWeekday(timestamp);
103         }
104 
105         function getYear(uint timestamp) public pure returns (uint16) {
106                 uint secondsAccountedFor = 0;
107                 uint16 year;
108                 uint numLeapYears;
109 
110                 // Year
111                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
112                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
113 
114                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
115                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
116 
117                 while (secondsAccountedFor > timestamp) {
118                         if (isLeapYear(uint16(year - 1))) {
119                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
120                         }
121                         else {
122                                 secondsAccountedFor -= YEAR_IN_SECONDS;
123                         }
124                         year -= 1;
125                 }
126                 return year;
127         }
128 
129         function getMonth(uint timestamp) public pure returns (uint8) {
130                 return parseTimestamp(timestamp).month;
131         }
132 
133         function getDay(uint timestamp) public pure returns (uint8) {
134                 return parseTimestamp(timestamp).day;
135         }
136 
137         function getHour(uint timestamp) public pure returns (uint8) {
138                 return uint8((timestamp / 60 / 60) % 24);
139         }
140 
141         function getMinute(uint timestamp) public pure returns (uint8) {
142                 return uint8((timestamp / 60) % 60);
143         }
144 
145         function getSecond(uint timestamp) public pure returns (uint8) {
146                 return uint8(timestamp % 60);
147         }
148 
149         function getWeekday(uint timestamp) public pure returns (uint8) {
150                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
151         }
152 
153         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
154                 return toTimestamp(year, month, day, 0, 0, 0);
155         }
156 
157         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
158                 return toTimestamp(year, month, day, hour, 0, 0);
159         }
160 
161         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
162                 return toTimestamp(year, month, day, hour, minute, 0);
163         }
164 
165         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
166                 uint16 i;
167 
168                 // Year
169                 for (i = ORIGIN_YEAR; i < year; i++) {
170                         if (isLeapYear(i)) {
171                                 timestamp += LEAP_YEAR_IN_SECONDS;
172                         }
173                         else {
174                                 timestamp += YEAR_IN_SECONDS;
175                         }
176                 }
177 
178                 // Month
179                 uint8[12] memory monthDayCounts;
180                 monthDayCounts[0] = 31;
181                 if (isLeapYear(year)) {
182                         monthDayCounts[1] = 29;
183                 }
184                 else {
185                         monthDayCounts[1] = 28;
186                 }
187                 monthDayCounts[2] = 31;
188                 monthDayCounts[3] = 30;
189                 monthDayCounts[4] = 31;
190                 monthDayCounts[5] = 30;
191                 monthDayCounts[6] = 31;
192                 monthDayCounts[7] = 31;
193                 monthDayCounts[8] = 30;
194                 monthDayCounts[9] = 31;
195                 monthDayCounts[10] = 30;
196                 monthDayCounts[11] = 31;
197 
198                 for (i = 1; i < month; i++) {
199                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
200                 }
201 
202                 // Day
203                 timestamp += DAY_IN_SECONDS * (day - 1);
204 
205                 // Hour
206                 timestamp += HOUR_IN_SECONDS * (hour);
207 
208                 // Minute
209                 timestamp += MINUTE_IN_SECONDS * (minute);
210 
211                 // Second
212                 timestamp += second;
213 
214                 return timestamp;
215         }
216 }
217 pragma solidity ^0.4.18;
218 
219 
220 /**
221  * @title ERC20Basic
222  * @dev Simpler version of ERC20 interface
223  * @dev see https://github.com/ethereum/EIPs/issues/179
224  */
225 contract ERC20Basic {
226   uint256 public totalSupply;
227   function balanceOf(address who) public view returns (uint256);
228   function transfer(address to, uint256 value) public returns (bool);
229   event Transfer(address indexed from, address indexed to, uint256 value);
230 }
231 
232 
233 /**
234  * @title ERC20 interface
235  * @dev see https://github.com/ethereum/EIPs/issues/20
236  */
237 contract ERC20 is ERC20Basic {
238   function allowance(address owner, address spender) public view returns (uint256);
239   function transferFrom(address from, address to, uint256 value) public returns (bool);
240   function approve(address spender, uint256 value) public returns (bool);
241   event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 /**
245  * @title Basic token
246  * @dev Basic version of StandardToken, with no allowances.
247  */
248 contract BasicToken is ERC20Basic {
249   using SafeMath for uint256;
250 
251   mapping(address => uint256) balances;
252 
253   /**
254   * @dev transfer token for a specified address
255   * @param _to The address to transfer to.
256   * @param _value The amount to be transferred.
257   */
258   function transfer(address _to, uint256 _value) public returns (bool) {
259     require(_to != address(0));
260     require(_value <= balances[msg.sender]);
261 
262     // SafeMath.sub will throw if there is not enough balance.
263     balances[msg.sender] = balances[msg.sender].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     Transfer(msg.sender, _to, _value);
266     return true;
267   }
268 
269   /**
270   * @dev Gets the balance of the specified address.
271   * @param _owner The address to query the the balance of.
272   * @return An uint256 representing the amount owned by the passed address.
273   */
274   function balanceOf(address _owner) public view returns (uint256 balance) {
275     return balances[_owner];
276   }
277 
278 }
279 pragma solidity ^0.4.18;
280 
281 
282 /**
283  * @title Ownable
284  * @dev The Ownable contract has an owner address, and provides basic authorization control
285  * functions, this simplifies the implementation of "user permissions".
286  */
287 contract Ownable {
288   address public owner;
289 
290 
291   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293 
294   /**
295    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
296    * account.
297    */
298   function Ownable() public {
299     owner = msg.sender;
300   }
301 
302   /**
303    * @dev Throws if called by any account other than the owner.
304    */
305   modifier onlyOwner() {
306     require(msg.sender == owner);
307     _;
308   }
309 
310 
311   /**
312    * @dev Allows the current owner to transfer control of the contract to a newOwner.
313    * @param newOwner The address to transfer ownership to.
314    */
315   function transferOwnership(address newOwner) public onlyOwner {
316     require(newOwner != address(0));
317     OwnershipTransferred(owner, newOwner);
318     owner = newOwner;
319   }
320 
321 }
322 
323 
324 /**
325  * @title Standard ERC20 token
326  *
327  * @dev Implementation of the basic standard token.
328  * @dev https://github.com/ethereum/EIPs/issues/20
329  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
330  */
331 contract StandardToken is ERC20, BasicToken {
332 
333   mapping (address => mapping (address => uint256)) internal allowed;
334 
335 
336   /**
337    * @dev Transfer tokens from one address to another
338    * @param _from address The address which you want to send tokens from
339    * @param _to address The address which you want to transfer to
340    * @param _value uint256 the amount of tokens to be transferred
341    */
342   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
343     require(_to != address(0));
344     require(_value <= balances[_from]);
345     require(_value <= allowed[_from][msg.sender]);
346 
347     balances[_from] = balances[_from].sub(_value);
348     balances[_to] = balances[_to].add(_value);
349     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
350     Transfer(_from, _to, _value);
351     return true;
352   }
353 
354   /**
355    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
356    *
357    * Beware that changing an allowance with this method brings the risk that someone may use both the old
358    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
359    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
360    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
361    * @param _spender The address which will spend the funds.
362    * @param _value The amount of tokens to be spent.
363    */
364   function approve(address _spender, uint256 _value) public returns (bool) {
365     allowed[msg.sender][_spender] = _value;
366     Approval(msg.sender, _spender, _value);
367     return true;
368   }
369 
370   /**
371    * @dev Function to check the amount of tokens that an owner allowed to a spender.
372    * @param _owner address The address which owns the funds.
373    * @param _spender address The address which will spend the funds.
374    * @return A uint256 specifying the amount of tokens still available for the spender.
375    */
376   function allowance(address _owner, address _spender) public view returns (uint256) {
377     return allowed[_owner][_spender];
378   }
379 
380   /**
381    * @dev Increase the amount of tokens that an owner allowed to a spender.
382    *
383    * approve should be called when allowed[_spender] == 0. To increment
384    * allowed value is better to use this function to avoid 2 calls (and wait until
385    * the first transaction is mined)
386    * From MonolithDAO Token.sol
387    * @param _spender The address which will spend the funds.
388    * @param _addedValue The amount of tokens to increase the allowance by.
389    */
390   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
391     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
392     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
393     return true;
394   }
395 
396   /**
397    * @dev Decrease the amount of tokens that an owner allowed to a spender.
398    *
399    * approve should be called when allowed[_spender] == 0. To decrement
400    * allowed value is better to use this function to avoid 2 calls (and wait until
401    * the first transaction is mined)
402    * From MonolithDAO Token.sol
403    * @param _spender The address which will spend the funds.
404    * @param _subtractedValue The amount of tokens to decrease the allowance by.
405    */
406   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
407     uint oldValue = allowed[msg.sender][_spender];
408     if (_subtractedValue > oldValue) {
409       allowed[msg.sender][_spender] = 0;
410     } else {
411       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
412     }
413     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
414     return true;
415   }
416 
417 }
418 pragma solidity ^0.4.18;
419 
420 
421 /**
422  * @title SafeMath
423  * @dev Math operations with safety checks that throw on error
424  */
425 library SafeMath {
426   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
427     if (a == 0) {
428       return 0;
429     }
430     uint256 c = a * b;
431     assert(c / a == b);
432     return c;
433   }
434 
435   function div(uint256 a, uint256 b) internal pure returns (uint256) {
436     // assert(b > 0); // Solidity automatically throws when dividing by 0
437     uint256 c = a / b;
438     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
439     return c;
440   }
441 
442   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
443     assert(b <= a);
444     return a - b;
445   }
446 
447   function add(uint256 a, uint256 b) internal pure returns (uint256) {
448     uint256 c = a + b;
449     assert(c >= a);
450     return c;
451   }
452 }
453 
454 
455 /**
456  * @title Destructible
457  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
458  */
459 contract Destructible is Ownable {
460 
461     function Destructible() public payable { }
462 
463     /**
464      * @dev Transfers the current balance to the owner and terminates the contract.
465      */
466     function destroy() onlyOwner public {
467         selfdestruct(owner);
468     }
469 
470     function destroyAndSend(address _recipient) onlyOwner public {
471         selfdestruct(_recipient);
472     }
473 }
474 
475 
476 /**
477  * @title Pausable
478  * @dev Base contract which allows children to implement an emergency stop mechanism.
479  */
480 contract Pausable is Ownable {
481     event Pause();
482     event Unpause();
483 
484     bool public paused = false;
485 
486 
487     /**
488      * @dev Modifier to make a function callable only when the contract is not paused.
489      */
490     modifier whenNotPaused() {
491         require(!paused);
492         _;
493     }
494 
495     /**
496      * @dev Modifier to make a function callable only when the contract is paused.
497      */
498     modifier whenPaused() {
499         require(paused);
500         _;
501     }
502 
503     /**
504      * @dev called by the owner to pause, triggers stopped state
505      */
506     function pause() onlyOwner whenNotPaused public {
507         paused = true;
508         Pause();
509     }
510 
511     /**
512      * @dev called by the owner to unpause, returns to normal state
513      */
514     function unpause() onlyOwner whenPaused public {
515         paused = false;
516         Unpause();
517     }
518 }
519 
520 
521 /// @title ABAToken - Token code for the ABA Project
522 /// @author David Chen, Jacky Lin
523 contract ABAToken is StandardToken, Ownable, Pausable, Destructible {
524 
525     using SafeMath for uint;
526     string public constant name = "EcosBall";
527     string public constant symbol = "ABA";
528     uint public constant decimals = 18;
529 
530     DateTime public dateTime;
531 
532     uint constant million=1000000e18;
533     //total token supply: 2.1 billion
534     uint constant totalToken = 2100*million;
535     //miner reward: 1.47 billion, 70% in 30 years, locked in the first year, 3.45% per year started from second year
536     uint constant minerTotalSupply = 1470*million;
537     //fund:105 million,5%, locked at least 1 year
538     uint constant fundTotalSupply = 105*million;
539     //IEO supply 105 million,5%
540     uint constant ieoTotalSupply = 105*million;
541     //Project team 105 million,5%, 12.5% of them are released in every 6 months
542     uint constant projectTotalSupply = 105*million;
543     //presale supply 105 million,5%
544     uint constant presaleTotalSupply = 105*million;
545     //market and community: 210 million, 10%, 50% of them are locked for 1 year
546     uint constant market_communityTotalSupply = 210*million;
547 
548     uint projectUsedTokens = 0;
549     uint market_communityUsedTokens = 0;
550 
551     bool bAllocFund = false;
552     bool bAllocMarket_community = false;
553     bool bAllocProject1 = false;
554     bool bAllocProject2 = false;
555     bool bAllocProject3 = false;
556     bool bAllocProject4 = false;
557     bool bAllocProject5 = false;
558     bool bAllocProject6 = false;
559     bool bAllocProject7 = false;
560     bool bAllocProject8 = false;
561     uint constant perProjectAlloc = 13125000e18;
562 
563     address public fundStorageVault;
564     address public ieoStorageVault;
565     address public projectStorageVault;
566     address public presaleStorageVault;
567     address public market_communityStorageVault;
568 
569     //@notice  Constructor of ABAToken
570     function ABAToken() {
571       totalSupply = totalToken;
572       fundStorageVault = 0xa5b2F189552d3200fF393a38cCD90D63F3a99D08;
573       ieoStorageVault = 0x07D150A514EB394efe4879d530C4c6C710509Da7;
574       projectStorageVault = 0xd275eD1359F89251FbDeCdCbC196B57Ad71B851c;
575       presaleStorageVault = 0xeA426B782D7526d5236Ff39515696cB096F5Af0A;
576       market_communityStorageVault = 0xA408529eb7a233808F4c37308ed52e02046e7B09;
577 
578       balances[fundStorageVault] = 0;
579       balances[ieoStorageVault] = ieoTotalSupply;
580       balances[projectStorageVault] = 0;
581       balances[presaleStorageVault] = presaleTotalSupply;
582       market_communityUsedTokens = market_communityTotalSupply.div(2);
583       balances[market_communityStorageVault] = market_communityUsedTokens;
584 
585       dateTime = new DateTime();
586       balances[msg.sender] = minerTotalSupply;
587     }
588 
589     function allocateFundToken() onlyOwner whenNotPaused external {
590       if (now < dateTime.toTimestamp(2019,4,15)) throw;
591       if (bAllocFund) throw;
592       bAllocFund = true;
593       balances[fundStorageVault] = balances[fundStorageVault].add(fundTotalSupply);
594     }
595 
596     function getProjectUsedTokens() constant returns (uint256) {
597       return projectUsedTokens;
598     }
599 
600     function getProjectUnusedTokens() constant returns (uint256) {
601       if(projectUsedTokens > projectTotalSupply) throw;
602       uint projectUnusedTokens = projectTotalSupply.sub(projectUsedTokens);
603       return projectUnusedTokens;
604     }
605 
606     function allocate1ProjectToken() onlyOwner whenNotPaused external {
607       if (now < dateTime.toTimestamp(2018,6,30)) throw;
608       if (bAllocProject1) throw;
609       bAllocProject1 = true;
610       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
611       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
612     }
613 
614     function allocate2ProjectToken() onlyOwner whenNotPaused external {
615       if (now < dateTime.toTimestamp(2018,12,31)) throw;
616       if (bAllocProject2) throw;
617       bAllocProject2 = true;
618       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
619       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
620     }
621 
622     function allocate3ProjectToken() onlyOwner whenNotPaused external {
623       if (now < dateTime.toTimestamp(2019,6,30)) throw;
624       if (bAllocProject3) throw;
625       bAllocProject3 = true;
626       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
627       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
628     }
629 
630     function allocate4ProjectToken() onlyOwner whenNotPaused external {
631       if (now < dateTime.toTimestamp(2019,12,31)) throw;
632       if (bAllocProject4) throw;
633       bAllocProject4 = true;
634       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
635       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
636     }
637 
638     function allocate5ProjectToken() onlyOwner whenNotPaused external {
639       if (now < dateTime.toTimestamp(2020,6,30)) throw;
640       if (bAllocProject5) throw;
641       bAllocProject5 = true;
642       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
643       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
644     }
645 
646     function allocate6ProjectToken() onlyOwner whenNotPaused external {
647       if (now < dateTime.toTimestamp(2020,12,31)) throw;
648       if (bAllocProject6) throw;
649       bAllocProject6 = true;
650       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
651       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
652     }
653 
654     function allocate7ProjectToken() onlyOwner whenNotPaused external {
655       if (now < dateTime.toTimestamp(2021,6,30)) throw;
656       if (bAllocProject7) throw;
657       bAllocProject7 = true;
658       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
659       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
660     }
661 
662     function allocate8ProjectToken() onlyOwner whenNotPaused external {
663       if (now < dateTime.toTimestamp(2021,12,31)) throw;
664       if (bAllocProject8) throw;
665       bAllocProject8 = true;
666       projectUsedTokens = projectUsedTokens.add(perProjectAlloc);
667       balances[projectStorageVault] = balances[projectStorageVault].add(perProjectAlloc);
668     }
669 
670     function allocateMarket_CommunitTokens() onlyOwner whenNotPaused external {
671       if (now < dateTime.toTimestamp(2019,4,15)) throw;
672       if (bAllocMarket_community) throw;
673       bAllocMarket_community = true;
674       uint nowAllocateTokens = market_communityTotalSupply.div(2);
675       market_communityUsedTokens = market_communityUsedTokens.add(market_communityUsedTokens);
676       balances[market_communityStorageVault] = balances[market_communityStorageVault].add(nowAllocateTokens);
677     }
678 
679     function getMarket_CommunitUsedTokens() constant returns (uint256) {
680       return market_communityUsedTokens;
681     }
682 
683     function getMarket_CommunitUnusedTokens() constant returns (uint256) {
684       if(market_communityUsedTokens > market_communityTotalSupply) throw;
685       uint market_communityUnusedTokens = market_communityTotalSupply.sub(market_communityUsedTokens);
686       return market_communityUnusedTokens;
687     }
688 }