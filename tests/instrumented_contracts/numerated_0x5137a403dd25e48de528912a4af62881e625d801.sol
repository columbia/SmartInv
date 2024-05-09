1 pragma solidity 0.4.24;
2 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 // File: contracts/IHuddlToken.sol
38 
39 contract IHuddlToken is IERC20{
40 
41     function mint(address to, uint256 value)external returns (bool);
42     
43     function decimals() public view returns(uint8);
44 }
45 
46 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that revert on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, reverts on overflow.
56   */
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (a == 0) {
62       return 0;
63     }
64 
65     uint256 c = a * b;
66     require(c / a == b);
67 
68     return c;
69   }
70 
71   /**
72   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b > 0); // Solidity only automatically asserts when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     require(b <= a);
87     uint256 c = a - b;
88 
89     return c;
90   }
91 
92   /**
93   * @dev Adds two numbers, reverts on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     require(c >= a);
98 
99     return c;
100   }
101 
102   /**
103   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
104   * reverts when dividing by zero.
105   */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0);
108     return a % b;
109   }
110 }
111 
112 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
113 
114 /**
115  * @title Ownable
116  * @dev The Ownable contract has an owner address, and provides basic authorization control
117  * functions, this simplifies the implementation of "user permissions".
118  */
119 contract Ownable {
120   address private _owner;
121 
122   event OwnershipTransferred(
123     address indexed previousOwner,
124     address indexed newOwner
125   );
126 
127   /**
128    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
129    * account.
130    */
131   constructor() internal {
132     _owner = msg.sender;
133     emit OwnershipTransferred(address(0), _owner);
134   }
135 
136   /**
137    * @return the address of the owner.
138    */
139   function owner() public view returns(address) {
140     return _owner;
141   }
142 
143   /**
144    * @dev Throws if called by any account other than the owner.
145    */
146   modifier onlyOwner() {
147     require(isOwner());
148     _;
149   }
150 
151   /**
152    * @return true if `msg.sender` is the owner of the contract.
153    */
154   function isOwner() public view returns(bool) {
155     return msg.sender == _owner;
156   }
157 
158   /**
159    * @dev Allows the current owner to relinquish control of the contract.
160    * @notice Renouncing to ownership will leave the contract without an owner.
161    * It will not be possible to call the functions with the `onlyOwner`
162    * modifier anymore.
163    */
164   function renounceOwnership() public onlyOwner {
165     emit OwnershipTransferred(_owner, address(0));
166     _owner = address(0);
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     _transferOwnership(newOwner);
175   }
176 
177   /**
178    * @dev Transfers control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function _transferOwnership(address newOwner) internal {
182     require(newOwner != address(0));
183     emit OwnershipTransferred(_owner, newOwner);
184     _owner = newOwner;
185   }
186 }
187 
188 // File: contracts/HuddlDistribution.sol
189 
190 contract HuddlDistribution is Ownable {
191     
192     using SafeMath for uint256;
193 
194     IHuddlToken token;
195     
196     uint256 lastReleasedQuarter;
197 
198     address public usersPool;
199     address public contributorsPool;
200     address public reservePool;
201 
202     uint256 public inflationRate;
203     //4% == 400 (supports upto 2 decimal places) for 4.5% enter 450
204     uint16 public constant INFLATION_RATE_OF_CHANGE = 400;
205 
206     uint256 public contributorDistPercent;
207     uint256 public reserveDistPercent;
208 
209     uint16 public contributorROC;
210     uint16 public reserveROC;
211 
212     uint8 public lastQuarter;//last quarter for which tokens were released
213     
214     bool public launched;
215     
216     //1000,000,000 (considering 18 decimal places)
217     uint256 public constant MAX_SUPPLY = 1000000000000000000000000000;
218 
219     uint256[] public quarterSchedule;
220 
221     event DistributionLaunched();
222 
223     event TokensReleased(
224         uint256 indexed userShare, 
225         uint256 indexed reserveShare, 
226         uint256 indexed contributorShare
227     );
228 
229     event ReserveDistributionPercentChanged(uint256 indexed newPercent);
230 
231     event ContributorDistributionPercentChanged(uint256 indexed newPercent);
232 
233     event ReserveROCChanged(uint256 indexed newROC);
234 
235     event ContributorROCChanged(uint256 indexed newROC);
236 
237     modifier distributionLaunched() {
238         require(launched, "Distribution not launched");
239         _;
240     }
241 
242     modifier quarterRunning() {
243         require(
244             lastQuarter < 72 && now >= quarterSchedule[lastQuarter],
245             "Quarter not started"
246         );
247         _;
248     }
249 
250     constructor(
251         address huddlTokenAddress, 
252         address _usersPool, 
253         address _contributorsPool, 
254         address _reservePool
255     )
256         public 
257     {
258 
259         require(
260             huddlTokenAddress != address(0), 
261             "Please provide valid huddl token address"
262         );
263         require(
264             _usersPool != address(0), 
265             "Please provide valid user pool address"
266         );
267         require(
268             _contributorsPool != address(0), 
269             "Please provide valid contributors pool address"
270         );
271         require(
272             _reservePool != address(0), 
273             "Please provide valid reserve pool address"
274         );
275         
276         usersPool = _usersPool;
277         contributorsPool = _contributorsPool;
278         reservePool = _reservePool;
279 
280         //considering 18 decimal places (10 * (10**18) / 100) 10%
281         inflationRate = 100000000000000000;
282 
283         //considering 18 decimal places (33.333 * (10**18) /100)
284         contributorDistPercent = 333330000000000000; 
285         reserveDistPercent = 333330000000000000;
286         
287         //Supports upto 2 decimal places, for 1% enter 100, for 1.5% enter 150
288         contributorROC = 100;//1%
289         reserveROC = 100;//1%
290 
291         token = IHuddlToken(huddlTokenAddress);
292 
293         //Initialize 72 quarterly token release schedule for distribution. Hard-coding token release time for each quarter for precision as required
294         quarterSchedule.push(1554076800); // 04/01/2019 (MM/DD/YYYY)
295         quarterSchedule.push(1561939200); // 07/01/2019 (MM/DD/YYYY)
296         quarterSchedule.push(1569888000); // 10/01/2019 (MM/DD/YYYY)
297         quarterSchedule.push(1577836800); // 01/01/2020 (MM/DD/YYYY)
298         quarterSchedule.push(1585699200); // 04/01/2020 (MM/DD/YYYY)
299         quarterSchedule.push(1593561600); // 07/01/2020 (MM/DD/YYYY)
300         quarterSchedule.push(1601510400); // 10/01/2020 (MM/DD/YYYY)
301         quarterSchedule.push(1609459200); // 01/01/2021 (MM/DD/YYYY)
302         quarterSchedule.push(1617235200); // 04/01/2021 (MM/DD/YYYY)
303         quarterSchedule.push(1625097600); // 07/01/2021 (MM/DD/YYYY)
304         quarterSchedule.push(1633046400); // 10/01/2021 (MM/DD/YYYY)
305         quarterSchedule.push(1640995200); // 01/01/2022 (MM/DD/YYYY)
306         quarterSchedule.push(1648771200); // 04/01/2022 (MM/DD/YYYY)
307         quarterSchedule.push(1656633600); // 07/01/2022 (MM/DD/YYYY)
308         quarterSchedule.push(1664582400); // 10/01/2022 (MM/DD/YYYY)
309         quarterSchedule.push(1672531200); // 01/01/2023 (MM/DD/YYYY)
310         quarterSchedule.push(1680307200); // 04/01/2023 (MM/DD/YYYY)
311         quarterSchedule.push(1688169600); // 07/01/2023 (MM/DD/YYYY)
312         quarterSchedule.push(1696118400); // 10/01/2023 (MM/DD/YYYY)
313         quarterSchedule.push(1704067200); // 01/01/2024 (MM/DD/YYYY)
314         quarterSchedule.push(1711929600); // 04/01/2024 (MM/DD/YYYY)
315         quarterSchedule.push(1719792000); // 07/01/2024 (MM/DD/YYYY)
316         quarterSchedule.push(1727740800); // 10/01/2024 (MM/DD/YYYY)
317         quarterSchedule.push(1735689600); // 01/01/2025 (MM/DD/YYYY)
318         quarterSchedule.push(1743465600); // 04/01/2025 (MM/DD/YYYY)
319         quarterSchedule.push(1751328000); // 07/01/2025 (MM/DD/YYYY)
320         quarterSchedule.push(1759276800); // 10/01/2025 (MM/DD/YYYY)
321         quarterSchedule.push(1767225600); // 01/01/2026 (MM/DD/YYYY)
322         quarterSchedule.push(1775001600); // 04/01/2026 (MM/DD/YYYY)
323         quarterSchedule.push(1782864000); // 07/01/2026 (MM/DD/YYYY)
324         quarterSchedule.push(1790812800); // 10/01/2026 (MM/DD/YYYY)
325         quarterSchedule.push(1798761600); // 01/01/2027 (MM/DD/YYYY)
326         quarterSchedule.push(1806537600); // 04/01/2027 (MM/DD/YYYY)
327         quarterSchedule.push(1814400000); // 07/01/2027 (MM/DD/YYYY)
328         quarterSchedule.push(1822348800); // 10/01/2027 (MM/DD/YYYY)
329         quarterSchedule.push(1830297600); // 01/01/2028 (MM/DD/YYYY)
330         quarterSchedule.push(1838160000); // 04/01/2028 (MM/DD/YYYY)
331         quarterSchedule.push(1846022400); // 07/01/2028 (MM/DD/YYYY)
332         quarterSchedule.push(1853971200); // 10/01/2028 (MM/DD/YYYY)
333         quarterSchedule.push(1861920000); // 01/01/2029 (MM/DD/YYYY)
334         quarterSchedule.push(1869696000); // 04/01/2029 (MM/DD/YYYY)
335         quarterSchedule.push(1877558400); // 07/01/2029 (MM/DD/YYYY)
336         quarterSchedule.push(1885507200); // 10/01/2029 (MM/DD/YYYY)
337         quarterSchedule.push(1893456000); // 01/01/2030 (MM/DD/YYYY)
338         quarterSchedule.push(1901232000); // 04/01/2030 (MM/DD/YYYY)
339         quarterSchedule.push(1909094400); // 07/01/2030 (MM/DD/YYYY)
340         quarterSchedule.push(1917043200); // 10/01/2030 (MM/DD/YYYY)
341         quarterSchedule.push(1924992000); // 01/01/2031 (MM/DD/YYYY)
342         quarterSchedule.push(1932768000); // 04/01/2031 (MM/DD/YYYY)
343         quarterSchedule.push(1940630400); // 07/01/2031 (MM/DD/YYYY)
344         quarterSchedule.push(1948579200); // 10/01/2031 (MM/DD/YYYY)
345         quarterSchedule.push(1956528000); // 01/01/2032 (MM/DD/YYYY)
346         quarterSchedule.push(1964390400); // 04/01/2032 (MM/DD/YYYY)
347         quarterSchedule.push(1972252800); // 07/01/2032 (MM/DD/YYYY)
348         quarterSchedule.push(1980201600); // 10/01/2032 (MM/DD/YYYY)
349         quarterSchedule.push(1988150400); // 01/01/2033 (MM/DD/YYYY)
350         quarterSchedule.push(1995926400); // 04/01/2033 (MM/DD/YYYY)
351         quarterSchedule.push(2003788800); // 07/01/2033 (MM/DD/YYYY)
352         quarterSchedule.push(2011737600); // 10/01/2033 (MM/DD/YYYY)
353         quarterSchedule.push(2019686400); // 01/01/2034 (MM/DD/YYYY)
354         quarterSchedule.push(2027462400); // 04/01/2034 (MM/DD/YYYY)
355         quarterSchedule.push(2035324800); // 07/01/2034 (MM/DD/YYYY)
356         quarterSchedule.push(2043273600); // 10/01/2034 (MM/DD/YYYY)
357         quarterSchedule.push(2051222400); // 01/01/2035 (MM/DD/YYYY)
358         quarterSchedule.push(2058998400); // 04/01/2035 (MM/DD/YYYY)
359         quarterSchedule.push(2066860800); // 07/01/2035 (MM/DD/YYYY)
360         quarterSchedule.push(2074809600); // 10/01/2035 (MM/DD/YYYY)
361         quarterSchedule.push(2082758400); // 01/01/2036 (MM/DD/YYYY)
362         quarterSchedule.push(2090620800); // 04/01/2036 (MM/DD/YYYY)
363         quarterSchedule.push(2098483200); // 07/01/2036 (MM/DD/YYYY)
364         quarterSchedule.push(2106432000); // 10/01/2036 (MM/DD/YYYY)
365         quarterSchedule.push(2114380800); // 01/01/2037 (MM/DD/YYYY)
366 
367     }
368 
369     /** 
370     * @dev When the distribution will start the initial set of tokens will be distributed amongst users, reserve and contributors as per specs
371     * Before calling this method the owner must transfer all the initial supply tokens to this distribution contract
372     */
373     function launchDistribution() external onlyOwner {
374 
375         require(!launched, "Distribution already launched");
376 
377         launched = true;
378 
379         (
380             uint256 userShare, 
381             uint256 reserveShare, 
382             uint256 contributorShare
383         ) = getDistributionShares(token.totalSupply());
384 
385         token.transfer(usersPool, userShare);
386         token.transfer(contributorsPool, contributorShare);
387         token.transfer(reservePool, reserveShare);
388         adjustDistributionPercentage();
389         emit DistributionLaunched();
390     } 
391 
392     /** 
393     * @dev This method allows owner of the contract to release tokens for the quarter.
394     * So suppose current quarter is 5 and previously released quarter is 3 then owner will have to send 2 transaction to release all tokens upto this quarter.
395     * First transaction will release tokens for quarter 4 and Second transaction will release tokens for quarter 5. This is done to reduce complexity.
396     */
397     function releaseTokens()
398         external 
399         onlyOwner 
400         distributionLaunched
401         quarterRunning//1. Check if quarter date has been reached
402         returns(bool)
403     {   
404         
405         //2. Increment quarter. Overflow will never happen as maximum quarters can be 72
406         lastQuarter = lastQuarter + 1;
407 
408         //3. Calculate amount of tokens to be released
409         uint256 amount = getTokensToMint();
410 
411         //4. Check if amount is greater than 0
412         require(amount>0, "No tokens to be released");
413 
414         //5. Calculate share of user, reserve and contributor
415         (
416             uint256 userShare, 
417             uint256 reserveShare, 
418             uint256 contributorShare
419         ) = getDistributionShares(amount);
420 
421         //6. Change inflation rate, for next release/quarter
422         adjustInflationRate();
423 
424         //7. Change distribution percentage for next quarter
425         adjustDistributionPercentage();
426 
427         //8. Mint and transfer tokens to respective pools
428         token.mint(usersPool, userShare);
429         token.mint(contributorsPool, contributorShare);
430         token.mint(reservePool, reserveShare);
431 
432         //9. Emit event
433         emit TokensReleased(
434             userShare, 
435             reserveShare, 
436             contributorShare
437         );
438     }
439    
440     /** 
441     * @dev This method will return the release time for upcoming quarter
442     */
443     function nextReleaseTime() external view returns(uint256 time) {
444         time = quarterSchedule[lastQuarter];
445     }
446 
447     /** 
448     * @dev This method will returns whether the next quarter's token can be released now or not
449     */
450     function canRelease() external view returns(bool release) {
451         release = now >= quarterSchedule[lastQuarter];
452     }
453 
454     /** 
455     * @dev Returns current distribution percentage for user pool
456     */
457     function userDistributionPercent() external view returns(uint256) {
458         uint256 totalPercent = 1000000000000000000;
459         return(
460             totalPercent.sub(contributorDistPercent.add(reserveDistPercent))
461         );
462     }
463 
464     /** 
465     * @dev Allows owner to change reserve distribution percentage for next quarter
466     * Consequent calculations will be done on this basis
467     * @param newPercent New percentage. Ex for 45.33% pass (45.33 * (10**18) /100) = 453330000000000000
468     */
469     function changeReserveDistributionPercent(
470         uint256 newPercent
471     )
472         external 
473         onlyOwner
474     {
475         reserveDistPercent = newPercent;
476         emit ReserveDistributionPercentChanged(newPercent);
477     }
478 
479     /** 
480     * @dev Allows owner to change contributor distribution percentage for next quarter
481     * Consequent calculations will be done on this basis
482     * @param newPercent New percentage. Ex for 45.33% pass (45.33 * (10**18) /100) = 453330000000000000
483     */
484     function changeContributorDistributionPercent(
485         uint256 newPercent
486     )
487         external 
488         onlyOwner
489     {
490         contributorDistPercent = newPercent;
491         emit ContributorDistributionPercentChanged(newPercent);
492     }
493 
494     /** 
495     * @dev Allows owner to change ROC for reserve pool
496     * @dev newROC New ROC. Ex- for 1% enter 100, for 1.5% enter 150
497     */
498     function changeReserveROC(uint16 newROC) external onlyOwner {
499         reserveROC = newROC;
500         emit ReserveROCChanged(newROC);
501     }
502 
503     /** 
504     * @dev Allows owner to change ROC for contributor pool
505     * @dev newROC New ROC. Ex- for 1% enter 100, for 1.5% enter 150
506     */
507     function changeContributorROC(uint16 newROC) external onlyOwner {
508         contributorROC = newROC;
509         emit ContributorROCChanged(newROC);
510     }
511 
512     /** 
513     * @dev This method returns the share of user, reserve and contributors for given token amount as per current distribution
514     * @param amount The amount of tokens for which the shares have to be calculated
515     */
516     function getDistributionShares(
517         uint256 amount
518     )
519         public 
520         view 
521         returns(
522             uint256 userShare, 
523             uint256 reserveShare, 
524             uint256 contributorShare
525         )
526     {
527         contributorShare = contributorDistPercent.mul(
528             amount.div(10**uint256(token.decimals()))
529         );
530 
531         reserveShare = reserveDistPercent.mul(
532             amount.div(10**uint256(token.decimals()))
533         );
534 
535         userShare = amount.sub(
536             contributorShare.add(reserveShare)
537         );
538 
539         assert(
540             contributorShare.add(reserveShare).add(userShare) == amount
541         );
542     }
543 
544     
545     /** 
546     * @dev Returns amount of tokens to be minted in next release(quarter)
547     */    
548     function getTokensToMint() public view returns(uint256 amount) {
549         
550         if (MAX_SUPPLY == token.totalSupply()){
551             return 0;
552         }
553 
554         //dividing by decimal places(18) since that is already multiplied in inflation rate
555         amount = token.totalSupply().div(
556             10 ** uint256(token.decimals())
557         ).mul(inflationRate);
558 
559         if (amount.add(token.totalSupply()) > MAX_SUPPLY){
560             amount = MAX_SUPPLY.sub(token.totalSupply());
561         }
562     }
563 
564     function adjustDistributionPercentage() private {
565         contributorDistPercent = contributorDistPercent.sub(
566             contributorDistPercent.mul(contributorROC).div(10000)
567         );
568 
569         reserveDistPercent = reserveDistPercent.sub(
570             reserveDistPercent.mul(reserveROC).div(10000)
571         );
572     }
573 
574     function adjustInflationRate() private {
575         inflationRate = inflationRate.sub(
576             inflationRate.mul(INFLATION_RATE_OF_CHANGE).div(10000)
577         );
578     }
579 
580     
581 }
582 
583 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
584 
585 /**
586  * @title Standard ERC20 token
587  *
588  * @dev Implementation of the basic standard token.
589  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
590  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
591  */
592 contract ERC20 is IERC20 {
593   using SafeMath for uint256;
594 
595   mapping (address => uint256) private _balances;
596 
597   mapping (address => mapping (address => uint256)) private _allowed;
598 
599   uint256 private _totalSupply;
600 
601   /**
602   * @dev Total number of tokens in existence
603   */
604   function totalSupply() public view returns (uint256) {
605     return _totalSupply;
606   }
607 
608   /**
609   * @dev Gets the balance of the specified address.
610   * @param owner The address to query the balance of.
611   * @return An uint256 representing the amount owned by the passed address.
612   */
613   function balanceOf(address owner) public view returns (uint256) {
614     return _balances[owner];
615   }
616 
617   /**
618    * @dev Function to check the amount of tokens that an owner allowed to a spender.
619    * @param owner address The address which owns the funds.
620    * @param spender address The address which will spend the funds.
621    * @return A uint256 specifying the amount of tokens still available for the spender.
622    */
623   function allowance(
624     address owner,
625     address spender
626    )
627     public
628     view
629     returns (uint256)
630   {
631     return _allowed[owner][spender];
632   }
633 
634   /**
635   * @dev Transfer token for a specified address
636   * @param to The address to transfer to.
637   * @param value The amount to be transferred.
638   */
639   function transfer(address to, uint256 value) public returns (bool) {
640     _transfer(msg.sender, to, value);
641     return true;
642   }
643 
644   /**
645    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
646    * Beware that changing an allowance with this method brings the risk that someone may use both the old
647    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
648    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
649    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
650    * @param spender The address which will spend the funds.
651    * @param value The amount of tokens to be spent.
652    */
653   function approve(address spender, uint256 value) public returns (bool) {
654     require(spender != address(0));
655 
656     _allowed[msg.sender][spender] = value;
657     emit Approval(msg.sender, spender, value);
658     return true;
659   }
660 
661   /**
662    * @dev Transfer tokens from one address to another
663    * @param from address The address which you want to send tokens from
664    * @param to address The address which you want to transfer to
665    * @param value uint256 the amount of tokens to be transferred
666    */
667   function transferFrom(
668     address from,
669     address to,
670     uint256 value
671   )
672     public
673     returns (bool)
674   {
675     require(value <= _allowed[from][msg.sender]);
676 
677     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
678     _transfer(from, to, value);
679     return true;
680   }
681 
682   /**
683    * @dev Increase the amount of tokens that an owner allowed to a spender.
684    * approve should be called when allowed_[_spender] == 0. To increment
685    * allowed value is better to use this function to avoid 2 calls (and wait until
686    * the first transaction is mined)
687    * From MonolithDAO Token.sol
688    * @param spender The address which will spend the funds.
689    * @param addedValue The amount of tokens to increase the allowance by.
690    */
691   function increaseAllowance(
692     address spender,
693     uint256 addedValue
694   )
695     public
696     returns (bool)
697   {
698     require(spender != address(0));
699 
700     _allowed[msg.sender][spender] = (
701       _allowed[msg.sender][spender].add(addedValue));
702     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
703     return true;
704   }
705 
706   /**
707    * @dev Decrease the amount of tokens that an owner allowed to a spender.
708    * approve should be called when allowed_[_spender] == 0. To decrement
709    * allowed value is better to use this function to avoid 2 calls (and wait until
710    * the first transaction is mined)
711    * From MonolithDAO Token.sol
712    * @param spender The address which will spend the funds.
713    * @param subtractedValue The amount of tokens to decrease the allowance by.
714    */
715   function decreaseAllowance(
716     address spender,
717     uint256 subtractedValue
718   )
719     public
720     returns (bool)
721   {
722     require(spender != address(0));
723 
724     _allowed[msg.sender][spender] = (
725       _allowed[msg.sender][spender].sub(subtractedValue));
726     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
727     return true;
728   }
729 
730   /**
731   * @dev Transfer token for a specified addresses
732   * @param from The address to transfer from.
733   * @param to The address to transfer to.
734   * @param value The amount to be transferred.
735   */
736   function _transfer(address from, address to, uint256 value) internal {
737     require(value <= _balances[from]);
738     require(to != address(0));
739 
740     _balances[from] = _balances[from].sub(value);
741     _balances[to] = _balances[to].add(value);
742     emit Transfer(from, to, value);
743   }
744 
745   /**
746    * @dev Internal function that mints an amount of the token and assigns it to
747    * an account. This encapsulates the modification of balances such that the
748    * proper events are emitted.
749    * @param account The account that will receive the created tokens.
750    * @param value The amount that will be created.
751    */
752   function _mint(address account, uint256 value) internal {
753     require(account != 0);
754     _totalSupply = _totalSupply.add(value);
755     _balances[account] = _balances[account].add(value);
756     emit Transfer(address(0), account, value);
757   }
758 
759   /**
760    * @dev Internal function that burns an amount of the token of a given
761    * account.
762    * @param account The account whose tokens will be burnt.
763    * @param value The amount that will be burnt.
764    */
765   function _burn(address account, uint256 value) internal {
766     require(account != 0);
767     require(value <= _balances[account]);
768 
769     _totalSupply = _totalSupply.sub(value);
770     _balances[account] = _balances[account].sub(value);
771     emit Transfer(account, address(0), value);
772   }
773 
774   /**
775    * @dev Internal function that burns an amount of the token of a given
776    * account, deducting from the sender's allowance for said account. Uses the
777    * internal burn function.
778    * @param account The account whose tokens will be burnt.
779    * @param value The amount that will be burnt.
780    */
781   function _burnFrom(address account, uint256 value) internal {
782     require(value <= _allowed[account][msg.sender]);
783 
784     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
785     // this function needs to emit an event with the updated approval.
786     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
787       value);
788     _burn(account, value);
789   }
790 }
791 
792 // File: openzeppelin-solidity/contracts/access/Roles.sol
793 
794 /**
795  * @title Roles
796  * @dev Library for managing addresses assigned to a Role.
797  */
798 library Roles {
799   struct Role {
800     mapping (address => bool) bearer;
801   }
802 
803   /**
804    * @dev give an account access to this role
805    */
806   function add(Role storage role, address account) internal {
807     require(account != address(0));
808     require(!has(role, account));
809 
810     role.bearer[account] = true;
811   }
812 
813   /**
814    * @dev remove an account's access to this role
815    */
816   function remove(Role storage role, address account) internal {
817     require(account != address(0));
818     require(has(role, account));
819 
820     role.bearer[account] = false;
821   }
822 
823   /**
824    * @dev check if an account has this role
825    * @return bool
826    */
827   function has(Role storage role, address account)
828     internal
829     view
830     returns (bool)
831   {
832     require(account != address(0));
833     return role.bearer[account];
834   }
835 }
836 
837 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
838 
839 contract MinterRole {
840   using Roles for Roles.Role;
841 
842   event MinterAdded(address indexed account);
843   event MinterRemoved(address indexed account);
844 
845   Roles.Role private minters;
846 
847   constructor() internal {
848     _addMinter(msg.sender);
849   }
850 
851   modifier onlyMinter() {
852     require(isMinter(msg.sender));
853     _;
854   }
855 
856   function isMinter(address account) public view returns (bool) {
857     return minters.has(account);
858   }
859 
860   function addMinter(address account) public onlyMinter {
861     _addMinter(account);
862   }
863 
864   function renounceMinter() public {
865     _removeMinter(msg.sender);
866   }
867 
868   function _addMinter(address account) internal {
869     minters.add(account);
870     emit MinterAdded(account);
871   }
872 
873   function _removeMinter(address account) internal {
874     minters.remove(account);
875     emit MinterRemoved(account);
876   }
877 }
878 
879 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
880 
881 /**
882  * @title ERC20Mintable
883  * @dev ERC20 minting logic
884  */
885 contract ERC20Mintable is ERC20, MinterRole {
886   /**
887    * @dev Function to mint tokens
888    * @param to The address that will receive the minted tokens.
889    * @param value The amount of tokens to mint.
890    * @return A boolean that indicates if the operation was successful.
891    */
892   function mint(
893     address to,
894     uint256 value
895   )
896     public
897     onlyMinter
898     returns (bool)
899   {
900     _mint(to, value);
901     return true;
902   }
903 }
904 
905 // File: contracts/HuddlToken.sol
906 
907 /** 
908 * @dev Mintable Huddl Token
909 * Initially deployer of the contract is only valid minter. Later on when distribution contract is deployed following steps needs to be followed-:
910 * 1. Make distribution contract a valid minter
911 * 2. Renounce miniter role for the token deployer address
912 * 3. Transfer initial supply tokens to distribution contract address
913 * 4. At launch of distribution contract transfer tokens to users, contributors and reserve as per monetary policy
914 */
915 contract HuddlToken is ERC20Mintable{
916 
917     using SafeMath for uint256;
918 
919     string private _name;
920     string private _symbol ;
921     uint8 private _decimals;
922 
923     constructor(
924         string name, 
925         string symbol, 
926         uint8 decimals, 
927         uint256 totalSupply
928     )
929         public 
930     {
931     
932         _name = name;
933         _symbol = symbol;
934         _decimals = decimals;
935         
936         //The initial supply of tokens will be given to the deployer. Deployer will later transfer it to distribution contract
937         //At launch distribution contract will give those tokens as per policy to the users, contributors and reserve
938         _mint(msg.sender, totalSupply.mul(10 ** uint256(decimals)));
939     }
940 
941     
942     /**
943     * @return the name of the token.
944     */
945     function name() public view returns(string) {
946         return _name;
947     }
948 
949     /**
950     * @return the symbol of the token.
951     */
952     function symbol() public view returns(string) {
953         return _symbol;
954     }
955 
956     /**
957     * @return the number of decimals of the token.
958     */
959     function decimals() public view returns(uint8) {
960         return _decimals;
961     }
962 
963 }
964 
965 // File: contracts/Migrations.sol
966 
967 contract Migrations {
968     address public owner;
969     uint public last_completed_migration;
970 
971     constructor() public {
972         owner = msg.sender;
973     }
974 
975     modifier restricted() {
976         if (msg.sender == owner) 
977             _;
978     }
979 
980     function setCompleted(uint completed) public restricted {
981         last_completed_migration = completed;
982     }
983 
984     function upgrade(address new_address) public restricted {
985         Migrations upgraded = Migrations(new_address);
986         upgraded.setCompleted(last_completed_migration);
987     }
988 }