1 pragma solidity ^0.5.0;
2 
3 
4 contract Static {
5 
6     enum Method { Boost, Repay }
7 }
8 
9 contract ISubscriptions is Static {
10 
11     function canCall(Method _method, uint _cdpId) external view returns(bool, uint);
12     function getOwner(uint _cdpId) external view returns(address);
13     function ratioGoodAfter(Method _method, uint _cdpId) external view returns(bool, uint);
14     function getRatio(uint _cdpId) public view returns (uint);
15 }
16 
17 contract DSProxyInterface {
18     function execute(bytes memory _code, bytes memory _data) public payable returns (address, bytes32);
19 
20     function execute(address _target, bytes memory _data) public payable returns (bytes32);
21 
22     function setCache(address _cacheAddr) public payable returns (bool);
23 
24     function owner() public returns (address);
25 }
26 
27 contract MCDMonitorProxy {
28 
29     uint public CHANGE_PERIOD;
30     address public monitor;
31     address public owner;
32     address public newMonitor;
33     uint public changeRequestedTimestamp;
34 
35     mapping(address => bool) public allowed;
36 
37     
38     modifier onlyAllowed() {
39         require(allowed[msg.sender] || msg.sender == owner);
40         _;
41     }
42 
43     modifier onlyMonitor() {
44         require (msg.sender == monitor);
45         _;
46     }
47 
48     constructor(uint _changePeriod) public {
49         owner = msg.sender;
50         CHANGE_PERIOD = _changePeriod * 1 days;
51     }
52 
53     
54     
55     function setMonitor(address _monitor) public onlyAllowed {
56         require(monitor == address(0));
57         monitor = _monitor;
58     }
59 
60     
61     
62     
63     
64     function callExecute(address _owner, address _saverProxy, bytes memory _data) public onlyMonitor {
65         
66         DSProxyInterface(_owner).execute(_saverProxy, _data);
67     }
68 
69     
70     
71     
72     function changeMonitor(address _newMonitor) public onlyAllowed {
73         changeRequestedTimestamp = now;
74         newMonitor = _newMonitor;
75     }
76 
77     
78     function cancelMonitorChange() public onlyAllowed {
79         changeRequestedTimestamp = 0;
80         newMonitor = address(0);
81     }
82 
83     
84     function confirmNewMonitor() public onlyAllowed {
85         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
86         require(changeRequestedTimestamp != 0);
87         require(newMonitor != address(0));
88 
89         monitor = newMonitor;
90         newMonitor = address(0);
91         changeRequestedTimestamp = 0;
92     }
93 
94     
95     
96     function addAllowed(address _user) public onlyAllowed {
97         allowed[_user] = true;
98     }
99 
100     
101     
102     
103     function removeAllowed(address _user) public onlyAllowed {
104         allowed[_user] = false;
105     }
106 }
107 
108 contract ConstantAddressesMainnet {
109     address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
110     address public constant IDAI_ADDRESS = 0x14094949152EDDBFcd073717200DA82fEd8dC960;
111     address public constant SOLO_MARGIN_ADDRESS = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
112     address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
113     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
114     address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
115     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
116     address public constant VOX_ADDRESS = 0x9B0F70Df76165442ca6092939132bBAEA77f2d7A;
117     address public constant PETH_ADDRESS = 0xf53AD2c6851052A81B42133467480961B2321C09;
118     address public constant TUB_ADDRESS = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
119     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
120     address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
121     address public constant OTC_ADDRESS = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
122     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
123 
124     address public constant KYBER_WRAPPER = 0x8F337bD3b7F2b05d9A8dC8Ac518584e833424893;
125     address public constant UNISWAP_WRAPPER = 0x1e30124FDE14533231216D95F7798cD0061e5cf8;
126     address public constant ETH2DAI_WRAPPER = 0xd7BBB1777E13b6F535Dec414f575b858ed300baF;
127     address public constant OASIS_WRAPPER = 0x9aBE2715D2d99246269b8E17e9D1b620E9bf6558;
128 
129     address public constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
130     address public constant UNISWAP_FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
131     address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
132     address public constant PIP_INTERFACE_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
133 
134     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
135     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
136 
137     address public constant SAVINGS_LOGGER_ADDRESS = 0x89b3635BD2bAD145C6f92E82C9e83f06D5654984;
138 
139     address public constant SAVER_EXCHANGE_ADDRESS = 0x865B41584A22F8345Fca4B71c42a1E7aBcD67eCB;
140 
141     
142     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
143     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
144 
145     
146     address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;
147     address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
148     address public constant SPOTTER_ADDRESS = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
149     address public constant PROXY_ACTIONS = 0x82ecD135Dce65Fbc6DbdD0e4237E0AF93FFD5038;
150 
151     address public constant JUG_ADDRESS = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
152     address public constant DAI_JOIN_ADDRESS = 0x9759A6Ac90977b93B58547b4A71c78317f391A28;
153     address public constant ETH_JOIN_ADDRESS = 0x2F0b23f53734252Bda2277357e97e1517d6B042A;
154     address public constant MIGRATION_ACTIONS_PROXY = 0xe4B22D484958E582098A98229A24e8A43801b674;
155 
156     address public constant SAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
157     address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
158 
159     address payable public constant SCD_MCD_MIGRATION = 0xc73e0383F3Aff3215E6f04B0331D58CeCf0Ab849;
160 
161     
162     address public constant SUBSCRIPTION_ADDRESS = 0x05A78A2a1Afeb699d73363D096659B53D3B1969E;
163     address public constant MONITOR_ADDRESS = 0x3F4339816EDEF8D3d3970DB2993e2e0Ec6010760;
164 
165 }
166 
167 contract ConstantAddressesKovan {
168     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
169     address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
170     address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
171     address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
172     address public constant VOX_ADDRESS = 0xBb4339c0aB5B1d9f14Bd6e3426444A1e9d86A1d9;
173     address public constant PETH_ADDRESS = 0xf4d791139cE033Ad35DB2B2201435fAd668B1b64;
174     address public constant TUB_ADDRESS = 0xa71937147b55Deb8a530C7229C442Fd3F31b7db2;
175     address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
176     address payable public  constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
177     address public constant OTC_ADDRESS = 0x4A6bC4e803c62081ffEbCc8d227B5a87a58f1F8F;
178     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
179     address public constant SOLO_MARGIN_ADDRESS = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
180     address public constant IDAI_ADDRESS = 0xA1e58F3B1927743393b25f261471E1f2D3D9f0F6;
181     address public constant CDAI_ADDRESS = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
182     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
183     address public constant DISCOUNT_ADDRESS = 0x1297c1105FEDf45E0CF6C102934f32C4EB780929;
184     address public constant SAI_SAVER_PROXY = 0xADB7c74bCe932fC6C27ddA3Ac2344707d2fBb0E6;
185 
186     address public constant KYBER_WRAPPER = 0x68c56FF0E7BBD30AF9Ad68225479449869fC1bA0;
187     address public constant UNISWAP_WRAPPER = 0x2A4ee140F05f1Ba9A07A020b07CCFB76CecE4b43;
188     address public constant ETH2DAI_WRAPPER = 0x823cde416973a19f98Bb9C96d97F4FE6C9A7238B;
189     address public constant OASIS_WRAPPER = 0x0257Ba4876863143bbeDB7847beC583e4deb6fE6;
190 
191     address public constant SAVER_EXCHANGE_ADDRESS = 0xACA7d11e3f482418C324aAC8e90AaD0431f692A6;
192 
193 
194     address public constant FACTORY_ADDRESS = 0xc72E74E474682680a414b506699bBcA44ab9a930;
195     
196     address public constant PIP_INTERFACE_ADDRESS = 0xA944bd4b25C9F186A846fd5668941AA3d3B8425F;
197     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x64A436ae831C1672AE81F674CAb8B6775df3475C;
198     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
199     address public constant KYBER_INTERFACE = 0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D;
200 
201     address public constant SAVINGS_LOGGER_ADDRESS = 0xA6E5d5F489b1c00d9C11E1caF45BAb6e6e26443d;
202 
203     
204     address public constant UNISWAP_FACTORY = 0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36;
205 
206     
207     address public constant MANAGER_ADDRESS = 0x1476483dD8C35F25e568113C5f70249D3976ba21;
208     address public constant VAT_ADDRESS = 0xbA987bDB501d131f766fEe8180Da5d81b34b69d9;
209     address public constant SPOTTER_ADDRESS = 0x3a042de6413eDB15F2784f2f97cC68C7E9750b2D;
210 
211     address public constant JUG_ADDRESS = 0xcbB7718c9F39d05aEEDE1c472ca8Bf804b2f1EaD;
212     address public constant DAI_JOIN_ADDRESS = 0x5AA71a3ae1C0bd6ac27A1f28e1415fFFB6F15B8c;
213     address public constant ETH_JOIN_ADDRESS = 0x775787933e92b709f2a3C70aa87999696e74A9F8;
214     address public constant MIGRATION_ACTIONS_PROXY = 0x433870076aBd08865f0e038dcC4Ac6450e313Bd8;
215     address public constant PROXY_ACTIONS = 0xd1D24637b9109B7f61459176EdcfF9Be56283a7B;
216 
217     address public constant SAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
218     address public constant DAI_ADDRESS = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
219 
220     address payable public constant SCD_MCD_MIGRATION = 0x411B2Faa662C8e3E5cF8f01dFdae0aeE482ca7b0;
221 
222     
223     address public constant SUBSCRIPTION_ADDRESS = 0xFC41f79776061a396635aD0b9dF7a640A05063C1;
224     address public constant MONITOR_ADDRESS = 0xfC1Fc0502e90B7A3766f93344E1eDb906F8A75DD;
225 }
226 
227 contract ConstantAddresses is ConstantAddressesMainnet {
228 }
229 
230 interface ERC20 {
231     function totalSupply() external view returns (uint supply);
232     function balanceOf(address _owner) external view returns (uint balance);
233     function transfer(address _to, uint _value) external returns (bool success);
234     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
235     function approve(address _spender, uint _value) external returns (bool success);
236     function allowance(address _owner, address _spender) external view returns (uint remaining);
237     function decimals() external view returns(uint digits);
238     event Approval(address indexed _owner, address indexed _spender, uint _value);
239 }
240 
241 contract GasTokenInterface is ERC20 {
242     function free(uint256 value) public returns (bool success);
243     function freeUpTo(uint256 value) public returns (uint256 freed);
244     function freeFrom(address from, uint256 value) public returns (bool success);
245     function freeFromUpTo(address from, uint256 value) public returns (uint256 freed);
246 }
247 
248 contract DSMath {
249     function add(uint x, uint y) internal pure returns (uint z) {
250         require((z = x + y) >= x);
251     }
252     function sub(uint x, uint y) internal pure returns (uint z) {
253         require((z = x - y) <= x);
254     }
255     function mul(uint x, uint y) internal pure returns (uint z) {
256         require(y == 0 || (z = x * y) / y == x);
257     }
258 
259     function min(uint x, uint y) internal pure returns (uint z) {
260         return x <= y ? x : y;
261     }
262     function max(uint x, uint y) internal pure returns (uint z) {
263         return x >= y ? x : y;
264     }
265     function imin(int x, int y) internal pure returns (int z) {
266         return x <= y ? x : y;
267     }
268     function imax(int x, int y) internal pure returns (int z) {
269         return x >= y ? x : y;
270     }
271 
272     uint constant WAD = 10 ** 18;
273     uint constant RAY = 10 ** 27;
274 
275     function wmul(uint x, uint y) internal pure returns (uint z) {
276         z = add(mul(x, y), WAD / 2) / WAD;
277     }
278     function rmul(uint x, uint y) internal pure returns (uint z) {
279         z = add(mul(x, y), RAY / 2) / RAY;
280     }
281     function wdiv(uint x, uint y) internal pure returns (uint z) {
282         z = add(mul(x, WAD), y / 2) / y;
283     }
284     function rdiv(uint x, uint y) internal pure returns (uint z) {
285         z = add(mul(x, RAY), y / 2) / y;
286     }
287 
288     
289     
290     
291     
292     
293     
294     
295     
296     
297     
298     
299     
300     
301     
302     
303     function rpow(uint x, uint n) internal pure returns (uint z) {
304         z = n % 2 != 0 ? x : RAY;
305 
306         for (n /= 2; n != 0; n /= 2) {
307             x = rmul(x, x);
308 
309             if (n % 2 != 0) {
310                 z = rmul(z, x);
311             }
312         }
313     }
314 }
315 
316 contract MCDMonitor is ConstantAddresses, DSMath, Static {
317 
318     uint constant public REPAY_GAS_TOKEN = 30;
319     uint constant public BOOST_GAS_TOKEN = 19;
320 
321     uint constant public MAX_GAS_PRICE = 40000000000; 
322 
323     uint public REPAY_GAS_COST = 1800000;
324     uint public BOOST_GAS_COST = 1250000;
325 
326     MCDMonitorProxy public monitorProxyContract;
327     ISubscriptions public subscriptionsContract;
328     GasTokenInterface gasToken = GasTokenInterface(GAS_TOKEN_INTERFACE_ADDRESS);
329     address public owner;
330     address public mcdSaverProxyAddress;
331 
332     
333     mapping(address => bool) public approvedCallers;
334 
335     event CdpRepay(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio);
336     event CdpBoost(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio);
337 
338     modifier onlyApproved() {
339         require(approvedCallers[msg.sender]);
340         _;
341     }
342 
343     modifier onlyOwner() {
344         require(owner == msg.sender);
345         _;
346     }
347 
348     constructor(address _monitorProxy, address _subscriptions, address _mcdSaverProxyAddress) public {
349         approvedCallers[msg.sender] = true;
350         owner = msg.sender;
351 
352         monitorProxyContract = MCDMonitorProxy(_monitorProxy);
353         subscriptionsContract = ISubscriptions(_subscriptions);
354         mcdSaverProxyAddress = _mcdSaverProxyAddress;
355     }
356 
357     
358     
359     
360     
361     
362     
363     function repayFor(uint _cdpId, uint _amount, address _collateralJoin, uint _exchangeType) public onlyApproved {
364         if (gasToken.balanceOf(address(this)) >= BOOST_GAS_TOKEN) {
365             gasToken.free(BOOST_GAS_TOKEN);
366         }
367 
368 
369         uint ratioBefore;
370         bool canCall;
371         (canCall, ratioBefore) = subscriptionsContract.canCall(Method.Repay, _cdpId);
372         require(canCall);
373 
374         uint gasCost = calcGasCost(REPAY_GAS_COST);
375 
376         monitorProxyContract.callExecute(subscriptionsContract.getOwner(_cdpId), mcdSaverProxyAddress, abi.encodeWithSignature("repay(uint256,address,uint256,uint256,uint256,uint256)", _cdpId, _collateralJoin, _amount, 0, _exchangeType, gasCost));
377 
378         uint ratioAfter;
379         bool ratioGoodAfter;
380         (ratioGoodAfter, ratioAfter) = subscriptionsContract.ratioGoodAfter(Method.Repay, _cdpId);
381         
382         require(ratioGoodAfter);
383 
384         emit CdpRepay(_cdpId, msg.sender, _amount, ratioBefore, ratioAfter);
385     }
386 
387     
388     
389     
390     
391     
392     
393     function boostFor(uint _cdpId, uint _amount, address _collateralJoin, uint _exchangeType) public onlyApproved {
394         if (gasToken.balanceOf(address(this)) >= REPAY_GAS_TOKEN) {
395             gasToken.free(REPAY_GAS_TOKEN);
396         }
397 
398         uint ratioBefore;
399         bool canCall;
400         (canCall, ratioBefore) = subscriptionsContract.canCall(Method.Boost, _cdpId);
401         require(canCall);
402 
403         uint gasCost = calcGasCost(BOOST_GAS_COST);
404 
405         monitorProxyContract.callExecute(subscriptionsContract.getOwner(_cdpId), mcdSaverProxyAddress, abi.encodeWithSignature("boost(uint256,address,uint256,uint256,uint256,uint256)", _cdpId, _collateralJoin, _amount, 0, _exchangeType, gasCost));
406 
407         uint ratioAfter;
408         bool ratioGoodAfter;
409         (ratioGoodAfter, ratioAfter) = subscriptionsContract.ratioGoodAfter(Method.Boost, _cdpId);
410         
411         require(ratioGoodAfter);
412 
413         emit CdpBoost(_cdpId, msg.sender, _amount, ratioBefore, ratioAfter);
414     }
415 
416     
417     
418     
419     function calcGasCost(uint _gasAmount) internal view returns (uint) {
420         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
421 
422         return mul(gasPrice, _gasAmount);
423     }
424 
425 
426 
427     
428     
429     function changeBoostGasCost(uint _gasCost) public onlyOwner {
430         require(_gasCost < 3000000);
431 
432         BOOST_GAS_COST = _gasCost;
433     }
434 
435     
436     
437     function changeRepayGasCost(uint _gasCost) public onlyOwner {
438         require(_gasCost < 3000000);
439 
440         REPAY_GAS_COST = _gasCost;
441     }
442 
443     
444     
445     function addCaller(address _caller) public onlyOwner {
446         approvedCallers[_caller] = true;
447     }
448 
449     
450     
451     function removeCaller(address _caller) public onlyOwner {
452         approvedCallers[_caller] = false;
453     }
454 
455     
456     
457     
458     
459     function transferERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
460         ERC20(_tokenAddress).transfer(_to, _amount);
461     }
462 
463     
464     
465     
466     function transferEth(address payable _to, uint _amount) public onlyOwner {
467         _to.transfer(_amount);
468     }
469 }