1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IOracleRef.sol";
5 import "./CoreRef.sol";
6 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
7 import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
8 
9 /// @title Reference to an Oracle
10 /// @author Fei Protocol
11 /// @notice defines some utilities around interacting with the referenced oracle
12 abstract contract OracleRef is IOracleRef, CoreRef {
13     using Decimal for Decimal.D256;
14     using SafeCast for int256;
15 
16     /// @notice the oracle reference by the contract
17     IOracle public override oracle;
18 
19     /// @notice the backup oracle reference by the contract
20     IOracle public override backupOracle;
21 
22     /// @notice number of decimals to scale oracle price by, i.e. multiplying by 10^(decimalsNormalizer)
23     int256 public override decimalsNormalizer;
24 
25     bool public override doInvert;
26 
27     /// @notice OracleRef constructor
28     /// @param _core Fei Core to reference
29     /// @param _oracle oracle to reference
30     /// @param _backupOracle backup oracle to reference
31     /// @param _decimalsNormalizer number of decimals to normalize the oracle feed if necessary
32     /// @param _doInvert invert the oracle price if this flag is on
33     constructor(
34         address _core,
35         address _oracle,
36         address _backupOracle,
37         int256 _decimalsNormalizer,
38         bool _doInvert
39     ) CoreRef(_core) {
40         _setOracle(_oracle);
41         if (_backupOracle != address(0) && _backupOracle != _oracle) {
42             _setBackupOracle(_backupOracle);
43         }
44         _setDoInvert(_doInvert);
45         _setDecimalsNormalizer(_decimalsNormalizer);
46     }
47 
48     /// @notice sets the referenced oracle
49     /// @param newOracle the new oracle to reference
50     function setOracle(address newOracle) external override onlyGovernor {
51         _setOracle(newOracle);
52     }
53 
54     /// @notice sets the flag for whether to invert or not
55     /// @param newDoInvert the new flag for whether to invert
56     function setDoInvert(bool newDoInvert) external override onlyGovernor {
57         _setDoInvert(newDoInvert);
58     }
59 
60     /// @notice sets the new decimalsNormalizer
61     /// @param newDecimalsNormalizer the new decimalsNormalizer
62     function setDecimalsNormalizer(int256 newDecimalsNormalizer) external override onlyGovernor {
63         _setDecimalsNormalizer(newDecimalsNormalizer);
64     }
65 
66     /// @notice sets the referenced backup oracle
67     /// @param newBackupOracle the new backup oracle to reference
68     function setBackupOracle(address newBackupOracle) external override onlyGovernorOrAdmin {
69         _setBackupOracle(newBackupOracle);
70     }
71 
72     /// @notice invert a peg price
73     /// @param price the peg price to invert
74     /// @return the inverted peg as a Decimal
75     /// @dev the inverted peg would be X per FEI
76     function invert(Decimal.D256 memory price) public pure override returns (Decimal.D256 memory) {
77         return Decimal.one().div(price);
78     }
79 
80     /// @notice updates the referenced oracle
81     function updateOracle() public override {
82         oracle.update();
83     }
84 
85     /// @notice the peg price of the referenced oracle
86     /// @return the peg as a Decimal
87     /// @dev the peg is defined as FEI per X with X being ETH, dollars, etc
88     function readOracle() public view override returns (Decimal.D256 memory) {
89         (Decimal.D256 memory _peg, bool valid) = oracle.read();
90         if (!valid && address(backupOracle) != address(0)) {
91             (_peg, valid) = backupOracle.read();
92         }
93         require(valid, "OracleRef: oracle invalid");
94 
95         // Invert the oracle price if necessary
96         if (doInvert) {
97             _peg = invert(_peg);
98         }
99 
100         // Scale the oracle price by token decimals delta if necessary
101         uint256 scalingFactor;
102         if (decimalsNormalizer < 0) {
103             scalingFactor = 10**(-1 * decimalsNormalizer).toUint256();
104             _peg = _peg.div(scalingFactor);
105         } else {
106             scalingFactor = 10**decimalsNormalizer.toUint256();
107             _peg = _peg.mul(scalingFactor);
108         }
109 
110         return _peg;
111     }
112 
113     function _setOracle(address newOracle) internal {
114         require(newOracle != address(0), "OracleRef: zero address");
115         address oldOracle = address(oracle);
116         oracle = IOracle(newOracle);
117         emit OracleUpdate(oldOracle, newOracle);
118     }
119 
120     // Supports zero address if no backup
121     function _setBackupOracle(address newBackupOracle) internal {
122         address oldBackupOracle = address(backupOracle);
123         backupOracle = IOracle(newBackupOracle);
124         emit BackupOracleUpdate(oldBackupOracle, newBackupOracle);
125     }
126 
127     function _setDoInvert(bool newDoInvert) internal {
128         bool oldDoInvert = doInvert;
129         doInvert = newDoInvert;
130 
131         if (oldDoInvert != newDoInvert) {
132             _setDecimalsNormalizer(-1 * decimalsNormalizer);
133         }
134 
135         emit InvertUpdate(oldDoInvert, newDoInvert);
136     }
137 
138     function _setDecimalsNormalizer(int256 newDecimalsNormalizer) internal {
139         int256 oldDecimalsNormalizer = decimalsNormalizer;
140         decimalsNormalizer = newDecimalsNormalizer;
141         emit DecimalsNormalizerUpdate(oldDecimalsNormalizer, newDecimalsNormalizer);
142     }
143 
144     function _setDecimalsNormalizerFromToken(address token) internal {
145         int256 feiDecimals = 18;
146         int256 _decimalsNormalizer = feiDecimals - int256(uint256(IERC20Metadata(token).decimals()));
147 
148         if (doInvert) {
149             _decimalsNormalizer = -1 * _decimalsNormalizer;
150         }
151 
152         _setDecimalsNormalizer(_decimalsNormalizer);
153     }
154 }
