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

//  _____         _                   __              _ _         _____             _           _       
// |   __|___ ___| |_ ___ ___ ___ ___|  |   ___ ___ _| |_|___ ___|     |___ ___ ___| |_ ___ ___| |_ ___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|  |__| -_|   | . | |   | . |   --| . |   |_ -|  _| .'|   |  _|_ -|
// |__|  |___|_| |_| |_| |___|___|___|_____|___|_|_|___|_|_|_|_  |_____|___|_|_|___|_| |__,|_|_|_| |___|
//                                                           |___|                                      

// Github - https://github.com/FortressFinance

abstract contract FortressLendingConstants {

    /********************************** Constants **********************************/

    // Precision settings
    uint256 internal constant LTV_PRECISION = 1e5; // 5 decimals
    uint256 internal constant LIQ_PRECISION = 1e5;
    uint256 internal constant UTIL_PREC = 1e5;
    uint256 internal constant FEE_PRECISION = 1e5;
    uint256 internal constant EXCHANGE_PRECISION = 1e18;

    // Default Interest Rate (if borrows = 0)
    uint64 internal constant DEFAULT_INT = 158049988; // 0.5% annual rate 1e18 precision

    // Protocol Fee
    uint16 internal constant DEFAULT_PROTOCOL_FEE = 5e2; // 0.5% 1e5 precision
    uint256 internal constant MAX_PROTOCOL_FEE = 5e4; // 50% 1e5 precision

    /********************************** Errors **********************************/

    error Insolvent(address _borrower);
    error BorrowerSolvent(address _borrower, uint256 _exchangeRate);
    error OracleLTEZero(address _oracle);
    error InsufficientAssetsInContract(uint256 _amount, uint256 _availableAmount);
    error SlippageTooHigh(uint256 _amountOut, uint256 _minAmount);
    error PriceTooLarge(uint256 _price);
    error PastDeadline(uint256 _blockTimestamp, uint256 _deadline);
    error InsufficientBalance(uint256 _amount, uint256 _balance);
    error AlreadyCalledOnBlock(address _borrowwer);
    error InvalidProtocolFee();
    error ZeroAmount();
    error ZeroAddress();
    error Paused();
    error NotOwner();
    error InvalidUnderlyingAsset();

    /********************************** Events **********************************/

    /// @notice Emitted when the fees are withdrawn
    /// @param _shares Number of _shares (fTokens) redeemed
    /// @param _recipient To whom the assets were sent
    /// @param _amountToTransfer The amount of fees redeemed
    event WithdrawFees(uint256 _shares, address _recipient, uint256 _amountToTransfer);

    /// @notice Emitted when the fee is updated
    /// @param _newFee The new fee
    event UpdateFee(uint64 _newFee);

    /// @notice Emitted when a borrower increases their position
    /// @param _borrower The borrower whose account was debited
    /// @param _borrowAmount The amount of Asset Tokens transferred
    /// @param _sharesAdded The number of Borrow Shares the borrower was debited
    event BorrowAsset(address indexed _borrower, uint256 _borrowAmount, uint256 _sharesAdded);

    /// @notice Emitted whenever `repayAssetWithCollateral()` is invoked
    /// @param _borrower The borrower account for which the repayment is taking place
    /// @param _collateralToSwap The amount of Collateral Token to swap and use for repayment
    /// @param _amountAssetOut The amount of Asset Token which was repaid
    /// @param _sharesRepaid The number of Borrow Shares which were repaid
    event RepayAssetWithCollateral(address indexed _borrower, uint256 _collateralToSwap, uint256 _amountAssetOut, uint256 _sharesRepaid);

    /// @notice Emitted when a borrower takes out a new leveraged position
    /// @param _borrower The account for which the debt is debited
    /// @param _borrowAmount The amount of Asset Token to be borrowed to be borrowed
    /// @param _borrowShares The number of Borrow Shares the borrower is credited
    /// @param _initialCollateralAmount The amount of initial Collateral Tokens supplied by the borrower
    /// @param _amountCollateralOut The amount of Collateral Token which was received for the Asset Tokens
    event LeveragedPosition(address indexed _borrower, uint256 _borrowAmount, uint256 _borrowShares, uint256 _initialCollateralAmount, uint256 _amountCollateralOut);

    /// @notice Emitted when a liquidation occurs
    /// @param _borrower The borrower account for which the liquidation occurred
    /// @param _collateralForLiquidator The amount of Collateral Token transferred to the liquidator
    /// @param _sharesToLiquidate The number of Borrow Shares the liquidator repaid on behalf of the borrower
    /// @param _sharesToAdjust The number of Borrow Shares that were adjusted on liabilities and assets (a writeoff)
    event Liquidate(address indexed _borrower, uint256 _collateralForLiquidator, uint256 _sharesToLiquidate, uint256 _amountLiquidatorToRepay, uint256 _sharesToAdjust, uint256 _amountToAdjust);

    /// @notice Emitted when a collateral is added to a borrower's position
    /// @param _sender The account from which funds are transferred
    /// @param _borrower The borrower whose account will be credited
    /// @param _collateralAmount The amount of Collateral Token to be transferred
    event AddCollateral(address indexed _sender, address indexed _borrower, uint256 _collateralAmount);

    /// @notice Emitted when collateral is removed from a borrower's position
    /// @param _sender The account from which funds are transferred
    /// @param _collateralAmount The amount of Collateral Token to be transferred
    /// @param _receiver The address to which Collateral Tokens will be transferred
    event RemoveCollateral(address indexed _sender, uint256 _collateralAmount, address indexed _receiver, address indexed _borrower);

    /// @notice Emitted whenever a debt position is repaid
    /// @param _payer The address paying for the repayment
    /// @param _borrower The borrower whose account will be credited
    /// @param _amountToRepay The amount of Asset token to be transferred
    /// @param _shares The amount of Borrow Shares which will be debited from the borrower after repayment
    event RepayAsset(address indexed _payer, address indexed _borrower, uint256 _amountToRepay, uint256 _shares);

    /// @notice Emitted when interest is accrued by borrowers
    /// @param _interestEarned The total interest accrued by all borrowers
    /// @param _rate The interest rate used to calculate accrued interest
    /// @param _deltaTime The time elapsed since last interest accrual
    /// @param _feesAmount The amount of fees paid to protocol
    /// @param _feesShare The amount of shares distributed to protocol
    event AddInterest(uint256 _interestEarned, uint256 _rate, uint256 _deltaTime, uint256 _feesAmount, uint256 _feesShare);

    /// @notice Emitted when the interest rate is updated
    /// @param _ratePerSec The old interest rate (per second)
    /// @param _deltaTime The time elapsed since last update
    /// @param _utilizationRate The utilization of assets in the Pair
    /// @param _newRatePerSec The new interest rate (per second)
    event UpdateRate(uint256 _ratePerSec, uint256 _deltaTime, uint256 _utilizationRate, uint256 _newRatePerSec);

    /// @notice Emitted when the Collateral:Asset exchange rate is updated
    /// @param _rate The new rate given as the amount of Collateral Token to buy 1e18 Asset Token
    event UpdateExchangeRate(uint256 _rate);

    /// @notice Emitted when the owner is updated
    /// @param _newOwner The new owner
    event UpdateOwner(address _newOwner);

    /// @notice Emitted when the swap contract is updated
    /// @param _swap The new swap contract
    event UpdateSwap(address _swap);

    /// @notice Emitted when the pause settings are updated
    /// @param _depositLiquidity Whether depositing liquidity is paused
    /// @param _withdrawLiquidity Whether withdrawing liquidity is paused
    /// @param _addLeverage Whether adding leverage is paused
    /// @param _removeLeverage Whether removing leverage is paused
    /// @param _addInterest Whether adding interest is paused
    /// @param _liquidations Whether liquidations are paused
    /// @param _addCollateral Whether adding collateral is paused
    /// @param _removeCollateral Whether removing collateral is paused
    /// @param _repayAsset Whether repaying assets is paused
    event UpdatePauseSettings(bool _depositLiquidity, bool _withdrawLiquidity, bool _addLeverage, bool _removeLeverage, bool _addInterest, bool _liquidations, bool _addCollateral, bool _removeCollateral, bool _repayAsset);
}