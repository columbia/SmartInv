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
17 //  _____         _                   __              _ _         _____             
18 // |   __|___ ___| |_ ___ ___ ___ ___|  |   ___ ___ _| |_|___ ___|     |___ ___ ___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|  |__| -_|   | . | |   | . |   --| . |  _| -_|
20 // |__|  |___|_| |_| |_| |___|___|___|_____|___|_|_|___|_|_|_|_  |_____|___|_| |___|
21 //                                                           |___|                  
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {ERC4626, ERC20} from "@solmate/mixins/ERC4626.sol";
26 import {AggregatorV3Interface} from "@chainlink/src/v0.8/interfaces/AggregatorV3Interface.sol";
27 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
28 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
29 import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
30 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
31 
32 import {FortressLendingConstants} from "./FortressLendingConstants.sol";
33 import {IRateCalculator} from "./interfaces/IRateCalculator.sol";
34 import {IFortressSwap} from "../fortress-interfaces/IFortressSwap.sol";
35 import {IFortressVault} from "../fortress-interfaces/IFortressVault.sol";
36 
37 /// @notice An abstract contract which contains the core logic and storage for the FortressLendingPair
38 abstract contract FortressLendingCore is FortressLendingConstants, ReentrancyGuard, ERC4626 {
39 
40     using SafeERC20 for IERC20;
41     using SafeCast for uint256;
42 
43     struct PauseSettings {
44         bool depositLiquidity;
45         bool withdrawLiquidity;
46         bool addLeverage;
47         bool removeLeverage;
48         bool addInterest;
49         bool liquidations;
50         bool addCollateral;
51         bool removeCollateral;
52         bool repayAsset;
53     }
54 
55     /********************************** Settings set by constructor() & initialize() **********************************/
56 
57     // Asset and collateral contracts
58     IERC20 public immutable assetContract;
59     IERC20 public immutable collateralContract;
60 
61     // Oracle wrapper contract and oracle Data
62     address public immutable oracleMultiply;
63     address public immutable oracleDivide;
64     uint256 public immutable oracleNormalization;
65 
66     // LTV Settings
67     uint256 public immutable maxLTV;
68 
69     // Liquidation Fee
70     uint256 public immutable cleanLiquidationFee;
71     uint256 public immutable dirtyLiquidationFee;
72 
73     // Interest Rate Calculator Contract
74     IRateCalculator public immutable rateContract; // For complex rate calculations
75     bytes public rateInitCallData; // Optional extra data from init function to be passed to rate calculator
76 
77     // Swapper
78     address public swap;
79     
80     // Owner
81     address public owner;
82 
83     // Pause Settings
84     PauseSettings public pauseSettings;
85 
86     /********************************** Storage **********************************/
87 
88     /// @notice Stores information about the current interest rate
89     /// @dev struct is packed to reduce SLOADs
90     CurrentRateInfo public currentRateInfo;
91     struct CurrentRateInfo {
92         uint64 lastBlock;
93         uint64 feeToProtocolRate; // 1e5 precision
94         uint64 lastTimestamp;
95         uint64 ratePerSec; // 1e18 precision
96     }
97 
98     /// @notice Stores information about the current exchange rate. Collateral:Asset ratio
99     /// @dev Struct packed to save SLOADs. Amount of Collateral Token to buy 1e18 Asset Token
100     ExchangeRateInfo public exchangeRateInfo;
101     struct ExchangeRateInfo {
102         uint32 lastTimestamp;
103         uint224 exchangeRate; // collateral:asset ratio. i.e. how much collateral to buy 1e18 asset
104     }
105 
106     // Contract Level Accounting
107     BorrowAccount public totalBorrow; // amount = total borrow amount with interest accrued, shares = total shares outstanding
108     struct BorrowAccount {
109         uint256 amount; // Total amount, analogous to market cap
110         uint256 shares; // Total shares, analogous to shares outstanding
111     }
112 
113     uint256 public totalCollateral; // total amount of collateral in contract
114     uint256 public totalAUM; // total amount of assets in contract (including lent assets)
115     
116     // User Level Accounting
117     /// @notice Stores the balance of collateral for each user
118     mapping(address => uint256) public userCollateralBalance; // amount of collateral each user is backed
119     /// @notice Stores the balance of borrow shares for each user
120     mapping(address => uint256) public userBorrowShares; // represents the shares held by individuals
121     // NOTE: user shares of assets are represented as ERC-20 tokens and accessible via balanceOf()
122 
123     // Speed Bump
124     /// @notice Stores the last interaction block for each user
125     mapping(address => uint256) public lastInteractionBlock;
126 
127     // ============================================================================================
128     // Initialize
129     // ============================================================================================
130 
131     /// @notice Called on deployment
132     /// @param _configData abi.encoded config data
133     /// @param _maxLTV The Maximum Loan-To-Value for a borrower to be considered solvent (1e5 precision)
134     /// @param _liquidationFee The fee paid to liquidators given as a % of the repayment (1e5 precision)
135     constructor(ERC20 _asset, string memory _name, string memory _symbol, bytes memory _configData, address _owner, address _swap, uint256 _maxLTV, uint256 _liquidationFee)
136         ERC4626(_asset, _name, _symbol) {
137 
138         (address _collateral, address _oracleMultiply, address _oracleDivide, uint256 _oracleNormalization, address _rateContract,)
139             = abi.decode(_configData, (address, address, address, uint256, address, bytes));
140 
141         // Pair Settings
142         assetContract = IERC20(address(_asset));
143         collateralContract = IERC20(_collateral);
144         currentRateInfo.feeToProtocolRate = DEFAULT_PROTOCOL_FEE;
145         cleanLiquidationFee = _liquidationFee;
146         dirtyLiquidationFee = (_liquidationFee * 90000) / LIQ_PRECISION; // 90% of clean fee
147 
148         // LTV Settings
149         maxLTV = _maxLTV;
150 
151         // Oracle Settings
152         oracleMultiply = _oracleMultiply;
153         oracleDivide = _oracleDivide;
154         oracleNormalization = _oracleNormalization;
155 
156         // Rate Calculator Settings
157         rateContract = IRateCalculator(_rateContract);
158 
159         // Set swap
160         swap = _swap;
161 
162         // Set admins
163         owner = _owner;
164     }
165 
166     /// @notice Called immediately after deployment
167     /// @dev This function can only be called by the owner
168     /// @param _rateInitCallData The configuration data for the Rate Calculator contract
169     function initialize(bytes calldata _rateInitCallData) external onlyOwner {
170         // Reverts if init data is not valid
171         IRateCalculator(rateContract).requireValidInitData(_rateInitCallData);
172 
173         // Set rate init Data
174         rateInitCallData = _rateInitCallData;
175 
176         // Instantiate Interest
177         _addInterest();
178 
179         // Instantiate Exchange Rate
180         _updateExchangeRate();
181     }
182 
183     // ============================================================================================
184     // External Helpers
185     // ============================================================================================
186 
187     /// @notice Returns the total amount of assets managed by Vault (including lent assets)
188     function totalAssets() public view override returns (uint256) {
189         return totalAUM;
190     }
191 
192     /// @notice Calculates the shares value in relationship to `amount` and `total`
193     /// @dev Given an amount, return the appropriate number of shares
194     /// @param _totalAmount The total amount of assets
195     /// @param _totalSupply The total supply of shares
196     /// @param _amount The amount of assets to convert to shares
197     /// @param _roundUp Whether to round up or down
198     /// @return _shares The number of shares
199     function convertToShares(uint256 _totalAmount, uint256 _totalSupply, uint256 _amount, bool _roundUp) public pure returns (uint256 _shares) {
200         if (_totalAmount == 0) {
201             _shares = _amount;
202         } else {
203             _shares = (_amount * _totalSupply) / _totalAmount;
204             if (_roundUp && (_shares * _totalAmount) / _totalSupply < _amount) {
205                 _shares = _shares + 1;
206             }
207         }
208     }
209 
210     /// @notice Calculates the amount value in relationship to `shares` and `total`
211     /// @dev Given a number of shares, returns the appropriate amount
212     /// @param _totalAmount The total amount of assets
213     /// @param _totalSupply The total supply of shares
214     /// @param _shares The number of shares to convert to amount
215     /// @param _roundUp Whether to round up or down
216     /// @return _amount The amount of assets
217     function convertToAssets(uint256 _totalAmount, uint256 _totalSupply, uint256 _shares, bool _roundUp) public pure returns (uint256 _amount) {
218         if (_totalSupply == 0) {
219             _amount = _shares;
220         } else {
221             _amount = (_shares * _totalAmount) / _totalSupply;
222             if (_roundUp && (_amount * _totalSupply) / _totalAmount < _shares) {
223                 _amount = _amount + 1;
224             }
225         }
226     }
227 
228     /// @notice Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
229     /// @param _shares - The amount of _shares to redeem
230     /// @return - The amount of _assets in return
231     function previewRedeem(uint256 _shares) public view override returns (uint256) {
232         uint256 _assets = convertToAssets(_shares);
233 
234         if (_assets > _totalAssetAvailable()) revert InsufficientAssetsInContract(_assets, _totalAssetAvailable());
235 
236         return _assets;
237     }
238 
239     /// @notice Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
240     /// @param _assets - The amount of _assets to withdraw
241     /// @return - The amount of shares to burn
242     function previewWithdraw(uint256 _assets) public view override returns (uint256) {
243         if (_assets > _totalAssetAvailable()) revert InsufficientAssetsInContract(_assets, _totalAssetAvailable());
244 
245         return convertToShares(_assets);
246     }
247 
248     /// @notice Returns the values of all constants used in the contract
249     function getConstants() external pure
250         returns (
251             uint256 _LTV_PRECISION,
252             uint256 _LIQ_PRECISION,
253             uint256 _UTIL_PREC,
254             uint256 _FEE_PRECISION,
255             uint256 _EXCHANGE_PRECISION,
256             uint64 _DEFAULT_INT,
257             uint16 _DEFAULT_PROTOCOL_FEE,
258             uint256 _MAX_PROTOCOL_FEE
259         )
260     {
261         _LTV_PRECISION = LTV_PRECISION;
262         _LIQ_PRECISION = LIQ_PRECISION;
263         _UTIL_PREC = UTIL_PREC;
264         _FEE_PRECISION = FEE_PRECISION;
265         _EXCHANGE_PRECISION = EXCHANGE_PRECISION;
266         _DEFAULT_INT = DEFAULT_INT;
267         _DEFAULT_PROTOCOL_FEE = DEFAULT_PROTOCOL_FEE;
268         _MAX_PROTOCOL_FEE = MAX_PROTOCOL_FEE;
269     }
270 
271     // ============================================================================================
272     // Internal Helpers
273     // ============================================================================================
274 
275     /// @notice Returns the total balance of Asset Tokens in the contract
276     /// @return The balance of Asset Tokens held by contract
277     function _totalAssetAvailable() internal view returns (uint256) {
278         return totalAssets() - totalBorrow.amount;
279     }
280 
281     /// @notice Determines if a given borrower is solvent given an exchange rate
282     /// @param _borrower The borrower address to check
283     /// @param _exchangeRate The exchange rate, i.e. the amount of collateral to buy 1e18 asset
284     /// @return Whether borrower is solvent
285     function _isSolvent(address _borrower, uint256 _exchangeRate) internal view returns (bool) {
286         if (maxLTV == 0) return true;
287         BorrowAccount memory _totalBorrow = totalBorrow;
288         uint256 _borrowerAmount = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, userBorrowShares[_borrower], true);
289         if (_borrowerAmount == 0) return true;
290         uint256 _collateralAmount = userCollateralBalance[_borrower];
291         if (_collateralAmount == 0) return false;
292 
293         uint256 _ltv = (((_borrowerAmount * _exchangeRate) / EXCHANGE_PRECISION) * LTV_PRECISION) / _collateralAmount;
294 
295         return _ltv <= maxLTV;
296     }
297 
298     /// @notice Approves a spender to spend a given amount of a token
299     /// @param _token The token to approve
300     /// @param _spender The spender to approve
301     /// @param _amount The amount to approve
302     function _approve(address _token, address _spender, uint256 _amount) internal {
303         IERC20(_token).safeApprove(_spender, 0);
304         IERC20(_token).safeApprove(_spender, _amount);
305     }
306 
307     // ============================================================================================
308     // Modifiers
309     // ============================================================================================
310 
311     /// @notice Checks that msg.sender is the owner
312     modifier onlyOwner() {
313         if (msg.sender != owner) revert NotOwner();
314         _;
315     }
316 
317     /// @notice Allows a borrower to interact with the contract only once per block
318     /// @param _borrower The borrower whose interaction we are checking
319     modifier speedBump(address _borrower) {
320         if (lastInteractionBlock[_borrower] == block.number) revert AlreadyCalledOnBlock(_borrower);
321         _;
322     }
323 
324     /// @notice Checks for solvency AFTER executing contract code
325     /// @param _borrower The borrower whose solvency we will check
326     modifier isSolvent(address _borrower) {
327         _;
328         if (!_isSolvent(_borrower, exchangeRateInfo.exchangeRate)) revert Insolvent(_borrower);
329     }
330 
331     // ============================================================================================
332     // Functions: Configuration
333     // ============================================================================================
334 
335     /// @notice Withdraws accumulated fees
336     /// @param _shares Number of fTokens to redeem
337     /// @param _recipient Address to send the assets
338     /// @return _amountToTransfer Amount of assets sent to recipient
339     function withdrawFees(uint256 _shares, address _recipient) external onlyOwner returns (uint256 _amountToTransfer) {
340 
341         // Take all available if 0 value passed
342         if (_shares == 0) _shares = balanceOf[address(this)];
343 
344         // We must calculate this before we subtract from _totalAsset or invoke _burn
345         _amountToTransfer = convertToAssets(totalAssets(), totalSupply, _shares, true);
346 
347         // Check for sufficient withdraw liquidity
348         if (_totalAssetAvailable() < _amountToTransfer) revert InsufficientAssetsInContract(_amountToTransfer, _totalAssetAvailable());
349 
350         // Effects: bookkeeping
351         totalAUM -= _amountToTransfer;
352         // totalSupply -= _shares; // NOTE: this is done in `_burn` below
353 
354         // Effects: write to states
355         _burn(address(this), _shares); // NOTE: will revert if _shares > balanceOf(address(this))
356 
357         // Interactions
358         assetContract.safeTransfer(_recipient, _amountToTransfer);
359         
360         emit WithdrawFees(_shares, _recipient, _amountToTransfer);
361     }
362 
363     /// @notice Updates the address of Swap contract
364     /// @param _swap The new swap address
365     function updateSwap(address _swap) external onlyOwner {
366         swap = _swap;
367 
368         emit UpdateSwap(_swap);
369     }
370 
371     /// @notice Updates the owner of the contract
372     /// @param _owner The address of the new owner
373     function updateOwner(address _owner) external onlyOwner {
374         owner = _owner;
375         
376         emit UpdateOwner(_owner);
377     }
378 
379     /// @notice Updates protocol fee amount
380     /// @param _newFee The new fee amount
381     function updateFee(uint64 _newFee) external onlyOwner {
382         if (_newFee > MAX_PROTOCOL_FEE) revert InvalidProtocolFee();
383 
384         _addInterest();
385 
386         currentRateInfo.feeToProtocolRate = _newFee;
387         
388         emit UpdateFee(_newFee);
389     }
390 
391     /// @notice Updates the pause settings
392     /// @param _configData The abi.encoded new pause settings
393     function updatePauseSettings(bytes memory _configData) external onlyOwner {
394         
395         _addInterest();
396 
397         (bool _depositLiquidity, bool _withdrawLiquidity, bool _addLeverage, bool _removeLeverage, bool _interest, bool _liquidations, bool _addCol, bool _removeCol, bool _repay)
398             = abi.decode(_configData, (bool, bool, bool, bool, bool, bool, bool, bool, bool));
399         
400         pauseSettings = PauseSettings({
401             depositLiquidity: _depositLiquidity,
402             withdrawLiquidity: _withdrawLiquidity,
403             addLeverage: _addLeverage,
404             removeLeverage: _removeLeverage,
405             addInterest: _interest,
406             liquidations: _liquidations,
407             addCollateral: _addCol,
408             removeCollateral: _removeCol,
409             repayAsset: _repay
410         });
411 
412         emit UpdatePauseSettings(_depositLiquidity, _withdrawLiquidity, _addLeverage, _removeLeverage, _interest, _liquidations, _addCol, _removeCol, _repay);
413     }
414 
415     // ============================================================================================
416     // Functions: Lending
417     // Visability: External
418     // ============================================================================================
419 
420     /// @notice Allows a user to Lend Assets by specifying the amount of Asset Tokens to lend
421     /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
422     /// @param _assets The amount of Asset Token to transfer to Pair
423     /// @param _receiver The address to receive the Asset Shares (fTokens)
424     /// @return _shares The number of fTokens received for the deposit
425     function deposit(uint256 _assets, address _receiver) public override nonReentrant returns (uint256 _shares) {
426         _addInterest();
427         
428         _shares = previewDeposit(_assets);
429         
430         _deposit(_assets, _shares, _receiver);
431 
432         return _shares;
433     }
434 
435     /// @notice Mints exact vault shares to _receiver by depositing assets
436     /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
437     /// @param _shares The amount of shares to mint
438     /// @param _receiver The address of the receiver of shares
439     /// @return _assets The amount of assets deposited
440     function mint(uint256 _shares, address _receiver) public override nonReentrant returns (uint256 _assets) {
441         _addInterest();
442 
443         _assets = previewMint(_shares);
444         
445         _deposit(_assets, _shares, _receiver);
446         
447         return _assets;
448     }
449 
450     /// @notice Burns shares from owner and sends exact amount of assets to _receiver
451     /// @param _assets The amount of assets to receive
452     /// @param _receiver The address of the receiver of assets
453     /// @param _owner The owner of shares
454     /// @return _shares The amount of shares burned
455     function withdraw(uint256 _assets, address _receiver, address _owner) public override nonReentrant returns (uint256 _shares) {
456         if (_assets > maxWithdraw(_owner)) revert InsufficientBalance(_assets, maxWithdraw(_owner));
457 
458         _addInterest();
459 
460         _shares = previewWithdraw(_assets);
461         
462         _withdraw(_assets, _shares, _receiver, _owner);
463         
464         return _shares;
465     }
466 
467     /// @notice Allows the caller to redeem their Asset Shares for Asset Tokens
468     /// @param _shares The number of Asset Shares (fTokens) to burn for Asset Tokens
469     /// @param _receiver The address to which the Asset Tokens will be transferred
470     /// @param _owner The owner of the Asset Shares (fTokens)
471     /// @return _assets The amount of Asset Tokens to be transferred
472     function redeem(uint256 _shares, address _receiver, address _owner) public override nonReentrant returns (uint256 _assets) {
473         if (_shares > maxRedeem(_owner)) revert InsufficientBalance(_shares, maxRedeem(_owner));
474 
475         _addInterest();
476 
477         _assets = previewRedeem(_shares);
478 
479         _withdraw(_assets, _shares, _receiver, _owner);
480         
481         return _assets;
482     }
483 
484     // ============================================================================================
485     // Functions: Lending
486     // Visability: Internal
487     // ============================================================================================
488 
489     /// @notice The nternal implementation for lending assets
490     /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
491     /// @param _assets The amount of Asset Token to be transferred
492     /// @param _shares The amount of Asset Shares (fTokens) to be minted
493     /// @param _receiver The address to receive the Asset Shares (fTokens)
494     function _deposit(uint256 _assets, uint256 _shares, address _receiver) internal {
495         if (pauseSettings.depositLiquidity) revert Paused();
496         if (_receiver == address(0)) revert ZeroAddress();
497         if (!(_assets > 0)) revert ZeroAmount();
498         if (!(_shares > 0)) revert ZeroAmount();
499 
500         totalAUM += _assets;
501         _mint(_receiver, _shares);
502         
503         assetContract.safeTransferFrom(msg.sender, address(this), _assets);
504         
505         emit Deposit(msg.sender, _receiver, _assets, _shares);
506     }
507 
508     /// @notice The internal implementation which allows a Lender to pull their Asset Tokens out of the Pair
509     /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
510     /// @param _assets The number of Asset Tokens to return
511     /// @param _shares The number of Asset Shares (fTokens) to burn
512     /// @param _receiver The address to which the Asset Tokens will be transferred
513     /// @param _owner The owner of the Asset Shares (fTokens)
514     function _withdraw(uint256 _assets, uint256 _shares, address _receiver, address _owner) internal {
515         if (pauseSettings.withdrawLiquidity) revert Paused();
516         if (_receiver == address(0)) revert ZeroAddress();
517         if (_owner == address(0)) revert ZeroAddress();
518         if (!(_shares > 0)) revert ZeroAmount();
519         if (!(_assets > 0)) revert ZeroAmount();
520 
521         if (msg.sender != _owner) {
522             uint256 _allowed = allowance[_owner][msg.sender]; // Saves gas for limited approvals
523             // NOTE: This will revert on underflow ensuring that allowance > shares
524             if (_allowed != type(uint256).max) allowance[_owner][msg.sender] = _allowed - _shares;
525         }
526 
527         _burn(_owner, _shares);
528         totalAUM -= _assets;
529 
530         assetContract.safeTransfer(_receiver, _assets);
531 
532         emit Withdraw(msg.sender, _receiver, _owner, _assets, _shares);
533     }
534 
535     // ============================================================================================
536     // Functions: Borrowing
537     // Visability: External
538     // ============================================================================================
539 
540     /// @notice Allows the caller to add Collateral Token to a borrowers position
541     /// @dev msg.sender must call ERC20.approve() on the Collateral Token contract prior to invocation
542     /// @param _collateralAmount The amount of Collateral Token to be added to borrower's position
543     /// @param _borrower The account to be credited
544     function addCollateral(uint256 _collateralAmount, address _borrower) external nonReentrant speedBump(_borrower) {
545         if (pauseSettings.addCollateral) revert Paused();
546 
547         lastInteractionBlock[_borrower] = block.number;
548 
549         _addInterest();
550 
551         _addCollateral(msg.sender, _collateralAmount, _borrower);
552     }
553 
554     /// @notice Removes collateral from msg.sender's borrow position
555     /// @dev msg.sender must be solvent after invocation or transaction will revert
556     /// @param _collateralAmount The amount of Collateral Token to transfer
557     /// @param _receiver The address to receive the transferred funds
558     function removeCollateral(uint256 _collateralAmount, address _receiver) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) {
559         if (pauseSettings.removeCollateral) revert Paused();
560         
561         lastInteractionBlock[msg.sender] = block.number;
562 
563         _addInterest();
564         
565         // Note: exchange rate is irrelevant when borrower has no debt shares
566         if (userBorrowShares[msg.sender] > 0) _updateExchangeRate();
567         
568         _removeCollateral(_collateralAmount, _receiver, msg.sender);
569     }
570 
571     /// @notice Allows the caller to pay down the debt for a given borrower
572     /// @dev Caller must first invoke `ERC20.approve()` for the Asset Token contract
573     /// @param _shares The number of Borrow Shares which will be repaid by the call
574     /// @param _borrower The account for which the debt will be reduced
575     /// @return _amountToRepay The amount of Asset Tokens which were transferred in order to repay the Borrow Shares
576     function repayAsset(uint256 _shares, address _borrower) external nonReentrant speedBump(_borrower) returns (uint256 _amountToRepay) {
577         if (pauseSettings.repayAsset) revert Paused();
578 
579         lastInteractionBlock[_borrower] = block.number;
580 
581         _addInterest();
582         
583         BorrowAccount memory _totalBorrow = totalBorrow;
584         _amountToRepay = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _shares, true);
585         
586         _repayAsset(_totalBorrow, _amountToRepay, _shares, msg.sender, _borrower);
587     }
588 
589     // ============================================================================================
590     // Functions: Borrowing
591     // Visability: Internal
592     // ============================================================================================
593 
594     /// @notice The nternal implementation for adding collateral to a borrowers position
595     /// @param _sender The source of funds for the new collateral
596     /// @param _collateralAmount The amount of Collateral Token to be transferred
597     /// @param _borrower The borrower account for which the collateral should be credited
598     function _addCollateral(address _sender, uint256 _collateralAmount, address _borrower) internal {
599         userCollateralBalance[_borrower] += _collateralAmount;
600         totalCollateral += _collateralAmount;
601 
602         if (_sender != address(this)) {
603             collateralContract.safeTransferFrom(_sender, address(this), _collateralAmount);
604         }
605         
606         emit AddCollateral(_sender, _borrower, _collateralAmount);
607     }
608     
609     /// @notice The internal implementation for removing collateral from a borrower's position
610     /// @param _collateralAmount The amount of Collateral Token to remove from the borrower's position
611     /// @param _receiver The address to receive the Collateral Token transferred
612     /// @param _borrower The borrower whose account will be debited the Collateral amount
613     function _removeCollateral(uint256 _collateralAmount, address _receiver, address _borrower) internal {
614         // Following line will revert on underflow if _collateralAmount > userCollateralBalance
615         userCollateralBalance[_borrower] -= _collateralAmount;
616         // Following line will revert on underflow if totalCollateral < _collateralAmount
617         totalCollateral -= _collateralAmount;
618 
619         if (_receiver != address(this)) {
620             collateralContract.safeTransfer(_receiver, _collateralAmount);
621         }
622 
623         emit RemoveCollateral(msg.sender, _collateralAmount, _receiver, _borrower);
624     }
625 
626     /// @notice The internal implementation for borrowing assets
627     /// @param _borrowAmount The amount of the Asset Token to borrow
628     /// @return _sharesAdded The amount of borrow shares the msg.sender will be debited
629     function _borrowAsset(uint256 _borrowAmount) internal returns (uint256 _sharesAdded) {
630         if (_borrowAmount > _totalAssetAvailable()) revert InsufficientAssetsInContract(_borrowAmount, _totalAssetAvailable());
631         
632         BorrowAccount memory _totalBorrow = totalBorrow;
633 
634         _sharesAdded = convertToShares(_totalBorrow.amount, _totalBorrow.shares, _borrowAmount, true);
635         _totalBorrow.amount = _totalBorrow.amount + _borrowAmount;
636         _totalBorrow.shares = _totalBorrow.shares + _sharesAdded;
637         
638         totalBorrow = _totalBorrow;
639         userBorrowShares[msg.sender] += _sharesAdded;
640 
641         emit BorrowAsset(msg.sender, _borrowAmount, _sharesAdded);
642     }
643 
644     /// @notice The internal implementation for repaying a borrow position
645     /// @dev The payer must have called ERC20.approve() on the Asset Token contract prior to invocation
646     /// @param _totalBorrow An in memory copy of the totalBorrow VaultAccount struct
647     /// @param _amountToRepay The amount of Asset Token to transfer
648     /// @param _shares The number of Borrow Shares the sender is repaying
649     /// @param _payer The address from which funds will be transferred
650     /// @param _borrower The borrower account which will be credited
651     function _repayAsset(BorrowAccount memory _totalBorrow, uint256 _amountToRepay, uint256 _shares, address _payer, address _borrower) internal {
652         _totalBorrow.amount = _totalBorrow.amount - _amountToRepay;
653         _totalBorrow.shares = _totalBorrow.shares - _shares;
654         
655         userBorrowShares[_borrower] -= _shares;
656         totalBorrow = _totalBorrow;
657 
658         if (_payer != address(this)) {
659             assetContract.safeTransferFrom(_payer, address(this), _amountToRepay);
660         }
661 
662         emit RepayAsset(_payer, _borrower, _amountToRepay, _shares);
663     }
664 
665     // ============================================================================================
666     // Functions: Under Collateralized Leverage
667     // ============================================================================================
668 
669     /// @notice Allows a user to enter a leveraged borrow position with minimal upfront Collateral (effectively take an under collateralized loan)
670     /// @dev Caller must invoke `ERC20.approve()` on the Collateral Token contract prior to calling function
671     /// @param _borrowAmount The amount of Asset Tokens borrowed
672     /// @param _initialCollateralAmount The initial amount of Collateral Tokens supplied by the borrower
673     /// @param _minAmount The minimum amount of Collateral Tokens to be received in exchange for the borrowed Asset Tokens
674     /// @param _underlyingAsset The address of the underlying asset to be deposited into the Vault, which will be swapped for Collateral Tokens
675     /// @return _totalCollateralAdded The total amount of Collateral Tokens added to a users account (initial + swap)
676     function leveragePosition(uint256 _borrowAmount, uint256 _initialCollateralAmount, uint256 _minAmount, address _underlyingAsset) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) returns (uint256 _totalCollateralAdded) {
677         if (ERC20(address(_underlyingAsset)).decimals() != ERC20(address(assetContract)).decimals()) revert InvalidUnderlyingAsset();
678         if (pauseSettings.addLeverage) revert Paused();
679 
680         lastInteractionBlock[msg.sender] = block.number;
681 
682         _addInterest();
683         _updateExchangeRate();
684 
685         // Add initial collateral
686         if (_initialCollateralAmount > 0) _addCollateral(msg.sender, _initialCollateralAmount, msg.sender);
687 
688         // Debit borrowers (msg.sender) account
689         uint256 _borrowShares = _borrowAsset(_borrowAmount);
690 
691         uint256 _underlyingAmount;
692         address _asset = address(assetContract);
693         if (_asset != _underlyingAsset) {
694             address _swap = address(swap);
695             _approve(_asset, _swap, _borrowAmount);
696             _underlyingAmount = IFortressSwap(_swap).swap(_asset, _underlyingAsset, _borrowAmount);
697         } else {
698             _underlyingAmount = _borrowAmount;
699         }
700 
701         address _collateralContract = address(collateralContract);
702         _approve(_underlyingAsset, _collateralContract, _underlyingAmount);
703         uint256 _amountCollateralOut = IFortressVault(_collateralContract).depositUnderlying(_underlyingAsset, address(this), _underlyingAmount, 0);
704         if (_amountCollateralOut < _minAmount) revert SlippageTooHigh(_amountCollateralOut, _minAmount);
705 
706         // address(this) as _sender means no transfer occurs as the pair has already received the collateral during swap
707         _addCollateral(address(this), _amountCollateralOut, msg.sender);
708         
709         emit LeveragedPosition(msg.sender, _borrowAmount, _borrowShares, _initialCollateralAmount, _amountCollateralOut);
710 
711         return _initialCollateralAmount + _amountCollateralOut;
712     }
713 
714     /// @notice Allows a borrower to repay their debt using existing collateral in contract
715     /// @param _collateralToSwap The amount of Collateral Tokens to swap for Asset Tokens
716     /// @param _minAmount The minimum amount of Asset Tokens to receive during the swap
717     /// @return _amountAssetOut The amount of Asset Tokens received for the Collateral Tokens, the amount the borrowers account was credited
718     function repayAssetWithCollateral(uint256 _collateralToSwap, uint256 _minAmount, address _underlyingAsset) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) returns (uint256 _amountAssetOut) {
719         if (ERC20(address(_underlyingAsset)).decimals() != ERC20(address(assetContract)).decimals()) revert InvalidUnderlyingAsset();
720         if (pauseSettings.removeLeverage) revert Paused();
721 
722         lastInteractionBlock[msg.sender] = block.number;
723 
724         _addInterest();
725         _updateExchangeRate();
726 
727         // Note: Debit users collateral balance in preparation for swap, setting _recipient to address(this) means no transfer occurs
728         _removeCollateral(_collateralToSwap, address(this), msg.sender);
729         _amountAssetOut = IFortressVault(address(collateralContract)).redeemUnderlying(_underlyingAsset, address(this), address(this), _collateralToSwap, 0);
730         
731         address _asset = address(assetContract);
732 
733         if (_underlyingAsset != _asset) {
734             _approve(_underlyingAsset, swap, _amountAssetOut);
735             _amountAssetOut = IFortressSwap(swap).swap(_underlyingAsset, _asset, _amountAssetOut);
736         }
737 
738         if (_amountAssetOut < _minAmount) revert SlippageTooHigh(_amountAssetOut, _minAmount);
739 
740         BorrowAccount memory _totalBorrow = totalBorrow;
741         uint256 _sharesToRepay = convertToShares(_totalBorrow.amount, _totalBorrow.shares, _amountAssetOut, false);
742 
743         // Note: Setting _payer to address(this) means no actual transfer will occur.  Contract already has funds
744         _repayAsset(_totalBorrow, _amountAssetOut, _sharesToRepay, address(this), msg.sender);
745 
746         emit RepayAssetWithCollateral(msg.sender, _collateralToSwap, _amountAssetOut, _sharesToRepay);
747     }
748 
749     // ============================================================================================
750     // Functions: Interest Accumulation and Adjustment
751     // ============================================================================================
752 
753     /// @notice The public implementation of `_addInterest` and allows 3rd parties to trigger interest accrual
754     /// @return _interestEarned The amount of interest accrued by all borrowers
755     function addInterest() external nonReentrant returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate) {
756         return _addInterest();
757     }
758 
759     /// @notice Invoked prior to every external function and is used to accrue interest and update interest rate
760     /// @dev Can only called once per block
761     /// @return _interestEarned The amount of interest accrued by all borrowers
762     function _addInterest() internal returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate) {
763         // Add interest only once per block
764         CurrentRateInfo memory _currentRateInfo = currentRateInfo;
765         if (_currentRateInfo.lastTimestamp == block.timestamp) {
766             _newRate = _currentRateInfo.ratePerSec;
767             return (_interestEarned, _feesAmount, _feesShare, _newRate);
768         }
769 
770         uint256 _totalAsset = totalAssets();
771         BorrowAccount memory _totalBorrow = totalBorrow;
772         
773         // If there are no borrows or contract is paused, no interest accrues and we reset interest rate
774         if (_totalBorrow.shares == 0 || pauseSettings.addInterest) {
775             if (!pauseSettings.addInterest) {
776                 _currentRateInfo.ratePerSec = DEFAULT_INT;
777             }
778             _currentRateInfo.lastTimestamp = uint64(block.timestamp);
779             _currentRateInfo.lastBlock = uint64(block.number);
780 
781             currentRateInfo = _currentRateInfo;
782         } else {
783             // We know totalBorrow.shares > 0
784             uint256 _deltaTime = block.timestamp - _currentRateInfo.lastTimestamp;
785 
786             // NOTE: Violates Checks-Effects-Interactions pattern
787             // Be sure to mark external version NONREENTRANT (even though rateContract is trusted)
788             // Calc new rate
789             uint256 _utilizationRate = (UTIL_PREC * _totalBorrow.amount) / _totalAsset;
790             
791             bytes memory _rateData = abi.encode(_currentRateInfo.ratePerSec, _deltaTime, _utilizationRate, block.number - _currentRateInfo.lastBlock);
792             _newRate = IRateCalculator(rateContract).getNewRate(_rateData, rateInitCallData);
793 
794             emit UpdateRate(_currentRateInfo.ratePerSec, _deltaTime, _utilizationRate, _newRate);
795 
796             // Effects: bookkeeping
797             _currentRateInfo.ratePerSec = _newRate;
798             _currentRateInfo.lastTimestamp = uint64(block.timestamp);
799             _currentRateInfo.lastBlock = uint64(block.number);
800 
801             // Calculate interest accrued
802             _interestEarned = (_deltaTime * _totalBorrow.amount * _currentRateInfo.ratePerSec) / 1e18;
803 
804             // Accumulate interest and fees
805             _totalBorrow.amount = _totalBorrow.amount + _interestEarned;
806             _totalAsset = _totalAsset + _interestEarned;
807             
808             if (_currentRateInfo.feeToProtocolRate > 0) {
809                 _feesAmount = (_interestEarned * _currentRateInfo.feeToProtocolRate) / FEE_PRECISION;
810 
811                 _feesShare = (_feesAmount * totalSupply) / (_totalAsset - _feesAmount);
812                 
813                 // Effects: write to storage
814                 _mint(address(this), _feesShare);
815             }
816             emit AddInterest(_interestEarned, _currentRateInfo.ratePerSec, _deltaTime, _feesAmount, _feesShare);
817 
818             // Effects: write to storage
819             currentRateInfo = _currentRateInfo;
820             totalBorrow = _totalBorrow;
821             totalAUM = _totalAsset;
822         }
823     }
824 
825     // ============================================================================================
826     // Functions: ExchangeRate
827     // ============================================================================================
828 
829     /// @notice The external implementation of `_updateExchangeRate`
830     /// @dev This function is invoked at most once per block as these queries can be expensive
831     /// @return _exchangeRate The new exchange rate
832     function updateExchangeRate() external nonReentrant returns (uint256 _exchangeRate) {
833         _exchangeRate = _updateExchangeRate();
834     }
835 
836     /// @notice Retrieves the latest exchange rate. i.e how much collateral to buy 1e18 asset
837     /// @dev This function is invoked at most once per block as these queries can be expensive
838     /// @return _exchangeRate The new exchange rate
839     function _updateExchangeRate() internal returns (uint256 _exchangeRate) {
840         ExchangeRateInfo memory _exchangeRateInfo = exchangeRateInfo;
841         if (_exchangeRateInfo.lastTimestamp == block.timestamp) {
842             return _exchangeRate = _exchangeRateInfo.exchangeRate;
843         }
844 
845         uint256 _price = uint256(1e36);
846         address _oracleMultiply = oracleMultiply;
847         if (_oracleMultiply != address(0)) {
848             (, int256 _answer, , , ) = AggregatorV3Interface(_oracleMultiply).latestRoundData();
849             if (_answer <= 0) {
850                 revert OracleLTEZero(_oracleMultiply);
851             }
852             _price = _price * uint256(_answer);
853         }
854 
855         address _oracleDivide = oracleDivide;
856         if (_oracleDivide != address(0)) {
857             (, int256 _answer, , , ) = AggregatorV3Interface(_oracleDivide).latestRoundData();
858             if (_answer <= 0) {
859                 revert OracleLTEZero(_oracleDivide);
860             }
861             _price = _price / uint256(_answer);
862         }
863 
864         _exchangeRate = _price / oracleNormalization;
865         if (_exchangeRate > type(uint224).max) revert PriceTooLarge(_exchangeRate);
866 
867         _exchangeRateInfo.exchangeRate = uint224(_exchangeRate);
868         _exchangeRateInfo.lastTimestamp = uint32(block.timestamp);
869         exchangeRateInfo = _exchangeRateInfo;
870         
871         emit UpdateExchangeRate(_exchangeRate);
872     }
873 
874     // ============================================================================================
875     // Functions: Liquidations
876     // ============================================================================================
877 
878     /// @notice Allows a third party to repay a borrower's debt if they have become insolvent
879     /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling `Liquidate()`
880     /// @param _sharesToLiquidate The number of Borrow Shares repaid by the liquidator
881     /// @param _deadline The timestamp after which tx will revert
882     /// @param _borrower The account for which the repayment is credited and from whom collateral will be taken
883     /// @return _collateralForLiquidator The amount of Collateral Token transferred to the liquidator
884     function liquidate(uint128 _sharesToLiquidate, uint256 _deadline, address _borrower) external nonReentrant returns (uint256 _collateralForLiquidator) {
885         if (block.timestamp > _deadline) revert PastDeadline(block.timestamp, _deadline);
886         if (pauseSettings.liquidations) revert Paused();
887 
888         _addInterest();
889         uint256 _exchangeRate = _updateExchangeRate();
890 
891         if (_isSolvent(_borrower, _exchangeRate)) revert BorrowerSolvent(_borrower, _exchangeRate);
892 
893         // Read from state
894         BorrowAccount memory _totalBorrow = totalBorrow;
895         uint256 _userCollateralBalance = userCollateralBalance[_borrower];
896         uint128 _borrowerShares = userBorrowShares[_borrower].toUint128();
897 
898         // Prevent stack-too-deep
899         int256 _leftoverCollateral;
900         {
901             // Checks & Calculations
902             // Determine the liquidation amount in collateral units (i.e. how much debt is liquidator going to repay)
903             // uint256 _liquidationAmountInCollateralUnits = ((_totalBorrow.toAmount(_sharesToLiquidate, false) * _exchangeRate) / EXCHANGE_PRECISION);
904             uint256 _liquidationAmountInAssetUnits = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToLiquidate, false);
905             uint256 _liquidationAmountInCollateralUnits = ((_liquidationAmountInAssetUnits * _exchangeRate) / EXCHANGE_PRECISION);
906 
907             // We first optimistically calculate the amount of collateral to give the liquidator based on the higher clean liquidation fee
908             // This fee only applies if the liquidator does a full liquidation
909             uint256 _optimisticCollateralForLiquidator = (_liquidationAmountInCollateralUnits * (LIQ_PRECISION + cleanLiquidationFee)) / LIQ_PRECISION;
910 
911             // Because interest accrues every block, _liquidationAmountInCollateralUnits from a few lines up is an ever increasing value
912             // This means that leftoverCollateral can occasionally go negative by a few hundred wei (cleanLiqFee premium covers this for liquidator)
913             _leftoverCollateral = (_userCollateralBalance.toInt256() - _optimisticCollateralForLiquidator.toInt256());
914 
915             // If cleanLiquidation fee results in no leftover collateral, give liquidator all the collateral
916             // This will only be true when there liquidator is cleaning out the position
917             _collateralForLiquidator = _leftoverCollateral <= 0
918                 ? _userCollateralBalance
919                 : (_liquidationAmountInCollateralUnits * (LIQ_PRECISION + dirtyLiquidationFee)) / LIQ_PRECISION;
920         }
921         // Calculated here for use during repayment, grouped with other calcs before effects start
922         // uint128 _amountLiquidatorToRepay = (_totalBorrow.toAmount(_sharesToLiquidate, true)).toUint128();
923         uint128 _amountLiquidatorToRepay = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToLiquidate, true).toUint128();
924 
925         // Determine if and how much debt to adjust
926         uint128 _sharesToAdjust;
927         {
928             uint128 _amountToAdjust;
929             if (_leftoverCollateral <= 0) {
930                 // Determine if we need to adjust any shares
931                 _sharesToAdjust = _borrowerShares - _sharesToLiquidate;
932                 if (_sharesToAdjust > 0) {
933                     // Write off bad debt
934                     // _amountToAdjust = (_totalBorrow.toAmount(_sharesToAdjust, false)).toUint128();
935                     _amountToAdjust = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToAdjust, false).toUint128();
936 
937                     // Note: Ensure this memory struct will be passed to _repayAsset for write to state
938                     _totalBorrow.amount -= _amountToAdjust;
939 
940                     // Effects: write to state
941                     totalAUM -= _amountToAdjust;
942                 }
943             }
944             emit Liquidate(_borrower, _collateralForLiquidator, _sharesToLiquidate, _amountLiquidatorToRepay, _sharesToAdjust, _amountToAdjust);
945         }
946 
947         // Effects & Interactions
948         // NOTE: reverts if _shares > userBorrowShares
949         _repayAsset(_totalBorrow, _amountLiquidatorToRepay, _sharesToLiquidate + _sharesToAdjust, msg.sender, _borrower); // liquidator repays shares on behalf of borrower
950         // NOTE: reverts if _collateralForLiquidator > userCollateralBalance
951         // Collateral is removed on behalf of borrower and sent to liquidator
952         // NOTE: reverts if _collateralForLiquidator > userCollateralBalance
953         _removeCollateral(_collateralForLiquidator, msg.sender, _borrower);
954     }
955 }