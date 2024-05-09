1 pragma solidity ^0.5.2;
2 
3 /*
4 
5     2019 Tether Token - tether.to
6     Deployed by Will Harborne - will@ethfinex.com
7     
8 */
9 
10 /**
11  * @title Roles
12  * @dev Library for managing addresses assigned to a Role.
13  */
14 library Roles {
15     struct Role {
16         mapping (address => bool) bearer;
17     }
18 
19     /**
20      * @dev give an account access to this role
21      */
22     function add(Role storage role, address account) internal {
23         require(account != address(0));
24         require(!has(role, account));
25 
26         role.bearer[account] = true;
27     }
28 
29     /**
30      * @dev remove an account's access to this role
31      */
32     function remove(Role storage role, address account) internal {
33         require(account != address(0));
34         require(has(role, account));
35 
36         role.bearer[account] = false;
37     }
38 
39     /**
40      * @dev check if an account has this role
41      * @return bool
42      */
43     function has(Role storage role, address account) internal view returns (bool) {
44         require(account != address(0));
45         return role.bearer[account];
46     }
47 }
48 
49 
50 contract PauserRole {
51     using Roles for Roles.Role;
52 
53     event PauserAdded(address indexed account);
54     event PauserRemoved(address indexed account);
55 
56     Roles.Role private _pausers;
57 
58     constructor () internal {
59         _addPauser(msg.sender);
60     }
61 
62     modifier onlyPauser() {
63         require(isPauser(msg.sender));
64         _;
65     }
66 
67     function isPauser(address account) public view returns (bool) {
68         return _pausers.has(account);
69     }
70 
71     function addPauser(address account) public onlyPauser {
72         _addPauser(account);
73     }
74 
75     function renouncePauser() public {
76         _removePauser(msg.sender);
77     }
78 
79     function _addPauser(address account) internal {
80         _pausers.add(account);
81         emit PauserAdded(account);
82     }
83 
84     function _removePauser(address account) internal {
85         _pausers.remove(account);
86         emit PauserRemoved(account);
87     }
88 }
89 
90 
91 /**
92  * @title Pausable
93  * @dev Base contract which allows children to implement an emergency stop mechanism.
94  */
95 contract Pausable is PauserRole {
96     event Paused(address account);
97     event Unpaused(address account);
98 
99     bool private _paused;
100 
101     constructor () internal {
102         _paused = false;
103     }
104 
105     /**
106      * @return true if the contract is paused, false otherwise.
107      */
108     function paused() public view returns (bool) {
109         return _paused;
110     }
111 
112     /**
113      * @dev Modifier to make a function callable only when the contract is not paused.
114      */
115     modifier whenNotPaused() {
116         require(!_paused);
117         _;
118     }
119 
120     /**
121      * @dev Modifier to make a function callable only when the contract is paused.
122      */
123     modifier whenPaused() {
124         require(_paused);
125         _;
126     }
127 
128     /**
129      * @dev called by the owner to pause, triggers stopped state
130      */
131     function pause() public onlyPauser whenNotPaused {
132         _paused = true;
133         emit Paused(msg.sender);
134     }
135 
136     /**
137      * @dev called by the owner to unpause, returns to normal state
138      */
139     function unpause() public onlyPauser whenPaused {
140         _paused = false;
141         emit Unpaused(msg.sender);
142     }
143 }
144 
145 /**
146  * @title Ownable
147  * @dev The Ownable contract has an owner address, and provides basic authorization control
148  * functions, this simplifies the implementation of "user permissions".
149  */
150 contract Ownable {
151     address private _owner;
152 
153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
154 
155     /**
156      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157      * account.
158      */
159     constructor () internal {
160         _owner = msg.sender;
161         emit OwnershipTransferred(address(0), _owner);
162     }
163 
164     /**
165      * @return the address of the owner.
166      */
167     function owner() public view returns (address) {
168         return _owner;
169     }
170 
171     /**
172      * @dev Throws if called by any account other than the owner.
173      */
174     modifier onlyOwner() {
175         require(isOwner());
176         _;
177     }
178 
179     /**
180      * @return true if `msg.sender` is the owner of the contract.
181      */
182     function isOwner() public view returns (bool) {
183         return msg.sender == _owner;
184     }
185 
186     /**
187      * @dev Allows the current owner to relinquish control of the contract.
188      * It will not be possible to call the functions with the `onlyOwner`
189      * modifier anymore.
190      * @notice Renouncing ownership will leave the contract without an owner,
191      * thereby removing any functionality that is only available to the owner.
192      */
193     function renounceOwnership() public onlyOwner {
194         emit OwnershipTransferred(_owner, address(0));
195         _owner = address(0);
196     }
197 
198     /**
199      * @dev Allows the current owner to transfer control of the contract to a newOwner.
200      * @param newOwner The address to transfer ownership to.
201      */
202     function transferOwnership(address newOwner) public onlyOwner {
203         _transferOwnership(newOwner);
204     }
205 
206     /**
207      * @dev Transfers control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function _transferOwnership(address newOwner) internal {
211         require(newOwner != address(0));
212         emit OwnershipTransferred(_owner, newOwner);
213         _owner = newOwner;
214     }
215 }
216 
217 
218 /**
219  * @title ERC20 interface
220  * @dev see https://eips.ethereum.org/EIPS/eip-20
221  */
222 interface IERC20 {
223     function transfer(address to, uint256 value) external returns (bool);
224 
225     function approve(address spender, uint256 value) external returns (bool);
226 
227     function transferFrom(address from, address to, uint256 value) external returns (bool);
228 
229     function totalSupply() external view returns (uint256);
230 
231     function balanceOf(address who) external view returns (uint256);
232 
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     event Approval(address indexed owner, address indexed spender, uint256 value);
238 }
239 
240 /**
241  * @title SafeMath
242  * @dev Unsigned math operations with safety checks that revert on error
243  */
244 library SafeMath {
245     /**
246      * @dev Multiplies two unsigned integers, reverts on overflow.
247      */
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250         // benefit is lost if 'b' is also tested.
251         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
252         if (a == 0) {
253             return 0;
254         }
255 
256         uint256 c = a * b;
257         require(c / a == b);
258 
259         return c;
260     }
261 
262     /**
263      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         // Solidity only automatically asserts when dividing by 0
267         require(b > 0);
268         uint256 c = a / b;
269         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
270 
271         return c;
272     }
273 
274     /**
275      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
276      */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         require(b <= a);
279         uint256 c = a - b;
280 
281         return c;
282     }
283 
284     /**
285      * @dev Adds two unsigned integers, reverts on overflow.
286      */
287     function add(uint256 a, uint256 b) internal pure returns (uint256) {
288         uint256 c = a + b;
289         require(c >= a);
290 
291         return c;
292     }
293 
294     /**
295      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
296      * reverts when dividing by zero.
297      */
298     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
299         require(b != 0);
300         return a % b;
301     }
302 }
303 
304 
305 /**
306  * @title Standard ERC20 token
307  *
308  * @dev Implementation of the basic standard token.
309  * https://eips.ethereum.org/EIPS/eip-20
310  * Originally based on code by FirstBlood:
311  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
312  *
313  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
314  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
315  * compliant implementations may not do it.
316  */
317 contract ERC20 is IERC20 {
318     using SafeMath for uint256;
319 
320     mapping (address => uint256) private _balances;
321 
322     mapping (address => mapping (address => uint256)) private _allowed;
323 
324     uint256 private _totalSupply;
325 
326     /**
327      * @dev Total number of tokens in existence
328      */
329     function totalSupply() public view returns (uint256) {
330         return _totalSupply;
331     }
332 
333     /**
334      * @dev Gets the balance of the specified address.
335      * @param owner The address to query the balance of.
336      * @return A uint256 representing the amount owned by the passed address.
337      */
338     function balanceOf(address owner) public view returns (uint256) {
339         return _balances[owner];
340     }
341 
342     /**
343      * @dev Function to check the amount of tokens that an owner allowed to a spender.
344      * @param owner address The address which owns the funds.
345      * @param spender address The address which will spend the funds.
346      * @return A uint256 specifying the amount of tokens still available for the spender.
347      */
348     function allowance(address owner, address spender) public view returns (uint256) {
349         return _allowed[owner][spender];
350     }
351 
352     /**
353      * @dev Transfer token to a specified address
354      * @param to The address to transfer to.
355      * @param value The amount to be transferred.
356      */
357     function transfer(address to, uint256 value) public returns (bool) {
358         _transfer(msg.sender, to, value);
359         return true;
360     }
361 
362     /**
363      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364      * Beware that changing an allowance with this method brings the risk that someone may use both the old
365      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
366      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      * @param spender The address which will spend the funds.
369      * @param value The amount of tokens to be spent.
370      */
371     function approve(address spender, uint256 value) public returns (bool) {
372         _approve(msg.sender, spender, value);
373         return true;
374     }
375 
376     /**
377      * @dev Transfer tokens from one address to another.
378      * Note that while this function emits an Approval event, this is not required as per the specification,
379      * and other compliant implementations may not emit the event.
380      * @param from address The address which you want to send tokens from
381      * @param to address The address which you want to transfer to
382      * @param value uint256 the amount of tokens to be transferred
383      */
384     function transferFrom(address from, address to, uint256 value) public returns (bool) {
385         _transfer(from, to, value);
386         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
387         return true;
388     }
389 
390     /**
391      * @dev Increase the amount of tokens that an owner allowed to a spender.
392      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
393      * allowed value is better to use this function to avoid 2 calls (and wait until
394      * the first transaction is mined)
395      * From MonolithDAO Token.sol
396      * Emits an Approval event.
397      * @param spender The address which will spend the funds.
398      * @param addedValue The amount of tokens to increase the allowance by.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
401         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
402         return true;
403     }
404 
405     /**
406      * @dev Decrease the amount of tokens that an owner allowed to a spender.
407      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
408      * allowed value is better to use this function to avoid 2 calls (and wait until
409      * the first transaction is mined)
410      * From MonolithDAO Token.sol
411      * Emits an Approval event.
412      * @param spender The address which will spend the funds.
413      * @param subtractedValue The amount of tokens to decrease the allowance by.
414      */
415     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
416         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
417         return true;
418     }
419 
420     /**
421      * @dev Transfer token for a specified addresses
422      * @param from The address to transfer from.
423      * @param to The address to transfer to.
424      * @param value The amount to be transferred.
425      */
426     function _transfer(address from, address to, uint256 value) internal {
427         require(to != address(0));
428 
429         _balances[from] = _balances[from].sub(value);
430         _balances[to] = _balances[to].add(value);
431         emit Transfer(from, to, value);
432     }
433 
434     /**
435      * @dev Internal function that mints an amount of the token and assigns it to
436      * an account. This encapsulates the modification of balances such that the
437      * proper events are emitted.
438      * @param account The account that will receive the created tokens.
439      * @param value The amount that will be created.
440      */
441     function _mint(address account, uint256 value) internal {
442         require(account != address(0));
443 
444         _totalSupply = _totalSupply.add(value);
445         _balances[account] = _balances[account].add(value);
446         emit Transfer(address(0), account, value);
447     }
448 
449     /**
450      * @dev Internal function that burns an amount of the token of a given
451      * account.
452      * @param account The account whose tokens will be burnt.
453      * @param value The amount that will be burnt.
454      */
455     function _burn(address account, uint256 value) internal {
456         require(account != address(0));
457 
458         _totalSupply = _totalSupply.sub(value);
459         _balances[account] = _balances[account].sub(value);
460         emit Transfer(account, address(0), value);
461     }
462 
463     /**
464      * @dev Approve an address to spend another addresses' tokens.
465      * @param owner The address that owns the tokens.
466      * @param spender The address that will spend the tokens.
467      * @param value The number of tokens that can be spent.
468      */
469     function _approve(address owner, address spender, uint256 value) internal {
470         require(spender != address(0));
471         require(owner != address(0));
472 
473         _allowed[owner][spender] = value;
474         emit Approval(owner, spender, value);
475     }
476 
477     /**
478      * @dev Internal function that burns an amount of the token of a given
479      * account, deducting from the sender's allowance for said account. Uses the
480      * internal burn function.
481      * Emits an Approval event (reflecting the reduced allowance).
482      * @param account The account whose tokens will be burnt.
483      * @param value The amount that will be burnt.
484      */
485     function _burnFrom(address account, uint256 value) internal {
486         _burn(account, value);
487         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
488     }
489 }
490 
491 contract UpgradedStandardToken is ERC20 {
492     // those methods are called by the legacy contract
493     // and they must ensure msg.sender to be the contract address
494     uint public _totalSupply;
495     function transferByLegacy(address from, address to, uint value) public returns (bool);
496     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
497     function approveByLegacy(address from, address spender, uint value) public returns (bool);
498     function increaseApprovalByLegacy(address from, address spender, uint addedValue) public returns (bool);
499     function decreaseApprovalByLegacy(address from, address spender, uint subtractedValue) public returns (bool);
500 }
501 
502 contract BlackList is Ownable {
503 
504     /////// Getter to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
505     function getBlackListStatus(address _maker) external view returns (bool) {
506         return isBlackListed[_maker];
507     }
508 
509     mapping (address => bool) public isBlackListed;
510 
511     function addBlackList (address _evilUser) public onlyOwner {
512         isBlackListed[_evilUser] = true;
513         emit AddedBlackList(_evilUser);
514     }
515 
516     function removeBlackList (address _clearedUser) public onlyOwner {
517         isBlackListed[_clearedUser] = false;
518         emit RemovedBlackList(_clearedUser);
519     }
520 
521     event AddedBlackList(address indexed _user);
522 
523     event RemovedBlackList(address indexed _user);
524 
525 }
526 
527 contract StandardTokenWithFees is ERC20, Ownable {
528 
529   // Additional variables for use if transaction fees ever became necessary
530   uint256 public basisPointsRate = 0;
531   uint256 public maximumFee = 0;
532   uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;
533   uint256 constant MAX_SETTABLE_FEE = 50;
534 
535   string public name;
536   string public symbol;
537   uint8 public decimals;
538 
539   uint public constant MAX_UINT = 2**256 - 1;
540 
541   function calcFee(uint _value) internal view returns (uint) {
542     uint fee = (_value.mul(basisPointsRate)).div(10000);
543     if (fee > maximumFee) {
544         fee = maximumFee;
545     }
546     return fee;
547   }
548 
549   function transfer(address _to, uint _value) public returns (bool) {
550     uint fee = calcFee(_value);
551     uint sendAmount = _value.sub(fee);
552 
553     super.transfer(_to, sendAmount);
554     if (fee > 0) {
555       super.transfer(owner(), fee);
556     }
557   }
558 
559   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
560     require(_to != address(0));
561     require(_value <= balanceOf(_from));
562     require(_value <= allowance(_from, msg.sender));
563 
564     uint fee = calcFee(_value);
565     uint sendAmount = _value.sub(fee);
566 
567     _transfer(_from, _to, sendAmount);
568     if (allowance(_from, msg.sender) < MAX_UINT) {
569         _approve(_from, msg.sender, allowance(_from, msg.sender).sub(_value));
570     }
571     if (fee > 0) {
572         _transfer(_from, owner(), fee);
573     }
574     return true;
575   }
576 
577   function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
578       // Ensure transparency by hardcoding limit beyond which fees can never be added
579       require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
580       require(newMaxFee < MAX_SETTABLE_FEE);
581 
582       basisPointsRate = newBasisPoints;
583       maximumFee = newMaxFee.mul(uint(10)**decimals);
584 
585       emit Params(basisPointsRate, maximumFee);
586   }
587 
588   // Called if contract ever adds fees
589   event Params(uint feeBasisPoints, uint maxFee);
590 
591 }
592 
593 contract TetherToken is Pausable, StandardTokenWithFees, BlackList {
594 
595     address public upgradedAddress;
596     bool public deprecated;
597 
598     //  The contract can be initialized with a number of tokens
599     //  All the tokens are deposited to the owner address
600     //
601     // @param _balance Initial supply of the contract
602     // @param _name Token Name
603     // @param _symbol Token symbol
604     // @param _decimals Token decimals
605     constructor (uint _initialSupply, string memory _name, string memory _symbol, uint8 _decimals) public {
606         _mint(owner(), _initialSupply);
607         name = _name;
608         symbol = _symbol;
609         decimals = _decimals;
610         deprecated = false;
611         emit Issue(_initialSupply);
612     }
613 
614     // Forward ERC20 methods to upgraded contract if this one is deprecated
615     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
616         require(!isBlackListed[msg.sender]);
617         if (deprecated) {
618             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
619         } else {
620             return super.transfer(_to, _value);
621         }
622     }
623 
624     // Forward ERC20 methods to upgraded contract if this one is deprecated
625     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
626         require(!isBlackListed[_from]);
627         if (deprecated) {
628             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
629         } else {
630             return super.transferFrom(_from, _to, _value);
631         }
632     }
633 
634     // Forward ERC20 methods to upgraded contract if this one is deprecated
635     function balanceOf(address who) public view returns (uint) {
636         if (deprecated) {
637             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
638         } else {
639             return super.balanceOf(who);
640         }
641     }
642 
643     // Allow checks of balance at time of deprecation
644     function oldBalanceOf(address who) public view returns (uint) {
645         if (deprecated) {
646             return super.balanceOf(who);
647         }
648     }
649 
650     // Forward ERC20 methods to upgraded contract if this one is deprecated
651     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
652         if (deprecated) {
653             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
654         } else {
655             return super.approve(_spender, _value);
656         }
657     }
658 
659     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
660         if (deprecated) {
661             return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);
662         } else {
663             return super.increaseAllowance(_spender, _addedValue);
664         }
665     }
666 
667     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
668         if (deprecated) {
669             return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);
670         } else {
671             return super.decreaseAllowance(_spender, _subtractedValue);
672         }
673     }
674 
675     // Forward ERC20 methods to upgraded contract if this one is deprecated
676     function allowance(address _owner, address _spender) public view returns (uint remaining) {
677         if (deprecated) {
678             return IERC20(upgradedAddress).allowance(_owner, _spender);
679         } else {
680             return super.allowance(_owner, _spender);
681         }
682     }
683 
684     // deprecate current contract in favour of a new one
685     function deprecate(address _upgradedAddress) public onlyOwner {
686         require(_upgradedAddress != address(0));
687         deprecated = true;
688         upgradedAddress = _upgradedAddress;
689         emit Deprecate(_upgradedAddress);
690     }
691 
692     // deprecate current contract if favour of a new one
693     function totalSupply() public view returns (uint) {
694         if (deprecated) {
695             return IERC20(upgradedAddress).totalSupply();
696         } else {
697             return super.totalSupply();
698         }
699     }
700 
701     // Issue a new amount of tokens
702     // these tokens are deposited into the owner address
703     //
704     // @param _amount Number of tokens to be issued
705     function issue(uint amount) public onlyOwner {
706         require(!deprecated);
707         _mint(owner(), amount);
708         emit Issue(amount);
709     }
710 
711     // Redeem tokens.
712     // These tokens are withdrawn from the owner address
713     // if the balance must be enough to cover the redeem
714     // or the call will fail.
715     // @param _amount Number of tokens to be issued
716     function redeem(uint amount) public onlyOwner {
717         require(!deprecated);
718         _burn(owner(), amount);
719         emit Redeem(amount);
720     }
721 
722     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
723         require(isBlackListed[_blackListedUser]);
724         uint dirtyFunds = balanceOf(_blackListedUser);
725         _burn(_blackListedUser, dirtyFunds);
726         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
727     }
728 
729     event DestroyedBlackFunds(address indexed _blackListedUser, uint _balance);
730 
731     // Called when new token are issued
732     event Issue(uint amount);
733 
734     // Called when tokens are redeemed
735     event Redeem(uint amount);
736 
737     // Called when contract is deprecated
738     event Deprecate(address newAddress);
739 
740 }