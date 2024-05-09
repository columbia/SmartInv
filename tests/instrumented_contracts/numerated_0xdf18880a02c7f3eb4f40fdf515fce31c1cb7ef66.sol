1 pragma solidity ^0.4.24;
2 
3 /*
4 *   gibmireinbier
5 *   0xA4a799086aE18D7db6C4b57f496B081b44888888
6 *   gibmireinbier@gmail.com
7 */
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that revert on error
12  */
13 library SafeMath {
14     int256 constant private INT256_MIN = -2**255;
15 
16     /**
17     * @dev Multiplies two unsigned integers, reverts on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21         // benefit is lost if 'b' is also tested.
22         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b);
29 
30         return c;
31     }
32 
33     /**
34     * @dev Multiplies two signed integers, reverts on overflow.
35     */
36     function mul(int256 a, int256 b) internal pure returns (int256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
45 
46         int256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
66     */
67     function div(int256 a, int256 b) internal pure returns (int256) {
68         require(b != 0); // Solidity only automatically asserts when dividing by 0
69         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
70 
71         int256 c = a / b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b <= a);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two signed integers, reverts on overflow.
88     */
89     function sub(int256 a, int256 b) internal pure returns (int256) {
90         int256 c = a - b;
91         require((b >= 0 && c <= a) || (b < 0 && c > a));
92 
93         return c;
94     }
95 
96     /**
97     * @dev Adds two unsigned integers, reverts on overflow.
98     */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a);
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two signed integers, reverts on overflow.
108     */
109     function add(int256 a, int256 b) internal pure returns (int256) {
110         int256 c = a + b;
111         require((b >= 0 && c >= a) || (b < 0 && c < a));
112 
113         return c;
114     }
115 
116     /**
117     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118     * reverts when dividing by zero.
119     */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }
125 
126 interface F2mInterface {
127     function joinNetwork(address[6] _contract) public;
128     // one time called
129     function disableRound0() public;
130     function activeBuy() public;
131     // Dividends from all sources (DApps, Donate ...)
132     function pushDividends() public payable;
133     /**
134      * Converts all of caller's dividends to tokens.
135      */
136     //function reinvest() public;
137     //function buy() public payable;
138     function buyFor(address _buyer) public payable;
139     function sell(uint256 _tokenAmount) public;
140     function exit() public;
141     function devTeamWithdraw() public returns(uint256);
142     function withdrawFor(address sender) public returns(uint256);
143     function transfer(address _to, uint256 _tokenAmount) public returns(bool);
144     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
145     function setAutoBuy() public;
146     /*==========================================
147     =            public FUNCTIONS            =
148     ==========================================*/
149     // function totalEthBalance() public view returns(uint256);
150     function ethBalance(address _address) public view returns(uint256);
151     function myBalance() public view returns(uint256);
152     function myEthBalance() public view returns(uint256);
153 
154     function swapToken() public;
155     function setNewToken(address _newTokenAddress) public;
156 }
157 
158 interface CitizenInterface {
159  
160     function joinNetwork(address[6] _contract) public;
161     /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
162     function devTeamWithdraw() public;
163 
164     /*----------  WRITE FUNCTIONS  ----------*/
165     function updateUsername(string _sNewUsername) public;
166     //Sources: Token contract, DApps
167     function pushRefIncome(address _sender) public payable;
168     function withdrawFor(address _sender) public payable returns(uint256);
169     function devTeamReinvest() public returns(uint256);
170 
171     /*----------  READ FUNCTIONS  ----------*/
172     function getRefWallet(address _address) public view returns(uint256);
173 }
174 
175 interface LotteryInterface {
176     function joinNetwork(address[6] _contract) public;
177     // call one time
178     function activeFirstRound() public;
179     // Core Functions
180     function pushToPot() public payable;
181     function finalizeable() public view returns(bool);
182     // bounty
183     function finalize() public;
184     function buy(string _sSalt) public payable;
185     function buyFor(string _sSalt, address _sender) public payable;
186     //function withdraw() public;
187     function withdrawFor(address _sender) public returns(uint256);
188 
189     function getRewardBalance(address _buyer) public view returns(uint256);
190     function getTotalPot() public view returns(uint256);
191     // EarlyIncome
192     function getEarlyIncomeByAddress(address _buyer) public view returns(uint256);
193     // included claimed amount
194     // function getEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
195     function getCurEarlyIncomeByAddress(address _buyer) public view returns(uint256);
196     // function getCurEarlyIncomeByAddressRound(address _buyer, uint256 _rId) public view returns(uint256);
197     function getCurRoundId() public view returns(uint256);
198     // set endRound, prepare to upgrade new version
199     function setLastRound(uint256 _lastRoundId) public;
200     function getPInvestedSumByRound(uint256 _rId, address _buyer) public view returns(uint256);
201     function cashoutable(address _address) public view returns(bool);
202     function isLastRound() public view returns(bool);
203 }
204 
205 interface DevTeamInterface {
206     function setF2mAddress(address _address) public;
207     function setLotteryAddress(address _address) public;
208     function setCitizenAddress(address _address) public;
209     function setBankAddress(address _address) public;
210     function setRewardAddress(address _address) public;
211     function setWhitelistAddress(address _address) public;
212 
213     function setupNetwork() public;
214 }
215 
216 contract Bank {
217     using SafeMath for uint256;
218 
219     mapping(address => uint256) public balance;
220     mapping(address => uint256) public claimedSum;
221     mapping(address => uint256) public donateSum;
222     mapping(address => bool) public isMember;
223     address[] public member;
224 
225     uint256 public TIME_OUT = 7 * 24 * 60 * 60;
226     mapping(address => uint256) public lastClaim;
227 
228     CitizenInterface public citizenContract;
229     LotteryInterface public lotteryContract;
230     F2mInterface public f2mContract;
231     DevTeamInterface public devTeamContract;
232 
233     constructor (address _devTeam)
234         public
235     {
236         // add administrators here
237         devTeamContract = DevTeamInterface(_devTeam);
238         devTeamContract.setBankAddress(address(this));
239     }
240 
241     // _contract = [f2mAddress, bankAddress, citizenAddress, lotteryAddress, rewardAddress, whitelistAddress];
242     function joinNetwork(address[6] _contract)
243         public
244     {
245         require(address(citizenContract) == 0x0,"already setup");
246         f2mContract = F2mInterface(_contract[0]);
247         //bankContract = BankInterface(bankAddress);
248         citizenContract = CitizenInterface(_contract[2]);
249         lotteryContract = LotteryInterface(_contract[3]);
250     }
251 
252     // Core functions
253 
254     function pushToBank(address _player)
255         public
256         payable
257     {
258         uint256 _amount = msg.value;
259         lastClaim[_player] = block.timestamp;
260         balance[_player] = _amount.add(balance[_player]);
261     }
262 
263     function collectDividends(address _member)
264         public
265         returns(uint256)
266     {
267         require(_member != address(devTeamContract), "no right");
268         uint256 collected = f2mContract.withdrawFor(_member);
269         claimedSum[_member] += collected;
270         return collected;
271     }
272 
273     function collectRef(address _member)
274         public
275         returns(uint256)
276     {
277         require(_member != address(devTeamContract), "no right");
278         uint256 collected = citizenContract.withdrawFor(_member);
279         claimedSum[_member] += collected;
280         return collected;
281     }
282 
283     function collectReward(address _member)
284         public
285         returns(uint256)
286     {
287         require(_member != address(devTeamContract), "no right");
288         uint256 collected = lotteryContract.withdrawFor(_member);
289         claimedSum[_member] += collected;
290         return collected;
291     }
292 
293     function collectIncome(address _member)
294         public
295         returns(uint256)
296     {
297         require(_member != address(devTeamContract), "no right");
298         //lastClaim[_member] = block.timestamp;
299         uint256 collected = collectDividends(_member) + collectRef(_member) + collectReward(_member);
300         return collected;
301     }
302 
303     function restTime(address _member)
304         public
305         view
306         returns(uint256)
307     {
308         uint256 timeDist = block.timestamp - lastClaim[_member];
309         if (timeDist >= TIME_OUT) return 0;
310         return TIME_OUT - timeDist;
311     }
312 
313     function timeout(address _member)
314         public
315         view
316         returns(bool)
317     {
318         return lastClaim[_member] > 0 && restTime(_member) == 0;
319     }
320 
321     function memberLog()
322         private
323     {
324         address _member = msg.sender;
325         lastClaim[_member] = block.timestamp;
326         if (isMember[_member]) return;
327         member.push(_member);
328         isMember[_member] = true;
329     }
330 
331     function cashoutable()
332         public
333         view
334         returns(bool)
335     {
336         return lotteryContract.cashoutable(msg.sender);
337     }
338 
339     function cashout()
340         public
341     {
342         address _sender = msg.sender;
343         uint256 _amount = balance[_sender];
344         require(_amount > 0, "nothing to cashout");
345         balance[_sender] = 0;
346         memberLog();
347         require(cashoutable() && _amount > 0, "need 1 ticket or wait to new round");
348         _sender.transfer(_amount);
349     }
350 
351     // ref => devTeam
352     // div => div
353     // lottery => div
354     function checkTimeout(address _member)
355         public
356     {
357         require(timeout(_member), "member still got time to withdraw");
358         require(_member != address(devTeamContract), "no right");
359         uint256 _curBalance = balance[_member];
360         uint256 _refIncome = collectRef(_member);
361         uint256 _divIncome = collectDividends(_member);
362         uint256 _rewardIncome = collectReward(_member);
363         donateSum[_member] += _refIncome + _divIncome + _rewardIncome;
364         balance[_member] = _curBalance;
365         f2mContract.pushDividends.value(_divIncome + _rewardIncome)();
366         citizenContract.pushRefIncome.value(_refIncome)(0x0);
367     }
368 
369     function withdraw() 
370         public
371     {
372         address _member = msg.sender;
373         collectIncome(_member);
374         cashout();
375         //lastClaim[_member] = block.timestamp;
376     } 
377 
378     function lotteryReinvest(string _sSalt, uint256 _amount)
379         public
380         payable
381     {
382         address _sender = msg.sender;
383         uint256 _deposit = msg.value;
384         uint256 _curBalance = balance[_sender];
385         uint256 investAmount;
386         uint256 collected = 0;
387         if (_deposit == 0) {
388             if (_amount > balance[_sender]) 
389                 collected = collectIncome(_sender);
390             require(_amount <= _curBalance + collected, "balance not enough");
391             investAmount = _amount;//_curBalance + collected;
392         } else {
393             collected = collectIncome(_sender);
394             investAmount = _deposit.add(_curBalance).add(collected);
395         }
396         balance[_sender] = _curBalance.add(collected + _deposit).sub(investAmount);
397         lastClaim [_sender] = block.timestamp;
398         lotteryContract.buyFor.value(investAmount)(_sSalt, _sender);
399     }
400 
401     function tokenReinvest(uint256 _amount) 
402         public
403         payable
404     {
405         address _sender = msg.sender;
406         uint256 _deposit = msg.value;
407         uint256 _curBalance = balance[_sender];
408         uint256 investAmount;
409         uint256 collected = 0;
410         if (_deposit == 0) {
411             if (_amount > balance[_sender]) 
412                 collected = collectIncome(_sender);
413             require(_amount <= _curBalance + collected, "balance not enough");
414             investAmount = _amount;//_curBalance + collected;
415         } else {
416             collected = collectIncome(_sender);
417             investAmount = _deposit.add(_curBalance).add(collected);
418         }
419         balance[_sender] = _curBalance.add(collected + _deposit).sub(investAmount);
420         lastClaim [_sender] = block.timestamp;
421         f2mContract.buyFor.value(investAmount)(_sender);
422     }
423 
424     // Read
425     function getDivBalance(address _sender)
426         public
427         view
428         returns(uint256)
429     {
430         uint256 _amount = f2mContract.ethBalance(_sender);
431         return _amount;
432     }
433 
434     function getEarlyIncomeBalance(address _sender)
435         public
436         view
437         returns(uint256)
438     {
439         uint256 _amount = lotteryContract.getCurEarlyIncomeByAddress(_sender);
440         return _amount;
441     }
442 
443     function getRewardBalance(address _sender)
444         public
445         view
446         returns(uint256)
447     {
448         uint256 _amount = lotteryContract.getRewardBalance(_sender);
449         return _amount;
450     }
451 
452     function getRefBalance(address _sender)
453         public
454         view
455         returns(uint256)
456     {
457         uint256 _amount = citizenContract.getRefWallet(_sender);
458         return _amount;
459     }
460 
461     function getBalance(address _sender)
462         public
463         view
464         returns(uint256)
465     {
466         uint256 _sum = getUnclaimedBalance(_sender);
467         return _sum + balance[_sender];
468     }
469 
470     function getUnclaimedBalance(address _sender)
471         public
472         view
473         returns(uint256)
474     {
475         uint256 _sum = getDivBalance(_sender) + getRefBalance(_sender) + getRewardBalance(_sender) + getEarlyIncomeBalance(_sender);
476         return _sum;
477     }
478 
479     function getClaimedBalance(address _sender)
480         public
481         view
482         returns(uint256)
483     {
484         return balance[_sender];
485     }
486 
487     function getTotalMember() 
488         public
489         view
490         returns(uint256)
491     {
492         return member.length;
493     }
494 }