1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.10;
3 
4 import "../../metagov/utils/LiquidityGaugeManager.sol";
5 import "../IPCVDepositBalances.sol";
6 
7 /// @title AngleGaugeLens
8 /// @author Fei Protocol
9 /// @notice a contract to read tokens held in a gauge.
10 /// Angle has a small modification in their Curve fork : they name a
11 /// variable staking_token() instead of lp_token() as in the original Curve code.
12 contract AngleGaugeLens is IPCVDepositBalances {
13     /// @notice FEI token address
14     address private constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
15 
16     /// @notice the gauge inspected
17     address public immutable gaugeAddress;
18 
19     /// @notice the address of the contract staking in the gauge
20     address public immutable stakerAddress;
21 
22     /// @notice the token the lens reports balances in
23     address public immutable override balanceReportedIn;
24 
25     constructor(address _gaugeAddress, address _stakerAddress) {
26         gaugeAddress = _gaugeAddress;
27         stakerAddress = _stakerAddress;
28         balanceReportedIn = ILiquidityGauge(_gaugeAddress).staking_token();
29     }
30 
31     /// @notice returns the amount of tokens staked by stakerAddress in
32     /// the gauge gaugeAddress.
33     function balance() public view override returns (uint256) {
34         return ILiquidityGauge(gaugeAddress).balanceOf(stakerAddress);
35     }
36 
37     /// @notice returns the amount of tokens staked by stakerAddress in
38     /// the gauge gaugeAddress.
39     /// In the case where an LP token between XYZ and FEI is staked in
40     /// the gauge, this lens reports the amount of LP tokens staked, not the
41     /// underlying amounts of XYZ and FEI tokens held within the LP tokens.
42     /// This lens can be coupled with another lens in order to compute the
43     /// underlying amounts of FEI and XYZ held inside the LP tokens.
44     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
45         uint256 stakedBalance = balance();
46         if (balanceReportedIn == FEI) {
47             return (stakedBalance, stakedBalance);
48         } else {
49             return (stakedBalance, 0);
50         }
51     }
52 }
