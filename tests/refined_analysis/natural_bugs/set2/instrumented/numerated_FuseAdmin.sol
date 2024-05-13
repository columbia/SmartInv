1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./FuseGuardian.sol";
5 import "./IMasterOracle.sol";
6 
7 contract FuseAdmin is FuseGuardian {
8     error ComptrollerError();
9 
10     /// @param _core address of core contract
11     /// @param _comptroller the fuse comptroller
12     constructor(address _core, Unitroller _comptroller) FuseGuardian(_core, _comptroller) {}
13 
14     function oracleAdd(address[] calldata underlyings, address[] calldata _oracles) external onlyGovernorOrAdmin {
15         IMasterOracle(comptroller.oracle()).add(underlyings, _oracles);
16     }
17 
18     function oracleChangeAdmin(address newAdmin) external onlyGovernor {
19         IMasterOracle(comptroller.oracle()).changeAdmin(newAdmin);
20     }
21 
22     function _addRewardsDistributor(address distributor) external onlyGovernorOrAdmin {
23         if (comptroller._addRewardsDistributor(distributor) != 0) revert ComptrollerError();
24     }
25 
26     function _setWhitelistEnforcement(bool enforce) external onlyGovernorOrAdmin {
27         if (comptroller._setWhitelistEnforcement(enforce) != 0) revert ComptrollerError();
28     }
29 
30     function _setWhitelistStatuses(address[] calldata suppliers, bool[] calldata statuses)
31         external
32         onlyGovernorOrAdmin
33     {
34         if (comptroller._setWhitelistStatuses(suppliers, statuses) != 0) revert ComptrollerError();
35     }
36 
37     function _setPriceOracle(address newOracle) public onlyGovernor {
38         if (comptroller._setPriceOracle(newOracle) != 0) revert ComptrollerError();
39     }
40 
41     function _setCloseFactor(uint256 newCloseFactorMantissa) external onlyGovernorOrAdmin {
42         if (comptroller._setCloseFactor(newCloseFactorMantissa) != 0) revert ComptrollerError();
43     }
44 
45     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) public onlyGovernorOrAdmin {
46         if (comptroller._setCollateralFactor(cToken, newCollateralFactorMantissa) != 0) revert ComptrollerError();
47     }
48 
49     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external onlyGovernorOrAdmin {
50         if (comptroller._setLiquidationIncentive(newLiquidationIncentiveMantissa) != 0) revert ComptrollerError();
51     }
52 
53     function _deployMarket(
54         address underlying,
55         address irm,
56         string calldata name,
57         string calldata symbol,
58         address impl,
59         bytes calldata data,
60         uint256 reserveFactor,
61         uint256 adminFee,
62         uint256 collateralFactorMantissa
63     ) external onlyGovernorOrAdmin {
64         bytes memory constructorData = abi.encode(
65             underlying,
66             address(comptroller),
67             irm,
68             name,
69             symbol,
70             impl,
71             data,
72             reserveFactor,
73             adminFee
74         );
75 
76         if (comptroller._deployMarket(false, constructorData, collateralFactorMantissa) != 0) revert ComptrollerError();
77     }
78 
79     function _unsupportMarket(CToken cToken) external onlyGovernorOrAdmin {
80         if (comptroller._unsupportMarket(cToken) != 0) revert ComptrollerError();
81     }
82 
83     function _toggleAutoImplementations(bool enabled) public onlyGovernorOrAdmin {
84         if (comptroller._toggleAutoImplementations(enabled) != 0) revert ComptrollerError();
85     }
86 
87     function _setPendingAdmin(address newPendingAdmin) public onlyGovernorOrAdmin {
88         if (comptroller._setPendingAdmin(newPendingAdmin) != 0) revert ComptrollerError();
89     }
90 
91     function _acceptAdmin() public {
92         if (comptroller._acceptAdmin() != 0) revert ComptrollerError();
93     }
94 }
