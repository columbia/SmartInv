1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./Storage.sol";
6 
7 abstract contract Events {
8     event Genesis();
9 
10 
11     event ProxyCreated(address indexed proxy, uint moduleId);
12     event MarketActivated(address indexed underlying, address indexed eToken, address indexed dToken);
13     event PTokenActivated(address indexed underlying, address indexed pToken);
14 
15     event EnterMarket(address indexed underlying, address indexed account);
16     event ExitMarket(address indexed underlying, address indexed account);
17 
18     event Deposit(address indexed underlying, address indexed account, uint amount);
19     event Withdraw(address indexed underlying, address indexed account, uint amount);
20     event Borrow(address indexed underlying, address indexed account, uint amount);
21     event Repay(address indexed underlying, address indexed account, uint amount);
22 
23     event Liquidation(address indexed liquidator, address indexed violator, address indexed underlying, address collateral, uint repay, uint yield, uint healthScore, uint baseDiscount, uint discount);
24 
25     event TrackAverageLiquidity(address indexed account);
26     event UnTrackAverageLiquidity(address indexed account);
27     event DelegateAverageLiquidity(address indexed account, address indexed delegate);
28 
29     event PTokenWrap(address indexed underlying, address indexed account, uint amount);
30     event PTokenUnWrap(address indexed underlying, address indexed account, uint amount);
31 
32     event AssetStatus(address indexed underlying, uint totalBalances, uint totalBorrows, uint96 reserveBalance, uint poolSize, uint interestAccumulator, int96 interestRate, uint timestamp);
33 
34 
35     event RequestDeposit(address indexed account, uint amount);
36     event RequestWithdraw(address indexed account, uint amount);
37     event RequestMint(address indexed account, uint amount);
38     event RequestBurn(address indexed account, uint amount);
39     event RequestTransferEToken(address indexed from, address indexed to, uint amount);
40     event RequestDonate(address indexed account, uint amount);
41 
42     event RequestBorrow(address indexed account, uint amount);
43     event RequestRepay(address indexed account, uint amount);
44     event RequestTransferDToken(address indexed from, address indexed to, uint amount);
45 
46     event RequestLiquidate(address indexed liquidator, address indexed violator, address indexed underlying, address collateral, uint repay, uint minYield);
47 
48 
49     event InstallerSetUpgradeAdmin(address indexed newUpgradeAdmin);
50     event InstallerSetGovernorAdmin(address indexed newGovernorAdmin);
51     event InstallerInstallModule(uint indexed moduleId, address indexed moduleImpl, bytes32 moduleGitCommit);
52 
53 
54     event GovSetAssetConfig(address indexed underlying, Storage.AssetConfig newConfig);
55     event GovSetIRM(address indexed underlying, uint interestRateModel, bytes resetParams);
56     event GovSetPricingConfig(address indexed underlying, uint16 newPricingType, uint32 newPricingParameter);
57     event GovSetReserveFee(address indexed underlying, uint32 newReserveFee);
58     event GovConvertReserves(address indexed underlying, address indexed recipient, uint amount);
59     event GovSetChainlinkPriceFeed(address indexed underlying, address chainlinkAggregator);
60 
61     event RequestSwap(address indexed accountIn, address indexed accountOut, address indexed underlyingIn, address underlyingOut, uint amount, uint swapType);
62     event RequestSwapHub(address indexed accountIn, address indexed accountOut, address indexed underlyingIn, address underlyingOut, uint amountIn, uint amountOut, uint mode, address swapHandler);
63     event RequestSwapHubRepay(address indexed accountIn, address indexed accountOut, address indexed underlyingIn, address underlyingOut, uint targetDebt, address swapHandler);
64 }
