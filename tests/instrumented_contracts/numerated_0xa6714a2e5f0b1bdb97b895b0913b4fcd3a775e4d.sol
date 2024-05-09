1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 contract DateTime {
18         /*
19          *  Date and Time utilities for ethereum contracts
20          *
21          */
22         struct _DateTime {
23                 uint16 year;
24                 uint8 month;
25                 uint8 day;
26                 uint8 hour;
27                 uint8 minute;
28                 uint8 second;
29                 uint8 weekday;
30         }
31 
32         uint constant DAY_IN_SECONDS = 86400;
33         uint constant YEAR_IN_SECONDS = 31536000;
34         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
35 
36         uint constant HOUR_IN_SECONDS = 3600;
37         uint constant MINUTE_IN_SECONDS = 60;
38 
39         uint16 constant ORIGIN_YEAR = 1970;
40 
41         function isLeapYear(uint16 year) public pure returns (bool) {
42                 if (year % 4 != 0) {
43                         return false;
44                 }
45                 if (year % 100 != 0) {
46                         return true;
47                 }
48                 if (year % 400 != 0) {
49                         return false;
50                 }
51                 return true;
52         }
53 
54         function leapYearsBefore(uint year) public pure returns (uint) {
55                 year -= 1;
56                 return year / 4 - year / 100 + year / 400;
57         }
58 
59         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
60                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
61                     return 31;
62                 } else if (month == 4 || month == 6 || month == 9 || month == 11) {
63                     return 30;
64                 } else if (isLeapYear(year)) {
65                     return 29;
66                 } else {
67                     return 28;
68                 }
69         }
70 
71         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
72                 uint secondsAccountedFor = 0;
73                 uint buf;
74                 uint8 i;
75 
76                 // Year
77                 dt.year = getYear(timestamp);
78                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
79 
80                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
81                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
82 
83                 // Month
84                 uint secondsInMonth;
85                 for (i = 1; i <= 12; i++) {
86                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
87                         if (secondsInMonth + secondsAccountedFor > timestamp) {
88                                 dt.month = i;
89                                 break;
90                         }
91                         secondsAccountedFor += secondsInMonth;
92                 }
93 
94                 // Day
95                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
96                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
97                                 dt.day = i;
98                                 break;
99                         }
100                         secondsAccountedFor += DAY_IN_SECONDS;
101                 }
102 
103                 // Hour
104                 dt.hour = getHour(timestamp);
105 
106                 // Minute
107                 dt.minute = getMinute(timestamp);
108 
109                 // Second
110                 dt.second = getSecond(timestamp);
111 
112                 // Day of week.
113                 dt.weekday = getWeekday(timestamp);
114         }
115 
116         function getYear(uint timestamp) public pure returns (uint16) {
117                 uint secondsAccountedFor = 0;
118                 uint16 year;
119                 uint numLeapYears;
120 
121                 // Year
122                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
123                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
124 
125                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
126                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
127 
128                 while (secondsAccountedFor > timestamp) {
129                         if (isLeapYear(uint16(year - 1))) {
130                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
131                         } else {
132                                 secondsAccountedFor -= YEAR_IN_SECONDS;
133                         }
134                         year -= 1;
135                 }
136                 return year;
137         }
138 
139         function getMonth(uint timestamp) public pure returns (uint8) {
140                 return parseTimestamp(timestamp).month;
141         }
142 
143         function getDay(uint timestamp) public pure returns (uint8) {
144                 return parseTimestamp(timestamp).day;
145         }
146 
147         function getHour(uint timestamp) public pure returns (uint8) {
148                 return uint8((timestamp / 60 / 60) % 24);
149         }
150 
151         function getMinute(uint timestamp) public pure returns (uint8) {
152                 return uint8((timestamp / 60) % 60);
153         }
154 
155         function getSecond(uint timestamp) public pure returns (uint8) {
156                 return uint8(timestamp % 60);
157         }
158 
159         function getWeekday(uint timestamp) public pure returns (uint8) {
160                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
161         }
162 
163         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
164                 return toTimestamp(year, month, day, 0, 0, 0);
165         }
166 
167         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
168                 return toTimestamp(year, month, day, hour, 0, 0);
169         }
170 
171         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
172                 return toTimestamp(year, month, day, hour, minute, 0);
173         }
174 
175         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
176                 uint16 i;
177 
178                 // Year
179                 for (i = ORIGIN_YEAR; i < year; i++) {
180                         if (isLeapYear(i)) {
181                             timestamp += LEAP_YEAR_IN_SECONDS;
182                         } else {
183                             timestamp += YEAR_IN_SECONDS;
184                         }
185                 }
186 
187                 // Month
188                 uint8[12] memory monthDayCounts;
189                 monthDayCounts[0] = 31;
190                 if (isLeapYear(year)) {
191                     monthDayCounts[1] = 29;
192                 } else {
193                     monthDayCounts[1] = 28;
194                 }
195                 monthDayCounts[2] = 31;
196                 monthDayCounts[3] = 30;
197                 monthDayCounts[4] = 31;
198                 monthDayCounts[5] = 30;
199                 monthDayCounts[6] = 31;
200                 monthDayCounts[7] = 31;
201                 monthDayCounts[8] = 30;
202                 monthDayCounts[9] = 31;
203                 monthDayCounts[10] = 30;
204                 monthDayCounts[11] = 31;
205 
206                 for (i = 1; i < month; i++) {
207                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
208                 }
209 
210                 // Day
211                 timestamp += DAY_IN_SECONDS * (day - 1);
212 
213                 // Hour
214                 timestamp += HOUR_IN_SECONDS * (hour);
215 
216                 // Minute
217                 timestamp += MINUTE_IN_SECONDS * (minute);
218 
219                 // Second
220                 timestamp += second;
221 
222                 return timestamp;
223         }
224 }
225 
226 
227 /**
228  * @title Ownable
229  * @dev The Ownable contract has an owner address, and provides basic authorization control
230  * functions, this simplifies the implementation of "user permissions".
231  */
232 contract Ownable {
233   address public owner;
234 
235 
236   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238 
239   /**
240    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
241    * account.
242    */
243   function Ownable() public {
244     owner = msg.sender;
245   }
246 
247 
248   /**
249    * @dev Throws if called by any account other than the owner.
250    */
251   modifier onlyOwner() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256 
257   /**
258    * @dev Allows the current owner to transfer control of the contract to a newOwner.
259    * @param newOwner The address to transfer ownership to.
260    */
261   function transferOwnership(address newOwner) public onlyOwner {
262     require(newOwner != address(0));
263     OwnershipTransferred(owner, newOwner);
264     owner = newOwner;
265   }
266 
267 }
268 
269 
270 
271 
272 /**
273  * @title Authorizable
274  * @dev Allows to authorize access to certain function calls
275  *
276  * ABI
277  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
278  */
279 contract Authorizable {
280 
281     address[] authorizers;
282     mapping(address => uint) authorizerIndex;
283 
284     /**
285      * @dev Throws if called by any account tat is not authorized.
286      */
287     modifier onlyAuthorized {
288         require(isAuthorized(msg.sender));
289         _;
290     }
291 
292     /**
293      * @dev Contructor that authorizes the msg.sender.
294      */
295     function Authorizable() public {
296         authorizers.length = 2;
297         authorizers[1] = msg.sender;
298         authorizerIndex[msg.sender] = 1;
299     }
300 
301     /**
302      * @dev Function to get a specific authorizer
303      * @param _authorizerIndex index of the authorizer to be retrieved.
304      * @return The address of the authorizer.
305      */
306     function getAuthorizer(uint _authorizerIndex) external view returns(address) {
307         return address(authorizers[_authorizerIndex + 1]);
308     }
309 
310     /**
311      * @dev Function to check if an address is authorized
312      * @param _addr the address to check if it is authorized.
313      * @return boolean flag if address is authorized.
314      */
315     function isAuthorized(address _addr) public view returns(bool) {
316         return authorizerIndex[_addr] > 0;
317     }
318 
319     /**
320      * @dev Function to add a new authorizer
321      * @param _addr the address to add as a new authorizer.
322      */
323     function addAuthorized(address _addr) external onlyAuthorized {
324         authorizerIndex[_addr] = authorizers.length;
325         authorizers.length++;
326         authorizers[authorizers.length - 1] = _addr;
327     }
328 
329 }
330 
331 
332 
333 /**
334  * @title SafeMath
335  * @dev Math operations with safety checks that throw on error
336  */
337 library SafeMath {
338   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339     if (a == 0) {
340       return 0;
341     }
342     uint256 c = a * b;
343     assert(c / a == b);
344     return c;
345   }
346 
347   function div(uint256 a, uint256 b) internal pure returns (uint256) {
348     // assert(b > 0); // Solidity automatically throws when dividing by 0
349     uint256 c = a / b;
350     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
351     return c;
352   }
353 
354   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
355     assert(b <= a);
356     return a - b;
357   }
358 
359   function add(uint256 a, uint256 b) internal pure returns (uint256) {
360     uint256 c = a + b;
361     assert(c >= a);
362     return c;
363   }
364 }
365 
366 
367 
368 
369 
370 
371 
372 
373 
374 
375 
376 
377 
378 
379 
380 /**
381  * @title Basic token
382  * @dev Basic version of StandardToken, with no allowances.
383  */
384 contract BasicToken is ERC20Basic {
385   using SafeMath for uint256;
386 
387   mapping(address => uint256) balances;
388 
389   /**
390   * @dev transfer token for a specified address
391   * @param _to The address to transfer to.
392   * @param _value The amount to be transferred.
393   */
394   function transfer(address _to, uint256 _value) public returns (bool) {
395     require(_to != address(0));
396     require(_value <= balances[msg.sender]);
397 
398     // SafeMath.sub will throw if there is not enough balance.
399     balances[msg.sender] = balances[msg.sender].sub(_value);
400     balances[_to] = balances[_to].add(_value);
401     Transfer(msg.sender, _to, _value);
402     return true;
403   }
404 
405   /**
406   * @dev Gets the balance of the specified address.
407   * @param _owner The address to query the the balance of.
408   * @return An uint256 representing the amount owned by the passed address.
409   */
410   function balanceOf(address _owner) public view returns (uint256 balance) {
411     return balances[_owner];
412   }
413 
414 }
415 
416 
417 
418 
419 
420 
421 
422 /**
423  * @title ERC20 interface
424  * @dev see https://github.com/ethereum/EIPs/issues/20
425  */
426 contract ERC20 is ERC20Basic {
427   function allowance(address owner, address spender) public view returns (uint256);
428   function transferFrom(address from, address to, uint256 value) public returns (bool);
429   function approve(address spender, uint256 value) public returns (bool);
430   event Approval(address indexed owner, address indexed spender, uint256 value);
431 }
432 
433 
434 
435 /**
436  * @title Standard ERC20 token
437  *
438  * @dev Implementation of the basic standard token.
439  * @dev https://github.com/ethereum/EIPs/issues/20
440  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
441  */
442 contract StandardToken is ERC20, BasicToken {
443 
444   mapping (address => mapping (address => uint256)) internal allowed;
445 
446 
447   /**
448    * @dev Transfer tokens from one address to another
449    * @param _from address The address which you want to send tokens from
450    * @param _to address The address which you want to transfer to
451    * @param _value uint256 the amount of tokens to be transferred
452    */
453   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
454     require(_to != address(0));
455     require(_value <= balances[_from]);
456     require(_value <= allowed[_from][msg.sender]);
457 
458     balances[_from] = balances[_from].sub(_value);
459     balances[_to] = balances[_to].add(_value);
460     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
461     Transfer(_from, _to, _value);
462     return true;
463   }
464 
465   /**
466    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
467    *
468    * Beware that changing an allowance with this method brings the risk that someone may use both the old
469    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
470    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
471    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
472    * @param _spender The address which will spend the funds.
473    * @param _value The amount of tokens to be spent.
474    */
475   function approve(address _spender, uint256 _value) public returns (bool) {
476     allowed[msg.sender][_spender] = _value;
477     Approval(msg.sender, _spender, _value);
478     return true;
479   }
480 
481   /**
482    * @dev Function to check the amount of tokens that an owner allowed to a spender.
483    * @param _owner address The address which owns the funds.
484    * @param _spender address The address which will spend the funds.
485    * @return A uint256 specifying the amount of tokens still available for the spender.
486    */
487   function allowance(address _owner, address _spender) public view returns (uint256) {
488     return allowed[_owner][_spender];
489   }
490 
491   /**
492    * approve should be called when allowed[_spender] == 0. To increment
493    * allowed value is better to use this function to avoid 2 calls (and wait until
494    * the first transaction is mined)
495    * From MonolithDAO Token.sol
496    */
497   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
498     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
499     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
500     return true;
501   }
502 
503   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
504     uint oldValue = allowed[msg.sender][_spender];
505     if (_subtractedValue > oldValue) {
506       allowed[msg.sender][_spender] = 0;
507     } else {
508       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
509     }
510     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
511     return true;
512   }
513 
514 }
515 
516 
517 
518 
519 
520 /**
521  * @title Mintable token
522  * @dev Simple ERC20 Token example, with mintable token creation
523  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
524  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
525  */
526 
527 contract MintableToken is StandardToken, Ownable {
528   event Mint(address indexed to, uint256 amount);
529   event MintFinished();
530 
531   bool public mintingFinished = false;
532 
533 
534   modifier canMint() {
535     require(!mintingFinished);
536     _;
537   }
538 
539   /**
540    * @dev Function to mint tokens
541    * @param _to The address that will receive the minted tokens.
542    * @param _amount The amount of tokens to mint.
543    * @return A boolean that indicates if the operation was successful.
544    */
545   function mint(address _to, uint256 _amount) public onlyOwner canMint  returns (bool) {
546     totalSupply = totalSupply.add(_amount);
547     balances[_to] = balances[_to].add(_amount);
548     Mint(_to, _amount);
549     Transfer(address(0), _to, _amount);
550     return true;
551   }
552 
553   /**
554    * @dev Function to stop minting new tokens.
555    * @return True if the operation was successful.
556    */
557   function finishMinting() public onlyOwner canMint  returns (bool) {
558     mintingFinished = true;
559     MintFinished();
560     return true;
561   }
562 }
563 
564 
565 /**
566  * @title PromotionCoin
567  * @dev The main PC token contract
568  */
569 contract PromotionCoin is MintableToken {
570 
571     string public name = "PromotionCoin";
572     string public symbol = "PC";
573     uint public decimals = 5;
574 
575     /**
576      * @dev Allows anyone to transfer 
577      * @param _to the recipient address of the tokens.
578      * @param _value number of tokens to be transfered.
579      */
580     function transfer(address _to, uint256 _value) public returns (bool) {
581         super.transfer(_to, _value);
582     }
583 
584     /**
585     * @dev Allows anyone to transfer 
586     * @param _from address The address which you want to send tokens from
587     * @param _to address The address which you want to transfer to
588     * @param _value uint the amout of tokens to be transfered
589     */
590     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
591         super.transferFrom(_from, _to, _value);
592     }
593 
594 }
595 
596 
597 /**
598  * @title PromotionCoinDistribution
599  * @dev The main PC token sale contract
600  *
601  * ABI
602  */
603 contract PromotionCoinDistribution is Ownable, Authorizable {
604     using SafeMath for uint;
605 
606     event AuthorizedCreateToPrivate(address recipient, uint pay_amount);
607     event Mined(address recipient, uint pay_amount);
608     event CreateTokenToTeam(address recipient, uint pay_amount);
609     event CreateTokenToMarket(address recipient, uint pay_amount);
610     event CreateTokenToOperation(address recipient, uint pay_amount);
611     event CreateTokenToTax(address recipient, uint pay_amount);
612     event PromotionCoinMintFinished();
613     
614     PromotionCoin public token = new PromotionCoin();
615     DateTime internal dateTime = new DateTime();
616     
617     uint public DICIMALS = 5;
618 
619     uint totalToken = 21000000000 * (10 ** DICIMALS); //210亿
620 
621     uint public privateTokenCap = 5000000000 * (10 ** DICIMALS); //私募发行50亿
622     uint public marketToken2018 = 0.50 * 1500000000 * (10 ** DICIMALS); //全球推广15亿，第一年 50%
623     uint public marketToken2019 = 0.25 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第二年 25%
624     uint public marketToken2020 = 0.15 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第三年 15%
625     uint public marketToken2021 = 0.10 * 1500000000 * (10 ** DICIMALS); //全球推广15亿, 第四年 10%
626     
627 
628     uint public operationToken = 2000000000 * (10 ** DICIMALS); //社区运营20亿
629     uint public minedTokenCap = 11000000000 * (10 ** DICIMALS); //挖矿110亿
630     uint public teamToken2018 = 500000000 * (10 ** DICIMALS); //团队预留10亿(10%),2018年发放5亿
631     uint public teamToken2019 = 500000000 * (10 ** DICIMALS); //团队预留10亿(10%),2019年发放5亿
632     uint public taxToken = 500000000 * (10 ** DICIMALS); //税务及法务年发放5亿
633 
634     uint public privateToken = 0; //私募已发行数量
635 
636     address public teamAddress;
637     address public operationAddress;
638     address public marketAddress;
639     address public taxAddress;
640 
641     bool public team2018TokenCreated = false;
642     bool public team2019TokenCreated = false;
643     bool public operationTokenCreated = false;
644     bool public market2018TokenCreated = false;
645     bool public market2019TokenCreated = false;
646     bool public market2020TokenCreated = false;
647     bool public market2021TokenCreated = false;
648     bool public taxTokenCreated = false;
649 
650     //year => token
651     mapping(uint16 => uint) public minedToken; //游戏挖矿已发行数量
652 
653     uint public firstYearMinedTokenCap = 5500000000 * (10 ** DICIMALS); //2018年55亿(110亿*0.5)，以后逐年减半 
654 
655     uint public minedTokenStartTime = 1514736000; //new Date("Jan 01 2018 00:00:00 GMT+8").getTime() / 1000;
656 
657     function isContract(address _addr) internal view returns(bool) {
658         uint size;
659         if (_addr == 0) 
660             return false;
661 
662         assembly {
663             size := extcodesize(_addr)
664         }
665         return size > 0;
666     }
667 
668     //2018年55亿(110亿*0.5)，以后逐年减半，到2028年发放剩余的全部
669     function getCurrentYearMinedTokenCap(uint _currentYear) public view returns(uint) {
670         require(_currentYear <= 2028);
671 
672         if (_currentYear < 2028) {
673             uint divTimes = 2 ** (_currentYear - 2018);
674             uint currentYearMinedTokenCap = firstYearMinedTokenCap.div(divTimes).div(10 ** DICIMALS).mul(10 ** DICIMALS);
675             return currentYearMinedTokenCap;
676         } else if (_currentYear == 2028) {
677             return 10742188 * (10 ** DICIMALS);
678         } else {
679             revert();
680         }
681     }
682 
683     function getCurrentYearRemainToken(uint16 _currentYear) public view returns(uint) {
684         uint currentYearMinedTokenCap = getCurrentYearMinedTokenCap(_currentYear);
685 
686          if (minedToken[_currentYear] == 0) {
687              return currentYearMinedTokenCap;
688          } else {
689              return currentYearMinedTokenCap.sub(minedToken[_currentYear]);
690          }
691     }
692 
693     function setTeamAddress(address _address) public onlyAuthorized {
694         teamAddress = _address;
695     }
696 
697     function setMarketAddress(address _address) public onlyAuthorized {
698         marketAddress = _address;
699     }
700 
701     function setOperationAddress(address _address) public onlyAuthorized {
702         operationAddress = _address;
703     }
704     
705     function setTaxAddress(address _address) public onlyAuthorized {
706         taxAddress = _address;
707     }
708 
709     function createTokenToMarket2018() public onlyAuthorized {
710         require(marketAddress != address(0));
711         require(market2018TokenCreated == false);
712 
713         market2018TokenCreated = true;
714         token.mint(marketAddress, marketToken2018);
715         CreateTokenToMarket(marketAddress, marketToken2018);
716     }
717 
718 
719     function createTokenToMarket2019() public onlyAuthorized {
720         require(marketAddress != address(0));
721         require(market2018TokenCreated == false);
722 
723         market2019TokenCreated = true;
724         token.mint(marketAddress, marketToken2019);
725         CreateTokenToMarket(marketAddress, marketToken2019);
726     }
727 
728     function createTokenToMarket2020() public onlyAuthorized {
729         require(marketAddress != address(0));
730         require(market2020TokenCreated == false);
731 
732         market2020TokenCreated = true;
733         token.mint(marketAddress, marketToken2020);
734         CreateTokenToMarket(marketAddress, marketToken2020);
735     }
736 
737     function createTokenToMarket2021() public onlyAuthorized {
738         require(marketAddress != address(0));
739         require(market2021TokenCreated == false);
740 
741         market2021TokenCreated = true;
742         token.mint(marketAddress, marketToken2021);
743         CreateTokenToMarket(marketAddress, marketToken2021);
744     }
745 
746 
747     function createTokenToOperation() public onlyAuthorized {
748         require(operationAddress != address(0));
749         require(operationTokenCreated == false);
750 
751         operationTokenCreated = true;
752         token.mint(operationAddress, operationToken);
753         CreateTokenToOperation(operationAddress, operationToken);
754     }
755 
756     function createTokenToTax() public onlyAuthorized {
757         require(taxAddress != address(0));
758         require(taxTokenCreated == false);
759 
760         taxTokenCreated = true;
761         token.mint(taxAddress, taxToken);
762         CreateTokenToOperation(taxAddress, taxToken);
763     }
764 
765 
766     function _createTokenToTeam(uint16 _currentYear) internal {
767         if (_currentYear == 2018) {
768             require(team2018TokenCreated == false);
769             team2018TokenCreated = true;
770             token.mint(teamAddress, teamToken2018);
771             CreateTokenToTeam(teamAddress, teamToken2018);
772         } else if (_currentYear == 2019) {
773             require(team2019TokenCreated == false);
774             team2019TokenCreated = true;
775             token.mint(teamAddress, teamToken2019);
776             CreateTokenToTeam(teamAddress, teamToken2019);
777         } else {
778             revert();
779         }
780     }
781 
782     function createTokenToTeam() public onlyAuthorized {
783         require(teamAddress != address(0));
784         uint16 currentYear = dateTime.getYear(now);
785         require(currentYear == 2018 || currentYear == 2019);
786         _createTokenToTeam(currentYear);
787     }
788 
789     function mined(address recipient, uint _tokens) public onlyAuthorized {
790         require(now > minedTokenStartTime);
791         uint16 currentYear = dateTime.getYear(now);
792         uint currentYearRemainTokens = getCurrentYearRemainToken(currentYear);
793         require(_tokens <= currentYearRemainTokens);
794 
795         minedToken[currentYear] += _tokens; 
796 
797         token.mint(recipient, _tokens);
798         Mined(recipient, _tokens); 
799     }
800 
801     function authorizedCreateTokensToPrivate(address recipient, uint _tokens) public onlyAuthorized {
802         require(privateToken + _tokens <= privateTokenCap);
803         privateToken += _tokens;
804         token.mint(recipient, _tokens);
805         AuthorizedCreateToPrivate(recipient, _tokens);
806     }
807 
808     function finishMinting() public onlyOwner {
809         token.finishMinting();
810         token.transferOwnership(owner);
811         PromotionCoinMintFinished();
812     }
813 
814     //不允许直接转账以太币购买
815     function () external {
816         revert();
817     }
818 }