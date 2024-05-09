1 pragma solidity ^0.5.7;
2 
3 interface TokenInterface {
4     function allowance(address, address) external view returns (uint);
5     function balanceOf(address) external view returns (uint);
6     function approve(address, uint) external;
7     function transfer(address, uint) external returns (bool);
8     function transferFrom(address, address, uint) external returns (bool);
9     function deposit() external payable;
10     function withdraw(uint) external;
11 }
12 
13 interface UniswapExchange {
14     function getEthToTokenInputPrice(uint ethSold) external view returns (uint tokenBought);
15     function getTokenToEthInputPrice(uint tokenSold) external view returns (uint ethBought);
16     function ethToTokenSwapInput(uint minTokens, uint deadline) external payable returns (uint tokenBought);
17     function tokenToEthSwapInput(uint tokenSold, uint minEth, uint deadline) external returns (uint ethBought);
18 }
19 
20 interface KyberInterface {
21     function trade(
22         address src,
23         uint srcAmount,
24         address dest,
25         address destAddress,
26         uint maxDestAmount,
27         uint minConversionRate,
28         address walletId
29         ) external payable returns (uint);
30 
31     function getExpectedRate(
32         address src,
33         address dest,
34         uint srcQty
35         ) external view returns (uint, uint);
36 }
37 
38 interface Eth2DaiInterface {
39     function getBuyAmount(address dest, address src, uint srcAmt) external view returns(uint);
40 	function getPayAmount(address src, address dest, uint destAmt) external view returns (uint);
41 	function sellAllAmount(
42         address src,
43         uint srcAmt,
44         address dest,
45         uint minDest
46     ) external returns (uint destAmt);
47 	function buyAllAmount(
48         address dest,
49         uint destAmt,
50         address src,
51         uint maxSrc
52     ) external returns (uint srcAmt);
53 }
54 
55 
56 contract DSMath {
57 
58     function add(uint x, uint y) internal pure returns (uint z) {
59         require((z = x + y) >= x, "math-not-safe");
60     }
61 
62     function sub(uint x, uint y) internal pure returns (uint z) {
63         require((z = x - y) <= x, "ds-math-sub-underflow");
64     }
65 
66     function mul(uint x, uint y) internal pure returns (uint z) {
67         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
68     }
69 
70     uint constant WAD = 10 ** 18;
71     uint constant RAY = 10 ** 27;
72 
73     function rmul(uint x, uint y) internal pure returns (uint z) {
74         z = add(mul(x, y), RAY / 2) / RAY;
75     }
76 
77     function rdiv(uint x, uint y) internal pure returns (uint z) {
78         z = add(mul(x, RAY), y / 2) / y;
79     }
80 
81     function wmul(uint x, uint y) internal pure returns (uint z) {
82         z = add(mul(x, y), WAD / 2) / WAD;
83     }
84 
85     function wdiv(uint x, uint y) internal pure returns (uint z) {
86         z = add(mul(x, WAD), y / 2) / y;
87     }
88 
89 }
90 
91 
92 contract Helper is DSMath {
93 
94     address public eth2daiAddr = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
95     address public uniswapAddr = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14; // Uniswap DAI exchange
96     address public kyberAddr = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
97     address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
98     address public wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
99     address public daiAddr = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
100     address public adminOne = 0xa7615CD307F323172331865181DC8b80a2834324;
101     address public adminTwo = 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
102     uint public maxSplitAmtEth = 60000000000000000000;
103     uint public maxSplitAmtDai = 20000000000000000000000;
104     uint public cut = 997500000000000000; // 0.25% charge
105     uint public minDai = 200000000000000000000; // DAI < 200 swap with Kyber or Uniswap
106     uint public minEth = 1000000000000000000; // ETH < 1 swap with Kyber or Uniswap
107 
108     function setAllowance(TokenInterface _token, address _spender) internal {
109         if (_token.allowance(address(this), _spender) != uint(-1)) {
110             _token.approve(_spender, uint(-1));
111         }
112     }
113 
114     modifier isAdmin {
115         require(msg.sender == adminOne || msg.sender == adminTwo, "Not an Admin");
116         _;
117     }
118 
119 }
120 
121 
122 contract AdminStuffs is Helper {
123 
124     function setSplitEth(uint amt) public isAdmin {
125         maxSplitAmtEth = amt;
126     }
127 
128     function setSplitDai(uint amt) public isAdmin {
129         maxSplitAmtDai = amt;
130     }
131 
132     function withdrawToken(address token) public isAdmin {
133         uint daiBal = TokenInterface(token).balanceOf(address(this));
134         TokenInterface(token).transfer(msg.sender, daiBal);
135     }
136 
137     function withdrawEth() public payable isAdmin {
138         msg.sender.transfer(address(this).balance);
139     }
140 
141     function changeFee(uint amt) public isAdmin {
142         if (amt > 997000000000000000) {
143             cut = 997000000000000000; // maximum fees can be 0.3%. Minimum 0%
144         } else {
145             cut = amt;
146         }
147     }
148 
149     function changeMinEth(uint amt) public isAdmin {
150         minEth = amt;
151     }
152 
153     function changeMinDai(uint amt) public isAdmin {
154         minDai = amt;
155     }
156 
157 }
158 
159 
160 contract SplitHelper is AdminStuffs {
161 
162     function getBest(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
163         uint finalSrcAmt = srcAmt;
164         if (src == daiAddr) {
165             finalSrcAmt = wmul(srcAmt, cut);
166         }
167         uint eth2DaiPrice = getRateEth2Dai(src, dest, finalSrcAmt);
168         uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
169         uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
170         if (eth2DaiPrice > kyberPrice && eth2DaiPrice > uniswapPrice) {
171             destAmt = eth2DaiPrice;
172             bestExchange = 0;
173         } else if (kyberPrice > eth2DaiPrice && kyberPrice > uniswapPrice) {
174             destAmt = kyberPrice;
175             bestExchange = 1;
176         } else {
177             destAmt = uniswapPrice;
178             bestExchange = 2;
179         }
180         if (dest == daiAddr) {
181             destAmt = wmul(destAmt, cut);
182         }
183         require(destAmt != 0, "Dest Amt = 0");
184     }
185 
186     function getBestUniswapKyber(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
187         uint finalSrcAmt = srcAmt;
188         if (src == daiAddr) {
189             finalSrcAmt = wmul(srcAmt, cut);
190         }
191         uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
192         uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
193         if (kyberPrice >= uniswapPrice) {
194             destAmt = kyberPrice;
195             bestExchange = 1;
196         } else {
197             destAmt = uniswapPrice;
198             bestExchange = 2;
199         }
200         if (dest == daiAddr) {
201             destAmt = wmul(destAmt, cut);
202         }
203         require(destAmt != 0, "Dest Amt = 0");
204     }
205 
206     function getRateEth2Dai(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
207         if (src == ethAddr) {
208             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(dest, wethAddr, srcAmt);
209         } else if (dest == ethAddr) {
210             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(wethAddr, src, srcAmt);
211         }
212     }
213 
214     function getRateKyber(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
215         (uint kyberPrice,) = KyberInterface(kyberAddr).getExpectedRate(src, dest, srcAmt);
216         destAmt = wmul(srcAmt, kyberPrice);
217     }
218 
219     function getRateUniswap(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
220         if (src == ethAddr) {
221             destAmt = UniswapExchange(uniswapAddr).getEthToTokenInputPrice(srcAmt);
222         } else if (dest == ethAddr) {
223             destAmt = UniswapExchange(uniswapAddr).getTokenToEthInputPrice(srcAmt);
224         }
225     }
226 
227 }
228 
229 
230 contract SplitResolver is SplitHelper {
231 
232     event LogEthToDai(address user, uint srcAmt, uint destAmt);
233     event LogDaiToEth(address user, uint srcAmt, uint destAmt);
234 
235     function swapEth2Dai(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
236         if (src == wethAddr) {
237             TokenInterface(wethAddr).deposit.value(srcAmt)();
238         }
239         destAmt = Eth2DaiInterface(eth2daiAddr).sellAllAmount(
240                 src,
241                 srcAmt,
242                 dest,
243                 0
244             );
245     }
246 
247     function swapKyber(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
248         uint ethAmt = src == ethAddr ? srcAmt : 0;
249         destAmt = KyberInterface(kyberAddr).trade.value(ethAmt)(
250                 src,
251                 srcAmt,
252                 dest,
253                 address(this),
254                 2**255,
255                 0,
256                 adminOne
257             );
258     }
259 
260     function swapUniswap(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
261         if (src == ethAddr) {
262             destAmt = UniswapExchange(uniswapAddr).ethToTokenSwapInput.value(srcAmt)(1, block.timestamp + 1);
263         } else if (dest == ethAddr) {
264             destAmt = UniswapExchange(uniswapAddr).tokenToEthSwapInput(srcAmt, 1, block.timestamp + 1);
265         }
266     }
267 
268     function ethToDaiBestSwap(uint bestExchange, uint amtToSwap) internal returns (uint destAmt) {
269         if (bestExchange == 0) {
270             destAmt += swapEth2Dai(wethAddr, daiAddr, amtToSwap);
271         } else if (bestExchange == 1) {
272             destAmt += swapKyber(ethAddr, daiAddr, amtToSwap);
273         } else {
274             destAmt += swapUniswap(ethAddr, daiAddr, amtToSwap);
275         }
276     }
277 
278     function ethToDaiLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
279         if (srcAmt > splitAmt) {
280             uint amtToSwap = splitAmt;
281             uint nextSrcAmt = srcAmt - splitAmt;
282             (uint bestExchange,) = getBest(ethAddr, daiAddr, amtToSwap);
283             uint daiBought = finalAmt;
284             daiBought += ethToDaiBestSwap(bestExchange, amtToSwap);
285             destAmt = ethToDaiLoop(nextSrcAmt, splitAmt, daiBought);
286         } else if (srcAmt > minEth) {
287             (uint bestExchange,) = getBest(ethAddr, daiAddr, srcAmt);
288             destAmt = finalAmt;
289             destAmt += ethToDaiBestSwap(bestExchange, srcAmt);
290         } else if (srcAmt > 0) {
291             (uint bestExchange,) = getBestUniswapKyber(ethAddr, daiAddr, srcAmt);
292             destAmt = finalAmt;
293             destAmt += ethToDaiBestSwap(bestExchange, srcAmt);
294         } else {
295             destAmt = finalAmt;
296         }
297     }
298 
299     function daiToEthBestSwap(uint bestExchange, uint amtToSwap) internal returns (uint destAmt) {
300         if (bestExchange == 0) {
301             destAmt += swapEth2Dai(daiAddr, wethAddr, amtToSwap);
302         } else if (bestExchange == 1) {
303             destAmt += swapKyber(daiAddr, ethAddr, amtToSwap);
304         } else {
305             destAmt += swapUniswap(daiAddr, ethAddr, amtToSwap);
306         }
307     }
308 
309     function daiToEthLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
310         if (srcAmt > splitAmt) {
311             uint amtToSwap = splitAmt;
312             uint nextSrcAmt = srcAmt - splitAmt;
313             (uint bestExchange,) = getBest(daiAddr, ethAddr, amtToSwap);
314             uint ethBought = finalAmt;
315             ethBought += daiToEthBestSwap(bestExchange, amtToSwap);
316             destAmt = daiToEthLoop(nextSrcAmt, splitAmt, ethBought);
317         } else if (srcAmt > minDai) {
318             (uint bestExchange,) = getBest(daiAddr, ethAddr, srcAmt);
319             destAmt = finalAmt;
320             destAmt += daiToEthBestSwap(bestExchange, srcAmt);
321         } else if (srcAmt > 0) {
322             (uint bestExchange,) = getBestUniswapKyber(daiAddr, ethAddr, srcAmt);
323             destAmt = finalAmt;
324             destAmt += daiToEthBestSwap(bestExchange, srcAmt);
325         } else {
326             destAmt = finalAmt;
327         }
328     }
329 
330     function wethToEth() internal {
331         TokenInterface wethContract = TokenInterface(wethAddr);
332         uint balanceWeth = wethContract.balanceOf(address(this));
333         if (balanceWeth > 0) {
334             wethContract.withdraw(balanceWeth);
335         }
336     }
337 
338 }
339 
340 
341 contract Swap is SplitResolver {
342 
343     function ethToDaiSwap(uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) { // srcAmt = msg.value
344         require(maxSplitAmtEth >= splitAmt, "split amt > max");
345         destAmt = ethToDaiLoop(msg.value, splitAmt, 0);
346         destAmt = wmul(destAmt, cut);
347         require(destAmt > slippageAmt, "Dest Amt < slippage");
348         require(TokenInterface(daiAddr).transfer(msg.sender, destAmt), "Not enough DAI to transfer");
349         emit LogEthToDai(msg.sender, msg.value, destAmt);
350     }
351 
352     function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) public returns (uint destAmt) {
353         require(maxSplitAmtDai >= splitAmt, "split amt > max");
354         require(TokenInterface(daiAddr).transferFrom(msg.sender, address(this), srcAmt), "Token Approved?");
355         uint finalSrcAmt = wmul(srcAmt, cut);
356         destAmt = daiToEthLoop(finalSrcAmt, splitAmt, 0);
357         wethToEth();
358         require(destAmt > slippageAmt, "Dest Amt < slippage");
359         msg.sender.transfer(destAmt);
360         emit LogDaiToEth(msg.sender, finalSrcAmt, destAmt);
361     }
362 
363 }
364 
365 
366 contract SplitSwap is Swap {
367 
368     constructor() public {
369         setAllowance(TokenInterface(daiAddr), eth2daiAddr);
370         setAllowance(TokenInterface(daiAddr), kyberAddr);
371         setAllowance(TokenInterface(daiAddr), uniswapAddr);
372         setAllowance(TokenInterface(wethAddr), eth2daiAddr);
373         setAllowance(TokenInterface(wethAddr), wethAddr);
374     }
375 
376     function() external payable {}
377 
378 }