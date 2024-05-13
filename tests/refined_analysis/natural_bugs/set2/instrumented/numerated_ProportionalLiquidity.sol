1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
4 
5 import "./Assimilators.sol";
6 
7 import "./Storage.sol";
8 
9 import "./lib/UnsafeMath64x64.sol";
10 import "./lib/ABDKMath64x64.sol";
11 
12 import "./CurveMath.sol";
13 
14 library ProportionalLiquidity {
15     using ABDKMath64x64 for uint256;
16     using ABDKMath64x64 for int128;
17     using UnsafeMath64x64 for int128;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     int128 public constant ONE = 0x10000000000000000;
22     int128 public constant ONE_WEI = 0x12;
23 
24     function proportionalDeposit(Storage.Curve storage curve, uint256 _deposit)
25         external
26         returns (uint256 curves_, uint256[] memory)
27     {
28         int128 __deposit = _deposit.divu(1e18);
29 
30         uint256 _length = curve.assets.length;
31 
32         uint256[] memory deposits_ = new uint256[](_length);
33 
34         (int128 _oGLiq, int128[] memory _oBals) = getGrossLiquidityAndBalancesForDeposit(curve);
35 
36         // Needed to calculate liquidity invariant
37         (int128 _oGLiqProp, int128[] memory _oBalsProp) = getGrossLiquidityAndBalances(curve);
38 
39         // No liquidity, oracle sets the ratio
40         if (_oGLiq == 0) {
41             for (uint256 i = 0; i < _length; i++) {
42                 // Variable here to avoid stack-too-deep errors
43                 int128 _d = __deposit.mul(curve.weights[i]);
44                 deposits_[i] = Assimilators.intakeNumeraire(curve.assets[i].addr, _d.add(ONE_WEI));
45             }
46         } else {
47             // We already have an existing pool ratio
48             // which must be respected
49             int128 _multiplier = __deposit.div(_oGLiq);
50 
51             uint256 _baseWeight = curve.weights[0].mulu(1e18);
52             uint256 _quoteWeight = curve.weights[1].mulu(1e18);
53 
54             for (uint256 i = 0; i < _length; i++) {
55                 deposits_[i] = Assimilators.intakeNumeraireLPRatio(
56                     curve.assets[i].addr,
57                     _baseWeight,
58                     _quoteWeight,
59                     _oBals[i].mul(_multiplier).add(ONE_WEI)
60                 );
61             }
62         }
63 
64         int128 _totalShells = curve.totalSupply.divu(1e18);
65 
66         int128 _newShells = __deposit;
67 
68         if (_totalShells > 0) {
69             _newShells = __deposit.div(_oGLiq);
70             _newShells = _newShells.mul(_totalShells);
71         }
72 
73         requireLiquidityInvariant(curve, _totalShells, _newShells, _oGLiqProp, _oBalsProp);
74 
75         mint(curve, msg.sender, curves_ = _newShells.mulu(1e18));
76 
77         return (curves_, deposits_);
78     }
79 
80     function viewProportionalDeposit(Storage.Curve storage curve, uint256 _deposit)
81         external
82         view
83         returns (uint256 curves_, uint256[] memory)
84     {
85         int128 __deposit = _deposit.divu(1e18);
86 
87         uint256 _length = curve.assets.length;
88 
89         (int128 _oGLiq, int128[] memory _oBals) = getGrossLiquidityAndBalancesForDeposit(curve);
90 
91         uint256[] memory deposits_ = new uint256[](_length);
92 
93         // No liquidity
94         if (_oGLiq == 0) {
95             for (uint256 i = 0; i < _length; i++) {
96                 deposits_[i] = Assimilators.viewRawAmount(
97                     curve.assets[i].addr,
98                     __deposit.mul(curve.weights[i]).add(ONE_WEI)
99                 );
100             }
101         } else {
102             // We already have an existing pool ratio
103             // this must be respected
104             int128 _multiplier = __deposit.div(_oGLiq);
105 
106             uint256 _baseWeight = curve.weights[0].mulu(1e18);
107             uint256 _quoteWeight = curve.weights[1].mulu(1e18);
108 
109             // Deposits into the pool is determined by existing LP ratio
110             for (uint256 i = 0; i < _length; i++) {
111                 deposits_[i] = Assimilators.viewRawAmountLPRatio(
112                     curve.assets[i].addr,
113                     _baseWeight,
114                     _quoteWeight,
115                     _oBals[i].mul(_multiplier).add(ONE_WEI)
116                 );
117             }
118         }
119 
120         int128 _totalShells = curve.totalSupply.divu(1e18);
121 
122         int128 _newShells = __deposit;
123 
124         if (_totalShells > 0) {
125             _newShells = __deposit.div(_oGLiq);
126             _newShells = _newShells.mul(_totalShells);
127         }
128 
129         curves_ = _newShells.mulu(1e18);
130 
131         return (curves_, deposits_);
132     }
133 
134     function emergencyProportionalWithdraw(Storage.Curve storage curve, uint256 _withdrawal)
135         external
136         returns (uint256[] memory)
137     {
138         uint256 _length = curve.assets.length;
139 
140         (, int128[] memory _oBals) = getGrossLiquidityAndBalances(curve);
141 
142         uint256[] memory withdrawals_ = new uint256[](_length);
143 
144         int128 _totalShells = curve.totalSupply.divu(1e18);
145         int128 __withdrawal = _withdrawal.divu(1e18);
146 
147         int128 _multiplier = __withdrawal.div(_totalShells);
148 
149         for (uint256 i = 0; i < _length; i++) {
150             withdrawals_[i] = Assimilators.outputNumeraire(
151                 curve.assets[i].addr,
152                 msg.sender,
153                 _oBals[i].mul(_multiplier)
154             );
155         }
156 
157         burn(curve, msg.sender, _withdrawal);
158 
159         return withdrawals_;
160     }
161 
162     function proportionalWithdraw(Storage.Curve storage curve, uint256 _withdrawal)
163         external
164         returns (uint256[] memory)
165     {
166         uint256 _length = curve.assets.length;
167 
168         (int128 _oGLiq, int128[] memory _oBals) = getGrossLiquidityAndBalances(curve);
169 
170         uint256[] memory withdrawals_ = new uint256[](_length);
171 
172         int128 _totalShells = curve.totalSupply.divu(1e18);
173         int128 __withdrawal = _withdrawal.divu(1e18);
174 
175         int128 _multiplier = __withdrawal.div(_totalShells);
176 
177         for (uint256 i = 0; i < _length; i++) {
178             withdrawals_[i] = Assimilators.outputNumeraire(
179                 curve.assets[i].addr,
180                 msg.sender,
181                 _oBals[i].mul(_multiplier)
182             );
183         }
184 
185         requireLiquidityInvariant(curve, _totalShells, __withdrawal.neg(), _oGLiq, _oBals);
186 
187         burn(curve, msg.sender, _withdrawal);
188 
189         return withdrawals_;
190     }
191 
192     function viewProportionalWithdraw(Storage.Curve storage curve, uint256 _withdrawal)
193         external
194         view
195         returns (uint256[] memory)
196     {
197         uint256 _length = curve.assets.length;
198 
199         (, int128[] memory _oBals) = getGrossLiquidityAndBalances(curve);
200 
201         uint256[] memory withdrawals_ = new uint256[](_length);
202 
203         int128 _multiplier = _withdrawal.divu(1e18).div(curve.totalSupply.divu(1e18));
204 
205         for (uint256 i = 0; i < _length; i++) {
206             withdrawals_[i] = Assimilators.viewRawAmount(curve.assets[i].addr, _oBals[i].mul(_multiplier));
207         }
208 
209         return withdrawals_;
210     }
211 
212     function getGrossLiquidityAndBalancesForDeposit(Storage.Curve storage curve)
213         internal
214         view
215         returns (int128 grossLiquidity_, int128[] memory)
216     {
217         uint256 _length = curve.assets.length;
218 
219         int128[] memory balances_ = new int128[](_length);
220         uint256 _baseWeight = curve.weights[0].mulu(1e18);
221         uint256 _quoteWeight = curve.weights[1].mulu(1e18);
222 
223         for (uint256 i = 0; i < _length; i++) {
224             int128 _bal = Assimilators.viewNumeraireBalanceLPRatio(_baseWeight, _quoteWeight, curve.assets[i].addr);
225 
226             balances_[i] = _bal;
227             grossLiquidity_ += _bal;
228         }
229 
230         return (grossLiquidity_, balances_);
231     }
232 
233     function getGrossLiquidityAndBalances(Storage.Curve storage curve)
234         internal
235         view
236         returns (int128 grossLiquidity_, int128[] memory)
237     {
238         uint256 _length = curve.assets.length;
239 
240         int128[] memory balances_ = new int128[](_length);
241 
242         for (uint256 i = 0; i < _length; i++) {
243             int128 _bal = Assimilators.viewNumeraireBalance(curve.assets[i].addr);
244 
245             balances_[i] = _bal;
246             grossLiquidity_ += _bal;
247         }
248 
249         return (grossLiquidity_, balances_);
250     }
251 
252     function requireLiquidityInvariant(
253         Storage.Curve storage curve,
254         int128 _curves,
255         int128 _newShells,
256         int128 _oGLiq,
257         int128[] memory _oBals
258     ) private view {
259         (int128 _nGLiq, int128[] memory _nBals) = getGrossLiquidityAndBalances(curve);
260 
261         int128 _beta = curve.beta;
262         int128 _delta = curve.delta;
263         int128[] memory _weights = curve.weights;
264 
265         int128 _omega = CurveMath.calculateFee(_oGLiq, _oBals, _beta, _delta, _weights);
266 
267         int128 _psi = CurveMath.calculateFee(_nGLiq, _nBals, _beta, _delta, _weights);
268 
269         CurveMath.enforceLiquidityInvariant(_curves, _newShells, _oGLiq, _nGLiq, _omega, _psi);
270     }
271 
272     function burn(
273         Storage.Curve storage curve,
274         address account,
275         uint256 amount
276     ) private {
277         curve.balances[account] = burnSub(curve.balances[account], amount);
278 
279         curve.totalSupply = burnSub(curve.totalSupply, amount);
280 
281         emit Transfer(msg.sender, address(0), amount);
282     }
283 
284     function mint(
285         Storage.Curve storage curve,
286         address account,
287         uint256 amount
288     ) private {
289         curve.totalSupply = mintAdd(curve.totalSupply, amount);
290 
291         curve.balances[account] = mintAdd(curve.balances[account], amount);
292 
293         emit Transfer(address(0), msg.sender, amount);
294     }
295 
296     function mintAdd(uint256 x, uint256 y) private pure returns (uint256 z) {
297         require((z = x + y) >= x, "Curve/mint-overflow");
298     }
299 
300     function burnSub(uint256 x, uint256 y) private pure returns (uint256 z) {
301         require((z = x - y) <= x, "Curve/burn-underflow");
302     }
303 }
