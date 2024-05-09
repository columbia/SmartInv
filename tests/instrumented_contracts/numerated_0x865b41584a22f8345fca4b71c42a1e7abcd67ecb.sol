1 pragma solidity ^0.5.0;
2 
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint supply);
6     function balanceOf(address _owner) external view returns (uint balance);
7     function transfer(address _to, uint _value) external returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
9     function approve(address _spender, uint _value) external returns (bool success);
10     function allowance(address _owner, address _spender) external view returns (uint remaining);
11     function decimals() external view returns(uint digits);
12     event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 interface ExchangeInterface {
16     function swapEtherToToken (uint _ethAmount, address _tokenAddress, uint _maxAmount) payable external returns(uint, uint);
17     function swapTokenToEther (address _tokenAddress, uint _amount, uint _maxAmount) external returns(uint);
18     function swapTokenToToken(address _src, address _dest, uint _amount) external payable returns(uint);
19 
20     function getExpectedRate(address src, address dest, uint srcQty) external view
21         returns (uint expectedRate);
22 }
23 
24 contract DSMath {
25     function add(uint x, uint y) internal pure returns (uint z) {
26         require((z = x + y) >= x);
27     }
28     function sub(uint x, uint y) internal pure returns (uint z) {
29         require((z = x - y) <= x);
30     }
31     function mul(uint x, uint y) internal pure returns (uint z) {
32         require(y == 0 || (z = x * y) / y == x);
33     }
34 
35     function min(uint x, uint y) internal pure returns (uint z) {
36         return x <= y ? x : y;
37     }
38     function max(uint x, uint y) internal pure returns (uint z) {
39         return x >= y ? x : y;
40     }
41     function imin(int x, int y) internal pure returns (int z) {
42         return x <= y ? x : y;
43     }
44     function imax(int x, int y) internal pure returns (int z) {
45         return x >= y ? x : y;
46     }
47 
48     uint constant WAD = 10 ** 18;
49     uint constant RAY = 10 ** 27;
50 
51     function wmul(uint x, uint y) internal pure returns (uint z) {
52         z = add(mul(x, y), WAD / 2) / WAD;
53     }
54     function rmul(uint x, uint y) internal pure returns (uint z) {
55         z = add(mul(x, y), RAY / 2) / RAY;
56     }
57     function wdiv(uint x, uint y) internal pure returns (uint z) {
58         z = add(mul(x, WAD), y / 2) / y;
59     }
60     function rdiv(uint x, uint y) internal pure returns (uint z) {
61         z = add(mul(x, RAY), y / 2) / y;
62     }
63 
64     
65     
66     
67     
68     
69     
70     
71     
72     
73     
74     
75     
76     
77     
78     
79     function rpow(uint x, uint n) internal pure returns (uint z) {
80         z = n % 2 != 0 ? x : RAY;
81 
82         for (n /= 2; n != 0; n /= 2) {
83             x = rmul(x, x);
84 
85             if (n % 2 != 0) {
86                 z = rmul(z, x);
87             }
88         }
89     }
90 }
91 
92 contract ConstantAddressesMainnet {
93     address public constant MAKER_DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
94     address public constant IDAI_ADDRESS = 0x14094949152EDDBFcd073717200DA82fEd8dC960;
95     address public constant SOLO_MARGIN_ADDRESS = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;
96     address public constant CDAI_ADDRESS = 0xF5DCe57282A584D2746FaF1593d3121Fcac444dC;
97     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
98     address public constant MKR_ADDRESS = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2;
99     address public constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
100     address public constant VOX_ADDRESS = 0x9B0F70Df76165442ca6092939132bBAEA77f2d7A;
101     address public constant PETH_ADDRESS = 0xf53AD2c6851052A81B42133467480961B2321C09;
102     address public constant TUB_ADDRESS = 0x448a5065aeBB8E423F0896E6c5D525C040f59af3;
103     address payable public constant WALLET_ID = 0x322d58b9E75a6918f7e7849AEe0fF09369977e08;
104     address public constant LOGGER_ADDRESS = 0xeCf88e1ceC2D2894A0295DB3D86Fe7CE4991E6dF;
105     address public constant OTC_ADDRESS = 0x39755357759cE0d7f32dC8dC45414CCa409AE24e;
106     address public constant DISCOUNT_ADDRESS = 0x1b14E8D511c9A4395425314f849bD737BAF8208F;
107 
108     address public constant KYBER_WRAPPER = 0x8F337bD3b7F2b05d9A8dC8Ac518584e833424893;
109     address public constant UNISWAP_WRAPPER = 0x1e30124FDE14533231216D95F7798cD0061e5cf8;
110     address public constant ETH2DAI_WRAPPER = 0xd7BBB1777E13b6F535Dec414f575b858ed300baF;
111     address public constant OASIS_WRAPPER = 0x9aBE2715D2d99246269b8E17e9D1b620E9bf6558;
112 
113     address public constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
114     address public constant UNISWAP_FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
115     address public constant FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
116     address public constant PIP_INTERFACE_ADDRESS = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
117 
118     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
119     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000b3F879cb30FE243b4Dfee438691c04;
120 
121     address public constant SAVINGS_LOGGER_ADDRESS = 0x89b3635BD2bAD145C6f92E82C9e83f06D5654984;
122 
123     
124     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
125     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
126 }
127 
128 contract ConstantAddressesKovan {
129     address public constant KYBER_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
130     address public constant WETH_ADDRESS = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;
131     address public constant MAKER_DAI_ADDRESS = 0xC4375B7De8af5a38a93548eb8453a498222C4fF2;
132     address public constant MKR_ADDRESS = 0xAaF64BFCC32d0F15873a02163e7E500671a4ffcD;
133     address public constant VOX_ADDRESS = 0xBb4339c0aB5B1d9f14Bd6e3426444A1e9d86A1d9;
134     address public constant PETH_ADDRESS = 0xf4d791139cE033Ad35DB2B2201435fAd668B1b64;
135     address public constant TUB_ADDRESS = 0xa71937147b55Deb8a530C7229C442Fd3F31b7db2;
136     address public constant LOGGER_ADDRESS = 0x32d0e18f988F952Eb3524aCE762042381a2c39E5;
137     address payable public  constant WALLET_ID = 0x54b44C6B18fc0b4A1010B21d524c338D1f8065F6;
138     address public constant OTC_ADDRESS = 0x4A6bC4e803c62081ffEbCc8d227B5a87a58f1F8F;
139     address public constant COMPOUND_DAI_ADDRESS = 0x25a01a05C188DaCBCf1D61Af55D4a5B4021F7eeD;
140     address public constant SOLO_MARGIN_ADDRESS = 0x4EC3570cADaAEE08Ae384779B0f3A45EF85289DE;
141     address public constant IDAI_ADDRESS = 0xA1e58F3B1927743393b25f261471E1f2D3D9f0F6;
142     address public constant CDAI_ADDRESS = 0xb6b09fBffBa6A5C4631e5F7B2e3Ee183aC259c0d;
143     address public constant STUPID_EXCHANGE = 0x863E41FE88288ebf3fcd91d8Dbb679fb83fdfE17;
144     address public constant DISCOUNT_ADDRESS = 0x1297c1105FEDf45E0CF6C102934f32C4EB780929;
145 
146     address public constant KYBER_WRAPPER = 0x0eED9d768BBed73A66201ab1441fa6a039e65228;
147     address public constant UNISWAP_WRAPPER = 0xb07a1Cb9661957E6949362bce42BD6930f861673;
148     address public constant ETH2DAI_WRAPPER = 0x823cde416973a19f98Bb9C96d97F4FE6C9A7238B;
149     address public constant OASIS_WRAPPER = 0x6Ab7e1d38B16731cdd0540d2494FeE6d000D451C;
150 
151     address public constant FACTORY_ADDRESS = 0xc72E74E474682680a414b506699bBcA44ab9a930;
152     
153     address public constant PIP_INTERFACE_ADDRESS = 0xA944bd4b25C9F186A846fd5668941AA3d3B8425F;
154     address public constant PROXY_REGISTRY_INTERFACE_ADDRESS = 0x64A436ae831C1672AE81F674CAb8B6775df3475C;
155     address public constant GAS_TOKEN_INTERFACE_ADDRESS = 0x0000000000170CcC93903185bE5A2094C870Df62;
156     address public constant KYBER_INTERFACE = 0x692f391bCc85cefCe8C237C01e1f636BbD70EA4D;
157 
158     address public constant SAVINGS_LOGGER_ADDRESS = 0xA6E5d5F489b1c00d9C11E1caF45BAb6e6e26443d;
159 
160     
161     address public constant UNISWAP_FACTORY = 0xf5D915570BC477f9B8D6C0E980aA81757A3AaC36;
162 }
163 
164 contract ConstantAddresses is ConstantAddressesMainnet {
165 }
166 
167 contract Discount {
168 
169     address public owner;
170     mapping (address => CustomServiceFee) public serviceFees;
171 
172     uint constant MAX_SERVICE_FEE = 400;
173 
174     struct CustomServiceFee {
175         bool active;
176         uint amount;
177     }
178 
179     constructor() public {
180         owner = msg.sender;
181     }
182 
183     function isCustomFeeSet(address _user) public view returns (bool) {
184         return serviceFees[_user].active;
185     }
186 
187     function getCustomServiceFee(address _user) public view returns (uint) {
188         return serviceFees[_user].amount;
189     }
190 
191     function setServiceFee(address _user, uint _fee) public {
192         require(msg.sender == owner, "Only owner");
193         require(_fee >= MAX_SERVICE_FEE || _fee == 0);
194 
195         serviceFees[_user] = CustomServiceFee({
196             active: true,
197             amount: _fee
198         });
199     }
200 
201     function disableServiceFee(address _user) public {
202         require(msg.sender == owner, "Only owner");
203 
204         serviceFees[_user] = CustomServiceFee({
205             active: false,
206             amount: 0
207         });
208     }
209 }
210 
211 contract SaverExchange is DSMath, ConstantAddresses {
212 
213     uint public constant SERVICE_FEE = 800; 
214 
215     event Swap(address src, address dest, uint amountSold, uint amountBought);
216 
217     function swapTokenToToken(address _src, address _dest, uint _amount, uint _minPrice, uint _exchangeType) public payable {
218         if (_src == KYBER_ETH_ADDRESS) {
219             require(msg.value >= _amount);
220             
221             msg.sender.transfer(sub(msg.value, _amount));
222         } else {
223             require(ERC20(_src).transferFrom(msg.sender, address(this), _amount));
224         }
225 
226         uint fee = takeFee(_amount, _src);
227         _amount = sub(_amount, fee);
228 
229         address wrapper;
230         uint price;
231         (wrapper, price) = getBestPrice(_amount, _src, _dest, _exchangeType);
232 
233         require(price > _minPrice, "Slippage hit");
234 
235         uint tokensReturned;
236         if (_src == KYBER_ETH_ADDRESS) {
237             (tokensReturned,) = ExchangeInterface(wrapper).swapEtherToToken.value(_amount)(_amount, _dest, uint(-1));
238         } else {
239             ERC20(_src).transfer(wrapper, _amount);
240 
241             if (_dest == KYBER_ETH_ADDRESS) {
242                 tokensReturned = ExchangeInterface(wrapper).swapTokenToEther(_src, _amount, uint(-1));
243             } else {
244                 tokensReturned = ExchangeInterface(wrapper).swapTokenToToken(_src, _dest, _amount);
245             }
246         }
247 
248         if (_dest == KYBER_ETH_ADDRESS) {
249             msg.sender.transfer(tokensReturned);
250         } else {
251             ERC20(_dest).transfer(msg.sender, tokensReturned);
252         }
253 
254         emit Swap(_src, _dest, _amount, tokensReturned);
255     }
256 
257 
258     
259 
260     function swapDaiToEth(uint _amount, uint _minPrice, uint _exchangeType) public {
261         require(ERC20(MAKER_DAI_ADDRESS).transferFrom(msg.sender, address(this), _amount));
262 
263         uint fee = takeFee(_amount, MAKER_DAI_ADDRESS);
264         _amount = sub(_amount, fee);
265 
266         address exchangeWrapper;
267         uint daiEthPrice;
268         (exchangeWrapper, daiEthPrice) = getBestPrice(_amount, MAKER_DAI_ADDRESS, KYBER_ETH_ADDRESS, _exchangeType);
269 
270         require(daiEthPrice > _minPrice, "Slippage hit");
271 
272         ERC20(MAKER_DAI_ADDRESS).transfer(exchangeWrapper, _amount);
273         ExchangeInterface(exchangeWrapper).swapTokenToEther(MAKER_DAI_ADDRESS, _amount, uint(-1));
274 
275         uint daiBalance = ERC20(MAKER_DAI_ADDRESS).balanceOf(address(this));
276         if (daiBalance > 0) {
277             ERC20(MAKER_DAI_ADDRESS).transfer(msg.sender, daiBalance);
278         }
279 
280         msg.sender.transfer(address(this).balance);
281     }
282 
283     function swapEthToDai(uint _amount, uint _minPrice, uint _exchangeType) public payable {
284         require(msg.value >= _amount);
285 
286         address exchangeWrapper;
287         uint ethDaiPrice;
288         (exchangeWrapper, ethDaiPrice) = getBestPrice(_amount, KYBER_ETH_ADDRESS, MAKER_DAI_ADDRESS, _exchangeType);
289 
290         require(ethDaiPrice > _minPrice, "Slippage hit");
291 
292         uint ethReturned;
293         uint daiReturned;
294         (daiReturned, ethReturned) = ExchangeInterface(exchangeWrapper).swapEtherToToken.value(_amount)(_amount, MAKER_DAI_ADDRESS, uint(-1));
295 
296         uint fee = takeFee(daiReturned, MAKER_DAI_ADDRESS);
297         daiReturned = sub(daiReturned, fee);
298 
299         ERC20(MAKER_DAI_ADDRESS).transfer(msg.sender, daiReturned);
300 
301         if (ethReturned > 0) {
302             msg.sender.transfer(ethReturned);
303         }
304     }
305 
306 
307     
308     
309     
310     
311     
312     function getBestPrice(uint _amount, address _srcToken, address _destToken, uint _exchangeType) public returns (address, uint) {
313         uint expectedRateKyber;
314         uint expectedRateUniswap;
315         uint expectedRateOasis;
316 
317 
318         if (_exchangeType == 1) {
319             return (OASIS_WRAPPER, getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount));
320         }
321 
322         if (_exchangeType == 2) {
323             return (KYBER_WRAPPER, getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount));
324         }
325 
326         if (_exchangeType == 3) {
327             expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount);
328             expectedRateUniswap = expectedRateUniswap * (10 ** (18 - getDecimals(_destToken)));
329             return (UNISWAP_WRAPPER, expectedRateUniswap);
330         }
331 
332         expectedRateKyber = getExpectedRate(KYBER_WRAPPER, _srcToken, _destToken, _amount);
333         expectedRateUniswap = getExpectedRate(UNISWAP_WRAPPER, _srcToken, _destToken, _amount);
334         expectedRateUniswap = expectedRateUniswap * (10 ** (18 - getDecimals(_destToken)));
335         expectedRateOasis = getExpectedRate(OASIS_WRAPPER, _srcToken, _destToken, _amount);
336 
337         if ((expectedRateKyber >= expectedRateUniswap) && (expectedRateKyber >= expectedRateOasis)) {
338             return (KYBER_WRAPPER, expectedRateKyber);
339         }
340 
341         if ((expectedRateOasis >= expectedRateKyber) && (expectedRateOasis >= expectedRateUniswap)) {
342             return (OASIS_WRAPPER, expectedRateOasis);
343         }
344 
345         if ((expectedRateUniswap >= expectedRateKyber) && (expectedRateUniswap >= expectedRateOasis)) {
346             return (UNISWAP_WRAPPER, expectedRateUniswap);
347         }
348     }
349 
350     function getExpectedRate(address _wrapper, address _srcToken, address _destToken, uint _amount) public returns(uint) {
351         bool success;
352         bytes memory result;
353 
354         (success, result) = _wrapper.call(abi.encodeWithSignature("getExpectedRate(address,address,uint256)", _srcToken, _destToken, _amount));
355 
356         if (success) {
357             return sliceUint(result, 0);
358         } else {
359             return 0;
360         }
361     }
362 
363     
364     
365     
366     function takeFee(uint _amount, address _token) internal returns (uint feeAmount) {
367         uint fee = SERVICE_FEE;
368 
369         if (Discount(DISCOUNT_ADDRESS).isCustomFeeSet(msg.sender)) {
370             fee = Discount(DISCOUNT_ADDRESS).getCustomServiceFee(msg.sender);
371         }
372 
373         if (fee == 0) {
374             feeAmount = 0;
375         } else {
376             feeAmount = _amount / SERVICE_FEE;
377             if (_token == KYBER_ETH_ADDRESS) {
378                 WALLET_ID.transfer(feeAmount);
379             } else {
380                 ERC20(_token).transfer(WALLET_ID, feeAmount);
381             }
382         }
383     }
384 
385 
386     function getDecimals(address _token) internal view returns(uint) {
387         
388         if (_token == address(0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A)) {
389             return 9;
390         }
391         
392         if (_token == address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)) {
393             return 6;
394         }
395         
396         if (_token == address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)) {
397             return 8;
398         }
399 
400         return 18;
401     }
402 
403     function sliceUint(bytes memory bs, uint start) internal pure returns (uint) {
404         require(bs.length >= start + 32, "slicing out of range");
405 
406         uint x;
407         assembly {
408             x := mload(add(bs, add(0x20, start)))
409         }
410 
411         return x;
412     }
413 
414     
415     function() external payable {}
416 }