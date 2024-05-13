1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.3;
4 
5 import "./Assimilators.sol";
6 import "./Storage.sol";
7 import "./CurveMath.sol";
8 import "./lib/UnsafeMath64x64.sol";
9 import "./lib/ABDKMath64x64.sol";
10 
11 import "@openzeppelin/contracts/math/SafeMath.sol";
12 
13 library Swaps {
14     using ABDKMath64x64 for int128;
15     using UnsafeMath64x64 for int128;
16     using ABDKMath64x64 for uint256;
17     using SafeMath for uint256;
18 
19     event Trade(
20         address indexed trader,
21         address indexed origin,
22         address indexed target,
23         uint256 originAmount,
24         uint256 targetAmount
25     );
26 
27     int128 public constant ONE = 0x10000000000000000;
28 
29     function getOriginAndTarget(
30         Storage.Curve storage curve,
31         address _o,
32         address _t
33     ) private view returns (Storage.Assimilator memory, Storage.Assimilator memory) {
34         Storage.Assimilator memory o_ = curve.assimilators[_o];
35         Storage.Assimilator memory t_ = curve.assimilators[_t];
36 
37         require(o_.addr != address(0), "Curve/origin-not-supported");
38         require(t_.addr != address(0), "Curve/target-not-supported");
39 
40         return (o_, t_);
41     }
42 
43     function originSwap(
44         Storage.Curve storage curve,
45         address _origin,
46         address _target,
47         uint256 _originAmount,
48         address _recipient
49     ) external returns (uint256 tAmt_) {
50         (Storage.Assimilator memory _o, Storage.Assimilator memory _t) = getOriginAndTarget(curve, _origin, _target);
51 
52         if (_o.ix == _t.ix)
53             return Assimilators.outputNumeraire(_t.addr, _recipient, Assimilators.intakeRaw(_o.addr, _originAmount));
54 
55         (int128 _amt, int128 _oGLiq, int128 _nGLiq, int128[] memory _oBals, int128[] memory _nBals) =
56             getOriginSwapData(curve, _o.ix, _t.ix, _o.addr, _originAmount);
57 
58         _amt = CurveMath.calculateTrade(curve, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
59 
60         _amt = _amt.us_mul(ONE - curve.epsilon);
61 
62         tAmt_ = Assimilators.outputNumeraire(_t.addr, _recipient, _amt);
63 
64         emit Trade(msg.sender, _origin, _target, _originAmount, tAmt_);
65     }
66 
67     function viewOriginSwap(
68         Storage.Curve storage curve,
69         address _origin,
70         address _target,
71         uint256 _originAmount
72     ) external view returns (uint256 tAmt_) {
73         (Storage.Assimilator memory _o, Storage.Assimilator memory _t) = getOriginAndTarget(curve, _origin, _target);
74 
75         if (_o.ix == _t.ix)
76             return Assimilators.viewRawAmount(_t.addr, Assimilators.viewNumeraireAmount(_o.addr, _originAmount));
77 
78         (int128 _amt, int128 _oGLiq, int128 _nGLiq, int128[] memory _nBals, int128[] memory _oBals) =
79             viewOriginSwapData(curve, _o.ix, _t.ix, _originAmount, _o.addr);
80 
81         _amt = CurveMath.calculateTrade(curve, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _t.ix);
82 
83         _amt = _amt.us_mul(ONE - curve.epsilon);
84 
85         tAmt_ = Assimilators.viewRawAmount(_t.addr, _amt.abs());
86     }
87 
88     function targetSwap(
89         Storage.Curve storage curve,
90         address _origin,
91         address _target,
92         uint256 _targetAmount,
93         address _recipient
94     ) external returns (uint256 oAmt_) {
95         (Storage.Assimilator memory _o, Storage.Assimilator memory _t) = getOriginAndTarget(curve, _origin, _target);
96 
97         if (_o.ix == _t.ix)
98             return Assimilators.intakeNumeraire(_o.addr, Assimilators.outputRaw(_t.addr, _recipient, _targetAmount));
99 
100         // If the origin is the quote currency (i.e. usdc)
101         // we need to make sure to massage the _targetAmount
102         // by dividing it by the exchange rate (so it gets
103         // multiplied later to reach the same target amount).
104         // Inelegant solution, but this way we don't need to
105         // re-write large chunks of the code-base
106 
107         // curve.assets[1].addr = quoteCurrency
108         // no variable assignment due to stack too deep
109         if (curve.assets[1].addr == _o.addr) {
110             _targetAmount = _targetAmount.mul(1e8).div(Assimilators.getRate(_t.addr));
111         }
112 
113         (int128 _amt, int128 _oGLiq, int128 _nGLiq, int128[] memory _oBals, int128[] memory _nBals) =
114             getTargetSwapData(curve, _t.ix, _o.ix, _t.addr, _recipient, _targetAmount);
115 
116         _amt = CurveMath.calculateTrade(curve, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
117 
118         // If the origin is the quote currency (i.e. usdc)
119         // we need to make sure to massage the _amt too
120 
121         // curve.assets[1].addr = quoteCurrency
122         if (curve.assets[1].addr == _o.addr) {
123             _amt = _amt.mul(Assimilators.getRate(_t.addr).divu(1e8));
124         }
125 
126         _amt = _amt.us_mul(ONE + curve.epsilon);
127 
128         oAmt_ = Assimilators.intakeNumeraire(_o.addr, _amt);
129 
130         emit Trade(msg.sender, _origin, _target, oAmt_, _targetAmount);
131     }
132 
133     function viewTargetSwap(
134         Storage.Curve storage curve,
135         address _origin,
136         address _target,
137         uint256 _targetAmount
138     ) external view returns (uint256 oAmt_) {
139         (Storage.Assimilator memory _o, Storage.Assimilator memory _t) = getOriginAndTarget(curve, _origin, _target);
140 
141         if (_o.ix == _t.ix)
142             return Assimilators.viewRawAmount(_o.addr, Assimilators.viewNumeraireAmount(_t.addr, _targetAmount));
143 
144         // If the origin is the quote currency (i.e. usdc)
145         // we need to make sure to massage the _targetAmount
146         // by dividing it by the exchange rate (so it gets
147         // multiplied later to reach the same target amount).
148         // Inelegant solution, but this way we don't need to
149         // re-write large chunks of the code-base
150 
151         // curve.assets[1].addr = quoteCurrency
152         // no variable assignment due to stack too deep
153         if (curve.assets[1].addr == _o.addr) {
154             _targetAmount = _targetAmount.mul(1e8).div(Assimilators.getRate(_t.addr));
155         }
156 
157         (int128 _amt, int128 _oGLiq, int128 _nGLiq, int128[] memory _nBals, int128[] memory _oBals) =
158             viewTargetSwapData(curve, _t.ix, _o.ix, _targetAmount, _t.addr);
159 
160         _amt = CurveMath.calculateTrade(curve, _oGLiq, _nGLiq, _oBals, _nBals, _amt, _o.ix);
161 
162         // If the origin is the quote currency (i.e. usdc)
163         // we need to make sure to massage the _amt too
164 
165         // curve.assets[1].addr = quoteCurrency
166         if (curve.assets[1].addr == _o.addr) {
167             _amt = _amt.mul(Assimilators.getRate(_t.addr).divu(1e8));
168         }
169 
170         _amt = _amt.us_mul(ONE + curve.epsilon);
171 
172         oAmt_ = Assimilators.viewRawAmount(_o.addr, _amt);
173     }
174 
175     function getOriginSwapData(
176         Storage.Curve storage curve,
177         uint256 _inputIx,
178         uint256 _outputIx,
179         address _assim,
180         uint256 _amt
181     )
182         private
183         returns (
184             int128 amt_,
185             int128 oGLiq_,
186             int128 nGLiq_,
187             int128[] memory,
188             int128[] memory
189         )
190     {
191         uint256 _length = curve.assets.length;
192 
193         int128[] memory oBals_ = new int128[](_length);
194         int128[] memory nBals_ = new int128[](_length);
195         Storage.Assimilator[] memory _reserves = curve.assets;
196 
197         for (uint256 i = 0; i < _length; i++) {
198             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
199             else {
200                 int128 _bal;
201                 (amt_, _bal) = Assimilators.intakeRawAndGetBalance(_assim, _amt);
202 
203                 oBals_[i] = _bal.sub(amt_);
204                 nBals_[i] = _bal;
205             }
206 
207             oGLiq_ += oBals_[i];
208             nGLiq_ += nBals_[i];
209         }
210 
211         nGLiq_ = nGLiq_.sub(amt_);
212         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
213 
214         return (amt_, oGLiq_, nGLiq_, oBals_, nBals_);
215     }
216 
217     function getTargetSwapData(
218         Storage.Curve storage curve,
219         uint256 _inputIx,
220         uint256 _outputIx,
221         address _assim,
222         address _recipient,
223         uint256 _amt
224     )
225         private
226         returns (
227             int128 amt_,
228             int128 oGLiq_,
229             int128 nGLiq_,
230             int128[] memory,
231             int128[] memory
232         )
233     {
234         uint256 _length = curve.assets.length;
235 
236         int128[] memory oBals_ = new int128[](_length);
237         int128[] memory nBals_ = new int128[](_length);
238         Storage.Assimilator[] memory _reserves = curve.assets;
239 
240         for (uint256 i = 0; i < _length; i++) {
241             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(_reserves[i].addr);
242             else {
243                 int128 _bal;
244                 (amt_, _bal) = Assimilators.outputRawAndGetBalance(_assim, _recipient, _amt);
245 
246                 oBals_[i] = _bal.sub(amt_);
247                 nBals_[i] = _bal;
248             }
249 
250             oGLiq_ += oBals_[i];
251             nGLiq_ += nBals_[i];
252         }
253 
254         nGLiq_ = nGLiq_.sub(amt_);
255         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
256 
257         return (amt_, oGLiq_, nGLiq_, oBals_, nBals_);
258     }
259 
260     function viewOriginSwapData(
261         Storage.Curve storage curve,
262         uint256 _inputIx,
263         uint256 _outputIx,
264         uint256 _amt,
265         address _assim
266     )
267         private
268         view
269         returns (
270             int128 amt_,
271             int128 oGLiq_,
272             int128 nGLiq_,
273             int128[] memory,
274             int128[] memory
275         )
276     {
277         uint256 _length = curve.assets.length;
278         int128[] memory nBals_ = new int128[](_length);
279         int128[] memory oBals_ = new int128[](_length);
280 
281         for (uint256 i = 0; i < _length; i++) {
282             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(curve.assets[i].addr);
283             else {
284                 int128 _bal;
285                 (amt_, _bal) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
286 
287                 oBals_[i] = _bal;
288                 nBals_[i] = _bal.add(amt_);
289             }
290 
291             oGLiq_ += oBals_[i];
292             nGLiq_ += nBals_[i];
293         }
294 
295         nGLiq_ = nGLiq_.sub(amt_);
296         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
297 
298         return (amt_, oGLiq_, nGLiq_, nBals_, oBals_);
299     }
300 
301     function viewTargetSwapData(
302         Storage.Curve storage curve,
303         uint256 _inputIx,
304         uint256 _outputIx,
305         uint256 _amt,
306         address _assim
307     )
308         private
309         view
310         returns (
311             int128 amt_,
312             int128 oGLiq_,
313             int128 nGLiq_,
314             int128[] memory,
315             int128[] memory
316         )
317     {
318         uint256 _length = curve.assets.length;
319         int128[] memory nBals_ = new int128[](_length);
320         int128[] memory oBals_ = new int128[](_length);
321 
322         for (uint256 i = 0; i < _length; i++) {
323             if (i != _inputIx) nBals_[i] = oBals_[i] = Assimilators.viewNumeraireBalance(curve.assets[i].addr);
324             else {
325                 int128 _bal;
326                 (amt_, _bal) = Assimilators.viewNumeraireAmountAndBalance(_assim, _amt);
327                 amt_ = amt_.neg();
328 
329                 oBals_[i] = _bal;
330                 nBals_[i] = _bal.add(amt_);
331             }
332 
333             oGLiq_ += oBals_[i];
334             nGLiq_ += nBals_[i];
335         }
336 
337         nGLiq_ = nGLiq_.sub(amt_);
338         nBals_[_outputIx] = ABDKMath64x64.sub(nBals_[_outputIx], amt_);
339 
340         return (amt_, oGLiq_, nGLiq_, nBals_, oBals_);
341     }
342 }
