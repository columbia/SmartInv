1 pragma solidity ^0.4.13;
2 
3 
4 contract DSAuthority {
5     function canCall(
6         address src, address dst, bytes4 sig
7     ) public view returns (bool);
8 }
9 
10 contract DSAuthEvents {
11     event LogSetAuthority (address indexed authority);
12     event LogSetOwner     (address indexed owner);
13 }
14 
15 contract DSAuth is DSAuthEvents {
16     DSAuthority  public  authority;
17     address      public  owner;
18 
19     function DSAuth() public {
20         owner = msg.sender;
21         emit LogSetOwner(msg.sender);
22     }
23 
24     function setOwner(address owner_)
25         public
26         auth
27     {
28         owner = owner_;
29         emit LogSetOwner(owner);
30     }
31 
32     function setAuthority(DSAuthority authority_)
33         public
34         auth
35     {
36         authority = authority_;
37         emit LogSetAuthority(authority);
38     }
39 
40     modifier auth {
41         require(isAuthorized(msg.sender, msg.sig));
42         _;
43     }
44 
45     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
46         if (src == address(this)) {
47             return true;
48         } else if (src == owner) {
49             return true;
50         } else if (authority == DSAuthority(0)) {
51             return false;
52         } else {
53             return authority.canCall(src, this, sig);
54         }
55     }
56 }
57 
58 
59 contract DSNote {
60     event LogNote(
61         bytes4   indexed  sig,
62         address  indexed  guy,
63         bytes32  indexed  foo,
64         bytes32  indexed  bar,
65         uint              wad,
66         bytes             fax
67     ) anonymous;
68 
69     modifier note {
70         bytes32 foo;
71         bytes32 bar;
72 
73         assembly {
74             foo := calldataload(4)
75             bar := calldataload(36)
76         }
77 
78         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
79 
80         _;
81     }
82 }
83 
84 
85 contract DSStop is DSNote, DSAuth {
86 
87     bool public stopped;
88 
89     modifier stoppable {
90         require(!stopped);
91         _;
92     }
93     function stop() public auth note {
94         stopped = true;
95     }
96     function start() public auth note {
97         stopped = false;
98     }
99 
100 }
101 
102 
103 contract ERC20Events {
104     event Approval(address indexed src, address indexed guy, uint wad);
105     event Transfer(address indexed src, address indexed dst, uint wad);
106 }
107 
108 contract ERC20 is ERC20Events {
109     function totalSupply() public view returns (uint);
110     function balanceOf(address guy) public view returns (uint);
111     function allowance(address src, address guy) public view returns (uint);
112 
113     function approve(address guy, uint wad) public returns (bool);
114     function transfer(address dst, uint wad) public returns (bool);
115     function transferFrom(
116         address src, address dst, uint wad
117     ) public returns (bool);
118 }
119 
120 
121 contract DSMath {
122     function add(uint x, uint y) internal pure returns (uint z) {
123         require((z = x + y) >= x);
124     }
125     function sub(uint x, uint y) internal pure returns (uint z) {
126         require((z = x - y) <= x);
127     }
128     function mul(uint x, uint y) internal pure returns (uint z) {
129         require(y == 0 || (z = x * y) / y == x);
130     }
131 
132     function min(uint x, uint y) internal pure returns (uint z) {
133         return x <= y ? x : y;
134     }
135     function max(uint x, uint y) internal pure returns (uint z) {
136         return x >= y ? x : y;
137     }
138     function imin(int x, int y) internal pure returns (int z) {
139         return x <= y ? x : y;
140     }
141     function imax(int x, int y) internal pure returns (int z) {
142         return x >= y ? x : y;
143     }
144 
145     uint constant WAD = 10 ** 18;
146     uint constant RAY = 10 ** 27;
147 
148     function wmul(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, y), WAD / 2) / WAD;
150     }
151     function rmul(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, y), RAY / 2) / RAY;
153     }
154     function wdiv(uint x, uint y) internal pure returns (uint z) {
155         z = add(mul(x, WAD), y / 2) / y;
156     }
157     function rdiv(uint x, uint y) internal pure returns (uint z) {
158         z = add(mul(x, RAY), y / 2) / y;
159     }
160 
161     // This famous algorithm is called "exponentiation by squaring"
162     // and calculates x^n with x as fixed-point and n as regular unsigned.
163     //
164     // It's O(log n), instead of O(n) for naive repeated multiplication.
165     //
166     // These facts are why it works:
167     //
168     //  If n is even, then x^n = (x^2)^(n/2).
169     //  If n is odd,  then x^n = x * x^(n-1),
170     //   and applying the equation for even x gives
171     //    x^n = x * (x^2)^((n-1) / 2).
172     //
173     //  Also, EVM division is flooring and
174     //    floor[(n-1) / 2] = floor[n / 2].
175     //
176     function rpow(uint x, uint n) internal pure returns (uint z) {
177         z = n % 2 != 0 ? x : RAY;
178 
179         for (n /= 2; n != 0; n /= 2) {
180             x = rmul(x, x);
181 
182             if (n % 2 != 0) {
183                 z = rmul(z, x);
184             }
185         }
186     }
187 }
188 
189 
190 contract DSTokenBase is ERC20, DSMath {
191     uint256                                            _supply;
192     mapping (address => uint256)                       _balances;
193     mapping (address => mapping (address => uint256))  _approvals;
194 
195     function DSTokenBase(uint supply) public {
196         _balances[msg.sender] = supply;
197         _supply = supply;
198     }
199 
200     function totalSupply() public view returns (uint) {
201         return _supply;
202     }
203     function balanceOf(address src) public view returns (uint) {
204         return _balances[src];
205     }
206     function allowance(address src, address guy) public view returns (uint) {
207         return _approvals[src][guy];
208     }
209 
210     function transfer(address dst, uint wad) public returns (bool) {
211         return transferFrom(msg.sender, dst, wad);
212     }
213 
214     function transferFrom(address src, address dst, uint wad)
215         public
216         returns (bool)
217     {
218         if (src != msg.sender) {
219             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
220         }
221 
222         _balances[src] = sub(_balances[src], wad);
223         _balances[dst] = add(_balances[dst], wad);
224 
225         emit Transfer(src, dst, wad);
226 
227         return true;
228     }
229 
230     function approve(address guy, uint wad) public returns (bool) {
231         _approvals[msg.sender][guy] = wad;
232 
233         emit Approval(msg.sender, guy, wad);
234 
235         return true;
236     }
237 }
238 
239 
240 contract DSToken is DSTokenBase(0), DSStop {
241 
242     string  public  symbol = "";
243     string   public  name = "";
244     uint256  public  decimals = 18; // standard token precision. override to customize
245 
246     function DSToken(
247         string symbol_,
248         string name_
249     ) public {
250         symbol = symbol_;
251         name = name_;
252     }
253 
254     event Mint(address indexed guy, uint wad);
255     event Burn(address indexed guy, uint wad);
256 
257     function setName(string name_) public auth {
258         name = name_;
259     }
260 
261     function approve(address guy) public stoppable returns (bool) {
262         return super.approve(guy, uint(-1));
263     }
264 
265     function approve(address guy, uint wad) public stoppable returns (bool) {
266         return super.approve(guy, wad);
267     }
268 
269     function transferFrom(address src, address dst, uint wad)
270         public
271         stoppable
272         returns (bool)
273     {
274         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
275             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
276         }
277 
278         _balances[src] = sub(_balances[src], wad);
279         _balances[dst] = add(_balances[dst], wad);
280 
281         emit Transfer(src, dst, wad);
282 
283         return true;
284     }
285 
286     function push(address dst, uint wad) public {
287         transferFrom(msg.sender, dst, wad);
288     }
289     function pull(address src, uint wad) public {
290         transferFrom(src, msg.sender, wad);
291     }
292     function move(address src, address dst, uint wad) public {
293         transferFrom(src, dst, wad);
294     }
295 
296     function mint(uint wad) public {
297         mint(msg.sender, wad);
298     }
299     function burn(uint wad) public {
300         burn(msg.sender, wad);
301     }
302     function mint(address guy, uint wad) public auth stoppable {
303         _balances[guy] = add(_balances[guy], wad);
304         _supply = add(_supply, wad);
305         emit Mint(guy, wad);
306     }
307     function burn(address guy, uint wad) public auth stoppable {
308         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
309             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
310         }
311 
312         _balances[guy] = sub(_balances[guy], wad);
313         _supply = sub(_supply, wad);
314         emit Burn(guy, wad);
315     }
316 }
317 
318 
319 //==============================
320 // 使用说明
321 //1.发布DSToken合约
322 //
323 //2.发布TICDist代币操作合约
324 //
325 //3.钱包里面，DSToken绑定操作合约合约
326 //
327 //4.设置参数
328 //
329 // setDistConfig 创始人参数说明
330 //["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c","0xCc1696E57E2Cd0dCd61164eE884B4994EA3B916A","0x9bD5DB3059186FA8eeAD8e4275a2DA50F0380528"] //有3个创始人
331 //[51,15,34] //各自分配比例51%，15%，34%
332 // setLockedConfig 锁仓参数说明
333 //["0xc94cd681477e6a70a4797a9Cbaa9F1E52366823c"] //只有第一个创始人锁仓
334 //[50]	// 第一个人自己的份额，锁仓50%
335 //[10]	// 锁仓截至时间为，开始发行后的10天
336 //
337 //5.开始发行 startDist
338 //==============================
339 
340 //===============================
341 // TIC代币 操作合约
342 //===============================
343 contract TICDist is DSAuth, DSMath {
344 
345     DSToken  public  TIC;                   // TIC代币对象
346     uint256  public  initSupply = 0;        // 初始化发行供应量
347     uint256  public  decimals = 18;         // 代币精度，默认小数点后18位，不建议修改
348 
349     // 发行相关
350     uint public distDay = 0;                // 发行 开始时间
351     bool public isDistConfig = false;       // 是否配置过发行标志
352     bool public isLockedConfig = false;     // 是否配置过锁仓标志
353     
354     bool public bTest = true;               // 锁仓的情况下，每天释放1%，做演示用
355     uint public testUnlockedDay = 0;        // 测试解锁的时间
356     
357     struct Detail {  
358         uint distPercent;   // 发行时，创始人的分配比例
359         uint lockedPercent; // 发行时，创始人的锁仓比例
360         uint lockedDay;     // 发行时，创始人的锁仓时间
361         uint256 lockedToken;   // 发行时，创始人的被锁仓代币
362     }
363 
364     address[] public founderList;                 // 创始人列表
365     mapping (address => Detail)  public  founders;// 发行时，创始人的分配比例
366     
367     // 默认构造
368     function TICDist(uint256 initial_supply) public {
369         initSupply = initial_supply;
370     }
371 
372     // 此操作合约，绑定代币接口, 注意，一开始代币创建，代币都在发行者账号里面
373     // @param  {DSToken} tic 代币对象
374     function setTIC(DSToken  tic) public auth {
375         // 判断之前没有绑定过
376         assert(address(TIC) == address(0));
377         // 本操作合约有代币所有权
378         assert(tic.owner() == address(this));
379         // 总发行量不能为0
380         assert(tic.totalSupply() == 0);
381         // 赋值
382         TIC = tic;
383         // 初始化代币总量，并把代币总量存到合约账号里面
384         initSupply = initSupply*10**uint256(decimals);
385         TIC.mint(initSupply);
386     }
387 
388     // 设置发行参数
389     // @param  {address[]nt} founders_ 创始人列表
390     // @param  {uint[]} percents_ 创始人分配比例，总和必须小于100
391     function setDistConfig(address[] founders_, uint[] percents_) public auth {
392         // 判断是否配置过
393         assert(isDistConfig == false);
394         // 输入参数测试
395         assert(founders_.length > 0);
396         assert(founders_.length == percents_.length);
397         uint all_percents = 0;
398         uint i = 0;
399         for (i=0; i<percents_.length; ++i){
400             assert(percents_[i] > 0);
401             assert(founders_[i] != address(0));
402             all_percents += percents_[i];
403         }
404         assert(all_percents <= 100);
405         // 赋值
406         founderList = founders_;
407         for (i=0; i<founders_.length; ++i){
408             founders[founders_[i]].distPercent = percents_[i];
409         }
410         // 设置标志
411         isDistConfig = true;
412     }
413 
414     // 设置发行锁仓参数
415     // @param  {address[]} founders_ 创始人列表，注意，不一定要所有创始人，只有锁仓需求的才要
416     // @param  {uint[]} percents_ 对应的锁仓比例
417     // @param  {uint[]} days_ 对应的锁仓时间，这个时间是相对distDay，发行后的时间
418     function setLockedConfig(address[] founders_, uint[] percents_, uint[] days_) public auth {
419         // 必须先设置发行参数
420         assert(isDistConfig == true);
421         // 判断是否配置过
422         assert(isLockedConfig == false);
423         // 判断是否有值
424         if (founders_.length > 0){
425             // 输入参数测试
426             assert(founders_.length == percents_.length);
427             assert(founders_.length == days_.length);
428             uint i = 0;
429             for (i=0; i<percents_.length; ++i){
430                 assert(percents_[i] > 0);
431                 assert(percents_[i] <= 100);
432                 assert(days_[i] > 0);
433                 assert(founders_[i] != address(0));
434             }
435             // 赋值
436             for (i=0; i<founders_.length; ++i){
437                 founders[founders_[i]].lockedPercent = percents_[i];
438                 founders[founders_[i]].lockedDay = days_[i];
439             }
440         }
441         // 设置标志
442         isLockedConfig = true;
443     }
444 
445     // 开始发行
446     function startDist() public auth {
447         // 必须还没发行过
448         assert(distDay == 0);
449         // 判断必须配置过
450         assert(isDistConfig == true);
451         assert(isLockedConfig == true);
452         // 对每个创始人代币初始化
453         uint i = 0;
454         for(i=0; i<founderList.length; ++i){
455             // 获得创始人的份额
456             uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;
457             assert(all_token_num > 0);
458             // 获得锁仓的份额
459             uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;
460             // 记录锁仓的token
461             founders[founderList[i]].lockedToken = locked_token_num;
462             // 发放token给创始人
463             TIC.push(founderList[i], all_token_num - locked_token_num);
464         }
465         // 设置发行时间
466         distDay = today();
467         // 更新锁仓时间
468         for(i=0; i<founderList.length; ++i){
469             if (founders[founderList[i]].lockedDay != 0){
470                 founders[founderList[i]].lockedDay += distDay;
471             }
472         }
473     }
474 
475     // 确认锁仓时间是否到了，结束锁仓
476     function checkLockedToken() public {
477         // 必须发行过
478         assert(distDay != 0);
479         // 是否是测试
480         if (bTest){
481             // 判断今天解锁过了没有
482             assert(today() > testUnlockedDay);
483             // 每次固定解锁1%
484             uint unlock_percent = 1;
485             // 给锁仓的每个人，做解锁动作 TODO
486             uint i = 0;
487             for(i=0; i<founderList.length; ++i){
488                 // 有锁仓需求的创始人 并且 有锁仓代币
489                 if (founders[founderList[i]].lockedDay > 0 && founders[founderList[i]].lockedToken > 0){
490                     // 获得总的代币
491                     uint256 all_token_num = TIC.totalSupply()*founders[founderList[i]].distPercent/100;
492                     // 获得锁仓的份额
493                     uint256 locked_token_num = all_token_num*founders[founderList[i]].lockedPercent/100;
494                     // 每天释放的量
495                     uint256 unlock_token_num = locked_token_num*unlock_percent/founders[founderList[i]].lockedPercent;
496                     if (unlock_token_num > founders[founderList[i]].lockedToken){
497                         unlock_token_num = founders[founderList[i]].lockedToken;
498                     }
499                     // 开始解锁 token
500                     TIC.push(founderList[i], unlock_token_num);
501                     // 锁仓token数据减少
502                     founders[founderList[i]].lockedToken -= unlock_token_num;
503                 }
504             }
505             // 刷新解锁时间
506             testUnlockedDay = today();            
507         } else {
508             // 有锁仓需求的创始人
509             assert(founders[msg.sender].lockedDay > 0);
510             // 有锁仓代币
511             assert(founders[msg.sender].lockedToken > 0);
512             // 判断是否解锁时间到
513             assert(today() > founders[msg.sender].lockedDay);
514             // 开始解锁 token
515             TIC.push(msg.sender, founders[msg.sender].lockedToken);
516             // 锁仓token数据清空
517             founders[msg.sender].lockedToken = 0;
518         }
519     }
520 
521     // 获得当前时间 单位天
522     function today() public constant returns (uint) {
523         return time() / 24 hours;
524         // TODO test
525         //return time() / 1 minutes;
526     }
527    
528     // 获得区块链时间戳，单位秒
529     function time() public constant returns (uint) {
530         return block.timestamp;
531     }
532 }