1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Eliptic curve signature operations
5  *
6  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
7  *
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  *
11  */
12 
13 library ECRecovery {
14 
15   /**
16    * @dev Recover signer address from a message by using their signature
17    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
18    * @param sig bytes signature, the signature is generated using web3.eth.sign()
19    */
20   function recover(bytes32 hash, bytes sig)
21     internal
22     pure
23     returns (address)
24   {
25     bytes32 r;
26     bytes32 s;
27     uint8 v;
28 
29     // Check the signature length
30     if (sig.length != 65) {
31       return (address(0));
32     }
33 
34     // Divide the signature in r, s and v variables
35     // ecrecover takes the signature parameters, and the only way to get them
36     // currently is to use assembly.
37     // solium-disable-next-line security/no-inline-assembly
38     assembly {
39       r := mload(add(sig, 32))
40       s := mload(add(sig, 64))
41       v := byte(0, mload(add(sig, 96)))
42     }
43 
44     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
45     if (v < 27) {
46       v += 27;
47     }
48 
49     // If the version is correct return the signer address
50     if (v != 27 && v != 28) {
51       return (address(0));
52     } else {
53       // solium-disable-next-line arg-overflow
54       return ecrecover(hash, v, r, s);
55     }
56   }
57 
58   /**
59    * toEthSignedMessageHash
60    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
61    * @dev and hash the result
62    */
63   function toEthSignedMessageHash(bytes32 hash)
64     internal
65     pure
66     returns (bytes32)
67   {
68     // 32 is the length in bytes of hash,
69     // enforced by the type signature above
70     return keccak256(
71       "\x19Ethereum Signed Message:\n32",
72       hash
73     );
74   }
75 }
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic {
83   function totalSupply() public view returns (uint256);
84   function balanceOf(address who) public view returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 /**
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95   address public owner;
96 
97 
98   event OwnershipRenounced(address indexed previousOwner);
99   event OwnershipTransferred(
100     address indexed previousOwner,
101     address indexed newOwner
102   );
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   constructor() public {
110     owner = msg.sender;
111   }
112 
113   /**
114    * @dev Throws if called by any account other than the owner.
115    */
116   modifier onlyOwner() {
117     require(msg.sender == owner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to relinquish control of the contract.
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
149 /**
150  * @title TokenDestructible:
151  * @author Remco Bloemen <remco@2π.com>
152  * @dev Base contract that can be destroyed by owner. All funds in contract including
153  * listed tokens will be sent to the owner.
154  */
155 contract TokenDestructible is Ownable {
156 
157   constructor() public payable { }
158 
159   /**
160    * @notice Terminate contract and refund to owner
161    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
162    refund.
163    * @notice The called token contracts could try to re-enter this contract. Only
164    supply token contracts you trust.
165    */
166   function destroy(address[] tokens) onlyOwner public {
167 
168     // Transfer tokens to owner
169     for (uint256 i = 0; i < tokens.length; i++) {
170       ERC20Basic token = ERC20Basic(tokens[i]);
171       uint256 balance = token.balanceOf(this);
172       token.transfer(owner, balance);
173     }
174 
175     // Transfer Eth to owner and terminate contract
176     selfdestruct(owner);
177   }
178 }
179 
180 /**
181  * @title Pausable
182  * @dev Base contract which allows children to implement an emergency stop mechanism.
183  */
184 contract Pausable is Ownable {
185   event Pause();
186   event Unpause();
187 
188   bool public paused = false;
189 
190 
191   /**
192    * @dev Modifier to make a function callable only when the contract is not paused.
193    */
194   modifier whenNotPaused() {
195     require(!paused);
196     _;
197   }
198 
199   /**
200    * @dev Modifier to make a function callable only when the contract is paused.
201    */
202   modifier whenPaused() {
203     require(paused);
204     _;
205   }
206 
207   /**
208    * @dev called by the owner to pause, triggers stopped state
209    */
210   function pause() onlyOwner whenNotPaused public {
211     paused = true;
212     emit Pause();
213   }
214 
215   /**
216    * @dev called by the owner to unpause, returns to normal state
217    */
218   function unpause() onlyOwner whenPaused public {
219     paused = false;
220     emit Unpause();
221   }
222 }
223 
224 
225 /**
226  * @title SafeMath
227  * @dev Math operations with safety checks that throw on error
228  */
229 library SafeMath {
230 
231   /**
232   * @dev Multiplies two numbers, throws on overflow.
233   */
234   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
235     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
236     // benefit is lost if 'b' is also tested.
237     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
238     if (a == 0) {
239       return 0;
240     }
241 
242     c = a * b;
243     assert(c / a == b);
244     return c;
245   }
246 
247   /**
248   * @dev Integer division of two numbers, truncating the quotient.
249   */
250   function div(uint256 a, uint256 b) internal pure returns (uint256) {
251     // assert(b > 0); // Solidity automatically throws when dividing by 0
252     // uint256 c = a / b;
253     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254     return a / b;
255   }
256 
257   /**
258   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
259   */
260   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   /**
266   * @dev Adds two numbers, throws on overflow.
267   */
268   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
269     c = a + b;
270     assert(c >= a);
271     return c;
272   }
273 }
274 
275 
276 /**
277  * @title Math
278  * @dev Assorted math operations
279  */
280 library Math {
281   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
282     return a >= b ? a : b;
283   }
284 
285   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
286     return a < b ? a : b;
287   }
288 
289   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
290     return a >= b ? a : b;
291   }
292 
293   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
294     return a < b ? a : b;
295   }
296 }
297 
298 
299 /**
300  * @title Basic token
301  * @dev Basic version of StandardToken, with no allowances.
302  */
303 contract BasicToken is ERC20Basic {
304   using SafeMath for uint256;
305 
306   mapping(address => uint256) balances;
307 
308   uint256 totalSupply_;
309 
310   /**
311   * @dev total number of tokens in existence
312   */
313   function totalSupply() public view returns (uint256) {
314     return totalSupply_;
315   }
316 
317   /**
318   * @dev transfer token for a specified address
319   * @param _to The address to transfer to.
320   * @param _value The amount to be transferred.
321   */
322   function transfer(address _to, uint256 _value) public returns (bool) {
323     require(_to != address(0));
324     require(_value <= balances[msg.sender]);
325 
326     balances[msg.sender] = balances[msg.sender].sub(_value);
327     balances[_to] = balances[_to].add(_value);
328     emit Transfer(msg.sender, _to, _value);
329     return true;
330   }
331 
332   /**
333   * @dev Gets the balance of the specified address.
334   * @param _owner The address to query the the balance of.
335   * @return An uint256 representing the amount owned by the passed address.
336   */
337   function balanceOf(address _owner) public view returns (uint256) {
338     return balances[_owner];
339   }
340 
341 }
342 
343 /**
344  * @title ERC20 interface
345  * @dev see https://github.com/ethereum/EIPs/issues/20
346  */
347 contract ERC20 is ERC20Basic {
348   function allowance(address owner, address spender)
349     public view returns (uint256);
350 
351   function transferFrom(address from, address to, uint256 value)
352     public returns (bool);
353 
354   function approve(address spender, uint256 value) public returns (bool);
355   event Approval(
356     address indexed owner,
357     address indexed spender,
358     uint256 value
359   );
360 }
361 
362 /**
363  * @title Standard ERC20 token
364  *
365  * @dev Implementation of the basic standard token.
366  * @dev https://github.com/ethereum/EIPs/issues/20
367  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
368  */
369 contract StandardToken is ERC20, BasicToken {
370 
371   mapping (address => mapping (address => uint256)) internal allowed;
372 
373 
374   /**
375    * @dev Transfer tokens from one address to another
376    * @param _from address The address which you want to send tokens from
377    * @param _to address The address which you want to transfer to
378    * @param _value uint256 the amount of tokens to be transferred
379    */
380   function transferFrom(
381     address _from,
382     address _to,
383     uint256 _value
384   )
385     public
386     returns (bool)
387   {
388     require(_to != address(0));
389     require(_value <= balances[_from]);
390     require(_value <= allowed[_from][msg.sender]);
391 
392     balances[_from] = balances[_from].sub(_value);
393     balances[_to] = balances[_to].add(_value);
394     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
395     emit Transfer(_from, _to, _value);
396     return true;
397   }
398 
399   /**
400    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
401    *
402    * Beware that changing an allowance with this method brings the risk that someone may use both the old
403    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
404    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
405    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
406    * @param _spender The address which will spend the funds.
407    * @param _value The amount of tokens to be spent.
408    */
409   function approve(address _spender, uint256 _value) public returns (bool) {
410     allowed[msg.sender][_spender] = _value;
411     emit Approval(msg.sender, _spender, _value);
412     return true;
413   }
414 
415   /**
416    * @dev Function to check the amount of tokens that an owner allowed to a spender.
417    * @param _owner address The address which owns the funds.
418    * @param _spender address The address which will spend the funds.
419    * @return A uint256 specifying the amount of tokens still available for the spender.
420    */
421   function allowance(
422     address _owner,
423     address _spender
424    )
425     public
426     view
427     returns (uint256)
428   {
429     return allowed[_owner][_spender];
430   }
431 
432   /**
433    * @dev Increase the amount of tokens that an owner allowed to a spender.
434    *
435    * approve should be called when allowed[_spender] == 0. To increment
436    * allowed value is better to use this function to avoid 2 calls (and wait until
437    * the first transaction is mined)
438    * From MonolithDAO Token.sol
439    * @param _spender The address which will spend the funds.
440    * @param _addedValue The amount of tokens to increase the allowance by.
441    */
442   function increaseApproval(
443     address _spender,
444     uint _addedValue
445   )
446     public
447     returns (bool)
448   {
449     allowed[msg.sender][_spender] = (
450       allowed[msg.sender][_spender].add(_addedValue));
451     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
452     return true;
453   }
454 
455   /**
456    * @dev Decrease the amount of tokens that an owner allowed to a spender.
457    *
458    * approve should be called when allowed[_spender] == 0. To decrement
459    * allowed value is better to use this function to avoid 2 calls (and wait until
460    * the first transaction is mined)
461    * From MonolithDAO Token.sol
462    * @param _spender The address which will spend the funds.
463    * @param _subtractedValue The amount of tokens to decrease the allowance by.
464    */
465   function decreaseApproval(
466     address _spender,
467     uint _subtractedValue
468   )
469     public
470     returns (bool)
471   {
472     uint oldValue = allowed[msg.sender][_spender];
473     if (_subtractedValue > oldValue) {
474       allowed[msg.sender][_spender] = 0;
475     } else {
476       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
477     }
478     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
479     return true;
480   }
481 
482 }
483 
484 
485 /**
486  * @title WIBToken
487  * @author Wibson Development Team <developers@wibson.org>
488  * @notice Wibson Oficial Token, this is an ERC20 standard compliant token.
489  * @dev WIBToken token has an initial supply of 9 billion tokens with 9 decimals.
490  */
491 contract WIBToken is StandardToken {
492   string public constant name = "WIBSON"; // solium-disable-line uppercase
493   string public constant symbol = "WIB"; // solium-disable-line uppercase
494   uint8 public constant decimals = 9; // solium-disable-line uppercase
495 
496   // solium-disable-next-line zeppelin/no-arithmetic-operations
497   uint256 public constant INITIAL_SUPPLY = 9000000000 * (10 ** uint256(decimals));
498 
499   constructor() public {
500     totalSupply_ = INITIAL_SUPPLY;
501     balances[msg.sender] = INITIAL_SUPPLY;
502     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
503   }
504 }
505 
506 
507 /**
508  * @title DataOrder
509  * @author Wibson Development Team <developers@wibson.org>
510  * @notice `DataOrder` is the contract between a given buyer and a set of sellers.
511  *         This holds the information about the "deal" between them and how the
512  *         transaction has evolved.
513  */
514 contract DataOrder is Ownable {
515   modifier validAddress(address addr) {
516     require(addr != address(0));
517     require(addr != address(this));
518     _;
519   }
520 
521   enum OrderStatus {
522     OrderCreated,
523     NotaryAdded,
524     TransactionCompleted
525   }
526 
527   enum DataResponseStatus {
528     DataResponseAdded,
529     RefundedToBuyer,
530     TransactionCompleted
531   }
532 
533   // --- Notary Information ---
534   struct NotaryInfo {
535     uint256 responsesPercentage;
536     uint256 notarizationFee;
537     string notarizationTermsOfService;
538     uint32 addedAt;
539   }
540 
541   // --- Seller Information ---
542   struct SellerInfo {
543     address notary;
544     string dataHash;
545     uint32 createdAt;
546     uint32 closedAt;
547     DataResponseStatus status;
548   }
549 
550   address public buyer;
551   string public filters;
552   string public dataRequest;
553   uint256 public price;
554   string public termsAndConditions;
555   string public buyerURL;
556   string public buyerPublicKey;
557   uint32 public createdAt;
558   uint32 public transactionCompletedAt;
559   OrderStatus public orderStatus;
560 
561   mapping(address => SellerInfo) public sellerInfo;
562   mapping(address => NotaryInfo) internal notaryInfo;
563 
564   address[] public sellers;
565   address[] public notaries;
566 
567   /**
568    * @notice Contract's constructor.
569    * @param _buyer Buyer address
570    * @param _filters Target audience of the order.
571    * @param _dataRequest Requested data type (Geolocation, Facebook, etc).
572    * @param _price Price per added Data Response.
573    * @param _termsAndConditions Copy of the terms and conditions for the order.
574    * @param _buyerURL Public URL of the buyer where the data must be sent.
575    * @param _buyerPublicKey Public Key of the buyer, which will be used to encrypt the
576    *        data to be sent.
577    */
578   constructor(
579     address _buyer,
580     string _filters,
581     string _dataRequest,
582     uint256 _price,
583     string _termsAndConditions,
584     string _buyerURL,
585     string _buyerPublicKey
586   ) public validAddress(_buyer) {
587     require(bytes(_buyerURL).length > 0);
588     require(bytes(_buyerPublicKey).length > 0);
589 
590     buyer = _buyer;
591     filters = _filters;
592     dataRequest = _dataRequest;
593     price = _price;
594     termsAndConditions = _termsAndConditions;
595     buyerURL = _buyerURL;
596     buyerPublicKey = _buyerPublicKey;
597     orderStatus = OrderStatus.OrderCreated;
598     createdAt = uint32(block.timestamp);
599     transactionCompletedAt = 0;
600   }
601 
602   /**
603    * @notice Adds a notary to the Data Order.
604    * @param notary Notary's address.
605    * @param responsesPercentage Percentage of DataResponses to audit per DataOrder.
606             Value must be between 0 and 100.
607    * @param notarizationFee Fee to be charged per validation done.
608    * @param notarizationTermsOfService Notary's terms and conditions for the order.
609    * @return true if the Notary was added successfully, reverts otherwise.
610    */
611   function addNotary(
612     address notary,
613     uint256 responsesPercentage,
614     uint256 notarizationFee,
615     string notarizationTermsOfService
616   ) public onlyOwner validAddress(notary) returns (bool) {
617     require(transactionCompletedAt == 0);
618     require(responsesPercentage <= 100);
619     require(!hasNotaryBeenAdded(notary));
620 
621     notaryInfo[notary] = NotaryInfo(
622       responsesPercentage,
623       notarizationFee,
624       notarizationTermsOfService,
625       uint32(block.timestamp)
626     );
627     notaries.push(notary);
628     orderStatus = OrderStatus.NotaryAdded;
629     return true;
630   }
631 
632    /**
633     * @notice Adds a new DataResponse.
634     * @param seller Address of the Seller.
635     * @param notary Notary address that the Seller chooses to use as notary,
636     *        this must be one within the allowed notaries and within the
637     *         DataOrder's notaries.
638     * @param dataHash Hash of the data that must be sent, this is a SHA256.
639     * @return true if the DataResponse was added successfully, reverts otherwise.
640     */
641   function addDataResponse(
642     address seller,
643     address notary,
644     string dataHash
645   ) public onlyOwner validAddress(seller) validAddress(notary) returns (bool) {
646     require(orderStatus == OrderStatus.NotaryAdded);
647     require(transactionCompletedAt == 0);
648     require(!hasSellerBeenAccepted(seller));
649     require(hasNotaryBeenAdded(notary));
650 
651     sellerInfo[seller] = SellerInfo(
652       notary,
653       dataHash,
654       uint32(block.timestamp),
655       0,
656       DataResponseStatus.DataResponseAdded
657     );
658 
659     sellers.push(seller);
660 
661     return true;
662   }
663 
664   /**
665    * @notice Closes a DataResponse.
666    * @dev Once the buyer receives the seller's data and checks that it is valid
667    *      or not, he must signal  DataResponse as completed.
668    * @param seller Seller address.
669    * @param transactionCompleted True, if the seller got paid for his/her data.
670    * @return true if DataResponse was successfully closed, reverts otherwise.
671    */
672   function closeDataResponse(
673     address seller,
674     bool transactionCompleted
675   ) public onlyOwner validAddress(seller) returns (bool) {
676     require(orderStatus != OrderStatus.TransactionCompleted);
677     require(transactionCompletedAt == 0);
678     require(hasSellerBeenAccepted(seller));
679     require(sellerInfo[seller].status == DataResponseStatus.DataResponseAdded);
680 
681     sellerInfo[seller].status = transactionCompleted
682       ? DataResponseStatus.TransactionCompleted
683       : DataResponseStatus.RefundedToBuyer;
684     sellerInfo[seller].closedAt = uint32(block.timestamp);
685     return true;
686   }
687 
688   /**
689    * @notice Closes the Data order.
690    * @dev Once the DataOrder is closed it will no longer accept new DataResponses.
691    * @return true if the DataOrder was successfully closed, reverts otherwise.
692    */
693   function close() public onlyOwner returns (bool) {
694     require(orderStatus != OrderStatus.TransactionCompleted);
695     require(transactionCompletedAt == 0);
696     orderStatus = OrderStatus.TransactionCompleted;
697     transactionCompletedAt = uint32(block.timestamp);
698     return true;
699   }
700 
701   /**
702    * @notice Checks if a DataResponse for a given seller has been accepted.
703    * @param seller Seller address.
704    * @return true if the DataResponse was accepted, false otherwise.
705    */
706   function hasSellerBeenAccepted(
707     address seller
708   ) public view validAddress(seller) returns (bool) {
709     return sellerInfo[seller].createdAt != 0;
710   }
711 
712   /**
713    * @notice Checks if the given notary was added to notarize this DataOrder.
714    * @param notary Notary address to check.
715    * @return true if the Notary was added, false otherwise.
716    */
717   function hasNotaryBeenAdded(
718     address notary
719   ) public view validAddress(notary) returns (bool) {
720     return notaryInfo[notary].addedAt != 0;
721   }
722 
723   /**
724    * @notice Gets the notary information.
725    * @param notary Notary address to get info for.
726    * @return Notary information (address, responsesPercentage, notarizationFee,
727    *         notarizationTermsOfService, addedAt)
728    */
729   function getNotaryInfo(
730     address notary
731   ) public view validAddress(notary) returns (
732     address,
733     uint256,
734     uint256,
735     string,
736     uint32
737   ) {
738     require(hasNotaryBeenAdded(notary));
739     NotaryInfo memory info = notaryInfo[notary];
740     return (
741       notary,
742       info.responsesPercentage,
743       info.notarizationFee,
744       info.notarizationTermsOfService,
745       uint32(info.addedAt)
746     );
747   }
748 
749   /**
750    * @notice Gets the seller information.
751    * @param seller Seller address to get info for.
752    * @return Seller information (address, notary, dataHash, createdAt, closedAt,
753    *         status)
754    */
755   function getSellerInfo(
756     address seller
757   ) public view validAddress(seller) returns (
758     address,
759     address,
760     string,
761     uint32,
762     uint32,
763     bytes32
764   ) {
765     require(hasSellerBeenAccepted(seller));
766     SellerInfo memory info = sellerInfo[seller];
767     return (
768       seller,
769       info.notary,
770       info.dataHash,
771       uint32(info.createdAt),
772       uint32(info.closedAt),
773       getDataResponseStatusAsString(info.status)
774     );
775   }
776 
777   /**
778    * @notice Gets the selected notary for the given seller.
779    * @param seller Seller address.
780    * @return Address of the notary assigned to the given seller.
781    */
782   function getNotaryForSeller(
783     address seller
784   ) public view validAddress(seller) returns (address) {
785     require(hasSellerBeenAccepted(seller));
786     SellerInfo memory info = sellerInfo[seller];
787     return info.notary;
788   }
789 
790   function getDataResponseStatusAsString(
791     DataResponseStatus drs
792   ) internal pure returns (bytes32) {
793     if (drs == DataResponseStatus.DataResponseAdded) {
794       return bytes32("DataResponseAdded");
795     }
796 
797     if (drs == DataResponseStatus.RefundedToBuyer) {
798       return bytes32("RefundedToBuyer");
799     }
800 
801     if (drs == DataResponseStatus.TransactionCompleted) {
802       return bytes32("TransactionCompleted");
803     }
804 
805     throw; // solium-disable-line security/no-throw
806   }
807 
808 }
809 
810 
811 /**
812  * @title MultiMap
813  * @author Wibson Development Team <developers@wibson.org>
814  * @notice An address `MultiMap`.
815  * @dev `MultiMap` is useful when you need to keep track of a set of addresses.
816  */
817 library MultiMap {
818 
819   struct MapStorage {
820     mapping(address => uint) addressToIndex;
821     address[] addresses;
822   }
823 
824   /**
825    * @notice Retrieves a address from the given `MapStorage` using a index Key.
826    * @param self `MapStorage` where the index must be searched.
827    * @param index Index to find.
828    * @return Address of the given Index.
829    */
830   function get(
831     MapStorage storage self,
832     uint index
833   ) public view returns (address) {
834     require(index < self.addresses.length);
835     return self.addresses[index];
836   }
837 
838   /**
839    * @notice Checks if the given address exists in the storage.
840    * @param self `MapStorage` where the key must be searched.
841    * @param _key Address to find.
842    * @return true if `_key` exists in the storage, false otherwise.
843    */
844   function exist(
845     MapStorage storage self,
846     address _key
847   ) public view returns (bool) {
848     if (_key != address(0)) {
849       uint targetIndex = self.addressToIndex[_key];
850       return targetIndex < self.addresses.length && self.addresses[targetIndex] == _key;
851     } else {
852       return false;
853     }
854   }
855 
856   /**
857    * @notice Inserts a new address within the given storage.
858    * @param self `MapStorage` where the key must be inserted.
859    * @param _key Address to insert.
860    * @return true if `_key` was added, reverts otherwise.
861    */
862   function insert(
863     MapStorage storage self,
864     address _key
865   ) public returns (bool) {
866     require(_key != address(0));
867     if (exist(self, _key)) {
868       return true;
869     }
870 
871     self.addressToIndex[_key] = self.addresses.length;
872     self.addresses.push(_key);
873 
874     return true;
875   }
876 
877   /**
878    * @notice Removes the given index from the storage.
879    * @param self MapStorage` where the index lives.
880    * @param index Index to remove.
881    * @return true if address at `index` was removed, false otherwise.
882    */
883   function removeAt(MapStorage storage self, uint index) public returns (bool) {
884     return remove(self, self.addresses[index]);
885   }
886 
887   /**
888    * @notice Removes the given address from the storage.
889    * @param self `MapStorage` where the address lives.
890    * @param _key Address to remove.
891    * @return true if `_key` was removed, false otherwise.
892    */
893   function remove(MapStorage storage self, address _key) public returns (bool) {
894     require(_key != address(0));
895     if (!exist(self, _key)) {
896       return false;
897     }
898 
899     uint currentIndex = self.addressToIndex[_key];
900 
901     uint lastIndex = SafeMath.sub(self.addresses.length, 1);
902     address lastAddress = self.addresses[lastIndex];
903     self.addressToIndex[lastAddress] = currentIndex;
904     self.addresses[currentIndex] = lastAddress;
905 
906     delete self.addresses[lastIndex];
907     delete self.addressToIndex[_key];
908 
909     self.addresses.length--;
910     return true;
911   }
912 
913   /**
914    * @notice Gets the current length of the Map.
915    * @param self `MapStorage` to get the length from.
916    * @return The length of the MultiMap.
917    */
918   function length(MapStorage storage self) public view returns (uint) {
919     return self.addresses.length;
920   }
921 }
922 
923 
924 /**
925  * @title CryptoUtils
926  * @author Wibson Development Team <developers@wibson.org>
927  * @notice Cryptographic utilities used by the Wibson protocol.
928  * @dev In order to get the same hashes using `Web3` upon which the signatures
929  *      are checked, you must use `web3.utils.soliditySha3` in v1.0 (or the
930  *      homonymous function in the `web3-utils` package)
931  *      http://web3js.readthedocs.io/en/1.0/web3-utils.html#utils-soliditysha3
932  */
933 library CryptoUtils {
934 
935   /**
936    * @notice Checks if the signature was created by the signer.
937    * @param hash Hash of the data using the `keccak256` algorithm.
938    * @param signer Signer address.
939    * @param signature Signature over the hash.
940    * @return true if `signer` is the one who signed the `hash`, false otherwise.
941    */
942   function isSignedBy(
943     bytes32 hash,
944     address signer,
945     bytes signature
946   ) private pure returns (bool) {
947     require(signer != address(0));
948     bytes32 prefixedHash = ECRecovery.toEthSignedMessageHash(hash);
949     address recovered = ECRecovery.recover(prefixedHash, signature);
950     return recovered == signer;
951   }
952 
953   /**
954    * @notice Checks if the notary's signature to be added to the DataOrder is valid.
955    * @param order Order address.
956    * @param notary Notary address.
957    * @param responsesPercentage Percentage of DataResponses to audit per DataOrder.
958    * @param notarizationFee Fee to be charged per validation done.
959    * @param notarizationTermsOfService Notary terms and conditions for the order.
960    * @param notarySignature Off-chain Notary signature.
961    * @return true if `notarySignature` is valid, false otherwise.
962    */
963   function isNotaryAdditionValid(
964     address order,
965     address notary,
966     uint256 responsesPercentage,
967     uint256 notarizationFee,
968     string notarizationTermsOfService,
969     bytes notarySignature
970   ) public pure returns (bool) {
971     require(order != address(0));
972     require(notary != address(0));
973     bytes32 hash = keccak256(
974       abi.encodePacked(
975         order,
976         responsesPercentage,
977         notarizationFee,
978         notarizationTermsOfService
979       )
980     );
981 
982     return isSignedBy(hash, notary, notarySignature);
983   }
984 
985   /**
986    * @notice Checks if the parameters passed correspond to the seller's signature used.
987    * @param order Order address.
988    * @param seller Seller address.
989    * @param notary Notary address.
990    * @param dataHash Hash of the data that must be sent, this is a SHA256.
991    * @param signature Signature of DataResponse.
992    * @return true if arguments are signed by the `seller`, false otherwise.
993    */
994   function isDataResponseValid(
995     address order,
996     address seller,
997     address notary,
998     string dataHash,
999     bytes signature
1000   ) public pure returns (bool) {
1001     require(order != address(0));
1002     require(seller != address(0));
1003     require(notary != address(0));
1004 
1005     bytes memory packed = bytes(dataHash).length > 0
1006       ? abi.encodePacked(order, notary, dataHash)
1007       : abi.encodePacked(order, notary);
1008 
1009     bytes32 hash = keccak256(packed);
1010     return isSignedBy(hash, seller, signature);
1011   }
1012 
1013   /**
1014    * @notice Checks if the notary's signature to close the `DataResponse` is valid.
1015    * @param order Order address.
1016    * @param seller Seller address.
1017    * @param notary Notary address.
1018    * @param wasAudited Indicates whether the data was audited or not.
1019    * @param isDataValid Indicates the result of the audit, if happened.
1020    * @param notarySignature Off-chain Notary signature.
1021    * @return true if `notarySignature` is valid, false otherwise.
1022    */
1023   function isNotaryVeredictValid(
1024     address order,
1025     address seller,
1026     address notary,
1027     bool wasAudited,
1028     bool isDataValid,
1029     bytes notarySignature
1030   ) public pure returns (bool) {
1031     require(order != address(0));
1032     require(seller != address(0));
1033     require(notary != address(0));
1034     bytes32 hash = keccak256(
1035       abi.encodePacked(
1036         order,
1037         seller,
1038         wasAudited,
1039         isDataValid
1040       )
1041     );
1042 
1043     return isSignedBy(hash, notary, notarySignature);
1044   }
1045 }
1046 
1047 
1048 
1049 /**
1050  * @title DataExchange
1051  * @author Wibson Development Team <developers@wibson.org>
1052  * @notice `DataExchange` is the core contract of the Wibson Protocol.
1053  *         This allows the creation, management, and tracking of DataOrders.
1054  * @dev This contract also contains some helper methods to access the data
1055  *      needed by the different parties involved in the Protocol.
1056  */
1057 contract DataExchange is TokenDestructible, Pausable {
1058   using SafeMath for uint256;
1059   using MultiMap for MultiMap.MapStorage;
1060 
1061   event NotaryRegistered(address indexed notary);
1062   event NotaryUpdated(address indexed notary);
1063   event NotaryUnregistered(address indexed notary);
1064 
1065   event NewOrder(address indexed orderAddr);
1066   event NotaryAddedToOrder(address indexed orderAddr, address indexed notary);
1067   event DataAdded(address indexed orderAddr, address indexed seller);
1068   event TransactionCompleted(address indexed orderAddr, address indexed seller);
1069   event RefundedToBuyer(address indexed orderAddr, address indexed buyer);
1070   event OrderClosed(address indexed orderAddr);
1071 
1072   struct NotaryInfo {
1073     address addr;
1074     string name;
1075     string notaryUrl;
1076     string publicKey;
1077   }
1078 
1079   MultiMap.MapStorage openOrders;
1080   MultiMap.MapStorage allowedNotaries;
1081 
1082   mapping(address => address[]) public ordersBySeller;
1083   mapping(address => address[]) public ordersByNotary;
1084   mapping(address => address[]) public ordersByBuyer;
1085   mapping(address => NotaryInfo) internal notaryInfo;
1086   // Tracks the orders created by this contract.
1087   mapping(address => bool) private orders;
1088 
1089   // @dev buyerBalance Keeps track of the buyer's balance per order-seller.
1090   // TODO: Is there a better way to do this?
1091   mapping(
1092     address => mapping(address => mapping(address => uint256))
1093   ) public buyerBalance;
1094 
1095   // @dev buyerRemainingBudgetForAudits Keeps track of the buyer's remaining
1096   // budget from the initial one set on the `DataOrder`
1097   mapping(address => mapping(address => uint256)) public buyerRemainingBudgetForAudits;
1098 
1099   modifier validAddress(address addr) {
1100     require(addr != address(0));
1101     require(addr != address(this));
1102     _;
1103   }
1104 
1105   modifier isOrderLegit(address order) {
1106     require(orders[order]);
1107     _;
1108   }
1109 
1110   // @dev token A WIBToken implementation of an ERC20 standard token.
1111   WIBToken token;
1112 
1113   // @dev The minimum for initial budget for audits per `DataOrder`.
1114   uint256 public minimumInitialBudgetForAudits;
1115 
1116   /**
1117    * @notice Contract constructor.
1118    * @param tokenAddress Address of the WIBToken token address.
1119    * @param ownerAddress Address of the DataExchange owner.
1120    */
1121   constructor(
1122     address tokenAddress,
1123     address ownerAddress
1124   ) public validAddress(tokenAddress) validAddress(ownerAddress) {
1125     require(tokenAddress != ownerAddress);
1126 
1127     token = WIBToken(tokenAddress);
1128     minimumInitialBudgetForAudits = 0;
1129     transferOwnership(ownerAddress);
1130   }
1131 
1132   /**
1133    * @notice Registers a new notary or replaces an already existing one.
1134    * @dev At least one notary is needed to enable `DataExchange` operation.
1135    * @param notary Address of a Notary to add.
1136    * @param name Name Of the Notary.
1137    * @param notaryUrl Public URL of the notary where the data must be sent.
1138    * @param publicKey PublicKey used by the Notary.
1139    * @return true if the notary was successfully registered, reverts otherwise.
1140    */
1141   function registerNotary(
1142     address notary,
1143     string name,
1144     string notaryUrl,
1145     string publicKey
1146   ) public onlyOwner whenNotPaused validAddress(notary) returns (bool) {
1147     bool isNew = notaryInfo[notary].addr == address(0);
1148 
1149     require(allowedNotaries.insert(notary));
1150     notaryInfo[notary] = NotaryInfo(
1151       notary,
1152       name,
1153       notaryUrl,
1154       publicKey
1155     );
1156 
1157     if (isNew) {
1158       emit NotaryRegistered(notary);
1159     } else {
1160       emit NotaryUpdated(notary);
1161     }
1162     return true;
1163   }
1164 
1165   /**
1166    * @notice Unregisters an existing notary.
1167    * @param notary Address of a Notary to unregister.
1168    * @return true if the notary was successfully unregistered, reverts otherwise.
1169    */
1170   function unregisterNotary(
1171     address notary
1172   ) public onlyOwner whenNotPaused validAddress(notary) returns (bool) {
1173     require(allowedNotaries.remove(notary));
1174 
1175     emit NotaryUnregistered(notary);
1176     return true;
1177   }
1178 
1179   /**
1180    * @notice Sets the minimum initial budget for audits to be placed by a buyer
1181    * on DataOrder creation.
1182    * @dev The initial budget for audit is used as a preventive method to reduce
1183    *      spam DataOrders in the network.
1184    * @param _minimumInitialBudgetForAudits The new minimum for initial budget for
1185    * audits per DataOrder.
1186    * @return true if the value was successfully set, reverts otherwise.
1187    */
1188   function setMinimumInitialBudgetForAudits(
1189     uint256 _minimumInitialBudgetForAudits
1190   ) public onlyOwner whenNotPaused returns (bool) {
1191     minimumInitialBudgetForAudits = _minimumInitialBudgetForAudits;
1192     return true;
1193   }
1194 
1195   /**
1196    * @notice Creates a new DataOrder.
1197    * @dev The `msg.sender` will become the buyer of the order.
1198    * @param filters Target audience of the order.
1199    * @param dataRequest Requested data type (Geolocation, Facebook, etc).
1200    * @param price Price per added Data Response.
1201    * @param initialBudgetForAudits The initial budget set for future audits.
1202    * @param termsAndConditions Buyer's terms and conditions for the order.
1203    * @param buyerURL Public URL of the buyer where the data must be sent.
1204    * @param publicKey Public Key of the buyer, which will be used to encrypt the
1205    *        data to be sent.
1206    * @return The address of the newly created DataOrder. If the DataOrder could
1207    *         not be created, reverts.
1208    */
1209   function newOrder(
1210     string filters,
1211     string dataRequest,
1212     uint256 price,
1213     uint256 initialBudgetForAudits,
1214     string termsAndConditions,
1215     string buyerURL,
1216     string publicKey
1217   ) public whenNotPaused returns (address) {
1218     require(initialBudgetForAudits >= minimumInitialBudgetForAudits);
1219     require(token.allowance(msg.sender, this) >= initialBudgetForAudits);
1220 
1221     address newOrderAddr = new DataOrder(
1222       msg.sender,
1223       filters,
1224       dataRequest,
1225       price,
1226       termsAndConditions,
1227       buyerURL,
1228       publicKey
1229     );
1230 
1231     token.transferFrom(msg.sender, this, initialBudgetForAudits);
1232     buyerRemainingBudgetForAudits[msg.sender][newOrderAddr] = initialBudgetForAudits;
1233 
1234     ordersByBuyer[msg.sender].push(newOrderAddr);
1235     orders[newOrderAddr] = true;
1236 
1237     emit NewOrder(newOrderAddr);
1238     return newOrderAddr;
1239   }
1240 
1241   /**
1242    * @notice Adds a notary to the Data Order.
1243    * @dev The `msg.sender` must be the buyer.
1244    * @param orderAddr Order Address to accept notarize.
1245    * @param notary Notary address.
1246    * @param responsesPercentage Percentage of `DataResponses` to audit per DataOrder.
1247    *        Value must be between 0 and 100.
1248    * @param notarizationFee Fee to be charged per validation done.
1249    * @param notarizationTermsOfService Notary's terms and conditions for the order.
1250    * @param notarySignature Notary's signature over the other arguments.
1251    * @return true if the Notary was added successfully, reverts otherwise.
1252    */
1253   function addNotaryToOrder(
1254     address orderAddr,
1255     address notary,
1256     uint256 responsesPercentage,
1257     uint256 notarizationFee,
1258     string notarizationTermsOfService,
1259     bytes notarySignature
1260   ) public whenNotPaused isOrderLegit(orderAddr) validAddress(notary) returns (bool) {
1261     DataOrder order = DataOrder(orderAddr);
1262     address buyer = order.buyer();
1263     require(msg.sender == buyer);
1264 
1265     require(!order.hasNotaryBeenAdded(notary));
1266     require(allowedNotaries.exist(notary));
1267 
1268     require(
1269       CryptoUtils.isNotaryAdditionValid(
1270         orderAddr,
1271         notary,
1272         responsesPercentage,
1273         notarizationFee,
1274         notarizationTermsOfService,
1275         notarySignature
1276       )
1277     );
1278 
1279     bool okay = order.addNotary(
1280       notary,
1281       responsesPercentage,
1282       notarizationFee,
1283       notarizationTermsOfService
1284     );
1285 
1286     if (okay) {
1287       openOrders.insert(orderAddr);
1288       ordersByNotary[notary].push(orderAddr);
1289       emit NotaryAddedToOrder(order, notary);
1290     }
1291     return okay;
1292   }
1293 
1294   /**
1295    * @notice Adds a new DataResponse to the given order.
1296    * @dev 1. The `msg.sender` must be the buyer of the order.
1297    *      2. The buyer must allow the DataExchange to withdraw the price of the
1298    *         order.
1299    * @param orderAddr Order address where the DataResponse must be added.
1300    * @param seller Address of the Seller.
1301    * @param notary Notary address that the Seller chose to use as notarizer,
1302    *        this must be one within the allowed notaries and within the
1303    *        DataOrder's notaries.
1304    * @param dataHash Hash of the data that must be sent, this is a SHA256.
1305    * @param signature Signature of DataResponse.
1306    * @return true if the DataResponse was set successfully, reverts otherwise.
1307    */
1308   function addDataResponseToOrder(
1309     address orderAddr,
1310     address seller,
1311     address notary,
1312     string dataHash,
1313     bytes signature
1314   ) public whenNotPaused isOrderLegit(orderAddr) returns (bool) {
1315     DataOrder order = DataOrder(orderAddr);
1316     address buyer = order.buyer();
1317     require(msg.sender == buyer);
1318     allDistinct(
1319       [
1320         orderAddr,
1321         buyer,
1322         seller,
1323         notary,
1324         address(this)
1325       ]
1326     );
1327     require(order.hasNotaryBeenAdded(notary));
1328 
1329     require(
1330       CryptoUtils.isDataResponseValid(
1331         orderAddr,
1332         seller,
1333         notary,
1334         dataHash,
1335         signature
1336       )
1337     );
1338 
1339     bool okay = order.addDataResponse(
1340       seller,
1341       notary,
1342       dataHash
1343     );
1344     require(okay);
1345 
1346     chargeBuyer(order, seller);
1347 
1348     ordersBySeller[seller].push(orderAddr);
1349     emit DataAdded(order, seller);
1350     return true;
1351   }
1352 
1353   /**
1354    * @notice Closes a DataResponse.
1355    * @dev Once the buyer receives the seller's data and checks that it is valid
1356    *      or not, he must close the DataResponse signaling the result.
1357    *        1. This method requires an offline signature from the notary set in
1358    *           the DataResponse, which will indicate the audit result or if
1359    *           the data was not audited at all.
1360    *             - If the notary did not audit the data or it verifies that it was
1361    *               valid, funds will be sent to the Seller.
1362    *             - If the notary signals the data as invalid, funds will be
1363    *               handed back to the Buyer.
1364    *             - Otherwise, funds will be locked at the `DataExchange` contract
1365    *               until the issue is solved.
1366    *        2. This also works as a pause mechanism in case the system is
1367    *           working under abnormal scenarios while allowing the parties to keep
1368    *           exchanging information without losing their funds until the system
1369    *           is back up.
1370    *        3. The `msg.sender` must be the buyer or the notary in case the
1371    *           former does not show up. Only through the notary's signature it is
1372    *           decided who must receive the funds.
1373    * @param orderAddr Order address where the DataResponse belongs to.
1374    * @param seller Seller address.
1375    * @param wasAudited Indicates whether the data was audited or not.
1376    * @param isDataValid Indicates the result of the audit, if happened.
1377    * @param notarySignature Off-chain Notary signature
1378    * @return true if the DataResponse was successfully closed, reverts otherwise.
1379    */
1380   function closeDataResponse(
1381     address orderAddr,
1382     address seller,
1383     bool wasAudited,
1384     bool isDataValid,
1385     bytes notarySignature
1386   ) public whenNotPaused isOrderLegit(orderAddr) returns (bool) {
1387     DataOrder order = DataOrder(orderAddr);
1388     address buyer = order.buyer();
1389     require(order.hasSellerBeenAccepted(seller));
1390 
1391     address notary = order.getNotaryForSeller(seller);
1392     require(msg.sender == buyer || msg.sender == notary);
1393     require(
1394       CryptoUtils.isNotaryVeredictValid(
1395         orderAddr,
1396         seller,
1397         notary,
1398         wasAudited,
1399         isDataValid,
1400         notarySignature
1401       )
1402     );
1403     bool transactionCompleted = !wasAudited || isDataValid;
1404     require(order.closeDataResponse(seller, transactionCompleted));
1405     payPlayers(
1406       order,
1407       buyer,
1408       seller,
1409       notary,
1410       wasAudited,
1411       isDataValid
1412     );
1413 
1414     if (transactionCompleted) {
1415       emit TransactionCompleted(order, seller);
1416     } else {
1417       emit RefundedToBuyer(order, buyer);
1418     }
1419     return true;
1420   }
1421 
1422   /**
1423    * @notice Closes the DataOrder.
1424    * @dev Onces the data is closed it will no longer accept new DataResponses.
1425    *      The `msg.sender` must be the buyer of the order or the owner of the
1426    *      contract in a emergency case.
1427    * @param orderAddr Order address to close.
1428    * @return true if the DataOrder was successfully closed, reverts otherwise.
1429    */
1430   function closeOrder(
1431     address orderAddr
1432   ) public whenNotPaused isOrderLegit(orderAddr) returns (bool) {
1433     require(openOrders.exist(orderAddr));
1434     DataOrder order = DataOrder(orderAddr);
1435     address buyer = order.buyer();
1436     require(msg.sender == buyer || msg.sender == owner);
1437 
1438     bool okay = order.close();
1439     if (okay) {
1440       // remaining budget for audits go back to buyer.
1441       uint256 remainingBudget = buyerRemainingBudgetForAudits[buyer][order];
1442       buyerRemainingBudgetForAudits[buyer][order] = 0;
1443       require(token.transfer(buyer, remainingBudget));
1444 
1445       openOrders.remove(orderAddr);
1446       emit OrderClosed(orderAddr);
1447     }
1448 
1449     return okay;
1450   }
1451 
1452   /**
1453    * @notice Gets all the data orders associated with a notary.
1454    * @param notary Notary address to get orders for.
1455    * @return A list of DataOrder addresses.
1456    */
1457   function getOrdersForNotary(
1458     address notary
1459   ) public view validAddress(notary) returns (address[]) {
1460     return ordersByNotary[notary];
1461   }
1462 
1463   /**
1464    * @notice Gets all the data orders associated with a seller.
1465    * @param seller Seller address to get orders for.
1466    * @return List of DataOrder addresses.
1467    */
1468   function getOrdersForSeller(
1469     address seller
1470   ) public view validAddress(seller) returns (address[]) {
1471     return ordersBySeller[seller];
1472   }
1473 
1474   /**
1475    * @notice Gets all the data orders associated with a buyer.
1476    * @param buyer Buyer address to get orders for.
1477    * @return List of DataOrder addresses.
1478    */
1479   function getOrdersForBuyer(
1480     address buyer
1481   ) public view validAddress(buyer) returns (address[]) {
1482     return ordersByBuyer[buyer];
1483   }
1484 
1485   /**
1486    * @notice Gets all the open data orders, that is all the DataOrders that are
1487    *         still receiving new DataResponses.
1488    * @return List of DataOrder addresses.
1489    */
1490   function getOpenOrders() public view returns (address[]) {
1491     return openOrders.addresses;
1492   }
1493 
1494   /**
1495    * @dev Gets the list of allowed notaries.
1496    * @return List of notary addresses.
1497    */
1498   function getAllowedNotaries() public view returns (address[]) {
1499     return allowedNotaries.addresses;
1500   }
1501 
1502   /**
1503    * @dev Gets information about a give notary.
1504    * @param notary Notary address to get info for.
1505    * @return Notary information (address, name, notaryUrl, publicKey, isActive).
1506    */
1507   function getNotaryInfo(
1508     address notary
1509   ) public view validAddress(notary) returns (address, string, string, string, bool) {
1510     NotaryInfo memory info = notaryInfo[notary];
1511 
1512     return (
1513       info.addr,
1514       info.name,
1515       info.notaryUrl,
1516       info.publicKey,
1517       allowedNotaries.exist(notary)
1518     );
1519   }
1520 
1521   /**
1522    * @dev Requires that five addresses are distinct between themselves and zero.
1523    * @param addresses array of five addresses to explore.
1524    */
1525   function allDistinct(address[5] addresses) private pure {
1526     for (uint i = 0; i < addresses.length; i++) {
1527       require(addresses[i] != address(0));
1528       for (uint j = i + 1; j < addresses.length; j++) { // solium-disable-line zeppelin/no-arithmetic-operations
1529         require(addresses[i] != addresses[j]);
1530       }
1531     }
1532   }
1533 
1534   /**
1535    * @dev Charges a buyer the final charges for a given `DataResponse`.
1536    * @notice 1. Tokens are held in the DataExchange contract until players are paid.
1537    *         2. This function follows a basic invoice flow:
1538    *
1539    *               DataOrder price
1540    *            + Notarization fee
1541    *            ------------------
1542    *                 Total charges
1543    *            -  Prepaid charges (Minimum between Notarization fee and Buyer remaining budget)
1544    *            ------------------
1545    *                 Final charges
1546    *
1547    * @param order DataOrder to which the DataResponse applies.
1548    * @param seller Address of the Seller.
1549    */
1550   function chargeBuyer(DataOrder order, address seller) private whenNotPaused {
1551     address buyer = order.buyer();
1552     address notary = order.getNotaryForSeller(seller);
1553     uint256 remainingBudget = buyerRemainingBudgetForAudits[buyer][order];
1554 
1555     uint256 orderPrice = order.price();
1556     (,, uint256 notarizationFee,,) = order.getNotaryInfo(notary);
1557     uint256 totalCharges = orderPrice.add(notarizationFee);
1558 
1559     uint256 prePaid = Math.min256(notarizationFee, remainingBudget);
1560     uint256 finalCharges = totalCharges.sub(prePaid);
1561 
1562     buyerRemainingBudgetForAudits[buyer][order] = remainingBudget.sub(prePaid);
1563     require(token.transferFrom(buyer, this, finalCharges));
1564 
1565     // Bookkeeping of the available tokens paid by the Buyer and now in control
1566     // of the DataExchange takes into account the total charges (final + pre-paid)
1567     buyerBalance[buyer][order][seller] = buyerBalance[buyer][order][seller].add(totalCharges);
1568   }
1569 
1570   /**
1571    * @dev Pays the seller, notary and/or buyer according to the notary's veredict.
1572    * @param order DataOrder to which the payments apply.
1573    * @param buyer Address of the Buyer.
1574    * @param seller Address of the Seller.
1575    * @param notary Address of the Notary.
1576    * @param wasAudited Indicates whether the data was audited or not.
1577    * @param isDataValid Indicates the result of the audit, if happened.
1578    */
1579   function payPlayers(
1580     DataOrder order,
1581     address buyer,
1582     address seller,
1583     address notary,
1584     bool wasAudited,
1585     bool isDataValid
1586   ) private whenNotPaused {
1587     uint256 orderPrice = order.price();
1588     (,, uint256 notarizationFee,,) = order.getNotaryInfo(notary);
1589     uint256 totalCharges = orderPrice.add(notarizationFee);
1590 
1591     require(buyerBalance[buyer][order][seller] >= totalCharges);
1592     buyerBalance[buyer][order][seller] = buyerBalance[buyer][order][seller].sub(totalCharges);
1593 
1594     // if no notarization was done, notarization fee tokens go back to buyer.
1595     address notarizationFeeReceiver = wasAudited ? notary : buyer;
1596 
1597     // if no notarization was done or data is valid, tokens go to the seller
1598     address orderPriceReceiver = (!wasAudited || isDataValid) ? seller : buyer;
1599 
1600     require(token.transfer(notarizationFeeReceiver, notarizationFee));
1601     require(token.transfer(orderPriceReceiver, orderPrice));
1602   }
1603 
1604 }