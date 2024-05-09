1 pragma solidity ^0.5.0;
2 
3 
4 interface TubInterface {
5     function open() external returns (bytes32);
6     function join(uint) external;
7     function exit(uint) external;
8     function lock(bytes32, uint) external;
9     function free(bytes32, uint) external;
10     function draw(bytes32, uint) external;
11     function wipe(bytes32, uint) external;
12     function give(bytes32, address) external;
13     function shut(bytes32) external;
14     function cups(bytes32) external view returns (address, uint, uint, uint);
15     function gem() external view returns (TokenInterface);
16     function gov() external view returns (TokenInterface);
17     function skr() external view returns (TokenInterface);
18     function sai() external view returns (TokenInterface);
19     function ink(bytes32) external view returns (uint);
20     function tab(bytes32) external view returns (uint);
21     function rap(bytes32) external view returns (uint);
22     function per() external view returns (uint);
23     function pep() external view returns (PepInterface);
24 }
25 
26 
27 interface TokenInterface {
28     function allowance(address, address) external view returns (uint);
29     function balanceOf(address) external view returns (uint);
30     function approve(address, uint) external;
31     function transfer(address, uint) external returns (bool);
32     function transferFrom(address, address, uint) external returns (bool);
33     function deposit() external payable;
34     function withdraw(uint) external;
35 }
36 
37 
38 interface PepInterface {
39     function peek() external returns (bytes32, bool);
40 }
41 
42 
43 interface WETHFace {
44     function deposit() external payable;
45     function withdraw(uint wad) external;
46 }
47 
48 interface UniswapExchange {
49     function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
50     function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
51     function tokenToTokenSwapOutput(
52         uint256 tokensBought,
53         uint256 maxTokensSold,
54         uint256 maxEthSold,
55         uint256 deadline,
56         address tokenAddr
57         ) external returns (uint256  tokensSold);
58 }
59 
60 
61 contract DSMath {
62 
63     function add(uint x, uint y) internal pure returns (uint z) {
64         require((z = x + y) >= x, "math-not-safe");
65     }
66 
67     function mul(uint x, uint y) internal pure returns (uint z) {
68         require(y == 0 || (z = x * y) / y == x, "math-not-safe");
69     }
70 
71     uint constant WAD = 10 ** 18;
72     uint constant RAY = 10 ** 27;
73 
74     function rmul(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, y), RAY / 2) / RAY;
76     }
77 
78     function rdiv(uint x, uint y) internal pure returns (uint z) {
79         z = add(mul(x, RAY), y / 2) / y;
80     }
81 
82     function wdiv(uint x, uint y) internal pure returns (uint z) {
83         z = add(mul(x, WAD), y / 2) / y;
84     }
85 
86 }
87 
88 
89 contract Helpers is DSMath {
90 
91     /**
92      * @dev get MakerDAO CDP engine
93      */
94     function getSaiTubAddress() public pure returns (address sai) {
95         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
96     }
97 
98     /**
99      * @dev get uniswap MKR exchange
100      */
101     function getUniswapMKRExchange() public pure returns (address ume) {
102         ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
103     }
104 
105     /**
106      * @dev get uniswap DAI exchange
107      */
108     function getUniswapDAIExchange() public pure returns (address ude) {
109         ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
110     }
111 
112     /**
113      * @dev get CDP bytes by CDP ID
114      */
115     function getCDPBytes(uint cdpNum) public pure returns (bytes32 cup) {
116         cup = bytes32(cdpNum);
117     }
118 
119 }
120 
121 
122 contract CDPResolver is Helpers {
123 
124     function open() public returns (uint) {
125         bytes32 cup = TubInterface(getSaiTubAddress()).open();
126         return uint(cup);
127     }
128 
129     /**
130      * @dev transfer CDP ownership
131      */
132     function give(uint cdpNum, address nextOwner) public {
133         TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
134     }
135 
136     function lock(uint cdpNum) public payable {
137         bytes32 cup = bytes32(cdpNum);
138         address tubAddr = getSaiTubAddress();
139         if (msg.value > 0) {
140             TubInterface tub = TubInterface(tubAddr);
141             TokenInterface weth = tub.gem();
142             TokenInterface peth = tub.skr();
143 
144             (address lad,,,) = tub.cups(cup);
145             require(lad == address(this), "cup-not-owned");
146 
147             weth.deposit.value(msg.value)();
148 
149             uint ink = rdiv(msg.value, tub.per());
150             ink = rmul(ink, tub.per()) <= msg.value ? ink : ink - 1;
151 
152             setAllowance(weth, tubAddr);
153             tub.join(ink);
154 
155             setAllowance(peth, tubAddr);
156             tub.lock(cup, ink);
157         }
158     }
159 
160     function free(uint cdpNum, uint jam) public {
161         bytes32 cup = bytes32(cdpNum);
162         address tubAddr = getSaiTubAddress();
163         
164         if (jam > 0) {
165             
166             TubInterface tub = TubInterface(tubAddr);
167             TokenInterface peth = tub.skr();
168             TokenInterface weth = tub.gem();
169 
170             uint ink = rdiv(jam, tub.per());
171             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
172             tub.free(cup, ink);
173 
174             setAllowance(peth, tubAddr);
175             
176             tub.exit(ink);
177             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
178             weth.withdraw(freeJam);
179             
180             address(msg.sender).transfer(freeJam);
181         }
182     }
183 
184     function draw(uint cdpNum, uint wad) public {
185         bytes32 cup = bytes32(cdpNum);
186         if (wad > 0) {
187             TubInterface tub = TubInterface(getSaiTubAddress());
188 
189             (address lad,,,) = tub.cups(cup);
190             require(lad == address(this), "cup-not-owned");
191 
192             tub.draw(cup, wad);
193             tub.sai().transfer(msg.sender, wad);
194         }
195     }
196 
197     function wipe(uint cdpNum, uint wad) public {
198         require(wad > 0, "no-wipe-no-dai");
199 
200         TubInterface tub = TubInterface(getSaiTubAddress());
201         UniswapExchange daiEx = UniswapExchange(getUniswapDAIExchange());
202         UniswapExchange mkrEx = UniswapExchange(getUniswapMKRExchange());
203         TokenInterface dai = tub.sai();
204         TokenInterface mkr = tub.gov();
205         PepInterface pep = tub.pep();
206 
207         bytes32 cup = bytes32(cdpNum);
208 
209         setAllowance(dai, getSaiTubAddress());
210         setAllowance(mkr, getSaiTubAddress());
211         setAllowance(dai, getUniswapDAIExchange());
212 
213         (bytes32 val, bool ok) = pep.peek();
214 
215         // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
216         uint mkrFee = wdiv(rmul(wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
217 
218         uint ethAmt = mkrEx.getEthToTokenOutputPrice(mkrFee);
219         uint daiAmt = daiEx.getTokenToEthOutputPrice(ethAmt);
220 
221         daiAmt = add(wad, daiAmt);
222         require(dai.transferFrom(msg.sender, address(this), daiAmt), "not-approved-yet");
223 
224         if (ok && val != 0) {
225             daiEx.tokenToTokenSwapOutput(
226                 mkrFee,
227                 daiAmt,
228                 uint(999000000000000000000),
229                 uint(1899063809), // 6th March 2030 GMT // no logic
230                 address(mkr)
231             );
232         }
233 
234         tub.wipe(cup, wad);
235     }
236 
237     function setAllowance(TokenInterface token_, address spender_) private {
238         if (token_.allowance(address(this), spender_) != uint(-1)) {
239             token_.approve(spender_, uint(-1));
240         }
241     }
242 
243 }
244 
245 
246 contract CDPCluster is CDPResolver {
247 
248     function wipeAndFree(uint cdpNum, uint jam, uint wad) public payable {
249         wipe(cdpNum, wad);
250         free(cdpNum, jam);
251     }
252 
253     /**
254      * @dev close CDP
255      */
256     function shut(uint cdpNum) public {
257         bytes32 cup = bytes32(cdpNum);
258         TubInterface tub = TubInterface(getSaiTubAddress());
259         wipeAndFree(cdpNum, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
260         tub.shut(cup);
261     }
262 
263     /**
264      * @dev open a new CDP and lock ETH
265      */
266     function openAndLock() public payable returns (uint cdpNum) {
267         cdpNum = open();
268         lock(cdpNum);
269     }
270 
271 }
272 
273 
274 contract InstaMaker is CDPCluster {
275 
276     uint public version;
277     
278     /**
279      * @dev setting up variables on deployment
280      * 1...2...3 versioning in each subsequent deployments
281      */
282     constructor(uint _version) public {
283         version = _version;
284     }
285 
286     function() external payable {}
287 
288 }