1 pragma solidity ^0.4.18;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
92 
93 /**
94  * @title Contracts that should not own Ether
95  * @author Remco Bloemen <remco@2π.com>
96  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
97  * in the contract, it will allow the owner to reclaim this ether.
98  * @notice Ether can still be send to this contract by:
99  * calling functions labeled `payable`
100  * `selfdestruct(contract_address)`
101  * mining directly to the contract address
102 */
103 contract HasNoEther is Ownable {
104 
105   /**
106   * @dev Constructor that rejects incoming Ether
107   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
108   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
109   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
110   * we could use assembly to access msg.value.
111   */
112   function HasNoEther() public payable {
113     require(msg.value == 0);
114   }
115 
116   /**
117    * @dev Disallows direct send by settings a default function without the `payable` flag.
118    */
119   function() external {
120   }
121 
122   /**
123    * @dev Transfer all Ether held by the contract to the owner.
124    */
125   function reclaimEther() external onlyOwner {
126     assert(owner.send(this.balance));
127   }
128 }
129 
130 // File: contracts/StoreManager.sol
131 
132 interface StoreInterface {
133 
134   function getAppNickname()
135   external
136   constant returns (bytes32);
137 
138 
139   function getAppId()
140   external
141   constant returns (uint);
142 
143 
144   function getAddressLastUpdate(
145     address _address
146   )
147   external
148   constant returns (uint);
149 
150 
151   function isUpgradable(
152     address _address,
153     string _uid
154   )
155   public
156   constant returns (bool);
157 
158 
159   function isUid(
160     string _uid
161   )
162   public
163   view
164   returns (bool);
165 
166 
167   function setIdentity(
168     address _address,
169     string _uid
170   )
171   external;
172 
173 
174   function unsetIdentity(
175     address _address
176   )
177   external;
178 
179 }
180 
181 
182 /**
183  * @title StoreManager
184  * @author Francesco Sullo <francesco@sullo.co>
185  * @dev Sets and removes tweedentities in the store,
186  * adding more logic to the simple logic of the store
187  */
188 
189 
190 contract StoreManager
191 is Pausable, HasNoEther
192 {
193 
194   string public fromVersion = "1.0.0";
195 
196   struct Store {
197     StoreInterface store;
198     address addr;
199     bool active;
200   }
201 
202   mapping(uint => Store) private __stores;
203   uint public totalStores;
204 
205   mapping(uint => bytes32) public appNicknames32;
206   mapping(uint => string) public appNicknames;
207   mapping(string => uint) private __appIds;
208 
209   address public claimer;
210   address public newClaimer;
211   mapping(address => bool) public customerService;
212   address[] private __customerServiceAddress;
213 
214   uint public upgradable = 0;
215   uint public notUpgradableInStore = 1;
216   uint public addressNotUpgradable = 2;
217 
218   uint public minimumTimeBeforeUpdate = 1 hours;
219 
220 
221 
222   // events
223 
224 
225   event StoreSet(
226     string appNickname,
227     address indexed addr
228   );
229 
230 
231   event ClaimerSet(
232     address indexed claimer,
233     bool isNew
234   );
235 
236 
237   event StoreActive(
238     string appNickname,
239     address indexed store,
240     bool active
241   );
242 
243 
244   event ClaimerSwitch(
245     address indexed oldClaimer,
246     address indexed newClaimer
247   );
248 
249 
250   event CustomerServiceSet(
251     address indexed addr
252   );
253 
254 
255   event IdentityNotUpgradable(
256     string appNickname,
257     address indexed addr,
258     string uid
259   );
260 
261 
262   event MinimumTimeBeforeUpdateChanged(
263     uint _newMinimumTime
264   );
265 
266   // config
267 
268 
269   /**
270    * @dev Sets a store to be used by the manager
271    * @param _appNickname The nickname of the app for which the store's been configured
272    * @param _address The address of the store
273    */
274   function setAStore(
275     string _appNickname,
276     address _address
277   )
278   public
279   onlyOwner
280   {
281     require(bytes(_appNickname).length > 0);
282     bytes32 _appNickname32 = keccak256(_appNickname);
283     require(_address != address(0));
284     StoreInterface _store = StoreInterface(_address);
285     require(_store.getAppNickname() == _appNickname32);
286     uint _appId = _store.getAppId();
287     require(appNicknames32[_appId] == 0x0);
288     appNicknames32[_appId] = _appNickname32;
289     appNicknames[_appId] = _appNickname;
290     __appIds[_appNickname] = _appId;
291 
292     __stores[_appId] = Store(
293       _store,
294       _address,
295       true
296     );
297     totalStores++;
298     StoreSet(_appNickname, _address);
299     StoreActive(_appNickname, _address, true);
300   }
301 
302 
303   /**
304    * @dev Sets the claimer which will verify the ownership and call to set a tweedentity
305    * @param _address Address of the claimer
306    */
307   function setClaimer(
308     address _address
309   )
310   public
311   onlyOwner
312   {
313     require(_address != address(0));
314     claimer = _address;
315     ClaimerSet(_address, false);
316   }
317 
318 
319   /**
320    * @dev Sets a new claimer during updates
321    * @param _address Address of the new claimer
322    */
323   function setNewClaimer(
324     address _address
325   )
326   public
327   onlyOwner
328   {
329     require(_address != address(0) && claimer != address(0));
330     newClaimer = _address;
331     ClaimerSet(_address, true);
332   }
333 
334 
335   /**
336   * @dev Sets new manager
337   */
338   function switchClaimerAndRemoveOldOne()
339   external
340   onlyOwner
341   {
342     require(newClaimer != address(0));
343     ClaimerSwitch(claimer, newClaimer);
344     claimer = newClaimer;
345     newClaimer = address(0);
346   }
347 
348 
349   /**
350    * @dev Sets a wallet as customer service to perform emergency removal of wrong, abused, squatted tweedentities (due, for example, to hacking of the Twitter account)
351    * @param _address The customer service wallet
352    * @param _status The status (true is set, false is unset)
353    */
354   function setCustomerService(
355     address _address,
356     bool _status
357   )
358   public
359   onlyOwner
360   {
361     require(_address != address(0));
362     customerService[_address] = _status;
363     bool found;
364     for (uint i = 0; i < __customerServiceAddress.length; i++) {
365       if (__customerServiceAddress[i] == _address) {
366         found = true;
367         break;
368       }
369     }
370     if (!found) {
371       __customerServiceAddress.push(_address);
372     }
373     CustomerServiceSet(_address);
374   }
375 
376 
377 
378   /**
379    * @dev Unable/disable a store
380    * @param _appNickname The store to be enabled/disabled
381    * @param _active A bool to unable (true) or disable (false)
382    */
383   function activateStore(
384     string _appNickname,
385     bool _active
386   )
387   public
388   onlyOwner
389   {
390     uint _appId = __appIds[_appNickname];
391     require(__stores[_appId].active != _active);
392     __stores[_appId] = Store(
393       __stores[_appId].store,
394       __stores[_appId].addr,
395       _active
396     );
397     StoreActive(_appNickname, __stores[_appId].addr, _active);
398   }
399 
400 
401 
402   //modifiers
403 
404 
405   modifier onlyClaimer() {
406     require(msg.sender == claimer || (newClaimer != address(0) && msg.sender == newClaimer));
407     _;
408   }
409 
410 
411   modifier onlyCustomerService() {
412     require(msg.sender == owner || customerService[msg.sender] == true);
413     _;
414   }
415 
416 
417   modifier whenStoreSet(
418     uint _appId
419   ) {
420     require(appNicknames32[_appId] != 0x0);
421     _;
422   }
423 
424 
425 
426   // internal getters
427 
428 
429   function __getStore(
430     uint _appId
431   )
432   internal
433   constant returns (StoreInterface)
434   {
435     return __stores[_appId].store;
436   }
437 
438 
439 
440   // helpers
441 
442 
443   function isAddressUpgradable(
444     StoreInterface _store,
445     address _address
446   )
447   internal
448   constant returns (bool)
449   {
450     uint lastUpdate = _store.getAddressLastUpdate(_address);
451     return lastUpdate == 0 || now >= lastUpdate + minimumTimeBeforeUpdate;
452   }
453 
454 
455   function isUpgradable(
456     StoreInterface _store,
457     address _address,
458     string _uid
459   )
460   internal
461   constant returns (bool)
462   {
463     if (!_store.isUpgradable(_address, _uid) || !isAddressUpgradable(_store, _address)) {
464       return false;
465     }
466     return true;
467   }
468 
469 
470 
471   // getters
472 
473 
474   /**
475    * @dev Gets the app-id associated to a nickname
476    * @param _appNickname The nickname of a configured app
477    */
478   function getAppId(
479     string _appNickname
480   )
481   external
482   constant returns (uint) {
483     return __appIds[_appNickname];
484   }
485 
486 
487   /**
488    * @dev Allows other contracts to check if a store is set
489    * @param _appNickname The nickname of a configured app
490    */
491   function isStoreSet(
492     string _appNickname
493   )
494   public
495   constant returns (bool){
496     return __appIds[_appNickname] != 0;
497   }
498 
499 
500   /**
501    * @dev Allows other contracts to check if a store is active
502    * @param _appId The id of a configured app
503    */
504   function isStoreActive(
505     uint _appId
506   )
507   public
508   constant returns (bool){
509     return __stores[_appId].active;
510   }
511 
512 
513   /**
514    * @dev Return a numeric code about the upgradability of a couple wallet-uid in a certain app
515    * @param _appId The id of the app
516    * @param _address The address of the wallet
517    * @param _uid The user-id
518    */
519   function getUpgradability(
520     uint _appId,
521     address _address,
522     string _uid
523   )
524   external
525   constant returns (uint)
526   {
527     StoreInterface _store = __getStore(_appId);
528     if (!_store.isUpgradable(_address, _uid)) {
529       return notUpgradableInStore;
530     } else if (!isAddressUpgradable(_store, _address)) {
531       return addressNotUpgradable;
532     } else {
533       return upgradable;
534     }
535   }
536 
537 
538   /**
539    * @dev Returns the address of a store
540    * @param _appNickname The app nickname
541    */
542   function getStoreAddress(
543     string _appNickname
544   )
545   external
546   constant returns (address) {
547     return __stores[__appIds[_appNickname]].addr;
548   }
549 
550 
551   /**
552    * @dev Returns the address of a store
553    * @param _appId The app id
554    */
555   function getStoreAddressById(
556     uint _appId
557   )
558   external
559   constant returns (address) {
560     return __stores[_appId].addr;
561   }
562 
563 
564   /**
565    * @dev Returns the address of any customerService account
566    */
567   function getCustomerServiceAddress()
568   external
569   constant returns (address[]) {
570     return __customerServiceAddress;
571   }
572 
573 
574 
575   // primary methods
576 
577 
578   /**
579    * @dev Sets a new identity
580    * @param _appId The id of the app
581    * @param _address The address of the wallet
582    * @param _uid The user-id
583    */
584   function setIdentity(
585     uint _appId,
586     address _address,
587     string _uid
588   )
589   external
590   onlyClaimer
591   whenStoreSet(_appId)
592   whenNotPaused
593   {
594     require(_address != address(0));
595 
596     StoreInterface _store = __getStore(_appId);
597     require(_store.isUid(_uid));
598 
599     if (isUpgradable(_store, _address, _uid)) {
600       _store.setIdentity(_address, _uid);
601     } else {
602       IdentityNotUpgradable(appNicknames[_appId], _address, _uid);
603     }
604   }
605 
606 
607   /**
608    * @dev Unsets an existent identity
609    * @param _appId The id of the app
610    * @param _address The address of the wallet
611    */
612   function unsetIdentity(
613     uint _appId,
614     address _address
615   )
616   external
617   onlyCustomerService
618   whenStoreSet(_appId)
619   whenNotPaused
620   {
621     StoreInterface _store = __getStore(_appId);
622     _store.unsetIdentity(_address);
623   }
624 
625 
626   /**
627    * @dev Allow the sender to unset its existent identity
628    * @param _appId The id of the app
629    */
630   function unsetMyIdentity(
631     uint _appId
632   )
633   external
634   whenStoreSet(_appId)
635   whenNotPaused
636   {
637     StoreInterface _store = __getStore(_appId);
638     _store.unsetIdentity(msg.sender);
639   }
640 
641 
642   /**
643    * @dev Update the minimum time before allowing a wallet to update its data
644    * @param _newMinimumTime The new minimum time in seconds
645    */
646   function changeMinimumTimeBeforeUpdate(
647     uint _newMinimumTime
648   )
649   external
650   onlyOwner
651   {
652     minimumTimeBeforeUpdate = _newMinimumTime;
653     MinimumTimeBeforeUpdateChanged(_newMinimumTime);
654   }
655 
656 }