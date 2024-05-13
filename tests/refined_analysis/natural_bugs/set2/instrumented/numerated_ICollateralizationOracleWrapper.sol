1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ICollateralizationOracle.sol";
5 
6 /// @title Collateralization ratio oracle interface for Fei Protocol
7 /// @author Fei Protocol
8 interface ICollateralizationOracleWrapper is ICollateralizationOracle {
9     // ----------- Events ------------------------------------------------------
10 
11     event CachedValueUpdate(
12         address from,
13         uint256 indexed protocolControlledValue,
14         uint256 indexed userCirculatingFei,
15         int256 indexed protocolEquity
16     );
17 
18     event CollateralizationOracleUpdate(
19         address from,
20         address indexed oldOracleAddress,
21         address indexed newOracleAddress
22     );
23 
24     event DeviationThresholdUpdate(address from, uint256 indexed oldThreshold, uint256 indexed newThreshold);
25 
26     event ReadPauseOverrideUpdate(bool readPauseOverride);
27 
28     // ----------- Public state changing api -----------
29 
30     function updateIfOutdated() external;
31 
32     // ----------- Governor only state changing api -----------
33     function setValidityDuration(uint256 _validityDuration) external;
34 
35     function setReadPauseOverride(bool newReadPauseOverride) external;
36 
37     function setDeviationThresholdBasisPoints(uint256 _newDeviationThresholdBasisPoints) external;
38 
39     function setCollateralizationOracle(address _newCollateralizationOracle) external;
40 
41     function setCache(
42         uint256 protocolControlledValue,
43         uint256 userCirculatingFei,
44         int256 protocolEquity
45     ) external;
46 
47     // ----------- Getters -----------
48 
49     function cachedProtocolControlledValue() external view returns (uint256);
50 
51     function cachedUserCirculatingFei() external view returns (uint256);
52 
53     function cachedProtocolEquity() external view returns (int256);
54 
55     function deviationThresholdBasisPoints() external view returns (uint256);
56 
57     function collateralizationOracle() external view returns (address);
58 
59     function isOutdatedOrExceededDeviationThreshold() external view returns (bool);
60 
61     function pcvStatsCurrent()
62         external
63         view
64         returns (
65             uint256 protocolControlledValue,
66             uint256 userCirculatingFei,
67             int256 protocolEquity,
68             bool validityStatus
69         );
70 
71     function isExceededDeviationThreshold() external view returns (bool);
72 
73     function readPauseOverride() external view returns (bool);
74 }
