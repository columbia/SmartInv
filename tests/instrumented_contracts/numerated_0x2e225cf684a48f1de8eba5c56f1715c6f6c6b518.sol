1 // Sources flattened with buidler v0.1.5
2 pragma solidity 0.4.24;
3 
4 
5 // File openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol@v1.12.0
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * See https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address _who) public view returns (uint256);
15   function transfer(address _to, uint256 _value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 // File openzeppelin-solidity/contracts/token/ERC20/ERC20.sol@v1.12.0
21 
22 /**
23  * @title ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/20
25  */
26 contract ERC20 is ERC20Basic {
27   function allowance(address _owner, address _spender)
28     public view returns (uint256);
29 
30   function transferFrom(address _from, address _to, uint256 _value)
31     public returns (bool);
32 
33   function approve(address _spender, uint256 _value) public returns (bool);
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 }
40 
41 
42 // File openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol@v1.12.0
43 
44 /**
45  * @title SafeERC20
46  * @dev Wrappers around ERC20 operations that throw on failure.
47  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
48  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
49  */
50 library SafeERC20 {
51   function safeTransfer(
52     ERC20Basic _token,
53     address _to,
54     uint256 _value
55   )
56     internal
57   {
58     require(_token.transfer(_to, _value));
59   }
60 
61   function safeTransferFrom(
62     ERC20 _token,
63     address _from,
64     address _to,
65     uint256 _value
66   )
67     internal
68   {
69     require(_token.transferFrom(_from, _to, _value));
70   }
71 
72   function safeApprove(
73     ERC20 _token,
74     address _spender,
75     uint256 _value
76   )
77     internal
78   {
79     require(_token.approve(_spender, _value));
80   }
81 }
82 
83 
84 // File openzeppelin-solidity/contracts/ownership/Ownable.sol@v1.12.0
85 
86 /**
87  * @title Ownable
88  * @dev The Ownable contract has an owner address, and provides basic authorization control
89  * functions, this simplifies the implementation of "user permissions".
90  */
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipRenounced(address indexed previousOwner);
96   event OwnershipTransferred(
97     address indexed previousOwner,
98     address indexed newOwner
99   );
100 
101 
102   /**
103    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
104    * account.
105    */
106   constructor() public {
107     owner = msg.sender;
108   }
109 
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118   /**
119    * @dev Allows the current owner to relinquish control of the contract.
120    * @notice Renouncing to ownership will leave the contract without an owner.
121    * It will not be possible to call the functions with the `onlyOwner`
122    * modifier anymore.
123    */
124   function renounceOwnership() public onlyOwner {
125     emit OwnershipRenounced(owner);
126     owner = address(0);
127   }
128 
129   /**
130    * @dev Allows the current owner to transfer control of the contract to a newOwner.
131    * @param _newOwner The address to transfer ownership to.
132    */
133   function transferOwnership(address _newOwner) public onlyOwner {
134     _transferOwnership(_newOwner);
135   }
136 
137   /**
138    * @dev Transfers control of the contract to a newOwner.
139    * @param _newOwner The address to transfer ownership to.
140    */
141   function _transferOwnership(address _newOwner) internal {
142     require(_newOwner != address(0));
143     emit OwnershipTransferred(owner, _newOwner);
144     owner = _newOwner;
145   }
146 }
147 
148 
149 // File openzeppelin-solidity/contracts/access/rbac/Roles.sol@v1.12.0
150 
151 /**
152  * @title Roles
153  * @author Francisco Giordano (@frangio)
154  * @dev Library for managing addresses assigned to a Role.
155  * See RBAC.sol for example usage.
156  */
157 library Roles {
158   struct Role {
159     mapping (address => bool) bearer;
160   }
161 
162   /**
163    * @dev give an address access to this role
164    */
165   function add(Role storage _role, address _addr)
166     internal
167   {
168     _role.bearer[_addr] = true;
169   }
170 
171   /**
172    * @dev remove an address' access to this role
173    */
174   function remove(Role storage _role, address _addr)
175     internal
176   {
177     _role.bearer[_addr] = false;
178   }
179 
180   /**
181    * @dev check if an address has this role
182    * // reverts
183    */
184   function check(Role storage _role, address _addr)
185     internal
186     view
187   {
188     require(has(_role, _addr));
189   }
190 
191   /**
192    * @dev check if an address has this role
193    * @return bool
194    */
195   function has(Role storage _role, address _addr)
196     internal
197     view
198     returns (bool)
199   {
200     return _role.bearer[_addr];
201   }
202 }
203 
204 
205 // File openzeppelin-solidity/contracts/access/rbac/RBAC.sol@v1.12.0
206 
207 /**
208  * @title RBAC (Role-Based Access Control)
209  * @author Matt Condon (@Shrugs)
210  * @dev Stores and provides setters and getters for roles and addresses.
211  * Supports unlimited numbers of roles and addresses.
212  * See //contracts/mocks/RBACMock.sol for an example of usage.
213  * This RBAC method uses strings to key roles. It may be beneficial
214  * for you to write your own implementation of this interface using Enums or similar.
215  */
216 contract RBAC {
217   using Roles for Roles.Role;
218 
219   mapping (string => Roles.Role) private roles;
220 
221   event RoleAdded(address indexed operator, string role);
222   event RoleRemoved(address indexed operator, string role);
223 
224   /**
225    * @dev reverts if addr does not have role
226    * @param _operator address
227    * @param _role the name of the role
228    * // reverts
229    */
230   function checkRole(address _operator, string _role)
231     public
232     view
233   {
234     roles[_role].check(_operator);
235   }
236 
237   /**
238    * @dev determine if addr has role
239    * @param _operator address
240    * @param _role the name of the role
241    * @return bool
242    */
243   function hasRole(address _operator, string _role)
244     public
245     view
246     returns (bool)
247   {
248     return roles[_role].has(_operator);
249   }
250 
251   /**
252    * @dev add a role to an address
253    * @param _operator address
254    * @param _role the name of the role
255    */
256   function addRole(address _operator, string _role)
257     internal
258   {
259     roles[_role].add(_operator);
260     emit RoleAdded(_operator, _role);
261   }
262 
263   /**
264    * @dev remove a role from an address
265    * @param _operator address
266    * @param _role the name of the role
267    */
268   function removeRole(address _operator, string _role)
269     internal
270   {
271     roles[_role].remove(_operator);
272     emit RoleRemoved(_operator, _role);
273   }
274 
275   /**
276    * @dev modifier to scope access to a single role (uses msg.sender as addr)
277    * @param _role the name of the role
278    * // reverts
279    */
280   modifier onlyRole(string _role)
281   {
282     checkRole(msg.sender, _role);
283     _;
284   }
285 
286   /**
287    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
288    * @param _roles the names of the roles to scope access to
289    * // reverts
290    *
291    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
292    *  see: https://github.com/ethereum/solidity/issues/2467
293    */
294   // modifier onlyRoles(string[] _roles) {
295   //     bool hasAnyRole = false;
296   //     for (uint8 i = 0; i < _roles.length; i++) {
297   //         if (hasRole(msg.sender, _roles[i])) {
298   //             hasAnyRole = true;
299   //             break;
300   //         }
301   //     }
302 
303   //     require(hasAnyRole);
304 
305   //     _;
306   // }
307 }
308 
309 
310 // File openzeppelin-solidity/contracts/ECRecovery.sol@v1.12.0
311 
312 /**
313  * @title Elliptic curve signature operations
314  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
315  * TODO Remove this library once solidity supports passing a signature to ecrecover.
316  * See https://github.com/ethereum/solidity/issues/864
317  */
318 
319 library ECRecovery {
320 
321   /**
322    * @dev Recover signer address from a message by using their signature
323    * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
324    * @param _sig bytes signature, the signature is generated using web3.eth.sign()
325    */
326   function recover(bytes32 _hash, bytes _sig)
327     internal
328     pure
329     returns (address)
330   {
331     bytes32 r;
332     bytes32 s;
333     uint8 v;
334 
335     // Check the signature length
336     if (_sig.length != 65) {
337       return (address(0));
338     }
339 
340     // Divide the signature in r, s and v variables
341     // ecrecover takes the signature parameters, and the only way to get them
342     // currently is to use assembly.
343     // solium-disable-next-line security/no-inline-assembly
344     assembly {
345       r := mload(add(_sig, 32))
346       s := mload(add(_sig, 64))
347       v := byte(0, mload(add(_sig, 96)))
348     }
349 
350     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
351     if (v < 27) {
352       v += 27;
353     }
354 
355     // If the version is correct return the signer address
356     if (v != 27 && v != 28) {
357       return (address(0));
358     } else {
359       // solium-disable-next-line arg-overflow
360       return ecrecover(_hash, v, r, s);
361     }
362   }
363 
364   /**
365    * toEthSignedMessageHash
366    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
367    * and hash the result
368    */
369   function toEthSignedMessageHash(bytes32 _hash)
370     internal
371     pure
372     returns (bytes32)
373   {
374     // 32 is the length in bytes of hash,
375     // enforced by the type signature above
376     return keccak256(
377       abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
378     );
379   }
380 }
381 
382 
383 // File openzeppelin-solidity/contracts/access/SignatureBouncer.sol@v1.12.0
384 
385 /**
386  * @title SignatureBouncer
387  * @author PhABC, Shrugs and aflesher
388  * @dev Bouncer allows users to submit a signature as a permission to do an action.
389  * If the signature is from one of the authorized bouncer addresses, the signature
390  * is valid. The owner of the contract adds/removes bouncers.
391  * Bouncer addresses can be individual servers signing grants or different
392  * users within a decentralized club that have permission to invite other members.
393  * This technique is useful for whitelists and airdrops; instead of putting all
394  * valid addresses on-chain, simply sign a grant of the form
395  * keccak256(abi.encodePacked(`:contractAddress` + `:granteeAddress`)) using a valid bouncer address.
396  * Then restrict access to your crowdsale/whitelist/airdrop using the
397  * `onlyValidSignature` modifier (or implement your own using isValidSignature).
398  * In addition to `onlyValidSignature`, `onlyValidSignatureAndMethod` and
399  * `onlyValidSignatureAndData` can be used to restrict access to only a given method
400  * or a given method with given parameters respectively.
401  * See the tests Bouncer.test.js for specific usage examples.
402  * @notice A method that uses the `onlyValidSignatureAndData` modifier must make the _sig
403  * parameter the "last" parameter. You cannot sign a message that has its own
404  * signature in it so the last 128 bytes of msg.data (which represents the
405  * length of the _sig data and the _sig data itself) is ignored when validating.
406  * Also non fixed sized parameters make constructing the data in the signature
407  * much more complex. See https://ethereum.stackexchange.com/a/50616 for more details.
408  */
409 contract SignatureBouncer is Ownable, RBAC {
410   using ECRecovery for bytes32;
411 
412   string public constant ROLE_BOUNCER = "bouncer";
413   uint constant METHOD_ID_SIZE = 4;
414   // signature size is 65 bytes (tightly packed v + r + s), but gets padded to 96 bytes
415   uint constant SIGNATURE_SIZE = 96;
416 
417   /**
418    * @dev requires that a valid signature of a bouncer was provided
419    */
420   modifier onlyValidSignature(bytes _sig)
421   {
422     require(isValidSignature(msg.sender, _sig));
423     _;
424   }
425 
426   /**
427    * @dev requires that a valid signature with a specifed method of a bouncer was provided
428    */
429   modifier onlyValidSignatureAndMethod(bytes _sig)
430   {
431     require(isValidSignatureAndMethod(msg.sender, _sig));
432     _;
433   }
434 
435   /**
436    * @dev requires that a valid signature with a specifed method and params of a bouncer was provided
437    */
438   modifier onlyValidSignatureAndData(bytes _sig)
439   {
440     require(isValidSignatureAndData(msg.sender, _sig));
441     _;
442   }
443 
444   /**
445    * @dev allows the owner to add additional bouncer addresses
446    */
447   function addBouncer(address _bouncer)
448     public
449     onlyOwner
450   {
451     require(_bouncer != address(0));
452     addRole(_bouncer, ROLE_BOUNCER);
453   }
454 
455   /**
456    * @dev allows the owner to remove bouncer addresses
457    */
458   function removeBouncer(address _bouncer)
459     public
460     onlyOwner
461   {
462     require(_bouncer != address(0));
463     removeRole(_bouncer, ROLE_BOUNCER);
464   }
465 
466   /**
467    * @dev is the signature of `this + sender` from a bouncer?
468    * @return bool
469    */
470   function isValidSignature(address _address, bytes _sig)
471     internal
472     view
473     returns (bool)
474   {
475     return isValidDataHash(
476       keccak256(abi.encodePacked(address(this), _address)),
477       _sig
478     );
479   }
480 
481   /**
482    * @dev is the signature of `this + sender + methodId` from a bouncer?
483    * @return bool
484    */
485   function isValidSignatureAndMethod(address _address, bytes _sig)
486     internal
487     view
488     returns (bool)
489   {
490     bytes memory data = new bytes(METHOD_ID_SIZE);
491     for (uint i = 0; i < data.length; i++) {
492       data[i] = msg.data[i];
493     }
494     return isValidDataHash(
495       keccak256(abi.encodePacked(address(this), _address, data)),
496       _sig
497     );
498   }
499 
500   /**
501     * @dev is the signature of `this + sender + methodId + params(s)` from a bouncer?
502     * @notice the _sig parameter of the method being validated must be the "last" parameter
503     * @return bool
504     */
505   function isValidSignatureAndData(address _address, bytes _sig)
506     internal
507     view
508     returns (bool)
509   {
510     require(msg.data.length > SIGNATURE_SIZE);
511     bytes memory data = new bytes(msg.data.length - SIGNATURE_SIZE);
512     for (uint i = 0; i < data.length; i++) {
513       data[i] = msg.data[i];
514     }
515     return isValidDataHash(
516       keccak256(abi.encodePacked(address(this), _address, data)),
517       _sig
518     );
519   }
520 
521   /**
522    * @dev internal function to convert a hash to an eth signed message
523    * and then recover the signature and check it against the bouncer role
524    * @return bool
525    */
526   function isValidDataHash(bytes32 _hash, bytes _sig)
527     internal
528     view
529     returns (bool)
530   {
531     address signer = _hash
532       .toEthSignedMessageHash()
533       .recover(_sig);
534     return hasRole(signer, ROLE_BOUNCER);
535   }
536 }
537 
538 
539 // File contracts/EscrowedERC20Bouncer.sol
540 
541 contract EscrowedERC20Bouncer is SignatureBouncer {
542   using SafeERC20 for ERC20;
543 
544   uint256 public nonce;
545 
546   modifier onlyBouncer()
547   {
548     checkRole(msg.sender, ROLE_BOUNCER);
549     _;
550   }
551 
552   modifier validDataWithoutSender(bytes _signature)
553   {
554     require(isValidSignatureAndData(address(this), _signature), "INVALID_SIGNATURE");
555     _;
556   }
557 
558   constructor(address _bouncer)
559     public
560   {
561     addBouncer(_bouncer);
562   }
563 
564   /**
565    * allow anyone with a valid bouncer signature for the msg data to send `_amount` of `_token` to `_to`
566    */
567   function withdraw(uint256 _nonce, ERC20 _token, address _to, uint256 _amount, bytes _signature)
568     public
569     validDataWithoutSender(_signature)
570   {
571     require(_nonce > nonce, "NONCE_GT_NONCE_REQUIRED");
572     nonce = _nonce;
573     _token.safeTransfer(_to, _amount);
574   }
575 
576   /**
577    * Allow the bouncer to withdraw all of the ERC20 tokens in the contract
578    */
579   function withdrawAll(ERC20 _token, address _to)
580     public
581     onlyBouncer
582   {
583     _token.safeTransfer(_to, _token.balanceOf(address(this)));
584   }
585 }
586 
587 
588 // File openzeppelin-solidity/contracts/introspection/ERC165.sol@v1.12.0
589 
590 /**
591  * @title ERC165
592  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
593  */
594 interface ERC165 {
595 
596   /**
597    * @notice Query if a contract implements an interface
598    * @param _interfaceId The interface identifier, as specified in ERC-165
599    * @dev Interface identification is specified in ERC-165. This function
600    * uses less than 30,000 gas.
601    */
602   function supportsInterface(bytes4 _interfaceId)
603     external
604     view
605     returns (bool);
606 }
607 
608 
609 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol@v1.12.0
610 
611 /**
612  * @title ERC721 Non-Fungible Token Standard basic interface
613  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
614  */
615 contract ERC721Basic is ERC165 {
616 
617   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
618   /*
619    * 0x80ac58cd ===
620    *   bytes4(keccak256('balanceOf(address)')) ^
621    *   bytes4(keccak256('ownerOf(uint256)')) ^
622    *   bytes4(keccak256('approve(address,uint256)')) ^
623    *   bytes4(keccak256('getApproved(uint256)')) ^
624    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
625    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
626    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
627    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
628    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
629    */
630 
631   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
632   /*
633    * 0x4f558e79 ===
634    *   bytes4(keccak256('exists(uint256)'))
635    */
636 
637   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
638   /**
639    * 0x780e9d63 ===
640    *   bytes4(keccak256('totalSupply()')) ^
641    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
642    *   bytes4(keccak256('tokenByIndex(uint256)'))
643    */
644 
645   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
646   /**
647    * 0x5b5e139f ===
648    *   bytes4(keccak256('name()')) ^
649    *   bytes4(keccak256('symbol()')) ^
650    *   bytes4(keccak256('tokenURI(uint256)'))
651    */
652 
653   event Transfer(
654     address indexed _from,
655     address indexed _to,
656     uint256 indexed _tokenId
657   );
658   event Approval(
659     address indexed _owner,
660     address indexed _approved,
661     uint256 indexed _tokenId
662   );
663   event ApprovalForAll(
664     address indexed _owner,
665     address indexed _operator,
666     bool _approved
667   );
668 
669   function balanceOf(address _owner) public view returns (uint256 _balance);
670   function ownerOf(uint256 _tokenId) public view returns (address _owner);
671   function exists(uint256 _tokenId) public view returns (bool _exists);
672 
673   function approve(address _to, uint256 _tokenId) public;
674   function getApproved(uint256 _tokenId)
675     public view returns (address _operator);
676 
677   function setApprovalForAll(address _operator, bool _approved) public;
678   function isApprovedForAll(address _owner, address _operator)
679     public view returns (bool);
680 
681   function transferFrom(address _from, address _to, uint256 _tokenId) public;
682   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
683     public;
684 
685   function safeTransferFrom(
686     address _from,
687     address _to,
688     uint256 _tokenId,
689     bytes _data
690   )
691     public;
692 }
693 
694 
695 // File openzeppelin-solidity/contracts/token/ERC721/ERC721.sol@v1.12.0
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
699  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
700  */
701 contract ERC721Enumerable is ERC721Basic {
702   function totalSupply() public view returns (uint256);
703   function tokenOfOwnerByIndex(
704     address _owner,
705     uint256 _index
706   )
707     public
708     view
709     returns (uint256 _tokenId);
710 
711   function tokenByIndex(uint256 _index) public view returns (uint256);
712 }
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
717  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
718  */
719 contract ERC721Metadata is ERC721Basic {
720   function name() external view returns (string _name);
721   function symbol() external view returns (string _symbol);
722   function tokenURI(uint256 _tokenId) public view returns (string);
723 }
724 
725 
726 /**
727  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
728  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
729  */
730 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
731 }
732 
733 
734 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol@v1.12.0
735 
736 /**
737  * @title ERC721 token receiver interface
738  * @dev Interface for any contract that wants to support safeTransfers
739  * from ERC721 asset contracts.
740  */
741 contract ERC721Receiver {
742   /**
743    * @dev Magic value to be returned upon successful reception of an NFT
744    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
745    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
746    */
747   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
748 
749   /**
750    * @notice Handle the receipt of an NFT
751    * @dev The ERC721 smart contract calls this function on the recipient
752    * after a `safetransfer`. This function MAY throw to revert and reject the
753    * transfer. Return of other than the magic value MUST result in the
754    * transaction being reverted.
755    * Note: the contract address is always the message sender.
756    * @param _operator The address which called `safeTransferFrom` function
757    * @param _from The address which previously owned the token
758    * @param _tokenId The NFT identifier which is being transferred
759    * @param _data Additional data with no specified format
760    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
761    */
762   function onERC721Received(
763     address _operator,
764     address _from,
765     uint256 _tokenId,
766     bytes _data
767   )
768     public
769     returns(bytes4);
770 }
771 
772 
773 // File openzeppelin-solidity/contracts/math/SafeMath.sol@v1.12.0
774 
775 /**
776  * @title SafeMath
777  * @dev Math operations with safety checks that throw on error
778  */
779 library SafeMath {
780 
781   /**
782   * @dev Multiplies two numbers, throws on overflow.
783   */
784   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
785     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
786     // benefit is lost if 'b' is also tested.
787     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
788     if (_a == 0) {
789       return 0;
790     }
791 
792     c = _a * _b;
793     assert(c / _a == _b);
794     return c;
795   }
796 
797   /**
798   * @dev Integer division of two numbers, truncating the quotient.
799   */
800   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
801     // assert(_b > 0); // Solidity automatically throws when dividing by 0
802     // uint256 c = _a / _b;
803     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
804     return _a / _b;
805   }
806 
807   /**
808   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
809   */
810   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
811     assert(_b <= _a);
812     return _a - _b;
813   }
814 
815   /**
816   * @dev Adds two numbers, throws on overflow.
817   */
818   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
819     c = _a + _b;
820     assert(c >= _a);
821     return c;
822   }
823 }
824 
825 
826 // File openzeppelin-solidity/contracts/AddressUtils.sol@v1.12.0
827 
828 /**
829  * Utility library of inline functions on addresses
830  */
831 library AddressUtils {
832 
833   /**
834    * Returns whether the target address is a contract
835    * @dev This function will return false if invoked during the constructor of a contract,
836    * as the code is not actually created until after the constructor finishes.
837    * @param _addr address to check
838    * @return whether the target address is a contract
839    */
840   function isContract(address _addr) internal view returns (bool) {
841     uint256 size;
842     // XXX Currently there is no better way to check if there is a contract in an address
843     // than to check the size of the code at that address.
844     // See https://ethereum.stackexchange.com/a/14016/36603
845     // for more details about how this works.
846     // TODO Check this again before the Serenity release, because all addresses will be
847     // contracts then.
848     // solium-disable-next-line security/no-inline-assembly
849     assembly { size := extcodesize(_addr) }
850     return size > 0;
851   }
852 
853 }
854 
855 
856 // File openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol@v1.12.0
857 
858 /**
859  * @title SupportsInterfaceWithLookup
860  * @author Matt Condon (@shrugs)
861  * @dev Implements ERC165 using a lookup table.
862  */
863 contract SupportsInterfaceWithLookup is ERC165 {
864 
865   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
866   /**
867    * 0x01ffc9a7 ===
868    *   bytes4(keccak256('supportsInterface(bytes4)'))
869    */
870 
871   /**
872    * @dev a mapping of interface id to whether or not it's supported
873    */
874   mapping(bytes4 => bool) internal supportedInterfaces;
875 
876   /**
877    * @dev A contract implementing SupportsInterfaceWithLookup
878    * implement ERC165 itself
879    */
880   constructor()
881     public
882   {
883     _registerInterface(InterfaceId_ERC165);
884   }
885 
886   /**
887    * @dev implement supportsInterface(bytes4) using a lookup table
888    */
889   function supportsInterface(bytes4 _interfaceId)
890     external
891     view
892     returns (bool)
893   {
894     return supportedInterfaces[_interfaceId];
895   }
896 
897   /**
898    * @dev private method for registering an interface
899    */
900   function _registerInterface(bytes4 _interfaceId)
901     internal
902   {
903     require(_interfaceId != 0xffffffff);
904     supportedInterfaces[_interfaceId] = true;
905   }
906 }
907 
908 
909 // File openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol@v1.12.0
910 
911 /**
912  * @title ERC721 Non-Fungible Token Standard basic implementation
913  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
914  */
915 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
916 
917   using SafeMath for uint256;
918   using AddressUtils for address;
919 
920   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
921   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
922   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
923 
924   // Mapping from token ID to owner
925   mapping (uint256 => address) internal tokenOwner;
926 
927   // Mapping from token ID to approved address
928   mapping (uint256 => address) internal tokenApprovals;
929 
930   // Mapping from owner to number of owned token
931   mapping (address => uint256) internal ownedTokensCount;
932 
933   // Mapping from owner to operator approvals
934   mapping (address => mapping (address => bool)) internal operatorApprovals;
935 
936   constructor()
937     public
938   {
939     // register the supported interfaces to conform to ERC721 via ERC165
940     _registerInterface(InterfaceId_ERC721);
941     _registerInterface(InterfaceId_ERC721Exists);
942   }
943 
944   /**
945    * @dev Gets the balance of the specified address
946    * @param _owner address to query the balance of
947    * @return uint256 representing the amount owned by the passed address
948    */
949   function balanceOf(address _owner) public view returns (uint256) {
950     require(_owner != address(0));
951     return ownedTokensCount[_owner];
952   }
953 
954   /**
955    * @dev Gets the owner of the specified token ID
956    * @param _tokenId uint256 ID of the token to query the owner of
957    * @return owner address currently marked as the owner of the given token ID
958    */
959   function ownerOf(uint256 _tokenId) public view returns (address) {
960     address owner = tokenOwner[_tokenId];
961     require(owner != address(0));
962     return owner;
963   }
964 
965   /**
966    * @dev Returns whether the specified token exists
967    * @param _tokenId uint256 ID of the token to query the existence of
968    * @return whether the token exists
969    */
970   function exists(uint256 _tokenId) public view returns (bool) {
971     address owner = tokenOwner[_tokenId];
972     return owner != address(0);
973   }
974 
975   /**
976    * @dev Approves another address to transfer the given token ID
977    * The zero address indicates there is no approved address.
978    * There can only be one approved address per token at a given time.
979    * Can only be called by the token owner or an approved operator.
980    * @param _to address to be approved for the given token ID
981    * @param _tokenId uint256 ID of the token to be approved
982    */
983   function approve(address _to, uint256 _tokenId) public {
984     address owner = ownerOf(_tokenId);
985     require(_to != owner);
986     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
987 
988     tokenApprovals[_tokenId] = _to;
989     emit Approval(owner, _to, _tokenId);
990   }
991 
992   /**
993    * @dev Gets the approved address for a token ID, or zero if no address set
994    * @param _tokenId uint256 ID of the token to query the approval of
995    * @return address currently approved for the given token ID
996    */
997   function getApproved(uint256 _tokenId) public view returns (address) {
998     return tokenApprovals[_tokenId];
999   }
1000 
1001   /**
1002    * @dev Sets or unsets the approval of a given operator
1003    * An operator is allowed to transfer all tokens of the sender on their behalf
1004    * @param _to operator address to set the approval
1005    * @param _approved representing the status of the approval to be set
1006    */
1007   function setApprovalForAll(address _to, bool _approved) public {
1008     require(_to != msg.sender);
1009     operatorApprovals[msg.sender][_to] = _approved;
1010     emit ApprovalForAll(msg.sender, _to, _approved);
1011   }
1012 
1013   /**
1014    * @dev Tells whether an operator is approved by a given owner
1015    * @param _owner owner address which you want to query the approval of
1016    * @param _operator operator address which you want to query the approval of
1017    * @return bool whether the given operator is approved by the given owner
1018    */
1019   function isApprovedForAll(
1020     address _owner,
1021     address _operator
1022   )
1023     public
1024     view
1025     returns (bool)
1026   {
1027     return operatorApprovals[_owner][_operator];
1028   }
1029 
1030   /**
1031    * @dev Transfers the ownership of a given token ID to another address
1032    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1033    * Requires the msg sender to be the owner, approved, or operator
1034    * @param _from current owner of the token
1035    * @param _to address to receive the ownership of the given token ID
1036    * @param _tokenId uint256 ID of the token to be transferred
1037   */
1038   function transferFrom(
1039     address _from,
1040     address _to,
1041     uint256 _tokenId
1042   )
1043     public
1044   {
1045     require(isApprovedOrOwner(msg.sender, _tokenId));
1046     require(_from != address(0));
1047     require(_to != address(0));
1048 
1049     clearApproval(_from, _tokenId);
1050     removeTokenFrom(_from, _tokenId);
1051     addTokenTo(_to, _tokenId);
1052 
1053     emit Transfer(_from, _to, _tokenId);
1054   }
1055 
1056   /**
1057    * @dev Safely transfers the ownership of a given token ID to another address
1058    * If the target address is a contract, it must implement `onERC721Received`,
1059    * which is called upon a safe transfer, and return the magic value
1060    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1061    * the transfer is reverted.
1062    *
1063    * Requires the msg sender to be the owner, approved, or operator
1064    * @param _from current owner of the token
1065    * @param _to address to receive the ownership of the given token ID
1066    * @param _tokenId uint256 ID of the token to be transferred
1067   */
1068   function safeTransferFrom(
1069     address _from,
1070     address _to,
1071     uint256 _tokenId
1072   )
1073     public
1074   {
1075     // solium-disable-next-line arg-overflow
1076     safeTransferFrom(_from, _to, _tokenId, "");
1077   }
1078 
1079   /**
1080    * @dev Safely transfers the ownership of a given token ID to another address
1081    * If the target address is a contract, it must implement `onERC721Received`,
1082    * which is called upon a safe transfer, and return the magic value
1083    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1084    * the transfer is reverted.
1085    * Requires the msg sender to be the owner, approved, or operator
1086    * @param _from current owner of the token
1087    * @param _to address to receive the ownership of the given token ID
1088    * @param _tokenId uint256 ID of the token to be transferred
1089    * @param _data bytes data to send along with a safe transfer check
1090    */
1091   function safeTransferFrom(
1092     address _from,
1093     address _to,
1094     uint256 _tokenId,
1095     bytes _data
1096   )
1097     public
1098   {
1099     transferFrom(_from, _to, _tokenId);
1100     // solium-disable-next-line arg-overflow
1101     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1102   }
1103 
1104   /**
1105    * @dev Returns whether the given spender can transfer a given token ID
1106    * @param _spender address of the spender to query
1107    * @param _tokenId uint256 ID of the token to be transferred
1108    * @return bool whether the msg.sender is approved for the given token ID,
1109    *  is an operator of the owner, or is the owner of the token
1110    */
1111   function isApprovedOrOwner(
1112     address _spender,
1113     uint256 _tokenId
1114   )
1115     internal
1116     view
1117     returns (bool)
1118   {
1119     address owner = ownerOf(_tokenId);
1120     // Disable solium check because of
1121     // https://github.com/duaraghav8/Solium/issues/175
1122     // solium-disable-next-line operator-whitespace
1123     return (
1124       _spender == owner ||
1125       getApproved(_tokenId) == _spender ||
1126       isApprovedForAll(owner, _spender)
1127     );
1128   }
1129 
1130   /**
1131    * @dev Internal function to mint a new token
1132    * Reverts if the given token ID already exists
1133    * @param _to The address that will own the minted token
1134    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1135    */
1136   function _mint(address _to, uint256 _tokenId) internal {
1137     require(_to != address(0));
1138     addTokenTo(_to, _tokenId);
1139     emit Transfer(address(0), _to, _tokenId);
1140   }
1141 
1142   /**
1143    * @dev Internal function to burn a specific token
1144    * Reverts if the token does not exist
1145    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1146    */
1147   function _burn(address _owner, uint256 _tokenId) internal {
1148     clearApproval(_owner, _tokenId);
1149     removeTokenFrom(_owner, _tokenId);
1150     emit Transfer(_owner, address(0), _tokenId);
1151   }
1152 
1153   /**
1154    * @dev Internal function to clear current approval of a given token ID
1155    * Reverts if the given address is not indeed the owner of the token
1156    * @param _owner owner of the token
1157    * @param _tokenId uint256 ID of the token to be transferred
1158    */
1159   function clearApproval(address _owner, uint256 _tokenId) internal {
1160     require(ownerOf(_tokenId) == _owner);
1161     if (tokenApprovals[_tokenId] != address(0)) {
1162       tokenApprovals[_tokenId] = address(0);
1163     }
1164   }
1165 
1166   /**
1167    * @dev Internal function to add a token ID to the list of a given address
1168    * @param _to address representing the new owner of the given token ID
1169    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1170    */
1171   function addTokenTo(address _to, uint256 _tokenId) internal {
1172     require(tokenOwner[_tokenId] == address(0));
1173     tokenOwner[_tokenId] = _to;
1174     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1175   }
1176 
1177   /**
1178    * @dev Internal function to remove a token ID from the list of a given address
1179    * @param _from address representing the previous owner of the given token ID
1180    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1181    */
1182   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1183     require(ownerOf(_tokenId) == _from);
1184     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1185     tokenOwner[_tokenId] = address(0);
1186   }
1187 
1188   /**
1189    * @dev Internal function to invoke `onERC721Received` on a target address
1190    * The call is not executed if the target address is not a contract
1191    * @param _from address representing the previous owner of the given token ID
1192    * @param _to target address that will receive the tokens
1193    * @param _tokenId uint256 ID of the token to be transferred
1194    * @param _data bytes optional data to send along with the call
1195    * @return whether the call correctly returned the expected magic value
1196    */
1197   function checkAndCallSafeTransfer(
1198     address _from,
1199     address _to,
1200     uint256 _tokenId,
1201     bytes _data
1202   )
1203     internal
1204     returns (bool)
1205   {
1206     if (!_to.isContract()) {
1207       return true;
1208     }
1209     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1210       msg.sender, _from, _tokenId, _data);
1211     return (retval == ERC721_RECEIVED);
1212   }
1213 }
1214 
1215 
1216 // File openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol@v1.12.0
1217 
1218 /**
1219  * @title Full ERC721 Token
1220  * This implementation includes all the required and some optional functionality of the ERC721 standard
1221  * Moreover, it includes approve all functionality using operator terminology
1222  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1223  */
1224 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1225 
1226   // Token name
1227   string internal name_;
1228 
1229   // Token symbol
1230   string internal symbol_;
1231 
1232   // Mapping from owner to list of owned token IDs
1233   mapping(address => uint256[]) internal ownedTokens;
1234 
1235   // Mapping from token ID to index of the owner tokens list
1236   mapping(uint256 => uint256) internal ownedTokensIndex;
1237 
1238   // Array with all token ids, used for enumeration
1239   uint256[] internal allTokens;
1240 
1241   // Mapping from token id to position in the allTokens array
1242   mapping(uint256 => uint256) internal allTokensIndex;
1243 
1244   // Optional mapping for token URIs
1245   mapping(uint256 => string) internal tokenURIs;
1246 
1247   /**
1248    * @dev Constructor function
1249    */
1250   constructor(string _name, string _symbol) public {
1251     name_ = _name;
1252     symbol_ = _symbol;
1253 
1254     // register the supported interfaces to conform to ERC721 via ERC165
1255     _registerInterface(InterfaceId_ERC721Enumerable);
1256     _registerInterface(InterfaceId_ERC721Metadata);
1257   }
1258 
1259   /**
1260    * @dev Gets the token name
1261    * @return string representing the token name
1262    */
1263   function name() external view returns (string) {
1264     return name_;
1265   }
1266 
1267   /**
1268    * @dev Gets the token symbol
1269    * @return string representing the token symbol
1270    */
1271   function symbol() external view returns (string) {
1272     return symbol_;
1273   }
1274 
1275   /**
1276    * @dev Returns an URI for a given token ID
1277    * Throws if the token ID does not exist. May return an empty string.
1278    * @param _tokenId uint256 ID of the token to query
1279    */
1280   function tokenURI(uint256 _tokenId) public view returns (string) {
1281     require(exists(_tokenId));
1282     return tokenURIs[_tokenId];
1283   }
1284 
1285   /**
1286    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1287    * @param _owner address owning the tokens list to be accessed
1288    * @param _index uint256 representing the index to be accessed of the requested tokens list
1289    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1290    */
1291   function tokenOfOwnerByIndex(
1292     address _owner,
1293     uint256 _index
1294   )
1295     public
1296     view
1297     returns (uint256)
1298   {
1299     require(_index < balanceOf(_owner));
1300     return ownedTokens[_owner][_index];
1301   }
1302 
1303   /**
1304    * @dev Gets the total amount of tokens stored by the contract
1305    * @return uint256 representing the total amount of tokens
1306    */
1307   function totalSupply() public view returns (uint256) {
1308     return allTokens.length;
1309   }
1310 
1311   /**
1312    * @dev Gets the token ID at a given index of all the tokens in this contract
1313    * Reverts if the index is greater or equal to the total number of tokens
1314    * @param _index uint256 representing the index to be accessed of the tokens list
1315    * @return uint256 token ID at the given index of the tokens list
1316    */
1317   function tokenByIndex(uint256 _index) public view returns (uint256) {
1318     require(_index < totalSupply());
1319     return allTokens[_index];
1320   }
1321 
1322   /**
1323    * @dev Internal function to set the token URI for a given token
1324    * Reverts if the token ID does not exist
1325    * @param _tokenId uint256 ID of the token to set its URI
1326    * @param _uri string URI to assign
1327    */
1328   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1329     require(exists(_tokenId));
1330     tokenURIs[_tokenId] = _uri;
1331   }
1332 
1333   /**
1334    * @dev Internal function to add a token ID to the list of a given address
1335    * @param _to address representing the new owner of the given token ID
1336    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1337    */
1338   function addTokenTo(address _to, uint256 _tokenId) internal {
1339     super.addTokenTo(_to, _tokenId);
1340     uint256 length = ownedTokens[_to].length;
1341     ownedTokens[_to].push(_tokenId);
1342     ownedTokensIndex[_tokenId] = length;
1343   }
1344 
1345   /**
1346    * @dev Internal function to remove a token ID from the list of a given address
1347    * @param _from address representing the previous owner of the given token ID
1348    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1349    */
1350   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1351     super.removeTokenFrom(_from, _tokenId);
1352 
1353     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1354     // then delete the last slot.
1355     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1356     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1357     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1358 
1359     ownedTokens[_from][tokenIndex] = lastToken;
1360     // This also deletes the contents at the last position of the array
1361     ownedTokens[_from].length--;
1362 
1363     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1364     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1365     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1366 
1367     ownedTokensIndex[_tokenId] = 0;
1368     ownedTokensIndex[lastToken] = tokenIndex;
1369   }
1370 
1371   /**
1372    * @dev Internal function to mint a new token
1373    * Reverts if the given token ID already exists
1374    * @param _to address the beneficiary that will own the minted token
1375    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1376    */
1377   function _mint(address _to, uint256 _tokenId) internal {
1378     super._mint(_to, _tokenId);
1379 
1380     allTokensIndex[_tokenId] = allTokens.length;
1381     allTokens.push(_tokenId);
1382   }
1383 
1384   /**
1385    * @dev Internal function to burn a specific token
1386    * Reverts if the token does not exist
1387    * @param _owner owner of the token to burn
1388    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1389    */
1390   function _burn(address _owner, uint256 _tokenId) internal {
1391     super._burn(_owner, _tokenId);
1392 
1393     // Clear metadata (if any)
1394     if (bytes(tokenURIs[_tokenId]).length != 0) {
1395       delete tokenURIs[_tokenId];
1396     }
1397 
1398     // Reorg all tokens array
1399     uint256 tokenIndex = allTokensIndex[_tokenId];
1400     uint256 lastTokenIndex = allTokens.length.sub(1);
1401     uint256 lastToken = allTokens[lastTokenIndex];
1402 
1403     allTokens[tokenIndex] = lastToken;
1404     allTokens[lastTokenIndex] = 0;
1405 
1406     allTokens.length--;
1407     allTokensIndex[_tokenId] = 0;
1408     allTokensIndex[lastToken] = tokenIndex;
1409   }
1410 
1411 }
1412 
1413 
1414 // File contracts/MintableERC721Token.sol
1415 
1416 // @TODO - finish this
1417 contract MintableERC721Token is ERC721Token {
1418   constructor(string name, string symbol)
1419     ERC721Token(name, symbol)
1420     public
1421   {
1422 
1423   }
1424 }
1425 
1426 
1427 // File openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol@v1.12.0
1428 
1429 /**
1430  * @title DetailedERC20 token
1431  * @dev The decimals are only for visualization purposes.
1432  * All the operations are done using the smallest and indivisible token unit,
1433  * just as on Ethereum all the operations are done in wei.
1434  */
1435 contract DetailedERC20 is ERC20 {
1436   string public name;
1437   string public symbol;
1438   uint8 public decimals;
1439 
1440   constructor(string _name, string _symbol, uint8 _decimals) public {
1441     name = _name;
1442     symbol = _symbol;
1443     decimals = _decimals;
1444   }
1445 }
1446 
1447 
1448 // File openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol@v1.12.0
1449 
1450 /**
1451  * @title Basic token
1452  * @dev Basic version of StandardToken, with no allowances.
1453  */
1454 contract BasicToken is ERC20Basic {
1455   using SafeMath for uint256;
1456 
1457   mapping(address => uint256) internal balances;
1458 
1459   uint256 internal totalSupply_;
1460 
1461   /**
1462   * @dev Total number of tokens in existence
1463   */
1464   function totalSupply() public view returns (uint256) {
1465     return totalSupply_;
1466   }
1467 
1468   /**
1469   * @dev Transfer token for a specified address
1470   * @param _to The address to transfer to.
1471   * @param _value The amount to be transferred.
1472   */
1473   function transfer(address _to, uint256 _value) public returns (bool) {
1474     require(_value <= balances[msg.sender]);
1475     require(_to != address(0));
1476 
1477     balances[msg.sender] = balances[msg.sender].sub(_value);
1478     balances[_to] = balances[_to].add(_value);
1479     emit Transfer(msg.sender, _to, _value);
1480     return true;
1481   }
1482 
1483   /**
1484   * @dev Gets the balance of the specified address.
1485   * @param _owner The address to query the the balance of.
1486   * @return An uint256 representing the amount owned by the passed address.
1487   */
1488   function balanceOf(address _owner) public view returns (uint256) {
1489     return balances[_owner];
1490   }
1491 
1492 }
1493 
1494 
1495 // File openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol@v1.12.0
1496 
1497 /**
1498  * @title Standard ERC20 token
1499  *
1500  * @dev Implementation of the basic standard token.
1501  * https://github.com/ethereum/EIPs/issues/20
1502  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1503  */
1504 contract StandardToken is ERC20, BasicToken {
1505 
1506   mapping (address => mapping (address => uint256)) internal allowed;
1507 
1508 
1509   /**
1510    * @dev Transfer tokens from one address to another
1511    * @param _from address The address which you want to send tokens from
1512    * @param _to address The address which you want to transfer to
1513    * @param _value uint256 the amount of tokens to be transferred
1514    */
1515   function transferFrom(
1516     address _from,
1517     address _to,
1518     uint256 _value
1519   )
1520     public
1521     returns (bool)
1522   {
1523     require(_value <= balances[_from]);
1524     require(_value <= allowed[_from][msg.sender]);
1525     require(_to != address(0));
1526 
1527     balances[_from] = balances[_from].sub(_value);
1528     balances[_to] = balances[_to].add(_value);
1529     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1530     emit Transfer(_from, _to, _value);
1531     return true;
1532   }
1533 
1534   /**
1535    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1536    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1537    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1538    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1539    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1540    * @param _spender The address which will spend the funds.
1541    * @param _value The amount of tokens to be spent.
1542    */
1543   function approve(address _spender, uint256 _value) public returns (bool) {
1544     allowed[msg.sender][_spender] = _value;
1545     emit Approval(msg.sender, _spender, _value);
1546     return true;
1547   }
1548 
1549   /**
1550    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1551    * @param _owner address The address which owns the funds.
1552    * @param _spender address The address which will spend the funds.
1553    * @return A uint256 specifying the amount of tokens still available for the spender.
1554    */
1555   function allowance(
1556     address _owner,
1557     address _spender
1558    )
1559     public
1560     view
1561     returns (uint256)
1562   {
1563     return allowed[_owner][_spender];
1564   }
1565 
1566   /**
1567    * @dev Increase the amount of tokens that an owner allowed to a spender.
1568    * approve should be called when allowed[_spender] == 0. To increment
1569    * allowed value is better to use this function to avoid 2 calls (and wait until
1570    * the first transaction is mined)
1571    * From MonolithDAO Token.sol
1572    * @param _spender The address which will spend the funds.
1573    * @param _addedValue The amount of tokens to increase the allowance by.
1574    */
1575   function increaseApproval(
1576     address _spender,
1577     uint256 _addedValue
1578   )
1579     public
1580     returns (bool)
1581   {
1582     allowed[msg.sender][_spender] = (
1583       allowed[msg.sender][_spender].add(_addedValue));
1584     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1585     return true;
1586   }
1587 
1588   /**
1589    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1590    * approve should be called when allowed[_spender] == 0. To decrement
1591    * allowed value is better to use this function to avoid 2 calls (and wait until
1592    * the first transaction is mined)
1593    * From MonolithDAO Token.sol
1594    * @param _spender The address which will spend the funds.
1595    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1596    */
1597   function decreaseApproval(
1598     address _spender,
1599     uint256 _subtractedValue
1600   )
1601     public
1602     returns (bool)
1603   {
1604     uint256 oldValue = allowed[msg.sender][_spender];
1605     if (_subtractedValue >= oldValue) {
1606       allowed[msg.sender][_spender] = 0;
1607     } else {
1608       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1609     }
1610     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1611     return true;
1612   }
1613 
1614 }
1615 
1616 
1617 // File openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol@v1.12.0
1618 
1619 /**
1620  * @title Mintable token
1621  * @dev Simple ERC20 Token example, with mintable token creation
1622  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1623  */
1624 contract MintableToken is StandardToken, Ownable {
1625   event Mint(address indexed to, uint256 amount);
1626   event MintFinished();
1627 
1628   bool public mintingFinished = false;
1629 
1630 
1631   modifier canMint() {
1632     require(!mintingFinished);
1633     _;
1634   }
1635 
1636   modifier hasMintPermission() {
1637     require(msg.sender == owner);
1638     _;
1639   }
1640 
1641   /**
1642    * @dev Function to mint tokens
1643    * @param _to The address that will receive the minted tokens.
1644    * @param _amount The amount of tokens to mint.
1645    * @return A boolean that indicates if the operation was successful.
1646    */
1647   function mint(
1648     address _to,
1649     uint256 _amount
1650   )
1651     public
1652     hasMintPermission
1653     canMint
1654     returns (bool)
1655   {
1656     totalSupply_ = totalSupply_.add(_amount);
1657     balances[_to] = balances[_to].add(_amount);
1658     emit Mint(_to, _amount);
1659     emit Transfer(address(0), _to, _amount);
1660     return true;
1661   }
1662 
1663   /**
1664    * @dev Function to stop minting new tokens.
1665    * @return True if the operation was successful.
1666    */
1667   function finishMinting() public onlyOwner canMint returns (bool) {
1668     mintingFinished = true;
1669     emit MintFinished();
1670     return true;
1671   }
1672 }
1673 
1674 
1675 // File contracts/mocks/MockToken.sol
1676 
1677 contract MockToken is DetailedERC20, MintableToken {
1678   constructor(string _name, string _symbol, uint8 _decimals)
1679     DetailedERC20(_name, _symbol, _decimals)
1680     public
1681   {
1682 
1683   }
1684 }
1685 
1686 
1687 // File contracts/old/ClaimableToken.sol
1688 
1689 // import "./MintableERC721Token.sol";
1690 // import "openzeppelin-solidity/contracts/token/ERC721/DefaultTokenURI.sol";
1691 
1692 
1693 // contract ClaimableToken is DefaultTokenURI, MintableERC721Token {
1694 
1695 //   constructor(string _name, string _symbol, string _tokenURI)
1696 //     MintableERC721Token(_name, _symbol)
1697 //     DefaultTokenURI(_tokenURI)
1698 //     public
1699 //   {
1700 
1701 //   }
1702 // }
1703 
1704 
1705 // File contracts/old/ClaimableTokenDeployer.sol
1706 
1707 // import "./ClaimableTokenMinter.sol";
1708 // import "./ClaimableToken.sol";
1709 
1710 
1711 // contract ClaimableTokenDeployer {
1712 //   ClaimableToken public token;
1713 //   ClaimableTokenMinter public minter;
1714 
1715 //   constructor(
1716 //     string _name,
1717 //     string _symbol,
1718 //     string _tokenURI,
1719 //     address _bouncer
1720 //   )
1721 //     public
1722 //   {
1723 //     token = new ClaimableToken(_name, _symbol, _tokenURI);
1724 //     minter = new ClaimableTokenMinter(token);
1725 //     token.addOwner(msg.sender);
1726 //     token.addMinter(address(minter));
1727 //     minter.addOwner(msg.sender);
1728 //     minter.addBouncer(_bouncer);
1729 //   }
1730 // }
1731 
1732 
1733 // File contracts/old/ClaimableTokenMinter.sol
1734 
1735 // import "./ClaimableToken.sol";
1736 // import "openzeppelin-solidity/contracts/access/ERC721Minter.sol";
1737 // import "openzeppelin-solidity/contracts/access/NonceTracker.sol";
1738 
1739 
1740 // contract ClaimableTokenMinter is NonceTracker, ERC721Minter {
1741 
1742 //   constructor(ClaimableToken _token)
1743 //     ERC721Minter(_token)
1744 //     public
1745 //   {
1746 
1747 //   }
1748 
1749 //   function mint(bytes _sig)
1750 //     withAccess(msg.sender, 1)
1751 //     public
1752 //     returns (uint256)
1753 //   {
1754 //     return super.mint(_sig);
1755 //   }
1756 // }