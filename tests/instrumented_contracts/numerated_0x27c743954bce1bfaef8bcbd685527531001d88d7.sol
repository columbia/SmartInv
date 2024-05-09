1 /* This code is provided at https://github.com/guylando/EthereumSmartContracts/blob/master/SafeUpgradeableTokenERC20/contracts/SafeUpgradeableTokenERC20.sol */
2 pragma solidity 0.5.8;
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://eips.ethereum.org/EIPS/eip-20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error.
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b, "SafeMath: multiplication overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0, "SafeMath: division by zero");
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a, "SafeMath: subtraction overflow");
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0, "SafeMath: modulo by zero");
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Roles
91  * @dev Library for managing addresses assigned to a Role.
92  */
93 library Roles {
94     struct Role {
95         mapping (address => bool) bearer;
96     }
97 
98     /**
99      * @dev Give an account access to this role.
100      */
101     function add(Role storage role, address account) internal {
102         require(!has(role, account), "Roles: account already has role");
103         require(account != address(this), "Roles: account is the contract address");
104         role.bearer[account] = true;
105     }
106 
107     /**
108      * @dev Remove an account's access to this role.
109      */
110     function remove(Role storage role, address account) internal {
111         require(has(role, account), "Roles: account does not have role");
112         require(account != address(this), "Roles: account is the contract address");
113         role.bearer[account] = false;
114     }
115 
116     /**
117      * @dev Check if an account has this role.
118      * @return bool
119      */
120     function has(Role storage role, address account) internal view returns (bool) {
121         require(account != address(0), "Roles: account is the zero address");
122         return role.bearer[account];
123     }
124 }
125 
126 /**
127  * Utility library of inline functions on addresses
128  */
129 library Address {
130     /**
131      * Returns whether the target address is a contract
132      * @dev This function will return false if invoked during the constructor of a contract,
133      * as the code is not actually created until after the constructor finishes.
134      * @param account address of the account to check
135      * @return whether the target address is a contract
136      */
137     function isContract(address account) internal view returns (bool) {
138         uint256 size;
139         // XXX Currently there is no better way to check if there is a contract in an address
140         // than to check the size of the code at that address.
141         // See https://ethereum.stackexchange.com/a/14016/36603
142         // for more details about how this works.
143         // TODO Check this again before the Serenity release, because all addresses will be
144         // contracts then.
145         // solhint-disable-next-line no-inline-assembly
146         assembly { size := extcodesize(account) }
147         return size > 0;
148     }
149 }
150 
151 /**
152  * @title SafeERC20
153  * @dev Wrappers around ERC20 operations that throw on failure (when the token
154  * contract returns false). Tokens that return no value (and instead revert or
155  * throw on failure) are also supported, non-reverting calls are assumed to be
156  * successful.
157  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
158  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
159  * Note Be careful when using SafeERC20 with non compliant token such as Golem token because SafeERC20 functions such as safeTransferFrom will give no indication that transferFrom is not implemented in the token, see: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1769
160  */
161 library SafeERC20 {
162     using SafeMath for uint256;
163     using Address for address;
164 
165     function safeTransfer(IERC20 token, address to, uint256 value) internal {
166         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
167     }
168 
169     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
170         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
171     }
172 
173     function safeApprove(IERC20 token, address spender, uint256 value) internal {
174         // safeApprove should only be called when setting an initial allowance,
175         // or when resetting it to zero. To increase and decrease it, use
176         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
177         // solhint-disable-next-line max-line-length
178         require((value == 0) || (token.allowance(address(this), spender) == 0),
179             "SafeERC20: approve from non-zero to non-zero allowance"
180         );
181         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
182     }
183 
184     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
185         uint256 newAllowance = token.allowance(address(this), spender).add(value);
186         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
187     }
188 
189     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
190         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
191         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
192     }
193 
194     /**
195      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
196      * on the return value: the return value is optional (but if data is returned, it must not be false).
197      * @param token The token targeted by the call.
198      * @param data The call data (encoded using abi.encode or one of its variants).
199      */
200     function callOptionalReturn(IERC20 token, bytes memory data) private {
201         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
202         // we're implementing it ourselves.
203 
204         // A Solidity high level call has three parts:
205         //  1. The target address is checked to verify it contains contract code
206         //  2. The call itself is made, and success asserted
207         //  3. The return value is decoded, which in turn checks the size of the returned data.
208         // solhint-disable-next-line max-line-length
209         require(address(token).isContract(), "SafeERC20: call to non-contract");
210 
211         // solhint-disable-next-line avoid-low-level-calls
212         (bool success, bytes memory returndata) = address(token).call(data);
213         require(success, "SafeERC20: low-level call failed");
214 
215         if (returndata.length > 0) { // Return data is optional
216             // solhint-disable-next-line max-line-length
217             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
218         }
219     }
220 }
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228     address internal _owner;
229 
230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
231 
232     /**
233      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234      * account.
235      */
236     constructor () internal {
237         _owner = msg.sender;
238         emit OwnershipTransferred(address(0), _owner);
239     }
240 
241     /**
242      * @return the address of the owner.
243      */
244     function owner() public view returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if called by any account other than the owner.
250      */
251     modifier onlyOwner() {
252         require(isOwner(), "Ownable: caller is not the owner");
253         _;
254     }
255 
256     /**
257      * @return true if `msg.sender` is the owner of the contract.
258      */
259     function isOwner() public view returns (bool) {
260         return msg.sender == _owner;
261     }
262 
263     /**
264      * @dev Allows the current owner to transfer control of the contract to a newOwner.
265      * @param newOwner The address to transfer ownership to.
266      */
267     function transferOwnership(address newOwner) public onlyOwner {
268         _transferOwnership(newOwner);
269     }
270 
271     /**
272      * @dev Transfers control of the contract to a newOwner.
273      * @param newOwner The address to transfer ownership to.
274      */
275     function _transferOwnership(address newOwner) internal {
276         require(newOwner != address(0), "Ownable: new owner is the zero address");
277         require(newOwner != address(this), "Ownable: new owner is the contract address");
278         emit OwnershipTransferred(_owner, newOwner);
279         _owner = newOwner;
280     }
281 }
282 
283 /**
284  * @title Standard ERC20 token
285  *
286  * @dev Implementation of the basic standard token.
287  * https://eips.ethereum.org/EIPS/eip-20
288  * Originally based on code by FirstBlood:
289  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
290  *
291  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
292  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
293  * compliant implementations may not do it.
294  */
295 contract ERC20 is IERC20 {
296     using SafeMath for uint256;
297 
298     mapping (address => uint256) private _balances;
299 
300     mapping (address => mapping (address => uint256)) private _allowances;
301 
302     uint256 private _totalSupply;
303     uint256 private constant MAX_UINT = 2**256 - 1;
304 
305     /**
306      * @dev Total number of tokens in existence.
307      */
308     function totalSupply() public view returns (uint256) {
309         return _totalSupply;
310     }
311 
312     /**
313      * @dev Gets the balance of the specified address.
314      * @param owner The address to query the balance of.
315      * @return A uint256 representing the amount owned by the passed address.
316      */
317     function balanceOf(address owner) public view returns (uint256) {
318         return _balances[owner];
319     }
320 
321     /**
322      * @dev Function to check the amount of tokens that an owner allowed to a spender.
323      * @param owner address The address which owns the funds.
324      * @param spender address The address which will spend the funds.
325      * @return A uint256 specifying the amount of tokens still available for the spender.
326      */
327     function allowance(address owner, address spender) public view returns (uint256) {
328         return _allowances[owner][spender];
329     }
330 
331     /**
332      * @dev Transfer token to a specified address.
333      * @param to The address to transfer to.
334      * @param value The amount to be transferred.
335      */
336     function transfer(address to, uint256 value) public returns (bool) {
337         _transfer(msg.sender, to, value);
338         return true;
339     }
340 
341     /**
342      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
343      * Beware that changing an allowance with this method brings the risk that someone may use both the old
344      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
345      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      * @param spender The address which will spend the funds.
348      * @param value The amount of tokens to be spent.
349      */
350     function approve(address spender, uint256 value) public returns (bool) {
351         // https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol#L225
352         // To change the approve amount you first have to reduce the addresses`
353         //  allowance to zero by calling `approve(_spender,0)` if it is not
354         //  already 0 to mitigate the race condition described here:
355         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356         // Note: this check is not compliant with ERC20 standard, see: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/438
357         require((value == 0) || (_allowances[msg.sender][spender] == 0),
358             "ERC20: must change allowance to 0 before changing to a different value");
359 
360         _approve(msg.sender, spender, value);
361         return true;
362     }
363 
364     /**
365      * @dev Transfer tokens from one address to another.
366      * Note that while this function emits an Approval event, this is not required as per the specification,
367      * and other compliant implementations may not emit the event.
368      * Note modified such that an allowance of MAX_UINT represents an unlimited amount https://github.com/ethereum/EIPs/issues/717.
369      * @param from address The address which you want to send tokens from
370      * @param to address The address which you want to transfer to
371      * @param value uint256 the amount of tokens to be transferred
372      */
373     function transferFrom(address from, address to, uint256 value) public returns (bool) {
374         _transfer(from, to, value);
375         uint256 currentAllowance = _allowances[from][msg.sender];
376         if (currentAllowance < MAX_UINT) {
377             _approve(from, msg.sender, currentAllowance.sub(value));
378         }
379         return true;
380     }
381 
382     /**
383      * @dev Increase the amount of tokens that an owner allowed to a spender.
384      * approve should be called when _allowances[msg.sender][spender] == 0. To increment
385      * allowed value is better to use this function to avoid 2 calls (and wait until
386      * the first transaction is mined)
387      * From MonolithDAO Token.sol
388      * Emits an Approval event.
389      * @param spender The address which will spend the funds.
390      * @param addedValue The amount of tokens to increase the allowance by.
391      */
392     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
393         require(addedValue > 0, "ERC20: addedValue value can't be 0");
394         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
395         return true;
396     }
397 
398     /**
399      * @dev Decrease the amount of tokens that an owner allowed to a spender.
400      * approve should be called when _allowances[msg.sender][spender] == 0. To decrement
401      * allowed value is better to use this function to avoid 2 calls (and wait until
402      * the first transaction is mined)
403      * From MonolithDAO Token.sol
404      * Emits an Approval event.
405      * Note If requested to decrease more than allowance then sets allowance to 0.
406      * @param spender The address which will spend the funds.
407      * @param subtractedValue The amount of tokens to decrease the allowance by.
408      */
409     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
410         require(subtractedValue > 0, "ERC20: decreaseAllowance value can't be 0");
411         require(_allowances[msg.sender][spender] > 0, "ERC20: current allowance must not be 0");
412         uint256 allowanceToSet;
413         if (subtractedValue < _allowances[msg.sender][spender]) {
414             allowanceToSet = _allowances[msg.sender][spender].sub(subtractedValue);
415         } else {
416             allowanceToSet = 0;
417         }
418         _approve(msg.sender, spender, allowanceToSet);
419         return true;
420     }
421 
422     /**
423      * @dev Transfer token for a specified addresses.
424      * @param from The address to transfer from.
425      * @param to The address to transfer to.
426      * @param value The amount to be transferred.
427      */
428     function _transfer(address from, address to, uint256 value) internal {
429         require(from != address(0), "ERC20: transfer from the zero address");
430         require(to != address(0), "ERC20: transfer to the zero address");
431         require(to != address(this), "ERC20: transfer to the contract address");
432 
433         _balances[from] = _balances[from].sub(value);
434         _balances[to] = _balances[to].add(value);
435         emit Transfer(from, to, value);
436     }
437 
438     /**
439      * @dev Internal function that mints an amount of the token and assigns it to
440      * an account. This encapsulates the modification of balances such that the
441      * proper events are emitted.
442      * @param account The account that will receive the created tokens.
443      * @param value The amount that will be created.
444      */
445     function _mint(address account, uint256 value) internal {
446         require(account != address(0), "ERC20: mint to the zero address");
447         require(account != address(this), "ERC20: mint to the contract address");
448         require(value != 0, "ERC20: mint value must be positive");
449 
450         _totalSupply = _totalSupply.add(value);
451         _balances[account] = _balances[account].add(value);
452         emit Transfer(address(0), account, value);
453     }
454 
455     /**
456      * @dev Internal function that burns an amount of the token of a given
457      * account.
458      * @param account The account whose tokens will be burnt.
459      * @param value The amount that will be burnt.
460      */
461     function _burn(address account, uint256 value) internal {
462         require(account != address(0), "ERC20: burn from the zero address");
463         require(account != address(this), "ERC20: burn from the contract address");
464 
465         _totalSupply = _totalSupply.sub(value);
466         _balances[account] = _balances[account].sub(value);
467         emit Transfer(account, address(0), value);
468     }
469 
470     /**
471      * @dev Approve an address to spend another addresses' tokens.
472      * @param owner The address that owns the tokens.
473      * @param spender The address that will spend the tokens.
474      * @param value The number of tokens that can be spent.
475      */
476     function _approve(address owner, address spender, uint256 value) internal {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = value;
481         emit Approval(owner, spender, value);
482     }
483 
484     /**
485      * @dev Internal function that burns an amount of the token of a given
486      * account, deducting from the sender's allowance for said account. Uses the
487      * internal burn function.
488      * Emits an Approval event (reflecting the reduced allowance).
489      * @param account The account whose tokens will be burnt.
490      * @param value The amount that will be burnt.
491      */
492     function _burnFrom(address account, uint256 value) internal {
493         _burn(account, value);
494         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
495     }
496 }
497 
498 contract PauserRole {
499     using SafeMath for uint256;
500     using Roles for Roles.Role;
501 
502     event PauserAdded(address indexed account);
503     event PauserRemoved(address indexed account);
504 
505     Roles.Role private _pausers;
506     uint256 internal _pausersCount;
507 
508     constructor () internal {
509         _addPauser(msg.sender);
510     }
511 
512     modifier onlyPauser() {
513         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
514         _;
515     }
516 
517     function isPauser(address account) public view returns (bool) {
518         return _pausers.has(account);
519     }
520 
521     function addPauser(address account) public onlyPauser {
522         _addPauser(account);
523     }
524 
525     function removePauser(address account) public onlyPauser {
526         _removePauser(account);
527     }
528 
529     function _addPauser(address account) internal {
530         _pausersCount = _pausersCount.add(1);
531         _pausers.add(account);
532         emit PauserAdded(account);
533     }
534 
535     function _removePauser(address account) internal {
536         require(_pausersCount > 1, "PauserRole: there should always be at least one pauser left");
537         _pausersCount = _pausersCount.sub(1);
538         _pausers.remove(account);
539         emit PauserRemoved(account);
540     }
541 }
542 
543 /**
544  * @title Pausable
545  * @dev Base contract which allows children to implement an emergency stop mechanism.
546  */
547 contract Pausable is PauserRole {
548     event Paused(address account);
549     event Unpaused(address account);
550 
551     bool private _paused;
552 
553     constructor () internal {
554         _paused = false;
555     }
556 
557     /**
558      * @return True if the contract is paused, false otherwise.
559      */
560     function paused() public view returns (bool) {
561         return _paused;
562     }
563 
564     /**
565      * @dev Modifier to make a function callable only when the contract is not paused.
566      */
567     modifier whenNotPaused() {
568         require(!_paused, "Pausable: paused");
569         _;
570     }
571 
572     /**
573      * @dev Modifier to make a function callable only when the contract is paused.
574      */
575     modifier whenPaused() {
576         require(_paused, "Pausable: not paused");
577         _;
578     }
579 
580     /**
581      * @dev Called by a pauser to pause, triggers stopped state.
582      */
583     function pause() public onlyPauser whenNotPaused {
584         _paused = true;
585         emit Paused(msg.sender);
586     }
587 
588     /**
589      * @dev Called by a pauser to unpause, returns to normal state.
590      */
591     function unpause() public onlyPauser whenPaused {
592         _paused = false;
593         emit Unpaused(msg.sender);
594     }
595 }
596 
597 /**
598  * @title Pausable token
599  * @dev ERC20 modified with pausable transfers.
600  */
601 contract ERC20Pausable is ERC20, Pausable {
602     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
603         return super.transfer(to, value);
604     }
605 
606     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
607         return super.transferFrom(from, to, value);
608     }
609 
610     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
611         return super.approve(spender, value);
612     }
613 
614     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
615         return super.increaseAllowance(spender, addedValue);
616     }
617 
618     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
619         return super.decreaseAllowance(spender, subtractedValue);
620     }
621 }
622 
623 /**
624  * @title ERC20Detailed token
625  * @dev The decimals are only for visualization purposes.
626  * All the operations are done using the smallest and indivisible token unit,
627  * just as on Ethereum all the operations are done in wei.
628  */
629 contract ERC20Detailed is IERC20 {
630     string private _name;
631     string private _symbol;
632     uint8 private _decimals;
633 
634     constructor (string memory name, string memory symbol, uint8 decimals) public {
635         _name = name;
636         _symbol = symbol;
637         _decimals = decimals;
638     }
639 
640     /**
641      * @return the name of the token.
642      */
643     function name() public view returns (string memory) {
644         return _name;
645     }
646 
647     /**
648      * @return the symbol of the token.
649      */
650     function symbol() public view returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @return the number of decimals of the token.
656      */
657     function decimals() public view returns (uint8) {
658         return _decimals;
659     }
660 }
661 
662 /**
663  * Upgrade agent interface inspired by Lunyr.
664  *
665  * Upgrade agent transfers tokens to a new contract.
666  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
667  */
668 contract UpgradeAgent {
669     /** Interface marker */
670     function isUpgradeAgent() external pure returns (bool) {
671         return true;
672     }
673 
674     function upgradeFrom(address _from, uint256 _value) external;
675 }
676 
677 /**
678  * @title SafeUpgradeableTokenERC20
679  * @dev The deployed contract of the token itself.
680  * Upgrade mechanism code review: https://github.com/bokkypoobah/InvestFeedCrowdsaleAudit/blob/master/codereview/UpgradeableToken.md
681  */
682 contract SafeUpgradeableTokenERC20 is ERC20Pausable, ERC20Detailed, Ownable, UpgradeAgent {
683     using SafeMath for uint256;
684 
685     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
686     address public upgradeMaster;
687 
688     /** The next contract where the tokens will be migrated. */
689     UpgradeAgent public upgradeAgent;
690 
691     /** How many tokens we have upgraded by now. */
692     uint256 public totalUpgraded;
693 
694     /** Previous token address in case this is an upgraded contract.
695      * Note Keeping it public so that everybody can easily get it and verify that the address here is not the current contract address and that it points to the correct contract.
696      */
697     address public previousToken;
698 
699     /**
700     * New contract version.
701     */
702     string public version = "1.0";
703 
704     /**
705     * Upgrade states.
706     *
707     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
708     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
709     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
710     * - UpgradeFinished: All contract tokens were upgraded (might never happen if some tokens belong to invalid addresses so dont wait for this status)
711     *
712     */
713     enum UpgradeState {WaitingForAgent, ReadyToUpgrade, Upgrading, UpgradeFinished}
714 
715     /**
716     * Somebody has upgraded some of his tokens.
717     */
718     event LogUpgrade(address indexed from, address indexed to, uint256 value);
719 
720     /**
721     * New upgrade agent available.
722     */
723     event LogUpgradeAgentSet(address indexed agent);
724 
725     constructor (address _previousToken, string memory _name, string memory _symbol, uint8 _decimals, uint256 _supply)
726         public
727         ERC20Detailed(_name, _symbol, _decimals)
728     {
729         upgradeMaster = msg.sender;
730         previousToken = _previousToken;
731         /* An upgraded token will be created with total supply of 0 in which case dont call mint */
732         if (_supply > 0) {
733             _mint(msg.sender, _supply);
734         }
735     }
736 
737     /**
738      * @dev Throws if called by any account other than the upgrade master.
739      */
740     modifier onlyUpgradeMaster() {
741         require(msg.sender == upgradeMaster, "caller must be upgradeMaster");
742         _;
743     }
744 
745     /**
746      * @dev Throws if called with an invalid address.
747      */
748     modifier validateAddress(address input) {
749         require(input != address(0), "invalid address, shouldnt be 0");
750         require(input != address(this), "invalid address, shouldnt be current contract address");
751         _;
752     }
753 
754     /**
755     * Allow the token holder to upgrade some of their tokens to a new contract.
756     */
757     function upgrade(uint256 value) external {
758         UpgradeState state = getUpgradeState();
759         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading, "upgrade state does not allow upgrade");
760         require(value != 0, "value must be non-zero");
761 
762         // Take tokens out from circulation
763         _burn(msg.sender, value);
764         totalUpgraded = totalUpgraded.add(value);
765         emit LogUpgrade(msg.sender, address(upgradeAgent), value);
766 
767         // Upgrade agent reissues the tokens
768         upgradeAgent.upgradeFrom(msg.sender, value);
769     }
770     /**
771     * Allow to upgrade from previous token if previous token was configured.
772     */
773     function upgradeFrom(address _from, uint256 _value) external validateAddress(_from) {
774         require(previousToken != address(0), "previousToken was not set");
775         require(msg.sender == previousToken, "upgradeFrom should only be called by previousToken");
776         _mint(_from, _value);
777     }
778 
779     /**
780     * Set an upgrade agent that handles
781     */
782     function setUpgradeAgent(UpgradeAgent newUpgradeAgent) external onlyUpgradeMaster validateAddress(address(newUpgradeAgent)) {
783         require(getUpgradeState() != UpgradeState.Upgrading, "upgrade already started");
784 
785         upgradeAgent = newUpgradeAgent;
786         emit LogUpgradeAgentSet(address(newUpgradeAgent));
787 
788         // Calling non-existent function will revert inside the call without this require error message
789         require(newUpgradeAgent.isUpgradeAgent(), "Bad interface");
790     }
791 
792     /**
793     * @dev Get the state of the token upgrade.
794     */
795     function getUpgradeState() public view returns(UpgradeState) {
796         if (address(upgradeAgent) == address(0)) {
797             return UpgradeState.WaitingForAgent;
798         } else if (totalUpgraded == 0) {
799             return UpgradeState.ReadyToUpgrade;
800         } else if (totalUpgraded < totalSupply()) {
801             return UpgradeState.Upgrading;
802         } else {
803             return UpgradeState.UpgradeFinished;
804         }
805     }
806 
807     /**
808     * @dev Change the upgrade master. This allows us to set a new owner for the upgrade mechanism.
809     * @param master The address of the new upgrade master
810     */
811     function setUpgradeMaster(address master) external onlyUpgradeMaster validateAddress(master) {
812         upgradeMaster = master;
813     }
814 
815     /**
816     * @dev Recover tokens transferred to this contract.
817     * Note Used to be inside open-zeppelin CanReclaimToken contract.
818     * Note Be careful to not pass too much gas when using this function because it uses SafeERC20 which can cause gas drain, see: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1767
819     * Note If the received contract implements balanceOf but does not implement transfer and has a non-reverting fallback function then no tokens will be transfered without any indication of failure, see: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1769
820     * @param _token The address of the token contract
821     */
822     function recoverToken(IERC20 _token) external onlyOwner {
823         uint256 balance = _token.balanceOf(address(this));
824         require(balance > 0, "no tokens to recover for received token type");
825         SafeERC20.safeTransfer(_token, _owner, balance);
826     }
827 
828     /**
829     * @dev Reclaim ownership of Ownable contracts
830     * Note If the received contract does not implement transferOwnership function and has a non-reverting fallback function then no ownership will be transfered without any indication of failure.
831     * @param contractInst The instance of the Ownable to be reclaimed.
832     */
833     function reclaimContract(Ownable contractInst) external onlyOwner {
834         contractInst.transferOwnership(_owner);
835     }
836 
837     /**
838     * @dev Reject all ERC223 compatible tokens
839     * Note Used to be inside open-zeppelin HasNoTokens contract.
840     * @param from address The address that is transferring the tokens
841     * @param value uint256 the amount of the specified token
842     * @param data Bytes The data passed from the caller.
843     */
844     function tokenFallback(address from, uint256 value, bytes calldata data) external pure {
845         /* Use variables to remove warnings https://github.com/OpenZeppelin/openzeppelin-solidity/commit/b50391862c42857e3ff2388598e52ebab92fc9fa#diff-24aa1138eec9d5dd65b1a8a898e04dd2 */
846         from;
847         value;
848         data;
849         revert("this contract does not support receiving ERC223 tokens");
850     }
851 
852     /**
853     * @dev It is possible that funds were sent to this address before the contract was deployed.
854     * It is also possible that funds are sent here by mistake using selfdestruct.
855     * This function prevents those funds being locked.
856     */
857     function recoverEther() external onlyOwner {
858         require(address(this).balance > 0, "no ether to recover");
859         address(uint160(_owner)).transfer(address(this).balance);
860     }
861 }