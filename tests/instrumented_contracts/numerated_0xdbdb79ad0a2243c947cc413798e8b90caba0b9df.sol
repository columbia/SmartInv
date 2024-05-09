1 pragma solidity ^0.4.13;
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
71 contract DSAuthority {
72     function canCall(
73         address src, address dst, bytes4 sig
74     ) public view returns (bool);
75 }
76 
77 contract DSAuthEvents {
78     event LogSetAuthority (address indexed authority);
79     event LogSetOwner     (address indexed owner);
80 }
81 
82 contract DSAuth is DSAuthEvents {
83     DSAuthority  public  authority;
84     address      public  owner;
85 
86     function DSAuth() public {
87         owner = msg.sender;
88         LogSetOwner(msg.sender);
89     }
90 
91     function setOwner(address owner_)
92         public
93         auth
94     {
95         owner = owner_;
96         LogSetOwner(owner);
97     }
98 
99     function setAuthority(DSAuthority authority_)
100         public
101         auth
102     {
103         authority = authority_;
104         LogSetAuthority(authority);
105     }
106 
107     modifier auth {
108         require(isAuthorized(msg.sender, msg.sig));
109         _;
110     }
111 
112     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
113         if (src == address(this)) {
114             return true;
115         } else if (src == owner) {
116             return true;
117         } else if (authority == DSAuthority(0)) {
118             return false;
119         } else {
120             return authority.canCall(src, this, sig);
121         }
122     }
123 }
124 
125 contract DSNote {
126     event LogNote(
127         bytes4   indexed  sig,
128         address  indexed  guy,
129         bytes32  indexed  foo,
130         bytes32  indexed  bar,
131         uint              wad,
132         bytes             fax
133     ) anonymous;
134 
135     modifier note {
136         bytes32 foo;
137         bytes32 bar;
138 
139         assembly {
140             foo := calldataload(4)
141             bar := calldataload(36)
142         }
143 
144         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
145 
146         _;
147     }
148 }
149 
150 contract DSStop is DSNote, DSAuth {
151 
152     bool public stopped;
153 
154     modifier stoppable {
155         require(!stopped);
156         _;
157     }
158     function stop() public auth note {
159         stopped = true;
160     }
161     function start() public auth note {
162         stopped = false;
163     }
164 
165 }
166 
167 contract ERC20 {
168     function totalSupply() public view returns (uint supply);
169     function balanceOf( address who ) public view returns (uint value);
170     function allowance( address owner, address spender ) public view returns (uint _allowance);
171 
172     function transfer( address to, uint value) public returns (bool ok);
173     function transferFrom( address from, address to, uint value) public returns (bool ok);
174     function approve( address spender, uint value ) public returns (bool ok);
175 
176     event Transfer( address indexed from, address indexed to, uint value);
177     event Approval( address indexed owner, address indexed spender, uint value);
178 }
179 
180 contract DSTokenBase is ERC20, DSMath {
181     uint256                                            _supply;
182     mapping (address => uint256)                       _balances;
183     mapping (address => mapping (address => uint256))  _approvals;
184 
185     function DSTokenBase(uint supply) public {
186         _balances[msg.sender] = supply;
187         _supply = supply;
188     }
189 
190     function totalSupply() public view returns (uint) {
191         return _supply;
192     }
193     function balanceOf(address src) public view returns (uint) {
194         return _balances[src];
195     }
196     function allowance(address src, address guy) public view returns (uint) {
197         return _approvals[src][guy];
198     }
199 
200     function transfer(address dst, uint wad) public returns (bool) {
201         return transferFrom(msg.sender, dst, wad);
202     }
203 
204     function transferFrom(address src, address dst, uint wad)
205         public
206         returns (bool)
207     {
208         if (src != msg.sender) {
209             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
210         }
211 
212         _balances[src] = sub(_balances[src], wad);
213         _balances[dst] = add(_balances[dst], wad);
214 
215         Transfer(src, dst, wad);
216 
217         return true;
218     }
219 
220     function approve(address guy, uint wad) public returns (bool) {
221         _approvals[msg.sender][guy] = wad;
222 
223         Approval(msg.sender, guy, wad);
224 
225         return true;
226     }
227 }
228 
229 contract DSToken is DSTokenBase(0), DSStop {
230 
231     mapping (address => mapping (address => bool)) _trusted;
232 
233     bytes32  public  symbol;
234     uint256  public  decimals = 18; // standard token precision. override to customize
235 
236     function DSToken(bytes32 symbol_) public {
237         symbol = symbol_;
238     }
239 
240     event Trust(address indexed src, address indexed guy, bool wat);
241     event Mint(address indexed guy, uint wad);
242     event Burn(address indexed guy, uint wad);
243 
244     function trusted(address src, address guy) public view returns (bool) {
245         return _trusted[src][guy];
246     }
247     function trust(address guy, bool wat) public stoppable {
248         _trusted[msg.sender][guy] = wat;
249         Trust(msg.sender, guy, wat);
250     }
251 
252     function approve(address guy, uint wad) public stoppable returns (bool) {
253         return super.approve(guy, wad);
254     }
255     function transferFrom(address src, address dst, uint wad)
256         public
257         stoppable
258         returns (bool)
259     {
260         if (src != msg.sender && !_trusted[src][msg.sender]) {
261             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
262         }
263 
264         _balances[src] = sub(_balances[src], wad);
265         _balances[dst] = add(_balances[dst], wad);
266 
267         Transfer(src, dst, wad);
268 
269         return true;
270     }
271 
272     function push(address dst, uint wad) public {
273         transferFrom(msg.sender, dst, wad);
274     }
275     function pull(address src, uint wad) public {
276         transferFrom(src, msg.sender, wad);
277     }
278     function move(address src, address dst, uint wad) public {
279         transferFrom(src, dst, wad);
280     }
281 
282     function mint(uint wad) public {
283         mint(msg.sender, wad);
284     }
285     function burn(uint wad) public {
286         burn(msg.sender, wad);
287     }
288     function mint(address guy, uint wad) public auth stoppable {
289         _balances[guy] = add(_balances[guy], wad);
290         _supply = add(_supply, wad);
291         Mint(guy, wad);
292     }
293     function burn(address guy, uint wad) public auth stoppable {
294         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
295             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
296         }
297 
298         _balances[guy] = sub(_balances[guy], wad);
299         _supply = sub(_supply, wad);
300         Burn(guy, wad);
301     }
302 
303     // Optional token name
304     bytes32   public  name = "";
305 
306     function setName(bytes32 name_) public auth {
307         name = name_;
308     }
309 }
310 
311 contract ViewlySeedSale is DSAuth, DSMath {
312 
313     uint constant public MAX_FUNDING =        4000 ether;  // max funding hard-cap
314     uint constant public MIN_FUNDING =        1000 ether;  // min funding requirement
315     uint constant public MAX_TOKENS = 10 * 1000000 ether;  // token hard-cap
316     uint constant public BONUS =              0.15 ether;  // bonus of tokens early buyers
317                                                            // get over last buyers
318 
319     DSToken public viewToken;         // VIEW token contract
320     address public beneficiary;       // destination to collect eth deposits
321     uint public startBlock;           // start block of sale
322     uint public endBlock;             // end block of sale
323 
324     uint public totalEthDeposited;    // sums of ether raised
325     uint public totalTokensBought;    // total tokens issued on sale
326     uint public totalEthCollected;    // total eth collected from sale
327     uint public totalEthRefunded;     // total eth refunded after a failed sale
328 
329     // buyers ether deposits
330     mapping (address => uint) public ethDeposits;
331     // ether refunds after a failed sale
332     mapping (address => uint) public ethRefunds;
333 
334     enum State {
335         Pending,
336         Running,
337         Succeeded,
338         Failed
339     }
340     State public state = State.Pending;
341 
342     event LogBuy(
343         address buyer,
344         uint ethDeposit,
345         uint tokensBought
346     );
347 
348     event LogRefund(
349         address buyer,
350         uint ethRefund
351     );
352 
353     event LogStartSale(
354         uint startBlock,
355         uint endBlock
356     );
357 
358     event LogEndSale(
359         bool success,
360         uint totalEthDeposited,
361         uint totalTokensBought
362     );
363 
364     event LogExtendSale(
365         uint blocks
366     );
367 
368     event LogCollectEth(
369         uint ethCollected,
370         uint totalEthDeposited
371     );
372 
373     // require given state of sale
374     modifier saleIn(State state_) { require(state_ == state); _; }
375 
376     // check current block is inside closed interval [startBlock, endBlock]
377     modifier inRunningBlock() {
378         require(block.number >= startBlock);
379         require(block.number < endBlock);
380         _;
381     }
382     // check sender has sent some ethers
383     modifier ethSent() { require(msg.value > 0); _; }
384 
385 
386     // PUBLIC //
387 
388     function ViewlySeedSale(DSToken viewToken_, address beneficiary_) {
389         viewToken = viewToken_;
390         beneficiary = beneficiary_;
391     }
392 
393     function() payable {
394         buyTokens();
395     }
396 
397     function buyTokens() saleIn(State.Running) inRunningBlock ethSent payable {
398         uint tokensBought = calcTokensForPurchase(msg.value, totalEthDeposited);
399         ethDeposits[msg.sender] = add(msg.value, ethDeposits[msg.sender]);
400         totalEthDeposited = add(msg.value, totalEthDeposited);
401         totalTokensBought = add(tokensBought, totalTokensBought);
402 
403         require(totalEthDeposited <= MAX_FUNDING);
404         require(totalTokensBought <= MAX_TOKENS);
405 
406         viewToken.mint(msg.sender, tokensBought);
407 
408         LogBuy(msg.sender, msg.value, tokensBought);
409     }
410 
411     function claimRefund() saleIn(State.Failed) {
412       require(ethDeposits[msg.sender] > 0);
413       require(ethRefunds[msg.sender] == 0);
414 
415       uint ethRefund = ethDeposits[msg.sender];
416       ethRefunds[msg.sender] = ethRefund;
417       totalEthRefunded = add(ethRefund, totalEthRefunded);
418       msg.sender.transfer(ethRefund);
419 
420       LogRefund(msg.sender, ethRefund);
421     }
422 
423 
424     // AUTH REQUIRED //
425 
426     function startSale(uint duration, uint blockOffset) auth saleIn(State.Pending) {
427         require(duration > 0);
428         require(blockOffset >= 0);
429 
430         startBlock = add(block.number, blockOffset);
431         endBlock   = add(startBlock, duration);
432         state      = State.Running;
433 
434         LogStartSale(startBlock, endBlock);
435     }
436 
437     function endSale() auth saleIn(State.Running) {
438         if (totalEthDeposited >= MIN_FUNDING)
439           state = State.Succeeded;
440         else
441           state = State.Failed;
442 
443         viewToken.stop();
444         LogEndSale(state == State.Succeeded, totalEthDeposited, totalTokensBought);
445     }
446 
447     function extendSale(uint blocks) auth saleIn(State.Running) {
448         require(blocks > 0);
449 
450         endBlock = add(endBlock, blocks);
451         LogExtendSale(blocks);
452     }
453 
454     function collectEth() auth {
455         require(totalEthDeposited >= MIN_FUNDING);
456         require(this.balance > 0);
457 
458         uint ethToCollect = this.balance;
459         totalEthCollected = add(totalEthCollected, ethToCollect);
460         beneficiary.transfer(ethToCollect);
461         LogCollectEth(ethToCollect, totalEthDeposited);
462     }
463 
464 
465     // PRIVATE //
466 
467     uint constant averageTokensPerEth = wdiv(MAX_TOKENS, MAX_FUNDING);
468     uint constant endingTokensPerEth = wdiv(2 * averageTokensPerEth, 2 ether + BONUS);
469 
470     // calculate number of tokens buyer get when sending 'ethSent' ethers
471     // after 'ethDepostiedSoFar` already reeived in the sale
472     function calcTokensForPurchase(uint ethSent, uint ethDepositedSoFar)
473         private view
474         returns (uint tokens)
475     {
476         uint tokensPerEthAtStart = calcTokensPerEth(ethDepositedSoFar);
477         uint tokensPerEthAtEnd = calcTokensPerEth(add(ethDepositedSoFar, ethSent));
478         uint averageTokensPerEth = add(tokensPerEthAtStart, tokensPerEthAtEnd) / 2;
479 
480         // = ethSent * averageTokensPerEthInThisPurchase
481         return wmul(ethSent, averageTokensPerEth);
482     }
483 
484     // return tokensPerEth for 'nthEther' of total contribution (MAX_FUNDING)
485     function calcTokensPerEth(uint nthEther)
486         private view
487         returns (uint)
488     {
489         uint shareOfSale = wdiv(nthEther, MAX_FUNDING);
490         uint shareOfBonus = sub(1 ether, shareOfSale);
491         uint actualBonus = wmul(shareOfBonus, BONUS);
492 
493         // = endingTokensPerEth * (1 + shareOfBonus * BONUS)
494         return wmul(endingTokensPerEth, add(1 ether, actualBonus));
495     }
496 }