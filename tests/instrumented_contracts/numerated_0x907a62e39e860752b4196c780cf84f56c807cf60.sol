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
198         tokenBankAddress = tokenBankAddr;
199     }
200     
201     function setTokenBankAddress(address addr) onlyAdministrator notNullAddress(addr) public {
202         tokenBankAddress = addr;
203     }
204     
205     function switchActive() onlyAdministrator public {
206         require(isActualContractVer);
207         isActive = !isActive;
208     }
209     
210     function holdStake(uint256 mntpAmount) onlyActive public {
211         require(mntpToken.balanceOf(msg.sender) > 0);
212         require(mntpToken.balanceOf(msg.sender) >= mntpAmount);
213         
214         mntpToken.transferFrom(msg.sender, address(this), mntpAmount);
215         core.addHeldTokens(msg.sender, mntpAmount);
216         
217         emit onHoldStake(msg.sender, mntpAmount);
218     }
219     
220     function unholdStake() onlyActive public {
221         uint256 amount = core.getUserStake(msg.sender);
222         
223         require(amount > 0);
224         require(getMntpBalance() >= amount);
225 		
226         core.freeHeldTokens(msg.sender, amount);
227         mntpToken.transfer(msg.sender, amount);
228         
229         emit onUnholdStake(msg.sender, amount);
230     }
231     
232     function distribShareProfit(uint256 mntpReward, uint256 goldReward) onlyActive onlyAdministratorOrManager public {
233         if (mntpReward > 0) mntpToken.transferFrom(tokenBankAddress, address(this), mntpReward);
234         if (goldReward > 0) goldToken.transferFrom(tokenBankAddress, address(this), goldReward);
235         
236         core.addRewardPerShare(mntpReward, goldReward);
237         
238         emit onDistribShareProfit(mntpReward, goldReward);
239     }
240 
241     function withdrawUserReward() onlyActive public {
242         uint256 mntpReward; uint256 mntpRewardAmp;
243         uint256 goldReward; uint256 goldRewardAmp;
244 
245         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
246         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
247 
248         require(getMntpBalance() >= mntpReward);
249         require(getGoldBalance() >= goldReward);
250 
251         core.addUserPayouts(msg.sender, mntpRewardAmp, goldRewardAmp);
252         
253         if (mntpReward > 0) mntpToken.transfer(msg.sender, mntpReward);
254         if (goldReward > 0) goldToken.transfer(msg.sender, goldReward);
255         
256         emit onUserRewardWithdrawn(msg.sender, mntpReward, goldReward);
257     }
258     
259     function withdrawRewardAndUnholdStake() onlyActive public {
260         withdrawUserReward();
261         unholdStake();
262     }
263     
264     function addRewadToStake() onlyActive public {
265         uint256 mntpReward; uint256 mntpRewardAmp;
266         
267         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
268         
269         require(mntpReward > 0);
270 
271         core.addUserPayouts(msg.sender, mntpRewardAmp, 0);
272         core.addHeldTokens(msg.sender, mntpReward);
273     }
274 
275     //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.
276     function migrateToNewControllerContract(address newControllerAddr) onlyAdministrator public {
277         require(newControllerAddr != address(0x0) && isActualContractVer);
278         
279         isActive = false;
280 
281         core.setNewControllerAddress(newControllerAddr);
282 
283         uint256 mntpTokenAmount = getMntpBalance();
284         uint256 goldTokenAmount = getGoldBalance();
285 
286         if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount); 
287         if (goldTokenAmount > 0) goldToken.transfer(newControllerAddr, goldTokenAmount); 
288 
289         isActualContractVer = false;
290     }
291 
292     function getMntpTokenUserReward() public view returns(uint256) {  
293         uint256 mntpReward; uint256 mntpRewardAmp;
294         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
295         return mntpReward;
296     }
297     
298     function getGoldTokenUserReward() public view returns(uint256) {  
299         uint256 goldReward; uint256 goldRewardAmp;
300         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
301         return goldReward;
302     }
303     
304     function getUserMntpRewardPayouts() public view returns(uint256) {
305         return core.getUserMntpRewardPayouts(msg.sender);
306     }    
307     
308     function getUserGoldRewardPayouts() public view returns(uint256) {
309         return core.getUserGoldRewardPayouts(msg.sender);
310     }    
311     
312     function getUserStake() public view returns(uint256) {
313         return core.getUserStake(msg.sender);
314     } 
315 
316     // HELPERS
317 
318     function getMntpBalance() view public returns(uint256) {
319         return mntpToken.balanceOf(address(this));
320     }
321 
322     function getGoldBalance() view public returns(uint256) {
323         return goldToken.balanceOf(address(this));
324     }
325 
326 }
327 
328 
329 library SafeMath {
330 
331     /**
332     * @dev Multiplies two numbers, throws on overflow.
333     */
334     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
335         if (a == 0) {
336             return 0;
337         }
338         uint256 c = a * b;
339         assert(c / a == b);
340         return c;
341     }
342 
343     /**
344     * @dev Integer division of two numbers, truncating the quotient.
345     */
346     function div(uint256 a, uint256 b) internal pure returns (uint256) {
347         // assert(b > 0); // Solidity automatically throws when dividing by 0
348         uint256 c = a / b;
349         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
350         return c;
351     }
352 
353     /**
354     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
355     */
356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
357         assert(b <= a);
358         return a - b;
359     }
360 
361     /**
362     * @dev Adds two numbers, throws on overflow.
363     */
364     function add(uint256 a, uint256 b) internal pure returns (uint256) {
365         uint256 c = a + b;
366         assert(c >= a);
367         return c;
368     } 
369 
370     function min(uint256 a, uint256 b) internal pure returns (uint256) {
371         return a < b ? a : b;
372     }   
373 
374     function max(uint256 a, uint256 b) internal pure returns (uint256) {
375         return a < b ? b : a;
376     }   
377 }