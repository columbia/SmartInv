// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
// ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
// █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
// ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
// ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
// ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
// ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
// ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
// █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
// ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
// ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
// ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

//  _____         _                   __              _ _         _____             
// |   __|___ ___| |_ ___ ___ ___ ___|  |   ___ ___ _| |_|___ ___|     |___ ___ ___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|  |__| -_|   | . | |   | . |   --| . |  _| -_|
// |__|  |___|_| |_| |_| |___|___|___|_____|___|_|_|___|_|_|_|_  |_____|___|_| |___|
//                                                           |___|                  

// Github - https://github.com/FortressFinance

import {ERC4626, ERC20} from "@solmate/mixins/ERC4626.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

import {FortressLendingConstants} from "./FortressLendingConstants.sol";
import {IRateCalculator} from "./interfaces/IRateCalculator.sol";
import {IFortressSwap} from "../fortress-interfaces/IFortressSwap.sol";
import {IFortressVault} from "../fortress-interfaces/IFortressVault.sol";

/// @notice An abstract contract which contains the core logic and storage for the FortressLendingPair
abstract contract FortressLendingCore is FortressLendingConstants, ReentrancyGuard, ERC4626 {

    using SafeERC20 for IERC20;
    using SafeCast for uint256;

    struct PauseSettings {
        bool depositLiquidity;
        bool withdrawLiquidity;
        bool addLeverage;
        bool removeLeverage;
        bool addInterest;
        bool liquidations;
        bool addCollateral;
        bool removeCollateral;
        bool repayAsset;
    }

    /********************************** Settings set by constructor() & initialize() **********************************/

    // Asset and collateral contracts
    IERC20 public immutable assetContract;
    IERC20 public immutable collateralContract;

    // Oracle wrapper contract and oracle Data
    address public immutable oracleMultiply;
    address public immutable oracleDivide;
    uint256 public immutable oracleNormalization;

    // LTV Settings
    uint256 public immutable maxLTV;

    // Liquidation Fee
    uint256 public immutable cleanLiquidationFee;
    uint256 public immutable dirtyLiquidationFee;

    // Interest Rate Calculator Contract
    IRateCalculator public immutable rateContract; // For complex rate calculations
    bytes public rateInitCallData; // Optional extra data from init function to be passed to rate calculator

    // Swapper
    address public swap;
    
    // Owner
    address public owner;

    // Pause Settings
    PauseSettings public pauseSettings;

    /********************************** Storage **********************************/

    /// @notice Stores information about the current interest rate
    /// @dev struct is packed to reduce SLOADs
    CurrentRateInfo public currentRateInfo;
    struct CurrentRateInfo {
        uint64 lastBlock;
        uint64 feeToProtocolRate; // 1e5 precision
        uint64 lastTimestamp;
        uint64 ratePerSec; // 1e18 precision
    }

    /// @notice Stores information about the current exchange rate. Collateral:Asset ratio
    /// @dev Struct packed to save SLOADs. Amount of Collateral Token to buy 1e18 Asset Token
    ExchangeRateInfo public exchangeRateInfo;
    struct ExchangeRateInfo {
        uint32 lastTimestamp;
        uint224 exchangeRate; // collateral:asset ratio. i.e. how much collateral to buy 1e18 asset
    }

    // Contract Level Accounting
    BorrowAccount public totalBorrow; // amount = total borrow amount with interest accrued, shares = total shares outstanding
    struct BorrowAccount {
        uint256 amount; // Total amount, analogous to market cap
        uint256 shares; // Total shares, analogous to shares outstanding
    }

    uint256 public totalCollateral; // total amount of collateral in contract
    uint256 public totalAUM; // total amount of assets in contract (including lent assets)
    
    // User Level Accounting
    /// @notice Stores the balance of collateral for each user
    mapping(address => uint256) public userCollateralBalance; // amount of collateral each user is backed
    /// @notice Stores the balance of borrow shares for each user
    mapping(address => uint256) public userBorrowShares; // represents the shares held by individuals
    // NOTE: user shares of assets are represented as ERC-20 tokens and accessible via balanceOf()

    // Speed Bump
    /// @notice Stores the last interaction block for each user
    mapping(address => uint256) public lastInteractionBlock;

    // ============================================================================================
    // Initialize
    // ============================================================================================

    /// @notice Called on deployment
    /// @param _configData abi.encoded config data
    /// @param _maxLTV The Maximum Loan-To-Value for a borrower to be considered solvent (1e5 precision)
    /// @param _liquidationFee The fee paid to liquidators given as a % of the repayment (1e5 precision)
    constructor(ERC20 _asset, string memory _name, string memory _symbol, bytes memory _configData, address _owner, address _swap, uint256 _maxLTV, uint256 _liquidationFee)
        ERC4626(_asset, _name, _symbol) {

        (address _collateral, address _oracleMultiply, address _oracleDivide, uint256 _oracleNormalization, address _rateContract,)
            = abi.decode(_configData, (address, address, address, uint256, address, bytes));

        // Pair Settings
        assetContract = IERC20(address(_asset));
        collateralContract = IERC20(_collateral);
        currentRateInfo.feeToProtocolRate = DEFAULT_PROTOCOL_FEE;
        cleanLiquidationFee = _liquidationFee;
        dirtyLiquidationFee = (_liquidationFee * 90000) / LIQ_PRECISION; // 90% of clean fee

        // LTV Settings
        maxLTV = _maxLTV;

        // Oracle Settings
        oracleMultiply = _oracleMultiply;
        oracleDivide = _oracleDivide;
        oracleNormalization = _oracleNormalization;

        // Rate Calculator Settings
        rateContract = IRateCalculator(_rateContract);

        // Set swap
        swap = _swap;

        // Set admins
        owner = _owner;
    }

    /// @notice Called immediately after deployment
    /// @dev This function can only be called by the owner
    /// @param _rateInitCallData The configuration data for the Rate Calculator contract
    function initialize(bytes calldata _rateInitCallData) external onlyOwner {
        // Reverts if init data is not valid
        IRateCalculator(rateContract).requireValidInitData(_rateInitCallData);

        // Set rate init Data
        rateInitCallData = _rateInitCallData;

        // Instantiate Interest
        _addInterest();

        // Instantiate Exchange Rate
        _updateExchangeRate();
    }

    // ============================================================================================
    // External Helpers
    // ============================================================================================

    /// @notice Returns the total amount of assets managed by Vault (including lent assets)
    function totalAssets() public view override returns (uint256) {
        return totalAUM;
    }

    /// @notice Calculates the shares value in relationship to `amount` and `total`
    /// @dev Given an amount, return the appropriate number of shares
    /// @param _totalAmount The total amount of assets
    /// @param _totalSupply The total supply of shares
    /// @param _amount The amount of assets to convert to shares
    /// @param _roundUp Whether to round up or down
    /// @return _shares The number of shares
    function convertToShares(uint256 _totalAmount, uint256 _totalSupply, uint256 _amount, bool _roundUp) public pure returns (uint256 _shares) {
        if (_totalAmount == 0) {
            _shares = _amount;
        } else {
            _shares = (_amount * _totalSupply) / _totalAmount;
            if (_roundUp && (_shares * _totalAmount) / _totalSupply < _amount) {
                _shares = _shares + 1;
            }
        }
    }

    /// @notice Calculates the amount value in relationship to `shares` and `total`
    /// @dev Given a number of shares, returns the appropriate amount
    /// @param _totalAmount The total amount of assets
    /// @param _totalSupply The total supply of shares
    /// @param _shares The number of shares to convert to amount
    /// @param _roundUp Whether to round up or down
    /// @return _amount The amount of assets
    function convertToAssets(uint256 _totalAmount, uint256 _totalSupply, uint256 _shares, bool _roundUp) public pure returns (uint256 _amount) {
        if (_totalSupply == 0) {
            _amount = _shares;
        } else {
            _amount = (_shares * _totalAmount) / _totalSupply;
            if (_roundUp && (_amount * _totalSupply) / _totalAmount < _shares) {
                _amount = _amount + 1;
            }
        }
    }

    /// @notice Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions
    /// @param _shares - The amount of _shares to redeem
    /// @return - The amount of _assets in return
    function previewRedeem(uint256 _shares) public view override returns (uint256) {
        uint256 _assets = convertToAssets(_shares);

        if (_assets > _totalAssetAvailable()) revert InsufficientAssetsInContract(_assets, _totalAssetAvailable());

        return _assets;
    }

    /// @notice Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions
    /// @param _assets - The amount of _assets to withdraw
    /// @return - The amount of shares to burn
    function previewWithdraw(uint256 _assets) public view override returns (uint256) {
        if (_assets > _totalAssetAvailable()) revert InsufficientAssetsInContract(_assets, _totalAssetAvailable());

        return convertToShares(_assets);
    }

    /// @notice Returns the values of all constants used in the contract
    function getConstants() external pure
        returns (
            uint256 _LTV_PRECISION,
            uint256 _LIQ_PRECISION,
            uint256 _UTIL_PREC,
            uint256 _FEE_PRECISION,
            uint256 _EXCHANGE_PRECISION,
            uint64 _DEFAULT_INT,
            uint16 _DEFAULT_PROTOCOL_FEE,
            uint256 _MAX_PROTOCOL_FEE
        )
    {
        _LTV_PRECISION = LTV_PRECISION;
        _LIQ_PRECISION = LIQ_PRECISION;
        _UTIL_PREC = UTIL_PREC;
        _FEE_PRECISION = FEE_PRECISION;
        _EXCHANGE_PRECISION = EXCHANGE_PRECISION;
        _DEFAULT_INT = DEFAULT_INT;
        _DEFAULT_PROTOCOL_FEE = DEFAULT_PROTOCOL_FEE;
        _MAX_PROTOCOL_FEE = MAX_PROTOCOL_FEE;
    }

    // ============================================================================================
    // Internal Helpers
    // ============================================================================================

    /// @notice Returns the total balance of Asset Tokens in the contract
    /// @return The balance of Asset Tokens held by contract
    function _totalAssetAvailable() internal view returns (uint256) {
        return totalAssets() - totalBorrow.amount;
    }

    /// @notice Determines if a given borrower is solvent given an exchange rate
    /// @param _borrower The borrower address to check
    /// @param _exchangeRate The exchange rate, i.e. the amount of collateral to buy 1e18 asset
    /// @return Whether borrower is solvent
    function _isSolvent(address _borrower, uint256 _exchangeRate) internal view returns (bool) {
        if (maxLTV == 0) return true;
        BorrowAccount memory _totalBorrow = totalBorrow;
        uint256 _borrowerAmount = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, userBorrowShares[_borrower], true);
        if (_borrowerAmount == 0) return true;
        uint256 _collateralAmount = userCollateralBalance[_borrower];
        if (_collateralAmount == 0) return false;

        uint256 _ltv = (((_borrowerAmount * _exchangeRate) / EXCHANGE_PRECISION) * LTV_PRECISION) / _collateralAmount;

        return _ltv <= maxLTV;
    }

    /// @notice Approves a spender to spend a given amount of a token
    /// @param _token The token to approve
    /// @param _spender The spender to approve
    /// @param _amount The amount to approve
    function _approve(address _token, address _spender, uint256 _amount) internal {
        IERC20(_token).safeApprove(_spender, 0);
        IERC20(_token).safeApprove(_spender, _amount);
    }

    // ============================================================================================
    // Modifiers
    // ============================================================================================

    /// @notice Checks that msg.sender is the owner
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    /// @notice Allows a borrower to interact with the contract only once per block
    /// @param _borrower The borrower whose interaction we are checking
    modifier speedBump(address _borrower) {
        if (lastInteractionBlock[_borrower] == block.number) revert AlreadyCalledOnBlock(_borrower);
        _;
    }

    /// @notice Checks for solvency AFTER executing contract code
    /// @param _borrower The borrower whose solvency we will check
    modifier isSolvent(address _borrower) {
        _;
        if (!_isSolvent(_borrower, exchangeRateInfo.exchangeRate)) revert Insolvent(_borrower);
    }

    // ============================================================================================
    // Functions: Configuration
    // ============================================================================================

    /// @notice Withdraws accumulated fees
    /// @param _shares Number of fTokens to redeem
    /// @param _recipient Address to send the assets
    /// @return _amountToTransfer Amount of assets sent to recipient
    function withdrawFees(uint256 _shares, address _recipient) external onlyOwner returns (uint256 _amountToTransfer) {

        // Take all available if 0 value passed
        if (_shares == 0) _shares = balanceOf[address(this)];

        // We must calculate this before we subtract from _totalAsset or invoke _burn
        _amountToTransfer = convertToAssets(totalAssets(), totalSupply, _shares, true);

        // Check for sufficient withdraw liquidity
        if (_totalAssetAvailable() < _amountToTransfer) revert InsufficientAssetsInContract(_amountToTransfer, _totalAssetAvailable());

        // Effects: bookkeeping
        totalAUM -= _amountToTransfer;
        // totalSupply -= _shares; // NOTE: this is done in `_burn` below

        // Effects: write to states
        _burn(address(this), _shares); // NOTE: will revert if _shares > balanceOf(address(this))

        // Interactions
        assetContract.safeTransfer(_recipient, _amountToTransfer);
        
        emit WithdrawFees(_shares, _recipient, _amountToTransfer);
    }

    /// @notice Updates the address of Swap contract
    /// @param _swap The new swap address
    function updateSwap(address _swap) external onlyOwner {
        swap = _swap;

        emit UpdateSwap(_swap);
    }

    /// @notice Updates the owner of the contract
    /// @param _owner The address of the new owner
    function updateOwner(address _owner) external onlyOwner {
        owner = _owner;
        
        emit UpdateOwner(_owner);
    }

    /// @notice Updates protocol fee amount
    /// @param _newFee The new fee amount
    function updateFee(uint64 _newFee) external onlyOwner {
        if (_newFee > MAX_PROTOCOL_FEE) revert InvalidProtocolFee();

        _addInterest();

        currentRateInfo.feeToProtocolRate = _newFee;
        
        emit UpdateFee(_newFee);
    }

    /// @notice Updates the pause settings
    /// @param _configData The abi.encoded new pause settings
    function updatePauseSettings(bytes memory _configData) external onlyOwner {
        
        _addInterest();

        (bool _depositLiquidity, bool _withdrawLiquidity, bool _addLeverage, bool _removeLeverage, bool _interest, bool _liquidations, bool _addCol, bool _removeCol, bool _repay)
            = abi.decode(_configData, (bool, bool, bool, bool, bool, bool, bool, bool, bool));
        
        pauseSettings = PauseSettings({
            depositLiquidity: _depositLiquidity,
            withdrawLiquidity: _withdrawLiquidity,
            addLeverage: _addLeverage,
            removeLeverage: _removeLeverage,
            addInterest: _interest,
            liquidations: _liquidations,
            addCollateral: _addCol,
            removeCollateral: _removeCol,
            repayAsset: _repay
        });

        emit UpdatePauseSettings(_depositLiquidity, _withdrawLiquidity, _addLeverage, _removeLeverage, _interest, _liquidations, _addCol, _removeCol, _repay);
    }

    // ============================================================================================
    // Functions: Lending
    // Visability: External
    // ============================================================================================

    /// @notice Allows a user to Lend Assets by specifying the amount of Asset Tokens to lend
    /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
    /// @param _assets The amount of Asset Token to transfer to Pair
    /// @param _receiver The address to receive the Asset Shares (fTokens)
    /// @return _shares The number of fTokens received for the deposit
    function deposit(uint256 _assets, address _receiver) public override nonReentrant returns (uint256 _shares) {
        _addInterest();
        
        _shares = previewDeposit(_assets);
        
        _deposit(_assets, _shares, _receiver);

        return _shares;
    }

    /// @notice Mints exact vault shares to _receiver by depositing assets
    /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
    /// @param _shares The amount of shares to mint
    /// @param _receiver The address of the receiver of shares
    /// @return _assets The amount of assets deposited
    function mint(uint256 _shares, address _receiver) public override nonReentrant returns (uint256 _assets) {
        _addInterest();

        _assets = previewMint(_shares);
        
        _deposit(_assets, _shares, _receiver);
        
        return _assets;
    }

    /// @notice Burns shares from owner and sends exact amount of assets to _receiver
    /// @param _assets The amount of assets to receive
    /// @param _receiver The address of the receiver of assets
    /// @param _owner The owner of shares
    /// @return _shares The amount of shares burned
    function withdraw(uint256 _assets, address _receiver, address _owner) public override nonReentrant returns (uint256 _shares) {
        if (_assets > maxWithdraw(_owner)) revert InsufficientBalance(_assets, maxWithdraw(_owner));

        _addInterest();

        _shares = previewWithdraw(_assets);
        
        _withdraw(_assets, _shares, _receiver, _owner);
        
        return _shares;
    }

    /// @notice Allows the caller to redeem their Asset Shares for Asset Tokens
    /// @param _shares The number of Asset Shares (fTokens) to burn for Asset Tokens
    /// @param _receiver The address to which the Asset Tokens will be transferred
    /// @param _owner The owner of the Asset Shares (fTokens)
    /// @return _assets The amount of Asset Tokens to be transferred
    function redeem(uint256 _shares, address _receiver, address _owner) public override nonReentrant returns (uint256 _assets) {
        if (_shares > maxRedeem(_owner)) revert InsufficientBalance(_shares, maxRedeem(_owner));

        _addInterest();

        _assets = previewRedeem(_shares);

        _withdraw(_assets, _shares, _receiver, _owner);
        
        return _assets;
    }

    // ============================================================================================
    // Functions: Lending
    // Visability: Internal
    // ============================================================================================

    /// @notice The nternal implementation for lending assets
    /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
    /// @param _assets The amount of Asset Token to be transferred
    /// @param _shares The amount of Asset Shares (fTokens) to be minted
    /// @param _receiver The address to receive the Asset Shares (fTokens)
    function _deposit(uint256 _assets, uint256 _shares, address _receiver) internal {
        if (pauseSettings.depositLiquidity) revert Paused();
        if (_receiver == address(0)) revert ZeroAddress();
        if (!(_assets > 0)) revert ZeroAmount();
        if (!(_shares > 0)) revert ZeroAmount();

        totalAUM += _assets;
        _mint(_receiver, _shares);
        
        assetContract.safeTransferFrom(msg.sender, address(this), _assets);
        
        emit Deposit(msg.sender, _receiver, _assets, _shares);
    }

    /// @notice The internal implementation which allows a Lender to pull their Asset Tokens out of the Pair
    /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling function
    /// @param _assets The number of Asset Tokens to return
    /// @param _shares The number of Asset Shares (fTokens) to burn
    /// @param _receiver The address to which the Asset Tokens will be transferred
    /// @param _owner The owner of the Asset Shares (fTokens)
    function _withdraw(uint256 _assets, uint256 _shares, address _receiver, address _owner) internal {
        if (pauseSettings.withdrawLiquidity) revert Paused();
        if (_receiver == address(0)) revert ZeroAddress();
        if (_owner == address(0)) revert ZeroAddress();
        if (!(_shares > 0)) revert ZeroAmount();
        if (!(_assets > 0)) revert ZeroAmount();

        if (msg.sender != _owner) {
            uint256 _allowed = allowance[_owner][msg.sender]; // Saves gas for limited approvals
            // NOTE: This will revert on underflow ensuring that allowance > shares
            if (_allowed != type(uint256).max) allowance[_owner][msg.sender] = _allowed - _shares;
        }

        _burn(_owner, _shares);
        totalAUM -= _assets;

        assetContract.safeTransfer(_receiver, _assets);

        emit Withdraw(msg.sender, _receiver, _owner, _assets, _shares);
    }

    // ============================================================================================
    // Functions: Borrowing
    // Visability: External
    // ============================================================================================

    /// @notice Allows the caller to add Collateral Token to a borrowers position
    /// @dev msg.sender must call ERC20.approve() on the Collateral Token contract prior to invocation
    /// @param _collateralAmount The amount of Collateral Token to be added to borrower's position
    /// @param _borrower The account to be credited
    function addCollateral(uint256 _collateralAmount, address _borrower) external nonReentrant speedBump(_borrower) {
        if (pauseSettings.addCollateral) revert Paused();

        lastInteractionBlock[_borrower] = block.number;

        _addInterest();

        _addCollateral(msg.sender, _collateralAmount, _borrower);
    }

    /// @notice Removes collateral from msg.sender's borrow position
    /// @dev msg.sender must be solvent after invocation or transaction will revert
    /// @param _collateralAmount The amount of Collateral Token to transfer
    /// @param _receiver The address to receive the transferred funds
    function removeCollateral(uint256 _collateralAmount, address _receiver) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) {
        if (pauseSettings.removeCollateral) revert Paused();
        
        lastInteractionBlock[msg.sender] = block.number;

        _addInterest();
        
        // Note: exchange rate is irrelevant when borrower has no debt shares
        if (userBorrowShares[msg.sender] > 0) _updateExchangeRate();
        
        _removeCollateral(_collateralAmount, _receiver, msg.sender);
    }

    /// @notice Allows the caller to pay down the debt for a given borrower
    /// @dev Caller must first invoke `ERC20.approve()` for the Asset Token contract
    /// @param _shares The number of Borrow Shares which will be repaid by the call
    /// @param _borrower The account for which the debt will be reduced
    /// @return _amountToRepay The amount of Asset Tokens which were transferred in order to repay the Borrow Shares
    function repayAsset(uint256 _shares, address _borrower) external nonReentrant speedBump(_borrower) returns (uint256 _amountToRepay) {
        if (pauseSettings.repayAsset) revert Paused();

        lastInteractionBlock[_borrower] = block.number;

        _addInterest();
        
        BorrowAccount memory _totalBorrow = totalBorrow;
        _amountToRepay = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _shares, true);
        
        _repayAsset(_totalBorrow, _amountToRepay, _shares, msg.sender, _borrower);
    }

    // ============================================================================================
    // Functions: Borrowing
    // Visability: Internal
    // ============================================================================================

    /// @notice The nternal implementation for adding collateral to a borrowers position
    /// @param _sender The source of funds for the new collateral
    /// @param _collateralAmount The amount of Collateral Token to be transferred
    /// @param _borrower The borrower account for which the collateral should be credited
    function _addCollateral(address _sender, uint256 _collateralAmount, address _borrower) internal {
        userCollateralBalance[_borrower] += _collateralAmount;
        totalCollateral += _collateralAmount;

        if (_sender != address(this)) {
            collateralContract.safeTransferFrom(_sender, address(this), _collateralAmount);
        }
        
        emit AddCollateral(_sender, _borrower, _collateralAmount);
    }
    
    /// @notice The internal implementation for removing collateral from a borrower's position
    /// @param _collateralAmount The amount of Collateral Token to remove from the borrower's position
    /// @param _receiver The address to receive the Collateral Token transferred
    /// @param _borrower The borrower whose account will be debited the Collateral amount
    function _removeCollateral(uint256 _collateralAmount, address _receiver, address _borrower) internal {
        // Following line will revert on underflow if _collateralAmount > userCollateralBalance
        userCollateralBalance[_borrower] -= _collateralAmount;
        // Following line will revert on underflow if totalCollateral < _collateralAmount
        totalCollateral -= _collateralAmount;

        if (_receiver != address(this)) {
            collateralContract.safeTransfer(_receiver, _collateralAmount);
        }

        emit RemoveCollateral(msg.sender, _collateralAmount, _receiver, _borrower);
    }

    /// @notice The internal implementation for borrowing assets
    /// @param _borrowAmount The amount of the Asset Token to borrow
    /// @return _sharesAdded The amount of borrow shares the msg.sender will be debited
    function _borrowAsset(uint256 _borrowAmount) internal returns (uint256 _sharesAdded) {
        if (_borrowAmount > _totalAssetAvailable()) revert InsufficientAssetsInContract(_borrowAmount, _totalAssetAvailable());
        
        BorrowAccount memory _totalBorrow = totalBorrow;

        _sharesAdded = convertToShares(_totalBorrow.amount, _totalBorrow.shares, _borrowAmount, true);
        _totalBorrow.amount = _totalBorrow.amount + _borrowAmount;
        _totalBorrow.shares = _totalBorrow.shares + _sharesAdded;
        
        totalBorrow = _totalBorrow;
        userBorrowShares[msg.sender] += _sharesAdded;

        emit BorrowAsset(msg.sender, _borrowAmount, _sharesAdded);
    }

    /// @notice The internal implementation for repaying a borrow position
    /// @dev The payer must have called ERC20.approve() on the Asset Token contract prior to invocation
    /// @param _totalBorrow An in memory copy of the totalBorrow VaultAccount struct
    /// @param _amountToRepay The amount of Asset Token to transfer
    /// @param _shares The number of Borrow Shares the sender is repaying
    /// @param _payer The address from which funds will be transferred
    /// @param _borrower The borrower account which will be credited
    function _repayAsset(BorrowAccount memory _totalBorrow, uint256 _amountToRepay, uint256 _shares, address _payer, address _borrower) internal {
        _totalBorrow.amount = _totalBorrow.amount - _amountToRepay;
        _totalBorrow.shares = _totalBorrow.shares - _shares;
        
        userBorrowShares[_borrower] -= _shares;
        totalBorrow = _totalBorrow;

        if (_payer != address(this)) {
            assetContract.safeTransferFrom(_payer, address(this), _amountToRepay);
        }

        emit RepayAsset(_payer, _borrower, _amountToRepay, _shares);
    }

    // ============================================================================================
    // Functions: Under Collateralized Leverage
    // ============================================================================================

    /// @notice Allows a user to enter a leveraged borrow position with minimal upfront Collateral (effectively take an under collateralized loan)
    /// @dev Caller must invoke `ERC20.approve()` on the Collateral Token contract prior to calling function
    /// @param _borrowAmount The amount of Asset Tokens borrowed
    /// @param _initialCollateralAmount The initial amount of Collateral Tokens supplied by the borrower
    /// @param _minAmount The minimum amount of Collateral Tokens to be received in exchange for the borrowed Asset Tokens
    /// @param _underlyingAsset The address of the underlying asset to be deposited into the Vault, which will be swapped for Collateral Tokens
    /// @return _totalCollateralAdded The total amount of Collateral Tokens added to a users account (initial + swap)
    function leveragePosition(uint256 _borrowAmount, uint256 _initialCollateralAmount, uint256 _minAmount, address _underlyingAsset) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) returns (uint256 _totalCollateralAdded) {
        if (ERC20(address(_underlyingAsset)).decimals() != ERC20(address(assetContract)).decimals()) revert InvalidUnderlyingAsset();
        if (pauseSettings.addLeverage) revert Paused();

        lastInteractionBlock[msg.sender] = block.number;

        _addInterest();
        _updateExchangeRate();

        // Add initial collateral
        if (_initialCollateralAmount > 0) _addCollateral(msg.sender, _initialCollateralAmount, msg.sender);

        // Debit borrowers (msg.sender) account
        uint256 _borrowShares = _borrowAsset(_borrowAmount);

        uint256 _underlyingAmount;
        address _asset = address(assetContract);
        if (_asset != _underlyingAsset) {
            address _swap = address(swap);
            _approve(_asset, _swap, _borrowAmount);
            _underlyingAmount = IFortressSwap(_swap).swap(_asset, _underlyingAsset, _borrowAmount);
        } else {
            _underlyingAmount = _borrowAmount;
        }

        address _collateralContract = address(collateralContract);
        _approve(_underlyingAsset, _collateralContract, _underlyingAmount);
        uint256 _amountCollateralOut = IFortressVault(_collateralContract).depositUnderlying(_underlyingAsset, address(this), _underlyingAmount, 0);
        if (_amountCollateralOut < _minAmount) revert SlippageTooHigh(_amountCollateralOut, _minAmount);

        // address(this) as _sender means no transfer occurs as the pair has already received the collateral during swap
        _addCollateral(address(this), _amountCollateralOut, msg.sender);
        
        emit LeveragedPosition(msg.sender, _borrowAmount, _borrowShares, _initialCollateralAmount, _amountCollateralOut);

        return _initialCollateralAmount + _amountCollateralOut;
    }

    /// @notice Allows a borrower to repay their debt using existing collateral in contract
    /// @param _collateralToSwap The amount of Collateral Tokens to swap for Asset Tokens
    /// @param _minAmount The minimum amount of Asset Tokens to receive during the swap
    /// @return _amountAssetOut The amount of Asset Tokens received for the Collateral Tokens, the amount the borrowers account was credited
    function repayAssetWithCollateral(uint256 _collateralToSwap, uint256 _minAmount, address _underlyingAsset) external nonReentrant speedBump(msg.sender) isSolvent(msg.sender) returns (uint256 _amountAssetOut) {
        if (ERC20(address(_underlyingAsset)).decimals() != ERC20(address(assetContract)).decimals()) revert InvalidUnderlyingAsset();
        if (pauseSettings.removeLeverage) revert Paused();

        lastInteractionBlock[msg.sender] = block.number;

        _addInterest();
        _updateExchangeRate();

        // Note: Debit users collateral balance in preparation for swap, setting _recipient to address(this) means no transfer occurs
        _removeCollateral(_collateralToSwap, address(this), msg.sender);
        _amountAssetOut = IFortressVault(address(collateralContract)).redeemUnderlying(_underlyingAsset, address(this), address(this), _collateralToSwap, 0);
        
        address _asset = address(assetContract);

        if (_underlyingAsset != _asset) {
            _approve(_underlyingAsset, swap, _amountAssetOut);
            _amountAssetOut = IFortressSwap(swap).swap(_underlyingAsset, _asset, _amountAssetOut);
        }

        if (_amountAssetOut < _minAmount) revert SlippageTooHigh(_amountAssetOut, _minAmount);

        BorrowAccount memory _totalBorrow = totalBorrow;
        uint256 _sharesToRepay = convertToShares(_totalBorrow.amount, _totalBorrow.shares, _amountAssetOut, false);

        // Note: Setting _payer to address(this) means no actual transfer will occur.  Contract already has funds
        _repayAsset(_totalBorrow, _amountAssetOut, _sharesToRepay, address(this), msg.sender);

        emit RepayAssetWithCollateral(msg.sender, _collateralToSwap, _amountAssetOut, _sharesToRepay);
    }

    // ============================================================================================
    // Functions: Interest Accumulation and Adjustment
    // ============================================================================================

    /// @notice The public implementation of `_addInterest` and allows 3rd parties to trigger interest accrual
    /// @return _interestEarned The amount of interest accrued by all borrowers
    function addInterest() external nonReentrant returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate) {
        return _addInterest();
    }

    /// @notice Invoked prior to every external function and is used to accrue interest and update interest rate
    /// @dev Can only called once per block
    /// @return _interestEarned The amount of interest accrued by all borrowers
    function _addInterest() internal returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate) {
        // Add interest only once per block
        CurrentRateInfo memory _currentRateInfo = currentRateInfo;
        if (_currentRateInfo.lastTimestamp == block.timestamp) {
            _newRate = _currentRateInfo.ratePerSec;
            return (_interestEarned, _feesAmount, _feesShare, _newRate);
        }

        uint256 _totalAsset = totalAssets();
        BorrowAccount memory _totalBorrow = totalBorrow;
        
        // If there are no borrows or contract is paused, no interest accrues and we reset interest rate
        if (_totalBorrow.shares == 0 || pauseSettings.addInterest) {
            if (!pauseSettings.addInterest) {
                _currentRateInfo.ratePerSec = DEFAULT_INT;
            }
            _currentRateInfo.lastTimestamp = uint64(block.timestamp);
            _currentRateInfo.lastBlock = uint64(block.number);

            currentRateInfo = _currentRateInfo;
        } else {
            // We know totalBorrow.shares > 0
            uint256 _deltaTime = block.timestamp - _currentRateInfo.lastTimestamp;

            // NOTE: Violates Checks-Effects-Interactions pattern
            // Be sure to mark external version NONREENTRANT (even though rateContract is trusted)
            // Calc new rate
            uint256 _utilizationRate = (UTIL_PREC * _totalBorrow.amount) / _totalAsset;
            
            bytes memory _rateData = abi.encode(_currentRateInfo.ratePerSec, _deltaTime, _utilizationRate, block.number - _currentRateInfo.lastBlock);
            _newRate = IRateCalculator(rateContract).getNewRate(_rateData, rateInitCallData);

            emit UpdateRate(_currentRateInfo.ratePerSec, _deltaTime, _utilizationRate, _newRate);

            // Effects: bookkeeping
            _currentRateInfo.ratePerSec = _newRate;
            _currentRateInfo.lastTimestamp = uint64(block.timestamp);
            _currentRateInfo.lastBlock = uint64(block.number);

            // Calculate interest accrued
            _interestEarned = (_deltaTime * _totalBorrow.amount * _currentRateInfo.ratePerSec) / 1e18;

            // Accumulate interest and fees
            _totalBorrow.amount = _totalBorrow.amount + _interestEarned;
            _totalAsset = _totalAsset + _interestEarned;
            
            if (_currentRateInfo.feeToProtocolRate > 0) {
                _feesAmount = (_interestEarned * _currentRateInfo.feeToProtocolRate) / FEE_PRECISION;

                _feesShare = (_feesAmount * totalSupply) / (_totalAsset - _feesAmount);
                
                // Effects: write to storage
                _mint(address(this), _feesShare);
            }
            emit AddInterest(_interestEarned, _currentRateInfo.ratePerSec, _deltaTime, _feesAmount, _feesShare);

            // Effects: write to storage
            currentRateInfo = _currentRateInfo;
            totalBorrow = _totalBorrow;
            totalAUM = _totalAsset;
        }
    }

    // ============================================================================================
    // Functions: ExchangeRate
    // ============================================================================================

    /// @notice The external implementation of `_updateExchangeRate`
    /// @dev This function is invoked at most once per block as these queries can be expensive
    /// @return _exchangeRate The new exchange rate
    function updateExchangeRate() external nonReentrant returns (uint256 _exchangeRate) {
        _exchangeRate = _updateExchangeRate();
    }

    /// @notice Retrieves the latest exchange rate. i.e how much collateral to buy 1e18 asset
    /// @dev This function is invoked at most once per block as these queries can be expensive
    /// @return _exchangeRate The new exchange rate
    function _updateExchangeRate() internal returns (uint256 _exchangeRate) {
        ExchangeRateInfo memory _exchangeRateInfo = exchangeRateInfo;
        if (_exchangeRateInfo.lastTimestamp == block.timestamp) {
            return _exchangeRate = _exchangeRateInfo.exchangeRate;
        }

        uint256 _price = uint256(1e36);
        address _oracleMultiply = oracleMultiply;
        if (_oracleMultiply != address(0)) {
            (, int256 _answer, , , ) = AggregatorV3Interface(_oracleMultiply).latestRoundData();
            if (_answer <= 0) {
                revert OracleLTEZero(_oracleMultiply);
            }
            _price = _price * uint256(_answer);
        }

        address _oracleDivide = oracleDivide;
        if (_oracleDivide != address(0)) {
            (, int256 _answer, , , ) = AggregatorV3Interface(_oracleDivide).latestRoundData();
            if (_answer <= 0) {
                revert OracleLTEZero(_oracleDivide);
            }
            _price = _price / uint256(_answer);
        }

        _exchangeRate = _price / oracleNormalization;
        if (_exchangeRate > type(uint224).max) revert PriceTooLarge(_exchangeRate);

        _exchangeRateInfo.exchangeRate = uint224(_exchangeRate);
        _exchangeRateInfo.lastTimestamp = uint32(block.timestamp);
        exchangeRateInfo = _exchangeRateInfo;
        
        emit UpdateExchangeRate(_exchangeRate);
    }

    // ============================================================================================
    // Functions: Liquidations
    // ============================================================================================

    /// @notice Allows a third party to repay a borrower's debt if they have become insolvent
    /// @dev Caller must invoke `ERC20.approve` on the Asset Token contract prior to calling `Liquidate()`
    /// @param _sharesToLiquidate The number of Borrow Shares repaid by the liquidator
    /// @param _deadline The timestamp after which tx will revert
    /// @param _borrower The account for which the repayment is credited and from whom collateral will be taken
    /// @return _collateralForLiquidator The amount of Collateral Token transferred to the liquidator
    function liquidate(uint128 _sharesToLiquidate, uint256 _deadline, address _borrower) external nonReentrant returns (uint256 _collateralForLiquidator) {
        if (block.timestamp > _deadline) revert PastDeadline(block.timestamp, _deadline);
        if (pauseSettings.liquidations) revert Paused();

        _addInterest();
        uint256 _exchangeRate = _updateExchangeRate();

        if (_isSolvent(_borrower, _exchangeRate)) revert BorrowerSolvent(_borrower, _exchangeRate);

        // Read from state
        BorrowAccount memory _totalBorrow = totalBorrow;
        uint256 _userCollateralBalance = userCollateralBalance[_borrower];
        uint128 _borrowerShares = userBorrowShares[_borrower].toUint128();

        // Prevent stack-too-deep
        int256 _leftoverCollateral;
        {
            // Checks & Calculations
            // Determine the liquidation amount in collateral units (i.e. how much debt is liquidator going to repay)
            // uint256 _liquidationAmountInCollateralUnits = ((_totalBorrow.toAmount(_sharesToLiquidate, false) * _exchangeRate) / EXCHANGE_PRECISION);
            uint256 _liquidationAmountInAssetUnits = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToLiquidate, false);
            uint256 _liquidationAmountInCollateralUnits = ((_liquidationAmountInAssetUnits * _exchangeRate) / EXCHANGE_PRECISION);

            // We first optimistically calculate the amount of collateral to give the liquidator based on the higher clean liquidation fee
            // This fee only applies if the liquidator does a full liquidation
            uint256 _optimisticCollateralForLiquidator = (_liquidationAmountInCollateralUnits * (LIQ_PRECISION + cleanLiquidationFee)) / LIQ_PRECISION;

            // Because interest accrues every block, _liquidationAmountInCollateralUnits from a few lines up is an ever increasing value
            // This means that leftoverCollateral can occasionally go negative by a few hundred wei (cleanLiqFee premium covers this for liquidator)
            _leftoverCollateral = (_userCollateralBalance.toInt256() - _optimisticCollateralForLiquidator.toInt256());

            // If cleanLiquidation fee results in no leftover collateral, give liquidator all the collateral
            // This will only be true when there liquidator is cleaning out the position
            _collateralForLiquidator = _leftoverCollateral <= 0
                ? _userCollateralBalance
                : (_liquidationAmountInCollateralUnits * (LIQ_PRECISION + dirtyLiquidationFee)) / LIQ_PRECISION;
        }
        // Calculated here for use during repayment, grouped with other calcs before effects start
        // uint128 _amountLiquidatorToRepay = (_totalBorrow.toAmount(_sharesToLiquidate, true)).toUint128();
        uint128 _amountLiquidatorToRepay = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToLiquidate, true).toUint128();

        // Determine if and how much debt to adjust
        uint128 _sharesToAdjust;
        {
            uint128 _amountToAdjust;
            if (_leftoverCollateral <= 0) {
                // Determine if we need to adjust any shares
                _sharesToAdjust = _borrowerShares - _sharesToLiquidate;
                if (_sharesToAdjust > 0) {
                    // Write off bad debt
                    // _amountToAdjust = (_totalBorrow.toAmount(_sharesToAdjust, false)).toUint128();
                    _amountToAdjust = convertToAssets(_totalBorrow.amount, _totalBorrow.shares, _sharesToAdjust, false).toUint128();

                    // Note: Ensure this memory struct will be passed to _repayAsset for write to state
                    _totalBorrow.amount -= _amountToAdjust;

                    // Effects: write to state
                    totalAUM -= _amountToAdjust;
                }
            }
            emit Liquidate(_borrower, _collateralForLiquidator, _sharesToLiquidate, _amountLiquidatorToRepay, _sharesToAdjust, _amountToAdjust);
        }

        // Effects & Interactions
        // NOTE: reverts if _shares > userBorrowShares
        _repayAsset(_totalBorrow, _amountLiquidatorToRepay, _sharesToLiquidate + _sharesToAdjust, msg.sender, _borrower); // liquidator repays shares on behalf of borrower
        // NOTE: reverts if _collateralForLiquidator > userCollateralBalance
        // Collateral is removed on behalf of borrower and sent to liquidator
        // NOTE: reverts if _collateralForLiquidator > userCollateralBalance
        _removeCollateral(_collateralForLiquidator, msg.sender, _borrower);
    }
}