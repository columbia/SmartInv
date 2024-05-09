1 pragma solidity 0.4.23;
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
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) public onlyOwner {
85     require(newOwner != address(0));
86     emit OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    */
93   function renounceOwnership() public onlyOwner {
94     emit OwnershipRenounced(owner);
95     owner = address(0);
96   }
97 }
98 
99 
100 /**
101  * @title Roles
102  * @author Francisco Giordano (@frangio)
103  * @dev Library for managing addresses assigned to a Role.
104  *      See RBAC.sol for example usage.
105  */
106 library Roles {
107   struct Role {
108     mapping (address => bool) bearer;
109   }
110 
111   /**
112    * @dev give an address access to this role
113    */
114   function add(Role storage role, address addr)
115     internal
116   {
117     role.bearer[addr] = true;
118   }
119 
120   /**
121    * @dev remove an address' access to this role
122    */
123   function remove(Role storage role, address addr)
124     internal
125   {
126     role.bearer[addr] = false;
127   }
128 
129   /**
130    * @dev check if an address has this role
131    * // reverts
132    */
133   function check(Role storage role, address addr)
134     view
135     internal
136   {
137     require(has(role, addr));
138   }
139 
140   /**
141    * @dev check if an address has this role
142    * @return bool
143    */
144   function has(Role storage role, address addr)
145     view
146     internal
147     returns (bool)
148   {
149     return role.bearer[addr];
150   }
151 }
152 
153 
154 /**
155  * @title RBAC (Role-Based Access Control)
156  * @author Matt Condon (@Shrugs)
157  * @dev Stores and provides setters and getters for roles and addresses.
158  * @dev Supports unlimited numbers of roles and addresses.
159  * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
160  * This RBAC method uses strings to key roles. It may be beneficial
161  *  for you to write your own implementation of this interface using Enums or similar.
162  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
163  *  to avoid typos.
164  */
165 contract RBAC {
166   using Roles for Roles.Role;
167 
168   mapping (string => Roles.Role) private roles;
169 
170   event RoleAdded(address addr, string roleName);
171   event RoleRemoved(address addr, string roleName);
172 
173   /**
174    * @dev reverts if addr does not have role
175    * @param addr address
176    * @param roleName the name of the role
177    * // reverts
178    */
179   function checkRole(address addr, string roleName)
180     view
181     public
182   {
183     roles[roleName].check(addr);
184   }
185 
186   /**
187    * @dev determine if addr has role
188    * @param addr address
189    * @param roleName the name of the role
190    * @return bool
191    */
192   function hasRole(address addr, string roleName)
193     view
194     public
195     returns (bool)
196   {
197     return roles[roleName].has(addr);
198   }
199 
200   /**
201    * @dev add a role to an address
202    * @param addr address
203    * @param roleName the name of the role
204    */
205   function addRole(address addr, string roleName)
206     internal
207   {
208     roles[roleName].add(addr);
209     emit RoleAdded(addr, roleName);
210   }
211 
212   /**
213    * @dev remove a role from an address
214    * @param addr address
215    * @param roleName the name of the role
216    */
217   function removeRole(address addr, string roleName)
218     internal
219   {
220     roles[roleName].remove(addr);
221     emit RoleRemoved(addr, roleName);
222   }
223 
224   /**
225    * @dev modifier to scope access to a single role (uses msg.sender as addr)
226    * @param roleName the name of the role
227    * // reverts
228    */
229   modifier onlyRole(string roleName)
230   {
231     checkRole(msg.sender, roleName);
232     _;
233   }
234 
235   /**
236    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
237    * @param roleNames the names of the roles to scope access to
238    * // reverts
239    *
240    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
241    *  see: https://github.com/ethereum/solidity/issues/2467
242    */
243   // modifier onlyRoles(string[] roleNames) {
244   //     bool hasAnyRole = false;
245   //     for (uint8 i = 0; i < roleNames.length; i++) {
246   //         if (hasRole(msg.sender, roleNames[i])) {
247   //             hasAnyRole = true;
248   //             break;
249   //         }
250   //     }
251 
252   //     require(hasAnyRole);
253 
254   //     _;
255   // }
256 }
257 
258 
259 /**
260  * @title Whitelist
261  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
262  * @dev This simplifies the implementation of "user permissions".
263  */
264 contract Whitelist is Ownable, RBAC {
265   event WhitelistedAddressAdded(address addr);
266   event WhitelistedAddressRemoved(address addr);
267 
268   string public constant ROLE_WHITELISTED = "whitelist";
269 
270   /**
271    * @dev Throws if called by any account that's not whitelisted.
272    */
273   modifier onlyWhitelisted() {
274     checkRole(msg.sender, ROLE_WHITELISTED);
275     _;
276   }
277 
278   /**
279    * @dev add an address to the whitelist
280    * @param addr address
281    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
282    */
283   function addAddressToWhitelist(address addr)
284     onlyOwner
285     public
286   {
287     addRole(addr, ROLE_WHITELISTED);
288     emit WhitelistedAddressAdded(addr);
289   }
290 
291   /**
292    * @dev getter to determine if address is in whitelist
293    */
294   function whitelist(address addr)
295     public
296     view
297     returns (bool)
298   {
299     return hasRole(addr, ROLE_WHITELISTED);
300   }
301 
302   /**
303    * @dev add addresses to the whitelist
304    * @param addrs addresses
305    * @return true if at least one address was added to the whitelist,
306    * false if all addresses were already in the whitelist
307    */
308   function addAddressesToWhitelist(address[] addrs)
309     onlyOwner
310     public
311   {
312     for (uint256 i = 0; i < addrs.length; i++) {
313       addAddressToWhitelist(addrs[i]);
314     }
315   }
316 
317   /**
318    * @dev remove an address from the whitelist
319    * @param addr address
320    * @return true if the address was removed from the whitelist,
321    * false if the address wasn't in the whitelist in the first place
322    */
323   function removeAddressFromWhitelist(address addr)
324     onlyOwner
325     public
326   {
327     removeRole(addr, ROLE_WHITELISTED);
328     emit WhitelistedAddressRemoved(addr);
329   }
330 
331   /**
332    * @dev remove addresses from the whitelist
333    * @param addrs addresses
334    * @return true if at least one address was removed from the whitelist,
335    * false if all addresses weren't in the whitelist in the first place
336    */
337   function removeAddressesFromWhitelist(address[] addrs)
338     onlyOwner
339     public
340   {
341     for (uint256 i = 0; i < addrs.length; i++) {
342       removeAddressFromWhitelist(addrs[i]);
343     }
344   }
345 
346 }
347 
348 
349 /**
350  * @title ERC20Basic
351  * @dev Simpler version of ERC20 interface
352  * @dev see https://github.com/ethereum/EIPs/issues/179
353  */
354 contract ERC20Basic {
355   function totalSupply() public view returns (uint256);
356   function balanceOf(address who) public view returns (uint256);
357   function transfer(address to, uint256 value) public returns (bool);
358   event Transfer(address indexed from, address indexed to, uint256 value);
359 }
360 
361 
362 /**
363  * @title ERC20 interface
364  * @dev see https://github.com/ethereum/EIPs/issues/20
365  */
366 contract ERC20 is ERC20Basic {
367   function allowance(address owner, address spender) public view returns (uint256);
368   function transferFrom(address from, address to, uint256 value) public returns (bool);
369   function approve(address spender, uint256 value) public returns (bool);
370   event Approval(address indexed owner, address indexed spender, uint256 value);
371 }
372 
373 
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure.
377  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
378  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
379  */
380 library SafeERC20 {
381   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
382     require(token.transfer(to, value));
383   }
384 
385   function safeTransferFrom(
386     ERC20 token,
387     address from,
388     address to,
389     uint256 value
390   )
391     internal
392   {
393     require(token.transferFrom(from, to, value));
394   }
395 
396   function safeApprove(ERC20 token, address spender, uint256 value) internal {
397     require(token.approve(spender, value));
398   }
399 }
400 
401 
402 contract PresaleSecond is Ownable {
403     using SafeMath for uint256;
404     using SafeERC20 for ERC20;
405 
406     uint256 public maxcap;      // sale hardcap
407     uint256 public exceed;      // indivisual hardcap
408     uint256 public minimum;     // indivisual softcap
409     uint256 public rate;        // exchange rate
410 
411     bool public paused = false;   // is sale paused?
412     bool public ignited = false;  // is sale started?
413     uint256 public weiRaised = 0; // check sale status
414 
415     address public wallet;      // wallet for withdrawal
416     address public distributor; // contract for release, refund
417     Whitelist public List;      // whitelist
418     ERC20 public Token;         // token
419 
420     constructor (
421         uint256 _maxcap,
422         uint256 _exceed,
423         uint256 _minimum,
424         uint256 _rate,
425         address _wallet,
426         address _distributor,
427         address _whitelist,
428         address _token
429     )
430         public
431     {
432         require(_wallet != address(0));
433         require(_whitelist != address(0));
434         require(_distributor != address(0));
435         require(_token != address(0));
436 
437         maxcap = _maxcap;
438         exceed = _exceed;
439         minimum = _minimum;
440         rate = _rate;
441 
442         wallet = _wallet;
443         distributor = _distributor;
444 
445         Token = ERC20(_token);
446         List = Whitelist(_whitelist);
447     }
448 
449     /* fallback function */
450     function () external payable {
451         collect();
452     }
453 
454 //  address
455     event Change(address _addr, string _name);
456 
457     function setWhitelist(address _whitelist) external onlyOwner {
458         require(_whitelist != address(0));
459 
460         List = Whitelist(_whitelist);
461         emit Change(_whitelist, "whitelist");
462     }
463 
464     function setDistributor(address _distributor) external onlyOwner {
465         require(_distributor != address(0));
466 
467         distributor = _distributor;
468         emit Change(_distributor, "distributor");
469 
470     }
471 
472     function setWallet(address _wallet) external onlyOwner {
473         require(_wallet != address(0));
474 
475         wallet = _wallet;
476         emit Change(_wallet, "wallet");
477     }
478 
479 //  sale controller
480     event Pause();
481     event Resume();
482     event Ignite();
483     event Extinguish();
484 
485     function pause() external onlyOwner {
486         paused = true;
487         emit Pause();
488     }
489 
490     function resume() external onlyOwner {
491         paused = false;
492         emit Resume();
493     }
494 
495     function ignite() external onlyOwner {
496         ignited = true;
497         emit Ignite();
498     }
499 
500     function extinguish() external onlyOwner {
501         ignited = false;
502         emit Extinguish();
503     }
504 
505 //  collect eth
506     event Purchase(address indexed _buyer, uint256 _purchased, uint256 _refund, uint256 _tokens);
507 
508     mapping (address => uint256) public buyers;
509 
510     function collect() public payable {
511         address buyer = msg.sender;
512         uint256 amount = msg.value;
513 
514         require(ignited && !paused);
515         require(List.whitelist(buyer));
516         require(buyer != address(0));
517         require(buyers[buyer].add(amount) >= minimum);
518         require(buyers[buyer] < exceed);
519         require(weiRaised < maxcap);
520 
521         uint256 purchase;
522         uint256 refund;
523 
524         (purchase, refund) = getPurchaseAmount(buyer, amount);
525 
526         weiRaised = weiRaised.add(purchase);
527 
528         if(weiRaised >= maxcap) ignited = false;
529 
530         buyers[buyer] = buyers[buyer].add(purchase);
531         emit Purchase(buyer, purchase, refund, purchase.mul(rate));
532 
533         buyer.transfer(refund);
534     }
535 
536 //  util functions for collect
537     function getPurchaseAmount(address _buyer, uint256 _amount)
538         private
539         view
540         returns (uint256, uint256)
541     {
542         uint256 d1 = maxcap.sub(weiRaised);
543         uint256 d2 = exceed.sub(buyers[_buyer]);
544 
545         uint256 d = (d1 > d2) ? d2 : d1;
546 
547         return (_amount > d) ? (d, _amount.sub(d)) : (_amount, 0);
548     }
549 
550 //  finalize
551     bool public finalized = false;
552 
553     function finalize() external onlyOwner {
554         require(!ignited && !finalized);
555 
556         withdrawEther();
557         withdrawToken();
558 
559         finalized = true;
560     }
561 
562 //  release & release
563     event Release(address indexed _to, uint256 _amount);
564     event Refund(address indexed _to, uint256 _amount);
565 
566     function release(address _addr)
567         external
568         returns (bool)
569     {
570         require(!ignited && !finalized);
571         require(msg.sender == distributor); // only for distributor
572         require(_addr != address(0));
573 
574         if(buyers[_addr] == 0) return false;
575 
576         uint256 releaseAmount = buyers[_addr].mul(rate);
577         buyers[_addr] = 0;
578 
579         Token.safeTransfer(_addr, releaseAmount);
580         emit Release(_addr, releaseAmount);
581 
582         return true;
583     }
584 
585     // 어떤 모종의 이유로 환불 절차를 밟아야 하는 경우를 상정하여 만들어놓은 안전장치입니다.
586     // This exists for safety when we have to run refund process by some reason.
587     function refund(address _addr)
588         external
589         returns (bool)
590     {
591         require(!ignited && !finalized);
592         require(msg.sender == distributor); // only for distributor
593         require(_addr != address(0));
594 
595         if(buyers[_addr] == 0) return false;
596 
597         uint256 refundAmount = buyers[_addr];
598         buyers[_addr] = 0;
599 
600         _addr.transfer(refundAmount);
601         emit Refund(_addr, refundAmount);
602 
603         return true;
604     }
605 
606 //  withdraw
607     event WithdrawToken(address indexed _from, uint256 _amount);
608     event WithdrawEther(address indexed _from, uint256 _amount);
609 
610     function withdrawToken() public onlyOwner {
611         require(!ignited);
612         Token.safeTransfer(wallet, Token.balanceOf(address(this)));
613         emit WithdrawToken(wallet, Token.balanceOf(address(this)));
614     }
615 
616     function withdrawEther() public onlyOwner {
617         require(!ignited);
618         wallet.transfer(address(this).balance);
619         emit WithdrawEther(wallet, address(this).balance);
620     }
621 }