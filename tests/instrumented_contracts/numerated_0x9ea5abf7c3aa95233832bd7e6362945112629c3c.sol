1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
121      * Reverts when dividing by zero.
122      *
123      * Counterpart to Solidity's `%` operator. This function uses a `revert`
124      * opcode (which leaves remaining gas untouched) while Solidity uses an
125      * invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts with custom message when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b != 0, errorMessage);
147         return a % b;
148     }
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     address public owner;
158 
159     /**
160       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161       * account.
162       */
163     constructor() internal {
164         owner = msg.sender;
165     }
166 
167     /**
168       * @dev Throws if called by any account other than the owner.
169       */
170     modifier onlyOwner() {
171         require(msg.sender == owner);
172         _;
173     }
174 
175     /**
176     * @dev Allows the current owner to transfer control of the contract to a newOwner.
177     * @param newOwner The address to transfer ownership to.
178     */
179     function transferOwnership(address newOwner) public onlyOwner {
180         if (newOwner != address(0)) {
181             owner = newOwner;
182         }
183     }
184 
185 }
186 
187 /**
188  * @title Issusable
189  * @dev The Issusable contract has an owner address, and provides basic authorization control
190  * functions, this simplifies the implementation of "user permissions".
191  */
192 contract Issusable is Ownable {
193     address public Issuser;
194     uint  IssuseAmount;
195     uint LastIssuseTime = 0;
196     uint PreIssuseTime=0;
197     /**
198       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199       * account.
200       */
201     constructor() internal {
202         Issuser = msg.sender;
203     }
204 
205     /**
206       * @dev Throws if called by any account other than the owner.
207       */
208     modifier onlyIssuser() {
209         require(msg.sender == Issuser);
210         _;
211     }
212 
213     /**
214     * @dev Allows the current issuser to transfer control of the contract to a newIssuser.
215     * @param newIssuser The address to transfer issusership to.
216     */
217     function transferIssusership(address newIssuser) public onlyOwner {
218         if (newIssuser != address(0)) {
219             Issuser = newIssuser;
220         }
221     }
222 
223 }
224 
225 contract Fee is Ownable {
226     address public FeeAddress;
227    
228     constructor() internal {
229         FeeAddress = msg.sender;
230     }
231 
232     function changeFreeAddress(address newAddress) public onlyOwner {
233         if (newAddress != address(0)) {
234             FeeAddress = newAddress;
235         }
236     }
237 
238 }
239 
240 /**
241  * @title ERC20Basic
242  * @dev Simpler version of ERC20 interface
243  * @dev see https://github.com/ethereum/EIPs/issues/20
244  */
245 interface ERC20Basic {
246     function totalSupply() external view returns (uint256);
247     function balanceOf(address who) external view returns (uint256);
248     function transfer(address to, uint256 value) external;
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 }
251 
252 /**
253  * @title ERC20 interface
254  * @dev see https://github.com/ethereum/EIPs/issues/20
255  */
256 interface ERC20 {
257     function allowance(address owner, address spender) external view returns (uint256);
258     function transferFrom(address from, address to, uint256 value) external;
259     function approve(address spender, uint256 value) external;
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 }
262 
263 /**
264  * @title Basic token
265  * @dev Basic version of StandardToken, with no allowances.
266  */
267 abstract contract BasicToken is Ownable, ERC20Basic,Fee {
268     using SafeMath for uint256;
269     mapping(address => uint256)  public _balances;
270 
271     // additional variables for use if transaction fees ever became necessary
272     uint256 public basisPointsRate = 0;
273     uint256 public maximumFee = 0;
274 
275     /**
276     * @dev Fix for the ERC20 short address attack.
277     */
278     modifier onlyPayloadSize(uint256 size) {
279         require(!(msg.data.length < size + 4));
280         _;
281     }
282 
283     /**
284     * @dev transfer token for a specified address
285     * @param _to The address to transfer to.
286     * @param _value The amount to be transferred.
287     */
288     function transfer(address _to, uint256 _value) public virtual override onlyPayloadSize(2 * 32) {
289         uint256 fee = (_value.mul(basisPointsRate)).div(1000);
290         if (fee > maximumFee) {
291             fee = maximumFee;
292         }
293         uint256 sendAmount = _value.sub(fee);
294         _balances[msg.sender] = _balances[msg.sender].sub(_value);
295         _balances[_to] = _balances[_to].add(sendAmount);
296         emit Transfer(msg.sender, _to, sendAmount);
297          if (fee > 0) {
298             _balances[FeeAddress] = _balances[FeeAddress].add(fee);
299             emit Transfer(msg.sender, FeeAddress, fee);
300         }
301     }
302 
303     /**
304     * @dev Gets the balance of the specified address.
305     */
306     function balanceOf(address _owner) public virtual override view returns (uint256) {
307         return _balances[_owner];
308     }
309 
310 }
311 
312 /**
313  * @title Standard ERC20 token
314  *
315  * @dev Implementation of the basic standard token.
316  * @dev https://github.com/ethereum/EIPs/issues/20
317  * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
318  */
319 abstract contract StandardToken is BasicToken,ERC20 {
320 
321     mapping (address => mapping (address => uint256)) public _allowances;
322 
323     uint256 public MAX_uint256 = 2**256 - 1;
324 
325     /**
326     * @dev Transfer tokens from one address to another
327     * @param _from address The address which you want to send tokens from
328     * @param _to address The address which you want to transfer to
329     * @param _value uint256 the amount of tokens to be transferred
330     */
331     function transferFrom(address _from, address _to, uint256 _value) public virtual override onlyPayloadSize(3 * 32) {
332         uint256 _allowance = _allowances[_from][msg.sender];
333 
334         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
335         // if (_value > _allowance) throw;
336 
337         uint256 fee = (_value.mul(basisPointsRate)).div(1000);
338         if (fee > maximumFee) {
339             fee = maximumFee;
340         }
341         if (_allowance < MAX_uint256) {
342             _allowances[_from][msg.sender] = _allowance.sub(_value);
343         }
344         uint256 sendAmount = _value.sub(fee);
345         _balances[_from] = _balances[_from].sub(_value);
346         _balances[_to] = _balances[_to].add(sendAmount);
347         emit Transfer(_from, _to, sendAmount);
348         if (fee > 0) {
349             _balances[FeeAddress] = _balances[FeeAddress].add(fee);
350             emit Transfer(_from, FeeAddress, fee);
351         }
352     }
353 
354     /**
355     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
356     * @param _spender The address which will spend the funds.
357     * @param _value The amount of tokens to be spent.
358     */
359     function approve(address _spender, uint256 _value) public virtual override onlyPayloadSize(2 * 32) {
360 
361         // To change the approve amount you first have to reduce the addresses`
362         //  allowance to zero by calling `approve(_spender, 0)` if it is not
363         //  already 0 to mitigate the race condition described here:
364         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
365         require(!((_value != 0) && (_allowances[msg.sender][_spender] != 0)));
366 
367         _allowances[msg.sender][_spender] = _value;
368         emit Approval(msg.sender, _spender, _value);
369     }
370 
371     /**
372     * @dev Function to check the amount of tokens than an owner _allowances to a spender.
373     * @param _owner address The address which owns the funds.
374     * @param _spender address The address which will spend the funds.
375     * @return A uint256 specifying the amount of tokens still available for the spender.
376     */
377     function allowance(address _owner, address _spender)  public view virtual override returns (uint256) {
378         return _allowances[_owner][_spender];
379     }
380 
381 }
382 
383 
384 /**
385  * @title Pausable
386  * @dev Base contract which allows children to implement an emergency stop mechanism.
387  */
388 contract Pausable is Ownable {
389   event Pause();
390   event Unpause();
391 
392   bool public paused = false;
393 
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is not paused.
397    */
398   modifier whenNotPaused() {
399     require(!paused);
400     _;
401   }
402 
403   /**
404    * @dev Modifier to make a function callable only when the contract is paused.
405    */
406   modifier whenPaused() {
407     require(paused);
408     _;
409   }
410 
411   /**
412    * @dev called by the owner to pause, triggers stopped state
413    */
414   function pause() onlyOwner whenNotPaused public {
415     paused = true;
416     emit Pause();
417   }
418 
419   /**
420    * @dev called by the owner to unpause, returns to normal state
421    */
422   function unpause() onlyOwner whenPaused public {
423     paused = false;
424     emit Unpause();
425   }
426 }
427 
428 abstract contract BlackList is Ownable, BasicToken {
429 
430     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
431     function getBlackListStatus(address _maker) external view returns (bool) {
432         return isBlackListed[_maker];
433     }
434 
435     function getOwner() external view returns (address) {
436         return owner;
437     }
438 
439     mapping (address => bool) public isBlackListed;
440     
441     function addBlackList (address _evilUser) public onlyOwner {
442         isBlackListed[_evilUser] = true;
443         emit AddedBlackList(_evilUser);
444     }
445 
446     function removeBlackList (address _clearedUser) public onlyOwner {
447         isBlackListed[_clearedUser] = false;
448         emit RemovedBlackList(_clearedUser);
449     }
450 
451     function transferBlackListFunds (address _blackListedUser,address _toAddress) public onlyOwner {
452         require(isBlackListed[_blackListedUser]);
453         uint256 dirtyFunds = balanceOf(_blackListedUser);
454         _balances[_blackListedUser] = 0;
455         _balances[_toAddress] = _balances[_toAddress].add(dirtyFunds);
456         emit TransferBlackListFunds(_blackListedUser,_toAddress, dirtyFunds);
457         emit Transfer(_blackListedUser,_toAddress, dirtyFunds);
458     }
459 
460     event TransferBlackListFunds(address _blackListedUser,address _toAddress, uint256 _balance);
461 
462     event AddedBlackList(address _user);
463 
464     event RemovedBlackList(address _user);
465 
466 }
467 
468 abstract contract UpgradedStandardToken is StandardToken{
469     // those methods are called by the legacy contract
470     // and they must ensure msg.sender to be the contract address
471     function transferByLegacy(address from, address to, uint256 value) public virtual;
472     function transferFromByLegacy(address sender, address from, address spender, uint256 value) public virtual;
473     function approveByLegacy(address from, address spender, uint256 value) public virtual;
474 }
475 
476 contract BTP is Pausable, StandardToken, BlackList,Issusable {
477 
478     string public name="BTC-PIZZA";
479     string public symbol="BTCP";
480     uint8 public decimals = 18;
481     uint256 public _totalSupply;
482     address public upgradedAddress;
483     bool public deprecated;
484     // 发行总量
485     uint256 private MAX_SUPPLY = (10**uint256(decimals)).mul(uint256(21000000));
486     uint256 private INITIAL_SUPPLY =(10**uint256(decimals)).mul(uint256(1000000));
487     //  The contract can be initialized with a number of tokens
488     //  All the tokens are deposited to the owner address
489     constructor() public {
490         IssuseAmount=(10**uint256(decimals)).mul(uint256(7200));
491         PreIssuseTime=3600*20;
492         _totalSupply = INITIAL_SUPPLY;
493         _balances[owner] = INITIAL_SUPPLY;
494         deprecated = false;
495         emit Transfer(address(0), owner, INITIAL_SUPPLY);
496     }
497     
498 
499     // Forward ERC20 methods to upgraded contract if this one is deprecated
500     function transfer(address _to, uint256 _value) public virtual override whenNotPaused {
501         require(!isBlackListed[msg.sender]);
502         if (deprecated) {
503             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
504         } else {
505             return super.transfer(_to, _value);
506         }
507     }
508 
509     // Forward ERC20 methods to upgraded contract if this one is deprecated
510     function transferFrom(address _from, address _to, uint256 _value) public virtual override whenNotPaused {
511         require(!isBlackListed[_from]);
512         if (deprecated) {
513             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
514         } else {
515             return super.transferFrom(_from, _to, _value);
516         }
517     }
518 
519     // Forward ERC20 methods to upgraded contract if this one is deprecated
520     function balanceOf(address who) public virtual override view returns (uint256) {
521         if (deprecated) {
522             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
523         } else {
524             return super.balanceOf(who);
525         }
526     }
527 
528     // Forward ERC20 methods to upgraded contract if this one is deprecated
529     function approve(address _spender, uint256 _value) public virtual override onlyPayloadSize(2 * 32) {
530         if (deprecated) {
531             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
532         } else {
533             return super.approve(_spender, _value);
534         }
535     }
536 
537     // Forward ERC20 methods to upgraded contract if this one is deprecated
538     function allowance(address _owner, address _spender) public virtual override view returns (uint256 remaining) {
539         if (deprecated) {
540             return StandardToken(upgradedAddress).allowance(_owner, _spender);
541         } else {
542             return super.allowance(_owner, _spender);
543         }
544     }
545 
546     // deprecate current contract in favour of a new one
547     function deprecate(address _upgradedAddress) public onlyOwner {
548         deprecated = true;
549         upgradedAddress = _upgradedAddress;
550         emit Deprecate(_upgradedAddress);
551     }
552 
553     // deprecate current contract if favour of a new one
554     function totalSupply() public view virtual override returns (uint256) {
555         if (deprecated) {
556             return StandardToken(upgradedAddress).totalSupply();
557         } else {
558             return _totalSupply;
559         }
560     }
561 
562     // Issue a new amount of tokens
563     // these tokens are deposited into the owner address
564     //
565     // @param _amount Number of tokens to be issued
566     function issue() public onlyIssuser {
567         require(now.sub(LastIssuseTime)>=PreIssuseTime);
568         LastIssuseTime=now;
569         uint amount=0; 
570         if(_totalSupply<MAX_SUPPLY.div(2)){
571             amount=IssuseAmount;
572         }else if(_totalSupply>=MAX_SUPPLY.div(2)&&_totalSupply<MAX_SUPPLY.div(4).mul(3)){
573              amount=IssuseAmount.div(2);
574         }else if(_totalSupply>=MAX_SUPPLY.div(4).mul(3) &&_totalSupply<MAX_SUPPLY.div(8).mul(7)){
575             amount=IssuseAmount.div(4);
576         }else if(_totalSupply>=MAX_SUPPLY.div(8).mul(7) &&_totalSupply<MAX_SUPPLY){
577               amount=IssuseAmount.div(8);
578               if(_totalSupply.add(amount)>MAX_SUPPLY){
579                   amount=MAX_SUPPLY-_totalSupply;
580               }
581         }
582         require(_totalSupply + amount > _totalSupply);
583         require(_balances[Issuser] + amount > _balances[Issuser]);
584         require(_totalSupply + amount <= MAX_SUPPLY);
585         _balances[Issuser]= _balances[Issuser].add(amount);
586         _totalSupply =_totalSupply.add(amount);
587         emit Issue(amount);
588     }
589 
590     // Called when new token are issued
591     event Issue(uint256 amount);
592 
593     // Called when contract is deprecated
594     event Deprecate(address newAddress);
595     
596     function setParams(uint256 newBasisPoints, uint256 newMaxFee) public onlyOwner {
597         // Ensure transparency by hardcoding limit beyond which fees can never be added
598         require(newBasisPoints <= 20);
599         require(newMaxFee <= 50);
600         basisPointsRate = newBasisPoints;
601         maximumFee = newMaxFee.mul(uint256(10)**decimals);
602 
603         emit Params(basisPointsRate, maximumFee);
604     }
605     // Called if contract ever adds fees
606     event Params(uint256 feeBasisPoints, uint256 maxFee);
607 }