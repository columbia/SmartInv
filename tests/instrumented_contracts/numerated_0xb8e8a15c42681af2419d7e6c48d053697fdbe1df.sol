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
236      * @dev Approve high and low rate.
237      * @param _highRateN The numerator of the high rate.
238      * @param _highRateD The denominator of the high rate.
239      * @param _lowRateN The numerator of the low rate.
240      * @param _lowRateD The denominator of the low rate.
241      * @return Success flag and error reason.
242      */
243     function approveRate(uint256 _highRateN, uint256 _highRateD, uint256 _lowRateN, uint256 _lowRateD) external view  returns (bool, string);
244 }
245 
246 // File: contracts/contract_address_locator/interfaces/IContractAddressLocator.sol
247 
248 /**
249  * @title Contract Address Locator Interface.
250  */
251 interface IContractAddressLocator {
252     /**
253      * @dev Get the contract address mapped to a given identifier.
254      * @param _identifier The identifier.
255      * @return The contract address.
256      */
257     function getContractAddress(bytes32 _identifier) external view returns (address);
258 
259     /**
260      * @dev Determine whether or not a contract address relates to one of the identifiers.
261      * @param _contractAddress The contract address to look for.
262      * @param _identifiers The identifiers.
263      * @return A boolean indicating if the contract address relates to one of the identifiers.
264      */
265     function isContractAddressRelates(address _contractAddress, bytes32[] _identifiers) external view returns (bool);
266 }
267 
268 // File: contracts/contract_address_locator/ContractAddressLocatorHolder.sol
269 
270 /**
271  * @title Contract Address Locator Holder.
272  * @dev Hold a contract address locator, which maps a unique identifier to every contract address in the system.
273  * @dev Any contract which inherits from this contract can retrieve the address of any contract in the system.
274  * @dev Thus, any contract can remain "oblivious" to the replacement of any other contract in the system.
275  * @dev In addition to that, any function in any contract can be restricted to a specific caller.
276  */
277 contract ContractAddressLocatorHolder {
278     bytes32 internal constant _IAuthorizationDataSource_ = "IAuthorizationDataSource";
279     bytes32 internal constant _ISGNConversionManager_    = "ISGNConversionManager"      ;
280     bytes32 internal constant _IModelDataSource_         = "IModelDataSource"        ;
281     bytes32 internal constant _IPaymentHandler_          = "IPaymentHandler"            ;
282     bytes32 internal constant _IPaymentManager_          = "IPaymentManager"            ;
283     bytes32 internal constant _IPaymentQueue_            = "IPaymentQueue"              ;
284     bytes32 internal constant _IReconciliationAdjuster_  = "IReconciliationAdjuster"      ;
285     bytes32 internal constant _IIntervalIterator_        = "IIntervalIterator"       ;
286     bytes32 internal constant _IMintHandler_             = "IMintHandler"            ;
287     bytes32 internal constant _IMintListener_            = "IMintListener"           ;
288     bytes32 internal constant _IMintManager_             = "IMintManager"            ;
289     bytes32 internal constant _IPriceBandCalculator_     = "IPriceBandCalculator"       ;
290     bytes32 internal constant _IModelCalculator_         = "IModelCalculator"        ;
291     bytes32 internal constant _IRedButton_               = "IRedButton"              ;
292     bytes32 internal constant _IReserveManager_          = "IReserveManager"         ;
293     bytes32 internal constant _ISagaExchanger_           = "ISagaExchanger"          ;
294     bytes32 internal constant _IMonetaryModel_               = "IMonetaryModel"              ;
295     bytes32 internal constant _IMonetaryModelState_          = "IMonetaryModelState"         ;
296     bytes32 internal constant _ISGAAuthorizationManager_ = "ISGAAuthorizationManager";
297     bytes32 internal constant _ISGAToken_                = "ISGAToken"               ;
298     bytes32 internal constant _ISGATokenManager_         = "ISGATokenManager"        ;
299     bytes32 internal constant _ISGNAuthorizationManager_ = "ISGNAuthorizationManager";
300     bytes32 internal constant _ISGNToken_                = "ISGNToken"               ;
301     bytes32 internal constant _ISGNTokenManager_         = "ISGNTokenManager"        ;
302     bytes32 internal constant _IMintingPointTimersManager_             = "IMintingPointTimersManager"            ;
303     bytes32 internal constant _ITradingClasses_          = "ITradingClasses"         ;
304     bytes32 internal constant _IWalletsTradingLimiterValueConverter_        = "IWalletsTLValueConverter"       ;
305     bytes32 internal constant _IWalletsTradingDataSource_       = "IWalletsTradingDataSource"      ;
306     bytes32 internal constant _WalletsTradingLimiter_SGNTokenManager_          = "WalletsTLSGNTokenManager"         ;
307     bytes32 internal constant _WalletsTradingLimiter_SGATokenManager_          = "WalletsTLSGATokenManager"         ;
308     bytes32 internal constant _IETHConverter_             = "IETHConverter"   ;
309     bytes32 internal constant _ITransactionLimiter_      = "ITransactionLimiter"     ;
310     bytes32 internal constant _ITransactionManager_      = "ITransactionManager"     ;
311     bytes32 internal constant _IRateApprover_      = "IRateApprover"     ;
312 
313     IContractAddressLocator private contractAddressLocator;
314 
315     /**
316      * @dev Create the contract.
317      * @param _contractAddressLocator The contract address locator.
318      */
319     constructor(IContractAddressLocator _contractAddressLocator) internal {
320         require(_contractAddressLocator != address(0), "locator is illegal");
321         contractAddressLocator = _contractAddressLocator;
322     }
323 
324     /**
325      * @dev Get the contract address locator.
326      * @return The contract address locator.
327      */
328     function getContractAddressLocator() external view returns (IContractAddressLocator) {
329         return contractAddressLocator;
330     }
331 
332     /**
333      * @dev Get the contract address mapped to a given identifier.
334      * @param _identifier The identifier.
335      * @return The contract address.
336      */
337     function getContractAddress(bytes32 _identifier) internal view returns (address) {
338         return contractAddressLocator.getContractAddress(_identifier);
339     }
340 
341 
342 
343     /**
344      * @dev Determine whether or not the sender relates to one of the identifiers.
345      * @param _identifiers The identifiers.
346      * @return A boolean indicating if the sender relates to one of the identifiers.
347      */
348     function isSenderAddressRelates(bytes32[] _identifiers) internal view returns (bool) {
349         return contractAddressLocator.isContractAddressRelates(msg.sender, _identifiers);
350     }
351 
352     /**
353      * @dev Verify that the caller is mapped to a given identifier.
354      * @param _identifier The identifier.
355      */
356     modifier only(bytes32 _identifier) {
357         require(msg.sender == getContractAddress(_identifier), "caller is illegal");
358         _;
359     }
360 
361 }
362 
363 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
364 
365 /**
366  * @title SafeMath
367  * @dev Math operations with safety checks that revert on error
368  */
369 library SafeMath {
370 
371   /**
372   * @dev Multiplies two numbers, reverts on overflow.
373   */
374   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
375     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
376     // benefit is lost if 'b' is also tested.
377     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
378     if (a == 0) {
379       return 0;
380     }
381 
382     uint256 c = a * b;
383     require(c / a == b);
384 
385     return c;
386   }
387 
388   /**
389   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
390   */
391   function div(uint256 a, uint256 b) internal pure returns (uint256) {
392     require(b > 0); // Solidity only automatically asserts when dividing by 0
393     uint256 c = a / b;
394     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
395 
396     return c;
397   }
398 
399   /**
400   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
401   */
402   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403     require(b <= a);
404     uint256 c = a - b;
405 
406     return c;
407   }
408 
409   /**
410   * @dev Adds two numbers, reverts on overflow.
411   */
412   function add(uint256 a, uint256 b) internal pure returns (uint256) {
413     uint256 c = a + b;
414     require(c >= a);
415 
416     return c;
417   }
418 
419   /**
420   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
421   * reverts when dividing by zero.
422   */
423   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
424     require(b != 0);
425     return a % b;
426   }
427 }
428 
429 // File: contracts/saga/ETHConverter.sol
430 
431 /**
432  * Details of usage of licenced software see here: https://www.saga.org/software/readme_v1
433  */
434 
435 /**
436  * @title ETH Converter.
437  */
438 contract ETHConverter is IETHConverter, ContractAddressLocatorHolder, Adminable {
439     string public constant VERSION = "1.0.0";
440 
441     using SafeMath for uint256;
442 
443     /**
444      * @dev SDR/ETH price maximum resolution.
445      * @notice Allow for sufficiently-high resolution.
446      * @notice Prevents multiplication-overflow.
447      */
448     uint256 public constant MAX_RESOLUTION = 0x10000000000000000;
449 
450     uint256 public sequenceNum = 0;
451     uint256 public highPriceN = 0;
452     uint256 public highPriceD = 0;
453     uint256 public lowPriceN = 0;
454     uint256 public lowPriceD = 0;
455 
456     event PriceSaved(uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD);
457     event PriceNotSaved(uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD);
458 
459     /*
460      * @dev Create the contract.
461      * @param _contractAddressLocator The contract address locator.
462      */
463     constructor(IContractAddressLocator _contractAddressLocator) ContractAddressLocatorHolder(_contractAddressLocator) public {}
464 
465     /**
466      * @dev Return the contract which implements the ITransactionLimiter interface.
467      */
468     function getTransactionLimiter() public view returns (ITransactionLimiter) {
469         return ITransactionLimiter(getContractAddress(_ITransactionLimiter_));
470     }
471 
472     /**
473      * @dev Return the contract which implements the IRateApprover interface.
474      */
475     function getRateApprover() public view returns (IRateApprover) {
476         return IRateApprover(getContractAddress(_IRateApprover_));
477     }
478 
479     /**
480     * @dev throw if called before high price set.
481     */
482     modifier onlyIfHighPriceSet() {
483         assert(highPriceN > 0 && highPriceD > 0);
484         _;
485     }
486 
487     /**
488     * @dev throw if called before low price set.
489     */
490     modifier onlyIfLowPriceSet() {
491         assert(lowPriceN > 0 && lowPriceD > 0);
492         _;
493     }
494 
495     /**
496      * @dev Set the SDR/ETH high price and the SDR/ETH low price.
497      * @param _sequenceNum The sequence-number of the operation.
498      * @param _highPriceN The numerator of the SDR/ETH high price.
499      * @param _highPriceD The denominator of the SDR/ETH high price.
500      * @param _lowPriceN The numerator of the SDR/ETH low price.
501      * @param _lowPriceD The denominator of the SDR/ETH low price.
502      */
503     function setPrice(uint256 _sequenceNum, uint256 _highPriceN, uint256 _highPriceD, uint256 _lowPriceN, uint256 _lowPriceD) external onlyAdmin  {
504         require(1 <= _highPriceN && _highPriceN <= MAX_RESOLUTION, "high price numerator is out of range");
505         require(1 <= _highPriceD && _highPriceD <= MAX_RESOLUTION, "high price denominator is out of range");
506         require(1 <= _lowPriceN && _lowPriceN <= MAX_RESOLUTION, "low price numerator is out of range");
507         require(1 <= _lowPriceD && _lowPriceD <= MAX_RESOLUTION, "low price denominator is out of range");
508         require(_highPriceN * _lowPriceD >= _highPriceD * _lowPriceN, "high price is smaller than low price");//will never overflow (MAX_RESOLUTION = 2^64 )
509 
510         (bool success, string memory reason) = getRateApprover().approveRate(_highPriceN, _highPriceD, _lowPriceN, _lowPriceD);
511         require(success, reason);
512 
513         if (sequenceNum < _sequenceNum) {
514             sequenceNum = _sequenceNum;
515             highPriceN = _highPriceN;
516             highPriceD = _highPriceD;
517             lowPriceN = _lowPriceN;
518             lowPriceD = _lowPriceD;
519             getTransactionLimiter().resetTotal();
520             emit PriceSaved(_highPriceN, _highPriceD, _lowPriceN, _lowPriceD);
521         }
522         else {
523             emit PriceNotSaved(_highPriceN, _highPriceD, _lowPriceN, _lowPriceD);
524         }
525     }
526 
527     /**
528      * @dev Get the current SDR worth of a given ETH amount.
529      * @param _ethAmount The amount of ETH to convert.
530      * @return The equivalent amount of SDR.
531      */
532     function toSdrAmount(uint256 _ethAmount) external view onlyIfLowPriceSet returns (uint256) {
533         return _ethAmount.mul(lowPriceN) / lowPriceD;
534     }
535 
536     /**
537      * @dev Get the current ETH worth of a given SDR amount.
538      * @param _sdrAmount The amount of SDR to convert.
539      * @return The equivalent amount of ETH.
540      */
541     function toEthAmount(uint256 _sdrAmount) external view onlyIfHighPriceSet returns (uint256) {
542         return _sdrAmount.mul(highPriceD) / highPriceN;
543     }
544 
545     /**
546      * @dev Get the original SDR worth of a converted ETH amount.
547      * @param _ethAmount The amount of ETH converted.
548      * @return The original amount of SDR.
549      */
550     function fromEthAmount(uint256 _ethAmount) external view onlyIfHighPriceSet returns (uint256) {
551         return _ethAmount.mul(highPriceN) / highPriceD;
552     }
553 }
