1 pragma solidity 0.4.25;
2 
3 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
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
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity-v1.12.0/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: contracts/utils/Adminable.sol
104 
105 /**
106  * @title Adminable.
107  */
108 contract Adminable is Claimable {
109     address[] public adminArray;
110 
111     struct AdminInfo {
112         bool valid;
113         uint256 index;
114     }
115 
116     mapping(address => AdminInfo) public adminTable;
117 
118     event AdminAccepted(address indexed _admin);
119     event AdminRejected(address indexed _admin);
120 
121     /**
122      * @dev Reverts if called by any account other than one of the administrators.
123      */
124     modifier onlyAdmin() {
125         require(adminTable[msg.sender].valid, "caller is illegal");
126         _;
127     }
128 
129     /**
130      * @dev Accept a new administrator.
131      * @param _admin The administrator's address.
132      */
133     function accept(address _admin) external onlyOwner {
134         require(_admin != address(0), "administrator is illegal");
135         AdminInfo storage adminInfo = adminTable[_admin];
136         require(!adminInfo.valid, "administrator is already accepted");
137         adminInfo.valid = true;
138         adminInfo.index = adminArray.length;
139         adminArray.push(_admin);
140         emit AdminAccepted(_admin);
141     }
142 
143     /**
144      * @dev Reject an existing administrator.
145      * @param _admin The administrator's address.
146      */
147     function reject(address _admin) external onlyOwner {
148         AdminInfo storage adminInfo = adminTable[_admin];
149         require(adminArray.length > adminInfo.index, "administrator is already rejected");
150         require(_admin == adminArray[adminInfo.index], "administrator is already rejected");
151         // at this point we know that adminArray.length > adminInfo.index >= 0
152         address lastAdmin = adminArray[adminArray.length - 1]; // will never underflow
153         adminTable[lastAdmin].index = adminInfo.index;
154         adminArray[adminInfo.index] = lastAdmin;
155         adminArray.length -= 1; // will never underflow
156         delete adminTable[_admin];
157         emit AdminRejected(_admin);
158     }
159 
160     /**
161      * @dev Get an array of all the administrators.
162      * @return An array of all the administrators.
163      */
164     function getAdminArray() external view returns (address[] memory) {
165         return adminArray;
166     }
167 
168     /**
169      * @dev Get the total number of administrators.
170      * @return The total number of administrators.
171      */
172     function getAdminCount() external view returns (uint256) {
173         return adminArray.length;
174     }
175 }
176 
177 // File: contracts/saga/interfaces/ITransactionLimiter.sol
178 
179 /**
180  * @title Transaction Limiter Interface.
181  */
182 interface ITransactionLimiter {
183     /**
184      * @dev Reset the total buy-amount and the total sell-amount.
185      */
186     function resetTotal() external;
187 
188     /**
189      * @dev Increment the total buy-amount.
190      * @param _amount The amount to increment by.
191      */
192     function incTotalBuy(uint256 _amount) external;
193 
194     /**
195      * @dev Increment the total sell-amount.
196      * @param _amount The amount to increment by.
197      */
198     function incTotalSell(uint256 _amount) external;
199 }
200 
201 // File: contracts/saga/interfaces/IETHConverter.sol
202 
203 /**
204  * @title ETH Converter Interface.
205  */
206 interface IETHConverter {
207     /**
208      * @dev Get the current SDR worth of a given ETH amount.
209      * @param _ethAmount The amount of ETH to convert.
210      * @return The equivalent amount of SDR.
211      */
212     function toSdrAmount(uint256 _ethAmount) external view returns (uint256);
213 
214     /**
215      * @dev Get the current ETH worth of a given SDR amount.
216      * @param _sdrAmount The amount of SDR to convert.
217      * @return The equivalent amount of ETH.
218      */
219     function toEthAmount(uint256 _sdrAmount) external view returns (uint256);
220 
221     /**
222      * @dev Get the original SDR worth of a converted ETH amount.
223      * @param _ethAmount The amount of ETH converted.
224      * @return The original amount of SDR.
225      */
226     function fromEthAmount(uint256 _ethAmount) external view returns (uint256);
227 }
228 
229 // File: contracts/saga/interfaces/IRateApprover.sol
230 
231 /**
232  * @title Rate Approver Interface.
233  */
234 interface IRateApprover {
235     /**
236      * @dev Approve high rate.
237      * @param _highRateN The numerator of the high rate.
238      * @param _highRateD The denominator of the high rate.
239      * @return Success flag.
240      */
241     function approveHighRate(uint256 _highRateN, uint256 _highRateD) external view  returns (bool);
242 
243     /**
244     * @dev Approve low rate.
245     * @param _lowRateN The numerator of the low rate.
246     * @param _lowRateD The denominator of the low rate.
247     * @return Success flag.
248     */
249     function approveLowRate(uint256 _lowRateN, uint256 _lowRateD) external view  returns (bool);
250 }
251 
252 // File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol
253 
254 /**
255  * @title Contract Address Locator Interface.
256  */
257 interface IContractAddressLocator {
258     /**
259      * @dev Get the contract address mapped to a given identifier.
260      * @param _identifier The identifier.
261      * @return The contract address.
262      */
263     function getContractAddress(bytes32 _identifier) external view returns (address);
264 
265     /**
266      * @dev Determine whether or not a contract address relates to one of the identifiers.
267      * @param _contractAddress The contract address to look for.
268      * @param _identifiers The identifiers.
269      * @return A boolean indicating if the contract address relates to one of the identifiers.
270      */
271     function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);
272 }
273 
274 // File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol
275 
276 /**
277  * @title Contract Address Locator Holder.
278  * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.
279  * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.
280  * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.
281  * @dev In addition to that, any function in any contract can be restricted to a specific caller.
282  */
283 contract ContractAddressLocatorHolder {
284     bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";
285     bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;
286     bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;
287     bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;
288     bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;
289     bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;
290     bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;
291     bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;
292     bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;
293     bytes32 internal constant _IMintListener_            = "IMintListener"           ;
294     bytes32 internal constant _IMintManager_             = "IMintManager"            ;
295     bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;
296     bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;
297     bytes32 internal constant _IRedButton_               = "IRedButton"              ;
298     bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;
299     bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;
300     bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;
301     bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;
302     bytes32 internal constant _ISGAAuthorizationManager_ = "ISGAAuthorizationManager";
303     bytes32 internal constant _ISGAToken_                = "ISGAToken"               ;
304     bytes32 internal constant _ISGATokenManager_         = "ISGATokenManager"        ;
305     bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";
306     bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;
307     bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;
308     bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;
309     bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;
310     bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;
311     bytes32 internal constant _BuyWalletsTradingDataSource_       = "BuyWalletsTradingDataSource"      ;
312     bytes32 internal constant _SellWalletsTradingDataSource_       = "SellWalletsTradingDataSource"      ;
313     bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;
314     bytes32 internal constant _BuyWalletsTradingLimiter_SGATokenManager_          = "BuyWalletsTLSGATokenManager"         ;
315     bytes32 internal constant _SellWalletsTradingLimiter_SGATokenManager_          = "SellWalletsTLSGATokenManager"         ;
316     bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;
317     bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;
318     bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;
319     bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;
320 
321     IContractAddressLocator private contractAddressLocator;
322 
323     /**
324      * @dev Create the contract.
325      * @param _contractAddressLocator The contract address locator.
326      */
327     constructor(IContractAddressLocator _contractAddressLocator) internal {
328         require(_contractAddressLocator != address(0), "locator is illegal");
329         contractAddressLocator = _contractAddressLocator;
330     }
331 
332     /**
333      * @dev Get the contract address locator.
334      * @return The contract address locator.
335      */
336     function getContractAddressLocator() external view returns (IContractAddressLocator) {
337         return contractAddressLocator;
338     }
339 
340     /**
341      * @dev Get the contract address mapped to a given identifier.
342      * @param _identifier The identifier.
343      * @return The contract address.
344      */
345     function getContractAddress(bytes32 _identifier) internal view returns (address) {
346         return contractAddressLocator.getContractAddress(_identifier);
347     }
348 
349 
350 
351     /**
352      * @dev Determine whether or not the sender relates to one of the identifiers.
353      * @param _identifiers The identifiers.
354      * @return A boolean indicating if the sender relates to one of the identifiers.
355      */
356     function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {
357         return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);
358     }
359 
360     /**
361      * @dev Verify that the caller is mapped to a given identifier.
362      * @param _identifier The identifier.
363      */
364     modifier only(bytes32 _identifier) {
365         require(msg.sender == getContractAddress(_identifier), "caller is illegal");
366         _;
367     }
368 
369 }
370 
371 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
372 
373 /**
374  * @title SafeMath
375  * @dev Math operations with safety checks that revert on error
376  */
377 library SafeMath {
378 
379   /**
380   * @dev Multiplies two numbers, reverts on overflow.
381   */
382   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
383     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
384     // benefit is lost if 'b' is also tested.
385     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
386     if (a == 0) {
387       return 0;
388     }
389 
390     uint256 c = a * b;
391     require(c / a == b);
392 
393     return c;
394   }
395 
396   /**
397   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
398   */
399   function div(uint256 a, uint256 b) internal pure returns (uint256) {
400     require(b > 0); // Solidity only automatically asserts when dividing by 0
401     uint256 c = a / b;
402     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
403 
404     return c;
405   }
406 
407   /**
408   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
409   */
410   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
411     require(b <= a);
412     uint256 c = a - b;
413 
414     return c;
415   }
416 
417   /**
418   * @dev Adds two numbers, reverts on overflow.
419   */
420   function add(uint256 a, uint256 b) internal pure returns (uint256) {
421     uint256 c = a + b;
422     require(c >= a);
423 
424     return c;
425   }
426 
427   /**
428   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
429   * reverts when dividing by zero.
430   */
431   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
432     require(b != 0);
433     return a % b;
434   }
435 }
436 
437 // File: contracts/saga/ETHConverter.sol
438 
439 /**
440  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
441  */
442 
443 /**
444  * @title ETH Converter.
445  */
446 contract ETHConverter is IETHConverter, ContractAddressLocatorHolder, Adminable {
447     string public constant VERSION = "1.1.0";
448 
449     using SafeMath for uint256;
450 
451     /**
452      * @dev SDR/ETH price maximum resolution.
453      * @notice Allow for sufficiently-high resolution.
454      * @notice Prevents multiplication-overflow.
455      */
456     uint256 public constant MAX_RESOLUTION = 0x10000000000000000;
457 
458     uint256 public sequenceNum = 0;
459     uint256 public highPriceN = 0;
460     uint256 public highPriceD = 0;
461     uint256 public lowPriceN = 0;
462     uint256 public lowPriceD = 0;
463 
464     event PriceSaved(uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD);
465     event PriceNotSaved(uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD);
466 
467     /*
468      * @dev Create the contract.
469      * @param _contractAddressLocator The contract address locator.
470      */
471     constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}
472 
473     /**
474      * @dev Return the contract which implements the ITransactionLimiter interface.
475      */
476     function getTransactionLimiter() public view returns (ITransactionLimiter) {
477         return ITransactionLimiter(getContractAddress(_ITransactionLimiter_));
478     }
479 
480     /**
481      * @dev Return the contract which implements the IRateApprover interface.
482      */
483     function getRateApprover() public view returns (IRateApprover) {
484         return IRateApprover(getContractAddress(_IRateApprover_));
485     }
486 
487     /**
488      * @dev throw if called when low rate is not approved.
489      */
490     modifier onlyApprovedLowRate() {
491         bool success = getRateApprover().approveLowRate(lowPriceN, lowPriceD);
492         require(success, "invalid ETH-SDR rate");
493         _;
494     }
495 
496     /**
497      * @dev throw if called when high rate is not approved.
498      */
499     modifier onlyApprovedHighRate() {
500         bool success = getRateApprover().approveHighRate(highPriceN, highPriceD);
501         require(success, "invalid ETH-SDR rate");
502         _;
503     }
504 
505     /**
506      * @dev Set the SDR/ETH high price and the SDR/ETH low price.
507      * @param _sequenceNum The sequence-number of the operation.
508      * @param _highPriceN The numerator of the SDR/ETH high price.
509      * @param _highPriceD The denominator of the SDR/ETH high price.
510      * @param _lowPriceN The numerator of the SDR/ETH low price.
511      * @param _lowPriceD The denominator of the SDR/ETH low price.
512      */
513     function setPrice(uint256 _sequenceNum, uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD) external onlyAdmin {
514         require(1 <= _highPriceN && _highPriceN <= MAX_RESOLUTION, "high price numerator is out of range");
515         require(1 <= _highPriceD && _highPriceD <= MAX_RESOLUTION, "high price denominator is out of range");
516         require(1 <= _lowPriceN && _lowPriceN <= MAX_RESOLUTION, "low price numerator is out of range");
517         require(1 <= _lowPriceD && _lowPriceD <= MAX_RESOLUTION, "low price denominator is out of range");
518         require(_highPriceN * _lowPriceD >= _highPriceD * _lowPriceN, "high price is smaller than low price");
519         //will never overflow (MAX_RESOLUTION = 2^64 )
520 
521         if (sequenceNum < _sequenceNum) {
522             sequenceNum = _sequenceNum;
523             highPriceN = _highPriceN;
524             highPriceD = _highPriceD;
525             lowPriceN = _lowPriceN;
526             lowPriceD = _lowPriceD;
527             getTransactionLimiter().resetTotal();
528             emit PriceSaved(_highPriceN, _highPriceD, _lowPriceN, _lowPriceD);
529         }
530         else {
531             emit PriceNotSaved(_highPriceN, _highPriceD, _lowPriceN, _lowPriceD);
532         }
533     }
534 
535     /**
536      * @dev Get the current SDR worth of a given ETH amount.
537      * @param _ethAmount The amount of ETH to convert.
538      * @return The equivalent amount of SDR.
539      */
540     function toSdrAmount(uint256 _ethAmount) external view onlyApprovedLowRate returns (uint256) {
541         return _ethAmount.mul(lowPriceN) / lowPriceD;
542     }
543 
544     /**
545      * @dev Get the current ETH worth of a given SDR amount.
546      * @param _sdrAmount The amount of SDR to convert.
547      * @return The equivalent amount of ETH.
548      */
549     function toEthAmount(uint256 _sdrAmount) external view onlyApprovedHighRate returns (uint256) {
550         return _sdrAmount.mul(highPriceD) / highPriceN;
551     }
552 
553     /**
554      * @dev Get the original SDR worth of a converted ETH amount.
555      * @param _ethAmount The amount of ETH converted.
556      * @return The original amount of SDR.
557      */
558     function fromEthAmount(uint256 _ethAmount) external view returns (uint256) {
559         return _ethAmount.mul(highPriceN) / highPriceD;
560     }
561 }