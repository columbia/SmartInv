1 pragma solidity ^0.4.14;
2 
3 contract ERC20 {
4     function totalSupply() constant returns (uint supply);
5     function balanceOf( address who ) constant returns (uint value);
6     function allowance( address owner, address spender ) constant returns (uint _allowance);
7 
8     function transfer( address to, uint value) returns (bool ok);
9     function transferFrom( address from, address to, uint value) returns (bool ok);
10     function approve( address spender, uint value ) returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSMath {
17     
18     /*
19     standard uint256 functions
20      */
21 
22     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
23         assert((z = x + y) >= x);
24     }
25 
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29 
30     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
31         assert((z = x * y) >= x);
32     }
33 
34     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
35         z = x / y;
36     }
37 
38     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         return x <= y ? x : y;
40     }
41     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         return x >= y ? x : y;
43     }
44 
45     /*
46     uint128 functions (h is for half)
47      */
48 
49 
50     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
51         assert((z = x + y) >= x);
52     }
53 
54     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
55         assert((z = x - y) <= x);
56     }
57 
58     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
59         assert((z = x * y) >= x);
60     }
61 
62     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
63         z = x / y;
64     }
65 
66     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
67         return x <= y ? x : y;
68     }
69     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
70         return x >= y ? x : y;
71     }
72 
73 
74     /*
75     int256 functions
76      */
77 
78     function imin(int256 x, int256 y) constant internal returns (int256 z) {
79         return x <= y ? x : y;
80     }
81     function imax(int256 x, int256 y) constant internal returns (int256 z) {
82         return x >= y ? x : y;
83     }
84 
85     /*
86     WAD math
87      */
88 
89     uint128 constant WAD = 10 ** 18;
90 
91     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
92         return hadd(x, y);
93     }
94 
95     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
96         return hsub(x, y);
97     }
98 
99     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
100         z = cast((uint256(x) * y + WAD / 2) / WAD);
101     }
102 
103     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
104         z = cast((uint256(x) * WAD + y / 2) / y);
105     }
106 
107     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
108         return hmin(x, y);
109     }
110     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
111         return hmax(x, y);
112     }
113 
114     /*
115     RAY math
116      */
117 
118     uint128 constant RAY = 10 ** 27;
119 
120     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
121         return hadd(x, y);
122     }
123 
124     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
125         return hsub(x, y);
126     }
127 
128     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
129         z = cast((uint256(x) * y + RAY / 2) / RAY);
130     }
131 
132     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
133         z = cast((uint256(x) * RAY + y / 2) / y);
134     }
135 
136     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
137         // This famous algorithm is called "exponentiation by squaring"
138         // and calculates x^n with x as fixed-point and n as regular unsigned.
139         //
140         // It's O(log n), instead of O(n) for naive repeated multiplication.
141         //
142         // These facts are why it works:
143         //
144         //  If n is even, then x^n = (x^2)^(n/2).
145         //  If n is odd,  then x^n = x * x^(n-1),
146         //   and applying the equation for even x gives
147         //    x^n = x * (x^2)^((n-1) / 2).
148         //
149         //  Also, EVM division is flooring and
150         //    floor[(n-1) / 2] = floor[n / 2].
151 
152         z = n % 2 != 0 ? x : RAY;
153 
154         for (n /= 2; n != 0; n /= 2) {
155             x = rmul(x, x);
156 
157             if (n % 2 != 0) {
158                 z = rmul(z, x);
159             }
160         }
161     }
162 
163     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
164         return hmin(x, y);
165     }
166     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
167         return hmax(x, y);
168     }
169 
170     function cast(uint256 x) constant internal returns (uint128 z) {
171         assert((z = uint128(x)) == x);
172     }
173 
174 }
175 
176 contract TokenBase is ERC20, DSMath {
177     uint256                                            _supply;
178     mapping (address => uint256)                       _balances;
179     mapping (address => mapping (address => uint256))  _approvals;
180 
181     function totalSupply() constant returns (uint256) {
182         return _supply;
183     }
184     function balanceOf(address addr) constant returns (uint256) {
185         return _balances[addr];
186     }
187     function allowance(address from, address to) constant returns (uint256) {
188         return _approvals[from][to];
189     }
190     
191     function transfer(address to, uint value) returns (bool) {
192         assert(_balances[msg.sender] >= value);
193         
194         _balances[msg.sender] = sub(_balances[msg.sender], value);
195         _balances[to] = add(_balances[to], value);
196         
197         Transfer(msg.sender, to, value);
198         
199         return true;
200     }
201     
202     function transferFrom(address from, address to, uint value) returns (bool) {
203         assert(_balances[from] >= value);
204         assert(_approvals[from][msg.sender] >= value);
205         
206         _approvals[from][msg.sender] = sub(_approvals[from][msg.sender], value);
207         _balances[from] = sub(_balances[from], value);
208         _balances[to] = add(_balances[to], value);
209         
210         Transfer(from, to, value);
211         
212         return true;
213     }
214     
215     function approve(address to, uint256 value) returns (bool) {
216         _approvals[msg.sender][to] = value;
217         
218         Approval(msg.sender, to, value);
219         
220         return true;
221     }
222 
223 }
224 
225 contract Owned
226 {
227     address public owner;
228     
229     function Owned()
230     {
231         owner = msg.sender;
232     }
233     
234     modifier onlyOwner()
235     {
236         if (msg.sender != owner) revert();
237         _;
238     }
239 }
240 
241 contract Migrable is TokenBase, Owned
242 {
243     event Migrate(address indexed _from, address indexed _to, uint256 _value);
244     address public migrationAgent;
245     uint256 public totalMigrated;
246 
247 
248     function migrate() external {
249         if (migrationAgent == 0)  revert();
250         if (_balances[msg.sender] == 0)  revert();
251         
252         uint256 _value = _balances[msg.sender];
253         _balances[msg.sender] = 0;
254         _supply = sub(_supply, _value);
255         totalMigrated = add(totalMigrated, _value);
256         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
257         Migrate(msg.sender, migrationAgent, _value);
258     }
259 
260     function setMigrationAgent(address _agent) onlyOwner external {
261         if (migrationAgent != 0)  revert();
262         migrationAgent = _agent;
263     }
264 }
265 
266 contract CrowdCoin is TokenBase, Owned, Migrable {
267     string public constant name = "Crowd Coin";
268     string public constant symbol = "CRC";
269     uint8 public constant decimals = 18; 
270 
271     uint public constant pre_ico_allocation = 10000000 * WAD;
272     uint public constant bounty_allocation = 1000000 * WAD;
273     
274     uint public ico_allocation = 5000000 * WAD;
275 
276     bool public locked = true;
277 
278     address public bounty;
279     CrowdCoinPreICO public pre_ico;
280     CrowdCoinICO public ico;
281 
282     function transfer(address to, uint value) returns (bool)
283     {
284         if (locked == true && msg.sender != address(ico) && msg.sender != address(pre_ico)) revert();
285         return super.transfer(to, value);
286     }
287     
288     function transferFrom(address from, address to, uint value)  returns (bool)
289     {
290         if (locked == true) revert();
291         return super.transferFrom(from, to, value);
292     }
293 
294     function init_pre_ico(address _pre_ico) onlyOwner
295     {
296         if (address(0) != address(pre_ico)) revert();
297         pre_ico = CrowdCoinPreICO(_pre_ico);
298         mint_tokens(pre_ico, pre_ico_allocation);
299     }
300     
301     function close_pre_ico() onlyOwner
302     {
303         ico_allocation = add(ico_allocation, _balances[pre_ico]);   
304         burn_balance(pre_ico);
305     }
306 
307     function init_ico(address _ico) onlyOwner
308     {
309         if (address(0) != address(ico) || address(0) == address(pre_ico) || _balances[pre_ico] > 0) revert();
310         ico = CrowdCoinICO(_ico);
311         mint_tokens(ico, ico_allocation);
312     }
313     
314     function init_bounty_program(address _bounty) onlyOwner
315     {
316         if (address(0) != address(bounty)) revert();
317         bounty = _bounty;
318         mint_tokens(bounty, bounty_allocation);
319     }
320     
321     function finalize(address team_allocation) onlyOwner {
322         if (ico.successfully_closed() == false || locked == false || address(0) == address(bounty)) revert();
323         burn_balance(ico);
324 
325         uint256 percentOfTotal = 20;
326         uint256 additionalTokens =
327             _supply * percentOfTotal / (100 - percentOfTotal);
328         
329         mint_tokens(team_allocation, additionalTokens);
330         
331         locked = false;
332     }
333 
334     function mint_tokens(address addr, uint amount) private
335     {
336         _balances[addr] = add(_balances[addr], amount);
337         _supply = add(_supply, amount);
338         Transfer(0, addr, amount);
339     }
340     
341     function burn_balance(address addr) private
342     {
343         uint amount = _balances[addr];
344         if (amount > 0)
345         {
346             _balances[addr] = 0;
347             _supply = sub(_supply, amount);
348             Transfer(addr, 0, amount);
349         }
350     }
351 }
352 
353 contract CrowdCoinManualSell
354 {
355     CrowdCoin public token;
356     address public dev_multisig;
357     address private constant owner_1 = 0x792030B6811043f79ae49d2C4bA33cC6a6326049;
358     address private constant owner_2 = 0x886531ed00cF51B6219Bf9EF9201ff4DEc622E6f;
359 
360     event Purchased(address participant, uint eth_amount, uint token_amount);
361     event ManualPurchase(address sender, address participant, uint token_amount);
362 
363     function transfer_coins(address _to, uint _value) public
364     {
365         if (msg.sender != owner_1 && msg.sender != owner_2) revert();
366         token.transfer(_to, _value);
367         ManualPurchase(msg.sender, _to, _value);
368     }
369 
370     function my_token_balance() public constant returns (uint)
371     {
372         return token.balanceOf(this);
373     }
374 
375     modifier has_value
376     {
377         if (msg.value < 0.01 ether) revert();
378         _;
379     }
380 }
381 
382 contract CrowdCoinSaleBonus
383 {
384     function get_bonus(uint buy_amount) internal returns(uint)
385     {
386         uint bonus = 0;
387         if (buy_amount >= 100000 ether)
388         {
389             bonus = 30;            
390         }
391         else if (buy_amount >= 50000 ether)
392         {
393             bonus = 25;            
394         }
395         else if (buy_amount >= 30000 ether)
396         {
397             bonus = 23;            
398         }
399         else if (buy_amount >= 20000 ether)
400         {
401             bonus = 20;            
402         }
403         else if (buy_amount >= 13000 ether)
404         {
405             bonus = 18;            
406         }
407         else if (buy_amount >= 8000 ether)
408         {
409             bonus = 15;            
410         }
411         else if (buy_amount >= 5000 ether)
412         {
413             bonus = 13;            
414         }
415         else if (buy_amount >= 3000 ether)
416         {
417             bonus = 10;            
418         }
419         return buy_amount * bonus / 100;
420     }
421 }
422 
423 contract CrowdCoinPreICO is Owned, DSMath, CrowdCoinSaleBonus, CrowdCoinManualSell
424 {
425     
426     uint public total_raised;
427 
428     uint public constant price =  0.00125 * 10**18; //have to set price here
429 
430     function CrowdCoinPreICO(address _token_address, address _dev_multisig)
431     {
432         token = CrowdCoin(_token_address);
433         dev_multisig = _dev_multisig;
434     }
435     
436     function () has_value payable external 
437     {
438         if (my_token_balance() == 0) revert();
439 
440         var can_buy = wdiv(cast(msg.value), cast(price));
441         can_buy = wadd(can_buy, cast(get_bonus(can_buy)));
442         var buy_amount = cast(min(can_buy, my_token_balance()));
443 
444         if (can_buy > buy_amount) revert();
445 
446         total_raised = add(total_raised, msg.value);
447 
448         dev_multisig.transfer(this.balance); //transfer eth to dev
449         token.transfer(msg.sender, buy_amount); //transfer tokens to participant
450         Purchased(msg.sender, msg.value, buy_amount);
451     }
452 }
453 
454 contract CrowdCoinICO is Owned, DSMath, CrowdCoinSaleBonus, CrowdCoinManualSell
455 {
456     uint public total_raised; //crowdsale total funds raised
457 
458     uint public start_time = 0;
459     uint public end_time = 0;
460     uint public constant goal = 350 ether;
461     uint256 public constant default_price = 0.005 * 10**18;
462     
463     mapping (uint => uint256) public price;
464 
465     mapping(address => uint) funded; //needed to save amounts of ETH for refund
466     
467     modifier in_time //allows send eth only when crowdsale is active
468     {
469         if (time() < start_time || time() > end_time)  revert();
470         _;
471     }
472 
473     function successfully_closed() public constant returns (bool)
474     {
475         return time() > start_time && (time() > end_time || my_token_balance() == 0) && total_raised >= goal;
476     }
477     
478     function time() public constant returns (uint)
479     {
480         return block.timestamp;
481     }
482 
483     function CrowdCoinICO(address _token_address, address _dev_multisig)
484     {
485         token = CrowdCoin(_token_address);
486         dev_multisig = _dev_multisig;
487         
488         price[0] = 0.0025 * 10**18;
489         price[1] = 0.0033 * 10**18;
490         price[2] = 0.0044 * 10**18;
491     }
492     
493     function init(uint _start_time, uint _end_time) onlyOwner
494     {
495         if (start_time != 0) revert();
496         start_time = _start_time;
497         end_time = _end_time;
498     }
499     
500     function () has_value in_time payable external 
501     {
502         if (my_token_balance() == 0) revert();
503 
504         var can_buy = wdiv(cast(msg.value), cast(get_current_price()));
505         can_buy = wadd(can_buy, cast(get_bonus(can_buy)));
506         var buy_amount = cast(min(can_buy, my_token_balance()));
507 
508         if (can_buy > buy_amount) revert();
509 
510         total_raised = add(total_raised, msg.value);
511         funded[msg.sender] = add(funded[msg.sender], msg.value);
512         token.transfer(msg.sender, buy_amount); //transfer tokens to participant
513         Purchased(msg.sender, msg.value, buy_amount);
514     }
515     
516     function refund()
517     {
518         if (total_raised >= goal || time() < end_time) revert();
519         var amount = funded[msg.sender];
520         if (amount > 0)
521         {
522             funded[msg.sender] = 0;
523             msg.sender.transfer(amount);
524         }
525     }
526     
527     function collect() //collect eth by devs if min goal reached
528     {
529         if (total_raised < goal) revert();
530         dev_multisig.transfer(this.balance);
531     }
532     
533     function get_current_price() constant returns (uint256) {
534         return price[current_week()] == 0 ? default_price : price[current_week()];
535     }
536     
537     function current_week() constant returns (uint) {
538         return sub(block.timestamp, start_time) / 7 days;
539     }
540 }
541 
542 
543 contract CrowdDevAllocation is Owned
544 {
545     CrowdCoin public token;
546     uint public initial_time;
547     address tokens_multisig;
548 
549     mapping(uint => bool) public unlocked;
550     mapping(uint => uint) public unlock_times;
551     mapping(uint => uint) unlock_values;
552     
553     function CrowdDevAllocation(address _token)
554     {
555         token = CrowdCoin(_token);
556     }
557     
558     function init() onlyOwner
559     {
560         if (token.balanceOf(this) == 0 || initial_time != 0) revert();
561         initial_time = block.timestamp;
562         uint256 balance = token.balanceOf(this);
563 
564         unlock_values[0] = balance / 100 * 33;
565         unlock_values[1] = balance / 100 * 33;
566         unlock_values[2] = balance / 100 * 34;
567 
568         unlock_times[0] = 180 days; //33% of tokens will be available after 180 days
569         unlock_times[1] = 1080 days; //33% of tokens will be available after 1080 days
570         unlock_times[2] = 1800 days; //34% of tokens will be available after 1800 days
571     }
572 
573     function unlock(uint part)
574     {
575         if (unlocked[part] == true || block.timestamp < initial_time + unlock_times[part] || unlock_values[part] == 0) revert();
576         token.transfer(tokens_multisig, unlock_values[part]);
577         unlocked[part] = true;
578     }
579 }
580 
581 contract MigrationAgent {
582     function migrateFrom(address _from, uint256 _value);
583 }