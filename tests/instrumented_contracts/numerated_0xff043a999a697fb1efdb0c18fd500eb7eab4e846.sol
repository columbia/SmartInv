1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() public onlyOwner whenNotPaused {
105     paused = true;
106     emit Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() public onlyOwner whenPaused {
113     paused = false;
114     emit Unpause();
115   }
116 }
117 
118 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
119 
120 pragma solidity ^0.4.24;
121 
122 
123 /**
124  * @title SafeMath
125  * @dev Math operations with safety checks that throw on error
126  */
127 library SafeMath {
128 
129   /**
130   * @dev Multiplies two numbers, throws on overflow.
131   */
132   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
133     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
134     // benefit is lost if 'b' is also tested.
135     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
136     if (_a == 0) {
137       return 0;
138     }
139 
140     c = _a * _b;
141     assert(c / _a == _b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
149     // assert(_b > 0); // Solidity automatically throws when dividing by 0
150     // uint256 c = _a / _b;
151     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
152     return _a / _b;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
159     assert(_b <= _a);
160     return _a - _b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
167     c = _a + _b;
168     assert(c >= _a);
169     return c;
170   }
171 }
172 
173 // File: contracts/v2/tools/SelfServiceAccessControls.sol
174 
175 contract SelfServiceAccessControls is Ownable {
176 
177   // Simple map to only allow certain artist create editions at first
178   mapping(address => bool) public allowedArtists;
179 
180   // When true any existing KO artist can mint their own editions
181   bool public openToAllArtist = false;
182 
183   /**
184    * @dev Controls is the contract is open to all
185    * @dev Only callable from owner
186    */
187   function setOpenToAllArtist(bool _openToAllArtist) onlyOwner public {
188     openToAllArtist = _openToAllArtist;
189   }
190 
191   /**
192    * @dev Controls who can call this contract
193    * @dev Only callable from owner
194    */
195   function setAllowedArtist(address _artist, bool _allowed) onlyOwner public {
196     allowedArtists[_artist] = _allowed;
197   }
198 
199   /**
200    * @dev Checks to see if the account can create editions
201    */
202   function isEnabledForAccount(address account) public view returns (bool) {
203     if (openToAllArtist) {
204       return true;
205     }
206     return allowedArtists[account];
207   }
208 
209   /**
210    * @dev Allows for the ability to extract stuck ether
211    * @dev Only callable from owner
212    */
213   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
214     require(_withdrawalAccount != address(0), "Invalid address provided");
215     _withdrawalAccount.transfer(address(this).balance);
216   }
217 }
218 
219 // File: contracts/v2/tools/SelfServiceEditionCurationV2.sol
220 
221 pragma solidity 0.4.24;
222 
223 
224 
225 
226 
227 interface IKODAV2SelfServiceEditionCuration {
228 
229   function createActiveEdition(
230     uint256 _editionNumber,
231     bytes32 _editionData,
232     uint256 _editionType,
233     uint256 _startDate,
234     uint256 _endDate,
235     address _artistAccount,
236     uint256 _artistCommission,
237     uint256 _priceInWei,
238     string _tokenUri,
239     uint256 _totalAvailable
240   ) external returns (bool);
241 
242   function artistsEditions(address _artistsAccount) external returns (uint256[1] _editionNumbers);
243 
244   function totalAvailableEdition(uint256 _editionNumber) external returns (uint256);
245 
246   function highestEditionNumber() external returns (uint256);
247 }
248 
249 interface IKODAAuction {
250   function setArtistsControlAddressAndEnabledEdition(uint256 _editionNumber, address _address) external;
251 }
252 
253 contract SelfServiceEditionCurationV2 is Ownable, Pausable {
254   using SafeMath for uint256;
255 
256   event SelfServiceEditionCreated(
257     uint256 indexed _editionNumber,
258     address indexed _creator,
259     uint256 _priceInWei,
260     uint256 _totalAvailable,
261     bool _enableAuction
262   );
263 
264   // Calling address
265   IKODAV2SelfServiceEditionCuration public kodaV2;
266   IKODAAuction public auction;
267   SelfServiceAccessControls public accessControls;
268 
269   // Default artist commission
270   uint256 public artistCommission = 85;
271 
272   // Config which enforces editions to not be over this size
273   uint256 public maxEditionSize = 100;
274 
275   // Config the minimum price per edition
276   uint256 public minPricePerEdition = 0;
277 
278   // When true this will skip the invocation in time period check
279   bool public disableInvocationCheck = false;
280 
281   // Max number of editions to be created in the time period
282   uint256 public maxInvocations = 1;
283 
284   // The rolling time period for max number of invocations
285   uint256 public maxInvocationsTimePeriod = 1 days;
286 
287   // Number of invocations the caller has performed in the time period
288   mapping(address => uint256) public invocationsInTimePeriod;
289 
290   // When the current time period started
291   mapping(address => uint256) public timeOfFirstInvocationInPeriod;
292 
293   /**
294    * @dev Construct a new instance of the contract
295    */
296   constructor(
297     IKODAV2SelfServiceEditionCuration _kodaV2,
298     IKODAAuction _auction,
299     SelfServiceAccessControls _accessControls
300   ) public {
301     kodaV2 = _kodaV2;
302     auction = _auction;
303     accessControls = _accessControls;
304   }
305 
306   /**
307    * @dev Called by artists, create new edition on the KODA platform
308    */
309   function createEdition(
310     uint256 _totalAvailable,
311     uint256 _priceInWei,
312     uint256 _startDate,
313     string _tokenUri,
314     bool _enableAuction
315   )
316   public
317   whenNotPaused
318   returns (uint256 _editionNumber)
319   {
320     validateInvocations();
321     return _createEdition(msg.sender, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
322   }
323 
324   /**
325    * @dev Caller by owner, can create editions for other artists
326    * @dev Only callable from owner regardless of pause state
327    */
328   function createEditionFor(
329     address _artist,
330     uint256 _totalAvailable,
331     uint256 _priceInWei,
332     uint256 _startDate,
333     string _tokenUri,
334     bool _enableAuction
335   )
336   public
337   onlyOwner
338   returns (uint256 _editionNumber)
339   {
340     return _createEdition(_artist, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
341   }
342 
343   /**
344    * @dev Internal function for edition creation
345    */
346   function _createEdition(
347     address _artist,
348     uint256 _totalAvailable,
349     uint256 _priceInWei,
350     uint256 _startDate,
351     string _tokenUri,
352     bool _enableAuction
353   )
354   internal
355   returns (uint256 _editionNumber){
356 
357     // Enforce edition size
358     require(_totalAvailable > 0, "Must be at least one available in edition");
359     require(_totalAvailable <= maxEditionSize, "Must not exceed max edition size");
360 
361     // Enforce min price
362     require(_priceInWei >= minPricePerEdition, "Price must be greater than minimum");
363 
364     // If we are the owner, skip this artists check
365     if (msg.sender != owner) {
366 
367       // Enforce who can call this
368       if (!accessControls.openToAllArtist()) {
369         require(accessControls.allowedArtists(_artist), "Only allowed artists can create editions for now");
370       }
371     }
372 
373     // Find the next edition number we can use
374     uint256 editionNumber = getNextAvailableEditionNumber();
375 
376     // Attempt to create a new edition
377     require(
378       _createNewEdition(editionNumber, _artist, _totalAvailable, _priceInWei, _startDate, _tokenUri),
379       "Failed to create new edition"
380     );
381 
382     // Enable the auction if desired
383     if (_enableAuction) {
384       auction.setArtistsControlAddressAndEnabledEdition(editionNumber, _artist);
385     }
386 
387     // Trigger event
388     emit SelfServiceEditionCreated(editionNumber, _artist, _priceInWei, _totalAvailable, _enableAuction);
389 
390     return editionNumber;
391   }
392 
393   /**
394    * @dev Internal function for calling external create methods with some none configurable defaults
395    */
396   function _createNewEdition(
397     uint256 _editionNumber,
398     address _artist,
399     uint256 _totalAvailable,
400     uint256 _priceInWei,
401     uint256 _startDate,
402     string _tokenUri
403   )
404   internal
405   returns (bool) {
406     return kodaV2.createActiveEdition(
407       _editionNumber,
408       0x0, // _editionData - no edition data
409       1, // _editionType - KODA always type 1
410       _startDate,
411       0, // _endDate - 0 = MAX unit256
412       _artist,
413       artistCommission,
414       _priceInWei,
415       _tokenUri,
416       _totalAvailable
417     );
418   }
419 
420   function validateInvocations() internal {
421     if (disableInvocationCheck) {
422       return;
423     }
424     uint256 invocationPeriodStart = timeOfFirstInvocationInPeriod[msg.sender];
425 
426     // If we are new to this process or its been cleared, skip the check
427     if (invocationPeriodStart != 0) {
428 
429       // Work out how much time has passed
430       uint256 timePassedInPeriod = block.timestamp - invocationPeriodStart;
431 
432       // If we are still in this time period
433       if (timePassedInPeriod < maxInvocationsTimePeriod) {
434 
435         uint256 invocations = invocationsInTimePeriod[msg.sender];
436 
437         uint256 currentInvocation = invocations + 1;
438 
439         // Ensure the number of invocations does not exceed the max number of invocations allowed
440         require(currentInvocation <= maxInvocations, "Exceeded max invocations for time period");
441 
442         // Update the invocations for this period if passed validation check
443         invocationsInTimePeriod[msg.sender] = currentInvocation;
444 
445       } else {
446         // if we have passed the time period simple clear out the fields and start the period again
447         invocationsInTimePeriod[msg.sender] = 1;
448         timeOfFirstInvocationInPeriod[msg.sender] = block.timestamp;
449       }
450 
451     } else {
452       // initial the counters if not used before
453       invocationsInTimePeriod[msg.sender] = 1;
454       timeOfFirstInvocationInPeriod[msg.sender] = block.timestamp;
455     }
456   }
457 
458   /**
459    * @dev Internal function for dynamically generating the next KODA edition number
460    */
461   function getNextAvailableEditionNumber()
462   internal
463   returns (uint256 editionNumber) {
464 
465     // Get current highest edition and total in the edition
466     uint256 highestEditionNumber = kodaV2.highestEditionNumber();
467     uint256 totalAvailableEdition = kodaV2.totalAvailableEdition(highestEditionNumber);
468 
469     // Add the current highest plus its total, plus 1 as tokens start at 1 not zero
470     uint256 nextAvailableEditionNumber = highestEditionNumber.add(totalAvailableEdition).add(1);
471 
472     // Round up to next 100, 1000 etc based on max allowed size
473     return ((nextAvailableEditionNumber + maxEditionSize - 1) / maxEditionSize) * maxEditionSize;
474   }
475 
476   /**
477    * @dev Sets the KODA address
478    * @dev Only callable from owner
479    */
480   function setKodavV2(IKODAV2SelfServiceEditionCuration _kodaV2) onlyOwner public {
481     kodaV2 = _kodaV2;
482   }
483 
484   /**
485    * @dev Sets the KODA auction
486    * @dev Only callable from owner
487    */
488   function setAuction(IKODAAuction _auction) onlyOwner public {
489     auction = _auction;
490   }
491 
492   /**
493    * @dev Sets the default commission for each edition
494    * @dev Only callable from owner
495    */
496   function setArtistCommission(uint256 _artistCommission) onlyOwner public {
497     artistCommission = _artistCommission;
498   }
499 
500   /**
501    * @dev Sets the max edition size
502    * @dev Only callable from owner
503    */
504   function setMaxEditionSize(uint256 _maxEditionSize) onlyOwner public {
505     maxEditionSize = _maxEditionSize;
506   }
507 
508   /**
509    * @dev Sets the max invocations
510    * @dev Only callable from owner
511    */
512   function setMaxInvocations(uint256 _maxInvocations) onlyOwner public {
513     maxInvocations = _maxInvocations;
514   }
515 
516   /**
517    * @dev Sets the disable invocation check, when true the invocation in time period check is skipped
518    * @dev Only callable from owner
519    */
520   function setDisableInvocationCheck(bool _disableInvocationCheck) onlyOwner public {
521     disableInvocationCheck = _disableInvocationCheck;
522   }
523 
524   /**
525    * @dev Sets minimum price per edition
526    * @dev Only callable from owner
527    */
528   function setMinPricePerEdition(uint256 _minPricePerEdition) onlyOwner public {
529     minPricePerEdition = _minPricePerEdition;
530   }
531 
532   /**
533    * @dev Checks to see if the account can mint more assets
534    */
535   function canCreateAnotherEdition(address account) public view returns (bool) {
536     if (!isEnabledForAccount(account)) {
537       return false;
538     }
539     return invocationsInTimePeriod[account] < maxInvocations;
540   }
541 
542   /**
543    * @dev Checks to see if the account can create editions
544    */
545   function isEnabledForAccount(address account) public view returns (bool) {
546     return accessControls.isEnabledForAccount(account);
547   }
548 
549   /**
550    * @dev Allows for the ability to extract stuck ether
551    * @dev Only callable from owner
552    */
553   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
554     require(_withdrawalAccount != address(0), "Invalid address provided");
555     _withdrawalAccount.transfer(address(this).balance);
556   }
557 }