1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/access/Roles.sol
285 
286 pragma solidity ^0.5.0;
287 
288 /**
289  * @title Roles
290  * @dev Library for managing addresses assigned to a Role.
291  */
292 library Roles {
293     struct Role {
294         mapping (address => bool) bearer;
295     }
296 
297     /**
298      * @dev give an account access to this role
299      */
300     function add(Role storage role, address account) internal {
301         require(account != address(0));
302         require(!has(role, account));
303 
304         role.bearer[account] = true;
305     }
306 
307     /**
308      * @dev remove an account's access to this role
309      */
310     function remove(Role storage role, address account) internal {
311         require(account != address(0));
312         require(has(role, account));
313 
314         role.bearer[account] = false;
315     }
316 
317     /**
318      * @dev check if an account has this role
319      * @return bool
320      */
321     function has(Role storage role, address account) internal view returns (bool) {
322         require(account != address(0));
323         return role.bearer[account];
324     }
325 }
326 
327 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
328 
329 pragma solidity ^0.5.0;
330 
331 
332 contract MinterRole {
333     using Roles for Roles.Role;
334 
335     event MinterAdded(address indexed account);
336     event MinterRemoved(address indexed account);
337 
338     Roles.Role private _minters;
339 
340     constructor () internal {
341         _addMinter(msg.sender);
342     }
343 
344     modifier onlyMinter() {
345         require(isMinter(msg.sender));
346         _;
347     }
348 
349     function isMinter(address account) public view returns (bool) {
350         return _minters.has(account);
351     }
352 
353     function addMinter(address account) public onlyMinter {
354         _addMinter(account);
355     }
356 
357     function renounceMinter() public {
358         _removeMinter(msg.sender);
359     }
360 
361     function _addMinter(address account) internal {
362         _minters.add(account);
363         emit MinterAdded(account);
364     }
365 
366     function _removeMinter(address account) internal {
367         _minters.remove(account);
368         emit MinterRemoved(account);
369     }
370 }
371 
372 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
373 
374 pragma solidity ^0.5.0;
375 
376 
377 
378 /**
379  * @title ERC20Mintable
380  * @dev ERC20 minting logic
381  */
382 contract ERC20Mintable is ERC20, MinterRole {
383     /**
384      * @dev Function to mint tokens
385      * @param to The address that will receive the minted tokens.
386      * @param value The amount of tokens to mint.
387      * @return A boolean that indicates if the operation was successful.
388      */
389     function mint(address to, uint256 value) public onlyMinter returns (bool) {
390         _mint(to, value);
391         return true;
392     }
393 }
394 
395 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
396 
397 pragma solidity ^0.5.0;
398 
399 
400 /**
401  * @title Capped token
402  * @dev Mintable token with a token cap.
403  */
404 contract ERC20Capped is ERC20Mintable {
405     uint256 private _cap;
406 
407     constructor (uint256 cap) public {
408         require(cap > 0);
409         _cap = cap;
410     }
411 
412     /**
413      * @return the cap for the token minting.
414      */
415     function cap() public view returns (uint256) {
416         return _cap;
417     }
418 
419     function _mint(address account, uint256 value) internal {
420         require(totalSupply().add(value) <= _cap);
421         super._mint(account, value);
422     }
423 }
424 
425 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
426 
427 pragma solidity ^0.5.0;
428 
429 
430 /**
431  * @title ERC20Detailed token
432  * @dev The decimals are only for visualization purposes.
433  * All the operations are done using the smallest and indivisible token unit,
434  * just as on Ethereum all the operations are done in wei.
435  */
436 contract ERC20Detailed is IERC20 {
437     string private _name;
438     string private _symbol;
439     uint8 private _decimals;
440 
441     constructor (string memory name, string memory symbol, uint8 decimals) public {
442         _name = name;
443         _symbol = symbol;
444         _decimals = decimals;
445     }
446 
447     /**
448      * @return the name of the token.
449      */
450     function name() public view returns (string memory) {
451         return _name;
452     }
453 
454     /**
455      * @return the symbol of the token.
456      */
457     function symbol() public view returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @return the number of decimals of the token.
463      */
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 }
468 
469 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
470 
471 pragma solidity ^0.5.0;
472 
473 
474 contract PauserRole {
475     using Roles for Roles.Role;
476 
477     event PauserAdded(address indexed account);
478     event PauserRemoved(address indexed account);
479 
480     Roles.Role private _pausers;
481 
482     constructor () internal {
483         _addPauser(msg.sender);
484     }
485 
486     modifier onlyPauser() {
487         require(isPauser(msg.sender));
488         _;
489     }
490 
491     function isPauser(address account) public view returns (bool) {
492         return _pausers.has(account);
493     }
494 
495     function addPauser(address account) public onlyPauser {
496         _addPauser(account);
497     }
498 
499     function renouncePauser() public {
500         _removePauser(msg.sender);
501     }
502 
503     function _addPauser(address account) internal {
504         _pausers.add(account);
505         emit PauserAdded(account);
506     }
507 
508     function _removePauser(address account) internal {
509         _pausers.remove(account);
510         emit PauserRemoved(account);
511     }
512 }
513 
514 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
515 
516 pragma solidity ^0.5.0;
517 
518 
519 /**
520  * @title Pausable
521  * @dev Base contract which allows children to implement an emergency stop mechanism.
522  */
523 contract Pausable is PauserRole {
524     event Paused(address account);
525     event Unpaused(address account);
526 
527     bool private _paused;
528 
529     constructor () internal {
530         _paused = false;
531     }
532 
533     /**
534      * @return true if the contract is paused, false otherwise.
535      */
536     function paused() public view returns (bool) {
537         return _paused;
538     }
539 
540     /**
541      * @dev Modifier to make a function callable only when the contract is not paused.
542      */
543     modifier whenNotPaused() {
544         require(!_paused);
545         _;
546     }
547 
548     /**
549      * @dev Modifier to make a function callable only when the contract is paused.
550      */
551     modifier whenPaused() {
552         require(_paused);
553         _;
554     }
555 
556     /**
557      * @dev called by the owner to pause, triggers stopped state
558      */
559     function pause() public onlyPauser whenNotPaused {
560         _paused = true;
561         emit Paused(msg.sender);
562     }
563 
564     /**
565      * @dev called by the owner to unpause, returns to normal state
566      */
567     function unpause() public onlyPauser whenPaused {
568         _paused = false;
569         emit Unpaused(msg.sender);
570     }
571 }
572 
573 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
574 
575 pragma solidity ^0.5.0;
576 
577 
578 
579 /**
580  * @title Pausable token
581  * @dev ERC20 modified with pausable transfers.
582  **/
583 contract ERC20Pausable is ERC20, Pausable {
584     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
585         return super.transfer(to, value);
586     }
587 
588     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
589         return super.transferFrom(from, to, value);
590     }
591 
592     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
593         return super.approve(spender, value);
594     }
595 
596     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
597         return super.increaseAllowance(spender, addedValue);
598     }
599 
600     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
601         return super.decreaseAllowance(spender, subtractedValue);
602     }
603 }
604 
605 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
606 
607 pragma solidity ^0.5.0;
608 
609 /**
610  * @title Ownable
611  * @dev The Ownable contract has an owner address, and provides basic authorization control
612  * functions, this simplifies the implementation of "user permissions".
613  */
614 contract Ownable {
615     address private _owner;
616 
617     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
618 
619     /**
620      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
621      * account.
622      */
623     constructor () internal {
624         _owner = msg.sender;
625         emit OwnershipTransferred(address(0), _owner);
626     }
627 
628     /**
629      * @return the address of the owner.
630      */
631     function owner() public view returns (address) {
632         return _owner;
633     }
634 
635     /**
636      * @dev Throws if called by any account other than the owner.
637      */
638     modifier onlyOwner() {
639         require(isOwner());
640         _;
641     }
642 
643     /**
644      * @return true if `msg.sender` is the owner of the contract.
645      */
646     function isOwner() public view returns (bool) {
647         return msg.sender == _owner;
648     }
649 
650     /**
651      * @dev Allows the current owner to relinquish control of the contract.
652      * @notice Renouncing to ownership will leave the contract without an owner.
653      * It will not be possible to call the functions with the `onlyOwner`
654      * modifier anymore.
655      */
656     function renounceOwnership() public onlyOwner {
657         emit OwnershipTransferred(_owner, address(0));
658         _owner = address(0);
659     }
660 
661     /**
662      * @dev Allows the current owner to transfer control of the contract to a newOwner.
663      * @param newOwner The address to transfer ownership to.
664      */
665     function transferOwnership(address newOwner) public onlyOwner {
666         _transferOwnership(newOwner);
667     }
668 
669     /**
670      * @dev Transfers control of the contract to a newOwner.
671      * @param newOwner The address to transfer ownership to.
672      */
673     function _transferOwnership(address newOwner) internal {
674         require(newOwner != address(0));
675         emit OwnershipTransferred(_owner, newOwner);
676         _owner = newOwner;
677     }
678 }
679 
680 // File: contracts/OceanToken.sol
681 
682 pragma solidity 0.5.3;
683 
684 
685 
686 
687 
688 /**
689  * @title Ocean Protocol ERC20 Token Contract
690  * @author Ocean Protocol Team
691  * @dev Implementation of the Ocean Token.
692  */
693 contract OceanToken is Ownable, ERC20Pausable, ERC20Detailed, ERC20Capped {
694     
695     using SafeMath for uint256;
696     
697     uint8 constant DECIMALS = 18;
698     uint256 constant CAP = 690900000;
699     uint256 TOTALSUPPLY = CAP.mul(uint256(10) ** DECIMALS);
700     
701     // keep track token holders
702     address[] private accounts = new address[](0);
703     mapping(address => bool) private tokenHolders;
704     
705     /**
706      * @dev OceanToken constructor
707      * @param contractOwner refers to the owner of the contract
708      */
709     constructor(
710         address contractOwner
711     )
712     public
713     ERC20Detailed('OceanToken', 'OCEAN', DECIMALS)
714     ERC20Capped(TOTALSUPPLY)
715     Ownable()
716     {
717         addPauser(contractOwner);
718         renouncePauser();
719         addMinter(contractOwner);
720         renounceMinter();
721         transferOwnership(contractOwner);
722     }
723     
724     /**
725      * @dev transfer tokens when not paused (pausable transfer function)
726      * @param _to receiver address
727      * @param _value amount of tokens
728      * @return true if receiver is illegible to receive tokens
729      */
730     function transfer(
731         address _to,
732         uint256 _value
733     )
734     public
735     returns (bool)
736     {
737         bool success = super.transfer(_to, _value);
738         if (success) {
739             updateTokenHolders(msg.sender, _to);
740         }
741         return success;
742     }
743     
744     /**
745      * @dev transferFrom transfers tokens only when token is not paused
746      * @param _from sender address
747      * @param _to receiver address
748      * @param _value amount of tokens
749      * @return true if receiver is illegible to receive tokens
750      */
751     function transferFrom(
752         address _from,
753         address _to,
754         uint256 _value
755     )
756     public
757     returns (bool)
758     {
759         bool success = super.transferFrom(_from, _to, _value);
760         if (success) {
761             updateTokenHolders(_from, _to);
762         }
763         return success;
764     }
765     
766     /**
767      * @dev retrieve the address & token balance of token holders (each time retrieve partial from the list)
768      * @param _start index
769      * @param _end index
770      * @return array of accounts and array of balances
771      */
772     function getAccounts(
773         uint256 _start,
774         uint256 _end
775     )
776     external
777     view
778     onlyOwner
779     returns (address[] memory, uint256[] memory)
780     {
781         require(
782             _start <= _end && _end < accounts.length,
783             'Array index out of bounds'
784         );
785         
786         uint256 length = _end.sub(_start).add(1);
787         
788         address[] memory _tokenHolders = new address[](length);
789         uint256[] memory _tokenBalances = new uint256[](length);
790         
791         for (uint256 i = _start; i <= _end; i++)
792         {
793             address account = accounts[i];
794             uint256 accountBalance = super.balanceOf(account);
795             if (accountBalance > 0)
796             {
797                 _tokenBalances[i] = accountBalance;
798                 _tokenHolders[i] = account;
799             }
800         }
801         
802         return (_tokenHolders, _tokenBalances);
803     }
804     
805     /**
806      * @dev get length of account list
807      */
808     function getAccountsLength()
809     external
810     view
811     onlyOwner
812     returns (uint256)
813     {
814         return accounts.length;
815     }
816     
817     /**
818      * @dev kill the contract and destroy all tokens
819      */
820     function kill()
821     external
822     onlyOwner
823     {
824         selfdestruct(address(uint160(owner())));
825     }
826     
827     /**
828      * @dev fallback function prevents ether transfer to this contract
829      */
830     function()
831     external
832     payable
833     {
834         revert('Invalid ether transfer');
835     }
836     
837     /*
838      * @dev tryToAddTokenHolder try to add the account to the token holders structure
839      * @param account address
840      */
841     function tryToAddTokenHolder(
842         address account
843     )
844     private
845     {
846         if (!tokenHolders[account] && super.balanceOf(account) > 0)
847         {
848             accounts.push(account);
849             tokenHolders[account] = true;
850         }
851     }
852     
853     /*
854      * @dev updateTokenHolders maintains the accounts array and set the address as a promising token holder
855      * @param sender address
856      * @param receiver address.
857      */
858     function updateTokenHolders(
859         address sender,
860         address receiver
861     )
862     private
863     {
864         tryToAddTokenHolder(sender);
865         tryToAddTokenHolder(receiver);
866     }
867 }