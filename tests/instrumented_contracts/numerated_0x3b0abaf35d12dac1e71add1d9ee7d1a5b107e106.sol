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
102     uint public maxSplitAmtEth = 50000000000000000000;
103     uint public maxSplitAmtDai = 20000000000000000000000;
104     uint public cut = 997500000000000000; // 0.25% charge
105 
106     function setAllowance(TokenInterface _token, address _spender) internal {
107         if (_token.allowance(address(this), _spender) != uint(-1)) {
108             _token.approve(_spender, uint(-1));
109         }
110     }
111 
112     modifier isAdmin {
113         require(msg.sender == adminOne || msg.sender == adminTwo, "Not an Admin");
114         _;
115     }
116 
117 }
118 
119 
120 contract AdminStuffs is Helper {
121 
122     function setSplitEth(uint amt) public isAdmin {
123         maxSplitAmtEth = amt;
124     }
125 
126     function setSplitDai(uint amt) public isAdmin {
127         maxSplitAmtDai = amt;
128     }
129 
130     function withdrawToken(address token) public isAdmin {
131         uint daiBal = TokenInterface(token).balanceOf(address(this));
132         TokenInterface(token).transfer(msg.sender, daiBal);
133     }
134 
135     function withdrawEth() public payable isAdmin {
136         msg.sender.transfer(address(this).balance);
137     }
138 
139     function changeFee(uint amt) public isAdmin {
140         if (amt > 997000000000000000) {
141             cut = 997000000000000000; // maximum fees can be 0.3%. Minimum 0%
142         } else {
143             cut = amt;
144         }
145     }
146 
147 }
148 
149 
150 contract SplitHelper is AdminStuffs {
151 
152     function getBest(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
153         uint finalSrcAmt = srcAmt;
154         if (src == daiAddr) {
155             finalSrcAmt = wmul(srcAmt, cut);
156         }
157         uint eth2DaiPrice = getRateEth2Dai(src, dest, finalSrcAmt);
158         uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
159         uint uniswapPrice = getRateUniswap(src, dest, finalSrcAmt);
160         if (eth2DaiPrice > kyberPrice && eth2DaiPrice > uniswapPrice) {
161             destAmt = eth2DaiPrice;
162             bestExchange = 0;
163         } else if (kyberPrice > uniswapPrice && kyberPrice > eth2DaiPrice) {
164             destAmt = kyberPrice;
165             bestExchange = 1;
166         } else {
167             destAmt = uniswapPrice;
168             bestExchange = 2;
169         }
170         if (dest == daiAddr) {
171             destAmt = wmul(destAmt, cut);
172         }
173         require(destAmt != 0, "Dest Amt = 0");
174     }
175 
176     function getRateEth2Dai(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
177         if (src == ethAddr) {
178             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(dest, wethAddr, srcAmt);
179         } else if (dest == ethAddr) {
180             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(wethAddr, src, srcAmt);
181         }
182     }
183 
184     function getRateKyber(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
185         (uint kyberPrice,) = KyberInterface(kyberAddr).getExpectedRate(src, dest, srcAmt);
186         destAmt = wmul(srcAmt, kyberPrice);
187     }
188 
189     function getRateUniswap(address src, address dest, uint srcAmt) public view returns (uint destAmt) {
190         if (src == ethAddr) {
191             destAmt = UniswapExchange(uniswapAddr).getEthToTokenInputPrice(srcAmt);
192         } else if (dest == ethAddr) {
193             destAmt = UniswapExchange(uniswapAddr).getTokenToEthInputPrice(srcAmt);
194         }
195     }
196 
197 }
198 
199 
200 contract SplitResolver is SplitHelper {
201 
202     function ethToDaiLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
203         if (srcAmt > splitAmt) {
204             uint amtToSwap = splitAmt;
205             uint nextSrcAmt = srcAmt - splitAmt;
206             (uint bestExchange,) = getBest(ethAddr, daiAddr, amtToSwap);
207             uint ethBought = finalAmt;
208             if (bestExchange == 0) {
209                 ethBought += swapEth2Dai(wethAddr, daiAddr, amtToSwap);
210             } else if (bestExchange == 1) {
211                 ethBought += swapKyber(ethAddr, daiAddr, amtToSwap);
212             } else {
213                 ethBought += swapUniswap(ethAddr, daiAddr, amtToSwap);
214             }
215             destAmt = ethToDaiLoop(nextSrcAmt, splitAmt, ethBought);
216         } else if (srcAmt > 0) {
217             (uint bestExchange,) = getBest(ethAddr, daiAddr, srcAmt);
218             destAmt = finalAmt;
219             if (bestExchange == 0) {
220                 destAmt += swapEth2Dai(wethAddr, daiAddr, srcAmt);
221             } else if (bestExchange == 1) {
222                 destAmt += swapKyber(ethAddr, daiAddr, srcAmt);
223             } else {
224                 destAmt += swapUniswap(ethAddr, daiAddr, srcAmt);
225             }
226         } else {
227             destAmt = finalAmt;
228         }
229     }
230 
231     function daiToEthLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
232         if (srcAmt > splitAmt) {
233             uint amtToSwap = splitAmt;
234             uint nextSrcAmt = srcAmt - splitAmt;
235             (uint bestExchange,) = getBest(daiAddr, ethAddr, amtToSwap);
236             uint ethBought = finalAmt;
237             if (bestExchange == 0) {
238                 ethBought += swapEth2Dai(daiAddr, wethAddr, amtToSwap);
239             } else if (bestExchange == 1) {
240                 ethBought += swapKyber(daiAddr, ethAddr, amtToSwap);
241             } else {
242                 ethBought += swapUniswap(daiAddr, ethAddr, amtToSwap);
243             }
244             destAmt = daiToEthLoop(nextSrcAmt, splitAmt, ethBought);
245         } else if (srcAmt > 0) {
246             (uint bestExchange,) = getBest(daiAddr, ethAddr, srcAmt);
247             destAmt = finalAmt;
248             if (bestExchange == 0) {
249                 destAmt += swapEth2Dai(daiAddr, wethAddr, srcAmt);
250             } else if (bestExchange == 1) {
251                 destAmt += swapKyber(daiAddr, ethAddr, srcAmt);
252             } else {
253                 destAmt += swapUniswap(daiAddr, ethAddr, srcAmt);
254             }
255             TokenInterface wethContract = TokenInterface(wethAddr);
256             uint balanceWeth = wethContract.balanceOf(address(this));
257             wethContract.withdraw(balanceWeth);
258         } else {
259             TokenInterface wethContract = TokenInterface(wethAddr);
260             uint balanceWeth = wethContract.balanceOf(address(this));
261             wethContract.withdraw(balanceWeth);
262             destAmt = finalAmt;
263         }
264     }
265 
266     function swapEth2Dai(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
267         if (src == wethAddr) {
268             TokenInterface(wethAddr).deposit.value(srcAmt)();
269         }
270         destAmt = Eth2DaiInterface(eth2daiAddr).sellAllAmount(
271                 src,
272                 srcAmt,
273                 dest,
274                 0
275             );
276     }
277 
278     function swapKyber(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
279         destAmt = KyberInterface(kyberAddr).trade.value(srcAmt)(
280                 src,
281                 srcAmt,
282                 dest,
283                 address(this),
284                 2**255,
285                 0,
286                 adminOne
287             );
288     }
289 
290     function swapUniswap(address src, address dest, uint srcAmt) internal returns (uint destAmt) {
291         if (src == ethAddr) {
292             destAmt = UniswapExchange(uniswapAddr).ethToTokenSwapInput.value(srcAmt)(uint(0), uint(1899063809));
293         } else if (dest == ethAddr) {
294             destAmt = UniswapExchange(uniswapAddr).tokenToEthSwapInput(srcAmt, uint(0), uint(1899063809));
295         }
296     }
297 
298 }
299 
300 
301 contract SplitSwap is SplitResolver {
302 
303     function ethToDaiSwap(uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) { // srcAmt = msg.value
304         require(maxSplitAmtEth >= splitAmt, "split amt > max");
305         destAmt = ethToDaiLoop(msg.value, splitAmt, 0);
306         destAmt = wmul(destAmt, cut);
307         require(destAmt > slippageAmt, "Dest Amt < slippage");
308         require(TokenInterface(daiAddr).transfer(msg.sender, destAmt), "Not enough DAI to transfer");
309     }
310 
311     function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) {
312         require(maxSplitAmtDai >= splitAmt, "split amt > max");
313         require(TokenInterface(daiAddr).transferFrom(msg.sender, address(this), srcAmt), "Token Approved?");
314         uint finalSrcAmt = wmul(srcAmt, cut);
315         destAmt = daiToEthLoop(finalSrcAmt, splitAmt, 0);
316         require(destAmt > slippageAmt, "Dest Amt < slippage");
317         msg.sender.transfer(destAmt);
318     }
319 
320 }
321 
322 
323 contract InstaSwap is SplitSwap {
324 
325     constructor() public {
326         setAllowance(TokenInterface(daiAddr), eth2daiAddr);
327         setAllowance(TokenInterface(daiAddr), kyberAddr);
328         setAllowance(TokenInterface(daiAddr), uniswapAddr);
329         setAllowance(TokenInterface(wethAddr), eth2daiAddr);
330         setAllowance(TokenInterface(wethAddr), wethAddr);
331     }
332 
333     function() external payable {}
334 
335 }