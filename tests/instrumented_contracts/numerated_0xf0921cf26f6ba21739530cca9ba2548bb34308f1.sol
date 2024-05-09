1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Adds two unsigned integers, reverts on overflow.
10      */
11     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         c = a + b;
13         assert(c >= a);
14         return c;
15     }
16 
17     /**
18      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
19      */
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     /**
26      * @dev Multiplies two unsigned integers, reverts on overflow.
27      */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29         if (a == 0) {
30             return 0;
31         }
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     /**
38      * @dev Integer division of two unsigned integers truncating the quotient,
39      * reverts on division by zero.
40      */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b > 0);
43         uint256 c = a / b;
44         assert(a == b * c + a % b);
45         return a / b;
46     }
47 
48     /**
49      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
50      * reverts when dividing by zero.
51      */
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0);
54         return a % b;
55     }
56 }
57 
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://eips.ethereum.org/EIPS/eip-20
62  */
63 interface IERC20{
64     function name() external view returns (string memory);
65     function symbol() external view returns (string memory);
66     function decimals() external view returns (uint8);
67     function totalSupply() external view returns (uint256);
68     function balanceOf(address owner) external view returns (uint256);
69     function transfer(address to, uint256 value) external returns (bool);
70     function transferFrom(address from, address to, uint256 value) external returns (bool);
71     function approve(address spender, uint256 value) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 /**
79  * @title Ownable
80  */
81 contract Ownable {
82     address internal _owner;
83 
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     /**
87      * @dev The Ownable constructor sets the original `owner` of the contract
88      * to the sender account.
89      */
90     constructor () internal {
91         _owner = msg.sender;
92         emit OwnershipTransferred(address(0), _owner);
93     }
94 
95     /**
96      * @return the address of the owner.
97      */
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOwner() {
106         require(msg.sender == _owner);
107         _;
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address newOwner) external onlyOwner {
115         require(newOwner != address(0));
116         _owner = newOwner;
117         emit OwnershipTransferred(_owner, newOwner);
118     }
119 
120     /**
121      * @dev Rescue compatible ERC20 Token
122      *
123      * @param tokenAddr ERC20 The address of the ERC20 token contract
124      * @param receiver The address of the receiver
125      * @param amount uint256
126      */
127     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
128         IERC20 _token = IERC20(tokenAddr);
129         require(receiver != address(0));
130         uint256 balance = _token.balanceOf(address(this));
131 
132         require(balance >= amount);
133         assert(_token.transfer(receiver, amount));
134     }
135 
136     /**
137      * @dev Withdraw Ether
138      */
139     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
140         require(to != address(0));
141 
142         uint256 balance = address(this).balance;
143 
144         require(balance >= amount);
145         to.transfer(amount);
146     }
147 }
148 
149 /**
150  * @title Pausable
151  * @dev Base contract which allows children to implement an emergency stop mechanism.
152  */
153 contract Pausable is Ownable {
154     bool private _paused;
155 
156     event Paused(address account);
157     event Unpaused(address account);
158 
159     constructor () internal {
160         _paused = false;
161     }
162 
163     /**
164      * @return Returns true if the contract is paused, false otherwise.
165      */
166     function paused() public view returns (bool) {
167         return _paused;
168     }
169 
170     /**
171      * @dev Modifier to make a function callable only when the contract is not paused.
172      */
173     modifier whenNotPaused() {
174         require(!_paused);
175         _;
176     }
177 
178     /**
179      * @dev Modifier to make a function callable only when the contract is paused.
180      */
181     modifier whenPaused() {
182         require(_paused);
183         _;
184     }
185 
186     /**
187      * @dev Called by a pauser to pause, triggers stopped state.
188      */
189     function pause() external onlyOwner whenNotPaused {
190         _paused = true;
191         emit Paused(msg.sender);
192     }
193 
194     /**
195      * @dev Called by a pauser to unpause, returns to normal state.
196      */
197     function unpause() external onlyOwner whenPaused {
198         _paused = false;
199         emit Unpaused(msg.sender);
200     }
201 }
202 
203 /**
204  * @title Wesion Main Contract
205  */
206 contract Wesion is Ownable, Pausable, IERC20 {
207     using SafeMath for uint256;
208 
209     string private _name = "Wesion";
210     string private _symbol = "Wesion";
211     uint8 private _decimals = 6;                // 6 decimals
212     uint256 private _cap = 35000000000000000;   // 35 billion cap, that is 35000000000.000000
213     uint256 private _totalSupply;
214 
215     mapping (address => bool) private _minter;
216     event Mint(address indexed to, uint256 value);
217     event MinterChanged(address account, bool state);
218 
219     mapping (address => uint256) private _balances;
220     mapping (address => mapping (address => uint256)) private _allowed;
221 
222     bool private _allowWhitelistRegistration;
223     mapping(address => address) private _referrer;
224     mapping(address => uint256) private _refCount;
225 
226     event WesionSaleWhitelistRegistered(address indexed addr, address indexed refAddr);
227     event WesionSaleWhitelistTransferred(address indexed previousAddr, address indexed _newAddr);
228     event WesionSaleWhitelistRegistrationEnabled();
229     event WesionSaleWhitelistRegistrationDisabled();
230 
231     uint256 private _whitelistRegistrationValue = 1001000000;   // 1001 Wesion, 1001.000000
232     uint256[15] private _whitelistRefRewards = [                // 100% Reward
233         301000000,  // 301 Wesion for Level.1
234         200000000,  // 200 Wesion for Level.2
235         100000000,  // 100 Wesion for Level.3
236         100000000,  // 100 Wesion for Level.4
237         100000000,  // 100 Wesion for Level.5
238         50000000,   //  50 Wesion for Level.6
239         40000000,   //  40 Wesion for Level.7
240         30000000,   //  30 Wesion for Level.8
241         20000000,   //  20 Wesion for Level.9
242         10000000,   //  10 Wesion for Level.10
243         10000000,   //  10 Wesion for Level.11
244         10000000,   //  10 Wesion for Level.12
245         10000000,   //  10 Wesion for Level.13
246         10000000,   //  10 Wesion for Level.14
247         10000000    //  10 Wesion for Level.15
248     ];
249 
250     event Donate(address indexed account, uint256 amount);
251 
252 
253     /**
254      * @dev Constructor
255      */
256     constructor() public {
257         _minter[msg.sender] = true;
258         _allowWhitelistRegistration = true;
259 
260         emit WesionSaleWhitelistRegistrationEnabled();
261 
262         _referrer[msg.sender] = msg.sender;
263         emit WesionSaleWhitelistRegistered(msg.sender, msg.sender);
264     }
265 
266 
267     /**
268      * @dev donate
269      */
270     function () external payable {
271         emit Donate(msg.sender, msg.value);
272     }
273 
274 
275     /**
276      * @return the name of the token.
277      */
278     function name() public view returns (string memory) {
279         return _name;
280     }
281 
282     /**
283      * @return the symbol of the token.
284      */
285     function symbol() public view returns (string memory) {
286         return _symbol;
287     }
288 
289     /**
290      * @return the number of decimals of the token.
291      */
292     function decimals() public view returns (uint8) {
293         return _decimals;
294     }
295 
296     /**
297      * @return the cap for the token minting.
298      */
299     function cap() public view returns (uint256) {
300         return _cap;
301     }
302 
303     /**
304      * @dev Total number of tokens in existence.
305      */
306     function totalSupply() public view returns (uint256) {
307         return _totalSupply;
308     }
309 
310     /**
311      * @dev Gets the balance of the specified address.
312      * @param owner The address to query the balance of.
313      * @return A uint256 representing the amount owned by the passed address.
314      */
315     function balanceOf(address owner) public view returns (uint256) {
316         return _balances[owner];
317     }
318 
319     /**
320      * @dev Function to check the amount of tokens that an owner allowed to a spender.
321      * @param owner address The address which owns the funds.
322      * @param spender address The address which will spend the funds.
323      * @return A uint256 specifying the amount of tokens still available for the spender.
324      */
325     function allowance(address owner, address spender) public view returns (uint256) {
326         return _allowed[owner][spender];
327     }
328 
329     /**
330      * @dev Transfer token to a specified address.
331      * @param to The address to transfer to.
332      * @param value The amount to be transferred.
333      */
334     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
335         if (_allowWhitelistRegistration && value == _whitelistRegistrationValue
336             && inWhitelist(to) && !inWhitelist(msg.sender) && isNotContract(msg.sender)) {
337             // Register whitelist for Wesion-Sale
338             _regWhitelist(msg.sender, to);
339             return true;
340         } else {
341             // Normal Transfer
342             _transfer(msg.sender, to, value);
343             return true;
344         }
345     }
346 
347     /**
348      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
349      * @param spender The address which will spend the funds.
350      * @param value The amount of tokens to be spent.
351      */
352     function approve(address spender, uint256 value) public returns (bool) {
353         _approve(msg.sender, spender, value);
354         return true;
355     }
356 
357     /**
358      * @dev Increase the amount of tokens that an owner allowed to a spender.
359      * @param spender The address which will spend the funds.
360      * @param addedValue The amount of tokens to increase the allowance by.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
363         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
364         return true;
365     }
366 
367     /**
368      * @dev Decrease the amount of tokens that an owner allowed to a spender.
369      * @param spender The address which will spend the funds.
370      * @param subtractedValue The amount of tokens to decrease the allowance by.
371      */
372     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
373         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
374         return true;
375     }
376     /**
377      * @dev Transfer tokens from one address to another.
378      * @param from address The address which you want to send tokens from
379      * @param to address The address which you want to transfer to
380      * @param value uint256 the amount of tokens to be transferred
381      */
382     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
383         require(_allowed[from][msg.sender] >= value);
384         _transfer(from, to, value);
385         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
386         return true;
387     }
388 
389     /**
390      * @dev Transfer token for a specified addresses.
391      * @param from The address to transfer from.
392      * @param to The address to transfer to.
393      * @param value The amount to be transferred.
394      */
395     function _transfer(address from, address to, uint256 value) internal {
396         require(to != address(0));
397 
398         _balances[from] = _balances[from].sub(value);
399         _balances[to] = _balances[to].add(value);
400         emit Transfer(from, to, value);
401     }
402 
403     /**
404      * @dev Approve an address to spend another addresses' tokens.
405      * @param owner The address that owns the tokens.
406      * @param spender The address that will spend the tokens.
407      * @param value The number of tokens that can be spent.
408      */
409     function _approve(address owner, address spender, uint256 value) internal {
410         require(owner != address(0));
411         require(spender != address(0));
412 
413         _allowed[owner][spender] = value;
414         emit Approval(owner, spender, value);
415     }
416 
417 
418     /**
419      * @dev Throws if called by account not a minter.
420      */
421     modifier onlyMinter() {
422         require(_minter[msg.sender]);
423         _;
424     }
425 
426     /**
427      * @dev Returns true if the given account is minter.
428      */
429     function isMinter(address account) public view returns (bool) {
430         return _minter[account];
431     }
432 
433     /**
434      * @dev Set a minter state
435      */
436     function setMinterState(address account, bool state) external onlyOwner {
437         _minter[account] = state;
438         emit MinterChanged(account, state);
439     }
440 
441     /**
442      * @dev Function to mint tokens
443      * @param to The address that will receive the minted tokens.
444      * @param value The amount of tokens to mint.
445      * @return A boolean that indicates if the operation was successful.
446      */
447     function mint(address to, uint256 value) public onlyMinter returns (bool) {
448         _mint(to, value);
449         return true;
450     }
451 
452     /**
453      * @dev Internal function that mints an amount of the token and assigns it to an account.
454      * @param account The account that will receive the created tokens.
455      * @param value The amount that will be created.
456      */
457     function _mint(address account, uint256 value) internal {
458         require(_totalSupply.add(value) <= _cap);
459         require(account != address(0));
460 
461         _totalSupply = _totalSupply.add(value);
462         _balances[account] = _balances[account].add(value);
463         emit Mint(account, value);
464         emit Transfer(address(0), account, value);
465     }
466 
467     /**
468      * @dev Throws if called by account not in whitelist.
469      */
470     modifier onlyInWhitelist() {
471         require(_referrer[msg.sender] != address(0));
472         _;
473     }
474 
475     /**
476      * @dev Returns true if the whitelist registration is allowed.
477      */
478     function allowWhitelistRegistration() public view returns (bool) {
479         return _allowWhitelistRegistration;
480     }
481 
482     /**
483      * @dev Returns true if the given account is in whitelist.
484      */
485     function inWhitelist(address account) public view returns (bool) {
486         return _referrer[account] != address(0);
487     }
488 
489     /**
490      * @dev Returns the referrer of a given account address
491      */
492     function referrer(address account) public view returns (address) {
493         return _referrer[account];
494     }
495 
496     /**
497      * @dev Returns the referrals count of a given account address
498      */
499     function refCount(address account) public view returns (uint256) {
500         return _refCount[account];
501     }
502 
503     /**
504      * @dev Disable Wesion-Sale whitelist registration. Unrecoverable!
505      */
506     function disableWesionSaleWhitelistRegistration() external onlyOwner {
507         _allowWhitelistRegistration = false;
508         emit WesionSaleWhitelistRegistrationDisabled();
509     }
510 
511     /**
512      * @dev Register whitelist for Wesion-Sale
513      */
514     function _regWhitelist(address account, address refAccount) internal {
515         _refCount[refAccount] = _refCount[refAccount].add(1);
516         _referrer[account] = refAccount;
517 
518         emit WesionSaleWhitelistRegistered(account, refAccount);
519 
520         // Whitelist Registration Referral Reward
521         _transfer(msg.sender, address(this), _whitelistRegistrationValue);
522         address cursor = account;
523         uint256 remain = _whitelistRegistrationValue;
524         for(uint i = 0; i < _whitelistRefRewards.length; i++) {
525             address receiver = _referrer[cursor];
526 
527             if (cursor != receiver) {
528                 if (_refCount[receiver] > i) {
529                     _transfer(address(this), receiver, _whitelistRefRewards[i]);
530                     remain = remain.sub(_whitelistRefRewards[i]);
531                 }
532             } else {
533                 _transfer(address(this), refAccount, remain);
534                 break;
535             }
536 
537             cursor = _referrer[cursor];
538         }
539     }
540 
541     /**
542      * @dev Transfer the whitelisted address to another.
543      */
544     function transferWhitelist(address account) external onlyInWhitelist {
545         require(isNotContract(account));
546 
547         _refCount[account] = _refCount[msg.sender];
548         _refCount[msg.sender] = 0;
549         _referrer[account] = _referrer[msg.sender];
550         _referrer[msg.sender] = address(0);
551         emit WesionSaleWhitelistTransferred(msg.sender, account);
552     }
553 
554     /**
555      * @dev Returns true if the given address is not a contract
556      */
557     function isNotContract(address addr) internal view returns (bool) {
558         uint size;
559         assembly {
560             size := extcodesize(addr)
561         }
562         return size == 0;
563     }
564 
565     /**
566      * @dev Calculator
567      * Returns the reward amount if someone now registers the whitelist directly with the given whitelistedAccount.
568      */
569     function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {
570         if (!inWhitelist(whitelistedAccount)) {
571             return 0;
572         }
573 
574         address cursor = whitelistedAccount;
575         uint256 remain = _whitelistRegistrationValue;
576         for(uint i = 1; i < _whitelistRefRewards.length; i++) {
577             address receiver = _referrer[cursor];
578 
579             if (cursor != receiver) {
580                 if (_refCount[receiver] > i) {
581                     remain = remain.sub(_whitelistRefRewards[i]);
582                 }
583             } else {
584                 reward = reward.add(remain);
585                 break;
586             }
587 
588             cursor = _referrer[cursor];
589         }
590 
591         return reward;
592     }
593 }