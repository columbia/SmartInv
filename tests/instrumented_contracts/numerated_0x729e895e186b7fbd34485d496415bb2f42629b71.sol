1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  * @dev SafeMath adapted for uint96
8  */
9 library SafeMathUint96 {
10   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
11     uint96 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint96 a, uint96 b) internal pure returns (uint96) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint96 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint96 a, uint96 b) internal pure returns (uint96) {
29     uint96 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  * @dev SafeMath adapted for uint8
40  */
41 library SafeMathUint8 {
42   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
43     uint8 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint8 a, uint8 b) internal pure returns (uint8) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint8 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint8 a, uint8 b) internal pure returns (uint8) {
61     uint8 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title SafeMathInt
69  * @dev Math operations with safety checks that throw on error
70  * @dev SafeMath adapted for int256
71  */
72 library SafeMathInt {
73   function mul(int256 a, int256 b) internal pure returns (int256) {
74     // Prevent overflow when multiplying INT256_MIN with -1
75     // https://github.com/RequestNetwork/requestNetwork/issues/43
76     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
77 
78     int256 c = a * b;
79     assert((b == 0) || (c / b == a));
80     return c;
81   }
82 
83   function div(int256 a, int256 b) internal pure returns (int256) {
84     // Prevent overflow when dividing INT256_MIN by -1
85     // https://github.com/RequestNetwork/requestNetwork/issues/43
86     assert(!(a == - 2**255 && b == -1));
87 
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     int256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(int256 a, int256 b) internal pure returns (int256) {
95     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
96 
97     return a - b;
98   }
99 
100   function add(int256 a, int256 b) internal pure returns (int256) {
101     int256 c = a + b;
102     assert((b >= 0 && c >= a) || (b < 0 && c < a));
103     return c;
104   }
105 
106   function toUint256Safe(int256 a) internal pure returns (uint256) {
107     assert(a>=0);
108     return uint256(a);
109   }
110 }
111 
112 /**
113  * @title SafeMath
114  * @dev Math operations with safety checks that throw on error
115  */
116 library SafeMath {
117   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118     uint256 c = a * b;
119 
120     assert(a == 0 || c / a == b);
121     return c;
122   }
123 
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   function add(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 
142   function toInt256Safe(uint256 a) internal pure returns (int256) {
143     int256 b = int256(a);
144     assert(b >= 0);
145     return b;
146   }
147 }
148 
149 
150 /**
151  * @title Bytes util library.
152  * @notice Collection of utility functions to manipulate bytes for Request.
153  */
154 library Bytes {
155     /**
156      * @notice Extracts an address in a bytes.
157      * @param data bytes from where the address will be extract
158      * @param offset position of the first byte of the address
159      * @return address
160      */
161     function extractAddress(bytes data, uint offset)
162         internal
163         pure
164         returns (address m) 
165     {
166         require(offset >= 0 && offset + 20 <= data.length, "offset value should be in the correct range");
167 
168         // solium-disable-next-line security/no-inline-assembly
169         assembly {
170             m := and(
171                 mload(add(data, add(20, offset))), 
172                 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
173             )
174         }
175     }
176 
177     /**
178      * @notice Extract a bytes32 from a bytes.
179      * @param data bytes from where the bytes32 will be extract
180      * @param offset position of the first byte of the bytes32
181      * @return address
182      */
183     function extractBytes32(bytes data, uint offset)
184         internal
185         pure
186         returns (bytes32 bs)
187     {
188         require(offset >= 0 && offset + 32 <= data.length, "offset value should be in the correct range");
189 
190         // solium-disable-next-line security/no-inline-assembly
191         assembly {
192             bs := mload(add(data, add(32, offset)))
193         }
194     }
195 
196     /**
197      * @notice Modifies 20 bytes in a bytes.
198      * @param data bytes to modify
199      * @param offset position of the first byte to modify
200      * @param b bytes20 to insert
201      * @return address
202      */
203     function updateBytes20inBytes(bytes data, uint offset, bytes20 b)
204         internal
205         pure
206     {
207         require(offset >= 0 && offset + 20 <= data.length, "offset value should be in the correct range");
208 
209         // solium-disable-next-line security/no-inline-assembly
210         assembly {
211             let m := mload(add(data, add(20, offset)))
212             m := and(m, 0xFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000)
213             m := or(m, div(b, 0x1000000000000000000000000))
214             mstore(add(data, add(20, offset)), m)
215         }
216     }
217 
218     /**
219      * @notice Extracts a string from a bytes. Extracts a sub-part from the bytes and convert it to string.
220      * @param data bytes from where the string will be extracted
221      * @param size string size to extract
222      * @param _offset position of the first byte of the string in bytes
223      * @return string
224      */ 
225     function extractString(bytes data, uint8 size, uint _offset) 
226         internal 
227         pure 
228         returns (string) 
229     {
230         bytes memory bytesString = new bytes(size);
231         for (uint j = 0; j < size; j++) {
232             bytesString[j] = data[_offset+j];
233         }
234         return string(bytesString);
235     }
236 }
237 
238 
239 /**
240  * @title Ownable
241  * @dev The Ownable contract has an owner address, and provides basic authorization control
242  * functions, this simplifies the implementation of "user permissions".
243  */
244 contract Ownable {
245   address public owner;
246 
247 
248   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250 
251   /**
252    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
253    * account.
254    */
255   function Ownable() public {
256     owner = msg.sender;
257   }
258 
259 
260   /**
261    * @dev Throws if called by any account other than the owner.
262    */
263   modifier onlyOwner() {
264     require(msg.sender == owner);
265     _;
266   }
267 
268 
269   /**
270    * @dev Allows the current owner to transfer control of the contract to a newOwner.
271    * @param newOwner The address to transfer ownership to.
272    */
273   function transferOwnership(address newOwner) onlyOwner public {
274     require(newOwner != address(0));
275     OwnershipTransferred(owner, newOwner);
276     owner = newOwner;
277   }
278 
279 }
280 
281 /**
282  * @title Pausable
283  * @dev Base contract which allows children to implement an emergency stop mechanism.
284  */
285 contract Pausable is Ownable {
286     event Pause();
287     event Unpause();
288 
289     bool public paused = false;
290 
291 
292     /**
293      * @dev Modifier to make a function callable only when the contract is not paused.
294      */
295     modifier whenNotPaused() {
296         require(!paused);
297         _;
298     }
299 
300     /**
301      * @dev Modifier to make a function callable only when the contract is paused.
302      */
303     modifier whenPaused() {
304         require(paused);
305         _;
306     }
307 
308     /**
309      * @dev called by the owner to pause, triggers stopped state
310      */
311     function pause() onlyOwner whenNotPaused public {
312         paused = true;
313         Pause();
314     }
315 
316     /**
317      * @dev called by the owner to unpause, returns to normal state
318      */
319     function unpause() onlyOwner whenPaused public {
320         paused = false;
321         Unpause();
322     }
323 }
324 
325 
326 /**
327  * @title ERC20Basic
328  * @dev Simpler version of ERC20 interface
329  * @dev see https://github.com/ethereum/EIPs/issues/179
330  */
331 contract ERC20Basic {
332   uint256 public totalSupply;
333   function balanceOf(address who) public constant returns (uint256);
334   function transfer(address to, uint256 value) public returns (bool);
335   event Transfer(address indexed from, address indexed to, uint256 value);
336 }
337 
338 
339 /**
340  * @title FeeCollector
341  *
342  * @notice FeeCollector is a contract managing the fees for currency contracts
343  */
344 contract FeeCollector is Ownable {
345     using SafeMath for uint256;
346 
347     uint256 public rateFeesNumerator;
348     uint256 public rateFeesDenominator;
349     uint256 public maxFees;
350 
351     // address of the contract that will burn req token
352     address public requestBurnerContract;
353 
354     event UpdateRateFees(uint256 rateFeesNumerator, uint256 rateFeesDenominator);
355     event UpdateMaxFees(uint256 maxFees);
356 
357     /**
358      * @param _requestBurnerContract Address of the contract where to send the ether.
359      * This burner contract will have a function that can be called by anyone and will exchange ether to req via Kyber and burn the REQ
360      */  
361     constructor(address _requestBurnerContract) 
362         public
363     {
364         requestBurnerContract = _requestBurnerContract;
365     }
366 
367     /**
368      * @notice Sets the fees rate.
369      * @dev if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
370      * @param _rateFeesNumerator        numerator rate
371      * @param _rateFeesDenominator      denominator rate
372      */  
373     function setRateFees(uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
374         external
375         onlyOwner
376     {
377         rateFeesNumerator = _rateFeesNumerator;
378         rateFeesDenominator = _rateFeesDenominator;
379         emit UpdateRateFees(rateFeesNumerator, rateFeesDenominator);
380     }
381 
382     /**
383      * @notice Sets the maximum fees in wei.
384      * @param _newMaxFees new max
385      */  
386     function setMaxCollectable(uint256 _newMaxFees) 
387         external
388         onlyOwner
389     {
390         maxFees = _newMaxFees;
391         emit UpdateMaxFees(maxFees);
392     }
393 
394     /**
395      * @notice Set the request burner address.
396      * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
397      */  
398     function setRequestBurnerContract(address _requestBurnerContract) 
399         external
400         onlyOwner
401     {
402         requestBurnerContract = _requestBurnerContract;
403     }
404 
405     /**
406      * @notice Computes the fees.
407      * @param _expectedAmount amount expected for the request
408      * @return the expected amount of fees in wei
409      */  
410     function collectEstimation(int256 _expectedAmount)
411         public
412         view
413         returns(uint256)
414     {
415         if (_expectedAmount<0) {
416             return 0;
417         }
418 
419         uint256 computedCollect = uint256(_expectedAmount).mul(rateFeesNumerator);
420 
421         if (rateFeesDenominator != 0) {
422             computedCollect = computedCollect.div(rateFeesDenominator);
423         }
424 
425         return computedCollect < maxFees ? computedCollect : maxFees;
426     }
427 
428     /**
429      * @notice Sends fees to the request burning address.
430      * @param _amount amount to send to the burning address
431      */  
432     function collectForREQBurning(uint256 _amount)
433         internal
434     {
435         // .transfer throws on failure
436         requestBurnerContract.transfer(_amount);
437     }
438 }
439 
440 
441 /**
442  * @title Administrable
443  * @notice Base contract for the administration of Core. Handles whitelisting of currency contracts
444  */
445 contract Administrable is Pausable {
446 
447     // mapping of address of trusted contract
448     mapping(address => uint8) public trustedCurrencyContracts;
449 
450     // Events of the system
451     event NewTrustedContract(address newContract);
452     event RemoveTrustedContract(address oldContract);
453 
454     /**
455      * @notice Adds a trusted currencyContract.
456      *
457      * @param _newContractAddress The address of the currencyContract
458      */
459     function adminAddTrustedCurrencyContract(address _newContractAddress)
460         external
461         onlyOwner
462     {
463         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
464         emit NewTrustedContract(_newContractAddress);
465     }
466 
467     /**
468      * @notice Removes a trusted currencyContract.
469      *
470      * @param _oldTrustedContractAddress The address of the currencyContract
471      */
472     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
473         external
474         onlyOwner
475     {
476         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0, "_oldTrustedContractAddress should not be 0");
477         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
478         emit RemoveTrustedContract(_oldTrustedContractAddress);
479     }
480 
481     /**
482      * @notice Gets the status of a trusted currencyContract .
483      * @dev Not used today, useful if we have several states in the future.
484      *
485      * @param _contractAddress The address of the currencyContract
486      * @return The status of the currencyContract. If trusted 1, otherwise 0
487      */
488     function getStatusContract(address _contractAddress)
489         external
490         view
491         returns(uint8) 
492     {
493         return trustedCurrencyContracts[_contractAddress];
494     }
495 
496     /**
497      * @notice Checks if a currencyContract is trusted.
498      *
499      * @param _contractAddress The address of the currencyContract
500      * @return bool true if contract is trusted
501      */
502     function isTrustedContract(address _contractAddress)
503         public
504         view
505         returns(bool)
506     {
507         return trustedCurrencyContracts[_contractAddress] == 1;
508     }
509 }
510 
511 
512 /**
513  * @title ERC20 interface
514  * @dev see https://github.com/ethereum/EIPs/issues/20
515  */
516 contract ERC20 is ERC20Basic {
517   function allowance(address owner, address spender) public constant returns (uint256);
518   function transferFrom(address from, address to, uint256 value) public returns (bool);
519   function approve(address spender, uint256 value) public returns (bool);
520   event Approval(address indexed owner, address indexed spender, uint256 value);
521 }
522 
523 /**
524  * @title ERC20 interface with no return for approve and transferFrom (like OMG token)
525  * @dev see https://etherscan.io/address/0xd26114cd6EE289AccF82350c8d8487fedB8A0C07#code
526  */
527 contract ERC20OMGLike is ERC20Basic {
528   function allowance(address owner, address spender) public constant returns (uint256);
529   function transferFrom(address from, address to, uint256 value) public;
530   function approve(address spender, uint256 value) public;
531   event Approval(address indexed owner, address indexed spender, uint256 value);
532 }
533 
534 
535 
536 /**
537  * @title RequestCore
538  *
539  * @notice The Core is the main contract which stores all the requests.
540  *
541  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
542  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
543  * @dev Requests can only be created in the currency contracts
544  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
545  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
546  */
547 contract RequestCore is Administrable {
548     using SafeMath for uint256;
549     using SafeMathUint96 for uint96;
550     using SafeMathInt for int256;
551     using SafeMathUint8 for uint8;
552 
553     enum State { Created, Accepted, Canceled }
554 
555     struct Request {
556         // ID address of the payer
557         address payer;
558 
559         // Address of the contract managing the request
560         address currencyContract;
561 
562         // State of the request
563         State state;
564 
565         // Main payee
566         Payee payee;
567     }
568 
569     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
570     // ex: can be used for routing taxes or fees at the moment of the payment.
571     struct Payee {
572         // ID address of the payee
573         address addr;
574 
575         // amount expected for the payee. 
576         // Not uint for evolution (may need negative amounts one day), and simpler operations
577         int256 expectedAmount;
578 
579         // balance of the payee
580         int256 balance;
581     }
582 
583     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
584     // Integer, incremented for each request of a Core contract, starting from 0
585     // RequestId (256bits) = contract address (160bits) + numRequest
586     uint96 public numRequests; 
587     
588     // Mapping of all the Requests. The key is the request ID.
589     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
590     // https://github.com/ethereum/solidity/issues/3577
591     mapping(bytes32 => Request) requests;
592 
593     // Mapping of subPayees of the requests. The key is the request ID.
594     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
595     mapping(bytes32 => Payee[256]) public subPayees;
596 
597     /*
598      *  Events 
599      */
600     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
601     event Accepted(bytes32 indexed requestId);
602     event Canceled(bytes32 indexed requestId);
603 
604     // Event for Payee & subPayees
605     // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
606     event NewSubPayee(bytes32 indexed requestId, address indexed payee); 
607     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
608     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
609 
610     /**
611      * @notice Function used by currency contracts to create a request in the Core.
612      *
613      * @dev _payees and _expectedAmounts must have the same size.
614      *
615      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
616      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
617      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
618      * @param _payer Entity expected to pay
619      * @param _data data of the request
620      * @return Returns the id of the request
621      */
622     function createRequest(
623         address     _creator,
624         address[]   _payees,
625         int256[]    _expectedAmounts,
626         address     _payer,
627         string      _data)
628         external
629         whenNotPaused 
630         returns (bytes32 requestId) 
631     {
632         // creator must not be null
633         require(_creator != 0, "creator should not be 0"); // not as modifier to lighten the stack
634         // call must come from a trusted contract
635         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
636 
637         // Generate the requestId
638         requestId = generateRequestId();
639 
640         address mainPayee;
641         int256 mainExpectedAmount;
642         // extract the main payee if filled
643         if (_payees.length!=0) {
644             mainPayee = _payees[0];
645             mainExpectedAmount = _expectedAmounts[0];
646         }
647 
648         // Store the new request
649         requests[requestId] = Request(
650             _payer,
651             msg.sender,
652             State.Created,
653             Payee(
654                 mainPayee,
655                 mainExpectedAmount,
656                 0
657             )
658         );
659 
660         // Declare the new request
661         emit Created(
662             requestId,
663             mainPayee,
664             _payer,
665             _creator,
666             _data
667         );
668         
669         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
670         initSubPayees(requestId, _payees, _expectedAmounts);
671 
672         return requestId;
673     }
674 
675     /**
676      * @notice Function used by currency contracts to create a request in the Core from bytes.
677      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
678      * @dev Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
679      * @param _data bytes containing all the data packed :
680             address(creator)
681             address(payer)
682             uint8(number_of_payees)
683             [
684                 address(main_payee_address)
685                 int256(main_payee_expected_amount)
686                 address(second_payee_address)
687                 int256(second_payee_expected_amount)
688                 ...
689             ]
690             uint8(data_string_size)
691             size(data)
692      * @return Returns the id of the request 
693      */ 
694     function createRequestFromBytes(bytes _data) 
695         external
696         whenNotPaused 
697         returns (bytes32 requestId) 
698     {
699         // call must come from a trusted contract
700         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
701 
702         // extract address creator & payer
703         address creator = extractAddress(_data, 0);
704 
705         address payer = extractAddress(_data, 20);
706 
707         // creator must not be null
708         require(creator!=0, "creator should not be 0");
709         
710         // extract the number of payees
711         uint8 payeesCount = uint8(_data[40]);
712 
713         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
714         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
715         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
716 
717         // extract the data size and then the data itself
718         uint8 dataSize = uint8(_data[offsetDataSize]);
719         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
720 
721         address mainPayee;
722         int256 mainExpectedAmount;
723         // extract the main payee if possible
724         if (payeesCount!=0) {
725             mainPayee = extractAddress(_data, 41);
726             mainExpectedAmount = int256(extractBytes32(_data, 61));
727         }
728 
729         // Generate the requestId
730         requestId = generateRequestId();
731 
732         // Store the new request
733         requests[requestId] = Request(
734             payer,
735             msg.sender,
736             State.Created,
737             Payee(
738                 mainPayee,
739                 mainExpectedAmount,
740                 0
741             )
742         );
743 
744         // Declare the new request
745         emit Created(
746             requestId,
747             mainPayee,
748             payer,
749             creator,
750             dataStr
751         );
752 
753         // Store and declare the sub payees
754         for (uint8 i = 1; i < payeesCount; i = i.add(1)) {
755             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
756 
757             // payees address cannot be 0x0
758             require(subPayeeAddress != 0, "subpayee should not be 0");
759 
760             subPayees[requestId][i-1] = Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
761             emit NewSubPayee(requestId, subPayeeAddress);
762         }
763 
764         return requestId;
765     }
766 
767     /**
768      * @notice Function used by currency contracts to accept a request in the Core.
769      * @dev callable only by the currency contract of the request
770      * @param _requestId Request id
771      */ 
772     function accept(bytes32 _requestId) 
773         external
774     {
775         Request storage r = requests[_requestId];
776         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
777         r.state = State.Accepted;
778         emit Accepted(_requestId);
779     }
780 
781     /**
782      * @notice Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
783      * @dev callable only by the currency contract of the request.
784      * @param _requestId Request id
785      */ 
786     function cancel(bytes32 _requestId)
787         external
788     {
789         Request storage r = requests[_requestId];
790         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
791         r.state = State.Canceled;
792         emit Canceled(_requestId);
793     }   
794 
795     /**
796      * @notice Function used to update the balance.
797      * @dev callable only by the currency contract of the request.
798      * @param _requestId Request id
799      * @param _payeeIndex index of the payee (0 = main payee)
800      * @param _deltaAmount modifier amount
801      */ 
802     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
803         external
804     {   
805         Request storage r = requests[_requestId];
806         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
807 
808         if ( _payeeIndex == 0 ) {
809             // modify the main payee
810             r.payee.balance = r.payee.balance.add(_deltaAmount);
811         } else {
812             // modify the sub payee
813             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
814             sp.balance = sp.balance.add(_deltaAmount);
815         }
816         emit UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
817     }
818 
819     /**
820      * @notice Function update the expectedAmount adding additional or subtract.
821      * @dev callable only by the currency contract of the request.
822      * @param _requestId Request id
823      * @param _payeeIndex index of the payee (0 = main payee)
824      * @param _deltaAmount modifier amount
825      */ 
826     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
827         external
828     {   
829         Request storage r = requests[_requestId];
830         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request");  
831 
832         if ( _payeeIndex == 0 ) {
833             // modify the main payee
834             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
835         } else {
836             // modify the sub payee
837             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
838             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
839         }
840         emit UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
841     }
842 
843     /**
844      * @notice Gets a request.
845      * @param _requestId Request id
846      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
847      */ 
848     function getRequest(bytes32 _requestId) 
849         external
850         view
851         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
852     {
853         Request storage r = requests[_requestId];
854         return (
855             r.payer,
856             r.currencyContract,
857             r.state,
858             r.payee.addr,
859             r.payee.expectedAmount,
860             r.payee.balance
861         );
862     }
863 
864     /**
865      * @notice Gets address of a payee.
866      * @param _requestId Request id
867      * @param _payeeIndex payee index (0 = main payee)
868      * @return payee address
869      */ 
870     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
871         public
872         view
873         returns(address)
874     {
875         if (_payeeIndex == 0) {
876             return requests[_requestId].payee.addr;
877         } else {
878             return subPayees[_requestId][_payeeIndex-1].addr;
879         }
880     }
881 
882     /**
883      * @notice Gets payer of a request.
884      * @param _requestId Request id
885      * @return payer address
886      */ 
887     function getPayer(bytes32 _requestId)
888         public
889         view
890         returns(address)
891     {
892         return requests[_requestId].payer;
893     }
894 
895     /**
896      * @notice Gets amount expected of a payee.
897      * @param _requestId Request id
898      * @param _payeeIndex payee index (0 = main payee)
899      * @return amount expected
900      */     
901     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
902         public
903         view
904         returns(int256)
905     {
906         if (_payeeIndex == 0) {
907             return requests[_requestId].payee.expectedAmount;
908         } else {
909             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
910         }
911     }
912 
913     /**
914      * @notice Gets number of subPayees for a request.
915      * @param _requestId Request id
916      * @return number of subPayees
917      */     
918     function getSubPayeesCount(bytes32 _requestId)
919         public
920         view
921         returns(uint8)
922     {
923         // solium-disable-next-line no-empty-blocks
924         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {}
925         return i;
926     }
927 
928     /**
929      * @notice Gets currencyContract of a request.
930      * @param _requestId Request id
931      * @return currencyContract address
932      */
933     function getCurrencyContract(bytes32 _requestId)
934         public
935         view
936         returns(address)
937     {
938         return requests[_requestId].currencyContract;
939     }
940 
941     /**
942      * @notice Gets balance of a payee.
943      * @param _requestId Request id
944      * @param _payeeIndex payee index (0 = main payee)
945      * @return balance
946      */     
947     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
948         public
949         view
950         returns(int256)
951     {
952         if (_payeeIndex == 0) {
953             return requests[_requestId].payee.balance;    
954         } else {
955             return subPayees[_requestId][_payeeIndex-1].balance;
956         }
957     }
958 
959     /**
960      * @notice Gets balance total of a request.
961      * @param _requestId Request id
962      * @return balance
963      */     
964     function getBalance(bytes32 _requestId)
965         public
966         view
967         returns(int256)
968     {
969         int256 balance = requests[_requestId].payee.balance;
970 
971         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
972             balance = balance.add(subPayees[_requestId][i].balance);
973         }
974 
975         return balance;
976     }
977 
978     /**
979      * @notice Checks if all the payees balances are null.
980      * @param _requestId Request id
981      * @return true if all the payees balances are equals to 0
982      */     
983     function areAllBalanceNull(bytes32 _requestId)
984         public
985         view
986         returns(bool isNull)
987     {
988         isNull = requests[_requestId].payee.balance == 0;
989 
990         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
991             isNull = subPayees[_requestId][i].balance == 0;
992         }
993 
994         return isNull;
995     }
996 
997     /**
998      * @notice Gets total expectedAmount of a request.
999      * @param _requestId Request id
1000      * @return balance
1001      */     
1002     function getExpectedAmount(bytes32 _requestId)
1003         public
1004         view
1005         returns(int256)
1006     {
1007         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
1008 
1009         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1010             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
1011         }
1012 
1013         return expectedAmount;
1014     }
1015 
1016     /**
1017      * @notice Gets state of a request.
1018      * @param _requestId Request id
1019      * @return state
1020      */ 
1021     function getState(bytes32 _requestId)
1022         public
1023         view
1024         returns(State)
1025     {
1026         return requests[_requestId].state;
1027     }
1028 
1029     /**
1030      * @notice Gets address of a payee.
1031      * @param _requestId Request id
1032      * @return payee index (0 = main payee) or -1 if not address not found
1033      */
1034     function getPayeeIndex(bytes32 _requestId, address _address)
1035         public
1036         view
1037         returns(int16)
1038     {
1039         // return 0 if main payee
1040         if (requests[_requestId].payee.addr == _address) {
1041             return 0;
1042         }
1043 
1044         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1045             if (subPayees[_requestId][i].addr == _address) {
1046                 // if found return subPayee index + 1 (0 is main payee)
1047                 return i+1;
1048             }
1049         }
1050         return -1;
1051     }
1052 
1053     /**
1054      * @notice Extracts a bytes32 from a bytes.
1055      * @param _data bytes from where the bytes32 will be extract
1056      * @param offset position of the first byte of the bytes32
1057      * @return address
1058      */
1059     function extractBytes32(bytes _data, uint offset)
1060         public
1061         pure
1062         returns (bytes32 bs)
1063     {
1064         require(offset >= 0 && offset + 32 <= _data.length, "offset value should be in the correct range");
1065 
1066         // solium-disable-next-line security/no-inline-assembly
1067         assembly {
1068             bs := mload(add(_data, add(32, offset)))
1069         }
1070     }
1071 
1072     /**
1073      * @notice Transfers to owner any tokens send by mistake on this contracts.
1074      * @param token The address of the token to transfer.
1075      * @param amount The amount to be transfered.
1076      */
1077     function emergencyERC20Drain(ERC20 token, uint amount )
1078         public
1079         onlyOwner 
1080     {
1081         token.transfer(owner, amount);
1082     }
1083 
1084     /**
1085      * @notice Extracts an address from a bytes at a given position.
1086      * @param _data bytes from where the address will be extract
1087      * @param offset position of the first byte of the address
1088      * @return address
1089      */
1090     function extractAddress(bytes _data, uint offset)
1091         internal
1092         pure
1093         returns (address m)
1094     {
1095         require(offset >= 0 && offset + 20 <= _data.length, "offset value should be in the correct range");
1096 
1097         // solium-disable-next-line security/no-inline-assembly
1098         assembly {
1099             m := and( mload(add(_data, add(20, offset))), 
1100                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1101         }
1102     }
1103     
1104     /**
1105      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest()).
1106      * @param _requestId Request id
1107      * @param _payees array of payees address
1108      * @param _expectedAmounts array of payees initial expected amounts
1109      */ 
1110     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
1111         internal
1112     {
1113         require(_payees.length == _expectedAmounts.length, "payee length should equal expected amount length");
1114      
1115         for (uint8 i = 1; i < _payees.length; i = i.add(1)) {
1116             // payees address cannot be 0x0
1117             require(_payees[i] != 0, "payee should not be 0");
1118             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
1119             emit NewSubPayee(_requestId, _payees[i]);
1120         }
1121     }
1122 
1123     /**
1124      * @notice Extracts a string from a bytes. Extracts a sub-part from tha bytes and convert it to string.
1125      * @param data bytes from where the string will be extracted
1126      * @param size string size to extract
1127      * @param _offset position of the first byte of the string in bytes
1128      * @return string
1129      */ 
1130     function extractString(bytes data, uint8 size, uint _offset) 
1131         internal 
1132         pure 
1133         returns (string) 
1134     {
1135         bytes memory bytesString = new bytes(size);
1136         for (uint j = 0; j < size; j++) {
1137             bytesString[j] = data[_offset+j];
1138         }
1139         return string(bytesString);
1140     }
1141 
1142     /**
1143      * @notice Generates a new unique requestId.
1144      * @return a bytes32 requestId 
1145      */ 
1146     function generateRequestId()
1147         internal
1148         returns (bytes32)
1149     {
1150         // Update numRequest
1151         numRequests = numRequests.add(1);
1152         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
1153         return bytes32((uint256(this) << 96).add(numRequests));
1154     }
1155 }
1156 
1157 
1158 /**
1159  * @title CurrencyContract
1160  *
1161  * @notice CurrencyContract is the base for currency contracts. To add a currency to the Request Protocol, create a new currencyContract that inherits from it.
1162  * @dev If currency contract is whitelisted by core & unpaused: All actions possible
1163  * @dev If currency contract is not Whitelisted by core & unpaused: Creation impossible, other actions possible
1164  * @dev If currency contract is paused: Nothing possible
1165  *
1166  * Functions that can be implemented by the currency contracts:
1167  *  - createRequestAsPayeeAction
1168  *  - createRequestAsPayerAction
1169  *  - broadcastSignedRequestAsPayer
1170  *  - paymentActionPayable
1171  *  - paymentAction
1172  *  - accept
1173  *  - cancel
1174  *  - refundAction
1175  *  - subtractAction
1176  *  - additionalAction
1177  */
1178 contract CurrencyContract is Pausable, FeeCollector {
1179     using SafeMath for uint256;
1180     using SafeMathInt for int256;
1181     using SafeMathUint8 for uint8;
1182 
1183     RequestCore public requestCore;
1184 
1185     /**
1186      * @param _requestCoreAddress Request Core address
1187      */
1188     constructor(address _requestCoreAddress, address _addressBurner) 
1189         FeeCollector(_addressBurner)
1190         public
1191     {
1192         requestCore = RequestCore(_requestCoreAddress);
1193     }
1194 
1195     /**
1196      * @notice Function to accept a request.
1197      *
1198      * @notice msg.sender must be _payer, The request must be in the state CREATED (not CANCELED, not ACCEPTED).
1199      *
1200      * @param _requestId id of the request
1201      */
1202     function acceptAction(bytes32 _requestId)
1203         public
1204         whenNotPaused
1205         onlyRequestPayer(_requestId)
1206     {
1207         // only a created request can be accepted
1208         require(requestCore.getState(_requestId) == RequestCore.State.Created, "request should be created");
1209 
1210         // declare the acceptation in the core
1211         requestCore.accept(_requestId);
1212     }
1213 
1214     /**
1215      * @notice Function to cancel a request.
1216      *
1217      * @dev msg.sender must be the _payer or the _payee.
1218      * @dev only request with balance equals to zero can be cancel.
1219      *
1220      * @param _requestId id of the request
1221      */
1222     function cancelAction(bytes32 _requestId)
1223         public
1224         whenNotPaused
1225     {
1226         // payer can cancel if request is just created
1227         // payee can cancel when request is not canceled yet
1228         require(
1229             // solium-disable-next-line indentation
1230             (requestCore.getPayer(_requestId) == msg.sender && requestCore.getState(_requestId) == RequestCore.State.Created) ||
1231             (requestCore.getPayeeAddress(_requestId,0) == msg.sender && requestCore.getState(_requestId) != RequestCore.State.Canceled),
1232             "payer should cancel a newly created request, or payee should cancel a not cancel request"
1233         );
1234 
1235         // impossible to cancel a Request with any payees balance != 0
1236         require(requestCore.areAllBalanceNull(_requestId), "all balanaces should be = 0 to cancel");
1237 
1238         // declare the cancellation in the core
1239         requestCore.cancel(_requestId);
1240     }
1241 
1242     /**
1243      * @notice Function to declare additionals.
1244      *
1245      * @dev msg.sender must be _payer.
1246      * @dev the request must be accepted or created.
1247      *
1248      * @param _requestId id of the request
1249      * @param _additionalAmounts amounts of additional to declare (index 0 is for main payee)
1250      */
1251     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1252         public
1253         whenNotPaused
1254         onlyRequestPayer(_requestId)
1255     {
1256 
1257         // impossible to make additional if request is canceled
1258         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1259 
1260         // impossible to declare more additionals than the number of payees
1261         require(
1262             _additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1263             "number of amounts should be <= number of payees"
1264         );
1265 
1266         for (uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1267             // no need to declare a zero as additional 
1268             if (_additionalAmounts[i] != 0) {
1269                 // Store and declare the additional in the core
1270                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1271             }
1272         }
1273     }
1274 
1275     /**
1276      * @notice Function to declare subtracts.
1277      *
1278      * @dev msg.sender must be _payee.
1279      * @dev the request must be accepted or created.
1280      *
1281      * @param _requestId id of the request
1282      * @param _subtractAmounts amounts of subtract to declare (index 0 is for main payee)
1283      */
1284     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1285         public
1286         whenNotPaused
1287         onlyRequestPayee(_requestId)
1288     {
1289         // impossible to make subtracts if request is canceled
1290         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1291 
1292         // impossible to declare more subtracts than the number of payees
1293         require(
1294             _subtractAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1295             "number of amounts should be <= number of payees"
1296         );
1297 
1298         for (uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1299             // no need to declare a zero as subtracts 
1300             if (_subtractAmounts[i] != 0) {
1301                 // subtract must be equal or lower than amount expected
1302                 require(
1303                     requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe(),
1304                     "subtract should equal or be lower than amount expected"
1305                 );
1306 
1307                 // Store and declare the subtract in the core
1308                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1309             }
1310         }
1311     }
1312 
1313     /**
1314      * @notice Base function for request creation.
1315      *
1316      * @dev msg.sender will be the creator.
1317      *
1318      * @param _payer Entity expected to pay
1319      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1320      * @param _expectedAmounts array of Expected amount to be received by each payees
1321      * @param _data Hash linking to additional data on the Request stored on IPFS
1322      *
1323      * @return Returns the id of the request and the collected fees
1324      */
1325     function createCoreRequestInternal(
1326         address     _payer,
1327         address[]   _payeesIdAddress,
1328         int256[]    _expectedAmounts,
1329         string      _data)
1330         internal
1331         whenNotPaused
1332         returns(bytes32 requestId, uint256 collectedFees)
1333     {
1334         int256 totalExpectedAmounts = 0;
1335         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1)) {
1336             // all expected amounts must be positive
1337             require(_expectedAmounts[i] >= 0, "expected amounts should be positive");
1338 
1339             // compute the total expected amount of the request
1340             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1341         }
1342 
1343         // store request in the core
1344         requestId = requestCore.createRequest(
1345             msg.sender,
1346             _payeesIdAddress,
1347             _expectedAmounts,
1348             _payer,
1349             _data
1350         );
1351 
1352         // compute and send fees
1353         collectedFees = collectEstimation(totalExpectedAmounts);
1354         collectForREQBurning(collectedFees);
1355     }
1356 
1357     /**
1358      * @notice Modifier to check if msg.sender is the main payee.
1359      * @dev Revert if msg.sender is not the main payee.
1360      * @param _requestId id of the request
1361      */ 
1362     modifier onlyRequestPayee(bytes32 _requestId)
1363     {
1364         require(requestCore.getPayeeAddress(_requestId, 0) == msg.sender, "only the payee should do this action");
1365         _;
1366     }
1367 
1368     /**
1369      * @notice Modifier to check if msg.sender is payer.
1370      * @dev Revert if msg.sender is not payer.
1371      * @param _requestId id of the request
1372      */ 
1373     modifier onlyRequestPayer(bytes32 _requestId)
1374     {
1375         require(requestCore.getPayer(_requestId) == msg.sender, "only the payer should do this action");
1376         _;
1377     }
1378 }
1379 
1380 
1381 /**
1382  * @title Request Signature util library.
1383  * @notice Collection of utility functions to handle Request signatures.
1384  */
1385 library Signature {
1386     using SafeMath for uint256;
1387     using SafeMathInt for int256;
1388     using SafeMathUint8 for uint8;
1389 
1390     /**
1391      * @notice Checks the validity of a signed request & the expiration date.
1392      * @param requestData bytes containing all the data packed :
1393             address(creator)
1394             address(payer)
1395             uint8(number_of_payees)
1396             [
1397                 address(main_payee_address)
1398                 int256(main_payee_expected_amount)
1399                 address(second_payee_address)
1400                 int256(second_payee_expected_amount)
1401                 ...
1402             ]
1403             uint8(data_string_size)
1404             size(data)
1405      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
1406      * @param expirationDate timestamp after that the signed request cannot be broadcasted
1407      * @param signature ECDSA signature containing v, r and s as bytes
1408      *
1409      * @return Validity of order signature.
1410      */ 
1411     function checkRequestSignature(
1412         bytes       requestData,
1413         address[]   payeesPaymentAddress,
1414         uint256     expirationDate,
1415         bytes       signature)
1416         internal
1417         view
1418         returns (bool)
1419     {
1420         bytes32 hash = getRequestHash(requestData, payeesPaymentAddress, expirationDate);
1421 
1422         // extract "v, r, s" from the signature
1423         uint8 v = uint8(signature[64]);
1424         v = v < 27 ? v.add(27) : v;
1425         bytes32 r = Bytes.extractBytes32(signature, 0);
1426         bytes32 s = Bytes.extractBytes32(signature, 32);
1427 
1428         // check signature of the hash with the creator address
1429         return isValidSignature(
1430             Bytes.extractAddress(requestData, 0),
1431             hash,
1432             v,
1433             r,
1434             s
1435         );
1436     }
1437 
1438     /**
1439      * @notice Checks the validity of a Bitcoin signed request & the expiration date.
1440      * @param requestData bytes containing all the data packed :
1441             address(creator)
1442             address(payer)
1443             uint8(number_of_payees)
1444             [
1445                 address(main_payee_address)
1446                 int256(main_payee_expected_amount)
1447                 address(second_payee_address)
1448                 int256(second_payee_expected_amount)
1449                 ...
1450             ]
1451             uint8(data_string_size)
1452             size(data)
1453      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
1454      * @param expirationDate timestamp after that the signed request cannot be broadcasted
1455      * @param signature ECDSA signature containing v, r and s as bytes
1456      *
1457      * @return Validity of order signature.
1458      */ 
1459     function checkBtcRequestSignature(
1460         bytes       requestData,
1461         bytes       payeesPaymentAddress,
1462         uint256     expirationDate,
1463         bytes       signature)
1464         internal
1465         view
1466         returns (bool)
1467     {
1468         bytes32 hash = getBtcRequestHash(requestData, payeesPaymentAddress, expirationDate);
1469 
1470         // extract "v, r, s" from the signature
1471         uint8 v = uint8(signature[64]);
1472         v = v < 27 ? v.add(27) : v;
1473         bytes32 r = Bytes.extractBytes32(signature, 0);
1474         bytes32 s = Bytes.extractBytes32(signature, 32);
1475 
1476         // check signature of the hash with the creator address
1477         return isValidSignature(
1478             Bytes.extractAddress(requestData, 0),
1479             hash,
1480             v,
1481             r,
1482             s
1483         );
1484     }
1485     
1486     /**
1487      * @notice Calculates the Keccak-256 hash of a BTC request with specified parameters.
1488      *
1489      * @param requestData bytes containing all the data packed
1490      * @param payeesPaymentAddress array of payees payment addresses
1491      * @param expirationDate timestamp after what the signed request cannot be broadcasted
1492      *
1493      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
1494      */
1495     function getBtcRequestHash(
1496         bytes       requestData,
1497         bytes   payeesPaymentAddress,
1498         uint256     expirationDate)
1499         private
1500         view
1501         returns(bytes32)
1502     {
1503         return keccak256(
1504             abi.encodePacked(
1505                 this,
1506                 requestData,
1507                 payeesPaymentAddress,
1508                 expirationDate
1509             )
1510         );
1511     }
1512 
1513     /**
1514      * @dev Calculates the Keccak-256 hash of a (not BTC) request with specified parameters.
1515      *
1516      * @param requestData bytes containing all the data packed
1517      * @param payeesPaymentAddress array of payees payment addresses
1518      * @param expirationDate timestamp after what the signed request cannot be broadcasted
1519      *
1520      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
1521      */
1522     function getRequestHash(
1523         bytes       requestData,
1524         address[]   payeesPaymentAddress,
1525         uint256     expirationDate)
1526         private
1527         view
1528         returns(bytes32)
1529     {
1530         return keccak256(
1531             abi.encodePacked(
1532                 this,
1533                 requestData,
1534                 payeesPaymentAddress,
1535                 expirationDate
1536             )
1537         );
1538     }
1539     
1540     /**
1541      * @notice Verifies that a hash signature is valid. 0x style.
1542      * @param signer address of signer.
1543      * @param hash Signed Keccak-256 hash.
1544      * @param v ECDSA signature parameter v.
1545      * @param r ECDSA signature parameters r.
1546      * @param s ECDSA signature parameters s.
1547      * @return Validity of order signature.
1548      */
1549     function isValidSignature(
1550         address signer,
1551         bytes32 hash,
1552         uint8   v,
1553         bytes32 r,
1554         bytes32 s)
1555         private
1556         pure
1557         returns (bool)
1558     {
1559         return signer == ecrecover(
1560             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
1561             v,
1562             r,
1563             s
1564         );
1565     }
1566 }
1567 
1568 /**
1569  * @title RequestOMG
1570  * @notice Currency contract managing the requests in ERC20 tokens like OMG (without returns).
1571  * @dev Requests can be created by the Payee with createRequestAsPayeeAction(), by the payer with createRequestAsPayerAction() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1572  */
1573 contract RequestOMG is CurrencyContract {
1574     using SafeMath for uint256;
1575     using SafeMathInt for int256;
1576     using SafeMathUint8 for uint8;
1577 
1578     // payment addresses by requestId (optional). We separate the Identity of the payee/payer (in the core) and the wallet address in the currency contract
1579     mapping(bytes32 => address[256]) public payeesPaymentAddress;
1580     mapping(bytes32 => address) public payerRefundAddress;
1581 
1582     // token address
1583     ERC20OMGLike public erc20Token;
1584 
1585     /**
1586      * @param _requestCoreAddress Request Core address
1587      * @param _requestBurnerAddress Request Burner contract address
1588      * @param _erc20Token ERC20 token contract handled by this currency contract
1589      */
1590     constructor (address _requestCoreAddress, address _requestBurnerAddress, ERC20OMGLike _erc20Token) 
1591         CurrencyContract(_requestCoreAddress, _requestBurnerAddress)
1592         public
1593     {
1594         erc20Token = _erc20Token;
1595     }
1596 
1597     /**
1598      * @notice Function to create a request as payee.
1599      *
1600      * @dev msg.sender must be the main payee.
1601      * @dev if _payeesPaymentAddress.length > _payeesIdAddress.length, the extra addresses will be stored but never used.
1602      *
1603      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1604      * @param _payeesPaymentAddress array of payees address for payment (optional)
1605      * @param _expectedAmounts array of Expected amount to be received by each payees
1606      * @param _payer Entity expected to pay
1607      * @param _payerRefundAddress Address of refund for the payer (optional)
1608      * @param _data Hash linking to additional data on the Request stored on IPFS
1609      *
1610      * @return Returns the id of the request
1611      */
1612     function createRequestAsPayeeAction(
1613         address[] 	_payeesIdAddress,
1614         address[] 	_payeesPaymentAddress,
1615         int256[] 	_expectedAmounts,
1616         address 	_payer,
1617         address 	_payerRefundAddress,
1618         string 		_data)
1619         external
1620         payable
1621         whenNotPaused
1622         returns(bytes32 requestId)
1623     {
1624         require(
1625             msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0,
1626             "caller should be the payee"
1627         );
1628 
1629         uint256 collectedFees;
1630         (requestId, collectedFees) = createCoreRequestInternal(
1631             _payer,
1632             _payeesIdAddress,
1633             _expectedAmounts,
1634             _data
1635         );
1636         
1637         // Additional check on the fees: they should be equal to the about of ETH sent
1638         require(collectedFees == msg.value, "fees should be the correct amout");
1639 
1640         // set payment addresses for payees
1641         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1642             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1643         }
1644         // set payment address for payer
1645         if (_payerRefundAddress != 0) {
1646             payerRefundAddress[requestId] = _payerRefundAddress;
1647         }
1648 
1649         return requestId;
1650     }
1651 
1652     /**
1653      * @notice Function to broadcast and accept an offchain signed request (the broadcaster can also pays and makes additionals).
1654      *
1655      * @dev msg.sender will be the _payer.
1656      * @dev only the _payer can make additionals.
1657      * @dev if _payeesPaymentAddress.length > _requestData.payeesIdAddress.length, the extra addresses will be stored but never used.
1658      *
1659      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1660      * @param _payeesPaymentAddress array of payees address for payment (optional) 
1661      * @param _payeeAmounts array of amount repartition for the payment
1662      * @param _additionals array to increase the ExpectedAmount for payees
1663      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1664      * @param _signature ECDSA signature in bytes
1665      *
1666      * @return Returns the id of the request
1667      */
1668     function broadcastSignedRequestAsPayerAction(
1669         bytes 		_requestData, // gather data to avoid "stack too deep"
1670         address[] 	_payeesPaymentAddress,
1671         uint256[] 	_payeeAmounts,
1672         uint256[] 	_additionals,
1673         uint256 	_expirationDate,
1674         bytes 		_signature)
1675         external
1676         payable
1677         whenNotPaused
1678         returns(bytes32 requestId)
1679     {
1680         // check expiration date
1681         // solium-disable-next-line security/no-block-members
1682         require(_expirationDate >= block.timestamp, "expiration should be after current time");
1683 
1684         // check the signature
1685         require(
1686             Signature.checkRequestSignature(
1687                 _requestData,
1688                 _payeesPaymentAddress,
1689                 _expirationDate,
1690                 _signature
1691             ),
1692             "signature should be correct"
1693         );
1694 
1695         return createAcceptAndPayFromBytes(
1696             _requestData,
1697             _payeesPaymentAddress,
1698             _payeeAmounts,
1699             _additionals
1700         );
1701     }
1702 
1703     /**
1704      * @notice Function to pay a request in ERC20 token.
1705      *
1706      * @dev msg.sender must have a balance of the token higher or equal to the sum of _payeeAmounts.
1707      * @dev msg.sender must have approved an amount of the token higher or equal to the sum of _payeeAmounts to the current contract.
1708      * @dev the request will be automatically accepted if msg.sender==payer. 
1709      *
1710      * @param _requestId id of the request
1711      * @param _payeeAmounts Amount to pay to payees (sum must be equal to msg.value) in wei
1712      * @param _additionalAmounts amount of additionals per payee in wei to declare
1713      */
1714     function paymentAction(
1715         bytes32 _requestId,
1716         uint256[] _payeeAmounts,
1717         uint256[] _additionalAmounts)
1718         external
1719         whenNotPaused
1720     {
1721         // automatically accept request if request is created and msg.sender is payer
1722         if (requestCore.getState(_requestId)==RequestCore.State.Created && msg.sender == requestCore.getPayer(_requestId)) {
1723             acceptAction(_requestId);
1724         }
1725 
1726         if (_additionalAmounts.length != 0) {
1727             additionalAction(_requestId, _additionalAmounts);
1728         }
1729 
1730         paymentInternal(_requestId, _payeeAmounts);
1731     }
1732 
1733     /**
1734      * @notice Function to pay back in ERC20 token a request to the payees.
1735      *
1736      * @dev msg.sender must have a balance of the token higher or equal to _amountToRefund.
1737      * @dev msg.sender must have approved an amount of the token higher or equal to _amountToRefund to the current contract.
1738      * @dev msg.sender must be one of the payees or one of the payees payment address.
1739      * @dev the request must be created or accepted.
1740      *
1741      * @param _requestId id of the request
1742      */
1743     function refundAction(bytes32 _requestId, uint256 _amountToRefund)
1744         external
1745         whenNotPaused
1746     {
1747         refundInternal(_requestId, msg.sender, _amountToRefund);
1748     }
1749 
1750     /**
1751      * @notice Function to create a request as payer. The request is payed if _payeeAmounts > 0.
1752      *
1753      * @dev msg.sender will be the payer.
1754      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1755      * @dev Is public instead of external to avoid "Stack too deep" exception.
1756      *
1757      * @param _payeesIdAddress array of payees address (the index 0 will be the payee the others are subPayees)
1758      * @param _expectedAmounts array of Expected amount to be received by each payees
1759      * @param _payerRefundAddress Address of refund for the payer (optional)
1760      * @param _payeeAmounts array of amount repartition for the payment
1761      * @param _additionals array to increase the ExpectedAmount for payees
1762      * @param _data Hash linking to additional data on the Request stored on IPFS
1763      *
1764      * @return Returns the id of the request
1765      */
1766     function createRequestAsPayerAction(
1767         address[] 	_payeesIdAddress,
1768         int256[] 	_expectedAmounts,
1769         address 	_payerRefundAddress,
1770         uint256[] 	_payeeAmounts,
1771         uint256[] 	_additionals,
1772         string 		_data)
1773         public
1774         payable
1775         whenNotPaused
1776         returns(bytes32 requestId)
1777     {
1778         require(msg.sender != _payeesIdAddress[0] && _payeesIdAddress[0] != 0, "caller should not be the main payee");
1779 
1780         uint256 collectedFees;
1781         (requestId, collectedFees) = createCoreRequestInternal(
1782             msg.sender,
1783             _payeesIdAddress,
1784             _expectedAmounts,
1785             _data
1786         );
1787 
1788         // Additional check on the fees: they should be equal to the about of ETH sent
1789         require(collectedFees == msg.value, "fees should be the correct amout");
1790 
1791         // set payment address for payer
1792         if (_payerRefundAddress != 0) {
1793             payerRefundAddress[requestId] = _payerRefundAddress;
1794         }
1795         
1796         // compute the total expected amount of the request
1797         // this computation is also made in createCoreRequestInternal but we do it again here to have better decoupling
1798         int256 totalExpectedAmounts = 0;
1799         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1)) {
1800             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1801         }
1802 
1803         // accept and pay the request with the value remaining after the fee collect
1804         acceptAndPay(
1805             requestId,
1806             _payeeAmounts,
1807             _additionals,
1808             totalExpectedAmounts
1809         );
1810 
1811         return requestId;
1812     }
1813 
1814     /**
1815      * @dev Internal function to create, accept, add additionals and pay a request as Payer.
1816      *
1817      * @dev msg.sender must be _payer.
1818      *
1819      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1820      * @param _payeesPaymentAddress array of payees address for payment (optional)
1821      * @param _payeeAmounts array of amount repartition for the payment
1822      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1823      *
1824      * @return Returns the id of the request
1825      */
1826     function createAcceptAndPayFromBytes(
1827         bytes 		_requestData,
1828         address[] 	_payeesPaymentAddress,
1829         uint256[] 	_payeeAmounts,
1830         uint256[] 	_additionals)
1831         internal
1832         returns(bytes32 requestId)
1833     {
1834         // extract main payee
1835         address mainPayee = Bytes.extractAddress(_requestData, 41);
1836         require(msg.sender != mainPayee && mainPayee != 0, "caller should not be the main payee");
1837 
1838         // creator must be the main payee
1839         require(Bytes.extractAddress(_requestData, 0) == mainPayee, "creator should be the main payee");
1840 
1841         // extract the number of payees
1842         uint8 payeesCount = uint8(_requestData[40]);
1843         int256 totalExpectedAmounts = 0;
1844         for (uint8 i = 0; i < payeesCount; i++) {
1845             // extract the expectedAmount for the payee[i]
1846             int256 expectedAmountTemp = int256(Bytes.extractBytes32(_requestData, uint256(i).mul(52).add(61)));
1847             
1848             // compute the total expected amount of the request
1849             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1850             
1851             // all expected amount must be positive
1852             require(expectedAmountTemp > 0, "expected amount should be > 0");
1853         }
1854 
1855         // compute and send fees
1856         uint256 fees = collectEstimation(totalExpectedAmounts);
1857         require(fees == msg.value, "fees should be the correct amout");
1858         collectForREQBurning(fees);
1859 
1860         // insert the msg.sender as the payer in the bytes
1861         Bytes.updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1862         // store request in the core
1863         requestId = requestCore.createRequestFromBytes(_requestData);
1864         
1865         // set payment addresses for payees
1866         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1867             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1868         }
1869 
1870         // accept and pay the request with the value remaining after the fee collect
1871         acceptAndPay(
1872             requestId,
1873             _payeeAmounts,
1874             _additionals,
1875             totalExpectedAmounts
1876         );
1877 
1878         return requestId;
1879     }
1880 
1881     /**
1882      * @dev Internal function to manage payment declaration.
1883      *
1884      * @param _requestId id of the request
1885      * @param _payeeAmounts Amount to pay to payees (sum must be equals to msg.value)
1886      */
1887     function paymentInternal(
1888         bytes32 	_requestId,
1889         uint256[] 	_payeeAmounts)
1890         internal
1891     {
1892         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1893 
1894         // we cannot have more amounts declared than actual payees
1895         require(
1896             _payeeAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1897             "number of amounts should be <= number of payees"
1898         );
1899 
1900         for (uint8 i = 0; i < _payeeAmounts.length; i = i.add(1)) {
1901             if (_payeeAmounts[i] != 0) {
1902                 // Store and declare the payment to the core
1903                 requestCore.updateBalance(_requestId, i, _payeeAmounts[i].toInt256Safe());
1904 
1905                 // pay the payment address if given, the id address otherwise
1906                 address addressToPay;
1907                 if (payeesPaymentAddress[_requestId][i] == 0) {
1908                     addressToPay = requestCore.getPayeeAddress(_requestId, i);
1909                 } else {
1910                     addressToPay = payeesPaymentAddress[_requestId][i];
1911                 }
1912 
1913                 // payment done, the token need to be sent
1914                 fundOrderInternal(msg.sender, addressToPay, _payeeAmounts[i]);
1915             }
1916         }
1917     }
1918 
1919     /**
1920      * @dev Internal function to accept, add additionals and pay a request as Payer
1921      *
1922      * @param _requestId id of the request
1923      * @param _payeeAmounts Amount to pay to payees (sum must be equals to _amountPaid)
1924      * @param _additionals Will increase the ExpectedAmounts of payees
1925      * @param _payeeAmountsSum total of amount token send for this transaction
1926      *
1927      */	
1928     function acceptAndPay(
1929         bytes32 _requestId,
1930         uint256[] _payeeAmounts,
1931         uint256[] _additionals,
1932         int256 _payeeAmountsSum)
1933         internal
1934     {
1935         acceptAction(_requestId);
1936         
1937         additionalAction(_requestId, _additionals);
1938 
1939         if (_payeeAmountsSum > 0) {
1940             paymentInternal(_requestId, _payeeAmounts);
1941         }
1942     }
1943 
1944     /**
1945      * @dev Internal function to manage refund declaration
1946      *
1947      * @param _requestId id of the request
1948      * @param _address address from where the refund has been done
1949      * @param _amount amount of the refund in ERC20 token to declare
1950      */
1951     function refundInternal(
1952         bytes32 _requestId,
1953         address _address,
1954         uint256 _amount)
1955         internal
1956     {
1957         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1958 
1959         // Check if the _address is a payeesId
1960         int16 payeeIndex = requestCore.getPayeeIndex(_requestId, _address);
1961 
1962         // get the number of payees
1963         uint8 payeesCount = requestCore.getSubPayeesCount(_requestId).add(1);
1964 
1965         if (payeeIndex < 0) {
1966             // if not ID addresses maybe in the payee payments addresses
1967             for (uint8 i = 0; i < payeesCount && payeeIndex == -1; i = i.add(1)) {
1968                 if (payeesPaymentAddress[_requestId][i] == _address) {
1969                     // get the payeeIndex
1970                     payeeIndex = int16(i);
1971                 }
1972             }
1973         }
1974         // the address must be found somewhere
1975         require(payeeIndex >= 0, "fromAddress should be a payee"); 
1976 
1977         // useless (subPayee size <256): require(payeeIndex < 265);
1978         requestCore.updateBalance(_requestId, uint8(payeeIndex), -_amount.toInt256Safe());
1979 
1980         // refund to the payment address if given, the id address otherwise
1981         address addressToPay = payerRefundAddress[_requestId];
1982         if (addressToPay == 0) {
1983             addressToPay = requestCore.getPayer(_requestId);
1984         }
1985 
1986         // refund declared, the money is ready to be sent to the payer
1987         fundOrderInternal(_address, addressToPay, _amount);
1988     }
1989 
1990     /**
1991      * @dev Internal function to manage fund mouvement.
1992      *
1993      * @param _from address where the token will get from
1994      * @param _recipient address where the token has to be sent to
1995      * @param _amount amount in ERC20 token to send
1996      */
1997     function fundOrderInternal(
1998         address _from,
1999         address _recipient,
2000         uint256 _amount)
2001         internal
2002     {	
2003         erc20Token.transferFrom(_from, _recipient, _amount);
2004     }
2005 }