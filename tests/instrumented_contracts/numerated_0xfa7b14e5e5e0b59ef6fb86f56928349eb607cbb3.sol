1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * @dev SafeMath adapted for uint96
7  */
8 library SafeMathUint96 {
9   function mul(uint96 a, uint96 b) internal pure returns (uint96) {
10     uint96 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint96 a, uint96 b) internal pure returns (uint96) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint96 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint96 a, uint96 b) internal pure returns (uint96) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint96 a, uint96 b) internal pure returns (uint96) {
28     uint96 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  * @dev SafeMath adapted for uint8
38  */
39 library SafeMathUint8 {
40   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
41     uint8 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint8 a, uint8 b) internal pure returns (uint8) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint8 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint8 a, uint8 b) internal pure returns (uint8) {
59     uint8 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 /**
67  * @title SafeMathInt
68  * @dev Math operations with safety checks that throw on error
69  * @dev SafeMath adapted for int256
70  */
71 library SafeMathInt {
72   function mul(int256 a, int256 b) internal pure returns (int256) {
73     // Prevent overflow when multiplying INT256_MIN with -1
74     // https://github.com/RequestNetwork/requestNetwork/issues/43
75     assert(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
76 
77     int256 c = a * b;
78     assert((b == 0) || (c / b == a));
79     return c;
80   }
81 
82   function div(int256 a, int256 b) internal pure returns (int256) {
83     // Prevent overflow when dividing INT256_MIN by -1
84     // https://github.com/RequestNetwork/requestNetwork/issues/43
85     assert(!(a == - 2**255 && b == -1));
86 
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     int256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(int256 a, int256 b) internal pure returns (int256) {
94     assert((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
95 
96     return a - b;
97   }
98 
99   function add(int256 a, int256 b) internal pure returns (int256) {
100     int256 c = a + b;
101     assert((b >= 0 && c >= a) || (b < 0 && c < a));
102     return c;
103   }
104 
105   function toUint256Safe(int256 a) internal pure returns (uint256) {
106     assert(a>=0);
107     return uint256(a);
108   }
109 }
110 
111 // From https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
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
238 /**
239  * @title Request Signature util library.
240  * @notice Collection of utility functions to handle Request signatures.
241  */
242 library Signature {
243     using SafeMath for uint256;
244     using SafeMathInt for int256;
245     using SafeMathUint8 for uint8;
246 
247     /**
248      * @notice Checks the validity of a signed request & the expiration date.
249      * @param requestData bytes containing all the data packed :
250             address(creator)
251             address(payer)
252             uint8(number_of_payees)
253             [
254                 address(main_payee_address)
255                 int256(main_payee_expected_amount)
256                 address(second_payee_address)
257                 int256(second_payee_expected_amount)
258                 ...
259             ]
260             uint8(data_string_size)
261             size(data)
262      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
263      * @param expirationDate timestamp after that the signed request cannot be broadcasted
264      * @param signature ECDSA signature containing v, r and s as bytes
265      *
266      * @return Validity of order signature.
267      */	
268     function checkRequestSignature(
269         bytes 		requestData,
270         address[] 	payeesPaymentAddress,
271         uint256 	expirationDate,
272         bytes 		signature)
273         internal
274         view
275         returns (bool)
276     {
277         bytes32 hash = getRequestHash(requestData, payeesPaymentAddress, expirationDate);
278 
279         // extract "v, r, s" from the signature
280         uint8 v = uint8(signature[64]);
281         v = v < 27 ? v.add(27) : v;
282         bytes32 r = Bytes.extractBytes32(signature, 0);
283         bytes32 s = Bytes.extractBytes32(signature, 32);
284 
285         // check signature of the hash with the creator address
286         return isValidSignature(
287             Bytes.extractAddress(requestData, 0),
288             hash,
289             v,
290             r,
291             s
292         );
293     }
294 
295     /**
296      * @notice Checks the validity of a Bitcoin signed request & the expiration date.
297      * @param requestData bytes containing all the data packed :
298             address(creator)
299             address(payer)
300             uint8(number_of_payees)
301             [
302                 address(main_payee_address)
303                 int256(main_payee_expected_amount)
304                 address(second_payee_address)
305                 int256(second_payee_expected_amount)
306                 ...
307             ]
308             uint8(data_string_size)
309             size(data)
310      * @param payeesPaymentAddress array of payees payment addresses (the index 0 will be the payee the others are subPayees)
311      * @param expirationDate timestamp after that the signed request cannot be broadcasted
312      * @param signature ECDSA signature containing v, r and s as bytes
313      *
314      * @return Validity of order signature.
315      */	
316     function checkBtcRequestSignature(
317         bytes 		requestData,
318         bytes 	    payeesPaymentAddress,
319         uint256 	expirationDate,
320         bytes 		signature)
321         internal
322         view
323         returns (bool)
324     {
325         bytes32 hash = getBtcRequestHash(requestData, payeesPaymentAddress, expirationDate);
326 
327         // extract "v, r, s" from the signature
328         uint8 v = uint8(signature[64]);
329         v = v < 27 ? v.add(27) : v;
330         bytes32 r = Bytes.extractBytes32(signature, 0);
331         bytes32 s = Bytes.extractBytes32(signature, 32);
332 
333         // check signature of the hash with the creator address
334         return isValidSignature(
335             Bytes.extractAddress(requestData, 0),
336             hash,
337             v,
338             r,
339             s
340         );
341     }
342     
343     /**
344      * @notice Calculates the Keccak-256 hash of a BTC request with specified parameters.
345      *
346      * @param requestData bytes containing all the data packed
347      * @param payeesPaymentAddress array of payees payment addresses
348      * @param expirationDate timestamp after what the signed request cannot be broadcasted
349      *
350      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
351      */
352     function getBtcRequestHash(
353         bytes 		requestData,
354         bytes 	payeesPaymentAddress,
355         uint256 	expirationDate)
356         private
357         view
358         returns(bytes32)
359     {
360         return keccak256(
361             abi.encodePacked(
362                 this,
363                 requestData,
364                 payeesPaymentAddress,
365                 expirationDate
366             )
367         );
368     }
369 
370     /**
371      * @dev Calculates the Keccak-256 hash of a (not BTC) request with specified parameters.
372      *
373      * @param requestData bytes containing all the data packed
374      * @param payeesPaymentAddress array of payees payment addresses
375      * @param expirationDate timestamp after what the signed request cannot be broadcasted
376      *
377      * @return Keccak-256 hash of (this, requestData, payeesPaymentAddress, expirationDate)
378      */
379     function getRequestHash(
380         bytes 		requestData,
381         address[] 	payeesPaymentAddress,
382         uint256 	expirationDate)
383         private
384         view
385         returns(bytes32)
386     {
387         return keccak256(
388             abi.encodePacked(
389                 this,
390                 requestData,
391                 payeesPaymentAddress,
392                 expirationDate
393             )
394         );
395     }
396     
397     /**
398      * @notice Verifies that a hash signature is valid. 0x style.
399      * @param signer address of signer.
400      * @param hash Signed Keccak-256 hash.
401      * @param v ECDSA signature parameter v.
402      * @param r ECDSA signature parameters r.
403      * @param s ECDSA signature parameters s.
404      * @return Validity of order signature.
405      */
406     function isValidSignature(
407         address signer,
408         bytes32 hash,
409         uint8 	v,
410         bytes32 r,
411         bytes32 s)
412         private
413         pure
414         returns (bool)
415     {
416         return signer == ecrecover(
417             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
418             v,
419             r,
420             s
421         );
422     }
423 }
424 
425 /**
426  * @title ERC20Basic
427  * @dev Simpler version of ERC20 interface
428  * @dev see https://github.com/ethereum/EIPs/issues/179
429  */
430 contract ERC20Basic {
431   uint256 public totalSupply;
432   function balanceOf(address who) public constant returns (uint256);
433   function transfer(address to, uint256 value) public returns (bool);
434   event Transfer(address indexed from, address indexed to, uint256 value);
435 }
436 
437 
438 /**
439  * @title ERC20 interface
440  * @dev see https://github.com/ethereum/EIPs/issues/20
441  */
442 contract ERC20 is ERC20Basic {
443   function allowance(address owner, address spender) public constant returns (uint256);
444   function transferFrom(address from, address to, uint256 value) public returns (bool);
445   function approve(address spender, uint256 value) public returns (bool);
446   event Approval(address indexed owner, address indexed spender, uint256 value);
447 }
448 
449 
450 /**
451  * @title Ownable
452  * @dev The Ownable contract has an owner address, and provides basic authorization control
453  * functions, this simplifies the implementation of "user permissions".
454  */
455 contract Ownable {
456   address public owner;
457 
458 
459   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
460 
461 
462   /**
463    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
464    * account.
465    */
466   function Ownable() public {
467     owner = msg.sender;
468   }
469 
470 
471   /**
472    * @dev Throws if called by any account other than the owner.
473    */
474   modifier onlyOwner() {
475     require(msg.sender == owner);
476     _;
477   }
478 
479 
480   /**
481    * @dev Allows the current owner to transfer control of the contract to a newOwner.
482    * @param newOwner The address to transfer ownership to.
483    */
484   function transferOwnership(address newOwner) onlyOwner public {
485     require(newOwner != address(0));
486     OwnershipTransferred(owner, newOwner);
487     owner = newOwner;
488   }
489 
490 }
491 
492 
493 /**
494  * @title FeeCollector
495  *
496  * @notice FeeCollector is a contract managing the fees for currency contracts
497  */
498 contract FeeCollector is Ownable {
499     using SafeMath for uint256;
500 
501     uint256 public rateFeesNumerator;
502     uint256 public rateFeesDenominator;
503     uint256 public maxFees;
504 
505     // address of the contract that will burn req token
506     address public requestBurnerContract;
507 
508     event UpdateRateFees(uint256 rateFeesNumerator, uint256 rateFeesDenominator);
509     event UpdateMaxFees(uint256 maxFees);
510 
511     /**
512      * @param _requestBurnerContract Address of the contract where to send the ether.
513      * This burner contract will have a function that can be called by anyone and will exchange ether to req via Kyber and burn the REQ
514      */  
515     constructor(address _requestBurnerContract) 
516         public
517     {
518         requestBurnerContract = _requestBurnerContract;
519     }
520 
521     /**
522      * @notice Sets the fees rate.
523      * @dev if the _rateFeesDenominator is 0, it will be treated as 1. (in other words, the computation of the fees will not use it)
524      * @param _rateFeesNumerator 		numerator rate
525      * @param _rateFeesDenominator 		denominator rate
526      */  
527     function setRateFees(uint256 _rateFeesNumerator, uint256 _rateFeesDenominator)
528         external
529         onlyOwner
530     {
531         rateFeesNumerator = _rateFeesNumerator;
532         rateFeesDenominator = _rateFeesDenominator;
533         emit UpdateRateFees(rateFeesNumerator, rateFeesDenominator);
534     }
535 
536     /**
537      * @notice Sets the maximum fees in wei.
538      * @param _newMaxFees new max
539      */  
540     function setMaxCollectable(uint256 _newMaxFees) 
541         external
542         onlyOwner
543     {
544         maxFees = _newMaxFees;
545         emit UpdateMaxFees(maxFees);
546     }
547 
548     /**
549      * @notice Set the request burner address.
550      * @param _requestBurnerContract address of the contract that will burn req token (probably through Kyber)
551      */  
552     function setRequestBurnerContract(address _requestBurnerContract) 
553         external
554         onlyOwner
555     {
556         requestBurnerContract = _requestBurnerContract;
557     }
558 
559     /**
560      * @notice Computes the fees.
561      * @param _expectedAmount amount expected for the request
562      * @return the expected amount of fees in wei
563      */  
564     function collectEstimation(int256 _expectedAmount)
565         public
566         view
567         returns(uint256)
568     {
569         if (_expectedAmount<0) {
570             return 0;
571         }
572 
573         uint256 computedCollect = uint256(_expectedAmount).mul(rateFeesNumerator);
574 
575         if (rateFeesDenominator != 0) {
576             computedCollect = computedCollect.div(rateFeesDenominator);
577         }
578 
579         return computedCollect < maxFees ? computedCollect : maxFees;
580     }
581 
582     /**
583      * @notice Sends fees to the request burning address.
584      * @param _amount amount to send to the burning address
585      */  
586     function collectForREQBurning(uint256 _amount)
587         internal
588     {
589         // .transfer throws on failure
590         requestBurnerContract.transfer(_amount);
591     }
592 }
593 
594 
595 
596 
597 
598 
599 /**
600  * @title Pausable
601  * @dev Base contract which allows children to implement an emergency stop mechanism.
602  */
603 contract Pausable is Ownable {
604     event Pause();
605     event Unpause();
606 
607     bool public paused = false;
608 
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is not paused.
612      */
613     modifier whenNotPaused() {
614         require(!paused);
615         _;
616     }
617 
618     /**
619      * @dev Modifier to make a function callable only when the contract is paused.
620      */
621     modifier whenPaused() {
622         require(paused);
623         _;
624     }
625 
626     /**
627      * @dev called by the owner to pause, triggers stopped state
628      */
629     function pause() onlyOwner whenNotPaused public {
630         paused = true;
631         Pause();
632     }
633 
634     /**
635      * @dev called by the owner to unpause, returns to normal state
636      */
637     function unpause() onlyOwner whenPaused public {
638         paused = false;
639         Unpause();
640     }
641 }
642 
643 
644 
645 /**
646  * @title Administrable
647  * @notice Base contract for the administration of Core. Handles whitelisting of currency contracts
648  */
649 contract Administrable is Pausable {
650 
651     // mapping of address of trusted contract
652     mapping(address => uint8) public trustedCurrencyContracts;
653 
654     // Events of the system
655     event NewTrustedContract(address newContract);
656     event RemoveTrustedContract(address oldContract);
657 
658     /**
659      * @notice Adds a trusted currencyContract.
660      *
661      * @param _newContractAddress The address of the currencyContract
662      */
663     function adminAddTrustedCurrencyContract(address _newContractAddress)
664         external
665         onlyOwner
666     {
667         trustedCurrencyContracts[_newContractAddress] = 1; //Using int instead of boolean in case we need several states in the future.
668         emit NewTrustedContract(_newContractAddress);
669     }
670 
671     /**
672      * @notice Removes a trusted currencyContract.
673      *
674      * @param _oldTrustedContractAddress The address of the currencyContract
675      */
676     function adminRemoveTrustedCurrencyContract(address _oldTrustedContractAddress)
677         external
678         onlyOwner
679     {
680         require(trustedCurrencyContracts[_oldTrustedContractAddress] != 0, "_oldTrustedContractAddress should not be 0");
681         trustedCurrencyContracts[_oldTrustedContractAddress] = 0;
682         emit RemoveTrustedContract(_oldTrustedContractAddress);
683     }
684 
685     /**
686      * @notice Gets the status of a trusted currencyContract .
687      * @dev Not used today, useful if we have several states in the future.
688      *
689      * @param _contractAddress The address of the currencyContract
690      * @return The status of the currencyContract. If trusted 1, otherwise 0
691      */
692     function getStatusContract(address _contractAddress)
693         external
694         view
695         returns(uint8) 
696     {
697         return trustedCurrencyContracts[_contractAddress];
698     }
699 
700     /**
701      * @notice Checks if a currencyContract is trusted.
702      *
703      * @param _contractAddress The address of the currencyContract
704      * @return bool true if contract is trusted
705      */
706     function isTrustedContract(address _contractAddress)
707         public
708         view
709         returns(bool)
710     {
711         return trustedCurrencyContracts[_contractAddress] == 1;
712     }
713 }
714 
715 
716 /**
717  * @title RequestCore
718  *
719  * @notice The Core is the main contract which stores all the requests.
720  *
721  * @dev The Core philosophy is to be as much flexible as possible to adapt in the future to any new system
722  * @dev All the important conditions and an important part of the business logic takes place in the currency contracts.
723  * @dev Requests can only be created in the currency contracts
724  * @dev Currency contracts have to be allowed by the Core and respect the business logic.
725  * @dev Request Network will develop one currency contracts per currency and anyone can creates its own currency contracts.
726  */
727 contract RequestCore is Administrable {
728     using SafeMath for uint256;
729     using SafeMathUint96 for uint96;
730     using SafeMathInt for int256;
731     using SafeMathUint8 for uint8;
732 
733     enum State { Created, Accepted, Canceled }
734 
735     struct Request {
736         // ID address of the payer
737         address payer;
738 
739         // Address of the contract managing the request
740         address currencyContract;
741 
742         // State of the request
743         State state;
744 
745         // Main payee
746         Payee payee;
747     }
748 
749     // Structure for the payees. A sub payee is an additional entity which will be paid during the processing of the invoice.
750     // ex: can be used for routing taxes or fees at the moment of the payment.
751     struct Payee {
752         // ID address of the payee
753         address addr;
754 
755         // amount expected for the payee. 
756         // Not uint for evolution (may need negative amounts one day), and simpler operations
757         int256 expectedAmount;
758 
759         // balance of the payee
760         int256 balance;
761     }
762 
763     // Count of request in the mapping. A maximum of 2^96 requests can be created per Core contract.
764     // Integer, incremented for each request of a Core contract, starting from 0
765     // RequestId (256bits) = contract address (160bits) + numRequest
766     uint96 public numRequests; 
767     
768     // Mapping of all the Requests. The key is the request ID.
769     // not anymore public to avoid "UnimplementedFeatureError: Only in-memory reference type can be stored."
770     // https://github.com/ethereum/solidity/issues/3577
771     mapping(bytes32 => Request) requests;
772 
773     // Mapping of subPayees of the requests. The key is the request ID.
774     // This array is outside the Request structure to optimize the gas cost when there is only 1 payee.
775     mapping(bytes32 => Payee[256]) public subPayees;
776 
777     /*
778      *  Events 
779      */
780     event Created(bytes32 indexed requestId, address indexed payee, address indexed payer, address creator, string data);
781     event Accepted(bytes32 indexed requestId);
782     event Canceled(bytes32 indexed requestId);
783 
784     // Event for Payee & subPayees
785     // Separated from the Created Event to allow a 4th indexed parameter (subpayees)
786     event NewSubPayee(bytes32 indexed requestId, address indexed payee); 
787     event UpdateExpectedAmount(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
788     event UpdateBalance(bytes32 indexed requestId, uint8 payeeIndex, int256 deltaAmount);
789 
790     /**
791      * @notice Function used by currency contracts to create a request in the Core.
792      *
793      * @dev _payees and _expectedAmounts must have the same size.
794      *
795      * @param _creator Request creator. The creator is the one who initiated the request (create or sign) and not necessarily the one who broadcasted it
796      * @param _payees array of payees address (the index 0 will be the payee the others are subPayees). Size must be smaller than 256.
797      * @param _expectedAmounts array of Expected amount to be received by each payees. Must be in same order than the payees. Size must be smaller than 256.
798      * @param _payer Entity expected to pay
799      * @param _data data of the request
800      * @return Returns the id of the request
801      */
802     function createRequest(
803         address     _creator,
804         address[]   _payees,
805         int256[]    _expectedAmounts,
806         address     _payer,
807         string      _data)
808         external
809         whenNotPaused 
810         returns (bytes32 requestId) 
811     {
812         // creator must not be null
813         require(_creator != 0, "creator should not be 0"); // not as modifier to lighten the stack
814         // call must come from a trusted contract
815         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
816 
817         // Generate the requestId
818         requestId = generateRequestId();
819 
820         address mainPayee;
821         int256 mainExpectedAmount;
822         // extract the main payee if filled
823         if (_payees.length!=0) {
824             mainPayee = _payees[0];
825             mainExpectedAmount = _expectedAmounts[0];
826         }
827 
828         // Store the new request
829         requests[requestId] = Request(
830             _payer,
831             msg.sender,
832             State.Created,
833             Payee(
834                 mainPayee,
835                 mainExpectedAmount,
836                 0
837             )
838         );
839 
840         // Declare the new request
841         emit Created(
842             requestId,
843             mainPayee,
844             _payer,
845             _creator,
846             _data
847         );
848         
849         // Store and declare the sub payees (needed in internal function to avoid "stack too deep")
850         initSubPayees(requestId, _payees, _expectedAmounts);
851 
852         return requestId;
853     }
854 
855     /**
856      * @notice Function used by currency contracts to create a request in the Core from bytes.
857      * @dev Used to avoid receiving a stack too deep error when called from a currency contract with too many parameters.
858      * @dev Note that to optimize the stack size and the gas cost we do not extract the params and store them in the stack. As a result there is some code redundancy
859      * @param _data bytes containing all the data packed :
860             address(creator)
861             address(payer)
862             uint8(number_of_payees)
863             [
864                 address(main_payee_address)
865                 int256(main_payee_expected_amount)
866                 address(second_payee_address)
867                 int256(second_payee_expected_amount)
868                 ...
869             ]
870             uint8(data_string_size)
871             size(data)
872      * @return Returns the id of the request 
873      */ 
874     function createRequestFromBytes(bytes _data) 
875         external
876         whenNotPaused 
877         returns (bytes32 requestId) 
878     {
879         // call must come from a trusted contract
880         require(isTrustedContract(msg.sender), "caller should be a trusted contract"); // not as modifier to lighten the stack
881 
882         // extract address creator & payer
883         address creator = extractAddress(_data, 0);
884 
885         address payer = extractAddress(_data, 20);
886 
887         // creator must not be null
888         require(creator!=0, "creator should not be 0");
889         
890         // extract the number of payees
891         uint8 payeesCount = uint8(_data[40]);
892 
893         // get the position of the dataSize in the byte (= number_of_payees * (address_payee_size + int256_payee_size) + address_creator_size + address_payer_size + payees_count_size
894         //                                              (= number_of_payees * (20+32) + 20 + 20 + 1 )
895         uint256 offsetDataSize = uint256(payeesCount).mul(52).add(41);
896 
897         // extract the data size and then the data itself
898         uint8 dataSize = uint8(_data[offsetDataSize]);
899         string memory dataStr = extractString(_data, dataSize, offsetDataSize.add(1));
900 
901         address mainPayee;
902         int256 mainExpectedAmount;
903         // extract the main payee if possible
904         if (payeesCount!=0) {
905             mainPayee = extractAddress(_data, 41);
906             mainExpectedAmount = int256(extractBytes32(_data, 61));
907         }
908 
909         // Generate the requestId
910         requestId = generateRequestId();
911 
912         // Store the new request
913         requests[requestId] = Request(
914             payer,
915             msg.sender,
916             State.Created,
917             Payee(
918                 mainPayee,
919                 mainExpectedAmount,
920                 0
921             )
922         );
923 
924         // Declare the new request
925         emit Created(
926             requestId,
927             mainPayee,
928             payer,
929             creator,
930             dataStr
931         );
932 
933         // Store and declare the sub payees
934         for (uint8 i = 1; i < payeesCount; i = i.add(1)) {
935             address subPayeeAddress = extractAddress(_data, uint256(i).mul(52).add(41));
936 
937             // payees address cannot be 0x0
938             require(subPayeeAddress != 0, "subpayee should not be 0");
939 
940             subPayees[requestId][i-1] = Payee(subPayeeAddress, int256(extractBytes32(_data, uint256(i).mul(52).add(61))), 0);
941             emit NewSubPayee(requestId, subPayeeAddress);
942         }
943 
944         return requestId;
945     }
946 
947     /**
948      * @notice Function used by currency contracts to accept a request in the Core.
949      * @dev callable only by the currency contract of the request
950      * @param _requestId Request id
951      */ 
952     function accept(bytes32 _requestId) 
953         external
954     {
955         Request storage r = requests[_requestId];
956         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
957         r.state = State.Accepted;
958         emit Accepted(_requestId);
959     }
960 
961     /**
962      * @notice Function used by currency contracts to cancel a request in the Core. Several reasons can lead to cancel a request, see request life cycle for more info.
963      * @dev callable only by the currency contract of the request.
964      * @param _requestId Request id
965      */ 
966     function cancel(bytes32 _requestId)
967         external
968     {
969         Request storage r = requests[_requestId];
970         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
971         r.state = State.Canceled;
972         emit Canceled(_requestId);
973     }   
974 
975     /**
976      * @notice Function used to update the balance.
977      * @dev callable only by the currency contract of the request.
978      * @param _requestId Request id
979      * @param _payeeIndex index of the payee (0 = main payee)
980      * @param _deltaAmount modifier amount
981      */ 
982     function updateBalance(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
983         external
984     {   
985         Request storage r = requests[_requestId];
986         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request"); 
987 
988         if ( _payeeIndex == 0 ) {
989             // modify the main payee
990             r.payee.balance = r.payee.balance.add(_deltaAmount);
991         } else {
992             // modify the sub payee
993             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
994             sp.balance = sp.balance.add(_deltaAmount);
995         }
996         emit UpdateBalance(_requestId, _payeeIndex, _deltaAmount);
997     }
998 
999     /**
1000      * @notice Function update the expectedAmount adding additional or subtract.
1001      * @dev callable only by the currency contract of the request.
1002      * @param _requestId Request id
1003      * @param _payeeIndex index of the payee (0 = main payee)
1004      * @param _deltaAmount modifier amount
1005      */ 
1006     function updateExpectedAmount(bytes32 _requestId, uint8 _payeeIndex, int256 _deltaAmount)
1007         external
1008     {   
1009         Request storage r = requests[_requestId];
1010         require(r.currencyContract == msg.sender, "caller should be the currency contract of the request");  
1011 
1012         if ( _payeeIndex == 0 ) {
1013             // modify the main payee
1014             r.payee.expectedAmount = r.payee.expectedAmount.add(_deltaAmount);    
1015         } else {
1016             // modify the sub payee
1017             Payee storage sp = subPayees[_requestId][_payeeIndex-1];
1018             sp.expectedAmount = sp.expectedAmount.add(_deltaAmount);
1019         }
1020         emit UpdateExpectedAmount(_requestId, _payeeIndex, _deltaAmount);
1021     }
1022 
1023     /**
1024      * @notice Gets a request.
1025      * @param _requestId Request id
1026      * @return request as a tuple : (address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
1027      */ 
1028     function getRequest(bytes32 _requestId) 
1029         external
1030         view
1031         returns(address payer, address currencyContract, State state, address payeeAddr, int256 payeeExpectedAmount, int256 payeeBalance)
1032     {
1033         Request storage r = requests[_requestId];
1034         return (
1035             r.payer,
1036             r.currencyContract,
1037             r.state,
1038             r.payee.addr,
1039             r.payee.expectedAmount,
1040             r.payee.balance
1041         );
1042     }
1043 
1044     /**
1045      * @notice Gets address of a payee.
1046      * @param _requestId Request id
1047      * @param _payeeIndex payee index (0 = main payee)
1048      * @return payee address
1049      */ 
1050     function getPayeeAddress(bytes32 _requestId, uint8 _payeeIndex)
1051         public
1052         view
1053         returns(address)
1054     {
1055         if (_payeeIndex == 0) {
1056             return requests[_requestId].payee.addr;
1057         } else {
1058             return subPayees[_requestId][_payeeIndex-1].addr;
1059         }
1060     }
1061 
1062     /**
1063      * @notice Gets payer of a request.
1064      * @param _requestId Request id
1065      * @return payer address
1066      */ 
1067     function getPayer(bytes32 _requestId)
1068         public
1069         view
1070         returns(address)
1071     {
1072         return requests[_requestId].payer;
1073     }
1074 
1075     /**
1076      * @notice Gets amount expected of a payee.
1077      * @param _requestId Request id
1078      * @param _payeeIndex payee index (0 = main payee)
1079      * @return amount expected
1080      */     
1081     function getPayeeExpectedAmount(bytes32 _requestId, uint8 _payeeIndex)
1082         public
1083         view
1084         returns(int256)
1085     {
1086         if (_payeeIndex == 0) {
1087             return requests[_requestId].payee.expectedAmount;
1088         } else {
1089             return subPayees[_requestId][_payeeIndex-1].expectedAmount;
1090         }
1091     }
1092 
1093     /**
1094      * @notice Gets number of subPayees for a request.
1095      * @param _requestId Request id
1096      * @return number of subPayees
1097      */     
1098     function getSubPayeesCount(bytes32 _requestId)
1099         public
1100         view
1101         returns(uint8)
1102     {
1103         // solium-disable-next-line no-empty-blocks
1104         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {}
1105         return i;
1106     }
1107 
1108     /**
1109      * @notice Gets currencyContract of a request.
1110      * @param _requestId Request id
1111      * @return currencyContract address
1112      */
1113     function getCurrencyContract(bytes32 _requestId)
1114         public
1115         view
1116         returns(address)
1117     {
1118         return requests[_requestId].currencyContract;
1119     }
1120 
1121     /**
1122      * @notice Gets balance of a payee.
1123      * @param _requestId Request id
1124      * @param _payeeIndex payee index (0 = main payee)
1125      * @return balance
1126      */     
1127     function getPayeeBalance(bytes32 _requestId, uint8 _payeeIndex)
1128         public
1129         view
1130         returns(int256)
1131     {
1132         if (_payeeIndex == 0) {
1133             return requests[_requestId].payee.balance;    
1134         } else {
1135             return subPayees[_requestId][_payeeIndex-1].balance;
1136         }
1137     }
1138 
1139     /**
1140      * @notice Gets balance total of a request.
1141      * @param _requestId Request id
1142      * @return balance
1143      */     
1144     function getBalance(bytes32 _requestId)
1145         public
1146         view
1147         returns(int256)
1148     {
1149         int256 balance = requests[_requestId].payee.balance;
1150 
1151         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1152             balance = balance.add(subPayees[_requestId][i].balance);
1153         }
1154 
1155         return balance;
1156     }
1157 
1158     /**
1159      * @notice Checks if all the payees balances are null.
1160      * @param _requestId Request id
1161      * @return true if all the payees balances are equals to 0
1162      */     
1163     function areAllBalanceNull(bytes32 _requestId)
1164         public
1165         view
1166         returns(bool isNull)
1167     {
1168         isNull = requests[_requestId].payee.balance == 0;
1169 
1170         for (uint8 i = 0; isNull && subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1171             isNull = subPayees[_requestId][i].balance == 0;
1172         }
1173 
1174         return isNull;
1175     }
1176 
1177     /**
1178      * @notice Gets total expectedAmount of a request.
1179      * @param _requestId Request id
1180      * @return balance
1181      */     
1182     function getExpectedAmount(bytes32 _requestId)
1183         public
1184         view
1185         returns(int256)
1186     {
1187         int256 expectedAmount = requests[_requestId].payee.expectedAmount;
1188 
1189         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1190             expectedAmount = expectedAmount.add(subPayees[_requestId][i].expectedAmount);
1191         }
1192 
1193         return expectedAmount;
1194     }
1195 
1196     /**
1197      * @notice Gets state of a request.
1198      * @param _requestId Request id
1199      * @return state
1200      */ 
1201     function getState(bytes32 _requestId)
1202         public
1203         view
1204         returns(State)
1205     {
1206         return requests[_requestId].state;
1207     }
1208 
1209     /**
1210      * @notice Gets address of a payee.
1211      * @param _requestId Request id
1212      * @return payee index (0 = main payee) or -1 if not address not found
1213      */
1214     function getPayeeIndex(bytes32 _requestId, address _address)
1215         public
1216         view
1217         returns(int16)
1218     {
1219         // return 0 if main payee
1220         if (requests[_requestId].payee.addr == _address) {
1221             return 0;
1222         }
1223 
1224         for (uint8 i = 0; subPayees[_requestId][i].addr != address(0); i = i.add(1)) {
1225             if (subPayees[_requestId][i].addr == _address) {
1226                 // if found return subPayee index + 1 (0 is main payee)
1227                 return i+1;
1228             }
1229         }
1230         return -1;
1231     }
1232 
1233     /**
1234      * @notice Extracts a bytes32 from a bytes.
1235      * @param _data bytes from where the bytes32 will be extract
1236      * @param offset position of the first byte of the bytes32
1237      * @return address
1238      */
1239     function extractBytes32(bytes _data, uint offset)
1240         public
1241         pure
1242         returns (bytes32 bs)
1243     {
1244         require(offset >= 0 && offset + 32 <= _data.length, "offset value should be in the correct range");
1245 
1246         // solium-disable-next-line security/no-inline-assembly
1247         assembly {
1248             bs := mload(add(_data, add(32, offset)))
1249         }
1250     }
1251 
1252     /**
1253      * @notice Transfers to owner any tokens send by mistake on this contracts.
1254      * @param token The address of the token to transfer.
1255      * @param amount The amount to be transfered.
1256      */
1257     function emergencyERC20Drain(ERC20 token, uint amount )
1258         public
1259         onlyOwner 
1260     {
1261         token.transfer(owner, amount);
1262     }
1263 
1264     /**
1265      * @notice Extracts an address from a bytes at a given position.
1266      * @param _data bytes from where the address will be extract
1267      * @param offset position of the first byte of the address
1268      * @return address
1269      */
1270     function extractAddress(bytes _data, uint offset)
1271         internal
1272         pure
1273         returns (address m)
1274     {
1275         require(offset >= 0 && offset + 20 <= _data.length, "offset value should be in the correct range");
1276 
1277         // solium-disable-next-line security/no-inline-assembly
1278         assembly {
1279             m := and( mload(add(_data, add(20, offset))), 
1280                       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
1281         }
1282     }
1283     
1284     /**
1285      * @dev Internal: Init payees for a request (needed to avoid 'stack too deep' in createRequest()).
1286      * @param _requestId Request id
1287      * @param _payees array of payees address
1288      * @param _expectedAmounts array of payees initial expected amounts
1289      */ 
1290     function initSubPayees(bytes32 _requestId, address[] _payees, int256[] _expectedAmounts)
1291         internal
1292     {
1293         require(_payees.length == _expectedAmounts.length, "payee length should equal expected amount length");
1294      
1295         for (uint8 i = 1; i < _payees.length; i = i.add(1)) {
1296             // payees address cannot be 0x0
1297             require(_payees[i] != 0, "payee should not be 0");
1298             subPayees[_requestId][i-1] = Payee(_payees[i], _expectedAmounts[i], 0);
1299             emit NewSubPayee(_requestId, _payees[i]);
1300         }
1301     }
1302 
1303     /**
1304      * @notice Extracts a string from a bytes. Extracts a sub-part from tha bytes and convert it to string.
1305      * @param data bytes from where the string will be extracted
1306      * @param size string size to extract
1307      * @param _offset position of the first byte of the string in bytes
1308      * @return string
1309      */ 
1310     function extractString(bytes data, uint8 size, uint _offset) 
1311         internal 
1312         pure 
1313         returns (string) 
1314     {
1315         bytes memory bytesString = new bytes(size);
1316         for (uint j = 0; j < size; j++) {
1317             bytesString[j] = data[_offset+j];
1318         }
1319         return string(bytesString);
1320     }
1321 
1322     /**
1323      * @notice Generates a new unique requestId.
1324      * @return a bytes32 requestId 
1325      */ 
1326     function generateRequestId()
1327         internal
1328         returns (bytes32)
1329     {
1330         // Update numRequest
1331         numRequests = numRequests.add(1);
1332         // requestId = ADDRESS_CONTRACT_CORE + numRequests (0xADRRESSCONTRACT00000NUMREQUEST)
1333         return bytes32((uint256(this) << 96).add(numRequests));
1334     }
1335 }
1336 
1337 
1338 /**
1339  * @title CurrencyContract
1340  *
1341  * @notice CurrencyContract is the base for currency contracts. To add a currency to the Request Protocol, create a new currencyContract that inherits from it.
1342  * @dev If currency contract is whitelisted by core & unpaused: All actions possible
1343  * @dev If currency contract is not Whitelisted by core & unpaused: Creation impossible, other actions possible
1344  * @dev If currency contract is paused: Nothing possible
1345  *
1346  * Functions that can be implemented by the currency contracts:
1347  *  - createRequestAsPayeeAction
1348  *  - createRequestAsPayerAction
1349  *  - broadcastSignedRequestAsPayer
1350  *  - paymentActionPayable
1351  *  - paymentAction
1352  *  - accept
1353  *  - cancel
1354  *  - refundAction
1355  *  - subtractAction
1356  *  - additionalAction
1357  */
1358 contract CurrencyContract is Pausable, FeeCollector {
1359     using SafeMath for uint256;
1360     using SafeMathInt for int256;
1361     using SafeMathUint8 for uint8;
1362 
1363     RequestCore public requestCore;
1364 
1365     /**
1366      * @param _requestCoreAddress Request Core address
1367      */
1368     constructor(address _requestCoreAddress, address _addressBurner) 
1369         FeeCollector(_addressBurner)
1370         public
1371     {
1372         requestCore = RequestCore(_requestCoreAddress);
1373     }
1374 
1375     /**
1376      * @notice Function to accept a request.
1377      *
1378      * @notice msg.sender must be _payer, The request must be in the state CREATED (not CANCELED, not ACCEPTED).
1379      *
1380      * @param _requestId id of the request
1381      */
1382     function acceptAction(bytes32 _requestId)
1383         public
1384         whenNotPaused
1385         onlyRequestPayer(_requestId)
1386     {
1387         // only a created request can be accepted
1388         require(requestCore.getState(_requestId) == RequestCore.State.Created, "request should be created");
1389 
1390         // declare the acceptation in the core
1391         requestCore.accept(_requestId);
1392     }
1393 
1394     /**
1395      * @notice Function to cancel a request.
1396      *
1397      * @dev msg.sender must be the _payer or the _payee.
1398      * @dev only request with balance equals to zero can be cancel.
1399      *
1400      * @param _requestId id of the request
1401      */
1402     function cancelAction(bytes32 _requestId)
1403         public
1404         whenNotPaused
1405     {
1406         // payer can cancel if request is just created
1407         // payee can cancel when request is not canceled yet
1408         require(
1409             // solium-disable-next-line indentation
1410             (requestCore.getPayer(_requestId) == msg.sender && requestCore.getState(_requestId) == RequestCore.State.Created) ||
1411             (requestCore.getPayeeAddress(_requestId,0) == msg.sender && requestCore.getState(_requestId) != RequestCore.State.Canceled),
1412             "payer should cancel a newly created request, or payee should cancel a not cancel request"
1413         );
1414 
1415         // impossible to cancel a Request with any payees balance != 0
1416         require(requestCore.areAllBalanceNull(_requestId), "all balanaces should be = 0 to cancel");
1417 
1418         // declare the cancellation in the core
1419         requestCore.cancel(_requestId);
1420     }
1421 
1422     /**
1423      * @notice Function to declare additionals.
1424      *
1425      * @dev msg.sender must be _payer.
1426      * @dev the request must be accepted or created.
1427      *
1428      * @param _requestId id of the request
1429      * @param _additionalAmounts amounts of additional to declare (index 0 is for main payee)
1430      */
1431     function additionalAction(bytes32 _requestId, uint256[] _additionalAmounts)
1432         public
1433         whenNotPaused
1434         onlyRequestPayer(_requestId)
1435     {
1436 
1437         // impossible to make additional if request is canceled
1438         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1439 
1440         // impossible to declare more additionals than the number of payees
1441         require(
1442             _additionalAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1443             "number of amounts should be <= number of payees"
1444         );
1445 
1446         for (uint8 i = 0; i < _additionalAmounts.length; i = i.add(1)) {
1447             // no need to declare a zero as additional 
1448             if (_additionalAmounts[i] != 0) {
1449                 // Store and declare the additional in the core
1450                 requestCore.updateExpectedAmount(_requestId, i, _additionalAmounts[i].toInt256Safe());
1451             }
1452         }
1453     }
1454 
1455     /**
1456      * @notice Function to declare subtracts.
1457      *
1458      * @dev msg.sender must be _payee.
1459      * @dev the request must be accepted or created.
1460      *
1461      * @param _requestId id of the request
1462      * @param _subtractAmounts amounts of subtract to declare (index 0 is for main payee)
1463      */
1464     function subtractAction(bytes32 _requestId, uint256[] _subtractAmounts)
1465         public
1466         whenNotPaused
1467         onlyRequestPayee(_requestId)
1468     {
1469         // impossible to make subtracts if request is canceled
1470         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1471 
1472         // impossible to declare more subtracts than the number of payees
1473         require(
1474             _subtractAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1475             "number of amounts should be <= number of payees"
1476         );
1477 
1478         for (uint8 i = 0; i < _subtractAmounts.length; i = i.add(1)) {
1479             // no need to declare a zero as subtracts 
1480             if (_subtractAmounts[i] != 0) {
1481                 // subtract must be equal or lower than amount expected
1482                 require(
1483                     requestCore.getPayeeExpectedAmount(_requestId,i) >= _subtractAmounts[i].toInt256Safe(),
1484                     "subtract should equal or be lower than amount expected"
1485                 );
1486 
1487                 // Store and declare the subtract in the core
1488                 requestCore.updateExpectedAmount(_requestId, i, -_subtractAmounts[i].toInt256Safe());
1489             }
1490         }
1491     }
1492 
1493     /**
1494      * @notice Base function for request creation.
1495      *
1496      * @dev msg.sender will be the creator.
1497      *
1498      * @param _payer Entity expected to pay
1499      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1500      * @param _expectedAmounts array of Expected amount to be received by each payees
1501      * @param _data Hash linking to additional data on the Request stored on IPFS
1502      *
1503      * @return Returns the id of the request and the collected fees
1504      */
1505     function createCoreRequestInternal(
1506         address 	_payer,
1507         address[] 	_payeesIdAddress,
1508         int256[] 	_expectedAmounts,
1509         string 		_data)
1510         internal
1511         whenNotPaused
1512         returns(bytes32 requestId, uint256 collectedFees)
1513     {
1514         int256 totalExpectedAmounts = 0;
1515         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1)) {
1516             // all expected amounts must be positive
1517             require(_expectedAmounts[i] >= 0, "expected amounts should be positive");
1518 
1519             // compute the total expected amount of the request
1520             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1521         }
1522 
1523         // store request in the core
1524         requestId = requestCore.createRequest(
1525             msg.sender,
1526             _payeesIdAddress,
1527             _expectedAmounts,
1528             _payer,
1529             _data
1530         );
1531 
1532         // compute and send fees
1533         collectedFees = collectEstimation(totalExpectedAmounts);
1534         collectForREQBurning(collectedFees);
1535     }
1536 
1537     /**
1538      * @notice Modifier to check if msg.sender is the main payee.
1539      * @dev Revert if msg.sender is not the main payee.
1540      * @param _requestId id of the request
1541      */	
1542     modifier onlyRequestPayee(bytes32 _requestId)
1543     {
1544         require(requestCore.getPayeeAddress(_requestId, 0) == msg.sender, "only the payee should do this action");
1545         _;
1546     }
1547 
1548     /**
1549      * @notice Modifier to check if msg.sender is payer.
1550      * @dev Revert if msg.sender is not payer.
1551      * @param _requestId id of the request
1552      */	
1553     modifier onlyRequestPayer(bytes32 _requestId)
1554     {
1555         require(requestCore.getPayer(_requestId) == msg.sender, "only the payer should do this action");
1556         _;
1557     }
1558 }
1559 
1560 
1561 /**
1562  * @title RequestERC20
1563  * @notice Currency contract managing the requests in ERC20 tokens.
1564  * @dev Requests can be created by the Payee with createRequestAsPayeeAction(), by the payer with createRequestAsPayerAction() or by the payer from a request signed offchain by the payee with broadcastSignedRequestAsPayer
1565  */
1566 contract RequestERC20 is CurrencyContract {
1567     using SafeMath for uint256;
1568     using SafeMathInt for int256;
1569     using SafeMathUint8 for uint8;
1570 
1571     // payment addresses by requestId (optional). We separate the Identity of the payee/payer (in the core) and the wallet address in the currency contract
1572     mapping(bytes32 => address[256]) public payeesPaymentAddress;
1573     mapping(bytes32 => address) public payerRefundAddress;
1574 
1575     // token address
1576     ERC20 public erc20Token;
1577 
1578     /**
1579      * @param _requestCoreAddress Request Core address
1580      * @param _requestBurnerAddress Request Burner contract address
1581      * @param _erc20Token ERC20 token contract handled by this currency contract
1582      */
1583     constructor (address _requestCoreAddress, address _requestBurnerAddress, ERC20 _erc20Token) 
1584         CurrencyContract(_requestCoreAddress, _requestBurnerAddress)
1585         public
1586     {
1587         erc20Token = _erc20Token;
1588     }
1589 
1590     /**
1591      * @notice Function to create a request as payee.
1592      *
1593      * @dev msg.sender must be the main payee.
1594      * @dev if _payeesPaymentAddress.length > _payeesIdAddress.length, the extra addresses will be stored but never used.
1595      *
1596      * @param _payeesIdAddress array of payees address (the index 0 will be the payee - must be msg.sender - the others are subPayees)
1597      * @param _payeesPaymentAddress array of payees address for payment (optional)
1598      * @param _expectedAmounts array of Expected amount to be received by each payees
1599      * @param _payer Entity expected to pay
1600      * @param _payerRefundAddress Address of refund for the payer (optional)
1601      * @param _data Hash linking to additional data on the Request stored on IPFS
1602      *
1603      * @return Returns the id of the request
1604      */
1605     function createRequestAsPayeeAction(
1606         address[] 	_payeesIdAddress,
1607         address[] 	_payeesPaymentAddress,
1608         int256[] 	_expectedAmounts,
1609         address 	_payer,
1610         address 	_payerRefundAddress,
1611         string 		_data)
1612         external
1613         payable
1614         whenNotPaused
1615         returns(bytes32 requestId)
1616     {
1617         require(
1618             msg.sender == _payeesIdAddress[0] && msg.sender != _payer && _payer != 0,
1619             "caller should be the payee"
1620         );
1621 
1622         uint256 collectedFees;
1623         (requestId, collectedFees) = createCoreRequestInternal(
1624             _payer,
1625             _payeesIdAddress,
1626             _expectedAmounts,
1627             _data
1628         );
1629         
1630         // Additional check on the fees: they should be equal to the about of ETH sent
1631         require(collectedFees == msg.value, "fees should be the correct amout");
1632 
1633         // set payment addresses for payees
1634         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1635             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1636         }
1637         // set payment address for payer
1638         if (_payerRefundAddress != 0) {
1639             payerRefundAddress[requestId] = _payerRefundAddress;
1640         }
1641 
1642         return requestId;
1643     }
1644 
1645     /**
1646      * @notice Function to broadcast and accept an offchain signed request (the broadcaster can also pays and makes additionals).
1647      *
1648      * @dev msg.sender will be the _payer.
1649      * @dev only the _payer can make additionals.
1650      * @dev if _payeesPaymentAddress.length > _requestData.payeesIdAddress.length, the extra addresses will be stored but never used.
1651      *
1652      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1653      * @param _payeesPaymentAddress array of payees address for payment (optional) 
1654      * @param _payeeAmounts array of amount repartition for the payment
1655      * @param _additionals array to increase the ExpectedAmount for payees
1656      * @param _expirationDate timestamp after that the signed request cannot be broadcasted
1657      * @param _signature ECDSA signature in bytes
1658      *
1659      * @return Returns the id of the request
1660      */
1661     function broadcastSignedRequestAsPayerAction(
1662         bytes 		_requestData, // gather data to avoid "stack too deep"
1663         address[] 	_payeesPaymentAddress,
1664         uint256[] 	_payeeAmounts,
1665         uint256[] 	_additionals,
1666         uint256 	_expirationDate,
1667         bytes 		_signature)
1668         external
1669         payable
1670         whenNotPaused
1671         returns(bytes32 requestId)
1672     {
1673         // check expiration date
1674         // solium-disable-next-line security/no-block-members
1675         require(_expirationDate >= block.timestamp, "expiration should be after current time");
1676 
1677         // check the signature
1678         require(
1679             Signature.checkRequestSignature(
1680                 _requestData,
1681                 _payeesPaymentAddress,
1682                 _expirationDate,
1683                 _signature
1684             ),
1685             "signature should be correct"
1686         );
1687 
1688         return createAcceptAndPayFromBytes(
1689             _requestData,
1690             _payeesPaymentAddress,
1691             _payeeAmounts,
1692             _additionals
1693         );
1694     }
1695 
1696     /**
1697      * @notice Function to pay a request in ERC20 token.
1698      *
1699      * @dev msg.sender must have a balance of the token higher or equal to the sum of _payeeAmounts.
1700      * @dev msg.sender must have approved an amount of the token higher or equal to the sum of _payeeAmounts to the current contract.
1701      * @dev the request will be automatically accepted if msg.sender==payer. 
1702      *
1703      * @param _requestId id of the request
1704      * @param _payeeAmounts Amount to pay to payees (sum must be equal to msg.value) in wei
1705      * @param _additionalAmounts amount of additionals per payee in wei to declare
1706      */
1707     function paymentAction(
1708         bytes32 _requestId,
1709         uint256[] _payeeAmounts,
1710         uint256[] _additionalAmounts)
1711         external
1712         whenNotPaused
1713     {
1714         // automatically accept request if request is created and msg.sender is payer
1715         if (requestCore.getState(_requestId)==RequestCore.State.Created && msg.sender == requestCore.getPayer(_requestId)) {
1716             acceptAction(_requestId);
1717         }
1718 
1719         if (_additionalAmounts.length != 0) {
1720             additionalAction(_requestId, _additionalAmounts);
1721         }
1722 
1723         paymentInternal(_requestId, _payeeAmounts);
1724     }
1725 
1726     /**
1727      * @notice Function to pay back in ERC20 token a request to the payees.
1728      *
1729      * @dev msg.sender must have a balance of the token higher or equal to _amountToRefund.
1730      * @dev msg.sender must have approved an amount of the token higher or equal to _amountToRefund to the current contract.
1731      * @dev msg.sender must be one of the payees or one of the payees payment address.
1732      * @dev the request must be created or accepted.
1733      *
1734      * @param _requestId id of the request
1735      */
1736     function refundAction(bytes32 _requestId, uint256 _amountToRefund)
1737         external
1738         whenNotPaused
1739     {
1740         refundInternal(_requestId, msg.sender, _amountToRefund);
1741     }
1742 
1743     /**
1744      * @notice Function to create a request as payer. The request is payed if _payeeAmounts > 0.
1745      *
1746      * @dev msg.sender will be the payer.
1747      * @dev If a contract is given as a payee make sure it is payable. Otherwise, the request will not be payable.
1748      * @dev Is public instead of external to avoid "Stack too deep" exception.
1749      *
1750      * @param _payeesIdAddress array of payees address (the index 0 will be the payee the others are subPayees)
1751      * @param _expectedAmounts array of Expected amount to be received by each payees
1752      * @param _payerRefundAddress Address of refund for the payer (optional)
1753      * @param _payeeAmounts array of amount repartition for the payment
1754      * @param _additionals array to increase the ExpectedAmount for payees
1755      * @param _data Hash linking to additional data on the Request stored on IPFS
1756      *
1757      * @return Returns the id of the request
1758      */
1759     function createRequestAsPayerAction(
1760         address[] 	_payeesIdAddress,
1761         int256[] 	_expectedAmounts,
1762         address 	_payerRefundAddress,
1763         uint256[] 	_payeeAmounts,
1764         uint256[] 	_additionals,
1765         string 		_data)
1766         public
1767         payable
1768         whenNotPaused
1769         returns(bytes32 requestId)
1770     {
1771         require(msg.sender != _payeesIdAddress[0] && _payeesIdAddress[0] != 0, "caller should not be the main payee");
1772 
1773         uint256 collectedFees;
1774         (requestId, collectedFees) = createCoreRequestInternal(
1775             msg.sender,
1776             _payeesIdAddress,
1777             _expectedAmounts,
1778             _data
1779         );
1780 
1781         // Additional check on the fees: they should be equal to the about of ETH sent
1782         require(collectedFees == msg.value, "fees should be the correct amout");
1783 
1784         // set payment address for payer
1785         if (_payerRefundAddress != 0) {
1786             payerRefundAddress[requestId] = _payerRefundAddress;
1787         }
1788         
1789         // compute the total expected amount of the request
1790         // this computation is also made in createCoreRequestInternal but we do it again here to have better decoupling
1791         int256 totalExpectedAmounts = 0;
1792         for (uint8 i = 0; i < _expectedAmounts.length; i = i.add(1)) {
1793             totalExpectedAmounts = totalExpectedAmounts.add(_expectedAmounts[i]);
1794         }
1795 
1796         // accept and pay the request with the value remaining after the fee collect
1797         acceptAndPay(
1798             requestId,
1799             _payeeAmounts,
1800             _additionals,
1801             totalExpectedAmounts
1802         );
1803 
1804         return requestId;
1805     }
1806 
1807     /**
1808      * @dev Internal function to create, accept, add additionals and pay a request as Payer.
1809      *
1810      * @dev msg.sender must be _payer.
1811      *
1812      * @param _requestData nasty bytes containing : creator, payer, payees|expectedAmounts, data
1813      * @param _payeesPaymentAddress array of payees address for payment (optional)
1814      * @param _payeeAmounts array of amount repartition for the payment
1815      * @param _additionals Will increase the ExpectedAmount of the request right after its creation by adding additionals
1816      *
1817      * @return Returns the id of the request
1818      */
1819     function createAcceptAndPayFromBytes(
1820         bytes 		_requestData,
1821         address[] 	_payeesPaymentAddress,
1822         uint256[] 	_payeeAmounts,
1823         uint256[] 	_additionals)
1824         internal
1825         returns(bytes32 requestId)
1826     {
1827         // extract main payee
1828         address mainPayee = Bytes.extractAddress(_requestData, 41);
1829         require(msg.sender != mainPayee && mainPayee != 0, "caller should not be the main payee");
1830 
1831         // creator must be the main payee
1832         require(Bytes.extractAddress(_requestData, 0) == mainPayee, "creator should be the main payee");
1833 
1834         // extract the number of payees
1835         uint8 payeesCount = uint8(_requestData[40]);
1836         int256 totalExpectedAmounts = 0;
1837         for (uint8 i = 0; i < payeesCount; i++) {
1838             // extract the expectedAmount for the payee[i]
1839             int256 expectedAmountTemp = int256(Bytes.extractBytes32(_requestData, uint256(i).mul(52).add(61)));
1840             
1841             // compute the total expected amount of the request
1842             totalExpectedAmounts = totalExpectedAmounts.add(expectedAmountTemp);
1843             
1844             // all expected amount must be positive
1845             require(expectedAmountTemp > 0, "expected amount should be > 0");
1846         }
1847 
1848         // compute and send fees
1849         uint256 fees = collectEstimation(totalExpectedAmounts);
1850         require(fees == msg.value, "fees should be the correct amout");
1851         collectForREQBurning(fees);
1852 
1853         // insert the msg.sender as the payer in the bytes
1854         Bytes.updateBytes20inBytes(_requestData, 20, bytes20(msg.sender));
1855         // store request in the core
1856         requestId = requestCore.createRequestFromBytes(_requestData);
1857         
1858         // set payment addresses for payees
1859         for (uint8 j = 0; j < _payeesPaymentAddress.length; j = j.add(1)) {
1860             payeesPaymentAddress[requestId][j] = _payeesPaymentAddress[j];
1861         }
1862 
1863         // accept and pay the request with the value remaining after the fee collect
1864         acceptAndPay(
1865             requestId,
1866             _payeeAmounts,
1867             _additionals,
1868             totalExpectedAmounts
1869         );
1870 
1871         return requestId;
1872     }
1873 
1874     /**
1875      * @dev Internal function to manage payment declaration.
1876      *
1877      * @param _requestId id of the request
1878      * @param _payeeAmounts Amount to pay to payees (sum must be equals to msg.value)
1879      */
1880     function paymentInternal(
1881         bytes32 	_requestId,
1882         uint256[] 	_payeeAmounts)
1883         internal
1884     {
1885         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1886 
1887         // we cannot have more amounts declared than actual payees
1888         require(
1889             _payeeAmounts.length <= requestCore.getSubPayeesCount(_requestId).add(1),
1890             "number of amounts should be <= number of payees"
1891         );
1892 
1893         for (uint8 i = 0; i < _payeeAmounts.length; i = i.add(1)) {
1894             if (_payeeAmounts[i] != 0) {
1895                 // Store and declare the payment to the core
1896                 requestCore.updateBalance(_requestId, i, _payeeAmounts[i].toInt256Safe());
1897 
1898                 // pay the payment address if given, the id address otherwise
1899                 address addressToPay;
1900                 if (payeesPaymentAddress[_requestId][i] == 0) {
1901                     addressToPay = requestCore.getPayeeAddress(_requestId, i);
1902                 } else {
1903                     addressToPay = payeesPaymentAddress[_requestId][i];
1904                 }
1905 
1906                 // payment done, the token need to be sent
1907                 fundOrderInternal(msg.sender, addressToPay, _payeeAmounts[i]);
1908             }
1909         }
1910     }
1911 
1912     /**
1913      * @dev Internal function to accept, add additionals and pay a request as Payer
1914      *
1915      * @param _requestId id of the request
1916      * @param _payeeAmounts Amount to pay to payees (sum must be equals to _amountPaid)
1917      * @param _additionals Will increase the ExpectedAmounts of payees
1918      * @param _payeeAmountsSum total of amount token send for this transaction
1919      *
1920      */	
1921     function acceptAndPay(
1922         bytes32 _requestId,
1923         uint256[] _payeeAmounts,
1924         uint256[] _additionals,
1925         int256 _payeeAmountsSum)
1926         internal
1927     {
1928         acceptAction(_requestId);
1929         
1930         additionalAction(_requestId, _additionals);
1931 
1932         if (_payeeAmountsSum > 0) {
1933             paymentInternal(_requestId, _payeeAmounts);
1934         }
1935     }
1936 
1937     /**
1938      * @dev Internal function to manage refund declaration
1939      *
1940      * @param _requestId id of the request
1941      * @param _address address from where the refund has been done
1942      * @param _amount amount of the refund in ERC20 token to declare
1943      */
1944     function refundInternal(
1945         bytes32 _requestId,
1946         address _address,
1947         uint256 _amount)
1948         internal
1949     {
1950         require(requestCore.getState(_requestId) != RequestCore.State.Canceled, "request should not be canceled");
1951 
1952         // Check if the _address is a payeesId
1953         int16 payeeIndex = requestCore.getPayeeIndex(_requestId, _address);
1954 
1955         // get the number of payees
1956         uint8 payeesCount = requestCore.getSubPayeesCount(_requestId).add(1);
1957 
1958         if (payeeIndex < 0) {
1959             // if not ID addresses maybe in the payee payments addresses
1960             for (uint8 i = 0; i < payeesCount && payeeIndex == -1; i = i.add(1)) {
1961                 if (payeesPaymentAddress[_requestId][i] == _address) {
1962                     // get the payeeIndex
1963                     payeeIndex = int16(i);
1964                 }
1965             }
1966         }
1967         // the address must be found somewhere
1968         require(payeeIndex >= 0, "fromAddress should be a payee"); 
1969 
1970         // useless (subPayee size <256): require(payeeIndex < 265);
1971         requestCore.updateBalance(_requestId, uint8(payeeIndex), -_amount.toInt256Safe());
1972 
1973         // refund to the payment address if given, the id address otherwise
1974         address addressToPay = payerRefundAddress[_requestId];
1975         if (addressToPay == 0) {
1976             addressToPay = requestCore.getPayer(_requestId);
1977         }
1978 
1979         // refund declared, the money is ready to be sent to the payer
1980         fundOrderInternal(_address, addressToPay, _amount);
1981     }
1982 
1983     /**
1984      * @dev Internal function to manage fund mouvement.
1985      *
1986      * @param _from address where the token will get from
1987      * @param _recipient address where the token has to be sent to
1988      * @param _amount amount in ERC20 token to send
1989      */
1990     function fundOrderInternal(
1991         address _from,
1992         address _recipient,
1993         uint256 _amount)
1994         internal
1995     {	
1996         require(erc20Token.transferFrom(_from, _recipient, _amount), "erc20 transfer should succeed");
1997     }
1998 }