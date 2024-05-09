1 /**
2  * MPSToken.sol
3  * MPS Token (Mt Pelerin Share)
4 
5  * More info about MPS : https://github.com/MtPelerin/MtPelerin-share-MPS
6 
7  * The unflattened code is available through this github tag:
8  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
9 
10  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
11 
12  * @notice All matters regarding the intellectual property of this code 
13  * @notice or software are subject to Swiss Law without reference to its 
14  * @notice conflicts of law rules.
15 
16  * @notice License for each contract is available in the respective file
17  * @notice or in the LICENSE.md file.
18  * @notice https://github.com/MtPelerin/
19 
20  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
21  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
22  */
23 
24 pragma solidity ^0.4.24;
25 
26 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 // File: contracts/zeppelin/math/SafeMath.sol
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47 
48   /**
49   * @dev Multiplies two numbers, throws on overflow.
50   */
51   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53     // benefit is lost if 'b' is also tested.
54     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55     if (a == 0) {
56       return 0;
57     }
58 
59     c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     // uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return a / b;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
86     c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
93 
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev transfer token for a specified address
114   * @param _to The address to transfer to.
115   * @param _value The amount to be transferred.
116   */
117   function transfer(address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120 
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 // File: contracts/interface/ISeizable.sol
139 
140 /**
141  * @title ISeizable
142  * @dev ISeizable interface
143  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
144  *
145  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
146  * @notice Please refer to the top of this file for the license.
147  **/
148 contract ISeizable {
149   function seize(address _account, uint256 _value) public;
150   event Seize(address account, uint256 amount);
151 }
152 
153 // File: contracts/zeppelin/ownership/Ownable.sol
154 
155 /**
156  * @title Ownable
157  * @dev The Ownable contract has an owner address, and provides basic authorization control
158  * functions, this simplifies the implementation of "user permissions".
159  */
160 contract Ownable {
161   address public owner;
162 
163 
164   event OwnershipRenounced(address indexed previousOwner);
165   event OwnershipTransferred(
166     address indexed previousOwner,
167     address indexed newOwner
168   );
169 
170 
171   /**
172    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
173    * account.
174    */
175   constructor() public {
176     owner = msg.sender;
177   }
178 
179   /**
180    * @dev Throws if called by any account other than the owner.
181    */
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187   /**
188    * @dev Allows the current owner to relinquish control of the contract.
189    */
190   function renounceOwnership() public onlyOwner {
191     emit OwnershipRenounced(owner);
192     owner = address(0);
193   }
194 
195   /**
196    * @dev Allows the current owner to transfer control of the contract to a newOwner.
197    * @param _newOwner The address to transfer ownership to.
198    */
199   function transferOwnership(address _newOwner) public onlyOwner {
200     _transferOwnership(_newOwner);
201   }
202 
203   /**
204    * @dev Transfers control of the contract to a newOwner.
205    * @param _newOwner The address to transfer ownership to.
206    */
207   function _transferOwnership(address _newOwner) internal {
208     require(_newOwner != address(0));
209     emit OwnershipTransferred(owner, _newOwner);
210     owner = _newOwner;
211   }
212 }
213 
214 // File: contracts/Authority.sol
215 
216 /**
217  * @title Authority
218  * @dev The Authority contract has an authority address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  * Authority means to represent a legal entity that is entitled to specific rights
221  *
222  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
223  *
224  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
225  * @notice Please refer to the top of this file for the license.
226  *
227  * Error messages
228  * AU01: Message sender must be an authority
229  */
230 contract Authority is Ownable {
231 
232   address authority;
233 
234   /**
235    * @dev Throws if called by any account other than the authority.
236    */
237   modifier onlyAuthority {
238     require(msg.sender == authority, "AU01");
239     _;
240   }
241 
242   /**
243    * @dev return the address associated to the authority
244    */
245   function authorityAddress() public view returns (address) {
246     return authority;
247   }
248 
249   /**
250    * @dev rdefines an authority
251    * @param _name the authority name
252    * @param _address the authority address.
253    */
254   function defineAuthority(string _name, address _address) public onlyOwner {
255     emit AuthorityDefined(_name, _address);
256     authority = _address;
257   }
258 
259   event AuthorityDefined(
260     string name,
261     address _address
262   );
263 }
264 
265 // File: contracts/token/component/SeizableToken.sol
266 
267 /**
268  * @title SeizableToken
269  * @dev BasicToken contract which allows owner to seize accounts
270  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
271  *
272  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
273  * @notice Please refer to the top of this file for the license.
274  *
275  * Error messages
276  * ST01: Owner cannot seize itself
277 */
278 contract SeizableToken is BasicToken, Authority, ISeizable {
279   using SafeMath for uint256;
280 
281   // Although very unlikely, the value below may overflow.
282   // This contract and its children should expect it to happened and consider
283   // this value as only the first 256 bits of the complete value.
284   uint256 public allTimeSeized = 0; // overflow may happend
285 
286   /**
287    * @dev called by the owner to seize value from the account
288    */
289   function seize(address _account, uint256 _value)
290     public onlyAuthority
291   {
292     require(_account != owner, "ST01");
293 
294     balances[_account] = balances[_account].sub(_value);
295     balances[authority] = balances[authority].add(_value);
296 
297     allTimeSeized += _value;
298     emit Seize(_account, _value);
299   }
300 }
301 
302 // File: contracts/zeppelin/token/ERC20/ERC20.sol
303 
304 /**
305  * @title ERC20 interface
306  * @dev see https://github.com/ethereum/EIPs/issues/20
307  */
308 contract ERC20 is ERC20Basic {
309   function allowance(address owner, address spender)
310     public view returns (uint256);
311 
312   function transferFrom(address from, address to, uint256 value)
313     public returns (bool);
314 
315   function approve(address spender, uint256 value) public returns (bool);
316   event Approval(
317     address indexed owner,
318     address indexed spender,
319     uint256 value
320   );
321 }
322 
323 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
324 
325 /**
326  * @title Standard ERC20 token
327  *
328  * @dev Implementation of the basic standard token.
329  * @dev https://github.com/ethereum/EIPs/issues/20
330  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
331  */
332 contract StandardToken is ERC20, BasicToken {
333 
334   mapping (address => mapping (address => uint256)) internal allowed;
335 
336 
337   /**
338    * @dev Transfer tokens from one address to another
339    * @param _from address The address which you want to send tokens from
340    * @param _to address The address which you want to transfer to
341    * @param _value uint256 the amount of tokens to be transferred
342    */
343   function transferFrom(
344     address _from,
345     address _to,
346     uint256 _value
347   )
348     public
349     returns (bool)
350   {
351     require(_to != address(0));
352     require(_value <= balances[_from]);
353     require(_value <= allowed[_from][msg.sender]);
354 
355     balances[_from] = balances[_from].sub(_value);
356     balances[_to] = balances[_to].add(_value);
357     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
358     emit Transfer(_from, _to, _value);
359     return true;
360   }
361 
362   /**
363    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
364    *
365    * Beware that changing an allowance with this method brings the risk that someone may use both the old
366    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
367    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
368    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
369    * @param _spender The address which will spend the funds.
370    * @param _value The amount of tokens to be spent.
371    */
372   function approve(address _spender, uint256 _value) public returns (bool) {
373     allowed[msg.sender][_spender] = _value;
374     emit Approval(msg.sender, _spender, _value);
375     return true;
376   }
377 
378   /**
379    * @dev Function to check the amount of tokens that an owner allowed to a spender.
380    * @param _owner address The address which owns the funds.
381    * @param _spender address The address which will spend the funds.
382    * @return A uint256 specifying the amount of tokens still available for the spender.
383    */
384   function allowance(
385     address _owner,
386     address _spender
387    )
388     public
389     view
390     returns (uint256)
391   {
392     return allowed[_owner][_spender];
393   }
394 
395   /**
396    * @dev Increase the amount of tokens that an owner allowed to a spender.
397    *
398    * approve should be called when allowed[_spender] == 0. To increment
399    * allowed value is better to use this function to avoid 2 calls (and wait until
400    * the first transaction is mined)
401    * From MonolithDAO Token.sol
402    * @param _spender The address which will spend the funds.
403    * @param _addedValue The amount of tokens to increase the allowance by.
404    */
405   function increaseApproval(
406     address _spender,
407     uint _addedValue
408   )
409     public
410     returns (bool)
411   {
412     allowed[msg.sender][_spender] = (
413       allowed[msg.sender][_spender].add(_addedValue));
414     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418   /**
419    * @dev Decrease the amount of tokens that an owner allowed to a spender.
420    *
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    */
428   function decreaseApproval(
429     address _spender,
430     uint _subtractedValue
431   )
432     public
433     returns (bool)
434   {
435     uint oldValue = allowed[msg.sender][_spender];
436     if (_subtractedValue > oldValue) {
437       allowed[msg.sender][_spender] = 0;
438     } else {
439       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
440     }
441     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
442     return true;
443   }
444 
445 }
446 
447 // File: contracts/interface/IProvableOwnership.sol
448 
449 /**
450  * @title IProvableOwnership
451  * @dev IProvableOwnership interface which describe proof of ownership.
452  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
453  *
454  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
455  * @notice Please refer to the top of this file for the license.
456  **/
457 contract IProvableOwnership {
458   function proofLength(address _holder) public view returns (uint256);
459   function proofAmount(address _holder, uint256 _proofId)
460     public view returns (uint256);
461 
462   function proofDateFrom(address _holder, uint256 _proofId)
463     public view returns (uint256);
464 
465   function proofDateTo(address _holder, uint256 _proofId)
466     public view returns (uint256);
467 
468   function createProof(address _holder) public;
469   function checkProof(address _holder, uint256 _proofId, uint256 _at)
470     public view returns (uint256);
471 
472   function transferWithProofs(
473     address _to,
474     uint256 _value,
475     bool _proofFrom,
476     bool _proofTo
477     ) public returns (bool);
478 
479   function transferFromWithProofs(
480     address _from,
481     address _to,
482     uint256 _value,
483     bool _proofFrom,
484     bool _proofTo
485     ) public returns (bool);
486 
487   event ProofOfOwnership(address indexed holder, uint256 proofId);
488 }
489 
490 // File: contracts/interface/IAuditableToken.sol
491 
492 /**
493  * @title IAuditableToken
494  * @dev IAuditableToken interface describing the audited data
495  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
496  *
497  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
498  * @notice Please refer to the top of this file for the license.
499  **/
500 contract IAuditableToken {
501   function lastTransactionAt(address _address) public view returns (uint256);
502   function lastReceivedAt(address _address) public view returns (uint256);
503   function lastSentAt(address _address) public view returns (uint256);
504   function transactionCount(address _address) public view returns (uint256);
505   function receivedCount(address _address) public view returns (uint256);
506   function sentCount(address _address) public view returns (uint256);
507   function totalReceivedAmount(address _address) public view returns (uint256);
508   function totalSentAmount(address _address) public view returns (uint256);
509 }
510 
511 // File: contracts/token/component/AuditableToken.sol
512 
513 /**
514  * @title AuditableToken
515  * @dev AuditableToken contract
516  * AuditableToken provides transaction data which can be used
517  * in other smart contracts
518  *
519  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
520  *
521  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
522  * @notice Please refer to the top of this file for the license.
523  **/
524 contract AuditableToken is IAuditableToken, StandardToken {
525 
526    // Although very unlikely, the following values below may overflow:
527    //   receivedCount, sentCount, totalReceivedAmount, totalSentAmount
528    // This contract and its children should expect it to happen and consider
529    // these values as only the first 256 bits of the complete value.
530   struct Audit {
531     uint256 createdAt;
532     uint256 lastReceivedAt;
533     uint256 lastSentAt;
534     uint256 receivedCount; // potential overflow
535     uint256 sentCount; // poential overflow
536     uint256 totalReceivedAmount; // potential overflow
537     uint256 totalSentAmount; // potential overflow
538   }
539   mapping(address => Audit) internal audits;
540 
541   /**
542    * @dev Time of the creation of the audit struct
543    */
544   function auditCreatedAt(address _address) public view returns (uint256) {
545     return audits[_address].createdAt;
546   }
547 
548   /**
549    * @dev Time of the last transaction
550    */
551   function lastTransactionAt(address _address) public view returns (uint256) {
552     return ( audits[_address].lastReceivedAt > audits[_address].lastSentAt ) ?
553       audits[_address].lastReceivedAt : audits[_address].lastSentAt;
554   }
555 
556   /**
557    * @dev Time of the last received transaction
558    */
559   function lastReceivedAt(address _address) public view returns (uint256) {
560     return audits[_address].lastReceivedAt;
561   }
562 
563   /**
564    * @dev Time of the last sent transaction
565    */
566   function lastSentAt(address _address) public view returns (uint256) {
567     return audits[_address].lastSentAt;
568   }
569 
570   /**
571    * @dev Count of transactions
572    */
573   function transactionCount(address _address) public view returns (uint256) {
574     return audits[_address].receivedCount + audits[_address].sentCount;
575   }
576 
577   /**
578    * @dev Count of received transactions
579    */
580   function receivedCount(address _address) public view returns (uint256) {
581     return audits[_address].receivedCount;
582   }
583 
584   /**
585    * @dev Count of sent transactions
586    */
587   function sentCount(address _address) public view returns (uint256) {
588     return audits[_address].sentCount;
589   }
590 
591   /**
592    * @dev All time received
593    */
594   function totalReceivedAmount(address _address)
595     public view returns (uint256)
596   {
597     return audits[_address].totalReceivedAmount;
598   }
599 
600   /**
601    * @dev All time sent
602    */
603   function totalSentAmount(address _address) public view returns (uint256) {
604     return audits[_address].totalSentAmount;
605   }
606 
607   /**
608    * @dev Overriden transfer function
609    */
610   function transfer(address _to, uint256 _value) public returns (bool) {
611     if (!super.transfer(_to, _value)) {
612       return false;
613     }
614     updateAudit(msg.sender, _to, _value);
615     return true;
616   }
617 
618   /**
619    * @dev Overriden transferFrom function
620    */
621   function transferFrom(address _from, address _to, uint256 _value)
622     public returns (bool)
623   {
624     if (!super.transferFrom(_from, _to, _value)) {
625       return false;
626     }
627 
628     updateAudit(_from, _to, _value);
629     return true;
630   }
631 
632  /**
633    * @dev currentTime()
634    */
635   function currentTime() internal view returns (uint256) {
636     // solium-disable-next-line security/no-block-members
637     return now;
638   }
639 
640   /**
641    * @dev Update audit data
642    */
643   function updateAudit(address _sender, address _receiver, uint256 _value)
644     private returns (uint256)
645   {
646     Audit storage senderAudit = audits[_sender];
647     senderAudit.lastSentAt = currentTime();
648     senderAudit.sentCount++;
649     senderAudit.totalSentAmount += _value;
650     if (senderAudit.createdAt == 0) {
651       senderAudit.createdAt = currentTime();
652     }
653 
654     Audit storage receiverAudit = audits[_receiver];
655     receiverAudit.lastReceivedAt = currentTime();
656     receiverAudit.receivedCount++;
657     receiverAudit.totalReceivedAmount += _value;
658     if (receiverAudit.createdAt == 0) {
659       receiverAudit.createdAt = currentTime();
660     }
661   }
662 }
663 
664 // File: contracts/token/component/ProvableOwnershipToken.sol
665 
666 /**
667  * @title ProvableOwnershipToken
668  * @dev ProvableOwnershipToken is a StandardToken
669  * with ability to record a proof of ownership
670  *
671  * When desired a proof of ownership can be generated.
672  * The proof is stored within the contract.
673  * A proofId is then returned.
674  * The proof can later be used to retrieve the amount needed.
675  *
676  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
677  *
678  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
679  * @notice Please refer to the top of this file for the license.
680  **/
681 contract ProvableOwnershipToken is IProvableOwnership, AuditableToken, Ownable {
682   struct Proof {
683     uint256 amount;
684     uint256 dateFrom;
685     uint256 dateTo;
686   }
687   mapping(address => mapping(uint256 => Proof)) internal proofs;
688   mapping(address => uint256) internal proofLengths;
689 
690   /**
691    * @dev number of proof stored in the contract
692    */
693   function proofLength(address _holder) public view returns (uint256) {
694     return proofLengths[_holder];
695   }
696 
697   /**
698    * @dev amount contains for the proofId reccord
699    */
700   function proofAmount(address _holder, uint256 _proofId)
701     public view returns (uint256)
702   {
703     return proofs[_holder][_proofId].amount;
704   }
705 
706   /**
707    * @dev date from which the proof is valid
708    */
709   function proofDateFrom(address _holder, uint256 _proofId)
710     public view returns (uint256)
711   {
712     return proofs[_holder][_proofId].dateFrom;
713   }
714 
715   /**
716    * @dev date until the proof is valid
717    */
718   function proofDateTo(address _holder, uint256 _proofId)
719     public view returns (uint256)
720   {
721     return proofs[_holder][_proofId].dateTo;
722   }
723 
724   /**
725    * @dev called to challenge a proof at a point in the past
726    * Return the amount tokens owned by the proof owner at that time
727    */
728   function checkProof(address _holder, uint256 _proofId, uint256 _at)
729     public view returns (uint256)
730   {
731     if (_proofId < proofLengths[_holder]) {
732       Proof storage proof = proofs[_holder][_proofId];
733 
734       if (proof.dateFrom <= _at && _at <= proof.dateTo) {
735         return proof.amount;
736       }
737     }
738     return 0;
739   }
740 
741   /**
742    * @dev called to create a proof of token ownership
743    */
744   function createProof(address _holder) public {
745     createProofInternal(
746       _holder,
747       balanceOf(_holder),
748       lastTransactionAt(_holder)
749     );
750   }
751 
752   /**
753    * @dev transfer function with also create a proof of ownership to any of the participants
754    * @param _proofSender if true a proof will be created for the sender
755    * @param _proofReceiver if true a proof will be created for the receiver
756    */
757   function transferWithProofs(
758     address _to,
759     uint256 _value,
760     bool _proofSender,
761     bool _proofReceiver
762   ) public returns (bool)
763   {
764     uint256 balanceBeforeFrom = balanceOf(msg.sender);
765     uint256 beforeFrom = lastTransactionAt(msg.sender);
766     uint256 balanceBeforeTo = balanceOf(_to);
767     uint256 beforeTo = lastTransactionAt(_to);
768 
769     if (!super.transfer(_to, _value)) {
770       return false;
771     }
772 
773     transferPostProcessing(
774       msg.sender,
775       balanceBeforeFrom,
776       beforeFrom,
777       _proofSender
778     );
779     transferPostProcessing(
780       _to,
781       balanceBeforeTo,
782       beforeTo,
783       _proofReceiver
784     );
785     return true;
786   }
787 
788   /**
789    * @dev transfer function with also create a proof of ownership to any of the participants
790    * @param _proofSender if true a proof will be created for the sender
791    * @param _proofReceiver if true a proof will be created for the receiver
792    */
793   function transferFromWithProofs(
794     address _from,
795     address _to, 
796     uint256 _value,
797     bool _proofSender, bool _proofReceiver)
798     public returns (bool)
799   {
800     uint256 balanceBeforeFrom = balanceOf(_from);
801     uint256 beforeFrom = lastTransactionAt(_from);
802     uint256 balanceBeforeTo = balanceOf(_to);
803     uint256 beforeTo = lastTransactionAt(_to);
804 
805     if (!super.transferFrom(_from, _to, _value)) {
806       return false;
807     }
808 
809     transferPostProcessing(
810       _from,
811       balanceBeforeFrom,
812       beforeFrom,
813       _proofSender
814     );
815     transferPostProcessing(
816       _to,
817       balanceBeforeTo,
818       beforeTo,
819       _proofReceiver
820     );
821     return true;
822   }
823 
824   /**
825    * @dev can be used to force create a proof (with a fake amount potentially !)
826    * Only usable by child contract internaly
827    */
828   function createProofInternal(
829     address _holder, uint256 _amount, uint256 _from) internal
830   {
831     uint proofId = proofLengths[_holder];
832     // solium-disable-next-line security/no-block-members
833     proofs[_holder][proofId] = Proof(_amount, _from, currentTime());
834     proofLengths[_holder] = proofId+1;
835     emit ProofOfOwnership(_holder, proofId);
836   }
837 
838   /**
839    * @dev private function updating contract state after a transfer operation
840    */
841   function transferPostProcessing(
842     address _holder,
843     uint256 _balanceBefore,
844     uint256 _before,
845     bool _proof) private
846   {
847     if (_proof) {
848       createProofInternal(_holder, _balanceBefore, _before);
849     }
850   }
851 
852   event ProofOfOwnership(address indexed holder, uint256 proofId);
853 }
854 
855 // File: contracts/interface/IClaimable.sol
856 
857 /**
858  * @title IClaimable
859  * @dev IClaimable interface
860  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
861  *
862  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
863  * @notice Please refer to the top of this file for the license.
864  **/
865 interface IClaimable {
866   function hasClaimsSince(address _address, uint256 at)
867     external view returns (bool);
868 }
869 
870 // File: contracts/interface/IWithClaims.sol
871 
872 /**
873  * @title IWithClaims
874  * @dev IWithClaims interface
875  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
876  *
877  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
878  * @notice Please refer to the top of this file for the license.
879  **/
880 contract IWithClaims {
881   function claimableLength() public view returns (uint256);
882   function claimable(uint256 _claimableId) public view returns (IClaimable);
883   function hasClaims(address _holder) public view returns (bool);
884   function defineClaimables(IClaimable[] _claimables) public;
885 
886   event ClaimablesDefined(uint256 count);
887 }
888 
889 // File: contracts/token/component/TokenWithClaims.sol
890 
891 /**
892  * @title TokenWithClaims
893  * @dev TokenWithClaims contract
894  * TokenWithClaims is a token that will create a
895  * proofOfOwnership during transfers if a claim can be made.
896  * Holder may ask for the claim later using the proofOfOwnership
897  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
898  *
899  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
900  * @notice Please refer to the top of this file for the license.
901  *
902  * Error messages
903  * E01: Claimable address must be defined
904  * E02: Claimables parameter must not be empty
905  * E03: Claimable does not exist
906 **/
907 contract TokenWithClaims is IWithClaims, ProvableOwnershipToken {
908 
909   IClaimable[] claimables;
910 
911   /**
912    * @dev Constructor
913    */
914   constructor(IClaimable[] _claimables) public {
915     claimables = _claimables;
916   }
917 
918   /**
919    * @dev Returns the number of claimables
920    */
921   function claimableLength() public view returns (uint256) {
922     return claimables.length;
923   }
924 
925   /**
926    * @dev Returns the Claimable associated to the specified claimableId
927    */
928   function claimable(uint256 _claimableId) public view returns (IClaimable) {
929     return claimables[_claimableId];
930   }
931 
932   /**
933    * @dev Returns true if there are any claims associated to this token
934    * to be made at this time for the _holder
935    */
936   function hasClaims(address _holder) public view returns (bool) {
937     uint256 lastTransaction = lastTransactionAt(_holder);
938     for (uint256 i = 0; i < claimables.length; i++) {
939       if (claimables[i].hasClaimsSince(_holder, lastTransaction)) {
940         return true;
941       }
942     }
943     return false;
944   }
945 
946   /**
947    * @dev Override the transfer function with transferWithProofs
948    * A proof of ownership will be made if any claims can be made by the participants
949    */
950   function transfer(address _to, uint256 _value) public returns (bool) {
951     bool proofFrom = hasClaims(msg.sender);
952     bool proofTo = hasClaims(_to);
953 
954     return super.transferWithProofs(
955       _to,
956       _value,
957       proofFrom,
958       proofTo
959     );
960   }
961 
962   /**
963    * @dev Override the transfer function with transferWithProofs
964    * A proof of ownership will be made if any claims can be made by the participants
965    */
966   function transferFrom(address _from, address _to, uint256 _value)
967     public returns (bool)
968   {
969     bool proofFrom = hasClaims(_from);
970     bool proofTo = hasClaims(_to);
971 
972     return super.transferFromWithProofs(
973       _from,
974       _to,
975       _value,
976       proofFrom,
977       proofTo
978     );
979   }
980 
981   /**
982    * @dev transfer with proofs
983    */
984   function transferWithProofs(
985     address _to,
986     uint256 _value,
987     bool _proofFrom,
988     bool _proofTo
989   ) public returns (bool)
990   {
991     bool proofFrom = _proofFrom || hasClaims(msg.sender);
992     bool proofTo = _proofTo || hasClaims(_to);
993 
994     return super.transferWithProofs(
995       _to,
996       _value,
997       proofFrom,
998       proofTo
999     );
1000   }
1001 
1002   /**
1003    * @dev transfer from with proofs
1004    */
1005   function transferFromWithProofs(
1006     address _from,
1007     address _to,
1008     uint256 _value,
1009     bool _proofFrom,
1010     bool _proofTo
1011   ) public returns (bool)
1012   {
1013     bool proofFrom = _proofFrom || hasClaims(_from);
1014     bool proofTo = _proofTo || hasClaims(_to);
1015 
1016     return super.transferFromWithProofs(
1017       _from,
1018       _to,
1019       _value,
1020       proofFrom,
1021       proofTo
1022     );
1023   }
1024 
1025   /**
1026    * @dev define claimables contract to this token
1027    */
1028   function defineClaimables(IClaimable[] _claimables) public onlyOwner {
1029     claimables = _claimables;
1030     emit ClaimablesDefined(claimables.length);
1031   }
1032 }
1033 
1034 // File: contracts/interface/IRule.sol
1035 
1036 /**
1037  * @title IRule
1038  * @dev IRule interface
1039  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1040  *
1041  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1042  * @notice Please refer to the top of this file for the license.
1043  **/
1044 interface IRule {
1045   function isAddressValid(address _address) external view returns (bool);
1046   function isTransferValid(address _from, address _to, uint256 _amount)
1047     external view returns (bool);
1048 }
1049 
1050 // File: contracts/interface/IWithRules.sol
1051 
1052 /**
1053  * @title IWithRules
1054  * @dev IWithRules interface
1055  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1056  *
1057  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1058  * @notice Please refer to the top of this file for the license.
1059  **/
1060 contract IWithRules {
1061   function ruleLength() public view returns (uint256);
1062   function rule(uint256 _ruleId) public view returns (IRule);
1063   function validateAddress(address _address) public view returns (bool);
1064   function validateTransfer(address _from, address _to, uint256 _amount)
1065     public view returns (bool);
1066 
1067   function defineRules(IRule[] _rules) public;
1068 
1069   event RulesDefined(uint256 count);
1070 }
1071 
1072 // File: contracts/rule/WithRules.sol
1073 
1074 /**
1075  * @title WithRules
1076  * @dev WithRules contract allows inheriting contract to use a set of validation rules
1077  * @dev contract owner may add or remove rules
1078  *
1079  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1080  *
1081  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1082  * @notice Please refer to the top of this file for the license.
1083  *
1084  * Error messages
1085  * WR01: The rules rejected this address
1086  * WR02: The rules rejected the transfer
1087  **/
1088 contract WithRules is IWithRules, Ownable {
1089 
1090   IRule[] internal rules;
1091 
1092   /**
1093    * @dev Constructor
1094    */
1095   constructor(IRule[] _rules) public {
1096     rules = _rules;
1097   }
1098 
1099   /**
1100    * @dev Returns the number of rules
1101    */
1102   function ruleLength() public view returns (uint256) {
1103     return rules.length;
1104   }
1105 
1106   /**
1107    * @dev Returns the Rule associated to the specified ruleId
1108    */
1109   function rule(uint256 _ruleId) public view returns (IRule) {
1110     return rules[_ruleId];
1111   }
1112 
1113   /**
1114    * @dev Check if the rules are valid for an address
1115    */
1116   function validateAddress(address _address) public view returns (bool) {
1117     for (uint256 i = 0; i < rules.length; i++) {
1118       if (!rules[i].isAddressValid(_address)) {
1119         return false;
1120       }
1121     }
1122     return true;
1123   }
1124 
1125   /**
1126    * @dev Check if the rules are valid
1127    */
1128   function validateTransfer(address _from, address _to, uint256 _amount)
1129     public view returns (bool)
1130   {
1131     for (uint256 i = 0; i < rules.length; i++) {
1132       if (!rules[i].isTransferValid(_from, _to, _amount)) {
1133         return false;
1134       }
1135     }
1136     return true;
1137   }
1138 
1139   /**
1140    * @dev Modifier to make functions callable
1141    * only when participants follow rules
1142    */
1143   modifier whenAddressRulesAreValid(address _address) {
1144     require(validateAddress(_address), "WR01");
1145     _;
1146   }
1147 
1148   /**
1149    * @dev Modifier to make transfer functions callable
1150    * only when participants follow rules
1151    */
1152   modifier whenTransferRulesAreValid(
1153     address _from,
1154     address _to,
1155     uint256 _amount)
1156   {
1157     require(validateTransfer(_from, _to, _amount), "WR02");
1158     _;
1159   }
1160 
1161   /**
1162    * @dev Define rules to the token
1163    */
1164   function defineRules(IRule[] _rules) public onlyOwner {
1165     rules = _rules;
1166     emit RulesDefined(rules.length);
1167   }
1168 }
1169 
1170 // File: contracts/token/component/TokenWithRules.sol
1171 
1172 /**
1173  * @title TokenWithRules
1174  * @dev TokenWithRules contract
1175  * TokenWithRules is a token that will apply
1176  * rules restricting transferability
1177  *
1178  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1179  *
1180  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1181  * @notice Please refer to the top of this file for the license.
1182  *
1183  **/
1184 contract TokenWithRules is StandardToken, WithRules {
1185 
1186   /**
1187    * @dev Constructor
1188    */
1189   constructor(IRule[] _rules) public WithRules(_rules) { }
1190 
1191   /**
1192    * @dev Overriden transfer function
1193    */
1194   function transfer(address _to, uint256 _value)
1195     public whenTransferRulesAreValid(msg.sender, _to, _value)
1196     returns (bool)
1197   {
1198     return super.transfer(_to, _value);
1199   }
1200 
1201   /**
1202    * @dev Overriden transferFrom function
1203    */
1204   function transferFrom(address _from, address _to, uint256 _value)
1205     public whenTransferRulesAreValid(_from, _to, _value)
1206     whenAddressRulesAreValid(msg.sender)
1207     returns (bool)
1208   {
1209     return super.transferFrom(_from, _to, _value);
1210   }
1211 }
1212 
1213 // File: contracts/token/BridgeToken.sol
1214 
1215 /**
1216  * @title BridgeToken
1217  * @dev BridgeToken contract
1218  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1219  *
1220  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1221  * @notice Please refer to the top of this file for the license.
1222  */
1223 contract BridgeToken is TokenWithRules, TokenWithClaims, SeizableToken {
1224   string public name;
1225   string public symbol;
1226 
1227   /**
1228    * @dev constructor
1229    */
1230   constructor(string _name, string _symbol) 
1231     TokenWithRules(new IRule[](0))
1232     TokenWithClaims(new IClaimable[](0)) public
1233   {
1234     name = _name;
1235     symbol = _symbol;
1236   }
1237 }
1238 
1239 // File: contracts/interface/IMintable.sol
1240 
1241 /**
1242  * @title Mintable interface
1243  *
1244  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1245  *
1246  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1247  * @notice Please refer to the top of this file for the license.
1248  */
1249 contract IMintable {
1250   function mintingFinished() public view returns (bool);
1251 
1252   function mint(address _to, uint256 _amount) public returns (bool);
1253   function finishMinting() public returns (bool);
1254  
1255   event Mint(address indexed to, uint256 amount);
1256   event MintFinished();
1257 }
1258 
1259 // File: contracts/token/component/MintableToken.sol
1260 
1261 /**
1262  * @title MintableToken
1263  * @dev MintableToken contract
1264  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1265  *
1266  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1267  * @notice Please refer to the top of this file for the license.
1268  *
1269  * Error messages
1270  * MT01: Minting is already finished.
1271 */
1272 contract MintableToken is StandardToken, Ownable, IMintable {
1273 
1274   bool public mintingFinished = false;
1275 
1276   function mintingFinished() public view returns (bool) {
1277     return mintingFinished;
1278   }
1279 
1280   modifier canMint() {
1281     require(!mintingFinished, "MT01");
1282     _;
1283   }
1284 
1285   /**
1286    * @dev Function to mint tokens
1287    * @param _to The address that will receive the minted tokens.
1288    * @param _amount The amount of tokens to mint.
1289    * @return A boolean that indicates if the operation was successful.
1290    */
1291   function mint(
1292     address _to,
1293     uint256 _amount
1294   ) public canMint onlyOwner returns (bool)
1295   {
1296     totalSupply_ = totalSupply_.add(_amount);
1297     balances[_to] = balances[_to].add(_amount);
1298     emit Mint(_to, _amount);
1299     emit Transfer(address(0), _to, _amount);
1300     return true;
1301   }
1302 
1303   /**
1304    * @dev Function to stop minting new tokens.
1305    * @return True if the operation was successful.
1306    */
1307   function finishMinting() public canMint onlyOwner returns (bool) {
1308     mintingFinished = true;
1309     emit MintFinished();
1310     return true;
1311   }
1312 
1313   event Mint(address indexed to, uint256 amount);
1314   event MintFinished();
1315 }
1316 
1317 // File: contracts/token/MintableBridgeToken.sol
1318 
1319 /**
1320  * @title MintableBridgeToken
1321  * @dev MintableBridgeToken contract
1322  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1323  *
1324  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1325  * @notice Please refer to the top of this file for the license.
1326  */
1327 contract MintableBridgeToken is BridgeToken, MintableToken {
1328 
1329   string public name;
1330   string public symbol;
1331 
1332   /**
1333    * @dev constructor
1334    */
1335   constructor(string _name, string _symbol)
1336     BridgeToken(_name, _symbol) public
1337   {
1338     name = _name;
1339     symbol = _symbol;
1340   }
1341 }
1342 
1343 // File: contracts/token/ShareBridgeToken.sol
1344 
1345 /**
1346  * @title ShareBridgeToken
1347  * @dev ShareBridgeToken contract
1348  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1349  *
1350  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1351  * @notice Please refer to the top of this file for the license.
1352  */
1353 contract ShareBridgeToken is MintableBridgeToken {
1354 
1355   // Shares are non divisible assets
1356   uint256 public decimals = 0;
1357 
1358   /**
1359    * @dev constructor
1360    */
1361   constructor(string _name, string _symbol) public
1362     MintableBridgeToken(_name, _symbol)
1363   {
1364   }
1365 }
1366 
1367 // File: contracts/mps/MPSToken.sol
1368 
1369 /**
1370  * @title MPSToken
1371  * @dev MPSToken contract
1372  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1373  *
1374  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1375  * @notice Please refer to the top of this file for the license.
1376  */
1377 contract MPSToken is ShareBridgeToken {
1378 
1379   /**
1380    * @dev constructor
1381    */
1382   constructor() public
1383     ShareBridgeToken("MtPelerin Shares", "MPS")
1384   {
1385   }
1386 }