1 pragma solidity ^0.5.2;
2 // tested in solidity 0.5.8
3 // using openzeppelin-solidity-2.2.0
4 
5 // import "../../utils/Address.sol";
6 /**
7  * Utility library of inline functions on addresses
8  */
9 library Address {
10     /**
11      * Returns whether the target address is a contract
12      * @dev This function will return false if invoked during the constructor of a contract,
13      * as the code is not actually created until after the constructor finishes.
14      * @param account address of the account to check
15      * @return whether the target address is a contract
16      */
17     function isContract(address account) internal view returns (bool) {
18         uint256 size;
19         // XXX Currently there is no better way to check if there is a contract in an address
20         // than to check the size of the code at that address.
21         // See https://ethereum.stackexchange.com/a/14016/36603
22         // for more details about how this works.
23         // TODO Check this again before the Serenity release, because all addresses will be
24         // contracts then.
25         // solhint-disable-next-line no-inline-assembly
26         assembly { size := extcodesize(account) }
27         return size > 0;
28     }
29 }
30 
31 
32 // import "../../math/SafeMath.sol";
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39      * @dev Multiplies two unsigned integers, reverts on overflow.
40      */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57      */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Adds two unsigned integers, reverts on overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89      * reverts when dividing by zero.
90      */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 
98 
99 // import "./IERC20.sol";
100 /**
101  * @title ERC20 interface
102  * @dev see https://eips.ethereum.org/EIPS/eip-20
103  */
104 interface IERC20 {
105     function transfer(address to, uint256 value) external returns (bool);
106 
107     function approve(address spender, uint256 value) external returns (bool);
108 
109     function transferFrom(address from, address to, uint256 value) external returns (bool);
110 
111     function totalSupply() external view returns (uint256);
112 
113     function balanceOf(address who) external view returns (uint256);
114 
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 /**
124  * @title SafeERC20
125  * @dev Wrappers around ERC20 operations that throw on failure (when the token
126  * contract returns false). Tokens that return no value (and instead revert or
127  * throw on failure) are also supported, non-reverting calls are assumed to be
128  * successful.
129  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
130  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
131  */
132 library SafeERC20 {
133     using SafeMath for uint256;
134     using Address for address;
135 
136     function safeTransfer(IERC20 token, address to, uint256 value) internal {
137         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
138     }
139 
140     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
141         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
142     }
143 
144     function safeApprove(IERC20 token, address spender, uint256 value) internal {
145         // safeApprove should only be called when setting an initial allowance,
146         // or when resetting it to zero. To increase and decrease it, use
147         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
148         require((value == 0) || (token.allowance(address(this), spender) == 0));
149         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
150     }
151 
152     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
153         uint256 newAllowance = token.allowance(address(this), spender).add(value);
154         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
155     }
156 
157     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
158         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
159         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
160     }
161 
162     /**
163      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
164      * on the return value: the return value is optional (but if data is returned, it must equal true).
165      * @param token The token targeted by the call.
166      * @param data The call data (encoded using abi.encode or one of its variants).
167      */
168     function callOptionalReturn(IERC20 token, bytes memory data) private {
169         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
170         // we're implementing it ourselves.
171 
172         // A Solidity high level call has three parts:
173         //  1. The target address is checked to verify it contains contract code
174         //  2. The call itself is made, and success asserted
175         //  3. The return value is decoded, which in turn checks the size of the returned data.
176 
177         require(address(token).isContract());
178 
179         // solhint-disable-next-line avoid-low-level-calls
180         (bool success, bytes memory returndata) = address(token).call(data);
181         require(success);
182 
183         if (returndata.length > 0) { // Return data is optional
184             require(abi.decode(returndata, (bool)));
185         }
186     }
187 }
188 /////////////////////////////////////////////////////////////////////////
189 // ownership/Ownable.sol
190 ///////////////////////////////////////////////////////////////////////
191 contract ERC20 is IERC20 {
192     using SafeMath for uint256;
193 
194     mapping (address => uint256) private _balances;
195 
196     mapping (address => mapping (address => uint256)) private _allowed;
197 
198     uint256 private _totalSupply;
199 
200     /**
201      * @dev Total number of tokens in existence
202      */
203     function totalSupply() public view returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208      * @dev Gets the balance of the specified address.
209      * @param owner The address to query the balance of.
210      * @return A uint256 representing the amount owned by the passed address.
211      */
212     function balanceOf(address owner) public view returns (uint256) {
213         return _balances[owner];
214     }
215 
216     /**
217      * @dev Function to check the amount of tokens that an owner allowed to a spender.
218      * @param owner address The address which owns the funds.
219      * @param spender address The address which will spend the funds.
220      * @return A uint256 specifying the amount of tokens still available for the spender.
221      */
222     function allowance(address owner, address spender) public view returns (uint256) {
223         return _allowed[owner][spender];
224     }
225 
226     /**
227      * @dev Transfer token to a specified address
228      * @param to The address to transfer to.
229      * @param value The amount to be transferred.
230      */
231     function transfer(address to, uint256 value) public returns (bool) {
232         _transfer(msg.sender, to, value);
233         return true;
234     }
235 
236     /**
237      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param spender The address which will spend the funds.
243      * @param value The amount of tokens to be spent.
244      */
245     function approve(address spender, uint256 value) public returns (bool) {
246         _approve(msg.sender, spender, value);
247         return true;
248     }
249 
250     /**
251      * @dev Transfer tokens from one address to another.
252      * Note that while this function emits an Approval event, this is not required as per the specification,
253      * and other compliant implementations may not emit the event.
254      * @param from address The address which you want to send tokens from
255      * @param to address The address which you want to transfer to
256      * @param value uint256 the amount of tokens to be transferred
257      */
258     function transferFrom(address from, address to, uint256 value) public returns (bool) {
259         _transfer(from, to, value);
260         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
261         return true;
262     }
263 
264     /**
265      * @dev Increase the amount of tokens that an owner allowed to a spender.
266      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
267      * allowed value is better to use this function to avoid 2 calls (and wait until
268      * the first transaction is mined)
269      * From MonolithDAO Token.sol
270      * Emits an Approval event.
271      * @param spender The address which will spend the funds.
272      * @param addedValue The amount of tokens to increase the allowance by.
273      */
274     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
275         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
276         return true;
277     }
278 
279     /**
280      * @dev Decrease the amount of tokens that an owner allowed to a spender.
281      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param subtractedValue The amount of tokens to decrease the allowance by.
288      */
289     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
290         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
291         return true;
292     }
293 
294     /**
295      * @dev Transfer token for a specified addresses
296      * @param from The address to transfer from.
297      * @param to The address to transfer to.
298      * @param value The amount to be transferred.
299      */
300     function _transfer(address from, address to, uint256 value) internal {
301         require(to != address(0));
302 
303         _balances[from] = _balances[from].sub(value);
304         _balances[to] = _balances[to].add(value);
305         emit Transfer(from, to, value);
306     }
307 
308     /**
309      * @dev Internal function that mints an amount of the token and assigns it to
310      * an account. This encapsulates the modification of balances such that the
311      * proper events are emitted.
312      * @param account The account that will receive the created tokens.
313      * @param value The amount that will be created.
314      */
315     function _mint(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.add(value);
319         _balances[account] = _balances[account].add(value);
320         emit Transfer(address(0), account, value);
321     }
322 
323     /**
324      * @dev Internal function that burns an amount of the token of a given
325      * account.
326      * @param account The account whose tokens will be burnt.
327      * @param value The amount that will be burnt.
328      */
329     function _burn(address account, uint256 value) internal {
330         require(account != address(0));
331 
332         _totalSupply = _totalSupply.sub(value);
333         _balances[account] = _balances[account].sub(value);
334         emit Transfer(account, address(0), value);
335     }
336 
337     /**
338      * @dev Approve an address to spend another addresses' tokens.
339      * @param owner The address that owns the tokens.
340      * @param spender The address that will spend the tokens.
341      * @param value The number of tokens that can be spent.
342      */
343     function _approve(address owner, address spender, uint256 value) internal {
344         require(spender != address(0));
345         require(owner != address(0));
346 
347         _allowed[owner][spender] = value;
348         emit Approval(owner, spender, value);
349     }
350 
351     /**
352      * @dev Internal function that burns an amount of the token of a given
353      * account, deducting from the sender's allowance for said account. Uses the
354      * internal burn function.
355      * Emits an Approval event (reflecting the reduced allowance).
356      * @param account The account whose tokens will be burnt.
357      * @param value The amount that will be burnt.
358      */
359     function _burnFrom(address account, uint256 value) internal {
360         _burn(account, value);
361         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
362     }
363 }
364 /////////////////////////////////////////////////////////////////////////
365 // ERC20Detailed
366 ///////////////////////////////////////////////////////////////////////
367 contract ERC20Detailed is IERC20 {
368     string private _name;
369     string private _symbol;
370     uint8 private _decimals;
371 
372     constructor (string memory name, string memory symbol, uint8 decimals) public {
373         _name = name;
374         _symbol = symbol;
375         _decimals = decimals;
376     }
377 
378     /**
379      * @return the name of the token.
380      */
381     function name() public view returns (string memory) {
382         return _name;
383     }
384 
385     /**
386      * @return the symbol of the token.
387      */
388     function symbol() public view returns (string memory) {
389         return _symbol;
390     }
391 
392     /**
393      * @return the number of decimals of the token.
394      */
395     function decimals() public view returns (uint8) {
396         return _decimals;
397     }
398 }
399 
400 /////////////////////////////////////////////////////////////////////////
401 // ownership/Ownable.sol
402 ///////////////////////////////////////////////////////////////////////
403 contract Ownable {
404     address private _owner;
405 
406     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
407 
408     /**
409      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
410      * account.
411      */
412     constructor (address Owner) internal {
413         _owner = Owner;
414         emit OwnershipTransferred(address(0), _owner);
415     }
416 
417     /**
418      * @return the address of the owner.
419      */
420     function owner() public view returns (address) {
421         return _owner;
422     }
423 
424     /**
425      * @dev Throws if called by any account other than the owner.
426      */
427     modifier onlyOwner() {
428         require(isOwner());
429         _;
430     }
431 
432     /**
433      * @return true if `msg.sender` is the owner of the contract.
434      */
435     function isOwner() public view returns (bool) {
436         return msg.sender == _owner;
437     }
438 
439     /**
440      * @dev Allows the current owner to relinquish control of the contract.
441      * It will not be possible to call the functions with the `onlyOwner`
442      * modifier anymore.
443      * @notice Renouncing ownership will leave the contract without an owner,
444      * thereby removing any functionality that is only available to the owner.
445      */
446     // function renounceOwnership() public onlyOwner {
447     //     emit OwnershipTransferred(_owner, address(0));
448     //     _owner = address(0);
449     // }
450 
451     /**
452      * @dev Allows the current owner to transfer control of the contract to a newOwner.
453      * @param newOwner The address to transfer ownership to.
454      */
455     // function transferOwnership(address newOwner) public onlyOwner {
456     //     _transferOwnership(newOwner);
457     // }
458 
459     /**
460      * @dev Transfers control of the contract to a newOwner.
461      * @param newOwner The address to transfer ownership to.
462      */
463     // function _transferOwnership(address newOwner) internal {
464     //     require(newOwner != address(0));
465     //     emit OwnershipTransferred(_owner, newOwner);
466     //     _owner = newOwner;
467     // }
468 }
469 
470 /////////////////////////////////////////////////////////////////////////
471 // LockerPool Contract
472 /////////////////////////////////////////////////////////////////////////
473 contract LockerPool is Ownable {
474     using SafeERC20 for IERC20;
475     using SafeMath for uint256;
476 
477     IERC20 public token;
478     uint256 public lockMonths;
479 
480     uint256 public INITIAL_LOCK_AMOUNT;
481 
482     uint256 public lockDays;
483     uint256 public lockDaysTime;
484 
485     modifier checkBeneficiaryExist(address _addr) {
486         require(beneficiaryList.length-1 != 0);
487         require(userBeneficiaryMap[_addr] != 0);
488         require(beneficiaryList[userBeneficiaryMap[_addr]].beneficiaryAddr == _addr);
489         _;
490     }
491 
492     function balanceOfPool() public view returns (uint256){
493         return token.balanceOf(address(this));
494     }
495 
496     function getRemainAmount() public view returns (uint256) {
497         return INITIAL_LOCK_AMOUNT.sub(getAllocatedAmount());
498     }
499 
500     function totalBeneficiaryCount() public view returns (uint256) {
501         return beneficiaryList.length-1;
502     }
503 
504     function getAllocatedAmount() public view returns (uint256){
505         uint256 _beneficiaryCount = beneficiaryList.length;
506         uint256 totalValue;
507         for (uint256 i=1; i < _beneficiaryCount; i++) { // start from 1, for using 0 as null
508             totalValue = totalValue.add(beneficiaryList[i].initialAmount);
509         }
510         return totalValue;
511     }
512 
513     function _checkIsReleasable(address addr, uint256 releasingPointId) internal view returns(bool){
514         if (beneficiaryList[userBeneficiaryMap[addr]].releasingPointStateList[releasingPointId] == false &&
515             now >= beneficiaryList[userBeneficiaryMap[addr]].releasingPointDateList[releasingPointId]) {
516                 return true;
517         }
518         else{
519             return false;
520         }
521     }
522 
523     function checkIsReleasableById(uint256 id, uint256 releasingPointId) internal view returns(bool){
524         if (beneficiaryList[id].releasingPointStateList[releasingPointId] == false &&
525             now >= beneficiaryList[id].releasingPointDateList[releasingPointId]) {
526                 return true;
527         }
528         else{
529             return false;
530         }
531     }
532 
533     function getUnlockedAmountPocket(address addr) public checkBeneficiaryExist(addr) view returns (uint256) {
534 
535         uint256 totalValue;
536         for (uint256 i=0; i < lockMonths; i++) {
537 
538             if (_checkIsReleasable(addr, i)){
539                 totalValue = totalValue.add(beneficiaryList[userBeneficiaryMap[addr]].releasingPointValueList[i]);
540             }
541         }
542         return totalValue;
543     }
544 
545     function getTransferCompletedAmount() public view returns (uint256) {
546         uint256 _beneficiaryCount = beneficiaryList.length;
547         uint256 totalValue;
548         for (uint256 i=1; i < _beneficiaryCount; i++) { // start from 1, for using 0 as null
549             totalValue = totalValue.add(beneficiaryList[i].transferCompletedAmount);
550         }
551         return totalValue;
552     }
553 
554     function getReleasingPoint(uint256 beneficiaryId, uint256 index) public view returns (uint256 _now, uint256 date, uint256 value, bool state, bool releasable){
555         return (now, beneficiaryList[beneficiaryId].releasingPointDateList[index], beneficiaryList[beneficiaryId].releasingPointValueList[index], beneficiaryList[beneficiaryId].releasingPointStateList[index], checkIsReleasableById(beneficiaryId, index));
556     }
557 
558     event AllocateLockupToken(address indexed beneficiaryAddr, uint256 initialAmount, uint256 lockupPeriodStartDate, uint256 releaseStartDate, uint256 releaseEndDate, uint256 id);
559 
560     struct Beneficiary {
561         uint256 id;
562         address beneficiaryAddr;
563         uint256 initialAmount;
564         uint256 transferCompletedAmount;
565         uint256 lockupPeriodStartDate;  // ownerGivedDate
566         uint256 releaseStartDate; // lockupPeriodEnxDate
567         uint256[] releasingPointDateList;
568         uint256[] releasingPointValueList;
569         bool[] releasingPointStateList;
570         uint256 releaseEndDate;
571         uint8 bType;
572     }
573 
574     Beneficiary[] public beneficiaryList;
575     mapping (address => uint256) public userBeneficiaryMap;
576     /**
577      * @dev Constructor that gives msg.sender all of existing tokens.
578      */
579     constructor (uint256 _lockMonths, uint256 _lockAmount, address poolOwner, address tokenAddr) public Ownable(poolOwner){
580         require(36 >= _lockMonths); // optional
581         token = IERC20(tokenAddr);
582         lockMonths = _lockMonths;
583         INITIAL_LOCK_AMOUNT = _lockAmount;
584         lockDays = lockMonths * 30;  // 1 mounth ~= 30 days
585         lockDaysTime = lockDays * 60 * 60 * 24; // 1 day == 86400 sec
586         beneficiaryList.length = beneficiaryList.length.add(1); // start from 1, for using 0 as null
587     }
588 
589     function allocateLockupToken(address _beneficiaryAddr, uint256 amount, uint8 _type) onlyOwner public returns (uint256 _beneficiaryId) {
590         require(userBeneficiaryMap[_beneficiaryAddr] == 0);  // already check
591         require(getRemainAmount() >= amount);
592         Beneficiary memory beneficiary = Beneficiary({
593             id: beneficiaryList.length,
594             beneficiaryAddr: _beneficiaryAddr,
595             initialAmount: amount,
596             transferCompletedAmount: 0,
597             lockupPeriodStartDate: uint256(now), // now == block.timestamp
598             releaseStartDate: uint256(now).add(lockDaysTime),
599             releasingPointDateList: new uint256[](lockMonths), // not return in ABCI v1
600             releasingPointValueList: new uint256[](lockMonths),
601             releasingPointStateList: new bool[](lockMonths),
602             releaseEndDate: 0,
603             bType: _type
604             });
605 
606         beneficiary.releaseEndDate = beneficiary.releaseStartDate.add(lockDaysTime);
607         uint256 remainAmount = beneficiary.initialAmount;
608         for (uint256 i=0; i < lockMonths; i++) {
609             beneficiary.releasingPointDateList[i] = beneficiary.releaseStartDate.add(lockDaysTime.div(lockMonths).mul(i.add(1)));
610             beneficiary.releasingPointStateList[i] = false;
611             if (i.add(1) != lockMonths){
612                 beneficiary.releasingPointValueList[i] = uint256(beneficiary.initialAmount.div(lockMonths));
613                 remainAmount = remainAmount.sub(beneficiary.releasingPointValueList[i]);
614             }
615             else{
616                 beneficiary.releasingPointValueList[i] = remainAmount;
617             }
618         }
619 
620         beneficiaryList.push(beneficiary);
621         userBeneficiaryMap[_beneficiaryAddr] = beneficiary.id;
622 
623         emit AllocateLockupToken(beneficiary.beneficiaryAddr, beneficiary.initialAmount, beneficiary.lockupPeriodStartDate, beneficiary.releaseStartDate, beneficiary.releaseEndDate, beneficiary.id);
624         return beneficiary.id;
625     }
626     event Claim(address indexed beneficiaryAddr, uint256 indexed beneficiaryId, uint256 value);
627     function claim () public checkBeneficiaryExist(msg.sender) returns (uint256) {
628         uint256 unlockedAmount = getUnlockedAmountPocket(msg.sender);
629         require(unlockedAmount > 0);
630 
631         uint256 totalValue;
632         for (uint256 i=0; i < lockMonths; i++) {
633             if (_checkIsReleasable(msg.sender, i)){
634                 beneficiaryList[userBeneficiaryMap[msg.sender]].releasingPointStateList[i] = true;
635                 totalValue = totalValue.add(beneficiaryList[userBeneficiaryMap[msg.sender]].releasingPointValueList[i]);
636             }
637         }
638         require(unlockedAmount == totalValue);
639         token.safeTransfer(msg.sender, totalValue);
640         beneficiaryList[userBeneficiaryMap[msg.sender]].transferCompletedAmount = beneficiaryList[userBeneficiaryMap[msg.sender]].transferCompletedAmount.add(totalValue);
641         emit Claim(beneficiaryList[userBeneficiaryMap[msg.sender]].beneficiaryAddr, beneficiaryList[userBeneficiaryMap[msg.sender]].id, totalValue);
642         return totalValue;
643     }
644 }
645 
646 /////////////////////////////////////////////////////////////////////////
647 // ToriToken Contract
648 /////////////////////////////////////////////////////////////////////////
649 contract ToriToken is ERC20, ERC20Detailed {
650     using SafeERC20 for IERC20;
651     using SafeMath for uint256;
652     uint8 public constant DECIMALS = 18;
653     uint256 public constant INITIAL_SUPPLY = 4000000000 * (10 ** uint256(DECIMALS));
654 
655     uint256 public remainReleased = INITIAL_SUPPLY;
656 
657     address private _owner;
658 
659     // no lockup ( with addresses )
660     address public initialSale = 0x4dEF0A02D30cdf62AB6e513e978dB8A58ed86B53;
661     address public saleCPool = 0xF3963A437E0e156e8102414DE3a9CC6E38829ea1;
662     address public ecoPool = 0xf6e25f35C3c5cF40035B7afD1e9F5198594f600e;
663     address public reservedPool = 0x557e4529D5784D978fCF7A5a20a184a78AF597D5;
664     address public marketingPool = 0xEeE05AfD6E1e02b6f86Dd1664689cC46Ab0D7B20;
665 
666     uint256 public initialSaleAmount = 600000000 ether;
667     uint256 public saleCPoolAmount = 360000000 ether;
668     uint256 public ecoPoolAmount = 580000000 ether;
669     uint256 public reservedPoolAmount = 600000000 ether;
670     uint256 public marketingPoolAmount = 80000000 ether;
671 
672     // with lockup ( with addresses )
673     address public saleBPoolOwner = 0xB7F1ea2af2a9Af419F093f62bDD67Df914b0ff2E;
674     address public airDropPoolOwner = 0x590d6d6817ed53142BF69F16725D596dAaE9a6Ce;
675     address public companyPoolOwner = 0x1b0E91D484eb69424100A48c74Bfb450ea494445;
676     address public productionPartnerPoolOwner = 0x0c0CD85EA55Ea1B6210ca89827FA15f9F10D56F6;
677     address public advisorPoolOwner = 0x68F0D15D17Aa71afB14d72C97634977495dF4d0E;
678     address public teamPoolOwner = 0x5A353e276F68558bEA884b13017026A6F1067951;
679 
680     uint256 public saleBPoolAmount = 420000000 ether;
681     uint256 public airDropPoolAmount = 200000000 ether;
682     uint256 public companyPoolAmount = 440000000 ether;
683     uint256 public productionPartnerPoolAmount = 200000000 ether;
684     uint256 public advisorPoolAmount = 120000000 ether;
685     uint256 public teamPoolAmount = 400000000 ether;
686 
687     uint8 public saleBPoolLockupPeriod = 12;
688     uint8 public airDropPoolLockupPeriod = 3;
689     uint8 public companyPoolLockupPeriod = 12;
690     uint8 public productionPartnerPoolLockupPeriod = 6;
691     uint8 public advisorPoolLockupPeriod = 12;
692     uint8 public teamPoolLockupPeriod = 24;
693 
694     LockerPool public saleBPool;
695     LockerPool public airDropPool;
696     LockerPool public companyPool;
697     LockerPool public productionPartnerPool;
698     LockerPool public advisorPool;
699     LockerPool public teamPool;
700 
701     bool private _deployedOuter;
702     bool private _deployedInner;
703 
704     function deployLockersOuter() public {
705         require(!_deployedOuter);
706         saleBPool = new LockerPool(saleBPoolLockupPeriod, saleBPoolAmount, saleBPoolOwner, address(this));
707         airDropPool = new LockerPool(airDropPoolLockupPeriod, airDropPoolAmount, airDropPoolOwner, address(this));
708         productionPartnerPool = new LockerPool(productionPartnerPoolLockupPeriod, productionPartnerPoolAmount, productionPartnerPoolOwner, address(this));
709         _deployedOuter = true;
710         _mint(address(saleBPool), saleBPoolAmount);
711         _mint(address(airDropPool), airDropPoolAmount);
712         _mint(address(productionPartnerPool), productionPartnerPoolAmount);
713     }
714 
715     function deployLockersInner() public {
716         require(!_deployedInner);
717         companyPool = new LockerPool(companyPoolLockupPeriod, companyPoolAmount, companyPoolOwner, address(this));
718         advisorPool = new LockerPool(advisorPoolLockupPeriod, advisorPoolAmount, advisorPoolOwner, address(this));
719         teamPool = new LockerPool(teamPoolLockupPeriod, teamPoolAmount, teamPoolOwner, address(this));
720         _deployedInner = true;
721         _mint(address(companyPool), companyPoolAmount);
722         _mint(address(advisorPool), advisorPoolAmount);
723         _mint(address(teamPool), teamPoolAmount);
724     }
725 
726     constructor () public ERC20Detailed("Storichain", "TORI", DECIMALS) {
727         _mint(address(initialSale), initialSaleAmount);
728         _mint(address(saleCPool), saleCPoolAmount);
729         _mint(address(ecoPool), ecoPoolAmount);
730         _mint(address(reservedPool), reservedPoolAmount);
731         _mint(address(marketingPool), marketingPoolAmount);
732         _deployedOuter = false;
733         _deployedInner = false;
734     }
735 }