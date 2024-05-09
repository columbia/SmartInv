1 pragma solidity ^0.5.0;
2 
3 
4 contract DSMath {
5 
6     function add(uint x, uint y) internal pure returns (uint z) {
7         require((z = x + y) >= x, "math-not-safe");
8     }
9 
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
12     }
13 
14     uint constant WAD = 10 ** 18;
15     uint constant RAY = 10 ** 27;
16 
17     function rmul(uint x, uint y) internal pure returns (uint z) {
18         z = add(mul(x, y), RAY / 2) / RAY;
19     }
20 
21     function rdiv(uint x, uint y) internal pure returns (uint z) {
22         z = add(mul(x, RAY), y / 2) / y;
23     }
24 
25     function wdiv(uint x, uint y) internal pure returns (uint z) {
26         z = add(mul(x, WAD), y / 2) / y;
27     }
28 
29 }
30 
31 
32 contract IERC20 {
33     function balanceOf(address who) external view returns (uint256);
34     function transfer(address to, uint256 value) external returns (bool);
35     function approve(address spender, uint256 value) external returns (bool);
36     function transferFrom(address from, address to, uint256 value) external returns (bool);
37 }
38 
39 
40 contract TubInterface {
41     function open() public returns (bytes32);
42     function join(uint) public;
43     function exit(uint) public;
44     function lock(bytes32, uint) public;
45     function free(bytes32, uint) public;
46     function draw(bytes32, uint) public;
47     function wipe(bytes32, uint) public;
48     function give(bytes32, address) public;
49     function shut(bytes32) public;
50     function cups(bytes32) public view returns (address, uint, uint, uint);
51     function gem() public view returns (TokenInterface);
52     function gov() public view returns (TokenInterface);
53     function skr() public view returns (TokenInterface);
54     function sai() public view returns (TokenInterface);
55     function ink(bytes32) public view returns (uint);
56     function tab(bytes32) public view returns (uint);
57     function rap(bytes32) public view returns (uint);
58     function per() public view returns (uint);
59     function pep() public view returns (PepInterface);
60 }
61 
62 
63 contract TokenInterface {
64     function allowance(address, address) public view returns (uint);
65     function balanceOf(address) public view returns (uint);
66     function approve(address, uint) public;
67     function transfer(address, uint) public returns (bool);
68     function transferFrom(address, address, uint) public returns (bool);
69     function deposit() public payable;
70     function withdraw(uint) public;
71 }
72 
73 
74 contract PepInterface {
75     function peek() public returns (bytes32, bool);
76 }
77 
78 
79 contract WETHFace {
80     function deposit() external payable;
81     function withdraw(uint wad) external;
82 }
83 
84 
85 contract UniswapExchange {
86     // Get Prices
87     function getEthToTokenInputPrice(uint256 ethSold) external view returns (uint256 tokensBought);
88     function getTokenToEthInputPrice(uint256 tokensSold) external view returns (uint256 ethBought);
89     // Trade ETH to ERC20
90     function ethToTokenSwapOutput(uint256 tokensBought, uint256 deadline) external payable returns (uint256  ethSold);
91     // Trade ERC20 to ERC20
92     function tokenToExchangeSwapOutput(
93         uint256 tokensBought,
94         uint256 maxTokensSold,
95         uint256 maxEthSold,
96         uint256 deadline,
97         address exchangeAddr
98         ) external returns (uint256  tokensSold);
99 }
100 
101 
102 contract Helpers is DSMath {
103 
104     /**
105      * @dev get MakerDAO CDP engine
106      */
107     function getPriceFeedAddress() public pure returns (address eth) {
108         eth = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
109     }
110 
111     /**
112      * @dev get ETH price feed
113      */
114     function getSaiTubAddress() public pure returns (address sai) {
115         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
116     }
117 
118     /**
119      * @dev get uniswap MKR exchange
120      */
121     function getUniswapMKRExchange() public pure returns (address ume) {
122         ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
123     }
124 
125     /**
126      * @dev get uniswap DAI exchange
127      */
128     function getUniswapDAIExchange() public pure returns (address ude) {
129         ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
130     }
131 
132     /**
133      * @dev get DAI address
134      */
135     function getDAIAddress() public pure returns (address ude) {
136         ude = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
137     }
138 
139     /**
140      * @dev get admin address
141      */
142     function getAddressAdmin() public pure returns (address admin) {
143         admin = 0x7284a8451d9a0e7Dc62B3a71C0593eA2eC5c5638;
144     }
145 
146     /**
147      * @dev get onchain ethereum price
148      */
149     function getRate() public returns (uint) {
150         (bytes32 ethrate, ) = PepInterface(getPriceFeedAddress()).peek();
151         return uint(ethrate);
152     }
153 
154     /**
155      * @dev get CDP owner by CDP IDs
156      */
157     function getCDPOwner(uint cdpNum) public view returns (address lad) {
158         bytes32 cup = bytes32(cdpNum);
159         TubInterface tub = TubInterface(getSaiTubAddress());
160         (lad,,,) = tub.cups(cup);
161     }
162 
163     /**
164      * @dev get CDP bytes by CDP ID
165      */
166     function getCDPBytes(uint cdpNum) public pure returns (bytes32 cup) {
167         cup = bytes32(cdpNum);
168     }
169 
170     /**
171      * @dev get stability fees in DAI
172      * @param wad is the DAI to wipe
173      */
174     function getStabilityFees(uint cdpNum, uint wad) public view returns (uint saiDebtFee) {
175         bytes32 cup = bytes32(cdpNum);
176         TubInterface tub = TubInterface(getSaiTubAddress());
177         saiDebtFee = rmul(wad, rdiv(tub.rap(cup), tub.tab(cup)));
178     }
179 
180     /**
181      * @dev get ETH required to buy MKR fees
182      * @param feesMKR is the stability fee needs to paid in MKR
183      */
184     function getETHRequired(uint feesMKR) public view returns (uint reqETH) {
185         UniswapExchange mkrExchange = UniswapExchange(getUniswapMKRExchange());
186         reqETH = mkrExchange.getTokenToEthInputPrice(feesMKR);
187     }
188 
189     /**
190      * @dev get DAI required to buy MKR fees
191      * @param feesMKR is the stability fee needs to paid in MKR
192      */
193     function getDAIRequired(uint feesMKR) public view returns (uint reqDAI) {
194         UniswapExchange mkrExchange = UniswapExchange(getUniswapMKRExchange());
195         UniswapExchange daiExchange = UniswapExchange(getUniswapDAIExchange());
196         uint ethBought = mkrExchange.getTokenToEthInputPrice(feesMKR);
197         reqDAI = daiExchange.getEthToTokenInputPrice(ethBought);
198     }
199 
200     /**
201      * @dev swapping given DAI with MKR
202      */
203     function swapMKR(TubInterface tub, uint feesMKR) public returns (uint daiSold) {
204         address uniDAIDEX = getUniswapDAIExchange();
205         UniswapExchange daiExchange = UniswapExchange(uniDAIDEX);
206         if (tub.sai().allowance(address(this), uniDAIDEX) != uint(-1)) {
207             tub.sai().approve(uniDAIDEX, uint(-1));
208         }
209         daiSold = daiExchange.tokenToExchangeSwapOutput(
210             feesMKR, // total MKR to buy
211             2**255, // max DAI to sell
212             2**255, // max ETH to sell - http://tinyimg.io/i/2Av1L2j.png
213             add(now, 100), // deadline is 100 seconds after this txn gets confirmed (i.e. no deadline)
214             getUniswapMKRExchange()
215         );
216     }
217 
218     /**
219      * @dev handling stability fees payment
220      */
221     function handleGovFee(TubInterface tub, uint saiDebtFee) internal {
222         address _otc = getUniswapMKRExchange();
223         (bytes32 val, bool ok) = tub.pep().peek();
224         if (ok && val != 0) {
225             uint govAmt = wdiv(saiDebtFee, uint(val)); // Fees in MKR
226             uint saiGovAmt = getDAIRequired(govAmt); // get price
227             if (tub.sai().allowance(address(this), _otc) != uint(-1)) {
228                 tub.sai().approve(_otc, uint(-1));
229             }
230             tub.sai().transferFrom(msg.sender, address(this), saiGovAmt);
231             swapMKR(tub, saiGovAmt); // swap DAI with MKR
232         }
233     }
234 
235 }
236 
237 
238 contract CDPResolver is Helpers {
239 
240     function open() public returns (uint) {
241         bytes32 cup = TubInterface(getSaiTubAddress()).open();
242         return uint(cup);
243     }
244 
245     /**
246      * @dev transfer CDP ownership
247      */
248     function give(uint cdpNum, address nextOwner) public {
249         TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
250     }
251 
252     function lock(uint cdpNum) public payable {
253         bytes32 cup = bytes32(cdpNum);
254         address tubAddr = getSaiTubAddress();
255         if (msg.value > 0) {
256             TubInterface tub = TubInterface(tubAddr);
257 
258             (address lad,,,) = tub.cups(cup);
259             require(lad == address(this), "cup-not-owned");
260 
261             tub.gem().deposit.value(msg.value)();
262 
263             uint ink = rdiv(msg.value, tub.per());
264             ink = rmul(ink, tub.per()) <= msg.value ? ink : ink - 1;
265 
266             if (tub.gem().allowance(address(this), tubAddr) != uint(-1)) {
267                 tub.gem().approve(tubAddr, uint(-1));
268             }
269             tub.join(ink);
270 
271             if (tub.skr().allowance(address(this), tubAddr) != uint(-1)) {
272                 tub.skr().approve(tubAddr, uint(-1));
273             }
274             tub.lock(cup, ink);
275         }
276     }
277 
278     function free(uint cdpNum, uint jam) public {
279         bytes32 cup = bytes32(cdpNum);
280         address tubAddr = getSaiTubAddress();
281         if (jam > 0) {
282             TubInterface tub = TubInterface(tubAddr);
283             uint ink = rdiv(jam, tub.per());
284             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
285             tub.free(cup, ink);
286             if (tub.skr().allowance(address(this), tubAddr) != uint(-1)) {
287                 tub.skr().approve(tubAddr, uint(-1));
288             }
289             tub.exit(ink);
290             uint freeJam = tub.gem().balanceOf(address(this)); // Withdraw possible previous stuck WETH as well
291             tub.gem().withdraw(freeJam);
292             address(msg.sender).transfer(freeJam);
293         }
294     }
295 
296     function draw(uint cdpNum, uint wad) public {
297         bytes32 cup = bytes32(cdpNum);
298         if (wad > 0) {
299             TubInterface tub = TubInterface(getSaiTubAddress());
300 
301             (address lad,,,) = tub.cups(cup);
302             require(lad == address(this), "cup-not-owned");
303 
304             tub.draw(cup, wad);
305             tub.sai().transfer(msg.sender, wad);
306         }
307     }
308 
309     function wipe(uint cdpNum, uint wad) public {
310         bytes32 cup = bytes32(cdpNum);
311         address tubAddr = getSaiTubAddress();
312         if (wad > 0) {
313             TubInterface tub = TubInterface(tubAddr);
314 
315             tub.sai().transferFrom(msg.sender, address(this), wad);
316             handleGovFee(tub, rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))));
317 
318             if (tub.sai().allowance(address(this), tubAddr) != uint(-1)) {
319                 tub.sai().approve(tubAddr, uint(-1));
320             }
321             if (tub.gov().allowance(address(this), tubAddr) != uint(-1)) {
322                 tub.gov().approve(tubAddr, uint(-1));
323             }
324             tub.wipe(cup, wad);
325         }
326     }
327 
328 }
329 
330 
331 contract CDPCluster is CDPResolver {
332 
333     function wipeAndFree(uint cdpNum, uint jam, uint wad) public payable {
334         wipe(cdpNum, wad);
335         free(cdpNum, jam);
336     }
337 
338     /**
339      * @dev close CDP
340      */
341     function shut(uint cdpNum) public {
342         bytes32 cup = bytes32(cdpNum);
343         TubInterface tub = TubInterface(getSaiTubAddress());
344         wipeAndFree(cdpNum, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
345         tub.shut(cup);
346     }
347 
348     /**
349      * @dev open a new CDP and lock ETH
350      */
351     function openAndLock() public payable returns (uint cdpNum) {
352         cdpNum = open();
353         lock(cdpNum);
354     }
355 
356 }
357 
358 
359 contract InstaMaker is CDPResolver {
360 
361     uint public version;
362     
363     /**
364      * @dev setting up variables on deployment
365      * 1...2...3 versioning in each subsequent deployments
366      */
367     constructor(uint _version) public {
368         version = _version;
369     }
370 
371 }