1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../oracle/collateralization/ICollateralizationOracle.sol";
5 
6 /// @title a Tribe Reserve Stabilizer interface
7 /// @author Fei Protocol
8 interface ITribeReserveStabilizer {
9     // ----------- Events -----------
10 
11     event CollateralizationOracleUpdate(
12         address indexed oldCollateralizationOracle,
13         address indexed newCollateralizationOracle
14     );
15 
16     event CollateralizationThresholdUpdate(
17         uint256 oldCollateralizationThresholdBasisPoints,
18         uint256 newCollateralizationThresholdBasisPoints
19     );
20 
21     // ----------- Governor only state changing api -----------
22 
23     function setCollateralizationOracle(ICollateralizationOracle newCollateralizationOracle) external;
24 
25     function setCollateralizationThreshold(uint256 newCollateralizationThresholdBasisPoints) external;
26 
27     function startOracleDelayCountdown() external;
28 
29     function resetOracleDelayCountdown() external;
30 
31     // ----------- Getters -----------
32 
33     function isCollateralizationBelowThreshold() external view returns (bool);
34 
35     function collateralizationOracle() external view returns (ICollateralizationOracle);
36 
37     function collateralizationThreshold() external view returns (Decimal.D256 calldata);
38 }
