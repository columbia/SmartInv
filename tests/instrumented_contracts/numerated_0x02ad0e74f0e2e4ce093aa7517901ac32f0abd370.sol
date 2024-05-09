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
116         uint256 mntpShareReward = SafeMath.div(SafeMath.mul(mntpReward, MAGNITUDE), totalMntpHeld);
117         uint256 goldShareReward = SafeMath.div(SafeMath.mul(goldReward, MAGNITUDE), totalMntpHeld);
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
129         rewardAmp = SafeMath.mul(mntpRewardPerShare, getUserStake(userAddress));
130         rewardAmp = (rewardAmp < getUserMntpRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserMntpRewardPayouts(userAddress));
131         reward = SafeMath.div(rewardAmp, MAGNITUDE);
132         
133         return (reward, rewardAmp);
134     }
135     
136     function getGoldTokenUserReward(address userAddress) public view returns(uint256 reward, uint256 rewardAmp) {  
137         rewardAmp = SafeMath.mul(goldRewardPerShare, getUserStake(userAddress));
138         rewardAmp = (rewardAmp < getUserGoldRewardPayouts(userAddress)) ? 0 : SafeMath.sub(rewardAmp, getUserGoldRewardPayouts(userAddress));
139         reward = SafeMath.div(rewardAmp, MAGNITUDE);
140         
141         return (reward, rewardAmp);
142     }
143     
144     function getUserMntpRewardPayouts(address userAddress) public view returns(uint256) {
145         return _rewardMntpPayouts[userAddress];
146     }    
147     
148     function getUserGoldRewardPayouts(address userAddress) public view returns(uint256) {
149         return _rewardGoldPayouts[userAddress];
150     }    
151     
152     function getUserStake(address userAddress) public view returns(uint256) {
153         return _userStakes[userAddress];
154     }    
155 
156 }
157 
158 
159 contract GoldmintPool {
160 
161     address public tokenBankAddress = address(0x0);
162 
163     PoolCore public core;
164     IStdToken public mntpToken;
165     IStdToken public goldToken;
166 
167     bool public isActualContractVer = true;
168     bool public isActive = true;
169     
170     event onDistribShareProfit(uint256 mntpReward, uint256 goldReward); 
171     event onUserRewardWithdrawn(address indexed userAddress, uint256 mntpReward, uint256 goldReward);
172     event onHoldStake(address indexed userAddress, uint256 mntpAmount);
173     event onUnholdStake(address indexed userAddress, uint256 mntpAmount);
174 
175     modifier onlyAdministrator() {
176         require(core.isAdministrator(msg.sender));
177         _;
178     }
179 
180     modifier onlyAdministratorOrManager() {
181         require(core.isAdministrator(msg.sender) || core.isManager(msg.sender));
182         _;
183     }
184     
185     modifier notNullAddress(address addr) {
186         require(addr != address(0x0));
187         _;
188     }
189     
190     modifier onlyActive() {
191         require(isActive);
192         _;
193     }
194 
195     constructor(address coreAddr, address tokenBankAddr) notNullAddress(coreAddr) notNullAddress(tokenBankAddr) public { 
196         core = PoolCore(coreAddr);
197         mntpToken = core.mntpToken();
198         goldToken = core.goldToken();
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
250         require(getMntpBalance() >= mntpReward);
251         require(getGoldBalance() >= goldReward);
252 
253         core.addUserPayouts(msg.sender, mntpRewardAmp, goldRewardAmp);
254         
255         if (mntpReward > 0) mntpToken.transfer(msg.sender, mntpReward);
256         if (goldReward > 0) goldToken.transfer(msg.sender, goldReward);
257         
258         emit onUserRewardWithdrawn(msg.sender, mntpReward, goldReward);
259     }
260     
261     function withdrawRewardAndUnholdStake() onlyActive public {
262         withdrawUserReward();
263         unholdStake();
264     }
265     
266     function addRewadToStake() onlyActive public {
267         uint256 mntpReward; uint256 mntpRewardAmp;
268         
269         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
270         
271         require(mntpReward > 0);
272 
273         core.addUserPayouts(msg.sender, mntpRewardAmp, 0);
274         core.addHeldTokens(msg.sender, mntpReward);
275     }
276 
277     //migrate to new controller contract in case of some mistake in the contract and transfer there all the tokens and eth. It can be done only after code review by Etherama developers.
278     function migrateToNewControllerContract(address newControllerAddr) onlyAdministrator public {
279         require(newControllerAddr != address(0x0) && isActualContractVer);
280         
281         isActive = false;
282 
283         core.setNewControllerAddress(newControllerAddr);
284 
285         uint256 mntpTokenAmount = getMntpBalance();
286         uint256 goldTokenAmount = getGoldBalance();
287 
288         if (mntpTokenAmount > 0) mntpToken.transfer(newControllerAddr, mntpTokenAmount); 
289         if (goldTokenAmount > 0) goldToken.transfer(newControllerAddr, goldTokenAmount); 
290 
291         isActualContractVer = false;
292     }
293 
294     function getMntpTokenUserReward() public view returns(uint256) {  
295         uint256 mntpReward; uint256 mntpRewardAmp;
296         (mntpReward, mntpRewardAmp) = core.getMntpTokenUserReward(msg.sender);
297         return mntpReward;
298     }
299     
300     function getGoldTokenUserReward() public view returns(uint256) {  
301         uint256 goldReward; uint256 goldRewardAmp;
302         (goldReward, goldRewardAmp) = core.getGoldTokenUserReward(msg.sender);
303         return goldReward;
304     }
305     
306     function getUserMntpRewardPayouts() public view returns(uint256) {
307         return core.getUserMntpRewardPayouts(msg.sender);
308     }    
309     
310     function getUserGoldRewardPayouts() public view returns(uint256) {
311         return core.getUserGoldRewardPayouts(msg.sender);
312     }    
313     
314     function getUserStake() public view returns(uint256) {
315         return core.getUserStake(msg.sender);
316     } 
317 
318     // HELPERS
319 
320     function getMntpBalance() view public returns(uint256) {
321         return mntpToken.balanceOf(address(this));
322     }
323 
324     function getGoldBalance() view public returns(uint256) {
325         return goldToken.balanceOf(address(this));
326     }
327 
328 }
329 
330 
331 library SafeMath {
332 
333     /**
334     * @dev Multiplies two numbers, throws on overflow.
335     */
336     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
337         if (a == 0) {
338             return 0;
339         }
340         uint256 c = a * b;
341         assert(c / a == b);
342         return c;
343     }
344 
345     /**
346     * @dev Integer division of two numbers, truncating the quotient.
347     */
348     function div(uint256 a, uint256 b) internal pure returns (uint256) {
349         // assert(b > 0); // Solidity automatically throws when dividing by 0
350         uint256 c = a / b;
351         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
352         return c;
353     }
354 
355     /**
356     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
357     */
358     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
359         assert(b <= a);
360         return a - b;
361     }
362 
363     /**
364     * @dev Adds two numbers, throws on overflow.
365     */
366     function add(uint256 a, uint256 b) internal pure returns (uint256) {
367         uint256 c = a + b;
368         assert(c >= a);
369         return c;
370     } 
371 
372     function min(uint256 a, uint256 b) internal pure returns (uint256) {
373         return a < b ? a : b;
374     }   
375 
376     function max(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a < b ? b : a;
378     }   
379 }