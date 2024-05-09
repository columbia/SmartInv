1 /**
2  * MPSBoardSig.sol
3  * Governance smart contract including multi-signature capabilities.
4  * It uniquely represents the Board of Directors of Mt Pelerin Group SA on-chain
5  * until it is superseded by a resolution of the board referring to a new
6  * governance on-chain reference.
7 
8  * The unflattened code is available through this github tag:
9  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
10 
11  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
12 
13  * @notice All matters regarding the intellectual property of this code 
14  * @notice or software are subject to Swiss Law without reference to its 
15  * @notice conflicts of law rules.
16 
17  * @notice License for each contract is available in the respective file
18  * @notice or in the LICENSE.md file.
19  * @notice https://github.com/MtPelerin/
20 
21  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
22  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
23  */
24 
25 
26 pragma solidity ^0.4.24;
27 
28 // File: contracts/multisig/private/MultiSig.sol
29 
30 /**
31  * @title MultiSig
32  * @dev MultiSig contract
33  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
34 
35  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
36  * @notice Please refer to the top of this file for the license.
37 
38  * Error messages
39  * MS01: Valid signatures below threshold
40  * MS02: Transaction validity has expired
41  * MS03: Sender does not belong to signers
42  * MS04: Execution should be correct
43  */
44 contract MultiSig {
45   address[]  signers_;
46   uint8 public threshold;
47 
48   bytes32 public replayProtection;
49   uint256 public nonce;
50 
51   /**
52    * @dev constructor
53    */
54   constructor(address[] _signers, uint8 _threshold) public {
55     signers_ = _signers;
56     threshold = _threshold;
57 
58     // Prevent first transaction of different contracts
59     // to be replayed here
60     updateReplayProtection();
61   }
62 
63   /**
64    * @dev fallback function
65    */
66   function () public payable { }
67 
68   /**
69    * @dev read a function selector from a bytes field
70    * @param _data contains the selector
71    */
72   function readSelector(bytes _data) public pure returns (bytes4) {
73     bytes4 selector;
74     // solium-disable-next-line security/no-inline-assembly
75     assembly {
76       selector := mload(add(_data, 0x20))
77     }
78     return selector;
79   }
80 
81   /**
82    * @dev read ERC20 destination
83    * @param _data ERC20 transfert
84    */
85   function readERC20Destination(bytes _data) public pure returns (address) {
86     address destination;
87     // solium-disable-next-line security/no-inline-assembly
88     assembly {
89       destination := mload(add(_data, 0x24))
90     }
91     return destination;
92   }
93 
94   /**
95    * @dev read ERC20 value
96    * @param _data contains the selector
97    */
98   function readERC20Value(bytes _data) public pure returns (uint256) {
99     uint256 value;
100     // solium-disable-next-line security/no-inline-assembly
101     assembly {
102       value := mload(add(_data, 0x44))
103     }
104     return value;
105   }
106 
107   /**
108    * @dev Modifier verifying that valid signatures are above _threshold
109    */
110   modifier thresholdRequired(
111     address _destination, uint256 _value, bytes _data,
112     uint256 _validity, uint256 _threshold,
113     bytes32[] _sigR, bytes32[] _sigS, uint8[] _sigV)
114   {
115     require(
116       reviewSignatures(
117         _destination, _value, _data, _validity, _sigR, _sigS, _sigV
118       ) >= _threshold,
119       "MS01"
120     );
121     _;
122   }
123 
124   /**
125    * @dev Modifier verifying that transaction is still valid
126    * @dev This modifier also protects against replay on forked chain.
127    *
128    * @notice If both the _validity and gasPrice are low, then there is a risk
129    * @notice that the transaction is executed after its _validity but before it does timeout
130    * @notice In that case, the transaction will fail.
131    * @notice In general, it is recommended to use a _validity greater than the potential timeout
132    */
133   modifier stillValid(uint256 _validity)
134   {
135     if (_validity != 0) {
136       require(_validity >= block.number, "MS02");
137     }
138     _;
139   }
140 
141   /**
142    * @dev Modifier requiring that the message sender belongs to the signers
143    */
144   modifier onlySigners() {
145     bool found = false;
146     for (uint256 i = 0; i < signers_.length && !found; i++) {
147       found = (msg.sender == signers_[i]);
148     }
149     require(found, "MS03");
150     _;
151   }
152 
153   /**
154    * @dev returns signers
155    */
156   function signers() public view returns (address[]) {
157     return signers_;
158   }
159 
160   /**
161    * returns threshold
162    */
163   function threshold() public view returns (uint8) {
164     return threshold;
165   }
166 
167   /**
168    * @dev returns replayProtection
169    */
170   function replayProtection() public view returns (bytes32) {
171     return replayProtection;
172   }
173 
174   /**
175    * @dev returns nonce
176    */
177   function nonce() public view returns (uint256) {
178     return nonce;
179   }
180 
181   /**
182    * @dev returns the number of valid signatures
183    */
184   function reviewSignatures(
185     address _destination, uint256 _value, bytes _data,
186     uint256 _validity,
187     bytes32[] _sigR, bytes32[] _sigS, uint8[] _sigV)
188     public view returns (uint256)
189   {
190     return reviewSignaturesInternal(
191       _destination,
192       _value,
193       _data,
194       _validity,
195       signers_,
196       _sigR,
197       _sigS,
198       _sigV
199     );
200   }
201 
202   /**
203    * @dev buildHash
204    **/
205   function buildHash(
206     address _destination, uint256 _value,
207     bytes _data, uint256 _validity)
208     public view returns (bytes32)
209   {
210     // FIXME: web3/solidity behaves differently with empty bytes
211     if (_data.length == 0) {
212       return keccak256(
213         abi.encode(
214           _destination, _value, _validity, replayProtection
215         )
216       );
217     } else {
218       return keccak256(
219         abi.encode(
220           _destination, _value, _data, _validity, replayProtection
221         )
222       );
223     }
224   }
225 
226   /**
227    * @dev recover the public address from the signatures
228    **/
229   function recoverAddress(
230     address _destination, uint256 _value,
231     bytes _data, uint256 _validity,
232     bytes32 _r, bytes32 _s, uint8 _v)
233     public view returns (address)
234   {
235     // When used in web.eth.sign, geth will prepend the hash
236     bytes32 hash = keccak256(
237       abi.encodePacked("\x19Ethereum Signed Message:\n32",
238         buildHash(
239           _destination,
240           _value,
241           _data,
242           _validity
243         )
244       )
245     );
246 
247     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
248     uint8 v = (_v < 27) ? _v += 27: _v;
249 
250     // If the version is correct return the signer address
251     if (v != 27 && v != 28) {
252       return address(0);
253     } else {
254       return ecrecover(
255         hash,
256         v,
257         _r,
258         _s
259       );
260     }
261   }
262 
263   /**
264    * @dev execute a transaction if enough signatures are valid
265    **/
266   function execute(
267     bytes32[] _sigR,
268     bytes32[] _sigS,
269     uint8[] _sigV,
270     address _destination, uint256 _value, bytes _data, uint256 _validity)
271     public
272     stillValid(_validity)
273     thresholdRequired(_destination, _value, _data, _validity, threshold, _sigR, _sigS, _sigV)
274     returns (bool)
275   {
276     executeInternal(_destination, _value, _data);
277     return true;
278   }
279 
280   /**
281    * @dev review signatures against a list of signers
282    * Signatures must be provided in the same order as the list of signers
283    * All provided signatures must be valid and correspond to one of the signers
284    * returns the number of valid signatures
285    * returns 0 if the inputs are inconsistent
286    */
287   function reviewSignaturesInternal(
288     address _destination, uint256 _value, bytes _data, uint256 _validity,
289     address[] _signers,
290     bytes32[] _sigR, bytes32[] _sigS, uint8[] _sigV)
291     internal view returns (uint256)
292   {
293     uint256 length = _sigR.length;
294     if (length == 0 || length > _signers.length || (
295       _sigS.length != length || _sigV.length != length
296     ))
297     {
298       return 0;
299     }
300 
301     uint256 validSigs = 0;
302     address recovered = recoverAddress(
303       _destination, _value, _data, _validity, 
304       _sigR[0], _sigS[0], _sigV[0]);
305     for (uint256 i = 0; i < _signers.length; i++) {
306       if (_signers[i] == recovered) {
307         validSigs++;
308         if (validSigs < length) {
309           recovered = recoverAddress(
310             _destination,
311             _value,
312             _data,
313             _validity,
314             _sigR[validSigs],
315             _sigS[validSigs],
316             _sigV[validSigs]
317           );
318         } else {
319           break;
320         }
321       }
322     }
323 
324     if (validSigs != length) {
325       return 0;
326     }
327 
328     return validSigs;
329   }
330 
331   /**
332    * @dev execute a transaction
333    **/
334   function executeInternal(address _destination, uint256 _value, bytes _data)
335     internal
336   {
337     updateReplayProtection();
338     if (_data.length == 0) {
339       _destination.transfer(_value);
340     } else {
341       // solium-disable-next-line security/no-call-value
342       require(_destination.call.value(_value)(_data), "MS04");
343     }
344     emit Execution(_destination, _value, _data);
345   }
346 
347   /**
348    * @dev update replay protection
349    * contract address is used to prevent replay between different contracts
350    * block hash is used to prevent replay between branches
351    * nonce is used to prevent replay within the contract
352    **/
353   function updateReplayProtection() internal {
354     replayProtection = keccak256(
355       abi.encodePacked(address(this), blockhash(block.number-1), nonce));
356     nonce++;
357   }
358 
359   event Execution(address to, uint256 value, bytes data);
360 }
361 
362 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
363 
364 /**
365  * @title ERC20Basic
366  * @dev Simpler version of ERC20 interface
367  * @dev see https://github.com/ethereum/EIPs/issues/179
368  */
369 contract ERC20Basic {
370   function totalSupply() public view returns (uint256);
371   function balanceOf(address who) public view returns (uint256);
372   function transfer(address to, uint256 value) public returns (bool);
373   event Transfer(address indexed from, address indexed to, uint256 value);
374 }
375 
376 // File: contracts/zeppelin/math/SafeMath.sol
377 
378 /**
379  * @title SafeMath
380  * @dev Math operations with safety checks that throw on error
381  */
382 library SafeMath {
383 
384   /**
385   * @dev Multiplies two numbers, throws on overflow.
386   */
387   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
388     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
389     // benefit is lost if 'b' is also tested.
390     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
391     if (a == 0) {
392       return 0;
393     }
394 
395     c = a * b;
396     assert(c / a == b);
397     return c;
398   }
399 
400   /**
401   * @dev Integer division of two numbers, truncating the quotient.
402   */
403   function div(uint256 a, uint256 b) internal pure returns (uint256) {
404     // assert(b > 0); // Solidity automatically throws when dividing by 0
405     // uint256 c = a / b;
406     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
407     return a / b;
408   }
409 
410   /**
411   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
412   */
413   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
414     assert(b <= a);
415     return a - b;
416   }
417 
418   /**
419   * @dev Adds two numbers, throws on overflow.
420   */
421   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
422     c = a + b;
423     assert(c >= a);
424     return c;
425   }
426 }
427 
428 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
429 
430 /**
431  * @title Basic token
432  * @dev Basic version of StandardToken, with no allowances.
433  */
434 contract BasicToken is ERC20Basic {
435   using SafeMath for uint256;
436 
437   mapping(address => uint256) balances;
438 
439   uint256 totalSupply_;
440 
441   /**
442   * @dev total number of tokens in existence
443   */
444   function totalSupply() public view returns (uint256) {
445     return totalSupply_;
446   }
447 
448   /**
449   * @dev transfer token for a specified address
450   * @param _to The address to transfer to.
451   * @param _value The amount to be transferred.
452   */
453   function transfer(address _to, uint256 _value) public returns (bool) {
454     require(_to != address(0));
455     require(_value <= balances[msg.sender]);
456 
457     balances[msg.sender] = balances[msg.sender].sub(_value);
458     balances[_to] = balances[_to].add(_value);
459     emit Transfer(msg.sender, _to, _value);
460     return true;
461   }
462 
463   /**
464   * @dev Gets the balance of the specified address.
465   * @param _owner The address to query the the balance of.
466   * @return An uint256 representing the amount owned by the passed address.
467   */
468   function balanceOf(address _owner) public view returns (uint256) {
469     return balances[_owner];
470   }
471 
472 }
473 
474 // File: contracts/interface/ISeizable.sol
475 
476 /**
477  * @title ISeizable
478  * @dev ISeizable interface
479  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
480  *
481  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
482  * @notice Please refer to the top of this file for the license.
483  **/
484 contract ISeizable {
485   function seize(address _account, uint256 _value) public;
486   event Seize(address account, uint256 amount);
487 }
488 
489 // File: contracts/zeppelin/ownership/Ownable.sol
490 
491 /**
492  * @title Ownable
493  * @dev The Ownable contract has an owner address, and provides basic authorization control
494  * functions, this simplifies the implementation of "user permissions".
495  */
496 contract Ownable {
497   address public owner;
498 
499 
500   event OwnershipRenounced(address indexed previousOwner);
501   event OwnershipTransferred(
502     address indexed previousOwner,
503     address indexed newOwner
504   );
505 
506 
507   /**
508    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
509    * account.
510    */
511   constructor() public {
512     owner = msg.sender;
513   }
514 
515   /**
516    * @dev Throws if called by any account other than the owner.
517    */
518   modifier onlyOwner() {
519     require(msg.sender == owner);
520     _;
521   }
522 
523   /**
524    * @dev Allows the current owner to relinquish control of the contract.
525    */
526   function renounceOwnership() public onlyOwner {
527     emit OwnershipRenounced(owner);
528     owner = address(0);
529   }
530 
531   /**
532    * @dev Allows the current owner to transfer control of the contract to a newOwner.
533    * @param _newOwner The address to transfer ownership to.
534    */
535   function transferOwnership(address _newOwner) public onlyOwner {
536     _transferOwnership(_newOwner);
537   }
538 
539   /**
540    * @dev Transfers control of the contract to a newOwner.
541    * @param _newOwner The address to transfer ownership to.
542    */
543   function _transferOwnership(address _newOwner) internal {
544     require(_newOwner != address(0));
545     emit OwnershipTransferred(owner, _newOwner);
546     owner = _newOwner;
547   }
548 }
549 
550 // File: contracts/Authority.sol
551 
552 /**
553  * @title Authority
554  * @dev The Authority contract has an authority address, and provides basic authorization control
555  * functions, this simplifies the implementation of "user permissions".
556  * Authority means to represent a legal entity that is entitled to specific rights
557  *
558  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
559  *
560  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
561  * @notice Please refer to the top of this file for the license.
562  *
563  * Error messages
564  * AU01: Message sender must be an authority
565  */
566 contract Authority is Ownable {
567 
568   address authority;
569 
570   /**
571    * @dev Throws if called by any account other than the authority.
572    */
573   modifier onlyAuthority {
574     require(msg.sender == authority, "AU01");
575     _;
576   }
577 
578   /**
579    * @dev return the address associated to the authority
580    */
581   function authorityAddress() public view returns (address) {
582     return authority;
583   }
584 
585   /**
586    * @dev rdefines an authority
587    * @param _name the authority name
588    * @param _address the authority address.
589    */
590   function defineAuthority(string _name, address _address) public onlyOwner {
591     emit AuthorityDefined(_name, _address);
592     authority = _address;
593   }
594 
595   event AuthorityDefined(
596     string name,
597     address _address
598   );
599 }
600 
601 // File: contracts/token/component/SeizableToken.sol
602 
603 /**
604  * @title SeizableToken
605  * @dev BasicToken contract which allows owner to seize accounts
606  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
607  *
608  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
609  * @notice Please refer to the top of this file for the license.
610  *
611  * Error messages
612  * ST01: Owner cannot seize itself
613 */
614 contract SeizableToken is BasicToken, Authority, ISeizable {
615   using SafeMath for uint256;
616 
617   // Although very unlikely, the value below may overflow.
618   // This contract and its children should expect it to happened and consider
619   // this value as only the first 256 bits of the complete value.
620   uint256 public allTimeSeized = 0; // overflow may happend
621 
622   /**
623    * @dev called by the owner to seize value from the account
624    */
625   function seize(address _account, uint256 _value)
626     public onlyAuthority
627   {
628     require(_account != owner, "ST01");
629 
630     balances[_account] = balances[_account].sub(_value);
631     balances[authority] = balances[authority].add(_value);
632 
633     allTimeSeized += _value;
634     emit Seize(_account, _value);
635   }
636 }
637 
638 // File: contracts/zeppelin/token/ERC20/ERC20.sol
639 
640 /**
641  * @title ERC20 interface
642  * @dev see https://github.com/ethereum/EIPs/issues/20
643  */
644 contract ERC20 is ERC20Basic {
645   function allowance(address owner, address spender)
646     public view returns (uint256);
647 
648   function transferFrom(address from, address to, uint256 value)
649     public returns (bool);
650 
651   function approve(address spender, uint256 value) public returns (bool);
652   event Approval(
653     address indexed owner,
654     address indexed spender,
655     uint256 value
656   );
657 }
658 
659 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
660 
661 /**
662  * @title Standard ERC20 token
663  *
664  * @dev Implementation of the basic standard token.
665  * @dev https://github.com/ethereum/EIPs/issues/20
666  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
667  */
668 contract StandardToken is ERC20, BasicToken {
669 
670   mapping (address => mapping (address => uint256)) internal allowed;
671 
672 
673   /**
674    * @dev Transfer tokens from one address to another
675    * @param _from address The address which you want to send tokens from
676    * @param _to address The address which you want to transfer to
677    * @param _value uint256 the amount of tokens to be transferred
678    */
679   function transferFrom(
680     address _from,
681     address _to,
682     uint256 _value
683   )
684     public
685     returns (bool)
686   {
687     require(_to != address(0));
688     require(_value <= balances[_from]);
689     require(_value <= allowed[_from][msg.sender]);
690 
691     balances[_from] = balances[_from].sub(_value);
692     balances[_to] = balances[_to].add(_value);
693     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
694     emit Transfer(_from, _to, _value);
695     return true;
696   }
697 
698   /**
699    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
700    *
701    * Beware that changing an allowance with this method brings the risk that someone may use both the old
702    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
703    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
704    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
705    * @param _spender The address which will spend the funds.
706    * @param _value The amount of tokens to be spent.
707    */
708   function approve(address _spender, uint256 _value) public returns (bool) {
709     allowed[msg.sender][_spender] = _value;
710     emit Approval(msg.sender, _spender, _value);
711     return true;
712   }
713 
714   /**
715    * @dev Function to check the amount of tokens that an owner allowed to a spender.
716    * @param _owner address The address which owns the funds.
717    * @param _spender address The address which will spend the funds.
718    * @return A uint256 specifying the amount of tokens still available for the spender.
719    */
720   function allowance(
721     address _owner,
722     address _spender
723    )
724     public
725     view
726     returns (uint256)
727   {
728     return allowed[_owner][_spender];
729   }
730 
731   /**
732    * @dev Increase the amount of tokens that an owner allowed to a spender.
733    *
734    * approve should be called when allowed[_spender] == 0. To increment
735    * allowed value is better to use this function to avoid 2 calls (and wait until
736    * the first transaction is mined)
737    * From MonolithDAO Token.sol
738    * @param _spender The address which will spend the funds.
739    * @param _addedValue The amount of tokens to increase the allowance by.
740    */
741   function increaseApproval(
742     address _spender,
743     uint _addedValue
744   )
745     public
746     returns (bool)
747   {
748     allowed[msg.sender][_spender] = (
749       allowed[msg.sender][_spender].add(_addedValue));
750     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
751     return true;
752   }
753 
754   /**
755    * @dev Decrease the amount of tokens that an owner allowed to a spender.
756    *
757    * approve should be called when allowed[_spender] == 0. To decrement
758    * allowed value is better to use this function to avoid 2 calls (and wait until
759    * the first transaction is mined)
760    * From MonolithDAO Token.sol
761    * @param _spender The address which will spend the funds.
762    * @param _subtractedValue The amount of tokens to decrease the allowance by.
763    */
764   function decreaseApproval(
765     address _spender,
766     uint _subtractedValue
767   )
768     public
769     returns (bool)
770   {
771     uint oldValue = allowed[msg.sender][_spender];
772     if (_subtractedValue > oldValue) {
773       allowed[msg.sender][_spender] = 0;
774     } else {
775       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
776     }
777     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
778     return true;
779   }
780 
781 }
782 
783 // File: contracts/interface/IProvableOwnership.sol
784 
785 /**
786  * @title IProvableOwnership
787  * @dev IProvableOwnership interface which describe proof of ownership.
788  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
789  *
790  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
791  * @notice Please refer to the top of this file for the license.
792  **/
793 contract IProvableOwnership {
794   function proofLength(address _holder) public view returns (uint256);
795   function proofAmount(address _holder, uint256 _proofId)
796     public view returns (uint256);
797 
798   function proofDateFrom(address _holder, uint256 _proofId)
799     public view returns (uint256);
800 
801   function proofDateTo(address _holder, uint256 _proofId)
802     public view returns (uint256);
803 
804   function createProof(address _holder) public;
805   function checkProof(address _holder, uint256 _proofId, uint256 _at)
806     public view returns (uint256);
807 
808   function transferWithProofs(
809     address _to,
810     uint256 _value,
811     bool _proofFrom,
812     bool _proofTo
813     ) public returns (bool);
814 
815   function transferFromWithProofs(
816     address _from,
817     address _to,
818     uint256 _value,
819     bool _proofFrom,
820     bool _proofTo
821     ) public returns (bool);
822 
823   event ProofOfOwnership(address indexed holder, uint256 proofId);
824 }
825 
826 // File: contracts/interface/IAuditableToken.sol
827 
828 /**
829  * @title IAuditableToken
830  * @dev IAuditableToken interface describing the audited data
831  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
832  *
833  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
834  * @notice Please refer to the top of this file for the license.
835  **/
836 contract IAuditableToken {
837   function lastTransactionAt(address _address) public view returns (uint256);
838   function lastReceivedAt(address _address) public view returns (uint256);
839   function lastSentAt(address _address) public view returns (uint256);
840   function transactionCount(address _address) public view returns (uint256);
841   function receivedCount(address _address) public view returns (uint256);
842   function sentCount(address _address) public view returns (uint256);
843   function totalReceivedAmount(address _address) public view returns (uint256);
844   function totalSentAmount(address _address) public view returns (uint256);
845 }
846 
847 // File: contracts/token/component/AuditableToken.sol
848 
849 /**
850  * @title AuditableToken
851  * @dev AuditableToken contract
852  * AuditableToken provides transaction data which can be used
853  * in other smart contracts
854  *
855  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
856  *
857  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
858  * @notice Please refer to the top of this file for the license.
859  **/
860 contract AuditableToken is IAuditableToken, StandardToken {
861 
862    // Although very unlikely, the following values below may overflow:
863    //   receivedCount, sentCount, totalReceivedAmount, totalSentAmount
864    // This contract and its children should expect it to happen and consider
865    // these values as only the first 256 bits of the complete value.
866   struct Audit {
867     uint256 createdAt;
868     uint256 lastReceivedAt;
869     uint256 lastSentAt;
870     uint256 receivedCount; // potential overflow
871     uint256 sentCount; // poential overflow
872     uint256 totalReceivedAmount; // potential overflow
873     uint256 totalSentAmount; // potential overflow
874   }
875   mapping(address => Audit) internal audits;
876 
877   /**
878    * @dev Time of the creation of the audit struct
879    */
880   function auditCreatedAt(address _address) public view returns (uint256) {
881     return audits[_address].createdAt;
882   }
883 
884   /**
885    * @dev Time of the last transaction
886    */
887   function lastTransactionAt(address _address) public view returns (uint256) {
888     return ( audits[_address].lastReceivedAt > audits[_address].lastSentAt ) ?
889       audits[_address].lastReceivedAt : audits[_address].lastSentAt;
890   }
891 
892   /**
893    * @dev Time of the last received transaction
894    */
895   function lastReceivedAt(address _address) public view returns (uint256) {
896     return audits[_address].lastReceivedAt;
897   }
898 
899   /**
900    * @dev Time of the last sent transaction
901    */
902   function lastSentAt(address _address) public view returns (uint256) {
903     return audits[_address].lastSentAt;
904   }
905 
906   /**
907    * @dev Count of transactions
908    */
909   function transactionCount(address _address) public view returns (uint256) {
910     return audits[_address].receivedCount + audits[_address].sentCount;
911   }
912 
913   /**
914    * @dev Count of received transactions
915    */
916   function receivedCount(address _address) public view returns (uint256) {
917     return audits[_address].receivedCount;
918   }
919 
920   /**
921    * @dev Count of sent transactions
922    */
923   function sentCount(address _address) public view returns (uint256) {
924     return audits[_address].sentCount;
925   }
926 
927   /**
928    * @dev All time received
929    */
930   function totalReceivedAmount(address _address)
931     public view returns (uint256)
932   {
933     return audits[_address].totalReceivedAmount;
934   }
935 
936   /**
937    * @dev All time sent
938    */
939   function totalSentAmount(address _address) public view returns (uint256) {
940     return audits[_address].totalSentAmount;
941   }
942 
943   /**
944    * @dev Overriden transfer function
945    */
946   function transfer(address _to, uint256 _value) public returns (bool) {
947     if (!super.transfer(_to, _value)) {
948       return false;
949     }
950     updateAudit(msg.sender, _to, _value);
951     return true;
952   }
953 
954   /**
955    * @dev Overriden transferFrom function
956    */
957   function transferFrom(address _from, address _to, uint256 _value)
958     public returns (bool)
959   {
960     if (!super.transferFrom(_from, _to, _value)) {
961       return false;
962     }
963 
964     updateAudit(_from, _to, _value);
965     return true;
966   }
967 
968  /**
969    * @dev currentTime()
970    */
971   function currentTime() internal view returns (uint256) {
972     // solium-disable-next-line security/no-block-members
973     return now;
974   }
975 
976   /**
977    * @dev Update audit data
978    */
979   function updateAudit(address _sender, address _receiver, uint256 _value)
980     private returns (uint256)
981   {
982     Audit storage senderAudit = audits[_sender];
983     senderAudit.lastSentAt = currentTime();
984     senderAudit.sentCount++;
985     senderAudit.totalSentAmount += _value;
986     if (senderAudit.createdAt == 0) {
987       senderAudit.createdAt = currentTime();
988     }
989 
990     Audit storage receiverAudit = audits[_receiver];
991     receiverAudit.lastReceivedAt = currentTime();
992     receiverAudit.receivedCount++;
993     receiverAudit.totalReceivedAmount += _value;
994     if (receiverAudit.createdAt == 0) {
995       receiverAudit.createdAt = currentTime();
996     }
997   }
998 }
999 
1000 // File: contracts/token/component/ProvableOwnershipToken.sol
1001 
1002 /**
1003  * @title ProvableOwnershipToken
1004  * @dev ProvableOwnershipToken is a StandardToken
1005  * with ability to record a proof of ownership
1006  *
1007  * When desired a proof of ownership can be generated.
1008  * The proof is stored within the contract.
1009  * A proofId is then returned.
1010  * The proof can later be used to retrieve the amount needed.
1011  *
1012  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1013  *
1014  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1015  * @notice Please refer to the top of this file for the license.
1016  **/
1017 contract ProvableOwnershipToken is IProvableOwnership, AuditableToken, Ownable {
1018   struct Proof {
1019     uint256 amount;
1020     uint256 dateFrom;
1021     uint256 dateTo;
1022   }
1023   mapping(address => mapping(uint256 => Proof)) internal proofs;
1024   mapping(address => uint256) internal proofLengths;
1025 
1026   /**
1027    * @dev number of proof stored in the contract
1028    */
1029   function proofLength(address _holder) public view returns (uint256) {
1030     return proofLengths[_holder];
1031   }
1032 
1033   /**
1034    * @dev amount contains for the proofId reccord
1035    */
1036   function proofAmount(address _holder, uint256 _proofId)
1037     public view returns (uint256)
1038   {
1039     return proofs[_holder][_proofId].amount;
1040   }
1041 
1042   /**
1043    * @dev date from which the proof is valid
1044    */
1045   function proofDateFrom(address _holder, uint256 _proofId)
1046     public view returns (uint256)
1047   {
1048     return proofs[_holder][_proofId].dateFrom;
1049   }
1050 
1051   /**
1052    * @dev date until the proof is valid
1053    */
1054   function proofDateTo(address _holder, uint256 _proofId)
1055     public view returns (uint256)
1056   {
1057     return proofs[_holder][_proofId].dateTo;
1058   }
1059 
1060   /**
1061    * @dev called to challenge a proof at a point in the past
1062    * Return the amount tokens owned by the proof owner at that time
1063    */
1064   function checkProof(address _holder, uint256 _proofId, uint256 _at)
1065     public view returns (uint256)
1066   {
1067     if (_proofId < proofLengths[_holder]) {
1068       Proof storage proof = proofs[_holder][_proofId];
1069 
1070       if (proof.dateFrom <= _at && _at <= proof.dateTo) {
1071         return proof.amount;
1072       }
1073     }
1074     return 0;
1075   }
1076 
1077   /**
1078    * @dev called to create a proof of token ownership
1079    */
1080   function createProof(address _holder) public {
1081     createProofInternal(
1082       _holder,
1083       balanceOf(_holder),
1084       lastTransactionAt(_holder)
1085     );
1086   }
1087 
1088   /**
1089    * @dev transfer function with also create a proof of ownership to any of the participants
1090    * @param _proofSender if true a proof will be created for the sender
1091    * @param _proofReceiver if true a proof will be created for the receiver
1092    */
1093   function transferWithProofs(
1094     address _to,
1095     uint256 _value,
1096     bool _proofSender,
1097     bool _proofReceiver
1098   ) public returns (bool)
1099   {
1100     uint256 balanceBeforeFrom = balanceOf(msg.sender);
1101     uint256 beforeFrom = lastTransactionAt(msg.sender);
1102     uint256 balanceBeforeTo = balanceOf(_to);
1103     uint256 beforeTo = lastTransactionAt(_to);
1104 
1105     if (!super.transfer(_to, _value)) {
1106       return false;
1107     }
1108 
1109     transferPostProcessing(
1110       msg.sender,
1111       balanceBeforeFrom,
1112       beforeFrom,
1113       _proofSender
1114     );
1115     transferPostProcessing(
1116       _to,
1117       balanceBeforeTo,
1118       beforeTo,
1119       _proofReceiver
1120     );
1121     return true;
1122   }
1123 
1124   /**
1125    * @dev transfer function with also create a proof of ownership to any of the participants
1126    * @param _proofSender if true a proof will be created for the sender
1127    * @param _proofReceiver if true a proof will be created for the receiver
1128    */
1129   function transferFromWithProofs(
1130     address _from,
1131     address _to, 
1132     uint256 _value,
1133     bool _proofSender, bool _proofReceiver)
1134     public returns (bool)
1135   {
1136     uint256 balanceBeforeFrom = balanceOf(_from);
1137     uint256 beforeFrom = lastTransactionAt(_from);
1138     uint256 balanceBeforeTo = balanceOf(_to);
1139     uint256 beforeTo = lastTransactionAt(_to);
1140 
1141     if (!super.transferFrom(_from, _to, _value)) {
1142       return false;
1143     }
1144 
1145     transferPostProcessing(
1146       _from,
1147       balanceBeforeFrom,
1148       beforeFrom,
1149       _proofSender
1150     );
1151     transferPostProcessing(
1152       _to,
1153       balanceBeforeTo,
1154       beforeTo,
1155       _proofReceiver
1156     );
1157     return true;
1158   }
1159 
1160   /**
1161    * @dev can be used to force create a proof (with a fake amount potentially !)
1162    * Only usable by child contract internaly
1163    */
1164   function createProofInternal(
1165     address _holder, uint256 _amount, uint256 _from) internal
1166   {
1167     uint proofId = proofLengths[_holder];
1168     // solium-disable-next-line security/no-block-members
1169     proofs[_holder][proofId] = Proof(_amount, _from, currentTime());
1170     proofLengths[_holder] = proofId+1;
1171     emit ProofOfOwnership(_holder, proofId);
1172   }
1173 
1174   /**
1175    * @dev private function updating contract state after a transfer operation
1176    */
1177   function transferPostProcessing(
1178     address _holder,
1179     uint256 _balanceBefore,
1180     uint256 _before,
1181     bool _proof) private
1182   {
1183     if (_proof) {
1184       createProofInternal(_holder, _balanceBefore, _before);
1185     }
1186   }
1187 
1188   event ProofOfOwnership(address indexed holder, uint256 proofId);
1189 }
1190 
1191 // File: contracts/interface/IClaimable.sol
1192 
1193 /**
1194  * @title IClaimable
1195  * @dev IClaimable interface
1196  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1197  *
1198  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1199  * @notice Please refer to the top of this file for the license.
1200  **/
1201 interface IClaimable {
1202   function hasClaimsSince(address _address, uint256 at)
1203     external view returns (bool);
1204 }
1205 
1206 // File: contracts/interface/IWithClaims.sol
1207 
1208 /**
1209  * @title IWithClaims
1210  * @dev IWithClaims interface
1211  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1212  *
1213  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1214  * @notice Please refer to the top of this file for the license.
1215  **/
1216 contract IWithClaims {
1217   function claimableLength() public view returns (uint256);
1218   function claimable(uint256 _claimableId) public view returns (IClaimable);
1219   function hasClaims(address _holder) public view returns (bool);
1220   function defineClaimables(IClaimable[] _claimables) public;
1221 
1222   event ClaimablesDefined(uint256 count);
1223 }
1224 
1225 // File: contracts/token/component/TokenWithClaims.sol
1226 
1227 /**
1228  * @title TokenWithClaims
1229  * @dev TokenWithClaims contract
1230  * TokenWithClaims is a token that will create a
1231  * proofOfOwnership during transfers if a claim can be made.
1232  * Holder may ask for the claim later using the proofOfOwnership
1233  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1234  *
1235  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1236  * @notice Please refer to the top of this file for the license.
1237  *
1238  * Error messages
1239  * E01: Claimable address must be defined
1240  * E02: Claimables parameter must not be empty
1241  * E03: Claimable does not exist
1242 **/
1243 contract TokenWithClaims is IWithClaims, ProvableOwnershipToken {
1244 
1245   IClaimable[] claimables;
1246 
1247   /**
1248    * @dev Constructor
1249    */
1250   constructor(IClaimable[] _claimables) public {
1251     claimables = _claimables;
1252   }
1253 
1254   /**
1255    * @dev Returns the number of claimables
1256    */
1257   function claimableLength() public view returns (uint256) {
1258     return claimables.length;
1259   }
1260 
1261   /**
1262    * @dev Returns the Claimable associated to the specified claimableId
1263    */
1264   function claimable(uint256 _claimableId) public view returns (IClaimable) {
1265     return claimables[_claimableId];
1266   }
1267 
1268   /**
1269    * @dev Returns true if there are any claims associated to this token
1270    * to be made at this time for the _holder
1271    */
1272   function hasClaims(address _holder) public view returns (bool) {
1273     uint256 lastTransaction = lastTransactionAt(_holder);
1274     for (uint256 i = 0; i < claimables.length; i++) {
1275       if (claimables[i].hasClaimsSince(_holder, lastTransaction)) {
1276         return true;
1277       }
1278     }
1279     return false;
1280   }
1281 
1282   /**
1283    * @dev Override the transfer function with transferWithProofs
1284    * A proof of ownership will be made if any claims can be made by the participants
1285    */
1286   function transfer(address _to, uint256 _value) public returns (bool) {
1287     bool proofFrom = hasClaims(msg.sender);
1288     bool proofTo = hasClaims(_to);
1289 
1290     return super.transferWithProofs(
1291       _to,
1292       _value,
1293       proofFrom,
1294       proofTo
1295     );
1296   }
1297 
1298   /**
1299    * @dev Override the transfer function with transferWithProofs
1300    * A proof of ownership will be made if any claims can be made by the participants
1301    */
1302   function transferFrom(address _from, address _to, uint256 _value)
1303     public returns (bool)
1304   {
1305     bool proofFrom = hasClaims(_from);
1306     bool proofTo = hasClaims(_to);
1307 
1308     return super.transferFromWithProofs(
1309       _from,
1310       _to,
1311       _value,
1312       proofFrom,
1313       proofTo
1314     );
1315   }
1316 
1317   /**
1318    * @dev transfer with proofs
1319    */
1320   function transferWithProofs(
1321     address _to,
1322     uint256 _value,
1323     bool _proofFrom,
1324     bool _proofTo
1325   ) public returns (bool)
1326   {
1327     bool proofFrom = _proofFrom || hasClaims(msg.sender);
1328     bool proofTo = _proofTo || hasClaims(_to);
1329 
1330     return super.transferWithProofs(
1331       _to,
1332       _value,
1333       proofFrom,
1334       proofTo
1335     );
1336   }
1337 
1338   /**
1339    * @dev transfer from with proofs
1340    */
1341   function transferFromWithProofs(
1342     address _from,
1343     address _to,
1344     uint256 _value,
1345     bool _proofFrom,
1346     bool _proofTo
1347   ) public returns (bool)
1348   {
1349     bool proofFrom = _proofFrom || hasClaims(_from);
1350     bool proofTo = _proofTo || hasClaims(_to);
1351 
1352     return super.transferFromWithProofs(
1353       _from,
1354       _to,
1355       _value,
1356       proofFrom,
1357       proofTo
1358     );
1359   }
1360 
1361   /**
1362    * @dev define claimables contract to this token
1363    */
1364   function defineClaimables(IClaimable[] _claimables) public onlyOwner {
1365     claimables = _claimables;
1366     emit ClaimablesDefined(claimables.length);
1367   }
1368 }
1369 
1370 // File: contracts/interface/IRule.sol
1371 
1372 /**
1373  * @title IRule
1374  * @dev IRule interface
1375  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1376  *
1377  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1378  * @notice Please refer to the top of this file for the license.
1379  **/
1380 interface IRule {
1381   function isAddressValid(address _address) external view returns (bool);
1382   function isTransferValid(address _from, address _to, uint256 _amount)
1383     external view returns (bool);
1384 }
1385 
1386 // File: contracts/interface/IWithRules.sol
1387 
1388 /**
1389  * @title IWithRules
1390  * @dev IWithRules interface
1391  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1392  *
1393  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1394  * @notice Please refer to the top of this file for the license.
1395  **/
1396 contract IWithRules {
1397   function ruleLength() public view returns (uint256);
1398   function rule(uint256 _ruleId) public view returns (IRule);
1399   function validateAddress(address _address) public view returns (bool);
1400   function validateTransfer(address _from, address _to, uint256 _amount)
1401     public view returns (bool);
1402 
1403   function defineRules(IRule[] _rules) public;
1404 
1405   event RulesDefined(uint256 count);
1406 }
1407 
1408 // File: contracts/rule/WithRules.sol
1409 
1410 /**
1411  * @title WithRules
1412  * @dev WithRules contract allows inheriting contract to use a set of validation rules
1413  * @dev contract owner may add or remove rules
1414  *
1415  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1416  *
1417  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1418  * @notice Please refer to the top of this file for the license.
1419  *
1420  * Error messages
1421  * WR01: The rules rejected this address
1422  * WR02: The rules rejected the transfer
1423  **/
1424 contract WithRules is IWithRules, Ownable {
1425 
1426   IRule[] internal rules;
1427 
1428   /**
1429    * @dev Constructor
1430    */
1431   constructor(IRule[] _rules) public {
1432     rules = _rules;
1433   }
1434 
1435   /**
1436    * @dev Returns the number of rules
1437    */
1438   function ruleLength() public view returns (uint256) {
1439     return rules.length;
1440   }
1441 
1442   /**
1443    * @dev Returns the Rule associated to the specified ruleId
1444    */
1445   function rule(uint256 _ruleId) public view returns (IRule) {
1446     return rules[_ruleId];
1447   }
1448 
1449   /**
1450    * @dev Check if the rules are valid for an address
1451    */
1452   function validateAddress(address _address) public view returns (bool) {
1453     for (uint256 i = 0; i < rules.length; i++) {
1454       if (!rules[i].isAddressValid(_address)) {
1455         return false;
1456       }
1457     }
1458     return true;
1459   }
1460 
1461   /**
1462    * @dev Check if the rules are valid
1463    */
1464   function validateTransfer(address _from, address _to, uint256 _amount)
1465     public view returns (bool)
1466   {
1467     for (uint256 i = 0; i < rules.length; i++) {
1468       if (!rules[i].isTransferValid(_from, _to, _amount)) {
1469         return false;
1470       }
1471     }
1472     return true;
1473   }
1474 
1475   /**
1476    * @dev Modifier to make functions callable
1477    * only when participants follow rules
1478    */
1479   modifier whenAddressRulesAreValid(address _address) {
1480     require(validateAddress(_address), "WR01");
1481     _;
1482   }
1483 
1484   /**
1485    * @dev Modifier to make transfer functions callable
1486    * only when participants follow rules
1487    */
1488   modifier whenTransferRulesAreValid(
1489     address _from,
1490     address _to,
1491     uint256 _amount)
1492   {
1493     require(validateTransfer(_from, _to, _amount), "WR02");
1494     _;
1495   }
1496 
1497   /**
1498    * @dev Define rules to the token
1499    */
1500   function defineRules(IRule[] _rules) public onlyOwner {
1501     rules = _rules;
1502     emit RulesDefined(rules.length);
1503   }
1504 }
1505 
1506 // File: contracts/token/component/TokenWithRules.sol
1507 
1508 /**
1509  * @title TokenWithRules
1510  * @dev TokenWithRules contract
1511  * TokenWithRules is a token that will apply
1512  * rules restricting transferability
1513  *
1514  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1515  *
1516  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1517  * @notice Please refer to the top of this file for the license.
1518  *
1519  **/
1520 contract TokenWithRules is StandardToken, WithRules {
1521 
1522   /**
1523    * @dev Constructor
1524    */
1525   constructor(IRule[] _rules) public WithRules(_rules) { }
1526 
1527   /**
1528    * @dev Overriden transfer function
1529    */
1530   function transfer(address _to, uint256 _value)
1531     public whenTransferRulesAreValid(msg.sender, _to, _value)
1532     returns (bool)
1533   {
1534     return super.transfer(_to, _value);
1535   }
1536 
1537   /**
1538    * @dev Overriden transferFrom function
1539    */
1540   function transferFrom(address _from, address _to, uint256 _value)
1541     public whenTransferRulesAreValid(_from, _to, _value)
1542     whenAddressRulesAreValid(msg.sender)
1543     returns (bool)
1544   {
1545     return super.transferFrom(_from, _to, _value);
1546   }
1547 }
1548 
1549 // File: contracts/token/BridgeToken.sol
1550 
1551 /**
1552  * @title BridgeToken
1553  * @dev BridgeToken contract
1554  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1555  *
1556  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1557  * @notice Please refer to the top of this file for the license.
1558  */
1559 contract BridgeToken is TokenWithRules, TokenWithClaims, SeizableToken {
1560   string public name;
1561   string public symbol;
1562 
1563   /**
1564    * @dev constructor
1565    */
1566   constructor(string _name, string _symbol) 
1567     TokenWithRules(new IRule[](0))
1568     TokenWithClaims(new IClaimable[](0)) public
1569   {
1570     name = _name;
1571     symbol = _symbol;
1572   }
1573 }
1574 
1575 // File: contracts/governance/BoardSig.sol
1576 
1577 /**
1578  * @title BoardSig
1579  * @dev BoardSig contract
1580  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1581  *
1582  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1583  * @notice Please refer to the top of this file for the license.
1584  *
1585  * @notice Swissquote Bank SA solely is entitled to the GNU LGPL.
1586  * @notice Any other party is subject to the copyright mentioned in the software.
1587  *
1588  * Error messages
1589  */
1590 contract BoardSig is MultiSig {
1591   bytes32 public constant TOKENIZE = keccak256("TOKENIZE");
1592 
1593   string public companyName;
1594 
1595   string public country;
1596   string public registeredNumber;
1597 
1598   BridgeToken public token;
1599 
1600   /**
1601    * @dev constructor function
1602    */
1603   constructor(address[] _addresses, uint8 _threshold) public
1604     MultiSig(_addresses, _threshold)
1605   {
1606   }
1607 
1608   /**
1609    * @dev returns hash of hashed "TOKENIZE"+ token address + document hash
1610    */
1611   function tokenizeHash(BridgeToken _token, bytes32 _hash)
1612     public pure returns (bytes32)
1613   {
1614     return keccak256(
1615       abi.encode(TOKENIZE, address(_token), _hash)
1616     );
1617   }
1618 
1619   /**
1620    * @dev tokenize shares
1621    */
1622   function tokenizeShares(
1623     BridgeToken _token,
1624     bytes32 _hash,
1625     bytes32[] _sigR,
1626     bytes32[] _sigS,
1627     uint8[] _sigV) public
1628     thresholdRequired(address(this), 0,
1629       abi.encodePacked(tokenizeHash(_token, _hash)),
1630       0, threshold, _sigR, _sigS, _sigV)
1631   {
1632     updateReplayProtection();
1633     token = _token;
1634 
1635     emit ShareTokenization(_token, _hash);
1636   }
1637 
1638   /**
1639    * @dev add board meeting
1640    */
1641   function addBoardMeeting(
1642     bytes32 _hash,
1643     bytes32[] _sigR,
1644     bytes32[] _sigS,
1645     uint8[] _sigV) public
1646     thresholdRequired(address(this), 0,
1647       abi.encodePacked(_hash),
1648       0, threshold, _sigR, _sigS, _sigV)
1649   {
1650     emit BoardMeetingHash(_hash);
1651   }
1652 
1653   event ShareTokenization(BridgeToken token, bytes32 hash);
1654   event BoardMeetingHash(bytes32 hash);
1655 
1656 }
1657 
1658 // File: contracts/mps/MPSBoardSig.sol
1659 
1660 /**
1661  * @title MPSBoardSig
1662  * @dev MPSBoardSig contract
1663  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1664  *
1665  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1666  * @notice Please refer to the top of this file for the license.
1667  *
1668  * Error messages
1669  */
1670 contract MPSBoardSig is BoardSig {
1671 
1672   string public companyName = "MtPelerin Group SA";
1673   string public country = "Switzerland";
1674   string public registeredNumber = "CHE-188.552.084";
1675 
1676   /**
1677    * @dev constructor function
1678    */
1679   constructor(address[] _addresses, uint8 _threshold) public
1680     BoardSig(_addresses, _threshold)
1681   {
1682   }
1683 }