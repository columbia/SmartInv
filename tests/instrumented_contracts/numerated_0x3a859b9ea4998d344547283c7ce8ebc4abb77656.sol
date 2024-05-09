1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 library Roles {
116   struct Role {
117     mapping (address => bool) bearer;
118   }
119 
120   /**
121    * @dev give an address access to this role
122    */
123   function add(Role storage role, address addr)
124     internal
125   {
126     role.bearer[addr] = true;
127   }
128 
129   /**
130    * @dev remove an address' access to this role
131    */
132   function remove(Role storage role, address addr)
133     internal
134   {
135     role.bearer[addr] = false;
136   }
137 
138   /**
139    * @dev check if an address has this role
140    * // reverts
141    */
142   function check(Role storage role, address addr)
143     view
144     internal
145   {
146     require(has(role, addr));
147   }
148 
149   /**
150    * @dev check if an address has this role
151    * @return bool
152    */
153   function has(Role storage role, address addr)
154     view
155     internal
156     returns (bool)
157   {
158     return role.bearer[addr];
159   }
160 }
161 
162 contract BasicToken is ERC20Basic {
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167   uint256 totalSupply_;
168 
169   /**
170   * @dev Total number of tokens in existence
171   */
172   function totalSupply() public view returns (uint256) {
173     return totalSupply_;
174   }
175 
176   /**
177   * @dev Transfer token for a specified address
178   * @param _to The address to transfer to.
179   * @param _value The amount to be transferred.
180   */
181   function transfer(address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     require(_value <= balances[msg.sender]);
184 
185     balances[msg.sender] = balances[msg.sender].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     emit Transfer(msg.sender, _to, _value);
188     return true;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 contract MultiSigTransfer is Ownable {
203   string public name = "MultiSigTransfer";
204   string public symbol = "MST";
205   bool public complete = false;
206   bool public denied = false;
207   uint32 public quantity;
208   address public targetAddress;
209   address public requesterAddress;
210 
211   /**
212   * @dev The multisig transfer contract ensures that no single administrator can
213   * KVTs without approval of another administrator
214   * @param _quantity The number of KVT to transfer
215   * @param _targetAddress The receiver of the KVTs
216   * @param _requesterAddress The administrator requesting the transfer
217   */
218   constructor(
219     uint32 _quantity,
220     address _targetAddress,
221     address _requesterAddress
222   ) public {
223     quantity = _quantity;
224     targetAddress = _targetAddress;
225     requesterAddress = _requesterAddress;
226   }
227 
228   /**
229   * @dev Mark the transfer as approved / complete
230   */
231   function approveTransfer() public onlyOwner {
232     require(denied == false, "cannot approve a denied transfer");
233     require(complete == false, "cannot approve a complete transfer");
234     complete = true;
235   }
236 
237   /**
238   * @dev Mark the transfer as denied
239   */
240   function denyTransfer() public onlyOwner {
241     require(denied == false, "cannot deny a transfer that is already denied");
242     denied = true;
243   }
244 
245   /**
246   * @dev Determine if the transfer is pending
247   */
248   function isPending() public view returns (bool) {
249     return !complete;
250   }
251 }
252 
253 contract RBAC {
254   using Roles for Roles.Role;
255 
256   mapping (string => Roles.Role) private roles;
257 
258   event RoleAdded(address indexed operator, string role);
259   event RoleRemoved(address indexed operator, string role);
260 
261   /**
262    * @dev reverts if addr does not have role
263    * @param _operator address
264    * @param _role the name of the role
265    * // reverts
266    */
267   function checkRole(address _operator, string _role)
268     view
269     public
270   {
271     roles[_role].check(_operator);
272   }
273 
274   /**
275    * @dev determine if addr has role
276    * @param _operator address
277    * @param _role the name of the role
278    * @return bool
279    */
280   function hasRole(address _operator, string _role)
281     view
282     public
283     returns (bool)
284   {
285     return roles[_role].has(_operator);
286   }
287 
288   /**
289    * @dev add a role to an address
290    * @param _operator address
291    * @param _role the name of the role
292    */
293   function addRole(address _operator, string _role)
294     internal
295   {
296     roles[_role].add(_operator);
297     emit RoleAdded(_operator, _role);
298   }
299 
300   /**
301    * @dev remove a role from an address
302    * @param _operator address
303    * @param _role the name of the role
304    */
305   function removeRole(address _operator, string _role)
306     internal
307   {
308     roles[_role].remove(_operator);
309     emit RoleRemoved(_operator, _role);
310   }
311 
312   /**
313    * @dev modifier to scope access to a single role (uses msg.sender as addr)
314    * @param _role the name of the role
315    * // reverts
316    */
317   modifier onlyRole(string _role)
318   {
319     checkRole(msg.sender, _role);
320     _;
321   }
322 
323   /**
324    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
325    * @param _roles the names of the roles to scope access to
326    * // reverts
327    *
328    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
329    *  see: https://github.com/ethereum/solidity/issues/2467
330    */
331   // modifier onlyRoles(string[] _roles) {
332   //     bool hasAnyRole = false;
333   //     for (uint8 i = 0; i < _roles.length; i++) {
334   //         if (hasRole(msg.sender, _roles[i])) {
335   //             hasAnyRole = true;
336   //             break;
337   //         }
338   //     }
339 
340   //     require(hasAnyRole);
341 
342   //     _;
343   // }
344 }
345 
346 contract KinesisVelocityToken is BasicToken, Ownable, RBAC {
347   string public name = "KinesisVelocityToken";
348   string public symbol = "KVT";
349   uint8 public decimals = 0;
350   string public constant ADMIN_ROLE = "ADMIN";
351 
352   address[] public transfers;
353 
354   uint public constant INITIAL_SUPPLY = 300000;
355   uint public totalSupply = 0;
356 
357   bool public isTransferable = false;
358   bool public toggleTransferablePending = false;
359   address public transferToggleRequester = address(0);
360 
361   constructor() public {
362     totalSupply = INITIAL_SUPPLY;
363     balances[msg.sender] = INITIAL_SUPPLY;
364     addRole(msg.sender, ADMIN_ROLE);
365   }
366 
367   /**
368   * @dev Determine if the address is the owner of the contract
369   * @param _address The address to determine of ownership
370   */
371   function isOwner(address _address) public view returns (bool) {
372     return owner == _address;
373   }
374 
375   /**
376   * @dev Returns the list of MultiSig transfers
377   */
378   function getTransfers() public view returns (address[]) {
379     return transfers;
380   }
381 
382   /**
383   * @dev The KVT ERC20 token uses adminstrators to handle transfering to the crowdsale, vesting and pre-purchasers
384   */
385   function isAdmin(address _address) public view returns (bool) {
386     return hasRole(_address, ADMIN_ROLE);
387   }
388 
389   /**
390   * @dev Set an administrator as the owner, using Open Zepplin RBAC implementation
391   */
392   function setAdmin(address _newAdmin) public onlyOwner {
393     return addRole(_newAdmin, ADMIN_ROLE);
394   }
395 
396   /**
397   * @dev Remove an administrator as the owner, using Open Zepplin RBAC implementation
398   */
399   function removeAdmin(address _oldAdmin) public onlyOwner {
400     return removeRole(_oldAdmin, ADMIN_ROLE);
401   }
402 
403   /**
404   * @dev As an administrator, request the token is made transferable
405   * @param _toState The transfer state being requested
406   */
407   function setTransferable(bool _toState) public onlyRole(ADMIN_ROLE) {
408     require(isTransferable != _toState, "to init a transfer toggle, the toState must change");
409     toggleTransferablePending = true;
410     transferToggleRequester = msg.sender;
411   }
412 
413   /**
414   * @dev As an administrator who did not make the request, approve the transferable state change
415   */
416   function approveTransferableToggle() public onlyRole(ADMIN_ROLE) {
417     require(toggleTransferablePending == true, "transfer toggle not in pending state");
418     require(transferToggleRequester != msg.sender, "the requester cannot approve the transfer toggle");
419     isTransferable = !isTransferable;
420     toggleTransferablePending = false;
421     transferToggleRequester = address(0);
422   }
423 
424   /**
425   * @dev transfer token for a specified address
426   * @param _to The address to transfer to.
427   * @param _value The amount to be transferred.
428   */
429   function _transfer(address _to, address _from, uint256 _value) private returns (bool) {
430     require(_value <= balances[_from], "the balance in the from address is smaller than the tx value");
431 
432     // SafeMath.sub will throw if there is not enough balance.
433     balances[_from] = balances[_from].sub(_value);
434     balances[_to] = balances[_to].add(_value);
435     emit Transfer(_from, _to, _value);
436     return true;
437   }
438 
439   /**
440   * @dev Public transfer token function. This wrapper ensures the token is transferable
441   * @param _to The address to transfer to.
442   * @param _value The amount to be transferred.
443   */
444   function transfer(address _to, uint256 _value) public returns (bool) {
445     require(_to != address(0), "cannot transfer to the zero address");
446 
447     /* We allow holders to return their Tokens to the contract owner at any point */
448     if (_to != owner && msg.sender != crowdsale) {
449       require(isTransferable == true, "kvt is not yet transferable");
450     }
451 
452     /* Transfers from the owner address must use the administrative transfer */
453     require(msg.sender != owner, "the owner of the kvt contract cannot transfer");
454 
455     return _transfer(_to, msg.sender, _value);
456   }
457 
458   /**
459   * @dev Request an administrative transfer. This does not move tokens
460   * @param _to The address to transfer to.
461   * @param _quantity The amount to be transferred.
462   */
463   function adminTransfer(address _to, uint32 _quantity) public onlyRole(ADMIN_ROLE) {
464     address newTransfer = new MultiSigTransfer(_quantity, _to, msg.sender);
465     transfers.push(newTransfer);
466   }
467 
468   /**
469   * @dev Approve an administrative transfer. This moves the tokens if the requester
470   * is an admin, but not the same admin as the one who made the request
471   * @param _approvedTransfer The contract address of the multisignature transfer.
472   */
473   function approveTransfer(address _approvedTransfer) public onlyRole(ADMIN_ROLE) returns (bool) {
474     MultiSigTransfer transferToApprove = MultiSigTransfer(_approvedTransfer);
475 
476     uint32 transferQuantity = transferToApprove.quantity();
477     address deliveryAddress = transferToApprove.targetAddress();
478     address requesterAddress = transferToApprove.requesterAddress();
479 
480     require(msg.sender != requesterAddress, "a requester cannot approve an admin transfer");
481 
482     transferToApprove.approveTransfer();
483     return _transfer(deliveryAddress, owner, transferQuantity);
484   }
485 
486   /**
487   * @dev Deny an administrative transfer. This ensures it cannot be approved.
488   * @param _approvedTransfer The contract address of the multisignature transfer.
489   */
490   function denyTransfer(address _approvedTransfer) public onlyRole(ADMIN_ROLE) returns (bool) {
491     MultiSigTransfer transferToApprove = MultiSigTransfer(_approvedTransfer);
492     transferToApprove.denyTransfer();
493   }
494 
495   address public crowdsale = address(0);
496 
497   /**
498   * @dev Any admin can set the current crowdsale address, to allows transfers
499   * from the crowdsale to the purchaser
500   */
501   function setCrowdsaleAddress(address _crowdsaleAddress) public onlyRole(ADMIN_ROLE) {
502     crowdsale = _crowdsaleAddress;
503   }
504 }