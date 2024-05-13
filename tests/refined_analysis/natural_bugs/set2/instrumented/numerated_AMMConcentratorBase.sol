1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____ _____ _____ _____                     _           _           _____             
18 // |  _  |     |     |     |___ ___ ___ ___ ___| |_ ___ ___| |_ ___ ___| __  |___ ___ ___ 
19 // |     | | | | | | |   --| . |   |  _| -_|   |  _|  _| .'|  _| . |  _| __ -| .'|_ -| -_|
20 // |__|__|_|_|_|_|_|_|_____|___|_|_|___|___|_|_|_| |_| |__,|_| |___|_| |_____|__,|___|___|
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
25 import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
26 import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
27 import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";
28 
29 import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";
30 import {ERC4626, ERC20, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";
31 import {IConvexBasicRewards} from "src/shared/interfaces/IConvexBasicRewards.sol";
32 import {IConvexBooster} from "src/shared/interfaces/IConvexBooster.sol";
33 
34 abstract contract AMMConcentratorBase is ReentrancyGuard, ERC4626 {
35   
36     using FixedPointMathLib for uint256;
37     using SafeERC20 for IERC20;
38     using Address for address payable;
39 
40     struct Fees {
41         /// @notice The percentage of fee to pay for platform on harvest
42         uint256 platformFeePercentage;
43         /// @notice The percentage of fee to pay for caller on harvest
44         uint256 harvestBountyPercentage;
45         /// @notice The fee percentage to take on withdrawal. Fee stays in the vault, and is therefore distributed to vault participants. Used as a mechanism to protect against mercenary capital
46         uint256 withdrawFeePercentage;
47     }
48 
49     struct Booster {
50         /// @notice The pool ID in LP Booster contract
51         uint256 boosterPoolId;
52         /// @notice The address of LP Booster contract
53         address booster;
54         /// @notice The address of LP staking rewards contract
55         address crvRewards;
56         /// @notice The reward assets
57         address[] rewardAssets;
58     }
59 
60     struct Settings {
61         /// @notice The description of the vault
62         string description;
63         /// @notice The internal accounting of the deposit limit. Denominated in shares
64         uint256 depositCap;
65         /// @notice The address of the platform
66         address platform;
67         /// @notice The address of the FortressSwap contract
68         address swap;
69         /// @notice The address of the AMM Operations contract
70         address payable ammOperations;
71         /// @notice The address of the owner
72         address owner;
73         /// @notice The address of the vault we concentrate the rewards into
74         address compounder;
75         /// @notice Whether deposit for the pool is paused
76         bool pauseDeposit;
77         /// @notice Whether withdraw for the pool is paused
78         bool pauseWithdraw;
79         /// @notice Whether claim from vault is paused
80         bool pauseClaim;
81     }
82 
83     struct UserInfo {
84         /// @notice The amount of current accrued rewards
85         uint256 rewards;
86         /// @notice The reward per share already paid for the user, with 1e18 precision
87         uint256 rewardPerSharePaid;
88     }
89 
90     /// @notice The fees settings
91     Fees public fees;
92 
93     /// @notice The LP booster settings
94     Booster public boosterData;
95 
96     /// @notice The vault settings
97     Settings public settings;
98 
99     /// @notice The address of the contract that can specify an owner when calling the claim function 
100     address public multiClaimer;
101 
102     /// @notice Mapping from account address to user info
103     mapping(address => UserInfo) public userInfo;
104 
105     /// @notice The accumulated reward per share, with 1e18 precision
106     uint256 public accRewardPerShare;
107     /// @notice The last block number that the harvest function was executed
108     uint256 public lastHarvestBlock;
109     /// @notice The internal accounting of AUM
110     uint256 public totalAUM;
111 
112     /// @notice The precision
113     uint256 internal constant PRECISION = 1e18;
114     /// @notice The fee denominator
115     uint256 internal constant FEE_DENOMINATOR = 1e9;
116     /// @notice The maximum withdrawal fee
117     uint256 internal constant MAX_WITHDRAW_FEE = 1e8; // 10%
118     /// @notice The maximum platform fee
119     uint256 internal constant MAX_PLATFORM_FEE = 2e8; // 20%
120     /// @notice The maximum harvest fee
121     uint256 internal constant MAX_HARVEST_BOUNTY = 1e8; // 10%
122     /// @notice The address representing ETH
123     address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
124 
125     /// @notice The mapping of whitelisted feeless redeemers
126     mapping(address => bool) public feelessRedeemerWhitelist;
127 
128     /// @notice The list the pool's underlying assets
129     address[] public underlyingAssets;
130     
131     /********************************** Constructor **********************************/
132 
133     constructor(
134             ERC20 _asset,
135             string memory _name,
136             string memory _symbol,
137             bytes memory _settingsConfig,
138             bytes memory _boosterConfig,
139             address _compounder,
140             address[] memory _underlyingAssets
141         )
142         ERC4626(_asset, _name, _symbol) {
143 
144             {
145                 Fees storage _fees = fees;
146                 _fees.platformFeePercentage = 50000000; // 5%
147                 _fees.harvestBountyPercentage = 25000000; // 2.5%
148                 _fees.withdrawFeePercentage = 2000000; // 0.2%
149             }
150 
151             {
152                 Settings storage _settings = settings;
153 
154                 (_settings.description, _settings.owner, _settings.platform, _settings.swap, _settings.ammOperations)
155                 = abi.decode(_settingsConfig, (string, address, address, address, address));
156 
157                 _settings.compounder = _compounder;
158                 _settings.depositCap = 0;
159                 _settings.pauseDeposit = false;
160                 _settings.pauseWithdraw = false;
161                 _settings.pauseClaim = false;
162             }
163 
164             {
165                 Booster storage _boosterData = boosterData;
166 
167                 (_boosterData.boosterPoolId, _boosterData.booster, _boosterData.crvRewards, _boosterData.rewardAssets)
168                 = abi.decode(_boosterConfig, (uint256, address, address, address[]));
169 
170                 for (uint256 i = 0; i < _boosterData.rewardAssets.length; i++) {
171                     IERC20(_boosterData.rewardAssets[i]).safeApprove(settings.swap, type(uint256).max);
172                 }
173 
174                 IERC20(address(_asset)).safeApprove(_boosterData.booster, type(uint256).max);
175             }
176 
177             underlyingAssets = _underlyingAssets;
178     }
179 
180     /********************************** View Functions **********************************/
181 
182     /// @dev Return the amount of pending rewards for specific pool
183     /// @param _account - The address of user
184     /// @return - The amount of pending rewards
185     function pendingReward(address _account) public view returns (uint256) {
186         UserInfo memory _userInfo = userInfo[_account];
187         
188         return _userInfo.rewards + (((accRewardPerShare - _userInfo.rewardPerSharePaid) * balanceOf[_account]) / PRECISION);
189     }
190 
191     /// @dev Get the list of addresses of the vault's underlying assets (the assets that comprise the LP token, which is the vault primary asset)
192     /// @return - The underlying assets
193     function getUnderlyingAssets() external view returns (address[] memory) {
194         return underlyingAssets;
195     }
196 
197     /// @dev Get the name of the vault
198     /// @return - The name of the vault
199     function getName() external view returns (string memory) {
200         return name;
201     }
202 
203     /// @dev Get the symbol of the vault
204     /// @return - The symbol of the vault
205     function getSymbol() external view returns (string memory) {
206         return symbol;
207     }
208 
209     /// @dev Get the description of the vault
210     /// @return - The description of the vault
211     function getDescription() external view returns (string memory) {
212         return settings.description;
213     }
214 
215     /// @dev Indicates whether there are pending rewards to harvest
216     /// @return - True if there are pending rewards, false if otherwise
217     function isPendingRewards() external virtual view returns (bool) {
218         return IConvexBasicRewards(boosterData.crvRewards).earned(address(this)) > 0;
219     }
220 
221     /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
222     /// @param _shares - The amount of _shares to redeem
223     /// @return - The amount of _assets in return, after subtracting a withdrawal fee
224     function previewRedeem(uint256 _shares) public view override returns (uint256) {
225         // Calculate assets based on a user's % ownership of vault shares
226         uint256 assets = convertToAssets(_shares);
227 
228         uint256 _totalSupply = totalSupply;
229 
230         // Calculate a fee - zero if user is the last to withdraw
231         uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(fees.withdrawFeePercentage, FEE_DENOMINATOR);
232 
233         // Redeemable amount is the post-withdrawal-fee amount
234         return assets - _fee;
235     }
236 
237     /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
238     /// @param _assets - The amount of _assets to withdraw
239     /// @return - The amount of shares to burn, after subtracting a fee
240     function previewWithdraw(uint256 _assets) public view override returns (uint256) {
241         // Calculate shares based on the specified assets' proportion of the pool
242         uint256 _shares = convertToShares(_assets);
243 
244         uint256 _totalSupply = totalSupply;
245 
246         // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
247         return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - fees.withdrawFeePercentage);
248     }
249 
250     /// @dev Returns the total amount of the assets that are managed by the vault
251     /// @return - The total amount of managed assets
252     function totalAssets() public view override returns (uint256) {
253         return totalAUM;
254     }
255 
256     /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call
257     function maxDeposit(address) public view override returns (uint256) {
258         uint256 _assetCap = convertToAssets(settings.depositCap);
259         return _assetCap == 0 ? type(uint256).max : _assetCap - totalAUM;
260     }
261 
262     /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call
263     function maxMint(address) public view override returns (uint256) {
264         uint256 _depositCap = settings.depositCap;
265         return _depositCap == 0 ? type(uint256).max : _depositCap - totalSupply;
266     }
267 
268     /********************************** Mutated Functions **********************************/
269 
270     /// @dev Mints vault shares to _receiver by depositing exact amount of assets
271     /// @param _assets - The amount of assets to deposit
272     /// @param _receiver - The receiver of minted shares
273     /// @return _shares - The amount of shares minted
274     function deposit(uint256 _assets, address _receiver) external override nonReentrant returns (uint256 _shares) {
275         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
276 
277         _updateRewards(_receiver);
278 
279         _shares = previewDeposit(_assets);
280         _deposit(msg.sender, _receiver, _assets, _shares);
281 
282         _depositStrategy(_assets, true);
283         
284         return _shares;
285     }
286 
287     /// @dev Mints exact vault shares to _receiver by depositing assets
288     /// @param _shares - The amount of shares to mint
289     /// @param _receiver - The address of the receiver of shares
290     /// @return _assets - The amount of assets deposited
291     function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
292         if (_shares >= maxMint(msg.sender)) revert InsufficientDepositCap();
293 
294         _updateRewards(_receiver);
295 
296         _assets = previewMint(_shares);
297         _deposit(msg.sender, _receiver, _assets, _shares);
298 
299         _depositStrategy(_assets, true);
300         
301         return _assets;
302     }
303 
304     /// @dev Burns shares from owner and sends exact amount of assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
305     /// @param _assets - The amount of assets to receive
306     /// @param _receiver - The address of the receiver of assets
307     /// @param _owner - The owner of shares
308     /// @return _shares - The amount of shares burned
309     function withdraw(uint256 _assets, address _receiver, address _owner) external override nonReentrant returns (uint256 _shares) {
310         if (_assets > maxWithdraw(_owner)) revert InsufficientBalance();
311 
312         _updateRewards(_owner);
313 
314         // If the _owner is whitelisted, we can skip the preview and just convert the assets to shares
315         _shares = feelessRedeemerWhitelist[_owner] ? convertToShares(_assets) : previewWithdraw(_assets);
316 
317         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
318         
319         _withdrawStrategy(_assets, _receiver, true);
320 
321         return _shares;
322     }
323 
324     /// @dev Burns exact amount of shares from owner and sends assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
325     /// @param _shares - The amount of shares to burn
326     /// @param _receiver - The address of the receiver of assets
327     /// @param _owner - The owner of shares
328     /// @return _assets - The amount of assets sent to the _receiver
329     function redeem(uint256 _shares, address _receiver, address _owner) public override nonReentrant returns (uint256 _assets) {
330         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
331 
332         _updateRewards(_owner);
333 
334         // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
335         _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
336 
337         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
338         
339         _withdrawStrategy(_assets, _receiver, true);
340 
341         return _assets;
342     }
343 
344     /// @dev Mints vault shares to _receiver by depositing exact amount of underlying assets
345     /// @param _underlyingAsset - The address of underlying asset to deposit
346     /// @param _receiver - The receiver of minted shares
347     /// @param _underlyingAmount - The amount of underlying assets to deposit
348     /// @param _minAmount - The minimum amount of assets (LP tokens) to receive
349     /// @return _shares - The amount of shares minted
350     // slither-disable-next-line reentrancy-no-eth
351     function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external payable nonReentrant returns (uint256 _shares) {
352         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
353         if (!(_underlyingAmount > 0)) revert ZeroAmount();
354         
355         _updateRewards(msg.sender);
356 
357         if (msg.value > 0) {
358             if (msg.value != _underlyingAmount) revert InvalidAmount();
359             if (_underlyingAsset != ETH) revert InvalidAsset();
360         } else {
361             IERC20(_underlyingAsset).safeTransferFrom(msg.sender, address(this), _underlyingAmount);
362         }
363 
364         uint256 _assets = _swapFromUnderlying(_underlyingAsset, _underlyingAmount, _minAmount);
365         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
366         
367         _shares = previewDeposit(_assets);
368         _deposit(msg.sender, _receiver, _assets, _shares);
369         
370         _depositStrategy(_assets, false);
371         
372         return _shares;
373     }
374 
375     /// @notice that this function is vulnerable to a sandwich/frontrunning attacke if called without asserting the returned value
376     /// @notice If the _owner is whitelisted, no withdrawal fee is applied
377     /// @dev Burns exact shares from owner and sends assets of unwrapped underlying tokens to _receiver
378     /// @param _underlyingAsset - The address of underlying asset to redeem shares for
379     /// @param _receiver - The address of the receiver of underlying assets
380     /// @param _owner - The owner of _shares
381     /// @param _shares - The amount of shares to burn
382     /// @param _minAmount - The minimum amount of underlying assets to receive
383     /// @return _underlyingAmount - The amount of underlying assets sent to the _receiver
384     // slither-disable-next-line reentrancy-no-eth
385     function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) public nonReentrant returns (uint256 _underlyingAmount) {
386         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
387         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
388         
389         _updateRewards(msg.sender);
390 
391         uint256 _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
392         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
393 
394         _withdrawStrategy(_assets, _receiver, false);
395         
396         _underlyingAmount = _swapToUnderlying(_underlyingAsset, _assets, _minAmount);
397         
398         if (_underlyingAsset == ETH) {
399             payable(_receiver).sendValue(_underlyingAmount);
400         } else {
401             IERC20(_underlyingAsset).safeTransfer(_receiver, _underlyingAmount);
402         }
403 
404         return _underlyingAmount;
405     }
406 
407     /// @dev Claims all rewards for _owner and sends them to _receiver
408     /// @param _owner - The owner of rewards
409     /// @param _receiver - The recipient of rewards
410     /// @return _rewards - The amount of Compounder shares sent to the _receiver
411     function claim(address _owner, address _receiver) public nonReentrant returns (uint256 _rewards) {
412         if (settings.pauseClaim) revert ClaimPaused();
413         
414         if (msg.sender != multiClaimer) {
415             _owner = msg.sender;
416         }
417 
418         _updateRewards(_owner);
419 
420         UserInfo storage _userInfo = userInfo[_owner];
421         _rewards = _userInfo.rewards;
422         _userInfo.rewards = 0;
423 
424         _claim(_rewards, _receiver);
425 
426         return _rewards;
427     }
428 
429     /// @dev Redeem shares and claim rewards in a single transaction
430     /// @param _shares - The amount of shares to redeem
431     /// @param _receiver - The receiver of assets and rewards
432     /// @return _assets - The amount of assets sent to _receiver
433     /// @return _rewards - The amount of rewards sent to _receiver
434     // slither-disable-next-line reentrancy-eth
435     function redeemAndClaim(uint256 _shares, address _receiver) external returns (uint256 _assets, uint256 _rewards) {
436         _assets = redeem(_shares, _receiver, msg.sender);
437         _rewards = claim(address(0), _receiver);
438 
439         return (_assets, _rewards);
440     }
441 
442     /// @dev Redeem to an underlying asset and claim rewards in a single transaction
443     /// @param _underlyingAsset - The address of the underlying asset to redeem the shares to
444     /// @param _receiver - The receiver of underlying assets and rewards
445     /// @param _shares - The amount of shares to redeem
446     /// @param _minAmount - The minimum amount of underlying assets to receive
447     /// @return _underlyingAmount - The amount of underlying assets sent to _receiver
448     /// @return _rewards - The amount of rewards sent to _receiver
449     // slither-disable-next-line reentrancy-eth
450     function redeemUnderlyingAndClaim(address _underlyingAsset, address _receiver, uint256 _shares, uint256 _minAmount) external returns (uint256 _underlyingAmount, uint256 _rewards) {
451         _underlyingAmount = redeemUnderlying(_underlyingAsset, _receiver, msg.sender, _shares, _minAmount);
452         _rewards = claim(address(0), _receiver);
453 
454         return (_underlyingAmount, _rewards);
455     }
456 
457     /// @dev Harvests the pending rewards and converts to assets, then re-stakes the assets
458     /// @param _receiver - The address of receiver of harvest bounty
459     /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
460     /// @return _rewards - The amount of rewards that were deposited back into the vault, denominated in the vault asset
461     function harvest(address _receiver, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
462         if (block.number == lastHarvestBlock) revert HarvestAlreadyCalled();
463         lastHarvestBlock = block.number;
464 
465         _rewards = _harvest(_receiver, _minBounty);
466         accRewardPerShare = accRewardPerShare + ((_rewards * PRECISION) / totalSupply);
467         
468         return _rewards;
469     }
470 
471     /// @dev Adds updating of rewards to the original function
472     function transfer(address to, uint256 amount) public override returns (bool) {
473         _updateRewards(msg.sender);
474 
475         balanceOf[msg.sender] -= amount;
476 
477         // Cannot overflow because the sum of all user
478         // balances can't exceed the max uint256 value.
479         unchecked { balanceOf[to] += amount; }
480 
481         emit Transfer(msg.sender, to, amount);
482 
483         return true;
484     }
485 
486     /// @dev Adds updating of rewards to the original function
487     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
488         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
489 
490         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
491 
492         _updateRewards(from);
493 
494         balanceOf[from] -= amount;
495 
496         // Cannot overflow because the sum of all user
497         // balances can't exceed the max uint256 value.
498         unchecked { balanceOf[to] += amount; }
499 
500         emit Transfer(from, to, amount);
501 
502         return true;
503     }
504 
505     /********************************** Restricted Functions **********************************/
506 
507     /// @dev Updates the feelessRedeemerWhitelist
508     /// @param _address - The address to update
509     /// @param _whitelist - The new whitelist status
510     function updateFeelessRedeemerWhitelist(address _address, bool _whitelist) external {
511         if (msg.sender != settings.owner) revert Unauthorized();
512 
513         feelessRedeemerWhitelist[_address] = _whitelist;
514 
515         emit UpdateFeelessRedeemerWhitelist(_address, _whitelist);
516     }
517 
518     /// @dev Updates vault fees
519     /// @param _withdrawFeePercentage - The new withdrawal fee percentage
520     /// @param _platformFeePercentage - The new platform fee percentage
521     /// @param _harvestBountyPercentage - The new harvest bounty percentage
522     function updateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage) external {
523         if (msg.sender != settings.owner) revert Unauthorized();
524         if (_withdrawFeePercentage > MAX_WITHDRAW_FEE) revert InvalidAmount();
525         if (_platformFeePercentage > MAX_PLATFORM_FEE) revert InvalidAmount();
526         if (_harvestBountyPercentage > MAX_HARVEST_BOUNTY) revert InvalidAmount();
527 
528         Fees storage _fees = fees;
529         _fees.withdrawFeePercentage = _withdrawFeePercentage;
530         _fees.platformFeePercentage = _platformFeePercentage;
531         _fees.harvestBountyPercentage = _harvestBountyPercentage;
532 
533         emit UpdateFees(_withdrawFeePercentage, _platformFeePercentage, _harvestBountyPercentage);
534     }
535 
536     /// @dev updates the vault external utils
537     /// @param _booster - The new booster address
538     /// @param _crvRewards - The new crvRewards address
539     /// @param _boosterPoolId - The new booster pool id
540     function updateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId) external {
541         if (msg.sender != settings.owner) revert Unauthorized();
542 
543         Booster storage _boosterData = boosterData;
544         _boosterData.booster = _booster;
545         _boosterData.crvRewards = _crvRewards;
546         _boosterData.boosterPoolId = _boosterPoolId;
547 
548         _approve(address(asset), _boosterData.booster, type(uint256).max);
549 
550         emit UpdateBoosterData(_booster, _crvRewards, _boosterPoolId);
551     }
552 
553     /// @dev updates the reward assets
554     /// @param _rewardAssets - The new address list of reward assets
555     function updateRewardAssets(address[] memory _rewardAssets) external {
556         if (msg.sender != settings.owner) revert Unauthorized();
557 
558         boosterData.rewardAssets = _rewardAssets;
559 
560         for (uint256 i = 0; i < _rewardAssets.length; i++) {
561             _approve(_rewardAssets[i], settings.swap, type(uint256).max);
562         }
563 
564         emit UpdateRewardAssets(_rewardAssets);
565     }
566 
567     /// @dev updates the vault internal utils
568     /// @param _compounder - The new compounder address
569     /// @param _platform - The new platform address
570     /// @param _swap - The new swap address
571     /// @param _ammOperations - The new ammOperations address
572     /// @param _owner - The address of the new owner
573     /// @param _depositCap - The new deposit cap
574     /// @param _underlyingAssets - The new underlying assets
575     function updateSettings(address _compounder, address _platform, address _swap, address _ammOperations, address _owner, uint256 _depositCap, address[] memory _underlyingAssets) external {
576         Settings storage _settings = settings;
577 
578         if (msg.sender != _settings.owner) revert Unauthorized();
579 
580         _settings.compounder = _compounder;
581         _settings.platform = _platform;
582         _settings.swap = _swap;
583         _settings.ammOperations = payable(_ammOperations);
584         _settings.owner = _owner;
585         _settings.depositCap = _depositCap;
586 
587         underlyingAssets = _underlyingAssets;
588 
589         emit UpdateSettings(_compounder, _platform, _swap, _ammOperations, _owner, _depositCap, _underlyingAssets);
590     }
591 
592     function updateMultiClaimer(address _multiClaimer) external {
593         if (msg.sender != settings.owner) revert Unauthorized();
594 
595         multiClaimer = _multiClaimer;
596 
597         emit UpdateMultiClaimer(_multiClaimer);
598     }
599 
600     /// @dev Pauses deposits/withdrawals for the vault
601     /// @param _pauseDeposit - The new deposit status
602     /// @param _pauseWithdraw - The new withdraw status
603     /// @param _pauseWithdraw - The new claim status
604     function pauseInteractions(bool _pauseDeposit, bool _pauseWithdraw, bool _pauseClaim) external {
605         Settings storage _settings = settings;
606 
607         if (msg.sender != _settings.owner) revert Unauthorized();
608 
609         _settings.pauseDeposit = _pauseDeposit;
610         _settings.pauseWithdraw = _pauseWithdraw;
611         _settings.pauseClaim = _pauseClaim;
612 
613         emit PauseInteractions(_pauseDeposit, _pauseWithdraw, _pauseClaim);
614     }
615 
616     /********************************** Internal Functions **********************************/
617 
618     function _updateRewards(address _account) internal {
619         uint256 _rewards = pendingReward(_account);
620         UserInfo storage _userInfo = userInfo[_account];
621 
622         _userInfo.rewards = _rewards;
623         _userInfo.rewardPerSharePaid = accRewardPerShare;
624     }
625 
626     function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
627         if (settings.pauseDeposit) revert DepositPaused();
628         if (_receiver == address(0)) revert ZeroAddress();
629         if (!(_assets > 0)) revert ZeroAmount();
630         if (!(_shares > 0)) revert ZeroAmount();
631 
632         _mint(_receiver, _shares);
633         totalAUM += _assets;
634 
635         emit Deposit(_caller, _receiver, _assets, _shares);
636     }
637 
638     function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
639         if (settings.pauseWithdraw) revert WithdrawPaused();
640         if (_receiver == address(0)) revert ZeroAddress();
641         if (_owner == address(0)) revert ZeroAddress();
642         if (!(_shares > 0)) revert ZeroAmount();
643         if (!(_assets > 0)) revert ZeroAmount();
644         
645         if (_caller != _owner) {
646             uint256 _allowed = allowance[_owner][_caller];
647             if (_allowed < _shares) revert InsufficientAllowance();
648             if (_allowed != type(uint256).max) allowance[_owner][_caller] = _allowed - _shares;
649         }
650         
651         _burn(_owner, _shares);
652         totalAUM -= _assets;
653         
654         emit Withdraw(_caller, _receiver, _owner, _assets, _shares);
655     }
656 
657     function _depositStrategy(uint256 _assets, bool _transfer) internal virtual {
658         if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
659         Booster memory _boosterData = boosterData;
660         IConvexBooster(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets, true);
661     }
662 
663     function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal virtual {
664         IConvexBasicRewards(boosterData.crvRewards).withdrawAndUnwrap(_assets, false);
665         if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
666     }
667 
668     function _claim(uint256 _rewards, address _receiver) internal {
669         if (!(_rewards > 0)) revert ZeroAmount();
670 
671         IERC20(settings.compounder).safeTransfer(_receiver, _rewards);
672         
673         emit Claim(_receiver, _rewards);
674     }
675 
676     function _isUnderlyingAsset(address _asset) internal view returns (bool) {
677         address[] memory _underlyingAssets = underlyingAssets;
678 
679         for (uint256 i = 0; i < _underlyingAssets.length; i++) {
680             if (_underlyingAssets[i] == _asset) {
681                 return true;
682             }
683         }
684         return false;
685     }
686 
687     function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal virtual returns (uint256 _assets) {}
688 
689     function _swapToUnderlying(address _underlyingAsset, uint256 _amount, uint256 _minAmount) internal virtual returns (uint256) {}
690 
691     function _harvest(address _receiver, uint256 _minBounty) internal virtual returns (uint256) {}
692 
693     function _approve(address _token, address _spender, uint256 _amount) internal {
694         IERC20(_token).safeApprove(_spender, 0);
695         IERC20(_token).safeApprove(_spender, _amount);
696     }
697 
698     /********************************** Events **********************************/
699 
700     event Deposit(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
701     event Withdraw(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
702     event Harvest(address indexed _harvester, address indexed _receiver, uint256 _rewards, uint256 _platformFee);
703     event Claim(address indexed _receiver, uint256 _rewards);
704     event UpdateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage);
705     event UpdateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId);
706     event UpdateRewardAssets(address[] _rewardAssets);
707     event UpdateSettings(address compounder, address _platform, address _swap, address ammOperations, address _owner, uint256 _depositCap, address[] _underlyingAssets);
708     event UpdateFeelessRedeemerWhitelist(address _address, bool _whitelist);
709     event UpdateMultiClaimer(address _multiClaimer);
710     event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw, bool _pauseClaim);
711     
712     /********************************** Errors **********************************/
713 
714     error Unauthorized();
715     error NotUnderlyingAsset();
716     error DepositPaused();
717     error WithdrawPaused();
718     error ClaimPaused();
719     error ZeroAmount();
720     error ZeroAddress();
721     error InsufficientBalance();
722     error InsufficientAllowance();
723     error InsufficientDepositCap();
724     error NoPendingRewards();
725     error InvalidAmount();
726     error InvalidAsset();
727     error InsufficientAmountOut();
728     error FailedToSendETH();
729     error HarvestAlreadyCalled();
730 }