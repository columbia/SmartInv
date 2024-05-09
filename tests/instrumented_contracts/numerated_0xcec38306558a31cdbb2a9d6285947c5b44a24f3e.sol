1 pragma solidity ^0.5.10;
2 
3 /**
4  * Innovative fantasy sports gaming ERC-20 token & arcade based on 
5  * blockchain technology and Ethereum smart contracts.
6  * The global leader and cryptocurrency for the $7 Billion Fantasy Sports & ESPORTS Industry. 
7  * DFS is designed to give sports fans the opportunity to show their knowledge, 
8  * allowing users to use DFS (Token) as a means of confidence of how likely their
9  * sports predictions are correct against other people around the world.
10  * 
11  * Official Site: https://www.digitalfantasysports.com
12  * Twitter: https://twitter.com/dfstoken
13  * Telegram: https://t.me/digitalfantasysportsdfs
14  * Instagram: https://www.instagram.com/dfstoken/
15  */
16 
17 
18 /**
19  * @title ERC20Basic
20  * @dev Simpler version of ERC20 interface
21  * See https://github.com/ethereum/EIPs/issues/179
22  */
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35 
36   /**
37   * @dev Multiplies two numbers, throws on overflow.
38   */
39   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
41     // benefit is lost if 'b' is also tested.
42     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43     if (a == 0) {
44       return 0;
45     }
46 
47     c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     // uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return a / b;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 /**
81  * @title Basic token
82  * @dev Basic version of StandardToken, with no allowances.
83  */
84 contract BasicToken is ERC20Basic {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88 
89   uint256 totalSupply_;
90 
91   /**
92   * @dev Total number of tokens in existence
93   */
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97 
98   /**
99   * @dev Transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[msg.sender]);
106 
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     emit Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 
144 /**
145  * @title Standard ERC20 token
146  *
147  * @dev Implementation of the basic standard token.
148  * https://github.com/ethereum/EIPs/issues/20
149  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
150  */
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) internal allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(
163     address _from,
164     address _to,
165     uint256 _value
166   )
167     public
168     returns (bool)
169   {
170     require(_to != address(0));
171     require(_value <= balances[_from]);
172     require(_value <= allowed[_from][msg.sender]);
173 
174     balances[_from] = balances[_from].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177     emit Transfer(_from, _to, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(
203     address _owner,
204     address _spender
205    )
206     public
207     view
208     returns (uint256)
209   {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint256 _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(
245     address _spender,
246     uint256 _subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     uint256 oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 /**
264  * @title Ownable
265  * @dev The Ownable contract has an owner address, and provides basic authorization control
266  * functions, this simplifies the implementation of "user permissions".
267  */
268 contract Ownable {
269   address payable public owner;
270 
271 
272   event OwnershipRenounced(address indexed previousOwner);
273   event OwnershipTransferred(
274     address indexed previousOwner,
275     address indexed newOwner
276   );
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   constructor() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to relinquish control of the contract.
297    * @notice Renouncing to ownership will leave the contract without an owner.
298    * It will not be possible to call the functions with the `onlyOwner`
299    * modifier anymore.
300    */
301   function renounceOwnership() public onlyOwner {
302     emit OwnershipRenounced(owner);
303     owner = address(0);
304   }
305 
306   /**
307    * @dev Allows the current owner to transfer control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function transferOwnership(address payable _newOwner) public onlyOwner {
311     _transferOwnership(_newOwner);
312   }
313 
314   /**
315    * @dev Transfers control of the contract to a newOwner.
316    * @param _newOwner The address to transfer ownership to.
317    */
318   function _transferOwnership(address payable _newOwner) internal {
319     require(_newOwner != address(0));
320     emit OwnershipTransferred(owner, _newOwner);
321     owner = _newOwner;
322   }
323 }
324 
325 /**
326  * @title Mintable token
327  * @dev Simple ERC20 Token example, with mintable token creation
328  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
329  */
330 contract MintableToken is StandardToken, Ownable {
331   event Mint(address indexed to, uint256 amount);
332   event MintFinished();
333 
334   bool public mintingFinished = false;
335 
336 
337   modifier canMint() {
338     require(!mintingFinished);
339     _;
340   }
341 
342   modifier hasMintPermission() {
343     require(msg.sender == owner);
344     _;
345   }
346 
347   /**
348    * @dev Function to mint tokens
349    * @param _to The address that will receive the minted tokens.
350    * @param _amount The amount of tokens to mint.
351    * @return A boolean that indicates if the operation was successful.
352    */
353   function mint(
354     address _to,
355     uint256 _amount
356   )
357     hasMintPermission
358     canMint
359     public
360     returns (bool)
361   {
362     totalSupply_ = totalSupply_.add(_amount);
363     balances[_to] = balances[_to].add(_amount);
364     emit Mint(_to, _amount);
365     emit Transfer(address(0), _to, _amount);
366     return true;
367   }
368 
369   /**
370    * @dev Function to stop minting new tokens.
371    * @return True if the operation was successful.
372    */
373   function finishMinting() onlyOwner canMint public returns (bool) {
374     mintingFinished = true;
375     emit MintFinished();
376     return true;
377   }
378 }
379 
380 /**
381  * @title Contracts that should not own Ether
382  * @author Remco Bloemen <remco@2π.com>
383  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
384  * in the contract, it will allow the owner to reclaim this ether.
385  * @notice Ether can still be sent to this contract by:
386  * calling functions labeled `payable`
387  * `selfdestruct(contract_address)`
388  * mining directly to the contract address
389  */
390 contract HasNoEther is Ownable {
391 
392   /**
393   * @dev Constructor that rejects incoming Ether
394   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
395   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
396   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
397   * we could use assembly to access msg.value.
398   */
399   constructor() public payable {
400     require(msg.value == 0);
401   }
402 
403   /**
404    * @dev Disallows direct send by settings a default function without the `payable` flag.
405    */
406   function() external {
407   }
408 
409   /**
410    * @dev Transfer all Ether held by the contract to the owner.
411    */
412   function reclaimEther() external onlyOwner {
413     owner.transfer(address(this).balance);
414   }
415 }
416 
417 /**
418  * @title SafeERC20
419  * @dev Wrappers around ERC20 operations that throw on failure.
420  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
422  */
423 library SafeERC20 {
424   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
425     require(token.transfer(to, value));
426   }
427 
428   function safeTransferFrom(
429     ERC20 token,
430     address from,
431     address to,
432     uint256 value
433   )
434     internal
435   {
436     require(token.transferFrom(from, to, value));
437   }
438 
439   function safeApprove(ERC20 token, address spender, uint256 value) internal {
440     require(token.approve(spender, value));
441   }
442 }
443 
444 /**
445  * @title Contracts that should be able to recover tokens
446  * @author SylTi
447  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
448  * This will prevent any accidental loss of tokens.
449  */
450 contract CanReclaimToken is Ownable {
451   using SafeERC20 for ERC20Basic;
452 
453   /**
454    * @dev Reclaim all ERC20Basic compatible tokens
455    * @param token ERC20Basic The address of the token contract
456    */
457   function reclaimToken(ERC20Basic token) external onlyOwner {
458     uint256 balance = token.balanceOf(address(this));
459     token.safeTransfer(owner, balance);
460   }
461 
462 }
463 
464 /**
465  * @title Contracts that should not own Tokens
466  * @author Remco Bloemen <remco@2π.com>
467  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
468  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
469  * owner to reclaim the tokens.
470  */
471 contract HasNoTokens is CanReclaimToken {
472 
473  /**
474   * @dev Reject all ERC223 compatible tokens
475   * @param from_ address The address that is transferring the tokens
476   * @param value_ uint256 the amount of the specified token
477   * @param data_ Bytes The data passed from the caller.
478   */
479   function tokenFallback(address from_, uint256 value_, bytes calldata data_) pure external {
480     from_;
481     value_;
482     data_;
483     revert();
484   }
485 
486 }
487 
488 /**
489  * @title Contracts that should not own Contracts
490  * @author Remco Bloemen <remco@2π.com>
491  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
492  * of this contract to reclaim ownership of the contracts.
493  */
494 contract HasNoContracts is Ownable {
495 
496   /**
497    * @dev Reclaim ownership of Ownable contracts
498    * @param contractAddr The address of the Ownable to be reclaimed.
499    */
500   function reclaimContract(address contractAddr) external onlyOwner {
501     Ownable contractInst = Ownable(contractAddr);
502     contractInst.transferOwnership(owner);
503   }
504 }
505 
506 /**
507  * @title Base contract for contracts that should not own things.
508  * @author Remco Bloemen <remco@2π.com>
509  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
510  * Owned contracts. See respective base contracts for details.
511  */
512 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
513 }
514 
515 /**
516  * @title ERC865Token Token
517  *
518  * ERC865Token allows users paying transfers in tokens instead of gas
519  * https://github.com/ethereum/EIPs/issues/865
520  *
521  */
522 
523 contract ERC865 is ERC20 {
524 
525     function transferPreSigned(
526         bytes memory _signature,
527         address _to,
528         uint256 _value,
529         uint256 _fee,
530         uint256 _nonce
531     )
532         public
533         returns (bool);
534 
535     function approvePreSigned(
536         bytes memory _signature,
537         address _spender,
538         uint256 _value,
539         uint256 _fee,
540         uint256 _nonce
541     )
542         public
543         returns (bool);
544 
545     function increaseApprovalPreSigned(
546         bytes memory _signature,
547         address _spender,
548         uint256 _addedValue,
549         uint256 _fee,
550         uint256 _nonce
551     )
552         public
553         returns (bool);
554 
555     function decreaseApprovalPreSigned(
556         bytes memory _signature,
557         address _spender,
558         uint256 _subtractedValue,
559         uint256 _fee,
560         uint256 _nonce
561     )
562         public
563         returns (bool);
564 
565     function transferFromPreSigned(
566         bytes memory _signature,
567         address _from,
568         address _to,
569         uint256 _value,
570         uint256 _fee,
571         uint256 _nonce
572     )
573         public
574         returns (bool);
575 }
576 
577 
578 /**
579  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
580  *
581  * These functions can be used to verify that a message was signed by the holder
582  * of the private keys of a given address.
583  */
584 library ECDSA {
585     /**
586      * @dev Returns the address that signed a hashed message (`hash`) with
587      * `signature`. This address can then be used for verification purposes.
588      *
589      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
590      * this function rejects them by requiring the `s` value to be in the lower
591      * half order, and the `v` value to be either 27 or 28.
592      *
593      * (.note) This call _does not revert_ if the signature is invalid, or
594      * if the signer is otherwise unable to be retrieved. In those scenarios,
595      * the zero address is returned.
596      *
597      * (.warning) `hash` _must_ be the result of a hash operation for the
598      * verification to be secure: it is possible to craft signatures that
599      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
600      * this is by receiving a hash of the original message (which may otherwise)
601      * be too long), and then calling `toEthSignedMessageHash` on it.
602      */
603     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
604         // Check the signature length
605         if (signature.length != 65) {
606             return (address(0));
607         }
608 
609         // Divide the signature in r, s and v variables
610         bytes32 r;
611         bytes32 s;
612         uint8 v;
613 
614         // ecrecover takes the signature parameters, and the only way to get them
615         // currently is to use assembly.
616         // solhint-disable-next-line no-inline-assembly
617         assembly {
618             r := mload(add(signature, 0x20))
619             s := mload(add(signature, 0x40))
620             v := byte(0, mload(add(signature, 0x60)))
621         }
622 
623         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
624         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
625         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
626         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
627         //
628         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
629         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
630         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
631         // these malleable signatures as well.
632         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
633             return address(0);
634         }
635 
636         if (v != 27 && v != 28) {
637             return address(0);
638         }
639 
640         // If the signature is valid (and not malleable), return the signer address
641         return ecrecover(hash, v, r, s);
642     }
643 
644     /**
645      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
646      * replicates the behavior of the
647      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
648      * JSON-RPC method.
649      *
650      * See `recover`.
651      */
652     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
653         // 32 is the length in bytes of hash,
654         // enforced by the type signature above
655         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
656     }
657 }
658 
659 /**
660  * @title ERC865Token Token
661  *
662  * ERC865Token allows users paying transfers in tokens instead of gas
663  * https://github.com/ethereum/EIPs/issues/865
664  *
665  */
666 
667 contract ERC865Token is ERC865, StandardToken {
668     using ECDSA for bytes32;
669 
670     /* Nonces of transfers performed */
671     mapping(bytes => bool) signatures;
672 
673     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
674     event ApprovalPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
675 
676     /**
677      * @notice Submit a presigned transfer
678      * @param _signature bytes The signature, issued by the owner.
679      * @param _to address The address which you want to transfer to.
680      * @param _value uint256 The amount of tokens to be transferred.
681      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
682      * @param _nonce uint256 Presigned transaction number.
683      */
684     function transferPreSigned(
685         bytes memory _signature,
686         address _to,
687         uint256 _value,
688         uint256 _fee,
689         uint256 _nonce
690     )
691         public
692         returns (bool)
693     {
694         require(_to != address(0));
695         require(signatures[_signature] == false);
696 
697         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
698 
699         address from = recover(hashedTx, _signature);
700         require(from != address(0));
701 
702         balances[from] = balances[from].sub(_value).sub(_fee);
703         balances[_to] = balances[_to].add(_value);
704         balances[msg.sender] = balances[msg.sender].add(_fee);
705         signatures[_signature] = true;
706 
707         emit Transfer(from, _to, _value);
708         emit Transfer(from, msg.sender, _fee);
709         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
710         return true;
711     }
712 
713     /**
714      * @notice Submit a presigned approval
715      * @param _signature bytes The signature, issued by the owner.
716      * @param _spender address The address which will spend the funds.
717      * @param _value uint256 The amount of tokens to allow.
718      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
719      * @param _nonce uint256 Presigned transaction number.
720      */
721     function approvePreSigned(
722         bytes memory _signature,
723         address _spender,
724         uint256 _value,
725         uint256 _fee,
726         uint256 _nonce
727     )
728         public
729         returns (bool)
730     {
731         require(_spender != address(0));
732         require(signatures[_signature] == false);
733 
734         bytes32 hashedTx = approvePreSignedHashing(address(this), _spender, _value, _fee, _nonce);
735         address from = recover(hashedTx, _signature);
736         require(from != address(0));
737 
738         allowed[from][_spender] = _value;
739         balances[from] = balances[from].sub(_fee);
740         balances[msg.sender] = balances[msg.sender].add(_fee);
741         signatures[_signature] = true;
742 
743         emit Approval(from, _spender, _value);
744         emit Transfer(from, msg.sender, _fee);
745         emit ApprovalPreSigned(from, _spender, msg.sender, _value, _fee);
746         return true;
747     }
748 
749     /**
750      * @notice Increase the amount of tokens that an owner allowed to a spender.
751      * @param _signature bytes The signature, issued by the owner.
752      * @param _spender address The address which will spend the funds.
753      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
754      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
755      * @param _nonce uint256 Presigned transaction number.
756      */
757     function increaseApprovalPreSigned(
758         bytes memory _signature,
759         address _spender,
760         uint256 _addedValue,
761         uint256 _fee,
762         uint256 _nonce
763     )
764         public
765         returns (bool)
766     {
767         require(_spender != address(0));
768         require(signatures[_signature] == false);
769 
770         bytes32 hashedTx = increaseApprovalPreSignedHashing(address(this), _spender, _addedValue, _fee, _nonce);
771         address from = recover(hashedTx, _signature);
772         require(from != address(0));
773 
774         allowed[from][_spender] = allowed[from][_spender].add(_addedValue);
775         balances[from] = balances[from].sub(_fee);
776         balances[msg.sender] = balances[msg.sender].add(_fee);
777         signatures[_signature] = true;
778 
779         emit Approval(from, _spender, allowed[from][_spender]);
780         emit Transfer(from, msg.sender, _fee);
781         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
782         return true;
783     }
784 
785     /**
786      * @notice Decrease the amount of tokens that an owner allowed to a spender.
787      * @param _signature bytes The signature, issued by the owner
788      * @param _spender address The address which will spend the funds.
789      * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
790      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
791      * @param _nonce uint256 Presigned transaction number.
792      */
793     function decreaseApprovalPreSigned(
794         bytes memory _signature,
795         address _spender,
796         uint256 _subtractedValue,
797         uint256 _fee,
798         uint256 _nonce
799     )
800         public
801         returns (bool)
802     {
803         require(_spender != address(0));
804         require(signatures[_signature] == false);
805 
806         bytes32 hashedTx = decreaseApprovalPreSignedHashing(address(this), _spender, _subtractedValue, _fee, _nonce);
807         address from = recover(hashedTx, _signature);
808         require(from != address(0));
809 
810         uint oldValue = allowed[from][_spender];
811         if (_subtractedValue > oldValue) {
812             allowed[from][_spender] = 0;
813         } else {
814             allowed[from][_spender] = oldValue.sub(_subtractedValue);
815         }
816         balances[from] = balances[from].sub(_fee);
817         balances[msg.sender] = balances[msg.sender].add(_fee);
818         signatures[_signature] = true;
819 
820         emit Approval(from, _spender, _subtractedValue);
821         emit Transfer(from, msg.sender, _fee);
822         emit ApprovalPreSigned(from, _spender, msg.sender, allowed[from][_spender], _fee);
823         return true;
824     }
825 
826     /**
827      * @notice Transfer tokens from one address to another
828      * @param _signature bytes The signature, issued by the spender.
829      * @param _from address The address which you want to send tokens from.
830      * @param _to address The address which you want to transfer to.
831      * @param _value uint256 The amount of tokens to be transferred.
832      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
833      * @param _nonce uint256 Presigned transaction number.
834      */
835     function transferFromPreSigned(
836         bytes memory _signature,
837         address _from,
838         address _to,
839         uint256 _value,
840         uint256 _fee,
841         uint256 _nonce
842     )
843         public
844         returns (bool)
845     {
846         require(_to != address(0));
847         require(signatures[_signature] == false);
848 
849         bytes32 hashedTx = transferFromPreSignedHashing(address(this), _from, _to, _value, _fee, _nonce);
850 
851         address spender = recover(hashedTx, _signature);
852         require(spender != address(0));
853 
854         balances[_from] = balances[_from].sub(_value);
855         balances[_to] = balances[_to].add(_value);
856         allowed[_from][spender] = allowed[_from][spender].sub(_value);
857 
858         balances[spender] = balances[spender].sub(_fee);
859         balances[msg.sender] = balances[msg.sender].add(_fee);
860         signatures[_signature] = true;
861 
862         emit Transfer(_from, _to, _value);
863         emit Transfer(spender, msg.sender, _fee);
864         return true;
865     }
866 
867 
868     /**
869      * @notice Hash (keccak256) of the payload used by transferPreSigned
870      * @param _token address The address of the token.
871      * @param _to address The address which you want to transfer to.
872      * @param _value uint256 The amount of tokens to be transferred.
873      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
874      * @param _nonce uint256 Presigned transaction number.
875      */
876     function transferPreSignedHashing(
877         address _token,
878         address _to,
879         uint256 _value,
880         uint256 _fee,
881         uint256 _nonce
882     )
883         public
884         pure
885         returns (bytes32)
886     {
887         /* "48664c16": transferPreSignedHashing(address,address,address,uint256,uint256,uint256) */
888         return keccak256(abi.encodePacked(bytes4(0x48664c16), _token, _to, _value, _fee, _nonce));
889     }
890 
891     /**
892      * @notice Hash (keccak256) of the payload used by approvePreSigned
893      * @param _token address The address of the token
894      * @param _spender address The address which will spend the funds.
895      * @param _value uint256 The amount of tokens to allow.
896      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
897      * @param _nonce uint256 Presigned transaction number.
898      */
899     function approvePreSignedHashing(
900         address _token,
901         address _spender,
902         uint256 _value,
903         uint256 _fee,
904         uint256 _nonce
905     )
906         public
907         pure
908         returns (bytes32)
909     {
910         /* "f7ac9c2e": approvePreSignedHashing(address,address,uint256,uint256,uint256) */
911         return keccak256(abi.encodePacked(bytes4(0xf7ac9c2e), _token, _spender, _value, _fee, _nonce));
912     }
913 
914     /**
915      * @notice Hash (keccak256) of the payload used by increaseApprovalPreSigned
916      * @param _token address The address of the token
917      * @param _spender address The address which will spend the funds.
918      * @param _addedValue uint256 The amount of tokens to increase the allowance by.
919      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
920      * @param _nonce uint256 Presigned transaction number.
921      */
922     function increaseApprovalPreSignedHashing(
923         address _token,
924         address _spender,
925         uint256 _addedValue,
926         uint256 _fee,
927         uint256 _nonce
928     )
929         public
930         pure
931         returns (bytes32)
932     {
933         /* "a45f71ff": increaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
934         return keccak256(abi.encodePacked(bytes4(0xa45f71ff), _token, _spender, _addedValue, _fee, _nonce));
935     }
936 
937      /**
938       * @notice Hash (keccak256) of the payload used by decreaseApprovalPreSigned
939       * @param _token address The address of the token
940       * @param _spender address The address which will spend the funds.
941       * @param _subtractedValue uint256 The amount of tokens to decrease the allowance by.
942       * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
943       * @param _nonce uint256 Presigned transaction number.
944       */
945     function decreaseApprovalPreSignedHashing(
946         address _token,
947         address _spender,
948         uint256 _subtractedValue,
949         uint256 _fee,
950         uint256 _nonce
951     )
952         public
953         pure
954         returns (bytes32)
955     {
956         /* "59388d78": decreaseApprovalPreSignedHashing(address,address,uint256,uint256,uint256) */
957         return keccak256(abi.encodePacked(bytes4(0x59388d78), _token, _spender, _subtractedValue, _fee, _nonce));
958     }
959 
960     /**
961      * @notice Hash (keccak256) of the payload used by transferFromPreSigned
962      * @param _token address The address of the token
963      * @param _from address The address which you want to send tokens from.
964      * @param _to address The address which you want to transfer to.
965      * @param _value uint256 The amount of tokens to be transferred.
966      * @param _fee uint256 The amount of tokens paid to msg.sender, by the spender.
967      * @param _nonce uint256 Presigned transaction number.
968      */
969     function transferFromPreSignedHashing(
970         address _token,
971         address _from,
972         address _to,
973         uint256 _value,
974         uint256 _fee,
975         uint256 _nonce
976     )
977         public
978         pure
979         returns (bytes32)
980     {
981         /* "b7656dc5": transferFromPreSignedHashing(address,address,address,uint256,uint256,uint256) */
982         return keccak256(abi.encodePacked(bytes4(0xb7656dc5), _token, _from, _to, _value, _fee, _nonce));
983     }
984 
985     /**
986      * @notice Recover signer address from a message by using his signature
987      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
988      * @param sig bytes signature, the signature is generated using web3.eth.sign()
989      */
990     function recover(bytes32 hash, bytes memory sig) public pure returns (address) {
991         return hash.toEthSignedMessageHash().recover(sig);
992     }
993 }
994 
995 contract DFSToken is MintableToken, ERC865Token, NoOwner {
996     string public symbol = 'DFS';
997     string public name = 'Fantasy Sports';
998     uint8 public constant decimals = 18;
999 
1000     bool public transferEnabled;    //allows to dissable transfers while minting and in case of emergency
1001 
1002     function setTransferEnabled(bool enable) onlyOwner public {
1003         transferEnabled = enable;
1004     }
1005     modifier canTransfer() {
1006         require( transferEnabled || msg.sender == owner);
1007         _;
1008     }
1009     
1010     function transfer(address _to, uint256 _value) canTransfer public returns (bool) {
1011         return super.transfer(_to, _value);
1012     }
1013     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool) {
1014         return super.transferFrom(_from, _to, _value);
1015     }
1016 
1017     function transferPreSigned(
1018         bytes memory _signature,
1019         address _to,
1020         uint256 _value,
1021         uint256 _fee,
1022         uint256 _nonce
1023     )
1024         public
1025         canTransfer
1026         returns (bool)
1027     {
1028         return super.transferPreSigned(_signature, _to, _value, _fee, _nonce);
1029     }
1030     function transferFromPreSigned(
1031         bytes memory _signature,
1032         address _from,
1033         address _to,
1034         uint256 _value,
1035         uint256 _fee,
1036         uint256 _nonce
1037     )
1038         public
1039         canTransfer
1040         returns (bool)
1041     {
1042         return super.transferFromPreSigned(_signature, _from, _to, _value, _fee, _nonce);
1043     }
1044 }