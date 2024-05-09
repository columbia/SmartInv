1 pragma solidity ^0.4.24;
2 
3 /* 
4 
5 https://dragoneth.com
6 
7 */
8 
9 contract DragonsETH {
10     function createDragon(
11         address _to, 
12         uint256 _timeToBorn, 
13         uint256 _parentOne, 
14         uint256 _parentTwo, 
15         uint256 _gen1, 
16         uint240 _gen2
17     ) 
18         external;
19 }
20 
21 library AddressUtils {
22 
23   /**
24    * Returns whether the target address is a contract
25    * @dev This function will return false if invoked during the constructor of a contract,
26    *  as the code is not actually created until after the constructor finishes.
27    * @param addr address to check
28    * @return whether the target address is a contract
29    */
30   function isContract(address addr) internal view returns (bool) {
31     uint256 size;
32     // XXX Currently there is no better way to check if there is a contract in an address
33     // than to check the size of the code at that address.
34     // See https://ethereum.stackexchange.com/a/14016/36603
35     // for more details about how this works.
36     // TODO Check this again before the Serenity release, because all addresses will be
37     // contracts then.
38     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
39     return size > 0;
40   }
41 
42 }
43 
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     // uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return a / b;
66   }
67 
68   /**
69   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 library Roles {
87   struct Role {
88     mapping (address => bool) bearer;
89   }
90 
91   /**
92    * @dev give an address access to this role
93    */
94   function add(Role storage role, address addr)
95     internal
96   {
97     role.bearer[addr] = true;
98   }
99 
100   /**
101    * @dev remove an address' access to this role
102    */
103   function remove(Role storage role, address addr)
104     internal
105   {
106     role.bearer[addr] = false;
107   }
108 
109   /**
110    * @dev check if an address has this role
111    * // reverts
112    */
113   function check(Role storage role, address addr)
114     view
115     internal
116   {
117     require(has(role, addr));
118   }
119 
120   /**
121    * @dev check if an address has this role
122    * @return bool
123    */
124   function has(Role storage role, address addr)
125     view
126     internal
127     returns (bool)
128   {
129     return role.bearer[addr];
130   }
131 }
132 
133 contract RBAC {
134   using Roles for Roles.Role;
135 
136   mapping (string => Roles.Role) private roles;
137 
138   event RoleAdded(address addr, string roleName);
139   event RoleRemoved(address addr, string roleName);
140 
141   /**
142    * @dev reverts if addr does not have role
143    * @param addr address
144    * @param roleName the name of the role
145    * // reverts
146    */
147   function checkRole(address addr, string roleName)
148     view
149     public
150   {
151     roles[roleName].check(addr);
152   }
153 
154   /**
155    * @dev determine if addr has role
156    * @param addr address
157    * @param roleName the name of the role
158    * @return bool
159    */
160   function hasRole(address addr, string roleName)
161     view
162     public
163     returns (bool)
164   {
165     return roles[roleName].has(addr);
166   }
167 
168   /**
169    * @dev add a role to an address
170    * @param addr address
171    * @param roleName the name of the role
172    */
173   function addRole(address addr, string roleName)
174     internal
175   {
176     roles[roleName].add(addr);
177     emit RoleAdded(addr, roleName);
178   }
179 
180   /**
181    * @dev remove a role from an address
182    * @param addr address
183    * @param roleName the name of the role
184    */
185   function removeRole(address addr, string roleName)
186     internal
187   {
188     roles[roleName].remove(addr);
189     emit RoleRemoved(addr, roleName);
190   }
191 
192   /**
193    * @dev modifier to scope access to a single role (uses msg.sender as addr)
194    * @param roleName the name of the role
195    * // reverts
196    */
197   modifier onlyRole(string roleName)
198   {
199     checkRole(msg.sender, roleName);
200     _;
201   }
202 
203   /**
204    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
205    * @param roleNames the names of the roles to scope access to
206    * // reverts
207    *
208    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
209    *  see: https://github.com/ethereum/solidity/issues/2467
210    */
211   // modifier onlyRoles(string[] roleNames) {
212   //     bool hasAnyRole = false;
213   //     for (uint8 i = 0; i < roleNames.length; i++) {
214   //         if (hasRole(msg.sender, roleNames[i])) {
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
226 contract RBACWithAdmin is RBAC {
227   /**
228    * A constant role name for indicating admins.
229    */
230   string public constant ROLE_ADMIN = "admin";
231   string public constant ROLE_PAUSE_ADMIN = "pauseAdmin";
232 
233   /**
234    * @dev modifier to scope access to admins
235    * // reverts
236    */
237   modifier onlyAdmin()
238   {
239     checkRole(msg.sender, ROLE_ADMIN);
240     _;
241   }
242   modifier onlyPauseAdmin()
243   {
244     checkRole(msg.sender, ROLE_PAUSE_ADMIN);
245     _;
246   }
247   /**
248    * @dev constructor. Sets msg.sender as admin by default
249    */
250   constructor()
251     public
252   {
253     addRole(msg.sender, ROLE_ADMIN);
254     addRole(msg.sender, ROLE_PAUSE_ADMIN);
255   }
256 
257   /**
258    * @dev add a role to an address
259    * @param addr address
260    * @param roleName the name of the role
261    */
262   function adminAddRole(address addr, string roleName)
263     onlyAdmin
264     public
265   {
266     addRole(addr, roleName);
267   }
268 
269   /**
270    * @dev remove a role from an address
271    * @param addr address
272    * @param roleName the name of the role
273    */
274   function adminRemoveRole(address addr, string roleName)
275     onlyAdmin
276     public
277   {
278     removeRole(addr, roleName);
279   }
280 }
281 
282 contract Pausable is RBACWithAdmin {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!paused);
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(paused);
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyPauseAdmin whenNotPaused public {
309     paused = true;
310     emit Pause();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() onlyPauseAdmin whenPaused public {
317     paused = false;
318     emit Unpause();
319   }
320 }
321 
322 contract ReentrancyGuard {
323 
324   /**
325    * @dev We use a single lock for the whole contract.
326    */
327   bool private reentrancyLock = false;
328 
329   /**
330    * @dev Prevents a contract from calling itself, directly or indirectly.
331    * @notice If you mark a function `nonReentrant`, you should also
332    * mark it `external`. Calling one nonReentrant function from
333    * another is not supported. Instead, you can implement a
334    * `private` function doing the actual work, and a `external`
335    * wrapper marked as `nonReentrant`.
336    */
337   modifier nonReentrant() {
338     require(!reentrancyLock);
339     reentrancyLock = true;
340     _;
341     reentrancyLock = false;
342   }
343 
344 }
345 
346 contract CrowdSaleDragonETH is Pausable, ReentrancyGuard {
347     using SafeMath for uint256;
348     using AddressUtils for address;
349     address private wallet;
350     address public mainContract;
351     uint256 public crowdSaleDragonPrice = 0.01 ether;
352     uint256 public soldDragons;
353     uint256 public priceChanger = 0.00002 ether;
354     uint256 public timeToBorn = 5760; // ~ 24h
355     uint256 public contRefer50x50;
356     mapping(address => bool) public refer50x50;
357     
358     constructor(address _wallet, address _mainContract) public {
359         wallet = _wallet;
360         mainContract = _mainContract;
361     }
362 
363 
364     function() external payable whenNotPaused nonReentrant {
365         require(soldDragons <= 100000);
366         require(msg.value >= crowdSaleDragonPrice);
367         require(!msg.sender.isContract());
368         uint256 count_to_buy;
369         uint256 return_value;
370   
371         count_to_buy = msg.value.div(crowdSaleDragonPrice);
372         if (count_to_buy > 15) 
373             count_to_buy = 15;
374         // operation safety check with functions div() and require() above
375         return_value = msg.value - count_to_buy * crowdSaleDragonPrice;
376         if (return_value > 0) 
377             msg.sender.transfer(return_value);
378             
379         uint256 mainValue = msg.value - return_value;
380         
381         if (msg.data.length == 20) {
382             address referer = bytesToAddress(bytes(msg.data));
383             require(referer != msg.sender);
384             if (referer == address(0))
385                 wallet.transfer(mainValue);
386             else {
387                 if (refer50x50[referer]) {
388                     referer.transfer(mainValue/2);
389                     wallet.transfer(mainValue - mainValue/2);
390                 } else {
391                     referer.transfer(mainValue*3/10);
392                     wallet.transfer(mainValue - mainValue*3/10);
393                 }
394             }
395         } else 
396             wallet.transfer(mainValue);
397 
398         for(uint256 i = 1; i <= count_to_buy; i += 1) {
399             DragonsETH(mainContract).createDragon(msg.sender, block.number + timeToBorn, 0, 0, 0, 0);
400             soldDragons++;
401             crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
402         }
403         
404     }
405 
406     function sendBonusEgg(address _to, uint256 _count) external onlyRole("BountyAgent") {
407         for(uint256 i = 1; i <= _count; i += 1) {
408             DragonsETH(mainContract).createDragon(_to, block.number + timeToBorn, 0, 0, 0, 0);
409             soldDragons++;
410             crowdSaleDragonPrice = crowdSaleDragonPrice + priceChanger;
411         }
412         
413     }
414 
415 
416 
417     function changePrice(uint256 _price) external onlyAdmin {
418         crowdSaleDragonPrice = _price;
419     }
420 
421     function setPriceChanger(uint256 _priceChanger) external onlyAdmin {
422         priceChanger = _priceChanger;
423     }
424 
425     function changeWallet(address _wallet) external onlyAdmin {
426         wallet = _wallet;
427     }
428     
429 
430     function setRefer50x50(address _refer) external onlyAdmin {
431         require(contRefer50x50 < 50);
432         require(refer50x50[_refer] == false);
433         refer50x50[_refer] = true;
434         contRefer50x50 += 1;
435     }
436 
437     function setTimeToBorn(uint256 _timeToBorn) external onlyAdmin {
438         timeToBorn = _timeToBorn;
439         
440     }
441 
442     function withdrawAllEther() external onlyAdmin {
443         require(wallet != 0);
444         wallet.transfer(address(this).balance);
445     }
446    
447     function bytesToAddress(bytes _bytesData) internal pure returns(address _addressReferer) {
448         assembly {
449             _addressReferer := mload(add(_bytesData,0x14))
450         }
451         return _addressReferer;
452     }
453 }