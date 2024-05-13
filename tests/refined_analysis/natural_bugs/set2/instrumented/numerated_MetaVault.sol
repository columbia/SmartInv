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
17 //  _____     _       _____         _ _   
18 // |     |___| |_ ___|  |  |___ _ _| | |_ 
19 // | | | | -_|  _| .'|  |  | .'| | | |  _|
20 // |_|_|_|___|_| |__,|\___/|__,|___|_|_|  
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
25 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
26 import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
27 
28 import {ERC20, ERC4626, FixedPointMathLib} from "src/shared/interfaces/ERC4626.sol";
29 import {AssetVault} from "./AssetVault.sol";
30 
31 import {IMetaVault} from "./interfaces/IMetaVault.sol";
32 import {IFortressSwap} from "./interfaces/IFortressSwap.sol";
33 
34 contract MetaVault is ReentrancyGuard, ERC4626, IMetaVault {
35 
36     using FixedPointMathLib for uint256;
37     using SafeERC20 for IERC20;
38 
39     /// @notice The current state of the vault
40     State public currentVaultState = State.INITIAL;
41 
42     // Vault owners
43     
44     /// @notice The platform address
45     address public platform;
46     /// @notice The vault manager address
47     address public manager;
48     
49     // Manager settings
50 
51     /// @notice The percentage of performance fee for Vault Manager
52     uint256 public managerPerformanceFee;
53     /// @notice The percentage of TVL that is the max performance fee. Used to disincentivize over risk taking
54     uint256 public performanceFeeLimit;
55     /// @notice The percentage of fee to keep in vault on withdraw (distrebuted among vault participants)
56     uint256 public vaultWithdrawFee;
57     /// @notice The percentage of TVL required in collateral by Vault Manager
58     uint256 public collateralRequirement;
59     /// @notice The block number that the Epoch is expected to end at
60     uint256 public epochEndBlock;
61     /// @notice Indicates whether to punish vault manager on not finishing an Epoch at the specified time
62     bool public isPenaltyEnabled;
63     /// @notice Indicates whether to charge a performance fee for Vault Manager
64     bool public isPerformanceFeeEnabled;
65     /// @notice Indicates whether to require collateral from the Vault Manager
66     bool public isCollateralRequired;
67 
68     // Platform settings
69 
70     /// @notice The Fortress swap contract address
71     address internal swap;
72     /// @notice The deposit limit, denominated in shares
73     uint256 public depositLimit;
74     /// @notice The percentage of managment fee to pay for platform
75     uint256 public platformManagementFee;
76     /// @notice The timelock period, in seconds
77     uint256 public timelockDuration;
78     /// @notice Whether deposit for the pool is paused
79     bool public isDepositPaused;
80     /// @notice Whether withdraw for the pool is paused
81     bool public isWithdrawPaused;
82     /// @notice Whether an epoch is initiated
83     bool public isEpochinitiated;
84     /// @notice Whether the vault is immutable
85     bool public isImmutable;
86     
87     // Accounting
88 
89     /// @notice The internal accounting of AUM
90     uint256 internal totalAUM;
91     /// @notice The snapshot of total shares supply from previous epoch
92     uint256 public snapshotSharesSupply;
93     /// @notice The snapshot of total asset supply from previous epoch
94     uint256 public snapshotAssetBalance;
95 
96     // Utility
97 
98     /// @notice The timestamp that the 'chargeManagementFee' function was last called
99     uint256 public lastManagementFeeTimestamp;
100     /// @notice The timestamp that the timelock has start.ed
101     uint256 public timelockStartTimestamp;
102     /// @notice Indicates whether the timelock has been initiated
103     bool public isTimelockInitiated;
104     /// @notice The fee denominator
105     uint256 internal constant FEE_DENOMINATOR = 1e9;
106 
107     /// @notice The mapping of addresses of assets to AssetVaults
108     /// @dev AssetVaults are standalone contracts that hold the assets and allow for the execution of Stratagies
109     mapping(address => address) public assetVaults;
110     /// @notice The mapping of blacklisted assets
111     mapping(address => bool) public blacklistedAssets;
112 
113     /// @notice The list of addresses of AssetVaults
114     address[] public assetVaultList;
115 
116     /********************************** Constructor **********************************/
117 
118     constructor(
119             ERC20 _asset,
120             string memory _name,
121             string memory _symbol,
122             address _platform,
123             address _manager,
124             address _swap
125         )
126         ERC4626(_asset, _name, _symbol) {
127         
128         // Vault owners
129         platform = _platform;
130         manager = _manager;
131 
132         // Manager settings
133         managerPerformanceFee = 5; // 20%
134         performanceFeeLimit = 5; // limit performance fee to 20% of TVL
135         vaultWithdrawFee = 2000000; // 0.2%
136         collateralRequirement = 200; // require manager to hold 0.5% of outstanding shares
137 
138         isPenaltyEnabled = true;
139         isPerformanceFeeEnabled = true;
140         isCollateralRequired = true;
141         
142         // Platform settings
143         swap = _swap;
144         platformManagementFee = 600; // 2% annually
145         depositLimit = 0;
146         timelockDuration = 86400; // 86400 seconds, 1 day
147 
148         isDepositPaused = false;
149         isWithdrawPaused = false;
150         isTimelockInitiated = false;
151         isEpochinitiated = false;
152 
153         lastManagementFeeTimestamp = block.timestamp;
154     }
155 
156     /********************************* Modifiers **********************************/
157 
158     modifier onlyPlatform() {
159         if (msg.sender != platform) revert Unauthorized();
160         _;
161     }
162 
163     /// @notice Platform has admin access
164     modifier onlyManager() {
165         if (msg.sender != manager && msg.sender != platform) revert Unauthorized();
166         _;
167     }
168 
169     modifier immutableVault() {
170         if (isImmutable) revert Immutable();
171         _;
172     }
173 
174     /********************************** View Functions **********************************/
175 
176     /// @inheritdoc ERC4626
177     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
178     function previewDeposit(uint256 _assets) public view override returns (uint256) {
179         if (currentVaultState != State.UNMANAGED) return 0;
180 
181         return convertToShares(_assets);
182     }
183 
184     /// @inheritdoc ERC4626
185     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
186     function previewMint(uint256 _shares) public view override returns (uint256) {
187         if (currentVaultState != State.UNMANAGED) return 0;
188 
189         return convertToAssets(_shares);
190     }
191 
192     /// @inheritdoc ERC4626
193     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
194     function previewRedeem(uint256 _shares) public view override returns (uint256) {
195         if (currentVaultState != State.UNMANAGED) return 0;
196 
197         uint256 assets = convertToAssets(_shares);
198 
199         uint256 _totalSupply = totalSupply;
200 
201         // Calculate a fee - zero if user is the last to withdraw
202         uint256 _fee = (_totalSupply == 0 || _totalSupply - _shares == 0) ? 0 : assets.mulDivDown(vaultWithdrawFee, FEE_DENOMINATOR);
203 
204         // Redeemable amount is the post-withdrawal-fee amount
205         return assets - _fee;
206     }
207 
208     /// @inheritdoc ERC4626
209     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
210     function previewWithdraw(uint256 _assets) public view override returns (uint256) {
211         if (currentVaultState != State.UNMANAGED) return 0;
212 
213         uint256 _shares = convertToShares(_assets);
214 
215         uint256 _totalSupply = totalSupply;
216 
217         // Factor in additional shares to fulfill withdrawal fee if user is not the last to withdraw
218         return (_totalSupply == 0 || _totalSupply - _shares == 0) ? _shares : (_shares * FEE_DENOMINATOR) / (FEE_DENOMINATOR - vaultWithdrawFee);
219     }
220 
221     /// @inheritdoc ERC4626
222     /// @notice May return an inaccurate response when 'state' is 'MANAGED' or 'INITIAL'
223     function totalAssets() public view override returns (uint256) {
224         return totalAUM;
225     }
226 
227     /// @inheritdoc ERC4626
228     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
229     function maxDeposit(address) public view override returns (uint256) {
230         if (currentVaultState != State.UNMANAGED) return 0;
231         
232         uint256 _depositLimitInAssets = convertToAssets(depositLimit);
233         uint256 _platformImposedLimit = _depositLimitInAssets == 0 ? type(uint256).max : _depositLimitInAssets - totalAUM;
234         
235         uint256 _collateralImposedLimit = msg.sender == manager ? type(uint256).max : convertToAssets(_getCollateralImposedLimit());
236         
237         return _platformImposedLimit < _collateralImposedLimit ? _platformImposedLimit : _collateralImposedLimit;
238     }
239 
240     /// @inheritdoc ERC4626
241     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
242     function maxMint(address) public view override returns (uint256) {
243         if (currentVaultState != State.UNMANAGED) return 0;
244         
245         uint256 _platformImposedLimit = depositLimit == 0 ? type(uint256).max : depositLimit - totalSupply;
246 
247         uint256 _collateralImposedLimit = msg.sender == manager ? type(uint256).max : _getCollateralImposedLimit();
248 
249         return _platformImposedLimit < _collateralImposedLimit ? _platformImposedLimit : _collateralImposedLimit;
250     }
251 
252     /// @inheritdoc ERC4626
253     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
254     function maxWithdraw(address owner) public view override returns (uint256) {
255         if (currentVaultState != State.UNMANAGED) return 0;
256 
257         return convertToAssets(balanceOf[owner]);
258     }
259 
260     /// @inheritdoc ERC4626
261     /// @notice Returns "0" if the Vault is not in an "UNMANAGED" state
262     function maxRedeem(address owner) public view override returns (uint256) {
263         if (currentVaultState != State.UNMANAGED) return 0;
264 
265         return balanceOf[owner];
266     }
267 
268     /// @inheritdoc IMetaVault
269     function isEpochOverdue() public view returns (bool) {
270         if (currentVaultState != State.MANAGED) return false;
271 
272         return block.number > epochEndBlock;
273     }
274 
275     /// @inheritdoc IMetaVault
276     function areAssetsBack() public view returns (bool) {
277         address[] memory _assetVaultList = assetVaultList;
278         for (uint256 i = 0; i < _assetVaultList.length; i++) {
279             if (AssetVault(_assetVaultList[i]).isActive()) return false;
280         }
281         return true;
282     }
283 
284     /// @inheritdoc IMetaVault
285     function getSwap() public view returns (address) {
286         return swap;
287     }
288 
289     /// @inheritdoc IMetaVault
290     function isUnmanaged() public view returns (bool) {
291         return currentVaultState == State.UNMANAGED;
292     }
293 
294     /// @inheritdoc IMetaVault
295     function getAssetVaultsLength() public view returns (uint256) {
296         return assetVaultList.length;
297     }
298 
299     /********************************** Investor Functions **********************************/
300 
301     /// @inheritdoc ERC4626
302     /// @notice Can only be called by anyone while "state" is "UNMANAGED"
303     function deposit(uint256 _assets, address _receiver) external override nonReentrant returns (uint256 _shares) {
304         if (_assets > maxDeposit(msg.sender)) revert DepositLimitExceeded();
305 
306         _shares = previewDeposit(_assets);
307 
308         _deposit(msg.sender, _receiver, _assets, _shares);
309 
310         IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
311 
312         return _shares;
313     }
314 
315     /// @inheritdoc ERC4626
316     /// @notice Can only be called by anyone while "state" is "UNMANAGED"
317     function mint(uint256 _shares, address _receiver) external override nonReentrant returns (uint256 _assets) {
318         if (_shares > maxMint(msg.sender)) revert DepositLimitExceeded();
319 
320         _assets = previewMint(_shares);
321         
322         _deposit(msg.sender, _receiver, _assets, _shares);
323 
324         IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
325 
326         return _assets;
327     }
328 
329     /// @inheritdoc ERC4626
330     /// @notice Can only be called by anyone while "state" is "UNMANAGED"
331     function withdraw(uint256 _assets, address _receiver, address _owner) external override nonReentrant returns (uint256 _shares) {
332         if (_assets > maxWithdraw(_owner)) revert InsufficientBalance();
333 
334         _shares = previewWithdraw(_assets);
335         
336         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
337 
338         IERC20(address(asset)).safeTransfer(_receiver, _assets);
339 
340         return _shares;
341     }
342 
343     /// @inheritdoc ERC4626
344     /// @notice Can only be called by anyone while "state" is "UNMANAGED"
345     function redeem(uint256 _shares, address _receiver, address _owner) external override nonReentrant returns (uint256 _assets) {
346         if (_shares > maxRedeem(_owner)) revert InsufficientBalance();
347 
348         _assets = previewRedeem(_shares);
349         
350         _withdraw(msg.sender, _receiver, _owner, _assets, _shares);
351 
352         IERC20(address(asset)).safeTransfer(_receiver, _assets);
353 
354         return _assets;
355     }
356 
357     /// @inheritdoc IMetaVault
358     function executeLatenessPenalty() external nonReentrant {
359         if (isPenaltyEnabled == false) revert LatenessNotPenalized();
360         if (!isEpochOverdue()) revert EpochNotCompleted();
361         
362         _onState(State.MANAGED);
363 
364         uint256 _burnAmount = balanceOf[address(this)] / 2;
365         if (isCollateralRequired) {
366             _burn(address(this), _burnAmount);
367         }
368 
369         isPerformanceFeeEnabled = false;
370         
371         emit LatenessPenalty(block.timestamp, _burnAmount);
372     }
373 
374     /********************************** Manager Functions **********************************/
375 
376     /// @inheritdoc IMetaVault
377     function initiateVault(bytes memory _configData) external onlyManager {
378         _onState(State.INITIAL);
379 
380         currentVaultState = State.UNMANAGED;
381 
382         emit EpochCompleted(block.timestamp, block.number, 0, 0);
383 
384         initiateEpoch(_configData);
385     }
386 
387     /// @inheritdoc IMetaVault
388     function initiateEpoch(bytes memory _configData) public onlyManager nonReentrant {
389         if (isEpochinitiated == true) revert EpochAlreadyInitiated();
390 
391         _onState(State.UNMANAGED);
392 
393         if (isImmutable) {
394             (epochEndBlock) = abi.decode(_configData, (uint256));
395         } else {
396             (epochEndBlock, isPenaltyEnabled, isPerformanceFeeEnabled, isCollateralRequired)
397                 = abi.decode(_configData, (uint256, bool, bool, bool));
398         }
399 
400         if (epochEndBlock <= block.number) revert EpochEndBlockInvalid();
401 
402         timelockStartTimestamp = block.timestamp;
403         isTimelockInitiated = true;
404         isEpochinitiated = true;
405         
406         emit EpochInitiated(block.timestamp, _configData);
407     }
408 
409     /// @inheritdoc IMetaVault
410     function startEpoch() external onlyManager nonReentrant {
411         if (isTimelockInitiated == false) revert NotTimelocked();
412         if (timelockStartTimestamp + timelockDuration > block.timestamp) revert TimelockNotExpired();
413         if (isCollateralRequired && balanceOf[address(this)] < totalSupply / collateralRequirement) revert InsufficientCollateral();
414         
415         _onState(State.UNMANAGED);
416 
417         _beforeEpochStart();
418 
419         currentVaultState = State.MANAGED;
420 
421         emit EpochStarted(block.timestamp, snapshotAssetBalance, snapshotSharesSupply);
422 
423         _afterEpochStart();
424     }
425 
426     /// @inheritdoc IMetaVault
427     function endEpoch() external onlyManager nonReentrant {
428         _onState(State.MANAGED);
429 
430         _beforeEpochEnd();
431 
432         currentVaultState = State.UNMANAGED;
433 
434         emit EpochCompleted(block.timestamp, block.number, snapshotAssetBalance, snapshotSharesSupply);
435 
436         _afterEpochEnd();
437     }
438 
439     /// @inheritdoc IMetaVault
440     function addAssetVault(address _targetAsset) external onlyManager nonReentrant immutableVault returns (address _assetVault) {
441         if (address(asset) != _targetAsset) {
442             if (!IFortressSwap(swap).routeExists(address(asset), _targetAsset)) revert InvalidSwapRoute();
443             if (!IFortressSwap(swap).routeExists(_targetAsset, address(asset))) revert InvalidSwapRoute();
444         }
445         if (blacklistedAssets[_targetAsset]) revert BlacklistedAsset();
446         
447         _onState(State.UNMANAGED);
448 
449         _assetVault = address(new AssetVault(_targetAsset, address(this), address(asset), platform, manager));
450         
451         assetVaults[_targetAsset] = _assetVault;
452         assetVaultList.push(_assetVault);
453 
454         emit AssetVaultAdded(_assetVault, _targetAsset);
455 
456         return _assetVault;
457     }
458 
459     /// @inheritdoc IMetaVault
460     function depositAsset(address _asset, uint256 _amount, uint256 _minAmount) external onlyManager nonReentrant returns (uint256) {
461         if (blacklistedAssets[_asset]) revert BlacklistedAsset();
462         
463         _onState(State.MANAGED);
464 
465         address _assetVault = assetVaults[_asset];
466         if (_assetVault == address(0)) revert AssetVaultNotAvailable();
467 
468         _approve(address(asset), _assetVault, _amount);
469         _amount = AssetVault(_assetVault).deposit(_amount);
470         if (_amount < _minAmount) revert InsufficientAmountOut();
471 
472         emit AssetDeposited(_assetVault, _asset, _amount);
473 
474         return _amount;
475     }
476 
477     /// @inheritdoc IMetaVault
478     function withdrawAsset(address _asset, uint256 _amount, uint256 _minAmount) external onlyManager nonReentrant returns (uint256) {
479         _onState(State.MANAGED);
480 
481         address _assetVault = assetVaults[_asset];
482         if (_assetVault == address(0)) revert AssetVaultNotAvailable();
483 
484         _amount = AssetVault(_assetVault).withdraw(_amount);
485         if (_amount < _minAmount) revert InsufficientAmountOut();
486 
487         emit AssetWithdrawn(_assetVault, _asset, _amount);
488 
489         return _amount;
490     }
491 
492     // @inheritdoc IMetaVault
493     /// @notice Vault Manager can add collateral by calling the "deposit" or "mint" functions with "_receiver" as "address(this)"
494     function removeCollateral(uint256 _shares) external onlyManager nonReentrant returns (uint256 _assets) {
495         if (_shares > maxRedeem(address(this))) revert InsufficientBalance();
496         
497         _onState(State.UNMANAGED);
498 
499         _assets = previewRedeem(_shares);
500         
501         address _receiver = manager;
502         _withdraw(address(this), _receiver, address(this), _assets, _shares);
503 
504         IERC20(address(asset)).safeTransfer(_receiver, _assets);
505 
506         return _assets;
507     }
508 
509     /// @inheritdoc IMetaVault
510     function updateManager(address _manager) external onlyManager {
511         _onState(State.UNMANAGED);
512 
513         manager = _manager;
514 
515         emit ManagerUpdated(_manager);
516     }
517 
518     /// @inheritdoc IMetaVault
519     function updateManagerSettings(uint256 _managerPerformanceFee, uint256 _vaultWithdrawFee, uint256 _collateralRequirement, uint256 _performanceFeeLimit) external onlyManager immutableVault {
520         if (_managerPerformanceFee < 4) revert ManagerPerformanceFeeInvalid();
521         if (_collateralRequirement < 0) revert CollateralRequirementInvalid();
522         if (_performanceFeeLimit < 0) revert PerformanceFeeLimitInvalid();
523         if (_vaultWithdrawFee < 0 || _vaultWithdrawFee > 10000000) revert VaultWithdrawFeeInvalid();
524 
525         _onState(State.UNMANAGED);
526 
527         managerPerformanceFee = _managerPerformanceFee;
528         vaultWithdrawFee = _vaultWithdrawFee;
529         collateralRequirement = _collateralRequirement;
530         performanceFeeLimit = _performanceFeeLimit;
531 
532         emit ManagerSettingsUpdated(_managerPerformanceFee, _vaultWithdrawFee, _collateralRequirement, _performanceFeeLimit);
533     }
534 
535     /// @inheritdoc IMetaVault
536     function makeImmutable() external onlyManager {
537         _onState(State.UNMANAGED);
538 
539         isImmutable = true;
540 
541         emit VaultImmutable();
542     }
543     
544     /********************************** Platform Functions **********************************/
545 
546     /// @inheritdoc IMetaVault
547     function chargeManagementFee() external onlyPlatform {
548         if (block.timestamp < lastManagementFeeTimestamp + 30 days) revert ManagementFeeNotDue();
549 
550         // mint management fee shares to platform
551         // 1 / 600 = 2 / (100 * 12) --> (set 'platformManagementFee' to '600' to charge 2% annually)
552         uint256 _feeAmount = totalSupply / platformManagementFee;
553         _mint(platform, _feeAmount);
554 
555         lastManagementFeeTimestamp = block.timestamp;
556 
557         emit ManagementFeeCharged(block.timestamp, _feeAmount);
558     }
559 
560     /// @inheritdoc IMetaVault
561     function updateManagementFees(uint256 _platformManagementFee) external onlyPlatform immutableVault {
562         if (_platformManagementFee < 240) revert platformManagementFeeInvalid();
563 
564         _onState(State.UNMANAGED);
565 
566         platformManagementFee = _platformManagementFee;
567 
568         emit ManagementFeeUpdated(_platformManagementFee);
569     }
570 
571     /// @inheritdoc IMetaVault
572     function updatePauseInteractions(bool _isDepositPaused, bool _isWithdrawPaused) external onlyPlatform immutableVault {
573         isDepositPaused = _isDepositPaused;
574         isWithdrawPaused = _isWithdrawPaused;
575 
576         emit PauseInteractionsUpdated(_isDepositPaused, _isWithdrawPaused);
577     }
578 
579     /// @inheritdoc IMetaVault
580     function updatePlatformSettings(State _currentVaultState, address _swap, uint256 _depositLimit, uint256 _timelockDuration) external onlyPlatform immutableVault {
581         if (_depositLimit <= totalSupply) revert DepositLimitExceeded();
582         
583         _onState(State.UNMANAGED);
584 
585         currentVaultState = _currentVaultState;
586         swap = _swap;
587         depositLimit = _depositLimit;
588         timelockDuration = _timelockDuration;
589 
590         emit SettingsUpdated(_currentVaultState, _swap, _depositLimit, _timelockDuration);
591     }
592 
593     /// @inheritdoc IMetaVault
594     function blacklistAsset(address _asset) external onlyPlatform immutableVault {
595         _onState(State.UNMANAGED);
596 
597         blacklistedAssets[_asset] = true;
598 
599         emit AssetBlacklisted(_asset);
600     }
601 
602     /********************************** Internal Functions **********************************/
603 
604     function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal override {
605         _onState(State.UNMANAGED);
606 
607         if (isDepositPaused) revert DepositPaused();
608         if (_receiver == address(0)) revert ZeroAddress();
609         if (!(_assets > 0)) revert ZeroAmount();
610         if (!(_shares > 0)) revert ZeroAmount();
611 
612         _mint(_receiver, _shares);
613         totalAUM += _assets;
614 
615         emit Deposited(_caller, _receiver, _assets, _shares);
616     }
617 
618     function _withdraw(address _caller, address _receiver, address _owner, uint256 _assets, uint256 _shares) internal override {
619         _onState(State.UNMANAGED);
620 
621         if (isWithdrawPaused) revert WithdrawPaused();
622         if (_receiver == address(0)) revert ZeroAddress();
623         if (_owner == address(0)) revert ZeroAddress();
624         if (!(_shares > 0)) revert ZeroAmount();
625         if (!(_assets > 0)) revert ZeroAmount();
626         
627         if (_caller != _owner) {
628             uint256 _allowed = allowance[_owner][_caller];
629             if (_allowed < _shares) revert InsufficientAllowance();
630             if (_allowed != type(uint256).max) allowance[_owner][_caller] = _allowed - _shares;
631         }
632         
633         _burn(_owner, _shares);
634         totalAUM -= _assets;
635 
636         emit Withdrawn(_caller, _receiver, _owner, _assets, _shares);
637     }
638 
639     function _beforeEpochStart() internal virtual {
640         _executeSnapshot();
641     }
642 
643     function _afterEpochStart() internal virtual {
644         isTimelockInitiated = false;
645     }
646 
647     function _beforeEpochEnd() internal virtual {
648         if(!areAssetsBack()) revert AssetsNotBack();
649 
650         _chargeFees();
651 
652         totalAUM = asset.balanceOf(address(this));
653 
654         _executeSnapshot();
655     }
656 
657     function _afterEpochEnd() internal virtual {
658         isEpochinitiated = false;
659         epochEndBlock = 0;
660     }
661 
662     function _executeSnapshot() internal virtual {
663         snapshotSharesSupply = totalSupply;
664         snapshotAssetBalance = totalAssets();
665 
666         emit Snapshot(block.timestamp, block.number, snapshotAssetBalance, snapshotSharesSupply);
667     }
668 
669     function _chargeFees() internal virtual {
670         uint256 _managerFee;
671         uint256 _snapshotAssetBalance = snapshotAssetBalance;
672         address _asset = address(asset);
673         uint256 _balance = IERC20(_asset).balanceOf(address(this));
674         if (_balance > _snapshotAssetBalance && isPerformanceFeeEnabled == true) {
675             uint256 _delta = _balance - _snapshotAssetBalance;
676             
677             // 1 / 5 = 20 / 100  --> (set 'managerPerformanceFee' to '5' to take 20% from profit)
678             _managerFee = _delta / managerPerformanceFee;
679             
680             // cap performance fee by a % of TVL to disincentivize over risk taking
681             // 1 / 5 = 20 / 100  --> (set 'performanceFeeLimit' to '5' to cap performance fee to 20% of TVL)
682             if (_managerFee > _snapshotAssetBalance / performanceFeeLimit) {
683                 _managerFee = _snapshotAssetBalance / performanceFeeLimit;
684             }
685             
686             // send performance fee to Vault Manager
687             IERC20(_asset).safeTransfer(manager, _managerFee);
688         }
689 
690         emit FeesCharged(_managerFee, _balance, _snapshotAssetBalance);
691     }
692 
693     function _onState(State _expectedState) internal view virtual {
694         if (currentVaultState != _expectedState) revert InvalidState();
695     }
696 
697     function _getCollateralImposedLimit() internal view returns (uint256) {
698         if (balanceOf[address(this)] <= totalSupply / collateralRequirement) {
699             return 0;
700         } else {
701             return balanceOf[address(this)] * collateralRequirement - totalSupply;
702         }
703     }
704 
705     function _approve(address _asset, address _spender, uint256 _amount) internal {
706         IERC20(_asset).safeApprove(_spender, 0);
707         IERC20(_asset).safeApprove(_spender, _amount);
708     }
709 }