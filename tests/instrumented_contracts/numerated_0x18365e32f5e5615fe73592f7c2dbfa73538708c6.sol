1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 
115 /**
116  * @title Roles
117  * @author Francisco Giordano (@frangio)
118  * @dev Library for managing addresses assigned to a Role.
119  *      See RBAC.sol for example usage.
120  */
121 library Roles {
122   struct Role {
123     mapping (address => bool) bearer;
124   }
125 
126   /**
127    * @dev give an address access to this role
128    */
129   function add(Role storage role, address addr)
130     internal
131   {
132     role.bearer[addr] = true;
133   }
134 
135   /**
136    * @dev remove an address' access to this role
137    */
138   function remove(Role storage role, address addr)
139     internal
140   {
141     role.bearer[addr] = false;
142   }
143 
144   /**
145    * @dev check if an address has this role
146    * // reverts
147    */
148   function check(Role storage role, address addr)
149     view
150     internal
151   {
152     require(has(role, addr));
153   }
154 
155   /**
156    * @dev check if an address has this role
157    * @return bool
158    */
159   function has(Role storage role, address addr)
160     view
161     internal
162     returns (bool)
163   {
164     return role.bearer[addr];
165   }
166 }
167 
168 contract RBAC {
169   using Roles for Roles.Role;
170 
171   mapping (string => Roles.Role) private roles;
172 
173   event RoleAdded(address addr, string roleName);
174   event RoleRemoved(address addr, string roleName);
175 
176   /**
177    * @dev reverts if addr does not have role
178    * @param addr address
179    * @param roleName the name of the role
180    * // reverts
181    */
182   function checkRole(address addr, string roleName)
183     view
184     public
185   {
186     roles[roleName].check(addr);
187   }
188 
189   /**
190    * @dev determine if addr has role
191    * @param addr address
192    * @param roleName the name of the role
193    * @return bool
194    */
195   function hasRole(address addr, string roleName)
196     view
197     public
198     returns (bool)
199   {
200     return roles[roleName].has(addr);
201   }
202 
203   /**
204    * @dev add a role to an address
205    * @param addr address
206    * @param roleName the name of the role
207    */
208   function addRole(address addr, string roleName)
209     internal
210   {
211     roles[roleName].add(addr);
212     emit RoleAdded(addr, roleName);
213   }
214 
215   /**
216    * @dev remove a role from an address
217    * @param addr address
218    * @param roleName the name of the role
219    */
220   function removeRole(address addr, string roleName)
221     internal
222   {
223     roles[roleName].remove(addr);
224     emit RoleRemoved(addr, roleName);
225   }
226 
227   /**
228    * @dev modifier to scope access to a single role (uses msg.sender as addr)
229    * @param roleName the name of the role
230    * // reverts
231    */
232   modifier onlyRole(string roleName)
233   {
234     checkRole(msg.sender, roleName);
235     _;
236   }
237 
238   /**
239    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
240    * @param roleNames the names of the roles to scope access to
241    * // reverts
242    *
243    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
244    *  see: https://github.com/ethereum/solidity/issues/2467
245    */
246   // modifier onlyRoles(string[] roleNames) {
247   //     bool hasAnyRole = false;
248   //     for (uint8 i = 0; i < roleNames.length; i++) {
249   //         if (hasRole(msg.sender, roleNames[i])) {
250   //             hasAnyRole = true;
251   //             break;
252   //         }
253   //     }
254 
255   //     require(hasAnyRole);
256 
257   //     _;
258   // }
259 }
260 
261 
262 /**
263  * @title Whitelist
264  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
265  * @dev This simplifies the implementation of "user permissions".
266  */
267 contract Whitelist is Ownable, RBAC {
268   event WhitelistedAddressAdded(address addr);
269   event WhitelistedAddressRemoved(address addr);
270 
271   string public constant ROLE_WHITELISTED = "whitelist";
272 
273   /**
274    * @dev Throws if called by any account that's not whitelisted.
275    */
276   modifier onlyWhitelisted() {
277     checkRole(msg.sender, ROLE_WHITELISTED);
278     _;
279   }
280 
281   /**
282    * @dev add an address to the whitelist
283    * @param addr address
284    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
285    */
286   function addAddressToWhitelist(address addr)
287     onlyOwner
288     public
289   {
290     addRole(addr, ROLE_WHITELISTED);
291     emit WhitelistedAddressAdded(addr);
292   }
293 
294   /**
295    * @dev getter to determine if address is in whitelist
296    */
297   function whitelist(address addr)
298     public
299     view
300     returns (bool)
301   {
302     return hasRole(addr, ROLE_WHITELISTED);
303   }
304 
305   /**
306    * @dev add addresses to the whitelist
307    * @param addrs addresses
308    * @return true if at least one address was added to the whitelist,
309    * false if all addresses were already in the whitelist
310    */
311   function addAddressesToWhitelist(address[] addrs)
312     onlyOwner
313     public
314   {
315     for (uint256 i = 0; i < addrs.length; i++) {
316       addAddressToWhitelist(addrs[i]);
317     }
318   }
319 
320   /**
321    * @dev remove an address from the whitelist
322    * @param addr address
323    * @return true if the address was removed from the whitelist,
324    * false if the address wasn't in the whitelist in the first place
325    */
326   function removeAddressFromWhitelist(address addr)
327     onlyOwner
328     public
329   {
330     removeRole(addr, ROLE_WHITELISTED);
331     emit WhitelistedAddressRemoved(addr);
332   }
333 
334   /**
335    * @dev remove addresses from the whitelist
336    * @param addrs addresses
337    * @return true if at least one address was removed from the whitelist,
338    * false if all addresses weren't in the whitelist in the first place
339    */
340   function removeAddressesFromWhitelist(address[] addrs)
341     onlyOwner
342     public
343   {
344     for (uint256 i = 0; i < addrs.length; i++) {
345       removeAddressFromWhitelist(addrs[i]);
346     }
347   }
348 
349 }
350 
351 
352 
353 /**
354  * @title ERC20Basic
355  * @dev Simpler version of ERC20 interface
356  * @dev see https://github.com/ethereum/EIPs/issues/179
357  */
358 contract ERC20Basic {
359   function totalSupply() public view returns (uint256);
360   function balanceOf(address who) public view returns (uint256);
361   function transfer(address to, uint256 value) public returns (bool);
362   event Transfer(address indexed from, address indexed to, uint256 value);
363 }
364 
365 /**
366  * @title ERC20 interface
367  * @dev see https://github.com/ethereum/EIPs/issues/20
368  */
369 contract ERC20 is ERC20Basic {
370   function allowance(address owner, address spender)
371     public view returns (uint256);
372 
373   function transferFrom(address from, address to, uint256 value)
374     public returns (bool);
375 
376   function approve(address spender, uint256 value) public returns (bool);
377   event Approval(
378     address indexed owner,
379     address indexed spender,
380     uint256 value
381   );
382 }
383 
384 contract PreSaleI is Whitelist {
385     using SafeMath for uint256;
386     // rate is the amount of token to the ether. Bonus rate is included in exchange rate.
387     uint256 public exchangeRate;
388     
389     // in ETH(wei), not token
390     uint256 public minValue;
391     uint256 public maxTotal;
392     uint256 public maxPerAddress;
393 
394     uint256 public startTimestamp;
395     uint256 public endTimestamp;
396     bool public enabled;
397 
398     address public wallet;
399     ERC20 public token;
400     
401     // in ETH(wei), not token
402     uint256 public accumulatedAmount = 0;
403     uint256 public accumulatedAmountExternal = 0;
404     mapping (address => uint256) public buyAmounts;
405 
406     address[] public addresses;
407 
408     constructor(ERC20 _token, address _wallet, uint256 _exchangeRate, uint256 _minValue, uint256 _maxTotal, uint256 _maxPerAddress, uint256 _startTimestamp, uint256 _endTimestamp) public {
409         require(_token != address(0));
410         require(_wallet != address(0));
411         token = _token;
412         wallet = _wallet;
413         exchangeRate = _exchangeRate;
414         minValue = _minValue;
415         maxTotal = _maxTotal;
416         maxPerAddress = _maxPerAddress;
417         startTimestamp = _startTimestamp;
418         endTimestamp = _endTimestamp;
419         enabled = false;
420     }
421 
422     function toggleEnabled() public onlyOwner {
423         enabled = !enabled;
424         emit ToggleEnabled(enabled);
425     }
426     event ToggleEnabled(bool _enabled);
427 
428     function updateExternalAmount(uint256 _amount) public onlyOwner {
429         accumulatedAmountExternal = _amount;
430         emit UpdateTotalAmount(accumulatedAmount.add(accumulatedAmountExternal));
431     }
432     event UpdateTotalAmount(uint256 _totalAmount);
433 
434     function () external payable {
435         if (msg.sender != wallet) {
436             buyTokens();
437         }
438     }
439 
440     function buyTokens() public payable onlyWhitelisted {
441         //require(msg.sender != address(0));
442         require(enabled);
443         require(block.timestamp >= startTimestamp && block.timestamp <= endTimestamp);
444         require(msg.value >= minValue);
445         require(buyAmounts[msg.sender] < maxPerAddress);
446         require(accumulatedAmount.add(accumulatedAmountExternal) < maxTotal);
447 
448         uint256 buyAmount;
449         uint256 refundAmount;
450         (buyAmount, refundAmount) = _calculateAmounts(msg.sender, msg.value);
451 
452         if (buyAmounts[msg.sender] == 0) {
453             addresses.push(msg.sender);
454         }
455 
456         accumulatedAmount = accumulatedAmount.add(buyAmount);
457         buyAmounts[msg.sender] = buyAmounts[msg.sender].add(buyAmount);
458         msg.sender.transfer(refundAmount);
459         emit BuyTokens(msg.sender, buyAmount, refundAmount, buyAmount.mul(exchangeRate));
460     }
461     event BuyTokens(address indexed _addr, uint256 _buyAmount, uint256 _refundAmount, uint256 _tokenAmount);
462 
463     function deliver(address _addr) public onlyOwner {
464         require(_isEndCollect());
465         uint256 amount = buyAmounts[_addr];
466         require(amount > 0);
467         uint256 tokenAmount = amount.mul(exchangeRate);
468         buyAmounts[_addr] = 0;
469         token.transfer(_addr, tokenAmount);
470         emit Deliver(_addr, tokenAmount);
471     }
472     event Deliver(address indexed _addr, uint256 _tokenAmount);
473 
474     function refund(address _addr) public onlyOwner {
475         require(_isEndCollect());
476         uint256 amount = buyAmounts[_addr];
477         require(amount > 0);
478         buyAmounts[_addr] = 0;
479         _addr.transfer(amount);
480         accumulatedAmount = accumulatedAmount.sub(amount);
481         emit Refund(_addr, amount);
482     }
483     event Refund(address indexed _addr, uint256 _buyAmount);
484 
485     function withdrawEth() public onlyOwner {
486         wallet.transfer(address(this).balance);
487         emit WithdrawEth(wallet, address(this).balance);
488     }
489     event WithdrawEth(address indexed _addr, uint256 _etherAmount);
490 
491     function terminate() public onlyOwner {
492         require(getNotDelivered() == address(0));
493         token.transfer(wallet, token.balanceOf(address(this)));
494         wallet.transfer(address(this).balance);
495         emit Terminate(wallet, token.balanceOf(address(this)), address(this).balance);
496     }
497     event Terminate(address indexed _addr, uint256 _tokenAmount, uint256 _etherAmount);
498 
499     function getNotDelivered() public view returns (address) {
500         for(uint256 i = 0; i < addresses.length; i++) {
501             if (buyAmounts[addresses[i]] != 0) {
502                 return addresses[i];
503             }
504         }
505         return address(0);
506     }
507 
508     function _calculateAmounts(address _buyAddress, uint256 _buyAmount) private view returns (uint256, uint256) {
509         uint256 buyLimit1 = maxTotal.sub(accumulatedAmount.add(accumulatedAmountExternal));
510         uint256 buyLimit2 = maxPerAddress.sub(buyAmounts[_buyAddress]);
511         uint256 buyLimit = buyLimit1 > buyLimit2 ? buyLimit2 : buyLimit1;
512         uint256 buyAmount = _buyAmount > buyLimit ? buyLimit : _buyAmount;
513         uint256 refundAmount = _buyAmount.sub(buyAmount);
514         return (buyAmount, refundAmount);
515     }
516 
517     function _isEndCollect() private view returns (bool) {
518         return !enabled && block.timestamp> endTimestamp;
519     }
520 }