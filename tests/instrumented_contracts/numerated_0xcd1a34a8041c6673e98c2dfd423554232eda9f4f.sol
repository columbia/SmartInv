1 /**
2  * TokenMinter.sol
3  * MPS Token (Mt Pelerin Share) token minter.
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
24 
25 pragma solidity ^0.4.24;
26 
27 // File: contracts/zeppelin/ownership/Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    */
64   function renounceOwnership() public onlyOwner {
65     emit OwnershipRenounced(owner);
66     owner = address(0);
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address _newOwner) public onlyOwner {
74     _transferOwnership(_newOwner);
75   }
76 
77   /**
78    * @dev Transfers control of the contract to a newOwner.
79    * @param _newOwner The address to transfer ownership to.
80    */
81   function _transferOwnership(address _newOwner) internal {
82     require(_newOwner != address(0));
83     emit OwnershipTransferred(owner, _newOwner);
84     owner = _newOwner;
85   }
86 }
87 
88 // File: contracts/zeppelin/math/SafeMath.sol
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103     if (a == 0) {
104       return 0;
105     }
106 
107     c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     // uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return a / b;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
134     c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 // File: contracts/interface/IMintable.sol
141 
142 /**
143  * @title Mintable interface
144  *
145  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
146  *
147  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
148  * @notice Please refer to the top of this file for the license.
149  */
150 contract IMintable {
151   function mintingFinished() public view returns (bool);
152 
153   function mint(address _to, uint256 _amount) public returns (bool);
154   function finishMinting() public returns (bool);
155  
156   event Mint(address indexed to, uint256 amount);
157   event MintFinished();
158 }
159 
160 // File: contracts/interface/IMintableByLot.sol
161 
162 /**
163  * @title MintableByLot interface
164  *
165  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
166  *
167  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
168  * @notice Please refer to the top of this file for the license.
169  */
170 contract IMintableByLot is IMintable {
171   function minterLotId(address _minter) public view returns (uint256);
172 }
173 
174 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
175 
176 /**
177  * @title ERC20Basic
178  * @dev Simpler version of ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/179
180  */
181 contract ERC20Basic {
182   function totalSupply() public view returns (uint256);
183   function balanceOf(address who) public view returns (uint256);
184   function transfer(address to, uint256 value) public returns (bool);
185   event Transfer(address indexed from, address indexed to, uint256 value);
186 }
187 
188 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
189 
190 /**
191  * @title Basic token
192  * @dev Basic version of StandardToken, with no allowances.
193  */
194 contract BasicToken is ERC20Basic {
195   using SafeMath for uint256;
196 
197   mapping(address => uint256) balances;
198 
199   uint256 totalSupply_;
200 
201   /**
202   * @dev total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return totalSupply_;
206   }
207 
208   /**
209   * @dev transfer token for a specified address
210   * @param _to The address to transfer to.
211   * @param _value The amount to be transferred.
212   */
213   function transfer(address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[msg.sender]);
216 
217     balances[msg.sender] = balances[msg.sender].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     emit Transfer(msg.sender, _to, _value);
220     return true;
221   }
222 
223   /**
224   * @dev Gets the balance of the specified address.
225   * @param _owner The address to query the the balance of.
226   * @return An uint256 representing the amount owned by the passed address.
227   */
228   function balanceOf(address _owner) public view returns (uint256) {
229     return balances[_owner];
230   }
231 
232 }
233 
234 // File: contracts/interface/ISeizable.sol
235 
236 /**
237  * @title ISeizable
238  * @dev ISeizable interface
239  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
240  *
241  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
242  * @notice Please refer to the top of this file for the license.
243  **/
244 contract ISeizable {
245   function seize(address _account, uint256 _value) public;
246   event Seize(address account, uint256 amount);
247 }
248 
249 // File: contracts/Authority.sol
250 
251 /**
252  * @title Authority
253  * @dev The Authority contract has an authority address, and provides basic authorization control
254  * functions, this simplifies the implementation of "user permissions".
255  * Authority means to represent a legal entity that is entitled to specific rights
256  *
257  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
258  *
259  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
260  * @notice Please refer to the top of this file for the license.
261  *
262  * Error messages
263  * AU01: Message sender must be an authority
264  */
265 contract Authority is Ownable {
266 
267   address authority;
268 
269   /**
270    * @dev Throws if called by any account other than the authority.
271    */
272   modifier onlyAuthority {
273     require(msg.sender == authority, "AU01");
274     _;
275   }
276 
277   /**
278    * @dev return the address associated to the authority
279    */
280   function authorityAddress() public view returns (address) {
281     return authority;
282   }
283 
284   /**
285    * @dev rdefines an authority
286    * @param _name the authority name
287    * @param _address the authority address.
288    */
289   function defineAuthority(string _name, address _address) public onlyOwner {
290     emit AuthorityDefined(_name, _address);
291     authority = _address;
292   }
293 
294   event AuthorityDefined(
295     string name,
296     address _address
297   );
298 }
299 
300 // File: contracts/token/component/SeizableToken.sol
301 
302 /**
303  * @title SeizableToken
304  * @dev BasicToken contract which allows owner to seize accounts
305  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
306  *
307  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
308  * @notice Please refer to the top of this file for the license.
309  *
310  * Error messages
311  * ST01: Owner cannot seize itself
312 */
313 contract SeizableToken is BasicToken, Authority, ISeizable {
314   using SafeMath for uint256;
315 
316   // Although very unlikely, the value below may overflow.
317   // This contract and its children should expect it to happened and consider
318   // this value as only the first 256 bits of the complete value.
319   uint256 public allTimeSeized = 0; // overflow may happend
320 
321   /**
322    * @dev called by the owner to seize value from the account
323    */
324   function seize(address _account, uint256 _value)
325     public onlyAuthority
326   {
327     require(_account != owner, "ST01");
328 
329     balances[_account] = balances[_account].sub(_value);
330     balances[authority] = balances[authority].add(_value);
331 
332     allTimeSeized += _value;
333     emit Seize(_account, _value);
334   }
335 }
336 
337 // File: contracts/zeppelin/token/ERC20/ERC20.sol
338 
339 /**
340  * @title ERC20 interface
341  * @dev see https://github.com/ethereum/EIPs/issues/20
342  */
343 contract ERC20 is ERC20Basic {
344   function allowance(address owner, address spender)
345     public view returns (uint256);
346 
347   function transferFrom(address from, address to, uint256 value)
348     public returns (bool);
349 
350   function approve(address spender, uint256 value) public returns (bool);
351   event Approval(
352     address indexed owner,
353     address indexed spender,
354     uint256 value
355   );
356 }
357 
358 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
359 
360 /**
361  * @title Standard ERC20 token
362  *
363  * @dev Implementation of the basic standard token.
364  * @dev https://github.com/ethereum/EIPs/issues/20
365  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
366  */
367 contract StandardToken is ERC20, BasicToken {
368 
369   mapping (address => mapping (address => uint256)) internal allowed;
370 
371 
372   /**
373    * @dev Transfer tokens from one address to another
374    * @param _from address The address which you want to send tokens from
375    * @param _to address The address which you want to transfer to
376    * @param _value uint256 the amount of tokens to be transferred
377    */
378   function transferFrom(
379     address _from,
380     address _to,
381     uint256 _value
382   )
383     public
384     returns (bool)
385   {
386     require(_to != address(0));
387     require(_value <= balances[_from]);
388     require(_value <= allowed[_from][msg.sender]);
389 
390     balances[_from] = balances[_from].sub(_value);
391     balances[_to] = balances[_to].add(_value);
392     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
393     emit Transfer(_from, _to, _value);
394     return true;
395   }
396 
397   /**
398    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
399    *
400    * Beware that changing an allowance with this method brings the risk that someone may use both the old
401    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
402    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
403    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404    * @param _spender The address which will spend the funds.
405    * @param _value The amount of tokens to be spent.
406    */
407   function approve(address _spender, uint256 _value) public returns (bool) {
408     allowed[msg.sender][_spender] = _value;
409     emit Approval(msg.sender, _spender, _value);
410     return true;
411   }
412 
413   /**
414    * @dev Function to check the amount of tokens that an owner allowed to a spender.
415    * @param _owner address The address which owns the funds.
416    * @param _spender address The address which will spend the funds.
417    * @return A uint256 specifying the amount of tokens still available for the spender.
418    */
419   function allowance(
420     address _owner,
421     address _spender
422    )
423     public
424     view
425     returns (uint256)
426   {
427     return allowed[_owner][_spender];
428   }
429 
430   /**
431    * @dev Increase the amount of tokens that an owner allowed to a spender.
432    *
433    * approve should be called when allowed[_spender] == 0. To increment
434    * allowed value is better to use this function to avoid 2 calls (and wait until
435    * the first transaction is mined)
436    * From MonolithDAO Token.sol
437    * @param _spender The address which will spend the funds.
438    * @param _addedValue The amount of tokens to increase the allowance by.
439    */
440   function increaseApproval(
441     address _spender,
442     uint _addedValue
443   )
444     public
445     returns (bool)
446   {
447     allowed[msg.sender][_spender] = (
448       allowed[msg.sender][_spender].add(_addedValue));
449     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
450     return true;
451   }
452 
453   /**
454    * @dev Decrease the amount of tokens that an owner allowed to a spender.
455    *
456    * approve should be called when allowed[_spender] == 0. To decrement
457    * allowed value is better to use this function to avoid 2 calls (and wait until
458    * the first transaction is mined)
459    * From MonolithDAO Token.sol
460    * @param _spender The address which will spend the funds.
461    * @param _subtractedValue The amount of tokens to decrease the allowance by.
462    */
463   function decreaseApproval(
464     address _spender,
465     uint _subtractedValue
466   )
467     public
468     returns (bool)
469   {
470     uint oldValue = allowed[msg.sender][_spender];
471     if (_subtractedValue > oldValue) {
472       allowed[msg.sender][_spender] = 0;
473     } else {
474       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
475     }
476     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
477     return true;
478   }
479 
480 }
481 
482 // File: contracts/interface/IProvableOwnership.sol
483 
484 /**
485  * @title IProvableOwnership
486  * @dev IProvableOwnership interface which describe proof of ownership.
487  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
488  *
489  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
490  * @notice Please refer to the top of this file for the license.
491  **/
492 contract IProvableOwnership {
493   function proofLength(address _holder) public view returns (uint256);
494   function proofAmount(address _holder, uint256 _proofId)
495     public view returns (uint256);
496 
497   function proofDateFrom(address _holder, uint256 _proofId)
498     public view returns (uint256);
499 
500   function proofDateTo(address _holder, uint256 _proofId)
501     public view returns (uint256);
502 
503   function createProof(address _holder) public;
504   function checkProof(address _holder, uint256 _proofId, uint256 _at)
505     public view returns (uint256);
506 
507   function transferWithProofs(
508     address _to,
509     uint256 _value,
510     bool _proofFrom,
511     bool _proofTo
512     ) public returns (bool);
513 
514   function transferFromWithProofs(
515     address _from,
516     address _to,
517     uint256 _value,
518     bool _proofFrom,
519     bool _proofTo
520     ) public returns (bool);
521 
522   event ProofOfOwnership(address indexed holder, uint256 proofId);
523 }
524 
525 // File: contracts/interface/IAuditableToken.sol
526 
527 /**
528  * @title IAuditableToken
529  * @dev IAuditableToken interface describing the audited data
530  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
531  *
532  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
533  * @notice Please refer to the top of this file for the license.
534  **/
535 contract IAuditableToken {
536   function lastTransactionAt(address _address) public view returns (uint256);
537   function lastReceivedAt(address _address) public view returns (uint256);
538   function lastSentAt(address _address) public view returns (uint256);
539   function transactionCount(address _address) public view returns (uint256);
540   function receivedCount(address _address) public view returns (uint256);
541   function sentCount(address _address) public view returns (uint256);
542   function totalReceivedAmount(address _address) public view returns (uint256);
543   function totalSentAmount(address _address) public view returns (uint256);
544 }
545 
546 // File: contracts/token/component/AuditableToken.sol
547 
548 /**
549  * @title AuditableToken
550  * @dev AuditableToken contract
551  * AuditableToken provides transaction data which can be used
552  * in other smart contracts
553  *
554  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
555  *
556  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
557  * @notice Please refer to the top of this file for the license.
558  **/
559 contract AuditableToken is IAuditableToken, StandardToken {
560 
561    // Although very unlikely, the following values below may overflow:
562    //   receivedCount, sentCount, totalReceivedAmount, totalSentAmount
563    // This contract and its children should expect it to happen and consider
564    // these values as only the first 256 bits of the complete value.
565   struct Audit {
566     uint256 createdAt;
567     uint256 lastReceivedAt;
568     uint256 lastSentAt;
569     uint256 receivedCount; // potential overflow
570     uint256 sentCount; // poential overflow
571     uint256 totalReceivedAmount; // potential overflow
572     uint256 totalSentAmount; // potential overflow
573   }
574   mapping(address => Audit) internal audits;
575 
576   /**
577    * @dev Time of the creation of the audit struct
578    */
579   function auditCreatedAt(address _address) public view returns (uint256) {
580     return audits[_address].createdAt;
581   }
582 
583   /**
584    * @dev Time of the last transaction
585    */
586   function lastTransactionAt(address _address) public view returns (uint256) {
587     return ( audits[_address].lastReceivedAt > audits[_address].lastSentAt ) ?
588       audits[_address].lastReceivedAt : audits[_address].lastSentAt;
589   }
590 
591   /**
592    * @dev Time of the last received transaction
593    */
594   function lastReceivedAt(address _address) public view returns (uint256) {
595     return audits[_address].lastReceivedAt;
596   }
597 
598   /**
599    * @dev Time of the last sent transaction
600    */
601   function lastSentAt(address _address) public view returns (uint256) {
602     return audits[_address].lastSentAt;
603   }
604 
605   /**
606    * @dev Count of transactions
607    */
608   function transactionCount(address _address) public view returns (uint256) {
609     return audits[_address].receivedCount + audits[_address].sentCount;
610   }
611 
612   /**
613    * @dev Count of received transactions
614    */
615   function receivedCount(address _address) public view returns (uint256) {
616     return audits[_address].receivedCount;
617   }
618 
619   /**
620    * @dev Count of sent transactions
621    */
622   function sentCount(address _address) public view returns (uint256) {
623     return audits[_address].sentCount;
624   }
625 
626   /**
627    * @dev All time received
628    */
629   function totalReceivedAmount(address _address)
630     public view returns (uint256)
631   {
632     return audits[_address].totalReceivedAmount;
633   }
634 
635   /**
636    * @dev All time sent
637    */
638   function totalSentAmount(address _address) public view returns (uint256) {
639     return audits[_address].totalSentAmount;
640   }
641 
642   /**
643    * @dev Overriden transfer function
644    */
645   function transfer(address _to, uint256 _value) public returns (bool) {
646     if (!super.transfer(_to, _value)) {
647       return false;
648     }
649     updateAudit(msg.sender, _to, _value);
650     return true;
651   }
652 
653   /**
654    * @dev Overriden transferFrom function
655    */
656   function transferFrom(address _from, address _to, uint256 _value)
657     public returns (bool)
658   {
659     if (!super.transferFrom(_from, _to, _value)) {
660       return false;
661     }
662 
663     updateAudit(_from, _to, _value);
664     return true;
665   }
666 
667  /**
668    * @dev currentTime()
669    */
670   function currentTime() internal view returns (uint256) {
671     // solium-disable-next-line security/no-block-members
672     return now;
673   }
674 
675   /**
676    * @dev Update audit data
677    */
678   function updateAudit(address _sender, address _receiver, uint256 _value)
679     private returns (uint256)
680   {
681     Audit storage senderAudit = audits[_sender];
682     senderAudit.lastSentAt = currentTime();
683     senderAudit.sentCount++;
684     senderAudit.totalSentAmount += _value;
685     if (senderAudit.createdAt == 0) {
686       senderAudit.createdAt = currentTime();
687     }
688 
689     Audit storage receiverAudit = audits[_receiver];
690     receiverAudit.lastReceivedAt = currentTime();
691     receiverAudit.receivedCount++;
692     receiverAudit.totalReceivedAmount += _value;
693     if (receiverAudit.createdAt == 0) {
694       receiverAudit.createdAt = currentTime();
695     }
696   }
697 }
698 
699 // File: contracts/token/component/ProvableOwnershipToken.sol
700 
701 /**
702  * @title ProvableOwnershipToken
703  * @dev ProvableOwnershipToken is a StandardToken
704  * with ability to record a proof of ownership
705  *
706  * When desired a proof of ownership can be generated.
707  * The proof is stored within the contract.
708  * A proofId is then returned.
709  * The proof can later be used to retrieve the amount needed.
710  *
711  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
712  *
713  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
714  * @notice Please refer to the top of this file for the license.
715  **/
716 contract ProvableOwnershipToken is IProvableOwnership, AuditableToken, Ownable {
717   struct Proof {
718     uint256 amount;
719     uint256 dateFrom;
720     uint256 dateTo;
721   }
722   mapping(address => mapping(uint256 => Proof)) internal proofs;
723   mapping(address => uint256) internal proofLengths;
724 
725   /**
726    * @dev number of proof stored in the contract
727    */
728   function proofLength(address _holder) public view returns (uint256) {
729     return proofLengths[_holder];
730   }
731 
732   /**
733    * @dev amount contains for the proofId reccord
734    */
735   function proofAmount(address _holder, uint256 _proofId)
736     public view returns (uint256)
737   {
738     return proofs[_holder][_proofId].amount;
739   }
740 
741   /**
742    * @dev date from which the proof is valid
743    */
744   function proofDateFrom(address _holder, uint256 _proofId)
745     public view returns (uint256)
746   {
747     return proofs[_holder][_proofId].dateFrom;
748   }
749 
750   /**
751    * @dev date until the proof is valid
752    */
753   function proofDateTo(address _holder, uint256 _proofId)
754     public view returns (uint256)
755   {
756     return proofs[_holder][_proofId].dateTo;
757   }
758 
759   /**
760    * @dev called to challenge a proof at a point in the past
761    * Return the amount tokens owned by the proof owner at that time
762    */
763   function checkProof(address _holder, uint256 _proofId, uint256 _at)
764     public view returns (uint256)
765   {
766     if (_proofId < proofLengths[_holder]) {
767       Proof storage proof = proofs[_holder][_proofId];
768 
769       if (proof.dateFrom <= _at && _at <= proof.dateTo) {
770         return proof.amount;
771       }
772     }
773     return 0;
774   }
775 
776   /**
777    * @dev called to create a proof of token ownership
778    */
779   function createProof(address _holder) public {
780     createProofInternal(
781       _holder,
782       balanceOf(_holder),
783       lastTransactionAt(_holder)
784     );
785   }
786 
787   /**
788    * @dev transfer function with also create a proof of ownership to any of the participants
789    * @param _proofSender if true a proof will be created for the sender
790    * @param _proofReceiver if true a proof will be created for the receiver
791    */
792   function transferWithProofs(
793     address _to,
794     uint256 _value,
795     bool _proofSender,
796     bool _proofReceiver
797   ) public returns (bool)
798   {
799     uint256 balanceBeforeFrom = balanceOf(msg.sender);
800     uint256 beforeFrom = lastTransactionAt(msg.sender);
801     uint256 balanceBeforeTo = balanceOf(_to);
802     uint256 beforeTo = lastTransactionAt(_to);
803 
804     if (!super.transfer(_to, _value)) {
805       return false;
806     }
807 
808     transferPostProcessing(
809       msg.sender,
810       balanceBeforeFrom,
811       beforeFrom,
812       _proofSender
813     );
814     transferPostProcessing(
815       _to,
816       balanceBeforeTo,
817       beforeTo,
818       _proofReceiver
819     );
820     return true;
821   }
822 
823   /**
824    * @dev transfer function with also create a proof of ownership to any of the participants
825    * @param _proofSender if true a proof will be created for the sender
826    * @param _proofReceiver if true a proof will be created for the receiver
827    */
828   function transferFromWithProofs(
829     address _from,
830     address _to, 
831     uint256 _value,
832     bool _proofSender, bool _proofReceiver)
833     public returns (bool)
834   {
835     uint256 balanceBeforeFrom = balanceOf(_from);
836     uint256 beforeFrom = lastTransactionAt(_from);
837     uint256 balanceBeforeTo = balanceOf(_to);
838     uint256 beforeTo = lastTransactionAt(_to);
839 
840     if (!super.transferFrom(_from, _to, _value)) {
841       return false;
842     }
843 
844     transferPostProcessing(
845       _from,
846       balanceBeforeFrom,
847       beforeFrom,
848       _proofSender
849     );
850     transferPostProcessing(
851       _to,
852       balanceBeforeTo,
853       beforeTo,
854       _proofReceiver
855     );
856     return true;
857   }
858 
859   /**
860    * @dev can be used to force create a proof (with a fake amount potentially !)
861    * Only usable by child contract internaly
862    */
863   function createProofInternal(
864     address _holder, uint256 _amount, uint256 _from) internal
865   {
866     uint proofId = proofLengths[_holder];
867     // solium-disable-next-line security/no-block-members
868     proofs[_holder][proofId] = Proof(_amount, _from, currentTime());
869     proofLengths[_holder] = proofId+1;
870     emit ProofOfOwnership(_holder, proofId);
871   }
872 
873   /**
874    * @dev private function updating contract state after a transfer operation
875    */
876   function transferPostProcessing(
877     address _holder,
878     uint256 _balanceBefore,
879     uint256 _before,
880     bool _proof) private
881   {
882     if (_proof) {
883       createProofInternal(_holder, _balanceBefore, _before);
884     }
885   }
886 
887   event ProofOfOwnership(address indexed holder, uint256 proofId);
888 }
889 
890 // File: contracts/interface/IClaimable.sol
891 
892 /**
893  * @title IClaimable
894  * @dev IClaimable interface
895  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
896  *
897  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
898  * @notice Please refer to the top of this file for the license.
899  **/
900 interface IClaimable {
901   function hasClaimsSince(address _address, uint256 at)
902     external view returns (bool);
903 }
904 
905 // File: contracts/interface/IWithClaims.sol
906 
907 /**
908  * @title IWithClaims
909  * @dev IWithClaims interface
910  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
911  *
912  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
913  * @notice Please refer to the top of this file for the license.
914  **/
915 contract IWithClaims {
916   function claimableLength() public view returns (uint256);
917   function claimable(uint256 _claimableId) public view returns (IClaimable);
918   function hasClaims(address _holder) public view returns (bool);
919   function defineClaimables(IClaimable[] _claimables) public;
920 
921   event ClaimablesDefined(uint256 count);
922 }
923 
924 // File: contracts/token/component/TokenWithClaims.sol
925 
926 /**
927  * @title TokenWithClaims
928  * @dev TokenWithClaims contract
929  * TokenWithClaims is a token that will create a
930  * proofOfOwnership during transfers if a claim can be made.
931  * Holder may ask for the claim later using the proofOfOwnership
932  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
933  *
934  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
935  * @notice Please refer to the top of this file for the license.
936  *
937  * Error messages
938  * E01: Claimable address must be defined
939  * E02: Claimables parameter must not be empty
940  * E03: Claimable does not exist
941 **/
942 contract TokenWithClaims is IWithClaims, ProvableOwnershipToken {
943 
944   IClaimable[] claimables;
945 
946   /**
947    * @dev Constructor
948    */
949   constructor(IClaimable[] _claimables) public {
950     claimables = _claimables;
951   }
952 
953   /**
954    * @dev Returns the number of claimables
955    */
956   function claimableLength() public view returns (uint256) {
957     return claimables.length;
958   }
959 
960   /**
961    * @dev Returns the Claimable associated to the specified claimableId
962    */
963   function claimable(uint256 _claimableId) public view returns (IClaimable) {
964     return claimables[_claimableId];
965   }
966 
967   /**
968    * @dev Returns true if there are any claims associated to this token
969    * to be made at this time for the _holder
970    */
971   function hasClaims(address _holder) public view returns (bool) {
972     uint256 lastTransaction = lastTransactionAt(_holder);
973     for (uint256 i = 0; i < claimables.length; i++) {
974       if (claimables[i].hasClaimsSince(_holder, lastTransaction)) {
975         return true;
976       }
977     }
978     return false;
979   }
980 
981   /**
982    * @dev Override the transfer function with transferWithProofs
983    * A proof of ownership will be made if any claims can be made by the participants
984    */
985   function transfer(address _to, uint256 _value) public returns (bool) {
986     bool proofFrom = hasClaims(msg.sender);
987     bool proofTo = hasClaims(_to);
988 
989     return super.transferWithProofs(
990       _to,
991       _value,
992       proofFrom,
993       proofTo
994     );
995   }
996 
997   /**
998    * @dev Override the transfer function with transferWithProofs
999    * A proof of ownership will be made if any claims can be made by the participants
1000    */
1001   function transferFrom(address _from, address _to, uint256 _value)
1002     public returns (bool)
1003   {
1004     bool proofFrom = hasClaims(_from);
1005     bool proofTo = hasClaims(_to);
1006 
1007     return super.transferFromWithProofs(
1008       _from,
1009       _to,
1010       _value,
1011       proofFrom,
1012       proofTo
1013     );
1014   }
1015 
1016   /**
1017    * @dev transfer with proofs
1018    */
1019   function transferWithProofs(
1020     address _to,
1021     uint256 _value,
1022     bool _proofFrom,
1023     bool _proofTo
1024   ) public returns (bool)
1025   {
1026     bool proofFrom = _proofFrom || hasClaims(msg.sender);
1027     bool proofTo = _proofTo || hasClaims(_to);
1028 
1029     return super.transferWithProofs(
1030       _to,
1031       _value,
1032       proofFrom,
1033       proofTo
1034     );
1035   }
1036 
1037   /**
1038    * @dev transfer from with proofs
1039    */
1040   function transferFromWithProofs(
1041     address _from,
1042     address _to,
1043     uint256 _value,
1044     bool _proofFrom,
1045     bool _proofTo
1046   ) public returns (bool)
1047   {
1048     bool proofFrom = _proofFrom || hasClaims(_from);
1049     bool proofTo = _proofTo || hasClaims(_to);
1050 
1051     return super.transferFromWithProofs(
1052       _from,
1053       _to,
1054       _value,
1055       proofFrom,
1056       proofTo
1057     );
1058   }
1059 
1060   /**
1061    * @dev define claimables contract to this token
1062    */
1063   function defineClaimables(IClaimable[] _claimables) public onlyOwner {
1064     claimables = _claimables;
1065     emit ClaimablesDefined(claimables.length);
1066   }
1067 }
1068 
1069 // File: contracts/interface/IRule.sol
1070 
1071 /**
1072  * @title IRule
1073  * @dev IRule interface
1074  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1075  *
1076  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1077  * @notice Please refer to the top of this file for the license.
1078  **/
1079 interface IRule {
1080   function isAddressValid(address _address) external view returns (bool);
1081   function isTransferValid(address _from, address _to, uint256 _amount)
1082     external view returns (bool);
1083 }
1084 
1085 // File: contracts/interface/IWithRules.sol
1086 
1087 /**
1088  * @title IWithRules
1089  * @dev IWithRules interface
1090  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1091  *
1092  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1093  * @notice Please refer to the top of this file for the license.
1094  **/
1095 contract IWithRules {
1096   function ruleLength() public view returns (uint256);
1097   function rule(uint256 _ruleId) public view returns (IRule);
1098   function validateAddress(address _address) public view returns (bool);
1099   function validateTransfer(address _from, address _to, uint256 _amount)
1100     public view returns (bool);
1101 
1102   function defineRules(IRule[] _rules) public;
1103 
1104   event RulesDefined(uint256 count);
1105 }
1106 
1107 // File: contracts/rule/WithRules.sol
1108 
1109 /**
1110  * @title WithRules
1111  * @dev WithRules contract allows inheriting contract to use a set of validation rules
1112  * @dev contract owner may add or remove rules
1113  *
1114  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1115  *
1116  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1117  * @notice Please refer to the top of this file for the license.
1118  *
1119  * Error messages
1120  * WR01: The rules rejected this address
1121  * WR02: The rules rejected the transfer
1122  **/
1123 contract WithRules is IWithRules, Ownable {
1124 
1125   IRule[] internal rules;
1126 
1127   /**
1128    * @dev Constructor
1129    */
1130   constructor(IRule[] _rules) public {
1131     rules = _rules;
1132   }
1133 
1134   /**
1135    * @dev Returns the number of rules
1136    */
1137   function ruleLength() public view returns (uint256) {
1138     return rules.length;
1139   }
1140 
1141   /**
1142    * @dev Returns the Rule associated to the specified ruleId
1143    */
1144   function rule(uint256 _ruleId) public view returns (IRule) {
1145     return rules[_ruleId];
1146   }
1147 
1148   /**
1149    * @dev Check if the rules are valid for an address
1150    */
1151   function validateAddress(address _address) public view returns (bool) {
1152     for (uint256 i = 0; i < rules.length; i++) {
1153       if (!rules[i].isAddressValid(_address)) {
1154         return false;
1155       }
1156     }
1157     return true;
1158   }
1159 
1160   /**
1161    * @dev Check if the rules are valid
1162    */
1163   function validateTransfer(address _from, address _to, uint256 _amount)
1164     public view returns (bool)
1165   {
1166     for (uint256 i = 0; i < rules.length; i++) {
1167       if (!rules[i].isTransferValid(_from, _to, _amount)) {
1168         return false;
1169       }
1170     }
1171     return true;
1172   }
1173 
1174   /**
1175    * @dev Modifier to make functions callable
1176    * only when participants follow rules
1177    */
1178   modifier whenAddressRulesAreValid(address _address) {
1179     require(validateAddress(_address), "WR01");
1180     _;
1181   }
1182 
1183   /**
1184    * @dev Modifier to make transfer functions callable
1185    * only when participants follow rules
1186    */
1187   modifier whenTransferRulesAreValid(
1188     address _from,
1189     address _to,
1190     uint256 _amount)
1191   {
1192     require(validateTransfer(_from, _to, _amount), "WR02");
1193     _;
1194   }
1195 
1196   /**
1197    * @dev Define rules to the token
1198    */
1199   function defineRules(IRule[] _rules) public onlyOwner {
1200     rules = _rules;
1201     emit RulesDefined(rules.length);
1202   }
1203 }
1204 
1205 // File: contracts/token/component/TokenWithRules.sol
1206 
1207 /**
1208  * @title TokenWithRules
1209  * @dev TokenWithRules contract
1210  * TokenWithRules is a token that will apply
1211  * rules restricting transferability
1212  *
1213  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1214  *
1215  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1216  * @notice Please refer to the top of this file for the license.
1217  *
1218  **/
1219 contract TokenWithRules is StandardToken, WithRules {
1220 
1221   /**
1222    * @dev Constructor
1223    */
1224   constructor(IRule[] _rules) public WithRules(_rules) { }
1225 
1226   /**
1227    * @dev Overriden transfer function
1228    */
1229   function transfer(address _to, uint256 _value)
1230     public whenTransferRulesAreValid(msg.sender, _to, _value)
1231     returns (bool)
1232   {
1233     return super.transfer(_to, _value);
1234   }
1235 
1236   /**
1237    * @dev Overriden transferFrom function
1238    */
1239   function transferFrom(address _from, address _to, uint256 _value)
1240     public whenTransferRulesAreValid(_from, _to, _value)
1241     whenAddressRulesAreValid(msg.sender)
1242     returns (bool)
1243   {
1244     return super.transferFrom(_from, _to, _value);
1245   }
1246 }
1247 
1248 // File: contracts/token/BridgeToken.sol
1249 
1250 /**
1251  * @title BridgeToken
1252  * @dev BridgeToken contract
1253  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1254  *
1255  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1256  * @notice Please refer to the top of this file for the license.
1257  */
1258 contract BridgeToken is TokenWithRules, TokenWithClaims, SeizableToken {
1259   string public name;
1260   string public symbol;
1261 
1262   /**
1263    * @dev constructor
1264    */
1265   constructor(string _name, string _symbol) 
1266     TokenWithRules(new IRule[](0))
1267     TokenWithClaims(new IClaimable[](0)) public
1268   {
1269     name = _name;
1270     symbol = _symbol;
1271   }
1272 }
1273 
1274 // File: contracts/token/component/MintableToken.sol
1275 
1276 /**
1277  * @title MintableToken
1278  * @dev MintableToken contract
1279  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1280  *
1281  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1282  * @notice Please refer to the top of this file for the license.
1283  *
1284  * Error messages
1285  * MT01: Minting is already finished.
1286 */
1287 contract MintableToken is StandardToken, Ownable, IMintable {
1288 
1289   bool public mintingFinished = false;
1290 
1291   function mintingFinished() public view returns (bool) {
1292     return mintingFinished;
1293   }
1294 
1295   modifier canMint() {
1296     require(!mintingFinished, "MT01");
1297     _;
1298   }
1299 
1300   /**
1301    * @dev Function to mint tokens
1302    * @param _to The address that will receive the minted tokens.
1303    * @param _amount The amount of tokens to mint.
1304    * @return A boolean that indicates if the operation was successful.
1305    */
1306   function mint(
1307     address _to,
1308     uint256 _amount
1309   ) public canMint onlyOwner returns (bool)
1310   {
1311     totalSupply_ = totalSupply_.add(_amount);
1312     balances[_to] = balances[_to].add(_amount);
1313     emit Mint(_to, _amount);
1314     emit Transfer(address(0), _to, _amount);
1315     return true;
1316   }
1317 
1318   /**
1319    * @dev Function to stop minting new tokens.
1320    * @return True if the operation was successful.
1321    */
1322   function finishMinting() public canMint onlyOwner returns (bool) {
1323     mintingFinished = true;
1324     emit MintFinished();
1325     return true;
1326   }
1327 
1328   event Mint(address indexed to, uint256 amount);
1329   event MintFinished();
1330 }
1331 
1332 // File: contracts/token/MintableBridgeToken.sol
1333 
1334 /**
1335  * @title MintableBridgeToken
1336  * @dev MintableBridgeToken contract
1337  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1338  *
1339  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1340  * @notice Please refer to the top of this file for the license.
1341  */
1342 contract MintableBridgeToken is BridgeToken, MintableToken {
1343 
1344   string public name;
1345   string public symbol;
1346 
1347   /**
1348    * @dev constructor
1349    */
1350   constructor(string _name, string _symbol)
1351     BridgeToken(_name, _symbol) public
1352   {
1353     name = _name;
1354     symbol = _symbol;
1355   }
1356 }
1357 
1358 // File: contracts/interface/ISaleConfig.sol
1359 
1360 /**
1361  * @title ISaleConfig interface
1362  *
1363  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1364  *
1365  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1366  * @notice Please refer to the top of this file for the license.
1367  */
1368 contract ISaleConfig {
1369 
1370   struct Tokensale {
1371     uint256 lotId;
1372     uint256 tokenPriceCHFCent;
1373   }
1374 
1375   function tokenSupply() public pure returns (uint256);
1376   function tokensaleLotSupplies() public view returns (uint256[]);
1377 
1378   function tokenizedSharePercent() public pure returns (uint256); 
1379   function tokenPriceCHF() public pure returns (uint256);
1380 
1381   function minimalCHFInvestment() public pure returns (uint256);
1382   function maximalCHFInvestment() public pure returns (uint256);
1383 
1384   function tokensalesCount() public view returns (uint256);
1385   function lotId(uint256 _tokensaleId) public view returns (uint256);
1386   function tokenPriceCHFCent(uint256 _tokensaleId)
1387     public view returns (uint256);
1388 }
1389 
1390 // File: contracts/tokensale/TokenMinter.sol
1391 
1392 /**
1393  * @title TokenMinter
1394  * @dev TokenMinter contract
1395  * The contract explicit the minting process of the Bridge Token
1396  *
1397  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
1398  *
1399  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
1400  * @notice Please refer to the top of this file for the license.
1401  *
1402  * Error messages
1403  * TM01: Configuration must be defined
1404  * TM02: Final token owner must be defined
1405  * TM03: There should be at least one lot
1406  * TM04: Must have one vault per lot
1407  * TM05: Each vault must be defined
1408  * TM06: Token must be defined
1409  * TM07: Token has already been defined
1410  * TM08: Minter must be the token owner
1411  * TM09: There should be no token supply
1412  * TM10: Token minting must not be finished
1413  * TM11: Minters must match tokensale configuration
1414  * TM12: Tokensale configuration must match lot definition
1415  * TM13: Minter is not already configured for the lot
1416  * TM14: Token must be defined
1417  * TM15: Amount to mint must be greater than 0
1418  * TM16: Mintable supply must be greater than amount to mint
1419  * TM17: Can only finish minting for active minters
1420  * TM18: No active minters expected for the lot
1421  * TM19: There should be some remaining supply in the lot
1422  * TM20: Minting must be successfull
1423  * TM21: Token minting must not be finished
1424  * TM22: There should be some unfinished lot(s)
1425  * TM23: All minting must be processed
1426  * TM24: Token minting must not be finished
1427  * TM25: Finish minting must be successful
1428  * TM26: Token minting must be finished
1429 */
1430 contract TokenMinter is IMintableByLot, Ownable {
1431   using SafeMath for uint256;
1432 
1433   struct MintableLot {
1434     uint256 mintableSupply;
1435     address vault;
1436     mapping(address => bool) minters;
1437     uint8 activeMinters;
1438   }
1439 
1440   MintableLot[] private mintableLots;
1441   mapping(address => uint256) public minterLotIds;
1442 
1443   uint256 public totalMintableSupply;
1444   address public finalTokenOwner;
1445 
1446   uint8 public activeLots;
1447 
1448   ISaleConfig public config;
1449   MintableBridgeToken public token;
1450 
1451   /**
1452    * @dev constructor
1453    */
1454   constructor(
1455     ISaleConfig _config,
1456     address _finalTokenOwner,
1457     address[] _vaults) public
1458   {
1459     require(address(_config) != 0, "TM01");
1460     require(_finalTokenOwner != 0, "TM02");
1461 
1462     uint256[] memory lots = _config.tokensaleLotSupplies();
1463     require(lots.length > 0, "TM03");
1464     require(_vaults.length == lots.length, "TM04");
1465 
1466     config = _config;
1467     finalTokenOwner = _finalTokenOwner;
1468 
1469     for (uint256 i = 0; i < lots.length; i++) {
1470       require(_vaults[i] != 0, "TM05");
1471       uint256 mintableSupply = lots[i];
1472       mintableLots.push(MintableLot(mintableSupply, _vaults[i], 0));
1473       totalMintableSupply = totalMintableSupply.add(mintableSupply);
1474       activeLots++;
1475       emit LotCreated(i+1, mintableSupply);
1476     }
1477   }
1478 
1479   /**
1480    * @dev minter lotId
1481    */
1482   function minterLotId(address _minter) public view returns (uint256) {
1483     return minterLotIds[_minter];
1484   }
1485 
1486   /**
1487    * @dev lot mintable supply
1488    */
1489   function lotMintableSupply(uint256 _lotId) public view returns (uint256) {
1490     return mintableLots[_lotId].mintableSupply;
1491   }
1492 
1493   /**
1494    * @dev lot vault
1495    */
1496   function lotVault(uint256 _lotId) public view returns (address) {
1497     return mintableLots[_lotId].vault;
1498   }
1499 
1500   /**
1501    * @dev is lot minter
1502    */
1503   function isLotMinter(uint256 _lotId, address _minter)
1504     public view returns (bool)
1505   {
1506     return mintableLots[_lotId].minters[_minter];
1507   }
1508 
1509   /**
1510    * @dev lot active minters
1511    */
1512   function lotActiveMinters(uint256 _lotId) public view returns (uint256) {
1513     return mintableLots[_lotId].activeMinters;
1514   }
1515 
1516   /**
1517    * @dev implement IMintable interface
1518    */
1519   function mintingFinished() public view returns (bool) {
1520     return token.mintingFinished();
1521   }
1522 
1523   /**
1524    * @dev setup token and minters
1525    **/
1526   function setup(MintableBridgeToken _token, address[] _minters)
1527     public onlyOwner
1528   {
1529     require(address(_token) != 0, "TM06");
1530     require(address(token) == 0, "TM07");
1531     // Ensure it has full ownership over the token to ensure
1532     // that only this contract will be allowed to mint
1533     require(_token.owner() == address(this), "TM08");
1534     token = _token;
1535     
1536     // Ensure that the token has not been premint
1537     require(token.totalSupply() == 0, "TM09");
1538     require(!token.mintingFinished(), "TM10");
1539     
1540     require(_minters.length == config.tokensalesCount(), "TM11");
1541     for (uint256 i = 0; i < _minters.length; i++) {
1542       if (_minters[i] != address(0)) {
1543         setupMinter(_minters[i], i);
1544       }
1545     }
1546   }
1547 
1548   /**
1549    * @dev setup minter
1550    */
1551   function setupMinter(address _minter, uint256 _tokensaleId)
1552     public onlyOwner
1553   {
1554     uint256 lotId = config.lotId(_tokensaleId);
1555     require(lotId < mintableLots.length, "TM12");
1556     MintableLot storage lot = mintableLots[lotId];
1557     require(!lot.minters[_minter], "TM13");
1558     lot.minters[_minter] = true;
1559     lot.activeMinters++;
1560     minterLotIds[_minter] = lotId;
1561     emit MinterAdded(lotId, _minter);
1562   }
1563 
1564   /**
1565    * @dev mint the token from the corresponding lot
1566    */
1567   function mint(address _to, uint256 _amount)
1568     public returns (bool)
1569   {
1570     require(address(token) != 0, "TM14");
1571     require(_amount > 0, "TM15");
1572     
1573     uint256 lotId = minterLotIds[msg.sender];
1574     MintableLot storage lot = mintableLots[lotId];
1575 
1576     require(lot.mintableSupply >= _amount, "TM16");
1577 
1578     lot.mintableSupply = lot.mintableSupply.sub(_amount);
1579     totalMintableSupply = totalMintableSupply.sub(_amount);
1580     return token.mint(_to, _amount);
1581   }
1582 
1583   /**
1584    * @dev update this contract minting to finish
1585    */
1586   function finishMinting() public returns (bool) {
1587     return finishMintingInternal(msg.sender);
1588   }
1589 
1590   /**
1591    * @dev update this contract minting to finish
1592    */
1593   function finishMintingRestricted(address _minter)
1594     public onlyOwner returns (bool)
1595   {
1596     return finishMintingInternal(_minter);
1597   }
1598 
1599   /**
1600    * @dev update this contract minting to finish
1601    */
1602   function finishMintingInternal(address _minter)
1603     public returns (bool)
1604   {
1605     uint256 lotId = minterLotIds[_minter];
1606     MintableLot storage lot = mintableLots[lotId];
1607     require(lot.minters[_minter], "TM17");
1608 
1609     lot.minters[_minter] = false;
1610     lot.activeMinters--;
1611 
1612     if (lot.activeMinters == 0 && lot.mintableSupply == 0) {
1613       finishLotMintingPrivate(lotId);
1614     }
1615     return true;
1616   }
1617 
1618   /**
1619    * @dev mint remaining non distributed tokens for a lot
1620    */
1621   function mintRemainingLot(uint256 _lotId)
1622     public returns (bool)
1623   {
1624     MintableLot storage lot = mintableLots[_lotId];
1625     require(lot.activeMinters == 0, "TM18");
1626     require(lot.mintableSupply > 0, "TM19");
1627 
1628     require(token.mint(lot.vault, lot.mintableSupply), "TM20");
1629     totalMintableSupply = totalMintableSupply.sub(lot.mintableSupply);
1630     lot.mintableSupply = 0;
1631  
1632     finishLotMintingPrivate(_lotId);
1633     return true;
1634   }
1635 
1636   /**
1637    * @dev mint remaining non distributed tokens
1638    * If some tokens remain unminted (unsold or rounding approximations)
1639    * they must be minted before the minting can be finished
1640    **/
1641   function mintAllRemaining() public onlyOwner returns (bool) {
1642     require(!token.mintingFinished(), "TM21");
1643     require(activeLots > 0, "TM22");
1644    
1645     if (totalMintableSupply > 0) {
1646       for (uint256 i = 0; i < mintableLots.length; i++) {
1647         MintableLot storage lot = mintableLots[i];
1648         if (lot.mintableSupply > 0) {
1649           mintRemainingLot(i);
1650         }
1651       }
1652     }
1653     return true;
1654   }
1655 
1656   /**
1657    * @dev finish token minting
1658    */
1659   function finishTokenMinting() public onlyOwner returns (bool) {
1660     require(totalMintableSupply == 0, "TM23");
1661     require(!token.mintingFinished(), "TM24");
1662     require(token.finishMinting(), "TM25");
1663     
1664     require(token.mintingFinished(), "TM26");
1665     token.transferOwnership(finalTokenOwner);
1666     emit TokenReleased();
1667   }
1668 
1669   /**
1670    * @dev finish lot minting
1671    */
1672   function finishLotMintingPrivate(uint256 _lotId) private {
1673     activeLots--;
1674     emit LotMinted(_lotId);
1675   }
1676 
1677   event LotCreated(uint256 lotId, uint256 tokenSupply);
1678   event MinterAdded(uint256 lotId, address minter);
1679   event LotMinted(uint256 lotId);
1680   event TokenReleased();
1681 }