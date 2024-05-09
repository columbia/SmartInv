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
173 // File: contracts/v2/tools/SelfServiceEditionCuration.sol
174 
175 pragma solidity 0.4.24;
176 
177 
178 
179 
180 interface IKODAV2SelfServiceEditionCuration {
181 
182   function createActiveEdition(
183     uint256 _editionNumber,
184     bytes32 _editionData,
185     uint256 _editionType,
186     uint256 _startDate,
187     uint256 _endDate,
188     address _artistAccount,
189     uint256 _artistCommission,
190     uint256 _priceInWei,
191     string _tokenUri,
192     uint256 _totalAvailable
193   ) external returns (bool);
194 
195   function artistsEditions(address _artistsAccount) external returns (uint256[1] _editionNumbers);
196 
197   function totalAvailableEdition(uint256 _editionNumber) external returns (uint256);
198 
199   function highestEditionNumber() external returns (uint256);
200 }
201 
202 interface IKODAAuction {
203   function setArtistsControlAddressAndEnabledEdition(uint256 _editionNumber, address _address) external;
204 }
205 
206 contract SelfServiceEditionCuration is Ownable, Pausable {
207   using SafeMath for uint256;
208 
209   event SelfServiceEditionCreated(
210     uint256 indexed _editionNumber,
211     address indexed _creator,
212     uint256 _priceInWei,
213     uint256 _totalAvailable,
214     bool _enableAuction
215   );
216 
217   // Calling address
218   IKODAV2SelfServiceEditionCuration public kodaV2;
219   IKODAAuction public auction;
220 
221   // Default artist commission
222   uint256 public artistCommission = 85;
223 
224   // When true any existing KO artist can mint their own editions
225   bool public openToAllArtist = false;
226 
227   // Simple map to only allow certain artist create editions at first
228   mapping(address => bool) public allowedArtists;
229 
230   // Config which enforces editions to not be over this size
231   uint256 public maxEditionSize = 100;
232 
233   // When true this will skip the invocation in time period check
234   bool public disableInvocationCheck = false;
235 
236   // Max number of editions to be created in the time period
237   uint256 public maxInvocations = 3;
238 
239   // The rolling time period for max number of invocations
240   uint256 public maxInvocationsTimePeriod = 1 days;
241 
242   // Number of invocations the caller has performed in the time period
243   mapping(address => uint256) public invocationsInTimePeriod;
244 
245   // When the current time period started
246   mapping(address => uint256) public timeOfFirstInvocationInPeriod;
247 
248   /**
249    * @dev Construct a new instance of the contract
250    */
251   constructor(IKODAV2SelfServiceEditionCuration _kodaV2, IKODAAuction _auction) public {
252     kodaV2 = _kodaV2;
253     auction = _auction;
254   }
255 
256   /**
257    * @dev Called by artists, create new edition on the KODA platform
258    */
259   function createEdition(
260     uint256 _totalAvailable,
261     uint256 _priceInWei,
262     uint256 _startDate,
263     string _tokenUri,
264     bool _enableAuction
265   )
266   public
267   whenNotPaused
268   returns (uint256 _editionNumber)
269   {
270     validateInvocations();
271     return _createEdition(msg.sender, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
272   }
273 
274   /**
275    * @dev Caller by owner, can create editions for other artists
276    * @dev Only callable from owner regardless of pause state
277    */
278   function createEditionFor(
279     address _artist,
280     uint256 _totalAvailable,
281     uint256 _priceInWei,
282     uint256 _startDate,
283     string _tokenUri,
284     bool _enableAuction
285   )
286   public
287   onlyOwner
288   returns (uint256 _editionNumber)
289   {
290     return _createEdition(_artist, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
291   }
292 
293   /**
294    * @dev Internal function for edition creation
295    */
296   function _createEdition(
297     address _artist,
298     uint256 _totalAvailable,
299     uint256 _priceInWei,
300     uint256 _startDate,
301     string _tokenUri,
302     bool _enableAuction
303   )
304   internal
305   returns (uint256 _editionNumber){
306 
307     // Enforce edition size
308     require(_totalAvailable > 0, "Must be at least one available in edition");
309     require(_totalAvailable <= maxEditionSize, "Must not exceed max edition size");
310 
311 
312     // If we are the owner, skip this artists check
313     if (msg.sender != owner) {
314 
315       // Enforce who can call this
316       if (!openToAllArtist) {
317         require(allowedArtists[_artist], "Only allowed artists can create editions for now");
318       }
319     }
320 
321     // Find the next edition number we can use
322     uint256 editionNumber = getNextAvailableEditionNumber();
323 
324     // Attempt to create a new edition
325     require(
326       _createNewEdition(editionNumber, _artist, _totalAvailable, _priceInWei, _startDate, _tokenUri),
327       "Failed to create new edition"
328     );
329 
330     // Enable the auction if desired
331     if (_enableAuction) {
332       auction.setArtistsControlAddressAndEnabledEdition(editionNumber, _artist);
333     }
334 
335     // Trigger event
336     emit SelfServiceEditionCreated(editionNumber, _artist, _priceInWei, _totalAvailable, _enableAuction);
337 
338     return editionNumber;
339   }
340 
341   /**
342    * @dev Internal function for calling external create methods with some none configurable defaults
343    */
344   function _createNewEdition(
345     uint256 _editionNumber,
346     address _artist,
347     uint256 _totalAvailable,
348     uint256 _priceInWei,
349     uint256 _startDate,
350     string _tokenUri
351   )
352   internal
353   returns (bool) {
354     return kodaV2.createActiveEdition(
355       _editionNumber,
356       0x0, // _editionData - no edition data
357       1, // _editionType - KODA always type 1
358       _startDate,
359       0, // _endDate - 0 = MAX unit256
360       _artist,
361       artistCommission,
362       _priceInWei,
363       _tokenUri,
364       _totalAvailable
365     );
366   }
367 
368   function validateInvocations() internal {
369     if (disableInvocationCheck) {
370       return;
371     }
372     uint256 invocationPeriodStart = timeOfFirstInvocationInPeriod[msg.sender];
373 
374     // If we are new to this process or its been cleared, skip the check
375     if (invocationPeriodStart != 0) {
376 
377       // Work out how much time has passed
378       uint256 timePassedInPeriod = block.timestamp - invocationPeriodStart;
379 
380       // If we are still in this time period
381       if (timePassedInPeriod < maxInvocationsTimePeriod) {
382 
383         uint256 invocations = invocationsInTimePeriod[msg.sender];
384 
385         // Ensure the number of invocations does not exceed the max number of invocations allowed
386         require(invocations <= maxInvocations, "Exceeded max invocations for time period");
387 
388         // Update the invocations for this period if passed validation check
389         invocationsInTimePeriod[msg.sender] = invocations + 1;
390 
391       } else {
392         // if we have passed the time period simple clear out the fields and start the period again
393         invocationsInTimePeriod[msg.sender] = 1;
394         timeOfFirstInvocationInPeriod[msg.sender] = block.number;
395       }
396 
397     } else {
398       // initial the counters if not used before
399       invocationsInTimePeriod[msg.sender] = 1;
400       timeOfFirstInvocationInPeriod[msg.sender] = block.number;
401     }
402   }
403 
404   /**
405    * @dev Internal function for dynamically generating the next KODA edition number
406    */
407   function getNextAvailableEditionNumber()
408   internal
409   returns (uint256 editionNumber) {
410 
411     // Get current highest edition and total in the edition
412     uint256 highestEditionNumber = kodaV2.highestEditionNumber();
413     uint256 totalAvailableEdition = kodaV2.totalAvailableEdition(highestEditionNumber);
414 
415     // Add the current highest plus its total, plus 1 as tokens start at 1 not zero
416     uint256 nextAvailableEditionNumber = highestEditionNumber.add(totalAvailableEdition).add(1);
417 
418     // Round up to next 100, 1000 etc based on max allowed size
419     return ((nextAvailableEditionNumber + maxEditionSize - 1) / maxEditionSize) * maxEditionSize;
420   }
421 
422   /**
423    * @dev Sets the KODA address
424    * @dev Only callable from owner
425    */
426   function setKodavV2(IKODAV2SelfServiceEditionCuration _kodaV2) onlyOwner public {
427     kodaV2 = _kodaV2;
428   }
429 
430   /**
431    * @dev Sets the KODA auction
432    * @dev Only callable from owner
433    */
434   function setAuction(IKODAAuction _auction) onlyOwner public {
435     auction = _auction;
436   }
437 
438   /**
439    * @dev Sets the default commission for each edition
440    * @dev Only callable from owner
441    */
442   function setArtistCommission(uint256 _artistCommission) onlyOwner public {
443     artistCommission = _artistCommission;
444   }
445 
446   /**
447    * @dev Controls is the contract is open to all
448    * @dev Only callable from owner
449    */
450   function setOpenToAllArtist(bool _openToAllArtist) onlyOwner public {
451     openToAllArtist = _openToAllArtist;
452   }
453 
454   /**
455    * @dev Controls who can call this contract
456    * @dev Only callable from owner
457    */
458   function setAllowedArtist(address _artist, bool _allowed) onlyOwner public {
459     allowedArtists[_artist] = _allowed;
460   }
461 
462   /**
463    * @dev Sets the max edition size
464    * @dev Only callable from owner
465    */
466   function setMaxEditionSize(uint256 _maxEditionSize) onlyOwner public {
467     maxEditionSize = _maxEditionSize;
468   }
469 
470   /**
471    * @dev Sets the max invocations
472    * @dev Only callable from owner
473    */
474   function setMaxInvocations(uint256 _maxInvocations) onlyOwner public {
475     maxInvocations = _maxInvocations;
476   }
477 
478   /**
479    * @dev Sets the disable invocation check, when true the invocation in time period check is skipped
480    * @dev Only callable from owner
481    */
482   function setDisableInvocationCheck(bool _disableInvocationCheck) onlyOwner public {
483     disableInvocationCheck = _disableInvocationCheck;
484   }
485 
486   /**
487    * @dev Checks to see if the account can mint more assets
488    */
489   function canCreateAnotherEdition(address account) public view returns (bool) {
490     return isEnabledForAccount(account) && invocationsInTimePeriod[account] <= maxInvocations;
491   }
492 
493   /**
494    * @dev Checks to see if the account can create editions
495    */
496   function isEnabledForAccount(address account) public view returns (bool) {
497     if (openToAllArtist) {
498       return true;
499     }
500     return allowedArtists[account];
501   }
502 
503   /**
504    * @dev Allows for the ability to extract stuck ether
505    * @dev Only callable from owner
506    */
507   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
508     require(_withdrawalAccount != address(0), "Invalid address provided");
509     _withdrawalAccount.transfer(address(this).balance);
510   }
511 }