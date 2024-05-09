1 pragma solidity ^0.5.2;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error
9  */
10 library SafeMath {
11     /**
12      * @dev Multiplies two unsigned integers, reverts on overflow.
13      */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
30      */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0);
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Adds two unsigned integers, reverts on overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62      * reverts when dividing by zero.
63      */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 pragma solidity ^0.5.2;
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84      * account.
85      */
86     constructor () internal {
87         _owner = msg.sender;
88         emit OwnershipTransferred(address(0), _owner);
89     }
90 
91     /**
92      * @return the address of the owner.
93      */
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(isOwner());
103         _;
104     }
105 
106     /**
107      * @return true if `msg.sender` is the owner of the contract.
108      */
109     function isOwner() public view returns (bool) {
110         return msg.sender == _owner;
111     }
112 
113     /**
114      * @dev Allows the current owner to relinquish control of the contract.
115      * @notice Renouncing to ownership will leave the contract without an owner.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 contract EtherStake is Ownable {
144  /**
145  * EtherStake
146  * www.etherstake.me
147  * Copyright 2019
148  * admin@etherpornstars.com
149  */
150     
151   using SafeMath for uint;
152   // Address set to win pot when time runs out
153   address payable public  leadAddress;
154     // Manage your dividends without MetaMask! Send 0.01 ETH to these directly
155   address public reinvestmentContractAddress;
156   address public withdrawalContractAddress;
157   // Multiplies your stake purchases, starts at 110% and goes down 0.1% a day down to 100% - get in early!
158   uint public stakeMultiplier;
159   uint public totalStake;
160   uint public day;
161   uint public roundId;
162   uint public roundEndTime;
163   uint public startOfNewDay;
164   uint public timeInADay;
165   uint public timeInAWeek;
166   // Optional message shown on the site when your address is leading
167   mapping(address => string) public playerMessage;
168   mapping(address => string) public playerName;
169   // Boundaries for messages
170   uint8 constant playerMessageMinLength = 1;
171   uint8 constant playerMessageMaxLength = 64;
172   mapping (uint => uint) internal seed; //save seed from rounds
173   mapping (uint => uint) internal roundIdToDays;
174   mapping (address => uint) public spentDivs;
175   // Main data structure that tracks all players dividends for current and previous rounds
176   mapping(uint => mapping(uint => divKeeper)) public playerDivsInADay;
177   // Emitted when user withdraws dividends or wins jackpot
178   event CashedOut(address _player, uint _amount);
179   event InvestReceipt(
180     address _player,
181     uint _stakeBought);
182     
183     struct divKeeper {
184       mapping(address => uint) playerStakeAtDay;
185       uint totalStakeAtDay;
186       uint revenueAtDay;
187   } 
188 
189     constructor() public {
190         roundId = 1;
191         timeInADay = 86400; // 86400 seconds in a day
192         timeInAWeek = 604800; // 604800 seconds in a week
193         roundEndTime = now + timeInAWeek; // round 1 end time 604800 seconds=7 days
194         startOfNewDay = now + timeInADay;
195         stakeMultiplier = 1100;
196         totalStake = 1000000000; 
197     }
198 
199 
200 
201     function() external payable {
202         require(msg.value >= 10000000000000000 && msg.value < 1000000000000000000000, "0.01 ETH minimum."); // Minimum stake buy is 0.01 ETH, max 1000
203 
204         if(now > roundEndTime){ // Check if round is over, then start new round. 
205             startNewRound();
206         }
207 
208         uint stakeBought = msg.value.mul(stakeMultiplier);
209         stakeBought = stakeBought.div(1000);
210         playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += stakeBought;
211         leadAddress = msg.sender;
212         totalStake += stakeBought;
213         addTime(stakeBought); // Add time based on amount bought
214         emit InvestReceipt(msg.sender, stakeBought);
215     }
216 
217     // Referrals only work with this function
218     function buyStakeWithEth(address _referrer) public payable {
219         require(msg.value >= 10000000000000000, "0.01 ETH minimum.");
220         if(_referrer != address(0)){
221                 uint _referralBonus = msg.value.div(50); // 2% referral
222                 if(_referrer == msg.sender) {
223                     _referrer = 0x93D43eeFcFbE8F9e479E172ee5d92DdDd2600E3b; // if user tries to refer himself
224                 }
225                 playerDivsInADay[roundId][day].playerStakeAtDay[_referrer] += _referralBonus;
226         }
227         if(now > roundEndTime){
228             startNewRound();
229         }
230 
231         uint stakeBought = msg.value.mul(stakeMultiplier);
232         stakeBought = stakeBought.div(1000);
233         playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += stakeBought;
234         leadAddress = msg.sender;
235         totalStake += stakeBought;
236         addTime(stakeBought);
237         emit InvestReceipt(msg.sender, stakeBought);
238     }
239     
240 
241     // Message stored forever, but only displayed on the site when your address is leading
242     function addMessage(string memory _message) public {
243         bytes memory _messageBytes = bytes(_message);
244         require(_messageBytes.length >= playerMessageMinLength, "Too short");
245         require(_messageBytes.length <= playerMessageMaxLength, "Too long");
246         playerMessage[msg.sender] = _message;
247     }
248     function getMessage(address _playerAddress)
249     external
250     view
251     returns (
252       string memory playerMessage_
253   ) {
254       playerMessage_ = playerMessage[_playerAddress];
255   }
256       // Name stored forever, but only displayed on the site when your address is leading
257     function addName(string memory _name) public {
258         bytes memory _messageBytes = bytes(_name);
259         require(_messageBytes.length >= playerMessageMinLength, "Too short");
260         require(_messageBytes.length <= playerMessageMaxLength, "Too long");
261         playerName[msg.sender] = _name;
262     }
263   
264     function getName(address _playerAddress)
265     external
266     view
267     returns (
268       string memory playerName_
269   ) {
270       playerName_ = playerName[_playerAddress];
271   }
272    
273     
274     function getPlayerCurrentRoundDivs(address _playerAddress) public view returns(uint playerTotalDivs) {
275         uint _playerTotalDivs;
276         uint _playerRollingStake;
277         for(uint c = 0 ; c < day; c++) { //iterate through all days of current round 
278             uint _playerStakeAtDay = playerDivsInADay[roundId][c].playerStakeAtDay[_playerAddress];
279             if(_playerStakeAtDay == 0 && _playerRollingStake == 0){
280                     continue; //if player has no stake then continue out to save gas
281                 }
282             _playerRollingStake += _playerStakeAtDay;
283             uint _revenueAtDay = playerDivsInADay[roundId][c].revenueAtDay;
284             uint _totalStakeAtDay = playerDivsInADay[roundId][c].totalStakeAtDay;
285             uint _playerShareAtDay = _playerRollingStake.mul(_revenueAtDay)/_totalStakeAtDay;
286             _playerTotalDivs += _playerShareAtDay;
287         }
288         return _playerTotalDivs.div(2); // Divide by 2, 50% goes to players as dividends, 50% goes to the jackpot.
289     }
290     
291     function getPlayerPreviousRoundDivs(address _playerAddress) public view returns(uint playerPreviousRoundDivs) {
292         uint _playerPreviousRoundDivs;
293         for(uint r = 1 ; r < roundId; r++) { // Iterate through all previous rounds 
294             uint _playerRollingStake;
295             uint _lastDay = roundIdToDays[r];
296             for(uint p = 0 ; p < _lastDay; p++) { //iterate through all days of previous round 
297                 uint _playerStakeAtDay = playerDivsInADay[r][p].playerStakeAtDay[_playerAddress];
298                 if(_playerStakeAtDay == 0 && _playerRollingStake == 0){
299                         continue; // If player has no stake then continue to next day to save gas
300                     }
301                 _playerRollingStake += _playerStakeAtDay;
302                 uint _revenueAtDay = playerDivsInADay[r][p].revenueAtDay;
303                 uint _totalStakeAtDay = playerDivsInADay[r][p].totalStakeAtDay;
304                 uint _playerShareAtDay = _playerRollingStake.mul(_revenueAtDay)/_totalStakeAtDay;
305                 _playerPreviousRoundDivs += _playerShareAtDay;
306             }
307         }
308         return _playerPreviousRoundDivs.div(2); // Divide by 2, 50% goes to players as dividends, 50% goes to the jackpot.
309     }
310     
311     function getPlayerTotalDivs(address _playerAddress) public view returns(uint PlayerTotalDivs) {
312         uint _playerTotalDivs;
313         _playerTotalDivs += getPlayerPreviousRoundDivs(_playerAddress);
314         _playerTotalDivs += getPlayerCurrentRoundDivs(_playerAddress);
315         
316         return _playerTotalDivs;
317     }
318     
319     function getPlayerCurrentStake(address _playerAddress) public view returns(uint playerCurrentStake) {
320         uint _playerRollingStake;
321         for(uint c = 0 ; c <= day; c++) { //iterate through all days of current round 
322             uint _playerStakeAtDay = playerDivsInADay[roundId][c].playerStakeAtDay[_playerAddress];
323             if(_playerStakeAtDay == 0 && _playerRollingStake == 0){
324                     continue; //if player has no stake then continue out to save gas
325                 }
326             _playerRollingStake += _playerStakeAtDay;
327         }
328         return _playerRollingStake;
329     }
330     
331 
332     // Buy a stake using your earned dividends from past or current round
333     function reinvestDivs(uint _divs) external{
334         require(_divs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");
335         uint _senderDivs = getPlayerTotalDivs(msg.sender);
336         spentDivs[msg.sender] += _divs;
337         uint _spentDivs = spentDivs[msg.sender];
338         uint _availableDivs = _senderDivs.sub(_spentDivs);
339         require(_availableDivs >= 0);
340         if(now > roundEndTime){
341             startNewRound();
342         }
343         playerDivsInADay[roundId][day].playerStakeAtDay[msg.sender] += _divs;
344         leadAddress = msg.sender;
345         totalStake += _divs;
346         addTime(_divs);
347         emit InvestReceipt(msg.sender, _divs);
348     }
349     // Turn your earned dividends from past or current rounds into Ether
350     function withdrawDivs(uint _divs) external{
351         require(_divs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");
352         uint _senderDivs = getPlayerTotalDivs(msg.sender);
353         spentDivs[msg.sender] += _divs;
354         uint _spentDivs = spentDivs[msg.sender];
355         uint _availableDivs = _senderDivs.sub(_spentDivs);
356         require(_availableDivs >= 0);
357         msg.sender.transfer(_divs);
358         emit CashedOut(msg.sender, _divs);
359     }
360     // Reinvests all of a players dividends using contract, for people without MetaMask
361     function reinvestDivsWithContract(address payable _reinvestor) external{ 
362         require(msg.sender == reinvestmentContractAddress);
363         uint _senderDivs = getPlayerTotalDivs(_reinvestor);
364         uint _spentDivs = spentDivs[_reinvestor];
365         uint _availableDivs = _senderDivs.sub(_spentDivs);
366         spentDivs[_reinvestor] += _senderDivs;
367         require(_availableDivs >= 10000000000000000, "You need at least 0.01 ETH in dividends.");
368         if(now > roundEndTime){
369             startNewRound();
370         }
371         playerDivsInADay[roundId][day].playerStakeAtDay[_reinvestor] += _availableDivs;
372         leadAddress = _reinvestor;
373         totalStake += _availableDivs;
374         addTime(_availableDivs);
375         emit InvestReceipt(msg.sender, _availableDivs);
376     }
377     // Withdraws all of a players dividends using contract, for people without MetaMask
378     function withdrawDivsWithContract(address payable _withdrawer) external{ 
379         require(msg.sender == withdrawalContractAddress);
380         uint _senderDivs = getPlayerTotalDivs(_withdrawer);
381         uint _spentDivs = spentDivs[_withdrawer];
382         uint _availableDivs = _senderDivs.sub(_spentDivs);
383         spentDivs[_withdrawer] += _availableDivs;
384         require(_availableDivs >= 0);
385         _withdrawer.transfer(_availableDivs);
386         emit CashedOut(_withdrawer, _availableDivs);
387     }
388     
389     // Time functions
390     function addTime(uint _stakeBought) private {
391         uint _timeAdd = _stakeBought/1000000000000; //1000000000000 0.01 ETH adds 2.77 hours
392         if(_timeAdd < timeInADay){
393             roundEndTime += _timeAdd;
394         }else{
395         roundEndTime += timeInADay; //24 hour cap
396         }
397             
398         if(now > startOfNewDay) { //check if 24 hours has passed
399             startNewDay();
400         }
401     }
402     
403     function startNewDay() private {
404         playerDivsInADay[roundId][day].totalStakeAtDay = totalStake;
405         playerDivsInADay[roundId][day].revenueAtDay = totalStake - playerDivsInADay[roundId][day-1].totalStakeAtDay; //div revenue today = pot today - pot yesterday
406         if(stakeMultiplier > 1000) {
407             stakeMultiplier -= 1;
408         }
409         startOfNewDay = now + timeInADay;
410         ++day;
411     }
412 
413     function startNewRound() private { 
414         playerDivsInADay[roundId][day].totalStakeAtDay = totalStake; //commit last changes to ending round
415         playerDivsInADay[roundId][day].revenueAtDay = totalStake - playerDivsInADay[roundId][day-1].totalStakeAtDay; //div revenue today = pot today - pot yesterday
416         roundIdToDays[roundId] = day; //save last day of ending round
417         jackpot();
418         resetRound();
419     }
420     function jackpot() private {
421         uint winnerShare = playerDivsInADay[roundId][day].totalStakeAtDay.div(2) + seed[roundId]; //add last seed to pot
422         seed[roundId+1] = totalStake.div(10); //10% of pot to seed next round
423         winnerShare -= seed[roundId+1];
424         leadAddress.transfer(winnerShare);
425         emit CashedOut(leadAddress, winnerShare);
426     }
427     function resetRound() private {
428         roundId += 1;
429         roundEndTime = now + timeInAWeek;  //add 1 week time to start next round
430         startOfNewDay = now; // save day start time, multiplier decreases 0.1%/day
431         day = 0;
432         stakeMultiplier = 1100;
433         totalStake = 10000000;
434     }
435 
436     function returnTimeLeft()
437      public view
438      returns(uint256) {
439      return(roundEndTime.sub(now));
440      }
441      
442     function returnDayTimeLeft()
443      public view
444      returns(uint256) {
445      return(startOfNewDay.sub(now));
446      }
447      
448     function returnSeedAtRound(uint _roundId)
449      public view
450      returns(uint256) {
451      return(seed[_roundId]);
452      }
453     function returnjackpot()
454      public view 
455      returns(uint256){
456         uint winnerShare = totalStake/2 + seed[roundId]; //add last seed to pot
457         uint nextseed = totalStake/10; //10% of pot to seed next round
458         winnerShare -= nextseed;
459         return winnerShare;
460     }
461     function returnEarningsAtDay(uint256 _roundId, uint256 _day, address _playerAddress)
462      public view 
463      returns(uint256){
464         uint earnings = playerDivsInADay[_roundId][_day].playerStakeAtDay[_playerAddress];
465         return earnings;
466     }
467       function setWithdrawalAndReinvestmentContracts(address _withdrawalContractAddress, address _reinvestmentContractAddress) external onlyOwner {
468     withdrawalContractAddress = _withdrawalContractAddress;
469     reinvestmentContractAddress = _reinvestmentContractAddress;
470   }
471 }
472 
473 contract WithdrawalContract {
474     
475     address payable public etherStakeAddress;
476     address payable public owner;
477     
478     
479     constructor(address payable _etherStakeAddress) public {
480         etherStakeAddress = _etherStakeAddress;
481         owner = msg.sender;
482     }
483     
484     function() external payable{
485         require(msg.value >= 10000000000000000, "0.01 ETH Fee");
486         EtherStake instanceEtherStake = EtherStake(etherStakeAddress);
487         instanceEtherStake.withdrawDivsWithContract(msg.sender);
488     }
489     
490     function collectFees() external {
491         owner.transfer(address(this).balance);
492     }
493 }