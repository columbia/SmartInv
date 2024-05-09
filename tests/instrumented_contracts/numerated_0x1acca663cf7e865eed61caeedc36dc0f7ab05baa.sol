1 // solium-disable linebreak-style
2 pragma solidity ^0.5.2;
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
25 
26 /**
27  * @title ERC20Detailed token
28  * @dev The decimals are only for visualization purposes.
29  * All the operations are done using the smallest and indivisible token unit,
30  * just as on Ethereum all the operations are done in wei.
31  */
32 contract ERC20Detailed is IERC20 {
33     string private _name;
34     string private _symbol;
35     uint8 private _decimals;
36 
37     constructor (string memory name, string memory symbol, uint8 decimals) public {
38         _name = name;
39         _symbol = symbol;
40         _decimals = decimals;
41     }
42 
43     /**
44      * @return the name of the token.
45      */
46     function name() public view returns (string memory) {
47         return _name;
48     }
49 
50     /**
51      * @return the symbol of the token.
52      */
53     function symbol() public view returns (string memory) {
54         return _symbol;
55     }
56 
57     /**
58      * @return the number of decimals of the token.
59      */
60     function decimals() public view returns (uint8) {
61         return _decimals;
62     }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Unsigned math operations with safety checks that revert on error
68  */
69 library SafeMath {
70     /**
71      * @dev Multiplies two unsigned integers, reverts on overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b);
83 
84         return c;
85     }
86 
87     /**
88      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0);
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95 
96         return c;
97     }
98 
99     /**
100      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b <= a);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110      * @dev Adds two unsigned integers, reverts on overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a);
115 
116         return c;
117     }
118 
119     /**
120      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
121      * reverts when dividing by zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b != 0);
125         return a % b;
126     }
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * https://eips.ethereum.org/EIPS/eip-20
134  * Originally based on code by FirstBlood:
135  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  *
137  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
138  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
139  * compliant implementations may not do it.
140  */
141 contract ERC20 is IERC20 {
142     using SafeMath for uint256;
143 
144     mapping (address => uint256) private _balances;
145 
146     mapping (address => mapping (address => uint256)) private _allowed;
147 
148     uint256 private _totalSupply;
149 
150     /**
151      * @dev Total number of tokens in existence
152      */
153     function totalSupply() public view returns (uint256) {
154         return _totalSupply;
155     }
156 
157     /**
158      * @dev Gets the balance of the specified address.
159      * @param owner The address to query the balance of.
160      * @return A uint256 representing the amount owned by the passed address.
161      */
162     function balanceOf(address owner) public view returns (uint256) {
163         return _balances[owner];
164     }
165 
166     /**
167      * @dev Function to check the amount of tokens that an owner allowed to a spender.
168      * @param owner address The address which owns the funds.
169      * @param spender address The address which will spend the funds.
170      * @return A uint256 specifying the amount of tokens still available for the spender.
171      */
172     function allowance(address owner, address spender) public view returns (uint256) {
173         return _allowed[owner][spender];
174     }
175 
176     /**
177      * @dev Transfer token to a specified address
178      * @param to The address to transfer to.
179      * @param value The amount to be transferred.
180      */
181     function transfer(address to, uint256 value) public returns (bool) {
182         _transfer(msg.sender, to, value);
183         return true;
184     }
185 
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      * Beware that changing an allowance with this method brings the risk that someone may use both the old
189      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      * @param spender The address which will spend the funds.
193      * @param value The amount of tokens to be spent.
194      */
195     function approve(address spender, uint256 value) public returns (bool) {
196         _approve(msg.sender, spender, value);
197         return true;
198     }
199 
200     /**
201      * @dev Transfer tokens from one address to another.
202      * Note that while this function emits an Approval event, this is not required as per the specification,
203      * and other compliant implementations may not emit the event.
204      * @param from address The address which you want to send tokens from
205      * @param to address The address which you want to transfer to
206      * @param value uint256 the amount of tokens to be transferred
207      */
208     function transferFrom(address from, address to, uint256 value) public returns (bool) {
209         _transfer(from, to, value);
210         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
211         return true;
212     }
213 
214     /**
215      * @dev Increase the amount of tokens that an owner allowed to a spender.
216      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * Emits an Approval event.
221      * @param spender The address which will spend the funds.
222      * @param addedValue The amount of tokens to increase the allowance by.
223      */
224     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
225         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
226         return true;
227     }
228 
229     /**
230      * @dev Decrease the amount of tokens that an owner allowed to a spender.
231      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * Emits an Approval event.
236      * @param spender The address which will spend the funds.
237      * @param subtractedValue The amount of tokens to decrease the allowance by.
238      */
239     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
240         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
241         return true;
242     }
243 
244     /**
245      * @dev Transfer token for a specified addresses
246      * @param from The address to transfer from.
247      * @param to The address to transfer to.
248      * @param value The amount to be transferred.
249      */
250     function _transfer(address from, address to, uint256 value) internal {
251         require(to != address(0));
252 
253         _balances[from] = _balances[from].sub(value);
254         _balances[to] = _balances[to].add(value);
255         emit Transfer(from, to, value);
256     }
257 
258     /**
259      * @dev Internal function that mints an amount of the token and assigns it to
260      * an account. This encapsulates the modification of balances such that the
261      * proper events are emitted.
262      * @param account The account that will receive the created tokens.
263      * @param value The amount that will be created.
264      */
265     function _mint(address account, uint256 value) internal {
266         require(account != address(0));
267 
268         _totalSupply = _totalSupply.add(value);
269         _balances[account] = _balances[account].add(value);
270         emit Transfer(address(0), account, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account.
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burn(address account, uint256 value) internal {
280         require(account != address(0));
281 
282         _totalSupply = _totalSupply.sub(value);
283         _balances[account] = _balances[account].sub(value);
284         emit Transfer(account, address(0), value);
285     }
286 
287     /**
288      * @dev Approve an address to spend another addresses' tokens.
289      * @param owner The address that owns the tokens.
290      * @param spender The address that will spend the tokens.
291      * @param value The number of tokens that can be spent.
292      */
293     function _approve(address owner, address spender, uint256 value) internal {
294         require(spender != address(0));
295         require(owner != address(0));
296 
297         _allowed[owner][spender] = value;
298         emit Approval(owner, spender, value);
299     }
300 
301     /**
302      * @dev Internal function that burns an amount of the token of a given
303      * account, deducting from the sender's allowance for said account. Uses the
304      * internal burn function.
305      * Emits an Approval event (reflecting the reduced allowance).
306      * @param account The account whose tokens will be burnt.
307      * @param value The amount that will be burnt.
308      */
309     function _burnFrom(address account, uint256 value) internal {
310         _burn(account, value);
311         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
312     }
313 }
314 
315 /**
316  * @title Roles
317  * @dev Library for managing addresses assigned to a Role.
318  */
319 library Roles {
320     struct Role {
321         mapping (address => bool) bearer;
322     }
323 
324     /**
325      * @dev give an account access to this role
326      */
327     function add(Role storage role, address account) internal {
328         require(account != address(0));
329         require(!has(role, account));
330 
331         role.bearer[account] = true;
332     }
333 
334     /**
335      * @dev remove an account's access to this role
336      */
337     function remove(Role storage role, address account) internal {
338         require(account != address(0));
339         require(has(role, account));
340 
341         role.bearer[account] = false;
342     }
343 
344     /**
345      * @dev check if an account has this role
346      * @return bool
347      */
348     function has(Role storage role, address account) internal view returns (bool) {
349         require(account != address(0));
350         return role.bearer[account];
351     }
352 }
353 
354 contract MinterRole {
355     using Roles for Roles.Role;
356 
357     event MinterAdded(address indexed account);
358     event MinterRemoved(address indexed account);
359 
360     Roles.Role private _minters;
361 
362     constructor () internal {
363         _addMinter(msg.sender);
364     }
365 
366     modifier onlyMinter() {
367         require(isMinter(msg.sender));
368         _;
369     }
370 
371     function isMinter(address account) public view returns (bool) {
372         return _minters.has(account);
373     }
374 
375     function addMinter(address account) public onlyMinter {
376         _addMinter(account);
377     }
378 
379     function renounceMinter() public {
380         _removeMinter(msg.sender);
381     }
382 
383     function _addMinter(address account) internal {
384         _minters.add(account);
385         emit MinterAdded(account);
386     }
387 
388     function _removeMinter(address account) internal {
389         _minters.remove(account);
390         emit MinterRemoved(account);
391     }
392 }
393 
394 /**
395  * @title ERC20Mintable
396  * @dev ERC20 minting logic
397  */
398 contract ERC20Mintable is ERC20, MinterRole {
399     /**
400      * @dev Function to mint tokens
401      * @param to The address that will receive the minted tokens.
402      * @param value The amount of tokens to mint.
403      * @return A boolean that indicates if the operation was successful.
404      */
405     function mint(address to, uint256 value) public onlyMinter returns (bool) {
406         _mint(to, value);
407         return true;
408     }
409 }
410 
411 contract PauserRole {
412     using Roles for Roles.Role;
413 
414     event PauserAdded(address indexed account);
415     event PauserRemoved(address indexed account);
416 
417     Roles.Role private _pausers;
418 
419     constructor () internal {
420         _addPauser(msg.sender);
421     }
422 
423     modifier onlyPauser() {
424         require(isPauser(msg.sender));
425         _;
426     }
427 
428     function isPauser(address account) public view returns (bool) {
429         return _pausers.has(account);
430     }
431 
432     function addPauser(address account) public onlyPauser {
433         _addPauser(account);
434     }
435 
436     function renouncePauser() public {
437         _removePauser(msg.sender);
438     }
439 
440     function _addPauser(address account) internal {
441         _pausers.add(account);
442         emit PauserAdded(account);
443     }
444 
445     function _removePauser(address account) internal {
446         _pausers.remove(account);
447         emit PauserRemoved(account);
448     }
449 }
450 
451 /**
452  * @title Pausable
453  * @dev Base contract which allows children to implement an emergency stop mechanism.
454  */
455 contract Pausable is PauserRole {
456     event Paused(address account);
457     event Unpaused(address account);
458 
459     bool private _paused;
460 
461     constructor () internal {
462         _paused = false;
463     }
464 
465     /**
466      * @return true if the contract is paused, false otherwise.
467      */
468     function paused() public view returns (bool) {
469         return _paused;
470     }
471 
472     /**
473      * @dev Modifier to make a function callable only when the contract is not paused.
474      */
475     modifier whenNotPaused() {
476         require(!_paused);
477         _;
478     }
479 
480     /**
481      * @dev Modifier to make a function callable only when the contract is paused.
482      */
483     modifier whenPaused() {
484         require(_paused);
485         _;
486     }
487 
488     /**
489      * @dev called by the owner to pause, triggers stopped state
490      */
491     function pause() public onlyPauser whenNotPaused {
492         _paused = true;
493         emit Paused(msg.sender);
494     }
495 
496     /**
497      * @dev called by the owner to unpause, returns to normal state
498      */
499     function unpause() public onlyPauser whenPaused {
500         _paused = false;
501         emit Unpaused(msg.sender);
502     }
503 }
504 
505 /**
506  * @title Pausable token
507  * @dev ERC20 modified with pausable transfers.
508  */
509 contract ERC20Pausable is ERC20, Pausable {
510     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
511         return super.transfer(to, value);
512     }
513 
514     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
515         return super.transferFrom(from, to, value);
516     }
517 
518     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
519         return super.approve(spender, value);
520     }
521 
522     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
523         return super.increaseAllowance(spender, addedValue);
524     }
525 
526     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
527         return super.decreaseAllowance(spender, subtractedValue);
528     }
529 }
530 
531 /**
532  * @title Ownable
533  * @dev The Ownable contract has an owner address, and provides basic authorization control
534  * functions, this simplifies the implementation of "user permissions".
535  */
536 contract Ownable {
537     address private _owner;
538 
539     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
540 
541     /**
542      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
543      * account.
544      */
545     constructor () internal {
546         _owner = msg.sender;
547         emit OwnershipTransferred(address(0), _owner);
548     }
549 
550     /**
551      * @return the address of the owner.
552      */
553     function owner() public view returns (address) {
554         return _owner;
555     }
556 
557     /**
558      * @dev Throws if called by any account other than the owner.
559      */
560     modifier onlyOwner() {
561         require(isOwner());
562         _;
563     }
564 
565     /**
566      * @return true if `msg.sender` is the owner of the contract.
567      */
568     function isOwner() public view returns (bool) {
569         return msg.sender == _owner;
570     }
571 
572     /**
573      * @dev Allows the current owner to relinquish control of the contract.
574      * It will not be possible to call the functions with the `onlyOwner`
575      * modifier anymore.
576      * @notice Renouncing ownership will leave the contract without an owner,
577      * thereby removing any functionality that is only available to the owner.
578      */
579     function renounceOwnership() public onlyOwner {
580         emit OwnershipTransferred(_owner, address(0));
581         _owner = address(0);
582     }
583 
584     /**
585      * @dev Allows the current owner to transfer control of the contract to a newOwner.
586      * @param newOwner The address to transfer ownership to.
587      */
588     function transferOwnership(address newOwner) public onlyOwner {
589         _transferOwnership(newOwner);
590     }
591 
592     /**
593      * @dev Transfers control of the contract to a newOwner.
594      * @param newOwner The address to transfer ownership to.
595      */
596     function _transferOwnership(address newOwner) internal {
597         require(newOwner != address(0));
598         emit OwnershipTransferred(_owner, newOwner);
599         _owner = newOwner;
600     }
601 }
602 
603 // NOTE replaced Mint -> Destroy, mint -> destroy
604 
605 contract DestroyerRole {
606     using Roles for Roles.Role;
607 
608     event DestroyerAdded(address indexed account);
609     event DestroyerRemoved(address indexed account);
610 
611     Roles.Role private destroyers;
612 
613     constructor() internal {
614         _addDestroyer(msg.sender);
615     }
616 
617     modifier onlyDestroyer() {
618         require(isDestroyer(msg.sender));
619         _;
620     }
621 
622     function isDestroyer(address account) public view returns (bool) {
623         return destroyers.has(account);
624     }
625 
626     function addDestroyer(address account) public onlyDestroyer {
627         _addDestroyer(account);
628     }
629 
630     function renounceDestroyer() public {
631         _removeDestroyer(msg.sender);
632     }
633 
634     function _addDestroyer(address account) internal {
635         destroyers.add(account);
636         emit DestroyerAdded(account);
637     }
638 
639     function _removeDestroyer(address account) internal {
640         destroyers.remove(account);
641         emit DestroyerRemoved(account);
642     }
643 }
644 
645 /**
646  * @title ERC20Destroyable
647  * @dev ERC20 destroying logic
648  */
649 contract ERC20Destroyable is ERC20, DestroyerRole {
650     /**
651      * @dev Function to mint tokens
652      * @param from The address that will have the tokens destroyed.
653      * @param value The amount of tokens to destroy.
654      * @return A boolean that indicates if the operation was successful.
655      */
656     function destroy(address from, uint256 value) public onlyDestroyer returns (bool) {
657         _burn(from, value);
658         return true;
659     }
660 }
661 
662 contract PrzToken is ERC20Detailed, ERC20Mintable, ERC20Destroyable, ERC20Pausable, Ownable {
663 
664     // Stores the address of the entry credit contract
665     address private _entryCreditContract;
666 
667     // Stores the address of contract with burned tokens (basis for BME minting)
668     address private _balanceSheetContract;
669 
670     // Stores the amount of addresses to mint for
671     uint256 private _bmeClaimBatchSize;
672     uint256 private _bmeMintBatchSize;
673 
674     // Stores phase state (default value for bool is false,
675     // https://solidity.readthedocs.io/en/v0.5.3/control-structures.html#default-value)
676     // Contract will be initialized in "initPhase", i.e. not in bmePhase
677     bool private _isInBmePhase;
678 
679     modifier whenNotInBME() {
680         require(!_isInBmePhase, "Function may no longer be called once BME starts");
681         _;
682     }
683 
684     modifier whenInBME() {
685         require(_isInBmePhase, "Function may only be called once BME starts");
686         _;
687     }
688 
689     event EntryCreditContractChanged(
690         address indexed previousEntryCreditContract,
691         address indexed newEntryCreditContract
692     );
693 
694     event BalanceSheetContractChanged(
695         address indexed previousBalanceSheetContract,
696         address indexed newBalanceSheetContract
697     );
698 
699     event BmeMintBatchSizeChanged(
700         uint256 indexed previousSize,
701         uint256 indexed newSize
702     );
703 
704     event BmeClaimBatchSizeChanged(
705         uint256 indexed previousSize,
706         uint256 indexed newSize
707     );
708 
709     event PhaseChangedToBME(address account);
710 
711 
712     /**
713      * @dev Constructor that initializes the PRZToken contract.
714      */
715     constructor (string memory name, string memory symbol, uint8 decimals)
716         ERC20Detailed(name, symbol, decimals)
717         ERC20Mintable()
718         ERC20Destroyable()
719         ERC20Pausable()
720         Ownable()
721         public
722     {
723         _isInBmePhase = false;
724         pause();
725         setEntryCreditContract(address(0));
726         setBalanceSheetContract(address(0));
727         setBmeMintBatchSize(200);
728         setBmeClaimBatchSize(200);
729     }
730 
731     // Returns _entryCreditContract
732     function entryCreditContract() public view returns (address) {
733         return _entryCreditContract;
734     }
735 
736     // Set _entryCreditContract
737     function setEntryCreditContract(address contractAddress) public onlyOwner {
738         emit EntryCreditContractChanged(_entryCreditContract, contractAddress);
739         _entryCreditContract = contractAddress;
740     }
741 
742     // Returns _balanceSheetContract
743     function balanceSheetContract() public view returns (address) {
744         return _balanceSheetContract;
745     }
746 
747     // Set _balanceSheetContract
748     function setBalanceSheetContract(address contractAddress) public onlyOwner {
749         emit BalanceSheetContractChanged(_balanceSheetContract, contractAddress);
750         _balanceSheetContract = contractAddress;
751     }
752 
753     // Returns _bmeMintBatchSize
754     function bmeMintBatchSize() public view returns (uint256) {
755         return _bmeMintBatchSize;
756     }
757 
758     // Set _bmeMintBatchSize
759     function setBmeMintBatchSize(uint256 batchSize) public onlyMinter {
760         emit BmeMintBatchSizeChanged(_bmeMintBatchSize, batchSize);
761         _bmeMintBatchSize = batchSize;
762     }
763 
764     // Returns _bmeClaimBatchSize
765     function bmeClaimBatchSize() public view returns (uint256) {
766         return _bmeClaimBatchSize;
767     }
768 
769     // Set _bmeClaimBatchSize
770     function setBmeClaimBatchSize(uint256 batchSize) public onlyMinter {
771         emit BmeClaimBatchSizeChanged(_bmeClaimBatchSize, batchSize);
772         _bmeClaimBatchSize = batchSize;
773     }
774 
775     // Overwrites ERC20._transfer.
776     // If to = _entryCreditContract, sends tokens to the credit contract according to the
777     // exchange rate in credit contract, destroys tokens locally
778     function _transfer(address from, address to, uint256 value) internal {
779 
780         if (to == _entryCreditContract) {
781 
782             _burn(from, value);
783             IEntryCreditContract entryCreditContractInstance = IEntryCreditContract(to);
784             require(entryCreditContractInstance.mint(from, value), "Failed to mint entry credits");
785 
786             IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
787             require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");
788 
789         } else {
790 
791             super._transfer(from, to, value);
792         }
793     }
794 
795     // Call ERC20._burn(from, value)
796     function destroy(address from, uint256 value)
797         public whenPaused whenNotInBME
798         returns (bool)
799     {
800         return super.destroy(from, value);
801     }
802 
803     // Run destroy for all entries
804     function batchDestroy(address[] calldata from, uint256[] calldata values)
805         external onlyDestroyer whenPaused whenNotInBME
806         returns (bool)
807     {
808         uint fromLength = from.length;
809 
810         require(fromLength == values.length, "Input arrays must have the same length");
811 
812         for (uint256 i = 0; i < fromLength; i++) {
813             _burn(from[i], values[i]);
814         }
815 
816         return true;
817     }
818 
819     // Call ERC20._mint(to, value)
820     function mint(address to, uint256 value)
821         public whenPaused whenNotInBME
822         returns (bool)
823     {
824         return super.mint(to, value);
825     }
826 
827     // Run mint for all entries
828     function batchMint(address[] calldata to, uint256[] calldata values)
829         external onlyMinter whenPaused whenNotInBME
830         returns (bool)
831     {
832         _batchMint(to, values);
833 
834         return true;
835     }
836 
837     // Uses the balance sheet in _balanceSheetContract as a basis for
838     // batchMint call for _bmeMintBatchSize addresses
839     function bmeMint()
840         public onlyMinter whenInBME whenNotPaused
841     {
842         IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
843         (address[] memory receivers, uint256[] memory amounts) = balanceSheetContractInstance.popMintingInformation(_bmeMintBatchSize);
844 
845         _batchMint(receivers, amounts);
846 
847         require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");
848     }
849 
850     // Uses the balance sheet in _balanceSheetContract to create
851     // tokens for all addresses in for, limits to _bmeMintBatchSize, emit Transfer
852     function _claimFor(address[] memory claimers)
853         private
854     {
855         IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
856         uint256[] memory amounts = balanceSheetContractInstance.popClaimingInformation(claimers);
857 
858         _batchMint(claimers, amounts);
859 
860         require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");
861     }
862 
863     function _batchMint(address[] memory to, uint256[] memory values)
864         private
865     {
866 
867         // length should not be computed at each iteration
868         uint toLength = to.length;
869 
870         require(toLength == values.length, "Input arrays must have the same length");
871 
872         for (uint256 i = 0; i < toLength; i++) {
873             _mint(to[i], values[i]);
874         }
875     }
876 
877     // Calls _claimFor with for = msg.sender
878     function claim()
879         public whenInBME whenNotPaused
880     {
881         address[] memory claimers = new address[](1);
882         claimers[0] = msg.sender;
883         _claimFor(claimers);
884     }
885 
886     // Calls _claimFor with for as provided
887     function claimFor(address[] calldata claimers)
888         external whenInBME whenNotPaused
889     {
890         require(claimers.length <= _bmeClaimBatchSize, "Input array must be shorter than bme claim batch size.");
891         _claimFor(claimers);
892     }
893 
894     // Change possible when in initPhase
895     function changePhaseToBME()
896         public onlyOwner whenNotPaused whenNotInBME
897     {
898         _isInBmePhase = true;
899         emit PhaseChangedToBME(msg.sender);
900     }
901 }
902 
903 interface IEntryCreditContract {
904 
905     function mint(address receiver, uint256 amount) external returns (bool);
906 }
907 
908 // NOTE the following interface imposes the minimum technically feasible
909 // NOTE constraints on information that is to be exchanged between the
910 // NOTE Peerz token contract and the balance sheet contract
911 
912 // NOTE in other words, in our opinion this interface is the one with the
913 // NOTE highest probability of allowing for an implementation of the required
914 // NOTE functionality in the balance sheet contract
915 
916 // NOTE an alternative approach to having popMintingInformation return two
917 // NOTE arrays would be to have it return a single array that contains only
918 // NOTE the receiving addresses for minting and using popClaimingInformation
919 // NOTE to actually mint the tokens; this approach requires bmeMint to make
920 // NOTE two external calls instead of a single one; and it imposes more
921 // NOTE structure on the future implementation of the balance sheet contract
922 // NOTE since its side of the BME mint functionality would have to be
923 // NOTE implemented using two separate functions whereas it might also on its
924 // NOTE side be more efficient to use a single function
925 
926 interface IBalanceSheetContract {
927 
928     function setPeerzTokenSupply(uint256 przTotalSupply) external returns (bool);
929 
930     // NOTE the returned arrays need to have exactly the same length
931     function popMintingInformation(uint256 bmeMintBatchSize) external returns (address[] memory, uint256[] memory);
932 
933     // NOTE the returned array needs to have exactly the same length as the claimers array
934     function popClaimingInformation(address[] calldata claimers) external returns (uint256[] memory);
935 }