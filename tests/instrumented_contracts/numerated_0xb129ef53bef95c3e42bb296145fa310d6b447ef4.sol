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
70     mapping(address => uint256) public _mntpRewardPerShare;   
71 
72     //gold reward per share
73     mapping(address => uint256) public _goldRewardPerShare;  
74 
75     address public controllerAddress = address(0x0);
76 
77     mapping(address => uint256) public _rewardMntpPayouts;
78     mapping(address => uint256) public _rewardGoldPayouts;
79 
80     mapping(address => uint256) public _userStakes;
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
160 
161 contract GoldmintPool {
162 
163     address public tokenBankAddress = address(0x0);
164 
165     PoolCore public core;
166     IStdToken public mntpToken;
167     IStdToken public goldToken;
168 
169     bool public isActualContractVer = true;
170     bool public isActive = true;
171     
172     event onDistribShareProfit(uint256 mntpReward, uint256 goldReward); 
173     event onUserRewardWithdrawn(address indexed userAddress, uint256 mntpReward, uint256 goldReward);
174     event onHoldStake(address indexed userAddress, uint256 mntpAmount);
175     event onUnholdStake(address indexed userAddress, uint256 mntpAmount);
176 
177     modifier onlyAdministrator() {
178         require(core.isAdministrator(msg.sender));
179         _;
180     }
181 
182     modifier onlyAdministratorOrManager() {
183         require(core.isAdministrator(msg.sender) || core.isManager(msg.sender));
184         _;
185     }
186     
187     modifier notNullAddress(address addr) {
188         require(addr != address(0x0));
189         _;
190     }
191     
192     modifier onlyActive() {
193         require(isActive);
194         _;
195     }
196 
197     constructor(address coreAddr, address tokenBankAddr) notNullAddress(coreAddr) notNullAddress(tokenBankAddr) public { 
198         core = PoolCore(coreAddr);
199         mntpToken = core.mntpToken();
200         goldToken = core.goldToken();
201         
202         tokenBankAddress = tokenBankAddr;
203     }
204     
205     function setTokenBankAddress(address addr) onlyAdministrator notNullAddress(addr) public {
206         tokenBankAddress = addr;
207     }
208     
209     function switchActive() onlyAdministrator public {
210         require(isActualContractVer);
211         isActive = !isActive;
212     }
213     
214     function holdStake(uint256 mntpAmount) onlyActive public {
215         require(mntpToken.balanceOf(msg.sender) > 0);
216         require(mntpToken.balanceOf(msg.sender) >= mntpAmount);
217         
218         mntpToken.transferFrom(msg.sender, address(this), mntpAmount);
219         core.addHeldTokens(msg.sender, mntpAmount);
220         
221         emit onHoldStake(msg.sender, mntpAmount);
222     }
223     
224     function unholdStake() onlyActive public {
225         uint256 amount = core.getUserStake(msg.sender);
226         
227         require(amount > 0);
228         require(getMntpBalance() >= amount);
229 		
230         core.freeHeldTokens(msg.sender);
231         mntpToken.transfer(msg.sender, amount);
232         
233         emit onUnholdStake(msg.sender, amount);
234     }
235     
236     function distribShareProfit(uint256 mntpReward, uint256 goldReward) onlyActive onlyAdministratorOrManager public {
237         if (mntpReward > 0) mntpToken.transferFrom(tokenBankAddress, address(this), mntpReward);
238         if (goldReward > 0) goldToken.transferFrom(tokenBankAddress, address(this), goldReward);
239         
240         core.addRewardPerShare(mntpReward, goldReward);
241         
242         emit onDistribShareProfit(mntpReward, goldReward);
243     }
244 
245     function withdrawUserReward() onlyActive public {
246         uint256 mntpReward; uint256 mntpRewardAmp;
247         uint256 goldReward; uint256 goldRewardAmp;
248 
249         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
250         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
251 
252         require(getMntpBalance() >= mntpReward);
253         require(getGoldBalance() >= goldReward);
254 
255         core.addUserPayouts(msg.sender, mntpRewardAmp, goldRewardAmp);
256         
257         if (mntpReward > 0) mntpToken.transfer(msg.sender, mntpReward);
258         if (goldReward > 0) goldToken.transfer(msg.sender, goldReward);
259         
260         emit onUserRewardWithdrawn(msg.sender, mntpReward, goldReward);
261     }
262     
263     function withdrawRewardAndUnholdStake() onlyActive public {
264         withdrawUserReward();
265         unholdStake();
266     }
267     
268     function addRewadToStake() onlyActive public {
269         uint256 mntpReward; uint256 mntpRewardAmp;
270         
271         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
272         
273         require(mntpReward > 0);
274 
275         core.addUserPayouts(msg.sender, mntpRewardAmp, 0);
276         core.addHeldTokens(msg.sender, mntpReward);
277     }
278 
279     //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.
280     function migrateToNewControllerContract(address newControllerAddr) onlyAdministrator public {
281         require(newControllerAddr != address(0x0) && isActualContractVer);
282         
283         isActive = false;
284 
285         core.setNewControllerAddress(newControllerAddr);
286 
287         uint256 mntpTokenAmount = getMntpBalance();
288         uint256 goldTokenAmount = getGoldBalance();
289 
290         if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount); 
291         if (goldTokenAmount > 0) goldToken.transfer(newControllerAddr, goldTokenAmount); 
292 
293         isActualContractVer = false;
294     }
295 
296     function getMntpTokenUserReward() public view returns(uint256) {  
297         uint256 mntpReward; uint256 mntpRewardAmp;
298         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
299         return mntpReward;
300     }
301     
302     function getGoldTokenUserReward() public view returns(uint256) {  
303         uint256 goldReward; uint256 goldRewardAmp;
304         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
305         return goldReward;
306     }
307     
308     function getUserMntpRewardPayouts() public view returns(uint256) {
309         return core.getUserMntpRewardPayouts(msg.sender);
310     }    
311     
312     function getUserGoldRewardPayouts() public view returns(uint256) {
313         return core.getUserGoldRewardPayouts(msg.sender);
314     }    
315     
316     function getUserStake() public view returns(uint256) {
317         return core.getUserStake(msg.sender);
318     } 
319 
320     // HELPERS
321 
322     function getMntpBalance() view public returns(uint256) {
323         return mntpToken.balanceOf(address(this));
324     }
325 
326     function getGoldBalance() view public returns(uint256) {
327         return goldToken.balanceOf(address(this));
328     }
329 
330 }
331 
332 
333 library SafeMath {
334 
335     /**
336     * @dev Multiplies two numbers, throws on overflow.
337     */
338     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
339         if (a == 0) {
340             return 0;
341         }
342         uint256 c = a * b;
343         assert(c / a == b);
344         return c;
345     }
346 
347     /**
348     * @dev Integer division of two numbers, truncating the quotient.
349     */
350     function div(uint256 a, uint256 b) internal pure returns (uint256) {
351         // assert(b > 0); // Solidity automatically throws when dividing by 0
352         uint256 c = a / b;
353         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
354         return c;
355     }
356 
357     /**
358     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
359     */
360     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
361         assert(b <= a);
362         return a - b;
363     }
364 
365     /**
366     * @dev Adds two numbers, throws on overflow.
367     */
368     function add(uint256 a, uint256 b) internal pure returns (uint256) {
369         uint256 c = a + b;
370         assert(c >= a);
371         return c;
372     } 
373 
374     function min(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a < b ? a : b;
376     }   
377 
378     function max(uint256 a, uint256 b) internal pure returns (uint256) {
379         return a < b ? b : a;
380     }   
381 }