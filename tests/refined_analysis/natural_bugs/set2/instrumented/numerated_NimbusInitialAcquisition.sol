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
98 }
99 
100 interface INimbusStakingPool {
101     function stakeFor(uint amount, address user) external;
102     function balanceOf(address account) external view returns (uint256);
103     function stakingToken() external view returns (IBEP20);
104 }
105 
106 interface INBU_WBNB {
107     function deposit() external payable;
108     function transfer(address to, uint value) external returns (bool);
109     function withdraw(uint) external;
110 }
111 
112 interface INimbusRouter {
113     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
114     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
115 }
116 
117 interface INimbusReferralProgramMarketing {
118     function registerUser(address user, uint sponsorId) external returns(uint userId);
119     function updateReferralProfitAmount(address user, uint amount) external;
120 }
121 
122 library Address {
123     function isContract(address account) internal view returns (bool) {
124         // This method relies in extcodesize, which returns 0 for contracts in construction, 
125         // since the code is only stored at the end of the constructor execution.
126 
127         uint256 size;
128         // solhint-disable-next-line no-inline-assembly
129         assembly { size := extcodesize(account) }
130         return size > 0;
131     }
132 }
133 
134 contract NimbusInitialAcquisition is Ownable, Pausable {
135     IBEP20 public immutable SYSTEM_TOKEN;
136     address public immutable NBU_WBNB;
137     INimbusReferralProgram public referralProgram;
138     INimbusReferralProgramMarketing public referralProgramMarketing;
139 
140     INimbusVesting public vestingContract;
141     uint public vestingFirstPeriodDuration;
142     uint public vestingSecondPeriodDuration;
143     
144     bool public allowAccuralMarketingReward;
145 
146     mapping(uint => INimbusStakingPool) public stakingPools;
147     mapping(address => uint) public userPurchases;
148     mapping(address => uint) public userPurchasesEquivalent;
149 
150     address public recipient;                      
151    
152     INimbusRouter public swapRouter;                
153     mapping (address => bool) public allowedTokens;
154     address public swapToken;                       
155     uint public swapTokenAmountForBonusThreshold;  
156     
157     uint public sponsorBonus;
158     mapping(address => uint) public unclaimedBonusBases;
159     mapping(address => uint) public unclaimedBonusBasesEquivalent;
160 
161     bool public useWeightedRates;
162     mapping(address => uint) public weightedTokenSystemTokenExchangeRates;
163 
164     uint public giveBonus;
165 
166     event BuySystemTokenForToken(address indexed token, uint tokenAmount, uint systemTokenAmount, uint swapTokenAmount, address indexed systemTokenRecipient);
167     event BuySystemTokenForBnb(uint bnbAmount, uint systemTokenAmount, address indexed systemTokenRecipient);
168     event ProcessSponsorBonus(address indexed sponsor, address indexed user, uint bonusAmount, uint indexed timestamp);
169     event AddUnclaimedSponsorBonus(address indexed user, uint systemTokenAmount, uint swapTokenAmount);
170 
171     event UpdateTokenSystemTokenWeightedExchangeRate(address indexed token, uint indexed newRate);
172     event ToggleUseWeightedRates(bool indexed useWeightedRates);
173     event Rescue(address indexed to, uint amount);
174     event RescueToken(address indexed token, address indexed to, uint amount);
175 
176     event AllowedTokenUpdated(address indexed token, bool allowance);
177     event SwapTokenUpdated(address indexed swapToken);
178     event SwapTokenAmountForBonusThresholdUpdated(uint indexed amount);
179 
180     event ProcessGiveBonus(address indexed to, uint amount, uint indexed timestamp);
181     event UpdateGiveBonus(uint indexed giveBonus);
182     event UpdateVestingContract(address indexed vestingContractAddress);
183     event UpdateVestingParams(uint vestingFirstPeriod, uint vestingSecondPeriod);
184     event ImportUserPurchases(address indexed user, uint amount, bool indexed isEquivalent, bool indexed addToExistent);
185 
186 
187     constructor (address systemToken, address vestingContractAddress, address router, address nbuWbnb) {
188         require(Address.isContract(systemToken), "systemToken is not a contract");
189         require(Address.isContract(vestingContractAddress), "vestingContractAddress is not a contract");
190         require(Address.isContract(router), "router is not a contract");
191         require(Address.isContract(nbuWbnb), "nbuWbnb is not a contract");
192         SYSTEM_TOKEN = IBEP20(systemToken);
193         vestingContract = INimbusVesting(vestingContractAddress);
194         NBU_WBNB = nbuWbnb;
195         sponsorBonus = 10;
196         giveBonus = 12;
197         swapRouter = INimbusRouter(router);
198         recipient = address(this);
199         vestingFirstPeriodDuration = 60 days;
200         vestingSecondPeriodDuration = 0;
201         allowAccuralMarketingReward = true;
202     }
203 
204     function buyExactSystemTokenForTokensAndRegister(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) external whenNotPaused {
205         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
206         require(userPurchasesEquivalent[referralProgram.userAddressById(sponsorId)] >= swapTokenAmountForBonusThreshold, "NimbusInitialAcquisition: Sponsor purchases amount is low");
207         referralProgramMarketing.registerUser(msg.sender, sponsorId);
208         buyExactSystemTokenForTokens(token, systemTokenAmount, systemTokenRecipient, stakingPoolId);
209     }
210 
211     function buyExactSystemTokenForTokensAndRegister(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) external whenNotPaused {
212         referralProgramMarketing.registerUser(msg.sender, 1000000001);
213         buyExactSystemTokenForTokens(token, systemTokenAmount, systemTokenRecipient, stakingPoolId);
214     }
215 
216     function buyExactSystemTokenForBnbAndRegister(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) payable external whenNotPaused {
217         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
218         require(userPurchasesEquivalent[referralProgram.userAddressById(sponsorId)] >= swapTokenAmountForBonusThreshold, "NimbusInitialAcquisition: Sponsor purchases amount is low");
219         referralProgramMarketing.registerUser(msg.sender, sponsorId);
220         buyExactSystemTokenForBnb(systemTokenAmount, systemTokenRecipient, stakingPoolId);
221     }
222 
223     function buyExactSystemTokenForBnbAndRegister(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) payable external whenNotPaused {
224         referralProgramMarketing.registerUser(msg.sender, 1000000001);
225         buyExactSystemTokenForBnb(systemTokenAmount, systemTokenRecipient, stakingPoolId);
226     }
227 
228     function buySystemTokenForExactBnbAndRegister(address systemTokenRecipient, uint stakingPoolId, uint sponsorId) payable external whenNotPaused {
229         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
230         require(userPurchasesEquivalent[referralProgram.userAddressById(sponsorId)] >= swapTokenAmountForBonusThreshold, "NimbusInitialAcquisition: Sponsor purchases amount is low");
231         referralProgramMarketing.registerUser(msg.sender, sponsorId);
232         buySystemTokenForExactBnb(systemTokenRecipient, stakingPoolId);
233     }
234 
235     function buySystemTokenForExactBnbAndRegister(address systemTokenRecipient, uint stakingPoolId) payable external whenNotPaused {
236         referralProgramMarketing.registerUser(msg.sender, 1000000001);
237         buySystemTokenForExactBnb(systemTokenRecipient, stakingPoolId);
238     }
239 
240     function buySystemTokenForExactTokensAndRegister(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId, uint sponsorId) external whenNotPaused {
241         require(sponsorId >= 1000000001, "NimbusInitialAcquisition: Sponsor id must be grater than 1000000000");
242         require(userPurchasesEquivalent[referralProgram.userAddressById(sponsorId)] >= swapTokenAmountForBonusThreshold, "NimbusInitialAcquisition: Sponsor purchases amount is low");
243         referralProgramMarketing.registerUser(msg.sender, sponsorId);
244         buySystemTokenForExactTokens(token, tokenAmount, systemTokenRecipient, stakingPoolId);
245     }
246 
247     function buySystemTokenForExactTokensAndRegister(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId) external whenNotPaused {
248         referralProgramMarketing.registerUser(msg.sender, 1000000001);
249         buySystemTokenForExactTokens(token, tokenAmount, systemTokenRecipient, stakingPoolId);
250     }
251     
252     function buyExactSystemTokenForTokens(address token, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) public whenNotPaused {
253         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
254         require(allowedTokens[token], "NimbusInitialAcquisition: Not allowed token");
255         require(referralProgram.userIdByAddress(msg.sender) > 0, "NimbusInitialAcquisition: Not part of referral program");
256         uint tokenAmount = getTokenAmountForSystemToken(token, systemTokenAmount);
257         TransferHelper.safeTransferFrom(token, msg.sender, recipient, tokenAmount);
258         _buySystemToken(token, tokenAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
259     }
260 
261     function buySystemTokenForExactTokens(address token, uint tokenAmount, address systemTokenRecipient, uint stakingPoolId) public whenNotPaused {
262         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
263         require(allowedTokens[token], "NimbusInitialAcquisition: Not allowed token");
264         require(referralProgram.userIdByAddress(msg.sender) > 0, "NimbusInitialAcquisition: Not part of referral program");
265         uint systemTokenAmount = getSystemTokenAmountForToken(token, tokenAmount);
266         TransferHelper.safeTransferFrom(token, msg.sender, recipient, tokenAmount);
267         _buySystemToken(token, tokenAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
268     }
269 
270     function buySystemTokenForExactBnb(address systemTokenRecipient, uint stakingPoolId) payable public whenNotPaused {
271         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
272         require(allowedTokens[NBU_WBNB], "NimbusInitialAcquisition: Not allowed purchase for BNB");
273         require(referralProgram.userIdByAddress(msg.sender) > 0, "NimbusInitialAcquisition: Not part of referral program");
274         uint systemTokenAmount = getSystemTokenAmountForBnb(msg.value);
275         INBU_WBNB(NBU_WBNB).deposit{value: msg.value}();
276         _buySystemToken(NBU_WBNB, msg.value, systemTokenAmount, systemTokenRecipient, stakingPoolId);
277     }
278 
279     function buyExactSystemTokenForBnb(uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) payable public whenNotPaused {
280         require(address(stakingPools[stakingPoolId]) != address(0), "NimbusInitialAcquisition: No staking pool with provided id");
281         require(allowedTokens[NBU_WBNB], "NimbusInitialAcquisition: Not allowed purchase for BNB");
282         require(referralProgram.userIdByAddress(msg.sender) > 0, "NimbusInitialAcquisition: Not part of referral program");
283         uint systemTokenAmountMax = getSystemTokenAmountForBnb(msg.value);
284         require(systemTokenAmountMax >= systemTokenAmount, "NimbusInitialAcquisition: Not enough BNB");
285         uint bnbAmount = systemTokenAmountMax == systemTokenAmount ? msg.value : getBnbAmountForSystemToken(systemTokenAmount);
286         INBU_WBNB(NBU_WBNB).deposit{value: bnbAmount}();
287         _buySystemToken(NBU_WBNB, bnbAmount, systemTokenAmount, systemTokenRecipient, stakingPoolId);
288         // refund dust bnb, if any
289         if (systemTokenAmountMax > systemTokenAmount) TransferHelper.safeTransferBNB(msg.sender, msg.value - bnbAmount);
290     }
291 
292     function claimSponsorBonusesBatch(address[] memory users) external { 
293         for (uint i; i < users.length; i++) {
294             claimSponsorBonuses(users[i]);
295         }
296     }
297 
298     function claimSponsorBonuses(address user) public {
299         require(unclaimedBonusBases[user] > 0, "NimbusInitialAcquisition: No unclaimed bonuses");
300         uint userSponsor = referralProgram.userSponsorByAddress(user);
301         require(userSponsor == referralProgram.userIdByAddress(msg.sender) && userSponsor != 0, "NimbusInitialAcquisition: Not user sponsor");
302         
303         uint minSwapTokenAmountForBonus = swapTokenAmountForBonusThreshold;
304         uint bonusBaseEquivalent = unclaimedBonusBasesEquivalent[user];
305         require (bonusBaseEquivalent >= minSwapTokenAmountForBonus, "NimbusInitialAcquisition: Bonus threshold not met");
306         require (userPurchasesEquivalent[msg.sender] >= minSwapTokenAmountForBonus, "NimbusInitialAcquisition: Sponsor balance threshold for bonus not met");
307 
308         uint sponsorBonusAmount = unclaimedBonusBases[user] * sponsorBonus / 100;
309         require(SYSTEM_TOKEN.transfer(msg.sender, sponsorBonusAmount), "NimbusInitialAcquisition: Transfer failed");
310         unclaimedBonusBases[user] = 0;
311         unclaimedBonusBasesEquivalent[user] = 0;
312         emit ProcessSponsorBonus(msg.sender, user, sponsorBonusAmount, block.timestamp);
313     }
314 
315 
316 
317     function availableInitialSupply() external view returns (uint) {
318         return SYSTEM_TOKEN.balanceOf(address(this));
319     }
320 
321     function getSystemTokenAmountForToken(address token, uint tokenAmount) public view returns (uint) { 
322         if (!useWeightedRates) {
323             address[] memory path = new address[](2);
324             path[0] = token;
325             path[1] = address(SYSTEM_TOKEN);
326             return swapRouter.getAmountsOut(tokenAmount, path)[1];
327         } else {
328             return tokenAmount * weightedTokenSystemTokenExchangeRates[token] / 1e18;
329         }  
330     }
331 
332     function getSystemTokenAmountForBnb(uint bnbAmount) public view returns (uint) { 
333         return getSystemTokenAmountForToken(NBU_WBNB, bnbAmount); 
334     }
335 
336     function getTokenAmountForSystemToken(address token, uint systemTokenAmount) public view returns (uint) { 
337         if (!useWeightedRates) { 
338             address[] memory path = new address[](2);
339             path[0] = token;
340             path[1] = address(SYSTEM_TOKEN);
341             return swapRouter.getAmountsIn(systemTokenAmount, path)[0];
342         } else {
343             return systemTokenAmount * 1e18 / weightedTokenSystemTokenExchangeRates[token];
344         }
345     }
346 
347     function getBnbAmountForSystemToken(uint systemTokenAmount) public view returns (uint) { 
348         return getTokenAmountForSystemToken(NBU_WBNB, systemTokenAmount);
349     }
350 
351     function currentBalance(address token) external view returns (uint) { 
352         return IBEP20(token).balanceOf(address(this));
353     }
354 
355     function estimateSponsorBonus(address user) external view returns (uint amount, address userSponsor) { 
356         if (unclaimedBonusBases[user] == 0) return (0, address(0));
357         userSponsor = referralProgram.userSponsorAddressByAddress(user);
358         if(userSponsor == address(0)) return (0, address(0));
359         
360         uint minSwapTokenAmountForBonus = swapTokenAmountForBonusThreshold;
361         uint bonusBaseEquivalent = unclaimedBonusBasesEquivalent[user];
362         if (bonusBaseEquivalent < minSwapTokenAmountForBonus) return (0, address(0));
363         if (userPurchasesEquivalent[userSponsor] < minSwapTokenAmountForBonus) return (0, address(0));
364 
365         amount = unclaimedBonusBases[user] * sponsorBonus / 100;
366     }
367 
368 
369 
370     function _buySystemToken(address token, uint tokenAmount, uint systemTokenAmount, address systemTokenRecipient, uint stakingPoolId) private {
371         stakingPools[stakingPoolId].stakeFor(systemTokenAmount, systemTokenRecipient);
372         userPurchases[systemTokenRecipient] += systemTokenAmount;
373         uint swapTokenAmount = getTokenAmountForSystemToken(swapToken, systemTokenAmount);
374         userPurchasesEquivalent[systemTokenRecipient] += swapTokenAmount;
375 
376         if(allowAccuralMarketingReward && address(referralProgramMarketing) != address(0)) {
377             referralProgramMarketing.updateReferralProfitAmount(systemTokenRecipient, systemTokenAmount);
378         }
379         emit BuySystemTokenForToken(token, tokenAmount, systemTokenAmount, swapTokenAmount, systemTokenRecipient);
380         if (giveBonus > 0) {
381             uint bonusGiveSystemToken = systemTokenAmount * giveBonus / 100;
382             vestingContract.vestWithVestType(systemTokenRecipient, bonusGiveSystemToken, vestingFirstPeriodDuration, vestingSecondPeriodDuration, 3); 
383             emit ProcessGiveBonus(systemTokenRecipient, bonusGiveSystemToken, block.timestamp);
384         }
385         _processSponsor(systemTokenRecipient, systemTokenAmount, swapTokenAmount);
386     }
387 
388     function _processSponsor(address systemTokenRecipient, uint systemTokenAmount, uint swapTokenAmount) private {
389         address sponsorAddress = getUserSponsorAddress(systemTokenRecipient);
390         if (sponsorAddress != address(0)) { 
391             uint minSwapTokenAmountForBonus = swapTokenAmountForBonusThreshold;
392             if (userPurchasesEquivalent[systemTokenRecipient] >= minSwapTokenAmountForBonus) {
393                 uint sponsorPurchases = userPurchasesEquivalent[sponsorAddress];
394                 
395                 if (sponsorPurchases >= minSwapTokenAmountForBonus) {
396                     uint bonusBase = systemTokenAmount + unclaimedBonusBases[systemTokenRecipient];
397                     uint sponsorBonusAmount = bonusBase * sponsorBonus / 100;
398                     require(SYSTEM_TOKEN.transfer(sponsorAddress, sponsorBonusAmount), "NimbusInitialAcquisition: Transfer failed");
399                     unclaimedBonusBases[systemTokenRecipient] = 0;
400                     unclaimedBonusBasesEquivalent[systemTokenRecipient] = 0;
401                     emit ProcessSponsorBonus(sponsorAddress, systemTokenRecipient, sponsorBonusAmount, block.timestamp);
402                 } else {
403                     unclaimedBonusBases[systemTokenRecipient] += systemTokenAmount;
404                     unclaimedBonusBasesEquivalent[systemTokenRecipient] += swapTokenAmount;
405                     emit AddUnclaimedSponsorBonus(systemTokenRecipient, systemTokenAmount, swapTokenAmount);
406                 }
407             } else {
408                 unclaimedBonusBases[systemTokenRecipient] += systemTokenAmount;
409                 unclaimedBonusBasesEquivalent[systemTokenRecipient] += swapTokenAmount;
410                 emit AddUnclaimedSponsorBonus(systemTokenRecipient, systemTokenAmount, swapTokenAmount);
411             }
412         } else {
413             unclaimedBonusBases[systemTokenRecipient] += systemTokenAmount;
414             emit AddUnclaimedSponsorBonus(systemTokenRecipient, systemTokenAmount, swapTokenAmount);
415         }
416     }
417 
418     function getUserSponsorAddress(address user) public view returns (address) {
419         if (address(referralProgram) == address(0)) {
420             return address(0);
421         } else {
422             return referralProgram.userSponsorAddressByAddress(user);
423         } 
424     }
425 
426     
427     
428 
429 
430     //Admin functions
431     function rescue(address payable to, uint256 amount) external onlyOwner {
432         require(to != address(0), "NimbusInitialAcquisition: Can't be zero address");
433         require(amount > 0, "NimbusInitialAcquisition: Should be greater than 0");
434         TransferHelper.safeTransferBNB(to, amount);
435         emit Rescue(to, amount);
436     }
437 
438     function rescue(address to, address token, uint256 amount) external onlyOwner {
439         require(to != address(0), "NimbusInitialAcquisition: Can't be zero address");
440         require(amount > 0, "NimbusInitialAcquisition: Should be greater than 0");
441         TransferHelper.safeTransfer(token, to, amount);
442         emit RescueToken(token, to, amount);
443     }
444 
445     function importUserPurchases(address user, uint amount, bool isEquivalent, bool addToExistent) external onlyOwner {
446         _importUserPurchases(user, amount, isEquivalent, addToExistent);
447     }
448 
449     function importUserPurchases(address[] memory users, uint[] memory amounts, bool isEquivalent, bool addToExistent) external onlyOwner {
450         require(users.length == amounts.length, "NimbusInitialAcquisition: Wrong lengths");
451 
452         for (uint256 i = 0; i < users.length; i++) {
453             _importUserPurchases(users[i], amounts[i], isEquivalent, addToExistent);
454         }
455     }
456 
457     function updateAccuralMarketingRewardAllowance(bool isAllowed) external onlyOwner {
458         allowAccuralMarketingReward = isAllowed;
459     }
460 
461     function updateStakingPool(uint id, address stakingPool) public onlyOwner {
462         _updateStakingPool(id, stakingPool);
463     }
464 
465     function updateStakingPool(uint[] memory ids, address[] memory _stakingPools) external onlyOwner {
466         require(ids.length == _stakingPools.length, "NimbusInitialAcquisition: Ids and staking pools arrays have different size.");
467         
468         for(uint i = 0; i < ids.length; i++) {
469             _updateStakingPool(ids[i], _stakingPools[i]);
470         }
471     }
472 
473     function updateAllowedTokens(address token, bool isAllowed) external onlyOwner {
474         require (token != address(0), "NimbusInitialAcquisition: Wrong addresses");
475         allowedTokens[token] = isAllowed;
476         emit AllowedTokenUpdated(token, isAllowed);
477     }
478     
479     function updateRecipient(address recipientAddress) external onlyOwner {
480         require(recipientAddress != address(0), "NimbusInitialAcquisition: Address is zero");
481         recipient = recipientAddress;
482     } 
483 
484     function updateSponsorBonus(uint bonus) external onlyOwner {
485         sponsorBonus = bonus;
486     }
487 
488     function updateReferralProgramContract(address newReferralProgramContract) external onlyOwner {
489         require(newReferralProgramContract != address(0), "NimbusInitialAcquisition: Address is zero");
490         referralProgram = INimbusReferralProgram(newReferralProgramContract);
491     }
492 
493     function updateReferralProgramMarketingContract(address newReferralProgramMarketingContract) external onlyOwner {
494         require(newReferralProgramMarketingContract != address(0), "NimbusInitialAcquisition: Address is zero");
495         referralProgramMarketing = INimbusReferralProgramMarketing(newReferralProgramMarketingContract);
496     }
497 
498     function updateSwapRouter(address newSwapRouter) external onlyOwner {
499         require(newSwapRouter != address(0), "NimbusInitialAcquisition: Address is zero");
500         swapRouter = INimbusRouter(newSwapRouter);
501     }
502 
503     function updateVestingContract(address vestingContractAddress) external onlyOwner {
504         require(Address.isContract(vestingContractAddress), "NimbusInitialAcquisition: VestingContractAddress is not a contract");
505         vestingContract = INimbusVesting(vestingContractAddress);
506         emit UpdateVestingContract(vestingContractAddress);
507     }
508 
509     function updateVestingParams(uint vestingFirstPeriod, uint vestingSecondPeriod) external onlyOwner {
510         require(vestingFirstPeriod != vestingFirstPeriodDuration && vestingSecondPeriodDuration != vestingSecondPeriod, "NimbusInitialAcquisition: Same params");
511         vestingFirstPeriodDuration = vestingFirstPeriod;
512         vestingSecondPeriodDuration = vestingSecondPeriod;
513         emit UpdateVestingParams(vestingFirstPeriod, vestingSecondPeriod);
514     }
515 
516     function updateSwapToken(address newSwapToken) external onlyOwner {
517         require(newSwapToken != address(0), "NimbusInitialAcquisition: Address is zero");
518         swapToken = newSwapToken;
519         emit SwapTokenUpdated(swapToken);
520     }
521 
522     function updateSwapTokenAmountForBonusThreshold(uint threshold) external onlyOwner {
523         swapTokenAmountForBonusThreshold = threshold;
524         emit SwapTokenAmountForBonusThresholdUpdated(swapTokenAmountForBonusThreshold);
525     }
526 
527     function updateTokenSystemTokenWeightedExchangeRate(address token, uint rate) external onlyOwner {
528         weightedTokenSystemTokenExchangeRates[token] = rate;
529         emit UpdateTokenSystemTokenWeightedExchangeRate(token, rate);
530     }
531 
532     function toggleUseWeightedRates() external onlyOwner {
533         useWeightedRates = !useWeightedRates;
534         emit ToggleUseWeightedRates(useWeightedRates);
535     }
536 
537     function _updateStakingPool(uint id, address stakingPool) private {
538         require(id != 0, "NimbusInitialAcquisition: Staking pool id cant be equal to 0.");
539         require(stakingPool != address(0), "NimbusInitialAcquisition: Staking pool address cant be equal to address(0).");
540 
541         stakingPools[id] = INimbusStakingPool(stakingPool);
542         require(SYSTEM_TOKEN.approve(stakingPool, type(uint256).max), "NimbusInitialAcquisition: Error on approving");
543     }
544 
545     function _importUserPurchases(address user, uint amount, bool isEquivalent, bool addToExistent) private {
546         require(user != address(0) && amount > 0, "NimbusInitialAcquisition: Zero values");
547         
548         if (isEquivalent) {
549             if (addToExistent) {
550                 userPurchasesEquivalent[user] += amount;
551             } else {
552                 userPurchasesEquivalent[user] = amount;
553             }    
554         } else {
555             if (addToExistent) {
556                 userPurchases[user] += amount;
557             } else {
558                 userPurchases[user] = amount;
559             }
560         }
561         emit ImportUserPurchases(user, amount, isEquivalent, addToExistent);
562     }
563 
564     function updateGiveBonus(uint bonus) external onlyOwner {
565         giveBonus = bonus;
566         emit UpdateGiveBonus(bonus);
567     }
568 
569 }
570 
571 library TransferHelper {
572     function safeApprove(address token, address to, uint value) internal {
573         // bytes4(keccak256(bytes('approve(address,uint256)')));
574         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
575         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
576     }
577 
578     function safeTransfer(address token, address to, uint value) internal {
579         // bytes4(keccak256(bytes('transfer(address,uint256)')));
580         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
581         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
582     }
583 
584     function safeTransferFrom(address token, address from, address to, uint value) internal {
585         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
586         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
587         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
588     }
589 
590     function safeTransferBNB(address to, uint value) internal {
591         (bool success,) = to.call{value:value}(new bytes(0));
592         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
593     }
594 }