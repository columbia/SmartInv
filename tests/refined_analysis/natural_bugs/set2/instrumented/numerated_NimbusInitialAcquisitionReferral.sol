1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed from, address indexed to);
22 
23     constructor() {
24         owner = msg.sender;
25         emit OwnershipTransferred(address(0), owner);
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner, "Ownable: Caller is not the owner");
30         _;
31     }
32 
33     function getOwner() external view returns (address) {
34         return owner;
35     }
36 
37     function transferOwnership(address transferOwner) external onlyOwner {
38         require(transferOwner != newOwner);
39         newOwner = transferOwner;
40     }
41 
42     function acceptOwnership() virtual external {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 abstract contract Pausable is Ownable {
51     event Paused(address account);
52     event Unpaused(address account);
53 
54     bool private _paused;
55 
56     constructor () {
57         _paused = false;
58     }
59 
60     function paused() public view returns (bool) {
61         return _paused;
62     }
63 
64     modifier whenNotPaused() {
65         require(!_paused, "Pausable: paused");
66         _;
67     }
68 
69     modifier whenPaused() {
70         require(_paused, "Pausable: not paused");
71         _;
72     }
73 
74 
75     function pause() external onlyOwner whenNotPaused {
76         _paused = true;
77         emit Paused(msg.sender);
78     }
79 
80     function unpause() external onlyOwner whenPaused {
81         _paused = false;
82         emit Unpaused(msg.sender);
83     }
84 }
85 
86 interface INimbusVesting {
87     function vest(address user, uint amount, uint vestingFirstPeriod, uint vestingSecondPeriod) external;
88     function vestWithVestType(address user, uint amount, uint vestingFirstPeriodDuration, uint vestingSecondPeriodDuration, uint vestType) external;
89     function unvest() external returns (uint unvested);
90     function unvestFor(address user) external returns (uint unvested);
91 }
92 
93 interface INimbusReferralProgram {
94     function userSponsorByAddress(address user)  external view returns (uint);
95     function userIdByAddress(address user) external view returns (uint);
96     function userAddressById(uint id) external view returns (address);
97     function userSponsorAddressByAddress(address user) external view returns (address);
98     function registerUserBySponsorId(address user, uint sponsorId, uint category) external returns (uint);
99     function registerUserBySponsorAddress(address user, address sponsorAddress, uint category) external returns (uint); 
100 }
101 
102 interface INimbusStakingPool {
103     function stakeFor(uint amount, address user) external;
104     function balanceOf(address account) external view returns (uint256);
105     function stakingToken() external view returns (IBEP20);
106 }
107 
108 interface INBU_WBNB {
109     function deposit() external payable;
110     function transfer(address to, uint value) external returns (bool);
111     function withdraw(uint) external;
112 }
113 
114 interface INimbusRouter {
115     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
116     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
117 }
118 
119 library Address {
120     function isContract(address account) internal view returns (bool) {
121         // This method relies in extcodesize, which returns 0 for contracts in construction, 
122         // since the code is only stored at the end of the constructor execution.
123 
124         uint256 size;
125         // solhint-disable-next-line no-inline-assembly
126         assembly { size := extcodesize(account) }
127         return size > 0;
128     }
129 }
130 
131 contract NimbusInitialAcquisition is Ownable, Pausable {
132     uint public constant USER_CATEGORY = 3;
133     IBEP20 public immutable SYSTEM_TOKEN;
134     address public immutable NBU_WBNB;
135     INimbusReferralProgram public referralProgram;
136     INimbusStakingPool[] public stakingPoolsSponsor;   //staking pools for checking sponsor balances
137 
138     INimbusVesting public vestingContract;
139     uint public vestingFirstPeriodDuration;
140     uint public vestingSecondPeriodDuration;
141 
142     mapping(uint => INimbusStakingPool) public stakingPools;
143 
144     address public recipient;                      
145    
146     INimbusRouter public swapRouter;                
147     mapping (address => bool) public allowedTokens;
148     address public swapToken;                       
149     uint public swapTokenAmountForBonusThreshold;  
150     
151     uint public sponsorBonus;
152     mapping(address => uint) public unclaimedBonusBases;
153 
154     bool public useWeightedRates;
155     mapping(address => uint) public weightedTokenSystemTokenExchangeRates;
156 
157     uint public giveBonus;
158 
159     event BuySystemTokenForToken(address indexed token, uint tokenAmount, uint systemTokenAmount, address indexed systemTokenRecipient);
160     event BuySystemTokenForBnb(uint bnbAmount, uint systemTokenAmount, address indexed systemTokenRecipient);
161     event ProcessSponsorBonus(address indexed sponsor, address indexed user, uint bonusAmount, uint indexed timestamp);
162     event AddUnclaimedSponsorBonus(address indexed user, uint systemTokenAmount);
163 
164     event UpdateTokenSystemTokenWeightedExchangeRate(address indexed token, uint indexed newRate);
165     event ToggleUseWeightedRates(bool indexed useWeightedRates);
166     event Rescue(address indexed to, uint amount);
167     event RescueToken(address indexed token, address indexed to, uint amount);
168 
169     event AllowedTokenUpdated(address indexed token, bool allowance);
170     event SwapTokenUpdated(address indexed swapToken);
171     event SwapTokenAmountForBonusThresholdUpdated(uint indexed amount);
172 
173     event ProcessGiveBonus(address indexed to, uint amount, uint indexed timestamp);
174     event UpdateGiveBonus(uint indexed giveBonus);
175     event UpdateVestingContract(address indexed vestingContractAddress);
176     event UpdateVestingParams(uint vestingFirstPeriod, uint vestingSecondPeriod);
177 
178     constructor (address systemToken, address vestingContractAddress, address router, address nbuWbnb) {
179         require(Address.isContract(systemToken), "systemToken is not a contract");
180         require(Address.isContract(vestingContractAddress), "vestingContractAddress is not a contract");
181         require(Address.isContract(router), "router is not a contract");
182         require(Address.isContract(nbuWbnb), "nbuWbnb is not a contract");
183         SYSTEM_TOKEN = IBEP20(systemToken);
184         vestingContract = INimbusVesting(vestingContractAddress);
185         NBU_WBNB = nbuWbnb;
186         sponsorBonus = 10;
187         giveBonus = 12;
188         swapRouter = INimbusRouter(router);
189         recipient = address(this);
190         vestingFirstPeriodDuration = 60 days;
191         vestingSecondPeriodDuration = 0;
192     }
193 
194     function availableInitialSupply() external view returns (uint) {
195         return SYSTEM_TOKEN.balanceOf(address(this));
196     }
197 
198     function getSystemTokenAmountForToken(address token, uint tokenAmount) public view returns (uint) { 
199         if (!useWeightedRates) {
200             address[] memory path = new address[](2);
201             path[0] = token;
202             path[1] = address(SYSTEM_TOKEN);
203             return swapRouter.getAmountsOut(tokenAmount, path)[1];
204         } else {
205             return tokenAmount * weightedTokenSystemTokenExchangeRates[token] / 1e18;
206         }  
207     }
208 
209     function getSystemTokenAmountForBnb(uint bnbAmount) public view returns (uint) { 
210         return getSystemTokenAmountForToken(NBU_WBNB, bnbAmount); 
211     }
212 
213     function getTokenAmountForSystemToken(address token, uint systemTokenAmount) public view returns (uint) { 
214         if (!useWeightedRates) { 
215             address[] memory path = new address[](2);
216             path[0] = token;
217             path[1] = address(SYSTEM_TOKEN);
218             return swapRouter.getAmountsIn(systemTokenAmount, path)[0];
219         } else {
220             return systemTokenAmount * 1e18 / weightedTokenSystemTokenExchangeRates[token];
221         }
222     }
223 
224     function getBnbAmountForSystemToken(uint systemTokenAmount) public view returns (uint) { 
225         return getTokenAmountForSystemToken(NBU_WBNB, systemTokenAmount);
226     }
227 
228     function currentBalance(address token) external view returns (uint) { 
229         return IBEP20(token).balanceOf(address(this));
230     }
231 
232     function _buySystemToken(address token, uint tokenAmount, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) private {
233         stakingPools[stakingPoolId].stakeFor(systemTokenAmount, systemTokenRecipient);
234         
235         emit BuySystemTokenForToken(token, tokenAmount, systemTokenAmount, systemTokenRecipient);
236         if (giveBonus > 0) {
237             uint bonusGiveSystemToken = systemTokenAmount * giveBonus / 100;
238             vestingContract.vestWithVestType(systemTokenRecipient, bonusGiveSystemToken, vestingFirstPeriodDuration, vestingSecondPeriodDuration, 1); 
239             emit ProcessGiveBonus(systemTokenRecipient, bonusGiveSystemToken, block.timestamp);
240         }
241         _processSponsor(systemTokenAmount);
242     }
243 
244     function _processSponsor(uint systemTokenAmount) private {
245         address sponsorAddress = _getUserSponsorAddress();
246         if (sponsorAddress != address(0)) { 
247             uint minSystemTokenAmountForBonus = getSystemTokenAmountForToken(swapToken, swapTokenAmountForBonusThreshold);
248             if (systemTokenAmount > minSystemTokenAmountForBonus) {
249                 uint sponsorAmount = SYSTEM_TOKEN.balanceOf(sponsorAddress);
250                 
251                 INimbusStakingPool[] memory stakingPoolsSponsorLocal = stakingPoolsSponsor;
252 
253                 for (uint i; i < stakingPoolsSponsorLocal.length; i++) {
254                     if (sponsorAmount > minSystemTokenAmountForBonus) break;
255                     sponsorAmount += stakingPoolsSponsorLocal[i].balanceOf(sponsorAddress);
256                 }
257                 
258                 if (sponsorAmount > minSystemTokenAmountForBonus) {
259                     uint bonusBase = systemTokenAmount + unclaimedBonusBases[msg.sender];
260                     uint sponsorBonusAmount = bonusBase * sponsorBonus / 100;
261                     require(SYSTEM_TOKEN.transfer(sponsorAddress, sponsorBonusAmount), "SYSTEM_TOKEN::transfer: transfer failed");
262                     unclaimedBonusBases[msg.sender] = 0;
263                     emit ProcessSponsorBonus(sponsorAddress, msg.sender, sponsorBonusAmount, block.timestamp);
264                 } else {
265                     unclaimedBonusBases[msg.sender] += systemTokenAmount;
266                     emit AddUnclaimedSponsorBonus(msg.sender, systemTokenAmount);
267                 }
268             } else {
269                 unclaimedBonusBases[msg.sender] += systemTokenAmount;
270                 emit AddUnclaimedSponsorBonus(msg.sender, systemTokenAmount);
271             }
272         } else {
273             unclaimedBonusBases[msg.sender] += systemTokenAmount;
274             emit AddUnclaimedSponsorBonus(msg.sender, systemTokenAmount);
275         }
276     }
277 
278     function _getUserSponsorAddress() private view returns (address) {
279         if (address(referralProgram) == address(0)) {
280             return address(0);
281         } else {
282             return referralProgram.userSponsorAddressByAddress(msg.sender);
283         } 
284     }
285 
286     function buyExactSystemTokenForTokensAndRegister(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) external whenNotPaused {
287         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
288         referralProgram.registerUserBySponsorId(msg.sender, sponsorId, USER_CATEGORY);
289         buyExactSystemTokenForTokens(token, systemTokenAmount, systemTokenRecipient, stakingPoolId);
290     }
291 
292     function buyExactSystemTokenForTokensAndRegister(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) external whenNotPaused {
293         referralProgram.registerUserBySponsorId(msg.sender, 1000000001, USER_CATEGORY);
294         buyExactSystemTokenForTokens(token, systemTokenAmount, systemTokenRecipient, stakingPoolId);
295     }
296 
297     function buyExactSystemTokenForBnbAndRegister(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) payable external whenNotPaused {
298         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
299         referralProgram.registerUserBySponsorId(msg.sender, sponsorId, USER_CATEGORY);
300         buyExactSystemTokenForBnb(systemTokenAmount, systemTokenRecipient, stakingPoolId);
301     }
302 
303     function buyExactSystemTokenForBnbAndRegister(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) payable external whenNotPaused {
304         referralProgram.registerUserBySponsorId(msg.sender, 1000000001, USER_CATEGORY);
305         buyExactSystemTokenForBnb(systemTokenAmount, systemTokenRecipient, stakingPoolId);
306     }
307 
308     function buySystemTokenForExactBnbAndRegister(address systemTokenRecipient, uint stakingPoolId, uint sponsorId) payable external whenNotPaused {
309         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
310         referralProgram.registerUserBySponsorId(msg.sender, sponsorId, USER_CATEGORY);
311         buySystemTokenForExactBnb(systemTokenRecipient, stakingPoolId);
312     }
313 
314     function buySystemTokenForExactBnbAndRegister(address systemTokenRecipient, uint stakingPoolId) payable external whenNotPaused {
315         referralProgram.registerUserBySponsorId(msg.sender, 1000000001, USER_CATEGORY);
316         buySystemTokenForExactBnb(systemTokenRecipient, stakingPoolId);
317     }
318 
319     function buySystemTokenForExactTokensAndRegister(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) external whenNotPaused {
320         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
321         referralProgram.registerUserBySponsorId(msg.sender, sponsorId, USER_CATEGORY);
322         buySystemTokenForExactTokens(token, tokenAmount, systemTokenRecipient, stakingPoolId);
323     }
324 
325     function buySystemTokenForExactTokensAndRegister(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId) external whenNotPaused {
326         referralProgram.registerUserBySponsorId(msg.sender, 1000000001, USER_CATEGORY);
327         buySystemTokenForExactTokens(token, tokenAmount, systemTokenRecipient, stakingPoolId);
328     }
329     
330     function buyExactSystemTokenForTokens(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) public whenNotPaused {
331         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
332         require(allowedTokens[token], "NimbusInitialAcquisition: Not allowed token");
333         uint tokenAmount = getTokenAmountForSystemToken(token, systemTokenAmount);
334         TransferHelper.safeTransferFrom(token, msg.sender, recipient, tokenAmount);
335         _buySystemToken(token, tokenAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
336     }
337 
338     function buySystemTokenForExactTokens(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId) public whenNotPaused {
339         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
340         require(allowedTokens[token], "NimbusInitialAcquisition: Not allowed token");
341         uint systemTokenAmount = getSystemTokenAmountForToken(token, tokenAmount);
342         TransferHelper.safeTransferFrom(token, msg.sender, recipient, tokenAmount);
343         _buySystemToken(token, tokenAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
344     }
345 
346     function buySystemTokenForExactBnb(address systemTokenRecipient, uint stakingPoolId) payable public whenNotPaused {
347         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
348         require(allowedTokens[NBU_WBNB], "NimbusInitialAcquisition: Not allowed purchase for BNB");
349         uint systemTokenAmount = getSystemTokenAmountForBnb(msg.value);
350         INBU_WBNB(NBU_WBNB).deposit{value: msg.value}();
351         _buySystemToken(NBU_WBNB, msg.value, systemTokenAmount, systemTokenRecipient, stakingPoolId);
352     }
353 
354     function buyExactSystemTokenForBnb(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) payable public whenNotPaused {
355         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
356         require(allowedTokens[NBU_WBNB], "NimbusInitialAcquisition: Not allowed purchase for BNB");
357         uint systemTokenAmountMax = getSystemTokenAmountForBnb(msg.value);
358         require(systemTokenAmountMax >= systemTokenAmount, "NimbusInitialAcquisition: Not enough BNB");
359         uint bnbAmount = systemTokenAmountMax == systemTokenAmount ? msg.value : getBnbAmountForSystemToken(systemTokenAmount);
360         INBU_WBNB(NBU_WBNB).deposit{value: bnbAmount}();
361         _buySystemToken(NBU_WBNB, bnbAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
362         // refund dust bnb, if any
363         if (systemTokenAmountMax > systemTokenAmount) TransferHelper.safeTransferBNB(msg.sender, msg.value - bnbAmount);
364     }
365 
366     function claimSponsorBonusesBatch(address[] memory users) external { 
367         for (uint i; i < users.length; i++) {
368             claimSponsorBonuses(users[i]);
369         }
370     }
371 
372     function claimSponsorBonuses(address user) public {
373         require(unclaimedBonusBases[user] > 0, "NimbusInitialAcquisition: No unclaimed bonuses");
374         uint userSponsor = referralProgram.userSponsorByAddress(user);
375         require(userSponsor == referralProgram.userIdByAddress(msg.sender) && userSponsor != 0, "NimbusInitialAcquisition: Not user sponsor");
376         
377         uint minSystemTokenAmountForBonus = getSystemTokenAmountForToken(swapToken, swapTokenAmountForBonusThreshold);
378         uint bonusBase = unclaimedBonusBases[user];
379         require (bonusBase >= minSystemTokenAmountForBonus, "NimbusInitialAcquisition: Bonus threshold not met");
380         
381         INimbusStakingPool[] memory stakingPoolsSponsorLocal = stakingPoolsSponsor;
382 
383         uint sponsorAmount = SYSTEM_TOKEN.balanceOf(msg.sender);
384         for (uint i; i < stakingPoolsSponsorLocal.length; i++) {
385             if (sponsorAmount > minSystemTokenAmountForBonus) break;
386             sponsorAmount += stakingPoolsSponsorLocal[i].balanceOf(msg.sender);
387         }
388         
389         require (sponsorAmount > minSystemTokenAmountForBonus, "NimbusInitialAcquisition: Sponsor balance threshold for bonus not met");
390         uint sponsorBonusAmount = bonusBase * sponsorBonus / 100;
391         require(SYSTEM_TOKEN.transfer(msg.sender, sponsorBonusAmount), "SYSTEM_TOKEN::transfer: transfer failed");
392         unclaimedBonusBases[user] = 0;
393         emit ProcessSponsorBonus(msg.sender, user, sponsorBonusAmount, block.timestamp);
394     }
395     
396 
397 
398     //Admin functions
399     function rescue(address payable to, uint256 amount) external onlyOwner {
400         require(to != address(0), "NimbusInitialAcquisition: Can't be zero address");
401         require(amount > 0, "NimbusInitialAcquisition: Should be greater than 0");
402         TransferHelper.safeTransferBNB(to, amount);
403         emit Rescue(to, amount);
404     }
405 
406     function rescue(address to, address token, uint256 amount) external onlyOwner {
407         require(to != address(0), "NimbusInitialAcquisition: Can't be zero address");
408         require(amount > 0, "NimbusInitialAcquisition: Should be greater than 0");
409         TransferHelper.safeTransfer(token, to, amount);
410         emit RescueToken(token, to, amount);
411     }
412 
413     function updateStakingPool(uint id, address stakingPool) public onlyOwner {
414         _updateStakingPool(id, stakingPool);
415     }
416 
417     function updateStakingPool(uint[] memory ids, address[] memory _stakingPools) external onlyOwner {
418         require(ids.length == _stakingPools.length, "NimbusInitialAcquisition: Ids and staking pools arrays have different size.");
419         
420         for(uint i = 0; i < ids.length; i++) {
421             _updateStakingPool(ids[i], _stakingPools[i]);
422         }
423     }
424 
425     function updateAllowedTokens(address token, bool isAllowed) external onlyOwner {
426         require (token != address(0), "NimbusInitialAcquisition: Wrong addresses");
427         allowedTokens[token] = isAllowed;
428         emit AllowedTokenUpdated(token, isAllowed);
429     }
430     
431     function updateRecipient(address recipientAddress) external onlyOwner {
432         require(recipientAddress != address(0), "NimbusInitialAcquisition: Address is zero");
433         recipient = recipientAddress;
434     } 
435 
436     function updateSponsorBonus(uint bonus) external onlyOwner {
437         sponsorBonus = bonus;
438     }
439 
440     function updateReferralProgramContract(address newReferralProgramContract) external onlyOwner {
441         require(newReferralProgramContract != address(0), "NimbusInitialAcquisition: Address is zero");
442         referralProgram = INimbusReferralProgram(newReferralProgramContract);
443     }
444 
445     function updateStakingPoolAdd(address newStakingPool) external onlyOwner {
446         INimbusStakingPool pool = INimbusStakingPool(newStakingPool);
447         require (pool.stakingToken() == SYSTEM_TOKEN, "NimbusInitialAcquisition: Wrong pool staking tokens");
448 
449         INimbusStakingPool[] memory stakingPoolsSponsorLocal = stakingPoolsSponsor;
450 
451         for (uint i; i < stakingPoolsSponsorLocal.length; i++) {
452             require (address(stakingPoolsSponsorLocal[i]) != newStakingPool, "NimbusInitialAcquisition: Pool exists");
453         }
454         stakingPoolsSponsor.push(pool);
455     }
456 
457     function updateStakingPoolRemove(uint poolIndex) external onlyOwner {
458         stakingPoolsSponsor[poolIndex] = stakingPoolsSponsor[stakingPoolsSponsor.length - 1];
459         stakingPoolsSponsor.pop();
460     }
461 
462     function updateSwapRouter(address newSwapRouter) external onlyOwner {
463         require(newSwapRouter != address(0), "NimbusInitialAcquisition: Address is zero");
464         swapRouter = INimbusRouter(newSwapRouter);
465     }
466 
467     function updateVestingContract(address vestingContractAddress) external onlyOwner {
468         require(Address.isContract(vestingContractAddress), "NimbusInitialAcquisition: VestingContractAddress is not a contract");
469         vestingContract = INimbusVesting(vestingContractAddress);
470         emit UpdateVestingContract(vestingContractAddress);
471     }
472 
473     function updateVestingParams(uint vestingFirstPeriod, uint vestingSecondPeriod) external onlyOwner {
474         require(vestingFirstPeriod != vestingFirstPeriodDuration && vestingSecondPeriodDuration != vestingSecondPeriod, "NimbusInitialAcquisition: Same params");
475         vestingFirstPeriodDuration = vestingFirstPeriod;
476         vestingSecondPeriodDuration = vestingSecondPeriod;
477         emit UpdateVestingParams(vestingFirstPeriod, vestingSecondPeriod);
478     }
479 
480     function updateSwapToken(address newSwapToken) external onlyOwner {
481         require(newSwapToken != address(0), "NimbusInitialAcquisition: Address is zero");
482         swapToken = newSwapToken;
483         emit SwapTokenUpdated(swapToken);
484     }
485 
486     function updateSwapTokenAmountForBonusThreshold(uint threshold) external onlyOwner {
487         swapTokenAmountForBonusThreshold = threshold;
488         emit SwapTokenAmountForBonusThresholdUpdated(swapTokenAmountForBonusThreshold);
489     }
490 
491     function updateTokenSystemTokenWeightedExchangeRate(address token, uint rate) external onlyOwner {
492         weightedTokenSystemTokenExchangeRates[token] = rate;
493         emit UpdateTokenSystemTokenWeightedExchangeRate(token, rate);
494     }
495 
496     function toggleUseWeightedRates() external onlyOwner {
497         useWeightedRates = !useWeightedRates;
498         emit ToggleUseWeightedRates(useWeightedRates);
499     }
500 
501     function _updateStakingPool(uint id, address stakingPool) private {
502         require(id != 0, "NimbusInitialAcquisition: Staking pool id cant be equal to 0.");
503         require(stakingPool != address(0), "NimbusInitialAcquisition: Staking pool address cant be equal to address(0).");
504 
505         stakingPools[id] = INimbusStakingPool(stakingPool);
506         require(SYSTEM_TOKEN.approve(stakingPool, type(uint256).max), "NimbusInitialAcquisition: Error on approving");
507     }
508 
509     function updateGiveBonus(uint bonus) external onlyOwner {
510         giveBonus = bonus;
511         emit UpdateGiveBonus(bonus);
512     }
513 
514 }
515 
516 library TransferHelper {
517     function safeApprove(address token, address to, uint value) internal {
518         // bytes4(keccak256(bytes('approve(address,uint256)')));
519         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
520         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
521     }
522 
523     function safeTransfer(address token, address to, uint value) internal {
524         // bytes4(keccak256(bytes('transfer(address,uint256)')));
525         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
526         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
527     }
528 
529     function safeTransferFrom(address token, address from, address to, uint value) internal {
530         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
531         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
532         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
533     }
534 
535     function safeTransferBNB(address to, uint value) internal {
536         (bool success,) = to.call{value:value}(new bytes(0));
537         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
538     }
539 }