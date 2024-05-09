1 pragma solidity 0.4.18;
2 
3 //import "ds-token/token.sol";
4     //import "ds-stop/stop.sol";
5         //import "ds-auth/auth.sol";
6         //import "ds-note/note.sol";
7     //import "./base.sol";
8         //import "erc20/erc20.sol";
9         //import "ds-math/math.sol";
10 
11 //import "ds-math/math.sol";
12 contract DSMath {
13     
14     /*
15     standard uint256 functions
16      */
17 
18     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
19         assert((z = x + y) >= x);
20     }
21 
22     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x - y) <= x);
24     }
25 
26     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         z = x * y;
28         assert(x == 0 || z / x == y);
29     }
30 
31     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
32         z = x / y;
33     }
34 
35     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
36         return x <= y ? x : y;
37     }
38     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         return x >= y ? x : y;
40     }
41 
42     /*
43     uint128 functions (h is for half)
44      */
45 
46 
47     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
48         assert((z = x + y) >= x);
49     }
50 
51     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
52         assert((z = x - y) <= x);
53     }
54 
55     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
56         z = x * y;
57         assert(x == 0 || z / x == y);
58     }
59 
60     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
61         z = x / y;
62     }
63 
64     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
65         return x <= y ? x : y;
66     }
67     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
68         return x >= y ? x : y;
69     }
70 
71 
72     /*
73     int256 functions
74      */
75 
76     function imin(int256 x, int256 y) constant internal returns (int256 z) {
77         return x <= y ? x : y;
78     }
79     function imax(int256 x, int256 y) constant internal returns (int256 z) {
80         return x >= y ? x : y;
81     }
82 
83     /*
84     WAD math
85      */
86 
87     uint128 constant WAD = 10 ** 18;
88 
89     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
90         return hadd(x, y);
91     }
92 
93     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
94         return hsub(x, y);
95     }
96 
97     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
98         z = cast((uint256(x) * y + WAD / 2) / WAD);
99     }
100 
101     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
102         z = cast((uint256(x) * WAD + y / 2) / y);
103     }
104 
105     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
106         return hmin(x, y);
107     }
108     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
109         return hmax(x, y);
110     }
111 
112     /*
113     RAY math
114      */
115 
116     uint128 constant RAY = 10 ** 27;
117 
118     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
119         return hadd(x, y);
120     }
121 
122     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
123         return hsub(x, y);
124     }
125 
126     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
127         z = cast((uint256(x) * y + RAY / 2) / RAY);
128     }
129 
130     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
131         z = cast((uint256(x) * RAY + y / 2) / y);
132     }
133 
134     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
135         // This famous algorithm is called "exponentiation by squaring"
136         // and calculates x^n with x as fixed-point and n as regular unsigned.
137         //
138         // It's O(log n), instead of O(n) for naive repeated multiplication.
139         //
140         // These facts are why it works:
141         //
142         //  If n is even, then x^n = (x^2)^(n/2).
143         //  If n is odd,  then x^n = x * x^(n-1),
144         //   and applying the equation for even x gives
145         //    x^n = x * (x^2)^((n-1) / 2).
146         //
147         //  Also, EVM division is flooring and
148         //    floor[(n-1) / 2] = floor[n / 2].
149 
150         z = n % 2 != 0 ? x : RAY;
151 
152         for (n /= 2; n != 0; n /= 2) {
153             x = rmul(x, x);
154 
155             if (n % 2 != 0) {
156                 z = rmul(z, x);
157             }
158         }
159     }
160 
161     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
162         return hmin(x, y);
163     }
164     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
165         return hmax(x, y);
166     }
167 
168     function cast(uint256 x) constant internal returns (uint128 z) {
169         assert((z = uint128(x)) == x);
170     }
171 
172 }
173 
174 //import "erc20/erc20.sol";
175 contract ERC20 {
176     function totalSupply() constant returns (uint supply);
177     function balanceOf( address who ) constant returns (uint value);
178     function allowance( address owner, address spender ) constant returns (uint _allowance);
179 
180     function transfer( address to, uint value) returns (bool ok);
181     function transferFrom( address from, address to, uint value) returns (bool ok);
182     function approve( address spender, uint value ) returns (bool ok);
183 
184     event Transfer( address indexed from, address indexed to, uint value);
185     event Approval( address indexed owner, address indexed spender, uint value);
186 }
187 
188 //import "./base.sol";
189 contract DSTokenBase is ERC20, DSMath {
190     uint256                                            _supply;
191     mapping (address => uint256)                       _balances;
192     mapping (address => mapping (address => uint256))  _approvals;
193     
194     function DSTokenBase(uint256 supply) {
195         _balances[msg.sender] = supply;
196         _supply = supply;
197     }
198     
199     function totalSupply() constant returns (uint256) {
200         return _supply;
201     }
202     function balanceOf(address src) constant returns (uint256) {
203         return _balances[src];
204     }
205     function allowance(address src, address guy) constant returns (uint256) {
206         return _approvals[src][guy];
207     }
208     
209     function transfer(address dst, uint wad) returns (bool) {
210         assert(_balances[msg.sender] >= wad);
211         
212         _balances[msg.sender] = sub(_balances[msg.sender], wad);
213         _balances[dst] = add(_balances[dst], wad);
214         
215         Transfer(msg.sender, dst, wad);
216         
217         return true;
218     }
219     
220     function transferFrom(address src, address dst, uint wad) returns (bool) {
221         assert(_balances[src] >= wad);
222         assert(_approvals[src][msg.sender] >= wad);
223         
224         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
225         _balances[src] = sub(_balances[src], wad);
226         _balances[dst] = add(_balances[dst], wad);
227         
228         Transfer(src, dst, wad);
229         
230         return true;
231     }
232     
233     function approve(address guy, uint256 wad) returns (bool) {
234         _approvals[msg.sender][guy] = wad;
235         
236         Approval(msg.sender, guy, wad);
237         
238         return true;
239     }
240 
241 }
242 
243 //import "ds-auth/auth.sol";
244 contract DSAuthority {
245     function canCall(
246         address src, address dst, bytes4 sig
247     ) constant returns (bool);
248 }
249 
250 contract DSAuthEvents {
251     event LogSetAuthority (address indexed authority);
252     event LogSetOwner     (address indexed owner);
253 }
254 
255 contract DSAuth is DSAuthEvents {
256     DSAuthority  public  authority;
257     address      public  owner;
258 
259     function DSAuth() {
260         owner = msg.sender;
261         LogSetOwner(msg.sender);
262     }
263 
264     function setOwner(address owner_)
265         auth
266     {
267         owner = owner_;
268         LogSetOwner(owner);
269     }
270 
271     function setAuthority(DSAuthority authority_)
272         auth
273     {
274         authority = authority_;
275         LogSetAuthority(authority);
276     }
277 
278     modifier auth {
279         assert(isAuthorized(msg.sender, msg.sig));
280         _;
281     }
282 
283     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
284         if (src == address(this)) {
285             return true;
286         } else if (src == owner) {
287             return true;
288         } else if (authority == DSAuthority(0)) {
289             return false;
290         } else {
291             return authority.canCall(src, this, sig);
292         }
293     }
294 }
295 
296 //import "ds-note/note.sol";
297 contract DSNote {
298     event LogNote(
299         bytes4   indexed  sig,
300         address  indexed  guy,
301         bytes32  indexed  foo,
302         bytes32  indexed  bar,
303         uint              wad,
304         bytes             fax
305     ) anonymous;
306 
307     modifier note {
308         bytes32 foo;
309         bytes32 bar;
310 
311         assembly {
312             foo := calldataload(4)
313             bar := calldataload(36)
314         }
315 
316         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
317 
318         _;
319     }
320 }
321 
322 //import "ds-stop/stop.sol";
323 contract DSStop is DSNote, DSAuth {
324 
325     bool public stopped;
326 
327     modifier stoppable {
328         assert (!stopped);
329         _;
330     }
331     function stop() auth note {
332         stopped = true;
333     }
334     function start() auth note {
335         stopped = false;
336     }
337 
338 }
339 
340 
341 
342 //import "ds-token/token.sol";
343 contract DSToken is DSTokenBase(0), DSStop {
344 
345     bytes32  public  symbol;
346     uint256  public  decimals = 18; // standard token precision. override to customize
347 
348     function DSToken(bytes32 symbol_) {
349         symbol = symbol_;
350     }
351 
352     function transfer(address dst, uint wad) stoppable note returns (bool) {
353         return super.transfer(dst, wad);
354     }
355     function transferFrom(
356         address src, address dst, uint wad
357     ) stoppable note returns (bool) {
358         return super.transferFrom(src, dst, wad);
359     }
360     function approve(address guy, uint wad) stoppable note returns (bool) {
361         return super.approve(guy, wad);
362     }
363 
364     function push(address dst, uint128 wad) returns (bool) {
365         return transfer(dst, wad);
366     }
367     function pull(address src, uint128 wad) returns (bool) {
368         return transferFrom(src, msg.sender, wad);
369     }
370 
371     function mint(uint128 wad) auth stoppable note {
372         _balances[msg.sender] = add(_balances[msg.sender], wad);
373         _supply = add(_supply, wad);
374     }
375     function burn(uint128 wad) auth stoppable note {
376         _balances[msg.sender] = sub(_balances[msg.sender], wad);
377         _supply = sub(_supply, wad);
378     }
379 
380     // Optional token name
381 
382     bytes32   public  name = "";
383     
384     function setName(bytes32 name_) auth {
385         name = name_;
386     }
387 
388 }
389 
390 
391 
392 
393 contract KeyRewardPool is DSMath, DSNote{
394 
395     DSToken public key;
396     uint public rewardStartTime;
397 
398     uint constant public yearlyRewardPercentage = 10; // 10% of remaining tokens
399     uint public totalRewardThisYear;
400     uint public collectedTokens;
401     address public withdrawer;
402     address public owner;
403     bool public paused;
404 
405     event TokensWithdrawn(address indexed _holder, uint _amount);
406     event LogSetWithdrawer(address indexed _withdrawer);
407     event LogSetOwner(address indexed _owner);
408 
409     modifier onlyWithdrawer {
410         require(msg.sender == withdrawer);
411         _;
412     }
413     modifier onlyOwner {
414         require(msg.sender == owner);
415         _;
416     }
417 
418     modifier notPaused {
419         require(!paused);
420         _;
421     }
422 
423     function KeyRewardPool(uint _rewardStartTime, address _key, address _withdrawer) public{
424         require(_rewardStartTime != 0 );
425         require(_key != address(0) );
426         require(_withdrawer != address(0) );
427         uint _time = time();
428         require(_rewardStartTime > _time - 364 days);
429 
430         rewardStartTime = _rewardStartTime;
431         key = DSToken(_key);
432         withdrawer = _withdrawer;
433         owner = msg.sender;
434         paused = false;
435     }
436 
437     // @notice call this method to extract the tokens
438     function collectToken() public notPaused onlyWithdrawer{
439         uint _time = time();
440         require(_time > rewardStartTime);
441 
442         var _key = key;  // create a in memory variable for storage variable will save gas usage.
443 
444 
445         uint balance = _key.balanceOf(address(this));
446         uint total = add(collectedTokens, balance);
447 
448         uint remainingTokens = total;
449 
450         uint yearCount = yearFor(_time);
451 
452         for(uint i = 0; i < yearCount; i++) {
453             remainingTokens =  div( mul(remainingTokens, 100 - yearlyRewardPercentage), 100);
454         }
455         //
456         totalRewardThisYear =  div( mul(remainingTokens, yearlyRewardPercentage), 100);
457 
458         // the reward will be increasing linearly in one year.
459         uint canExtractThisYear = div( mul(totalRewardThisYear, (_time - rewardStartTime)  % 365 days), 365 days);
460 
461         uint canExtract = canExtractThisYear + (total - remainingTokens);
462 
463         canExtract = sub(canExtract, collectedTokens);
464 
465         if(canExtract > balance) {
466             canExtract = balance;
467         }
468 
469         
470         collectedTokens = add(collectedTokens, canExtract);
471 
472         assert(_key.transfer(withdrawer, canExtract)); // Fix potential re-entry bug.
473         TokensWithdrawn(withdrawer, canExtract);
474     }
475 
476 
477     function yearFor(uint timestamp) public constant returns(uint) {
478         return timestamp < rewardStartTime
479             ? 0
480             : sub(timestamp, rewardStartTime) / (365 days);
481     }
482 
483     // overrideable for easy testing
484     function time() public constant returns (uint) {
485         return now;
486     }
487 
488     function setWithdrawer(address _withdrawer) public onlyOwner {
489         withdrawer = _withdrawer;
490         LogSetWithdrawer(_withdrawer);
491     }
492 
493     function setOwner(address _owner) public onlyOwner {
494         owner = _owner;
495         LogSetOwner(_owner);
496     }
497 
498 
499     function pauseCollectToken() public onlyOwner {
500         paused = true;
501     }
502 
503     function resumeCollectToken() public onlyOwner {
504         paused = false;
505     }
506 
507     // @notice This method can be used by the controller to extract mistakenly
508     //  sent tokens to this contract.
509     // @param dst The address that will be receiving the tokens
510     // @param wad The amount of tokens to transfer
511     // @param _token The address of the token contract that you want to recover
512     function transferTokens(address dst, uint wad, address _token) public onlyWithdrawer {
513         require( _token != address(key));
514         if (wad > 0) {
515             ERC20 token = ERC20(_token);
516             token.transfer(dst, wad);
517         }
518     }
519 
520     
521 }