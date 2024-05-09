1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier - Full Stack Blockchain Developer
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 contract Bank {
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) public balance;
13     mapping(address => uint256) public claimedSum;
14     mapping(address => uint256) public donateSum;
15     mapping(address => bool) public isMember;
16     address[] public member;
17 
18     uint256 public TIME_OUT = 7 days;
19     mapping(address => uint256) public lastClaim;
20 
21     CitizenInterface public citizenContract;
22     LotteryInterface public lotteryContract;
23     F2mInterface public f2mContract;
24     DevTeamInterface public devTeamContract;
25 
26     constructor (address _devTeam)
27         public
28     {
29         // add administrators here
30         devTeamContract = DevTeamInterface(_devTeam);
31         devTeamContract.setBankAddress(address(this));
32     }
33 
34     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
35     function joinNetwork(address[6] _contract)
36         public
37     {
38         require(address(citizenContract) == 0x0,"already setup");
39         f2mContract = F2mInterface(_contract[0]);
40         //bankContract = BankInterface(bankAddress);
41         citizenContract = CitizenInterface(_contract[2]);
42         lotteryContract = LotteryInterface(_contract[3]);
43     }
44 
45     // Core functions
46 
47     function pushToBank(address _player)
48         public
49         payable
50     {
51         uint256 _amount = msg.value;
52         lastClaim[_player] = block.timestamp;
53         balance[_player] = _amount.add(balance[_player]);
54     }
55 
56     function collectDividends(address _member)
57         public
58         returns(uint256)
59     {
60         require(_member != address(devTeamContract), "no right");
61         uint256 collected = f2mContract.withdrawFor(_member);
62         claimedSum[_member] += collected;
63         return collected;
64     }
65 
66     function collectRef(address _member)
67         public
68         returns(uint256)
69     {
70         require(_member != address(devTeamContract), "no right");
71         uint256 collected = citizenContract.withdrawFor(_member);
72         claimedSum[_member] += collected;
73         return collected;
74     }
75 
76     function collectReward(address _member)
77         public
78         returns(uint256)
79     {
80         require(_member != address(devTeamContract), "no right");
81         uint256 collected = lotteryContract.withdrawFor(_member);
82         claimedSum[_member] += collected;
83         return collected;
84     }
85 
86     function collectIncome(address _member)
87         public
88         returns(uint256)
89     {
90         require(_member != address(devTeamContract), "no right");
91         //lastClaim[_member] = block.timestamp;
92         uint256 collected = collectDividends(_member) + collectRef(_member) + collectReward(_member);
93         return collected;
94     }
95 
96     function restTime(address _member)
97         public
98         view
99         returns(uint256)
100     {
101         uint256 timeDist = block.timestamp - lastClaim[_member];
102         if (timeDist >= TIME_OUT) return 0;
103         return TIME_OUT - timeDist;
104     }
105 
106     function timeout(address _member)
107         public
108         view
109         returns(bool)
110     {
111         return lastClaim[_member] > 0 && restTime(_member) == 0;
112     }
113 
114     function memberLog()
115         private
116     {
117         address _member = msg.sender;
118         lastClaim[_member] = block.timestamp;
119         if (isMember[_member]) return;
120         member.push(_member);
121         isMember[_member] = true;
122     }
123 
124     function cashoutable()
125         public
126         view
127         returns(bool)
128     {
129         return lotteryContract.cashoutable(msg.sender);
130     }
131 
132     function cashout()
133         public
134     {
135         address _sender = msg.sender;
136         uint256 _amount = balance[_sender];
137         require(_amount > 0, "nothing to cashout");
138         balance[_sender] = 0;
139         memberLog();
140         require(cashoutable() && _amount > 0, "need 1 ticket or wait to new round");
141         _sender.transfer(_amount);
142     }
143 
144     // ref => devTeam
145     // div => div
146     // lottery => div
147     function checkTimeout(address _member)
148         public
149     {
150         require(timeout(_member), "member still got time to withdraw");
151         require(_member != address(devTeamContract), "no right");
152         uint256 _curBalance = balance[_member];
153         uint256 _refIncome = collectRef(_member);
154         uint256 _divIncome = collectDividends(_member);
155         uint256 _rewardIncome = collectReward(_member);
156         donateSum[_member] += _refIncome + _divIncome + _rewardIncome;
157         balance[_member] = _curBalance;
158         f2mContract.pushDividends.value(_divIncome + _rewardIncome)();
159         citizenContract.pushRefIncome.value(_refIncome)(0x0);
160     }
161 
162     function withdraw() 
163         public
164     {
165         address _member = msg.sender;
166         collectIncome(_member);
167         cashout();
168         //lastClaim[_member] = block.timestamp;
169     } 
170 
171     function lotteryReinvest(string _sSalt, uint256 _amount)
172         public
173         payable
174     {
175         address _sender = msg.sender;
176         uint256 _deposit = msg.value;
177         uint256 _curBalance = balance[_sender];
178         uint256 investAmount;
179         uint256 collected = 0;
180         if (_deposit == 0) {
181             if (_amount > balance[_sender]) 
182                 collected = collectIncome(_sender);
183             require(_amount <= _curBalance + collected, "balance not enough");
184             investAmount = _amount;//_curBalance + collected;
185         } else {
186             collected = collectIncome(_sender);
187             investAmount = _deposit.add(_curBalance).add(collected);
188         }
189         balance[_sender] = _curBalance.add(collected + _deposit).sub(investAmount);
190         lastClaim [_sender] = block.timestamp;
191         lotteryContract.buyFor.value(investAmount)(_sSalt, _sender);
192     }
193 
194     function tokenReinvest(uint256 _amount) 
195         public
196         payable
197     {
198         address _sender = msg.sender;
199         uint256 _deposit = msg.value;
200         uint256 _curBalance = balance[_sender];
201         uint256 investAmount;
202         uint256 collected = 0;
203         if (_deposit == 0) {
204             if (_amount > balance[_sender]) 
205                 collected = collectIncome(_sender);
206             require(_amount <= _curBalance + collected, "balance not enough");
207             investAmount = _amount;//_curBalance + collected;
208         } else {
209             collected = collectIncome(_sender);
210             investAmount = _deposit.add(_curBalance).add(collected);
211         }
212         balance[_sender] = _curBalance.add(collected + _deposit).sub(investAmount);
213         lastClaim [_sender] = block.timestamp;
214         f2mContract.buyFor.value(investAmount)(_sender);
215     }
216 
217     // Read
218     function getDivBalance(address _sender)
219         public
220         view
221         returns(uint256)
222     {
223         uint256 _amount = f2mContract.ethBalance(_sender);
224         return _amount;
225     }
226 
227     function getEarlyIncomeBalance(address _sender)
228         public
229         view
230         returns(uint256)
231     {
232         uint256 _amount = lotteryContract.getCurEarlyIncomeByAddress(_sender);
233         return _amount;
234     }
235 
236     function getRewardBalance(address _sender)
237         public
238         view
239         returns(uint256)
240     {
241         uint256 _amount = lotteryContract.getRewardBalance(_sender);
242         return _amount;
243     }
244 
245     function getRefBalance(address _sender)
246         public
247         view
248         returns(uint256)
249     {
250         uint256 _amount = citizenContract.getRefWallet(_sender);
251         return _amount;
252     }
253 
254     function getBalance(address _sender)
255         public
256         view
257         returns(uint256)
258     {
259         uint256 _sum = getUnclaimedBalance(_sender);
260         return _sum + balance[_sender];
261     }
262 
263     function getUnclaimedBalance(address _sender)
264         public
265         view
266         returns(uint256)
267     {
268         uint256 _sum = getDivBalance(_sender) + getRefBalance(_sender) + getRewardBalance(_sender) + getEarlyIncomeBalance(_sender);
269         return _sum;
270     }
271 
272     function getClaimedBalance(address _sender)
273         public
274         view
275         returns(uint256)
276     {
277         return balance[_sender];
278     }
279 
280     function getTotalMember() 
281         public
282         view
283         returns(uint256)
284     {
285         return member.length;
286     }
287 }
288 
289 
290 /**
291  * @title SafeMath
292  * @dev Math operations with safety checks that revert on error
293  */
294 library SafeMath {
295     int256 constant private INT256_MIN = -2**255;
296 
297     /**
298     * @dev Multiplies two unsigned integers, reverts on overflow.
299     */
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
302         // benefit is lost if 'b' is also tested.
303         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
304         if (a == 0) {
305             return 0;
306         }
307 
308         uint256 c = a * b;
309         require(c / a == b);
310 
311         return c;
312     }
313 
314     /**
315     * @dev Multiplies two signed integers, reverts on overflow.
316     */
317     function mul(int256 a, int256 b) internal pure returns (int256) {
318         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
319         // benefit is lost if 'b' is also tested.
320         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
321         if (a == 0) {
322             return 0;
323         }
324 
325         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
326 
327         int256 c = a * b;
328         require(c / a == b);
329 
330         return c;
331     }
332 
333     /**
334     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
335     */
336     function div(uint256 a, uint256 b) internal pure returns (uint256) {
337         // Solidity only automatically asserts when dividing by 0
338         require(b > 0);
339         uint256 c = a / b;
340         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
341 
342         return c;
343     }
344 
345     /**
346     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
347     */
348     function div(int256 a, int256 b) internal pure returns (int256) {
349         require(b != 0); // Solidity only automatically asserts when dividing by 0
350         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
351 
352         int256 c = a / b;
353 
354         return c;
355     }
356 
357     /**
358     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
359     */
360     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
361         require(b <= a);
362         uint256 c = a - b;
363 
364         return c;
365     }
366 
367     /**
368     * @dev Subtracts two signed integers, reverts on overflow.
369     */
370     function sub(int256 a, int256 b) internal pure returns (int256) {
371         int256 c = a - b;
372         require((b >= 0 && c <= a) || (b < 0 && c > a));
373 
374         return c;
375     }
376 
377     /**
378     * @dev Adds two unsigned integers, reverts on overflow.
379     */
380     function add(uint256 a, uint256 b) internal pure returns (uint256) {
381         uint256 c = a + b;
382         require(c >= a);
383 
384         return c;
385     }
386 
387     /**
388     * @dev Adds two signed integers, reverts on overflow.
389     */
390     function add(int256 a, int256 b) internal pure returns (int256) {
391         int256 c = a + b;
392         require((b >= 0 && c >= a) || (b < 0 && c < a));
393 
394         return c;
395     }
396 
397     /**
398     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
399     * reverts when dividing by zero.
400     */
401     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
402         require(b != 0);
403         return a % b;
404     }
405 }
406 
407 interface F2mInterface {
408     function joinNetwork(address[6] _contract) public;
409     // one time called
410     // function disableRound0() public;
411     function activeBuy() public;
412     // function premine() public;
413     // Dividends from all sources (DApps, Donate ...)
414     function pushDividends() public payable;
415     /**
416      * Converts all of caller's dividends to tokens.
417      */
418     function buyFor(address _buyer) public payable;
419     function sell(uint256 _tokenAmount) public;
420     function exit() public;
421     function devTeamWithdraw() public returns(uint256);
422     function withdrawFor(address sender) public returns(uint256);
423     function transfer(address _to, uint256 _tokenAmount) public returns(bool);
424     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
425     function setAutoBuy() public;
426     /*==========================================
427     =            PUBLIC FUNCTIONS            =
428     ==========================================*/
429     function ethBalance(address _address) public view returns(uint256);
430     function myBalance() public view returns(uint256);
431     function myEthBalance() public view returns(uint256);
432 
433     function swapToken() public;
434     function setNewToken(address _newTokenAddress) public;
435 }
436 
437 interface CitizenInterface {
438  
439     function joinNetwork(address[6] _contract) public;
440     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
441     function devTeamWithdraw() public;
442 
443     /*----------  WRITE FUNCTIONS  ----------*/
444     function updateUsername(string _sNewUsername) public;
445     //Sources: Token contract, DApps
446     function pushRefIncome(address _sender) public payable;
447     function withdrawFor(address _sender) public payable returns(uint256);
448     function devTeamReinvest() public returns(uint256);
449 
450     /*----------  READ FUNCTIONS  ----------*/
451     function getRefWallet(address _address) public view returns(uint256);
452 }
453 
454 interface LotteryInterface {
455     function joinNetwork(address[6] _contract) public;
456     // call one time
457     function activeFirstRound() public;
458     // Core Functions
459     function pushToPot() public payable;
460     function finalizeable() public view returns(bool);
461     // bounty
462     function finalize() public;
463     function buy(string _sSalt) public payable;
464     function buyFor(string _sSalt, address _sender) public payable;
465     //function withdraw() public;
466     function withdrawFor(address _sender) public returns(uint256);
467 
468     function getRewardBalance(address _buyer) public view returns(uint256);
469     function getTotalPot() public view returns(uint256);
470     // EarlyIncome
471     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
472     // included claimed amount
473     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
474     function getCurRoundId() public view returns(uint256);
475     // set endRound, prepare to upgrade new version
476     function setLastRound(uint256 _lastRoundId) public;
477     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
478     function cashoutable(address _address) public view returns(bool);
479     function isLastRound() public view returns(bool);
480     function sBountyClaim(address _sBountyHunter) public returns(uint256);
481 }
482 
483 interface DevTeamInterface {
484     function setF2mAddress(address _address) public;
485     function setLotteryAddress(address _address) public;
486     function setCitizenAddress(address _address) public;
487     function setBankAddress(address _address) public;
488     function setRewardAddress(address _address) public;
489     function setWhitelistAddress(address _address) public;
490 
491     function setupNetwork() public;
492 }