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
17 //  _____         _                   __              _ _         _____             _           _       
18 // |   __|___ ___| |_ ___ ___ ___ ___|  |   ___ ___ _| |_|___ ___|     |___ ___ ___| |_ ___ ___| |_ ___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|  |__| -_|   | . | |   | . |   --| . |   |_ -|  _| .'|   |  _|_ -|
20 // |__|  |___|_| |_| |_| |___|___|___|_____|___|_|_|___|_|_|_|_  |_____|___|_|_|___|_| |__,|_|_|_| |___|
21 //                                                           |___|                                      
22 
23 // Github - https://github.com/FortressFinance
24 
25 abstract contract FortressLendingConstants {
26 
27     /********************************** Constants **********************************/
28 
29     // Precision settings
30     uint256 internal constant LTV_PRECISION = 1e5; // 5 decimals
31     uint256 internal constant LIQ_PRECISION = 1e5;
32     uint256 internal constant UTIL_PREC = 1e5;
33     uint256 internal constant FEE_PRECISION = 1e5;
34     uint256 internal constant EXCHANGE_PRECISION = 1e18;
35 
36     // Default Interest Rate (if borrows = 0)
37     uint64 internal constant DEFAULT_INT = 158049988; // 0.5% annual rate 1e18 precision
38 
39     // Protocol Fee
40     uint16 internal constant DEFAULT_PROTOCOL_FEE = 5e2; // 0.5% 1e5 precision
41     uint256 internal constant MAX_PROTOCOL_FEE = 5e4; // 50% 1e5 precision
42 
43     /********************************** Errors **********************************/
44 
45     error Insolvent(address _borrower);
46     error BorrowerSolvent(address _borrower, uint256 _exchangeRate);
47     error OracleLTEZero(address _oracle);
48     error InsufficientAssetsInContract(uint256 _amount, uint256 _availableAmount);
49     error SlippageTooHigh(uint256 _amountOut, uint256 _minAmount);
50     error PriceTooLarge(uint256 _price);
51     error PastDeadline(uint256 _blockTimestamp, uint256 _deadline);
52     error InsufficientBalance(uint256 _amount, uint256 _balance);
53     error AlreadyCalledOnBlock(address _borrowwer);
54     error InvalidProtocolFee();
55     error ZeroAmount();
56     error ZeroAddress();
57     error Paused();
58     error NotOwner();
59     error InvalidUnderlyingAsset();
60 
61     /********************************** Events **********************************/
62 
63     /// @notice Emitted when the fees are withdrawn
64     /// @param _shares Number of _shares (fTokens) redeemed
65     /// @param _recipient To whom the assets were sent
66     /// @param _amountToTransfer The amount of fees redeemed
67     event WithdrawFees(uint256 _shares, address _recipient, uint256 _amountToTransfer);
68 
69     /// @notice Emitted when the fee is updated
70     /// @param _newFee The new fee
71     event UpdateFee(uint64 _newFee);
72 
73     /// @notice Emitted when a borrower increases their position
74     /// @param _borrower The borrower whose account was debited
75     /// @param _borrowAmount The amount of Asset Tokens transferred
76     /// @param _sharesAdded The number of Borrow Shares the borrower was debited
77     event BorrowAsset(address indexed _borrower, uint256 _borrowAmount, uint256 _sharesAdded);
78 
79     /// @notice Emitted whenever `repayAssetWithCollateral()` is invoked
80     /// @param _borrower The borrower account for which the repayment is taking place
81     /// @param _collateralToSwap The amount of Collateral Token to swap and use for repayment
82     /// @param _amountAssetOut The amount of Asset Token which was repaid
83     /// @param _sharesRepaid The number of Borrow Shares which were repaid
84     event RepayAssetWithCollateral(address indexed _borrower, uint256 _collateralToSwap, uint256 _amountAssetOut, uint256 _sharesRepaid);
85 
86     /// @notice Emitted when a borrower takes out a new leveraged position
87     /// @param _borrower The account for which the debt is debited
88     /// @param _borrowAmount The amount of Asset Token to be borrowed to be borrowed
89     /// @param _borrowShares The number of Borrow Shares the borrower is credited
90     /// @param _initialCollateralAmount The amount of initial Collateral Tokens supplied by the borrower
91     /// @param _amountCollateralOut The amount of Collateral Token which was received for the Asset Tokens
92     event LeveragedPosition(address indexed _borrower, uint256 _borrowAmount, uint256 _borrowShares, uint256 _initialCollateralAmount, uint256 _amountCollateralOut);
93 
94     /// @notice Emitted when a liquidation occurs
95     /// @param _borrower The borrower account for which the liquidation occurred
96     /// @param _collateralForLiquidator The amount of Collateral Token transferred to the liquidator
97     /// @param _sharesToLiquidate The number of Borrow Shares the liquidator repaid on behalf of the borrower
98     /// @param _sharesToAdjust The number of Borrow Shares that were adjusted on liabilities and assets (a writeoff)
99     event Liquidate(address indexed _borrower, uint256 _collateralForLiquidator, uint256 _sharesToLiquidate, uint256 _amountLiquidatorToRepay, uint256 _sharesToAdjust, uint256 _amountToAdjust);
100 
101     /// @notice Emitted when a collateral is added to a borrower's position
102     /// @param _sender The account from which funds are transferred
103     /// @param _borrower The borrower whose account will be credited
104     /// @param _collateralAmount The amount of Collateral Token to be transferred
105     event AddCollateral(address indexed _sender, address indexed _borrower, uint256 _collateralAmount);
106 
107     /// @notice Emitted when collateral is removed from a borrower's position
108     /// @param _sender The account from which funds are transferred
109     /// @param _collateralAmount The amount of Collateral Token to be transferred
110     /// @param _receiver The address to which Collateral Tokens will be transferred
111     event RemoveCollateral(address indexed _sender, uint256 _collateralAmount, address indexed _receiver, address indexed _borrower);
112 
113     /// @notice Emitted whenever a debt position is repaid
114     /// @param _payer The address paying for the repayment
115     /// @param _borrower The borrower whose account will be credited
116     /// @param _amountToRepay The amount of Asset token to be transferred
117     /// @param _shares The amount of Borrow Shares which will be debited from the borrower after repayment
118     event RepayAsset(address indexed _payer, address indexed _borrower, uint256 _amountToRepay, uint256 _shares);
119 
120     /// @notice Emitted when interest is accrued by borrowers
121     /// @param _interestEarned The total interest accrued by all borrowers
122     /// @param _rate The interest rate used to calculate accrued interest
123     /// @param _deltaTime The time elapsed since last interest accrual
124     /// @param _feesAmount The amount of fees paid to protocol
125     /// @param _feesShare The amount of shares distributed to protocol
126     event AddInterest(uint256 _interestEarned, uint256 _rate, uint256 _deltaTime, uint256 _feesAmount, uint256 _feesShare);
127 
128     /// @notice Emitted when the interest rate is updated
129     /// @param _ratePerSec The old interest rate (per second)
130     /// @param _deltaTime The time elapsed since last update
131     /// @param _utilizationRate The utilization of assets in the Pair
132     /// @param _newRatePerSec The new interest rate (per second)
133     event UpdateRate(uint256 _ratePerSec, uint256 _deltaTime, uint256 _utilizationRate, uint256 _newRatePerSec);
134 
135     /// @notice Emitted when the Collateral:Asset exchange rate is updated
136     /// @param _rate The new rate given as the amount of Collateral Token to buy 1e18 Asset Token
137     event UpdateExchangeRate(uint256 _rate);
138 
139     /// @notice Emitted when the owner is updated
140     /// @param _newOwner The new owner
141     event UpdateOwner(address _newOwner);
142 
143     /// @notice Emitted when the swap contract is updated
144     /// @param _swap The new swap contract
145     event UpdateSwap(address _swap);
146 
147     /// @notice Emitted when the pause settings are updated
148     /// @param _depositLiquidity Whether depositing liquidity is paused
149     /// @param _withdrawLiquidity Whether withdrawing liquidity is paused
150     /// @param _addLeverage Whether adding leverage is paused
151     /// @param _removeLeverage Whether removing leverage is paused
152     /// @param _addInterest Whether adding interest is paused
153     /// @param _liquidations Whether liquidations are paused
154     /// @param _addCollateral Whether adding collateral is paused
155     /// @param _removeCollateral Whether removing collateral is paused
156     /// @param _repayAsset Whether repaying assets is paused
157     event UpdatePauseSettings(bool _depositLiquidity, bool _withdrawLiquidity, bool _addLeverage, bool _removeLeverage, bool _addInterest, bool _liquidations, bool _addCollateral, bool _removeCollateral, bool _repayAsset);
158 }