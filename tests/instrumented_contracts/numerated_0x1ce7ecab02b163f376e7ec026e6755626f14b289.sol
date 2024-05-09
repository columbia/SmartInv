1 /*
2                                      
3   _ __   _____   ___   _ _ __    _   
4  | '_ \ / _ \ \ / / | | | '_ \ _| |_ 
5  | | | | (_) \ V /| |_| | | | |_   _|
6  |_| |_|\___/ \_/  \__,_|_| |_| |_|  
7                                      
8 */
9 
10 /* SPDX-License-Identifier: MIT License */
11 
12 pragma solidity 0.6.8;
13 
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 /**
103  * @dev Contract module which allows children to implement an emergency stop
104  * mechanism that can be triggered by an authorized account.
105  *
106  * This module is used through inheritance. It will make available the
107  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
108  * the functions of your contract. Note that they will not be pausable by
109  * simply including this module, only once the modifiers are put in place.
110  */
111 contract Pausable is Context {
112     /**
113      * @dev Emitted when the pause is triggered by `account`.
114      */
115     event Paused(address account);
116 
117     /**
118      * @dev Emitted when the pause is lifted by `account`.
119      */
120     event Unpaused(address account);
121 
122     bool private _paused;
123 
124     /**
125      * @dev Initializes the contract in unpaused state.
126      */
127     constructor () internal {
128         _paused = false;
129     }
130 
131     /**
132      * @dev Returns true if the contract is paused, and false otherwise.
133      */
134     function paused() public view returns (bool) {
135         return _paused;
136     }
137 
138     /**
139      * @dev Modifier to make a function callable only when the contract is not paused.
140      *
141      * Requirements:
142      *
143      * - The contract must not be paused.
144      */
145     modifier whenNotPaused() {
146         require(!_paused, "Pausable: paused");
147         _;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is paused.
152      *
153      * Requirements:
154      *
155      * - The contract must be paused.
156      */
157     modifier whenPaused() {
158         require(_paused, "Pausable: not paused");
159         _;
160     }
161 
162     /**
163      * @dev Triggers stopped state.
164      *
165      * Requirements:
166      *
167      * - The contract must not be paused.
168      */
169     function _pause() internal virtual whenNotPaused {
170         _paused = true;
171         emit Paused(_msgSender());
172     }
173 
174     /**
175      * @dev Returns to normal state.
176      *
177      * Requirements:
178      *
179      * - The contract must be paused.
180      */
181     function _unpause() internal virtual whenPaused {
182         _paused = false;
183         emit Unpaused(_msgSender());
184     }
185 }
186 
187 
188 contract Destructible {
189     address payable public grand_owner;
190 
191     event GrandOwnershipTransferred(address indexed previous_owner, address indexed new_owner);
192 
193     constructor() public {
194         grand_owner = msg.sender;
195     }
196 
197     function transferGrandOwnership(address payable _to) external {
198         require(msg.sender == grand_owner, "Access denied (only grand owner)");
199         
200         grand_owner = _to;
201     }
202 
203     function destruct() external {
204         require(msg.sender == grand_owner, "Access denied (only grand owner)");
205 
206         selfdestruct(grand_owner);
207     }
208 }
209 
210 contract NovunPlus is Ownable, Destructible, Pausable {
211     struct User {
212         uint256 id;
213         uint256 cycle;
214         address upline;
215         uint256 referrals;
216         uint256 payouts;
217         uint256 direct_bonus;
218         uint256 match_bonus;
219         uint256 deposit_amount;
220         uint256 deposit_payouts;
221         uint40 deposit_time;
222         uint256 total_deposits;
223         uint256 total_payouts;
224         uint256 total_structure;
225     }
226 
227     mapping(address => User) public users;
228 
229     uint256[] public cycles;                        // ether
230     uint8[] public ref_bonuses;                     // 1 => 1%
231     uint8[] public net_bonuses;
232 
233     uint256 public total_withdraw;
234     uint256 public lastUserId;
235     
236     event Upline(address indexed addr, address indexed upline);
237     event NewDeposit(address indexed addr, uint256 amount);
238     event DirectPayout(address indexed addr, address indexed from, uint256 amount, uint8 level);
239     event MatchPayout(address indexed addr, address indexed from, uint256 amount);
240     event Withdraw(address indexed addr, uint256 amount);
241     event LimitReached(address indexed addr, uint256 amount);
242 
243     constructor() public {
244         ref_bonuses.push(30);
245         ref_bonuses.push(15);
246         ref_bonuses.push(15);
247         ref_bonuses.push(15);
248         ref_bonuses.push(15);
249         ref_bonuses.push(8);
250         ref_bonuses.push(8);
251         ref_bonuses.push(8);
252         ref_bonuses.push(8);
253         ref_bonuses.push(8);
254 
255         net_bonuses.push(8);
256         net_bonuses.push(4);
257         net_bonuses.push(2);
258 
259         cycles.push(10 ether);
260         cycles.push(25 ether);
261         cycles.push(50 ether);
262         cycles.push(100 ether);
263     }
264 
265     receive() payable external whenNotPaused {
266         _deposit(msg.sender, msg.value);
267     }
268 
269     function _setUpline(address _addr, address _upline) private {
270         if(users[_addr].upline == address(0) && _upline != _addr && (users[_upline].deposit_time > 0 || _upline == owner())) {
271             users[_addr].upline = _upline;
272             users[_upline].referrals++;
273 
274             emit Upline(_addr, _upline);
275 
276             for(uint8 i = 0; i < ref_bonuses.length; i++) {
277                 if(_upline == address(0)) break;
278 
279                 users[_upline].total_structure++;
280 
281                 _upline = users[_upline].upline;
282             }
283         }
284     }
285 
286     function _deposit(address _addr, uint256 _amount) private {
287         require(users[_addr].upline != address(0) || _addr == owner(), "No upline");
288 
289         if(users[_addr].deposit_time > 0) {
290             users[_addr].cycle++;
291             
292             require(users[_addr].payouts >= maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
293             require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
294         } else {
295             lastUserId++;
296             require(_amount >= 0.1 ether && _amount <= cycles[0], "Bad amount");
297         }
298         
299         users[_addr].id = lastUserId;
300         users[_addr].payouts = 0;
301         users[_addr].deposit_amount = _amount;
302         users[_addr].deposit_payouts = 0;
303         users[_addr].deposit_time = uint40(block.timestamp);
304         users[_addr].total_deposits += _amount;
305         
306         emit NewDeposit(_addr, _amount);
307         
308         address _upline = users[_addr].upline;
309         for (uint8 i = 0; i < net_bonuses.length; i++) {
310             uint256 _bonus = (_amount * net_bonuses[i]) / 100;
311             
312             if(_upline != address(0)) {
313                 users[_upline].direct_bonus += _bonus;
314 
315                 emit DirectPayout(_upline, _addr, _bonus, i + 1);
316                 
317                 _upline = users[_upline].upline;
318             } else {
319                  users[owner()].direct_bonus += _bonus;
320                 emit DirectPayout(owner(), _addr, _bonus, i + 1);
321                 
322                 _upline = owner();
323             }
324         }
325 
326         payable(owner()).transfer((_amount * 15) / 1000); // 1.5%
327     }
328 
329     function _refPayout(address _addr, uint256 _amount) private {
330         address up = users[_addr].upline;
331 
332         for(uint8 i = 0; i < ref_bonuses.length; i++) {
333             if(up == address(0)) break;
334             
335             if(users[up].referrals >= i + 1) {
336                 uint256 bonus = _amount * ref_bonuses[i] / 100;
337                 
338                 users[up].match_bonus += bonus;
339 
340                 emit MatchPayout(up, _addr, bonus);
341             }
342 
343             up = users[up].upline;
344         }
345     }
346 
347     function deposit(address _upline) external payable whenNotPaused {
348         _setUpline(msg.sender, _upline);
349         _deposit(msg.sender, msg.value);
350     }
351 
352     function withdraw() external whenNotPaused {
353         (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
354         
355         require(users[msg.sender].payouts < max_payout, "Full payouts");
356 
357         // Deposit payout
358         if(to_payout > 0) {
359             if(users[msg.sender].payouts + to_payout > max_payout) {
360                 to_payout = max_payout - users[msg.sender].payouts;
361             }
362 
363             users[msg.sender].deposit_payouts += to_payout;
364             users[msg.sender].payouts += to_payout;
365 
366             _refPayout(msg.sender, to_payout);
367         }
368         
369         // Direct payout
370         if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
371             uint256 direct_bonus = users[msg.sender].direct_bonus;
372 
373             if(users[msg.sender].payouts + direct_bonus > max_payout) {
374                 direct_bonus = max_payout - users[msg.sender].payouts;
375             }
376 
377             users[msg.sender].direct_bonus -= direct_bonus;
378             to_payout += direct_bonus;
379         }
380 
381         // Match payout
382         if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
383             uint256 match_bonus = users[msg.sender].match_bonus;
384 
385             if(users[msg.sender].payouts + match_bonus > max_payout) {
386                 match_bonus = max_payout - users[msg.sender].payouts;
387             }
388 
389             users[msg.sender].match_bonus -= match_bonus;
390             users[msg.sender].payouts += match_bonus;
391             to_payout += match_bonus;
392         }
393 
394         require(to_payout > 0, "Zero payout");
395         
396         users[msg.sender].total_payouts += to_payout;
397         total_withdraw += to_payout;
398 
399         payable(msg.sender).transfer(to_payout);
400 
401         emit Withdraw(msg.sender, to_payout);
402 
403         if(users[msg.sender].payouts >= max_payout) {
404             emit LimitReached(msg.sender, users[msg.sender].payouts);
405         }
406     }
407     
408     function pause() external onlyOwner {
409         _pause();
410     }
411     
412     function unpause() external onlyOwner {
413         _unpause();
414     }
415 
416     function maxPayoutOf(uint256 _amount) private pure returns(uint256) {
417         return _amount * 3;
418     }
419 
420     function payoutOf(address _addr) public view returns(uint256 payout, uint256 max_payout) {
421         payout = 0;
422         max_payout = maxPayoutOf(users[_addr].deposit_amount);
423 
424         if(users[_addr].deposit_payouts < max_payout) {
425             payout = (((users[_addr].deposit_amount * 15) / 1000) * ((now - users[_addr].deposit_time) / 1 days)) - users[_addr].deposit_payouts;
426             
427             if(users[_addr].deposit_payouts + payout > max_payout) {
428                 payout = max_payout - users[_addr].deposit_payouts;
429             }
430         }
431         
432         return (payout, max_payout);
433     }
434 
435     /*
436         Only external call
437     */
438     function getDaysSinceDeposit(address _addr) external view returns(uint daysSince, uint secondsSince) {
439         return (((now - users[_addr].deposit_time) / 1 days), (now - users[_addr].deposit_time));
440     }
441     
442     function isUserRegistered(address _addr) external view returns(bool isRegistered) {
443         return (users[_addr].total_deposits > 0);
444     }
445     
446     function userInfo(address _addr) external view returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 match_bonus, uint256 cycle) {
447         return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].match_bonus, users[_addr].cycle);
448     }
449 
450     function userInfoTotals(address _addr) external view returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
451         return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
452     }
453 
454     function contractInfo() external view returns(uint256 _total_withdraw, uint256 _lastUserId) {
455         return (total_withdraw, lastUserId);
456     }
457 }