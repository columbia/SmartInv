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
20     function tab(bytes32) external returns (uint);
21     function rap(bytes32) external returns (uint);
22     function per() external view returns (uint);
23     function pep() external view returns (PepInterface);
24 }
25 
26 interface TokenInterface {
27     function allowance(address, address) external view returns (uint);
28     function balanceOf(address) external view returns (uint);
29     function approve(address, uint) external;
30     function transfer(address, uint) external returns (bool);
31     function transferFrom(address, address, uint) external returns (bool);
32     function deposit() external payable;
33     function withdraw(uint) external;
34 }
35 
36 interface PepInterface {
37     function peek() external returns (bytes32, bool);
38 }
39 
40 interface UniswapExchange {
41     function getEthToTokenOutputPrice(uint256 tokensBought) external view returns (uint256 ethSold);
42     function getTokenToEthOutputPrice(uint256 ethBought) external view returns (uint256 tokensSold);
43     function tokenToTokenSwapOutput(
44         uint256 tokensBought,
45         uint256 maxTokensSold,
46         uint256 maxEthSold,
47         uint256 deadline,
48         address tokenAddr
49         ) external returns (uint256  tokensSold);
50 }
51 
52 
53 contract DSMath {
54 
55     function add(uint x, uint y) internal pure returns (uint z) {
56         require((z = x + y) >= x, "math-not-safe");
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
74     function wdiv(uint x, uint y) internal pure returns (uint z) {
75         z = add(mul(x, WAD), y / 2) / y;
76     }
77 
78 }
79 
80 
81 contract Helpers is DSMath {
82 
83     /**
84      * @dev get MakerDAO CDP engine
85      */
86     function getSaiTubAddress() public pure returns (address sai) {
87         sai = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
88     }
89 
90     /**
91      * @dev get uniswap MKR exchange
92      */
93     function getUniswapMKRExchange() public pure returns (address ume) {
94         ume = 0x2C4Bd064b998838076fa341A83d007FC2FA50957;
95     }
96 
97     /**
98      * @dev get uniswap DAI exchange
99      */
100     function getUniswapDAIExchange() public pure returns (address ude) {
101         ude = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;
102     }
103 
104     /**
105      * @dev get CDP bytes by CDP ID
106      */
107     function getCDPBytes(uint cdpNum) public pure returns (bytes32 cup) {
108         cup = bytes32(cdpNum);
109     }
110 
111 }
112 
113 
114 contract CDPResolver is Helpers {
115 
116     function open() public returns (uint) {
117         bytes32 cup = TubInterface(getSaiTubAddress()).open();
118         return uint(cup);
119     }
120 
121     /**
122      * @dev transfer CDP ownership
123      */
124     function give(uint cdpNum, address nextOwner) public {
125         TubInterface(getSaiTubAddress()).give(bytes32(cdpNum), nextOwner);
126     }
127 
128     function lock(uint cdpNum) public payable {
129         bytes32 cup = bytes32(cdpNum);
130         address tubAddr = getSaiTubAddress();
131         if (msg.value > 0) {
132             TubInterface tub = TubInterface(tubAddr);
133             TokenInterface weth = tub.gem();
134             TokenInterface peth = tub.skr();
135 
136             weth.deposit.value(msg.value)();
137 
138             uint ink = rdiv(msg.value, tub.per());
139             ink = rmul(ink, tub.per()) <= msg.value ? ink : ink - 1;
140 
141             setAllowance(weth, tubAddr);
142             tub.join(ink);
143 
144             setAllowance(peth, tubAddr);
145             tub.lock(cup, ink);
146         }
147     }
148 
149     function free(uint cdpNum, uint jam) public {
150         bytes32 cup = bytes32(cdpNum);
151         address tubAddr = getSaiTubAddress();
152         
153         if (jam > 0) {
154             
155             TubInterface tub = TubInterface(tubAddr);
156             TokenInterface peth = tub.skr();
157             TokenInterface weth = tub.gem();
158 
159             uint ink = rdiv(jam, tub.per());
160             ink = rmul(ink, tub.per()) <= jam ? ink : ink - 1;
161             tub.free(cup, ink);
162 
163             setAllowance(peth, tubAddr);
164             
165             tub.exit(ink);
166             uint freeJam = weth.balanceOf(address(this)); // withdraw possible previous stuck WETH as well
167             weth.withdraw(freeJam);
168             
169             address(msg.sender).transfer(freeJam);
170         }
171     }
172 
173     function draw(uint cdpNum, uint _wad) public {
174         bytes32 cup = bytes32(cdpNum);
175         if (_wad > 0) {
176             TubInterface tub = TubInterface(getSaiTubAddress());
177 
178             tub.draw(cup, _wad);
179             tub.sai().transfer(msg.sender, _wad);
180         }
181     }
182 
183     function wipe(uint cdpNum, uint _wad) public {
184         require(_wad > 0, "no-wipe-no-dai");
185 
186         TubInterface tub = TubInterface(getSaiTubAddress());
187         UniswapExchange daiEx = UniswapExchange(getUniswapDAIExchange());
188         UniswapExchange mkrEx = UniswapExchange(getUniswapMKRExchange());
189         TokenInterface dai = tub.sai();
190         TokenInterface mkr = tub.gov();
191 
192         bytes32 cup = bytes32(cdpNum);
193 
194         setAllowance(dai, getSaiTubAddress());
195         setAllowance(mkr, getSaiTubAddress());
196         setAllowance(dai, getUniswapDAIExchange());
197 
198         (bytes32 val, bool ok) = tub.pep().peek();
199 
200         // MKR required for wipe = Stability fees accrued in Dai / MKRUSD value
201         uint mkrFee = wdiv(rmul(_wad, rdiv(tub.rap(cup), tub.tab(cup))), uint(val));
202 
203         uint daiAmt = daiEx.getTokenToEthOutputPrice(mkrEx.getEthToTokenOutputPrice(mkrFee));
204         daiAmt = add(_wad, daiAmt);
205         require(dai.transferFrom(msg.sender, address(this), daiAmt), "not-approved-yet");
206 
207         if (ok && val != 0) {
208             daiEx.tokenToTokenSwapOutput(
209                 mkrFee,
210                 daiAmt,
211                 uint(999000000000000000000),
212                 uint(1899063809), // 6th March 2030 GMT // no logic
213                 address(mkr)
214             );
215         }
216 
217         tub.wipe(cup, _wad);
218     }
219 
220     function setAllowance(TokenInterface token_, address spender_) private {
221         if (token_.allowance(address(this), spender_) != uint(-1)) {
222             token_.approve(spender_, uint(-1));
223         }
224     }
225 
226 }
227 
228 
229 contract CDPCluster is CDPResolver {
230 
231     function wipeAndFree(uint cdpNum, uint jam, uint _wad) public payable {
232         wipe(cdpNum, _wad);
233         free(cdpNum, jam);
234     }
235 
236     /**
237      * @dev close CDP
238      */
239     function shut(uint cdpNum) public {
240         bytes32 cup = bytes32(cdpNum);
241         TubInterface tub = TubInterface(getSaiTubAddress());
242         wipeAndFree(cdpNum, rmul(tub.ink(cup), tub.per()), tub.tab(cup));
243         tub.shut(cup);
244     }
245 
246     /**
247      * @dev open a new CDP and lock ETH
248      */
249     function openAndLock() public payable returns (uint cdpNum) {
250         cdpNum = open();
251         lock(cdpNum);
252     }
253 
254 }
255 
256 
257 contract InstaMaker is CDPCluster {
258 
259     uint public version;
260     
261     /**
262      * @dev setting up variables on deployment
263      * 1...2...3 versioning in each subsequent deployments
264      */
265     constructor(uint _version) public {
266         version = _version;
267     }
268 
269     function() external payable {}
270 
271 }