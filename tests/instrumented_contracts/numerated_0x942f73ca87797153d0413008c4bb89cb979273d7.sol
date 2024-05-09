1 pragma solidity ^0.5.15;
2 
3 /*
4 
5     2020 Authentic Matrix Token - ATM
6     
7 */
8 
9 /**
10  * @title Roles
11  * @dev Library for managing addresses assigned to a Role.
12  */
13 library Roles {
14     struct Role {
15         mapping (address => bool) bearer;
16     }
17 
18     /**
19      * @dev give an account access to this role
20      */
21     function add(Role storage role, address account) internal {
22         require(account != address(0));
23         require(!has(role, account));
24 
25         role.bearer[account] = true;
26     }
27 
28     /**
29      * @dev remove an account's access to this role
30      */
31     function remove(Role storage role, address account) internal {
32         require(account != address(0));
33         require(has(role, account));
34 
35         role.bearer[account] = false;
36     }
37 
38     /**
39      * @dev check if an account has this role
40      * @return bool
41      */
42     function has(Role storage role, address account) internal view returns (bool) {
43         require(account != address(0));
44         return role.bearer[account];
45     }
46 }
47 
48 
49 contract PauserRole {
50     using Roles for Roles.Role;
51 
52     event PauserAdded(address indexed account);
53     event PauserRemoved(address indexed account);
54 
55     Roles.Role private _pausers;
56 
57     constructor () internal {
58         _addPauser(msg.sender);
59     }
60 
61     modifier onlyPauser() {
62         require(isPauser(msg.sender));
63         _;
64     }
65 
66     function isPauser(address account) public view returns (bool) {
67         return _pausers.has(account);
68     }
69 
70     function addPauser(address account) public onlyPauser {
71         _addPauser(account);
72     }
73 
74     function renouncePauser() public {
75         _removePauser(msg.sender);
76     }
77 
78     function _addPauser(address account) internal {
79         _pausers.add(account);
80         emit PauserAdded(account);
81     }
82 
83     function _removePauser(address account) internal {
84         _pausers.remove(account);
85         emit PauserRemoved(account);
86     }
87 }
88 
89 
90 /**
91  * @title Pausable
92  * @dev Base contract which allows children to implement an emergency stop mechanism.
93  */
94 contract Pausable is PauserRole {
95     event Paused(address account);
96     event Unpaused(address account);
97 
98     bool private _paused;
99 
100     constructor () internal {
101         _paused = false;
102     }
103 
104     /**
105      * @return true if the contract is paused, false otherwise.
106      */
107     function paused() public view returns (bool) {
108         return _paused;
109     }
110 
111     /**
112      * @dev Modifier to make a function callable only when the contract is not paused.
113      */
114     modifier whenNotPaused() {
115         require(!_paused);
116         _;
117     }
118 
119     /**
120      * @dev Modifier to make a function callable only when the contract is paused.
121      */
122     modifier whenPaused() {
123         require(_paused);
124         _;
125     }
126 
127     /**
128      * @dev called by the owner to pause, triggers stopped state
129      */
130     function pause() public onlyPauser whenNotPaused {
131         _paused = true;
132         emit Paused(msg.sender);
133     }
134 
135     /**
136      * @dev called by the owner to unpause, returns to normal state
137      */
138     function unpause() public onlyPauser whenPaused {
139         _paused = false;
140         emit Unpaused(msg.sender);
141     }
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150     address private _owner;
151 
152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154     /**
155      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156      * account.
157      */
158     constructor () internal {
159         _owner = msg.sender;
160         emit OwnershipTransferred(address(0), _owner);
161     }
162 
163     /**
164      * @return the address of the owner.
165      */
166     function owner() public view returns (address) {
167         return _owner;
168     }
169 
170     /**
171      * @dev Throws if called by any account other than the owner.
172      */
173     modifier onlyOwner() {
174         require(isOwner());
175         _;
176     }
177 
178     /**
179      * @return true if `msg.sender` is the owner of the contract.
180      */
181     function isOwner() public view returns (bool) {
182         return msg.sender == _owner;
183     }
184 
185     /**
186      * @dev Allows the current owner to relinquish control of the contract.
187      * It will not be possible to call the functions with the `onlyOwner`
188      * modifier anymore.
189      * @notice Renouncing ownership will leave the contract without an owner,
190      * thereby removing any functionality that is only available to the owner.
191      */
192     function renounceOwnership() public onlyOwner {
193         emit OwnershipTransferred(_owner, address(0));
194         _owner = address(0);
195     }
196 
197     /**
198      * @dev Allows the current owner to transfer control of the contract to a newOwner.
199      * @param newOwner The address to transfer ownership to.
200      */
201     function transferOwnership(address newOwner) public onlyOwner {
202         _transferOwnership(newOwner);
203     }
204 
205     /**
206      * @dev Transfers control of the contract to a newOwner.
207      * @param newOwner The address to transfer ownership to.
208      */
209     function _transferOwnership(address newOwner) internal {
210         require(newOwner != address(0));
211         emit OwnershipTransferred(_owner, newOwner);
212         _owner = newOwner;
213     }
214 }
215 
216 
217 /**
218  * @title ERC20 interface
219  * @dev see https://eips.ethereum.org/EIPS/eip-20
220  */
221 interface IERC20 {
222     function transfer(address to, uint256 value) external returns (bool);
223 
224     function approve(address spender, uint256 value) external returns (bool);
225 
226     function transferFrom(address from, address to, uint256 value) external returns (bool);
227 
228     function totalSupply() external view returns (uint256);
229 
230     function balanceOf(address who) external view returns (uint256);
231 
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 /**
240  * @title SafeMath
241  * @dev Unsigned math operations with safety checks that revert on error
242  */
243 library SafeMath {
244     /**
245      * @dev Multiplies two unsigned integers, reverts on overflow.
246      */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249         // benefit is lost if 'b' is also tested.
250         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b);
257 
258         return c;
259     }
260 
261     /**
262      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
263      */
264     function div(uint256 a, uint256 b) internal pure returns (uint256) {
265         // Solidity only automatically asserts when dividing by 0
266         require(b > 0);
267         uint256 c = a / b;
268         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269 
270         return c;
271     }
272 
273     /**
274      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
275      */
276     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
277         require(b <= a);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284      * @dev Adds two unsigned integers, reverts on overflow.
285      */
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         uint256 c = a + b;
288         require(c >= a);
289 
290         return c;
291     }
292 
293     /**
294      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
295      * reverts when dividing by zero.
296      */
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         require(b != 0);
299         return a % b;
300     }
301 }
302 
303 
304 /**
305  * @title Standard ERC20 token
306  *
307  * @dev Implementation of the basic standard token.
308  * https://eips.ethereum.org/EIPS/eip-20
309  * Originally based on code by FirstBlood:
310  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
311  *
312  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
313  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
314  * compliant implementations may not do it.
315  */
316 contract ERC20 is IERC20 {
317     using SafeMath for uint256;
318 
319     mapping (address => uint256) private _balances;
320 
321     mapping (address => mapping (address => uint256)) private _allowed;
322 
323     uint256 private _totalSupply;
324 
325     /**
326      * @dev Total number of tokens in existence
327      */
328     function totalSupply() public view returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev Gets the balance of the specified address.
334      * @param owner The address to query the balance of.
335      * @return A uint256 representing the amount owned by the passed address.
336      */
337     function balanceOf(address owner) public view returns (uint256) {
338         return _balances[owner];
339     }
340 
341     /**
342      * @dev Function to check the amount of tokens that an owner allowed to a spender.
343      * @param owner address The address which owns the funds.
344      * @param spender address The address which will spend the funds.
345      * @return A uint256 specifying the amount of tokens still available for the spender.
346      */
347     function allowance(address owner, address spender) public view returns (uint256) {
348         return _allowed[owner][spender];
349     }
350 
351     /**
352      * @dev Transfer token to a specified address
353      * @param to The address to transfer to.
354      * @param value The amount to be transferred.
355      */
356     function transfer(address to, uint256 value) public returns (bool) {
357         _transfer(msg.sender, to, value);
358         return true;
359     }
360 
361     /**
362      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
363      * Beware that changing an allowance with this method brings the risk that someone may use both the old
364      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
365      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
366      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
367      * @param spender The address which will spend the funds.
368      * @param value The amount of tokens to be spent.
369      */
370     function approve(address spender, uint256 value) public returns (bool) {
371         _approve(msg.sender, spender, value);
372         return true;
373     }
374 
375     /**
376      * @dev Transfer tokens from one address to another.
377      * Note that while this function emits an Approval event, this is not required as per the specification,
378      * and other compliant implementations may not emit the event.
379      * @param from address The address which you want to send tokens from
380      * @param to address The address which you want to transfer to
381      * @param value uint256 the amount of tokens to be transferred
382      */
383     function transferFrom(address from, address to, uint256 value) public returns (bool) {
384         _transfer(from, to, value);
385         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
386         return true;
387     }
388 
389     /**
390      * @dev Increase the amount of tokens that an owner allowed to a spender.
391      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
392      * allowed value is better to use this function to avoid 2 calls (and wait until
393      * the first transaction is mined)
394      * From MonolithDAO Token.sol
395      * Emits an Approval event.
396      * @param spender The address which will spend the funds.
397      * @param addedValue The amount of tokens to increase the allowance by.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
400         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
401         return true;
402     }
403 
404     /**
405      * @dev Decrease the amount of tokens that an owner allowed to a spender.
406      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
407      * allowed value is better to use this function to avoid 2 calls (and wait until
408      * the first transaction is mined)
409      * From MonolithDAO Token.sol
410      * Emits an Approval event.
411      * @param spender The address which will spend the funds.
412      * @param subtractedValue The amount of tokens to decrease the allowance by.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
415         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
416         return true;
417     }
418 
419     /**
420      * @dev Transfer token for a specified addresses
421      * @param from The address to transfer from.
422      * @param to The address to transfer to.
423      * @param value The amount to be transferred.
424      */
425     function _transfer(address from, address to, uint256 value) internal {
426         require(to != address(0));
427 
428         _balances[from] = _balances[from].sub(value);
429         _balances[to] = _balances[to].add(value);
430         emit Transfer(from, to, value);
431     }
432 
433     /**
434      * @dev Internal function that mints an amount of the token and assigns it to
435      * an account. This encapsulates the modification of balances such that the
436      * proper events are emitted.
437      * @param account The account that will receive the created tokens.
438      * @param value The amount that will be created.
439      */
440     function _mint(address account, uint256 value) internal {
441         require(account != address(0));
442 
443         _totalSupply = _totalSupply.add(value);
444         _balances[account] = _balances[account].add(value);
445         emit Transfer(address(0), account, value);
446     }
447 
448     /**
449      * @dev Internal function that burns an amount of the token of a given
450      * account.
451      * @param account The account whose tokens will be burnt.
452      * @param value The amount that will be burnt.
453      */
454     function _burn(address account, uint256 value) internal {
455         require(account != address(0));
456 
457         _totalSupply = _totalSupply.sub(value);
458         _balances[account] = _balances[account].sub(value);
459         emit Transfer(account, address(0), value);
460     }
461 
462     /**
463      * @dev Approve an address to spend another addresses' tokens.
464      * @param owner The address that owns the tokens.
465      * @param spender The address that will spend the tokens.
466      * @param value The number of tokens that can be spent.
467      */
468     function _approve(address owner, address spender, uint256 value) internal {
469         require(spender != address(0));
470         require(owner != address(0));
471 
472         _allowed[owner][spender] = value;
473         emit Approval(owner, spender, value);
474     }
475 
476     /**
477      * @dev Internal function that burns an amount of the token of a given
478      * account, deducting from the sender's allowance for said account. Uses the
479      * internal burn function.
480      * Emits an Approval event (reflecting the reduced allowance).
481      * @param account The account whose tokens will be burnt.
482      * @param value The amount that will be burnt.
483      */
484     function _burnFrom(address account, uint256 value) internal {
485         _burn(account, value);
486         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
487     }
488 }
489 
490 contract UpgradedStandardToken is ERC20 {
491     // those methods are called by the legacy contract
492     // and they must ensure msg.sender to be the contract address
493     uint public _totalSupply;
494     function transferByLegacy(address from, address to, uint value) public returns (bool);
495     function transferFromByLegacy(address sender, address from, address spender, uint value) public returns (bool);
496     function approveByLegacy(address from, address spender, uint value) public returns (bool);
497     function increaseApprovalByLegacy(address from, address spender, uint addedValue) public returns (bool);
498     function decreaseApprovalByLegacy(address from, address spender, uint subtractedValue) public returns (bool);
499 }
500 
501 contract BlackList is Ownable {
502     function getBlackListStatus(address _maker) external view returns (bool) {
503         return isBlackListed[_maker];
504     }
505 
506     mapping (address => bool) public isBlackListed;
507 
508     function addBlackList (address _evilUser) public onlyOwner {
509         isBlackListed[_evilUser] = true;
510         emit AddedBlackList(_evilUser);
511     }
512 
513     function removeBlackList (address _clearedUser) public onlyOwner {
514         isBlackListed[_clearedUser] = false;
515         emit RemovedBlackList(_clearedUser);
516     }
517 
518     event AddedBlackList(address indexed _user);
519 
520     event RemovedBlackList(address indexed _user);
521 
522 }
523 
524 contract StandardTokenWithFees is ERC20, Ownable {
525 
526   // Additional variables for use if transaction fees ever became necessary
527   uint256 public basisPointsRate = 0;
528   uint256 public maximumFee = 0;
529   uint256 constant MAX_SETTABLE_BASIS_POINTS = 20;
530   uint256 constant MAX_SETTABLE_FEE = 50;
531 
532   string public name;
533   string public symbol;
534   uint8 public decimals;
535 
536   uint public constant MAX_UINT = 2**256 - 1;
537 
538   function calcFee(uint _value) internal view returns (uint) {
539     uint fee = (_value.mul(basisPointsRate)).div(10000);
540     if (fee > maximumFee) {
541         fee = maximumFee;
542     }
543     return fee;
544   }
545 
546   function transfer(address _to, uint _value) public returns (bool) {
547     uint fee = calcFee(_value);
548     uint sendAmount = _value.sub(fee);
549 
550     super.transfer(_to, sendAmount);
551     if (fee > 0) {
552       super.transfer(owner(), fee);
553     }
554   }
555 
556   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
557     require(_to != address(0));
558     require(_value <= balanceOf(_from));
559     require(_value <= allowance(_from, msg.sender));
560 
561     uint fee = calcFee(_value);
562     uint sendAmount = _value.sub(fee);
563 
564     _transfer(_from, _to, sendAmount);
565     if (allowance(_from, msg.sender) < MAX_UINT) {
566         _approve(_from, msg.sender, allowance(_from, msg.sender).sub(_value));
567     }
568     if (fee > 0) {
569         _transfer(_from, owner(), fee);
570     }
571     return true;
572   }
573 
574   function setParams(uint newBasisPoints, uint newMaxFee) public onlyOwner {
575       // Ensure transparency by hardcoding limit beyond which fees can never be added
576       require(newBasisPoints < MAX_SETTABLE_BASIS_POINTS);
577       require(newMaxFee < MAX_SETTABLE_FEE);
578 
579       basisPointsRate = newBasisPoints;
580       maximumFee = newMaxFee.mul(uint(10)**decimals);
581 
582       emit Params(basisPointsRate, maximumFee);
583   }
584 
585   // Called if contract ever adds fees
586   event Params(uint feeBasisPoints, uint maxFee);
587 
588 }
589 
590 contract ATMToken is Pausable, StandardTokenWithFees, BlackList {
591 
592     address public upgradedAddress;
593     bool public deprecated;
594 
595     //  The contract can be initialized with a number of tokens
596     //  All the tokens are deposited to the owner address
597     //
598     // @param _balance Initial supply of the contract
599     // @param _name Token Name
600     // @param _symbol Token symbol
601     // @param _decimals Token decimals
602     constructor (uint _initialSupply, string memory _name, string memory _symbol, uint8 _decimals) public {
603         _mint(owner(), _initialSupply);
604         name = _name;
605         symbol = _symbol;
606         decimals = _decimals;
607         deprecated = false;
608         emit Issue(_initialSupply);
609     }
610 
611     // Forward ERC20 methods to upgraded contract if this one is deprecated
612     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
613         require(!isBlackListed[msg.sender]);
614         if (deprecated) {
615             return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
616         } else {
617             return super.transfer(_to, _value);
618         }
619     }
620 
621     // Forward ERC20 methods to upgraded contract if this one is deprecated
622     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
623         require(!isBlackListed[_from]);
624         if (deprecated) {
625             return UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
626         } else {
627             return super.transferFrom(_from, _to, _value);
628         }
629     }
630 
631     // Forward ERC20 methods to upgraded contract if this one is deprecated
632     function balanceOf(address who) public view returns (uint) {
633         if (deprecated) {
634             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
635         } else {
636             return super.balanceOf(who);
637         }
638     }
639 
640     // Allow checks of balance at time of deprecation
641     function oldBalanceOf(address who) public view returns (uint) {
642         if (deprecated) {
643             return super.balanceOf(who);
644         }
645     }
646 
647     // Forward ERC20 methods to upgraded contract if this one is deprecated
648     function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
649         if (deprecated) {
650             return UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
651         } else {
652             return super.approve(_spender, _value);
653         }
654     }
655 
656     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
657         if (deprecated) {
658             return UpgradedStandardToken(upgradedAddress).increaseApprovalByLegacy(msg.sender, _spender, _addedValue);
659         } else {
660             return super.increaseAllowance(_spender, _addedValue);
661         }
662     }
663 
664     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
665         if (deprecated) {
666             return UpgradedStandardToken(upgradedAddress).decreaseApprovalByLegacy(msg.sender, _spender, _subtractedValue);
667         } else {
668             return super.decreaseAllowance(_spender, _subtractedValue);
669         }
670     }
671 
672     // Forward ERC20 methods to upgraded contract if this one is deprecated
673     function allowance(address _owner, address _spender) public view returns (uint remaining) {
674         if (deprecated) {
675             return IERC20(upgradedAddress).allowance(_owner, _spender);
676         } else {
677             return super.allowance(_owner, _spender);
678         }
679     }
680 
681     // deprecate current contract in favour of a new one
682     function deprecate(address _upgradedAddress) public onlyOwner {
683         require(_upgradedAddress != address(0));
684         deprecated = true;
685         upgradedAddress = _upgradedAddress;
686         emit Deprecate(_upgradedAddress);
687     }
688 
689     // deprecate current contract if favour of a new one
690     function totalSupply() public view returns (uint) {
691         if (deprecated) {
692             return IERC20(upgradedAddress).totalSupply();
693         } else {
694             return super.totalSupply();
695         }
696     }
697 
698     // Issue a new amount of tokens
699     // these tokens are deposited into the owner address
700     //
701     // @param _amount Number of tokens to be issued
702     function issue(uint amount) public onlyOwner {
703         require(!deprecated);
704         _mint(owner(), amount);
705         emit Issue(amount);
706     }
707     
708     // Issue a new amount of tokens
709     // these tokens are deposited into the account address
710     //
711     // @param _account Address to be issued
712     // @param _amount Number of tokens to be issued
713     function issueToAccount(address account, uint amount) public onlyOwner {
714         require(!deprecated);
715         _mint(account, amount);
716         emit Issue(amount);
717     }
718 
719     // Redeem tokens.
720     // These tokens are withdrawn from the owner address
721     // if the balance must be enough to cover the redeem
722     // or the call will fail.
723     // @param _amount Number of tokens to be issued
724     function redeem(uint amount) public onlyOwner {
725         require(!deprecated);
726         _burn(owner(), amount);
727         emit Redeem(amount);
728     }
729 
730     function destroyBlackFunds (address _blackListedUser) public onlyOwner {
731         require(isBlackListed[_blackListedUser]);
732         uint dirtyFunds = balanceOf(_blackListedUser);
733         _burn(_blackListedUser, dirtyFunds);
734         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
735     }
736 
737     event DestroyedBlackFunds(address indexed _blackListedUser, uint _balance);
738 
739     // Called when new token are issued
740     event Issue(uint amount);
741 
742     // Called when tokens are redeemed
743     event Redeem(uint amount);
744 
745     // Called when contract is deprecated
746     event Deprecate(address newAddress);
747 
748 }