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
108     function freeHeldTokens(address userAddress, uint256 tokenAmount) onlyController public {
109         _userStakes[userAddress] = SafeMath.sub(_userStakes[userAddress], tokenAmount);
110         totalMntpHeld = SafeMath.sub(totalMntpHeld, tokenAmount);
111     }
112 
113     function addRewardPerShare(uint256 mntpReward, uint256 goldReward) onlyController public {
114         require(totalMntpHeld > 0);
115 
116         uint256 mntpShareReward = (mntpReward * MAGNITUDE) / totalMntpHeld;
117         uint256 goldShareReward = (goldReward * MAGNITUDE) / totalMntpHeld;
118 
119         mntpRewardPerShare = SafeMath.add(mntpRewardPerShare, mntpShareReward);
120         goldRewardPerShare = SafeMath.add(goldRewardPerShare, goldShareReward);
121     }  
122     
123     function addUserPayouts(address userAddress, uint256 mntpReward, uint256 goldReward) onlyController public {
124         _rewardMntpPayouts[userAddress] = SafeMath.add(_rewardMntpPayouts[userAddress], mntpReward);
125         _rewardGoldPayouts[userAddress] = SafeMath.add(_rewardGoldPayouts[userAddress], goldReward);
126     }
127 
128     function getMntpTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  
129         rewardAmp = mntpRewardPerShare * getUserStake(userAddress);
130         rewardAmp = (rewardAmp < getUserMntpRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserMntpRewardPayouts(userAddress));
131         reward = rewardAmp / MAGNITUDE;
132         return (reward, rewardAmp);
133     }
134     
135     function getGoldTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  
136         rewardAmp = goldRewardPerShare * getUserStake(userAddress);
137         rewardAmp = (rewardAmp < getUserGoldRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserGoldRewardPayouts(userAddress));
138         reward = rewardAmp / MAGNITUDE;
139         return (reward, rewardAmp);
140     }
141     
142     function getUserMntpRewardPayouts(address userAddress) public view returns(uint256) {
143         return _rewardMntpPayouts[userAddress];
144     }    
145     
146     function getUserGoldRewardPayouts(address userAddress) public view returns(uint256) {
147         return _rewardGoldPayouts[userAddress];
148     }    
149     
150     function getUserStake(address userAddress) public view returns(uint256) {
151         return _userStakes[userAddress];
152     }    
153 
154 }
155 
156 
157 contract GoldmintPool {
158 
159     address public tokenBankAddress = address(0x0);
160 
161     PoolCore public core;
162     IStdToken public mntpToken;
163     IStdToken public goldToken;
164 
165     bool public isActualContractVer = true;
166     bool public isActive = true;
167     
168     event onDistribShareProfit(uint256 mntpReward, uint256 goldReward); 
169     event onUserRewardWithdrawn(address indexed userAddress, uint256 mntpReward, uint256 goldReward);
170     event onHoldStake(address indexed userAddress, uint256 mntpAmount);
171     event onUnholdStake(address indexed userAddress, uint256 mntpAmount);
172 
173     modifier onlyAdministrator() {
174         require(core.isAdministrator(msg.sender));
175         _;
176     }
177 
178     modifier onlyAdministratorOrManager() {
179         require(core.isAdministrator(msg.sender) || core.isManager(msg.sender));
180         _;
181     }
182     
183     modifier notNullAddress(address addr) {
184         require(addr != address(0x0));
185         _;
186     }
187     
188     modifier onlyActive() {
189         require(isActive);
190         _;
191     }
192 
193     constructor(address coreAddr, address tokenBankAddr) notNullAddress(coreAddr) notNullAddress(tokenBankAddr) public { 
194         core = PoolCore(coreAddr);
195         mntpToken = core.mntpToken();
196         goldToken = core.goldToken();
197         
198         core.setNewControllerAddress(address(this));
199         
200         tokenBankAddress = tokenBankAddr;
201     }
202     
203     function setTokenBankAddress(address addr) onlyAdministrator notNullAddress(addr) public {
204         tokenBankAddress = addr;
205     }
206     
207     function switchActive() onlyAdministrator public {
208         require(isActualContractVer);
209         isActive = !isActive;
210     }
211     
212     function holdStake(uint256 mntpAmount) onlyActive public {
213         require(mntpToken.balanceOf(msg.sender) > 0);
214         require(mntpToken.balanceOf(msg.sender) >= mntpAmount);
215         
216         mntpToken.transferFrom(msg.sender, address(this), mntpAmount);
217         core.addHeldTokens(msg.sender, mntpAmount);
218         
219         emit onHoldStake(msg.sender, mntpAmount);
220     }
221     
222     function unholdStake() onlyActive public {
223         uint256 amount = core.getUserStake(msg.sender);
224         
225         require(amount > 0);
226         require(getMntpBalance() >= amount);
227 		
228         core.freeHeldTokens(msg.sender, amount);
229         mntpToken.transfer(msg.sender, amount);
230         
231         emit onUnholdStake(msg.sender, amount);
232     }
233     
234     function distribShareProfit(uint256 mntpReward, uint256 goldReward) onlyActive onlyAdministratorOrManager public {
235         if (mntpReward > 0) mntpToken.transferFrom(tokenBankAddress, address(this), mntpReward);
236         if (goldReward > 0) goldToken.transferFrom(tokenBankAddress, address(this), goldReward);
237         
238         core.addRewardPerShare(mntpReward, goldReward);
239         
240         emit onDistribShareProfit(mntpReward, goldReward);
241     }
242 
243     function withdrawUserReward() onlyActive public {
244         uint256 mntpReward; uint256 mntpRewardAmp;
245         uint256 goldReward; uint256 goldRewardAmp;
246 
247         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
248         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
249 
250         require(mntpReward > 0 || goldReward > 0);
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