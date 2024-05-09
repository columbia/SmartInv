1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 interface IERC20 {
79     function transfer(address to, uint256 value) external returns (bool);
80 
81     function approve(address spender, uint256 value) external returns (bool);
82 
83     function transferFrom(address from, address to, uint256 value) external returns (bool);
84 
85     function totalSupply() external view returns (uint256);
86 
87     function balanceOf(address who) external view returns (uint256);
88 
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Unsigned math operations with safety checks that revert on error
99  */
100 library SafeMath {
101     /**
102     * @dev Multiplies two unsigned integers, reverts on overflow.
103     */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b);
114 
115         return c;
116     }
117 
118     /**
119     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
120     */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         // Solidity only automatically asserts when dividing by 0
123         require(b > 0);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
132     */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b <= a);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141     * @dev Adds two unsigned integers, reverts on overflow.
142     */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a);
146 
147         return c;
148     }
149 
150     /**
151     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
152     * reverts when dividing by zero.
153     */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b != 0);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
165  * Originally based on code by FirstBlood:
166  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  *
168  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
169  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
170  * compliant implementations may not do it.
171  */
172 contract ERC20 is IERC20 {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowed;
178 
179     uint256 private _totalSupply;
180 
181     /**
182     * @dev Total number of tokens in existence
183     */
184     function totalSupply() public view returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param owner The address to query the balance of.
191     * @return An uint256 representing the amount owned by the passed address.
192     */
193     function balanceOf(address owner) public view returns (uint256) {
194         return _balances[owner];
195     }
196 
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param owner address The address which owns the funds.
200      * @param spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      */
203     function allowance(address owner, address spender) public view returns (uint256) {
204         return _allowed[owner][spender];
205     }
206 
207     /**
208     * @dev Transfer token for a specified address
209     * @param to The address to transfer to.
210     * @param value The amount to be transferred.
211     */
212     function transfer(address to, uint256 value) public returns (bool) {
213         _transfer(msg.sender, to, value);
214         return true;
215     }
216 
217     /**
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param spender The address which will spend the funds.
224      * @param value The amount of tokens to be spent.
225      */
226     function approve(address spender, uint256 value) public returns (bool) {
227         require(spender != address(0));
228 
229         _allowed[msg.sender][spender] = value;
230         emit Approval(msg.sender, spender, value);
231         return true;
232     }
233 
234     /**
235      * @dev Transfer tokens from one address to another.
236      * Note that while this function emits an Approval event, this is not required as per the specification,
237      * and other compliant implementations may not emit the event.
238      * @param from address The address which you want to send tokens from
239      * @param to address The address which you want to transfer to
240      * @param value uint256 the amount of tokens to be transferred
241      */
242     function transferFrom(address from, address to, uint256 value) public returns (bool) {
243         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244         _transfer(from, to, value);
245         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
263         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     /**
268      * @dev Decrease the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param subtractedValue The amount of tokens to decrease the allowance by.
276      */
277     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286     * @dev Transfer token for a specified addresses
287     * @param from The address to transfer from.
288     * @param to The address to transfer to.
289     * @param value The amount to be transferred.
290     */
291     function _transfer(address from, address to, uint256 value) internal {
292         require(to != address(0));
293 
294         _balances[from] = _balances[from].sub(value);
295         _balances[to] = _balances[to].add(value);
296         emit Transfer(from, to, value);
297     }
298 
299     /**
300      * @dev Internal function that mints an amount of the token and assigns it to
301      * an account. This encapsulates the modification of balances such that the
302      * proper events are emitted.
303      * @param account The account that will receive the created tokens.
304      * @param value The amount that will be created.
305      */
306     function _mint(address account, uint256 value) internal {
307         require(account != address(0));
308 
309         _totalSupply = _totalSupply.add(value);
310         _balances[account] = _balances[account].add(value);
311         emit Transfer(address(0), account, value);
312     }
313 
314     /**
315      * @dev Internal function that burns an amount of the token of a given
316      * account.
317      * @param account The account whose tokens will be burnt.
318      * @param value The amount that will be burnt.
319      */
320     function _burn(address account, uint256 value) internal {
321         require(account != address(0));
322 
323         _totalSupply = _totalSupply.sub(value);
324         _balances[account] = _balances[account].sub(value);
325         emit Transfer(account, address(0), value);
326     }
327 
328     /**
329      * @dev Internal function that burns an amount of the token of a given
330      * account, deducting from the sender's allowance for said account. Uses the
331      * internal burn function.
332      * Emits an Approval event (reflecting the reduced allowance).
333      * @param account The account whose tokens will be burnt.
334      * @param value The amount that will be burnt.
335      */
336     function _burnFrom(address account, uint256 value) internal {
337         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
338         _burn(account, value);
339         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
340     }
341 }
342 
343 /**
344  * @title Roles
345  * @dev Library for managing addresses assigned to a Role.
346  */
347 library Roles {
348     struct Role {
349         mapping (address => bool) bearer;
350     }
351 
352     /**
353      * @dev give an account access to this role
354      */
355     function add(Role storage role, address account) internal {
356         require(account != address(0));
357         require(!has(role, account));
358 
359         role.bearer[account] = true;
360     }
361 
362     /**
363      * @dev remove an account's access to this role
364      */
365     function remove(Role storage role, address account) internal {
366         require(account != address(0));
367         require(has(role, account));
368 
369         role.bearer[account] = false;
370     }
371 
372     /**
373      * @dev check if an account has this role
374      * @return bool
375      */
376     function has(Role storage role, address account) internal view returns (bool) {
377         require(account != address(0));
378         return role.bearer[account];
379     }
380 }
381 
382 contract MinterRole {
383     using Roles for Roles.Role;
384 
385     event MinterAdded(address indexed account);
386     event MinterRemoved(address indexed account);
387 
388     Roles.Role private _minters;
389 
390     constructor () internal {
391         _addMinter(msg.sender);
392     }
393 
394     modifier onlyMinter() {
395         require(isMinter(msg.sender));
396         _;
397     }
398 
399     function isMinter(address account) public view returns (bool) {
400         return _minters.has(account);
401     }
402 
403     function addMinter(address account) public onlyMinter {
404         _addMinter(account);
405     }
406 
407     function renounceMinter() public {
408         _removeMinter(msg.sender);
409     }
410 
411     function _addMinter(address account) internal {
412         _minters.add(account);
413         emit MinterAdded(account);
414     }
415 
416     function _removeMinter(address account) internal {
417         _minters.remove(account);
418         emit MinterRemoved(account);
419     }
420 }
421 
422 /**
423  * @title ERC20Mintable
424  * @dev ERC20 minting logic
425  */
426 contract ERC20Mintable is ERC20, MinterRole {
427     /**
428      * @dev Function to mint tokens
429      * @param to The address that will receive the minted tokens.
430      * @param value The amount of tokens to mint.
431      * @return A boolean that indicates if the operation was successful.
432      */
433     function mint(address to, uint256 value) public onlyMinter returns (bool) {
434         _mint(to, value);
435         return true;
436     }
437 }
438 
439 /**
440  * @title WhitelistAdminRole
441  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
442  */
443 contract WhitelistAdminRole {
444     using Roles for Roles.Role;
445 
446     event WhitelistAdminAdded(address indexed account);
447     event WhitelistAdminRemoved(address indexed account);
448 
449     Roles.Role private _whitelistAdmins;
450 
451     constructor () internal {
452         _addWhitelistAdmin(msg.sender);
453     }
454 
455     modifier onlyWhitelistAdmin() {
456         require(isWhitelistAdmin(msg.sender));
457         _;
458     }
459 
460     function isWhitelistAdmin(address account) public view returns (bool) {
461         return _whitelistAdmins.has(account);
462     }
463 
464     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
465         _addWhitelistAdmin(account);
466     }
467 
468     function renounceWhitelistAdmin() public {
469         _removeWhitelistAdmin(msg.sender);
470     }
471 
472     function _addWhitelistAdmin(address account) internal {
473         _whitelistAdmins.add(account);
474         emit WhitelistAdminAdded(account);
475     }
476 
477     function _removeWhitelistAdmin(address account) internal {
478         _whitelistAdmins.remove(account);
479         emit WhitelistAdminRemoved(account);
480     }
481 }
482 
483 contract OwnableWhitelistAdminRole is Ownable, WhitelistAdminRole {
484     function addWhitelistAdmin(address account) public onlyOwner {
485         _addWhitelistAdmin(account);
486     }
487 
488     function removeWhitelistAdmin(address account) public onlyOwner {
489         _removeWhitelistAdmin(account);
490     }
491 }
492 
493 contract Whitelist {
494     event WhitelistCreated(address account);
495     event WhitelistChange(address indexed account, bool allowed);
496 
497     constructor() public {
498         emit WhitelistCreated(address(this));
499     }
500 
501     function isWhitelisted(address account) public view returns (bool);
502 }
503 
504 contract WhitelistImpl is Ownable, OwnableWhitelistAdminRole, Whitelist {
505     mapping(address => bool) public whitelist;
506 
507     function isWhitelisted(address account) public view returns (bool) {
508         return whitelist[account];
509     }
510 
511     function addToWhitelist(address[] memory accounts) public onlyWhitelistAdmin {
512         for(uint i = 0; i < accounts.length; i++) {
513             _setWhitelisted(accounts[i], true);
514         }
515     }
516 
517     function removeFromWhitelist(address[] memory accounts) public onlyWhitelistAdmin {
518         for(uint i = 0; i < accounts.length; i++) {
519             _setWhitelisted(accounts[i], false);
520         }
521     }
522 
523     function setWhitelisted(address account, bool whitelisted) public onlyWhitelistAdmin {
524         _setWhitelisted(account, whitelisted);
525     }
526 
527     function _setWhitelisted(address account, bool whitelisted) internal {
528         whitelist[account] = whitelisted;
529         emit WhitelistChange(account, whitelisted);
530     }
531 }
532 
533 contract TransitSale is Ownable, WhitelistImpl {
534     using SafeMath for uint256;
535 
536     struct PoolDescription {
537         /**
538          * @dev maximal amount of tokens in this pool
539          */
540         uint maxAmount;
541         /**
542          * @dev amount of tokens already released
543          */
544         uint releasedAmount;
545         /**
546          * @dev release time
547          */
548         uint releaseTime;
549         /**
550          * @dev release type of the holder (fixed - date is set in seconds since 01.01.1970, floating - date is set in seconds since holder creation, direct - tokens are transferred to beneficiary immediately)
551          */
552         ReleaseType releaseType;
553     }
554 
555     enum ReleaseType { Fixed, Floating, Direct }
556 
557     event PoolCreatedEvent(string name, uint maxAmount, uint releaseTime, uint vestingInterval, uint value, ReleaseType releaseType);
558     event TokenHolderCreatedEvent(string name, address holder, address beneficiary, uint amount);
559     event ReleasedEvent(address beneficiary, uint amount);
560 
561     uint private constant DAY = 86400;
562     uint private constant INTERVAL = 30 * DAY;
563     uint private constant DEFAULT_EXCHANGE_LISTING_TIME = 1559347200;//06/01/2019 @ 12:00am (UTC)
564 
565     ERC20Mintable public token;
566     uint private exchangeListingTime;
567     mapping(string => PoolDescription) private pools;
568     mapping(address => uint) public released;
569     mapping(address => uint) public totals;
570 
571     constructor(ERC20Mintable _token) public {
572         token = _token;
573 
574         registerPool("Private", 516666650 * 10 ** 18, ReleaseType.Fixed);
575         registerPool("IEO", 200000000 * 10 ** 18, ReleaseType.Direct);
576         registerPool("Incentives", 108333350 * 10 ** 18, ReleaseType.Direct);
577         registerPool("Team", 300000000 * 10 ** 18, ReleaseType.Fixed);
578         registerPool("Reserve", 375000000 * 10 ** 18, ReleaseType.Fixed);
579     }
580 
581     function registerPool(string memory _name, uint _maxAmount, ReleaseType _releaseType) internal {
582         require(_maxAmount > 0, "maxAmount should be greater than 0");
583         require(_releaseType != ReleaseType.Floating, "ReleaseType.Floating is not supported. use Pools instead");
584         pools[_name] = PoolDescription(_maxAmount, 0, 0, _releaseType);
585         emit PoolCreatedEvent(_name, _maxAmount, 0, INTERVAL, 20, _releaseType);
586     }
587 
588     function createHolder(string memory _name, address _beneficiary, uint _amount) onlyOwner public {
589         require(isWhitelisted(_beneficiary), "not whitelisted");
590 
591         PoolDescription storage pool = pools[_name];
592         require(pool.maxAmount != 0, "pool is not defined");
593         uint newReleasedAmount = _amount.add(pool.releasedAmount);
594         require(newReleasedAmount <= pool.maxAmount, "pool is depleted");
595         pool.releasedAmount = newReleasedAmount;
596         if (pool.releaseType == ReleaseType.Direct) {
597             require(token.mint(_beneficiary, _amount));
598         } else {
599             require(token.mint(address(this), _amount));
600             totals[_beneficiary] = totals[_beneficiary].add(_amount);
601             emit TokenHolderCreatedEvent(_name, address(this), _beneficiary, _amount);
602         }
603     }
604 
605     function getVestedAmountForAddress(address _beneficiary) view public returns (uint) {
606         uint releaseTime = releaseTime();
607         if (now < releaseTime) {
608             return 0;
609         }
610         uint total = totals[_beneficiary];
611         uint diff = now.sub(releaseTime);
612         uint interval = 1 + diff / INTERVAL;
613         if (interval >= 5) {
614             return total;
615         }
616         return interval.mul(total).div(5);
617     }
618 
619     function getVestedAmount() view public returns (uint) {
620         return getVestedAmountForAddress(msg.sender);
621     }
622 
623     function getTotalAmount() view public returns (uint) {
624         return totals[msg.sender];
625     }
626 
627     function getReleasedAmount() view public returns (uint) {
628         return released[msg.sender];
629     }
630 
631     function release() public {
632         uint vested = getVestedAmountForAddress(msg.sender);
633         uint amount = vested.sub(released[msg.sender]);
634         require(amount > 0);
635         released[msg.sender] = vested;
636         require(token.transfer(msg.sender, amount));
637         emit ReleasedEvent(msg.sender, amount);
638     }
639 
640     function getTokensLeft(string memory _name) view public returns (uint) {
641         PoolDescription storage pool = pools[_name];
642         require(pool.maxAmount != 0, "pool is not defined");
643         return pool.maxAmount.sub(pool.releasedAmount);
644     }
645 
646     function setExchangeListingTime(uint _exchangeListingTime) onlyOwner public {
647         require(exchangeListingTime == 0);
648         exchangeListingTime = _exchangeListingTime;
649     }
650 
651     function releaseTime() view public returns (uint) {
652         uint listingTime;
653         if (exchangeListingTime == 0) {
654             listingTime = DEFAULT_EXCHANGE_LISTING_TIME;
655         } else {
656             listingTime = exchangeListingTime;
657         }
658         return listingTime.add(90 * DAY);
659     }
660 }