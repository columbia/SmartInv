1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "../../interfaces/IOutputReceiver.sol";
7 import "../../interfaces/IOutputReceiverV2.sol";
8 import "../../interfaces/IOutputReceiverV3.sol";
9 import "../../interfaces/IRevest.sol";
10 import "../../interfaces/IAddressRegistry.sol";
11 import "../../interfaces/IRewardsHandler.sol";
12 import "../../interfaces/IFNFTHandler.sol";
13 import "../../interfaces/IAddressLock.sol";
14 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
15 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
16 import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
17 
18 contract Staking is Ownable, IOutputReceiverV3, ERC165, IAddressLock {
19     using SafeERC20 for IERC20;
20 
21     address private revestAddress;
22     address public lpAddress;
23     address public rewardsHandlerAddress;
24     address public addressRegistry;
25 
26     address public oldStakingContract;
27     uint public previousStakingIDCutoff;
28 
29     bool public additionalEnabled;
30 
31     uint private constant ONE_DAY = 86400;
32 
33     uint private constant WINDOW_ONE = ONE_DAY;
34     uint private constant WINDOW_THREE = ONE_DAY*5;
35     uint private constant WINDOW_SIX = ONE_DAY*9;
36     uint private constant WINDOW_TWELVE = ONE_DAY*14;
37     uint private constant MAX_INT = 2**256 - 1;
38 
39     // For tracking if a given contract has approval for token
40     mapping (address => mapping (address => bool)) private approvedContracts;
41 
42     address internal immutable WETH;
43 
44     uint[4] internal interestRates = [4, 13, 27, 56];
45     string public customMetadataUrl = "https://revest.mypinata.cloud/ipfs/QmdaJso83dhA5My9gz3ewXBxoWveo95utJJqY99ZSGEpRc";
46     string public addressMetadataUrl = "https://revest.mypinata.cloud/ipfs/QmWUyvkGFtFRXWxneojvAfBMy8QpewSvwQMQAkAUV42A91";
47 
48     event StakedRevest(uint indexed timePeriod, bool indexed isBasic, uint indexed amount, uint fnftId);
49 
50     struct StakingData {
51         uint timePeriod;
52         uint dateLockedFrom;
53         uint amount;
54     }
55 
56     // fnftId -> timePeriods
57     mapping(uint => StakingData) public stakingConfigs;
58 
59     constructor(
60         address revestAddress_,
61         address lpAddress_,
62         address rewardsHandlerAddress_,
63         address addressRegistry_,
64         address wrappedEth_
65     ) {
66         revestAddress = revestAddress_;
67         lpAddress = lpAddress_;
68         addressRegistry = addressRegistry_;
69         rewardsHandlerAddress = rewardsHandlerAddress_;
70         WETH = wrappedEth_;
71         previousStakingIDCutoff = IFNFTHandler(IAddressRegistry(addressRegistry).getRevestFNFT()).getNextId() - 1;
72 
73         address revest = address(getRevest());
74         IERC20(lpAddress).approve(revest, MAX_INT);
75         IERC20(revestAddress).approve(revest, MAX_INT);
76         approvedContracts[revest][lpAddress] = true;
77         approvedContracts[revest][revestAddress] = true;
78     }
79 
80     function supportsInterface(bytes4 interfaceId) public view override (ERC165, IERC165) returns (bool) {
81         return (
82             interfaceId == type(IOutputReceiver).interfaceId
83             || interfaceId == type(IAddressLock).interfaceId
84             || interfaceId == type(IOutputReceiverV2).interfaceId
85             || interfaceId == type(IOutputReceiverV3).interfaceId
86             || super.supportsInterface(interfaceId)
87         );
88     }
89 
90     function stakeBasicTokens(uint amount, uint monthsMaturity) public returns (uint) {
91         return _stake(revestAddress, amount, monthsMaturity);
92     }
93 
94     function stakeLPTokens(uint amount, uint monthsMaturity) public returns (uint) {
95         return _stake(lpAddress, amount, monthsMaturity);
96     }
97 
98     function claimRewards(uint fnftId) external {
99         // Check to make sure user owns the fnftId
100         require(IFNFTHandler(getRegistry().getRevestFNFT()).getBalance(_msgSender(), fnftId) == 1, 'E061');
101         // Receive rewards
102         IRewardsHandler(rewardsHandlerAddress).claimRewards(fnftId, _msgSender());
103     }
104 
105     ///
106     /// Address Lock Features
107     ///
108 
109     function updateLock(uint fnftId, uint, bytes memory) external override {
110         require(IFNFTHandler(getRegistry().getRevestFNFT()).getBalance(_msgSender(), fnftId) == 1, 'E061');
111         // Receive rewards
112         IRewardsHandler(rewardsHandlerAddress).claimRewards(fnftId, _msgSender());
113     }
114 
115     // This function not utilized
116     function createLock(uint, uint, bytes memory) external pure override {
117         return;
118     }
119 
120     ///
121     /// Output Recevier Functions
122     ///
123 
124     function receiveRevestOutput(
125         uint fnftId,
126         address asset,
127         address payable owner,
128         uint quantity
129     ) external override {
130         address vault = getRegistry().getTokenVault();
131         require(_msgSender() == vault, "E016");
132         require(quantity == 1, 'ONLY SINGULAR');
133         // Strictly limit access
134         require(fnftId <= previousStakingIDCutoff || stakingConfigs[fnftId].timePeriod > 0, 'Nonexistent!');
135 
136         uint totalQuantity = getValue(fnftId);
137         IRewardsHandler(rewardsHandlerAddress).claimRewards(fnftId, owner);
138         if (asset == revestAddress) {
139             IRewardsHandler(rewardsHandlerAddress).updateBasicShares(fnftId, 0);
140         } else if (asset == lpAddress) {
141             IRewardsHandler(rewardsHandlerAddress).updateLPShares(fnftId, 0);
142         } else {
143             require(false, "E072");
144         }
145         IERC20(asset).safeTransfer(owner, totalQuantity);
146         emit WithdrawERC20OutputReceiver(_msgSender(), asset, totalQuantity, fnftId, '');
147     }
148 
149     function handleTimelockExtensions(uint fnftId, uint expiration, address caller) external override {}
150 
151     function handleAdditionalDeposit(uint fnftId, uint amountToDeposit, uint quantity, address caller) external override {
152         require(_msgSender() == getRegistry().getRevest(), "E016");
153         require(quantity == 1);
154         require(additionalEnabled, 'Not allowed!');
155         _depositAdditionalToStake(fnftId, amountToDeposit, caller);
156     }
157 
158     function handleSplitOperation(uint fnftId, uint[] memory proportions, uint quantity, address caller) external override {}
159 
160     // Future proofing for secondary callbacks during withdrawal
161     // Could just use triggerOutputReceiverUpdate and call withdrawal function
162     // But deliberately using reentry is poor form and reminds me too much of OAuth 2.0 
163     function receiveSecondaryCallback(
164         uint fnftId,
165         address payable owner,
166         uint quantity,
167         IRevest.FNFTConfig memory config,
168         bytes memory args
169     ) external payable override {}
170 
171     // Allows for similar function to address lock, updating state while still locked
172     // Called by the user directly
173     function triggerOutputReceiverUpdate(
174         uint fnftId,
175         bytes memory args
176     ) external override {}
177 
178     // This function should only ever be called when a split or additional deposit has occurred 
179     function handleFNFTRemaps(uint, uint[] memory, address, bool) external pure override {
180         revert();
181     }
182 
183 
184     function _stake(address stakeToken, uint amount, uint monthsMaturity) private returns (uint){
185         require (stakeToken == lpAddress || stakeToken == revestAddress, "E079");
186         require(monthsMaturity == 1 || monthsMaturity == 3 || monthsMaturity == 6 || monthsMaturity == 12, 'E055');
187         IERC20(stakeToken).safeTransferFrom(msg.sender, address(this), amount);
188 
189         IRevest.FNFTConfig memory fnftConfig;
190         fnftConfig.asset = stakeToken;
191         fnftConfig.depositAmount = amount;
192         fnftConfig.isMulti = true;
193 
194         fnftConfig.pipeToContract = address(this);
195 
196         address[] memory recipients = new address[](1);
197         recipients[0] = _msgSender();
198 
199         uint[] memory quantities = new uint[](1);
200         quantities[0] = 1;
201 
202         address revest = getRegistry().getRevest();
203         if(!approvedContracts[revest][stakeToken]){
204             IERC20(stakeToken).approve(revest, MAX_INT);
205             approvedContracts[revest][stakeToken] = true;
206         }
207         uint fnftId = IRevest(revest).mintAddressLock(address(this), '', recipients, quantities, fnftConfig);
208 
209         uint interestRate = getInterestRate(monthsMaturity);
210         uint allocPoint = amount * interestRate;
211 
212         StakingData memory cfg = StakingData(monthsMaturity, block.timestamp, amount);
213         stakingConfigs[fnftId] = cfg;
214 
215         if(stakeToken == lpAddress) {
216             IRewardsHandler(rewardsHandlerAddress).updateLPShares(fnftId, allocPoint);
217         } else if (stakeToken == revestAddress) {
218             IRewardsHandler(rewardsHandlerAddress).updateBasicShares(fnftId, allocPoint);
219         }
220         
221         emit StakedRevest(monthsMaturity, stakeToken == revestAddress, amount, fnftId);
222         emit DepositERC20OutputReceiver(_msgSender(), stakeToken, amount, fnftId, '');
223         return fnftId;
224     }
225 
226     function _depositAdditionalToStake(uint fnftId, uint amount, address caller) private {
227         //Prevent unauthorized access
228         require(IFNFTHandler(getRegistry().getRevestFNFT()).getBalance(caller, fnftId) == 1, 'E061');
229         require(fnftId > previousStakingIDCutoff, 'E080');
230         uint time = stakingConfigs[fnftId].timePeriod;
231         require(time > 0, 'E078');
232         address asset = ITokenVault(getRegistry().getTokenVault()).getFNFT(fnftId).asset;
233         require(asset == revestAddress || asset == lpAddress, 'E079');
234 
235         //Claim rewards owed
236         IRewardsHandler(rewardsHandlerAddress).claimRewards(fnftId, _msgSender());
237 
238         //Write new, extended unlock date
239         stakingConfigs[fnftId].dateLockedFrom = block.timestamp;
240         stakingConfigs[fnftId].amount = stakingConfigs[fnftId].amount + amount;
241         //Retreive current allocation points – WETH and RVST implicitly have identical alloc points
242         uint oldAllocPoints = IRewardsHandler(rewardsHandlerAddress).getAllocPoint(fnftId, revestAddress, asset == revestAddress);
243         uint allocPoints = amount * getInterestRate(time) + oldAllocPoints;
244         if(asset == revestAddress) {
245             IRewardsHandler(rewardsHandlerAddress).updateBasicShares(fnftId, allocPoints);
246         } else if (asset == lpAddress) {
247             IRewardsHandler(rewardsHandlerAddress).updateLPShares(fnftId, allocPoints);
248         }
249         emit DepositERC20OutputReceiver(_msgSender(), asset, amount, fnftId, '');
250     }
251 
252 
253     ///
254     /// VIEW FUNCTIONS
255     ///
256 
257     /// Custom view function
258 
259     function getInterestRate(uint months) public view returns (uint) {
260         if (months <= 1) {
261             return interestRates[0];
262         } else if (months <= 3) {
263             return interestRates[1];
264         } else if (months <= 6) {
265             return interestRates[2];
266         } else {
267             return interestRates[3];
268         }
269     }
270 
271     function getRevest() private view returns (IRevest) {
272         return IRevest(getRegistry().getRevest());
273     }
274 
275     function getRegistry() public view returns (IAddressRegistry) {
276         return IAddressRegistry(addressRegistry);
277     }
278 
279     function getWindow(uint timePeriod) public pure returns (uint window) {
280         if(timePeriod == 1) {
281             window = WINDOW_ONE;
282         }
283         if(timePeriod == 3) {
284             window = WINDOW_THREE;
285         }
286         if(timePeriod == 6) {
287             window = WINDOW_SIX;
288         }
289         if(timePeriod == 12) {
290             window = WINDOW_TWELVE;
291         }
292     }
293 
294     /// ADDRESS REGISTRY VIEW FUNCTIONS
295 
296     /// Does the address lock need an update? 
297     function needsUpdate() external pure override returns (bool) {
298         return true;
299     }
300 
301     /// Get the metadata URL for an address lock
302     function getMetadata() external view override returns (string memory) {
303         return addressMetadataUrl;
304     }
305 
306     /// Can the stake be unlocked?
307     function isUnlockable(uint fnftId, uint) external view override returns (bool) {
308         if(fnftId <= previousStakingIDCutoff) {
309             return Staking(oldStakingContract).isUnlockable(fnftId, 0);
310         }
311         uint timePeriod = stakingConfigs[fnftId].timePeriod;
312         uint depositTime = stakingConfigs[fnftId].dateLockedFrom;
313 
314         uint window = getWindow(timePeriod);
315         bool mature = block.timestamp - depositTime > (timePeriod * 30 * ONE_DAY);
316         bool window_open = (block.timestamp - depositTime) % (timePeriod * 30 * ONE_DAY) < window;
317         return mature && window_open;
318     }
319 
320     // Retrieve encoded data on the state of the stake for the address lock component
321     function getDisplayValues(uint fnftId, uint) external view override returns (bytes memory) {
322         if(fnftId <= previousStakingIDCutoff) {
323             return IAddressLock(oldStakingContract).getDisplayValues(fnftId, 0);
324         }
325         uint allocPoints;
326         {
327             uint revestTokenAlloc = IRewardsHandler(rewardsHandlerAddress).getAllocPoint(fnftId, revestAddress, true);
328             uint lpTokenAlloc = IRewardsHandler(rewardsHandlerAddress).getAllocPoint(fnftId, revestAddress, false);
329             allocPoints = revestTokenAlloc > 0 ? revestTokenAlloc : lpTokenAlloc;
330         }
331         uint timePeriod = stakingConfigs[fnftId].timePeriod;
332         return abi.encode(allocPoints, timePeriod);
333     }
334 
335     /// OUTPUT RECEVIER VIEW FUNCTIONS
336 
337     function getCustomMetadata(uint fnftId) external view override returns (string memory) {
338         if(fnftId <= previousStakingIDCutoff) {
339             return Staking(oldStakingContract).getCustomMetadata(fnftId);
340         } else {
341             return customMetadataUrl;
342         }
343     }
344 
345     function getOutputDisplayValues(uint fnftId) external view override returns (bytes memory) {
346         if(fnftId <= previousStakingIDCutoff) {
347             return IOutputReceiver(oldStakingContract).getOutputDisplayValues(fnftId);
348         }
349         bool isRevestToken;
350         {
351             // Will be zero if this is an LP stake
352             uint revestTokenAlloc = IRewardsHandler(rewardsHandlerAddress).getAllocPoint(fnftId, revestAddress, true);
353             uint wethTokenAlloc = IRewardsHandler(rewardsHandlerAddress).getAllocPoint(fnftId, WETH, true);
354             isRevestToken = revestTokenAlloc > 0 || wethTokenAlloc > 0;
355         }
356         uint revestRewards = IRewardsHandler(rewardsHandlerAddress).getRewards(fnftId, revestAddress);
357         uint wethRewards = IRewardsHandler(rewardsHandlerAddress).getRewards(fnftId, WETH);
358         uint timePeriod = stakingConfigs[fnftId].timePeriod;
359         uint nextUnlock = block.timestamp + ((timePeriod * 30 days) - ((block.timestamp - stakingConfigs[fnftId].dateLockedFrom)  % (timePeriod * 30 days)));
360         //This parameter has been modified for new stakes
361         return abi.encode(revestRewards, wethRewards, timePeriod, stakingConfigs[fnftId].dateLockedFrom, isRevestToken ? revestAddress : lpAddress, nextUnlock);
362     }
363 
364     function getAddressRegistry() external view override returns (address) {
365         return addressRegistry;
366     }
367 
368     function getValue(uint fnftId) public view override returns (uint) {
369         if(fnftId <= previousStakingIDCutoff) {
370             return ITokenVault(getRegistry().getTokenVault()).getFNFT(fnftId).depositAmount;
371         } else {
372             return stakingConfigs[fnftId].amount;
373         }
374     }
375 
376     function getAsset(uint fnftId) external view override returns (address) {
377         return ITokenVault(getRegistry().getTokenVault()).getFNFT(fnftId).asset;
378     }
379 
380     ///
381     /// ADMIN FUNCTIONS
382     ///
383 
384     // Allows us to set a new output receiver metadata URL
385     function setCustomMetadata(string memory _customMetadataUrl) external onlyOwner {
386         customMetadataUrl = _customMetadataUrl;
387     }
388 
389     function setLPAddress(address lpAddress_) external onlyOwner {
390         lpAddress = lpAddress_;
391     }
392 
393     function setAddressRegistry(address addressRegistry_) external override onlyOwner {
394         addressRegistry = addressRegistry_;
395     }
396 
397     // Set a new metadata url for address lock
398     function setMetadata(string memory _addressMetadataUrl) external onlyOwner {
399         addressMetadataUrl = _addressMetadataUrl;
400     }
401 
402     // What contract will handle staking rewards
403     function setRewardsHandler(address _handler) external onlyOwner {
404         rewardsHandlerAddress = _handler;
405     }
406 
407     function setCutoff(uint cutoff) external onlyOwner {
408         previousStakingIDCutoff = cutoff;
409     }
410 
411     function setOldStaking(address stake) external onlyOwner {
412         oldStakingContract = stake;
413     }
414 
415     function setAdditionalDepositsEnabled(bool enabled) external onlyOwner {
416         additionalEnabled = enabled;
417     }
418 
419 }
