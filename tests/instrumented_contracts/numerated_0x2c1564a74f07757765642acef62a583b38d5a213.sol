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
252     event WithdrawToken(address indexed from, address indexed to, uint256 value);
253 
254     /**
255      * @dev Constructor
256      */
257     constructor() public {
258         _minter[msg.sender] = true;
259         _allowWhitelistRegistration = true;
260 
261         emit WesionSaleWhitelistRegistrationEnabled();
262 
263         _referrer[msg.sender] = msg.sender;
264         emit WesionSaleWhitelistRegistered(msg.sender, msg.sender);
265     }
266 
267 
268     /**
269      * @dev donate
270      */
271     function () external payable {
272         emit Donate(msg.sender, msg.value);
273     }
274 
275 
276     /**
277      * @return the name of the token.
278      */
279     function name() public view returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @return the symbol of the token.
285      */
286     function symbol() public view returns (string memory) {
287         return _symbol;
288     }
289 
290     /**
291      * @return the number of decimals of the token.
292      */
293     function decimals() public view returns (uint8) {
294         return _decimals;
295     }
296 
297     /**
298      * @return the cap for the token minting.
299      */
300     function cap() public view returns (uint256) {
301         return _cap;
302     }
303 
304     /**
305      * @dev Total number of tokens in existence.
306      */
307     function totalSupply() public view returns (uint256) {
308         return _totalSupply;
309     }
310 
311     /**
312      * @dev Gets the balance of the specified address.
313      * @param owner The address to query the balance of.
314      * @return A uint256 representing the amount owned by the passed address.
315      */
316     function balanceOf(address owner) public view returns (uint256) {
317         return _balances[owner];
318     }
319 
320     /**
321      * @dev Function to check the amount of tokens that an owner allowed to a spender.
322      * @param owner address The address which owns the funds.
323      * @param spender address The address which will spend the funds.
324      * @return A uint256 specifying the amount of tokens still available for the spender.
325      */
326     function allowance(address owner, address spender) public view returns (uint256) {
327         return _allowed[owner][spender];
328     }
329 
330     /**
331      * @dev Transfer token to a specified address.
332      * @param to The address to transfer to.
333      * @param value The amount to be transferred.
334      */
335     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
336         if (_allowWhitelistRegistration && value == _whitelistRegistrationValue
337             && inWhitelist(to) && !inWhitelist(msg.sender) && isNotContract(msg.sender)) {
338             // Register whitelist for Wesion-Sale
339             _regWhitelist(msg.sender, to);
340             return true;
341         } else {
342             // Normal Transfer
343             _transfer(msg.sender, to, value);
344             return true;
345         }
346     }
347 
348     /**
349      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
350      * @param spender The address which will spend the funds.
351      * @param value The amount of tokens to be spent.
352      */
353     function approve(address spender, uint256 value) public returns (bool) {
354         _approve(msg.sender, spender, value);
355         return true;
356     }
357 
358     /**
359      * @dev Increase the amount of tokens that an owner allowed to a spender.
360      * @param spender The address which will spend the funds.
361      * @param addedValue The amount of tokens to increase the allowance by.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
364         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
365         return true;
366     }
367 
368     /**
369      * @dev Decrease the amount of tokens that an owner allowed to a spender.
370      * @param spender The address which will spend the funds.
371      * @param subtractedValue The amount of tokens to decrease the allowance by.
372      */
373     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
374         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
375         return true;
376     }
377     /**
378      * @dev Transfer tokens from one address to another.
379      * @param from address The address which you want to send tokens from
380      * @param to address The address which you want to transfer to
381      * @param value uint256 the amount of tokens to be transferred
382      */
383     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
384         require(_allowed[from][msg.sender] >= value);
385         _transfer(from, to, value);
386         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
387         return true;
388     }
389 
390     /**
391      * @dev Transfer token for a specified addresses.
392      * @param from The address to transfer from.
393      * @param to The address to transfer to.
394      * @param value The amount to be transferred.
395      */
396     function _transfer(address from, address to, uint256 value) internal {
397         require(to != address(0));
398 
399         _balances[from] = _balances[from].sub(value);
400         _balances[to] = _balances[to].add(value);
401         emit Transfer(from, to, value);
402     }
403 
404     /**
405      * @dev Approve an address to spend another addresses' tokens.
406      * @param owner The address that owns the tokens.
407      * @param spender The address that will spend the tokens.
408      * @param value The number of tokens that can be spent.
409      */
410     function _approve(address owner, address spender, uint256 value) internal {
411         require(owner != address(0));
412         require(spender != address(0));
413 
414         _allowed[owner][spender] = value;
415         emit Approval(owner, spender, value);
416     }
417 
418 
419     /**
420      * @dev Throws if called by account not a minter.
421      */
422     modifier onlyMinter() {
423         require(_minter[msg.sender]);
424         _;
425     }
426 
427     /**
428      * @dev Returns true if the given account is minter.
429      */
430     function isMinter(address account) public view returns (bool) {
431         return _minter[account];
432     }
433 
434     /**
435      * @dev Set a minter state
436      */
437     function setMinterState(address account, bool state) external onlyOwner {
438         _minter[account] = state;
439         emit MinterChanged(account, state);
440     }
441 
442     /**
443      * @dev Function to mint tokens
444      * @param to The address that will receive the minted tokens.
445      * @param value The amount of tokens to mint.
446      * @return A boolean that indicates if the operation was successful.
447      */
448     function mint(address to, uint256 value) public onlyMinter returns (bool) {
449         _mint(to, value);
450         return true;
451     }
452 
453     /**
454      * @dev Internal function that mints an amount of the token and assigns it to an account.
455      * @param account The account that will receive the created tokens.
456      * @param value The amount that will be created.
457      */
458     function _mint(address account, uint256 value) internal {
459         require(_totalSupply.add(value) <= _cap);
460         require(account != address(0));
461 
462         _totalSupply = _totalSupply.add(value);
463         _balances[account] = _balances[account].add(value);
464         emit Mint(account, value);
465         emit Transfer(address(0), account, value);
466     }
467 
468     /**
469      * @dev Throws if called by account not in whitelist.
470      */
471     modifier onlyInWhitelist() {
472         require(_referrer[msg.sender] != address(0));
473         _;
474     }
475 
476     /**
477      * @dev Returns true if the whitelist registration is allowed.
478      */
479     function allowWhitelistRegistration() public view returns (bool) {
480         return _allowWhitelistRegistration;
481     }
482 
483     /**
484      * @dev Returns true if the given account is in whitelist.
485      */
486     function inWhitelist(address account) public view returns (bool) {
487         return _referrer[account] != address(0);
488     }
489 
490     /**
491      * @dev Returns the referrer of a given account address
492      */
493     function referrer(address account) public view returns (address) {
494         return _referrer[account];
495     }
496 
497     /**
498      * @dev Returns the referrals count of a given account address
499      */
500     function refCount(address account) public view returns (uint256) {
501         return _refCount[account];
502     }
503 
504     /**
505      * @dev Disable Wesion-Sale whitelist registration. Unrecoverable!
506      */
507     function disableWesionSaleWhitelistRegistration() external onlyOwner {
508         _allowWhitelistRegistration = false;
509         emit WesionSaleWhitelistRegistrationDisabled();
510     }
511 
512     /**
513      * @dev Register whitelist for Wesion-Sale
514      */
515     function _regWhitelist(address account, address refAccount) internal {
516         _refCount[refAccount] = _refCount[refAccount].add(1);
517         _referrer[account] = refAccount;
518 
519         emit WesionSaleWhitelistRegistered(account, refAccount);
520 
521         // Whitelist Registration Referral Reward
522         _transfer(msg.sender, address(this), _whitelistRegistrationValue);
523         address cursor = account;
524         uint256 remain = _whitelistRegistrationValue;
525         uint256 _rebackToContract = 0;
526         for(uint i = 0; i < _whitelistRefRewards.length; i++) {
527             address receiver = _referrer[cursor];
528 
529             if (cursor != receiver) {
530                 if (_refCount[receiver] > i) {
531                     _transfer(address(this), receiver, _whitelistRefRewards[i]);
532                     remain = remain.sub(_whitelistRefRewards[i]);
533                 }
534                 else {
535                     _rebackToContract = _rebackToContract.add(_whitelistRefRewards[i]);
536                     remain = remain.sub(_whitelistRefRewards[i]);
537                     continue;
538                 }
539             } else {
540                 _rebackToContract = _rebackToContract.add(remain);
541                 break;
542             }
543 
544             cursor = _referrer[cursor];
545         }
546 
547         if (_rebackToContract > 0) {
548             _transfer(address(this), address(this), _rebackToContract);
549         }
550     }
551 
552     /**
553      * @dev Transfer the whitelisted address to another.
554      */
555     function transferWhitelist(address account) external onlyInWhitelist {
556         require(isNotContract(account));
557 
558         _refCount[account] = _refCount[msg.sender];
559         _refCount[msg.sender] = 0;
560         _referrer[account] = _referrer[msg.sender];
561         _referrer[msg.sender] = address(0);
562         emit WesionSaleWhitelistTransferred(msg.sender, account);
563     }
564 
565     /**
566      * @dev Returns true if the given address is not a contract
567      */
568     function isNotContract(address addr) internal view returns (bool) {
569         uint size;
570         assembly {
571             size := extcodesize(addr)
572         }
573         return size == 0;
574     }
575 
576     /**
577      * @dev Calculator
578      * Returns the reward amount if someone now registers the whitelist directly with the given whitelistedAccount.
579      */
580     function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {
581         if (!inWhitelist(whitelistedAccount)) {
582             return 0;
583         }
584 
585         address cursor = whitelistedAccount;
586         uint256 remain = _whitelistRegistrationValue;
587         for(uint i = 1; i < _whitelistRefRewards.length; i++) {
588             address receiver = _referrer[cursor];
589 
590             if (cursor != receiver) {
591                 if (_refCount[receiver] > i) {
592                     remain = remain.sub(_whitelistRefRewards[i]);
593                 }
594             } else {
595                 reward = reward.add(remain);
596                 break;
597             }
598 
599             cursor = _referrer[cursor];
600         }
601 
602         return reward;
603     }
604 
605     /**
606      * @dev owner can transfer the token store in this contract address.
607      */
608     function withdrawToken(address _to, uint256 _value) public onlyOwner {
609         require (_value > 0);
610         require (_to != address(0));
611         _transfer(address(this), _to, _value);
612         emit WithdrawToken(address(this), _to, _value);
613     }
614 
615 }