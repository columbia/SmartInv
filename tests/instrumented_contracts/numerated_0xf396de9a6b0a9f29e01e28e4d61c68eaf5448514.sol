1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
12     }
13 
14     /**
15      * @dev give an account access to this role
16      */
17     function add(Role storage role, address account) internal {
18         require(account != address(0));
19         require(!has(role, account));
20 
21         role.bearer[account] = true;
22     }
23 
24     /**
25      * @dev remove an account's access to this role
26      */
27     function remove(Role storage role, address account) internal {
28         require(account != address(0));
29         require(has(role, account));
30 
31         role.bearer[account] = false;
32     }
33 
34     /**
35      * @dev check if an account has this role
36      * @return bool
37      */
38     function has(Role storage role, address account) internal view returns (bool) {
39         require(account != address(0));
40         return role.bearer[account];
41     }
42 }
43 
44 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
45 
46 pragma solidity ^0.5.0;
47 
48 
49 contract SignerRole {
50     using Roles for Roles.Role;
51 
52     event SignerAdded(address indexed account);
53     event SignerRemoved(address indexed account);
54 
55     Roles.Role private _signers;
56 
57     constructor () internal {
58         _addSigner(msg.sender);
59     }
60 
61     modifier onlySigner() {
62         require(isSigner(msg.sender));
63         _;
64     }
65 
66     function isSigner(address account) public view returns (bool) {
67         return _signers.has(account);
68     }
69 
70     function addSigner(address account) public onlySigner {
71         _addSigner(account);
72     }
73 
74     function renounceSigner() public {
75         _removeSigner(msg.sender);
76     }
77 
78     function _addSigner(address account) internal {
79         _signers.add(account);
80         emit SignerAdded(account);
81     }
82 
83     function _removeSigner(address account) internal {
84         _signers.remove(account);
85         emit SignerRemoved(account);
86     }
87 }
88 
89 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * @title Elliptic curve signature operations
95  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
96  * TODO Remove this library once solidity supports passing a signature to ecrecover.
97  * See https://github.com/ethereum/solidity/issues/864
98  */
99 
100 library ECDSA {
101     /**
102      * @dev Recover signer address from a message by using their signature
103      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
104      * @param signature bytes signature, the signature is generated using web3.eth.sign()
105      */
106     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
107         bytes32 r;
108         bytes32 s;
109         uint8 v;
110 
111         // Check the signature length
112         if (signature.length != 65) {
113             return (address(0));
114         }
115 
116         // Divide the signature in r, s and v variables
117         // ecrecover takes the signature parameters, and the only way to get them
118         // currently is to use assembly.
119         // solhint-disable-next-line no-inline-assembly
120         assembly {
121             r := mload(add(signature, 0x20))
122             s := mload(add(signature, 0x40))
123             v := byte(0, mload(add(signature, 0x60)))
124         }
125 
126         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
127         if (v < 27) {
128             v += 27;
129         }
130 
131         // If the version is correct return the signer address
132         if (v != 27 && v != 28) {
133             return (address(0));
134         } else {
135             return ecrecover(hash, v, r, s);
136         }
137     }
138 
139     /**
140      * toEthSignedMessageHash
141      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
142      * and hash the result
143      */
144     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
145         // 32 is the length in bytes of hash,
146         // enforced by the type signature above
147         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
148     }
149 }
150 
151 // File: openzeppelin-solidity/contracts/drafts/SignatureBouncer.sol
152 
153 pragma solidity ^0.5.0;
154 
155 
156 
157 /**
158  * @title SignatureBouncer
159  * @author PhABC, Shrugs and aflesher
160  * @dev SignatureBouncer allows users to submit a signature as a permission to
161  * do an action.
162  * If the signature is from one of the authorized signer addresses, the
163  * signature is valid.
164  * Note that SignatureBouncer offers no protection against replay attacks, users
165  * must add this themselves!
166  *
167  * Signer addresses can be individual servers signing grants or different
168  * users within a decentralized club that have permission to invite other
169  * members. This technique is useful for whitelists and airdrops; instead of
170  * putting all valid addresses on-chain, simply sign a grant of the form
171  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a
172  * valid signer address.
173  * Then restrict access to your crowdsale/whitelist/airdrop using the
174  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
175  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
176  * `onlyValidSignatureAndData` can be used to restrict access to only a given
177  * method or a given method with given parameters respectively.
178  * See the tests in SignatureBouncer.test.js for specific usage examples.
179  *
180  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make
181  * the _signature parameter the "last" parameter. You cannot sign a message that
182  * has its own signature in it so the last 128 bytes of msg.data (which
183  * represents the length of the _signature data and the _signaature data itself)
184  * is ignored when validating. Also non fixed sized parameters make constructing
185  * the data in the signature much more complex.
186  * See https://ethereum.stackexchange.com/a/50616 for more details.
187  */
188 contract SignatureBouncer is SignerRole {
189     using ECDSA for bytes32;
190 
191     // Function selectors are 4 bytes long, as documented in
192     // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
193     uint256 private constant _METHOD_ID_SIZE = 4;
194     // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
195     uint256 private constant _SIGNATURE_SIZE = 96;
196 
197     constructor () internal {
198         // solhint-disable-previous-line no-empty-blocks
199     }
200 
201     /**
202      * @dev requires that a valid signature of a signer was provided
203      */
204     modifier onlyValidSignature(bytes memory signature) {
205         require(_isValidSignature(msg.sender, signature));
206         _;
207     }
208 
209     /**
210      * @dev requires that a valid signature with a specifed method of a signer was provided
211      */
212     modifier onlyValidSignatureAndMethod(bytes memory signature) {
213         require(_isValidSignatureAndMethod(msg.sender, signature));
214         _;
215     }
216 
217     /**
218      * @dev requires that a valid signature with a specifed method and params of a signer was provided
219      */
220     modifier onlyValidSignatureAndData(bytes memory signature) {
221         require(_isValidSignatureAndData(msg.sender, signature));
222         _;
223     }
224 
225     /**
226      * @dev is the signature of `this + sender` from a signer?
227      * @return bool
228      */
229     function _isValidSignature(address account, bytes memory signature) internal view returns (bool) {
230         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account)), signature);
231     }
232 
233     /**
234      * @dev is the signature of `this + sender + methodId` from a signer?
235      * @return bool
236      */
237     function _isValidSignatureAndMethod(address account, bytes memory signature) internal view returns (bool) {
238         bytes memory data = new bytes(_METHOD_ID_SIZE);
239         for (uint i = 0; i < data.length; i++) {
240             data[i] = msg.data[i];
241         }
242         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
243     }
244 
245     /**
246         * @dev is the signature of `this + sender + methodId + params(s)` from a signer?
247         * @notice the signature parameter of the method being validated must be the "last" parameter
248         * @return bool
249         */
250     function _isValidSignatureAndData(address account, bytes memory signature) internal view returns (bool) {
251         require(msg.data.length > _SIGNATURE_SIZE);
252 
253         bytes memory data = new bytes(msg.data.length - _SIGNATURE_SIZE);
254         for (uint i = 0; i < data.length; i++) {
255             data[i] = msg.data[i];
256         }
257 
258         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
259     }
260 
261     /**
262      * @dev internal function to convert a hash to an eth signed message
263      * and then recover the signature and check it against the signer role
264      * @return bool
265      */
266     function _isValidDataHash(bytes32 hash, bytes memory signature) internal view returns (bool) {
267         address signer = hash.toEthSignedMessageHash().recover(signature);
268 
269         return signer != address(0) && isSigner(signer);
270     }
271 }
272 
273 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
274 
275 pragma solidity ^0.5.0;
276 
277 /**
278  * @title ERC20 interface
279  * @dev see https://github.com/ethereum/EIPs/issues/20
280  */
281 interface IERC20 {
282     function transfer(address to, uint256 value) external returns (bool);
283 
284     function approve(address spender, uint256 value) external returns (bool);
285 
286     function transferFrom(address from, address to, uint256 value) external returns (bool);
287 
288     function totalSupply() external view returns (uint256);
289 
290     function balanceOf(address who) external view returns (uint256);
291 
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     event Transfer(address indexed from, address indexed to, uint256 value);
295 
296     event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
300 
301 pragma solidity ^0.5.0;
302 
303 /**
304  * @title SafeMath
305  * @dev Unsigned math operations with safety checks that revert on error
306  */
307 library SafeMath {
308     /**
309     * @dev Multiplies two unsigned integers, reverts on overflow.
310     */
311     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
312         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
313         // benefit is lost if 'b' is also tested.
314         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
315         if (a == 0) {
316             return 0;
317         }
318 
319         uint256 c = a * b;
320         require(c / a == b);
321 
322         return c;
323     }
324 
325     /**
326     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
327     */
328     function div(uint256 a, uint256 b) internal pure returns (uint256) {
329         // Solidity only automatically asserts when dividing by 0
330         require(b > 0);
331         uint256 c = a / b;
332         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
333 
334         return c;
335     }
336 
337     /**
338     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
339     */
340     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
341         require(b <= a);
342         uint256 c = a - b;
343 
344         return c;
345     }
346 
347     /**
348     * @dev Adds two unsigned integers, reverts on overflow.
349     */
350     function add(uint256 a, uint256 b) internal pure returns (uint256) {
351         uint256 c = a + b;
352         require(c >= a);
353 
354         return c;
355     }
356 
357     /**
358     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
359     * reverts when dividing by zero.
360     */
361     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
362         require(b != 0);
363         return a % b;
364     }
365 }
366 
367 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
368 
369 pragma solidity ^0.5.0;
370 
371 
372 
373 /**
374  * @title Standard ERC20 token
375  *
376  * @dev Implementation of the basic standard token.
377  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
378  * Originally based on code by FirstBlood:
379  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
380  *
381  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
382  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
383  * compliant implementations may not do it.
384  */
385 contract ERC20 is IERC20 {
386     using SafeMath for uint256;
387 
388     mapping (address => uint256) private _balances;
389 
390     mapping (address => mapping (address => uint256)) private _allowed;
391 
392     uint256 private _totalSupply;
393 
394     /**
395     * @dev Total number of tokens in existence
396     */
397     function totalSupply() public view returns (uint256) {
398         return _totalSupply;
399     }
400 
401     /**
402     * @dev Gets the balance of the specified address.
403     * @param owner The address to query the balance of.
404     * @return An uint256 representing the amount owned by the passed address.
405     */
406     function balanceOf(address owner) public view returns (uint256) {
407         return _balances[owner];
408     }
409 
410     /**
411      * @dev Function to check the amount of tokens that an owner allowed to a spender.
412      * @param owner address The address which owns the funds.
413      * @param spender address The address which will spend the funds.
414      * @return A uint256 specifying the amount of tokens still available for the spender.
415      */
416     function allowance(address owner, address spender) public view returns (uint256) {
417         return _allowed[owner][spender];
418     }
419 
420     /**
421     * @dev Transfer token for a specified address
422     * @param to The address to transfer to.
423     * @param value The amount to be transferred.
424     */
425     function transfer(address to, uint256 value) public returns (bool) {
426         _transfer(msg.sender, to, value);
427         return true;
428     }
429 
430     /**
431      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
432      * Beware that changing an allowance with this method brings the risk that someone may use both the old
433      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
434      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
435      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
436      * @param spender The address which will spend the funds.
437      * @param value The amount of tokens to be spent.
438      */
439     function approve(address spender, uint256 value) public returns (bool) {
440         require(spender != address(0));
441 
442         _allowed[msg.sender][spender] = value;
443         emit Approval(msg.sender, spender, value);
444         return true;
445     }
446 
447     /**
448      * @dev Transfer tokens from one address to another.
449      * Note that while this function emits an Approval event, this is not required as per the specification,
450      * and other compliant implementations may not emit the event.
451      * @param from address The address which you want to send tokens from
452      * @param to address The address which you want to transfer to
453      * @param value uint256 the amount of tokens to be transferred
454      */
455     function transferFrom(address from, address to, uint256 value) public returns (bool) {
456         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
457         _transfer(from, to, value);
458         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
459         return true;
460     }
461 
462     /**
463      * @dev Increase the amount of tokens that an owner allowed to a spender.
464      * approve should be called when allowed_[_spender] == 0. To increment
465      * allowed value is better to use this function to avoid 2 calls (and wait until
466      * the first transaction is mined)
467      * From MonolithDAO Token.sol
468      * Emits an Approval event.
469      * @param spender The address which will spend the funds.
470      * @param addedValue The amount of tokens to increase the allowance by.
471      */
472     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
473         require(spender != address(0));
474 
475         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
476         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
477         return true;
478     }
479 
480     /**
481      * @dev Decrease the amount of tokens that an owner allowed to a spender.
482      * approve should be called when allowed_[_spender] == 0. To decrement
483      * allowed value is better to use this function to avoid 2 calls (and wait until
484      * the first transaction is mined)
485      * From MonolithDAO Token.sol
486      * Emits an Approval event.
487      * @param spender The address which will spend the funds.
488      * @param subtractedValue The amount of tokens to decrease the allowance by.
489      */
490     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
491         require(spender != address(0));
492 
493         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
494         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
495         return true;
496     }
497 
498     /**
499     * @dev Transfer token for a specified addresses
500     * @param from The address to transfer from.
501     * @param to The address to transfer to.
502     * @param value The amount to be transferred.
503     */
504     function _transfer(address from, address to, uint256 value) internal {
505         require(to != address(0));
506 
507         _balances[from] = _balances[from].sub(value);
508         _balances[to] = _balances[to].add(value);
509         emit Transfer(from, to, value);
510     }
511 
512     /**
513      * @dev Internal function that mints an amount of the token and assigns it to
514      * an account. This encapsulates the modification of balances such that the
515      * proper events are emitted.
516      * @param account The account that will receive the created tokens.
517      * @param value The amount that will be created.
518      */
519     function _mint(address account, uint256 value) internal {
520         require(account != address(0));
521 
522         _totalSupply = _totalSupply.add(value);
523         _balances[account] = _balances[account].add(value);
524         emit Transfer(address(0), account, value);
525     }
526 
527     /**
528      * @dev Internal function that burns an amount of the token of a given
529      * account.
530      * @param account The account whose tokens will be burnt.
531      * @param value The amount that will be burnt.
532      */
533     function _burn(address account, uint256 value) internal {
534         require(account != address(0));
535 
536         _totalSupply = _totalSupply.sub(value);
537         _balances[account] = _balances[account].sub(value);
538         emit Transfer(account, address(0), value);
539     }
540 
541     /**
542      * @dev Internal function that burns an amount of the token of a given
543      * account, deducting from the sender's allowance for said account. Uses the
544      * internal burn function.
545      * Emits an Approval event (reflecting the reduced allowance).
546      * @param account The account whose tokens will be burnt.
547      * @param value The amount that will be burnt.
548      */
549     function _burnFrom(address account, uint256 value) internal {
550         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
551         _burn(account, value);
552         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
553     }
554 }
555 
556 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
557 
558 pragma solidity ^0.5.0;
559 
560 
561 /**
562  * @title Burnable Token
563  * @dev Token that can be irreversibly burned (destroyed).
564  */
565 contract ERC20Burnable is ERC20 {
566     /**
567      * @dev Burns a specific amount of tokens.
568      * @param value The amount of token to be burned.
569      */
570     function burn(uint256 value) public {
571         _burn(msg.sender, value);
572     }
573 
574     /**
575      * @dev Burns a specific amount of tokens from the target address and decrements allowance
576      * @param from address The address which you want to send tokens from
577      * @param value uint256 The amount of token to be burned
578      */
579     function burnFrom(address from, uint256 value) public {
580         _burnFrom(from, value);
581     }
582 }
583 
584 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
585 
586 pragma solidity ^0.5.0;
587 
588 
589 
590 /**
591  * @title SafeERC20
592  * @dev Wrappers around ERC20 operations that throw on failure.
593  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
594  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
595  */
596 library SafeERC20 {
597     using SafeMath for uint256;
598 
599     function safeTransfer(IERC20 token, address to, uint256 value) internal {
600         require(token.transfer(to, value));
601     }
602 
603     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
604         require(token.transferFrom(from, to, value));
605     }
606 
607     function safeApprove(IERC20 token, address spender, uint256 value) internal {
608         // safeApprove should only be called when setting an initial allowance,
609         // or when resetting it to zero. To increase and decrease it, use
610         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
611         require((value == 0) || (token.allowance(address(this), spender) == 0));
612         require(token.approve(spender, value));
613     }
614 
615     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
616         uint256 newAllowance = token.allowance(address(this), spender).add(value);
617         require(token.approve(spender, newAllowance));
618     }
619 
620     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
622         require(token.approve(spender, newAllowance));
623     }
624 }
625 
626 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
627 
628 pragma solidity ^0.5.0;
629 
630 /**
631  * @title Ownable
632  * @dev The Ownable contract has an owner address, and provides basic authorization control
633  * functions, this simplifies the implementation of "user permissions".
634  */
635 contract Ownable {
636     address private _owner;
637 
638     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
639 
640     /**
641      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
642      * account.
643      */
644     constructor () internal {
645         _owner = msg.sender;
646         emit OwnershipTransferred(address(0), _owner);
647     }
648 
649     /**
650      * @return the address of the owner.
651      */
652     function owner() public view returns (address) {
653         return _owner;
654     }
655 
656     /**
657      * @dev Throws if called by any account other than the owner.
658      */
659     modifier onlyOwner() {
660         require(isOwner());
661         _;
662     }
663 
664     /**
665      * @return true if `msg.sender` is the owner of the contract.
666      */
667     function isOwner() public view returns (bool) {
668         return msg.sender == _owner;
669     }
670 
671     /**
672      * @dev Allows the current owner to relinquish control of the contract.
673      * @notice Renouncing to ownership will leave the contract without an owner.
674      * It will not be possible to call the functions with the `onlyOwner`
675      * modifier anymore.
676      */
677     function renounceOwnership() public onlyOwner {
678         emit OwnershipTransferred(_owner, address(0));
679         _owner = address(0);
680     }
681 
682     /**
683      * @dev Allows the current owner to transfer control of the contract to a newOwner.
684      * @param newOwner The address to transfer ownership to.
685      */
686     function transferOwnership(address newOwner) public onlyOwner {
687         _transferOwnership(newOwner);
688     }
689 
690     /**
691      * @dev Transfers control of the contract to a newOwner.
692      * @param newOwner The address to transfer ownership to.
693      */
694     function _transferOwnership(address newOwner) internal {
695         require(newOwner != address(0));
696         emit OwnershipTransferred(_owner, newOwner);
697         _owner = newOwner;
698     }
699 }
700 
701 // File: contracts/misc/DutchAuction.sol
702 
703 pragma solidity ^0.5.0;
704 
705 
706 
707 
708 
709 
710 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
711 /// @author Stefan George - <stefan.george@consensys.net>
712 /// @author Airalab - <research@aira.life> 
713 contract DutchAuction is SignatureBouncer, Ownable {
714     using SafeERC20 for ERC20Burnable;
715 
716     /*
717      *  Events
718      */
719     event BidSubmission(address indexed sender, uint256 amount);
720 
721     /*
722      *  Constants
723      */
724     uint constant public WAITING_PERIOD = 0; // 1 days;
725 
726     /*
727      *  Storage
728      */
729     ERC20Burnable public token;
730     address public ambix;
731     address payable public wallet;
732     uint public maxTokenSold;
733     uint public ceiling;
734     uint public priceFactor;
735     uint public startBlock;
736     uint public endTime;
737     uint public totalReceived;
738     uint public finalPrice;
739     mapping (address => uint) public bids;
740     Stages public stage;
741 
742     /*
743      *  Enums
744      */
745     enum Stages {
746         AuctionDeployed,
747         AuctionSetUp,
748         AuctionStarted,
749         AuctionEnded,
750         TradingStarted
751     }
752 
753     /*
754      *  Modifiers
755      */
756     modifier atStage(Stages _stage) {
757         // Contract on stage
758         require(stage == _stage);
759         _;
760     }
761 
762     modifier isValidPayload() {
763         require(msg.data.length == 4 || msg.data.length == 164);
764         _;
765     }
766 
767     modifier timedTransitions() {
768         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
769             finalizeAuction();
770         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
771             stage = Stages.TradingStarted;
772         _;
773     }
774 
775     /*
776      *  Public functions
777      */
778     /// @dev Contract constructor function sets owner.
779     /// @param _wallet Multisig wallet.
780     /// @param _maxTokenSold Auction token balance.
781     /// @param _ceiling Auction ceiling.
782     /// @param _priceFactor Auction price factor.
783     constructor(address payable _wallet, uint _maxTokenSold, uint _ceiling, uint _priceFactor)
784         public
785     {
786         require(_wallet != address(0) && _ceiling > 0 && _priceFactor > 0);
787 
788         wallet = _wallet;
789         maxTokenSold = _maxTokenSold;
790         ceiling = _ceiling;
791         priceFactor = _priceFactor;
792         stage = Stages.AuctionDeployed;
793     }
794 
795     /// @dev Setup function sets external contracts' addresses.
796     /// @param _token Token address.
797     /// @param _ambix Distillation cube address.
798     function setup(ERC20Burnable _token, address _ambix)
799         public
800         onlyOwner
801         atStage(Stages.AuctionDeployed)
802     {
803         // Validate argument
804         require(_token != ERC20Burnable(0) && _ambix != address(0));
805 
806         token = _token;
807         ambix = _ambix;
808 
809         // Validate token balance
810         require(token.balanceOf(address(this)) == maxTokenSold);
811 
812         stage = Stages.AuctionSetUp;
813     }
814 
815     /// @dev Starts auction and sets startBlock.
816     function startAuction()
817         public
818         onlyOwner
819         atStage(Stages.AuctionSetUp)
820     {
821         stage = Stages.AuctionStarted;
822         startBlock = block.number;
823     }
824 
825     /// @dev Calculates current token price.
826     /// @return Returns token price.
827     function calcCurrentTokenPrice()
828         public
829         timedTransitions
830         returns (uint)
831     {
832         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
833             return finalPrice;
834         return calcTokenPrice();
835     }
836 
837     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
838     /// @return Returns current auction stage.
839     function updateStage()
840         public
841         timedTransitions
842         returns (Stages)
843     {
844         return stage;
845     }
846 
847     /// @dev Allows to send a bid to the auction.
848     /// @param signature KYC approvement
849     function bid(bytes calldata signature)
850         external
851         payable
852         isValidPayload
853         timedTransitions
854         atStage(Stages.AuctionStarted)
855         onlyValidSignature(signature)
856         returns (uint amount)
857     {
858         require(msg.value > 0);
859         amount = msg.value;
860 
861         address payable receiver = msg.sender;
862 
863         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
864         uint maxWei = maxTokenSold * calcTokenPrice() / 10**9 - totalReceived;
865         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
866         if (maxWeiBasedOnTotalReceived < maxWei)
867             maxWei = maxWeiBasedOnTotalReceived;
868 
869         // Only invest maximum possible amount.
870         if (amount > maxWei) {
871             amount = maxWei;
872             // Send change back to receiver address.
873             receiver.transfer(msg.value - amount);
874         }
875 
876         // Forward funding to ether wallet
877         (bool success,) = wallet.call.value(amount)("");
878         require(success);
879 
880         bids[receiver] += amount;
881         totalReceived += amount;
882         emit BidSubmission(receiver, amount);
883 
884         // Finalize auction when maxWei reached
885         if (amount == maxWei)
886             finalizeAuction();
887     }
888 
889     /// @dev Claims tokens for bidder after auction.
890     function claimTokens()
891         public
892         isValidPayload
893         timedTransitions
894         atStage(Stages.TradingStarted)
895     {
896         address receiver = msg.sender;
897         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
898         bids[receiver] = 0;
899         token.safeTransfer(receiver, tokenCount);
900     }
901 
902     /// @dev Calculates stop price.
903     /// @return Returns stop price.
904     function calcStopPrice()
905         view
906         public
907         returns (uint)
908     {
909         return totalReceived * 10**9 / maxTokenSold + 1;
910     }
911 
912     /// @dev Calculates token price.
913     /// @return Returns token price.
914     function calcTokenPrice()
915         view
916         public
917         returns (uint)
918     {
919         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
920     }
921 
922     /*
923      *  Private functions
924      */
925     function finalizeAuction()
926         private
927     {
928         stage = Stages.AuctionEnded;
929         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
930         uint soldTokens = totalReceived * 10**9 / finalPrice;
931 
932         if (totalReceived == ceiling) {
933             // Auction contract transfers all unsold tokens to Ambix contract
934             token.safeTransfer(ambix, maxTokenSold - soldTokens);
935         } else {
936             // Auction contract burn all unsold tokens
937             token.burn(maxTokenSold - soldTokens);
938         }
939 
940         endTime = now;
941     }
942 }