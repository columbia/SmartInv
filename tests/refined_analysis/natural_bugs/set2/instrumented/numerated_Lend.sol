1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IFactory} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IFactory.sol';
6 import {IWETH} from '../interfaces/IWETH.sol';
7 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
8 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
9 import {ILend} from '../interfaces/ILend.sol';
10 import {LendMath} from './LendMath.sol';
11 import {Deploy} from './Deploy.sol';
12 import {MsgValue} from './MsgValue.sol';
13 
14 library Lend {
15     using LendMath for IPair;
16     using Deploy for IConvenience.Native;
17 
18     function lendGivenBond(
19         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
20         IConvenience convenience,
21         IFactory factory,
22         ILend.LendGivenBond calldata params
23     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
24         (assetIn, claimsOut) = _lendGivenBond(
25             natives,
26             ILend._LendGivenBond(
27                 convenience,
28                 factory,
29                 params.asset,
30                 params.collateral,
31                 params.maturity,
32                 msg.sender,
33                 params.bondTo,
34                 params.insuranceTo,
35                 params.assetIn,
36                 params.bondOut,
37                 params.minInsurance,
38                 params.deadline
39             )
40         );
41     }
42 
43     function lendGivenBondETHAsset(
44         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
45         IConvenience convenience,
46         IFactory factory,
47         IWETH weth,
48         ILend.LendGivenBondETHAsset calldata params
49     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
50         uint112 assetInETH = MsgValue.getUint112();
51 
52         (assetIn, claimsOut) = _lendGivenBond(
53             natives,
54             ILend._LendGivenBond(
55                 convenience,
56                 factory,
57                 weth,
58                 params.collateral,
59                 params.maturity,
60                 address(this),
61                 params.bondTo,
62                 params.insuranceTo,
63                 assetInETH,
64                 params.bondOut,
65                 params.minInsurance,
66                 params.deadline
67             )
68         );
69     }
70 
71     function lendGivenBondETHCollateral(
72         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
73         IConvenience convenience,
74         IFactory factory,
75         IWETH weth,
76         ILend.LendGivenBondETHCollateral calldata params
77     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
78         (assetIn, claimsOut) = _lendGivenBond(
79             natives,
80             ILend._LendGivenBond(
81                 convenience,
82                 factory,
83                 params.asset,
84                 weth,
85                 params.maturity,
86                 msg.sender,
87                 params.bondTo,
88                 params.insuranceTo,
89                 params.assetIn,
90                 params.bondOut,
91                 params.minInsurance,
92                 params.deadline
93             )
94         );
95     }
96 
97     function lendGivenInsurance(
98         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
99         IConvenience convenience,
100         IFactory factory,
101         ILend.LendGivenInsurance calldata params
102     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
103         (assetIn, claimsOut) = _lendGivenInsurance(
104             natives,
105             ILend._LendGivenInsurance(
106                 convenience,
107                 factory,
108                 params.asset,
109                 params.collateral,
110                 params.maturity,
111                 msg.sender,
112                 params.bondTo,
113                 params.insuranceTo,
114                 params.assetIn,
115                 params.insuranceOut,
116                 params.minBond,
117                 params.deadline
118             )
119         );
120     }
121 
122     function lendGivenInsuranceETHAsset(
123         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
124         IConvenience convenience,
125         IFactory factory,
126         IWETH weth,
127         ILend.LendGivenInsuranceETHAsset calldata params
128     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
129         uint112 assetInETH = MsgValue.getUint112();
130 
131         (assetIn, claimsOut) = _lendGivenInsurance(
132             natives,
133             ILend._LendGivenInsurance(
134                 convenience,
135                 factory,
136                 weth,
137                 params.collateral,
138                 params.maturity,
139                 address(this),
140                 params.bondTo,
141                 params.insuranceTo,
142                 assetInETH,
143                 params.insuranceOut,
144                 params.minBond,
145                 params.deadline
146             )
147         );
148     }
149 
150     function lendGivenInsuranceETHCollateral(
151         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
152         IConvenience convenience,
153         IFactory factory,
154         IWETH weth,
155         ILend.LendGivenInsuranceETHCollateral calldata params
156     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
157         (assetIn, claimsOut) = _lendGivenInsurance(
158             natives,
159             ILend._LendGivenInsurance(
160                 convenience,
161                 factory,
162                 params.asset,
163                 weth,
164                 params.maturity,
165                 msg.sender,
166                 params.bondTo,
167                 params.insuranceTo,
168                 params.assetIn,
169                 params.insuranceOut,
170                 params.minBond,
171                 params.deadline
172             )
173         );
174     }
175 
176     function lendGivenPercent(
177         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
178         IConvenience convenience,
179         IFactory factory,
180         ILend.LendGivenPercent calldata params
181     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
182         (assetIn, claimsOut) = _lendGivenPercent(
183             natives,
184             ILend._LendGivenPercent(
185                 convenience,
186                 factory,
187                 params.asset,
188                 params.collateral,
189                 params.maturity,
190                 msg.sender,
191                 params.bondTo,
192                 params.insuranceTo,
193                 params.assetIn,
194                 params.percent,
195                 params.minBond,
196                 params.minInsurance,
197                 params.deadline
198             )
199         );
200     }
201 
202     function lendGivenPercentETHAsset(
203         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
204         IConvenience convenience,
205         IFactory factory,
206         IWETH weth,
207         ILend.LendGivenPercentETHAsset calldata params
208     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
209         uint112 assetInETH = MsgValue.getUint112();
210 
211         (assetIn, claimsOut) = _lendGivenPercent(
212             natives,
213             ILend._LendGivenPercent(
214                 convenience,
215                 factory,
216                 weth,
217                 params.collateral,
218                 params.maturity,
219                 address(this),
220                 params.bondTo,
221                 params.insuranceTo,
222                 assetInETH,
223                 params.percent,
224                 params.minBond,
225                 params.minInsurance,
226                 params.deadline
227             )
228         );
229     }
230 
231     function lendGivenPercentETHCollateral(
232         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
233         IConvenience convenience,
234         IFactory factory,
235         IWETH weth,
236         ILend.LendGivenPercentETHCollateral calldata params
237     ) external returns (uint256 assetIn, IPair.Claims memory claimsOut) {
238         (assetIn, claimsOut) = _lendGivenPercent(
239             natives,
240             ILend._LendGivenPercent(
241                 convenience,
242                 factory,
243                 params.asset,
244                 weth,
245                 params.maturity,
246                 msg.sender,
247                 params.bondTo,
248                 params.insuranceTo,
249                 params.assetIn,
250                 params.percent,
251                 params.minBond,
252                 params.minInsurance,
253                 params.deadline
254             )
255         );
256     }
257 
258     function _lendGivenBond(
259         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
260         ILend._LendGivenBond memory params
261     ) private returns (uint256 assetIn, IPair.Claims memory claimsOut) {
262         require(params.bondOut > params.assetIn, 'E517');
263 
264         IPair pair = params.factory.getPair(params.asset, params.collateral);
265         require(address(pair) != address(0), 'E501');
266         (uint112 xIncrease, uint112 yDecrease, uint112 zDecrease) = pair.givenBond(
267             params.maturity,
268             params.assetIn,
269             params.bondOut
270         );
271 
272         (assetIn, claimsOut) = _lend(
273             natives,
274             ILend._Lend(
275                 params.convenience,
276                 pair,
277                 params.asset,
278                 params.collateral,
279                 params.maturity,
280                 params.from,
281                 params.bondTo,
282                 params.insuranceTo,
283                 xIncrease,
284                 yDecrease,
285                 zDecrease,
286                 params.deadline
287             )
288         );
289 
290         require(uint128(claimsOut.insuranceInterest) + claimsOut.insurancePrincipal >= params.minInsurance, 'E515');
291     }
292 
293     function _lendGivenInsurance(
294         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
295         ILend._LendGivenInsurance memory params
296     ) private returns (uint256 assetIn, IPair.Claims memory claimsOut) {
297         IPair pair = params.factory.getPair(params.asset, params.collateral);
298         require(address(pair) != address(0), 'E501');
299 
300         (uint112 xIncrease, uint112 yDecrease, uint112 zDecrease) = pair.givenInsurance(
301             params.maturity,
302             params.assetIn,
303             params.insuranceOut
304         );
305 
306         (assetIn, claimsOut) = _lend(
307             natives,
308             ILend._Lend(
309                 params.convenience,
310                 pair,
311                 params.asset,
312                 params.collateral,
313                 params.maturity,
314                 params.from,
315                 params.bondTo,
316                 params.insuranceTo,
317                 xIncrease,
318                 yDecrease,
319                 zDecrease,
320                 params.deadline
321             )
322         );
323 
324         require(uint128(claimsOut.bondInterest) + claimsOut.bondPrincipal >= params.minBond, 'E514');
325     }
326 
327     function _lendGivenPercent(
328         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
329         ILend._LendGivenPercent memory params
330     ) private returns (uint256 assetIn, IPair.Claims memory claimsOut) {
331         require(params.percent <= 0x100000000, 'E505');
332 
333         IPair pair = params.factory.getPair(params.asset, params.collateral);
334         require(address(pair) != address(0), 'E501');
335 
336         (uint112 xIncrease, uint112 yDecrease, uint112 zDecrease) = pair.givenPercent(
337             params.maturity,
338             params.assetIn,
339             params.percent
340         );
341 
342         (assetIn, claimsOut) = _lend(
343             natives,
344             ILend._Lend(
345                 params.convenience,
346                 pair,
347                 params.asset,
348                 params.collateral,
349                 params.maturity,
350                 params.from,
351                 params.bondTo,
352                 params.insuranceTo,
353                 xIncrease,
354                 yDecrease,
355                 zDecrease,
356                 params.deadline
357             )
358         );
359 
360         require(uint128(claimsOut.bondInterest) + claimsOut.bondPrincipal >= params.minBond, 'E514');
361         require(uint128(claimsOut.insuranceInterest) + claimsOut.insurancePrincipal >= params.minInsurance, 'E515');
362     }
363 
364     function _lend(
365         mapping(IERC20 => mapping(IERC20 => mapping(uint256 => IConvenience.Native))) storage natives,
366         ILend._Lend memory params
367     ) private returns (uint256 assetIn, IPair.Claims memory claimsOut) {
368         require(params.deadline >= block.timestamp, 'E504');
369         require(params.maturity > block.timestamp, 'E508');
370 
371         IConvenience.Native storage native = natives[params.asset][params.collateral][params.maturity];
372         if (address(native.liquidity) == address(0))
373             native.deploy(params.convenience, params.pair, params.asset, params.collateral, params.maturity);
374 
375         (assetIn, claimsOut) = params.pair.lend(
376             IPair.LendParam(
377                 params.maturity,
378                 address(this),
379                 address(this),
380                 params.xIncrease,
381                 params.yDecrease,
382                 params.zDecrease,
383                 bytes(abi.encode(params.asset, params.collateral, params.from))
384             )
385         );
386 
387         native.bondInterest.mint(params.bondTo, claimsOut.bondInterest);
388         native.bondPrincipal.mint(params.bondTo, claimsOut.bondPrincipal);
389         native.insuranceInterest.mint(params.insuranceTo, claimsOut.insuranceInterest);
390         native.insurancePrincipal.mint(params.insuranceTo, claimsOut.insurancePrincipal);
391     }
392 }
