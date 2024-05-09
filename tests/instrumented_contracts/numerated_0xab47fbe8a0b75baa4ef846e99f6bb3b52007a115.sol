1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-22
3 */
4 
5 pragma solidity ^0.5.14;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: node_modules\@openzeppelin\contracts\ownership\Ownable.sol
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         _owner = _msgSender();
55         emit OwnershipTransferred(address(0), _owner);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 interface IERC20 {
115     function transfer(address to, uint256 value) external returns (bool);
116 
117     function approve(address spender, uint256 value) external returns (bool);
118 
119     function transferFrom(address from, address to, uint256 value) external returns (bool);
120 
121     function totalSupply() external view returns (uint256);
122 
123     function balanceOf(address who) external view returns (uint256);
124 
125     function allowance(address owner, address spender) external view returns (uint256);
126 
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * @title SafeMath
135  * @dev Unsigned math operations with safety checks that revert on error
136  */
137 library SafeMath {
138     /**
139     * @dev Multiplies two unsigned integers, reverts on overflow.
140     */
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
143         // benefit is lost if 'b' is also tested.
144         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
145         if (a == 0) {
146             return 0;
147         }
148 
149         uint256 c = a * b;
150         require(c / a == b);
151 
152         return c;
153     }
154 
155     /**
156     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
157     */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0);
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
169     */
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b <= a);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178     * @dev Adds two unsigned integers, reverts on overflow.
179     */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         require(c >= a);
183 
184         return c;
185     }
186 
187     /**
188     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
189     * reverts when dividing by zero.
190     */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         require(b != 0);
193         return a % b;
194     }
195 }
196 
197 
198 /**
199  * @title Standard ERC20 token
200  *
201  * @dev Implementation of the basic standard token.
202  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
203  * Originally based on code by FirstBlood:
204  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  *
206  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
207  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
208  * compliant implementations may not do it.
209  */
210 contract ERC20 is IERC20 {
211     using SafeMath for uint256;
212 
213     mapping (address => uint256) private _balances;
214 
215     mapping (address => mapping (address => uint256)) private _allowed;
216 
217     uint256 private _totalSupply;
218 
219     /**
220     * @dev Total number of tokens in existence
221     */
222     function totalSupply() public view returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227     * @dev Gets the balance of the specified address.
228     * @param owner The address to query the balance of.
229     * @return An uint256 representing the amount owned by the passed address.
230     */
231     function balanceOf(address owner) public view returns (uint256) {
232         return _balances[owner];
233     }
234 
235     /**
236      * @dev Function to check the amount of tokens that an owner allowed to a spender.
237      * @param owner address The address which owns the funds.
238      * @param spender address The address which will spend the funds.
239      * @return A uint256 specifying the amount of tokens still available for the spender.
240      */
241     function allowance(address owner, address spender) public view returns (uint256) {
242         return _allowed[owner][spender];
243     }
244 
245     /**
246     * @dev Transfer token for a specified address
247     * @param to The address to transfer to.
248     * @param value The amount to be transferred.
249     */
250     function transfer(address to, uint256 value) public returns (bool) {
251         _transfer(msg.sender, to, value);
252         return true;
253     }
254 
255     /**
256      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257      * Beware that changing an allowance with this method brings the risk that someone may use both the old
258      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
259      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      * @param spender The address which will spend the funds.
262      * @param value The amount of tokens to be spent.
263      */
264     function approve(address spender, uint256 value) public returns (bool) {
265         require(spender != address(0));
266 
267         _allowed[msg.sender][spender] = value;
268         emit Approval(msg.sender, spender, value);
269         return true;
270     }
271 
272     /**
273      * @dev Transfer tokens from one address to another.
274      * Note that while this function emits an Approval event, this is not required as per the specification,
275      * and other compliant implementations may not emit the event.
276      * @param from address The address which you want to send tokens from
277      * @param to address The address which you want to transfer to
278      * @param value uint256 the amount of tokens to be transferred
279      */
280     function transferFrom(address from, address to, uint256 value) public returns (bool) {
281         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
282         _transfer(from, to, value);
283         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
284         return true;
285     }
286 
287     /**
288      * @dev Increase the amount of tokens that an owner allowed to a spender.
289      * approve should be called when allowed_[_spender] == 0. To increment
290      * allowed value is better to use this function to avoid 2 calls (and wait until
291      * the first transaction is mined)
292      * From MonolithDAO Token.sol
293      * Emits an Approval event.
294      * @param spender The address which will spend the funds.
295      * @param addedValue The amount of tokens to increase the allowance by.
296      */
297     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
298         require(spender != address(0));
299 
300         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
301         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302         return true;
303     }
304 
305     /**
306      * @dev Decrease the amount of tokens that an owner allowed to a spender.
307      * approve should be called when allowed_[_spender] == 0. To decrement
308      * allowed value is better to use this function to avoid 2 calls (and wait until
309      * the first transaction is mined)
310      * From MonolithDAO Token.sol
311      * Emits an Approval event.
312      * @param spender The address which will spend the funds.
313      * @param subtractedValue The amount of tokens to decrease the allowance by.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
316         require(spender != address(0));
317 
318         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
319         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
320         return true;
321     }
322 
323     /**
324     * @dev Transfer token for a specified addresses
325     * @param from The address to transfer from.
326     * @param to The address to transfer to.
327     * @param value The amount to be transferred.
328     */
329     function _transfer(address from, address to, uint256 value) internal {
330         require(to != address(0));
331 
332         _balances[from] = _balances[from].sub(value);
333         _balances[to] = _balances[to].add(value);
334         emit Transfer(from, to, value);
335     }
336 
337     /**
338      * @dev Internal function that mints an amount of the token and assigns it to
339      * an account. This encapsulates the modification of balances such that the
340      * proper events are emitted.
341      * @param account The account that will receive the created tokens.
342      * @param value The amount that will be created.
343      */
344     function _mint(address account, uint256 value) internal {
345         require(account != address(0));
346 
347         _totalSupply = _totalSupply.add(value);
348         _balances[account] = _balances[account].add(value);
349         emit Transfer(address(0), account, value);
350     }
351 
352     /**
353      * @dev Internal function that burns an amount of the token of a given
354      * account.
355      * @param account The account whose tokens will be burnt.
356      * @param value The amount that will be burnt.
357      */
358     function _burn(address account, uint256 value) internal {
359         require(account != address(0));
360 
361         _totalSupply = _totalSupply.sub(value);
362         _balances[account] = _balances[account].sub(value);
363         emit Transfer(account, address(0), value);
364     }
365 
366     /**
367      * @dev Internal function that burns an amount of the token of a given
368      * account, deducting from the sender's allowance for said account. Uses the
369      * internal burn function.
370      * Emits an Approval event (reflecting the reduced allowance).
371      * @param account The account whose tokens will be burnt.
372      * @param value The amount that will be burnt.
373      */
374     function _burnFrom(address account, uint256 value) internal {
375         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
376         _burn(account, value);
377         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
378     }
379 }
380 
381 
382 /**
383  * @title Helps contracts guard against reentrancy attacks.
384  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
385  * @dev If you mark a function `nonReentrant`, you should also
386  * mark it `external`.
387  */
388 contract ReentrancyGuard {
389     /// @dev counter to allow mutex lock with only one SSTORE operation
390     uint256 private _guardCounter;
391 
392     constructor() public {
393         // The counter starts at one to prevent changing it from zero to a non-zero
394         // value, which is a more expensive operation.
395         _guardCounter = 1;
396     }
397 
398     /**
399      * @dev Prevents a contract from calling itself, directly or indirectly.
400      * Calling a `nonReentrant` function from another `nonReentrant`
401      * function is not supported. It is possible to prevent this from happening
402      * by making the `nonReentrant` function external, and make it call a
403      * `private` function that does the actual work.
404      */
405     modifier nonReentrant() {
406         _guardCounter += 1;
407         uint256 localCounter = _guardCounter;
408         _;
409         require(localCounter == _guardCounter);
410     }
411 }
412 
413 /**
414  * @title Roles
415  * @dev Library for managing addresses assigned to a Role.
416  */
417 library Roles {
418     struct Role {
419         mapping (address => bool) bearer;
420     }
421 
422     /**
423      * @dev Give an account access to this role.
424      */
425     function add(Role storage role, address account) internal {
426         require(!has(role, account), "Roles: account already has role");
427         role.bearer[account] = true;
428     }
429 
430     /**
431      * @dev Remove an account's access to this role.
432      */
433     function remove(Role storage role, address account) internal {
434         require(has(role, account), "Roles: account does not have role");
435         role.bearer[account] = false;
436     }
437 
438     /**
439      * @dev Check if an account has this role.
440      * @return bool
441      */
442     function has(Role storage role, address account) internal view returns (bool) {
443         require(account != address(0), "Roles: account is the zero address");
444         return role.bearer[account];
445     }
446 }
447 
448 
449 contract WIPcoin is ERC20, ReentrancyGuard, Ownable {
450 
451     using SafeMath for uint256;
452     using Roles for Roles.Role;
453 
454     Roles.Role private _admin;
455 
456     event MintWIP(address mintingAddress, uint256 amount);
457     event BurnWIP(uint256 amount);
458 
459     mapping (address => uint256) private amountClaimableByAddress;
460 
461     uint8 constant public decimals = 18;
462     string constant public name = "WIPcoin";
463     string constant public symbol = "WIPC";
464     uint256 constant public WIPHardCap = 1000000;
465     uint256 public timerInitiated;
466     uint256 public halvingIndex;
467     uint256 public halvingTimeStamp;
468     uint256 constant public halvingPeriodSeconds = 19353600;
469     bool public numberOfAttendeesSet;
470     bool public weeklyCountFinalized;
471     bool public backDropComplete;
472     
473     address public expensesWeeklyAddress;
474     address public promoWeeklyAddress;
475 
476     uint256 claimTimeDelay;
477     uint256 thisWeeksAttendees;
478     uint256 totalMeetups;
479     uint256 totalAttendees;
480     
481     uint256 expensesSplit;
482     uint256 promotionalSplit;
483     uint256 communitySplit;
484     
485     constructor() public {
486         _mint(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3, WIPHardCap*6*10**16);
487         _mint(0x442DCCEe68425828C106A3662014B4F131e3BD9b, WIPHardCap*6*10**16);
488         _mint(0x81E5cd19323ce7f6b36c9511fbC98d477a188b13, WIPHardCap*6*10**16);
489         _mint(0xc2F82A1F287B5b5AEBff7C19e83e0a16Cf3bD041, WIPHardCap*6*10**16);
490         _mint(0xfd3be6f4D3E099eDa7158dB21d459794B25309F8, WIPHardCap*6*10**16);
491         timerInitiated = block.timestamp;
492         halvingTimeStamp = timerInitiated + halvingPeriodSeconds;
493         halvingIndex = 0;
494         totalMeetups = 22;
495         totalAttendees = 1247;
496         backDropComplete = false;
497         expensesWeeklyAddress = 0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3;
498         promoWeeklyAddress = 0x1082ACF0F6C0728F80FAe05741e6EcDEF976C181;
499         communitySplit = 60;
500         expensesSplit = 25;
501         promotionalSplit = 15;
502         _admin.add(0x63a9dbCe75413036B2B778E670aaBd4493aAF9F3);
503         _admin.add(0x442DCCEe68425828C106A3662014B4F131e3BD9b);
504         _admin.add(0x81E5cd19323ce7f6b36c9511fbC98d477a188b13);
505         _admin.add(0xc2F82A1F287B5b5AEBff7C19e83e0a16Cf3bD041);
506     }
507 
508     function getWeeklyDistribution() public view returns (uint256 communityDistributionAmount, uint256 expensesDistributionAmount, uint256 promotionalDistributionAmount) {
509         uint256 halvingDecay = 2**halvingIndex;
510         uint256 totalDistributionAmount = WIPHardCap*1/halvingDecay*10**16;
511         
512         communityDistributionAmount = totalDistributionAmount*communitySplit/100;
513         expensesDistributionAmount = totalDistributionAmount*expensesSplit/100;
514         promotionalDistributionAmount = totalDistributionAmount*promotionalSplit/100;
515     }
516 
517     function getCirculatingWIP() private view returns (uint256 circulatingWIP) {
518         circulatingWIP = totalSupply().div(10**18); 
519     }
520 
521     function updateHalvingIndex() private {
522         if (getTimeToNextHalving() <= 0) {
523             halvingIndex = halvingIndex + 1;
524         }
525         halvingTimeStamp = timerInitiated + ((halvingIndex + 1) * halvingPeriodSeconds);
526     }
527 
528     function getTimeToNextHalving() private view returns (int256 timeToNextHalving){
529         timeToNextHalving = int256(halvingTimeStamp - block.timestamp);
530     }
531 
532     function updateNumberOfAttendees(uint256 numberOfAttendees) public {
533         require(_admin.has(msg.sender), "Only official admin can update number of attendees.");
534         require (getTimeToDelayEnd() <= 0);
535         
536         numberOfAttendeesSet = true;
537         weeklyCountFinalized = false;
538         thisWeeksAttendees = numberOfAttendees; 
539         
540         updateHalvingIndex();
541     }
542 
543     function pushAddresses(address[] memory attendee) public nonReentrant {
544         require(_admin.has(msg.sender), "Only official admin can push attendee addresses.");
545         require(getTimeToNextHalving() >= 0);
546         require(getTimeToNextHalving() <= int256(halvingPeriodSeconds));
547         
548         require(numberOfAttendeesSet == true);
549         require(thisWeeksAttendees == attendee.length);
550         
551         uint256 crowdDistribution;
552         (crowdDistribution,,) = getWeeklyDistribution();
553         
554         uint256 weeklyWIPDistribution = crowdDistribution/thisWeeksAttendees;
555         for(uint256 i = 0; i < attendee.length; i++){
556             amountClaimableByAddress[attendee[i]] = amountClaimableByAddress[attendee[i]] + weeklyWIPDistribution;
557         }
558         
559         finalizeWeeklyAddresses();
560     }
561     
562     function initialBackDrop(address[] memory attendee, uint256[] memory backDropAmount) public onlyOwner nonReentrant {
563         require(backDropComplete == false);
564         require(attendee.length == backDropAmount.length);
565         
566         for(uint256 i = 0; i < attendee.length; i++){
567             amountClaimableByAddress[attendee[i]] = amountClaimableByAddress[attendee[i]] + backDropAmount[i];
568         }
569         
570         backDropComplete = true;
571     }
572 
573     function finalizeWeeklyAddresses() private {
574         numberOfAttendeesSet = false;
575         weeklyCountFinalized = true;
576         totalMeetups = totalMeetups + 1;
577         totalAttendees = totalAttendees + thisWeeksAttendees;
578         claimTimeDelay = block.timestamp + 518400; //6 days to allow for some input lag
579         claimTeamWeekly();
580     }
581     
582     function getTimeToDelayEnd() private view returns (int256 timeToDelayEnd){
583         timeToDelayEnd = int256(claimTimeDelay - block.timestamp);
584     }
585 
586     function claimWIPCoin() public nonReentrant {
587         require(weeklyCountFinalized == true);
588         uint256 amountToClaim = amountClaimableByAddress[msg.sender];
589         amountClaimableByAddress[msg.sender] = 0;
590         
591         require(getCirculatingWIP() + amountToClaim <= WIPHardCap.mul(10**18));
592         
593         _mint(msg.sender, amountToClaim);
594         emit MintWIP(msg.sender, amountToClaim.div(10**18));
595     }
596     
597     function claimTeamWeekly() private {
598         require(weeklyCountFinalized == true);
599         
600         uint256 expensesDistribution;
601         uint256 promotionalDistribution;
602         (,expensesDistribution, promotionalDistribution) = getWeeklyDistribution();
603         
604         require(getCirculatingWIP() + expensesDistribution <= WIPHardCap.mul(10**18));
605         _mint(expensesWeeklyAddress, expensesDistribution);
606         emit MintWIP(expensesWeeklyAddress, expensesDistribution.div(10**18));
607         
608         require(getCirculatingWIP() + promotionalDistribution <= WIPHardCap.mul(10**18));
609         _mint(promoWeeklyAddress, promotionalDistribution);
610         emit MintWIP(promoWeeklyAddress, promotionalDistribution.div(10**18));        
611     }
612     
613     function updateTeamWeekly(address newTeamWeekly) public onlyOwner {
614         expensesWeeklyAddress = newTeamWeekly;
615     }
616 
617     function updatePromoWeekly(address newPromoWeekly) public onlyOwner {
618         promoWeeklyAddress = newPromoWeekly;
619     }
620     
621     function adjustWeeklySplit(uint256 newExpenses, uint256 newPromo, uint256 newCommunity) public onlyOwner {
622         require(newExpenses + newPromo + newCommunity == 100);
623         
624         expensesSplit = newExpenses;
625         promotionalSplit = newPromo;
626         communitySplit = newCommunity;
627     }
628     
629     function getStats() public view returns (uint256 meetups, uint256 attendees, uint256 weeklyAttendees , uint256 circulatingSupply, int256 nextHalvingCountdown, int256 nextTimeDelayEnding, uint256 expensesPercent, uint256 promotionalPercent, uint256 communityPercent){
630         meetups = totalMeetups;
631         attendees =  totalAttendees;
632         weeklyAttendees = thisWeeksAttendees;
633         circulatingSupply = getCirculatingWIP();
634         nextHalvingCountdown = getTimeToNextHalving();
635         nextTimeDelayEnding = getTimeToDelayEnd();
636         expensesPercent = expensesSplit;
637         promotionalPercent = promotionalSplit;
638         communityPercent = communitySplit;
639     }
640     
641     function getAmountClaimable(address userAddress) public view returns (uint256 amountClaimable) {
642         amountClaimable = amountClaimableByAddress[userAddress];
643     }
644     
645     function addAdminAddress(address newAdminAddress) public onlyOwner {
646         _admin.add(newAdminAddress);
647     }
648     
649     function removeAdminAddress(address oldAdminAddress) public onlyOwner {
650         _admin.remove(oldAdminAddress);
651     }
652     
653     function burnWIP(uint256 WIPToBurn) public nonReentrant {
654         _burn(msg.sender, WIPToBurn);
655         emit BurnWIP(WIPToBurn.div(10**18));
656         }
657     }