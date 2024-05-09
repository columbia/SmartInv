1 pragma solidity 0.5.3;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
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
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param owner The address to query the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Transfer token for a specified address
139     * @param to The address to transfer to.
140     * @param value The amount to be transferred.
141     */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = value;
160         emit Approval(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174         _transfer(from, to, value);
175         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when allowed_[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         require(spender != address(0));
191 
192         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
211         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212         return true;
213     }
214 
215     /**
216     * @dev Transfer token for a specified addresses
217     * @param from The address to transfer from.
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }
272 
273 /**
274  * @title Roles
275  * @dev Library for managing addresses assigned to a Role.
276  */
277 library Roles {
278     struct Role {
279         mapping (address => bool) bearer;
280     }
281 
282     /**
283      * @dev give an account access to this role
284      */
285     function add(Role storage role, address account) internal {
286         require(account != address(0));
287         require(!has(role, account));
288 
289         role.bearer[account] = true;
290     }
291 
292     /**
293      * @dev remove an account's access to this role
294      */
295     function remove(Role storage role, address account) internal {
296         require(account != address(0));
297         require(has(role, account));
298 
299         role.bearer[account] = false;
300     }
301 
302     /**
303      * @dev check if an account has this role
304      * @return bool
305      */
306     function has(Role storage role, address account) internal view returns (bool) {
307         require(account != address(0));
308         return role.bearer[account];
309     }
310 }
311 
312 contract MinterRole {
313     using Roles for Roles.Role;
314 
315     event MinterAdded(address indexed account);
316     event MinterRemoved(address indexed account);
317 
318     Roles.Role private _minters;
319 
320     constructor () internal {
321         _addMinter(msg.sender);
322     }
323 
324     modifier onlyMinter() {
325         require(isMinter(msg.sender));
326         _;
327     }
328 
329     function isMinter(address account) public view returns (bool) {
330         return _minters.has(account);
331     }
332 
333     function addMinter(address account) public onlyMinter {
334         _addMinter(account);
335     }
336 
337     function renounceMinter() public {
338         _removeMinter(msg.sender);
339     }
340 
341     function _addMinter(address account) internal {
342         _minters.add(account);
343         emit MinterAdded(account);
344     }
345 
346     function _removeMinter(address account) internal {
347         _minters.remove(account);
348         emit MinterRemoved(account);
349     }
350 }
351 
352 /**
353  * @title ERC20Mintable
354  * @dev ERC20 minting logic
355  */
356 contract ERC20Mintable is ERC20, MinterRole {
357     /**
358      * @dev Function to mint tokens
359      * @param to The address that will receive the minted tokens.
360      * @param value The amount of tokens to mint.
361      * @return A boolean that indicates if the operation was successful.
362      */
363     function mint(address to, uint256 value) public onlyMinter returns (bool) {
364         _mint(to, value);
365         return true;
366     }
367 }
368 
369 /**
370  * @title Capped token
371  * @dev Mintable token with a token cap.
372  */
373 contract ERC20Capped is ERC20Mintable {
374     uint256 private _cap;
375 
376     constructor (uint256 cap) public {
377         require(cap > 0);
378         _cap = cap;
379     }
380 
381     /**
382      * @return the cap for the token minting.
383      */
384     function cap() public view returns (uint256) {
385         return _cap;
386     }
387 
388     function _mint(address account, uint256 value) internal {
389         require(totalSupply().add(value) <= _cap);
390         super._mint(account, value);
391     }
392 }
393 
394 /**
395  * @title ERC20Detailed token
396  * @dev The decimals are only for visualization purposes.
397  * All the operations are done using the smallest and indivisible token unit,
398  * just as on Ethereum all the operations are done in wei.
399  */
400 contract ERC20Detailed is IERC20 {
401     string private _name;
402     string private _symbol;
403     uint8 private _decimals;
404 
405     constructor (string memory name, string memory symbol, uint8 decimals) public {
406         _name = name;
407         _symbol = symbol;
408         _decimals = decimals;
409     }
410 
411     /**
412      * @return the name of the token.
413      */
414     function name() public view returns (string memory) {
415         return _name;
416     }
417 
418     /**
419      * @return the symbol of the token.
420      */
421     function symbol() public view returns (string memory) {
422         return _symbol;
423     }
424 
425     /**
426      * @return the number of decimals of the token.
427      */
428     function decimals() public view returns (uint8) {
429         return _decimals;
430     }
431 }
432 
433 contract PauserRole {
434     using Roles for Roles.Role;
435 
436     event PauserAdded(address indexed account);
437     event PauserRemoved(address indexed account);
438 
439     Roles.Role private _pausers;
440 
441     constructor () internal {
442         _addPauser(msg.sender);
443     }
444 
445     modifier onlyPauser() {
446         require(isPauser(msg.sender));
447         _;
448     }
449 
450     function isPauser(address account) public view returns (bool) {
451         return _pausers.has(account);
452     }
453 
454     function addPauser(address account) public onlyPauser {
455         _addPauser(account);
456     }
457 
458     function renouncePauser() public {
459         _removePauser(msg.sender);
460     }
461 
462     function _addPauser(address account) internal {
463         _pausers.add(account);
464         emit PauserAdded(account);
465     }
466 
467     function _removePauser(address account) internal {
468         _pausers.remove(account);
469         emit PauserRemoved(account);
470     }
471 }
472 
473 /**
474  * @title Pausable
475  * @dev Base contract which allows children to implement an emergency stop mechanism.
476  */
477 contract Pausable is PauserRole {
478     event Paused(address account);
479     event Unpaused(address account);
480 
481     bool private _paused;
482 
483     constructor () internal {
484         _paused = false;
485     }
486 
487     /**
488      * @return true if the contract is paused, false otherwise.
489      */
490     function paused() public view returns (bool) {
491         return _paused;
492     }
493 
494     /**
495      * @dev Modifier to make a function callable only when the contract is not paused.
496      */
497     modifier whenNotPaused() {
498         require(!_paused);
499         _;
500     }
501 
502     /**
503      * @dev Modifier to make a function callable only when the contract is paused.
504      */
505     modifier whenPaused() {
506         require(_paused);
507         _;
508     }
509 
510     /**
511      * @dev called by the owner to pause, triggers stopped state
512      */
513     function pause() public onlyPauser whenNotPaused {
514         _paused = true;
515         emit Paused(msg.sender);
516     }
517 
518     /**
519      * @dev called by the owner to unpause, returns to normal state
520      */
521     function unpause() public onlyPauser whenPaused {
522         _paused = false;
523         emit Unpaused(msg.sender);
524     }
525 }
526 
527 /**
528  * @title Pausable token
529  * @dev ERC20 modified with pausable transfers.
530  **/
531 contract ERC20Pausable is ERC20, Pausable {
532     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
533         return super.transfer(to, value);
534     }
535 
536     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
537         return super.transferFrom(from, to, value);
538     }
539 
540     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
541         return super.approve(spender, value);
542     }
543 
544     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
545         return super.increaseAllowance(spender, addedValue);
546     }
547 
548     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
549         return super.decreaseAllowance(spender, subtractedValue);
550     }
551 }
552 
553 /**
554  * @title Ownable
555  * @dev The Ownable contract has an owner address, and provides basic authorization control
556  * functions, this simplifies the implementation of "user permissions".
557  */
558 contract Ownable {
559     address private _owner;
560 
561     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
562 
563     /**
564      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
565      * account.
566      */
567     constructor () internal {
568         _owner = msg.sender;
569         emit OwnershipTransferred(address(0), _owner);
570     }
571 
572     /**
573      * @return the address of the owner.
574      */
575     function owner() public view returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(isOwner());
584         _;
585     }
586 
587     /**
588      * @return true if `msg.sender` is the owner of the contract.
589      */
590     function isOwner() public view returns (bool) {
591         return msg.sender == _owner;
592     }
593 
594     /**
595      * @dev Allows the current owner to relinquish control of the contract.
596      * @notice Renouncing to ownership will leave the contract without an owner.
597      * It will not be possible to call the functions with the `onlyOwner`
598      * modifier anymore.
599      */
600     function renounceOwnership() public onlyOwner {
601         emit OwnershipTransferred(_owner, address(0));
602         _owner = address(0);
603     }
604 
605     /**
606      * @dev Allows the current owner to transfer control of the contract to a newOwner.
607      * @param newOwner The address to transfer ownership to.
608      */
609     function transferOwnership(address newOwner) public onlyOwner {
610         _transferOwnership(newOwner);
611     }
612 
613     /**
614      * @dev Transfers control of the contract to a newOwner.
615      * @param newOwner The address to transfer ownership to.
616      */
617     function _transferOwnership(address newOwner) internal {
618         require(newOwner != address(0));
619         emit OwnershipTransferred(_owner, newOwner);
620         _owner = newOwner;
621     }
622 }
623 
624 /**
625  * @title Ocean Protocol ERC20 Token Contract
626  * @author Ocean Protocol Team
627  * @dev Implementation of the Ocean Token.
628  */
629 contract OceanToken is Ownable, ERC20Pausable, ERC20Detailed, ERC20Capped {
630     
631     using SafeMath for uint256;
632     
633     uint8 constant DECIMALS = 18;
634     uint256 constant CAP = 1410000000;
635     uint256 TOTALSUPPLY = CAP.mul(uint256(10) ** DECIMALS);
636     
637     // keep track token holders
638     address[] private accounts = new address[](0);
639     mapping(address => bool) private tokenHolders;
640     
641     /**
642      * @dev Ocean Token constructor
643      * @param contractOwner refers to the owner of the contract
644      */
645     constructor(
646         address contractOwner
647     )
648     public
649     ERC20Detailed('Ocean Token', 'OCEAN', DECIMALS)
650     ERC20Capped(TOTALSUPPLY)
651     Ownable()
652     {
653         addPauser(contractOwner);
654         renouncePauser();
655         addMinter(contractOwner);
656         renounceMinter();
657         transferOwnership(contractOwner);
658     }
659     
660     /**
661      * @dev transfer tokens when not paused (pausable transfer function)
662      * @param _to receiver address
663      * @param _value amount of tokens
664      * @return true if receiver is illegible to receive tokens
665      */
666     function transfer(
667         address _to,
668         uint256 _value
669     )
670     public
671     returns (bool)
672     {
673         bool success = super.transfer(_to, _value);
674         if (success) {
675             updateTokenHolders(msg.sender, _to);
676         }
677         return success;
678     }
679     
680     /**
681      * @dev transferFrom transfers tokens only when token is not paused
682      * @param _from sender address
683      * @param _to receiver address
684      * @param _value amount of tokens
685      * @return true if receiver is illegible to receive tokens
686      */
687     function transferFrom(
688         address _from,
689         address _to,
690         uint256 _value
691     )
692     public
693     returns (bool)
694     {
695         bool success = super.transferFrom(_from, _to, _value);
696         if (success) {
697             updateTokenHolders(_from, _to);
698         }
699         return success;
700     }
701     
702     /**
703      * @dev retrieve the address & token balance of token holders (each time retrieve partial from the list)
704      * @param _start index
705      * @param _end index
706      * @return array of accounts and array of balances
707      */
708     function getAccounts(
709         uint256 _start,
710         uint256 _end
711     )
712     external
713     view
714     onlyOwner
715     returns (address[] memory, uint256[] memory)
716     {
717         require(
718             _start <= _end && _end < accounts.length,
719             'Array index out of bounds'
720         );
721         
722         uint256 length = _end.sub(_start).add(1);
723         
724         address[] memory _tokenHolders = new address[](length);
725         uint256[] memory _tokenBalances = new uint256[](length);
726         
727         for (uint256 i = _start; i <= _end; i++)
728         {
729             address account = accounts[i];
730             uint256 accountBalance = super.balanceOf(account);
731             if (accountBalance > 0)
732             {
733                 _tokenBalances[i] = accountBalance;
734                 _tokenHolders[i] = account;
735             }
736         }
737         
738         return (_tokenHolders, _tokenBalances);
739     }
740     
741     /**
742      * @dev get length of account list
743      */
744     function getAccountsLength()
745     external
746     view
747     onlyOwner
748     returns (uint256)
749     {
750         return accounts.length;
751     }
752     
753     /**
754      * @dev kill the contract and destroy all tokens
755      */
756     function kill()
757     external
758     onlyOwner
759     {
760         selfdestruct(address(uint160(owner())));
761     }
762     
763     /**
764      * @dev fallback function prevents ether transfer to this contract
765      */
766     function()
767     external
768     payable
769     {
770         revert('Invalid ether transfer');
771     }
772     
773     /*
774      * @dev tryToAddTokenHolder try to add the account to the token holders structure
775      * @param account address
776      */
777     function tryToAddTokenHolder(
778         address account
779     )
780     private
781     {
782         if (!tokenHolders[account] && super.balanceOf(account) > 0)
783         {
784             accounts.push(account);
785             tokenHolders[account] = true;
786         }
787     }
788     
789     /*
790      * @dev updateTokenHolders maintains the accounts array and set the address as a promising token holder
791      * @param sender address
792      * @param receiver address.
793      */
794     function updateTokenHolders(
795         address sender,
796         address receiver
797     )
798     private
799     {
800         tryToAddTokenHolder(sender);
801         tryToAddTokenHolder(receiver);
802     }
803 }