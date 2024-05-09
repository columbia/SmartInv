1 pragma solidity ^0.5.7;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
27 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
28 
29 /**
30  * @title ERC20Detailed token
31  * @dev The decimals are only for visualization purposes.
32  * All the operations are done using the smallest and indivisible token unit,
33  * just as on Ethereum all the operations are done in wei.
34  */
35 contract ERC20Detailed is IERC20 {
36     string private _name;
37     string private _symbol;
38     uint8 private _decimals;
39 
40     constructor (string memory name, string memory symbol, uint8 decimals) public {
41         _name = name;
42         _symbol = symbol;
43         _decimals = decimals;
44     }
45 
46     /**
47      * @return the name of the token.
48      */
49     function name() public view returns (string memory) {
50         return _name;
51     }
52 
53     /**
54      * @return the symbol of the token.
55      */
56     function symbol() public view returns (string memory) {
57         return _symbol;
58     }
59 
60     /**
61      * @return the number of decimals of the token.
62      */
63     function decimals() public view returns (uint8) {
64         return _decimals;
65     }
66 }
67 
68 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
69 
70 /**
71  * @title SafeMath
72  * @dev Unsigned math operations with safety checks that revert on error
73  */
74 library SafeMath {
75     /**
76      * @dev Multiplies two unsigned integers, reverts on overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
94      */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     /**
105      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b <= a);
109         uint256 c = a - b;
110 
111         return c;
112     }
113 
114     /**
115      * @dev Adds two unsigned integers, reverts on overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a);
120 
121         return c;
122     }
123 
124     /**
125      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
126      * reverts when dividing by zero.
127      */
128     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
129         require(b != 0);
130         return a % b;
131     }
132 }
133 
134 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * https://eips.ethereum.org/EIPS/eip-20
141  * Originally based on code by FirstBlood:
142  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  *
144  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
145  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
146  * compliant implementations may not do it.
147  */
148 contract ERC20 is IERC20 {
149     using SafeMath for uint256;
150 
151     mapping (address => uint256) private _balances;
152 
153     mapping (address => mapping (address => uint256)) private _allowed;
154 
155     uint256 private _totalSupply;
156 
157     /**
158      * @dev Total number of tokens in existence
159      */
160     function totalSupply() public view returns (uint256) {
161         return _totalSupply;
162     }
163 
164     /**
165      * @dev Gets the balance of the specified address.
166      * @param owner The address to query the balance of.
167      * @return A uint256 representing the amount owned by the passed address.
168      */
169     function balanceOf(address owner) public view returns (uint256) {
170         return _balances[owner];
171     }
172 
173     /**
174      * @dev Function to check the amount of tokens that an owner allowed to a spender.
175      * @param owner address The address which owns the funds.
176      * @param spender address The address which will spend the funds.
177      * @return A uint256 specifying the amount of tokens still available for the spender.
178      */
179     function allowance(address owner, address spender) public view returns (uint256) {
180         return _allowed[owner][spender];
181     }
182 
183     /**
184      * @dev Transfer token to a specified address
185      * @param to The address to transfer to.
186      * @param value The amount to be transferred.
187      */
188     function transfer(address to, uint256 value) public returns (bool) {
189         _transfer(msg.sender, to, value);
190         return true;
191     }
192 
193     /**
194      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195      * Beware that changing an allowance with this method brings the risk that someone may use both the old
196      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      * @param spender The address which will spend the funds.
200      * @param value The amount of tokens to be spent.
201      */
202     function approve(address spender, uint256 value) public returns (bool) {
203         _approve(msg.sender, spender, value);
204         return true;
205     }
206 
207     /**
208      * @dev Transfer tokens from one address to another.
209      * Note that while this function emits an Approval event, this is not required as per the specification,
210      * and other compliant implementations may not emit the event.
211      * @param from address The address which you want to send tokens from
212      * @param to address The address which you want to transfer to
213      * @param value uint256 the amount of tokens to be transferred
214      */
215     function transferFrom(address from, address to, uint256 value) public returns (bool) {
216         _transfer(from, to, value);
217         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
218         return true;
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * Emits an Approval event.
228      * @param spender The address which will spend the funds.
229      * @param addedValue The amount of tokens to increase the allowance by.
230      */
231     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
232         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
233         return true;
234     }
235 
236     /**
237      * @dev Decrease the amount of tokens that an owner allowed to a spender.
238      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
247         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
248         return true;
249     }
250 
251     /**
252      * @dev Transfer token for a specified addresses
253      * @param from The address to transfer from.
254      * @param to The address to transfer to.
255      * @param value The amount to be transferred.
256      */
257     function _transfer(address from, address to, uint256 value) internal {
258         require(to != address(0));
259 
260         _balances[from] = _balances[from].sub(value);
261         _balances[to] = _balances[to].add(value);
262         emit Transfer(from, to, value);
263     }
264 
265     /**
266      * @dev Internal function that mints an amount of the token and assigns it to
267      * an account. This encapsulates the modification of balances such that the
268      * proper events are emitted.
269      * @param account The account that will receive the created tokens.
270      * @param value The amount that will be created.
271      */
272     function _mint(address account, uint256 value) internal {
273         require(account != address(0));
274 
275         _totalSupply = _totalSupply.add(value);
276         _balances[account] = _balances[account].add(value);
277         emit Transfer(address(0), account, value);
278     }
279 
280     /**
281      * @dev Internal function that burns an amount of the token of a given
282      * account.
283      * @param account The account whose tokens will be burnt.
284      * @param value The amount that will be burnt.
285      */
286     function _burn(address account, uint256 value) internal {
287         require(account != address(0));
288 
289         _totalSupply = _totalSupply.sub(value);
290         _balances[account] = _balances[account].sub(value);
291         emit Transfer(account, address(0), value);
292     }
293 
294     /**
295      * @dev Approve an address to spend another addresses' tokens.
296      * @param owner The address that owns the tokens.
297      * @param spender The address that will spend the tokens.
298      * @param value The number of tokens that can be spent.
299      */
300     function _approve(address owner, address spender, uint256 value) internal {
301         require(spender != address(0));
302         require(owner != address(0));
303 
304         _allowed[owner][spender] = value;
305         emit Approval(owner, spender, value);
306     }
307 
308     /**
309      * @dev Internal function that burns an amount of the token of a given
310      * account, deducting from the sender's allowance for said account. Uses the
311      * internal burn function.
312      * Emits an Approval event (reflecting the reduced allowance).
313      * @param account The account whose tokens will be burnt.
314      * @param value The amount that will be burnt.
315      */
316     function _burnFrom(address account, uint256 value) internal {
317         _burn(account, value);
318         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
319     }
320 }
321 
322 // File: openzeppelin-solidity/contracts/access/Roles.sol
323 
324 /**
325  * @title Roles
326  * @dev Library for managing addresses assigned to a Role.
327  */
328 library Roles {
329     struct Role {
330         mapping (address => bool) bearer;
331     }
332 
333     /**
334      * @dev give an account access to this role
335      */
336     function add(Role storage role, address account) internal {
337         require(account != address(0));
338         require(!has(role, account));
339 
340         role.bearer[account] = true;
341     }
342 
343     /**
344      * @dev remove an account's access to this role
345      */
346     function remove(Role storage role, address account) internal {
347         require(account != address(0));
348         require(has(role, account));
349 
350         role.bearer[account] = false;
351     }
352 
353     /**
354      * @dev check if an account has this role
355      * @return bool
356      */
357     function has(Role storage role, address account) internal view returns (bool) {
358         require(account != address(0));
359         return role.bearer[account];
360     }
361 }
362 
363 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
364 
365 contract MinterRole {
366     using Roles for Roles.Role;
367 
368     event MinterAdded(address indexed account);
369     event MinterRemoved(address indexed account);
370 
371     Roles.Role private _minters;
372 
373     constructor () internal {
374         _addMinter(msg.sender);
375     }
376 
377     modifier onlyMinter() {
378         require(isMinter(msg.sender));
379         _;
380     }
381 
382     function isMinter(address account) public view returns (bool) {
383         return _minters.has(account);
384     }
385 
386     function addMinter(address account) public onlyMinter {
387         _addMinter(account);
388     }
389 
390     function renounceMinter() public {
391         _removeMinter(msg.sender);
392     }
393 
394     function _addMinter(address account) internal {
395         _minters.add(account);
396         emit MinterAdded(account);
397     }
398 
399     function _removeMinter(address account) internal {
400         _minters.remove(account);
401         emit MinterRemoved(account);
402     }
403 }
404 
405 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
406 
407 /**
408  * @title ERC20Mintable
409  * @dev ERC20 minting logic
410  */
411 contract ERC20Mintable is ERC20, MinterRole {
412     /**
413      * @dev Function to mint tokens
414      * @param to The address that will receive the minted tokens.
415      * @param value The amount of tokens to mint.
416      * @return A boolean that indicates if the operation was successful.
417      */
418     function mint(address to, uint256 value) public onlyMinter returns (bool) {
419         _mint(to, value);
420         return true;
421     }
422 }
423 
424 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
425 
426 /**
427  * @title Capped token
428  * @dev Mintable token with a token cap.
429  */
430 contract ERC20Capped is ERC20Mintable {
431     uint256 private _cap;
432 
433     constructor (uint256 cap) public {
434         require(cap > 0);
435         _cap = cap;
436     }
437 
438     /**
439      * @return the cap for the token minting.
440      */
441     function cap() public view returns (uint256) {
442         return _cap;
443     }
444 
445     function _mint(address account, uint256 value) internal {
446         require(totalSupply().add(value) <= _cap);
447         super._mint(account, value);
448     }
449 }
450 
451 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
452 
453 /**
454  * @title Burnable Token
455  * @dev Token that can be irreversibly burned (destroyed).
456  */
457 contract ERC20Burnable is ERC20 {
458     /**
459      * @dev Burns a specific amount of tokens.
460      * @param value The amount of token to be burned.
461      */
462     function burn(uint256 value) public {
463         _burn(msg.sender, value);
464     }
465 
466     /**
467      * @dev Burns a specific amount of tokens from the target address and decrements allowance
468      * @param from address The account whose tokens will be burned.
469      * @param value uint256 The amount of token to be burned.
470      */
471     function burnFrom(address from, uint256 value) public {
472         _burnFrom(from, value);
473     }
474 }
475 
476 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
477 
478 /**
479  * @title Ownable
480  * @dev The Ownable contract has an owner address, and provides basic authorization control
481  * functions, this simplifies the implementation of "user permissions".
482  */
483 contract Ownable {
484     address private _owner;
485 
486     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
487 
488     /**
489      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
490      * account.
491      */
492     constructor () internal {
493         _owner = msg.sender;
494         emit OwnershipTransferred(address(0), _owner);
495     }
496 
497     /**
498      * @return the address of the owner.
499      */
500     function owner() public view returns (address) {
501         return _owner;
502     }
503 
504     /**
505      * @dev Throws if called by any account other than the owner.
506      */
507     modifier onlyOwner() {
508         require(isOwner());
509         _;
510     }
511 
512     /**
513      * @return true if `msg.sender` is the owner of the contract.
514      */
515     function isOwner() public view returns (bool) {
516         return msg.sender == _owner;
517     }
518 
519     /**
520      * @dev Allows the current owner to relinquish control of the contract.
521      * It will not be possible to call the functions with the `onlyOwner`
522      * modifier anymore.
523      * @notice Renouncing ownership will leave the contract without an owner,
524      * thereby removing any functionality that is only available to the owner.
525      */
526     function renounceOwnership() public onlyOwner {
527         emit OwnershipTransferred(_owner, address(0));
528         _owner = address(0);
529     }
530 
531     /**
532      * @dev Allows the current owner to transfer control of the contract to a newOwner.
533      * @param newOwner The address to transfer ownership to.
534      */
535     function transferOwnership(address newOwner) public onlyOwner {
536         _transferOwnership(newOwner);
537     }
538 
539     /**
540      * @dev Transfers control of the contract to a newOwner.
541      * @param newOwner The address to transfer ownership to.
542      */
543     function _transferOwnership(address newOwner) internal {
544         require(newOwner != address(0));
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549 
550 // File: eth-token-recover/contracts/TokenRecover.sol
551 
552 /**
553  * @title TokenRecover
554  * @author Vittorio Minacori (https://github.com/vittominacori)
555  * @dev Allow to recover any ERC20 sent into the contract for error
556  */
557 contract TokenRecover is Ownable {
558 
559     /**
560      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
561      * @param tokenAddress The token contract address
562      * @param tokenAmount Number of tokens to be sent
563      */
564     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
565         IERC20(tokenAddress).transfer(owner(), tokenAmount);
566     }
567 }
568 
569 // File: ico-maker/contracts/access/roles/OperatorRole.sol
570 
571 contract OperatorRole {
572     using Roles for Roles.Role;
573 
574     event OperatorAdded(address indexed account);
575     event OperatorRemoved(address indexed account);
576 
577     Roles.Role private _operators;
578 
579     constructor() internal {
580         _addOperator(msg.sender);
581     }
582 
583     modifier onlyOperator() {
584         require(isOperator(msg.sender));
585         _;
586     }
587 
588     function isOperator(address account) public view returns (bool) {
589         return _operators.has(account);
590     }
591 
592     function addOperator(address account) public onlyOperator {
593         _addOperator(account);
594     }
595 
596     function renounceOperator() public {
597         _removeOperator(msg.sender);
598     }
599 
600     function _addOperator(address account) internal {
601         _operators.add(account);
602         emit OperatorAdded(account);
603     }
604 
605     function _removeOperator(address account) internal {
606         _operators.remove(account);
607         emit OperatorRemoved(account);
608     }
609 }
610 
611 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
612 
613 /**
614  * @title BaseERC20Token
615  * @author Vittorio Minacori (https://github.com/vittominacori)
616  * @dev Implementation of the BaseERC20Token
617  */
618 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
619 
620     event MintFinished();
621     event TransferEnabled();
622 
623     // indicates if minting is finished
624     bool private _mintingFinished = false;
625 
626     // indicates if transfer is enabled
627     bool private _transferEnabled = false;
628 
629     /**
630      * @dev Tokens can be minted only before minting finished.
631      */
632     modifier canMint() {
633         require(!_mintingFinished);
634         _;
635     }
636 
637     /**
638      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
639      */
640     modifier canTransfer(address from) {
641         require(_transferEnabled || isOperator(from));
642         _;
643     }
644 
645     /**
646      * @param name Name of the token
647      * @param symbol A symbol to be used as ticker
648      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
649      * @param cap Maximum number of tokens mintable
650      * @param initialSupply Initial token supply
651      */
652     constructor(
653         string memory name,
654         string memory symbol,
655         uint8 decimals,
656         uint256 cap,
657         uint256 initialSupply
658     )
659         public
660         ERC20Detailed(name, symbol, decimals)
661         ERC20Capped(cap)
662     {
663         if (initialSupply > 0) {
664             _mint(owner(), initialSupply);
665         }
666     }
667 
668     /**
669      * @return if minting is finished or not.
670      */
671     function mintingFinished() public view returns (bool) {
672         return _mintingFinished;
673     }
674 
675     /**
676      * @return if transfer is enabled or not.
677      */
678     function transferEnabled() public view returns (bool) {
679         return _transferEnabled;
680     }
681 
682     /**
683      * @dev Function to mint tokens
684      * @param to The address that will receive the minted tokens.
685      * @param value The amount of tokens to mint.
686      * @return A boolean that indicates if the operation was successful.
687      */
688     function mint(address to, uint256 value) public canMint returns (bool) {
689         return super.mint(to, value);
690     }
691 
692     /**
693      * @dev Transfer token to a specified address
694      * @param to The address to transfer to.
695      * @param value The amount to be transferred.
696      * @return A boolean that indicates if the operation was successful.
697      */
698     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
699         return super.transfer(to, value);
700     }
701 
702     /**
703      * @dev Transfer tokens from one address to another.
704      * @param from address The address which you want to send tokens from
705      * @param to address The address which you want to transfer to
706      * @param value uint256 the amount of tokens to be transferred
707      * @return A boolean that indicates if the operation was successful.
708      */
709     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
710         return super.transferFrom(from, to, value);
711     }
712 
713     /**
714      * @dev Function to stop minting new tokens and enable transfer.
715      */
716     function finishMinting() public onlyOwner canMint {
717         _mintingFinished = true;
718         _transferEnabled = true;
719 
720         emit MintFinished();
721         emit TransferEnabled();
722     }
723 
724     /**
725    * @dev Function to enable transfers.
726    */
727     function enableTransfer() public onlyOwner {
728         _transferEnabled = true;
729 
730         emit TransferEnabled();
731     }
732 
733     /**
734      * @dev remove the `operator` role from address
735      * @param account Address you want to remove role
736      */
737     function removeOperator(address account) public onlyOwner {
738         _removeOperator(account);
739     }
740 
741     /**
742      * @dev remove the `minter` role from address
743      * @param account Address you want to remove role
744      */
745     function removeMinter(address account) public onlyOwner {
746         _removeMinter(account);
747     }
748 }
749 
750 // File: contracts/ERC20Token.sol
751 
752 /**
753  * @title ERC20Token
754  * @author Vittorio Minacori (https://github.com/vittominacori)
755  * @dev Implementation of a BaseERC20Token
756  */
757 contract ERC20Token is BaseERC20Token {
758 
759     string public builtOn = "https://vittominacori.github.io/erc20-generator";
760 
761     constructor(
762         string memory name,
763         string memory symbol,
764         uint8 decimals,
765         uint256 cap,
766         uint256 initialSupply
767     )
768         public
769         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
770     {} // solhint-disable-line no-empty-blocks
771 }