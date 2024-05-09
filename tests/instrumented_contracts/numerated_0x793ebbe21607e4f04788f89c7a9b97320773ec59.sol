1 pragma solidity ^0.4.16;
2 
3 contract DSMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     // This famous algorithm is called "exponentiation by squaring"
44     // and calculates x^n with x as fixed-point and n as regular unsigned.
45     //
46     // It's O(log n), instead of O(n) for naive repeated multiplication.
47     //
48     // These facts are why it works:
49     //
50     //  If n is even, then x^n = (x^2)^(n/2).
51     //  If n is odd,  then x^n = x * x^(n-1),
52     //   and applying the equation for even x gives
53     //    x^n = x * (x^2)^((n-1) / 2).
54     //
55     //  Also, EVM division is flooring and
56     //    floor[(n-1) / 2] = floor[n / 2].
57     //
58     function rpow(uint x, uint n) internal pure returns (uint z) {
59         z = n % 2 != 0 ? x : RAY;
60 
61         for (n /= 2; n != 0; n /= 2) {
62             x = rmul(x, x);
63 
64             if (n % 2 != 0) {
65                 z = rmul(z, x);
66             }
67         }
68     }
69 }
70 
71 contract OtcInterface {
72     function sellAllAmount(address, uint, address, uint) public returns (uint);
73     function buyAllAmount(address, uint, address, uint) public returns (uint);
74     function getPayAmount(address, address, uint) public constant returns (uint);
75 }
76 
77 contract TokenInterface {
78     function balanceOf(address) public returns (uint);
79     function allowance(address, address) public returns (uint);
80     function approve(address, uint) public;
81     function transfer(address,uint) public returns (bool);
82     function transferFrom(address, address, uint) public returns (bool);
83     function deposit() public payable;
84     function withdraw(uint) public;
85 }
86 
87 contract OasisDirectProxy is DSMath {
88     function withdrawAndSend(TokenInterface wethToken, uint wethAmt) internal {
89         wethToken.withdraw(wethAmt);
90         require(msg.sender.call.value(wethAmt)());
91     }
92 
93     function sellAllAmount(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface buyToken, uint minBuyAmt) public returns (uint buyAmt) {
94         require(payToken.transferFrom(msg.sender, this, payAmt));
95         if (payToken.allowance(this, otc) < payAmt) {
96             payToken.approve(otc, uint(-1));
97         }
98         buyAmt = otc.sellAllAmount(payToken, payAmt, buyToken, minBuyAmt);
99         require(buyToken.transfer(msg.sender, buyAmt));
100     }
101 
102     function sellAllAmountPayEth(OtcInterface otc, TokenInterface wethToken, TokenInterface buyToken, uint minBuyAmt) public payable returns (uint buyAmt) {
103         wethToken.deposit.value(msg.value)();
104         if (wethToken.allowance(this, otc) < msg.value) {
105             wethToken.approve(otc, uint(-1));
106         }
107         buyAmt = otc.sellAllAmount(wethToken, msg.value, buyToken, minBuyAmt);
108         require(buyToken.transfer(msg.sender, buyAmt));
109     }
110 
111     function sellAllAmountBuyEth(OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface wethToken, uint minBuyAmt) public returns (uint wethAmt) {
112         require(payToken.transferFrom(msg.sender, this, payAmt));
113         if (payToken.allowance(this, otc) < payAmt) {
114             payToken.approve(otc, uint(-1));
115         }
116         wethAmt = otc.sellAllAmount(payToken, payAmt, wethToken, minBuyAmt);
117         withdrawAndSend(wethToken, wethAmt);
118     }
119 
120     function buyAllAmount(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {
121         uint payAmtNow = otc.getPayAmount(payToken, buyToken, buyAmt);
122         require(payAmtNow <= maxPayAmt);
123         require(payToken.transferFrom(msg.sender, this, payAmtNow));
124         if (payToken.allowance(this, otc) < payAmtNow) {
125             payToken.approve(otc, uint(-1));
126         }
127         payAmt = otc.buyAllAmount(buyToken, buyAmt, payToken, payAmtNow);
128         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
129     }
130 
131     function buyAllAmountPayEth(OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface wethToken) public payable returns (uint wethAmt) {
132         // In this case user needs to send more ETH than a estimated value, then contract will send back the rest
133         wethToken.deposit.value(msg.value)();
134         if (wethToken.allowance(this, otc) < msg.value) {
135             wethToken.approve(otc, uint(-1));
136         }
137         wethAmt = otc.buyAllAmount(buyToken, buyAmt, wethToken, msg.value);
138         require(buyToken.transfer(msg.sender, min(buyAmt, buyToken.balanceOf(this)))); // To avoid rounding issues we check the minimum value
139         withdrawAndSend(wethToken, sub(msg.value, wethAmt));
140     }
141 
142     function buyAllAmountBuyEth(OtcInterface otc, TokenInterface wethToken, uint wethAmt, TokenInterface payToken, uint maxPayAmt) public returns (uint payAmt) {
143         uint payAmtNow = otc.getPayAmount(payToken, wethToken, wethAmt);
144         require(payAmtNow <= maxPayAmt);
145         require(payToken.transferFrom(msg.sender, this, payAmtNow));
146         if (payToken.allowance(this, otc) < payAmtNow) {
147             payToken.approve(otc, uint(-1));
148         }
149         payAmt = otc.buyAllAmount(wethToken, wethAmt, payToken, payAmtNow);
150         withdrawAndSend(wethToken, wethAmt);
151     }
152 
153     function() public payable {}
154 }
155 
156 contract DSAuthority {
157     function canCall(
158         address src, address dst, bytes4 sig
159     ) public view returns (bool);
160 }
161 
162 contract DSAuthEvents {
163     event LogSetAuthority (address indexed authority);
164     event LogSetOwner     (address indexed owner);
165 }
166 
167 contract DSAuth is DSAuthEvents {
168     DSAuthority  public  authority;
169     address      public  owner;
170 
171     function DSAuth() public {
172         owner = msg.sender;
173         LogSetOwner(msg.sender);
174     }
175 
176     function setOwner(address owner_)
177         public
178         auth
179     {
180         owner = owner_;
181         LogSetOwner(owner);
182     }
183 
184     function setAuthority(DSAuthority authority_)
185         public
186         auth
187     {
188         authority = authority_;
189         LogSetAuthority(authority);
190     }
191 
192     modifier auth {
193         require(isAuthorized(msg.sender, msg.sig));
194         _;
195     }
196 
197     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
198         if (src == address(this)) {
199             return true;
200         } else if (src == owner) {
201             return true;
202         } else if (authority == DSAuthority(0)) {
203             return false;
204         } else {
205             return authority.canCall(src, this, sig);
206         }
207     }
208 }
209 
210 contract DSNote {
211     event LogNote(
212         bytes4   indexed  sig,
213         address  indexed  guy,
214         bytes32  indexed  foo,
215         bytes32  indexed  bar,
216         uint              wad,
217         bytes             fax
218     ) anonymous;
219 
220     modifier note {
221         bytes32 foo;
222         bytes32 bar;
223 
224         assembly {
225             foo := calldataload(4)
226             bar := calldataload(36)
227         }
228 
229         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
230 
231         _;
232     }
233 }
234 
235 // DSProxy
236 // Allows code execution using a persistant identity This can be very
237 // useful to execute a sequence of atomic actions. Since the owner of
238 // the proxy can be changed, this allows for dynamic ownership models
239 // i.e. a multisig
240 contract DSProxy is DSAuth, DSNote {
241     DSProxyCache public cache;  // global cache for contracts
242 
243     function DSProxy(address _cacheAddr) public {
244         require(setCache(_cacheAddr));
245     }
246 
247     function() public payable {
248     }
249 
250     // use the proxy to execute calldata _data on contract _code
251     function execute(bytes _code, bytes _data)
252         public
253         payable
254         returns (address target, bytes32 response)
255     {
256         target = cache.read(_code);
257         if (target == 0x0) {
258             // deploy contract & store its address in cache
259             target = cache.write(_code);
260         }
261 
262         response = execute(target, _data);
263     }
264 
265     function execute(address _target, bytes _data)
266         public
267         auth
268         note
269         payable
270         returns (bytes32 response)
271     {
272         require(_target != 0x0);
273 
274         // call contract in current context
275         assembly {
276             let succeeded := delegatecall(sub(gas, 5000), _target, add(_data, 0x20), mload(_data), 0, 32)
277             response := mload(0)      // load delegatecall output
278             switch iszero(succeeded)
279             case 1 {
280                 // throw if delegatecall failed
281                 revert(0, 0)
282             }
283         }
284     }
285 
286     //set new cache
287     function setCache(address _cacheAddr)
288         public
289         auth
290         note
291         returns (bool)
292     {
293         require(_cacheAddr != 0x0);        // invalid cache address
294         cache = DSProxyCache(_cacheAddr);  // overwrite cache
295         return true;
296     }
297 }
298 
299 // DSProxyFactory
300 // This factory deploys new proxy instances through build()
301 // Deployed proxy addresses are logged
302 contract DSProxyFactory {
303     event Created(address indexed sender, address proxy, address cache);
304     mapping(address=>bool) public isProxy;
305     DSProxyCache public cache = new DSProxyCache();
306 
307     // deploys a new proxy instance
308     // sets owner of proxy to caller
309     function build() public returns (DSProxy proxy) {
310         proxy = build(msg.sender);
311     }
312 
313     // deploys a new proxy instance
314     // sets custom owner of proxy
315     function build(address owner) public returns (DSProxy proxy) {
316         proxy = new DSProxy(cache);
317         Created(owner, address(proxy), address(cache));
318         proxy.setOwner(owner);
319         isProxy[proxy] = true;
320     }
321 }
322 
323 // DSProxyCache
324 // This global cache stores addresses of contracts previously deployed
325 // by a proxy. This saves gas from repeat deployment of the same
326 // contracts and eliminates blockchain bloat.
327 
328 // By default, all proxies deployed from the same factory store
329 // contracts in the same cache. The cache a proxy instance uses can be
330 // changed.  The cache uses the sha3 hash of a contract's bytecode to
331 // lookup the address
332 contract DSProxyCache {
333     mapping(bytes32 => address) cache;
334 
335     function read(bytes _code) public view returns (address) {
336         bytes32 hash = keccak256(_code);
337         return cache[hash];
338     }
339 
340     function write(bytes _code) public returns (address target) {
341         assembly {
342             target := create(0, add(_code, 0x20), mload(_code))
343             switch iszero(extcodesize(target))
344             case 1 {
345                 // throw if contract failed to deploy
346                 revert(0, 0)
347             }
348         }
349         bytes32 hash = keccak256(_code);
350         cache[hash] = target;
351     }
352 }
353 
354 contract ProxyCreationAndExecute is OasisDirectProxy {
355     TokenInterface wethToken;
356 
357     function ProxyCreationAndExecute(address wethToken_) {
358         wethToken = TokenInterface(wethToken_);
359     }
360 
361     function createAndSellAllAmount(DSProxyFactory factory, OtcInterface otc, TokenInterface payToken, uint payAmt, TokenInterface buyToken, uint minBuyAmt) public returns (DSProxy proxy, uint buyAmt) {
362         proxy = factory.build(msg.sender);
363         buyAmt = sellAllAmount(otc, payToken, payAmt, buyToken, minBuyAmt);
364     }
365 
366     function createAndSellAllAmountPayEth(DSProxyFactory factory, OtcInterface otc, TokenInterface buyToken, uint minBuyAmt) public payable returns (DSProxy proxy, uint buyAmt) {
367         proxy = factory.build(msg.sender);
368         buyAmt = sellAllAmountPayEth(otc, wethToken, buyToken, minBuyAmt);
369     }
370 
371     function createAndSellAllAmountBuyEth(DSProxyFactory factory, OtcInterface otc, TokenInterface payToken, uint payAmt, uint minBuyAmt) public returns (DSProxy proxy, uint wethAmt) {
372         proxy = factory.build(msg.sender);
373         wethAmt = sellAllAmountBuyEth(otc, payToken, payAmt, wethToken, minBuyAmt);
374     }
375 
376     function createAndBuyAllAmount(DSProxyFactory factory, OtcInterface otc, TokenInterface buyToken, uint buyAmt, TokenInterface payToken, uint maxPayAmt) public returns (DSProxy proxy, uint payAmt) {
377         proxy = factory.build(msg.sender);
378         payAmt = buyAllAmount(otc, buyToken, buyAmt, payToken, maxPayAmt);
379     }
380 
381     function createAndBuyAllAmountPayEth(DSProxyFactory factory, OtcInterface otc, TokenInterface buyToken, uint buyAmt) public payable returns (DSProxy proxy, uint wethAmt) {
382         proxy = factory.build(msg.sender);
383         wethAmt = buyAllAmountPayEth(otc, buyToken, buyAmt, wethToken);
384     }
385 
386     function createAndBuyAllAmountBuyEth(DSProxyFactory factory, OtcInterface otc, uint wethAmt, TokenInterface payToken, uint maxPayAmt) public returns (DSProxy proxy, uint payAmt) {
387         proxy = factory.build(msg.sender);
388         payAmt = buyAllAmountBuyEth(otc, wethToken, wethAmt, payToken, maxPayAmt);
389     }
390 
391     function() public payable {
392         require(msg.sender == address(wethToken));
393     }
394 }