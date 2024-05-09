1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114   using SafeMath for uint256;
115 
116   function safeTransfer(
117     IERC20 token,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(
127     IERC20 token,
128     address from,
129     address to,
130     uint256 value
131   )
132     internal
133   {
134     require(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(
138     IERC20 token,
139     address spender,
140     uint256 value
141   )
142     internal
143   {
144     // safeApprove should only be called when setting an initial allowance, 
145     // or when resetting it to zero. To increase and decrease it, use 
146     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148     require(token.approve(spender, value));
149   }
150 
151   function safeIncreaseAllowance(
152     IERC20 token,
153     address spender,
154     uint256 value
155   )
156     internal
157   {
158     uint256 newAllowance = token.allowance(address(this), spender).add(value);
159     require(token.approve(spender, newAllowance));
160   }
161 
162   function safeDecreaseAllowance(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170     require(token.approve(spender, newAllowance));
171   }
172 }
173 
174 // File: contracts/ens/AbstractENS.sol
175 
176 contract AbstractENS {
177     function owner(bytes32 _node) public view returns(address);
178     function resolver(bytes32 _node) public view returns(address);
179     function ttl(bytes32 _node) public view returns(uint64);
180     function setOwner(bytes32 _node, address _owner) public;
181     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
182     function setResolver(bytes32 _node, address _resolver) public;
183     function setTTL(bytes32 _node, uint64 _ttl) public;
184 
185     // Logged when the owner of a node assigns a new owner to a subnode.
186     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
187 
188     // Logged when the owner of a node transfers ownership to a new account.
189     event Transfer(bytes32 indexed node, address owner);
190 
191     // Logged when the resolver for a node changes.
192     event NewResolver(bytes32 indexed node, address resolver);
193 
194     // Logged when the TTL of a node changes
195     event NewTTL(bytes32 indexed node, uint64 ttl);
196 }
197 
198 // File: contracts/ens/AbstractResolver.sol
199 
200 contract AbstractResolver {
201     function supportsInterface(bytes4 _interfaceID) public view returns (bool);
202     function addr(bytes32 _node) public view returns (address ret);
203     function setAddr(bytes32 _node, address _addr) public;
204     function hash(bytes32 _node) public view returns (bytes32 ret);
205     function setHash(bytes32 _node, bytes32 _hash) public;
206 }
207 
208 // File: contracts/misc/SingletonHash.sol
209 
210 contract SingletonHash {
211     event HashConsumed(bytes32 indexed hash);
212 
213     /**
214      * @dev Used hash accounting
215      */
216     mapping(bytes32 => bool) public isHashConsumed;
217 
218     /**
219      * @dev Parameter can be used only once
220      * @param _hash Single usage hash
221      */
222     function singletonHash(bytes32 _hash) internal {
223         require(!isHashConsumed[_hash]);
224         isHashConsumed[_hash] = true;
225         emit HashConsumed(_hash);
226     }
227 }
228 
229 // File: openzeppelin-solidity/contracts/access/Roles.sol
230 
231 /**
232  * @title Roles
233  * @dev Library for managing addresses assigned to a Role.
234  */
235 library Roles {
236   struct Role {
237     mapping (address => bool) bearer;
238   }
239 
240   /**
241    * @dev give an account access to this role
242    */
243   function add(Role storage role, address account) internal {
244     require(account != address(0));
245     require(!has(role, account));
246 
247     role.bearer[account] = true;
248   }
249 
250   /**
251    * @dev remove an account's access to this role
252    */
253   function remove(Role storage role, address account) internal {
254     require(account != address(0));
255     require(has(role, account));
256 
257     role.bearer[account] = false;
258   }
259 
260   /**
261    * @dev check if an account has this role
262    * @return bool
263    */
264   function has(Role storage role, address account)
265     internal
266     view
267     returns (bool)
268   {
269     require(account != address(0));
270     return role.bearer[account];
271   }
272 }
273 
274 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
275 
276 contract SignerRole {
277   using Roles for Roles.Role;
278 
279   event SignerAdded(address indexed account);
280   event SignerRemoved(address indexed account);
281 
282   Roles.Role private signers;
283 
284   constructor() internal {
285     _addSigner(msg.sender);
286   }
287 
288   modifier onlySigner() {
289     require(isSigner(msg.sender));
290     _;
291   }
292 
293   function isSigner(address account) public view returns (bool) {
294     return signers.has(account);
295   }
296 
297   function addSigner(address account) public onlySigner {
298     _addSigner(account);
299   }
300 
301   function renounceSigner() public {
302     _removeSigner(msg.sender);
303   }
304 
305   function _addSigner(address account) internal {
306     signers.add(account);
307     emit SignerAdded(account);
308   }
309 
310   function _removeSigner(address account) internal {
311     signers.remove(account);
312     emit SignerRemoved(account);
313   }
314 }
315 
316 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
317 
318 /**
319  * @title Elliptic curve signature operations
320  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
321  * TODO Remove this library once solidity supports passing a signature to ecrecover.
322  * See https://github.com/ethereum/solidity/issues/864
323  */
324 
325 library ECDSA {
326 
327   /**
328    * @dev Recover signer address from a message by using their signature
329    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
330    * @param signature bytes signature, the signature is generated using web3.eth.sign()
331    */
332   function recover(bytes32 hash, bytes signature)
333     internal
334     pure
335     returns (address)
336   {
337     bytes32 r;
338     bytes32 s;
339     uint8 v;
340 
341     // Check the signature length
342     if (signature.length != 65) {
343       return (address(0));
344     }
345 
346     // Divide the signature in r, s and v variables
347     // ecrecover takes the signature parameters, and the only way to get them
348     // currently is to use assembly.
349     // solium-disable-next-line security/no-inline-assembly
350     assembly {
351       r := mload(add(signature, 0x20))
352       s := mload(add(signature, 0x40))
353       v := byte(0, mload(add(signature, 0x60)))
354     }
355 
356     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
357     if (v < 27) {
358       v += 27;
359     }
360 
361     // If the version is correct return the signer address
362     if (v != 27 && v != 28) {
363       return (address(0));
364     } else {
365       // solium-disable-next-line arg-overflow
366       return ecrecover(hash, v, r, s);
367     }
368   }
369 
370   /**
371    * toEthSignedMessageHash
372    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
373    * and hash the result
374    */
375   function toEthSignedMessageHash(bytes32 hash)
376     internal
377     pure
378     returns (bytes32)
379   {
380     // 32 is the length in bytes of hash,
381     // enforced by the type signature above
382     return keccak256(
383       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
384     );
385   }
386 }
387 
388 // File: openzeppelin-solidity/contracts/drafts/SignatureBouncer.sol
389 
390 /**
391  * @title SignatureBouncer
392  * @author PhABC, Shrugs and aflesher
393  * @dev SignatureBouncer allows users to submit a signature as a permission to
394  * do an action.
395  * If the signature is from one of the authorized signer addresses, the
396  * signature is valid.
397  * Note that SignatureBouncer offers no protection against replay attacks, users
398  * must add this themselves!
399  *
400  * Signer addresses can be individual servers signing grants or different
401  * users within a decentralized club that have permission to invite other
402  * members. This technique is useful for whitelists and airdrops; instead of
403  * putting all valid addresses on-chain, simply sign a grant of the form
404  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a
405  * valid signer address.
406  * Then restrict access to your crowdsale/whitelist/airdrop using the
407  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
408  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
409  * `onlyValidSignatureAndData` can be used to restrict access to only a given
410  * method or a given method with given parameters respectively.
411  * See the tests in SignatureBouncer.test.js for specific usage examples.
412  *
413  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make
414  * the _signature parameter the "last" parameter. You cannot sign a message that
415  * has its own signature in it so the last 128 bytes of msg.data (which
416  * represents the length of the _signature data and the _signaature data itself)
417  * is ignored when validating. Also non fixed sized parameters make constructing
418  * the data in the signature much more complex.
419  * See https://ethereum.stackexchange.com/a/50616 for more details.
420  */
421 contract SignatureBouncer is SignerRole {
422   using ECDSA for bytes32;
423 
424   // Function selectors are 4 bytes long, as documented in
425   // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
426   uint256 private constant _METHOD_ID_SIZE = 4;
427   // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
428   uint256 private constant _SIGNATURE_SIZE = 96;
429 
430   constructor() internal {}
431 
432   /**
433    * @dev requires that a valid signature of a signer was provided
434    */
435   modifier onlyValidSignature(bytes signature)
436   {
437     require(_isValidSignature(msg.sender, signature));
438     _;
439   }
440 
441   /**
442    * @dev requires that a valid signature with a specifed method of a signer was provided
443    */
444   modifier onlyValidSignatureAndMethod(bytes signature)
445   {
446     require(_isValidSignatureAndMethod(msg.sender, signature));
447     _;
448   }
449 
450   /**
451    * @dev requires that a valid signature with a specifed method and params of a signer was provided
452    */
453   modifier onlyValidSignatureAndData(bytes signature)
454   {
455     require(_isValidSignatureAndData(msg.sender, signature));
456     _;
457   }
458 
459   /**
460    * @dev is the signature of `this + sender` from a signer?
461    * @return bool
462    */
463   function _isValidSignature(address account, bytes signature)
464     internal
465     view
466     returns (bool)
467   {
468     return _isValidDataHash(
469       keccak256(abi.encodePacked(address(this), account)),
470       signature
471     );
472   }
473 
474   /**
475    * @dev is the signature of `this + sender + methodId` from a signer?
476    * @return bool
477    */
478   function _isValidSignatureAndMethod(address account, bytes signature)
479     internal
480     view
481     returns (bool)
482   {
483     bytes memory data = new bytes(_METHOD_ID_SIZE);
484     for (uint i = 0; i < data.length; i++) {
485       data[i] = msg.data[i];
486     }
487     return _isValidDataHash(
488       keccak256(abi.encodePacked(address(this), account, data)),
489       signature
490     );
491   }
492 
493   /**
494     * @dev is the signature of `this + sender + methodId + params(s)` from a signer?
495     * @notice the signature parameter of the method being validated must be the "last" parameter
496     * @return bool
497     */
498   function _isValidSignatureAndData(address account, bytes signature)
499     internal
500     view
501     returns (bool)
502   {
503     require(msg.data.length > _SIGNATURE_SIZE);
504     bytes memory data = new bytes(msg.data.length - _SIGNATURE_SIZE);
505     for (uint i = 0; i < data.length; i++) {
506       data[i] = msg.data[i];
507     }
508     return _isValidDataHash(
509       keccak256(abi.encodePacked(address(this), account, data)),
510       signature
511     );
512   }
513 
514   /**
515    * @dev internal function to convert a hash to an eth signed message
516    * and then recover the signature and check it against the signer role
517    * @return bool
518    */
519   function _isValidDataHash(bytes32 hash, bytes signature)
520     internal
521     view
522     returns (bool)
523   {
524     address signer = hash
525       .toEthSignedMessageHash()
526       .recover(signature);
527 
528     return signer != address(0) && isSigner(signer);
529   }
530 }
531 
532 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
533 
534 /**
535  * @title Standard ERC20 token
536  *
537  * @dev Implementation of the basic standard token.
538  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
539  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
540  */
541 contract ERC20 is IERC20 {
542   using SafeMath for uint256;
543 
544   mapping (address => uint256) private _balances;
545 
546   mapping (address => mapping (address => uint256)) private _allowed;
547 
548   uint256 private _totalSupply;
549 
550   /**
551   * @dev Total number of tokens in existence
552   */
553   function totalSupply() public view returns (uint256) {
554     return _totalSupply;
555   }
556 
557   /**
558   * @dev Gets the balance of the specified address.
559   * @param owner The address to query the balance of.
560   * @return An uint256 representing the amount owned by the passed address.
561   */
562   function balanceOf(address owner) public view returns (uint256) {
563     return _balances[owner];
564   }
565 
566   /**
567    * @dev Function to check the amount of tokens that an owner allowed to a spender.
568    * @param owner address The address which owns the funds.
569    * @param spender address The address which will spend the funds.
570    * @return A uint256 specifying the amount of tokens still available for the spender.
571    */
572   function allowance(
573     address owner,
574     address spender
575    )
576     public
577     view
578     returns (uint256)
579   {
580     return _allowed[owner][spender];
581   }
582 
583   /**
584   * @dev Transfer token for a specified address
585   * @param to The address to transfer to.
586   * @param value The amount to be transferred.
587   */
588   function transfer(address to, uint256 value) public returns (bool) {
589     _transfer(msg.sender, to, value);
590     return true;
591   }
592 
593   /**
594    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
595    * Beware that changing an allowance with this method brings the risk that someone may use both the old
596    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
597    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
598    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
599    * @param spender The address which will spend the funds.
600    * @param value The amount of tokens to be spent.
601    */
602   function approve(address spender, uint256 value) public returns (bool) {
603     require(spender != address(0));
604 
605     _allowed[msg.sender][spender] = value;
606     emit Approval(msg.sender, spender, value);
607     return true;
608   }
609 
610   /**
611    * @dev Transfer tokens from one address to another
612    * @param from address The address which you want to send tokens from
613    * @param to address The address which you want to transfer to
614    * @param value uint256 the amount of tokens to be transferred
615    */
616   function transferFrom(
617     address from,
618     address to,
619     uint256 value
620   )
621     public
622     returns (bool)
623   {
624     require(value <= _allowed[from][msg.sender]);
625 
626     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
627     _transfer(from, to, value);
628     return true;
629   }
630 
631   /**
632    * @dev Increase the amount of tokens that an owner allowed to a spender.
633    * approve should be called when allowed_[_spender] == 0. To increment
634    * allowed value is better to use this function to avoid 2 calls (and wait until
635    * the first transaction is mined)
636    * From MonolithDAO Token.sol
637    * @param spender The address which will spend the funds.
638    * @param addedValue The amount of tokens to increase the allowance by.
639    */
640   function increaseAllowance(
641     address spender,
642     uint256 addedValue
643   )
644     public
645     returns (bool)
646   {
647     require(spender != address(0));
648 
649     _allowed[msg.sender][spender] = (
650       _allowed[msg.sender][spender].add(addedValue));
651     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
652     return true;
653   }
654 
655   /**
656    * @dev Decrease the amount of tokens that an owner allowed to a spender.
657    * approve should be called when allowed_[_spender] == 0. To decrement
658    * allowed value is better to use this function to avoid 2 calls (and wait until
659    * the first transaction is mined)
660    * From MonolithDAO Token.sol
661    * @param spender The address which will spend the funds.
662    * @param subtractedValue The amount of tokens to decrease the allowance by.
663    */
664   function decreaseAllowance(
665     address spender,
666     uint256 subtractedValue
667   )
668     public
669     returns (bool)
670   {
671     require(spender != address(0));
672 
673     _allowed[msg.sender][spender] = (
674       _allowed[msg.sender][spender].sub(subtractedValue));
675     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
676     return true;
677   }
678 
679   /**
680   * @dev Transfer token for a specified addresses
681   * @param from The address to transfer from.
682   * @param to The address to transfer to.
683   * @param value The amount to be transferred.
684   */
685   function _transfer(address from, address to, uint256 value) internal {
686     require(value <= _balances[from]);
687     require(to != address(0));
688 
689     _balances[from] = _balances[from].sub(value);
690     _balances[to] = _balances[to].add(value);
691     emit Transfer(from, to, value);
692   }
693 
694   /**
695    * @dev Internal function that mints an amount of the token and assigns it to
696    * an account. This encapsulates the modification of balances such that the
697    * proper events are emitted.
698    * @param account The account that will receive the created tokens.
699    * @param value The amount that will be created.
700    */
701   function _mint(address account, uint256 value) internal {
702     require(account != 0);
703     _totalSupply = _totalSupply.add(value);
704     _balances[account] = _balances[account].add(value);
705     emit Transfer(address(0), account, value);
706   }
707 
708   /**
709    * @dev Internal function that burns an amount of the token of a given
710    * account.
711    * @param account The account whose tokens will be burnt.
712    * @param value The amount that will be burnt.
713    */
714   function _burn(address account, uint256 value) internal {
715     require(account != 0);
716     require(value <= _balances[account]);
717 
718     _totalSupply = _totalSupply.sub(value);
719     _balances[account] = _balances[account].sub(value);
720     emit Transfer(account, address(0), value);
721   }
722 
723   /**
724    * @dev Internal function that burns an amount of the token of a given
725    * account, deducting from the sender's allowance for said account. Uses the
726    * internal burn function.
727    * @param account The account whose tokens will be burnt.
728    * @param value The amount that will be burnt.
729    */
730   function _burnFrom(address account, uint256 value) internal {
731     require(value <= _allowed[account][msg.sender]);
732 
733     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
734     // this function needs to emit an event with the updated approval.
735     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
736       value);
737     _burn(account, value);
738   }
739 }
740 
741 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
742 
743 /**
744  * @title Burnable Token
745  * @dev Token that can be irreversibly burned (destroyed).
746  */
747 contract ERC20Burnable is ERC20 {
748 
749   /**
750    * @dev Burns a specific amount of tokens.
751    * @param value The amount of token to be burned.
752    */
753   function burn(uint256 value) public {
754     _burn(msg.sender, value);
755   }
756 
757   /**
758    * @dev Burns a specific amount of tokens from the target address and decrements allowance
759    * @param from address The address which you want to send tokens from
760    * @param value uint256 The amount of token to be burned
761    */
762   function burnFrom(address from, uint256 value) public {
763     _burnFrom(from, value);
764   }
765 }
766 
767 // File: contracts/misc/DutchAuction.sol
768 
769 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
770 /// @author Stefan George - <stefan.george@consensys.net>
771 /// @author Airalab - <research@aira.life> 
772 contract DutchAuction is SignatureBouncer {
773     using SafeERC20 for ERC20Burnable;
774 
775     /*
776      *  Events
777      */
778     event BidSubmission(address indexed sender, uint256 amount);
779 
780     /*
781      *  Constants
782      */
783     uint constant public WAITING_PERIOD = 0; // 1 days;
784 
785     /*
786      *  Storage
787      */
788     ERC20Burnable public token;
789     address public ambix;
790     address public wallet;
791     address public owner;
792     uint public maxTokenSold;
793     uint public ceiling;
794     uint public priceFactor;
795     uint public startBlock;
796     uint public endTime;
797     uint public totalReceived;
798     uint public finalPrice;
799     mapping (address => uint) public bids;
800     Stages public stage;
801 
802     /*
803      *  Enums
804      */
805     enum Stages {
806         AuctionDeployed,
807         AuctionSetUp,
808         AuctionStarted,
809         AuctionEnded,
810         TradingStarted
811     }
812 
813     /*
814      *  Modifiers
815      */
816     modifier atStage(Stages _stage) {
817         // Contract on stage
818         require(stage == _stage);
819         _;
820     }
821 
822     modifier isOwner() {
823         // Only owner is allowed to proceed
824         require(msg.sender == owner);
825         _;
826     }
827 
828     modifier isWallet() {
829         // Only wallet is allowed to proceed
830         require(msg.sender == wallet);
831         _;
832     }
833 
834     modifier isValidPayload() {
835         require(msg.data.length == 4 || msg.data.length == 164);
836         _;
837     }
838 
839     modifier timedTransitions() {
840         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
841             finalizeAuction();
842         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
843             stage = Stages.TradingStarted;
844         _;
845     }
846 
847     /*
848      *  Public functions
849      */
850     /// @dev Contract constructor function sets owner.
851     /// @param _wallet Multisig wallet.
852     /// @param _maxTokenSold Auction token balance.
853     /// @param _ceiling Auction ceiling.
854     /// @param _priceFactor Auction price factor.
855     constructor(address _wallet, uint _maxTokenSold, uint _ceiling, uint _priceFactor)
856         public
857     {
858         require(_wallet != 0 && _ceiling > 0 && _priceFactor > 0);
859 
860         owner = msg.sender;
861         wallet = _wallet;
862         maxTokenSold = _maxTokenSold;
863         ceiling = _ceiling;
864         priceFactor = _priceFactor;
865         stage = Stages.AuctionDeployed;
866     }
867 
868     /// @dev Setup function sets external contracts' addresses.
869     /// @param _token Token address.
870     /// @param _ambix Distillation cube address.
871     function setup(ERC20Burnable _token, address _ambix)
872         public
873         isOwner
874         atStage(Stages.AuctionDeployed)
875     {
876         // Validate argument
877         require(address(_token) != 0 && _ambix != 0);
878 
879         token = _token;
880         ambix = _ambix;
881 
882         // Validate token balance
883         require(token.balanceOf(this) == maxTokenSold);
884 
885         stage = Stages.AuctionSetUp;
886     }
887 
888     /// @dev Starts auction and sets startBlock.
889     function startAuction()
890         public
891         isWallet
892         atStage(Stages.AuctionSetUp)
893     {
894         stage = Stages.AuctionStarted;
895         startBlock = block.number;
896     }
897 
898     /// @dev Calculates current token price.
899     /// @return Returns token price.
900     function calcCurrentTokenPrice()
901         public
902         timedTransitions
903         returns (uint)
904     {
905         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
906             return finalPrice;
907         return calcTokenPrice();
908     }
909 
910     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
911     /// @return Returns current auction stage.
912     function updateStage()
913         public
914         timedTransitions
915         returns (Stages)
916     {
917         return stage;
918     }
919 
920     /// @dev Allows to send a bid to the auction.
921     /// @param signature KYC approvement
922     function bid(bytes signature)
923         public
924         payable
925         isValidPayload
926         timedTransitions
927         atStage(Stages.AuctionStarted)
928         onlyValidSignature(signature)
929         returns (uint amount)
930     {
931         require(msg.value > 0);
932         amount = msg.value;
933 
934         address receiver = msg.sender;
935 
936         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
937         uint maxWei = maxTokenSold * calcTokenPrice() / 10**9 - totalReceived;
938         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
939         if (maxWeiBasedOnTotalReceived < maxWei)
940             maxWei = maxWeiBasedOnTotalReceived;
941 
942         // Only invest maximum possible amount.
943         if (amount > maxWei) {
944             amount = maxWei;
945             // Send change back to receiver address.
946             receiver.transfer(msg.value - amount);
947         }
948 
949         // Forward funding to ether wallet
950         wallet.transfer(amount);
951 
952         bids[receiver] += amount;
953         totalReceived += amount;
954         emit BidSubmission(receiver, amount);
955 
956         // Finalize auction when maxWei reached
957         if (amount == maxWei)
958             finalizeAuction();
959     }
960 
961     /// @dev Claims tokens for bidder after auction.
962     function claimTokens()
963         public
964         isValidPayload
965         timedTransitions
966         atStage(Stages.TradingStarted)
967     {
968         address receiver = msg.sender;
969         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
970         bids[receiver] = 0;
971         token.safeTransfer(receiver, tokenCount);
972     }
973 
974     /// @dev Calculates stop price.
975     /// @return Returns stop price.
976     function calcStopPrice()
977         view
978         public
979         returns (uint)
980     {
981         return totalReceived * 10**9 / maxTokenSold + 1;
982     }
983 
984     /// @dev Calculates token price.
985     /// @return Returns token price.
986     function calcTokenPrice()
987         view
988         public
989         returns (uint)
990     {
991         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
992     }
993 
994     /*
995      *  Private functions
996      */
997     function finalizeAuction()
998         private
999     {
1000         stage = Stages.AuctionEnded;
1001         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
1002         uint soldTokens = totalReceived * 10**9 / finalPrice;
1003 
1004         if (totalReceived == ceiling) {
1005             // Auction contract transfers all unsold tokens to Ambix contract
1006             token.safeTransfer(ambix, maxTokenSold - soldTokens);
1007         } else {
1008             // Auction contract burn all unsold tokens
1009             token.burn(maxTokenSold - soldTokens);
1010         }
1011 
1012         endTime = now;
1013     }
1014 }
1015 
1016 // File: contracts/misc/SharedCode.sol
1017 
1018 // Inspired by https://github.com/GNSPS/2DProxy
1019 library SharedCode {
1020     /**
1021      * @dev Create tiny proxy without constructor
1022      * @param _shared Shared code contract address
1023      */
1024     function proxy(address _shared) internal returns (address instance) {
1025         bytes memory code = abi.encodePacked(
1026             hex"603160008181600b9039f3600080808080368092803773",
1027             _shared, hex"5af43d828181803e808314603057f35bfd"
1028         );
1029         assembly {
1030             instance := create(0, add(code, 0x20), 60)
1031             if iszero(extcodesize(instance)) {
1032                 revert(0, 0)
1033             }
1034         }
1035     }
1036 }
1037 
1038 // File: contracts/robonomics/interface/ILiability.sol
1039 
1040 /**
1041  * @title Standard liability smart contract interface
1042  */
1043 contract ILiability {
1044     /**
1045      * @dev Liability termination signal
1046      */
1047     event Finalized(bool indexed success, bytes result);
1048 
1049     /**
1050      * @dev Behaviour model multihash
1051      */
1052     bytes public model;
1053 
1054     /**
1055      * @dev Objective ROSBAG multihash
1056      * @notice ROSBAGv2 is used: http://wiki.ros.org/Bags/Format/2.0 
1057      */
1058     bytes public objective;
1059 
1060     /**
1061      * @dev Report ROSBAG multihash 
1062      * @notice ROSBAGv2 is used: http://wiki.ros.org/Bags/Format/2.0 
1063      */
1064     bytes public result;
1065 
1066     /**
1067      * @dev Payment token address
1068      */
1069     address public token;
1070 
1071     /**
1072      * @dev Liability cost
1073      */
1074     uint256 public cost;
1075 
1076     /**
1077      * @dev Lighthouse fee in wn
1078      */
1079     uint256 public lighthouseFee;
1080 
1081     /**
1082      * @dev Validator fee in wn
1083      */
1084     uint256 public validatorFee;
1085 
1086     /**
1087      * @dev Robonomics demand message hash
1088      */
1089     bytes32 public demandHash;
1090 
1091     /**
1092      * @dev Robonomics offer message hash
1093      */
1094     bytes32 public offerHash;
1095 
1096     /**
1097      * @dev Liability promisor address
1098      */
1099     address public promisor;
1100 
1101     /**
1102      * @dev Liability promisee address
1103      */
1104     address public promisee;
1105 
1106     /**
1107      * @dev Lighthouse assigned to this liability
1108      */
1109     address public lighthouse;
1110 
1111     /**
1112      * @dev Liability validator address
1113      */
1114     address public validator;
1115 
1116     /**
1117      * @dev Liability success flag
1118      */
1119     bool public isSuccess;
1120 
1121     /**
1122      * @dev Liability finalization status flag
1123      */
1124     bool public isFinalized;
1125 
1126     /**
1127      * @dev Deserialize robonomics demand message
1128      * @notice It can be called by factory only
1129      */
1130     function demand(
1131         bytes   _model,
1132         bytes   _objective,
1133 
1134         address _token,
1135         uint256 _cost,
1136 
1137         address _lighthouse,
1138 
1139         address _validator,
1140         uint256 _validator_fee,
1141 
1142         uint256 _deadline,
1143         bytes32 _nonce,
1144         bytes   _signature
1145     ) external returns (bool);
1146 
1147     /**
1148      * @dev Deserialize robonomics offer message
1149      * @notice It can be called by factory only
1150      */
1151     function offer(
1152         bytes   _model,
1153         bytes   _objective,
1154         
1155         address _token,
1156         uint256 _cost,
1157 
1158         address _validator,
1159 
1160         address _lighthouse,
1161         uint256 _lighthouse_fee,
1162 
1163         uint256 _deadline,
1164         bytes32 _nonce,
1165         bytes   _signature
1166     ) external returns (bool);
1167 
1168     /**
1169      * @dev Finalize liability contract
1170      * @param _result Result data hash
1171      * @param _success Set 'true' when liability has success result
1172      * @param _signature Result signature: liability address, result and success flag signed by promisor
1173      * @notice It can be called by assigned lighthouse only
1174      */
1175     function finalize(bytes _result, bool  _success, bytes _signature) external returns (bool);
1176 }
1177 
1178 // File: contracts/robonomics/interface/ILighthouse.sol
1179 
1180 /**
1181  * @title Robonomics lighthouse contract interface
1182  */
1183 contract ILighthouse {
1184     /**
1185      * @dev Provider going online
1186      */
1187     event Online(address indexed provider);
1188 
1189     /**
1190      * @dev Provider going offline
1191      */
1192     event Offline(address indexed provider);
1193 
1194     /**
1195      * @dev Active robonomics provider
1196      */
1197     event Current(address indexed provider, uint256 indexed quota);
1198 
1199     /**
1200      * @dev Robonomics providers list
1201      */
1202     address[] public providers;
1203 
1204     /**
1205      * @dev Count of robonomics providers on this lighthouse
1206      */
1207     function providersLength() public view returns (uint256)
1208     { return providers.length; }
1209 
1210     /**
1211      * @dev Provider stake distribution
1212      */
1213     mapping(address => uint256) public stakes;
1214 
1215     /**
1216      * @dev Minimal stake to get one quota
1217      */
1218     uint256 public minimalStake;
1219 
1220     /**
1221      * @dev Silence timeout for provider in blocks
1222      */
1223     uint256 public timeoutInBlocks;
1224 
1225     /**
1226      * @dev Block number of last transaction from current provider
1227      */
1228     uint256 public keepAliveBlock;
1229 
1230     /**
1231      * @dev Round robin provider list marker
1232      */
1233     uint256 public marker;
1234 
1235     /**
1236      * @dev Current provider quota
1237      */
1238     uint256 public quota;
1239 
1240     /**
1241      * @dev Get quota of provider
1242      */
1243     function quotaOf(address _provider) public view returns (uint256)
1244     { return stakes[_provider] / minimalStake; }
1245 
1246     /**
1247      * @dev Increase stake and get more quota,
1248      *      one quota - one transaction in round
1249      * @param _value in wn
1250      * @notice XRT should be approved before call this 
1251      */
1252     function refill(uint256 _value) external returns (bool);
1253 
1254     /**
1255      * @dev Decrease stake and get XRT back
1256      * @param _value in wn
1257      */
1258     function withdraw(uint256 _value) external returns (bool);
1259 
1260     /**
1261      * @dev Create liability smart contract assigned to this lighthouse
1262      * @param _demand ABI-encoded demand message
1263      * @param _offer ABI-encoded offer message
1264      * @notice Only current provider can call it
1265      */
1266     function createLiability(bytes _demand, bytes _offer) external returns (bool);
1267 
1268     /**
1269      * @dev Finalize liability smart contract assigned to this lighthouse
1270      * @param _liability smart contract address
1271      * @param _result report of work
1272      * @param _success work success flag
1273      * @param _signature work signature
1274      */
1275     function finalizeLiability(address _liability, bytes _result, bool _success, bytes _signature) external returns (bool);
1276 }
1277 
1278 // File: contracts/robonomics/interface/IFactory.sol
1279 
1280 /**
1281  * @title Robonomics liability factory interface
1282  */
1283 contract IFactory {
1284     /**
1285      * @dev New liability created 
1286      */
1287     event NewLiability(address indexed liability);
1288 
1289     /**
1290      * @dev New lighthouse created
1291      */
1292     event NewLighthouse(address indexed lighthouse, string name);
1293 
1294     /**
1295      * @dev Lighthouse address mapping
1296      */
1297     mapping(address => bool) public isLighthouse;
1298 
1299     /**
1300      * @dev Total GAS utilized by Robonomics network
1301      */
1302     uint256 public totalGasConsumed = 0;
1303 
1304     /**
1305      * @dev GAS utilized by liability contracts
1306      */
1307     mapping(address => uint256) public gasConsumedOf;
1308 
1309     /**
1310      * @dev The count of consumed gas for switch to next epoch 
1311      */
1312     uint256 public constant gasEpoch = 347 * 10**10;
1313 
1314     /**
1315      * @dev Current gas price in wei
1316      */
1317     uint256 public gasPrice = 10 * 10**9;
1318 
1319     /**
1320      * @dev XRT emission value for consumed gas
1321      * @param _gas Gas consumed by robonomics program
1322      */
1323     function wnFromGas(uint256 _gas) public view returns (uint256);
1324 
1325     /**
1326      * @dev Create lighthouse smart contract
1327      * @param _minimalStake Minimal stake value of XRT token (one quota price)
1328      * @param _timeoutInBlocks Max time of lighthouse silence in blocks
1329      * @param _name Lighthouse name,
1330      *              example: 'my-name' will create 'my-name.lighthouse.4.robonomics.eth' domain
1331      */
1332     function createLighthouse(uint256 _minimalStake, uint256 _timeoutInBlocks, string _name) external returns (ILighthouse);
1333 
1334     /**
1335      * @dev Create robot liability smart contract
1336      * @param _demand ABI-encoded demand message
1337      * @param _offer ABI-encoded offer message
1338      * @notice This method is for lighthouse contract use only
1339      */
1340     function createLiability(bytes _demand, bytes _offer) external returns (ILiability);
1341 
1342     /**
1343      * @dev Is called after liability creation
1344      * @param _liability Liability contract address
1345      * @param _start_gas Transaction start gas level
1346      * @notice This method is for lighthouse contract use only
1347      */
1348     function liabilityCreated(ILiability _liability, uint256 _start_gas) external returns (bool);
1349 
1350     /**
1351      * @dev Is called after liability finalization
1352      * @param _liability Liability contract address
1353      * @param _start_gas Transaction start gas level
1354      * @notice This method is for lighthouse contract use only
1355      */
1356     function liabilityFinalized(ILiability _liability, uint256 _start_gas) external returns (bool);
1357 }
1358 
1359 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1360 
1361 contract MinterRole {
1362   using Roles for Roles.Role;
1363 
1364   event MinterAdded(address indexed account);
1365   event MinterRemoved(address indexed account);
1366 
1367   Roles.Role private minters;
1368 
1369   constructor() internal {
1370     _addMinter(msg.sender);
1371   }
1372 
1373   modifier onlyMinter() {
1374     require(isMinter(msg.sender));
1375     _;
1376   }
1377 
1378   function isMinter(address account) public view returns (bool) {
1379     return minters.has(account);
1380   }
1381 
1382   function addMinter(address account) public onlyMinter {
1383     _addMinter(account);
1384   }
1385 
1386   function renounceMinter() public {
1387     _removeMinter(msg.sender);
1388   }
1389 
1390   function _addMinter(address account) internal {
1391     minters.add(account);
1392     emit MinterAdded(account);
1393   }
1394 
1395   function _removeMinter(address account) internal {
1396     minters.remove(account);
1397     emit MinterRemoved(account);
1398   }
1399 }
1400 
1401 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
1402 
1403 /**
1404  * @title ERC20Mintable
1405  * @dev ERC20 minting logic
1406  */
1407 contract ERC20Mintable is ERC20, MinterRole {
1408   /**
1409    * @dev Function to mint tokens
1410    * @param to The address that will receive the minted tokens.
1411    * @param value The amount of tokens to mint.
1412    * @return A boolean that indicates if the operation was successful.
1413    */
1414   function mint(
1415     address to,
1416     uint256 value
1417   )
1418     public
1419     onlyMinter
1420     returns (bool)
1421   {
1422     _mint(to, value);
1423     return true;
1424   }
1425 }
1426 
1427 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1428 
1429 /**
1430  * @title ERC20Detailed token
1431  * @dev The decimals are only for visualization purposes.
1432  * All the operations are done using the smallest and indivisible token unit,
1433  * just as on Ethereum all the operations are done in wei.
1434  */
1435 contract ERC20Detailed is IERC20 {
1436   string private _name;
1437   string private _symbol;
1438   uint8 private _decimals;
1439 
1440   constructor(string name, string symbol, uint8 decimals) public {
1441     _name = name;
1442     _symbol = symbol;
1443     _decimals = decimals;
1444   }
1445 
1446   /**
1447    * @return the name of the token.
1448    */
1449   function name() public view returns(string) {
1450     return _name;
1451   }
1452 
1453   /**
1454    * @return the symbol of the token.
1455    */
1456   function symbol() public view returns(string) {
1457     return _symbol;
1458   }
1459 
1460   /**
1461    * @return the number of decimals of the token.
1462    */
1463   function decimals() public view returns(uint8) {
1464     return _decimals;
1465   }
1466 }
1467 
1468 // File: contracts/robonomics/XRT.sol
1469 
1470 contract XRT is ERC20Mintable, ERC20Burnable, ERC20Detailed {
1471     constructor(uint256 _initial_supply) public ERC20Detailed("Robonomics Beta 4", "XRT", 9) {
1472         _mint(msg.sender, _initial_supply);
1473     }
1474 }
1475 
1476 // File: contracts/robonomics/Lighthouse.sol
1477 
1478 contract Lighthouse is ILighthouse {
1479     using SafeERC20 for XRT;
1480 
1481     IFactory public factory;
1482     XRT      public xrt;
1483 
1484     function setup(XRT _xrt, uint256 _minimalStake, uint256 _timeoutInBlocks) external returns (bool) {
1485         require(address(factory) == 0 && _minimalStake > 0 && _timeoutInBlocks > 0);
1486 
1487         minimalStake    = _minimalStake;
1488         timeoutInBlocks = _timeoutInBlocks;
1489         factory         = IFactory(msg.sender);
1490         xrt             = _xrt;
1491 
1492         return true;
1493     }
1494 
1495     /**
1496      * @dev Providers index, started from 1
1497      */
1498     mapping(address => uint256) public indexOf;
1499 
1500     function refill(uint256 _value) external returns (bool) {
1501         xrt.safeTransferFrom(msg.sender, this, _value);
1502 
1503         if (stakes[msg.sender] == 0) {
1504             require(_value >= minimalStake);
1505             providers.push(msg.sender);
1506             indexOf[msg.sender] = providers.length;
1507             emit Online(msg.sender);
1508         }
1509 
1510         stakes[msg.sender] += _value;
1511         return true;
1512     }
1513 
1514     function withdraw(uint256 _value) external returns (bool) {
1515         require(stakes[msg.sender] >= _value);
1516 
1517         stakes[msg.sender] -= _value;
1518         xrt.safeTransfer(msg.sender, _value);
1519 
1520         // Drop member with zero quota
1521         if (quotaOf(msg.sender) == 0) {
1522             uint256 balance = stakes[msg.sender];
1523             stakes[msg.sender] = 0;
1524             xrt.safeTransfer(msg.sender, balance);
1525             
1526             uint256 senderIndex = indexOf[msg.sender] - 1;
1527             uint256 lastIndex = providers.length - 1;
1528             if (senderIndex < lastIndex)
1529                 providers[senderIndex] = providers[lastIndex];
1530 
1531             providers.length -= 1;
1532             indexOf[msg.sender] = 0;
1533 
1534             emit Offline(msg.sender);
1535         }
1536         return true;
1537     }
1538 
1539     function keepAliveTransaction() internal {
1540         if (timeoutInBlocks < block.number - keepAliveBlock) {
1541             // Set up the marker according to provider index
1542             marker = indexOf[msg.sender];
1543 
1544             // Thransaction sender should be a registered provider
1545             require(marker > 0 && marker <= providers.length);
1546 
1547             // Allocate new quota
1548             quota = quotaOf(providers[marker - 1]);
1549 
1550             // Current provider signal
1551             emit Current(providers[marker - 1], quota);
1552         }
1553 
1554         // Store transaction sending block
1555         keepAliveBlock = block.number;
1556     }
1557 
1558     function quotedTransaction() internal {
1559         // Don't premit transactions without providers on board
1560         require(providers.length > 0);
1561 
1562         // Zero quota guard
1563         // XXX: When quota for some reasons is zero, DoS will be preverted by keepalive transaction
1564         require(quota > 0);
1565 
1566         // Only provider with marker can to send transaction
1567         require(msg.sender == providers[marker - 1]);
1568 
1569         // Consume one quota for transaction sending
1570         if (quota > 1) {
1571             quota -= 1;
1572         } else {
1573             // Step over marker
1574             marker = marker % providers.length + 1;
1575 
1576             // Allocate new quota
1577             quota = quotaOf(providers[marker - 1]);
1578 
1579             // Current provider signal
1580             emit Current(providers[marker - 1], quota);
1581         }
1582     }
1583 
1584     function startGas() internal view returns (uint256 gas) {
1585         // the total amount of gas the tx is DataFee + TxFee + ExecutionGas
1586         // ExecutionGas
1587         gas = gasleft();
1588         // TxFee
1589         gas += 21000;
1590         // DataFee
1591         for (uint256 i = 0; i < msg.data.length; ++i)
1592             gas += msg.data[i] == 0 ? 4 : 68;
1593     }
1594 
1595     function createLiability(
1596         bytes _demand,
1597         bytes _offer
1598     )
1599         external
1600         returns (bool)
1601     {
1602         // Gas with estimation error
1603         uint256 gas = startGas() + 20311;
1604 
1605         keepAliveTransaction();
1606         quotedTransaction();
1607 
1608         ILiability liability = factory.createLiability(_demand, _offer);
1609         require(address(liability) != 0);
1610         require(factory.liabilityCreated(liability, gas - gasleft()));
1611         return true;
1612     }
1613 
1614     function finalizeLiability(
1615         address _liability,
1616         bytes _result,
1617         bool _success,
1618         bytes _signature
1619     )
1620         external
1621         returns (bool)
1622     {
1623         // Gas with estimation error
1624         uint256 gas = startGas() + 23441;
1625 
1626         keepAliveTransaction();
1627         quotedTransaction();
1628 
1629         ILiability liability = ILiability(_liability);
1630         require(factory.gasConsumedOf(_liability) > 0);
1631         require(liability.finalize(_result, _success, _signature));
1632         require(factory.liabilityFinalized(liability, gas - gasleft()));
1633         return true;
1634     }
1635 }
1636 
1637 // File: contracts/robonomics/interface/IValidator.sol
1638 
1639 /**
1640  * @dev Observing network contract interface
1641  */
1642 contract IValidator {
1643     /**
1644      * @dev Final liability decision
1645      */
1646     event Decision(address indexed liability, bool indexed success);
1647 
1648     /**
1649      * @dev Decision availability marker 
1650      */
1651     mapping(address => bool) public hasDecision;
1652 
1653     /**
1654      * @dev Get decision of liability, is used by liability contract only
1655      * @notice Transaction will fail when have no decision
1656      */
1657     function decision() external returns (bool);
1658 }
1659 
1660 // File: contracts/robonomics/Liability.sol
1661 
1662 contract Liability is ILiability {
1663     using ECDSA for bytes32;
1664     using SafeERC20 for XRT;
1665     using SafeERC20 for ERC20;
1666 
1667     address public factory;
1668     XRT     public xrt;
1669 
1670     function setup(XRT _xrt) external returns (bool) {
1671         require(factory == 0);
1672 
1673         factory = msg.sender;
1674         xrt     = _xrt;
1675 
1676         return true;
1677     }
1678 
1679     function demand(
1680         bytes   _model,
1681         bytes   _objective,
1682 
1683         address _token,
1684         uint256 _cost,
1685 
1686         address _lighthouse,
1687 
1688         address _validator,
1689         uint256 _validator_fee,
1690 
1691         uint256 _deadline,
1692         bytes32 _nonce,
1693         bytes   _signature
1694     )
1695         external
1696         returns (bool)
1697     {
1698         require(msg.sender == factory);
1699         require(block.number < _deadline);
1700 
1701         model        = _model;
1702         objective    = _objective;
1703         token        = _token;
1704         cost         = _cost;
1705         lighthouse   = _lighthouse;
1706         validator    = _validator;
1707         validatorFee = _validator_fee;
1708 
1709         demandHash = keccak256(abi.encodePacked(
1710             _model
1711           , _objective
1712           , _token
1713           , _cost
1714           , _lighthouse
1715           , _validator
1716           , _validator_fee
1717           , _deadline
1718           , _nonce
1719         ));
1720 
1721         promisee = demandHash
1722             .toEthSignedMessageHash()
1723             .recover(_signature);
1724         return true;
1725     }
1726 
1727     function offer(
1728         bytes   _model,
1729         bytes   _objective,
1730         
1731         address _token,
1732         uint256 _cost,
1733 
1734         address _validator,
1735 
1736         address _lighthouse,
1737         uint256 _lighthouse_fee,
1738 
1739         uint256 _deadline,
1740         bytes32 _nonce,
1741         bytes   _signature
1742     )
1743         external
1744         returns (bool)
1745     {
1746         require(msg.sender == factory);
1747         require(block.number < _deadline);
1748         require(keccak256(model) == keccak256(_model));
1749         require(keccak256(objective) == keccak256(_objective));
1750         require(_token == token);
1751         require(_cost == cost);
1752         require(_lighthouse == lighthouse);
1753         require(_validator == validator);
1754 
1755         lighthouseFee = _lighthouse_fee;
1756 
1757         offerHash = keccak256(abi.encodePacked(
1758             _model
1759           , _objective
1760           , _token
1761           , _cost
1762           , _validator
1763           , _lighthouse
1764           , _lighthouse_fee
1765           , _deadline
1766           , _nonce
1767         ));
1768 
1769         promisor = offerHash
1770             .toEthSignedMessageHash()
1771             .recover(_signature);
1772         return true;
1773     }
1774 
1775     function finalize(
1776         bytes _result,
1777         bool  _success,
1778         bytes _signature
1779     )
1780         external
1781         returns (bool)
1782     {
1783         require(msg.sender == lighthouse);
1784         require(!isFinalized);
1785 
1786         address resultSender = keccak256(abi.encodePacked(this, _result, _success))
1787             .toEthSignedMessageHash()
1788             .recover(_signature);
1789         require(resultSender == promisor);
1790 
1791         isFinalized = true;
1792         result      = _result;
1793 
1794         if (validator == 0) {
1795             // Set state of liability according promisor report only
1796             isSuccess = _success;
1797         } else {
1798             // Validator can take a fee for decision
1799             xrt.safeApprove(validator, validatorFee);
1800             // Set state of liability considering validator decision
1801             isSuccess = _success && IValidator(validator).decision();
1802         }
1803 
1804         if (cost > 0)
1805             ERC20(token).safeTransfer(isSuccess ? promisor : promisee, cost);
1806 
1807         emit Finalized(isSuccess, result);
1808         return true;
1809     }
1810 }
1811 
1812 // File: contracts/robonomics/Factory.sol
1813 
1814 contract Factory is IFactory, SingletonHash {
1815     constructor(
1816         address _liability,
1817         address _lighthouse,
1818         DutchAuction _auction,
1819         AbstractENS _ens,
1820         XRT _xrt
1821     ) public {
1822         liabilityCode = _liability;
1823         lighthouseCode = _lighthouse;
1824         auction = _auction;
1825         ens = _ens;
1826         xrt = _xrt;
1827     }
1828 
1829     address public liabilityCode;
1830     address public lighthouseCode;
1831 
1832     using SafeERC20 for XRT;
1833     using SafeERC20 for ERC20;
1834     using SharedCode for address;
1835 
1836     /**
1837      * @dev Robonomics dutch auction contract
1838      */
1839     DutchAuction public auction;
1840 
1841     /**
1842      * @dev Ethereum name system
1843      */
1844     AbstractENS public ens;
1845 
1846     /**
1847      * @dev Robonomics network protocol token
1848      */
1849     XRT public xrt;
1850 
1851     /**
1852      * @dev SMMA filter with function: SMMA(i) = (SMMA(i-1)*(n-1) + PRICE(i)) / n
1853      * @param _prePrice PRICE[n-1]
1854      * @param _price PRICE[n]
1855      * @return filtered price
1856      */
1857     function smma(uint256 _prePrice, uint256 _price) internal pure returns (uint256) {
1858         return (_prePrice * (smmaPeriod - 1) + _price) / smmaPeriod;
1859     }
1860 
1861     /**
1862      * @dev SMMA filter period
1863      */
1864     uint256 private constant smmaPeriod = 100;
1865 
1866     /**
1867      * @dev XRT emission value for utilized gas
1868      */
1869     function wnFromGas(uint256 _gas) public view returns (uint256) {
1870         // Just return wn=gas when auction isn't finish
1871         if (auction.finalPrice() == 0)
1872             return _gas;
1873 
1874         // Current gas utilization epoch
1875         uint256 epoch = totalGasConsumed / gasEpoch;
1876 
1877         // XRT emission with addition coefficient by gas utilzation epoch
1878         uint256 wn = _gas * 10**9 * gasPrice * 2**epoch / 3**epoch / auction.finalPrice();
1879 
1880         // Check to not permit emission decrease below wn=gas
1881         return wn < _gas ? _gas : wn;
1882     }
1883 
1884     modifier onlyLighthouse {
1885         require(isLighthouse[msg.sender]);
1886 
1887         _;
1888     }
1889 
1890     modifier gasPriceEstimate {
1891         gasPrice = smma(gasPrice, tx.gasprice);
1892 
1893         _;
1894     }
1895 
1896     function createLighthouse(
1897         uint256 _minimalStake,
1898         uint256 _timeoutInBlocks,
1899         string  _name
1900     )
1901         external
1902         returns (ILighthouse lighthouse)
1903     {
1904         bytes32 LIGHTHOUSE_NODE
1905             // lighthouse.4.robonomics.eth
1906             = 0xbb02fe616f0926339902db4d17f52c2dfdb337f2a010da2743a8dbdac12d56f9;
1907         bytes32 hname = keccak256(bytes(_name));
1908 
1909         // Name reservation check
1910         bytes32 subnode = keccak256(abi.encodePacked(LIGHTHOUSE_NODE, hname));
1911         require(ens.resolver(subnode) == 0);
1912 
1913         // Create lighthouse
1914         lighthouse = ILighthouse(lighthouseCode.proxy());
1915         require(Lighthouse(lighthouse).setup(xrt, _minimalStake, _timeoutInBlocks));
1916 
1917         emit NewLighthouse(lighthouse, _name);
1918         isLighthouse[lighthouse] = true;
1919 
1920         // Register subnode
1921         ens.setSubnodeOwner(LIGHTHOUSE_NODE, hname, this);
1922 
1923         // Register lighthouse address
1924         AbstractResolver resolver = AbstractResolver(ens.resolver(LIGHTHOUSE_NODE));
1925         ens.setResolver(subnode, resolver);
1926         resolver.setAddr(subnode, lighthouse);
1927     }
1928 
1929     function createLiability(
1930         bytes _demand,
1931         bytes _offer
1932     )
1933         external
1934         onlyLighthouse
1935         returns (ILiability liability)
1936     {
1937         // Create liability
1938         liability = ILiability(liabilityCode.proxy());
1939         require(Liability(liability).setup(xrt));
1940 
1941         emit NewLiability(liability);
1942 
1943         // Parse messages
1944         require(address(liability).call(abi.encodePacked(bytes4(0xd9ff764a), _demand))); // liability.demand(...)
1945         singletonHash(liability.demandHash());
1946 
1947         require(address(liability).call(abi.encodePacked(bytes4(0xd5056962), _offer))); // liability.offer(...)
1948         singletonHash(liability.offerHash());
1949 
1950         // Check lighthouse
1951         require(isLighthouse[liability.lighthouse()]);
1952 
1953         // Transfer lighthouse fee to lighthouse worker directly
1954         if (liability.lighthouseFee() > 0)
1955             xrt.safeTransferFrom(liability.promisor(),
1956                                  tx.origin,
1957                                  liability.lighthouseFee());
1958 
1959         // Transfer liability security and hold on contract
1960         ERC20 token = ERC20(liability.token());
1961         if (liability.cost() > 0)
1962             token.safeTransferFrom(liability.promisee(),
1963                                    liability,
1964                                    liability.cost());
1965 
1966         // Transfer validator fee and hold on contract
1967         if (liability.validator() != 0 && liability.validatorFee() > 0)
1968             xrt.safeTransferFrom(liability.promisee(),
1969                                  liability,
1970                                  liability.validatorFee());
1971      }
1972 
1973     function liabilityCreated(
1974         ILiability _liability,
1975         uint256 _gas
1976     )
1977         external
1978         onlyLighthouse
1979         gasPriceEstimate
1980         returns (bool)
1981     {
1982         totalGasConsumed          += _gas;
1983         gasConsumedOf[_liability] += _gas;
1984         return true;
1985     }
1986 
1987     function liabilityFinalized(
1988         ILiability _liability,
1989         uint256 _gas
1990     )
1991         external
1992         onlyLighthouse
1993         gasPriceEstimate
1994         returns (bool)
1995     {
1996         totalGasConsumed          += _gas;
1997         gasConsumedOf[_liability] += _gas;
1998         require(xrt.mint(tx.origin, wnFromGas(gasConsumedOf[_liability])));
1999         return true;
2000     }
2001 }