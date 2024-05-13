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
18 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
19 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
20 
21 import "./lib/ABDKMath64x64.sol";
22 
23 import "./Storage.sol";
24 
25 import "./CurveMath.sol";
26 
27 library Orchestrator {
28     using SafeERC20 for IERC20;
29     using ABDKMath64x64 for int128;
30     using ABDKMath64x64 for uint256;
31 
32     int128 private constant ONE_WEI = 0x12;
33 
34     event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);
35 
36     event AssetIncluded(address indexed numeraire, address indexed reserve, uint256 weight);
37 
38     event AssimilatorIncluded(
39         address indexed derivative,
40         address indexed numeraire,
41         address indexed reserve,
42         address assimilator
43     );
44 
45     function setParams(
46         Storage.Curve storage curve,
47         uint256 _alpha,
48         uint256 _beta,
49         uint256 _feeAtHalt,
50         uint256 _epsilon,
51         uint256 _lambda
52     ) external {
53         require(0 < _alpha && _alpha < 1e18, "Curve/parameter-invalid-alpha");
54 
55         require(_beta < _alpha, "Curve/parameter-invalid-beta");
56 
57         require(_feeAtHalt <= 5e17, "Curve/parameter-invalid-max");
58 
59         require(_epsilon <= 1e16, "Curve/parameter-invalid-epsilon");
60 
61         require(_lambda <= 1e18, "Curve/parameter-invalid-lambda");
62 
63         int128 _omega = getFee(curve);
64 
65         curve.alpha = (_alpha + 1).divu(1e18);
66 
67         curve.beta = (_beta + 1).divu(1e18);
68 
69         curve.delta = (_feeAtHalt).divu(1e18).div(uint256(2).fromUInt().mul(curve.alpha.sub(curve.beta))) + ONE_WEI;
70 
71         curve.epsilon = (_epsilon + 1).divu(1e18);
72 
73         curve.lambda = (_lambda + 1).divu(1e18);
74 
75         int128 _psi = getFee(curve);
76 
77         require(_omega >= _psi, "Curve/parameters-increase-fee");
78 
79         emit ParametersSet(_alpha, _beta, curve.delta.mulu(1e18), _epsilon, _lambda);
80     }
81 
82     function getFee(Storage.Curve storage curve) private view returns (int128 fee_) {
83         int128 _gLiq;
84 
85         // Always pairs
86         int128[] memory _bals = new int128[](2);
87 
88         for (uint256 i = 0; i < _bals.length; i++) {
89             int128 _bal = Assimilators.viewNumeraireBalance(curve.assets[i].addr);
90 
91             _bals[i] = _bal;
92 
93             _gLiq += _bal;
94         }
95 
96         fee_ = CurveMath.calculateFee(_gLiq, _bals, curve.beta, curve.delta, curve.weights);
97     }
98 
99     function initialize(
100         Storage.Curve storage curve,
101         address[] storage numeraires,
102         address[] storage reserves,
103         address[] storage derivatives,
104         address[] calldata _assets,
105         uint256[] calldata _assetWeights
106     ) external {
107         require(_assetWeights.length == 2, "Curve/assetWeights-must-be-length-two");
108         require(_assets.length % 5 == 0, "Curve/assets-must-be-divisible-by-five");
109 
110         for (uint256 i = 0; i < _assetWeights.length; i++) {
111             uint256 ix = i * 5;
112 
113             numeraires.push(_assets[ix]);
114             derivatives.push(_assets[ix]);
115 
116             reserves.push(_assets[2 + ix]);
117             if (_assets[ix] != _assets[2 + ix]) derivatives.push(_assets[2 + ix]);
118 
119             includeAsset(
120                 curve,
121                 _assets[ix], // numeraire
122                 _assets[1 + ix], // numeraire assimilator
123                 _assets[2 + ix], // reserve
124                 _assets[3 + ix], // reserve assimilator
125                 _assets[4 + ix], // reserve approve to
126                 _assetWeights[i]
127             );
128         }
129     }
130 
131     function includeAsset(
132         Storage.Curve storage curve,
133         address _numeraire,
134         address _numeraireAssim,
135         address _reserve,
136         address _reserveAssim,
137         address _reserveApproveTo,
138         uint256 _weight
139     ) private {
140         require(_numeraire != address(0), "Curve/numeraire-cannot-be-zeroth-address");
141 
142         require(_numeraireAssim != address(0), "Curve/numeraire-assimilator-cannot-be-zeroth-address");
143 
144         require(_reserve != address(0), "Curve/reserve-cannot-be-zeroth-address");
145 
146         require(_reserveAssim != address(0), "Curve/reserve-assimilator-cannot-be-zeroth-address");
147 
148         require(_weight < 1e18, "Curve/weight-must-be-less-than-one");
149 
150         if (_numeraire != _reserve) IERC20(_numeraire).safeApprove(_reserveApproveTo, uint256(-1));
151 
152         Storage.Assimilator storage _numeraireAssimilator = curve.assimilators[_numeraire];
153 
154         _numeraireAssimilator.addr = _numeraireAssim;
155 
156         _numeraireAssimilator.ix = uint8(curve.assets.length);
157 
158         Storage.Assimilator storage _reserveAssimilator = curve.assimilators[_reserve];
159 
160         _reserveAssimilator.addr = _reserveAssim;
161 
162         _reserveAssimilator.ix = uint8(curve.assets.length);
163 
164         int128 __weight = _weight.divu(1e18).add(uint256(1).divu(1e18));
165 
166         curve.weights.push(__weight);
167 
168         curve.assets.push(_numeraireAssimilator);
169 
170         emit AssetIncluded(_numeraire, _reserve, _weight);
171 
172         emit AssimilatorIncluded(_numeraire, _numeraire, _reserve, _numeraireAssim);
173 
174         if (_numeraireAssim != _reserveAssim) {
175             emit AssimilatorIncluded(_reserve, _numeraire, _reserve, _reserveAssim);
176         }
177     }
178 
179     function includeAssimilator(
180         Storage.Curve storage curve,
181         address _derivative,
182         address _numeraire,
183         address _reserve,
184         address _assimilator,
185         address _derivativeApproveTo
186     ) private {
187         require(_derivative != address(0), "Curve/derivative-cannot-be-zeroth-address");
188 
189         require(_numeraire != address(0), "Curve/numeraire-cannot-be-zeroth-address");
190 
191         require(_reserve != address(0), "Curve/numeraire-cannot-be-zeroth-address");
192 
193         require(_assimilator != address(0), "Curve/assimilator-cannot-be-zeroth-address");
194 
195         IERC20(_numeraire).safeApprove(_derivativeApproveTo, uint256(-1));
196 
197         Storage.Assimilator storage _numeraireAssim = curve.assimilators[_numeraire];
198 
199         curve.assimilators[_derivative] = Storage.Assimilator(_assimilator, _numeraireAssim.ix);
200 
201         emit AssimilatorIncluded(_derivative, _numeraire, _reserve, _assimilator);
202     }
203 
204     function viewCurve(Storage.Curve storage curve)
205         external
206         view
207         returns (
208             uint256 alpha_,
209             uint256 beta_,
210             uint256 delta_,
211             uint256 epsilon_,
212             uint256 lambda_
213         )
214     {
215         alpha_ = curve.alpha.mulu(1e18);
216 
217         beta_ = curve.beta.mulu(1e18);
218 
219         delta_ = curve.delta.mulu(1e18);
220 
221         epsilon_ = curve.epsilon.mulu(1e18);
222 
223         lambda_ = curve.lambda.mulu(1e18);
224     }
225 }
