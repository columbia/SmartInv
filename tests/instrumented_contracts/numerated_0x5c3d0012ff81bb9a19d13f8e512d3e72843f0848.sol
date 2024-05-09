1 pragma solidity ^0.4.24;
2 
3 contract RBAC {
4   using Roles for Roles.Role;
5 
6   mapping (string => Roles.Role) private roles;
7 
8   event RoleAdded(address indexed operator, string role);
9   event RoleRemoved(address indexed operator, string role);
10 
11   /**
12    * @dev reverts if addr does not have role
13    * @param _operator address
14    * @param _role the name of the role
15    * // reverts
16    */
17   function checkRole(address _operator, string _role)
18     public
19     view
20   {
21     roles[_role].check(_operator);
22   }
23 
24   /**
25    * @dev determine if addr has role
26    * @param _operator address
27    * @param _role the name of the role
28    * @return bool
29    */
30   function hasRole(address _operator, string _role)
31     public
32     view
33     returns (bool)
34   {
35     return roles[_role].has(_operator);
36   }
37 
38   /**
39    * @dev add a role to an address
40    * @param _operator address
41    * @param _role the name of the role
42    */
43   function addRole(address _operator, string _role)
44     internal
45   {
46     roles[_role].add(_operator);
47     emit RoleAdded(_operator, _role);
48   }
49 
50   /**
51    * @dev remove a role from an address
52    * @param _operator address
53    * @param _role the name of the role
54    */
55   function removeRole(address _operator, string _role)
56     internal
57   {
58     roles[_role].remove(_operator);
59     emit RoleRemoved(_operator, _role);
60   }
61 
62   /**
63    * @dev modifier to scope access to a single role (uses msg.sender as addr)
64    * @param _role the name of the role
65    * // reverts
66    */
67   modifier onlyRole(string _role)
68   {
69     checkRole(msg.sender, _role);
70     _;
71   }
72 
73   /**
74    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
75    * @param _roles the names of the roles to scope access to
76    * // reverts
77    *
78    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
79    *  see: https://github.com/ethereum/solidity/issues/2467
80    */
81   // modifier onlyRoles(string[] _roles) {
82   //     bool hasAnyRole = false;
83   //     for (uint8 i = 0; i < _roles.length; i++) {
84   //         if (hasRole(msg.sender, _roles[i])) {
85   //             hasAnyRole = true;
86   //             break;
87   //         }
88   //     }
89 
90   //     require(hasAnyRole);
91 
92   //     _;
93   // }
94 }
95 
96 library Roles {
97   struct Role {
98     mapping (address => bool) bearer;
99   }
100 
101   /**
102    * @dev give an address access to this role
103    */
104   function add(Role storage _role, address _addr)
105     internal
106   {
107     _role.bearer[_addr] = true;
108   }
109 
110   /**
111    * @dev remove an address' access to this role
112    */
113   function remove(Role storage _role, address _addr)
114     internal
115   {
116     _role.bearer[_addr] = false;
117   }
118 
119   /**
120    * @dev check if an address has this role
121    * // reverts
122    */
123   function check(Role storage _role, address _addr)
124     internal
125     view
126   {
127     require(has(_role, _addr));
128   }
129 
130   /**
131    * @dev check if an address has this role
132    * @return bool
133    */
134   function has(Role storage _role, address _addr)
135     internal
136     view
137     returns (bool)
138   {
139     return _role.bearer[_addr];
140   }
141 }
142 
143 library SafeMath {
144 
145   /**
146   * @dev Multiplies two numbers, throws on overflow.
147   */
148   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
149     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
150     // benefit is lost if 'b' is also tested.
151     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
152     if (_a == 0) {
153       return 0;
154     }
155 
156     c = _a * _b;
157     assert(c / _a == _b);
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers, truncating the quotient.
163   */
164   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
165     // assert(_b > 0); // Solidity automatically throws when dividing by 0
166     // uint256 c = _a / _b;
167     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
168     return _a / _b;
169   }
170 
171   /**
172   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
175     assert(_b <= _a);
176     return _a - _b;
177   }
178 
179   /**
180   * @dev Adds two numbers, throws on overflow.
181   */
182   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
183     c = _a + _b;
184     assert(c >= _a);
185     return c;
186   }
187 }
188 
189 contract Ownable {
190   address public owner;
191 
192 
193   event OwnershipRenounced(address indexed previousOwner);
194   event OwnershipTransferred(
195     address indexed previousOwner,
196     address indexed newOwner
197   );
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   constructor() public {
205     owner = msg.sender;
206   }
207 
208   /**
209    * @dev Throws if called by any account other than the owner.
210    */
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216   /**
217    * @dev Allows the current owner to relinquish control of the contract.
218    * @notice Renouncing to ownership will leave the contract without an owner.
219    * It will not be possible to call the functions with the `onlyOwner`
220    * modifier anymore.
221    */
222   function renounceOwnership() public onlyOwner {
223     emit OwnershipRenounced(owner);
224     owner = address(0);
225   }
226 
227   /**
228    * @dev Allows the current owner to transfer control of the contract to a newOwner.
229    * @param _newOwner The address to transfer ownership to.
230    */
231   function transferOwnership(address _newOwner) public onlyOwner {
232     _transferOwnership(_newOwner);
233   }
234 
235   /**
236    * @dev Transfers control of the contract to a newOwner.
237    * @param _newOwner The address to transfer ownership to.
238    */
239   function _transferOwnership(address _newOwner) internal {
240     require(_newOwner != address(0));
241     emit OwnershipTransferred(owner, _newOwner);
242     owner = _newOwner;
243   }
244 }
245 
246 contract Claimable is Ownable {
247   address public pendingOwner;
248 
249   /**
250    * @dev Modifier throws if called by any account other than the pendingOwner.
251    */
252   modifier onlyPendingOwner() {
253     require(msg.sender == pendingOwner);
254     _;
255   }
256 
257   /**
258    * @dev Allows the current owner to set the pendingOwner address.
259    * @param newOwner The address to transfer ownership to.
260    */
261   function transferOwnership(address newOwner) public onlyOwner {
262     pendingOwner = newOwner;
263   }
264 
265   /**
266    * @dev Allows the pendingOwner address to finalize the transfer.
267    */
268   function claimOwnership() public onlyPendingOwner {
269     emit OwnershipTransferred(owner, pendingOwner);
270     owner = pendingOwner;
271     pendingOwner = address(0);
272   }
273 }
274 
275 contract SimpleFlyDropToken is Claimable {
276     using SafeMath for uint256;
277 
278     ERC20 internal erc20tk;
279 
280     function setToken(address _token) onlyOwner public {
281         require(_token != address(0));
282         erc20tk = ERC20(_token);
283     }
284 
285     /**
286      * @dev Send tokens to other multi addresses in one function
287      *
288      * @param _destAddrs address The addresses which you want to send tokens to
289      * @param _values uint256 the amounts of tokens to be sent
290      */
291     function multiSend(address[] _destAddrs, uint256[] _values) onlyOwner public returns (uint256) {
292         require(_destAddrs.length == _values.length);
293 
294         uint256 i = 0;
295         for (; i < _destAddrs.length; i = i.add(1)) {
296             if (!erc20tk.transfer(_destAddrs[i], _values[i])) {
297                 break;
298             }
299         }
300 
301         return (i);
302     }
303 }
304 
305 contract DelayedClaimable is Claimable {
306 
307   uint256 public end;
308   uint256 public start;
309 
310   /**
311    * @dev Used to specify the time period during which a pending
312    * owner can claim ownership.
313    * @param _start The earliest time ownership can be claimed.
314    * @param _end The latest time ownership can be claimed.
315    */
316   function setLimits(uint256 _start, uint256 _end) public onlyOwner {
317     require(_start <= _end);
318     end = _end;
319     start = _start;
320   }
321 
322   /**
323    * @dev Allows the pendingOwner address to finalize the transfer, as long as it is called within
324    * the specified start and end time.
325    */
326   function claimOwnership() public onlyPendingOwner {
327     require((block.number <= end) && (block.number >= start));
328     emit OwnershipTransferred(owner, pendingOwner);
329     owner = pendingOwner;
330     pendingOwner = address(0);
331     end = 0;
332   }
333 
334 }
335 
336 contract Poweruser is DelayedClaimable, RBAC {
337   string public constant ROLE_POWERUSER = "poweruser";
338 
339   constructor () public {
340     addRole(msg.sender, ROLE_POWERUSER);
341   }
342 
343   /**
344    * @dev Throws if called by any account that's not a superuser.
345    */
346   modifier onlyPoweruser() {
347     checkRole(msg.sender, ROLE_POWERUSER);
348     _;
349   }
350 
351   modifier onlyOwnerOrPoweruser() {
352     require(msg.sender == owner || isPoweruser(msg.sender));
353     _;
354   }
355 
356   /**
357    * @dev getter to determine if address has poweruser role
358    */
359   function isPoweruser(address _addr)
360     public
361     view
362     returns (bool)
363   {
364     return hasRole(_addr, ROLE_POWERUSER);
365   }
366 
367   /**
368    * @dev Add a new account address as power user.
369    * @param _newPoweruser The address to be as a power user.
370    */
371   function addPoweruser(address _newPoweruser) public onlyOwner {
372     require(_newPoweruser != address(0));
373     addRole(_newPoweruser, ROLE_POWERUSER);
374   }
375 
376   /**
377    * @dev Remove a new account address from power user list.
378    * @param _oldPoweruser The address to be as a power user.
379    */
380   function removePoweruser(address _oldPoweruser) public onlyOwner {
381     require(_oldPoweruser != address(0));
382     removeRole(_oldPoweruser, ROLE_POWERUSER);
383   }
384 }
385 
386 contract FlyDropTokenMgr is Poweruser {
387     using SafeMath for uint256;
388 
389     address[] dropTokenAddrs;
390     SimpleFlyDropToken currentDropTokenContract;
391     // mapping(address => mapping (address => uint256)) budgets;
392 
393     /**
394      * @dev Send tokens to other multi addresses in one function
395      *
396      * @param _rand a random index for choosing a FlyDropToken contract address
397      * @param _from address The address which you want to send tokens from
398      * @param _value uint256 the amounts of tokens to be sent
399      * @param _token address the ERC20 token address
400      */
401     function prepare(uint256 _rand,
402                      address _from,
403                      address _token,
404                      uint256 _value) onlyOwnerOrPoweruser public returns (bool) {
405         require(_token != address(0));
406         require(_from != address(0));
407         require(_rand > 0);
408 
409         if (ERC20(_token).allowance(_from, this) < _value) {
410             return false;
411         }
412 
413         if (_rand > dropTokenAddrs.length) {
414             SimpleFlyDropToken dropTokenContract = new SimpleFlyDropToken();
415             dropTokenAddrs.push(address(dropTokenContract));
416             currentDropTokenContract = dropTokenContract;
417         } else {
418             currentDropTokenContract = SimpleFlyDropToken(dropTokenAddrs[_rand.sub(1)]);
419         }
420 
421         currentDropTokenContract.setToken(_token);
422         return ERC20(_token).transferFrom(_from, currentDropTokenContract, _value);
423         // budgets[_token][_from] = budgets[_token][_from].sub(_value);
424         // return itoken(_token).approveAndCall(currentDropTokenContract, _value, _extraData);
425         // return true;
426     }
427 
428     // function setBudget(address _token, address _from, uint256 _value) onlyOwner public {
429     //     require(_token != address(0));
430     //     require(_from != address(0));
431 
432     //     budgets[_token][_from] = _value;
433     // }
434 
435     /**
436      * @dev Send tokens to other multi addresses in one function
437      *
438      * @param _destAddrs address The addresses which you want to send tokens to
439      * @param _values uint256 the amounts of tokens to be sent
440      */
441     function flyDrop(address[] _destAddrs, uint256[] _values) onlyOwnerOrPoweruser public returns (uint256) {
442         require(address(currentDropTokenContract) != address(0));
443         return currentDropTokenContract.multiSend(_destAddrs, _values);
444     }
445 
446 }
447 
448 contract ERC20Basic {
449   function totalSupply() public view returns (uint256);
450   function balanceOf(address _who) public view returns (uint256);
451   function transfer(address _to, uint256 _value) public returns (bool);
452   event Transfer(address indexed from, address indexed to, uint256 value);
453 }
454 
455 contract ERC20 is ERC20Basic {
456   function allowance(address _owner, address _spender)
457     public view returns (uint256);
458 
459   function transferFrom(address _from, address _to, uint256 _value)
460     public returns (bool);
461 
462   function approve(address _spender, uint256 _value) public returns (bool);
463   event Approval(
464     address indexed owner,
465     address indexed spender,
466     uint256 value
467   );
468 }