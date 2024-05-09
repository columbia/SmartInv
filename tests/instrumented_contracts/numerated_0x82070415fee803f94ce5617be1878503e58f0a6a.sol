1 pragma solidity ^0.5.7;
2 
3 
4 // Vision.Network 100G Token -- is called "Voken" (upgraded)
5 // 
6 // More info:
7 //   https://vision.network
8 //   https://voken.io
9 //
10 // Contact us:
11 //   support@vision.network
12 //   support@voken.io
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Unsigned math operations with safety checks that revert on error.
18  */
19 library SafeMath {
20     /**
21      * @dev Adds two unsigned integers, reverts on overflow.
22      */
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     /**
30      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     /**
38      * @dev Multiplies two unsigned integers, reverts on overflow.
39      */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
41         if (a == 0) {
42             return 0;
43         }
44         c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient,
51      * reverts on division by zero.
52      */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         assert(b > 0);
55         uint256 c = a / b;
56         assert(a == b * c + a % b);
57         return a / b;
58     }
59 
60     /**
61      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62      * reverts when dividing by zero.
63      */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://eips.ethereum.org/EIPS/eip-20
74  */
75 interface IERC20{
76     function name() external view returns (string memory);
77     function symbol() external view returns (string memory);
78     function decimals() external view returns (uint8);
79     function totalSupply() external view returns (uint256);
80     function balanceOf(address owner) external view returns (uint256);
81     function transfer(address to, uint256 value) external returns (bool);
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83     function approve(address spender, uint256 value) external returns (bool);
84     function allowance(address owner, address spender) external view returns (uint256);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 /**
91  * @title Ownable
92  */
93 contract Ownable {
94     address internal _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev The Ownable constructor sets the original `owner` of the contract
100      * to the sender account.
101      */
102     constructor () internal {
103         _owner = msg.sender;
104         emit OwnershipTransferred(address(0), _owner);
105     }
106 
107     /**
108      * @return the address of the owner.
109      */
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(msg.sender == _owner);
119         _;
120     }
121 
122     /**
123      * @dev Allows the current owner to transfer control of the contract to a newOwner.
124      * @param newOwner The address to transfer ownership to.
125      */
126     function transferOwnership(address newOwner) external onlyOwner {
127         require(newOwner != address(0));
128         _owner = newOwner;
129         emit OwnershipTransferred(_owner, newOwner);
130     }
131 
132     /**
133      * @dev Rescue compatible ERC20 Token
134      *
135      * @param tokenAddr ERC20 The address of the ERC20 token contract
136      * @param receiver The address of the receiver
137      * @param amount uint256
138      */
139     function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
140         IERC20 _token = IERC20(tokenAddr);
141         require(receiver != address(0));
142         uint256 balance = _token.balanceOf(address(this));
143         
144         require(balance >= amount);
145         assert(_token.transfer(receiver, amount));
146     }
147 
148     /**
149      * @dev Withdraw Ether
150      */
151     function withdrawEther(address payable to, uint256 amount) external onlyOwner {
152         require(to != address(0));
153         
154         uint256 balance = address(this).balance;
155         
156         require(balance >= amount);
157         to.transfer(amount);
158     }
159 }
160 
161 /**
162  * @title Pausable
163  * @dev Base contract which allows children to implement an emergency stop mechanism.
164  */
165 contract Pausable is Ownable {
166     bool private _paused;
167 
168     event Paused(address account);
169     event Unpaused(address account);
170 
171     constructor () internal {
172         _paused = false;
173     }
174 
175     /**
176      * @return Returns true if the contract is paused, false otherwise.
177      */
178     function paused() public view returns (bool) {
179         return _paused;
180     }
181 
182     /**
183      * @dev Modifier to make a function callable only when the contract is not paused.
184      */
185     modifier whenNotPaused() {
186         require(!_paused);
187         _;
188     }
189 
190     /**
191      * @dev Modifier to make a function callable only when the contract is paused.
192      */
193     modifier whenPaused() {
194         require(_paused);
195         _;
196     }
197 
198     /**
199      * @dev Called by a pauser to pause, triggers stopped state.
200      */
201     function pause() external onlyOwner whenNotPaused {
202         _paused = true;
203         emit Paused(msg.sender);
204     }
205 
206     /**
207      * @dev Called by a pauser to unpause, returns to normal state.
208      */
209     function unpause() external onlyOwner whenPaused {
210         _paused = false;
211         emit Unpaused(msg.sender);
212     }
213 }
214 
215 /**
216  * @title Voken Main Contract
217  */
218 contract Voken is Ownable, Pausable, IERC20 {
219     using SafeMath for uint256;
220 
221     string private _name = "Vision.Network 100G Token";
222     string private _symbol = "Voken";
223     uint8 private _decimals = 6;                // 6 decimals
224     uint256 private _cap = 35000000000000000;   // 35 billion cap, that is 35000000000.000000
225     uint256 private _totalSupply;
226     
227     mapping (address => bool) private _minter;
228     event Mint(address indexed to, uint256 value);
229     event MinterChanged(address account, bool state);
230 
231     mapping (address => uint256) private _balances;
232     mapping (address => mapping (address => uint256)) private _allowed;
233 
234     bool private _allowWhitelistRegistration;
235     mapping(address => address) private _referrer;
236     mapping(address => uint256) private _refCount;
237 
238     event VokenSaleWhitelistRegistered(address indexed addr, address indexed refAddr);
239     event VokenSaleWhitelistTransferred(address indexed previousAddr, address indexed _newAddr);
240     event VokenSaleWhitelistRegistrationEnabled();
241     event VokenSaleWhitelistRegistrationDisabled();
242 
243     uint256 private _whitelistRegistrationValue = 1001000000;   // 1001 Voken, 1001.000000
244     uint256[15] private _whitelistRefRewards = [                // 100% Reward
245         301000000,  // 301 Voken for Level.1
246         200000000,  // 200 Voken for Level.2
247         100000000,  // 100 Voken for Level.3
248         100000000,  // 100 Voken for Level.4
249         100000000,  // 100 Voken for Level.5
250         50000000,   //  50 Voken for Level.6
251         40000000,   //  40 Voken for Level.7
252         30000000,   //  30 Voken for Level.8
253         20000000,   //  20 Voken for Level.9
254         10000000,   //  10 Voken for Level.10
255         10000000,   //  10 Voken for Level.11
256         10000000,   //  10 Voken for Level.12
257         10000000,   //  10 Voken for Level.13
258         10000000,   //  10 Voken for Level.14
259         10000000    //  10 Voken for Level.15
260     ];
261 
262     event Donate(address indexed account, uint256 amount);
263 
264 
265     /**
266      * @dev Constructor
267      */
268     constructor() public {
269         _minter[msg.sender] = true;
270         _allowWhitelistRegistration = true;
271 
272         emit VokenSaleWhitelistRegistrationEnabled();
273 
274         _referrer[msg.sender] = msg.sender;
275         emit VokenSaleWhitelistRegistered(msg.sender, msg.sender);
276     }
277 
278 
279     /**
280      * @dev donate
281      */
282     function () external payable {
283         emit Donate(msg.sender, msg.value);
284     }
285 
286 
287     /**
288      * @return the name of the token.
289      */
290     function name() public view returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @return the symbol of the token.
296      */
297     function symbol() public view returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @return the number of decimals of the token.
303      */
304     function decimals() public view returns (uint8) {
305         return _decimals;
306     }
307 
308     /**
309      * @return the cap for the token minting.
310      */
311     function cap() public view returns (uint256) {
312         return _cap;
313     }
314     
315     /**
316      * @dev Total number of tokens in existence.
317      */
318     function totalSupply() public view returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev Gets the balance of the specified address.
324      * @param owner The address to query the balance of.
325      * @return A uint256 representing the amount owned by the passed address.
326      */
327     function balanceOf(address owner) public view returns (uint256) {
328         return _balances[owner];
329     }
330 
331     /**
332      * @dev Function to check the amount of tokens that an owner allowed to a spender.
333      * @param owner address The address which owns the funds.
334      * @param spender address The address which will spend the funds.
335      * @return A uint256 specifying the amount of tokens still available for the spender.
336      */
337     function allowance(address owner, address spender) public view returns (uint256) {
338         return _allowed[owner][spender];
339     }
340 
341     /**
342      * @dev Transfer token to a specified address.
343      * @param to The address to transfer to.
344      * @param value The amount to be transferred.
345      */
346     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
347         if (_allowWhitelistRegistration && value == _whitelistRegistrationValue
348             && inWhitelist(to) && !inWhitelist(msg.sender) && isNotContract(msg.sender)) {
349             // Register whitelist for Voken-Sale
350             _regWhitelist(msg.sender, to);
351             return true;
352         } else {
353             // Normal Transfer
354             _transfer(msg.sender, to, value);
355             return true;
356         }
357     }
358 
359     /**
360      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
361      * @param spender The address which will spend the funds.
362      * @param value The amount of tokens to be spent.
363      */
364     function approve(address spender, uint256 value) public returns (bool) {
365         _approve(msg.sender, spender, value);
366         return true;
367     }
368 
369     /**
370      * @dev Increase the amount of tokens that an owner allowed to a spender.
371      * @param spender The address which will spend the funds.
372      * @param addedValue The amount of tokens to increase the allowance by.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Decrease the amount of tokens that an owner allowed to a spender.
381      * @param spender The address which will spend the funds.
382      * @param subtractedValue The amount of tokens to decrease the allowance by.
383      */
384     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
385         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
386         return true;
387     }
388     /**
389      * @dev Transfer tokens from one address to another.
390      * @param from address The address which you want to send tokens from
391      * @param to address The address which you want to transfer to
392      * @param value uint256 the amount of tokens to be transferred
393      */
394     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
395         require(_allowed[from][msg.sender] >= value);
396         _transfer(from, to, value);
397         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
398         return true;
399     }
400 
401     /**
402      * @dev Transfer token for a specified addresses.
403      * @param from The address to transfer from.
404      * @param to The address to transfer to.
405      * @param value The amount to be transferred.
406      */
407     function _transfer(address from, address to, uint256 value) internal {
408         require(to != address(0));
409 
410         _balances[from] = _balances[from].sub(value);
411         _balances[to] = _balances[to].add(value);
412         emit Transfer(from, to, value);
413     }
414 
415     /**
416      * @dev Approve an address to spend another addresses' tokens.
417      * @param owner The address that owns the tokens.
418      * @param spender The address that will spend the tokens.
419      * @param value The number of tokens that can be spent.
420      */
421     function _approve(address owner, address spender, uint256 value) internal {
422         require(owner != address(0));
423         require(spender != address(0));
424 
425         _allowed[owner][spender] = value;
426         emit Approval(owner, spender, value);
427     }
428 
429 
430     /**
431      * @dev Throws if called by account not a minter.
432      */
433     modifier onlyMinter() {
434         require(_minter[msg.sender]);
435         _;
436     }
437 
438     /**
439      * @dev Returns true if the given account is minter.
440      */
441     function isMinter(address account) public view returns (bool) {
442         return _minter[account];
443     }
444 
445     /**
446      * @dev Set a minter state
447      */
448     function setMinterState(address account, bool state) external onlyOwner {
449         _minter[account] = state;
450         emit MinterChanged(account, state);
451     }
452 
453     /**
454      * @dev Function to mint tokens
455      * @param to The address that will receive the minted tokens.
456      * @param value The amount of tokens to mint.
457      * @return A boolean that indicates if the operation was successful.
458      */
459     function mint(address to, uint256 value) public onlyMinter returns (bool) {
460         _mint(to, value);
461         return true;
462     }
463 
464     /**
465      * @dev Internal function that mints an amount of the token and assigns it to an account.
466      * @param account The account that will receive the created tokens.
467      * @param value The amount that will be created.
468      */
469     function _mint(address account, uint256 value) internal {
470         require(_totalSupply.add(value) <= _cap);
471         require(account != address(0));
472 
473         _totalSupply = _totalSupply.add(value);
474         _balances[account] = _balances[account].add(value);
475         emit Mint(account, value);
476         emit Transfer(address(0), account, value);
477     }
478 
479     /**
480      * @dev Throws if called by account not in whitelist.
481      */
482     modifier onlyInWhitelist() {
483         require(_referrer[msg.sender] != address(0));
484         _;
485     }
486 
487     /**
488      * @dev Returns true if the whitelist registration is allowed.
489      */
490     function allowWhitelistRegistration() public view returns (bool) {
491         return _allowWhitelistRegistration;
492     }
493 
494     /**
495      * @dev Returns true if the given account is in whitelist.
496      */
497     function inWhitelist(address account) public view returns (bool) {
498         return _referrer[account] != address(0);
499     }
500 
501     /**
502      * @dev Returns the referrer of a given account address
503      */
504     function referrer(address account) public view returns (address) {
505         return _referrer[account];
506     }
507 
508     /**
509      * @dev Returns the referrals count of a given account address
510      */
511     function refCount(address account) public view returns (uint256) {
512         return _refCount[account];
513     }
514 
515     /**
516      * @dev Disable Voken-Sale whitelist registration. Unrecoverable!
517      */
518     function disableVokenSaleWhitelistRegistration() external onlyOwner {
519         _allowWhitelistRegistration = false;
520         emit VokenSaleWhitelistRegistrationDisabled();
521     }
522 
523     /**
524      * @dev Register whitelist for Voken-Sale
525      */
526     function _regWhitelist(address account, address refAccount) internal {
527         _refCount[refAccount] = _refCount[refAccount].add(1);
528         _referrer[account] = refAccount;
529 
530         emit VokenSaleWhitelistRegistered(account, refAccount);
531 
532         // Whitelist Registration Referral Reward
533         _transfer(msg.sender, address(this), _whitelistRegistrationValue);
534         address cursor = account;
535         uint256 remain = _whitelistRegistrationValue;
536         for(uint i = 0; i < _whitelistRefRewards.length; i++) {
537             address receiver = _referrer[cursor];
538 
539             if (cursor != receiver) {
540                 if (_refCount[receiver] > i) {
541                     _transfer(address(this), receiver, _whitelistRefRewards[i]);
542                     remain = remain.sub(_whitelistRefRewards[i]);
543                 }
544             } else {
545                 _transfer(address(this), refAccount, remain);
546                 break;
547             }
548 
549             cursor = _referrer[cursor];
550         }
551     }
552 
553     /**
554      * @dev Transfer the whitelisted address to another.
555      */
556     function transferWhitelist(address account) external onlyInWhitelist {
557         require(isNotContract(account));
558 
559         _refCount[account] = _refCount[msg.sender];
560         _refCount[msg.sender] = 0;
561         _referrer[account] = _referrer[msg.sender];
562         _referrer[msg.sender] = address(0);
563         emit VokenSaleWhitelistTransferred(msg.sender, account);
564     }
565 
566     /**
567      * @dev Returns true if the given address is not a contract
568      */
569     function isNotContract(address addr) internal view returns (bool) {
570         uint size;
571         assembly {
572             size := extcodesize(addr)
573         }
574         return size == 0;
575     }
576 
577     /**
578      * @dev Calculator
579      * Returns the reward amount if someone now registers the whitelist directly with the given whitelistedAccount.
580      */
581     function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {
582         if (!inWhitelist(whitelistedAccount)) {
583             return 0;
584         }
585 
586         address cursor = whitelistedAccount;
587         uint256 remain = _whitelistRegistrationValue;
588         for(uint i = 1; i < _whitelistRefRewards.length; i++) {
589             address receiver = _referrer[cursor];
590 
591             if (cursor != receiver) {
592                 if (_refCount[receiver] > i) {
593                     remain = remain.sub(_whitelistRefRewards[i]);
594                 }
595             } else {
596                 reward = reward.add(remain);
597                 break;
598             }
599 
600             cursor = _referrer[cursor];
601         }
602 
603         return reward;
604     }
605 }