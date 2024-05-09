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
95 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title SafeERC20
103  * @dev Wrappers around ERC20 operations that throw on failure.
104  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
105  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
106  */
107 library SafeERC20 {
108     using SafeMath for uint256;
109 
110     function safeTransfer(IERC20 token, address to, uint256 value) internal {
111         require(token.transfer(to, value));
112     }
113 
114     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
115         require(token.transferFrom(from, to, value));
116     }
117 
118     function safeApprove(IERC20 token, address spender, uint256 value) internal {
119         // safeApprove should only be called when setting an initial allowance,
120         // or when resetting it to zero. To increase and decrease it, use
121         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
122         require((value == 0) || (token.allowance(address(this), spender) == 0));
123         require(token.approve(spender, value));
124     }
125 
126     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
127         uint256 newAllowance = token.allowance(address(this), spender).add(value);
128         require(token.approve(spender, newAllowance));
129     }
130 
131     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
132         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
133         require(token.approve(spender, newAllowance));
134     }
135 }
136 
137 // File: contracts/ens/AbstractENS.sol
138 
139 pragma solidity ^0.5.0;
140 
141 contract AbstractENS {
142     function owner(bytes32 _node) public view returns(address);
143     function resolver(bytes32 _node) public view returns(address);
144     function ttl(bytes32 _node) public view returns(uint64);
145     function setOwner(bytes32 _node, address _owner) public;
146     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
147     function setResolver(bytes32 _node, address _resolver) public;
148     function setTTL(bytes32 _node, uint64 _ttl) public;
149 
150     // Logged when the owner of a node assigns a new owner to a subnode.
151     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
152 
153     // Logged when the owner of a node transfers ownership to a new account.
154     event Transfer(bytes32 indexed node, address owner);
155 
156     // Logged when the resolver for a node changes.
157     event NewResolver(bytes32 indexed node, address resolver);
158 
159     // Logged when the TTL of a node changes
160     event NewTTL(bytes32 indexed node, uint64 ttl);
161 }
162 
163 // File: contracts/ens/AbstractResolver.sol
164 
165 pragma solidity ^0.5.0;
166 
167 contract AbstractResolver {
168     function supportsInterface(bytes4 _interfaceID) public view returns (bool);
169     function addr(bytes32 _node) public view returns (address ret);
170     function setAddr(bytes32 _node, address _addr) public;
171     function hash(bytes32 _node) public view returns (bytes32 ret);
172     function setHash(bytes32 _node, bytes32 _hash) public;
173 }
174 
175 // File: contracts/misc/SingletonHash.sol
176 
177 pragma solidity ^0.5.0;
178 
179 contract SingletonHash {
180     event HashConsumed(bytes32 indexed hash);
181 
182     /**
183      * @dev Used hash accounting
184      */
185     mapping(bytes32 => bool) public isHashConsumed;
186 
187     /**
188      * @dev Parameter can be used only once
189      * @param _hash Single usage hash
190      */
191     function singletonHash(bytes32 _hash) internal {
192         require(!isHashConsumed[_hash]);
193         isHashConsumed[_hash] = true;
194         emit HashConsumed(_hash);
195     }
196 }
197 
198 // File: openzeppelin-solidity/contracts/access/Roles.sol
199 
200 pragma solidity ^0.5.0;
201 
202 /**
203  * @title Roles
204  * @dev Library for managing addresses assigned to a Role.
205  */
206 library Roles {
207     struct Role {
208         mapping (address => bool) bearer;
209     }
210 
211     /**
212      * @dev give an account access to this role
213      */
214     function add(Role storage role, address account) internal {
215         require(account != address(0));
216         require(!has(role, account));
217 
218         role.bearer[account] = true;
219     }
220 
221     /**
222      * @dev remove an account's access to this role
223      */
224     function remove(Role storage role, address account) internal {
225         require(account != address(0));
226         require(has(role, account));
227 
228         role.bearer[account] = false;
229     }
230 
231     /**
232      * @dev check if an account has this role
233      * @return bool
234      */
235     function has(Role storage role, address account) internal view returns (bool) {
236         require(account != address(0));
237         return role.bearer[account];
238     }
239 }
240 
241 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
242 
243 pragma solidity ^0.5.0;
244 
245 
246 contract SignerRole {
247     using Roles for Roles.Role;
248 
249     event SignerAdded(address indexed account);
250     event SignerRemoved(address indexed account);
251 
252     Roles.Role private _signers;
253 
254     constructor () internal {
255         _addSigner(msg.sender);
256     }
257 
258     modifier onlySigner() {
259         require(isSigner(msg.sender));
260         _;
261     }
262 
263     function isSigner(address account) public view returns (bool) {
264         return _signers.has(account);
265     }
266 
267     function addSigner(address account) public onlySigner {
268         _addSigner(account);
269     }
270 
271     function renounceSigner() public {
272         _removeSigner(msg.sender);
273     }
274 
275     function _addSigner(address account) internal {
276         _signers.add(account);
277         emit SignerAdded(account);
278     }
279 
280     function _removeSigner(address account) internal {
281         _signers.remove(account);
282         emit SignerRemoved(account);
283     }
284 }
285 
286 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
287 
288 pragma solidity ^0.5.0;
289 
290 /**
291  * @title Elliptic curve signature operations
292  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
293  * TODO Remove this library once solidity supports passing a signature to ecrecover.
294  * See https://github.com/ethereum/solidity/issues/864
295  */
296 
297 library ECDSA {
298     /**
299      * @dev Recover signer address from a message by using their signature
300      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
301      * @param signature bytes signature, the signature is generated using web3.eth.sign()
302      */
303     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
304         bytes32 r;
305         bytes32 s;
306         uint8 v;
307 
308         // Check the signature length
309         if (signature.length != 65) {
310             return (address(0));
311         }
312 
313         // Divide the signature in r, s and v variables
314         // ecrecover takes the signature parameters, and the only way to get them
315         // currently is to use assembly.
316         // solhint-disable-next-line no-inline-assembly
317         assembly {
318             r := mload(add(signature, 0x20))
319             s := mload(add(signature, 0x40))
320             v := byte(0, mload(add(signature, 0x60)))
321         }
322 
323         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
324         if (v < 27) {
325             v += 27;
326         }
327 
328         // If the version is correct return the signer address
329         if (v != 27 && v != 28) {
330             return (address(0));
331         } else {
332             return ecrecover(hash, v, r, s);
333         }
334     }
335 
336     /**
337      * toEthSignedMessageHash
338      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
339      * and hash the result
340      */
341     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
342         // 32 is the length in bytes of hash,
343         // enforced by the type signature above
344         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
345     }
346 }
347 
348 // File: openzeppelin-solidity/contracts/drafts/SignatureBouncer.sol
349 
350 pragma solidity ^0.5.0;
351 
352 
353 
354 /**
355  * @title SignatureBouncer
356  * @author PhABC, Shrugs and aflesher
357  * @dev SignatureBouncer allows users to submit a signature as a permission to
358  * do an action.
359  * If the signature is from one of the authorized signer addresses, the
360  * signature is valid.
361  * Note that SignatureBouncer offers no protection against replay attacks, users
362  * must add this themselves!
363  *
364  * Signer addresses can be individual servers signing grants or different
365  * users within a decentralized club that have permission to invite other
366  * members. This technique is useful for whitelists and airdrops; instead of
367  * putting all valid addresses on-chain, simply sign a grant of the form
368  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a
369  * valid signer address.
370  * Then restrict access to your crowdsale/whitelist/airdrop using the
371  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
372  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
373  * `onlyValidSignatureAndData` can be used to restrict access to only a given
374  * method or a given method with given parameters respectively.
375  * See the tests in SignatureBouncer.test.js for specific usage examples.
376  *
377  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make
378  * the _signature parameter the "last" parameter. You cannot sign a message that
379  * has its own signature in it so the last 128 bytes of msg.data (which
380  * represents the length of the _signature data and the _signaature data itself)
381  * is ignored when validating. Also non fixed sized parameters make constructing
382  * the data in the signature much more complex.
383  * See https://ethereum.stackexchange.com/a/50616 for more details.
384  */
385 contract SignatureBouncer is SignerRole {
386     using ECDSA for bytes32;
387 
388     // Function selectors are 4 bytes long, as documented in
389     // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
390     uint256 private constant _METHOD_ID_SIZE = 4;
391     // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
392     uint256 private constant _SIGNATURE_SIZE = 96;
393 
394     constructor () internal {
395         // solhint-disable-previous-line no-empty-blocks
396     }
397 
398     /**
399      * @dev requires that a valid signature of a signer was provided
400      */
401     modifier onlyValidSignature(bytes memory signature) {
402         require(_isValidSignature(msg.sender, signature));
403         _;
404     }
405 
406     /**
407      * @dev requires that a valid signature with a specifed method of a signer was provided
408      */
409     modifier onlyValidSignatureAndMethod(bytes memory signature) {
410         require(_isValidSignatureAndMethod(msg.sender, signature));
411         _;
412     }
413 
414     /**
415      * @dev requires that a valid signature with a specifed method and params of a signer was provided
416      */
417     modifier onlyValidSignatureAndData(bytes memory signature) {
418         require(_isValidSignatureAndData(msg.sender, signature));
419         _;
420     }
421 
422     /**
423      * @dev is the signature of `this + sender` from a signer?
424      * @return bool
425      */
426     function _isValidSignature(address account, bytes memory signature) internal view returns (bool) {
427         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account)), signature);
428     }
429 
430     /**
431      * @dev is the signature of `this + sender + methodId` from a signer?
432      * @return bool
433      */
434     function _isValidSignatureAndMethod(address account, bytes memory signature) internal view returns (bool) {
435         bytes memory data = new bytes(_METHOD_ID_SIZE);
436         for (uint i = 0; i < data.length; i++) {
437             data[i] = msg.data[i];
438         }
439         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
440     }
441 
442     /**
443         * @dev is the signature of `this + sender + methodId + params(s)` from a signer?
444         * @notice the signature parameter of the method being validated must be the "last" parameter
445         * @return bool
446         */
447     function _isValidSignatureAndData(address account, bytes memory signature) internal view returns (bool) {
448         require(msg.data.length > _SIGNATURE_SIZE);
449 
450         bytes memory data = new bytes(msg.data.length - _SIGNATURE_SIZE);
451         for (uint i = 0; i < data.length; i++) {
452             data[i] = msg.data[i];
453         }
454 
455         return _isValidDataHash(keccak256(abi.encodePacked(address(this), account, data)), signature);
456     }
457 
458     /**
459      * @dev internal function to convert a hash to an eth signed message
460      * and then recover the signature and check it against the signer role
461      * @return bool
462      */
463     function _isValidDataHash(bytes32 hash, bytes memory signature) internal view returns (bool) {
464         address signer = hash.toEthSignedMessageHash().recover(signature);
465 
466         return signer != address(0) && isSigner(signer);
467     }
468 }
469 
470 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
471 
472 pragma solidity ^0.5.0;
473 
474 
475 
476 /**
477  * @title Standard ERC20 token
478  *
479  * @dev Implementation of the basic standard token.
480  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
481  * Originally based on code by FirstBlood:
482  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
483  *
484  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
485  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
486  * compliant implementations may not do it.
487  */
488 contract ERC20 is IERC20 {
489     using SafeMath for uint256;
490 
491     mapping (address => uint256) private _balances;
492 
493     mapping (address => mapping (address => uint256)) private _allowed;
494 
495     uint256 private _totalSupply;
496 
497     /**
498     * @dev Total number of tokens in existence
499     */
500     function totalSupply() public view returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505     * @dev Gets the balance of the specified address.
506     * @param owner The address to query the balance of.
507     * @return An uint256 representing the amount owned by the passed address.
508     */
509     function balanceOf(address owner) public view returns (uint256) {
510         return _balances[owner];
511     }
512 
513     /**
514      * @dev Function to check the amount of tokens that an owner allowed to a spender.
515      * @param owner address The address which owns the funds.
516      * @param spender address The address which will spend the funds.
517      * @return A uint256 specifying the amount of tokens still available for the spender.
518      */
519     function allowance(address owner, address spender) public view returns (uint256) {
520         return _allowed[owner][spender];
521     }
522 
523     /**
524     * @dev Transfer token for a specified address
525     * @param to The address to transfer to.
526     * @param value The amount to be transferred.
527     */
528     function transfer(address to, uint256 value) public returns (bool) {
529         _transfer(msg.sender, to, value);
530         return true;
531     }
532 
533     /**
534      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
535      * Beware that changing an allowance with this method brings the risk that someone may use both the old
536      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
537      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
538      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
539      * @param spender The address which will spend the funds.
540      * @param value The amount of tokens to be spent.
541      */
542     function approve(address spender, uint256 value) public returns (bool) {
543         require(spender != address(0));
544 
545         _allowed[msg.sender][spender] = value;
546         emit Approval(msg.sender, spender, value);
547         return true;
548     }
549 
550     /**
551      * @dev Transfer tokens from one address to another.
552      * Note that while this function emits an Approval event, this is not required as per the specification,
553      * and other compliant implementations may not emit the event.
554      * @param from address The address which you want to send tokens from
555      * @param to address The address which you want to transfer to
556      * @param value uint256 the amount of tokens to be transferred
557      */
558     function transferFrom(address from, address to, uint256 value) public returns (bool) {
559         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
560         _transfer(from, to, value);
561         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
562         return true;
563     }
564 
565     /**
566      * @dev Increase the amount of tokens that an owner allowed to a spender.
567      * approve should be called when allowed_[_spender] == 0. To increment
568      * allowed value is better to use this function to avoid 2 calls (and wait until
569      * the first transaction is mined)
570      * From MonolithDAO Token.sol
571      * Emits an Approval event.
572      * @param spender The address which will spend the funds.
573      * @param addedValue The amount of tokens to increase the allowance by.
574      */
575     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
576         require(spender != address(0));
577 
578         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
579         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
580         return true;
581     }
582 
583     /**
584      * @dev Decrease the amount of tokens that an owner allowed to a spender.
585      * approve should be called when allowed_[_spender] == 0. To decrement
586      * allowed value is better to use this function to avoid 2 calls (and wait until
587      * the first transaction is mined)
588      * From MonolithDAO Token.sol
589      * Emits an Approval event.
590      * @param spender The address which will spend the funds.
591      * @param subtractedValue The amount of tokens to decrease the allowance by.
592      */
593     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
594         require(spender != address(0));
595 
596         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
597         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
598         return true;
599     }
600 
601     /**
602     * @dev Transfer token for a specified addresses
603     * @param from The address to transfer from.
604     * @param to The address to transfer to.
605     * @param value The amount to be transferred.
606     */
607     function _transfer(address from, address to, uint256 value) internal {
608         require(to != address(0));
609 
610         _balances[from] = _balances[from].sub(value);
611         _balances[to] = _balances[to].add(value);
612         emit Transfer(from, to, value);
613     }
614 
615     /**
616      * @dev Internal function that mints an amount of the token and assigns it to
617      * an account. This encapsulates the modification of balances such that the
618      * proper events are emitted.
619      * @param account The account that will receive the created tokens.
620      * @param value The amount that will be created.
621      */
622     function _mint(address account, uint256 value) internal {
623         require(account != address(0));
624 
625         _totalSupply = _totalSupply.add(value);
626         _balances[account] = _balances[account].add(value);
627         emit Transfer(address(0), account, value);
628     }
629 
630     /**
631      * @dev Internal function that burns an amount of the token of a given
632      * account.
633      * @param account The account whose tokens will be burnt.
634      * @param value The amount that will be burnt.
635      */
636     function _burn(address account, uint256 value) internal {
637         require(account != address(0));
638 
639         _totalSupply = _totalSupply.sub(value);
640         _balances[account] = _balances[account].sub(value);
641         emit Transfer(account, address(0), value);
642     }
643 
644     /**
645      * @dev Internal function that burns an amount of the token of a given
646      * account, deducting from the sender's allowance for said account. Uses the
647      * internal burn function.
648      * Emits an Approval event (reflecting the reduced allowance).
649      * @param account The account whose tokens will be burnt.
650      * @param value The amount that will be burnt.
651      */
652     function _burnFrom(address account, uint256 value) internal {
653         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
654         _burn(account, value);
655         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
656     }
657 }
658 
659 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
660 
661 pragma solidity ^0.5.0;
662 
663 
664 /**
665  * @title Burnable Token
666  * @dev Token that can be irreversibly burned (destroyed).
667  */
668 contract ERC20Burnable is ERC20 {
669     /**
670      * @dev Burns a specific amount of tokens.
671      * @param value The amount of token to be burned.
672      */
673     function burn(uint256 value) public {
674         _burn(msg.sender, value);
675     }
676 
677     /**
678      * @dev Burns a specific amount of tokens from the target address and decrements allowance
679      * @param from address The address which you want to send tokens from
680      * @param value uint256 The amount of token to be burned
681      */
682     function burnFrom(address from, uint256 value) public {
683         _burnFrom(from, value);
684     }
685 }
686 
687 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
688 
689 pragma solidity ^0.5.0;
690 
691 /**
692  * @title Ownable
693  * @dev The Ownable contract has an owner address, and provides basic authorization control
694  * functions, this simplifies the implementation of "user permissions".
695  */
696 contract Ownable {
697     address private _owner;
698 
699     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
700 
701     /**
702      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
703      * account.
704      */
705     constructor () internal {
706         _owner = msg.sender;
707         emit OwnershipTransferred(address(0), _owner);
708     }
709 
710     /**
711      * @return the address of the owner.
712      */
713     function owner() public view returns (address) {
714         return _owner;
715     }
716 
717     /**
718      * @dev Throws if called by any account other than the owner.
719      */
720     modifier onlyOwner() {
721         require(isOwner());
722         _;
723     }
724 
725     /**
726      * @return true if `msg.sender` is the owner of the contract.
727      */
728     function isOwner() public view returns (bool) {
729         return msg.sender == _owner;
730     }
731 
732     /**
733      * @dev Allows the current owner to relinquish control of the contract.
734      * @notice Renouncing to ownership will leave the contract without an owner.
735      * It will not be possible to call the functions with the `onlyOwner`
736      * modifier anymore.
737      */
738     function renounceOwnership() public onlyOwner {
739         emit OwnershipTransferred(_owner, address(0));
740         _owner = address(0);
741     }
742 
743     /**
744      * @dev Allows the current owner to transfer control of the contract to a newOwner.
745      * @param newOwner The address to transfer ownership to.
746      */
747     function transferOwnership(address newOwner) public onlyOwner {
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers control of the contract to a newOwner.
753      * @param newOwner The address to transfer ownership to.
754      */
755     function _transferOwnership(address newOwner) internal {
756         require(newOwner != address(0));
757         emit OwnershipTransferred(_owner, newOwner);
758         _owner = newOwner;
759     }
760 }
761 
762 // File: contracts/misc/DutchAuction.sol
763 
764 pragma solidity ^0.5.0;
765 
766 
767 
768 
769 
770 
771 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
772 /// @author Stefan George - <stefan.george@consensys.net>
773 /// @author Airalab - <research@aira.life> 
774 contract DutchAuction is SignatureBouncer, Ownable {
775     using SafeERC20 for ERC20Burnable;
776 
777     /*
778      *  Events
779      */
780     event BidSubmission(address indexed sender, uint256 amount);
781 
782     /*
783      *  Constants
784      */
785     uint constant public WAITING_PERIOD = 0; // 1 days;
786 
787     /*
788      *  Storage
789      */
790     ERC20Burnable public token;
791     address public ambix;
792     address payable public wallet;
793     uint public maxTokenSold;
794     uint public ceiling;
795     uint public priceFactor;
796     uint public startBlock;
797     uint public endTime;
798     uint public totalReceived;
799     uint public finalPrice;
800     mapping (address => uint) public bids;
801     Stages public stage;
802 
803     /*
804      *  Enums
805      */
806     enum Stages {
807         AuctionDeployed,
808         AuctionSetUp,
809         AuctionStarted,
810         AuctionEnded,
811         TradingStarted
812     }
813 
814     /*
815      *  Modifiers
816      */
817     modifier atStage(Stages _stage) {
818         // Contract on stage
819         require(stage == _stage);
820         _;
821     }
822 
823     modifier isValidPayload() {
824         require(msg.data.length == 4 || msg.data.length == 164);
825         _;
826     }
827 
828     modifier timedTransitions() {
829         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
830             finalizeAuction();
831         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
832             stage = Stages.TradingStarted;
833         _;
834     }
835 
836     /*
837      *  Public functions
838      */
839     /// @dev Contract constructor function sets owner.
840     /// @param _wallet Multisig wallet.
841     /// @param _maxTokenSold Auction token balance.
842     /// @param _ceiling Auction ceiling.
843     /// @param _priceFactor Auction price factor.
844     constructor(address payable _wallet, uint _maxTokenSold, uint _ceiling, uint _priceFactor)
845         public
846     {
847         require(_wallet != address(0) && _ceiling > 0 && _priceFactor > 0);
848 
849         wallet = _wallet;
850         maxTokenSold = _maxTokenSold;
851         ceiling = _ceiling;
852         priceFactor = _priceFactor;
853         stage = Stages.AuctionDeployed;
854     }
855 
856     /// @dev Setup function sets external contracts' addresses.
857     /// @param _token Token address.
858     /// @param _ambix Distillation cube address.
859     function setup(ERC20Burnable _token, address _ambix)
860         public
861         onlyOwner
862         atStage(Stages.AuctionDeployed)
863     {
864         // Validate argument
865         require(_token != ERC20Burnable(0) && _ambix != address(0));
866 
867         token = _token;
868         ambix = _ambix;
869 
870         // Validate token balance
871         require(token.balanceOf(address(this)) == maxTokenSold);
872 
873         stage = Stages.AuctionSetUp;
874     }
875 
876     /// @dev Starts auction and sets startBlock.
877     function startAuction()
878         public
879         onlyOwner
880         atStage(Stages.AuctionSetUp)
881     {
882         stage = Stages.AuctionStarted;
883         startBlock = block.number;
884     }
885 
886     /// @dev Calculates current token price.
887     /// @return Returns token price.
888     function calcCurrentTokenPrice()
889         public
890         timedTransitions
891         returns (uint)
892     {
893         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
894             return finalPrice;
895         return calcTokenPrice();
896     }
897 
898     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
899     /// @return Returns current auction stage.
900     function updateStage()
901         public
902         timedTransitions
903         returns (Stages)
904     {
905         return stage;
906     }
907 
908     /// @dev Allows to send a bid to the auction.
909     /// @param signature KYC approvement
910     function bid(bytes calldata signature)
911         external
912         payable
913         isValidPayload
914         timedTransitions
915         atStage(Stages.AuctionStarted)
916         onlyValidSignature(signature)
917         returns (uint amount)
918     {
919         require(msg.value > 0);
920         amount = msg.value;
921 
922         address payable receiver = msg.sender;
923 
924         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
925         uint maxWei = maxTokenSold * calcTokenPrice() / 10**9 - totalReceived;
926         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
927         if (maxWeiBasedOnTotalReceived < maxWei)
928             maxWei = maxWeiBasedOnTotalReceived;
929 
930         // Only invest maximum possible amount.
931         if (amount > maxWei) {
932             amount = maxWei;
933             // Send change back to receiver address.
934             receiver.transfer(msg.value - amount);
935         }
936 
937         // Forward funding to ether wallet
938         (bool success,) = wallet.call.value(amount)("");
939         require(success);
940 
941         bids[receiver] += amount;
942         totalReceived += amount;
943         emit BidSubmission(receiver, amount);
944 
945         // Finalize auction when maxWei reached
946         if (amount == maxWei)
947             finalizeAuction();
948     }
949 
950     /// @dev Claims tokens for bidder after auction.
951     function claimTokens()
952         public
953         isValidPayload
954         timedTransitions
955         atStage(Stages.TradingStarted)
956     {
957         address receiver = msg.sender;
958         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
959         bids[receiver] = 0;
960         token.safeTransfer(receiver, tokenCount);
961     }
962 
963     /// @dev Calculates stop price.
964     /// @return Returns stop price.
965     function calcStopPrice()
966         view
967         public
968         returns (uint)
969     {
970         return totalReceived * 10**9 / maxTokenSold + 1;
971     }
972 
973     /// @dev Calculates token price.
974     /// @return Returns token price.
975     function calcTokenPrice()
976         view
977         public
978         returns (uint)
979     {
980         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
981     }
982 
983     /*
984      *  Private functions
985      */
986     function finalizeAuction()
987         private
988     {
989         stage = Stages.AuctionEnded;
990         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
991         uint soldTokens = totalReceived * 10**9 / finalPrice;
992 
993         if (totalReceived == ceiling) {
994             // Auction contract transfers all unsold tokens to Ambix contract
995             token.safeTransfer(ambix, maxTokenSold - soldTokens);
996         } else {
997             // Auction contract burn all unsold tokens
998             token.burn(maxTokenSold - soldTokens);
999         }
1000 
1001         endTime = now;
1002     }
1003 }
1004 
1005 // File: contracts/misc/SharedCode.sol
1006 
1007 pragma solidity ^0.5.0;
1008 
1009 // Inspired by https://github.com/GNSPS/2DProxy
1010 library SharedCode {
1011     /**
1012      * @dev Create tiny proxy without constructor
1013      * @param _shared Shared code contract address
1014      */
1015     function proxy(address _shared) internal returns (address instance) {
1016         bytes memory code = abi.encodePacked(
1017             hex"603160008181600b9039f3600080808080368092803773",
1018             _shared, hex"5af43d828181803e808314603057f35bfd"
1019         );
1020         assembly {
1021             instance := create(0, add(code, 0x20), 60)
1022             if iszero(extcodesize(instance)) {
1023                 revert(0, 0)
1024             }
1025         }
1026     }
1027 }
1028 
1029 // File: contracts/robonomics/interface/ILiability.sol
1030 
1031 pragma solidity ^0.5.0;
1032 
1033 /**
1034  * @title Standard liability smart contract interface
1035  */
1036 contract ILiability {
1037     /**
1038      * @dev Liability termination signal
1039      */
1040     event Finalized(bool indexed success, bytes result);
1041 
1042     /**
1043      * @dev Behaviour model multihash
1044      */
1045     bytes public model;
1046 
1047     /**
1048      * @dev Objective ROSBAG multihash
1049      * @notice ROSBAGv2 is used: http://wiki.ros.org/Bags/Format/2.0 
1050      */
1051     bytes public objective;
1052 
1053     /**
1054      * @dev Report ROSBAG multihash 
1055      * @notice ROSBAGv2 is used: http://wiki.ros.org/Bags/Format/2.0 
1056      */
1057     bytes public result;
1058 
1059     /**
1060      * @dev Payment token address
1061      */
1062     address public token;
1063 
1064     /**
1065      * @dev Liability cost
1066      */
1067     uint256 public cost;
1068 
1069     /**
1070      * @dev Lighthouse fee in wn
1071      */
1072     uint256 public lighthouseFee;
1073 
1074     /**
1075      * @dev Validator fee in wn
1076      */
1077     uint256 public validatorFee;
1078 
1079     /**
1080      * @dev Robonomics demand message hash
1081      */
1082     bytes32 public demandHash;
1083 
1084     /**
1085      * @dev Robonomics offer message hash
1086      */
1087     bytes32 public offerHash;
1088 
1089     /**
1090      * @dev Liability promisor address
1091      */
1092     address public promisor;
1093 
1094     /**
1095      * @dev Liability promisee address
1096      */
1097     address public promisee;
1098 
1099     /**
1100      * @dev Lighthouse assigned to this liability
1101      */
1102     address public lighthouse;
1103 
1104     /**
1105      * @dev Liability validator address
1106      */
1107     address public validator;
1108 
1109     /**
1110      * @dev Liability success flag
1111      */
1112     bool public isSuccess;
1113 
1114     /**
1115      * @dev Liability finalization status flag
1116      */
1117     bool public isFinalized;
1118 
1119     /**
1120      * @dev Deserialize robonomics demand message
1121      * @notice It can be called by factory only
1122      */
1123     function demand(
1124         bytes   calldata _model,
1125         bytes   calldata _objective,
1126 
1127         address _token,
1128         uint256 _cost,
1129 
1130         address _lighthouse,
1131 
1132         address _validator,
1133         uint256 _validator_fee,
1134 
1135         uint256 _deadline,
1136         address _sender,
1137         bytes   calldata _signature
1138     ) external returns (bool);
1139 
1140     /**
1141      * @dev Deserialize robonomics offer message
1142      * @notice It can be called by factory only
1143      */
1144     function offer(
1145         bytes   calldata _model,
1146         bytes   calldata _objective,
1147         
1148         address _token,
1149         uint256 _cost,
1150 
1151         address _validator,
1152 
1153         address _lighthouse,
1154         uint256 _lighthouse_fee,
1155 
1156         uint256 _deadline,
1157         address _sender,
1158         bytes   calldata _signature
1159     ) external returns (bool);
1160 
1161     /**
1162      * @dev Finalize liability contract
1163      * @param _result Result data hash
1164      * @param _success Set 'true' when liability has success result
1165      * @param _signature Result signature: liability address, result and success flag signed by promisor
1166      * @notice It can be called by assigned lighthouse only
1167      */
1168     function finalize(
1169         bytes calldata _result,
1170         bool  _success,
1171         bytes calldata _signature
1172     ) external returns (bool);
1173 }
1174 
1175 // File: contracts/robonomics/interface/ILighthouse.sol
1176 
1177 pragma solidity ^0.5.0;
1178 
1179 /**
1180  * @title Robonomics lighthouse contract interface
1181  */
1182 contract ILighthouse {
1183     /**
1184      * @dev Provider going online
1185      */
1186     event Online(address indexed provider);
1187 
1188     /**
1189      * @dev Provider going offline
1190      */
1191     event Offline(address indexed provider);
1192 
1193     /**
1194      * @dev Active robonomics provider
1195      */
1196     event Current(address indexed provider, uint256 indexed quota);
1197 
1198     /**
1199      * @dev Robonomics providers list
1200      */
1201     address[] public providers;
1202 
1203     /**
1204      * @dev Count of robonomics providers on this lighthouse
1205      */
1206     function providersLength() public view returns (uint256)
1207     { return providers.length; }
1208 
1209     /**
1210      * @dev Provider stake distribution
1211      */
1212     mapping(address => uint256) public stakes;
1213 
1214     /**
1215      * @dev Minimal stake to get one quota
1216      */
1217     uint256 public minimalStake;
1218 
1219     /**
1220      * @dev Silence timeout for provider in blocks
1221      */
1222     uint256 public timeoutInBlocks;
1223 
1224     /**
1225      * @dev Block number of last transaction from current provider
1226      */
1227     uint256 public keepAliveBlock;
1228 
1229     /**
1230      * @dev Round robin provider list marker
1231      */
1232     uint256 public marker;
1233 
1234     /**
1235      * @dev Current provider quota
1236      */
1237     uint256 public quota;
1238 
1239     /**
1240      * @dev Get quota of provider
1241      */
1242     function quotaOf(address _provider) public view returns (uint256)
1243     { return stakes[_provider] / minimalStake; }
1244 
1245     /**
1246      * @dev Increase stake and get more quota,
1247      *      one quota - one transaction in round
1248      * @param _value in wn
1249      * @notice XRT should be approved before call this 
1250      */
1251     function refill(uint256 _value) external returns (bool);
1252 
1253     /**
1254      * @dev Decrease stake and get XRT back
1255      * @param _value in wn
1256      */
1257     function withdraw(uint256 _value) external returns (bool);
1258 
1259     /**
1260      * @dev Create liability smart contract assigned to this lighthouse
1261      * @param _demand ABI-encoded demand message
1262      * @param _offer ABI-encoded offer message
1263      * @notice Only current provider can call it
1264      */
1265     function createLiability(
1266         bytes calldata _demand,
1267         bytes calldata _offer
1268     ) external returns (bool);
1269 
1270     /**
1271      * @dev Finalize liability smart contract assigned to this lighthouse
1272      * @param _liability smart contract address
1273      * @param _result report of work
1274      * @param _success work success flag
1275      * @param _signature work signature
1276      */
1277     function finalizeLiability(
1278         address _liability,
1279         bytes calldata _result,
1280         bool _success,
1281         bytes calldata _signature
1282     ) external returns (bool);
1283 }
1284 
1285 // File: contracts/robonomics/interface/IFactory.sol
1286 
1287 pragma solidity ^0.5.0;
1288 
1289 
1290 
1291 /**
1292  * @title Robonomics liability factory interface
1293  */
1294 contract IFactory {
1295     /**
1296      * @dev New liability created 
1297      */
1298     event NewLiability(address indexed liability);
1299 
1300     /**
1301      * @dev New lighthouse created
1302      */
1303     event NewLighthouse(address indexed lighthouse, string name);
1304 
1305     /**
1306      * @dev Lighthouse address mapping
1307      */
1308     mapping(address => bool) public isLighthouse;
1309 
1310     /**
1311      * @dev Nonce accounting
1312      */
1313     mapping(address => uint256) public nonceOf;
1314 
1315     /**
1316      * @dev Total GAS utilized by Robonomics network
1317      */
1318     uint256 public totalGasConsumed = 0;
1319 
1320     /**
1321      * @dev GAS utilized by liability contracts
1322      */
1323     mapping(address => uint256) public gasConsumedOf;
1324 
1325     /**
1326      * @dev The count of consumed gas for switch to next epoch 
1327      */
1328     uint256 public constant gasEpoch = 347 * 10**10;
1329 
1330     /**
1331      * @dev Current gas price in wei
1332      */
1333     uint256 public gasPrice = 10 * 10**9;
1334 
1335     /**
1336      * @dev XRT emission value for consumed gas
1337      * @param _gas Gas consumed by robonomics program
1338      */
1339     function wnFromGas(uint256 _gas) public view returns (uint256);
1340 
1341     /**
1342      * @dev Create lighthouse smart contract
1343      * @param _minimalStake Minimal stake value of XRT token (one quota price)
1344      * @param _timeoutInBlocks Max time of lighthouse silence in blocks
1345      * @param _name Lighthouse name,
1346      *              example: 'my-name' will create 'my-name.lighthouse.4.robonomics.eth' domain
1347      */
1348     function createLighthouse(
1349         uint256 _minimalStake,
1350         uint256 _timeoutInBlocks,
1351         string calldata _name
1352     ) external returns (ILighthouse);
1353 
1354     /**
1355      * @dev Create robot liability smart contract
1356      * @param _demand ABI-encoded demand message
1357      * @param _offer ABI-encoded offer message
1358      * @notice This method is for lighthouse contract use only
1359      */
1360     function createLiability(
1361         bytes calldata _demand,
1362         bytes calldata _offer
1363     ) external returns (ILiability);
1364 
1365     /**
1366      * @dev Is called after liability creation
1367      * @param _liability Liability contract address
1368      * @param _start_gas Transaction start gas level
1369      * @notice This method is for lighthouse contract use only
1370      */
1371     function liabilityCreated(ILiability _liability, uint256 _start_gas) external returns (bool);
1372 
1373     /**
1374      * @dev Is called after liability finalization
1375      * @param _liability Liability contract address
1376      * @param _start_gas Transaction start gas level
1377      * @notice This method is for lighthouse contract use only
1378      */
1379     function liabilityFinalized(ILiability _liability, uint256 _start_gas) external returns (bool);
1380 }
1381 
1382 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1383 
1384 pragma solidity ^0.5.0;
1385 
1386 
1387 contract MinterRole {
1388     using Roles for Roles.Role;
1389 
1390     event MinterAdded(address indexed account);
1391     event MinterRemoved(address indexed account);
1392 
1393     Roles.Role private _minters;
1394 
1395     constructor () internal {
1396         _addMinter(msg.sender);
1397     }
1398 
1399     modifier onlyMinter() {
1400         require(isMinter(msg.sender));
1401         _;
1402     }
1403 
1404     function isMinter(address account) public view returns (bool) {
1405         return _minters.has(account);
1406     }
1407 
1408     function addMinter(address account) public onlyMinter {
1409         _addMinter(account);
1410     }
1411 
1412     function renounceMinter() public {
1413         _removeMinter(msg.sender);
1414     }
1415 
1416     function _addMinter(address account) internal {
1417         _minters.add(account);
1418         emit MinterAdded(account);
1419     }
1420 
1421     function _removeMinter(address account) internal {
1422         _minters.remove(account);
1423         emit MinterRemoved(account);
1424     }
1425 }
1426 
1427 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1428 
1429 pragma solidity ^0.5.0;
1430 
1431 
1432 
1433 /**
1434  * @title ERC20Mintable
1435  * @dev ERC20 minting logic
1436  */
1437 contract ERC20Mintable is ERC20, MinterRole {
1438     /**
1439      * @dev Function to mint tokens
1440      * @param to The address that will receive the minted tokens.
1441      * @param value The amount of tokens to mint.
1442      * @return A boolean that indicates if the operation was successful.
1443      */
1444     function mint(address to, uint256 value) public onlyMinter returns (bool) {
1445         _mint(to, value);
1446         return true;
1447     }
1448 }
1449 
1450 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1451 
1452 pragma solidity ^0.5.0;
1453 
1454 
1455 /**
1456  * @title ERC20Detailed token
1457  * @dev The decimals are only for visualization purposes.
1458  * All the operations are done using the smallest and indivisible token unit,
1459  * just as on Ethereum all the operations are done in wei.
1460  */
1461 contract ERC20Detailed is IERC20 {
1462     string private _name;
1463     string private _symbol;
1464     uint8 private _decimals;
1465 
1466     constructor (string memory name, string memory symbol, uint8 decimals) public {
1467         _name = name;
1468         _symbol = symbol;
1469         _decimals = decimals;
1470     }
1471 
1472     /**
1473      * @return the name of the token.
1474      */
1475     function name() public view returns (string memory) {
1476         return _name;
1477     }
1478 
1479     /**
1480      * @return the symbol of the token.
1481      */
1482     function symbol() public view returns (string memory) {
1483         return _symbol;
1484     }
1485 
1486     /**
1487      * @return the number of decimals of the token.
1488      */
1489     function decimals() public view returns (uint8) {
1490         return _decimals;
1491     }
1492 }
1493 
1494 // File: contracts/robonomics/XRT.sol
1495 
1496 pragma solidity ^0.5.0;
1497 
1498 
1499 
1500 
1501 contract XRT is ERC20Mintable, ERC20Burnable, ERC20Detailed {
1502     constructor(uint256 _initial_supply) public ERC20Detailed("Robonomics", "XRT", 9) {
1503         _mint(msg.sender, _initial_supply);
1504     }
1505 }
1506 
1507 // File: contracts/robonomics/Lighthouse.sol
1508 
1509 pragma solidity ^0.5.0;
1510 
1511 
1512 
1513 
1514 
1515 contract Lighthouse is ILighthouse {
1516     using SafeERC20 for XRT;
1517 
1518     IFactory public factory;
1519     XRT      public xrt;
1520 
1521     function setup(XRT _xrt, uint256 _minimalStake, uint256 _timeoutInBlocks) external returns (bool) {
1522         require(factory == IFactory(0) && _minimalStake > 0 && _timeoutInBlocks > 0);
1523 
1524         minimalStake    = _minimalStake;
1525         timeoutInBlocks = _timeoutInBlocks;
1526         factory         = IFactory(msg.sender);
1527         xrt             = _xrt;
1528 
1529         return true;
1530     }
1531 
1532     /**
1533      * @dev Providers index, started from 1
1534      */
1535     mapping(address => uint256) public indexOf;
1536 
1537     function refill(uint256 _value) external returns (bool) {
1538         xrt.safeTransferFrom(msg.sender, address(this), _value);
1539 
1540         if (stakes[msg.sender] == 0) {
1541             require(_value >= minimalStake);
1542             providers.push(msg.sender);
1543             indexOf[msg.sender] = providers.length;
1544             emit Online(msg.sender);
1545         }
1546 
1547         stakes[msg.sender] += _value;
1548         return true;
1549     }
1550 
1551     function withdraw(uint256 _value) external returns (bool) {
1552         require(stakes[msg.sender] >= _value);
1553 
1554         stakes[msg.sender] -= _value;
1555         xrt.safeTransfer(msg.sender, _value);
1556 
1557         // Drop member with zero quota
1558         if (quotaOf(msg.sender) == 0) {
1559             uint256 balance = stakes[msg.sender];
1560             stakes[msg.sender] = 0;
1561             xrt.safeTransfer(msg.sender, balance);
1562             
1563             uint256 senderIndex = indexOf[msg.sender] - 1;
1564             uint256 lastIndex = providers.length - 1;
1565             if (senderIndex < lastIndex)
1566                 providers[senderIndex] = providers[lastIndex];
1567 
1568             providers.length -= 1;
1569             indexOf[msg.sender] = 0;
1570 
1571             emit Offline(msg.sender);
1572         }
1573         return true;
1574     }
1575 
1576     function keepAliveTransaction() internal {
1577         if (timeoutInBlocks < block.number - keepAliveBlock) {
1578             // Set up the marker according to provider index
1579             marker = indexOf[msg.sender];
1580 
1581             // Thransaction sender should be a registered provider
1582             require(marker > 0 && marker <= providers.length);
1583 
1584             // Allocate new quota
1585             quota = quotaOf(providers[marker - 1]);
1586 
1587             // Current provider signal
1588             emit Current(providers[marker - 1], quota);
1589         }
1590 
1591         // Store transaction sending block
1592         keepAliveBlock = block.number;
1593     }
1594 
1595     function quotedTransaction() internal {
1596         // Don't premit transactions without providers on board
1597         require(providers.length > 0);
1598 
1599         // Zero quota guard
1600         // XXX: When quota for some reasons is zero, DoS will be preverted by keepalive transaction
1601         require(quota > 0);
1602 
1603         // Only provider with marker can to send transaction
1604         require(msg.sender == providers[marker - 1]);
1605 
1606         // Consume one quota for transaction sending
1607         if (quota > 1) {
1608             quota -= 1;
1609         } else {
1610             // Step over marker
1611             marker = marker % providers.length + 1;
1612 
1613             // Allocate new quota
1614             quota = quotaOf(providers[marker - 1]);
1615 
1616             // Current provider signal
1617             emit Current(providers[marker - 1], quota);
1618         }
1619     }
1620 
1621     function startGas() internal view returns (uint256 gas) {
1622         // the total amount of gas the tx is DataFee + TxFee + ExecutionGas
1623         // ExecutionGas
1624         gas = gasleft();
1625         // TxFee
1626         gas += 21000;
1627         // DataFee
1628         for (uint256 i = 0; i < msg.data.length; ++i)
1629             gas += msg.data[i] == 0 ? 4 : 68;
1630     }
1631 
1632     function createLiability(
1633         bytes calldata _demand,
1634         bytes calldata _offer
1635     )
1636         external
1637         returns (bool)
1638     {
1639         // Gas with estimation error
1640         uint256 gas = startGas() + 4887;
1641 
1642         keepAliveTransaction();
1643         quotedTransaction();
1644 
1645         ILiability liability = factory.createLiability(_demand, _offer);
1646         require(liability != ILiability(0));
1647         require(factory.liabilityCreated(liability, gas - gasleft()));
1648         return true;
1649     }
1650 
1651     function finalizeLiability(
1652         address _liability,
1653         bytes calldata _result,
1654         bool _success,
1655         bytes calldata _signature
1656     )
1657         external
1658         returns (bool)
1659     {
1660         // Gas with estimation error
1661         uint256 gas = startGas() + 22335;
1662 
1663         keepAliveTransaction();
1664         quotedTransaction();
1665 
1666         ILiability liability = ILiability(_liability);
1667         require(factory.gasConsumedOf(_liability) > 0);
1668         require(liability.finalize(_result, _success, _signature));
1669         require(factory.liabilityFinalized(liability, gas - gasleft()));
1670         return true;
1671     }
1672 }
1673 
1674 // File: contracts/robonomics/interface/IValidator.sol
1675 
1676 pragma solidity ^0.5.0;
1677 
1678 /**
1679  * @dev Observing network contract interface
1680  */
1681 contract IValidator {
1682     /**
1683      * @dev Be sure than address is really validator
1684      * @return true when validator address in argument
1685      */
1686     function isValidator(address _validator) external returns (bool);
1687 }
1688 
1689 // File: contracts/robonomics/Liability.sol
1690 
1691 pragma solidity ^0.5.0;
1692 
1693 
1694 
1695 
1696 
1697 
1698 
1699 contract Liability is ILiability {
1700     using ECDSA for bytes32;
1701     using SafeERC20 for XRT;
1702     using SafeERC20 for ERC20;
1703 
1704     address public factory;
1705     XRT     public xrt;
1706 
1707     function setup(XRT _xrt) external returns (bool) {
1708         require(factory == address(0));
1709 
1710         factory = msg.sender;
1711         xrt     = _xrt;
1712 
1713         return true;
1714     }
1715 
1716     function demand(
1717         bytes   calldata _model,
1718         bytes   calldata _objective,
1719 
1720         address _token,
1721         uint256 _cost,
1722 
1723         address _lighthouse,
1724 
1725         address _validator,
1726         uint256 _validator_fee,
1727 
1728         uint256 _deadline,
1729         address _sender,
1730         bytes   calldata _signature
1731     )
1732         external
1733         returns (bool)
1734     {
1735         require(msg.sender == factory);
1736         require(block.number < _deadline);
1737 
1738         model        = _model;
1739         objective    = _objective;
1740         token        = _token;
1741         cost         = _cost;
1742         lighthouse   = _lighthouse;
1743         validator    = _validator;
1744         validatorFee = _validator_fee;
1745 
1746         demandHash = keccak256(abi.encodePacked(
1747             _model
1748           , _objective
1749           , _token
1750           , _cost
1751           , _lighthouse
1752           , _validator
1753           , _validator_fee
1754           , _deadline
1755           , IFactory(factory).nonceOf(_sender)
1756           , _sender
1757         ));
1758 
1759         promisee = demandHash
1760             .toEthSignedMessageHash()
1761             .recover(_signature);
1762         require(promisee == _sender);
1763         return true;
1764     }
1765 
1766     function offer(
1767         bytes   calldata _model,
1768         bytes   calldata _objective,
1769         
1770         address _token,
1771         uint256 _cost,
1772 
1773         address _validator,
1774 
1775         address _lighthouse,
1776         uint256 _lighthouse_fee,
1777 
1778         uint256 _deadline,
1779         address _sender,
1780         bytes   calldata _signature
1781     )
1782         external
1783         returns (bool)
1784     {
1785         require(msg.sender == factory);
1786         require(block.number < _deadline);
1787         require(keccak256(model) == keccak256(_model));
1788         require(keccak256(objective) == keccak256(_objective));
1789         require(_token == token);
1790         require(_cost == cost);
1791         require(_lighthouse == lighthouse);
1792         require(_validator == validator);
1793 
1794         lighthouseFee = _lighthouse_fee;
1795 
1796         offerHash = keccak256(abi.encodePacked(
1797             _model
1798           , _objective
1799           , _token
1800           , _cost
1801           , _validator
1802           , _lighthouse
1803           , _lighthouse_fee
1804           , _deadline
1805           , IFactory(factory).nonceOf(_sender)
1806           , _sender
1807         ));
1808 
1809         promisor = offerHash
1810             .toEthSignedMessageHash()
1811             .recover(_signature);
1812         require(promisor == _sender);
1813         return true;
1814     }
1815 
1816     function finalize(
1817         bytes calldata _result,
1818         bool  _success,
1819         bytes calldata _signature
1820     )
1821         external
1822         returns (bool)
1823     {
1824         require(msg.sender == lighthouse);
1825         require(!isFinalized);
1826 
1827         isFinalized = true;
1828         result      = _result;
1829         isSuccess   = _success;
1830 
1831         address resultSender = keccak256(abi.encodePacked(this, _result, _success))
1832             .toEthSignedMessageHash()
1833             .recover(_signature);
1834 
1835         if (validator == address(0)) {
1836             require(resultSender == promisor);
1837         } else {
1838             require(IValidator(validator).isValidator(resultSender));
1839             // Transfer validator fee when is set
1840             if (validatorFee > 0)
1841                 xrt.safeTransfer(validator, validatorFee);
1842 
1843         }
1844 
1845         if (cost > 0)
1846             ERC20(token).safeTransfer(isSuccess ? promisor : promisee, cost);
1847 
1848         emit Finalized(isSuccess, result);
1849         return true;
1850     }
1851 }
1852 
1853 // File: contracts/robonomics/Factory.sol
1854 
1855 pragma solidity ^0.5.0;
1856 
1857 
1858 
1859 
1860 
1861 
1862 
1863 
1864 
1865 
1866 
1867 contract Factory is IFactory, SingletonHash {
1868     constructor(
1869         address _liability,
1870         address _lighthouse,
1871         DutchAuction _auction,
1872         AbstractENS _ens,
1873         XRT _xrt
1874     ) public {
1875         liabilityCode = _liability;
1876         lighthouseCode = _lighthouse;
1877         auction = _auction;
1878         ens = _ens;
1879         xrt = _xrt;
1880     }
1881 
1882     address public liabilityCode;
1883     address public lighthouseCode;
1884 
1885     using SafeERC20 for XRT;
1886     using SafeERC20 for ERC20;
1887     using SharedCode for address;
1888 
1889     /**
1890      * @dev Robonomics dutch auction contract
1891      */
1892     DutchAuction public auction;
1893 
1894     /**
1895      * @dev Ethereum name system
1896      */
1897     AbstractENS public ens;
1898 
1899     /**
1900      * @dev Robonomics network protocol token
1901      */
1902     XRT public xrt;
1903 
1904     /**
1905      * @dev SMMA filter with function: SMMA(i) = (SMMA(i-1)*(n-1) + PRICE(i)) / n
1906      * @param _prePrice PRICE[n-1]
1907      * @param _price PRICE[n]
1908      * @return filtered price
1909      */
1910     function smma(uint256 _prePrice, uint256 _price) internal pure returns (uint256) {
1911         return (_prePrice * (smmaPeriod - 1) + _price) / smmaPeriod;
1912     }
1913 
1914     /**
1915      * @dev SMMA filter period
1916      */
1917     uint256 private constant smmaPeriod = 1000;
1918 
1919     /**
1920      * @dev XRT emission value for utilized gas
1921      */
1922     function wnFromGas(uint256 _gas) public view returns (uint256) {
1923         // Just return wn=gas*150 when auction isn't finish
1924         if (auction.finalPrice() == 0)
1925             return _gas * 150;
1926 
1927         // Current gas utilization epoch
1928         uint256 epoch = totalGasConsumed / gasEpoch;
1929 
1930         // XRT emission with addition coefficient by gas utilzation epoch
1931         uint256 wn = _gas * 10**9 * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1932 
1933         // Check to not permit emission decrease below wn=gas
1934         return wn < _gas ? _gas : wn;
1935     }
1936 
1937     modifier onlyLighthouse {
1938         require(isLighthouse[msg.sender]);
1939 
1940         _;
1941     }
1942 
1943     modifier gasPriceEstimate {
1944         gasPrice = smma(gasPrice, tx.gasprice);
1945 
1946         _;
1947     }
1948 
1949     function createLighthouse(
1950         uint256 _minimalStake,
1951         uint256 _timeoutInBlocks,
1952         string  calldata _name
1953     )
1954         external
1955         returns (ILighthouse lighthouse)
1956     {
1957         bytes32 LIGHTHOUSE_NODE
1958             // lighthouse.5.robonomics.eth
1959             = 0x8d6c004b56cbe83bbfd9dcbd8f45d1f76398267bbb130a4629d822abc1994b96;
1960         bytes32 hname = keccak256(bytes(_name));
1961 
1962         // Name reservation check
1963         bytes32 subnode = keccak256(abi.encodePacked(LIGHTHOUSE_NODE, hname));
1964         require(ens.resolver(subnode) == address(0));
1965 
1966         // Create lighthouse
1967         lighthouse = ILighthouse(lighthouseCode.proxy());
1968         require(Lighthouse(address(lighthouse)).setup(xrt, _minimalStake, _timeoutInBlocks));
1969 
1970         emit NewLighthouse(address(lighthouse), _name);
1971         isLighthouse[address(lighthouse)] = true;
1972 
1973         // Register subnode
1974         ens.setSubnodeOwner(LIGHTHOUSE_NODE, hname, address(this));
1975 
1976         // Register lighthouse address
1977         AbstractResolver resolver = AbstractResolver(ens.resolver(LIGHTHOUSE_NODE));
1978         ens.setResolver(subnode, address(resolver));
1979         resolver.setAddr(subnode, address(lighthouse));
1980     }
1981 
1982     function createLiability(
1983         bytes calldata _demand,
1984         bytes calldata _offer
1985     )
1986         external
1987         onlyLighthouse
1988         returns (ILiability liability)
1989     {
1990         // Create liability
1991         liability = ILiability(liabilityCode.proxy());
1992         require(Liability(address(liability)).setup(xrt));
1993 
1994         emit NewLiability(address(liability));
1995 
1996         // Parse messages
1997         (bool success, bytes memory returnData)
1998             = address(liability).call(abi.encodePacked(bytes4(0x48a984e4), _demand)); // liability.demand(...)
1999         require(success);
2000         singletonHash(liability.demandHash());
2001         nonceOf[liability.promisee()] += 1;
2002 
2003         (success, returnData)
2004             = address(liability).call(abi.encodePacked(bytes4(0x413781d2), _offer)); // liability.offer(...)
2005         require(success);
2006         singletonHash(liability.offerHash());
2007         nonceOf[liability.promisor()] += 1;
2008 
2009         // Check lighthouse
2010         require(isLighthouse[liability.lighthouse()]);
2011 
2012         // Transfer lighthouse fee to lighthouse worker directly
2013         if (liability.lighthouseFee() > 0)
2014             xrt.safeTransferFrom(liability.promisor(),
2015                                  tx.origin,
2016                                  liability.lighthouseFee());
2017 
2018         // Transfer liability security and hold on contract
2019         ERC20 token = ERC20(liability.token());
2020         if (liability.cost() > 0)
2021             token.safeTransferFrom(liability.promisee(),
2022                                    address(liability),
2023                                    liability.cost());
2024 
2025         // Transfer validator fee and hold on contract
2026         if (liability.validator() != address(0) && liability.validatorFee() > 0)
2027             xrt.safeTransferFrom(liability.promisee(),
2028                                  address(liability),
2029                                  liability.validatorFee());
2030      }
2031 
2032     function liabilityCreated(
2033         ILiability _liability,
2034         uint256 _gas
2035     )
2036         external
2037         onlyLighthouse
2038         gasPriceEstimate
2039         returns (bool)
2040     {
2041         address liability = address(_liability);
2042         totalGasConsumed         += _gas;
2043         gasConsumedOf[liability] += _gas;
2044         return true;
2045     }
2046 
2047     function liabilityFinalized(
2048         ILiability _liability,
2049         uint256 _gas
2050     )
2051         external
2052         onlyLighthouse
2053         gasPriceEstimate
2054         returns (bool)
2055     {
2056         address liability = address(_liability);
2057         totalGasConsumed         += _gas;
2058         gasConsumedOf[liability] += _gas;
2059         require(xrt.mint(tx.origin, wnFromGas(gasConsumedOf[liability])));
2060         return true;
2061     }
2062 }