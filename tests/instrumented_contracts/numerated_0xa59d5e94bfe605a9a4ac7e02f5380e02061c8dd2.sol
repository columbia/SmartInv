1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract StaticV2 {
6 
7     enum Method { Boost, Repay }
8 
9     struct CdpHolder {
10         uint128 minRatio;
11         uint128 maxRatio;
12         uint128 optimalRatioBoost;
13         uint128 optimalRatioRepay;
14         address owner;
15         uint cdpId;
16         bool boostEnabled;
17         bool nextPriceEnabled;
18     }
19 
20     struct SubPosition {
21         uint arrPos;
22         bool subscribed;
23     }
24 }
25 
26 contract ISubscriptionsV2 is StaticV2 {
27 
28     function getOwner(uint _cdpId) external view returns(address);
29     function getSubscribedInfo(uint _cdpId) public view returns(bool, uint128, uint128, uint128, uint128, address, uint coll, uint debt);
30     function getCdpHolder(uint _cdpId) public view returns (bool subscribed, CdpHolder memory);
31 }
32 
33 contract DSProxyInterface {
34 
35     
36     
37     
38     
39     
40 
41     function execute(address _target, bytes memory _data) public payable returns (bytes32);
42 
43     function setCache(address _cacheAddr) public payable returns (bool);
44 
45     function owner() public returns (address);
46 }
47 
48 interface ERC20 {
49     function totalSupply() external view returns (uint256 supply);
50 
51     function balanceOf(address _owner) external view returns (uint256 balance);
52 
53     function transfer(address _to, uint256 _value) external returns (bool success);
54 
55     function transferFrom(address _from, address _to, uint256 _value)
56         external
57         returns (bool success);
58 
59     function approve(address _spender, uint256 _value) external returns (bool success);
60 
61     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
62 
63     function decimals() external view returns (uint256 digits);
64 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 contract AdminAuth {
69 
70     address public owner;
71     address public admin;
72 
73     modifier onlyOwner() {
74         require(owner == msg.sender);
75         _;
76     }
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     
83     
84     function setAdminByOwner(address _admin) public {
85         require(msg.sender == owner);
86         require(_admin == address(0));
87 
88         admin = _admin;
89     }
90 
91     
92     
93     function setAdminByAdmin(address _admin) public {
94         require(msg.sender == admin);
95 
96         admin = _admin;
97     }
98 
99     
100     
101     function setOwnerByAdmin(address _owner) public {
102         require(msg.sender == admin);
103 
104         owner = _owner;
105     }
106 }
107 
108 contract MCDMonitorProxyV2 is AdminAuth {
109 
110     uint public CHANGE_PERIOD;
111     address public monitor;
112     address public newMonitor;
113     address public lastMonitor;
114     uint public changeRequestedTimestamp;
115 
116     mapping(address => bool) public allowed;
117 
118     event MonitorChangeInitiated(address oldMonitor, address newMonitor);
119     event MonitorChangeCanceled();
120     event MonitorChangeFinished(address monitor);
121     event MonitorChangeReverted(address monitor);
122 
123     
124     modifier onlyAllowed() {
125         require(allowed[msg.sender] || msg.sender == owner);
126         _;
127     }
128 
129     modifier onlyMonitor() {
130         require (msg.sender == monitor);
131         _;
132     }
133 
134     constructor(uint _changePeriod) public {
135         CHANGE_PERIOD = _changePeriod * 1 days;
136     }
137 
138     
139     
140     
141     
142     function callExecute(address _owner, address _saverProxy, bytes memory _data) public payable onlyMonitor {
143         
144         DSProxyInterface(_owner).execute.value(msg.value)(_saverProxy, _data);
145 
146         
147         if (address(this).balance > 0) {
148             msg.sender.transfer(address(this).balance);
149         }
150     }
151 
152     
153     
154     function setMonitor(address _monitor) public onlyAllowed {
155         require(monitor == address(0));
156         monitor = _monitor;
157     }
158 
159     
160     
161     
162     function changeMonitor(address _newMonitor) public onlyAllowed {
163         require(changeRequestedTimestamp == 0);
164 
165         changeRequestedTimestamp = now;
166         lastMonitor = monitor;
167         newMonitor = _newMonitor;
168 
169         emit MonitorChangeInitiated(lastMonitor, newMonitor);
170     }
171 
172     
173     function cancelMonitorChange() public onlyAllowed {
174         require(changeRequestedTimestamp > 0);
175 
176         changeRequestedTimestamp = 0;
177         newMonitor = address(0);
178 
179         emit MonitorChangeCanceled();
180     }
181 
182     
183     function confirmNewMonitor() public onlyAllowed {
184         require((changeRequestedTimestamp + CHANGE_PERIOD) < now);
185         require(changeRequestedTimestamp != 0);
186         require(newMonitor != address(0));
187 
188         monitor = newMonitor;
189         newMonitor = address(0);
190         changeRequestedTimestamp = 0;
191 
192         emit MonitorChangeFinished(monitor);
193     }
194 
195     
196     function revertMonitor() public onlyAllowed {
197         require(lastMonitor != address(0));
198 
199         monitor = lastMonitor;
200 
201         emit MonitorChangeReverted(monitor);
202     }
203 
204 
205     
206     
207     function addAllowed(address _user) public onlyAllowed {
208         allowed[_user] = true;
209     }
210 
211     
212     
213     
214     function removeAllowed(address _user) public onlyAllowed {
215         allowed[_user] = false;
216     }
217 
218     function setChangePeriod(uint _periodInDays) public onlyAllowed {
219         require(_periodInDays * 1 days > CHANGE_PERIOD);
220 
221         CHANGE_PERIOD = _periodInDays * 1 days;
222     }
223 
224     
225     
226     function withdrawToken(address _token) public onlyOwner {
227         uint balance = ERC20(_token).balanceOf(address(this));
228         ERC20(_token).transfer(msg.sender, balance);
229     }
230 
231     
232     function withdrawEth() public onlyOwner {
233         uint balance = address(this).balance;
234         msg.sender.transfer(balance);
235     }
236 }
237 
238 contract ConstantAddressesMainnet {
239     address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
240     address public constant IDAI_ADDRESS = 0x14094949152EDDBFcd073717200DA82fEd8dC960;
241     address public constant SOLO_MARGIN_ADDRESS = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
242     address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
243     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
244     address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
245     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
246     address public constant VOX_ADDRESS = 0x9B0F70Df76165442ca6092939132bBAEA77f2d7A;
247     address public constant PETH_ADDRESS = 0xf53AD2c6851052A81B42133467480961B2321C09;
248     address public constant TUB_ADDRESS = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
249     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
250     address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
251     address public constant OTC_ADDRESS = 0x794e6e91555438aFc3ccF1c5076A74F42133d08D;
252     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
253 
254     address public constant KYBER_WRAPPER = 0x8F337bD3b7F2b05d9A8dC8Ac518584e833424893;
255     address public constant UNISWAP_WRAPPER = 0x1e30124FDE14533231216D95F7798cD0061e5cf8;
256     address public constant ETH2DAI_WRAPPER = 0xd7BBB1777E13b6F535Dec414f575b858ed300baF;
257     address public constant OASIS_WRAPPER = 0x9aBE2715D2d99246269b8E17e9D1b620E9bf6558;
258 
259     address public constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
260     address public constant UNISWAP_FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
261     address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
262     address public constant PIP_INTERFACE_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
263 
264     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
265     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
266 
267     address public constant SAVINGS_LOGGER_ADDRESS = 0x89b3635BD2bAD145C6f92E82C9e83f06D5654984;
268     address public constant AUTOMATIC_LOGGER_ADDRESS = 0xAD32Ce09DE65971fFA8356d7eF0B783B82Fd1a9A;
269 
270     address public constant SAVER_EXCHANGE_ADDRESS = 0x6eC6D98e2AF940436348883fAFD5646E9cdE2446;
271 
272     
273     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
274     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
275 
276     
277     address public constant MANAGER_ADDRESS = 0x5ef30b9986345249bc32d8928B7ee64DE9435E39;
278     address public constant VAT_ADDRESS = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B;
279     address public constant SPOTTER_ADDRESS = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
280     address public constant PROXY_ACTIONS = 0x82ecD135Dce65Fbc6DbdD0e4237E0AF93FFD5038;
281 
282     address public constant JUG_ADDRESS = 0x19c0976f590D67707E62397C87829d896Dc0f1F1;
283     address public constant DAI_JOIN_ADDRESS = 0x9759A6Ac90977b93B58547b4A71c78317f391A28;
284     address public constant ETH_JOIN_ADDRESS = 0x2F0b23f53734252Bda2277357e97e1517d6B042A;
285     address public constant MIGRATION_ACTIONS_PROXY = 0xe4B22D484958E582098A98229A24e8A43801b674;
286 
287     address public constant SAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
288     address public constant DAI_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
289 
290     address payable public constant SCD_MCD_MIGRATION = 0xc73e0383F3Aff3215E6f04B0331D58CeCf0Ab849;
291 
292     
293     address public constant SUBSCRIPTION_ADDRESS = 0x83152CAA0d344a2Fd428769529e2d490A88f4393;
294     address public constant MONITOR_ADDRESS = 0x3F4339816EDEF8D3d3970DB2993e2e0Ec6010760;
295 
296     address public constant NEW_CDAI_ADDRESS = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
297     address public constant NEW_IDAI_ADDRESS = 0x493C57C4763932315A328269E1ADaD09653B9081;
298 
299     address public constant ERC20_PROXY_0X = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
300 }
301 
302 contract ConstantAddressesKovan {
303     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
304     address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
305     address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
306     address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
307     address public constant VOX_ADDRESS = 0xBb4339c0aB5B1d9f14Bd6e3426444A1e9d86A1d9;
308     address public constant PETH_ADDRESS = 0xf4d791139cE033Ad35DB2B2201435fAd668B1b64;
309     address public constant TUB_ADDRESS = 0xa71937147b55Deb8a530C7229C442Fd3F31b7db2;
310     address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
311     address payable public constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
312     address public constant OTC_ADDRESS = 0x4A6bC4e803c62081ffEbCc8d227B5a87a58f1F8F;
313     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
314     address public constant SOLO_MARGIN_ADDRESS = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
315     address public constant IDAI_ADDRESS = 0xA1e58F3B1927743393b25f261471E1f2D3D9f0F6;
316     address public constant CDAI_ADDRESS = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
317     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
318     address public constant DISCOUNT_ADDRESS = 0x1297c1105FEDf45E0CF6C102934f32C4EB780929;
319     address public constant SAI_SAVER_PROXY = 0xADB7c74bCe932fC6C27ddA3Ac2344707d2fBb0E6;
320 
321     address public constant KYBER_WRAPPER = 0x68c56FF0E7BBD30AF9Ad68225479449869fC1bA0;
322     address public constant UNISWAP_WRAPPER = 0x2A4ee140F05f1Ba9A07A020b07CCFB76CecE4b43;
323     address public constant ETH2DAI_WRAPPER = 0x823cde416973a19f98Bb9C96d97F4FE6C9A7238B;
324     address public constant OASIS_WRAPPER = 0x0257Ba4876863143bbeDB7847beC583e4deb6fE6;
325 
326     address public constant SAVER_EXCHANGE_ADDRESS = 0xACA7d11e3f482418C324aAC8e90AaD0431f692A6;
327 
328     address public constant FACTORY_ADDRESS = 0xc72E74E474682680a414b506699bBcA44ab9a930;
329     
330     address public constant PIP_INTERFACE_ADDRESS = 0xA944bd4b25C9F186A846fd5668941AA3d3B8425F;
331     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x64A436ae831C1672AE81F674CAb8B6775df3475C;
332     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
333     address public constant KYBER_INTERFACE = 0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D;
334 
335     address public constant SAVINGS_LOGGER_ADDRESS = 0x2aa889D809B29c608dA99767837D189dAe12a874;
336 
337     
338     address public constant UNISWAP_FACTORY = 0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36;
339 
340     
341     address public constant MANAGER_ADDRESS = 0x1476483dD8C35F25e568113C5f70249D3976ba21;
342     address public constant VAT_ADDRESS = 0xbA987bDB501d131f766fEe8180Da5d81b34b69d9;
343     address public constant SPOTTER_ADDRESS = 0x3a042de6413eDB15F2784f2f97cC68C7E9750b2D;
344 
345     address public constant JUG_ADDRESS = 0xcbB7718c9F39d05aEEDE1c472ca8Bf804b2f1EaD;
346     address public constant DAI_JOIN_ADDRESS = 0x5AA71a3ae1C0bd6ac27A1f28e1415fFFB6F15B8c;
347     address public constant ETH_JOIN_ADDRESS = 0x775787933e92b709f2a3C70aa87999696e74A9F8;
348     address public constant MIGRATION_ACTIONS_PROXY = 0x433870076aBd08865f0e038dcC4Ac6450e313Bd8;
349     address public constant PROXY_ACTIONS = 0xd1D24637b9109B7f61459176EdcfF9Be56283a7B;
350 
351     address public constant SAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
352     address public constant DAI_ADDRESS = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
353 
354     address payable public constant SCD_MCD_MIGRATION = 0x411B2Faa662C8e3E5cF8f01dFdae0aeE482ca7b0;
355 
356     
357     address public constant SUBSCRIPTION_ADDRESS = 0xFC41f79776061a396635aD0b9dF7a640A05063C1;
358     address public constant MONITOR_ADDRESS = 0xfC1Fc0502e90B7A3766f93344E1eDb906F8A75DD;
359 
360     
361     address public constant NEW_CDAI_ADDRESS = 0xe7bc397DBd069fC7d0109C0636d06888bb50668c;
362     address public constant NEW_IDAI_ADDRESS = 0x6c1E2B0f67e00c06c8e2BE7Dc681Ab785163fF4D;
363 }
364 
365 contract ConstantAddresses is ConstantAddressesMainnet {}
366 
367 contract GasTokenInterface is ERC20 {
368     function free(uint256 value) public returns (bool success);
369 
370     function freeUpTo(uint256 value) public returns (uint256 freed);
371 
372     function freeFrom(address from, uint256 value) public returns (bool success);
373 
374     function freeFromUpTo(address from, uint256 value) public returns (uint256 freed);
375 }
376 
377 contract DSMath {
378     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
379         require((z = x + y) >= x);
380     }
381 
382     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
383         require((z = x - y) <= x);
384     }
385 
386     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
387         require(y == 0 || (z = x * y) / y == x);
388     }
389 
390     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
391         return x / y;
392     }
393 
394     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
395         return x <= y ? x : y;
396     }
397 
398     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
399         return x >= y ? x : y;
400     }
401 
402     function imin(int256 x, int256 y) internal pure returns (int256 z) {
403         return x <= y ? x : y;
404     }
405 
406     function imax(int256 x, int256 y) internal pure returns (int256 z) {
407         return x >= y ? x : y;
408     }
409 
410     uint256 constant WAD = 10**18;
411     uint256 constant RAY = 10**27;
412 
413     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
414         z = add(mul(x, y), WAD / 2) / WAD;
415     }
416 
417     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
418         z = add(mul(x, y), RAY / 2) / RAY;
419     }
420 
421     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
422         z = add(mul(x, WAD), y / 2) / y;
423     }
424 
425     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
426         z = add(mul(x, RAY), y / 2) / y;
427     }
428 
429     
430     
431     
432     
433     
434     
435     
436     
437     
438     
439     
440     
441     
442     
443     
444     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
445         z = n % 2 != 0 ? x : RAY;
446 
447         for (n /= 2; n != 0; n /= 2) {
448             x = rmul(x, x);
449 
450             if (n % 2 != 0) {
451                 z = rmul(z, x);
452             }
453         }
454     }
455 }
456 
457 contract Manager {
458     function last(address) public returns (uint);
459     function cdpCan(address, uint, address) public view returns (uint);
460     function ilks(uint) public view returns (bytes32);
461     function owns(uint) public view returns (address);
462     function urns(uint) public view returns (address);
463     function vat() public view returns (address);
464     function open(bytes32, address) public returns (uint);
465     function give(uint, address) public;
466     function cdpAllow(uint, address, uint) public;
467     function urnAllow(address, uint) public;
468     function frob(uint, int, int) public;
469     function flux(uint, address, uint) public;
470     function move(uint, address, uint) public;
471     function exit(address, uint, address, uint) public;
472     function quit(uint, address) public;
473     function enter(address, uint) public;
474     function shift(uint, uint) public;
475 }
476 
477 contract Vat {
478 
479     struct Urn {
480         uint256 ink;   
481         uint256 art;   
482     }
483 
484     struct Ilk {
485         uint256 Art;   
486         uint256 rate;  
487         uint256 spot;  
488         uint256 line;  
489         uint256 dust;  
490     }
491 
492     mapping (bytes32 => mapping (address => Urn )) public urns;
493     mapping (bytes32 => Ilk)                       public ilks;
494     mapping (bytes32 => mapping (address => uint)) public gem;  
495 
496     function can(address, address) public view returns (uint);
497     function dai(address) public view returns (uint);
498     function frob(bytes32, address, address, address, int, int) public;
499     function hope(address) public;
500     function move(address, address, uint) public;
501 }
502 
503 contract PipInterface {
504     function read() public returns (bytes32);
505 }
506 
507 contract Spotter {
508     struct Ilk {
509         PipInterface pip;
510         uint256 mat;
511     }
512 
513     mapping (bytes32 => Ilk) public ilks;
514 
515     uint256 public par;
516 
517 }
518 
519 contract AutomaticLogger {
520     event CdpRepay(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);
521     event CdpBoost(uint indexed cdpId, address indexed caller, uint amount, uint beforeRatio, uint afterRatio, address logger);
522 
523     function logRepay(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
524         emit CdpRepay(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
525     }
526 
527     function logBoost(uint cdpId, address caller, uint amount, uint beforeRatio, uint afterRatio) public {
528         emit CdpBoost(cdpId, caller, amount, beforeRatio, afterRatio, msg.sender);
529     }
530 }
531 
532 contract MCDMonitorV2 is AdminAuth, ConstantAddresses, DSMath, StaticV2 {
533 
534     uint public REPAY_GAS_TOKEN = 30;
535     uint public BOOST_GAS_TOKEN = 19;
536 
537     uint constant public MAX_GAS_PRICE = 80000000000; 
538 
539     uint public REPAY_GAS_COST = 2200000;
540     uint public BOOST_GAS_COST = 1500000;
541 
542     MCDMonitorProxyV2 public monitorProxyContract;
543     ISubscriptionsV2 public subscriptionsContract;
544     GasTokenInterface gasToken = GasTokenInterface(GAS_TOKEN_INTERFACE_ADDRESS);
545     address public automaticSaverProxyAddress;
546 
547     Manager public manager = Manager(MANAGER_ADDRESS);
548     Vat public vat = Vat(VAT_ADDRESS);
549     Spotter public spotter = Spotter(SPOTTER_ADDRESS);
550     AutomaticLogger public logger = AutomaticLogger(AUTOMATIC_LOGGER_ADDRESS);
551 
552     
553     mapping(address => bool) public approvedCallers;
554 
555     modifier onlyApproved() {
556         require(approvedCallers[msg.sender]);
557         _;
558     }
559 
560     constructor(address _monitorProxy, address _subscriptions, address _automaticSaverProxyAddress) public {
561         approvedCallers[msg.sender] = true;
562 
563         monitorProxyContract = MCDMonitorProxyV2(_monitorProxy);
564         subscriptionsContract = ISubscriptionsV2(_subscriptions);
565         automaticSaverProxyAddress = _automaticSaverProxyAddress;
566     }
567 
568     
569     
570     
571     
572     
573     
574     
575     function repayFor(
576         uint[6] memory _data, 
577         uint256 _nextPrice,
578         address _joinAddr,
579         address _exchangeAddress,
580         bytes memory _callData
581     ) public payable onlyApproved {
582         if (gasToken.balanceOf(address(this)) >= BOOST_GAS_TOKEN) {
583             gasToken.free(BOOST_GAS_TOKEN);
584         }
585 
586         uint ratioBefore;
587         bool isAllowed;
588         (isAllowed, ratioBefore) = canCall(Method.Repay, _data[0], _nextPrice);
589         require(isAllowed);
590 
591         uint gasCost = calcGasCost(REPAY_GAS_COST);
592         _data[4] = gasCost;
593 
594         monitorProxyContract.callExecute.value(msg.value)(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticRepay(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));
595 
596         uint ratioAfter;
597         bool isGoodRatio;
598         (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Repay, _data[0], _nextPrice);
599         
600         require(isGoodRatio);
601 
602         returnEth();        
603 
604         logger.logRepay(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
605     }
606 
607     
608     
609     
610     
611     
612     
613     
614     function boostFor(
615         uint[6] memory _data, 
616         uint256 _nextPrice,
617         address _joinAddr,
618         address _exchangeAddress,
619         bytes memory _callData
620     ) public payable onlyApproved {
621         if (gasToken.balanceOf(address(this)) >= REPAY_GAS_TOKEN) {
622             gasToken.free(REPAY_GAS_TOKEN);
623         }
624 
625         uint ratioBefore;
626         bool isAllowed;
627         (isAllowed, ratioBefore) = canCall(Method.Boost, _data[0], _nextPrice);
628         require(isAllowed);
629 
630         uint gasCost = calcGasCost(BOOST_GAS_COST);
631         _data[4] = gasCost;
632 
633         monitorProxyContract.callExecute.value(msg.value)(subscriptionsContract.getOwner(_data[0]), automaticSaverProxyAddress, abi.encodeWithSignature("automaticBoost(uint256[6],address,address,bytes)", _data, _joinAddr, _exchangeAddress, _callData));
634 
635         uint ratioAfter;
636         bool isGoodRatio;
637         (isGoodRatio, ratioAfter) = ratioGoodAfter(Method.Boost, _data[0], _nextPrice);
638         
639         require(isGoodRatio);
640 
641         returnEth();
642 
643         logger.logBoost(_data[0], msg.sender, _data[1], ratioBefore, ratioAfter);
644     }
645 
646 
647     function returnEth() internal {
648         
649         if (address(this).balance > 0) {
650             msg.sender.transfer(address(this).balance);
651         }
652     }
653 
654 
655 
656     
657     
658     function getOwner(uint _cdpId) public view returns(address) {
659         return manager.owns(_cdpId);
660     }
661 
662     
663     
664     
665     function getCdpInfo(uint _cdpId, bytes32 _ilk) public view returns (uint, uint) {
666         address urn = manager.urns(_cdpId);
667 
668         (uint collateral, uint debt) = vat.urns(_ilk, urn);
669         (,uint rate,,,) = vat.ilks(_ilk);
670 
671         return (collateral, rmul(debt, rate));
672     }
673 
674     
675     
676     function getPrice(bytes32 _ilk) public view returns (uint) {
677         (, uint mat) = spotter.ilks(_ilk);
678         (,,uint spot,,) = vat.ilks(_ilk);
679 
680         return rmul(rmul(spot, spotter.par()), mat);
681     }
682 
683     
684     
685     
686     function getRatio(uint _cdpId, uint _nextPrice) public view returns (uint) {
687         bytes32 ilk = manager.ilks(_cdpId);
688         uint price = (_nextPrice == 0) ? getPrice(ilk) : _nextPrice;
689 
690         (uint collateral, uint debt) = getCdpInfo(_cdpId, ilk);
691 
692         if (debt == 0) return 0;
693 
694         return rdiv(wmul(collateral, price), debt) / (10 ** 18);
695     }
696 
697     
698     
699     function canCall(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
700         bool subscribed;
701         CdpHolder memory holder;
702         (subscribed, holder) = subscriptionsContract.getCdpHolder(_cdpId);
703 
704         
705         if (!subscribed) return (false, 0);
706 
707         
708         if (_nextPrice > 0 && !holder.nextPriceEnabled) return (false, 0);
709 
710         
711         if (_method == Method.Boost && !holder.boostEnabled) return (false, 0);
712 
713         
714         if (getOwner(_cdpId) != holder.owner) return (false, 0);
715 
716         uint currRatio = getRatio(_cdpId, _nextPrice);
717 
718         if (_method == Method.Repay) {
719             return (currRatio < holder.minRatio, currRatio);
720         } else if (_method == Method.Boost) {
721             return (currRatio > holder.maxRatio, currRatio);
722         }
723     }
724 
725     
726     function ratioGoodAfter(Method _method, uint _cdpId, uint _nextPrice) public view returns(bool, uint) {
727         CdpHolder memory holder;
728 
729         (, holder) = subscriptionsContract.getCdpHolder(_cdpId);
730 
731         uint currRatio = getRatio(_cdpId, _nextPrice);
732 
733         if (_method == Method.Repay) {
734             return (currRatio < holder.maxRatio, currRatio);
735         } else if (_method == Method.Boost) {
736             return (currRatio > holder.minRatio, currRatio);
737         }
738     }
739 
740     
741     
742     
743     function calcGasCost(uint _gasAmount) public view returns (uint) {
744         uint gasPrice = tx.gasprice <= MAX_GAS_PRICE ? tx.gasprice : MAX_GAS_PRICE;
745 
746         return mul(gasPrice, _gasAmount);
747     }
748 
749 
750 
751     
752     
753     function changeBoostGasCost(uint _gasCost) public onlyOwner {
754         require(_gasCost < 3000000);
755 
756         BOOST_GAS_COST = _gasCost;
757     }
758 
759     
760     
761     function changeRepayGasCost(uint _gasCost) public onlyOwner {
762         require(_gasCost < 3000000);
763 
764         REPAY_GAS_COST = _gasCost;
765     }
766 
767     
768     
769     
770     function changeGasTokenAmount(uint _gasAmount, bool _isRepay) public onlyOwner {
771         if (_isRepay) {
772             REPAY_GAS_TOKEN = _gasAmount;
773         } else {
774             BOOST_GAS_TOKEN = _gasAmount;
775         }
776     }
777 
778     
779     
780     function addCaller(address _caller) public onlyOwner {
781         approvedCallers[_caller] = true;
782     }
783 
784     
785     
786     function removeCaller(address _caller) public onlyOwner {
787         approvedCallers[_caller] = false;
788     }
789 
790     
791     
792     
793     
794     function transferERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
795         ERC20(_tokenAddress).transfer(_to, _amount);
796     }
797 
798     
799     
800     
801     function transferEth(address payable _to, uint _amount) public onlyOwner {
802         _to.transfer(_amount);
803     }
804 }