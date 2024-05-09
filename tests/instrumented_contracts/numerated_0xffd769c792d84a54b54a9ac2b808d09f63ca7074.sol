1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 
66 
67 /**
68  * @title Roles
69  * @author Francisco Giordano (@frangio)
70  * @dev Library for managing addresses assigned to a Role.
71  * See RBAC.sol for example usage.
72  */
73 library Roles {
74   struct Role {
75     mapping (address => bool) bearer;
76   }
77 
78   /**
79    * @dev give an address access to this role
80    */
81   function add(Role storage role, address addr)
82     internal
83   {
84     role.bearer[addr] = true;
85   }
86 
87   /**
88    * @dev remove an address' access to this role
89    */
90   function remove(Role storage role, address addr)
91     internal
92   {
93     role.bearer[addr] = false;
94   }
95 
96   /**
97    * @dev check if an address has this role
98    * // reverts
99    */
100   function check(Role storage role, address addr)
101     view
102     internal
103   {
104     require(has(role, addr));
105   }
106 
107   /**
108    * @dev check if an address has this role
109    * @return bool
110    */
111   function has(Role storage role, address addr)
112     view
113     internal
114     returns (bool)
115   {
116     return role.bearer[addr];
117   }
118 }
119 
120 
121 
122 /**
123  * @title RBAC (Role-Based Access Control)
124  * @author Matt Condon (@Shrugs)
125  * @dev Stores and provides setters and getters for roles and addresses.
126  * Supports unlimited numbers of roles and addresses.
127  * See //contracts/mocks/RBACMock.sol for an example of usage.
128  * This RBAC method uses strings to key roles. It may be beneficial
129  * for you to write your own implementation of this interface using Enums or similar.
130  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
131  * to avoid typos.
132  */
133 contract RBAC {
134   using Roles for Roles.Role;
135 
136   mapping (string => Roles.Role) private roles;
137 
138   event RoleAdded(address indexed operator, string role);
139   event RoleRemoved(address indexed operator, string role);
140 
141   /**
142    * @dev reverts if addr does not have role
143    * @param _operator address
144    * @param _role the name of the role
145    * // reverts
146    */
147   function checkRole(address _operator, string _role)
148     view
149     public
150   {
151     roles[_role].check(_operator);
152   }
153 
154   /**
155    * @dev determine if addr has role
156    * @param _operator address
157    * @param _role the name of the role
158    * @return bool
159    */
160   function hasRole(address _operator, string _role)
161     view
162     public
163     returns (bool)
164   {
165     return roles[_role].has(_operator);
166   }
167 
168   /**
169    * @dev add a role to an address
170    * @param _operator address
171    * @param _role the name of the role
172    */
173   function addRole(address _operator, string _role)
174     internal
175   {
176     roles[_role].add(_operator);
177     emit RoleAdded(_operator, _role);
178   }
179 
180   /**
181    * @dev remove a role from an address
182    * @param _operator address
183    * @param _role the name of the role
184    */
185   function removeRole(address _operator, string _role)
186     internal
187   {
188     roles[_role].remove(_operator);
189     emit RoleRemoved(_operator, _role);
190   }
191 
192   /**
193    * @dev modifier to scope access to a single role (uses msg.sender as addr)
194    * @param _role the name of the role
195    * // reverts
196    */
197   modifier onlyRole(string _role)
198   {
199     checkRole(msg.sender, _role);
200     _;
201   }
202 
203   /**
204    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
205    * @param _roles the names of the roles to scope access to
206    * // reverts
207    *
208    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
209    *  see: https://github.com/ethereum/solidity/issues/2467
210    */
211   // modifier onlyRoles(string[] _roles) {
212   //     bool hasAnyRole = false;
213   //     for (uint8 i = 0; i < _roles.length; i++) {
214   //         if (hasRole(msg.sender, _roles[i])) {
215   //             hasAnyRole = true;
216   //             break;
217   //         }
218   //     }
219 
220   //     require(hasAnyRole);
221 
222   //     _;
223   // }
224 }
225 
226 
227 /**
228  * @title Whitelist
229  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
230  * This simplifies the implementation of "user permissions".
231  */
232 contract Whitelist is Ownable, RBAC {
233   string public constant ROLE_WHITELISTED = "whitelist";
234 
235   /**
236    * @dev Throws if operator is not whitelisted.
237    * @param _operator address
238    */
239   modifier onlyIfWhitelisted(address _operator) {
240     checkRole(_operator, ROLE_WHITELISTED);
241     _;
242   }
243 
244   /**
245    * @dev add an address to the whitelist
246    * @param _operator address
247    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
248    */
249   function addAddressToWhitelist(address _operator)
250     onlyOwner
251     public
252   {
253     addRole(_operator, ROLE_WHITELISTED);
254   }
255 
256   /**
257    * @dev getter to determine if address is in whitelist
258    */
259   function whitelist(address _operator)
260     public
261     view
262     returns (bool)
263   {
264     return hasRole(_operator, ROLE_WHITELISTED);
265   }
266 
267   /**
268    * @dev add addresses to the whitelist
269    * @param _operators addresses
270    * @return true if at least one address was added to the whitelist,
271    * false if all addresses were already in the whitelist
272    */
273   function addAddressesToWhitelist(address[] _operators)
274     onlyOwner
275     public
276   {
277     for (uint256 i = 0; i < _operators.length; i++) {
278       addAddressToWhitelist(_operators[i]);
279     }
280   }
281 
282   /**
283    * @dev remove an address from the whitelist
284    * @param _operator address
285    * @return true if the address was removed from the whitelist,
286    * false if the address wasn't in the whitelist in the first place
287    */
288   function removeAddressFromWhitelist(address _operator)
289     onlyOwner
290     public
291   {
292     removeRole(_operator, ROLE_WHITELISTED);
293   }
294 
295   /**
296    * @dev remove addresses from the whitelist
297    * @param _operators addresses
298    * @return true if at least one address was removed from the whitelist,
299    * false if all addresses weren't in the whitelist in the first place
300    */
301   function removeAddressesFromWhitelist(address[] _operators)
302     onlyOwner
303     public
304   {
305     for (uint256 i = 0; i < _operators.length; i++) {
306       removeAddressFromWhitelist(_operators[i]);
307     }
308   }
309 
310 }
311 
312 contract ClubAccessControl is Whitelist {
313     bool public paused = false;
314 
315     modifier whenNotPaused() {
316         require(!paused);
317         _;
318     }
319 
320     modifier whenPaused {
321         require(paused);
322         _;
323     }
324 }
325 
326 contract HKHcoinInterface {
327     mapping (address => uint256) public balanceOf;
328     function mintToken(address target, uint256 mintedAmount) public;
329     function burnFrom(address _from, uint256 _value) public returns (bool success);
330 }
331 
332 contract PlayerFactory is ClubAccessControl {
333     struct Player {
334         bool isFreezed;
335         bool isExist;
336     }
337 
338     mapping (address => Player) public players;
339     HKHcoinInterface hkhconinContract;
340     uint initCoins = 1000000;
341 
342     modifier onlyIfPlayerNotFreezed(address _playerAddress) { 
343         require (!players[_playerAddress].isFreezed);
344         _; 
345     }
346     
347     modifier onlyIfPlayerExist(address _playerAddress) { 
348         require (players[_playerAddress].isExist);
349         _; 
350     }
351 
352     event NewPlayer(address indexed _playerAddress);
353 
354     function setHKHcoinAddress(address _address) 
355         external
356         onlyIfWhitelisted(msg.sender)
357     {
358         hkhconinContract = HKHcoinInterface(_address);
359     }
360 
361     function getBalanceOfPlayer(address _playerAddress)
362         public
363         onlyIfPlayerExist(_playerAddress)
364         view
365         returns (uint)
366     {
367         return hkhconinContract.balanceOf(_playerAddress);
368     }
369 
370     function joinClub(address _playerAddress)
371         external
372         onlyIfWhitelisted(msg.sender)
373         whenNotPaused
374     {
375         require(!players[_playerAddress].isExist);
376         players[_playerAddress] = Player(false, true);
377         hkhconinContract.mintToken(_playerAddress, initCoins);
378         emit NewPlayer(_playerAddress);
379     }
380 
381     function reset(address _playerAddress)
382         external
383         onlyIfWhitelisted(msg.sender)
384         onlyIfPlayerExist(_playerAddress)
385         whenNotPaused
386     {
387         uint balance = hkhconinContract.balanceOf(_playerAddress);
388 
389         if(balance > initCoins)
390             _destroy(_playerAddress, balance - initCoins);
391         else if(balance < initCoins)
392             _recharge(_playerAddress, initCoins - balance);
393 
394         emit NewPlayer(_playerAddress);
395     }
396 
397     function recharge(address _playerAddress, uint _amount)
398         public
399         onlyIfWhitelisted(msg.sender)
400         onlyIfPlayerExist(_playerAddress)
401         whenNotPaused
402     {
403         _recharge(_playerAddress, _amount);
404     }
405 
406     function destroy(address _playerAddress, uint _amount)
407         public
408         onlyIfWhitelisted(msg.sender)
409         onlyIfPlayerExist(_playerAddress)
410         whenNotPaused
411     {
412         _destroy(_playerAddress, _amount);
413     }
414 
415     function freezePlayer(address _playerAddress)
416         public
417         onlyIfWhitelisted(msg.sender)
418         onlyIfPlayerExist(_playerAddress)
419         whenNotPaused
420     {
421         players[_playerAddress].isFreezed = true;
422     }
423 
424     function resumePlayer(address _playerAddress)
425         public
426         onlyIfWhitelisted(msg.sender)
427         onlyIfPlayerExist(_playerAddress)
428         whenNotPaused
429     {
430         players[_playerAddress].isFreezed = false;
431     }
432 
433     function _recharge(address _playerAddress, uint _amount)
434         internal
435     {
436         hkhconinContract.mintToken(_playerAddress, _amount);
437     }
438 
439     function _destroy(address _playerAddress, uint _amount)
440         internal
441     {
442         hkhconinContract.burnFrom(_playerAddress, _amount);
443     }
444 }
445 
446 /**
447  * 
448  */
449 contract LotteryFactory is PlayerFactory {
450 
451     event BuyLottery(
452         uint32 _id,
453         address indexed _playerAddress,
454         string _betline,
455         string _place,
456         uint32 _betAmount,
457         uint32 indexed _date,
458         uint8 indexed _race
459     );
460 
461     struct Lottery {
462         uint32 betAmount;
463         uint32 dividend;
464         uint32 date;
465         uint8 race;
466         bool isPaid;
467         string betline;
468         string place;
469     }
470 
471     Lottery[] public lotteries;
472 
473     mapping (uint => address) public lotteryToOwner;
474     mapping (address => uint) ownerLotteryCount;
475 
476     constructor() public {
477         addAddressToWhitelist(msg.sender);
478     }
479 
480     function getLotteriesByOwner(address _owner) 
481         view 
482         external 
483         onlyIfPlayerExist(_owner) 
484         returns(uint[]) 
485     {
486         uint[] memory result = new uint[](ownerLotteryCount[_owner]);
487         uint counter = 0;
488         for (uint i = 0; i < lotteries.length; i++) {
489             if (lotteryToOwner[i] == _owner) {
490                 result[counter] = i;
491                 counter++;
492             }
493         }
494         return result;
495     }
496 
497     function createLottery(
498         address _playerAddress,
499         string _betline, 
500         string _place,
501         uint32 _betAmount,
502         uint32 _date,
503         uint8 _race
504     )
505         external
506         onlyIfWhitelisted(msg.sender)
507         onlyIfPlayerExist(_playerAddress)
508         onlyIfPlayerNotFreezed(_playerAddress)
509         whenNotPaused
510     {
511         uint32 id = uint32(lotteries.push(Lottery(_betAmount, 0, _date, _race, false, _betline, _place))) - 1;
512         lotteryToOwner[id] = _playerAddress;
513         ownerLotteryCount[_playerAddress]++;
514         _destroy(_playerAddress, _betAmount);
515         emit BuyLottery(
516             id,
517             _playerAddress,
518             _betline,
519             _place,
520             _betAmount,
521             _date,
522             _race
523         );
524     }
525 
526     function setDividendAndPayOut(
527         uint32 _id,
528         uint32 _dividend
529     )
530         external
531         onlyIfWhitelisted(msg.sender)
532         whenNotPaused
533     {
534         if(lotteries[_id].isPaid == false) {
535             lotteries[_id].dividend = _dividend;
536             _recharge(lotteryToOwner[_id], lotteries[_id].dividend);
537             lotteries[_id].isPaid = true;
538         }
539     }
540 }