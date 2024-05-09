1 pragma solidity ^0.4.24;
2 pragma experimental "v0.5.0";
3 pragma experimental ABIEncoderV2;
4 
5 contract ERC20 {
6   function balanceOf (address owner) public view returns (uint256);
7   function allowance (address owner, address spender) public view returns (uint256);
8   function transfer (address to, uint256 value) public returns (bool);
9   function transferFrom (address from, address to, uint256 value) public returns (bool);
10   function approve (address spender, uint256 value) public returns (bool);
11 }
12 
13 contract SalesPool {
14   using Math for uint256;
15 
16   address public owner;
17 
18   ERC20         public smartToken;
19   Math.Fraction public tokenPrice;
20 
21   uint256 public pipeIndex = 1;
22   mapping (uint256 => SalesPipe) public indexToPipe;
23   mapping (address => uint256)   public pipeToIndex;
24 
25   struct Commission {
26     uint256 gt;
27     uint256 lte;
28     uint256 pa;
29   }
30 
31   struct Commissions {
32     Commission[] array;
33     uint256      length;
34   }
35 
36   uint256 termsIndex = 1;
37   mapping (uint256 => Commissions) public terms;
38 
39   event CreateSalesPipe(address salesPipe);
40 
41   constructor (
42     address _smartTokenAddress,
43     uint256 _priceNumerator,
44     uint256 _priceDenominator
45   ) public {
46     owner      = msg.sender;
47     smartToken = ERC20(_smartTokenAddress);
48 
49     tokenPrice.numerator   = _priceNumerator;
50     tokenPrice.denominator = _priceDenominator;
51 
52     uint256 maxUint256 =
53       115792089237316195423570985008687907853269984665640564039457584007913129639935;
54 
55     terms[1].array.push(Commission(0 ether, 2000 ether, 5));
56     terms[1].array.push(Commission(2000 ether, 10000 ether, 8));
57     terms[1].array.push(Commission(10000 ether, maxUint256, 10));
58     terms[1].length = terms[1].array.length;
59 
60     terms[2].array.push(Commission(0 ether, maxUint256, 5));
61     terms[2].length = terms[2].array.length;
62 
63     terms[3].array.push(Commission(0 ether, maxUint256, 15));
64     terms[3].length = terms[3].array.length;
65 
66     termsIndex = 4;
67   }
68 
69   function pushTerms (Commission[] _array) public {
70     require(msg.sender == owner);
71 
72     for (uint256 i = 0; i < _array.length; i++) {
73       terms[termsIndex].array.push(Commission(_array[i].gt, _array[i].lte, _array[i].pa));
74     }
75 
76     terms[termsIndex].length = terms[termsIndex].array.length;
77 
78     termsIndex++;
79   }
80 
81   function createPipe (
82     uint256 _termsNumber,
83     uint256 _allowance,
84     bytes32 _secretHash
85   ) public {
86     require(msg.sender == owner);
87 
88     SalesPipe pipe = new SalesPipe(owner, _termsNumber, smartToken, _secretHash);
89 
90     address pipeAddress = address(pipe);
91 
92     smartToken.approve(pipeAddress, _allowance);
93 
94     indexToPipe[pipeIndex]   = pipe;
95     pipeToIndex[pipeAddress] = pipeIndex;
96     pipeIndex++;
97 
98     emit CreateSalesPipe(pipeAddress);
99   }
100 
101   function setSalesPipeAllowance (address _pipeAddress, uint256 _value) public {
102     require(msg.sender == owner);
103     smartToken.approve(_pipeAddress, _value);
104   }
105 
106   function poolTokenAmount () public view returns (uint256) {
107     return smartToken.balanceOf(address(this));
108   }
109 
110   function transferEther(address _to, uint256 _value) public {
111     require(msg.sender == owner);
112     _to.transfer(_value);
113   }
114 
115   function transferToken(ERC20 erc20, address _to, uint256 _value) public {
116     require(msg.sender == owner);
117     erc20.transfer(_to, _value);
118   }
119 
120   function setOwner (address _owner) public {
121     require(msg.sender == owner);
122     owner = _owner;
123   }
124 
125   function setSmartToken(address _smartTokenAddress) public {
126     require(msg.sender == owner);
127     smartToken = ERC20(_smartTokenAddress);
128   }
129 
130   function setTokenPrice(uint256 numerator, uint256 denominator) public {
131     require(msg.sender == owner);
132     require(
133       numerator   > 0 &&
134       denominator > 0
135     );
136 
137     tokenPrice.numerator   = numerator;
138     tokenPrice.denominator = denominator;
139   }
140 
141   function getTokenPrice () public view returns (uint256, uint256) {
142     return (tokenPrice.numerator, tokenPrice.denominator);
143   }
144 
145   function getCommissions (uint256 _termsNumber) public view returns (Commissions) {
146     return terms[_termsNumber];
147   }
148   
149   function () payable external {}
150 
151 }
152 
153 contract SalesPipe {
154   using Math for uint256;
155 
156   SalesPool public pool;
157   address   public owner;
158 
159   uint256 public termsNumber;
160 
161   ERC20 public smartToken;
162 
163   address public rf = address(0);
164   bytes32 public secretHash;
165 
166   bool public available = true;
167   bool public finalized = false;
168 
169   uint256 public totalEtherReceived = 0;
170 
171   event TokenPurchase(
172     ERC20 indexed smartToken,
173     address indexed buyer,
174     address indexed receiver,
175     uint256 value,
176     uint256 amount
177   );
178 
179   event RFDeclare (address rf);
180   event Finalize  (uint256 fstkRevenue, uint256 rfReceived);
181 
182   constructor (
183     address _owner,
184     uint256 _termsNumber,
185     ERC20   _smartToken,
186     bytes32 _secretHash
187   ) public {
188     pool  = SalesPool(msg.sender);
189     owner = _owner;
190 
191     termsNumber = _termsNumber;
192     smartToken  = _smartToken;
193 
194     secretHash = _secretHash;
195   }
196 
197   function () external payable {
198     Math.Fraction memory tokenPrice;
199     (tokenPrice.numerator, tokenPrice.denominator) = pool.getTokenPrice();
200 
201     address poolAddress = address(pool);
202 
203     uint256 availableAmount =
204       Math.min(
205         smartToken.allowance(poolAddress, address(this)),
206         smartToken.balanceOf(poolAddress)
207       );
208     uint256 revenue;
209     uint256 purchaseAmount = msg.value.div(tokenPrice);
210 
211     require(
212       available &&
213       finalized == false &&
214       availableAmount > 0 &&
215       purchaseAmount  > 0
216     );
217 
218     if (availableAmount >= purchaseAmount) {
219       revenue = msg.value;
220 
221       if (availableAmount == purchaseAmount) {
222         available = false;
223       }
224     } else {
225       purchaseAmount = availableAmount;
226       revenue = availableAmount.mulCeil(tokenPrice);
227       available = false;
228 
229       msg.sender.transfer(msg.value - revenue);
230     }
231 
232     smartToken.transferFrom(poolAddress, msg.sender, purchaseAmount);
233 
234     emit TokenPurchase(smartToken, msg.sender, msg.sender, revenue, purchaseAmount);
235 
236     totalEtherReceived += revenue;
237   }
238 
239   function declareRF(string _secret) public {
240     require(
241       secretHash == keccak256(abi.encodePacked(_secret)) &&
242       rf         == address(0)
243     );
244 
245     rf = msg.sender;
246 
247     emit RFDeclare(rf);
248   }
249 
250   function finalize () public {
251     require(
252       msg.sender == owner &&
253       available  == false &&
254       finalized  == false &&
255       rf         != address(0)
256     );
257 
258     finalized = true;
259 
260     address poolAddress = address(pool);
261 
262     uint256 rfEther   = calculateCommission(address(this).balance, termsNumber);
263     uint256 fstkEther = address(this).balance - rfEther;
264 
265     rf.transfer(rfEther);
266     poolAddress.transfer(fstkEther);
267 
268     emit Finalize(fstkEther, rfEther);
269   }
270 
271   function calculateCommission (
272     uint256 _totalReceivedEther,
273     uint256 _termsNumber
274   ) public view returns (uint256) {
275     SalesPool.Commissions memory commissions = pool.getCommissions(_termsNumber);
276 
277     for (uint256 i = 0; i < commissions.length; i++) {
278       SalesPool.Commission memory commission = commissions.array[i];
279       if (_totalReceivedEther > commission.gt && _totalReceivedEther <= commission.lte) {
280         return _totalReceivedEther * commission.pa / 100;
281       }
282     }
283 
284     return 0;
285   }
286 
287   function setOwner (address _owner) public {
288     require(msg.sender == owner);
289     owner = _owner;
290   }
291 
292   function setTermsNumber (uint256 _termsNumber) public {
293     require(msg.sender == owner);
294     termsNumber = _termsNumber;
295   }
296 
297   function setAvailability (bool _available) public {
298     require(msg.sender == owner);
299     available = _available;
300   }
301 
302 }
303 
304 library Math {
305 
306   struct Fraction {
307     uint256 numerator;
308     uint256 denominator;
309   }
310 
311   function isPositive(Fraction memory fraction) internal pure returns (bool) {
312     return fraction.numerator > 0 && fraction.denominator > 0;
313   }
314 
315   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
316     r = a * b;
317     require((a == 0) || (r / a == b));
318   }
319 
320   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
321     r = a / b;
322   }
323 
324   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
325     require((r = a - b) <= a);
326   }
327 
328   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
329     require((r = a + b) >= a);
330   }
331 
332   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
333     return x <= y ? x : y;
334   }
335 
336   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
337     return x >= y ? x : y;
338   }
339 
340   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
341     // try mul
342     r = value * m;
343     if (r / value == m) {
344       // if mul not overflow
345       r /= d;
346     } else {
347       // else div first
348       r = mul(value / d, m);
349     }
350   }
351 
352   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
353     // try mul
354     r = value * m;
355     if (r / value == m) {
356       // mul not overflow
357       if (r % d == 0) {
358         r /= d;
359       } else {
360         r = (r / d) + 1;
361       }
362     } else {
363       // mul overflow then div first
364       r = mul(value / d, m);
365       if (value % d != 0) {
366         r += 1;
367       }
368     }
369   }
370 
371   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
372     return mulDiv(x, f.numerator, f.denominator);
373   }
374 
375   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
376     return mulDivCeil(x, f.numerator, f.denominator);
377   }
378 
379   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
380     return mulDiv(x, f.denominator, f.numerator);
381   }
382 
383   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
384     return mulDivCeil(x, f.denominator, f.numerator);
385   }
386 
387   function mul(Fraction memory x, Fraction memory y) internal pure returns (Math.Fraction) {
388     return Math.Fraction({
389       numerator: mul(x.numerator, y.numerator),
390       denominator: mul(x.denominator, y.denominator)
391     });
392   }
393 }