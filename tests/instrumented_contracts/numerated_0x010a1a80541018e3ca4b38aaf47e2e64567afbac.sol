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
130 // File: contracts/TweedentityManager.sol
131 
132 interface ITweedentityStore {
133 
134   function isUpgradable(address _address, string _uid) public constant returns (bool);
135 
136   function setIdentity(address _address, string _uid) external;
137 
138   function unsetIdentity(address _address) external;
139 
140   function getAppNickname() external constant returns (bytes32);
141 
142   function getAppId() external constant returns (uint);
143 
144   function getAddressLastUpdate(address _address) external constant returns (uint);
145 
146   function isUid(string _uid) public pure returns (bool);
147 
148 }
149 
150 
151 /**
152  * @title TweedentityManager
153  * @author Francesco Sullo <francesco@sullo.co>
154  * @dev Sets and removes tweedentities in the store,
155  * adding more logic to the simple logic of the store
156  */
157 
158 
159 contract TweedentityManager
160 is Pausable, HasNoEther
161 {
162 
163   string public version = "1.3.0";
164 
165   struct Store {
166     ITweedentityStore store;
167     address addr;
168   }
169 
170   mapping(uint => Store) private __stores;
171 
172   mapping(uint => bytes32) public appNicknames32;
173   mapping(uint => string) public appNicknames;
174   mapping(string => uint) private __appIds;
175 
176   address public claimer;
177   address public newClaimer;
178   mapping(address => bool) public customerService;
179   address[] private __customerServiceAddress;
180 
181   uint public upgradable = 0;
182   uint public notUpgradableInStore = 1;
183   uint public addressNotUpgradable = 2;
184 
185   uint public minimumTimeBeforeUpdate = 1 hours;
186 
187 
188 
189   // events
190 
191 
192   event IdentityNotUpgradable(
193     string appNickname,
194     address indexed addr,
195     string uid
196   );
197 
198 
199 
200   // config
201 
202 
203   /**
204    * @dev Sets a store to be used by the manager
205    * @param _appNickname The nickname of the app for which the store's been configured
206    * @param _address The address of the store
207    */
208   function setAStore(
209     string _appNickname,
210     address _address
211   )
212   public
213   onlyOwner
214   {
215     require(bytes(_appNickname).length > 0);
216     bytes32 _appNickname32 = keccak256(_appNickname);
217     require(_address != address(0));
218     ITweedentityStore _store = ITweedentityStore(_address);
219     require(_store.getAppNickname() == _appNickname32);
220     uint _appId = _store.getAppId();
221     require(appNicknames32[_appId] == 0x0);
222     appNicknames32[_appId] = _appNickname32;
223     appNicknames[_appId] = _appNickname;
224     __appIds[_appNickname] = _appId;
225 
226     __stores[_appId] = Store(
227       ITweedentityStore(_address),
228       _address
229     );
230   }
231 
232 
233   /**
234    * @dev Sets the claimer which will verify the ownership and call to set a tweedentity
235    * @param _address Address of the claimer
236    */
237   function setClaimer(
238     address _address
239   )
240   public
241   onlyOwner
242   {
243     require(_address != address(0));
244     claimer = _address;
245   }
246 
247 
248   /**
249    * @dev Sets a new claimer during updates
250    * @param _address Address of the new claimer
251    */
252   function setNewClaimer(
253     address _address
254   )
255   public
256   onlyOwner
257   {
258     require(_address != address(0) && claimer != address(0));
259     newClaimer = _address;
260   }
261 
262 
263   /**
264   * @dev Sets new manager
265   */
266   function switchClaimerAndRemoveOldOne()
267   external
268   onlyOwner
269   {
270     claimer = newClaimer;
271     newClaimer = address(0);
272   }
273 
274 
275   /**
276    * @dev Sets a wallet as customer service to perform emergency removal of wrong, abused, squatted tweedentities (due, for example, to hacking of the Twitter account)
277    * @param _address The customer service wallet
278    * @param _status The status (true is set, false is unset)
279    */
280   function setCustomerService(
281     address _address,
282     bool _status
283   )
284   public
285   onlyOwner
286   {
287     require(_address != address(0));
288     customerService[_address] = _status;
289     bool found;
290     for (uint i = 0; i < __customerServiceAddress.length; i++) {
291       if (__customerServiceAddress[i] == _address) {
292         found = true;
293         break;
294       }
295     }
296     if (!found) {
297       __customerServiceAddress.push(_address);
298     }
299   }
300 
301 
302 
303   //modifiers
304 
305 
306   modifier onlyClaimer() {
307     require(msg.sender == claimer || (newClaimer != address(0) && msg.sender == newClaimer));
308     _;
309   }
310 
311 
312   modifier onlyCustomerService() {
313     require(msg.sender == owner || customerService[msg.sender] == true);
314     _;
315   }
316 
317 
318   modifier whenStoreSet(
319     uint _appId
320   ) {
321     require(appNicknames32[_appId] != 0x0);
322     _;
323   }
324 
325 
326 
327   // internal getters
328 
329 
330   function __getStore(
331     uint _appId
332   )
333   internal
334   constant returns (ITweedentityStore)
335   {
336     return __stores[_appId].store;
337   }
338 
339 
340 
341   // helpers
342 
343 
344   function isAddressUpgradable(
345     ITweedentityStore _store,
346     address _address
347   )
348   internal
349   constant returns (bool)
350   {
351     uint lastUpdate = _store.getAddressLastUpdate(_address);
352     return lastUpdate == 0 || now >= lastUpdate + minimumTimeBeforeUpdate;
353   }
354 
355 
356   function isUpgradable(
357     ITweedentityStore _store,
358     address _address,
359     string _uid
360   )
361   internal
362   constant returns (bool)
363   {
364     if (!_store.isUpgradable(_address, _uid) || !isAddressUpgradable(_store, _address)) {
365       return false;
366     }
367     return true;
368   }
369 
370 
371 
372   // getters
373 
374 
375   /**
376    * @dev Gets the app-id associated to a nickname
377    * @param _appNickname The nickname of a configured app
378    */
379   function getAppId(
380     string _appNickname
381   )
382   external
383   constant returns (uint) {
384     return __appIds[_appNickname];
385   }
386 
387 
388   /**
389    * @dev Allows other contracts to check if a store is set
390    * @param _appNickname The nickname of a configured app
391    */
392   function isStoreSet(
393     string _appNickname
394   )
395   public
396   constant returns (bool){
397     return __appIds[_appNickname] != 0;
398   }
399 
400 
401   /**
402    * @dev Return a numeric code about the upgradability of a couple wallet-uid in a certain app
403    * @param _appId The id of the app
404    * @param _address The address of the wallet
405    * @param _uid The user-id
406    */
407   function getUpgradability(
408     uint _appId,
409     address _address,
410     string _uid
411   )
412   external
413   constant returns (uint)
414   {
415     ITweedentityStore _store = __getStore(_appId);
416     if (!_store.isUpgradable(_address, _uid)) {
417       return notUpgradableInStore;
418     } else if (!isAddressUpgradable(_store, _address)) {
419       return addressNotUpgradable;
420     } else {
421       return upgradable;
422     }
423   }
424 
425 
426   /**
427    * @dev Returns the address of a store
428    * @param _appNickname The app nickname
429    */
430   function getStoreAddress(
431     string _appNickname
432   )
433   external
434   constant returns (address) {
435     return __stores[__appIds[_appNickname]].addr;
436   }
437 
438 
439   /**
440    * @dev Returns the address of any customerService account
441    */
442   function getCustomerServiceAddress()
443   external
444   constant returns (address[]) {
445     return __customerServiceAddress;
446   }
447 
448 
449 
450   // primary methods
451 
452 
453   /**
454    * @dev Sets a new identity
455    * @param _appId The id of the app
456    * @param _address The address of the wallet
457    * @param _uid The user-id
458    */
459   function setIdentity(
460     uint _appId,
461     address _address,
462     string _uid
463   )
464   external
465   onlyClaimer
466   whenStoreSet(_appId)
467   whenNotPaused
468   {
469     require(_address != address(0));
470 
471     ITweedentityStore _store = __getStore(_appId);
472     require(_store.isUid(_uid));
473     if (isUpgradable(_store, _address, _uid)) {
474       _store.setIdentity(_address, _uid);
475     } else {
476       IdentityNotUpgradable(appNicknames[_appId], _address, _uid);
477     }
478   }
479 
480 
481   /**
482    * @dev Unsets an existent identity
483    * @param _appId The id of the app
484    * @param _address The address of the wallet
485    */
486   function unsetIdentity(
487     uint _appId,
488     address _address
489   )
490   external
491   onlyCustomerService
492   whenStoreSet(_appId)
493   whenNotPaused
494   {
495     ITweedentityStore _store = __getStore(_appId);
496     _store.unsetIdentity(_address);
497   }
498 
499 
500   /**
501    * @dev Allow the sender to unset its existent identity
502    * @param _appId The id of the app
503    */
504   function unsetMyIdentity(
505     uint _appId
506   )
507   external
508   whenStoreSet(_appId)
509   whenNotPaused
510   {
511     ITweedentityStore _store = __getStore(_appId);
512     _store.unsetIdentity(msg.sender);
513   }
514 
515 
516   /**
517    * @dev Update the minimum time before allowing a wallet to update its data
518    * @param _newMinimumTime The new minimum time in seconds
519    */
520   function changeMinimumTimeBeforeUpdate(
521     uint _newMinimumTime
522   )
523   external
524   onlyOwner
525   {
526     minimumTimeBeforeUpdate = _newMinimumTime;
527   }
528 
529 
530 
531   // private methods
532 
533 
534   function __stringToUint(
535     string s
536   )
537   internal
538   pure
539   returns (uint result)
540   {
541     bytes memory b = bytes(s);
542     uint i;
543     result = 0;
544     for (i = 0; i < b.length; i++) {
545       uint c = uint(b[i]);
546       if (c >= 48 && c <= 57) {
547         result = result * 10 + (c - 48);
548       }
549     }
550   }
551 
552 
553   function __uintToBytes(uint x)
554   internal
555   pure
556   returns (bytes b)
557   {
558     b = new bytes(32);
559     for (uint i = 0; i < 32; i++) {
560       b[i] = byte(uint8(x / (2 ** (8 * (31 - i)))));
561     }
562   }
563 
564 }