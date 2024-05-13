1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
5 
6 /**
7  * @author Brean
8  * @title LibCases handles the cases for beanstalk.
9  *
10  * @dev Cases are used to determine the change in
11  * temperature and Bean to maxLP gaugePoint per BDV ratio.
12  *
13  *  Data format:
14  *
15  * mT: 4 Bytes (1% = 1e6)
16  * bT: 1 Bytes (1% = 1)
17  * mL: 10 Bytes (1% = 1e18)
18  * bL: 10 Bytes (1% = 1e18)
19  * 7 bytes are left for future use.
20  *
21  * Temperature and Bean and maxLP gaugePoint per BDV ratio is updated as such:
22  * T_n = mT * T_n-1 + bT
23  * L_n = mL * L_n-1 + bL
24  *
25  * In total, there are 144 cases (4 * 3 * 3 * 4)
26  *
27  * temperature is stored in AppStorage with 0 decimal precision (1% = 1),
28  * which is why bT has 0 decimal precision.
29  *
30  */
31 
32 library LibCases {
33 
34     struct CaseData {
35         uint32 mT;
36         int8 bT;
37         uint80 mL;
38         int80 bL;
39     }
40 
41 
42     // constants are used for reability purposes, 
43     // given that multiple cases use the same values.
44     //
45     // Naming Convention:
46     // PLUS: increment by X (y_i = y_1 + X)
47     // MINUS decrement by X (y_i = y_1 - X)
48     // INCR: scale up by X (y_i = y_1 * X)
49     // DECR: scale down by X (y_i = y_1 * (1-X))
50     // T: Temperature, L: Bean to max LP gauge point per BDV ratio
51     // Example: T_PLUS_3_L_MINUS_FIFTY-> Temperature is incremented 3%, 
52     // BeantoMaxLPGaugePointPerBdvRatio is decrement by 50%.
53     //                                                                     bT
54     //////////////////////////////////////////////////////////     [  mT  ][][       mL         ][       BL         ][    null    ]
55     bytes32 internal constant   T_PLUS_3_L_MINUS_FIFTY = bytes32(0x05F5E1000300056BC75E2D63100000FFFD4A1C50E94E78000000000000000000); // temperature increased by 3%, Bean2maxLpGpPerBdv decreased by 50.
56     bytes32 internal constant   T_PLUS_1_L_MINUS_FIFTY = bytes32(0x05F5E1000100056BC75E2D63100000FFFD4A1C50E94E78000000000000000000); // temperature increased by 1%, Bean2maxLpGpPerBdv decreased by 50.
57     bytes32 internal constant   T_PLUS_0_L_MINUS_FIFTY = bytes32(0x05F5E1000000056BC75E2D63100000FFFD4A1C50E94E78000000000000000000); // temperature increased by 0%, Bean2maxLpGpPerBdv decreased by 50.
58     bytes32 internal constant  T_MINUS_1_L_MINUS_FIFTY = bytes32(0x05F5E100FF00056BC75E2D63100000FFFD4A1C50E94E78000000000000000000); // temperature decreased by 1%, Bean2maxLpGpPerBdv decreased by 50.
59     bytes32 internal constant  T_MINUS_3_L_MINUS_FIFTY = bytes32(0x05F5E100FD00056BC75E2D63100000FFFD4A1C50E94E78000000000000000000); // temperature decreased by 3%, Bean2maxLpGpPerBdv decreased by 50.
60     //////////////////////////////////////////////////////////  [  mT  ][][       mL         ][       BL         ][    null    ]
61     bytes32 internal constant   T_PLUS_3_L_PLUS_ONE = bytes32(0x05F5E1000300056BC75E2D6310000000000DE0B6B3A764000000000000000000); // temperature increased by 3%, Bean2maxLpGpPerBdv increased by 1.
62     bytes32 internal constant   T_PLUS_1_L_PLUS_ONE = bytes32(0x05F5E1000100056BC75E2D6310000000000DE0B6B3A764000000000000000000); // temperature increased by 1%, Bean2maxLpGpPerBdv increased by 1.
63     bytes32 internal constant   T_PLUS_0_L_PLUS_ONE = bytes32(0x05F5E1000000056BC75E2D6310000000000DE0B6B3A764000000000000000000); // temperature increased by 0%, Bean2maxLpGpPerBdv increased by 1.
64     //////////////////////////////////////////////////////////  [  mT  ][][       mL         ][       BL         ][    null    ]
65     bytes32 internal constant   T_PLUS_3_L_PLUS_TWO = bytes32(0x05F5E1000300056BC75E2D6310000000001BC16D674EC8000000000000000000); // temperature increased by 3%, Bean2maxLpGpPerBdv increased by 2.
66     bytes32 internal constant   T_PLUS_1_L_PLUS_TWO = bytes32(0x05F5E1000100056BC75E2D6310000000001BC16D674EC8000000000000000000); // temperature increased by 1%, Bean2maxLpGpPerBdv increased by 2.
67     bytes32 internal constant   T_PLUS_0_L_PLUS_TWO = bytes32(0x05F5E1000000056BC75E2D6310000000001BC16D674EC8000000000000000000); // temperature increased by 0%, Bean2maxLpGpPerBdv increased by 2.
68     //////////////////////////////////////////////////////////  [  mT  ][][       mL         ][       BL         ][    null    ]
69     bytes32 internal constant  T_PLUS_0_L_MINUS_ONE = bytes32(0x05F5E1000000056BC75E2D63100000FFFFF21F494C589C000000000000000000); // temperature increased by 0%, Bean2maxLpGpPerBdv decreased by 1.
70     bytes32 internal constant T_MINUS_1_L_MINUS_ONE = bytes32(0x05F5E100FF00056BC75E2D63100000FFFFF21F494C589C000000000000000000); // temperature decreased by 1%, Bean2maxLpGpPerBdv decreased by 1.
71     bytes32 internal constant T_MINUS_3_L_MINUS_ONE = bytes32(0x05F5E100FD00056BC75E2D63100000FFFFF21F494C589C000000000000000000); // temperature decreased by 3%, Bean2maxLpGpPerBdv decreased by 1.
72 
73     /**
74      * @notice given a caseID (0-144), return the caseData.
75      *
76      * CaseV2 allows developers to change both the absolute
77      * and relative change in temperature and bean to maxLP gaugePoint to BDV ratio,
78      * with greater precision than CaseV1.
79      *
80      */
81     function getDataFromCase(uint256 caseId) internal view returns (bytes32 caseData) {
82         AppStorage storage s = LibAppStorage.diamondStorage();
83         return s.casesV2[caseId];
84     }
85 
86     /**
87      * @notice given a caseID (0-144), return the data associated.
88      * @dev * Each case outputs 4 variables:
89      * mT: Relative Temperature change. (1% = 1e6)
90      * bT: Absolute Temperature change. (1% = 1)
91      * mL: Relative Grown Stalk to Liquidity change. (1% = 1e18)
92      * bL: Absolute Grown Stalk to Liquidity change. (1% = 1e18)
93      */
94     function decodeCaseData(uint256 caseId) internal view returns (CaseData memory cd) {
95         bytes32 _caseData = getDataFromCase(caseId);
96         // cd.mT = uint32(bytes4(_caseData)); Uncomment if you want to use mT
97         cd.bT = int8(bytes1(_caseData << 32));
98         // cd.mL = uint80(bytes10(_caseData << 40)); Uncomment if you want to use mL
99         cd.bL = int80(bytes10(_caseData << 120));
100     }
101 
102 function setCasesV2() internal {
103         AppStorage storage s = LibAppStorage.diamondStorage();
104         s.casesV2 = [
105         //               Dsc soil demand,  Steady soil demand  Inc soil demand
106                     /////////////////////// Exremely Low L2SR ///////////////////////
107             bytes32(T_PLUS_3_L_MINUS_FIFTY),    T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY, // Exs Low: P < 1
108                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
109                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
110                      T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY, // Rea Low: P < 1
111                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
112                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
113                      T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY,    T_PLUS_0_L_MINUS_FIFTY, // Rea Hgh: P < 1
114                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
115                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
116                      T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY,    T_PLUS_0_L_MINUS_FIFTY, // Exs Hgh: P < 1
117                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
118                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
119                     /////////////////////// Reasonably Low L2SR ///////////////////////
120                      T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY, // Exs Low: P < 1
121                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
122                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
123                      T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_3_L_MINUS_FIFTY,    T_PLUS_1_L_MINUS_FIFTY, // Rea Low: P < 1
124                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > 1
125                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
126                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE,       T_PLUS_0_L_PLUS_ONE, // Rea Hgh: P < 1
127                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
128                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
129                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE,       T_PLUS_0_L_PLUS_ONE, // Exs Hgh: P < 1
130                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
131                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
132                     /////////////////////// Reasonably High L2SR ///////////////////////
133                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE, // Exs Low: P < 1
134                       T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
135                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
136                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE, // Rea Low: P < 1
137                       T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
138                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
139                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE,       T_PLUS_0_L_PLUS_ONE, // Rea Hgh: P < 1
140                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
141                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
142                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE,       T_PLUS_0_L_PLUS_ONE, // Exs Hgh: P < 1
143                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
144                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
145                     /////////////////////// Extremely High L2SR ///////////////////////
146                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE, // Exs Low: P < 1
147                       T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
148                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
149                         T_PLUS_3_L_PLUS_ONE,       T_PLUS_3_L_PLUS_ONE,       T_PLUS_1_L_PLUS_ONE, // Rea Low: P < 1
150                       T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
151                     T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
152                         T_PLUS_3_L_PLUS_TWO,       T_PLUS_1_L_PLUS_TWO,       T_PLUS_0_L_PLUS_TWO, // Rea Hgh: P < 1
153                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
154                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY, //          P > Q
155                         T_PLUS_3_L_PLUS_TWO,       T_PLUS_1_L_PLUS_TWO,       T_PLUS_0_L_PLUS_TWO, // Exs Hgh: P < 1
156                        T_PLUS_0_L_MINUS_ONE,     T_MINUS_1_L_MINUS_ONE,     T_MINUS_3_L_MINUS_ONE, //          P > 1
157                      T_PLUS_0_L_MINUS_FIFTY,   T_MINUS_1_L_MINUS_FIFTY,   T_MINUS_3_L_MINUS_FIFTY  //          P > Q
158         ];
159     }
160 }
