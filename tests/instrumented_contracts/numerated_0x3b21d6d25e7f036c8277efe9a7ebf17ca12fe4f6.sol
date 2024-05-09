1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /*
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address payable public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address payable _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address payable _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 library ERC20SafeTransfer {
68     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
69         (success,) = _tokenAddress.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
70         require(success, "Transfer failed");
71 
72         return fetchReturnData();
73     }
74 
75     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
76         (success,) = _tokenAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
77         require(success, "Transfer From failed");
78 
79         return fetchReturnData();
80     }
81 
82     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
83         (success,) = _tokenAddress.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
84         require(success,  "Approve failed");
85 
86         return fetchReturnData();
87     }
88 
89     function fetchReturnData() internal pure returns (bool success){
90         assembly {
91             switch returndatasize()
92             case 0 {
93                 success := 1
94             }
95             case 32 {
96                 returndatacopy(0, 0, 32)
97                 success := mload(0)
98             }
99             default {
100                 revert(0, 0)
101             }
102         }
103     }
104 
105 }
106 
107 /// @title A contract which allows its owner to withdraw any ether which is contained inside
108 contract Withdrawable is Ownable {
109 
110     /// @notice Withdraw ether contained in this contract and send it back to owner
111     /// @dev onlyOwner modifier only allows the contract owner to run the code
112     /// @param _token The address of the token that the user wants to withdraw
113     /// @param _amount The amount of tokens that the caller wants to withdraw
114     /// @return bool value indicating whether the transfer was successful
115     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
116         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
117     }
118 
119     /// @notice Withdraw ether contained in this contract and send it back to owner
120     /// @dev onlyOwner modifier only allows the contract owner to run the code
121     /// @param _amount The amount of ether that the caller wants to withdraw
122     function withdrawETH(uint256 _amount) external onlyOwner {
123         owner.transfer(_amount);
124     }
125 }
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable {
132   event Paused();
133   event Unpaused();
134 
135   bool private _paused = false;
136 
137   /**
138    * @return true if the contract is paused, false otherwise.
139    */
140   function paused() public view returns (bool) {
141     return _paused;
142   }
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is not paused.
146    */
147   modifier whenNotPaused() {
148     require(!_paused, "Contract is paused.");
149     _;
150   }
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is paused.
154    */
155   modifier whenPaused() {
156     require(_paused, "Contract not paused.");
157     _;
158   }
159 
160   /**
161    * @dev called by the owner to pause, triggers stopped state
162    */
163   function pause() public onlyOwner whenNotPaused {
164     _paused = true;
165     emit Paused();
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause() public onlyOwner whenPaused {
172     _paused = false;
173     emit Unpaused();
174   }
175 }
176 
177 /**
178  * @title ERC20 interface
179  * @dev see https://github.com/ethereum/EIPs/issues/20
180  */
181 contract ERC20 {
182   function totalSupply() public view returns (uint256);
183 
184   function balanceOf(address _who) public view returns (uint256);
185 
186   function allowance(address _owner, address _spender)
187     public view returns (uint256);
188 
189   function transfer(address _to, uint256 _value) public returns (bool);
190 
191   function approve(address _spender, uint256 _value)
192     public returns (bool);
193 
194   function transferFrom(address _from, address _to, uint256 _value)
195     public returns (bool);
196 
197   function decimals() public view returns (uint256);
198 
199   event Transfer(
200     address indexed from,
201     address indexed to,
202     uint256 value
203   );
204 
205   event Approval(
206     address indexed owner,
207     address indexed spender,
208     uint256 value
209   );
210 }
211 
212 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
213 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
214 contract TokenTransferProxy is Ownable {
215 
216     /// @dev Only authorized addresses can invoke functions with this modifier.
217     modifier onlyAuthorized {
218         require(authorized[msg.sender]);
219         _;
220     }
221 
222     modifier targetAuthorized(address target) {
223         require(authorized[target]);
224         _;
225     }
226 
227     modifier targetNotAuthorized(address target) {
228         require(!authorized[target]);
229         _;
230     }
231 
232     mapping (address => bool) public authorized;
233     address[] public authorities;
234 
235     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
236     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
237 
238     /*
239      * Public functions
240      */
241 
242     /// @dev Authorizes an address.
243     /// @param target Address to authorize.
244     function addAuthorizedAddress(address target)
245         public
246         onlyOwner
247         targetNotAuthorized(target)
248     {
249         authorized[target] = true;
250         authorities.push(target);
251         emit LogAuthorizedAddressAdded(target, msg.sender);
252     }
253 
254     /// @dev Removes authorizion of an address.
255     /// @param target Address to remove authorization from.
256     function removeAuthorizedAddress(address target)
257         public
258         onlyOwner
259         targetAuthorized(target)
260     {
261         delete authorized[target];
262         for (uint i = 0; i < authorities.length; i++) {
263             if (authorities[i] == target) {
264                 authorities[i] = authorities[authorities.length - 1];
265                 authorities.length -= 1;
266                 break;
267             }
268         }
269         emit LogAuthorizedAddressRemoved(target, msg.sender);
270     }
271 
272     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
273     /// @param token Address of token to transfer.
274     /// @param from Address to transfer token from.
275     /// @param to Address to transfer token to.
276     /// @param value Amount of token to transfer.
277     /// @return Success of transfer.
278     function transferFrom(
279         address token,
280         address from,
281         address to,
282         uint value)
283         public
284         onlyAuthorized
285         returns (bool)
286     {
287         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
288         return true;
289     }
290 
291     /*
292      * Public view functions
293      */
294 
295     /// @dev Gets all authorized addresses.
296     /// @return Array of authorized addresses.
297     function getAuthorizedAddresses()
298         public
299         view
300         returns (address[] memory)
301     {
302         return authorities;
303     }
304 }
305 
306 library Utils {
307 
308     uint256 constant internal PRECISION = (10**18);
309     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
310     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
311     uint256 constant internal MAX_DECIMALS = 18;
312     uint256 constant internal ETH_DECIMALS = 18;
313     uint256 constant internal MAX_UINT = 2**256-1;
314     address constant internal ETH_ADDRESS = address(0x0);
315 
316     // Currently constants can't be accessed from other contracts, so providing functions to do that here
317     function precision() internal pure returns (uint256) { return PRECISION; }
318     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
319     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
320     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
321     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
322     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
323     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
324 
325     /// @notice Retrieve the number of decimals used for a given ERC20 token
326     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
327     /// ensure that an exception doesn't cause transaction failure
328     /// @param token the token for which we should retrieve the decimals
329     /// @return decimals the number of decimals in the given token
330     function getDecimals(address token)
331         internal
332         returns (uint256 decimals)
333     {
334         bytes4 functionSig = bytes4(keccak256("decimals()"));
335 
336         /// @dev Using assembly due to issues with current solidity `address.call()`
337         /// implementation: https://github.com/ethereum/solidity/issues/2884
338         assembly {
339             // Pointer to next free memory slot
340             let ptr := mload(0x40)
341             // Store functionSig variable at ptr
342             mstore(ptr,functionSig)
343             let functionSigLength := 0x04
344             let wordLength := 0x20
345 
346             let success := call(
347                                 gas, // Amount of gas
348                                 token, // Address to call
349                                 0, // ether to send
350                                 ptr, // ptr to input data
351                                 functionSigLength, // size of data
352                                 ptr, // where to store output data (overwrite input)
353                                 wordLength // size of output data (32 bytes)
354                                )
355 
356             switch success
357             case 0 {
358                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
359             }
360             case 1 {
361                 decimals := mload(ptr) // Set decimals to return data from call
362             }
363             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
364         }
365     }
366 
367     /// @dev Checks that a given address has its token allowance and balance set above the given amount
368     /// @param tokenOwner the address which should have custody of the token
369     /// @param tokenAddress the address of the token to check
370     /// @param tokenAmount the amount of the token which should be set
371     /// @param addressToAllow the address which should be allowed to transfer the token
372     /// @return bool true if the allowance and balance is set, false if not
373     function tokenAllowanceAndBalanceSet(
374         address tokenOwner,
375         address tokenAddress,
376         uint256 tokenAmount,
377         address addressToAllow
378     )
379         internal
380         view
381         returns (bool)
382     {
383         return (
384             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
385             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
386         );
387     }
388 
389     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
390         if (dstDecimals >= srcDecimals) {
391             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
392             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
393         } else {
394             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
395             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
396         }
397     }
398 
399     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
400 
401         //source quantity is rounded up. to avoid dest quantity being too low.
402         uint numerator;
403         uint denominator;
404         if (srcDecimals >= dstDecimals) {
405             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
406             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
407             denominator = rate;
408         } else {
409             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
410             numerator = (PRECISION * dstQty);
411             denominator = (rate * (10**(dstDecimals - srcDecimals)));
412         }
413         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
414     }
415 
416     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
417         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
418     }
419 
420     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
421         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
422     }
423 
424     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
425         internal pure returns (uint)
426     {
427         require(srcAmount <= MAX_QTY);
428         require(destAmount <= MAX_QTY);
429 
430         if (dstDecimals >= srcDecimals) {
431             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
432             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
433         } else {
434             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
435             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
436         }
437     }
438 
439     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
440     function min(uint256 a, uint256 b) internal pure returns (uint256) {
441         return a < b ? a : b;
442     }
443 }
444 
445 /**
446  * @title SafeMath
447  * @dev Math operations with safety checks that revert on error
448  */
449 library SafeMath {
450 
451   /**
452   * @dev Multiplies two numbers, reverts on overflow.
453   */
454   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
455     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
456     // benefit is lost if 'b' is also tested.
457     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
458     if (_a == 0) {
459       return 0;
460     }
461 
462     uint256 c = _a * _b;
463     require(c / _a == _b);
464 
465     return c;
466   }
467 
468   /**
469   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
470   */
471   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
472     require(_b > 0); // Solidity only automatically asserts when dividing by 0
473     uint256 c = _a / _b;
474     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
475 
476     return c;
477   }
478 
479   /**
480   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
481   */
482   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
483     require(_b <= _a);
484     uint256 c = _a - _b;
485 
486     return c;
487   }
488 
489   /**
490   * @dev Adds two numbers, reverts on overflow.
491   */
492   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
493     uint256 c = _a + _b;
494     require(c >= _a);
495 
496     return c;
497   }
498 
499   /**
500   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
501   * reverts when dividing by zero.
502   */
503   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504     require(b != 0);
505     return a % b;
506   }
507 }
508 
509 /**
510  * @title Math
511  * @dev Assorted math operations
512  */
513 
514 library Math {
515   function max(uint256 a, uint256 b) internal pure returns (uint256) {
516     return a >= b ? a : b;
517   }
518 
519   function min(uint256 a, uint256 b) internal pure returns (uint256) {
520     return a < b ? a : b;
521   }
522 
523   function average(uint256 a, uint256 b) internal pure returns (uint256) {
524     // (a + b) / 2 can overflow, so we distribute
525     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
526   }
527 }
528 
529 contract PartnerRegistry is Ownable, Pausable {
530 
531     address target;
532     mapping(address => bool) partnerContracts;
533     address payable public companyBeneficiary;
534     uint256 public basePercentage;
535     PartnerRegistry public previousRegistry;
536 
537     event PartnerRegistered(address indexed creator, address indexed beneficiary, address partnerContract);
538 
539     constructor(PartnerRegistry _previousRegistry, address _target, address payable _companyBeneficiary, uint256 _basePercentage) public {
540         previousRegistry = _previousRegistry;
541         target = _target;
542         companyBeneficiary = _companyBeneficiary;
543         basePercentage = _basePercentage;
544     }
545 
546     function registerPartner(address payable partnerBeneficiary, uint256 partnerPercentage) whenNotPaused external {
547         Partner newPartner = Partner(createClone());
548         newPartner.init(this,address(0x0000000000000000000000000000000000000000), 0, partnerBeneficiary, partnerPercentage);
549         partnerContracts[address(newPartner)] = true;
550         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
551     }
552 
553     function overrideRegisterPartner(
554         address payable _companyBeneficiary,
555         uint256 _companyPercentage,
556         address payable partnerBeneficiary,
557         uint256 partnerPercentage
558     ) external onlyOwner {
559         Partner newPartner = Partner(createClone());
560         newPartner.init(PartnerRegistry(0x0000000000000000000000000000000000000000), _companyBeneficiary, _companyPercentage, partnerBeneficiary, partnerPercentage);
561         partnerContracts[address(newPartner)] = true;
562         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
563     }
564 
565     function deletePartner(address _partnerAddress) external onlyOwner {
566         partnerContracts[_partnerAddress] = false;
567     }
568 
569     function createClone() internal returns (address payable result) {
570         bytes20 targetBytes = bytes20(target);
571         assembly {
572             let clone := mload(0x40)
573             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
574             mstore(add(clone, 0x14), targetBytes)
575             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
576             result := create(0, clone, 0x37)
577         }
578     }
579 
580     function isValidPartner(address partnerContract) external view returns(bool) {
581         return partnerContracts[partnerContract] || previousRegistry.isValidPartner(partnerContract);
582     }
583 
584     function updateCompanyInfo(address payable newCompanyBeneficiary, uint256 newBasePercentage) external onlyOwner {
585         companyBeneficiary = newCompanyBeneficiary;
586         basePercentage = newBasePercentage;
587     }
588 }
589 
590 contract Partner {
591 
592     address payable public partnerBeneficiary;
593     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
594 
595     uint256 public overrideCompanyPercentage;
596     address payable public overrideCompanyBeneficiary;
597 
598    PartnerRegistry public registry;
599 
600     event LogPayout(
601         address[] tokens,
602         uint256[] amount
603     );
604 
605     function init(
606        PartnerRegistry _registry,
607         address payable _overrideCompanyBeneficiary,
608         uint256 _overrideCompanyPercentage,
609         address payable _partnerBeneficiary,
610         uint256 _partnerPercentage
611     ) public {
612        require(registry == PartnerRegistry(0x0000000000000000000000000000000000000000) &&
613          overrideCompanyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0)
614        );
615         overrideCompanyBeneficiary = _overrideCompanyBeneficiary;
616         overrideCompanyPercentage = _overrideCompanyPercentage;
617         partnerBeneficiary = _partnerBeneficiary;
618         partnerPercentage = _partnerPercentage;
619         overrideCompanyPercentage = _overrideCompanyPercentage;
620         registry = _registry;
621     }
622 
623     function payout(
624         address[] memory tokens,
625         uint256[] memory amounts
626     ) public {
627         uint totalFeePercentage = getTotalFeePercentage();
628         address payable companyBeneficiary = companyBeneficiary();
629         // Payout both the partner and the company at the same time
630         for(uint256 index = 0; index<tokens.length; index++){
631             uint256 partnerAmount = SafeMath.div(SafeMath.mul(amounts[index], partnerPercentage), getTotalFeePercentage());
632             uint256 companyAmount = amounts[index] - partnerAmount;
633             if(tokens[index] == Utils.eth_address()){
634                 partnerBeneficiary.transfer(partnerAmount);
635                 companyBeneficiary.transfer(companyAmount);
636             } else {
637                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
638                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
639             }
640         }
641 	emit LogPayout(tokens,amounts);
642     }
643 
644     function getTotalFeePercentage() public view returns (uint256){
645         return partnerPercentage + companyPercentage();
646     }
647 
648     function companyPercentage() public view returns (uint256){
649         if(registry != PartnerRegistry(0x0000000000000000000000000000000000000000)){
650             return Math.max(registry.basePercentage(), partnerPercentage);
651         } else {
652             return overrideCompanyPercentage;
653         }
654     }
655 
656     function companyBeneficiary() public view returns (address payable) {
657         if(registry != PartnerRegistry(0x0000000000000000000000000000000000000000)){
658             return registry.companyBeneficiary();
659         } else {
660             return overrideCompanyBeneficiary;
661         }    
662     }
663 
664     function() external payable {
665 
666     }
667 }
668 
669 
670 /// @title Interface for all exchange handler contracts
671 contract ExchangeHandler is Withdrawable, Pausable {
672 
673     /*
674     *   State Variables
675     */
676 
677     /* Logger public logger; */
678     /*
679     *   Modifiers
680     */
681 
682     function performOrder(
683         bytes memory genericPayload,
684         uint256 availableToSpend,
685         uint256 targetAmount,
686         bool targetAmountIsSource
687     )
688         public
689         payable
690         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
691 
692 }
693 
694 /// @title The primary contract for Totle
695 contract TotlePrimary is Withdrawable, Pausable {
696 
697     /*
698     *   State Variables
699     */
700 
701     TokenTransferProxy public tokenTransferProxy;
702     mapping(address => bool) public signers;
703     /* Logger public logger; */
704 
705     /*
706     *   Types
707     */
708 
709     // Structs
710     struct Order {
711         address payable exchangeHandler;
712         bytes encodedPayload;
713     }
714 
715     struct Trade {
716         address sourceToken;
717         address destinationToken;
718         uint256 amount;
719         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
720         Order[] orders;
721     }
722 
723     struct Swap {
724         Trade[] trades;
725         uint256 minimumExchangeRate;
726         uint256 minimumDestinationAmount;
727         uint256 sourceAmount;
728         uint256 tradeToTakeFeeFrom;
729         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
730         address payable redirectAddress;
731         bool required;
732     }
733 
734     struct SwapCollection {
735         Swap[] swaps;
736         address payable partnerContract;
737         uint256 expirationBlock;
738         bytes32 id;
739         uint256 maxGasPrice;
740         uint8 v;
741         bytes32 r;
742         bytes32 s;
743     }
744 
745     struct TokenBalance {
746         address tokenAddress;
747         uint256 balance;
748     }
749 
750     struct FeeVariables {
751         uint256 feePercentage;
752         Partner partner;
753         uint256 totalFee;
754     }
755 
756     struct AmountsSpentReceived{
757         uint256 spent;
758         uint256 received;
759     }
760     /*
761     *   Events
762     */
763 
764     event LogSwapCollection(
765         bytes32 indexed id,
766         address indexed partnerContract,
767         address indexed user
768     );
769 
770     event LogSwap(
771         bytes32 indexed id,
772         address sourceAsset,
773         address destinationAsset,
774         uint256 sourceAmount,
775         uint256 destinationAmount,
776         address feeAsset,
777         uint256 feeAmount
778     );
779 
780     /// @notice Constructor
781     /// @param _tokenTransferProxy address of the TokenTransferProxy
782     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
783     constructor (address _tokenTransferProxy, address _signer/*, address _logger*/) public {
784         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
785         signers[_signer] = true;
786         /* logger = Logger(_logger); */
787     }
788 
789     /*
790     *   Public functions
791     */
792 
793     modifier notExpired(SwapCollection memory swaps) {
794         require(swaps.expirationBlock > block.number, "Expired");
795         _;
796     }
797 
798     modifier validSignature(SwapCollection memory swaps){
799         bytes32 hash = keccak256(abi.encode(swaps.swaps, swaps.partnerContract, swaps.expirationBlock, swaps.id, swaps.maxGasPrice, msg.sender));
800         require(signers[ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), swaps.v, swaps.r, swaps.s)], "Invalid signature");
801         _;
802     }
803 
804     modifier notAboveMaxGas(SwapCollection memory swaps){
805         require(tx.gasprice <= swaps.maxGasPrice, "Gas price too high");
806         _;
807     }
808 
809     /// @notice Performs the requested set of swaps
810     /// @param swaps The struct that defines the collection of swaps to perform
811     function performSwapCollection(
812         SwapCollection memory swaps
813     )
814         public
815         payable
816         whenNotPaused
817         notExpired(swaps)
818         validSignature(swaps)
819         notAboveMaxGas(swaps)
820     {
821         TokenBalance[20] memory balances;
822         balances[0] = TokenBalance(address(Utils.eth_address()), msg.value);
823         //this.log("Created eth balance", balances[0].balance, 0x0);
824         for(uint256 swapIndex = 0; swapIndex < swaps.swaps.length; swapIndex++){
825             //this.log("About to perform swap", swapIndex, swaps.id);
826             performSwap(swaps.id, swaps.swaps[swapIndex], balances, swaps.partnerContract);
827         }
828         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
829         transferAllTokensToUser(balances);
830     }
831 
832     function addSigner(address newSigner) public onlyOwner {
833          signers[newSigner] = true;
834     }
835 
836     function removeSigner(address signer) public onlyOwner {
837          signers[signer] = false;
838     }
839 
840     /*
841     *   Internal functions
842     */
843 
844 
845     function performSwap(
846         bytes32 swapCollectionId,
847         Swap memory swap,
848         TokenBalance[20] memory balances,
849         address payable partnerContract
850     )
851         internal
852     {
853         if(!transferFromSenderDifference(balances, swap.trades[0].sourceToken, swap.sourceAmount)){
854             if(swap.required){
855                 revert("Failed to get tokens for swap");
856             } else {
857                 return;
858             }
859         }
860         uint256 amountSpentFirstTrade = 0;
861         uint256 amountReceived = 0;
862         uint256 feeAmount = 0;
863         for(uint256 tradeIndex = 0; tradeIndex < swap.trades.length; tradeIndex++){
864             if(tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource){
865                 feeAmount = takeFee(balances, swap.trades[tradeIndex].sourceToken, partnerContract,tradeIndex==0 ? swap.sourceAmount : amountReceived);
866             }
867             uint256 tempSpent;
868             //this.log("About to performTrade",0,0x0);
869             (tempSpent, amountReceived) = performTrade(
870                 swap.trades[tradeIndex],
871                 balances,
872                 Utils.min(
873                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
874                     balances[findToken(balances, swap.trades[tradeIndex].sourceToken)].balance
875                 )
876             );
877             if(!swap.trades[tradeIndex].isSourceAmount && amountReceived < swap.trades[tradeIndex].amount){
878                 if(swap.required){
879                     revert("Not enough destination amount");
880                 }
881                 return;
882             }
883             if(tradeIndex == 0){
884                 amountSpentFirstTrade = tempSpent;
885                 if(feeAmount != 0){
886                     amountSpentFirstTrade += feeAmount;
887                 }
888             }
889             if(tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource){
890                 feeAmount = takeFee(balances, swap.trades[tradeIndex].destinationToken, partnerContract, amountReceived);
891                 amountReceived -= feeAmount;
892             }
893         }
894         //this.log("About to emit LogSwap", 0, 0x0);
895         emit LogSwap(
896             swapCollectionId,
897             swap.trades[0].sourceToken,
898             swap.trades[swap.trades.length-1].destinationToken,
899             amountSpentFirstTrade,
900             amountReceived,
901             swap.takeFeeFromSource?swap.trades[swap.tradeToTakeFeeFrom].sourceToken:swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
902             feeAmount
903         );
904 
905         if(amountReceived < swap.minimumDestinationAmount){
906             //this.log("Minimum destination amount failed", 0, 0x0);
907             revert("Got less than minimumDestinationAmount");
908         } else if (minimumRateFailed(swap.trades[0].sourceToken, swap.trades[swap.trades.length-1].destinationToken,swap.sourceAmount, amountReceived, swap.minimumExchangeRate)){
909             //this.log("Minimum rate failed", 0, 0x0);
910             revert("Minimum exchange rate not met");
911         }
912         if(swap.redirectAddress != msg.sender && swap.redirectAddress != address(0x0)){
913             //this.log("About to redirect tokens", amountReceived, 0x0);
914             uint256 destinationTokenIndex = findToken(balances,swap.trades[swap.trades.length-1].destinationToken);
915             uint256 amountToSend = Math.min(amountReceived, balances[destinationTokenIndex].balance);
916             transferTokens(balances, destinationTokenIndex, swap.redirectAddress, amountToSend);
917             removeBalance(balances, swap.trades[swap.trades.length-1].destinationToken, amountToSend);
918         }
919     }
920 
921     function performTrade(
922         Trade memory trade, 
923         TokenBalance[20] memory balances,
924         uint256 availableToSpend
925     ) 
926         internal returns (uint256 totalSpent, uint256 totalReceived)
927     {
928         uint256 tempSpent = 0;
929         uint256 tempReceived = 0;
930         for(uint256 orderIndex = 0; orderIndex < trade.orders.length; orderIndex++){
931             if((availableToSpend - totalSpent) * 10000 < availableToSpend){
932                 break;
933             } else if(!trade.isSourceAmount && tempReceived == trade.amount){
934                 break;
935             } else if (trade.isSourceAmount && tempSpent == trade.amount){
936                 break;
937             }
938             //this.log("About to perform order", orderIndex,0x0);
939             (tempSpent, tempReceived) = performOrder(
940                 trade.orders[orderIndex], 
941                 availableToSpend - totalSpent,
942                 trade.isSourceAmount ? availableToSpend - totalSpent : trade.amount - totalReceived, 
943                 trade.isSourceAmount,
944                 trade.sourceToken, 
945                 balances);
946             //this.log("Order performed",0,0x0);
947             totalSpent += tempSpent;
948             totalReceived += tempReceived;
949         }
950         addBalance(balances, trade.destinationToken, totalReceived);
951         removeBalance(balances, trade.sourceToken, totalSpent);
952         //this.log("Trade performed",tempSpent, 0);
953     }
954 
955     function performOrder(
956         Order memory order, 
957         uint256 availableToSpend,
958         uint256 targetAmount,
959         bool isSourceAmount,
960         address tokenToSpend,
961         TokenBalance[20] memory balances
962     )
963         internal returns (uint256 spent, uint256 received)
964     {
965         //this.log("Performing order", availableToSpend, 0x0);
966 
967         if(tokenToSpend == Utils.eth_address()){
968             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder.value(availableToSpend)(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
969 
970         } else {
971             transferTokens(balances, findToken(balances, tokenToSpend), order.exchangeHandler, availableToSpend);
972             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
973         }
974         //this.log("Performing order", spent,0x0);
975         //this.log("Performing order", received,0x0);
976     }
977 
978     function minimumRateFailed(
979         address sourceToken,
980         address destinationToken,
981         uint256 sourceAmount,
982         uint256 destinationAmount,
983         uint256 minimumExchangeRate
984     )
985         internal returns(bool failed)
986     {
987         //this.log("About to get source decimals",sourceAmount,0x0);
988         uint256 sourceDecimals = sourceToken == Utils.eth_address() ? 18 : Utils.getDecimals(sourceToken);
989         //this.log("About to get destination decimals",destinationAmount,0x0);
990         uint256 destinationDecimals = destinationToken == Utils.eth_address() ? 18 : Utils.getDecimals(destinationToken);
991         //this.log("About to calculate amount got",0,0x0);
992         uint256 rateGot = Utils.calcRateFromQty(sourceAmount, destinationAmount, sourceDecimals, destinationDecimals);
993         //this.log("Minimum rate failed", rateGot, 0x0);
994         return rateGot < minimumExchangeRate;
995     }
996 
997     function takeFee(
998         TokenBalance[20] memory balances,
999         address token,
1000         address payable partnerContract,
1001         uint256 amountTraded
1002     )
1003         internal
1004         returns (uint256 feeAmount)
1005     {
1006         Partner partner = Partner(partnerContract);
1007         uint256 feePercentage = partner.getTotalFeePercentage();
1008         //this.log("Got fee percentage", feePercentage, 0x0);
1009         feeAmount = calculateFee(amountTraded, feePercentage);
1010         //this.log("Taking fee", feeAmount, 0);
1011         transferTokens(balances, findToken(balances, token), partnerContract, feeAmount);
1012         removeBalance(balances, findToken(balances, token), feeAmount);
1013         //this.log("Took fee", 0, 0x0);
1014         return feeAmount;
1015     }
1016 
1017     function transferFromSenderDifference(
1018         TokenBalance[20] memory balances,
1019         address token,
1020         uint256 sourceAmount
1021     )
1022         internal returns (bool)
1023     {
1024         if(token == Utils.eth_address()){
1025             if(sourceAmount>balances[0].balance){
1026                 //this.log("Not enough eth", 0,0x0);
1027                 return false;
1028             }
1029             //this.log("Enough eth", 0,0x0);
1030             return true;
1031         }
1032 
1033         uint256 tokenIndex = findToken(balances, token);
1034         if(sourceAmount>balances[tokenIndex].balance){
1035             //this.log("Transferring in token", 0,0x0);
1036             bool success;
1037             (success,) = address(tokenTransferProxy).call(abi.encodeWithSignature("transferFrom(address,address,address,uint256)", token, msg.sender, address(this), sourceAmount - balances[tokenIndex].balance));
1038             if(success){
1039                 //this.log("Got enough token", 0,0x0);
1040                 balances[tokenIndex].balance = sourceAmount;
1041                 return true;
1042             }
1043             //this.log("Didn't get enough token", 0,0x0);
1044             return false;
1045         }
1046         return true;
1047     }
1048 
1049     function transferAllTokensToUser(
1050         TokenBalance[20] memory balances
1051     )
1052         internal
1053     {
1054         //this.log("About to transfer all tokens", 0, 0x0);
1055         for(uint256 balanceIndex = 0; balanceIndex < balances.length; balanceIndex++){
1056             if(balanceIndex != 0 && balances[balanceIndex].tokenAddress == address(0x0)){
1057                 return;
1058             }
1059             //this.log("Transferring tokens", uint256(balances[balanceIndex].balance),0x0);
1060             transferTokens(balances, balanceIndex, msg.sender, balances[balanceIndex].balance);
1061         }
1062     }
1063 
1064 
1065 
1066     function transferTokens(
1067         TokenBalance[20] memory balances,
1068         uint256 tokenIndex,
1069         address payable destination,
1070         uint256 tokenAmount
1071     )
1072         internal
1073     {
1074         if(tokenAmount > 0){
1075             if(balances[tokenIndex].tokenAddress == Utils.eth_address()){
1076                 destination.transfer(tokenAmount);
1077             } else {
1078                 require(ERC20SafeTransfer.safeTransfer(balances[tokenIndex].tokenAddress, destination, tokenAmount),'Transfer failed');
1079             }
1080         }
1081     }
1082 
1083     function findToken(
1084         TokenBalance[20] memory balances,
1085         address token
1086     )
1087         internal pure returns (uint256)
1088     {
1089         for(uint256 index = 0; index < balances.length; index++){
1090             if(balances[index].tokenAddress == token){
1091                 return index;
1092             } else if (index != 0 && balances[index].tokenAddress == address(0x0)){
1093                 balances[index] = TokenBalance(token, 0);
1094                 return index;
1095             }
1096         }
1097     }
1098 
1099     function addBalance(
1100         TokenBalance[20] memory balances,
1101         address tokenAddress,
1102         uint256 amountToAdd
1103     )
1104         internal
1105         pure
1106     {
1107         uint256 tokenIndex = findToken(balances, tokenAddress);
1108         addBalance(balances, tokenIndex, amountToAdd);
1109     }
1110 
1111     function addBalance(
1112         TokenBalance[20] memory balances,
1113         uint256 balanceIndex,
1114         uint256 amountToAdd
1115     )
1116         internal
1117         pure
1118     {
1119        balances[balanceIndex].balance += amountToAdd;
1120     }
1121 
1122     function removeBalance(
1123         TokenBalance[20] memory balances,
1124         address tokenAddress,
1125         uint256 amountToRemove
1126     )
1127         internal
1128         pure
1129     {
1130         uint256 tokenIndex = findToken(balances, tokenAddress);
1131         removeBalance(balances, tokenIndex, amountToRemove);
1132     }
1133 
1134     function removeBalance(
1135         TokenBalance[20] memory balances,
1136         uint256 balanceIndex,
1137         uint256 amountToRemove
1138     )
1139         internal
1140         pure
1141     {
1142         balances[balanceIndex].balance -= amountToRemove;
1143     }
1144 
1145     // @notice Calculates the fee amount given a fee percentage and amount
1146     // @param amount the amount to calculate the fee based on
1147     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1148     function calculateFee(uint256 amount, uint256 fee) internal pure returns (uint256){
1149         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1150     }
1151 
1152     /*
1153     *   Payable fallback function
1154     */
1155 
1156     /// @notice payable fallback to allow handler or exchange contracts to return ether
1157     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1158     function() external payable whenNotPaused {
1159         // Check in here that the sender is a contract! (to stop accidents)
1160         uint256 size;
1161         address sender = msg.sender;
1162         assembly {
1163             size := extcodesize(sender)
1164         }
1165         if (size == 0) {
1166             revert("EOA cannot send ether to primary fallback");
1167         }
1168     }
1169     event Log(string a, uint256 b, bytes32 c);
1170 
1171     function log(string memory a, uint256 b, bytes32 c) public {
1172         emit Log(a,b,c);
1173     }
1174 }