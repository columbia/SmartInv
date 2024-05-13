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
11 library LendMath {
12     using Math for uint256;
13     using SquareRoot for uint256;
14     using FullMath for uint256;
15     using ConstantProduct for IPair;
16     using ConstantProduct for ConstantProduct.CP;
17     using SafeCast for uint256;
18 
19     uint256 private constant BASE = 0x10000000000;
20 
21     function givenBond(
22         IPair pair,
23         uint256 maturity,
24         uint112 assetIn,
25         uint128 bondOut
26     )
27         internal
28         view
29         returns (
30             uint112 xIncrease,
31             uint112 yDecrease,
32             uint112 zDecrease
33         )
34     {
35         ConstantProduct.CP memory cp = pair.get(maturity);
36 
37         xIncrease = getX(pair, maturity, assetIn);
38 
39         uint256 xReserve = cp.x;
40         xReserve += xIncrease;
41 
42         uint256 _yDecrease = bondOut;
43         _yDecrease -= xIncrease;
44         _yDecrease <<= 32;
45         uint256 denominator = maturity;
46         denominator -= block.timestamp;
47         _yDecrease = _yDecrease.divUp(denominator);
48         yDecrease = _yDecrease.toUint112();
49 
50         uint256 yReserve = cp.y;
51         yReserve -= _yDecrease;
52 
53         uint256 zReserve = cp.x;
54         zReserve *= cp.y;
55         denominator = xReserve;
56         denominator *= yReserve;
57         zReserve = zReserve.mulDivUp(cp.z, denominator);
58 
59         uint256 _zDecrease = cp.z;
60         _zDecrease -= zReserve;
61         zDecrease = _zDecrease.toUint112();
62     }
63 
64     function givenInsurance(
65         IPair pair,
66         uint256 maturity,
67         uint112 assetIn,
68         uint128 insuranceOut
69     )
70         internal
71         view
72         returns (
73             uint112 xIncrease,
74             uint112 yDecrease,
75             uint112 zDecrease
76         )
77     {
78         ConstantProduct.CP memory cp = pair.get(maturity);
79 
80         xIncrease = getX(pair, maturity, assetIn);
81 
82         uint256 xReserve = cp.x;
83         xReserve += xIncrease;
84 
85         uint256 _zDecrease = insuranceOut;
86         _zDecrease *= xReserve;
87         uint256 subtrahend = cp.z;
88         subtrahend *= xIncrease;
89         _zDecrease -= subtrahend;
90         _zDecrease <<= 25;
91         uint256 denominator = maturity;
92         denominator -= block.timestamp;
93         denominator *= xReserve;
94         _zDecrease = _zDecrease.divUp(denominator);
95         zDecrease = _zDecrease.toUint112();
96 
97         uint256 zReserve = cp.z;
98         zReserve -= _zDecrease;
99 
100         uint256 yReserve = cp.x;
101         yReserve *= cp.z;
102         denominator = xReserve;
103         denominator *= zReserve;
104         yReserve = yReserve.mulDivUp(cp.y, denominator);
105 
106         uint256 _yDecrease = cp.y;
107         _yDecrease -= yReserve;
108         yDecrease = _yDecrease.toUint112();
109     }
110 
111     function givenPercent(
112         IPair pair,
113         uint256 maturity,
114         uint112 assetIn,
115         uint40 percent
116     )
117         internal
118         view
119         returns (
120             uint112 xIncrease,
121             uint112 yDecrease,
122             uint112 zDecrease
123         )
124     {
125         ConstantProduct.CP memory cp = pair.get(maturity);
126 
127         xIncrease = getX(pair, maturity, assetIn);
128 
129         uint256 xReserve = cp.x;
130         xReserve += xIncrease;
131 
132         if (percent <= 0x80000000) {
133             uint256 yMid = cp.y;
134             uint256 subtrahend = cp.y;
135             subtrahend *= cp.y;
136             subtrahend = subtrahend.mulDivUp(cp.x, xReserve);
137             subtrahend = subtrahend.sqrtUp();
138             yMid -= subtrahend;
139 
140             uint256 _yDecrease = yMid;
141             _yDecrease *= percent;
142             _yDecrease >>= 31;
143             yDecrease = _yDecrease.toUint112();
144 
145             uint256 yReserve = cp.y;
146             yReserve -= _yDecrease;
147 
148             uint256 zReserve = cp.x;
149             zReserve *= cp.y;
150             uint256 denominator = xReserve;
151             denominator *= yReserve;
152             zReserve = zReserve.mulDivUp(cp.z, denominator);
153 
154             uint256 _zDecrease = cp.z;
155             _zDecrease -= zReserve;
156             zDecrease = _zDecrease.toUint112();
157         } else {
158             percent = 0x100000000 - percent;
159 
160             uint256 zMid = cp.z;
161             uint256 subtrahend = cp.z;
162             subtrahend *= cp.z;
163             subtrahend = subtrahend.mulDivUp(cp.x, xReserve);
164             subtrahend = subtrahend.sqrtUp();
165             zMid -= subtrahend;
166 
167             uint256 _zDecrease = zMid;
168             _zDecrease *= percent;
169             _zDecrease >>= 31;
170             zDecrease = _zDecrease.toUint112();
171 
172             uint256 zReserve = cp.z;
173             zReserve -= _zDecrease;
174 
175             uint256 yReserve = cp.x;
176             yReserve *= cp.z;
177             uint256 denominator = xReserve;
178             denominator *= zReserve;
179             yReserve = yReserve.mulDivUp(cp.y, denominator);
180 
181             uint256 _yDecrease = cp.y;
182             _yDecrease -= yReserve;
183             yDecrease = _yDecrease.toUint112();
184         }
185     }
186 
187     function getX(
188         IPair pair,
189         uint256 maturity,
190         uint112 assetIn
191     ) private view returns (uint112 xIncrease) {
192         // uint256 duration = maturity;
193         // duration -= block.timestamp;
194 
195         uint256 totalFee = pair.fee();
196         totalFee += pair.protocolFee();
197 
198         uint256 denominator = maturity;
199         denominator -= block.timestamp;
200         denominator *= totalFee;
201         denominator += BASE;
202 
203         uint256 _xIncrease = assetIn;
204         _xIncrease *= BASE;
205         _xIncrease /= denominator;
206         xIncrease = _xIncrease.toUint112();
207 
208         // uint256 denominator = duration;
209         // denominator *= pair.fee();
210         // denominator += BASE;
211 
212         // uint256 _xIncrease = assetIn;
213         // _xIncrease *= BASE;
214         // _xIncrease /= denominator;
215 
216         // denominator = duration;
217         // denominator *= pair.protocolFee();
218         // denominator += BASE;
219 
220         // _xIncrease *= BASE;
221         // _xIncrease /= denominator;
222         // xIncrease = _xIncrease.toUint112();
223     }
224 }
