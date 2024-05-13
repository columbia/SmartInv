1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.10;
3 
4 import "../../metagov/utils/LiquidityGaugeManager.sol";
5 import "../IPCVDepositBalances.sol";
6 
7 /// @title CurveGaugeLens
8 /// @author Fei Protocol
9 /// @notice a contract to read tokens held in a gauge
10 contract CurveGaugeLens is IPCVDepositBalances {
11     /// @notice FEI token address
12     address private constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
13 
14     /// @notice the gauge inspected
15     address public immutable gaugeAddress;
16 
17     /// @notice the address of the contract staking in the gauge
18     address public immutable stakerAddress;
19 
20     /// @notice the token the lens reports balances in
21     address public immutable override balanceReportedIn;
22 
23     constructor(address _gaugeAddress, address _stakerAddress) {
24         gaugeAddress = _gaugeAddress;
25         stakerAddress = _stakerAddress;
26         balanceReportedIn = ILiquidityGauge(_gaugeAddress).lp_token();
27     }
28 
29     /// @notice returns the amount of tokens staked by stakerAddress in
30     /// the gauge gaugeAddress.
31     function balance() public view override returns (uint256) {
32         return ILiquidityGauge(gaugeAddress).balanceOf(stakerAddress);
33     }
34 
35     /// @notice returns the amount of tokens staked by stakerAddress in
36     /// the gauge gaugeAddress.
37     /// In the case where an LP token between XYZ and FEI is staked in
38     /// the gauge, this lens reports the amount of LP tokens staked, not the
39     /// underlying amounts of XYZ and FEI tokens held within the LP tokens.
40     /// This lens can be coupled with another lens in order to compute the
41     /// underlying amounts of FEI and XYZ held inside the LP tokens.
42     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
43         uint256 stakedBalance = balance();
44         if (balanceReportedIn == FEI) {
45             return (stakedBalance, stakedBalance);
46         } else {
47             return (stakedBalance, 0);
48         }
49     }
50 }
