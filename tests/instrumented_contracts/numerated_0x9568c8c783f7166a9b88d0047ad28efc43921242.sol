1 pragma solidity ^0.4.25;
2 
3 contract IStdToken {
4     function balanceOf(address _owner) public view returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
7 }
8 
9 contract PoolCommon {
10     
11     //main adrministrators of the Etherama network
12     mapping(address => bool) private _administrators;
13 
14     //main managers of the Etherama network
15     mapping(address => bool) private _managers;
16 
17     
18     modifier onlyAdministrator() {
19         require(_administrators[msg.sender]);
20         _;
21     }
22 
23     modifier onlyAdministratorOrManager() {
24         require(_administrators[msg.sender] || _managers[msg.sender]);
25         _;
26     }
27     
28     constructor() public {
29         _administrators[msg.sender] = true;
30     }
31     
32     
33     function addAdministator(address addr) onlyAdministrator public {
34         _administrators[addr] = true;
35     }
36 
37     function removeAdministator(address addr) onlyAdministrator public {
38         _administrators[addr] = false;
39     }
40 
41     function isAdministrator(address addr) public view returns (bool) {
42         return _administrators[addr];
43     }
44 
45     function addManager(address addr) onlyAdministrator public {
46         _managers[addr] = true;
47     }
48 
49     function removeManager(address addr) onlyAdministrator public {
50         _managers[addr] = false;
51     }
52     
53     function isManager(address addr) public view returns (bool) {
54         return _managers[addr];
55     }
56 }
57 
58 contract PoolCore is PoolCommon {
59     uint256 constant public MAGNITUDE = 2**64;
60 
61     //MNTP token reward per share
62     uint256 public mntpRewardPerShare;
63     //GOLD token reward per share
64     uint256 public goldRewardPerShare;
65 
66     //Total MNTP tokens held by users
67     uint256 public totalMntpHeld;
68 
69     //mntp reward per share
70     mapping(address => uint256) private _mntpRewardPerShare;   
71 
72     //gold reward per share
73     mapping(address => uint256) private _goldRewardPerShare;  
74 
75     address public controllerAddress = address(0x0);
76 
77     mapping(address => uint256) private _rewardMntpPayouts;
78     mapping(address => uint256) private _rewardGoldPayouts;
79 
80     mapping(address => uint256) private _userStakes;
81 
82     IStdToken public mntpToken;
83     IStdToken public goldToken;
84 
85 
86     modifier onlyController() {
87         require(controllerAddress == msg.sender);
88         _;
89     }
90 	
91     constructor(address mntpTokenAddr, address goldTokenAddr) PoolCommon() public {
92         controllerAddress = msg.sender;
93         mntpToken = IStdToken(mntpTokenAddr);
94         goldToken = IStdToken(goldTokenAddr);
95     }
96 	
97     function setNewControllerAddress(address newAddress) onlyController public {
98         controllerAddress = newAddress;
99     }
100     
101     function addHeldTokens(address userAddress, uint256 tokenAmount) onlyController public {
102         _userStakes[userAddress] = SafeMath.add(_userStakes[userAddress], tokenAmount);
103         totalMntpHeld = SafeMath.add(totalMntpHeld, tokenAmount);
104         
105         addUserPayouts(userAddress, SafeMath.mul(mntpRewardPerShare, tokenAmount), SafeMath.mul(goldRewardPerShare, tokenAmount));
106     }
107 	
108     function freeHeldTokens(address userAddress) onlyController public {
109         totalMntpHeld = SafeMath.sub(totalMntpHeld, _userStakes[userAddress]);
110 		_userStakes[userAddress] = 0;
111 		_rewardMntpPayouts[userAddress] = 0;
112         _rewardGoldPayouts[userAddress] = 0;
113     }
114 
115     function addRewardPerShare(uint256 mntpReward, uint256 goldReward) onlyController public {
116         require(totalMntpHeld > 0);
117 
118         uint256 mntpShareReward = SafeMath.div(SafeMath.mul(mntpReward, MAGNITUDE), totalMntpHeld);
119         uint256 goldShareReward = SafeMath.div(SafeMath.mul(goldReward, MAGNITUDE), totalMntpHeld);
120 
121         mntpRewardPerShare = SafeMath.add(mntpRewardPerShare, mntpShareReward);
122         goldRewardPerShare = SafeMath.add(goldRewardPerShare, goldShareReward);
123     }  
124     
125     function addUserPayouts(address userAddress, uint256 mntpReward, uint256 goldReward) onlyController public {
126         _rewardMntpPayouts[userAddress] = SafeMath.add(_rewardMntpPayouts[userAddress], mntpReward);
127         _rewardGoldPayouts[userAddress] = SafeMath.add(_rewardGoldPayouts[userAddress], goldReward);
128     }
129 
130     function getMntpTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  
131         rewardAmp = SafeMath.mul(mntpRewardPerShare, getUserStake(userAddress));
132         rewardAmp = (rewardAmp < getUserMntpRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserMntpRewardPayouts(userAddress));
133         reward = SafeMath.div(rewardAmp, MAGNITUDE);
134         
135         return (reward, rewardAmp);
136     }
137     
138     function getGoldTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  
139         rewardAmp = SafeMath.mul(goldRewardPerShare, getUserStake(userAddress));
140         rewardAmp = (rewardAmp < getUserGoldRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserGoldRewardPayouts(userAddress));
141         reward = SafeMath.div(rewardAmp, MAGNITUDE);
142         
143         return (reward, rewardAmp);
144     }
145     
146     function getUserMntpRewardPayouts(address userAddress) public view returns(uint256) {
147         return _rewardMntpPayouts[userAddress];
148     }    
149     
150     function getUserGoldRewardPayouts(address userAddress) public view returns(uint256) {
151         return _rewardGoldPayouts[userAddress];
152     }    
153     
154     function getUserStake(address userAddress) public view returns(uint256) {
155         return _userStakes[userAddress];
156     }    
157 
158 }
159 
160 contract StakeFreezer {
161 
162     address public controllerAddress = address(0x0);
163 
164     mapping(address => uint256) private _userStakes;
165 
166     event onFreeze(address indexed userAddress, uint256 tokenAmount, bytes32 sumusAddress);
167     event onUnfreeze(address indexed userAddress, uint256 tokenAmount);
168 
169 
170     modifier onlyController() {
171         require(controllerAddress == msg.sender);
172         _;
173     }
174 	
175     constructor() public {
176         controllerAddress = msg.sender;
177     }
178 	
179     function setNewControllerAddress(address newAddress) onlyController public {
180         controllerAddress = newAddress;
181     }
182 
183     function freezeUserStake(address userAddress, uint256 tokenAmount, bytes32 sumusAddress) onlyController public {
184         _userStakes[userAddress] = SafeMath.add(_userStakes[userAddress], tokenAmount);
185         emit onFreeze(userAddress, tokenAmount, sumusAddress);
186     }
187 
188 	function unfreezeUserStake(address userAddress, uint256 tokenAmount) onlyController public {
189         _userStakes[userAddress] = SafeMath.sub(_userStakes[userAddress], tokenAmount);
190         emit onUnfreeze(userAddress, tokenAmount);
191     }
192     
193     function getUserFrozenStake(address userAddress) public view returns(uint256) {
194         return _userStakes[userAddress];
195     }
196 }
197 
198 
199 contract GoldmintPool {
200 
201     address public tokenBankAddress = address(0x0);
202 
203     PoolCore public core;
204     StakeFreezer public stakeFreezer;
205     IStdToken public mntpToken;
206     IStdToken public goldToken;
207 
208     bool public isActualContractVer = true;
209     bool public isActive = true;
210     
211     event onDistribShareProfit(uint256 mntpReward, uint256 goldReward); 
212     event onUserRewardWithdrawn(address indexed userAddress, uint256 mntpReward, uint256 goldReward);
213     event onHoldStake(address indexed userAddress, uint256 mntpAmount);
214     event onUnholdStake(address indexed userAddress, uint256 mntpAmount);
215 
216     modifier onlyAdministrator() {
217         require(core.isAdministrator(msg.sender));
218         _;
219     }
220 
221     modifier onlyAdministratorOrManager() {
222         require(core.isAdministrator(msg.sender) || core.isManager(msg.sender));
223         _;
224     }
225     
226     modifier notNullAddress(address addr) {
227         require(addr != address(0x0));
228         _;
229     }
230     
231     modifier onlyActive() {
232         require(isActive);
233         _;
234     }
235 
236     constructor(address coreAddr, address tokenBankAddr, address stakeFreezerAddr) notNullAddress(coreAddr) notNullAddress(tokenBankAddr) public { 
237         core = PoolCore(coreAddr);
238         stakeFreezer = StakeFreezer(stakeFreezerAddr);
239         mntpToken = core.mntpToken();
240         goldToken = core.goldToken();
241         
242         tokenBankAddress = tokenBankAddr;
243     }
244     
245     function setTokenBankAddress(address addr) onlyAdministrator notNullAddress(addr) public {
246         tokenBankAddress = addr;
247     }
248 
249     function setStakeFreezerAddress(address addr) onlyAdministrator public {
250         stakeFreezer = StakeFreezer(addr);
251     }
252     
253     function switchActive() onlyAdministrator public {
254         require(isActualContractVer);
255         isActive = !isActive;
256     }
257     
258     function holdStake(uint256 mntpAmount) onlyActive public {
259         require(mntpToken.balanceOf(msg.sender) > 0);
260         require(mntpToken.balanceOf(msg.sender) >= mntpAmount);
261         
262         mntpToken.transferFrom(msg.sender, address(this), mntpAmount);
263         core.addHeldTokens(msg.sender, mntpAmount);
264         
265         emit onHoldStake(msg.sender, mntpAmount);
266     }
267     
268     function unholdStake() onlyActive public {
269         uint256 frozenAmount;
270         uint256 amount = core.getUserStake(msg.sender);
271         
272         require(amount > 0);
273         require(getMntpBalance() >= amount);
274         
275         if (stakeFreezer != address(0x0)) {
276             frozenAmount = stakeFreezer.getUserFrozenStake(msg.sender);
277         }
278         require(frozenAmount == 0);
279 		
280         core.freeHeldTokens(msg.sender);
281         mntpToken.transfer(msg.sender, amount);
282         
283         emit onUnholdStake(msg.sender, amount);
284     }
285     
286     function distribShareProfit(uint256 mntpReward, uint256 goldReward) onlyActive onlyAdministratorOrManager public {
287         if (mntpReward > 0) mntpToken.transferFrom(tokenBankAddress, address(this), mntpReward);
288         if (goldReward > 0) goldToken.transferFrom(tokenBankAddress, address(this), goldReward);
289         
290         core.addRewardPerShare(mntpReward, goldReward);
291         
292         emit onDistribShareProfit(mntpReward, goldReward);
293     }
294 
295     function withdrawUserReward() onlyActive public {
296         uint256 mntpReward; uint256 mntpRewardAmp;
297         uint256 goldReward; uint256 goldRewardAmp;
298 
299         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
300         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
301 
302         require(getMntpBalance() >= mntpReward);
303         require(getGoldBalance() >= goldReward);
304 
305         core.addUserPayouts(msg.sender, mntpRewardAmp, goldRewardAmp);
306         
307         if (mntpReward > 0) mntpToken.transfer(msg.sender, mntpReward);
308         if (goldReward > 0) goldToken.transfer(msg.sender, goldReward);
309         
310         emit onUserRewardWithdrawn(msg.sender, mntpReward, goldReward);
311     }
312     
313     function withdrawRewardAndUnholdStake() onlyActive public {
314         withdrawUserReward();
315         unholdStake();
316     }
317     
318     function addRewadToStake() onlyActive public {
319         uint256 mntpReward; uint256 mntpRewardAmp;
320         
321         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
322         
323         require(mntpReward > 0);
324 
325         core.addUserPayouts(msg.sender, mntpRewardAmp, 0);
326         core.addHeldTokens(msg.sender, mntpReward);
327 
328         emit onHoldStake(msg.sender, mntpReward);
329     }
330 
331     function freezeStake(bytes32 sumusAddress) onlyActive public {
332         require(stakeFreezer != address(0x0));
333 
334         uint256 stake = core.getUserStake(msg.sender);
335 		require(stake > 0);
336 		
337         uint256 freezeAmount = SafeMath.sub(stake, stakeFreezer.getUserFrozenStake(msg.sender));
338 		require(freezeAmount > 0);
339 
340         stakeFreezer.freezeUserStake(msg.sender, freezeAmount, sumusAddress);
341     }
342 
343     function unfreezeUserStake(address userAddress) onlyActive onlyAdministratorOrManager public {
344         require(stakeFreezer != address(0x0));
345 
346         uint256 amount = stakeFreezer.getUserFrozenStake(userAddress);
347 		require(amount > 0);
348 		
349         stakeFreezer.unfreezeUserStake(userAddress, amount);
350     }
351 
352     //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.
353     function migrateToNewControllerContract(address newControllerAddr) onlyAdministrator public {
354         require(newControllerAddr != address(0x0) && isActualContractVer);
355         
356         isActive = false;
357 
358         core.setNewControllerAddress(newControllerAddr);
359         if (stakeFreezer != address(0x0)) {
360             stakeFreezer.setNewControllerAddress(newControllerAddr);
361         }
362 
363         uint256 mntpTokenAmount = getMntpBalance();
364         uint256 goldTokenAmount = getGoldBalance();
365 
366         if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount); 
367         if (goldTokenAmount > 0) goldToken.transfer(newControllerAddr, goldTokenAmount); 
368 
369         isActualContractVer = false;
370     }
371 
372     function getMntpTokenUserReward() public view returns(uint256) {  
373         uint256 mntpReward; uint256 mntpRewardAmp;
374         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
375         return mntpReward;
376     }
377     
378     function getGoldTokenUserReward() public view returns(uint256) {  
379         uint256 goldReward; uint256 goldRewardAmp;
380         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
381         return goldReward;
382     }
383     
384     function getUserMntpRewardPayouts() public view returns(uint256) {
385         return core.getUserMntpRewardPayouts(msg.sender);
386     }    
387     
388     function getUserGoldRewardPayouts() public view returns(uint256) {
389         return core.getUserGoldRewardPayouts(msg.sender);
390     }    
391     
392     function getUserStake() public view returns(uint256) {
393         return core.getUserStake(msg.sender);
394     }
395 
396     function getUserFrozenStake() public view returns(uint256) {
397         if (stakeFreezer != address(0x0)) {
398             return stakeFreezer.getUserFrozenStake(msg.sender);
399         }
400         return 0;
401     }
402 
403     // HELPERS
404 
405     function getMntpBalance() view public returns(uint256) {
406         return mntpToken.balanceOf(address(this));
407     }
408 
409     function getGoldBalance() view public returns(uint256) {
410         return goldToken.balanceOf(address(this));
411     }
412 
413 }
414 
415 
416 library SafeMath {
417 
418     /**
419     * @dev Multiplies two numbers, throws on overflow.
420     */
421     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
422         if (a == 0) {
423             return 0;
424         }
425         uint256 c = a * b;
426         assert(c / a == b);
427         return c;
428     }
429 
430     /**
431     * @dev Integer division of two numbers, truncating the quotient.
432     */
433     function div(uint256 a, uint256 b) internal pure returns (uint256) {
434         // assert(b > 0); // Solidity automatically throws when dividing by 0
435         uint256 c = a / b;
436         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
437         return c;
438     }
439 
440     /**
441     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
442     */
443     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444         assert(b <= a);
445         return a - b;
446     }
447 
448     /**
449     * @dev Adds two numbers, throws on overflow.
450     */
451     function add(uint256 a, uint256 b) internal pure returns (uint256) {
452         uint256 c = a + b;
453         assert(c >= a);
454         return c;
455     } 
456 
457     function min(uint256 a, uint256 b) internal pure returns (uint256) {
458         return a < b ? a : b;
459     }   
460 
461     function max(uint256 a, uint256 b) internal pure returns (uint256) {
462         return a < b ? b : a;
463     }   
464 }