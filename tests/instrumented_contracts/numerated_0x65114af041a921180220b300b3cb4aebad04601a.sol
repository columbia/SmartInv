1 pragma solidity ^0.5.0;
2 
3 contract TokenInterface {
4     function allowance(address, address) public returns (uint);
5     function balanceOf(address) public returns (uint);
6     function approve(address, uint) public;
7     function transfer(address, uint) public returns (bool);
8     function transferFrom(address, address, uint) public returns (bool);
9     function deposit() public payable;
10     function withdraw(uint) public;
11 }
12 
13 contract PipInterface {
14     function read() public returns (bytes32);
15 }
16 
17 contract PepInterface {
18     function peek() public returns (bytes32, bool);
19 }
20 
21 contract VoxInterface {
22     function par() public returns (uint);
23 }
24 
25 contract TubInterface {
26     event LogNewCup(address indexed lad, bytes32 cup);
27 
28     function open() public returns (bytes32);
29     function join(uint) public;
30     function exit(uint) public;
31     function lock(bytes32, uint) public;
32     function free(bytes32, uint) public;
33     function draw(bytes32, uint) public;
34     function wipe(bytes32, uint) public;
35     function give(bytes32, address) public;
36     function shut(bytes32) public;
37     function bite(bytes32) public;
38     function cups(bytes32) public returns (address, uint, uint, uint);
39     function gem() public returns (TokenInterface);
40     function gov() public returns (TokenInterface);
41     function skr() public returns (TokenInterface);
42     function sai() public returns (TokenInterface);
43     function vox() public returns (VoxInterface);
44     function ask(uint) public returns (uint);
45     function mat() public returns (uint);
46     function chi() public returns (uint);
47     function ink(bytes32) public returns (uint);
48     function tab(bytes32) public returns (uint);
49     function rap(bytes32) public returns (uint);
50     function per() public returns (uint);
51     function pip() public returns (PipInterface);
52     function pep() public returns (PepInterface);
53     function tag() public returns (uint);
54     function drip() public;
55     function lad(bytes32 cup) public view returns (address);
56     function bid(uint wad) public view returns (uint);
57 }
58 
59 contract DSProxyInterface {
60     function execute(bytes memory _code, bytes memory _data) public payable returns (address, bytes32);
61 
62     function execute(address _target, bytes memory _data) public payable returns (bytes32);
63 
64     function setCache(address _cacheAddr) public payable returns (bool);
65 
66     function owner() public returns (address);
67 }
68 
69 contract ProxyRegistryInterface {
70     function proxies(address _owner) public view returns(DSProxyInterface);
71     function build(address) public returns (address);
72 }
73 
74 interface ERC20 {
75     function totalSupply() external view returns (uint supply);
76     function balanceOf(address _owner) external view returns (uint balance);
77     function transfer(address _to, uint _value) external returns (bool success);
78     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
79     function approve(address _spender, uint _value) external returns (bool success);
80     function allowance(address _owner, address _spender) external view returns (uint remaining);
81     function decimals() external view returns(uint digits);
82     event Approval(address indexed _owner, address indexed _spender, uint _value);
83 }
84 
85 contract GasTokenInterface is ERC20 {
86     function free(uint256 value) public returns (bool success);
87     function freeUpTo(uint256 value) public returns (uint256 freed);
88     function freeFrom(address from, uint256 value) public returns (bool success);
89     function freeFromUpTo(address from, uint256 value) public returns (uint256 freed);
90 }
91 
92 contract DSMath {
93     function add(uint x, uint y) internal pure returns (uint z) {
94         require((z = x + y) >= x);
95     }
96     function sub(uint x, uint y) internal pure returns (uint z) {
97         require((z = x - y) <= x);
98     }
99     function mul(uint x, uint y) internal pure returns (uint z) {
100         require(y == 0 || (z = x * y) / y == x);
101     }
102 
103     function min(uint x, uint y) internal pure returns (uint z) {
104         return x <= y ? x : y;
105     }
106     function max(uint x, uint y) internal pure returns (uint z) {
107         return x >= y ? x : y;
108     }
109     function imin(int x, int y) internal pure returns (int z) {
110         return x <= y ? x : y;
111     }
112     function imax(int x, int y) internal pure returns (int z) {
113         return x >= y ? x : y;
114     }
115 
116     uint constant WAD = 10 ** 18;
117     uint constant RAY = 10 ** 27;
118 
119     function wmul(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, y), WAD / 2) / WAD;
121     }
122     function rmul(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, y), RAY / 2) / RAY;
124     }
125     function wdiv(uint x, uint y) internal pure returns (uint z) {
126         z = add(mul(x, WAD), y / 2) / y;
127     }
128     function rdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, RAY), y / 2) / y;
130     }
131 
132     // This famous algorithm is called "exponentiation by squaring"
133     // and calculates x^n with x as fixed-point and n as regular unsigned.
134     //
135     // It's O(log n), instead of O(n) for naive repeated multiplication.
136     //
137     // These facts are why it works:
138     //
139     //  If n is even, then x^n = (x^2)^(n/2).
140     //  If n is odd,  then x^n = x * x^(n-1),
141     //   and applying the equation for even x gives
142     //    x^n = x * (x^2)^((n-1) / 2).
143     //
144     //  Also, EVM division is flooring and
145     //    floor[(n-1) / 2] = floor[n / 2].
146     //
147     function rpow(uint x, uint n) internal pure returns (uint z) {
148         z = n % 2 != 0 ? x : RAY;
149 
150         for (n /= 2; n != 0; n /= 2) {
151             x = rmul(x, x);
152 
153             if (n % 2 != 0) {
154                 z = rmul(z, x);
155             }
156         }
157     }
158 }
159 
160 
161 contract ConstantAddressesMainnet {
162     address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
163     address public constant IDAI_ADDRESS = 0x14094949152EDDBFcd073717200DA82fEd8dC960;
164     address public constant SOLO_MARGIN_ADDRESS = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
165     address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
166     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
167     address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
168     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
169     address public constant VOX_ADDRESS = 0x9B0F70Df76165442ca6092939132bBAEA77f2d7A;
170     address public constant PETH_ADDRESS = 0xf53AD2c6851052A81B42133467480961B2321C09;
171     address public constant TUB_ADDRESS = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
172     address public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
173     address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
174     address public constant OTC_ADDRESS = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
175 
176     address public constant KYBER_WRAPPER = 0xAae7ba823679889b12f71D1f18BEeCBc69E62237;
177     address public constant UNISWAP_WRAPPER = 0x0aa70981311D60a9521C99cecFDD68C3E5a83B83;
178     address public constant ETH2DAI_WRAPPER = 0xd7BBB1777E13b6F535Dec414f575b858ed300baF;
179 
180     address public constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
181     address public constant UNISWAP_FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
182     address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
183     address public constant PIP_INTERFACE_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
184 
185     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
186     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
187 
188     // Kovan addresses, not used on mainnet
189     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
190     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
191 }
192 
193 contract ConstantAddressesKovan {
194     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
195     address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
196     address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
197     address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
198     address public constant VOX_ADDRESS = 0xBb4339c0aB5B1d9f14Bd6e3426444A1e9d86A1d9;
199     address public constant PETH_ADDRESS = 0xf4d791139cE033Ad35DB2B2201435fAd668B1b64;
200     address public constant TUB_ADDRESS = 0xa71937147b55Deb8a530C7229C442Fd3F31b7db2;
201     address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
202     address public constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
203     address public constant OTC_ADDRESS = 0x4A6bC4e803c62081ffEbCc8d227B5a87a58f1F8F;
204     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
205     address public constant SOLO_MARGIN_ADDRESS = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
206     address public constant IDAI_ADDRESS = 0xA1e58F3B1927743393b25f261471E1f2D3D9f0F6;
207     address public constant CDAI_ADDRESS = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
208     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
209 
210     address public constant KYBER_WRAPPER = 0x5595930d576Aedf13945C83cE5aaD827529A1310;
211     address public constant UNISWAP_WRAPPER = 0x5595930d576Aedf13945C83cE5aaD827529A1310;
212     address public constant ETH2DAI_WRAPPER = 0x823cde416973a19f98Bb9C96d97F4FE6C9A7238B;
213 
214     address public constant FACTORY_ADDRESS = 0xc72E74E474682680a414b506699bBcA44ab9a930;
215     //
216     address public constant PIP_INTERFACE_ADDRESS = 0xA944bd4b25C9F186A846fd5668941AA3d3B8425F;
217     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x64A436ae831C1672AE81F674CAb8B6775df3475C;
218     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
219     address public constant KYBER_INTERFACE = 0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D;
220 
221     // Rinkeby, when no Kovan
222     address public constant UNISWAP_FACTORY = 0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36;
223 }
224 
225 contract ConstantAddresses is ConstantAddressesMainnet {
226 }
227 
228 contract Monitor is DSMath, ConstantAddresses {
229 
230     // KOVAN
231     PipInterface pip = PipInterface(PIP_INTERFACE_ADDRESS);
232     TubInterface tub = TubInterface(TUB_ADDRESS);
233     ProxyRegistryInterface registry = ProxyRegistryInterface(PROXY_REGISTRY_INTERFACE_ADDRESS);
234     GasTokenInterface gasToken = GasTokenInterface(GAS_TOKEN_INTERFACE_ADDRESS);
235 
236     uint constant public REPAY_GAS_TOKEN = 30;
237     uint constant public BOOST_GAS_TOKEN = 19;
238 
239     uint constant public MAX_GAS_PRICE = 40000000000; // 40 gwei
240 
241     uint constant public REPAY_GAS_COST = 1300000;
242     uint constant public BOOST_GAS_COST = 650000;
243 
244     address public saverProxy;
245     address public owner;
246     uint public changeIndex;
247 
248     struct CdpHolder {
249         uint minRatio;
250         uint maxRatio;
251         uint optimalRatioBoost;
252         uint optimalRatioRepay;
253         address owner;
254     }
255 
256     mapping(bytes32 => CdpHolder) public holders;
257 
258     /// @dev This will be Bot addresses which will trigger the calls
259     mapping(address => bool) public approvedCallers;
260 
261     event Subscribed(address indexed owner, bytes32 cdpId);
262     event Unsubscribed(address indexed owner, bytes32 cdpId);
263     event Updated(address indexed owner, bytes32 cdpId);
264 
265     event CdpRepay(bytes32 indexed cdpId, address caller, uint _amount, uint _ratioBefore, uint _ratioAfter);
266     event CdpBoost(bytes32 indexed cdpId, address caller, uint _amount, uint _ratioBefore, uint _ratioAfter);
267 
268     modifier onlyApproved() {
269         require(approvedCallers[msg.sender]);
270         _;
271     }
272 
273     modifier onlyOwner() {
274         require(owner == msg.sender);
275         _;
276     }
277 
278     constructor(address _saverProxy) public {
279         approvedCallers[msg.sender] = true;
280         owner = msg.sender;
281 
282         saverProxy = _saverProxy;
283         changeIndex = 0;
284     }
285 
286     /// @notice Owners of Cdps subscribe through DSProxy for automatic saving
287     /// @param _cdpId Id of the cdp
288     /// @param _minRatio Minimum ratio that the Cdp can be
289     /// @param _maxRatio Maximum ratio that the Cdp can be
290     /// @param _optimalRatioBoost Optimal ratio for the user after boost is performed
291     /// @param _optimalRatioRepay Optimal ratio for the user after repay is performed
292     function subscribe(bytes32 _cdpId, uint _minRatio, uint _maxRatio, uint _optimalRatioBoost, uint _optimalRatioRepay) public {
293         require(isOwner(msg.sender, _cdpId));
294 
295         bool isCreated = holders[_cdpId].owner == address(0) ? true : false;
296 
297         holders[_cdpId] = CdpHolder({
298             minRatio: _minRatio,
299             maxRatio: _maxRatio,
300             optimalRatioBoost: _optimalRatioBoost,
301             optimalRatioRepay: _optimalRatioRepay,
302             owner: msg.sender
303         });
304 
305         changeIndex++;
306 
307         if (isCreated) {
308             emit Subscribed(msg.sender, _cdpId);
309         } else {
310             emit Updated(msg.sender, _cdpId);
311         }
312     }
313 
314     /// @notice Users can unsubscribe from monitoring
315     /// @param _cdpId Id of the cdp
316     function unsubscribe(bytes32 _cdpId) public {
317         require(isOwner(msg.sender, _cdpId));
318 
319         delete holders[_cdpId];
320 
321         changeIndex++;
322 
323         emit Unsubscribed(msg.sender, _cdpId);
324     }
325 
326     /// @notice Bots call this method to repay for user when conditions are met
327     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
328     /// @param _cdpId Id of the cdp
329     /// @param _amount Amount of Eth to convert to Dai
330     function repayFor(bytes32 _cdpId, uint _amount) public onlyApproved {
331         if (gasToken.balanceOf(address(this)) >= BOOST_GAS_TOKEN) {
332             gasToken.free(BOOST_GAS_TOKEN);
333         }
334 
335         CdpHolder memory holder = holders[_cdpId];
336         uint ratioBefore = getRatio(_cdpId);
337 
338         require(holder.owner != address(0));
339         require(ratioBefore <= holders[_cdpId].minRatio);
340 
341         uint gasCost = calcGasCost(REPAY_GAS_COST);
342 
343         DSProxyInterface(holder.owner).execute(saverProxy, abi.encodeWithSignature("repay(bytes32,uint256,uint256)", _cdpId, _amount, gasCost));
344 
345         uint ratioAfter = getRatio(_cdpId);
346 
347         emit CdpRepay(_cdpId, msg.sender, _amount, ratioBefore, ratioAfter);
348     }
349 
350     /// @notice Bots call this method to boost for user when conditions are met
351     /// @dev If the contract ownes gas token it will try and use it for gas price reduction
352     /// @param _cdpId Id of the cdp
353     /// @param _amount Amount of Dai to convert to Eth
354     function boostFor(bytes32 _cdpId, uint _amount) public onlyApproved {
355         if (gasToken.balanceOf(address(this)) >= REPAY_GAS_TOKEN) {
356             gasToken.free(REPAY_GAS_TOKEN);
357         }
358 
359         CdpHolder memory holder = holders[_cdpId];
360         uint ratioBefore = getRatio(_cdpId);
361 
362         require(holder.owner != address(0));
363 
364         require(ratioBefore >= holders[_cdpId].maxRatio);
365 
366         uint gasCost = calcGasCost(BOOST_GAS_COST);
367 
368         DSProxyInterface(holder.owner).execute(saverProxy, abi.encodeWithSignature("boost(bytes32,uint256,uint256)", _cdpId, _amount, gasCost));
369 
370         uint ratioAfter = getRatio(_cdpId);
371 
372         emit CdpBoost(_cdpId, msg.sender, _amount, ratioBefore, ratioAfter);
373     }
374 
375 
376     /// @notice Calculates the ratio of a given cdp
377     /// @param _cdpId The id od the cdp
378     function getRatio(bytes32 _cdpId) public returns(uint) {
379         return (rdiv(rmul(rmul(tub.ink(_cdpId), tub.tag()), WAD), tub.tab(_cdpId)));
380     }
381 
382     /// @notice Check if the owner is the cup owner
383     /// @param _owner Address which is the owner of the cup
384     /// @param _cdpId Id of the cdp
385     function isOwner(address _owner, bytes32 _cdpId) internal view returns(bool) {
386         require(tub.lad(_cdpId) == _owner);
387 
388         return true;
389     }
390 
391     /// @notice Calculates gas cost (in Eth) of tx
392     /// @dev Gas price is limited to MAX_GAS_PRICE to prevent attack of draining user CDP
393     /// @param _gasAmount Amount of gas used for the tx
394     function calcGasCost(uint _gasAmount) internal view returns (uint) {
395         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
396 
397         return mul(gasPrice, _gasAmount);
398     }
399 
400 
401     /******************* OWNER ONLY OPERATIONS ********************************/
402 
403     /// @notice Adds a new bot address which can call repay/boost
404     /// @param _caller Bot address
405     function addCaller(address _caller) public onlyOwner {
406         approvedCallers[_caller] = true;
407     }
408 
409     /// @notice Removed a bot address so it can't call repay/boost
410     /// @param _caller Bot address
411     function removeCaller(address _caller) public onlyOwner {
412         approvedCallers[_caller] = false;
413     }
414 
415     /// @notice If any tokens gets stuck in the contract
416     /// @param _tokenAddress Address of the ERC20 token
417     /// @param _to Address of the receiver
418     /// @param _amount The amount to be sent
419     function transferERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
420         ERC20(_tokenAddress).transfer(_to, _amount);
421     }
422 
423     /// @notice If any Eth gets stuck in the contract
424     /// @param _to Address of the receiver
425     /// @param _amount The amount to be sent
426     function transferEth(address payable _to, uint _amount) public onlyOwner {
427         _to.transfer(_amount);
428     }
429  }