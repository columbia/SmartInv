1 /**
2  * UserRegistry.sol
3  * Mt Pelerin user registry.
4 
5  * The unflattened code is available through this github tag:
6  * https://github.com/MtPelerin/MtPelerin-protocol/tree/etherscan-verify-batch-1
7 
8  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
9 
10  * @notice All matters regarding the intellectual property of this code 
11  * @notice or software are subject to Swiss Law without reference to its 
12  * @notice conflicts of law rules.
13 
14  * @notice License for each contract is available in the respective file
15  * @notice or in the LICENSE.md file.
16  * @notice https://github.com/MtPelerin/
17 
18  * @notice Code by OpenZeppelin is copyrighted and licensed on their repository:
19  * @notice https://github.com/OpenZeppelin/openzeppelin-solidity
20  */
21 
22 pragma solidity ^0.4.24;
23 
24 // File: contracts/zeppelin/ownership/Ownable.sol
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipRenounced(address indexed previousOwner);
36   event OwnershipTransferred(
37     address indexed previousOwner,
38     address indexed newOwner
39   );
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   constructor() public {
47     owner = msg.sender;
48   }
49 
50   /**
51    * @dev Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58   /**
59    * @dev Allows the current owner to relinquish control of the contract.
60    */
61   function renounceOwnership() public onlyOwner {
62     emit OwnershipRenounced(owner);
63     owner = address(0);
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address _newOwner) public onlyOwner {
71     _transferOwnership(_newOwner);
72   }
73 
74   /**
75    * @dev Transfers control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function _transferOwnership(address _newOwner) internal {
79     require(_newOwner != address(0));
80     emit OwnershipTransferred(owner, _newOwner);
81     owner = _newOwner;
82   }
83 }
84 
85 // File: contracts/Authority.sol
86 
87 /**
88  * @title Authority
89  * @dev The Authority contract has an authority address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  * Authority means to represent a legal entity that is entitled to specific rights
92  *
93  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
94  *
95  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
96  * @notice Please refer to the top of this file for the license.
97  *
98  * Error messages
99  * AU01: Message sender must be an authority
100  */
101 contract Authority is Ownable {
102 
103   address authority;
104 
105   /**
106    * @dev Throws if called by any account other than the authority.
107    */
108   modifier onlyAuthority {
109     require(msg.sender == authority, "AU01");
110     _;
111   }
112 
113   /**
114    * @dev return the address associated to the authority
115    */
116   function authorityAddress() public view returns (address) {
117     return authority;
118   }
119 
120   /**
121    * @dev rdefines an authority
122    * @param _name the authority name
123    * @param _address the authority address.
124    */
125   function defineAuthority(string _name, address _address) public onlyOwner {
126     emit AuthorityDefined(_name, _address);
127     authority = _address;
128   }
129 
130   event AuthorityDefined(
131     string name,
132     address _address
133   );
134 }
135 
136 // File: contracts/interface/IRule.sol
137 
138 /**
139  * @title IRule
140  * @dev IRule interface
141  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
142  *
143  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
144  * @notice Please refer to the top of this file for the license.
145  **/
146 interface IRule {
147   function isAddressValid(address _address) external view returns (bool);
148   function isTransferValid(address _from, address _to, uint256 _amount)
149     external view returns (bool);
150 }
151 
152 // File: contracts/interface/IUserRegistry.sol
153 
154 /**
155  * @title IUserRegistry
156  * @dev IUserRegistry interface
157  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
158  *
159  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
160  * @notice Please refer to the top of this file for the license.
161  **/
162 contract IUserRegistry {
163 
164   function registerManyUsers(address[] _addresses, uint256 _validUntilTime)
165     public;
166 
167   function attachManyAddresses(uint256[] _userIds, address[] _addresses)
168     public;
169 
170   function detachManyAddresses(address[] _addresses)
171     public;
172 
173   function userCount() public view returns (uint256);
174   function userId(address _address) public view returns (uint256);
175   function addressConfirmed(address _address) public view returns (bool);
176   function validUntilTime(uint256 _userId) public view returns (uint256);
177   function suspended(uint256 _userId) public view returns (bool);
178   function extended(uint256 _userId, uint256 _key)
179     public view returns (uint256);
180 
181   function isAddressValid(address _address) public view returns (bool);
182   function isValid(uint256 _userId) public view returns (bool);
183 
184   function registerUser(address _address, uint256 _validUntilTime) public;
185   function attachAddress(uint256 _userId, address _address) public;
186   function confirmSelf() public;
187   function detachAddress(address _address) public;
188   function detachSelf() public;
189   function detachSelfAddress(address _address) public;
190   function suspendUser(uint256 _userId) public;
191   function unsuspendUser(uint256 _userId) public;
192   function suspendManyUsers(uint256[] _userIds) public;
193   function unsuspendManyUsers(uint256[] _userIds) public;
194   function updateUser(uint256 _userId, uint256 _validUntil, bool _suspended)
195     public;
196 
197   function updateManyUsers(
198     uint256[] _userIds,
199     uint256 _validUntil,
200     bool _suspended) public;
201 
202   function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
203     public;
204 
205   function updateManyUsersExtended(
206     uint256[] _userIds,
207     uint256 _key,
208     uint256 _value) public;
209 }
210 
211 // File: contracts/UserRegistry.sol
212 
213 /**
214  * @title UserRegistry
215  * @dev UserRegistry contract
216  * Configure and manage users
217  * Extended may be used externaly to store data within a user context
218  *
219  * @author Cyril Lapinte - <cyril.lapinte@mtpelerin.com>
220  *
221  * @notice Copyright © 2016 - 2018 Mt Pelerin Group SA - All Rights Reserved
222  * @notice Please refer to the top of this file for the license.
223  *
224  * Error messages
225  * UR01: Users length does not match addresses length
226  * UR02: UserId is invalid
227  * UR03: WalletOwner is invalid
228  * UR04: WalletOwner is already confirmed
229  * UR05: User is already suspended
230  * UR06: User is not suspended
231 */
232 contract UserRegistry is IUserRegistry, Authority {
233 
234   struct User {
235     uint256 validUntilTime;
236     bool suspended;
237     mapping(uint256 => uint256) extended;
238   }
239   struct WalletOwner {
240     uint256 userId;
241     bool confirmed;
242   }
243 
244   mapping(uint256 => User) internal users;
245   mapping(address => WalletOwner) internal walletOwners;
246   uint256 public userCount;
247 
248   /**
249    * @dev contructor
250    **/
251   constructor(address[] _addresses, uint256 _validUntilTime) public {
252     for (uint256 i = 0; i < _addresses.length; i++) {
253       registerUserInternal(_addresses[i], _validUntilTime);
254       walletOwners[_addresses[i]].confirmed = true;
255     }
256   }
257 
258   /**
259    * @dev register many users
260    */
261   function registerManyUsers(address[] _addresses, uint256 _validUntilTime)
262     public onlyAuthority
263   {
264     for (uint256 i = 0; i < _addresses.length; i++) {
265       registerUserInternal(_addresses[i], _validUntilTime);
266     }
267   }
268 
269   /**
270    * @dev attach many addresses to many users
271    */
272   function attachManyAddresses(uint256[] _userIds, address[] _addresses)
273     public onlyAuthority
274   {
275     require(_addresses.length == _userIds.length, "UR01");
276     for (uint256 i = 0; i < _addresses.length; i++) {
277       attachAddress(_userIds[i], _addresses[i]);
278     }
279   }
280 
281   /**
282    * @dev detach many addresses association between addresses and their respective users
283    */
284   function detachManyAddresses(address[] _addresses) public onlyAuthority {
285     for (uint256 i = 0; i < _addresses.length; i++) {
286       detachAddress(_addresses[i]);
287     }
288   }
289 
290   /**
291    * @dev number of user registred
292    */
293   function userCount() public view returns (uint256) {
294     return userCount;
295   }
296 
297   /**
298    * @dev the userId associated to the provided address
299    */
300   function userId(address _address) public view returns (uint256) {
301     return walletOwners[_address].userId;
302   }
303 
304   /**
305    * @dev the userId associated to the provided address if the user is valid
306    */
307   function validUserId(address _address) public view returns (uint256) {
308     if (isAddressValid(_address)) {
309       return walletOwners[_address].userId;
310     }
311     return 0;
312   }
313 
314   /**
315    * @dev the userId associated to the provided address
316    */
317   function addressConfirmed(address _address) public view returns (bool) {
318     return walletOwners[_address].confirmed;
319   }
320 
321   /**
322    * @dev returns the time at which user validity ends
323    */
324   function validUntilTime(uint256 _userId) public view returns (uint256) {
325     return users[_userId].validUntilTime;
326   }
327 
328   /**
329    * @dev is the user suspended
330    */
331   function suspended(uint256 _userId) public view returns (bool) {
332     return users[_userId].suspended;
333   }
334 
335   /**
336    * @dev access to extended user data
337    */
338   function extended(uint256 _userId, uint256 _key)
339     public view returns (uint256)
340   {
341     return users[_userId].extended[_key];
342   }
343 
344   /**
345    * @dev validity of the current user
346    */
347   function isAddressValid(address _address) public view returns (bool) {
348     return walletOwners[_address].confirmed &&
349       isValid(walletOwners[_address].userId);
350   }
351 
352   /**
353    * @dev validity of the current user
354    */
355   function isValid(uint256 _userId) public view returns (bool) {
356     return isValidInternal(users[_userId]);
357   }
358 
359   /**
360    * @dev register a user
361    */
362   function registerUser(address _address, uint256 _validUntilTime)
363     public onlyAuthority
364   {
365     registerUserInternal(_address, _validUntilTime);
366   }
367 
368   /**
369    * @dev register a user
370    */
371   function registerUserInternal(address _address, uint256 _validUntilTime)
372     public
373   {
374     require(walletOwners[_address].userId == 0, "UR03");
375     users[++userCount] = User(_validUntilTime, false);
376     walletOwners[_address] = WalletOwner(userCount, false);
377   }
378 
379   /**
380    * @dev attach an address with a user
381    */
382   function attachAddress(uint256 _userId, address _address)
383     public onlyAuthority
384   {
385     require(_userId > 0 && _userId <= userCount, "UR02");
386     require(walletOwners[_address].userId == 0, "UR03");
387     walletOwners[_address] = WalletOwner(_userId, false);
388   }
389 
390   /**
391    * @dev confirm the address by the user to activate it
392    */
393   function confirmSelf() public {
394     require(walletOwners[msg.sender].userId != 0, "UR03");
395     require(!walletOwners[msg.sender].confirmed, "UR04");
396     walletOwners[msg.sender].confirmed = true;
397   }
398 
399   /**
400    * @dev detach the association between an address and its user
401    */
402   function detachAddress(address _address) public onlyAuthority {
403     require(walletOwners[_address].userId != 0, "UR03");
404     delete walletOwners[_address];
405   }
406 
407   /**
408    * @dev detach the association between an address and its user
409    */
410   function detachSelf() public {
411     detachSelfAddress(msg.sender);
412   }
413 
414   /**
415    * @dev detach the association between an address and its user
416    */
417   function detachSelfAddress(address _address) public {
418     uint256 senderUserId = walletOwners[msg.sender].userId;
419     require(senderUserId != 0, "UR03");
420     require(walletOwners[_address].userId == senderUserId, "UR06");
421     delete walletOwners[_address];
422   }
423 
424   /**
425    * @dev suspend a user
426    */
427   function suspendUser(uint256 _userId) public onlyAuthority {
428     require(_userId > 0 && _userId <= userCount, "UR02");
429     require(!users[_userId].suspended, "UR06");
430     users[_userId].suspended = true;
431   }
432 
433   /**
434    * @dev unsuspend a user
435    */
436   function unsuspendUser(uint256 _userId) public onlyAuthority {
437     require(_userId > 0 && _userId <= userCount, "UR02");
438     require(users[_userId].suspended, "UR06");
439     users[_userId].suspended = false;
440   }
441 
442   /**
443    * @dev suspend many users
444    */
445   function suspendManyUsers(uint256[] _userIds) public onlyAuthority {
446     for (uint256 i = 0; i < _userIds.length; i++) {
447       suspendUser(_userIds[i]);
448     }
449   }
450 
451   /**
452    * @dev unsuspend many users
453    */
454   function unsuspendManyUsers(uint256[] _userIds) public onlyAuthority {
455     for (uint256 i = 0; i < _userIds.length; i++) {
456       unsuspendUser(_userIds[i]);
457     }
458   }
459 
460   /**
461    * @dev update a user
462    */
463   function updateUser(
464     uint256 _userId,
465     uint256 _validUntilTime,
466     bool _suspended) public onlyAuthority
467   {
468     require(_userId > 0 && _userId <= userCount, "UR02");
469     users[_userId].validUntilTime = _validUntilTime;
470     users[_userId].suspended = _suspended;
471   }
472 
473   /**
474    * @dev update many users
475    */
476   function updateManyUsers(
477     uint256[] _userIds,
478     uint256 _validUntilTime,
479     bool _suspended) public onlyAuthority
480   {
481     for (uint256 i = 0; i < _userIds.length; i++) {
482       updateUser(_userIds[i], _validUntilTime, _suspended);
483     }
484   }
485 
486   /**
487    * @dev update user extended information
488    */
489   function updateUserExtended(uint256 _userId, uint256 _key, uint256 _value)
490     public onlyAuthority
491   {
492     require(_userId > 0 && _userId <= userCount, "UR02");
493     users[_userId].extended[_key] = _value;
494   }
495 
496   /**
497    * @dev update many users' extended information
498    */
499   function updateManyUsersExtended(
500     uint256[] _userIds,
501     uint256 _key,
502     uint256 _value) public onlyAuthority
503   {
504     for (uint256 i = 0; i < _userIds.length; i++) {
505       updateUserExtended(_userIds[i], _key, _value);
506     }
507   }
508 
509   /**
510    * @dev validity of the current user
511    */
512   function isValidInternal(User user) internal view returns (bool) {
513     // solium-disable-next-line security/no-block-members
514     return !user.suspended && user.validUntilTime > now;
515   }
516 }