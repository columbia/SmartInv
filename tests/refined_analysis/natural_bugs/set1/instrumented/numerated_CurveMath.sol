1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 
18 import "./Storage.sol";
19 
20 import "./lib/UnsafeMath64x64.sol";
21 import "./lib/ABDKMath64x64.sol";
22 
23 library CurveMath {
24     int128 private constant ONE = 0x10000000000000000;
25     int128 private constant MAX = 0x4000000000000000; // .25 in layman's terms
26     int128 private constant MAX_DIFF = -0x10C6F7A0B5EE;
27     int128 private constant ONE_WEI = 0x12;
28 
29     using ABDKMath64x64 for int128;
30     using UnsafeMath64x64 for int128;
31     using ABDKMath64x64 for uint256;
32 
33     // This is used to prevent stack too deep errors
34     function calculateFee(
35         int128 _gLiq,
36         int128[] memory _bals,
37         Storage.Curve storage curve,
38         int128[] memory _weights
39     ) internal view returns (int128 psi_) {
40         int128 _beta = curve.beta;
41         int128 _delta = curve.delta;
42 
43         psi_ = calculateFee(_gLiq, _bals, _beta, _delta, _weights);
44     }
45 
46     function calculateFee(
47         int128 _gLiq,
48         int128[] memory _bals,
49         int128 _beta,
50         int128 _delta,
51         int128[] memory _weights
52     ) internal pure returns (int128 psi_) {
53         uint256 _length = _bals.length;
54 
55         for (uint256 i = 0; i < _length; i++) {
56             int128 _ideal = _gLiq.mul(_weights[i]);
57             psi_ += calculateMicroFee(_bals[i], _ideal, _beta, _delta);
58         }
59     }
60 
61     function calculateMicroFee(
62         int128 _bal,
63         int128 _ideal,
64         int128 _beta,
65         int128 _delta
66     ) private pure returns (int128 fee_) {
67         if (_bal < _ideal) {
68             int128 _threshold = _ideal.mul(ONE - _beta);
69 
70             if (_bal < _threshold) {
71                 int128 _feeMargin = _threshold - _bal;
72 
73                 fee_ = _feeMargin.div(_ideal);
74                 fee_ = fee_.mul(_delta);
75 
76                 if (fee_ > MAX) fee_ = MAX;
77 
78                 fee_ = fee_.mul(_feeMargin);
79             } else fee_ = 0;
80         } else {
81             int128 _threshold = _ideal.mul(ONE + _beta);
82 
83             if (_bal > _threshold) {
84                 int128 _feeMargin = _bal - _threshold;
85 
86                 fee_ = _feeMargin.div(_ideal);
87                 fee_ = fee_.mul(_delta);
88 
89                 if (fee_ > MAX) fee_ = MAX;
90 
91                 fee_ = fee_.mul(_feeMargin);
92             } else fee_ = 0;
93         }
94     }
95 
96     function calculateTrade(
97         Storage.Curve storage curve,
98         int128 _oGLiq,
99         int128 _nGLiq,
100         int128[] memory _oBals,
101         int128[] memory _nBals,
102         int128 _inputAmt,
103         uint256 _outputIndex
104     ) internal view returns (int128 outputAmt_) {
105         outputAmt_ = -_inputAmt;
106 
107         int128 _lambda = curve.lambda;
108         int128[] memory _weights = curve.weights;
109 
110         int128 _omega = calculateFee(_oGLiq, _oBals, curve, _weights);
111         int128 _psi;
112 
113         for (uint256 i = 0; i < 32; i++) {
114             _psi = calculateFee(_nGLiq, _nBals, curve, _weights);
115 
116             int128 prevAmount;
117             {
118                 prevAmount = outputAmt_;
119                 outputAmt_ = _omega < _psi ? -(_inputAmt + _omega - _psi) : -(_inputAmt + _lambda.mul(_omega - _psi));
120             }
121 
122             if (outputAmt_ / 1e13 == prevAmount / 1e13) {
123                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
124 
125                 _nBals[_outputIndex] = _oBals[_outputIndex] + outputAmt_;
126 
127                 enforceHalts(curve, _oGLiq, _nGLiq, _oBals, _nBals, _weights);
128 
129                 enforceSwapInvariant(_oGLiq, _omega, _nGLiq, _psi);
130 
131                 return outputAmt_;
132             } else {
133                 _nGLiq = _oGLiq + _inputAmt + outputAmt_;
134 
135                 _nBals[_outputIndex] = _oBals[_outputIndex].add(outputAmt_);
136             }
137         }
138 
139         revert("Curve/swap-convergence-failed");
140     }
141 
142     function calculateLiquidityMembrane(
143         Storage.Curve storage curve,
144         int128 _oGLiq,
145         int128 _nGLiq,
146         int128[] memory _oBals,
147         int128[] memory _nBals
148     ) internal view returns (int128 curves_) {
149         enforceHalts(curve, _oGLiq, _nGLiq, _oBals, _nBals, curve.weights);
150 
151         int128 _omega;
152         int128 _psi;
153 
154         {
155             int128 _beta = curve.beta;
156             int128 _delta = curve.delta;
157             int128[] memory _weights = curve.weights;
158 
159             _omega = calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
160             _psi = calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
161         }
162 
163         int128 _feeDiff = _psi.sub(_omega);
164         int128 _liqDiff = _nGLiq.sub(_oGLiq);
165         int128 _oUtil = _oGLiq.sub(_omega);
166         int128 _totalShells = curve.totalSupply.divu(1e18);
167         int128 _curveMultiplier;
168 
169         if (_totalShells == 0) {
170             curves_ = _nGLiq.sub(_psi);
171         } else if (_feeDiff >= 0) {
172             _curveMultiplier = _liqDiff.sub(_feeDiff).div(_oUtil);
173         } else {
174             _curveMultiplier = _liqDiff.sub(curve.lambda.mul(_feeDiff));
175 
176             _curveMultiplier = _curveMultiplier.div(_oUtil);
177         }
178 
179         if (_totalShells != 0) {
180             curves_ = _totalShells.mul(_curveMultiplier);
181 
182             enforceLiquidityInvariant(_totalShells, curves_, _oGLiq, _nGLiq, _omega, _psi);
183         }
184     }
185 
186     function enforceSwapInvariant(
187         int128 _oGLiq,
188         int128 _omega,
189         int128 _nGLiq,
190         int128 _psi
191     ) private pure {
192         int128 _nextUtil = _nGLiq - _psi;
193 
194         int128 _prevUtil = _oGLiq - _omega;
195 
196         int128 _diff = _nextUtil - _prevUtil;
197 
198         require(0 < _diff || _diff >= MAX_DIFF, "Curve/swap-invariant-violation");
199     }
200 
201     function enforceLiquidityInvariant(
202         int128 _totalShells,
203         int128 _newShells,
204         int128 _oGLiq,
205         int128 _nGLiq,
206         int128 _omega,
207         int128 _psi
208     ) internal pure {
209         if (_totalShells == 0 || 0 == _totalShells + _newShells) return;
210 
211         int128 _prevUtilPerShell = _oGLiq.sub(_omega).div(_totalShells);
212 
213         int128 _nextUtilPerShell = _nGLiq.sub(_psi).div(_totalShells.add(_newShells));
214 
215         int128 _diff = _nextUtilPerShell - _prevUtilPerShell;
216 
217         require(0 < _diff || _diff >= MAX_DIFF, "Curve/liquidity-invariant-violation");
218     }
219 
220     function enforceHalts(
221         Storage.Curve storage curve,
222         int128 _oGLiq,
223         int128 _nGLiq,
224         int128[] memory _oBals,
225         int128[] memory _nBals,
226         int128[] memory _weights
227     ) private view {
228         uint256 _length = _nBals.length;
229         int128 _alpha = curve.alpha;
230 
231         for (uint256 i = 0; i < _length; i++) {
232             int128 _nIdeal = _nGLiq.mul(_weights[i]);
233 
234             if (_nBals[i] > _nIdeal) {
235                 int128 _upperAlpha = ONE + _alpha;
236 
237                 int128 _nHalt = _nIdeal.mul(_upperAlpha);
238 
239                 if (_nBals[i] > _nHalt) {
240                     int128 _oHalt = _oGLiq.mul(_weights[i]).mul(_upperAlpha);
241 
242                     if (_oBals[i] < _oHalt) revert("Curve/upper-halt");
243                     if (_nBals[i] - _nHalt > _oBals[i] - _oHalt) revert("Curve/upper-halt");
244                 }
245             } else {
246                 int128 _lowerAlpha = ONE - _alpha;
247 
248                 int128 _nHalt = _nIdeal.mul(_lowerAlpha);
249 
250                 if (_nBals[i] < _nHalt) {
251                     int128 _oHalt = _oGLiq.mul(_weights[i]);
252                     _oHalt = _oHalt.mul(_lowerAlpha);
253 
254                     if (_oBals[i] > _oHalt) revert("Curve/lower-halt");
255                     if (_nHalt - _nBals[i] > _oHalt - _oBals[i]) revert("Curve/lower-halt");
256                 }
257             }
258         }
259     }
260 }
