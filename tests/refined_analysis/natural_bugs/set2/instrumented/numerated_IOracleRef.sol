1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../oracle/IOracle.sol";
5 
6 /// @title OracleRef interface
7 /// @author Fei Protocol
8 interface IOracleRef {
9     // ----------- Events -----------
10 
11     event OracleUpdate(address indexed oldOracle, address indexed newOracle);
12 
13     event InvertUpdate(bool oldDoInvert, bool newDoInvert);
14 
15     event DecimalsNormalizerUpdate(int256 oldDecimalsNormalizer, int256 newDecimalsNormalizer);
16 
17     event BackupOracleUpdate(address indexed oldBackupOracle, address indexed newBackupOracle);
18 
19     // ----------- State changing API -----------
20 
21     function updateOracle() external;
22 
23     // ----------- Governor only state changing API -----------
24 
25     function setOracle(address newOracle) external;
26 
27     function setBackupOracle(address newBackupOracle) external;
28 
29     function setDecimalsNormalizer(int256 newDecimalsNormalizer) external;
30 
31     function setDoInvert(bool newDoInvert) external;
32 
33     // ----------- Getters -----------
34 
35     function oracle() external view returns (IOracle);
36 
37     function backupOracle() external view returns (IOracle);
38 
39     function doInvert() external view returns (bool);
40 
41     function decimalsNormalizer() external view returns (int256);
42 
43     function readOracle() external view returns (Decimal.D256 memory);
44 
45     function invert(Decimal.D256 calldata price) external pure returns (Decimal.D256 memory);
46 }
