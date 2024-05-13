1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 import {Math} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/Math.sol';
6 import {ConstantProduct} from './ConstantProduct.sol';
7 import {SafeCast} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/SafeCast.sol';
8 library MintMath {
9     using Math for uint256;
10     using ConstantProduct for IPair;
11     using SafeCast for uint256;
12 
13     function givenNew(
14         uint256 maturity,
15         uint112 assetIn,
16         uint112 debtIn,
17         uint112 collateralIn
18     )
19         internal
20         view
21         returns (
22             uint112 xIncrease,
23             uint112 yIncrease,
24             uint112 zIncrease
25         )
26     {
27         xIncrease = assetIn;
28         uint256 duration = maturity;
29         duration -= block.timestamp;
30         uint256 _yIncrease = debtIn;
31         _yIncrease -= assetIn;
32         _yIncrease <<= 32;
33         _yIncrease /= duration;
34         yIncrease = _yIncrease.toUint112();
35         uint256 _zIncrease = collateralIn;
36         _zIncrease <<= 25;
37         uint256 denominator = duration;
38         denominator += 0x2000000;
39         _zIncrease /= denominator;
40         zIncrease = _zIncrease.toUint112();
41     }
42 
43     function givenAsset(
44         IPair pair,
45         uint256 maturity,
46         uint112 assetIn
47     )
48         internal
49         view
50         returns (
51             uint112 xIncrease,
52             uint112 yIncrease,
53             uint112 zIncrease
54         )
55     {
56         ConstantProduct.CP memory cp = pair.get(maturity);
57 
58         uint256 _xIncrease = assetIn;
59         _xIncrease *= cp.x;
60         uint256 denominator = cp.x;
61         denominator += pair.feeStored(maturity);
62         _xIncrease /= denominator;
63         xIncrease = _xIncrease.toUint112();
64 
65         uint256 _yIncrease = cp.y;
66         _yIncrease *= assetIn;
67         _yIncrease /= cp.x;
68         yIncrease = _yIncrease.toUint112();
69 
70         uint256 _zIncrease = cp.z;
71         _zIncrease *= assetIn;
72         _zIncrease /= cp.x;
73         zIncrease = _zIncrease.toUint112();
74     }
75 
76     function givenDebt(
77         IPair pair,
78         uint256 maturity,
79         uint112 debtIn
80     )
81         internal
82         view
83         returns (
84             uint112 xIncrease,
85             uint112 yIncrease,
86             uint112 zIncrease
87         )
88     {
89         ConstantProduct.CP memory cp = pair.get(maturity);
90 
91         uint256 _yIncrease = debtIn;
92         _yIncrease *= cp.y;
93         _yIncrease <<= 32;
94         uint256 denominator = maturity;
95         denominator -= block.timestamp;
96         denominator *= cp.y;
97         uint256 addend = cp.x;
98         addend <<= 32;
99         denominator += addend;
100         _yIncrease /= denominator;
101         yIncrease = _yIncrease.toUint112();
102 
103         uint256 _xIncrease = cp.x;
104         _xIncrease *= _yIncrease;
105         _xIncrease = _xIncrease.divUp(cp.y);
106         xIncrease = _xIncrease.toUint112();
107 
108         uint256 _zIncrease = cp.z;
109         _zIncrease *= _yIncrease;
110         _zIncrease /= cp.y;
111         zIncrease = _zIncrease.toUint112();
112     }
113 
114     function givenCollateral(
115         IPair pair,
116         uint256 maturity,
117         uint112 collateralIn
118     )
119         internal
120         view
121         returns (
122             uint112 xIncrease,
123             uint112 yIncrease,
124             uint112 zIncrease
125         )
126     {
127         ConstantProduct.CP memory cp = pair.get(maturity);
128 
129         uint256 _zIncrease = collateralIn;
130         _zIncrease <<= 25;
131         uint256 denominator = maturity;
132         denominator -= block.timestamp;
133         denominator += 0x2000000;
134         _zIncrease /= denominator;
135         zIncrease = _zIncrease.toUint112();
136 
137         uint256 _xIncrease = cp.x;
138         _xIncrease *= _zIncrease;
139         _xIncrease = _xIncrease.divUp(cp.z);
140         xIncrease = _xIncrease.toUint112();
141 
142         uint256 _yIncrease = cp.y;
143         _yIncrease *= _zIncrease;
144         _yIncrease /= cp.z;
145         yIncrease = _yIncrease.toUint112();
146     }
147 }
