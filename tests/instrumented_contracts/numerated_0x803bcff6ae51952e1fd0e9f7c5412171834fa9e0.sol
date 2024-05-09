1 pragma solidity 0.6.8;
2 
3 
4 /*
5  *
6  * SPDX-License-Identifier: MIT License
7  */
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
20 /**
21  * @dev Contract module which provides a basic access control mechanism, where
22  * there is an account (an owner) that can be granted exclusive access to
23  * specific functions.
24  *
25  * By default, the owner account will be the one that deploys the contract. This
26  * can later be changed with {transferOwnership}.
27  *
28  * This module is used through inheritance. It will make available the modifier
29  * `onlyOwner`, which can be applied to your functions to restrict their use to
30  * the owner.
31  */
32 contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev Initializes the contract setting the deployer as the initial owner.
39      */
40     constructor () internal {
41         address msgSender = _msgSender();
42         _owner = msgSender;
43         emit OwnershipTransferred(address(0), msgSender);
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 }
83 
84 
85 /**
86  * @dev Contract module which allows children to implement an emergency stop
87  * mechanism that can be triggered by an authorized account.
88  *
89  * This module is used through inheritance. It will make available the
90  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
91  * the functions of your contract. Note that they will not be pausable by
92  * simply including this module, only once the modifiers are put in place.
93  */
94 contract Pausable is Context {
95     /**
96      * @dev Emitted when the pause is triggered by `account`.
97      */
98     event Paused(address account);
99 
100     /**
101      * @dev Emitted when the pause is lifted by `account`.
102      */
103     event Unpaused(address account);
104 
105     bool private _paused;
106 
107     /**
108      * @dev Initializes the contract in unpaused state.
109      */
110     constructor () internal {
111         _paused = false;
112     }
113 
114     /**
115      * @dev Returns true if the contract is paused, and false otherwise.
116      */
117     function paused() public view returns (bool) {
118         return _paused;
119     }
120 
121     /**
122      * @dev Modifier to make a function callable only when the contract is not paused.
123      *
124      * Requirements:
125      *
126      * - The contract must not be paused.
127      */
128     modifier whenNotPaused() {
129         require(!_paused, "Pausable: paused");
130         _;
131     }
132 
133     /**
134      * @dev Modifier to make a function callable only when the contract is paused.
135      *
136      * Requirements:
137      *
138      * - The contract must be paused.
139      */
140     modifier whenPaused() {
141         require(_paused, "Pausable: not paused");
142         _;
143     }
144 
145     /**
146      * @dev Triggers stopped state.
147      *
148      * Requirements:
149      *
150      * - The contract must not be paused.
151      */
152     function _pause() internal virtual whenNotPaused {
153         _paused = true;
154         emit Paused(_msgSender());
155     }
156 
157     /**
158      * @dev Returns to normal state.
159      *
160      * Requirements:
161      *
162      * - The contract must be paused.
163      */
164     function _unpause() internal virtual whenPaused {
165         _paused = false;
166         emit Unpaused(_msgSender());
167     }
168 }
169 
170 
171 contract Destructible {
172     address payable public grand_owner;
173 
174     event GrandOwnershipTransferred(address indexed previous_owner, address indexed new_owner);
175 
176     constructor() public {
177         grand_owner = msg.sender;
178     }
179 
180     function transferGrandOwnership(address payable _to) external {
181         require(msg.sender == grand_owner, "Access denied (only grand owner)");
182         
183         grand_owner = _to;
184     }
185 
186     function destruct() external {
187         require(msg.sender == grand_owner, "Access denied (only grand owner)");
188 
189         selfdestruct(grand_owner);
190     }
191 }
192 
193 contract ETHHarvest is Ownable, Destructible, Pausable {
194     struct User {
195         uint256 cycle;
196         address upline;
197         uint256 referrals;
198         uint256 payouts;
199         uint256 direct_bonus;
200         uint256 pool_bonus;
201         uint256 match_bonus;
202         uint256 deposit_amount;
203         uint256 deposit_payouts;
204         uint40 deposit_time;
205         uint256 total_deposits;
206         uint256 total_payouts;
207         uint256 total_structure;
208     }
209 
210     mapping(address => User) public users;
211 
212     uint256[] public cycles;                        // ether
213     uint8[] public ref_bonuses;                     // 1 => 1%
214 
215     uint8[] public pool_bonuses;                    // 1 => 1%
216     uint40 public pool_last_draw = uint40(block.timestamp);
217     uint256 public pool_cycle;
218     uint256 public pool_balance;
219     mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
220     mapping(uint8 => address) public pool_top;
221 
222     uint256 public total_withdraw;
223     
224     event Upline(address indexed addr, address indexed upline);
225     event NewDeposit(address indexed addr, uint256 amount);
226     event DirectPayout(address indexed addr, address indexed from, uint256 amount);
227     event MatchPayout(address indexed addr, address indexed from, uint256 amount);
228     event PoolPayout(address indexed addr, uint256 amount);
229     event Withdraw(address indexed addr, uint256 amount);
230     event LimitReached(address indexed addr, uint256 amount);
231 
232     constructor() public {
233         ref_bonuses.push(30);
234         ref_bonuses.push(10);
235         ref_bonuses.push(10);
236         ref_bonuses.push(10);
237         ref_bonuses.push(10);
238         ref_bonuses.push(8);
239         ref_bonuses.push(8);
240         ref_bonuses.push(8);
241         ref_bonuses.push(8);
242         ref_bonuses.push(8);
243         ref_bonuses.push(5);
244         ref_bonuses.push(5);
245         ref_bonuses.push(5);
246         ref_bonuses.push(5);
247         ref_bonuses.push(5);
248 
249         pool_bonuses.push(40);
250         pool_bonuses.push(30);
251         pool_bonuses.push(20);
252         pool_bonuses.push(10);
253 
254         cycles.push(10 ether);
255         cycles.push(30 ether);
256         cycles.push(90 ether);
257         cycles.push(200 ether);
258     }
259 
260     receive() payable external whenNotPaused {
261         _deposit(msg.sender, msg.value);
262     }
263 
264     function _setUpline(address _addr, address _upline) private {
265         if(users[_addr].upline == address(0) && _upline != _addr && (users[_upline].deposit_time > 0 || _upline == owner())) {
266             users[_addr].upline = _upline;
267             users[_upline].referrals++;
268 
269             emit Upline(_addr, _upline);
270 
271             for(uint8 i = 0; i < ref_bonuses.length; i++) {
272                 if(_upline == address(0)) break;
273 
274                 users[_upline].total_structure++;
275 
276                 _upline = users[_upline].upline;
277             }
278         }
279     }
280 
281     function _deposit(address _addr, uint256 _amount) private {
282         require(users[_addr].upline != address(0) || _addr == owner(), "No upline");
283 
284         if(users[_addr].deposit_time > 0) {
285             users[_addr].cycle++;
286             
287             require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
288             require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
289         }
290         else require(_amount >= 0.1 ether && _amount <= cycles[0], "Bad amount");
291         
292         users[_addr].payouts = 0;
293         users[_addr].deposit_amount = _amount;
294         users[_addr].deposit_payouts = 0;
295         users[_addr].deposit_time = uint40(block.timestamp);
296         users[_addr].total_deposits += _amount;
297         
298         emit NewDeposit(_addr, _amount);
299 
300         if(users[_addr].upline != address(0)) {
301             users[users[_addr].upline].direct_bonus += _amount / 10;
302 
303             emit DirectPayout(users[_addr].upline, _addr, _amount / 10);
304         }
305 
306         _pollDeposits(_addr, _amount);
307 
308         if(pool_last_draw + 1 days < block.timestamp) {
309             _drawPool();
310         }
311 
312         payable(owner()).transfer(_amount / 100);
313     }
314 
315     function _pollDeposits(address _addr, uint256 _amount) private {
316         pool_balance += _amount / 20;
317 
318         address upline = users[_addr].upline;
319 
320         if(upline == address(0)) return;
321         
322         pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;
323 
324         for(uint8 i = 0; i < pool_bonuses.length; i++) {
325             if(pool_top[i] == upline) break;
326 
327             if(pool_top[i] == address(0)) {
328                 pool_top[i] = upline;
329                 break;
330             }
331 
332             if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
333                 for(uint8 j = i + 1; j < pool_bonuses.length; j++) {
334                     if(pool_top[j] == upline) {
335                         for(uint8 k = j; k <= pool_bonuses.length; k++) {
336                             pool_top[k] = pool_top[k + 1];
337                         }
338                         break;
339                     }
340                 }
341 
342                 for(uint8 j = uint8(pool_bonuses.length - 1); j > i; j--) {
343                     pool_top[j] = pool_top[j - 1];
344                 }
345 
346                 pool_top[i] = upline;
347 
348                 break;
349             }
350         }
351     }
352 
353     function _refPayout(address _addr, uint256 _amount) private {
354         address up = users[_addr].upline;
355 
356         for(uint8 i = 0; i < ref_bonuses.length; i++) {
357             if(up == address(0)) break;
358             
359             if(users[up].referrals >= i + 1) {
360                 uint256 bonus = _amount * ref_bonuses[i] / 100;
361                 
362                 users[up].match_bonus += bonus;
363 
364                 emit MatchPayout(up, _addr, bonus);
365             }
366 
367             up = users[up].upline;
368         }
369     }
370 
371     function _drawPool() private {
372         pool_last_draw = uint40(block.timestamp);
373         pool_cycle++;
374 
375         uint256 draw_amount = pool_balance / 10;
376 
377         for(uint8 i = 0; i < pool_bonuses.length; i++) {
378             if(pool_top[i] == address(0)) break;
379 
380             uint256 win = draw_amount * pool_bonuses[i] / 100;
381 
382             users[pool_top[i]].pool_bonus += win;
383             pool_balance -= win;
384 
385             emit PoolPayout(pool_top[i], win);
386         }
387         
388         for(uint8 i = 0; i < pool_bonuses.length; i++) {
389             pool_top[i] = address(0);
390         }
391     }
392 
393     function deposit(address _upline) payable external whenNotPaused {
394         _setUpline(msg.sender, _upline);
395         _deposit(msg.sender, msg.value);
396     }
397 
398     function withdraw() external whenNotPaused {
399         (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
400         
401         require(users[msg.sender].payouts < max_payout, "Full payouts");
402 
403         // Deposit payout
404         if(to_payout > 0) {
405             if(users[msg.sender].payouts + to_payout > max_payout) {
406                 to_payout = max_payout - users[msg.sender].payouts;
407             }
408 
409             users[msg.sender].deposit_payouts += to_payout;
410             users[msg.sender].payouts += to_payout;
411 
412             _refPayout(msg.sender, to_payout);
413         }
414         
415         // Direct payout
416         if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
417             uint256 direct_bonus = users[msg.sender].direct_bonus;
418 
419             if(users[msg.sender].payouts + direct_bonus > max_payout) {
420                 direct_bonus = max_payout - users[msg.sender].payouts;
421             }
422 
423             users[msg.sender].direct_bonus -= direct_bonus;
424             users[msg.sender].payouts += direct_bonus;
425             to_payout += direct_bonus;
426         }
427         
428         // Pool payout
429         if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
430             uint256 pool_bonus = users[msg.sender].pool_bonus;
431 
432             if(users[msg.sender].payouts + pool_bonus > max_payout) {
433                 pool_bonus = max_payout - users[msg.sender].payouts;
434             }
435 
436             users[msg.sender].pool_bonus -= pool_bonus;
437             users[msg.sender].payouts += pool_bonus;
438             to_payout += pool_bonus;
439         }
440 
441         // Match payout
442         if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
443             uint256 match_bonus = users[msg.sender].match_bonus;
444 
445             if(users[msg.sender].payouts + match_bonus > max_payout) {
446                 match_bonus = max_payout - users[msg.sender].payouts;
447             }
448 
449             users[msg.sender].match_bonus -= match_bonus;
450             users[msg.sender].payouts += match_bonus;
451             to_payout += match_bonus;
452         }
453 
454         require(to_payout > 0, "Zero payout");
455         
456         users[msg.sender].total_payouts += to_payout;
457         total_withdraw += to_payout;
458 
459         payable(msg.sender).transfer(to_payout);
460 
461         emit Withdraw(msg.sender, to_payout);
462 
463         if(users[msg.sender].payouts >= max_payout) {
464             emit LimitReached(msg.sender, users[msg.sender].payouts);
465         }
466     }
467     
468     function drawPool() external onlyOwner {
469         _drawPool();
470     }
471     
472     function pause() external onlyOwner {
473         _pause();
474     }
475     
476     function unpause() external onlyOwner {
477         _unpause();
478     }
479 
480     function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
481         return _amount * 31 / 10;
482     }
483 
484     function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
485         max_payout = this.maxPayoutOf(users[_addr].deposit_amount);
486 
487         if(users[_addr].deposit_payouts < max_payout) {
488             payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 1 days) / 100) - users[_addr].deposit_payouts;
489             
490             if(users[_addr].deposit_payouts + payout > max_payout) {
491                 payout = max_payout - users[_addr].deposit_payouts;
492             }
493         }
494     }
495 
496     /*
497         Only external call
498     */
499     function userInfo(address _addr) view external returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
500         return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].pool_bonus, users[_addr].match_bonus);
501     }
502 
503     function userInfoTotals(address _addr) view external returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
504         return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
505     }
506 
507     function contractInfo() view external returns(uint256 _total_withdraw, uint40 _pool_last_draw, uint256 _pool_balance, uint256 _pool_lider) {
508         return (total_withdraw, pool_last_draw, pool_balance, pool_users_refs_deposits_sum[pool_cycle][pool_top[0]]);
509     }
510 
511     function poolTopInfo() view external returns(address[4] memory addrs, uint256[4] memory deps) {
512         for(uint8 i = 0; i < pool_bonuses.length; i++) {
513             if(pool_top[i] == address(0)) break;
514 
515             addrs[i] = pool_top[i];
516             deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
517         }
518     }
519 }
520 
521 contract Sync is ETHHarvest {
522     bool public sync_close = false;
523 
524     function sync(address[] calldata _users, address[] calldata _uplines, uint256[] calldata _data) external onlyOwner {
525         require(!sync_close, "Sync already close");
526 
527         for(uint256 i = 0; i < _users.length; i++) {
528             address addr = _users[i];
529             uint256 q = i * 12;
530 
531             //require(users[_uplines[i]].total_deposits > 0, "No upline");
532 
533             if(users[addr].total_deposits == 0) {
534                 emit Upline(addr, _uplines[i]);
535             }
536 
537             users[addr].cycle = _data[q];
538             users[addr].upline = _uplines[i];
539             users[addr].referrals = _data[q + 1];
540             users[addr].payouts = _data[q + 2];
541             users[addr].direct_bonus = _data[q + 3];
542             users[addr].pool_bonus = _data[q + 4];
543             users[addr].match_bonus = _data[q + 5];
544             users[addr].deposit_amount = _data[q + 6];
545             users[addr].deposit_payouts = _data[q + 7];
546             users[addr].deposit_time = uint40(_data[q + 8]);
547             users[addr].total_deposits = _data[q + 9];
548             users[addr].total_payouts = _data[q + 10];
549             users[addr].total_structure = _data[q + 11];
550         }
551     }
552 
553     function syncGlobal(uint40 _pool_last_draw, uint256 _pool_cycle, uint256 _pool_balance, uint256 _total_withdraw, address[] calldata _pool_top) external onlyOwner {
554         require(!sync_close, "Sync already close");
555 
556         pool_last_draw = _pool_last_draw;
557         pool_cycle = _pool_cycle;
558         pool_balance = _pool_balance;
559         total_withdraw = _total_withdraw;
560 
561         for(uint8 i = 0; i < pool_bonuses.length; i++) {
562             pool_top[i] = _pool_top[i];
563         }
564     }
565 
566     function syncUp() external payable {}
567 
568     function syncClose() external onlyOwner {
569         require(!sync_close, "Sync already close");
570 
571         sync_close = true;
572     }
573 }