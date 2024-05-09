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
219 // File: contracts/v2/tools/SelfServiceEditionCurationV3.sol
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
253 // One invocation per time-period
254 contract SelfServiceEditionCurationV3 is Ownable, Pausable {
255   using SafeMath for uint256;
256 
257   event SelfServiceEditionCreated(
258     uint256 indexed _editionNumber,
259     address indexed _creator,
260     uint256 _priceInWei,
261     uint256 _totalAvailable,
262     bool _enableAuction
263   );
264 
265   // Calling address
266   IKODAV2SelfServiceEditionCuration public kodaV2;
267   IKODAAuction public auction;
268   SelfServiceAccessControls public accessControls;
269 
270   // Default artist commission
271   uint256 public artistCommission = 85;
272 
273   // Config which enforces editions to not be over this size
274   uint256 public maxEditionSize = 100;
275 
276   // Config the minimum price per edition
277   uint256 public minPricePerEdition = 0.01 ether;
278 
279   // frozen out for..
280   uint256 public freezeWindow = 1 days;
281 
282   // When the current time period started
283   mapping(address => uint256) public frozenTil;
284 
285   /**
286    * @dev Construct a new instance of the contract
287    */
288   constructor(
289     IKODAV2SelfServiceEditionCuration _kodaV2,
290     IKODAAuction _auction,
291     SelfServiceAccessControls _accessControls
292   ) public {
293     kodaV2 = _kodaV2;
294     auction = _auction;
295     accessControls = _accessControls;
296   }
297 
298   /**
299    * @dev Called by artists, create new edition on the KODA platform
300    */
301   function createEdition(
302     uint256 _totalAvailable,
303     uint256 _priceInWei,
304     uint256 _startDate,
305     string _tokenUri,
306     bool _enableAuction
307   )
308   public
309   whenNotPaused
310   returns (uint256 _editionNumber)
311   {
312     require(!_isFrozen(msg.sender), 'Sender currently frozen out of creation');
313 
314     frozenTil[msg.sender] = block.timestamp.add(freezeWindow);
315 
316     return _createEdition(msg.sender, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
317   }
318 
319   /**
320    * @dev Caller by owner, can create editions for other artists
321    * @dev Only callable from owner regardless of pause state
322    */
323   function createEditionFor(
324     address _artist,
325     uint256 _totalAvailable,
326     uint256 _priceInWei,
327     uint256 _startDate,
328     string _tokenUri,
329     bool _enableAuction
330   )
331   public
332   onlyOwner
333   returns (uint256 _editionNumber)
334   {
335     return _createEdition(_artist, _totalAvailable, _priceInWei, _startDate, _tokenUri, _enableAuction);
336   }
337 
338   /**
339    * @dev Internal function for edition creation
340    */
341   function _createEdition(
342     address _artist,
343     uint256 _totalAvailable,
344     uint256 _priceInWei,
345     uint256 _startDate,
346     string _tokenUri,
347     bool _enableAuction
348   )
349   internal
350   returns (uint256 _editionNumber){
351 
352     // Enforce edition size
353     require(_totalAvailable > 0, "Must be at least one available in edition");
354     require(_totalAvailable <= maxEditionSize, "Must not exceed max edition size");
355 
356     // Enforce min price
357     require(_priceInWei >= minPricePerEdition, "Price must be greater than minimum");
358 
359     // If we are the owner, skip this artists check
360     if (msg.sender != owner) {
361 
362       // Enforce who can call this
363       if (!accessControls.openToAllArtist()) {
364         require(accessControls.allowedArtists(_artist), "Only allowed artists can create editions for now");
365       }
366     }
367 
368     // Find the next edition number we can use
369     uint256 editionNumber = getNextAvailableEditionNumber();
370 
371     // Attempt to create a new edition
372     require(
373       _createNewEdition(editionNumber, _artist, _totalAvailable, _priceInWei, _startDate, _tokenUri),
374       "Failed to create new edition"
375     );
376 
377     // Enable the auction if desired
378     if (_enableAuction) {
379       auction.setArtistsControlAddressAndEnabledEdition(editionNumber, _artist);
380     }
381 
382     // Trigger event
383     emit SelfServiceEditionCreated(editionNumber, _artist, _priceInWei, _totalAvailable, _enableAuction);
384 
385     return editionNumber;
386   }
387 
388   /**
389    * @dev Internal function for calling external create methods with some none configurable defaults
390    */
391   function _createNewEdition(
392     uint256 _editionNumber,
393     address _artist,
394     uint256 _totalAvailable,
395     uint256 _priceInWei,
396     uint256 _startDate,
397     string _tokenUri
398   )
399   internal
400   returns (bool) {
401     return kodaV2.createActiveEdition(
402       _editionNumber,
403       0x0, // _editionData - no edition data
404       1, // _editionType - KODA always type 1
405       _startDate,
406       0, // _endDate - 0 = MAX unit256
407       _artist,
408       artistCommission,
409       _priceInWei,
410       _tokenUri,
411       _totalAvailable
412     );
413   }
414 
415   /**
416    * @dev Internal function for checking is an account is frozen out yet
417    */
418   function _isFrozen(address account) internal view returns (bool) {
419     return (block.timestamp < frozenTil[account]);
420   }
421 
422   /**
423    * @dev Internal function for dynamically generating the next KODA edition number
424    */
425   function getNextAvailableEditionNumber() internal returns (uint256 editionNumber) {
426 
427     // Get current highest edition and total in the edition
428     uint256 highestEditionNumber = kodaV2.highestEditionNumber();
429     uint256 totalAvailableEdition = kodaV2.totalAvailableEdition(highestEditionNumber);
430 
431     // Add the current highest plus its total, plus 1 as tokens start at 1 not zero
432     uint256 nextAvailableEditionNumber = highestEditionNumber.add(totalAvailableEdition).add(1);
433 
434     // Round up to next 100, 1000 etc based on max allowed size
435     return ((nextAvailableEditionNumber + maxEditionSize - 1) / maxEditionSize) * maxEditionSize;
436   }
437 
438   /**
439    * @dev Sets the KODA address
440    * @dev Only callable from owner
441    */
442   function setKodavV2(IKODAV2SelfServiceEditionCuration _kodaV2) onlyOwner public {
443     kodaV2 = _kodaV2;
444   }
445 
446   /**
447    * @dev Sets the KODA auction
448    * @dev Only callable from owner
449    */
450   function setAuction(IKODAAuction _auction) onlyOwner public {
451     auction = _auction;
452   }
453 
454   /**
455    * @dev Sets the default commission for each edition
456    * @dev Only callable from owner
457    */
458   function setArtistCommission(uint256 _artistCommission) onlyOwner public {
459     artistCommission = _artistCommission;
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
471    * @dev Sets minimum price per edition
472    * @dev Only callable from owner
473    */
474   function setMinPricePerEdition(uint256 _minPricePerEdition) onlyOwner public {
475     minPricePerEdition = _minPricePerEdition;
476   }
477 
478   /**
479    * @dev Sets freeze window
480    * @dev Only callable from owner
481    */
482   function setFreezeWindow(uint256 _freezeWindow) onlyOwner public {
483     freezeWindow = _freezeWindow;
484   }
485 
486   /**
487    * @dev Checks to see if the account is currently frozen out
488    */
489   function isFrozen(address account) public view returns (bool) {
490     return _isFrozen(account);
491   }
492 
493   /**
494    * @dev Checks to see if the account can create editions
495    */
496   function isEnabledForAccount(address account) public view returns (bool) {
497     return accessControls.isEnabledForAccount(account);
498   }
499 
500   /**
501    * @dev Checks to see if the account can create editions
502    */
503   function canCreateAnotherEdition(address account) public view returns (bool) {
504     if (!isEnabledForAccount(account)) {
505       return false;
506     }
507     return !_isFrozen(account);
508   }
509 
510   /**
511    * @dev Allows for the ability to extract stuck ether
512    * @dev Only callable from owner
513    */
514   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
515     require(_withdrawalAccount != address(0), "Invalid address provided");
516     _withdrawalAccount.transfer(address(this).balance);
517   }
518 }