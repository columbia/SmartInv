1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/access/Roles.sol
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10   struct Role {
11     mapping (address => bool) bearer;
12   }
13 
14   /**
15    * @dev give an account access to this role
16    */
17   function add(Role storage role, address account) internal {
18     require(account != address(0));
19     require(!has(role, account));
20 
21     role.bearer[account] = true;
22   }
23 
24   /**
25    * @dev remove an account's access to this role
26    */
27   function remove(Role storage role, address account) internal {
28     require(account != address(0));
29     require(has(role, account));
30 
31     role.bearer[account] = false;
32   }
33 
34   /**
35    * @dev check if an account has this role
36    * @return bool
37    */
38   function has(Role storage role, address account)
39     internal
40     view
41     returns (bool)
42   {
43     require(account != address(0));
44     return role.bearer[account];
45   }
46 }
47 
48 // File: openzeppelin-solidity/contracts/access/roles/SignerRole.sol
49 
50 contract SignerRole {
51   using Roles for Roles.Role;
52 
53   event SignerAdded(address indexed account);
54   event SignerRemoved(address indexed account);
55 
56   Roles.Role private signers;
57 
58   constructor() internal {
59     _addSigner(msg.sender);
60   }
61 
62   modifier onlySigner() {
63     require(isSigner(msg.sender));
64     _;
65   }
66 
67   function isSigner(address account) public view returns (bool) {
68     return signers.has(account);
69   }
70 
71   function addSigner(address account) public onlySigner {
72     _addSigner(account);
73   }
74 
75   function renounceSigner() public {
76     _removeSigner(msg.sender);
77   }
78 
79   function _addSigner(address account) internal {
80     signers.add(account);
81     emit SignerAdded(account);
82   }
83 
84   function _removeSigner(address account) internal {
85     signers.remove(account);
86     emit SignerRemoved(account);
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
91 
92 /**
93  * @title Elliptic curve signature operations
94  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
95  * TODO Remove this library once solidity supports passing a signature to ecrecover.
96  * See https://github.com/ethereum/solidity/issues/864
97  */
98 
99 library ECDSA {
100 
101   /**
102    * @dev Recover signer address from a message by using their signature
103    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
104    * @param signature bytes signature, the signature is generated using web3.eth.sign()
105    */
106   function recover(bytes32 hash, bytes signature)
107     internal
108     pure
109     returns (address)
110   {
111     bytes32 r;
112     bytes32 s;
113     uint8 v;
114 
115     // Check the signature length
116     if (signature.length != 65) {
117       return (address(0));
118     }
119 
120     // Divide the signature in r, s and v variables
121     // ecrecover takes the signature parameters, and the only way to get them
122     // currently is to use assembly.
123     // solium-disable-next-line security/no-inline-assembly
124     assembly {
125       r := mload(add(signature, 0x20))
126       s := mload(add(signature, 0x40))
127       v := byte(0, mload(add(signature, 0x60)))
128     }
129 
130     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
131     if (v < 27) {
132       v += 27;
133     }
134 
135     // If the version is correct return the signer address
136     if (v != 27 && v != 28) {
137       return (address(0));
138     } else {
139       // solium-disable-next-line arg-overflow
140       return ecrecover(hash, v, r, s);
141     }
142   }
143 
144   /**
145    * toEthSignedMessageHash
146    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
147    * and hash the result
148    */
149   function toEthSignedMessageHash(bytes32 hash)
150     internal
151     pure
152     returns (bytes32)
153   {
154     // 32 is the length in bytes of hash,
155     // enforced by the type signature above
156     return keccak256(
157       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
158     );
159   }
160 }
161 
162 // File: openzeppelin-solidity/contracts/drafts/SignatureBouncer.sol
163 
164 /**
165  * @title SignatureBouncer
166  * @author PhABC, Shrugs and aflesher
167  * @dev SignatureBouncer allows users to submit a signature as a permission to
168  * do an action.
169  * If the signature is from one of the authorized signer addresses, the
170  * signature is valid.
171  * Note that SignatureBouncer offers no protection against replay attacks, users
172  * must add this themselves!
173  *
174  * Signer addresses can be individual servers signing grants or different
175  * users within a decentralized club that have permission to invite other
176  * members. This technique is useful for whitelists and airdrops; instead of
177  * putting all valid addresses on-chain, simply sign a grant of the form
178  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a
179  * valid signer address.
180  * Then restrict access to your crowdsale/whitelist/airdrop using the
181  * `onlyValidSignature` modifier (or implement your own using _isValidSignature).
182  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
183  * `onlyValidSignatureAndData` can be used to restrict access to only a given
184  * method or a given method with given parameters respectively.
185  * See the tests in SignatureBouncer.test.js for specific usage examples.
186  *
187  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make
188  * the _signature parameter the "last" parameter. You cannot sign a message that
189  * has its own signature in it so the last 128 bytes of msg.data (which
190  * represents the length of the _signature data and the _signaature data itself)
191  * is ignored when validating. Also non fixed sized parameters make constructing
192  * the data in the signature much more complex.
193  * See https://ethereum.stackexchange.com/a/50616 for more details.
194  */
195 contract SignatureBouncer is SignerRole {
196   using ECDSA for bytes32;
197 
198   // Function selectors are 4 bytes long, as documented in
199   // https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector
200   uint256 private constant _METHOD_ID_SIZE = 4;
201   // Signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
202   uint256 private constant _SIGNATURE_SIZE = 96;
203 
204   constructor() internal {}
205 
206   /**
207    * @dev requires that a valid signature of a signer was provided
208    */
209   modifier onlyValidSignature(bytes signature)
210   {
211     require(_isValidSignature(msg.sender, signature));
212     _;
213   }
214 
215   /**
216    * @dev requires that a valid signature with a specifed method of a signer was provided
217    */
218   modifier onlyValidSignatureAndMethod(bytes signature)
219   {
220     require(_isValidSignatureAndMethod(msg.sender, signature));
221     _;
222   }
223 
224   /**
225    * @dev requires that a valid signature with a specifed method and params of a signer was provided
226    */
227   modifier onlyValidSignatureAndData(bytes signature)
228   {
229     require(_isValidSignatureAndData(msg.sender, signature));
230     _;
231   }
232 
233   /**
234    * @dev is the signature of `this + sender` from a signer?
235    * @return bool
236    */
237   function _isValidSignature(address account, bytes signature)
238     internal
239     view
240     returns (bool)
241   {
242     return _isValidDataHash(
243       keccak256(abi.encodePacked(address(this), account)),
244       signature
245     );
246   }
247 
248   /**
249    * @dev is the signature of `this + sender + methodId` from a signer?
250    * @return bool
251    */
252   function _isValidSignatureAndMethod(address account, bytes signature)
253     internal
254     view
255     returns (bool)
256   {
257     bytes memory data = new bytes(_METHOD_ID_SIZE);
258     for (uint i = 0; i < data.length; i++) {
259       data[i] = msg.data[i];
260     }
261     return _isValidDataHash(
262       keccak256(abi.encodePacked(address(this), account, data)),
263       signature
264     );
265   }
266 
267   /**
268     * @dev is the signature of `this + sender + methodId + params(s)` from a signer?
269     * @notice the signature parameter of the method being validated must be the "last" parameter
270     * @return bool
271     */
272   function _isValidSignatureAndData(address account, bytes signature)
273     internal
274     view
275     returns (bool)
276   {
277     require(msg.data.length > _SIGNATURE_SIZE);
278     bytes memory data = new bytes(msg.data.length - _SIGNATURE_SIZE);
279     for (uint i = 0; i < data.length; i++) {
280       data[i] = msg.data[i];
281     }
282     return _isValidDataHash(
283       keccak256(abi.encodePacked(address(this), account, data)),
284       signature
285     );
286   }
287 
288   /**
289    * @dev internal function to convert a hash to an eth signed message
290    * and then recover the signature and check it against the signer role
291    * @return bool
292    */
293   function _isValidDataHash(bytes32 hash, bytes signature)
294     internal
295     view
296     returns (bool)
297   {
298     address signer = hash
299       .toEthSignedMessageHash()
300       .recover(signature);
301 
302     return signer != address(0) && isSigner(signer);
303   }
304 }
305 
306 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
307 
308 /**
309  * @title ERC20 interface
310  * @dev see https://github.com/ethereum/EIPs/issues/20
311  */
312 interface IERC20 {
313   function totalSupply() external view returns (uint256);
314 
315   function balanceOf(address who) external view returns (uint256);
316 
317   function allowance(address owner, address spender)
318     external view returns (uint256);
319 
320   function transfer(address to, uint256 value) external returns (bool);
321 
322   function approve(address spender, uint256 value)
323     external returns (bool);
324 
325   function transferFrom(address from, address to, uint256 value)
326     external returns (bool);
327 
328   event Transfer(
329     address indexed from,
330     address indexed to,
331     uint256 value
332   );
333 
334   event Approval(
335     address indexed owner,
336     address indexed spender,
337     uint256 value
338   );
339 }
340 
341 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
342 
343 /**
344  * @title SafeMath
345  * @dev Math operations with safety checks that revert on error
346  */
347 library SafeMath {
348 
349   /**
350   * @dev Multiplies two numbers, reverts on overflow.
351   */
352   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
353     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
354     // benefit is lost if 'b' is also tested.
355     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
356     if (a == 0) {
357       return 0;
358     }
359 
360     uint256 c = a * b;
361     require(c / a == b);
362 
363     return c;
364   }
365 
366   /**
367   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
368   */
369   function div(uint256 a, uint256 b) internal pure returns (uint256) {
370     require(b > 0); // Solidity only automatically asserts when dividing by 0
371     uint256 c = a / b;
372     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
373 
374     return c;
375   }
376 
377   /**
378   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
379   */
380   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
381     require(b <= a);
382     uint256 c = a - b;
383 
384     return c;
385   }
386 
387   /**
388   * @dev Adds two numbers, reverts on overflow.
389   */
390   function add(uint256 a, uint256 b) internal pure returns (uint256) {
391     uint256 c = a + b;
392     require(c >= a);
393 
394     return c;
395   }
396 
397   /**
398   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
399   * reverts when dividing by zero.
400   */
401   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
402     require(b != 0);
403     return a % b;
404   }
405 }
406 
407 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
408 
409 /**
410  * @title Standard ERC20 token
411  *
412  * @dev Implementation of the basic standard token.
413  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
414  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
415  */
416 contract ERC20 is IERC20 {
417   using SafeMath for uint256;
418 
419   mapping (address => uint256) private _balances;
420 
421   mapping (address => mapping (address => uint256)) private _allowed;
422 
423   uint256 private _totalSupply;
424 
425   /**
426   * @dev Total number of tokens in existence
427   */
428   function totalSupply() public view returns (uint256) {
429     return _totalSupply;
430   }
431 
432   /**
433   * @dev Gets the balance of the specified address.
434   * @param owner The address to query the balance of.
435   * @return An uint256 representing the amount owned by the passed address.
436   */
437   function balanceOf(address owner) public view returns (uint256) {
438     return _balances[owner];
439   }
440 
441   /**
442    * @dev Function to check the amount of tokens that an owner allowed to a spender.
443    * @param owner address The address which owns the funds.
444    * @param spender address The address which will spend the funds.
445    * @return A uint256 specifying the amount of tokens still available for the spender.
446    */
447   function allowance(
448     address owner,
449     address spender
450    )
451     public
452     view
453     returns (uint256)
454   {
455     return _allowed[owner][spender];
456   }
457 
458   /**
459   * @dev Transfer token for a specified address
460   * @param to The address to transfer to.
461   * @param value The amount to be transferred.
462   */
463   function transfer(address to, uint256 value) public returns (bool) {
464     _transfer(msg.sender, to, value);
465     return true;
466   }
467 
468   /**
469    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
470    * Beware that changing an allowance with this method brings the risk that someone may use both the old
471    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
472    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
473    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
474    * @param spender The address which will spend the funds.
475    * @param value The amount of tokens to be spent.
476    */
477   function approve(address spender, uint256 value) public returns (bool) {
478     require(spender != address(0));
479 
480     _allowed[msg.sender][spender] = value;
481     emit Approval(msg.sender, spender, value);
482     return true;
483   }
484 
485   /**
486    * @dev Transfer tokens from one address to another
487    * @param from address The address which you want to send tokens from
488    * @param to address The address which you want to transfer to
489    * @param value uint256 the amount of tokens to be transferred
490    */
491   function transferFrom(
492     address from,
493     address to,
494     uint256 value
495   )
496     public
497     returns (bool)
498   {
499     require(value <= _allowed[from][msg.sender]);
500 
501     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
502     _transfer(from, to, value);
503     return true;
504   }
505 
506   /**
507    * @dev Increase the amount of tokens that an owner allowed to a spender.
508    * approve should be called when allowed_[_spender] == 0. To increment
509    * allowed value is better to use this function to avoid 2 calls (and wait until
510    * the first transaction is mined)
511    * From MonolithDAO Token.sol
512    * @param spender The address which will spend the funds.
513    * @param addedValue The amount of tokens to increase the allowance by.
514    */
515   function increaseAllowance(
516     address spender,
517     uint256 addedValue
518   )
519     public
520     returns (bool)
521   {
522     require(spender != address(0));
523 
524     _allowed[msg.sender][spender] = (
525       _allowed[msg.sender][spender].add(addedValue));
526     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
527     return true;
528   }
529 
530   /**
531    * @dev Decrease the amount of tokens that an owner allowed to a spender.
532    * approve should be called when allowed_[_spender] == 0. To decrement
533    * allowed value is better to use this function to avoid 2 calls (and wait until
534    * the first transaction is mined)
535    * From MonolithDAO Token.sol
536    * @param spender The address which will spend the funds.
537    * @param subtractedValue The amount of tokens to decrease the allowance by.
538    */
539   function decreaseAllowance(
540     address spender,
541     uint256 subtractedValue
542   )
543     public
544     returns (bool)
545   {
546     require(spender != address(0));
547 
548     _allowed[msg.sender][spender] = (
549       _allowed[msg.sender][spender].sub(subtractedValue));
550     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
551     return true;
552   }
553 
554   /**
555   * @dev Transfer token for a specified addresses
556   * @param from The address to transfer from.
557   * @param to The address to transfer to.
558   * @param value The amount to be transferred.
559   */
560   function _transfer(address from, address to, uint256 value) internal {
561     require(value <= _balances[from]);
562     require(to != address(0));
563 
564     _balances[from] = _balances[from].sub(value);
565     _balances[to] = _balances[to].add(value);
566     emit Transfer(from, to, value);
567   }
568 
569   /**
570    * @dev Internal function that mints an amount of the token and assigns it to
571    * an account. This encapsulates the modification of balances such that the
572    * proper events are emitted.
573    * @param account The account that will receive the created tokens.
574    * @param value The amount that will be created.
575    */
576   function _mint(address account, uint256 value) internal {
577     require(account != 0);
578     _totalSupply = _totalSupply.add(value);
579     _balances[account] = _balances[account].add(value);
580     emit Transfer(address(0), account, value);
581   }
582 
583   /**
584    * @dev Internal function that burns an amount of the token of a given
585    * account.
586    * @param account The account whose tokens will be burnt.
587    * @param value The amount that will be burnt.
588    */
589   function _burn(address account, uint256 value) internal {
590     require(account != 0);
591     require(value <= _balances[account]);
592 
593     _totalSupply = _totalSupply.sub(value);
594     _balances[account] = _balances[account].sub(value);
595     emit Transfer(account, address(0), value);
596   }
597 
598   /**
599    * @dev Internal function that burns an amount of the token of a given
600    * account, deducting from the sender's allowance for said account. Uses the
601    * internal burn function.
602    * @param account The account whose tokens will be burnt.
603    * @param value The amount that will be burnt.
604    */
605   function _burnFrom(address account, uint256 value) internal {
606     require(value <= _allowed[account][msg.sender]);
607 
608     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
609     // this function needs to emit an event with the updated approval.
610     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
611       value);
612     _burn(account, value);
613   }
614 }
615 
616 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
617 
618 /**
619  * @title Burnable Token
620  * @dev Token that can be irreversibly burned (destroyed).
621  */
622 contract ERC20Burnable is ERC20 {
623 
624   /**
625    * @dev Burns a specific amount of tokens.
626    * @param value The amount of token to be burned.
627    */
628   function burn(uint256 value) public {
629     _burn(msg.sender, value);
630   }
631 
632   /**
633    * @dev Burns a specific amount of tokens from the target address and decrements allowance
634    * @param from address The address which you want to send tokens from
635    * @param value uint256 The amount of token to be burned
636    */
637   function burnFrom(address from, uint256 value) public {
638     _burnFrom(from, value);
639   }
640 }
641 
642 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
643 
644 /**
645  * @title SafeERC20
646  * @dev Wrappers around ERC20 operations that throw on failure.
647  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
648  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
649  */
650 library SafeERC20 {
651 
652   using SafeMath for uint256;
653 
654   function safeTransfer(
655     IERC20 token,
656     address to,
657     uint256 value
658   )
659     internal
660   {
661     require(token.transfer(to, value));
662   }
663 
664   function safeTransferFrom(
665     IERC20 token,
666     address from,
667     address to,
668     uint256 value
669   )
670     internal
671   {
672     require(token.transferFrom(from, to, value));
673   }
674 
675   function safeApprove(
676     IERC20 token,
677     address spender,
678     uint256 value
679   )
680     internal
681   {
682     // safeApprove should only be called when setting an initial allowance, 
683     // or when resetting it to zero. To increase and decrease it, use 
684     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
685     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
686     require(token.approve(spender, value));
687   }
688 
689   function safeIncreaseAllowance(
690     IERC20 token,
691     address spender,
692     uint256 value
693   )
694     internal
695   {
696     uint256 newAllowance = token.allowance(address(this), spender).add(value);
697     require(token.approve(spender, newAllowance));
698   }
699 
700   function safeDecreaseAllowance(
701     IERC20 token,
702     address spender,
703     uint256 value
704   )
705     internal
706   {
707     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
708     require(token.approve(spender, newAllowance));
709   }
710 }
711 
712 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
713 
714 /**
715  * @title Ownable
716  * @dev The Ownable contract has an owner address, and provides basic authorization control
717  * functions, this simplifies the implementation of "user permissions".
718  */
719 contract Ownable {
720   address private _owner;
721 
722   event OwnershipTransferred(
723     address indexed previousOwner,
724     address indexed newOwner
725   );
726 
727   /**
728    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
729    * account.
730    */
731   constructor() internal {
732     _owner = msg.sender;
733     emit OwnershipTransferred(address(0), _owner);
734   }
735 
736   /**
737    * @return the address of the owner.
738    */
739   function owner() public view returns(address) {
740     return _owner;
741   }
742 
743   /**
744    * @dev Throws if called by any account other than the owner.
745    */
746   modifier onlyOwner() {
747     require(isOwner());
748     _;
749   }
750 
751   /**
752    * @return true if `msg.sender` is the owner of the contract.
753    */
754   function isOwner() public view returns(bool) {
755     return msg.sender == _owner;
756   }
757 
758   /**
759    * @dev Allows the current owner to relinquish control of the contract.
760    * @notice Renouncing to ownership will leave the contract without an owner.
761    * It will not be possible to call the functions with the `onlyOwner`
762    * modifier anymore.
763    */
764   function renounceOwnership() public onlyOwner {
765     emit OwnershipTransferred(_owner, address(0));
766     _owner = address(0);
767   }
768 
769   /**
770    * @dev Allows the current owner to transfer control of the contract to a newOwner.
771    * @param newOwner The address to transfer ownership to.
772    */
773   function transferOwnership(address newOwner) public onlyOwner {
774     _transferOwnership(newOwner);
775   }
776 
777   /**
778    * @dev Transfers control of the contract to a newOwner.
779    * @param newOwner The address to transfer ownership to.
780    */
781   function _transferOwnership(address newOwner) internal {
782     require(newOwner != address(0));
783     emit OwnershipTransferred(_owner, newOwner);
784     _owner = newOwner;
785   }
786 }
787 
788 // File: contracts/misc/AbstractAmbix.sol
789 
790 /**
791   @dev Ambix contract is used for morph Token set to another
792   Token's by rule (recipe). In distillation process given
793   Token's are burned and result generated by emission.
794   
795   The recipe presented as equation in form:
796   (N1 * A1 & N'1 * A'1 & N''1 * A''1 ...)
797   | (N2 * A2 & N'2 * A'2 & N''2 * A''2 ...) ...
798   | (Nn * An & N'n * A'n & N''n * A''n ...)
799   = M1 * B1 & M2 * B2 ... & Mm * Bm 
800     where A, B - input and output tokens
801           N, M - token value coeficients
802           n, m - input / output dimetion size 
803           | - is alternative operator (logical OR)
804           & - is associative operator (logical AND)
805   This says that `Ambix` should receive (approve) left
806   part of equation and send (transfer) right part.
807 */
808 contract AbstractAmbix is Ownable {
809     using SafeERC20 for ERC20Burnable;
810     using SafeERC20 for ERC20;
811 
812     address[][] public A;
813     uint256[][] public N;
814     address[] public B;
815     uint256[] public M;
816 
817     /**
818      * @dev Append token recipe source alternative
819      * @param _a Token recipe source token addresses
820      * @param _n Token recipe source token counts
821      **/
822     function appendSource(
823         address[] _a,
824         uint256[] _n
825     ) external onlyOwner {
826         uint256 i;
827 
828         require(_a.length == _n.length && _a.length > 0);
829 
830         for (i = 0; i < _a.length; ++i)
831             require(_a[i] != 0);
832 
833         if (_n.length == 1 && _n[0] == 0) {
834             require(B.length == 1);
835         } else {
836             for (i = 0; i < _n.length; ++i)
837                 require(_n[i] > 0);
838         }
839 
840         A.push(_a);
841         N.push(_n);
842     }
843 
844     /**
845      * @dev Set sink of token recipe
846      * @param _b Token recipe sink token list
847      * @param _m Token recipe sink token counts
848      */
849     function setSink(
850         address[] _b,
851         uint256[] _m
852     ) external onlyOwner{
853         require(_b.length == _m.length);
854 
855         for (uint256 i = 0; i < _b.length; ++i)
856             require(_b[i] != 0);
857 
858         B = _b;
859         M = _m;
860     }
861 
862     function _run(uint256 _ix) internal {
863         require(_ix < A.length);
864         uint256 i;
865 
866         if (N[_ix][0] > 0) {
867             // Static conversion
868 
869             // Token count multiplier
870             uint256 mux = ERC20(A[_ix][0]).allowance(msg.sender, this) / N[_ix][0];
871             require(mux > 0);
872 
873             // Burning run
874             for (i = 0; i < A[_ix].length; ++i)
875                 ERC20Burnable(A[_ix][i]).burnFrom(msg.sender, mux * N[_ix][i]);
876 
877             // Transfer up
878             for (i = 0; i < B.length; ++i)
879                 ERC20(B[i]).safeTransfer(msg.sender, M[i] * mux);
880 
881         } else {
882             // Dynamic conversion
883             //   Let source token total supply is finite and decrease on each conversion,
884             //   just convert finite supply of source to tokens on balance of ambix.
885             //         dynamicRate = balance(sink) / total(source)
886 
887             // Is available for single source and single sink only
888             require(A[_ix].length == 1 && B.length == 1);
889 
890             ERC20Burnable source = ERC20Burnable(A[_ix][0]);
891             ERC20 sink = ERC20(B[0]);
892 
893             uint256 scale = 10 ** 18 * sink.balanceOf(this) / source.totalSupply();
894 
895             uint256 allowance = source.allowance(msg.sender, this);
896             require(allowance > 0);
897             source.burnFrom(msg.sender, allowance);
898 
899             uint256 reward = scale * allowance / 10 ** 18;
900             require(reward > 0);
901             sink.safeTransfer(msg.sender, reward);
902         }
903     }
904 }
905 
906 // File: contracts/misc/KycAmbix.sol
907 
908 contract KycAmbix is AbstractAmbix, SignatureBouncer {
909     /**
910      * @dev Run distillation process
911      * @param _ix Source alternative index
912      * @param _signature KYC indulgence (KYC signature of concatenated sender and contract address)
913      */
914     function run(uint256 _ix, bytes _signature) external onlyValidSignature(_signature)
915     { _run(_ix); }
916 }