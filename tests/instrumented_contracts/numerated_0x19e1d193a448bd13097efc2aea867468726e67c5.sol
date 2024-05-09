1 pragma solidity 0.6.0;
2 
3 /**
4  * @title Dividend logic
5  * @dev Some operations about dividend,logic and asset separation
6  */
7 contract Nest_3_TokenAbonus {
8     using address_make_payable for address;
9     using SafeMath for uint256;
10     
11     ERC20 _nestContract;
12     Nest_3_TokenSave _tokenSave;                                                                //  Lock-up contract
13     Nest_3_Abonus _abonusContract;                                                              //  ETH bonus pool
14     Nest_3_VoteFactory _voteFactory;                                                            //  Voting contract
15     Nest_3_Leveling _nestLeveling;                                                              //  Leveling contract
16     address _destructionAddress;                                                                //  Destroy contract address
17     
18     uint256 _timeLimit = 168 hours;                                                             //  Bonus period
19     uint256 _nextTime = 1596168000;                                                             //  Next bonus time
20     uint256 _getAbonusTimeLimit = 60 hours;                                                     //  During of triggering calculation of bonus
21     uint256 _times = 0;                                                                         //  Bonus ledger
22     uint256 _expectedIncrement = 3;                                                             //  Expected bonus increment ratio
23     uint256 _expectedSpanForNest = 100000000 ether;                                             //  NEST expected bonus increment threshold
24     uint256 _expectedSpanForNToken = 1000000 ether;                                             //  NToken expected bonus increment threshold
25     uint256 _expectedMinimum = 100 ether;                                                       //  Expected minimum bonus
26     uint256 _savingLevelOne = 10;                                                               //  Saving threshold level 1
27     uint256 _savingLevelTwo = 20;                                                               //  Saving threshold level 2 
28     uint256 _savingLevelTwoSub = 100 ether;                                                     //  Function parameters of savings threshold level 2  
29     uint256 _savingLevelThree = 30;                                                             //  Function parameters of savings threshold level 3
30     uint256 _savingLevelThreeSub = 600 ether;                                                   //  Function parameters of savings threshold level 3
31     
32     mapping(address => uint256) _abonusMapping;                                                 //  Bonus pool snapshot - token address (NEST or NToken) => number of ETH in the bonus pool 
33     mapping(address => uint256) _tokenAllValueMapping;                                          //  Number of tokens (circulation) - token address (NEST or NToken) ) => total circulation 
34     mapping(address => mapping(uint256 => uint256)) _tokenAllValueHistory;                      //  NEST or NToken circulation snapshot - token address (NEST or NToken) => number of periods => total circulation 
35     mapping(address => mapping(uint256 => mapping(address => uint256))) _tokenSelfHistory;      //  Personal lockup - NEST or NToken snapshot token address (NEST or NToken) => period => user address => total circulation
36     mapping(address => mapping(uint256 => bool)) _snapshot;                                     //  Whether snapshot - token address (NEST or NToken) => number of periods => whether to take a snapshot
37     mapping(uint256 => mapping(address => mapping(address => bool))) _getMapping;               //  Receiving records - period => token address (NEST or NToken) => user address => whether received
38     
39     //  Log token address, amount
40     event GetTokenLog(address tokenAddress, uint256 tokenAmount);
41     
42    /**
43     * @dev Initialization method
44     * @param voteFactory Voting contract address
45     */
46     constructor (address voteFactory) public {
47         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
48         _voteFactory = voteFactoryMap; 
49         _nestContract = ERC20(address(voteFactoryMap.checkAddress("nest")));
50         _tokenSave = Nest_3_TokenSave(address(voteFactoryMap.checkAddress("nest.v3.tokenSave")));
51         address payable addr = address(voteFactoryMap.checkAddress("nest.v3.abonus")).make_payable();
52         _abonusContract = Nest_3_Abonus(addr);
53         address payable levelingAddr = address(voteFactoryMap.checkAddress("nest.v3.leveling")).make_payable();
54         _nestLeveling = Nest_3_Leveling(levelingAddr);
55         _destructionAddress = address(voteFactoryMap.checkAddress("nest.v3.destruction"));
56     }
57     
58     /**
59     * @dev Modify voting contract
60     * @param voteFactory Voting contract address
61     */
62     function changeMapping(address voteFactory) public onlyOwner {
63         Nest_3_VoteFactory voteFactoryMap = Nest_3_VoteFactory(address(voteFactory));
64         _voteFactory = voteFactoryMap; 
65         _nestContract = ERC20(address(voteFactoryMap.checkAddress("nest")));
66         _tokenSave = Nest_3_TokenSave(address(voteFactoryMap.checkAddress("nest.v3.tokenSave")));
67         address payable addr = address(voteFactoryMap.checkAddress("nest.v3.abonus")).make_payable();
68         _abonusContract = Nest_3_Abonus(addr);
69         address payable levelingAddr = address(voteFactoryMap.checkAddress("nest.v3.leveling")).make_payable();
70         _nestLeveling = Nest_3_Leveling(levelingAddr);
71         _destructionAddress = address(voteFactoryMap.checkAddress("nest.v3.destruction"));
72     }
73     
74     /**
75     * @dev Deposit 
76     * @param amount Deposited amount
77     * @param token Locked token address
78     */
79     function depositIn(uint256 amount, address token) public {
80         uint256 nowTime = now;
81         uint256 nextTime = _nextTime;
82         uint256 timeLimit = _timeLimit;
83         if (nowTime < nextTime) {
84             //  Bonus triggered
85             require(!(nowTime >= nextTime.sub(timeLimit) && nowTime <= nextTime.sub(timeLimit).add(_getAbonusTimeLimit)));
86         } else {
87             //  Bonus not triggered
88             uint256 times = (nowTime.sub(_nextTime)).div(_timeLimit);
89             //  Calculate the time when bonus should be started
90             uint256 startTime = _nextTime.add((times).mul(_timeLimit));  
91             //  Calculate the time when bonus should be stopped
92             uint256 endTime = startTime.add(_getAbonusTimeLimit);                                                                    
93             require(!(nowTime >= startTime && nowTime <= endTime));
94         }
95         _tokenSave.depositIn(amount, token, address(msg.sender));                 
96     }
97     
98     /**
99     * @dev Withdrawing
100     * @param amount Withdrawing amount
101     * @param token Token address
102     */
103     function takeOut(uint256 amount, address token) public {
104         require(amount > 0, "Parameter needs to be greater than 0");                                                                
105         require(amount <= _tokenSave.checkAmount(address(msg.sender), token), "Insufficient storage balance");
106         if (token == address(_nestContract)) {
107             require(!_voteFactory.checkVoteNow(address(tx.origin)), "Voting");
108         }
109         _tokenSave.takeOut(amount, token, address(msg.sender));                                                             
110     }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
111     
112     /**
113     * @dev Receiving
114     * @param token Receiving token address
115     */
116     function getAbonus(address token) public {
117         uint256 tokenAmount = _tokenSave.checkAmount(address(msg.sender), token);
118         require(tokenAmount > 0, "Insufficient storage balance");
119         reloadTime();
120         reloadToken(token);                                                                                                      
121         uint256 nowTime = now;
122         require(nowTime >= _nextTime.sub(_timeLimit) && nowTime <= _nextTime.sub(_timeLimit).add(_getAbonusTimeLimit), "Not time to draw");
123         require(!_getMapping[_times.sub(1)][token][address(msg.sender)], "Have received");                                     
124         _tokenSelfHistory[token][_times.sub(1)][address(msg.sender)] = tokenAmount;                                         
125         require(_tokenAllValueMapping[token] > 0, "Total flux error");
126         uint256 selfNum = tokenAmount.mul(_abonusMapping[token]).div(_tokenAllValueMapping[token]);
127         require(selfNum > 0, "No limit available");
128         _getMapping[_times.sub(1)][token][address(msg.sender)] = true;
129         _abonusContract.getETH(selfNum, token,address(msg.sender)); 
130         emit GetTokenLog(token, selfNum);
131     }
132     
133     /**
134     * @dev Update bonus time and stage ledger
135     */
136     function reloadTime() private {
137         uint256 nowTime = now;
138         //  The current time must exceed the bonus time
139         if (nowTime >= _nextTime) {                                                                                                 
140             uint256 time = (nowTime.sub(_nextTime)).div(_timeLimit);
141             uint256 startTime = _nextTime.add((time).mul(_timeLimit));                                                              
142             uint256 endTime = startTime.add(_getAbonusTimeLimit);                                                                   
143             if (nowTime >= startTime && nowTime <= endTime) {
144                 _nextTime = getNextTime();                                                                                      
145                 _times = _times.add(1);                                                                                       
146             }
147         }
148     }
149     
150     /**
151     * @dev Snapshot of the amount of tokens
152     * @param token Receiving token address
153     */
154     function reloadToken(address token) private {
155         if (!_snapshot[token][_times.sub(1)]) {
156             levelingResult(token);                                                                                          
157             _abonusMapping[token] = _abonusContract.getETHNum(token); 
158             _tokenAllValueMapping[token] = allValue(token);
159             _tokenAllValueHistory[token][_times.sub(1)] = allValue(token);
160             _snapshot[token][_times.sub(1)] = true;
161         }
162     }
163     
164     /**
165     * @dev Leveling settlement
166     * @param token Receiving token address
167     */
168     function levelingResult(address token) private {
169         uint256 steps;
170         if (token == address(_nestContract)) {
171             steps = allValue(token).div(_expectedSpanForNest);
172         } else {
173             steps = allValue(token).div(_expectedSpanForNToken);
174         }
175         uint256 minimumAbonus = _expectedMinimum;
176         for (uint256 i = 0; i < steps; i++) {
177             minimumAbonus = minimumAbonus.add(minimumAbonus.mul(_expectedIncrement).div(100));
178         }
179         uint256 thisAbonus = _abonusContract.getETHNum(token);
180         if (thisAbonus > minimumAbonus) {
181             uint256 levelAmount = 0;
182             if (thisAbonus > 5000 ether) {
183                 levelAmount = thisAbonus.mul(_savingLevelThree).div(100).sub(_savingLevelThreeSub);
184             } else if (thisAbonus > 1000 ether) {
185                 levelAmount = thisAbonus.mul(_savingLevelTwo).div(100).sub(_savingLevelTwoSub);
186             } else {
187                 levelAmount = thisAbonus.mul(_savingLevelOne).div(100);
188             }
189             if (thisAbonus.sub(levelAmount) < minimumAbonus) {
190                 _abonusContract.getETH(thisAbonus.sub(minimumAbonus), token, address(this));
191                 _nestLeveling.switchToEth.value(thisAbonus.sub(minimumAbonus))(token);
192             } else {
193                 _abonusContract.getETH(levelAmount, token, address(this));
194                 _nestLeveling.switchToEth.value(levelAmount)(token);
195             }
196         } else {
197             uint256 ethValue = _nestLeveling.tranEth(minimumAbonus.sub(thisAbonus), token, address(this));
198             _abonusContract.switchToEth.value(ethValue)(token);
199         }
200     }
201     
202      // Next bonus time, current bonus deadline, ETH number, NEST number, NEST participating in bonus, bonus to receive, approved amount, balance, whether bonus can be paid 
203     function getInfo(address token) public view returns (uint256 nextTime, uint256 getAbonusTime, uint256 ethNum, uint256 tokenValue, uint256 myJoinToken, uint256 getEth, uint256 allowNum, uint256 leftNum, bool allowAbonus)  {
204         uint256 nowTime = now;
205         if (nowTime >= _nextTime.sub(_timeLimit) && nowTime <= _nextTime.sub(_timeLimit).add(_getAbonusTimeLimit) && _times > 0 && _snapshot[token][_times.sub(1)]) {
206             //  Bonus have been triggered, and during the time of this bonus, display snapshot data 
207             allowAbonus = _getMapping[_times.sub(1)][token][address(msg.sender)];
208             ethNum = _abonusMapping[token];
209             tokenValue = _tokenAllValueMapping[token];
210         } else {
211             //  Display real-time data 
212             ethNum = _abonusContract.getETHNum(token);
213             tokenValue = allValue(token);
214             allowAbonus = _getMapping[_times][token][address(msg.sender)];
215         }
216         myJoinToken = _tokenSave.checkAmount(address(msg.sender), token);
217         if (allowAbonus == true) {
218             getEth = 0; 
219         } else {
220             getEth = myJoinToken.mul(ethNum).div(tokenValue);
221         }
222         nextTime = getNextTime();
223         getAbonusTime = nextTime.sub(_timeLimit).add(_getAbonusTimeLimit);
224         allowNum = ERC20(token).allowance(address(msg.sender), address(_tokenSave));
225         leftNum = ERC20(token).balanceOf(address(msg.sender));
226     }
227     
228     /**
229     * @dev View next bonus time 
230     * @return Next bonus time 
231     */
232     function getNextTime() public view returns (uint256) {
233         uint256 nowTime = now;
234         if (_nextTime > nowTime) { 
235             return _nextTime; 
236         } else {
237             uint256 time = (nowTime.sub(_nextTime)).div(_timeLimit);
238             return _nextTime.add(_timeLimit.mul(time.add(1)));
239         }
240     }
241     
242     /**
243     * @dev View total circulation 
244     * @return Total circulation
245     */
246     function allValue(address token) public view returns (uint256) {
247         if (token == address(_nestContract)) {
248             uint256 all = 10000000000 ether;
249             uint256 leftNum = all.sub(_nestContract.balanceOf(address(_voteFactory.checkAddress("nest.v3.miningSave")))).sub(_nestContract.balanceOf(address(_destructionAddress)));
250             return leftNum;
251         } else {
252             return ERC20(token).totalSupply();
253         }
254     }
255     
256     /**
257     * @dev View bonus period
258     * @return Bonus period
259     */
260     function checkTimeLimit() public view returns (uint256) {
261         return _timeLimit;
262     }
263     
264     /**
265     * @dev View duration of triggering calculation of bonus
266     * @return Bonus period
267     */
268     function checkGetAbonusTimeLimit() public view returns (uint256) {
269         return _getAbonusTimeLimit;
270     }
271     
272     /**
273     * @dev View current lowest expected bonus
274     * @return Current lowest expected bonus
275     */
276     function checkMinimumAbonus(address token) public view returns (uint256) {
277         uint256 miningAmount;
278         if (token == address(_nestContract)) {
279             miningAmount = allValue(token).div(_expectedSpanForNest);
280         } else {
281             miningAmount = allValue(token).div(_expectedSpanForNToken);
282         }
283         uint256 minimumAbonus = _expectedMinimum;
284         for (uint256 i = 0; i < miningAmount; i++) {
285             minimumAbonus = minimumAbonus.add(minimumAbonus.mul(_expectedIncrement).div(100));
286         }
287         return minimumAbonus;
288     }
289     
290     /**
291     * @dev Check whether the bonus token is snapshoted
292     * @param token Token address
293     * @return Whether snapshoted
294     */
295     function checkSnapshot(address token) public view returns (bool) {
296         return _snapshot[token][_times.sub(1)];
297     }
298     
299     /**
300     * @dev Check the expected bonus incremental ratio
301     * @return Expected bonus increment ratio
302     */
303     function checkeExpectedIncrement() public view returns (uint256) {
304         return _expectedIncrement;
305     }
306     
307     /**
308     * @dev View expected minimum bonus
309     * @return Expected minimum bonus
310     */
311     function checkExpectedMinimum() public view returns (uint256) {
312         return _expectedMinimum;
313     }
314     
315     /**
316     * @dev View savings threshold
317     * @return Save threshold
318     */
319     function checkSavingLevelOne() public view returns (uint256) {
320         return _savingLevelOne;
321     }
322     function checkSavingLevelTwo() public view returns (uint256) {
323         return _savingLevelTwo;
324     }
325     function checkSavingLevelThree() public view returns (uint256) {
326         return _savingLevelThree;
327     }
328     
329     /**
330     * @dev View NEST liquidity snapshot
331     * @param token Locked token address
332     * @param times Bonus snapshot period
333     */
334     function checkTokenAllValueHistory(address token, uint256 times) public view returns (uint256) {
335         return _tokenAllValueHistory[token][times];
336     }
337     
338     /**
339     * @dev View personal lock-up NEST snapshot
340     * @param times Bonus snapshot period
341     * @param user User address
342     * @return The number of personal locked NEST snapshots
343     */
344     function checkTokenSelfHistory(address token, uint256 times, address user) public view returns (uint256) {
345         return _tokenSelfHistory[token][times][user];
346     }
347     
348     // View the period number of bonus
349     function checkTimes() public view returns (uint256) {
350         return _times;
351     }
352     
353     // NEST expected bonus increment threshold
354     function checkExpectedSpanForNest() public view returns (uint256) {
355         return _expectedSpanForNest;
356     }
357     
358     // NToken expected bonus increment threshold
359     function checkExpectedSpanForNToken() public view returns (uint256) {
360         return _expectedSpanForNToken;
361     }
362     
363     // View the function parameters of savings threshold level 3
364     function checkSavingLevelTwoSub() public view returns (uint256) {
365         return _savingLevelTwoSub;
366     }
367     
368     // View the function parameters of savings threshold level 3
369     function checkSavingLevelThreeSub() public view returns (uint256) {
370         return _savingLevelThreeSub;
371     }
372     
373     /**
374     * @dev Update bonus period
375     * @param hour Bonus period (hours)
376     */
377     function changeTimeLimit(uint256 hour) public onlyOwner {
378         require(hour > 0, "Parameter needs to be greater than 0");
379         _timeLimit = hour.mul(1 hours);
380     }
381     
382     /**
383     * @dev Update collection period
384     * @param hour Collection period (hours)
385     */
386     function changeGetAbonusTimeLimit(uint256 hour) public onlyOwner {
387         require(hour > 0, "Parameter needs to be greater than 0");
388         _getAbonusTimeLimit = hour;
389     }
390     
391     /**
392     * @dev Update expected bonus increment ratio
393     * @param num Expected bonus increment ratio
394     */
395     function changeExpectedIncrement(uint256 num) public onlyOwner {
396         require(num > 0, "Parameter needs to be greater than 0");
397         _expectedIncrement = num;
398     }
399     
400     /**
401     * @dev Update expected minimum bonus
402     * @param num Expected minimum bonus
403     */
404     function changeExpectedMinimum(uint256 num) public onlyOwner {
405         require(num > 0, "Parameter needs to be greater than 0");
406         _expectedMinimum = num;
407     }
408     
409     /**
410     * @dev  Update saving threshold
411     * @param threshold Saving threshold
412     */
413     function changeSavingLevelOne(uint256 threshold) public onlyOwner {
414         _savingLevelOne = threshold;
415     }
416     function changeSavingLevelTwo(uint256 threshold) public onlyOwner {
417         _savingLevelTwo = threshold;
418     }
419     function changeSavingLevelThree(uint256 threshold) public onlyOwner {
420         _savingLevelThree = threshold;
421     }
422     
423     /**
424     * @dev Update the function parameters of savings threshold level 2
425     */
426     function changeSavingLevelTwoSub(uint256 num) public onlyOwner {
427         _savingLevelTwoSub = num;
428     }
429     
430     /**
431     * @dev Update the function parameters of savings threshold level 3
432     */
433     function changeSavingLevelThreeSub(uint256 num) public onlyOwner {
434         _savingLevelThreeSub = num;
435     }
436     
437     /**
438     * @dev Update NEST expected bonus incremental threshold
439     * @param num Threshold
440     */
441     function changeExpectedSpanForNest(uint256 num) public onlyOwner {
442         _expectedSpanForNest = num;
443     }
444     
445     /**
446     * @dev Update NToken expected bonus incremental threshold
447     * @param num Threshold
448     */
449     function changeExpectedSpanForNToken(uint256 num) public onlyOwner {
450         _expectedSpanForNToken = num;
451     }
452     
453     receive() external payable {
454         
455     }
456     
457     // Administrator only
458     modifier onlyOwner(){
459         require(_voteFactory.checkOwners(address(msg.sender)), "No authority");
460         _;
461     }
462 }
463 
464 // NEST and NToken lock-up contracts
465 interface Nest_3_TokenSave {
466     function depositIn(uint256 num, address token, address target) external;
467     function checkAmount(address sender, address token) external view returns(uint256);
468     function takeOut(uint256 num, address token, address target) external;
469 }
470 
471 // ETH bonus pool
472 interface Nest_3_Abonus {
473     function getETH(uint256 num, address token, address target) external;
474     function getETHNum(address token) external view returns (uint256);
475     function switchToEth(address token) external payable;
476 }
477 
478 // Leveling contract
479 interface Nest_3_Leveling {
480     function tranEth(uint256 amount, address token, address target) external returns (uint256);
481     function switchToEth(address token) external payable;
482 }
483 
484 // Voting factory contract
485 interface Nest_3_VoteFactory {
486     // Check if there is a vote currently participating
487     function checkVoteNow(address user) external view returns(bool);
488     // Check address
489 	function checkAddress(string calldata name) external view returns (address contractAddress);
490 	// Check whether the administrator
491 	function checkOwners(address man) external view returns (bool);
492 }
493 
494 // ERC20 contract
495 interface ERC20 {
496     function totalSupply() external view returns (uint256);
497     function balanceOf(address account) external view returns (uint256);
498     function transfer(address recipient, uint256 amount) external returns (bool);
499     function allowance(address owner, address spender) external view returns (uint256);
500     function approve(address spender, uint256 amount) external returns (bool);
501     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
502     event Transfer(address indexed from, address indexed to, uint256 value);
503     event Approval(address indexed owner, address indexed spender, uint256 value);
504 }
505 
506 library SafeMath {
507     function add(uint256 a, uint256 b) internal pure returns (uint256) {
508         uint256 c = a + b;
509         require(c >= a, "SafeMath: addition overflow");
510 
511         return c;
512     }
513     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
514         return sub(a, b, "SafeMath: subtraction overflow");
515     }
516     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
517         require(b <= a, errorMessage);
518         uint256 c = a - b;
519 
520         return c;
521     }
522     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
523         if (a == 0) {
524             return 0;
525         }
526         uint256 c = a * b;
527         require(c / a == b, "SafeMath: multiplication overflow");
528 
529         return c;
530     }
531     function div(uint256 a, uint256 b) internal pure returns (uint256) {
532         return div(a, b, "SafeMath: division by zero");
533     }
534     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
535         require(b > 0, errorMessage);
536         uint256 c = a / b;
537         return c;
538     }
539     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
540         return mod(a, b, "SafeMath: modulo by zero");
541     }
542     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b != 0, errorMessage);
544         return a % b;
545     }
546 }
547 
548 library address_make_payable {
549    function make_payable(address x) internal pure returns (address payable) {
550       return address(uint160(x));
551    }
552 }