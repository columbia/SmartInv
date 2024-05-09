1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev give an account access to this role
14      */
15     function add(Role storage role, address account) internal {
16         require(account != address(0));
17         require(!has(role, account));
18 
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev remove an account's access to this role
24      */
25     function remove(Role storage role, address account) internal {
26         require(account != address(0));
27         require(has(role, account));
28 
29         role.bearer[account] = false;
30     }
31 
32     /**
33      * @dev check if an account has this role
34      * @return bool
35      */
36     function has(Role storage role, address account) internal view returns (bool) {
37         require(account != address(0));
38         return role.bearer[account];
39     }
40 }
41 
42 
43 /**
44  * @title SafeMath
45  * @dev Unsigned math operations with safety checks that revert on error
46  */
47 library SafeMath {
48     /**
49     * @dev Multiplies two unsigned integers, reverts on overflow.
50     */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b);
61 
62         return c;
63     }
64 
65     /**
66     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
67     */
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Solidity only automatically asserts when dividing by 0
70         require(b > 0);
71         uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73 
74         return c;
75     }
76 
77     /**
78     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88     * @dev Adds two unsigned integers, reverts on overflow.
89     */
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a);
93 
94         return c;
95     }
96 
97     /**
98     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
99     * reverts when dividing by zero.
100     */
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b != 0);
103         return a % b;
104     }
105 }
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 interface IERC20 {
113     function transfer(address to, uint256 value) external returns (bool);
114 
115     function approve(address spender, uint256 value) external returns (bool);
116 
117     function transferFrom(address from, address to, uint256 value) external returns (bool);
118 
119     function totalSupply() external view returns (uint256);
120 
121     function balanceOf(address who) external view returns (uint256);
122 
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     event Transfer(address indexed from, address indexed to, uint256 value);
126 
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 
131 
132 
133 
134 /**
135  * @title SafeERC20
136  * @dev Wrappers around ERC20 operations that throw on failure.
137  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
138  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
139  */
140 library SafeERC20 {
141     using SafeMath for uint256;
142 
143     function safeTransfer(IERC20 token, address to, uint256 value) internal {
144         require(token.transfer(to, value));
145     }
146 
147     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
148         require(token.transferFrom(from, to, value));
149     }
150 
151     function safeApprove(IERC20 token, address spender, uint256 value) internal {
152         // safeApprove should only be called when setting an initial allowance,
153         // or when resetting it to zero. To increase and decrease it, use
154         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
155         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
156         require(token.approve(spender, value));
157     }
158 
159     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
160         uint256 newAllowance = token.allowance(address(this), spender).add(value);
161         require(token.approve(spender, newAllowance));
162     }
163 
164     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
165         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
166         require(token.approve(spender, newAllowance));
167     }
168 }
169 
170 
171 
172 
173 contract PauserRole {
174     using Roles for Roles.Role;
175 
176     event PauserAdded(address indexed account);
177     event PauserRemoved(address indexed account);
178 
179     Roles.Role private _pausers;
180 
181     constructor () internal {
182         _addPauser(msg.sender);
183     }
184 
185     modifier onlyPauser() {
186         require(isPauser(msg.sender));
187         _;
188     }
189 
190     function isPauser(address account) public view returns (bool) {
191         return _pausers.has(account);
192     }
193 
194     function addPauser(address account) public onlyPauser {
195         _addPauser(account);
196     }
197 
198     function renouncePauser() public {
199         _removePauser(msg.sender);
200     }
201 
202     function _addPauser(address account) internal {
203         _pausers.add(account);
204         emit PauserAdded(account);
205     }
206 
207     function _removePauser(address account) internal {
208         _pausers.remove(account);
209         emit PauserRemoved(account);
210     }
211 }
212 
213 
214 
215 
216 
217 /**
218  * @title Standard ERC20 token
219  *
220  * @dev Implementation of the basic standard token.
221  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
222  * Originally based on code by FirstBlood:
223  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  *
225  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
226  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
227  * compliant implementations may not do it.
228  */
229 contract ERC20 is IERC20 {
230     using SafeMath for uint256;
231 
232     mapping (address => uint256) private _balances;
233 
234     mapping (address => mapping (address => uint256)) private _allowed;
235 
236     uint256 private _totalSupply;
237 
238     /**
239     * @dev Total number of tokens in existence
240     */
241     function totalSupply() public view returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246     * @dev Gets the balance of the specified address.
247     * @param owner The address to query the balance of.
248     * @return An uint256 representing the amount owned by the passed address.
249     */
250     function balanceOf(address owner) public view returns (uint256) {
251         return _balances[owner];
252     }
253 
254     /**
255      * @dev Function to check the amount of tokens that an owner allowed to a spender.
256      * @param owner address The address which owns the funds.
257      * @param spender address The address which will spend the funds.
258      * @return A uint256 specifying the amount of tokens still available for the spender.
259      */
260     function allowance(address owner, address spender) public view returns (uint256) {
261         return _allowed[owner][spender];
262     }
263 
264     /**
265     * @dev Transfer token for a specified address
266     * @param to The address to transfer to.
267     * @param value The amount to be transferred.
268     */
269     function transfer(address to, uint256 value) public returns (bool) {
270         _transfer(msg.sender, to, value);
271         return true;
272     }
273 
274     /**
275      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
276      * Beware that changing an allowance with this method brings the risk that someone may use both the old
277      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      * @param spender The address which will spend the funds.
281      * @param value The amount of tokens to be spent.
282      */
283     function approve(address spender, uint256 value) public returns (bool) {
284         require(spender != address(0));
285 
286         _allowed[msg.sender][spender] = value;
287         emit Approval(msg.sender, spender, value);
288         return true;
289     }
290 
291     /**
292      * @dev Transfer tokens from one address to another.
293      * Note that while this function emits an Approval event, this is not required as per the specification,
294      * and other compliant implementations may not emit the event.
295      * @param from address The address which you want to send tokens from
296      * @param to address The address which you want to transfer to
297      * @param value uint256 the amount of tokens to be transferred
298      */
299     function transferFrom(address from, address to, uint256 value) public returns (bool) {
300         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
301         _transfer(from, to, value);
302         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
303         return true;
304     }
305 
306     /**
307      * @dev Increase the amount of tokens that an owner allowed to a spender.
308      * approve should be called when allowed_[_spender] == 0. To increment
309      * allowed value is better to use this function to avoid 2 calls (and wait until
310      * the first transaction is mined)
311      * From MonolithDAO Token.sol
312      * Emits an Approval event.
313      * @param spender The address which will spend the funds.
314      * @param addedValue The amount of tokens to increase the allowance by.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
317         require(spender != address(0));
318 
319         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
320         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
321         return true;
322     }
323 
324     /**
325      * @dev Decrease the amount of tokens that an owner allowed to a spender.
326      * approve should be called when allowed_[_spender] == 0. To decrement
327      * allowed value is better to use this function to avoid 2 calls (and wait until
328      * the first transaction is mined)
329      * From MonolithDAO Token.sol
330      * Emits an Approval event.
331      * @param spender The address which will spend the funds.
332      * @param subtractedValue The amount of tokens to decrease the allowance by.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
335         require(spender != address(0));
336 
337         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
338         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
339         return true;
340     }
341 
342     /**
343     * @dev Transfer token for a specified addresses
344     * @param from The address to transfer from.
345     * @param to The address to transfer to.
346     * @param value The amount to be transferred.
347     */
348     function _transfer(address from, address to, uint256 value) internal {
349         require(to != address(0));
350 
351         _balances[from] = _balances[from].sub(value);
352         _balances[to] = _balances[to].add(value);
353         emit Transfer(from, to, value);
354     }
355 
356     /**
357      * @dev Internal function that mints an amount of the token and assigns it to
358      * an account. This encapsulates the modification of balances such that the
359      * proper events are emitted.
360      * @param account The account that will receive the created tokens.
361      * @param value The amount that will be created.
362      */
363     function _mint(address account, uint256 value) internal {
364         require(account != address(0));
365 
366         _totalSupply = _totalSupply.add(value);
367         _balances[account] = _balances[account].add(value);
368         emit Transfer(address(0), account, value);
369     }
370 
371     /**
372      * @dev Internal function that burns an amount of the token of a given
373      * account.
374      * @param account The account whose tokens will be burnt.
375      * @param value The amount that will be burnt.
376      */
377     function _burn(address account, uint256 value) internal {
378         require(account != address(0));
379 
380         _totalSupply = _totalSupply.sub(value);
381         _balances[account] = _balances[account].sub(value);
382         emit Transfer(account, address(0), value);
383     }
384 
385     /**
386      * @dev Internal function that burns an amount of the token of a given
387      * account, deducting from the sender's allowance for said account. Uses the
388      * internal burn function.
389      * Emits an Approval event (reflecting the reduced allowance).
390      * @param account The account whose tokens will be burnt.
391      * @param value The amount that will be burnt.
392      */
393     function _burnFrom(address account, uint256 value) internal {
394         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
395         _burn(account, value);
396         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
397     }
398 }
399 
400 
401 
402 
403 contract MinterRole {
404     using Roles for Roles.Role;
405 
406     event MinterAdded(address indexed account);
407     event MinterRemoved(address indexed account);
408 
409     Roles.Role private _minters;
410 
411     constructor () internal {
412         _addMinter(msg.sender);
413     }
414 
415     modifier onlyMinter() {
416         require(isMinter(msg.sender));
417         _;
418     }
419 
420     function isMinter(address account) public view returns (bool) {
421         return _minters.has(account);
422     }
423 
424     function addMinter(address account) public onlyMinter {
425         _addMinter(account);
426     }
427 
428     function renounceMinter() public {
429         _removeMinter(msg.sender);
430     }
431 
432     function _addMinter(address account) internal {
433         _minters.add(account);
434         emit MinterAdded(account);
435     }
436 
437     function _removeMinter(address account) internal {
438         _minters.remove(account);
439         emit MinterRemoved(account);
440     }
441 }
442 
443 
444 
445 
446 /**
447  * @title Ownable
448  * @dev The Ownable contract has an owner address, and provides basic authorization control
449  * functions, this simplifies the implementation of "user permissions".
450  */
451 contract Ownable {
452     address private _owner;
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     /**
457      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
458      * account.
459      */
460     constructor () internal {
461         _owner = msg.sender;
462         emit OwnershipTransferred(address(0), _owner);
463     }
464 
465     /**
466      * @return the address of the owner.
467      */
468     function owner() public view returns (address) {
469         return _owner;
470     }
471 
472     /**
473      * @dev Throws if called by any account other than the owner.
474      */
475     modifier onlyOwner() {
476         require(isOwner());
477         _;
478     }
479 
480     /**
481      * @return true if `msg.sender` is the owner of the contract.
482      */
483     function isOwner() public view returns (bool) {
484         return msg.sender == _owner;
485     }
486 
487     /**
488      * @dev Allows the current owner to relinquish control of the contract.
489      * @notice Renouncing to ownership will leave the contract without an owner.
490      * It will not be possible to call the functions with the `onlyOwner`
491      * modifier anymore.
492      */
493     function renounceOwnership() public onlyOwner {
494         emit OwnershipTransferred(_owner, address(0));
495         _owner = address(0);
496     }
497 
498     /**
499      * @dev Allows the current owner to transfer control of the contract to a newOwner.
500      * @param newOwner The address to transfer ownership to.
501      */
502     function transferOwnership(address newOwner) public onlyOwner {
503         _transferOwnership(newOwner);
504     }
505 
506     /**
507      * @dev Transfers control of the contract to a newOwner.
508      * @param newOwner The address to transfer ownership to.
509      */
510     function _transferOwnership(address newOwner) internal {
511         require(newOwner != address(0));
512         emit OwnershipTransferred(_owner, newOwner);
513         _owner = newOwner;
514     }
515 }
516 
517 
518 
519 
520 
521 /**
522  * @title Burnable Token
523  * @dev Token that can be irreversibly burned (destroyed).
524  */
525 contract ERC20Burnable is ERC20 {
526     /**
527      * @dev Burns a specific amount of tokens.
528      * @param value The amount of token to be burned.
529      */
530     function burn(uint256 value) public {
531         _burn(msg.sender, value);
532     }
533 
534     /**
535      * @dev Burns a specific amount of tokens from the target address and decrements allowance
536      * @param from address The address which you want to send tokens from
537      * @param value uint256 The amount of token to be burned
538      */
539     function burnFrom(address from, uint256 value) public {
540         _burnFrom(from, value);
541     }
542 }
543 
544 
545 
546 
547 
548 
549 /**
550  * @title ERC20Mintable
551  * @dev ERC20 minting logic
552  */
553 contract ERC20Mintable is ERC20, MinterRole {
554     /**
555      * @dev Function to mint tokens
556      * @param to The address that will receive the minted tokens.
557      * @param value The amount of tokens to mint.
558      * @return A boolean that indicates if the operation was successful.
559      */
560     function mint(address to, uint256 value) public onlyMinter returns (bool) {
561         _mint(to, value);
562         return true;
563     }
564 }
565 
566 
567 
568 
569 
570 
571 
572 
573 /**
574  * @title Pausable
575  * @dev Base contract which allows children to implement an emergency stop mechanism.
576  */
577 contract Pausable is PauserRole {
578     event Paused(address account);
579     event Unpaused(address account);
580 
581     bool private _paused;
582 
583     constructor () internal {
584         _paused = false;
585     }
586 
587     /**
588      * @return true if the contract is paused, false otherwise.
589      */
590     function paused() public view returns (bool) {
591         return _paused;
592     }
593 
594     /**
595      * @dev Modifier to make a function callable only when the contract is not paused.
596      */
597     modifier whenNotPaused() {
598         require(!_paused);
599         _;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is paused.
604      */
605     modifier whenPaused() {
606         require(_paused);
607         _;
608     }
609 
610     /**
611      * @dev called by the owner to pause, triggers stopped state
612      */
613     function pause() public onlyPauser whenNotPaused {
614         _paused = true;
615         emit Paused(msg.sender);
616     }
617 
618     /**
619      * @dev called by the owner to unpause, returns to normal state
620      */
621     function unpause() public onlyPauser whenPaused {
622         _paused = false;
623         emit Unpaused(msg.sender);
624     }
625 }
626 
627 
628 /**
629  * @title Pausable token
630  * @dev ERC20 modified with pausable transfers.
631  **/
632 contract ERC20Pausable is ERC20, Pausable {
633     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
634         return super.transfer(to, value);
635     }
636 
637     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
638         return super.transferFrom(from, to, value);
639     }
640 
641     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
642         return super.approve(spender, value);
643     }
644 
645     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
646         return super.increaseAllowance(spender, addedValue);
647     }
648 
649     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
650         return super.decreaseAllowance(spender, subtractedValue);
651     }
652 }
653 
654 
655 
656 
657 
658 /**
659  * @title ERC20Detailed token
660  * @dev The decimals are only for visualization purposes.
661  * All the operations are done using the smallest and indivisible token unit,
662  * just as on Ethereum all the operations are done in wei.
663  */
664 contract ERC20Detailed is IERC20 {
665     string private _name;
666     string private _symbol;
667     uint8 private _decimals;
668 
669     constructor (string memory name, string memory symbol, uint8 decimals) public {
670         _name = name;
671         _symbol = symbol;
672         _decimals = decimals;
673     }
674 
675     /**
676      * @return the name of the token.
677      */
678     function name() public view returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @return the symbol of the token.
684      */
685     function symbol() public view returns (string memory) {
686         return _symbol;
687     }
688 
689     /**
690      * @return the number of decimals of the token.
691      */
692     function decimals() public view returns (uint8) {
693         return _decimals;
694     }
695 }
696 
697 
698 
699 
700 
701 contract TokenWhitelist is Ownable {
702 
703     mapping(address => bool) private whitelist;
704 
705     event Whitelisted(address indexed wallet);
706     event Dewhitelisted(address indexed wallet);
707 
708     function enableWallet(address _wallet) public onlyOwner {
709         require(_wallet != address(0), "Invalid wallet");
710         whitelist[_wallet] = true;
711         emit Whitelisted(_wallet);
712     }
713     
714     function enableWalletBatch(address[] memory _wallets) public onlyOwner {
715         for (uint256 i = 0; i < _wallets.length; i++) {
716             enableWallet(_wallets[i]);
717         }
718     }
719 
720 
721     function disableWallet(address _wallet) public onlyOwner {
722         require(_wallet != address(0), "Invalid wallet");
723         whitelist[_wallet] = false;
724         emit Dewhitelisted(_wallet);
725     }
726 
727     
728     function disableWalletBatch(address[] memory _wallets) public onlyOwner {
729         for (uint256 i = 0; i < _wallets.length; i++) {
730             disableWallet(_wallets[i]);
731         }
732     }
733     
734     function checkWhitelisted(address _wallet) public view returns (bool){
735         return whitelist[_wallet];
736     }
737     
738 }
739 
740 
741 
742 
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 
753 
754 
755 contract TrustedRole is Ownable {
756     using Roles for Roles.Role;
757 
758     event TrustedAdded(address indexed account);
759     event TrustedRemoved(address indexed account);
760 
761     Roles.Role private trusted;
762 
763     constructor() internal {
764         _addTrusted(msg.sender);
765     }
766 
767     modifier onlyOwnerOrTrusted() {
768         require(isOwner() || isTrusted(msg.sender), "Only owner or trusted allowed");
769         _;
770     }
771 
772     modifier onlyTrusted() {
773         require(isTrusted(msg.sender), "Only trusted allowed");
774         _;
775     }
776 
777     function isTrusted(address account) public view returns (bool) {
778         return trusted.has(account);
779     }
780 
781     function addTrusted(address account) public onlyOwner {
782         _addTrusted(account);
783     }
784 
785     function removeTrusted(address account) public onlyOwner {
786         _removeTrusted(account);
787     }
788 
789     function _addTrusted(address account) internal {
790         trusted.add(account);
791         emit TrustedAdded(account);
792     }
793 
794     function _removeTrusted(address account) internal {
795         trusted.remove(account);
796         emit TrustedRemoved(account);
797     }
798 }
799 
800 
801 /**
802  * @title MultiTokenDividend
803  *
804  * Based on https://medium.com/%40weka/dividend-bearing-tokens-on-ethereum-42d01c710657
805  * Distributes dividends on multiple currencies: ETH and ERC20
806  */
807 contract MultiTokenDividend is Ownable, TrustedRole {
808     using SafeMath for uint256;
809     using SafeERC20 for IERC20;
810 
811     // Stores each account preferred payment method and balance
812     struct Account {
813         address tokenAddress;
814         uint256 amount;
815         uint256 lastTotalDividendPoints;
816     }
817     mapping(address => Account) public accounts;
818 
819     // Stores information about each payment method
820     struct Dividend {
821         uint256 totalDividendPoints;
822         uint256 unclaimedDividends;
823         uint256 totalSupply;
824     }
825     mapping(address => Dividend) public tokenDividends;
826 
827     // Main token for calculation of dividends
828     ERC20Detailed private _sharesToken;
829 
830     // Constant to allow division by totalSupply (from the article)
831     uint256 private X;
832 
833     // Disbursement failure for tracking
834     event TransferFailure(address indexed beneficiary);
835 
836     constructor(ERC20Detailed token, uint256 const) public {
837         _sharesToken = token;
838         X = const;
839     }
840 
841     // Access
842     modifier onlyToken() {
843         require(msg.sender == address(_sharesToken), "Only the token allowed");
844         _;
845     }
846 
847     // Receive and collect funds
848     function() external payable {}
849     function collect(address tokenAddress) public onlyOwner {
850         if (tokenAddress == address(0)) {
851             address(uint160(owner())).transfer(address(this).balance);
852         }
853         else {
854             IERC20 token = IERC20(tokenAddress);
855             token.safeTransfer(owner(), token.balanceOf(address(this)));
856         }
857     }
858 
859     function setPaymentMethod(address beneficiary, address tokenAddress) public onlyOwnerOrTrusted {
860         // Ensure he doesn't lose his unclaimed dividends
861         updateAccount(beneficiary);
862         require(accounts[beneficiary].amount == 0, "Withdraw the balance before changing payout token");
863 
864         // Set the new payment method
865         address oldToken = accounts[beneficiary].tokenAddress;
866         accounts[beneficiary].tokenAddress = tokenAddress;
867         accounts[beneficiary].lastTotalDividendPoints = tokenDividends[tokenAddress].totalDividendPoints;
868         
869         // Move his pool of tokens to another payment method
870         uint256 beneficiaryShares = _sharesToken.balanceOf(beneficiary);
871         tokenDividends[oldToken].totalSupply = tokenDividends[oldToken].totalSupply.sub(beneficiaryShares);
872         tokenDividends[tokenAddress].totalSupply = tokenDividends[tokenAddress].totalSupply.add(beneficiaryShares);
873     }
874 
875     function dividendsOwing(address beneficiary) internal view returns(uint256) {
876         Account storage account = accounts[beneficiary];
877         uint256 newDividendPoints = tokenDividends[account.tokenAddress].totalDividendPoints.sub(account.lastTotalDividendPoints);
878         return _sharesToken.balanceOf(beneficiary).mul(newDividendPoints).div(X);
879     }
880 
881     function updateAccount(address account) public onlyOwnerOrTrusted {
882         _updateAccount(account);
883     }
884 
885     function _updateAccount(address account) internal {
886         uint256 owing = dividendsOwing(account);
887         Dividend storage dividend = tokenDividends[accounts[account].tokenAddress];
888         if (owing > 0) {
889             dividend.unclaimedDividends = dividend.unclaimedDividends.sub(owing);
890             accounts[account].amount = accounts[account].amount.add(owing);
891         }
892         // Prevent new account holders to claim past dividends
893         if (accounts[account].lastTotalDividendPoints != dividend.totalDividendPoints) {
894             accounts[account].lastTotalDividendPoints = dividend.totalDividendPoints;
895         }
896     }
897 
898     // Register dividends for these payment methods
899     function addDividends(address[] memory tokens) public onlyOwner {
900         for (uint256 i = 0; i < tokens.length; i++) {
901             address token = tokens[i];
902             uint256 tokenAmount = 0;
903             
904             // Get the total amount to distribute
905             if (token == address(0)) {
906                 // ETH
907                 tokenAmount = address(this).balance;
908             }
909             else {
910                 // ERC20
911                 tokenAmount = IERC20(token).balanceOf(address(this));
912             }
913 
914             Dividend storage dividend = tokenDividends[token];
915 
916             // Subtract unclaimed tokens
917             if (tokenAmount > dividend.unclaimedDividends) {
918                 tokenAmount = tokenAmount - dividend.unclaimedDividends;
919                 dividend.totalDividendPoints = dividend.totalDividendPoints.add(
920                     tokenAmount.mul(X).div(dividend.totalSupply)
921                 );
922                 dividend.unclaimedDividends = dividend.unclaimedDividends.add(tokenAmount);
923             }
924         }
925     }
926 
927     // Send the dividends to their accounts
928     // Iterate offchain to prevent hitting the gas limit
929     function disburse(address payable[] calldata beneficiaries) external onlyOwner {
930         for (uint256 i = 0; i < beneficiaries.length; i++) {
931             address payable acc = beneficiaries[i];
932             updateAccount(acc);
933 
934             bool success = _disburse(acc);
935             if (!success) {
936                 emit TransferFailure(acc);
937             }
938         }
939     }
940 
941     function withdraw() public {
942         _updateAccount(msg.sender);
943         require(_disburse(msg.sender), "Failed to transfer ETH");
944     }
945 
946     function _disburse(address payable beneficiary) internal returns (bool) {
947         Account storage account = accounts[beneficiary];
948         uint256 amount = account.amount;
949         if (amount == 0) return true;
950         
951         // Set to 0 before transfering
952         account.amount = 0;
953 
954         if (account.tokenAddress == address(0)) {
955             // ETH disbursement
956             bool success = beneficiary.send(amount);
957             if (!success) {
958                 account.amount = amount;
959             }
960             return success;
961         }
962         else {
963             // ERC20 disbursement
964             IERC20 token = IERC20(account.tokenAddress);
965             token.safeTransfer(beneficiary, amount);
966             return true;
967         }
968     }
969 
970     /**
971      * Changes to totalSupply
972      */
973     function _registerBurn(address from, uint256 amount) public onlyToken {
974         _updateAccount(from);
975         Dividend storage tokenDividend = tokenDividends[accounts[from].tokenAddress];
976         tokenDividend.totalSupply = tokenDividend.totalSupply.sub(amount);
977     }
978     function _registerMint(address to, uint256 amount) public onlyToken {
979         _updateAccount(to);
980         Dividend storage tokenDividend = tokenDividends[accounts[to].tokenAddress];
981         tokenDividend.totalSupply = tokenDividend.totalSupply.add(amount);
982     }
983     function _registerTransfer(address from, address to, uint256 amount) public onlyToken {
984         _updateAccount(from);
985         _updateAccount(to);
986         if (accounts[from].tokenAddress != accounts[to].tokenAddress) {
987             Dividend storage fromDividend = tokenDividends[accounts[from].tokenAddress];
988             fromDividend.totalSupply = fromDividend.totalSupply.sub(amount);
989             
990             Dividend storage toDividend = tokenDividends[accounts[to].tokenAddress];
991             toDividend.totalSupply = toDividend.totalSupply.add(amount);
992         }
993     }
994 }
995 
996 
997 contract ERC20MultiDividend is Ownable, ERC20 {
998     MultiTokenDividend internal _dividend;
999 
1000     constructor() internal {}
1001 
1002     function setDividendContract(MultiTokenDividend dividend) external onlyOwner {
1003         _dividend = dividend;
1004     }
1005 
1006     /**
1007      * Notify MultiTokenDividend of changes
1008      */
1009     function _burn(address account, uint256 value) internal {
1010         _dividend._registerBurn(account, value);
1011         super._burn(account, value);
1012     }
1013     function _mint(address account, uint256 value) internal {
1014         _dividend._registerMint(account, value);
1015         super._mint(account, value);
1016     }
1017     function _transfer(address from, address to, uint256 value) internal {
1018         _dividend._registerTransfer(from, to, value);
1019         super._transfer(from, to, value);
1020     }
1021 }
1022 
1023 contract ReitBZ is Ownable, ERC20MultiDividend, ERC20Burnable, ERC20Mintable, ERC20Pausable, ERC20Detailed {
1024 
1025     TokenWhitelist public whitelist;
1026 
1027     constructor() public
1028     ERC20Detailed("ReitBZ", "RBZ", 18) {
1029         whitelist = new TokenWhitelist();
1030     }
1031 
1032     // Distribution Functions
1033     // Whitelist Functions
1034     function transferOwnership(address newOwner) public onlyOwner {
1035         super.transferOwnership(newOwner);
1036         _addMinter(newOwner);
1037         _removeMinter(msg.sender);
1038         _addPauser(newOwner);
1039         _removePauser(msg.sender);
1040     }
1041 
1042     function addToWhitelistBatch(address[] calldata wallets) external onlyOwner {
1043         whitelist.enableWalletBatch(wallets);
1044     }
1045 
1046     function addToWhitelist(address wallet) public onlyOwner {
1047         whitelist.enableWallet(wallet);
1048     }
1049 
1050     function removeFromWhitelist(address wallet) public onlyOwner {
1051         whitelist.disableWallet(wallet);
1052     }
1053 
1054     function removeFromWhitelistBatch(address[] calldata wallets) external onlyOwner {
1055         whitelist.disableWalletBatch(wallets);
1056     }
1057 
1058     function checkWhitelisted(address wallet) public view returns (bool) {
1059         return whitelist.checkWhitelisted(wallet);
1060     }
1061 
1062     // ERC20Burnable Functions
1063 
1064     function burn(uint256 value) public onlyOwner {
1065         super.burn(value);
1066     }
1067 
1068     function burnFrom(address from, uint256 value) public onlyOwner {
1069         _burn(from, value);
1070     }
1071 
1072     // ERC20Mintable Functions
1073 
1074     function mint(address to, uint256 value) public returns (bool) {
1075         require(whitelist.checkWhitelisted(to), "Receiver is not whitelisted.");
1076         return super.mint(to, value);
1077     }
1078 
1079     // ERC20 Functions
1080 
1081     function transfer(address to, uint256 value) public returns (bool) {
1082         require(whitelist.checkWhitelisted(msg.sender), "Sender is not whitelisted.");
1083         require(whitelist.checkWhitelisted(to), "Receiver is not whitelisted.");
1084         return super.transfer(to, value);
1085     }
1086 
1087     function transferFrom(address from,address to, uint256 value) public returns (bool) {
1088         require(whitelist.checkWhitelisted(msg.sender), "Transaction sender is not whitelisted.");
1089         require(whitelist.checkWhitelisted(from), "Token sender is not whitelisted.");
1090         require(whitelist.checkWhitelisted(to), "Receiver is not whitelisted.");
1091         return super.transferFrom(from, to, value);
1092     }
1093 
1094     function approve(address spender, uint256 value) public returns (bool) {
1095         require(whitelist.checkWhitelisted(msg.sender), "Sender is not whitelisted.");
1096         require(whitelist.checkWhitelisted(spender), "Spender is not whitelisted.");
1097         return super.approve(spender, value);
1098     }
1099 
1100     function increaseAllowance(address spender, uint addedValue) public returns (bool success) {
1101         require(whitelist.checkWhitelisted(msg.sender), "Sender is not whitelisted.");
1102         require(whitelist.checkWhitelisted(spender), "Spender is not whitelisted.");
1103         return super.increaseAllowance(spender, addedValue);
1104     }
1105 
1106     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool success) {
1107         require(whitelist.checkWhitelisted(msg.sender), "Sender is not whitelisted.");
1108         require(whitelist.checkWhitelisted(spender), "Spender is not whitelisted.");
1109         return super.decreaseAllowance(spender, subtractedValue);
1110     }
1111 
1112 }