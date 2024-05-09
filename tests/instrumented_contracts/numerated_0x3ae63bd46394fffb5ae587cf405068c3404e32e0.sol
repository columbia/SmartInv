1 pragma solidity ^0.4.18;
2 
3 // File: contracts/UidCheckerInterface.sol
4 
5 interface UidCheckerInterface {
6 
7   function isUid(
8     string _uid
9   )
10   public
11   pure returns (bool);
12 
13 }
14 
15 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() public {
34     owner = msg.sender;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) public onlyOwner {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 
57 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
58 
59 /**
60  * @title Contracts that should not own Ether
61  * @author Remco Bloemen <remco@2π.com>
62  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
63  * in the contract, it will allow the owner to reclaim this ether.
64  * @notice Ether can still be send to this contract by:
65  * calling functions labeled `payable`
66  * `selfdestruct(contract_address)`
67  * mining directly to the contract address
68 */
69 contract HasNoEther is Ownable {
70 
71   /**
72   * @dev Constructor that rejects incoming Ether
73   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
74   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
75   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
76   * we could use assembly to access msg.value.
77   */
78   function HasNoEther() public payable {
79     require(msg.value == 0);
80   }
81 
82   /**
83    * @dev Disallows direct send by settings a default function without the `payable` flag.
84    */
85   function() external {
86   }
87 
88   /**
89    * @dev Transfer all Ether held by the contract to the owner.
90    */
91   function reclaimEther() external onlyOwner {
92     assert(owner.send(this.balance));
93   }
94 }
95 
96 // File: contracts/Datastore.sol
97 
98 /**
99  * @title Store
100  * @author Francesco Sullo <francesco@sullo.co>
101  * @dev It store the tweedentities related to the app
102  */
103 
104 
105 
106 contract Datastore
107 is HasNoEther
108 {
109 
110   string public fromVersion = "1.0.0";
111 
112   uint public appId;
113   string public appNickname;
114 
115   uint public identities;
116 
117   address public manager;
118   address public newManager;
119 
120   UidCheckerInterface public checker;
121 
122   struct Uid {
123     string lastUid;
124     uint lastUpdate;
125   }
126 
127   struct Address {
128     address lastAddress;
129     uint lastUpdate;
130   }
131 
132   mapping(string => Address) internal __addressByUid;
133   mapping(address => Uid) internal __uidByAddress;
134 
135   bool public appSet;
136 
137 
138 
139   // events
140 
141 
142   event AppSet(
143     string appNickname,
144     uint appId,
145     address checker
146   );
147 
148 
149   event ManagerSet(
150     address indexed manager,
151     bool isNew
152   );
153 
154   event ManagerSwitch(
155     address indexed oldManager,
156     address indexed newManager
157   );
158 
159 
160   event IdentitySet(
161     address indexed addr,
162     string uid
163   );
164 
165 
166   event IdentityUnset(
167     address indexed addr,
168     string uid
169   );
170 
171 
172 
173   // modifiers
174 
175 
176   modifier onlyManager() {
177     require(msg.sender == manager || (newManager != address(0) && msg.sender == newManager));
178     _;
179   }
180 
181 
182   modifier whenAppSet() {
183     require(appSet);
184     _;
185   }
186 
187 
188 
189   // config
190 
191 
192   /**
193   * @dev Updates the checker for the store
194   * @param _address Checker's address
195   */
196   function setNewChecker(
197     address _address
198   )
199   external
200   onlyOwner
201   {
202     require(_address != address(0));
203     checker = UidCheckerInterface(_address);
204   }
205 
206 
207   /**
208   * @dev Sets the manager
209   * @param _address Manager's address
210   */
211   function setManager(
212     address _address
213   )
214   external
215   onlyOwner
216   {
217     require(_address != address(0));
218     manager = _address;
219     ManagerSet(_address, false);
220   }
221 
222 
223   /**
224   * @dev Sets new manager
225   * @param _address New manager's address
226   */
227   function setNewManager(
228     address _address
229   )
230   external
231   onlyOwner
232   {
233     require(_address != address(0) && manager != address(0));
234     newManager = _address;
235     ManagerSet(_address, true);
236   }
237 
238 
239   /**
240   * @dev Sets new manager
241   */
242   function switchManagerAndRemoveOldOne()
243   external
244   onlyOwner
245   {
246     require(newManager != address(0));
247     ManagerSwitch(manager, newManager);
248     manager = newManager;
249     newManager = address(0);
250   }
251 
252 
253   /**
254   * @dev Sets the app
255   * @param _appNickname Nickname (e.g. twitter)
256   * @param _appId ID (e.g. 1)
257   */
258   function setApp(
259     string _appNickname,
260     uint _appId,
261     address _checker
262   )
263   external
264   onlyOwner
265   {
266     require(!appSet);
267     require(_appId > 0);
268     require(_checker != address(0));
269     require(bytes(_appNickname).length > 0);
270     appId = _appId;
271     appNickname = _appNickname;
272     checker = UidCheckerInterface(_checker);
273     appSet = true;
274     AppSet(_appNickname, _appId, _checker);
275   }
276 
277 
278 
279   // helpers
280 
281 
282   /**
283    * @dev Checks if a tweedentity is upgradable
284    * @param _address The address
285    * @param _uid The user-id
286    */
287   function isUpgradable(
288     address _address,
289     string _uid
290   )
291   public
292   constant returns (bool)
293   {
294     if (__addressByUid[_uid].lastAddress != address(0)) {
295       return keccak256(getUid(_address)) == keccak256(_uid);
296     }
297     return true;
298   }
299 
300 
301 
302   // primary methods
303 
304 
305   /**
306    * @dev Sets a tweedentity
307    * @param _address The address of the wallet
308    * @param _uid The user-id of the owner user account
309    */
310   function setIdentity(
311     address _address,
312     string _uid
313   )
314   external
315   onlyManager
316   whenAppSet
317   {
318     require(_address != address(0));
319     require(isUid(_uid));
320     require(isUpgradable(_address, _uid));
321 
322     if (bytes(__uidByAddress[_address].lastUid).length > 0) {
323       // if _address is associated with an oldUid,
324       // this removes the association between _address and oldUid
325       __addressByUid[__uidByAddress[_address].lastUid] = Address(address(0), __addressByUid[__uidByAddress[_address].lastUid].lastUpdate);
326       identities--;
327     }
328 
329     __uidByAddress[_address] = Uid(_uid, now);
330     __addressByUid[_uid] = Address(_address, now);
331     identities++;
332     IdentitySet(_address, _uid);
333   }
334 
335 
336   /**
337    * @dev Unset a tweedentity
338    * @param _address The address of the wallet
339    */
340   function unsetIdentity(
341     address _address
342   )
343   external
344   onlyManager
345   whenAppSet
346   {
347     require(_address != address(0));
348     require(bytes(__uidByAddress[_address].lastUid).length > 0);
349 
350     string memory uid = __uidByAddress[_address].lastUid;
351     __uidByAddress[_address] = Uid('', __uidByAddress[_address].lastUpdate);
352     __addressByUid[uid] = Address(address(0), __addressByUid[uid].lastUpdate);
353     identities--;
354     IdentityUnset(_address, uid);
355   }
356 
357 
358 
359   // getters
360 
361 
362   /**
363    * @dev Returns the keccak256 of the app nickname
364    */
365   function getAppNickname()
366   external
367   whenAppSet
368   constant returns (bytes32) {
369     return keccak256(appNickname);
370   }
371 
372 
373   /**
374    * @dev Returns the appId
375    */
376   function getAppId()
377   external
378   whenAppSet
379   constant returns (uint) {
380     return appId;
381   }
382 
383 
384   /**
385    * @dev Returns the user-id associated to a wallet
386    * @param _address The address of the wallet
387    */
388   function getUid(
389     address _address
390   )
391   public
392   constant returns (string)
393   {
394     return __uidByAddress[_address].lastUid;
395   }
396 
397 
398   /**
399    * @dev Returns the address associated to a user-id
400    * @param _uid The user-id
401    */
402   function getAddress(
403     string _uid
404   )
405   external
406   constant returns (address)
407   {
408     return __addressByUid[_uid].lastAddress;
409   }
410 
411 
412   /**
413    * @dev Returns the timestamp of last update by address
414    * @param _address The address of the wallet
415    */
416   function getAddressLastUpdate(
417     address _address
418   )
419   external
420   constant returns (uint)
421   {
422     return __uidByAddress[_address].lastUpdate;
423   }
424 
425 
426   /**
427  * @dev Returns the timestamp of last update by user-id
428  * @param _uid The user-id
429  */
430   function getUidLastUpdate(
431     string _uid
432   )
433   external
434   constant returns (uint)
435   {
436     return __addressByUid[_uid].lastUpdate;
437   }
438 
439 
440 
441   // utils
442 
443 
444   function isUid(
445     string _uid
446   )
447   public
448   view
449   returns (bool)
450   {
451     return checker.isUid(_uid);
452   }
453 
454 }