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
17 //  _____ _____ _____ _____                             _         _____             
18 // |  _  |     |     |     |___ _____ ___ ___ _ _ ___ _| |___ ___| __  |___ ___ ___ 
19 // |     | | | | | | |   --| . |     | . | . | | |   | . | -_|  _| __ -| .'|_ -| -_|
20 // |__|__|_|_|_|_|_|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_| |_____|__,|___|___|
21 //                                   |_|                                            
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
28 import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";
29 
30 import {ERC4626, ERC20, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";
31 import {IConvexBasicRewards} from "src/shared/interfaces/IConvexBasicRewards.sol";
32 import {IConvexBooster} from "src/shared/interfaces/IConvexBooster.sol";
33 import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";
34 
35 abstract contract AMMCompounderBase is ReentrancyGuard, ERC4626 {
36   
37     using FixedPointMathLib for uint256;
38     using SafeERC20 for IERC20;
39     using Address for address payable;
40 
41     struct Fees {
42         /// @notice The percentage of fee to pay for platform on harvest
43         uint256 platformFeePercentage;
44         /// @notice The percentage of fee to pay for caller on harvest
45         uint256 harvestBountyPercentage;
46         /// @notice The fee percentage to take on withdrawal. Fee stays in the vault, and is therefore distributed to vault participants. Used as a mechanism to protect against mercenary capital
47         uint256 withdrawFeePercentage;
48     }
49 
50     struct Booster {
51         /// @notice The pool ID in LP Booster contract
52         uint256 boosterPoolId;
53         /// @notice The address of LP Booster contract
54         address booster;
55         /// @notice The address of LP staking rewards contract
56         address crvRewards;
57         /// @notice The reward assets
58         address[] rewardAssets;
59     }
60 
61     struct Settings {
62         /// @notice The description of the vault
63         string description;
64         /// @notice The internal accounting of the deposit limit. Denominated in shares
65         uint256 depositCap;
66         /// @notice The address of the platform
67         address platform;
68         /// @notice The address of the FortressSwap contract
69         address swap;
70         /// @notice The address of the Fortress AMM Operations contract
71         address payable ammOperations;
72         /// @notice The address of the owner
73         address owner;
74         /// @notice Whether deposit for the pool is paused
75         bool pauseDeposit;
76         /// @notice Whether withdraw for the pool is paused
77         bool pauseWithdraw;
78     }
79 
80     /// @notice The fees settings
81     Fees public fees;
82 
83     /// @notice The LP booster settings
84     Booster public boosterData;
85 
86     /// @notice The vault settings
87     Settings public settings;
88 
89     /// @notice The internal accounting of AUM
90     uint256 internal totalAUM;
91     /// @notice The last block number that the harvest function was executed
92     uint256 public lastHarvestBlock;
93 
94     /// @notice The fee denominator
95     uint256 internal constant FEE_DENOMINATOR = 1e9;
96     /// @notice The maximum withdrawal fee
97     uint256 internal constant MAX_WITHDRAW_FEE = 1e8; // 10%
98     /// @notice The maximum platform fee
99     uint256 internal constant MAX_PLATFORM_FEE = 2e8; // 20%
100     /// @notice The maximum harvest fee
101     uint256 internal constant MAX_HARVEST_BOUNTY = 1e8; // 10%
102     /// @notice The address representing ETH
103     address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
104     
105     /// @notice The mapping of whitelisted feeless redeemers
106     mapping(address => bool) public feelessRedeemerWhitelist;
107 
108     /// @notice The underlying assets
109     address[] public underlyingAssets;
110 
111     /********************************** Constructor **********************************/
112 
113     constructor(
114             ERC20 _asset,
115             string memory _name,
116             string memory _symbol,
117             bytes memory _settingsConfig,
118             bytes memory _boosterConfig,
119             address[] memory _underlyingAssets
120         )
121         ERC4626(_asset, _name, _symbol) {
122             {
123                 Fees storage _fees = fees;
124                 _fees.platformFeePercentage = 50000000; // 5%
125                 _fees.harvestBountyPercentage = 25000000; // 2.5%
126                 _fees.withdrawFeePercentage = 2000000; // 0.2%
127             }
128 
129             {
130                 Settings storage _settings = settings;
131 
132                 (_settings.description, _settings.owner, _settings.platform, _settings.swap, _settings.ammOperations)
133                 = abi.decode(_settingsConfig, (string, address, address, address, address));
134                 
135                 _settings.depositCap = 0;
136                 _settings.pauseDeposit = false;
137                 _settings.pauseWithdraw = false;
138             }
139 
140             {
141                 Booster storage _boosterData = boosterData;
142 
143                 (_boosterData.boosterPoolId, _boosterData.booster, _boosterData.crvRewards, _boosterData.rewardAssets)
144                 = abi.decode(_boosterConfig, (uint256, address, address, address[]));
145 
146                 IERC20(address(_asset)).safeApprove(_boosterData.booster, type(uint256).max);
147 
148                 for (uint256 i = 0; i < _boosterData.rewardAssets.length; i++) {
149                     IERC20(_boosterData.rewardAssets[i]).safeApprove(settings.swap, type(uint256).max);
150                 }
151             }
152 
153             underlyingAssets = _underlyingAssets;
154     }
155 
156     /********************************** View Functions **********************************/
157 
158     /// @dev Get the list of addresses of the vault's underlying assets (the assets that comprise the LP token, which is the vault primary asset)
159     /// @return - The underlying assets
160     function getUnderlyingAssets() external view returns (address[] memory) {
161         return underlyingAssets;
162     }
163 
164     /// @dev Get the name of the vault
165     /// @return - The name of the vault
166     function getName() external view returns (string memory) {
167         return name;
168     }
169 
170     /// @dev Get the symbol of the vault
171     /// @return - The symbol of the vault
172     function getSymbol() external view returns (string memory) {
173         return symbol;
174     }
175 
176     /// @dev Get the description of the vault
177     /// @return - The description of the vault
178     function getDescription() external view returns (string memory) {
179         return settings.description;
180     }
181 
182     /// @dev Indicates whether there are pending rewards to harvest
183     /// @return - True if there are pending rewards, false if otherwise
184     function isPendingRewards() external virtual view returns (bool) {
185         return IConvexBasicRewards(boosterData.crvRewards).earned(address(this)) > 0;
186     }
187 
188     /// @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
189     /// @param _shares - The amount of shares to redeem
190     /// @return - The amount of assets in return, after subtracting a withdrawal fee
191     function previewRedeem(uint256 _shares) public view override returns (uint256) {
192         uint256 assets = convertToAssets(_shares);
193 
194         uint256 _totalSupply = totalSupply;
195 
196         // Calculate a fee - zero if user is the last to withdraw
197         uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(fees.withdrawFeePercentage, FEE_DENOMINATOR);
198 
199         // Redeemable amount is the post-withdrawal-fee amount
200         return assets - _fee;
201     }
202 
203     /// @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
204     /// @param _assets - The amount of assets to withdraw
205     /// @return - The amount of shares to burn, after subtracting a fee
206     function previewWithdraw(uint256 _assets) public view override returns (uint256) {
207         uint256 _shares = convertToShares(_assets);
208 
209         uint256 _totalSupply = totalSupply;
210 
211         // Factor in additional shares to fulfill withdrawal fee if user is not the last to withdraw
212         return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - fees.withdrawFeePercentage);
213     }
214 
215     /// @dev Returns the total AUM
216     /// @return - The total AUM
217     function totalAssets() public view override returns (uint256) {
218         return totalAUM;
219     }
220 
221     /// @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call
222     function maxDeposit(address) public view override returns (uint256) {
223         uint256 _assetCap = convertToAssets(settings.depositCap);
224         return _assetCap == 0 ? type(uint256).max : _assetCap - totalAUM;
225     }
226 
227     /// @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call
228     function maxMint(address) public view override returns (uint256) {
229         uint256 _depositCap = settings.depositCap;
230         return _depositCap == 0 ? type(uint256).max : _depositCap - totalSupply;
231     }
232 
233     /// @dev Checks if a specific asset is an underlying asset
234     /// @param _asset - The address of the asset to check
235     /// @return - Whether the assets is an underlying asset
236     function _isUnderlyingAsset(address _asset) internal view returns (bool) {
237         address[] memory _underlyingAssets = underlyingAssets;
238 
239         for (uint256 i = 0; i < _underlyingAssets.length; i++) {
240             if (_underlyingAssets[i] == _asset) {
241                 return true;
242             }
243         }
244         return false;
245     }
246 
247     /********************************** Mutated Functions **********************************/
248 
249     /// @dev Mints vault shares to _receiver by depositing exact amount of assets
250     /// @param _assets - The amount of assets to deposit
251     /// @param _receiver - The receiver of minted shares
252     /// @return _shares - The amount of shares minted
253     function deposit(uint256 _assets, address _receiver) external override nonReentrant returns (uint256 _shares) {
254         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
255 
256         _shares = previewDeposit(_assets);
257 
258         _deposit(msg.sender, _receiver, _assets, _shares);
259 
260         _depositStrategy(_assets, true);
261 
262         return _shares;
263     }
264 
265     /// @dev Mints exact vault shares to _receiver by depositing assets
266     /// @param _shares - The amount of shares to mint
267     /// @param _receiver - The address of the receiver of shares
268     /// @return _assets - The amount of assets deposited
269     function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
270         if (_shares >= maxMint(msg.sender)) revert InsufficientDepositCap();
271 
272         _assets = previewMint(_shares);
273         
274         _deposit(msg.sender, _receiver, _assets, _shares);
275 
276         _depositStrategy(_assets, true);
277 
278         return _assets;
279     }
280 
281     /// @dev Burns shares from owner and sends exact amount of assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
282     /// @param _assets - The amount of assets to receive
283     /// @param _receiver - The address of the receiver of assets
284     /// @param _owner - The owner of shares
285     /// @return _shares - The amount of shares burned
286     function withdraw(uint256 _assets, address _receiver, address _owner) external override nonReentrant returns (uint256 _shares) {
287         if (_assets > maxWithdraw(_owner)) revert InsufficientBalance();
288 
289         // If the _owner is whitelisted, we can skip the preview and just convert the assets to shares
290         _shares = feelessRedeemerWhitelist[_owner] ? convertToShares(_assets) : previewWithdraw(_assets);
291         
292         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
293         
294         _withdrawStrategy(_assets, _receiver, true);
295 
296         return _shares;
297     }
298 
299     /// @dev Burns exact amount of shares from owner and sends assets to _receiver. If the _owner is whitelisted, no withdrawal fee is applied
300     /// @param _shares - The amount of shares to burn
301     /// @param _receiver - The address of the receiver of assets
302     /// @param _owner - The owner of shares
303     /// @return _assets - The amount of assets sent to the _receiver
304     function redeem(uint256 _shares, address _receiver, address _owner) external override nonReentrant returns (uint256 _assets) {
305         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
306 
307         // If the _owner is whitelisted, we can skip the preview and just convert the shares to assets
308         _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
309         
310         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
311         
312         _withdrawStrategy(_assets, _receiver, true);
313 
314         return _assets;
315     }
316 
317     /// @dev Mints vault shares to _receiver by depositing exact amount of underlying assets
318     /// @param _underlyingAsset - The address of the underlying asset to deposit
319     /// @param _receiver - The receiver of minted shares
320     /// @param _underlyingAmount - The amount of underlying assets to deposit
321     /// @param _minAmount - The minimum amount of assets (LP tokens) to receive
322     /// @return _shares - The amount of shares minted
323     function depositUnderlying(address _underlyingAsset, address _receiver, uint256 _underlyingAmount, uint256 _minAmount) external payable nonReentrant returns (uint256 _shares) {
324         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
325         if (!(_underlyingAmount > 0)) revert ZeroAmount();
326         
327         if (msg.value > 0) {
328             if (msg.value != _underlyingAmount) revert InvalidAmount();
329             if (_underlyingAsset != ETH) revert InvalidAsset();
330         } else {
331             IERC20(_underlyingAsset).safeTransferFrom(msg.sender, address(this), _underlyingAmount);
332         }
333 
334         uint256 _assets = _swapFromUnderlying(_underlyingAsset, _underlyingAmount, _minAmount);
335         if (_assets >= maxDeposit(msg.sender)) revert InsufficientDepositCap();
336         
337         _shares = previewDeposit(_assets);
338         _deposit(msg.sender, _receiver, _assets, _shares);
339         
340         _depositStrategy(_assets, false);
341         
342         return _shares;
343     }
344 
345     /// @notice This function is vulnerable to a frontrunning attacke if called without asserting the returned value
346     /// @notice If the _owner is whitelisted, no withdrawal fee is applied
347     /// @dev Burns exact shares from owner and sends assets of unwrapped underlying tokens to _receiver
348     /// @param _underlyingAsset - The address of underlying asset to redeem shares for
349     /// @param _receiver - The address of the receiver of underlying assets
350     /// @param _owner - The owner of _shares
351     /// @param _shares - The amount of shares to burn
352     /// @param _minAmount - The minimum amount of underlying assets to receive
353     /// @return _underlyingAmount - The amount of underlying assets sent to the _receiver
354     function redeemUnderlying(address _underlyingAsset, address _receiver, address _owner, uint256 _shares, uint256 _minAmount) external nonReentrant returns (uint256 _underlyingAmount) {
355         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
356         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
357 
358         uint256 _assets = feelessRedeemerWhitelist[_owner] ? convertToAssets(_shares) : previewRedeem(_shares);
359         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
360 
361         _withdrawStrategy(_assets, _receiver, false);
362         
363         _underlyingAmount = _swapToUnderlying(_underlyingAsset, _assets, _minAmount);
364         
365         if (_underlyingAsset == ETH) {
366             payable(_receiver).sendValue(_underlyingAmount);
367         } else {
368             IERC20(_underlyingAsset).safeTransfer(_receiver, _underlyingAmount);
369         }
370 
371         return _underlyingAmount;
372     }
373 
374     /// @dev Harvests the pending rewards and converts to assets, then re-stakes the assets
375     /// @param _receiver - The address of receiver of harvest bounty
376     /// @param _underlyingAsset - The address of underlying asset to convert rewards to, will then be deposited in the pool in return for assets (LP tokens) 
377     /// @param _minBounty - The minimum amount of harvest bounty _receiver should get
378     /// @return _rewards - The amount of rewards that were deposited back into the vault, denominated in the vault asset
379     function harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) external nonReentrant returns (uint256 _rewards) {
380         if (!_isUnderlyingAsset(_underlyingAsset)) revert NotUnderlyingAsset();
381         if (lastHarvestBlock == block.number) revert HarvestAlreadyCalled();
382         lastHarvestBlock = block.number;
383         
384         _rewards = _harvest(_receiver, _underlyingAsset, _minBounty);
385         totalAUM += _rewards;
386 
387         return _rewards;
388     }
389 
390     /// @dev Adds emitting of YbTokenTransfer event to the original function
391     function transfer(address to, uint256 amount) public override returns (bool) {
392         balanceOf[msg.sender] -= amount;
393 
394         // Cannot overflow because the sum of all user
395         // balances can't exceed the max uint256 value.
396         unchecked {
397             balanceOf[to] += amount;
398         }
399 
400         emit Transfer(msg.sender, to, amount);
401         emit YbTokenTransfer(msg.sender, to, amount, convertToAssets(amount));
402         
403         return true;
404     }
405 
406     /// @dev Adds emitting of YbTokenTransfer event to the original function
407     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
408         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
409 
410         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
411 
412         balanceOf[from] -= amount;
413 
414         // Cannot overflow because the sum of all user
415         // balances can't exceed the max uint256 value.
416         unchecked {
417             balanceOf[to] += amount;
418         }
419 
420         emit Transfer(from, to, amount);
421         emit YbTokenTransfer(from, to, amount, convertToAssets(amount));
422 
423         return true;
424     }
425 
426     /********************************** Restricted Functions **********************************/
427 
428     /// @dev Updates the feelessRedeemerWhitelist
429     /// @param _address - The address to update
430     /// @param _whitelist - The new whitelist status
431     function updateFeelessRedeemerWhitelist(address _address, bool _whitelist) external {
432         if (msg.sender != settings.owner) revert Unauthorized();
433 
434         feelessRedeemerWhitelist[_address] = _whitelist;
435 
436         emit UpdateFeelessRedeemerWhitelist(_address, _whitelist);
437     }
438 
439     /// @dev Updates the vault fees
440     /// @param _withdrawFeePercentage - The new withdrawal fee percentage
441     /// @param _platformFeePercentage - The new platform fee percentage
442     /// @param _harvestBountyPercentage - The new harvest fee percentage
443     function updateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage) external {
444         if (msg.sender != settings.owner) revert Unauthorized();
445         if (_withdrawFeePercentage > MAX_WITHDRAW_FEE) revert InvalidAmount();
446         if (_platformFeePercentage > MAX_PLATFORM_FEE) revert InvalidAmount();
447         if (_harvestBountyPercentage > MAX_HARVEST_BOUNTY) revert InvalidAmount();
448 
449         Fees storage _fees = fees;
450         _fees.withdrawFeePercentage = _withdrawFeePercentage;
451         _fees.platformFeePercentage = _platformFeePercentage;
452         _fees.harvestBountyPercentage = _harvestBountyPercentage;
453 
454         emit UpdateFees(_withdrawFeePercentage, _platformFeePercentage, _harvestBountyPercentage);
455     }
456 
457     /// @dev updates the vault external utils
458     /// @param _booster - The new booster address
459     /// @param _crvRewards - The new crvRewards address
460     /// @param _boosterPoolId - The new booster pool id
461     function updateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId) external {
462         if (msg.sender != settings.owner) revert Unauthorized();
463 
464         Booster storage _boosterData = boosterData;
465         _boosterData.booster = _booster;
466         _boosterData.crvRewards = _crvRewards;
467         _boosterData.boosterPoolId = _boosterPoolId;
468 
469         _approve(address(asset), _boosterData.booster, type(uint256).max);
470 
471         emit UpdateBoosterData(_booster, _crvRewards, _boosterPoolId);
472     }
473 
474     /// @dev updates the reward assets
475     /// @param _rewardAssets - The new address list of reward assets
476     function updateRewardAssets(address[] memory _rewardAssets) external {
477         if (msg.sender != settings.owner) revert Unauthorized();
478 
479         boosterData.rewardAssets = _rewardAssets;
480 
481         for (uint256 i = 0; i < _rewardAssets.length; i++) {
482             _approve(_rewardAssets[i], settings.swap, type(uint256).max);
483         }
484 
485         emit UpdateRewardAssets(_rewardAssets);
486     }
487 
488     /// @dev updates the vault internal utils
489     /// @param _description - The new description
490     /// @param _platform - The new platform address
491     /// @param _swap - The new swap address
492     /// @param _ammOperations - The new ammOperations address
493     /// @param _owner - The address of the new owner
494     /// @param _depositCap - The new deposit cap
495     /// @param _underlyingAssets - The new address list of underlying assets
496     function updateSettings(string memory _description, address _platform, address _swap, address _ammOperations, address _owner, uint256 _depositCap, address[] memory _underlyingAssets) external {
497         Settings storage _settings = settings;
498 
499         if (msg.sender != _settings.owner) revert Unauthorized();
500 
501         _settings.description = _description;
502         _settings.platform = _platform;
503         _settings.swap = _swap;
504         _settings.ammOperations = payable(_ammOperations);
505         _settings.owner = _owner;
506         _settings.depositCap = _depositCap;
507 
508         underlyingAssets = _underlyingAssets;
509 
510         emit UpdateSettings(_platform, _swap, _ammOperations, _owner, _depositCap, _underlyingAssets);
511     }
512 
513     /// @dev Pauses deposits/withdrawals for the vault.
514     /// @param _pauseDeposit - The new deposit status.
515     /// @param _pauseWithdraw - The new withdraw status.
516     function pauseInteractions(bool _pauseDeposit, bool _pauseWithdraw) external {
517         Settings storage _settings = settings;
518 
519         if (msg.sender != _settings.owner) revert Unauthorized();
520 
521         _settings.pauseDeposit = _pauseDeposit;
522         _settings.pauseWithdraw = _pauseWithdraw;
523         
524         emit PauseInteractions(_pauseDeposit, _pauseWithdraw);
525     }
526 
527     /********************************** Internal Functions **********************************/
528 
529     function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
530         if (settings.pauseDeposit) revert DepositPaused();
531         if (_receiver == address(0)) revert ZeroAddress();
532         if (!(_assets > 0)) revert ZeroAmount();
533         if (!(_shares > 0)) revert ZeroAmount();
534 
535         _mint(_receiver, _shares);
536         totalAUM += _assets;
537 
538         emit Deposit(_caller, _receiver, _assets, _shares);
539     }
540 
541     function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
542         if (settings.pauseWithdraw) revert WithdrawPaused();
543         if (_receiver == address(0)) revert ZeroAddress();
544         if (_owner == address(0)) revert ZeroAddress();
545         if (!(_shares > 0)) revert ZeroAmount();
546         if (!(_assets > 0)) revert ZeroAmount();
547         
548         if (_caller != _owner) {
549             uint256 _allowed = allowance[_owner][_caller];
550             if (_allowed < _shares) revert InsufficientAllowance();
551             if (_allowed != type(uint256).max) allowance[_owner][_caller] = _allowed - _shares;
552         }
553         
554         _burn(_owner, _shares);
555         totalAUM -= _assets;
556 
557         emit Withdraw(_caller, _receiver, _owner, _assets, _shares);
558     }
559 
560     function _depositStrategy(uint256 _assets, bool _transfer) internal virtual {
561         if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
562         Booster memory _boosterData = boosterData;
563         IConvexBooster(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets, true);
564     }
565 
566     function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal virtual {
567         IConvexBasicRewards(boosterData.crvRewards).withdrawAndUnwrap(_assets, false);
568         if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
569     }
570 
571     function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal virtual returns (uint256 _assets) {}
572 
573     function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal virtual returns (uint256) {}
574 
575     function _harvest(address _receiver, address _underlyingAsset, uint256 _minimumOut) internal virtual returns (uint256) {}
576 
577     function _approve(address _token, address _spender, uint256 _amount) internal {
578         IERC20(_token).safeApprove(_spender, 0);
579         IERC20(_token).safeApprove(_spender, _amount);
580     }
581 
582     /********************************** Events **********************************/
583 
584     event Deposit(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
585     event Withdraw(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
586     event YbTokenTransfer(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
587     event Harvest(address indexed _harvester, address indexed _receiver, uint256 _rewards, uint256 _platformFee);
588     event UpdateFees(uint256 _withdrawFeePercentage, uint256 _platformFeePercentage, uint256 _harvestBountyPercentage);
589     event UpdateBoosterData(address _booster, address _crvRewards, uint256 _boosterPoolId);
590     event UpdateRewardAssets(address[] _rewardAssets);
591     event UpdateSettings(address _platform, address _swap, address _ammOperations, address _owner, uint256 _depositCap, address[] _underlyingAssets);
592     event UpdateFeelessRedeemerWhitelist(address _address, bool _whitelist);
593     event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);
594     
595     /********************************** Errors **********************************/
596 
597     error Unauthorized();
598     error NotUnderlyingAsset();
599     error DepositPaused();
600     error WithdrawPaused();
601     error InsufficientDepositCap();
602     error HarvestAlreadyCalled();
603     error ZeroAmount();
604     error ZeroAddress();
605     error InsufficientBalance();
606     error InsufficientAllowance();
607     error NoPendingRewards();
608     error InvalidAmount();
609     error InvalidAsset();
610     error InsufficientAmountOut();
611     error FailedToSendETH();
612     error NotWhitelisted();
613 }