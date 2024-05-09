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
45 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
46 
47 /**
48  * @title Contracts that should not own Ether
49  * @author Remco Bloemen <remco@2π.com>
50  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
51  * in the contract, it will allow the owner to reclaim this ether.
52  * @notice Ether can still be send to this contract by:
53  * calling functions labeled `payable`
54  * `selfdestruct(contract_address)`
55  * mining directly to the contract address
56 */
57 contract HasNoEther is Ownable {
58 
59   /**
60   * @dev Constructor that rejects incoming Ether
61   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
62   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
63   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
64   * we could use assembly to access msg.value.
65   */
66   function HasNoEther() public payable {
67     require(msg.value == 0);
68   }
69 
70   /**
71    * @dev Disallows direct send by settings a default function without the `payable` flag.
72    */
73   function() external {
74   }
75 
76   /**
77    * @dev Transfer all Ether held by the contract to the owner.
78    */
79   function reclaimEther() external onlyOwner {
80     assert(owner.send(this.balance));
81   }
82 }
83 
84 // File: contracts/TweedentityStore.sol
85 
86 /**
87  * @title TweedentityStore
88  * @author Francesco Sullo <francesco@sullo.co>
89  * @dev It store the tweedentities related to the app
90  */
91 
92 
93 
94 contract TweedentityStore
95 is HasNoEther
96 {
97 
98   string public version = "1.3.0";
99 
100   uint public appId;
101   string public appNickname;
102 
103   uint public identities;
104 
105   address public manager;
106   address public newManager;
107 
108   struct Uid {
109     string lastUid;
110     uint lastUpdate;
111   }
112 
113   struct Address {
114     address lastAddress;
115     uint lastUpdate;
116   }
117 
118   mapping(string => Address) internal __addressByUid;
119   mapping(address => Uid) internal __uidByAddress;
120 
121   bool public appSet;
122 
123 
124 
125   // events
126 
127 
128   event IdentitySet(
129     address indexed addr,
130     string uid
131   );
132 
133 
134   event IdentityUnset(
135     address indexed addr,
136     string uid
137   );
138 
139 
140 
141   // modifiers
142 
143 
144   modifier onlyManager() {
145     require(msg.sender == manager || (newManager != address(0) && msg.sender == newManager));
146     _;
147   }
148 
149 
150   modifier whenAppSet() {
151     require(appSet);
152     _;
153   }
154 
155 
156 
157   // config
158 
159 
160   /**
161   * @dev Sets the manager
162   * @param _address Manager's address
163   */
164   function setManager(
165     address _address
166   )
167   external
168   onlyOwner
169   {
170     require(_address != address(0));
171     manager = _address;
172   }
173 
174 
175   /**
176   * @dev Sets new manager
177   * @param _address New manager's address
178   */
179   function setNewManager(
180     address _address
181   )
182   external
183   onlyOwner
184   {
185     require(_address != address(0) && manager != address(0));
186     newManager = _address;
187   }
188 
189 
190   /**
191   * @dev Sets new manager
192   */
193   function switchManagerAndRemoveOldOne()
194   external
195   onlyOwner
196   {
197     manager = newManager;
198     newManager = address(0);
199   }
200 
201 
202   /**
203   * @dev Sets the app
204   * @param _appNickname Nickname (e.g. twitter)
205   * @param _appId ID (e.g. 1)
206   */
207   function setApp(
208     string _appNickname,
209     uint _appId
210   )
211   external
212   onlyOwner
213   {
214     require(!appSet);
215     require(_appId > 0);
216     require(bytes(_appNickname).length > 0);
217     appId = _appId;
218     appNickname = _appNickname;
219     appSet = true;
220   }
221 
222 
223 
224   // helpers
225 
226 
227   /**
228    * @dev Checks if a tweedentity is upgradable
229    * @param _address The address
230    * @param _uid The user-id
231    */
232   function isUpgradable(
233     address _address,
234     string _uid
235   )
236   public
237   constant returns (bool)
238   {
239     if (__addressByUid[_uid].lastAddress != address(0)) {
240       return keccak256(getUid(_address)) == keccak256(_uid);
241     }
242     return true;
243   }
244 
245 
246 
247   // primary methods
248 
249 
250   /**
251    * @dev Sets a tweedentity
252    * @param _address The address of the wallet
253    * @param _uid The user-id of the owner user account
254    */
255   function setIdentity(
256     address _address,
257     string _uid
258   )
259   external
260   onlyManager
261   whenAppSet
262   {
263     require(_address != address(0));
264     require(isUid(_uid));
265     require(isUpgradable(_address, _uid));
266 
267     if (bytes(__uidByAddress[_address].lastUid).length > 0) {
268       // if _address is associated with an oldUid,
269       // this removes the association between _address and oldUid
270       __addressByUid[__uidByAddress[_address].lastUid] = Address(address(0), __addressByUid[__uidByAddress[_address].lastUid].lastUpdate);
271       identities--;
272     }
273 
274     __uidByAddress[_address] = Uid(_uid, now);
275     __addressByUid[_uid] = Address(_address, now);
276     identities++;
277     IdentitySet(_address, _uid);
278   }
279 
280 
281   /**
282    * @dev Unset a tweedentity
283    * @param _address The address of the wallet
284    */
285   function unsetIdentity(
286     address _address
287   )
288   external
289   onlyManager
290   whenAppSet
291   {
292     require(_address != address(0));
293     require(bytes(__uidByAddress[_address].lastUid).length > 0);
294 
295     string memory uid = __uidByAddress[_address].lastUid;
296     __uidByAddress[_address] = Uid('', __uidByAddress[_address].lastUpdate);
297     __addressByUid[uid] = Address(address(0), __addressByUid[uid].lastUpdate);
298     identities--;
299     IdentityUnset(_address, uid);
300   }
301 
302 
303 
304   // getters
305 
306 
307   /**
308    * @dev Returns the keccak256 of the app nickname
309    */
310   function getAppNickname()
311   external
312   whenAppSet
313   constant returns (bytes32) {
314     return keccak256(appNickname);
315   }
316 
317 
318   /**
319    * @dev Returns the appId
320    */
321   function getAppId()
322   external
323   whenAppSet
324   constant returns (uint) {
325     return appId;
326   }
327 
328 
329   /**
330    * @dev Returns the user-id associated to a wallet
331    * @param _address The address of the wallet
332    */
333   function getUid(
334     address _address
335   )
336   public
337   constant returns (string)
338   {
339     return __uidByAddress[_address].lastUid;
340   }
341 
342 
343   /**
344    * @dev Returns the user-id associated to a wallet as a unsigned integer
345    * @param _address The address of the wallet
346    */
347   function getUidAsInteger(
348     address _address
349   )
350   external
351   constant returns (uint)
352   {
353     return __stringToUint(__uidByAddress[_address].lastUid);
354   }
355 
356 
357   /**
358    * @dev Returns the address associated to a user-id
359    * @param _uid The user-id
360    */
361   function getAddress(
362     string _uid
363   )
364   external
365   constant returns (address)
366   {
367     return __addressByUid[_uid].lastAddress;
368   }
369 
370 
371   /**
372    * @dev Returns the timestamp of last update by address
373    * @param _address The address of the wallet
374    */
375   function getAddressLastUpdate(
376     address _address
377   )
378   external
379   constant returns (uint)
380   {
381     return __uidByAddress[_address].lastUpdate;
382   }
383 
384 
385   /**
386  * @dev Returns the timestamp of last update by user-id
387  * @param _uid The user-id
388  */
389   function getUidLastUpdate(
390     string _uid
391   )
392   external
393   constant returns (uint)
394   {
395     return __addressByUid[_uid].lastUpdate;
396   }
397 
398 
399 
400   // utils
401 
402 
403   function isUid(
404     string _uid
405   )
406   public
407   pure
408   returns (bool)
409   {
410     bytes memory uid = bytes(_uid);
411     if (uid.length == 0) {
412       return false;
413     } else {
414       for (uint i = 0; i < uid.length; i++) {
415         if (uid[i] < 48 || uid[i] > 57) {
416           return false;
417         }
418       }
419     }
420     return true;
421   }
422 
423 
424 
425   // private methods
426 
427 
428   function __stringToUint(
429     string s
430   )
431   internal
432   pure
433   returns (uint result)
434   {
435     bytes memory b = bytes(s);
436     uint i;
437     result = 0;
438     for (i = 0; i < b.length; i++) {
439       uint c = uint(b[i]);
440       if (c >= 48 && c <= 57) {
441         result = result * 10 + (c - 48);
442       }
443     }
444   }
445 
446 
447   function __uintToBytes(uint x)
448   internal
449   pure
450   returns (bytes b)
451   {
452     b = new bytes(32);
453     for (uint i = 0; i < 32; i++) {
454       b[i] = byte(uint8(x / (2 ** (8 * (31 - i)))));
455     }
456   }
457 
458 }