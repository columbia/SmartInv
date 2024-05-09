1 pragma solidity 0.6.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         require(c / a == b, "SafeMath: multiplication overflow");
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b > 0, "SafeMath: division by zero");
22         uint256 c = a / b;
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0, "SafeMath: modulo by zero");
43         return a % b;
44     }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53 
54     address internal _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor(address initialOwner) internal {
59         require(initialOwner != address(0));
60         _owner = initialOwner;
61         emit OwnershipTransferred(address(0), _owner);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(msg.sender == _owner, "Caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public onlyOwner {
79         require(newOwner != address(0), "New owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 
84 }
85 
86 /**
87  * @title Roles
88  * @dev Library for managing addresses assigned to a Role.
89  */
90 library Roles {
91     struct Role {
92         mapping (address => bool) bearer;
93     }
94 
95     /**
96      * @dev Give an account access to this role.
97      */
98     function add(Role storage role, address account) internal {
99         require(!has(role, account), "Roles: account already has role");
100         role.bearer[account] = true;
101     }
102 
103     /**
104      * @dev Remove an account's access to this role.
105      */
106     function remove(Role storage role, address account) internal {
107         require(has(role, account), "Roles: account does not have role");
108         role.bearer[account] = false;
109     }
110 
111     /**
112      * @dev Check if an account has this role.
113      * @return bool
114      */
115     function has(Role storage role, address account) internal view returns (bool) {
116         require(account != address(0), "Roles: account is the zero address");
117         return role.bearer[account];
118     }
119 }
120 
121 /**
122  * @title WhitelistedRole
123  * @dev Whitelisted accounts have been approved by to perform certain actions (e.g. participate in a
124  * crowdsale).
125  */
126 abstract contract WhitelistedRole is Ownable {
127     using Roles for Roles.Role;
128 
129     event WhitelistedAdded(address indexed account);
130     event WhitelistedRemoved(address indexed account);
131 
132     Roles.Role internal _whitelisteds;
133 
134     modifier onlyWhitelisted() {
135         require(isWhitelisted(msg.sender), "Sender is not whitelisted");
136         _;
137     }
138 
139     function isWhitelisted(address account) public view returns (bool) {
140         return _whitelisteds.has(account);
141     }
142 
143     function addWhitelisteds(address[] memory accounts) public virtual onlyOwner {
144         for (uint256 i = 0; i < accounts.length; i++) {
145             _whitelisteds.add(accounts[i]);
146             emit WhitelistedAdded(accounts[i]);
147         }
148     }
149 
150     function removeWhitelisteds(address[] memory accounts) public virtual onlyOwner {
151         for (uint256 i = 0; i < accounts.length; i++) {
152             _whitelisteds.remove(accounts[i]);
153             emit WhitelistedRemoved(accounts[i]);
154         }
155     }
156 }
157 
158 /**
159  * @title ERC20 interface
160  * @dev see https://eips.ethereum.org/EIPS/eip-20
161  */
162  interface IERC20 {
163      function transfer(address to, uint256 value) external returns (bool);
164      function approve(address spender, uint256 value) external returns (bool);
165      function transferFrom(address from, address to, uint256 value) external returns (bool);
166      function totalSupply() external view returns (uint256);
167      function balanceOf(address who) external view returns (uint256);
168      function allowance(address owner, address spender) external view returns (uint256);
169      event Transfer(address indexed from, address indexed to, uint256 value);
170      event Approval(address indexed owner, address indexed spender, uint256 value);
171  }
172 
173 /**
174  * @title Staking contract
175  */
176 contract Staking is WhitelistedRole {
177     using SafeMath for uint256;
178 
179     IERC20 public token;
180 
181     uint256 constant public ONE_HUNDRED = 10000;
182     uint256 constant public ONE_DAY = 1 days;
183 
184     uint256 _depositsBalance;
185 
186     Parameters[] _stages;
187     struct Parameters {
188         uint256 minimum;
189         uint256 maximum;
190         uint256 minPercent;
191         uint256 maxPercent;
192         uint256 timestamp;
193         uint256 interval;
194     }
195 
196     uint256 public yearSettingsLimit;
197 
198     mapping (address => User) _users;
199     struct User {
200         uint256 deposit;
201         uint256 checkpoint;
202         uint256 lastStage;
203         uint256 reserved;
204     }
205 
206     bool public finalized;
207 
208     event Invested(address indexed user, uint256 amount);
209     event DividendsWithdrawn(address sender, address indexed user, uint256 amount);
210     event DividendsReserved(address sender, address indexed user, uint256 amount);
211     event DepositWithdrawn(address sender, address indexed user, uint256 amount, uint256 remaining);
212     event SetParameters(uint256 index, uint256 interval, uint256 minimum, uint256 maximum, uint256 minPercent, uint256 maxPercent);
213     event Donated(address indexed sender, address indexed from, uint256 amount);
214     event TheEnd(uint256 balance);
215 
216     constructor(address digexTokenAddr, uint256 newMinimum, uint256 newMaximum, uint256 newMinPercent, uint256 newMaxPercent, uint256 settingsLimit) public Ownable(msg.sender) {
217         require(digexTokenAddr != address(0));
218 
219         token = IERC20(digexTokenAddr);
220         setParameters(newMinimum, newMaximum, newMinPercent, newMaxPercent);
221         yearSettingsLimit = settingsLimit;
222     }
223 
224     function receiveApproval(address from, uint256 amount, address tokenAddr, bytes calldata extraData) external {
225         require(tokenAddr == address(token));
226         if (extraData.length > 0) {
227             donate(from, amount);
228         } else {
229             invest(from, amount);
230         }
231     }
232 
233     function invest(address from, uint256 amount) public {
234         User storage user = _users[from];
235 
236         require(!finalized, "Staking is finalized already");
237         require(msg.sender == address(token) || msg.sender == from, "You can send only your tokens");
238         require(token.allowance(from, address(this)) >= amount, "Approve this token amount first");
239 
240         token.transferFrom(from, address(this), amount);
241 
242         if (user.deposit > 0) {
243             user.reserved = getDividends(from);
244         }
245 
246         user.checkpoint = now;
247         user.lastStage = getCurrentStage();
248 
249         user.deposit = user.deposit.add(amount);
250         _depositsBalance = _depositsBalance.add(amount);
251 
252         emit Invested(from, amount);
253     }
254 
255     fallback() external payable {
256         if (msg.value > 0) {
257             msg.sender.transfer(msg.value);
258         }
259 
260         if (msg.data.length > 0) {
261             if (_bytesToAddress(bytes(msg.data)) == msg.sender) {
262                 withdrawAll(msg.sender);
263             }
264         } else {
265             withdrawDividends(msg.sender);
266         }
267     }
268 
269     function donate(address from, uint256 amount) public {
270         require(msg.sender == address(token) || msg.sender == from, "You can send only your tokens");
271         require(token.allowance(from, address(this)) >= amount, "Approve this token amount first");
272 
273         token.transferFrom(from, address(this), amount);
274 
275         emit Donated(msg.sender, from, amount);
276     }
277 
278     function withdrawAll(address account) public {
279         require(msg.sender == account || msg.sender == _owner);
280 
281         withdrawDeposit(account);
282         if (_users[account].reserved > 0) {
283             withdrawDividends(account);
284         }
285     }
286 
287     function withdrawDeposit(address account) public {
288         require(msg.sender == account || msg.sender == _owner);
289 
290         User storage user = _users[account];
291 
292         uint256 deposit = user.deposit;
293         require(deposit > 0, "Account has no deposit");
294 
295         if (user.checkpoint < now) {
296             user.reserved = getDividends(account);
297             user.checkpoint = now;
298             user.lastStage = getCurrentStage();
299         }
300 
301         user.deposit = 0;
302         _depositsBalance = _depositsBalance.sub(deposit);
303 
304         token.transfer(account, deposit);
305 
306         emit DepositWithdrawn(msg.sender, account, deposit, user.reserved);
307     }
308 
309     function withdrawDividends(address account) public {
310         require(msg.sender == account || msg.sender == _owner);
311 
312         User storage user = _users[account];
313 
314         uint256 payout = getDividends(account);
315 
316         if (user.checkpoint < now) {
317             user.checkpoint = now;
318             user.lastStage = getCurrentStage();
319         }
320 
321         if (user.reserved > 0) {
322             user.reserved = 0;
323         }
324 
325         require(payout > 0, "Account has no dividends");
326 
327         uint256 remaining = getTokenBalanceOf(address(this)).sub(_depositsBalance);
328 
329         if (payout > remaining) {
330             user.reserved = user.reserved.add(payout - remaining);
331             payout = remaining;
332 
333             emit DividendsReserved(msg.sender, account, user.reserved);
334         }
335 
336         if (payout > 0) {
337             token.transfer(account, payout);
338 
339             emit DividendsWithdrawn(msg.sender, account, payout);
340         }
341     }
342 
343     function finilize() public onlyOwner {
344         Parameters memory current = _stages[getCurrentStage()];
345 
346         require(current.minPercent == 0 && current.maxPercent == 0 && now - current.timestamp >= 180 * ONE_DAY, "Only after 180 days of stopped state");
347 
348         uint256 balance = getTokenBalanceOf(address(this));
349         token.transfer(address(token), balance);
350 
351         finalized = true;
352 
353         emit TheEnd(balance);
354     }
355 
356     function setParameters(uint256 newMinimum, uint256 newMaximum, uint256 newMinPercent, uint256 newMaxPercent) public onlyOwner {
357         require(newMaximum >= newMinimum && newMaxPercent >= newMinPercent, "Maximum must be more or equal than minimum");
358         require(newMaxPercent <= 50, "maxPercent must be less or equal than 0.5");
359 
360         uint256 currentStage = getCurrentStage();
361         uint256 nextStage;
362         uint256 interval;
363 
364         if (_stages.length > 0) {
365             Parameters storage current = _stages[currentStage];
366 
367             require(newMinimum != current.minimum || newMaximum != current.maximum || newMinPercent != current.minPercent || newMaxPercent != current.maxPercent, "Nothing changes");
368 
369             nextStage = currentStage+1;
370             if (nextStage >= yearSettingsLimit) {
371                 require(now - _stages[nextStage - yearSettingsLimit].timestamp >= 365 * ONE_DAY, "Year-settings-limit overflow");
372             }
373 
374             if (current.interval == 0) {
375                 interval = now - current.timestamp;
376                 current.interval = interval;
377             }
378         }
379 
380         _stages.push(Parameters(newMinimum, newMaximum, newMinPercent, newMaxPercent, now, 0));
381 
382         emit SetParameters(nextStage, interval, newMinimum, newMaximum, newMinPercent, newMaxPercent);
383     }
384 
385     function addWhitelisteds(address[] memory accounts) public override onlyOwner {
386         for (uint256 i = 0; i < accounts.length; i++) {
387 
388             if (_users[accounts[i]].checkpoint < now) {
389                 _users[accounts[i]].reserved = getDividends(accounts[i]);
390                 _users[accounts[i]].checkpoint = now;
391                 _users[accounts[i]].lastStage = getCurrentStage();
392             }
393 
394             _whitelisteds.add(accounts[i]);
395             emit WhitelistedAdded(accounts[i]);
396         }
397     }
398 
399     function removeWhitelisteds(address[] memory accounts) public override onlyOwner {
400         for (uint256 i = 0; i < accounts.length; i++) {
401 
402             if (_users[accounts[i]].checkpoint < now) {
403                 _users[accounts[i]].reserved = getDividends(accounts[i]);
404                 _users[accounts[i]].checkpoint = now;
405                 _users[accounts[i]].lastStage = getCurrentStage();
406             }
407 
408             _whitelisteds.remove(accounts[i]);
409             emit WhitelistedRemoved(accounts[i]);
410         }
411     }
412 
413     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
414         require(ERC20Token != address(token));
415 
416         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
417         IERC20(ERC20Token).transfer(recipient, amount);
418 
419     }
420 
421     function getDeposit(address addr) public view returns(uint256) {
422         return _users[addr].deposit;
423     }
424 
425     function getPercent(uint256 deposit, uint256 stage) public view returns(uint256) {
426         Parameters memory par = _stages[stage];
427 
428         uint256 userPercent;
429 
430         if (deposit < par.minimum) {
431             userPercent = 0;
432         } else if (deposit >= par.maximum) {
433             userPercent = par.minPercent;
434         } else {
435             uint256 amount = deposit.sub(par.minimum);
436             userPercent = par.maxPercent.sub(amount.mul(par.maxPercent.sub(par.minPercent)).div(par.maximum.sub(par.minimum)));
437         }
438 
439         return userPercent;
440     }
441 
442     function getUserPercent(address addr) public view returns(uint256) {
443         if (isWhitelisted(addr)) {
444             return _stages[getCurrentStage()].maxPercent;
445         } else {
446             return getPercent(getDeposit(addr), getCurrentStage());
447         }
448     }
449 
450     function getDividends(address addr) public view returns(uint256) {
451         User storage user = _users[addr];
452 
453         uint256 currentStage = getCurrentStage();
454         uint256 payout = user.reserved;
455         uint256 percent;
456         uint256 deposit = user.deposit;
457 
458         if (user.lastStage == currentStage) {
459 
460             if (isWhitelisted(addr)) {
461                 percent = _stages[currentStage].maxPercent;
462             } else if (deposit > _stages[currentStage].maximum) {
463                 deposit = _stages[currentStage].maximum;
464                 percent = _stages[currentStage].minPercent;
465             } else {
466                 percent = getUserPercent(addr);
467             }
468 
469             payout += (deposit.mul(percent).div(ONE_HUNDRED)).mul(now.sub(user.checkpoint)).div(ONE_DAY);
470 
471         } else {
472 
473             uint256 i = currentStage.sub(user.lastStage);
474 
475             while (true) {
476 
477                 if (isWhitelisted(addr)) {
478                     percent = _stages[currentStage-i].maxPercent;
479                 } else if (deposit > _stages[currentStage].maximum) {
480                     deposit = _stages[currentStage-i].maximum;
481                     percent = _stages[currentStage-i].minPercent;
482                 } else {
483                     percent = getPercent(deposit, currentStage-i);
484                 }
485 
486                 if (currentStage-i == user.lastStage) {
487                     payout += (deposit.mul(percent).div(ONE_HUNDRED)).mul(_stages[user.lastStage+1].timestamp.sub(user.checkpoint)).div(ONE_DAY);
488                 } else if (_stages[currentStage-i].interval != 0) {
489                     payout += (deposit.mul(percent).div(ONE_HUNDRED)).mul(_stages[currentStage-i].interval).div(ONE_DAY);
490                 } else {
491                     payout += (deposit.mul(percent).div(ONE_HUNDRED)).mul(now.sub(_stages[currentStage].timestamp)).div(ONE_DAY);
492                     break;
493                 }
494 
495                 i--;
496             }
497 
498         }
499 
500         return payout;
501     }
502 
503     function getAvailable(address addr) public view returns(uint256) {
504         return getDeposit(addr).add(getDividends(addr));
505     }
506 
507     function getCurrentStage() public view returns(uint256) {
508         if (_stages.length > 0) {
509             return _stages.length-1;
510         }
511     }
512 
513     function getParameters(uint256 stage) public view returns(uint256 minimum, uint256 maximum, uint256 minPercent, uint256 maxPercent, uint256 timestamp, uint256 interval) {
514         Parameters memory par = _stages[stage];
515         return (par.minimum, par.maximum, par.minPercent, par.maxPercent, par.timestamp, par.interval);
516     }
517 
518     function getCurrentParameters() public view returns(uint256 minimum, uint256 maximum, uint256 minPercent, uint256 maxPercent, uint256 timestamp, uint256 interval) {
519         return getParameters(getCurrentStage());
520     }
521 
522     function getContractTokenBalance() public view returns(uint256 balance, uint256 deposits, uint256 dividends) {
523         balance = token.balanceOf(address(this));
524         deposits = _depositsBalance;
525         if (balance >= deposits) {
526             dividends = balance.sub(deposits);
527         }
528     }
529 
530     function getTokenBalanceOf(address account) public view returns(uint256) {
531         return token.balanceOf(account);
532     }
533 
534     function _bytesToAddress(bytes memory source) internal pure returns(address parsedAddr) {
535         assembly {
536             parsedAddr := mload(add(source,0x14))
537         }
538         return parsedAddr;
539     }
540 
541 }