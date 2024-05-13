1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
5 import {Math} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/Math.sol';
6 import {SquareRoot} from './SquareRoot.sol';
7 import {FullMath} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/FullMath.sol';
8 import {ConstantProduct} from './ConstantProduct.sol';
9 import {SafeCast} from '@timeswap-labs/timeswap-v1-core/contracts/libraries/SafeCast.sol';
10 
11 library BorrowMath {
12     using Math for uint256;
13     using SquareRoot for uint256;
14     using FullMath for uint256;
15     using ConstantProduct for IPair;
16     using ConstantProduct for ConstantProduct.CP;
17     using SafeCast for uint256;
18 
19     uint256 private constant BASE = 0x10000000000;
20 
21     function givenDebt(
22         IPair pair,
23         uint256 maturity,
24         uint112 assetOut,
25         uint112 debtIn
26     )
27         internal
28         view
29         returns (
30             uint112 xDecrease,
31             uint112 yIncrease,
32             uint112 zIncrease
33         )
34     {
35         ConstantProduct.CP memory cp = pair.get(maturity);
36 
37         xDecrease = getX(pair, maturity, assetOut);
38 
39         uint256 xReserve = cp.x;
40         xReserve -= xDecrease;
41 
42         uint256 _yIncrease = debtIn;
43         _yIncrease -= xDecrease;
44         _yIncrease <<= 32;
45         uint256 denominator = maturity;
46         denominator -= block.timestamp;
47         _yIncrease /= denominator;
48         yIncrease = _yIncrease.toUint112();
49 
50         uint256 yReserve = cp.y;
51         yReserve += _yIncrease;
52 
53         uint256 zReserve = cp.x;
54         zReserve *= cp.y;
55         denominator = xReserve;
56         denominator *= yReserve;
57         zReserve = zReserve.mulDivUp(cp.z, denominator);
58 
59         uint256 _zIncrease = zReserve;
60         _zIncrease -= cp.z;
61         zIncrease = _zIncrease.toUint112();
62     }
63 
64     function givenCollateral(
65         IPair pair,
66         uint256 maturity,
67         uint112 assetOut,
68         uint112 collateralIn
69     )
70         internal
71         view
72         returns (
73             uint112 xDecrease,
74             uint112 yIncrease,
75             uint112 zIncrease
76         )
77     {
78         ConstantProduct.CP memory cp = pair.get(maturity);
79 
80         xDecrease = getX(pair, maturity, assetOut);
81 
82         uint256 xReserve = cp.x;
83         xReserve -= xDecrease;
84 
85         uint256 _zIncrease = collateralIn;
86         _zIncrease = xReserve;
87         uint256 subtrahend = cp.z;
88         subtrahend *= xDecrease;
89         _zIncrease -= subtrahend;
90         _zIncrease <<= 25;
91         uint256 denominator = maturity;
92         denominator -= block.timestamp;
93         denominator *= xReserve;
94         _zIncrease /= denominator;
95         zIncrease = _zIncrease.toUint112();
96 
97         uint256 zReserve = cp.z;
98         zReserve += _zIncrease;
99 
100         uint256 yReserve = cp.x;
101         yReserve *= cp.z;
102         denominator = xReserve;
103         denominator *= zReserve;
104         yReserve = yReserve.mulDivUp(cp.y, denominator);
105 
106         uint256 _yIncrease = yReserve;
107         _yIncrease -= cp.y;
108         yIncrease = _yIncrease.toUint112();
109     }
110 
111     function givenPercent(
112         IPair pair,
113         uint256 maturity,
114         uint112 assetOut,
115         uint40 percent
116     )
117         internal
118         view
119         returns (
120             uint112 xDecrease,
121             uint112 yIncrease,
122             uint112 zIncrease
123         )
124     {
125         ConstantProduct.CP memory cp = pair.get(maturity);
126 
127         xDecrease = getX(pair, maturity, assetOut);
128 
129         uint256 xReserve = cp.x;
130         xReserve -= xDecrease;
131 
132         if (percent <= 0x80000000) {
133             uint256 yMid = cp.y;
134             yMid *= cp.y;
135             yMid = yMid.mulDivUp(cp.x, xReserve);
136             yMid = yMid.sqrtUp();
137             yMid -= cp.y;
138 
139             uint256 _yIncrease = yMid;
140             _yIncrease *= percent;
141             _yIncrease = _yIncrease.shiftRightUp(31);
142             yIncrease = _yIncrease.toUint112();
143 
144             uint256 yReserve = cp.y;
145             yReserve += _yIncrease;
146 
147             uint256 zReserve = cp.x;
148             zReserve *= cp.y;
149             uint256 denominator = xReserve;
150             denominator *= yReserve;
151             zReserve = zReserve.mulDivUp(cp.z, denominator);
152 
153             uint256 _zIncrease = zReserve;
154             _zIncrease -= cp.z;
155             zIncrease = _zIncrease.toUint112();
156         } else {
157             percent = 0x100000000 - percent;
158 
159             uint256 zMid = cp.z;
160             zMid *= cp.z;
161             zMid = zMid.mulDivUp(cp.x, xReserve);
162             zMid = zMid.sqrtUp();
163             zMid -= cp.z;
164 
165             uint256 _zIncrease = zMid;
166             _zIncrease *= percent;
167             _zIncrease = _zIncrease.shiftRightUp(31);
168             zIncrease = _zIncrease.toUint112();
169 
170             uint256 zReserve = cp.z;
171             zReserve += _zIncrease;
172 
173             uint256 yReserve = cp.x;
174             yReserve *= cp.z;
175             uint256 denominator = xReserve;
176             denominator *= zReserve;
177             yReserve = yReserve.mulDivUp(cp.y, denominator);
178 
179             uint256 _yIncrease = yReserve;
180             _yIncrease -= cp.y;
181             yIncrease = _yIncrease.toUint112();
182         }
183     }
184 
185     function getX(
186         IPair pair,
187         uint256 maturity,
188         uint112 assetOut
189     ) private view returns (uint112 xDecrease) {
190         // uint256 duration = maturity;
191         // duration -= block.timestamp;
192 
193         uint256 totalFee = pair.fee();
194         totalFee += pair.protocolFee();
195 
196         uint256 numerator = maturity;
197         numerator -= block.timestamp;
198         numerator *= totalFee;
199         numerator += BASE;
200 
201         uint256 _xDecrease = assetOut;
202         _xDecrease *= numerator;
203         _xDecrease = _xDecrease.divUp(BASE);
204         xDecrease = _xDecrease.toUint112();
205 
206         // uint256 numerator = duration;
207         // numerator *= pair.fee();
208         // numerator += BASE;
209 
210         // uint256 _xDecrease = assetOut;
211         // _xDecrease *= numerator;
212         // _xDecrease = _xDecrease.divUp(BASE);
213 
214         // numerator = duration;
215         // numerator *= pair.protocolFee();
216         // numerator += BASE;
217 
218         // _xDecrease *= numerator;
219         // _xDecrease = _xDecrease.divUp(BASE);
220         // xDecrease = _xDecrease.toUint112();
221     }
222 }
