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
13 interface KyberInterface {
14     function trade(
15         address src,
16         uint srcAmount,
17         address dest,
18         address destAddress,
19         uint maxDestAmount,
20         uint minConversionRate,
21         address walletId
22         ) external payable returns (uint);
23 
24     function getExpectedRate(
25         address src,
26         address dest,
27         uint srcQty
28         ) external view returns (uint, uint);
29 }
30 
31 interface Eth2DaiInterface {
32     function getBuyAmount(address dest, address src, uint srcAmt) external view returns(uint);
33 	function getPayAmount(address src, address dest, uint destAmt) external view returns (uint);
34 	function sellAllAmount(
35         address src,
36         uint srcAmt,
37         address dest,
38         uint minDest
39     ) external returns (uint destAmt);
40 	function buyAllAmount(
41         address dest,
42         uint destAmt,
43         address src,
44         uint maxSrc
45     ) external returns (uint srcAmt);
46 }
47 
48 
49 contract DSMath {
50 
51     function add(uint x, uint y) internal pure returns (uint z) {
52         require((z = x + y) >= x, "math-not-safe");
53     }
54 
55     function sub(uint x, uint y) internal pure returns (uint z) {
56         require((z = x - y) <= x, "ds-math-sub-underflow");
57     }
58 
59     function mul(uint x, uint y) internal pure returns (uint z) {
60         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
61     }
62 
63     uint constant WAD = 10 ** 18;
64     uint constant RAY = 10 ** 27;
65 
66     function rmul(uint x, uint y) internal pure returns (uint z) {
67         z = add(mul(x, y), RAY / 2) / RAY;
68     }
69 
70     function rdiv(uint x, uint y) internal pure returns (uint z) {
71         z = add(mul(x, RAY), y / 2) / y;
72     }
73 
74     function wmul(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, y), WAD / 2) / WAD;
76     }
77 
78     function wdiv(uint x, uint y) internal pure returns (uint z) {
79         z = add(mul(x, WAD), y / 2) / y;
80     }
81 
82 }
83 
84 
85 contract Helper is DSMath {
86 
87     address public eth2daiAddr = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
88     address public kyberAddr = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
89     address public ethAddr = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
90     address public wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
91     address public daiAddr = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
92     address public adminOne = 0xa7615CD307F323172331865181DC8b80a2834324;
93     address public adminTwo = 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
94     uint public maxSplitAmtEth = 60000000000000000000;
95     uint public maxSplitAmtDai = 20000000000000000000000;
96     uint public cut = 997500000000000000; // 0.25% charge
97 
98     function setAllowance(TokenInterface _token, address _spender) internal {
99         if (_token.allowance(address(this), _spender) != uint(-1)) {
100             _token.approve(_spender, uint(-1));
101         }
102     }
103 
104     modifier isAdmin {
105         require(msg.sender == adminOne || msg.sender == adminTwo, "Not an Admin");
106         _;
107     }
108 
109 }
110 
111 
112 contract AdminStuffs is Helper {
113 
114     function setSplitEth(uint amt) public isAdmin {
115         maxSplitAmtEth = amt;
116     }
117 
118     function setSplitDai(uint amt) public isAdmin {
119         maxSplitAmtDai = amt;
120     }
121 
122     function withdrawToken(address token) public isAdmin {
123         uint daiBal = TokenInterface(token).balanceOf(address(this));
124         TokenInterface(token).transfer(msg.sender, daiBal);
125     }
126 
127     function withdrawEth() public payable isAdmin {
128         msg.sender.transfer(address(this).balance);
129     }
130 
131     function changeFee(uint amt) public isAdmin {
132         if (amt > 997000000000000000) {
133             cut = 997000000000000000; // maximum fees can be 0.3%. Minimum 0%
134         } else {
135             cut = amt;
136         }
137     }
138 
139 }
140 
141 
142 contract SplitHelper is AdminStuffs {
143 
144     function getBest(address src, address dest, uint srcAmt) public view returns (uint bestExchange, uint destAmt) {
145         uint finalSrcAmt = srcAmt;
146         if (src == daiAddr) {
147             finalSrcAmt = wmul(srcAmt, cut);
148         }
149         uint eth2DaiPrice = getRateEth2Dai(src, dest, finalSrcAmt);
150         uint kyberPrice = getRateKyber(src, dest, finalSrcAmt);
151         if (eth2DaiPrice > kyberPrice) {
152             destAmt = eth2DaiPrice;
153             bestExchange = 0;
154         } else if (kyberPrice >= eth2DaiPrice) {
155             destAmt = kyberPrice;
156             bestExchange = 1;
157         }
158         if (dest == daiAddr) {
159             destAmt = wmul(destAmt, cut);
160         }
161         require(destAmt != 0, "Dest Amt = 0");
162     }
163 
164     function getRateEth2Dai(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
165         if (src == ethAddr) {
166             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(dest, wethAddr, srcAmt);
167         } else if (dest == ethAddr) {
168             destAmt = Eth2DaiInterface(eth2daiAddr).getBuyAmount(wethAddr, src, srcAmt);
169         }
170     }
171 
172     function getRateKyber(address src, address dest, uint srcAmt) internal view returns (uint destAmt) {
173         (uint kyberPrice,) = KyberInterface(kyberAddr).getExpectedRate(src, dest, srcAmt);
174         destAmt = wmul(srcAmt, kyberPrice);
175     }
176 
177 }
178 
179 
180 contract SplitResolver is SplitHelper {
181 
182     event LogEthToDai(uint srcAmt, uint destAmt);
183     event LogDaiToEth(uint srcAmt, uint destAmt);
184 
185     function ethToDaiLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
186         if (srcAmt > splitAmt) {
187             uint amtToSwap = splitAmt;
188             uint nextSrcAmt = srcAmt - splitAmt;
189             (uint bestExchange,) = getBest(ethAddr, daiAddr, amtToSwap);
190             uint daiBought = finalAmt;
191             if (bestExchange == 0) {
192                 daiBought += swapEth2Dai(wethAddr, daiAddr, amtToSwap);
193             } else if (bestExchange == 1) {
194                 daiBought += swapKyber(ethAddr, daiAddr, amtToSwap);
195             }
196             destAmt = ethToDaiLoop(nextSrcAmt, splitAmt, daiBought);
197         } else if (srcAmt > 0) {
198             destAmt = finalAmt;
199             destAmt += swapKyber(ethAddr, daiAddr, srcAmt);
200         } else {
201             destAmt = finalAmt;
202         }
203     }
204 
205     function daiToEthLoop(uint srcAmt, uint splitAmt, uint finalAmt) internal returns (uint destAmt) {
206         if (srcAmt > splitAmt) {
207             uint amtToSwap = splitAmt;
208             uint nextSrcAmt = srcAmt - splitAmt;
209             (uint bestExchange,) = getBest(daiAddr, ethAddr, amtToSwap);
210             uint ethBought = finalAmt;
211             if (bestExchange == 0) {
212                 ethBought += swapEth2Dai(daiAddr, wethAddr, amtToSwap);
213             } else if (bestExchange == 1) {
214                 ethBought += swapKyber(daiAddr, ethAddr, amtToSwap);
215             }
216             destAmt = daiToEthLoop(nextSrcAmt, splitAmt, ethBought);
217         } else if (srcAmt > 0) {
218             destAmt = finalAmt;
219             destAmt += swapKyber(daiAddr, ethAddr, srcAmt);
220             TokenInterface wethContract = TokenInterface(wethAddr);
221             uint balanceWeth = wethContract.balanceOf(address(this));
222             if (balanceWeth > 0) {
223                 wethContract.withdraw(balanceWeth);
224             }
225         } else {
226             TokenInterface wethContract = TokenInterface(wethAddr);
227             uint balanceWeth = wethContract.balanceOf(address(this));
228             if (balanceWeth > 0) {
229                 wethContract.withdraw(balanceWeth);
230             }
231             destAmt = finalAmt;
232         }
233     }
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
260 }
261 
262 
263 contract SplitSwap is SplitResolver {
264 
265     function ethToDaiSwap(uint splitAmt, uint slippageAmt) public payable returns (uint destAmt) { // srcAmt = msg.value
266         require(maxSplitAmtEth >= splitAmt, "split amt > max");
267         destAmt = ethToDaiLoop(msg.value, splitAmt, 0);
268         destAmt = wmul(destAmt, cut);
269         require(destAmt > slippageAmt, "Dest Amt < slippage");
270         require(TokenInterface(daiAddr).transfer(msg.sender, destAmt), "Not enough DAI to transfer");
271         emit LogEthToDai(msg.value, destAmt);
272     }
273 
274     function daiToEthSwap(uint srcAmt, uint splitAmt, uint slippageAmt) public returns (uint destAmt) {
275         require(maxSplitAmtDai >= splitAmt, "split amt > max");
276         require(TokenInterface(daiAddr).transferFrom(msg.sender, address(this), srcAmt), "Token Approved?");
277         uint finalSrcAmt = wmul(srcAmt, cut);
278         destAmt = daiToEthLoop(finalSrcAmt, splitAmt, 0);
279         require(destAmt > slippageAmt, "Dest Amt < slippage");
280         msg.sender.transfer(destAmt);
281         emit LogDaiToEth(finalSrcAmt, destAmt);
282     }
283 
284 }
285 
286 
287 contract InstaSwap is SplitSwap {
288 
289     constructor() public {
290         setAllowance(TokenInterface(daiAddr), eth2daiAddr);
291         setAllowance(TokenInterface(daiAddr), kyberAddr);
292         setAllowance(TokenInterface(wethAddr), eth2daiAddr);
293         setAllowance(TokenInterface(wethAddr), wethAddr);
294     }
295 
296     function() external payable {}
297 
298 }