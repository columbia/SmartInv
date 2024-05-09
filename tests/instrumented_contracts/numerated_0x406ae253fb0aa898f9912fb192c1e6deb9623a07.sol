1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
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
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
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
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
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
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
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
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
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
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
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
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.2;
290 
291 
292 /**
293  * @title ERC20Detailed token
294  * @dev The decimals are only for visualization purposes.
295  * All the operations are done using the smallest and indivisible token unit,
296  * just as on Ethereum all the operations are done in wei.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @return the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @return the symbol of the token.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @return the number of decimals of the token.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/access/Roles.sol
332 
333 pragma solidity ^0.5.2;
334 
335 /**
336  * @title Roles
337  * @dev Library for managing addresses assigned to a Role.
338  */
339 library Roles {
340     struct Role {
341         mapping (address => bool) bearer;
342     }
343 
344     /**
345      * @dev give an account access to this role
346      */
347     function add(Role storage role, address account) internal {
348         require(account != address(0));
349         require(!has(role, account));
350 
351         role.bearer[account] = true;
352     }
353 
354     /**
355      * @dev remove an account's access to this role
356      */
357     function remove(Role storage role, address account) internal {
358         require(account != address(0));
359         require(has(role, account));
360 
361         role.bearer[account] = false;
362     }
363 
364     /**
365      * @dev check if an account has this role
366      * @return bool
367      */
368     function has(Role storage role, address account) internal view returns (bool) {
369         require(account != address(0));
370         return role.bearer[account];
371     }
372 }
373 
374 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
375 
376 pragma solidity ^0.5.2;
377 
378 
379 contract PauserRole {
380     using Roles for Roles.Role;
381 
382     event PauserAdded(address indexed account);
383     event PauserRemoved(address indexed account);
384 
385     Roles.Role private _pausers;
386 
387     constructor () internal {
388         _addPauser(msg.sender);
389     }
390 
391     modifier onlyPauser() {
392         require(isPauser(msg.sender));
393         _;
394     }
395 
396     function isPauser(address account) public view returns (bool) {
397         return _pausers.has(account);
398     }
399 
400     function addPauser(address account) public onlyPauser {
401         _addPauser(account);
402     }
403 
404     function renouncePauser() public {
405         _removePauser(msg.sender);
406     }
407 
408     function _addPauser(address account) internal {
409         _pausers.add(account);
410         emit PauserAdded(account);
411     }
412 
413     function _removePauser(address account) internal {
414         _pausers.remove(account);
415         emit PauserRemoved(account);
416     }
417 }
418 
419 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
420 
421 pragma solidity ^0.5.2;
422 
423 
424 /**
425  * @title Pausable
426  * @dev Base contract which allows children to implement an emergency stop mechanism.
427  */
428 contract Pausable is PauserRole {
429     event Paused(address account);
430     event Unpaused(address account);
431 
432     bool private _paused;
433 
434     constructor () internal {
435         _paused = false;
436     }
437 
438     /**
439      * @return true if the contract is paused, false otherwise.
440      */
441     function paused() public view returns (bool) {
442         return _paused;
443     }
444 
445     /**
446      * @dev Modifier to make a function callable only when the contract is not paused.
447      */
448     modifier whenNotPaused() {
449         require(!_paused);
450         _;
451     }
452 
453     /**
454      * @dev Modifier to make a function callable only when the contract is paused.
455      */
456     modifier whenPaused() {
457         require(_paused);
458         _;
459     }
460 
461     /**
462      * @dev called by the owner to pause, triggers stopped state
463      */
464     function pause() public onlyPauser whenNotPaused {
465         _paused = true;
466         emit Paused(msg.sender);
467     }
468 
469     /**
470      * @dev called by the owner to unpause, returns to normal state
471      */
472     function unpause() public onlyPauser whenPaused {
473         _paused = false;
474         emit Unpaused(msg.sender);
475     }
476 }
477 
478 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
479 
480 pragma solidity ^0.5.2;
481 
482 
483 
484 /**
485  * @title Pausable token
486  * @dev ERC20 modified with pausable transfers.
487  */
488 contract ERC20Pausable is ERC20, Pausable {
489     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
490         return super.transfer(to, value);
491     }
492 
493     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
494         return super.transferFrom(from, to, value);
495     }
496 
497     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
498         return super.approve(spender, value);
499     }
500 
501     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
502         return super.increaseAllowance(spender, addedValue);
503     }
504 
505     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
506         return super.decreaseAllowance(spender, subtractedValue);
507     }
508 }
509 
510 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
511 
512 pragma solidity ^0.5.2;
513 
514 
515 contract MinterRole {
516     using Roles for Roles.Role;
517 
518     event MinterAdded(address indexed account);
519     event MinterRemoved(address indexed account);
520 
521     Roles.Role private _minters;
522 
523     constructor () internal {
524         _addMinter(msg.sender);
525     }
526 
527     modifier onlyMinter() {
528         require(isMinter(msg.sender));
529         _;
530     }
531 
532     function isMinter(address account) public view returns (bool) {
533         return _minters.has(account);
534     }
535 
536     function addMinter(address account) public onlyMinter {
537         _addMinter(account);
538     }
539 
540     function renounceMinter() public {
541         _removeMinter(msg.sender);
542     }
543 
544     function _addMinter(address account) internal {
545         _minters.add(account);
546         emit MinterAdded(account);
547     }
548 
549     function _removeMinter(address account) internal {
550         _minters.remove(account);
551         emit MinterRemoved(account);
552     }
553 }
554 
555 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
556 
557 pragma solidity ^0.5.2;
558 
559 
560 
561 /**
562  * @title ERC20Mintable
563  * @dev ERC20 minting logic
564  */
565 contract ERC20Mintable is ERC20, MinterRole {
566     /**
567      * @dev Function to mint tokens
568      * @param to The address that will receive the minted tokens.
569      * @param value The amount of tokens to mint.
570      * @return A boolean that indicates if the operation was successful.
571      */
572     function mint(address to, uint256 value) public onlyMinter returns (bool) {
573         _mint(to, value);
574         return true;
575     }
576 }
577 
578 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
579 
580 pragma solidity ^0.5.2;
581 
582 
583 /**
584  * @title Burnable Token
585  * @dev Token that can be irreversibly burned (destroyed).
586  */
587 contract ERC20Burnable is ERC20 {
588     /**
589      * @dev Burns a specific amount of tokens.
590      * @param value The amount of token to be burned.
591      */
592     function burn(uint256 value) public {
593         _burn(msg.sender, value);
594     }
595 
596     /**
597      * @dev Burns a specific amount of tokens from the target address and decrements allowance
598      * @param from address The account whose tokens will be burned.
599      * @param value uint256 The amount of token to be burned.
600      */
601     function burnFrom(address from, uint256 value) public {
602         _burnFrom(from, value);
603     }
604 }
605 
606 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
607 
608 pragma solidity ^0.5.2;
609 
610 /**
611  * @title Ownable
612  * @dev The Ownable contract has an owner address, and provides basic authorization control
613  * functions, this simplifies the implementation of "user permissions".
614  */
615 contract Ownable {
616     address private _owner;
617 
618     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619 
620     /**
621      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
622      * account.
623      */
624     constructor () internal {
625         _owner = msg.sender;
626         emit OwnershipTransferred(address(0), _owner);
627     }
628 
629     /**
630      * @return the address of the owner.
631      */
632     function owner() public view returns (address) {
633         return _owner;
634     }
635 
636     /**
637      * @dev Throws if called by any account other than the owner.
638      */
639     modifier onlyOwner() {
640         require(isOwner());
641         _;
642     }
643 
644     /**
645      * @return true if `msg.sender` is the owner of the contract.
646      */
647     function isOwner() public view returns (bool) {
648         return msg.sender == _owner;
649     }
650 
651     /**
652      * @dev Allows the current owner to relinquish control of the contract.
653      * It will not be possible to call the functions with the `onlyOwner`
654      * modifier anymore.
655      * @notice Renouncing ownership will leave the contract without an owner,
656      * thereby removing any functionality that is only available to the owner.
657      */
658     function renounceOwnership() public onlyOwner {
659         emit OwnershipTransferred(_owner, address(0));
660         _owner = address(0);
661     }
662 
663     /**
664      * @dev Allows the current owner to transfer control of the contract to a newOwner.
665      * @param newOwner The address to transfer ownership to.
666      */
667     function transferOwnership(address newOwner) public onlyOwner {
668         _transferOwnership(newOwner);
669     }
670 
671     /**
672      * @dev Transfers control of the contract to a newOwner.
673      * @param newOwner The address to transfer ownership to.
674      */
675     function _transferOwnership(address newOwner) internal {
676         require(newOwner != address(0));
677         emit OwnershipTransferred(_owner, newOwner);
678         _owner = newOwner;
679     }
680 }
681 
682 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
683 
684 pragma solidity ^0.5.2;
685 
686 
687 contract SignerRole {
688     using Roles for Roles.Role;
689 
690     event SignerAdded(address indexed account);
691     event SignerRemoved(address indexed account);
692 
693     Roles.Role private _signers;
694 
695     constructor () internal {
696         _addSigner(msg.sender);
697     }
698 
699     modifier onlySigner() {
700         require(isSigner(msg.sender));
701         _;
702     }
703 
704     function isSigner(address account) public view returns (bool) {
705         return _signers.has(account);
706     }
707 
708     function addSigner(address account) public onlySigner {
709         _addSigner(account);
710     }
711 
712     function renounceSigner() public {
713         _removeSigner(msg.sender);
714     }
715 
716     function _addSigner(address account) internal {
717         _signers.add(account);
718         emit SignerAdded(account);
719     }
720 
721     function _removeSigner(address account) internal {
722         _signers.remove(account);
723         emit SignerRemoved(account);
724     }
725 }
726 
727 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
728 
729 pragma solidity ^0.5.2;
730 
731 /**
732  * @title Elliptic curve signature operations
733  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
734  * TODO Remove this library once solidity supports passing a signature to ecrecover.
735  * See https://github.com/ethereum/solidity/issues/864
736  */
737 
738 library ECDSA {
739     /**
740      * @dev Recover signer address from a message by using their signature
741      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
742      * @param signature bytes signature, the signature is generated using web3.eth.sign()
743      */
744     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
745         // Check the signature length
746         if (signature.length != 65) {
747             return (address(0));
748         }
749 
750         // Divide the signature in r, s and v variables
751         bytes32 r;
752         bytes32 s;
753         uint8 v;
754 
755         // ecrecover takes the signature parameters, and the only way to get them
756         // currently is to use assembly.
757         // solhint-disable-next-line no-inline-assembly
758         assembly {
759             r := mload(add(signature, 0x20))
760             s := mload(add(signature, 0x40))
761             v := byte(0, mload(add(signature, 0x60)))
762         }
763 
764         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
765         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
766         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
767         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
768         //
769         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
770         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
771         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
772         // these malleable signatures as well.
773         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
774             return address(0);
775         }
776 
777         if (v != 27 && v != 28) {
778             return address(0);
779         }
780 
781         // If the signature is valid (and not malleable), return the signer address
782         return ecrecover(hash, v, r, s);
783     }
784 
785     /**
786      * toEthSignedMessageHash
787      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
788      * and hash the result
789      */
790     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
791         // 32 is the length in bytes of hash,
792         // enforced by the type signature above
793         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
794     }
795 }
796 
797 // File: openzeppelin-solidity/contracts/drafts/SignatureBouncer.sol
798 
799 pragma solidity ^0.5.2;
800 
801 
802 
803 /**
804  * @title SignatureBouncer
805  * @author PhABC, Shrugs and aflesher
806  * @dev SignatureBouncer allows users to submit a signature as a permission to
807  * do an action.
808  * If the signature is from one of the authorized signer addresses, the
809  * signature is valid.
810  * Note that SignatureBouncer offers no protection against replay attacks, users
811  * must add this themselves!
812  *
813  * Signer addresses can be individual servers signing grants or different
814  * users within a decentralized club that have permission to invite other
815  * members. This technique is useful for whitelists and airdrops; instead of
816  * putting all valid addresses on-chain, simply sign a grant of the form
817  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a
818  * valid signer address.
819  * Then restrict access to your crowdsale/whitelist/airdrop using the
820  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
821  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
822  * `onlyValidSignatureAndData` can be used to restrict access to only a given
823  * method or a given method with given parameters respectively.
824  * See the tests in SignatureBouncer.test.js for specific usage examples.
825  *
826  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make
827  * the _signature parameter the "last" parameter. You cannot sign a message that
828  * has its own signature in it so the last 128 bytes of msg.data (which
829  * represents the length of the _signature data and the _signature data itself)
830  * is ignored when validating. Also non fixed sized parameters make constructing
831  * the data in the signature much more complex.
832  * See https://ethereum.stackexchange.com/a/50616 for more details.
833  */
834 contract SignatureBouncer is SignerRole {
835     using ECDSA for bytes32;
836 
837     // Function selectors are 4 bytes long, as documented in
838     // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
839     uint256 private constant _METHOD_ID_SIZE = 4;
840     // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
841     uint256 private constant _SIGNATURE_SIZE = 96;
842 
843     constructor () internal {
844         // solhint-disable-previous-line no-empty-blocks
845     }
846 
847     /**
848      * @dev requires that a valid signature of a signer was provided
849      */
850     modifier onlyValidSignature(bytes memory signature) {
851         require(_isValidSignature(msg.sender, signature));
852         _;
853     }
854 
855     /**
856      * @dev requires that a valid signature with a specified method of a signer was provided
857      */
858     modifier onlyValidSignatureAndMethod(bytes memory signature) {
859         require(_isValidSignatureAndMethod(msg.sender, signature));
860         _;
861     }
862 
863     /**
864      * @dev requires that a valid signature with a specified method and params of a signer was provided
865      */
866     modifier onlyValidSignatureAndData(bytes memory signature) {
867         require(_isValidSignatureAndData(msg.sender, signature));
868         _;
869     }
870 
871     /**
872      * @dev is the signature of `this + account` from a signer?
873      * @return bool
874      */
875     function _isValidSignature(address account, bytes memory signature) internal view returns (bool) {
876         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account)), signature);
877     }
878 
879     /**
880      * @dev is the signature of `this + account + methodId` from a signer?
881      * @return bool
882      */
883     function _isValidSignatureAndMethod(address account, bytes memory signature) internal view returns (bool) {
884         bytes memory data = new bytes(_METHOD_ID_SIZE);
885         for (uint i = 0; i < data.length; i++) {
886             data[i] = msg.data[i];
887         }
888         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
889     }
890 
891     /**
892      * @dev is the signature of `this + account + methodId + params(s)` from a signer?
893      * @notice the signature parameter of the method being validated must be the "last" parameter
894      * @return bool
895      */
896     function _isValidSignatureAndData(address account, bytes memory signature) internal view returns (bool) {
897         require(msg.data.length > _SIGNATURE_SIZE);
898 
899         bytes memory data = new bytes(msg.data.length - _SIGNATURE_SIZE);
900         for (uint i = 0; i < data.length; i++) {
901             data[i] = msg.data[i];
902         }
903 
904         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
905     }
906 
907     /**
908      * @dev internal function to convert a hash to an eth signed message
909      * and then recover the signature and check it against the signer role
910      * @return bool
911      */
912     function _isValidDataHash(bytes32 hash, bytes memory signature) internal view returns (bool) {
913         address signer = hash.toEthSignedMessageHash().recover(signature);
914 
915         return signer != address(0) && isSigner(signer);
916     }
917 }
918 
919 // File: openzeppelin-solidity/contracts/introspection/ERC165Checker.sol
920 
921 pragma solidity ^0.5.2;
922 
923 /**
924  * @title ERC165Checker
925  * @dev Use `using ERC165Checker for address`; to include this library
926  * https://eips.ethereum.org/EIPS/eip-165
927  */
928 library ERC165Checker {
929     // As per the EIP-165 spec, no interface should ever match 0xffffffff
930     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
931 
932     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
933     /*
934      * 0x01ffc9a7 ===
935      *     bytes4(keccak256('supportsInterface(bytes4)'))
936      */
937 
938     /**
939      * @notice Query if a contract supports ERC165
940      * @param account The address of the contract to query for support of ERC165
941      * @return true if the contract at account implements ERC165
942      */
943     function _supportsERC165(address account) internal view returns (bool) {
944         // Any contract that implements ERC165 must explicitly indicate support of
945         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
946         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
947             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
948     }
949 
950     /**
951      * @notice Query if a contract implements an interface, also checks support of ERC165
952      * @param account The address of the contract to query for support of an interface
953      * @param interfaceId The interface identifier, as specified in ERC-165
954      * @return true if the contract at account indicates support of the interface with
955      * identifier interfaceId, false otherwise
956      * @dev Interface identification is specified in ERC-165.
957      */
958     function _supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
959         // query support of both ERC165 as per the spec and support of _interfaceId
960         return _supportsERC165(account) &&
961             _supportsERC165Interface(account, interfaceId);
962     }
963 
964     /**
965      * @notice Query if a contract implements interfaces, also checks support of ERC165
966      * @param account The address of the contract to query for support of an interface
967      * @param interfaceIds A list of interface identifiers, as specified in ERC-165
968      * @return true if the contract at account indicates support all interfaces in the
969      * interfaceIds list, false otherwise
970      * @dev Interface identification is specified in ERC-165.
971      */
972     function _supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
973         // query support of ERC165 itself
974         if (!_supportsERC165(account)) {
975             return false;
976         }
977 
978         // query support of each interface in _interfaceIds
979         for (uint256 i = 0; i < interfaceIds.length; i++) {
980             if (!_supportsERC165Interface(account, interfaceIds[i])) {
981                 return false;
982             }
983         }
984 
985         // all interfaces supported
986         return true;
987     }
988 
989     /**
990      * @notice Query if a contract implements an interface, does not check ERC165 support
991      * @param account The address of the contract to query for support of an interface
992      * @param interfaceId The interface identifier, as specified in ERC-165
993      * @return true if the contract at account indicates support of the interface with
994      * identifier interfaceId, false otherwise
995      * @dev Assumes that account contains a contract that supports ERC165, otherwise
996      * the behavior of this method is undefined. This precondition can be checked
997      * with the `supportsERC165` method in this library.
998      * Interface identification is specified in ERC-165.
999      */
1000     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1001         // success determines whether the staticcall succeeded and result determines
1002         // whether the contract at account indicates support of _interfaceId
1003         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1004 
1005         return (success && result);
1006     }
1007 
1008     /**
1009      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1010      * @param account The address of the contract to query for support of an interface
1011      * @param interfaceId The interface identifier, as specified in ERC-165
1012      * @return success true if the STATICCALL succeeded, false otherwise
1013      * @return result true if the STATICCALL succeeded and the contract at account
1014      * indicates support of the interface with identifier interfaceId, false otherwise
1015      */
1016     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1017         private
1018         view
1019         returns (bool success, bool result)
1020     {
1021         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1022 
1023         // solhint-disable-next-line no-inline-assembly
1024         assembly {
1025             let encodedParams_data := add(0x20, encodedParams)
1026             let encodedParams_size := mload(encodedParams)
1027 
1028             let output := mload(0x40)    // Find empty storage location using "free memory pointer"
1029             mstore(output, 0x0)
1030 
1031             success := staticcall(
1032                 30000,                   // 30k gas
1033                 account,                 // To addr
1034                 encodedParams_data,
1035                 encodedParams_size,
1036                 output,
1037                 0x20                     // Outputs are 32 bytes long
1038             )
1039 
1040             result := mload(output)      // Load the result
1041         }
1042     }
1043 }
1044 
1045 // File: contracts/TorocusToken.sol
1046 
1047 pragma solidity ^0.5.2;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 
1058 
1059 contract TorocusToken is  ERC20Detailed, ERC20Mintable, ERC20Burnable, ERC20Pausable, SignatureBouncer {
1060     using SafeMath for uint256;
1061     mapping (address => mapping (uint256 => bool)) public _usedNonce;
1062 
1063     constructor(
1064         string memory name,
1065         string memory symbol,
1066         uint8 decimals,
1067         uint256 initialSupply,
1068         address initialHolder,
1069         address minter,
1070         address signer,
1071         address pauser
1072     )
1073         ERC20Detailed(name, symbol, decimals)
1074         SignatureBouncer()
1075         ERC20Mintable()
1076         ERC20Pausable()
1077         public
1078     {
1079         _mint(initialHolder, initialSupply);
1080         _addMinter(minter);
1081         _addPauser(pauser);
1082         _addSigner(signer);
1083     }
1084 
1085     modifier isNotUsedNonce(address from, uint256 nonce) {
1086         require(!_usedNonce[from][nonce]);
1087         _;
1088     }
1089 
1090     function transferDelegatedWithSign(
1091         address from,
1092         address to,
1093         uint256 amount,
1094         uint256 fee,
1095         uint256 nonce,
1096         string memory message,
1097         bytes memory signature
1098     ) public
1099         whenNotPaused
1100         isNotUsedNonce(msg.sender, nonce)
1101         onlyValidSignatureAndData(signature)
1102         returns (bool success)
1103     {
1104         require(from != address(0));
1105         require(to != address(0));
1106         require(from != to);
1107         require(msg.sender != to);
1108         require(msg.sender != from);
1109         require(balanceOf(from) >= amount.add(fee), "not enough balance");
1110 
1111         if(fee > 0) {
1112             _transfer(from, msg.sender, fee);
1113         }
1114         _transfer(from, to, amount);
1115 
1116         _usedNonce[msg.sender][nonce] = true;
1117         return true;
1118     }
1119 }